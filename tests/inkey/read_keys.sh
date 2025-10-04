#!/bin/bash

# Check if number of keypresses is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <number_of_keypresses>"
    exit 1
fi

# Store the number of keypresses needed
max_keys=$1
count=0
key_buffer=""

# Function to handle cleanup
cleanup() {
    # Restore terminal settings if we're in a terminal
    if [ -n "$old_settings" ]; then
        stty "$old_settings"
    fi
}

# Save current terminal settings and check if we're in a terminal
if [ -t 0 ]; then
    old_settings=$(stty -g)
    # Set terminal to raw mode
    stty raw -echo
else
    old_settings=""
fi

# Trap for cleanup on script exit
trap cleanup EXIT

echo "Press keys (Enter to finish early). Waiting for $max_keys keys..."

while [ $count -lt $max_keys ]; do
    # Read a single character with timeout
    IFS= read -r -n1 -t 0.1 char || true
    
    # Break on EOF or Enter key
    if [ $? -gt 128 ]; then
        continue
    elif [ -z "$char" ] || [ "$char" = $'\n' ] || [ "$char" = $'\r' ]; then
        break
    fi
    
    # Append the character to our buffer
    key_buffer="$key_buffer$char"
    ((count++))
    
    # Print the character (since echo is off)
    echo -n "$char"
done

# Print a newline since we're in raw mode
echo

# Restore terminal settings (this will also happen via trap)
cleanup

echo "Keys pressed: $count"
echo "Characters entered: $key_buffer"