# A module for Neorg

This is a module for Neorg that allows you to easily create folders, .norg files, and insert links to these files directly in your Neorg documents using a prompt or based on visual selection.

## Installation

Install using packer:

```lua
use "madskjeldgaard/neorg-create_link-module"

```

## Configuration

In the `load` section of your neorg module, as a minimum add `["external.integrations.create_link"] = {}`, and fill out the config options:

```lua
require('neorg').setup({
	load = {
		["external.integrations.create_link"] = {
			config = {
			}
		},
		["core.defaults"] = {}, -- Loads default behaviour
...
    })
```

This will expose a keymap to the `keymap` part of your neorg setup. Use it like this:

```lua
-- When in normal mode and using this keymapping: Prompt for path and create link
-- When in visual mode and using this keymapping: Create a link from the selected text
keybinds.map("norg", {"n", "v"}, "<leader>cl", 
    "<cmd>Neorg keybind norg external.integrations.create_link.create_and_link<cr>")
```
