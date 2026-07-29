source ~/.dotfiles/scripts/utils.sh

if [ ! -d ~/.claude ]; then mkdir ~/.claude; fi

echo "linking ~/.claude config"
rm -f ~/.claude/CLAUDE.md ~/.claude/settings.json ~/.claude/keybindings.json
rm -rf ~/.claude/agents ~/.claude/skills ~/.claude/commands
ln -s ~/.dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/.dotfiles/claude/settings.json ~/.claude/settings.json
ln -s ~/.dotfiles/claude/keybindings.json ~/.claude/keybindings.json
ln -s ~/.dotfiles/claude/agents ~/.claude/agents
ln -s ~/.dotfiles/claude/skills ~/.claude/skills
ln -s ~/.dotfiles/claude/commands ~/.claude/commands

# TS 6 vendored for hooks/organize-ts-imports.cjs (typescript >= 7 dropped the JS API)
# bun is installed by homebrew-setup.sh, which runs before this script
bun install --cwd ~/.dotfiles/claude/hooks

# plugins are enabled in settings.json but must be installed per-machine
if command -v claude &>/dev/null; then
  claude plugin install typescript-lsp@claude-plugins-official --scope user
  claude plugin install pyright-lsp@claude-plugins-official --scope user
fi
