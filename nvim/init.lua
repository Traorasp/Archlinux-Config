local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- PLUGINA
require("lazy").setup({
    -- LSP Setup
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
    -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "lewis6991/gitsigns.nvim",
  "kdheepak/lazygit.nvim",
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha") -- Latte, Frappe, Macchiato, Mocha
    end,
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" }
      })
    end,
  },
  
})


-- LSP
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "ts_ls", "cssls", "dockerls", "jsonls", "bashls",
		"eslint"}
})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Syntax Parsing
require("nvim-treesitter.configs").setup({
  ensure_installed = { 
	  "python", "javascript", "lua", "json", "css", 
	  "bash", "dockerfile", "yaml",
	  "markdown", "sql"

  }, -- Add your languages
  highlight = { enable = true },
  indent = { enable = true },
})

-- File Manager
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

require("gitsigns").setup()
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true })

-- Normal mode mappings (movement)
vim.keymap.set('n', 'j', 'h', { noremap = true })  -- left
vim.keymap.set('n', 'k', 'j', { noremap = true })  -- down
vim.keymap.set('n', 'l', 'k', { noremap = true })  -- up
vim.keymap.set('n', ';', 'l', { noremap = true })  -- right

-- Visual mode mappings
vim.keymap.set('v', 'j', 'h', { noremap = true })
vim.keymap.set('v', 'k', 'j', { noremap = true })
vim.keymap.set('v', 'l', 'k', { noremap = true })
vim.keymap.set('v', ';', 'l', { noremap = true })

-- Operator-pending mode (for motions like d, y, c)
vim.keymap.set('o', 'j', 'h', { noremap = true })
vim.keymap.set('o', 'k', 'j', { noremap = true })
vim.keymap.set('o', 'l', 'k', { noremap = true })
vim.keymap.set('o', ';', 'l', { noremap = true })

vim.keymap.set('n', "'", ';', { noremap = true })  -- use 'fd, bat for repeating f/F/t/T

-- Change split navigation keys
vim.keymap.set('n', '<C-w>j', '<C-w>h')  -- Left (was h)
vim.keymap.set('n', '<C-w>k', '<C-w>j')  -- Down (was j)
vim.keymap.set('n', '<C-w>l', '<C-w>k')  -- Up (was k)
vim.keymap.set('n', '<C-w>;', '<C-w>l')  -- Right (was l)
