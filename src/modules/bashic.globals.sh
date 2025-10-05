#!/bin/bash
# BASHIC Global Variables Module
# bashic.globals.sh - Shared global variables across all modules

# Core program state
declare -g -A NUMERIC_VARS
declare -g -A STRING_VARS
declare -g -A PROGRAM_LINES
declare -g -A ARRAYS

# Control flow stacks
declare -g -a GOSUB_STACK
declare -g -a FOR_STACK
declare -g -a WHILE_STACK

# Data handling
declare -g -a DATA_ITEMS
declare -g DATA_POINTER

# Program execution state
declare -g RUNNING
declare -g CURRENT_LINE
declare -g DEBUG

# Random number generation
declare -g RANDOM_SEED

# Graphics state
declare -g -a BASHIC_GRAPHICS_BUFFER
declare -g BASHIC_GRAPHICS_WIDTH
declare -g BASHIC_GRAPHICS_HEIGHT

# Keyboard input
declare -g BASHIC_INKEY_BUFFER
declare -g BASHIC_INKEY_SEMAPHORE
