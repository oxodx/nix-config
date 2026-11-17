package main

import "testing"

func TestSelectRoute(t *testing.T) {
	users := map[string]bool{"alice": true, "randomuser": true}
	exists := func(user string) bool { return users[user] }

	tests := []struct {
		name string
		path string
		want route
	}{
		{"root site", "/", route{"oxod", "/"}},
		{"default project", "/nekolauncher", route{"oxod", "/nekolauncher"}},
		{"default project asset", "/nekolauncher/assets/app.js", route{"oxod", "/nekolauncher/assets/app.js"}},
		{"other user project", "/randomuser/randomrepo", route{"randomuser", "/randomrepo"}},
		{"other user asset", "/alice/site/assets/app.js", route{"alice", "/site/assets/app.js"}},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if got := selectRoute(test.path, exists); got != test.want {
				t.Fatalf("selectRoute(%q) = %#v, want %#v", test.path, got, test.want)
			}
		})
	}
}
