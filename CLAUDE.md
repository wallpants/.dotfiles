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
- `minimal.lua` - Minimal config used by the `vim` shell alias (`nvim -u`): core options/keymaps + a small plugin allowlist, reusing specs from the main config
- `lua/gual/` - Core config (options, keymaps, autocmds, lazy.nvim setup, LSP server config in `lsp.lua`, helpers in `utils.lua`)
- `lua/plugins/` - Plugin specs in lazy.nvim format

### Key Details
- **Plugin manager**: lazy.nvim
- **Treesitter**: Uses `tree-sitter-manager.nvim` (requires system tree-sitter CLI). Highlighting enabled via autocommand calling `vim.treesitter.start()`
- **LSP**: nvim-lspconfig + mason.nvim (servers/tools installed via mason-tool-installer). TypeScript uses `tsgo`; linting via `oxlint` (custom pull-diagnostics workaround in `gual/lsp.lua`). Server settings configured with `vim.lsp.config()` in `gual/lsp.lua`
- **Formatting**: conform.nvim (`oxfmt` for JS/TS/JSON/CSS/etc, stylua for Lua, black for Python), format-on-save with TS import organizing in `lua/plugins/formatting.lua`
- **Completion**: nvim-cmp + LuaSnip
- **Colorscheme**: Defaults to "murphy", env-based switching via `NVIM_THEME`

### Common Tasks
- **Add plugin**: Create/edit file in `lua/plugins/`, return lazy.nvim spec table
- **Add keymaps**: Use `Utils.map()` or edit `gual/keymaps.lua`
- **Add autocommands**: Edit `gual/autocmds.lua`

## Kitty (`kitty/`)

- `kitty.conf` - Main configuration
- `os_specific.conf` - Symlink to `mac.conf` or `linux.conf`
- `ssh.conf` - Overrides applied when using the `ssh` kitten (sets `NVIM_THEME=material`)
- `themes/` - Color themes (active theme included at the bottom of `kitty.conf`)
- `wallpapers/` - Background images

## Zsh (`zsh/`)

- `zshrc` - Main zsh configuration (oh-my-zsh)
- `os_specific.zsh` - Symlink to `mac.zsh` or `linux.zsh`
- `leite.zsh-theme` - Custom oh-my-zsh theme

## Scripts (`scripts/`)

Setup scripts for fresh installs (`setup.sh` sources the others):
- `setup.sh` - Main entry point: clones repo, runs the scripts below
- `utils.sh` - Helpers: `get_current_os`, `eval_if_os`, `brew_ensure_installed`
- `github-setup.sh` - Git identity + ssh key generation
- `install-fonts.sh` - Font install (linux: symlink + fc-cache, macos: copy to ~/Library/Fonts)
- `homebrew-setup.sh` - Homebrew + package installation
- `neovim-setup.sh` - Neovim config symlink
- `kitty-setup.sh` - Kitty config symlink
- `zsh-setup.sh` - Zsh/oh-my-zsh setup
- `create-user.sh` - Standalone: create user on a fresh server (run before `setup.sh`)
- `wsl-install-gui-apps.sh` - Standalone: GUI apps for WSL

## Platform Support

Machines in use: macOS laptop, a kubuntu desktop, and a DigitalOcean droplet running Ubuntu. All three run the full `setup.sh`.

Uses symlinks for OS-specific configs (created by setup scripts, gitignored):
- `kitty/os_specific.conf` -> `mac.conf` or `linux.conf`
- `zsh/os_specific.zsh` -> `mac.zsh` or `linux.zsh`
