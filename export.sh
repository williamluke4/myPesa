#!/bin/bash

# Define the root directory to search and the output file
root_dir="./lib/" # Change this to your directory path
output_file="./exported.txt" # Change this to your output file path

# Check if the output file already exists and clear its contents
> "$output_file"

# Function to append file path and content to the output file
append_file_content() {
    local file="$1"
    # Check if the file is ignored by git
    if git -C "$(dirname "$file")" check-ignore "$file" > /dev/null 2>&1; then
        echo "Skipping ignored file: $file"
    else
        echo "File: $file" >> "$output_file"
        cat "$file" >> "$output_file"
        echo -e "\n" >> "$output_file"
    fi
}

# Export the function so it can be used by find's exec
export -f append_file_content
export output_file

# Navigate to the root directory
cd "$root_dir"

# Make sure we are in a git repository
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    # Find all files and append their path and content to the output file
    find . -type f -exec bash -c 'append_file_content "$0"' {} \;
    echo "Processing completed. Check the output in $output_file"
else
    echo "Error: The specified directory is not part of a git repository."
fi