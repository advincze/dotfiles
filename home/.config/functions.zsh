
# Get the full local path for cloning a git repository
function _clone__get_full_path() {
    local git_url=$1
    local base_dir=~/src

    if [[ -z "$git_url" ]]; then
        echo "Usage: get_clone_path <git_url>"
        return 1
    fi

    # Extract the host and path from the git URL
    if [[ $git_url =~ ^git@([^:]+):(.*)$ ]]; then
        local host=${match[1]}
        local repo_path=${match[2]}
        # Special handling for Azure URLs with 'v3'
        if [[ $host == "ssh.dev.azure.com" && $repo_path =~ ^v3/(.*)$ ]]; then
            repo_path=${match[1]}
        fi
        # Remove 'ssh.' prefix if it exists
        host=${host#ssh.}
    elif [[ $git_url =~ ^ssh://git@([^:/]+)(:[0-9]+)?/(.*)$ ]]; then
        local host=${match[1]}
        local repo_path=${match[3]}
        # Remove 'ssh.' prefix if it exists
        host=${host#ssh.}
    elif [[ $git_url =~ ^https://([^/]+)/(.+)$ ]]; then
        local host=${match[1]}
        local repo_path=${match[2]}
    elif [[ $git_url =~ ^codecommit::([^:]+)://(.*)$ ]]; then
        local host="codecommit"
        local repo_path=${match[2]}
    else
        echo "Unsupported git URL format: $git_url"
        return 1
    fi

    # Determine the full local path for cloning
    local full_path="$base_dir/$host/${repo_path%.*}"
    echo "$full_path"
}

# Clone a git repository into a standard directory structure
function clone() {
    local git_url=$1

    if [[ -z "$git_url" ]]; then
        echo "Usage: clone <git_url>"
        return 1
    fi

    local full_path
    full_path=$(_clone__get_full_path "$git_url")
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    # Create the directory hierarchy if it doesn't exist
    mkdir -p "$(dirname "$full_path")"

    # Clone the repository
    git clone "$git_url" "$full_path"
}

function vs() {
    if [ $# -eq 0 ]; then
        code .
    else
        code "$@"
    fi
}

function cs() {
    if [ $# -eq 0 ]; then
        cursor .
    else
        cursor "$@"
    fi
}

function git_delete_local_branches() {
  # Get the name of the current branch
  local current_branch=$(git symbolic-ref --short HEAD)

  # Get the list of local branches, excluding main, master, and the current branch
  local branches_to_delete=$(git branch | grep -vE "^\*|main|master" | awk '{$1=$1};1')

  if [[ -z "$branches_to_delete" ]]; then
    echo "No branches to delete."
    return 0
  fi

  echo "Deleting the following branches:"
  echo "$branches_to_delete"

  # Delete the branches
  git branch -D $branches_to_delete
}