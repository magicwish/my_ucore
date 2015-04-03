
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba e8 89 11 00       	mov    $0x1189e8,%edx
  100035:	b8 56 7a 11 00       	mov    $0x117a56,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 56 7a 11 00 	movl   $0x117a56,(%esp)
  100051:	e8 9f 5f 00 00       	call   105ff5 <memset>

    cons_init();                // init the console
  100056:	e8 76 15 00 00       	call   1015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 61 10 00 	movl   $0x106180,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 61 10 00 	movl   $0x10619c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 8d 44 00 00       	call   104511 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b1 16 00 00       	call   10173a <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 29 18 00 00       	call   1018b7 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f4 0c 00 00       	call   100d87 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 10 16 00 00       	call   1016a8 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 fd 0b 00 00       	call   100cb9 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 60 7a 11 00       	mov    0x117a60,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 61 10 00 	movl   $0x1061a1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 60 7a 11 00       	mov    0x117a60,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 61 10 00 	movl   $0x1061af,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 60 7a 11 00       	mov    0x117a60,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 61 10 00 	movl   $0x1061bd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 60 7a 11 00       	mov    0x117a60,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 61 10 00 	movl   $0x1061cb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 60 7a 11 00       	mov    0x117a60,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 61 10 00 	movl   $0x1061d9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 60 7a 11 00       	mov    0x117a60,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 60 7a 11 00       	mov    %eax,0x117a60
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 62 10 00 	movl   $0x106208,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 62 10 00 	movl   $0x106227,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 80 7a 11 00    	mov    %dl,0x117a80(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 80 7a 11 00       	add    $0x117a80,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 80 7a 11 00       	mov    $0x117a80,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 03 13 00 00       	call   1015fd <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 d7 54 00 00       	call   10580e <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8a 12 00 00       	call   1015fd <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6a 12 00 00       	call   101639 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 62 10 00    	movl   $0x10622c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 62 10 00 	movl   $0x10622c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 c0 74 10 00 	movl   $0x1074c0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 c4 24 11 00 	movl   $0x1124c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec c5 24 11 00 	movl   $0x1124c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 62 4f 11 00 	movl   $0x114f62,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 7d 57 00 00       	call   105e69 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 62 10 00 	movl   $0x106236,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 62 10 00 	movl   $0x10624f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 7e 61 10 	movl   $0x10617e,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 62 10 00 	movl   $0x106267,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 56 7a 11 	movl   $0x117a56,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 62 10 00 	movl   $0x10627f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 e8 89 11 	movl   $0x1189e8,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 62 10 00 	movl   $0x106297,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 e8 89 11 00       	mov    $0x1189e8,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 62 10 00 	movl   $0x1062b0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 62 10 00 	movl   $0x1062da,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 62 10 00 	movl   $0x1062f6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
	cprintf("Hello world\n");
  1009c0:	c7 04 24 08 63 10 00 	movl   $0x106308,(%esp)
  1009c7:	e8 70 f9 ff ff       	call   10033c <cprintf>
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cc:	89 e8                	mov    %ebp,%eax
  1009ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	uint32_t ebp = read_ebp();
  1009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009d7:	e8 cd ff ff ff       	call   1009a9 <read_eip>
  1009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (ebp != 0)
  1009df:	e9 8e 00 00 00       	jmp    100a72 <print_stackframe+0xb8>
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f2:	c7 04 24 15 63 10 00 	movl   $0x106315,(%esp)
  1009f9:	e8 3e f9 ff ff       	call   10033c <cprintf>
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
  1009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a01:	83 c0 08             	add    $0x8,%eax
  100a04:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int i = 0;
  100a07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (; i < 4; i++)
  100a0e:	eb 2f                	jmp    100a3f <print_stackframe+0x85>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
  100a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1d:	01 d0                	add    %edx,%eax
  100a1f:	8b 00                	mov    (%eax),%eax
  100a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100a24:	83 c2 01             	add    $0x1,%edx
  100a27:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a2b:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a2f:	c7 04 24 2c 63 10 00 	movl   $0x10632c,(%esp)
  100a36:	e8 01 f9 ff ff       	call   10033c <cprintf>
	while (ebp != 0)
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
		int i = 0;
		for (; i < 4; i++)
  100a3b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
  100a43:	7e cb                	jle    100a10 <print_stackframe+0x56>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
		print_debuginfo(eip-1);
  100a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a48:	83 e8 01             	sub    $0x1,%eax
  100a4b:	89 04 24             	mov    %eax,(%esp)
  100a4e:	e8 b3 fe ff ff       	call   100906 <print_debuginfo>
		cprintf("\n");
  100a53:	c7 04 24 3a 63 10 00 	movl   $0x10633a,(%esp)
  100a5a:	e8 dd f8 ff ff       	call   10033c <cprintf>
		eip = *((uint32_t*)ebp+1);
  100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a62:	83 c0 04             	add    $0x4,%eax
  100a65:	8b 00                	mov    (%eax),%eax
  100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;	
  100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6d:	8b 00                	mov    (%eax),%eax
  100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	cprintf("Hello world\n");
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	while (ebp != 0)
  100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a76:	0f 85 68 ff ff ff    	jne    1009e4 <print_stackframe+0x2a>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a7c:	c9                   	leave  
  100a7d:	c3                   	ret    

00100a7e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7e:	55                   	push   %ebp
  100a7f:	89 e5                	mov    %esp,%ebp
  100a81:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8b:	eb 0c                	jmp    100a99 <parse+0x1b>
            *buf ++ = '\0';
  100a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a90:	8d 50 01             	lea    0x1(%eax),%edx
  100a93:	89 55 08             	mov    %edx,0x8(%ebp)
  100a96:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a99:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9c:	0f b6 00             	movzbl (%eax),%eax
  100a9f:	84 c0                	test   %al,%al
  100aa1:	74 1d                	je     100ac0 <parse+0x42>
  100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa6:	0f b6 00             	movzbl (%eax),%eax
  100aa9:	0f be c0             	movsbl %al,%eax
  100aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab0:	c7 04 24 bc 63 10 00 	movl   $0x1063bc,(%esp)
  100ab7:	e8 7a 53 00 00       	call   105e36 <strchr>
  100abc:	85 c0                	test   %eax,%eax
  100abe:	75 cd                	jne    100a8d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac3:	0f b6 00             	movzbl (%eax),%eax
  100ac6:	84 c0                	test   %al,%al
  100ac8:	75 02                	jne    100acc <parse+0x4e>
            break;
  100aca:	eb 67                	jmp    100b33 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad0:	75 14                	jne    100ae6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad9:	00 
  100ada:	c7 04 24 c1 63 10 00 	movl   $0x1063c1,(%esp)
  100ae1:	e8 56 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae9:	8d 50 01             	lea    0x1(%eax),%edx
  100aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af9:	01 c2                	add    %eax,%edx
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b00:	eb 04                	jmp    100b06 <parse+0x88>
            buf ++;
  100b02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b06:	8b 45 08             	mov    0x8(%ebp),%eax
  100b09:	0f b6 00             	movzbl (%eax),%eax
  100b0c:	84 c0                	test   %al,%al
  100b0e:	74 1d                	je     100b2d <parse+0xaf>
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	0f b6 00             	movzbl (%eax),%eax
  100b16:	0f be c0             	movsbl %al,%eax
  100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1d:	c7 04 24 bc 63 10 00 	movl   $0x1063bc,(%esp)
  100b24:	e8 0d 53 00 00       	call   105e36 <strchr>
  100b29:	85 c0                	test   %eax,%eax
  100b2b:	74 d5                	je     100b02 <parse+0x84>
            buf ++;
        }
    }
  100b2d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2e:	e9 66 ff ff ff       	jmp    100a99 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b36:	c9                   	leave  
  100b37:	c3                   	ret    

00100b38 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b38:	55                   	push   %ebp
  100b39:	89 e5                	mov    %esp,%ebp
  100b3b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b45:	8b 45 08             	mov    0x8(%ebp),%eax
  100b48:	89 04 24             	mov    %eax,(%esp)
  100b4b:	e8 2e ff ff ff       	call   100a7e <parse>
  100b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b57:	75 0a                	jne    100b63 <runcmd+0x2b>
        return 0;
  100b59:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5e:	e9 85 00 00 00       	jmp    100be8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6a:	eb 5c                	jmp    100bc8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b72:	89 d0                	mov    %edx,%eax
  100b74:	01 c0                	add    %eax,%eax
  100b76:	01 d0                	add    %edx,%eax
  100b78:	c1 e0 02             	shl    $0x2,%eax
  100b7b:	05 20 70 11 00       	add    $0x117020,%eax
  100b80:	8b 00                	mov    (%eax),%eax
  100b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b86:	89 04 24             	mov    %eax,(%esp)
  100b89:	e8 09 52 00 00       	call   105d97 <strcmp>
  100b8e:	85 c0                	test   %eax,%eax
  100b90:	75 32                	jne    100bc4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b95:	89 d0                	mov    %edx,%eax
  100b97:	01 c0                	add    %eax,%eax
  100b99:	01 d0                	add    %edx,%eax
  100b9b:	c1 e0 02             	shl    $0x2,%eax
  100b9e:	05 20 70 11 00       	add    $0x117020,%eax
  100ba3:	8b 40 08             	mov    0x8(%eax),%eax
  100ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba9:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb3:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb6:	83 c2 04             	add    $0x4,%edx
  100bb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbd:	89 0c 24             	mov    %ecx,(%esp)
  100bc0:	ff d0                	call   *%eax
  100bc2:	eb 24                	jmp    100be8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcb:	83 f8 02             	cmp    $0x2,%eax
  100bce:	76 9c                	jbe    100b6c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd7:	c7 04 24 df 63 10 00 	movl   $0x1063df,(%esp)
  100bde:	e8 59 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be8:	c9                   	leave  
  100be9:	c3                   	ret    

00100bea <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bea:	55                   	push   %ebp
  100beb:	89 e5                	mov    %esp,%ebp
  100bed:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf0:	c7 04 24 f8 63 10 00 	movl   $0x1063f8,(%esp)
  100bf7:	e8 40 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfc:	c7 04 24 20 64 10 00 	movl   $0x106420,(%esp)
  100c03:	e8 34 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0c:	74 0b                	je     100c19 <kmonitor+0x2f>
        print_trapframe(tf);
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 d7 0d 00 00       	call   1019f0 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c19:	c7 04 24 45 64 10 00 	movl   $0x106445,(%esp)
  100c20:	e8 0e f6 ff ff       	call   100233 <readline>
  100c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2c:	74 18                	je     100c46 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c38:	89 04 24             	mov    %eax,(%esp)
  100c3b:	e8 f8 fe ff ff       	call   100b38 <runcmd>
  100c40:	85 c0                	test   %eax,%eax
  100c42:	79 02                	jns    100c46 <kmonitor+0x5c>
                break;
  100c44:	eb 02                	jmp    100c48 <kmonitor+0x5e>
            }
        }
    }
  100c46:	eb d1                	jmp    100c19 <kmonitor+0x2f>
}
  100c48:	c9                   	leave  
  100c49:	c3                   	ret    

00100c4a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4a:	55                   	push   %ebp
  100c4b:	89 e5                	mov    %esp,%ebp
  100c4d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c57:	eb 3f                	jmp    100c98 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5c:	89 d0                	mov    %edx,%eax
  100c5e:	01 c0                	add    %eax,%eax
  100c60:	01 d0                	add    %edx,%eax
  100c62:	c1 e0 02             	shl    $0x2,%eax
  100c65:	05 20 70 11 00       	add    $0x117020,%eax
  100c6a:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c70:	89 d0                	mov    %edx,%eax
  100c72:	01 c0                	add    %eax,%eax
  100c74:	01 d0                	add    %edx,%eax
  100c76:	c1 e0 02             	shl    $0x2,%eax
  100c79:	05 20 70 11 00       	add    $0x117020,%eax
  100c7e:	8b 00                	mov    (%eax),%eax
  100c80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c88:	c7 04 24 49 64 10 00 	movl   $0x106449,(%esp)
  100c8f:	e8 a8 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9b:	83 f8 02             	cmp    $0x2,%eax
  100c9e:	76 b9                	jbe    100c59 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	c9                   	leave  
  100ca6:	c3                   	ret    

00100ca7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca7:	55                   	push   %ebp
  100ca8:	89 e5                	mov    %esp,%ebp
  100caa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cad:	e8 be fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb7:	c9                   	leave  
  100cb8:	c3                   	ret    

00100cb9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb9:	55                   	push   %ebp
  100cba:	89 e5                	mov    %esp,%ebp
  100cbc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cbf:	e8 f6 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc9:	c9                   	leave  
  100cca:	c3                   	ret    

00100ccb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccb:	55                   	push   %ebp
  100ccc:	89 e5                	mov    %esp,%ebp
  100cce:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  100cd6:	85 c0                	test   %eax,%eax
  100cd8:	74 02                	je     100cdc <__panic+0x11>
        goto panic_dead;
  100cda:	eb 48                	jmp    100d24 <__panic+0x59>
    }
    is_panic = 1;
  100cdc:	c7 05 80 7e 11 00 01 	movl   $0x1,0x117e80
  100ce3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce6:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cef:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfa:	c7 04 24 52 64 10 00 	movl   $0x106452,(%esp)
  100d01:	e8 36 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d10:	89 04 24             	mov    %eax,(%esp)
  100d13:	e8 f1 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d18:	c7 04 24 6e 64 10 00 	movl   $0x10646e,(%esp)
  100d1f:	e8 18 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d24:	e8 85 09 00 00       	call   1016ae <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d30:	e8 b5 fe ff ff       	call   100bea <kmonitor>
    }
  100d35:	eb f2                	jmp    100d29 <__panic+0x5e>

00100d37 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d37:	55                   	push   %ebp
  100d38:	89 e5                	mov    %esp,%ebp
  100d3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3d:	8d 45 14             	lea    0x14(%ebp),%eax
  100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d51:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  100d58:	e8 df f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d64:	8b 45 10             	mov    0x10(%ebp),%eax
  100d67:	89 04 24             	mov    %eax,(%esp)
  100d6a:	e8 9a f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6f:	c7 04 24 6e 64 10 00 	movl   $0x10646e,(%esp)
  100d76:	e8 c1 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7b:	c9                   	leave  
  100d7c:	c3                   	ret    

00100d7d <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7d:	55                   	push   %ebp
  100d7e:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d80:	a1 80 7e 11 00       	mov    0x117e80,%eax
}
  100d85:	5d                   	pop    %ebp
  100d86:	c3                   	ret    

00100d87 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d87:	55                   	push   %ebp
  100d88:	89 e5                	mov    %esp,%ebp
  100d8a:	83 ec 28             	sub    $0x28,%esp
  100d8d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d93:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d97:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9f:	ee                   	out    %al,(%dx)
  100da0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100daa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
  100db3:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db9:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc6:	c7 05 6c 89 11 00 00 	movl   $0x0,0x11896c
  100dcd:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd0:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  100dd7:	e8 60 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100ddc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de3:	e8 24 09 00 00       	call   10170c <pic_enable>
}
  100de8:	c9                   	leave  
  100de9:	c3                   	ret    

00100dea <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dea:	55                   	push   %ebp
  100deb:	89 e5                	mov    %esp,%ebp
  100ded:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df0:	9c                   	pushf  
  100df1:	58                   	pop    %eax
  100df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df8:	25 00 02 00 00       	and    $0x200,%eax
  100dfd:	85 c0                	test   %eax,%eax
  100dff:	74 0c                	je     100e0d <__intr_save+0x23>
        intr_disable();
  100e01:	e8 a8 08 00 00       	call   1016ae <intr_disable>
        return 1;
  100e06:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0b:	eb 05                	jmp    100e12 <__intr_save+0x28>
    }
    return 0;
  100e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e12:	c9                   	leave  
  100e13:	c3                   	ret    

00100e14 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e14:	55                   	push   %ebp
  100e15:	89 e5                	mov    %esp,%ebp
  100e17:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e1e:	74 05                	je     100e25 <__intr_restore+0x11>
        intr_enable();
  100e20:	e8 83 08 00 00       	call   1016a8 <intr_enable>
    }
}
  100e25:	c9                   	leave  
  100e26:	c3                   	ret    

00100e27 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e27:	55                   	push   %ebp
  100e28:	89 e5                	mov    %esp,%ebp
  100e2a:	83 ec 10             	sub    $0x10,%esp
  100e2d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e33:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e37:	89 c2                	mov    %eax,%edx
  100e39:	ec                   	in     (%dx),%al
  100e3a:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e43:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e47:	89 c2                	mov    %eax,%edx
  100e49:	ec                   	in     (%dx),%al
  100e4a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e53:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e57:	89 c2                	mov    %eax,%edx
  100e59:	ec                   	in     (%dx),%al
  100e5a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6d:	c9                   	leave  
  100e6e:	c3                   	ret    

00100e6f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6f:	55                   	push   %ebp
  100e70:	89 e5                	mov    %esp,%ebp
  100e72:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e75:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7f:	0f b7 00             	movzwl (%eax),%eax
  100e82:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e89:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e91:	0f b7 00             	movzwl (%eax),%eax
  100e94:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e98:	74 12                	je     100eac <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea1:	66 c7 05 a6 7e 11 00 	movw   $0x3b4,0x117ea6
  100ea8:	b4 03 
  100eaa:	eb 13                	jmp    100ebf <cga_init+0x50>
    } else {
        *cp = was;
  100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb6:	66 c7 05 a6 7e 11 00 	movw   $0x3d4,0x117ea6
  100ebd:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ebf:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  100ec6:	0f b7 c0             	movzwl %ax,%eax
  100ec9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eda:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  100ee1:	83 c0 01             	add    $0x1,%eax
  100ee4:	0f b7 c0             	movzwl %ax,%eax
  100ee7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eeb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eef:	89 c2                	mov    %eax,%edx
  100ef1:	ec                   	in     (%dx),%al
  100ef2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef9:	0f b6 c0             	movzbl %al,%eax
  100efc:	c1 e0 08             	shl    $0x8,%eax
  100eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f02:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  100f09:	0f b7 c0             	movzwl %ax,%eax
  100f0c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f10:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f14:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f18:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1d:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  100f24:	83 c0 01             	add    $0x1,%eax
  100f27:	0f b7 c0             	movzwl %ax,%eax
  100f2a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f32:	89 c2                	mov    %eax,%edx
  100f34:	ec                   	in     (%dx),%al
  100f35:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f38:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3c:	0f b6 c0             	movzbl %al,%eax
  100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f45:	a3 a0 7e 11 00       	mov    %eax,0x117ea0
    crt_pos = pos;
  100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4d:	66 a3 a4 7e 11 00    	mov    %ax,0x117ea4
}
  100f53:	c9                   	leave  
  100f54:	c3                   	ret    

00100f55 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f55:	55                   	push   %ebp
  100f56:	89 e5                	mov    %esp,%ebp
  100f58:	83 ec 48             	sub    $0x48,%esp
  100f5b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f61:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f65:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f69:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f74:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f80:	ee                   	out    %al,(%dx)
  100f81:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f87:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f9e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fad:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
  100fcd:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fdf:	ee                   	out    %al,(%dx)
  100fe0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff4:	3c ff                	cmp    $0xff,%al
  100ff6:	0f 95 c0             	setne  %al
  100ff9:	0f b6 c0             	movzbl %al,%eax
  100ffc:	a3 a8 7e 11 00       	mov    %eax,0x117ea8
  101001:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101007:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100b:	89 c2                	mov    %eax,%edx
  10100d:	ec                   	in     (%dx),%al
  10100e:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101011:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101017:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101b:	89 c2                	mov    %eax,%edx
  10101d:	ec                   	in     (%dx),%al
  10101e:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101021:	a1 a8 7e 11 00       	mov    0x117ea8,%eax
  101026:	85 c0                	test   %eax,%eax
  101028:	74 0c                	je     101036 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101031:	e8 d6 06 00 00       	call   10170c <pic_enable>
    }
}
  101036:	c9                   	leave  
  101037:	c3                   	ret    

00101038 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101038:	55                   	push   %ebp
  101039:	89 e5                	mov    %esp,%ebp
  10103b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101045:	eb 09                	jmp    101050 <lpt_putc_sub+0x18>
        delay();
  101047:	e8 db fd ff ff       	call   100e27 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101050:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101056:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105a:	89 c2                	mov    %eax,%edx
  10105c:	ec                   	in     (%dx),%al
  10105d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101060:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101064:	84 c0                	test   %al,%al
  101066:	78 09                	js     101071 <lpt_putc_sub+0x39>
  101068:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106f:	7e d6                	jle    101047 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101071:	8b 45 08             	mov    0x8(%ebp),%eax
  101074:	0f b6 c0             	movzbl %al,%eax
  101077:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101080:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101084:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101088:	ee                   	out    %al,(%dx)
  101089:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101093:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101097:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109b:	ee                   	out    %al,(%dx)
  10109c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a2:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ae:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010af:	c9                   	leave  
  1010b0:	c3                   	ret    

001010b1 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b1:	55                   	push   %ebp
  1010b2:	89 e5                	mov    %esp,%ebp
  1010b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bb:	74 0d                	je     1010ca <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c0:	89 04 24             	mov    %eax,(%esp)
  1010c3:	e8 70 ff ff ff       	call   101038 <lpt_putc_sub>
  1010c8:	eb 24                	jmp    1010ee <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d1:	e8 62 ff ff ff       	call   101038 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010dd:	e8 56 ff ff ff       	call   101038 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e9:	e8 4a ff ff ff       	call   101038 <lpt_putc_sub>
    }
}
  1010ee:	c9                   	leave  
  1010ef:	c3                   	ret    

001010f0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f0:	55                   	push   %ebp
  1010f1:	89 e5                	mov    %esp,%ebp
  1010f3:	53                   	push   %ebx
  1010f4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fa:	b0 00                	mov    $0x0,%al
  1010fc:	85 c0                	test   %eax,%eax
  1010fe:	75 07                	jne    101107 <cga_putc+0x17>
        c |= 0x0700;
  101100:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101107:	8b 45 08             	mov    0x8(%ebp),%eax
  10110a:	0f b6 c0             	movzbl %al,%eax
  10110d:	83 f8 0a             	cmp    $0xa,%eax
  101110:	74 4c                	je     10115e <cga_putc+0x6e>
  101112:	83 f8 0d             	cmp    $0xd,%eax
  101115:	74 57                	je     10116e <cga_putc+0x7e>
  101117:	83 f8 08             	cmp    $0x8,%eax
  10111a:	0f 85 88 00 00 00    	jne    1011a8 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101120:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  101127:	66 85 c0             	test   %ax,%ax
  10112a:	74 30                	je     10115c <cga_putc+0x6c>
            crt_pos --;
  10112c:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  101133:	83 e8 01             	sub    $0x1,%eax
  101136:	66 a3 a4 7e 11 00    	mov    %ax,0x117ea4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113c:	a1 a0 7e 11 00       	mov    0x117ea0,%eax
  101141:	0f b7 15 a4 7e 11 00 	movzwl 0x117ea4,%edx
  101148:	0f b7 d2             	movzwl %dx,%edx
  10114b:	01 d2                	add    %edx,%edx
  10114d:	01 c2                	add    %eax,%edx
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	b0 00                	mov    $0x0,%al
  101154:	83 c8 20             	or     $0x20,%eax
  101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115a:	eb 72                	jmp    1011ce <cga_putc+0xde>
  10115c:	eb 70                	jmp    1011ce <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10115e:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  101165:	83 c0 50             	add    $0x50,%eax
  101168:	66 a3 a4 7e 11 00    	mov    %ax,0x117ea4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10116e:	0f b7 1d a4 7e 11 00 	movzwl 0x117ea4,%ebx
  101175:	0f b7 0d a4 7e 11 00 	movzwl 0x117ea4,%ecx
  10117c:	0f b7 c1             	movzwl %cx,%eax
  10117f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101185:	c1 e8 10             	shr    $0x10,%eax
  101188:	89 c2                	mov    %eax,%edx
  10118a:	66 c1 ea 06          	shr    $0x6,%dx
  10118e:	89 d0                	mov    %edx,%eax
  101190:	c1 e0 02             	shl    $0x2,%eax
  101193:	01 d0                	add    %edx,%eax
  101195:	c1 e0 04             	shl    $0x4,%eax
  101198:	29 c1                	sub    %eax,%ecx
  10119a:	89 ca                	mov    %ecx,%edx
  10119c:	89 d8                	mov    %ebx,%eax
  10119e:	29 d0                	sub    %edx,%eax
  1011a0:	66 a3 a4 7e 11 00    	mov    %ax,0x117ea4
        break;
  1011a6:	eb 26                	jmp    1011ce <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a8:	8b 0d a0 7e 11 00    	mov    0x117ea0,%ecx
  1011ae:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  1011b5:	8d 50 01             	lea    0x1(%eax),%edx
  1011b8:	66 89 15 a4 7e 11 00 	mov    %dx,0x117ea4
  1011bf:	0f b7 c0             	movzwl %ax,%eax
  1011c2:	01 c0                	add    %eax,%eax
  1011c4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ca:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ce:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  1011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d9:	76 5b                	jbe    101236 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011db:	a1 a0 7e 11 00       	mov    0x117ea0,%eax
  1011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e6:	a1 a0 7e 11 00       	mov    0x117ea0,%eax
  1011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f2:	00 
  1011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f7:	89 04 24             	mov    %eax,(%esp)
  1011fa:	e8 35 4e 00 00       	call   106034 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101206:	eb 15                	jmp    10121d <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101208:	a1 a0 7e 11 00       	mov    0x117ea0,%eax
  10120d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101210:	01 d2                	add    %edx,%edx
  101212:	01 d0                	add    %edx,%eax
  101214:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101219:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101224:	7e e2                	jle    101208 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101226:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  10122d:	83 e8 50             	sub    $0x50,%eax
  101230:	66 a3 a4 7e 11 00    	mov    %ax,0x117ea4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101236:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  10123d:	0f b7 c0             	movzwl %ax,%eax
  101240:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101244:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101248:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101251:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  101258:	66 c1 e8 08          	shr    $0x8,%ax
  10125c:	0f b6 c0             	movzbl %al,%eax
  10125f:	0f b7 15 a6 7e 11 00 	movzwl 0x117ea6,%edx
  101266:	83 c2 01             	add    $0x1,%edx
  101269:	0f b7 d2             	movzwl %dx,%edx
  10126c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101270:	88 45 ed             	mov    %al,-0x13(%ebp)
  101273:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127c:	0f b7 05 a6 7e 11 00 	movzwl 0x117ea6,%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10128e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101292:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101296:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101297:	0f b7 05 a4 7e 11 00 	movzwl 0x117ea4,%eax
  10129e:	0f b6 c0             	movzbl %al,%eax
  1012a1:	0f b7 15 a6 7e 11 00 	movzwl 0x117ea6,%edx
  1012a8:	83 c2 01             	add    $0x1,%edx
  1012ab:	0f b7 d2             	movzwl %dx,%edx
  1012ae:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b2:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
}
  1012be:	83 c4 34             	add    $0x34,%esp
  1012c1:	5b                   	pop    %ebx
  1012c2:	5d                   	pop    %ebp
  1012c3:	c3                   	ret    

001012c4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c4:	55                   	push   %ebp
  1012c5:	89 e5                	mov    %esp,%ebp
  1012c7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d1:	eb 09                	jmp    1012dc <serial_putc_sub+0x18>
        delay();
  1012d3:	e8 4f fb ff ff       	call   100e27 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012dc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e6:	89 c2                	mov    %eax,%edx
  1012e8:	ec                   	in     (%dx),%al
  1012e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f0:	0f b6 c0             	movzbl %al,%eax
  1012f3:	83 e0 20             	and    $0x20,%eax
  1012f6:	85 c0                	test   %eax,%eax
  1012f8:	75 09                	jne    101303 <serial_putc_sub+0x3f>
  1012fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101301:	7e d0                	jle    1012d3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101303:	8b 45 08             	mov    0x8(%ebp),%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101312:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101316:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131a:	ee                   	out    %al,(%dx)
}
  10131b:	c9                   	leave  
  10131c:	c3                   	ret    

0010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101327:	74 0d                	je     101336 <serial_putc+0x19>
        serial_putc_sub(c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	89 04 24             	mov    %eax,(%esp)
  10132f:	e8 90 ff ff ff       	call   1012c4 <serial_putc_sub>
  101334:	eb 24                	jmp    10135a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133d:	e8 82 ff ff ff       	call   1012c4 <serial_putc_sub>
        serial_putc_sub(' ');
  101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101349:	e8 76 ff ff ff       	call   1012c4 <serial_putc_sub>
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 6a ff ff ff       	call   1012c4 <serial_putc_sub>
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101362:	eb 33                	jmp    101397 <cons_intr+0x3b>
        if (c != 0) {
  101364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101368:	74 2d                	je     101397 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136a:	a1 c4 80 11 00       	mov    0x1180c4,%eax
  10136f:	8d 50 01             	lea    0x1(%eax),%edx
  101372:	89 15 c4 80 11 00    	mov    %edx,0x1180c4
  101378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137b:	88 90 c0 7e 11 00    	mov    %dl,0x117ec0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101381:	a1 c4 80 11 00       	mov    0x1180c4,%eax
  101386:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138b:	75 0a                	jne    101397 <cons_intr+0x3b>
                cons.wpos = 0;
  10138d:	c7 05 c4 80 11 00 00 	movl   $0x0,0x1180c4
  101394:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101397:	8b 45 08             	mov    0x8(%ebp),%eax
  10139a:	ff d0                	call   *%eax
  10139c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a3:	75 bf                	jne    101364 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a5:	c9                   	leave  
  1013a6:	c3                   	ret    

001013a7 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a7:	55                   	push   %ebp
  1013a8:	89 e5                	mov    %esp,%ebp
  1013aa:	83 ec 10             	sub    $0x10,%esp
  1013ad:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b7:	89 c2                	mov    %eax,%edx
  1013b9:	ec                   	in     (%dx),%al
  1013ba:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c1:	0f b6 c0             	movzbl %al,%eax
  1013c4:	83 e0 01             	and    $0x1,%eax
  1013c7:	85 c0                	test   %eax,%eax
  1013c9:	75 07                	jne    1013d2 <serial_proc_data+0x2b>
        return -1;
  1013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d0:	eb 2a                	jmp    1013fc <serial_proc_data+0x55>
  1013d2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013dc:	89 c2                	mov    %eax,%edx
  1013de:	ec                   	in     (%dx),%al
  1013df:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e6:	0f b6 c0             	movzbl %al,%eax
  1013e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ec:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f0:	75 07                	jne    1013f9 <serial_proc_data+0x52>
        c = '\b';
  1013f2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fc:	c9                   	leave  
  1013fd:	c3                   	ret    

001013fe <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fe:	55                   	push   %ebp
  1013ff:	89 e5                	mov    %esp,%ebp
  101401:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101404:	a1 a8 7e 11 00       	mov    0x117ea8,%eax
  101409:	85 c0                	test   %eax,%eax
  10140b:	74 0c                	je     101419 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140d:	c7 04 24 a7 13 10 00 	movl   $0x1013a7,(%esp)
  101414:	e8 43 ff ff ff       	call   10135c <cons_intr>
    }
}
  101419:	c9                   	leave  
  10141a:	c3                   	ret    

0010141b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141b:	55                   	push   %ebp
  10141c:	89 e5                	mov    %esp,%ebp
  10141e:	83 ec 38             	sub    $0x38,%esp
  101421:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101427:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142b:	89 c2                	mov    %eax,%edx
  10142d:	ec                   	in     (%dx),%al
  10142e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101431:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101435:	0f b6 c0             	movzbl %al,%eax
  101438:	83 e0 01             	and    $0x1,%eax
  10143b:	85 c0                	test   %eax,%eax
  10143d:	75 0a                	jne    101449 <kbd_proc_data+0x2e>
        return -1;
  10143f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101444:	e9 59 01 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
  101449:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101453:	89 c2                	mov    %eax,%edx
  101455:	ec                   	in     (%dx),%al
  101456:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101459:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101460:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101464:	75 17                	jne    10147d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101466:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  10146b:	83 c8 40             	or     $0x40,%eax
  10146e:	a3 c8 80 11 00       	mov    %eax,0x1180c8
        return 0;
  101473:	b8 00 00 00 00       	mov    $0x0,%eax
  101478:	e9 25 01 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	84 c0                	test   %al,%al
  101483:	79 47                	jns    1014cc <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101485:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  10148a:	83 e0 40             	and    $0x40,%eax
  10148d:	85 c0                	test   %eax,%eax
  10148f:	75 09                	jne    10149a <kbd_proc_data+0x7f>
  101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101495:	83 e0 7f             	and    $0x7f,%eax
  101498:	eb 04                	jmp    10149e <kbd_proc_data+0x83>
  10149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a5:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ac:	83 c8 40             	or     $0x40,%eax
  1014af:	0f b6 c0             	movzbl %al,%eax
  1014b2:	f7 d0                	not    %eax
  1014b4:	89 c2                	mov    %eax,%edx
  1014b6:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  1014bb:	21 d0                	and    %edx,%eax
  1014bd:	a3 c8 80 11 00       	mov    %eax,0x1180c8
        return 0;
  1014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c7:	e9 d6 00 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014cc:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  1014d1:	83 e0 40             	and    $0x40,%eax
  1014d4:	85 c0                	test   %eax,%eax
  1014d6:	74 11                	je     1014e9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014dc:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  1014e1:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e4:	a3 c8 80 11 00       	mov    %eax,0x1180c8
    }

    shift |= shiftcode[data];
  1014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ed:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f4:	0f b6 d0             	movzbl %al,%edx
  1014f7:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  1014fc:	09 d0                	or     %edx,%eax
  1014fe:	a3 c8 80 11 00       	mov    %eax,0x1180c8
    shift ^= togglecode[data];
  101503:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101507:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10150e:	0f b6 d0             	movzbl %al,%edx
  101511:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  101516:	31 d0                	xor    %edx,%eax
  101518:	a3 c8 80 11 00       	mov    %eax,0x1180c8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151d:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  101522:	83 e0 03             	and    $0x3,%eax
  101525:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101530:	01 d0                	add    %edx,%eax
  101532:	0f b6 00             	movzbl (%eax),%eax
  101535:	0f b6 c0             	movzbl %al,%eax
  101538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153b:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  101540:	83 e0 08             	and    $0x8,%eax
  101543:	85 c0                	test   %eax,%eax
  101545:	74 22                	je     101569 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101547:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154b:	7e 0c                	jle    101559 <kbd_proc_data+0x13e>
  10154d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101551:	7f 06                	jg     101559 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101553:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101557:	eb 10                	jmp    101569 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101559:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155d:	7e 0a                	jle    101569 <kbd_proc_data+0x14e>
  10155f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101563:	7f 04                	jg     101569 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101565:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101569:	a1 c8 80 11 00       	mov    0x1180c8,%eax
  10156e:	f7 d0                	not    %eax
  101570:	83 e0 06             	and    $0x6,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	75 28                	jne    10159f <kbd_proc_data+0x184>
  101577:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157e:	75 1f                	jne    10159f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101580:	c7 04 24 a9 64 10 00 	movl   $0x1064a9,(%esp)
  101587:	e8 b0 ed ff ff       	call   10033c <cprintf>
  10158c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101592:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101596:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a2:	c9                   	leave  
  1015a3:	c3                   	ret    

001015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a4:	55                   	push   %ebp
  1015a5:	89 e5                	mov    %esp,%ebp
  1015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015aa:	c7 04 24 1b 14 10 00 	movl   $0x10141b,(%esp)
  1015b1:	e8 a6 fd ff ff       	call   10135c <cons_intr>
}
  1015b6:	c9                   	leave  
  1015b7:	c3                   	ret    

001015b8 <kbd_init>:

static void
kbd_init(void) {
  1015b8:	55                   	push   %ebp
  1015b9:	89 e5                	mov    %esp,%ebp
  1015bb:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015be:	e8 e1 ff ff ff       	call   1015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ca:	e8 3d 01 00 00       	call   10170c <pic_enable>
}
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d7:	e8 93 f8 ff ff       	call   100e6f <cga_init>
    serial_init();
  1015dc:	e8 74 f9 ff ff       	call   100f55 <serial_init>
    kbd_init();
  1015e1:	e8 d2 ff ff ff       	call   1015b8 <kbd_init>
    if (!serial_exists) {
  1015e6:	a1 a8 7e 11 00       	mov    0x117ea8,%eax
  1015eb:	85 c0                	test   %eax,%eax
  1015ed:	75 0c                	jne    1015fb <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ef:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  1015f6:	e8 41 ed ff ff       	call   10033c <cprintf>
    }
}
  1015fb:	c9                   	leave  
  1015fc:	c3                   	ret    

001015fd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fd:	55                   	push   %ebp
  1015fe:	89 e5                	mov    %esp,%ebp
  101600:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101603:	e8 e2 f7 ff ff       	call   100dea <__intr_save>
  101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160b:	8b 45 08             	mov    0x8(%ebp),%eax
  10160e:	89 04 24             	mov    %eax,(%esp)
  101611:	e8 9b fa ff ff       	call   1010b1 <lpt_putc>
        cga_putc(c);
  101616:	8b 45 08             	mov    0x8(%ebp),%eax
  101619:	89 04 24             	mov    %eax,(%esp)
  10161c:	e8 cf fa ff ff       	call   1010f0 <cga_putc>
        serial_putc(c);
  101621:	8b 45 08             	mov    0x8(%ebp),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 f1 fc ff ff       	call   10131d <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 dd f7 ff ff       	call   100e14 <__intr_restore>
}
  101637:	c9                   	leave  
  101638:	c3                   	ret    

00101639 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101646:	e8 9f f7 ff ff       	call   100dea <__intr_save>
  10164b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164e:	e8 ab fd ff ff       	call   1013fe <serial_intr>
        kbd_intr();
  101653:	e8 4c ff ff ff       	call   1015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101658:	8b 15 c0 80 11 00    	mov    0x1180c0,%edx
  10165e:	a1 c4 80 11 00       	mov    0x1180c4,%eax
  101663:	39 c2                	cmp    %eax,%edx
  101665:	74 31                	je     101698 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101667:	a1 c0 80 11 00       	mov    0x1180c0,%eax
  10166c:	8d 50 01             	lea    0x1(%eax),%edx
  10166f:	89 15 c0 80 11 00    	mov    %edx,0x1180c0
  101675:	0f b6 80 c0 7e 11 00 	movzbl 0x117ec0(%eax),%eax
  10167c:	0f b6 c0             	movzbl %al,%eax
  10167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101682:	a1 c0 80 11 00       	mov    0x1180c0,%eax
  101687:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168c:	75 0a                	jne    101698 <cons_getc+0x5f>
                cons.rpos = 0;
  10168e:	c7 05 c0 80 11 00 00 	movl   $0x0,0x1180c0
  101695:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169b:	89 04 24             	mov    %eax,(%esp)
  10169e:	e8 71 f7 ff ff       	call   100e14 <__intr_restore>
    return c;
  1016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a6:	c9                   	leave  
  1016a7:	c3                   	ret    

001016a8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a8:	55                   	push   %ebp
  1016a9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ab:	fb                   	sti    
    sti();
}
  1016ac:	5d                   	pop    %ebp
  1016ad:	c3                   	ret    

001016ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b1:	fa                   	cli    
    cli();
}
  1016b2:	5d                   	pop    %ebp
  1016b3:	c3                   	ret    

001016b4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
  1016b7:	83 ec 14             	sub    $0x14,%esp
  1016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c5:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cb:	a1 cc 80 11 00       	mov    0x1180cc,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	74 36                	je     10170a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d8:	0f b6 c0             	movzbl %al,%eax
  1016db:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ec:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f1:	66 c1 e8 08          	shr    $0x8,%ax
  1016f5:	0f b6 c0             	movzbl %al,%eax
  1016f8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016fe:	88 45 f9             	mov    %al,-0x7(%ebp)
  101701:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101705:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101709:	ee                   	out    %al,(%dx)
    }
}
  10170a:	c9                   	leave  
  10170b:	c3                   	ret    

0010170c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170c:	55                   	push   %ebp
  10170d:	89 e5                	mov    %esp,%ebp
  10170f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101712:	8b 45 08             	mov    0x8(%ebp),%eax
  101715:	ba 01 00 00 00       	mov    $0x1,%edx
  10171a:	89 c1                	mov    %eax,%ecx
  10171c:	d3 e2                	shl    %cl,%edx
  10171e:	89 d0                	mov    %edx,%eax
  101720:	f7 d0                	not    %eax
  101722:	89 c2                	mov    %eax,%edx
  101724:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172b:	21 d0                	and    %edx,%eax
  10172d:	0f b7 c0             	movzwl %ax,%eax
  101730:	89 04 24             	mov    %eax,(%esp)
  101733:	e8 7c ff ff ff       	call   1016b4 <pic_setmask>
}
  101738:	c9                   	leave  
  101739:	c3                   	ret    

0010173a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173a:	55                   	push   %ebp
  10173b:	89 e5                	mov    %esp,%ebp
  10173d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101740:	c7 05 cc 80 11 00 01 	movl   $0x1,0x1180cc
  101747:	00 00 00 
  10174a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101750:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101754:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101758:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175c:	ee                   	out    %al,(%dx)
  10175d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101763:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
  101770:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101776:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101789:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101791:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017af:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
  1017bc:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
  1017cf:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017dd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e1:	ee                   	out    %al,(%dx)
  1017e2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ec:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f4:	ee                   	out    %al,(%dx)
  1017f5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fb:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101803:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
  101808:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101812:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101816:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
  10181b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101821:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101825:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101829:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
  10182e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101834:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101838:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
  101841:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101847:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101854:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185b:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185f:	74 12                	je     101873 <pic_init+0x139>
        pic_setmask(irq_mask);
  101861:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101868:	0f b7 c0             	movzwl %ax,%eax
  10186b:	89 04 24             	mov    %eax,(%esp)
  10186e:	e8 41 fe ff ff       	call   1016b4 <pic_setmask>
    }
}
  101873:	c9                   	leave  
  101874:	c3                   	ret    

00101875 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101875:	55                   	push   %ebp
  101876:	89 e5                	mov    %esp,%ebp
  101878:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101882:	00 
  101883:	c7 04 24 e0 64 10 00 	movl   $0x1064e0,(%esp)
  10188a:	e8 ad ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188f:	c7 04 24 ea 64 10 00 	movl   $0x1064ea,(%esp)
  101896:	e8 a1 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  10189b:	c7 44 24 08 f8 64 10 	movl   $0x1064f8,0x8(%esp)
  1018a2:	00 
  1018a3:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018aa:	00 
  1018ab:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  1018b2:	e8 14 f4 ff ff       	call   100ccb <__panic>

001018b7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b7:	55                   	push   %ebp
  1018b8:	89 e5                	mov    %esp,%ebp
  1018ba:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c4:	e9 c3 00 00 00       	jmp    10198c <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cc:	8b 04 85 04 76 11 00 	mov    0x117604(,%eax,4),%eax
  1018d3:	89 c2                	mov    %eax,%edx
  1018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d8:	66 89 14 c5 e0 80 11 	mov    %dx,0x1180e0(,%eax,8)
  1018df:	00 
  1018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e3:	66 c7 04 c5 e2 80 11 	movw   $0x8,0x1180e2(,%eax,8)
  1018ea:	00 08 00 
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	0f b6 14 c5 e4 80 11 	movzbl 0x1180e4(,%eax,8),%edx
  1018f7:	00 
  1018f8:	83 e2 e0             	and    $0xffffffe0,%edx
  1018fb:	88 14 c5 e4 80 11 00 	mov    %dl,0x1180e4(,%eax,8)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	0f b6 14 c5 e4 80 11 	movzbl 0x1180e4(,%eax,8),%edx
  10190c:	00 
  10190d:	83 e2 1f             	and    $0x1f,%edx
  101910:	88 14 c5 e4 80 11 00 	mov    %dl,0x1180e4(,%eax,8)
  101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191a:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  101921:	00 
  101922:	83 e2 f0             	and    $0xfffffff0,%edx
  101925:	83 ca 0e             	or     $0xe,%edx
  101928:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  10192f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101932:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  101939:	00 
  10193a:	83 e2 ef             	and    $0xffffffef,%edx
  10193d:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  101944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101947:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  10194e:	00 
  10194f:	83 e2 9f             	and    $0xffffff9f,%edx
  101952:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  101959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195c:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  101963:	00 
  101964:	83 ca 80             	or     $0xffffff80,%edx
  101967:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  10196e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101971:	8b 04 85 04 76 11 00 	mov    0x117604(,%eax,4),%eax
  101978:	c1 e8 10             	shr    $0x10,%eax
  10197b:	89 c2                	mov    %eax,%edx
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	66 89 14 c5 e6 80 11 	mov    %dx,0x1180e6(,%eax,8)
  101987:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101988:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101994:	0f 86 2f ff ff ff    	jbe    1018c9 <idt_init+0x12>
  10199a:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a4:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// load the IDT
    lidt(&idt_pd);
}
  1019a7:	c9                   	leave  
  1019a8:	c3                   	ret    

001019a9 <trapname>:

static const char *
trapname(int trapno) {
  1019a9:	55                   	push   %ebp
  1019aa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1019af:	83 f8 13             	cmp    $0x13,%eax
  1019b2:	77 0c                	ja     1019c0 <trapname+0x17>
        return excnames[trapno];
  1019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b7:	8b 04 85 80 68 10 00 	mov    0x106880(,%eax,4),%eax
  1019be:	eb 18                	jmp    1019d8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c4:	7e 0d                	jle    1019d3 <trapname+0x2a>
  1019c6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ca:	7f 07                	jg     1019d3 <trapname+0x2a>
        return "Hardware Interrupt";
  1019cc:	b8 1f 65 10 00       	mov    $0x10651f,%eax
  1019d1:	eb 05                	jmp    1019d8 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d3:	b8 32 65 10 00       	mov    $0x106532,%eax
}
  1019d8:	5d                   	pop    %ebp
  1019d9:	c3                   	ret    

001019da <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019da:	55                   	push   %ebp
  1019db:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e4:	66 83 f8 08          	cmp    $0x8,%ax
  1019e8:	0f 94 c0             	sete   %al
  1019eb:	0f b6 c0             	movzbl %al,%eax
}
  1019ee:	5d                   	pop    %ebp
  1019ef:	c3                   	ret    

001019f0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f0:	55                   	push   %ebp
  1019f1:	89 e5                	mov    %esp,%ebp
  1019f3:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fd:	c7 04 24 73 65 10 00 	movl   $0x106573,(%esp)
  101a04:	e8 33 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	89 04 24             	mov    %eax,(%esp)
  101a0f:	e8 a1 01 00 00       	call   101bb5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a14:	8b 45 08             	mov    0x8(%ebp),%eax
  101a17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a1b:	0f b7 c0             	movzwl %ax,%eax
  101a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a22:	c7 04 24 84 65 10 00 	movl   $0x106584,(%esp)
  101a29:	e8 0e e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a31:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a35:	0f b7 c0             	movzwl %ax,%eax
  101a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3c:	c7 04 24 97 65 10 00 	movl   $0x106597,(%esp)
  101a43:	e8 f4 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4f:	0f b7 c0             	movzwl %ax,%eax
  101a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a56:	c7 04 24 aa 65 10 00 	movl   $0x1065aa,(%esp)
  101a5d:	e8 da e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a69:	0f b7 c0             	movzwl %ax,%eax
  101a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a70:	c7 04 24 bd 65 10 00 	movl   $0x1065bd,(%esp)
  101a77:	e8 c0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7f:	8b 40 30             	mov    0x30(%eax),%eax
  101a82:	89 04 24             	mov    %eax,(%esp)
  101a85:	e8 1f ff ff ff       	call   1019a9 <trapname>
  101a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  101a8d:	8b 52 30             	mov    0x30(%edx),%edx
  101a90:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a94:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a98:	c7 04 24 d0 65 10 00 	movl   $0x1065d0,(%esp)
  101a9f:	e8 98 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa7:	8b 40 34             	mov    0x34(%eax),%eax
  101aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aae:	c7 04 24 e2 65 10 00 	movl   $0x1065e2,(%esp)
  101ab5:	e8 82 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101aba:	8b 45 08             	mov    0x8(%ebp),%eax
  101abd:	8b 40 38             	mov    0x38(%eax),%eax
  101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac4:	c7 04 24 f1 65 10 00 	movl   $0x1065f1,(%esp)
  101acb:	e8 6c e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad7:	0f b7 c0             	movzwl %ax,%eax
  101ada:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ade:	c7 04 24 00 66 10 00 	movl   $0x106600,(%esp)
  101ae5:	e8 52 e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	8b 40 40             	mov    0x40(%eax),%eax
  101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af4:	c7 04 24 13 66 10 00 	movl   $0x106613,(%esp)
  101afb:	e8 3c e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b07:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b0e:	eb 3e                	jmp    101b4e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	8b 50 40             	mov    0x40(%eax),%edx
  101b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b19:	21 d0                	and    %edx,%eax
  101b1b:	85 c0                	test   %eax,%eax
  101b1d:	74 28                	je     101b47 <print_trapframe+0x157>
  101b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b22:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b29:	85 c0                	test   %eax,%eax
  101b2b:	74 1a                	je     101b47 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b30:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3b:	c7 04 24 22 66 10 00 	movl   $0x106622,(%esp)
  101b42:	e8 f5 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b4b:	d1 65 f0             	shll   -0x10(%ebp)
  101b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b51:	83 f8 17             	cmp    $0x17,%eax
  101b54:	76 ba                	jbe    101b10 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b56:	8b 45 08             	mov    0x8(%ebp),%eax
  101b59:	8b 40 40             	mov    0x40(%eax),%eax
  101b5c:	25 00 30 00 00       	and    $0x3000,%eax
  101b61:	c1 e8 0c             	shr    $0xc,%eax
  101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b68:	c7 04 24 26 66 10 00 	movl   $0x106626,(%esp)
  101b6f:	e8 c8 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b74:	8b 45 08             	mov    0x8(%ebp),%eax
  101b77:	89 04 24             	mov    %eax,(%esp)
  101b7a:	e8 5b fe ff ff       	call   1019da <trap_in_kernel>
  101b7f:	85 c0                	test   %eax,%eax
  101b81:	75 30                	jne    101bb3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b83:	8b 45 08             	mov    0x8(%ebp),%eax
  101b86:	8b 40 44             	mov    0x44(%eax),%eax
  101b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8d:	c7 04 24 2f 66 10 00 	movl   $0x10662f,(%esp)
  101b94:	e8 a3 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b99:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba0:	0f b7 c0             	movzwl %ax,%eax
  101ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba7:	c7 04 24 3e 66 10 00 	movl   $0x10663e,(%esp)
  101bae:	e8 89 e7 ff ff       	call   10033c <cprintf>
    }
}
  101bb3:	c9                   	leave  
  101bb4:	c3                   	ret    

00101bb5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb5:	55                   	push   %ebp
  101bb6:	89 e5                	mov    %esp,%ebp
  101bb8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 00                	mov    (%eax),%eax
  101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc4:	c7 04 24 51 66 10 00 	movl   $0x106651,(%esp)
  101bcb:	e8 6c e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd3:	8b 40 04             	mov    0x4(%eax),%eax
  101bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bda:	c7 04 24 60 66 10 00 	movl   $0x106660,(%esp)
  101be1:	e8 56 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be6:	8b 45 08             	mov    0x8(%ebp),%eax
  101be9:	8b 40 08             	mov    0x8(%eax),%eax
  101bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf0:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  101bf7:	e8 40 e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bff:	8b 40 0c             	mov    0xc(%eax),%eax
  101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c06:	c7 04 24 7e 66 10 00 	movl   $0x10667e,(%esp)
  101c0d:	e8 2a e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	8b 40 10             	mov    0x10(%eax),%eax
  101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1c:	c7 04 24 8d 66 10 00 	movl   $0x10668d,(%esp)
  101c23:	e8 14 e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 14             	mov    0x14(%eax),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 9c 66 10 00 	movl   $0x10669c,(%esp)
  101c39:	e8 fe e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c41:	8b 40 18             	mov    0x18(%eax),%eax
  101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c48:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  101c4f:	e8 e8 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c54:	8b 45 08             	mov    0x8(%ebp),%eax
  101c57:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5e:	c7 04 24 ba 66 10 00 	movl   $0x1066ba,(%esp)
  101c65:	e8 d2 e6 ff ff       	call   10033c <cprintf>
}
  101c6a:	c9                   	leave  
  101c6b:	c3                   	ret    

00101c6c <print_tmode_info>:
#define T_MODE_TICK		1
#define T_MODE_KEY		2
static int tmode = T_MODE_TICK;

static void print_tmode_info()
{
  101c6c:	55                   	push   %ebp
  101c6d:	89 e5                	mov    %esp,%ebp
  101c6f:	83 ec 18             	sub    $0x18,%esp
	cprintf("Change mode:\n");
  101c72:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  101c79:	e8 be e6 ff ff       	call   10033c <cprintf>
	cprintf("1:tick\n");
  101c7e:	c7 04 24 d7 66 10 00 	movl   $0x1066d7,(%esp)
  101c85:	e8 b2 e6 ff ff       	call   10033c <cprintf>
	cprintf("2:keypress\n");
  101c8a:	c7 04 24 df 66 10 00 	movl   $0x1066df,(%esp)
  101c91:	e8 a6 e6 ff ff       	call   10033c <cprintf>
}
  101c96:	c9                   	leave  
  101c97:	c3                   	ret    

00101c98 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c98:	55                   	push   %ebp
  101c99:	89 e5                	mov    %esp,%ebp
  101c9b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca1:	8b 40 30             	mov    0x30(%eax),%eax
  101ca4:	83 f8 2f             	cmp    $0x2f,%eax
  101ca7:	77 21                	ja     101cca <trap_dispatch+0x32>
  101ca9:	83 f8 2e             	cmp    $0x2e,%eax
  101cac:	0f 83 9a 01 00 00    	jae    101e4c <trap_dispatch+0x1b4>
  101cb2:	83 f8 21             	cmp    $0x21,%eax
  101cb5:	0f 84 9e 00 00 00    	je     101d59 <trap_dispatch+0xc1>
  101cbb:	83 f8 24             	cmp    $0x24,%eax
  101cbe:	74 70                	je     101d30 <trap_dispatch+0x98>
  101cc0:	83 f8 20             	cmp    $0x20,%eax
  101cc3:	74 16                	je     101cdb <trap_dispatch+0x43>
  101cc5:	e9 4a 01 00 00       	jmp    101e14 <trap_dispatch+0x17c>
  101cca:	83 e8 78             	sub    $0x78,%eax
  101ccd:	83 f8 01             	cmp    $0x1,%eax
  101cd0:	0f 87 3e 01 00 00    	ja     101e14 <trap_dispatch+0x17c>
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101cd6:	e9 71 01 00 00       	jmp    101e4c <trap_dispatch+0x1b4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
  101cdb:	a1 6c 89 11 00       	mov    0x11896c,%eax
  101ce0:	83 c0 01             	add    $0x1,%eax
  101ce3:	a3 6c 89 11 00       	mov    %eax,0x11896c
		if (tmode == T_MODE_TICK)
  101ce8:	a1 00 76 11 00       	mov    0x117600,%eax
  101ced:	83 f8 01             	cmp    $0x1,%eax
  101cf0:	75 39                	jne    101d2b <trap_dispatch+0x93>
		{
			if (ticks % TICK_NUM == 0)
  101cf2:	8b 0d 6c 89 11 00    	mov    0x11896c,%ecx
  101cf8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cfd:	89 c8                	mov    %ecx,%eax
  101cff:	f7 e2                	mul    %edx
  101d01:	89 d0                	mov    %edx,%eax
  101d03:	c1 e8 05             	shr    $0x5,%eax
  101d06:	6b c0 64             	imul   $0x64,%eax,%eax
  101d09:	29 c1                	sub    %eax,%ecx
  101d0b:	89 c8                	mov    %ecx,%eax
  101d0d:	85 c0                	test   %eax,%eax
  101d0f:	75 1a                	jne    101d2b <trap_dispatch+0x93>
				cprintf("%d ticks\n", ticks);
  101d11:	a1 6c 89 11 00       	mov    0x11896c,%eax
  101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1a:	c7 04 24 e0 64 10 00 	movl   $0x1064e0,(%esp)
  101d21:	e8 16 e6 ff ff       	call   10033c <cprintf>
		}
        break;
  101d26:	e9 22 01 00 00       	jmp    101e4d <trap_dispatch+0x1b5>
  101d2b:	e9 1d 01 00 00       	jmp    101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d30:	e8 04 f9 ff ff       	call   101639 <cons_getc>
  101d35:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d38:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d3c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d40:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d48:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  101d4f:	e8 e8 e5 ff ff       	call   10033c <cprintf>
        break;
  101d54:	e9 f4 00 00 00       	jmp    101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d59:	e8 db f8 ff ff       	call   101639 <cons_getc>
  101d5e:	88 45 f7             	mov    %al,-0x9(%ebp)
		if (c == 0)
  101d61:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  101d65:	75 05                	jne    101d6c <trap_dispatch+0xd4>
			break;
  101d67:	e9 e1 00 00 00       	jmp    101e4d <trap_dispatch+0x1b5>

		if (c == 19 && tmode != T_MODE_SEL)
  101d6c:	80 7d f7 13          	cmpb   $0x13,-0x9(%ebp)
  101d70:	75 1d                	jne    101d8f <trap_dispatch+0xf7>
  101d72:	a1 00 76 11 00       	mov    0x117600,%eax
  101d77:	85 c0                	test   %eax,%eax
  101d79:	74 14                	je     101d8f <trap_dispatch+0xf7>
		{
			tmode = T_MODE_SEL;
  101d7b:	c7 05 00 76 11 00 00 	movl   $0x0,0x117600
  101d82:	00 00 00 
			print_tmode_info();
  101d85:	e8 e2 fe ff ff       	call   101c6c <print_tmode_info>
			break;
  101d8a:	e9 be 00 00 00       	jmp    101e4d <trap_dispatch+0x1b5>
		}

		if (tmode == T_MODE_KEY)
  101d8f:	a1 00 76 11 00       	mov    0x117600,%eax
  101d94:	83 f8 02             	cmp    $0x2,%eax
  101d97:	75 16                	jne    101daf <trap_dispatch+0x117>
		{
        	cprintf("%c", c);
  101d99:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da1:	c7 04 24 fd 66 10 00 	movl   $0x1066fd,(%esp)
  101da8:	e8 8f e5 ff ff       	call   10033c <cprintf>
  101dad:	eb 63                	jmp    101e12 <trap_dispatch+0x17a>
		}
		else if (tmode == T_MODE_SEL)
  101daf:	a1 00 76 11 00       	mov    0x117600,%eax
  101db4:	85 c0                	test   %eax,%eax
  101db6:	75 5a                	jne    101e12 <trap_dispatch+0x17a>
		{
			switch (c)
  101db8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dbc:	83 f8 31             	cmp    $0x31,%eax
  101dbf:	74 07                	je     101dc8 <trap_dispatch+0x130>
  101dc1:	83 f8 32             	cmp    $0x32,%eax
  101dc4:	74 1a                	je     101de0 <trap_dispatch+0x148>
  101dc6:	eb 30                	jmp    101df8 <trap_dispatch+0x160>
			{
				case '1': tmode = T_MODE_TICK; cprintf("\n"); break;
  101dc8:	c7 05 00 76 11 00 01 	movl   $0x1,0x117600
  101dcf:	00 00 00 
  101dd2:	c7 04 24 00 67 10 00 	movl   $0x106700,(%esp)
  101dd9:	e8 5e e5 ff ff       	call   10033c <cprintf>
  101dde:	eb 32                	jmp    101e12 <trap_dispatch+0x17a>
				case '2': tmode = T_MODE_KEY; cprintf("\n"); break;
  101de0:	c7 05 00 76 11 00 02 	movl   $0x2,0x117600
  101de7:	00 00 00 
  101dea:	c7 04 24 00 67 10 00 	movl   $0x106700,(%esp)
  101df1:	e8 46 e5 ff ff       	call   10033c <cprintf>
  101df6:	eb 1a                	jmp    101e12 <trap_dispatch+0x17a>
				default:
					cprintf("%c is not valid.", c);
  101df8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e00:	c7 04 24 02 67 10 00 	movl   $0x106702,(%esp)
  101e07:	e8 30 e5 ff ff       	call   10033c <cprintf>
					print_tmode_info();
  101e0c:	e8 5b fe ff ff       	call   101c6c <print_tmode_info>
					break;
  101e11:	90                   	nop
			}
		}
        break;
  101e12:	eb 39                	jmp    101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e1b:	0f b7 c0             	movzwl %ax,%eax
  101e1e:	83 e0 03             	and    $0x3,%eax
  101e21:	85 c0                	test   %eax,%eax
  101e23:	75 28                	jne    101e4d <trap_dispatch+0x1b5>
            print_trapframe(tf);
  101e25:	8b 45 08             	mov    0x8(%ebp),%eax
  101e28:	89 04 24             	mov    %eax,(%esp)
  101e2b:	e8 c0 fb ff ff       	call   1019f0 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e30:	c7 44 24 08 13 67 10 	movl   $0x106713,0x8(%esp)
  101e37:	00 
  101e38:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  101e3f:	00 
  101e40:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  101e47:	e8 7f ee ff ff       	call   100ccb <__panic>
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e4c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e4d:	c9                   	leave  
  101e4e:	c3                   	ret    

00101e4f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e4f:	55                   	push   %ebp
  101e50:	89 e5                	mov    %esp,%ebp
  101e52:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e55:	8b 45 08             	mov    0x8(%ebp),%eax
  101e58:	89 04 24             	mov    %eax,(%esp)
  101e5b:	e8 38 fe ff ff       	call   101c98 <trap_dispatch>
}
  101e60:	c9                   	leave  
  101e61:	c3                   	ret    

00101e62 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e62:	1e                   	push   %ds
    pushl %es
  101e63:	06                   	push   %es
    pushl %fs
  101e64:	0f a0                	push   %fs
    pushl %gs
  101e66:	0f a8                	push   %gs
    pushal
  101e68:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e69:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e6e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e70:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e72:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e73:	e8 d7 ff ff ff       	call   101e4f <trap>

    # pop the pushed stack pointer
    popl %esp
  101e78:	5c                   	pop    %esp

00101e79 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e79:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e7a:	0f a9                	pop    %gs
    popl %fs
  101e7c:	0f a1                	pop    %fs
    popl %es
  101e7e:	07                   	pop    %es
    popl %ds
  101e7f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e80:	83 c4 08             	add    $0x8,%esp
    iret
  101e83:	cf                   	iret   

00101e84 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $0
  101e86:	6a 00                	push   $0x0
  jmp __alltraps
  101e88:	e9 d5 ff ff ff       	jmp    101e62 <__alltraps>

00101e8d <vector1>:
.globl vector1
vector1:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $1
  101e8f:	6a 01                	push   $0x1
  jmp __alltraps
  101e91:	e9 cc ff ff ff       	jmp    101e62 <__alltraps>

00101e96 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $2
  101e98:	6a 02                	push   $0x2
  jmp __alltraps
  101e9a:	e9 c3 ff ff ff       	jmp    101e62 <__alltraps>

00101e9f <vector3>:
.globl vector3
vector3:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $3
  101ea1:	6a 03                	push   $0x3
  jmp __alltraps
  101ea3:	e9 ba ff ff ff       	jmp    101e62 <__alltraps>

00101ea8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $4
  101eaa:	6a 04                	push   $0x4
  jmp __alltraps
  101eac:	e9 b1 ff ff ff       	jmp    101e62 <__alltraps>

00101eb1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $5
  101eb3:	6a 05                	push   $0x5
  jmp __alltraps
  101eb5:	e9 a8 ff ff ff       	jmp    101e62 <__alltraps>

00101eba <vector6>:
.globl vector6
vector6:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $6
  101ebc:	6a 06                	push   $0x6
  jmp __alltraps
  101ebe:	e9 9f ff ff ff       	jmp    101e62 <__alltraps>

00101ec3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $7
  101ec5:	6a 07                	push   $0x7
  jmp __alltraps
  101ec7:	e9 96 ff ff ff       	jmp    101e62 <__alltraps>

00101ecc <vector8>:
.globl vector8
vector8:
  pushl $8
  101ecc:	6a 08                	push   $0x8
  jmp __alltraps
  101ece:	e9 8f ff ff ff       	jmp    101e62 <__alltraps>

00101ed3 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ed3:	6a 09                	push   $0x9
  jmp __alltraps
  101ed5:	e9 88 ff ff ff       	jmp    101e62 <__alltraps>

00101eda <vector10>:
.globl vector10
vector10:
  pushl $10
  101eda:	6a 0a                	push   $0xa
  jmp __alltraps
  101edc:	e9 81 ff ff ff       	jmp    101e62 <__alltraps>

00101ee1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ee1:	6a 0b                	push   $0xb
  jmp __alltraps
  101ee3:	e9 7a ff ff ff       	jmp    101e62 <__alltraps>

00101ee8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ee8:	6a 0c                	push   $0xc
  jmp __alltraps
  101eea:	e9 73 ff ff ff       	jmp    101e62 <__alltraps>

00101eef <vector13>:
.globl vector13
vector13:
  pushl $13
  101eef:	6a 0d                	push   $0xd
  jmp __alltraps
  101ef1:	e9 6c ff ff ff       	jmp    101e62 <__alltraps>

00101ef6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ef6:	6a 0e                	push   $0xe
  jmp __alltraps
  101ef8:	e9 65 ff ff ff       	jmp    101e62 <__alltraps>

00101efd <vector15>:
.globl vector15
vector15:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $15
  101eff:	6a 0f                	push   $0xf
  jmp __alltraps
  101f01:	e9 5c ff ff ff       	jmp    101e62 <__alltraps>

00101f06 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $16
  101f08:	6a 10                	push   $0x10
  jmp __alltraps
  101f0a:	e9 53 ff ff ff       	jmp    101e62 <__alltraps>

00101f0f <vector17>:
.globl vector17
vector17:
  pushl $17
  101f0f:	6a 11                	push   $0x11
  jmp __alltraps
  101f11:	e9 4c ff ff ff       	jmp    101e62 <__alltraps>

00101f16 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $18
  101f18:	6a 12                	push   $0x12
  jmp __alltraps
  101f1a:	e9 43 ff ff ff       	jmp    101e62 <__alltraps>

00101f1f <vector19>:
.globl vector19
vector19:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $19
  101f21:	6a 13                	push   $0x13
  jmp __alltraps
  101f23:	e9 3a ff ff ff       	jmp    101e62 <__alltraps>

00101f28 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $20
  101f2a:	6a 14                	push   $0x14
  jmp __alltraps
  101f2c:	e9 31 ff ff ff       	jmp    101e62 <__alltraps>

00101f31 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $21
  101f33:	6a 15                	push   $0x15
  jmp __alltraps
  101f35:	e9 28 ff ff ff       	jmp    101e62 <__alltraps>

00101f3a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $22
  101f3c:	6a 16                	push   $0x16
  jmp __alltraps
  101f3e:	e9 1f ff ff ff       	jmp    101e62 <__alltraps>

00101f43 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $23
  101f45:	6a 17                	push   $0x17
  jmp __alltraps
  101f47:	e9 16 ff ff ff       	jmp    101e62 <__alltraps>

00101f4c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $24
  101f4e:	6a 18                	push   $0x18
  jmp __alltraps
  101f50:	e9 0d ff ff ff       	jmp    101e62 <__alltraps>

00101f55 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $25
  101f57:	6a 19                	push   $0x19
  jmp __alltraps
  101f59:	e9 04 ff ff ff       	jmp    101e62 <__alltraps>

00101f5e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $26
  101f60:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f62:	e9 fb fe ff ff       	jmp    101e62 <__alltraps>

00101f67 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $27
  101f69:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f6b:	e9 f2 fe ff ff       	jmp    101e62 <__alltraps>

00101f70 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $28
  101f72:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f74:	e9 e9 fe ff ff       	jmp    101e62 <__alltraps>

00101f79 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $29
  101f7b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f7d:	e9 e0 fe ff ff       	jmp    101e62 <__alltraps>

00101f82 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $30
  101f84:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f86:	e9 d7 fe ff ff       	jmp    101e62 <__alltraps>

00101f8b <vector31>:
.globl vector31
vector31:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $31
  101f8d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f8f:	e9 ce fe ff ff       	jmp    101e62 <__alltraps>

00101f94 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $32
  101f96:	6a 20                	push   $0x20
  jmp __alltraps
  101f98:	e9 c5 fe ff ff       	jmp    101e62 <__alltraps>

00101f9d <vector33>:
.globl vector33
vector33:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $33
  101f9f:	6a 21                	push   $0x21
  jmp __alltraps
  101fa1:	e9 bc fe ff ff       	jmp    101e62 <__alltraps>

00101fa6 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $34
  101fa8:	6a 22                	push   $0x22
  jmp __alltraps
  101faa:	e9 b3 fe ff ff       	jmp    101e62 <__alltraps>

00101faf <vector35>:
.globl vector35
vector35:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $35
  101fb1:	6a 23                	push   $0x23
  jmp __alltraps
  101fb3:	e9 aa fe ff ff       	jmp    101e62 <__alltraps>

00101fb8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $36
  101fba:	6a 24                	push   $0x24
  jmp __alltraps
  101fbc:	e9 a1 fe ff ff       	jmp    101e62 <__alltraps>

00101fc1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $37
  101fc3:	6a 25                	push   $0x25
  jmp __alltraps
  101fc5:	e9 98 fe ff ff       	jmp    101e62 <__alltraps>

00101fca <vector38>:
.globl vector38
vector38:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $38
  101fcc:	6a 26                	push   $0x26
  jmp __alltraps
  101fce:	e9 8f fe ff ff       	jmp    101e62 <__alltraps>

00101fd3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $39
  101fd5:	6a 27                	push   $0x27
  jmp __alltraps
  101fd7:	e9 86 fe ff ff       	jmp    101e62 <__alltraps>

00101fdc <vector40>:
.globl vector40
vector40:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $40
  101fde:	6a 28                	push   $0x28
  jmp __alltraps
  101fe0:	e9 7d fe ff ff       	jmp    101e62 <__alltraps>

00101fe5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $41
  101fe7:	6a 29                	push   $0x29
  jmp __alltraps
  101fe9:	e9 74 fe ff ff       	jmp    101e62 <__alltraps>

00101fee <vector42>:
.globl vector42
vector42:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $42
  101ff0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ff2:	e9 6b fe ff ff       	jmp    101e62 <__alltraps>

00101ff7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $43
  101ff9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ffb:	e9 62 fe ff ff       	jmp    101e62 <__alltraps>

00102000 <vector44>:
.globl vector44
vector44:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $44
  102002:	6a 2c                	push   $0x2c
  jmp __alltraps
  102004:	e9 59 fe ff ff       	jmp    101e62 <__alltraps>

00102009 <vector45>:
.globl vector45
vector45:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $45
  10200b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10200d:	e9 50 fe ff ff       	jmp    101e62 <__alltraps>

00102012 <vector46>:
.globl vector46
vector46:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $46
  102014:	6a 2e                	push   $0x2e
  jmp __alltraps
  102016:	e9 47 fe ff ff       	jmp    101e62 <__alltraps>

0010201b <vector47>:
.globl vector47
vector47:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $47
  10201d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10201f:	e9 3e fe ff ff       	jmp    101e62 <__alltraps>

00102024 <vector48>:
.globl vector48
vector48:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $48
  102026:	6a 30                	push   $0x30
  jmp __alltraps
  102028:	e9 35 fe ff ff       	jmp    101e62 <__alltraps>

0010202d <vector49>:
.globl vector49
vector49:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $49
  10202f:	6a 31                	push   $0x31
  jmp __alltraps
  102031:	e9 2c fe ff ff       	jmp    101e62 <__alltraps>

00102036 <vector50>:
.globl vector50
vector50:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $50
  102038:	6a 32                	push   $0x32
  jmp __alltraps
  10203a:	e9 23 fe ff ff       	jmp    101e62 <__alltraps>

0010203f <vector51>:
.globl vector51
vector51:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $51
  102041:	6a 33                	push   $0x33
  jmp __alltraps
  102043:	e9 1a fe ff ff       	jmp    101e62 <__alltraps>

00102048 <vector52>:
.globl vector52
vector52:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $52
  10204a:	6a 34                	push   $0x34
  jmp __alltraps
  10204c:	e9 11 fe ff ff       	jmp    101e62 <__alltraps>

00102051 <vector53>:
.globl vector53
vector53:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $53
  102053:	6a 35                	push   $0x35
  jmp __alltraps
  102055:	e9 08 fe ff ff       	jmp    101e62 <__alltraps>

0010205a <vector54>:
.globl vector54
vector54:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $54
  10205c:	6a 36                	push   $0x36
  jmp __alltraps
  10205e:	e9 ff fd ff ff       	jmp    101e62 <__alltraps>

00102063 <vector55>:
.globl vector55
vector55:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $55
  102065:	6a 37                	push   $0x37
  jmp __alltraps
  102067:	e9 f6 fd ff ff       	jmp    101e62 <__alltraps>

0010206c <vector56>:
.globl vector56
vector56:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $56
  10206e:	6a 38                	push   $0x38
  jmp __alltraps
  102070:	e9 ed fd ff ff       	jmp    101e62 <__alltraps>

00102075 <vector57>:
.globl vector57
vector57:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $57
  102077:	6a 39                	push   $0x39
  jmp __alltraps
  102079:	e9 e4 fd ff ff       	jmp    101e62 <__alltraps>

0010207e <vector58>:
.globl vector58
vector58:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $58
  102080:	6a 3a                	push   $0x3a
  jmp __alltraps
  102082:	e9 db fd ff ff       	jmp    101e62 <__alltraps>

00102087 <vector59>:
.globl vector59
vector59:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $59
  102089:	6a 3b                	push   $0x3b
  jmp __alltraps
  10208b:	e9 d2 fd ff ff       	jmp    101e62 <__alltraps>

00102090 <vector60>:
.globl vector60
vector60:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $60
  102092:	6a 3c                	push   $0x3c
  jmp __alltraps
  102094:	e9 c9 fd ff ff       	jmp    101e62 <__alltraps>

00102099 <vector61>:
.globl vector61
vector61:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $61
  10209b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10209d:	e9 c0 fd ff ff       	jmp    101e62 <__alltraps>

001020a2 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $62
  1020a4:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020a6:	e9 b7 fd ff ff       	jmp    101e62 <__alltraps>

001020ab <vector63>:
.globl vector63
vector63:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $63
  1020ad:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020af:	e9 ae fd ff ff       	jmp    101e62 <__alltraps>

001020b4 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $64
  1020b6:	6a 40                	push   $0x40
  jmp __alltraps
  1020b8:	e9 a5 fd ff ff       	jmp    101e62 <__alltraps>

001020bd <vector65>:
.globl vector65
vector65:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $65
  1020bf:	6a 41                	push   $0x41
  jmp __alltraps
  1020c1:	e9 9c fd ff ff       	jmp    101e62 <__alltraps>

001020c6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $66
  1020c8:	6a 42                	push   $0x42
  jmp __alltraps
  1020ca:	e9 93 fd ff ff       	jmp    101e62 <__alltraps>

001020cf <vector67>:
.globl vector67
vector67:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $67
  1020d1:	6a 43                	push   $0x43
  jmp __alltraps
  1020d3:	e9 8a fd ff ff       	jmp    101e62 <__alltraps>

001020d8 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $68
  1020da:	6a 44                	push   $0x44
  jmp __alltraps
  1020dc:	e9 81 fd ff ff       	jmp    101e62 <__alltraps>

001020e1 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $69
  1020e3:	6a 45                	push   $0x45
  jmp __alltraps
  1020e5:	e9 78 fd ff ff       	jmp    101e62 <__alltraps>

001020ea <vector70>:
.globl vector70
vector70:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $70
  1020ec:	6a 46                	push   $0x46
  jmp __alltraps
  1020ee:	e9 6f fd ff ff       	jmp    101e62 <__alltraps>

001020f3 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $71
  1020f5:	6a 47                	push   $0x47
  jmp __alltraps
  1020f7:	e9 66 fd ff ff       	jmp    101e62 <__alltraps>

001020fc <vector72>:
.globl vector72
vector72:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $72
  1020fe:	6a 48                	push   $0x48
  jmp __alltraps
  102100:	e9 5d fd ff ff       	jmp    101e62 <__alltraps>

00102105 <vector73>:
.globl vector73
vector73:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $73
  102107:	6a 49                	push   $0x49
  jmp __alltraps
  102109:	e9 54 fd ff ff       	jmp    101e62 <__alltraps>

0010210e <vector74>:
.globl vector74
vector74:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $74
  102110:	6a 4a                	push   $0x4a
  jmp __alltraps
  102112:	e9 4b fd ff ff       	jmp    101e62 <__alltraps>

00102117 <vector75>:
.globl vector75
vector75:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $75
  102119:	6a 4b                	push   $0x4b
  jmp __alltraps
  10211b:	e9 42 fd ff ff       	jmp    101e62 <__alltraps>

00102120 <vector76>:
.globl vector76
vector76:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $76
  102122:	6a 4c                	push   $0x4c
  jmp __alltraps
  102124:	e9 39 fd ff ff       	jmp    101e62 <__alltraps>

00102129 <vector77>:
.globl vector77
vector77:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $77
  10212b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10212d:	e9 30 fd ff ff       	jmp    101e62 <__alltraps>

00102132 <vector78>:
.globl vector78
vector78:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $78
  102134:	6a 4e                	push   $0x4e
  jmp __alltraps
  102136:	e9 27 fd ff ff       	jmp    101e62 <__alltraps>

0010213b <vector79>:
.globl vector79
vector79:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $79
  10213d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10213f:	e9 1e fd ff ff       	jmp    101e62 <__alltraps>

00102144 <vector80>:
.globl vector80
vector80:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $80
  102146:	6a 50                	push   $0x50
  jmp __alltraps
  102148:	e9 15 fd ff ff       	jmp    101e62 <__alltraps>

0010214d <vector81>:
.globl vector81
vector81:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $81
  10214f:	6a 51                	push   $0x51
  jmp __alltraps
  102151:	e9 0c fd ff ff       	jmp    101e62 <__alltraps>

00102156 <vector82>:
.globl vector82
vector82:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $82
  102158:	6a 52                	push   $0x52
  jmp __alltraps
  10215a:	e9 03 fd ff ff       	jmp    101e62 <__alltraps>

0010215f <vector83>:
.globl vector83
vector83:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $83
  102161:	6a 53                	push   $0x53
  jmp __alltraps
  102163:	e9 fa fc ff ff       	jmp    101e62 <__alltraps>

00102168 <vector84>:
.globl vector84
vector84:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $84
  10216a:	6a 54                	push   $0x54
  jmp __alltraps
  10216c:	e9 f1 fc ff ff       	jmp    101e62 <__alltraps>

00102171 <vector85>:
.globl vector85
vector85:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $85
  102173:	6a 55                	push   $0x55
  jmp __alltraps
  102175:	e9 e8 fc ff ff       	jmp    101e62 <__alltraps>

0010217a <vector86>:
.globl vector86
vector86:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $86
  10217c:	6a 56                	push   $0x56
  jmp __alltraps
  10217e:	e9 df fc ff ff       	jmp    101e62 <__alltraps>

00102183 <vector87>:
.globl vector87
vector87:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $87
  102185:	6a 57                	push   $0x57
  jmp __alltraps
  102187:	e9 d6 fc ff ff       	jmp    101e62 <__alltraps>

0010218c <vector88>:
.globl vector88
vector88:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $88
  10218e:	6a 58                	push   $0x58
  jmp __alltraps
  102190:	e9 cd fc ff ff       	jmp    101e62 <__alltraps>

00102195 <vector89>:
.globl vector89
vector89:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $89
  102197:	6a 59                	push   $0x59
  jmp __alltraps
  102199:	e9 c4 fc ff ff       	jmp    101e62 <__alltraps>

0010219e <vector90>:
.globl vector90
vector90:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $90
  1021a0:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021a2:	e9 bb fc ff ff       	jmp    101e62 <__alltraps>

001021a7 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $91
  1021a9:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021ab:	e9 b2 fc ff ff       	jmp    101e62 <__alltraps>

001021b0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $92
  1021b2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021b4:	e9 a9 fc ff ff       	jmp    101e62 <__alltraps>

001021b9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $93
  1021bb:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021bd:	e9 a0 fc ff ff       	jmp    101e62 <__alltraps>

001021c2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $94
  1021c4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021c6:	e9 97 fc ff ff       	jmp    101e62 <__alltraps>

001021cb <vector95>:
.globl vector95
vector95:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $95
  1021cd:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021cf:	e9 8e fc ff ff       	jmp    101e62 <__alltraps>

001021d4 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $96
  1021d6:	6a 60                	push   $0x60
  jmp __alltraps
  1021d8:	e9 85 fc ff ff       	jmp    101e62 <__alltraps>

001021dd <vector97>:
.globl vector97
vector97:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $97
  1021df:	6a 61                	push   $0x61
  jmp __alltraps
  1021e1:	e9 7c fc ff ff       	jmp    101e62 <__alltraps>

001021e6 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $98
  1021e8:	6a 62                	push   $0x62
  jmp __alltraps
  1021ea:	e9 73 fc ff ff       	jmp    101e62 <__alltraps>

001021ef <vector99>:
.globl vector99
vector99:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $99
  1021f1:	6a 63                	push   $0x63
  jmp __alltraps
  1021f3:	e9 6a fc ff ff       	jmp    101e62 <__alltraps>

001021f8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $100
  1021fa:	6a 64                	push   $0x64
  jmp __alltraps
  1021fc:	e9 61 fc ff ff       	jmp    101e62 <__alltraps>

00102201 <vector101>:
.globl vector101
vector101:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $101
  102203:	6a 65                	push   $0x65
  jmp __alltraps
  102205:	e9 58 fc ff ff       	jmp    101e62 <__alltraps>

0010220a <vector102>:
.globl vector102
vector102:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $102
  10220c:	6a 66                	push   $0x66
  jmp __alltraps
  10220e:	e9 4f fc ff ff       	jmp    101e62 <__alltraps>

00102213 <vector103>:
.globl vector103
vector103:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $103
  102215:	6a 67                	push   $0x67
  jmp __alltraps
  102217:	e9 46 fc ff ff       	jmp    101e62 <__alltraps>

0010221c <vector104>:
.globl vector104
vector104:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $104
  10221e:	6a 68                	push   $0x68
  jmp __alltraps
  102220:	e9 3d fc ff ff       	jmp    101e62 <__alltraps>

00102225 <vector105>:
.globl vector105
vector105:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $105
  102227:	6a 69                	push   $0x69
  jmp __alltraps
  102229:	e9 34 fc ff ff       	jmp    101e62 <__alltraps>

0010222e <vector106>:
.globl vector106
vector106:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $106
  102230:	6a 6a                	push   $0x6a
  jmp __alltraps
  102232:	e9 2b fc ff ff       	jmp    101e62 <__alltraps>

00102237 <vector107>:
.globl vector107
vector107:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $107
  102239:	6a 6b                	push   $0x6b
  jmp __alltraps
  10223b:	e9 22 fc ff ff       	jmp    101e62 <__alltraps>

00102240 <vector108>:
.globl vector108
vector108:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $108
  102242:	6a 6c                	push   $0x6c
  jmp __alltraps
  102244:	e9 19 fc ff ff       	jmp    101e62 <__alltraps>

00102249 <vector109>:
.globl vector109
vector109:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $109
  10224b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10224d:	e9 10 fc ff ff       	jmp    101e62 <__alltraps>

00102252 <vector110>:
.globl vector110
vector110:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $110
  102254:	6a 6e                	push   $0x6e
  jmp __alltraps
  102256:	e9 07 fc ff ff       	jmp    101e62 <__alltraps>

0010225b <vector111>:
.globl vector111
vector111:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $111
  10225d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10225f:	e9 fe fb ff ff       	jmp    101e62 <__alltraps>

00102264 <vector112>:
.globl vector112
vector112:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $112
  102266:	6a 70                	push   $0x70
  jmp __alltraps
  102268:	e9 f5 fb ff ff       	jmp    101e62 <__alltraps>

0010226d <vector113>:
.globl vector113
vector113:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $113
  10226f:	6a 71                	push   $0x71
  jmp __alltraps
  102271:	e9 ec fb ff ff       	jmp    101e62 <__alltraps>

00102276 <vector114>:
.globl vector114
vector114:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $114
  102278:	6a 72                	push   $0x72
  jmp __alltraps
  10227a:	e9 e3 fb ff ff       	jmp    101e62 <__alltraps>

0010227f <vector115>:
.globl vector115
vector115:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $115
  102281:	6a 73                	push   $0x73
  jmp __alltraps
  102283:	e9 da fb ff ff       	jmp    101e62 <__alltraps>

00102288 <vector116>:
.globl vector116
vector116:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $116
  10228a:	6a 74                	push   $0x74
  jmp __alltraps
  10228c:	e9 d1 fb ff ff       	jmp    101e62 <__alltraps>

00102291 <vector117>:
.globl vector117
vector117:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $117
  102293:	6a 75                	push   $0x75
  jmp __alltraps
  102295:	e9 c8 fb ff ff       	jmp    101e62 <__alltraps>

0010229a <vector118>:
.globl vector118
vector118:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $118
  10229c:	6a 76                	push   $0x76
  jmp __alltraps
  10229e:	e9 bf fb ff ff       	jmp    101e62 <__alltraps>

001022a3 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $119
  1022a5:	6a 77                	push   $0x77
  jmp __alltraps
  1022a7:	e9 b6 fb ff ff       	jmp    101e62 <__alltraps>

001022ac <vector120>:
.globl vector120
vector120:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $120
  1022ae:	6a 78                	push   $0x78
  jmp __alltraps
  1022b0:	e9 ad fb ff ff       	jmp    101e62 <__alltraps>

001022b5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $121
  1022b7:	6a 79                	push   $0x79
  jmp __alltraps
  1022b9:	e9 a4 fb ff ff       	jmp    101e62 <__alltraps>

001022be <vector122>:
.globl vector122
vector122:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $122
  1022c0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022c2:	e9 9b fb ff ff       	jmp    101e62 <__alltraps>

001022c7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $123
  1022c9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022cb:	e9 92 fb ff ff       	jmp    101e62 <__alltraps>

001022d0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $124
  1022d2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022d4:	e9 89 fb ff ff       	jmp    101e62 <__alltraps>

001022d9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $125
  1022db:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022dd:	e9 80 fb ff ff       	jmp    101e62 <__alltraps>

001022e2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $126
  1022e4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022e6:	e9 77 fb ff ff       	jmp    101e62 <__alltraps>

001022eb <vector127>:
.globl vector127
vector127:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $127
  1022ed:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022ef:	e9 6e fb ff ff       	jmp    101e62 <__alltraps>

001022f4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $128
  1022f6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022fb:	e9 62 fb ff ff       	jmp    101e62 <__alltraps>

00102300 <vector129>:
.globl vector129
vector129:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $129
  102302:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102307:	e9 56 fb ff ff       	jmp    101e62 <__alltraps>

0010230c <vector130>:
.globl vector130
vector130:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $130
  10230e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102313:	e9 4a fb ff ff       	jmp    101e62 <__alltraps>

00102318 <vector131>:
.globl vector131
vector131:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $131
  10231a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10231f:	e9 3e fb ff ff       	jmp    101e62 <__alltraps>

00102324 <vector132>:
.globl vector132
vector132:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $132
  102326:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10232b:	e9 32 fb ff ff       	jmp    101e62 <__alltraps>

00102330 <vector133>:
.globl vector133
vector133:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $133
  102332:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102337:	e9 26 fb ff ff       	jmp    101e62 <__alltraps>

0010233c <vector134>:
.globl vector134
vector134:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $134
  10233e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102343:	e9 1a fb ff ff       	jmp    101e62 <__alltraps>

00102348 <vector135>:
.globl vector135
vector135:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $135
  10234a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10234f:	e9 0e fb ff ff       	jmp    101e62 <__alltraps>

00102354 <vector136>:
.globl vector136
vector136:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $136
  102356:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10235b:	e9 02 fb ff ff       	jmp    101e62 <__alltraps>

00102360 <vector137>:
.globl vector137
vector137:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $137
  102362:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102367:	e9 f6 fa ff ff       	jmp    101e62 <__alltraps>

0010236c <vector138>:
.globl vector138
vector138:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $138
  10236e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102373:	e9 ea fa ff ff       	jmp    101e62 <__alltraps>

00102378 <vector139>:
.globl vector139
vector139:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $139
  10237a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10237f:	e9 de fa ff ff       	jmp    101e62 <__alltraps>

00102384 <vector140>:
.globl vector140
vector140:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $140
  102386:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10238b:	e9 d2 fa ff ff       	jmp    101e62 <__alltraps>

00102390 <vector141>:
.globl vector141
vector141:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $141
  102392:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102397:	e9 c6 fa ff ff       	jmp    101e62 <__alltraps>

0010239c <vector142>:
.globl vector142
vector142:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $142
  10239e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023a3:	e9 ba fa ff ff       	jmp    101e62 <__alltraps>

001023a8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $143
  1023aa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023af:	e9 ae fa ff ff       	jmp    101e62 <__alltraps>

001023b4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $144
  1023b6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023bb:	e9 a2 fa ff ff       	jmp    101e62 <__alltraps>

001023c0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $145
  1023c2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023c7:	e9 96 fa ff ff       	jmp    101e62 <__alltraps>

001023cc <vector146>:
.globl vector146
vector146:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $146
  1023ce:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023d3:	e9 8a fa ff ff       	jmp    101e62 <__alltraps>

001023d8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $147
  1023da:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023df:	e9 7e fa ff ff       	jmp    101e62 <__alltraps>

001023e4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $148
  1023e6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023eb:	e9 72 fa ff ff       	jmp    101e62 <__alltraps>

001023f0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $149
  1023f2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023f7:	e9 66 fa ff ff       	jmp    101e62 <__alltraps>

001023fc <vector150>:
.globl vector150
vector150:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $150
  1023fe:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102403:	e9 5a fa ff ff       	jmp    101e62 <__alltraps>

00102408 <vector151>:
.globl vector151
vector151:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $151
  10240a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10240f:	e9 4e fa ff ff       	jmp    101e62 <__alltraps>

00102414 <vector152>:
.globl vector152
vector152:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $152
  102416:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10241b:	e9 42 fa ff ff       	jmp    101e62 <__alltraps>

00102420 <vector153>:
.globl vector153
vector153:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $153
  102422:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102427:	e9 36 fa ff ff       	jmp    101e62 <__alltraps>

0010242c <vector154>:
.globl vector154
vector154:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $154
  10242e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102433:	e9 2a fa ff ff       	jmp    101e62 <__alltraps>

00102438 <vector155>:
.globl vector155
vector155:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $155
  10243a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10243f:	e9 1e fa ff ff       	jmp    101e62 <__alltraps>

00102444 <vector156>:
.globl vector156
vector156:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $156
  102446:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10244b:	e9 12 fa ff ff       	jmp    101e62 <__alltraps>

00102450 <vector157>:
.globl vector157
vector157:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $157
  102452:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102457:	e9 06 fa ff ff       	jmp    101e62 <__alltraps>

0010245c <vector158>:
.globl vector158
vector158:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $158
  10245e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102463:	e9 fa f9 ff ff       	jmp    101e62 <__alltraps>

00102468 <vector159>:
.globl vector159
vector159:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $159
  10246a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10246f:	e9 ee f9 ff ff       	jmp    101e62 <__alltraps>

00102474 <vector160>:
.globl vector160
vector160:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $160
  102476:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10247b:	e9 e2 f9 ff ff       	jmp    101e62 <__alltraps>

00102480 <vector161>:
.globl vector161
vector161:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $161
  102482:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102487:	e9 d6 f9 ff ff       	jmp    101e62 <__alltraps>

0010248c <vector162>:
.globl vector162
vector162:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $162
  10248e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102493:	e9 ca f9 ff ff       	jmp    101e62 <__alltraps>

00102498 <vector163>:
.globl vector163
vector163:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $163
  10249a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10249f:	e9 be f9 ff ff       	jmp    101e62 <__alltraps>

001024a4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $164
  1024a6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024ab:	e9 b2 f9 ff ff       	jmp    101e62 <__alltraps>

001024b0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $165
  1024b2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024b7:	e9 a6 f9 ff ff       	jmp    101e62 <__alltraps>

001024bc <vector166>:
.globl vector166
vector166:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $166
  1024be:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024c3:	e9 9a f9 ff ff       	jmp    101e62 <__alltraps>

001024c8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $167
  1024ca:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024cf:	e9 8e f9 ff ff       	jmp    101e62 <__alltraps>

001024d4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $168
  1024d6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024db:	e9 82 f9 ff ff       	jmp    101e62 <__alltraps>

001024e0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $169
  1024e2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024e7:	e9 76 f9 ff ff       	jmp    101e62 <__alltraps>

001024ec <vector170>:
.globl vector170
vector170:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $170
  1024ee:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024f3:	e9 6a f9 ff ff       	jmp    101e62 <__alltraps>

001024f8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $171
  1024fa:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024ff:	e9 5e f9 ff ff       	jmp    101e62 <__alltraps>

00102504 <vector172>:
.globl vector172
vector172:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $172
  102506:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10250b:	e9 52 f9 ff ff       	jmp    101e62 <__alltraps>

00102510 <vector173>:
.globl vector173
vector173:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $173
  102512:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102517:	e9 46 f9 ff ff       	jmp    101e62 <__alltraps>

0010251c <vector174>:
.globl vector174
vector174:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $174
  10251e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102523:	e9 3a f9 ff ff       	jmp    101e62 <__alltraps>

00102528 <vector175>:
.globl vector175
vector175:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $175
  10252a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10252f:	e9 2e f9 ff ff       	jmp    101e62 <__alltraps>

00102534 <vector176>:
.globl vector176
vector176:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $176
  102536:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10253b:	e9 22 f9 ff ff       	jmp    101e62 <__alltraps>

00102540 <vector177>:
.globl vector177
vector177:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $177
  102542:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102547:	e9 16 f9 ff ff       	jmp    101e62 <__alltraps>

0010254c <vector178>:
.globl vector178
vector178:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $178
  10254e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102553:	e9 0a f9 ff ff       	jmp    101e62 <__alltraps>

00102558 <vector179>:
.globl vector179
vector179:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $179
  10255a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10255f:	e9 fe f8 ff ff       	jmp    101e62 <__alltraps>

00102564 <vector180>:
.globl vector180
vector180:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $180
  102566:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10256b:	e9 f2 f8 ff ff       	jmp    101e62 <__alltraps>

00102570 <vector181>:
.globl vector181
vector181:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $181
  102572:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102577:	e9 e6 f8 ff ff       	jmp    101e62 <__alltraps>

0010257c <vector182>:
.globl vector182
vector182:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $182
  10257e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102583:	e9 da f8 ff ff       	jmp    101e62 <__alltraps>

00102588 <vector183>:
.globl vector183
vector183:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $183
  10258a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10258f:	e9 ce f8 ff ff       	jmp    101e62 <__alltraps>

00102594 <vector184>:
.globl vector184
vector184:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $184
  102596:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10259b:	e9 c2 f8 ff ff       	jmp    101e62 <__alltraps>

001025a0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $185
  1025a2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025a7:	e9 b6 f8 ff ff       	jmp    101e62 <__alltraps>

001025ac <vector186>:
.globl vector186
vector186:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $186
  1025ae:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025b3:	e9 aa f8 ff ff       	jmp    101e62 <__alltraps>

001025b8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $187
  1025ba:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025bf:	e9 9e f8 ff ff       	jmp    101e62 <__alltraps>

001025c4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $188
  1025c6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025cb:	e9 92 f8 ff ff       	jmp    101e62 <__alltraps>

001025d0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $189
  1025d2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025d7:	e9 86 f8 ff ff       	jmp    101e62 <__alltraps>

001025dc <vector190>:
.globl vector190
vector190:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $190
  1025de:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025e3:	e9 7a f8 ff ff       	jmp    101e62 <__alltraps>

001025e8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $191
  1025ea:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025ef:	e9 6e f8 ff ff       	jmp    101e62 <__alltraps>

001025f4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $192
  1025f6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025fb:	e9 62 f8 ff ff       	jmp    101e62 <__alltraps>

00102600 <vector193>:
.globl vector193
vector193:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $193
  102602:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102607:	e9 56 f8 ff ff       	jmp    101e62 <__alltraps>

0010260c <vector194>:
.globl vector194
vector194:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $194
  10260e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102613:	e9 4a f8 ff ff       	jmp    101e62 <__alltraps>

00102618 <vector195>:
.globl vector195
vector195:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $195
  10261a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10261f:	e9 3e f8 ff ff       	jmp    101e62 <__alltraps>

00102624 <vector196>:
.globl vector196
vector196:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $196
  102626:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10262b:	e9 32 f8 ff ff       	jmp    101e62 <__alltraps>

00102630 <vector197>:
.globl vector197
vector197:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $197
  102632:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102637:	e9 26 f8 ff ff       	jmp    101e62 <__alltraps>

0010263c <vector198>:
.globl vector198
vector198:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $198
  10263e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102643:	e9 1a f8 ff ff       	jmp    101e62 <__alltraps>

00102648 <vector199>:
.globl vector199
vector199:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $199
  10264a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10264f:	e9 0e f8 ff ff       	jmp    101e62 <__alltraps>

00102654 <vector200>:
.globl vector200
vector200:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $200
  102656:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10265b:	e9 02 f8 ff ff       	jmp    101e62 <__alltraps>

00102660 <vector201>:
.globl vector201
vector201:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $201
  102662:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102667:	e9 f6 f7 ff ff       	jmp    101e62 <__alltraps>

0010266c <vector202>:
.globl vector202
vector202:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $202
  10266e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102673:	e9 ea f7 ff ff       	jmp    101e62 <__alltraps>

00102678 <vector203>:
.globl vector203
vector203:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $203
  10267a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10267f:	e9 de f7 ff ff       	jmp    101e62 <__alltraps>

00102684 <vector204>:
.globl vector204
vector204:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $204
  102686:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10268b:	e9 d2 f7 ff ff       	jmp    101e62 <__alltraps>

00102690 <vector205>:
.globl vector205
vector205:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $205
  102692:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102697:	e9 c6 f7 ff ff       	jmp    101e62 <__alltraps>

0010269c <vector206>:
.globl vector206
vector206:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $206
  10269e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026a3:	e9 ba f7 ff ff       	jmp    101e62 <__alltraps>

001026a8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $207
  1026aa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026af:	e9 ae f7 ff ff       	jmp    101e62 <__alltraps>

001026b4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $208
  1026b6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026bb:	e9 a2 f7 ff ff       	jmp    101e62 <__alltraps>

001026c0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $209
  1026c2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026c7:	e9 96 f7 ff ff       	jmp    101e62 <__alltraps>

001026cc <vector210>:
.globl vector210
vector210:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $210
  1026ce:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026d3:	e9 8a f7 ff ff       	jmp    101e62 <__alltraps>

001026d8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $211
  1026da:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026df:	e9 7e f7 ff ff       	jmp    101e62 <__alltraps>

001026e4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $212
  1026e6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026eb:	e9 72 f7 ff ff       	jmp    101e62 <__alltraps>

001026f0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $213
  1026f2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026f7:	e9 66 f7 ff ff       	jmp    101e62 <__alltraps>

001026fc <vector214>:
.globl vector214
vector214:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $214
  1026fe:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102703:	e9 5a f7 ff ff       	jmp    101e62 <__alltraps>

00102708 <vector215>:
.globl vector215
vector215:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $215
  10270a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10270f:	e9 4e f7 ff ff       	jmp    101e62 <__alltraps>

00102714 <vector216>:
.globl vector216
vector216:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $216
  102716:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10271b:	e9 42 f7 ff ff       	jmp    101e62 <__alltraps>

00102720 <vector217>:
.globl vector217
vector217:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $217
  102722:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102727:	e9 36 f7 ff ff       	jmp    101e62 <__alltraps>

0010272c <vector218>:
.globl vector218
vector218:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $218
  10272e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102733:	e9 2a f7 ff ff       	jmp    101e62 <__alltraps>

00102738 <vector219>:
.globl vector219
vector219:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $219
  10273a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10273f:	e9 1e f7 ff ff       	jmp    101e62 <__alltraps>

00102744 <vector220>:
.globl vector220
vector220:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $220
  102746:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10274b:	e9 12 f7 ff ff       	jmp    101e62 <__alltraps>

00102750 <vector221>:
.globl vector221
vector221:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $221
  102752:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102757:	e9 06 f7 ff ff       	jmp    101e62 <__alltraps>

0010275c <vector222>:
.globl vector222
vector222:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $222
  10275e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102763:	e9 fa f6 ff ff       	jmp    101e62 <__alltraps>

00102768 <vector223>:
.globl vector223
vector223:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $223
  10276a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10276f:	e9 ee f6 ff ff       	jmp    101e62 <__alltraps>

00102774 <vector224>:
.globl vector224
vector224:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $224
  102776:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10277b:	e9 e2 f6 ff ff       	jmp    101e62 <__alltraps>

00102780 <vector225>:
.globl vector225
vector225:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $225
  102782:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102787:	e9 d6 f6 ff ff       	jmp    101e62 <__alltraps>

0010278c <vector226>:
.globl vector226
vector226:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $226
  10278e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102793:	e9 ca f6 ff ff       	jmp    101e62 <__alltraps>

00102798 <vector227>:
.globl vector227
vector227:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $227
  10279a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10279f:	e9 be f6 ff ff       	jmp    101e62 <__alltraps>

001027a4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $228
  1027a6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027ab:	e9 b2 f6 ff ff       	jmp    101e62 <__alltraps>

001027b0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $229
  1027b2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027b7:	e9 a6 f6 ff ff       	jmp    101e62 <__alltraps>

001027bc <vector230>:
.globl vector230
vector230:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $230
  1027be:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027c3:	e9 9a f6 ff ff       	jmp    101e62 <__alltraps>

001027c8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $231
  1027ca:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027cf:	e9 8e f6 ff ff       	jmp    101e62 <__alltraps>

001027d4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $232
  1027d6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027db:	e9 82 f6 ff ff       	jmp    101e62 <__alltraps>

001027e0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $233
  1027e2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027e7:	e9 76 f6 ff ff       	jmp    101e62 <__alltraps>

001027ec <vector234>:
.globl vector234
vector234:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $234
  1027ee:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027f3:	e9 6a f6 ff ff       	jmp    101e62 <__alltraps>

001027f8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $235
  1027fa:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027ff:	e9 5e f6 ff ff       	jmp    101e62 <__alltraps>

00102804 <vector236>:
.globl vector236
vector236:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $236
  102806:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10280b:	e9 52 f6 ff ff       	jmp    101e62 <__alltraps>

00102810 <vector237>:
.globl vector237
vector237:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $237
  102812:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102817:	e9 46 f6 ff ff       	jmp    101e62 <__alltraps>

0010281c <vector238>:
.globl vector238
vector238:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $238
  10281e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102823:	e9 3a f6 ff ff       	jmp    101e62 <__alltraps>

00102828 <vector239>:
.globl vector239
vector239:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $239
  10282a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10282f:	e9 2e f6 ff ff       	jmp    101e62 <__alltraps>

00102834 <vector240>:
.globl vector240
vector240:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $240
  102836:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10283b:	e9 22 f6 ff ff       	jmp    101e62 <__alltraps>

00102840 <vector241>:
.globl vector241
vector241:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $241
  102842:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102847:	e9 16 f6 ff ff       	jmp    101e62 <__alltraps>

0010284c <vector242>:
.globl vector242
vector242:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $242
  10284e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102853:	e9 0a f6 ff ff       	jmp    101e62 <__alltraps>

00102858 <vector243>:
.globl vector243
vector243:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $243
  10285a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10285f:	e9 fe f5 ff ff       	jmp    101e62 <__alltraps>

00102864 <vector244>:
.globl vector244
vector244:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $244
  102866:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10286b:	e9 f2 f5 ff ff       	jmp    101e62 <__alltraps>

00102870 <vector245>:
.globl vector245
vector245:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $245
  102872:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102877:	e9 e6 f5 ff ff       	jmp    101e62 <__alltraps>

0010287c <vector246>:
.globl vector246
vector246:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $246
  10287e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102883:	e9 da f5 ff ff       	jmp    101e62 <__alltraps>

00102888 <vector247>:
.globl vector247
vector247:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $247
  10288a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10288f:	e9 ce f5 ff ff       	jmp    101e62 <__alltraps>

00102894 <vector248>:
.globl vector248
vector248:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $248
  102896:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10289b:	e9 c2 f5 ff ff       	jmp    101e62 <__alltraps>

001028a0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $249
  1028a2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028a7:	e9 b6 f5 ff ff       	jmp    101e62 <__alltraps>

001028ac <vector250>:
.globl vector250
vector250:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $250
  1028ae:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028b3:	e9 aa f5 ff ff       	jmp    101e62 <__alltraps>

001028b8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $251
  1028ba:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028bf:	e9 9e f5 ff ff       	jmp    101e62 <__alltraps>

001028c4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $252
  1028c6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028cb:	e9 92 f5 ff ff       	jmp    101e62 <__alltraps>

001028d0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $253
  1028d2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028d7:	e9 86 f5 ff ff       	jmp    101e62 <__alltraps>

001028dc <vector254>:
.globl vector254
vector254:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $254
  1028de:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028e3:	e9 7a f5 ff ff       	jmp    101e62 <__alltraps>

001028e8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $255
  1028ea:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028ef:	e9 6e f5 ff ff       	jmp    101e62 <__alltraps>

001028f4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028f4:	55                   	push   %ebp
  1028f5:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028f7:	8b 55 08             	mov    0x8(%ebp),%edx
  1028fa:	a1 e4 89 11 00       	mov    0x1189e4,%eax
  1028ff:	29 c2                	sub    %eax,%edx
  102901:	89 d0                	mov    %edx,%eax
  102903:	c1 f8 02             	sar    $0x2,%eax
  102906:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10290c:	5d                   	pop    %ebp
  10290d:	c3                   	ret    

0010290e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10290e:	55                   	push   %ebp
  10290f:	89 e5                	mov    %esp,%ebp
  102911:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102914:	8b 45 08             	mov    0x8(%ebp),%eax
  102917:	89 04 24             	mov    %eax,(%esp)
  10291a:	e8 d5 ff ff ff       	call   1028f4 <page2ppn>
  10291f:	c1 e0 0c             	shl    $0xc,%eax
}
  102922:	c9                   	leave  
  102923:	c3                   	ret    

00102924 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102924:	55                   	push   %ebp
  102925:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102927:	8b 45 08             	mov    0x8(%ebp),%eax
  10292a:	8b 00                	mov    (%eax),%eax
}
  10292c:	5d                   	pop    %ebp
  10292d:	c3                   	ret    

0010292e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10292e:	55                   	push   %ebp
  10292f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102931:	8b 45 08             	mov    0x8(%ebp),%eax
  102934:	8b 55 0c             	mov    0xc(%ebp),%edx
  102937:	89 10                	mov    %edx,(%eax)
}
  102939:	5d                   	pop    %ebp
  10293a:	c3                   	ret    

0010293b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10293b:	55                   	push   %ebp
  10293c:	89 e5                	mov    %esp,%ebp
  10293e:	83 ec 10             	sub    $0x10,%esp
  102941:	c7 45 fc d0 89 11 00 	movl   $0x1189d0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10294b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10294e:	89 50 04             	mov    %edx,0x4(%eax)
  102951:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102954:	8b 50 04             	mov    0x4(%eax),%edx
  102957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10295a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10295c:	c7 05 d8 89 11 00 00 	movl   $0x0,0x1189d8
  102963:	00 00 00 
}
  102966:	c9                   	leave  
  102967:	c3                   	ret    

00102968 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102968:	55                   	push   %ebp
  102969:	89 e5                	mov    %esp,%ebp
  10296b:	83 ec 78             	sub    $0x78,%esp
	assert(n > 0);
  10296e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102972:	75 24                	jne    102998 <default_init_memmap+0x30>
  102974:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  10297b:	00 
  10297c:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102983:	00 
  102984:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10298b:	00 
  10298c:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102993:	e8 33 e3 ff ff       	call   100ccb <__panic>
	struct Page* p = base;
  102998:	8b 45 08             	mov    0x8(%ebp),%eax
  10299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++)
  10299e:	e9 a3 00 00 00       	jmp    102a46 <default_init_memmap+0xde>
	{
		assert(PageReserved(p));
  1029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a6:	83 c0 04             	add    $0x4,%eax
  1029a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1029b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029b9:	0f a3 10             	bt     %edx,(%eax)
  1029bc:	19 c0                	sbb    %eax,%eax
  1029be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1029c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1029c5:	0f 95 c0             	setne  %al
  1029c8:	0f b6 c0             	movzbl %al,%eax
  1029cb:	85 c0                	test   %eax,%eax
  1029cd:	75 24                	jne    1029f3 <default_init_memmap+0x8b>
  1029cf:	c7 44 24 0c 01 69 10 	movl   $0x106901,0xc(%esp)
  1029d6:	00 
  1029d7:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1029de:	00 
  1029df:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  1029e6:	00 
  1029e7:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1029ee:	e8 d8 e2 ff ff       	call   100ccb <__panic>
		ClearPageReserved(p);
  1029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f6:	83 c0 04             	add    $0x4,%eax
  1029f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102a00:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102a09:	0f b3 10             	btr    %edx,(%eax)
		SetPageProperty(p);
  102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a0f:	83 c0 04             	add    $0x4,%eax
  102a12:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a1f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a22:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
  102a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
  102a2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a36:	00 
  102a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a3a:	89 04 24             	mov    %eax,(%esp)
  102a3d:	e8 ec fe ff ff       	call   10292e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page* p = base;
	for (; p != base + n; p++)
  102a42:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a49:	89 d0                	mov    %edx,%eax
  102a4b:	c1 e0 02             	shl    $0x2,%eax
  102a4e:	01 d0                	add    %edx,%eax
  102a50:	c1 e0 02             	shl    $0x2,%eax
  102a53:	89 c2                	mov    %eax,%edx
  102a55:	8b 45 08             	mov    0x8(%ebp),%eax
  102a58:	01 d0                	add    %edx,%eax
  102a5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a5d:	0f 85 40 ff ff ff    	jne    1029a3 <default_init_memmap+0x3b>
		ClearPageReserved(p);
		SetPageProperty(p);
		p->property = 0;
		set_page_ref(p, 0);
	}
	base->property = n;
  102a63:	8b 45 08             	mov    0x8(%ebp),%eax
  102a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a69:	89 50 08             	mov    %edx,0x8(%eax)
	nr_free += n;
  102a6c:	8b 15 d8 89 11 00    	mov    0x1189d8,%edx
  102a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a75:	01 d0                	add    %edx,%eax
  102a77:	a3 d8 89 11 00       	mov    %eax,0x1189d8
  102a7c:	c7 45 d0 d0 89 11 00 	movl   $0x1189d0,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a86:	8b 40 04             	mov    0x4(%eax),%eax
	
	list_entry_t *le = list_next(&free_list);
  102a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list)
  102a8c:	eb 6c                	jmp    102afa <default_init_memmap+0x192>
	{
		p = le2page(le, page_link);
  102a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a91:	83 e8 0c             	sub    $0xc,%eax
  102a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base < p)
  102a97:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a9d:	73 4c                	jae    102aeb <default_init_memmap+0x183>
		{
			list_add_before(&(p->page_link), &(base->page_link));
  102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa2:	83 c0 0c             	add    $0xc,%eax
  102aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aa8:	83 c2 0c             	add    $0xc,%edx
  102aab:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102aae:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102ab1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ab4:	8b 00                	mov    (%eax),%eax
  102ab6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ab9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102abc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102abf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ac2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ac5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ac8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102acb:	89 10                	mov    %edx,(%eax)
  102acd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ad0:	8b 10                	mov    (%eax),%edx
  102ad2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ad5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ad8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102adb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ade:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ae1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ae4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ae7:	89 10                	mov    %edx,(%eax)
			return;
  102ae9:	eb 60                	jmp    102b4b <default_init_memmap+0x1e3>
  102aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aee:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102af1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102af4:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  102af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}
	base->property = n;
	nr_free += n;
	
	list_entry_t *le = list_next(&free_list);
	while (le != &free_list)
  102afa:	81 7d f0 d0 89 11 00 	cmpl   $0x1189d0,-0x10(%ebp)
  102b01:	75 8b                	jne    102a8e <default_init_memmap+0x126>
			list_add_before(&(p->page_link), &(base->page_link));
			return;
		}
		le = list_next(le);
	}	
	list_add_before(&free_list, &(base->page_link));
  102b03:	8b 45 08             	mov    0x8(%ebp),%eax
  102b06:	83 c0 0c             	add    $0xc,%eax
  102b09:	c7 45 b4 d0 89 11 00 	movl   $0x1189d0,-0x4c(%ebp)
  102b10:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b13:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b16:	8b 00                	mov    (%eax),%eax
  102b18:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102b1b:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102b1e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102b21:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b24:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b27:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102b2a:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102b2d:	89 10                	mov    %edx,(%eax)
  102b2f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102b32:	8b 10                	mov    (%eax),%edx
  102b34:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102b37:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b3d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102b40:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b43:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b46:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102b49:	89 10                	mov    %edx,(%eax)
}
  102b4b:	c9                   	leave  
  102b4c:	c3                   	ret    

00102b4d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102b4d:	55                   	push   %ebp
  102b4e:	89 e5                	mov    %esp,%ebp
  102b50:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b57:	75 24                	jne    102b7d <default_alloc_pages+0x30>
  102b59:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  102b60:	00 
  102b61:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102b68:	00 
  102b69:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  102b70:	00 
  102b71:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102b78:	e8 4e e1 ff ff       	call   100ccb <__panic>
    if (n > nr_free) {
  102b7d:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  102b82:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b85:	73 0a                	jae    102b91 <default_alloc_pages+0x44>
        return NULL;
  102b87:	b8 00 00 00 00       	mov    $0x0,%eax
  102b8c:	e9 6f 01 00 00       	jmp    102d00 <default_alloc_pages+0x1b3>
    }
    struct Page *page = NULL;
  102b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b98:	c7 45 f0 d0 89 11 00 	movl   $0x1189d0,-0x10(%ebp)
	list_entry_t *prev_le = NULL;
  102b9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int block_size = 0;
  102ba6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102bad:	eb 1c                	jmp    102bcb <default_alloc_pages+0x7e>
        struct Page *p = le2page(le, page_link);
  102baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb2:	83 e8 0c             	sub    $0xc,%eax
  102bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (p->property >= n) {
  102bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bbb:	8b 40 08             	mov    0x8(%eax),%eax
  102bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bc1:	72 08                	jb     102bcb <default_alloc_pages+0x7e>
            page = p;
  102bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102bc9:	eb 18                	jmp    102be3 <default_alloc_pages+0x96>
  102bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bce:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bd4:	8b 40 04             	mov    0x4(%eax),%eax
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
	list_entry_t *prev_le = NULL;
	int block_size = 0;
    while ((le = list_next(le)) != &free_list) {
  102bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bda:	81 7d f0 d0 89 11 00 	cmpl   $0x1189d0,-0x10(%ebp)
  102be1:	75 cc                	jne    102baf <default_alloc_pages+0x62>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102be7:	0f 84 10 01 00 00    	je     102cfd <default_alloc_pages+0x1b0>
		block_size = page->property;
  102bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf0:	8b 40 08             	mov    0x8(%eax),%eax
  102bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		prev_le = list_prev(&(page->page_link));
  102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf9:	83 c0 0c             	add    $0xc,%eax
  102bfc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102bff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c02:	8b 00                	mov    (%eax),%eax
  102c04:	89 45 e8             	mov    %eax,-0x18(%ebp)
		page->property = 0;
  102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		int i = 0;
  102c11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (;i < n; i++)
  102c18:	eb 2e                	jmp    102c48 <default_alloc_pages+0xfb>
		{
			ClearPageProperty(page+i);
  102c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c1d:	89 d0                	mov    %edx,%eax
  102c1f:	c1 e0 02             	shl    $0x2,%eax
  102c22:	01 d0                	add    %edx,%eax
  102c24:	c1 e0 02             	shl    $0x2,%eax
  102c27:	89 c2                	mov    %eax,%edx
  102c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c2c:	01 d0                	add    %edx,%eax
  102c2e:	83 c0 04             	add    $0x4,%eax
  102c31:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102c38:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c3e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c41:	0f b3 10             	btr    %edx,(%eax)
    if (page != NULL) {
		block_size = page->property;
		prev_le = list_prev(&(page->page_link));
		page->property = 0;
		int i = 0;
		for (;i < n; i++)
  102c44:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  102c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c4e:	72 ca                	jb     102c1a <default_alloc_pages+0xcd>
		{
			ClearPageProperty(page+i);
			//page_ref_inc(page+i); 
		}
        list_del(&(page->page_link));
  102c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c53:	83 c0 0c             	add    $0xc,%eax
  102c56:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c59:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c5c:	8b 40 04             	mov    0x4(%eax),%eax
  102c5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c62:	8b 12                	mov    (%edx),%edx
  102c64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102c67:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c6d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102c70:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c73:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c76:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c79:	89 10                	mov    %edx,(%eax)
        if (block_size > n) {
  102c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c81:	76 6d                	jbe    102cf0 <default_alloc_pages+0x1a3>
            struct Page *p = page + n;
  102c83:	8b 55 08             	mov    0x8(%ebp),%edx
  102c86:	89 d0                	mov    %edx,%eax
  102c88:	c1 e0 02             	shl    $0x2,%eax
  102c8b:	01 d0                	add    %edx,%eax
  102c8d:	c1 e0 02             	shl    $0x2,%eax
  102c90:	89 c2                	mov    %eax,%edx
  102c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c95:	01 d0                	add    %edx,%eax
  102c97:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = block_size - n;
  102c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c9d:	2b 45 08             	sub    0x8(%ebp),%eax
  102ca0:	89 c2                	mov    %eax,%edx
  102ca2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ca5:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(prev_le, &(p->page_link));
  102ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cab:	8d 50 0c             	lea    0xc(%eax),%edx
  102cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cb1:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102cb4:	89 55 b8             	mov    %edx,-0x48(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102cb7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102cba:	8b 40 04             	mov    0x4(%eax),%eax
  102cbd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cc0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102cc3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cc6:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102cc9:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ccc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102ccf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102cd2:	89 10                	mov    %edx,(%eax)
  102cd4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102cd7:	8b 10                	mov    (%eax),%edx
  102cd9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102cdc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cdf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ce2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102ce5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ce8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ceb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102cee:	89 10                	mov    %edx,(%eax)
    	}
        nr_free -= n;
  102cf0:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  102cf5:	2b 45 08             	sub    0x8(%ebp),%eax
  102cf8:	a3 d8 89 11 00       	mov    %eax,0x1189d8
    }
    return page;
  102cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d00:	c9                   	leave  
  102d01:	c3                   	ret    

00102d02 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102d02:	55                   	push   %ebp
  102d03:	89 e5                	mov    %esp,%ebp
  102d05:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d0f:	75 24                	jne    102d35 <default_free_pages+0x33>
  102d11:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  102d18:	00 
  102d19:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102d20:	00 
  102d21:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  102d28:	00 
  102d29:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102d30:	e8 96 df ff ff       	call   100ccb <__panic>
    struct Page *p = base;
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102d3b:	e9 ac 00 00 00       	jmp    102dec <default_free_pages+0xea>
        assert(!PageReserved(p) && !PageProperty(p));
  102d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d43:	83 c0 04             	add    $0x4,%eax
  102d46:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102d4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d56:	0f a3 10             	bt     %edx,(%eax)
  102d59:	19 c0                	sbb    %eax,%eax
  102d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102d5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d62:	0f 95 c0             	setne  %al
  102d65:	0f b6 c0             	movzbl %al,%eax
  102d68:	85 c0                	test   %eax,%eax
  102d6a:	75 2c                	jne    102d98 <default_free_pages+0x96>
  102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6f:	83 c0 04             	add    $0x4,%eax
  102d72:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102d79:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102d82:	0f a3 10             	bt     %edx,(%eax)
  102d85:	19 c0                	sbb    %eax,%eax
  102d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102d8a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102d8e:	0f 95 c0             	setne  %al
  102d91:	0f b6 c0             	movzbl %al,%eax
  102d94:	85 c0                	test   %eax,%eax
  102d96:	74 24                	je     102dbc <default_free_pages+0xba>
  102d98:	c7 44 24 0c 14 69 10 	movl   $0x106914,0xc(%esp)
  102d9f:	00 
  102da0:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  102da7:	00 
  102da8:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  102daf:	00 
  102db0:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  102db7:	e8 0f df ff ff       	call   100ccb <__panic>
		SetPageProperty(p);  
  102dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbf:	83 c0 04             	add    $0x4,%eax
  102dc2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102dc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102dcf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102dd2:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  102dd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102ddc:	00 
  102ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de0:	89 04 24             	mov    %eax,(%esp)
  102de3:	e8 46 fb ff ff       	call   10292e <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102de8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  102def:	89 d0                	mov    %edx,%eax
  102df1:	c1 e0 02             	shl    $0x2,%eax
  102df4:	01 d0                	add    %edx,%eax
  102df6:	c1 e0 02             	shl    $0x2,%eax
  102df9:	89 c2                	mov    %eax,%edx
  102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfe:	01 d0                	add    %edx,%eax
  102e00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e03:	0f 85 37 ff ff ff    	jne    102d40 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
		SetPageProperty(p);  
        set_page_ref(p, 0);
    }
    base->property = n;
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e0f:	89 50 08             	mov    %edx,0x8(%eax)
  102e12:	c7 45 cc d0 89 11 00 	movl   $0x1189d0,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e1c:	8b 40 04             	mov    0x4(%eax),%eax

	list_entry_t *le = list_next(&free_list);
  102e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list) {
  102e22:	eb 7f                	jmp    102ea3 <default_free_pages+0x1a1>
		p = le2page(le, page_link);
  102e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e27:	83 e8 0c             	sub    $0xc,%eax
  102e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base + base->property == p) {
  102e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e30:	8b 50 08             	mov    0x8(%eax),%edx
  102e33:	89 d0                	mov    %edx,%eax
  102e35:	c1 e0 02             	shl    $0x2,%eax
  102e38:	01 d0                	add    %edx,%eax
  102e3a:	c1 e0 02             	shl    $0x2,%eax
  102e3d:	89 c2                	mov    %eax,%edx
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	01 d0                	add    %edx,%eax
  102e44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e47:	75 4b                	jne    102e94 <default_free_pages+0x192>
			base->property += p->property;
  102e49:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4c:	8b 50 08             	mov    0x8(%eax),%edx
  102e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e52:	8b 40 08             	mov    0x8(%eax),%eax
  102e55:	01 c2                	add    %eax,%edx
  102e57:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5a:	89 50 08             	mov    %edx,0x8(%eax)
			p->property = 0;
  102e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			list_del(&(p->page_link));
  102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6a:	83 c0 0c             	add    $0xc,%eax
  102e6d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e70:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e73:	8b 40 04             	mov    0x4(%eax),%eax
  102e76:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102e79:	8b 12                	mov    (%edx),%edx
  102e7b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102e7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e84:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102e87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e8a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e8d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102e90:	89 10                	mov    %edx,(%eax)
			break;
  102e92:	eb 1c                	jmp    102eb0 <default_free_pages+0x1ae>
  102e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e97:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e9d:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  102ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;

	list_entry_t *le = list_next(&free_list);
	while (le != &free_list) {
  102ea3:	81 7d f0 d0 89 11 00 	cmpl   $0x1189d0,-0x10(%ebp)
  102eaa:	0f 85 74 ff ff ff    	jne    102e24 <default_free_pages+0x122>
  102eb0:	c7 45 b8 d0 89 11 00 	movl   $0x1189d0,-0x48(%ebp)
  102eb7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102eba:	8b 40 04             	mov    0x4(%eax),%eax
			break;
		}
		le = list_next(le);
	}
	
	le = list_next(&free_list);
  102ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list) {
  102ec0:	e9 85 00 00 00       	jmp    102f4a <default_free_pages+0x248>
		p = le2page(le, page_link);
  102ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec8:	83 e8 0c             	sub    $0xc,%eax
  102ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p + p->property == base) {
  102ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed1:	8b 50 08             	mov    0x8(%eax),%edx
  102ed4:	89 d0                	mov    %edx,%eax
  102ed6:	c1 e0 02             	shl    $0x2,%eax
  102ed9:	01 d0                	add    %edx,%eax
  102edb:	c1 e0 02             	shl    $0x2,%eax
  102ede:	89 c2                	mov    %eax,%edx
  102ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee3:	01 d0                	add    %edx,%eax
  102ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ee8:	75 51                	jne    102f3b <default_free_pages+0x239>
			p->property += base->property;
  102eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eed:	8b 50 08             	mov    0x8(%eax),%edx
  102ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef3:	8b 40 08             	mov    0x8(%eax),%eax
  102ef6:	01 c2                	add    %eax,%edx
  102ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efb:	89 50 08             	mov    %edx,0x8(%eax)
			base->property = 0;
  102efe:	8b 45 08             	mov    0x8(%ebp),%eax
  102f01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			base = p;
  102f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f0b:	89 45 08             	mov    %eax,0x8(%ebp)
			list_del(&(p->page_link));
  102f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f11:	83 c0 0c             	add    $0xc,%eax
  102f14:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102f17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102f1a:	8b 40 04             	mov    0x4(%eax),%eax
  102f1d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102f20:	8b 12                	mov    (%edx),%edx
  102f22:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102f25:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102f28:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f2b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102f2e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f31:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f34:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102f37:	89 10                	mov    %edx,(%eax)
			break;
  102f39:	eb 1c                	jmp    102f57 <default_free_pages+0x255>
  102f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102f41:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f44:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  102f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
		}
		le = list_next(le);
	}
	
	le = list_next(&free_list);
	while (le != &free_list) {
  102f4a:	81 7d f0 d0 89 11 00 	cmpl   $0x1189d0,-0x10(%ebp)
  102f51:	0f 85 6e ff ff ff    	jne    102ec5 <default_free_pages+0x1c3>
			list_del(&(p->page_link));
			break;
		}
		le = list_next(le);
	}
	nr_free += n;
  102f57:	8b 15 d8 89 11 00    	mov    0x1189d8,%edx
  102f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f60:	01 d0                	add    %edx,%eax
  102f62:	a3 d8 89 11 00       	mov    %eax,0x1189d8
  102f67:	c7 45 a4 d0 89 11 00 	movl   $0x1189d0,-0x5c(%ebp)
  102f6e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f71:	8b 40 04             	mov    0x4(%eax),%eax
	
	le = list_next(&free_list);
  102f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list)
  102f77:	eb 6c                	jmp    102fe5 <default_free_pages+0x2e3>
	{
		p = le2page(le, page_link);
  102f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7c:	83 e8 0c             	sub    $0xc,%eax
  102f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base < p)
  102f82:	8b 45 08             	mov    0x8(%ebp),%eax
  102f85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f88:	73 4c                	jae    102fd6 <default_free_pages+0x2d4>
		{
			list_add_before(&(p->page_link), &(base->page_link));
  102f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8d:	83 c0 0c             	add    $0xc,%eax
  102f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f93:	83 c2 0c             	add    $0xc,%edx
  102f96:	89 55 a0             	mov    %edx,-0x60(%ebp)
  102f99:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102f9c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f9f:	8b 00                	mov    (%eax),%eax
  102fa1:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102fa4:	89 55 98             	mov    %edx,-0x68(%ebp)
  102fa7:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102faa:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102fad:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102fb0:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fb3:	8b 55 98             	mov    -0x68(%ebp),%edx
  102fb6:	89 10                	mov    %edx,(%eax)
  102fb8:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fbb:	8b 10                	mov    (%eax),%edx
  102fbd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102fc0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102fc3:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fc6:	8b 55 90             	mov    -0x70(%ebp),%edx
  102fc9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102fcc:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fcf:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102fd2:	89 10                	mov    %edx,(%eax)
			return;
  102fd4:	eb 75                	jmp    10304b <default_free_pages+0x349>
  102fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fd9:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102fdc:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102fdf:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  102fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		le = list_next(le);
	}
	nr_free += n;
	
	le = list_next(&free_list);
	while (le != &free_list)
  102fe5:	81 7d f0 d0 89 11 00 	cmpl   $0x1189d0,-0x10(%ebp)
  102fec:	75 8b                	jne    102f79 <default_free_pages+0x277>
			list_add_before(&(p->page_link), &(base->page_link));
			return;
		}
		le = list_next(le);
	}	
	list_add_before(&free_list, &(base->page_link));
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	83 c0 0c             	add    $0xc,%eax
  102ff4:	c7 45 88 d0 89 11 00 	movl   $0x1189d0,-0x78(%ebp)
  102ffb:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102ffe:	8b 45 88             	mov    -0x78(%ebp),%eax
  103001:	8b 00                	mov    (%eax),%eax
  103003:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103006:	89 55 80             	mov    %edx,-0x80(%ebp)
  103009:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  10300f:	8b 45 88             	mov    -0x78(%ebp),%eax
  103012:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103018:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10301e:	8b 55 80             	mov    -0x80(%ebp),%edx
  103021:	89 10                	mov    %edx,(%eax)
  103023:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103029:	8b 10                	mov    (%eax),%edx
  10302b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103031:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103034:	8b 45 80             	mov    -0x80(%ebp),%eax
  103037:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  10303d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103040:	8b 45 80             	mov    -0x80(%ebp),%eax
  103043:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103049:	89 10                	mov    %edx,(%eax)
}
  10304b:	c9                   	leave  
  10304c:	c3                   	ret    

0010304d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10304d:	55                   	push   %ebp
  10304e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103050:	a1 d8 89 11 00       	mov    0x1189d8,%eax
}
  103055:	5d                   	pop    %ebp
  103056:	c3                   	ret    

00103057 <basic_check>:

static void
basic_check(void) {
  103057:	55                   	push   %ebp
  103058:	89 e5                	mov    %esp,%ebp
  10305a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10305d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103067:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103077:	e8 85 0e 00 00       	call   103f01 <alloc_pages>
  10307c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10307f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103083:	75 24                	jne    1030a9 <basic_check+0x52>
  103085:	c7 44 24 0c 39 69 10 	movl   $0x106939,0xc(%esp)
  10308c:	00 
  10308d:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103094:	00 
  103095:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  10309c:	00 
  10309d:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1030a4:	e8 22 dc ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030b0:	e8 4c 0e 00 00       	call   103f01 <alloc_pages>
  1030b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030bc:	75 24                	jne    1030e2 <basic_check+0x8b>
  1030be:	c7 44 24 0c 55 69 10 	movl   $0x106955,0xc(%esp)
  1030c5:	00 
  1030c6:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1030cd:	00 
  1030ce:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  1030d5:	00 
  1030d6:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1030dd:	e8 e9 db ff ff       	call   100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030e9:	e8 13 0e 00 00       	call   103f01 <alloc_pages>
  1030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030f5:	75 24                	jne    10311b <basic_check+0xc4>
  1030f7:	c7 44 24 0c 71 69 10 	movl   $0x106971,0xc(%esp)
  1030fe:	00 
  1030ff:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103106:	00 
  103107:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  10310e:	00 
  10310f:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103116:	e8 b0 db ff ff       	call   100ccb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10311b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10311e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103121:	74 10                	je     103133 <basic_check+0xdc>
  103123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103126:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103129:	74 08                	je     103133 <basic_check+0xdc>
  10312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103131:	75 24                	jne    103157 <basic_check+0x100>
  103133:	c7 44 24 0c 90 69 10 	movl   $0x106990,0xc(%esp)
  10313a:	00 
  10313b:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103142:	00 
  103143:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  10314a:	00 
  10314b:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103152:	e8 74 db ff ff       	call   100ccb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315a:	89 04 24             	mov    %eax,(%esp)
  10315d:	e8 c2 f7 ff ff       	call   102924 <page_ref>
  103162:	85 c0                	test   %eax,%eax
  103164:	75 1e                	jne    103184 <basic_check+0x12d>
  103166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103169:	89 04 24             	mov    %eax,(%esp)
  10316c:	e8 b3 f7 ff ff       	call   102924 <page_ref>
  103171:	85 c0                	test   %eax,%eax
  103173:	75 0f                	jne    103184 <basic_check+0x12d>
  103175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103178:	89 04 24             	mov    %eax,(%esp)
  10317b:	e8 a4 f7 ff ff       	call   102924 <page_ref>
  103180:	85 c0                	test   %eax,%eax
  103182:	74 24                	je     1031a8 <basic_check+0x151>
  103184:	c7 44 24 0c b4 69 10 	movl   $0x1069b4,0xc(%esp)
  10318b:	00 
  10318c:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103193:	00 
  103194:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  10319b:	00 
  10319c:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1031a3:	e8 23 db ff ff       	call   100ccb <__panic>
	
    assert(page2pa(p0) < npage * PGSIZE);
  1031a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031ab:	89 04 24             	mov    %eax,(%esp)
  1031ae:	e8 5b f7 ff ff       	call   10290e <page2pa>
  1031b3:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  1031b9:	c1 e2 0c             	shl    $0xc,%edx
  1031bc:	39 d0                	cmp    %edx,%eax
  1031be:	72 24                	jb     1031e4 <basic_check+0x18d>
  1031c0:	c7 44 24 0c f0 69 10 	movl   $0x1069f0,0xc(%esp)
  1031c7:	00 
  1031c8:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1031cf:	00 
  1031d0:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  1031d7:	00 
  1031d8:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1031df:	e8 e7 da ff ff       	call   100ccb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e7:	89 04 24             	mov    %eax,(%esp)
  1031ea:	e8 1f f7 ff ff       	call   10290e <page2pa>
  1031ef:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  1031f5:	c1 e2 0c             	shl    $0xc,%edx
  1031f8:	39 d0                	cmp    %edx,%eax
  1031fa:	72 24                	jb     103220 <basic_check+0x1c9>
  1031fc:	c7 44 24 0c 0d 6a 10 	movl   $0x106a0d,0xc(%esp)
  103203:	00 
  103204:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10320b:	00 
  10320c:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  103213:	00 
  103214:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10321b:	e8 ab da ff ff       	call   100ccb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103223:	89 04 24             	mov    %eax,(%esp)
  103226:	e8 e3 f6 ff ff       	call   10290e <page2pa>
  10322b:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  103231:	c1 e2 0c             	shl    $0xc,%edx
  103234:	39 d0                	cmp    %edx,%eax
  103236:	72 24                	jb     10325c <basic_check+0x205>
  103238:	c7 44 24 0c 2a 6a 10 	movl   $0x106a2a,0xc(%esp)
  10323f:	00 
  103240:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103247:	00 
  103248:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  10324f:	00 
  103250:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103257:	e8 6f da ff ff       	call   100ccb <__panic>

    list_entry_t free_list_store = free_list;
  10325c:	a1 d0 89 11 00       	mov    0x1189d0,%eax
  103261:	8b 15 d4 89 11 00    	mov    0x1189d4,%edx
  103267:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10326a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10326d:	c7 45 e0 d0 89 11 00 	movl   $0x1189d0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103277:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10327a:	89 50 04             	mov    %edx,0x4(%eax)
  10327d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103280:	8b 50 04             	mov    0x4(%eax),%edx
  103283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103286:	89 10                	mov    %edx,(%eax)
  103288:	c7 45 dc d0 89 11 00 	movl   $0x1189d0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10328f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103292:	8b 40 04             	mov    0x4(%eax),%eax
  103295:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103298:	0f 94 c0             	sete   %al
  10329b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10329e:	85 c0                	test   %eax,%eax
  1032a0:	75 24                	jne    1032c6 <basic_check+0x26f>
  1032a2:	c7 44 24 0c 47 6a 10 	movl   $0x106a47,0xc(%esp)
  1032a9:	00 
  1032aa:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1032b1:	00 
  1032b2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  1032b9:	00 
  1032ba:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1032c1:	e8 05 da ff ff       	call   100ccb <__panic>

    unsigned int nr_free_store = nr_free;
  1032c6:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  1032cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032ce:	c7 05 d8 89 11 00 00 	movl   $0x0,0x1189d8
  1032d5:	00 00 00 

    assert(alloc_page() == NULL);
  1032d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032df:	e8 1d 0c 00 00       	call   103f01 <alloc_pages>
  1032e4:	85 c0                	test   %eax,%eax
  1032e6:	74 24                	je     10330c <basic_check+0x2b5>
  1032e8:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1032ef:	00 
  1032f0:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1032f7:	00 
  1032f8:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  1032ff:	00 
  103300:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103307:	e8 bf d9 ff ff       	call   100ccb <__panic>

    free_page(p0);
  10330c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103313:	00 
  103314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103317:	89 04 24             	mov    %eax,(%esp)
  10331a:	e8 1a 0c 00 00       	call   103f39 <free_pages>
    free_page(p1);
  10331f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103326:	00 
  103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10332a:	89 04 24             	mov    %eax,(%esp)
  10332d:	e8 07 0c 00 00       	call   103f39 <free_pages>
    free_page(p2);
  103332:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103339:	00 
  10333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10333d:	89 04 24             	mov    %eax,(%esp)
  103340:	e8 f4 0b 00 00       	call   103f39 <free_pages>
    assert(nr_free == 3);
  103345:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  10334a:	83 f8 03             	cmp    $0x3,%eax
  10334d:	74 24                	je     103373 <basic_check+0x31c>
  10334f:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  103356:	00 
  103357:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10335e:	00 
  10335f:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  103366:	00 
  103367:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10336e:	e8 58 d9 ff ff       	call   100ccb <__panic>

    assert((p0 = alloc_page()) != NULL);
  103373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10337a:	e8 82 0b 00 00       	call   103f01 <alloc_pages>
  10337f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103382:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103386:	75 24                	jne    1033ac <basic_check+0x355>
  103388:	c7 44 24 0c 39 69 10 	movl   $0x106939,0xc(%esp)
  10338f:	00 
  103390:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103397:	00 
  103398:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10339f:	00 
  1033a0:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1033a7:	e8 1f d9 ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033b3:	e8 49 0b 00 00       	call   103f01 <alloc_pages>
  1033b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033bf:	75 24                	jne    1033e5 <basic_check+0x38e>
  1033c1:	c7 44 24 0c 55 69 10 	movl   $0x106955,0xc(%esp)
  1033c8:	00 
  1033c9:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1033d0:	00 
  1033d1:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1033d8:	00 
  1033d9:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1033e0:	e8 e6 d8 ff ff       	call   100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033ec:	e8 10 0b 00 00       	call   103f01 <alloc_pages>
  1033f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033f8:	75 24                	jne    10341e <basic_check+0x3c7>
  1033fa:	c7 44 24 0c 71 69 10 	movl   $0x106971,0xc(%esp)
  103401:	00 
  103402:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103409:	00 
  10340a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  103411:	00 
  103412:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103419:	e8 ad d8 ff ff       	call   100ccb <__panic>

    assert(alloc_page() == NULL);
  10341e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103425:	e8 d7 0a 00 00       	call   103f01 <alloc_pages>
  10342a:	85 c0                	test   %eax,%eax
  10342c:	74 24                	je     103452 <basic_check+0x3fb>
  10342e:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  103435:	00 
  103436:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10343d:	00 
  10343e:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  103445:	00 
  103446:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10344d:	e8 79 d8 ff ff       	call   100ccb <__panic>

    free_page(p0);
  103452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103459:	00 
  10345a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10345d:	89 04 24             	mov    %eax,(%esp)
  103460:	e8 d4 0a 00 00       	call   103f39 <free_pages>
  103465:	c7 45 d8 d0 89 11 00 	movl   $0x1189d0,-0x28(%ebp)
  10346c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10346f:	8b 40 04             	mov    0x4(%eax),%eax
  103472:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103475:	0f 94 c0             	sete   %al
  103478:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10347b:	85 c0                	test   %eax,%eax
  10347d:	74 24                	je     1034a3 <basic_check+0x44c>
  10347f:	c7 44 24 0c 80 6a 10 	movl   $0x106a80,0xc(%esp)
  103486:	00 
  103487:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10348e:	00 
  10348f:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103496:	00 
  103497:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10349e:	e8 28 d8 ff ff       	call   100ccb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034aa:	e8 52 0a 00 00       	call   103f01 <alloc_pages>
  1034af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034b8:	74 24                	je     1034de <basic_check+0x487>
  1034ba:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  1034c1:	00 
  1034c2:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1034c9:	00 
  1034ca:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1034d1:	00 
  1034d2:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1034d9:	e8 ed d7 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  1034de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034e5:	e8 17 0a 00 00       	call   103f01 <alloc_pages>
  1034ea:	85 c0                	test   %eax,%eax
  1034ec:	74 24                	je     103512 <basic_check+0x4bb>
  1034ee:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1034f5:	00 
  1034f6:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1034fd:	00 
  1034fe:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103505:	00 
  103506:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10350d:	e8 b9 d7 ff ff       	call   100ccb <__panic>
	
    assert(nr_free == 0);
  103512:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  103517:	85 c0                	test   %eax,%eax
  103519:	74 24                	je     10353f <basic_check+0x4e8>
  10351b:	c7 44 24 0c b1 6a 10 	movl   $0x106ab1,0xc(%esp)
  103522:	00 
  103523:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10352a:	00 
  10352b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103532:	00 
  103533:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10353a:	e8 8c d7 ff ff       	call   100ccb <__panic>
    free_list = free_list_store;
  10353f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103545:	a3 d0 89 11 00       	mov    %eax,0x1189d0
  10354a:	89 15 d4 89 11 00    	mov    %edx,0x1189d4
    nr_free = nr_free_store;
  103550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103553:	a3 d8 89 11 00       	mov    %eax,0x1189d8

    free_page(p);
  103558:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10355f:	00 
  103560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103563:	89 04 24             	mov    %eax,(%esp)
  103566:	e8 ce 09 00 00       	call   103f39 <free_pages>
    free_page(p1);
  10356b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103572:	00 
  103573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103576:	89 04 24             	mov    %eax,(%esp)
  103579:	e8 bb 09 00 00       	call   103f39 <free_pages>
    free_page(p2);
  10357e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103585:	00 
  103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103589:	89 04 24             	mov    %eax,(%esp)
  10358c:	e8 a8 09 00 00       	call   103f39 <free_pages>
}
  103591:	c9                   	leave  
  103592:	c3                   	ret    

00103593 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103593:	55                   	push   %ebp
  103594:	89 e5                	mov    %esp,%ebp
  103596:	53                   	push   %ebx
  103597:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10359d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035ab:	c7 45 ec d0 89 11 00 	movl   $0x1189d0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1035b2:	eb 6b                	jmp    10361f <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b7:	83 e8 0c             	sub    $0xc,%eax
  1035ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1035bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035c0:	83 c0 04             	add    $0x4,%eax
  1035c3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035d3:	0f a3 10             	bt     %edx,(%eax)
  1035d6:	19 c0                	sbb    %eax,%eax
  1035d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035df:	0f 95 c0             	setne  %al
  1035e2:	0f b6 c0             	movzbl %al,%eax
  1035e5:	85 c0                	test   %eax,%eax
  1035e7:	75 24                	jne    10360d <default_check+0x7a>
  1035e9:	c7 44 24 0c be 6a 10 	movl   $0x106abe,0xc(%esp)
  1035f0:	00 
  1035f1:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1035f8:	00 
  1035f9:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103600:	00 
  103601:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103608:	e8 be d6 ff ff       	call   100ccb <__panic>
        count ++, total += p->property;
  10360d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103611:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103614:	8b 50 08             	mov    0x8(%eax),%edx
  103617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10361a:	01 d0                	add    %edx,%eax
  10361c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10361f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103622:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103625:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103628:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10362b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10362e:	81 7d ec d0 89 11 00 	cmpl   $0x1189d0,-0x14(%ebp)
  103635:	0f 85 79 ff ff ff    	jne    1035b4 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10363b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10363e:	e8 28 09 00 00       	call   103f6b <nr_free_pages>
  103643:	39 c3                	cmp    %eax,%ebx
  103645:	74 24                	je     10366b <default_check+0xd8>
  103647:	c7 44 24 0c ce 6a 10 	movl   $0x106ace,0xc(%esp)
  10364e:	00 
  10364f:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103656:	00 
  103657:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  10365e:	00 
  10365f:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103666:	e8 60 d6 ff ff       	call   100ccb <__panic>

    basic_check();
  10366b:	e8 e7 f9 ff ff       	call   103057 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103670:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103677:	e8 85 08 00 00       	call   103f01 <alloc_pages>
  10367c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10367f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103683:	75 24                	jne    1036a9 <default_check+0x116>
  103685:	c7 44 24 0c e7 6a 10 	movl   $0x106ae7,0xc(%esp)
  10368c:	00 
  10368d:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103694:	00 
  103695:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10369c:	00 
  10369d:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1036a4:	e8 22 d6 ff ff       	call   100ccb <__panic>
    assert(!PageProperty(p0));
  1036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ac:	83 c0 04             	add    $0x4,%eax
  1036af:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036bc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036bf:	0f a3 10             	bt     %edx,(%eax)
  1036c2:	19 c0                	sbb    %eax,%eax
  1036c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036c7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036cb:	0f 95 c0             	setne  %al
  1036ce:	0f b6 c0             	movzbl %al,%eax
  1036d1:	85 c0                	test   %eax,%eax
  1036d3:	74 24                	je     1036f9 <default_check+0x166>
  1036d5:	c7 44 24 0c f2 6a 10 	movl   $0x106af2,0xc(%esp)
  1036dc:	00 
  1036dd:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1036e4:	00 
  1036e5:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1036ec:	00 
  1036ed:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1036f4:	e8 d2 d5 ff ff       	call   100ccb <__panic>

    list_entry_t free_list_store = free_list;
  1036f9:	a1 d0 89 11 00       	mov    0x1189d0,%eax
  1036fe:	8b 15 d4 89 11 00    	mov    0x1189d4,%edx
  103704:	89 45 80             	mov    %eax,-0x80(%ebp)
  103707:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10370a:	c7 45 b4 d0 89 11 00 	movl   $0x1189d0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103711:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103714:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103717:	89 50 04             	mov    %edx,0x4(%eax)
  10371a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10371d:	8b 50 04             	mov    0x4(%eax),%edx
  103720:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103723:	89 10                	mov    %edx,(%eax)
  103725:	c7 45 b0 d0 89 11 00 	movl   $0x1189d0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10372c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10372f:	8b 40 04             	mov    0x4(%eax),%eax
  103732:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103735:	0f 94 c0             	sete   %al
  103738:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10373b:	85 c0                	test   %eax,%eax
  10373d:	75 24                	jne    103763 <default_check+0x1d0>
  10373f:	c7 44 24 0c 47 6a 10 	movl   $0x106a47,0xc(%esp)
  103746:	00 
  103747:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10374e:	00 
  10374f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  103756:	00 
  103757:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10375e:	e8 68 d5 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  103763:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10376a:	e8 92 07 00 00       	call   103f01 <alloc_pages>
  10376f:	85 c0                	test   %eax,%eax
  103771:	74 24                	je     103797 <default_check+0x204>
  103773:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  10377a:	00 
  10377b:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103782:	00 
  103783:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10378a:	00 
  10378b:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103792:	e8 34 d5 ff ff       	call   100ccb <__panic>

    unsigned int nr_free_store = nr_free;
  103797:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  10379c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10379f:	c7 05 d8 89 11 00 00 	movl   $0x0,0x1189d8
  1037a6:	00 00 00 

    free_pages(p0 + 2, 3);
  1037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037ac:	83 c0 28             	add    $0x28,%eax
  1037af:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037b6:	00 
  1037b7:	89 04 24             	mov    %eax,(%esp)
  1037ba:	e8 7a 07 00 00       	call   103f39 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037bf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037c6:	e8 36 07 00 00       	call   103f01 <alloc_pages>
  1037cb:	85 c0                	test   %eax,%eax
  1037cd:	74 24                	je     1037f3 <default_check+0x260>
  1037cf:	c7 44 24 0c 04 6b 10 	movl   $0x106b04,0xc(%esp)
  1037d6:	00 
  1037d7:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1037de:	00 
  1037df:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1037e6:	00 
  1037e7:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1037ee:	e8 d8 d4 ff ff       	call   100ccb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037f6:	83 c0 28             	add    $0x28,%eax
  1037f9:	83 c0 04             	add    $0x4,%eax
  1037fc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103803:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103806:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103809:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10380c:	0f a3 10             	bt     %edx,(%eax)
  10380f:	19 c0                	sbb    %eax,%eax
  103811:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103814:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103818:	0f 95 c0             	setne  %al
  10381b:	0f b6 c0             	movzbl %al,%eax
  10381e:	85 c0                	test   %eax,%eax
  103820:	74 0e                	je     103830 <default_check+0x29d>
  103822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103825:	83 c0 28             	add    $0x28,%eax
  103828:	8b 40 08             	mov    0x8(%eax),%eax
  10382b:	83 f8 03             	cmp    $0x3,%eax
  10382e:	74 24                	je     103854 <default_check+0x2c1>
  103830:	c7 44 24 0c 1c 6b 10 	movl   $0x106b1c,0xc(%esp)
  103837:	00 
  103838:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  10383f:	00 
  103840:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  103847:	00 
  103848:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  10384f:	e8 77 d4 ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103854:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10385b:	e8 a1 06 00 00       	call   103f01 <alloc_pages>
  103860:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103863:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103867:	75 24                	jne    10388d <default_check+0x2fa>
  103869:	c7 44 24 0c 48 6b 10 	movl   $0x106b48,0xc(%esp)
  103870:	00 
  103871:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103878:	00 
  103879:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103880:	00 
  103881:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103888:	e8 3e d4 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  10388d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103894:	e8 68 06 00 00       	call   103f01 <alloc_pages>
  103899:	85 c0                	test   %eax,%eax
  10389b:	74 24                	je     1038c1 <default_check+0x32e>
  10389d:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1038a4:	00 
  1038a5:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1038ac:	00 
  1038ad:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1038b4:	00 
  1038b5:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1038bc:	e8 0a d4 ff ff       	call   100ccb <__panic>
    assert(p0 + 2 == p1);
  1038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038c4:	83 c0 28             	add    $0x28,%eax
  1038c7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1038ca:	74 24                	je     1038f0 <default_check+0x35d>
  1038cc:	c7 44 24 0c 66 6b 10 	movl   $0x106b66,0xc(%esp)
  1038d3:	00 
  1038d4:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1038db:	00 
  1038dc:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  1038e3:	00 
  1038e4:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1038eb:	e8 db d3 ff ff       	call   100ccb <__panic>

    p2 = p0 + 1;
  1038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038f3:	83 c0 14             	add    $0x14,%eax
  1038f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1038f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103900:	00 
  103901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103904:	89 04 24             	mov    %eax,(%esp)
  103907:	e8 2d 06 00 00       	call   103f39 <free_pages>
    free_pages(p1, 3);
  10390c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103913:	00 
  103914:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103917:	89 04 24             	mov    %eax,(%esp)
  10391a:	e8 1a 06 00 00       	call   103f39 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103922:	83 c0 04             	add    $0x4,%eax
  103925:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10392c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10392f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103932:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103935:	0f a3 10             	bt     %edx,(%eax)
  103938:	19 c0                	sbb    %eax,%eax
  10393a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10393d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103941:	0f 95 c0             	setne  %al
  103944:	0f b6 c0             	movzbl %al,%eax
  103947:	85 c0                	test   %eax,%eax
  103949:	74 0b                	je     103956 <default_check+0x3c3>
  10394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10394e:	8b 40 08             	mov    0x8(%eax),%eax
  103951:	83 f8 01             	cmp    $0x1,%eax
  103954:	74 24                	je     10397a <default_check+0x3e7>
  103956:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  10395d:	00 
  10395e:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103965:	00 
  103966:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10396d:	00 
  10396e:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103975:	e8 51 d3 ff ff       	call   100ccb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10397d:	83 c0 04             	add    $0x4,%eax
  103980:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103987:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10398a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10398d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103990:	0f a3 10             	bt     %edx,(%eax)
  103993:	19 c0                	sbb    %eax,%eax
  103995:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103998:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10399c:	0f 95 c0             	setne  %al
  10399f:	0f b6 c0             	movzbl %al,%eax
  1039a2:	85 c0                	test   %eax,%eax
  1039a4:	74 0b                	je     1039b1 <default_check+0x41e>
  1039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039a9:	8b 40 08             	mov    0x8(%eax),%eax
  1039ac:	83 f8 03             	cmp    $0x3,%eax
  1039af:	74 24                	je     1039d5 <default_check+0x442>
  1039b1:	c7 44 24 0c 9c 6b 10 	movl   $0x106b9c,0xc(%esp)
  1039b8:	00 
  1039b9:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1039c0:	00 
  1039c1:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1039c8:	00 
  1039c9:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  1039d0:	e8 f6 d2 ff ff       	call   100ccb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039dc:	e8 20 05 00 00       	call   103f01 <alloc_pages>
  1039e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039e7:	83 e8 14             	sub    $0x14,%eax
  1039ea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1039ed:	74 24                	je     103a13 <default_check+0x480>
  1039ef:	c7 44 24 0c c2 6b 10 	movl   $0x106bc2,0xc(%esp)
  1039f6:	00 
  1039f7:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  1039fe:	00 
  1039ff:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  103a06:	00 
  103a07:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103a0e:	e8 b8 d2 ff ff       	call   100ccb <__panic>
    free_page(p0);
  103a13:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a1a:	00 
  103a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a1e:	89 04 24             	mov    %eax,(%esp)
  103a21:	e8 13 05 00 00       	call   103f39 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a26:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a2d:	e8 cf 04 00 00       	call   103f01 <alloc_pages>
  103a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a38:	83 c0 14             	add    $0x14,%eax
  103a3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a3e:	74 24                	je     103a64 <default_check+0x4d1>
  103a40:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  103a47:	00 
  103a48:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103a4f:	00 
  103a50:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  103a57:	00 
  103a58:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103a5f:	e8 67 d2 ff ff       	call   100ccb <__panic>

    free_pages(p0, 2);
  103a64:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a6b:	00 
  103a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a6f:	89 04 24             	mov    %eax,(%esp)
  103a72:	e8 c2 04 00 00       	call   103f39 <free_pages>
    free_page(p2);
  103a77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a7e:	00 
  103a7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a82:	89 04 24             	mov    %eax,(%esp)
  103a85:	e8 af 04 00 00       	call   103f39 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a8a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a91:	e8 6b 04 00 00       	call   103f01 <alloc_pages>
  103a96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103a9d:	75 24                	jne    103ac3 <default_check+0x530>
  103a9f:	c7 44 24 0c 00 6c 10 	movl   $0x106c00,0xc(%esp)
  103aa6:	00 
  103aa7:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103aae:	00 
  103aaf:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  103ab6:	00 
  103ab7:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103abe:	e8 08 d2 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  103ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103aca:	e8 32 04 00 00       	call   103f01 <alloc_pages>
  103acf:	85 c0                	test   %eax,%eax
  103ad1:	74 24                	je     103af7 <default_check+0x564>
  103ad3:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  103ada:	00 
  103adb:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103ae2:	00 
  103ae3:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  103aea:	00 
  103aeb:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103af2:	e8 d4 d1 ff ff       	call   100ccb <__panic>

    assert(nr_free == 0);
  103af7:	a1 d8 89 11 00       	mov    0x1189d8,%eax
  103afc:	85 c0                	test   %eax,%eax
  103afe:	74 24                	je     103b24 <default_check+0x591>
  103b00:	c7 44 24 0c b1 6a 10 	movl   $0x106ab1,0xc(%esp)
  103b07:	00 
  103b08:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103b0f:	00 
  103b10:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  103b17:	00 
  103b18:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103b1f:	e8 a7 d1 ff ff       	call   100ccb <__panic>
    nr_free = nr_free_store;
  103b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b27:	a3 d8 89 11 00       	mov    %eax,0x1189d8

    free_list = free_list_store;
  103b2c:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b2f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b32:	a3 d0 89 11 00       	mov    %eax,0x1189d0
  103b37:	89 15 d4 89 11 00    	mov    %edx,0x1189d4
    free_pages(p0, 5);
  103b3d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b44:	00 
  103b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b48:	89 04 24             	mov    %eax,(%esp)
  103b4b:	e8 e9 03 00 00       	call   103f39 <free_pages>

    le = &free_list;
  103b50:	c7 45 ec d0 89 11 00 	movl   $0x1189d0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b57:	eb 1d                	jmp    103b76 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b5c:	83 e8 0c             	sub    $0xc,%eax
  103b5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103b62:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103b6c:	8b 40 08             	mov    0x8(%eax),%eax
  103b6f:	29 c2                	sub    %eax,%edx
  103b71:	89 d0                	mov    %edx,%eax
  103b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b79:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103b7c:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b7f:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b85:	81 7d ec d0 89 11 00 	cmpl   $0x1189d0,-0x14(%ebp)
  103b8c:	75 cb                	jne    103b59 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103b8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b92:	74 24                	je     103bb8 <default_check+0x625>
  103b94:	c7 44 24 0c 1e 6c 10 	movl   $0x106c1e,0xc(%esp)
  103b9b:	00 
  103b9c:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103ba3:	00 
  103ba4:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  103bab:	00 
  103bac:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103bb3:	e8 13 d1 ff ff       	call   100ccb <__panic>
    assert(total == 0);
  103bb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bbc:	74 24                	je     103be2 <default_check+0x64f>
  103bbe:	c7 44 24 0c 29 6c 10 	movl   $0x106c29,0xc(%esp)
  103bc5:	00 
  103bc6:	c7 44 24 08 d6 68 10 	movl   $0x1068d6,0x8(%esp)
  103bcd:	00 
  103bce:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103bd5:	00 
  103bd6:	c7 04 24 eb 68 10 00 	movl   $0x1068eb,(%esp)
  103bdd:	e8 e9 d0 ff ff       	call   100ccb <__panic>
}
  103be2:	81 c4 94 00 00 00    	add    $0x94,%esp
  103be8:	5b                   	pop    %ebx
  103be9:	5d                   	pop    %ebp
  103bea:	c3                   	ret    

00103beb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103beb:	55                   	push   %ebp
  103bec:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103bee:	8b 55 08             	mov    0x8(%ebp),%edx
  103bf1:	a1 e4 89 11 00       	mov    0x1189e4,%eax
  103bf6:	29 c2                	sub    %eax,%edx
  103bf8:	89 d0                	mov    %edx,%eax
  103bfa:	c1 f8 02             	sar    $0x2,%eax
  103bfd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c03:	5d                   	pop    %ebp
  103c04:	c3                   	ret    

00103c05 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103c05:	55                   	push   %ebp
  103c06:	89 e5                	mov    %esp,%ebp
  103c08:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0e:	89 04 24             	mov    %eax,(%esp)
  103c11:	e8 d5 ff ff ff       	call   103beb <page2ppn>
  103c16:	c1 e0 0c             	shl    $0xc,%eax
}
  103c19:	c9                   	leave  
  103c1a:	c3                   	ret    

00103c1b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103c1b:	55                   	push   %ebp
  103c1c:	89 e5                	mov    %esp,%ebp
  103c1e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c21:	8b 45 08             	mov    0x8(%ebp),%eax
  103c24:	c1 e8 0c             	shr    $0xc,%eax
  103c27:	89 c2                	mov    %eax,%edx
  103c29:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103c2e:	39 c2                	cmp    %eax,%edx
  103c30:	72 1c                	jb     103c4e <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c32:	c7 44 24 08 64 6c 10 	movl   $0x106c64,0x8(%esp)
  103c39:	00 
  103c3a:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c41:	00 
  103c42:	c7 04 24 83 6c 10 00 	movl   $0x106c83,(%esp)
  103c49:	e8 7d d0 ff ff       	call   100ccb <__panic>
    }
    return &pages[PPN(pa)];
  103c4e:	8b 0d e4 89 11 00    	mov    0x1189e4,%ecx
  103c54:	8b 45 08             	mov    0x8(%ebp),%eax
  103c57:	c1 e8 0c             	shr    $0xc,%eax
  103c5a:	89 c2                	mov    %eax,%edx
  103c5c:	89 d0                	mov    %edx,%eax
  103c5e:	c1 e0 02             	shl    $0x2,%eax
  103c61:	01 d0                	add    %edx,%eax
  103c63:	c1 e0 02             	shl    $0x2,%eax
  103c66:	01 c8                	add    %ecx,%eax
}
  103c68:	c9                   	leave  
  103c69:	c3                   	ret    

00103c6a <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103c6a:	55                   	push   %ebp
  103c6b:	89 e5                	mov    %esp,%ebp
  103c6d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c70:	8b 45 08             	mov    0x8(%ebp),%eax
  103c73:	89 04 24             	mov    %eax,(%esp)
  103c76:	e8 8a ff ff ff       	call   103c05 <page2pa>
  103c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c81:	c1 e8 0c             	shr    $0xc,%eax
  103c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c87:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103c8c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c8f:	72 23                	jb     103cb4 <page2kva+0x4a>
  103c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c98:	c7 44 24 08 94 6c 10 	movl   $0x106c94,0x8(%esp)
  103c9f:	00 
  103ca0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ca7:	00 
  103ca8:	c7 04 24 83 6c 10 00 	movl   $0x106c83,(%esp)
  103caf:	e8 17 d0 ff ff       	call   100ccb <__panic>
  103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cbc:	c9                   	leave  
  103cbd:	c3                   	ret    

00103cbe <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103cbe:	55                   	push   %ebp
  103cbf:	89 e5                	mov    %esp,%ebp
  103cc1:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc7:	83 e0 01             	and    $0x1,%eax
  103cca:	85 c0                	test   %eax,%eax
  103ccc:	75 1c                	jne    103cea <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103cce:	c7 44 24 08 b8 6c 10 	movl   $0x106cb8,0x8(%esp)
  103cd5:	00 
  103cd6:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cdd:	00 
  103cde:	c7 04 24 83 6c 10 00 	movl   $0x106c83,(%esp)
  103ce5:	e8 e1 cf ff ff       	call   100ccb <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103cea:	8b 45 08             	mov    0x8(%ebp),%eax
  103ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cf2:	89 04 24             	mov    %eax,(%esp)
  103cf5:	e8 21 ff ff ff       	call   103c1b <pa2page>
}
  103cfa:	c9                   	leave  
  103cfb:	c3                   	ret    

00103cfc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103cfc:	55                   	push   %ebp
  103cfd:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103cff:	8b 45 08             	mov    0x8(%ebp),%eax
  103d02:	8b 00                	mov    (%eax),%eax
}
  103d04:	5d                   	pop    %ebp
  103d05:	c3                   	ret    

00103d06 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103d06:	55                   	push   %ebp
  103d07:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d09:	8b 45 08             	mov    0x8(%ebp),%eax
  103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0f:	89 10                	mov    %edx,(%eax)
}
  103d11:	5d                   	pop    %ebp
  103d12:	c3                   	ret    

00103d13 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d13:	55                   	push   %ebp
  103d14:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d16:	8b 45 08             	mov    0x8(%ebp),%eax
  103d19:	8b 00                	mov    (%eax),%eax
  103d1b:	8d 50 01             	lea    0x1(%eax),%edx
  103d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103d21:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d23:	8b 45 08             	mov    0x8(%ebp),%eax
  103d26:	8b 00                	mov    (%eax),%eax
}
  103d28:	5d                   	pop    %ebp
  103d29:	c3                   	ret    

00103d2a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d2a:	55                   	push   %ebp
  103d2b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d30:	8b 00                	mov    (%eax),%eax
  103d32:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d35:	8b 45 08             	mov    0x8(%ebp),%eax
  103d38:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3d:	8b 00                	mov    (%eax),%eax
}
  103d3f:	5d                   	pop    %ebp
  103d40:	c3                   	ret    

00103d41 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103d41:	55                   	push   %ebp
  103d42:	89 e5                	mov    %esp,%ebp
  103d44:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d47:	9c                   	pushf  
  103d48:	58                   	pop    %eax
  103d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d4f:	25 00 02 00 00       	and    $0x200,%eax
  103d54:	85 c0                	test   %eax,%eax
  103d56:	74 0c                	je     103d64 <__intr_save+0x23>
        intr_disable();
  103d58:	e8 51 d9 ff ff       	call   1016ae <intr_disable>
        return 1;
  103d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  103d62:	eb 05                	jmp    103d69 <__intr_save+0x28>
    }
    return 0;
  103d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d69:	c9                   	leave  
  103d6a:	c3                   	ret    

00103d6b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103d6b:	55                   	push   %ebp
  103d6c:	89 e5                	mov    %esp,%ebp
  103d6e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d75:	74 05                	je     103d7c <__intr_restore+0x11>
        intr_enable();
  103d77:	e8 2c d9 ff ff       	call   1016a8 <intr_enable>
    }
}
  103d7c:	c9                   	leave  
  103d7d:	c3                   	ret    

00103d7e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d7e:	55                   	push   %ebp
  103d7f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d81:	8b 45 08             	mov    0x8(%ebp),%eax
  103d84:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d87:	b8 23 00 00 00       	mov    $0x23,%eax
  103d8c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103d8e:	b8 23 00 00 00       	mov    $0x23,%eax
  103d93:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103d95:	b8 10 00 00 00       	mov    $0x10,%eax
  103d9a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103d9c:	b8 10 00 00 00       	mov    $0x10,%eax
  103da1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103da3:	b8 10 00 00 00       	mov    $0x10,%eax
  103da8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103daa:	ea b1 3d 10 00 08 00 	ljmp   $0x8,$0x103db1
}
  103db1:	5d                   	pop    %ebp
  103db2:	c3                   	ret    

00103db3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103db3:	55                   	push   %ebp
  103db4:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103db6:	8b 45 08             	mov    0x8(%ebp),%eax
  103db9:	a3 04 89 11 00       	mov    %eax,0x118904
}
  103dbe:	5d                   	pop    %ebp
  103dbf:	c3                   	ret    

00103dc0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103dc0:	55                   	push   %ebp
  103dc1:	89 e5                	mov    %esp,%ebp
  103dc3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103dc6:	b8 00 70 11 00       	mov    $0x117000,%eax
  103dcb:	89 04 24             	mov    %eax,(%esp)
  103dce:	e8 e0 ff ff ff       	call   103db3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103dd3:	66 c7 05 08 89 11 00 	movw   $0x10,0x118908
  103dda:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103ddc:	66 c7 05 48 7a 11 00 	movw   $0x68,0x117a48
  103de3:	68 00 
  103de5:	b8 00 89 11 00       	mov    $0x118900,%eax
  103dea:	66 a3 4a 7a 11 00    	mov    %ax,0x117a4a
  103df0:	b8 00 89 11 00       	mov    $0x118900,%eax
  103df5:	c1 e8 10             	shr    $0x10,%eax
  103df8:	a2 4c 7a 11 00       	mov    %al,0x117a4c
  103dfd:	0f b6 05 4d 7a 11 00 	movzbl 0x117a4d,%eax
  103e04:	83 e0 f0             	and    $0xfffffff0,%eax
  103e07:	83 c8 09             	or     $0x9,%eax
  103e0a:	a2 4d 7a 11 00       	mov    %al,0x117a4d
  103e0f:	0f b6 05 4d 7a 11 00 	movzbl 0x117a4d,%eax
  103e16:	83 e0 ef             	and    $0xffffffef,%eax
  103e19:	a2 4d 7a 11 00       	mov    %al,0x117a4d
  103e1e:	0f b6 05 4d 7a 11 00 	movzbl 0x117a4d,%eax
  103e25:	83 e0 9f             	and    $0xffffff9f,%eax
  103e28:	a2 4d 7a 11 00       	mov    %al,0x117a4d
  103e2d:	0f b6 05 4d 7a 11 00 	movzbl 0x117a4d,%eax
  103e34:	83 c8 80             	or     $0xffffff80,%eax
  103e37:	a2 4d 7a 11 00       	mov    %al,0x117a4d
  103e3c:	0f b6 05 4e 7a 11 00 	movzbl 0x117a4e,%eax
  103e43:	83 e0 f0             	and    $0xfffffff0,%eax
  103e46:	a2 4e 7a 11 00       	mov    %al,0x117a4e
  103e4b:	0f b6 05 4e 7a 11 00 	movzbl 0x117a4e,%eax
  103e52:	83 e0 ef             	and    $0xffffffef,%eax
  103e55:	a2 4e 7a 11 00       	mov    %al,0x117a4e
  103e5a:	0f b6 05 4e 7a 11 00 	movzbl 0x117a4e,%eax
  103e61:	83 e0 df             	and    $0xffffffdf,%eax
  103e64:	a2 4e 7a 11 00       	mov    %al,0x117a4e
  103e69:	0f b6 05 4e 7a 11 00 	movzbl 0x117a4e,%eax
  103e70:	83 c8 40             	or     $0x40,%eax
  103e73:	a2 4e 7a 11 00       	mov    %al,0x117a4e
  103e78:	0f b6 05 4e 7a 11 00 	movzbl 0x117a4e,%eax
  103e7f:	83 e0 7f             	and    $0x7f,%eax
  103e82:	a2 4e 7a 11 00       	mov    %al,0x117a4e
  103e87:	b8 00 89 11 00       	mov    $0x118900,%eax
  103e8c:	c1 e8 18             	shr    $0x18,%eax
  103e8f:	a2 4f 7a 11 00       	mov    %al,0x117a4f

    // reload all segment registers
    lgdt(&gdt_pd);
  103e94:	c7 04 24 50 7a 11 00 	movl   $0x117a50,(%esp)
  103e9b:	e8 de fe ff ff       	call   103d7e <lgdt>
  103ea0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103ea6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103eaa:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103ead:	c9                   	leave  
  103eae:	c3                   	ret    

00103eaf <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103eaf:	55                   	push   %ebp
  103eb0:	89 e5                	mov    %esp,%ebp
  103eb2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103eb5:	c7 05 dc 89 11 00 48 	movl   $0x106c48,0x1189dc
  103ebc:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ebf:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103ec4:	8b 00                	mov    (%eax),%eax
  103ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103eca:	c7 04 24 e4 6c 10 00 	movl   $0x106ce4,(%esp)
  103ed1:	e8 66 c4 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103ed6:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103edb:	8b 40 04             	mov    0x4(%eax),%eax
  103ede:	ff d0                	call   *%eax
}
  103ee0:	c9                   	leave  
  103ee1:	c3                   	ret    

00103ee2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ee2:	55                   	push   %ebp
  103ee3:	89 e5                	mov    %esp,%ebp
  103ee5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ee8:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103eed:	8b 40 08             	mov    0x8(%eax),%eax
  103ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ef3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  103efa:	89 14 24             	mov    %edx,(%esp)
  103efd:	ff d0                	call   *%eax
}
  103eff:	c9                   	leave  
  103f00:	c3                   	ret    

00103f01 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f01:	55                   	push   %ebp
  103f02:	89 e5                	mov    %esp,%ebp
  103f04:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f0e:	e8 2e fe ff ff       	call   103d41 <__intr_save>
  103f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f16:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  103f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  103f21:	89 14 24             	mov    %edx,(%esp)
  103f24:	ff d0                	call   *%eax
  103f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f2c:	89 04 24             	mov    %eax,(%esp)
  103f2f:	e8 37 fe ff ff       	call   103d6b <__intr_restore>
    return page;
  103f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f37:	c9                   	leave  
  103f38:	c3                   	ret    

00103f39 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f39:	55                   	push   %ebp
  103f3a:	89 e5                	mov    %esp,%ebp
  103f3c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f3f:	e8 fd fd ff ff       	call   103d41 <__intr_save>
  103f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f47:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103f4c:	8b 40 10             	mov    0x10(%eax),%eax
  103f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f52:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f56:	8b 55 08             	mov    0x8(%ebp),%edx
  103f59:	89 14 24             	mov    %edx,(%esp)
  103f5c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f61:	89 04 24             	mov    %eax,(%esp)
  103f64:	e8 02 fe ff ff       	call   103d6b <__intr_restore>
}
  103f69:	c9                   	leave  
  103f6a:	c3                   	ret    

00103f6b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f6b:	55                   	push   %ebp
  103f6c:	89 e5                	mov    %esp,%ebp
  103f6e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f71:	e8 cb fd ff ff       	call   103d41 <__intr_save>
  103f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f79:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  103f7e:	8b 40 14             	mov    0x14(%eax),%eax
  103f81:	ff d0                	call   *%eax
  103f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f89:	89 04 24             	mov    %eax,(%esp)
  103f8c:	e8 da fd ff ff       	call   103d6b <__intr_restore>
    return ret;
  103f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103f94:	c9                   	leave  
  103f95:	c3                   	ret    

00103f96 <page_init>:

/* pmm_init - initialize the physical memory management */
/* 虚拟地址比物理地址偏移KERNBASE。存在变量中的地址值为物理地址，但变量本身的地址要减偏移才为物理地址，因为这程序本身运行时是在虚拟地址中的。*/
static void
page_init(void) {
  103f96:	55                   	push   %ebp
  103f97:	89 e5                	mov    %esp,%ebp
  103f99:	57                   	push   %edi
  103f9a:	56                   	push   %esi
  103f9b:	53                   	push   %ebx
  103f9c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103fa2:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103fa9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103fb7:	c7 04 24 fb 6c 10 00 	movl   $0x106cfb,(%esp)
  103fbe:	e8 79 c3 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fca:	e9 15 01 00 00       	jmp    1040e4 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fcf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fd5:	89 d0                	mov    %edx,%eax
  103fd7:	c1 e0 02             	shl    $0x2,%eax
  103fda:	01 d0                	add    %edx,%eax
  103fdc:	c1 e0 02             	shl    $0x2,%eax
  103fdf:	01 c8                	add    %ecx,%eax
  103fe1:	8b 50 08             	mov    0x8(%eax),%edx
  103fe4:	8b 40 04             	mov    0x4(%eax),%eax
  103fe7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103fea:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ff3:	89 d0                	mov    %edx,%eax
  103ff5:	c1 e0 02             	shl    $0x2,%eax
  103ff8:	01 d0                	add    %edx,%eax
  103ffa:	c1 e0 02             	shl    $0x2,%eax
  103ffd:	01 c8                	add    %ecx,%eax
  103fff:	8b 48 0c             	mov    0xc(%eax),%ecx
  104002:	8b 58 10             	mov    0x10(%eax),%ebx
  104005:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104008:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10400b:	01 c8                	add    %ecx,%eax
  10400d:	11 da                	adc    %ebx,%edx
  10400f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104012:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104015:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104018:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10401b:	89 d0                	mov    %edx,%eax
  10401d:	c1 e0 02             	shl    $0x2,%eax
  104020:	01 d0                	add    %edx,%eax
  104022:	c1 e0 02             	shl    $0x2,%eax
  104025:	01 c8                	add    %ecx,%eax
  104027:	83 c0 14             	add    $0x14,%eax
  10402a:	8b 00                	mov    (%eax),%eax
  10402c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104032:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104035:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104038:	83 c0 ff             	add    $0xffffffff,%eax
  10403b:	83 d2 ff             	adc    $0xffffffff,%edx
  10403e:	89 c6                	mov    %eax,%esi
  104040:	89 d7                	mov    %edx,%edi
  104042:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104045:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104048:	89 d0                	mov    %edx,%eax
  10404a:	c1 e0 02             	shl    $0x2,%eax
  10404d:	01 d0                	add    %edx,%eax
  10404f:	c1 e0 02             	shl    $0x2,%eax
  104052:	01 c8                	add    %ecx,%eax
  104054:	8b 48 0c             	mov    0xc(%eax),%ecx
  104057:	8b 58 10             	mov    0x10(%eax),%ebx
  10405a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104060:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104064:	89 74 24 14          	mov    %esi,0x14(%esp)
  104068:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10406c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10406f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104072:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104076:	89 54 24 10          	mov    %edx,0x10(%esp)
  10407a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10407e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104082:	c7 04 24 08 6d 10 00 	movl   $0x106d08,(%esp)
  104089:	e8 ae c2 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  10408e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104091:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104094:	89 d0                	mov    %edx,%eax
  104096:	c1 e0 02             	shl    $0x2,%eax
  104099:	01 d0                	add    %edx,%eax
  10409b:	c1 e0 02             	shl    $0x2,%eax
  10409e:	01 c8                	add    %ecx,%eax
  1040a0:	83 c0 14             	add    $0x14,%eax
  1040a3:	8b 00                	mov    (%eax),%eax
  1040a5:	83 f8 01             	cmp    $0x1,%eax
  1040a8:	75 36                	jne    1040e0 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  1040aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040b0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040b3:	77 2b                	ja     1040e0 <page_init+0x14a>
  1040b5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  1040b8:	72 05                	jb     1040bf <page_init+0x129>
  1040ba:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1040bd:	73 21                	jae    1040e0 <page_init+0x14a>
  1040bf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040c3:	77 1b                	ja     1040e0 <page_init+0x14a>
  1040c5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  1040c9:	72 09                	jb     1040d4 <page_init+0x13e>
  1040cb:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  1040d2:	77 0c                	ja     1040e0 <page_init+0x14a>
                maxpa = end;
  1040d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1040d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1040da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1040e0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1040e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040e7:	8b 00                	mov    (%eax),%eax
  1040e9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1040ec:	0f 8f dd fe ff ff    	jg     103fcf <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  1040f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040f6:	72 1d                	jb     104115 <page_init+0x17f>
  1040f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040fc:	77 09                	ja     104107 <page_init+0x171>
  1040fe:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104105:	76 0e                	jbe    104115 <page_init+0x17f>
        maxpa = KMEMSIZE;
  104107:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10410e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }
	/*end为ucore加载的地址末尾*/
    extern char end[];

	/*pages ~ pages + (sizeof(Page))*npage 用来存页记录*/
    npage = maxpa / PGSIZE;
  104115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10411b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10411f:	c1 ea 0c             	shr    $0xc,%edx
  104122:	a3 e0 88 11 00       	mov    %eax,0x1188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104127:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  10412e:	b8 e8 89 11 00       	mov    $0x1189e8,%eax
  104133:	8d 50 ff             	lea    -0x1(%eax),%edx
  104136:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104139:	01 d0                	add    %edx,%eax
  10413b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10413e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104141:	ba 00 00 00 00       	mov    $0x0,%edx
  104146:	f7 75 ac             	divl   -0x54(%ebp)
  104149:	89 d0                	mov    %edx,%eax
  10414b:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10414e:	29 c2                	sub    %eax,%edx
  104150:	89 d0                	mov    %edx,%eax
  104152:	a3 e4 89 11 00       	mov    %eax,0x1189e4

	/*先全标为reserved*/
    for (i = 0; i < npage; i ++) {
  104157:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10415e:	eb 2f                	jmp    10418f <page_init+0x1f9>
        SetPageReserved(pages + i);
  104160:	8b 0d e4 89 11 00    	mov    0x1189e4,%ecx
  104166:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104169:	89 d0                	mov    %edx,%eax
  10416b:	c1 e0 02             	shl    $0x2,%eax
  10416e:	01 d0                	add    %edx,%eax
  104170:	c1 e0 02             	shl    $0x2,%eax
  104173:	01 c8                	add    %ecx,%eax
  104175:	83 c0 04             	add    $0x4,%eax
  104178:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  10417f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104182:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104185:	8b 55 90             	mov    -0x70(%ebp),%edx
  104188:	0f ab 10             	bts    %edx,(%eax)
	/*pages ~ pages + (sizeof(Page))*npage 用来存页记录*/
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

	/*先全标为reserved*/
    for (i = 0; i < npage; i ++) {
  10418b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10418f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104192:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104197:	39 c2                	cmp    %eax,%edx
  104199:	72 c5                	jb     104160 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }
	
	/*free memory从存页记录的末尾开始*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10419b:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  1041a1:	89 d0                	mov    %edx,%eax
  1041a3:	c1 e0 02             	shl    $0x2,%eax
  1041a6:	01 d0                	add    %edx,%eax
  1041a8:	c1 e0 02             	shl    $0x2,%eax
  1041ab:	89 c2                	mov    %eax,%edx
  1041ad:	a1 e4 89 11 00       	mov    0x1189e4,%eax
  1041b2:	01 d0                	add    %edx,%eax
  1041b4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1041b7:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1041be:	77 23                	ja     1041e3 <page_init+0x24d>
  1041c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041c7:	c7 44 24 08 38 6d 10 	movl   $0x106d38,0x8(%esp)
  1041ce:	00 
  1041cf:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  1041d6:	00 
  1041d7:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1041de:	e8 e8 ca ff ff       	call   100ccb <__panic>
  1041e3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041e6:	05 00 00 00 40       	add    $0x40000000,%eax
  1041eb:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*对实际空闲的内存块，reserved,free位均标0，完成初始化*/
    for (i = 0; i < memmap->nr_map; i ++) {
  1041ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041f5:	e9 74 01 00 00       	jmp    10436e <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1041fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104200:	89 d0                	mov    %edx,%eax
  104202:	c1 e0 02             	shl    $0x2,%eax
  104205:	01 d0                	add    %edx,%eax
  104207:	c1 e0 02             	shl    $0x2,%eax
  10420a:	01 c8                	add    %ecx,%eax
  10420c:	8b 50 08             	mov    0x8(%eax),%edx
  10420f:	8b 40 04             	mov    0x4(%eax),%eax
  104212:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104215:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104218:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10421b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10421e:	89 d0                	mov    %edx,%eax
  104220:	c1 e0 02             	shl    $0x2,%eax
  104223:	01 d0                	add    %edx,%eax
  104225:	c1 e0 02             	shl    $0x2,%eax
  104228:	01 c8                	add    %ecx,%eax
  10422a:	8b 48 0c             	mov    0xc(%eax),%ecx
  10422d:	8b 58 10             	mov    0x10(%eax),%ebx
  104230:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104233:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104236:	01 c8                	add    %ecx,%eax
  104238:	11 da                	adc    %ebx,%edx
  10423a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10423d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104240:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104243:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104246:	89 d0                	mov    %edx,%eax
  104248:	c1 e0 02             	shl    $0x2,%eax
  10424b:	01 d0                	add    %edx,%eax
  10424d:	c1 e0 02             	shl    $0x2,%eax
  104250:	01 c8                	add    %ecx,%eax
  104252:	83 c0 14             	add    $0x14,%eax
  104255:	8b 00                	mov    (%eax),%eax
  104257:	83 f8 01             	cmp    $0x1,%eax
  10425a:	0f 85 0a 01 00 00    	jne    10436a <page_init+0x3d4>
            if (begin < freemem) {
  104260:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104263:	ba 00 00 00 00       	mov    $0x0,%edx
  104268:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10426b:	72 17                	jb     104284 <page_init+0x2ee>
  10426d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104270:	77 05                	ja     104277 <page_init+0x2e1>
  104272:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104275:	76 0d                	jbe    104284 <page_init+0x2ee>
                begin = freemem;
  104277:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10427a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10427d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104284:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104288:	72 1d                	jb     1042a7 <page_init+0x311>
  10428a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10428e:	77 09                	ja     104299 <page_init+0x303>
  104290:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104297:	76 0e                	jbe    1042a7 <page_init+0x311>
                end = KMEMSIZE;
  104299:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042a0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042ad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042b0:	0f 87 b4 00 00 00    	ja     10436a <page_init+0x3d4>
  1042b6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042b9:	72 09                	jb     1042c4 <page_init+0x32e>
  1042bb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042be:	0f 83 a6 00 00 00    	jae    10436a <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1042c4:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1042cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042ce:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1042d1:	01 d0                	add    %edx,%eax
  1042d3:	83 e8 01             	sub    $0x1,%eax
  1042d6:	89 45 98             	mov    %eax,-0x68(%ebp)
  1042d9:	8b 45 98             	mov    -0x68(%ebp),%eax
  1042dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1042e1:	f7 75 9c             	divl   -0x64(%ebp)
  1042e4:	89 d0                	mov    %edx,%eax
  1042e6:	8b 55 98             	mov    -0x68(%ebp),%edx
  1042e9:	29 c2                	sub    %eax,%edx
  1042eb:	89 d0                	mov    %edx,%eax
  1042ed:	ba 00 00 00 00       	mov    $0x0,%edx
  1042f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1042f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042fb:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1042fe:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104301:	ba 00 00 00 00       	mov    $0x0,%edx
  104306:	89 c7                	mov    %eax,%edi
  104308:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10430e:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104311:	89 d0                	mov    %edx,%eax
  104313:	83 e0 00             	and    $0x0,%eax
  104316:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104319:	8b 45 80             	mov    -0x80(%ebp),%eax
  10431c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10431f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104322:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104325:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104328:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10432b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10432e:	77 3a                	ja     10436a <page_init+0x3d4>
  104330:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104333:	72 05                	jb     10433a <page_init+0x3a4>
  104335:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104338:	73 30                	jae    10436a <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE); /*pa2page():从内存地址找所在页的页记录的位置*/
  10433a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10433d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104340:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104343:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104346:	29 c8                	sub    %ecx,%eax
  104348:	19 da                	sbb    %ebx,%edx
  10434a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10434e:	c1 ea 0c             	shr    $0xc,%edx
  104351:	89 c3                	mov    %eax,%ebx
  104353:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104356:	89 04 24             	mov    %eax,(%esp)
  104359:	e8 bd f8 ff ff       	call   103c1b <pa2page>
  10435e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104362:	89 04 24             	mov    %eax,(%esp)
  104365:	e8 78 fb ff ff       	call   103ee2 <init_memmap>
	
	/*free memory从存页记录的末尾开始*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

	/*对实际空闲的内存块，reserved,free位均标0，完成初始化*/
    for (i = 0; i < memmap->nr_map; i ++) {
  10436a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10436e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104371:	8b 00                	mov    (%eax),%eax
  104373:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104376:	0f 8f 7e fe ff ff    	jg     1041fa <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE); /*pa2page():从内存地址找所在页的页记录的位置*/
                }
            }
        }
    }
}
  10437c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104382:	5b                   	pop    %ebx
  104383:	5e                   	pop    %esi
  104384:	5f                   	pop    %edi
  104385:	5d                   	pop    %ebp
  104386:	c3                   	ret    

00104387 <enable_paging>:

static void
enable_paging(void) {
  104387:	55                   	push   %ebp
  104388:	89 e5                	mov    %esp,%ebp
  10438a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10438d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104392:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104398:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10439b:	0f 20 c0             	mov    %cr0,%eax
  10439e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1043a1:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1043a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1043a7:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1043ae:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1043b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1043b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043bb:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1043be:	c9                   	leave  
  1043bf:	c3                   	ret    

001043c0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043c0:	55                   	push   %ebp
  1043c1:	89 e5                	mov    %esp,%ebp
  1043c3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1043c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043cc:	31 d0                	xor    %edx,%eax
  1043ce:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043d3:	85 c0                	test   %eax,%eax
  1043d5:	74 24                	je     1043fb <boot_map_segment+0x3b>
  1043d7:	c7 44 24 0c 6a 6d 10 	movl   $0x106d6a,0xc(%esp)
  1043de:	00 
  1043df:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  1043e6:	00 
  1043e7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  1043ee:	00 
  1043ef:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1043f6:	e8 d0 c8 ff ff       	call   100ccb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104402:	8b 45 0c             	mov    0xc(%ebp),%eax
  104405:	25 ff 0f 00 00       	and    $0xfff,%eax
  10440a:	89 c2                	mov    %eax,%edx
  10440c:	8b 45 10             	mov    0x10(%ebp),%eax
  10440f:	01 c2                	add    %eax,%edx
  104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104414:	01 d0                	add    %edx,%eax
  104416:	83 e8 01             	sub    $0x1,%eax
  104419:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10441c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441f:	ba 00 00 00 00       	mov    $0x0,%edx
  104424:	f7 75 f0             	divl   -0x10(%ebp)
  104427:	89 d0                	mov    %edx,%eax
  104429:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10442c:	29 c2                	sub    %eax,%edx
  10442e:	89 d0                	mov    %edx,%eax
  104430:	c1 e8 0c             	shr    $0xc,%eax
  104433:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104436:	8b 45 0c             	mov    0xc(%ebp),%eax
  104439:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10443c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10443f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104444:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104447:	8b 45 14             	mov    0x14(%ebp),%eax
  10444a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10444d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104455:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104458:	eb 6b                	jmp    1044c5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10445a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104461:	00 
  104462:	8b 45 0c             	mov    0xc(%ebp),%eax
  104465:	89 44 24 04          	mov    %eax,0x4(%esp)
  104469:	8b 45 08             	mov    0x8(%ebp),%eax
  10446c:	89 04 24             	mov    %eax,(%esp)
  10446f:	e8 cc 01 00 00       	call   104640 <get_pte>
  104474:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10447b:	75 24                	jne    1044a1 <boot_map_segment+0xe1>
  10447d:	c7 44 24 0c 96 6d 10 	movl   $0x106d96,0xc(%esp)
  104484:	00 
  104485:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  10448c:	00 
  10448d:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  104494:	00 
  104495:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10449c:	e8 2a c8 ff ff       	call   100ccb <__panic>
        *ptep = pa | PTE_P | perm;
  1044a1:	8b 45 18             	mov    0x18(%ebp),%eax
  1044a4:	8b 55 14             	mov    0x14(%ebp),%edx
  1044a7:	09 d0                	or     %edx,%eax
  1044a9:	83 c8 01             	or     $0x1,%eax
  1044ac:	89 c2                	mov    %eax,%edx
  1044ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044b1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1044b7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044be:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044c9:	75 8f                	jne    10445a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1044cb:	c9                   	leave  
  1044cc:	c3                   	ret    

001044cd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044cd:	55                   	push   %ebp
  1044ce:	89 e5                	mov    %esp,%ebp
  1044d0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044da:	e8 22 fa ff ff       	call   103f01 <alloc_pages>
  1044df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044e6:	75 1c                	jne    104504 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044e8:	c7 44 24 08 a3 6d 10 	movl   $0x106da3,0x8(%esp)
  1044ef:	00 
  1044f0:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1044f7:	00 
  1044f8:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1044ff:	e8 c7 c7 ff ff       	call   100ccb <__panic>
    }
    return page2kva(p);
  104504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104507:	89 04 24             	mov    %eax,(%esp)
  10450a:	e8 5b f7 ff ff       	call   103c6a <page2kva>
}
  10450f:	c9                   	leave  
  104510:	c3                   	ret    

00104511 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104511:	55                   	push   %ebp
  104512:	89 e5                	mov    %esp,%ebp
  104514:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104517:	e8 93 f9 ff ff       	call   103eaf <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10451c:	e8 75 fa ff ff       	call   103f96 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104521:	e8 66 04 00 00       	call   10498c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104526:	e8 a2 ff ff ff       	call   1044cd <boot_alloc_page>
  10452b:	a3 e4 88 11 00       	mov    %eax,0x1188e4
    memset(boot_pgdir, 0, PGSIZE);
  104530:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104535:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10453c:	00 
  10453d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104544:	00 
  104545:	89 04 24             	mov    %eax,(%esp)
  104548:	e8 a8 1a 00 00       	call   105ff5 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10454d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104552:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104555:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10455c:	77 23                	ja     104581 <pmm_init+0x70>
  10455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104561:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104565:	c7 44 24 08 38 6d 10 	movl   $0x106d38,0x8(%esp)
  10456c:	00 
  10456d:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  104574:	00 
  104575:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10457c:	e8 4a c7 ff ff       	call   100ccb <__panic>
  104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104584:	05 00 00 00 40       	add    $0x40000000,%eax
  104589:	a3 e0 89 11 00       	mov    %eax,0x1189e0

    check_pgdir();
  10458e:	e8 17 04 00 00       	call   1049aa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104593:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104598:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10459e:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1045a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045a6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1045ad:	77 23                	ja     1045d2 <pmm_init+0xc1>
  1045af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045b6:	c7 44 24 08 38 6d 10 	movl   $0x106d38,0x8(%esp)
  1045bd:	00 
  1045be:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  1045c5:	00 
  1045c6:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1045cd:	e8 f9 c6 ff ff       	call   100ccb <__panic>
  1045d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045d5:	05 00 00 00 40       	add    $0x40000000,%eax
  1045da:	83 c8 03             	or     $0x3,%eax
  1045dd:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045df:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1045e4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045eb:	00 
  1045ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045f3:	00 
  1045f4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045fb:	38 
  1045fc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104603:	c0 
  104604:	89 04 24             	mov    %eax,(%esp)
  104607:	e8 b4 fd ff ff       	call   1043c0 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10460c:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104611:	8b 15 e4 88 11 00    	mov    0x1188e4,%edx
  104617:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10461d:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10461f:	e8 63 fd ff ff       	call   104387 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104624:	e8 97 f7 ff ff       	call   103dc0 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104629:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10462e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104634:	e8 0c 0a 00 00       	call   105045 <check_boot_pgdir>

    print_pgdir();
  104639:	e8 99 0e 00 00       	call   1054d7 <print_pgdir>

}
  10463e:	c9                   	leave  
  10463f:	c3                   	ret    

00104640 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104640:	55                   	push   %ebp
  104641:	89 e5                	mov    %esp,%ebp
  104643:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  104646:	8b 45 0c             	mov    0xc(%ebp),%eax
  104649:	c1 e8 16             	shr    $0x16,%eax
  10464c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104653:	8b 45 08             	mov    0x8(%ebp),%eax
  104656:	01 d0                	add    %edx,%eax
  104658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  10465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465e:	8b 00                	mov    (%eax),%eax
  104660:	83 e0 01             	and    $0x1,%eax
  104663:	85 c0                	test   %eax,%eax
  104665:	0f 85 af 00 00 00    	jne    10471a <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  10466b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10466f:	74 15                	je     104686 <get_pte+0x46>
  104671:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104678:	e8 84 f8 ff ff       	call   103f01 <alloc_pages>
  10467d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104680:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104684:	75 0a                	jne    104690 <get_pte+0x50>
            return NULL;
  104686:	b8 00 00 00 00       	mov    $0x0,%eax
  10468b:	e9 e6 00 00 00       	jmp    104776 <get_pte+0x136>
        }
        set_page_ref(page, 1);
  104690:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104697:	00 
  104698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10469b:	89 04 24             	mov    %eax,(%esp)
  10469e:	e8 63 f6 ff ff       	call   103d06 <set_page_ref>
        uintptr_t pa = page2pa(page);
  1046a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046a6:	89 04 24             	mov    %eax,(%esp)
  1046a9:	e8 57 f5 ff ff       	call   103c05 <page2pa>
  1046ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  1046b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1046b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046ba:	c1 e8 0c             	shr    $0xc,%eax
  1046bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046c0:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1046c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1046c8:	72 23                	jb     1046ed <get_pte+0xad>
  1046ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046d1:	c7 44 24 08 94 6c 10 	movl   $0x106c94,0x8(%esp)
  1046d8:	00 
  1046d9:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  1046e0:	00 
  1046e1:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1046e8:	e8 de c5 ff ff       	call   100ccb <__panic>
  1046ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1046f0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1046fc:	00 
  1046fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104704:	00 
  104705:	89 04 24             	mov    %eax,(%esp)
  104708:	e8 e8 18 00 00       	call   105ff5 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  10470d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104710:	83 c8 07             	or     $0x7,%eax
  104713:	89 c2                	mov    %eax,%edx
  104715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104718:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471d:	8b 00                	mov    (%eax),%eax
  10471f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104724:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10472a:	c1 e8 0c             	shr    $0xc,%eax
  10472d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104730:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104735:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104738:	72 23                	jb     10475d <get_pte+0x11d>
  10473a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10473d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104741:	c7 44 24 08 94 6c 10 	movl   $0x106c94,0x8(%esp)
  104748:	00 
  104749:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
  104750:	00 
  104751:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104758:	e8 6e c5 ff ff       	call   100ccb <__panic>
  10475d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104760:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104765:	8b 55 0c             	mov    0xc(%ebp),%edx
  104768:	c1 ea 0c             	shr    $0xc,%edx
  10476b:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104771:	c1 e2 02             	shl    $0x2,%edx
  104774:	01 d0                	add    %edx,%eax
}
  104776:	c9                   	leave  
  104777:	c3                   	ret    

00104778 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104778:	55                   	push   %ebp
  104779:	89 e5                	mov    %esp,%ebp
  10477b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10477e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104785:	00 
  104786:	8b 45 0c             	mov    0xc(%ebp),%eax
  104789:	89 44 24 04          	mov    %eax,0x4(%esp)
  10478d:	8b 45 08             	mov    0x8(%ebp),%eax
  104790:	89 04 24             	mov    %eax,(%esp)
  104793:	e8 a8 fe ff ff       	call   104640 <get_pte>
  104798:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10479b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10479f:	74 08                	je     1047a9 <get_page+0x31>
        *ptep_store = ptep;
  1047a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1047a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047a7:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1047a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047ad:	74 1b                	je     1047ca <get_page+0x52>
  1047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b2:	8b 00                	mov    (%eax),%eax
  1047b4:	83 e0 01             	and    $0x1,%eax
  1047b7:	85 c0                	test   %eax,%eax
  1047b9:	74 0f                	je     1047ca <get_page+0x52>
        return pa2page(*ptep);
  1047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047be:	8b 00                	mov    (%eax),%eax
  1047c0:	89 04 24             	mov    %eax,(%esp)
  1047c3:	e8 53 f4 ff ff       	call   103c1b <pa2page>
  1047c8:	eb 05                	jmp    1047cf <get_page+0x57>
    }
    return NULL;
  1047ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047cf:	c9                   	leave  
  1047d0:	c3                   	ret    

001047d1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1047d1:	55                   	push   %ebp
  1047d2:	89 e5                	mov    %esp,%ebp
  1047d4:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1047d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1047da:	8b 00                	mov    (%eax),%eax
  1047dc:	83 e0 01             	and    $0x1,%eax
  1047df:	85 c0                	test   %eax,%eax
  1047e1:	74 4d                	je     104830 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  1047e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1047e6:	8b 00                	mov    (%eax),%eax
  1047e8:	89 04 24             	mov    %eax,(%esp)
  1047eb:	e8 ce f4 ff ff       	call   103cbe <pte2page>
  1047f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  1047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f6:	89 04 24             	mov    %eax,(%esp)
  1047f9:	e8 2c f5 ff ff       	call   103d2a <page_ref_dec>
  1047fe:	85 c0                	test   %eax,%eax
  104800:	75 13                	jne    104815 <page_remove_pte+0x44>
            free_page(page);
  104802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104809:	00 
  10480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10480d:	89 04 24             	mov    %eax,(%esp)
  104810:	e8 24 f7 ff ff       	call   103f39 <free_pages>
        }
        *ptep = 0;
  104815:	8b 45 10             	mov    0x10(%ebp),%eax
  104818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  10481e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104821:	89 44 24 04          	mov    %eax,0x4(%esp)
  104825:	8b 45 08             	mov    0x8(%ebp),%eax
  104828:	89 04 24             	mov    %eax,(%esp)
  10482b:	e8 ff 00 00 00       	call   10492f <tlb_invalidate>
    }
}
  104830:	c9                   	leave  
  104831:	c3                   	ret    

00104832 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104832:	55                   	push   %ebp
  104833:	89 e5                	mov    %esp,%ebp
  104835:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104838:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10483f:	00 
  104840:	8b 45 0c             	mov    0xc(%ebp),%eax
  104843:	89 44 24 04          	mov    %eax,0x4(%esp)
  104847:	8b 45 08             	mov    0x8(%ebp),%eax
  10484a:	89 04 24             	mov    %eax,(%esp)
  10484d:	e8 ee fd ff ff       	call   104640 <get_pte>
  104852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104859:	74 19                	je     104874 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104862:	8b 45 0c             	mov    0xc(%ebp),%eax
  104865:	89 44 24 04          	mov    %eax,0x4(%esp)
  104869:	8b 45 08             	mov    0x8(%ebp),%eax
  10486c:	89 04 24             	mov    %eax,(%esp)
  10486f:	e8 5d ff ff ff       	call   1047d1 <page_remove_pte>
    }
}
  104874:	c9                   	leave  
  104875:	c3                   	ret    

00104876 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104876:	55                   	push   %ebp
  104877:	89 e5                	mov    %esp,%ebp
  104879:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10487c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104883:	00 
  104884:	8b 45 10             	mov    0x10(%ebp),%eax
  104887:	89 44 24 04          	mov    %eax,0x4(%esp)
  10488b:	8b 45 08             	mov    0x8(%ebp),%eax
  10488e:	89 04 24             	mov    %eax,(%esp)
  104891:	e8 aa fd ff ff       	call   104640 <get_pte>
  104896:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10489d:	75 0a                	jne    1048a9 <page_insert+0x33>
        return -E_NO_MEM;
  10489f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1048a4:	e9 84 00 00 00       	jmp    10492d <page_insert+0xb7>
    }
    page_ref_inc(page);
  1048a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048ac:	89 04 24             	mov    %eax,(%esp)
  1048af:	e8 5f f4 ff ff       	call   103d13 <page_ref_inc>
    if (*ptep & PTE_P) {
  1048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b7:	8b 00                	mov    (%eax),%eax
  1048b9:	83 e0 01             	and    $0x1,%eax
  1048bc:	85 c0                	test   %eax,%eax
  1048be:	74 3e                	je     1048fe <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1048c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c3:	8b 00                	mov    (%eax),%eax
  1048c5:	89 04 24             	mov    %eax,(%esp)
  1048c8:	e8 f1 f3 ff ff       	call   103cbe <pte2page>
  1048cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1048d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1048d6:	75 0d                	jne    1048e5 <page_insert+0x6f>
            page_ref_dec(page);
  1048d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048db:	89 04 24             	mov    %eax,(%esp)
  1048de:	e8 47 f4 ff ff       	call   103d2a <page_ref_dec>
  1048e3:	eb 19                	jmp    1048fe <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1048ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1048ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f6:	89 04 24             	mov    %eax,(%esp)
  1048f9:	e8 d3 fe ff ff       	call   1047d1 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1048fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104901:	89 04 24             	mov    %eax,(%esp)
  104904:	e8 fc f2 ff ff       	call   103c05 <page2pa>
  104909:	0b 45 14             	or     0x14(%ebp),%eax
  10490c:	83 c8 01             	or     $0x1,%eax
  10490f:	89 c2                	mov    %eax,%edx
  104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104914:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104916:	8b 45 10             	mov    0x10(%ebp),%eax
  104919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10491d:	8b 45 08             	mov    0x8(%ebp),%eax
  104920:	89 04 24             	mov    %eax,(%esp)
  104923:	e8 07 00 00 00       	call   10492f <tlb_invalidate>
    return 0;
  104928:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10492d:	c9                   	leave  
  10492e:	c3                   	ret    

0010492f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10492f:	55                   	push   %ebp
  104930:	89 e5                	mov    %esp,%ebp
  104932:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104935:	0f 20 d8             	mov    %cr3,%eax
  104938:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  10493e:	89 c2                	mov    %eax,%edx
  104940:	8b 45 08             	mov    0x8(%ebp),%eax
  104943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104946:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10494d:	77 23                	ja     104972 <tlb_invalidate+0x43>
  10494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104956:	c7 44 24 08 38 6d 10 	movl   $0x106d38,0x8(%esp)
  10495d:	00 
  10495e:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104965:	00 
  104966:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10496d:	e8 59 c3 ff ff       	call   100ccb <__panic>
  104972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104975:	05 00 00 00 40       	add    $0x40000000,%eax
  10497a:	39 c2                	cmp    %eax,%edx
  10497c:	75 0c                	jne    10498a <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10497e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104981:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104987:	0f 01 38             	invlpg (%eax)
    }
}
  10498a:	c9                   	leave  
  10498b:	c3                   	ret    

0010498c <check_alloc_page>:

static void
check_alloc_page(void) {
  10498c:	55                   	push   %ebp
  10498d:	89 e5                	mov    %esp,%ebp
  10498f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104992:	a1 dc 89 11 00       	mov    0x1189dc,%eax
  104997:	8b 40 18             	mov    0x18(%eax),%eax
  10499a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10499c:	c7 04 24 bc 6d 10 00 	movl   $0x106dbc,(%esp)
  1049a3:	e8 94 b9 ff ff       	call   10033c <cprintf>
}
  1049a8:	c9                   	leave  
  1049a9:	c3                   	ret    

001049aa <check_pgdir>:

static void
check_pgdir(void) {
  1049aa:	55                   	push   %ebp
  1049ab:	89 e5                	mov    %esp,%ebp
  1049ad:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1049b0:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1049b5:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1049ba:	76 24                	jbe    1049e0 <check_pgdir+0x36>
  1049bc:	c7 44 24 0c db 6d 10 	movl   $0x106ddb,0xc(%esp)
  1049c3:	00 
  1049c4:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  1049cb:	00 
  1049cc:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1049d3:	00 
  1049d4:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1049db:	e8 eb c2 ff ff       	call   100ccb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1049e0:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1049e5:	85 c0                	test   %eax,%eax
  1049e7:	74 0e                	je     1049f7 <check_pgdir+0x4d>
  1049e9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1049ee:	25 ff 0f 00 00       	and    $0xfff,%eax
  1049f3:	85 c0                	test   %eax,%eax
  1049f5:	74 24                	je     104a1b <check_pgdir+0x71>
  1049f7:	c7 44 24 0c f8 6d 10 	movl   $0x106df8,0xc(%esp)
  1049fe:	00 
  1049ff:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104a06:	00 
  104a07:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104a0e:	00 
  104a0f:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104a16:	e8 b0 c2 ff ff       	call   100ccb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104a1b:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a27:	00 
  104a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a2f:	00 
  104a30:	89 04 24             	mov    %eax,(%esp)
  104a33:	e8 40 fd ff ff       	call   104778 <get_page>
  104a38:	85 c0                	test   %eax,%eax
  104a3a:	74 24                	je     104a60 <check_pgdir+0xb6>
  104a3c:	c7 44 24 0c 30 6e 10 	movl   $0x106e30,0xc(%esp)
  104a43:	00 
  104a44:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104a4b:	00 
  104a4c:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104a53:	00 
  104a54:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104a5b:	e8 6b c2 ff ff       	call   100ccb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a67:	e8 95 f4 ff ff       	call   103f01 <alloc_pages>
  104a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a6f:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a7b:	00 
  104a7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a83:	00 
  104a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a87:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a8b:	89 04 24             	mov    %eax,(%esp)
  104a8e:	e8 e3 fd ff ff       	call   104876 <page_insert>
  104a93:	85 c0                	test   %eax,%eax
  104a95:	74 24                	je     104abb <check_pgdir+0x111>
  104a97:	c7 44 24 0c 58 6e 10 	movl   $0x106e58,0xc(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104aae:	00 
  104aaf:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104ab6:	e8 10 c2 ff ff       	call   100ccb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104abb:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104ac0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ac7:	00 
  104ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104acf:	00 
  104ad0:	89 04 24             	mov    %eax,(%esp)
  104ad3:	e8 68 fb ff ff       	call   104640 <get_pte>
  104ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104adf:	75 24                	jne    104b05 <check_pgdir+0x15b>
  104ae1:	c7 44 24 0c 84 6e 10 	movl   $0x106e84,0xc(%esp)
  104ae8:	00 
  104ae9:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104af0:	00 
  104af1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104af8:	00 
  104af9:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104b00:	e8 c6 c1 ff ff       	call   100ccb <__panic>
    assert(pa2page(*ptep) == p1);
  104b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b08:	8b 00                	mov    (%eax),%eax
  104b0a:	89 04 24             	mov    %eax,(%esp)
  104b0d:	e8 09 f1 ff ff       	call   103c1b <pa2page>
  104b12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b15:	74 24                	je     104b3b <check_pgdir+0x191>
  104b17:	c7 44 24 0c b1 6e 10 	movl   $0x106eb1,0xc(%esp)
  104b1e:	00 
  104b1f:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104b26:	00 
  104b27:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104b2e:	00 
  104b2f:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104b36:	e8 90 c1 ff ff       	call   100ccb <__panic>
    assert(page_ref(p1) == 1);
  104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b3e:	89 04 24             	mov    %eax,(%esp)
  104b41:	e8 b6 f1 ff ff       	call   103cfc <page_ref>
  104b46:	83 f8 01             	cmp    $0x1,%eax
  104b49:	74 24                	je     104b6f <check_pgdir+0x1c5>
  104b4b:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  104b52:	00 
  104b53:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104b5a:	00 
  104b5b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104b62:	00 
  104b63:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104b6a:	e8 5c c1 ff ff       	call   100ccb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b6f:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104b74:	8b 00                	mov    (%eax),%eax
  104b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b81:	c1 e8 0c             	shr    $0xc,%eax
  104b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b87:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104b8c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b8f:	72 23                	jb     104bb4 <check_pgdir+0x20a>
  104b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b98:	c7 44 24 08 94 6c 10 	movl   $0x106c94,0x8(%esp)
  104b9f:	00 
  104ba0:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104ba7:	00 
  104ba8:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104baf:	e8 17 c1 ff ff       	call   100ccb <__panic>
  104bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104bbc:	83 c0 04             	add    $0x4,%eax
  104bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104bc2:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104bc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104bce:	00 
  104bcf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bd6:	00 
  104bd7:	89 04 24             	mov    %eax,(%esp)
  104bda:	e8 61 fa ff ff       	call   104640 <get_pte>
  104bdf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104be2:	74 24                	je     104c08 <check_pgdir+0x25e>
  104be4:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104beb:	00 
  104bec:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104bf3:	00 
  104bf4:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104bfb:	00 
  104bfc:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104c03:	e8 c3 c0 ff ff       	call   100ccb <__panic>

    p2 = alloc_page();
  104c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c0f:	e8 ed f2 ff ff       	call   103f01 <alloc_pages>
  104c14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104c17:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c1c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104c23:	00 
  104c24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c2b:	00 
  104c2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c33:	89 04 24             	mov    %eax,(%esp)
  104c36:	e8 3b fc ff ff       	call   104876 <page_insert>
  104c3b:	85 c0                	test   %eax,%eax
  104c3d:	74 24                	je     104c63 <check_pgdir+0x2b9>
  104c3f:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104c46:	00 
  104c47:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104c4e:	00 
  104c4f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104c56:	00 
  104c57:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104c5e:	e8 68 c0 ff ff       	call   100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c63:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c68:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c6f:	00 
  104c70:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c77:	00 
  104c78:	89 04 24             	mov    %eax,(%esp)
  104c7b:	e8 c0 f9 ff ff       	call   104640 <get_pte>
  104c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c87:	75 24                	jne    104cad <check_pgdir+0x303>
  104c89:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104c90:	00 
  104c91:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104c98:	00 
  104c99:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104ca0:	00 
  104ca1:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104ca8:	e8 1e c0 ff ff       	call   100ccb <__panic>
    assert(*ptep & PTE_U);
  104cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cb0:	8b 00                	mov    (%eax),%eax
  104cb2:	83 e0 04             	and    $0x4,%eax
  104cb5:	85 c0                	test   %eax,%eax
  104cb7:	75 24                	jne    104cdd <check_pgdir+0x333>
  104cb9:	c7 44 24 0c 68 6f 10 	movl   $0x106f68,0xc(%esp)
  104cc0:	00 
  104cc1:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104cc8:	00 
  104cc9:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104cd0:	00 
  104cd1:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104cd8:	e8 ee bf ff ff       	call   100ccb <__panic>
    assert(*ptep & PTE_W);
  104cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce0:	8b 00                	mov    (%eax),%eax
  104ce2:	83 e0 02             	and    $0x2,%eax
  104ce5:	85 c0                	test   %eax,%eax
  104ce7:	75 24                	jne    104d0d <check_pgdir+0x363>
  104ce9:	c7 44 24 0c 76 6f 10 	movl   $0x106f76,0xc(%esp)
  104cf0:	00 
  104cf1:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104cf8:	00 
  104cf9:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104d00:	00 
  104d01:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104d08:	e8 be bf ff ff       	call   100ccb <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104d0d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d12:	8b 00                	mov    (%eax),%eax
  104d14:	83 e0 04             	and    $0x4,%eax
  104d17:	85 c0                	test   %eax,%eax
  104d19:	75 24                	jne    104d3f <check_pgdir+0x395>
  104d1b:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  104d22:	00 
  104d23:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104d2a:	00 
  104d2b:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104d32:	00 
  104d33:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104d3a:	e8 8c bf ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 1);
  104d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d42:	89 04 24             	mov    %eax,(%esp)
  104d45:	e8 b2 ef ff ff       	call   103cfc <page_ref>
  104d4a:	83 f8 01             	cmp    $0x1,%eax
  104d4d:	74 24                	je     104d73 <check_pgdir+0x3c9>
  104d4f:	c7 44 24 0c 9a 6f 10 	movl   $0x106f9a,0xc(%esp)
  104d56:	00 
  104d57:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104d5e:	00 
  104d5f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104d66:	00 
  104d67:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104d6e:	e8 58 bf ff ff       	call   100ccb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d73:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d78:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d7f:	00 
  104d80:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d87:	00 
  104d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d8f:	89 04 24             	mov    %eax,(%esp)
  104d92:	e8 df fa ff ff       	call   104876 <page_insert>
  104d97:	85 c0                	test   %eax,%eax
  104d99:	74 24                	je     104dbf <check_pgdir+0x415>
  104d9b:	c7 44 24 0c ac 6f 10 	movl   $0x106fac,0xc(%esp)
  104da2:	00 
  104da3:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104daa:	00 
  104dab:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104db2:	00 
  104db3:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104dba:	e8 0c bf ff ff       	call   100ccb <__panic>
    assert(page_ref(p1) == 2);
  104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dc2:	89 04 24             	mov    %eax,(%esp)
  104dc5:	e8 32 ef ff ff       	call   103cfc <page_ref>
  104dca:	83 f8 02             	cmp    $0x2,%eax
  104dcd:	74 24                	je     104df3 <check_pgdir+0x449>
  104dcf:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  104dd6:	00 
  104dd7:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104dde:	00 
  104ddf:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104de6:	00 
  104de7:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104dee:	e8 d8 be ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104df6:	89 04 24             	mov    %eax,(%esp)
  104df9:	e8 fe ee ff ff       	call   103cfc <page_ref>
  104dfe:	85 c0                	test   %eax,%eax
  104e00:	74 24                	je     104e26 <check_pgdir+0x47c>
  104e02:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104e09:	00 
  104e0a:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104e11:	00 
  104e12:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104e19:	00 
  104e1a:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104e21:	e8 a5 be ff ff       	call   100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104e26:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e32:	00 
  104e33:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e3a:	00 
  104e3b:	89 04 24             	mov    %eax,(%esp)
  104e3e:	e8 fd f7 ff ff       	call   104640 <get_pte>
  104e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e4a:	75 24                	jne    104e70 <check_pgdir+0x4c6>
  104e4c:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104e53:	00 
  104e54:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104e5b:	00 
  104e5c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104e63:	00 
  104e64:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104e6b:	e8 5b be ff ff       	call   100ccb <__panic>
    assert(pa2page(*ptep) == p1);
  104e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e73:	8b 00                	mov    (%eax),%eax
  104e75:	89 04 24             	mov    %eax,(%esp)
  104e78:	e8 9e ed ff ff       	call   103c1b <pa2page>
  104e7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e80:	74 24                	je     104ea6 <check_pgdir+0x4fc>
  104e82:	c7 44 24 0c b1 6e 10 	movl   $0x106eb1,0xc(%esp)
  104e89:	00 
  104e8a:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104e91:	00 
  104e92:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104e99:	00 
  104e9a:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104ea1:	e8 25 be ff ff       	call   100ccb <__panic>
    assert((*ptep & PTE_U) == 0);
  104ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ea9:	8b 00                	mov    (%eax),%eax
  104eab:	83 e0 04             	and    $0x4,%eax
  104eae:	85 c0                	test   %eax,%eax
  104eb0:	74 24                	je     104ed6 <check_pgdir+0x52c>
  104eb2:	c7 44 24 0c fc 6f 10 	movl   $0x106ffc,0xc(%esp)
  104eb9:	00 
  104eba:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104ec1:	00 
  104ec2:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104ec9:	00 
  104eca:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104ed1:	e8 f5 bd ff ff       	call   100ccb <__panic>

    page_remove(boot_pgdir, 0x0);
  104ed6:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ee2:	00 
  104ee3:	89 04 24             	mov    %eax,(%esp)
  104ee6:	e8 47 f9 ff ff       	call   104832 <page_remove>
    assert(page_ref(p1) == 1);
  104eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eee:	89 04 24             	mov    %eax,(%esp)
  104ef1:	e8 06 ee ff ff       	call   103cfc <page_ref>
  104ef6:	83 f8 01             	cmp    $0x1,%eax
  104ef9:	74 24                	je     104f1f <check_pgdir+0x575>
  104efb:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  104f02:	00 
  104f03:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104f0a:	00 
  104f0b:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104f12:	00 
  104f13:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104f1a:	e8 ac bd ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f22:	89 04 24             	mov    %eax,(%esp)
  104f25:	e8 d2 ed ff ff       	call   103cfc <page_ref>
  104f2a:	85 c0                	test   %eax,%eax
  104f2c:	74 24                	je     104f52 <check_pgdir+0x5a8>
  104f2e:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104f35:	00 
  104f36:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104f3d:	00 
  104f3e:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104f45:	00 
  104f46:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104f4d:	e8 79 bd ff ff       	call   100ccb <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104f52:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104f57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f5e:	00 
  104f5f:	89 04 24             	mov    %eax,(%esp)
  104f62:	e8 cb f8 ff ff       	call   104832 <page_remove>
    assert(page_ref(p1) == 0);
  104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f6a:	89 04 24             	mov    %eax,(%esp)
  104f6d:	e8 8a ed ff ff       	call   103cfc <page_ref>
  104f72:	85 c0                	test   %eax,%eax
  104f74:	74 24                	je     104f9a <check_pgdir+0x5f0>
  104f76:	c7 44 24 0c 11 70 10 	movl   $0x107011,0xc(%esp)
  104f7d:	00 
  104f7e:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104f85:	00 
  104f86:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104f8d:	00 
  104f8e:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104f95:	e8 31 bd ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f9d:	89 04 24             	mov    %eax,(%esp)
  104fa0:	e8 57 ed ff ff       	call   103cfc <page_ref>
  104fa5:	85 c0                	test   %eax,%eax
  104fa7:	74 24                	je     104fcd <check_pgdir+0x623>
  104fa9:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104fb0:	00 
  104fb1:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104fb8:	00 
  104fb9:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104fc0:	00 
  104fc1:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  104fc8:	e8 fe bc ff ff       	call   100ccb <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104fcd:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104fd2:	8b 00                	mov    (%eax),%eax
  104fd4:	89 04 24             	mov    %eax,(%esp)
  104fd7:	e8 3f ec ff ff       	call   103c1b <pa2page>
  104fdc:	89 04 24             	mov    %eax,(%esp)
  104fdf:	e8 18 ed ff ff       	call   103cfc <page_ref>
  104fe4:	83 f8 01             	cmp    $0x1,%eax
  104fe7:	74 24                	je     10500d <check_pgdir+0x663>
  104fe9:	c7 44 24 0c 24 70 10 	movl   $0x107024,0xc(%esp)
  104ff0:	00 
  104ff1:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  104ff8:	00 
  104ff9:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  105000:	00 
  105001:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  105008:	e8 be bc ff ff       	call   100ccb <__panic>
    free_page(pa2page(boot_pgdir[0]));
  10500d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105012:	8b 00                	mov    (%eax),%eax
  105014:	89 04 24             	mov    %eax,(%esp)
  105017:	e8 ff eb ff ff       	call   103c1b <pa2page>
  10501c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105023:	00 
  105024:	89 04 24             	mov    %eax,(%esp)
  105027:	e8 0d ef ff ff       	call   103f39 <free_pages>
    boot_pgdir[0] = 0;
  10502c:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105037:	c7 04 24 4a 70 10 00 	movl   $0x10704a,(%esp)
  10503e:	e8 f9 b2 ff ff       	call   10033c <cprintf>
}
  105043:	c9                   	leave  
  105044:	c3                   	ret    

00105045 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105045:	55                   	push   %ebp
  105046:	89 e5                	mov    %esp,%ebp
  105048:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10504b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105052:	e9 ca 00 00 00       	jmp    105121 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10505a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10505d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105060:	c1 e8 0c             	shr    $0xc,%eax
  105063:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105066:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  10506b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10506e:	72 23                	jb     105093 <check_boot_pgdir+0x4e>
  105070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105073:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105077:	c7 44 24 08 94 6c 10 	movl   $0x106c94,0x8(%esp)
  10507e:	00 
  10507f:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  105086:	00 
  105087:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10508e:	e8 38 bc ff ff       	call   100ccb <__panic>
  105093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105096:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10509b:	89 c2                	mov    %eax,%edx
  10509d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1050a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1050a9:	00 
  1050aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050ae:	89 04 24             	mov    %eax,(%esp)
  1050b1:	e8 8a f5 ff ff       	call   104640 <get_pte>
  1050b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1050bd:	75 24                	jne    1050e3 <check_boot_pgdir+0x9e>
  1050bf:	c7 44 24 0c 64 70 10 	movl   $0x107064,0xc(%esp)
  1050c6:	00 
  1050c7:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  1050ce:	00 
  1050cf:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  1050d6:	00 
  1050d7:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1050de:	e8 e8 bb ff ff       	call   100ccb <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1050e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050e6:	8b 00                	mov    (%eax),%eax
  1050e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050ed:	89 c2                	mov    %eax,%edx
  1050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050f2:	39 c2                	cmp    %eax,%edx
  1050f4:	74 24                	je     10511a <check_boot_pgdir+0xd5>
  1050f6:	c7 44 24 0c a1 70 10 	movl   $0x1070a1,0xc(%esp)
  1050fd:	00 
  1050fe:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  105105:	00 
  105106:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  10510d:	00 
  10510e:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  105115:	e8 b1 bb ff ff       	call   100ccb <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10511a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105124:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  105129:	39 c2                	cmp    %eax,%edx
  10512b:	0f 82 26 ff ff ff    	jb     105057 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105131:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105136:	05 ac 0f 00 00       	add    $0xfac,%eax
  10513b:	8b 00                	mov    (%eax),%eax
  10513d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105142:	89 c2                	mov    %eax,%edx
  105144:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10514c:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  105153:	77 23                	ja     105178 <check_boot_pgdir+0x133>
  105155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105158:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10515c:	c7 44 24 08 38 6d 10 	movl   $0x106d38,0x8(%esp)
  105163:	00 
  105164:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  10516b:	00 
  10516c:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  105173:	e8 53 bb ff ff       	call   100ccb <__panic>
  105178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10517b:	05 00 00 00 40       	add    $0x40000000,%eax
  105180:	39 c2                	cmp    %eax,%edx
  105182:	74 24                	je     1051a8 <check_boot_pgdir+0x163>
  105184:	c7 44 24 0c b8 70 10 	movl   $0x1070b8,0xc(%esp)
  10518b:	00 
  10518c:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  105193:	00 
  105194:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  10519b:	00 
  10519c:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1051a3:	e8 23 bb ff ff       	call   100ccb <__panic>

    assert(boot_pgdir[0] == 0);
  1051a8:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1051ad:	8b 00                	mov    (%eax),%eax
  1051af:	85 c0                	test   %eax,%eax
  1051b1:	74 24                	je     1051d7 <check_boot_pgdir+0x192>
  1051b3:	c7 44 24 0c ec 70 10 	movl   $0x1070ec,0xc(%esp)
  1051ba:	00 
  1051bb:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  1051c2:	00 
  1051c3:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1051ca:	00 
  1051cb:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1051d2:	e8 f4 ba ff ff       	call   100ccb <__panic>

    struct Page *p;
    p = alloc_page();
  1051d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051de:	e8 1e ed ff ff       	call   103f01 <alloc_pages>
  1051e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1051e6:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1051eb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1051f2:	00 
  1051f3:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1051fa:	00 
  1051fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  105202:	89 04 24             	mov    %eax,(%esp)
  105205:	e8 6c f6 ff ff       	call   104876 <page_insert>
  10520a:	85 c0                	test   %eax,%eax
  10520c:	74 24                	je     105232 <check_boot_pgdir+0x1ed>
  10520e:	c7 44 24 0c 00 71 10 	movl   $0x107100,0xc(%esp)
  105215:	00 
  105216:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  10521d:	00 
  10521e:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  105225:	00 
  105226:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10522d:	e8 99 ba ff ff       	call   100ccb <__panic>
    assert(page_ref(p) == 1);
  105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105235:	89 04 24             	mov    %eax,(%esp)
  105238:	e8 bf ea ff ff       	call   103cfc <page_ref>
  10523d:	83 f8 01             	cmp    $0x1,%eax
  105240:	74 24                	je     105266 <check_boot_pgdir+0x221>
  105242:	c7 44 24 0c 2e 71 10 	movl   $0x10712e,0xc(%esp)
  105249:	00 
  10524a:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  105251:	00 
  105252:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105259:	00 
  10525a:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  105261:	e8 65 ba ff ff       	call   100ccb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105266:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10526b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105272:	00 
  105273:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10527a:	00 
  10527b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10527e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105282:	89 04 24             	mov    %eax,(%esp)
  105285:	e8 ec f5 ff ff       	call   104876 <page_insert>
  10528a:	85 c0                	test   %eax,%eax
  10528c:	74 24                	je     1052b2 <check_boot_pgdir+0x26d>
  10528e:	c7 44 24 0c 40 71 10 	movl   $0x107140,0xc(%esp)
  105295:	00 
  105296:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  10529d:	00 
  10529e:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1052a5:	00 
  1052a6:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1052ad:	e8 19 ba ff ff       	call   100ccb <__panic>
    assert(page_ref(p) == 2);
  1052b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052b5:	89 04 24             	mov    %eax,(%esp)
  1052b8:	e8 3f ea ff ff       	call   103cfc <page_ref>
  1052bd:	83 f8 02             	cmp    $0x2,%eax
  1052c0:	74 24                	je     1052e6 <check_boot_pgdir+0x2a1>
  1052c2:	c7 44 24 0c 77 71 10 	movl   $0x107177,0xc(%esp)
  1052c9:	00 
  1052ca:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  1052d1:	00 
  1052d2:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1052d9:	00 
  1052da:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  1052e1:	e8 e5 b9 ff ff       	call   100ccb <__panic>

    const char *str = "ucore: Hello world!!";
  1052e6:	c7 45 dc 88 71 10 00 	movl   $0x107188,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1052ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052f4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052fb:	e8 1e 0a 00 00       	call   105d1e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105300:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105307:	00 
  105308:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10530f:	e8 83 0a 00 00       	call   105d97 <strcmp>
  105314:	85 c0                	test   %eax,%eax
  105316:	74 24                	je     10533c <check_boot_pgdir+0x2f7>
  105318:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  10531f:	00 
  105320:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  105327:	00 
  105328:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  10532f:	00 
  105330:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  105337:	e8 8f b9 ff ff       	call   100ccb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10533c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10533f:	89 04 24             	mov    %eax,(%esp)
  105342:	e8 23 e9 ff ff       	call   103c6a <page2kva>
  105347:	05 00 01 00 00       	add    $0x100,%eax
  10534c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10534f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105356:	e8 6b 09 00 00       	call   105cc6 <strlen>
  10535b:	85 c0                	test   %eax,%eax
  10535d:	74 24                	je     105383 <check_boot_pgdir+0x33e>
  10535f:	c7 44 24 0c d8 71 10 	movl   $0x1071d8,0xc(%esp)
  105366:	00 
  105367:	c7 44 24 08 81 6d 10 	movl   $0x106d81,0x8(%esp)
  10536e:	00 
  10536f:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  105376:	00 
  105377:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  10537e:	e8 48 b9 ff ff       	call   100ccb <__panic>

    free_page(p);
  105383:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10538a:	00 
  10538b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10538e:	89 04 24             	mov    %eax,(%esp)
  105391:	e8 a3 eb ff ff       	call   103f39 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105396:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10539b:	8b 00                	mov    (%eax),%eax
  10539d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1053a2:	89 04 24             	mov    %eax,(%esp)
  1053a5:	e8 71 e8 ff ff       	call   103c1b <pa2page>
  1053aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053b1:	00 
  1053b2:	89 04 24             	mov    %eax,(%esp)
  1053b5:	e8 7f eb ff ff       	call   103f39 <free_pages>
    boot_pgdir[0] = 0;
  1053ba:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1053bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1053c5:	c7 04 24 fc 71 10 00 	movl   $0x1071fc,(%esp)
  1053cc:	e8 6b af ff ff       	call   10033c <cprintf>
}
  1053d1:	c9                   	leave  
  1053d2:	c3                   	ret    

001053d3 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1053d3:	55                   	push   %ebp
  1053d4:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1053d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d9:	83 e0 04             	and    $0x4,%eax
  1053dc:	85 c0                	test   %eax,%eax
  1053de:	74 07                	je     1053e7 <perm2str+0x14>
  1053e0:	b8 75 00 00 00       	mov    $0x75,%eax
  1053e5:	eb 05                	jmp    1053ec <perm2str+0x19>
  1053e7:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1053ec:	a2 68 89 11 00       	mov    %al,0x118968
    str[1] = 'r';
  1053f1:	c6 05 69 89 11 00 72 	movb   $0x72,0x118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1053f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1053fb:	83 e0 02             	and    $0x2,%eax
  1053fe:	85 c0                	test   %eax,%eax
  105400:	74 07                	je     105409 <perm2str+0x36>
  105402:	b8 77 00 00 00       	mov    $0x77,%eax
  105407:	eb 05                	jmp    10540e <perm2str+0x3b>
  105409:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10540e:	a2 6a 89 11 00       	mov    %al,0x11896a
    str[3] = '\0';
  105413:	c6 05 6b 89 11 00 00 	movb   $0x0,0x11896b
    return str;
  10541a:	b8 68 89 11 00       	mov    $0x118968,%eax
}
  10541f:	5d                   	pop    %ebp
  105420:	c3                   	ret    

00105421 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105421:	55                   	push   %ebp
  105422:	89 e5                	mov    %esp,%ebp
  105424:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105427:	8b 45 10             	mov    0x10(%ebp),%eax
  10542a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10542d:	72 0a                	jb     105439 <get_pgtable_items+0x18>
        return 0;
  10542f:	b8 00 00 00 00       	mov    $0x0,%eax
  105434:	e9 9c 00 00 00       	jmp    1054d5 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105439:	eb 04                	jmp    10543f <get_pgtable_items+0x1e>
        start ++;
  10543b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10543f:	8b 45 10             	mov    0x10(%ebp),%eax
  105442:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105445:	73 18                	jae    10545f <get_pgtable_items+0x3e>
  105447:	8b 45 10             	mov    0x10(%ebp),%eax
  10544a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105451:	8b 45 14             	mov    0x14(%ebp),%eax
  105454:	01 d0                	add    %edx,%eax
  105456:	8b 00                	mov    (%eax),%eax
  105458:	83 e0 01             	and    $0x1,%eax
  10545b:	85 c0                	test   %eax,%eax
  10545d:	74 dc                	je     10543b <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10545f:	8b 45 10             	mov    0x10(%ebp),%eax
  105462:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105465:	73 69                	jae    1054d0 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105467:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10546b:	74 08                	je     105475 <get_pgtable_items+0x54>
            *left_store = start;
  10546d:	8b 45 18             	mov    0x18(%ebp),%eax
  105470:	8b 55 10             	mov    0x10(%ebp),%edx
  105473:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105475:	8b 45 10             	mov    0x10(%ebp),%eax
  105478:	8d 50 01             	lea    0x1(%eax),%edx
  10547b:	89 55 10             	mov    %edx,0x10(%ebp)
  10547e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105485:	8b 45 14             	mov    0x14(%ebp),%eax
  105488:	01 d0                	add    %edx,%eax
  10548a:	8b 00                	mov    (%eax),%eax
  10548c:	83 e0 07             	and    $0x7,%eax
  10548f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105492:	eb 04                	jmp    105498 <get_pgtable_items+0x77>
            start ++;
  105494:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105498:	8b 45 10             	mov    0x10(%ebp),%eax
  10549b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10549e:	73 1d                	jae    1054bd <get_pgtable_items+0x9c>
  1054a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1054a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1054aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1054ad:	01 d0                	add    %edx,%eax
  1054af:	8b 00                	mov    (%eax),%eax
  1054b1:	83 e0 07             	and    $0x7,%eax
  1054b4:	89 c2                	mov    %eax,%edx
  1054b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054b9:	39 c2                	cmp    %eax,%edx
  1054bb:	74 d7                	je     105494 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1054bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054c1:	74 08                	je     1054cb <get_pgtable_items+0xaa>
            *right_store = start;
  1054c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054c6:	8b 55 10             	mov    0x10(%ebp),%edx
  1054c9:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1054cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054ce:	eb 05                	jmp    1054d5 <get_pgtable_items+0xb4>
    }
    return 0;
  1054d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1054d5:	c9                   	leave  
  1054d6:	c3                   	ret    

001054d7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1054d7:	55                   	push   %ebp
  1054d8:	89 e5                	mov    %esp,%ebp
  1054da:	57                   	push   %edi
  1054db:	56                   	push   %esi
  1054dc:	53                   	push   %ebx
  1054dd:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1054e0:	c7 04 24 1c 72 10 00 	movl   $0x10721c,(%esp)
  1054e7:	e8 50 ae ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1054ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1054f3:	e9 fa 00 00 00       	jmp    1055f2 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054fb:	89 04 24             	mov    %eax,(%esp)
  1054fe:	e8 d0 fe ff ff       	call   1053d3 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105503:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105506:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105509:	29 d1                	sub    %edx,%ecx
  10550b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10550d:	89 d6                	mov    %edx,%esi
  10550f:	c1 e6 16             	shl    $0x16,%esi
  105512:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105515:	89 d3                	mov    %edx,%ebx
  105517:	c1 e3 16             	shl    $0x16,%ebx
  10551a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10551d:	89 d1                	mov    %edx,%ecx
  10551f:	c1 e1 16             	shl    $0x16,%ecx
  105522:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105525:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105528:	29 d7                	sub    %edx,%edi
  10552a:	89 fa                	mov    %edi,%edx
  10552c:	89 44 24 14          	mov    %eax,0x14(%esp)
  105530:	89 74 24 10          	mov    %esi,0x10(%esp)
  105534:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105538:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10553c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105540:	c7 04 24 4d 72 10 00 	movl   $0x10724d,(%esp)
  105547:	e8 f0 ad ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10554c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10554f:	c1 e0 0a             	shl    $0xa,%eax
  105552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105555:	eb 54                	jmp    1055ab <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10555a:	89 04 24             	mov    %eax,(%esp)
  10555d:	e8 71 fe ff ff       	call   1053d3 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105562:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105565:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105568:	29 d1                	sub    %edx,%ecx
  10556a:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10556c:	89 d6                	mov    %edx,%esi
  10556e:	c1 e6 0c             	shl    $0xc,%esi
  105571:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105574:	89 d3                	mov    %edx,%ebx
  105576:	c1 e3 0c             	shl    $0xc,%ebx
  105579:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10557c:	c1 e2 0c             	shl    $0xc,%edx
  10557f:	89 d1                	mov    %edx,%ecx
  105581:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105584:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105587:	29 d7                	sub    %edx,%edi
  105589:	89 fa                	mov    %edi,%edx
  10558b:	89 44 24 14          	mov    %eax,0x14(%esp)
  10558f:	89 74 24 10          	mov    %esi,0x10(%esp)
  105593:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10559b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10559f:	c7 04 24 6c 72 10 00 	movl   $0x10726c,(%esp)
  1055a6:	e8 91 ad ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1055ab:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1055b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1055b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1055b6:	89 ce                	mov    %ecx,%esi
  1055b8:	c1 e6 0a             	shl    $0xa,%esi
  1055bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1055be:	89 cb                	mov    %ecx,%ebx
  1055c0:	c1 e3 0a             	shl    $0xa,%ebx
  1055c3:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1055c6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1055ca:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1055cd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1055d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  1055dd:	89 1c 24             	mov    %ebx,(%esp)
  1055e0:	e8 3c fe ff ff       	call   105421 <get_pgtable_items>
  1055e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055ec:	0f 85 65 ff ff ff    	jne    105557 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1055f2:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1055f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055fa:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1055fd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105601:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105604:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105608:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10560c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105610:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105617:	00 
  105618:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10561f:	e8 fd fd ff ff       	call   105421 <get_pgtable_items>
  105624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10562b:	0f 85 c7 fe ff ff    	jne    1054f8 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105631:	c7 04 24 90 72 10 00 	movl   $0x107290,(%esp)
  105638:	e8 ff ac ff ff       	call   10033c <cprintf>
}
  10563d:	83 c4 4c             	add    $0x4c,%esp
  105640:	5b                   	pop    %ebx
  105641:	5e                   	pop    %esi
  105642:	5f                   	pop    %edi
  105643:	5d                   	pop    %ebp
  105644:	c3                   	ret    

00105645 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105645:	55                   	push   %ebp
  105646:	89 e5                	mov    %esp,%ebp
  105648:	83 ec 58             	sub    $0x58,%esp
  10564b:	8b 45 10             	mov    0x10(%ebp),%eax
  10564e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105651:	8b 45 14             	mov    0x14(%ebp),%eax
  105654:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105657:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10565a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10565d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105660:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105663:	8b 45 18             	mov    0x18(%ebp),%eax
  105666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10566c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10566f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10567b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10567f:	74 1c                	je     10569d <printnum+0x58>
  105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105684:	ba 00 00 00 00       	mov    $0x0,%edx
  105689:	f7 75 e4             	divl   -0x1c(%ebp)
  10568c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10568f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105692:	ba 00 00 00 00       	mov    $0x0,%edx
  105697:	f7 75 e4             	divl   -0x1c(%ebp)
  10569a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10569d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056a3:	f7 75 e4             	divl   -0x1c(%ebp)
  1056a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1056a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1056ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1056b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1056b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056bb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1056be:	8b 45 18             	mov    0x18(%ebp),%eax
  1056c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1056c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056c9:	77 56                	ja     105721 <printnum+0xdc>
  1056cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1056ce:	72 05                	jb     1056d5 <printnum+0x90>
  1056d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1056d3:	77 4c                	ja     105721 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1056d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1056d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1056db:	8b 45 20             	mov    0x20(%ebp),%eax
  1056de:	89 44 24 18          	mov    %eax,0x18(%esp)
  1056e2:	89 54 24 14          	mov    %edx,0x14(%esp)
  1056e6:	8b 45 18             	mov    0x18(%ebp),%eax
  1056e9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1056ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1056f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1056fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105702:	8b 45 08             	mov    0x8(%ebp),%eax
  105705:	89 04 24             	mov    %eax,(%esp)
  105708:	e8 38 ff ff ff       	call   105645 <printnum>
  10570d:	eb 1c                	jmp    10572b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10570f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105712:	89 44 24 04          	mov    %eax,0x4(%esp)
  105716:	8b 45 20             	mov    0x20(%ebp),%eax
  105719:	89 04 24             	mov    %eax,(%esp)
  10571c:	8b 45 08             	mov    0x8(%ebp),%eax
  10571f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105721:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105725:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105729:	7f e4                	jg     10570f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10572b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10572e:	05 44 73 10 00       	add    $0x107344,%eax
  105733:	0f b6 00             	movzbl (%eax),%eax
  105736:	0f be c0             	movsbl %al,%eax
  105739:	8b 55 0c             	mov    0xc(%ebp),%edx
  10573c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105740:	89 04 24             	mov    %eax,(%esp)
  105743:	8b 45 08             	mov    0x8(%ebp),%eax
  105746:	ff d0                	call   *%eax
}
  105748:	c9                   	leave  
  105749:	c3                   	ret    

0010574a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10574a:	55                   	push   %ebp
  10574b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10574d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105751:	7e 14                	jle    105767 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	8b 00                	mov    (%eax),%eax
  105758:	8d 48 08             	lea    0x8(%eax),%ecx
  10575b:	8b 55 08             	mov    0x8(%ebp),%edx
  10575e:	89 0a                	mov    %ecx,(%edx)
  105760:	8b 50 04             	mov    0x4(%eax),%edx
  105763:	8b 00                	mov    (%eax),%eax
  105765:	eb 30                	jmp    105797 <getuint+0x4d>
    }
    else if (lflag) {
  105767:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10576b:	74 16                	je     105783 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10576d:	8b 45 08             	mov    0x8(%ebp),%eax
  105770:	8b 00                	mov    (%eax),%eax
  105772:	8d 48 04             	lea    0x4(%eax),%ecx
  105775:	8b 55 08             	mov    0x8(%ebp),%edx
  105778:	89 0a                	mov    %ecx,(%edx)
  10577a:	8b 00                	mov    (%eax),%eax
  10577c:	ba 00 00 00 00       	mov    $0x0,%edx
  105781:	eb 14                	jmp    105797 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105783:	8b 45 08             	mov    0x8(%ebp),%eax
  105786:	8b 00                	mov    (%eax),%eax
  105788:	8d 48 04             	lea    0x4(%eax),%ecx
  10578b:	8b 55 08             	mov    0x8(%ebp),%edx
  10578e:	89 0a                	mov    %ecx,(%edx)
  105790:	8b 00                	mov    (%eax),%eax
  105792:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105797:	5d                   	pop    %ebp
  105798:	c3                   	ret    

00105799 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105799:	55                   	push   %ebp
  10579a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10579c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1057a0:	7e 14                	jle    1057b6 <getint+0x1d>
        return va_arg(*ap, long long);
  1057a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a5:	8b 00                	mov    (%eax),%eax
  1057a7:	8d 48 08             	lea    0x8(%eax),%ecx
  1057aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1057ad:	89 0a                	mov    %ecx,(%edx)
  1057af:	8b 50 04             	mov    0x4(%eax),%edx
  1057b2:	8b 00                	mov    (%eax),%eax
  1057b4:	eb 28                	jmp    1057de <getint+0x45>
    }
    else if (lflag) {
  1057b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1057ba:	74 12                	je     1057ce <getint+0x35>
        return va_arg(*ap, long);
  1057bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bf:	8b 00                	mov    (%eax),%eax
  1057c1:	8d 48 04             	lea    0x4(%eax),%ecx
  1057c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1057c7:	89 0a                	mov    %ecx,(%edx)
  1057c9:	8b 00                	mov    (%eax),%eax
  1057cb:	99                   	cltd   
  1057cc:	eb 10                	jmp    1057de <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1057ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d1:	8b 00                	mov    (%eax),%eax
  1057d3:	8d 48 04             	lea    0x4(%eax),%ecx
  1057d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1057d9:	89 0a                	mov    %ecx,(%edx)
  1057db:	8b 00                	mov    (%eax),%eax
  1057dd:	99                   	cltd   
    }
}
  1057de:	5d                   	pop    %ebp
  1057df:	c3                   	ret    

001057e0 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1057e0:	55                   	push   %ebp
  1057e1:	89 e5                	mov    %esp,%ebp
  1057e3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1057e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1057e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1057ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1057f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1057f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105801:	8b 45 08             	mov    0x8(%ebp),%eax
  105804:	89 04 24             	mov    %eax,(%esp)
  105807:	e8 02 00 00 00       	call   10580e <vprintfmt>
    va_end(ap);
}
  10580c:	c9                   	leave  
  10580d:	c3                   	ret    

0010580e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10580e:	55                   	push   %ebp
  10580f:	89 e5                	mov    %esp,%ebp
  105811:	56                   	push   %esi
  105812:	53                   	push   %ebx
  105813:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105816:	eb 18                	jmp    105830 <vprintfmt+0x22>
            if (ch == '\0') {
  105818:	85 db                	test   %ebx,%ebx
  10581a:	75 05                	jne    105821 <vprintfmt+0x13>
                return;
  10581c:	e9 d1 03 00 00       	jmp    105bf2 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105821:	8b 45 0c             	mov    0xc(%ebp),%eax
  105824:	89 44 24 04          	mov    %eax,0x4(%esp)
  105828:	89 1c 24             	mov    %ebx,(%esp)
  10582b:	8b 45 08             	mov    0x8(%ebp),%eax
  10582e:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105830:	8b 45 10             	mov    0x10(%ebp),%eax
  105833:	8d 50 01             	lea    0x1(%eax),%edx
  105836:	89 55 10             	mov    %edx,0x10(%ebp)
  105839:	0f b6 00             	movzbl (%eax),%eax
  10583c:	0f b6 d8             	movzbl %al,%ebx
  10583f:	83 fb 25             	cmp    $0x25,%ebx
  105842:	75 d4                	jne    105818 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105844:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105848:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10584f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105852:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105855:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10585c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10585f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105862:	8b 45 10             	mov    0x10(%ebp),%eax
  105865:	8d 50 01             	lea    0x1(%eax),%edx
  105868:	89 55 10             	mov    %edx,0x10(%ebp)
  10586b:	0f b6 00             	movzbl (%eax),%eax
  10586e:	0f b6 d8             	movzbl %al,%ebx
  105871:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105874:	83 f8 55             	cmp    $0x55,%eax
  105877:	0f 87 44 03 00 00    	ja     105bc1 <vprintfmt+0x3b3>
  10587d:	8b 04 85 68 73 10 00 	mov    0x107368(,%eax,4),%eax
  105884:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105886:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10588a:	eb d6                	jmp    105862 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10588c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105890:	eb d0                	jmp    105862 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10589c:	89 d0                	mov    %edx,%eax
  10589e:	c1 e0 02             	shl    $0x2,%eax
  1058a1:	01 d0                	add    %edx,%eax
  1058a3:	01 c0                	add    %eax,%eax
  1058a5:	01 d8                	add    %ebx,%eax
  1058a7:	83 e8 30             	sub    $0x30,%eax
  1058aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1058ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b0:	0f b6 00             	movzbl (%eax),%eax
  1058b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1058b6:	83 fb 2f             	cmp    $0x2f,%ebx
  1058b9:	7e 0b                	jle    1058c6 <vprintfmt+0xb8>
  1058bb:	83 fb 39             	cmp    $0x39,%ebx
  1058be:	7f 06                	jg     1058c6 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1058c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1058c4:	eb d3                	jmp    105899 <vprintfmt+0x8b>
            goto process_precision;
  1058c6:	eb 33                	jmp    1058fb <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1058c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058cb:	8d 50 04             	lea    0x4(%eax),%edx
  1058ce:	89 55 14             	mov    %edx,0x14(%ebp)
  1058d1:	8b 00                	mov    (%eax),%eax
  1058d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1058d6:	eb 23                	jmp    1058fb <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1058d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058dc:	79 0c                	jns    1058ea <vprintfmt+0xdc>
                width = 0;
  1058de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1058e5:	e9 78 ff ff ff       	jmp    105862 <vprintfmt+0x54>
  1058ea:	e9 73 ff ff ff       	jmp    105862 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1058ef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1058f6:	e9 67 ff ff ff       	jmp    105862 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1058fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058ff:	79 12                	jns    105913 <vprintfmt+0x105>
                width = precision, precision = -1;
  105901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105904:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105907:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10590e:	e9 4f ff ff ff       	jmp    105862 <vprintfmt+0x54>
  105913:	e9 4a ff ff ff       	jmp    105862 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105918:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10591c:	e9 41 ff ff ff       	jmp    105862 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105921:	8b 45 14             	mov    0x14(%ebp),%eax
  105924:	8d 50 04             	lea    0x4(%eax),%edx
  105927:	89 55 14             	mov    %edx,0x14(%ebp)
  10592a:	8b 00                	mov    (%eax),%eax
  10592c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10592f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105933:	89 04 24             	mov    %eax,(%esp)
  105936:	8b 45 08             	mov    0x8(%ebp),%eax
  105939:	ff d0                	call   *%eax
            break;
  10593b:	e9 ac 02 00 00       	jmp    105bec <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105940:	8b 45 14             	mov    0x14(%ebp),%eax
  105943:	8d 50 04             	lea    0x4(%eax),%edx
  105946:	89 55 14             	mov    %edx,0x14(%ebp)
  105949:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10594b:	85 db                	test   %ebx,%ebx
  10594d:	79 02                	jns    105951 <vprintfmt+0x143>
                err = -err;
  10594f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105951:	83 fb 06             	cmp    $0x6,%ebx
  105954:	7f 0b                	jg     105961 <vprintfmt+0x153>
  105956:	8b 34 9d 28 73 10 00 	mov    0x107328(,%ebx,4),%esi
  10595d:	85 f6                	test   %esi,%esi
  10595f:	75 23                	jne    105984 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105961:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105965:	c7 44 24 08 55 73 10 	movl   $0x107355,0x8(%esp)
  10596c:	00 
  10596d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105970:	89 44 24 04          	mov    %eax,0x4(%esp)
  105974:	8b 45 08             	mov    0x8(%ebp),%eax
  105977:	89 04 24             	mov    %eax,(%esp)
  10597a:	e8 61 fe ff ff       	call   1057e0 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10597f:	e9 68 02 00 00       	jmp    105bec <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105984:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105988:	c7 44 24 08 5e 73 10 	movl   $0x10735e,0x8(%esp)
  10598f:	00 
  105990:	8b 45 0c             	mov    0xc(%ebp),%eax
  105993:	89 44 24 04          	mov    %eax,0x4(%esp)
  105997:	8b 45 08             	mov    0x8(%ebp),%eax
  10599a:	89 04 24             	mov    %eax,(%esp)
  10599d:	e8 3e fe ff ff       	call   1057e0 <printfmt>
            }
            break;
  1059a2:	e9 45 02 00 00       	jmp    105bec <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1059a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1059aa:	8d 50 04             	lea    0x4(%eax),%edx
  1059ad:	89 55 14             	mov    %edx,0x14(%ebp)
  1059b0:	8b 30                	mov    (%eax),%esi
  1059b2:	85 f6                	test   %esi,%esi
  1059b4:	75 05                	jne    1059bb <vprintfmt+0x1ad>
                p = "(null)";
  1059b6:	be 61 73 10 00       	mov    $0x107361,%esi
            }
            if (width > 0 && padc != '-') {
  1059bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059bf:	7e 3e                	jle    1059ff <vprintfmt+0x1f1>
  1059c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1059c5:	74 38                	je     1059ff <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1059c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1059ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d1:	89 34 24             	mov    %esi,(%esp)
  1059d4:	e8 15 03 00 00       	call   105cee <strnlen>
  1059d9:	29 c3                	sub    %eax,%ebx
  1059db:	89 d8                	mov    %ebx,%eax
  1059dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059e0:	eb 17                	jmp    1059f9 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1059e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1059e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059ed:	89 04 24             	mov    %eax,(%esp)
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1059f5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059fd:	7f e3                	jg     1059e2 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059ff:	eb 38                	jmp    105a39 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105a01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105a05:	74 1f                	je     105a26 <vprintfmt+0x218>
  105a07:	83 fb 1f             	cmp    $0x1f,%ebx
  105a0a:	7e 05                	jle    105a11 <vprintfmt+0x203>
  105a0c:	83 fb 7e             	cmp    $0x7e,%ebx
  105a0f:	7e 15                	jle    105a26 <vprintfmt+0x218>
                    putch('?', putdat);
  105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a18:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a22:	ff d0                	call   *%eax
  105a24:	eb 0f                	jmp    105a35 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2d:	89 1c 24             	mov    %ebx,(%esp)
  105a30:	8b 45 08             	mov    0x8(%ebp),%eax
  105a33:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105a35:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a39:	89 f0                	mov    %esi,%eax
  105a3b:	8d 70 01             	lea    0x1(%eax),%esi
  105a3e:	0f b6 00             	movzbl (%eax),%eax
  105a41:	0f be d8             	movsbl %al,%ebx
  105a44:	85 db                	test   %ebx,%ebx
  105a46:	74 10                	je     105a58 <vprintfmt+0x24a>
  105a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a4c:	78 b3                	js     105a01 <vprintfmt+0x1f3>
  105a4e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105a52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105a56:	79 a9                	jns    105a01 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a58:	eb 17                	jmp    105a71 <vprintfmt+0x263>
                putch(' ', putdat);
  105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a61:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105a68:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6b:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a6d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a75:	7f e3                	jg     105a5a <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105a77:	e9 70 01 00 00       	jmp    105bec <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a83:	8d 45 14             	lea    0x14(%ebp),%eax
  105a86:	89 04 24             	mov    %eax,(%esp)
  105a89:	e8 0b fd ff ff       	call   105799 <getint>
  105a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a9a:	85 d2                	test   %edx,%edx
  105a9c:	79 26                	jns    105ac4 <vprintfmt+0x2b6>
                putch('-', putdat);
  105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105aac:	8b 45 08             	mov    0x8(%ebp),%eax
  105aaf:	ff d0                	call   *%eax
                num = -(long long)num;
  105ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ab7:	f7 d8                	neg    %eax
  105ab9:	83 d2 00             	adc    $0x0,%edx
  105abc:	f7 da                	neg    %edx
  105abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105ac4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105acb:	e9 a8 00 00 00       	jmp    105b78 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ad7:	8d 45 14             	lea    0x14(%ebp),%eax
  105ada:	89 04 24             	mov    %eax,(%esp)
  105add:	e8 68 fc ff ff       	call   10574a <getuint>
  105ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105ae8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105aef:	e9 84 00 00 00       	jmp    105b78 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105afb:	8d 45 14             	lea    0x14(%ebp),%eax
  105afe:	89 04 24             	mov    %eax,(%esp)
  105b01:	e8 44 fc ff ff       	call   10574a <getuint>
  105b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b09:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105b0c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105b13:	eb 63                	jmp    105b78 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b1c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105b23:	8b 45 08             	mov    0x8(%ebp),%eax
  105b26:	ff d0                	call   *%eax
            putch('x', putdat);
  105b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b2f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105b36:	8b 45 08             	mov    0x8(%ebp),%eax
  105b39:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  105b3e:	8d 50 04             	lea    0x4(%eax),%edx
  105b41:	89 55 14             	mov    %edx,0x14(%ebp)
  105b44:	8b 00                	mov    (%eax),%eax
  105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105b50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105b57:	eb 1f                	jmp    105b78 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b60:	8d 45 14             	lea    0x14(%ebp),%eax
  105b63:	89 04 24             	mov    %eax,(%esp)
  105b66:	e8 df fb ff ff       	call   10574a <getuint>
  105b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b71:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b78:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b7f:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b86:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b94:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b98:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba6:	89 04 24             	mov    %eax,(%esp)
  105ba9:	e8 97 fa ff ff       	call   105645 <printnum>
            break;
  105bae:	eb 3c                	jmp    105bec <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb7:	89 1c 24             	mov    %ebx,(%esp)
  105bba:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbd:	ff d0                	call   *%eax
            break;
  105bbf:	eb 2b                	jmp    105bec <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bc8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105bd4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bd8:	eb 04                	jmp    105bde <vprintfmt+0x3d0>
  105bda:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bde:	8b 45 10             	mov    0x10(%ebp),%eax
  105be1:	83 e8 01             	sub    $0x1,%eax
  105be4:	0f b6 00             	movzbl (%eax),%eax
  105be7:	3c 25                	cmp    $0x25,%al
  105be9:	75 ef                	jne    105bda <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105beb:	90                   	nop
        }
    }
  105bec:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105bed:	e9 3e fc ff ff       	jmp    105830 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105bf2:	83 c4 40             	add    $0x40,%esp
  105bf5:	5b                   	pop    %ebx
  105bf6:	5e                   	pop    %esi
  105bf7:	5d                   	pop    %ebp
  105bf8:	c3                   	ret    

00105bf9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105bf9:	55                   	push   %ebp
  105bfa:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bff:	8b 40 08             	mov    0x8(%eax),%eax
  105c02:	8d 50 01             	lea    0x1(%eax),%edx
  105c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c08:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0e:	8b 10                	mov    (%eax),%edx
  105c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c13:	8b 40 04             	mov    0x4(%eax),%eax
  105c16:	39 c2                	cmp    %eax,%edx
  105c18:	73 12                	jae    105c2c <sprintputch+0x33>
        *b->buf ++ = ch;
  105c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c1d:	8b 00                	mov    (%eax),%eax
  105c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  105c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c25:	89 0a                	mov    %ecx,(%edx)
  105c27:	8b 55 08             	mov    0x8(%ebp),%edx
  105c2a:	88 10                	mov    %dl,(%eax)
    }
}
  105c2c:	5d                   	pop    %ebp
  105c2d:	c3                   	ret    

00105c2e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105c2e:	55                   	push   %ebp
  105c2f:	89 e5                	mov    %esp,%ebp
  105c31:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105c34:	8d 45 14             	lea    0x14(%ebp),%eax
  105c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c41:	8b 45 10             	mov    0x10(%ebp),%eax
  105c44:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c52:	89 04 24             	mov    %eax,(%esp)
  105c55:	e8 08 00 00 00       	call   105c62 <vsnprintf>
  105c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c60:	c9                   	leave  
  105c61:	c3                   	ret    

00105c62 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105c62:	55                   	push   %ebp
  105c63:	89 e5                	mov    %esp,%ebp
  105c65:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105c68:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c71:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c74:	8b 45 08             	mov    0x8(%ebp),%eax
  105c77:	01 d0                	add    %edx,%eax
  105c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c87:	74 0a                	je     105c93 <vsnprintf+0x31>
  105c89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c8f:	39 c2                	cmp    %eax,%edx
  105c91:	76 07                	jbe    105c9a <vsnprintf+0x38>
        return -E_INVAL;
  105c93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c98:	eb 2a                	jmp    105cc4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c9a:	8b 45 14             	mov    0x14(%ebp),%eax
  105c9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ca8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  105caf:	c7 04 24 f9 5b 10 00 	movl   $0x105bf9,(%esp)
  105cb6:	e8 53 fb ff ff       	call   10580e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cbe:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105cc4:	c9                   	leave  
  105cc5:	c3                   	ret    

00105cc6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105cc6:	55                   	push   %ebp
  105cc7:	89 e5                	mov    %esp,%ebp
  105cc9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105cd3:	eb 04                	jmp    105cd9 <strlen+0x13>
        cnt ++;
  105cd5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdc:	8d 50 01             	lea    0x1(%eax),%edx
  105cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  105ce2:	0f b6 00             	movzbl (%eax),%eax
  105ce5:	84 c0                	test   %al,%al
  105ce7:	75 ec                	jne    105cd5 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105cec:	c9                   	leave  
  105ced:	c3                   	ret    

00105cee <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105cee:	55                   	push   %ebp
  105cef:	89 e5                	mov    %esp,%ebp
  105cf1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105cfb:	eb 04                	jmp    105d01 <strnlen+0x13>
        cnt ++;
  105cfd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d04:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105d07:	73 10                	jae    105d19 <strnlen+0x2b>
  105d09:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0c:	8d 50 01             	lea    0x1(%eax),%edx
  105d0f:	89 55 08             	mov    %edx,0x8(%ebp)
  105d12:	0f b6 00             	movzbl (%eax),%eax
  105d15:	84 c0                	test   %al,%al
  105d17:	75 e4                	jne    105cfd <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d1c:	c9                   	leave  
  105d1d:	c3                   	ret    

00105d1e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105d1e:	55                   	push   %ebp
  105d1f:	89 e5                	mov    %esp,%ebp
  105d21:	57                   	push   %edi
  105d22:	56                   	push   %esi
  105d23:	83 ec 20             	sub    $0x20,%esp
  105d26:	8b 45 08             	mov    0x8(%ebp),%eax
  105d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d38:	89 d1                	mov    %edx,%ecx
  105d3a:	89 c2                	mov    %eax,%edx
  105d3c:	89 ce                	mov    %ecx,%esi
  105d3e:	89 d7                	mov    %edx,%edi
  105d40:	ac                   	lods   %ds:(%esi),%al
  105d41:	aa                   	stos   %al,%es:(%edi)
  105d42:	84 c0                	test   %al,%al
  105d44:	75 fa                	jne    105d40 <strcpy+0x22>
  105d46:	89 fa                	mov    %edi,%edx
  105d48:	89 f1                	mov    %esi,%ecx
  105d4a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d4d:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105d50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105d56:	83 c4 20             	add    $0x20,%esp
  105d59:	5e                   	pop    %esi
  105d5a:	5f                   	pop    %edi
  105d5b:	5d                   	pop    %ebp
  105d5c:	c3                   	ret    

00105d5d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105d5d:	55                   	push   %ebp
  105d5e:	89 e5                	mov    %esp,%ebp
  105d60:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105d63:	8b 45 08             	mov    0x8(%ebp),%eax
  105d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105d69:	eb 21                	jmp    105d8c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6e:	0f b6 10             	movzbl (%eax),%edx
  105d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d74:	88 10                	mov    %dl,(%eax)
  105d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d79:	0f b6 00             	movzbl (%eax),%eax
  105d7c:	84 c0                	test   %al,%al
  105d7e:	74 04                	je     105d84 <strncpy+0x27>
            src ++;
  105d80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105d84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d88:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d90:	75 d9                	jne    105d6b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d95:	c9                   	leave  
  105d96:	c3                   	ret    

00105d97 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d97:	55                   	push   %ebp
  105d98:	89 e5                	mov    %esp,%ebp
  105d9a:	57                   	push   %edi
  105d9b:	56                   	push   %esi
  105d9c:	83 ec 20             	sub    $0x20,%esp
  105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105db1:	89 d1                	mov    %edx,%ecx
  105db3:	89 c2                	mov    %eax,%edx
  105db5:	89 ce                	mov    %ecx,%esi
  105db7:	89 d7                	mov    %edx,%edi
  105db9:	ac                   	lods   %ds:(%esi),%al
  105dba:	ae                   	scas   %es:(%edi),%al
  105dbb:	75 08                	jne    105dc5 <strcmp+0x2e>
  105dbd:	84 c0                	test   %al,%al
  105dbf:	75 f8                	jne    105db9 <strcmp+0x22>
  105dc1:	31 c0                	xor    %eax,%eax
  105dc3:	eb 04                	jmp    105dc9 <strcmp+0x32>
  105dc5:	19 c0                	sbb    %eax,%eax
  105dc7:	0c 01                	or     $0x1,%al
  105dc9:	89 fa                	mov    %edi,%edx
  105dcb:	89 f1                	mov    %esi,%ecx
  105dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105dd0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105dd3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105dd9:	83 c4 20             	add    $0x20,%esp
  105ddc:	5e                   	pop    %esi
  105ddd:	5f                   	pop    %edi
  105dde:	5d                   	pop    %ebp
  105ddf:	c3                   	ret    

00105de0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105de0:	55                   	push   %ebp
  105de1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105de3:	eb 0c                	jmp    105df1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105de5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105de9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ded:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105df5:	74 1a                	je     105e11 <strncmp+0x31>
  105df7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfa:	0f b6 00             	movzbl (%eax),%eax
  105dfd:	84 c0                	test   %al,%al
  105dff:	74 10                	je     105e11 <strncmp+0x31>
  105e01:	8b 45 08             	mov    0x8(%ebp),%eax
  105e04:	0f b6 10             	movzbl (%eax),%edx
  105e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e0a:	0f b6 00             	movzbl (%eax),%eax
  105e0d:	38 c2                	cmp    %al,%dl
  105e0f:	74 d4                	je     105de5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e15:	74 18                	je     105e2f <strncmp+0x4f>
  105e17:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1a:	0f b6 00             	movzbl (%eax),%eax
  105e1d:	0f b6 d0             	movzbl %al,%edx
  105e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e23:	0f b6 00             	movzbl (%eax),%eax
  105e26:	0f b6 c0             	movzbl %al,%eax
  105e29:	29 c2                	sub    %eax,%edx
  105e2b:	89 d0                	mov    %edx,%eax
  105e2d:	eb 05                	jmp    105e34 <strncmp+0x54>
  105e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e34:	5d                   	pop    %ebp
  105e35:	c3                   	ret    

00105e36 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105e36:	55                   	push   %ebp
  105e37:	89 e5                	mov    %esp,%ebp
  105e39:	83 ec 04             	sub    $0x4,%esp
  105e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e42:	eb 14                	jmp    105e58 <strchr+0x22>
        if (*s == c) {
  105e44:	8b 45 08             	mov    0x8(%ebp),%eax
  105e47:	0f b6 00             	movzbl (%eax),%eax
  105e4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e4d:	75 05                	jne    105e54 <strchr+0x1e>
            return (char *)s;
  105e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e52:	eb 13                	jmp    105e67 <strchr+0x31>
        }
        s ++;
  105e54:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105e58:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5b:	0f b6 00             	movzbl (%eax),%eax
  105e5e:	84 c0                	test   %al,%al
  105e60:	75 e2                	jne    105e44 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e67:	c9                   	leave  
  105e68:	c3                   	ret    

00105e69 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105e69:	55                   	push   %ebp
  105e6a:	89 e5                	mov    %esp,%ebp
  105e6c:	83 ec 04             	sub    $0x4,%esp
  105e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e72:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e75:	eb 11                	jmp    105e88 <strfind+0x1f>
        if (*s == c) {
  105e77:	8b 45 08             	mov    0x8(%ebp),%eax
  105e7a:	0f b6 00             	movzbl (%eax),%eax
  105e7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e80:	75 02                	jne    105e84 <strfind+0x1b>
            break;
  105e82:	eb 0e                	jmp    105e92 <strfind+0x29>
        }
        s ++;
  105e84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105e88:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8b:	0f b6 00             	movzbl (%eax),%eax
  105e8e:	84 c0                	test   %al,%al
  105e90:	75 e5                	jne    105e77 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105e92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e95:	c9                   	leave  
  105e96:	c3                   	ret    

00105e97 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e97:	55                   	push   %ebp
  105e98:	89 e5                	mov    %esp,%ebp
  105e9a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ea4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105eab:	eb 04                	jmp    105eb1 <strtol+0x1a>
        s ++;
  105ead:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb4:	0f b6 00             	movzbl (%eax),%eax
  105eb7:	3c 20                	cmp    $0x20,%al
  105eb9:	74 f2                	je     105ead <strtol+0x16>
  105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ebe:	0f b6 00             	movzbl (%eax),%eax
  105ec1:	3c 09                	cmp    $0x9,%al
  105ec3:	74 e8                	je     105ead <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec8:	0f b6 00             	movzbl (%eax),%eax
  105ecb:	3c 2b                	cmp    $0x2b,%al
  105ecd:	75 06                	jne    105ed5 <strtol+0x3e>
        s ++;
  105ecf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ed3:	eb 15                	jmp    105eea <strtol+0x53>
    }
    else if (*s == '-') {
  105ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed8:	0f b6 00             	movzbl (%eax),%eax
  105edb:	3c 2d                	cmp    $0x2d,%al
  105edd:	75 0b                	jne    105eea <strtol+0x53>
        s ++, neg = 1;
  105edf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ee3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105eee:	74 06                	je     105ef6 <strtol+0x5f>
  105ef0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105ef4:	75 24                	jne    105f1a <strtol+0x83>
  105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef9:	0f b6 00             	movzbl (%eax),%eax
  105efc:	3c 30                	cmp    $0x30,%al
  105efe:	75 1a                	jne    105f1a <strtol+0x83>
  105f00:	8b 45 08             	mov    0x8(%ebp),%eax
  105f03:	83 c0 01             	add    $0x1,%eax
  105f06:	0f b6 00             	movzbl (%eax),%eax
  105f09:	3c 78                	cmp    $0x78,%al
  105f0b:	75 0d                	jne    105f1a <strtol+0x83>
        s += 2, base = 16;
  105f0d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105f11:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105f18:	eb 2a                	jmp    105f44 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f1e:	75 17                	jne    105f37 <strtol+0xa0>
  105f20:	8b 45 08             	mov    0x8(%ebp),%eax
  105f23:	0f b6 00             	movzbl (%eax),%eax
  105f26:	3c 30                	cmp    $0x30,%al
  105f28:	75 0d                	jne    105f37 <strtol+0xa0>
        s ++, base = 8;
  105f2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f2e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105f35:	eb 0d                	jmp    105f44 <strtol+0xad>
    }
    else if (base == 0) {
  105f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f3b:	75 07                	jne    105f44 <strtol+0xad>
        base = 10;
  105f3d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105f44:	8b 45 08             	mov    0x8(%ebp),%eax
  105f47:	0f b6 00             	movzbl (%eax),%eax
  105f4a:	3c 2f                	cmp    $0x2f,%al
  105f4c:	7e 1b                	jle    105f69 <strtol+0xd2>
  105f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f51:	0f b6 00             	movzbl (%eax),%eax
  105f54:	3c 39                	cmp    $0x39,%al
  105f56:	7f 11                	jg     105f69 <strtol+0xd2>
            dig = *s - '0';
  105f58:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5b:	0f b6 00             	movzbl (%eax),%eax
  105f5e:	0f be c0             	movsbl %al,%eax
  105f61:	83 e8 30             	sub    $0x30,%eax
  105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f67:	eb 48                	jmp    105fb1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105f69:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6c:	0f b6 00             	movzbl (%eax),%eax
  105f6f:	3c 60                	cmp    $0x60,%al
  105f71:	7e 1b                	jle    105f8e <strtol+0xf7>
  105f73:	8b 45 08             	mov    0x8(%ebp),%eax
  105f76:	0f b6 00             	movzbl (%eax),%eax
  105f79:	3c 7a                	cmp    $0x7a,%al
  105f7b:	7f 11                	jg     105f8e <strtol+0xf7>
            dig = *s - 'a' + 10;
  105f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f80:	0f b6 00             	movzbl (%eax),%eax
  105f83:	0f be c0             	movsbl %al,%eax
  105f86:	83 e8 57             	sub    $0x57,%eax
  105f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f8c:	eb 23                	jmp    105fb1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f91:	0f b6 00             	movzbl (%eax),%eax
  105f94:	3c 40                	cmp    $0x40,%al
  105f96:	7e 3d                	jle    105fd5 <strtol+0x13e>
  105f98:	8b 45 08             	mov    0x8(%ebp),%eax
  105f9b:	0f b6 00             	movzbl (%eax),%eax
  105f9e:	3c 5a                	cmp    $0x5a,%al
  105fa0:	7f 33                	jg     105fd5 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa5:	0f b6 00             	movzbl (%eax),%eax
  105fa8:	0f be c0             	movsbl %al,%eax
  105fab:	83 e8 37             	sub    $0x37,%eax
  105fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fb4:	3b 45 10             	cmp    0x10(%ebp),%eax
  105fb7:	7c 02                	jl     105fbb <strtol+0x124>
            break;
  105fb9:	eb 1a                	jmp    105fd5 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105fbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fc2:	0f af 45 10          	imul   0x10(%ebp),%eax
  105fc6:	89 c2                	mov    %eax,%edx
  105fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fcb:	01 d0                	add    %edx,%eax
  105fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105fd0:	e9 6f ff ff ff       	jmp    105f44 <strtol+0xad>

    if (endptr) {
  105fd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105fd9:	74 08                	je     105fe3 <strtol+0x14c>
        *endptr = (char *) s;
  105fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fde:	8b 55 08             	mov    0x8(%ebp),%edx
  105fe1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105fe7:	74 07                	je     105ff0 <strtol+0x159>
  105fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fec:	f7 d8                	neg    %eax
  105fee:	eb 03                	jmp    105ff3 <strtol+0x15c>
  105ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105ff3:	c9                   	leave  
  105ff4:	c3                   	ret    

00105ff5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105ff5:	55                   	push   %ebp
  105ff6:	89 e5                	mov    %esp,%ebp
  105ff8:	57                   	push   %edi
  105ff9:	83 ec 24             	sub    $0x24,%esp
  105ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106002:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  106006:	8b 55 08             	mov    0x8(%ebp),%edx
  106009:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10600c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10600f:	8b 45 10             	mov    0x10(%ebp),%eax
  106012:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106015:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106018:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10601c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10601f:	89 d7                	mov    %edx,%edi
  106021:	f3 aa                	rep stos %al,%es:(%edi)
  106023:	89 fa                	mov    %edi,%edx
  106025:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106028:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10602b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10602e:	83 c4 24             	add    $0x24,%esp
  106031:	5f                   	pop    %edi
  106032:	5d                   	pop    %ebp
  106033:	c3                   	ret    

00106034 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106034:	55                   	push   %ebp
  106035:	89 e5                	mov    %esp,%ebp
  106037:	57                   	push   %edi
  106038:	56                   	push   %esi
  106039:	53                   	push   %ebx
  10603a:	83 ec 30             	sub    $0x30,%esp
  10603d:	8b 45 08             	mov    0x8(%ebp),%eax
  106040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106043:	8b 45 0c             	mov    0xc(%ebp),%eax
  106046:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106049:	8b 45 10             	mov    0x10(%ebp),%eax
  10604c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10604f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106052:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106055:	73 42                	jae    106099 <memmove+0x65>
  106057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10605a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10605d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106060:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106066:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10606c:	c1 e8 02             	shr    $0x2,%eax
  10606f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106074:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106077:	89 d7                	mov    %edx,%edi
  106079:	89 c6                	mov    %eax,%esi
  10607b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10607d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106080:	83 e1 03             	and    $0x3,%ecx
  106083:	74 02                	je     106087 <memmove+0x53>
  106085:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106087:	89 f0                	mov    %esi,%eax
  106089:	89 fa                	mov    %edi,%edx
  10608b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10608e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106091:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106097:	eb 36                	jmp    1060cf <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10609c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10609f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060a2:	01 c2                	add    %eax,%edx
  1060a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060a7:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1060aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060ad:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1060b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060b3:	89 c1                	mov    %eax,%ecx
  1060b5:	89 d8                	mov    %ebx,%eax
  1060b7:	89 d6                	mov    %edx,%esi
  1060b9:	89 c7                	mov    %eax,%edi
  1060bb:	fd                   	std    
  1060bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060be:	fc                   	cld    
  1060bf:	89 f8                	mov    %edi,%eax
  1060c1:	89 f2                	mov    %esi,%edx
  1060c3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1060c6:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1060c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1060cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1060cf:	83 c4 30             	add    $0x30,%esp
  1060d2:	5b                   	pop    %ebx
  1060d3:	5e                   	pop    %esi
  1060d4:	5f                   	pop    %edi
  1060d5:	5d                   	pop    %ebp
  1060d6:	c3                   	ret    

001060d7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1060d7:	55                   	push   %ebp
  1060d8:	89 e5                	mov    %esp,%ebp
  1060da:	57                   	push   %edi
  1060db:	56                   	push   %esi
  1060dc:	83 ec 20             	sub    $0x20,%esp
  1060df:	8b 45 08             	mov    0x8(%ebp),%eax
  1060e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1060ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1060f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060f4:	c1 e8 02             	shr    $0x2,%eax
  1060f7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1060f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1060fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060ff:	89 d7                	mov    %edx,%edi
  106101:	89 c6                	mov    %eax,%esi
  106103:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106105:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106108:	83 e1 03             	and    $0x3,%ecx
  10610b:	74 02                	je     10610f <memcpy+0x38>
  10610d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10610f:	89 f0                	mov    %esi,%eax
  106111:	89 fa                	mov    %edi,%edx
  106113:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106116:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106119:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10611c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10611f:	83 c4 20             	add    $0x20,%esp
  106122:	5e                   	pop    %esi
  106123:	5f                   	pop    %edi
  106124:	5d                   	pop    %ebp
  106125:	c3                   	ret    

00106126 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106126:	55                   	push   %ebp
  106127:	89 e5                	mov    %esp,%ebp
  106129:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10612c:	8b 45 08             	mov    0x8(%ebp),%eax
  10612f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106132:	8b 45 0c             	mov    0xc(%ebp),%eax
  106135:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106138:	eb 30                	jmp    10616a <memcmp+0x44>
        if (*s1 != *s2) {
  10613a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10613d:	0f b6 10             	movzbl (%eax),%edx
  106140:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106143:	0f b6 00             	movzbl (%eax),%eax
  106146:	38 c2                	cmp    %al,%dl
  106148:	74 18                	je     106162 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10614a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10614d:	0f b6 00             	movzbl (%eax),%eax
  106150:	0f b6 d0             	movzbl %al,%edx
  106153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106156:	0f b6 00             	movzbl (%eax),%eax
  106159:	0f b6 c0             	movzbl %al,%eax
  10615c:	29 c2                	sub    %eax,%edx
  10615e:	89 d0                	mov    %edx,%eax
  106160:	eb 1a                	jmp    10617c <memcmp+0x56>
        }
        s1 ++, s2 ++;
  106162:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106166:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10616a:	8b 45 10             	mov    0x10(%ebp),%eax
  10616d:	8d 50 ff             	lea    -0x1(%eax),%edx
  106170:	89 55 10             	mov    %edx,0x10(%ebp)
  106173:	85 c0                	test   %eax,%eax
  106175:	75 c3                	jne    10613a <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10617c:	c9                   	leave  
  10617d:	c3                   	ret    
