#!/bin/bash
# Generate ShellCheck exclusions from global variables
# This script reads the globals module and creates exclusion comments

set -euo pipefail

GLOBALS_FILE="src/modules/bashic.globals.sh"
EXCLUSIONS_FILE="scripts/shellcheck_exclusions.txt"

if [[ ! -f "$GLOBALS_FILE" ]]; then
    echo "Error: $GLOBALS_FILE not found"
    exit 1
fi

# Extract variable names from declare statements
echo "# Auto-generated ShellCheck exclusions from bashic.globals.sh" > "$EXCLUSIONS_FILE"
echo "# Generated on: $(date)" >> "$EXCLUSIONS_FILE"
echo "" >> "$EXCLUSIONS_FILE"

# Extract variable names from declare -g statements
grep "declare -g" "$GLOBALS_FILE" | while read -r line; do
    # Extract variable name from declare statement
    if [[ "$line" =~ declare\ -g.*\ ([A-Za-z_][A-Za-z0-9_]*)\[? ]]; then
        var_name="${BASH_REMATCH[1]}"
        echo "# shellcheck disable=SC2034" >> "$EXCLUSIONS_FILE"
        echo "declare -g $var_name" >> "$EXCLUSIONS_FILE"
    fi
done

echo "Generated exclusions in $EXCLUSIONS_FILE"
echo "Variables found:"
grep "declare -g" "$GLOBALS_FILE" | sed 's/.*declare -g.* \([A-Za-z_][A-Za-z0-9_]*\).*/\1/'
