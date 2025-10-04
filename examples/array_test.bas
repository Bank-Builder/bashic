10 REM Array Test Program
20 PRINT "Testing DIM and Array Operations"
30 PRINT "================================"
40 PRINT
50 REM Test array declaration and assignment
60 DIM NUMS(3)
70 NUMS(0) = 10
80 NUMS(1) = 20
90 NUMS(2) = 30
100 NUMS(3) = 40
110 PRINT
120 REM Test array access
130 PRINT "Array values:"
140 PRINT "NUMS(0) =", NUMS(0)
150 PRINT "NUMS(1) =", NUMS(1)
160 PRINT "NUMS(2) =", NUMS(2)
170 PRINT "NUMS(3) =", NUMS(3)
180 PRINT
190 REM Test with expressions
200 FOR I = 0 TO 3
210   PRINT "NUMS("; I; ") ="; NUMS(I)
220 NEXT I
230 PRINT
240 PRINT "Array test completed successfully!"
250 END
