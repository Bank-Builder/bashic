# BODMAS Expression Parser
# Brackets, Orders, Division, Multiplication, Addition, Subtraction

# Evaluate expression with BODMAS precedence
evaluate_expression() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Evaluating expression: $expr"
    
    # Use BODMAS parser
    parse_bodmas "$expr"
}

# BODMAS parser: Brackets, Orders, Division, Multiplication, Addition, Subtraction
parse_bodmas() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Parsing BODMAS: $expr"
    
    # Step 1: Handle Brackets (inside-out)
    expr=$(parse_brackets "$expr")
    
    # Step 2: Handle Orders (exponentiation) - not implemented yet
    # Step 3: Handle Division and Multiplication (left-to-right)
    expr=$(parse_mult_div "$expr")
    
    # Step 4: Handle Addition and Subtraction (left-to-right)
    expr=$(parse_add_sub "$expr")
    
    echo "$expr"
}

# Parse brackets (inside-out evaluation)
parse_brackets() {
    local expr="$1"
    
    # Find innermost brackets
    while [[ "$expr" =~ \( ]]; do
        local i=0
        local paren_count=0
        local start_pos=-1
        local end_pos=-1
        
        while [[ $i -lt ${#expr} ]]; do
            local char="${expr:$i:1}"
            if [[ "$char" == "(" ]]; then
                if [[ $paren_count -eq 0 ]]; then
                    start_pos=$i
                fi
                paren_count=$((paren_count + 1))
            elif [[ "$char" == ")" ]]; then
                paren_count=$((paren_count - 1))
                if [[ $paren_count -eq 0 ]]; then
                    end_pos=$i
                    break
                fi
            fi
            i=$((i + 1))
        done
        
        if [[ $start_pos -ge 0 && $end_pos -ge 0 ]]; then
            # Extract content inside brackets
            local inner="${expr:$((start_pos + 1)):$((end_pos - start_pos - 1))}"
            local before="${expr:0:$start_pos}"
            local after="${expr:$((end_pos + 1))}"
            
            # Recursively evaluate inner expression
            local inner_result=$(parse_bodmas "$inner")
            
            # Reconstruct expression with evaluated inner part
            expr="${before}${inner_result}${after}"
        else
            break
        fi
    done
    
    echo "$expr"
}

# Parse multiplication and division (left-to-right)
parse_mult_div() {
    local expr="$1"
    
    # Handle multiplication and division in left-to-right order
    while [[ "$expr" =~ \* ]] || [[ "$expr" =~ / ]]; do
        # Find first * or / operator
        local i=0
        local in_quotes=0
        local op_pos=-1
        local op_char=""
        
        while [[ $i -lt ${#expr} ]]; do
            local char="${expr:$i:1}"
            if [[ "$char" == "\"" ]]; then
                in_quotes=$((!in_quotes))
            elif [[ "$char" == "*" && $in_quotes -eq 0 ]]; then
                op_pos=$i
                op_char="*"
                break
            elif [[ "$char" == "/" && $in_quotes -eq 0 ]]; then
                op_pos=$i
                op_char="/"
                break
            fi
            i=$((i + 1))
        done
        
        if [[ $op_pos -ge 0 ]]; then
            # Find left and right operands
            local left=$(find_operand_left "$expr" $op_pos)
            local right=$(find_operand_right "$expr" $op_pos)
            
            # Evaluate operands
            local left_val=$(evaluate_atom "$left")
            local right_val=$(evaluate_atom "$right")
            
            # Perform operation
            local result
            if [[ "$op_char" == "*" ]]; then
                result=$((left_val * right_val))
            else
                result=$((left_val / right_val))
            fi
            
            # Replace in expression
            expr="${expr:0:$((op_pos - ${#left}))}${result}${expr:$((op_pos + 1 + ${#right}))}"
        else
            break
        fi
    done
    
    echo "$expr"
}

# Parse addition and subtraction (left-to-right)
parse_add_sub() {
    local expr="$1"
    
    # Handle addition and subtraction in left-to-right order
    while [[ "$expr" =~ \+ ]] || [[ "$expr" =~ \- ]]; do
        # Find first + or - operator (not at start)
        local i=1
        local in_quotes=0
        local op_pos=-1
        local op_char=""
        
        while [[ $i -lt ${#expr} ]]; do
            local char="${expr:$i:1}"
            if [[ "$char" == "\"" ]]; then
                in_quotes=$((!in_quotes))
            elif [[ "$char" == "+" && $in_quotes -eq 0 ]]; then
                op_pos=$i
                op_char="+"
                break
            elif [[ "$char" == "-" && $in_quotes -eq 0 ]]; then
                op_pos=$i
                op_char="-"
                break
            fi
            i=$((i + 1))
        done
        
        if [[ $op_pos -ge 0 ]]; then
            # Find left and right operands
            local left=$(find_operand_left "$expr" $op_pos)
            local right=$(find_operand_right "$expr" $op_pos)
            
            # Evaluate operands
            local left_val=$(evaluate_atom "$left")
            local right_val=$(evaluate_atom "$right")
            
            # Check if this is string concatenation
            if [[ ! "$left_val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || [[ ! "$right_val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                # String concatenation
                result="${left_val}${right_val}"
            else
                # Numeric operation
                if [[ "$op_char" == "+" ]]; then
                    result=$((left_val + right_val))
                else
                    result=$((left_val - right_val))
                fi
            fi
            
            # Replace in expression
            expr="${expr:0:$((op_pos - ${#left}))}${result}${expr:$((op_pos + 1 + ${#right}))}"
        else
            break
        fi
    done
    
    echo "$expr"
}

# Find left operand for an operator
find_operand_left() {
    local expr="$1"
    local op_pos="$2"
    
    # Find the start of the left operand
    local start=$op_pos
    while [[ $start -gt 0 ]]; do
        local char="${expr:$((start-1)):1}"
        if [[ "$char" =~ [0-9A-Z_$] ]]; then
            start=$((start - 1))
        else
            break
        fi
    done
    
    echo "${expr:$start:$((op_pos - start))}"
}

# Find right operand for an operator
find_operand_right() {
    local expr="$1"
    local op_pos="$2"
    
    # Find the end of the right operand
    local end=$((op_pos + 1))
    while [[ $end -lt ${#expr} ]]; do
        local char="${expr:$end:1}"
        if [[ "$char" =~ [0-9A-Z_$] ]]; then
            end=$((end + 1))
        else
            break
        fi
    done
    
    echo "${expr:$((op_pos + 1)):$((end - op_pos - 1))}"
}

# Evaluate basic elements (variables, functions, literals)
evaluate_atom() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Evaluating atom: $expr"
    
    # Handle string literals
    if [[ "$expr" =~ ^\"(.*)\"$ ]]; then
        echo "${BASH_REMATCH[1]}"
        return
    fi
    
    # Handle special functions
    if [[ "$expr" == "INKEY$" ]]; then
        INKEY$
        return
    fi
    
    if [[ "$expr" == "TIME$" ]]; then
        str_time
        return
    fi
    
    # Handle string variables
    if [[ "$expr" =~ ^[A-Z][A-Z0-9_]*\$$ ]]; then
        echo "${STRING_VARS[$expr]:-}"
        return
    fi
    
    # Handle numeric variables
    if [[ "$expr" =~ ^[A-Z][A-Z0-9_]*$ ]]; then
        echo "${NUMERIC_VARS[$expr]:-0}"
        return
    fi
    
    # Handle numeric literals
    if is_numeric "$expr"; then
        echo "$expr"
        return
    fi
    
    # Handle function calls
    if [[ "$expr" =~ ^([A-Z]+\$?)\(([^)]*)\)$ ]]; then
        local func="${BASH_REMATCH[1]}"
        local arg="${BASH_REMATCH[2]}"
        
        # Evaluate function arguments first
        arg=$(parse_bodmas "$arg")
        
        # Call the appropriate function
        case "$func" in
            "ABS") math_abs "$arg" ;;
            "INT") math_int "$arg" ;;
            "SGN") math_sgn "$arg" ;;
            "SQR") math_sqr "$arg" ;;
            "RND") math_rnd "$arg" ;;
            "LEN") str_len "$arg" ;;
            "LEFT$") str_left "$arg" ;;
            "RIGHT$") str_right "$arg" ;;
            "MID$") str_mid "$arg" ;;
            "ASC") str_asc "$arg" ;;
            "CHR$") str_chr "$arg" ;;
            "VAL") str_val "$arg" ;;
            "STR$") echo "$arg" ;;
            "SPACE$") str_space "$arg" ;;
            "TAB") str_tab "$arg" ;;
            *) echo "0" ;; # Unknown function
        esac
        return
    fi
    
    # Default: return as-is
    echo "$expr"
}
