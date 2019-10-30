.pos 0x100
		ld $s, r0			# r0 = &s
		ld (r0), r0
		ld $0, r7			# r3 = i = 0
		ld $n, r4	
		ld (r4), r4			# r4 = n
		not r4
		inc r4				# r4 = -n
calculate_avg:	mov r7, r6			# r5 = i'
		add r4, r6			# r5 = i'-n
		beq r6, sort		# if(i=n), goto sort
		bgt r6, sort		# if(i>n), goto sort
		# if (i<n), continue
avg_loop:	mov r7, r2		# r2 = i
		shl $1, r2		# r2 = i*2
		mov r7, r3		# r3 = i
		shl $2, r3		# r2 = i*4
		add r3, r2		# r2 = i*6
		ld $0, r1		# r1 = sum' = 0
		# inc r2			# r2 = i*6 + 1
		inc r2 			# r2 = o = i*6 + 2 = grade[0]
		ld (r0, r2, 4), r3	# r3 = s[i] -> grade[0]
		add r3, r1		# r1 = s[i] -> grade[0]
		inc r2			# r2 = o = i*6 + 3 = grade[1]
		ld (r0, r2, 4), r3	# r3 = s[i] -> grade[1]
		add r3, r1		# r1 = s[i] -> grade[1] + s[i] -> grade[0]
		inc r2			# r2 = o = i*6 + 4 = grade[2]
		ld (r0, r2, 4), r3	# r3 = s[i] -> grade[2]
		add r3, r1		# r1 = s[i] -> grade[2] + s[i] -> grade[1] + s[i] -> grade[0]
		inc r2			# r2 = o = i*6 + 4 = grade[3]
		ld (r0, r2, 4), r3	# r3 = s[i] -> grade[3]
		add r3, r1		# r1 = s[i] -> grade[3] + s[i] -> grade[2] + s[i] -> grade[1] + s[i] -> grade[0]
		inc r2			# r2 = o = s[i] -> computed average
		# can use r3 again, only locally
		shr $2, r1
		st r1, (r0, r2, 4)	# s->base.average = average/r1
		inc r7			# i ++
		br calculate_avg   	# go back to loop


sort:		ld $0, r1			# r1 = i'

sort_loop:	mov r1, r2			# r2 = i'
		ld $n, r3	
		ld (r3), r3			# r3 = n
		not r3
		inc r3
		add r3, r2			# r2 = i'-n
		beq r2, end_loop		# if (i'=n), go to end_loop
		mov r1, r2			# r2 = i'
		inc r2				# r2 = j' = i'+1
		# top of inner loop
		# if (i<n) do conditional swap
L1:		ld $n, r3	
		ld (r3), r3		# r3 = n
		not r3
		inc r3
		mov r2, r4 		# r4 = j’ <= top of inner for loop (j’)
 		add r3, r4 		# r4 = j’ - n’
 		beq r4, L3 		# goto L3 if j’ == n’
		# do conditional swap
		br compare		# call compare

# swap[i] and swap[i+1] (s[i]->average <= s[j]->average)
compare:	mov r1, r3			# r3 = i' 
		shl $1, r3			# r3 = i*2
		mov r1, r5			# r5 = i
		shl $2, r5			# r5 = i*4
		add r5, r3			# r3 = i*6
		ld $5, r5			# r5 = 6 = position of calculated average
		add r5, r3			# r3 = 6 + i*6 

		mov r2, r6			# r6 = j' 
		shl $1, r6			# r6 = i*2
		mov r2, r7			# r7 = j
		shl $2, r7			# r7 = j*4
		add r7, r6			# r6 = j*6
		ld $5, r5			# r5 = 6 = position of calculated average
		add r5, r6			# r6 = 6 + j*6 

		# ld $6, r3			# r3 = 6 = position of calculated average
		# add r3, r2			# r2 = 6 + i*6 
		# mov r2, r4			# r4 = 6 + i*6 
		# add r3, r4			# r3 = 12 + i*6 = s[i+1]'s index for grade

		ld (r0, r3, 4), r3		# r3 = s[i]->average
		ld (r0, r6, 4), r6		# r6 = s[j]->average
		not r6
		inc r6				# r6 = -s[j]->average
		add r6, r3			# r2 = s[i]->average - s[j]->average
		bgt r3, L2		        # if (s[i]->average > s[j]->average) go back to sort
		br swap				# if (s[i]->average <= s[i+1]->average) do swap

swap:		mov r1, r3			# r3 = i' 
		shl $1, r3			# r3 = i*2
		mov r1, r5			# r5 = i
		shl $2, r5			# r5 = i*4
		add r5, r3			# r3 = i*6
		# ld $1, r4
		# add r4, r3			# r3 = 1 + i*6

		mov r2, r6			# r6 = j' 
		shl $1, r6			# r6 = i*2
		mov r2, r7			# r7 = j
		shl $2, r7			# r7 = j*4
		add r7, r6			# r6 = j*6
		# ld $1, r4
		# add r4, r6			# r6 = 1 + j*6

	# availavle: r4, r5, r7
	# swap id
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
	# swap grade[0]
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
	# swap grade[1]
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
	# swap grade[2]
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
	# swap grade[3]
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
	# swap average
		ld (r0, r3, 4), r4		# r4 = temp.id = s[i]->id
		ld (r0, r6, 4), r5		# r5 = s[j]->id'
		st r4, (r0, r6, 4)		# s[j]->id = temp.id
		st r5, (r0, r3, 4)		# s[i]-> id = r5
		inc r3				# r3 ++ = 1 + i*6 + 1
		inc r6				# r6 ++ = 1 + j*6 + 1
		# inc r1				# i++
		br L2				# goto L2
L2:		inc r2 				# j’++
 		br L1 				# goto top of inner loop <= end of inner loop
L3: 		inc r1 				# i’++
 		br sort_loop			# goto top of outer loop <= end of outer loop
# find median person write sid m
# (n-1)*3 +1
end_loop: 	
		ld $n, r1	
		ld (r1), r1			# r1 = n
		# mov r1, r3			# r3 = n 
		dec r1				# r1 = n-1 
		mov r1, r3			# r3 = n-1 
		add r1, r1			# r1 = (n-1)*2
		add r3, r1			# r1 = (n-1)*3
		ld (r0, r1, 4), r1		# r1 = s[n]->id
		ld $m, r3			# r3 = &m
		st r1, (r3)			# m = s[n]->id
		halt



.pos 0x2000	
n: 		.long 7 		# 2 students
m: 		.long 0 		# put the answer here
s: 		.long base 		# address of the array

.pos 0x5000
base: 
		.long 0001 		# student ID
 		.long 80 		# grade 0
 		.long 60 		# grade 1
 		.long 78 		# grade 2
 		.long 90 		# grade 3
 		.long 0 		# computed average0
 		.long 0002 		# student ID
 		.long 30 		# grade 0
 		.long 40 		# grade 1
 		.long 880 		# grade 2
 		.long 200 		# grade 3
 		.long 0 		# computed average1	
 		.long 0003 		# student ID
 		.long 900 		# grade 0
 		.long 400 		# grade 1
 		.long 880 		# grade 2
 		.long 200 		# grade 3
 		.long 0 		# computed average1	
 		.long 0004 		# student ID
 		.long 90 		# grade 0
 		.long 400 		# grade 1
 		.long 880 		# grade 2
 		.long 200 		# grade 3
 		.long 0 		# computed average1
 		.long 0005		# student ID
 		.long 900 		# grade 0
 		.long 400 		# grade 1
 		.long 88 		# grade 2
 		.long 200 		# grade 3
 		.long 0 		# computed average1
 		.long 0006 		# student ID
 		.long 900 		# grade 0
 		.long 400 		# grade 1
 		.long 880 		# grade 2
 		.long 20 		# grade 3
 		.long 0 		# computed average1
 		.long 0007 		# student ID
 		.long 900 		# grade 0
 		.long 400 		# grade 1
 		.long 880 		# grade 2
 		.long 200 		# grade 3
 		.long 0 		# computed average1