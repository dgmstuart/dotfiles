# Path
##########

# /etc/paths adds the following:
#   /usr/bin
#   /bin
#   /usr/sbin
#   /sbin
#   /usr/local/bin

# I also have the following already in my path - haven't worked out where from yet:
#   /usr/local/git/bin
#   /usr/X11/bin

# It looks like the following don't actually need to be in the path after all...
#   export PATH=$PATH:/usr/local/heroku/bin
#   export PATH=$PATH:/usr/local/mysql/bin

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
alias soldn='cd ~/Sites/swingoutlondon'
alias ssoldn='soldn; subl .'

# Git
alias gce='git config -e'


# Environment 
##############

# Syntax highlighting for less:
export LESSOPEN="| src-hilite-lesspipe.sh %s" 
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"