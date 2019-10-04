BinaryTree:
	gcc -std=gnu11 -g BinaryTree.c -o BinaryTree && ./BinaryTree
CFLAGS += -std=gnu11 -g
EXES = BinaryTree
OBJS = BinaryTree.o
all: $(EXES)
clean:
	rm -f $(OBJS) $(EXES)
tidy:
	rm -f $(OBJS)
prog: BinaryTree.o
prog.o: BinaryTree.c