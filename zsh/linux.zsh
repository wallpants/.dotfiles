alias open="xdg-open"

# I'm not sure why it's not automatically set in fedora, but if we don't set it
# bun uses a wrong timezone
export TZ="America/Monterrey"

export PKG_CONFIG_PATH="/usr/lib64/pkgconfig:/usr/share/pkgconfig"

export ANDROID_HOME="$HOME/Android/Sdk"

export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
if [ -x "$BREW_PREFIX/bin/brew" ]; then
  eval "$($BREW_PREFIX/bin/brew shellenv)"               # load brew
  FPATH="$BREW_PREFIX/share/zsh/site-functions:${FPATH}" # load brew completions
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# required for pylint to work
# export PYTHONPATH=$HOME/.local/lib/python3.11/site-packages
