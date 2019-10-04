.pos 0x100
                 ld   $d0, r0             # r0 = & d0.e
                 ld   0x4(r0), r1         # r1 = d0.f
                 st   r1, 0x0(r0)         # d0.e = d0.f
                 ld   $d1, r0             # r0 = & d1
                 ld   0x0(r0), r0         # r0 = d1
                 ld   0x4(r0), r1         # r1 = d1->f
                 st   r1, 0x0(r0)         # d1->e = d1->f
                 halt   

struct D {
  int e;
  int f;
};

struct D  d0;
struct D* d1;

void foo () {
  d1 = (struct D*) malloc (sizeof(struct D));
  d0.e = d0.f; // change the values
  d1->e = d1->f; // change the pointers
}

.pos 0x2000
d0:              .long 0x00000001         # d0.e
                 .long 0x00000002         # d0.f
.pos 0x3000
d1:              .long 0x00004000         # d1
.pos 0x4000
d1_data:         .long 0x00000003         # d1->e
                 .long 0x00000004         # d1->f
