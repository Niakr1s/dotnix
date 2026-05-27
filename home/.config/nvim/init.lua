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
vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-night")

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

vim.api.nvim_create_user_command("Source", function()
  vim.cmd('source ~/.config/nvim/init.lua')
  print('Configuration reloaded!')
end, { desc = "Reload configuration" })


-- Configure completion behavior
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
-- menu: Show popup menu
-- menuone: Show menu even with one item
-- noselect: Don't auto-select the first item
-- noinsert: Don't auto-insert text

-- Ctrl+Space to manually trigger omnifunc completion
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })

-- [[ Lsp ]]

-- Python
vim.lsp.enable("ruff")
-- Ruby
vim.lsp.enable("ruby_lsp")
-- Bash
vim.lsp.enable("bashls")
-- Rust
vim.lsp.enable("rust_analyzer")
-- Go (Golang)
vim.lsp.enable("gopls")
-- C / C++
vim.lsp.enable("clangd")
-- C#
vim.lsp.enable("csharp_ls")
-- Nix
vim.lsp.enable("nil_ls")
-- Lua
vim.lsp.enable("lua_ls")
-- JSON
vim.lsp.enable("jsonls")
-- HTML
vim.lsp.enable("html")
-- CSS
vim.lsp.enable("cssls")
-- TypeScript / JavaScript
vim.lsp.enable("vtsls")
-- Java
vim.lsp.enable("jdtls")
-- Zig
vim.lsp.enable("zls")
-- YAML
vim.lsp.enable("yamlls")
-- Markdown
vim.lsp.enable("marksman")
-- PHP
vim.lsp.enable("phpactor")

-- [[ Lsp hotkeys ]]
--
-- GLOBAL DEFAULTS:
-- "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
-- "gri" is mapped to vim.lsp.buf.implementation()
-- "grn" is mapped to vim.lsp.buf.rename()
-- "grr" is mapped to vim.lsp.buf.references()
-- "grt" is mapped to vim.lsp.buf.type_definition()
-- "grx" is mapped to vim.lsp.codelens.run()
-- "gO" is mapped to vim.lsp.buf.document_symbol()
-- CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
-- v_an and v_in fall back to LSP vim.lsp.buf.selection_range() if treesitter is not active.
-- gx handles textDocument/documentLink.
--
-- BUFFER-LOCAL DEFAULTS:
-- 'omnifunc' is set to vim.lsp.omnifunc(), use i_CTRL-X_CTRL-O to trigger completion.
-- 'tagfunc' is set to vim.lsp.tagfunc(). This enables features like go-to-definition, :tjump, and keymaps like CTRL-], CTRL-W_], CTRL-W_} to utilize the language server.
-- 'formatexpr' is set to vim.lsp.formatexpr(), so you can format lines via gq if the language server supports it.
-- To opt out of this use gw instead of gq, or clear 'formatexpr' on LspAttach.
-- K is mapped to vim.lsp.buf.hover() unless 'keywordprg' is customized or a custom keymap for K exists.

vim.keymap.set("n", "H", vim.diagnostic.open_float, { desc = "Show diagnostic in floating window" })

-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Go to declaration (often similar to definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true, lsp_fallback = true })
end, { desc = "Format current buffer" })

-- [[ Surround
require("nvim-surround").setup()

-- [[ Treesitter
-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo[0][0].foldmethod = "expr"

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	incremental_selection = { enable = true },
	textobjects = { enable = true },
  indent = { enable = true }
})


-- [[ Yazi
vim.g.loaded_netrwPlugin = 1 -- disable deafult explorer (netrw) when open with 'vim .'
require("yazi").setup({
    -- Set the floating window border to 'none' to remove borders
    yazi_floating_window_border = 'none',
    -- Optional: other common settings you might want to include
    open_for_directories = true, -- Set to true if you want yazi to replace netrw
    floating_window_scaling_factor = 0.8, -- Control window size (0.9 = 90%)
    yazi_floating_window_winblend = 0, -- Transparency (0 = opaque)
})

vim.keymap.set("n", "<leader>-", function()
    require("yazi").yazi()
end, { desc = "Open yazi at the current file" })

-- [[ Blink.cmp
require("blink.cmp").setup()

-- [[ Gitsigns
require('gitsigns').setup{
  current_line_blame = true,

  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)

    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hi', gitsigns.preview_hunk_inline)
  end
}
