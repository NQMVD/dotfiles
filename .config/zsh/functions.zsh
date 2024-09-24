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



# function ai() {
#     MODELS=$(aichat --list-models)
#     MODEL=$(echo $MODELS | gum filter --header 'Choose a Model:')

#     gum confirm 'Create a new Session?'
#     NEWSESSION=$?

#     if is equal "$NEWSESSION" 0; then
#         aichat --model "$MODEL"
#     else
#         SESSIONS=$(aichat --list-sessions)
#         SESSION=$(echo $SESSIONS | gum filter --header 'Choose a Session')
#         aichat --model "$MODEL" --session "$SESSION"
#     fi
# }

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

    # if is file "$HOME/dotfiles/.config/$CHOICE"; then
      hx "$HOME/dotfiles/.config/$CHOICE"
    # elif is dir "$HOME/dotfiles/.config/$CHOICE"; then
    #   yazi "$HOME/dotfiles/.config/$CHOICE"
    # fi
    
  # local choice=$(gum choose "zsh" "zellij" "starship" "jrnl" "hyprland")

  # case "$choice" in
  #   zsh) helix ~/.config/zsh; source ~/.zshrc && echo 'Reloaded!' || echo 'Failed to Reload...' ;;
  #   zellij) helix ~/.config/zellij/config.kdl ;;
  #   starship) helix ~/.config/starship.toml ;;
  #   jrnl) helix ~/.config/jrnl/jrnl.yaml ;;
  #   hyprland) helix ~/.config/hypr ;;
  # esac
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
    local MODEL="$OLLAMA_MODEL"
    local PROMPT="$@"
    [[ "$#" -lt 1 ]] && PROMPT=$(chew "Prompt:" -w)  #{ gum log -l 'error' 'No prompt provided'; return 1 } 
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

    COUNT=$(echo "$RESPONSE" | getcodeblocks count)
    CLIP=$(whatclip)

    if [[ $COUNT -eq 0 ]]; then
        gum confirm "No code blocks found! Copy to clipboard anyway?" && echo "$RESPONSE" | $CLIP

    elif [[ $COUNT -eq 1 ]]; then
        CODEBLOCK=$(echo "$RESPONSE" | getcodeblocks get 1)
        gum confirm "Copy to Clipboard?" && echo "$CODEBLOCK" | $CLIP

    else
        CODEBLOCKNUM=$(echo "$RESPONSE" | getcodeblocks | gum choose --header='Choose a Codeblock:' | awk -F: '{print $1}')
        CODEBLOCK=$(echo "$RESPONSE" | getcodeblocks get "$CODEBLOCKNUM")
        gum confirm "Copy to Clipboard?" && echo "$CODEBLOCK" | $CLIP
    fi
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
