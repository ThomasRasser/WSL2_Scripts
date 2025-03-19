#!/bin/bash

# File: convlp.sh
# Author: Thomas Rasser
# Created: 2023-11-27
# Purpose: Convert a WSL Linux path to its Windows counterpart

# This function converts a WSL Linux path to its Windows counterpart
# Usage: convlp [PATH] or echo [PATH] | convlp
# Output: <path of given file in windows format>

source "/home/thomas/desktop/projects/1_Programming/1_Pure_Language/10_Shell/2_CopyPathWindows/debug.sh"

function convlp {
  local fn_name="convlp"
  local usage=$(printf "[%s] Usage: %s [PATH] or echo [PATH] | %s\n" "$fn_name" "$fn_name" "$fn_name")
  local input_path

  # Check if input is provided via pipe or as an argument
  debug_log "[%s] Trying to read input." "$fn_name"
  if [ -p /dev/stdin ]; then
    # Read the first line from stdin
    read input_path
    debug_log "[%s] Input received via pipe: %s" "$fn_name" "$input_path"
  elif [ $# -eq 1 ]; then
    debug_log "[%s] Input received as argument: %s" "$fn_name" "$1"
    input_path=$1
  elif [ $# -eq 0 ]; then
    debug_log "[%s] No input provided. Using current working directory: %s" "$fn_name" "$(pwd)"
    input_path=$(pwd)
  else
    echo "$usage"
    debug_log "[%s] Invalid input received." "$fn_name"
    return 1
  fi

  # Check if iswinp is available
  debug_log "[%s] Checking if iswinp is available." "$fn_name"
  iswinp_path=$(command -v iswinp)
  if [[ -z "$iswinp_path" ]]; then
      debug_log "[%s] iswinp could not be found. Please install it first." "$fn_name"
      return 1
  else
      debug_log "[%s] iswinp is available at: %s" "$fn_name" "$iswinp_path"
  fi

  # Check if it is already a valid windows path
  debug_log "[%s] Checking if the input path is a valid Windows path." "$fn_name"
  if printf "%s\n" "$input_path" | iswinp ; then
    debug_log "[%s] The input path is already a valid Windows path and MUST NOT be converted." "$fn_name"
    printf "%s" "$input_path"
    return 0
  else
    debug_log "[%s] The input path is not a valid Windows path and MUST be converted." "$fn_name"
  fi

  # Check if iswslp is available
  debug_log "[%s] Checking if iswslp is available." "$fn_name"
  iswslp_path=$(command -v iswslp)
  if [[ -z "$iswslp_path" ]]; then
    debug_log "[%s] iswslp could not be found. Please install it first." "$fn_name"
    return 1
  else
    debug_log "[%s] iswslp is available at: %s" "$fn_name" "$iswslp_path"
  fi

  # Check if it is a valid WSL path
  debug_log "[%s] Checking if the input path is a valid WSL path: %s" "$fn_name" "$input_path"
  iswslp_output=$(printf "%s\n" "$input_path" | iswslp 2>&1)
  iswslp_exit_code=$?  # Store exit code
  if (( iswslp_exit_code != 0 )); then
      debug_log "[%s] Invalid WSL Path: %s. iswslp output: %s" "$fn_name" "$input_path" "$iswslp_output"
      return 0
  else
      debug_log "[%s] Valid WSL Path confirmed: %s" "$fn_name" "$input_path"
  fi

  # Resolve relative path to absolute path
  local abs_path=$(realpath "$input_path")
  debug_log "[%s] Resolved absolute path: %s" "$fn_name" "$abs_path"

  # Replace all '/' with '\\'
  local win_path=$(echo "$abs_path" | sed 's/\//\\\\/g')
  debug_log "[%s] Converted slashes to double-backslashes: %s" "$fn_name" "$win_path"

  # Check if path is already on the windows drive or on WSL
  if [[ "$abs_path" == "/mnt/c"* ]]; then
    # Replace "mnt/c" with "C:"
    win_path=$(echo "$win_path" | sed 's/\\mnt\\c/C:/g')
  else
    # Prepend the WSL prefix
    win_path=$(echo "\\\\\\wsl.localhost\\\\Ubuntu$win_path")
  fi
  debug_log "[%s] Changed path to Windows format: %s" "$fn_name" "$win_path"

  # Check if the created win path is valid
  debug_log "[%s] Checking if the created Windows path is valid: %s" "$fn_name" "$win_path"
  iswinp_output=$(printf "%s\n" "$win_path" | iswinp 2>&1)
  iswinp_exit_code=$?
  if (( iswinp_exit_code == 1 )); then
      debug_log "[%s] Invalid Windows Path: %s. iswinp output: %s" "$fn_name" "$win_path" "$iswinp_output"
      return 1
  fi

  debug_log "[%s] Converted WSL path to Windows path: %s" "$fn_name" "$win_path"
  printf "%s\n" "$win_path"
  return 0
}
