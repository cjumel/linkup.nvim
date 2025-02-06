local api = require("linkup.api")
local config = require("linkup.config")

local M = {}

function M.setup(opts)
  config.setup(opts)

  if config.api_key == nil then
    error("Linkup API key not found.")
  end
end

function M.standard_search()
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  vim.ui.input({ prompt = "Linkup Standard Search" }, function(input)
    if input ~= nil and input ~= "" then
      api.search(input, "standard", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

function M.deep_search()
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  vim.ui.input({ prompt = "Linkup Deep Search" }, function(input)
    if input ~= nil and input ~= "" then
      api.search(input, "deep", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

return M
