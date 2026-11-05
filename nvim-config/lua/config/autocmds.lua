local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Remove trailing whitespace on save, without moving the cursor.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  desc = "Remove trailing whitespace",
  callback = function(args)
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd([[keeppatterns %s/\s\+$//e]])
    end)
    vim.fn.winrestview(view)
  end,
})

-- Python uses two-space indentation.
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = augroup("python_indent"),
  desc = "Use two-space indentation for Python",
  callback = function(args)
    if vim.bo[args.buf].filetype == "python" then
      vim.bo[args.buf].expandtab = true
      vim.bo[args.buf].tabstop = 2
      vim.bo[args.buf].softtabstop = 2
      vim.bo[args.buf].shiftwidth = 2
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  desc = "Highlight copied text",
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Reopen files at the last edit position.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  desc = "Return to the last edit position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Language server keymaps and inlay hints, set once a server attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_attach"),
  desc = "Language server keymaps",
  callback = function(ev)
    local function map(lhs, fn, desc)
      vim.keymap.set("n", lhs, fn, { buffer = ev.buf, silent = true, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("gr", vim.lsp.buf.references, "Goto References")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("gI", vim.lsp.buf.implementation, "Goto Implementation")
    map("gT", vim.lsp.buf.type_definition, "Type Definition")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})
