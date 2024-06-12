# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings (Emacs)
bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Hooks
function do-ls() {emulate -L zsh; ls;}
function checkwd() {
  emulate -L zsh
}

function checkjobs() {
  emulate -L zsh
  if is not empty $(jobs); then
    export JOBS=''
  else
    export JOBS=''
  fi
}

# add-zsh-hook chpwd do-ls
add-zsh-hook preexec checkjobs
add-zsh-hook precmd checkjobs
