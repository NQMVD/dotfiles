# --- functions ---
source ~/.config/zsh/aliases.zsh

# command_not_found_handler() {
#     # add some stuff here later
# }

# precmd() {
#     if [ "$?" -ne 0 ]; then
#         # command_failed_handler
#     fi
# }

# bash matrix impl
function matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4;        letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }

# mkdir and cd
function mdc() {
  mkdir -p $1 && cd $1
}

function acp() {
  # show small status
  git status --porcelain
  # add all files
  git add .
  # check if anything changed: A for added, M for modified (D for deleted, might include in the future)
  git status --porcelain | grep -E "^\s?[AM]+\s" >/dev/null && git commit -m "$(gum input --header=\"Changes:\")" && gum confirm "Push?" && git push
}


# open config of choice
function conf() {
  local choice=$(gum choose "zsh" "zellij" "starship" "jrnl" "hyprland")

  case "$choice" in
    zsh) helix ~/.config/zsh; source ~/.zshrc && echo 'Reloaded!' || echo 'Failed to Reload...' ;;
    zellij) helix ~/.config/zellij/config.kdl ;;
    starship) helix ~/.config/starship.toml ;;
    jrnl) helix ~/.config/jrnl/jrnl.yaml ;;
    hyprland) helix ~/.config/hypr ;;
  esac
}

# rust cargo install with pueue bg, sets PUEUE_CARGO_DONE
function rci() {
  PKG=$1
  export PUEUE_CARGO_DONE=-1
  pueue add -g 'CARGO' "cargo install $PKG && export PUEUE_CARGO_DONE=0 || cargo install $PKG --locked && export PUEUE_CARGO_DONE=0 || export PUEUE_CARGO_DONE=1"
}


# Function to create an executable copy of a *.zsh!* file in /usr/local/bin directory
function cec() {
    local source_file="$1"
    local base_name="$(basename "$source_file")"
    local dest_file="/usr/local/bin/$base_name"

    # Check if the source file exists
    if [[ ! -f "$source_file" ]]; then
        echo "Error: Source file $source_file not found."
        return 1
    fi

    # Check if the destination file already exists
    if [[ -e "$dest_file" ]]; then
        # Prompt for confirmation to override the destination file
        echo "Destination file '$dest_file' already exists."
        if ! gum confirm 'What to do?' --affirmative="Override!" --negative="See diff..."
        then
            delta $source_file $dest_file || diff $source_file $dest_file
            gum confirm "Override it?" || { echo "Aborted..." && return 1 }
        fi
    fi

    # Check if the file contains a shebang line and if its a .zsh file
    # if ! head -n 1 "$source_file" | grep -q "^#!"; then
    if [[ "$source_file" == *.zsh ]]; then
        if ! head -n 1 "$source_file" | rg -q "^#!"; then
            sudo echo "#!/usr/bin/env zsh" > "$dest_file"
            sudo echo "# Source file: $source_file" >> "$dest_file"
            sudo echo "# -------------------------" >> "$dest_file"
            sudo cat "$source_file" >> "$dest_file"
        else
            # Copy the file to /bin directory with sudo
            sudo cp -v "$source_file" "$dest_file"
        fi
    else
        echo "NOT YET IMPLEMENTED FOR FILES LIKE: $source_file"
    fi
    
    # Make the file executable with sudo
    sudo chmod +x "$dest_file"

    echo "Executable copy created: $dest_file"
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

# extracts functions and its comments
function extract_functions() {
    if [ -z "$1" ]; then
        echo "Please provide a file path as an argument."
        return 1
    fi

    local file_path="$1"
    local function_names='# functions\n'
    local line_number=1
    local prev_line=""

    while IFS= read -r line; do
        local combined_line="$prev_line$line"
        if [[ "$combined_line" =~ '^(#.*\n)(\s*function\s+)(\S+)\s*\(\)' ]]; then
            local comment="${match[1]}"
            local function_name="${match[3]}"

            if [ -n "$comment" ]; then
                function_names+="- \`${function_name}\`: ${comment:2}\n"
            else
                function_names+="- \`${function_name}\`: no description\n"
            fi
        fi
        prev_line="$line\n"
        ((line_number++))
    done < "$file_path"

    echo "$function_names" #| sed 's/^[[:space:]]*//g'
}

# lists shell commands: aliases, functions, binaries
function list() {
  # gum choose aliases, functions, scripts, binaries
  local choice=$(gum choose "functions" "programs" "scripts" "binaries" "aliases" "all")

  # TODO: sort scripts by dir then file, then by file extension, 
  # then add markdown like with functions but read the first line with shebang and second line with description

  # local SCRIPTS=$(gum style --padding="0 1" --border=rounded "$(eza -1 --icons=always --color=always ~/scripts)") 
  # local BINS=$(gum style --padding="0 1" --border=rounded "$(eza -1 --icons=always --color=always /usr/local/bin)") 

  local SCRIPTS=$(hbox scripts "$(eza -1 --color=always ~/scripts)") 
  local BINS=$(hbox binaries "$(eza -1 --color=always /usr/local/bin)") 

  case "$choice" in
    aliases) alias | bat -l zsh;;
    functions) extract_functions ~/.config/zsh/functions.zsh | glow;;
    scripts) echo $SCRIPTS;;
    binaries) echo $BINS;;
    programs) gum join "$SCRIPTS" "$BINS";;
    all) extract_functions ~/.config/zsh/functions.zsh | glow && echo && gum join "$SCRIPTS" "$BINS";;
  esac
}

# fetch and bonsai as a welcome
function zen() {
  local files=$(gum style --padding '0 1' --border 'rounded' "$(l)")
  # FIX: bonsai returning bulls***
  local bonsai=$(gum style --padding '0 1' --border 'rounded' "$(cbonsai -p)")

  echo "$(gum join --align 'center' "$files" "$bonsai")"
}

# a stupid xargs, runs a given command for each line from pipe input (nushell wins this one tho)
function peach() {
  local command=$1
  shift

  while IFS= read -r line; do
    $command "$@" "$line"
  done
}

# ask ollama
function ask() {
  local MODEL='llama3'
  local PROMPT="$@"
  [[ "$#" -lt 1 ]] && PROMPT=$(chewwrite "Prompt:")  #{ gum log -l 'error' 'No prompt provided'; return 1 } 
  local RESPONSE=$(gum spin --title="Generating..." -- ollama run "$MODEL" "$PROMPT")
  echo "# DATE: $(date)
---
# MODEL: ${MODEL}
---
# PROMPT::
${PROMPT}
---
# RESPONSE::
${RESPONSE}
" > "${HOME}/ai/${MODEL}/question_$(date +%c | tr ' ' '_').md"
  echo "$RESPONSE" | glow
  gum confirm "Copy to Clipboard?" && echo "$RESPONSE" | wl-copy
}

# --- depracted ---

# unzips with either unzip or tar automatically
# function unpack() {
#     [[ $# -ne 1 ]] && echo "Usage: unpack <file>" && return 1

#     local file="$1"

#     if [[ -f "$file" ]]; then
#         if [[ "$file" == *.zip ]]; then
#             unzip "$file"
#         elif [[ "$file" == *.tar.gz || "$file" == *.tgz ]]; then
#             tar -xzf "$file"
#         elif [[ "$file" == *.tar.bz2 || "$file" == *.tbz2 ]]; then
#             tar -xjf "$file"
#         elif [[ "$file" == *.tar.xz || "$file" == *.txz ]]; then
#             tar -xJf "$file"
#         elif [[ "$file" == *.tar ]]; then
#             tar -xf "$file"
#         else
#             echo "Unsupported file format."
#             return 1
#         fi
#     else
#         echo "File not found: $file"
#         return 1
#     fi
# }


# gum style box with a header
# function hbox() {
#     local HEADER=$1
#     shift
#     local REST=$(gum style --padding="0 1" --border=rounded "$@")
#     echo -e "$HEADER\n$REST"
# }


# function hbox() {
#   local header=$1
#   shift
#   local content="$@"

#   # Generate the boxed content
#   local boxed_content=$(gum style --padding="0 1" --border=rounded "[ $header ]" "$@") #$(echo "$content" | box)

#   # Extract the first line (the top border) from the boxed content
#   local top_border=$(echo "$boxed_content" | head -n 1)

#   # Calculate the necessary padding
#   local border_length=${#top_border}
#   local header_length=${#header}
#   local padding_length=$(( (border_length - header_length) / 2 ))

#   # Construct the new top border with the header
#   local new_top_border=""
#   new_top_border+="${top_border:0:$((padding_length - 2))}"
#   new_top_border+="[ $(gum style --foreground 6 $header) ]"
#   new_top_border+="${top_border:$((2 + padding_length + header_length))}"

#   # Replace the original top border with the new one
#   local result=$(echo "$boxed_content" | sed "2s/.*/$new_top_border/" | sed '1d')

#   # Print the result
#   echo "$result"
# }


# list all repos in cwd with starship
# function rep() {
#   for dir in */; do
#     if [ -d "$dir/.git" ]; then

#       (cd "$dir" || exit
#       local content=$(starship explain)
#       local cwd=$(echo "$content" | rg 'working dir' | sed 's/.*"\(.*\)".*/\1/')
#       local branch=$(echo "$content" | rg 'branch' | sed 's/.*"\(.*\)".*/\1/')
#       local state=$(echo "$content" | rg 'state' | sed 's/.*"\(.*\)".*/\1/')
#       local versions=$(echo "$content" | rg 'via' | while read -r line; do echo "$line" | sed 's/.*"\(.*\)".*/\1/'; done | tr '\n' ' ')

#       echo "- ${cwd}${branch}${state}${versions}")
#       # (cd "$dir" || exit; starship prompt | sed -E 's/%\{[^}]*%}//g' | sed 's/..$//')
#     fi
#   done
# }
