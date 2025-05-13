asect 0xff61
simulating:
asect 0xff62
evaluating:

rsect move_ai

sync_fields: ext
move_left_ai: ext
move_right_ai: ext
move_down_ai: ext
move_up_ai: ext

eval_collective: ext
eval_individual: ext

choose_move: ext

move_ai>
	ldi r0, simulating
	ldi r1, 1
	stb r0, r1 
	jsr sync_fields
	# simulation of movements
	jsr move_left_ai
	jsr move_right_ai
	jsr move_down_ai
	jsr move_up_ai

	ldi r0, simulating
	ldi r1, 0
	stb r0, r1
	ldi r0, evaluating
	ldi r1, 1
	stb r0, r1
	
	#choosing the best move
	ldi r0, 0xff10
	ldi r1, 0xff50
	while
		ldi r2, 0xff58
		cmp r1, r2
	stays lt
		push r0
		push r1
		jsr eval_collective
		jsr eval_individual
		pop r2
		pop r2
		add r0, 0x10
		add r1, 2
	wend

	ldi r0, evaluating
	ldi r1, 0
	stb r0, r1

	jsr choose_move
	rts

end.
