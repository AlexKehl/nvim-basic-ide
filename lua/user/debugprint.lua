local js_like = {
	left = 'console.log("',
	right = '")',
	-- left_var = "",
	-- mid_var = "",
	-- right_var = "",
}

return {
	keymaps = {
		normal = {
			plain_below = "<leader>ej",
			plain_above = "<leader>ek",
			variable_below = "<leader>ew",
			-- variable_above = "g?V",
			variable_below_alwaysprompt = "",
			variable_above_alwaysprompt = "",
			textobj_below = "<leader>ee",
			textobj_above = "g?O",
			toggle_comment_debug_prints = "",
			delete_debug_prints = "<leader>ed",
		},
		insert = {
			plain = "<C-G>p",
			variable = "<C-G>v",
		},
		visual = {
			variable_below = "<leader>e",
			variable_above = "g?V",
		},
	},
	commands = {
		toggle_comment_debug_prints = "ToggleCommentDebugPrints",
		delete_debug_prints = "DeleteDebugPrints",
		reset_debug_prints_counter = "ResetDebugPrintsCounter",
	},
	filetypes = {
		["javascript"] = js_like,
		["javascriptreact"] = js_like,
		["typescript"] = js_like,
		["typescriptreact"] = js_like,
	},
	print_tag = "",
	display_counter = false,
	display_location = false,
	display_snippet = false,
	notify_for_registers = false,
	highlight_lines = false,
}
