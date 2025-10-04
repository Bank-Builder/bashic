# BASHIC Special Variables

## Overview
Variables starting with `BASHIC_` are special system variables that control interpreter behavior. These variables are reserved and should not be used for regular program data.

## Available Special Variables

### BASHIC_UPPER_CASE
**Type**: Numeric (0 or 1)  
**Default**: 0 (disabled)  
**Purpose**: Controls automatic uppercase conversion for INPUT statements

When set to 1, all user input from INPUT statements is automatically converted to uppercase. This emulates the behavior of the GW-BASIC code:
```basic
DEF SEG=&H40:X=PEEK(&H17):X=X OR &H40:POKE &H17,X
```

#### Usage Example
```basic
10 PRINT "Normal input:"
20 INPUT "Enter name: ", NAME$
30 PRINT "You entered: "; NAME$
40 PRINT
50 REM Enable uppercase mode
60 BASHIC_UPPER_CASE = 1
70 INPUT "Enter word: ", WORD$
80 PRINT "You entered: "; WORD$
90 REM Disable uppercase mode
100 BASHIC_UPPER_CASE = 0
```

#### Why This Exists
In classic GW-BASIC, programs could directly manipulate PC BIOS keyboard flags to force CAPS LOCK mode. Since BASHIC runs on modern systems without direct hardware access, this special variable provides equivalent functionality in a portable way.

## Reserved Namespace
All variables matching the pattern `BASHIC_*` are reserved for system use. User programs should avoid creating variables with this prefix to prevent conflicts with current and future special variables.

## Future Special Variables (Planned)
- `BASHIC_DEBUG` - Enable/disable debug output
- `BASHIC_ECHO` - Echo INPUT commands
- `BASHIC_STRICT` - Enable strict error checking
- `BASHIC_VERSION` - Read-only interpreter version

## Environment Variables
BASHIC special variables can also be set via environment variables before running a program:

```bash
export BASHIC_UPPER_CASE=1
./bashic myprogram.bas
```

Environment variables take precedence over program-set values until the program explicitly sets them.

