local uv = vim.uv or vim.loop

-- Detects if we open a Rojo project
local function rojo_project()
	local root = vim.fs.root(0, function(name)
		return name:match(".+%.project%.json$")
	end)

	return root and vim.fs.normalize(root) or nil
end

local function rojo_paths()
	local root = rojo_project()
	if not root then
		return
	end

	local default_project = vim.fs.joinpath(root, "default.project.json")
	if uv.fs_stat(default_project) then
		return {
			root = root,
			project = default_project,
			sourcemap = vim.fs.joinpath(root, "sourcemap.json"),
		}
	end

	local project_files = vim.fs.find(function(name, path)
		return vim.fs.normalize(path) == root and name:match(".+%.project%.json$")
	end, {
		path = root,
		type = "file",
		limit = 1,
	})

	if project_files and project_files[1] then
		return {
			root = root,
			project = vim.fs.normalize(project_files[1]),
			sourcemap = vim.fs.joinpath(root, "sourcemap.json"),
		}
	end

	return { root = root }
end

local rojo = rojo_paths()

-- [[ Luau filetype detection ]]
-- Automatically recognise .lua as luau files in a Roblox project
if rojo then
	vim.filetype.add({
		extension = {
			lua = function(path)
				return path:match("%.nvim%.lua$") and "lua" or "luau"
			end,
		},
	})
end

return {
	"lopi-py/luau-lsp.nvim",
	config = function()
		-- Configure *server* settings
		vim.lsp.config("luau-lsp", {
			settings = {
				["luau-lsp"] = {
					ignoreGlobs = { "**/_Index/**", "node_modules/**" },
					completion = {
						imports = {
							enabled = true,
							ignoreGlobs = { "**/_Index/**", "node_modules/**" },
						},
					},
				},
			},
		})

		-- We call `require("luau-lsp").setup` instead of `vim.lsp.enable("luau_lsp")` because luau-lsp.nvim will
		-- add extra features to luau-lsp, so we don't need to call the native lsp setup
		--
		-- See https://github.com/lopi-py/luau-lsp.nvim
		local luau_lsp_opts = {
			platform = {
				type = rojo and rojo.root and "roblox" or "standard",
			},
			plugin = {
				enabled = true,
			},
		}

		if rojo and rojo.project then
			luau_lsp_opts.sourcemap = {
				autogenerate = true,
				rojo_project_file = rojo.project,
				sourcemap_file = rojo.sourcemap,
			}
		else
			luau_lsp_opts.sourcemap = {
				enabled = false,
			}
		end

		require("luau-lsp").setup(luau_lsp_opts)
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
