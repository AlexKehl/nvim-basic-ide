local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
	return
end

dap_install.setup({})

dap_install.config("python", {})
dap_install.config("typescript", {})
-- add other configs here

dapui.setup({
	layouts = {
		elements = {
			{
				id = "scopes",
				size = 0.25, -- Can be float or integer > 1
			},
			{ id = "breakpoints", size = 0.25 },
		},
		size = 40,
		position = "right", -- Can be "left", "right", "top", "bottom"
	},
	-- tray = {
	--   elements = {},
	-- },
})

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dap.adapters.chrome = {
	-- executable: launch the remote debug adapter - server: connect to an already running debug adapter
	type = "executable",
	-- command to launch the debug adapter - used only on executable type
	command = "node",
	args = { os.getenv("HOME") .. "/.local/share/nvim/dapinstall/chrome/vscode-chrome-debug/out/src/chromeDebug.js" },
}

dap.configurations.typescript = {
	{
		name = "Debug (Attach) - Remote",
		type = "chrome",
		request = "attach",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		--      reAttach = true,
		trace = true,
		protocol = "inspector",
		hostName = "127.0.0.1",
		port = 9229,
		webRoot = "${workspaceFolder}",
	},
}

-- dap.adapters.node2 = {
-- 	type = "executable",
-- 	command = "node",
-- 	args = { os.getenv("HOME") .. "/.local/share/nvim/dapinstall/jsnode/vscode-node-debug2/out/src/nodeDebug.js" },
-- }
--
-- dap.configurations.typescript = {
-- 	{
-- 		type = "node2",
-- 		request = "attach",
-- 		-- program = "${file}",
-- 		cwd = vim.fn.getcwd(),
-- 		sourceMaps = true,
-- 		protocol = "inspector",
-- 		port = 9229,
-- 		webRoot = "${workspaceFolder}",
-- 	},
-- }
