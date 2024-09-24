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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/noah/.dart-cli-completion/zsh-config.zsh ]] && . /home/noah/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

