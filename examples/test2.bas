10 REM Advanced BASIC Test Program
20 REM Tests more complex functionality
30 PRINT "BASHIC Test Program 2"
40 PRINT "====================="
50 PRINT
60 REM Test arrays
70 DIM NUMS(5)
80 PRINT "Filling array with squares:"
90 FOR I = 1 TO 5
100   NUMS(I) = I * I
110   PRINT "NUMS("; I; ") ="; NUMS(I)
120 NEXT I
130 PRINT
140 REM Test WHILE loop
150 PRINT "WHILE loop countdown:"
160 LET COUNT = 5
170 WHILE COUNT > 0
180   PRINT COUNT;
190   COUNT = COUNT - 1
200 WEND
210 PRINT "Blast off!"
220 PRINT
230 REM Test GOSUB/RETURN
240 PRINT "Testing subroutines:"
250 GOSUB 400
260 GOSUB 450
270 PRINT
280 REM Test string functions
290 LET MSG$ = "BASIC Programming"
300 PRINT "Original string: "; MSG$
310 PRINT "Length: "; LEN(MSG$)
320 PRINT "First 5 chars: "; LEFT$(MSG$, 5)
330 PRINT "Last 11 chars: "; RIGHT$(MSG$, 11)
340 PRINT "Middle part: "; MID$(MSG$, 7, 7)
350 PRINT
360 REM Test input (commented out for automated testing)
370 REM PRINT "Enter your name: ";
380 REM INPUT NAME$
390 REM PRINT "Hello, "; NAME$; "!"
395 PRINT "Test 2 completed successfully!"
396 GOTO 500
400 REM Subroutine 1
410 PRINT "  This is subroutine 1"
420 RETURN
450 REM Subroutine 2
460 PRINT "  This is subroutine 2"
470 RETURN
500 END
