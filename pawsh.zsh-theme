## =============================
## Pawsh ZSH Theme
## =============================

autoload -Uz colors && colors
autoload -Uz add-zsh-hook

## Git: prefix, suffix, dirty/clean
ZSH_THEME_GIT_PROMPT_PREFIX="%{${fg_bold[blue]}%}git:(%{${fg[red]}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{${reset_color}%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{${fg[blue]}%}) %{${fg[yellow]}%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{${fg[blue]}%})"

## -----------------------------
## Fast git prompt (single git read)
## -----------------------------
function pawsh_git_info {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local git_data
  git_data=$(git status --porcelain=2 --branch 2>/dev/null)

  local branch=""
  local ahead=0 behind=0
  local staged=0 modified=0 untracked=0 deleted=0 conflicts=0

  while IFS= read -r line; do
    case "$line" in

      "# branch.head "*)
        branch=${line#"# branch.head "}
      ;;

      "# branch.ab "*)
        local ab=${line#"# branch.ab +"}
        ahead=${ab%% -*}
        behind=${ab##* -}
      ;;

      "1 "*|"2 "*)
        local xy=${line:2:2}

        [[ ${xy:0:1} != "." ]] && ((staged++))
        [[ ${xy:1:1} != "." ]] && ((modified++))

        [[ $line == *" D."* || $line == *".D"* ]] && ((deleted++))
      ;;

      "? "*)
        ((untracked++))
      ;;

      "u "*)
        ((conflicts++))
      ;;

    esac
  done <<< "$git_data"

  local dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"

  if (( staged > 0 || modified > 0 || untracked > 0 || conflicts > 0 )); then
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

## -----------------------------
## Detailed right-side git info
## -----------------------------
function git_complete_status {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local git_data
  git_data=$(git status --porcelain=2 --branch 2>/dev/null)

  local branch=""
  local ahead=0 behind=0
  local staged=0 modified=0 untracked=0 deleted=0 conflicts=0

  while IFS= read -r line; do
    case "$line" in

      "# branch.head "*)
        branch=${line#"# branch.head "}
      ;;

      "# branch.ab "*)
        local ab=${line#"# branch.ab +"}
        ahead=${ab%% -*}
        behind=${ab##* -}
      ;;

      "1 "*|"2 "*)
        local xy=${line:2:2}

        [[ ${xy:0:1} != "." ]] && ((staged++))
        [[ ${xy:1:1} != "." ]] && ((modified++))

        [[ $line == *" D."* || $line == *".D"* ]] && ((deleted++))
      ;;

      "? "*)
        ((untracked++))
      ;;

      "u "*)
        ((conflicts++))
      ;;

    esac
  done <<< "$git_data"

  local info="%{${fg[blue]}%}$branch%{${reset_color}%}"

  (( staged > 0 ))    && info+=" %{${fg[green]}%}+$staged%{${reset_color}%}"
  (( modified > 0 ))  && info+=" %{${fg[yellow]}%}~$modified%{${reset_color}%}"
  (( deleted > 0 ))   && info+=" %{${fg[red]}%}-$deleted%{${reset_color}%}"
  (( untracked > 0 )) && info+=" %{${fg[magenta]}%}?$untracked%{${reset_color}%}"
  (( ahead > 0 ))     && info+=" %{${fg[cyan]}%}↑$ahead%{${reset_color}%}"
  (( behind > 0 ))    && info+=" %{${fg[red]}%}↓$behind%{${reset_color}%}"
  (( conflicts > 0 )) && info+=" %{${fg_bold[red]}%}⚡$conflicts%{${reset_color}%}"

  local git_dir
  git_dir=$(git rev-parse --git-dir 2>/dev/null)

  [[ -f "$git_dir/MERGE_HEAD" ]] && info+=" %{${fg[yellow]}%}[MERGE]%{${reset_color}%}"
  [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]] && info+=" %{${fg[yellow]}%}[REBASE]%{${reset_color}%}"
  [[ -f "$git_dir/CHERRY_PICK_HEAD" ]] && info+=" %{${fg[yellow]}%}[CHERRY]%{${reset_color}%}"
  [[ -f "$git_dir/BISECT_LOG" ]] && info+=" %{${fg[yellow]}%}[BISECT]%{${reset_color}%}"

  echo "$info"
}

## -----------------------------
## Directory
## -----------------------------
function pawsh_dir_prompt {
  [[ "$PWD" == "$HOME" ]] && return
  echo "%{${fg[cyan]}%}${PWD:t}%{${reset_color}%} "
}

## -----------------------------
## Virtualenv
## -----------------------------
function virtualenv_prompt {
  [[ -n "$VIRTUAL_ENV" ]] || return
  echo "%{${fg_bold[blue]}%}[${VIRTUAL_ENV:t}]%{${reset_color}%} "
}

## -----------------------------
## Vi mode
## -----------------------------
function vi_mode_prompt {
  [[ "$KEYMAP" == vicmd ]] || return
  echo "%{${fg_bold[red]}%}[N]%{${reset_color}%} "
}

## -----------------------------
## Prompt
## -----------------------------
PROMPT='%(?:%F{#4ECDC4}>ﻌ<%f:%F{#EE4B4B}>ﻌ<%f) %(!.%{${fg[magenta]}%}#%{${reset_color}%}.)$(virtualenv_prompt)$(vi_mode_prompt)$(pawsh_dir_prompt)$(pawsh_git_info)'

RPROMPT='$(git_complete_status)'

## -----------------------------
## Vi mode refresh
## -----------------------------
function zle-keymap-select {
  zle reset-prompt
}

function zle-line-init {
  zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init
