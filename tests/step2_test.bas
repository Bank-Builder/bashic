10 LET A$ = "HELLO"
20 LET B = 42
30 REM This should work (no function calls)
40 PRINT A$, B
50 REM This should work (assignment first)
60 LET RESULT$ = LEFT$(A$, 2)
70 PRINT RESULT$
80 END
