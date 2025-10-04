# INPUT and String Operators Analysis Plan

## Goal
Analyze what's missing for INPUT statements and other string operators in BASHIC.

## Current Status Analysis

### ✅ IMPLEMENTED Statements:
- END, STOP
- PRINT (with parentheses-aware parsing)
- LET (with string concatenation support)
- DIM (with pre-parsing)
- FOR/NEXT
- WHILE/WEND
- IF/THEN/ELSE (with logical operators)
- GOTO
- GOSUB/RETURN

### ❌ MISSING Statements:
- **INPUT** - User input from keyboard
- **CLEAR** - Clear all variables
- **NEW** - Clear program and variables
- **RUN** - Restart program execution

### ✅ IMPLEMENTED String Operations:
- String variables: `A$ = "hello"`
- String literals: `"hello"`
- String functions: LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL, STR$
- String concatenation: `A$ + B$`
- String comparison: `A$ = B$`, `A$ <> B$`, etc.
- String assignment: `A$ = B$ + C$`

### ❌ MISSING String Operations:
- **INPUT for strings**: `INPUT A$`
- **INPUT with prompts**: `INPUT "Enter name:", A$`
- **Multiple INPUT**: `INPUT "X,Y:", X, Y`
- **String comparison operators**: All work, but need verification
- **String in conditions**: Need to verify all comparison operators work with strings

## Step-by-Step Implementation Plan

### Step 1: Implement INPUT Statement
- Create `execute_input()` function
- Handle single variable: `INPUT A`
- Handle string variables: `INPUT A$`
- Handle prompts: `INPUT "Enter value:", A`
- Handle multiple variables: `INPUT "X,Y:", X, Y`
- Parse comma-separated input values
- Validate input types (numeric vs string)

### Step 2: Implement Program Control Commands
- **CLEAR**: Clear all variables (NUMERIC_VARS, STRING_VARS, ARRAYS)
- **NEW**: Clear program and variables, reset interpreter state
- **RUN**: Restart program execution from beginning

### Step 3: Verify String Comparison Operators
- Test all comparison operators with strings: `=`, `<>`, `<`, `>`, `<=`, `>=`
- Verify lexicographic ordering works correctly
- Test string comparisons in IF and WHILE statements
- Test mixed string/numeric comparisons

### Step 4: Test String Operations Integration
- Test string concatenation with all string functions
- Test nested string operations
- Test string operations in complex expressions
- Verify error handling for invalid string operations

### Step 5: Add to Regression Suite
- Add INPUT statement tests
- Add program control command tests
- Add comprehensive string operation tests
- Verify no existing functionality is broken

## Implementation Details

### INPUT Statement Formats:
1. `INPUT A` - Single numeric variable
2. `INPUT A$` - Single string variable
3. `INPUT "Enter value:", A` - Prompt with variable
4. `INPUT "Enter name:", A$` - Prompt with string variable
5. `INPUT "X,Y:", X, Y` - Multiple variables
6. `INPUT "Name,Age:", NAME$, AGE` - Mixed types

### Program Control Commands:
- **CLEAR**: Reset all variable arrays to empty
- **NEW**: Clear variables + reset program state + clear line numbers
- **RUN**: Restart execution from first line

### String Comparison Verification:
- `"apple" < "banana"` → true (lexicographic)
- `"cat" = "cat"` → true
- `"dog" <> "cat"` → true
- `"zebra" > "apple"` → true

## Code Locations
- INPUT: New `execute_input()` function + case in `execute_statement()`
- CLEAR/NEW/RUN: New functions + cases in `execute_statement()`
- String comparison: Verify `evaluate_condition()` function

## Success Criteria
- `INPUT A` works for numeric input
- `INPUT A$` works for string input
- `INPUT "Enter name:", A$` works with prompts
- `INPUT "X,Y:", X, Y` works for multiple variables
- `CLEAR` clears all variables
- `NEW` resets interpreter state
- `RUN` restarts program execution
- All string comparison operators work correctly
- All existing functionality preserved
- All regression tests pass
