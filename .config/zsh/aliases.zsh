# --- direct aliases ---

# short ones
alias j='just'

alias c=__zoxide_z
alias zi=__zoxide_zi
alias cb='c -'
alias ..='c ..'

# short renames
alias fetch='fastfetch'
alias md='mkdir -p'
alias hmm='h-m-m'

alias x='helix'
alias hx='helix'
alias g='git'
alias lg='lazygit'

# ls...
EZAFLAGS='--icons --color=always --group-directories-first --git --sort=name'
alias l='la'
alias la="eza --all ${EZAFLAGS}"
alias ls="eza ${EZAFLAGS}"
alias ll="eza -lah ${EZAFLAGS}"

alias lt="eza --all --tree --level=2 ${EZAFLAGS}"
alias ltt="eza --all --tree --level=3 ${EZAFLAGS}"
alias lttt="eza --all --tree --level=4 ${EZAFLAGS}"

alias dir='br -sdp'

# copy, move, remove = use yazi if possible!
alias cp='cp -vR'
alias rm='rm -vr'
alias mv='mv -v'

alias wget='wget -c'


# custom
alias update='topgrade --tmux --no-retry'

alias zels='zellij ls'
alias zain='zellij -s MAIN &> /dev/null || zellij a MAIN'

alias glog='git log --graph --abbrev-commit -n 5'
alias gs='git status -s'
alias gst='git fetch; git status'

alias box='gum style --padding="0 1" --border=rounded'
alias pgr='gum pager'
alias uhas='HAS_ALLOW_UNSAFE=y has'

alias u='ultralist'
alias ula='ultralist list --status --notes'
alias uls='ultralist list --notes group:status'

alias fzfp="fzf --preview 'bat --color=always --style=plain {}'"
alias justchoose='just --choose'
alias justls='just --list'
alias justedit='just --edit'
alias justdump='just --dump'

alias run='tempfile=$(mktemp); $EDITOR $tempfile; source $tempfile; rm $tempfile'

alias todo='hmm todo.hmm'

alias hxo='FILE=$(gum file -a || exit 1) && helix $FILE'
# alias napsync='(cd ~/repos/snippets && git add . && git commit -m "update" && git push)'
alias download='cd ~/Downloads && gum spin --spinner=minidot --title="Downloading..." -- wget -c'

# unused...
alias da='du -ch -d 1' # replace with dust
alias df='df -h'
alias ip='command ip -color=auto'
alias userlist='cut -d: -f1 /etc/passwd'
alias probe='sudo -E hw-probe -all -upload'
alias splitfile='split'
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'
