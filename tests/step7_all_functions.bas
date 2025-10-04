10 REM Test all multi-parameter functions
20 LET TEST$ = "PROGRAMMING"
30 PRINT "Original:", TEST$
40 LET L$ = LEFT$(TEST$, 4)
50 PRINT "LEFT$(4):", L$
60 LET R$ = RIGHT$(TEST$, 3)
70 PRINT "RIGHT$(3):", R$
80 LET M$ = MID$(TEST$, 3, 4)
90 PRINT "MID$(3,4):", M$
100 PRINT "ASC('A'):", ASC("A")
110 PRINT "CHR$(65):", CHR$(65)
120 PRINT "VAL('123'):", VAL("123")
130 END
