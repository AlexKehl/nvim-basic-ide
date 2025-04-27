-- Shorten function name
local keymap = vim.keymap.set

-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- QuickFix window
keymap("n", "]q", "<cmd>cnext<CR>", opts)
keymap("n", "[q", "<cmd>cprev<CR>", opts)

-- Tabs
keymap("n", "<leader>1", "<cmd>tabn 1<CR>", opts)
keymap("n", "<leader>2", "<cmd>tabn 2<CR>", opts)
keymap("n", "<leader>3", "<cmd>tabn 3<CR>", opts)
keymap("n", "<leader>4", "<cmd>tabn 4<CR>", opts)
keymap("n", "<leader>5", "<cmd>tabn 5<CR>", opts)
keymap("n", "<leader>6", "<cmd>tabn 6<CR>", opts)
keymap("n", "<leader>7", "<cmd>tabn 7<CR>", opts)
keymap("n", "<leader>8", "<cmd>tabn 8<CR>", opts)
keymap("n", "<leader>9", "<cmd>tabn 9<CR>", opts)
keymap("n", "<leader>t", "<cmd>tabnew<CR>", opts)

local function eval_on_save()
	if vim.bo.filetype == "clojure" then
		vim.cmd("w")
		vim.cmd("ConjureEvalBuf")
		return
	end
	if vim.bo.filetype == "fennel" then
		vim.cmd("w")
		vim.cmd("ConjureEvalBuf")
		-- vim.cmd("Lazy reload nvim-parinfer")
		return
	end
	return vim.cmd("w")
end

keymap("n", "<leader>eg", [[:ConjureEval (user/reset)<CR>]], opts)
keymap("n", "<leader>et", "<cmd>ConjureCljRunCurrentTest<CR>", opts)
keymap("n", "<leader>ea", [[:ConjureEval (user/run-all-tests)<CR>]], opts)
keymap("n", "<leader>eu", [[:ConjureEval (user/unmap-defs)<CR>]], opts)
-- keymap("n", "<leader>mt", "<cmd>mark T<CR>", opts)
keymap("n", "<leader>mt", function()
	vim.cmd("mark T")
	print("Mark set")
end, opts)
-- keymap("n", "<leader>mm", "<leader>emT", opts)

keymap("n", "<C-y>", function()
	eval = require("conjure.eval")
	marked_form = eval["marked-form"]
	vim.schedule(function()
		marked_form("T")
	end)
end, opts)

-- Quick file operations
keymap("n", "<leader>w", eval_on_save, opts)

keymap("n", "<leader>q", "<cmd>q<CR>", opts)

-- Ranger
-- keymap("n", "<C-p>", "<cmd>RnvimrToggle<CR>", opts)
-- Oil
keymap("n", "<C-p>", "<cmd>Oil<CR>", opts)

-- Clear highlights
keymap("n", "<leader><cr>", "<cmd>nohlsearch<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --
keymap("n", "\\", "<Plug>(comment_toggle_linewise_current)", opts)
keymap("n", "<leader>a", "<cmd>A<CR>", opts)
keymap("n", "<leader>b", "<cmd>Git blame<CR>", opts)
keymap("n", "<leader>ll", "<cmd>diffget //3<CR>", opts)
keymap("n", "<leader>lh", "<cmd>diffget //2<CR>", opts)
-- keymap("n", "<leader>1", "<cmd>diffget<CR>", opts)

-- Misc
-- Behave like Vims other bindings (C, D etc.)
keymap("n", "Y", "y$", opts)

-- Telescope
keymap("n", "<C-f>", ":Telescope find_files<CR>", opts)
keymap("n", "<C-e>", ":Telescope live_grep<CR>", opts)
keymap("n", "§", ":Telescope buffers<CR>", opts)
keymap("n", "<C-n>", ":Telescope command_history<CR>", opts)
keymap("n", "z", ":Telescope oldfiles<CR>", opts)
keymap("n", "<C-q>", ":Telescope diagnostics<CR>", opts)

-- todo
keymap("n", "<leader>d", "<cmd>:e ~/.todo.txt<CR>", opts)

-- Markdown
keymap("n", "<leader>md", ":MarkdownPreviewToggle<CR>", opts)

local function format()
	local filepath = vim.api.nvim_buf_get_name(0)
	if not (filepath == "") then
		vim.cmd([[ FormatWrite]])
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
	end
end

keymap("n", "<CR>", format, opts)

-- music
-- keymap("n", "<tab>", ":LilyPlayer<CR>", opts)

-- in terminal mode map esc <C-\><C-n> to exit terminal mode
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Neotest
keymap("n", "<leader>no", ":lua require('neotest').output.open({ enter = true })<CR>", opts)
keymap("n", "<leader>nw", ":lua require('neotest').watch.toggle()<CR>", opts)
keymap("n", "<leader>ns", ":lua require('neotest').summary.toggle()<CR>", opts)
keymap("n", "<leader>np", ":lua require('neotest').output_panel.toggle()<CR>", opts)
keymap("n", "<leader>nc", ":lua require('neotest').output_panel.clear()<CR>", opts)

-- Text objects for whitespace
keymap("n", "da ", "F df ", opts)
keymap("n", "di ", "T dt ", opts)
keymap("n", "ca ", "F cf ", opts)
keymap("n", "ci ", "T ct ", opts)

keymap("n", "<leader>el", "<cmd>EslintFixAll<CR>", opts)

keymap("n", "<leader>jq", "?%<CR>x:norm v%gJ<CR>V:!jq<CR>", opts)

-- copilot chat
-- keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", opts)
-- keymap("n", "<M-c>", "<cmd>CopilotChatToggle<CR>", opts)
-- keymap("v", "<leader>cc", "<cmd>CopilotChatToggle<CR>", opts)
-- keymap("n", "<leader>ct", "<cmd>CopilotChatTests<CR>", opts)
-- keymap("v", "<leader>ct", "<cmd>CopilotChatTests<CR>", opts)

keymap("n", "<leader>cc", "<cmd>AvanteAsk<CR>", opts)

keymap("n", "<leader>cp", "<cmd>Copilot panel<CR>", opts)
keymap("n", "<leader>cr", ":lua require('copilot.panel').refresh()<CR>", opts)

vim.keymap.set("n", "<leader>ch", function()
	vim.cmd("TSC")
	vim.cmd("TSCOpen")
end, opts)

vim.keymap.set("n", "<leader>cl", function()
	vim.cmd("silent! TSCStop")
	vim.cmd("ccl")
end, opts)

-- Substitute
vim.keymap.set("n", "m", ":lua require('substitute').operator()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "mm", ":lua require('substitute').line()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "M", ":lua require('substitute').eol()<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "m", ":lua require('substitute').visual()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bb", "vip:!zsh<CR>", opts)
vim.keymap.set("n", "<leader>bj", "vip:!zsh | jq<CR>", opts)
vim.keymap.set("n", "<leader>jj", "vip:!jq<CR>", opts)

vim.keymap.set("v", "v", "<Plug>(expand_region_expand)", {})
vim.keymap.set("v", "<C-v>", "<Plug>(expand_region_shrink)", {})

vim.keymap.set("n", "<leader>,", "A)<ESC><cmd>silent! ConjureEvalCurrentForm<CR><cmd>silent! normal! x0w<CR>", opts)

local function eval_clojure_tests()
	if not (vim.bo.filetype == "clojure") then
		return
	end
	local file_name = vim.api.nvim_buf_get_name(0)

	if string.find(file_name, "_test") then
		return vim.cmd("ConjureCljRunCurrentNsTests")
	end

	vim.cmd("ConjureCljRunAlternateNsTest")
end

vim.keymap.set("n", "<C-t>", eval_clojure_tests, {})

vim.keymap.set("i", "<C-o>", "()<Esc>i", opts)
vim.keymap.set("i", "<C-]>", "[]<Esc>i", opts)
vim.keymap.set("i", "<C-y>", "{}<Esc>i", opts)
vim.keymap.set("i", "<C-u>", '""<Esc>i', opts)

-- <LocalLeader>W                          *<Plug>(sexp_round_head_wrap_element)*
-- <LocalLeader>w                          *<Plug>(sexp_round_tail_wrap_element)*
vim.keymap.set("n", "<leader>:", "<Plug>(sexp_round_tail_wrap_element)", opts)
vim.keymap.set("n", "<leader>;", "<Plug>(sexp_round_head_wrap_element)", opts)
vim.keymap.set("n", "<leader>es", "<Plug>(sexp_move_to_prev_top_element) fna*<Esc><cmd>ConjureEvalRootForm<CR>x0", opts)

-- remove default nvim keymaps. These cause lag when using normal gr keybinding
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")
