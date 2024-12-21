local default_config = {
  -- The Linkup API key. If nil, the plugin will try to use the environment variable LINKUP_API_KEY.
  api_key = nil,
  -- The Linkup API base URL.
  base_url = "https://api.linkup.so/v1",
}

local M = vim.deepcopy(default_config)

function M.setup(opts)
  opts = opts or {}

  local new_config = vim.tbl_extend("force", default_config, opts)
  if new_config["api_key"] == nil then
    new_config["api_key"] = os.getenv("LINKUP_API_KEY")
  end

  for k, v in pairs(new_config) do
    M[k] = v
  end
end

return M
