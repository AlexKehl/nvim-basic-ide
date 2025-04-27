return {
	provider = "copilot",
	copilot = {
		model = "claude-3.5-sonnet",
	},
	behaviour = {
		auto_suggestions = false, -- Experimental stage
		auto_set_highlight_group = true,
		auto_set_keymaps = false,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
		minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		enable_token_counting = true, -- Whether to enable token counting. Default to true.
		enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
		enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
	},
	mappings = {
		ask = {},
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		cancel = {
			normal = { "<C-c>", "<Esc>", "q" },
			insert = { "<C-c>" },
		},
		sidebar = {
			apply_all = "A",
			apply_cursor = "a",
			retry_user_request = "r",
			edit_user_request = "e",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
			remove_file = "d",
			add_file = "@",
			close = { "<Esc>", "q" },
			close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
		},
	},
}
