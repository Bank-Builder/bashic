# Error Context Negative Test Plan

## Goal
Create a negative test to verify that error context (line numbers and program content) is properly included in error messages.

## Step-by-Step Implementation Plan

### Step 1: Analyze Current Error Context Implementation
- Review error_with_context() function
- Identify what context information is included
- Document current error message format

### Step 2: Design Negative Test Cases
- Create test cases that trigger various error conditions
- Include errors that should show line numbers and program content
- Test different types of errors (array bounds, undefined variables, syntax errors)

### Step 3: Create Error Context Test Program
- Design BASIC program with intentional errors
- Include multiple error types to test different error paths
- Ensure errors occur at different line numbers

### Step 4: Implement Test Cases
- Array index out of bounds error
- Undefined array access error
- Invalid DIM statement error
- GOTO to undefined line error
- Invalid FOR statement error

### Step 5: Verify Error Context Output
- Run test program and capture error output
- Verify line numbers are included
- Verify program content is included
- Verify error messages are helpful for debugging

### Step 6: Add to Regression Suite
- Add error context verification to tests/regression.bas
- Ensure error context is tested in automated tests
- Document expected error message format

## Test Cases to Implement

### Test 1: Array Index Out of Bounds
```basic
10 DIM NUMS(3)
20 NUMS(5) = 100  // Should trigger bounds error
```

### Test 2: Undefined Array Access
```basic
10 NUMS(0) = 100  // Should trigger "Array not declared" error
```

### Test 3: Invalid DIM Statement
```basic
10 DIM INVALID(  // Should trigger syntax error
```

### Test 4: GOTO to Undefined Line
```basic
10 GOTO 999  // Should trigger "GOTO to undefined line" error
```

### Test 5: Invalid FOR Statement
```basic
10 FOR INVALID  // Should trigger "Invalid FOR statement" error
```

## Success Criteria
- Error messages include line numbers
- Error messages include program content
- Error messages are helpful for debugging
- All error types show proper context
- Test can be automated in regression suite
