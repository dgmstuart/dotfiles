# !/bin/zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

plugins=(git rbenv osx bundler heroku rails ruby rake node sublime nanoc npm)

source $ZSH/oh-my-zsh.sh

source $HOME/.profile
source $HOME/.zsh/functions
# N.B: Aliases are sourced in .zshenv so that they are available in non-interactive shells
source $HOME/.zsh/dgms.zsh-theme
source $HOME/.zsh/mandatory_aliases.sh
source $HOME/.zsh/explicit_aliases.sh

# Enable the hash key
bindkey -s '^[3' \#

source ~/k/k.sh
alias ll="k -Ah"

