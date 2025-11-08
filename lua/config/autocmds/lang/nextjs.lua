local autocmd = vim.api.nvim_create_autocmd

-- Helpers
local function get_parent_dir_name()
	local filepath = vim.fn.expand("%:p:h")
	local dirname = vim.fn.fnamemodify(filepath, ":t")

	dirname = dirname:gsub("[-_](%w)", function(c)
		return c:upper()
	end)
	dirname = dirname:sub(1, 1):upper() .. dirname:sub(2)

	return dirname
end

local function is_buffer_empty()
	return vim.fn.line("$") == 1 and vim.fn.getline(1) == ""
end

local nextjs_group = vim.api.nvim_create_augroup("NextJSTemplates", { clear = true })

-- Template helper
local function create_template_autocmd(pattern, template_fn)
	autocmd({ "BufNewFile", "BufReadPost" }, {
		group = nextjs_group,
		pattern = pattern,
		callback = function()
			if not is_buffer_empty() then
				return
			end

			local template = template_fn()
			if template == nil then
				return
			end

			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
		end,
	})
end

-- Templates
create_template_autocmd("*/page.tsx", function()
	local name = get_parent_dir_name() .. "Page"
	return string.format(
		[[export default function %s() {
  return (
    <div>
      <h1>%s</h1>
    </div>
  );
}]],
		name,
		name
	)
end)

create_template_autocmd("*/layout.tsx", function()
	local name = get_parent_dir_name() .. "Layout"
	return string.format(
		[[export default function %s({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      {children}
    </div>
  );
}]],
		name
	)
end)

create_template_autocmd("*/loading.tsx", function()
	local name = get_parent_dir_name() .. "Loading"
	return string.format(
		[[export default function %s() {
  return (
    <div>
      <p>Loading...</p>
    </div>
  );
}]],
		name
	)
end)

create_template_autocmd("*/not-found.tsx", function()
	return [[export default function NotFound() {
  return (
    <div>
      <h2>Not Found</h2>
      <p>Could not find requested resource</p>
    </div>
  );
}]]
end)

create_template_autocmd("*/route.ts", function()
	return [[import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  return NextResponse.json({ message: 'Hello' });
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  return NextResponse.json({ message: 'Created' }, { status: 201 });
}]]
end)

-- Generic React component
create_template_autocmd("*.tsx", function()
	local filename = vim.fn.expand("%:t:r")

	local special_files = {
		["page"] = true,
		["layout"] = true,
		["loading"] = true,
		["error"] = true,
		["not-found"] = true,
	}

	if special_files[filename] then
		return nil
	end

	local name = filename:gsub("[-_](%w)", function(c)
		return c:upper()
	end)
	name = name:sub(1, 1):upper() .. name:sub(2)

	return string.format(
		[[interface %sProps {
  // Add props here
}

export default function %s({}: %sProps) {
  return (
    <div>
      <p>%s</p>
    </div>
  );
}]],
		name,
		name,
		name,
		name
	)
end)
