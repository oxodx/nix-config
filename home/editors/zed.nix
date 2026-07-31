{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "tokyo-night"
      "catppuccin-icons"
      "nix"
      "toml"
      "rust"
    ];

    userSettings = {
      # For information on how to configure Zed, see the Zed
      # documentation: https://zed.dev/docs/configuring-zed
      #
      # To see all of Zed's default settings without changing your
      # custom settings, run the `open default settings` command
      # from the command palette or from `Zed` application menu.
      #
      # Full reference: https://zed.dev/docs/reference/all-settings
      # Visual customization: https://zed.dev/docs/visual-customization
      # Key bindings: https://zed.dev/docs/key-bindings
      # Themes: https://zed.dev/docs/themes

      # UI font family (for menus, panels, etc.)
      # https://zed.dev/docs/reference/all-settings#ui-font-family
      ui_font_family = "JetBrainsMono Nerd Font";

      # Whether to colorize matching brackets (rainbow brackets)
      # https://zed.dev/docs/reference/all-settings#colorize-brackets
      colorize_brackets = true;

      # Whether and how to display code lenses from language servers
      # https://zed.dev/docs/reference/all-settings#code-lens
      code_lens = "menu";

      # Editor toolbar settings
      # https://zed.dev/docs/reference/all-settings#editor-toolbar
      toolbar.code_actions = true;

      # Whether to show signature help after completion or bracket pair inserted
      # https://zed.dev/docs/reference/all-settings#show-signature-help-after-edits
      show_signature_help_after_edits = false;

      # Show method signatures when inside parentheses
      # https://zed.dev/docs/reference/all-settings#auto-signature-help
      auto_signature_help = false;

      # Hide variable values in private files (e.g., .env, .pem)
      # https://zed.dev/docs/reference/all-settings#redact-private-values
      redact_private_values = true;

      # Default behavior for opening files via CLI
      # https://zed.dev/docs/reference/all-settings#cli-default-open-behavior
      cli_default_open_behavior = "existing_window";

      # Session settings
      # https://zed.dev/docs/reference/all-settings#session
      session.trust_all_worktrees = true;

      # Git settings
      # https://zed.dev/docs/reference/all-settings#git
      git.inline_blame.enabled = true;

      # Status bar settings
      # https://zed.dev/docs/reference/all-settings#status-bar
      status_bar = {
        show_active_file = false;
        experimental.show = false;
      };

      # Gutter settings
      # https://zed.dev/docs/reference/all-settings#gutter
      gutter.line_numbers = true;

      # Cursor shape: bar, block, underline, hollow
      # https://zed.dev/docs/reference/all-settings#cursor-shape
      cursor_shape = "bar";

      # Whether the cursor blinks
      # https://zed.dev/docs/reference/all-settings#cursor-blink
      cursor_blink = true;

      # Use macOS native window tabs
      # https://zed.dev/docs/reference/all-settings#use-system-tabs
      use_system_window_tabs = true;

      # Show whitespace characters: all, selection, none, boundary
      # https://zed.dev/docs/reference/all-settings#show-whitespaces
      show_whitespaces = "none";

      # Use tab characters instead of spaces
      # https://zed.dev/docs/reference/all-settings#hard-tabs
      hard_tabs = true;

      # Git panel settings
      # https://zed.dev/docs/reference/all-settings#git-panel
      git_panel = {
        collapse_untracked_diff = true;
        show_count_badge = true;
        diff_stats = true;
        file_icons = true;
        tree_view = true;
        dock = "right";
      };

      # Icon theme settings
      # https://zed.dev/docs/reference/all-settings#icon-theme
      icon_theme = {
        mode = "dark";
        light = "Catppuccin Mocha";
        dark = "Catppuccin Mocha";
      };

      # Base keymap: VSCode, Atom, JetBrains, SublimeText, TextMate, None
      # https://zed.dev/docs/key-bindings#predefined-keymaps
      base_keymap = "VSCode";

      # Theme settings
      # https://zed.dev/docs/themes
      theme = {
        mode = "dark";
        light = "Tokyo Night Storm";
        dark = "Tokyo Night";
      };

      # UI font size (for menus, panels, etc.)
      # https://zed.dev/docs/reference/all-settings#ui-font-size
      ui_font_size = 16;

      # Editor buffer font size
      # https://zed.dev/docs/reference/all-settings#buffer-font-size
      buffer_font_size = 17.5;

      # Finder model width
      # https://zed.dev/docs/reference/all-settings#file-finder
      file_finder.modal_max_width = "medium";

      # Buffer font family (editor font)
      # https://zed.dev/docs/reference/all-settings#buffer-font-family
      buffer_font_family = "JetBrainsMono Nerd Font";

      # Vim mode settings
      # https://zed.dev/docs/reference/all-settings#vim
      vim_mode = false;

      # Vim settings (empty = use defaults)
      # https://zed.dev/docs/reference/all-settings#vim
      vim = { };

      # Which-key (vim keybinding helper) settings
      # https://zed.dev/docs/visual-customization#vim-mode
      which_key = {
        delay_ms = 500;
        enabled = true;
      };

      # Use relative line numbers in gutter
      # https://zed.dev/docs/reference/all-settings#relative-line-numbers
      relative_line_numbers = "enabled";

      # Auto-save after delay (matches nvim's autowrite behavior)
      # https://zed.dev/docs/reference/all-settings#autosave
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      # Editor vertical scroll margin (nvim's scrolloff=4)
      # Lines to keep above/below cursor
      # https://zed.dev/docs/reference/all-settings#vertical-scroll-margin
      vertical_scroll_margin = 4;

      # Editor horizontal scroll margin (nvim's sidescrolloff=8)
      # Columns to keep left/right of cursor
      # https://zed.dev/docs/reference/all-settings#horizontal-scroll-margin
      horizontal_scroll_margin = 8;

      # Confirm before quitting with unsaved changes (nvim's confirm=true)
      # https://zed.dev/docs/reference/all-settings#confirm-quit
      confirm_quit = true;

      # Tab bar settings
      # https://zed.dev/docs/reference/all-settings#editor-tab-bar
      tab_bar.show = true;

      # Scrollbar settings
      # https://zed.dev/docs/reference/all-settings#editor-scrollbar
      scrollbar.show = "never";

      # Only show error on tab
      # https://zed.dev/docs/reference/all-settings#editor-tabs
      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "errors";
      };

      # Indentation guides (rainbow indentation)
      # https://zed.dev/docs/reference/all-settings#indent-guides
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };

      # Ident Size
      # https://zed.dev/docs/reference/all-settings#indent-size
      tab_size = 2;

      # Zen mode / centered layout
      # https://zed.dev/docs/reference/all-settings#centered-layout
      centered_layout = {
        left_padding = 0.15;
        right_padding = 0.15;
      };

      # Inlay hints (parameter names, types, etc.)
      # https://zed.dev/docs/reference/all-settings#inlay-hints
      # Preconfigured for: Go, Rust, TypeScript, Svelte
      inlay_hints.enabled = true;

      # Language-specific settings
      # https://zed.dev/docs/configuring-languages#language-specific-settings
      #
      # Base profile shared by most languages (TypeScript, JavaScript inherit as-is):
      #   show_whitespaces: "all", show_edit_predictions: true,
      #   hard_tabs: true, format_on_save: "on",
      #   inlay_hints: { enabled: true, show_parameter_hints: false,
      #                  show_other_hints: true, show_type_hints: true }
      #
      # Only overrides from the base are listed below.
      languages = {
        # Python — ruff formatter, ty type-checker
        # https://zed.dev/docs/languages/python
        Python = {
          formatter = {
            language_server = {
              name = "ruff";
            };
          };
          language_servers = [
            "ty"
            "ruff"
            "!basedpyright"
            "!pyrefly"
            "!pyright"
            "!pylsp"
          ];
        };

        # Rust — spaces + rust-analyzer formatter
        # https://zed.dev/docs/languages/rust
        Rust = {
          hard_tabs = false;
          formatter = {
            language_server = {
              name = "rust-analyzer";
            };
          };
          language_servers = [
            "rust-analyzer"
            "!rustc"
          ];
        };

        # Go — gopls formatter
        # https://zed.dev/docs/languages/go
        Go = {
          formatter = {
            language_server = {
              name = "gopls";
            };
          };
          language_servers = [
            "gopls"
            "!goimports"
          ];
        };

        # Markdown — no format_on_save, preferred line length
        # https://zed.dev/docs/languages/markdown
        Markdown = {
          format_on_save = "off";
          preferred_line_length = 80;
        };

        # JSON — spaces, no formatter override
        # https://zed.dev/docs/languages/json
        JSON = {
          hard_tabs = false;
        };
      };

      # Terminal settings
      # https://zed.dev/docs/reference/all-settings#terminal
      terminal = {
        show_count_badge = true;
        font_size = 17.0;
        font_family = "JetBrainsMono Nerd Font Nerd Font";
        env = {
          EDITOR = "zed --wait";
        };
      };

      # File type associations
      # https://zed.dev/docs/configuring-languages#file-associations
      file_types = {
        Dockerfile = [
          "Dockerfile"
          "Dockerfile.*"
        ];
        JSON = [
          "json"
          "jsonc"
          "*.code-snippets"
        ];
      };

      # File scan exclusions (files to hide from file explorer and search)
      # https://zed.dev/docs/reference/all-settings#file-scan-exclusions
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        # Above is default from Zed
        "**/out"
        "**/dist"
        "**/.husky"
        "**/.turbo"
        "**/.vscode-test"
        "**/.vscode"
        "**/.next"
        "**/.storybook"
        "**/.tap"
        "**/.nyc_output"
        "**/report"
        "**/node_modules"
      ];

      # Telemetry settings
      # https://zed.dev/docs/reference/all-settings#telemetry
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      # Project panel settings
      # https://zed.dev/docs/reference/all-settings#project-panel
      project_panel = {
        hide_root = true;
        git_status_indicator = true;
        diagnostic_badges = true;
        show_diagnostics = "errors";
        auto_fold_dirs = false;
        button = true;
        dock = "right";
        git_status = true;
      };

      # Outline panel settings
      # https://zed.dev/docs/reference/all-settings#outline-panel
      outline_panel = {
        dock = "right";
      };

      # Collaboration panel settings
      # https://zed.dev/docs/reference/all-settings#collaboration-panel
      collaboration_panel = {
        dock = "right";
      };

      # Auto update
      # https://zed.dev/docs/reference/all-settings#auto-update
      auto_update = false;

      # Hour format
      # https://zed.dev/docs/reference/all-settings#hour-format
      hour_format = "hour24";

      # Direnv integration
      # https://zed.dev/docs/reference/all-settings#direnv-integration
      load_direnv = "shell_hook";
    };
  };
}
