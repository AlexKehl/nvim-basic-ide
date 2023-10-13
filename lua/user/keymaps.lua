-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Shorten function name
local keymap = vim.keymap.set

-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

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

-- Quick file operations
keymap("n", "<leader>w", "<cmd>w<CR>", opts)
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

-- QuickFix
keymap("n", "<leader>cl", "<cmd>ccl<CR>", opts)

-- Plugins --
keymap("n", "<Right>", "<cmd>BufSurfForward<CR>", opts)
keymap("n", "<Left>", "<cmd>BufSurfBack<CR>", opts)
keymap("n", "\\", "gcc", opts)
keymap("n", "<leader>a", "<cmd>A<CR>", opts)
keymap("n", "<leader>b", "<cmd>Git blame<CR>", opts)
keymap("n", "<leader>l", "<cmd>diffget //3<CR>", opts)
keymap("n", "<leader>h", "<cmd>diffget //2<CR>", opts)
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
keymap("n", "<C-c>", ":Telescope registers<CR>", opts)
keymap("n", "<leader>gw", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- TODO
-- -- Repeat movement with ; and ,
-- -- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
--
-- -- vim way: ; goes to the direction you were moving.
-- -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
--
-- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
