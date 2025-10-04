10 REM Test MOD operator implementation
20 PRINT "Testing MOD operator"
30 PRINT "==================="
40 PRINT
50 REM Test basic MOD operations
60 PRINT "Basic MOD tests:"
70 PRINT "10 MOD 3 =", 10 MOD 3
80 PRINT "7 MOD 2 =", 7 MOD 2
90 PRINT "8 MOD 4 =", 8 MOD 4
100 PRINT "5 MOD 5 =", 5 MOD 5
110 PRINT
120 REM Test MOD with variables
130 LET A = 15
140 LET B = 4
150 PRINT "Variables: A=", A, "B=", B
160 PRINT "A MOD B =", A MOD B
170 PRINT
180 REM Test MOD in conditions (even/odd detection)
190 PRINT "Even/odd detection:"
200 FOR I = 1 TO 6
210   IF I MOD 2 = 0 THEN PRINT I; "is even" ELSE PRINT I; "is odd"
220 NEXT I
230 PRINT
240 PRINT "MOD test completed!"
250 END
