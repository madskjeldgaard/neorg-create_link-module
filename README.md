# A module for Neorg

This is a module for Neorg that allows you to easily create folders, .norg files, and insert links to these files directly in your Neorg documents using a prompt.

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
-- Prompt for path and create link
keybinds.map("norg", "n", "<leader>cl", 
    "<cmd>Neorg keybind norg external.integrations.create_link.create_and_link<cr>")
```
