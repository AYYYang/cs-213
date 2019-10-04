.pos 0x100
		# tmp = 0;
		# tos = 0;
		ld $0, r0			# r0 = 0
		ld $tmp, r1			# r1 = address of tmp
		ld $tos, r2			# r2 = address of tos
		st r0, (r1) 		# tmp = 0 
		st r0, (r2) 		# tos = 0
		# s[tos] = a[0];
		ld (r2), r2			# r2 = tos = 0
		ld $s, r3			# r3 = address of s
		ld $a, r4			# r4 = address of a[0]
		ld (r4), r4			# r4 = a[0]
		st r4, (r3, r2, 4)  # s[tos] = a[0]
		# tos++;
		ld $tos, r0			# r0 = address of tos
		ld (r0), r1			# r1 = tos
		inc r1				# r1 ++
		st r1, (r0) 		# tos ++
		# s[tos] = a[1]; this works
		ld $tos, r0		    # r0 = address of tos
		ld (r0), r4			# r4 = tos
		ld $a, r1			# r1 = address a[0]
		ld $s, r3			# r3 = address of s[0]
		ld 4(r1), r1		# r1 = a[1]
		st r1, (r3, r4, 4)	# s[tos] = a[1]
		# tos ++
		inc r4				# r4 ++
		st r4, (r0)			# tos ++
		# s[tos] = a[2];
		ld $tos, r0		    # r0 = address of tos
		ld (r0), r4			# r4 = tos
		ld $a, r1			# r1 = address a[0]
		ld $s, r3			# r3 = address of s[0]
		ld 8(r1), r1		# r1 = a[1]
		st r1, (r3, r4, 4)	# s[tos] = a[2]
		# tos ++
		inc r4				# r4 ++
		st r4, (r0)			# tos ++
	    # tos--;
	    dec r4				# r4 --
		st r4, (r0)			# tos --
		# tmp = s[tos];
		ld $tmp, r2			# r2 = address of tmp
		st r1, (r2)			# tmp = s[tos]
	    # tos--;
	    dec r4				# r4 --
		st r4, (r0)			# tos --
		# tmp = tmp + s[tos]; works
		ld (r2), r5			# r5 = tmp
		ld $s,   r3 		# r3 = s[0]
		ld (r3, r4, 4), r6	# r6 = s[tos]
		add r5, r6			# r6 = tmp + s[tos]
		st r6, (r2) 		# tmp = tmp + s[tos]
		# tos--;
		dec r4				# r4 --
		st r4, (r0)			# tos --
		# tmp = tmp + s[tos]; works
		ld (r2), r5			# r5 = tmp
		ld $s,   r3 		# r3 = s[0]
		ld (r3, r4, 4), r6	# r6 = s[tos]
		add r5, r6			# r6 = tmp + s[tos]
		st r6, (r2) 		# tmp = tmp + s[tos]

.pos 0x200
a:  	.long 1             # a[0]
    	.long 2             # a[1]
    	.long 7             # a[2]
s:  	.long 0             # s[0]
    	.long 1             # s[1]
    	.long 4             # s[2]
    	.long 5             # s[3]
    	.long 8             # s[4]
tos:	.long 0				# tos
tmp:    .long 0				# tmp

