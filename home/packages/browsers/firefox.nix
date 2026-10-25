{...}: {
  programs.firefox = {
    enable = true;

    preferencesStatus = "user";

    preferences = {
      "browser.contentblocking.category" = "standard";
      "browser.download.deletePrivate" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "devtools.cache.disabled" = true;
      "network.dns.disablePrefetch" = true;
      "network.http.speculative-parallel-limit" = 0;
      "network.prefetch-next" = false;
      "privacy.clearOnShutdown_v2.formdata" = true;
      "sidebar.verticalTabs" = true;
      "signon.rememberSignons" = false;
    };

    policies = {
      SearchEngines.Default = "DuckDuckGo";

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/5034826/ublock_origin-1.75.0.xpi";
        };
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/5055526/proton_pass-1.41.1.xpi";
        };
      };
    };
  };
}
