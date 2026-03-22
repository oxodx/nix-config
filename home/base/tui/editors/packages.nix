{ pkgs, pkgs-master, ... }:
{
  home.packages =
    with pkgs;
    (
      [
        nil
        nixd
        statix
        deadnix
        nixfmt

        nickel

        terraform-ls
        jsonnet
        jsonnet-language-server
        taplo
        yaml-language-server
        actionlint

        hadolint
        dockerfile-language-server

        marksman
        glow
        pkgs-master.hugo

        sqlfluff

        buf
      ]
      ++ [
        cmake
        cmake-language-server
        gnumake
        checkmake
        gcc
        gdb
        clang-tools
        lldb
        vscode-extensions.vadimcn.vscode-lldb.adapter

        uv
        pipx
        (python313.withPackages (
          ps: with ps; [
            pyright
            ruff

            black

            jupyter
            ipython
            pandas
            requests
            pyquery
            pyyaml
            boto3

            protobuf
            numpy
          ]
        ))

        pkgs-master.rustc
        pkgs-master.rust-analyzer
        pkgs-master.cargo
        pkgs-master.rustfmt
        pkgs-master.clippy

        go
        gomodifytags
        iferr
        impl
        gotools
        gopls
        delve

        jdk17
        gradle
        maven
        spring-boot-cli
        jdt-language-server

        zls

        stylua
        lua-language-server

        bash-language-server
        shellcheck
        shfmt
      ]
      ++ [
        nodejs_24
        pnpm
        typescript
        typescript-language-server
        bun
        vscode-langservers-extracted
        tailwindcss-language-server
        emmet-ls
      ]
      ++ [
        proselint
        verible
        prettier
        fzf
        gdu
        (ripgrep.override { withPCRE2 = true; })
      ]
    );
}
