#based on the RobbyRussell theme
PROMPT='%{$fg_bold[green]%}♺ %{$fg_bold[red]%}%p %{$fg[yellow]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{%F{red}%}*%{%f%k%b%}%{$fg[blue]%})"
