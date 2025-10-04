10 REM Conditional Control in Nested Loops
20 PRINT "Testing Conditional Control in Loops"
30 PRINT "===================================="
40 PRINT
50 REM Test 1: IF/THEN/ELSE inside FOR loop
60 PRINT "Test 1: IF/THEN/ELSE inside FOR"
70 FOR I = 1 TO 5
80   IF I MOD 2 = 0 THEN PRINT I; "even" ELSE PRINT I; "odd"
90 NEXT I
100 PRINT
110 REM Test 2: IF controlling WHILE loop
120 PRINT "Test 2: IF controlling WHILE"
130 LET J = 1
140 WHILE J <= 4
150   IF J = 3 THEN PRINT "Skip 3" ELSE PRINT "Value:", J
160   LET J = J + 1
170 WEND
180 PRINT
190 REM Test 3: Nested FOR with conditional breaks using GOTO
200 PRINT "Test 3: Conditional control flow"
210 FOR OUTER = 1 TO 3
220   FOR INNER = 1 TO 3
230     IF OUTER = 2 AND INNER = 2 THEN GOTO 300
240     PRINT "O="; OUTER; "I="; INNER
250   NEXT INNER
260 NEXT OUTER
270 PRINT "Should not reach here"
280 GOTO 400
290 REM
300 PRINT "Jumped out at OUTER=2, INNER=2"
310 REM
400 PRINT "Conditional control tests completed!"
410 END
