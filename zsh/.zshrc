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
# Using the OS X Keychain to store and retrieve passwords
# https://www.netmeister.org/blog/keychain-passwords.html
##
source ~/.tokenz
tokenz () {
    # Check if a token name is provided
    if [ -z "$1" ]; then
        echo "Error: No token name provided."
        return 1
    fi
    
    # Add the token to the keychain
    security add-generic-password -a "${USER}" -s "$1" -w
    if [ $? -ne 0 ]; then
        echo "Error: Failed to add token to keychain."
        return 1
    fi
    
    # Append the export command to the .tokenz file
    export_command="export $1=\$(security find-generic-password -a ${USER} -s $1 -w)"
    echo "${export_command}" >> ~/.tokenz
    if [ $? -ne 0 ]; then
        echo "Error: Failed to write to ~/.tokenz file."
        return 1
    fi
    
    echo "Token $1 added to keychain and export command appended to ~/.tokenz"
    source ~/.tokenz
}