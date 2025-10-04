#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counter for tests
tests_passed=0
tests_failed=0

# BASHIC interpreter path
BASHIC="$(cd "$(dirname "$0")/../.." && pwd)/bashic"

# Function to print test results
print_result() {
    local test_name=$1
    local result=$2
    if [ $result -eq 0 ]; then
        echo -e "${GREEN}✓ Test passed:${NC} $test_name"
        ((tests_passed++))
    else
        echo -e "${RED}✗ Test failed:${NC} $test_name"
        ((tests_failed++))
    fi
}

# Test 1: Check if BASHIC exists and is executable
echo "Test 1: Checking if BASHIC exists and is executable"
if [ -x "$BASHIC" ]; then
    print_result "BASHIC exists and is executable" 0
else
    print_result "BASHIC exists and is executable" 1
    exit 1
fi

# Test 2: Test single keypress
echo -e "\nTest 2: Testing single keypress"
cat > test_single.bas << 'EOF'
10 K$ = INKEY$
20 IF K$ = "" THEN GOTO 10
30 PRINT "Key:"; K$
40 END
EOF

printf "x" | $BASHIC test_single.bas > test_output.tmp 2>/dev/null
output=$(cat test_output.tmp)
if [[ $output == *"Key:x"* ]]; then
    print_result "Single key input test" 0
else
    print_result "Single key input test" 1
fi

# Test 3: Test multiple keypresses
echo -e "\nTest 3: Testing multiple keypresses"
cat > test_multi.bas << 'EOF'
10 K$ = ""
20 FOR I = 1 TO 3
30   X$ = INKEY$
40   IF X$ = "" THEN GOTO 30
50   K$ = K$ + X$
60 NEXT I
70 PRINT "Keys:"; K$
80 END
EOF

printf "abc" | $BASHIC test_multi.bas > test_output.tmp 2>/dev/null
output=$(cat test_output.tmp)
if [[ $output == *"Keys:abc"* ]]; then
    print_result "Multiple key input test" 0
else
    print_result "Multiple key input test" 1
fi

# Test 4: Test ESC key detection
echo -e "\nTest 4: Testing ESC key detection"
cat > test_esc.bas << 'EOF'
10 K$ = INKEY$
20 IF K$ = "" THEN GOTO 10
30 IF ASC(K$) = 27 THEN PRINT "ESC" ELSE PRINT "Not ESC"
40 END
EOF

printf "\x1B" | $BASHIC test_esc.bas > test_output.tmp 2>/dev/null
output=$(cat test_output.tmp)
if [[ $output == *"ESC"* ]]; then
    print_result "ESC key detection test" 0
else
    print_result "ESC key detection test" 1
fi

# Test 5: Test empty input timeout
echo -e "\nTest 5: Testing empty input timeout"
cat > test_timeout.bas << 'EOF'
10 T = 0
20 K$ = INKEY$
30 IF K$ <> "" THEN PRINT "Got key"; : END
40 T = T + 1
50 IF T < 10 THEN GOTO 20
60 PRINT "Timeout"
70 END
EOF

printf "" | $BASHIC test_timeout.bas > test_output.tmp 2>/dev/null
output=$(cat test_output.tmp)
if [[ $output == *"Timeout"* ]]; then
    print_result "Empty input timeout test" 0
else
    print_result "Empty input timeout test" 1
fi

# Clean up temporary files
rm -f test_*.bas test_output.tmp

# Print final results
echo -e "\nTest Summary:"
echo "Tests passed: $tests_passed"
echo "Tests failed: $tests_failed"

# Exit with status based on test results
if [ $tests_failed -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi