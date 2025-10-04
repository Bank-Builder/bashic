# BASHIC Project TODO

## Project Overview
Create a BASIC interpreter using only bash that can execute .bas files with `./bashic myprog.bas`.

## Project Structure Tasks
- [x] Create project directory structure
- [x] Create README.md with project overview
- [x] Create examples/ directory for test programs
- [x] Create scripts/ directory for build scripts
- [x] Create debian/ directory for package structure

## Specification Tasks
- [x] Write detailed BASIC specification (BRS) document
- [x] Define supported data types (numeric, string, arrays)
- [x] Define supported operators (arithmetic, comparison, logical)
- [x] Define control flow statements (IF/THEN, FOR/NEXT, WHILE/WEND, GOSUB/RETURN)
- [x] Define built-in functions (math, string manipulation)
- [x] Define I/O statements (PRINT, INPUT)
- [x] Define error handling approach
- [x] Define memory management approach

## Core Interpreter Implementation
- [x] Create main bashic executable script
- [x] Implement command line argument parsing
- [x] Implement program file loading
- [x] Implement line number parsing and storage
- [x] Implement program execution loop
- [x] Implement basic error handling

## Expression Evaluation
- [x] Implement numeric literal parsing
- [x] Implement string literal parsing
- [x] Implement variable reference evaluation
- [x] Implement basic arithmetic operations (+, -, *, /)
- [ ] **FIX REQUIRED**: Arithmetic expressions in PRINT statements not evaluating (A + B shows as "A + B")
- [x] Implement comparison operations (=, <>, <, >, <=, >=)
- [ ] **ENHANCEMENT**: Implement operator precedence handling
- [ ] **ENHANCEMENT**: Implement parentheses in expressions

## Variable Management
- [x] Implement numeric variable storage
- [x] Implement string variable storage (variables ending with $)
- [x] Implement variable assignment (LET statement)
- [x] Implement variable retrieval
- [x] **COMPLETED**: Implement array declaration (DIM statement)
- [x] **COMPLETED**: Implement array access and assignment

## Control Flow Statements
- [x] Implement IF/THEN statement
- [x] **COMPLETED**: Implement IF/THEN/ELSE statement
- [x] Implement GOTO statement
- [x] Implement GOSUB/RETURN statements with stack
- [x] Implement FOR/NEXT loops with variable and step support
- [x] **COMPLETED**: Implement WHILE/WEND loops
- [x] Implement END/STOP statements
- [x] **COMPLETED**: Implement nested control structures (all combinations tested)

## Missing Operators (6/16 operators not implemented)

### Arithmetic Operators (3 missing)
- [ ] **HIGH PRIORITY**: Implement MOD (modulus) operator
  - Location: Line 400 in evaluate_expression() 
  - Pattern: Add MOD to arithmetic regex and case statement
  - Usage: `A MOD B` for remainder calculation
- [ ] **MEDIUM PRIORITY**: Implement \ (integer division) operator
  - Location: Line 400 in evaluate_expression()
  - Pattern: Follow existing arithmetic operator pattern
  - Usage: `A \ B` for integer division
- [ ] **LOWER PRIORITY**: Implement ^ (exponentiation) operator
  - Location: Line 400 in evaluate_expression()
  - Pattern: Follow existing arithmetic operator pattern  
  - Usage: `A ^ B` for power calculation

### Logical Operators (3 missing)
- [ ] **HIGH PRIORITY**: Implement AND logical operator
  - Location: Condition evaluation in IF/WHILE (lines 650+)
  - Pattern: Extend condition parsing for compound conditions
  - Usage: `IF A > 5 AND B < 10 THEN`
- [ ] **HIGH PRIORITY**: Implement OR logical operator
  - Location: Condition evaluation in IF/WHILE (lines 650+)
  - Pattern: Extend condition parsing for compound conditions
  - Usage: `IF A = 1 OR A = 2 THEN`
- [ ] **MEDIUM PRIORITY**: Implement NOT logical operator
  - Location: Condition evaluation in IF/WHILE (lines 650+)
  - Pattern: Prefix operator for condition negation
  - Usage: `IF NOT A = 0 THEN`

## Built-in Functions
### Mathematical Functions
- [x] Implement ABS(x) - absolute value
- [x] Implement INT(x) - integer part
- [x] Implement SGN(x) - sign function
- [x] Implement SQR(x) - square root
- [ ] **MISSING**: Implement SIN(x), COS(x), TAN(x) - trigonometric functions
- [ ] **MISSING**: Implement LOG(x), EXP(x) - logarithmic functions
- [ ] **MISSING**: Implement RND(x) - random number generation

### String Functions
- [x] Implement LEN(s$) - string length
- [x] Implement LEFT$(s$, n) - left substring
- [x] Implement RIGHT$(s$, n) - right substring
- [x] Implement MID$(s$, start, len) - middle substring
- [x] Implement ASC(s$) - ASCII value
- [x] Implement CHR$(n) - character from ASCII
- [x] **EXPOSED**: ASC, CHR$, VAL functions (were hidden, now accessible)
- [ ] **MISSING**: Implement STR$(n) - number to string conversion
- [x] Implement VAL(s$) - string to number conversion

## I/O Statements
- [x] Implement basic PRINT statement
- [x] Implement PRINT with comma separation (tab formatting)
- [x] Implement PRINT with semicolon separation (no newline)
- [x] Implement PRINT with string literals
- [x] Implement PRINT with variable references
- [x] **COMPLETED**: PRINT expressions now evaluate properly
- [ ] **MISSING**: Implement INPUT statement for numeric input
- [ ] **MISSING**: Implement INPUT statement for string input
- [ ] **MISSING**: Implement INPUT with prompt text

## Missing Built-in Functions (8 functions not implemented)

### Mathematical Functions (6 missing)
- [ ] **MEDIUM PRIORITY**: Implement SIN(x) - sine function
  - Requires trigonometric calculation (bc or approximation)
- [ ] **MEDIUM PRIORITY**: Implement COS(x) - cosine function  
  - Requires trigonometric calculation (bc or approximation)
- [ ] **MEDIUM PRIORITY**: Implement TAN(x) - tangent function
  - Requires trigonometric calculation (bc or approximation)
- [ ] **MEDIUM PRIORITY**: Implement LOG(x) - natural logarithm
  - Requires logarithmic calculation (bc or approximation)
- [ ] **MEDIUM PRIORITY**: Implement EXP(x) - exponential function
  - Requires exponential calculation (bc or approximation)
- [ ] **HIGH PRIORITY**: Implement RND(x) - random number generation
  - Use bash $RANDOM for implementation
  - Usage: `RND(1)` returns 0-1 random number

### String Functions (1 missing)
- [ ] **HIGH PRIORITY**: Implement STR$(n) - number to string conversion
  - Location: Add to function case statement
  - Pattern: Follow existing string function pattern
  - Usage: `STR$(123)` returns "123"

### Program Control Commands (3 missing)
- [ ] **MEDIUM PRIORITY**: Implement CLEAR command
  - Clear all variables but keep program
  - Reset NUMERIC_VARS, STRING_VARS, ARRAYS
- [ ] **MEDIUM PRIORITY**: Implement NEW command  
  - Clear program and all variables
  - Reset PROGRAM_LINES and all variable arrays
- [ ] **LOW PRIORITY**: Implement RUN command
  - Restart program execution from beginning
  - Reset execution state and start from first line

## Test Programs
- [x] Create test1.bas - simple functionality test
- [x] Create test2.bas - advanced functionality test
- [x] **COMPLETED**: Verify all test programs run correctly
  - test1.bas: ✅ WORKING - all arithmetic and basic functions work
  - test2.bas: ✅ WORKING - all functionality working (DIM implemented)
  - tests/regression.bas: ✅ WORKING - 100% function coverage achieved
- [x] Create additional test programs for edge cases
  - Created math_test.bas for comprehensive mathematical function testing

## Debian Package
- [x] Create debian/DEBIAN/control file
- [x] Create debian package directory structure
- [x] Create scripts/mkdeb.sh build script
- [x] Make mkdeb.sh executable
- [ ] Test debian package creation
- [ ] Test debian package installation

## Code Quality & Bug Fixes
### Critical Fixes Needed
- [x] **FIXED**: Fix arithmetic expression evaluation in PRINT statements
  - Issue: Regex pattern `^([A-Z0-9]+)\ *([+\-*/])\ *([A-Z0-9]+)$` not matching
  - Root cause: Character class `[+\-*/]` not properly escaped in bash regex
  - Solution: Replace with individual operator patterns: `(\+|\-|\*|/)`
  - Location: Line 280 in bashic script, evaluate_expression function
  - Status: COMPLETED - arithmetic now works in PRINT statements
- [ ] **CRITICAL**: Fix regex patterns for expression parsing
  - Multiple regex patterns using character classes need review
  - Test all regex patterns with actual input data
- [x] **FIXED**: Test and fix all mathematical functions
  - math_sgn() function has complex logic that may not work correctly
  - math_sqr() fallback Newton's method may have issues
  - Status: COMPLETED - SGN function rewritten and tested, all math functions working
- [x] **FIXED**: Inconsistent code between main bashic and debian/usr/bin/bashic files
  - debian/usr/bin/bashic has different regex pattern (line 280)
  - Need to sync both files after fixes
  - Status: COMPLETED - both files now synchronized

### Enhancements Needed
- [ ] Improve error messages with line numbers
- [ ] Add support for negative numbers in expressions  
- [ ] Add support for floating point arithmetic
- [ ] Improve expression parsing for complex expressions
- [ ] Add support for string concatenation
- [ ] Add support for logical operators (AND, OR, NOT)

### Testing & Validation
- [ ] Test all BASIC statements with various inputs
- [ ] Test error conditions and error messages
- [ ] Test edge cases (empty programs, invalid syntax, etc.)
- [ ] Performance testing with larger programs
- [ ] Memory usage testing

## Documentation
- [x] Create comprehensive SPECIFICATION.md
- [x] Create project README.md
- [x] Document command line usage
- [x] Document installation procedures
- [ ] Create user manual with examples
- [ ] Document known limitations
- [ ] Create developer documentation

## Git & Version Control
- [ ] Create .gitignore file
- [ ] Create LICENSE file
- [ ] Set up proper git repository structure
- [ ] Tag initial release version

## Status Summary
- **Completed**: 45+ tasks
- **Critical Fixes Needed**: 3 tasks
- **Enhancements**: 10+ tasks
- **Testing**: 5+ tasks

## Immediate Next Steps (Priority Order)

### Phase 1: Critical Bug Fixes
1. **Fix INKEY$ implementation for interactive mode**
   - Issue: INKEY$ only works in non-interactive mode (stdin not terminal)
   - Location: bashic.core.sh and bashic.eval.sh
   - Implementation Issues:
     a. Terminal Mode:
        - Raw/cbreak mode setup inconsistent
        - Terminal state restoration unreliable
        - Need to handle -icanon and -echo properly
     b. Input Reading:
        - Non-blocking read unreliable
        - Timeout values need tuning
        - Buffer management inconsistent
     c. Testing:
        - Need comprehensive test suite
        - Edge cases not covered
        - Debug output interferes with testing
   - Required Changes:
     1. Implement proper terminal mode setup
     2. Use consistent input reading method
     3. Improve buffer management
     4. Add comprehensive tests
     5. Fix debug output interference
2. **Fix arithmetic expression regex** (Line 280 in bashic)
   - Replace `[+\-*/]` with `(\+|\-|\*|/)`
   - Test with "A + B", "A-B", "A*B", "A/B"
3. **Sync debian/usr/bin/bashic** with main bashic file
4. **Test mathematical functions** (ABS, INT, SGN, SQR)
5. **Verify test1.bas and test2.bas run correctly**

### Phase 2: Missing Core Features  
1. **Implement WHILE/WEND loops**
2. **Implement INPUT statements**
3. **Implement DIM and array support**
4. **Add missing mathematical functions** (SIN, COS, etc.)

### Phase 3: Testing & Packaging
1. **Create comprehensive test suite**
2. **Test debian package creation and installation**
3. **Performance and memory testing**

## Implementation Priority Plan

### Phase 1: High Priority Operators (Essential for BASIC programs)
1. **Implement MOD operator** - Most commonly used for even/odd, cycling
2. **Implement AND/OR logical operators** - Essential for complex conditions
3. **Implement STR$ function** - Common string conversion
4. **Implement RND function** - Random number generation

### Phase 2: Medium Priority Features  
1. **Implement INPUT statements** - User interaction
2. **Implement remaining arithmetic operators** (\, ^)
3. **Implement NOT logical operator** - Logical completeness
4. **Implement trigonometric functions** (SIN, COS, TAN, LOG, EXP)

### Phase 3: Program Control Commands
1. **Implement CLEAR command** - Variable reset
2. **Implement NEW command** - Program reset
3. **Implement RUN command** - Program restart

### Phase 4: Advanced Features
1. **Operator precedence handling** - Complex expression evaluation
2. **Parentheses in expressions** - Grouped operations
3. **String concatenation** - Enhanced string operations

## Next Immediate Tasks
1. Implement MOD operator with regression tests
2. Implement AND/OR logical operators with regression tests
3. Test all operators with nested control structures
4. Update tests/regression.bas for 100% operator coverage
5. Build and test debian package with complete functionality
