asect 0
main: ext               # Declare labels

default_handler1: ext    # as external
default_handler2: ext
default_handler3: ext
default_handler4: ext

# Interrupt vector table (IVT)
# Place a vector to program start and
# map all internal exceptions to default_handler
dc main, 0              # Startup/Reset vector
dc default_handler1, 0   # Unaligned SP
dc default_handler2, 0   # Unaligned PC
dc default_handler3, 0   # Invalid instruction
dc default_handler4, 0   # Double fault
align 0x80              # Reserve space for the rest 
                        # of IVT

# Exception handlers section
rsect exc_handlers

# This handler halts processor
default_handler1>
    halt

default_handler2>
    halt

default_handler3>
    halt

default_handler4>
    halt


# Main program section
rsect main

place_tile: ext
move_left: ext
move_right: ext
eval_collective: ext
move_down: ext
move_up: ext

main>
	jsr place_tile
    jsr move_down
    jsr place_tile
    jsr move_right
    jsr place_tile
    jsr move_up
    jsr place_tile
    jsr move_left
    jsr place_tile
    jsr move_down

	halt
    # your code here

end.