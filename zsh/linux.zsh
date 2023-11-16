alias open="xdg-open"

export DOCKER_HOST="unix:///home/gualcasas/.docker/desktop/docker.sock"

export BREW_PREFIX="/home/linuxbrew/.linuxbrew"
eval "$($BREW_PREFIX/bin/brew shellenv)"               # load brew
FPATH="$BREW_PREFIX/share/zsh/site-functions:${FPATH}" # load brew completions

export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# load terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/linuxbrew/.linuxbrew/Cellar/terraform/1.6.4/bin/terraform terraform
