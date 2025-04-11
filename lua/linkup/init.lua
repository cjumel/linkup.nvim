local curl = require("plenary.curl")

local M = {}

---@class linkup.Config
---@field api_key? string The Linkup API key. If nil, the plugin will try to use the environment
--- variable LINKUP_API_KEY.
---@field base_url string The Linkup API base URL.
local config = {
  api_key = nil,
  base_url = "https://api.linkup.so/v1",
}

--- Setup the linkup.nvim plugin.
---@param opts linkup.Config The options to pass to the plugin.
function M.setup(opts)
  opts = opts or {}
  local new_config = vim.tbl_extend("force", config, opts)
  if new_config["api_key"] == nil then
    new_config["api_key"] = os.getenv("LINKUP_API_KEY")
  end
  for k, v in pairs(new_config) do
    config[k] = v
  end
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  vim.api.nvim_create_user_command(
    "LinkupStandardSearch",
    M.standard_search,
    { desc = "Perform a standard search with the Linkup API" }
  )
  vim.api.nvim_create_user_command(
    "LinkupDeepSearch",
    M.deep_search,
    { desc = "Perform a deep search with the Linkup API" }
  )
  vim.api.nvim_create_user_command(
    "LinkupViewLastQuerySources",
    M.view_last_query_sources,
    { desc = "View the sources of the last query" }
  )
end

--- Call the Linkup API.
---@param query string The query to perform.
---@param depth string The type of query to perform.
---@param output_type string The type of output to require.
---@param callback fun(response: table): nil The function to call once the API has been called.
local function linkup(query, depth, output_type, callback)
  curl.post(config.base_url .. "/search", {
    headers = {
      ["Authorization"] = "Bearer " .. config.api_key,
      ["Content-Type"] = "application/json",
    },
    body = vim.json.encode({
      q = query,
      depth = depth,
      outputType = output_type,
    }),
    callback = function(response)
      local body = vim.json.decode(response.body)
      if body["error"] then
        local message = body["error"]
          .. " ("
          .. body["statusCode"]
          .. ") - "
          .. table.concat(body["message"], " ")
        vim.notify(message, vim.log.levels.WARN, { title = "linkup.nvim" })
      end
      callback(body)
    end,
  })
end

--- Perform a standard search on the Linkup API.
function M.standard_search()
  vim.ui.input({ prompt = "Linkup Standard Search" }, function(input)
    if input ~= nil and input ~= "" then
      linkup(input, "standard", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "linkup.nvim" })
        vim.g._linkup_last_query_sources = response.sources
      end)
    end
  end)
end

--- Perform a deep search on the Linkup API.
function M.deep_search()
  vim.ui.input({ prompt = "Linkup Deep Search" }, function(input)
    if input ~= nil and input ~= "" then
      linkup(input, "deep", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "linkup.nvim" })
        vim.g._linkup_last_query_sources = response.sources
      end)
    end
  end)
end

function M.view_last_query_sources()
  if vim.g._linkup_last_query_sources == nil then
    vim.notify("No previous query found.", vim.log.levels.WARN, { title = "linkup.nvim" })
    return
  end
  vim.notify(vim.g._linkup_last_query_sources, vim.log.levels.INFO, { title = "linkup.nvim" })
end

return M
