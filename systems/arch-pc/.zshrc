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

# --- exports ---
export VISUAL=helix
export EDITOR=helix
export PATHBACK="${PATH}"
export PATH="${PATH}:/home/noah/programs"
export PATH="${PATH}:/home/noah/.cargo/bin"
export PATH="${PATH}:/home/noah/.local/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"

# --- variables ---
export JRNL_ENTRY_COUNT=8

# source ~/.zsh_aliases
source ~/.zsh_gh_completion
source ~/.config/broot/launcher/bash/br # TODO: move to /local/bin
source ~/.secrets

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
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
# file commands with gum spinners
# alias cp='gum spin --spinner=minidot --show-output --title="Copying..." -- cp -vR'
# alias mv='gum spin --spinner=minidot --show-output --title="Moving..." -- mv -v'
# alias rm='gum spin --spinner=minidot --show-output --title="Deleting" -- rm -vr'

# sys info
alias neo='neofetch'
alias da='du -ch -d 1'
alias df='df -h'
alias free='free -mt'
alias ip='command ip -color=auto'
alias userlist='cut -d: -f1 /etc/passwd'
alias probe='sudo -E hw-probe -all -upload'

# pacman (and yay)
alias in='yay -S --noconfirm'
alias up='yay -Syu' # dont add noconfirm here!

# program shorts
alias lg='lazygit'
alias vim='nvim'
alias hx='helix'
alias glop='glow -p'
alias cht='cht.sh'
alias wget='wget -c'
alias ai='gh copilot suggest'
alias tod='taskell ~/taskell.md'
alias todo='taskell'
alias con='wezterm ssh noah@mondkuchen.tech'
alias jrnle='jrnl --edit'
alias jrnlg="jrnl -n ${JRNL_ENTRY_COUNT} | glow"
alias jrnlp="jrnl -n ${JRNL_ENTRY_COUNT} --format pretty"
alias jrnlb="jrnl -n ${JRNL_ENTRY_COUNT} --format boxes" # maybe with | gum pager ?
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
alias napsync='WD=$(pwd); cd ~/repos/snippets && git add . && git commit -m "update" && git push; cd $WD'
# alias acp='git add . && git commit -m "$(gum input --header=\"Changes:\")" && gum confirm "Push?" && git push'
alias acp='git add . && (git status --porcelain | grep -E "^\s?[AM]+\s" >/dev/null && git commit -m "$(gum input --header=\"Changes:\")") && gum confirm "Push?" && git push'
alias download='cd ~/Downloads && gum spin --spinner=minidot --show-output --title="Downloading..." -- wget -c'

# misc
alias splitfile='split'
alias term2iso='echo '\''Setting terminal to iso mode'\'' ; print -n '\''\e%@'\'
alias term2utf='echo '\''Setting terminal to utf-8 mode'\''; print -n '\''\e%G'\'
alias zsrc='source ~/.zshrc'

# functions
function matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4;        letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }

function rep() {
  for dir in */; do
    if [ -d "$dir/.git" ]; then

      (cd "$dir" || exit
      local content=$(starship explain)
      local cwd=$(echo "$content" | rg 'working dir' | sed 's/.*"\(.*\)".*/\1/')
      local branch=$(echo "$content" | rg 'branch' | sed 's/.*"\(.*\)".*/\1/')
      local state=$(echo "$content" | rg 'state' | sed 's/.*"\(.*\)".*/\1/')
      local versions=$(echo "$content" | rg 'via' | while read -r line; do echo "$line" | sed 's/.*"\(.*\)".*/\1/'; done | tr '\n' ' ')

      echo "- ${cwd}${branch}${state}${versions}")
      # (cd "$dir" || exit; starship prompt | sed -E 's/%\{[^}]*%}//g' | sed 's/..$//')
      echo ""
    fi
  done
}

function conf() {
  local choice=$(gum choose "zsh" "zellij" "starship" "jrnl" "hyprland")

  case "$choice" in
    zsh) helix ~/.zshrc; source ~/.zshrc && echo 'Reloaded!' || echo 'Failed to Reload...' ;;
    zellij) helix ~/.config/zellij/config.kdl ;;
    starship) helix ~/.config/starship.toml ;;
    jrnl) helix ~/.config/jrnl/jrnl.yaml ;;
    hyprland) helix ~/.config/hypr/hyprland.conf ;;
  esac
}

function rci() {
  PKG=$1
  export PUEUE_CARGO_DONE=-1
  pueue add -g 'CARGO' "cargo install $PKG && export PUEUE_CARGO_DONE=0 || cargo install $PKG --locked && export PUEUE_CARGO_DONE=0 || export PUEUE_CARGO_DONE=1"
}

function unpack() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: unpack <file>"
        return 1
    fi

    local file="$1"

    if [[ -f "$file" ]]; then
        if [[ "$file" == *.zip ]]; then
            unzip "$file"
        elif [[ "$file" == *.tar.gz || "$file" == *.tgz ]]; then
            tar -xzf "$file"
        elif [[ "$file" == *.tar.bz2 || "$file" == *.tbz2 ]]; then
            tar -xjf "$file"
        elif [[ "$file" == *.tar.xz || "$file" == *.txz ]]; then
            tar -xJf "$file"
        elif [[ "$file" == *.tar ]]; then
            tar -xf "$file"
        else
            echo "Unsupported file format."
            return 1
        fi
    else
        echo "File not found: $file"
        return 1
    fi
}


# Function to create an executable copy of a file in /bin directory
function create_executable_copyOLD() {
    local source_file="$1"
    local base_name="$(basename "$source_file")"
    local dest_file="/usr/local/bin/$base_name"

    # Check if the source file exists
    if [ ! -f "$source_file" ]; then
        echo "Error: Source file '$source_file' not found."
        return 1
    fi

    # Check if the destination file already exists
    if [ -e "$dest_file" ]; then
        echo "Error: Destination file '$dest_file' already exists."
        return 1
    fi

    # Copy the file to /bin directory
    sudo cp -v "$source_file" "$dest_file"
    
    # Make the file executable
    sudo chmod +x "$dest_file"

    echo "Executable copy created: $dest_file"
}

# Function to create an executable copy of a file in /bin directory
function cec() {
    local source_file="$1"
    local base_name="$(basename "$source_file")"
    local dest_file="/usr/local/bin/$base_name"

    # Check if the source file exists
    if [ ! -f "$source_file" ]; then
        echo "Error: Source file '$source_file' not found."
        return 1
    fi

    # Check if the destination file already exists
    if [ -e "$dest_file" ]; then
        # Prompt for confirmation to override the destination file
        echo "Destination file '$dest_file' already exists."
        gum confirm "Override it?" || { echo "Aborted..." && return 1 }
    fi

    # Check if the file contains a shebang line
    # if ! head -n 1 "$source_file" | grep -q "^#!"; then
    if ! head -n 1 "$source_file" | grep -q "^#!" && [[ "$source_file" == *.sh ]]; then
        # Add default shebang line for Zsh
        sudo echo "#!/usr/bin/env zsh" > "$dest_file"
        sudo echo "# Automatically added by create_executable_copy function" >> "$dest_file"
        sudo echo "# ------------------------------------------------------" >> "$dest_file"
        sudo cat "$source_file" >> "$dest_file"
    else
        # Copy the file to /bin directory with sudo
        sudo cp -v "$source_file" "$dest_file"
    fi
    
    # Make the file executable with sudo
    sudo chmod +x "$dest_file"

    echo "Executable copy created: $dest_file"
}

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


function check_packages() {
  local package=$1
  local package_managers=(cargo yay pacman apt pip brew)
  local available_package_managers=()
                                                                                                                              
  # Check if each package manager is available on your system
  for pm in $package_managers; do
    case $pm in
      apt)  command -v apt &> /dev/null && available_package_managers+=($pm);;
      pip)  command -v pip    &> /dev/null && available_package_managers+=($pm);;
      brew) command -v brew    &> /dev/null && available_package_managers+=($pm);;
    esac
  done
                                                                                                                              
  # Only proceed if at least one package manager is available
  if [[ ${#available_package_managers[@]} -gt 0 ]]; then
    for pm in $available_package_managers; do
      case $pm in
        apt|apt-get)
          installed=$(dpkg-query -W -f=${package} | grep -q ${package} && echo "Installed")
          available=$(apt-cache policy ${package} | grep -q " Installed" && echo "Available")
         ;;
        dnf) installed=$(dnf list --installed ${package} | grep -q ${package} && echo "Installed");;
        pip)  installed=$(pip show ${package} | grep -q "INSTALLED" && echo "Installed");;
        npm)  installed=$(npm ls ${package} | grep -q ${package} && echo "Installed");;
        brew) installed=$(brew list --versions ${package} | grep -q ${package} && echo "Installed");;
      esac
                                                                                                                              
      printf "%-20s %s\n" "$pm: $package" "${installed} ${available}"
    done
  else
    echo "No package managers available on your system."
  fi

}

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

function list() {
  # gum choose aliases, customs, programs
  local choice=$(gum choose "customs" "aliases" "binaries")

  local customs_list='# name - description (args)
   - conf = choose a config file to edit with `helix`
   - rep = list all repos width starship promt
   - unpack = unpacks an archive with either unzip or tar *automatically*
   - rci = install a rust program and hide it with pueue (program_name)
   - cec = create executable copy in /bin (file_name)
   - onetime = runs a program only *once* (program_name)'

  local bin_list='WIP'

  
  case "$choice" in
    customs) echo $customs_list | glow ;;
    aliases) alias ;;
    programs) echo $bin_list | glow ;;
  esac
}

function zen() {
  local files=$(gum style --padding '0 1' --border 'rounded' "$(l)")
  local bonsai=$(gum style --padding '0 1' --border 'rounded' "$(cbonsai -p)")

  echo "$(gum join --align 'center' "$files" "$bonsai")"
}


# function acp() {
#   git add . &&  git commit -m "$(gum input --header='Changes:')" && gum confirm "Push?" && git push
# }

# --- startup ---
# clear
# cbonsai -p -l -t 0.001 -M 6 -L 40


# Following line was automatically added by arttime installer
export MANPATH=/home/noah/.local/share/man:$MANPATH
