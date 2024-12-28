## Shell Setup
#
# Vanity configurations
##
export PROMPT='%2~ > ';
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit && compinit

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
zed() {
   if [[ "$1" = "--log" ]]; then
       command tail -f ~/Library/Logs/Zed/Zed.log
   else
       command zed "$@"
   fi
}
