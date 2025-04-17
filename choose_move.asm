
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

    # find max
    ldi r0, 0
    ldi r1, 0xff50
    ldw r1, r0, r3 #maximum
    ldi r4, 0xff10 # Поле с максимальной оценкой
    ldi r5, 0xff10 # Поле для текущей оценки
    while
        cmp r0, 4
    stays lt
        
        ldw r1, r0, r2 #current value
        if
            cmp r3, r2
        is lt
            move r5, r4 #address of max value
        fi
        add r1, 2
        add r5, 0x10
        inc r0
    wend

    move r4, r0
    jsr move_matrix

    rts
end.