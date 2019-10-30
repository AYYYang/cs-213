# 1. Compute the average grade for a single student and store it in the struct. For simplicity, you
#  can ignore the fractional part of the average; i.e., you do not need to round. 
# struct Student {
#  int sid;
#  int grade[4];
#  int average; // this is computed by your program
# };
# int n; // number of students
# int m; // you store the median student’s id here
# struct Student* s; // a dynamic array of n students

# average = sum/count;
# r0 = &s
# r1 = sum
# r2 is used as current grade

.pos 0x100	
		ld $s, r0			# r0 = &s
		ld $2, r2
		ld $0, r1			# sum
		ld (r0, r2, 4), r3	# r1 = s->base.grade[0]
		add r3, r1
		inc r2
		ld (r0, r2, 4), r3	# r2 = s->base.grade[1]
		add r3, r1			# r1 = s->base.grade[0] + s->base.grade[1]
		inc r2
		ld (r0, r2, 4), r3	# r2 = s->base.grade[2]
		add r3, r1			# r1 = s->base.grade[0] + s->base.grade[1] + s->base.grade[2]
		inc r2
		ld (r0, r2, 4), r3	# r2 = s->base.grade[3]
		add r3, r1			# r1 = sum = s->base.grade[0] + s->base.grade[1] + s->base.grade[2] + s->base.grade[4]
		# you can recycle r2 again
		inc r2
		shr $2, r1			# r1 = sum/4 = average
		st r1, (r0, r2, 4)		# s->base.average = average/r1

# version two 

		# ld $s, r0			# r0 = &s
		# ld 8(r0), r1		# r1 = s->base.grade[0]
		# ld 12(r0), r2		# r2 = s->base.grade[1]
		# add r2, r1			# r1 = s->base.grade[0] + s->base.grade[1]
		# ld 16(r0), r2		# r2 = s->base.grade[2]
		# add r2, r1			# r1 = s->base.grade[0] + s->base.grade[1] + s->base.grade[2]
		# ld 20(r0), r2		# r2 = s->base.grade[3]
		# add r2, r1			# r1 = sum = s->base.grade[0] + s->base.grade[1] + s->base.grade[2] + s->base.grade[4]
		# # you can recycle r2 again
		# shr $2, r1			# r1 = sum/4 = average
		# st r1, 24(r0)		# s->base.average = average/r1

.pos 0x8000
n: 		.long 1 		# just one student
m: 		.long 0 		# put the answer here
s: 		.long base 		# address of the array

base: 
		.long 1234 		# student ID
 		.long 80 		# grade 0
 		.long 60 		# grade 1
 		.long 78 		# grade 2
 		.long 90 		# grade 3
 		.long 0 		# computed average