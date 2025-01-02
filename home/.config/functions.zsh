
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