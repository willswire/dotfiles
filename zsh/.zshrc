## Shell Appearance
#
# Vanity configurations
##
export PROMPT="WW %1~ > ";

## Homebrew
#
# Configurations and customizations
##
eval "$(/opt/homebrew/bin/brew shellenv)";
export HOMEBREW_NO_ENV_HINTS=1;
export HOMEBREW_BUNDLE_FILE="~/Brewfile"
export HOMEBREW_BUNDLE_FILE_GLOBAL=$HOMEBREW_BUNDLE_FILE
brew() {
    command brew "$@"
    if [[ "$1" = "install" ]]; then
        command brew bundle dump -f
    fi
}

## Path
#
# Path things
##
SCRIPTS="/Users/willwalker/Developer/scripts"
GO_BIN="/Users/willwalker/go/bin"
CARGO_BIN="/Users/willwalker/.cargo/bin"
PIPX_BIN="/Users/willwalker/.local/bin"
export PATH="$SCRIPTS:$GO_BIN:$CARGO_BIN:$PIPX_BIN:$PATH"

## Alias
#
# Less is more
##
alias zedlog="tail -f ~/Library/Logs/Zed/Zed.log"
