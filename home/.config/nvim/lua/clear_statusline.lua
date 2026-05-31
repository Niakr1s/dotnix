local M = {}

function M.setup(opts)
  local timeout = opts.timeout or 3000

  -- Auto-clear echo messages after 3 seconds
  local clear_timer = nil

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = ":",
    callback = function()
      if clear_timer then clear_timer:stop() end
      clear_timer = vim.defer_fn(function()
        vim.api.nvim_echo({}, false, {})
        vim.cmd.redrawstatus()
      end, timeout)
    end,
  })
end

return M
