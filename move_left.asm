asect 0xff00
matrix:

rsect move_left


final_slide_row_left>
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 0 # адрес первой ячейки
	ldi r3, 0
	while
		cmp r1, 4
	stays lt
		ldb r5, r1, r2
		if
			tst r2
		is nz
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			add r0, 1 # сдвигаем r0 на следующую ячейку
		fi
		add r1, 1 # сдвигаем r1 на следующую ячейку
	wend
	rts

slide_row_left>

	ldi r3, 0 # helper 0 for clearing tile

	# обнуление строк
	add r5, 0x10
	ldi r0, 0
	ldi r1, 0
	while
		cmp r1, 4 
	stays lt
		stb r5, r0, r3
		inc r0
		inc r1
	wend
	sub r5, 0x10
	
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 0 # адрес первой ячейки

	ldi r7, 0 # amount of empty tiles
	while
		cmp r1, 4
	stays lt
		ldb r5, r1, r2
		if
			tst r2
		is nz
			ldi r6, 1 # set flag that matrix has changed
			add r5, 0x10
			stb r5, r1, r3 # clear tile
			stb r5, r0, r2 # move non-zero tile to the first
			sub r5, 0x10
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

	add r5, 0x10

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
		add r0, 1 # переходим на следующую ячейку
		add r1, 1 # переходим на следующую ячейку
	wend

	sub r5, 0x10
	
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

		add r5, 0x10
		jsr final_slide_row_left
		sub r5, 0x10

		add r5, 4 # переходим на следующий ряд
	wend
	rts

end.
