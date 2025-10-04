# Nested Control Loop Test Plan

## Goal
Create comprehensive test cases for all nested control loop combinations in BASHIC.

## Implementation Status: ✅ COMPLETED

All nested control structure testing has been implemented and verified working.

## Current Control Structures Available
1. **FOR/NEXT** loops
2. **WHILE/WEND** loops  
3. **IF/THEN/ELSE** statements
4. **GOSUB/RETURN** subroutines

## Nested Combinations to Test

### Level 1: Two-Level Nesting
1. **FOR inside FOR** - Nested FOR loops
2. **WHILE inside WHILE** - Nested WHILE loops
3. **FOR inside WHILE** - FOR loop within WHILE loop
4. **WHILE inside FOR** - WHILE loop within FOR loop
5. **IF inside FOR** - Conditional within FOR loop
6. **IF inside WHILE** - Conditional within WHILE loop
7. **GOSUB from loops** - Subroutine calls from within loops

### Level 2: Three-Level Nesting
1. **FOR/WHILE/IF** - Triple nested structures
2. **WHILE/FOR/IF** - Alternative triple nesting
3. **GOSUB with nested loops** - Subroutines containing nested loops

### Level 3: Complex Scenarios
1. **Multiple GOSUB with nested returns** - Complex subroutine patterns
2. **Early loop exits** - GOTO out of nested loops
3. **Conditional loop control** - IF statements controlling loop flow

## Test Implementation Strategy

### Test 1: Basic Two-Level Nesting
- FOR inside FOR (multiplication table)
- WHILE inside WHILE (countdown matrix)
- FOR inside WHILE and vice versa

### Test 2: Conditional Control in Loops
- IF/THEN/ELSE inside FOR loops
- IF/THEN/ELSE inside WHILE loops
- Complex condition evaluation within loops

### Test 3: Subroutine Integration
- GOSUB from within nested loops
- RETURN to correct loop context
- Subroutines containing their own nested loops

### Test 4: Stack Management Validation
- Verify FOR_STACK handles deep nesting correctly
- Verify WHILE_STACK handles deep nesting correctly
- Verify GOSUB_STACK handles calls from nested contexts

### Test 5: Error Conditions
- NEXT without FOR in nested context
- WEND without WHILE in nested context
- RETURN without GOSUB in nested context

## Success Criteria
- All nested combinations execute correctly
- Stack management preserves proper execution flow
- No stack corruption or memory issues
- Performance acceptable for reasonable nesting depth
- Error handling works correctly in nested contexts

## Files to Create
1. `tests/nested_basic.bas` - Basic two-level nesting
2. `tests/nested_complex.bas` - Three-level and complex scenarios
3. `tests/nested_errors.bas` - Error condition testing
4. Add nested tests to `examples/regression.bas`
