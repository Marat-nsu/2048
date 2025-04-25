asect 0xfefe
random:
asect 0xff00
matrix:
rsect place_tile
macro mod/2
	while
		cmp $1, $2
	stays ge
		sub $1, $2, $1
	wend
mend


# count empty tiles and store it to r0
count_empty>
	ldi r0, 0
	ldi r1, 0
	ldi r2, matrix
	while
		cmp r1, 16
	stays lt
		if
			ldb r2, r1, r3
			tst r3
		is z
			inc r0
		fi
		add r1, 1
	wend
	rts

# choose 2 or 4 and store it to r0
choose_tile>
	ldi r0, 0
	ldi r1, random
	ldw r1, r1
	shra r1
	addc r0, r0, r0 
	add r0, 1 # C is set to 0 or 1, we add 1 to get valid power of 2
	rts

place_tile>
	# setup
	jsr choose_tile
	move r0, r4
	jsr count_empty
	if
		tst r0
	is z
		rts
	fi
	move r4, r1 # r0 - amount of empty tiles, r1 - selected tile
	ldi r2, random
	ldw r2, r2
	mod r2, r0 # r2 - number of empty tile where we will place r1
	# place
	ldi r3, 0 # current tile index
	ldi r4, matrix
	ldi r5, 0 # amount of empty tiles
	while
		cmp r3, 16
	stays lt
		if
			ldb r4, r3, r6
			tst r6
		is z
			if
				cmp r5, r2
			is eq
				stb r4, r3, r1
				break
			fi
			inc r5
		fi
		add r3, 1
	wend
	rts
end.
