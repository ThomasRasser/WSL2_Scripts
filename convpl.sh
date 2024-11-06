#!/bin/bash
# File: convpl.sh
# Author: Thomas Rasser
# Created: 2024-08-27
# Purpose: Convert a Windows path to its WSL Linux counterpart

# This function converts a Windows path to its WSL Linux counterpart
# But it does only work with full paths, not relative paths
# Usage: convpl [PATH] or echo [PATH] | convpl
# Output: <path of given file in wsl format>
function convpl {

  local input_path

  # Check if input is provided via pipe or as an argument
  if [ -p /dev/stdin ]; then
    # Read the first line from stdin
    read input_path
  elif [ $# -eq 1 ]; then
    input_path=$1
  elif [ $# -eq 0 ]; then
    input_path=$(pwd)
  else
    echo "Usage: convpl [PATH] or echo [PATH] | convpl"
    return 1
  fi

  # Replace all '\\' with '/'
  local wsl_path=$(printf "%s\n" "$input_path" | sed 's/\\/\//g')

  # Convert the Windows drive letter to the WSL mount point
  if [[ "$wsl_path" =~ ^([A-Za-z]): ]]; then
    # Extract the drive letter and convert it to lowercase
    local drive_letter=$(echo "$match[1]" | tr '[:upper:]' '[:lower:]')
    # Replace the drive letter with /mnt/drive_letter and adjust the path
    wsl_path="/mnt/$drive_letter${wsl_path:2}"
  fi

  # Check if the path is not valid on WSL
  if [[ ! -e "$wsl_path" ]]; then
    echo "Invalid Path"
    return 1
  fi

  printf "%s" "$wsl_path"
  return 0
}
