#!/bin/bash
# BASHIC Screen Functions Module
# bashic.screen.sh - Screen control using ANSI escape codes

# Global screen state
CURRENT_FG_COLOR=37  # White foreground
CURRENT_BG_COLOR=40  # Black background
SCREEN_WIDTH=80

# Clear screen
screen_cls() {
    echo -ne "\033[2J\033[H"
}

# Position cursor at row, column
screen_locate() {
    local row="${1:-1}"
    local col="${2:-1}"
    local cursor_visible="${3:-1}"  # Optional cursor visibility (ignored)
    
    # ANSI escape: ESC[row;colH
    echo -ne "\033[${row};${col}H"
}

# Set text and background color
screen_color() {
    local fg="${1:-7}"  # Default white
    local bg="${2:-0}"  # Default black
    
    # Convert BASIC color codes (0-15) to ANSI (30-37, 90-97 for fg; 40-47, 100-107 for bg)
    # BASIC: 0=black, 1=blue, 2=green, 3=cyan, 4=red, 5=magenta, 6=brown/yellow, 7=white
    # BASIC: 8-15 are bright versions
    
    local ansi_fg=37
    local ansi_bg=40
    
    # Map foreground color
    case "$fg" in
        0) ansi_fg=30 ;;  # Black
        1) ansi_fg=34 ;;  # Blue
        2) ansi_fg=32 ;;  # Green
        3) ansi_fg=36 ;;  # Cyan
        4) ansi_fg=31 ;;  # Red
        5) ansi_fg=35 ;;  # Magenta
        6) ansi_fg=33 ;;  # Yellow
        7) ansi_fg=37 ;;  # White
        8) ansi_fg=90 ;;  # Bright Black (Gray)
        9) ansi_fg=94 ;;  # Bright Blue
        10) ansi_fg=92 ;; # Bright Green
        11) ansi_fg=96 ;; # Bright Cyan
        12) ansi_fg=91 ;; # Bright Red
        13) ansi_fg=95 ;; # Bright Magenta
        14) ansi_fg=93 ;; # Bright Yellow
        15) ansi_fg=97 ;; # Bright White
    esac
    
    # Map background color
    case "$bg" in
        0) ansi_bg=40 ;;  # Black
        1) ansi_bg=44 ;;  # Blue
        2) ansi_bg=42 ;;  # Green
        3) ansi_bg=46 ;;  # Cyan
        4) ansi_bg=41 ;;  # Red
        5) ansi_bg=45 ;;  # Magenta
        6) ansi_bg=43 ;;  # Yellow
        7) ansi_bg=47 ;;  # White
    esac
    
    CURRENT_FG_COLOR=$ansi_fg
    CURRENT_BG_COLOR=$ansi_bg
    
    echo -ne "\033[${ansi_fg};${ansi_bg}m"
}

# Beep
screen_beep() {
    echo -ne "\a"
}

# Set screen width (just store, don't actually resize)
screen_width() {
    local width="$1"
    SCREEN_WIDTH=$width
    # Note: Can't actually resize terminal from bash
}

