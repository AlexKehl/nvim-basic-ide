local dap = require("dap")
local dapui = require("dapui")

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "8123",
	executable = {
		command = "node",
		-- 💀 Make sure to update this path to point to your installation
		args = { os.getenv("HOME") .. "/js-debug/src/dapDebugServer.js", "8123" },
	},
}

dap.configurations.javascript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
}

dap.configurations.typescript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		runtimeExecutable = "node",
		runtimeArgs = { "-r", "ts-node/register" },
		args = { "--inspect", "${file}" },
		program = "${file}",
		cwd = "${workspaceFolder}",
		-- attachSimplePort = 8123,
	},
}

dapui.setup()
