# Missing Operators Implementation Plan

## Current Operator Status

### ✅ IMPLEMENTED Operators (10/16 = 62.5%):

#### Arithmetic (4/7):
- ✅ `+` Addition
- ✅ `-` Subtraction  
- ✅ `*` Multiplication
- ✅ `/` Division

#### Comparison (6/6):
- ✅ `=` Equal
- ✅ `<>` Not equal
- ✅ `<` Less than
- ✅ `>` Greater than
- ✅ `<=` Less than or equal
- ✅ `>=` Greater than or equal

### ❌ MISSING Operators (6/16 = 37.5%):

#### Arithmetic (3/7):
- ❌ `MOD` Modulus
- ❌ `\` Integer division
- ❌ `^` Exponentiation

#### Logical (3/3):
- ❌ `AND` Logical AND
- ❌ `OR` Logical OR
- ❌ `NOT` Logical NOT

## Implementation Plan (Priority Order)

### Phase 1: MOD Operator (Highest Priority)
**Goal**: Implement modulus operator for remainder calculations

**Implementation Steps**:
1. Add MOD to arithmetic expression regex pattern
2. Implement modulus calculation in arithmetic case statement
3. Test with various expressions (A MOD B)
4. Add regression test cases

**Code Location**: Line 400 in evaluate_expression()
**Code Reuse**: Follow existing arithmetic operator pattern

### Phase 2: Logical Operators (High Priority)
**Goal**: Implement AND, OR, NOT for compound conditions

**Implementation Steps**:
1. Create evaluate_condition() helper function
2. Parse logical operators in conditions
3. Implement operator precedence: NOT > AND > OR
4. Update IF and WHILE to use enhanced condition evaluation
5. Test complex conditions

**Code Location**: Lines 650+ (condition evaluation in IF/WHILE)
**Code Reuse**: Extract and enhance existing condition logic

### Phase 3: Integer Division (\) (Medium Priority)
**Goal**: Implement integer division operator

**Implementation Steps**:
1. Add \ to arithmetic expression regex
2. Implement integer division in case statement
3. Test edge cases (division by zero)
4. Add regression tests

**Code Location**: Line 400 in evaluate_expression()
**Code Reuse**: Follow existing arithmetic operator pattern

### Phase 4: Exponentiation (^) (Lower Priority)
**Goal**: Implement power/exponentiation operator

**Implementation Steps**:
1. Add ^ to arithmetic expression regex
2. Implement power calculation (using bash arithmetic or bc)
3. Test with various bases and exponents
4. Add regression tests

**Code Location**: Line 400 in evaluate_expression()
**Code Reuse**: Follow existing arithmetic operator pattern

## Testing Strategy

### Test Files to Create:
1. `tests/mod_test.bas` - MOD operator testing
2. `tests/logical_test.bas` - AND, OR, NOT testing
3. `tests/arithmetic_complete.bas` - All arithmetic operators
4. Add cases to `tests/regression.bas`

### Success Criteria:
- All 16 operators from specification implemented
- All operators work in expressions and conditions
- Proper operator precedence maintained
- No regression in existing functionality
- 100% operator coverage in regression tests

## Implementation Order Rationale:
1. **MOD first** - Most commonly used in BASIC programs (even/odd, cycling)
2. **Logical operators** - Essential for complex conditions
3. **Integer division** - Mathematical completeness
4. **Exponentiation** - Advanced mathematical operations
