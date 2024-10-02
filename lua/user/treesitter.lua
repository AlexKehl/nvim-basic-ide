local ts_utils = require("nvim-treesitter.ts_utils")

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

local M = {}

configs.setup({
	ensure_installed = { "tsx", "lua", "rust", "typescript", "javascript" },
	ignore_install = { "" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
	-- context_commentstring = {
	-- 	enable = true,
	-- 	enable_autocmd = false,
	-- 	config = {
	-- 		typescript = { __default = "// %s", __multiline = "/* %s */" },
	-- 	},
	-- },
	highlight = {
		enable = true,

		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	-- incremental_selection = {
	-- 	enable = true,
	-- 	keymaps = {
	-- 		node_incremental = "v",
	-- 		node_decremental = "<C-v>",
	-- 	},
	-- },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["id"] = "@conditional.inner",
				["ad"] = "@conditional.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = "@function.outer",
				["]a"] = "@parameter.outer",
				["]d"] = "@conditional.outer",
				["]b"] = "@block.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[a"] = "@parameter.outer",
				["[d"] = "@conditional.outer",
				["[b"] = "@block.outer",
			},
		},
	},
})

local function is_import_statement(node)
	while node do
		local type = node:type()
		if type == "import_statement" or type == "import_declaration" then
			return true
		end
		node = node:parent()
	end
	return false
end

local function is_current_node(buf, node)
  if buf ~= vim.fn.bufnr() then
    return false
  end

  return node:start() == ts_utils.get_node_at_cursor():start()
end

M.filter_references_with_treesitter = function(references)
	local filtered_references = {}
	for _, reference in ipairs(references) do
		local escaped_path = vim.uri_to_fname(reference.user_data.uri)
		local buf = vim.fn.bufnr(escaped_path)

		if buf == -1 then
			goto continue
		end

		local node = vim.treesitter.get_node({
			bufnr = buf,
			pos = {
				reference.user_data.range.start.line,
				reference.user_data.range.start.character,
			},
			lang = "typescript",
		})

    if (is_current_node(buf, node)) then
      goto continue
    end

		if not node or not is_import_statement(node) then
			table.insert(filtered_references, reference)
		end

		::continue::
	end

	return filtered_references
end

return M
