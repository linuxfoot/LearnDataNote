#!/usr/bin/env bash

# Function to display introductory message and the year
eec() {
  echo "File Janitor, $(date +%Y)" # Display current year
  echo -e "Powered by Bash\n" # Credit the scripting language
}

# Start of the case statement to handle script input
case $1 in
  "" ) # No argument provided, show help message
    eec
    echo -e "\nType file-janitor.sh help to see available options" # Guidance for the user
  ;;
  "help" ) # 'help' argument provided, display help text
    eec
    cat ./file-janitor-help.txt # Display contents of help text file
  ;;
  "report" ) # 'report' argument provided, generate file report
    shift 1 # Shift arguments for sub-case
    case ${1} in
      "" ) # No sub-argument, report on current directory
        eec 
        echo -e "The current directory contains:\n"
        for i in "tmp" "log" "py" ;do # Loop through specified file types
          sizze=0 # Initialize size variable
          ssum=$( find . -type f -name "*$i" -maxdepth 1 -exec ls -l {} \; | awk '{ sum += $5 } END { printf "%d" , sum }' ) # Sum file sizes
          sizze=$(( $ssum + 0 )) # Convert to integer
          nu=$( find . -type f -name "*" -maxdepth 1 | grep "$i" | wc -l ) # Count files
          if [[ $nu -eq 0 ]]; then sizze=0; fi # If no files, set size to 0
          echo "$nu $i file(s), with total size of ${sizze} bytes" # Output file count and size
        done
      ;;
      * ) # Sub-argument provided, report on specified directory
        if [[ ! -d "${1}" ]]; then # Check if directory exists
          eec
          echo "$1 is not found" # Directory not found message
        fi  
        if [[ -f "${1}" ]]; then # Check if not a file
          eec
          echo "$1 is not a directory" # Not a directory message
        fi
        if [[ -d "${1}" ]]; then # If directory exists
          eec
          echo -e "${1} contains:\n"
          # Similar logic to above for specified directory
          for i in "tmp" "log" "py" ;do
            # ...
            echo "$nu $i file(s), with total size of ${sizze} bytes"
          done
        fi
      ;;
    esac
  ;;
  "clean" ) # 'clean' argument provided, clean files
    shift 1 # Shift arguments for sub-case
    case ${1} in
      "" ) # No sub-argument, clean current directory
        eec   
        echo -e "Cleaning the current directory...\n"
        # Loop through file types with different cleaning strategies
        for i in "tmp" "log" "py" ;do
          case $i in 
            "log" )
              nul=$( find . -type f -name "*$i" -maxdepth 1 -mtime +3 | wc -l ) # Count old log files
              find . -type f -name "*$i" -maxdepth 1 -mtime +3 -delete # Delete old log files
              ;;
            "tmp" )
              nut=$( find . -type f -name "*$i" -maxdepth 1 | wc -l ) # Count temporary files
              find . -type f -name "*$i" -maxdepth 1 -delete # Delete temporary files
              ;;
            "py" )
              ppath=$(echo "./python_scripts") # Target path for python files
              nup=$( find . -type f -name "*$i" -maxdepth 1 | wc -l ) # Count python files
              if [[ ! -d ${ppath} ]] && [[ $nup -gt 0 ]]; then # Create target directory if necessary
                mkdir -p ${ppath}
              fi
              find . -type f -name "*$i" -maxdepth 1 -exec mv {} ${ppath} \; # Move python files
              ;;
          esac
        done
        echo "Deleting old log files...   done! $nul files have been deleted"
        echo "Deleting temporary files...  done! $nut files have been deleted"
        echo "Moving python files...  done! $nup files have been moved"
        echo -e "\nClean up of the current directory is complete!"
      ;;
      * ) # Sub-argument provided, clean specified directory
        # Similar logic to above for specified directory
        if [[ -d "${1}" ]]; then
          # ...
          echo -e "\nClean up of ${1} is complete!"
        fi
      ;;
    esac
  ;;
  "list" ) # 'list' argument provided, list files
    shift 1 # Shift arguments for sub-case
    case ${1} in
      "" ) # No sub-argument, list current directory
        eec 
        echo -e "Listing files in the current directory\n"
        find ./ -name '*' -maxdepth 1 -not -name '.' -exec basename {} \; # List non-hidden files
      ;;
      * ) # Sub-argument provided, list specified directory
        if [[ ! -d "${1}" ]]; then # Check if directory exists
          eec
          echo "$1 is not found" # Directory not found message
        fi  
        if [[ -f "${1}" ]]; then # Check if not a file
          eec
          echo "$1 is not a directory" # Not a directory message
        fi
        if [[ -d "${1}" ]]; then # If directory exists
          eec
          echo -e "Listing files in ${1}\n "
          ls ${1} -a -I "." -I ".." # List all files in directory, excluding '.' and '..'
        fi
      ;;
    esac
  ;;
  * ) # Default case for any other argument
    eec
    echo -e "\nType file-janitor.sh help to see available options" # Guidance for the user
  ;;
esac