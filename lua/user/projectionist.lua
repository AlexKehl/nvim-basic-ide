-- [nfnl] fnl/user/projectionist.fnl
local function log(val)
  print(vim.inspect(val))
  return val
end
local function path__3efilename(path)
  local splitted = vim.split(path, "/")
  local last = splitted[#splitted]
  local _let_1_ = vim.split(last, "%.")
  local filename = _let_1_[1]
  local ext = _let_1_[2]
  return {filename = filename, ext = ext}
end
local function get_clojure_path(buf_path)
  local _let_2_ = path__3efilename(buf_path)
  local filename = _let_2_["filename"]
  local ext = _let_2_["ext"]
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
  local filename = path__3efilename(buf_path)
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
    return get_ts_path(ft)
  elseif (ft == "javascript") then
    return get_ts_path(ft)
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
  vim.keymap.set("n", "<leader>ej", "<cmd>ConjureEval (refresh)<CR>")
  return vim.keymap.set("n", "<leader>a", open_projection)
end
return {setup = setup}
