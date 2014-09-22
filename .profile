# Path
##########

export PATH=~/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

# Aliases
##########

# zsh
alias ohmyzsh="subl ~/.oh-my-zsh"
alias zshplugins='ll ~/.oh-my-zsh/plugins'
alias zshconfig="vim ~/.zshrc"
alias szsh='source ~/.zshrc'

# profile
alias epr="vim ~/.profile"
alias eprl="vim ~/.profile.local"

# Editors
alias subl=subl
alias v='vim'
alias mvm='mvim'
alias sublconf='~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User'

# Listing
alias l='ls -F'
alias ll='ls -aloh'
alias lt='ls -alort'

# Whippet
alias whippetmulti='sudo whippet --multisite -p 80'
alias whippetlocal='sudo whippet -p 80'

# Git
alias gad='git add .'
alias gmsg='git commit --message'
alias gcd='git checkout develop'
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

# Rails
alias zc='zeus console'

# Heroku
alias gphm='git push heroku master'
alias heroku_cc='heroku run rails runner Rails.cache.clear'
alias heroku_m='heroku run rake db:migrate && heroku restart'

# Maintenance
function rmtemp(){
  if [ -s *~ ]; then
    rm *~
  fi
}
alias janitor='sudo periodic daily weekly monthly; cd ~; rmtemp; cd -'

# Display the top N used commands
function top_commands() {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -${1:-20}
}

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
