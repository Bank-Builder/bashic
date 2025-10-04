10 REM WHILE/WEND Loop Test Program
20 PRINT "Testing WHILE/WEND Loops"
30 PRINT "========================="
40 PRINT
50 REM Test basic WHILE loop
60 LET I = 1
70 PRINT "Counting up from 1 to 5:"
80 WHILE I <= 5
90   PRINT "I =", I
100   I = I + 1
110 WEND
120 PRINT "Final I =", I
130 PRINT
140 REM Test countdown WHILE loop  
150 LET COUNT = 3
160 PRINT "Countdown:"
170 WHILE COUNT > 0
180   PRINT COUNT;
190   COUNT = COUNT - 1
200 WEND
210 PRINT "Go!"
220 PRINT
230 REM Test nested WHILE loops
240 PRINT "Nested WHILE loops:"
250 LET X = 1
260 WHILE X <= 2
270   PRINT "Outer X =", X
280   LET Y = 1
290   WHILE Y <= 3
300     PRINT "  Inner Y =", Y
310     Y = Y + 1
320   WEND
330   X = X + 1
340 WEND
350 PRINT
360 PRINT "WHILE/WEND test completed!"
370 END
