# INPUT and String Operators Implementation Plan

## Executive Summary
BASHIC interpreter is ~85% complete. Missing critical INPUT statement and program control commands. String operations are largely complete but need verification.

## Current Status

### ✅ IMPLEMENTED (9/13 statements - 69% complete)
- **Control Flow**: END, STOP, PRINT, LET, DIM, FOR/NEXT, WHILE/WEND, IF/THEN/ELSE, GOTO, GOSUB/RETURN
- **String Functions**: LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL, STR$
- **String Operations**: String variables, literals, concatenation (+), assignment
- **Operators**: All comparison (=, <>, <, >, <=, >=), all logical (NOT, AND, OR), most arithmetic (+, -, *, /, MOD)

### ❌ MISSING (4/13 statements - 31% incomplete)
- **INPUT** - User input from keyboard (CRITICAL)
- **CLEAR** - Clear all variables
- **NEW** - Clear program and variables, reset interpreter
- **RUN** - Restart program execution

### ❓ NEEDS VERIFICATION
- String comparison operators (lexicographic ordering)
- Mixed string/numeric comparisons
- String operations in complex expressions

## Implementation Priority

### Phase 1: INPUT Statement (HIGH PRIORITY)
**Goal**: Enable interactive BASIC programs

**INPUT Formats to Implement**:
1. `INPUT A` - Single numeric variable
2. `INPUT A$` - Single string variable
3. `INPUT "Enter value:", A` - Prompt with variable
4. `INPUT "Enter name:", A$` - Prompt with string variable
5. `INPUT "X,Y:", X, Y` - Multiple variables
6. `INPUT "Name,Age:", NAME$, AGE` - Mixed types

**Implementation Steps**:
1. Create `execute_input()` function
2. Parse INPUT statement arguments
3. Handle prompts and variable lists
4. Read user input from stdin
5. Parse comma-separated input values
6. Validate input types (numeric vs string)
7. Assign values to variables
8. Add INPUT case to `execute_statement()`

### Phase 2: String Comparison Verification (MEDIUM PRIORITY)
**Goal**: Ensure all string operations work correctly

**Tests to Implement**:
1. Lexicographic ordering: `"apple" < "banana"`
2. String equality: `"cat" = "cat"`
3. String inequality: `"dog" <> "cat"`
4. Mixed comparisons: `A$ = "hello" AND A$ <> "world"`
5. String comparisons in IF/WHILE statements

### Phase 3: Program Control Commands (LOW PRIORITY)
**Goal**: Complete BASIC command set

**Commands to Implement**:
1. **CLEAR**: Clear all variables (NUMERIC_VARS, STRING_VARS, ARRAYS)
2. **NEW**: Clear program and variables, reset interpreter state
3. **RUN**: Restart program execution from beginning

## Technical Implementation Details

### INPUT Statement Implementation
```bash
execute_input() {
    local args="$1"
    # Parse prompts and variable lists
    # Read from stdin
    # Validate and assign values
}
```

### String Comparison Verification
- Test all comparison operators with strings
- Verify lexicographic ordering works correctly
- Test string comparisons in conditional statements
- Test mixed string/numeric comparisons

### Program Control Commands
- **CLEAR**: Reset variable arrays to empty
- **NEW**: Clear variables + reset program state + clear line numbers
- **RUN**: Restart execution from first line

## Success Criteria

### INPUT Statement
- ✅ `INPUT A` works for numeric input
- ✅ `INPUT A$` works for string input
- ✅ `INPUT "Enter name:", A$` works with prompts
- ✅ `INPUT "X,Y:", X, Y` works for multiple variables
- ✅ Input validation and error handling
- ✅ Integration with existing variable system

### String Operations
- ✅ All string comparison operators work correctly
- ✅ Lexicographic ordering works
- ✅ String comparisons work in IF/WHILE statements
- ✅ Mixed string/numeric comparisons work
- ✅ String operations work in complex expressions

### Program Control
- ✅ `CLEAR` clears all variables
- ✅ `NEW` resets interpreter state
- ✅ `RUN` restarts program execution
- ✅ All existing functionality preserved

## Testing Strategy

### Regression Testing
- Add INPUT statement tests to `tests/regression.bas`
- Add string comparison verification tests
- Add program control command tests
- Verify no existing functionality is broken

### Test Cases
1. **INPUT Tests**: All INPUT formats, error handling, type validation
2. **String Comparison Tests**: All operators, lexicographic ordering, mixed types
3. **Program Control Tests**: CLEAR, NEW, RUN functionality
4. **Integration Tests**: INPUT with strings, string operations in complex expressions

## Estimated Completion

### Phase 1 (INPUT): 2-3 hours
- INPUT statement implementation
- Basic testing and validation

### Phase 2 (String Verification): 1-2 hours
- String comparison testing
- Bug fixes if needed

### Phase 3 (Program Control): 1 hour
- CLEAR, NEW, RUN implementation
- Final testing

**Total Estimated Time**: 4-6 hours

## Risk Assessment

### Low Risk
- String comparison verification (likely already working)
- Program control commands (straightforward implementation)

### Medium Risk
- INPUT statement parsing (complex argument handling)
- Input validation and error handling
- Integration with existing variable system

### Mitigation
- Implement incrementally with extensive testing
- Follow existing code patterns and error handling
- Use regression testing to prevent breaking existing functionality

## Next Steps

1. **Start with INPUT statement** - Most critical missing feature
2. **Implement incrementally** - One INPUT format at a time
3. **Test thoroughly** - Each implementation step
4. **Verify string operations** - Ensure all work correctly
5. **Complete program control** - Add remaining commands
6. **Final regression testing** - Ensure 100% functionality

## Conclusion

BASHIC interpreter is very close to completion. INPUT statement is the critical missing piece that will enable interactive BASIC programs. String operations are largely complete but need verification. Program control commands are straightforward additions.

**Priority**: Implement INPUT statement first, then verify string operations, then add program control commands.
