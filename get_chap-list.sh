#!/bin/bash

# Define the directory containing .qmd files
directory="chapters"

# Create or clear the output file
> my_chapters.txt

# List all .qmd files in the specified directory and prepend each line with "- "
for file in "$directory"/*.qmd; do
    echo "- $file" >> my_chapters.txt
done
