local curl = require("plenary.curl")

local M = {}

local config = {
  -- The Linkup API key. If nil, the plugin will try to use the environment variable LINKUP_API_KEY.
  api_key = nil,
  -- The Linkup API base URL.
  base_url = "https://api.linkup.so/v1",
}

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
end

local function linkup(query, depth, output_type, callback)
  local headers = {
    ["Authorization"] = "Bearer " .. config.api_key,
    ["Content-Type"] = "application/json",
  }
  local data = vim.json.encode({
    q = query,
    depth = depth,
    outputType = output_type,
  })

  return curl.post(config.base_url .. "/search", {
    headers = headers,
    body = data,
    callback = function(response)
      local body = vim.json.decode(response.body)
      if body["error"] then
        local message = body["error"]
          .. " ("
          .. body["statusCode"]
          .. ") - "
          .. table.concat(body["message"], " ")
        vim.notify(message, vim.log.levels.WARN, { title = "Linkup" })
      end
      callback(body)
    end,
  })
end

function M.standard_search()
  if config.api_key == nil then
    error("Linkup API key not found.")
  end

  vim.ui.input({ prompt = "Linkup Standard Search" }, function(input)
    if input ~= nil and input ~= "" then
      linkup(input, "standard", "sourcedAnswer", function(response)
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
      linkup(input, "deep", "sourcedAnswer", function(response)
        vim.notify(response.answer, vim.log.levels.INFO, { title = "Linkup" })
      end)
    end
  end)
end

return M
