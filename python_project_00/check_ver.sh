#!/bin/bash
 if [ ! -f version.txt ]; then
    echo "version.txt file not found!"
    exit 1
  fi
  if ! grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' version.txt; then
    echo "version.txt does not contain a valid version number!"
    exit 1
  fi