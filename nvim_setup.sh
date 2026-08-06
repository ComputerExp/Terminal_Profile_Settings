#!/bin/bash
# ==============================================================================
# UBUNTU LOCAL DEVELOPMENT SUITE - NEOVIM MASTER EDITION
# ==============================================================================
set -e

echo "🚀 [1/4] Snapping up system binaries with apt-fast..."
sudo apt-fast update
sudo apt-fast install -y git curl nodejs npm python3 python3-pip ripgrep build-essential unzip
yes | npm install -g tree-sitter-cli
sudo apt install xclip -y
echo "📦 [2/4] Deploying cutting-edge Neovim via Snap..."
sudo snap install nvim --classic

echo "🧼 [3/4] Resetting previous configurations and setting up new config and path variables..."
rm -rf "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim"
mkdir -p "$HOME/.config/nvim"
echo 'export NVIM_RTP="$HOME/.local/share/nvim/site"' >> ~/.bashrc

echo "📝 [4/4] Injecting the monolithic Master Lua configuration..."
cat << 'EOF' > "$HOME/.config/nvim/init.lua"
-- ============================================================================
-- 1. GLOBAL VS-CODE OPTIONS & KEYBINDS
-- ============================================================================
vim.g.mapleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.cmd([[ let @c = "\<Esc>:%+y\<CR>i" ]])

-- Traditional Vim-style save shortcuts for Tmux compatibility
vim.cmd([[ nmap <C-s> :w<CR> ]])
vim.cmd([[ imap <C-s> <Esc><C-s>a ]])                  
-- ============================================================================
-- 2. BOOTSTRAP PACKAGE MANAGER (lazy.nvim)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- 3. THE COMPLETE SYNCHRONIZED PLUGIN LAYOUT
-- ============================================================================
require("lazy").setup({
  -- Core Theme (Loads First)
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
  },
 
  -- Status Line (Loads via Safe Component Initialization)
  { 
    "nvim-lualine/lualine.nvim", 
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine_theme = 'auto'
      require('lualine').setup({
        options = { theme = lualine_theme }
      })
    end
  },

  -- File Explorer Sidebar
  { 
    "nvim-tree/nvim-tree.lua", 
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end
  },

  -- Universal Fuzzy Finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Syntax Highlighting Engine
  { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.config').setup({
        ensure_installed = { "python", "c", "cpp", "asm", "sql", "lua" },
        highlight = { enable = true },
      })
    end
  },

  -- Intelligent Auto-Popup Autocomplete Engine
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
})

-- ============================================================================
-- 4. INTERACTIVE KEYMAPS & SHIFT SHORTCUTS
-- ============================================================================
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>f', builtin.live_grep, { desc = "Global Text Search" })

-- ============================================================================
-- 5. AUTOMATIC POPUP ACCEPTER LOGIC
-- ============================================================================
local cmp = require'cmp'
cmp.setup({
  completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim-lsp' },
    { name = 'path' },
    { name = 'buffer' },
  })
})

-- ============================================================================
-- 6. LSP BACKGROUND ROUTING
-- ============================================================================
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

require("mason-lspconfig").setup({
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({ capabilities = capabilities })
        end,
        ["sqlls"] = function()
            lspconfig.sqlls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(".sqllsrc.json", ".git")
            })
        end,
    }
})

-- ============================================================================
-- 7. CLEANUP BACKEND AUTOMATIONS
-- ============================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[%!black - 2>/dev/null]])
        vim.fn.winrestview(view)
    end,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Line Diagnostic" })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = "Next Error" })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = "Prev Error" })

-- ============================================================================
-- 8. YOUR DELAYED STARTUP EXECUTION STRATEGY
-- ============================================================================
-- This fires at the absolute end of the loading pipeline. Zero errors, pure beauty.
vim.cmd([[ colorscheme catppuccin ]]) 

EOF


