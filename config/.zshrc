# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/noah/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# imported from bashrc
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export VISUAL=hx
export EDITOR=hx
export PATHBACK="${PATH}"
export PATH="${PATH}:/home/noah/programs"

source "$HOME/.cargo/env"
source ~/.zsh_aliases
source ~/.zsh_gh_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# eval "$(zellij setup --generate-completion zsh)"

source /home/noah/.config/broot/launcher/bash/br
