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
    if [[ "$1" = "install" || "$1" = "upgrade" || "$1" = "update" ]]; then
        # Dump the Brewfile after install or upgrade
        command brew bundle dump -f
    elif [[ "$1" = "cleanup" ]]; then
        # Run a cleanup after updating
        command brew bundle -f cleanup
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
ORACLE_BIN="/opt/oracle/"
export PATH="$SCRIPTS:$ORACLE_BIN:$GO_BIN:$CARGO_BIN:$PIPX_BIN:$PATH"

## NodeJS sucks
#
# Setting up NVM for Node version mgmgt
##
export NVM_DIR="$HOME/.nvm"
/opt/homebrew/opt/nvm/nvm.sh

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
alias tf=tofu
alias l=ls
alias k=kubectl
