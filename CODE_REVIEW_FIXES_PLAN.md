# Code Review Fixes Implementation Plan

## Goal
Fix remaining code review items to improve functionality, performance, and maintainability.

## Step-by-Step Implementation Plan

### Step 1: Update README and Remove bc Dependency Issue
- Add `bc` to dependencies in README.md
- Remove item 1 from code_review.md (bc dependency violation)
- Update code review to reflect bc is acceptable

### Step 2: Implement Pre-parsing for Array Bounds (Item 7)
- Create pre_parse_program() function
- Extract all DIM statements during program load
- Store array metadata before execution starts
- Validate array bounds during pre-parsing
- Update load_program() to call pre-parsing

### Step 3: Fix Array Stack Management Bug (Item 2)
- Replace incorrect `unset array[-1]` with proper removal
- Create generic stack_pop() helper function
- Update FOR_STACK, WHILE_STACK, GOSUB_STACK management
- Test stack operations thoroughly

### Step 4: Establish Consistent Error Handling (Item 2)
- Define error handling strategy
- Create error_with_context() function
- Include line numbers and variable values in errors
- Update all error calls to use new function

### Step 5: Optimize Expression Evaluation (Item 4)
- Combine multiple regex patterns into single evaluation
- Reduce redundant regex matches
- Cache compiled regex patterns
- Test performance improvement

### Step 6: Fix Redundant String Operations (Item 5)
- Move trim() calls to expression entry points
- Eliminate multiple trim() calls on same values
- Update evaluate_expression() to trim once at start

### Step 7: Optimize Line Number Lookup (Item 6)
- Pre-sort line numbers once during load
- Implement binary search for line lookups
- Cache sorted line numbers array
- Update find_next_line() function

### Step 8: Define Constants for Magic Numbers (Item 7)
- Create constants for array bounds
- Define BASIC indexing constants
- Replace hardcoded values with named constants
- Update array validation logic

### Step 9: Establish Consistent Naming Convention (Item 8)
- Define naming convention (snake_case for locals)
- Update variable names throughout codebase
- Ensure consistency with global variables
- Update function parameter names

### Step 10: Create Generic Stack Management (Item 9)
- Create stack_push() and stack_pop() functions
- Replace duplicate stack management code
- Update FOR_STACK, WHILE_STACK, GOSUB_STACK usage
- Test all stack operations

### Step 11: Add Input Validation (Item 10)
- Validate DIM array sizes (positive, reasonable limits)
- Add bounds checking for numeric inputs
- Validate line numbers in GOTO/GOSUB
- Test edge cases

### Step 12: Add Overflow Protection (Item 11)
- Implement integer overflow detection
- Add safe arithmetic functions
- Update arithmetic operations
- Test overflow scenarios

### Step 13: Break Down Large Functions (Item 13)
- Split evaluate_expression() into smaller functions
- Create separate handlers for each expression type
- Maintain same functionality with better structure
- Test all expression types

### Step 14: Separate Responsibilities (Item 14)
- Split execute_print() into parser and formatter
- Create print_parse_expressions() function
- Create print_format_output() function
- Maintain same PRINT functionality

### Step 15: Add Consistent Debug Output (Item 15)
- Add debug output to all major functions
- Standardize debug message format
- Include relevant context in debug messages
- Test debug output

## Code Reuse Strategy
- Create generic helper functions for common operations
- Reuse patterns across similar functionality
- Maintain existing API while improving implementation
- Follow established patterns for consistency

## Success Criteria
- All code review items addressed
- No regression in existing functionality
- Performance improvements measurable
- Code more maintainable and robust
- All tests continue to pass
