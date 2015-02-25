# Path
##########

export PATH=~/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

# Aliases
##########

# zsh
alias ohmyzsh="subl ~/.oh-my-zsh"
alias zshplugins='ll ~/.oh-my-zsh/plugins'
alias zpr="vim ~/.zshrc"
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
alias gasp='git add spec/spec_helper.rb'
alias grm='git rm'
alias msg='git commit --message'
alias gcd='git checkout develop'
alias gce='git config -e'
alias gitsubmodulefoo='git submodule sync;git submodule update --init --recursive'
alias gittest='git push origin +HEAD:testing'
alias gitemptycommit='git commit --allow-empty -m Empty'
alias tga='tig --all'

function gitsubplugin(){
  if [ -d "plugins" ]; then
    git submodule add git@git.dxw.net:wordpress-plugins/$1 plugins/$1
  else
    echo "The plugins directory doesn't exist."
    echo "Are you sure you're in the right place?"
  fi
}

# Rails
alias zst='zeus start'
alias zc='zeus console'
alias zrr='zeus rake routes'
alias rdm='zeus rake db:migrate'

# Bundler
alias b='bundle'

# Heroku
alias gphm='git push heroku master'
alias heroku_cc='heroku run rails runner Rails.cache.clear'
alias heroku_m='heroku run rake db:migrate && heroku restart'

# Blog
alias rgd='rake gen_deploy'
function new_post(){
  cd ${BLOG_HOME:?"Need to set BLOG_HOME to the location of the octopress blog directory"}
  rake new_post["$@"]
}

# Consular
alias cs='consular start'

# Maintenance
function rmtemp(){
  if [ -s *~ ]; then
    rm *~
  fi
}
alias janitor='sudo periodic daily weekly monthly; cd ~; rmtemp; cd -'

# Display the top N used commands
function top_commands() {
  history | tail -2000 | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -${1:-20}
}

alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

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
