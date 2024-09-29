# --- evals ---

# Prompt
# TODO: add toggle switch for this

# eval "$(oh-my-posh init zsh --config $HOME/.config/zsh/ohmyposh/bubblesextra.omp.toml)"
eval "$(starship init zsh)"


# eval "$(fzf --zsh)"
eval "$(zoxide init zsh --no-cmd)"
# source "$HOME/.config/broot/launcher/bash/br"

# FIX: warns with "can only be called from completion function"
# eval "$(zellij setup --generate-completion zsh)"

# if [[ -z "$ZELLIJ" ]]; then
#     if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
#         zellij attach -c
#     else
#         zellij
#     fi

#     if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
#         exit
#     fi
# fi
