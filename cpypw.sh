#!/bin/bash
# File: cpypw.sh
# Author: Thomas Rasser
# Created: 2023-11-27
# Purpose: Convert a WSL Linux path to its Windows counterpart
#          and copy it to the clipboard

# This function converts a WSL Linux path to its Windows counterpart
# and copies it to the clipboard
# Usage: cpypw [PATH] or echo [PATH] | cpypw
function cpypw {

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
    echo "Usage: cpypw [PATH] or echo [PATH] | cpypw"
    return 1
  fi

  # check if clip.exe is available
  if ! command -v clip.exe &> /dev/null
  then
    echo "clip.exe could not be found. Please install it first."
    return 1
  fi

  # Replace all '/' with '\'
  local win_path=$(echo "$input_path" | sed 's/\//\\\\/g')

  # Check if path is already on the windows drive on or WSL
  if [[ "$input_path" == "/mnt/c"* ]]; then
    # Repalce "mnt/c" with "C:"
    echo "$win_path" | sed 's/\\mnt\\c/C:/g' | clip.exe
  else
    # Prepend the WSL path
    echo "\\\\\\wsl.localhost\\\\Ubuntu$win_path" | clip.exe
  fi

  return 1
}
