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
SCRIPTS="/Users/$USER/Developer/scripts"
GO_BIN="/Users/$USER/go/bin"
CARGO_BIN="/Users/$USER/.cargo/bin"
PIPX_BIN="/Users/$USER/.local/bin"
ORACLE_BIN="/opt/oracle/"
export PATH="$SCRIPTS:$ORACLE_BIN:$GO_BIN:$CARGO_BIN:$PIPX_BIN:$PATH"

## NodeJS sucks
#
# Setting up NVM for Node version mgmgt
##
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

## Aliases and Functions
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
cdev() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: cdev <directory-name>"
    return 1
  fi

  # Search for the directory, suppressing error messages
  local target
  target=$(find ~/Developer -type d -name "$1" 2>/dev/null | head -n 1)
  
  if [ -n "$target" ]; then
    cd "$target" || return
  else
    echo "Directory '$1' not found in ~/Developer"
  fi
}
devclone() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: devclone <repository-url>"
    return 1
  fi

  local url="$1"
  local host repo_path

  # Extract hostname and repository path from the URL
  if [[ "$url" == https://* ]]; then
    # For HTTPS URLs, e.g. https://github.com/owner/repo.git
    local rest="${url#https://}"
    host="${rest%%/*}"
    repo_path="${rest#*/}"
  elif [[ "$url" == git@*:* ]]; then
    # For SSH URLs, e.g. git@github.com:owner/repo.git
    local rest="${url#git@}"
    host="${rest%%:*}"
    repo_path="${rest#*:}"
  else
    echo "Unsupported URL format: $url"
    return 1
  fi

  # Remove trailing .git from the repository path, if present
  repo_path="${repo_path%.git}"

  # Construct the target directory path under ~/Developer
  local target_dir=~/Developer/"${host}"/"${repo_path}"

  # Create the parent directories if they don't exist
  mkdir -p "$(dirname "$target_dir")"

  git clone "$url" "$target_dir"
}
alias tf=tofu
alias l=ls
alias k=kubectl

## Docker
#
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
##
fpath=(/Users/william/.docker/completions $fpath)
autoload -Uz compinit
compinit
