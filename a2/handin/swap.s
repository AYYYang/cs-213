.pos 0x100
                 ld   $array, r0          # r0 = address of array[0]
                 ld   $t, r1              # r1 = address of t  
                 ld   0x0(r1), r4         # r5 holds value of t         
                 ld   0x0(r0), r6         # r6 = array[0]
                 st   r6, 0x0(r1)         # t = array[0]
                 ld   $0x1, r5            # r5 = 1
                 ld   (r0, r5, 4), r7     # r7 = array[1]
                 st   r7, 0x0(r0)         # array[0] = array[1]
                 st   r4, (r0, r5, 4)     # array[1] = t
                 halt                     # halt
.pos 0x1000
t:               .long 0xffffffff         # t
.pos 0x2000
array:           .long 0x00000001         # array[0]
                 .long 0x00000002         # array[1]