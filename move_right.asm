asect 0xff00
matrix:

rsect move_right

slide_row_right>
	ldi r0, 3 # адрес первой ячейки
	ldi r1, 3 # адрес первой ячейки
	ldi r3, 0 # helper 0 for clearing tile
	ldi r7, 0
	while
		cmp r1, 0
	stays ge
		ldb r5, r1, r2
		if
			tst r2
		is nz
			ldi r6, 1 # set flag that matrix has changed
			add r5, 0x20
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r5, 0x20
			add r0, -1 # сдвигаем r0 на следующую ячейку
		else
			inc r7
		fi
		add r1, -1 # сдвигаем r1 на следующую ячейку
	wend
	rts

merge_row_right>
	ldi r0, 3 # адрес первой ячейки
	ldi r1, 2 # адрес второй ячейки
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
				add r5, 0x20
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
				sub r5, 0x20
			fi
		fi
		add r0, -1 # переходим на следующую ячейку
		add r1, -1 # переходим на следующую ячейку
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
	ldi r5, matrix # адрес обрабатываемого ряда
	ldi r4, 0xff10 # адрес конца матрицы
	while
		cmp r5, r4
	stays lt
		jsr process_row_right
		add r5, 4 # переходим на следующий ряд
	wend
	rts

end.