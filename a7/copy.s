.pos 0x100
# void copy() {
#   int dst[2]; // 8 bytes
#   int i = 0; // 4 bytes 
#   while (src[i] != 0) {
#     dst[i] = src[i];
#     i++;
#   }
#   dst[i]=0;
# }

# int main () {
#   copy ();
# }

main: 	ld   	$stackBtm, r5			# sp = address of last word of stack
		inca r5				# sp = address of word after stack
		gpc  $6, r6              	# ra = pc + 6
		j    copy                 	# call copy()
		halt

.pos 0x200
copy:		ld $-12, r0    		# r0 = -16 = -(size of callee part of copy's frame)
		add  r0, r5              	# allocate callee part of copy's frame
		st r6, 0x8(r5)			# stores the ra in stack

		ld $0x00000000, r1		# r1 = i = 0
		ld $src, r2			# r2 = & src

while_loop:	ld (r2, r1, 4), r3		# r3 = src[i]
		beq r3, end			# if (scr[i] = 0), goto end
		# if (scr[i] = 0) execute while loop

		st r3, (r5, r1, 4)		# dst[i] = src[i] local variable
		inc r1
		br while_loop			# goes back to while loop

end: 		ld   0x8(r5), r6         	# load return address from stack
		ld   $12, r0			# r0 = 16 = size of copy's frame
		add  r0, r5              	# deallocate callee parts of copy's frame
		j    0x0(r6)			# return

.pos 0x1000
# int src[2] = {1,0};
src: 		.long 0x200c
		.long 0x200c
		.long 0x200c
		.long 0x200c
		nop 
		nop 
		nop
		nop
		ld $-1, r0
		mov r0, r1
		mov r1, r2
		mov r1, r3
		mov r1, r4
		mov r1, r5
		mov r1, r6
		mov r1, r7
		mov r1, r0
		halt

.pos 0x2000
stackTop:        .long 0x00000000         
                 .long 0x00000000         
stackBtm:        .long 0x00000000



