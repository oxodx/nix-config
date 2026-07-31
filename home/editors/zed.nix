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
      vim_mode = true;

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

    userKeymaps = [
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
        bindings = {
          # Git
          "space g h d" = "editor::ToggleSelectedDiffHunks";
          "space g s" = "git_panel::ToggleFocus";
          # Toggle inlay hints
          "space t i" = "editor::ToggleInlayHints";
          # Toggle soft wrap
          "space u w" = "editor::ToggleSoftWrap";
          # NOTE: Toggle Zen mode, partially with nvim plugin like no-neck-pain
          "space c z" = "workspace::ToggleCenteredLayout";
          # Open markdown preview
          "space m p" = "markdown::OpenPreview";
          "space m P" = "markdown::OpenPreviewToTheSide";
          # Open recent project
          "space f p" = "projects::OpenRecent";
          # Search word under cursor
          "space s w" = "pane::DeploySearch";
          # Search on current buffer
          "space s b" = "buffer_search::Deploy";
          # Chat with AI — inline assists (editor buffer)
          "space a i" = "assistant::InlineAssist";
          # Agent panel (chat panel)
          "space a c" = "agent::ToggleFocus";
          "space a n" = "agent::NewThread";
          "space a m" = "agent::ToggleModelSelector";
          "space a s" = "agent::OpenSettings";
          "space a a" = "agent::OpenProjectAGENTS.mdRules";
          "space a d" = "agent::OpenAgentDiff";
          # Go to file with `gf`
          "g f" = "editor::OpenExcerpts";
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          # put key-bindings here if you want them to work only in normal mode
          # Ctrl hjkl to move between panes
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
          # LSP
          "space c a" = "editor::ToggleCodeActions";
          "space ." = "editor::ToggleCodeActions";
          "space c r" = "editor::Rename";
          "space c f" = "editor::Format";
          "g d" = "editor::GoToDefinition";
          "g D" = "editor::GoToDefinitionSplit";
          "g i" = "editor::GoToImplementation";
          "g I" = "editor::GoToImplementationSplit";
          "g t" = "editor::GoToTypeDefinition";
          "g T" = "editor::GoToTypeDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          "] d" = "editor::GoToDiagnostic";
          "[ d" = "editor::GoToPreviousDiagnostic";
          # Next/prev error
          "] e" = [
            "editor::GoToDiagnostic"
            { "severity" = "error"; }
          ];
          "[ e" = [
            "editor::GoToPreviousDiagnostic"
            { "severity" = "error"; }
          ];
          # Next/prev warning
          "] w" = [
            "editor::GoToDiagnostic"
            { "severity" = "warning"; }
          ];
          "[ w" = [
            "editor::GoToPreviousDiagnostic"
            { "severity" = "warning"; }
          ];
          # Next/prev hint
          "] H" = [
            "editor::GoToDiagnostic"
            { "severity" = "hint"; }
          ];
          "[ H" = [
            "editor::GoToPreviousDiagnostic"
            { "severity" = "hint"; }
          ];
          # Symbol search
          "s s" = "outline::Toggle";
          "s S" = "project_symbols::Toggle";
          # Diagnostic
          "space x x" = "diagnostics::Deploy";
          # Git
          # Git prev/next hunk
          "] h" = "editor::GoToHunk";
          "[ h" = "editor::GoToPreviousHunk";
          # Git project diff
          "space g d" = "git::Diff";
          # Toggle inline blame
          "space g b" = "editor::ToggleGitBlameInline";
          # Expand all diff hunks
          "space g h e" = "editor::ExpandAllDiffHunks";
          # Buffers
          # Switch between buffers
          "shift-h" = "pane::ActivatePreviousItem";
          "shift-l" = "pane::ActivateNextItem";
          # Close active panel
          "shift-q" = "pane::CloseActiveItem";
          "ctrl-q" = "pane::CloseActiveItem";
          "space b d" = "pane::CloseActiveItem";
          # Buffer switch alias
          "space b b" = "pane::ActivatePreviousItem";
          # Close other items
          "space b o" = "pane::CloseOtherItems";
          # Save file
          "ctrl-s" = "workspace::Save";
          # File finder
          "space space" = "file_finder::Toggle";
          # Project search
          "space /" = "pane::DeploySearch";
          # Show project panel with current file
          "space e" = "pane::RevealInProjectPanel";
          # Move lines up/down
          "alt-k" = "editor::MoveLineUp";
          "alt-j" = "editor::MoveLineDown";
          # Buffer prev/next aliases
          "[b" = "pane::ActivatePreviousItem";
          "]b" = "pane::ActivateNextItem";
          # Window management
          "space w w" = "workspace::ActivatePreviousPane";
          "space w -" = "pane::SplitDown";
          "space w |" = "pane::SplitRight";
          # New file
          "space f n" = "workspace::NewFile";
          # Quit all
          "space q q" = "workspace::CloseWindow";
          # Window resize
          "ctrl-shift-k" = "vim::ResizePaneUp";
          "ctrl-shift-j" = "vim::ResizePaneDown";
          "ctrl-shift-h" = "vim::ResizePaneLeft";
          "ctrl-shift-l" = "vim::ResizePaneRight";
          # Close active buffer
          "space w d" = "pane::CloseActiveItem";
        };
      }
      # Empty pane, set of keybindings that are available when there is no active editor
      {
        context = "EmptyPane || SharedScreen";
        bindings = {
          # Open file finder
          "space space" = "file_finder::Toggle";
          # Open recent project
          "space f p" = "projects::OpenRecent";
          # Open AI chat
          "space a c" = "agent::ToggleFocus";
          # Git status
          "space g s" = "git_panel::ToggleFocus";
        };
      }
      # Comment code
      {
        context = "Editor && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          # visual, visual line & visual block modes
          "g c" = "editor::ToggleComments";
          # Inline assists (selection required — runs in editor buffer)
          "space a e" = [
            "assistant::InlineAssist"
            { prompt = "Explain the selected code. Cover purpose, control flow, and non-obvious behavior."; }
          ];
          "space a f" = [
            "assistant::InlineAssist"
            { prompt = "Fix bugs and issues in the selected code. Identify root causes, not just symptoms."; }
          ];
          "space a t" = [
            "assistant::InlineAssist"
            {
              prompt = "Generate focused unit tests for the selected code. Use the project's test framework and conventions. Output with arrange/act/assert sections.";
            }
          ];
          "space a r" = [
            "assistant::InlineAssist"
            {
              prompt = "Refactor the selected code for clarity and maintainability without changing external behavior. Extract functions, simplify conditions, remove duplication.";
            }
          ];
          "space a d" = [
            "assistant::InlineAssist"
            {
              prompt = "Add concise inline documentation comments to the selected code without changing logic.";
            }
          ];
          "space a k" = [
            "assistant::InlineAssist"
            { prompt = "Summarize the selected code. One-paragraph summary plus key takeaways."; }
          ];
          "space a n" = "agent::NewThread";
          # Focus agent panel, attach visual selection — sidekick `<leader>av`
          "space a v" = [
            "action::Sequence"
            [
              "agent::ToggleFocus"
              "agent::AddSelectionToThread"
            ]
          ];
        };
      }
      # Better escape
      {
        context = "Editor && vim_mode == insert && !menu";
        bindings = {
          "j j" = "vim::NormalBefore"; # remap jj in insert mode to escape
          "j k" = "vim::NormalBefore"; # remap jk in insert mode to escape
        };
      }
      # Rename
      {
        context = "Editor && vim_operator == c";
        bindings = {
          "c" = "vim::CurrentLine";
          "r" = "editor::Rename"; # zed specific
        };
      }
      # Code Action
      {
        context = "Editor && vim_operator == c";
        bindings = {
          "c" = "vim::CurrentLine";
          "a" = "editor::ToggleCodeActions"; # zed specific
        };
      }
      # Toggle terminal
      {
        context = "Workspace";
        bindings = {
          "ctrl-\\" = "terminal_panel::ToggleFocus";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      # File panel (netrw)
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "a" = "project_panel::NewFile";
          "A" = "project_panel::NewDirectory";
          "r" = "project_panel::Rename";
          "d" = "project_panel::Delete";
          "x" = "project_panel::Cut";
          "c" = "project_panel::Copy";
          "p" = "project_panel::Paste";
          # Close project panel as project file panel on the right
          "q" = "workspace::ToggleRightDock";
          "space e" = "workspace::ToggleRightDock";
          # Navigate between panel
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      # Panel navigation
      {
        context = "Dock";
        bindings = {
          "ctrl-w h" = "workspace::ActivatePaneLeft";
          "ctrl-w l" = "workspace::ActivatePaneRight";
          "ctrl-w k" = "workspace::ActivatePaneUp";
          "ctrl-w j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "Workspace";
        bindings = {
          # Map VSCode like keybindings
          "cmd-b" = "workspace::ToggleRightDock";
        };
      }
      # Run nearest task
      {
        context = "EmptyPane || SharedScreen || vim_mode == normal";
        bindings = {
          "space r t" = [
            "editor::SpawnNearestTask"
            { reveal = "no_focus"; }
          ];
        };
      }
      # Sneak motion, refer https://github.com/zed-industries/zed/pull/22793/files#diff-90c0cb07588e2f309c31f0bb17096728b8f4e0bad71f3152d4d81ca867321c68
      {
        context = "vim_mode == normal || vim_mode == visual";
        bindings = {
          "s" = [
            "vim::PushSneak"
            { }
          ];
          "S" = [
            "vim::PushSneakBackward"
            { }
          ];
        };
      }
    ];
  };
}
