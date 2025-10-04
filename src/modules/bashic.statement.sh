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
    # Check if there are separators outside string literals
    local has_separators=false
    local i=0
    local in_string=0
    while [[ $i -lt ${#args} ]]; do
        local char="${args:$i:1}"
        if [[ "$char" == '"' ]]; then
            in_string=$((!in_string))
        elif [[ ($char == "," || $char == ";") && $in_string -eq 0 ]]; then
            has_separators=true
            break
        fi
        i=$((i + 1))
    done

    if [[ "$has_separators" == "false" ]]; then
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
                # BASIC comma formatting: align to 14-character columns
                local current_len=${#output}
                local next_column=$(((current_len / 14 + 1) * 14))
                local spaces_needed=$((next_column - current_len))
                output="${output}$(printf '%*s' $spaces_needed '')${value}"
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

    debug "execute_let called with: $stmt"

    # Handle array assignment: VARNAME(INDEX) = VALUE
    local array_assign_regex='^([A-Z][A-Z0-9_]*\$?)\(([^)]+)\)[[:space:]]*=[[:space:]]*(.*)$'
    debug "Checking array assignment regex against: $stmt"
    if [[ "$stmt" =~ $array_assign_regex ]]; then
        local array_name="${BASH_REMATCH[1]}"
        local index_expr="${BASH_REMATCH[2]}"
        local value="${BASH_REMATCH[3]}"
        debug "Array assignment matched: array_name=$array_name, index_expr=$index_expr, value=$value"
        
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
execute_input() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    local prompt=""
    local var_list=""
    
    # Parse INPUT statement: INPUT "prompt", VAR or INPUT VAR
    if [[ "$stmt" =~ ^\"([^\"]*)\",[[:space:]]*(.+)$ ]]; then
        prompt="${BASH_REMATCH[1]}"
        var_list="${BASH_REMATCH[2]}"
    elif [[ "$stmt" =~ ^\"([^\"]*)\"[[:space:]]+(.+)$ ]]; then
        prompt="${BASH_REMATCH[1]}"
        var_list="${BASH_REMATCH[2]}"
    else
        var_list="$stmt"
    fi
    
    # Display prompt if provided
    if [[ -n "$prompt" ]]; then
        printf "%s" "$prompt"
    else
        printf "? "
    fi
    
    # Read input
    local input_value
    read -r input_value
    
    # Convert to uppercase if BASHIC_UPPER_CASE mode is enabled
    # Check both environment variable and BASIC variable
    local upper_case_mode="${BASHIC_UPPER_CASE:-${NUMERIC_VARS[BASHIC_UPPER_CASE]:-0}}"
    if [[ "$upper_case_mode" == "1" ]]; then
        input_value="${input_value^^}"
    fi
    
    # Parse variable list (comma-separated)
    IFS=',' read -ra vars <<< "$var_list"
    
    if [[ ${#vars[@]} -eq 1 ]]; then
        # Single variable
        local var_name=$(trim "${vars[0]}")
        
        if [[ "$var_name" =~ \$$ ]]; then
            # String variable
            STRING_VARS["$var_name"]="$input_value"
        else
            # Numeric variable
            if [[ "$input_value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                NUMERIC_VARS["$var_name"]="$input_value"
            else
                NUMERIC_VARS["$var_name"]="0"
            fi
        fi
    else
        # Multiple variables - split input by comma
        IFS=',' read -ra input_vals <<< "$input_value"
        
        local idx=0
        for var_name in "${vars[@]}"; do
            var_name=$(trim "$var_name")
            local val="${input_vals[$idx]:-}"
            val=$(trim "$val")
            
            if [[ "$var_name" =~ \$$ ]]; then
                # String variable
                STRING_VARS["$var_name"]="$val"
            else
                # Numeric variable
                if [[ "$val" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
                    NUMERIC_VARS["$var_name"]="$val"
                else
                    NUMERIC_VARS["$var_name"]="0"
                fi
            fi
            idx=$((idx + 1))
        done
    fi
    
    debug "INPUT: Read values into variables"
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
        KEY*|CLS|WIDTH*|LOCATE*|BEEP|RANDOMIZE*|COLOR*|SOUND*|POKE*|PEEK*|DEF*)
            # GW-BASIC hardware/graphics commands - ignore (no-op stubs)
            debug "Ignoring GW-BASIC command: ${upper_stmt%% *}"
            ;;
        DATA*|READ*|RESTORE*|ON*)
            # GW-BASIC data/computed GOTO commands - not yet implemented
            debug "Ignoring unimplemented command: ${upper_stmt%% *}"
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
        INPUT*)
            local args="${stmt#*INPUT}"
            execute_input "$args"
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
            # Pattern: VARNAME[$(INDEX)] = VALUE or VARNAME = VALUE
            local assign_regex='^[A-Z][A-Z0-9_]*(\$\([^)]+\)|[A-Z0-9_]*|\$|\([^)]+\))?[[:space:]]*='
            debug "Checking assignment regex against: $stmt"
            if [[ "$stmt" =~ $assign_regex ]]; then
                execute_let "$stmt"
            else
                debug "Statement does not match assignment regex: $stmt"
                error "Unknown statement: $stmt"
            fi
            ;;
    esac
}
