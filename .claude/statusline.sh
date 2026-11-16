#!/bin/bash
# Status line: current model + background job counts by state.
#
# Colours are ANSI indices rather than hex, so the terminal's own Solarized
# palette supplies them and they follow light/dark mode. In Solarized's ANSI
# mapping, bright red (91) is orange. Icons are Nerd Font Material Design
# circles, matching the md-check_circle used for passing specs in nvim.

input=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$input")
effort=$(jq -r '.effort.level // empty' <<<"$input")
counts=$(jq -r '.state' ~/.claude/jobs/*/state.json 2>/dev/null | sort | uniq -c)

esc=$'\e'
reset="${esc}[0m"
dim="${esc}[2m"

count() { echo "$counts" | awk -v s="$1" '$2==s{c=$1} END{print c+0}'; }

# segment <state> <icon> <ansi colour>: dimmed when the count is zero.
segment() {
  local n; n=$(count "$1")
  if [ "$n" -eq 0 ]; then
    printf '%s%s %s%s' "$dim" "$2" "$n" "$reset"
  else
    printf '%s[%sm%s %s%s' "$esc" "$3" "$2" "$n" "$reset"
  fi
}

[ -n "$effort" ] && effort=" ${dim}(${effort})${reset}"

printf '%s[38;2;215;119;87m󰚩 %s%s%s  %s  %s  %s\n' "$esc" "$model" "$reset" "$effort" \
  "$(segment working 󱥸 33)" \
  "$(segment blocked 󰋗 91)" \
  "$(segment done 󰗠 32)"
