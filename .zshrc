# !/bin/zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Write oh-my-zsh cache files to cache folder instead of home
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

plugins=(heroku npm)

source $ZSH/oh-my-zsh.sh

source $HOME/.profile
source $HOME/.zsh/functions
source $HOME/.zsh/aliases
# N.B: Aliases are also sourced in .zshenv so that they are available in non-interactive shells like vim
source $HOME/.zsh/dgms.zsh-theme
source $HOME/.zsh/explicit_aliases.sh

# Enable the hash key
bindkey -s '^[3' \#

source ~/k/k.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ASDF_DIR="$HOME/.asdf"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="${ASDF_DIR}/bin:$PATH"
export PATH="${ASDF_DIR}/shims:$PATH"

source ~/.iterm2_shell_integration.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm alias default node #  default to the latest installed version
nvm use default --slient

eval "$(direnv hook zsh)"
