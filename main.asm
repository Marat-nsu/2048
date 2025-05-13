asect 0xfefc
is_game_over:

asect 0xfefa
direction:

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

place_tile: ext
sync_fields: ext

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

move_ai: ext


main>
    jsr place_tile
	jsr place_tile

    while
        ldi r0, is_game_over
        ldb r0, r0
        tst r0
    stays z
        jsr move_ai
        jsr place_tile
    wend

	halt
end.
