#!/bin/bash
# File: cpypf.sh
# Author: Thomas Rasser
# Created: 2023-11-27
# Purpose: Copy a path to a file into the windows clipboard 
# Usage: cpypf [FILE] or echo [FILE] | cpypf
# Output:  <None>
function cpyp {
  
  local input_file

  # Check if input is provided via pipe or as an argument
  if [ -p /dev/stdin ]; then
    # Read the first line from stdin
    read input_file
  elif [ $# -eq 1 ]; then
    input_file=$1
  elif [ $# -eq 0 ]; then
    pwd | clip.exe
    return 0
  else
    echo "Usage: cpypf [PATH] or echo [PATH] | cpypf"
    return 1
  fi

  # check if clip.exe is available
  if ! command -v clip.exe &> /dev/null
  then
    echo "clip.exe could not be found. Please install it first."
    return 1
  fi
  
  # Copy the path to the file into the clipboard
  readlink -f "$input_file" | clip.exe

  return 0
}