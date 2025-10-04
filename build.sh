#!/bin/bash
# BASHIC Build Script
# Concatenates all modules into a single bashic file

set -euo pipefail

# Build directory
BUILD_DIR="build"
MODULES_DIR="src/modules"

# Create build directory
mkdir -p "$BUILD_DIR"

# Start with shebang and basic setup
cat > "$BUILD_DIR/bashic" << 'EOF'
#!/bin/bash

# BASHIC - BASIC Interpreter in Bash
# Version 1.0
# A complete BASIC interpreter written entirely in bash

set -euo pipefail
EOF

# Concatenate modules in dependency order
echo "" >> "$BUILD_DIR/bashic"
echo "# ===== UTILITY MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.util.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== MATH MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.math.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== STRING MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.string.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== SCREEN MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.screen.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== EVAL MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.eval.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== CONTROL MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.control.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== STATEMENT MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.statement.sh" >> "$BUILD_DIR/bashic"

echo "" >> "$BUILD_DIR/bashic"
echo "# ===== CORE MODULE =====" >> "$BUILD_DIR/bashic"
cat "$MODULES_DIR/bashic.core.sh" >> "$BUILD_DIR/bashic"

# Make executable
chmod +x "$BUILD_DIR/bashic"

echo "Build complete: $BUILD_DIR/bashic"
echo "File size: $(wc -l < "$BUILD_DIR/bashic") lines"
