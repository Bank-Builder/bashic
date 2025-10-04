# Learning Bash Through Building a BASIC Interpreter

## Tips, Tricks, and Lessons Learned from Building BASHIC

This document captures the key insights, gotchas, and bash programming techniques discovered while building a complete BASIC interpreter in pure bash.

---

## Table of Contents
1. [Regex Patterns in Bash](#regex-patterns-in-bash)
2. [Associative Arrays](#associative-arrays)
3. [Variable Scope and Global State](#variable-scope-and-global-state)
4. [String Parsing Challenges](#string-parsing-challenges)
5. [Performance Optimization](#performance-optimization)
6. [Special Variables and Functions](#special-variables-and-functions)
7. [Input Handling](#input-handling)
8. [Common Pitfalls](#common-pitfalls)

---

## Regex Patterns in Bash

### Character Classes Must Be Escaped Carefully

**Problem**: Character class `[+\-*/]` doesn't work in bash regex
```bash
# WRONG - doesn't match arithmetic operators
if [[ "$expr" =~ ^([A-Z0-9]+)\ *([+\-*/])\ *([A-Z0-9]+)$ ]]; then
```

**Solution**: Use alternation instead
```bash
# CORRECT - matches arithmetic operators
if [[ "$expr" =~ ^([A-Z0-9]+)\ *(\+|\-|\*|/)\ *([A-Z0-9]+)$ ]]; then
```

### Semicolon in Character Classes

**Problem**: Semicolon in character class `[;,]` causes syntax errors in conditionals
```bash
# WRONG - syntax error
if [[ "$stmt" =~ ^\"([^\"]*)\"[;,][[:space:]]*(.+)$ ]]; then
```

**Solution**: Use separate patterns or escape properly
```bash
# CORRECT - no character class
if [[ "$stmt" =~ ^\"([^\"]*)\",[[:space:]]*(.+)$ ]]; then
```

### Dollar Sign in Patterns

**Problem**: String array names end with `$` which must be handled specially
```bash
# WRONG - doesn't match WORDS$
^([A-Z][A-Z0-9_]*)\(([^)]+)\)$

# CORRECT - optional $ at end
^([A-Z][A-Z0-9_]*\$?)\(([^)]+)\)$
```

---

## Associative Arrays

### String Keys Work for Mixed Types

**Lesson**: Bash associative arrays accept string keys, including decimal numbers

```bash
declare -A PROGRAM_LINES
PROGRAM_LINES[10]="PRINT \"Hello\""
PROGRAM_LINES[10.1]="PRINT \"World\""  # Fractional line numbers work!
PROGRAM_LINES[10.2]="END"
```

### Sorting with `sort -n` Handles Decimals

```bash
# Gets sorted correctly: 10, 10.1, 10.2, 20, 20.1
printf '%s\n' "${!PROGRAM_LINES[@]}" | sort -n
```

### Duplicate Keys - Last One Wins

```bash
PROGRAM_LINES[220]="PRINT \"First\""
PROGRAM_LINES[220]="PRINT \"Second\""  # Overwrites first
# Result: Only second value is stored
```

---

## Variable Scope and Global State

### Global Variables Must Be Declared Outside Functions

```bash
# At top level
INKEY_BUFFER=""  # Global variable

function my_func() {
    # Can access and modify INKEY_BUFFER here
    INKEY_BUFFER="test"
}
```

### Function Calls Don't Inherit Environment

**Problem**: BASHIC_UPPER_CASE set as environment variable not accessible in functions

**Solution**: Check both environment and program variables
```bash
local upper_mode="${BASHIC_UPPER_CASE:-${NUMERIC_VARS[BASHIC_UPPER_CASE]:-0}}"
```

### Caching Arrays

**Problem**: Checking if array is empty
```bash
# WRONG - always returns true for arrays
if [[ -z "${SORTED_LINE_NUMBERS:-}" ]]; then
```

**Solution**: Check array length
```bash
# CORRECT
if [[ ${#SORTED_LINE_NUMBERS[@]} -eq 0 ]]; then
```

---

## String Parsing Challenges

### Comma Splitting with Parentheses

**Problem**: `DIM A(5), B$(10)` splits at wrong comma (inside parentheses)

**Solution**: Track parenthesis depth
```bash
local paren_count=0
while [[ $i -lt ${#args} ]]; do
    case "${args:$i:1}" in
        "(") paren_count=$((paren_count + 1)) ;;
        ")") paren_count=$((paren_count - 1)) ;;
        ",") 
            if [[ $paren_count -eq 0 ]]; then
                # Split here
            fi
            ;;
    esac
    i=$((i + 1))
done
```

### Colon Statement Separator

**Problem**: Split `A=5: B=10: PRINT "Time: 10:30"` correctly

**Solution**: Track string literals AND skip REM comments
```bash
# Check if it's a comment first
if [[ "$statement" =~ ^REM || "$statement" =~ ^\' ]]; then
    # Don't split REM comments
else
    # Split by colon, but track quote state
    local in_string=0
    # ... parse with quote tracking
fi
```

### String Literal Comma Detection

**Problem**: `PRINT "A, B, C"` was being split at commas inside string

**Solution**: Check for separators outside strings first
```bash
local in_string=0
local has_separator=false
while [[ $i -lt ${#args} ]]; do
    if [[ "${args:$i:1}" == '"' ]]; then
        in_string=$((1 - in_string))
    elif [[ "${args:$i:1}" == "," && $in_string -eq 0 ]]; then
        has_separator=true
        break
    fi
done
```

---

## Performance Optimization

### Avoid Subprocess Calls in Loops

**Problem**: Calling `bc` or `awk` for every line comparison = 40,000+ subprocess calls
```bash
# WRONG - extremely slow
for line in "${line_numbers[@]}"; do
    if [[ $(echo "$line > $current" | bc) == "1" ]]; then
```

**Solution**: Use bash built-ins and leverage pre-sorted data
```bash
# CORRECT - find current, return next
local found_current=false
for line in "${line_numbers[@]}"; do
    if [[ "$found_current" == "true" ]]; then
        echo "$line"
        break
    fi
    [[ "$line" == "$current" ]] && found_current=true
done
```

**Result**: Regression tests went from timeout to 5 seconds!

### Integer vs Boolean Variables

**Problem**: Using `false` as a variable value with `set -euo pipefail`
```bash
local in_quotes=false  # WRONG - 'false' is treated as command
```

**Solution**: Use 0/1 for boolean logic
```bash
local in_quotes=0  # CORRECT
in_quotes=$((1 - in_quotes))  # Toggle
```

---

## Special Variables and Functions

### Order Matters for Pattern Matching

**Problem**: `INKEY$` was matching as string variable before being checked as function

**Solution**: Check special cases FIRST
```bash
# Check INKEY$ BEFORE general string variable pattern
if [[ "$expr" == "INKEY$" ]]; then
    # Handle special function
    return
fi

# Then check general string variables
if [[ "$expr" =~ ^[A-Z][A-Z0-9_]*\$$ ]]; then
    # Handle regular string variable
fi
```

### Function vs Array Disambiguation

**Problem**: `LEFT$(A$, 2)` looks like array access `ARRAY(INDEX)`

**Solution**: Check known functions FIRST, then try array access
```bash
case "$func" in
    "LEFT$"|"RIGHT$"|"MID$")
        # Handle as function
        ;;
    *)
        # Not a known function, check if it's an array
        ;;
esac
```

---

## Input Handling

### Non-Interactive Input with INKEY$

**Problem**: INKEY$ needs non-blocking keyboard read, but stdin is buffered

**Solution**: Pre-read all stdin at program start
```bash
# In load_program(), before reading the .bas file
if [[ ! -t 0 ]]; then
    # stdin is not a terminal - buffer all input
    if read -t 0 2>/dev/null; then
        IFS= read -r -d '' INKEY_BUFFER
    fi
fi
```

Then consume character by character:
```bash
if [[ -n "$INKEY_BUFFER" ]]; then
    key="${INKEY_BUFFER:0:1}"      # Get first char
    INKEY_BUFFER="${INKEY_BUFFER:1}"  # Remove from buffer
fi
```

### INPUT vs INKEY$

- **INPUT**: Blocking, reads full line, waits for Enter
- **INKEY$**: Non-blocking, returns single character immediately
- Both should support `BASHIC_UPPER_CASE` for consistency

---

## Common Pitfalls

### 1. Build System Confusion

**Problem**: Editing `bashic` file directly, but `build.sh` creates `build/bashic`

**Solution**: Always copy after building
```bash
./build.sh
cp build/bashic bashic
chmod +x bashic
```

### 2. Duplicate Line Numbers in Test Files

**Gotcha**: BASIC allows duplicate line numbers (last one wins)
```basic
220 PRINT "First"
220 LET S$ = "Hello"  # This one is used
```

### 3. set -euo pipefail Strictness

Variables must be initialized or default-valued:
```bash
# WRONG
local result=false  # 'false' command doesn't exist

# CORRECT
local result=0
```

### 4. IFS and Array Splitting

**Problem**: Using IFS=, changes global IFS
```bash
# WRONG - affects rest of script
IFS=',' read -ra array <<< "$string"

# BETTER - localize IFS
local IFS=','
read -ra array <<< "$string"
```

### 5. Fractional Line Numbers for Multi-Statement Lines

**Technique**: Use decimal sub-indices for statements on same line
```basic
10 A=5: B=10: PRINT "Done"
```
Stored as:
- `10` → "A=5"
- `10.1` → "B=10"  
- `10.2` → "PRINT \"Done\""

Benefits:
- Never conflicts with user line numbers
- `sort -n` handles correctly
- Original line numbers preserved for GOTO/GOSUB

---

## Architecture Insights

### Modular Design Pays Off

Separating concerns into modules made debugging much easier:
- `bashic.util.sh` - Globals, error handling
- `bashic.math.sh` - Math functions
- `bashic.string.sh` - String functions
- `bashic.eval.sh` - Expression evaluation
- `bashic.control.sh` - Control flow
- `bashic.statement.sh` - Statement execution
- `bashic.core.sh` - Program loading and execution loop

### Expression Evaluation Order

Critical to check in correct order:
1. String literals `"text"`
2. Special functions like `INKEY$`
3. String variables `NAME$`
4. Numeric variables `COUNT`
5. Numeric literals `123`
6. Function calls `ABS(X)`
7. Array access `NUMS(I)`
8. Operators and complex expressions

### Statement Parsing Priority

Order of checking in `execute_statement()`:
1. Empty/comments (skip early)
2. END/STOP (terminate)
3. Hardware stubs (ignore gracefully)
4. Known keywords (PRINT, IF, FOR, etc.)
5. Assignment detection (fallback for implicit LET)

---

## Testing Strategy

### Test-Driven Development

1. Run regression tests after EVERY change
2. Create specific test cases for each feature
3. Test edge cases (empty strings, zero, negative numbers)
4. Test nested structures thoroughly

### Module-Level Testing

Create `tests/modules/test_*.bas` for each module:
- Isolated testing of single module
- Easier to debug than full integration
- Faster test cycles

### Regression Suite

Maintain comprehensive `tests/regression.bas`:
- Tests ALL implemented features
- Must pass 100% before any commit
- Catches regressions immediately

---

## Advanced Techniques

### PRINT Comma Formatting

BASIC uses 14-character column zones for comma-separated values:
```bash
# Calculate next column position
local current_len=${#output}
local next_column=$(((current_len / 14 + 1) * 14))
local spaces_needed=$((next_column - current_len))
output="${output}$(printf '%*s' $spaces_needed '')${value}"
```

### Stack Operations with Generic Functions

```bash
stack_push() {
    local stack_name="$1"
    local value="$2"
    case "$stack_name" in
        "GOSUB_STACK") GOSUB_STACK+=("$value") ;;
        "FOR_STACK") FOR_STACK+=("$value") ;;
        "WHILE_STACK") WHILE_STACK+=("$value") ;;
    esac
}
```

### Code Reuse Pattern

FOR/NEXT pattern reused for WHILE/WEND:
- Both use stack to track loop state
- Both check condition and either loop back or pop stack
- Consistent structure makes maintenance easier

### Error Context

Always provide context in error messages:
```bash
error_with_context() {
    local message="$1"
    if [[ $CURRENT_LINE -gt 0 ]]; then
        echo "ERROR: $message (line $CURRENT_LINE: ${PROGRAM_LINES[$CURRENT_LINE]})" >&2
    else
        echo "ERROR: $message" >&2
    fi
    exit 1
}
```

---

## Bash Gotchas Discovered

### 1. String Comparison vs Numeric Comparison

```bash
# String comparison (lexicographic)
[[ "10" < "9" ]]  # TRUE because "1" < "9"

# Numeric comparison
[[ 10 -lt 9 ]]    # FALSE because 10 > 9
```

### 2. Unbound Variables with set -u

With `set -u`, undefined variables cause script termination:
```bash
# WRONG
if [[ $UNDEFINED == "test" ]]; then  # Error: unbound variable

# CORRECT
if [[ "${UNDEFINED:-}" == "test" ]]; then  # Returns empty if unset
```

### 3. Substring Extraction

```bash
local str="Hello World"
echo "${str:0:5}"    # "Hello" - offset 0, length 5
echo "${str:6}"      # "World" - offset 6, rest of string
echo "${str: -5}"    # "World" - last 5 chars (note space before -)
```

### 4. read -t 0 Behavior

```bash
# read -t 0 checks if input is READY, but doesn't read it!
if read -t 0; then
    # Input is available, NOW actually read it
    read -r data
fi
```

### 5. Boolean Variable Initialization

```bash
# WRONG with set -euo pipefail
local flag=false  # Error: false command not found

# CORRECT
local flag=0
[[ $flag -eq 0 ]] && echo "false"
```

---

## Optimization Lessons

### 1. Minimize Subprocess Calls

Each `bc`, `awk`, or external command spawns a new process.

**Before**: 40,000+ subprocess calls (5+ minutes)
```bash
for line in "${lines[@]}"; do
    if [[ $(echo "$line > $current" | bc) == "1" ]]; then
```

**After**: Pure bash (5 seconds)
```bash
for line in "${lines[@]}"; do
    [[ "$found_current" == "true" ]] && echo "$line" && break
    [[ "$line" == "$current" ]] && found_current=true
done
```

### 2. Character-by-Character Parsing

Faster than regex for simple checks:
```bash
local i=0
while [[ $i -lt ${#string} ]]; do
    local char="${string:$i:1}"
    # Process character
    i=$((i + 1))
done
```

### 3. Early Returns

Return as soon as result is known:
```bash
# Handle simple cases first
[[ -z "$expr" ]] && echo "" && return
[[ "$expr" =~ ^\".*\"$ ]] && echo "${BASH_REMATCH[1]}" && return
# Then handle complex cases
```

---

## GW-BASIC Compatibility Tricks

### Hardware Command Stubs

Many GW-BASIC programs use hardware-specific commands. Create no-op stubs:
```bash
case "$upper_stmt" in
    KEY*|CLS|WIDTH*|LOCATE*|BEEP|COLOR*|SOUND*)
        # Ignore hardware commands gracefully
        debug "Ignoring GW-BASIC command: ${upper_stmt%% *}"
        ;;
esac
```

### Special Variable Emulation

Replace hardware manipulation with portable variables:
```bash
# GW-BASIC: DEF SEG=&H40:X=PEEK(&H17):X=X OR &H40:POKE &H17,X
# BASHIC equivalent:
BASHIC_UPPER_CASE = 1
```

### Multi-Statement Lines

GW-BASIC allows: `10 A=5: B=10: PRINT "Done"`

Implementation using fractional line numbers preserves GOTO targets.

---

## Testing Insights

### Test What You Changed

After modifying expression evaluation, test:
- Simple expressions
- Complex nested expressions  
- Edge cases (empty, zero, negative)
- Expressions in different contexts (PRINT, IF, LET)

### Regression Test Structure

Group tests by feature:
```basic
100 REM TEST 1: Variables and Arithmetic
...
200 REM TEST 2: String Variables
...
9000 REM ERROR HANDLER
9010 PRINT "TEST FAILED"
9020 END
```

Single error handler for all tests keeps code DRY.

### Debug Output Strategy

Use DEBUG flag with meaningful messages:
```bash
debug "Evaluating expression: $expr"
debug "IF condition '$condition' evaluated to $result"
debug "GOTO line $line_num"
```

Helps trace execution without verbose logging in production.

---

## Documentation

### Self-Documenting Code

Good variable names reduce need for comments:
```bash
# GOOD
local array_name="${BASH_REMATCH[1]}"
local index_expr="${BASH_REMATCH[2]}"
local value="${BASH_REMATCH[3]}"

# BAD
local a="${BASH_REMATCH[1]}"
local b="${BASH_REMATCH[2]}"
local c="${BASH_REMATCH[3]}"
```

### Function Headers

Each module starts with clear purpose:
```bash
#!/bin/bash
# BASHIC Math Functions Module
# bashic.math.sh - Mathematical functions (ABS, INT, SGN, SQR)
```

---

## Summary of Key Learnings

1. **Regex is powerful but has quirks** - Test patterns thoroughly
2. **Global state requires careful management** - Use consistent naming
3. **Performance matters** - Minimize subprocesses
4. **Order of checks is critical** - Most specific first
5. **Test continuously** - Regression tests catch issues early
6. **Bash can be surprisingly powerful** - Complex interpreters are possible
7. **Modular design enables debugging** - Separate concerns clearly
8. **Edge cases matter** - Empty strings, duplicates, special chars
9. **Document as you go** - Future you will thank you
10. **Incremental development** - Small changes, test frequently

---

## Resources and References

- Bash Reference Manual: Pattern matching, parameter expansion
- GW-BASIC Language Reference: BASIC syntax and semantics
- Classic BASIC programs: Real-world test cases
- Stack Overflow: Bash regex and array handling

---

**Building BASHIC taught that bash is capable of much more than simple scripting - with careful design, you can implement complex interpreters and achieve good performance!**

