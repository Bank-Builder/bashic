# BASHIC Modularization Implementation Plan

## Goal
Refactor BASHIC into modular components using bashic.<<module>>.sh naming convention while maintaining single-file distribution.

## Step-by-Step Implementation Plan

### Step 1: Create Module Structure
- Create `src/modules/` directory
- Create module files: bashic.util.sh, bashic.math.sh, bashic.string.sh, bashic.eval.sh, bashic.control.sh, bashic.statement.sh, bashic.core.sh
- Create build.sh script to concatenate modules

### Step 2: Extract Utility Functions
- Move utility functions to bashic.util.sh: trim, is_numeric, error, error_with_context, debug
- Move constants to bashic.util.sh: MAX_ARRAY_SIZE, BASIC_INDEX_BASE, MAX_LINE_NUMBER
- Move global variable declarations to bashic.util.sh

### Step 3: Extract Math Functions
- Move math functions to bashic.math.sh: math_abs, math_int, math_sgn, math_sqr
- Ensure proper dependency on bashic.util.sh

### Step 4: Extract String Functions
- Move string functions to bashic.string.sh: str_len, str_left, str_right, str_mid, str_asc, str_chr, str_val
- Ensure proper dependency on bashic.util.sh

### Step 5: Extract Expression Evaluation
- Move evaluate_expression to bashic.eval.sh
- Move evaluate_condition to bashic.eval.sh
- Move evaluate_compound_condition to bashic.eval.sh
- Ensure proper dependencies on bashic.util.sh, bashic.math.sh, bashic.string.sh

### Step 6: Extract Control Flow
- Move control flow functions to bashic.control.sh: execute_for, execute_next, execute_while, execute_wend, execute_if, execute_gosub, execute_return
- Move stack functions to bashic.control.sh: stack_push, stack_pop
- Ensure proper dependencies on bashic.util.sh, bashic.eval.sh

### Step 7: Extract Statement Execution
- Move statement execution functions to bashic.statement.sh: execute_print, execute_let, execute_dim, execute_input
- Move execute_statement to bashic.statement.sh
- Ensure proper dependencies on bashic.util.sh, bashic.eval.sh, bashic.control.sh

### Step 8: Extract Core Program Management
- Move core functions to bashic.core.sh: load_program, pre_parse_program, run_program, get_line_numbers, find_next_line
- Move main execution loop to bashic.core.sh
- Ensure proper dependencies on all other modules

### Step 9: Create Build System
- Create build.sh script to concatenate modules in dependency order
- Test build output against original bashic
- Update mkdeb.sh to use build.sh

### Step 10: Regression Testing
- Run all tests/ to ensure no regression
- Test built bashic against original bashic
- Verify all functionality works identically
- Update documentation

## Module Dependencies

```
bashic.util.sh (no dependencies)
├── bashic.math.sh (depends on: util)
├── bashic.string.sh (depends on: util)
├── bashic.eval.sh (depends on: util, math, string)
├── bashic.control.sh (depends on: util, eval)
├── bashic.statement.sh (depends on: util, eval, control)
└── bashic.core.sh (depends on: all)
```

## Build Order
1. bashic.util.sh
2. bashic.math.sh
3. bashic.string.sh
4. bashic.eval.sh
5. bashic.control.sh
6. bashic.statement.sh
7. bashic.core.sh

## Success Criteria
- All modules created with proper dependencies
- Build script creates identical bashic file
- All tests/ pass without regression
- Performance identical to original
- Single file distribution maintained
- Modular source for development
