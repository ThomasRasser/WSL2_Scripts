#!/bin/bash
# File: iswinp.sh
# Author: Thomas Rasser
# Created: 2024-11-06
# Purpose: Checks if a given path is a valid windows or wsl path

# This function checks if a given path is a valid windows or wsl path
# Usage: iswinp [PATH] or echo [PATH] | iswinp
# Returns: 0: valid Windows path
#          1: otherwise

# in WSL
# wsl: /home/thomas/desktop/
# win: /mnt/c/Users/thomas/Desktop

# in Windows
# wsl: \\wsl.localhost\Ubuntu\home\thomas\desktop
# win: C:\Users\thomas\Desktop

source "/home/thomas/desktop/projects/1_Programming/1_Pure_Language/10_Shell/2_CopyPathWindows/debug.sh"

function iswinp() {

    local fn_name="iswinp"
    local usage
    usage=$(printf "[%s] Usage: %s [PATH] or echo [PATH] | %s\n" "$fn_name" "$fn_name" "$fn_name") || return 1

    local input_path

    # Check if input is provided via pipe or as an argument
    debug_log "[%s] Trying to read input." "$fn_name"
    if [ -p /dev/stdin ]; then
        # Read the first line from stdin
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
        echo "$usage"
        return 1
    fi

    # Check if the path does NOT start with '\\'
    # or a drive letter (e.g. 'C:\')
    local start_2=${input_path:0:2}
    # ^\\\\ is invalid, therefore we check the only the first 2 characters for \\\\
    local start_3=${input_path:0:3}
    if [[ ! "$start_2" =~ \\\\ && ! "$start_3" =~ ^[A-Za-z]: ]]; then
        debug_log "[%s] This path does not start with '\\\\\\\\' or a drive letter (e.g. 'C:\\').\n" "$fn_name"
        return 1
    fi

    # Check if the path contains invalid characters
    debug_log "[%s] Checking for invalid characters in the path." "$fn_name"
    if [[ "$input_path" =~ [\*\?\"\<\>\|\:\/] ]]; then
        debug_log "[%s] The path contains invalid characters." "$fn_name"
        return 1
    fi

    # The following checks have been removed to improve runtime,
    # since powershell commands are notoriously slow in WSL

    # Check if the path exists
    # debug_log "[%s] Checking if the path exists via PowerShell: %s" "$fn_name" "$input_path"
    # ps_output=$(powershell.exe -Command "if (Test-Path '$input_path') { exit 1 } else { exit 0 }" 2>&1)
    # ps_exit_code=$?
    # if (( ps_exit_code == 0 )); then
    #     debug_log "[%s] The path does not exist. PowerShell output: %s" "$fn_name" "$ps_output"
    #     return 1
    # fi

    debug_log "[%s] This path is a valid Windows path:\n%s.\n" "$fn_name" "$input_path"
    return 0
}
