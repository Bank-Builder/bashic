#!/bin/bash
# BASHIC Expression Evaluation Module
# bashic.eval.sh - Expression evaluation, operators, and condition evaluation

# Evaluate expression (optimized with single regex pattern)
evaluate_expression() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Evaluating expression: $expr"
    
    # Handle string literals
    if [[ "$expr" =~ ^\"(.*)\"$ ]]; then
        echo "${BASH_REMATCH[1]}"
        return
    fi
    
    # Handle special functions (before string variables)
    if [[ "$expr" == "INKEY$" ]]; then
        # Use the kbd module's INKEY$ function
        INKEY_STR
        return
    fi
    
    if [[ "$expr" == "TIME$" ]]; then
        # Return current time as HH:MM:SS
        str_time
        return
    fi
    
    # Handle string variables
    if [[ "$expr" =~ ^[A-Za-z][A-Za-z0-9_]*\$$ ]]; then
        local var_name="$expr"
        echo "${STRING_VARS[$var_name]:-}"
        return
    fi
    
    # Handle numeric variables (including integer variables with % suffix)
    if [[ "$expr" =~ ^[A-Za-z][A-Za-z0-9_]*%?$ ]]; then
        local var_name="$expr"
        echo "${NUMERIC_VARS[$var_name]:-0}"
        return
    fi
    
    # Handle numeric literals
    if is_numeric "$expr"; then
        echo "$expr"
        return
    fi
    
    # Handle string functions FIRST (functions ending in $)
    local string_func_regex='^([A-Za-z]+\$?)\(([^)]*)\)$'
    if [[ "$expr" =~ $string_func_regex ]]; then
        local func="${BASH_REMATCH[1]}"
        local arg="${BASH_REMATCH[2]}"
        
        # Check if it's a string function (ends with $)
        if [[ "$func" =~ \$$ ]]; then
            case "$func" in
                "INPUT$")
                    str_input "$arg"
                    return
                    ;;
                "STR$")
                    arg=$(evaluate_expression "$arg")
                    str_str "$arg"
                    return
                    ;;
                "LEFT$")
                    str_left "$arg"
                    return
                    ;;
                "RIGHT$")
                    str_right "$arg"
                    return
                    ;;
                "MID$")
                    str_mid "$arg"
                    return
                    ;;
                "CHR$")
                    str_chr "$arg"
                    return
                    ;;
                "SPACE$")
                    str_space "$arg"
                    return
                    ;;
                "TIME$")
                    str_time
                    return
                    ;;
                "TAB$")
                    str_tab "$arg"
                    return
                    ;;
                *)
                    debug "Unknown string function: $func"
                    ;;
            esac
        fi
    fi
    
    # Handle function calls (check before array access)
    local func_regex='^([A-Za-z]+\$?)\(([^)]*)\)$'
    if [[ "$expr" =~ $func_regex ]]; then
        local func="${BASH_REMATCH[1]}"
        local arg="${BASH_REMATCH[2]}"
        
        # Check if it's a known function (not an array)
        case "$func" in
            "ABS")
                arg=$(evaluate_expression "$arg")
                math_abs "$arg"
                return
                ;;
            "INT")
                arg=$(evaluate_expression "$arg")
                math_int "$arg"
                return
                ;;
            "SGN")
                arg=$(evaluate_expression "$arg")
                math_sgn "$arg"
                return
                ;;
            "SQR")
                arg=$(evaluate_expression "$arg")
                math_sqr "$arg"
                return
                ;;
            "RND")
                arg=$(evaluate_expression "$arg")
                math_rnd "$arg"
                return
                ;;
            "LEN")
                arg=$(evaluate_expression "$arg")
                str_len "$arg"
                return
                ;;
            "LEFT$")
                if [[ "$arg" =~ ^([^,]+),([^,]+)$ ]]; then
                    local str_arg="${BASH_REMATCH[1]}"
                    local len_arg="${BASH_REMATCH[2]}"
                    str_arg=$(evaluate_expression "$(trim "$str_arg")")
                    len_arg=$(evaluate_expression "$(trim "$len_arg")")
                    str_left "$str_arg" "$len_arg"
                    return
                fi
                ;;
            "RIGHT$")
                if [[ "$arg" =~ ^([^,]+),([^,]+)$ ]]; then
                    local str_arg="${BASH_REMATCH[1]}"
                    local len_arg="${BASH_REMATCH[2]}"
                    str_arg=$(evaluate_expression "$(trim "$str_arg")")
                    len_arg=$(evaluate_expression "$(trim "$len_arg")")
                    str_right "$str_arg" "$len_arg"
                    return
                fi
                ;;
            "MID$")
                if [[ "$arg" =~ ^([^,]+),([^,]+),([^,]+)$ ]]; then
                    local str_arg="${BASH_REMATCH[1]}"
                    local start_arg="${BASH_REMATCH[2]}"
                    local len_arg="${BASH_REMATCH[3]}"
                    str_arg=$(evaluate_expression "$(trim "$str_arg")")
                    start_arg=$(evaluate_expression "$(trim "$start_arg")")
                    len_arg=$(evaluate_expression "$(trim "$len_arg")")
                    str_mid "$str_arg" "$start_arg" "$len_arg"
                    return
                fi
                ;;
            "ASC")
                arg=$(evaluate_expression "$arg")
                str_asc "$arg"
                return
                ;;
            "CHR$")
                arg=$(evaluate_expression "$arg")
                str_chr "$arg"
                return
                ;;
            "VAL")
                arg=$(evaluate_expression "$arg")
                str_val "$arg"
                return
                ;;
            "STR$")
                arg=$(evaluate_expression "$arg")
                echo "$arg"
                return
                ;;
            "SPACE$")
                arg=$(evaluate_expression "$arg")
                str_space "$arg"
                return
                ;;
            "TAB")
                arg=$(evaluate_expression "$arg")
                str_tab "$arg"
                return
                ;;
            *)
                # Not a known function, might be an array - fall through to array handling
                ;;
        esac
    fi
    
    # Handle array access (after function calls)
    local array_regex='^([A-Za-z][A-Za-z0-9_]*)\(([^)]+)\)$'
    if [[ "$expr" =~ $array_regex ]]; then
        local array_name="${BASH_REMATCH[1]}"
        array_name="${array_name^^}"  # Convert to uppercase for consistency
        local index_expr="${BASH_REMATCH[2]}"
        
        # Check if this is 2D array access (comma-separated indices)
        if [[ "$index_expr" =~ ^([^,]+),([^,]+)$ ]]; then
            # 2D array access: array(i, j)
            local index1_expr="${BASH_REMATCH[1]}"
            local index2_expr="${BASH_REMATCH[2]}"
            
            # Evaluate both indices
            local index1
            index1=$(evaluate_expression "$index1_expr")
            local index2
            index2=$(evaluate_expression "$index2_expr")
            
            # Check if array exists
            if [[ -z "${ARRAYS[$array_name]:-}" ]]; then
                error "Array not declared: $array_name"
            fi
            
            # Get array type and dimensions
            local array_info="${ARRAYS[$array_name]}"
            local array_type="${array_info%:*}"
            local dimensions="${array_info#*:}"
            
            # Parse dimensions
            if [[ "$dimensions" =~ ^([0-9]+),([0-9]+)$ ]]; then
                local size1="${BASH_REMATCH[1]}"
                local size2="${BASH_REMATCH[2]}"
                
                # Check bounds for 2D array
                if [[ $index1 -lt 0 || $index1 -gt $size1 ]]; then
                    error "Array index out of bounds: $array_name($index1,$index2) - first dimension"
                fi
                if [[ $index2 -lt 0 || $index2 -gt $size2 ]]; then
                    error "Array index out of bounds: $array_name($index1,$index2) - second dimension"
                fi
                
                # Return array element value (2D: array_name_i_j)
                local element_name="${array_name}_${index1}_${index2}"
                if [[ "$array_type" == "string" ]]; then
                    echo "${STRING_VARS[$element_name]:-}"
                else
                    echo "${NUMERIC_VARS[$element_name]:-0}"
                fi
            else
                error "Array $array_name is not 2D: $dimensions"
            fi
        else
            # 1D array access: array(i)
            local index
            index=$(evaluate_expression "$index_expr")
            
            # Check if array exists
            if [[ -z "${ARRAYS[$array_name]:-}" ]]; then
                error "Array not declared: $array_name"
            fi
            
            # Get array type and size
            local array_info="${ARRAYS[$array_name]}"
            local array_type="${array_info%:*}"
            local array_size="${array_info#*:}"
            
            # Check bounds
            if [[ $index -lt 0 || $index -gt $array_size ]]; then
                error "Array index out of bounds: $array_name($index)"
            fi
            
            # Return array element value
            local element_name="${array_name}_${index}"
            if [[ "$array_type" == "string" ]]; then
                echo "${STRING_VARS[$element_name]:-}"
            else
                echo "${NUMERIC_VARS[$element_name]:-0}"
            fi
        fi
        return
    fi
    
    # Handle MOD operator (word-based operator)
    if [[ "$expr" =~ ^([A-Za-z0-9_]+)\ +MOD\ +([A-Za-z0-9_]+)$ ]]; then
        local left="${BASH_REMATCH[1]}"
        local right="${BASH_REMATCH[2]}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        left=$(evaluate_expression "$left")
        right=$(evaluate_expression "$right")
        
        echo "$((left % right))"
        return
    fi
    
    # Handle string concatenation (+ operator) with proper quote handling
    # Find the + operator that's outside quotes
    local i=0
    local in_quotes=0
    local plus_pos=-1
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        if [[ "$char" == "\"" ]]; then
            in_quotes=$((!in_quotes))
        elif [[ "$char" == "+" && $in_quotes -eq 0 ]]; then
            plus_pos=$i
            break
        fi
        i=$((i + 1))
    done
    
    if [[ $plus_pos -ge 0 ]]; then
        # Found + operator outside quotes
        local left="${expr:0:$plus_pos}"
        local right="${expr:$((plus_pos + 1))}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Evaluate both sides
        local left_val
        left_val=$(evaluate_expression "$left")
        local right_val
        right_val=$(evaluate_expression "$right")
        
        # Check if this is string concatenation (not arithmetic)
        if [[ ! "$left_val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || [[ ! "$right_val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
            # String concatenation
            echo "${left_val}${right_val}"
            return
        fi
        # If both are numeric, fall through to arithmetic handling
    fi
    
    # Handle simple arithmetic (symbol-based operators)
    if [[ "$expr" =~ ^([A-Za-z0-9_]+)\ *(\+|\-|\*|/)\ *([A-Za-z0-9_]+)$ ]]; then
        local left="${BASH_REMATCH[1]}"
        local op="${BASH_REMATCH[2]}"
        local right="${BASH_REMATCH[3]}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        left=$(evaluate_expression "$left")
        right=$(evaluate_expression "$right")
        
        case "$op" in
            "+") echo "$((left + right))" ;;
            "-") echo "$((left - right))" ;;
            "*") echo "$((left * right))" ;;
            "/") echo "$((left / right))" ;;
        esac
        return
    fi
    
    # Default: return as-is
    echo "$expr"
}

# Evaluate simple condition
evaluate_condition() {
    local condition="$1"
    local result=false
    
    if [[ "$condition" =~ ^([^<>=!]+)[[:space:]]*([<>=!]+)[[:space:]]*(.+)$ ]]; then
        local left="${BASH_REMATCH[1]}"
        local op="${BASH_REMATCH[2]}"
        local right="${BASH_REMATCH[3]}"
        
        left=$(evaluate_expression "$(trim "$left")")
        right=$(evaluate_expression "$(trim "$right")")
        
        case "$op" in
            "=")  [[ "$left" == "$right" ]] && result=true ;;
            "<>") [[ "$left" != "$right" ]] && result=true ;;
            "<")  
                # Check if both are numeric
                if [[ "$left" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] && [[ "$right" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                    [[ $left -lt $right ]] && result=true
                else
                    # String comparison (lexicographic)
                    [[ "$left" < "$right" ]] && result=true
                fi
                ;;
            ">")  
                # Check if both are numeric
                if [[ "$left" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] && [[ "$right" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                    [[ $left -gt $right ]] && result=true
                else
                    # String comparison (lexicographic)
                    [[ "$left" > "$right" ]] && result=true
                fi
                ;;
            "<=") 
                # Check if both are numeric
                if [[ "$left" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] && [[ "$right" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                    [[ $left -le $right ]] && result=true
                else
                    # String comparison (lexicographic)
                    [[ "$left" < "$right" ]] || [[ "$left" == "$right" ]] && result=true
                fi
                ;;
            ">=") 
                # Check if both are numeric
                if [[ "$left" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] && [[ "$right" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                    [[ $left -ge $right ]] && result=true
                else
                    # String comparison (lexicographic)
                    [[ "$left" > "$right" ]] || [[ "$left" == "$right" ]] && result=true
                fi
                ;;
        esac
    fi
    
    echo "$result"
}

# Evaluate compound condition with AND/OR/NOT operators
evaluate_compound_condition() {
    local condition="$1"
    
    # Handle NOT operator (highest precedence)
    if [[ "$condition" =~ ^NOT[[:space:]]+(.+)$ ]]; then
        local inner_condition="${BASH_REMATCH[1]}"
        
        # Recursively evaluate the inner condition
        local inner_result
        inner_result=$(evaluate_compound_condition "$inner_condition")
        
        # NOT logic: true becomes false, false becomes true
        if [[ "$inner_result" == "true" ]]; then
            echo "false"
        else
            echo "true"
        fi
        return
    fi
    
    # Handle AND operator (higher precedence)
    if [[ "$condition" =~ ^(.+)[[:space:]]+AND[[:space:]]+(.+)$ ]]; then
        local left_cond="${BASH_REMATCH[1]}"
        local right_cond="${BASH_REMATCH[2]}"
        
        # Recursively evaluate both sides
        local left_result
        left_result=$(evaluate_compound_condition "$left_cond")
        local right_result
        right_result=$(evaluate_compound_condition "$right_cond")
        
        if [[ "$left_result" == "true" && "$right_result" == "true" ]]; then
            echo "true"
        else
            echo "false"
        fi
        return
    fi
    
    # Handle OR operator (lower precedence)
    if [[ "$condition" =~ ^(.+)[[:space:]]+OR[[:space:]]+(.+)$ ]]; then
        local left_cond="${BASH_REMATCH[1]}"
        local right_cond="${BASH_REMATCH[2]}"
        
        # Recursively evaluate both sides
        local left_result
        left_result=$(evaluate_compound_condition "$left_cond")
        local right_result
        right_result=$(evaluate_compound_condition "$right_cond")
        
        if [[ "$left_result" == "true" || "$right_result" == "true" ]]; then
            echo "true"
        else
            echo "false"
        fi
        return
    fi
    
    # No logical operators - evaluate as simple condition
    evaluate_condition "$condition"
}
