# !/bin/zsh
# vim: set filetype=zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dgms"

plugins=(git rbenv osx bundler heroku rails ruby node sublime nanoc npm node)

source $ZSH/oh-my-zsh.sh

# Make zsh play nice with rake
alias rake="noglob rake"

source $HOME/.profile
