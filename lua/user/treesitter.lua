-- [nfnl] fnl/user/treesitter.fnl
local configs = require("nvim-treesitter.configs")
local function disabled_3f(_, buf)
  local max_filesize = (50 * 1024)
  local ok, stats = pcall(vim.loop.fs_stat(vim.api.nvim_buf_get_name(buf)))
  return (ok and (("size")(stats) > max_filesize))
end
local function expand_selection()
  local ts_sel = require("nvim-treesitter.incremental_selection")
  if vim.b.ts_current_node then
    return ts_sel.init_selection()
  else
    return ts_sel.node_incremental()
  end
end
local function shrink_selection()
  local ts_sel = require("nvim-treesitter.incremental_selection")
  return ts_sel.node_decremental()
end
vim.keymap.set("v", "v", expand_selection, {noremap = true})
vim.keymap.set("v", "<C-v>", shrink_selection, {noremap = true})
return configs.setup({ensure_installed = {"tsx", "lua", "rust", "typescript", "javascript", "clojure"}, ignore_install = {""}, rainbow = {enable = true}, incremental_selection = {enable = true, keymaps = {init_selection = false, node_decremental = false, node_incremental = false, scope_incremental = false}}, indent = {enable = true, disable = {"python", "css"}}, highlight = {enable = true, disable = disabled_3f, custom_captures = {["keyword.special"] = "Special", namespace = "Include"}, additional_vim_regex_highlighting = {"lilypond"}}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", af = "@function.outer", ["if"] = "@function.inner", id = "@conditional.inner", ad = "@conditional.outer", av = "@assignment.outer", iv = "@assignment.inner", ar = "@return.outer", ir = "@return.inner"}}, move = {enable = true, set_jumps = true, goto_next_start = {["]f"] = "@function.outer", ["]a"] = "@parameter.outer", ["]d"] = "@conditional.outer", ["]b"] = "@block.outer"}, goto_previous_start = {["[f"] = "@function.outer", ["[a"] = "@parameter.outer", ["[d"] = "@conditional.outer", ["[b"] = "@block.outer"}}}})
