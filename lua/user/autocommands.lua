-- [nfnl] fnl/user/autocommands.fnl
local keymap_opts = {buffer = true, noremap = true, silent = true}
local function _1_()
  return vim.keymap.set("n", "<leader>or", "<cmd>OrganizeImports<CR>", keymap_opts)
end
vim.api.nvim_create_autocmd("FileType", {callback = _1_, pattern = {"typescript", "typescriptreact"}})
local function _2_()
  if (vim.bo.filetype ~= "qf") then
    local function _3_()
      return vim.cmd("FormatWrite")
    end
    return vim.keymap.set("n", "<CR>", _3_, opts)
  else
    return vim.keymap.del("n", "<CR>")
  end
end
vim.api.nvim_create_autocmd("BufEnter", {callback = _2_})
return vim.api.nvim_create_autocmd("BufEnter", {command = "syntax sync fromstart", pattern = {"*.ly", "*.ily", "*.tex"}})
