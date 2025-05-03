rsect eval_collective


# r0 - current row
eval_row>
	push r7
	ldsp r7
	addsp -4


	ldi r2, 0
	ssw r2, -2
	ssw r2, -4
	ldi r3, 1
	ldi r6, 0
	while
		cmp r3, 4
	stays lt
		ldb r0, r2, r4
		ldb r0, r3, r5
		if
			cmp r4, r5
		is eq
			lsw r6, -2 # store merge/mono
			inc r6
			ssw r6, -2
		fi
		if
			cmp r4, r5
		is le
			sub r4, r5, r4
		else
			sub r5, r4, r4
		fi
		lsw r5, -4
		sub r5, r4, r5
		ssw r5, -4
		inc r2
		inc r3
	wend
	lsw r2, -4
	lsw r3, -2
	addsp 4
	pop r7
	rts

# r0 - current column
eval_column>
	push r7
	ldsp r7
	addsp -4


	ldi r2, 0
	ssw r2, -2
	ssw r2, -4
	ldi r3, 4
	ldi r6, 0
	while
		cmp r3, 16
	stays lt
		ldb r0, r2, r4
		ldb r0, r3, r5
		if
			cmp r4, r5
		is eq
			lsw r6, -2 # store merge/mono
			inc r6
			ssw r6, -2
		fi
		if
			cmp r4, r5
		is le
			sub r4, r5, r4
		else
			sub r5, r4, r4
		fi
		lsw r5, -4
		sub r5, r4, r5
		ssw r5, -4
		add r2, 4
		add r3, 4
	wend
	lsw r2, -4
	lsw r3, -2
	addsp 4
	pop r7
	rts

# fp + 6 = matrix address
# fp + 4 = result address
# fp - 0 = smoothnes
# fp - 2 = merge
# fp - 4 = mono
eval_collective>
	push r7
	ldsp r7
	addsp -6

	lsw r0, 6 #matrix begin
	lsw r1, 6
	add r1, 0x10 #matrix end
	# rows
	while
		cmp r0, r1
	stays lt
		jsr eval_row
		# smoothnes
		lsw r4, 0
		add r2, r4, r4
		ssw r4, 0
		# merge
		lsw r4, -2
		add r3, r4, r4
		ssw r4, -2
		add r0, 4
	wend

	# columns
	lsw r0, 6
	lsw r1, 6
	add r1, 4
	while
		cmp r0, r1
	stays lt
		jsr eval_column
		# smoothnes
		lsw r4, 0
		add r2, r4, r4
		ssw r4, 0
		# merge
		lsw r4, -2
		add r3, r4, r4
		ssw r4, -2
		add r0, 1
	wend

	# Эта функция очищает значение которое хранилось по 
	# адресу result, 
	# функция eval_individual должна не записать оценку в result,
	# а добавить свою оценку к result
	lsw r0, 0 # smoothnes
	shl r0, 3 # weight smooth
	lsw r1, -2 # merge
	neg r0
	move r0, r3
	shl r1, r2, 5 # коэффициент merge - 32
	add r2, r3, r3
	
	add r1, 24 # mono = merge + 24
	shl r1, r1, 1 # коэффициент mono - 2
	add r1, r3, r3
	lsw r4, 4 # result
	stw r4, r3
	lsw r0, 6
	lsw r1, 4
	addsp 6
	pop r7
	rts

end.