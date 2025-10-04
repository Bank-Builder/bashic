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

# Function to handle cleanup
cleanup_keyboard() {
    # Restore terminal settings if we're in a terminal
    if [ -n "$BASHIC_TTY_SETTINGS" ]; then
        stty "$BASHIC_TTY_SETTINGS"
    fi
}

# Get a single character from keyboard or buffer
get_key() {
    if [ -t 0 ]; then
        # Interactive mode - read directly from terminal
        local IFS=
        local char
        
        # Read a single character with timeout
        read -r -n1 -t 0.1 char || true
        
        # Check for timeout (no input)
        if [ $? -gt 128 ] || [ -z "$char" ]; then
            echo ""
            return
        fi
        
        # Print the character (since echo is off)
        echo -n "$char" > /dev/tty
        echo "$char"
    else
        # Non-interactive mode - read from stdin
        local char
        if read -r -n1 -t 0.1 char; then
            echo "$char"
        else
            echo ""
        fi
    fi
}

# Set up cleanup trap
trap cleanup_keyboard EXIT