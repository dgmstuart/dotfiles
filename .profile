# Path
##########

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

# Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# Aliases 
##########

# zsh
alias ohmyzsh="subl ~/.oh-my-zsh"
alias zshplugins='ll ~/.oh-my-zsh/plugins'
alias zshconfig="vim ~/.zshrc"
alias szsh='source ~/.zshrc'

# Editors
alias subl=subl
alias v='vim'
alias mvm='mvim'

# Listing
alias l='ls -F'
alias ll='ls -alo'
alias lt='ls -alort'
alias lh='ls -alh'

# Projects
alias soldn='cd ~/Dev/swingoutlondon'
alias ssoldn='soldn; subl .'

# Git
alias gce='git config -e'


# Environment 
##############
export VISUAL='subl'
export EDITOR='vi'

# Syntax highlighting for less:
export LESSOPEN="| src-hilite-lesspipe.sh %s" 
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"