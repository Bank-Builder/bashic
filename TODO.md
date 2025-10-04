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
- [ ] **MISSING**: Implement array declaration (DIM statement)
- [ ] **MISSING**: Implement array access and assignment

## Control Flow Statements
- [x] Implement IF/THEN statement
- [ ] **MISSING**: Implement IF/THEN/ELSE statement
- [x] Implement GOTO statement
- [x] Implement GOSUB/RETURN statements with stack
- [x] Implement FOR/NEXT loops with variable and step support
- [ ] **MISSING**: Implement WHILE/WEND loops (declared but not implemented)
- [x] Implement END/STOP statements

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
- [ ] **MISSING**: Implement STR$(n) - number to string conversion
- [x] Implement VAL(s$) - string to number conversion

## I/O Statements
- [x] Implement basic PRINT statement
- [x] Implement PRINT with comma separation (tab formatting)
- [x] Implement PRINT with semicolon separation (no newline)
- [x] Implement PRINT with string literals
- [x] Implement PRINT with variable references
- [ ] **FIX REQUIRED**: PRINT expressions not evaluating properly
- [ ] **MISSING**: Implement INPUT statement for numeric input
- [ ] **MISSING**: Implement INPUT statement for string input
- [ ] **MISSING**: Implement INPUT with prompt text

## Test Programs
- [x] Create test1.bas - simple functionality test
- [x] Create test2.bas - advanced functionality test
- [ ] **TESTING**: Verify all test programs run correctly
- [ ] Create additional test programs for edge cases

## Debian Package
- [x] Create debian/DEBIAN/control file
- [x] Create debian package directory structure
- [x] Create scripts/mkdeb.sh build script
- [x] Make mkdeb.sh executable
- [ ] Test debian package creation
- [ ] Test debian package installation

## Code Quality & Bug Fixes
### Critical Fixes Needed
- [ ] **CRITICAL**: Fix arithmetic expression evaluation in PRINT statements
  - Issue: Regex pattern `^([A-Z0-9]+)\ *([+\-*/])\ *([A-Z0-9]+)$` not matching
  - Root cause: Character class `[+\-*/]` not properly escaped in bash regex
  - Solution: Replace with individual operator patterns: `(\+|\-|\*|/)`
  - Location: Line 280 in bashic script, evaluate_expression function
- [ ] **CRITICAL**: Fix regex patterns for expression parsing
  - Multiple regex patterns using character classes need review
  - Test all regex patterns with actual input data
- [ ] **CRITICAL**: Test and fix all mathematical functions
  - math_sgn() function has complex logic that may not work correctly
  - math_sqr() fallback Newton's method may have issues
- [ ] **CRITICAL**: Inconsistent code between main bashic and debian/usr/bin/bashic files
  - debian/usr/bin/bashic has different regex pattern (line 280)
  - Need to sync both files after fixes

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
1. **Fix arithmetic expression regex** (Line 280 in bashic)
   - Replace `[+\-*/]` with `(\+|\-|\*|/)`
   - Test with "A + B", "A-B", "A*B", "A/B"
2. **Sync debian/usr/bin/bashic** with main bashic file
3. **Test mathematical functions** (ABS, INT, SGN, SQR)
4. **Verify test1.bas and test2.bas run correctly**

### Phase 2: Missing Core Features  
1. **Implement WHILE/WEND loops**
2. **Implement INPUT statements**
3. **Implement DIM and array support**
4. **Add missing mathematical functions** (SIN, COS, etc.)

### Phase 3: Testing & Packaging
1. **Create comprehensive test suite**
2. **Test debian package creation and installation**
3. **Performance and memory testing**

## Next Priority Tasks
1. Fix arithmetic expression evaluation in PRINT statements
2. Test and validate all existing functionality
3. Implement missing core features (WHILE/WEND, arrays)
4. Create comprehensive test suite
5. Build and test debian package
