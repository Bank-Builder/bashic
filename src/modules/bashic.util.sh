#!/bin/bash
# BASHIC Utility Functions Module
# bashic.util.sh - Core utilities, constants, and global variables

# Constants
readonly MAX_ARRAY_SIZE=10000
readonly BASIC_INDEX_BASE=1  # BASIC uses 1-based indexing
readonly MAX_LINE_NUMBER=99999

# Global variables
declare -A PROGRAM_LINES      # Program lines indexed by line number
declare -A NUMERIC_VARS       # Numeric variables
declare -A STRING_VARS        # String variables  
declare -A ARRAYS            # Arrays
declare -a GOSUB_STACK       # GOSUB return stack
declare -a FOR_STACK         # FOR loop stack
declare -a WHILE_STACK       # WHILE loop stack

CURRENT_LINE=0
PROGRAM_COUNTER=0
RUNNING=false
DEBUG=false

# Error handling with context
error_with_context() {
    local message="$1"
    local context=""
    
    if [[ $CURRENT_LINE -gt 0 ]]; then
        context=" (line $CURRENT_LINE"
        if [[ -n "${PROGRAM_LINES[$CURRENT_LINE]:-}" ]]; then
            context="$context: ${PROGRAM_LINES[$CURRENT_LINE]}"
        fi
        context="$context)"
    fi
    
    echo "ERROR: $message$context" >&2
    exit 1
}

# Legacy error function for backward compatibility
error() {
    error_with_context "$1"
}

# Usage information
usage() {
    echo "Usage: $0 [options] <program.bas>"
    echo "Options:"
    echo "  -d, --debug    Enable debug output"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version information"
    exit 0
}

# Debug output
debug() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# Trim whitespace from string
trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"  # Remove leading whitespace
    str="${str%"${str##*[![:space:]]}"}"  # Remove trailing whitespace
    echo "$str"
}

# Check if string is numeric
is_numeric() {
    local str="$1"
    [[ "$str" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

# Generic stack push function
stack_push() {
    local stack_name="$1"
    local value="$2"
    
    case "$stack_name" in
        "GOSUB_STACK")
            GOSUB_STACK+=("$value")
            ;;
        "FOR_STACK")
            FOR_STACK+=("$value")
            ;;
        "WHILE_STACK")
            WHILE_STACK+=("$value")
            ;;
        *)
            error "Unknown stack: $stack_name"
            ;;
    esac
}

# Generic stack pop function
stack_pop() {
    local stack_name="$1"
    local result=""
    
    case "$stack_name" in
        "GOSUB_STACK")
            if [[ ${#GOSUB_STACK[@]} -gt 0 ]]; then
                result="${GOSUB_STACK[-1]}"
                unset GOSUB_STACK[-1]
            fi
            ;;
        "FOR_STACK")
            if [[ ${#FOR_STACK[@]} -gt 0 ]]; then
                result="${FOR_STACK[-1]}"
                unset FOR_STACK[-1]
            fi
            ;;
        "WHILE_STACK")
            if [[ ${#WHILE_STACK[@]} -gt 0 ]]; then
                result="${WHILE_STACK[-1]}"
                unset WHILE_STACK[-1]
            fi
            ;;
        *)
            error "Unknown stack: $stack_name"
            ;;
    esac
    
    echo "$result"
}
