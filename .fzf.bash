# Setup fzf
# ---------
if [[ ! "$PATH" == *`brew --prefix`/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}`brew --prefix`/opt/fzf/bin"
fi

# Auto-completion
# ---------------
source "`brew --prefix`/opt/fzf/shell/completion.bash"

# Key bindings
# ------------
source "`brew --prefix`/opt/fzf/shell/key-bindings.bash"
