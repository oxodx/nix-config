local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Files and search
map("n", "<leader>e", "<cmd>Neotree toggle reveal<cr>", "Explorer")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", "Find files")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Find text")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", "Find buffers")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Find help")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent files")

-- Git and diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")

-- Formatting and code actions
map("n", "<leader>cf", function()
  require("conform").format({ async = false, lsp_format = "fallback", timeout_ms = 5000 }, function(err)
    if err then
      vim.notify("Formatting failed: " .. err, vim.log.levels.ERROR)
    end
  end)
end, "Format")

map("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, "Organize imports")

map({ "n", "v" }, "<leader>/", "gcc", "Toggle comment", { remap = true })

-- Buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", "Next buffer")

-- Windows
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")

-- Editing
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search")
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")
map("v", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move selection up")
map("n", "<leader>q", "<cmd>confirm qa<cr>", "Quit Neovim")
