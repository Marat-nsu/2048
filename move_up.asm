asect 0xff00
matrix:

rsect move_up

slide_row_up>
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 0 # адрес первой ячейки
	ldi r7, 0 # amount of empty tiles
	while
		cmp r1, 16
	stays lt
		ldb r5, r1, r2
		if
			tst r2
		is nz
			if
				cmp r0, r1
			is ne
				ldi r6, 1 # set flag that matrix has changed
				add r5, 0x30
				add r5, 0x10 # 0x40 не влезает в imm6
				stb r5, r0, r2 # move non-zero tile to the first
				ldi r3, 0
				stb r5, r1, r3 # clear tile
				sub r5, 0x30
				sub r5, 0x10
			fi
			add r0, 4 # сдвигаем r0 на следующую ячейку
		else 
			inc r7
		fi
		add r1, 4 # сдвигаем r1 на следующую ячейку
	wend
	rts

merge_row_up>
	ldi r0, 0 # адрес первой ячейки
	ldi r1, 4 # адрес второй ячейки
	ldi r7, 0 # has row been changed
	while
		cmp r1, 16
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
				add r5, 0x30
				add r5, 0x10 # 0x40 не влезает в imm6
				stb r5, r0, r2
				ldi r3, 0
				stb r5, r1, r3
				sub r5, 0x30
				sub r5, 0x10
			fi
		fi
		add r0, 4 # переходим на следующую ячейку
		add r1, 4 # переходим на следующую ячейку
	wend
	rts

process_row_up>
	jsr slide_row_up
	if
		cmp r7, 4 # if row is empty, there is nothing we can do
	is eq
		rts
	fi
	jsr merge_row_up
	if
		tst r7 # if row hasn't been changed, there is nothing we can do
	is z
		rts
	fi
	jsr slide_row_up
	rts

move_up>
	ldi r6, 0
	# r6 has matrix changed
	ldi r5, matrix # адрес обрабатываемого столбца
	ldi r4, 0xff04 # адрес последнего столбика
	while
		cmp r5, r4
	stays lt
		jsr process_row_up
		add r5, 1 # переходим на следующий ряд
	wend
	rts

end.