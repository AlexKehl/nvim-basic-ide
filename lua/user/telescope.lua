local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local M = {}

local function fzf_multi_select(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local num_selections = #picker:get_multi_selection()

	if num_selections > 1 then
		-- actions.file_edit throws - context of picker seems to change
		--actions.file_edit(prompt_bufnr)
		actions.send_selected_to_qflist(prompt_bufnr)
		actions.open_qflist()
	else
		actions.file_edit(prompt_bufnr)
	end
end

telescope.setup({
	defaults = {
		file_ignore_patterns = { ".git/", "node_modules" },
		mappings = {
			i = {
				["<Down>"] = actions.cycle_history_next,
				["<Up>"] = actions.cycle_history_prev,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-d>"] = actions.delete_buffer,
				["<C-w>"] = fzf_multi_select,
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
			},
			n = {
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<C-w>"] = fzf_multi_select,
			},
		},
		layout_config = {
			prompt_position = "top",
			width = 0.99,
			height = 0.99,
		},
		sorting_strategy = "ascending",
		sorter = require("telescope.sorters").get_fuzzy_file,
		-- reverser = require("telescope.actions").cycle_history_next,
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
		},
	},
	pickers = {
		buffers = {
			-- ignore_current_buffer = true,
			sort_mru = true,
		},
	},
})

telescope.load_extension("ui-select")
telescope.load_extension("fzf")

M.custom_references_picker = function(items)
	pickers
		.new({}, {
			prompt_title = "LSP References",
			finder = finders.new_table({
				results = items,
				entry_maker = make_entry.gen_from_quickfix({ show_line = false }),
			}),
			previewer = conf.grep_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return M
