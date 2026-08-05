# .dotfiles

Personal dotfiles for macOS/Linux (nvim, kitty, zsh, lazygit, Claude Code).

### Create User

Only needed on a fresh server where you'd otherwise be running as root. Prompts for a username, creates the user with a home directory and password, and adds it to the admin group (`sudo` on ubuntu/debian, `wheel` on fedora). Log in as that user before running the setup below.

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/wallpants/.dotfiles/main/scripts/create-user.sh)"
```

### Clone & setup

Full machine setup, safe to re-run. Clones this repo to `~/.dotfiles` (or updates it with a fast-forward pull if already present — aborting if local changes prevent that) and then:

- sets git identity and generates an ssh key for GitHub (printed at the end so you can add it to your account)
- installs fonts
- installs Homebrew and CLI packages (nvim, lazygit, bun, ripgrep, fd, nvm, ...)
- installs kitty (macOS: brew cask, linux: official binary bundle) and symlinks nvim/kitty configs into `~/.config`
- installs oh-my-zsh, makes zsh the default shell, and symlinks the zsh config
- symlinks Claude Code config into `~/.claude` and installs its plugins
- syncs nvim: installs plugins pinned in `lazy-lock.json`, installs/updates mason tools (LSP servers, formatters, linters)

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/wallpants/.dotfiles/main/scripts/setup.sh)"
```

### Windows VM

Partial support: Git Bash with the usual aliases (`windows/bashrc`) and nvim in minimal mode (`nvim/windows-init.lua` — the full config's external tools aren't installed on Windows). No zsh/kitty.

1. If git isn't installed yet, in PowerShell (then open a new PowerShell so git is on PATH):

   ```powershell
   winget install -e --id Git.Git
   ```

2. Enable **Developer Mode** (Settings → System → For developers) — required for unelevated symlinks.
3. In PowerShell:

   ```powershell
   git clone https://github.com/wallpants/.dotfiles.git "$env:USERPROFILE\.dotfiles"
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.dotfiles\scripts\windows-setup.ps1"
   ```

   Installs CLI tools via winget (neovim, lazygit, ripgrep, lsd), installs the repo fonts per-user, symlinks `~/.bashrc` and `%LOCALAPPDATA%\nvim\init.lua`. Safe to re-run.

4. Windows Terminal → Settings → Open JSON file, add a Git Bash profile to `profiles.list` and make it the default:

   ```json
   "defaultProfile": "{4f6b6f6d-4d3e-4f2b-9c6a-7a2e0e6b9d21}",
   ```

   ```json
   {
       "guid": "{4f6b6f6d-4d3e-4f2b-9c6a-7a2e0e6b9d21}",
       "name": "Git Bash",
       "commandline": "\"C:\\Program Files\\Git\\bin\\bash.exe\" -i -l",
       "startingDirectory": "%USERPROFILE%",
       "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico",
       "hidden": false
   },
   ```

5. Windows Terminal → Settings → Profiles → Git Bash → Appearance → set the font to one of the installed nerd fonts (Meslo/Victor/Inconsolata) so devicons and `lsd` glyphs render.
