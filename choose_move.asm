
rsect choose_move


move_matrix>
    #r0 - address of needed matrix
    #r2 - address of main matrix
    ldi r6, 0x10
    add r0, r6, r1
    ldi r2, 0xff00
    while
        cmp r0, r1
    stays lt
        ldb r0, r3
        stb r2, r3

        inc r0
        inc r2
    wend
    rts


choose_move>

    # ldw
    # stw

    # find max
    ldi r0, 0
    ldi r1, 0xff50
    ldw r1, r0, r3 #maximum
    move r1, r4    #address of max value
    while
        cmp r0, 4
    stays lt
        
        ldw r1, r0, r2 #current value
        if
            cmp r3, r2
        is lt
            inc r4 
            move r2, r3
        fi
        add r1, 1
        inc r0
    wend



    # choose address of needed matrix
    ldi r1, 0xff50
    if
        cmp r1, r4
    is z
        # 0xff10 - 0xff20
        ldi r0, 0xff10
        jsr move_matrix
    else 
        if
            inc r1
            cmp r1, r4
        is z
            # 0xff20 - 0xff30
            ldi r0, 0xff20
            jsr move_matrix
        else 
            if
                inc r1
                cmp r1, r4
            is z
                # 0xff30 - 0xff40
                ldi r0, 0xff30
                jsr move_matrix
            else
                # 0xff40 - 0xff50
                ldi r0, 0xff40
                jsr move_matrix
            fi
        fi
    fi
    rts
end.
