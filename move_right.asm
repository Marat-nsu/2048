asect 0xff00
matrix:

rsect move_right

slide_row_right>
	ldi r0, 3
	ldi r1, 3
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
				stb r5, r0, r2 # move non-zero tile to the first
				stb r5, r1, r3 # clear tile
			fi
			add r0, -1 # move r0 to the next tile
		else
			inc r7
		fi
		add r1, -1
	wend
	rts

merge_row_right>
	ldi r0, 3
	ldi r1, 2
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
		add r0, -1
		add r1, -1
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
	# r5 address of current row
	ldi r5, matrix
	ldi r4, 0xff10 # end of matrix
	while
		cmp r5, r4
	stays lt
		jsr process_row_right
		add r5, 4
	wend
	rts

end.