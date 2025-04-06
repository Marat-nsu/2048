asect 0xff00
matrix:

rsect move_down

slide_col_down>
    ldi r0, 3
    ldi r1, 3
    ldi r3, 0
    ldi r7, 0
    while
        cmp r1, 0
    stays ge
        ldb r5, r1
        if
            tst r2
        is nz
            if
                cmp r0, r1
            is ne
                ldi r6, 1
                stb r5, r0, r2
                stb r5, r1, r3
            fi
            add r0, -1
        else
            inc r7
        fi
        add r1, -1
    wend
    rts

merge_col_down>
    ldi r0, 3
    ldi r1, 2
    ldi r7, 0
    while
        cmp r1, 0
    stays ge
        ldb r5, r0
        ldb r5, r1
        if
            cmp r2, r3
        is eq
            if
                tst r2
            is nz
                ldi r7, 1
                ldi r6, 1
                add r2, 1
                stb r5, r0, r2
                stb r5, r1, r3
            fi
        fi
        add r0, -1
        add r1, -1
    wend
    rts

process_col_down>
    jsr slide_col_down
    if
        cmp r7, 4
    is eq
        rts
    fi
    jsr merge_col_down
    if
        tst r7
    is z
        rts
    fi
    jsr slide_col_down
    rts

move_down>
    ldi r6, 0
    ldi r8, 0
    while
        cmp r8, 4
    stays lt
        ldi r5, matrix
        jsr process_col_down
        add r8, 1
    wend
    rts

end.