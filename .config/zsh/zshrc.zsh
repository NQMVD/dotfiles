CONFPATH="$HOME/.config/zsh"

# Load zinit plugins
source "$CONFPATH/zinit.zsh"

# Load must-have-stuff
source "$CONFPATH/stuff.zsh"

# Load completions
source "$CONFPATH/completion.zsh"

source "$CONFPATH/just.zsh"

# Load variables and paths
source "$CONFPATH/exports.zsh"

# Load commands
source "$CONFPATH/aliases.zsh"
source "$CONFPATH/functions.zsh"
source "$CONFPATH/subcommands.zsh"

# Eval tool inits
source "$CONFPATH/evals.zsh"

source "$HOME/.secrets"
