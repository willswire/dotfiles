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
export PATH="/Users/willwalker/Developer/scripts:/Users/willwalker/go/bin:$PATH"
