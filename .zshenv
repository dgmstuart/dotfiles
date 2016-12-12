# Always include aliases and functions:
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

# Use Homebrew's directories rather than ~/.rbenv
export RBENV_ROOT=/usr/local/var/rbenv

# Enable rbenbv shims and autocompletions
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
