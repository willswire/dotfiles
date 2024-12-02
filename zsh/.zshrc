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

## Path
#
# Path things
##
export PATH="~/Developer/scripts:~/go/bin:$PATH"
