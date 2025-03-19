#!/bin/bash
# File: debug.sh
# Author: Thomas Rasser
# Created: 2025-03-19
# Purpose: Store debug information of other scripts into a common file

# This script is used to store debug information of other scripts into a common file
# Usage: debug_log [MESSAGE]

# Set the debug mode: 1 for enabled, 0 for disabled
DEBUG=1

# Set the debug file path
DEBUG_FILE_PATH="/home/thomas/desktop/projects/1_Programming/1_Pure_Language/10_Shell/2_CopyPathWindows/debug.log"

function debug_log() {
  if ((DEBUG)); then
    printf "%s\n" "$(printf "$@")" >> "$DEBUG_FILE_PATH"
  fi
}
