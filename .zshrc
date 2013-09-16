# !/bin/zsh
# vim: set filetype=zsh

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git rvm osx bundler heroku rails rails3 ruby sublime nanoc npm node)

source $ZSH/oh-my-zsh.sh

source $HOME/.profile