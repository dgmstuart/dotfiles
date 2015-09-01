# vim: syntax=zsh
PROMPT='%{$fg_bold[green]%}♺ %{$fg[yellow]%}%~$(git_prompt_info) %{$fg[blue]%}ruby-$(rbenv version-name) %{$fg[yellow]%}»%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*"
