10 REM Comprehensive Error Context Test
20 REM This program tests error context for various error types
30 PRINT "Error Context Test Suite"
40 PRINT "========================"
50 PRINT
60 REM Test 1: Array index out of bounds
70 PRINT "Test 1: Array index out of bounds"
80 DIM NUMS(3)
90 NUMS(5) = 100
100 REM Test 2: Undefined array access
110 PRINT "Test 2: Undefined array access"
120 UNDEFINED(0) = 200
130 REM Test 3: GOTO to undefined line
140 PRINT "Test 3: GOTO to undefined line"
150 GOTO 999
160 REM Test 4: Invalid FOR statement
170 PRINT "Test 4: Invalid FOR statement"
180 FOR INVALID
190 REM Test 5: Invalid LET statement
200 PRINT "Test 5: Invalid LET statement"
210 LET INVALID
220 END
