#!/bin/bash

# Build Debian package for BASHIC
# Usage: ./scripts/mkdeb.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEBIAN_DIR="$PROJECT_DIR/debian"
PACKAGE_NAME="bashic"
VERSION="1.0"
ARCHITECTURE="all"
PACKAGE_FILE="${PACKAGE_NAME}_${VERSION}_${ARCHITECTURE}.deb"

echo "Building BASHIC Debian package..."
echo "Project directory: $PROJECT_DIR"
echo "Debian directory: $DEBIAN_DIR"

# Validate debian directory structure
if [[ ! -d "$DEBIAN_DIR" ]]; then
    echo "Error: Debian directory not found: $DEBIAN_DIR"
    exit 1
fi

if [[ ! -f "$DEBIAN_DIR/DEBIAN/control" ]]; then
    echo "Error: Control file not found: $DEBIAN_DIR/DEBIAN/control"
    exit 1
fi

# Build the modular bashic executable
echo "Building modular bashic executable..."
cd "$PROJECT_DIR"
./build.sh

# Copy the built executable
echo "Copying built bashic executable..."
cp "$PROJECT_DIR/build/bashic" "$DEBIAN_DIR/usr/bin/bashic"
chmod +x "$DEBIAN_DIR/usr/bin/bashic"

# Set proper permissions
echo "Setting permissions..."
find "$DEBIAN_DIR" -type f -exec chmod 644 {} \;
find "$DEBIAN_DIR" -type d -exec chmod 755 {} \;
chmod +x "$DEBIAN_DIR/usr/bin/bashic"

# Create package
echo "Building package: $PACKAGE_FILE"
cd "$PROJECT_DIR"

if command -v dpkg-deb >/dev/null 2>&1; then
    dpkg-deb --build debian "$PACKAGE_FILE"
    echo "Package built successfully: $PACKAGE_FILE"
    
    # Show package info
    echo ""
    echo "Package information:"
    dpkg-deb --info "$PACKAGE_FILE"
    
    echo ""
    echo "Package contents:"
    dpkg-deb --contents "$PACKAGE_FILE"
    
    echo ""
    echo "To install:"
    echo "  sudo dpkg -i $PACKAGE_FILE"
    echo ""
    echo "To remove:"
    echo "  sudo dpkg -r $PACKAGE_NAME"
    
else
    echo "Error: dpkg-deb not found. Please install dpkg-dev package."
    echo "On Ubuntu/Debian: sudo apt-get install dpkg-dev"
    exit 1
fi

echo "Build completed successfully!"
