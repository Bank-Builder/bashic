# Additional arithmetic parsing functions

# Handle MOD operator
parse_mod() {
    local expr="$1"
    
    # Find MOD operator
    if [[ "$expr" =~ ^(.+)\ +MOD\ +(.+)$ ]]; then
        local left="${BASH_REMATCH[1]}"
        local right="${BASH_REMATCH[2]}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Recursively evaluate both sides
        local left_result=$(parse_arithmetic "$left")
        local right_result=$(parse_arithmetic "$right")
        
        echo "$((left_result % right_result))"
        return
    fi
    
    # No MOD found, continue with other operators
    parse_multiplication "$expr"
}

# Handle multiplication
parse_multiplication() {
    local expr="$1"
    
    # Find * operator (outside quotes)
    local i=0
    local in_quotes=0
    local mult_pos=-1
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        if [[ "$char" == "\"" ]]; then
            in_quotes=$((!in_quotes))
        elif [[ "$char" == "*" && $in_quotes -eq 0 ]]; then
            mult_pos=$i
            break
        fi
        i=$((i + 1))
    done
    
    if [[ $mult_pos -ge 0 ]]; then
        local left="${expr:0:$mult_pos}"
        local right="${expr:$((mult_pos + 1))}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Recursively evaluate both sides
        local left_result=$(parse_arithmetic "$left")
        local right_result=$(parse_arithmetic "$right")
        
        echo "$((left_result * right_result))"
        return
    fi
    
    # No multiplication found, continue with division
    parse_division "$expr"
}

# Handle division
parse_division() {
    local expr="$1"
    
    # Find / operator (outside quotes)
    local i=0
    local in_quotes=0
    local div_pos=-1
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        if [[ "$char" == "\"" ]]; then
            in_quotes=$((!in_quotes))
        elif [[ "$char" == "/" && $in_quotes -eq 0 ]]; then
            div_pos=$i
            break
        fi
        i=$((i + 1))
    done
    
    if [[ $div_pos -ge 0 ]]; then
        local left="${expr:0:$div_pos}"
        local right="${expr:$((div_pos + 1))}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Recursively evaluate both sides
        local left_result=$(parse_arithmetic "$left")
        local right_result=$(parse_arithmetic "$right")
        
        echo "$((left_result / right_result))"
        return
    fi
    
    # No division found, continue with addition
    parse_addition "$expr"
}

# Handle addition
parse_addition() {
    local expr="$1"
    
    # Find + operator (outside quotes)
    local i=0
    local in_quotes=0
    local add_pos=-1
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        if [[ "$char" == "\"" ]]; then
            in_quotes=$((!in_quotes))
        elif [[ "$char" == "+" && $in_quotes -eq 0 ]]; then
            add_pos=$i
            break
        fi
        i=$((i + 1))
    done
    
    if [[ $add_pos -ge 0 ]]; then
        local left="${expr:0:$add_pos}"
        local right="${expr:$((add_pos + 1))}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Recursively evaluate both sides
        local left_result=$(parse_arithmetic "$left")
        local right_result=$(parse_arithmetic "$right")
        
        # Check if this is string concatenation
        if [[ ! "$left_result" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || [[ ! "$right_result" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
            echo "${left_result}${right_result}"
        else
            echo "$((left_result + right_result))"
        fi
        return
    fi
    
    # No addition found, continue with subtraction
    parse_subtraction "$expr"
}

# Handle subtraction
parse_subtraction() {
    local expr="$1"
    
    # Find - operator (outside quotes, but not at start)
    local i=1
    local in_quotes=0
    local sub_pos=-1
    
    while [[ $i -lt ${#expr} ]]; do
        local char="${expr:$i:1}"
        if [[ "$char" == "\"" ]]; then
            in_quotes=$((!in_quotes))
        elif [[ "$char" == "-" && $in_quotes -eq 0 ]]; then
            sub_pos=$i
            break
        fi
        i=$((i + 1))
    done
    
    if [[ $sub_pos -ge 0 ]]; then
        local left="${expr:0:$sub_pos}"
        local right="${expr:$((sub_pos + 1))}"
        
        left=$(trim "$left")
        right=$(trim "$right")
        
        # Recursively evaluate both sides
        local left_result=$(parse_arithmetic "$left")
        local right_result=$(parse_arithmetic "$right")
        
        echo "$((left_result - right_result))"
        return
    fi
    
    # No subtraction found, evaluate as atom
    evaluate_atom "$expr"
}
