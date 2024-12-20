local actions = require("fzf-lua.actions")

require("fzf-lua").setup({
	-- fzf_bin         = 'sk',            -- use skim instead of fzf?
	-- https://github.com/skim-rs/skim
	-- can also be set to 'fzf-tmux'
	winopts = {
		-- split         = "belowright new",-- open in a split instead?
		-- "belowright new"  : split below
		-- "aboveleft new"   : split above
		-- "belowright vnew" : split right
		-- "aboveleft vnew   : split left
		-- Only valid when using a float window
		-- (i.e. when 'split' is not defined, default)
		height = 0.99, -- window height
		width = 0.99, -- window width
		row = 0.35, -- window row position (0=top, 1=bottom)
		col = 0.50, -- window col position (0=left, 1=right)
		-- border argument passthrough to nvim_open_win(), also used
		-- to manually draw the border characters around the preview
		-- window, can be set to 'false' to remove all borders or to
		-- 'none', 'single', 'double', 'thicc' (+cc) or 'rounded' (default)
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		-- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
		backdrop = 60,
		-- requires neovim > v0.9.0, passed as is to `nvim_open_win`
		-- can be sent individually to any provider to set the win title
		-- title         = "Title",
		-- title_pos     = "center",    -- 'left', 'center' or 'right'
		fullscreen = false, -- start fullscreen?
		-- enable treesitter highlighting for the main fzf window will only have
		-- effect where grep like results are present, i.e. "file:line:col:text"
		-- due to highlight color collisions will also override `fzf_colors`
		-- set `fzf_colors=false` or `fzf_colors.hl=...` to override
		treesitter = {
			enabled = false,
			fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
		},
		preview = {
			-- default     = 'bat',           -- override the default previewer?
			-- default uses the 'builtin' previewer
			border = "border", -- border|noborder, applies only to
			-- native fzf previewers (bat/cat/git/etc)
			wrap = "nowrap", -- wrap|nowrap
			hidden = "nohidden", -- hidden|nohidden
			vertical = "down:45%", -- up|down:size
			horizontal = "right:60%", -- right|left:size
			layout = "flex", -- horizontal|vertical|flex
			flip_columns = 100, -- #cols to switch to horizontal on flex
			-- Only used with the builtin previewer:
			title = true, -- preview border title (file/buf)?
			title_pos = "center", -- left|center|right, title alignment
			scrollbar = "float", -- `false` or string:'float|border'
			-- float:  in-window floating border
			-- border: in-border "block" marker
			scrolloff = "-2", -- float scrollbar offset from right
			-- applies only when scrollbar = 'float'
			delay = 10, -- delay(ms) displaying the preview
			-- prevents lag on fast scrolling
			winopts = { -- builtin previewer window options
				number = true,
				relativenumber = false,
				cursorline = true,
				cursorlineopt = "both",
				cursorcolumn = false,
				signcolumn = "no",
				list = false,
				foldenable = false,
				foldmethod = "manual",
			},
		},
		on_create = function()
			-- called once upon creation of the fzf main window
			-- can be used to add custom fzf-lua mappings, e.g:
			--   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
		end,
		-- called once _after_ the fzf interface is closed
		-- on_close = function() ... end
	},
	files = {
		cwd_prompt = false,
		-- actions = {
		-- 	["<C-g>"] = { actions.toggle_ignore },
		["<C-h>"] = { actions.toggle_hidden },
		-- },
	},
	-- uncomment to use fzf native previewers
	-- (instead of using a neovim floating window)
	-- manpages = { previewer = "man_native" },
	-- helptags = { previewer = "help_native" },
	--
	-- padding can help kitty term users with double-width icon rendering
	file_icon_padding = "",
	-- uncomment if your terminal/font does not support unicode character
	-- 'EN SPACE' (U+2002), the below sets it to 'NBSP' (U+00A0) instead
	-- nbsp = '\xc2\xa0',
})
