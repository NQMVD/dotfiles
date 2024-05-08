# --- functions ---

# bash matrix impl
function matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4;        letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }

# list all repos in cwd with starship
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

# open config of choice
function conf() {
  local choice=$(gum choose "zsh" "zellij" "starship" "jrnl" "hyprland")

  case "$choice" in
    zsh) helix ~/.config/zsh; source ~/.zshrc && echo 'Reloaded!' || echo 'Failed to Reload...' ;;
    zellij) helix ~/.config/zellij/config.kdl ;;
    starship) helix ~/.config/starship.toml ;;
    jrnl) helix ~/.config/jrnl/jrnl.yaml ;;
    hyprland) helix ~/.config/hypr/hyprland.conf ;;
  esac
}

# rust cargo install with pueue bg, sets PUEUE_CARGO_DONE
function rci() {
  PKG=$1
  export PUEUE_CARGO_DONE=-1
  pueue add -g 'CARGO' "cargo install $PKG && export PUEUE_CARGO_DONE=0 || cargo install $PKG --locked && export PUEUE_CARGO_DONE=0 || export PUEUE_CARGO_DONE=1"
}

# unzips with either unzip or tar automatically
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

# Function to create an executable copy of a file in /usr/local/bin directory
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


# TODO: complete checks for pkg mngrs
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

# lists shell commands: aliases, functions, binaries
function list() {
  # gum choose aliases, customs, programs
  local choice=$(gum choose "customs" "aliases" "binaries")

  # TODO: create script to extract infos from file
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
    aliases) alias | bat -l zsh;;
    programs) echo $bin_list | glow ;;
  esac
}

# fetch and bonsai as a welcome
function zen() {
  local files=$(gum style --padding '0 1' --border 'rounded' "$(l)")
  # FIX: bonsai returning bulls***
  local bonsai=$(gum style --padding '0 1' --border 'rounded' "$(cbonsai -p)")

  echo "$(gum join --align 'center' "$files" "$bonsai")"
}

function peach() {
  local command=$1
  shift

  while IFS= read -r line; do
    $command "$@" "$line"
  done
}
