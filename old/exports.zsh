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
