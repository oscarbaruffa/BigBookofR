#!/bin/bash

# Define the directory containing .qmd files
directory="chapters"

# Filename for the list
output_file="chapter_list.txt"

# Add the specific file that should start the list
echo "- $directory/Career and Community.qmd" > $output_file

# List all .qmd files in the specified directory except the two specific files, and prepend each line with "- "
for file in "$directory"/*.qmd; do
    if [[ "$file" != "$directory/Career and Community.qmd" && "$file" != "$directory/Other compendiums.qmd" ]]; then
        echo "- $file" >> $output_file
    fi
done

# Add the specific file that should end the list
echo "- $directory/Other compendiums.qmd" >> $output_file
