# BASHIC - BASIC Interpreter in Bash

A complete BASIC interpreter written entirely in bash, compatible with classic DOS BASIC syntax.

## Overview

BASHIC is a text-mode BASIC interpreter that runs .bas files using bash shell capabilities with minimal external dependencies.

## Dependencies

- `bash` (shell interpreter)
- `bc` (basic calculator for mathematical functions)

## Usage

```bash
./bashic program.bas
```

## Features

- Classic DOS BASIC syntax support
- Variables (numeric and string)
- Control structures (IF/THEN, FOR/NEXT, WHILE/WEND, GOSUB/RETURN)
- Built-in functions (mathematical, string manipulation)
- Line-numbered programs
- Interactive and file-based execution
- Text-only output (no graphics)

## Installation

### From Source
```bash
chmod +x bashic
./bashic test1.bas
```

### Debian Package
```bash
./scripts/mkdeb.sh
sudo dpkg -i bashic_1.0_all.deb
```

## Project Structure

```
bashic/
├── bashic              # Main interpreter executable
├── README.md           # This file
├── SPECIFICATION.md    # Detailed language specification
├── examples/           # Sample BASIC programs
│   ├── test1.bas      # Simple test program
│   └── test2.bas      # Advanced test program
├── scripts/           # Build and packaging scripts
│   └── mkdeb.sh       # Debian package builder
└── debian/            # Debian package structure
    ├── DEBIAN/
    │   └── control
    └── usr/
        └── bin/
            └── bashic
```

## License

MIT License - see LICENSE file for details.
