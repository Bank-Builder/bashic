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
        BASHIC_TTY_SETTINGS=$(stty -g 2>/dev/null)
        # Set terminal to raw mode with proper settings
        stty raw -echo min 0 time 0 2>/dev/null || true
    else
        BASHIC_TTY_SETTINGS=""
    fi
}

# Function to convert key to readable name
key_name() {
    local key="$1"
    case "$key" in
        $'\r') echo "ENTER" ;;
        $'\e') echo "ESC" ;;
        $'\t') echo "TAB" ;;
        $'\b'|$'\x7f') echo "BACKSPACE" ;;  # handle DEL too
        *) echo "$key" ;;
    esac
}

# Function to handle cleanup
cleanup_keyboard() {
    # Restore terminal settings if we're in a terminal
    if [ -n "$BASHIC_TTY_SETTINGS" ]; then
        stty "$BASHIC_TTY_SETTINGS" 2>/dev/null || true
    fi
}

# Get a single character from keyboard or buffer
get_key() {
    local char
    if [ -t 0 ]; then
        local old_stty
        old_stty=$(stty -g)
        stty -echo -icanon time 40 min 0
        char=$(dd bs=1 count=1 2>/dev/null)
        stty "$old_stty"
    else
        IFS= read -r -n1 -t 4 char || return 0
    fi

    printf '%s' "$char"

}



# INKEY$ function for BASIC compatibility
INKEY_STR() {
    echo $(get_key)
}

# Set up cleanup trap
trap cleanup_keyboard EXIT