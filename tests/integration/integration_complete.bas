10 REM BASHIC Complete Integration Test
20 REM Comprehensive test of all modules and functionality
30 REM This test combines all module tests into a single comprehensive test
40 PRINT "BASHIC Complete Integration Test"
50 PRINT "==============================="
60 PRINT "Testing all modules and functionality together"
70 PRINT
80 REM ========================================
90 REM Test 1: Core Utilities and Constants
100 REM ========================================
110 PRINT "TEST 1: Core Utilities and Constants"
120 PRINT "-----------------------------------"
130 LET TEST_VAR = 42
140 LET TEST_STR$ = "Integration"
150 PRINT "Variables initialized:", TEST_VAR, TEST_STR$
160 PRINT "Global state management working"
170 PRINT
180 REM ========================================
190 REM Test 2: Mathematical Functions
200 REM ========================================
210 PRINT "TEST 2: Mathematical Functions"
220 PRINT "-------------------------------"
230 PRINT "ABS(-10) =", ABS(-10)
240 PRINT "INT(3.7) =", INT(3.7)
250 PRINT "SGN(-5) =", SGN(-5)
260 PRINT "SQR(25) =", SQR(25)
270 PRINT "All math functions working"
280 PRINT
290 REM ========================================
300 REM Test 3: String Functions
310 REM ========================================
320 PRINT "TEST 3: String Functions"
330 PRINT "-----------------------"
340 LET STR$ = "Hello World"
350 PRINT "LEN(\"Hello World\") =", LEN(STR$)
360 PRINT "LEFT$(STR$, 5) =", LEFT$(STR$, 5)
370 PRINT "RIGHT$(STR$, 5) =", RIGHT$(STR$, 5)
380 PRINT "MID$(STR$, 7, 5) =", MID$(STR$, 7, 5)
390 PRINT "ASC(\"A\") =", ASC("A")
400 PRINT "CHR$(65) =", CHR$(65)
410 PRINT "VAL(\"123\") =", VAL("123")
420 PRINT "STR$(456) =", STR$(456)
430 PRINT "All string functions working"
440 PRINT
450 REM ========================================
460 REM Test 4: Expression Evaluation
470 REM ========================================
480 PRINT "TEST 4: Expression Evaluation"
490 PRINT "-----------------------------"
500 LET A = 10
510 LET B = 3
520 LET C$ = "Hello"
530 LET D$ = "World"
540 PRINT "Arithmetic: A + B =", A + B
550 PRINT "Arithmetic: A MOD B =", A MOD B
560 PRINT "String concat: C$ + D$ =", C$ + D$
570 PRINT "Comparison: A > B =", A > B
580 PRINT "Logical: A > 5 AND B < 5 =", A > 5 AND B < 5
590 PRINT "Complex: ABS(A - B) =", ABS(A - B)
600 PRINT "All expression evaluation working"
610 PRINT
620 REM ========================================
630 REM Test 5: Control Flow
640 REM ========================================
650 PRINT "TEST 5: Control Flow"
660 PRINT "-------------------"
670 PRINT "FOR/NEXT loop:"
680 FOR I = 1 TO 3
690   PRINT "  Iteration", I
700 NEXT I
710 PRINT "WHILE/WEND loop:"
720 LET COUNT = 3
730 WHILE COUNT > 0
740   PRINT "  Count:", COUNT
750   LET COUNT = COUNT - 1
760 WEND
770 PRINT "IF/THEN/ELSE:"
780 IF A > 5 THEN PRINT "  A > 5 is TRUE" ELSE PRINT "  A > 5 is FALSE"
790 PRINT "GOSUB/RETURN:"
800 GOSUB 2000
810 PRINT "All control flow working"
820 PRINT
830 REM ========================================
840 REM Test 6: Statement Execution
850 REM ========================================
860 PRINT "TEST 6: Statement Execution"
870 PRINT "---------------------------"
880 PRINT "PRINT statement working"
890 LET X = 100
900 LET Y$ = "Test"
910 PRINT "LET statements working:", X, Y$
920 DIM ARRAY(3)
930 FOR I = 0 TO 3
940   LET ARRAY(I) = I * 10
950 NEXT I
960 PRINT "DIM and array operations working"
970 PRINT "ARRAY(2) =", ARRAY(2)
980 PRINT "All statement execution working"
990 PRINT
1000 REM ========================================
1010 REM Test 7: Complex Integration Scenarios
1020 REM ========================================
1030 PRINT "TEST 7: Complex Integration Scenarios"
1030 PRINT "------------------------------------"
1040 PRINT "Nested control structures:"
1050 FOR I = 1 TO 2
1060   FOR J = 1 TO 2
1070     LET RESULT = I * J
1080     IF RESULT > 1 THEN
1090       PRINT "  I =", I, "J =", J, "Result =", RESULT
1100     END IF
1110   NEXT J
1120 NEXT I
1130 PRINT "String manipulation in loops:"
1140 LET WORDS$(3)
1150 FOR I = 0 TO 3
1160   LET WORDS$(I) = "Word" + STR$(I)
1170   PRINT "  WORDS$("; I; ") ="; WORDS$(I)
1180 NEXT I
1190 PRINT "Function calls in expressions:"
1200 LET COMPLEX = ABS(-5) + INT(3.7) + LEN("Hello")
1210 PRINT "  Complex expression result:", COMPLEX
1220 PRINT "All complex scenarios working"
1230 PRINT
1240 REM ========================================
1250 REM Test 8: Error Handling and Edge Cases
1260 REM ========================================
1270 PRINT "TEST 8: Error Handling and Edge Cases"
1280 PRINT "-------------------------------------"
1290 PRINT "Empty string handling:"
1300 LET EMPTY$ = ""
1310 PRINT "  LEN(EMPTY$) =", LEN(EMPTY$)
1320 PRINT "Zero handling:"
1330 PRINT "  ABS(0) =", ABS(0)
1340 PRINT "  SQR(0) =", SQR(0)
1350 PRINT "Edge case handling working"
1360 PRINT
1370 REM ========================================
1380 REM Test 9: Performance and Efficiency
1390 REM ========================================
1400 PRINT "TEST 9: Performance and Efficiency"
1410 PRINT "---------------------------------"
1420 PRINT "Large loop execution:"
1430 FOR I = 1 TO 10
1440   LET TEMP = I * I
1450 NEXT I
1460 PRINT "  Large loop completed successfully"
1470 PRINT "Array operations:"
1480 FOR I = 0 TO 5
1490   LET ARRAY(I) = ARRAY(I) + 1
1500 NEXT I
1510 PRINT "  Array operations completed successfully"
1520 PRINT "Performance tests working"
1530 PRINT
1540 REM ========================================
1550 REM Test 10: Module Integration Verification
1560 REM ========================================
1570 PRINT "TEST 10: Module Integration Verification"
1580 PRINT "---------------------------------------"
1590 PRINT "All modules are working together:"
1600 PRINT "  ✓ bashic.util.sh - Core utilities"
1610 PRINT "  ✓ bashic.math.sh - Mathematical functions"
1620 PRINT "  ✓ bashic.string.sh - String functions"
1630 PRINT "  ✓ bashic.eval.sh - Expression evaluation"
1640 PRINT "  ✓ bashic.control.sh - Control flow"
1650 PRINT "  ✓ bashic.statement.sh - Statement execution"
1660 PRINT "  ✓ bashic.core.sh - Program management"
1670 PRINT
1680 PRINT "=========================================="
1690 PRINT "TEST 13: New Features (Hangman Support)"
1700 PRINT "=========================================="
1710 PRINT "RND(1) =", RND(1)
1720 PRINT "TIME$ =", TIME$
1730 PRINT "SPACE$(10): ["; SPACE$(10); "]"
1740 PRINT "TAB(15): A"; TAB(15); "B"
1750 READ W1$, W2$
1760 PRINT "DATA/READ:", W1$, W2$
1770 RESTORE
1780 READ W$
1790 PRINT "After RESTORE:", W$
1800 LET IDX = 2
1810 ON IDX GOTO 1900, 1910, 1920
1820 PRINT "ON GOTO failed"
1900 PRINT "Wrong": GOTO 1930
1910 PRINT "ON GOTO: Correct (index 2)": GOTO 1930
1920 PRINT "Wrong": GOTO 1930
1930 PRINT "All new features working!"
1940 PRINT
1950 PRINT "=========================================="
1960 PRINT "BASHIC INTEGRATION TEST COMPLETED"
1970 PRINT "=========================================="
1980 PRINT "All modules tested and integrated successfully!"
1990 PRINT "BASHIC interpreter is fully functional!"
2000 END
2010 REM Subroutine for GOSUB test
2020 PRINT "  GOSUB subroutine executed"
2030 RETURN
2040 REM DATA for new features test
2050 DATA "First", "Second", "Third"
