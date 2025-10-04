10 REM Test String Comparison Operators
20 PRINT "Testing String Comparison Operators"
30 PRINT "==================================="
40 PRINT
50 LET A$ = "apple"
60 LET B$ = "banana"
70 LET C$ = "cat"
80 LET D$ = "dog"
90 LET E$ = "zebra"
100 PRINT "Variables: A$ =", A$, "B$ =", B$, "C$ =", C$, "D$ =", D$, "E$ =", E$
110 PRINT
120 REM Test equality
130 PRINT "Test 1: String Equality"
140 IF A$ = "apple" THEN PRINT "A$ = \"apple\": TRUE"
150 IF C$ = C$ THEN PRINT "C$ = C$: TRUE"
160 IF A$ = B$ THEN PRINT "Should not print" ELSE PRINT "A$ = B$: FALSE"
170 PRINT
180 REM Test inequality
190 PRINT "Test 2: String Inequality"
200 IF A$ <> B$ THEN PRINT "A$ <> B$: TRUE"
210 IF C$ <> "cat" THEN PRINT "Should not print" ELSE PRINT "C$ <> \"cat\": FALSE"
220 PRINT
230 REM Test less than
240 PRINT "Test 3: String Less Than"
250 IF A$ < B$ THEN PRINT "A$ < B$: TRUE (apple < banana)"
260 IF C$ < "dog" THEN PRINT "C$ < \"dog\": TRUE (cat < dog)"
270 IF E$ < A$ THEN PRINT "Should not print" ELSE PRINT "E$ < A$: FALSE (zebra < apple)"
280 PRINT
290 REM Test greater than
300 PRINT "Test 4: String Greater Than"
310 IF B$ > A$ THEN PRINT "B$ > A$: TRUE (banana > apple)"
320 IF E$ > A$ THEN PRINT "E$ > A$: TRUE (zebra > apple)"
330 IF A$ > B$ THEN PRINT "Should not print" ELSE PRINT "A$ > B$: FALSE (apple > banana)"
340 PRINT
350 REM Test less than or equal
360 PRINT "Test 5: String Less Than or Equal"
370 IF A$ <= B$ THEN PRINT "A$ <= B$: TRUE (apple <= banana)"
380 IF C$ <= C$ THEN PRINT "C$ <= C$: TRUE (cat <= cat)"
390 IF E$ <= A$ THEN PRINT "Should not print" ELSE PRINT "E$ <= A$: FALSE (zebra <= apple)"
400 PRINT
410 REM Test greater than or equal
420 PRINT "Test 6: String Greater Than or Equal"
430 IF B$ >= A$ THEN PRINT "B$ >= A$: TRUE (banana >= apple)"
440 IF C$ >= C$ THEN PRINT "C$ >= C$: TRUE (cat >= cat)"
450 IF A$ >= B$ THEN PRINT "Should not print" ELSE PRINT "A$ >= B$: FALSE (apple >= banana)"
460 PRINT
470 PRINT "String comparison operator tests completed!"
480 END
