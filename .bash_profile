export ENV="$HOME/.bashrc"
source $ENV

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash  ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash 
fi

NO_COLOR="\033[0m"
GRAY="\033[90m"

if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  . /usr/local/etc/bash_completion.d/git-completion.bash;
  PS1='\W $(__git_ps1 "$GRAY%s$NO_COLOR ")\$ ';
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


echo "BAAAAR"