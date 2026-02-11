#!/bin/bash 

# this scripts schedules the given script to a given date and time 

if [ $# -lt 2 ]; then 
    echo "Invalid number of arguments: $#" 
    exit 1 
fi

DATETIME_RAW="$1" # arg1 should be a datetime  
SCRIPT_PATH="$2" # arg2 executable script path 
GIT_REPO_PATH="$3" # arg3 path to the git repo to push to

# validate script: exists and is executable
if [ ! -x "$SCRIPT_PATH" ]; then # -x tests if the file exists and execuable
    echo "Error: '$SCRIPT_PATH' does not exist or is not executable" 
    exit 1
fi

# convert date to systemd format: 
# time separated with ":" -> "-"
DATETIME=$(echo "$DATETIME_RAW" | sed -E 's/^([0-9]{4})\.([0-9]{2})\.([0-9]{2})\.\s*/\1-\2-\3 /')

# validate datetime: 
if ! systemd-analyze calendar "$DATETIME" &>/dev/null; then 
    echo "Error invalid datetime '$DATETIME'. "
    echo "Parsed from: '$DATETIME_RAW'. "
    exit 1
fi

SCRIPT_NAME=$(basename "$SCRIPT_PATH" .sh) 
TIMER_NAME="oneshot-${SCRIPT_NAME}-$(date +%s)"

echo "    Scheduling: '$SCRIPT_PATH'" 
echo "            At: $DATETIME"
echo "    Timer name: $TIMER_NAME"
echo "" 

systemd-run --user \
    --on-calendar="$DATETIME" \
    --unit="$TIMER_NAME" \
    --timer-property=AccuracySec=0 \
    --description="One Shot Execution: $SCRIPT_PATH at $DATETIME" \
    /bin/bash "$SCRIPT_PATH" "$GIT_REPO_PATH"

if [ $? -eq 0 ]; then 
    echo "Script scheduled successfully" 
else 
    echo "ERROR: Failed to schedule!" 
    exit 1
fi 

# systemctl --user list-timers --all
# systemctl --user stop timer-name 
# journalctl --user -u timer-name.service

# easier usage: in .bashrc: 
# # commit scheduler env vars: 
# export CSCHED="$HOME/projects/commit_scheduler" # add git repo here
# commit_this_at() {
#    GIT_REPO_DIR="$1"
#    TIMESTAMP="$2"
#    "$CSCHED/scripts/commit_at.sh" "$TIMESTAMP" \
#        "$CSCHED/scripts/git_auto_push.sh" "$GIT_REPO_DIR"
# }
