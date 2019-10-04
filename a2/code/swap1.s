.pos 0x100

## need to use ld   0x0(r0), r2 to store values of t and other data
                 ld   $0x0, r0            # r0 = 0
                 ld   $t, r1              # r1 = address of t
                 st   r0, 0x0(r1)         # t = array[0]
                 ld   $array[1], r2       # r2 = address of array[1]
                 st   r2, 0x0(r0)         # array[0] = array[1]
                 st   r1, 0x0(r2)         # array[1] = t
                 halt                     # halt
.pos 0x1000
t:               .long 0xffffffff         # t
.pos 0x2000
array:           .long 0x00000001         # array[0]
                 .long 0x00000002         # array[1]

