#!/bin/bash
# BASHIC Expression Module
# bashic.expr.sh - Expression evaluation using stack-based approach

# Evaluate expression with proper precedence
evaluate_expression() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Evaluating expression: $expr"
    
    # Use stack-based parser
    parse_expression_stack "$expr"
}

# Stack-based expression parser using Shunting Yard algorithm
parse_expression_stack() {
    local expr="$1"
    expr=$(trim "$expr")
    
    debug "Parsing expression with stack: $expr"
    
    # Handle brackets first (inside-out)
    expr=$(parse_brackets_stack "$expr")
    
    # Process the expression with stack
    echo "$(process_expression_stack "$expr")"
}

# Parse brackets using recursive approach
parse_brackets_stack() {
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
            
            # Check if this is a function call (before part ends with function name)
            if [[ "$before" =~ ^([A-Z]+\$?)$ ]]; then
                # This is a function call - don't process brackets, let evaluate_atom handle it
                break
            else
                # This is a regular bracket - recursively evaluate inner expression
                local inner_result=$(parse_expression_stack "$inner")
                
                # Reconstruct expression with evaluated inner part
                expr="${before}${inner_result}${after}"
            fi
        else
            break
        fi
    done
    
    echo "$expr"
}

# Process expression using Shunting Yard algorithm
process_expression_stack() {
    local expr="$1"
    
    # Tokenize the expression
    local tokens=($(tokenize_expression "$expr"))
    
    # Convert to postfix notation using Shunting Yard algorithm
    local output_queue=()
    local operator_stack=()
    
    echo "DEBUG: Input tokens: ${tokens[*]}" >&2
    
    for token in "${tokens[@]}"; do
        echo "DEBUG: Processing token: '$token'" >&2
        if [[ "$token" =~ ^[0-9A-Z_\$]+$ ]] || [[ "$token" =~ ^[A-Z]+\$?\(.*\)$ ]] || [[ "$token" =~ ^\".*\"$ ]]; then
            # Operand (variable, number, function call, or string literal) - add to output
            echo "DEBUG: Adding operand to output: '$token'" >&2
            output_queue+=("$token")
        elif [[ "$token" == "+" || "$token" == "-" || "$token" == "*" || "$token" == "/" ]]; then
            # Operator - handle precedence
            echo "DEBUG: Processing operator: '$token'" >&2
            while [[ ${#operator_stack[@]} -gt 0 ]]; do
                local top="${operator_stack[-1]}"
                echo "DEBUG: Checking precedence: '$token' vs '$top'" >&2
                if [[ ("$top" == "+" || "$top" == "-" || "$top" == "*" || "$top" == "/") ]] && [[ $(get_precedence "$token") -le $(get_precedence "$top") ]]; then
                    echo "DEBUG: Moving '$top' from stack to output" >&2
                    output_queue+=("${operator_stack[-1]}")
                    unset operator_stack[-1]
                    operator_stack=("${operator_stack[@]}")
                else
                    break
                fi
            done
            echo "DEBUG: Adding operator to stack: '$token'" >&2
            operator_stack+=("$token")
        fi
    done
    
    # Pop remaining operators
    echo "DEBUG: Popping remaining operators" >&2
    while [[ ${#operator_stack[@]} -gt 0 ]]; do
        echo "DEBUG: Moving '${operator_stack[-1]}' from stack to output" >&2
        output_queue+=("${operator_stack[-1]}")
        unset operator_stack[-1]
        operator_stack=("${operator_stack[@]}")
    done
    
    echo "DEBUG: Final postfix: ${output_queue[*]}" >&2
    
    # Evaluate postfix expression
    local eval_stack=()
    for token in "${output_queue[@]}"; do
        if [[ "$token" =~ ^[0-9A-Z_\$]+$ ]] || [[ "$token" =~ ^[A-Z]+\$?\(.*\)$ ]] || [[ "$token" =~ ^\".*\"$ ]]; then
            # Operand (variable, number, function call, or string literal) - push to stack
            local value=$(evaluate_atom "$token")
            eval_stack+=("$value")
        elif [[ "$token" == "+" || "$token" == "-" || "$token" == "*" || "$token" == "/" ]]; then
            # Operator - pop operands and evaluate
            if [[ ${#eval_stack[@]} -ge 2 ]]; then
                local right="${eval_stack[-1]}"
                unset eval_stack[-1]
                eval_stack=("${eval_stack[@]}")
                local left="${eval_stack[-1]}"
                unset eval_stack[-1]
                eval_stack=("${eval_stack[@]}")
                
                local result
                case "$token" in
                    "+") result=$((left + right)) ;;
                    "-") result=$((left - right)) ;;
                    "*") result=$((left * right)) ;;
                    "/") result=$((left / right)) ;;
                esac
                eval_stack+=("$result")
            fi
        fi
    done
    
    # Return final result
    if [[ ${#eval_stack[@]} -eq 1 ]]; then
        echo "${eval_stack[0]}"
    else
        echo "0"
    fi
}

# Tokenize expression into array
tokenize_expression() {
    local expr="$1"
    local tokens=()
    local i=0
    local current_token=""
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        
        if [[ "$char" =~ [0-9A-Z_\$] ]]; then
            # Variable or number
            current_token="${current_token}${char}"
        elif [[ "$char" == "+" || "$char" == "-" || "$char" == "*" || "$char" == "/" ]]; then
            # Operator
            if [[ -n "$current_token" ]]; then
                tokens+=("$current_token")
                current_token=""
            fi
            tokens+=("$char")
        elif [[ "$char" == " " ]]; then
            # Space - end current token
            if [[ -n "$current_token" ]]; then
                tokens+=("$current_token")
                current_token=""
            fi
        elif [[ "$char" == "(" ]]; then
            # Left parenthesis - check if this is a function call
            if [[ -n "$current_token" && "$current_token" =~ ^[A-Z]+\$?$ ]]; then
                # This is a function call - keep the function name and parenthesis together
                current_token="${current_token}("
            else
                # Regular parenthesis - end current token and add as separate token
                if [[ -n "$current_token" ]]; then
                    tokens+=("$current_token")
                    current_token=""
                fi
                tokens+=("$char")
            fi
        elif [[ "$char" == "\"" ]]; then
            # String literal - handle complete string
            # If we're in a function call, add the string to the current token
            if [[ "$current_token" =~ ^[A-Z]+\$?\( ]]; then
                # We're inside a function call - add the string literal to the current token
                local string_content="\""
                i=$((i + 1))
                while [[ $i -lt ${#expr} ]]; do
                    local next_char="${expr:$i:1}"
                    string_content="${string_content}${next_char}"
                    if [[ "$next_char" == "\"" ]]; then
                        break
                    fi
                    i=$((i + 1))
                done
                current_token="${current_token}${string_content}"
            else
                # Regular string literal - end current token and add as separate token
                if [[ -n "$current_token" ]]; then
                    tokens+=("$current_token")
                    current_token=""
                fi
                
                # Find the closing quote
                local string_content="\""
                i=$((i + 1))
                while [[ $i -lt ${#expr} ]]; do
                    local next_char="${expr:$i:1}"
                    string_content="${string_content}${next_char}"
                    if [[ "$next_char" == "\"" ]]; then
                        break
                    fi
                    i=$((i + 1))
                done
                
                tokens+=("$string_content")
            fi
        elif [[ "$char" == ")" ]]; then
            # Right parenthesis - if we're in a function call, complete it
            if [[ "$current_token" =~ ^[A-Z]+\$?\( ]]; then
                current_token="${current_token})"
                tokens+=("$current_token")
                current_token=""
            else
                # Regular parenthesis - end current token and add as separate token
                if [[ -n "$current_token" ]]; then
                    tokens+=("$current_token")
                    current_token=""
                fi
                tokens+=("$char")
            fi
        fi
        i=$((i + 1))
    done
    
    # Add final token
    if [[ -n "$current_token" ]]; then
        tokens+=("$current_token")
    fi
    
    # Print tokens (for use in command substitution)
    printf '%s\n' "${tokens[@]}"
}

# Get operator precedence
get_precedence() {
    local op="$1"
    case "$op" in
        "*"|"/") echo "2" ;;
        "+"|"-") echo "1" ;;
        *) echo "0" ;;
    esac
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
        INKEY_STR
        return
    fi
    
    if [[ "$expr" == "TIME$" ]]; then
        TIME_STR
        return
    fi
    
    # Handle function calls (check before variables to avoid conflicts)
    if [[ "$expr" =~ ^([A-Z]+\$?)\( ]]; then
        local func="${BASH_REMATCH[1]}"
        # Extract argument by removing function name and parentheses
        local arg="${expr#${func}(}"
        arg="${arg%)}"
        
        # Evaluate function arguments first
        arg=$(parse_expression_stack "$arg")
        
        # Call the appropriate function
        case "$func" in
            "ABS") ABS "$arg" ;;
            "INT") INT "$arg" ;;
            "SGN") SGN "$arg" ;;
            "SQR") SQR "$arg" ;;
            "RND") RND "$arg" ;;
            "LEN") LEN "$arg" ;;
            "LEFT$") LEFT_STR "$arg" ;;
            "RIGHT$") RIGHT_STR "$arg" ;;
            "MID$") MID_STR "$arg" ;;
            "ASC") ASC "$arg" ;;
            "CHR$") CHR_STR "$arg" ;;
            "VAL") VAL "$arg" ;;
            "STR$") echo "$arg" ;;
            "SPACE$") SPACE_STR "$arg" ;;
            "TAB") TAB "$arg" ;;
            *) echo "0" ;; # Unknown function
        esac
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
    
    # Default: return as-is
    echo "$expr"
}
