# Path
##########
PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

PATH=$PATH:/opt/homebrew/bin:/opt/homebrew/sbin

if [ -d "/Applications/Postgres.app" ]; then
  PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin";
fi

# Node
PATH=~/.npm-global/bin:$PATH

# Golang
export GOPATH=~/go
PATH=$PATH:$GOPATH/bin

# Composer
export COMPOSERPATH=~/.composer
PATH=$PATH:$COMPOSERPATH/vendor/bin

export PATH

# Other application env variables
#################################

# Perl
export PERL5LIB=/usr/local/Cellar/git/2.6.3/lib/perl5/site_perl

# Rust
if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env";
fi

export DEV_DIR=$HOME/dev

# Environment
##############
export VISUAL='vim'
export EDITOR='vim'
export LANG="en_GB.UTF-8"

# Syntax highlighting for less:
# Install with "brew install source-highlight"
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"

# Decrease the lag when switching to normal mode on the command line:
export KEYTIMEOUT=1

# Man syntax highlighting
#########################
export LESS_TERMCAP_mb=$(printf '\e[31m')    # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[35m')    # enter double-bright mode – magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[07;33m') # enter standout mode – yellow background
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan

# Tmux
#######
# Disable auto-renaming of windows:
export DISABLE_AUTO_TITLE=true

# File limits
#############
ulimit -n 200000
ulimit -u 2048

# load travis
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# Per-system profile
[ -r ~/.profile.local ] && . ~/.profile.local
