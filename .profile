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

# profile
alias epr="vim .profile"
alias eprl="vim .profile.local"

# Editors
alias subl=subl
alias v='vim'
alias mvm='mvim'

# Listing
alias l='ls -F'
alias ll='ls -alo'
alias lt='ls -alort'
alias lh='ls -alh'

# Whippet
alias whippetmulti='sudo whippet --multisite -p 80'
alias whippetlocal='sudo whippet -p 80'

# Git
alias gce='git config -e'
alias gitsubmodulefoo='git submodule sync;git submodule update --init --recursive'
alias gittest='git push origin +HEAD:testing'
alias gitemptycommit='git commit --allow-empty -m Empty'

function gitsubplugin(){
  if [ -d "plugins" ]; then
    git submodule add git@git.dxw.net:wordpress-plugins/$1 plugins/$1
  else
    echo "The plugins directory doesn't exist." 
    echo "Are you sure you're in the right place?"
  fi
}

# Environment 
##############
export VISUAL='subl'
export EDITOR='vi'

# Syntax highlighting for less:
# Install with "brew install source-highlight"
export LESSOPEN="| src-hilite-lesspipe.sh %s" 
export LESS='-R'
export MORE='-R'

# Disable the less history file
export LESSHISTFILE="-"

## Per-system profile
[ -r ~/.profile.local ] && . ~/.profile.local