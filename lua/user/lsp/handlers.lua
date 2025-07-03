-- [nfnl] fnl/user/lsp/handlers.fnl
local custom_references_picker = require("user.telescope").custom_references_picker
local c = require("nfnl/core")
local ts_utils = require("nvim-treesitter.ts_utils")
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return 
else
end
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
client_capabilities.textDocument.completion.completionItem.snippetSupport = true
local capabilities = cmp_nvim_lsp.default_capabilities(client_capabilities)
local function setup()
  vim.diagnostic.config({float = {border = "rounded", focusable = true, header = "", prefix = "", source = "always", style = "minimal"}, severity_sort = true, signs = {text = {[vim.diagnostic.severity.ERROR] = "\239\129\151", [vim.diagnostic.severity.HINT] = "\243\176\140\181", [vim.diagnostic.severity.INFO] = "\239\129\154", [vim.diagnostic.severity.WARN] = "\239\129\177"}}, update_in_insert = true, underline = false, virtual_text = false})
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
  return nil
end
local function log(message)
  vim.fn.writefile({vim.inspect(message)}, (vim.fn.stdpath("cache") .. "/my_log.txt"), "a")
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
local function _6_()
  return get_parent_type(ts_utils.get_node_at_cursor())
end
vim.keymap.set("n", "<leader>fp", _6_)
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
  local function _9_(reference)
    local escaped_path = vim.uri_to_fname(reference.user_data.uri)
    local buf = vim.fn.bufnr(escaped_path)
    if (buf == -1) then
      return false
    else
      return relevant_reference_3f(buf, reference)
    end
  end
  return c.filter(_9_, references)
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
local keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}
local function lsp_keymaps(bufnr)
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gy", ":Telescope lsp_type_definitions show_line=false<CR>", opts)
  keymap(bufnr, "n", "gd", ":Telescope lsp_definitions show_line=false<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gi", ":Telescope lsp_implementations show_line=false<CR>", opts)
  local function _17_()
    return vim.lsp.buf.references(nil, {on_list = on_references})
  end
  vim.keymap.set("n", "gr", _17_, opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  local function _18_()
    if ((vim.bo.filetype == "typescript") or (vim.bo.filetype == "typescriptreact")) then
      return vim.lsp.buf.code_action({filter = code_action_filter})
    else
      return vim.lsp.buf.code_action()
    end
  end
  vim.keymap.set("n", "<leader>f", _18_, opts)
  keymap(bufnr, "n", "<leader>F", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "]g", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "[g", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  local function _20_()
    return vim.lsp.buf.references(nil, {on_list = on_test_list})
  end
  return vim.keymap.set("n", "gt", _20_, opts)
end
local function on_attach(client, bufnr)
  if (client.name == "ts_ls") then
    client.server_capabilities.document_formatting = false
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
  return lsp_keymaps(bufnr)
end
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return 
else
end
lspconfig.gleam.setup({capabilities = capabilities, cmd = {"gleam", "lsp"}, filetypes = {"gleam"}, on_attach = on_attach, root_dir = lspconfig.util.root_pattern("gleam.toml", ".git")})
lspconfig.fennel_ls.setup({})
return {on_attach = on_attach, setup = setup}
