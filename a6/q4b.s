.pos 0x100
start:
    ld $sb, r5          # [01] sp = address of last word of stack
    inca    r5          # [02] sp = address of word after stack
    gpc $6, r6          # [03] r6 = pc + 6
    j main              # jump to main
    halt

f:
    deca r5             # allocate calle part of f's frame
    ld $0, r0           # r0 = i' = 0

    ld 4(r5), r1        # r1 = x from stack
    ld $0x80000000, r2  # r2 = top of stack
f_loop:
    beq r1, f_end       # if(x = 0), goto f_end
    mov r1, r3          # r3 = x'
    and r2, r3          # r3 = x' & 0x80000000
    beq r3, f_if1       # if (x'& 0x80000000 = 0), goto f_if1
    inc r0              # i++
f_if1:
    shl $1, r1          # r1 = x' = x'*2
    br f_loop           # goto f_loop
f_end:
    inca r5             # deallocate callee part of f's frame
    j(r6)               # return

main:
    deca r5             # allocate calle part of main's frame
    deca r5             # allocate calle part of main_loop's frame
    st r6, 4(r5)        # save ra on stack
    ld $8, r4           # r4 = n' = 8

main_loop:
    beq r4, main_end    # if (n = 0), goto main_end
    dec r4              # n' = n'-1
    ld $x, r0           # r0 = & x
    ld (r0,r4,4), r0    # x[n'] = x

    deca r5             # allocate calle part of f's frame
    st r0, (r5)         # save x on stack

    gpc $6, r6          # r6 = pc + 6
    j f                 # goto f()

    inca r5             # deallocate callee part of main_loop's frame
    ld $y, r1           # r1 = &y
    st r0, (r1,r4,4)    # y[n'] = r0 = i
    br main_loop        # goto main_loop

main_end:
    ld 4(r5), r6        # load return address from stack
    inca r5             # deallocate callee part of main_loop's frame
    inca r5             # deallocate callee part of main's frame
    j (r6)              # return

.pos 0x2000
x:
    .long 1             # x[0]
    .long 2             # x[1]
    .long 3             # x[2]
    .long -1            # x[3]
    .long -2            # x[4]
    .long 0             # x[5]
    .long 184           # x[6]
    .long 340057058     # x[7]

y:
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

