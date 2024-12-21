local M = {}

function M.setup(opts)
  local config = require("linkup.config")
  config.setup(opts)

  if config.api_key == nil then
    error("Linkup API key not found.")
  end
end

function M.standard_search()
  local config = require("linkup.config")
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  local visual_mode = require("visual_mode")
  local text = ""
  if visual_mode.is_on() then
    text = visual_mode.get_text()
  end

  local api = require("linkup.api")
  vim.ui.input({ prompt = "Linkup Standard Search", default = text }, function(input)
    if input ~= nil and input ~= "" then
      api.search(input, "standard", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

function M.deep_search()
  local config = require("linkup.config")
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  local visual_mode = require("visual_mode")
  local text = ""
  if visual_mode.is_on() then
    text = visual_mode.get_text()
  end

  local api = require("linkup.api")
  vim.ui.input({ prompt = "Linkup Deep Search", default = text }, function(input)
    if input ~= nil and input ~= "" then
      api.search(input, "deep", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

return M
