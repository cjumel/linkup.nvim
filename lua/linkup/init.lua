local M = {}

function M.setup(opts)
  local config = require("linkup.config")
  config.setup(opts)
end

local function is_visual_mode()
  return vim.tbl_contains({ "v", "V", "\22" }, vim.fn.mode())
end

local function get_visual_selection()
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

function M.standard_search()
  local api = require("linkup.api")

  local text = ""
  if is_visual_mode() then
    text = get_visual_selection()
  end

  vim.ui.input({ prompt = "Linkup Standard Search", default = text }, function(input)
    if input ~= "" then
      api.search(input, "standard", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

function M.deep_search()
  local api = require("linkup.api")

  local text = ""
  if is_visual_mode() then
    text = get_visual_selection()
  end

  vim.ui.input({ prompt = "Linkup Deep Search", default = text }, function(input)
    if input ~= "" then
      api.search(input, "deep", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

return M
