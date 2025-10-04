# PRINT Parsing Fix Plan

## Problem Statement
PRINT statements with function calls containing commas are being parsed incorrectly.
Example: `PRINT LEFT$(A$, 2)` splits at the comma, treating it as two separate expressions.

## Root Cause Analysis
The current PRINT parsing uses regex `^([^,;]+)([,;])(.*)$` which stops at the first comma/semicolon, breaking function calls with parameters.

## Solution Approach - Step by Step Plan

### Step 1: Test Current Behavior
- Create simple test case: `PRINT LEFT$(A$, 2)`
- Verify it fails as expected
- Document exact failure mode

### Step 2: Identify Required Behavior
- Function calls with commas should be treated as single expressions
- Only commas/semicolons OUTSIDE parentheses should be separators
- Examples:
  - `PRINT A, B` → two expressions: `A` and `B`
  - `PRINT LEFT$(A$, 2)` → one expression: `LEFT$(A$, 2)`
  - `PRINT LEFT$(A$, 2), B` → two expressions: `LEFT$(A$, 2)` and `B`

### Step 3: Design Parsing Algorithm
- Track parentheses depth while scanning string
- Only treat comma/semicolon as separator when depth = 0
- Split string at valid separators
- Evaluate each part as expression

### Step 4: Implement Parentheses-Aware Parsing
- Replace simple regex with character-by-character parsing
- Maintain paren_count variable
- Build array of expression parts
- Process each part through evaluate_expression()

### Step 5: Test Implementation
- Test simple function call: `PRINT LEFT$(A$, 2)`
- Test mixed expressions: `PRINT LEFT$(A$, 2), B`
- Test nested functions: `PRINT MID$(LEFT$(A$, 3), 1, 2)`
- Test with semicolons: `PRINT LEFT$(A$, 2); "text"`

### Step 6: Regression Testing
- Run full regression.bas test suite
- Ensure no existing functionality is broken
- Verify all PRINT variations still work

### Step 7: Cleanup and Documentation
- Remove debug files
- Update comments in code
- Document the fix approach

## Implementation Strategy
- Keep the fix minimal and focused
- Maintain backward compatibility
- Use clear, readable code over clever optimizations
- Test each step before proceeding

## Success Criteria
- `PRINT LEFT$(A$, 2)` outputs "HE" for input "HELLO"
- All existing PRINT functionality preserved
- All regression tests pass
- No performance degradation for simple PRINT statements
