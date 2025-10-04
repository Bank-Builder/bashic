10 REM GOSUB Integration with Nested Loops
20 PRINT "Testing GOSUB with Nested Loops"
30 PRINT "==============================="
40 PRINT
50 REM Test 1: GOSUB from within nested loops
60 PRINT "Test 1: GOSUB from nested loops"
70 FOR I = 1 TO 2
80   FOR J = 1 TO 2
90     PRINT "Before GOSUB I="; I; "J="; J
100     GOSUB 1000
110     PRINT "After GOSUB I="; I; "J="; J
120   NEXT J
130 NEXT I
140 PRINT
150 REM Test 2: Subroutine with its own nested loops
160 PRINT "Test 2: Subroutine with nested loops"
170 GOSUB 2000
180 PRINT
190 PRINT "GOSUB nested tests completed!"
200 END
210 REM
1000 REM Subroutine called from nested loops
1010 PRINT "  In subroutine"
1020 RETURN
1030 REM
2000 REM Subroutine with its own nested structure
2010 PRINT "Subroutine with nested loops:"
2020 FOR A = 1 TO 2
2030   LET B = 1
2040   WHILE B <= 2
2050     PRINT "  Sub: A="; A; "B="; B
2060     LET B = B + 1
2070   WEND
2080 NEXT A
2090 RETURN
