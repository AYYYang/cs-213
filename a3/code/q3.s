.pos 0x100
	# a = 3;
	ld $a, r0		# r0 = address of a
	ld $3, r7		# r7 = 3
	st r7, (r0)		# a =3
	# p = &a;
	ld $p, r1		# r1 = address of p
	st r0, (r1)		# p = &a
	# *p = *p - 1; change a to be a - 1
	ld (r1), r3		# r3 = p
	ld (r3), r2		# r2 = *p
	dec r2			# r2 = *p - 1
	st r2, (r0)		# *p = *p - 1
	# p = &b[0];
	ld $b, r3		# r3 = address of b[0]
	st r3, (r1) 	# p = &b[0]
	# p++; == p+1 == *(p+1) inca 
	ld (r1), r2		# r2 = p
	inca r2			# r2 ++ 
	st r2, (r1)		# p ++
	# p[a] = b[a]; p[a] == *(p+a)
	ld (r0), r2		# r2 = a
	ld (r3, r2, 4), r4	# r4 = b[a]
	ld (r1), r5		# r5 = *p
	st r4, (r5, r2, 4) 	# p[a] = b[a] OR *(p+a) = b[a]
	# *(p+3) = b[0];
	ld (r3), r6		# r6 = b[0]
	ld (r1), r5		# r5 = *p
	st r6, (r5, r7, 4) # *(p+3) = b[0]
.pos 0x200
# Data area
a:  .long 1             # a
p:  .long 0             # p
b:  .long 2             # b[0]
    .long 3             # b[1]
    .long 7             # b[2]
    .long 5             # b[3]
    .long 8             # b[4]
