.pos 0x100
		ld $s, r0			# r0 = &s
		ld $0, r7			# r3 = i = 0
		ld $n, r4	
		ld (r4), r4			# r4 = n
		not r4
		inc r4				# r4 = -n
loop:		mov r7, r6			# r5 = i'
		add r4, r6			# r5 = i'-n
		beq r6, end_loop		# if(i=n), goto end_loop
		bgt r6, end_loop		# if(i>n), goto end_loop
		# if (i<n), continue
# compute average for one student and then store in memory
continue:	mov r7, r2		# r2 = i
		shl $1, r2		# r2 = i*2
		mov r7, r3		# r3 = i
		shl $2, r3		# r2 = i*4
		add r3, r2		# r2 = i*6
		ld $0, r1		# r1 = sum' = 0
		inc r2			# r2 = i*6 + 1
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
		br loop   		# go back to loop

end_loop:	halt	


.pos 0x8000
n: 		.long 2 		# 2 students
m: 		.long 0 		# put the answer here
s: 		.long base 		# address of the array

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
 		.long 88 		# grade 2
 		.long 20 		# grade 3
 		.long 0 		# computed average1