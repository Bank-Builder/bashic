10 REM BASHIC INPUT Statement Examples
20 REM Demonstrates INPUT functionality and BASHIC_UPPER_CASE
30 PRINT "BASHIC INPUT Statement Test"
40 PRINT "==========================="
50 PRINT
60 REM Test 1: Simple INPUT
70 PRINT "Test 1: Simple INPUT"
80 INPUT "Enter your name: ", NAME$
90 PRINT "Hello, "; NAME$; "!"
100 PRINT
110 REM Test 2: Numeric INPUT
120 PRINT "Test 2: Numeric INPUT"
130 INPUT "Enter your age: ", AGE
140 PRINT "You are "; AGE; " years old"
150 PRINT
160 REM Test 3: Multiple variables
170 PRINT "Test 3: Multiple variables (comma-separated)"
180 INPUT "Enter X, Y, Z: ", X, Y, Z
190 PRINT "X ="; X; ", Y ="; Y; ", Z ="; Z
200 PRINT
210 REM Test 4: Uppercase mode (like GW-BASIC CAPS LOCK)
220 PRINT "Test 4: Uppercase mode"
230 PRINT "Enabling BASHIC_UPPER_CASE..."
240 BASHIC_UPPER_CASE = 1
250 INPUT "Enter a sentence (will be UPPERCASE): ", TEXT$
260 PRINT "You entered: "; TEXT$
270 PRINT
280 REM Test 5: Disable uppercase
290 BASHIC_UPPER_CASE = 0
300 PRINT "Test 5: Normal mode restored"
310 INPUT "Enter another sentence: ", TEXT2$
320 PRINT "You entered: "; TEXT2$
330 PRINT
340 PRINT "All INPUT tests completed!"
350 END

