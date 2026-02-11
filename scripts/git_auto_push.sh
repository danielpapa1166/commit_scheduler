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


# set the git repo directory: 
# directory can be passed as argument to be used to push to different remote 
REPO_DIR="${1:-$SCRIPT_DIR/..}" 
echo "             Repo: $REPO_DIR " >> "$LOG_FILE"
# get the current git branch: 
BRANCH=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
echo "             Branch: $BRANCH " >> "$LOG_FILE"

if [ -z "$BRANCH" ]; then 
    echo "Not a git repository: $REPO_DIR"
    echo "             Failed: Not a git repository: $REPO_DIR " >> "$LOG_FILE"
    exit 1
fi

# stage files: 
echo "Stating files " 
git -C "$REPO_DIR" add -A 
echo "             Staging files: Done " >> "$LOG_FILE"

# commit using the message file: 
echo "Commit files " 
git -C "$REPO_DIR" commit -F "$COMMIT_MSG_FILE"
echo "             Commit: Done. From message file $COMMIT_MSG_FILE " >> "$LOG_FILE"

# push: 
echo "Pushing to origin: " 
git -C "$REPO_DIR" push origin "$BRANCH"
echo "             Pushing to origin: Done " >> "$LOG_FILE"
