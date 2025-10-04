# Control Flow Implementation Plan

## Current Status Analysis

### ✅ IMPLEMENTED Control Flow:
1. ✅ **GOTO** - Jump to line number
2. ✅ **GOSUB/RETURN** - Subroutine calls with stack
3. ✅ **FOR/NEXT** - Loops with counter and step
4. ✅ **WHILE/WEND** - Condition-based loops
5. ✅ **IF/THEN** - Basic conditional execution
6. ✅ **IF/THEN/ELSE** - Conditional with alternative path ✅ COMPLETED
7. ✅ **END/STOP** - Program termination
8. ✅ **Nested structures** - All combinations tested and working

### ❌ MISSING Control Flow (from specification):
1. ❌ **Logical operators** - AND, OR, NOT in conditions
2. ❌ **Additional arithmetic operators** - MOD, \, ^
3. ❌ **Program control** - CLEAR, NEW, RUN

## Implementation Plan

### Phase 1: IF/THEN/ELSE Statement ✅ COMPLETED
**Goal**: Support `IF condition THEN statement ELSE statement`

**Status**: ✅ COMPLETED - IF/THEN/ELSE fully implemented and tested

**Implementation**:
- Modified execute_if() to parse ELSE clause
- Reused existing condition evaluation logic
- Added ELSE execution path
- Tested with regression suite

### Phase 2: Logical Operators in Conditions
**Goal**: Support AND, OR, NOT in IF and WHILE conditions

**Steps**:
1. Create logical operator evaluation function
2. Modify condition parsing to handle compound conditions
3. Implement operator precedence (NOT, AND, OR)
4. Update IF and WHILE to use enhanced condition evaluation

**Code Reuse**: Extend existing condition evaluation pattern

### Phase 3: Additional Arithmetic Operators
**Goal**: Support MOD (modulus), \ (integer division), ^ (exponentiation)

**Steps**:
1. Add new operators to arithmetic expression evaluation
2. Implement helper functions for complex operations
3. Update regex patterns to recognize new operators
4. Test with various expressions

**Code Reuse**: Follow existing arithmetic operator pattern

### Phase 4: Program Control Commands
**Goal**: Support CLEAR, NEW, RUN commands

**Steps**:
1. Implement execute_clear() - reset all variables
2. Implement execute_new() - reset program and variables
3. Implement execute_run() - restart program execution
4. Add cases to execute_statement()

**Code Reuse**: Use existing variable management patterns

## Implementation Priority
1. **IF/THEN/ELSE** (most commonly used)
2. **Additional operators** (MOD, \, ^)
3. **Logical operators** (AND, OR, NOT)
4. **Program control** (CLEAR, NEW, RUN)

## Testing Strategy
- Add test cases to regression.bas for each new feature
- Create focused test files in tests/ for development
- Ensure no regression in existing functionality
- Test edge cases and error conditions

## Success Criteria
- All control flow statements from specification work correctly
- regression.bas includes tests for all new features
- No existing functionality is broken
- Code follows established patterns and reuses existing helpers
