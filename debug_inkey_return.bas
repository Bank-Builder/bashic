10 REM Debug what INKEY$ returns
20 CLS
30 PRINT "Testing what INKEY$ returns..."
40 X$ = INKEY$
50 PRINT "INKEY$ returned: ["; X$; "]"
60 PRINT "Length: "; LEN(X$)
70 PRINT "ASCII codes: ";
80 FOR I = 1 TO LEN(X$)
90 PRINT ASC(MID$(X$, I, 1)); " ";
100 NEXT I
110 PRINT
120 END
