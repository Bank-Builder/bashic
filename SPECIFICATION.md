# BASHIC Language Specification (BRS)

## Version 1.0

### Overview

BASHIC is a BASIC interpreter implemented entirely in bash, designed to be compatible with classic DOS BASIC syntax while maintaining simplicity and portability.

## Language Features

### Program Structure

- Programs consist of numbered lines (1-65535)
- Lines are executed in numerical order unless control flow statements redirect execution
- Each line may contain one statement
- Lines without numbers are treated as immediate mode (if supported)

### Data Types

#### Numeric Variables
- Integer: -2147483648 to 2147483647
- Floating point: Limited precision (bash arithmetic)
- Variable names: A-Z, A-Z followed by digits or single $

#### String Variables
- Variable names end with $ (e.g., A$, NAME$)
- Maximum length: 255 characters
- Enclosed in double quotes in literals

### Variables

#### Numeric Variables
```basic
A = 10
B% = 15        ' Integer variable
PI = 3.14159
```

#### String Variables
```basic
A$ = "Hello World"
NAME$ = "John Doe"
```

#### Arrays
```basic
DIM A(10)      ' Numeric array 0-10
DIM B$(5)      ' String array 0-5
```

### Operators

#### Arithmetic Operators
- `+` Addition
- `-` Subtraction  
- `*` Multiplication
- `/` Division
- `\` Integer division
- `MOD` Modulus
- `^` Exponentiation

#### Comparison Operators
- `=` Equal
- `<>` Not equal
- `<` Less than
- `>` Greater than
- `<=` Less than or equal
- `>=` Greater than or equal

#### Logical Operators
- `AND` Logical AND
- `OR` Logical OR
- `NOT` Logical NOT

### Control Flow Statements

#### IF/THEN/ELSE
```basic
10 IF A > 5 THEN PRINT "Greater than 5"
20 IF A = 0 THEN 100
30 IF A < 0 THEN PRINT "Negative" ELSE PRINT "Positive"
```

#### FOR/NEXT Loops
```basic
10 FOR I = 1 TO 10
20   PRINT I
30 NEXT I

40 FOR J = 10 TO 1 STEP -2
50   PRINT J
60 NEXT J
```

#### WHILE/WEND Loops
```basic
10 A = 1
20 WHILE A <= 5
30   PRINT A
40   A = A + 1
50 WEND
```

#### GOSUB/RETURN
```basic
10 GOSUB 100
20 END
100 PRINT "Subroutine"
110 RETURN
```

#### GOTO
```basic
10 GOTO 50
20 PRINT "Skipped"
50 PRINT "Jumped here"
```

### Input/Output Statements

#### PRINT
```basic
10 PRINT "Hello World"
20 PRINT A, B, C
30 PRINT "Value:", A
40 PRINT A;           ' No newline
50 PRINT              ' Empty line
```

#### INPUT
```basic
10 INPUT A
20 INPUT "Enter name:", A$
30 INPUT "X,Y:", X, Y
```

### Built-in Functions

#### Mathematical Functions
- `ABS(x)` - Absolute value
- `INT(x)` - Integer part
- `SGN(x)` - Sign (-1, 0, 1)
- `SQR(x)` - Square root
- `SIN(x)` - Sine (radians)
- `COS(x)` - Cosine (radians)
- `TAN(x)` - Tangent (radians)
- `LOG(x)` - Natural logarithm
- `EXP(x)` - e^x
- `RND(x)` - Random number 0-1

#### String Functions
- `LEN(s$)` - String length
- `LEFT$(s$, n)` - Left n characters
- `RIGHT$(s$, n)` - Right n characters
- `MID$(s$, start, len)` - Substring
- `ASC(s$)` - ASCII value of first character
- `CHR$(n)` - Character from ASCII value
- `STR$(n)` - Convert number to string
- `VAL(s$)` - Convert string to number

### Program Control

#### RUN
- Executes the program from the lowest line number

#### END
- Terminates program execution

#### STOP
- Stops program execution (like END)

#### CLEAR
- Clears all variables

#### NEW
- Clears program and variables

### Memory Management

#### DIM
```basic
10 DIM A(100)         ' Array with indices 0-100
20 DIM B$(10, 5)      ' 2D string array
```

### Error Handling

#### Error Types
- Syntax Error: Invalid BASIC syntax
- Type Mismatch: Wrong data type
- Out of Memory: Arrays too large
- Division by Zero: Mathematical error
- Undefined Variable: Variable not initialized
- Line Number Error: GOTO/GOSUB to non-existent line

### Implementation Notes

#### Line Number Handling
- Lines stored in associative array indexed by line number
- Execution pointer tracks current line
- GOTO/GOSUB validate target line exists

#### Variable Storage
- Numeric variables stored in associative array
- String variables stored in separate associative array
- Arrays implemented as bash arrays with name mangling

#### Expression Evaluation
- Recursive descent parser for expressions
- Operator precedence handled correctly
- Type checking for operations

#### Memory Limitations
- Variables limited by bash array capabilities
- String length limited to bash string limits
- Recursion depth limited by bash stack

### Reserved Words

```
AND, AS, CLEAR, DIM, ELSE, END, FOR, GOSUB, GOTO, IF, INPUT, 
LET, MOD, NEW, NEXT, NOT, OR, PRINT, RETURN, RUN, STEP, STOP, 
THEN, TO, WEND, WHILE

ABS, ASC, CHR$, COS, EXP, INT, LEFT$, LEN, LOG, MID$, RIGHT$, 
RND, SGN, SIN, SQR, STR$, TAN, VAL
```

### File Format

- Plain text files with .bas extension
- Lines may be in any order (sorted by line number at load)
- Comments start with REM or single quote (')
- Case insensitive keywords
- Line endings: Unix (LF) or DOS (CRLF)

### Command Line Usage

```bash
./bashic program.bas          # Run BASIC program
./bashic -i                   # Interactive mode (if implemented)
./bashic -h                   # Help
./bashic -v                   # Version
```

### Compatibility

- Compatible with GW-BASIC and QBasic subset
- Text-mode only (no graphics)
- No file I/O beyond program loading
- No advanced features (procedures, user functions, etc.)

This specification defines a minimal but functional BASIC interpreter suitable for educational use and simple programming tasks.
