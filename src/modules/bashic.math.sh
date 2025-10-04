#!/bin/bash
# BASHIC Math Functions Module
# bashic.math.sh - Mathematical functions (ABS, INT, SGN, SQR)

# Mathematical functions
math_abs() {
    local n="$1"
    if [[ $(echo "$n < 0" | bc -l 2>/dev/null || echo "0") == "1" ]]; then
        echo "$n * -1" | bc -l 2>/dev/null || echo "${n#-}"
    else
        echo "$n"
    fi
}

math_int() {
    local n="$1"
    echo "$n" | cut -d. -f1
}

math_sgn() {
    local n="$1"
    if [[ "$n" =~ ^-.*$ ]]; then
        echo "-1"
    elif [[ "$n" == "0" || "$n" == "0.0" ]]; then
        echo "0"
    else
        echo "1"
    fi
}

math_sqr() {
    local n="$1"
    # Simple square root using bash arithmetic (limited precision)
    if command -v bc >/dev/null 2>&1; then
        echo "sqrt($n)" | bc -l
    else
        # Fallback: Newton's method approximation
        local x="$n"
        local prev=0
        while [[ "$x" != "$prev" ]]; do
            prev="$x"
            x=$(( (x + n/x) / 2 ))
        done
        echo "$x"
    fi
}
