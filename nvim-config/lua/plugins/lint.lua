-- Nix diagnostics supplement nixd's syntax/type diagnostics.
return {
  {
    "mfussenegger/nvim-lint",
    ft = "nix",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { nix = { "statix", "deadnix" } }
      local function lint_nix()
        if vim.bo.filetype ~= "nix" or vim.bo.buftype ~= "" then
          return
        end
        local available = vim.tbl_filter(function(name)
          return vim.fn.executable(name) == 1
        end, lint.linters_by_ft.nix)
        if #available > 0 then
          lint.try_lint(available)
        end
      end
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nix_lint", { clear = true }),
        callback = lint_nix,
      })
      lint_nix()
    end,
  },
}
