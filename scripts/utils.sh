# get curret os:
# "ubuntu"
# "fedora"
# "macos"
# "unknown"
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

# eval_if_os "{os}" "{command}"
#
# execute {command} if current os matches {os}
# * "fedora"
# * "ubuntu"
# * "macos"
# * "linux" - this targets both "fedora" and "ubuntu"
eval_if_os() {
  local os="$1"
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

# brew_ensure_installed "{cmd}" "{custom_install_cmd}"
#
# install {cmd} with 'brew install {cmd}' if {cmd} not found.
# if {custom_install_cmd} provided, use that command instead of 'brew install'
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
