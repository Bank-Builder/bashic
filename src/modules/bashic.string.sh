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
