10 REM Debug INKEY$ space bar issue
20 PRINT "Press SPACE BAR to continue..."
30 CMD$=INKEY$
40 PRINT "You pressed: '"; CMD$; "'"
50 PRINT "Length: "; LEN(CMD$)
60 IF CMD$<>" " THEN PRINT "Not a space!" ELSE PRINT "It's a space!"
70 END
