# AND/OR Logical Operators Implementation Plan

## Goal
Implement AND and OR logical operators for compound conditions in IF and WHILE statements.

## Current Condition Evaluation
Currently supports simple conditions: `A > 5`, `B = 10`, etc.
Need to support compound conditions: `A > 5 AND B < 10`, `X = 1 OR X = 2`

## Step-by-Step Implementation Plan

### Step 1: Analyze Current Condition Evaluation
- Review existing condition parsing in IF and WHILE statements
- Identify code reuse opportunities
- Document current regex patterns

### Step 2: Design Compound Condition Parser
- Support format: `condition1 AND condition2`
- Support format: `condition1 OR condition2`  
- Handle operator precedence: AND before OR
- Plan recursive evaluation for multiple operators

### Step 3: Create Enhanced Condition Evaluator
- Extract current condition logic into reusable helper function
- Create evaluate_compound_condition() function
- Parse logical operators (AND, OR)
- Evaluate sub-conditions using existing logic

### Step 4: Update IF Statement
- Modify execute_if() to use enhanced condition evaluator
- Maintain backward compatibility with simple conditions
- Test with compound conditions

### Step 5: Update WHILE Statement  
- Modify execute_wend() to use enhanced condition evaluator
- Ensure same logic as IF for consistency
- Test with compound conditions in loops

### Step 6: Create Test Cases
- Test simple AND conditions: `A > 5 AND B < 10`
- Test simple OR conditions: `A = 1 OR A = 2`
- Test in IF statements and WHILE loops
- Test nested structures with compound conditions

### Step 7: Add to Regression Suite
- Add comprehensive AND/OR tests to regression.bas
- Verify no existing functionality is broken

## Code Reuse Strategy
- Extract existing condition evaluation into helper function
- Reuse same comparison operators (=, <>, <, >, <=, >=)
- Apply same pattern to both IF and WHILE statements
- Follow same debug and error handling patterns

## Implementation Locations
- Current condition evaluation: Lines 650+ (WEND) and 700+ (IF)
- Target: Create shared evaluate_condition() helper
- Update: execute_if() and execute_wend() functions

## Success Criteria
- `IF A > 5 AND B < 10 THEN` works correctly
- `WHILE X = 1 OR Y = 2` works correctly
- All existing simple conditions still work
- Proper operator precedence (AND before OR)
- All regression tests pass
