{pkgs, ...}: let
  formatters = {
    alejandra = "${pkgs.alejandra}/bin/alejandra";
    biome = "${pkgs.biome}/bin/biome";
    oxfmt = "${pkgs.oxfmt}/bin/oxfmt";
    shfmt = "${pkgs.shfmt}/bin/shfmt";
  };

  languageServers = {
    astro-ls = "${pkgs.astro-language-server}/bin/astro-ls";
    biome = "${pkgs.biome}/bin/biome";
    marksman = "${pkgs.marksman}/bin/marksman";
    nil = "${pkgs.nil}/bin/nil";
    tailwindcss = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
    volar = "${pkgs.vue-language-server}/bin/vue-language-server";
  };

  # Helper function to create external formatter config
  mkExternalFormatter = command: args: {
    external = {
      inherit command;
      arguments = args;
    };
  };
in {
  languages = {
    YAML = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
    };
    Astro = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.biome ["format" "--stdin-file-path" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["astro-ls" "tailwindcss-language-server"];
    };
    JavaScript = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["biome" "tailwindcss-language-server"];
    };
    JSON = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["biome"];
    };
    Markdown = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["marksman"];
    };
    TypeScript = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["biome" "tailwindcss-language-server"];
    };
    TSX = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["biome" "tailwindcss-language-server"];
    };
    CSS = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["biome" "tailwindcss-language-server"];
    };
    HTML = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["tailwindcss-language-server"];
    };
    "Vue.js" = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.oxfmt ["--stdin-filepath" "{buffer_path}"];
      format_on_save = "on";
      language_servers = ["vue-language-server" "tailwindcss-language-server"];
    };
    Nix = {
      tab_size = 2;
      formatter = mkExternalFormatter formatters.alejandra ["-q"];
      format_on_save = "on";
      language_servers = ["nil"];
    };
  };

  lsp = {
    "astro-language-server" = {
      binary = {
        path = languageServers.astro-ls;
        arguments = ["--stdio"];
      };
    };
    biome = {
      binary = {
        path = languageServers.biome;
        arguments = ["lsp-proxy"];
      };
    };
    nil = {
      binary = {
        path = languageServers.nil;
      };
      initialization_options = {
        formatting = {
          command = [formatters.alejandra "-q"];
        };
      };
    };
    "tailwindcss-language-server" = {
      binary = {
        path = languageServers.tailwindcss;
        arguments = ["--stdio"];
      };
    };
    "vue-language-server" = {
      binary = {
        path = languageServers.volar;
        arguments = ["--stdio"];
      };
    };
  };
}
