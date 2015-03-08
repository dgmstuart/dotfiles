# Custom prompt:
export PS1='[\s] $(tput setaf 3)\w $(tput setaf 4)$ $(tput sgr0)'

# Show colours
alias ls='ls -G'

# git autocompletion in git 1.8.x
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash  ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash 
fi

source $HOME/.profile
