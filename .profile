# Path
##########

export PATH=~/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

# Aliases
##########

# zsh
alias ohmyzsh="~/.oh-my-zsh"
alias zshplugins='cd ~/.oh-my-zsh/plugins; ll'
alias zpr="vim ~/.zshrc"
alias szsh='source ~/.zshrc'

# profile
alias epr="vim ~/.profile"
alias eprl="vim ~/.profile.local"

# Editors
alias subl=subl
alias sublconf='~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User'
alias v='vim'
alias mvm='mvim'
alias vv='vim ~/.vimrc'

# Listing
alias l='ls -F'
alias ll='ls -aloh'
alias lt='ls -alort'

# Whippet
alias whippetmulti='sudo whippet-server --multisite -p 80'
alias whippetlocal='sudo whippet-server -p 80 -i 127.0.0.1'

# Git
alias gad='git add .'
alias gcad='gad; gca'
alias gasp='git add spec/spec_helper.rb'
alias grm='git rm'
alias msg='git commit --message'
alias gcd='git checkout develop'
alias gce='git config -e'
alias gitsubmodulefoo='git submodule sync;git submodule update --init --recursive'
alias gitemptycommit='git commit --allow-empty -m Empty'
alias tga='tig --all'
alias gittest='git push origin +HEAD:testing'
alias gp2p='git push origin +master:production'

# RSpec
alias rsp='rspec'

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
function newpost(){
  cd ${BLOG_HOME:?"Need to set BLOG_HOME to the location of the octopress blog directory"}
  output=$( rake new_post["$@"] )
  echo "$output"

  local return_code=$?
  if [ $return_code -eq 0 ]; then
    # Get the name of the file which was just created:
    post_path=$(grep -o 'source\/_posts\/.*\.markdown' <<< $output)
    # Stash all other posts (for faster generation)
    echo "Isolating post..."
    rake isolate["$post_path"]
    # Open with the cursor at the bottom of the header:
    vim -c 'normal G' $post_path
  fi
}
# blogposts: display the list of posts ordered by last modified time
# %m                           -- Last modified timestamp
# %N                           -- Quoted File name
# -exec stat -f "%m %N" {} \;  -- Outputs a timestamp at the beginning of the line for sorting
# cut -d ' ' -f2-              -- Returns only the second field in a space-delimited string
alias blogposts='find $BLOG_HOME/source/_posts/* -exec stat -f "%m %N" {} \; | sort -n | cut -d " " -f2-'
alias lastpost='find `blogposts` | tail -1 '
alias epost='vim `lastpost`'

# Consular
alias cs='consular start'

# Maintenance
function rmtemp(){
  if [ -s *~ ]; then
    rm *~
  fi
  if [ -s .*~ ]; then
    rm .*~
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
