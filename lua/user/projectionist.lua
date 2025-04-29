-- [nfnl] fnl/user/projectionist.fnl
local c = require("nfnl.core")
local fs = require("nfnl.fs")
local function log(val)
  print(vim.inspect(val))
  return val
end
local function get_clojure_path(buf_path)
  local _let_1_ = vim.split(fs.filename(buf_path), "%.")
  local filename = _let_1_[1]
  local ext = _let_1_[2]
  if string.match(buf_path, "src/") then
    return string.gsub(string.gsub(buf_path, "src/", "test/"), (filename .. "." .. ext), (filename .. "_test." .. ext))
  elseif string.match(buf_path, "test/") then
    return string.gsub(string.gsub(buf_path, "test/", "src/"), filename, string.gsub(filename, "_test", ""))
  elseif "else" then
    return print("Could not match file")
  else
    return nil
  end
end
local function get_ts_path(buf_path)
  local _let_3_ = vim.split(fs.filename(buf_path), "%.")
  local filename = _let_3_[1]
  local _ = _let_3_[2]
  if vim.endswith(buf_path, ".test.ts") then
    return string.gsub(buf_path, (filename .. ".test.ts"), (filename .. ".ts"))
  elseif vim.endswith(buf_path, ".ts") then
    return string.gsub(buf_path, (filename .. ".ts"), (filename .. ".test.ts"))
  elseif "else" then
    return print("Could not match file")
  else
    return nil
  end
end
local function get_alternate_file()
  local buf_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local ft = vim.bo.filetype
  if (ft == "clojure") then
    return get_clojure_path(buf_path)
  elseif (ft == "fennel") then
    return get_clojure_path(buf_path)
  elseif (ft == "typescript") then
    return get_ts_path(buf_path)
  elseif (ft == "javascript") then
    return get_ts_path(buf_path)
  else
    return nil
  end
end
local function open_projection()
  return vim.api.nvim_command(("edit " .. get_alternate_file()))
end
local function refresh()
  do
    local projectionist = require("user.projectionist")
    projectionist.setup()
  end
  return vim.api.nvim_command("write")
end
local function setup()
  local function _6_()
    return print("kek")
  end
  vim.keymap.set("n", "<leader>en", _6_)
  vim.keymap.set("n", "<leader>ej", "<cmd>ConjureEval (refresh)<CR>")
  return vim.keymap.set("n", "<leader>a", open_projection)
end
return {setup = setup, ["get-clojure-path"] = get_clojure_path, ["get-ts-path"] = get_ts_path}
