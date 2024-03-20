vim.api.nvim_create_autocmd("BufWritePost", {
	command = "silent LilyCmp",
	pattern = "*.ly",
})

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	command = "syntax sync fromstart",
-- 	pattern = { "*.ly", "*.ily", "*.tex" },
-- })

require("nvls").setup({
	lilypond = {
		mappings = {
			player = "<leader>p",
			compile = "<leader>c",
			open_pdf = "<leader>o",
			switch_buffers = "<A-Space>",
			insert_version = "<F4>",
			hyphenation = "<F12>",
			hyphenation_change_lang = "<F11>",
			insert_hyphen = "<leader>ih",
			add_hyphen = "<leader>ah",
			del_next_hyphen = "<leader>dh",
			del_prev_hyphen = "<leader>dH",
		},
		options = {
			pitches_language = "default",
			hyphenation_language = "en_DEFAULT",
			output = "pdf",
			backend = nil,
			main_file = "main.ly",
			main_folder = "%:p:h",
			include_dir = nil,
			diagnostics = false,
			pdf_viewer = "skim",
		},
	},
	latex = {
		mappings = {
			compile = "<F5>",
			open_pdf = "<F6>",
			lilypond_syntax = "<F3>",
		},
		options = {
			lilypond_book_flags = nil,
			clean_logs = false,
			main_file = "main.tex",
			main_folder = "%:p:h",
			include_dir = nil,
			lilypond_syntax_au = "BufEnter",
			pdf_viewer = nil,
		},
	},
	texinfo = {
		mappings = {
			compile = "<F5>",
			open_pdf = "<F6>",
			lilypond_syntax = "<F3>",
		},
		options = {
			lilypond_book_flags = "--pdf",
			clean_logs = false,
			main_file = "main.texi",
			main_folder = "%:p:h",
			--include_dir = nil,
			lilypond_syntax_au = "BufEnter",
			pdf_viewer = nil,
		},
	},
	player = {
		mappings = {
			quit = "q",
			play_pause = "p",
			loop = "<A-l>",
			backward = "h",
			small_backward = "<S-h>",
			forward = "l",
			small_forward = "<S-l>",
			decrease_speed = "j",
			increase_speed = "k",
			halve_speed = "<S-j>",
			double_speed = "<S-k>",
		},
		options = {
			row = 1,
			col = "99%",
			width = "37",
			height = "1",
			border_style = "single",
			winhighlight = "Normal:Normal,FloatBorder:Normal",
			midi_synth = "fluidsynth",
			fluidsynth_flags = nil,
			timidity_flags = nil,
			audio_format = nil,
			mpv_flags = {
				"--msg-level=cplayer=no,ffmpeg=no,alsa=no",
				"--loop",
				"--config-dir=/dev/null",
			},
		},
	},
})
