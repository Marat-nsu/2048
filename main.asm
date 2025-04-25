asect 0xfefc
is_game_over:


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
    ldi r0, 0xff00
    ldi r1, 1
    ldi r2, 0
    stb r0, r2, r1
    halt

default_handler2>
    ldi r0, 0xff00
    ldi r1, 2
    ldi r2, 0
    stb r0, r2, r1
    halt

default_handler3>
    ldi r0, 0xff00
    ldi r1, 3
    ldi r2, 0
    stb r0, r2, r1
    halt

default_handler4>
    ldi r0, 0xff00
    ldi r1, 4
    ldi r2, 0
    stb r0, r2, r1
    halt


# Main program section
rsect main

choose_move: ext
place_tile: ext
move_left: ext
move_right: ext
eval_collective: ext
move_down: ext
move_up: ext
eval_individual: ext

main>
    jsr place_tile
	jsr place_tile

    while
        ldi r0, is_game_over
        ldb r0, r0
        tst r0
    stays z
        #simulation of movements
        jsr move_left
        jsr move_right
        jsr move_down
        jsr move_up
        
        #choosing the best move
        ldi r0, 0xff10
        ldi r1, 0xff50
        while
            ldi r2, 0xff58
            cmp r1, r2
        stays lt
            push r0
            push r1
            jsr eval_collective
            pop r2
            pop r2
            push r0
            push r1
            jsr eval_individual
            pop r2
            pop r2
            add r0, 0x10
            add r1, 2
        wend

        jsr choose_move
        jsr place_tile
    wend

	halt
end.
