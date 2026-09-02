source ~/.dotfiles/scripts/utils.sh

# source .zsh files in case brew is installed
eval_if_os "linux" "source ~/.dotfiles/zsh/linux.zsh"
eval_if_os "macos" "source ~/.dotfiles/zsh/mac.zsh"

# Ensure brew & zsh are installed
if ! command -v brew &>/dev/null; then
    eval_if_os "fedora" "sudo dnf update"
    eval_if_os "fedora" "sudo dnf group install development-tools -y"
    eval_if_os "fedora" "sudo dnf install zsh -y"

    eval_if_os "ubuntu" "sudo apt update"
    eval_if_os "ubuntu" "sudo apt install build-essential -y"
    eval_if_os "ubuntu" "sudo apt install zsh -y"

    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # source .zsh files again to load brew if newly installed
    eval_if_os "linux" "source ~/.dotfiles/zsh/linux.zsh"
    eval_if_os "macos" "source ~/.dotfiles/zsh/mac.zsh"
fi

brew_ensure_installed "go"
brew_ensure_installed "delta" "brew install git-delta"
brew_ensure_installed "lsd"
brew_ensure_installed "tree"
brew_ensure_installed "zsh-syntax-highlighting"
brew_ensure_installed "zsh-autosuggestions"
brew_ensure_installed "uv"
brew_ensure_installed "doctl"
brew_ensure_installed "viu"
brew_ensure_installed "lazygit"
brew_ensure_installed "nvim" "brew install neovim"
brew_ensure_installed "dotenv-linter"
brew_ensure_installed "unzip"
# brew ignores untrusted third-party taps, so trust it explicitly
brew_ensure_installed "bun" "brew tap oven-sh/bun && brew trust oven-sh/bun && brew install bun"
brew_ensure_installed "fd"
brew_ensure_installed "rg" "brew install ripgrep"
brew_ensure_installed "tree-sitter" "brew install tree-sitter-cli"
# czg's brew formula depends on brew's node, which HOMEBREW_FORBIDDEN_FORMULAE forbids (nvm manages node), so install it with bun
[ -x "$HOME/.bun/bin/czg" ] || bun install -g czg
eval_if_os "macos" "brew_ensure_installed 'gsed' 'brew install gnu-sed'"
# brew_ensure_installed "supabase" "brew install supabase/tap/supabase"

brew_ensure_installed "nvm"
# source .zsh files again to load nvm
eval_if_os "linux" "source ~/.dotfiles/zsh/linux.zsh"
eval_if_os "macos" "source ~/.dotfiles/zsh/mac.zsh"
# node is needed by the npm-based mason packages installed in nvim-sync.sh
brew_ensure_installed "node" "nvm install 24"
