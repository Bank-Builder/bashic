#!/bin/bash
# Apply ShellCheck exclusions to all modules
# This script adds the generated exclusions to each module

set -euo pipefail

MODULES_DIR="src/modules"
EXCLUSIONS_FILE="scripts/shellcheck_exclusions.txt"

if [[ ! -f "$EXCLUSIONS_FILE" ]]; then
    echo "Error: $EXCLUSIONS_FILE not found. Run generate_shellcheck_exclusions.sh first."
    exit 1
fi

# Process each module file
for module in "$MODULES_DIR"/bashic.*.sh; do
    if [[ -f "$module" ]]; then
        echo "Processing $module..."
        
        # Create a temporary file with exclusions added
        temp_file=$(mktemp)
        
        # Add exclusions after the shebang and module header
        {
            # Keep the shebang and first few lines
            head -n 3 "$module"
            echo ""
            echo "# Global variable exclusions (auto-generated)"
            cat "$EXCLUSIONS_FILE"
            echo ""
            echo "# Module content"
            # Skip the first few lines and add the rest
            tail -n +4 "$module"
        } > "$temp_file"
        
        # Replace the original file
        mv "$temp_file" "$module"
        
        echo "Updated $module"
    fi
done

echo "All modules updated with ShellCheck exclusions"
