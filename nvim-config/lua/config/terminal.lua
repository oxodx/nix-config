local M = {}
local buffer
local previous_window

-- Keep the shell alive when the panel is hidden.
function M.toggle()
  if buffer and vim.api.nvim_buf_is_valid(buffer) then
    local window = vim.fn.bufwinid(buffer)
    if window ~= -1 then
      vim.api.nvim_win_hide(window)
      if previous_window and vim.api.nvim_win_is_valid(previous_window) then
        vim.api.nvim_set_current_win(previous_window)
      end
      return
    end
  end

  previous_window = vim.api.nvim_get_current_win()
  vim.cmd("botright 12split")
  if buffer and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_win_set_buf(0, buffer)
  else
    buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buffer)
    vim.bo[buffer].bufhidden = "hide"
    vim.fn.jobstart(vim.o.shell, { term = true })
  end
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.cmd("startinsert")
end

return M
