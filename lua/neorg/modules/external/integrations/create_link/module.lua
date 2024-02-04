local neorg = require('neorg.core')

local module = neorg.modules.create('external.integrations.create_link')

module.setup = function()
  return {
    success = true,
    requires = { "core.neorgcmd", "core.keybinds", "core.ui" },
  }
end

local function get_visual_selection()
  local vstart = vim.fn.getpos([['<]])
  local vend = vim.fn.getpos([['>]])
  local line_start = vstart[2]
  local line_end = vend[2]
  -- or use api.nvim_buf_get_lines
  local lines = vim.fn.getline(line_start, line_end)

  return table.concat(lines, "\n")
end

module.create_and_link = function(relativePath)
  local visuallySelected = false

  -- Use visual selection if relativePath is nil or empty
  if not relativePath or relativePath == "" then
    relativePath = get_visual_selection()
    visuallySelected = true
  end

  -- Parsing folder and filename
  local folderPath, fileName = relativePath:match("^(.-)/([^/]-)$")

  folderPath = folderPath or ""
  fileName = fileName or ""

  if not folderPath and not fileName then
    print("Invalid path")
    return
  end

  -- Create folder if it doesn't exist
  local fullFolderPath = vim.fn.expand('%:p:h') .. '/' .. folderPath
  if vim.fn.isdirectory(fullFolderPath) == 0 then
    vim.fn.mkdir(fullFolderPath, 'p')
  end

  -- Create file if it doesn't exist
  local fullFilePath = fullFolderPath .. '/' .. fileName .. '.norg'
  if vim.fn.filereadable(fullFilePath) == 0 then
    local file = io.open(fullFilePath, 'w')
    file:close()
  end

  -- Insert link in current buffer
  local linkText = "{:$/" .. relativePath .. ":}[" .. relativePath .. "]"

  if visuallySelected then
    -- Delete the visual selection
    vim.cmd("'<,'>d _")
  end

  vim.api.nvim_put({ linkText }, "c", true, true)
end

module.load = function()
  module.required["core.keybinds"].register_keybind(module.name, "create_and_link")
end

module.on_event = function(event)
  if event.type == "core.keybinds.events.external.integrations.create_link.create_and_link" then
    -- Check if we have visual selection
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == "\\<C-v>" then
      -- We have visual selection, use it directly
      local selectedText = get_visual_selection()
      vim.cmd("normal! <Esc>") -- Exit visual mode
      module.create_and_link(selectedText)
    else
      -- No visual selection, prompt the user for input
      module.required["core.ui"].create_prompt("NeorgCreateAndLink", "Enter Path: ", function(text)
        -- Close popup
        vim.cmd("q")

        -- Create folder, file and insert link
        module.create_and_link(text)
      end, {
        center_x = true,
        center_y = true,
      }, {
        width = 30,
        height = 1,
        row = 10,
        col = 0,
      })
    end
  end
end

module.events.subscribed = {
  ["core.keybinds"] = {
    ["external.integrations.create_link.create_and_link"] = true,
  },
}

return module
