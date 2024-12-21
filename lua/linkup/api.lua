local M = {}

function M.search(query, depth, output_type, callback)
  local config = require("linkup.config")
  local curl = require("plenary.curl")

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

return M
