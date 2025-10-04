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

## Development

### Building from Source
```bash
# Build the modular bashic executable
./build.sh

# The built executable is in build/bashic
./build/bashic program.bas
```

### Module Structure
BASHIC uses a modular architecture with clear separation of concerns:
- **bashic.util.sh**: Core utilities, error handling, global variables
- **bashic.math.sh**: Mathematical functions (ABS, INT, SGN, SQR)
- **bashic.string.sh**: String functions (LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL)
- **bashic.eval.sh**: Expression evaluation, operators, condition evaluation
- **bashic.control.sh**: Control flow (FOR/NEXT, WHILE/WEND, IF/THEN/ELSE, GOSUB/RETURN)
- **bashic.statement.sh**: Statement execution (PRINT, LET, DIM, INPUT)
- **bashic.core.sh**: Program management, execution loop, main function

### Build Process
The `build.sh` script concatenates all modules in dependency order to create a single executable file, maintaining performance while enabling modular development.

## Project Structure

```
bashic/
├── bashic              # Main interpreter executable (built from modules)
├── build.sh            # Build script to concatenate modules
├── build/              # Build output directory
│   └── bashic          # Built executable
├── src/modules/        # Modular source files
│   ├── bashic.util.sh  # Core utilities, constants, global variables
│   ├── bashic.math.sh  # Mathematical functions (ABS, INT, SGN, SQR)
│   ├── bashic.string.sh # String functions (LEN, LEFT$, RIGHT$, MID$, etc.)
│   ├── bashic.eval.sh  # Expression evaluation, operators
│   ├── bashic.control.sh # Control flow (FOR/NEXT, WHILE/WEND, IF/THEN/ELSE)
│   ├── bashic.statement.sh # Statement execution (PRINT, LET, DIM, INPUT)
│   └── bashic.core.sh  # Program management, execution loop, main function
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
