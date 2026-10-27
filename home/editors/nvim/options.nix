{...}: {
  globalOpts = {
    number = true;
    relativenumber = true;
    cursorline = true;
    signcolumn = "yes";
    termguicolors = true;

    mouse = "a";
    clipboard = "unnamedplus";
    undofile = true;
    swapfile = false;
    backup = false;
    confirm = true;

    ignorecase = true;
    smartcase = true;
    inccommand = "split";
    hlsearch = true;

    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;
    smartindent = true;
    breakindent = true;

    splitbelow = true;
    splitright = true;
    scrolloff = 8;
    sidescrolloff = 8;
    wrap = false;

    completeopt = ["menuone" "noselect"];
    updatetime = 250;
    timeoutlen = 1000;
    winborder = "rounded";

    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
  };

  diagnostic.settings = {
    severity_sort = true;
    update_in_insert = false;
    virtual_text = {
      spacing = 2;
      source = "if_many";
    };
    float = {
      border = "rounded";
      source = true;
    };
  };

  autoCmd = [
    {
      event = "TextYankPost";
      desc = "Highlight copied text";
      callback.__raw = "function() vim.highlight.on_yank({ timeout = 150 }) end";
    }
    {
      event = "BufReadPost";
      desc = "Return to the last edit position";
      callback.__raw = ''
        function(args)
          local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
          local lines = vim.api.nvim_buf_line_count(args.buf)
          if mark[1] > 0 and mark[1] <= lines then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
  ];
}
