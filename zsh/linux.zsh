alias open="xdg-open"

# I'm not sure why it's not automatically set in fedora, but if we don't set it
# bun uses a wrong timezone
export TZ="America/Monterrey"

export DOCKER_HOST="unix://$HOME/.docker/desktop/docker.sock"

export PKG_CONFIG_PATH="/usr/lib64/pkgconfig:/usr/share/pkgconfig"

export ANDROID_HOME="$HOME/Android/Sdk"

export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
eval "$($BREW_PREFIX/bin/brew shellenv)"               # load brew
FPATH="$BREW_PREFIX/share/zsh/site-functions:${FPATH}" # load brew completions

export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# load terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/terraform/1.6.4/bin/terraform terraform

# required for pylint to work
# export PYTHONPATH=$HOME/.local/lib/python3.11/site-packages
