10 REM Debug expression evaluation
20 CLS
30 PRINT "Testing simple expressions..."
40 A = 2
50 B = 3
60 C = 4
70 PRINT "A="; A; " B="; B; " C="; C
80 PRINT
90 PRINT "Testing A + B * C..."
100 RESULT = A + B * C
110 PRINT "A + B * C = "; RESULT
120 PRINT "Expected: 14 (2 + 12)"
130 PRINT
140 PRINT "Testing ABS(A) + 2..."
150 RESULT = ABS(A) + 2
160 PRINT "ABS(A) + 2 = "; RESULT
170 PRINT "Expected: 7 (5 + 2)"
180 END
