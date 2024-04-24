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

export VISUAL=helix
export EDITOR=helix
export PATHBACK="${PATH}"
export PATH="${PATH}:/home/noah/programs"
export PATH="${PATH}:/home/noah/.cargo/bin"

# source ~/.zsh_aliases
source ~/.zsh_gh_completion
source /home/noah/.config/broot/launcher/bash/br

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# eval "$(zellij setup --generate-completion zsh)"

# --- aliases ---
# Change Dir
alias c='z'
alias cc='z -'
alias ..='z ..'
alias ...='z ../..'

# other dir commands
alias md='mkdir -p'
alias rd=rmdir

# ls aliases to eza
alias l='eza --icons --oneline --color=always --group-directories-first'
alias ll='eza --all --icons --oneline --color=always --group-directories-first'
alias la='eza -lah --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first'
alias ltt='eza --tree --level=3 --color=always --group-directories-first'
alias lttt='eza --tree --level=4 --color=always --group-directories-first'
alias lta='eza --all --tree --level=2 --color=always --group-directories-first'
alias ltta='eza --all --tree --level=3 --color=always --group-directories-first'
alias lttta='eza --all --tree --level=4 --color=always --group-directories-first'

# file commands
alias cp='cp -vR'
alias rm='rm -vr'
alias mv='mv -v'

# sys info
alias cls='clear && neofetch'
alias neo='neofetch'
alias da='du -ch -d 1'
alias df='df -h'
alias free='free -mt'
alias ip='command ip -color=auto'
alias userlist='cut -d: -f1 /etc/passwd'
alias probe='sudo -E hw-probe -all -upload'
alias bon='cbonsai -l -t 0.001 -m welcome back! -M 6 -L 40'
alias hi='zellij k welcome; zellij -s welcome --layout=greet'

# pacman (and yay)
alias in='yay -S --noconfirm'
alias up='yay -Syu' # dont add noconfirm here!

# programs
alias lg=lazygit
alias vim='nvim'
alias hx='helix'
alias hxo='FILE=$(gum file -a || exit 1) && helix $FILE'
alias cht='cht.sh'
alias wget='wget -c'
alias ai='gh copilot suggest'
alias tod='hx ~/TODO.md'
alias todo='hx ./TODO.md'
alias con='wezterm ssh noah@mondkuchen.tech'

# other
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'
alias zsrc='source ~/.zshrc'

# functions

matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4;        letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }

function rep() {
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      (cd "$dir" || exit; starship prompt | sed -E 's/%\{[^}]*%}//g' | sed 's/..$//')
      echo ""
    fi
  done
}

function conf() {
  local choice=$(gum choose "zsh" "zellij" "starship")

  case "$choice" in
    zsh) helix ~/.zshrc ;;
    zellij) helix ~/.config/zellij/config.kdl ;;
    starship) helix ~/.config/starship.toml ;;
  esac
}


# --- startup ---
clear
neofetch
