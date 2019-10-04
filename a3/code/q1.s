.pos 0x100
    # STATEMENT 1: i  = a[3]; --> worked on SIM 
    ld $a, r0           # r0 = address of a/a[0]
    ld $i, r1           # r1 = address of i
    ld 0xc(r0), r0      # r0 = a[3]
    st r0, 0(r1)        # i = a[3]

    # STATEMENT 2: i  = a[i]; 
    ld $a, r0           # r0 = address of a/a[0]
    ld $i ,r1           # r1 = address of i
    ld 0(r1), r3        # r3 = i
    ld (r0,r3,4), r4    # r4 = a[i]
    st r4, 0(r1)        # i  = a[i]

    # STATEMENT 3: p  = &j; *p = 4;
    ld $j, r0           # r0 = address of j
    ld $p, r1           # r1 = address of p
    st r0, 0(r1)        # p  = &j
    ld $4, r3           # r3 = 4
    st r3, 0(r0)        # j = 4 OR *p = 4

    # Statement 4: p  = &a[a[2]];
    ld $a, r0           # r0 = address of a[0]
    ld (r0), r1         # r1 = a
    ld 0x8(r0), r2      # r2 = a[2] == 7
    shl $2, r2          # r2 = a[2]*4 == a[a[2]] - a[0]
    add r2, r0          # r0 = a[0] + a[a[2]]*4
    ld $p, r7           # r7 = address of p
    st r0, 0(r7)        # p = &a[a[2]]
    #   *p = *p + a[4];
    ld $p, r0           # r0 = address of p
    ld (r0), r1         # r1 = &a[7]
    ld (r1), r2         # r2 = a[7] = *p
    ld $a, r3           # r3 = address of a[0]
    ld 0x10(r3), r4     # r4 = a[4]
    add r2, r4          # r2 = *p + a[4]
    st r4, (r1)         # a[7] == a[7] + a[4]

.pos 0x200
# Data area
i:  .long 0             # i
j:  .long 1             # j
p:  .long 0             # p
a:  .long 0             # a[0]
    .long 0             # a[1]
    .long 7             # a[2]
    .long 5             # a[3]
    .long 8             # a[4]
    .long 2             # a[5]
    .long 0             # a[6]
    .long 3             # a[7]
    .long 0             # a[8]
    .long 10            # a[9]
