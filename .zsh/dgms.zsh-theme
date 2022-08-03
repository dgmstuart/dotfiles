# vim: syntax=zsh
PROMPT='%{$fg[green]%}♺ %{$fg[yellow]%}%~$(git_prompt_info) %{$fg[blue]%}$(ruby -v | grep -o "ruby\s\?[0-9\.]*") %{$fg[yellow]%}»%{$reset_color%} '
RPROMPT='%{$fg[green]%}$(battery escape)%{$reset_color%} %{$fg[yellow]%}%T%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
