## =============================
## Pawsh ZSH Theme
## =============================
# =============================================================================
# Pawsh — minimal, standalone zsh prompt (zsh >= 5.3, no framework required)
#
#   >ﻌ< project                                  (venv) [main +1 ~2 ?3 ↑1]
#
# Left:   cat face (yellow = last command ok, red = failed) + directory name.
# Right:  vi mode, virtualenv and the whole git block, git wrapped in [ ].
#
# Install:   source /path/to/pawsh.zsh-theme    (from ~/.zshrc)
# Colors:    named ANSI colors only (black..white), so everything follows the
#            palette of your terminal theme. No hex / 256 / truecolor values.
# Config:    PAWSH_FACE   prompt symbol (default: >ﻌ<)
# =============================================================================

setopt prompt_subst transient_rprompt
autoload -Uz add-zle-hook-widget

(( ${+PAWSH_FACE} )) || typeset -g PAWSH_FACE='>ﻌ<'

# Prevent virtualenv's activate script from prepending its own "(env)" prefix.
export VIRTUAL_ENV_DISABLE_PROMPT=1

typeset -g _pawsh_face='' _pawsh_dir='' _pawsh_vi='' _pawsh_venv=''
typeset -g _pawsh_git='' _pawsh_right=''

# -----------------------------------------------------------------------------
# Git: one `git status` call per prompt, rendered as a single [ ] block.
#   [branch +N ~N -N ?N !N ↑N ↓N state]
#   +N staged   ~N modified   -N deleted   ?N untracked   !N conflicts
#   ↑N ahead    ↓N behind     merge / rebase / cherry-pick / bisect
# Branch color: green = clean, yellow = dirty, red = conflicts.
# -----------------------------------------------------------------------------
_pawsh_git_update() {
  _pawsh_git=''

  local out
  out=$(command git --no-optional-locks status --porcelain=2 --branch 2>/dev/null) || return

  local line branch='' oid='' ab xy
  local -i ahead=0 behind=0 staged=0 modified=0 deleted=0 untracked=0 conflicts=0

  for line in "${(@f)out}"; do
    case $line in
      '# branch.oid '*)  oid=${line#'# branch.oid '} ;;
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.ab '*)
        ab=${line#'# branch.ab '}          # "+A -B"
        ahead=${${ab%% *}#+}
        behind=${${ab##* }#-}
        ;;
      '1 '*|'2 '*)
        xy=${line[3,4]}
        [[ ${xy[1]} != . ]] && (( ++staged ))
        if [[ ${xy[2]} == D ]]; then
          (( ++deleted ))
        elif [[ ${xy[2]} != . ]]; then
          (( ++modified ))
        fi
        ;;
      '? '*) (( ++untracked )) ;;
      'u '*) (( ++conflicts )) ;;
    esac
  done

  local name=$branch color=green
  [[ $branch == '(detached)' ]] && name=${oid[1,7]}
  name=${name//\%/%%}

  if (( conflicts )); then
    color=red
  elif (( staged || modified || deleted || untracked )); then
    color=yellow
  fi

  local s=''
  (( staged ))    && s+=" %F{green}+${staged}%f"
  (( modified ))  && s+=" %F{yellow}~${modified}%f"
  (( deleted ))   && s+=" %F{red}-${deleted}%f"
  (( untracked )) && s+=" %F{magenta}?${untracked}%f"
  (( ahead ))     && s+=" %F{cyan}↑${ahead}%f"
  (( behind ))    && s+=" %F{red}↓${behind}%f"
  (( conflicts )) && s+=" %B%F{red}!${conflicts}%f%b"

  local gd
  gd=$(command git rev-parse --git-dir 2>/dev/null)
  if   [[ -d $gd/rebase-merge || -d $gd/rebase-apply ]]; then s+=" %F{yellow}rebase%f"
  elif [[ -f $gd/MERGE_HEAD ]];       then s+=" %F{yellow}merge%f"
  elif [[ -f $gd/CHERRY_PICK_HEAD ]]; then s+=" %F{yellow}cherry-pick%f"
  elif [[ -f $gd/BISECT_LOG ]];       then s+=" %F{yellow}bisect%f"
  fi

  _pawsh_git="[%F{$color}${name}%f${s}]"
}

# Joins the non-empty right-side pieces with single spaces.
_pawsh_build_right() {
  local -a parts
  [[ -n $_pawsh_vi   ]] && parts+=$_pawsh_vi
  [[ -n $_pawsh_venv ]] && parts+=$_pawsh_venv
  [[ -n $_pawsh_git  ]] && parts+=$_pawsh_git
  _pawsh_right=${(j: :)parts}
}

# -----------------------------------------------------------------------------
# Runs before every prompt. Everything is computed here, so PROMPT itself only
# expands variables (no subshells while redrawing).
# -----------------------------------------------------------------------------
_pawsh_precmd() {
  local last=$?          # must stay first: exit status of the previous command

  local color=yellow
  (( last )) && color=red
  _pawsh_face="%F{$color}${PAWSH_FACE}%f%(!. %B%F{red}#%f%b.) "

  _pawsh_dir=''
  local d=''
  if [[ $PWD == / ]]; then
    d=/
  elif [[ $PWD != $HOME ]]; then
    d=${PWD:t}
  fi
  [[ -n $d ]] && _pawsh_dir="%F{blue}${d//\%/%%}%f "

  _pawsh_vi=''

  _pawsh_venv=''
  if [[ -n $VIRTUAL_ENV ]]; then
    local v=${VIRTUAL_ENV:t}
    [[ $v == (.venv|venv|env) ]] && v=${VIRTUAL_ENV:h:t}
    _pawsh_venv="%F{magenta}(${v//\%/%%})%f"
  fi

  _pawsh_git_update
  _pawsh_build_right
}

# Run first so $? is still the user's last command.
precmd_functions=(_pawsh_precmd ${precmd_functions:#_pawsh_precmd})

# -----------------------------------------------------------------------------
# Vi mode indicator (only shown in command mode)
# -----------------------------------------------------------------------------
_pawsh_keymap_select() {
  _pawsh_vi=''
  [[ $KEYMAP == vicmd ]] && _pawsh_vi='%B(N)%b'
  _pawsh_build_right
  zle reset-prompt
}
add-zle-hook-widget keymap-select _pawsh_keymap_select

PROMPT='${_pawsh_face}${_pawsh_dir}'
RPROMPT='${_pawsh_right}'

