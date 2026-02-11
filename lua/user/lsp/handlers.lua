-- [nfnl] fnl/user/lsp/handlers.fnl
local custom_references_picker = require("user.telescope").custom_references_picker
local c = require("nfnl/core")
local ts_utils = require("nvim-treesitter.ts_utils")
local keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
client_capabilities.textDocument.completion.completionItem.snippetSupport = true
local function setup()
  vim.diagnostic.config({float = {border = "rounded", focusable = true, header = "", prefix = "", source = "always", style = "minimal"}, severity_sort = true, signs = {text = {[vim.diagnostic.severity.ERROR] = "\239\129\151", [vim.diagnostic.severity.HINT] = "\243\176\140\181", [vim.diagnostic.severity.INFO] = "\239\129\154", [vim.diagnostic.severity.WARN] = "\239\129\177"}}, update_in_insert = true, underline = false, virtual_text = false})
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
  return nil
end
local function log(message)
  vim.fn.writefile({vim.inspect(message)}, (vim.fn.stdpath("cache") .. "my_log.txt"), "a")
  return message
end
local function get_parent_type(node)
  if node:parent() then
    return get_parent_type(node:parent(), node:type())
  else
    return nil
  end
end
local function is_import_statement(node)
  if c["nil?"](node) then
    return false
  elseif ((node:type() == "import_statement") or (node:type() == "import_declaration") or (node:type() == "import_clause") or (node:type() == "import_specifier") or (node:type() == "named_imports")) then
    return true
  else
    return is_import_statement(node:parent())
  end
end
local function is_export_statement(node)
  if c["nil?"](node) then
    return false
  elseif (node:type() == "export_clause") then
    return true
  else
    return is_export_statement(node:parent())
  end
end
local function is_jsx_closing_tag(node)
  if c["nil?"](node) then
    return false
  elseif (node:type() == "jsx_closing_element") then
    return true
  else
    return is_jsx_closing_tag(node:parent())
  end
end
local function is_test_file(filename)
  return (string.find(filename, "test.ts") or string.find(filename, "test.clj"))
end
local function _5_()
  return get_parent_type(ts_utils.get_node_at_cursor())
end
vim.keymap.set("n", "<leader>fp", _5_)
local function is_current_node(buf, node)
  if (buf ~= vim.fn.bufnr()) then
    return false
  else
    return (node:start() == ts_utils.get_node_at_cursor():start())
  end
end
local function relevant_reference_3f(buf, reference)
  if (0 == vim.fn.bufloaded(buf)) then
    vim.fn.bufload(buf)
  else
  end
  local parser = vim.treesitter.get_parser(buf)
  local range = {reference.user_data.range.start.line, reference.user_data.range.start.character}
  local _ = parser:parse(range)
  local node = vim.treesitter.get_node({bufnr = buf, pos = range})
  return not (is_current_node(buf, node) or is_import_statement(node) or is_jsx_closing_tag(node) or is_export_statement(node))
end
local function filter_relevant_references(references)
  local function _8_(reference)
    local escaped_path = vim.uri_to_fname(reference.user_data.uri)
    local buf = vim.fn.bufnr(escaped_path)
    if (buf == -1) then
      return false
    elseif is_test_file(escaped_path) then
      return false
    else
      return relevant_reference_3f(buf, reference)
    end
  end
  return c.filter(_8_, references)
end
local function on_references(options)
  local filtered_references = filter_relevant_references(options.items)
  if (#filtered_references == 0) then
    vim.print("No references found")
    return 
  else
  end
  if (#filtered_references == 1) then
    local reference = filtered_references[1]
    vim.lsp.util.show_document({range = reference.user_data.range, uri = reference.user_data.uri}, "utf-8")
    return 
  else
  end
  options.items = filtered_references
  return custom_references_picker(filtered_references)
end
local function test_reference_pred(reference)
  local escaped_path = vim.uri_to_fname(reference.user_data.uri)
  local buf = vim.fn.bufnr(escaped_path)
  if (buf == -1) then
    return false
  else
    if string.find(escaped_path, "test") then
      return true
    else
      return false
    end
  end
end
local function filter_test_references(references)
  return c.filter(test_reference_pred, references)
end
local function on_test_list(options)
  local filtered_references = filter_test_references(options.items)
  if (#filtered_references == 0) then
    vim.print("No references found")
    return 
  else
  end
  local reference = filtered_references[1]
  return vim.lsp.util.show_document({range = reference.user_data.range, uri = reference.user_data.uri}, "utf-8")
end
local function code_action_filter(code_action)
  if (string.find(code_action.command.title, "Add") or string.find(code_action.command.title, "Update")) then
    return true
  else
    return false
  end
end
local function organize_imports()
  return vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.api.nvim_buf_get_name(0)}, title = ""})
end
local function add_missing_imports()
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.addMissingImports.ts"}}})
end
local function apply_eslint_fixes(bufnr)
  return vim.lsp.buf.execute_command({command = "eslint.applyAllFixes", arguments = {{uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr]}}, title = ""})
end
local function ts_custom_commands(bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", organize_imports, {})
  return vim.api.nvim_buf_create_user_command(bufnr, "AddMissingImports", add_missing_imports, {})
end
local function eslint_custom_commands(bufnr)
  local function _16_()
    return apply_eslint_fixes(bufnr)
  end
  return vim.api.nvim_buf_create_user_command(bufnr, "EslintFixAll", _16_, {})
end
local function clojure_custom_commands(bufnr)
  local uri = vim.uri_from_bufnr(bufnr)
  local row = (vim.fn.getpos(".")[2] - 1)
  local col = (vim.fn.getpos(".")[3] - 1)
  local function _17_()
    return vim.lsp.buf.execute_command({command = "clean-ns", arguments = {uri, row, col}})
  end
  vim.api.nvim_buf_create_user_command(bufnr, "CleanNs", _17_, {})
  local function _18_()
    return vim.lsp.buf.execute_command({command = "add-missing-libspec", arguments = {uri, row, col}})
  end
  vim.api.nvim_buf_create_user_command(bufnr, "AddMissingLibspec", _18_, {})
  return keymap(bufnr, "n", "<leader>cn", ":CleanNs<CR>", opts)
end
local function lsp_keymaps(bufnr)
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gy", ":Telescope lsp_type_definitions show_line=false<CR>", opts)
  keymap(bufnr, "n", "gd", ":Telescope lsp_definitions show_line=false<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gi", ":Telescope lsp_implementations show_line=false<CR>", opts)
  local function _19_()
    return vim.lsp.buf.references(nil, {on_list = on_references})
  end
  vim.keymap.set("n", "gr", _19_, opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  local function _20_()
    if ((vim.bo.filetype == "typescript") or (vim.bo.filetype == "typescriptreact")) then
      return vim.lsp.buf.code_action({filter = code_action_filter})
    else
      return vim.lsp.buf.code_action()
    end
  end
  vim.keymap.set("n", "<leader>f", _20_, opts)
  keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "]g", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "[g", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  local function _22_()
    return vim.lsp.buf.references(nil, {on_list = on_test_list})
  end
  return vim.keymap.set("n", "gt", _22_, opts)
end
local function log0(message)
  vim.fn.writefile({vim.inspect(message)}, (vim.fn.stdpath("cache") .. "/my_log.txt"), "a")
  return message
end
local function on_attach(client, bufnr)
  log0(vim.inspect(vim.lsp.get_clients()))
  if (client.name == "ts_ls") then
    client.server_capabilities.document_formatting = false
    ts_custom_commands(bufnr)
  else
  end
  if (client.name == "sumneko_lua") then
    client.server_capabilities.document_formatting = false
  else
  end
  if (client.name == "gleam") then
    client.server_capabilities.documentFormattingProvider = true
  else
  end
  if (client.name == "eslint") then
    eslint_custom_commands(bufnr)
  else
  end
  if (client.name == "clojure_lsp") then
    clojure_custom_commands(bufnr)
  else
  end
  return lsp_keymaps(bufnr)
end
vim.lsp.enable("ts_ls")
vim.lsp.config("ts_ls", {on_attach = on_attach})
vim.lsp.enable("clojure_lsp")
vim.lsp.config("clojure_lsp", {on_attach = on_attach})
vim.lsp.enable("marksman")
vim.lsp.config("marksman", {on_attach = on_attach})
vim.lsp.enable("eslint")
vim.lsp.config("eslint", {on_attach = on_attach})
vim.lsp.enable("fennel_ls")
vim.lsp.config("fennel_ls", {on_attach = on_attach})
return {on_attach = on_attach, setup = setup}
