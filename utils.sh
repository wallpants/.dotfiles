#! /bin/bash

# execute cmd if matching OS
# usage: eval_if_os "darwin" echo "hello from mac"
eval_if_os() {
  local os=$1 # "linux" | "darwin"
  local operation=$2
  if [[ $OSTYPE != $os* ]]; then return; fi
  eval "$operation"
}

# install package if not found
# usage: brew_ensure_installed "viu"
brew_ensure_installed() {
    local package=$1
    local custom_install_cmd=$3
    # check if the package is installed
    if ! command -v "$package" &> /dev/null; then
        echo "$package is not installed. Installing..."
        # use custom install cmd if specified
        if [[ -n $custom_install_cmd ]]; then
          eval "$custom_install_cmd"
        else
          brew install "$package"
        fi
    fi
}
