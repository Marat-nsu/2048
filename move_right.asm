asect 0xff00
matrix:
asect 0xff20
matrix_ai:

rsect move_right

slide_row_right>
	ldi r0, 3 # address of the first tile
	ldi r1, 3 # address of the first tile
	ldi r3, 0 # helper 0 for clearing tile
	ldi r7, 0
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
				ldi r6, 1 # set flag that matrix has changed
				stb r5, r1, r3 # clear tile
				stb r5, r0, r2 # move non-zero tile to the first
			fi
			add r0, -1 # move r0 to the next tile
		else
			inc r7
		fi
		add r1, -1 # move r1 to the next tile
	wend
	rts

merge_row_right>
	ldi r0, 3 # address of the first tile
	ldi r1, 2 # address of the second tile
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
		add r0, -1 # move to the next tile
		add r1, -1 # move to the next tile
	wend
	rts

process_row_right>
	jsr slide_row_right
	if
		cmp r7, 4
	is eq
		rts
	fi
	jsr merge_row_right
	if
		tst r7
	is z
		rts
	fi
	jsr slide_row_right
	rts

move_right>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix # address of processed row
	move r5, r4
	add r4, 0x10 # address of the end of the matrix
	while
		cmp r5, r4
	stays lt
		jsr process_row_right
		add r5, 4 # go to the next row
	wend
	if
		tst r6
	is z
		ldi r0, 0xff52
		ldi r1, -1
		stw r0, r1
	fi
	rts

move_right_ai>
	ldi r6, 0
	ldi r5, matrix_ai
	move r5, r4
	add r4, 0x10
	while
		cmp r5, r4
	stays lt
		jsr process_row_right
		add r5, 4
	wend
	if
		tst r6
	is z
		ldi r0, 0xff52
		ldi r1, -1
		stw r0, r1
	fi
	rts


end.
