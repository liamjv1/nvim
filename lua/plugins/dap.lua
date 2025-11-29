---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	local args_str = type(args) == "table" and table.concat(args, " ") or args
	config = vim.deepcopy(config)
	config.args = function()
		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str))
		if config.type and config.type == "java" then
			return new_args
		end
		return require("dap.utils").splitstr(new_args)
	end
	return config
end

return {
	{
		"mfussenegger/nvim-dap",
		desc = "Debug Adapter Protocol client",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F6>",
				function()
					require("dap").pause()
				end,
				desc = "Debug: Pause",
			},
			{
				"<F8>",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Debug: Run to Cursor",
			},
			{
				"<F9>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Conditional Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Debug: Run to Cursor",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Debug: Run with Args",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Debug: Run Last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Terminate",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Debug: Toggle REPL",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Debug: Hover Variables",
			},
			{
				"<leader>ds",
				function()
					require("dap.ui.widgets").sidebar(require("dap.ui.widgets").scopes).open()
				end,
				desc = "Debug: Scopes",
			},
			{
				"<leader>df",
				function()
					require("dap.ui.widgets").sidebar(require("dap.ui.widgets").frames).open()
				end,
				desc = "Debug: Frames",
			},
		},
		config = function()
			local dap = require("dap")

			-- Signs
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			local icons = {
				Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = "●",
				BreakpointCondition = "◆",
				BreakpointRejected = "",
				LogPoint = "◆",
			}
			for name, sign in pairs(icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define("Dap" .. name, {
					text = sign[1],
					texthl = sign[2] or "DiagnosticInfo",
					linehl = sign[3],
					numhl = sign[3],
				})
			end

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		opts = {},
		config = function(_, opts)
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "williamboman/mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			automatic_installation = true,
			ensure_installed = { "delve", "codelldb" },
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
				codelldb = function(config)
					config.adapters = {
						type = "server",
						port = "${port}",
						executable = {
							command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
							args = { "--port", "${port}" },
						},
					}
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		},
	},
}
