# Dotfiles

Personal dotfiles for macOS/Linux development environment.

## Structure

```
.dotfiles/
├── claude/          # Claude Code user configuration
├── fonts/           # Custom fonts
├── kitty/           # Kitty terminal configuration
├── lazygit/         # Lazygit configuration
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
- `open-actions.conf` / `launch-actions.conf` - What kitty does when asked to open a path: clicked `file://` hyperlinks go through open-actions, OS-initiated opens (Finder "Open With", Dock drops, `open -a kitty`) through launch-actions. Both open files in nvim in a new tab, directories in a new tab shell
- `nvim_hints.py` - Custom hints-kitten processing for `cmd+p`: hints every path on screen (with or without `:linenum`) and opens the pick in nvim in a new tab, jumping to the line if present
- `os_specific.conf` - Symlink to `mac.conf` or `linux.conf`
- `ssh.conf` - Overrides applied when using the `ssh` kitten (sets `NVIM_THEME=material`)
- `themes/` - Color themes (active theme included at the bottom of `kitty.conf`)
- `wallpapers/` - Background images

## Claude Code (`claude/`)

User-level Claude Code config, symlinked into `~/.claude/` by `claude-setup.sh` (individual files/dirs are linked, not the whole directory — `~/.claude` also holds runtime state and credentials that must stay out of git):

- `CLAUDE.md` - Global instructions for all projects
- `settings.json` - Theme, vim mode, enabled plugins
- `keybindings.json` - Custom keybindings
- `agents/`, `skills/`, `commands/` - User-level agents/skills/commands (empty placeholders for now)

Enabled plugins (`typescript-lsp`, `pyright-lsp`) are installed per-machine by `claude-setup.sh`; their language servers (`typescript-language-server`, `pyright-langserver`) come from Mason (`ts_ls` is in mason-tool-installer's list but excluded from nvim's `automatic_enable` — nvim uses `tsgo` instead). Mason's bin dir (`~/.local/share/nvim/mason/bin`) is added to PATH in `zshrc`.

## Lazygit (`lazygit/`)

- `config.yml` - Lazygit configuration, picked up via `LG_CONFIG_FILE` exported in `zsh/zshrc` (no symlink; `state.yml` stays in lazygit's default config dir)

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
- `claude-setup.sh` - Claude Code config symlinks + plugin installs
- `create-user.sh` - Standalone: create user on a fresh server (run before `setup.sh`)
- `wsl-install-gui-apps.sh` - Standalone: GUI apps for WSL

## Platform Support

Machines in use: macOS laptop, a kubuntu desktop, and a DigitalOcean droplet running Ubuntu. All three run the full `setup.sh`.

Uses symlinks for OS-specific configs (created by setup scripts, gitignored):
- `kitty/os_specific.conf` -> `mac.conf` or `linux.conf`
- `zsh/os_specific.zsh` -> `mac.zsh` or `linux.zsh`
