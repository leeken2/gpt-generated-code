#!/bin/bash

filename="/C/Users/ircloud/Desktop/project77/ircloud-ydp-web/src/common/router/paths.js"
filename_routes="/C/Users/ircloud/Desktop/project77/ircloud-ydp-web/src/common/router/routes.ts"

if [ ! -f "$filename" ]; then
    echo "File not found."
    exit 1
fi

if [ ! -f "$filename_routes" ]; then
    echo "Output file not found."
    exit 1
fi

while true; do
    read -p "Enter the keyword to search (type 'exit' to end): " keyword

    if [ "$keyword" == "exit" ]; then
        echo "Exiting script."
        exit 0
    fi

    # Trim leading and trailing whitespace from the keyword
    keyword=$(echo "$keyword" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Check if the keyword is empty
    if [ -z "$keyword" ]; then
        echo "Keyword cannot be empty. Please enter a valid keyword."
        continue
    fi

    echo "------------------------------------"

    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/:.*//')  # Remove line numbers
        variable_name=$(echo "$line" | awk '{print $3}')
        echo -e "[-]Matching line: \n \e[1;32m$line\e[0m"
        echo -e "[-]Extracted variable name: \n \e[1;32m$variable_name\e[0m"

        # Read the file content into a variable
        content=$(< "$filename_routes")

        # Use regular expression to match content within curly braces
        while [[ $content =~ \{([^}]*)\} ]]; do
            matched_content="${BASH_REMATCH[1]}"
            if [[ $matched_content == *"$variable_name"* ]]; then
                echo -e "Extracted content: \e[1;32m$matched_content \e[0m"
            fi
            content=${content#*"${BASH_REMATCH[0]}"}
        done
        echo '-------------------------------------------'
        echo 
    done < <(grep -i "$keyword" "$filename")
done
