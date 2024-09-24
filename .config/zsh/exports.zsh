# --- exports ---
export VISUAL=helix
export EDITOR=helix
# export PATHBACK="${PATH}"
export PATH="${PATH}:/home/noah/scripts"
export PATH="${PATH}:/home/noah/.cargo/bin"
export PATH="${PATH}:/home/noah/.local/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"
export PATH="${PATH}:$(gem env path | sed 's#[^:]\+#&/bin#g')"
export MANPATH="/home/noah/.local/share/man:${MANPATH}"

# --- variables ---
export JRNL_ENTRY_COUNT=8
export BAT_STYLE="changes,header,grid"
export BAT_THEME="base16" # "ansi"
export JUST_CHOOSER="gum choose --no-limit --header='Recipies:'"
export OLLAMA_MODEL="llama3.1"
export ZELLIJ_RUNNER_MAX_DIRS_DEPTH="2"
export BINSTALL_NO_CONFIRM

# --- Gum styling ---
# choose
export GUM_CHOOSE_CURSOR=" " # get a nerdfonts one
export GUM_CHOOSE_CURSOR_PREFIX="󰄱 "
export GUM_CHOOSE_SELECTED_PREFIX="󰡖 "
export GUM_CHOOSE_UNSELECTED_PREFIX="󰄱 "
# export GUM_CHOOSE_HEADER_FOREGROUND="5"
# export GUM_CHOOSE_CURSOR_FOREGROUND="2"
# export GUM_CHOOSE_ITEM_FOREGROUND="7"
# export GUM_CHOOSE_SELECTED_FOREGROUND="4"

# confirm
# export GUM_CONFIRM_PROMPT_FOREGROUND="5"
# export GUM_CONFIRM_SELECTED_BACKGROUND="99"

# input & write
export GUM_INPUT_PROMPT=" "
# export GUM_INPUT_PROMPT_FOREGROUND="2"
# export GUM_INPUT_CURSOR_FOREGROUND="4"
# export GUM_INPUT_HEADER_FOREGROUND="5"
# export GUM_WRITE_PROMPT_FOREGROUND="2"
# export GUM_WRITE_CURSOR_FOREGROUND="4"
# export GUM_WRITE_HEADER_FOREGROUND="5"
# export GUM_WRITE_CURSOR_LINE_FOREGROUND="5"

# file
export GUM_FILE_CURSOR=" "

# spinner
export GUM_SPIN_SHOW_OUTPUT="true"
export GUM_SPIN_SPINNER="pulse"
# export GUM_SPIN_TITLE_FOREGROUND="99"
# export GUM_SPIN_SPINNER_FOREGROUND="4"
