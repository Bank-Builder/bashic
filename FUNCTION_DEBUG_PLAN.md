# Function Call Debug Plan

## Problem Statement
Multi-parameter functions (LEFT$, RIGHT$, MID$) are not working in any context.

## Step-by-Step Debugging Plan

### Step 1: Test Single-Parameter Functions
- Verify ABS, INT, SGN, SQR work correctly
- Confirm the function call mechanism works for simple cases

### Step 2: Test Multi-Parameter Function Recognition
- Test if LEFT$(A$, 2) is recognized as a function call
- Check if regex patterns match multi-parameter syntax

### Step 3: Test Parameter Parsing
- Verify comma-separated parameters are parsed correctly
- Check if evaluate_expression is called on each parameter

### Step 4: Test Helper Function Calls
- Test str_left, str_right, str_mid functions directly
- Verify they produce expected output

### Step 5: Fix Function Call Flow
- Trace the execution path for multi-parameter functions
- Fix any issues in parameter handling

### Step 6: Test Integration
- Test function calls in assignments
- Test function calls in PRINT statements

### Step 7: Validate All Functions
- Test all 11 implemented functions
- Ensure 100% coverage in regression test
