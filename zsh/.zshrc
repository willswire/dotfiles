## Shell Appearance
#
# Vanity configurations
##
export PROMPT="%n %1~ > ";

## Homebrew
# 
# Configurations and customizations
##
eval "$(/opt/homebrew/bin/brew shellenv)";
export HOMEBREW_NO_ENV_HINTS=1;
export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$PATH"

## Go
#
# Path things
##
export PATH="/Users/willwalker/go/bin:$PATH"

## Aliases
#
# Compound commands to make DevOps better
##
alias gamend="git add .;git commit --amend --no-edit;git push --force"

## Secrets
#
# security add-generic-password -a "$USER" -s 'My Secret Token' -w 'qwerty123'
# export ACCESS_TOKEN=$(security find-generic-password -s 'My Secret Token' -w)
##
