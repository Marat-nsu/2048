rsect eval_individual

# fp + 6 = matrix address
# fp + 4 = result address
# fp - 0 = corner_score
# fp - 2 = free_score

eval_individual>
    push r7
    ldsp r7
    addsp -6


    ldi r2, 0       # cur_idx
    ldi r3, 0       # cur_val
    ldi r4, 0       # max
    ldi r5, 0       # max_position
    ldi r6, 0       # free_count

    lsw r0, 6
    while
        cmp r2, 16 
    stays lt
        ldb r0, r2, r3  

        # find maximum
        if
            cmp r3, r4
        is gt
            move r3, r4
            move r2, r5
        fi

        # count empty
        if
            tst r3
        is z
            inc r6
        fi

        inc r2
    wend

    # corner
    ldi r1, 0
    if
        cmp r5, 0
    is eq
        ldi r1, 1
    fi
    if
        cmp r5, 3
    is eq
        ldi r1, 1
    fi
    if
        cmp r5, 12
    is eq
        ldi r1, 1
    fi    
    if
        cmp r5, 15
    is eq
        ldi r1, 1
    fi


    ssw r1, 0       # corner_score
    ssw r6, -2       # free_score

    lsw r0, 0       # corner
    lsw r1, -2       # free

    
    shl r0, r0, 2   # corner_coef = 4
    shl r1, r1, 2   # free_coef = 4
    add r0, r1, r2 

    lsw r3, 4       # result adress
    ldw r3, r4      
    add r4, r2, r4  
    stw r3, r4     

	lsw r0, 6
	lsw r1, 4
    addsp 6
    pop r7
    rts

end.