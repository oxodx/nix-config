{...}: {
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle reveal<cr>";
      options.desc = "Explorer";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Find text";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Find buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "Find help";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Recent files";
    }

    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options.desc = "Lazygit";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>cf";
      action.__raw = ''
        function()
          require("conform").format({
            async = false,
            lsp_format = "fallback",
            timeout_ms = 5000,
          }, function(err)
            if err then
              vim.notify("Formatting failed: " .. err, vim.log.levels.ERROR)
            end
          end)
        end
      '';
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>co";
      action.__raw = ''
        function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
        end
      '';
      options.desc = "Organize imports";
    }
    {
      mode = ["n" "v"];
      key = "<leader>/";
      action = "gcc";
      options = {
        desc = "Toggle comment";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "Next buffer";
    }

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Window left";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Window down";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Window up";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Window right";
    }

    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear search";
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent left";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent right";
    }
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<cr>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<cr>gv=gv";
      options.desc = "Move selection up";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "vim.diagnostic.goto_prev";
      options.desc = "Previous diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "vim.diagnostic.goto_next";
      options.desc = "Next diagnostic";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>confirm qa<cr>";
      options.desc = "Quit Neovim";
    }
  ];
}
