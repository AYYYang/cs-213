.pos 0x100
                 ld   $b, r0              # r0 = addr. of b
                 ld   0x0(r0), r2         # r2 = b
                 ld   0x0(r0), r5         # value of b, DO NOT modify         
                 ld   $0x1, r1            # r1 = 1 
                 add  r1, r2	          # r2 = 1 + b
                 st   r2,0x0(r0)          # b = 1 + b 
                 ld   $0x4, r1            # r1 = 4 
                 add  r1, r2	          # r2 = 4 + b
                 st   r2,0x0(r0)          # b = 4 + b 
                 # ld   $0x1, r1          # r1 = 1
                 shr  $1, r2              # r2 = b/2
                 st   r2,0x0(r0)          # b = b/2
                 # mov ()            # r3 = b
                 and  r5, r2               # r2 = b & b
                 st   r2,0x0(r0)          # b = b & b
                 # ld   $0x2, r1          # r1 = 2
                 shl  $2, r2              # r2 = b << 2
                 ld   $a, r7              # r7 = addr. of a 
                 st   r2, 0x0(r7)          # a = b << 2   
                 halt                     # halt

.pos 0x1000
a:              .long 0x1         # a
.pos 0x2000                 
b:              .long 0x4         # b