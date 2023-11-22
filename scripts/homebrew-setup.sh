source ~/.dotfiles/scripts/utils.sh

# source .zsh files in case brew is installed
eval_if_os "linux" "source ~/.dotfiles/zsh/linux.zsh"
eval_if_os "macos" "source ~/.dotfiles/zsh/mac.zsh"

# Ensure brew & zsh are installed
if ! command -v brew &>/dev/null; then
    eval_if_os "fedora" "sudo dnf update"
    eval_if_os "fedora" "sudo dnf groupinstall 'Development Tools' -y"
    eval_if_os "fedora" "sudo dnf install zsh -y"

    eval_if_os "ubuntu" "sudo apt update"
    eval_if_os "ubuntu" "sudo apt install build-essential -y"
    eval_if_os "ubuntu" "sudo apt install zsh -y"

    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # source .zsh files again to load brew if newly installed
    eval_if_os "linux" "source zsh/linux.zsh"
    eval_if_os "macos" "source zsh/mac.zsh"
fi

brew_ensure_installed "go"
brew_ensure_installed "pipenv"
brew_ensure_installed "pyenv"
brew_ensure_installed "viu"
brew_ensure_installed "lazygit"
brew_ensure_installed "nvim" "brew install neovim"
brew_ensure_installed "doctl"
brew_ensure_installed "frpc"
brew_ensure_installed "unzip"
brew_ensure_installed "bun" "brew tap oven-sh/bun && brew install bun"
brew_ensure_installed "pnpm"
brew_ensure_installed "fd"
brew_ensure_installed "terraform" "brew tap hashicorp/tap && brew install hashicorp/tap/terraform"
brew_ensure_installed "rg" "brew install ripgrep"
eval_if_os "macos" "brew_ensure_installed 'gsed' 'brew install gnu-sed'"
brew_ensure_installed "supabase" "brew install supabase/tap/supabase"

brew_ensure_installed "nvm"
# source .zsh files again to load nvm
eval_if_os "linux" "source ~/.dotfiles/zsh/linux.zsh"
eval_if_os "macos" "source ~/.dotfiles/zsh/mac.zsh"
brew_ensure_installed "node" "nvm install 18"
