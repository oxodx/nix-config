{
  lib,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [deadnix statix jdk21 maven gradle];

  extraConfigLua = ''
    vim.lsp.config("pyright", {
      before_init = function(_, config)
        local venv_python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
        if venv_python and vim.fn.executable(venv_python) == 1 then
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = venv_python
        end
      end,
    })
  '';

  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd = {
          enable = true;
          settings = {
            formatting.command = ["${lib.getExe pkgs.alejandra}"];
            nixpkgs.expr = ''(builtins.getFlake "/home/oxod/dev/nix-config").inputs.nixpkgs.legacyPackages.x86_64-linux'';
            options.nixos.expr = ''(builtins.getFlake "/home/oxod/dev/nix-config").nixosConfigurations.oxod-laptop.options'';
          };
        };

        jdtls = {
          enable = true;
          settings.java = {
            completion.favoriteStaticMembers = [
              "org.junit.jupiter.api.Assertions.*"
              "org.mockito.Mockito.*"
              "java.util.Objects.requireNonNull"
            ];
            configuration.updateBuildConfiguration = "interactive";
            contentProvider.preferred = "fernflower";
            eclipse.downloadSources = true;
            maven.downloadSources = true;
            implementationsCodeLens.enabled = true;
            referencesCodeLens.enabled = true;
            signatureHelp.enabled = true;
          };
        };

        yamlls = {
          enable = true;
          settings = {
            schemaStore = {
              enable = false;
              url = "";
            };
          };
        };

        # Golang
        gopls = {
          enable = true;
          autostart = true;
        };

        # Lua
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        # Rust
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };

        # Spellcheck
        harper_ls = {
          enable = true;
          settings = {
            "harper-ls" = {
              linters = {
                boring_words = true;
                linking_verbs = true;
                # Rarely useful with coding
                sentence_capitalization = false;
                spell_check = false;
              };
              codeActions.forceStable = true;
            };
          };
        };

        ts_ls.enable = true; # TS/JS
        cssls.enable = true; # CSS
        tailwindcss.enable = true; # TailwindCSS
        html.enable = true; # HTML
        astro.enable = true; # AstroJS
        phpactor.enable = true; # PHP
        svelte.enable = false; # Svelte
        pyright.enable = true; # Python
        nil_ls.enable = false; # nixd is configured above
        dockerls.enable = true; # Docker
        bashls.enable = true; # Bash
        clangd.enable = true; # C/C++
        csharp_ls.enable = true; # C#
        markdown_oxide.enable = true; # Markdown
      };

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code action";
          };
          K = {
            action = "hover";
            desc = "Hover documentation";
          };
          "<C-k>" = {
            action = "signature_help";
            desc = "Signature help";
          };
        };
      };
    };
  };
}
