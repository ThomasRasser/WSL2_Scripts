#!/bin/bash
# File: convpw.sh
# Author: Thomas Rasser
# Created: 2023-11-27
# Purpose: Convert a WSL Linux path to its Windows counterpart

# This function converts a WSL Linux path to its Windows counterpart
# Usage: convpw [PATH] or echo [PATH] | convpw
# Output: <path of given file in windows format>
function convpw {

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
    echo "Usage: convpw [PATH] or echo [PATH] | convpw"
    return 1
  fi

  # Resolve relative path to absolute path
  local abs_path=$(realpath "$input_path")

  # Replace all '/' with '\\'
  local win_path=$(echo "$abs_path" | sed 's/\//\\\\/g')

  # Check if path is already on the windows drive or on WSL
  if [[ "$abs_path" == "/mnt/c"* ]]; then
    # Replace "mnt/c" with "C:"
    echo "$win_path" | sed 's/\\mnt\\c/C:/g'
  else
    # Prepend the WSL path
    echo "\\\\\\wsl.localhost\\\\Ubuntu$win_path"
  fi

  return 0
}
