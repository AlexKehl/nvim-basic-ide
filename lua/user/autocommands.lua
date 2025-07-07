-- [nfnl] fnl/user/autocommands.fnl
local keymap_opts = {buffer = true, noremap = true, silent = true}
local function _1_()
  return vim.keymap.set("n", "<leader>or", "<cmd>OrganizeImports<CR>", keymap_opts)
end
vim.api.nvim_create_autocmd("FileType", {callback = _1_, pattern = {"typescript", "typescriptreact"}})
local function _2_()
  require("csvview").enable()
  return vim.opt_local.formatoptions:remove("t")
end
vim.api.nvim_create_autocmd("FileType", {callback = _2_, desc = "Enable CSV View on .csv files", pattern = {"csv", "tsv"}})
local function _3_()
  return vim.keymap.set("n", "<Tab>", "<cmd>ParinferToggle<CR>", keymap_opts)
end
vim.api.nvim_create_autocmd("FileType", {callback = _3_, pattern = {"clojure", "scheme", "lisp", "racket", "fennel"}})
local function _4_()
  if (vim.bo.filetype ~= "qf") then
    local function _5_()
      return vim.cmd("FormatWrite")
    end
    return vim.keymap.set("n", "<CR>", _5_, opts)
  else
    return vim.keymap.del("n", "<CR>")
  end
end
return vim.api.nvim_create_autocmd("BufEnter", {callback = _4_})
