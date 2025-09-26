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
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
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

			-- VSCode launch.json with comments
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end

			------------------------------------------------------------------
			-- JavaScript / TypeScript: Node (Next.js server) + Chrome client
			-- Requires Mason package: js-debug-adapter
			------------------------------------------------------------------
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = 8123,
				executable = {
					command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/js-debug-adapter",
				},
			}

			dap.adapters["pwa-chrome"] = {
				type = "executable",
				command = "node",
				args = {
					os.getenv("HOME")
						.. "/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
				},
			}
			-- Alias so `"type": "node"` in launch.json works
			dap.adapters["node"] = dap.adapters["pwa-node"]

			local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						name = "Next.js: debug server",
						type = "pwa-node",
						request = "launch",
						program = "${workspaceFolder}/node_modules/next/dist/bin/next",
						runtimeArgs = { "--inspect" },
						skipFiles = { "<node_internals>/**" },
						serverReadyAction = {
							action = "debugWithChrome",
							killOnServerStop = true,
							pattern = "- Local:.+(https?://.+)",
							uriFormat = "%s",
							webRoot = "${workspaceFolder}",
						},
						cwd = "${workspaceFolder}",
					},
					{
						name = "Next.js: debug client-side",
						type = "chrome",
						request = "launch",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						sourceMaps = true,
						sourceMapPathOverrides = {
							["webpack://_N_E/*"] = "${webRoot}/*",
						},
					},
				}
			end

			------------------------------------------------------------------
			-- C/C++/Rust/Go: install codelldb and delve via Mason
			-- Configurations can be added per-language as needed
			------------------------------------------------------------------
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
			handlers = {},
		},
		config = function() end,
	},
}
