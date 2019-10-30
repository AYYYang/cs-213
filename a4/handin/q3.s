.pos 0x1000
code:		# v0 = s.x[i]; good 
		ld $v0, r0		# r0 = & v0
		ld $s, r1		# r1 = & s
		# inca r1		# r1 = & s.x 
		ld $i, r3		# r3 = & i
		ld (r3), r3		# r3 = i
		ld (r1, r3, 4), r4	# r4 = s.x[i]
		st r4, 0x0(r0)		# v0 = s.x[i]
		 # v1 = s.y[i]; good	
		ld $v1, r0		# r0 = & v1
		ld $s, r1		# r1 = & s
		ld 0x8(r1), r2		# r2 = &s.y
		ld $i, r3		# r3 = & i
		ld (r3), r3		# r3 = i
		ld (r2, r3, 4), r4	# r4 = s.y[i]
		st r4, 0x0(r0)		# v1 = s.y[i]
		#  v2 = s.z->x[i]; good
		ld $v2, r0		# r0 = & v2
		ld $s, r1		# r1 = & s
		ld 0xc(r1), r2		# r2 = & s.z
		ld $i, r3		# r3 = & i
		ld (r3), r3		# r3 = i
		ld (r2, r3, 4), r4	# r4 = s.z->x[i]
		st r4, 0x0(r0)		# v2 = s.z->x[i]
		#  v3 = s.z->z->y[i]; good
		ld $v3, r0		# r0 = & v2
		ld $s, r1		# r1 = & s
		ld 0xc(r1), r2		# r2 = & s.z
		ld 0xc(r2), r3		# r3= & s.z->z
		ld 0x8(r3), r4		# r4 = & s.z->z->y
		ld $i, r7		# r7 = & i
		ld (r7), r7		# r7 = i
		ld (r4, r7, 4), r6	# r6 = s.z->z->y[i]
		st r6, 0x0(r0)		#  v3 = s.z->z->y[i]

# void foo () {
#  v0 = s.x[i]; good 
#  v1 = s.y[i]; good
#  v2 = s.z->x[i]; good 
#  v3 = s.z->z->y[i];
# }

# struct S { # 24 bytes
#  int x[2]; # 8 bytes
#  int* y; # 8 bytes
#  struct S* z; # 8 bytes
# };

# s.y = malloc (2 * sizeof (int)); # 8 bytes
# s.z = malloc (sizeof (struct S)); # 24 bytes
# s.z->z = malloc (sizeof (struct S)); # 24 bytes
# s.z->z->y = malloc (2 * sizeof (int)); # 8 bytes


.pos 0x2000
static:
i: 			.long 0x1 		# i
v0: 		.long 0x2 		# v0
v1: 		.long 0x3 		# v1
v2: 		.long 0x4		# v2
v3: 		.long 0x5		# v3
s: 			.long 0x9		# s.x[0]
 			.long 0xa 		# s.x[1]
			.long s_y 		# s.y
			.long s_z		# s.z

.pos 0x3000
heap:
s_y:		.long 0x10		# s.y[0]
			.long 0x11 		# s.y[1]
s_z: 		.long 0x90 		# s.z->x[0]
			.long 0x91 		# s.z->x[1]
 			.long 0 		# s.z->y
 			.long s_z_z 	# s.z->z
s_z_z:		.long 0x1		# s.z->z->x[0]
			.long 0x90 		# s.z->z->x[1]
 			.long s_z_z_y 	# s.z->z->y
 			.long 0 		# s.z->z->z
s_z_z_y:	.long 0			# s.z->z->y[0]
			.long 0x99 		# s.z->z->y[1]





