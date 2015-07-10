# Path
##########
export PATH=~/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

# Environment
##############
export VISUAL='vim'
export EDITOR='vim'

# Syntax highlighting for less:
# Install with "brew install source-highlight"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"

# Decrease the lag when switching to normal mode on the command line:
export KEYTIMEOUT=1

# Golang
########
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# rbenv
########
# Use Homebrew's directories rather than ~/.rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# Enable rbenbv shims and autocompletions
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Per-system profile
[ -r ~/.profile.local ] && . ~/.profile.local
