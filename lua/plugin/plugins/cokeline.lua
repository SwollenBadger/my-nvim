return {
  "willothy/nvim-cokeline",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",     -- Required for v0.4.0+
    "nvim-tree/nvim-web-devicons", -- If you want devicons
    "moll/vim-bbye",
  },
  keys = {
    {
      "<leader>bd",
      function()
        require("core.util").buf_kill("Bdelete")
      end,
    },
    { "<S-h>", "<Plug>(cokeline-focus-prev)",  { silent = true } },
    { "<S-l>", "<Plug>(cokeline-focus-next)",  { silent = true } },
    { "<C-h>", "<Plug>(cokeline-switch-prev)", { silent = true } },
    { "<C-l>", "<Plug>(cokeline-switch-next)", { silent = true } },
  },
  config = true,
  opts = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    local separator = {
      text = " ",
      truncation = { priority = 1 },
      fg = function(buffer)
        return buffer.is_focused and mocha.overlay0 or mocha.surface0
      end,
    }

    local dev_icon = {
      text = function(buffer)
        return "" .. buffer.devicon.icon
      end,
      fg = function(buffer)
        return buffer.devicon.color
      end,
    }

    local filename = {
      text = function(buffer)
        return (buffer.is_readonly and buffer.unique_prefix .. buffer.filename .. " 󰌾 ")
            or buffer.unique_prefix .. buffer.filename .. " "
      end,
      fg = function(buffer)
        return (buffer.is_readonly and mocha.overlay0) or (buffer.is_focused and mocha.text) or mocha.overlay0
      end,
      bold = function(buffer)
        return buffer.is_focused
      end,
    }

    local diagnostics_error = {
      text = function(buffer)
        return (buffer.diagnostics.errors ~= 0 and " ") or ""
      end,
      fg = mocha.red,
    }

    local diagnostics_warning = {
      text = function(buffer)
        return (buffer.diagnostics.warnings ~= 0 and "󱧡 ") or ""
      end,
      fg = mocha.yellow,
    }

    local diagnostics_info = {
      text = function(buffer)
        return (buffer.diagnostics.infos ~= 0 and "󰌵 ") or ""
      end,
      fg = mocha.blue,
    }

    local diagnostics_hint = {
      text = function(buffer)
        return (buffer.diagnostics.hints ~= 0 and "󰛨 ") or ""
      end,
      fg = mocha.green,
    }

    local modified_status = {
      text = function(buffer)
        return (buffer.is_modified and " " or "") or ""
      end,
      fg = mocha.peach,
    }

    local close_button = {
      text = "  ",
      delete_buffer_on_left_click = true,
      fg = function(buffer)
        return buffer.is_focused and mocha.text or mocha.overlay0
      end,
    }
    --[[ local function harpoon_sorter() ]]
    --[[ 	-- local harpoon = require("harpoon.mark") ]]
    --[[ 	local cache = {} ]]
    --[[]]
    --[[ 	local function marknum(buf, force) ]]
    --[[ 		local b = cache[buf.number] ]]
    --[[ 		if b == nil or force then ]]
    --[[ 			b = harpoon.get_index_of(buf.path) ]]
    --[[ 			cache[buf.number] = b ]]
    --[[ 		end ]]
    --[[ 		return b ]]
    --[[ 	end ]]
    --[[]]
    --[[ 	harpoon.on("changed", function() ]]
    --[[ 		for _, buf in ipairs(require("cokeline.buffers").get_visible()) do ]]
    --[[ 			cache[buf.number] = marknum(buf, true) ]]
    --[[ 		end ]]
    --[[ 	end) ]]
    --[[]]
    --[[ 	---@type a Buffer ]]
    --[[ 	---@type b Buffer ]]
    --[[ 	-- Use this in `config.buffers.new_buffers_position` ]]
    --[[ 	return function(a, b) ]]
    --[[ 		local ma = marknum(a) ]]
    --[[ 		local mb = marknum(b) ]]
    --[[ 		if ma and not mb then ]]
    --[[ 			return true ]]
    --[[ 		elseif mb and not ma then ]]
    --[[ 			return false ]]
    --[[ 		elseif ma == nil and mb == nil then ]]
    --[[ 			-- switch the a and b.index to place non-harpoon buffers on the left ]]
    --[[ 			-- side of the tabline - this puts them on the right. ]]
    --[[ 			ma = a._valid_index ]]
    --[[ 			mb = b._valid_index ]]
    --[[ 		end ]]
    --[[ 		return ma < mb ]]
    --[[ 	end ]]
    --[[ end ]]

    return {
      show_if_buffers_are_at_least = 0,

      buffers = {
        filter_valid = function(buffer)
          return buffer.filename ~= "[No Name]"
        end,
        -- new_buffers_position = harpoon_sorter(),
      },
      default_hl = {
        bg = "none",
      },
      components = {
        separator,
        dev_icon,
        filename,
        modified_status,
        diagnostics_error,
        diagnostics_warning,
        diagnostics_info,
        diagnostics_hint,
        close_button,
      },
      sidebar = {
        filetype = { "NvimTree", "neo-tree" },
        components = {
          {
            text = " File Tree",
            style = "bold",
            fg = mocha.mauve,
            bg = mocha.mantle,
          },
        },
      },
    }
  end,
}
