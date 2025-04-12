asect 0xff00
matrix:

rsect move_left

slide_row_left>
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 0 # адрес первой ячейки
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
				add r5, 0x10
				stb r5, r0, r2 # move non-zero tile to the first
				stb r5, r1, r3 # clear tile
				sub r5, 0x10
			fi
			add r0, 1 # сдвигаем r0 на следующую ячейку
		else 
			inc r7
		fi
		add r1, 1 # сдвигаем r1 на следующую ячейку
	wend
	rts

merge_row_left>
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 1 # адрес второй ячейки
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
				add r5, 0x10
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
				sub r5, 0x10
			fi
		fi
		add r0, 1 # переходим на следующую ячейку
		add r1, 1 # переходим на следующую ячейку
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
	ldi r5, matrix # адрес обрабатываемого ряда
	ldi r4, 0xff10 # адрес конца матрицы
	while
		cmp r5, r4
	stays lt
		jsr process_row_left
		add r5, 4 # переходим на следующий ряд
	wend
	rts

end.