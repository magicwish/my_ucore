#include <stdio.h>
#include <ulib.h>

int magic = -0x10384;
int wish = 0x10384;

int
main(void) {
    int pid1, pid2, pid3, code, ret;
    cprintf("I am the parent. Forking the children...\n");
    if ((pid1 = fork()) == 0) {
        cprintf("I am the child. pid %d\n", getpid());
        yield();
		cprintf("I am the child. pid %d\n", getpid());
        yield();
		cprintf("I am the child. pid %d\n", getpid());
		cprintf("pid %d exit.\n", getpid());
        exit(magic);
    }
    else {
        cprintf("I am parent, fork a child pid %d\n", pid1);
		if((pid2 = fork()) == 0) {
			cprintf("I am the child. pid %d\n", getpid());
			yield();
			cprintf("I am the child. pid %d\n", getpid());
			cprintf("pid %d exit.\n", getpid());
			exit(wish);
		}
		else {
			cprintf("I am parent, fork a child pid %d\n", pid2);
			if((pid3 = fork()) == 0) {
				cprintf("I am the child. pid %d\n", getpid());
				cprintf("pid %d exit.\n", getpid());
				exit(wish);
			}
		}
    }
    cprintf("I am the parent, waiting now..\n");
	ret = waitpid(pid1, &code);
	cprintf("ret: %d code: %d\n", ret, code);
    return 0;
}

