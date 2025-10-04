# New Expression Parser Functions

# Parse expression with proper precedence
parse_expression() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Parsing expression: $expr"
    
    # Level 1: Handle parentheses (inside-out)
    if [[ "$expr" =~ \( ]]; then
        parse_parentheses "$expr"
        return
    fi
    
    # Level 2: Handle comparison operators (lowest precedence)
    parse_comparison "$expr"
}

# Handle parentheses (inside-out evaluation)
parse_parentheses() {
    local expr="$1"
    
    # Find innermost parentheses
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
        # Extract content inside parentheses
        local inner="${expr:$((start_pos + 1)):$((end_pos - start_pos - 1))}"
        local before="${expr:0:$start_pos}"
        local after="${expr:$((end_pos + 1))}"
        
        # Recursively evaluate inner expression
        local inner_result=$(parse_expression "$inner")
        
        # Reconstruct expression with evaluated inner part
        local new_expr="${before}${inner_result}${after}"
        
        # Recursively parse the new expression
        parse_expression "$new_expr"
    else
        # No parentheses found, continue with other precedence levels
        parse_comparison "$expr"
    fi
}

# Handle comparison operators (=, <>, <, >, <=, >=)
parse_comparison() {
    local expr="$1"
    
    # Check for comparison operators in order of precedence
    local operators=("<>" "<=" ">=" "=" "<" ">")
    
    for op in "${operators[@]}"; do
        if [[ "$expr" =~ $op ]]; then
            # Split by operator
            local parts=(${expr//$op/ })
            if [[ ${#parts[@]} -eq 2 ]]; then
                local left="${parts[0]}"
                local right="${parts[1]}"
                
                # Recursively evaluate both sides
                local left_result=$(parse_arithmetic "$left")
                local right_result=$(parse_arithmetic "$right")
                
                # Perform comparison
                case "$op" in
                    "=")  [[ "$left_result" == "$right_result" ]] && echo "true" || echo "false" ;;
                    "<>") [[ "$left_result" != "$right_result" ]] && echo "true" || echo "false" ;;
                    "<")  [[ $left_result -lt $right_result ]] && echo "true" || echo "false" ;;
                    ">")  [[ $left_result -gt $right_result ]] && echo "true" || echo "false" ;;
                    "<=") [[ $left_result -le $right_result ]] && echo "true" || echo "false" ;;
                    ">=") [[ $left_result -ge $right_result ]] && echo "true" || echo "false" ;;
                esac
                return
            fi
        fi
    done
    
    # No comparison operators found, continue with arithmetic
    parse_arithmetic "$expr"
}

# Handle arithmetic operators with precedence
parse_arithmetic() {
    local expr="$1"
    
    # Level 4: Handle *, /, MOD (higher precedence)
    if [[ "$expr" =~ \ +MOD\ + ]]; then
        parse_mod "$expr"
        return
    fi
    
    if [[ "$expr" =~ \* ]]; then
        parse_multiplication "$expr"
        return
    fi
    
    if [[ "$expr" =~ / ]]; then
        parse_division "$expr"
        return
    fi
    
    # Level 5: Handle +, - (lower precedence)
    if [[ "$expr" =~ \+ ]]; then
        parse_addition "$expr"
        return
    fi
    
    if [[ "$expr" =~ \- ]]; then
        parse_subtraction "$expr"
        return
    fi
    
    # No arithmetic operators found, evaluate as atom
    evaluate_atom "$expr"
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
        arg=$(parse_expression "$arg")
        
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
