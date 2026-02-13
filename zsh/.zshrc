## Shell Setup
#
# Vanity configurations
##
export PROMPT='%1~ > ';

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
    if [[ "$1" = "upgrade" ]]; then
        # Upgrade brew packages based on Brewfile
        command brew bundle install --upgrade
    elif [[ "$1" = "install" ]]; then
        # Add the new formula to the Brewfile
        command brew bundle add "$2"
    elif [[ "$1" = "cleanup" ]]; then
        # Run a cleanup
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
    "/Users/$USER/go/bin"
    "/Users/$USER/.cargo/bin"
    "/Users/$USER/.local/bin"
    $path
)
SCRIPTS="/Users/$USER/Developer/scripts"
GO_BIN="/Users/$USER/go/bin"
CARGO_BIN="/Users/$USER/.cargo/bin"
export PATH="$SCRIPTS:$GO_BIN:$CARGO_BIN:$PATH"

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
cdev() {
  local dev_root="${HOME}/Developer"
  local query="$1"

  if [[ $# -ne 1 ]]; then
    echo "Usage: cdev <directory-name|path>"
    return 1
  fi

  # Fast-path for explicit paths.
  if [[ -d "$query" ]]; then
    cd "$query" || return
    return
  fi
  if [[ -d "${dev_root}/${query}" ]]; then
    cd "${dev_root}/${query}" || return
    return
  fi

  local target
  # Find first matching directory and stop immediately.
  target="$(find "$dev_root" \
    \( -name .git -o -name node_modules -o -name .venv -o -name target -o -name dist \) -prune -false -o \
    -type d -name "$query" -print -quit 2>/dev/null)"

  if [[ -n "$target" ]]; then
    cd "$target" || return
    return
  fi

  echo "Directory '$query' not found in ${dev_root}"
  return 1
}
devclone() {
  local dev_root="${HOME}/Developer"
  local url="$1"
  local host repo_path rest target_dir

  if [[ $# -ne 1 ]]; then
    echo "Usage: devclone <repository-url>"
    return 1
  fi

  # Supported examples:
  # - https://github.com/owner/repo.git
  # - ssh://git@github.com/owner/repo.git
  # - git@github.com:owner/repo.git
  if [[ "$url" == https://* || "$url" == http://* || "$url" == ssh://* ]]; then
    rest="${url#*://}"        # Strip scheme
    rest="${rest#*@}"         # Strip optional user@
    host="${rest%%/*}"
    repo_path="${rest#*/}"
  elif [[ "$url" == *@*:* ]]; then
    rest="${url#*@}"
    host="${rest%%:*}"
    repo_path="${rest#*:}"
  else
    echo "Unsupported URL format: $url"
    return 1
  fi

  repo_path="${repo_path%.git}"
  repo_path="${repo_path#/}"
  repo_path="${repo_path%%/}"

  if [[ -z "$host" || -z "$repo_path" || "$repo_path" == "$rest" ]]; then
    echo "Could not parse repository URL: $url"
    return 1
  fi

  target_dir="${dev_root}/${host}/${repo_path}"

  if [[ -e "$target_dir" ]]; then
    echo "Target already exists: $target_dir"
    return 1
  fi

  mkdir -p "$(dirname "$target_dir")" || return
  git clone -- "$url" "$target_dir" || return
  cd "$target_dir" || return
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
