10 REM Complex Three-Level Nested Control Structures
20 PRINT "Testing Complex Nested Structures"
30 PRINT "================================="
40 PRINT
50 REM Test 1: FOR/WHILE/IF triple nesting
60 PRINT "Test 1: FOR/WHILE/IF nesting"
70 FOR LEVEL1 = 1 TO 2
80   PRINT "Level 1:", LEVEL1
90   LET LEVEL2 = 1
100   WHILE LEVEL2 <= 2
110     PRINT "  Level 2:", LEVEL2
120     FOR LEVEL3 = 1 TO 2
130       IF LEVEL3 = 1 THEN PRINT "    First" ELSE PRINT "    Second"
140     NEXT LEVEL3
150     LET LEVEL2 = LEVEL2 + 1
160   WEND
170 NEXT LEVEL1
180 PRINT
190 REM Test 2: WHILE/FOR/GOSUB with deep nesting
200 PRINT "Test 2: WHILE/FOR/GOSUB nesting"
210 LET OUTER_COUNT = 1
220 WHILE OUTER_COUNT <= 2
230   PRINT "WHILE outer:", OUTER_COUNT
240   FOR MIDDLE = 1 TO 2
250     PRINT "  FOR middle:", MIDDLE
260     IF MIDDLE = 2 THEN GOSUB 1000
270   NEXT MIDDLE
280   LET OUTER_COUNT = OUTER_COUNT + 1
290 WEND
300 PRINT
310 REM Test 3: Stack stress test
320 PRINT "Test 3: Stack stress test"
330 FOR A = 1 TO 3
340   FOR B = 1 TO 2
350     LET C = 1
360     WHILE C <= 2
370       FOR D = 1 TO 2
380         IF A = 2 AND B = 1 AND C = 1 AND D = 1 THEN GOSUB 2000
390       NEXT D
400       LET C = C + 1
410     WEND
420   NEXT B
430 NEXT A
440 PRINT
450 PRINT "Complex nested tests completed successfully!"
460 END
470 REM
1000 REM Subroutine called from nested context
1010 PRINT "    GOSUB from nested loops"
1020 RETURN
1030 REM
2000 REM Deep subroutine call
2010 PRINT "      Deep GOSUB: A="; A; "B="; B; "C="; C; "D="; D
2020 RETURN
