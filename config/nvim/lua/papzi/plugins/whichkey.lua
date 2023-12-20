local wk = require("which-key")
wk.setup({
	plugins = {
		marks = false,
		registers = false,
		spelling = { enabled = false, suggestions = 20 },
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
})

local Terminal = require("toggleterm.terminal").Terminal
local toggle_float = function()
	local float = Terminal:new({ direction = "float" })
	return float:toggle()
end
local toggle_lazygit = function()
	local lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
	return lazygit:toggle()
end

local mappings = {

	w = {
		name = "Window Splits",
		e = { "Equal Windows Size" },
		h = { ":sp<cr>", "Horizontal Split" },
		x = { ":close<cr>", "Close Split" },
		v = { ":vs<cr>", "Vertical Split" },
	},

	f = { ":NvimTreeToggle<cr>", "File Explorer" },

	t = {
		name = "Tabs",
		n = { ":tabnext<cr>", "Next Tab" },
		o = { ":tabnew<cr>", "New Tab" },
		p = { ":tabprevious<cr>", "Previous Tab" },
		x = { ":tabclose<cr>", "Close Tab" },
	},

	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		f = { "<cmd>Telescope find_files<cr>", "Find Files" },
		g = { "<cmd>Telescope grep_string<cr>", "Grep String" },
		h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		s = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		v = { "<cmd>Telescope buffers<cr>", "Buffers" },
	},
}

local opts = { prefix = "<leader>" }
wk.register(mappings, opts)
