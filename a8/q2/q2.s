.pos 0x0
                 ld   $0x1028, r5       # sp = address of last word of stack      
                 ld   $0xfffffff4, r0   # r0 = -12 = -(size of caller part of ____ frame)
                 add  r0, r5            # sp = allocate caller part of _____'s frame
                 ld   $0x200, r0        # r0 = &a
                 ld   0x0(r0), r0       # r0 = a  
                 st   r0, 0x0(r5)       # save a[0] on stack  
                 ld   $0x204, r0        # r0 = &a[1]
                 ld   0x0(r0), r0       # r0 = a[1]  
                 st   r0, 0x4(r5)       # save a[1] on stack  
                 ld   $0x208, r0        # r0 = &a[2]  
                 ld   0x0(r0), r0       # r0 = a[2]
                 st   r0, 0x8(r5)       # save a[2] on stack   
                 gpc  $6, r6            # ra = pc + 6      
                 j    0x300             # call q2()
                 ld   $0x20c, r1        # r1 = &a[3]  
                 st   r0, 0x0(r1)       # a[3] = return value  
                 halt                     
.pos 0x200
a:               .long 0x00000010       # a       
                 .long 0x0000001a       # a[1]  
                 .long 0x00000032       # a[2]  
                 .long 0x00000022       # a[3]  
.pos 0x300
q2:              ld   0x0(r5), r0       # r0 = arg0    
                 ld   0x4(r5), r1       # r1 = arg1 
                 ld   0x8(r5), r2       # r2 = arg2  
                 ld   $0xfffffff6, r3   # r3 = - 10 
                 add  r3, r0            # r0 = arg0 - 10
                 mov  r0, r3            # r3 = r0 = arg0 - 10  
                 not  r3                # r3 = !r3  
                 inc  r3                # r3 = 10 - arg0  
                 bgt  r3, L6            # if(arg0 < 10) goto L6
                 mov  r0, r3            # else r3 = arg0 - 10 
                 ld   $0xfffffff8, r4   # r4 = -8  
                 add  r4, r3            # r3 = arg0 - 18  
                 bgt  r3, L6            # if (arg0 > 18), goto L6  
                 ld   $0x400, r3        # r3 = &jumptable
                 j    *(r3, r0, 4)      # goto jmptable[arg0 - 10]  
.pos 0x330
case0:           add  r1, r2            # arg2 = arg2 + arg1 
                 br   done              # goto done 

                 not  r2                # r2 = !arg2   
                 inc  r2                # r2 = - arg2 
                 add  r1, r2            # arg2 = arg1 - arg2
                 br   done              # goto done   

                 not  r2                # r2 = !arg2  
                 inc  r2                # r2 = -arg2 
                 add  r1, r2            # r2 = arg1 - arg2  
                 bgt  r2, L0            # if (arg1 > arg2) goto L0  
                 ld   $0x0, r2          # arg2 = 0
                 br   L1                # goto L1 
L0:              ld   $0x1, r2          # arg2 = 1 
L1:              br   done              # goto done 

                 not  r1                # r1 = !arg1  
                 inc  r1                # r1 = -arg1  
                 add  r2, r1            # arg1 = arg2 - arg1  
                 bgt  r1, L2            # if (arg2 > arg1), goto L2  
                 ld   $0x0, r2          # arg2 = 0  
                 br   L3                # goto L3  
L2:              ld   $0x1, r2          # arg2 = 1  
L3:              br   done              # goto done 

                 not  r2                # r2 = !arg2  
                 inc  r2                # r2 = -arg2  
                 add  r1, r2            # arg2 = arg1 - arg2  
                 beq  r2, L4            # if(arg1 = arg2), goto L4  
                 ld   $0x0, r2          # arg2 = 0  
                 br   L5                # goto L5
L4:              ld   $0x1, r2          # arg2 = 1  
L5:              br   done              # goto done 

L6:              ld   $0x0, r2          # arg2 = 0          
                 br   done              # goto done    

done:            mov  r2, r0            # return value = arg2  
                 j    0x0(r6)           # return  
.pos 0x400
jumptable:       .long 0x00000330           
                 .long 0x00000384         
                 .long 0x00000334         
                 .long 0x00000384         
                 .long 0x0000033c         
                 .long 0x00000384         
                 .long 0x00000354         
                 .long 0x00000384         
                 .long 0x0000036c         
.pos 0x1000
sT:              .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
sb:              .long 0x00000000         
