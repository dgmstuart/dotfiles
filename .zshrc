# !/bin/zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

plugins=(git bundler heroku npm)

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

. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

source ~/.iterm2_shell_integration.zsh
