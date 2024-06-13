# --- aliases ---
# Change dir with zoxide
alias c='z'
alias cc='z -'
alias ..='z ..'
alias ...='z ../..'

# other dir commands

# ls aliases to eza
# thinking:
# l = list (all)
# ls = list short
# lt = list tree (all)
# lst = list short tree
# lttt = list tree deeper
EZAFLAGS='--icons --color=always --group-directories-first --git --git-ignore'
alias  l="eza --all --oneline ${EZAFLAGS}"
alias ls="eza --oneline ${EZAFLAGS}"
alias ll="eza -lah ${EZAFLAGS}"
alias gl="eza --all --grid --width 50 ${EZAFLAGS}"

alias lt="eza --all --tree --level=2 ${EZAFLAGS}"
alias ltt="eza --all --tree --level=3 ${EZAFLAGS}"
alias lttt="eza --all --tree --level=4 ${EZAFLAGS}"
alias lst="eza --tree --level=2 ${EZAFLAGS}"
alias lstt="eza --tree --level=3 ${EZAFLAGS}"
alias lsttt="eza --tree --level=4 ${EZAFLAGS}"

alias dir='br -sdp'

# file commands
alias cp='cp -vR'
alias rm='rm -vr'
alias mv='mv -v'
# file commands with gum spinners
# TODO: create functions to try make it work with completions again
# alias cp='gum spin --spinner=minidot --show-output --title="Copying..." -- cp -vR'
# alias mv='gum spin --spinner=minidot --show-output --title="Moving..." -- mv -v'
# alias rm='gum spin --spinner=minidot --show-output --title="Deleting" -- rm -vr'

# misc
alias splitfile='split'
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'
alias zsrc='source ~/.zshrc'

# sys info
alias neo='neofetch' # works but also add others like fetchit
alias fetch='fetchit -f ~/Pictures/ascii/arch.txt'
alias da='du -ch -d 1' # replace with dust
alias df='df -h'
alias free='free -mt'
alias ip='command ip -color=auto'
alias userlist='cut -d: -f1 /etc/passwd'
alias probe='sudo -E hw-probe -all -upload'

# pacman (and yay)
alias in='yay -S --noconfirm'
alias up='yay -Syu' # dont add noconfirm here!

# program shorts
alias wget='wget -c'
alias md='mkdir -p'
alias lg='lazygit'
alias hx='helix'
alias glop='glow -p'
alias box='gum style --padding="0 1" --border=rounded'
alias pgr='gum pager'
alias cht='cht.sh'
alias ai='aichat'
alias uhas='HAS_ALLOW_UNSAFE=y has'
alias con='wezterm ssh noah@mondkuchen.tech'
alias note='dnote'

alias fzfp="fzf --preview 'bat --color=always --style=plain {}'"
alias justchoose='just --choose'
alias justlist='just --list'
alias justedit='just --edit'

alias run='tempfile=$(mktemp); $EDITOR $tempfile; source $tempfile; rm $tempfile'

# todos and jrnls
alias tod='taskell ~/taskell.md'
alias tode='helix ~/taskell.md'
alias todo='taskell'
alias jrnle='jrnl --edit'
alias jrnlg="jrnl -n ${JRNL_ENTRY_COUNT} | glow"
alias jrnlp="jrnl -n ${JRNL_ENTRY_COUNT} --format pretty"
alias jrnlb="jrnl -n ${JRNL_ENTRY_COUNT} --format boxed" # maybe with | gum pager ?
alias jrnls="jrnl -n ${JRNL_ENTRY_COUNT} --format short"
alias jrnll='jrnl --list'
alias jrnli='gum input --cursor.foreground "#f58ee0" \
          --prompt.foreground "#c58fff" \
          --width 100 \
          --prompt "jrnl entry: " \
          --placeholder "..." | jrnl'

# util
alias cls='clear; cbonsai -p -M 6 -L 40'
alias hxo='FILE=$(gum file -a || exit 1) && helix $FILE'
alias bon='cbonsai -l -t 0.001 -m "welcome back!" -M 6 -L 40'
alias hi='zellij k welcome; zellij -s welcome --layout=greet'
alias napsync='(cd ~/repos/snippets && git add . && git commit -m "update" && git push)'
alias download='cd ~/Downloads && gum spin --spinner=minidot --show-output --title="Downloading..." -- wget -c'


# logger
function gol() {
	# level, msg
	# check GUM_LOG_LEVEL
	LEVELS=("debug" "info" "warn" "error" "fatal")
	# TODO: implement
	
}
