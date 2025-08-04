## Shell Setup
#
# Vanity configurations
##
export PROMPT='%2~ > ';

# Load syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Lazy load completions
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qNmh+24) ]]; then
    compinit -d ${ZDOTDIR:-${HOME}}/.zcompdump
else
    compinit -C -d ${ZDOTDIR:-${HOME}}/.zcompdump
fi

## Homebrew
#
# Configurations and customizations
##
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BUNDLE_FILE="~/Brewfile"
export HOMEBREW_BUNDLE_FILE_GLOBAL=$HOMEBREW_BUNDLE_FILE

# Lazy load brew shellenv
if [[ -z "$HOMEBREW_PREFIX" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
typeset -U path
path=(
    "/Users/$USER/Developer/scripts"
    "/opt/oracle"
    "/Users/$USER/go/bin"
    "/Users/$USER/.cargo/bin"
    "/Users/$USER/.local/bin"
    $path
)

## NodeJS sucks
#
# Setting up NVM for Node version mgmgt (lazy loaded)
##
export NVM_DIR="$HOME/.nvm"
nvm() {
    unfunction nvm
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    nvm "$@"
}

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
convert_ascii_to_utf8() {
    local folder="$1"
    # Recursively find all files in the given folder
    find "$folder" -type f | while read -r file; do
        # Check if the file is ASCII text using the 'file' command
        if file "$file" | grep -qi 'ASCII'; then
            echo "Converting $file from ASCII to UTF-8..."
            # Convert from ASCII to UTF-8 by redirecting output to a temporary file
            if iconv -f ASCII -t UTF-8 "$file" > "$file.new"; then
                mv "$file.new" "$file"
            else
                echo "Conversion failed for $file"
                rm -f "$file.new"
            fi
        fi
    done
}
alias tf=tofu
alias l=ls
alias k=kubectl

## Docker
#
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
##
if [[ -d /Users/$USER/.docker/completions ]]; then
    fpath=("/Users/$USER/.docker/completions" $fpath)
fi
