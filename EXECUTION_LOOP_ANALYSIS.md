# Execution Loop Analysis

## The Problem

The execution loop has a fundamental issue with how it handles control flow statements.

## Current Behavior (BROKEN)

```bash
while RUNNING:
    stmt = PROGRAM_LINES[CURRENT_LINE]
    execute_statement(stmt)
    CURRENT_LINE = find_next_line(CURRENT_LINE)  # Always finds NEXT line
```

### Why This Breaks GOTO

```basic
10 PRINT "A"
20 GOTO 100
30 PRINT "B"
100 PRINT "C"
```

Trace:
1. Execute line 20: GOTO 100 → sets CURRENT_LINE=100
2. Loop calls find_next_line(100) → returns 110
3. Line 100 is SKIPPED!

### Why This Breaks ON...GOTO

Same issue - ON GOTO sets line, then find_next_line skips it.

## Previous Attempt (Also BROKEN)

```bash
while RUNNING:
    saved_line = CURRENT_LINE
    execute_statement(PROGRAM_LINES[CURRENT_LINE])
    if CURRENT_LINE == saved_line:  # Line didn't change
        CURRENT_LINE = find_next_line(CURRENT_LINE)
    # else: use changed CURRENT_LINE as-is
```

### Why This Breaks FOR/NEXT

```basic
10 FOR I = 1 TO 3
20   PRINT I
30 NEXT I
```

Trace:
1. Execute line 10 (FOR) → pushes stack, doesn't change CURRENT_LINE
2. Line unchanged, so find_next_line(10) → line 20
3. Execute line 20 (PRINT)
4. Execute line 30 (NEXT) → sets CURRENT_LINE=10 (FOR line)
5. CURRENT_LINE changed (30→10), so DON'T call find_next_line
6. Next iteration: Execute line 10 (FOR) AGAIN
7. FOR pushes ANOTHER loop onto stack → infinite nested loops!

## The Core Issue

**GOTO/ON GOTO** need:
- Set CURRENT_LINE to target
- NEXT iteration should execute that target line

**FOR/NEXT** need:
- NEXT sets CURRENT_LINE to FOR line
- NEXT iteration should execute line AFTER FOR (not FOR itself)

These requirements conflict!

## Solution Options

### Option 1: Track Line Change Intent
Add a flag indicating whether to execute the new line or advance from it.

### Option 2: Fix NEXT to Jump Past FOR
NEXT should set CURRENT_LINE to the line AFTER the FOR, not the FOR line itself.

### Option 3: Have FOR Check for Re-entry
FOR should detect if already in a loop and not push another context.

### Option 4: Two-Phase Execution
- Phase 1: Execute current line
- Phase 2: Determine next line based on what was executed

## Recommended Solution

**Option 2** - Fix NEXT to jump to the line AFTER FOR.

This is cleanest because:
- GOTO sets target line, next iteration executes it ✓
- NEXT sets line after FOR, loop body executes ✓
- No special tracking needed
- Aligns with actual BASIC semantics

Implementation:
- FOR stores its own line number in stack
- NEXT retrieves that line, then calls find_next_line() to get the line AFTER it
- Sets CURRENT_LINE to that next line

This way:
- NEXT at line 30 → find_next_line(10) → 20 → CURRENT_LINE=20
- Loop calls find_next_line(20) → 30
- Back to NEXT, cycle repeats

## Code Changes Needed

In `execute_next()`:
```bash
if continue_loop:
    # Don't jump to FOR line, jump to line AFTER it
    next_line_after_for = find_next_line(for_line)
    CURRENT_LINE = next_line_after_for
```

Same pattern needed for WHILE/WEND.

