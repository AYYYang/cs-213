.pos 0x100
		ld $i, r0			# r0 = &i'
		ld (r0), r0 		# r0 = i' = -1
		inc r0				# i' = 0
		ld $n, r3	
		ld (r3), r3			# r3 = n'
		not r3	
		inc r3				# r3 = -n'
		ld $c, r4			
		ld (r4), r4			# r4 = c'

loop:	mov r0, r5			# r5 = r0 = i'
		add r3, r5			# r3 = i'- n'
		bgt r5, end_loop	# if (i>n) goto end_loop
		beq r5, end_loop	# if (i=n) goto end_loop
		# continue with the loop
		ld $a, r1			# r1 = &a
		ld (r1, r0, 4), r1	# r1 = a[i]'
		ld $b, r2			# r2 = &b
		ld (r2, r0, 4), r2  # r2 = b[i]'
		not r2
		inc r2
		add r2, r1			# r1 = a[i] - b[i]
		inc r0				# i++
		bgt r1, ADD 		# if(a[i] > b[i]), goto ADD
		# else go back to loop
ELSE:	br loop
ADD: 	inc r4				# r4 = c' + 1
		br loop

end_loop:	ld $c, r1			
			st r4, (r1) 	# c = c'
			ld $i, r1
			st r0, (r1)
			halt


.pos 0x1000
i: 	.long 0xffffffff	
n: 	.long 0x5
a: 	.long 0xa
	.long 0x14
	.long 0x1e
	.long 0x28
	.long 0x32
b:	.long 0xb
	.long 0x14
	.long 0x1c
	.long 0x2c
	.long 0x30
c:	.long 0x00
