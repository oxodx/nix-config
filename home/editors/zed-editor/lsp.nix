{pkgs, ...}: {
  # LSP configuration recipes
  # Copy relevant blocks into your settings.json "lsp" section.
  # Docs: https://zed.dev/docs/configuring-languages#configuring-language-servers

  # https://github.com/zed-extensions/nix
  nil = {
    binary = {
      path_lookup = true;
    };
    settings = {
      formatting = {
        command = ["alejandra"];
      };
    };
  };

  # https://zed.dev/docs/languages/rust
  rust-analyzer = {
    initialization_options = {
      checkOnSave = true;
      check = {command = "clippy";};
      cargo = {features = "all";};
      procMacro = {enable = true;};
      inlayHints = {
        bindingModeHints = {enable = true;};
        chainingHints = {enable = true;};
        closingBraceHints = {enable = true;};
        lifetimeElisionHints = {enable = "skip_trivial";};
        typeHints = {enable = true;};
        parameterHints = {enable = true;};
        reborrowHints = {enable = "keep";};
      };
    };
  };

  # https://zed.dev/docs/languages/go
  gopls = {
    initialization_options = {
      gofumpt = true;
      staticcheck = true;
      usePlaceholders = true;
      semanticTokens = true;
      analyses = {
        unusedparams = true;
        unusedwrite = true;
        fieldalignment = true;
        nilness = true;
      };
      hints = {
        assignVariableTypes = true;
        compositeLiteralFields = true;
        compositeLiteralTypes = true;
        constantTypeValues = true;
        functionDocParameters = true;
        parameterNames = true;
        rangeVariableTypes = true;
      };
    };
  };

  # https://zed.dev/docs/languages/javascript
  # https://zed.dev/docs/languages/typescript
  vtsls = {
    settings = {
      typescript = {
        suggest = {
          autoImports = true;
          completeFunctionCalls = true;
        };
        inlayHints = {
          parameterNames = {enabled = "all";};
          parameterTypes = {enabled = true;};
          variableTypes = {enabled = true;};
          returnType = {enabled = true;};
          propertyDeclarationTypes = {enabled = true;};
        };
        preferences = {
          includePackageJsonAutoImports = "on";
          organizeImports = {ignoreCase = false;};
        };
        format = {
          indentSize = 2;
          tabSize = 2;
        };
      };
    };
  };

  # https://zed.dev/docs/languages/cpp
  clangd = {
    binary = {
      path = "${pkgs.clang-tools}/bin/clangd";
      arguments = [];
    };
  };
}
