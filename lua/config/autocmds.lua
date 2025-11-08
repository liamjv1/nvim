local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("general", { clear = true })

-- Highlights yanked
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Makes help windows auto go to right instead of small window below
autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "help" then
			vim.cmd("wincmd L")
		end
	end,
})

autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- Disable comment on new line
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	group = general,
	desc = "Disable New Line Comment",
})

-- Some auto abbreviations
vim.cmd([[
  " Fix accidental capitals on the command-line
  cnoreabbrev <expr> W    (getcmdtype() ==# ':' ? 'w'    : 'W')
  cnoreabbrev <expr> Q    (getcmdtype() ==# ':' ? 'q'    : 'Q')
  cnoreabbrev <expr> Wq   (getcmdtype() ==# ':' ? 'wq'   : 'Wq')
  cnoreabbrev <expr> Wqa  (getcmdtype() ==# ':' ? 'wqa'  : 'Wqa')

  " This fixes when typing too fast my nav layer is still active when i press q my shift for : is still active mea
  cnoreabbrev < w
  cnoreabbrev ` q
  cnoreabbrev <q wq
]])

-- Auto-generate Next.js component templates
local function get_parent_dir_name()
	local filepath = vim.fn.expand("%:p:h")
	local dirname = vim.fn.fnamemodify(filepath, ":t")

	-- Capitalize first letter, handle kebab-case/snake_case
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

autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*/page.tsx",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local component_name = get_parent_dir_name() .. "Page"
		local template = string.format(
			[[export default function %s() {
  return (
    <div>
      <h1>%s</h1>
    </div>
  );
}]],
			component_name,
			component_name
		)

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})

autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*/layout.tsx",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local component_name = get_parent_dir_name() .. "Layout"
		local template = string.format(
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
			component_name
		)

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})

autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*/loading.tsx",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local component_name = get_parent_dir_name() .. "Loading"
		local template = string.format(
			[[export default function %s() {
  return (
    <div>
      <p>Loading...</p>
    </div>
  );
}]],
			component_name
		)

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})

-- not-found.tsx
autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*/not-found.tsx",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local template = [[export default function NotFound() {
  return (
    <div>
      <h2>Not Found</h2>
      <p>Could not find requested resource</p>
    </div>
  );
}]]

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})

-- route.ts (API routes)
autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*/route.ts",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local template = [[import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  return NextResponse.json({ message: 'Hello' });
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  return NextResponse.json({ message: 'Created' }, { status: 201 });
}]]

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})

-- Generic React component (fallback for any .tsx not matching special patterns)
autocmd({ "BufNewFile", "BufReadPost" }, {
	group = nextjs_group,
	pattern = "*.tsx",
	callback = function()
		if not is_buffer_empty() then
			return
		end

		local filename = vim.fn.expand("%:t:r")

		-- Skip if it's a Next.js special file
		local special_files = {
			["page"] = true,
			["layout"] = true,
			["loading"] = true,
			["error"] = true,
			["not-found"] = true,
		}

		if special_files[filename] then
			return
		end

		-- Convert filename to PascalCase component name
		local component_name = filename:gsub("[-_](%w)", function(c)
			return c:upper()
		end)
		component_name = component_name:sub(1, 1):upper() .. component_name:sub(2)

		local template = string.format(
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
			component_name,
			component_name,
			component_name,
			component_name
		)

		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))
	end,
})
