local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
		t("export function Component(){"),
		t({ "", "    return <div>" }),
		i(1),
		t({ "</div>", "}" }),
	}),

	s("nxl", {
		t("export default function Layout({children}: {children: React.ReactNode}){"),
		t({ "", "    return <main>" }),
		t("{children}"),
		t({ "</main>", "}" }),
	}),
}
