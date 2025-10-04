#!/bin/bash
# BASHIC Core Module
# bashic.core.sh - Program management, execution loop, and main function

# Load program from file
load_program() {
    local filename="$1"
    
    if [[ ! -f "$filename" ]]; then
        error "File not found: $filename"
    fi
    
    debug "Loading program: $filename"
    
    # Set up terminal for INKEY$ handling
    if [[ -t 0 ]]; then
        debug "stdin is a terminal - setting up interactive mode"
        # Save current terminal settings
        OLD_TTY_SETTINGS=$(stty -g)
        # Set terminal to raw mode
        stty raw -echo
        
        # Function to handle cleanup
        cleanup_terminal() {
            if [[ -n "$OLD_TTY_SETTINGS" ]]; then
                debug "Restoring terminal settings"
                stty "$OLD_TTY_SETTINGS" </dev/tty 2>/dev/null || true
            fi
        }
        
        # Trap for cleanup on script exit
        trap cleanup_terminal EXIT
    else
        debug "stdin is not a terminal - reading input for buffer"
        # Read all input into buffer for non-interactive mode
        INKEY_BUFFER=$(cat)
        debug "INKEY_BUFFER filled with ${#INKEY_BUFFER} characters"
    fi
    
    # Clear existing program
    PROGRAM_LINES=()
    NUMERIC_VARS=()
    STRING_VARS=()
    ARRAYS=()
    GOSUB_STACK=()
    FOR_STACK=()
    WHILE_STACK=()
    DATA_ITEMS=()
    DATA_POINTER=0
    
    # Initialize graphics buffer
    init_graphics_buffer
    
    # Read program lines
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*REM ]]; then
            continue
        fi
        
        # Extract line number and statement
        if [[ "$line" =~ ^[[:space:]]*([0-9]+)[[:space:]]+(.*)$ ]]; then
            local line_num="${BASH_REMATCH[1]}"
            local statement="${BASH_REMATCH[2]}"
            
            # Validate line number
            if [[ $line_num -gt $MAX_LINE_NUMBER ]]; then
                error "Line number too large: $line_num"
            fi
            
            # Check if statement contains colons (multi-statement line)
            # Don't split REM comments or strings
            local has_colon=false
            local upper_stmt="${statement^^}"
            
            if [[ ! "$upper_stmt" =~ ^REM && ! "$statement" =~ ^\' ]]; then
                # Check for colon outside of strings
                local in_string=0
                local i=0
                while [[ $i -lt ${#statement} ]]; do
                    local char="${statement:$i:1}"
                    if [[ "$char" == '"' ]]; then
                        in_string=$((1 - in_string))
                    elif [[ "$char" == ":" && $in_string -eq 0 ]]; then
                        has_colon=true
                        break
                    fi
                    i=$((i + 1))
                done
            fi
            
            # If no colon or REM, store as single statement (original behavior)
            if [[ "$has_colon" == "false" ]]; then
                PROGRAM_LINES[$line_num]="$statement"
            else
                # Split by colon, preserving colons in strings
                local stmts=()
                local current=""
                local in_string=0
                local i=0
                
                while [[ $i -lt ${#statement} ]]; do
                    local char="${statement:$i:1}"
                    if [[ "$char" == '"' ]]; then
                        in_string=$((1 - in_string))
                        current="${current}${char}"
                    elif [[ "$char" == ":" && $in_string -eq 0 ]]; then
                        if [[ -n "$current" ]]; then
                            stmts+=("$current")
                            current=""
                        fi
                    else
                        current="${current}${char}"
                    fi
                    i=$((i + 1))
                done
                [[ -n "$current" ]] && stmts+=("$current")
                
                # Store statements using fractional line numbers
                if [[ ${#stmts[@]} -gt 0 ]]; then
                    PROGRAM_LINES[$line_num]="${stmts[0]}"
                    
                    local stmt_idx=1
                    while [[ $stmt_idx -lt ${#stmts[@]} ]]; do
                        local sub_line="${line_num}.${stmt_idx}"
                        PROGRAM_LINES[$sub_line]="${stmts[$stmt_idx]}"
                        debug "Multi-statement: line $line_num part $stmt_idx stored as $sub_line"
                        stmt_idx=$((stmt_idx + 1))
                    done
                fi
            fi
        fi
    done < "$filename"
    
    if [[ ${#PROGRAM_LINES[@]} -eq 0 ]]; then
        error "No valid program lines found"
    fi
    
    # Pre-parse program for DIM and DATA statements
    pre_parse_program
    
    debug "Program loaded: ${#PROGRAM_LINES[@]} lines"
}

# Pre-parse program to handle DIM and DATA statements
pre_parse_program() {
    debug "Pre-parsing program for DIM and DATA statements"
    
    # Sort line numbers for DATA statement processing
    local sorted_lines
    readarray -t sorted_lines < <(printf '%s\n' "${!PROGRAM_LINES[@]}" | sort -n)
    
    for line_num in "${sorted_lines[@]}"; do
        local stmt="${PROGRAM_LINES[$line_num]}"
        local upper_stmt=$(echo "$stmt" | tr '[:lower:]' '[:upper:]')
        
        if [[ "$upper_stmt" =~ ^DIM[[:space:]]+(.*)$ ]]; then
            local args="${BASH_REMATCH[1]}"
            args=$(trim "$args")
            
            debug "DIM args: '$args'"
            
            # Split by comma, but only outside parentheses
            declare -a array_decls
            local current=""
            local paren_count=0
            local i=0
            
            while [[ $i -lt ${#args} ]]; do
                local char="${args:$i:1}"
                if [[ "$char" == "(" ]]; then
                    paren_count=$((paren_count + 1))
                    current="${current}${char}"
                elif [[ "$char" == ")" ]]; then
                    paren_count=$((paren_count - 1))
                    current="${current}${char}"
                elif [[ "$char" == "," && $paren_count -eq 0 ]]; then
                    array_decls+=("$current")
                    current=""
                else
                    current="${current}${char}"
                fi
                i=$((i + 1))
            done
            [[ -n "$current" ]] && array_decls+=("$current")
            
            debug "Found ${#array_decls[@]} array declarations"
            
            for array_decl in "${array_decls[@]}"; do
                array_decl=$(trim "$array_decl")
                
                debug "Parsing array declaration: '$array_decl'"
                
                # Parse DIM statement: ARRAY(SIZE) or ARRAY$(SIZE) or ARRAY(SIZE,SIZE) for 2D
                # For 2D arrays, we'll use the first dimension as size
                # SIZE can be a number or a variable name (for dynamic sizing)
                if [[ "$array_decl" =~ ^([A-Z][A-Z0-9_]*)(\$?)\(([A-Z0-9_%]+)(,[A-Z0-9_%]+)?\)$ ]]; then
                    local array_name="${BASH_REMATCH[1]}"
                    local is_string="${BASH_REMATCH[2]}"
                    local size_expr="${BASH_REMATCH[3]}"
                    
                    # Evaluate size expression (could be a variable or number)
                    local size
                    if [[ "$size_expr" =~ ^[0-9]+$ ]]; then
                        size="$size_expr"
                    else
                        # Try to evaluate as variable
                        size="${NUMERIC_VARS[$size_expr]:-100}"
                    fi
                    
                    # Validate array size
                    if [[ $size -gt $MAX_ARRAY_SIZE ]]; then
                        error "Array size too large: $array_name($size)"
                    fi
                    
                    # Store array metadata
                    local array_type="numeric"
                    [[ -n "$is_string" ]] && array_type="string"
                    # Include $ in array name for string arrays for consistency
                    [[ -n "$is_string" ]] && array_name="${array_name}$"
                    ARRAYS[$array_name]="$array_type:$size"
                    
                    debug "DIM: $array_name($size) - $array_type"
                else
                    error "Invalid DIM statement: $stmt"
                fi
            done
        fi
        
        # Parse DATA statements
        if [[ "$upper_stmt" =~ ^DATA[[:space:]]+(.*)$ ]]; then
            local data_args="${BASH_REMATCH[1]}"
            
            # Split by comma, preserving quoted strings
            local in_quotes=0
            local current=""
            local i=0
            
            while [[ $i -lt ${#data_args} ]]; do
                local char="${data_args:$i:1}"
                if [[ "$char" == '"' ]]; then
                    in_quotes=$((1 - in_quotes))
                    current="${current}${char}"
                elif [[ "$char" == "," && $in_quotes -eq 0 ]]; then
                    current=$(trim "$current")
                    # Remove quotes if present
                    if [[ "$current" =~ ^\"(.*)\"$ ]]; then
                        current="${BASH_REMATCH[1]}"
                    fi
                    DATA_ITEMS+=("$current")
                    current=""
                else
                    current="${current}${char}"
                fi
                i=$((i + 1))
            done
            
            # Add last item
            if [[ -n "$current" ]]; then
                current=$(trim "$current")
                if [[ "$current" =~ ^\"(.*)\"$ ]]; then
                    current="${BASH_REMATCH[1]}"
                fi
                DATA_ITEMS+=("$current")
            fi
            
            debug "DATA: Added ${#DATA_ITEMS[@]} total items so far"
        fi
    done
    
    debug "Pre-parsing complete: ${#ARRAYS[@]} arrays declared, ${#DATA_ITEMS[@]} DATA items"
}

# Get sorted line numbers
get_line_numbers() {
    if [[ -z "${SORTED_LINE_NUMBERS:-}" ]] || [[ ${#SORTED_LINE_NUMBERS[@]} -eq 0 ]]; then
        readarray -t SORTED_LINE_NUMBERS < <(printf '%s\n' "${!PROGRAM_LINES[@]}" | sort -n)
    fi
    
    printf '%s\n' "${SORTED_LINE_NUMBERS[@]}"
}

# Find next line number after current line
find_next_line() {
    local current="$1"
    local line_numbers
    readarray -t line_numbers < <(get_line_numbers)
    
    # Since lines are already sorted numerically (sort -n handles decimals)
    # we just need to find the first line after current
    local next=""
    local found_current=false
    
    for line in "${line_numbers[@]}"; do
        if [[ "$found_current" == "true" ]]; then
            next="$line"
            break
        fi
        if [[ "$line" == "$current" ]]; then
            found_current=true
        fi
    done
    
    echo "$next"
}

# Run program
run_program() {
    debug "Starting program execution"
    
    RUNNING=true
    CURRENT_LINE=0
    
    # Start with first line
    local line_numbers
    readarray -t line_numbers < <(get_line_numbers)
    
    if [[ ${#line_numbers[@]} -eq 0 ]]; then
        error "No program lines to execute"
    fi
    
    CURRENT_LINE="${line_numbers[0]}"
    
    while [[ "$RUNNING" == "true" ]]; do
        local stmt="${PROGRAM_LINES[$CURRENT_LINE]}"
        local saved_line="$CURRENT_LINE"
        
        debug "Executing line $CURRENT_LINE: $stmt"
        
        execute_statement "$stmt"
        
        if [[ "$RUNNING" == "true" ]]; then
            # Check if statement changed the line (GOTO, ON GOTO, etc.)
            if [[ "$CURRENT_LINE" != "$saved_line" ]]; then
                # Line was changed by control flow - use new line on next iteration
                debug "Control flow changed line from $saved_line to $CURRENT_LINE"
            else
                # Normal flow - advance to next line
                local next_line=$(find_next_line "$CURRENT_LINE")
                if [[ -n "$next_line" ]]; then
                    CURRENT_LINE="$next_line"
                else
                    RUNNING=false
                fi
            fi
        fi
    done
    
    debug "Program execution completed"
    
    # Restore terminal settings if we were in interactive mode
    if [[ -t 0 && -n "${saved_stty:-}" ]]; then
        debug "Restoring terminal settings"
        stty "$saved_stty" 2>/dev/null || true
    fi
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--debug)
                DEBUG=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -v|--version)
                echo "BASHIC Version 1.0"
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                if [[ -z "${PROGRAM_FILE:-}" ]]; then
                    PROGRAM_FILE="$1"
                else
                    error "Multiple program files specified"
                fi
                shift
                ;;
        esac
    done
}

# Main function
main() {
    parse_args "$@"
    
    if [[ -z "${PROGRAM_FILE:-}" ]]; then
        usage
        exit 1
    fi
    
    load_program "$PROGRAM_FILE"
    run_program
}

# Run main function with all arguments
main "$@"