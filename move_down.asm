asect 0xff00
matrix:
asect 0xff30
matrix_ai:

rsect move_down


slide_col_down>
	ldi r0, 12 # address of bottom tile
	ldi r1, 12 # same address
	ldi r7, 0
	ldi r3, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			if
				cmp r0, r1
			is ne
				ldi r6, 1 # has matrix been changed
				stb r5, r1, r3 # clear tile
				stb r5, r0, r2 # move non-zero tile to the first
			fi
			sub r0, 4 # move r0 to the next tile
		else
			inc r7
		fi
		sub r1, 4 # move r1 to the next tile
	wend
	rts

merge_col_down>
	ldi r0, 12 # address of the first tile
	ldi r1, 8 # address of the second tile
	ldi r7, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r0, r2
		ldb r5, r1, r3
		if
			cmp r2, r3
		is eq
			if
				tst r2
			is nz
				ldi r7, 1
				ldi r6, 1 # set flag that matrix has changed
				add r2, 1
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
			fi
		fi
		sub r0, 4 # go to the next tile
		sub r1, 4 # go to the next tile
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
	# r6 has matrix changed
	ldi r5, matrix # address of processed column
	move r5, r4
	add r4, 4 # address of the last column
	while
		cmp r5, r4
	stays lt
		jsr process_col_down
		add r5, 1 # go to the next column
	wend
	if
		tst r6
	is z
		ldi r0, 0xff54
		ldi r1, -1
		stw r0, r1
	fi
	rts

move_down_ai>
	ldi r6, 0
	ldi r5, matrix_ai
	move r5, r4
	add r4, 4
	while
		cmp r5, r4
	stays lt
		jsr process_col_down
		add r5, 1
	wend
	if
		tst r6
	is z
		ldi r0, 0xff54
		ldi r1, -1
		stw r0, r1
	fi
	rts


end