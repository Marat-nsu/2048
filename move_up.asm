asect 0xff00
matrix:

rsect move_up

slide_col_up>
    ldi r0, 0
    ldi r1, 0
    ldi r3, 0
    ldi r7, 0
    while
        cmp r1, 4
    stays lt
        ldi r2, 0
        ldb r2, r5, r1
        if
            tst r2
        is nz
            if
                cmp r0, r1
            is ne
                ldi r6, 1
                stb r2, r5, r0
                stb r3, r5, r1
            fi
            add r0, 1
        else
            inc r7
        fi
        add r1, 1
    wend
    rts

merge_col_up>
    ldi r0, 0
    ldi r1, 1
    ldi r7, 0
    while
        cmp r1, 4
    stays lt
        ldi r2, 0
        ldi r3, 0
        ldb r2, r5, r0
        ldb r3, r5, r1
        if
            cmp r2, r3
        is eq
            if
                tst r2
            is nz
                ldi r7, 1
                ldi r6, 1
                add r2, 1
                stb r2, r5, r0
                stb r3, r5, r1
            fi
        fi
        add r0, 1
        add r1, 1
    wend
    rts

process_col_up>
    jsr slide_col_up
    if
        cmp r7, 4
    is eq
        rts
    fi
    jsr merge_col_up
    if
        tst r7
    is z
        rts
    fi
    jsr slide_col_up
    rts

move_up>
    ldi r6, 0
    ldi r4, 0
    while
        cmp r4, 4
    stays lt
        ldi r5, matrix
        jsr process_col_up
        add r4, 1
    wend
    rts

end.