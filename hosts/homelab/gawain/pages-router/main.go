package main

import (
	"context"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"regexp"
	"strings"
	"sync"
	"time"
)

var validUser = regexp.MustCompile(`^[A-Za-z0-9_.-]+$`)

type cacheEntry struct {
	exists  bool
	expires time.Time
}

type userDirectory struct {
	baseURL *url.URL
	client  *http.Client
	mu      sync.Mutex
	cache   map[string]cacheEntry
}

func (directory *userDirectory) exists(ctx context.Context, user string) bool {
	if !validUser.MatchString(user) {
		return false
	}

	now := time.Now()
	directory.mu.Lock()
	entry, cached := directory.cache[strings.ToLower(user)]
	directory.mu.Unlock()
	if cached && now.Before(entry.expires) {
		return entry.exists
	}

	requestURL := directory.baseURL.JoinPath("api", "v1", "users", user)
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, requestURL.String(), nil)
	if err != nil {
		return false
	}

	response, err := directory.client.Do(request)
	if err != nil {
		log.Printf("Forgejo user lookup for %q failed: %v", user, err)
		return false
	}
	response.Body.Close()

	exists := response.StatusCode == http.StatusOK
	directory.mu.Lock()
	directory.cache[strings.ToLower(user)] = cacheEntry{
		exists:  exists,
		expires: now.Add(5 * time.Minute),
	}
	directory.mu.Unlock()
	return exists
}

type route struct {
	user string
	path string
}

func selectRoute(path string, userExists func(string) bool) route {
	clean := strings.TrimPrefix(path, "/")
	parts := strings.Split(clean, "/")
	if clean == "" || len(parts) < 2 || !userExists(parts[0]) {
		return route{user: "oxod", path: path}
	}

	return route{
		user: parts[0],
		path: "/" + strings.Join(parts[1:], "/"),
	}
}

type routeKey struct{}

func main() {
	forgejoURL, err := url.Parse("http://127.0.0.1:3001/")
	if err != nil {
		log.Fatal(err)
	}
	pagesURL, err := url.Parse("http://127.0.0.1:3003/")
	if err != nil {
		log.Fatal(err)
	}

	directory := &userDirectory{
		baseURL: forgejoURL,
		client:  &http.Client{Timeout: 2 * time.Second},
		cache:   make(map[string]cacheEntry),
	}

	proxy := &httputil.ReverseProxy{
		Rewrite: func(request *httputil.ProxyRequest) {
			routed := request.In.Context().Value(routeKey{}).(route)
			request.SetURL(pagesURL)
			request.SetXForwarded()
			request.Out.URL.Path = routed.path
			request.Out.URL.RawPath = ""
			request.Out.Host = routed.user + ".oxod.nl"
			request.Out.Header.Set("X-Forwarded-Host", request.In.Host)
			request.Out.Header.Set("X-Forwarded-Proto", "https")
		},
		ErrorHandler: func(writer http.ResponseWriter, _ *http.Request, proxyErr error) {
			log.Printf("Pages proxy failed: %v", proxyErr)
			http.Error(writer, "Pages service unavailable", http.StatusBadGateway)
		},
	}

	handler := http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		routed := selectRoute(request.URL.Path, func(user string) bool {
			return directory.exists(request.Context(), user)
		})
		ctx := context.WithValue(request.Context(), routeKey{}, routed)
		proxy.ServeHTTP(writer, request.WithContext(ctx))
	})

	server := &http.Server{
		Addr:              "127.0.0.1:3005",
		Handler:           handler,
		ReadHeaderTimeout: 10 * time.Second,
		IdleTimeout:       90 * time.Second,
	}
	log.Printf("Pages router ready on %s", server.Addr)
	log.Fatal(server.ListenAndServe())
}
