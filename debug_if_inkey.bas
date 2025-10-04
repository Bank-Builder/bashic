10 REM Debug INKEY$ test
20 CLS
30 PRINT "Testing INKEY$ in IF statement..."
40 PRINT "About to test IF INKEY$ = '' THEN GOTO 40"
50 IF INKEY$ = "" THEN GOTO 50
60 PRINT "Key detected!"
70 END
