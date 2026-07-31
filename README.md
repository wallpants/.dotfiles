# .dotfiles

Personal dotfiles for macOS/Linux (nvim, kitty, zsh, lazygit, Claude Code).

### Create User

Only needed on a fresh server where you'd otherwise be running as root. Prompts for a username, creates the user with a home directory and password, and adds it to the admin group (`sudo` on ubuntu/debian, `wheel` on fedora). Log in as that user before running the setup below.

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/wallpants/.dotfiles/main/scripts/create-user.sh)"
```

### Clone & setup

Full machine setup, safe to re-run. Clones this repo to `~/.dotfiles` (if missing) and then:

- sets git identity and generates an ssh key for GitHub (printed at the end so you can add it to your account)
- installs fonts
- installs Homebrew and CLI packages (nvim, lazygit, bun, ripgrep, fd, nvm, ...)
- installs kitty (macOS: brew cask, linux: official binary bundle) and symlinks nvim/kitty configs into `~/.config`
- installs oh-my-zsh, makes zsh the default shell, and symlinks the zsh config
- symlinks Claude Code config into `~/.claude` and installs its plugins

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/wallpants/.dotfiles/main/scripts/setup.sh)"
```
