asect 0xfefc
is_game_over:


asect 0
main: ext               # Declare labels




default_handler: ext    # as external

# Interrupt vector table (IVT)
# Place a vector to program start and
# map all internal exceptions to default_handler
dc main, 0              # Startup/Reset vector
dc default_handler, 0   # Unaligned SP
dc default_handler, 0   # Unaligned PC
dc default_handler, 0   # Invalid instruction
dc default_handler, 0   # Double fault
align 0x80              # Reserve space for the rest 
                        # of IVT

# Exception handlers section
rsect exc_handlers

# This handler halts processor
default_handler>
    halt

# Main program section
rsect main

#
# БАЗА
#

choose_move: ext
place_tile: ext

#
# ХОД ИГРОКА
#

move_left: ext
move_right: ext
move_down: ext
move_up: ext

#
# ИИ
#

move_left_ai: ext
move_right_ai: ext
move_down_ai: ext
move_up_ai: ext

eval_collective: ext
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
