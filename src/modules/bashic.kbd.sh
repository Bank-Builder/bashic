#!/bin/bash
# BASHIC Keyboard Module
# bashic.kbd.sh - Keyboard input handling

# Global variables for keyboard input
BASHIC_INKEY_BUFFER=""  # Buffer for non-interactive input
BASHIC_TTY_SETTINGS=""  # Store original terminal settings

# Initialize keyboard handling
init_keyboard() {
    # Save current terminal settings and check if we're in a terminal
    if [ -t 0 ]; then
        BASHIC_TTY_SETTINGS=$(stty -g)
        # Set terminal to raw mode
        stty raw -echo
    else
        BASHIC_TTY_SETTINGS=""
    fi
}

# Function to convert key to readable name
key_name() {
    local key="$1"
    case "$key" in
        $'\n') echo "ENTER" ;;
        $'\e') echo "ESC" ;;
        # ' ') echo "SPACE" ;;
        $'\t') echo "TAB" ;;
        $'\b') echo "BACKSPACE" ;;
        *) echo "$key" ;;
    esac
}

# Function to handle cleanup
cleanup_keyboard() {
    # Restore terminal settings if we're in a terminal
    if [ -n "$BASHIC_TTY_SETTINGS" ]; then
        stty "$BASHIC_TTY_SETTINGS"
    fi
}

# Get a single character from keyboard or buffer
get_key() {
    local char
    if [ -t 0 ]; then
        # Interactive mode - read directly from terminal
        # local IFS=
        # local char
        
        # Read a single character with timeout
        read -r -n1 -t 4 char
        
        # Check for timeout (no input)
        if [ $? -gt 128 ] || [ -z "$char" ]; then
            echo ""
            return
        fi
        
        echo "$char"
        
        # Print the character (since echo is off) - but skip special keys
        # case "$char" in
        #     $'\n'|$'\r'|$'\e'|$'\t'|$'\b') 
        #         # Don't echo special keys to avoid formatting issues
        #         ;;
        #     *) 
        #         # Echo regular characters so user sees what they typed
        #         echo -n "$char" > /dev/tty
        #         ;;
        # esac
        # echo "$char"
    else
        # Non-interactive mode - read from stdin
        # local char
        if read -r -n1 -t 4 char; then
            echo -n "$char"
        else
            echo -n ""
        fi
    fi
}

# Set up cleanup trap
trap cleanup_keyboard EXIT