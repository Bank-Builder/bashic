10 REM Basic Nested Control Loop Tests
20 PRINT "Testing Basic Nested Control Loops"
30 PRINT "=================================="
40 PRINT
50 REM Test 1: FOR inside FOR (multiplication table)
60 PRINT "Test 1: Nested FOR loops (2x2 table)"
70 FOR I = 1 TO 2
80   FOR J = 1 TO 2
90     PRINT I; "x"; J; "="; I * J
100   NEXT J
110 NEXT I
120 PRINT
130 REM Test 2: WHILE inside WHILE
140 PRINT "Test 2: Nested WHILE loops"
150 LET OUTER = 1
160 WHILE OUTER <= 2
170   PRINT "Outer:", OUTER
180   LET INNER = 1
190   WHILE INNER <= 2
200     PRINT "  Inner:", INNER
210     LET INNER = INNER + 1
220   WEND
230   LET OUTER = OUTER + 1
240 WEND
250 PRINT
260 REM Test 3: FOR inside WHILE
270 PRINT "Test 3: FOR inside WHILE"
280 LET COUNT = 1
290 WHILE COUNT <= 2
300   PRINT "WHILE iteration:", COUNT
310   FOR K = 1 TO 3
320     PRINT "  FOR K =", K
330   NEXT K
340   LET COUNT = COUNT + 1
350 WEND
360 PRINT
370 REM Test 4: WHILE inside FOR
380 PRINT "Test 4: WHILE inside FOR"
390 FOR M = 1 TO 2
400   PRINT "FOR M =", M
410   LET N = 1
420   WHILE N <= 2
430     PRINT "  WHILE N =", N
440     LET N = N + 1
450   WEND
460 NEXT M
470 PRINT
480 PRINT "Basic nested tests completed successfully!"
490 END
