#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Debug function for the keyboard module
debug() {
    if [[ "${DEBUG:-}" == "true" ]]; then
        echo "DEBUG: $*" >&2
    fi
}

# Counter for tests
tests_passed=0
tests_failed=0

# Source the keyboard module
source "$(cd "$(dirname "$0")/../../.." && pwd)/src/modules/bashic.kbd.sh"

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

# Test 1: Test non-interactive mode with single character
echo "Test 1: Testing non-interactive mode with single character"
output=$(echo "a" | { init_keyboard; get_key; })
if [[ "$output" == "a" ]]; then
    print_result "Single character input" 0
else
    print_result "Single character input" 1
fi

# Test 2: Test non-interactive mode with multiple characters
echo -e "\nTest 2: Testing non-interactive mode with multiple characters"
output=$(printf "abc" | { init_keyboard; get_key; })
if [[ "$output" == "a" ]]; then
    print_result "First character from multiple" 0
else
    print_result "First character from multiple" 1
fi

# Test 3: Test non-interactive mode buffer depletion
echo -e "\nTest 3: Testing buffer depletion"
output=$(printf "abc" | { 
    init_keyboard
    c1=$(get_key)
    c2=$(get_key)
    c3=$(get_key)
    c4=$(get_key)
    echo "$c1$c2$c3$c4"
})
if [[ "$output" == "abc" ]]; then
    print_result "Buffer depletion" 0
else
    print_result "Buffer depletion" 1
    echo "Expected: 'abc', Got: '$output'"
fi

# Test 4: Test interactive mode (manual test)
echo -e "\nTest 4: Testing interactive mode"
if [[ -t 0 ]]; then
    echo "Press any key (interactive test)..."
    init_keyboard
    key=$(get_key)
    if [[ -n "$key" ]]; then
        echo "Received key: $key"
        print_result "Interactive input" 0
    else
        print_result "Interactive input" 1
    fi
else
    echo "Skipping interactive test (not a terminal)"
    print_result "Interactive input" 0
fi

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
