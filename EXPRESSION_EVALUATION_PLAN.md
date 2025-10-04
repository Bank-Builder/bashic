# Expression Evaluation Fix Plan

## Problem Analysis
The current `evaluate_expression` function doesn't follow proper precedence rules:
- No parentheses handling
- No operator precedence (A + B * C should be A + (B * C))
- Functions evaluated multiple times in conditions
- No recursive evaluation for complex expressions

## Solution Plan

### Phase 1: Create Proper Expression Parser
1. **Parse parentheses first** (inside-out evaluation)
2. **Handle operator precedence** correctly  
3. **Evaluate functions/variables before operators**
4. **Support recursive evaluation**

### Phase 2: Implement Precedence Levels
1. **Level 1**: Parentheses `()`
2. **Level 2**: Functions `INKEY$()`, `TIME$()`, `ABS()`, etc.
3. **Level 3**: Variables `A`, `B$`, arrays `A(1)`
4. **Level 4**: Arithmetic operators `*`, `/`, `MOD`
5. **Level 5**: Arithmetic operators `+`, `-`
6. **Level 6**: Comparison operators `=`, `<>`, `<`, `>`, `<=`, `>=`

### Phase 3: Implementation Steps
1. **Create `parse_expression()` function** that handles precedence
2. **Create `evaluate_atom()` function** for basic elements (variables, functions, literals)
3. **Create `evaluate_operator()` function** for operators with precedence
4. **Replace current `evaluate_expression()` with new implementation**
5. **Test with simple examples**

### Phase 4: Test Cases
```basic
# Test 1: Simple function call (should evaluate INKEY$ once)
10 IF INKEY$ = "" THEN PRINT "Empty"

# Test 2: Arithmetic precedence (should be A + (B * C))
10 IF A + B * C = 10 THEN PRINT "Math works"

# Test 3: Parentheses (should evaluate parentheses first)
10 IF (A + B) * C = 10 THEN PRINT "Parens work"

# Test 4: Complex expression
10 IF ABS(A) + B * C = 10 THEN PRINT "Complex works"
```

### Phase 5: Implementation Details

#### New Function Structure:
```bash
parse_expression() {
    # Handle parentheses first
    # Then handle operators by precedence
    # Recursively evaluate sub-expressions
}

evaluate_atom() {
    # Handle: variables, functions, literals, arrays
    # This replaces the current basic evaluation
}

evaluate_operator() {
    # Handle operators with proper precedence
    # Call parse_expression recursively for operands
}
```

#### Precedence Rules:
- Parentheses: highest precedence
- Functions: evaluate arguments first
- Variables: direct lookup
- Arithmetic: *, /, MOD before +, -
- Comparison: lowest precedence

### Phase 6: Testing Strategy
1. Test each precedence level individually
2. Test complex nested expressions
3. Test function calls in conditions
4. Test arithmetic precedence
5. Test parentheses handling
6. Verify no double evaluation of functions

### Phase 7: Rollback Plan
If implementation fails:
1. Keep original evaluate_expression as backup
2. Add feature flag to switch between old/new
3. Test thoroughly before removing old code

## Success Criteria
- `IF INKEY$ = "" THEN GOTO 40` works correctly (no double evaluation)
- `IF A + B * C = 10` evaluates as `A + (B * C) = 10`
- `IF (A + B) * C = 10` evaluates parentheses first
- All existing functionality continues to work
- No performance regression
