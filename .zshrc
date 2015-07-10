# !/bin/zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dgms"

plugins=(git rbenv osx bundler heroku rails ruby rake node sublime nanoc npm)

source $ZSH/oh-my-zsh.sh

source $HOME/.profile
source $HOME/.zsh/functions
# N.B: Aliases are sourced in .zshenv so that they are available in non-interactive shells

source ~/k/k.sh
alias ll="k -Ah"

