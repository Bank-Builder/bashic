# DIM Implementation Plan

## Goal
Implement DIM statement to support array declaration and access in BASHIC interpreter.

## Required Functionality
Based on test2.bas analysis:
- `DIM NUMS(5)` - declare numeric array with 5 elements (0-5)
- `NUMS(I) = I * I` - assign values to array elements
- `NUMS(I)` - read values from array elements

## Implementation Steps

### Step 1: Add DIM Statement Recognition
- Add DIM case to execute_statement() function
- Create execute_dim() function
- Parse DIM syntax: `DIM VARNAME(SIZE)`

### Step 2: Array Storage System
- Extend ARRAYS associative array (already declared)
- Store array metadata: name, size, type
- Use name mangling for array element storage

### Step 3: Array Element Access in Expression Evaluator
- Modify evaluate_expression() to handle VARNAME(INDEX)
- Parse array access syntax
- Return array element values

### Step 4: Array Assignment Support
- Modify execute_let() to handle VARNAME(INDEX) = VALUE
- Parse array assignment syntax
- Store values in array storage system

### Step 5: Testing and Validation
- Test with test2.bas program
- Verify array bounds checking
- Test edge cases

## Technical Details

### Array Storage Format
```bash
# Array metadata
ARRAYS["NUMS"]="numeric:5"  # type:size

# Array elements (name mangling)
NUMERIC_VARS["NUMS_0"]="0"
NUMERIC_VARS["NUMS_1"]="1"
# etc.
```

### Regex Patterns Needed
- DIM parsing: `^DIM[[:space:]]+([A-Z][A-Z0-9]*\$?)\(([0-9]+)\)$`
- Array access: `^([A-Z][A-Z0-9]*)\(([^)]+)\)$`

## Files to Modify
1. `bashic` - main interpreter
2. `debian/usr/bin/bashic` - keep synchronized

## Success Criteria
- test2.bas runs without DIM errors
- Array assignment and access work correctly
- No regression in existing functionality
