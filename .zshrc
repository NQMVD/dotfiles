# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

# Add in snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings = Emacs
bindkey -e

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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Eval completions
eval "$(starship completions zsh)"
eval "$(just --completions zsh)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -f /home/noah/.dart-cli-completion/zsh-config.zsh ]] && . /home/noah/.dart-cli-completion/zsh-config.zsh || true


# --- exports ---
export VISUAL=helix
export EDITOR=helix
export PATH="${PATH}:/home/noah/scripts"
export PATH="${PATH}:/home/noah/.cargo/bin"
export PATH="${PATH}:/home/noah/.local/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"
export PATH="${PATH}:$(gem env path | sed 's#[^:]\+#&/bin#g')"
export PATH="${PATH}:.nvm/versions/node/v22.7.0/bin"
export MANPATH="/home/noah/.local/share/man:${MANPATH}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


# --- variables ---
export OLLAMA_MODEL="llama3.1"

export HAS_ALLOW_UNSAFE='y'
export BAT_STYLE="changes,header,grid"
export BAT_THEME="base16" # "ansi"
export JUST_CHOOSER="gum choose --no-limit --header='Recipies:'"
export ZELLIJ_RUNNER_MAX_DIRS_DEPTH="2"
export BINSTALL_NO_CONFIRM
export ZEIT_DB="$HOME/zeit/database.db"

# --- Gum styling ---
# choose
export GUM_CHOOSE_CURSOR=" " # get a nerdfonts one
export GUM_CHOOSE_CURSOR_PREFIX="󰄱 "
export GUM_CHOOSE_SELECTED_PREFIX="󰡖 "
export GUM_CHOOSE_UNSELECTED_PREFIX="󰄱 "

# input & write
export GUM_INPUT_PROMPT=" "

# file
export GUM_FILE_CURSOR=" "

# spinner
export GUM_SPIN_SHOW_OUTPUT="true"
export GUM_SPIN_SPINNER="pulse"

# --- direct aliases ---

alias c=__zoxide_z
alias zi=__zoxide_zi
alias cb='c -'
alias ..='c ..'

# short renames
alias fetch='fastfetch'
alias md='mkdir -p'
alias hmm='h-m-m'

alias j='just'
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

# copy, move, remove = use yazi if possible!
alias cp='cp -vR'
alias rm='rm -vr'
alias mv='mv -v'

alias wget='wget -c'
alias wcl='wc -l'
alias upper='tr "[:lower:]" "[:upper:]"'
alias lower='tr "[:upper:]" "[:lower:]"'

# custom
alias update='topgrade --tmux --no-retry'

alias zels='zellij ls'

alias glog='git log --graph --abbrev-commit -n 5'
alias gs='git status -s'
alias gst='git fetch; git status'

alias box='gum style --padding="0 1" --border=rounded'
alias pgr='gum pager'
alias shas='HAS_ALLOW_UNSAFE=n has'

alias u='ultralist'
alias ula='ultralist list --status --notes'
alias uls='ultralist list --notes group:status'

alias fzfp="fzf --preview 'bat --color=always --style=plain {}'"
alias jc='just --choose'
alias jls='just --list'
alias je='just --edit'
alias jd='just --dump'

alias run='tempfile=$(mktemp); $EDITOR $tempfile; source $tempfile; rm $tempfile'

alias todo='hmm todo.hmm'

# alias napsync='(cd ~/repos/snippets && git add . && git commit -m "update" && git push)'
alias download='cd ~/Downloads && gum spin --spinner=minidot --title="Downloading..." -- wget -c'

# unused...
alias df='df -h'
alias userlist='cut -d: -f1 /etc/passwd'
alias splitfile='split'

# --- subcommands ---

function pman() {

    case "$1" in
        colors)
            echo Default, Indexed
            echo Idea
            echo Not Started
            echo Started, Ongoing
            echo Paused
            echo Completed
            echo Aborted
            ;;
        *)
            command "$0" "$@"
            exit_code=$?
            
            if [ $exit_code -ne 0 ]; then
                echo "Error: subcommand not recognized or '$0 $@' command failed."
            fi

            return $exit_code
            ;;
    esac
}

function zeit() {
  if [ $# -eq 0 ]; then
    zeit tracking
  else
    zeit $@
  fi
}

# --- functions ---

function uhr() {
    
}

pf() {
  set -f
  local PUEUE_TASKS="pueue status --json | jq -c '.tasks' | jq -r '.[] | \"\(.id | tostring | (\" \" * (2 - length)) + .) | \(.group) | \(.path[-15:]) | \(.status) | \(.command[-15:]) | \(.start[:19])\"'"
  local header="p:pause | s:start | r:restart | k:kill | l:log | f:reload"

local bind="\
ctrl-p:execute-silent(echo {} | cut -d'|' -f1 | xargs pueue pause > /dev/null)+reload^$PUEUE_TASKS^,\
ctrl-s:execute-silent(echo {} | cut -d'|' -f1 | xargs pueue start > /dev/null)+reload^$PUEUE_TASKS^,\
ctrl-r:execute-silent(echo {} | cut -d'|' -f1 | xargs pueue restart -ik > /dev/null)+reload^$PUEUE_TASKS^,\
ctrl-k:execute-silent(echo {} | cut -d'|' -f1 | xargs pueue kill > /dev/null)+reload^$PUEUE_TASKS^,\
ctrl-l:execute-silent(echo {} | cut -d'|' -f1 | xargs pueue log | less > /dev/tty),\
ctrl-f:reload^$PUEUE_TASKS^\
"

  echo $PUEUE_TASKS | sh | fzf --header "${header}" -m \
    --preview="echo {} | cut -d'|' -f1 | xargs pueue log | bat -l log --style=rule,numbers --color=always -r ':200'" \
    --bind="$bind"
  set +f
}

function clone() {
    local fullrepo="$1"
    local repo="$(echo $fullrepo | sed 's/.*\///')"
    cd ~/Repos
    gh repo clone "$fullrepo"
    cd "$repo"
}

# shows content of .helf file in cwd, used to describe what a dir is
function helf() {
    if is existing './.helf'; then
        glow ./.helf
    elif is existing './README.md'; then
        glow ./README.md
    else
        gum log -l error 'No .helf or README file in cwd...'
    fi
}

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
}

# mkdir and cd
function mdc() {
  mkdir -p $1 && cd $1
}

function moji() {
    # set -e

    # Check if the current directory is a git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not a git repository."
        return 1
    fi

    # Check for changes
    if git diff-index --quiet HEAD --; then
        echo "No changes to commit."
        return 0
    fi

    # Add all changes
    git add --all

    # Check again for changes after adding
    if git diff-index --quiet HEAD --; then
        echo "No changes to commit even after adding."
        return 0
    fi

    clear
    git status -s
    hr

    # use goji for pretty commit
    if ! goji; then
        echo 'User aborted...'
        return 1
    fi
    hr

    # Show the commit and what changed
    git show --stat
    hr

    # Push to the current branch
    if ! gum confirm "Push?"; then
        echo 'Did not push...'
        return 0
    fi
    gum spin --show-error --title="Pushing..." --spinner="minidot" -- git push origin HEAD
    
    echo "Done!"
}


# open config of choice
function conf() {
    LIST=$(eza -a "$HOME/dotfiles/.config")

    CHOICE=$(echo $LIST | gum filter --header 'Config to open:')

    hx "$HOME/dotfiles/.config/$CHOICE"
}

# exec-once for the shell with a cache file
function onetime() {
    local prog="$1"
    local cache_file="$HOME/.cache/onetimer"

    # Check if the cache file exists, and create it if it doesn't
    if [ ! -f "$cache_file" ]; then
        touch "$cache_file"
    fi

    # Check if the program has been run before
    if grep -q "^$prog$" "$cache_file"; then
        echo "Program $prog has been run before."
    else
        # Run the program and add it to the cache file
        "$prog"
        echo "$prog" >> "$cache_file"
    fi
}


# splits pipe input when hitting $1 or 50 lines ($2 or 80 = width)
function split() {
    local limit=${1:-50}
    local width=${2:-80}
    local content=$(</dev/stdin)
    local line_count=$(echo -n "$content" | wc -l)
    
    if [[ $line_count -gt $limit ]]; then
        echo "$content" | column -c $width
    else
        echo "$content"
    fi
}

# a stupid xargs, runs a given command for each line from pipe input (nushell wins this one tho)
function peach() {
  local command=$1
  shift

  while IFS= read -r line; do
    $command "$@" "$line"
  done
}

# --- evals ---
eval "$(zoxide init zsh --no-cmd)"

# eval "$(oh-my-posh init zsh --config $HOME/.config/zsh/ohmyposh/bubblesextra.omp.toml)"
# OR
eval "$(starship init zsh)"

source ~/.config/zsh/starship_transient_prompt.zsh

source ~/.secrets
