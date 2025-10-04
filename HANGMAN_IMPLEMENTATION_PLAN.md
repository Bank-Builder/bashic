# Hangman.bas Implementation Plan

## Analysis of Missing Features in examples/hangman.bas

### ✅ Already Implemented (Working)
- ✅ PRINT, LET, DIM - Basic statements
- ✅ IF/THEN/ELSE, FOR/NEXT, GOTO - Control flow
- ✅ String variables, arrays (1D and 2D)
- ✅ String functions: LEN, MID$, LEFT$, RIGHT$, CHR$, VAL
- ✅ Math: INT, ABS, SGN, SQR
- ✅ Logical operators: AND, OR, NOT
- ✅ Colon statement separator (:)
- ✅ INPUT statement
- ✅ INKEY$ function
- ✅ BASHIC_UPPER_CASE special variable
- ✅ END, STOP

### ❌ Missing Features Required for Hangman.bas

#### HIGH PRIORITY (Critical for gameplay)

**1. ON...GOTO Statement** (Lines 58, 69)
```basic
410 ON M GOTO 415,420,425,430,435,440,445,450,455,460
470 ON M GOTO 480,490,500,510,520,530,540,550,560,570
```
- Computed GOTO based on variable value
- `ON X GOTO line1, line2, line3` - jumps to line1 if X=1, line2 if X=2, etc.
- **Implementation**: Parse comma-separated line list, use variable as index

**2. DATA/READ/RESTORE Statements** (Lines 87-97, 29, 30, 115)
```basic
700 DATA  "GUM","SIN","FOR","CRY","HID","BYE","FLY"
115 U(Q)=1:C=C+1:RESTORE:T1=0
150 FOR I=1 TO Q:READ A$:NEXT I
```
- `DATA` - Store data in program
- `READ` - Read next data item into variable
- `RESTORE` - Reset data pointer to beginning
- **Implementation**: Parse DATA lines, maintain data pointer, read sequentially

**3. RND Function** (Line 27)
```basic
100 Q=INT(N*RND(1))+1
```
- Random number generator (0-1)
- **Implementation**: Use bash $RANDOM and scale

**4. TAB Function** (Line 81)
```basic
580 FOR I=1 TO 13:PRINT TAB(13);:FOR J=1 TO 12:PRINT P$(I,J);:NEXT J
```
- Move cursor to column position
- **Implementation**: Print spaces to reach column

**5. TIME$ Function** (Line 13)
```basic
27 RANDOMIZE VAL(MID$(TIME$,7,2))
```
- Current time as string (HH:MM:SS format)
- **Implementation**: Use `date +%H:%M:%S`

**6. SPACE$ Function** (Line 19)
```basic
45 LOCATE 23,7:COLOR 7,0:PRINT SPACE$(30);
```
- Return string of N spaces
- **Implementation**: `printf '%*s' N ''`

#### MEDIUM PRIORITY (Screen Module Features)

**NEW MODULE: bashic.screen.sh**
Create a new screen module using ANSI escape codes to implement display functions:

**7. CLS Statement** (Lines 3, 10, 32, 54, 56, 86)
- Clear screen
- **Implementation**: `echo -e "\033[2J\033[H"` (ANSI clear screen + home)

**8. LOCATE Statement** (Lines 4, 6, 10-12, 17, 19, 32, 54, 83, 86)
- Position cursor at row, column
- **Implementation**: `echo -ne "\033[${row};${col}H"` (ANSI cursor positioning)

**9. COLOR Statement** (Lines 17, 19, 38, 83)
- Set text/background colors
- **Implementation**: ANSI color codes `\033[${fg};${bg}m`
- Standard colors: 30-37 (foreground), 40-47 (background)

**10. WIDTH Statement** (Lines 3, 9)
- Set screen width
- **Implementation**: Store in SCREEN_WIDTH variable (doesn't actually resize terminal)

**11. SOUND/BEEP Statements** (Lines 57, 68)
- Make sound/beep
- **Implementation**: `echo -e "\a"` (terminal bell)

**12. KEY OFF Statement** (Line 3)
- Disable function key display
- **Stub**: Ignore (no-op) - not relevant for modern terminals

**13. POKE/PEEK Statements** (Line 17)
- Memory manipulation
- **Stub**: Ignore (no-op) - cannot implement in bash

#### LOW PRIORITY (Advanced features)

**13. 2D Array Access** (Lines 22, 70-80)
```basic
70 FOR I=1 TO 12:FOR J=1 TO 12:P$(I,J)=" ":NEXT J:NEXT I
```
- Currently DIM supports P$(13,12) but access needs row,col indexing
- **Implementation**: Store as P$_row_col

**14. Integer Variables (%)** (Lines 14, 16)
```basic
28 NUMWORDS%=66
```
- Variables ending in % are integers
- **Implementation**: Store in NUMERIC_VARS, truncate on assignment

**15. Hexadecimal Numbers (&H)** (Line 1 - already removed)
```basic
DEF SEG=&H40
```
- Not needed for BASHIC version

---

## Implementation Priority Order

### Phase 1: Essential for Basic Gameplay (Must Have)
1. **RND(X)** - Random number function
2. **ON...GOTO** - Computed GOTO for game logic
3. **DATA/READ/RESTORE** - Word list storage and retrieval
4. **TIME$** - For RANDOMIZE seed
5. **SPACE$(N)** - String of spaces
6. **TAB(N)** - Column positioning

### Phase 2: Enhanced Features (Nice to Have)
7. **2D Array Access** - P$(I,J) for graphics
8. **Integer Variables (%)** - NUMWORDS%

### Phase 3: Already Stubbed (Working)
- All hardware commands already ignored gracefully
- Program runs but without graphics/sound

---

## Estimated Implementation Effort

### Quick Wins (< 30 minutes each)
- ✅ SPACE$(N) - Simple string generation
- ✅ RND(X) - Use $RANDOM
- ✅ TIME$ - Use date command
- ✅ TAB(N) - Print spaces

### Medium Effort (1-2 hours)
- ⚠️ ON...GOTO - Parse line list, index lookup
- ⚠️ DATA/READ/RESTORE - Data storage and pointer management

### Complex (2+ hours)
- ⚠️ 2D Array Access - Requires index parsing and storage redesign

---

## Testing Strategy

Create `tests/hangman_features.bas` to test each feature:
1. Test RND produces different values
2. Test ON...GOTO with various indices
3. Test DATA/READ/RESTORE cycle
4. Test TIME$ format
5. Test SPACE$ and TAB

Then test actual hangman.bas gameplay.

---

## Success Criteria

Hangman.bas should:
1. Display column selection prompt
2. Show hangman title screen
3. Load word list from DATA statements
4. Accept letter guesses
5. Display guessed letters
6. Show hangman graphics (if 2D arrays work)
7. Track wins/losses
8. Allow multiple games

---

## Notes

- Hangman uses advanced GW-BASIC features (graphics, sound, memory access)
- Some features (LOCATE, COLOR, CLS) are display-only and can be stubbed
- Core game logic depends on: RND, ON GOTO, DATA/READ
- With these 3 features, game should be playable (without graphics)

