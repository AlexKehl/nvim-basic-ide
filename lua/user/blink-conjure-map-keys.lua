-- [nfnl] fnl/user/blink-conjure-map-keys.fnl
local source = {}
source.new = function()
  return setmetatable({}, {__index = source})
end
source.enabled = function(_self)
  return (vim.bo.filetype == "clojure")
end
local function get_last_result()
  local ok, eval = pcall(require, "conjure.eval")
  if (ok and eval.results and (#eval.results > 0)) then
    return eval.results[#eval.results]
  else
    return nil
  end
end
local function extract_map_keys(result_str)
  if (result_str and result_str:match("^%s*[{#]")) then
    local keys = {}
    for kw in result_str:gmatch("[{,\n]%s*(::?[%w%-%._%*!%?]+/?[%w%-%._%*!%?]*)") do
      table.insert(keys, kw)
    end
    return keys
  else
    return nil
  end
end
source.get_completions = function(_self, _, callback)
  local items = {}
  local seen = {}
  local kind_keyword = require("blink.cmp.types").CompletionItemKind.Keyword
  local plain_text = vim.lsp.protocol.InsertTextFormat.PlainText
  do
    local last_result = get_last_result()
    if last_result then
      local keys = extract_map_keys(last_result.result)
      if keys then
        for _0, key in ipairs(keys) do
          if not seen[key] then
            seen[key] = true
            table.insert(items, {label = key, kind = kind_keyword, insertTextFormat = plain_text, insertText = key, detail = "*1 map key"})
          else
          end
        end
      else
      end
    else
    end
  end
  return callback({items = items, is_incomplete_backward = false, is_incomplete_forward = false})
end
return source
