execute_for() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    if [[ "$stmt" =~ ^([A-Z][A-Z0-9_]*)[[:space:]]*=[[:space:]]*([^[:space:]]+)[[:space:]]+TO[[:space:]]+([^[:space:]]+)([[:space:]]+STEP[[:space:]]+([^[:space:]]+))?$ ]]; then
        local var_name="${BASH_REMATCH[1]}"
        local start_val="${BASH_REMATCH[2]}"
        local end_val="${BASH_REMATCH[3]}"
        local step_val="${BASH_REMATCH[5]:-1}"
        
        start_val=$(evaluate_expression "$start_val")
        end_val=$(evaluate_expression "$end_val")
        step_val=$(evaluate_expression "$step_val")
        
        NUMERIC_VARS["$var_name"]="$start_val"
        
        # Push FOR loop info onto stack
        # Store the FOR line so NEXT can jump back to loop body
        stack_push FOR_STACK "$var_name:$end_val:$step_val:$CURRENT_LINE"
        
        debug "FOR $var_name = $start_val TO $end_val STEP $step_val at line $CURRENT_LINE"
    else
        error "Invalid FOR statement: $stmt"
    fi
}
execute_next() {
    local stmt="$1"
    
    if [[ ${#FOR_STACK[@]} -eq 0 ]]; then
        error "NEXT without FOR"
    fi
    
    local for_info="${FOR_STACK[-1]}"
    local var_name="${for_info%%:*}"
    local rest="${for_info#*:}"
    local end_val="${rest%%:*}"
    rest="${rest#*:}"
    local step_val="${rest%%:*}"
    local for_line="${rest#*:}"
    
    # Get current variable value and increment
    local current_val="${NUMERIC_VARS[$var_name]}"
    local new_val=$((current_val + step_val))
    NUMERIC_VARS["$var_name"]="$new_val"
    
    # Check if loop should continue
    local continue_loop=false
    if [[ $step_val -gt 0 ]]; then
        [[ $new_val -le $end_val ]] && continue_loop=true
    else
        [[ $new_val -ge $end_val ]] && continue_loop=true
    fi
    
    if [[ "$continue_loop" == "true" ]]; then
        # Jump to the line AFTER the FOR statement (the loop body starts there)
        # Get the next line after FOR and set that as current
        # This way the loop body executes again without re-executing FOR
        local next_after_for=$(find_next_line "$for_line")
        if [[ -n "$next_after_for" ]]; then
            CURRENT_LINE="$next_after_for"
            debug "NEXT: Continue loop, $var_name = $new_val, jumping to line $CURRENT_LINE (after FOR at $for_line)"
        else
            error "NEXT: No line after FOR"
        fi
    else
        # Pop FOR stack and continue
        stack_pop FOR_STACK >/dev/null
        debug "NEXT: End loop, $var_name = $new_val"
    fi
}
execute_while() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    # Store the condition and current line for the loop
    # Push WHILE loop info onto stack: "condition:line_num"
    stack_push WHILE_STACK "$stmt:$CURRENT_LINE"
    
    debug "WHILE $stmt"
}
execute_wend() {
    local stmt="$1"
    
    if [[ ${#WHILE_STACK[@]} -eq 0 ]]; then
        error "WEND without WHILE"
    fi
    
    local while_info="${WHILE_STACK[-1]}"
    local condition="${while_info%:*}"
    local while_line="${while_info#*:}"
    
    # Evaluate the WHILE condition (using enhanced compound condition evaluator)
    local result=$(evaluate_compound_condition "$condition")
    
    debug "WEND: condition '$condition' evaluated to $result"
    
    if [[ "$result" == "true" ]]; then
        # Jump to the line AFTER the WHILE statement (loop body starts there)
        local next_after_while=$(find_next_line "$while_line")
        if [[ -n "$next_after_while" ]]; then
            CURRENT_LINE="$next_after_while"
            debug "WEND: Continue loop, jumping to line $CURRENT_LINE (after WHILE at $while_line)"
        else
            error "WEND: No line after WHILE"
        fi
    else
        # Pop WHILE stack and continue (same pattern as FOR/NEXT)
        stack_pop WHILE_STACK >/dev/null
        debug "WEND: End loop"
    fi
}
execute_if() {
    local stmt="$1"
    stmt=$(trim "$stmt")
    
    if [[ "$stmt" =~ ^(.+)[[:space:]]+THEN[[:space:]]+(.*)$ ]]; then
        local condition="${BASH_REMATCH[1]}"
        local then_else_part="${BASH_REMATCH[2]}"
        
        # Check for ELSE clause
        local then_part=""
        local else_part=""
        
        if [[ "$then_else_part" =~ ^(.+)[[:space:]]+ELSE[[:space:]]+(.*)$ ]]; then
            then_part="${BASH_REMATCH[1]}"
            else_part="${BASH_REMATCH[2]}"
            debug "IF with ELSE: then='$then_part', else='$else_part'"
        else
            then_part="$then_else_part"
            debug "IF without ELSE: then='$then_part'"
        fi
        
        # Evaluate condition using enhanced compound condition evaluator
        local result=$(evaluate_compound_condition "$condition")
        
        debug "IF condition '$condition' evaluated to $result"
        
        if [[ "$result" == "true" ]]; then
            # Execute THEN part (reuse existing logic)
            if is_numeric "$then_part"; then
                CURRENT_LINE="$then_part"
                debug "IF: GOTO line $then_part"
            else
                execute_statement "$then_part"
            fi
        elif [[ -n "$else_part" ]]; then
            # Execute ELSE part (same logic as THEN)
            if is_numeric "$else_part"; then
                CURRENT_LINE="$else_part"
                debug "IF: ELSE GOTO line $else_part"
            else
                execute_statement "$else_part"
            fi
        fi
    else
        error "Invalid IF statement: $stmt"
    fi
}
execute_gosub() {
    local line_num="$1"
    
    if [[ -z "${PROGRAM_LINES[$line_num]:-}" ]]; then
        error "GOSUB to undefined line: $line_num"
    fi
    
    # Push return address onto stack
    local next_line=$(find_next_line "$CURRENT_LINE")
    stack_push GOSUB_STACK "$next_line"
    
    CURRENT_LINE="$line_num"
    debug "GOSUB to line $line_num, return to $next_line"
}
execute_return() {
    local return_line=$(stack_pop GOSUB_STACK)
    if [[ $? -ne 0 ]]; then
        error "RETURN without GOSUB"
    fi
    
    CURRENT_LINE="$return_line"
    debug "RETURN to line $return_line"
}
