asect 0xfefc
is_game_over:

asect 0xfefa
direction:

asect 0xfef8
is_ai:

asect 0xff60
status:

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
        if
            ldi r0, is_ai
            ldw r0, r0
            tst r0
        is nz
            jsr move_ai
        else
            while
                ldi r0, is_ai
                ldw r0, r0
                tst r0
            stays z
                ldi r0, status
                ldi r1, 1
                stb r0, r1
                ldi r0, direction
                ldw r0, r0
                if
                    tst r0
                is z
                    continue
                fi

                # Влево
                if
                    cmp r0, 1
                is eq
                    ldi r0, status
                    ldi r1, 0
                    stb r0, r1
                    jsr move_left
                    break
                fi

                # Вправо
                if
                    cmp r0, 2
                is eq
                    ldi r0, status
                    ldi r1, 0
                    stb r0, r1
                    jsr move_right
                    break
                fi

                # Вниз
                if
                    cmp r0, 4
                is eq
                    ldi r0, status
                    ldi r1, 0
                    stb r0, r1
                    jsr move_down
                    break
                fi

                # Вверх
                if
                    cmp r0, 8
                is eq
                    ldi r0, status
                    ldi r1, 0
                    stb r0, r1
                    jsr move_up
                    break
                fi
            wend
            ldi r0, status
            ldi r1, 0
            stb r0, r1
            if
                ldi r0, is_ai
                ldw r0, r0
                tst r0
            is nz
                jsr move_ai
            fi
        fi
        jsr place_tile
    wend

	halt
end.
