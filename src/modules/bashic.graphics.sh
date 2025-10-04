#!/bin/bash
# BASHIC Graphics Module
# bashic.graphics.sh - Graphics functions for LINE command and text-based graphics

# Graphics buffer for LINE command
declare -a BASHIC_GRAPHICS_BUFFER  # 2D array for text graphics
BASHIC_GRAPHICS_WIDTH=80
BASHIC_GRAPHICS_HEIGHT=25

# Initialize graphics buffer
init_graphics_buffer() {
    # Clear the graphics buffer
    BASHIC_GRAPHICS_BUFFER=()
    
    # Initialize with spaces
    local row=0
    while [[ $row -lt $BASHIC_GRAPHICS_HEIGHT ]]; do
        local col=0
        local line=""
        while [[ $col -lt $BASHIC_GRAPHICS_WIDTH ]]; do
            line="${line} "
            col=$((col + 1))
        done
        BASHIC_GRAPHICS_BUFFER[$row]="$line"
        row=$((row + 1))
    done
    
    debug "Graphics buffer initialized: ${BASHIC_GRAPHICS_WIDTH}x${BASHIC_GRAPHICS_HEIGHT}"
}

# Set a pixel in the graphics buffer
set_pixel() {
    local x="$1"
    local y="$2"
    local char="${3:-*}"
    
    # Convert graphics coordinates to buffer coordinates
    # Graphics coordinates are typically 0-based, buffer is 0-based
    local buffer_x=$x
    local buffer_y=$y
    
    # Check bounds
    if [[ $buffer_x -ge 0 && $buffer_x -lt $BASHIC_GRAPHICS_WIDTH && 
          $buffer_y -ge 0 && $buffer_y -lt $BASHIC_GRAPHICS_HEIGHT ]]; then
        local line="${BASHIC_GRAPHICS_BUFFER[$buffer_y]}"
        local new_line="${line:0:$buffer_x}${char}${line:$((buffer_x + 1))}"
        BASHIC_GRAPHICS_BUFFER[$buffer_y]="$new_line"
    fi
}

# Draw a line between two points using Bresenham's algorithm
draw_line() {
    local x1="$1"
    local y1="$2"
    local x2="$3"
    local y2="$4"
    local char="${5:-*}"
    
    debug "Drawing line from ($x1,$y1) to ($x2,$y2) with char '$char'"
    
    # Bresenham's line algorithm
    local dx=$((x2 - x1))
    local dy=$((y2 - y1))
    
    # Determine step direction
    local step_x=1
    local step_y=1
    if [[ $dx -lt 0 ]]; then
        dx=$((-dx))
        step_x=-1
    fi
    if [[ $dy -lt 0 ]]; then
        dy=$((-dy))
        step_y=-1
    fi
    
    # Determine which axis has the greater change
    local x=$x1
    local y=$y1
    
    if [[ $dx -gt $dy ]]; then
        # X-axis dominant
        local error=$((dx / 2))
        while [[ $x -ne $x2 ]]; do
            set_pixel "$x" "$y" "$char"
            error=$((error - dy))
            if [[ $error -lt 0 ]]; then
                y=$((y + step_y))
                error=$((error + dx))
            fi
            x=$((x + step_x))
        done
    else
        # Y-axis dominant
        local error=$((dy / 2))
        while [[ $y -ne $y2 ]]; do
            set_pixel "$x" "$y" "$char"
            error=$((error - dx))
            if [[ $error -lt 0 ]]; then
                x=$((x + step_x))
                error=$((error + dy))
            fi
            y=$((y + step_y))
        done
    fi
    
    # Draw the final point
    set_pixel "$x2" "$y2" "$char"
}

# Display the graphics buffer
display_graphics() {
    echo -ne "\033[H"  # Move cursor to home position
    local row=0
    while [[ $row -lt $BASHIC_GRAPHICS_HEIGHT ]]; do
        echo "${BASHIC_GRAPHICS_BUFFER[$row]}"
        row=$((row + 1))
    done
}

# Clear the graphics buffer
clear_graphics() {
    init_graphics_buffer
}

# Execute SCREEN command
execute_screen() {
    local mode="${1:-0}"
    mode=$(trim "$mode")
    
    # Evaluate mode if it's an expression
    local screen_mode=$(evaluate_expression "$mode")
    
    debug "SCREEN: Setting display mode to $screen_mode"
    
    case "$screen_mode" in
        0)
            # Text mode (80x25) - default terminal mode
            SCREEN_WIDTH=80
            debug "SCREEN 0: Text mode (80x25)"
            ;;
        1)
            # Medium resolution graphics (320x200) - simulate with wider terminal
            SCREEN_WIDTH=80  # Keep reasonable width for terminal
            debug "SCREEN 1: Medium resolution graphics mode (simulated)"
            ;;
        2)
            # High resolution graphics (640x200) - simulate with wider terminal
            SCREEN_WIDTH=80  # Keep reasonable width for terminal
            debug "SCREEN 2: High resolution graphics mode (simulated)"
            ;;
        3)
            # Extended text mode (80x25) - same as mode 0
            SCREEN_WIDTH=80
            debug "SCREEN 3: Extended text mode (80x25)"
            ;;
        4)
            # Very high resolution (640x400) - simulate with wider terminal
            SCREEN_WIDTH=80  # Keep reasonable width for terminal
            debug "SCREEN 4: Very high resolution graphics mode (simulated)"
            ;;
        *)
            debug "SCREEN $screen_mode: Unknown mode, defaulting to text mode"
            SCREEN_WIDTH=80
            ;;
    esac
    
    # Clear screen when changing modes (like GW-BASIC)
    screen_cls
}

# Execute LINE command
execute_line() {
    local stmt="${1:-}"
    stmt=$(trim "$stmt")
    
    debug "LINE command: $stmt"
    
    # Parse LINE command syntax:
    # LINE (x1,y1)-(x2,y2) [,color] [,B[F]]
    # LINE (x1,y1)-(x2,y2) [,color] [,BF]
    
    # Parse LINE command using a simpler approach
    if [[ "$stmt" =~ ^\(.*\)-\(.*\) ]]; then
        # Extract coordinates using parameter expansion
        local coords="${stmt#*(}"
        local point1="${coords%%)-*}"
        coords="${coords#*)-}"
        local point2="${coords%%)*}"
        local options="${coords#*)}"
        
        # Parse coordinates - remove parentheses and split by comma
        local coords1=$(echo "$point1" | sed 's/[()]//g')
        local coords2=$(echo "$point2" | sed 's/[()]//g')
        
        if [[ "$coords1" =~ ^([^,]+),([^,]+)$ ]]; then
            local x1=$(evaluate_expression "${BASH_REMATCH[1]}")
            local y1=$(evaluate_expression "${BASH_REMATCH[2]}")
        else
            error "Invalid LINE coordinates: $coords1"
            return
        fi
        
        if [[ "$coords2" =~ ^([^,]+),([^,]+)$ ]]; then
            local x2=$(evaluate_expression "${BASH_REMATCH[1]}")
            local y2=$(evaluate_expression "${BASH_REMATCH[2]}")
        else
            error "Invalid LINE coordinates: $coords2"
            return
        fi
        
        # Parse options
        local color="*"
        local box_mode=""
        
        if [[ -n "$options" ]]; then
            options=$(trim "$options")
            # Remove leading comma
            options="${options#,}"
            
            # Check for box mode (B or BF)
            if [[ "$options" =~ ,[[:space:]]*B[[:space:]]*F?[[:space:]]*$ ]]; then
                box_mode="${BASH_REMATCH[0]}"
                options="${options%%,*}"
            elif [[ "$options" =~ ,[[:space:]]*B[[:space:]]*$ ]]; then
                box_mode="${BASH_REMATCH[0]}"
                options="${options%%,*}"
            fi
            
            # Parse color if present
            if [[ -n "$options" ]]; then
                options=$(trim "$options")
                options="${options#,}"
                if [[ -n "$options" ]]; then
                    color=$(evaluate_expression "$options")
                fi
            fi
        fi
        
        debug "LINE: ($x1,$y1) to ($x2,$y2), color='$color', box='$box_mode'"
        
        # Draw the line or box
        if [[ -n "$box_mode" ]]; then
            # Draw box
            draw_line "$x1" "$y1" "$x2" "$y1" "$color"  # Top
            draw_line "$x2" "$y1" "$x2" "$y2" "$color"  # Right
            draw_line "$x2" "$y2" "$x1" "$y2" "$color"  # Bottom
            draw_line "$x1" "$y2" "$x1" "$y1" "$color"  # Left
            
            # If BF (box fill), fill the box
            if [[ "$box_mode" =~ BF ]]; then
                local min_x=$x1
                local max_x=$x2
                local min_y=$y1
                local max_y=$y2
                
                if [[ $x1 -gt $x2 ]]; then
                    min_x=$x2
                    max_x=$x1
                fi
                if [[ $y1 -gt $y2 ]]; then
                    min_y=$y2
                    max_y=$y1
                fi
                
                local fill_y=$((min_y + 1))
                while [[ $fill_y -lt $max_y ]]; do
                    local fill_x=$((min_x + 1))
                    while [[ $fill_x -lt $max_x ]]; do
                        set_pixel "$fill_x" "$fill_y" "$color"
                        fill_x=$((fill_x + 1))
                    done
                    fill_y=$((fill_y + 1))
                done
            fi
        else
            # Draw simple line
            draw_line "$x1" "$y1" "$x2" "$y2" "$color"
        fi
        
        # Display the graphics buffer
        display_graphics
        
    else
        error "Invalid LINE statement: $stmt"
    fi
}
