## Shell Setup
#
# Vanity configurations
##
export PROMPT='%1~ > ';

## Platform Detection
#
# Set BREW_PREFIX once; everything else derives from it.
##
if [[ "$(uname -s)" == "Darwin" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
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
    eval "$("${BREW_PREFIX}/bin/brew" shellenv)"
fi

# Load syntax highlighting (installed via brew)
if [[ -f "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Lazy load completions
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qNmh+24) ]]; then
    compinit -d ${ZDOTDIR:-${HOME}}/.zcompdump
else
    compinit -C -d ${ZDOTDIR:-${HOME}}/.zcompdump
fi

brew() {
    command brew "$@"
    if [[ "$1" = "upgrade" ]]; then
        command brew bundle install --upgrade
    elif [[ "$1" = "install" ]]; then
        command brew bundle add "$2"
    elif [[ "$1" = "cleanup" ]]; then
        command brew bundle -f cleanup
    fi
}

## Path
#
# Path things — use $HOME instead of /Users/$USER so it works everywhere
##
typeset -U path
path=(
    "${HOME}/Developer/scripts"
    "${HOME}/go/bin"
    "${HOME}/.cargo/bin"
    "${HOME}/.local/bin"
    $path
)

## NodeJS sucks
#
# Setting up NVM for Node version mgmgt (lazy loaded)
##
export NVM_DIR="$HOME/.nvm"
nvm() {
    unfunction nvm
    local nvm_script="${BREW_PREFIX}/opt/nvm/nvm.sh"
    [ -s "$nvm_script" ] && \. "$nvm_script"
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
  if [[ -d "$query" ]]; then
    cd "$query" || return
    return
  fi
  if [[ -d "${dev_root}/${query}" ]]; then
    cd "${dev_root}/${query}" || return
    return
  fi
  local target
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
  if [[ "$url" == https://* || "$url" == http://* || "$url" == ssh://* ]]; then
    rest="${url#*://}"
    rest="${rest#*@}"
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
# Completions — Docker Desktop on macOS vs system Docker on Linux
##
if [[ -d "${HOME}/.docker/completions" ]]; then
    fpath=("${HOME}/.docker/completions" $fpath)
fi
