precmd_functions=(zvm_init "${(@)precmd_functions:#zvm_init}")
precmd_functions+=(set-long-prompt)
zvm_after_init_commands+=("zle -N zle-line-finish; zle-line-finish() { set-short-prompt }")

set-long-prompt() {
    PROMPT=$(starship prompt)
}

export COLUMNS=$(($COLUMNS + ($COLUMNS*0.1)))
set-short-prompt() {
  if [[ $PROMPT != '%# ' ]]; then
    PROMPT="$(starship prompt --profile transient)"
    zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
  fi
}

zle-keymap-select() {
    set-short-prompt
}
zle -N zle-keymap-select

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt; return 130' INT
