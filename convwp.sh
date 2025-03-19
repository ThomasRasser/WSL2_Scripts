#!/bin/bash

# File: convwp.sh
# Author: Thomas Rasser
# Created: 2024-08-27
# Purpose: Convert a Windows path to its WSL Linux counterpart

# This function converts a Windows path to its WSL Linux counterpart
# But it does only work with full paths, not relative paths
# Usage: convwp [PATH] or echo [PATH] | convwp
# Output: <path of given file in wsl format>

source "/home/thomas/desktop/projects/1_Programming/1_Pure_Language/10_Shell/2_CopyPathWindows/debug.sh"

function convwp {

  local input_path
  local fn_name="convwp"

  # Check if input is provided via pipe or as an argument
  if [ -p /dev/stdin ]; then
    # Read the first line from stdin
    read -r input_path
  elif [ $# -eq 1 ]; then
    input_path=$1
  elif [ $# -eq 0 ]; then
    input_path=$(pwd)
  else
    echo "Usage: convwp [PATH] or echo [PATH] | convwp"
    return 1
  fi

  # Check if sed is available
  if ! command -v sed &> /dev/null
  then
    printf "[%s] sed could not be found. Please install it first.\n" "$fn_name"
    return 1
  fi

  # Check if iswslp is available
  if ! command -v iswslp &> /dev/null
  then
    printf "[%s] iswslp could not be found. Please install it first.\n" "$fn_name"
    return 1
  fi

  # Check if it already is a valid wsl path
  if iswslp "$input_path" > /dev/null 2>&1; then
    printf "%s" "$input_path"
    return 0
  fi

  # Check if iswinp is available
  if ! command -v iswinp &> /dev/null
  then
    printf "[%s] iswinp could not be found. Please install it first.\n" "$fn_name"
    return 1
  fi

  # Check if it is a valid windows path
  if ! iswinp "$input_path" > /dev/null 2>&1; then
    printf "[%s] Invalid Path: %s\n" "$fn_name" "$input_path"
    return 1
  fi

  # Replace all '\\' with '/'
  local wsl_path
  wsl_path=$(printf "%s\n" "$input_path" | sed 's/\\/\//g') || return 1

  # If it starts with '/wsl.localhost/Ubuntu, remove it
  if [[ "$wsl_path" =~ ^/wsl\.localhost/Ubuntu ]]; then
    wsl_path="${wsl_path#/wsl.localhost/Ubuntu}"
  # Convert the Windows drive letter to the WSL mount point
  elif [[ "$wsl_path" =~ ^([A-Za-z]): ]]; then
    # Extract the drive letter and convert it to lowercase
    local drive_letter
    drive_letter=$(echo "$match[1]" | tr '[:upper:]' '[:lower:]') || return 1
    # Replace the drive letter with /mnt/drive_letter and adjust the path
    wsl_path="/mnt/$drive_letter${wsl_path:2}"
  fi

  # Check if the path is not valid on WSL
  if [[ ! -e "$wsl_path" ]]; then
    printf "[%s] Invalid Path: %s\n" "$fn_name" "$wsl_path"
    return 1
  fi

  printf "%s\n" "$wsl_path"
  return 0
}
