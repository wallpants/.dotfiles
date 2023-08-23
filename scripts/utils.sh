#! /bin/bash

# get curret os
get_current_os() {
  if [ -f "/etc/os-release" ]; then
    source /etc/os-release
    case "$ID" in
    ubuntu)
      echo "ubuntu"
      ;;
    fedora)
      echo "fedora"
      ;;
    *)
      echo "unknown"
      ;;
    esac
  elif [ "$(uname)" == "Darwin" ]; then
    echo "macos"
  else
    echo "unknown"
  fi
}

# execute cmd if matching OS, "linux" matches both "ubuntu" and "fedora"
# usage: eval_if_os "macos" "echo 'hello from mac'"
eval_if_os() {
  local os="$1" # "fedora" | "ubuntu" | "macos" | "linux"
  local operation="$2"
  local current_os=$(get_current_os)

  if [[ "$os" == "linux" ]]; then
    if [[ !("$current_os" == "fedora" || "$current_os" == "ubuntu") ]]; then
      return
    fi
  elif [[ "$current_os" != "$os" ]]; then
    return
  fi

  eval "$operation"
}

# install package if not found
# usage: brew_ensure_installed "viu"
brew_ensure_installed() {
  local package=$1
  local custom_install_cmd=$2
  # check if the package is installed
  if ! command -v "$package" &>/dev/null; then
    echo "$package is not installed. Installing..."
    # use custom install cmd if specified
    if [[ -n $custom_install_cmd ]]; then
      eval "$custom_install_cmd"
    else
      brew install "$package"
    fi
  fi
}
