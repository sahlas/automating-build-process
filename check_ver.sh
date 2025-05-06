#!/bin/bash
          # Check if version.txt exists
   if [ ! -f ./version.txt ]; then
            echo "version.txt file not found!"
            exit 1
          fi
          if ! grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' version.txt; then
            echo "version.txt does not contain a valid version number!"
            exit 1
          fi

          # Check if version.txt is empty
          # if [ ! -s version.txt ]; then
          #   echo "version.txt is empty!"
          #   exit 1
          # fi

          # # Check if version.txt in parent directory
          # if [ ! -f ../version.txt ]; then
          #   echo "version.txt not found in parent directory!"
          #   exit 1
          # fi
          # Check if version.txt is in current or any subdirectory
          # if [ -f version.txt ]; then
          #   echo "version.txt found in current directory!"
          #   exit 1
          # fi
          # # Check if version.txt contains a valid version string
          # if ! grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' version.txt; then
          #   echo "version.txt does not contain a valid version string!"
          #   exit 1
          # fi
