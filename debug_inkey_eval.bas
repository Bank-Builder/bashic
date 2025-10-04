10 REM Debug INKEY$ evaluation
20 CLS
30 PRINT "Testing INKEY$ evaluation..."
40 PRINT "Calling INKEY$ directly..."
50 X$ = INKEY$
60 PRINT "INKEY$ returned: ["; X$; "]"
70 PRINT "Length: "; LEN(X$)
80 PRINT
90 PRINT "Testing in IF statement..."
100 IF INKEY$ = "" THEN PRINT "INKEY$ is empty" ELSE PRINT "INKEY$ is not empty"
110 END
