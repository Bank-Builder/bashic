#!/bin/bash
# BASHIC String Functions Module
# bashic.string.sh - String functions (LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL, STR$)

# String functions
str_len() {
    echo "${#1}"
}

str_left() {
    local str="$1"
    local len="$2"
    echo "${str:0:$len}"
}

str_right() {
    local str="$1"
    local len="$2"
    local str_len="${#str}"
    local start=$((str_len - len))
    [[ $start -lt 0 ]] && start=0
    echo "${str:$start}"
}

str_mid() {
    local str="$1"
    local start="$2"
    local len="${3:-${#str}}"
    start=$((start - BASIC_INDEX_BASE))  # BASIC uses 1-based indexing
    [[ $start -lt 0 ]] && start=0
    echo "${str:$start:$len}"
}

str_asc() {
    local str="$1"
    [[ -z "$str" ]] && echo "0" && return
    printf "%d" "'${str:0:1}"
}

str_chr() {
    local code="$1"
    printf "\\$(printf "%03o" "$code")"
}

str_val() {
    local str="$1"
    # Extract numeric part from beginning of string
    if [[ "$str" =~ ^[[:space:]]*(-?[0-9]+(\.[0-9]+)?) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "0"
    fi
}

str_space() {
    local n="$1"
    printf '%*s' "$n" ''
}

str_time() {
    date +%H:%M:%S
}

str_tab() {
    local col="$1"
    # Return spaces to reach column position
    # For simplicity, just return N spaces
    printf '%*s' "$col" ''
}

# INPUT$ function - read a single character without pressing Enter
str_input() {
    local count="${1:-1}"
    
    # Check if we're in interactive mode
    if [[ -t 0 ]]; then
        # Interactive mode - read character directly
        local char
        read -n "$count" char
        echo "$char"
    else
        # Non-interactive mode - read from buffer
        if [[ ${#INKEY_BUFFER} -ge $count ]]; then
            local result="${INKEY_BUFFER:0:$count}"
            INKEY_BUFFER="${INKEY_BUFFER:$count}"
            echo "$result"
        else
            # Not enough characters in buffer
            echo ""
        fi
    fi
}

# STR$ function - convert number to string
str_str() {
    local num="$1"
    # Remove trailing .0 if present
    if [[ "$num" =~ \.0$ ]]; then
        num="${num%.0}"
    fi
    echo "$num"
}

# String comparison functions
str_compare() {
    local str1="$1"
    local op="$2"
    local str2="$3"
    
    case "$op" in
        "=")
            [[ "$str1" == "$str2" ]] && echo "1" || echo "0"
            ;;
        "<>")
            [[ "$str1" != "$str2" ]] && echo "1" || echo "0"
            ;;
        "<")
            [[ "$str1" < "$str2" ]] && echo "1" || echo "0"
            ;;
        ">")
            [[ "$str1" > "$str2" ]] && echo "1" || echo "0"
            ;;
        "<=")
            [[ "$str1" < "$str2" ]] || [[ "$str1" == "$str2" ]] && echo "1" || echo "0"
            ;;
        ">=")
            [[ "$str1" > "$str2" ]] || [[ "$str1" == "$str2" ]] && echo "1" || echo "0"
            ;;
        *)
            echo "0"
            ;;
    esac
}

# String concatenation
str_concat() {
    local result=""
    for arg in "$@"; do
        result+="$arg"
    done
    echo "$result"
}

# String replacement
str_replace() {
    local str="$1"
    local search="$2"
    local replace="$3"
    echo "${str//$search/$replace}"
}

# String trimming
str_trim() {
    local str="$1"
    # Remove leading and trailing whitespace
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    echo "$str"
}

# String case conversion
str_upper() {
    echo "${1^^}"
}

str_lower() {
    echo "${1,,}"
}
