
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba a0 fd 10 00       	mov    $0x10fda0,%edx
  10000b:	b8 36 ea 10 00       	mov    $0x10ea36,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 36 ea 10 00 	movl   $0x10ea36,(%esp)
  100027:	e8 e4 35 00 00       	call   103610 <memset>

    cons_init();                // init the console
  10002c:	e8 1b 16 00 00       	call   10164c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 a0 37 10 00 	movl   $0x1037a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 bc 37 10 00 	movl   $0x1037bc,(%esp)
  100046:	e8 a9 03 00 00       	call   1003f4 <cprintf>

    print_kerninfo();
  10004b:	e8 d8 08 00 00       	call   100928 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 f9 2b 00 00       	call   102c53 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 30 17 00 00       	call   10178f <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 82 18 00 00       	call   1018e6 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 d6 0d 00 00       	call   100e3f <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 8f 16 00 00       	call   1016fd <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 3f 02 00 00       	call   1002b2 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 da 0c 00 00       	call   100d71 <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 c1 37 10 00 	movl   $0x1037c1,(%esp)
  100137:	e8 b8 02 00 00       	call   1003f4 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 cf 37 10 00 	movl   $0x1037cf,(%esp)
  100157:	e8 98 02 00 00       	call   1003f4 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 dd 37 10 00 	movl   $0x1037dd,(%esp)
  100177:	e8 78 02 00 00       	call   1003f4 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 eb 37 10 00 	movl   $0x1037eb,(%esp)
  100197:	e8 58 02 00 00       	call   1003f4 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 f9 37 10 00 	movl   $0x1037f9,(%esp)
  1001b7:	e8 38 02 00 00       	call   1003f4 <cprintf>
    round ++;
  1001bc:	a1 40 ea 10 00       	mov    0x10ea40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 ea 10 00       	mov    %eax,0x10ea40
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
  1001ce:	83 ec 28             	sub    $0x28,%esp
    //LAB1 CHALLENGE 1 : TODO
    uint16_t reg0, reg1;
    asm volatile (
  1001d1:	89 6d f6             	mov    %ebp,-0xa(%ebp)
  1001d4:	89 65 f4             	mov    %esp,-0xc(%ebp)
            "mov %%ebp, %0;"
            "mov %%esp, %1;"
            : "=m"(reg0), "=m"(reg1));
    cprintf("Before u2k ebp = %x\n", reg0);
  1001d7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1001db:	0f b7 c0             	movzwl %ax,%eax
  1001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e2:	c7 04 24 07 38 10 00 	movl   $0x103807,(%esp)
  1001e9:	e8 06 02 00 00       	call   1003f4 <cprintf>
    cprintf("Before u2k esp = %x\n", reg1);
  1001ee:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001f2:	0f b7 c0             	movzwl %ax,%eax
  1001f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f9:	c7 04 24 1c 38 10 00 	movl   $0x10381c,(%esp)
  100200:	e8 ef 01 00 00       	call   1003f4 <cprintf>

	asm volatile (
  100205:	83 ec 08             	sub    $0x8,%esp
  100208:	cd 78                	int    $0x78
	    "sub $0x8, %%esp \n"
	    "int %0 \n"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
    asm volatile (
  10020a:	89 6d f6             	mov    %ebp,-0xa(%ebp)
  10020d:	89 65 f4             	mov    %esp,-0xc(%ebp)
            "mov %%ebp, %0;"
            "mov %%esp, %1;"
            : "=m"(reg0), "=m"(reg1));
    cprintf("After u2k ebp = %x\n", reg0);
  100210:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100214:	0f b7 c0             	movzwl %ax,%eax
  100217:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021b:	c7 04 24 31 38 10 00 	movl   $0x103831,(%esp)
  100222:	e8 cd 01 00 00       	call   1003f4 <cprintf>
    cprintf("After u2k esp = %x\n", reg1);
  100227:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10022b:	0f b7 c0             	movzwl %ax,%eax
  10022e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100232:	c7 04 24 45 38 10 00 	movl   $0x103845,(%esp)
  100239:	e8 b6 01 00 00       	call   1003f4 <cprintf>
}
  10023e:	c9                   	leave  
  10023f:	c3                   	ret    

00100240 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100240:	55                   	push   %ebp
  100241:	89 e5                	mov    %esp,%ebp
  100243:	83 ec 28             	sub    $0x28,%esp
    //LAB1 CHALLENGE 1 :  TODO
    uint16_t reg0, reg1;
    asm volatile (
  100246:	89 6d f6             	mov    %ebp,-0xa(%ebp)
  100249:	89 65 f4             	mov    %esp,-0xc(%ebp)
            "mov %%ebp, %0;"
            "mov %%esp, %1;"
            : "=m"(reg0), "=m"(reg1));
    cprintf("Before k2u ebp = %x\n", reg0);
  10024c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100250:	0f b7 c0             	movzwl %ax,%eax
  100253:	89 44 24 04          	mov    %eax,0x4(%esp)
  100257:	c7 04 24 59 38 10 00 	movl   $0x103859,(%esp)
  10025e:	e8 91 01 00 00       	call   1003f4 <cprintf>
    cprintf("Before k2u esp = %x\n", reg1);
  100263:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100267:	0f b7 c0             	movzwl %ax,%eax
  10026a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026e:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  100275:	e8 7a 01 00 00       	call   1003f4 <cprintf>

	asm volatile (
  10027a:	cd 79                	int    $0x79
	    "int %0 \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
    asm volatile (
  10027c:	89 6d f6             	mov    %ebp,-0xa(%ebp)
  10027f:	89 65 f4             	mov    %esp,-0xc(%ebp)
            "mov %%ebp, %0;"
            "mov %%esp, %1;"
            : "=m"(reg0), "=m"(reg1));
    cprintf("After k2u ebp = %x\n", reg0);
  100282:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100286:	0f b7 c0             	movzwl %ax,%eax
  100289:	89 44 24 04          	mov    %eax,0x4(%esp)
  10028d:	c7 04 24 83 38 10 00 	movl   $0x103883,(%esp)
  100294:	e8 5b 01 00 00       	call   1003f4 <cprintf>
    cprintf("After k2u esp = %x\n", reg1);
  100299:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10029d:	0f b7 c0             	movzwl %ax,%eax
  1002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a4:	c7 04 24 97 38 10 00 	movl   $0x103897,(%esp)
  1002ab:	e8 44 01 00 00       	call   1003f4 <cprintf>
}
  1002b0:	c9                   	leave  
  1002b1:	c3                   	ret    

001002b2 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1002b2:	55                   	push   %ebp
  1002b3:	89 e5                	mov    %esp,%ebp
  1002b5:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1002b8:	e8 48 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1002bd:	c7 04 24 ac 38 10 00 	movl   $0x1038ac,(%esp)
  1002c4:	e8 2b 01 00 00       	call   1003f4 <cprintf>
    lab1_switch_to_user();
  1002c9:	e8 fd fe ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1002ce:	e8 32 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1002d3:	c7 04 24 cc 38 10 00 	movl   $0x1038cc,(%esp)
  1002da:	e8 15 01 00 00       	call   1003f4 <cprintf>
    lab1_switch_to_kernel();
  1002df:	e8 5c ff ff ff       	call   100240 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1002e4:	e8 1c fe ff ff       	call   100105 <lab1_print_cur_status>
}
  1002e9:	c9                   	leave  
  1002ea:	c3                   	ret    

001002eb <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  1002f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f5:	74 13                	je     10030a <readline+0x1f>
        cprintf("%s", prompt);
  1002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002fe:	c7 04 24 eb 38 10 00 	movl   $0x1038eb,(%esp)
  100305:	e8 ea 00 00 00       	call   1003f4 <cprintf>
    }
    int i = 0, c;
  10030a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100311:	e8 66 01 00 00       	call   10047c <getchar>
  100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100319:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10031d:	79 07                	jns    100326 <readline+0x3b>
            return NULL;
  10031f:	b8 00 00 00 00       	mov    $0x0,%eax
  100324:	eb 79                	jmp    10039f <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100326:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10032a:	7e 28                	jle    100354 <readline+0x69>
  10032c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100333:	7f 1f                	jg     100354 <readline+0x69>
            cputchar(c);
  100335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100338:	89 04 24             	mov    %eax,(%esp)
  10033b:	e8 da 00 00 00       	call   10041a <cputchar>
            buf[i ++] = c;
  100340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100343:	8d 50 01             	lea    0x1(%eax),%edx
  100346:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10034c:	88 90 60 ea 10 00    	mov    %dl,0x10ea60(%eax)
  100352:	eb 46                	jmp    10039a <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100354:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100358:	75 17                	jne    100371 <readline+0x86>
  10035a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035e:	7e 11                	jle    100371 <readline+0x86>
            cputchar(c);
  100360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100363:	89 04 24             	mov    %eax,(%esp)
  100366:	e8 af 00 00 00       	call   10041a <cputchar>
            i --;
  10036b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036f:	eb 29                	jmp    10039a <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100371:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100375:	74 06                	je     10037d <readline+0x92>
  100377:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10037b:	75 1d                	jne    10039a <readline+0xaf>
            cputchar(c);
  10037d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100380:	89 04 24             	mov    %eax,(%esp)
  100383:	e8 92 00 00 00       	call   10041a <cputchar>
            buf[i] = '\0';
  100388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038b:	05 60 ea 10 00       	add    $0x10ea60,%eax
  100390:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100393:	b8 60 ea 10 00       	mov    $0x10ea60,%eax
  100398:	eb 05                	jmp    10039f <readline+0xb4>
        }
    }
  10039a:	e9 72 ff ff ff       	jmp    100311 <readline+0x26>
}
  10039f:	c9                   	leave  
  1003a0:	c3                   	ret    

001003a1 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1003a1:	55                   	push   %ebp
  1003a2:	89 e5                	mov    %esp,%ebp
  1003a4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1003aa:	89 04 24             	mov    %eax,(%esp)
  1003ad:	e8 c6 12 00 00       	call   101678 <cons_putc>
    (*cnt) ++;
  1003b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003b5:	8b 00                	mov    (%eax),%eax
  1003b7:	8d 50 01             	lea    0x1(%eax),%edx
  1003ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bd:	89 10                	mov    %edx,(%eax)
}
  1003bf:	c9                   	leave  
  1003c0:	c3                   	ret    

001003c1 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1003c1:	55                   	push   %ebp
  1003c2:	89 e5                	mov    %esp,%ebp
  1003c4:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1003c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1003d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1003df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e3:	c7 04 24 a1 03 10 00 	movl   $0x1003a1,(%esp)
  1003ea:	e8 3a 2a 00 00       	call   102e29 <vprintfmt>
    return cnt;
  1003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003f2:	c9                   	leave  
  1003f3:	c3                   	ret    

001003f4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1003f4:	55                   	push   %ebp
  1003f5:	89 e5                	mov    %esp,%ebp
  1003f7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1003fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  1003fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100403:	89 44 24 04          	mov    %eax,0x4(%esp)
  100407:	8b 45 08             	mov    0x8(%ebp),%eax
  10040a:	89 04 24             	mov    %eax,(%esp)
  10040d:	e8 af ff ff ff       	call   1003c1 <vcprintf>
  100412:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100415:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100418:	c9                   	leave  
  100419:	c3                   	ret    

0010041a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10041a:	55                   	push   %ebp
  10041b:	89 e5                	mov    %esp,%ebp
  10041d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100420:	8b 45 08             	mov    0x8(%ebp),%eax
  100423:	89 04 24             	mov    %eax,(%esp)
  100426:	e8 4d 12 00 00       	call   101678 <cons_putc>
}
  10042b:	c9                   	leave  
  10042c:	c3                   	ret    

0010042d <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10042d:	55                   	push   %ebp
  10042e:	89 e5                	mov    %esp,%ebp
  100430:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10043a:	eb 13                	jmp    10044f <cputs+0x22>
        cputch(c, &cnt);
  10043c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100440:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100443:	89 54 24 04          	mov    %edx,0x4(%esp)
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 52 ff ff ff       	call   1003a1 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10044f:	8b 45 08             	mov    0x8(%ebp),%eax
  100452:	8d 50 01             	lea    0x1(%eax),%edx
  100455:	89 55 08             	mov    %edx,0x8(%ebp)
  100458:	0f b6 00             	movzbl (%eax),%eax
  10045b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10045e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100462:	75 d8                	jne    10043c <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100464:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100467:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100472:	e8 2a ff ff ff       	call   1003a1 <cputch>
    return cnt;
  100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10047a:	c9                   	leave  
  10047b:	c3                   	ret    

0010047c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10047c:	55                   	push   %ebp
  10047d:	89 e5                	mov    %esp,%ebp
  10047f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100482:	e8 1a 12 00 00       	call   1016a1 <cons_getc>
  100487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10048a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10048e:	74 f2                	je     100482 <getchar+0x6>
        /* do nothing */;
    return c;
  100490:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100493:	c9                   	leave  
  100494:	c3                   	ret    

00100495 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100495:	55                   	push   %ebp
  100496:	89 e5                	mov    %esp,%ebp
  100498:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049e:	8b 00                	mov    (%eax),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a6:	8b 00                	mov    (%eax),%eax
  1004a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004b2:	e9 d2 00 00 00       	jmp    100589 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	89 c2                	mov    %eax,%edx
  1004c1:	c1 ea 1f             	shr    $0x1f,%edx
  1004c4:	01 d0                	add    %edx,%eax
  1004c6:	d1 f8                	sar    %eax
  1004c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d1:	eb 04                	jmp    1004d7 <stab_binsearch+0x42>
            m --;
  1004d3:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004dd:	7c 1f                	jl     1004fe <stab_binsearch+0x69>
  1004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e2:	89 d0                	mov    %edx,%eax
  1004e4:	01 c0                	add    %eax,%eax
  1004e6:	01 d0                	add    %edx,%eax
  1004e8:	c1 e0 02             	shl    $0x2,%eax
  1004eb:	89 c2                	mov    %eax,%edx
  1004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f6:	0f b6 c0             	movzbl %al,%eax
  1004f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fc:	75 d5                	jne    1004d3 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100501:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100504:	7d 0b                	jge    100511 <stab_binsearch+0x7c>
            l = true_m + 1;
  100506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100509:	83 c0 01             	add    $0x1,%eax
  10050c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10050f:	eb 78                	jmp    100589 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100511:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051b:	89 d0                	mov    %edx,%eax
  10051d:	01 c0                	add    %eax,%eax
  10051f:	01 d0                	add    %edx,%eax
  100521:	c1 e0 02             	shl    $0x2,%eax
  100524:	89 c2                	mov    %eax,%edx
  100526:	8b 45 08             	mov    0x8(%ebp),%eax
  100529:	01 d0                	add    %edx,%eax
  10052b:	8b 40 08             	mov    0x8(%eax),%eax
  10052e:	3b 45 18             	cmp    0x18(%ebp),%eax
  100531:	73 13                	jae    100546 <stab_binsearch+0xb1>
            *region_left = m;
  100533:	8b 45 0c             	mov    0xc(%ebp),%eax
  100536:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100539:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053e:	83 c0 01             	add    $0x1,%eax
  100541:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100544:	eb 43                	jmp    100589 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100546:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100549:	89 d0                	mov    %edx,%eax
  10054b:	01 c0                	add    %eax,%eax
  10054d:	01 d0                	add    %edx,%eax
  10054f:	c1 e0 02             	shl    $0x2,%eax
  100552:	89 c2                	mov    %eax,%edx
  100554:	8b 45 08             	mov    0x8(%ebp),%eax
  100557:	01 d0                	add    %edx,%eax
  100559:	8b 40 08             	mov    0x8(%eax),%eax
  10055c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055f:	76 16                	jbe    100577 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100564:	8d 50 ff             	lea    -0x1(%eax),%edx
  100567:	8b 45 10             	mov    0x10(%ebp),%eax
  10056a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056f:	83 e8 01             	sub    $0x1,%eax
  100572:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100575:	eb 12                	jmp    100589 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100577:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057d:	89 10                	mov    %edx,(%eax)
            l = m;
  10057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100582:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100585:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100589:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10058c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10058f:	0f 8e 22 ff ff ff    	jle    1004b7 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100599:	75 0f                	jne    1005aa <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  10059b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059e:	8b 00                	mov    (%eax),%eax
  1005a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a6:	89 10                	mov    %edx,(%eax)
  1005a8:	eb 3f                	jmp    1005e9 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ad:	8b 00                	mov    (%eax),%eax
  1005af:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005b2:	eb 04                	jmp    1005b8 <stab_binsearch+0x123>
  1005b4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bb:	8b 00                	mov    (%eax),%eax
  1005bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005c0:	7d 1f                	jge    1005e1 <stab_binsearch+0x14c>
  1005c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c5:	89 d0                	mov    %edx,%eax
  1005c7:	01 c0                	add    %eax,%eax
  1005c9:	01 d0                	add    %edx,%eax
  1005cb:	c1 e0 02             	shl    $0x2,%eax
  1005ce:	89 c2                	mov    %eax,%edx
  1005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d3:	01 d0                	add    %edx,%eax
  1005d5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d9:	0f b6 c0             	movzbl %al,%eax
  1005dc:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005df:	75 d3                	jne    1005b4 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e7:	89 10                	mov    %edx,(%eax)
    }
}
  1005e9:	c9                   	leave  
  1005ea:	c3                   	ret    

001005eb <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005eb:	55                   	push   %ebp
  1005ec:	89 e5                	mov    %esp,%ebp
  1005ee:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f4:	c7 00 f0 38 10 00    	movl   $0x1038f0,(%eax)
    info->eip_line = 0;
  1005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100604:	8b 45 0c             	mov    0xc(%ebp),%eax
  100607:	c7 40 08 f0 38 10 00 	movl   $0x1038f0,0x8(%eax)
    info->eip_fn_namelen = 9;
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100618:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061b:	8b 55 08             	mov    0x8(%ebp),%edx
  10061e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100621:	8b 45 0c             	mov    0xc(%ebp),%eax
  100624:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10062b:	c7 45 f4 a4 41 10 00 	movl   $0x1041a4,-0xc(%ebp)
    stab_end = __STAB_END__;
  100632:	c7 45 f0 f0 bb 10 00 	movl   $0x10bbf0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100639:	c7 45 ec f1 bb 10 00 	movl   $0x10bbf1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100640:	c7 45 e8 38 dc 10 00 	movl   $0x10dc38,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10064d:	76 0d                	jbe    10065c <debuginfo_eip+0x71>
  10064f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100652:	83 e8 01             	sub    $0x1,%eax
  100655:	0f b6 00             	movzbl (%eax),%eax
  100658:	84 c0                	test   %al,%al
  10065a:	74 0a                	je     100666 <debuginfo_eip+0x7b>
        return -1;
  10065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100661:	e9 c0 02 00 00       	jmp    100926 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100666:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10066d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100673:	29 c2                	sub    %eax,%edx
  100675:	89 d0                	mov    %edx,%eax
  100677:	c1 f8 02             	sar    $0x2,%eax
  10067a:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100680:	83 e8 01             	sub    $0x1,%eax
  100683:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100686:	8b 45 08             	mov    0x8(%ebp),%eax
  100689:	89 44 24 10          	mov    %eax,0x10(%esp)
  10068d:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100694:	00 
  100695:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100698:	89 44 24 08          	mov    %eax,0x8(%esp)
  10069c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10069f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006a6:	89 04 24             	mov    %eax,(%esp)
  1006a9:	e8 e7 fd ff ff       	call   100495 <stab_binsearch>
    if (lfile == 0)
  1006ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b1:	85 c0                	test   %eax,%eax
  1006b3:	75 0a                	jne    1006bf <debuginfo_eip+0xd4>
        return -1;
  1006b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ba:	e9 67 02 00 00       	jmp    100926 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d2:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006d9:	00 
  1006da:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006eb:	89 04 24             	mov    %eax,(%esp)
  1006ee:	e8 a2 fd ff ff       	call   100495 <stab_binsearch>

    if (lfun <= rfun) {
  1006f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006f9:	39 c2                	cmp    %eax,%edx
  1006fb:	7f 7c                	jg     100779 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100700:	89 c2                	mov    %eax,%edx
  100702:	89 d0                	mov    %edx,%eax
  100704:	01 c0                	add    %eax,%eax
  100706:	01 d0                	add    %edx,%eax
  100708:	c1 e0 02             	shl    $0x2,%eax
  10070b:	89 c2                	mov    %eax,%edx
  10070d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100710:	01 d0                	add    %edx,%eax
  100712:	8b 10                	mov    (%eax),%edx
  100714:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10071a:	29 c1                	sub    %eax,%ecx
  10071c:	89 c8                	mov    %ecx,%eax
  10071e:	39 c2                	cmp    %eax,%edx
  100720:	73 22                	jae    100744 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100722:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100725:	89 c2                	mov    %eax,%edx
  100727:	89 d0                	mov    %edx,%eax
  100729:	01 c0                	add    %eax,%eax
  10072b:	01 d0                	add    %edx,%eax
  10072d:	c1 e0 02             	shl    $0x2,%eax
  100730:	89 c2                	mov    %eax,%edx
  100732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100735:	01 d0                	add    %edx,%eax
  100737:	8b 10                	mov    (%eax),%edx
  100739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10073c:	01 c2                	add    %eax,%edx
  10073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100741:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100744:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	89 d0                	mov    %edx,%eax
  10074b:	01 c0                	add    %eax,%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	c1 e0 02             	shl    $0x2,%eax
  100752:	89 c2                	mov    %eax,%edx
  100754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100757:	01 d0                	add    %edx,%eax
  100759:	8b 50 08             	mov    0x8(%eax),%edx
  10075c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	8b 40 10             	mov    0x10(%eax),%eax
  100768:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100771:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100774:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100777:	eb 15                	jmp    10078e <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100779:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077c:	8b 55 08             	mov    0x8(%ebp),%edx
  10077f:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10078b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100791:	8b 40 08             	mov    0x8(%eax),%eax
  100794:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10079b:	00 
  10079c:	89 04 24             	mov    %eax,(%esp)
  10079f:	e8 e0 2c 00 00       	call   103484 <strfind>
  1007a4:	89 c2                	mov    %eax,%edx
  1007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a9:	8b 40 08             	mov    0x8(%eax),%eax
  1007ac:	29 c2                	sub    %eax,%edx
  1007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1007b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007bb:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007c2:	00 
  1007c3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007ca:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d4:	89 04 24             	mov    %eax,(%esp)
  1007d7:	e8 b9 fc ff ff       	call   100495 <stab_binsearch>
    if (lline <= rline) {
  1007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007e2:	39 c2                	cmp    %eax,%edx
  1007e4:	7f 24                	jg     10080a <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	89 d0                	mov    %edx,%eax
  1007ed:	01 c0                	add    %eax,%eax
  1007ef:	01 d0                	add    %edx,%eax
  1007f1:	c1 e0 02             	shl    $0x2,%eax
  1007f4:	89 c2                	mov    %eax,%edx
  1007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ff:	0f b7 d0             	movzwl %ax,%edx
  100802:	8b 45 0c             	mov    0xc(%ebp),%eax
  100805:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100808:	eb 13                	jmp    10081d <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10080a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10080f:	e9 12 01 00 00       	jmp    100926 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100817:	83 e8 01             	sub    $0x1,%eax
  10081a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10081d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100823:	39 c2                	cmp    %eax,%edx
  100825:	7c 56                	jl     10087d <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082a:	89 c2                	mov    %eax,%edx
  10082c:	89 d0                	mov    %edx,%eax
  10082e:	01 c0                	add    %eax,%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	c1 e0 02             	shl    $0x2,%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083a:	01 d0                	add    %edx,%eax
  10083c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100840:	3c 84                	cmp    $0x84,%al
  100842:	74 39                	je     10087d <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100847:	89 c2                	mov    %eax,%edx
  100849:	89 d0                	mov    %edx,%eax
  10084b:	01 c0                	add    %eax,%eax
  10084d:	01 d0                	add    %edx,%eax
  10084f:	c1 e0 02             	shl    $0x2,%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100857:	01 d0                	add    %edx,%eax
  100859:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10085d:	3c 64                	cmp    $0x64,%al
  10085f:	75 b3                	jne    100814 <debuginfo_eip+0x229>
  100861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100864:	89 c2                	mov    %eax,%edx
  100866:	89 d0                	mov    %edx,%eax
  100868:	01 c0                	add    %eax,%eax
  10086a:	01 d0                	add    %edx,%eax
  10086c:	c1 e0 02             	shl    $0x2,%eax
  10086f:	89 c2                	mov    %eax,%edx
  100871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100874:	01 d0                	add    %edx,%eax
  100876:	8b 40 08             	mov    0x8(%eax),%eax
  100879:	85 c0                	test   %eax,%eax
  10087b:	74 97                	je     100814 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10087d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100883:	39 c2                	cmp    %eax,%edx
  100885:	7c 46                	jl     1008cd <debuginfo_eip+0x2e2>
  100887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088a:	89 c2                	mov    %eax,%edx
  10088c:	89 d0                	mov    %edx,%eax
  10088e:	01 c0                	add    %eax,%eax
  100890:	01 d0                	add    %edx,%eax
  100892:	c1 e0 02             	shl    $0x2,%eax
  100895:	89 c2                	mov    %eax,%edx
  100897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089a:	01 d0                	add    %edx,%eax
  10089c:	8b 10                	mov    (%eax),%edx
  10089e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008a4:	29 c1                	sub    %eax,%ecx
  1008a6:	89 c8                	mov    %ecx,%eax
  1008a8:	39 c2                	cmp    %eax,%edx
  1008aa:	73 21                	jae    1008cd <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	89 d0                	mov    %edx,%eax
  1008b3:	01 c0                	add    %eax,%eax
  1008b5:	01 d0                	add    %edx,%eax
  1008b7:	c1 e0 02             	shl    $0x2,%eax
  1008ba:	89 c2                	mov    %eax,%edx
  1008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008bf:	01 d0                	add    %edx,%eax
  1008c1:	8b 10                	mov    (%eax),%edx
  1008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008c6:	01 c2                	add    %eax,%edx
  1008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008cb:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008d3:	39 c2                	cmp    %eax,%edx
  1008d5:	7d 4a                	jge    100921 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008da:	83 c0 01             	add    $0x1,%eax
  1008dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008e0:	eb 18                	jmp    1008fa <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008e5:	8b 40 14             	mov    0x14(%eax),%eax
  1008e8:	8d 50 01             	lea    0x1(%eax),%edx
  1008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ee:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f4:	83 c0 01             	add    $0x1,%eax
  1008f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100900:	39 c2                	cmp    %eax,%edx
  100902:	7d 1d                	jge    100921 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100907:	89 c2                	mov    %eax,%edx
  100909:	89 d0                	mov    %edx,%eax
  10090b:	01 c0                	add    %eax,%eax
  10090d:	01 d0                	add    %edx,%eax
  10090f:	c1 e0 02             	shl    $0x2,%eax
  100912:	89 c2                	mov    %eax,%edx
  100914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100917:	01 d0                	add    %edx,%eax
  100919:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10091d:	3c a0                	cmp    $0xa0,%al
  10091f:	74 c1                	je     1008e2 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100921:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100926:	c9                   	leave  
  100927:	c3                   	ret    

00100928 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100928:	55                   	push   %ebp
  100929:	89 e5                	mov    %esp,%ebp
  10092b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10092e:	c7 04 24 fa 38 10 00 	movl   $0x1038fa,(%esp)
  100935:	e8 ba fa ff ff       	call   1003f4 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10093a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100941:	00 
  100942:	c7 04 24 13 39 10 00 	movl   $0x103913,(%esp)
  100949:	e8 a6 fa ff ff       	call   1003f4 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10094e:	c7 44 24 04 99 37 10 	movl   $0x103799,0x4(%esp)
  100955:	00 
  100956:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  10095d:	e8 92 fa ff ff       	call   1003f4 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100962:	c7 44 24 04 36 ea 10 	movl   $0x10ea36,0x4(%esp)
  100969:	00 
  10096a:	c7 04 24 43 39 10 00 	movl   $0x103943,(%esp)
  100971:	e8 7e fa ff ff       	call   1003f4 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100976:	c7 44 24 04 a0 fd 10 	movl   $0x10fda0,0x4(%esp)
  10097d:	00 
  10097e:	c7 04 24 5b 39 10 00 	movl   $0x10395b,(%esp)
  100985:	e8 6a fa ff ff       	call   1003f4 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10098a:	b8 a0 fd 10 00       	mov    $0x10fda0,%eax
  10098f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100995:	b8 00 00 10 00       	mov    $0x100000,%eax
  10099a:	29 c2                	sub    %eax,%edx
  10099c:	89 d0                	mov    %edx,%eax
  10099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a4:	85 c0                	test   %eax,%eax
  1009a6:	0f 48 c2             	cmovs  %edx,%eax
  1009a9:	c1 f8 0a             	sar    $0xa,%eax
  1009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b0:	c7 04 24 74 39 10 00 	movl   $0x103974,(%esp)
  1009b7:	e8 38 fa ff ff       	call   1003f4 <cprintf>
}
  1009bc:	c9                   	leave  
  1009bd:	c3                   	ret    

001009be <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009be:	55                   	push   %ebp
  1009bf:	89 e5                	mov    %esp,%ebp
  1009c1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009c7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d1:	89 04 24             	mov    %eax,(%esp)
  1009d4:	e8 12 fc ff ff       	call   1005eb <debuginfo_eip>
  1009d9:	85 c0                	test   %eax,%eax
  1009db:	74 15                	je     1009f2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009e4:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  1009eb:	e8 04 fa ff ff       	call   1003f4 <cprintf>
  1009f0:	eb 6d                	jmp    100a5f <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009f9:	eb 1c                	jmp    100a17 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a01:	01 d0                	add    %edx,%eax
  100a03:	0f b6 00             	movzbl (%eax),%eax
  100a06:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a0f:	01 ca                	add    %ecx,%edx
  100a11:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a1d:	7f dc                	jg     1009fb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100a1f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a28:	01 d0                	add    %edx,%eax
  100a2a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a30:	8b 55 08             	mov    0x8(%ebp),%edx
  100a33:	89 d1                	mov    %edx,%ecx
  100a35:	29 c1                	sub    %eax,%ecx
  100a37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a41:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a53:	c7 04 24 ba 39 10 00 	movl   $0x1039ba,(%esp)
  100a5a:	e8 95 f9 ff ff       	call   1003f4 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100a5f:	c9                   	leave  
  100a60:	c3                   	ret    

00100a61 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a61:	55                   	push   %ebp
  100a62:	89 e5                	mov    %esp,%ebp
  100a64:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a67:	8b 45 04             	mov    0x4(%ebp),%eax
  100a6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a70:	c9                   	leave  
  100a71:	c3                   	ret    

00100a72 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a72:	55                   	push   %ebp
  100a73:	89 e5                	mov    %esp,%ebp
  100a75:	83 ec 38             	sub    $0x38,%esp
	cprintf("Hello world\n");
  100a78:	c7 04 24 cc 39 10 00 	movl   $0x1039cc,(%esp)
  100a7f:	e8 70 f9 ff ff       	call   1003f4 <cprintf>
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a84:	89 e8                	mov    %ebp,%eax
  100a86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	uint32_t ebp = read_ebp();
  100a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  100a8f:	e8 cd ff ff ff       	call   100a61 <read_eip>
  100a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (ebp != 0)
  100a97:	e9 8e 00 00 00       	jmp    100b2a <print_stackframe+0xb8>
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  100a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aaa:	c7 04 24 d9 39 10 00 	movl   $0x1039d9,(%esp)
  100ab1:	e8 3e f9 ff ff       	call   1003f4 <cprintf>
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
  100ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab9:	83 c0 08             	add    $0x8,%eax
  100abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int i = 0;
  100abf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (; i < 4; i++)
  100ac6:	eb 2f                	jmp    100af7 <print_stackframe+0x85>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
  100ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad5:	01 d0                	add    %edx,%eax
  100ad7:	8b 00                	mov    (%eax),%eax
  100ad9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100adc:	83 c2 01             	add    $0x1,%edx
  100adf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae3:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ae7:	c7 04 24 f0 39 10 00 	movl   $0x1039f0,(%esp)
  100aee:	e8 01 f9 ff ff       	call   1003f4 <cprintf>
	while (ebp != 0)
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
		int i = 0;
		for (; i < 4; i++)
  100af3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100af7:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
  100afb:	7e cb                	jle    100ac8 <print_stackframe+0x56>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
		print_debuginfo(eip-1);
  100afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b00:	83 e8 01             	sub    $0x1,%eax
  100b03:	89 04 24             	mov    %eax,(%esp)
  100b06:	e8 b3 fe ff ff       	call   1009be <print_debuginfo>
		cprintf("\n");
  100b0b:	c7 04 24 fe 39 10 00 	movl   $0x1039fe,(%esp)
  100b12:	e8 dd f8 ff ff       	call   1003f4 <cprintf>
		eip = *((uint32_t*)ebp+1);
  100b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1a:	83 c0 04             	add    $0x4,%eax
  100b1d:	8b 00                	mov    (%eax),%eax
  100b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;	
  100b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b25:	8b 00                	mov    (%eax),%eax
  100b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	cprintf("Hello world\n");
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	while (ebp != 0)
  100b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b2e:	0f 85 68 ff ff ff    	jne    100a9c <print_stackframe+0x2a>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100b34:	c9                   	leave  
  100b35:	c3                   	ret    

00100b36 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b36:	55                   	push   %ebp
  100b37:	89 e5                	mov    %esp,%ebp
  100b39:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b43:	eb 0c                	jmp    100b51 <parse+0x1b>
            *buf ++ = '\0';
  100b45:	8b 45 08             	mov    0x8(%ebp),%eax
  100b48:	8d 50 01             	lea    0x1(%eax),%edx
  100b4b:	89 55 08             	mov    %edx,0x8(%ebp)
  100b4e:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b51:	8b 45 08             	mov    0x8(%ebp),%eax
  100b54:	0f b6 00             	movzbl (%eax),%eax
  100b57:	84 c0                	test   %al,%al
  100b59:	74 1d                	je     100b78 <parse+0x42>
  100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5e:	0f b6 00             	movzbl (%eax),%eax
  100b61:	0f be c0             	movsbl %al,%eax
  100b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b68:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  100b6f:	e8 dd 28 00 00       	call   103451 <strchr>
  100b74:	85 c0                	test   %eax,%eax
  100b76:	75 cd                	jne    100b45 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b78:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7b:	0f b6 00             	movzbl (%eax),%eax
  100b7e:	84 c0                	test   %al,%al
  100b80:	75 02                	jne    100b84 <parse+0x4e>
            break;
  100b82:	eb 67                	jmp    100beb <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b84:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b88:	75 14                	jne    100b9e <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b8a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b91:	00 
  100b92:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  100b99:	e8 56 f8 ff ff       	call   1003f4 <cprintf>
        }
        argv[argc ++] = buf;
  100b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba1:	8d 50 01             	lea    0x1(%eax),%edx
  100ba4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ba7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bb1:	01 c2                	add    %eax,%edx
  100bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb6:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb8:	eb 04                	jmp    100bbe <parse+0x88>
            buf ++;
  100bba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc1:	0f b6 00             	movzbl (%eax),%eax
  100bc4:	84 c0                	test   %al,%al
  100bc6:	74 1d                	je     100be5 <parse+0xaf>
  100bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bcb:	0f b6 00             	movzbl (%eax),%eax
  100bce:	0f be c0             	movsbl %al,%eax
  100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd5:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  100bdc:	e8 70 28 00 00       	call   103451 <strchr>
  100be1:	85 c0                	test   %eax,%eax
  100be3:	74 d5                	je     100bba <parse+0x84>
            buf ++;
        }
    }
  100be5:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100be6:	e9 66 ff ff ff       	jmp    100b51 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bee:	c9                   	leave  
  100bef:	c3                   	ret    

00100bf0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bf0:	55                   	push   %ebp
  100bf1:	89 e5                	mov    %esp,%ebp
  100bf3:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bf6:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  100c00:	89 04 24             	mov    %eax,(%esp)
  100c03:	e8 2e ff ff ff       	call   100b36 <parse>
  100c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c0f:	75 0a                	jne    100c1b <runcmd+0x2b>
        return 0;
  100c11:	b8 00 00 00 00       	mov    $0x0,%eax
  100c16:	e9 85 00 00 00       	jmp    100ca0 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c22:	eb 5c                	jmp    100c80 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c24:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2a:	89 d0                	mov    %edx,%eax
  100c2c:	01 c0                	add    %eax,%eax
  100c2e:	01 d0                	add    %edx,%eax
  100c30:	c1 e0 02             	shl    $0x2,%eax
  100c33:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c38:	8b 00                	mov    (%eax),%eax
  100c3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c3e:	89 04 24             	mov    %eax,(%esp)
  100c41:	e8 6c 27 00 00       	call   1033b2 <strcmp>
  100c46:	85 c0                	test   %eax,%eax
  100c48:	75 32                	jne    100c7c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4d:	89 d0                	mov    %edx,%eax
  100c4f:	01 c0                	add    %eax,%eax
  100c51:	01 d0                	add    %edx,%eax
  100c53:	c1 e0 02             	shl    $0x2,%eax
  100c56:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c5b:	8b 40 08             	mov    0x8(%eax),%eax
  100c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c61:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c67:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c6b:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c6e:	83 c2 04             	add    $0x4,%edx
  100c71:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c75:	89 0c 24             	mov    %ecx,(%esp)
  100c78:	ff d0                	call   *%eax
  100c7a:	eb 24                	jmp    100ca0 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c7c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c83:	83 f8 02             	cmp    $0x2,%eax
  100c86:	76 9c                	jbe    100c24 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8f:	c7 04 24 a3 3a 10 00 	movl   $0x103aa3,(%esp)
  100c96:	e8 59 f7 ff ff       	call   1003f4 <cprintf>
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ca8:	c7 04 24 bc 3a 10 00 	movl   $0x103abc,(%esp)
  100caf:	e8 40 f7 ff ff       	call   1003f4 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cb4:	c7 04 24 e4 3a 10 00 	movl   $0x103ae4,(%esp)
  100cbb:	e8 34 f7 ff ff       	call   1003f4 <cprintf>

    if (tf != NULL) {
  100cc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cc4:	74 0b                	je     100cd1 <kmonitor+0x2f>
        print_trapframe(tf);
  100cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc9:	89 04 24             	mov    %eax,(%esp)
  100ccc:	e8 cd 0d 00 00       	call   101a9e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cd1:	c7 04 24 09 3b 10 00 	movl   $0x103b09,(%esp)
  100cd8:	e8 0e f6 ff ff       	call   1002eb <readline>
  100cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ce0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ce4:	74 18                	je     100cfe <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf0:	89 04 24             	mov    %eax,(%esp)
  100cf3:	e8 f8 fe ff ff       	call   100bf0 <runcmd>
  100cf8:	85 c0                	test   %eax,%eax
  100cfa:	79 02                	jns    100cfe <kmonitor+0x5c>
                break;
  100cfc:	eb 02                	jmp    100d00 <kmonitor+0x5e>
            }
        }
    }
  100cfe:	eb d1                	jmp    100cd1 <kmonitor+0x2f>
}
  100d00:	c9                   	leave  
  100d01:	c3                   	ret    

00100d02 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d02:	55                   	push   %ebp
  100d03:	89 e5                	mov    %esp,%ebp
  100d05:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d0f:	eb 3f                	jmp    100d50 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d14:	89 d0                	mov    %edx,%eax
  100d16:	01 c0                	add    %eax,%eax
  100d18:	01 d0                	add    %edx,%eax
  100d1a:	c1 e0 02             	shl    $0x2,%eax
  100d1d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d22:	8b 48 04             	mov    0x4(%eax),%ecx
  100d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d28:	89 d0                	mov    %edx,%eax
  100d2a:	01 c0                	add    %eax,%eax
  100d2c:	01 d0                	add    %edx,%eax
  100d2e:	c1 e0 02             	shl    $0x2,%eax
  100d31:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d36:	8b 00                	mov    (%eax),%eax
  100d38:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d40:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  100d47:	e8 a8 f6 ff ff       	call   1003f4 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d53:	83 f8 02             	cmp    $0x2,%eax
  100d56:	76 b9                	jbe    100d11 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5d:	c9                   	leave  
  100d5e:	c3                   	ret    

00100d5f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d5f:	55                   	push   %ebp
  100d60:	89 e5                	mov    %esp,%ebp
  100d62:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d65:	e8 be fb ff ff       	call   100928 <print_kerninfo>
    return 0;
  100d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6f:	c9                   	leave  
  100d70:	c3                   	ret    

00100d71 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d71:	55                   	push   %ebp
  100d72:	89 e5                	mov    %esp,%ebp
  100d74:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d77:	e8 f6 fc ff ff       	call   100a72 <print_stackframe>
    return 0;
  100d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d81:	c9                   	leave  
  100d82:	c3                   	ret    

00100d83 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100d83:	55                   	push   %ebp
  100d84:	89 e5                	mov    %esp,%ebp
  100d86:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100d89:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  100d8e:	85 c0                	test   %eax,%eax
  100d90:	74 02                	je     100d94 <__panic+0x11>
        goto panic_dead;
  100d92:	eb 48                	jmp    100ddc <__panic+0x59>
    }
    is_panic = 1;
  100d94:	c7 05 60 ee 10 00 01 	movl   $0x1,0x10ee60
  100d9b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d9e:	8d 45 14             	lea    0x14(%ebp),%eax
  100da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100da7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100dab:	8b 45 08             	mov    0x8(%ebp),%eax
  100dae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100db2:	c7 04 24 16 3b 10 00 	movl   $0x103b16,(%esp)
  100db9:	e8 36 f6 ff ff       	call   1003f4 <cprintf>
    vcprintf(fmt, ap);
  100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  100dc8:	89 04 24             	mov    %eax,(%esp)
  100dcb:	e8 f1 f5 ff ff       	call   1003c1 <vcprintf>
    cprintf("\n");
  100dd0:	c7 04 24 32 3b 10 00 	movl   $0x103b32,(%esp)
  100dd7:	e8 18 f6 ff ff       	call   1003f4 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100ddc:	e8 22 09 00 00       	call   101703 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de8:	e8 b5 fe ff ff       	call   100ca2 <kmonitor>
    }
  100ded:	eb f2                	jmp    100de1 <__panic+0x5e>

00100def <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100def:	55                   	push   %ebp
  100df0:	89 e5                	mov    %esp,%ebp
  100df2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100df5:	8d 45 14             	lea    0x14(%ebp),%eax
  100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100dfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e02:	8b 45 08             	mov    0x8(%ebp),%eax
  100e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e09:	c7 04 24 34 3b 10 00 	movl   $0x103b34,(%esp)
  100e10:	e8 df f5 ff ff       	call   1003f4 <cprintf>
    vcprintf(fmt, ap);
  100e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  100e1f:	89 04 24             	mov    %eax,(%esp)
  100e22:	e8 9a f5 ff ff       	call   1003c1 <vcprintf>
    cprintf("\n");
  100e27:	c7 04 24 32 3b 10 00 	movl   $0x103b32,(%esp)
  100e2e:	e8 c1 f5 ff ff       	call   1003f4 <cprintf>
    va_end(ap);
}
  100e33:	c9                   	leave  
  100e34:	c3                   	ret    

00100e35 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100e35:	55                   	push   %ebp
  100e36:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100e38:	a1 60 ee 10 00       	mov    0x10ee60,%eax
}
  100e3d:	5d                   	pop    %ebp
  100e3e:	c3                   	ret    

00100e3f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100e3f:	55                   	push   %ebp
  100e40:	89 e5                	mov    %esp,%ebp
  100e42:	83 ec 28             	sub    $0x28,%esp
  100e45:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100e4b:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e4f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e53:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e57:	ee                   	out    %al,(%dx)
  100e58:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e5e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100e62:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e66:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6a:	ee                   	out    %al,(%dx)
  100e6b:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100e71:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100e75:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e79:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e7d:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e7e:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100e85:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e88:	c7 04 24 52 3b 10 00 	movl   $0x103b52,(%esp)
  100e8f:	e8 60 f5 ff ff       	call   1003f4 <cprintf>
    pic_enable(IRQ_TIMER);
  100e94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e9b:	e8 c1 08 00 00       	call   101761 <pic_enable>
}
  100ea0:	c9                   	leave  
  100ea1:	c3                   	ret    

00100ea2 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ea2:	55                   	push   %ebp
  100ea3:	89 e5                	mov    %esp,%ebp
  100ea5:	83 ec 10             	sub    $0x10,%esp
  100ea8:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eae:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100eb2:	89 c2                	mov    %eax,%edx
  100eb4:	ec                   	in     (%dx),%al
  100eb5:	88 45 fd             	mov    %al,-0x3(%ebp)
  100eb8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ebe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ec2:	89 c2                	mov    %eax,%edx
  100ec4:	ec                   	in     (%dx),%al
  100ec5:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ec8:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ece:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ed2:	89 c2                	mov    %eax,%edx
  100ed4:	ec                   	in     (%dx),%al
  100ed5:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ed8:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100ede:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ee2:	89 c2                	mov    %eax,%edx
  100ee4:	ec                   	in     (%dx),%al
  100ee5:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ee8:	c9                   	leave  
  100ee9:	c3                   	ret    

00100eea <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eea:	55                   	push   %ebp
  100eeb:	89 e5                	mov    %esp,%ebp
  100eed:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100ef0:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efa:	0f b7 00             	movzwl (%eax),%eax
  100efd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f04:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0c:	0f b7 00             	movzwl (%eax),%eax
  100f0f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100f13:	74 12                	je     100f27 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100f15:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f1c:	66 c7 05 86 ee 10 00 	movw   $0x3b4,0x10ee86
  100f23:	b4 03 
  100f25:	eb 13                	jmp    100f3a <cga_init+0x50>
    } else {
        *cp = was;
  100f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f2e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f31:	66 c7 05 86 ee 10 00 	movw   $0x3d4,0x10ee86
  100f38:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f3a:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  100f41:	0f b7 c0             	movzwl %ax,%eax
  100f44:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100f48:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f4c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100f55:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  100f5c:	83 c0 01             	add    $0x1,%eax
  100f5f:	0f b7 c0             	movzwl %ax,%eax
  100f62:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f66:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f6a:	89 c2                	mov    %eax,%edx
  100f6c:	ec                   	in     (%dx),%al
  100f6d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f70:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f74:	0f b6 c0             	movzbl %al,%eax
  100f77:	c1 e0 08             	shl    $0x8,%eax
  100f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f7d:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  100f84:	0f b7 c0             	movzwl %ax,%eax
  100f87:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f8b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f93:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f97:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f98:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  100f9f:	83 c0 01             	add    $0x1,%eax
  100fa2:	0f b7 c0             	movzwl %ax,%eax
  100fa5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fad:	89 c2                	mov    %eax,%edx
  100faf:	ec                   	in     (%dx),%al
  100fb0:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb7:	0f b6 c0             	movzbl %al,%eax
  100fba:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc0:	a3 80 ee 10 00       	mov    %eax,0x10ee80
    crt_pos = pos;
  100fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fc8:	66 a3 84 ee 10 00    	mov    %ax,0x10ee84
}
  100fce:	c9                   	leave  
  100fcf:	c3                   	ret    

00100fd0 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd0:	55                   	push   %ebp
  100fd1:	89 e5                	mov    %esp,%ebp
  100fd3:	83 ec 48             	sub    $0x48,%esp
  100fd6:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100fdc:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fe4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fe8:	ee                   	out    %al,(%dx)
  100fe9:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100fef:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ff3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ff7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ffb:	ee                   	out    %al,(%dx)
  100ffc:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  101002:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  101006:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10100a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10100e:	ee                   	out    %al,(%dx)
  10100f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101015:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  101019:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10101d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
  101022:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  101028:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  10102c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101030:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
  101035:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  10103b:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  10103f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101043:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
  101048:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10104e:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  101052:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101056:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10105a:	ee                   	out    %al,(%dx)
  10105b:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101061:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101065:	89 c2                	mov    %eax,%edx
  101067:	ec                   	in     (%dx),%al
  101068:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  10106b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10106f:	3c ff                	cmp    $0xff,%al
  101071:	0f 95 c0             	setne  %al
  101074:	0f b6 c0             	movzbl %al,%eax
  101077:	a3 88 ee 10 00       	mov    %eax,0x10ee88
  10107c:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101082:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101086:	89 c2                	mov    %eax,%edx
  101088:	ec                   	in     (%dx),%al
  101089:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10108c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101092:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101096:	89 c2                	mov    %eax,%edx
  101098:	ec                   	in     (%dx),%al
  101099:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10109c:	a1 88 ee 10 00       	mov    0x10ee88,%eax
  1010a1:	85 c0                	test   %eax,%eax
  1010a3:	74 0c                	je     1010b1 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  1010a5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010ac:	e8 b0 06 00 00       	call   101761 <pic_enable>
    }
}
  1010b1:	c9                   	leave  
  1010b2:	c3                   	ret    

001010b3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010b3:	55                   	push   %ebp
  1010b4:	89 e5                	mov    %esp,%ebp
  1010b6:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010c0:	eb 09                	jmp    1010cb <lpt_putc_sub+0x18>
        delay();
  1010c2:	e8 db fd ff ff       	call   100ea2 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1010cb:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010d1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010d5:	89 c2                	mov    %eax,%edx
  1010d7:	ec                   	in     (%dx),%al
  1010d8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010db:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010df:	84 c0                	test   %al,%al
  1010e1:	78 09                	js     1010ec <lpt_putc_sub+0x39>
  1010e3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010ea:	7e d6                	jle    1010c2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ef:	0f b6 c0             	movzbl %al,%eax
  1010f2:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  1010f8:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010fb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ff:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101103:	ee                   	out    %al,(%dx)
  101104:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10110a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10110e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101112:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101116:	ee                   	out    %al,(%dx)
  101117:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10111d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101121:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101125:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101129:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10112a:	c9                   	leave  
  10112b:	c3                   	ret    

0010112c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10112c:	55                   	push   %ebp
  10112d:	89 e5                	mov    %esp,%ebp
  10112f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101132:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101136:	74 0d                	je     101145 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101138:	8b 45 08             	mov    0x8(%ebp),%eax
  10113b:	89 04 24             	mov    %eax,(%esp)
  10113e:	e8 70 ff ff ff       	call   1010b3 <lpt_putc_sub>
  101143:	eb 24                	jmp    101169 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101145:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10114c:	e8 62 ff ff ff       	call   1010b3 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101151:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101158:	e8 56 ff ff ff       	call   1010b3 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10115d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101164:	e8 4a ff ff ff       	call   1010b3 <lpt_putc_sub>
    }
}
  101169:	c9                   	leave  
  10116a:	c3                   	ret    

0010116b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10116b:	55                   	push   %ebp
  10116c:	89 e5                	mov    %esp,%ebp
  10116e:	53                   	push   %ebx
  10116f:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101172:	8b 45 08             	mov    0x8(%ebp),%eax
  101175:	b0 00                	mov    $0x0,%al
  101177:	85 c0                	test   %eax,%eax
  101179:	75 07                	jne    101182 <cga_putc+0x17>
        c |= 0x0700;
  10117b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101182:	8b 45 08             	mov    0x8(%ebp),%eax
  101185:	0f b6 c0             	movzbl %al,%eax
  101188:	83 f8 0a             	cmp    $0xa,%eax
  10118b:	74 4c                	je     1011d9 <cga_putc+0x6e>
  10118d:	83 f8 0d             	cmp    $0xd,%eax
  101190:	74 57                	je     1011e9 <cga_putc+0x7e>
  101192:	83 f8 08             	cmp    $0x8,%eax
  101195:	0f 85 88 00 00 00    	jne    101223 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10119b:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  1011a2:	66 85 c0             	test   %ax,%ax
  1011a5:	74 30                	je     1011d7 <cga_putc+0x6c>
            crt_pos --;
  1011a7:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  1011ae:	83 e8 01             	sub    $0x1,%eax
  1011b1:	66 a3 84 ee 10 00    	mov    %ax,0x10ee84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011b7:	a1 80 ee 10 00       	mov    0x10ee80,%eax
  1011bc:	0f b7 15 84 ee 10 00 	movzwl 0x10ee84,%edx
  1011c3:	0f b7 d2             	movzwl %dx,%edx
  1011c6:	01 d2                	add    %edx,%edx
  1011c8:	01 c2                	add    %eax,%edx
  1011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cd:	b0 00                	mov    $0x0,%al
  1011cf:	83 c8 20             	or     $0x20,%eax
  1011d2:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011d5:	eb 72                	jmp    101249 <cga_putc+0xde>
  1011d7:	eb 70                	jmp    101249 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1011d9:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  1011e0:	83 c0 50             	add    $0x50,%eax
  1011e3:	66 a3 84 ee 10 00    	mov    %ax,0x10ee84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011e9:	0f b7 1d 84 ee 10 00 	movzwl 0x10ee84,%ebx
  1011f0:	0f b7 0d 84 ee 10 00 	movzwl 0x10ee84,%ecx
  1011f7:	0f b7 c1             	movzwl %cx,%eax
  1011fa:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101200:	c1 e8 10             	shr    $0x10,%eax
  101203:	89 c2                	mov    %eax,%edx
  101205:	66 c1 ea 06          	shr    $0x6,%dx
  101209:	89 d0                	mov    %edx,%eax
  10120b:	c1 e0 02             	shl    $0x2,%eax
  10120e:	01 d0                	add    %edx,%eax
  101210:	c1 e0 04             	shl    $0x4,%eax
  101213:	29 c1                	sub    %eax,%ecx
  101215:	89 ca                	mov    %ecx,%edx
  101217:	89 d8                	mov    %ebx,%eax
  101219:	29 d0                	sub    %edx,%eax
  10121b:	66 a3 84 ee 10 00    	mov    %ax,0x10ee84
        break;
  101221:	eb 26                	jmp    101249 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101223:	8b 0d 80 ee 10 00    	mov    0x10ee80,%ecx
  101229:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  101230:	8d 50 01             	lea    0x1(%eax),%edx
  101233:	66 89 15 84 ee 10 00 	mov    %dx,0x10ee84
  10123a:	0f b7 c0             	movzwl %ax,%eax
  10123d:	01 c0                	add    %eax,%eax
  10123f:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101242:	8b 45 08             	mov    0x8(%ebp),%eax
  101245:	66 89 02             	mov    %ax,(%edx)
        break;
  101248:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101249:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  101250:	66 3d cf 07          	cmp    $0x7cf,%ax
  101254:	76 5b                	jbe    1012b1 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101256:	a1 80 ee 10 00       	mov    0x10ee80,%eax
  10125b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101261:	a1 80 ee 10 00       	mov    0x10ee80,%eax
  101266:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10126d:	00 
  10126e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101272:	89 04 24             	mov    %eax,(%esp)
  101275:	e8 d5 23 00 00       	call   10364f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10127a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101281:	eb 15                	jmp    101298 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101283:	a1 80 ee 10 00       	mov    0x10ee80,%eax
  101288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10128b:	01 d2                	add    %edx,%edx
  10128d:	01 d0                	add    %edx,%eax
  10128f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101294:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101298:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10129f:	7e e2                	jle    101283 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1012a1:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  1012a8:	83 e8 50             	sub    $0x50,%eax
  1012ab:	66 a3 84 ee 10 00    	mov    %ax,0x10ee84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012b1:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  1012b8:	0f b7 c0             	movzwl %ax,%eax
  1012bb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1012bf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1012c3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012c7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012cb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1012cc:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  1012d3:	66 c1 e8 08          	shr    $0x8,%ax
  1012d7:	0f b6 c0             	movzbl %al,%eax
  1012da:	0f b7 15 86 ee 10 00 	movzwl 0x10ee86,%edx
  1012e1:	83 c2 01             	add    $0x1,%edx
  1012e4:	0f b7 d2             	movzwl %dx,%edx
  1012e7:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012eb:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012f6:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012f7:	0f b7 05 86 ee 10 00 	movzwl 0x10ee86,%eax
  1012fe:	0f b7 c0             	movzwl %ax,%eax
  101301:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101305:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101309:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10130d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101311:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101312:	0f b7 05 84 ee 10 00 	movzwl 0x10ee84,%eax
  101319:	0f b6 c0             	movzbl %al,%eax
  10131c:	0f b7 15 86 ee 10 00 	movzwl 0x10ee86,%edx
  101323:	83 c2 01             	add    $0x1,%edx
  101326:	0f b7 d2             	movzwl %dx,%edx
  101329:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10132d:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101330:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101334:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101338:	ee                   	out    %al,(%dx)
}
  101339:	83 c4 34             	add    $0x34,%esp
  10133c:	5b                   	pop    %ebx
  10133d:	5d                   	pop    %ebp
  10133e:	c3                   	ret    

0010133f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10133f:	55                   	push   %ebp
  101340:	89 e5                	mov    %esp,%ebp
  101342:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10134c:	eb 09                	jmp    101357 <serial_putc_sub+0x18>
        delay();
  10134e:	e8 4f fb ff ff       	call   100ea2 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101353:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101357:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10135d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101361:	89 c2                	mov    %eax,%edx
  101363:	ec                   	in     (%dx),%al
  101364:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101367:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10136b:	0f b6 c0             	movzbl %al,%eax
  10136e:	83 e0 20             	and    $0x20,%eax
  101371:	85 c0                	test   %eax,%eax
  101373:	75 09                	jne    10137e <serial_putc_sub+0x3f>
  101375:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10137c:	7e d0                	jle    10134e <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10137e:	8b 45 08             	mov    0x8(%ebp),%eax
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10138a:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10138d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101391:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101395:	ee                   	out    %al,(%dx)
}
  101396:	c9                   	leave  
  101397:	c3                   	ret    

00101398 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101398:	55                   	push   %ebp
  101399:	89 e5                	mov    %esp,%ebp
  10139b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10139e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a2:	74 0d                	je     1013b1 <serial_putc+0x19>
        serial_putc_sub(c);
  1013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a7:	89 04 24             	mov    %eax,(%esp)
  1013aa:	e8 90 ff ff ff       	call   10133f <serial_putc_sub>
  1013af:	eb 24                	jmp    1013d5 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1013b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b8:	e8 82 ff ff ff       	call   10133f <serial_putc_sub>
        serial_putc_sub(' ');
  1013bd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c4:	e8 76 ff ff ff       	call   10133f <serial_putc_sub>
        serial_putc_sub('\b');
  1013c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013d0:	e8 6a ff ff ff       	call   10133f <serial_putc_sub>
    }
}
  1013d5:	c9                   	leave  
  1013d6:	c3                   	ret    

001013d7 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013d7:	55                   	push   %ebp
  1013d8:	89 e5                	mov    %esp,%ebp
  1013da:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013dd:	eb 33                	jmp    101412 <cons_intr+0x3b>
        if (c != 0) {
  1013df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e3:	74 2d                	je     101412 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013e5:	a1 a4 f0 10 00       	mov    0x10f0a4,%eax
  1013ea:	8d 50 01             	lea    0x1(%eax),%edx
  1013ed:	89 15 a4 f0 10 00    	mov    %edx,0x10f0a4
  1013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013f6:	88 90 a0 ee 10 00    	mov    %dl,0x10eea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013fc:	a1 a4 f0 10 00       	mov    0x10f0a4,%eax
  101401:	3d 00 02 00 00       	cmp    $0x200,%eax
  101406:	75 0a                	jne    101412 <cons_intr+0x3b>
                cons.wpos = 0;
  101408:	c7 05 a4 f0 10 00 00 	movl   $0x0,0x10f0a4
  10140f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101412:	8b 45 08             	mov    0x8(%ebp),%eax
  101415:	ff d0                	call   *%eax
  101417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10141a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10141e:	75 bf                	jne    1013df <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101420:	c9                   	leave  
  101421:	c3                   	ret    

00101422 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101422:	55                   	push   %ebp
  101423:	89 e5                	mov    %esp,%ebp
  101425:	83 ec 10             	sub    $0x10,%esp
  101428:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10142e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101432:	89 c2                	mov    %eax,%edx
  101434:	ec                   	in     (%dx),%al
  101435:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101438:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10143c:	0f b6 c0             	movzbl %al,%eax
  10143f:	83 e0 01             	and    $0x1,%eax
  101442:	85 c0                	test   %eax,%eax
  101444:	75 07                	jne    10144d <serial_proc_data+0x2b>
        return -1;
  101446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10144b:	eb 2a                	jmp    101477 <serial_proc_data+0x55>
  10144d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101453:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101457:	89 c2                	mov    %eax,%edx
  101459:	ec                   	in     (%dx),%al
  10145a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10145d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101461:	0f b6 c0             	movzbl %al,%eax
  101464:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101467:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10146b:	75 07                	jne    101474 <serial_proc_data+0x52>
        c = '\b';
  10146d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101474:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101477:	c9                   	leave  
  101478:	c3                   	ret    

00101479 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101479:	55                   	push   %ebp
  10147a:	89 e5                	mov    %esp,%ebp
  10147c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10147f:	a1 88 ee 10 00       	mov    0x10ee88,%eax
  101484:	85 c0                	test   %eax,%eax
  101486:	74 0c                	je     101494 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101488:	c7 04 24 22 14 10 00 	movl   $0x101422,(%esp)
  10148f:	e8 43 ff ff ff       	call   1013d7 <cons_intr>
    }
}
  101494:	c9                   	leave  
  101495:	c3                   	ret    

00101496 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101496:	55                   	push   %ebp
  101497:	89 e5                	mov    %esp,%ebp
  101499:	83 ec 38             	sub    $0x38,%esp
  10149c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014a2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1014a6:	89 c2                	mov    %eax,%edx
  1014a8:	ec                   	in     (%dx),%al
  1014a9:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014b0:	0f b6 c0             	movzbl %al,%eax
  1014b3:	83 e0 01             	and    $0x1,%eax
  1014b6:	85 c0                	test   %eax,%eax
  1014b8:	75 0a                	jne    1014c4 <kbd_proc_data+0x2e>
        return -1;
  1014ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014bf:	e9 59 01 00 00       	jmp    10161d <kbd_proc_data+0x187>
  1014c4:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1014ce:	89 c2                	mov    %eax,%edx
  1014d0:	ec                   	in     (%dx),%al
  1014d1:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014d4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d8:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014db:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014df:	75 17                	jne    1014f8 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1014e1:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  1014e6:	83 c8 40             	or     $0x40,%eax
  1014e9:	a3 a8 f0 10 00       	mov    %eax,0x10f0a8
        return 0;
  1014ee:	b8 00 00 00 00       	mov    $0x0,%eax
  1014f3:	e9 25 01 00 00       	jmp    10161d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fc:	84 c0                	test   %al,%al
  1014fe:	79 47                	jns    101547 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101500:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  101505:	83 e0 40             	and    $0x40,%eax
  101508:	85 c0                	test   %eax,%eax
  10150a:	75 09                	jne    101515 <kbd_proc_data+0x7f>
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	83 e0 7f             	and    $0x7f,%eax
  101513:	eb 04                	jmp    101519 <kbd_proc_data+0x83>
  101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101519:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101520:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101527:	83 c8 40             	or     $0x40,%eax
  10152a:	0f b6 c0             	movzbl %al,%eax
  10152d:	f7 d0                	not    %eax
  10152f:	89 c2                	mov    %eax,%edx
  101531:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  101536:	21 d0                	and    %edx,%eax
  101538:	a3 a8 f0 10 00       	mov    %eax,0x10f0a8
        return 0;
  10153d:	b8 00 00 00 00       	mov    $0x0,%eax
  101542:	e9 d6 00 00 00       	jmp    10161d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101547:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  10154c:	83 e0 40             	and    $0x40,%eax
  10154f:	85 c0                	test   %eax,%eax
  101551:	74 11                	je     101564 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101553:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101557:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  10155c:	83 e0 bf             	and    $0xffffffbf,%eax
  10155f:	a3 a8 f0 10 00       	mov    %eax,0x10f0a8
    }

    shift |= shiftcode[data];
  101564:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101568:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10156f:	0f b6 d0             	movzbl %al,%edx
  101572:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  101577:	09 d0                	or     %edx,%eax
  101579:	a3 a8 f0 10 00       	mov    %eax,0x10f0a8
    shift ^= togglecode[data];
  10157e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101582:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101589:	0f b6 d0             	movzbl %al,%edx
  10158c:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  101591:	31 d0                	xor    %edx,%eax
  101593:	a3 a8 f0 10 00       	mov    %eax,0x10f0a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101598:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  10159d:	83 e0 03             	and    $0x3,%eax
  1015a0:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1015a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015ab:	01 d0                	add    %edx,%eax
  1015ad:	0f b6 00             	movzbl (%eax),%eax
  1015b0:	0f b6 c0             	movzbl %al,%eax
  1015b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015b6:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  1015bb:	83 e0 08             	and    $0x8,%eax
  1015be:	85 c0                	test   %eax,%eax
  1015c0:	74 22                	je     1015e4 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015c2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015c6:	7e 0c                	jle    1015d4 <kbd_proc_data+0x13e>
  1015c8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015cc:	7f 06                	jg     1015d4 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015ce:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015d2:	eb 10                	jmp    1015e4 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015d4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d8:	7e 0a                	jle    1015e4 <kbd_proc_data+0x14e>
  1015da:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015de:	7f 04                	jg     1015e4 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015e0:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015e4:	a1 a8 f0 10 00       	mov    0x10f0a8,%eax
  1015e9:	f7 d0                	not    %eax
  1015eb:	83 e0 06             	and    $0x6,%eax
  1015ee:	85 c0                	test   %eax,%eax
  1015f0:	75 28                	jne    10161a <kbd_proc_data+0x184>
  1015f2:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f9:	75 1f                	jne    10161a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015fb:	c7 04 24 6d 3b 10 00 	movl   $0x103b6d,(%esp)
  101602:	e8 ed ed ff ff       	call   1003f4 <cprintf>
  101607:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10160d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101611:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101615:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101619:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10161d:	c9                   	leave  
  10161e:	c3                   	ret    

0010161f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10161f:	55                   	push   %ebp
  101620:	89 e5                	mov    %esp,%ebp
  101622:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101625:	c7 04 24 96 14 10 00 	movl   $0x101496,(%esp)
  10162c:	e8 a6 fd ff ff       	call   1013d7 <cons_intr>
}
  101631:	c9                   	leave  
  101632:	c3                   	ret    

00101633 <kbd_init>:

static void
kbd_init(void) {
  101633:	55                   	push   %ebp
  101634:	89 e5                	mov    %esp,%ebp
  101636:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101639:	e8 e1 ff ff ff       	call   10161f <kbd_intr>
    pic_enable(IRQ_KBD);
  10163e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101645:	e8 17 01 00 00       	call   101761 <pic_enable>
}
  10164a:	c9                   	leave  
  10164b:	c3                   	ret    

0010164c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10164c:	55                   	push   %ebp
  10164d:	89 e5                	mov    %esp,%ebp
  10164f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101652:	e8 93 f8 ff ff       	call   100eea <cga_init>
    serial_init();
  101657:	e8 74 f9 ff ff       	call   100fd0 <serial_init>
    kbd_init();
  10165c:	e8 d2 ff ff ff       	call   101633 <kbd_init>
    if (!serial_exists) {
  101661:	a1 88 ee 10 00       	mov    0x10ee88,%eax
  101666:	85 c0                	test   %eax,%eax
  101668:	75 0c                	jne    101676 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10166a:	c7 04 24 79 3b 10 00 	movl   $0x103b79,(%esp)
  101671:	e8 7e ed ff ff       	call   1003f4 <cprintf>
    }
}
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101678:	55                   	push   %ebp
  101679:	89 e5                	mov    %esp,%ebp
  10167b:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10167e:	8b 45 08             	mov    0x8(%ebp),%eax
  101681:	89 04 24             	mov    %eax,(%esp)
  101684:	e8 a3 fa ff ff       	call   10112c <lpt_putc>
    cga_putc(c);
  101689:	8b 45 08             	mov    0x8(%ebp),%eax
  10168c:	89 04 24             	mov    %eax,(%esp)
  10168f:	e8 d7 fa ff ff       	call   10116b <cga_putc>
    serial_putc(c);
  101694:	8b 45 08             	mov    0x8(%ebp),%eax
  101697:	89 04 24             	mov    %eax,(%esp)
  10169a:	e8 f9 fc ff ff       	call   101398 <serial_putc>
}
  10169f:	c9                   	leave  
  1016a0:	c3                   	ret    

001016a1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016a1:	55                   	push   %ebp
  1016a2:	89 e5                	mov    %esp,%ebp
  1016a4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016a7:	e8 cd fd ff ff       	call   101479 <serial_intr>
    kbd_intr();
  1016ac:	e8 6e ff ff ff       	call   10161f <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016b1:	8b 15 a0 f0 10 00    	mov    0x10f0a0,%edx
  1016b7:	a1 a4 f0 10 00       	mov    0x10f0a4,%eax
  1016bc:	39 c2                	cmp    %eax,%edx
  1016be:	74 36                	je     1016f6 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1016c0:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  1016c5:	8d 50 01             	lea    0x1(%eax),%edx
  1016c8:	89 15 a0 f0 10 00    	mov    %edx,0x10f0a0
  1016ce:	0f b6 80 a0 ee 10 00 	movzbl 0x10eea0(%eax),%eax
  1016d5:	0f b6 c0             	movzbl %al,%eax
  1016d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016db:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  1016e0:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016e5:	75 0a                	jne    1016f1 <cons_getc+0x50>
            cons.rpos = 0;
  1016e7:	c7 05 a0 f0 10 00 00 	movl   $0x0,0x10f0a0
  1016ee:	00 00 00 
        }
        return c;
  1016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016f4:	eb 05                	jmp    1016fb <cons_getc+0x5a>
    }
    return 0;
  1016f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016fb:	c9                   	leave  
  1016fc:	c3                   	ret    

001016fd <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016fd:	55                   	push   %ebp
  1016fe:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101700:	fb                   	sti    
    sti();
}
  101701:	5d                   	pop    %ebp
  101702:	c3                   	ret    

00101703 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101703:	55                   	push   %ebp
  101704:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101706:	fa                   	cli    
    cli();
}
  101707:	5d                   	pop    %ebp
  101708:	c3                   	ret    

00101709 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101709:	55                   	push   %ebp
  10170a:	89 e5                	mov    %esp,%ebp
  10170c:	83 ec 14             	sub    $0x14,%esp
  10170f:	8b 45 08             	mov    0x8(%ebp),%eax
  101712:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101716:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10171a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101720:	a1 ac f0 10 00       	mov    0x10f0ac,%eax
  101725:	85 c0                	test   %eax,%eax
  101727:	74 36                	je     10175f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101729:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10172d:	0f b6 c0             	movzbl %al,%eax
  101730:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101736:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101739:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10173d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101741:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101742:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101746:	66 c1 e8 08          	shr    $0x8,%ax
  10174a:	0f b6 c0             	movzbl %al,%eax
  10174d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101753:	88 45 f9             	mov    %al,-0x7(%ebp)
  101756:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10175a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
    }
}
  10175f:	c9                   	leave  
  101760:	c3                   	ret    

00101761 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101761:	55                   	push   %ebp
  101762:	89 e5                	mov    %esp,%ebp
  101764:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101767:	8b 45 08             	mov    0x8(%ebp),%eax
  10176a:	ba 01 00 00 00       	mov    $0x1,%edx
  10176f:	89 c1                	mov    %eax,%ecx
  101771:	d3 e2                	shl    %cl,%edx
  101773:	89 d0                	mov    %edx,%eax
  101775:	f7 d0                	not    %eax
  101777:	89 c2                	mov    %eax,%edx
  101779:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101780:	21 d0                	and    %edx,%eax
  101782:	0f b7 c0             	movzwl %ax,%eax
  101785:	89 04 24             	mov    %eax,(%esp)
  101788:	e8 7c ff ff ff       	call   101709 <pic_setmask>
}
  10178d:	c9                   	leave  
  10178e:	c3                   	ret    

0010178f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10178f:	55                   	push   %ebp
  101790:	89 e5                	mov    %esp,%ebp
  101792:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101795:	c7 05 ac f0 10 00 01 	movl   $0x1,0x10f0ac
  10179c:	00 00 00 
  10179f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1017a5:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1017a9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ad:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
  1017b2:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017b8:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017bc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017c0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
  1017c5:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017cb:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1017cf:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017d3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017de:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017e2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017e6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017f1:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017f5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017f9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
  1017fe:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101804:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101808:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10180c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101810:	ee                   	out    %al,(%dx)
  101811:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101817:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10181b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10181f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
  101824:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10182a:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10182e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101832:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
  101837:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10183d:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101841:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101845:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101849:	ee                   	out    %al,(%dx)
  10184a:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101850:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101854:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101858:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10185c:	ee                   	out    %al,(%dx)
  10185d:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101863:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101867:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10186b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10186f:	ee                   	out    %al,(%dx)
  101870:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101876:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10187a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10187e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101882:	ee                   	out    %al,(%dx)
  101883:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101889:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10188d:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101891:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101895:	ee                   	out    %al,(%dx)
  101896:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10189c:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1018a0:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1018a4:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1018a8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018a9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1018b0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018b4:	74 12                	je     1018c8 <pic_init+0x139>
        pic_setmask(irq_mask);
  1018b6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1018bd:	0f b7 c0             	movzwl %ax,%eax
  1018c0:	89 04 24             	mov    %eax,(%esp)
  1018c3:	e8 41 fe ff ff       	call   101709 <pic_setmask>
    }
}
  1018c8:	c9                   	leave  
  1018c9:	c3                   	ret    

001018ca <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1018ca:	55                   	push   %ebp
  1018cb:	89 e5                	mov    %esp,%ebp
  1018cd:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018d0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018d7:	00 
  1018d8:	c7 04 24 a0 3b 10 00 	movl   $0x103ba0,(%esp)
  1018df:	e8 10 eb ff ff       	call   1003f4 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018e4:	c9                   	leave  
  1018e5:	c3                   	ret    

001018e6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018e6:	55                   	push   %ebp
  1018e7:	89 e5                	mov    %esp,%ebp
  1018e9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018f3:	e9 c3 00 00 00       	jmp    1019bb <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	8b 04 85 e4 e5 10 00 	mov    0x10e5e4(,%eax,4),%eax
  101902:	89 c2                	mov    %eax,%edx
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	66 89 14 c5 c0 f0 10 	mov    %dx,0x10f0c0(,%eax,8)
  10190e:	00 
  10190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101912:	66 c7 04 c5 c2 f0 10 	movw   $0x8,0x10f0c2(,%eax,8)
  101919:	00 08 00 
  10191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191f:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  101926:	00 
  101927:	83 e2 e0             	and    $0xffffffe0,%edx
  10192a:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  10193b:	00 
  10193c:	83 e2 1f             	and    $0x1f,%edx
  10193f:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  101950:	00 
  101951:	83 e2 f0             	and    $0xfffffff0,%edx
  101954:	83 ca 0e             	or     $0xe,%edx
  101957:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  101968:	00 
  101969:	83 e2 ef             	and    $0xffffffef,%edx
  10196c:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101976:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  10197d:	00 
  10197e:	83 e2 9f             	and    $0xffffff9f,%edx
  101981:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  101992:	00 
  101993:	83 ca 80             	or     $0xffffff80,%edx
  101996:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  10199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a0:	8b 04 85 e4 e5 10 00 	mov    0x10e5e4(,%eax,4),%eax
  1019a7:	c1 e8 10             	shr    $0x10,%eax
  1019aa:	89 c2                	mov    %eax,%edx
  1019ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019af:	66 89 14 c5 c6 f0 10 	mov    %dx,0x10f0c6(,%eax,8)
  1019b6:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019be:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019c3:	0f 86 2f ff ff ff    	jbe    1018f8 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019c9:	a1 c8 e7 10 00       	mov    0x10e7c8,%eax
  1019ce:	66 a3 88 f4 10 00    	mov    %ax,0x10f488
  1019d4:	66 c7 05 8a f4 10 00 	movw   $0x8,0x10f48a
  1019db:	08 00 
  1019dd:	0f b6 05 8c f4 10 00 	movzbl 0x10f48c,%eax
  1019e4:	83 e0 e0             	and    $0xffffffe0,%eax
  1019e7:	a2 8c f4 10 00       	mov    %al,0x10f48c
  1019ec:	0f b6 05 8c f4 10 00 	movzbl 0x10f48c,%eax
  1019f3:	83 e0 1f             	and    $0x1f,%eax
  1019f6:	a2 8c f4 10 00       	mov    %al,0x10f48c
  1019fb:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  101a02:	83 e0 f0             	and    $0xfffffff0,%eax
  101a05:	83 c8 0e             	or     $0xe,%eax
  101a08:	a2 8d f4 10 00       	mov    %al,0x10f48d
  101a0d:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  101a14:	83 e0 ef             	and    $0xffffffef,%eax
  101a17:	a2 8d f4 10 00       	mov    %al,0x10f48d
  101a1c:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  101a23:	83 c8 60             	or     $0x60,%eax
  101a26:	a2 8d f4 10 00       	mov    %al,0x10f48d
  101a2b:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  101a32:	83 c8 80             	or     $0xffffff80,%eax
  101a35:	a2 8d f4 10 00       	mov    %al,0x10f48d
  101a3a:	a1 c8 e7 10 00       	mov    0x10e7c8,%eax
  101a3f:	c1 e8 10             	shr    $0x10,%eax
  101a42:	66 a3 8e f4 10 00    	mov    %ax,0x10f48e
  101a48:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a52:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a55:	c9                   	leave  
  101a56:	c3                   	ret    

00101a57 <trapname>:

static const char *
trapname(int trapno) {
  101a57:	55                   	push   %ebp
  101a58:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5d:	83 f8 13             	cmp    $0x13,%eax
  101a60:	77 0c                	ja     101a6e <trapname+0x17>
        return excnames[trapno];
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	8b 04 85 40 3f 10 00 	mov    0x103f40(,%eax,4),%eax
  101a6c:	eb 18                	jmp    101a86 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a6e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a72:	7e 0d                	jle    101a81 <trapname+0x2a>
  101a74:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a78:	7f 07                	jg     101a81 <trapname+0x2a>
        return "Hardware Interrupt";
  101a7a:	b8 aa 3b 10 00       	mov    $0x103baa,%eax
  101a7f:	eb 05                	jmp    101a86 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a81:	b8 bd 3b 10 00       	mov    $0x103bbd,%eax
}
  101a86:	5d                   	pop    %ebp
  101a87:	c3                   	ret    

00101a88 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a88:	55                   	push   %ebp
  101a89:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a92:	66 83 f8 08          	cmp    $0x8,%ax
  101a96:	0f 94 c0             	sete   %al
  101a99:	0f b6 c0             	movzbl %al,%eax
}
  101a9c:	5d                   	pop    %ebp
  101a9d:	c3                   	ret    

00101a9e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a9e:	55                   	push   %ebp
  101a9f:	89 e5                	mov    %esp,%ebp
  101aa1:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	c7 04 24 fe 3b 10 00 	movl   $0x103bfe,(%esp)
  101ab2:	e8 3d e9 ff ff       	call   1003f4 <cprintf>
    print_regs(&tf->tf_regs);
  101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aba:	89 04 24             	mov    %eax,(%esp)
  101abd:	e8 a1 01 00 00       	call   101c63 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac9:	0f b7 c0             	movzwl %ax,%eax
  101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad0:	c7 04 24 0f 3c 10 00 	movl   $0x103c0f,(%esp)
  101ad7:	e8 18 e9 ff ff       	call   1003f4 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101adc:	8b 45 08             	mov    0x8(%ebp),%eax
  101adf:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ae3:	0f b7 c0             	movzwl %ax,%eax
  101ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aea:	c7 04 24 22 3c 10 00 	movl   $0x103c22,(%esp)
  101af1:	e8 fe e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101af6:	8b 45 08             	mov    0x8(%ebp),%eax
  101af9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101afd:	0f b7 c0             	movzwl %ax,%eax
  101b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b04:	c7 04 24 35 3c 10 00 	movl   $0x103c35,(%esp)
  101b0b:	e8 e4 e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b17:	0f b7 c0             	movzwl %ax,%eax
  101b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1e:	c7 04 24 48 3c 10 00 	movl   $0x103c48,(%esp)
  101b25:	e8 ca e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2d:	8b 40 30             	mov    0x30(%eax),%eax
  101b30:	89 04 24             	mov    %eax,(%esp)
  101b33:	e8 1f ff ff ff       	call   101a57 <trapname>
  101b38:	8b 55 08             	mov    0x8(%ebp),%edx
  101b3b:	8b 52 30             	mov    0x30(%edx),%edx
  101b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b42:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b46:	c7 04 24 5b 3c 10 00 	movl   $0x103c5b,(%esp)
  101b4d:	e8 a2 e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	8b 40 34             	mov    0x34(%eax),%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 6d 3c 10 00 	movl   $0x103c6d,(%esp)
  101b63:	e8 8c e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	8b 40 38             	mov    0x38(%eax),%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  101b79:	e8 76 e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b85:	0f b7 c0             	movzwl %ax,%eax
  101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8c:	c7 04 24 8b 3c 10 00 	movl   $0x103c8b,(%esp)
  101b93:	e8 5c e8 ff ff       	call   1003f4 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 40 40             	mov    0x40(%eax),%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 9e 3c 10 00 	movl   $0x103c9e,(%esp)
  101ba9:	e8 46 e8 ff ff       	call   1003f4 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bb5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bbc:	eb 3e                	jmp    101bfc <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	8b 50 40             	mov    0x40(%eax),%edx
  101bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bc7:	21 d0                	and    %edx,%eax
  101bc9:	85 c0                	test   %eax,%eax
  101bcb:	74 28                	je     101bf5 <print_trapframe+0x157>
  101bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd0:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bd7:	85 c0                	test   %eax,%eax
  101bd9:	74 1a                	je     101bf5 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bde:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be9:	c7 04 24 ad 3c 10 00 	movl   $0x103cad,(%esp)
  101bf0:	e8 ff e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bf5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bf9:	d1 65 f0             	shll   -0x10(%ebp)
  101bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bff:	83 f8 17             	cmp    $0x17,%eax
  101c02:	76 ba                	jbe    101bbe <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	8b 40 40             	mov    0x40(%eax),%eax
  101c0a:	25 00 30 00 00       	and    $0x3000,%eax
  101c0f:	c1 e8 0c             	shr    $0xc,%eax
  101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c16:	c7 04 24 b1 3c 10 00 	movl   $0x103cb1,(%esp)
  101c1d:	e8 d2 e7 ff ff       	call   1003f4 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	89 04 24             	mov    %eax,(%esp)
  101c28:	e8 5b fe ff ff       	call   101a88 <trap_in_kernel>
  101c2d:	85 c0                	test   %eax,%eax
  101c2f:	75 30                	jne    101c61 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 44             	mov    0x44(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101c42:	e8 ad e7 ff ff       	call   1003f4 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c4e:	0f b7 c0             	movzwl %ax,%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101c5c:	e8 93 e7 ff ff       	call   1003f4 <cprintf>
    }
}
  101c61:	c9                   	leave  
  101c62:	c3                   	ret    

00101c63 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c63:	55                   	push   %ebp
  101c64:	89 e5                	mov    %esp,%ebp
  101c66:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	8b 00                	mov    (%eax),%eax
  101c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c72:	c7 04 24 dc 3c 10 00 	movl   $0x103cdc,(%esp)
  101c79:	e8 76 e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c81:	8b 40 04             	mov    0x4(%eax),%eax
  101c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c88:	c7 04 24 eb 3c 10 00 	movl   $0x103ceb,(%esp)
  101c8f:	e8 60 e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	8b 40 08             	mov    0x8(%eax),%eax
  101c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9e:	c7 04 24 fa 3c 10 00 	movl   $0x103cfa,(%esp)
  101ca5:	e8 4a e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101caa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cad:	8b 40 0c             	mov    0xc(%eax),%eax
  101cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb4:	c7 04 24 09 3d 10 00 	movl   $0x103d09,(%esp)
  101cbb:	e8 34 e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc3:	8b 40 10             	mov    0x10(%eax),%eax
  101cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cca:	c7 04 24 18 3d 10 00 	movl   $0x103d18,(%esp)
  101cd1:	e8 1e e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd9:	8b 40 14             	mov    0x14(%eax),%eax
  101cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce0:	c7 04 24 27 3d 10 00 	movl   $0x103d27,(%esp)
  101ce7:	e8 08 e7 ff ff       	call   1003f4 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cec:	8b 45 08             	mov    0x8(%ebp),%eax
  101cef:	8b 40 18             	mov    0x18(%eax),%eax
  101cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf6:	c7 04 24 36 3d 10 00 	movl   $0x103d36,(%esp)
  101cfd:	e8 f2 e6 ff ff       	call   1003f4 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d02:	8b 45 08             	mov    0x8(%ebp),%eax
  101d05:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0c:	c7 04 24 45 3d 10 00 	movl   $0x103d45,(%esp)
  101d13:	e8 dc e6 ff ff       	call   1003f4 <cprintf>
}
  101d18:	c9                   	leave  
  101d19:	c3                   	ret    

00101d1a <print_tmode_info>:
#define T_MODE_TICK		1
#define T_MODE_KEY		2
static int tmode = T_MODE_TICK;

static void print_tmode_info()
{
  101d1a:	55                   	push   %ebp
  101d1b:	89 e5                	mov    %esp,%ebp
  101d1d:	83 ec 18             	sub    $0x18,%esp
	cprintf("Change mode:\n");
  101d20:	c7 04 24 54 3d 10 00 	movl   $0x103d54,(%esp)
  101d27:	e8 c8 e6 ff ff       	call   1003f4 <cprintf>
	cprintf("1:tick\n");
  101d2c:	c7 04 24 62 3d 10 00 	movl   $0x103d62,(%esp)
  101d33:	e8 bc e6 ff ff       	call   1003f4 <cprintf>
	cprintf("2:keypress\n");
  101d38:	c7 04 24 6a 3d 10 00 	movl   $0x103d6a,(%esp)
  101d3f:	e8 b0 e6 ff ff       	call   1003f4 <cprintf>
}
  101d44:	c9                   	leave  
  101d45:	c3                   	ret    

00101d46 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d46:	55                   	push   %ebp
  101d47:	89 e5                	mov    %esp,%ebp
  101d49:	57                   	push   %edi
  101d4a:	56                   	push   %esi
  101d4b:	53                   	push   %ebx
  101d4c:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d52:	8b 40 30             	mov    0x30(%eax),%eax
  101d55:	83 f8 2f             	cmp    $0x2f,%eax
  101d58:	77 21                	ja     101d7b <trap_dispatch+0x35>
  101d5a:	83 f8 2e             	cmp    $0x2e,%eax
  101d5d:	0f 83 de 02 00 00    	jae    102041 <trap_dispatch+0x2fb>
  101d63:	83 f8 21             	cmp    $0x21,%eax
  101d66:	0f 84 a4 00 00 00    	je     101e10 <trap_dispatch+0xca>
  101d6c:	83 f8 24             	cmp    $0x24,%eax
  101d6f:	74 76                	je     101de7 <trap_dispatch+0xa1>
  101d71:	83 f8 20             	cmp    $0x20,%eax
  101d74:	74 1c                	je     101d92 <trap_dispatch+0x4c>
  101d76:	e9 8e 02 00 00       	jmp    102009 <trap_dispatch+0x2c3>
  101d7b:	83 f8 78             	cmp    $0x78,%eax
  101d7e:	0f 84 4a 01 00 00    	je     101ece <trap_dispatch+0x188>
  101d84:	83 f8 79             	cmp    $0x79,%eax
  101d87:	0f 84 d7 01 00 00    	je     101f64 <trap_dispatch+0x21e>
  101d8d:	e9 77 02 00 00       	jmp    102009 <trap_dispatch+0x2c3>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
  101d92:	a1 28 f9 10 00       	mov    0x10f928,%eax
  101d97:	83 c0 01             	add    $0x1,%eax
  101d9a:	a3 28 f9 10 00       	mov    %eax,0x10f928
		if (tmode == T_MODE_TICK)
  101d9f:	a1 e0 e5 10 00       	mov    0x10e5e0,%eax
  101da4:	83 f8 01             	cmp    $0x1,%eax
  101da7:	75 39                	jne    101de2 <trap_dispatch+0x9c>
		{
			if (ticks % TICK_NUM == 0)
  101da9:	8b 0d 28 f9 10 00    	mov    0x10f928,%ecx
  101daf:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101db4:	89 c8                	mov    %ecx,%eax
  101db6:	f7 e2                	mul    %edx
  101db8:	89 d0                	mov    %edx,%eax
  101dba:	c1 e8 05             	shr    $0x5,%eax
  101dbd:	6b c0 64             	imul   $0x64,%eax,%eax
  101dc0:	29 c1                	sub    %eax,%ecx
  101dc2:	89 c8                	mov    %ecx,%eax
  101dc4:	85 c0                	test   %eax,%eax
  101dc6:	75 1a                	jne    101de2 <trap_dispatch+0x9c>
				cprintf("%d ticks\n", ticks);
  101dc8:	a1 28 f9 10 00       	mov    0x10f928,%eax
  101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd1:	c7 04 24 a0 3b 10 00 	movl   $0x103ba0,(%esp)
  101dd8:	e8 17 e6 ff ff       	call   1003f4 <cprintf>
		}
        break;
  101ddd:	e9 60 02 00 00       	jmp    102042 <trap_dispatch+0x2fc>
  101de2:	e9 5b 02 00 00       	jmp    102042 <trap_dispatch+0x2fc>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101de7:	e8 b5 f8 ff ff       	call   1016a1 <cons_getc>
  101dec:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101def:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101df3:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101df7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dff:	c7 04 24 76 3d 10 00 	movl   $0x103d76,(%esp)
  101e06:	e8 e9 e5 ff ff       	call   1003f4 <cprintf>
        break;
  101e0b:	e9 32 02 00 00       	jmp    102042 <trap_dispatch+0x2fc>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e10:	e8 8c f8 ff ff       	call   1016a1 <cons_getc>
  101e15:	88 45 e7             	mov    %al,-0x19(%ebp)
		if (c == 0)
  101e18:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
  101e1c:	75 05                	jne    101e23 <trap_dispatch+0xdd>
			break;
  101e1e:	e9 1f 02 00 00       	jmp    102042 <trap_dispatch+0x2fc>

		if (c == 19 && tmode != T_MODE_SEL)
  101e23:	80 7d e7 13          	cmpb   $0x13,-0x19(%ebp)
  101e27:	75 1d                	jne    101e46 <trap_dispatch+0x100>
  101e29:	a1 e0 e5 10 00       	mov    0x10e5e0,%eax
  101e2e:	85 c0                	test   %eax,%eax
  101e30:	74 14                	je     101e46 <trap_dispatch+0x100>
		{
			tmode = T_MODE_SEL;
  101e32:	c7 05 e0 e5 10 00 00 	movl   $0x0,0x10e5e0
  101e39:	00 00 00 
			print_tmode_info();
  101e3c:	e8 d9 fe ff ff       	call   101d1a <print_tmode_info>
			break;
  101e41:	e9 fc 01 00 00       	jmp    102042 <trap_dispatch+0x2fc>
		}

		if (tmode == T_MODE_KEY)
  101e46:	a1 e0 e5 10 00       	mov    0x10e5e0,%eax
  101e4b:	83 f8 02             	cmp    $0x2,%eax
  101e4e:	75 16                	jne    101e66 <trap_dispatch+0x120>
		{
        	cprintf("%c", c);
  101e50:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e58:	c7 04 24 88 3d 10 00 	movl   $0x103d88,(%esp)
  101e5f:	e8 90 e5 ff ff       	call   1003f4 <cprintf>
  101e64:	eb 63                	jmp    101ec9 <trap_dispatch+0x183>
		}
		else if (tmode == T_MODE_SEL)
  101e66:	a1 e0 e5 10 00       	mov    0x10e5e0,%eax
  101e6b:	85 c0                	test   %eax,%eax
  101e6d:	75 5a                	jne    101ec9 <trap_dispatch+0x183>
		{
			switch (c)
  101e6f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e73:	83 f8 31             	cmp    $0x31,%eax
  101e76:	74 07                	je     101e7f <trap_dispatch+0x139>
  101e78:	83 f8 32             	cmp    $0x32,%eax
  101e7b:	74 1a                	je     101e97 <trap_dispatch+0x151>
  101e7d:	eb 30                	jmp    101eaf <trap_dispatch+0x169>
			{
				case '1': tmode = T_MODE_TICK; cprintf("\n"); break;
  101e7f:	c7 05 e0 e5 10 00 01 	movl   $0x1,0x10e5e0
  101e86:	00 00 00 
  101e89:	c7 04 24 8b 3d 10 00 	movl   $0x103d8b,(%esp)
  101e90:	e8 5f e5 ff ff       	call   1003f4 <cprintf>
  101e95:	eb 32                	jmp    101ec9 <trap_dispatch+0x183>
				case '2': tmode = T_MODE_KEY; cprintf("\n"); break;
  101e97:	c7 05 e0 e5 10 00 02 	movl   $0x2,0x10e5e0
  101e9e:	00 00 00 
  101ea1:	c7 04 24 8b 3d 10 00 	movl   $0x103d8b,(%esp)
  101ea8:	e8 47 e5 ff ff       	call   1003f4 <cprintf>
  101ead:	eb 1a                	jmp    101ec9 <trap_dispatch+0x183>
				default:
					cprintf("%c is not valid.", c);
  101eaf:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eb7:	c7 04 24 8d 3d 10 00 	movl   $0x103d8d,(%esp)
  101ebe:	e8 31 e5 ff ff       	call   1003f4 <cprintf>
					print_tmode_info();
  101ec3:	e8 52 fe ff ff       	call   101d1a <print_tmode_info>
					break;
  101ec8:	90                   	nop
			}
		}
        break;
  101ec9:	e9 74 01 00 00       	jmp    102042 <trap_dispatch+0x2fc>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101ece:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed5:	66 83 f8 1b          	cmp    $0x1b,%ax
  101ed9:	0f 84 80 00 00 00    	je     101f5f <trap_dispatch+0x219>
			cprintf("k2u tf:%x\n", tf);
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ee6:	c7 04 24 9e 3d 10 00 	movl   $0x103d9e,(%esp)
  101eed:	e8 02 e5 ff ff       	call   1003f4 <cprintf>
            switchk2u = *tf;
  101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef5:	ba 40 f9 10 00       	mov    $0x10f940,%edx
  101efa:	89 c3                	mov    %eax,%ebx
  101efc:	b8 13 00 00 00       	mov    $0x13,%eax
  101f01:	89 d7                	mov    %edx,%edi
  101f03:	89 de                	mov    %ebx,%esi
  101f05:	89 c1                	mov    %eax,%ecx
  101f07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101f09:	66 c7 05 7c f9 10 00 	movw   $0x1b,0x10f97c
  101f10:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f12:	66 c7 05 88 f9 10 00 	movw   $0x23,0x10f988
  101f19:	23 00 
  101f1b:	0f b7 05 88 f9 10 00 	movzwl 0x10f988,%eax
  101f22:	66 a3 68 f9 10 00    	mov    %ax,0x10f968
  101f28:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101f2f:	66 a3 6c f9 10 00    	mov    %ax,0x10f96c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f35:	8b 45 08             	mov    0x8(%ebp),%eax
  101f38:	83 c0 44             	add    $0x44,%eax
  101f3b:	a3 84 f9 10 00       	mov    %eax,0x10f984
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f40:	a1 80 f9 10 00       	mov    0x10f980,%eax
  101f45:	80 cc 30             	or     $0x30,%ah
  101f48:	a3 80 f9 10 00       	mov    %eax,0x10f980
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f50:	8d 50 fc             	lea    -0x4(%eax),%edx
  101f53:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  101f58:	89 02                	mov    %eax,(%edx)
        }
        break;
  101f5a:	e9 e3 00 00 00       	jmp    102042 <trap_dispatch+0x2fc>
  101f5f:	e9 de 00 00 00       	jmp    102042 <trap_dispatch+0x2fc>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f64:	8b 45 08             	mov    0x8(%ebp),%eax
  101f67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f6b:	66 83 f8 08          	cmp    $0x8,%ax
  101f6f:	0f 84 92 00 00 00    	je     102007 <trap_dispatch+0x2c1>
			cprintf("u2k tf:%x\n", tf);
  101f75:	8b 45 08             	mov    0x8(%ebp),%eax
  101f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f7c:	c7 04 24 a9 3d 10 00 	movl   $0x103da9,(%esp)
  101f83:	e8 6c e4 ff ff       	call   1003f4 <cprintf>
            tf->tf_cs = KERNEL_CS;
  101f88:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f91:	8b 45 08             	mov    0x8(%ebp),%eax
  101f94:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fab:	8b 40 40             	mov    0x40(%eax),%eax
  101fae:	80 e4 cf             	and    $0xcf,%ah
  101fb1:	89 c2                	mov    %eax,%edx
  101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb6:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbc:	8b 40 44             	mov    0x44(%eax),%eax
  101fbf:	83 e8 44             	sub    $0x44,%eax
  101fc2:	a3 8c f9 10 00       	mov    %eax,0x10f98c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101fc7:	a1 8c f9 10 00       	mov    0x10f98c,%eax
  101fcc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fd3:	00 
  101fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  101fd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fdb:	89 04 24             	mov    %eax,(%esp)
  101fde:	e8 6c 16 00 00       	call   10364f <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe6:	8d 50 fc             	lea    -0x4(%eax),%edx
  101fe9:	a1 8c f9 10 00       	mov    0x10f98c,%eax
  101fee:	89 02                	mov    %eax,(%edx)
			cprintf("u2k switchu2k:%x\n", switchu2k);
  101ff0:	a1 8c f9 10 00       	mov    0x10f98c,%eax
  101ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ff9:	c7 04 24 b4 3d 10 00 	movl   $0x103db4,(%esp)
  102000:	e8 ef e3 ff ff       	call   1003f4 <cprintf>
        }
        break;
  102005:	eb 3b                	jmp    102042 <trap_dispatch+0x2fc>
  102007:	eb 39                	jmp    102042 <trap_dispatch+0x2fc>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102009:	8b 45 08             	mov    0x8(%ebp),%eax
  10200c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102010:	0f b7 c0             	movzwl %ax,%eax
  102013:	83 e0 03             	and    $0x3,%eax
  102016:	85 c0                	test   %eax,%eax
  102018:	75 28                	jne    102042 <trap_dispatch+0x2fc>
            print_trapframe(tf);
  10201a:	8b 45 08             	mov    0x8(%ebp),%eax
  10201d:	89 04 24             	mov    %eax,(%esp)
  102020:	e8 79 fa ff ff       	call   101a9e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102025:	c7 44 24 08 c6 3d 10 	movl   $0x103dc6,0x8(%esp)
  10202c:	00 
  10202d:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  102034:	00 
  102035:	c7 04 24 e2 3d 10 00 	movl   $0x103de2,(%esp)
  10203c:	e8 42 ed ff ff       	call   100d83 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  102041:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  102042:	83 c4 2c             	add    $0x2c,%esp
  102045:	5b                   	pop    %ebx
  102046:	5e                   	pop    %esi
  102047:	5f                   	pop    %edi
  102048:	5d                   	pop    %ebp
  102049:	c3                   	ret    

0010204a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10204a:	55                   	push   %ebp
  10204b:	89 e5                	mov    %esp,%ebp
  10204d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102050:	8b 45 08             	mov    0x8(%ebp),%eax
  102053:	89 04 24             	mov    %eax,(%esp)
  102056:	e8 eb fc ff ff       	call   101d46 <trap_dispatch>
}
  10205b:	c9                   	leave  
  10205c:	c3                   	ret    

0010205d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10205d:	1e                   	push   %ds
    pushl %es
  10205e:	06                   	push   %es
    pushl %fs
  10205f:	0f a0                	push   %fs
    pushl %gs
  102061:	0f a8                	push   %gs
    pushal
  102063:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102064:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102069:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10206b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10206d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10206e:	e8 d7 ff ff ff       	call   10204a <trap>

    # pop the pushed stack pointer
    popl %esp
  102073:	5c                   	pop    %esp

00102074 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102074:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102075:	0f a9                	pop    %gs
    popl %fs
  102077:	0f a1                	pop    %fs
    popl %es
  102079:	07                   	pop    %es
    popl %ds
  10207a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10207b:	83 c4 08             	add    $0x8,%esp
    iret
  10207e:	cf                   	iret   

0010207f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $0
  102081:	6a 00                	push   $0x0
  jmp __alltraps
  102083:	e9 d5 ff ff ff       	jmp    10205d <__alltraps>

00102088 <vector1>:
.globl vector1
vector1:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $1
  10208a:	6a 01                	push   $0x1
  jmp __alltraps
  10208c:	e9 cc ff ff ff       	jmp    10205d <__alltraps>

00102091 <vector2>:
.globl vector2
vector2:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $2
  102093:	6a 02                	push   $0x2
  jmp __alltraps
  102095:	e9 c3 ff ff ff       	jmp    10205d <__alltraps>

0010209a <vector3>:
.globl vector3
vector3:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $3
  10209c:	6a 03                	push   $0x3
  jmp __alltraps
  10209e:	e9 ba ff ff ff       	jmp    10205d <__alltraps>

001020a3 <vector4>:
.globl vector4
vector4:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $4
  1020a5:	6a 04                	push   $0x4
  jmp __alltraps
  1020a7:	e9 b1 ff ff ff       	jmp    10205d <__alltraps>

001020ac <vector5>:
.globl vector5
vector5:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $5
  1020ae:	6a 05                	push   $0x5
  jmp __alltraps
  1020b0:	e9 a8 ff ff ff       	jmp    10205d <__alltraps>

001020b5 <vector6>:
.globl vector6
vector6:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $6
  1020b7:	6a 06                	push   $0x6
  jmp __alltraps
  1020b9:	e9 9f ff ff ff       	jmp    10205d <__alltraps>

001020be <vector7>:
.globl vector7
vector7:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $7
  1020c0:	6a 07                	push   $0x7
  jmp __alltraps
  1020c2:	e9 96 ff ff ff       	jmp    10205d <__alltraps>

001020c7 <vector8>:
.globl vector8
vector8:
  pushl $8
  1020c7:	6a 08                	push   $0x8
  jmp __alltraps
  1020c9:	e9 8f ff ff ff       	jmp    10205d <__alltraps>

001020ce <vector9>:
.globl vector9
vector9:
  pushl $9
  1020ce:	6a 09                	push   $0x9
  jmp __alltraps
  1020d0:	e9 88 ff ff ff       	jmp    10205d <__alltraps>

001020d5 <vector10>:
.globl vector10
vector10:
  pushl $10
  1020d5:	6a 0a                	push   $0xa
  jmp __alltraps
  1020d7:	e9 81 ff ff ff       	jmp    10205d <__alltraps>

001020dc <vector11>:
.globl vector11
vector11:
  pushl $11
  1020dc:	6a 0b                	push   $0xb
  jmp __alltraps
  1020de:	e9 7a ff ff ff       	jmp    10205d <__alltraps>

001020e3 <vector12>:
.globl vector12
vector12:
  pushl $12
  1020e3:	6a 0c                	push   $0xc
  jmp __alltraps
  1020e5:	e9 73 ff ff ff       	jmp    10205d <__alltraps>

001020ea <vector13>:
.globl vector13
vector13:
  pushl $13
  1020ea:	6a 0d                	push   $0xd
  jmp __alltraps
  1020ec:	e9 6c ff ff ff       	jmp    10205d <__alltraps>

001020f1 <vector14>:
.globl vector14
vector14:
  pushl $14
  1020f1:	6a 0e                	push   $0xe
  jmp __alltraps
  1020f3:	e9 65 ff ff ff       	jmp    10205d <__alltraps>

001020f8 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $15
  1020fa:	6a 0f                	push   $0xf
  jmp __alltraps
  1020fc:	e9 5c ff ff ff       	jmp    10205d <__alltraps>

00102101 <vector16>:
.globl vector16
vector16:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $16
  102103:	6a 10                	push   $0x10
  jmp __alltraps
  102105:	e9 53 ff ff ff       	jmp    10205d <__alltraps>

0010210a <vector17>:
.globl vector17
vector17:
  pushl $17
  10210a:	6a 11                	push   $0x11
  jmp __alltraps
  10210c:	e9 4c ff ff ff       	jmp    10205d <__alltraps>

00102111 <vector18>:
.globl vector18
vector18:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $18
  102113:	6a 12                	push   $0x12
  jmp __alltraps
  102115:	e9 43 ff ff ff       	jmp    10205d <__alltraps>

0010211a <vector19>:
.globl vector19
vector19:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $19
  10211c:	6a 13                	push   $0x13
  jmp __alltraps
  10211e:	e9 3a ff ff ff       	jmp    10205d <__alltraps>

00102123 <vector20>:
.globl vector20
vector20:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $20
  102125:	6a 14                	push   $0x14
  jmp __alltraps
  102127:	e9 31 ff ff ff       	jmp    10205d <__alltraps>

0010212c <vector21>:
.globl vector21
vector21:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $21
  10212e:	6a 15                	push   $0x15
  jmp __alltraps
  102130:	e9 28 ff ff ff       	jmp    10205d <__alltraps>

00102135 <vector22>:
.globl vector22
vector22:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $22
  102137:	6a 16                	push   $0x16
  jmp __alltraps
  102139:	e9 1f ff ff ff       	jmp    10205d <__alltraps>

0010213e <vector23>:
.globl vector23
vector23:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $23
  102140:	6a 17                	push   $0x17
  jmp __alltraps
  102142:	e9 16 ff ff ff       	jmp    10205d <__alltraps>

00102147 <vector24>:
.globl vector24
vector24:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $24
  102149:	6a 18                	push   $0x18
  jmp __alltraps
  10214b:	e9 0d ff ff ff       	jmp    10205d <__alltraps>

00102150 <vector25>:
.globl vector25
vector25:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $25
  102152:	6a 19                	push   $0x19
  jmp __alltraps
  102154:	e9 04 ff ff ff       	jmp    10205d <__alltraps>

00102159 <vector26>:
.globl vector26
vector26:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $26
  10215b:	6a 1a                	push   $0x1a
  jmp __alltraps
  10215d:	e9 fb fe ff ff       	jmp    10205d <__alltraps>

00102162 <vector27>:
.globl vector27
vector27:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $27
  102164:	6a 1b                	push   $0x1b
  jmp __alltraps
  102166:	e9 f2 fe ff ff       	jmp    10205d <__alltraps>

0010216b <vector28>:
.globl vector28
vector28:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $28
  10216d:	6a 1c                	push   $0x1c
  jmp __alltraps
  10216f:	e9 e9 fe ff ff       	jmp    10205d <__alltraps>

00102174 <vector29>:
.globl vector29
vector29:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $29
  102176:	6a 1d                	push   $0x1d
  jmp __alltraps
  102178:	e9 e0 fe ff ff       	jmp    10205d <__alltraps>

0010217d <vector30>:
.globl vector30
vector30:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $30
  10217f:	6a 1e                	push   $0x1e
  jmp __alltraps
  102181:	e9 d7 fe ff ff       	jmp    10205d <__alltraps>

00102186 <vector31>:
.globl vector31
vector31:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $31
  102188:	6a 1f                	push   $0x1f
  jmp __alltraps
  10218a:	e9 ce fe ff ff       	jmp    10205d <__alltraps>

0010218f <vector32>:
.globl vector32
vector32:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $32
  102191:	6a 20                	push   $0x20
  jmp __alltraps
  102193:	e9 c5 fe ff ff       	jmp    10205d <__alltraps>

00102198 <vector33>:
.globl vector33
vector33:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $33
  10219a:	6a 21                	push   $0x21
  jmp __alltraps
  10219c:	e9 bc fe ff ff       	jmp    10205d <__alltraps>

001021a1 <vector34>:
.globl vector34
vector34:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $34
  1021a3:	6a 22                	push   $0x22
  jmp __alltraps
  1021a5:	e9 b3 fe ff ff       	jmp    10205d <__alltraps>

001021aa <vector35>:
.globl vector35
vector35:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $35
  1021ac:	6a 23                	push   $0x23
  jmp __alltraps
  1021ae:	e9 aa fe ff ff       	jmp    10205d <__alltraps>

001021b3 <vector36>:
.globl vector36
vector36:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $36
  1021b5:	6a 24                	push   $0x24
  jmp __alltraps
  1021b7:	e9 a1 fe ff ff       	jmp    10205d <__alltraps>

001021bc <vector37>:
.globl vector37
vector37:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $37
  1021be:	6a 25                	push   $0x25
  jmp __alltraps
  1021c0:	e9 98 fe ff ff       	jmp    10205d <__alltraps>

001021c5 <vector38>:
.globl vector38
vector38:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $38
  1021c7:	6a 26                	push   $0x26
  jmp __alltraps
  1021c9:	e9 8f fe ff ff       	jmp    10205d <__alltraps>

001021ce <vector39>:
.globl vector39
vector39:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $39
  1021d0:	6a 27                	push   $0x27
  jmp __alltraps
  1021d2:	e9 86 fe ff ff       	jmp    10205d <__alltraps>

001021d7 <vector40>:
.globl vector40
vector40:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $40
  1021d9:	6a 28                	push   $0x28
  jmp __alltraps
  1021db:	e9 7d fe ff ff       	jmp    10205d <__alltraps>

001021e0 <vector41>:
.globl vector41
vector41:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $41
  1021e2:	6a 29                	push   $0x29
  jmp __alltraps
  1021e4:	e9 74 fe ff ff       	jmp    10205d <__alltraps>

001021e9 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $42
  1021eb:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021ed:	e9 6b fe ff ff       	jmp    10205d <__alltraps>

001021f2 <vector43>:
.globl vector43
vector43:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $43
  1021f4:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021f6:	e9 62 fe ff ff       	jmp    10205d <__alltraps>

001021fb <vector44>:
.globl vector44
vector44:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $44
  1021fd:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021ff:	e9 59 fe ff ff       	jmp    10205d <__alltraps>

00102204 <vector45>:
.globl vector45
vector45:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $45
  102206:	6a 2d                	push   $0x2d
  jmp __alltraps
  102208:	e9 50 fe ff ff       	jmp    10205d <__alltraps>

0010220d <vector46>:
.globl vector46
vector46:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $46
  10220f:	6a 2e                	push   $0x2e
  jmp __alltraps
  102211:	e9 47 fe ff ff       	jmp    10205d <__alltraps>

00102216 <vector47>:
.globl vector47
vector47:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $47
  102218:	6a 2f                	push   $0x2f
  jmp __alltraps
  10221a:	e9 3e fe ff ff       	jmp    10205d <__alltraps>

0010221f <vector48>:
.globl vector48
vector48:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $48
  102221:	6a 30                	push   $0x30
  jmp __alltraps
  102223:	e9 35 fe ff ff       	jmp    10205d <__alltraps>

00102228 <vector49>:
.globl vector49
vector49:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $49
  10222a:	6a 31                	push   $0x31
  jmp __alltraps
  10222c:	e9 2c fe ff ff       	jmp    10205d <__alltraps>

00102231 <vector50>:
.globl vector50
vector50:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $50
  102233:	6a 32                	push   $0x32
  jmp __alltraps
  102235:	e9 23 fe ff ff       	jmp    10205d <__alltraps>

0010223a <vector51>:
.globl vector51
vector51:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $51
  10223c:	6a 33                	push   $0x33
  jmp __alltraps
  10223e:	e9 1a fe ff ff       	jmp    10205d <__alltraps>

00102243 <vector52>:
.globl vector52
vector52:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $52
  102245:	6a 34                	push   $0x34
  jmp __alltraps
  102247:	e9 11 fe ff ff       	jmp    10205d <__alltraps>

0010224c <vector53>:
.globl vector53
vector53:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $53
  10224e:	6a 35                	push   $0x35
  jmp __alltraps
  102250:	e9 08 fe ff ff       	jmp    10205d <__alltraps>

00102255 <vector54>:
.globl vector54
vector54:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $54
  102257:	6a 36                	push   $0x36
  jmp __alltraps
  102259:	e9 ff fd ff ff       	jmp    10205d <__alltraps>

0010225e <vector55>:
.globl vector55
vector55:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $55
  102260:	6a 37                	push   $0x37
  jmp __alltraps
  102262:	e9 f6 fd ff ff       	jmp    10205d <__alltraps>

00102267 <vector56>:
.globl vector56
vector56:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $56
  102269:	6a 38                	push   $0x38
  jmp __alltraps
  10226b:	e9 ed fd ff ff       	jmp    10205d <__alltraps>

00102270 <vector57>:
.globl vector57
vector57:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $57
  102272:	6a 39                	push   $0x39
  jmp __alltraps
  102274:	e9 e4 fd ff ff       	jmp    10205d <__alltraps>

00102279 <vector58>:
.globl vector58
vector58:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $58
  10227b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10227d:	e9 db fd ff ff       	jmp    10205d <__alltraps>

00102282 <vector59>:
.globl vector59
vector59:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $59
  102284:	6a 3b                	push   $0x3b
  jmp __alltraps
  102286:	e9 d2 fd ff ff       	jmp    10205d <__alltraps>

0010228b <vector60>:
.globl vector60
vector60:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $60
  10228d:	6a 3c                	push   $0x3c
  jmp __alltraps
  10228f:	e9 c9 fd ff ff       	jmp    10205d <__alltraps>

00102294 <vector61>:
.globl vector61
vector61:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $61
  102296:	6a 3d                	push   $0x3d
  jmp __alltraps
  102298:	e9 c0 fd ff ff       	jmp    10205d <__alltraps>

0010229d <vector62>:
.globl vector62
vector62:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $62
  10229f:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022a1:	e9 b7 fd ff ff       	jmp    10205d <__alltraps>

001022a6 <vector63>:
.globl vector63
vector63:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $63
  1022a8:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022aa:	e9 ae fd ff ff       	jmp    10205d <__alltraps>

001022af <vector64>:
.globl vector64
vector64:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $64
  1022b1:	6a 40                	push   $0x40
  jmp __alltraps
  1022b3:	e9 a5 fd ff ff       	jmp    10205d <__alltraps>

001022b8 <vector65>:
.globl vector65
vector65:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $65
  1022ba:	6a 41                	push   $0x41
  jmp __alltraps
  1022bc:	e9 9c fd ff ff       	jmp    10205d <__alltraps>

001022c1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $66
  1022c3:	6a 42                	push   $0x42
  jmp __alltraps
  1022c5:	e9 93 fd ff ff       	jmp    10205d <__alltraps>

001022ca <vector67>:
.globl vector67
vector67:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $67
  1022cc:	6a 43                	push   $0x43
  jmp __alltraps
  1022ce:	e9 8a fd ff ff       	jmp    10205d <__alltraps>

001022d3 <vector68>:
.globl vector68
vector68:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $68
  1022d5:	6a 44                	push   $0x44
  jmp __alltraps
  1022d7:	e9 81 fd ff ff       	jmp    10205d <__alltraps>

001022dc <vector69>:
.globl vector69
vector69:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $69
  1022de:	6a 45                	push   $0x45
  jmp __alltraps
  1022e0:	e9 78 fd ff ff       	jmp    10205d <__alltraps>

001022e5 <vector70>:
.globl vector70
vector70:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $70
  1022e7:	6a 46                	push   $0x46
  jmp __alltraps
  1022e9:	e9 6f fd ff ff       	jmp    10205d <__alltraps>

001022ee <vector71>:
.globl vector71
vector71:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $71
  1022f0:	6a 47                	push   $0x47
  jmp __alltraps
  1022f2:	e9 66 fd ff ff       	jmp    10205d <__alltraps>

001022f7 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $72
  1022f9:	6a 48                	push   $0x48
  jmp __alltraps
  1022fb:	e9 5d fd ff ff       	jmp    10205d <__alltraps>

00102300 <vector73>:
.globl vector73
vector73:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $73
  102302:	6a 49                	push   $0x49
  jmp __alltraps
  102304:	e9 54 fd ff ff       	jmp    10205d <__alltraps>

00102309 <vector74>:
.globl vector74
vector74:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $74
  10230b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10230d:	e9 4b fd ff ff       	jmp    10205d <__alltraps>

00102312 <vector75>:
.globl vector75
vector75:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $75
  102314:	6a 4b                	push   $0x4b
  jmp __alltraps
  102316:	e9 42 fd ff ff       	jmp    10205d <__alltraps>

0010231b <vector76>:
.globl vector76
vector76:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $76
  10231d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10231f:	e9 39 fd ff ff       	jmp    10205d <__alltraps>

00102324 <vector77>:
.globl vector77
vector77:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $77
  102326:	6a 4d                	push   $0x4d
  jmp __alltraps
  102328:	e9 30 fd ff ff       	jmp    10205d <__alltraps>

0010232d <vector78>:
.globl vector78
vector78:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $78
  10232f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102331:	e9 27 fd ff ff       	jmp    10205d <__alltraps>

00102336 <vector79>:
.globl vector79
vector79:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $79
  102338:	6a 4f                	push   $0x4f
  jmp __alltraps
  10233a:	e9 1e fd ff ff       	jmp    10205d <__alltraps>

0010233f <vector80>:
.globl vector80
vector80:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $80
  102341:	6a 50                	push   $0x50
  jmp __alltraps
  102343:	e9 15 fd ff ff       	jmp    10205d <__alltraps>

00102348 <vector81>:
.globl vector81
vector81:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $81
  10234a:	6a 51                	push   $0x51
  jmp __alltraps
  10234c:	e9 0c fd ff ff       	jmp    10205d <__alltraps>

00102351 <vector82>:
.globl vector82
vector82:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $82
  102353:	6a 52                	push   $0x52
  jmp __alltraps
  102355:	e9 03 fd ff ff       	jmp    10205d <__alltraps>

0010235a <vector83>:
.globl vector83
vector83:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $83
  10235c:	6a 53                	push   $0x53
  jmp __alltraps
  10235e:	e9 fa fc ff ff       	jmp    10205d <__alltraps>

00102363 <vector84>:
.globl vector84
vector84:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $84
  102365:	6a 54                	push   $0x54
  jmp __alltraps
  102367:	e9 f1 fc ff ff       	jmp    10205d <__alltraps>

0010236c <vector85>:
.globl vector85
vector85:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $85
  10236e:	6a 55                	push   $0x55
  jmp __alltraps
  102370:	e9 e8 fc ff ff       	jmp    10205d <__alltraps>

00102375 <vector86>:
.globl vector86
vector86:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $86
  102377:	6a 56                	push   $0x56
  jmp __alltraps
  102379:	e9 df fc ff ff       	jmp    10205d <__alltraps>

0010237e <vector87>:
.globl vector87
vector87:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $87
  102380:	6a 57                	push   $0x57
  jmp __alltraps
  102382:	e9 d6 fc ff ff       	jmp    10205d <__alltraps>

00102387 <vector88>:
.globl vector88
vector88:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $88
  102389:	6a 58                	push   $0x58
  jmp __alltraps
  10238b:	e9 cd fc ff ff       	jmp    10205d <__alltraps>

00102390 <vector89>:
.globl vector89
vector89:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $89
  102392:	6a 59                	push   $0x59
  jmp __alltraps
  102394:	e9 c4 fc ff ff       	jmp    10205d <__alltraps>

00102399 <vector90>:
.globl vector90
vector90:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $90
  10239b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10239d:	e9 bb fc ff ff       	jmp    10205d <__alltraps>

001023a2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $91
  1023a4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023a6:	e9 b2 fc ff ff       	jmp    10205d <__alltraps>

001023ab <vector92>:
.globl vector92
vector92:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $92
  1023ad:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023af:	e9 a9 fc ff ff       	jmp    10205d <__alltraps>

001023b4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $93
  1023b6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023b8:	e9 a0 fc ff ff       	jmp    10205d <__alltraps>

001023bd <vector94>:
.globl vector94
vector94:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $94
  1023bf:	6a 5e                	push   $0x5e
  jmp __alltraps
  1023c1:	e9 97 fc ff ff       	jmp    10205d <__alltraps>

001023c6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $95
  1023c8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1023ca:	e9 8e fc ff ff       	jmp    10205d <__alltraps>

001023cf <vector96>:
.globl vector96
vector96:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $96
  1023d1:	6a 60                	push   $0x60
  jmp __alltraps
  1023d3:	e9 85 fc ff ff       	jmp    10205d <__alltraps>

001023d8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $97
  1023da:	6a 61                	push   $0x61
  jmp __alltraps
  1023dc:	e9 7c fc ff ff       	jmp    10205d <__alltraps>

001023e1 <vector98>:
.globl vector98
vector98:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $98
  1023e3:	6a 62                	push   $0x62
  jmp __alltraps
  1023e5:	e9 73 fc ff ff       	jmp    10205d <__alltraps>

001023ea <vector99>:
.globl vector99
vector99:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $99
  1023ec:	6a 63                	push   $0x63
  jmp __alltraps
  1023ee:	e9 6a fc ff ff       	jmp    10205d <__alltraps>

001023f3 <vector100>:
.globl vector100
vector100:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $100
  1023f5:	6a 64                	push   $0x64
  jmp __alltraps
  1023f7:	e9 61 fc ff ff       	jmp    10205d <__alltraps>

001023fc <vector101>:
.globl vector101
vector101:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $101
  1023fe:	6a 65                	push   $0x65
  jmp __alltraps
  102400:	e9 58 fc ff ff       	jmp    10205d <__alltraps>

00102405 <vector102>:
.globl vector102
vector102:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $102
  102407:	6a 66                	push   $0x66
  jmp __alltraps
  102409:	e9 4f fc ff ff       	jmp    10205d <__alltraps>

0010240e <vector103>:
.globl vector103
vector103:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $103
  102410:	6a 67                	push   $0x67
  jmp __alltraps
  102412:	e9 46 fc ff ff       	jmp    10205d <__alltraps>

00102417 <vector104>:
.globl vector104
vector104:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $104
  102419:	6a 68                	push   $0x68
  jmp __alltraps
  10241b:	e9 3d fc ff ff       	jmp    10205d <__alltraps>

00102420 <vector105>:
.globl vector105
vector105:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $105
  102422:	6a 69                	push   $0x69
  jmp __alltraps
  102424:	e9 34 fc ff ff       	jmp    10205d <__alltraps>

00102429 <vector106>:
.globl vector106
vector106:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $106
  10242b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10242d:	e9 2b fc ff ff       	jmp    10205d <__alltraps>

00102432 <vector107>:
.globl vector107
vector107:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $107
  102434:	6a 6b                	push   $0x6b
  jmp __alltraps
  102436:	e9 22 fc ff ff       	jmp    10205d <__alltraps>

0010243b <vector108>:
.globl vector108
vector108:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $108
  10243d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10243f:	e9 19 fc ff ff       	jmp    10205d <__alltraps>

00102444 <vector109>:
.globl vector109
vector109:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $109
  102446:	6a 6d                	push   $0x6d
  jmp __alltraps
  102448:	e9 10 fc ff ff       	jmp    10205d <__alltraps>

0010244d <vector110>:
.globl vector110
vector110:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $110
  10244f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102451:	e9 07 fc ff ff       	jmp    10205d <__alltraps>

00102456 <vector111>:
.globl vector111
vector111:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $111
  102458:	6a 6f                	push   $0x6f
  jmp __alltraps
  10245a:	e9 fe fb ff ff       	jmp    10205d <__alltraps>

0010245f <vector112>:
.globl vector112
vector112:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $112
  102461:	6a 70                	push   $0x70
  jmp __alltraps
  102463:	e9 f5 fb ff ff       	jmp    10205d <__alltraps>

00102468 <vector113>:
.globl vector113
vector113:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $113
  10246a:	6a 71                	push   $0x71
  jmp __alltraps
  10246c:	e9 ec fb ff ff       	jmp    10205d <__alltraps>

00102471 <vector114>:
.globl vector114
vector114:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $114
  102473:	6a 72                	push   $0x72
  jmp __alltraps
  102475:	e9 e3 fb ff ff       	jmp    10205d <__alltraps>

0010247a <vector115>:
.globl vector115
vector115:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $115
  10247c:	6a 73                	push   $0x73
  jmp __alltraps
  10247e:	e9 da fb ff ff       	jmp    10205d <__alltraps>

00102483 <vector116>:
.globl vector116
vector116:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $116
  102485:	6a 74                	push   $0x74
  jmp __alltraps
  102487:	e9 d1 fb ff ff       	jmp    10205d <__alltraps>

0010248c <vector117>:
.globl vector117
vector117:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $117
  10248e:	6a 75                	push   $0x75
  jmp __alltraps
  102490:	e9 c8 fb ff ff       	jmp    10205d <__alltraps>

00102495 <vector118>:
.globl vector118
vector118:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $118
  102497:	6a 76                	push   $0x76
  jmp __alltraps
  102499:	e9 bf fb ff ff       	jmp    10205d <__alltraps>

0010249e <vector119>:
.globl vector119
vector119:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $119
  1024a0:	6a 77                	push   $0x77
  jmp __alltraps
  1024a2:	e9 b6 fb ff ff       	jmp    10205d <__alltraps>

001024a7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $120
  1024a9:	6a 78                	push   $0x78
  jmp __alltraps
  1024ab:	e9 ad fb ff ff       	jmp    10205d <__alltraps>

001024b0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $121
  1024b2:	6a 79                	push   $0x79
  jmp __alltraps
  1024b4:	e9 a4 fb ff ff       	jmp    10205d <__alltraps>

001024b9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $122
  1024bb:	6a 7a                	push   $0x7a
  jmp __alltraps
  1024bd:	e9 9b fb ff ff       	jmp    10205d <__alltraps>

001024c2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $123
  1024c4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1024c6:	e9 92 fb ff ff       	jmp    10205d <__alltraps>

001024cb <vector124>:
.globl vector124
vector124:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $124
  1024cd:	6a 7c                	push   $0x7c
  jmp __alltraps
  1024cf:	e9 89 fb ff ff       	jmp    10205d <__alltraps>

001024d4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $125
  1024d6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1024d8:	e9 80 fb ff ff       	jmp    10205d <__alltraps>

001024dd <vector126>:
.globl vector126
vector126:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $126
  1024df:	6a 7e                	push   $0x7e
  jmp __alltraps
  1024e1:	e9 77 fb ff ff       	jmp    10205d <__alltraps>

001024e6 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $127
  1024e8:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024ea:	e9 6e fb ff ff       	jmp    10205d <__alltraps>

001024ef <vector128>:
.globl vector128
vector128:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $128
  1024f1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024f6:	e9 62 fb ff ff       	jmp    10205d <__alltraps>

001024fb <vector129>:
.globl vector129
vector129:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $129
  1024fd:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102502:	e9 56 fb ff ff       	jmp    10205d <__alltraps>

00102507 <vector130>:
.globl vector130
vector130:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $130
  102509:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10250e:	e9 4a fb ff ff       	jmp    10205d <__alltraps>

00102513 <vector131>:
.globl vector131
vector131:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $131
  102515:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10251a:	e9 3e fb ff ff       	jmp    10205d <__alltraps>

0010251f <vector132>:
.globl vector132
vector132:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $132
  102521:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102526:	e9 32 fb ff ff       	jmp    10205d <__alltraps>

0010252b <vector133>:
.globl vector133
vector133:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $133
  10252d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102532:	e9 26 fb ff ff       	jmp    10205d <__alltraps>

00102537 <vector134>:
.globl vector134
vector134:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $134
  102539:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10253e:	e9 1a fb ff ff       	jmp    10205d <__alltraps>

00102543 <vector135>:
.globl vector135
vector135:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $135
  102545:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10254a:	e9 0e fb ff ff       	jmp    10205d <__alltraps>

0010254f <vector136>:
.globl vector136
vector136:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $136
  102551:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102556:	e9 02 fb ff ff       	jmp    10205d <__alltraps>

0010255b <vector137>:
.globl vector137
vector137:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $137
  10255d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102562:	e9 f6 fa ff ff       	jmp    10205d <__alltraps>

00102567 <vector138>:
.globl vector138
vector138:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $138
  102569:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10256e:	e9 ea fa ff ff       	jmp    10205d <__alltraps>

00102573 <vector139>:
.globl vector139
vector139:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $139
  102575:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10257a:	e9 de fa ff ff       	jmp    10205d <__alltraps>

0010257f <vector140>:
.globl vector140
vector140:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $140
  102581:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102586:	e9 d2 fa ff ff       	jmp    10205d <__alltraps>

0010258b <vector141>:
.globl vector141
vector141:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $141
  10258d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102592:	e9 c6 fa ff ff       	jmp    10205d <__alltraps>

00102597 <vector142>:
.globl vector142
vector142:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $142
  102599:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10259e:	e9 ba fa ff ff       	jmp    10205d <__alltraps>

001025a3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $143
  1025a5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025aa:	e9 ae fa ff ff       	jmp    10205d <__alltraps>

001025af <vector144>:
.globl vector144
vector144:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $144
  1025b1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025b6:	e9 a2 fa ff ff       	jmp    10205d <__alltraps>

001025bb <vector145>:
.globl vector145
vector145:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $145
  1025bd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1025c2:	e9 96 fa ff ff       	jmp    10205d <__alltraps>

001025c7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $146
  1025c9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1025ce:	e9 8a fa ff ff       	jmp    10205d <__alltraps>

001025d3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $147
  1025d5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1025da:	e9 7e fa ff ff       	jmp    10205d <__alltraps>

001025df <vector148>:
.globl vector148
vector148:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $148
  1025e1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025e6:	e9 72 fa ff ff       	jmp    10205d <__alltraps>

001025eb <vector149>:
.globl vector149
vector149:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $149
  1025ed:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025f2:	e9 66 fa ff ff       	jmp    10205d <__alltraps>

001025f7 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $150
  1025f9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025fe:	e9 5a fa ff ff       	jmp    10205d <__alltraps>

00102603 <vector151>:
.globl vector151
vector151:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $151
  102605:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10260a:	e9 4e fa ff ff       	jmp    10205d <__alltraps>

0010260f <vector152>:
.globl vector152
vector152:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $152
  102611:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102616:	e9 42 fa ff ff       	jmp    10205d <__alltraps>

0010261b <vector153>:
.globl vector153
vector153:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $153
  10261d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102622:	e9 36 fa ff ff       	jmp    10205d <__alltraps>

00102627 <vector154>:
.globl vector154
vector154:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $154
  102629:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10262e:	e9 2a fa ff ff       	jmp    10205d <__alltraps>

00102633 <vector155>:
.globl vector155
vector155:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $155
  102635:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10263a:	e9 1e fa ff ff       	jmp    10205d <__alltraps>

0010263f <vector156>:
.globl vector156
vector156:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $156
  102641:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102646:	e9 12 fa ff ff       	jmp    10205d <__alltraps>

0010264b <vector157>:
.globl vector157
vector157:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $157
  10264d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102652:	e9 06 fa ff ff       	jmp    10205d <__alltraps>

00102657 <vector158>:
.globl vector158
vector158:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $158
  102659:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10265e:	e9 fa f9 ff ff       	jmp    10205d <__alltraps>

00102663 <vector159>:
.globl vector159
vector159:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $159
  102665:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10266a:	e9 ee f9 ff ff       	jmp    10205d <__alltraps>

0010266f <vector160>:
.globl vector160
vector160:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $160
  102671:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102676:	e9 e2 f9 ff ff       	jmp    10205d <__alltraps>

0010267b <vector161>:
.globl vector161
vector161:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $161
  10267d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102682:	e9 d6 f9 ff ff       	jmp    10205d <__alltraps>

00102687 <vector162>:
.globl vector162
vector162:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $162
  102689:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10268e:	e9 ca f9 ff ff       	jmp    10205d <__alltraps>

00102693 <vector163>:
.globl vector163
vector163:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $163
  102695:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10269a:	e9 be f9 ff ff       	jmp    10205d <__alltraps>

0010269f <vector164>:
.globl vector164
vector164:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $164
  1026a1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026a6:	e9 b2 f9 ff ff       	jmp    10205d <__alltraps>

001026ab <vector165>:
.globl vector165
vector165:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $165
  1026ad:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026b2:	e9 a6 f9 ff ff       	jmp    10205d <__alltraps>

001026b7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $166
  1026b9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1026be:	e9 9a f9 ff ff       	jmp    10205d <__alltraps>

001026c3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $167
  1026c5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1026ca:	e9 8e f9 ff ff       	jmp    10205d <__alltraps>

001026cf <vector168>:
.globl vector168
vector168:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $168
  1026d1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1026d6:	e9 82 f9 ff ff       	jmp    10205d <__alltraps>

001026db <vector169>:
.globl vector169
vector169:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $169
  1026dd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1026e2:	e9 76 f9 ff ff       	jmp    10205d <__alltraps>

001026e7 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $170
  1026e9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026ee:	e9 6a f9 ff ff       	jmp    10205d <__alltraps>

001026f3 <vector171>:
.globl vector171
vector171:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $171
  1026f5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026fa:	e9 5e f9 ff ff       	jmp    10205d <__alltraps>

001026ff <vector172>:
.globl vector172
vector172:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $172
  102701:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102706:	e9 52 f9 ff ff       	jmp    10205d <__alltraps>

0010270b <vector173>:
.globl vector173
vector173:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $173
  10270d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102712:	e9 46 f9 ff ff       	jmp    10205d <__alltraps>

00102717 <vector174>:
.globl vector174
vector174:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $174
  102719:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10271e:	e9 3a f9 ff ff       	jmp    10205d <__alltraps>

00102723 <vector175>:
.globl vector175
vector175:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $175
  102725:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10272a:	e9 2e f9 ff ff       	jmp    10205d <__alltraps>

0010272f <vector176>:
.globl vector176
vector176:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $176
  102731:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102736:	e9 22 f9 ff ff       	jmp    10205d <__alltraps>

0010273b <vector177>:
.globl vector177
vector177:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $177
  10273d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102742:	e9 16 f9 ff ff       	jmp    10205d <__alltraps>

00102747 <vector178>:
.globl vector178
vector178:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $178
  102749:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10274e:	e9 0a f9 ff ff       	jmp    10205d <__alltraps>

00102753 <vector179>:
.globl vector179
vector179:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $179
  102755:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10275a:	e9 fe f8 ff ff       	jmp    10205d <__alltraps>

0010275f <vector180>:
.globl vector180
vector180:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $180
  102761:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102766:	e9 f2 f8 ff ff       	jmp    10205d <__alltraps>

0010276b <vector181>:
.globl vector181
vector181:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $181
  10276d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102772:	e9 e6 f8 ff ff       	jmp    10205d <__alltraps>

00102777 <vector182>:
.globl vector182
vector182:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $182
  102779:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10277e:	e9 da f8 ff ff       	jmp    10205d <__alltraps>

00102783 <vector183>:
.globl vector183
vector183:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $183
  102785:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10278a:	e9 ce f8 ff ff       	jmp    10205d <__alltraps>

0010278f <vector184>:
.globl vector184
vector184:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $184
  102791:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102796:	e9 c2 f8 ff ff       	jmp    10205d <__alltraps>

0010279b <vector185>:
.globl vector185
vector185:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $185
  10279d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027a2:	e9 b6 f8 ff ff       	jmp    10205d <__alltraps>

001027a7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $186
  1027a9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027ae:	e9 aa f8 ff ff       	jmp    10205d <__alltraps>

001027b3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $187
  1027b5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027ba:	e9 9e f8 ff ff       	jmp    10205d <__alltraps>

001027bf <vector188>:
.globl vector188
vector188:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $188
  1027c1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1027c6:	e9 92 f8 ff ff       	jmp    10205d <__alltraps>

001027cb <vector189>:
.globl vector189
vector189:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $189
  1027cd:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1027d2:	e9 86 f8 ff ff       	jmp    10205d <__alltraps>

001027d7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $190
  1027d9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1027de:	e9 7a f8 ff ff       	jmp    10205d <__alltraps>

001027e3 <vector191>:
.globl vector191
vector191:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $191
  1027e5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027ea:	e9 6e f8 ff ff       	jmp    10205d <__alltraps>

001027ef <vector192>:
.globl vector192
vector192:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $192
  1027f1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027f6:	e9 62 f8 ff ff       	jmp    10205d <__alltraps>

001027fb <vector193>:
.globl vector193
vector193:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $193
  1027fd:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102802:	e9 56 f8 ff ff       	jmp    10205d <__alltraps>

00102807 <vector194>:
.globl vector194
vector194:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $194
  102809:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10280e:	e9 4a f8 ff ff       	jmp    10205d <__alltraps>

00102813 <vector195>:
.globl vector195
vector195:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $195
  102815:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10281a:	e9 3e f8 ff ff       	jmp    10205d <__alltraps>

0010281f <vector196>:
.globl vector196
vector196:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $196
  102821:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102826:	e9 32 f8 ff ff       	jmp    10205d <__alltraps>

0010282b <vector197>:
.globl vector197
vector197:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $197
  10282d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102832:	e9 26 f8 ff ff       	jmp    10205d <__alltraps>

00102837 <vector198>:
.globl vector198
vector198:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $198
  102839:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10283e:	e9 1a f8 ff ff       	jmp    10205d <__alltraps>

00102843 <vector199>:
.globl vector199
vector199:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $199
  102845:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10284a:	e9 0e f8 ff ff       	jmp    10205d <__alltraps>

0010284f <vector200>:
.globl vector200
vector200:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $200
  102851:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102856:	e9 02 f8 ff ff       	jmp    10205d <__alltraps>

0010285b <vector201>:
.globl vector201
vector201:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $201
  10285d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102862:	e9 f6 f7 ff ff       	jmp    10205d <__alltraps>

00102867 <vector202>:
.globl vector202
vector202:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $202
  102869:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10286e:	e9 ea f7 ff ff       	jmp    10205d <__alltraps>

00102873 <vector203>:
.globl vector203
vector203:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $203
  102875:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10287a:	e9 de f7 ff ff       	jmp    10205d <__alltraps>

0010287f <vector204>:
.globl vector204
vector204:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $204
  102881:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102886:	e9 d2 f7 ff ff       	jmp    10205d <__alltraps>

0010288b <vector205>:
.globl vector205
vector205:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $205
  10288d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102892:	e9 c6 f7 ff ff       	jmp    10205d <__alltraps>

00102897 <vector206>:
.globl vector206
vector206:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $206
  102899:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10289e:	e9 ba f7 ff ff       	jmp    10205d <__alltraps>

001028a3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $207
  1028a5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028aa:	e9 ae f7 ff ff       	jmp    10205d <__alltraps>

001028af <vector208>:
.globl vector208
vector208:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $208
  1028b1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028b6:	e9 a2 f7 ff ff       	jmp    10205d <__alltraps>

001028bb <vector209>:
.globl vector209
vector209:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $209
  1028bd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1028c2:	e9 96 f7 ff ff       	jmp    10205d <__alltraps>

001028c7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $210
  1028c9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1028ce:	e9 8a f7 ff ff       	jmp    10205d <__alltraps>

001028d3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $211
  1028d5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1028da:	e9 7e f7 ff ff       	jmp    10205d <__alltraps>

001028df <vector212>:
.globl vector212
vector212:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $212
  1028e1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028e6:	e9 72 f7 ff ff       	jmp    10205d <__alltraps>

001028eb <vector213>:
.globl vector213
vector213:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $213
  1028ed:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028f2:	e9 66 f7 ff ff       	jmp    10205d <__alltraps>

001028f7 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $214
  1028f9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028fe:	e9 5a f7 ff ff       	jmp    10205d <__alltraps>

00102903 <vector215>:
.globl vector215
vector215:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $215
  102905:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10290a:	e9 4e f7 ff ff       	jmp    10205d <__alltraps>

0010290f <vector216>:
.globl vector216
vector216:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $216
  102911:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102916:	e9 42 f7 ff ff       	jmp    10205d <__alltraps>

0010291b <vector217>:
.globl vector217
vector217:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $217
  10291d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102922:	e9 36 f7 ff ff       	jmp    10205d <__alltraps>

00102927 <vector218>:
.globl vector218
vector218:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $218
  102929:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10292e:	e9 2a f7 ff ff       	jmp    10205d <__alltraps>

00102933 <vector219>:
.globl vector219
vector219:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $219
  102935:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10293a:	e9 1e f7 ff ff       	jmp    10205d <__alltraps>

0010293f <vector220>:
.globl vector220
vector220:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $220
  102941:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102946:	e9 12 f7 ff ff       	jmp    10205d <__alltraps>

0010294b <vector221>:
.globl vector221
vector221:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $221
  10294d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102952:	e9 06 f7 ff ff       	jmp    10205d <__alltraps>

00102957 <vector222>:
.globl vector222
vector222:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $222
  102959:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10295e:	e9 fa f6 ff ff       	jmp    10205d <__alltraps>

00102963 <vector223>:
.globl vector223
vector223:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $223
  102965:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10296a:	e9 ee f6 ff ff       	jmp    10205d <__alltraps>

0010296f <vector224>:
.globl vector224
vector224:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $224
  102971:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102976:	e9 e2 f6 ff ff       	jmp    10205d <__alltraps>

0010297b <vector225>:
.globl vector225
vector225:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $225
  10297d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102982:	e9 d6 f6 ff ff       	jmp    10205d <__alltraps>

00102987 <vector226>:
.globl vector226
vector226:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $226
  102989:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10298e:	e9 ca f6 ff ff       	jmp    10205d <__alltraps>

00102993 <vector227>:
.globl vector227
vector227:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $227
  102995:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10299a:	e9 be f6 ff ff       	jmp    10205d <__alltraps>

0010299f <vector228>:
.globl vector228
vector228:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $228
  1029a1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029a6:	e9 b2 f6 ff ff       	jmp    10205d <__alltraps>

001029ab <vector229>:
.globl vector229
vector229:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $229
  1029ad:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029b2:	e9 a6 f6 ff ff       	jmp    10205d <__alltraps>

001029b7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $230
  1029b9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1029be:	e9 9a f6 ff ff       	jmp    10205d <__alltraps>

001029c3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $231
  1029c5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1029ca:	e9 8e f6 ff ff       	jmp    10205d <__alltraps>

001029cf <vector232>:
.globl vector232
vector232:
  pushl $0
  1029cf:	6a 00                	push   $0x0
  pushl $232
  1029d1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1029d6:	e9 82 f6 ff ff       	jmp    10205d <__alltraps>

001029db <vector233>:
.globl vector233
vector233:
  pushl $0
  1029db:	6a 00                	push   $0x0
  pushl $233
  1029dd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1029e2:	e9 76 f6 ff ff       	jmp    10205d <__alltraps>

001029e7 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029e7:	6a 00                	push   $0x0
  pushl $234
  1029e9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029ee:	e9 6a f6 ff ff       	jmp    10205d <__alltraps>

001029f3 <vector235>:
.globl vector235
vector235:
  pushl $0
  1029f3:	6a 00                	push   $0x0
  pushl $235
  1029f5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029fa:	e9 5e f6 ff ff       	jmp    10205d <__alltraps>

001029ff <vector236>:
.globl vector236
vector236:
  pushl $0
  1029ff:	6a 00                	push   $0x0
  pushl $236
  102a01:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a06:	e9 52 f6 ff ff       	jmp    10205d <__alltraps>

00102a0b <vector237>:
.globl vector237
vector237:
  pushl $0
  102a0b:	6a 00                	push   $0x0
  pushl $237
  102a0d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a12:	e9 46 f6 ff ff       	jmp    10205d <__alltraps>

00102a17 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a17:	6a 00                	push   $0x0
  pushl $238
  102a19:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a1e:	e9 3a f6 ff ff       	jmp    10205d <__alltraps>

00102a23 <vector239>:
.globl vector239
vector239:
  pushl $0
  102a23:	6a 00                	push   $0x0
  pushl $239
  102a25:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a2a:	e9 2e f6 ff ff       	jmp    10205d <__alltraps>

00102a2f <vector240>:
.globl vector240
vector240:
  pushl $0
  102a2f:	6a 00                	push   $0x0
  pushl $240
  102a31:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a36:	e9 22 f6 ff ff       	jmp    10205d <__alltraps>

00102a3b <vector241>:
.globl vector241
vector241:
  pushl $0
  102a3b:	6a 00                	push   $0x0
  pushl $241
  102a3d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a42:	e9 16 f6 ff ff       	jmp    10205d <__alltraps>

00102a47 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a47:	6a 00                	push   $0x0
  pushl $242
  102a49:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a4e:	e9 0a f6 ff ff       	jmp    10205d <__alltraps>

00102a53 <vector243>:
.globl vector243
vector243:
  pushl $0
  102a53:	6a 00                	push   $0x0
  pushl $243
  102a55:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a5a:	e9 fe f5 ff ff       	jmp    10205d <__alltraps>

00102a5f <vector244>:
.globl vector244
vector244:
  pushl $0
  102a5f:	6a 00                	push   $0x0
  pushl $244
  102a61:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a66:	e9 f2 f5 ff ff       	jmp    10205d <__alltraps>

00102a6b <vector245>:
.globl vector245
vector245:
  pushl $0
  102a6b:	6a 00                	push   $0x0
  pushl $245
  102a6d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a72:	e9 e6 f5 ff ff       	jmp    10205d <__alltraps>

00102a77 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a77:	6a 00                	push   $0x0
  pushl $246
  102a79:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a7e:	e9 da f5 ff ff       	jmp    10205d <__alltraps>

00102a83 <vector247>:
.globl vector247
vector247:
  pushl $0
  102a83:	6a 00                	push   $0x0
  pushl $247
  102a85:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a8a:	e9 ce f5 ff ff       	jmp    10205d <__alltraps>

00102a8f <vector248>:
.globl vector248
vector248:
  pushl $0
  102a8f:	6a 00                	push   $0x0
  pushl $248
  102a91:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a96:	e9 c2 f5 ff ff       	jmp    10205d <__alltraps>

00102a9b <vector249>:
.globl vector249
vector249:
  pushl $0
  102a9b:	6a 00                	push   $0x0
  pushl $249
  102a9d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102aa2:	e9 b6 f5 ff ff       	jmp    10205d <__alltraps>

00102aa7 <vector250>:
.globl vector250
vector250:
  pushl $0
  102aa7:	6a 00                	push   $0x0
  pushl $250
  102aa9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102aae:	e9 aa f5 ff ff       	jmp    10205d <__alltraps>

00102ab3 <vector251>:
.globl vector251
vector251:
  pushl $0
  102ab3:	6a 00                	push   $0x0
  pushl $251
  102ab5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102aba:	e9 9e f5 ff ff       	jmp    10205d <__alltraps>

00102abf <vector252>:
.globl vector252
vector252:
  pushl $0
  102abf:	6a 00                	push   $0x0
  pushl $252
  102ac1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102ac6:	e9 92 f5 ff ff       	jmp    10205d <__alltraps>

00102acb <vector253>:
.globl vector253
vector253:
  pushl $0
  102acb:	6a 00                	push   $0x0
  pushl $253
  102acd:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102ad2:	e9 86 f5 ff ff       	jmp    10205d <__alltraps>

00102ad7 <vector254>:
.globl vector254
vector254:
  pushl $0
  102ad7:	6a 00                	push   $0x0
  pushl $254
  102ad9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102ade:	e9 7a f5 ff ff       	jmp    10205d <__alltraps>

00102ae3 <vector255>:
.globl vector255
vector255:
  pushl $0
  102ae3:	6a 00                	push   $0x0
  pushl $255
  102ae5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102aea:	e9 6e f5 ff ff       	jmp    10205d <__alltraps>

00102aef <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102aef:	55                   	push   %ebp
  102af0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102af2:	8b 45 08             	mov    0x8(%ebp),%eax
  102af5:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102af8:	b8 23 00 00 00       	mov    $0x23,%eax
  102afd:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102aff:	b8 23 00 00 00       	mov    $0x23,%eax
  102b04:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b06:	b8 10 00 00 00       	mov    $0x10,%eax
  102b0b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b0d:	b8 10 00 00 00       	mov    $0x10,%eax
  102b12:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b14:	b8 10 00 00 00       	mov    $0x10,%eax
  102b19:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b1b:	ea 22 2b 10 00 08 00 	ljmp   $0x8,$0x102b22
}
  102b22:	5d                   	pop    %ebp
  102b23:	c3                   	ret    

00102b24 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b24:	55                   	push   %ebp
  102b25:	89 e5                	mov    %esp,%ebp
  102b27:	83 ec 28             	sub    $0x28,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b2a:	b8 a0 f9 10 00       	mov    $0x10f9a0,%eax
  102b2f:	05 00 04 00 00       	add    $0x400,%eax
  102b34:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  102b39:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  102b40:	10 00 
	cprintf("TSS esp:%x\n", ts.ts_esp0);
  102b42:	a1 c4 f8 10 00       	mov    0x10f8c4,%eax
  102b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4b:	c7 04 24 90 3f 10 00 	movl   $0x103f90,(%esp)
  102b52:	e8 9d d8 ff ff       	call   1003f4 <cprintf>
	cprintf("TSS ss:%x\n", ts.ts_ss0);
  102b57:	0f b7 05 c8 f8 10 00 	movzwl 0x10f8c8,%eax
  102b5e:	0f b7 c0             	movzwl %ax,%eax
  102b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b65:	c7 04 24 9c 3f 10 00 	movl   $0x103f9c,(%esp)
  102b6c:	e8 83 d8 ff ff       	call   1003f4 <cprintf>
    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b71:	66 c7 05 28 ea 10 00 	movw   $0x68,0x10ea28
  102b78:	68 00 
  102b7a:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102b7f:	66 a3 2a ea 10 00    	mov    %ax,0x10ea2a
  102b85:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102b8a:	c1 e8 10             	shr    $0x10,%eax
  102b8d:	a2 2c ea 10 00       	mov    %al,0x10ea2c
  102b92:	0f b6 05 2d ea 10 00 	movzbl 0x10ea2d,%eax
  102b99:	83 e0 f0             	and    $0xfffffff0,%eax
  102b9c:	83 c8 09             	or     $0x9,%eax
  102b9f:	a2 2d ea 10 00       	mov    %al,0x10ea2d
  102ba4:	0f b6 05 2d ea 10 00 	movzbl 0x10ea2d,%eax
  102bab:	83 c8 10             	or     $0x10,%eax
  102bae:	a2 2d ea 10 00       	mov    %al,0x10ea2d
  102bb3:	0f b6 05 2d ea 10 00 	movzbl 0x10ea2d,%eax
  102bba:	83 e0 9f             	and    $0xffffff9f,%eax
  102bbd:	a2 2d ea 10 00       	mov    %al,0x10ea2d
  102bc2:	0f b6 05 2d ea 10 00 	movzbl 0x10ea2d,%eax
  102bc9:	83 c8 80             	or     $0xffffff80,%eax
  102bcc:	a2 2d ea 10 00       	mov    %al,0x10ea2d
  102bd1:	0f b6 05 2e ea 10 00 	movzbl 0x10ea2e,%eax
  102bd8:	83 e0 f0             	and    $0xfffffff0,%eax
  102bdb:	a2 2e ea 10 00       	mov    %al,0x10ea2e
  102be0:	0f b6 05 2e ea 10 00 	movzbl 0x10ea2e,%eax
  102be7:	83 e0 ef             	and    $0xffffffef,%eax
  102bea:	a2 2e ea 10 00       	mov    %al,0x10ea2e
  102bef:	0f b6 05 2e ea 10 00 	movzbl 0x10ea2e,%eax
  102bf6:	83 e0 df             	and    $0xffffffdf,%eax
  102bf9:	a2 2e ea 10 00       	mov    %al,0x10ea2e
  102bfe:	0f b6 05 2e ea 10 00 	movzbl 0x10ea2e,%eax
  102c05:	83 c8 40             	or     $0x40,%eax
  102c08:	a2 2e ea 10 00       	mov    %al,0x10ea2e
  102c0d:	0f b6 05 2e ea 10 00 	movzbl 0x10ea2e,%eax
  102c14:	83 e0 7f             	and    $0x7f,%eax
  102c17:	a2 2e ea 10 00       	mov    %al,0x10ea2e
  102c1c:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102c21:	c1 e8 18             	shr    $0x18,%eax
  102c24:	a2 2f ea 10 00       	mov    %al,0x10ea2f
    gdt[SEG_TSS].sd_s = 0;
  102c29:	0f b6 05 2d ea 10 00 	movzbl 0x10ea2d,%eax
  102c30:	83 e0 ef             	and    $0xffffffef,%eax
  102c33:	a2 2d ea 10 00       	mov    %al,0x10ea2d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c38:	c7 04 24 30 ea 10 00 	movl   $0x10ea30,(%esp)
  102c3f:	e8 ab fe ff ff       	call   102aef <lgdt>
  102c44:	66 c7 45 f6 28 00    	movw   $0x28,-0xa(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102c4a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  102c4e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c51:	c9                   	leave  
  102c52:	c3                   	ret    

00102c53 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c53:	55                   	push   %ebp
  102c54:	89 e5                	mov    %esp,%ebp
  102c56:	83 ec 08             	sub    $0x8,%esp
    gdt_init();
  102c59:	e8 c6 fe ff ff       	call   102b24 <gdt_init>
}
  102c5e:	c9                   	leave  
  102c5f:	c3                   	ret    

00102c60 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102c60:	55                   	push   %ebp
  102c61:	89 e5                	mov    %esp,%ebp
  102c63:	83 ec 58             	sub    $0x58,%esp
  102c66:	8b 45 10             	mov    0x10(%ebp),%eax
  102c69:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c6c:	8b 45 14             	mov    0x14(%ebp),%eax
  102c6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102c72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c78:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c7b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102c7e:	8b 45 18             	mov    0x18(%ebp),%eax
  102c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c8d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102c9a:	74 1c                	je     102cb8 <printnum+0x58>
  102c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  102ca4:	f7 75 e4             	divl   -0x1c(%ebp)
  102ca7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cad:	ba 00 00 00 00       	mov    $0x0,%edx
  102cb2:	f7 75 e4             	divl   -0x1c(%ebp)
  102cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cbe:	f7 75 e4             	divl   -0x1c(%ebp)
  102cc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cc4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102cd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102cd9:	8b 45 18             	mov    0x18(%ebp),%eax
  102cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  102ce1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ce4:	77 56                	ja     102d3c <printnum+0xdc>
  102ce6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ce9:	72 05                	jb     102cf0 <printnum+0x90>
  102ceb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102cee:	77 4c                	ja     102d3c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102cf0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102cf3:	8d 50 ff             	lea    -0x1(%eax),%edx
  102cf6:	8b 45 20             	mov    0x20(%ebp),%eax
  102cf9:	89 44 24 18          	mov    %eax,0x18(%esp)
  102cfd:	89 54 24 14          	mov    %edx,0x14(%esp)
  102d01:	8b 45 18             	mov    0x18(%ebp),%eax
  102d04:	89 44 24 10          	mov    %eax,0x10(%esp)
  102d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d12:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d20:	89 04 24             	mov    %eax,(%esp)
  102d23:	e8 38 ff ff ff       	call   102c60 <printnum>
  102d28:	eb 1c                	jmp    102d46 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d31:	8b 45 20             	mov    0x20(%ebp),%eax
  102d34:	89 04 24             	mov    %eax,(%esp)
  102d37:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3a:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102d3c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102d40:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102d44:	7f e4                	jg     102d2a <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102d46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d49:	05 28 40 10 00       	add    $0x104028,%eax
  102d4e:	0f b6 00             	movzbl (%eax),%eax
  102d51:	0f be c0             	movsbl %al,%eax
  102d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d57:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d5b:	89 04 24             	mov    %eax,(%esp)
  102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d61:	ff d0                	call   *%eax
}
  102d63:	c9                   	leave  
  102d64:	c3                   	ret    

00102d65 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102d65:	55                   	push   %ebp
  102d66:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102d68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102d6c:	7e 14                	jle    102d82 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d71:	8b 00                	mov    (%eax),%eax
  102d73:	8d 48 08             	lea    0x8(%eax),%ecx
  102d76:	8b 55 08             	mov    0x8(%ebp),%edx
  102d79:	89 0a                	mov    %ecx,(%edx)
  102d7b:	8b 50 04             	mov    0x4(%eax),%edx
  102d7e:	8b 00                	mov    (%eax),%eax
  102d80:	eb 30                	jmp    102db2 <getuint+0x4d>
    }
    else if (lflag) {
  102d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d86:	74 16                	je     102d9e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102d88:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8b:	8b 00                	mov    (%eax),%eax
  102d8d:	8d 48 04             	lea    0x4(%eax),%ecx
  102d90:	8b 55 08             	mov    0x8(%ebp),%edx
  102d93:	89 0a                	mov    %ecx,(%edx)
  102d95:	8b 00                	mov    (%eax),%eax
  102d97:	ba 00 00 00 00       	mov    $0x0,%edx
  102d9c:	eb 14                	jmp    102db2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	8b 00                	mov    (%eax),%eax
  102da3:	8d 48 04             	lea    0x4(%eax),%ecx
  102da6:	8b 55 08             	mov    0x8(%ebp),%edx
  102da9:	89 0a                	mov    %ecx,(%edx)
  102dab:	8b 00                	mov    (%eax),%eax
  102dad:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102db2:	5d                   	pop    %ebp
  102db3:	c3                   	ret    

00102db4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102db4:	55                   	push   %ebp
  102db5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102db7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102dbb:	7e 14                	jle    102dd1 <getint+0x1d>
        return va_arg(*ap, long long);
  102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc0:	8b 00                	mov    (%eax),%eax
  102dc2:	8d 48 08             	lea    0x8(%eax),%ecx
  102dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc8:	89 0a                	mov    %ecx,(%edx)
  102dca:	8b 50 04             	mov    0x4(%eax),%edx
  102dcd:	8b 00                	mov    (%eax),%eax
  102dcf:	eb 28                	jmp    102df9 <getint+0x45>
    }
    else if (lflag) {
  102dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dd5:	74 12                	je     102de9 <getint+0x35>
        return va_arg(*ap, long);
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	8b 00                	mov    (%eax),%eax
  102ddc:	8d 48 04             	lea    0x4(%eax),%ecx
  102ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  102de2:	89 0a                	mov    %ecx,(%edx)
  102de4:	8b 00                	mov    (%eax),%eax
  102de6:	99                   	cltd   
  102de7:	eb 10                	jmp    102df9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102de9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dec:	8b 00                	mov    (%eax),%eax
  102dee:	8d 48 04             	lea    0x4(%eax),%ecx
  102df1:	8b 55 08             	mov    0x8(%ebp),%edx
  102df4:	89 0a                	mov    %ecx,(%edx)
  102df6:	8b 00                	mov    (%eax),%eax
  102df8:	99                   	cltd   
    }
}
  102df9:	5d                   	pop    %ebp
  102dfa:	c3                   	ret    

00102dfb <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102dfb:	55                   	push   %ebp
  102dfc:	89 e5                	mov    %esp,%ebp
  102dfe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102e01:	8d 45 14             	lea    0x14(%ebp),%eax
  102e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  102e11:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1f:	89 04 24             	mov    %eax,(%esp)
  102e22:	e8 02 00 00 00       	call   102e29 <vprintfmt>
    va_end(ap);
}
  102e27:	c9                   	leave  
  102e28:	c3                   	ret    

00102e29 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e29:	55                   	push   %ebp
  102e2a:	89 e5                	mov    %esp,%ebp
  102e2c:	56                   	push   %esi
  102e2d:	53                   	push   %ebx
  102e2e:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e31:	eb 18                	jmp    102e4b <vprintfmt+0x22>
            if (ch == '\0') {
  102e33:	85 db                	test   %ebx,%ebx
  102e35:	75 05                	jne    102e3c <vprintfmt+0x13>
                return;
  102e37:	e9 d1 03 00 00       	jmp    10320d <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e43:	89 1c 24             	mov    %ebx,(%esp)
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  102e4e:	8d 50 01             	lea    0x1(%eax),%edx
  102e51:	89 55 10             	mov    %edx,0x10(%ebp)
  102e54:	0f b6 00             	movzbl (%eax),%eax
  102e57:	0f b6 d8             	movzbl %al,%ebx
  102e5a:	83 fb 25             	cmp    $0x25,%ebx
  102e5d:	75 d4                	jne    102e33 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102e5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102e63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102e70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e7a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  102e80:	8d 50 01             	lea    0x1(%eax),%edx
  102e83:	89 55 10             	mov    %edx,0x10(%ebp)
  102e86:	0f b6 00             	movzbl (%eax),%eax
  102e89:	0f b6 d8             	movzbl %al,%ebx
  102e8c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102e8f:	83 f8 55             	cmp    $0x55,%eax
  102e92:	0f 87 44 03 00 00    	ja     1031dc <vprintfmt+0x3b3>
  102e98:	8b 04 85 4c 40 10 00 	mov    0x10404c(,%eax,4),%eax
  102e9f:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102ea1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102ea5:	eb d6                	jmp    102e7d <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102ea7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102eab:	eb d0                	jmp    102e7d <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ead:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102eb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eb7:	89 d0                	mov    %edx,%eax
  102eb9:	c1 e0 02             	shl    $0x2,%eax
  102ebc:	01 d0                	add    %edx,%eax
  102ebe:	01 c0                	add    %eax,%eax
  102ec0:	01 d8                	add    %ebx,%eax
  102ec2:	83 e8 30             	sub    $0x30,%eax
  102ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  102ecb:	0f b6 00             	movzbl (%eax),%eax
  102ece:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ed1:	83 fb 2f             	cmp    $0x2f,%ebx
  102ed4:	7e 0b                	jle    102ee1 <vprintfmt+0xb8>
  102ed6:	83 fb 39             	cmp    $0x39,%ebx
  102ed9:	7f 06                	jg     102ee1 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102edb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102edf:	eb d3                	jmp    102eb4 <vprintfmt+0x8b>
            goto process_precision;
  102ee1:	eb 33                	jmp    102f16 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102ee3:	8b 45 14             	mov    0x14(%ebp),%eax
  102ee6:	8d 50 04             	lea    0x4(%eax),%edx
  102ee9:	89 55 14             	mov    %edx,0x14(%ebp)
  102eec:	8b 00                	mov    (%eax),%eax
  102eee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ef1:	eb 23                	jmp    102f16 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102ef3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ef7:	79 0c                	jns    102f05 <vprintfmt+0xdc>
                width = 0;
  102ef9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102f00:	e9 78 ff ff ff       	jmp    102e7d <vprintfmt+0x54>
  102f05:	e9 73 ff ff ff       	jmp    102e7d <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102f0a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102f11:	e9 67 ff ff ff       	jmp    102e7d <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102f16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f1a:	79 12                	jns    102f2e <vprintfmt+0x105>
                width = precision, precision = -1;
  102f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f22:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102f29:	e9 4f ff ff ff       	jmp    102e7d <vprintfmt+0x54>
  102f2e:	e9 4a ff ff ff       	jmp    102e7d <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f33:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102f37:	e9 41 ff ff ff       	jmp    102e7d <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  102f3f:	8d 50 04             	lea    0x4(%eax),%edx
  102f42:	89 55 14             	mov    %edx,0x14(%ebp)
  102f45:	8b 00                	mov    (%eax),%eax
  102f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f4a:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f4e:	89 04 24             	mov    %eax,(%esp)
  102f51:	8b 45 08             	mov    0x8(%ebp),%eax
  102f54:	ff d0                	call   *%eax
            break;
  102f56:	e9 ac 02 00 00       	jmp    103207 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102f5b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f5e:	8d 50 04             	lea    0x4(%eax),%edx
  102f61:	89 55 14             	mov    %edx,0x14(%ebp)
  102f64:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102f66:	85 db                	test   %ebx,%ebx
  102f68:	79 02                	jns    102f6c <vprintfmt+0x143>
                err = -err;
  102f6a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102f6c:	83 fb 06             	cmp    $0x6,%ebx
  102f6f:	7f 0b                	jg     102f7c <vprintfmt+0x153>
  102f71:	8b 34 9d 0c 40 10 00 	mov    0x10400c(,%ebx,4),%esi
  102f78:	85 f6                	test   %esi,%esi
  102f7a:	75 23                	jne    102f9f <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102f7c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102f80:	c7 44 24 08 39 40 10 	movl   $0x104039,0x8(%esp)
  102f87:	00 
  102f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f92:	89 04 24             	mov    %eax,(%esp)
  102f95:	e8 61 fe ff ff       	call   102dfb <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102f9a:	e9 68 02 00 00       	jmp    103207 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102f9f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102fa3:	c7 44 24 08 42 40 10 	movl   $0x104042,0x8(%esp)
  102faa:	00 
  102fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fae:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb5:	89 04 24             	mov    %eax,(%esp)
  102fb8:	e8 3e fe ff ff       	call   102dfb <printfmt>
            }
            break;
  102fbd:	e9 45 02 00 00       	jmp    103207 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102fc2:	8b 45 14             	mov    0x14(%ebp),%eax
  102fc5:	8d 50 04             	lea    0x4(%eax),%edx
  102fc8:	89 55 14             	mov    %edx,0x14(%ebp)
  102fcb:	8b 30                	mov    (%eax),%esi
  102fcd:	85 f6                	test   %esi,%esi
  102fcf:	75 05                	jne    102fd6 <vprintfmt+0x1ad>
                p = "(null)";
  102fd1:	be 45 40 10 00       	mov    $0x104045,%esi
            }
            if (width > 0 && padc != '-') {
  102fd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fda:	7e 3e                	jle    10301a <vprintfmt+0x1f1>
  102fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102fe0:	74 38                	je     10301a <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102fe2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fec:	89 34 24             	mov    %esi,(%esp)
  102fef:	e8 15 03 00 00       	call   103309 <strnlen>
  102ff4:	29 c3                	sub    %eax,%ebx
  102ff6:	89 d8                	mov    %ebx,%eax
  102ff8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ffb:	eb 17                	jmp    103014 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ffd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103001:	8b 55 0c             	mov    0xc(%ebp),%edx
  103004:	89 54 24 04          	mov    %edx,0x4(%esp)
  103008:	89 04 24             	mov    %eax,(%esp)
  10300b:	8b 45 08             	mov    0x8(%ebp),%eax
  10300e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103010:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103014:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103018:	7f e3                	jg     102ffd <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10301a:	eb 38                	jmp    103054 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10301c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103020:	74 1f                	je     103041 <vprintfmt+0x218>
  103022:	83 fb 1f             	cmp    $0x1f,%ebx
  103025:	7e 05                	jle    10302c <vprintfmt+0x203>
  103027:	83 fb 7e             	cmp    $0x7e,%ebx
  10302a:	7e 15                	jle    103041 <vprintfmt+0x218>
                    putch('?', putdat);
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103033:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10303a:	8b 45 08             	mov    0x8(%ebp),%eax
  10303d:	ff d0                	call   *%eax
  10303f:	eb 0f                	jmp    103050 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  103041:	8b 45 0c             	mov    0xc(%ebp),%eax
  103044:	89 44 24 04          	mov    %eax,0x4(%esp)
  103048:	89 1c 24             	mov    %ebx,(%esp)
  10304b:	8b 45 08             	mov    0x8(%ebp),%eax
  10304e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103050:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103054:	89 f0                	mov    %esi,%eax
  103056:	8d 70 01             	lea    0x1(%eax),%esi
  103059:	0f b6 00             	movzbl (%eax),%eax
  10305c:	0f be d8             	movsbl %al,%ebx
  10305f:	85 db                	test   %ebx,%ebx
  103061:	74 10                	je     103073 <vprintfmt+0x24a>
  103063:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103067:	78 b3                	js     10301c <vprintfmt+0x1f3>
  103069:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10306d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103071:	79 a9                	jns    10301c <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103073:	eb 17                	jmp    10308c <vprintfmt+0x263>
                putch(' ', putdat);
  103075:	8b 45 0c             	mov    0xc(%ebp),%eax
  103078:	89 44 24 04          	mov    %eax,0x4(%esp)
  10307c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103083:	8b 45 08             	mov    0x8(%ebp),%eax
  103086:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103088:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10308c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103090:	7f e3                	jg     103075 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  103092:	e9 70 01 00 00       	jmp    103207 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10309a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10309e:	8d 45 14             	lea    0x14(%ebp),%eax
  1030a1:	89 04 24             	mov    %eax,(%esp)
  1030a4:	e8 0b fd ff ff       	call   102db4 <getint>
  1030a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b5:	85 d2                	test   %edx,%edx
  1030b7:	79 26                	jns    1030df <vprintfmt+0x2b6>
                putch('-', putdat);
  1030b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ca:	ff d0                	call   *%eax
                num = -(long long)num;
  1030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030d2:	f7 d8                	neg    %eax
  1030d4:	83 d2 00             	adc    $0x0,%edx
  1030d7:	f7 da                	neg    %edx
  1030d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1030df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030e6:	e9 a8 00 00 00       	jmp    103193 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1030eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030f2:	8d 45 14             	lea    0x14(%ebp),%eax
  1030f5:	89 04 24             	mov    %eax,(%esp)
  1030f8:	e8 68 fc ff ff       	call   102d65 <getuint>
  1030fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103100:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103103:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10310a:	e9 84 00 00 00       	jmp    103193 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10310f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103112:	89 44 24 04          	mov    %eax,0x4(%esp)
  103116:	8d 45 14             	lea    0x14(%ebp),%eax
  103119:	89 04 24             	mov    %eax,(%esp)
  10311c:	e8 44 fc ff ff       	call   102d65 <getuint>
  103121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103124:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103127:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10312e:	eb 63                	jmp    103193 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  103130:	8b 45 0c             	mov    0xc(%ebp),%eax
  103133:	89 44 24 04          	mov    %eax,0x4(%esp)
  103137:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10313e:	8b 45 08             	mov    0x8(%ebp),%eax
  103141:	ff d0                	call   *%eax
            putch('x', putdat);
  103143:	8b 45 0c             	mov    0xc(%ebp),%eax
  103146:	89 44 24 04          	mov    %eax,0x4(%esp)
  10314a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103151:	8b 45 08             	mov    0x8(%ebp),%eax
  103154:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103156:	8b 45 14             	mov    0x14(%ebp),%eax
  103159:	8d 50 04             	lea    0x4(%eax),%edx
  10315c:	89 55 14             	mov    %edx,0x14(%ebp)
  10315f:	8b 00                	mov    (%eax),%eax
  103161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10316b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103172:	eb 1f                	jmp    103193 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103177:	89 44 24 04          	mov    %eax,0x4(%esp)
  10317b:	8d 45 14             	lea    0x14(%ebp),%eax
  10317e:	89 04 24             	mov    %eax,(%esp)
  103181:	e8 df fb ff ff       	call   102d65 <getuint>
  103186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103189:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10318c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10319a:	89 54 24 18          	mov    %edx,0x18(%esp)
  10319e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1031a1:	89 54 24 14          	mov    %edx,0x14(%esp)
  1031a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031af:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031be:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c1:	89 04 24             	mov    %eax,(%esp)
  1031c4:	e8 97 fa ff ff       	call   102c60 <printnum>
            break;
  1031c9:	eb 3c                	jmp    103207 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1031cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031d2:	89 1c 24             	mov    %ebx,(%esp)
  1031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d8:	ff d0                	call   *%eax
            break;
  1031da:	eb 2b                	jmp    103207 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1031dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031e3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1031ef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031f3:	eb 04                	jmp    1031f9 <vprintfmt+0x3d0>
  1031f5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1031fc:	83 e8 01             	sub    $0x1,%eax
  1031ff:	0f b6 00             	movzbl (%eax),%eax
  103202:	3c 25                	cmp    $0x25,%al
  103204:	75 ef                	jne    1031f5 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103206:	90                   	nop
        }
    }
  103207:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103208:	e9 3e fc ff ff       	jmp    102e4b <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10320d:	83 c4 40             	add    $0x40,%esp
  103210:	5b                   	pop    %ebx
  103211:	5e                   	pop    %esi
  103212:	5d                   	pop    %ebp
  103213:	c3                   	ret    

00103214 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103214:	55                   	push   %ebp
  103215:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103217:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321a:	8b 40 08             	mov    0x8(%eax),%eax
  10321d:	8d 50 01             	lea    0x1(%eax),%edx
  103220:	8b 45 0c             	mov    0xc(%ebp),%eax
  103223:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103226:	8b 45 0c             	mov    0xc(%ebp),%eax
  103229:	8b 10                	mov    (%eax),%edx
  10322b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322e:	8b 40 04             	mov    0x4(%eax),%eax
  103231:	39 c2                	cmp    %eax,%edx
  103233:	73 12                	jae    103247 <sprintputch+0x33>
        *b->buf ++ = ch;
  103235:	8b 45 0c             	mov    0xc(%ebp),%eax
  103238:	8b 00                	mov    (%eax),%eax
  10323a:	8d 48 01             	lea    0x1(%eax),%ecx
  10323d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103240:	89 0a                	mov    %ecx,(%edx)
  103242:	8b 55 08             	mov    0x8(%ebp),%edx
  103245:	88 10                	mov    %dl,(%eax)
    }
}
  103247:	5d                   	pop    %ebp
  103248:	c3                   	ret    

00103249 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103249:	55                   	push   %ebp
  10324a:	89 e5                	mov    %esp,%ebp
  10324c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10324f:	8d 45 14             	lea    0x14(%ebp),%eax
  103252:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103258:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10325c:	8b 45 10             	mov    0x10(%ebp),%eax
  10325f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326a:	8b 45 08             	mov    0x8(%ebp),%eax
  10326d:	89 04 24             	mov    %eax,(%esp)
  103270:	e8 08 00 00 00       	call   10327d <vsnprintf>
  103275:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10327b:	c9                   	leave  
  10327c:	c3                   	ret    

0010327d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10327d:	55                   	push   %ebp
  10327e:	89 e5                	mov    %esp,%ebp
  103280:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103283:	8b 45 08             	mov    0x8(%ebp),%eax
  103286:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103289:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10328f:	8b 45 08             	mov    0x8(%ebp),%eax
  103292:	01 d0                	add    %edx,%eax
  103294:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10329e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1032a2:	74 0a                	je     1032ae <vsnprintf+0x31>
  1032a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032aa:	39 c2                	cmp    %eax,%edx
  1032ac:	76 07                	jbe    1032b5 <vsnprintf+0x38>
        return -E_INVAL;
  1032ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1032b3:	eb 2a                	jmp    1032df <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1032b5:	8b 45 14             	mov    0x14(%ebp),%eax
  1032b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1032bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1032c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ca:	c7 04 24 14 32 10 00 	movl   $0x103214,(%esp)
  1032d1:	e8 53 fb ff ff       	call   102e29 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032d9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032df:	c9                   	leave  
  1032e0:	c3                   	ret    

001032e1 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1032e1:	55                   	push   %ebp
  1032e2:	89 e5                	mov    %esp,%ebp
  1032e4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1032e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1032ee:	eb 04                	jmp    1032f4 <strlen+0x13>
        cnt ++;
  1032f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f7:	8d 50 01             	lea    0x1(%eax),%edx
  1032fa:	89 55 08             	mov    %edx,0x8(%ebp)
  1032fd:	0f b6 00             	movzbl (%eax),%eax
  103300:	84 c0                	test   %al,%al
  103302:	75 ec                	jne    1032f0 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103304:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103307:	c9                   	leave  
  103308:	c3                   	ret    

00103309 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103309:	55                   	push   %ebp
  10330a:	89 e5                	mov    %esp,%ebp
  10330c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10330f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103316:	eb 04                	jmp    10331c <strnlen+0x13>
        cnt ++;
  103318:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10331c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10331f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103322:	73 10                	jae    103334 <strnlen+0x2b>
  103324:	8b 45 08             	mov    0x8(%ebp),%eax
  103327:	8d 50 01             	lea    0x1(%eax),%edx
  10332a:	89 55 08             	mov    %edx,0x8(%ebp)
  10332d:	0f b6 00             	movzbl (%eax),%eax
  103330:	84 c0                	test   %al,%al
  103332:	75 e4                	jne    103318 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103337:	c9                   	leave  
  103338:	c3                   	ret    

00103339 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103339:	55                   	push   %ebp
  10333a:	89 e5                	mov    %esp,%ebp
  10333c:	57                   	push   %edi
  10333d:	56                   	push   %esi
  10333e:	83 ec 20             	sub    $0x20,%esp
  103341:	8b 45 08             	mov    0x8(%ebp),%eax
  103344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103347:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10334d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103353:	89 d1                	mov    %edx,%ecx
  103355:	89 c2                	mov    %eax,%edx
  103357:	89 ce                	mov    %ecx,%esi
  103359:	89 d7                	mov    %edx,%edi
  10335b:	ac                   	lods   %ds:(%esi),%al
  10335c:	aa                   	stos   %al,%es:(%edi)
  10335d:	84 c0                	test   %al,%al
  10335f:	75 fa                	jne    10335b <strcpy+0x22>
  103361:	89 fa                	mov    %edi,%edx
  103363:	89 f1                	mov    %esi,%ecx
  103365:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103368:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10336b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103371:	83 c4 20             	add    $0x20,%esp
  103374:	5e                   	pop    %esi
  103375:	5f                   	pop    %edi
  103376:	5d                   	pop    %ebp
  103377:	c3                   	ret    

00103378 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103378:	55                   	push   %ebp
  103379:	89 e5                	mov    %esp,%ebp
  10337b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10337e:	8b 45 08             	mov    0x8(%ebp),%eax
  103381:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103384:	eb 21                	jmp    1033a7 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103386:	8b 45 0c             	mov    0xc(%ebp),%eax
  103389:	0f b6 10             	movzbl (%eax),%edx
  10338c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10338f:	88 10                	mov    %dl,(%eax)
  103391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103394:	0f b6 00             	movzbl (%eax),%eax
  103397:	84 c0                	test   %al,%al
  103399:	74 04                	je     10339f <strncpy+0x27>
            src ++;
  10339b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10339f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1033a3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1033a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033ab:	75 d9                	jne    103386 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1033ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1033b0:	c9                   	leave  
  1033b1:	c3                   	ret    

001033b2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1033b2:	55                   	push   %ebp
  1033b3:	89 e5                	mov    %esp,%ebp
  1033b5:	57                   	push   %edi
  1033b6:	56                   	push   %esi
  1033b7:	83 ec 20             	sub    $0x20,%esp
  1033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1033bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1033c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033cc:	89 d1                	mov    %edx,%ecx
  1033ce:	89 c2                	mov    %eax,%edx
  1033d0:	89 ce                	mov    %ecx,%esi
  1033d2:	89 d7                	mov    %edx,%edi
  1033d4:	ac                   	lods   %ds:(%esi),%al
  1033d5:	ae                   	scas   %es:(%edi),%al
  1033d6:	75 08                	jne    1033e0 <strcmp+0x2e>
  1033d8:	84 c0                	test   %al,%al
  1033da:	75 f8                	jne    1033d4 <strcmp+0x22>
  1033dc:	31 c0                	xor    %eax,%eax
  1033de:	eb 04                	jmp    1033e4 <strcmp+0x32>
  1033e0:	19 c0                	sbb    %eax,%eax
  1033e2:	0c 01                	or     $0x1,%al
  1033e4:	89 fa                	mov    %edi,%edx
  1033e6:	89 f1                	mov    %esi,%ecx
  1033e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033eb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1033f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1033f4:	83 c4 20             	add    $0x20,%esp
  1033f7:	5e                   	pop    %esi
  1033f8:	5f                   	pop    %edi
  1033f9:	5d                   	pop    %ebp
  1033fa:	c3                   	ret    

001033fb <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1033fb:	55                   	push   %ebp
  1033fc:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1033fe:	eb 0c                	jmp    10340c <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103400:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103404:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103408:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10340c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103410:	74 1a                	je     10342c <strncmp+0x31>
  103412:	8b 45 08             	mov    0x8(%ebp),%eax
  103415:	0f b6 00             	movzbl (%eax),%eax
  103418:	84 c0                	test   %al,%al
  10341a:	74 10                	je     10342c <strncmp+0x31>
  10341c:	8b 45 08             	mov    0x8(%ebp),%eax
  10341f:	0f b6 10             	movzbl (%eax),%edx
  103422:	8b 45 0c             	mov    0xc(%ebp),%eax
  103425:	0f b6 00             	movzbl (%eax),%eax
  103428:	38 c2                	cmp    %al,%dl
  10342a:	74 d4                	je     103400 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10342c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103430:	74 18                	je     10344a <strncmp+0x4f>
  103432:	8b 45 08             	mov    0x8(%ebp),%eax
  103435:	0f b6 00             	movzbl (%eax),%eax
  103438:	0f b6 d0             	movzbl %al,%edx
  10343b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343e:	0f b6 00             	movzbl (%eax),%eax
  103441:	0f b6 c0             	movzbl %al,%eax
  103444:	29 c2                	sub    %eax,%edx
  103446:	89 d0                	mov    %edx,%eax
  103448:	eb 05                	jmp    10344f <strncmp+0x54>
  10344a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10344f:	5d                   	pop    %ebp
  103450:	c3                   	ret    

00103451 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103451:	55                   	push   %ebp
  103452:	89 e5                	mov    %esp,%ebp
  103454:	83 ec 04             	sub    $0x4,%esp
  103457:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10345d:	eb 14                	jmp    103473 <strchr+0x22>
        if (*s == c) {
  10345f:	8b 45 08             	mov    0x8(%ebp),%eax
  103462:	0f b6 00             	movzbl (%eax),%eax
  103465:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103468:	75 05                	jne    10346f <strchr+0x1e>
            return (char *)s;
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	eb 13                	jmp    103482 <strchr+0x31>
        }
        s ++;
  10346f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103473:	8b 45 08             	mov    0x8(%ebp),%eax
  103476:	0f b6 00             	movzbl (%eax),%eax
  103479:	84 c0                	test   %al,%al
  10347b:	75 e2                	jne    10345f <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10347d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103482:	c9                   	leave  
  103483:	c3                   	ret    

00103484 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103484:	55                   	push   %ebp
  103485:	89 e5                	mov    %esp,%ebp
  103487:	83 ec 04             	sub    $0x4,%esp
  10348a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103490:	eb 11                	jmp    1034a3 <strfind+0x1f>
        if (*s == c) {
  103492:	8b 45 08             	mov    0x8(%ebp),%eax
  103495:	0f b6 00             	movzbl (%eax),%eax
  103498:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10349b:	75 02                	jne    10349f <strfind+0x1b>
            break;
  10349d:	eb 0e                	jmp    1034ad <strfind+0x29>
        }
        s ++;
  10349f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a6:	0f b6 00             	movzbl (%eax),%eax
  1034a9:	84 c0                	test   %al,%al
  1034ab:	75 e5                	jne    103492 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1034ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1034b0:	c9                   	leave  
  1034b1:	c3                   	ret    

001034b2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1034b2:	55                   	push   %ebp
  1034b3:	89 e5                	mov    %esp,%ebp
  1034b5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1034b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1034bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1034c6:	eb 04                	jmp    1034cc <strtol+0x1a>
        s ++;
  1034c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cf:	0f b6 00             	movzbl (%eax),%eax
  1034d2:	3c 20                	cmp    $0x20,%al
  1034d4:	74 f2                	je     1034c8 <strtol+0x16>
  1034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d9:	0f b6 00             	movzbl (%eax),%eax
  1034dc:	3c 09                	cmp    $0x9,%al
  1034de:	74 e8                	je     1034c8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e3:	0f b6 00             	movzbl (%eax),%eax
  1034e6:	3c 2b                	cmp    $0x2b,%al
  1034e8:	75 06                	jne    1034f0 <strtol+0x3e>
        s ++;
  1034ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1034ee:	eb 15                	jmp    103505 <strtol+0x53>
    }
    else if (*s == '-') {
  1034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f3:	0f b6 00             	movzbl (%eax),%eax
  1034f6:	3c 2d                	cmp    $0x2d,%al
  1034f8:	75 0b                	jne    103505 <strtol+0x53>
        s ++, neg = 1;
  1034fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1034fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103505:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103509:	74 06                	je     103511 <strtol+0x5f>
  10350b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10350f:	75 24                	jne    103535 <strtol+0x83>
  103511:	8b 45 08             	mov    0x8(%ebp),%eax
  103514:	0f b6 00             	movzbl (%eax),%eax
  103517:	3c 30                	cmp    $0x30,%al
  103519:	75 1a                	jne    103535 <strtol+0x83>
  10351b:	8b 45 08             	mov    0x8(%ebp),%eax
  10351e:	83 c0 01             	add    $0x1,%eax
  103521:	0f b6 00             	movzbl (%eax),%eax
  103524:	3c 78                	cmp    $0x78,%al
  103526:	75 0d                	jne    103535 <strtol+0x83>
        s += 2, base = 16;
  103528:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10352c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103533:	eb 2a                	jmp    10355f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103535:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103539:	75 17                	jne    103552 <strtol+0xa0>
  10353b:	8b 45 08             	mov    0x8(%ebp),%eax
  10353e:	0f b6 00             	movzbl (%eax),%eax
  103541:	3c 30                	cmp    $0x30,%al
  103543:	75 0d                	jne    103552 <strtol+0xa0>
        s ++, base = 8;
  103545:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103549:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103550:	eb 0d                	jmp    10355f <strtol+0xad>
    }
    else if (base == 0) {
  103552:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103556:	75 07                	jne    10355f <strtol+0xad>
        base = 10;
  103558:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10355f:	8b 45 08             	mov    0x8(%ebp),%eax
  103562:	0f b6 00             	movzbl (%eax),%eax
  103565:	3c 2f                	cmp    $0x2f,%al
  103567:	7e 1b                	jle    103584 <strtol+0xd2>
  103569:	8b 45 08             	mov    0x8(%ebp),%eax
  10356c:	0f b6 00             	movzbl (%eax),%eax
  10356f:	3c 39                	cmp    $0x39,%al
  103571:	7f 11                	jg     103584 <strtol+0xd2>
            dig = *s - '0';
  103573:	8b 45 08             	mov    0x8(%ebp),%eax
  103576:	0f b6 00             	movzbl (%eax),%eax
  103579:	0f be c0             	movsbl %al,%eax
  10357c:	83 e8 30             	sub    $0x30,%eax
  10357f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103582:	eb 48                	jmp    1035cc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103584:	8b 45 08             	mov    0x8(%ebp),%eax
  103587:	0f b6 00             	movzbl (%eax),%eax
  10358a:	3c 60                	cmp    $0x60,%al
  10358c:	7e 1b                	jle    1035a9 <strtol+0xf7>
  10358e:	8b 45 08             	mov    0x8(%ebp),%eax
  103591:	0f b6 00             	movzbl (%eax),%eax
  103594:	3c 7a                	cmp    $0x7a,%al
  103596:	7f 11                	jg     1035a9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103598:	8b 45 08             	mov    0x8(%ebp),%eax
  10359b:	0f b6 00             	movzbl (%eax),%eax
  10359e:	0f be c0             	movsbl %al,%eax
  1035a1:	83 e8 57             	sub    $0x57,%eax
  1035a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035a7:	eb 23                	jmp    1035cc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ac:	0f b6 00             	movzbl (%eax),%eax
  1035af:	3c 40                	cmp    $0x40,%al
  1035b1:	7e 3d                	jle    1035f0 <strtol+0x13e>
  1035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b6:	0f b6 00             	movzbl (%eax),%eax
  1035b9:	3c 5a                	cmp    $0x5a,%al
  1035bb:	7f 33                	jg     1035f0 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c0:	0f b6 00             	movzbl (%eax),%eax
  1035c3:	0f be c0             	movsbl %al,%eax
  1035c6:	83 e8 37             	sub    $0x37,%eax
  1035c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  1035d2:	7c 02                	jl     1035d6 <strtol+0x124>
            break;
  1035d4:	eb 1a                	jmp    1035f0 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1035d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1035da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  1035e1:	89 c2                	mov    %eax,%edx
  1035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e6:	01 d0                	add    %edx,%eax
  1035e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1035eb:	e9 6f ff ff ff       	jmp    10355f <strtol+0xad>

    if (endptr) {
  1035f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1035f4:	74 08                	je     1035fe <strtol+0x14c>
        *endptr = (char *) s;
  1035f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1035fc:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1035fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103602:	74 07                	je     10360b <strtol+0x159>
  103604:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103607:	f7 d8                	neg    %eax
  103609:	eb 03                	jmp    10360e <strtol+0x15c>
  10360b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10360e:	c9                   	leave  
  10360f:	c3                   	ret    

00103610 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103610:	55                   	push   %ebp
  103611:	89 e5                	mov    %esp,%ebp
  103613:	57                   	push   %edi
  103614:	83 ec 24             	sub    $0x24,%esp
  103617:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361a:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10361d:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103621:	8b 55 08             	mov    0x8(%ebp),%edx
  103624:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103627:	88 45 f7             	mov    %al,-0x9(%ebp)
  10362a:	8b 45 10             	mov    0x10(%ebp),%eax
  10362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103630:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103633:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103637:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10363a:	89 d7                	mov    %edx,%edi
  10363c:	f3 aa                	rep stos %al,%es:(%edi)
  10363e:	89 fa                	mov    %edi,%edx
  103640:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103643:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103646:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103649:	83 c4 24             	add    $0x24,%esp
  10364c:	5f                   	pop    %edi
  10364d:	5d                   	pop    %ebp
  10364e:	c3                   	ret    

0010364f <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10364f:	55                   	push   %ebp
  103650:	89 e5                	mov    %esp,%ebp
  103652:	57                   	push   %edi
  103653:	56                   	push   %esi
  103654:	53                   	push   %ebx
  103655:	83 ec 30             	sub    $0x30,%esp
  103658:	8b 45 08             	mov    0x8(%ebp),%eax
  10365b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10365e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103661:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103664:	8b 45 10             	mov    0x10(%ebp),%eax
  103667:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10366a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10366d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103670:	73 42                	jae    1036b4 <memmove+0x65>
  103672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10367b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103681:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103687:	c1 e8 02             	shr    $0x2,%eax
  10368a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10368c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10368f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103692:	89 d7                	mov    %edx,%edi
  103694:	89 c6                	mov    %eax,%esi
  103696:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103698:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10369b:	83 e1 03             	and    $0x3,%ecx
  10369e:	74 02                	je     1036a2 <memmove+0x53>
  1036a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1036a2:	89 f0                	mov    %esi,%eax
  1036a4:	89 fa                	mov    %edi,%edx
  1036a6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1036a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1036ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b2:	eb 36                	jmp    1036ea <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1036ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036bd:	01 c2                	add    %eax,%edx
  1036bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036c2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1036c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036c8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036ce:	89 c1                	mov    %eax,%ecx
  1036d0:	89 d8                	mov    %ebx,%eax
  1036d2:	89 d6                	mov    %edx,%esi
  1036d4:	89 c7                	mov    %eax,%edi
  1036d6:	fd                   	std    
  1036d7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1036d9:	fc                   	cld    
  1036da:	89 f8                	mov    %edi,%eax
  1036dc:	89 f2                	mov    %esi,%edx
  1036de:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1036e1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1036e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1036ea:	83 c4 30             	add    $0x30,%esp
  1036ed:	5b                   	pop    %ebx
  1036ee:	5e                   	pop    %esi
  1036ef:	5f                   	pop    %edi
  1036f0:	5d                   	pop    %ebp
  1036f1:	c3                   	ret    

001036f2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1036f2:	55                   	push   %ebp
  1036f3:	89 e5                	mov    %esp,%ebp
  1036f5:	57                   	push   %edi
  1036f6:	56                   	push   %esi
  1036f7:	83 ec 20             	sub    $0x20,%esp
  1036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1036fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103700:	8b 45 0c             	mov    0xc(%ebp),%eax
  103703:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103706:	8b 45 10             	mov    0x10(%ebp),%eax
  103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10370f:	c1 e8 02             	shr    $0x2,%eax
  103712:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10371a:	89 d7                	mov    %edx,%edi
  10371c:	89 c6                	mov    %eax,%esi
  10371e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103720:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103723:	83 e1 03             	and    $0x3,%ecx
  103726:	74 02                	je     10372a <memcpy+0x38>
  103728:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10372a:	89 f0                	mov    %esi,%eax
  10372c:	89 fa                	mov    %edi,%edx
  10372e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103731:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103734:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103737:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10373a:	83 c4 20             	add    $0x20,%esp
  10373d:	5e                   	pop    %esi
  10373e:	5f                   	pop    %edi
  10373f:	5d                   	pop    %ebp
  103740:	c3                   	ret    

00103741 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103741:	55                   	push   %ebp
  103742:	89 e5                	mov    %esp,%ebp
  103744:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103747:	8b 45 08             	mov    0x8(%ebp),%eax
  10374a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10374d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103750:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103753:	eb 30                	jmp    103785 <memcmp+0x44>
        if (*s1 != *s2) {
  103755:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103758:	0f b6 10             	movzbl (%eax),%edx
  10375b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10375e:	0f b6 00             	movzbl (%eax),%eax
  103761:	38 c2                	cmp    %al,%dl
  103763:	74 18                	je     10377d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103765:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103768:	0f b6 00             	movzbl (%eax),%eax
  10376b:	0f b6 d0             	movzbl %al,%edx
  10376e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103771:	0f b6 00             	movzbl (%eax),%eax
  103774:	0f b6 c0             	movzbl %al,%eax
  103777:	29 c2                	sub    %eax,%edx
  103779:	89 d0                	mov    %edx,%eax
  10377b:	eb 1a                	jmp    103797 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10377d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103781:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103785:	8b 45 10             	mov    0x10(%ebp),%eax
  103788:	8d 50 ff             	lea    -0x1(%eax),%edx
  10378b:	89 55 10             	mov    %edx,0x10(%ebp)
  10378e:	85 c0                	test   %eax,%eax
  103790:	75 c3                	jne    103755 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103792:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103797:	c9                   	leave  
  103798:	c3                   	ret    
