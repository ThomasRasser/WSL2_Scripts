#!/bin/bash
# File: cdwin.sh
# Author: Thomas Rasser
# Created: 2024-08-27
# Purpose: Convert a Windows path to its WSL Linux counterpart
#          and changes to this directory

# This function converts a Windows path to its WSL Linux counterpart
# and changes to this directory, if it exists
# But it does only work with full paths, not relative paths
# Usage: cdwin [PATH]

function cdwin() {

    # Validate input
    if [[ $# -ne 1 ]]; then
        echo "Usage: cdwin [Windows path]"
        return 1
    fi
    local input_path="$1"

    # Use convwp to convert the windows path into its WSL counterpart
    local linux_path
    linux_path=$(convwp "$input_path") || return 1

    # Check if the converted path exists and change directory
    if [[ -e "$linux_path" ]]; then
        cd "$linux_path"
        return 0
    else
        echo "Path does not exist: $linux_path"
        return 1
    fi
}
