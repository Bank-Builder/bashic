10 REM Test error conditions in nested contexts
20 PRINT "Testing Error Handling in Nested Loops"
30 PRINT "======================================"
40 PRINT
50 REM Test valid nested structure first
60 PRINT "Test 1: Valid nested structure"
70 FOR I = 1 TO 2
80   FOR J = 1 TO 2
90     PRINT "I="; I; "J="; J
100   NEXT J
110 NEXT I
120 PRINT "Valid structure: PASS"
130 PRINT
140 REM Test GOSUB/RETURN stack integrity
150 PRINT "Test 2: GOSUB/RETURN stack integrity"
160 FOR A = 1 TO 2
170   GOSUB 1000
180 NEXT A
190 PRINT "GOSUB stack integrity: PASS"
200 PRINT
210 PRINT "Error condition tests completed!"
220 END
230 REM
1000 REM Subroutine that tests nested calls
1010 PRINT "  In subroutine, A="; A
1020 IF A = 1 THEN GOSUB 2000
1030 RETURN
1040 REM
2000 REM Nested subroutine
2010 PRINT "    Nested subroutine call"
2020 RETURN
