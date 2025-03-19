#!/bin/bash
# File: iswslp.sh
# Author: Thomas Rasser
# Created: 2024-11-06
# Purpose: Checks if a given path is a valid windows or wsl path

# This function checks if a given path is a valid windows or wsl path
# Usage: iswslp [PATH] or echo [PATH] | iswslp
# Returns: 0: valid WSL path
#          1: otherwise

source "/home/thomas/desktop/projects/1_Programming/1_Pure_Language/10_Shell/2_CopyPathWindows/debug.sh"

function iswslp() {

    local fn_name="iswslp"
    local usage
    usage=$(printf "[%s] Usage: %s [PATH] or echo [PATH] | %s\n" "$fn_name" "$fn_name" "$fn_name") || return 1

    local input_path

    # Check if input is provided via pipe or as an argument
    debug_log "[%s] Trying to read input." "$fn_name"
    if [ -p /dev/stdin ]; then
        read -r input_path
        debug_log "[%s] Input received via pipe: %s" "$fn_name" "$input_path"
    elif [ $# -eq 1 ]; then
        debug_log "[%s] Input received as argument: %s" "$fn_name" "$1"
        input_path=$1
    else
        debug_log "[%s] No input provided, printing usage." "$fn_name"
        echo "$usage"
        return 1
    fi

    # Check if input is empty
    debug_log "[%s] Checking if input is empty." "$fn_name"
    if [[ -z "$input_path" ]]; then
        debug_log "[%s] Input is empty." "$fn_name"
        return 1
    fi

    # Check if the path does not start with '/'
    debug_log "[%s] Checking if the path starts with '/'" "$fn_name"
    if [[ ! "$input_path" =~ ^/ ]]; then
        debug_log "[%s] This path does not start with '/'.\n" "$fn_name"
        return 1
    fi

    # Check if the path contains invalid characters
    debug_log "[%s] Checking if the path contains invalid characters." "$fn_name"
    if [[ "$input_path" =~ [\*\?\"\<\>\|\:] ]]; then
        debug_log "[%s] This path contains invalid characters.\n" "$fn_name"
        return 1
    fi

    # Check if the path does not exist
    debug_log "[%s] Checking if the path exists." "$fn_name"
    if [[ ! -e "$input_path" ]]; then
        debug_log "[%s] This path does not exist.\n" "$fn_name"
        return 1
    fi

    # Path is a valid WSL path and exists
    debug_log "[%s] This path is a valid WSL path:\n%s\n" "$fn_name" "$input_path"
    return 0
}
