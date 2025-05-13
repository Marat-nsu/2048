rsect sync_fields

sync_fields>
	ldi r0, 0xff00
	ldi r1, 0xff10
	ldi r2, 0xff20
	ldi r3, 0xff30
	ldi r4, 0xff40

	ldi r5, 0

	while
		cmp r5, 0x10
	stays lt
		# Загрузили две ячейки из главного поля
		ldw r0, r5, r6

		# Синхронизируем
		stw r1, r5, r6
		stw r2, r5, r6
		stw r3, r5, r6
		stw r4, r5, r6

		add r5, 2
	wend
	rts
end.