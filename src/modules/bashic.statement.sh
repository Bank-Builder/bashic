execute_print() {
    local args="$1"
    
    if [[ -z "$args" ]]; then
        echo
        return
    fi
    
    # Split by comma or semicolon
    local output=""
    local no_newline=false
    
    # Simple parsing - handle comma and semicolon separated values
    # For single expressions, just evaluate directly
    if [[ "$args" != *","* && "$args" != *";"* ]]; then
        local value=$(evaluate_expression "$args")
        echo -e "$value"
        return
    fi
    
    # For multiple expressions, use parentheses-aware parsing
    while [[ -n "$args" ]]; do
        args=$(trim "$args")
        
        # Find the next comma or semicolon that's outside parentheses
        local paren_count=0
        local i=0
        local sep_pos=-1
        local sep_char=""
        
        while [[ $i -lt ${#args} ]]; do
            local char="${args:$i:1}"
            case "$char" in
                "(") paren_count=$((paren_count + 1)) ;;
                ")") paren_count=$((paren_count - 1)) ;;
                ","|";")
                    if [[ $paren_count -eq 0 ]]; then
                        sep_pos=$i
                        sep_char="$char"
                        break
                    fi
                    ;;
            esac
            i=$((i + 1))
        done
        
        if [[ $sep_pos -ge 0 ]]; then
            # Found separator outside parentheses
            local value="${args:0:$sep_pos}"
            args="${args:$((sep_pos + 1))}"
            
            value=$(evaluate_expression "$value")
            
            if [[ "$sep_char" == "," ]]; then
                output="${output}${value}\t"
            else
                output="${output}${value}"
                no_newline=true
            fi
        else
            # No separator found - last item
            local value=$(evaluate_expression "$args")
            output="${output}${value}"
            break
        fi
    done
    
    if [[ "$no_newline" == "true" ]]; then
        printf "%s" "$output"
    else
        echo -e "$output"
    fi
}
execute_let() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    # Handle array assignment: VARNAME(INDEX) = VALUE
    local array_assign_regex='^([A-Z][A-Z0-9_]*)\(([^)]+)\)[[:space:]]*=[[:space:]]*(.*)$'
    if [[ "$stmt" =~ $array_assign_regex ]]; then
        local array_name="${BASH_REMATCH[1]}"
        local index_expr="${BASH_REMATCH[2]}"
        local value="${BASH_REMATCH[3]}"
        
        # Evaluate index and value
        local index=$(evaluate_expression "$index_expr")
        value=$(evaluate_expression "$value")
        
        # Check if array exists
        if [[ -z "${ARRAYS[$array_name]:-}" ]]; then
            error "Array not declared: $array_name"
        fi
        
        # Get array info
        local array_info="${ARRAYS[$array_name]}"
        local array_type="${array_info%:*}"
        local array_size="${array_info#*:}"
        
        # Check bounds
        if [[ $index -lt 0 || $index -gt $array_size ]]; then
            error "Array index out of bounds: $array_name($index)"
        fi
        
        # Store array element
        local element_name="${array_name}_${index}"
        if [[ "$array_type" == "string" ]]; then
            STRING_VARS["$element_name"]="$value"
        else
            NUMERIC_VARS["$element_name"]="$value"
        fi
        
        debug "Set $array_name($index) = $value"
        
    # Handle regular variable assignment: VARNAME = VALUE
    elif [[ "$stmt" =~ ^([A-Z][A-Z0-9_]*\$?)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
        local var_name="${BASH_REMATCH[1]}"
        local value="${BASH_REMATCH[2]}"
        
        value=$(evaluate_expression "$value")
        
        if [[ "$var_name" =~ \$$ ]]; then
            STRING_VARS["$var_name"]="$value"
        else
            NUMERIC_VARS["$var_name"]="$value"
        fi
        
        debug "Set $var_name = $value"
    else
        error "Invalid LET statement: $stmt"
    fi
}
execute_dim() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    # Arrays are already declared during pre-parsing
    # This function exists for compatibility but does nothing
    debug "DIM statement already processed during pre-parsing: $stmt"
}
execute_statement() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    debug "Executing: $stmt"
    
    # Skip empty statements and comments
    [[ -z "$stmt" ]] && return
    [[ "$stmt" =~ ^REM ]] && return
    [[ "$stmt" =~ ^\' ]] && return
    
    # Convert to uppercase for keyword matching
    local upper_stmt="${stmt^^}"
    
    case "$upper_stmt" in
        END|STOP)
            debug "Program ended"
            RUNNING=false
            ;;
        PRINT*)
            local args="${stmt#*PRINT}"
            execute_print "$args"
            ;;
        LET*)
            local args="${stmt#*LET}"
            execute_let "$args"
            ;;
        DIM*)
            local args="${stmt#*DIM}"
            execute_dim "$args"
            ;;
        FOR*)
            local args="${stmt#*FOR}"
            execute_for "$args"
            ;;
        NEXT*)
            execute_next "$stmt"
            ;;
        WHILE*)
            local args="${stmt#*WHILE}"
            execute_while "$args"
            ;;
        WEND*)
            execute_wend "$stmt"
            ;;
        IF*)
            local args="${stmt#*IF}"
            execute_if "$args"
            ;;
        GOTO*)
            local line_num="${stmt#*GOTO}"
            line_num=$(trim "$line_num")
            if [[ -z "${PROGRAM_LINES[$line_num]:-}" ]]; then
                error "GOTO to undefined line: $line_num"
            fi
            CURRENT_LINE="$line_num"
            debug "GOTO line $line_num"
            ;;
        GOSUB*)
            local line_num="${stmt#*GOSUB}"
            line_num=$(trim "$line_num")
            execute_gosub "$line_num"
            ;;
        RETURN)
            execute_return
            ;;
        *)
            # Check if it's an assignment without LET
            local assign_regex='^[A-Z][A-Z0-9_]*(\$|\([^)]+\))?[[:space:]]*='
            if [[ "$stmt" =~ $assign_regex ]]; then
                execute_let "$stmt"
            else
                error "Unknown statement: $stmt"
            fi
            ;;
    esac
}
