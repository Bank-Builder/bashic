# String Operators Implementation Plan

## Goal
Implement string operators and operations to enhance string handling capabilities in BASHIC.

## Current String Functionality Analysis
- ✅ String variables: `A$ = "hello"`
- ✅ String literals: `PRINT "hello"`
- ✅ String functions: LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL
- ❌ String concatenation: `A$ + B$`
- ❌ String comparison operators: `A$ = B$`, `A$ <> B$`, etc.
- ❌ STR$ function: Convert number to string
- ❌ String assignment with expressions: `A$ = B$ + C$`

## Step-by-Step Implementation Plan

### Step 1: Analyze Current String Handling
- Review existing string variable handling
- Check string literal processing
- Examine string function implementations
- Identify gaps in string operations

### Step 2: Implement String Concatenation (+)
- Add string concatenation to evaluate_expression()
- Support format: `A$ + B$`
- Handle mixed expressions: `A$ + "text"`
- Test with various string combinations

### Step 3: Implement STR$ Function
- Add STR$ function to evaluate_expression()
- Convert numeric values to strings
- Handle edge cases (negative numbers, decimals)
- Test STR$ with various numeric inputs

### Step 4: Enhance String Comparison
- Ensure string comparison operators work correctly
- Test `A$ = B$`, `A$ <> B$`, `A$ < B$`, etc.
- Verify string comparison in IF and WHILE statements
- Test mixed string/numeric comparisons

### Step 5: Implement String Assignment with Expressions
- Support `A$ = B$ + C$` assignments
- Handle complex string expressions
- Test nested string operations
- Verify string assignment in LET statements

### Step 6: Create Comprehensive String Tests
- Test all string operations
- Test string functions with concatenation
- Test string comparisons
- Test edge cases and error conditions

### Step 7: Add to Regression Suite
- Add string operation tests to tests/regression.bas
- Verify no existing functionality is broken
- Ensure 100% string operation coverage

## Implementation Details

### String Concatenation
- Format: `string1 + string2`
- Examples:
  - `A$ + B$` - Concatenate two string variables
  - `A$ + "text"` - Concatenate variable with literal
  - `"hello" + "world"` - Concatenate two literals

### STR$ Function
- Format: `STR$(number)`
- Examples:
  - `STR$(123)` → `"123"`
  - `STR$(-45)` → `"-45"`
  - `STR$(3.14)` → `"3.14"`

### String Comparison
- All comparison operators should work with strings
- Lexicographic ordering (ASCII-based)
- Examples:
  - `"apple" < "banana"` → true
  - `"cat" = "cat"` → true
  - `"dog" <> "cat"` → true

## Code Locations
- String concatenation: `evaluate_expression()` function
- STR$ function: `evaluate_expression()` function (case statement)
- String comparison: `evaluate_condition()` function
- String assignment: `execute_let()` function

## Success Criteria
- `A$ + B$` works correctly
- `STR$(123)` returns `"123"`
- `"hello" + "world"` returns `"helloworld"`
- String comparisons work in IF/WHILE statements
- `A$ = B$ + C$` assignments work
- All existing string functionality preserved
- All regression tests pass
