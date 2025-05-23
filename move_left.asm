asect 0xff00
matrix:
asect 0xff10
matrix_ai:

rsect move_left

slide_row_left>
	ldi r0, 0 # address of the first tile
	ldi r1, 0 # address of the first tile
	ldi r3, 0
	ldi r7, 0 # amount of empty tiles
	while
		cmp r1, 4
	stays lt
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
			add r0, 1 # move r0 to the next tile
		else 
			inc r7
		fi
		add r1, 1 # move r1 to the next tile
	wend
	rts

merge_row_left>
	ldi r0, 0 # address of the first tile
	ldi r1, 1 # address of the second tile
	ldi r7, 0 # has row been changed
	while
		cmp r1, 4
	stays lt
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
		add r0, 1 # go to the next tile
		add r1, 1 # go to the next tile
	wend
	rts

process_row_left>
	jsr slide_row_left
	if
		cmp r7, 4 # if row is empty, there is nothing we can do
	is eq
		rts
	fi
	jsr merge_row_left
	if
		tst r7 # if row hasn't been changed, there is nothing we can do
	is z
		rts
	fi
	jsr slide_row_left
	rts

move_left>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix # address of processed row
	move r5, r4
	add r4, 0x10 # address of end of the matrix
	while
		cmp r5, r4
	stays lt
		jsr process_row_left
		add r5, 4 # go to the next row
	wend
	if
		tst r6
	is z
		ldi r0, 0xff50
		ldi r1, -1
		stw r0, r1
	fi
	rts

# same function as move_left, but with different game field address
move_left_ai>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix_ai
	move r5, r4
	add r4, 0x10
	while
		cmp r5, r4
	stays lt
		jsr process_row_left
		add r5, 4
	wend
	if
		tst r6
	is z
		ldi r0, 0xff50
		ldi r1, -1
		stw r0, r1
	fi
	rts

end.
