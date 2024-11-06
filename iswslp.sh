#!/bin/bash
# File: iswinp.sh
# Author: Thomas Rasser
# Created: 2024-11-06
# Purpose: Checks if a given path is a valid windows or wsl path

# This function checks if a given path is a valid windows or wsl path
# Usage: iswinp [PATH] or echo [PATH] | iswinp
# Returns: 0: valid WSL path
#          1: otherwise

iswslp() {

    local input_path

    # Check if input is provided via pipe or as an argument
    if [ -p /dev/stdin ]; then
        # Read the first line from stdin
        read input_path
    elif [ $# -eq 1 ]; then
        input_path=$1
    else
        echo "Usage: cpypw [PATH] or echo [PATH] | cpypw"
        return 1
    fi

    if [[ -z "$input_path" ]]; then
        echo "Usage: iswinp [PATH]"
        return $input_path_type$
    fi

    # Check if the path does not start with '/'
    if [[ ! "$input_path" =~ ^/ ]]; then
        echo "This path does not start with '/'."
        return 1
    fi

    # Check if the path contains invalid characters
    if [[ "$input_path" =~ [\*\?\"\<\>\|\:] ]]; then
        echo "This path contains invalid characters."
        return 1
    fi

    # Check if the path does not exist
    if [[ ! -e "$input_path" ]]; then
        echo "Invalid Path"
        return 1
    fi

    # Path is valid and exists
    printf "%s is a valid WSL path.\n" "$input_path"
    return 0
}
