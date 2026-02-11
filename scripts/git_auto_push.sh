#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

LOG_DIR="$SCRIPT_DIR/../log"
LOG_FILE="$LOG_DIR/auto_push.log"

mkdir -p "$LOG_DIR"
echo "Auto-push at: $(date '+%Y-%m-%d %H:%M:%S') " >> "$LOG_FILE"

COMMIT_MSG_FILE="$SCRIPT_DIR/../txt/commit_message.txt"

# check if the file exists: 
if [ ! -f "$COMMIT_MSG_FILE" ]; then
    echo "Commit message file not found: $COMMIT_MSG_FILE"
    exit 1
fi 

echo "Add SSH agent for authentication" 
# only works with no pw: todo: check if needed at all 
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_ed25519

# set the git repo directory: 
REPO_DIR="$SCRIPT_DIR/.."

# get the current git branch: 
BRANCH=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)


if [ -z "$BRANCH" ]; then 
    echo "Not a git repository: $REPO_DIR"
    exit 1
fi

echo "Current branch: $BRANCH" 


# stage files: 
echo "Stating files " 
git -C "$REPO_DIR" add -A 

# commit using the message file: 
echo "Commit files " 
git -C "$REPO_DIR" commit -F "$COMMIT_MSG_FILE"

# push: 
echo "Pushing to origin " 
git -C "$REPO_DIR" push origin "$BRANCH"