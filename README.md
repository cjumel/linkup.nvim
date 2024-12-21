# linkup.nvim

Integrate the [Linkup](https://www.linkup.so/) API directly in Neovim. The Linkup API provides
access to LLM-augmented web search wich additional access to Linkup premium sources.

## Installation

To install the plugin, you can use your favorite plugin manager, for example
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cjumel/linkup.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ls",
      function() require("linkup").standard_search() end,
      mode = { "n", "v" },
      desc = "[L]inkup: [S]tandard search",
    },
    {
      "<leader>ld",
      function() require("linkup").deep_search() end,
      mode = { "n", "v" },
      desc = "[L]inkup: [D]eep search",
    },
  },
  opts = {}
}
```

<details>
<summary>Default configuration</summary>

```lua
{
  -- The Linkup API key. If nil, the plugin will try to use the environment variable LINKUP_API_KEY.
  api_key = nil,
  -- The Linkup API base URL.
  base_url = "https://api.linkup.so/v1",
}
```

</details>
