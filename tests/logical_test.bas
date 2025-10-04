10 REM Test AND/OR logical operators
20 PRINT "Testing AND/OR Logical Operators"
30 PRINT "================================"
40 PRINT
50 REM Test AND operator
60 PRINT "Testing AND operator:"
70 LET A = 5
80 LET B = 10
90 IF A > 3 AND B > 8 THEN PRINT "Both conditions true"
100 IF A > 3 AND B > 15 THEN PRINT "Should not print" ELSE PRINT "AND works correctly"
110 PRINT
120 REM Test OR operator  
130 PRINT "Testing OR operator:"
140 IF A = 5 OR B = 15 THEN PRINT "At least one condition true"
150 IF A = 1 OR B = 1 THEN PRINT "Should not print" ELSE PRINT "OR works correctly"
160 PRINT
170 REM Test in WHILE loop
180 PRINT "Testing logical operators in WHILE:"
190 LET I = 1
200 WHILE I <= 3 AND I > 0
210   PRINT "WHILE with AND: I =", I
220   LET I = I + 1
230 WEND
240 PRINT
250 LET J = 1
260 WHILE J = 1 OR J = 2
270   PRINT "WHILE with OR: J =", J
280   LET J = J + 1
290   IF J > 2 THEN LET J = 5
300 WEND
310 PRINT
320 PRINT "Logical operator tests completed!"
330 END
