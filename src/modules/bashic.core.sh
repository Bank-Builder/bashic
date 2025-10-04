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
    
    # Clear existing program
    PROGRAM_LINES=()
    NUMERIC_VARS=()
    STRING_VARS=()
    ARRAYS=()
    GOSUB_STACK=()
    FOR_STACK=()
    WHILE_STACK=()
    
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
            
            PROGRAM_LINES[$line_num]="$statement"
        fi
    done < "$filename"
    
    if [[ ${#PROGRAM_LINES[@]} -eq 0 ]]; then
        error "No valid program lines found"
    fi
    
    # Pre-parse program for DIM statements
    pre_parse_program
    
    debug "Program loaded: ${#PROGRAM_LINES[@]} lines"
}

# Pre-parse program to handle DIM statements
pre_parse_program() {
    debug "Pre-parsing program for DIM statements"
    
    for line_num in "${!PROGRAM_LINES[@]}"; do
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
    done
    
    debug "Pre-parsing complete: ${#ARRAYS[@]} arrays declared"
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
    
    # Binary search for next line
    local left=0
    local right=${#line_numbers[@]}
    
    while [[ $left -lt $right ]]; do
        local mid=$(( (left + right) / 2 ))
        if [[ ${line_numbers[$mid]} -le $current ]]; then
            left=$((mid + 1))
        else
            right=$mid
        fi
    done
    
    local next=""
    if [[ $left -lt ${#line_numbers[@]} ]]; then
        next="${line_numbers[$left]}"
    fi
    
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
        debug "Executing line $CURRENT_LINE: $stmt"
        
        execute_statement "$stmt"
        
        if [[ "$RUNNING" == "true" ]]; then
            # Move to next line unless current line was changed by control flow
            local next_line=$(find_next_line "$CURRENT_LINE")
            if [[ -n "$next_line" ]]; then
                CURRENT_LINE="$next_line"
            else
                RUNNING=false
            fi
        fi
    done
    
    debug "Program execution completed"
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