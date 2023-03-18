local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		file_ignore_patterns = { ".git/", "node_modules" },
		mappings = {
			i = {
				["<Down>"] = actions.cycle_history_next,
				["<Up>"] = actions.cycle_history_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
		layout_config = {
			prompt_position = "top",
			width = 0.99,
			height = 0.99,
		},
		sorting_strategy = "ascending",
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),
		},
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
	-- pickers = {
	-- 	buffers = {
	-- 		sort_lastused = true,
	-- 	},
	-- },
})
telescope.load_extension("ui-select")
telescope.load_extension("fzf")
