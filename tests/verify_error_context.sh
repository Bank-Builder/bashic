#!/bin/bash

# Error Context Verification Script
# This script tests that error messages include proper context

echo "Error Context Verification Script"
echo "================================"
echo

# Test 1: Array index out of bounds
echo "Test 1: Array index out of bounds"
if ./bashic tests/error_context_test.bas 2>&1 | grep -q "line 90: NUMS(5) = 100"; then
    echo "  PASS: Error context includes line number and program content"
else
    echo "  FAIL: Error context missing or incorrect"
    exit 1
fi
echo

# Test 2: Undefined array access
echo "Test 2: Undefined array access"
if ./bashic tests/error_context_test2.bas 2>&1 | grep -q "line 30: UNDEFINED(0) = 100"; then
    echo "  PASS: Error context includes line number and program content"
else
    echo "  FAIL: Error context missing or incorrect"
    exit 1
fi
echo

# Test 3: GOTO to undefined line
echo "Test 3: GOTO to undefined line"
if ./bashic tests/error_context_test3.bas 2>&1 | grep -q "line 30: GOTO 999"; then
    echo "  PASS: Error context includes line number and program content"
else
    echo "  FAIL: Error context missing or incorrect"
    exit 1
fi
echo

# Test 4: Invalid FOR statement
echo "Test 4: Invalid FOR statement"
if ./bashic tests/error_context_test4.bas 2>&1 | grep -q "line 30: FOR INVALID"; then
    echo "  PASS: Error context includes line number and program content"
else
    echo "  FAIL: Error context missing or incorrect"
    exit 1
fi
echo

# Test 5: Invalid DIM statement (pre-parsing error)
echo "Test 5: Invalid DIM statement"
if ./bashic tests/error_context_test5.bas 2>&1 | grep -q "Line 30: Invalid DIM statement"; then
    echo "  PASS: Error context includes line number (pre-parsing error)"
else
    echo "  FAIL: Error context missing or incorrect"
    exit 1
fi
echo

echo "ALL ERROR CONTEXT TESTS PASSED!"
echo "Error messages properly include line numbers and program content."
echo "This verifies that Item 11 (Incomplete Error Context) is COMPLETED."
