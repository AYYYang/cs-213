.pos 0x0
                 ld   $sb, r5           # [01] sp = address of last word of stack
                 inca r5                # [02] sp = address of word after stack
                 gpc  $6, r6            # [03] r6 = pc + 6
                 j    0x300             # [04] call a() at 0x300    
                 halt                     
.pos 0x100
n:                 .long 0x00001000         
.pos 0x200
b:               ld   (r5), r0          # r0 = x from stack
                 ld   4(r5), r1         # r1 = y from stack
                 ld   $0x100, r2        # r2 = &n
                 ld   (r2), r2          # r2 = n
                 ld   (r2, r1, 4), r3   # r3 = n[y]
                 add  r3, r0            # r0 = n[y] + x  
                 st   r0, (r2, r1, 4)   # n[y] = n[y] + x
                 j    (r6)              # return
.pos 0x300
a:               ld   $-12, r0          # [05] r0 = -12 = -(size of callee part of a's frame)
                 add  r0, r5            # [06] allocate callee part of b's frame
                 st   r6, 8(r5)         # [07] store return address to stack

                 ld   $1, r0            # [08] r0 = 1 = p
                 st   r0, (r5)          # [09] store p to stack

                 ld   $2, r0            # [10] r0 = 2 = q
                 st   r0, 4(r5)         # [11] store q as the next return address to stck

                 ld   $-8, r0           # [12] r0 = -8 = size of callee part of b's frame
                 add  r0, r5            # [13] allocate caller part of b's frame
                 ld   $3, r0            # [14] r0 = 3 = value of x0
                 st   r0, (r5)          # [15] save x onto stack
                 ld   $4, r0            # [16] r0 = 4 = value of y
                 st   r0, 4(r5)         # [17] store value of y onto the stack

                 gpc  $6, r6            # set return address    
                 j    0x200             # calls b()

                 ld   $8, r0            # r0 = 8 = size of callee part of b's frame
                 add  r0, r5            # deallocate callee parts of b's frame

                 ld   (r5), r1          # r1 = p from stack
                 ld   4(r5), r2         # r2 = q from stack

                 ld   $-8, r0           # r0 = -8 = size of callee part of b's frame
                 add  r0, r5            # allocate caller part of b's frame
                 st   r1, (r5)          # x = p
                 st   r2, 4(r5)         # y = q

                 gpc  $6, r6            # set return address    
                 j    0x200             # calls b()  

                 ld   $8, r0            # r0 = 8 = size of caller part of b's frame
                 add  r0, r5            # deallocate caller part of b's frame

                 ld   8(r5), r6         # load return address from stack
                 ld   $12, r0           # r0 = 12 = size of callee fn2's frame
                 add  r0, r5            # deallocate callee parts of fns'2 frame
                 j    (r6)              # return
.pos 0x1000
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
                 .long 0
.pos 0x8000
# These are here so you can see (some of) the stack contents.
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
    .long 0
sb: .long 0
