-- [nfnl] fnl/user/autocommands.fnl
local keymap_opts = {buffer = true, noremap = true, silent = true}
local function _1_()
  vim.keymap.set("n", "<leader>or", "<cmd>OrganizeImports<CR>", keymap_opts)
  return vim.keymap.set("n", "<leader>oi", "<cmd>AddMissingImports<CR>", keymap_opts)
end
vim.api.nvim_create_autocmd("FileType", {callback = _1_, pattern = {"typescript", "typescriptreact"}})
local function _2_()
  return vim.keymap.set("n", "<leader>or", "<cmd>OrganizeImports<CR>", keymap_opts)
end
vim.api.nvim_create_autocmd("FileType", {callback = _2_, pattern = {"typescript", "typescriptreact"}})
return vim.api.nvim_create_autocmd("BufEnter", {command = "syntax sync fromstart", pattern = {"*.ly", "*.ily", "*.tex"}})
