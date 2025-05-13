asect 0xff63
choosing:

rsect choose_move


move_matrix>
    #r0 - address of needed matrix
    #r1 - address of main matrix
    ldi r1, 0xff00
    ldi r2, 0xff10
    ldi r3, 0xff20
    ldi r4, 0xff30
    ldi r5, 0xff40
    ldi r6, 0
    while
        cmp r6, 0x10
    stays lt
        ldb r0, r6, r7
        stb r1, r6, r7
        ldi r7, 0
        # Очищаем поля
        stb r2, r6, r7
        stb r3, r6, r7
        stb r4, r6, r7
        stb r5, r6, r7

        add r6, 1
    wend
    rts


choose_move>
    ldi r0, choosing
    ldi r1, 1
    stb r0, r1

    # find max
    ldi r0, 0
    ldi r1, 0xff50
    ldw r1, r0, r3 #maximum
    ldi r4, 0xff10 # Поле с максимальной оценкой
    ldi r5, 0xff10 # Поле для текущей оценки
    ldi r6, 0
    while
        cmp r0, 4
    stays lt
        
        ldw r1, r6, r2 #current value
        if
            cmp r3, r2
        is ls
            move r5, r4 #address of max value
        fi
        add r1, 2
        add r5, 0x10
        inc r0
    wend

    move r4, r0
    jsr move_matrix

    ldi r0, choosing
    ldi r1, 0
    stb r0, r1
    rts
end.