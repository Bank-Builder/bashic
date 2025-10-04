# Test Reorganization and Integration Test Plan

## Goal
Review all tests, rename them to match modules, and create a comprehensive integration test covering all functionality.

## Step-by-Step Implementation Plan

### Step 1: Review Current Test Structure
- List all existing tests in tests/ and examples/
- Analyze what each test covers
- Identify gaps in test coverage
- Map tests to modules

### Step 2: Rename Tests to Match Modules
- Rename tests to follow module naming convention
- Group tests by module functionality
- Ensure clear test organization

### Step 3: Create Module-Specific Tests
- Create tests for each module if missing
- Ensure comprehensive coverage of each module
- Test edge cases and error conditions

### Step 4: Create Comprehensive Integration Test
- Combine all module tests into single integration test
- Test module interactions
- Test complete workflows
- Ensure end-to-end functionality

### Step 5: Update Test Documentation
- Document test structure
- Update README with test information
- Create test running instructions

## Proposed Test Structure

### Module-Specific Tests
- `test_util.bas` - Core utilities, error handling, global variables
- `test_math.bas` - Mathematical functions (ABS, INT, SGN, SQR)
- `test_string.bas` - String functions (LEN, LEFT$, RIGHT$, MID$, ASC, CHR$, VAL)
- `test_eval.bas` - Expression evaluation, operators, condition evaluation
- `test_control.bas` - Control flow (FOR/NEXT, WHILE/WEND, IF/THEN/ELSE, GOSUB/RETURN)
- `test_statement.bas` - Statement execution (PRINT, LET, DIM, INPUT)
- `test_core.bas` - Program management, execution loop

### Integration Tests
- `integration_complete.bas` - Complete functionality test
- `integration_workflows.bas` - End-to-end workflow tests
- `integration_edge_cases.bas` - Edge cases and error conditions

### Existing Tests to Review
- `regression.bas` - Current comprehensive test
- `string_comparison_test.bas` - String comparison tests
- `string_control_test.bas` - String control structure tests
- Various nested and control flow tests

## Success Criteria
- All tests renamed to match module structure
- Each module has comprehensive test coverage
- Integration test covers all functionality
- Clear test organization and documentation
- All tests pass with modular bashic
