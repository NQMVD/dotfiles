# Lines configured by zsh-newuser-install
export HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# bindkey -v
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

# --- Variables ---
export VISUAL=hx
export EDITOR=hx
export PATH="/home/noah/programs:$PATH"

export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

export TICK="$(echo ':heavy_check_mark:' | gum format -t emoji)"
export FAIL="$(echo ':x:' | gum format -t emoji)"
export MINUS="$(echo ':heavy_minus_sign:' | gum format -t emoji)"
export PLUS="$(echo ':heavy_plus_sign:' | gum format -t emoji)"
export CIRCLE="$(echo ':o:' | gum format -t emoji)"
export BANG="$(echo ':heavy_exclamation_mark:' | gum format -t emoji)"

# --- evals ---
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval $(thefuck --alias)
# eval "$(zellij setup --generate-completion zsh)"
eval "$(fzf --zsh)"
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    # hmm)          fzf --preview "bat -n --color=always --line-range :500 {}" --query '*.hmm' "$@" ;;
    # hmm)          fd  --type f --extension hmm | fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    hmm)          fd  --type f --extension hmm ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

source /home/noah/.config/broot/launcher/bash/br
source "$HOME/.cargo/env"
# source "$(redo alias-file)"
source ~/.zsh_gh_completion

# --- Aliases ---
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
alias mv='mv -v'
alias rm='rm -vr'

# sys info
alias cls='clear; fetchit'
alias neo='neofetch'
alias dim='echo "$(tput cols) $(tput lines)"'
alias inf='fetchit; echo "Dims: $(tput cols) $(tput lines)"'
alias da='du -sch'
alias df='df -h'
alias free='free -mt'
alias ip='command ip -color=auto'
alias userlist='cut -d: -f1 /etc/passwd'
alias probe='sudo -E hw-probe -all -upload'

# apt
alias in='sudo apt install'
alias update='topgrade --tmux --no-retry'

# programs
# alias bat='batcat'
alias lg=lazygit
alias vim='nvim'
alias pue='pueue'
alias cht='cht.sh'
alias wget='wget -c'
alias ai='gh copilot suggest'
alias sun='sunbeam'
alias todo='taskell'
alias hmm='h-m-m'

alias logd='gum log -s -l debug -- '
alias logi='gum log -s -l info -- '
alias logw='gum log -s -l warn -- '
alias loge='gum log -s -l error -- '
alias logtd='gum log -t TimeOnly -s -l debug -- '
alias logti='gum log -t TimeOnly -s -l info -- '
alias logtw='gum log -t TimeOnly -s -l warn -- '
alias logte='gum log -t TimeOnly -s -l error -- '

alias zain='zellij -s main || zellij a main || echo "Excuse you?"'

alias froze='freeze -c full'

# other
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'

alias conf='hx ~/.zshrc && source ~/.zshrc'
alias zsrc='source ~/.zshrc'

#########################################################################################

# --- functions ---

matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4;        letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }


pcp() {
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 | awk '{
		count += $NF
	    if (count % 10 == 0) {
	       percent = count / total_size * 100
	       printf "%3d%% [", percent
	       for (i=0;i<=percent;i++)
	          printf "="
	       printf ">"
	       for (i=percent;i<100;i++)
	          printf " "
	       printf "]\r"
	    }
	 }
	 END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

pmv() {
	strace -q -ewrite mv -- "${1}" "${2}" 2>&1 | awk '{
		count += $NF
	    if (count % 10 == 0) {
	       percent = count / total_size * 100
	       printf "%3d%% [", percent
	       for (i=0;i<=percent;i++)
	          printf "="
	       printf ">"
	       for (i=percent;i<100;i++)
	          printf " "
	       printf "]\r"
	    }
	 }
	 END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

prm() {
	strace -q -ewrite rm -- "${1}" "${2}" 2>&1 | awk '{
		count += $NF
	    if (count % 10 == 0) {
	       percent = count / total_size * 100
	       printf "%3d%% [", percent
	       for (i=0;i<=percent;i++)
	          printf "="
	       printf ">"
	       for (i=percent;i<100;i++)
	          printf " "
	       printf "]\r"
	    }
	 }
	 END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

lexc() {
    local file_path="$1"

    # Check if the file exists
    if [ ! -f "$file_path" ]; then
        echo "File not found: $file_path"
        return 1
    fi

    # Prepend shebang
    local temp_file=$(mktemp)
    echo '#!/bin/luajit' > "$temp_file"
    cat "$file_path" >> "$temp_file"
    mv "$temp_file" "$file_path"

    # Make the file executable
    chmod +x "$file_path"

    echo "File $file_path is now executable with Luajit."
}

wannareboot() {
	# check for minecraft server, cargo

	if ps aux | rg 'java'; then
		echo "Minecraft Server still running, abording..."
		exit 1
	fi

	if ps aux | rg 'cargo'; then
		echo "cargo still running, abording..."
		exit 1
	fi

	echo "Nothing important running, ready to reboot!"
	sleep 1
	sudo reboot now
}

state() {
	local MS=$(echo 'UP')
	echo "Mincraft Server: $MS"
}

# --- Startup ---
# cbonsai -p

