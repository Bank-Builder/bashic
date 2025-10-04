10 REM Simple BASIC Test Program
20 REM Tests basic functionality
30 PRINT "BASHIC Test Program 1"
40 PRINT "====================="
50 PRINT
60 REM Test variables and arithmetic
70 LET A = 10
80 LET B = 5
90 PRINT "A =", A
100 PRINT "B =", B
110 PRINT "A + B =", A + B
120 PRINT "A - B =", A - B
130 PRINT "A * B =", A * B
140 PRINT "A / B =", A / B
150 PRINT
160 REM Test string variables
170 LET A$ = "Hello"
180 LET B$ = "World"
190 PRINT A$, B$
200 PRINT
210 REM Test FOR loop
220 PRINT "Counting from 1 to 5:"
230 FOR I = 1 TO 5
240   PRINT I;
250 NEXT I
260 PRINT
270 PRINT
280 REM Test IF statement
290 LET X = 7
300 IF X > 5 THEN PRINT "X is greater than 5"
310 IF X < 10 THEN PRINT "X is less than 10"
320 PRINT
330 REM Test mathematical functions
340 PRINT "Mathematical functions:"
350 PRINT "ABS(-5) =", ABS(-5)
360 PRINT "INT(3.7) =", INT(3.7)
370 PRINT "SQR(16) =", SQR(16)
380 PRINT
390 PRINT "Test 1 completed successfully!"
400 END
