10 REM Test String Comparisons in Control Structures
20 PRINT "Testing String Comparisons in Control Structures"
30 PRINT "==============================================="
40 PRINT
50 LET A$ = "hello"
60 LET B$ = "world"
70 LET C$ = "test"
80 PRINT "Variables: A$ =", A$, "B$ =", B$, "C$ =", C$
90 PRINT
100 REM Test IF statements with string comparisons
110 PRINT "Test 1: IF statements with string comparisons"
120 IF A$ = "hello" THEN PRINT "IF: A$ = \"hello\" is TRUE"
130 IF A$ <> B$ THEN PRINT "IF: A$ <> B$ is TRUE"
140 IF A$ < B$ THEN PRINT "IF: A$ < B$ is TRUE (hello < world)"
150 IF B$ > A$ THEN PRINT "IF: B$ > A$ is TRUE (world > hello)"
160 PRINT
170 REM Test WHILE loops with string comparisons
180 PRINT "Test 2: WHILE loops with string comparisons"
190 LET I$ = "a"
200 WHILE I$ <= "c"
210   PRINT "WHILE: I$ =", I$
220   IF I$ = "a" THEN LET I$ = "b"
230   IF I$ = "b" THEN LET I$ = "c"
240 WEND
260 PRINT
270 REM Test complex string conditions with logical operators
280 PRINT "Test 3: Complex string conditions with logical operators"
290 IF A$ = "hello" AND A$ <> "world" THEN PRINT "Complex: A$ = \"hello\" AND A$ <> \"world\" is TRUE"
300 IF A$ < "z" OR A$ > "a" THEN PRINT "Complex: A$ < \"z\" OR A$ > \"a\" is TRUE"
310 IF NOT A$ = "test" THEN PRINT "Complex: NOT A$ = \"test\" is TRUE"
320 PRINT
330 REM Test nested string comparisons
340 PRINT "Test 4: Nested string comparisons"
350 IF A$ = "hello" THEN
360   IF B$ <> "hello" THEN PRINT "Nested: A$ = \"hello\" AND B$ <> \"hello\" is TRUE"
370   IF A$ < B$ THEN PRINT "Nested: A$ = \"hello\" AND A$ < B$ is TRUE"
380 END IF
390 PRINT
400 PRINT "String comparison control structure tests completed!"
410 END
