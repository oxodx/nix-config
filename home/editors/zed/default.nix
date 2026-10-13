{
  lib,
  pkgs,
  ...
}: let
  configFile = "zed/settings.json";
  languageConfig = import ./settings.nix {inherit pkgs lib;};
  settingsJSON = builtins.toJSON ({
      node = {
        path = "${pkgs.nodejs}/bin/node";
        npm_path = "${pkgs.nodejs}/bin/npm";
      };
      audio = {"experimental.rodio_audio" = true;};
      calls.mute_on_join = true;
      terminal.font_size = 11;
      window_decorations = "client";
      use_system_window_tabs = false;
      tabs.git_status = false;
      title_bar = {
        show_menus = false;
        show_user_picture = false;
        show_user_menu = false;
        show_sign_in = true;
        show_onboarding_banner = false;
        show_project_items = true;
        show_branch_name = true;
        show_branch_icon = false;
      };
      debugger.button = false;
      colorize_brackets = true;
      inlay_hints = {
        show_background = true;
        enabled = true;
      };
      show_whitespaces = "selection";
      gutter.runnables = true;
      indent_guides = {
        background_coloring = "disabled";
        coloring = "fixed";
      };
      relative_line_numbers = "enabled";
      which_key.enabled = true;
      helix_mode = false;
      current_line_highlight = "all";
      hide_mouse = "never";
      multi_cursor_modifier = "cmd_or_ctrl";
      agent_ui_font_size = 15;
      agent_buffer_font_size = 11;
      session.trust_all_worktrees = true;
      redact_private_values = true;
      ui_font_family = "GT Pressura Mono Trial";
      buffer_font_features = {
        calt = true;
        dlig = true;
        liga = true;
        ss13 = true;
        ss15 = true;
      };
      buffer_font_fallbacks = ["Symbols Nerd Font"];
      buffer_font_size = 12;
      scrollbar.show = "never";
      tab_bar.show = false;
      toolbar = {
        agent_review = false;
        quick_actions = false;
      };
      vim_mode = false;
      theme = {
        mode = "system";
        light = "Catppuccin Mocha";
        dark = "Catppuccin Mocha";
      };
      icon_theme = "Catppuccin Mocha";
      project_panel.dock = "right";
      unnecessary_code_fade = 0.9;
      restore_on_startup = "last_session";
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      edit_predictions_disabled_in = ["comments"];
      preview_tabs.enabled = false;
      format_on_save = "on";
      tab_size = 2;
      features.edit_prediction_provider = "copilot";
      agent = {
        play_sound_when_agent_done = false;
        default_profile = "write";
        always_allow_tool_actions = false;
        dock = "right";
        default_model = {
          provider = "openrouter";
          model = "mistralai/devstral-2512:free";
        };
        commit_message_model = {
          provider = "openrouter";
          model = "mistralai/devstral-2512:free";
        };
        thread_summary_model = {
          provider = "openrouter";
          model = "mistralai/devstral-2512:free";
        };
      };
    }
    // languageConfig);
  lspPackages = with pkgs; [
    # Language Server Protocol
    astro-language-server
    biome
    marksman
    nil
    kdePackages.qtdeclarative # qmlls for the QML extension
    tailwindcss-language-server
    vue-language-server
    # Formatters
    alejandra
    oxfmt
    shfmt
    # Node.js (required for Zed LSP node integration)
    nodejs
  ];
  lspBinPath = pkgs.buildEnv {
    name = "zed-lsp-env";
    paths = lspPackages;
    pathsToLink = ["/bin"];
  };
  zedWithLSP = pkgs.symlinkJoin {
    name = "zed-with-lsp";
    paths = [pkgs.zed-editor];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm -rf $out/bin
      mkdir -p $out/bin
      makeWrapper ${pkgs.zed-editor}/bin/zeditor $out/bin/zeditor \
        --prefix PATH : ${lspBinPath}/bin
      for bin in ${pkgs.zed-editor}/bin/*; do
        if [ "$(basename $bin)" != "zeditor" ]; then
          ln -s $bin $out/bin/$(basename $bin)
        fi
      done
    '';
  };
in {
  users.users.oxod.packages = [
    zedWithLSP
  ];
  xdg.configFile."${configFile}" = {
    text = settingsJSON;
    mutable = true;
  };
}
