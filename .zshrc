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
plugins=(git osx bundler heroku rails rails3 ruby sublime nanoc)

source $ZSH/oh-my-zsh.sh

source ~/.zsh/aliases.zsh

# Syntax highlighting for less:
export LESSOPEN="| src-hilite-lesspipe.sh %s" 
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"


# Paths
source ~/.project_paths
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
