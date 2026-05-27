-- [[ Basic Settings ]]
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.showmode = false -- We'll use statusline instead
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.breakindent = true -- Better indentation for wrapped lines
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true -- But be smart about it
vim.opt.signcolumn = "yes" -- Keep sign column always visible
vim.opt.updatetime = 250 -- Faster update time
vim.opt.timeoutlen = 300 -- Faster key sequence timeout
vim.opt.splitright = true -- New splits open to the right
vim.opt.splitbelow = true -- New splits open below
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Preview substitutions live
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Keep 10 lines below/above cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns side scrolling

-- [[ Tab Settings: 2 spaces ]]
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.softtabstop = 2 -- Number of spaces for editing (backspace)
vim.opt.shiftwidth = 2 -- Number of spaces for auto-indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- [[ Enable .nvim.lua files]]
vim.o.exrc = true
vim.o.secure = true

-- [[ Key Mappings ]]
vim.g.mapleader = " " -- Set space as leader key
vim.g.maplocalleader = " "

-- Better navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv", { desc = "Move selected lines up" })

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, center cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, center" })

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })

-- [[ Conform ]]
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "ruff" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		-- rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.api.nvim_create_user_command("Format", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format current buffer with conform" })
