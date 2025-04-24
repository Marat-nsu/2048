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
    halt

default_handler2>
    halt

default_handler3>
    halt

default_handler4>
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
        ldi r0, 0xff00
        ldi r1, 0xff50
        while
            ldi r2, 0xff58
            cmp r1, r2
        stays lt
            push r0
            push r1
            jsr eval_collective
            push r0
            push r1
            jsr eval_individual

            pop r1
            pop r0
            pop r1
            pop r0

            add r0, 0x10
            add r1, 2
            
        #2048 in the tile 
        #(check of the end)
            # ldi r0, 0xff07
            # ldi r2, 11
            # stb r0, r2
        wend

        jsr choose_move

        jsr place_tile
    wend

	halt
end.













#>
####complex check for move_up and move_down
    # ldi r2, 1
    # ldi r0, 0xff00
    # ldi r1, 0xff04
    # stb r0, r2
    # stb r1, r2
    

    # ldi r0, 0xff01
    # ldi r1, 0xff09
    # stb r0, r2
    # stb r1, r2
    # ldi r0, 0xff05
    # ldi r1, 0xff0d
    # stb r0, r2
    # stb r1, r2


    # ldi r0, 0xff03
    # stb r0, r2


    # ldi r0, 0xff0a
    # ldi r1, 0xff06
    # stb r0, r2
    # stb r1, r2

    # ldi r2, 2
    # ldi r0, 0xff08
    # stb r0, r2

    # ldi r0, 0xff02
    # stb r0, r2
####complex check for move_up and move_down
#<

#>
####complex check for move_left and move_right
    # ldi r2, 1
    # ldi r0, 0xff00
    # ldi r1, 0xff01
    # stb r0, r2
    # stb r1, r2
    # ldi r0, 0xff02
    # ldi r1, 0xff03
    # stb r0, r2
    # stb r1, r2
    

    # ldi r0, 0xff04
    # ldi r1, 0xff05
    # stb r0, r2
    # stb r1, r2
    


    # ldi r0, 0xff08
    # stb r0, r2


    # ldi r0, 0xff0c
    # ldi r1, 0xff0d
    # stb r0, r2
    # stb r1, r2

    # ldi r0, 0xff0e
    # stb r0, r2
    # ldi r2, 2

    # ldi r0, 0xff06
    # stb r0, r2
####complex check for move_left and move_right
#<
