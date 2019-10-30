



.pos 0x8000
n: .long 1 # just one student
m: .long 0 # put the answer here
s: .long base # address of the array
base: .long 1234 # student ID
 .long 80 # grade 0
 .long 60 # grade 1
 .long 78 # grade 2
 .long 90 # grade 3
 .long 0 # computed average