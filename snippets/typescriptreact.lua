local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
	-- Next.js page component
	s("nxp", {
		t("export default function Page(){"),
		t({ "", "    return <div>" }),
		i(1),
		t({ "</div>", "}" }),
	}),

	-- Next.js component with props
	s("nxc", {
		t("export function "),
		d(1, function(args)
			local filename = vim.fn.expand('%:t:r')
			local component_name = ""
			for word in filename:gmatch("([^%-]+)") do
				component_name = component_name .. word:sub(1,1):upper() .. word:sub(2)
			end
			return sn(nil, { i(1, component_name) })
		end, {}),
		t("(){"),
		t({ "", "    return <div>" }),
		i(2),
		t({ "</div>", "}" }),
	}),

	s("nxl", {
		t("export default function "),
		i(1, "Layout"),
		t("({children}: {children: React.ReactNode}){"),
		t({ "", "    return <main>" }),
		t("{children}"),
		t({ "</main>", "}" }),
	}),
}
