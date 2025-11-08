require("config.autocmds.general")

-- Auto-load all language-specific autocmds
local lang_path = vim.fn.stdpath("config") .. "/lua/config/autocmds/lang"
local lang_files = vim.fn.glob(lang_path .. "/*.lua", false, true)

for _, file in ipairs(lang_files) do
	local module_name = file:match("([^/]+)%.lua$")
	if module_name then
		require("config.autocmds.lang." .. module_name)
	end
end
