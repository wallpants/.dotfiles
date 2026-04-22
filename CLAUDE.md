# Dotfiles

Personal dotfiles for macOS/Linux development environment.

## Structure

```
.dotfiles/
├── fonts/           # Custom fonts
├── kitty/           # Kitty terminal configuration
├── nvim/            # Neovim configuration
├── scripts/         # Setup and installation scripts
└── zsh/             # Zsh shell configuration
```

## Neovim (`nvim/`)

**Version**: Neovim 0.12+

### Structure
- `init.lua` - Entry point, loads `gual` module
- `lua/gual/` - Core config (options, keymaps, autocmds, lazy.nvim setup)
- `lua/plugins/` - Plugin specs in lazy.nvim format

### Key Details
- **Plugin manager**: lazy.nvim
- **Treesitter**: Uses `tree-sitter-manager.nvim` (requires system tree-sitter CLI). Highlighting enabled via autocommand calling `vim.treesitter.start()`
- **LSP**: nvim-lspconfig + mason.nvim. TypeScript uses typescript-tools.nvim
- **Colorscheme**: Defaults to "murphy", env-based switching via `NVIM_THEME`

### Common Tasks
- **Add plugin**: Create/edit file in `lua/plugins/`, return lazy.nvim spec table
- **Add keymaps**: Use `Utils.map()` or edit `gual/keymaps.lua`
- **Add autocommands**: Edit `gual/autocmds.lua`

## Kitty (`kitty/`)

- `kitty.conf` - Main configuration
- `os_specific.conf` - Symlink to `mac.conf` or `linux.conf`
- `themes/` - Color themes

## Zsh (`zsh/`)

- `zshrc` - Main zsh configuration
- `os_specific.zsh` - Symlink to `mac.zsh` or `linux.zsh`
- `leite.zsh-theme` - Custom oh-my-zsh theme

## Scripts (`scripts/`)

Setup scripts for fresh installs:
- `setup.sh` - Main entry point
- `homebrew-setup.sh` - Package installation
- `neovim-setup.sh` - Neovim config symlink
- `kitty-setup.sh` - Kitty config symlink
- `zsh-setup.sh` - Zsh/oh-my-zsh setup

## Platform Support

Uses symlinks for OS-specific configs:
- `kitty/os_specific.conf` -> `mac.conf` or `linux.conf`
- `zsh/os_specific.zsh` -> `mac.zsh` or `linux.zsh`
