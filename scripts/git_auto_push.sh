#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo "Dummy script has been called at: $(date '+%Y-%m-%d %H:%M:%S') " >> "$SCRIPT_DIR/../log/dummy_log.log"

COMMIT_MSG_FILE="$SCRIPT_DIR/../txt/commit_message.txt"

# check if the file exists: 
if [ ! -f "$COMMIT_MSG_FILE" ]; then
    echo "Commit message file not found: $COMMIT_MSG_FILE"
    exit 1
fi 

# get the current git branch: 
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Current branch: $BRANCH" 


# stage files: 
git add -A 

# commit using the message file: 
git commit -F "$COMMIT_MSG_FILE"

# push: 
git push origin "$BRANCH"