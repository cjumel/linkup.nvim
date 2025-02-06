# linkup.nvim

Integrate the [Linkup API](https://www.linkup.so/) directly in Neovim. The Linkup API provides
access to LLM-augmented web search, as well as to Linkup's premium sources.

## Installation

To install the plugin, you can use your favorite plugin manager, for example
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "LinkupStandardSearch", "LinkupDeepSearch" },
  opts = {},
}
```

<details>
<summary>Default configuration</summary>

```lua
{
  ---@type string|nil The Linkup API key. If nil, the plugin will try to use the environment
  --- variable LINKUP_API_KEY.
  api_key = nil,
  ---@type string The Linkup API base URL.
  base_url = "https://api.linkup.so/v1",
}
```

</details>
