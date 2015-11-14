# Path
##########
export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
# Use globally installed node modules:
export PATH=$PATH:~/.npm-global/bin

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

# Composer
export COMPOSERPATH=~/.composer
export PATH=$PATH:$COMPOSERPATH/vendor/bin

# Man syntax highlighting
#########################
export LESS_TERMCAP_mb=$(printf '\e[31m')    # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[35m')    # enter double-bright mode – magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[07;33m') # enter standout mode – yellow background
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan

# rbenv
########
# Use Homebrew's directories rather than ~/.rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# Enable rbenbv shims and autocompletions
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Tmux
#######
# Disable auto-renaming of windows:
export DISABLE_AUTO_TITLE=true

# Per-system profile
[ -r ~/.profile.local ] && . ~/.profile.local
