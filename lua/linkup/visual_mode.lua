local M = {}

function M.is_on()
  return vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode())
end

function M.get_text()
  local _, srow, scol = unpack(vim.fn.getpos("v"))
  local _, erow, ecol = unpack(vim.fn.getpos("."))

  local lines = {}
  if vim.fn.mode() == "v" then -- Visual characterwise mode
    if srow < erow or (srow == erow and scol <= ecol) then
      lines = vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      lines = vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  elseif vim.fn.mode() == "V" then -- Visual line mode
    if srow > erow then
      lines = vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  elseif vim.fn.mode() == "\22" then -- Visual block mode
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(
          0,
          i - 1,
          math.min(scol - 1, ecol),
          i - 1,
          math.max(scol - 1, ecol),
          {}
        )[1]
      )
    end
  end
  return table.concat(lines, " ")
end

return M
