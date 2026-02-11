#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo "Dummy script has been called at: $(date '+%Y-%m-%d %H:%M:%S') " >> "$SCRIPT_DIR/../log/dummy_log.log"