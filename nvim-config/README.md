# Neovim config

A standalone Neovim configuration, moved out of a NixOS/NixVim setup. It runs on Linux, macOS,
and Windows. Plugins come from lazy.nvim, and language servers come from Mason, so nothing needs Nix.

## What you get

- Catppuccin Mocha theme, lualine, bufferline, which-key, indent guides
- neo-tree file explorer, Telescope fuzzy finder (with fzf when available)
- Treesitter highlighting and indentation
- blink.cmp completion, LuaSnip snippets, and the full set of snippets from the original setup
- LSP for about twenty languages (installed through Mason), with formatting through conform.nvim
- Git: gitsigns, and lazygit inside Neovim
- The same keymaps as before (see below)

## Requirements

- **Neovim 0.11 or newer.** The config uses `vim.lsp.config` and `winborder`.
- **git**, for lazy.nvim to clone plugins.
- **ripgrep** (`rg`), for Telescope's live grep.
- **fd**, for file search (optional, but recommended).
- **A C compiler and make**, for Treesitter parsers and the fzf extension. On Linux, gcc or clang
  and make. On Windows, Visual Studio Build Tools or zig, and make if you have it.
- **A Nerd Font** in your terminal, so the icons show.
- **JDK 21**, if you want Java (jdtls). Other languages do not need it.

Installing the tools:

- Arch: `sudo pacman -S neovim git ripgrep fd make base-devel`
- Debian/Ubuntu: `sudo apt install neovim git ripgrep fd-find make build-essential`
  (on Debian the binary is `fdfind`; add a symlink `fd` if you want the same name)
- Windows: `winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd`

## Install

Linux or macOS:

    ./install.sh

Windows (PowerShell):

    .\install.ps1

Both installers move any existing Neovim config aside first, so nothing is lost. Start `nvim`.
lazy.nvim installs the plugins on the first start. Run `:Mason` to see the language servers, and
`:checkhealth` to check everything.

## Layout

    init.lua                 entry point
    lua/config/options.lua   editor options and diagnostics settings
    lua/config/lazy.lua      lazy.nvim bootstrap
    lua/config/keymaps.lua   keymaps (leader is Space)
    lua/config/autocmds.lua  autocommands, including the LSP keymaps
    lua/plugins/*.lua        one file per area: ui, editor, explorer, telescope,
                             treesitter, completion, lsp, format
    custom-snippets/         SnipMate snippets, loaded by LuaSnip

## Keymaps (leader = Space)

| Keys | Action |
| --- | --- |
| `<leader>e` | Toggle the file explorer |
| `<leader>ff` / `fg` / `fb` / `fh` / `fr` | Find files / text / buffers / help / recent files |
| `<leader>gg` | Lazygit |
| `<leader>xx` | Diagnostics list |
| `<leader>cf` | Format the buffer |
| `<leader>co` | Organize imports |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>/` | Toggle comment (normal and visual) |
| `<leader>bd` | Delete buffer |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-h/j/k/l>` | Move between windows |
| `<leader>q` | Quit (asks before closing unsaved buffers) |
| `gd` `gr` `gD` `gI` `gT` `K` `<C-k>` | Language server: definition, references, declaration, implementation, type, hover, signature |
| `[d` / `]d` | Previous / next diagnostic |
| `J` / `K` (visual) | Move the selection down / up |

Press Space and wait to see the rest in the which-key menu.

## Language servers and tools

Servers are installed by Mason and listed in `lua/plugins/lsp.lua`. Add or remove one there, or
use `:Mason`. Formatters are in `lua/plugins/format.lua`, and Mason installs stylua, shfmt,
prettier, yapf, and clang-format.

QML (Quickshell) support uses `qmlls` when it is on your PATH. Set `QML_IMPORT_PATH` to a
colon-separated list of QML module directories, and `qmlls` gets them with `-I`.

## What was left out from the Nix version

- **nixd and the Nix formatter (alejandra)**: they were tied to the NixOS flake. Add them back on
  NixOS if you still want them.
- **nvim-lint for Nix (deadnix, statix)**: same reason.
- **Paths to your flake**: the nixd settings pointed at `/home/oxod/dev/nix-config`. They are gone.
- **The Nix-generated plugin lock**: plugin versions now come from lazy.nvim. Pin them with
  `lazy-lock.json` if you want reproducible installs.

## Troubleshooting

- **A language server does not start**: run `:Mason`, check it is installed, then `:LspInfo`.
- **Treesitter parsers fail to build**: you are missing a C compiler. See Requirements.
- **Telescope has no fzf speed-up**: install make and reopen Neovim, which rebuilds the extension.
- **Icons look like boxes**: your terminal needs a Nerd Font.
