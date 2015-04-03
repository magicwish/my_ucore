
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba e8 89 11 c0       	mov    $0xc01189e8,%edx
c0100035:	b8 56 7a 11 c0       	mov    $0xc0117a56,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 56 7a 11 c0 	movl   $0xc0117a56,(%esp)
c0100051:	e8 9f 5f 00 00       	call   c0105ff5 <memset>

    cons_init();                // init the console
c0100056:	e8 76 15 00 00       	call   c01015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 61 10 c0 	movl   $0xc0106180,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 61 10 c0 	movl   $0xc010619c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 8d 44 00 00       	call   c0104511 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b1 16 00 00       	call   c010173a <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 29 18 00 00       	call   c01018b7 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f4 0c 00 00       	call   c0100d87 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 10 16 00 00       	call   c01016a8 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 fd 0b 00 00       	call   c0100cb9 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 61 10 c0 	movl   $0xc01061a1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 61 10 c0 	movl   $0xc01061af,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 61 10 c0 	movl   $0xc01061bd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 61 10 c0 	movl   $0xc01061cb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 61 10 c0 	movl   $0xc01061d9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 60 7a 11 c0       	mov    0xc0117a60,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 60 7a 11 c0       	mov    %eax,0xc0117a60
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 62 10 c0 	movl   $0xc0106208,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 62 10 c0 	movl   $0xc0106227,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 80 7a 11 c0    	mov    %dl,-0x3fee8580(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 80 7a 11 c0       	add    $0xc0117a80,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 80 7a 11 c0       	mov    $0xc0117a80,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 03 13 00 00       	call   c01015fd <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 d7 54 00 00       	call   c010580e <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8a 12 00 00       	call   c01015fd <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6a 12 00 00       	call   c0101639 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 62 10 c0    	movl   $0xc010622c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 62 10 c0 	movl   $0xc010622c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 c0 74 10 c0 	movl   $0xc01074c0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 c4 24 11 c0 	movl   $0xc01124c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec c5 24 11 c0 	movl   $0xc01124c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 62 4f 11 c0 	movl   $0xc0114f62,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 7d 57 00 00       	call   c0105e69 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 62 10 c0 	movl   $0xc0106236,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 62 10 c0 	movl   $0xc010624f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 7e 61 10 	movl   $0xc010617e,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 62 10 c0 	movl   $0xc0106267,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 56 7a 11 	movl   $0xc0117a56,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 62 10 c0 	movl   $0xc010627f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 e8 89 11 	movl   $0xc01189e8,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 62 10 c0 	movl   $0xc0106297,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 e8 89 11 c0       	mov    $0xc01189e8,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 62 10 c0 	movl   $0xc01062b0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 62 10 c0 	movl   $0xc01062da,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 62 10 c0 	movl   $0xc01062f6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
	cprintf("Hello world\n");
c01009c0:	c7 04 24 08 63 10 c0 	movl   $0xc0106308,(%esp)
c01009c7:	e8 70 f9 ff ff       	call   c010033c <cprintf>
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	uint32_t ebp = read_ebp();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009d7:	e8 cd ff ff ff       	call   c01009a9 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (ebp != 0)
c01009df:	e9 8e 00 00 00       	jmp    c0100a72 <print_stackframe+0xb8>
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f2:	c7 04 24 15 63 10 c0 	movl   $0xc0106315,(%esp)
c01009f9:	e8 3e f9 ff ff       	call   c010033c <cprintf>
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
c01009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a01:	83 c0 08             	add    $0x8,%eax
c0100a04:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int i = 0;
c0100a07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (; i < 4; i++)
c0100a0e:	eb 2f                	jmp    c0100a3f <print_stackframe+0x85>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
c0100a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1d:	01 d0                	add    %edx,%eax
c0100a1f:	8b 00                	mov    (%eax),%eax
c0100a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100a24:	83 c2 01             	add    $0x1,%edx
c0100a27:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a2b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100a2f:	c7 04 24 2c 63 10 c0 	movl   $0xc010632c,(%esp)
c0100a36:	e8 01 f9 ff ff       	call   c010033c <cprintf>
	while (ebp != 0)
	{
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t* argBaseAddr = (uint32_t*)ebp + 2;
		int i = 0;
		for (; i < 4; i++)
c0100a3b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a3f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0100a43:	7e cb                	jle    c0100a10 <print_stackframe+0x56>
			cprintf("arg%d:0x%08x ", i+1, *(argBaseAddr+i));
		print_debuginfo(eip-1);
c0100a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a48:	83 e8 01             	sub    $0x1,%eax
c0100a4b:	89 04 24             	mov    %eax,(%esp)
c0100a4e:	e8 b3 fe ff ff       	call   c0100906 <print_debuginfo>
		cprintf("\n");
c0100a53:	c7 04 24 3a 63 10 c0 	movl   $0xc010633a,(%esp)
c0100a5a:	e8 dd f8 ff ff       	call   c010033c <cprintf>
		eip = *((uint32_t*)ebp+1);
c0100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a62:	83 c0 04             	add    $0x4,%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *(uint32_t*)ebp;	
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	cprintf("Hello world\n");
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	while (ebp != 0)
c0100a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a76:	0f 85 68 ff ff ff    	jne    c01009e4 <print_stackframe+0x2a>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a7c:	c9                   	leave  
c0100a7d:	c3                   	ret    

c0100a7e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7e:	55                   	push   %ebp
c0100a7f:	89 e5                	mov    %esp,%ebp
c0100a81:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8b:	eb 0c                	jmp    c0100a99 <parse+0x1b>
            *buf ++ = '\0';
c0100a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a90:	8d 50 01             	lea    0x1(%eax),%edx
c0100a93:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a96:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9c:	0f b6 00             	movzbl (%eax),%eax
c0100a9f:	84 c0                	test   %al,%al
c0100aa1:	74 1d                	je     c0100ac0 <parse+0x42>
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	0f b6 00             	movzbl (%eax),%eax
c0100aa9:	0f be c0             	movsbl %al,%eax
c0100aac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab0:	c7 04 24 bc 63 10 c0 	movl   $0xc01063bc,(%esp)
c0100ab7:	e8 7a 53 00 00       	call   c0105e36 <strchr>
c0100abc:	85 c0                	test   %eax,%eax
c0100abe:	75 cd                	jne    c0100a8d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac3:	0f b6 00             	movzbl (%eax),%eax
c0100ac6:	84 c0                	test   %al,%al
c0100ac8:	75 02                	jne    c0100acc <parse+0x4e>
            break;
c0100aca:	eb 67                	jmp    c0100b33 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad0:	75 14                	jne    c0100ae6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad9:	00 
c0100ada:	c7 04 24 c1 63 10 c0 	movl   $0xc01063c1,(%esp)
c0100ae1:	e8 56 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae9:	8d 50 01             	lea    0x1(%eax),%edx
c0100aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af9:	01 c2                	add    %eax,%edx
c0100afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afe:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b00:	eb 04                	jmp    c0100b06 <parse+0x88>
            buf ++;
c0100b02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b09:	0f b6 00             	movzbl (%eax),%eax
c0100b0c:	84 c0                	test   %al,%al
c0100b0e:	74 1d                	je     c0100b2d <parse+0xaf>
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	0f b6 00             	movzbl (%eax),%eax
c0100b16:	0f be c0             	movsbl %al,%eax
c0100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1d:	c7 04 24 bc 63 10 c0 	movl   $0xc01063bc,(%esp)
c0100b24:	e8 0d 53 00 00       	call   c0105e36 <strchr>
c0100b29:	85 c0                	test   %eax,%eax
c0100b2b:	74 d5                	je     c0100b02 <parse+0x84>
            buf ++;
        }
    }
c0100b2d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2e:	e9 66 ff ff ff       	jmp    c0100a99 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b36:	c9                   	leave  
c0100b37:	c3                   	ret    

c0100b38 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b38:	55                   	push   %ebp
c0100b39:	89 e5                	mov    %esp,%ebp
c0100b3b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b48:	89 04 24             	mov    %eax,(%esp)
c0100b4b:	e8 2e ff ff ff       	call   c0100a7e <parse>
c0100b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b57:	75 0a                	jne    c0100b63 <runcmd+0x2b>
        return 0;
c0100b59:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b5e:	e9 85 00 00 00       	jmp    c0100be8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6a:	eb 5c                	jmp    c0100bc8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b72:	89 d0                	mov    %edx,%eax
c0100b74:	01 c0                	add    %eax,%eax
c0100b76:	01 d0                	add    %edx,%eax
c0100b78:	c1 e0 02             	shl    $0x2,%eax
c0100b7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b80:	8b 00                	mov    (%eax),%eax
c0100b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b86:	89 04 24             	mov    %eax,(%esp)
c0100b89:	e8 09 52 00 00       	call   c0105d97 <strcmp>
c0100b8e:	85 c0                	test   %eax,%eax
c0100b90:	75 32                	jne    c0100bc4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b95:	89 d0                	mov    %edx,%eax
c0100b97:	01 c0                	add    %eax,%eax
c0100b99:	01 d0                	add    %edx,%eax
c0100b9b:	c1 e0 02             	shl    $0x2,%eax
c0100b9e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba3:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba9:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bac:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb3:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb6:	83 c2 04             	add    $0x4,%edx
c0100bb9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbd:	89 0c 24             	mov    %ecx,(%esp)
c0100bc0:	ff d0                	call   *%eax
c0100bc2:	eb 24                	jmp    c0100be8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcb:	83 f8 02             	cmp    $0x2,%eax
c0100bce:	76 9c                	jbe    c0100b6c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd7:	c7 04 24 df 63 10 c0 	movl   $0xc01063df,(%esp)
c0100bde:	e8 59 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be8:	c9                   	leave  
c0100be9:	c3                   	ret    

c0100bea <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bea:	55                   	push   %ebp
c0100beb:	89 e5                	mov    %esp,%ebp
c0100bed:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf0:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
c0100bf7:	e8 40 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfc:	c7 04 24 20 64 10 c0 	movl   $0xc0106420,(%esp)
c0100c03:	e8 34 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0c:	74 0b                	je     c0100c19 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 04 24             	mov    %eax,(%esp)
c0100c14:	e8 d7 0d 00 00       	call   c01019f0 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c19:	c7 04 24 45 64 10 c0 	movl   $0xc0106445,(%esp)
c0100c20:	e8 0e f6 ff ff       	call   c0100233 <readline>
c0100c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2c:	74 18                	je     c0100c46 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c38:	89 04 24             	mov    %eax,(%esp)
c0100c3b:	e8 f8 fe ff ff       	call   c0100b38 <runcmd>
c0100c40:	85 c0                	test   %eax,%eax
c0100c42:	79 02                	jns    c0100c46 <kmonitor+0x5c>
                break;
c0100c44:	eb 02                	jmp    c0100c48 <kmonitor+0x5e>
            }
        }
    }
c0100c46:	eb d1                	jmp    c0100c19 <kmonitor+0x2f>
}
c0100c48:	c9                   	leave  
c0100c49:	c3                   	ret    

c0100c4a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4a:	55                   	push   %ebp
c0100c4b:	89 e5                	mov    %esp,%ebp
c0100c4d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c57:	eb 3f                	jmp    c0100c98 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5c:	89 d0                	mov    %edx,%eax
c0100c5e:	01 c0                	add    %eax,%eax
c0100c60:	01 d0                	add    %edx,%eax
c0100c62:	c1 e0 02             	shl    $0x2,%eax
c0100c65:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6a:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c70:	89 d0                	mov    %edx,%eax
c0100c72:	01 c0                	add    %eax,%eax
c0100c74:	01 d0                	add    %edx,%eax
c0100c76:	c1 e0 02             	shl    $0x2,%eax
c0100c79:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c7e:	8b 00                	mov    (%eax),%eax
c0100c80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c88:	c7 04 24 49 64 10 c0 	movl   $0xc0106449,(%esp)
c0100c8f:	e8 a8 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9b:	83 f8 02             	cmp    $0x2,%eax
c0100c9e:	76 b9                	jbe    c0100c59 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca5:	c9                   	leave  
c0100ca6:	c3                   	ret    

c0100ca7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca7:	55                   	push   %ebp
c0100ca8:	89 e5                	mov    %esp,%ebp
c0100caa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cad:	e8 be fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cbf:	e8 f6 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0100cd6:	85 c0                	test   %eax,%eax
c0100cd8:	74 02                	je     c0100cdc <__panic+0x11>
        goto panic_dead;
c0100cda:	eb 48                	jmp    c0100d24 <__panic+0x59>
    }
    is_panic = 1;
c0100cdc:	c7 05 80 7e 11 c0 01 	movl   $0x1,0xc0117e80
c0100ce3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce6:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cef:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfa:	c7 04 24 52 64 10 c0 	movl   $0xc0106452,(%esp)
c0100d01:	e8 36 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d10:	89 04 24             	mov    %eax,(%esp)
c0100d13:	e8 f1 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d18:	c7 04 24 6e 64 10 c0 	movl   $0xc010646e,(%esp)
c0100d1f:	e8 18 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d24:	e8 85 09 00 00       	call   c01016ae <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d30:	e8 b5 fe ff ff       	call   c0100bea <kmonitor>
    }
c0100d35:	eb f2                	jmp    c0100d29 <__panic+0x5e>

c0100d37 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d37:	55                   	push   %ebp
c0100d38:	89 e5                	mov    %esp,%ebp
c0100d3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d51:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0100d58:	e8 df f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d64:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d67:	89 04 24             	mov    %eax,(%esp)
c0100d6a:	e8 9a f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6f:	c7 04 24 6e 64 10 c0 	movl   $0xc010646e,(%esp)
c0100d76:	e8 c1 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7b:	c9                   	leave  
c0100d7c:	c3                   	ret    

c0100d7d <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7d:	55                   	push   %ebp
c0100d7e:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d80:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
}
c0100d85:	5d                   	pop    %ebp
c0100d86:	c3                   	ret    

c0100d87 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d87:	55                   	push   %ebp
c0100d88:	89 e5                	mov    %esp,%ebp
c0100d8a:	83 ec 28             	sub    $0x28,%esp
c0100d8d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d93:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d97:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9f:	ee                   	out    %al,(%dx)
c0100da0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100daa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db2:	ee                   	out    %al,(%dx)
c0100db3:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db9:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc6:	c7 05 6c 89 11 c0 00 	movl   $0x0,0xc011896c
c0100dcd:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd0:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0100dd7:	e8 60 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100ddc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de3:	e8 24 09 00 00       	call   c010170c <pic_enable>
}
c0100de8:	c9                   	leave  
c0100de9:	c3                   	ret    

c0100dea <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dea:	55                   	push   %ebp
c0100deb:	89 e5                	mov    %esp,%ebp
c0100ded:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df0:	9c                   	pushf  
c0100df1:	58                   	pop    %eax
c0100df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df8:	25 00 02 00 00       	and    $0x200,%eax
c0100dfd:	85 c0                	test   %eax,%eax
c0100dff:	74 0c                	je     c0100e0d <__intr_save+0x23>
        intr_disable();
c0100e01:	e8 a8 08 00 00       	call   c01016ae <intr_disable>
        return 1;
c0100e06:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0b:	eb 05                	jmp    c0100e12 <__intr_save+0x28>
    }
    return 0;
c0100e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e12:	c9                   	leave  
c0100e13:	c3                   	ret    

c0100e14 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e14:	55                   	push   %ebp
c0100e15:	89 e5                	mov    %esp,%ebp
c0100e17:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e1e:	74 05                	je     c0100e25 <__intr_restore+0x11>
        intr_enable();
c0100e20:	e8 83 08 00 00       	call   c01016a8 <intr_enable>
    }
}
c0100e25:	c9                   	leave  
c0100e26:	c3                   	ret    

c0100e27 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e27:	55                   	push   %ebp
c0100e28:	89 e5                	mov    %esp,%ebp
c0100e2a:	83 ec 10             	sub    $0x10,%esp
c0100e2d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e33:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e37:	89 c2                	mov    %eax,%edx
c0100e39:	ec                   	in     (%dx),%al
c0100e3a:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e43:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e47:	89 c2                	mov    %eax,%edx
c0100e49:	ec                   	in     (%dx),%al
c0100e4a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e53:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e57:	89 c2                	mov    %eax,%edx
c0100e59:	ec                   	in     (%dx),%al
c0100e5a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e67:	89 c2                	mov    %eax,%edx
c0100e69:	ec                   	in     (%dx),%al
c0100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6d:	c9                   	leave  
c0100e6e:	c3                   	ret    

c0100e6f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6f:	55                   	push   %ebp
c0100e70:	89 e5                	mov    %esp,%ebp
c0100e72:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e75:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7f:	0f b7 00             	movzwl (%eax),%eax
c0100e82:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e98:	74 12                	je     c0100eac <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea1:	66 c7 05 a6 7e 11 c0 	movw   $0x3b4,0xc0117ea6
c0100ea8:	b4 03 
c0100eaa:	eb 13                	jmp    c0100ebf <cga_init+0x50>
    } else {
        *cp = was;
c0100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb6:	66 c7 05 a6 7e 11 c0 	movw   $0x3d4,0xc0117ea6
c0100ebd:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ebf:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c0100ec6:	0f b7 c0             	movzwl %ax,%eax
c0100ec9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eda:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c0100ee1:	83 c0 01             	add    $0x1,%eax
c0100ee4:	0f b7 c0             	movzwl %ax,%eax
c0100ee7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eeb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eef:	89 c2                	mov    %eax,%edx
c0100ef1:	ec                   	in     (%dx),%al
c0100ef2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef9:	0f b6 c0             	movzbl %al,%eax
c0100efc:	c1 e0 08             	shl    $0x8,%eax
c0100eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f02:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c0100f09:	0f b7 c0             	movzwl %ax,%eax
c0100f0c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f10:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f14:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f18:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1d:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c0100f24:	83 c0 01             	add    $0x1,%eax
c0100f27:	0f b7 c0             	movzwl %ax,%eax
c0100f2a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f32:	89 c2                	mov    %eax,%edx
c0100f34:	ec                   	in     (%dx),%al
c0100f35:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f38:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3c:	0f b6 c0             	movzbl %al,%eax
c0100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f45:	a3 a0 7e 11 c0       	mov    %eax,0xc0117ea0
    crt_pos = pos;
c0100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4d:	66 a3 a4 7e 11 c0    	mov    %ax,0xc0117ea4
}
c0100f53:	c9                   	leave  
c0100f54:	c3                   	ret    

c0100f55 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f55:	55                   	push   %ebp
c0100f56:	89 e5                	mov    %esp,%ebp
c0100f58:	83 ec 48             	sub    $0x48,%esp
c0100f5b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f61:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f65:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f69:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6d:	ee                   	out    %al,(%dx)
c0100f6e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f74:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
c0100f81:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f87:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f9e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fad:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
c0100fcd:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
c0100fe0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fea:	89 c2                	mov    %eax,%edx
c0100fec:	ec                   	in     (%dx),%al
c0100fed:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff4:	3c ff                	cmp    $0xff,%al
c0100ff6:	0f 95 c0             	setne  %al
c0100ff9:	0f b6 c0             	movzbl %al,%eax
c0100ffc:	a3 a8 7e 11 c0       	mov    %eax,0xc0117ea8
c0101001:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101007:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100b:	89 c2                	mov    %eax,%edx
c010100d:	ec                   	in     (%dx),%al
c010100e:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101011:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101017:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101b:	89 c2                	mov    %eax,%edx
c010101d:	ec                   	in     (%dx),%al
c010101e:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101021:	a1 a8 7e 11 c0       	mov    0xc0117ea8,%eax
c0101026:	85 c0                	test   %eax,%eax
c0101028:	74 0c                	je     c0101036 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101031:	e8 d6 06 00 00       	call   c010170c <pic_enable>
    }
}
c0101036:	c9                   	leave  
c0101037:	c3                   	ret    

c0101038 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101038:	55                   	push   %ebp
c0101039:	89 e5                	mov    %esp,%ebp
c010103b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101045:	eb 09                	jmp    c0101050 <lpt_putc_sub+0x18>
        delay();
c0101047:	e8 db fd ff ff       	call   c0100e27 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101050:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101056:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105a:	89 c2                	mov    %eax,%edx
c010105c:	ec                   	in     (%dx),%al
c010105d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101060:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101064:	84 c0                	test   %al,%al
c0101066:	78 09                	js     c0101071 <lpt_putc_sub+0x39>
c0101068:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106f:	7e d6                	jle    c0101047 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101071:	8b 45 08             	mov    0x8(%ebp),%eax
c0101074:	0f b6 c0             	movzbl %al,%eax
c0101077:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101080:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101084:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101088:	ee                   	out    %al,(%dx)
c0101089:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101093:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101097:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109b:	ee                   	out    %al,(%dx)
c010109c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a2:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ae:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010af:	c9                   	leave  
c01010b0:	c3                   	ret    

c01010b1 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b1:	55                   	push   %ebp
c01010b2:	89 e5                	mov    %esp,%ebp
c01010b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bb:	74 0d                	je     c01010ca <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c0:	89 04 24             	mov    %eax,(%esp)
c01010c3:	e8 70 ff ff ff       	call   c0101038 <lpt_putc_sub>
c01010c8:	eb 24                	jmp    c01010ee <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d1:	e8 62 ff ff ff       	call   c0101038 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010dd:	e8 56 ff ff ff       	call   c0101038 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e9:	e8 4a ff ff ff       	call   c0101038 <lpt_putc_sub>
    }
}
c01010ee:	c9                   	leave  
c01010ef:	c3                   	ret    

c01010f0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f0:	55                   	push   %ebp
c01010f1:	89 e5                	mov    %esp,%ebp
c01010f3:	53                   	push   %ebx
c01010f4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fa:	b0 00                	mov    $0x0,%al
c01010fc:	85 c0                	test   %eax,%eax
c01010fe:	75 07                	jne    c0101107 <cga_putc+0x17>
        c |= 0x0700;
c0101100:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101107:	8b 45 08             	mov    0x8(%ebp),%eax
c010110a:	0f b6 c0             	movzbl %al,%eax
c010110d:	83 f8 0a             	cmp    $0xa,%eax
c0101110:	74 4c                	je     c010115e <cga_putc+0x6e>
c0101112:	83 f8 0d             	cmp    $0xd,%eax
c0101115:	74 57                	je     c010116e <cga_putc+0x7e>
c0101117:	83 f8 08             	cmp    $0x8,%eax
c010111a:	0f 85 88 00 00 00    	jne    c01011a8 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101120:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c0101127:	66 85 c0             	test   %ax,%ax
c010112a:	74 30                	je     c010115c <cga_putc+0x6c>
            crt_pos --;
c010112c:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c0101133:	83 e8 01             	sub    $0x1,%eax
c0101136:	66 a3 a4 7e 11 c0    	mov    %ax,0xc0117ea4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113c:	a1 a0 7e 11 c0       	mov    0xc0117ea0,%eax
c0101141:	0f b7 15 a4 7e 11 c0 	movzwl 0xc0117ea4,%edx
c0101148:	0f b7 d2             	movzwl %dx,%edx
c010114b:	01 d2                	add    %edx,%edx
c010114d:	01 c2                	add    %eax,%edx
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	b0 00                	mov    $0x0,%al
c0101154:	83 c8 20             	or     $0x20,%eax
c0101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115a:	eb 72                	jmp    c01011ce <cga_putc+0xde>
c010115c:	eb 70                	jmp    c01011ce <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010115e:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c0101165:	83 c0 50             	add    $0x50,%eax
c0101168:	66 a3 a4 7e 11 c0    	mov    %ax,0xc0117ea4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116e:	0f b7 1d a4 7e 11 c0 	movzwl 0xc0117ea4,%ebx
c0101175:	0f b7 0d a4 7e 11 c0 	movzwl 0xc0117ea4,%ecx
c010117c:	0f b7 c1             	movzwl %cx,%eax
c010117f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101185:	c1 e8 10             	shr    $0x10,%eax
c0101188:	89 c2                	mov    %eax,%edx
c010118a:	66 c1 ea 06          	shr    $0x6,%dx
c010118e:	89 d0                	mov    %edx,%eax
c0101190:	c1 e0 02             	shl    $0x2,%eax
c0101193:	01 d0                	add    %edx,%eax
c0101195:	c1 e0 04             	shl    $0x4,%eax
c0101198:	29 c1                	sub    %eax,%ecx
c010119a:	89 ca                	mov    %ecx,%edx
c010119c:	89 d8                	mov    %ebx,%eax
c010119e:	29 d0                	sub    %edx,%eax
c01011a0:	66 a3 a4 7e 11 c0    	mov    %ax,0xc0117ea4
        break;
c01011a6:	eb 26                	jmp    c01011ce <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a8:	8b 0d a0 7e 11 c0    	mov    0xc0117ea0,%ecx
c01011ae:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c01011b5:	8d 50 01             	lea    0x1(%eax),%edx
c01011b8:	66 89 15 a4 7e 11 c0 	mov    %dx,0xc0117ea4
c01011bf:	0f b7 c0             	movzwl %ax,%eax
c01011c2:	01 c0                	add    %eax,%eax
c01011c4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ce:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c01011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d9:	76 5b                	jbe    c0101236 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011db:	a1 a0 7e 11 c0       	mov    0xc0117ea0,%eax
c01011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e6:	a1 a0 7e 11 c0       	mov    0xc0117ea0,%eax
c01011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f2:	00 
c01011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f7:	89 04 24             	mov    %eax,(%esp)
c01011fa:	e8 35 4e 00 00       	call   c0106034 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101206:	eb 15                	jmp    c010121d <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101208:	a1 a0 7e 11 c0       	mov    0xc0117ea0,%eax
c010120d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101210:	01 d2                	add    %edx,%edx
c0101212:	01 d0                	add    %edx,%eax
c0101214:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101219:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101224:	7e e2                	jle    c0101208 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101226:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c010122d:	83 e8 50             	sub    $0x50,%eax
c0101230:	66 a3 a4 7e 11 c0    	mov    %ax,0xc0117ea4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101236:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c010123d:	0f b7 c0             	movzwl %ax,%eax
c0101240:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101244:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101248:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101251:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c0101258:	66 c1 e8 08          	shr    $0x8,%ax
c010125c:	0f b6 c0             	movzbl %al,%eax
c010125f:	0f b7 15 a6 7e 11 c0 	movzwl 0xc0117ea6,%edx
c0101266:	83 c2 01             	add    $0x1,%edx
c0101269:	0f b7 d2             	movzwl %dx,%edx
c010126c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101270:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101273:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127c:	0f b7 05 a6 7e 11 c0 	movzwl 0xc0117ea6,%eax
c0101283:	0f b7 c0             	movzwl %ax,%eax
c0101286:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010128e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101292:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101296:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101297:	0f b7 05 a4 7e 11 c0 	movzwl 0xc0117ea4,%eax
c010129e:	0f b6 c0             	movzbl %al,%eax
c01012a1:	0f b7 15 a6 7e 11 c0 	movzwl 0xc0117ea6,%edx
c01012a8:	83 c2 01             	add    $0x1,%edx
c01012ab:	0f b7 d2             	movzwl %dx,%edx
c01012ae:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b2:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
}
c01012be:	83 c4 34             	add    $0x34,%esp
c01012c1:	5b                   	pop    %ebx
c01012c2:	5d                   	pop    %ebp
c01012c3:	c3                   	ret    

c01012c4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c4:	55                   	push   %ebp
c01012c5:	89 e5                	mov    %esp,%ebp
c01012c7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d1:	eb 09                	jmp    c01012dc <serial_putc_sub+0x18>
        delay();
c01012d3:	e8 4f fb ff ff       	call   c0100e27 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012dc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e6:	89 c2                	mov    %eax,%edx
c01012e8:	ec                   	in     (%dx),%al
c01012e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f0:	0f b6 c0             	movzbl %al,%eax
c01012f3:	83 e0 20             	and    $0x20,%eax
c01012f6:	85 c0                	test   %eax,%eax
c01012f8:	75 09                	jne    c0101303 <serial_putc_sub+0x3f>
c01012fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101301:	7e d0                	jle    c01012d3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101303:	8b 45 08             	mov    0x8(%ebp),%eax
c0101306:	0f b6 c0             	movzbl %al,%eax
c0101309:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101312:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101316:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131a:	ee                   	out    %al,(%dx)
}
c010131b:	c9                   	leave  
c010131c:	c3                   	ret    

c010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131d:	55                   	push   %ebp
c010131e:	89 e5                	mov    %esp,%ebp
c0101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101327:	74 0d                	je     c0101336 <serial_putc+0x19>
        serial_putc_sub(c);
c0101329:	8b 45 08             	mov    0x8(%ebp),%eax
c010132c:	89 04 24             	mov    %eax,(%esp)
c010132f:	e8 90 ff ff ff       	call   c01012c4 <serial_putc_sub>
c0101334:	eb 24                	jmp    c010135a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133d:	e8 82 ff ff ff       	call   c01012c4 <serial_putc_sub>
        serial_putc_sub(' ');
c0101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101349:	e8 76 ff ff ff       	call   c01012c4 <serial_putc_sub>
        serial_putc_sub('\b');
c010134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101355:	e8 6a ff ff ff       	call   c01012c4 <serial_putc_sub>
    }
}
c010135a:	c9                   	leave  
c010135b:	c3                   	ret    

c010135c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135c:	55                   	push   %ebp
c010135d:	89 e5                	mov    %esp,%ebp
c010135f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101362:	eb 33                	jmp    c0101397 <cons_intr+0x3b>
        if (c != 0) {
c0101364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101368:	74 2d                	je     c0101397 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136a:	a1 c4 80 11 c0       	mov    0xc01180c4,%eax
c010136f:	8d 50 01             	lea    0x1(%eax),%edx
c0101372:	89 15 c4 80 11 c0    	mov    %edx,0xc01180c4
c0101378:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137b:	88 90 c0 7e 11 c0    	mov    %dl,-0x3fee8140(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101381:	a1 c4 80 11 c0       	mov    0xc01180c4,%eax
c0101386:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138b:	75 0a                	jne    c0101397 <cons_intr+0x3b>
                cons.wpos = 0;
c010138d:	c7 05 c4 80 11 c0 00 	movl   $0x0,0xc01180c4
c0101394:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101397:	8b 45 08             	mov    0x8(%ebp),%eax
c010139a:	ff d0                	call   *%eax
c010139c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a3:	75 bf                	jne    c0101364 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a5:	c9                   	leave  
c01013a6:	c3                   	ret    

c01013a7 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a7:	55                   	push   %ebp
c01013a8:	89 e5                	mov    %esp,%ebp
c01013aa:	83 ec 10             	sub    $0x10,%esp
c01013ad:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b7:	89 c2                	mov    %eax,%edx
c01013b9:	ec                   	in     (%dx),%al
c01013ba:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c1:	0f b6 c0             	movzbl %al,%eax
c01013c4:	83 e0 01             	and    $0x1,%eax
c01013c7:	85 c0                	test   %eax,%eax
c01013c9:	75 07                	jne    c01013d2 <serial_proc_data+0x2b>
        return -1;
c01013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d0:	eb 2a                	jmp    c01013fc <serial_proc_data+0x55>
c01013d2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013dc:	89 c2                	mov    %eax,%edx
c01013de:	ec                   	in     (%dx),%al
c01013df:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e6:	0f b6 c0             	movzbl %al,%eax
c01013e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ec:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f0:	75 07                	jne    c01013f9 <serial_proc_data+0x52>
        c = '\b';
c01013f2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fc:	c9                   	leave  
c01013fd:	c3                   	ret    

c01013fe <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fe:	55                   	push   %ebp
c01013ff:	89 e5                	mov    %esp,%ebp
c0101401:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101404:	a1 a8 7e 11 c0       	mov    0xc0117ea8,%eax
c0101409:	85 c0                	test   %eax,%eax
c010140b:	74 0c                	je     c0101419 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140d:	c7 04 24 a7 13 10 c0 	movl   $0xc01013a7,(%esp)
c0101414:	e8 43 ff ff ff       	call   c010135c <cons_intr>
    }
}
c0101419:	c9                   	leave  
c010141a:	c3                   	ret    

c010141b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141b:	55                   	push   %ebp
c010141c:	89 e5                	mov    %esp,%ebp
c010141e:	83 ec 38             	sub    $0x38,%esp
c0101421:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101427:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142b:	89 c2                	mov    %eax,%edx
c010142d:	ec                   	in     (%dx),%al
c010142e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101431:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101435:	0f b6 c0             	movzbl %al,%eax
c0101438:	83 e0 01             	and    $0x1,%eax
c010143b:	85 c0                	test   %eax,%eax
c010143d:	75 0a                	jne    c0101449 <kbd_proc_data+0x2e>
        return -1;
c010143f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101444:	e9 59 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
c0101449:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101453:	89 c2                	mov    %eax,%edx
c0101455:	ec                   	in     (%dx),%al
c0101456:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101459:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101460:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101464:	75 17                	jne    c010147d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101466:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c010146b:	83 c8 40             	or     $0x40,%eax
c010146e:	a3 c8 80 11 c0       	mov    %eax,0xc01180c8
        return 0;
c0101473:	b8 00 00 00 00       	mov    $0x0,%eax
c0101478:	e9 25 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101481:	84 c0                	test   %al,%al
c0101483:	79 47                	jns    c01014cc <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101485:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c010148a:	83 e0 40             	and    $0x40,%eax
c010148d:	85 c0                	test   %eax,%eax
c010148f:	75 09                	jne    c010149a <kbd_proc_data+0x7f>
c0101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101495:	83 e0 7f             	and    $0x7f,%eax
c0101498:	eb 04                	jmp    c010149e <kbd_proc_data+0x83>
c010149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a5:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ac:	83 c8 40             	or     $0x40,%eax
c01014af:	0f b6 c0             	movzbl %al,%eax
c01014b2:	f7 d0                	not    %eax
c01014b4:	89 c2                	mov    %eax,%edx
c01014b6:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c01014bb:	21 d0                	and    %edx,%eax
c01014bd:	a3 c8 80 11 c0       	mov    %eax,0xc01180c8
        return 0;
c01014c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c7:	e9 d6 00 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014cc:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c01014d1:	83 e0 40             	and    $0x40,%eax
c01014d4:	85 c0                	test   %eax,%eax
c01014d6:	74 11                	je     c01014e9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014dc:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c01014e1:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e4:	a3 c8 80 11 c0       	mov    %eax,0xc01180c8
    }

    shift |= shiftcode[data];
c01014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ed:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f4:	0f b6 d0             	movzbl %al,%edx
c01014f7:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c01014fc:	09 d0                	or     %edx,%eax
c01014fe:	a3 c8 80 11 c0       	mov    %eax,0xc01180c8
    shift ^= togglecode[data];
c0101503:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101507:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010150e:	0f b6 d0             	movzbl %al,%edx
c0101511:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c0101516:	31 d0                	xor    %edx,%eax
c0101518:	a3 c8 80 11 c0       	mov    %eax,0xc01180c8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151d:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c0101522:	83 e0 03             	and    $0x3,%eax
c0101525:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101530:	01 d0                	add    %edx,%eax
c0101532:	0f b6 00             	movzbl (%eax),%eax
c0101535:	0f b6 c0             	movzbl %al,%eax
c0101538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153b:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c0101540:	83 e0 08             	and    $0x8,%eax
c0101543:	85 c0                	test   %eax,%eax
c0101545:	74 22                	je     c0101569 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101547:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154b:	7e 0c                	jle    c0101559 <kbd_proc_data+0x13e>
c010154d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101551:	7f 06                	jg     c0101559 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101553:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101557:	eb 10                	jmp    c0101569 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101559:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155d:	7e 0a                	jle    c0101569 <kbd_proc_data+0x14e>
c010155f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101563:	7f 04                	jg     c0101569 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101565:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101569:	a1 c8 80 11 c0       	mov    0xc01180c8,%eax
c010156e:	f7 d0                	not    %eax
c0101570:	83 e0 06             	and    $0x6,%eax
c0101573:	85 c0                	test   %eax,%eax
c0101575:	75 28                	jne    c010159f <kbd_proc_data+0x184>
c0101577:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010157e:	75 1f                	jne    c010159f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101580:	c7 04 24 a9 64 10 c0 	movl   $0xc01064a9,(%esp)
c0101587:	e8 b0 ed ff ff       	call   c010033c <cprintf>
c010158c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101592:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101596:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a2:	c9                   	leave  
c01015a3:	c3                   	ret    

c01015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a4:	55                   	push   %ebp
c01015a5:	89 e5                	mov    %esp,%ebp
c01015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015aa:	c7 04 24 1b 14 10 c0 	movl   $0xc010141b,(%esp)
c01015b1:	e8 a6 fd ff ff       	call   c010135c <cons_intr>
}
c01015b6:	c9                   	leave  
c01015b7:	c3                   	ret    

c01015b8 <kbd_init>:

static void
kbd_init(void) {
c01015b8:	55                   	push   %ebp
c01015b9:	89 e5                	mov    %esp,%ebp
c01015bb:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015be:	e8 e1 ff ff ff       	call   c01015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ca:	e8 3d 01 00 00       	call   c010170c <pic_enable>
}
c01015cf:	c9                   	leave  
c01015d0:	c3                   	ret    

c01015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d7:	e8 93 f8 ff ff       	call   c0100e6f <cga_init>
    serial_init();
c01015dc:	e8 74 f9 ff ff       	call   c0100f55 <serial_init>
    kbd_init();
c01015e1:	e8 d2 ff ff ff       	call   c01015b8 <kbd_init>
    if (!serial_exists) {
c01015e6:	a1 a8 7e 11 c0       	mov    0xc0117ea8,%eax
c01015eb:	85 c0                	test   %eax,%eax
c01015ed:	75 0c                	jne    c01015fb <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ef:	c7 04 24 b5 64 10 c0 	movl   $0xc01064b5,(%esp)
c01015f6:	e8 41 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fb:	c9                   	leave  
c01015fc:	c3                   	ret    

c01015fd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015fd:	55                   	push   %ebp
c01015fe:	89 e5                	mov    %esp,%ebp
c0101600:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101603:	e8 e2 f7 ff ff       	call   c0100dea <__intr_save>
c0101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160b:	8b 45 08             	mov    0x8(%ebp),%eax
c010160e:	89 04 24             	mov    %eax,(%esp)
c0101611:	e8 9b fa ff ff       	call   c01010b1 <lpt_putc>
        cga_putc(c);
c0101616:	8b 45 08             	mov    0x8(%ebp),%eax
c0101619:	89 04 24             	mov    %eax,(%esp)
c010161c:	e8 cf fa ff ff       	call   c01010f0 <cga_putc>
        serial_putc(c);
c0101621:	8b 45 08             	mov    0x8(%ebp),%eax
c0101624:	89 04 24             	mov    %eax,(%esp)
c0101627:	e8 f1 fc ff ff       	call   c010131d <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162f:	89 04 24             	mov    %eax,(%esp)
c0101632:	e8 dd f7 ff ff       	call   c0100e14 <__intr_restore>
}
c0101637:	c9                   	leave  
c0101638:	c3                   	ret    

c0101639 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101639:	55                   	push   %ebp
c010163a:	89 e5                	mov    %esp,%ebp
c010163c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101646:	e8 9f f7 ff ff       	call   c0100dea <__intr_save>
c010164b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164e:	e8 ab fd ff ff       	call   c01013fe <serial_intr>
        kbd_intr();
c0101653:	e8 4c ff ff ff       	call   c01015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101658:	8b 15 c0 80 11 c0    	mov    0xc01180c0,%edx
c010165e:	a1 c4 80 11 c0       	mov    0xc01180c4,%eax
c0101663:	39 c2                	cmp    %eax,%edx
c0101665:	74 31                	je     c0101698 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101667:	a1 c0 80 11 c0       	mov    0xc01180c0,%eax
c010166c:	8d 50 01             	lea    0x1(%eax),%edx
c010166f:	89 15 c0 80 11 c0    	mov    %edx,0xc01180c0
c0101675:	0f b6 80 c0 7e 11 c0 	movzbl -0x3fee8140(%eax),%eax
c010167c:	0f b6 c0             	movzbl %al,%eax
c010167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101682:	a1 c0 80 11 c0       	mov    0xc01180c0,%eax
c0101687:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168c:	75 0a                	jne    c0101698 <cons_getc+0x5f>
                cons.rpos = 0;
c010168e:	c7 05 c0 80 11 c0 00 	movl   $0x0,0xc01180c0
c0101695:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101698:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169b:	89 04 24             	mov    %eax,(%esp)
c010169e:	e8 71 f7 ff ff       	call   c0100e14 <__intr_restore>
    return c;
c01016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a6:	c9                   	leave  
c01016a7:	c3                   	ret    

c01016a8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a8:	55                   	push   %ebp
c01016a9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ab:	fb                   	sti    
    sti();
}
c01016ac:	5d                   	pop    %ebp
c01016ad:	c3                   	ret    

c01016ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b1:	fa                   	cli    
    cli();
}
c01016b2:	5d                   	pop    %ebp
c01016b3:	c3                   	ret    

c01016b4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
c01016b7:	83 ec 14             	sub    $0x14,%esp
c01016ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c5:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cb:	a1 cc 80 11 c0       	mov    0xc01180cc,%eax
c01016d0:	85 c0                	test   %eax,%eax
c01016d2:	74 36                	je     c010170a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d8:	0f b6 c0             	movzbl %al,%eax
c01016db:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ec:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f1:	66 c1 e8 08          	shr    $0x8,%ax
c01016f5:	0f b6 c0             	movzbl %al,%eax
c01016f8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016fe:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101701:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101705:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101709:	ee                   	out    %al,(%dx)
    }
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101712:	8b 45 08             	mov    0x8(%ebp),%eax
c0101715:	ba 01 00 00 00       	mov    $0x1,%edx
c010171a:	89 c1                	mov    %eax,%ecx
c010171c:	d3 e2                	shl    %cl,%edx
c010171e:	89 d0                	mov    %edx,%eax
c0101720:	f7 d0                	not    %eax
c0101722:	89 c2                	mov    %eax,%edx
c0101724:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172b:	21 d0                	and    %edx,%eax
c010172d:	0f b7 c0             	movzwl %ax,%eax
c0101730:	89 04 24             	mov    %eax,(%esp)
c0101733:	e8 7c ff ff ff       	call   c01016b4 <pic_setmask>
}
c0101738:	c9                   	leave  
c0101739:	c3                   	ret    

c010173a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173a:	55                   	push   %ebp
c010173b:	89 e5                	mov    %esp,%ebp
c010173d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101740:	c7 05 cc 80 11 c0 01 	movl   $0x1,0xc01180cc
c0101747:	00 00 00 
c010174a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101750:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101754:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101758:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175c:	ee                   	out    %al,(%dx)
c010175d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101763:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176f:	ee                   	out    %al,(%dx)
c0101770:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101776:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101782:	ee                   	out    %al,(%dx)
c0101783:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101789:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101791:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
c0101796:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a8:	ee                   	out    %al,(%dx)
c01017a9:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017af:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bb:	ee                   	out    %al,(%dx)
c01017bc:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017ce:	ee                   	out    %al,(%dx)
c01017cf:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017dd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e1:	ee                   	out    %al,(%dx)
c01017e2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ec:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f4:	ee                   	out    %al,(%dx)
c01017f5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fb:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101803:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101807:	ee                   	out    %al,(%dx)
c0101808:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101812:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101816:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101821:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101825:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101829:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182d:	ee                   	out    %al,(%dx)
c010182e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101834:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101838:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
c0101841:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101847:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101854:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185b:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185f:	74 12                	je     c0101873 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101861:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101868:	0f b7 c0             	movzwl %ax,%eax
c010186b:	89 04 24             	mov    %eax,(%esp)
c010186e:	e8 41 fe ff ff       	call   c01016b4 <pic_setmask>
    }
}
c0101873:	c9                   	leave  
c0101874:	c3                   	ret    

c0101875 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101875:	55                   	push   %ebp
c0101876:	89 e5                	mov    %esp,%ebp
c0101878:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101882:	00 
c0101883:	c7 04 24 e0 64 10 c0 	movl   $0xc01064e0,(%esp)
c010188a:	e8 ad ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188f:	c7 04 24 ea 64 10 c0 	movl   $0xc01064ea,(%esp)
c0101896:	e8 a1 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c010189b:	c7 44 24 08 f8 64 10 	movl   $0xc01064f8,0x8(%esp)
c01018a2:	c0 
c01018a3:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018aa:	00 
c01018ab:	c7 04 24 0e 65 10 c0 	movl   $0xc010650e,(%esp)
c01018b2:	e8 14 f4 ff ff       	call   c0100ccb <__panic>

c01018b7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b7:	55                   	push   %ebp
c01018b8:	89 e5                	mov    %esp,%ebp
c01018ba:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018c4:	e9 c3 00 00 00       	jmp    c010198c <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cc:	8b 04 85 04 76 11 c0 	mov    -0x3fee89fc(,%eax,4),%eax
c01018d3:	89 c2                	mov    %eax,%edx
c01018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d8:	66 89 14 c5 e0 80 11 	mov    %dx,-0x3fee7f20(,%eax,8)
c01018df:	c0 
c01018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e3:	66 c7 04 c5 e2 80 11 	movw   $0x8,-0x3fee7f1e(,%eax,8)
c01018ea:	c0 08 00 
c01018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f0:	0f b6 14 c5 e4 80 11 	movzbl -0x3fee7f1c(,%eax,8),%edx
c01018f7:	c0 
c01018f8:	83 e2 e0             	and    $0xffffffe0,%edx
c01018fb:	88 14 c5 e4 80 11 c0 	mov    %dl,-0x3fee7f1c(,%eax,8)
c0101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101905:	0f b6 14 c5 e4 80 11 	movzbl -0x3fee7f1c(,%eax,8),%edx
c010190c:	c0 
c010190d:	83 e2 1f             	and    $0x1f,%edx
c0101910:	88 14 c5 e4 80 11 c0 	mov    %dl,-0x3fee7f1c(,%eax,8)
c0101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191a:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c0101921:	c0 
c0101922:	83 e2 f0             	and    $0xfffffff0,%edx
c0101925:	83 ca 0e             	or     $0xe,%edx
c0101928:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c010192f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101932:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c0101939:	c0 
c010193a:	83 e2 ef             	and    $0xffffffef,%edx
c010193d:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c0101944:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101947:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c010194e:	c0 
c010194f:	83 e2 9f             	and    $0xffffff9f,%edx
c0101952:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c0101959:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195c:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c0101963:	c0 
c0101964:	83 ca 80             	or     $0xffffff80,%edx
c0101967:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c010196e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101971:	8b 04 85 04 76 11 c0 	mov    -0x3fee89fc(,%eax,4),%eax
c0101978:	c1 e8 10             	shr    $0x10,%eax
c010197b:	89 c2                	mov    %eax,%edx
c010197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101980:	66 89 14 c5 e6 80 11 	mov    %dx,-0x3fee7f1a(,%eax,8)
c0101987:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101988:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198f:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101994:	0f 86 2f ff ff ff    	jbe    c01018c9 <idt_init+0x12>
c010199a:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019a4:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// load the IDT
    lidt(&idt_pd);
}
c01019a7:	c9                   	leave  
c01019a8:	c3                   	ret    

c01019a9 <trapname>:

static const char *
trapname(int trapno) {
c01019a9:	55                   	push   %ebp
c01019aa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01019af:	83 f8 13             	cmp    $0x13,%eax
c01019b2:	77 0c                	ja     c01019c0 <trapname+0x17>
        return excnames[trapno];
c01019b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b7:	8b 04 85 80 68 10 c0 	mov    -0x3fef9780(,%eax,4),%eax
c01019be:	eb 18                	jmp    c01019d8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019c0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019c4:	7e 0d                	jle    c01019d3 <trapname+0x2a>
c01019c6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019ca:	7f 07                	jg     c01019d3 <trapname+0x2a>
        return "Hardware Interrupt";
c01019cc:	b8 1f 65 10 c0       	mov    $0xc010651f,%eax
c01019d1:	eb 05                	jmp    c01019d8 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019d3:	b8 32 65 10 c0       	mov    $0xc0106532,%eax
}
c01019d8:	5d                   	pop    %ebp
c01019d9:	c3                   	ret    

c01019da <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019da:	55                   	push   %ebp
c01019db:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019e4:	66 83 f8 08          	cmp    $0x8,%ax
c01019e8:	0f 94 c0             	sete   %al
c01019eb:	0f b6 c0             	movzbl %al,%eax
}
c01019ee:	5d                   	pop    %ebp
c01019ef:	c3                   	ret    

c01019f0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019f0:	55                   	push   %ebp
c01019f1:	89 e5                	mov    %esp,%ebp
c01019f3:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fd:	c7 04 24 73 65 10 c0 	movl   $0xc0106573,(%esp)
c0101a04:	e8 33 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0c:	89 04 24             	mov    %eax,(%esp)
c0101a0f:	e8 a1 01 00 00       	call   c0101bb5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a1b:	0f b7 c0             	movzwl %ax,%eax
c0101a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a22:	c7 04 24 84 65 10 c0 	movl   $0xc0106584,(%esp)
c0101a29:	e8 0e e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a31:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a35:	0f b7 c0             	movzwl %ax,%eax
c0101a38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a3c:	c7 04 24 97 65 10 c0 	movl   $0xc0106597,(%esp)
c0101a43:	e8 f4 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a4f:	0f b7 c0             	movzwl %ax,%eax
c0101a52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a56:	c7 04 24 aa 65 10 c0 	movl   $0xc01065aa,(%esp)
c0101a5d:	e8 da e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a65:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a69:	0f b7 c0             	movzwl %ax,%eax
c0101a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a70:	c7 04 24 bd 65 10 c0 	movl   $0xc01065bd,(%esp)
c0101a77:	e8 c0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7f:	8b 40 30             	mov    0x30(%eax),%eax
c0101a82:	89 04 24             	mov    %eax,(%esp)
c0101a85:	e8 1f ff ff ff       	call   c01019a9 <trapname>
c0101a8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a8d:	8b 52 30             	mov    0x30(%edx),%edx
c0101a90:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a94:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a98:	c7 04 24 d0 65 10 c0 	movl   $0xc01065d0,(%esp)
c0101a9f:	e8 98 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa7:	8b 40 34             	mov    0x34(%eax),%eax
c0101aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aae:	c7 04 24 e2 65 10 c0 	movl   $0xc01065e2,(%esp)
c0101ab5:	e8 82 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abd:	8b 40 38             	mov    0x38(%eax),%eax
c0101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac4:	c7 04 24 f1 65 10 c0 	movl   $0xc01065f1,(%esp)
c0101acb:	e8 6c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ad7:	0f b7 c0             	movzwl %ax,%eax
c0101ada:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ade:	c7 04 24 00 66 10 c0 	movl   $0xc0106600,(%esp)
c0101ae5:	e8 52 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	8b 40 40             	mov    0x40(%eax),%eax
c0101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af4:	c7 04 24 13 66 10 c0 	movl   $0xc0106613,(%esp)
c0101afb:	e8 3c e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b07:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b0e:	eb 3e                	jmp    c0101b4e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 50 40             	mov    0x40(%eax),%edx
c0101b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b19:	21 d0                	and    %edx,%eax
c0101b1b:	85 c0                	test   %eax,%eax
c0101b1d:	74 28                	je     c0101b47 <print_trapframe+0x157>
c0101b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b22:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b29:	85 c0                	test   %eax,%eax
c0101b2b:	74 1a                	je     c0101b47 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b30:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3b:	c7 04 24 22 66 10 c0 	movl   $0xc0106622,(%esp)
c0101b42:	e8 f5 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b4b:	d1 65 f0             	shll   -0x10(%ebp)
c0101b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b51:	83 f8 17             	cmp    $0x17,%eax
c0101b54:	76 ba                	jbe    c0101b10 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b59:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5c:	25 00 30 00 00       	and    $0x3000,%eax
c0101b61:	c1 e8 0c             	shr    $0xc,%eax
c0101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b68:	c7 04 24 26 66 10 c0 	movl   $0xc0106626,(%esp)
c0101b6f:	e8 c8 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b77:	89 04 24             	mov    %eax,(%esp)
c0101b7a:	e8 5b fe ff ff       	call   c01019da <trap_in_kernel>
c0101b7f:	85 c0                	test   %eax,%eax
c0101b81:	75 30                	jne    c0101bb3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b86:	8b 40 44             	mov    0x44(%eax),%eax
c0101b89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8d:	c7 04 24 2f 66 10 c0 	movl   $0xc010662f,(%esp)
c0101b94:	e8 a3 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101ba0:	0f b7 c0             	movzwl %ax,%eax
c0101ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba7:	c7 04 24 3e 66 10 c0 	movl   $0xc010663e,(%esp)
c0101bae:	e8 89 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101bb3:	c9                   	leave  
c0101bb4:	c3                   	ret    

c0101bb5 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bb5:	55                   	push   %ebp
c0101bb6:	89 e5                	mov    %esp,%ebp
c0101bb8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 00                	mov    (%eax),%eax
c0101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc4:	c7 04 24 51 66 10 c0 	movl   $0xc0106651,(%esp)
c0101bcb:	e8 6c e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd3:	8b 40 04             	mov    0x4(%eax),%eax
c0101bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bda:	c7 04 24 60 66 10 c0 	movl   $0xc0106660,(%esp)
c0101be1:	e8 56 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101be6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be9:	8b 40 08             	mov    0x8(%eax),%eax
c0101bec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf0:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0101bf7:	e8 40 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bff:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c06:	c7 04 24 7e 66 10 c0 	movl   $0xc010667e,(%esp)
c0101c0d:	e8 2a e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	8b 40 10             	mov    0x10(%eax),%eax
c0101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1c:	c7 04 24 8d 66 10 c0 	movl   $0xc010668d,(%esp)
c0101c23:	e8 14 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	8b 40 14             	mov    0x14(%eax),%eax
c0101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c32:	c7 04 24 9c 66 10 c0 	movl   $0xc010669c,(%esp)
c0101c39:	e8 fe e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c41:	8b 40 18             	mov    0x18(%eax),%eax
c0101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c48:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0101c4f:	e8 e8 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c57:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5e:	c7 04 24 ba 66 10 c0 	movl   $0xc01066ba,(%esp)
c0101c65:	e8 d2 e6 ff ff       	call   c010033c <cprintf>
}
c0101c6a:	c9                   	leave  
c0101c6b:	c3                   	ret    

c0101c6c <print_tmode_info>:
#define T_MODE_TICK		1
#define T_MODE_KEY		2
static int tmode = T_MODE_TICK;

static void print_tmode_info()
{
c0101c6c:	55                   	push   %ebp
c0101c6d:	89 e5                	mov    %esp,%ebp
c0101c6f:	83 ec 18             	sub    $0x18,%esp
	cprintf("Change mode:\n");
c0101c72:	c7 04 24 c9 66 10 c0 	movl   $0xc01066c9,(%esp)
c0101c79:	e8 be e6 ff ff       	call   c010033c <cprintf>
	cprintf("1:tick\n");
c0101c7e:	c7 04 24 d7 66 10 c0 	movl   $0xc01066d7,(%esp)
c0101c85:	e8 b2 e6 ff ff       	call   c010033c <cprintf>
	cprintf("2:keypress\n");
c0101c8a:	c7 04 24 df 66 10 c0 	movl   $0xc01066df,(%esp)
c0101c91:	e8 a6 e6 ff ff       	call   c010033c <cprintf>
}
c0101c96:	c9                   	leave  
c0101c97:	c3                   	ret    

c0101c98 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c98:	55                   	push   %ebp
c0101c99:	89 e5                	mov    %esp,%ebp
c0101c9b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca1:	8b 40 30             	mov    0x30(%eax),%eax
c0101ca4:	83 f8 2f             	cmp    $0x2f,%eax
c0101ca7:	77 21                	ja     c0101cca <trap_dispatch+0x32>
c0101ca9:	83 f8 2e             	cmp    $0x2e,%eax
c0101cac:	0f 83 9a 01 00 00    	jae    c0101e4c <trap_dispatch+0x1b4>
c0101cb2:	83 f8 21             	cmp    $0x21,%eax
c0101cb5:	0f 84 9e 00 00 00    	je     c0101d59 <trap_dispatch+0xc1>
c0101cbb:	83 f8 24             	cmp    $0x24,%eax
c0101cbe:	74 70                	je     c0101d30 <trap_dispatch+0x98>
c0101cc0:	83 f8 20             	cmp    $0x20,%eax
c0101cc3:	74 16                	je     c0101cdb <trap_dispatch+0x43>
c0101cc5:	e9 4a 01 00 00       	jmp    c0101e14 <trap_dispatch+0x17c>
c0101cca:	83 e8 78             	sub    $0x78,%eax
c0101ccd:	83 f8 01             	cmp    $0x1,%eax
c0101cd0:	0f 87 3e 01 00 00    	ja     c0101e14 <trap_dispatch+0x17c>
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101cd6:	e9 71 01 00 00       	jmp    c0101e4c <trap_dispatch+0x1b4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
c0101cdb:	a1 6c 89 11 c0       	mov    0xc011896c,%eax
c0101ce0:	83 c0 01             	add    $0x1,%eax
c0101ce3:	a3 6c 89 11 c0       	mov    %eax,0xc011896c
		if (tmode == T_MODE_TICK)
c0101ce8:	a1 00 76 11 c0       	mov    0xc0117600,%eax
c0101ced:	83 f8 01             	cmp    $0x1,%eax
c0101cf0:	75 39                	jne    c0101d2b <trap_dispatch+0x93>
		{
			if (ticks % TICK_NUM == 0)
c0101cf2:	8b 0d 6c 89 11 c0    	mov    0xc011896c,%ecx
c0101cf8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cfd:	89 c8                	mov    %ecx,%eax
c0101cff:	f7 e2                	mul    %edx
c0101d01:	89 d0                	mov    %edx,%eax
c0101d03:	c1 e8 05             	shr    $0x5,%eax
c0101d06:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d09:	29 c1                	sub    %eax,%ecx
c0101d0b:	89 c8                	mov    %ecx,%eax
c0101d0d:	85 c0                	test   %eax,%eax
c0101d0f:	75 1a                	jne    c0101d2b <trap_dispatch+0x93>
				cprintf("%d ticks\n", ticks);
c0101d11:	a1 6c 89 11 c0       	mov    0xc011896c,%eax
c0101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1a:	c7 04 24 e0 64 10 c0 	movl   $0xc01064e0,(%esp)
c0101d21:	e8 16 e6 ff ff       	call   c010033c <cprintf>
		}
        break;
c0101d26:	e9 22 01 00 00       	jmp    c0101e4d <trap_dispatch+0x1b5>
c0101d2b:	e9 1d 01 00 00       	jmp    c0101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d30:	e8 04 f9 ff ff       	call   c0101639 <cons_getc>
c0101d35:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d38:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d3c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d40:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d48:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0101d4f:	e8 e8 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d54:	e9 f4 00 00 00       	jmp    c0101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d59:	e8 db f8 ff ff       	call   c0101639 <cons_getc>
c0101d5e:	88 45 f7             	mov    %al,-0x9(%ebp)
		if (c == 0)
c0101d61:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0101d65:	75 05                	jne    c0101d6c <trap_dispatch+0xd4>
			break;
c0101d67:	e9 e1 00 00 00       	jmp    c0101e4d <trap_dispatch+0x1b5>

		if (c == 19 && tmode != T_MODE_SEL)
c0101d6c:	80 7d f7 13          	cmpb   $0x13,-0x9(%ebp)
c0101d70:	75 1d                	jne    c0101d8f <trap_dispatch+0xf7>
c0101d72:	a1 00 76 11 c0       	mov    0xc0117600,%eax
c0101d77:	85 c0                	test   %eax,%eax
c0101d79:	74 14                	je     c0101d8f <trap_dispatch+0xf7>
		{
			tmode = T_MODE_SEL;
c0101d7b:	c7 05 00 76 11 c0 00 	movl   $0x0,0xc0117600
c0101d82:	00 00 00 
			print_tmode_info();
c0101d85:	e8 e2 fe ff ff       	call   c0101c6c <print_tmode_info>
			break;
c0101d8a:	e9 be 00 00 00       	jmp    c0101e4d <trap_dispatch+0x1b5>
		}

		if (tmode == T_MODE_KEY)
c0101d8f:	a1 00 76 11 c0       	mov    0xc0117600,%eax
c0101d94:	83 f8 02             	cmp    $0x2,%eax
c0101d97:	75 16                	jne    c0101daf <trap_dispatch+0x117>
		{
        	cprintf("%c", c);
c0101d99:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da1:	c7 04 24 fd 66 10 c0 	movl   $0xc01066fd,(%esp)
c0101da8:	e8 8f e5 ff ff       	call   c010033c <cprintf>
c0101dad:	eb 63                	jmp    c0101e12 <trap_dispatch+0x17a>
		}
		else if (tmode == T_MODE_SEL)
c0101daf:	a1 00 76 11 c0       	mov    0xc0117600,%eax
c0101db4:	85 c0                	test   %eax,%eax
c0101db6:	75 5a                	jne    c0101e12 <trap_dispatch+0x17a>
		{
			switch (c)
c0101db8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dbc:	83 f8 31             	cmp    $0x31,%eax
c0101dbf:	74 07                	je     c0101dc8 <trap_dispatch+0x130>
c0101dc1:	83 f8 32             	cmp    $0x32,%eax
c0101dc4:	74 1a                	je     c0101de0 <trap_dispatch+0x148>
c0101dc6:	eb 30                	jmp    c0101df8 <trap_dispatch+0x160>
			{
				case '1': tmode = T_MODE_TICK; cprintf("\n"); break;
c0101dc8:	c7 05 00 76 11 c0 01 	movl   $0x1,0xc0117600
c0101dcf:	00 00 00 
c0101dd2:	c7 04 24 00 67 10 c0 	movl   $0xc0106700,(%esp)
c0101dd9:	e8 5e e5 ff ff       	call   c010033c <cprintf>
c0101dde:	eb 32                	jmp    c0101e12 <trap_dispatch+0x17a>
				case '2': tmode = T_MODE_KEY; cprintf("\n"); break;
c0101de0:	c7 05 00 76 11 c0 02 	movl   $0x2,0xc0117600
c0101de7:	00 00 00 
c0101dea:	c7 04 24 00 67 10 c0 	movl   $0xc0106700,(%esp)
c0101df1:	e8 46 e5 ff ff       	call   c010033c <cprintf>
c0101df6:	eb 1a                	jmp    c0101e12 <trap_dispatch+0x17a>
				default:
					cprintf("%c is not valid.", c);
c0101df8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e00:	c7 04 24 02 67 10 c0 	movl   $0xc0106702,(%esp)
c0101e07:	e8 30 e5 ff ff       	call   c010033c <cprintf>
					print_tmode_info();
c0101e0c:	e8 5b fe ff ff       	call   c0101c6c <print_tmode_info>
					break;
c0101e11:	90                   	nop
			}
		}
        break;
c0101e12:	eb 39                	jmp    c0101e4d <trap_dispatch+0x1b5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e17:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e1b:	0f b7 c0             	movzwl %ax,%eax
c0101e1e:	83 e0 03             	and    $0x3,%eax
c0101e21:	85 c0                	test   %eax,%eax
c0101e23:	75 28                	jne    c0101e4d <trap_dispatch+0x1b5>
            print_trapframe(tf);
c0101e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e28:	89 04 24             	mov    %eax,(%esp)
c0101e2b:	e8 c0 fb ff ff       	call   c01019f0 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e30:	c7 44 24 08 13 67 10 	movl   $0xc0106713,0x8(%esp)
c0101e37:	c0 
c0101e38:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0101e3f:	00 
c0101e40:	c7 04 24 0e 65 10 c0 	movl   $0xc010650e,(%esp)
c0101e47:	e8 7f ee ff ff       	call   c0100ccb <__panic>
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e4c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e4d:	c9                   	leave  
c0101e4e:	c3                   	ret    

c0101e4f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e4f:	55                   	push   %ebp
c0101e50:	89 e5                	mov    %esp,%ebp
c0101e52:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e58:	89 04 24             	mov    %eax,(%esp)
c0101e5b:	e8 38 fe ff ff       	call   c0101c98 <trap_dispatch>
}
c0101e60:	c9                   	leave  
c0101e61:	c3                   	ret    

c0101e62 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e62:	1e                   	push   %ds
    pushl %es
c0101e63:	06                   	push   %es
    pushl %fs
c0101e64:	0f a0                	push   %fs
    pushl %gs
c0101e66:	0f a8                	push   %gs
    pushal
c0101e68:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e69:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e6e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e70:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e72:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e73:	e8 d7 ff ff ff       	call   c0101e4f <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e78:	5c                   	pop    %esp

c0101e79 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e79:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e7a:	0f a9                	pop    %gs
    popl %fs
c0101e7c:	0f a1                	pop    %fs
    popl %es
c0101e7e:	07                   	pop    %es
    popl %ds
c0101e7f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e80:	83 c4 08             	add    $0x8,%esp
    iret
c0101e83:	cf                   	iret   

c0101e84 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e84:	6a 00                	push   $0x0
  pushl $0
c0101e86:	6a 00                	push   $0x0
  jmp __alltraps
c0101e88:	e9 d5 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101e8d <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $1
c0101e8f:	6a 01                	push   $0x1
  jmp __alltraps
c0101e91:	e9 cc ff ff ff       	jmp    c0101e62 <__alltraps>

c0101e96 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $2
c0101e98:	6a 02                	push   $0x2
  jmp __alltraps
c0101e9a:	e9 c3 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101e9f <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e9f:	6a 00                	push   $0x0
  pushl $3
c0101ea1:	6a 03                	push   $0x3
  jmp __alltraps
c0101ea3:	e9 ba ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ea8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $4
c0101eaa:	6a 04                	push   $0x4
  jmp __alltraps
c0101eac:	e9 b1 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101eb1 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $5
c0101eb3:	6a 05                	push   $0x5
  jmp __alltraps
c0101eb5:	e9 a8 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101eba <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eba:	6a 00                	push   $0x0
  pushl $6
c0101ebc:	6a 06                	push   $0x6
  jmp __alltraps
c0101ebe:	e9 9f ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ec3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $7
c0101ec5:	6a 07                	push   $0x7
  jmp __alltraps
c0101ec7:	e9 96 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ecc <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ecc:	6a 08                	push   $0x8
  jmp __alltraps
c0101ece:	e9 8f ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ed3 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ed3:	6a 09                	push   $0x9
  jmp __alltraps
c0101ed5:	e9 88 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101eda <vector10>:
.globl vector10
vector10:
  pushl $10
c0101eda:	6a 0a                	push   $0xa
  jmp __alltraps
c0101edc:	e9 81 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ee1 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ee1:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ee3:	e9 7a ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ee8 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ee8:	6a 0c                	push   $0xc
  jmp __alltraps
c0101eea:	e9 73 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101eef <vector13>:
.globl vector13
vector13:
  pushl $13
c0101eef:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ef1:	e9 6c ff ff ff       	jmp    c0101e62 <__alltraps>

c0101ef6 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ef6:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ef8:	e9 65 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101efd <vector15>:
.globl vector15
vector15:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $15
c0101eff:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f01:	e9 5c ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f06 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $16
c0101f08:	6a 10                	push   $0x10
  jmp __alltraps
c0101f0a:	e9 53 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f0f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f0f:	6a 11                	push   $0x11
  jmp __alltraps
c0101f11:	e9 4c ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f16 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $18
c0101f18:	6a 12                	push   $0x12
  jmp __alltraps
c0101f1a:	e9 43 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f1f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $19
c0101f21:	6a 13                	push   $0x13
  jmp __alltraps
c0101f23:	e9 3a ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f28 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $20
c0101f2a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f2c:	e9 31 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f31 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $21
c0101f33:	6a 15                	push   $0x15
  jmp __alltraps
c0101f35:	e9 28 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f3a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f3a:	6a 00                	push   $0x0
  pushl $22
c0101f3c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f3e:	e9 1f ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f43 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f43:	6a 00                	push   $0x0
  pushl $23
c0101f45:	6a 17                	push   $0x17
  jmp __alltraps
c0101f47:	e9 16 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f4c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f4c:	6a 00                	push   $0x0
  pushl $24
c0101f4e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f50:	e9 0d ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f55 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f55:	6a 00                	push   $0x0
  pushl $25
c0101f57:	6a 19                	push   $0x19
  jmp __alltraps
c0101f59:	e9 04 ff ff ff       	jmp    c0101e62 <__alltraps>

c0101f5e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f5e:	6a 00                	push   $0x0
  pushl $26
c0101f60:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f62:	e9 fb fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f67 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f67:	6a 00                	push   $0x0
  pushl $27
c0101f69:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f6b:	e9 f2 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f70 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f70:	6a 00                	push   $0x0
  pushl $28
c0101f72:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f74:	e9 e9 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f79 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f79:	6a 00                	push   $0x0
  pushl $29
c0101f7b:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f7d:	e9 e0 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f82 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f82:	6a 00                	push   $0x0
  pushl $30
c0101f84:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f86:	e9 d7 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f8b <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $31
c0101f8d:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f8f:	e9 ce fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f94 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $32
c0101f96:	6a 20                	push   $0x20
  jmp __alltraps
c0101f98:	e9 c5 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101f9d <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $33
c0101f9f:	6a 21                	push   $0x21
  jmp __alltraps
c0101fa1:	e9 bc fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fa6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $34
c0101fa8:	6a 22                	push   $0x22
  jmp __alltraps
c0101faa:	e9 b3 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101faf <vector35>:
.globl vector35
vector35:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $35
c0101fb1:	6a 23                	push   $0x23
  jmp __alltraps
c0101fb3:	e9 aa fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fb8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fb8:	6a 00                	push   $0x0
  pushl $36
c0101fba:	6a 24                	push   $0x24
  jmp __alltraps
c0101fbc:	e9 a1 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fc1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fc1:	6a 00                	push   $0x0
  pushl $37
c0101fc3:	6a 25                	push   $0x25
  jmp __alltraps
c0101fc5:	e9 98 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fca <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fca:	6a 00                	push   $0x0
  pushl $38
c0101fcc:	6a 26                	push   $0x26
  jmp __alltraps
c0101fce:	e9 8f fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fd3 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fd3:	6a 00                	push   $0x0
  pushl $39
c0101fd5:	6a 27                	push   $0x27
  jmp __alltraps
c0101fd7:	e9 86 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fdc <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fdc:	6a 00                	push   $0x0
  pushl $40
c0101fde:	6a 28                	push   $0x28
  jmp __alltraps
c0101fe0:	e9 7d fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fe5 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $41
c0101fe7:	6a 29                	push   $0x29
  jmp __alltraps
c0101fe9:	e9 74 fe ff ff       	jmp    c0101e62 <__alltraps>

c0101fee <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $42
c0101ff0:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101ff2:	e9 6b fe ff ff       	jmp    c0101e62 <__alltraps>

c0101ff7 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101ff7:	6a 00                	push   $0x0
  pushl $43
c0101ff9:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101ffb:	e9 62 fe ff ff       	jmp    c0101e62 <__alltraps>

c0102000 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102000:	6a 00                	push   $0x0
  pushl $44
c0102002:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102004:	e9 59 fe ff ff       	jmp    c0101e62 <__alltraps>

c0102009 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102009:	6a 00                	push   $0x0
  pushl $45
c010200b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010200d:	e9 50 fe ff ff       	jmp    c0101e62 <__alltraps>

c0102012 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102012:	6a 00                	push   $0x0
  pushl $46
c0102014:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102016:	e9 47 fe ff ff       	jmp    c0101e62 <__alltraps>

c010201b <vector47>:
.globl vector47
vector47:
  pushl $0
c010201b:	6a 00                	push   $0x0
  pushl $47
c010201d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010201f:	e9 3e fe ff ff       	jmp    c0101e62 <__alltraps>

c0102024 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102024:	6a 00                	push   $0x0
  pushl $48
c0102026:	6a 30                	push   $0x30
  jmp __alltraps
c0102028:	e9 35 fe ff ff       	jmp    c0101e62 <__alltraps>

c010202d <vector49>:
.globl vector49
vector49:
  pushl $0
c010202d:	6a 00                	push   $0x0
  pushl $49
c010202f:	6a 31                	push   $0x31
  jmp __alltraps
c0102031:	e9 2c fe ff ff       	jmp    c0101e62 <__alltraps>

c0102036 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $50
c0102038:	6a 32                	push   $0x32
  jmp __alltraps
c010203a:	e9 23 fe ff ff       	jmp    c0101e62 <__alltraps>

c010203f <vector51>:
.globl vector51
vector51:
  pushl $0
c010203f:	6a 00                	push   $0x0
  pushl $51
c0102041:	6a 33                	push   $0x33
  jmp __alltraps
c0102043:	e9 1a fe ff ff       	jmp    c0101e62 <__alltraps>

c0102048 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102048:	6a 00                	push   $0x0
  pushl $52
c010204a:	6a 34                	push   $0x34
  jmp __alltraps
c010204c:	e9 11 fe ff ff       	jmp    c0101e62 <__alltraps>

c0102051 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102051:	6a 00                	push   $0x0
  pushl $53
c0102053:	6a 35                	push   $0x35
  jmp __alltraps
c0102055:	e9 08 fe ff ff       	jmp    c0101e62 <__alltraps>

c010205a <vector54>:
.globl vector54
vector54:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $54
c010205c:	6a 36                	push   $0x36
  jmp __alltraps
c010205e:	e9 ff fd ff ff       	jmp    c0101e62 <__alltraps>

c0102063 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102063:	6a 00                	push   $0x0
  pushl $55
c0102065:	6a 37                	push   $0x37
  jmp __alltraps
c0102067:	e9 f6 fd ff ff       	jmp    c0101e62 <__alltraps>

c010206c <vector56>:
.globl vector56
vector56:
  pushl $0
c010206c:	6a 00                	push   $0x0
  pushl $56
c010206e:	6a 38                	push   $0x38
  jmp __alltraps
c0102070:	e9 ed fd ff ff       	jmp    c0101e62 <__alltraps>

c0102075 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102075:	6a 00                	push   $0x0
  pushl $57
c0102077:	6a 39                	push   $0x39
  jmp __alltraps
c0102079:	e9 e4 fd ff ff       	jmp    c0101e62 <__alltraps>

c010207e <vector58>:
.globl vector58
vector58:
  pushl $0
c010207e:	6a 00                	push   $0x0
  pushl $58
c0102080:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102082:	e9 db fd ff ff       	jmp    c0101e62 <__alltraps>

c0102087 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102087:	6a 00                	push   $0x0
  pushl $59
c0102089:	6a 3b                	push   $0x3b
  jmp __alltraps
c010208b:	e9 d2 fd ff ff       	jmp    c0101e62 <__alltraps>

c0102090 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102090:	6a 00                	push   $0x0
  pushl $60
c0102092:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102094:	e9 c9 fd ff ff       	jmp    c0101e62 <__alltraps>

c0102099 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102099:	6a 00                	push   $0x0
  pushl $61
c010209b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010209d:	e9 c0 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020a2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01020a2:	6a 00                	push   $0x0
  pushl $62
c01020a4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020a6:	e9 b7 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020ab <vector63>:
.globl vector63
vector63:
  pushl $0
c01020ab:	6a 00                	push   $0x0
  pushl $63
c01020ad:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020af:	e9 ae fd ff ff       	jmp    c0101e62 <__alltraps>

c01020b4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020b4:	6a 00                	push   $0x0
  pushl $64
c01020b6:	6a 40                	push   $0x40
  jmp __alltraps
c01020b8:	e9 a5 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020bd <vector65>:
.globl vector65
vector65:
  pushl $0
c01020bd:	6a 00                	push   $0x0
  pushl $65
c01020bf:	6a 41                	push   $0x41
  jmp __alltraps
c01020c1:	e9 9c fd ff ff       	jmp    c0101e62 <__alltraps>

c01020c6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020c6:	6a 00                	push   $0x0
  pushl $66
c01020c8:	6a 42                	push   $0x42
  jmp __alltraps
c01020ca:	e9 93 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020cf <vector67>:
.globl vector67
vector67:
  pushl $0
c01020cf:	6a 00                	push   $0x0
  pushl $67
c01020d1:	6a 43                	push   $0x43
  jmp __alltraps
c01020d3:	e9 8a fd ff ff       	jmp    c0101e62 <__alltraps>

c01020d8 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020d8:	6a 00                	push   $0x0
  pushl $68
c01020da:	6a 44                	push   $0x44
  jmp __alltraps
c01020dc:	e9 81 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020e1 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020e1:	6a 00                	push   $0x0
  pushl $69
c01020e3:	6a 45                	push   $0x45
  jmp __alltraps
c01020e5:	e9 78 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020ea <vector70>:
.globl vector70
vector70:
  pushl $0
c01020ea:	6a 00                	push   $0x0
  pushl $70
c01020ec:	6a 46                	push   $0x46
  jmp __alltraps
c01020ee:	e9 6f fd ff ff       	jmp    c0101e62 <__alltraps>

c01020f3 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020f3:	6a 00                	push   $0x0
  pushl $71
c01020f5:	6a 47                	push   $0x47
  jmp __alltraps
c01020f7:	e9 66 fd ff ff       	jmp    c0101e62 <__alltraps>

c01020fc <vector72>:
.globl vector72
vector72:
  pushl $0
c01020fc:	6a 00                	push   $0x0
  pushl $72
c01020fe:	6a 48                	push   $0x48
  jmp __alltraps
c0102100:	e9 5d fd ff ff       	jmp    c0101e62 <__alltraps>

c0102105 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102105:	6a 00                	push   $0x0
  pushl $73
c0102107:	6a 49                	push   $0x49
  jmp __alltraps
c0102109:	e9 54 fd ff ff       	jmp    c0101e62 <__alltraps>

c010210e <vector74>:
.globl vector74
vector74:
  pushl $0
c010210e:	6a 00                	push   $0x0
  pushl $74
c0102110:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102112:	e9 4b fd ff ff       	jmp    c0101e62 <__alltraps>

c0102117 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102117:	6a 00                	push   $0x0
  pushl $75
c0102119:	6a 4b                	push   $0x4b
  jmp __alltraps
c010211b:	e9 42 fd ff ff       	jmp    c0101e62 <__alltraps>

c0102120 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102120:	6a 00                	push   $0x0
  pushl $76
c0102122:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102124:	e9 39 fd ff ff       	jmp    c0101e62 <__alltraps>

c0102129 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102129:	6a 00                	push   $0x0
  pushl $77
c010212b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010212d:	e9 30 fd ff ff       	jmp    c0101e62 <__alltraps>

c0102132 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102132:	6a 00                	push   $0x0
  pushl $78
c0102134:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102136:	e9 27 fd ff ff       	jmp    c0101e62 <__alltraps>

c010213b <vector79>:
.globl vector79
vector79:
  pushl $0
c010213b:	6a 00                	push   $0x0
  pushl $79
c010213d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010213f:	e9 1e fd ff ff       	jmp    c0101e62 <__alltraps>

c0102144 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102144:	6a 00                	push   $0x0
  pushl $80
c0102146:	6a 50                	push   $0x50
  jmp __alltraps
c0102148:	e9 15 fd ff ff       	jmp    c0101e62 <__alltraps>

c010214d <vector81>:
.globl vector81
vector81:
  pushl $0
c010214d:	6a 00                	push   $0x0
  pushl $81
c010214f:	6a 51                	push   $0x51
  jmp __alltraps
c0102151:	e9 0c fd ff ff       	jmp    c0101e62 <__alltraps>

c0102156 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102156:	6a 00                	push   $0x0
  pushl $82
c0102158:	6a 52                	push   $0x52
  jmp __alltraps
c010215a:	e9 03 fd ff ff       	jmp    c0101e62 <__alltraps>

c010215f <vector83>:
.globl vector83
vector83:
  pushl $0
c010215f:	6a 00                	push   $0x0
  pushl $83
c0102161:	6a 53                	push   $0x53
  jmp __alltraps
c0102163:	e9 fa fc ff ff       	jmp    c0101e62 <__alltraps>

c0102168 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102168:	6a 00                	push   $0x0
  pushl $84
c010216a:	6a 54                	push   $0x54
  jmp __alltraps
c010216c:	e9 f1 fc ff ff       	jmp    c0101e62 <__alltraps>

c0102171 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102171:	6a 00                	push   $0x0
  pushl $85
c0102173:	6a 55                	push   $0x55
  jmp __alltraps
c0102175:	e9 e8 fc ff ff       	jmp    c0101e62 <__alltraps>

c010217a <vector86>:
.globl vector86
vector86:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $86
c010217c:	6a 56                	push   $0x56
  jmp __alltraps
c010217e:	e9 df fc ff ff       	jmp    c0101e62 <__alltraps>

c0102183 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102183:	6a 00                	push   $0x0
  pushl $87
c0102185:	6a 57                	push   $0x57
  jmp __alltraps
c0102187:	e9 d6 fc ff ff       	jmp    c0101e62 <__alltraps>

c010218c <vector88>:
.globl vector88
vector88:
  pushl $0
c010218c:	6a 00                	push   $0x0
  pushl $88
c010218e:	6a 58                	push   $0x58
  jmp __alltraps
c0102190:	e9 cd fc ff ff       	jmp    c0101e62 <__alltraps>

c0102195 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102195:	6a 00                	push   $0x0
  pushl $89
c0102197:	6a 59                	push   $0x59
  jmp __alltraps
c0102199:	e9 c4 fc ff ff       	jmp    c0101e62 <__alltraps>

c010219e <vector90>:
.globl vector90
vector90:
  pushl $0
c010219e:	6a 00                	push   $0x0
  pushl $90
c01021a0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021a2:	e9 bb fc ff ff       	jmp    c0101e62 <__alltraps>

c01021a7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021a7:	6a 00                	push   $0x0
  pushl $91
c01021a9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021ab:	e9 b2 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021b0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021b0:	6a 00                	push   $0x0
  pushl $92
c01021b2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021b4:	e9 a9 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021b9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021b9:	6a 00                	push   $0x0
  pushl $93
c01021bb:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021bd:	e9 a0 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021c2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021c2:	6a 00                	push   $0x0
  pushl $94
c01021c4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021c6:	e9 97 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021cb <vector95>:
.globl vector95
vector95:
  pushl $0
c01021cb:	6a 00                	push   $0x0
  pushl $95
c01021cd:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021cf:	e9 8e fc ff ff       	jmp    c0101e62 <__alltraps>

c01021d4 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021d4:	6a 00                	push   $0x0
  pushl $96
c01021d6:	6a 60                	push   $0x60
  jmp __alltraps
c01021d8:	e9 85 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021dd <vector97>:
.globl vector97
vector97:
  pushl $0
c01021dd:	6a 00                	push   $0x0
  pushl $97
c01021df:	6a 61                	push   $0x61
  jmp __alltraps
c01021e1:	e9 7c fc ff ff       	jmp    c0101e62 <__alltraps>

c01021e6 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021e6:	6a 00                	push   $0x0
  pushl $98
c01021e8:	6a 62                	push   $0x62
  jmp __alltraps
c01021ea:	e9 73 fc ff ff       	jmp    c0101e62 <__alltraps>

c01021ef <vector99>:
.globl vector99
vector99:
  pushl $0
c01021ef:	6a 00                	push   $0x0
  pushl $99
c01021f1:	6a 63                	push   $0x63
  jmp __alltraps
c01021f3:	e9 6a fc ff ff       	jmp    c0101e62 <__alltraps>

c01021f8 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021f8:	6a 00                	push   $0x0
  pushl $100
c01021fa:	6a 64                	push   $0x64
  jmp __alltraps
c01021fc:	e9 61 fc ff ff       	jmp    c0101e62 <__alltraps>

c0102201 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $101
c0102203:	6a 65                	push   $0x65
  jmp __alltraps
c0102205:	e9 58 fc ff ff       	jmp    c0101e62 <__alltraps>

c010220a <vector102>:
.globl vector102
vector102:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $102
c010220c:	6a 66                	push   $0x66
  jmp __alltraps
c010220e:	e9 4f fc ff ff       	jmp    c0101e62 <__alltraps>

c0102213 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $103
c0102215:	6a 67                	push   $0x67
  jmp __alltraps
c0102217:	e9 46 fc ff ff       	jmp    c0101e62 <__alltraps>

c010221c <vector104>:
.globl vector104
vector104:
  pushl $0
c010221c:	6a 00                	push   $0x0
  pushl $104
c010221e:	6a 68                	push   $0x68
  jmp __alltraps
c0102220:	e9 3d fc ff ff       	jmp    c0101e62 <__alltraps>

c0102225 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $105
c0102227:	6a 69                	push   $0x69
  jmp __alltraps
c0102229:	e9 34 fc ff ff       	jmp    c0101e62 <__alltraps>

c010222e <vector106>:
.globl vector106
vector106:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $106
c0102230:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102232:	e9 2b fc ff ff       	jmp    c0101e62 <__alltraps>

c0102237 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $107
c0102239:	6a 6b                	push   $0x6b
  jmp __alltraps
c010223b:	e9 22 fc ff ff       	jmp    c0101e62 <__alltraps>

c0102240 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102240:	6a 00                	push   $0x0
  pushl $108
c0102242:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102244:	e9 19 fc ff ff       	jmp    c0101e62 <__alltraps>

c0102249 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $109
c010224b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010224d:	e9 10 fc ff ff       	jmp    c0101e62 <__alltraps>

c0102252 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102252:	6a 00                	push   $0x0
  pushl $110
c0102254:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102256:	e9 07 fc ff ff       	jmp    c0101e62 <__alltraps>

c010225b <vector111>:
.globl vector111
vector111:
  pushl $0
c010225b:	6a 00                	push   $0x0
  pushl $111
c010225d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010225f:	e9 fe fb ff ff       	jmp    c0101e62 <__alltraps>

c0102264 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102264:	6a 00                	push   $0x0
  pushl $112
c0102266:	6a 70                	push   $0x70
  jmp __alltraps
c0102268:	e9 f5 fb ff ff       	jmp    c0101e62 <__alltraps>

c010226d <vector113>:
.globl vector113
vector113:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $113
c010226f:	6a 71                	push   $0x71
  jmp __alltraps
c0102271:	e9 ec fb ff ff       	jmp    c0101e62 <__alltraps>

c0102276 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102276:	6a 00                	push   $0x0
  pushl $114
c0102278:	6a 72                	push   $0x72
  jmp __alltraps
c010227a:	e9 e3 fb ff ff       	jmp    c0101e62 <__alltraps>

c010227f <vector115>:
.globl vector115
vector115:
  pushl $0
c010227f:	6a 00                	push   $0x0
  pushl $115
c0102281:	6a 73                	push   $0x73
  jmp __alltraps
c0102283:	e9 da fb ff ff       	jmp    c0101e62 <__alltraps>

c0102288 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102288:	6a 00                	push   $0x0
  pushl $116
c010228a:	6a 74                	push   $0x74
  jmp __alltraps
c010228c:	e9 d1 fb ff ff       	jmp    c0101e62 <__alltraps>

c0102291 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $117
c0102293:	6a 75                	push   $0x75
  jmp __alltraps
c0102295:	e9 c8 fb ff ff       	jmp    c0101e62 <__alltraps>

c010229a <vector118>:
.globl vector118
vector118:
  pushl $0
c010229a:	6a 00                	push   $0x0
  pushl $118
c010229c:	6a 76                	push   $0x76
  jmp __alltraps
c010229e:	e9 bf fb ff ff       	jmp    c0101e62 <__alltraps>

c01022a3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01022a3:	6a 00                	push   $0x0
  pushl $119
c01022a5:	6a 77                	push   $0x77
  jmp __alltraps
c01022a7:	e9 b6 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022ac <vector120>:
.globl vector120
vector120:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $120
c01022ae:	6a 78                	push   $0x78
  jmp __alltraps
c01022b0:	e9 ad fb ff ff       	jmp    c0101e62 <__alltraps>

c01022b5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $121
c01022b7:	6a 79                	push   $0x79
  jmp __alltraps
c01022b9:	e9 a4 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022be <vector122>:
.globl vector122
vector122:
  pushl $0
c01022be:	6a 00                	push   $0x0
  pushl $122
c01022c0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022c2:	e9 9b fb ff ff       	jmp    c0101e62 <__alltraps>

c01022c7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022c7:	6a 00                	push   $0x0
  pushl $123
c01022c9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022cb:	e9 92 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022d0 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022d0:	6a 00                	push   $0x0
  pushl $124
c01022d2:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022d4:	e9 89 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022d9 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $125
c01022db:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022dd:	e9 80 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022e2 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022e2:	6a 00                	push   $0x0
  pushl $126
c01022e4:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022e6:	e9 77 fb ff ff       	jmp    c0101e62 <__alltraps>

c01022eb <vector127>:
.globl vector127
vector127:
  pushl $0
c01022eb:	6a 00                	push   $0x0
  pushl $127
c01022ed:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022ef:	e9 6e fb ff ff       	jmp    c0101e62 <__alltraps>

c01022f4 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022f4:	6a 00                	push   $0x0
  pushl $128
c01022f6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022fb:	e9 62 fb ff ff       	jmp    c0101e62 <__alltraps>

c0102300 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $129
c0102302:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102307:	e9 56 fb ff ff       	jmp    c0101e62 <__alltraps>

c010230c <vector130>:
.globl vector130
vector130:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $130
c010230e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102313:	e9 4a fb ff ff       	jmp    c0101e62 <__alltraps>

c0102318 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102318:	6a 00                	push   $0x0
  pushl $131
c010231a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010231f:	e9 3e fb ff ff       	jmp    c0101e62 <__alltraps>

c0102324 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $132
c0102326:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010232b:	e9 32 fb ff ff       	jmp    c0101e62 <__alltraps>

c0102330 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $133
c0102332:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102337:	e9 26 fb ff ff       	jmp    c0101e62 <__alltraps>

c010233c <vector134>:
.globl vector134
vector134:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $134
c010233e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102343:	e9 1a fb ff ff       	jmp    c0101e62 <__alltraps>

c0102348 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $135
c010234a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010234f:	e9 0e fb ff ff       	jmp    c0101e62 <__alltraps>

c0102354 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $136
c0102356:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010235b:	e9 02 fb ff ff       	jmp    c0101e62 <__alltraps>

c0102360 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $137
c0102362:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102367:	e9 f6 fa ff ff       	jmp    c0101e62 <__alltraps>

c010236c <vector138>:
.globl vector138
vector138:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $138
c010236e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102373:	e9 ea fa ff ff       	jmp    c0101e62 <__alltraps>

c0102378 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $139
c010237a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010237f:	e9 de fa ff ff       	jmp    c0101e62 <__alltraps>

c0102384 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $140
c0102386:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010238b:	e9 d2 fa ff ff       	jmp    c0101e62 <__alltraps>

c0102390 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $141
c0102392:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102397:	e9 c6 fa ff ff       	jmp    c0101e62 <__alltraps>

c010239c <vector142>:
.globl vector142
vector142:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $142
c010239e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023a3:	e9 ba fa ff ff       	jmp    c0101e62 <__alltraps>

c01023a8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $143
c01023aa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023af:	e9 ae fa ff ff       	jmp    c0101e62 <__alltraps>

c01023b4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $144
c01023b6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023bb:	e9 a2 fa ff ff       	jmp    c0101e62 <__alltraps>

c01023c0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $145
c01023c2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023c7:	e9 96 fa ff ff       	jmp    c0101e62 <__alltraps>

c01023cc <vector146>:
.globl vector146
vector146:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $146
c01023ce:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023d3:	e9 8a fa ff ff       	jmp    c0101e62 <__alltraps>

c01023d8 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $147
c01023da:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023df:	e9 7e fa ff ff       	jmp    c0101e62 <__alltraps>

c01023e4 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $148
c01023e6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023eb:	e9 72 fa ff ff       	jmp    c0101e62 <__alltraps>

c01023f0 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $149
c01023f2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023f7:	e9 66 fa ff ff       	jmp    c0101e62 <__alltraps>

c01023fc <vector150>:
.globl vector150
vector150:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $150
c01023fe:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102403:	e9 5a fa ff ff       	jmp    c0101e62 <__alltraps>

c0102408 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $151
c010240a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010240f:	e9 4e fa ff ff       	jmp    c0101e62 <__alltraps>

c0102414 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $152
c0102416:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010241b:	e9 42 fa ff ff       	jmp    c0101e62 <__alltraps>

c0102420 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $153
c0102422:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102427:	e9 36 fa ff ff       	jmp    c0101e62 <__alltraps>

c010242c <vector154>:
.globl vector154
vector154:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $154
c010242e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102433:	e9 2a fa ff ff       	jmp    c0101e62 <__alltraps>

c0102438 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $155
c010243a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010243f:	e9 1e fa ff ff       	jmp    c0101e62 <__alltraps>

c0102444 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $156
c0102446:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010244b:	e9 12 fa ff ff       	jmp    c0101e62 <__alltraps>

c0102450 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $157
c0102452:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102457:	e9 06 fa ff ff       	jmp    c0101e62 <__alltraps>

c010245c <vector158>:
.globl vector158
vector158:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $158
c010245e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102463:	e9 fa f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102468 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $159
c010246a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010246f:	e9 ee f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102474 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $160
c0102476:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010247b:	e9 e2 f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102480 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $161
c0102482:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102487:	e9 d6 f9 ff ff       	jmp    c0101e62 <__alltraps>

c010248c <vector162>:
.globl vector162
vector162:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $162
c010248e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102493:	e9 ca f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102498 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $163
c010249a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010249f:	e9 be f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024a4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $164
c01024a6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024ab:	e9 b2 f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024b0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $165
c01024b2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024b7:	e9 a6 f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024bc <vector166>:
.globl vector166
vector166:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $166
c01024be:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024c3:	e9 9a f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024c8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $167
c01024ca:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024cf:	e9 8e f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024d4 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $168
c01024d6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024db:	e9 82 f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024e0 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $169
c01024e2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024e7:	e9 76 f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024ec <vector170>:
.globl vector170
vector170:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $170
c01024ee:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024f3:	e9 6a f9 ff ff       	jmp    c0101e62 <__alltraps>

c01024f8 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $171
c01024fa:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024ff:	e9 5e f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102504 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $172
c0102506:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010250b:	e9 52 f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102510 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $173
c0102512:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102517:	e9 46 f9 ff ff       	jmp    c0101e62 <__alltraps>

c010251c <vector174>:
.globl vector174
vector174:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $174
c010251e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102523:	e9 3a f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102528 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $175
c010252a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010252f:	e9 2e f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102534 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $176
c0102536:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010253b:	e9 22 f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102540 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $177
c0102542:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102547:	e9 16 f9 ff ff       	jmp    c0101e62 <__alltraps>

c010254c <vector178>:
.globl vector178
vector178:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $178
c010254e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102553:	e9 0a f9 ff ff       	jmp    c0101e62 <__alltraps>

c0102558 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $179
c010255a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010255f:	e9 fe f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102564 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $180
c0102566:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010256b:	e9 f2 f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102570 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $181
c0102572:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102577:	e9 e6 f8 ff ff       	jmp    c0101e62 <__alltraps>

c010257c <vector182>:
.globl vector182
vector182:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $182
c010257e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102583:	e9 da f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102588 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $183
c010258a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010258f:	e9 ce f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102594 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $184
c0102596:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010259b:	e9 c2 f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025a0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $185
c01025a2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025a7:	e9 b6 f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025ac <vector186>:
.globl vector186
vector186:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $186
c01025ae:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025b3:	e9 aa f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025b8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $187
c01025ba:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025bf:	e9 9e f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025c4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $188
c01025c6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025cb:	e9 92 f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025d0 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $189
c01025d2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025d7:	e9 86 f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025dc <vector190>:
.globl vector190
vector190:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $190
c01025de:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025e3:	e9 7a f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025e8 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $191
c01025ea:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025ef:	e9 6e f8 ff ff       	jmp    c0101e62 <__alltraps>

c01025f4 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $192
c01025f6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025fb:	e9 62 f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102600 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $193
c0102602:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102607:	e9 56 f8 ff ff       	jmp    c0101e62 <__alltraps>

c010260c <vector194>:
.globl vector194
vector194:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $194
c010260e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102613:	e9 4a f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102618 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $195
c010261a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010261f:	e9 3e f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102624 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $196
c0102626:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010262b:	e9 32 f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102630 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $197
c0102632:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102637:	e9 26 f8 ff ff       	jmp    c0101e62 <__alltraps>

c010263c <vector198>:
.globl vector198
vector198:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $198
c010263e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102643:	e9 1a f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102648 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $199
c010264a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010264f:	e9 0e f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102654 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $200
c0102656:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010265b:	e9 02 f8 ff ff       	jmp    c0101e62 <__alltraps>

c0102660 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $201
c0102662:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102667:	e9 f6 f7 ff ff       	jmp    c0101e62 <__alltraps>

c010266c <vector202>:
.globl vector202
vector202:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $202
c010266e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102673:	e9 ea f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102678 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $203
c010267a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010267f:	e9 de f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102684 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $204
c0102686:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010268b:	e9 d2 f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102690 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $205
c0102692:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102697:	e9 c6 f7 ff ff       	jmp    c0101e62 <__alltraps>

c010269c <vector206>:
.globl vector206
vector206:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $206
c010269e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026a3:	e9 ba f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026a8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $207
c01026aa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026af:	e9 ae f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026b4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $208
c01026b6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026bb:	e9 a2 f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026c0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $209
c01026c2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026c7:	e9 96 f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026cc <vector210>:
.globl vector210
vector210:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $210
c01026ce:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026d3:	e9 8a f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026d8 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $211
c01026da:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026df:	e9 7e f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026e4 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $212
c01026e6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026eb:	e9 72 f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026f0 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $213
c01026f2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026f7:	e9 66 f7 ff ff       	jmp    c0101e62 <__alltraps>

c01026fc <vector214>:
.globl vector214
vector214:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $214
c01026fe:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102703:	e9 5a f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102708 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $215
c010270a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010270f:	e9 4e f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102714 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $216
c0102716:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010271b:	e9 42 f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102720 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $217
c0102722:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102727:	e9 36 f7 ff ff       	jmp    c0101e62 <__alltraps>

c010272c <vector218>:
.globl vector218
vector218:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $218
c010272e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102733:	e9 2a f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102738 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $219
c010273a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010273f:	e9 1e f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102744 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $220
c0102746:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010274b:	e9 12 f7 ff ff       	jmp    c0101e62 <__alltraps>

c0102750 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $221
c0102752:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102757:	e9 06 f7 ff ff       	jmp    c0101e62 <__alltraps>

c010275c <vector222>:
.globl vector222
vector222:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $222
c010275e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102763:	e9 fa f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102768 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $223
c010276a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010276f:	e9 ee f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102774 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $224
c0102776:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010277b:	e9 e2 f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102780 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $225
c0102782:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102787:	e9 d6 f6 ff ff       	jmp    c0101e62 <__alltraps>

c010278c <vector226>:
.globl vector226
vector226:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $226
c010278e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102793:	e9 ca f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102798 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $227
c010279a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010279f:	e9 be f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027a4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $228
c01027a6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027ab:	e9 b2 f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027b0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $229
c01027b2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027b7:	e9 a6 f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027bc <vector230>:
.globl vector230
vector230:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $230
c01027be:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027c3:	e9 9a f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027c8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $231
c01027ca:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027cf:	e9 8e f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027d4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $232
c01027d6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027db:	e9 82 f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027e0 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $233
c01027e2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027e7:	e9 76 f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027ec <vector234>:
.globl vector234
vector234:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $234
c01027ee:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027f3:	e9 6a f6 ff ff       	jmp    c0101e62 <__alltraps>

c01027f8 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $235
c01027fa:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027ff:	e9 5e f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102804 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $236
c0102806:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010280b:	e9 52 f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102810 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $237
c0102812:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102817:	e9 46 f6 ff ff       	jmp    c0101e62 <__alltraps>

c010281c <vector238>:
.globl vector238
vector238:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $238
c010281e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102823:	e9 3a f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102828 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $239
c010282a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010282f:	e9 2e f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102834 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $240
c0102836:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010283b:	e9 22 f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102840 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $241
c0102842:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102847:	e9 16 f6 ff ff       	jmp    c0101e62 <__alltraps>

c010284c <vector242>:
.globl vector242
vector242:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $242
c010284e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102853:	e9 0a f6 ff ff       	jmp    c0101e62 <__alltraps>

c0102858 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $243
c010285a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010285f:	e9 fe f5 ff ff       	jmp    c0101e62 <__alltraps>

c0102864 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $244
c0102866:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010286b:	e9 f2 f5 ff ff       	jmp    c0101e62 <__alltraps>

c0102870 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $245
c0102872:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102877:	e9 e6 f5 ff ff       	jmp    c0101e62 <__alltraps>

c010287c <vector246>:
.globl vector246
vector246:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $246
c010287e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102883:	e9 da f5 ff ff       	jmp    c0101e62 <__alltraps>

c0102888 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $247
c010288a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010288f:	e9 ce f5 ff ff       	jmp    c0101e62 <__alltraps>

c0102894 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $248
c0102896:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010289b:	e9 c2 f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028a0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $249
c01028a2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028a7:	e9 b6 f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028ac <vector250>:
.globl vector250
vector250:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $250
c01028ae:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028b3:	e9 aa f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028b8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $251
c01028ba:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028bf:	e9 9e f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028c4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $252
c01028c6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028cb:	e9 92 f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028d0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $253
c01028d2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028d7:	e9 86 f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028dc <vector254>:
.globl vector254
vector254:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $254
c01028de:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028e3:	e9 7a f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028e8 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $255
c01028ea:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028ef:	e9 6e f5 ff ff       	jmp    c0101e62 <__alltraps>

c01028f4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028f4:	55                   	push   %ebp
c01028f5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01028fa:	a1 e4 89 11 c0       	mov    0xc01189e4,%eax
c01028ff:	29 c2                	sub    %eax,%edx
c0102901:	89 d0                	mov    %edx,%eax
c0102903:	c1 f8 02             	sar    $0x2,%eax
c0102906:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010290c:	5d                   	pop    %ebp
c010290d:	c3                   	ret    

c010290e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010290e:	55                   	push   %ebp
c010290f:	89 e5                	mov    %esp,%ebp
c0102911:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102914:	8b 45 08             	mov    0x8(%ebp),%eax
c0102917:	89 04 24             	mov    %eax,(%esp)
c010291a:	e8 d5 ff ff ff       	call   c01028f4 <page2ppn>
c010291f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102922:	c9                   	leave  
c0102923:	c3                   	ret    

c0102924 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102924:	55                   	push   %ebp
c0102925:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102927:	8b 45 08             	mov    0x8(%ebp),%eax
c010292a:	8b 00                	mov    (%eax),%eax
}
c010292c:	5d                   	pop    %ebp
c010292d:	c3                   	ret    

c010292e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010292e:	55                   	push   %ebp
c010292f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102931:	8b 45 08             	mov    0x8(%ebp),%eax
c0102934:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102937:	89 10                	mov    %edx,(%eax)
}
c0102939:	5d                   	pop    %ebp
c010293a:	c3                   	ret    

c010293b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010293b:	55                   	push   %ebp
c010293c:	89 e5                	mov    %esp,%ebp
c010293e:	83 ec 10             	sub    $0x10,%esp
c0102941:	c7 45 fc d0 89 11 c0 	movl   $0xc01189d0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102948:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010294b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010294e:	89 50 04             	mov    %edx,0x4(%eax)
c0102951:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102954:	8b 50 04             	mov    0x4(%eax),%edx
c0102957:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010295a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010295c:	c7 05 d8 89 11 c0 00 	movl   $0x0,0xc01189d8
c0102963:	00 00 00 
}
c0102966:	c9                   	leave  
c0102967:	c3                   	ret    

c0102968 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102968:	55                   	push   %ebp
c0102969:	89 e5                	mov    %esp,%ebp
c010296b:	83 ec 78             	sub    $0x78,%esp
	assert(n > 0);
c010296e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102972:	75 24                	jne    c0102998 <default_init_memmap+0x30>
c0102974:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c010297b:	c0 
c010297c:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102983:	c0 
c0102984:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010298b:	00 
c010298c:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102993:	e8 33 e3 ff ff       	call   c0100ccb <__panic>
	struct Page* p = base;
c0102998:	8b 45 08             	mov    0x8(%ebp),%eax
c010299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++)
c010299e:	e9 a3 00 00 00       	jmp    c0102a46 <default_init_memmap+0xde>
	{
		assert(PageReserved(p));
c01029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a6:	83 c0 04             	add    $0x4,%eax
c01029a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01029b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01029b9:	0f a3 10             	bt     %edx,(%eax)
c01029bc:	19 c0                	sbb    %eax,%eax
c01029be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01029c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01029c5:	0f 95 c0             	setne  %al
c01029c8:	0f b6 c0             	movzbl %al,%eax
c01029cb:	85 c0                	test   %eax,%eax
c01029cd:	75 24                	jne    c01029f3 <default_init_memmap+0x8b>
c01029cf:	c7 44 24 0c 01 69 10 	movl   $0xc0106901,0xc(%esp)
c01029d6:	c0 
c01029d7:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01029de:	c0 
c01029df:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c01029e6:	00 
c01029e7:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01029ee:	e8 d8 e2 ff ff       	call   c0100ccb <__panic>
		ClearPageReserved(p);
c01029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f6:	83 c0 04             	add    $0x4,%eax
c01029f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102a00:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102a09:	0f b3 10             	btr    %edx,(%eax)
		SetPageProperty(p);
c0102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a0f:	83 c0 04             	add    $0x4,%eax
c0102a12:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0102a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a1f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a22:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
c0102a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
c0102a2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a36:	00 
c0102a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a3a:	89 04 24             	mov    %eax,(%esp)
c0102a3d:	e8 ec fe ff ff       	call   c010292e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
	struct Page* p = base;
	for (; p != base + n; p++)
c0102a42:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a49:	89 d0                	mov    %edx,%eax
c0102a4b:	c1 e0 02             	shl    $0x2,%eax
c0102a4e:	01 d0                	add    %edx,%eax
c0102a50:	c1 e0 02             	shl    $0x2,%eax
c0102a53:	89 c2                	mov    %eax,%edx
c0102a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a58:	01 d0                	add    %edx,%eax
c0102a5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a5d:	0f 85 40 ff ff ff    	jne    c01029a3 <default_init_memmap+0x3b>
		ClearPageReserved(p);
		SetPageProperty(p);
		p->property = 0;
		set_page_ref(p, 0);
	}
	base->property = n;
c0102a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a66:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a69:	89 50 08             	mov    %edx,0x8(%eax)
	nr_free += n;
c0102a6c:	8b 15 d8 89 11 c0    	mov    0xc01189d8,%edx
c0102a72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a75:	01 d0                	add    %edx,%eax
c0102a77:	a3 d8 89 11 c0       	mov    %eax,0xc01189d8
c0102a7c:	c7 45 d0 d0 89 11 c0 	movl   $0xc01189d0,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a83:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a86:	8b 40 04             	mov    0x4(%eax),%eax
	
	list_entry_t *le = list_next(&free_list);
c0102a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list)
c0102a8c:	eb 6c                	jmp    c0102afa <default_init_memmap+0x192>
	{
		p = le2page(le, page_link);
c0102a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a91:	83 e8 0c             	sub    $0xc,%eax
c0102a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base < p)
c0102a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a9d:	73 4c                	jae    c0102aeb <default_init_memmap+0x183>
		{
			list_add_before(&(p->page_link), &(base->page_link));
c0102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa2:	83 c0 0c             	add    $0xc,%eax
c0102aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102aa8:	83 c2 0c             	add    $0xc,%edx
c0102aab:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102aae:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102ab1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ab4:	8b 00                	mov    (%eax),%eax
c0102ab6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ab9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102abc:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102abf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ac2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ac5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ac8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102acb:	89 10                	mov    %edx,(%eax)
c0102acd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ad0:	8b 10                	mov    (%eax),%edx
c0102ad2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ad5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ad8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102adb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ade:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ae1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ae4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ae7:	89 10                	mov    %edx,(%eax)
			return;
c0102ae9:	eb 60                	jmp    c0102b4b <default_init_memmap+0x1e3>
c0102aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102aee:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102af1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102af4:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c0102af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}
	base->property = n;
	nr_free += n;
	
	list_entry_t *le = list_next(&free_list);
	while (le != &free_list)
c0102afa:	81 7d f0 d0 89 11 c0 	cmpl   $0xc01189d0,-0x10(%ebp)
c0102b01:	75 8b                	jne    c0102a8e <default_init_memmap+0x126>
			list_add_before(&(p->page_link), &(base->page_link));
			return;
		}
		le = list_next(le);
	}	
	list_add_before(&free_list, &(base->page_link));
c0102b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b06:	83 c0 0c             	add    $0xc,%eax
c0102b09:	c7 45 b4 d0 89 11 c0 	movl   $0xc01189d0,-0x4c(%ebp)
c0102b10:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b13:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b16:	8b 00                	mov    (%eax),%eax
c0102b18:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102b1b:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102b1e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102b21:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b24:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b27:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102b2a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102b2d:	89 10                	mov    %edx,(%eax)
c0102b2f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102b32:	8b 10                	mov    (%eax),%edx
c0102b34:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102b37:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b3d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102b40:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b43:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b46:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102b49:	89 10                	mov    %edx,(%eax)
}
c0102b4b:	c9                   	leave  
c0102b4c:	c3                   	ret    

c0102b4d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102b4d:	55                   	push   %ebp
c0102b4e:	89 e5                	mov    %esp,%ebp
c0102b50:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b57:	75 24                	jne    c0102b7d <default_alloc_pages+0x30>
c0102b59:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c0102b60:	c0 
c0102b61:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102b68:	c0 
c0102b69:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0102b70:	00 
c0102b71:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102b78:	e8 4e e1 ff ff       	call   c0100ccb <__panic>
    if (n > nr_free) {
c0102b7d:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c0102b82:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b85:	73 0a                	jae    c0102b91 <default_alloc_pages+0x44>
        return NULL;
c0102b87:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b8c:	e9 6f 01 00 00       	jmp    c0102d00 <default_alloc_pages+0x1b3>
    }
    struct Page *page = NULL;
c0102b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b98:	c7 45 f0 d0 89 11 c0 	movl   $0xc01189d0,-0x10(%ebp)
	list_entry_t *prev_le = NULL;
c0102b9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int block_size = 0;
c0102ba6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102bad:	eb 1c                	jmp    c0102bcb <default_alloc_pages+0x7e>
        struct Page *p = le2page(le, page_link);
c0102baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bb2:	83 e8 0c             	sub    $0xc,%eax
c0102bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (p->property >= n) {
c0102bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bbb:	8b 40 08             	mov    0x8(%eax),%eax
c0102bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bc1:	72 08                	jb     c0102bcb <default_alloc_pages+0x7e>
            page = p;
c0102bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102bc9:	eb 18                	jmp    c0102be3 <default_alloc_pages+0x96>
c0102bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bce:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bd4:	8b 40 04             	mov    0x4(%eax),%eax
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
	list_entry_t *prev_le = NULL;
	int block_size = 0;
    while ((le = list_next(le)) != &free_list) {
c0102bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102bda:	81 7d f0 d0 89 11 c0 	cmpl   $0xc01189d0,-0x10(%ebp)
c0102be1:	75 cc                	jne    c0102baf <default_alloc_pages+0x62>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102be7:	0f 84 10 01 00 00    	je     c0102cfd <default_alloc_pages+0x1b0>
		block_size = page->property;
c0102bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf0:	8b 40 08             	mov    0x8(%eax),%eax
c0102bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		prev_le = list_prev(&(page->page_link));
c0102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf9:	83 c0 0c             	add    $0xc,%eax
c0102bfc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102bff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c02:	8b 00                	mov    (%eax),%eax
c0102c04:	89 45 e8             	mov    %eax,-0x18(%ebp)
		page->property = 0;
c0102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		int i = 0;
c0102c11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (;i < n; i++)
c0102c18:	eb 2e                	jmp    c0102c48 <default_alloc_pages+0xfb>
		{
			ClearPageProperty(page+i);
c0102c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c1d:	89 d0                	mov    %edx,%eax
c0102c1f:	c1 e0 02             	shl    $0x2,%eax
c0102c22:	01 d0                	add    %edx,%eax
c0102c24:	c1 e0 02             	shl    $0x2,%eax
c0102c27:	89 c2                	mov    %eax,%edx
c0102c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c2c:	01 d0                	add    %edx,%eax
c0102c2e:	83 c0 04             	add    $0x4,%eax
c0102c31:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102c38:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c3e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c41:	0f b3 10             	btr    %edx,(%eax)
    if (page != NULL) {
		block_size = page->property;
		prev_le = list_prev(&(page->page_link));
		page->property = 0;
		int i = 0;
		for (;i < n; i++)
c0102c44:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0102c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c4e:	72 ca                	jb     c0102c1a <default_alloc_pages+0xcd>
		{
			ClearPageProperty(page+i);
			//page_ref_inc(page+i); 
		}
        list_del(&(page->page_link));
c0102c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c53:	83 c0 0c             	add    $0xc,%eax
c0102c56:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102c59:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c5c:	8b 40 04             	mov    0x4(%eax),%eax
c0102c5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c62:	8b 12                	mov    (%edx),%edx
c0102c64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102c67:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c6d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c70:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c73:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c76:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c79:	89 10                	mov    %edx,(%eax)
        if (block_size > n) {
c0102c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c81:	76 6d                	jbe    c0102cf0 <default_alloc_pages+0x1a3>
            struct Page *p = page + n;
c0102c83:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c86:	89 d0                	mov    %edx,%eax
c0102c88:	c1 e0 02             	shl    $0x2,%eax
c0102c8b:	01 d0                	add    %edx,%eax
c0102c8d:	c1 e0 02             	shl    $0x2,%eax
c0102c90:	89 c2                	mov    %eax,%edx
c0102c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c95:	01 d0                	add    %edx,%eax
c0102c97:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = block_size - n;
c0102c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c9d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ca0:	89 c2                	mov    %eax,%edx
c0102ca2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ca5:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(prev_le, &(p->page_link));
c0102ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cab:	8d 50 0c             	lea    0xc(%eax),%edx
c0102cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cb1:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102cb4:	89 55 b8             	mov    %edx,-0x48(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102cb7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102cba:	8b 40 04             	mov    0x4(%eax),%eax
c0102cbd:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102cc0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102cc3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cc6:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102cc9:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ccc:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102ccf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102cd2:	89 10                	mov    %edx,(%eax)
c0102cd4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102cd7:	8b 10                	mov    (%eax),%edx
c0102cd9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102cdc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cdf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ce2:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102ce5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ce8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ceb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102cee:	89 10                	mov    %edx,(%eax)
    	}
        nr_free -= n;
c0102cf0:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c0102cf5:	2b 45 08             	sub    0x8(%ebp),%eax
c0102cf8:	a3 d8 89 11 c0       	mov    %eax,0xc01189d8
    }
    return page;
c0102cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d00:	c9                   	leave  
c0102d01:	c3                   	ret    

c0102d02 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102d02:	55                   	push   %ebp
c0102d03:	89 e5                	mov    %esp,%ebp
c0102d05:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d0f:	75 24                	jne    c0102d35 <default_free_pages+0x33>
c0102d11:	c7 44 24 0c d0 68 10 	movl   $0xc01068d0,0xc(%esp)
c0102d18:	c0 
c0102d19:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102d20:	c0 
c0102d21:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
c0102d28:	00 
c0102d29:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102d30:	e8 96 df ff ff       	call   c0100ccb <__panic>
    struct Page *p = base;
c0102d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102d3b:	e9 ac 00 00 00       	jmp    c0102dec <default_free_pages+0xea>
        assert(!PageReserved(p) && !PageProperty(p));
c0102d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d43:	83 c0 04             	add    $0x4,%eax
c0102d46:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102d4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d53:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102d56:	0f a3 10             	bt     %edx,(%eax)
c0102d59:	19 c0                	sbb    %eax,%eax
c0102d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102d5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d62:	0f 95 c0             	setne  %al
c0102d65:	0f b6 c0             	movzbl %al,%eax
c0102d68:	85 c0                	test   %eax,%eax
c0102d6a:	75 2c                	jne    c0102d98 <default_free_pages+0x96>
c0102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6f:	83 c0 04             	add    $0x4,%eax
c0102d72:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102d79:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102d82:	0f a3 10             	bt     %edx,(%eax)
c0102d85:	19 c0                	sbb    %eax,%eax
c0102d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102d8a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102d8e:	0f 95 c0             	setne  %al
c0102d91:	0f b6 c0             	movzbl %al,%eax
c0102d94:	85 c0                	test   %eax,%eax
c0102d96:	74 24                	je     c0102dbc <default_free_pages+0xba>
c0102d98:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c0102d9f:	c0 
c0102da0:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0102da7:	c0 
c0102da8:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
c0102daf:	00 
c0102db0:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0102db7:	e8 0f df ff ff       	call   c0100ccb <__panic>
		SetPageProperty(p);  
c0102dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbf:	83 c0 04             	add    $0x4,%eax
c0102dc2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102dc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102dcf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102dd2:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c0102dd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102ddc:	00 
c0102ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de0:	89 04 24             	mov    %eax,(%esp)
c0102de3:	e8 46 fb ff ff       	call   c010292e <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102de8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102dec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102def:	89 d0                	mov    %edx,%eax
c0102df1:	c1 e0 02             	shl    $0x2,%eax
c0102df4:	01 d0                	add    %edx,%eax
c0102df6:	c1 e0 02             	shl    $0x2,%eax
c0102df9:	89 c2                	mov    %eax,%edx
c0102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfe:	01 d0                	add    %edx,%eax
c0102e00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e03:	0f 85 37 ff ff ff    	jne    c0102d40 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
		SetPageProperty(p);  
        set_page_ref(p, 0);
    }
    base->property = n;
c0102e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e0f:	89 50 08             	mov    %edx,0x8(%eax)
c0102e12:	c7 45 cc d0 89 11 c0 	movl   $0xc01189d0,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e19:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e1c:	8b 40 04             	mov    0x4(%eax),%eax

	list_entry_t *le = list_next(&free_list);
c0102e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list) {
c0102e22:	eb 7f                	jmp    c0102ea3 <default_free_pages+0x1a1>
		p = le2page(le, page_link);
c0102e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e27:	83 e8 0c             	sub    $0xc,%eax
c0102e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base + base->property == p) {
c0102e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e30:	8b 50 08             	mov    0x8(%eax),%edx
c0102e33:	89 d0                	mov    %edx,%eax
c0102e35:	c1 e0 02             	shl    $0x2,%eax
c0102e38:	01 d0                	add    %edx,%eax
c0102e3a:	c1 e0 02             	shl    $0x2,%eax
c0102e3d:	89 c2                	mov    %eax,%edx
c0102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e42:	01 d0                	add    %edx,%eax
c0102e44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e47:	75 4b                	jne    c0102e94 <default_free_pages+0x192>
			base->property += p->property;
c0102e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4c:	8b 50 08             	mov    0x8(%eax),%edx
c0102e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e52:	8b 40 08             	mov    0x8(%eax),%eax
c0102e55:	01 c2                	add    %eax,%edx
c0102e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e5a:	89 50 08             	mov    %edx,0x8(%eax)
			p->property = 0;
c0102e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			list_del(&(p->page_link));
c0102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6a:	83 c0 0c             	add    $0xc,%eax
c0102e6d:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e70:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e73:	8b 40 04             	mov    0x4(%eax),%eax
c0102e76:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102e79:	8b 12                	mov    (%edx),%edx
c0102e7b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102e7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e84:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102e87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e8a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e8d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102e90:	89 10                	mov    %edx,(%eax)
			break;
c0102e92:	eb 1c                	jmp    c0102eb0 <default_free_pages+0x1ae>
c0102e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e97:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102e9d:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c0102ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;

	list_entry_t *le = list_next(&free_list);
	while (le != &free_list) {
c0102ea3:	81 7d f0 d0 89 11 c0 	cmpl   $0xc01189d0,-0x10(%ebp)
c0102eaa:	0f 85 74 ff ff ff    	jne    c0102e24 <default_free_pages+0x122>
c0102eb0:	c7 45 b8 d0 89 11 c0 	movl   $0xc01189d0,-0x48(%ebp)
c0102eb7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102eba:	8b 40 04             	mov    0x4(%eax),%eax
			break;
		}
		le = list_next(le);
	}
	
	le = list_next(&free_list);
c0102ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list) {
c0102ec0:	e9 85 00 00 00       	jmp    c0102f4a <default_free_pages+0x248>
		p = le2page(le, page_link);
c0102ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec8:	83 e8 0c             	sub    $0xc,%eax
c0102ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (p + p->property == base) {
c0102ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed1:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed4:	89 d0                	mov    %edx,%eax
c0102ed6:	c1 e0 02             	shl    $0x2,%eax
c0102ed9:	01 d0                	add    %edx,%eax
c0102edb:	c1 e0 02             	shl    $0x2,%eax
c0102ede:	89 c2                	mov    %eax,%edx
c0102ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee3:	01 d0                	add    %edx,%eax
c0102ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ee8:	75 51                	jne    c0102f3b <default_free_pages+0x239>
			p->property += base->property;
c0102eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eed:	8b 50 08             	mov    0x8(%eax),%edx
c0102ef0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef3:	8b 40 08             	mov    0x8(%eax),%eax
c0102ef6:	01 c2                	add    %eax,%edx
c0102ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efb:	89 50 08             	mov    %edx,0x8(%eax)
			base->property = 0;
c0102efe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			base = p;
c0102f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0b:	89 45 08             	mov    %eax,0x8(%ebp)
			list_del(&(p->page_link));
c0102f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f11:	83 c0 0c             	add    $0xc,%eax
c0102f14:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102f17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102f1a:	8b 40 04             	mov    0x4(%eax),%eax
c0102f1d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102f20:	8b 12                	mov    (%edx),%edx
c0102f22:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102f25:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102f28:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f2b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102f2e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f31:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f34:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102f37:	89 10                	mov    %edx,(%eax)
			break;
c0102f39:	eb 1c                	jmp    c0102f57 <default_free_pages+0x255>
c0102f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f3e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102f41:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f44:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c0102f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
		}
		le = list_next(le);
	}
	
	le = list_next(&free_list);
	while (le != &free_list) {
c0102f4a:	81 7d f0 d0 89 11 c0 	cmpl   $0xc01189d0,-0x10(%ebp)
c0102f51:	0f 85 6e ff ff ff    	jne    c0102ec5 <default_free_pages+0x1c3>
			list_del(&(p->page_link));
			break;
		}
		le = list_next(le);
	}
	nr_free += n;
c0102f57:	8b 15 d8 89 11 c0    	mov    0xc01189d8,%edx
c0102f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f60:	01 d0                	add    %edx,%eax
c0102f62:	a3 d8 89 11 c0       	mov    %eax,0xc01189d8
c0102f67:	c7 45 a4 d0 89 11 c0 	movl   $0xc01189d0,-0x5c(%ebp)
c0102f6e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f71:	8b 40 04             	mov    0x4(%eax),%eax
	
	le = list_next(&free_list);
c0102f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (le != &free_list)
c0102f77:	eb 6c                	jmp    c0102fe5 <default_free_pages+0x2e3>
	{
		p = le2page(le, page_link);
c0102f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f7c:	83 e8 0c             	sub    $0xc,%eax
c0102f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (base < p)
c0102f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f88:	73 4c                	jae    c0102fd6 <default_free_pages+0x2d4>
		{
			list_add_before(&(p->page_link), &(base->page_link));
c0102f8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f8d:	83 c0 0c             	add    $0xc,%eax
c0102f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102f93:	83 c2 0c             	add    $0xc,%edx
c0102f96:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0102f99:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102f9c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f9f:	8b 00                	mov    (%eax),%eax
c0102fa1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102fa4:	89 55 98             	mov    %edx,-0x68(%ebp)
c0102fa7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102faa:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102fad:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102fb0:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fb3:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102fb6:	89 10                	mov    %edx,(%eax)
c0102fb8:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fbb:	8b 10                	mov    (%eax),%edx
c0102fbd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102fc0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102fc3:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fc6:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102fc9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102fcc:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fcf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102fd2:	89 10                	mov    %edx,(%eax)
			return;
c0102fd4:	eb 75                	jmp    c010304b <default_free_pages+0x349>
c0102fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fd9:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102fdc:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102fdf:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c0102fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		le = list_next(le);
	}
	nr_free += n;
	
	le = list_next(&free_list);
	while (le != &free_list)
c0102fe5:	81 7d f0 d0 89 11 c0 	cmpl   $0xc01189d0,-0x10(%ebp)
c0102fec:	75 8b                	jne    c0102f79 <default_free_pages+0x277>
			list_add_before(&(p->page_link), &(base->page_link));
			return;
		}
		le = list_next(le);
	}	
	list_add_before(&free_list, &(base->page_link));
c0102fee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ff1:	83 c0 0c             	add    $0xc,%eax
c0102ff4:	c7 45 88 d0 89 11 c0 	movl   $0xc01189d0,-0x78(%ebp)
c0102ffb:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102ffe:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103001:	8b 00                	mov    (%eax),%eax
c0103003:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103006:	89 55 80             	mov    %edx,-0x80(%ebp)
c0103009:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010300f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103012:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103018:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010301e:	8b 55 80             	mov    -0x80(%ebp),%edx
c0103021:	89 10                	mov    %edx,(%eax)
c0103023:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103029:	8b 10                	mov    (%eax),%edx
c010302b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103031:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103034:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103037:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c010303d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103040:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103043:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0103049:	89 10                	mov    %edx,(%eax)
}
c010304b:	c9                   	leave  
c010304c:	c3                   	ret    

c010304d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010304d:	55                   	push   %ebp
c010304e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103050:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
}
c0103055:	5d                   	pop    %ebp
c0103056:	c3                   	ret    

c0103057 <basic_check>:

static void
basic_check(void) {
c0103057:	55                   	push   %ebp
c0103058:	89 e5                	mov    %esp,%ebp
c010305a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010305d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103064:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103067:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010306d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103077:	e8 85 0e 00 00       	call   c0103f01 <alloc_pages>
c010307c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010307f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103083:	75 24                	jne    c01030a9 <basic_check+0x52>
c0103085:	c7 44 24 0c 39 69 10 	movl   $0xc0106939,0xc(%esp)
c010308c:	c0 
c010308d:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103094:	c0 
c0103095:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010309c:	00 
c010309d:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01030a4:	e8 22 dc ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030b0:	e8 4c 0e 00 00       	call   c0103f01 <alloc_pages>
c01030b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030bc:	75 24                	jne    c01030e2 <basic_check+0x8b>
c01030be:	c7 44 24 0c 55 69 10 	movl   $0xc0106955,0xc(%esp)
c01030c5:	c0 
c01030c6:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01030cd:	c0 
c01030ce:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01030d5:	00 
c01030d6:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01030dd:	e8 e9 db ff ff       	call   c0100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030e9:	e8 13 0e 00 00       	call   c0103f01 <alloc_pages>
c01030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030f5:	75 24                	jne    c010311b <basic_check+0xc4>
c01030f7:	c7 44 24 0c 71 69 10 	movl   $0xc0106971,0xc(%esp)
c01030fe:	c0 
c01030ff:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103106:	c0 
c0103107:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c010310e:	00 
c010310f:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103116:	e8 b0 db ff ff       	call   c0100ccb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010311b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010311e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103121:	74 10                	je     c0103133 <basic_check+0xdc>
c0103123:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103126:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103129:	74 08                	je     c0103133 <basic_check+0xdc>
c010312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103131:	75 24                	jne    c0103157 <basic_check+0x100>
c0103133:	c7 44 24 0c 90 69 10 	movl   $0xc0106990,0xc(%esp)
c010313a:	c0 
c010313b:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103142:	c0 
c0103143:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010314a:	00 
c010314b:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103152:	e8 74 db ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103157:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010315a:	89 04 24             	mov    %eax,(%esp)
c010315d:	e8 c2 f7 ff ff       	call   c0102924 <page_ref>
c0103162:	85 c0                	test   %eax,%eax
c0103164:	75 1e                	jne    c0103184 <basic_check+0x12d>
c0103166:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103169:	89 04 24             	mov    %eax,(%esp)
c010316c:	e8 b3 f7 ff ff       	call   c0102924 <page_ref>
c0103171:	85 c0                	test   %eax,%eax
c0103173:	75 0f                	jne    c0103184 <basic_check+0x12d>
c0103175:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103178:	89 04 24             	mov    %eax,(%esp)
c010317b:	e8 a4 f7 ff ff       	call   c0102924 <page_ref>
c0103180:	85 c0                	test   %eax,%eax
c0103182:	74 24                	je     c01031a8 <basic_check+0x151>
c0103184:	c7 44 24 0c b4 69 10 	movl   $0xc01069b4,0xc(%esp)
c010318b:	c0 
c010318c:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103193:	c0 
c0103194:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c010319b:	00 
c010319c:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01031a3:	e8 23 db ff ff       	call   c0100ccb <__panic>
	
    assert(page2pa(p0) < npage * PGSIZE);
c01031a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031ab:	89 04 24             	mov    %eax,(%esp)
c01031ae:	e8 5b f7 ff ff       	call   c010290e <page2pa>
c01031b3:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c01031b9:	c1 e2 0c             	shl    $0xc,%edx
c01031bc:	39 d0                	cmp    %edx,%eax
c01031be:	72 24                	jb     c01031e4 <basic_check+0x18d>
c01031c0:	c7 44 24 0c f0 69 10 	movl   $0xc01069f0,0xc(%esp)
c01031c7:	c0 
c01031c8:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01031cf:	c0 
c01031d0:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01031d7:	00 
c01031d8:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01031df:	e8 e7 da ff ff       	call   c0100ccb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e7:	89 04 24             	mov    %eax,(%esp)
c01031ea:	e8 1f f7 ff ff       	call   c010290e <page2pa>
c01031ef:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c01031f5:	c1 e2 0c             	shl    $0xc,%edx
c01031f8:	39 d0                	cmp    %edx,%eax
c01031fa:	72 24                	jb     c0103220 <basic_check+0x1c9>
c01031fc:	c7 44 24 0c 0d 6a 10 	movl   $0xc0106a0d,0xc(%esp)
c0103203:	c0 
c0103204:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010320b:	c0 
c010320c:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103213:	00 
c0103214:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010321b:	e8 ab da ff ff       	call   c0100ccb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103220:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103223:	89 04 24             	mov    %eax,(%esp)
c0103226:	e8 e3 f6 ff ff       	call   c010290e <page2pa>
c010322b:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0103231:	c1 e2 0c             	shl    $0xc,%edx
c0103234:	39 d0                	cmp    %edx,%eax
c0103236:	72 24                	jb     c010325c <basic_check+0x205>
c0103238:	c7 44 24 0c 2a 6a 10 	movl   $0xc0106a2a,0xc(%esp)
c010323f:	c0 
c0103240:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103247:	c0 
c0103248:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010324f:	00 
c0103250:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103257:	e8 6f da ff ff       	call   c0100ccb <__panic>

    list_entry_t free_list_store = free_list;
c010325c:	a1 d0 89 11 c0       	mov    0xc01189d0,%eax
c0103261:	8b 15 d4 89 11 c0    	mov    0xc01189d4,%edx
c0103267:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010326a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010326d:	c7 45 e0 d0 89 11 c0 	movl   $0xc01189d0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103274:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103277:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010327a:	89 50 04             	mov    %edx,0x4(%eax)
c010327d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103280:	8b 50 04             	mov    0x4(%eax),%edx
c0103283:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103286:	89 10                	mov    %edx,(%eax)
c0103288:	c7 45 dc d0 89 11 c0 	movl   $0xc01189d0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010328f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103292:	8b 40 04             	mov    0x4(%eax),%eax
c0103295:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103298:	0f 94 c0             	sete   %al
c010329b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010329e:	85 c0                	test   %eax,%eax
c01032a0:	75 24                	jne    c01032c6 <basic_check+0x26f>
c01032a2:	c7 44 24 0c 47 6a 10 	movl   $0xc0106a47,0xc(%esp)
c01032a9:	c0 
c01032aa:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01032b1:	c0 
c01032b2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01032b9:	00 
c01032ba:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01032c1:	e8 05 da ff ff       	call   c0100ccb <__panic>

    unsigned int nr_free_store = nr_free;
c01032c6:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c01032cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032ce:	c7 05 d8 89 11 c0 00 	movl   $0x0,0xc01189d8
c01032d5:	00 00 00 

    assert(alloc_page() == NULL);
c01032d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032df:	e8 1d 0c 00 00       	call   c0103f01 <alloc_pages>
c01032e4:	85 c0                	test   %eax,%eax
c01032e6:	74 24                	je     c010330c <basic_check+0x2b5>
c01032e8:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01032ef:	c0 
c01032f0:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01032f7:	c0 
c01032f8:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01032ff:	00 
c0103300:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103307:	e8 bf d9 ff ff       	call   c0100ccb <__panic>

    free_page(p0);
c010330c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103313:	00 
c0103314:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103317:	89 04 24             	mov    %eax,(%esp)
c010331a:	e8 1a 0c 00 00       	call   c0103f39 <free_pages>
    free_page(p1);
c010331f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103326:	00 
c0103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010332a:	89 04 24             	mov    %eax,(%esp)
c010332d:	e8 07 0c 00 00       	call   c0103f39 <free_pages>
    free_page(p2);
c0103332:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103339:	00 
c010333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333d:	89 04 24             	mov    %eax,(%esp)
c0103340:	e8 f4 0b 00 00       	call   c0103f39 <free_pages>
    assert(nr_free == 3);
c0103345:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c010334a:	83 f8 03             	cmp    $0x3,%eax
c010334d:	74 24                	je     c0103373 <basic_check+0x31c>
c010334f:	c7 44 24 0c 73 6a 10 	movl   $0xc0106a73,0xc(%esp)
c0103356:	c0 
c0103357:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010335e:	c0 
c010335f:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103366:	00 
c0103367:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010336e:	e8 58 d9 ff ff       	call   c0100ccb <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010337a:	e8 82 0b 00 00       	call   c0103f01 <alloc_pages>
c010337f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103382:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103386:	75 24                	jne    c01033ac <basic_check+0x355>
c0103388:	c7 44 24 0c 39 69 10 	movl   $0xc0106939,0xc(%esp)
c010338f:	c0 
c0103390:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103397:	c0 
c0103398:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010339f:	00 
c01033a0:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01033a7:	e8 1f d9 ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033b3:	e8 49 0b 00 00       	call   c0103f01 <alloc_pages>
c01033b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033bf:	75 24                	jne    c01033e5 <basic_check+0x38e>
c01033c1:	c7 44 24 0c 55 69 10 	movl   $0xc0106955,0xc(%esp)
c01033c8:	c0 
c01033c9:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01033d0:	c0 
c01033d1:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01033d8:	00 
c01033d9:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01033e0:	e8 e6 d8 ff ff       	call   c0100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033ec:	e8 10 0b 00 00       	call   c0103f01 <alloc_pages>
c01033f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033f8:	75 24                	jne    c010341e <basic_check+0x3c7>
c01033fa:	c7 44 24 0c 71 69 10 	movl   $0xc0106971,0xc(%esp)
c0103401:	c0 
c0103402:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103409:	c0 
c010340a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103411:	00 
c0103412:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103419:	e8 ad d8 ff ff       	call   c0100ccb <__panic>

    assert(alloc_page() == NULL);
c010341e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103425:	e8 d7 0a 00 00       	call   c0103f01 <alloc_pages>
c010342a:	85 c0                	test   %eax,%eax
c010342c:	74 24                	je     c0103452 <basic_check+0x3fb>
c010342e:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c0103435:	c0 
c0103436:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010343d:	c0 
c010343e:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0103445:	00 
c0103446:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010344d:	e8 79 d8 ff ff       	call   c0100ccb <__panic>

    free_page(p0);
c0103452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103459:	00 
c010345a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010345d:	89 04 24             	mov    %eax,(%esp)
c0103460:	e8 d4 0a 00 00       	call   c0103f39 <free_pages>
c0103465:	c7 45 d8 d0 89 11 c0 	movl   $0xc01189d0,-0x28(%ebp)
c010346c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010346f:	8b 40 04             	mov    0x4(%eax),%eax
c0103472:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103475:	0f 94 c0             	sete   %al
c0103478:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010347b:	85 c0                	test   %eax,%eax
c010347d:	74 24                	je     c01034a3 <basic_check+0x44c>
c010347f:	c7 44 24 0c 80 6a 10 	movl   $0xc0106a80,0xc(%esp)
c0103486:	c0 
c0103487:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010348e:	c0 
c010348f:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103496:	00 
c0103497:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010349e:	e8 28 d8 ff ff       	call   c0100ccb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034aa:	e8 52 0a 00 00       	call   c0103f01 <alloc_pages>
c01034af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034b8:	74 24                	je     c01034de <basic_check+0x487>
c01034ba:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c01034c1:	c0 
c01034c2:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01034c9:	c0 
c01034ca:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01034d1:	00 
c01034d2:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01034d9:	e8 ed d7 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c01034de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034e5:	e8 17 0a 00 00       	call   c0103f01 <alloc_pages>
c01034ea:	85 c0                	test   %eax,%eax
c01034ec:	74 24                	je     c0103512 <basic_check+0x4bb>
c01034ee:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01034f5:	c0 
c01034f6:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01034fd:	c0 
c01034fe:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103505:	00 
c0103506:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010350d:	e8 b9 d7 ff ff       	call   c0100ccb <__panic>
	
    assert(nr_free == 0);
c0103512:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c0103517:	85 c0                	test   %eax,%eax
c0103519:	74 24                	je     c010353f <basic_check+0x4e8>
c010351b:	c7 44 24 0c b1 6a 10 	movl   $0xc0106ab1,0xc(%esp)
c0103522:	c0 
c0103523:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010352a:	c0 
c010352b:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103532:	00 
c0103533:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010353a:	e8 8c d7 ff ff       	call   c0100ccb <__panic>
    free_list = free_list_store;
c010353f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103545:	a3 d0 89 11 c0       	mov    %eax,0xc01189d0
c010354a:	89 15 d4 89 11 c0    	mov    %edx,0xc01189d4
    nr_free = nr_free_store;
c0103550:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103553:	a3 d8 89 11 c0       	mov    %eax,0xc01189d8

    free_page(p);
c0103558:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010355f:	00 
c0103560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103563:	89 04 24             	mov    %eax,(%esp)
c0103566:	e8 ce 09 00 00       	call   c0103f39 <free_pages>
    free_page(p1);
c010356b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103572:	00 
c0103573:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103576:	89 04 24             	mov    %eax,(%esp)
c0103579:	e8 bb 09 00 00       	call   c0103f39 <free_pages>
    free_page(p2);
c010357e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103585:	00 
c0103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103589:	89 04 24             	mov    %eax,(%esp)
c010358c:	e8 a8 09 00 00       	call   c0103f39 <free_pages>
}
c0103591:	c9                   	leave  
c0103592:	c3                   	ret    

c0103593 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103593:	55                   	push   %ebp
c0103594:	89 e5                	mov    %esp,%ebp
c0103596:	53                   	push   %ebx
c0103597:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010359d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035ab:	c7 45 ec d0 89 11 c0 	movl   $0xc01189d0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035b2:	eb 6b                	jmp    c010361f <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035b7:	83 e8 0c             	sub    $0xc,%eax
c01035ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01035bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035c0:	83 c0 04             	add    $0x4,%eax
c01035c3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035d3:	0f a3 10             	bt     %edx,(%eax)
c01035d6:	19 c0                	sbb    %eax,%eax
c01035d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035df:	0f 95 c0             	setne  %al
c01035e2:	0f b6 c0             	movzbl %al,%eax
c01035e5:	85 c0                	test   %eax,%eax
c01035e7:	75 24                	jne    c010360d <default_check+0x7a>
c01035e9:	c7 44 24 0c be 6a 10 	movl   $0xc0106abe,0xc(%esp)
c01035f0:	c0 
c01035f1:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01035f8:	c0 
c01035f9:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103600:	00 
c0103601:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103608:	e8 be d6 ff ff       	call   c0100ccb <__panic>
        count ++, total += p->property;
c010360d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103611:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103614:	8b 50 08             	mov    0x8(%eax),%edx
c0103617:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010361a:	01 d0                	add    %edx,%eax
c010361c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010361f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103622:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103625:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103628:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010362b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010362e:	81 7d ec d0 89 11 c0 	cmpl   $0xc01189d0,-0x14(%ebp)
c0103635:	0f 85 79 ff ff ff    	jne    c01035b4 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010363b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010363e:	e8 28 09 00 00       	call   c0103f6b <nr_free_pages>
c0103643:	39 c3                	cmp    %eax,%ebx
c0103645:	74 24                	je     c010366b <default_check+0xd8>
c0103647:	c7 44 24 0c ce 6a 10 	movl   $0xc0106ace,0xc(%esp)
c010364e:	c0 
c010364f:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103656:	c0 
c0103657:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010365e:	00 
c010365f:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103666:	e8 60 d6 ff ff       	call   c0100ccb <__panic>

    basic_check();
c010366b:	e8 e7 f9 ff ff       	call   c0103057 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103670:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103677:	e8 85 08 00 00       	call   c0103f01 <alloc_pages>
c010367c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010367f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103683:	75 24                	jne    c01036a9 <default_check+0x116>
c0103685:	c7 44 24 0c e7 6a 10 	movl   $0xc0106ae7,0xc(%esp)
c010368c:	c0 
c010368d:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103694:	c0 
c0103695:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010369c:	00 
c010369d:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01036a4:	e8 22 d6 ff ff       	call   c0100ccb <__panic>
    assert(!PageProperty(p0));
c01036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ac:	83 c0 04             	add    $0x4,%eax
c01036af:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036bc:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036bf:	0f a3 10             	bt     %edx,(%eax)
c01036c2:	19 c0                	sbb    %eax,%eax
c01036c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036c7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036cb:	0f 95 c0             	setne  %al
c01036ce:	0f b6 c0             	movzbl %al,%eax
c01036d1:	85 c0                	test   %eax,%eax
c01036d3:	74 24                	je     c01036f9 <default_check+0x166>
c01036d5:	c7 44 24 0c f2 6a 10 	movl   $0xc0106af2,0xc(%esp)
c01036dc:	c0 
c01036dd:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01036e4:	c0 
c01036e5:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01036ec:	00 
c01036ed:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01036f4:	e8 d2 d5 ff ff       	call   c0100ccb <__panic>

    list_entry_t free_list_store = free_list;
c01036f9:	a1 d0 89 11 c0       	mov    0xc01189d0,%eax
c01036fe:	8b 15 d4 89 11 c0    	mov    0xc01189d4,%edx
c0103704:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103707:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010370a:	c7 45 b4 d0 89 11 c0 	movl   $0xc01189d0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103711:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103714:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103717:	89 50 04             	mov    %edx,0x4(%eax)
c010371a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010371d:	8b 50 04             	mov    0x4(%eax),%edx
c0103720:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103723:	89 10                	mov    %edx,(%eax)
c0103725:	c7 45 b0 d0 89 11 c0 	movl   $0xc01189d0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010372c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010372f:	8b 40 04             	mov    0x4(%eax),%eax
c0103732:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103735:	0f 94 c0             	sete   %al
c0103738:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010373b:	85 c0                	test   %eax,%eax
c010373d:	75 24                	jne    c0103763 <default_check+0x1d0>
c010373f:	c7 44 24 0c 47 6a 10 	movl   $0xc0106a47,0xc(%esp)
c0103746:	c0 
c0103747:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010374e:	c0 
c010374f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103756:	00 
c0103757:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010375e:	e8 68 d5 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c0103763:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010376a:	e8 92 07 00 00       	call   c0103f01 <alloc_pages>
c010376f:	85 c0                	test   %eax,%eax
c0103771:	74 24                	je     c0103797 <default_check+0x204>
c0103773:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c010377a:	c0 
c010377b:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103782:	c0 
c0103783:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010378a:	00 
c010378b:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103792:	e8 34 d5 ff ff       	call   c0100ccb <__panic>

    unsigned int nr_free_store = nr_free;
c0103797:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c010379c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010379f:	c7 05 d8 89 11 c0 00 	movl   $0x0,0xc01189d8
c01037a6:	00 00 00 

    free_pages(p0 + 2, 3);
c01037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ac:	83 c0 28             	add    $0x28,%eax
c01037af:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037b6:	00 
c01037b7:	89 04 24             	mov    %eax,(%esp)
c01037ba:	e8 7a 07 00 00       	call   c0103f39 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037bf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037c6:	e8 36 07 00 00       	call   c0103f01 <alloc_pages>
c01037cb:	85 c0                	test   %eax,%eax
c01037cd:	74 24                	je     c01037f3 <default_check+0x260>
c01037cf:	c7 44 24 0c 04 6b 10 	movl   $0xc0106b04,0xc(%esp)
c01037d6:	c0 
c01037d7:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01037de:	c0 
c01037df:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01037e6:	00 
c01037e7:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01037ee:	e8 d8 d4 ff ff       	call   c0100ccb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037f6:	83 c0 28             	add    $0x28,%eax
c01037f9:	83 c0 04             	add    $0x4,%eax
c01037fc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103803:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103806:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103809:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010380c:	0f a3 10             	bt     %edx,(%eax)
c010380f:	19 c0                	sbb    %eax,%eax
c0103811:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103814:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103818:	0f 95 c0             	setne  %al
c010381b:	0f b6 c0             	movzbl %al,%eax
c010381e:	85 c0                	test   %eax,%eax
c0103820:	74 0e                	je     c0103830 <default_check+0x29d>
c0103822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103825:	83 c0 28             	add    $0x28,%eax
c0103828:	8b 40 08             	mov    0x8(%eax),%eax
c010382b:	83 f8 03             	cmp    $0x3,%eax
c010382e:	74 24                	je     c0103854 <default_check+0x2c1>
c0103830:	c7 44 24 0c 1c 6b 10 	movl   $0xc0106b1c,0xc(%esp)
c0103837:	c0 
c0103838:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c010383f:	c0 
c0103840:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103847:	00 
c0103848:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c010384f:	e8 77 d4 ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103854:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010385b:	e8 a1 06 00 00       	call   c0103f01 <alloc_pages>
c0103860:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103863:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103867:	75 24                	jne    c010388d <default_check+0x2fa>
c0103869:	c7 44 24 0c 48 6b 10 	movl   $0xc0106b48,0xc(%esp)
c0103870:	c0 
c0103871:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103878:	c0 
c0103879:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103880:	00 
c0103881:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103888:	e8 3e d4 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c010388d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103894:	e8 68 06 00 00       	call   c0103f01 <alloc_pages>
c0103899:	85 c0                	test   %eax,%eax
c010389b:	74 24                	je     c01038c1 <default_check+0x32e>
c010389d:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01038a4:	c0 
c01038a5:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01038ac:	c0 
c01038ad:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01038b4:	00 
c01038b5:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01038bc:	e8 0a d4 ff ff       	call   c0100ccb <__panic>
    assert(p0 + 2 == p1);
c01038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038c4:	83 c0 28             	add    $0x28,%eax
c01038c7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01038ca:	74 24                	je     c01038f0 <default_check+0x35d>
c01038cc:	c7 44 24 0c 66 6b 10 	movl   $0xc0106b66,0xc(%esp)
c01038d3:	c0 
c01038d4:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01038db:	c0 
c01038dc:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01038e3:	00 
c01038e4:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01038eb:	e8 db d3 ff ff       	call   c0100ccb <__panic>

    p2 = p0 + 1;
c01038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038f3:	83 c0 14             	add    $0x14,%eax
c01038f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01038f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103900:	00 
c0103901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103904:	89 04 24             	mov    %eax,(%esp)
c0103907:	e8 2d 06 00 00       	call   c0103f39 <free_pages>
    free_pages(p1, 3);
c010390c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103913:	00 
c0103914:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103917:	89 04 24             	mov    %eax,(%esp)
c010391a:	e8 1a 06 00 00       	call   c0103f39 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103922:	83 c0 04             	add    $0x4,%eax
c0103925:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010392c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010392f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103932:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103935:	0f a3 10             	bt     %edx,(%eax)
c0103938:	19 c0                	sbb    %eax,%eax
c010393a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010393d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103941:	0f 95 c0             	setne  %al
c0103944:	0f b6 c0             	movzbl %al,%eax
c0103947:	85 c0                	test   %eax,%eax
c0103949:	74 0b                	je     c0103956 <default_check+0x3c3>
c010394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010394e:	8b 40 08             	mov    0x8(%eax),%eax
c0103951:	83 f8 01             	cmp    $0x1,%eax
c0103954:	74 24                	je     c010397a <default_check+0x3e7>
c0103956:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c010395d:	c0 
c010395e:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103965:	c0 
c0103966:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010396d:	00 
c010396e:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103975:	e8 51 d3 ff ff       	call   c0100ccb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010397d:	83 c0 04             	add    $0x4,%eax
c0103980:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103987:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010398a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010398d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103990:	0f a3 10             	bt     %edx,(%eax)
c0103993:	19 c0                	sbb    %eax,%eax
c0103995:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103998:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010399c:	0f 95 c0             	setne  %al
c010399f:	0f b6 c0             	movzbl %al,%eax
c01039a2:	85 c0                	test   %eax,%eax
c01039a4:	74 0b                	je     c01039b1 <default_check+0x41e>
c01039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039a9:	8b 40 08             	mov    0x8(%eax),%eax
c01039ac:	83 f8 03             	cmp    $0x3,%eax
c01039af:	74 24                	je     c01039d5 <default_check+0x442>
c01039b1:	c7 44 24 0c 9c 6b 10 	movl   $0xc0106b9c,0xc(%esp)
c01039b8:	c0 
c01039b9:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01039c0:	c0 
c01039c1:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01039c8:	00 
c01039c9:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c01039d0:	e8 f6 d2 ff ff       	call   c0100ccb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039dc:	e8 20 05 00 00       	call   c0103f01 <alloc_pages>
c01039e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039e7:	83 e8 14             	sub    $0x14,%eax
c01039ea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01039ed:	74 24                	je     c0103a13 <default_check+0x480>
c01039ef:	c7 44 24 0c c2 6b 10 	movl   $0xc0106bc2,0xc(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c01039fe:	c0 
c01039ff:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103a06:	00 
c0103a07:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103a0e:	e8 b8 d2 ff ff       	call   c0100ccb <__panic>
    free_page(p0);
c0103a13:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a1a:	00 
c0103a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a1e:	89 04 24             	mov    %eax,(%esp)
c0103a21:	e8 13 05 00 00       	call   c0103f39 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a26:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a2d:	e8 cf 04 00 00       	call   c0103f01 <alloc_pages>
c0103a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a35:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a38:	83 c0 14             	add    $0x14,%eax
c0103a3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a3e:	74 24                	je     c0103a64 <default_check+0x4d1>
c0103a40:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c0103a47:	c0 
c0103a48:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103a4f:	c0 
c0103a50:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0103a57:	00 
c0103a58:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103a5f:	e8 67 d2 ff ff       	call   c0100ccb <__panic>

    free_pages(p0, 2);
c0103a64:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a6b:	00 
c0103a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a6f:	89 04 24             	mov    %eax,(%esp)
c0103a72:	e8 c2 04 00 00       	call   c0103f39 <free_pages>
    free_page(p2);
c0103a77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a7e:	00 
c0103a7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a82:	89 04 24             	mov    %eax,(%esp)
c0103a85:	e8 af 04 00 00       	call   c0103f39 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a8a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a91:	e8 6b 04 00 00       	call   c0103f01 <alloc_pages>
c0103a96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103a9d:	75 24                	jne    c0103ac3 <default_check+0x530>
c0103a9f:	c7 44 24 0c 00 6c 10 	movl   $0xc0106c00,0xc(%esp)
c0103aa6:	c0 
c0103aa7:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103ab6:	00 
c0103ab7:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103abe:	e8 08 d2 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c0103ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aca:	e8 32 04 00 00       	call   c0103f01 <alloc_pages>
c0103acf:	85 c0                	test   %eax,%eax
c0103ad1:	74 24                	je     c0103af7 <default_check+0x564>
c0103ad3:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c0103ada:	c0 
c0103adb:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103ae2:	c0 
c0103ae3:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103aea:	00 
c0103aeb:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103af2:	e8 d4 d1 ff ff       	call   c0100ccb <__panic>

    assert(nr_free == 0);
c0103af7:	a1 d8 89 11 c0       	mov    0xc01189d8,%eax
c0103afc:	85 c0                	test   %eax,%eax
c0103afe:	74 24                	je     c0103b24 <default_check+0x591>
c0103b00:	c7 44 24 0c b1 6a 10 	movl   $0xc0106ab1,0xc(%esp)
c0103b07:	c0 
c0103b08:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103b0f:	c0 
c0103b10:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0103b17:	00 
c0103b18:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103b1f:	e8 a7 d1 ff ff       	call   c0100ccb <__panic>
    nr_free = nr_free_store;
c0103b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b27:	a3 d8 89 11 c0       	mov    %eax,0xc01189d8

    free_list = free_list_store;
c0103b2c:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b2f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b32:	a3 d0 89 11 c0       	mov    %eax,0xc01189d0
c0103b37:	89 15 d4 89 11 c0    	mov    %edx,0xc01189d4
    free_pages(p0, 5);
c0103b3d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b44:	00 
c0103b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b48:	89 04 24             	mov    %eax,(%esp)
c0103b4b:	e8 e9 03 00 00       	call   c0103f39 <free_pages>

    le = &free_list;
c0103b50:	c7 45 ec d0 89 11 c0 	movl   $0xc01189d0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b57:	eb 1d                	jmp    c0103b76 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b5c:	83 e8 0c             	sub    $0xc,%eax
c0103b5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103b62:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b6c:	8b 40 08             	mov    0x8(%eax),%eax
c0103b6f:	29 c2                	sub    %eax,%edx
c0103b71:	89 d0                	mov    %edx,%eax
c0103b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b79:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103b7c:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b7f:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b85:	81 7d ec d0 89 11 c0 	cmpl   $0xc01189d0,-0x14(%ebp)
c0103b8c:	75 cb                	jne    c0103b59 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103b8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b92:	74 24                	je     c0103bb8 <default_check+0x625>
c0103b94:	c7 44 24 0c 1e 6c 10 	movl   $0xc0106c1e,0xc(%esp)
c0103b9b:	c0 
c0103b9c:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103ba3:	c0 
c0103ba4:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0103bab:	00 
c0103bac:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103bb3:	e8 13 d1 ff ff       	call   c0100ccb <__panic>
    assert(total == 0);
c0103bb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bbc:	74 24                	je     c0103be2 <default_check+0x64f>
c0103bbe:	c7 44 24 0c 29 6c 10 	movl   $0xc0106c29,0xc(%esp)
c0103bc5:	c0 
c0103bc6:	c7 44 24 08 d6 68 10 	movl   $0xc01068d6,0x8(%esp)
c0103bcd:	c0 
c0103bce:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103bd5:	00 
c0103bd6:	c7 04 24 eb 68 10 c0 	movl   $0xc01068eb,(%esp)
c0103bdd:	e8 e9 d0 ff ff       	call   c0100ccb <__panic>
}
c0103be2:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103be8:	5b                   	pop    %ebx
c0103be9:	5d                   	pop    %ebp
c0103bea:	c3                   	ret    

c0103beb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103beb:	55                   	push   %ebp
c0103bec:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103bee:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bf1:	a1 e4 89 11 c0       	mov    0xc01189e4,%eax
c0103bf6:	29 c2                	sub    %eax,%edx
c0103bf8:	89 d0                	mov    %edx,%eax
c0103bfa:	c1 f8 02             	sar    $0x2,%eax
c0103bfd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c03:	5d                   	pop    %ebp
c0103c04:	c3                   	ret    

c0103c05 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103c05:	55                   	push   %ebp
c0103c06:	89 e5                	mov    %esp,%ebp
c0103c08:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0e:	89 04 24             	mov    %eax,(%esp)
c0103c11:	e8 d5 ff ff ff       	call   c0103beb <page2ppn>
c0103c16:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c19:	c9                   	leave  
c0103c1a:	c3                   	ret    

c0103c1b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103c1b:	55                   	push   %ebp
c0103c1c:	89 e5                	mov    %esp,%ebp
c0103c1e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c24:	c1 e8 0c             	shr    $0xc,%eax
c0103c27:	89 c2                	mov    %eax,%edx
c0103c29:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103c2e:	39 c2                	cmp    %eax,%edx
c0103c30:	72 1c                	jb     c0103c4e <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c32:	c7 44 24 08 64 6c 10 	movl   $0xc0106c64,0x8(%esp)
c0103c39:	c0 
c0103c3a:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c41:	00 
c0103c42:	c7 04 24 83 6c 10 c0 	movl   $0xc0106c83,(%esp)
c0103c49:	e8 7d d0 ff ff       	call   c0100ccb <__panic>
    }
    return &pages[PPN(pa)];
c0103c4e:	8b 0d e4 89 11 c0    	mov    0xc01189e4,%ecx
c0103c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c57:	c1 e8 0c             	shr    $0xc,%eax
c0103c5a:	89 c2                	mov    %eax,%edx
c0103c5c:	89 d0                	mov    %edx,%eax
c0103c5e:	c1 e0 02             	shl    $0x2,%eax
c0103c61:	01 d0                	add    %edx,%eax
c0103c63:	c1 e0 02             	shl    $0x2,%eax
c0103c66:	01 c8                	add    %ecx,%eax
}
c0103c68:	c9                   	leave  
c0103c69:	c3                   	ret    

c0103c6a <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103c6a:	55                   	push   %ebp
c0103c6b:	89 e5                	mov    %esp,%ebp
c0103c6d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c73:	89 04 24             	mov    %eax,(%esp)
c0103c76:	e8 8a ff ff ff       	call   c0103c05 <page2pa>
c0103c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c81:	c1 e8 0c             	shr    $0xc,%eax
c0103c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c87:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103c8c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c8f:	72 23                	jb     c0103cb4 <page2kva+0x4a>
c0103c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c94:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c98:	c7 44 24 08 94 6c 10 	movl   $0xc0106c94,0x8(%esp)
c0103c9f:	c0 
c0103ca0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ca7:	00 
c0103ca8:	c7 04 24 83 6c 10 c0 	movl   $0xc0106c83,(%esp)
c0103caf:	e8 17 d0 ff ff       	call   c0100ccb <__panic>
c0103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cbc:	c9                   	leave  
c0103cbd:	c3                   	ret    

c0103cbe <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103cbe:	55                   	push   %ebp
c0103cbf:	89 e5                	mov    %esp,%ebp
c0103cc1:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc7:	83 e0 01             	and    $0x1,%eax
c0103cca:	85 c0                	test   %eax,%eax
c0103ccc:	75 1c                	jne    c0103cea <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103cce:	c7 44 24 08 b8 6c 10 	movl   $0xc0106cb8,0x8(%esp)
c0103cd5:	c0 
c0103cd6:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cdd:	00 
c0103cde:	c7 04 24 83 6c 10 c0 	movl   $0xc0106c83,(%esp)
c0103ce5:	e8 e1 cf ff ff       	call   c0100ccb <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cf2:	89 04 24             	mov    %eax,(%esp)
c0103cf5:	e8 21 ff ff ff       	call   c0103c1b <pa2page>
}
c0103cfa:	c9                   	leave  
c0103cfb:	c3                   	ret    

c0103cfc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103cfc:	55                   	push   %ebp
c0103cfd:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d02:	8b 00                	mov    (%eax),%eax
}
c0103d04:	5d                   	pop    %ebp
c0103d05:	c3                   	ret    

c0103d06 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103d06:	55                   	push   %ebp
c0103d07:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0f:	89 10                	mov    %edx,(%eax)
}
c0103d11:	5d                   	pop    %ebp
c0103d12:	c3                   	ret    

c0103d13 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d13:	55                   	push   %ebp
c0103d14:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d19:	8b 00                	mov    (%eax),%eax
c0103d1b:	8d 50 01             	lea    0x1(%eax),%edx
c0103d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d21:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d26:	8b 00                	mov    (%eax),%eax
}
c0103d28:	5d                   	pop    %ebp
c0103d29:	c3                   	ret    

c0103d2a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d2a:	55                   	push   %ebp
c0103d2b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d30:	8b 00                	mov    (%eax),%eax
c0103d32:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d38:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3d:	8b 00                	mov    (%eax),%eax
}
c0103d3f:	5d                   	pop    %ebp
c0103d40:	c3                   	ret    

c0103d41 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103d41:	55                   	push   %ebp
c0103d42:	89 e5                	mov    %esp,%ebp
c0103d44:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d47:	9c                   	pushf  
c0103d48:	58                   	pop    %eax
c0103d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d4f:	25 00 02 00 00       	and    $0x200,%eax
c0103d54:	85 c0                	test   %eax,%eax
c0103d56:	74 0c                	je     c0103d64 <__intr_save+0x23>
        intr_disable();
c0103d58:	e8 51 d9 ff ff       	call   c01016ae <intr_disable>
        return 1;
c0103d5d:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d62:	eb 05                	jmp    c0103d69 <__intr_save+0x28>
    }
    return 0;
c0103d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d69:	c9                   	leave  
c0103d6a:	c3                   	ret    

c0103d6b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103d6b:	55                   	push   %ebp
c0103d6c:	89 e5                	mov    %esp,%ebp
c0103d6e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d75:	74 05                	je     c0103d7c <__intr_restore+0x11>
        intr_enable();
c0103d77:	e8 2c d9 ff ff       	call   c01016a8 <intr_enable>
    }
}
c0103d7c:	c9                   	leave  
c0103d7d:	c3                   	ret    

c0103d7e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d7e:	55                   	push   %ebp
c0103d7f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d84:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d87:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d8c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103d8e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d93:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103d95:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d9a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103d9c:	b8 10 00 00 00       	mov    $0x10,%eax
c0103da1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103da3:	b8 10 00 00 00       	mov    $0x10,%eax
c0103da8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103daa:	ea b1 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103db1
}
c0103db1:	5d                   	pop    %ebp
c0103db2:	c3                   	ret    

c0103db3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103db3:	55                   	push   %ebp
c0103db4:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db9:	a3 04 89 11 c0       	mov    %eax,0xc0118904
}
c0103dbe:	5d                   	pop    %ebp
c0103dbf:	c3                   	ret    

c0103dc0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103dc0:	55                   	push   %ebp
c0103dc1:	89 e5                	mov    %esp,%ebp
c0103dc3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103dc6:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103dcb:	89 04 24             	mov    %eax,(%esp)
c0103dce:	e8 e0 ff ff ff       	call   c0103db3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103dd3:	66 c7 05 08 89 11 c0 	movw   $0x10,0xc0118908
c0103dda:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103ddc:	66 c7 05 48 7a 11 c0 	movw   $0x68,0xc0117a48
c0103de3:	68 00 
c0103de5:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103dea:	66 a3 4a 7a 11 c0    	mov    %ax,0xc0117a4a
c0103df0:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103df5:	c1 e8 10             	shr    $0x10,%eax
c0103df8:	a2 4c 7a 11 c0       	mov    %al,0xc0117a4c
c0103dfd:	0f b6 05 4d 7a 11 c0 	movzbl 0xc0117a4d,%eax
c0103e04:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e07:	83 c8 09             	or     $0x9,%eax
c0103e0a:	a2 4d 7a 11 c0       	mov    %al,0xc0117a4d
c0103e0f:	0f b6 05 4d 7a 11 c0 	movzbl 0xc0117a4d,%eax
c0103e16:	83 e0 ef             	and    $0xffffffef,%eax
c0103e19:	a2 4d 7a 11 c0       	mov    %al,0xc0117a4d
c0103e1e:	0f b6 05 4d 7a 11 c0 	movzbl 0xc0117a4d,%eax
c0103e25:	83 e0 9f             	and    $0xffffff9f,%eax
c0103e28:	a2 4d 7a 11 c0       	mov    %al,0xc0117a4d
c0103e2d:	0f b6 05 4d 7a 11 c0 	movzbl 0xc0117a4d,%eax
c0103e34:	83 c8 80             	or     $0xffffff80,%eax
c0103e37:	a2 4d 7a 11 c0       	mov    %al,0xc0117a4d
c0103e3c:	0f b6 05 4e 7a 11 c0 	movzbl 0xc0117a4e,%eax
c0103e43:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e46:	a2 4e 7a 11 c0       	mov    %al,0xc0117a4e
c0103e4b:	0f b6 05 4e 7a 11 c0 	movzbl 0xc0117a4e,%eax
c0103e52:	83 e0 ef             	and    $0xffffffef,%eax
c0103e55:	a2 4e 7a 11 c0       	mov    %al,0xc0117a4e
c0103e5a:	0f b6 05 4e 7a 11 c0 	movzbl 0xc0117a4e,%eax
c0103e61:	83 e0 df             	and    $0xffffffdf,%eax
c0103e64:	a2 4e 7a 11 c0       	mov    %al,0xc0117a4e
c0103e69:	0f b6 05 4e 7a 11 c0 	movzbl 0xc0117a4e,%eax
c0103e70:	83 c8 40             	or     $0x40,%eax
c0103e73:	a2 4e 7a 11 c0       	mov    %al,0xc0117a4e
c0103e78:	0f b6 05 4e 7a 11 c0 	movzbl 0xc0117a4e,%eax
c0103e7f:	83 e0 7f             	and    $0x7f,%eax
c0103e82:	a2 4e 7a 11 c0       	mov    %al,0xc0117a4e
c0103e87:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103e8c:	c1 e8 18             	shr    $0x18,%eax
c0103e8f:	a2 4f 7a 11 c0       	mov    %al,0xc0117a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103e94:	c7 04 24 50 7a 11 c0 	movl   $0xc0117a50,(%esp)
c0103e9b:	e8 de fe ff ff       	call   c0103d7e <lgdt>
c0103ea0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ea6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103eaa:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103ead:	c9                   	leave  
c0103eae:	c3                   	ret    

c0103eaf <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103eaf:	55                   	push   %ebp
c0103eb0:	89 e5                	mov    %esp,%ebp
c0103eb2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103eb5:	c7 05 dc 89 11 c0 48 	movl   $0xc0106c48,0xc01189dc
c0103ebc:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ebf:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103ec4:	8b 00                	mov    (%eax),%eax
c0103ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103eca:	c7 04 24 e4 6c 10 c0 	movl   $0xc0106ce4,(%esp)
c0103ed1:	e8 66 c4 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103ed6:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103edb:	8b 40 04             	mov    0x4(%eax),%eax
c0103ede:	ff d0                	call   *%eax
}
c0103ee0:	c9                   	leave  
c0103ee1:	c3                   	ret    

c0103ee2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ee2:	55                   	push   %ebp
c0103ee3:	89 e5                	mov    %esp,%ebp
c0103ee5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ee8:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103eed:	8b 40 08             	mov    0x8(%eax),%eax
c0103ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ef3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ef7:	8b 55 08             	mov    0x8(%ebp),%edx
c0103efa:	89 14 24             	mov    %edx,(%esp)
c0103efd:	ff d0                	call   *%eax
}
c0103eff:	c9                   	leave  
c0103f00:	c3                   	ret    

c0103f01 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f01:	55                   	push   %ebp
c0103f02:	89 e5                	mov    %esp,%ebp
c0103f04:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f0e:	e8 2e fe ff ff       	call   c0103d41 <__intr_save>
c0103f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f16:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103f1b:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f21:	89 14 24             	mov    %edx,(%esp)
c0103f24:	ff d0                	call   *%eax
c0103f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f2c:	89 04 24             	mov    %eax,(%esp)
c0103f2f:	e8 37 fe ff ff       	call   c0103d6b <__intr_restore>
    return page;
c0103f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f37:	c9                   	leave  
c0103f38:	c3                   	ret    

c0103f39 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f39:	55                   	push   %ebp
c0103f3a:	89 e5                	mov    %esp,%ebp
c0103f3c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f3f:	e8 fd fd ff ff       	call   c0103d41 <__intr_save>
c0103f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f47:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103f4c:	8b 40 10             	mov    0x10(%eax),%eax
c0103f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f52:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f56:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f59:	89 14 24             	mov    %edx,(%esp)
c0103f5c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f61:	89 04 24             	mov    %eax,(%esp)
c0103f64:	e8 02 fe ff ff       	call   c0103d6b <__intr_restore>
}
c0103f69:	c9                   	leave  
c0103f6a:	c3                   	ret    

c0103f6b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f6b:	55                   	push   %ebp
c0103f6c:	89 e5                	mov    %esp,%ebp
c0103f6e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f71:	e8 cb fd ff ff       	call   c0103d41 <__intr_save>
c0103f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f79:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0103f7e:	8b 40 14             	mov    0x14(%eax),%eax
c0103f81:	ff d0                	call   *%eax
c0103f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f89:	89 04 24             	mov    %eax,(%esp)
c0103f8c:	e8 da fd ff ff       	call   c0103d6b <__intr_restore>
    return ret;
c0103f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103f94:	c9                   	leave  
c0103f95:	c3                   	ret    

c0103f96 <page_init>:

/* pmm_init - initialize the physical memory management */
/* 虚拟地址比物理地址偏移KERNBASE。存在变量中的地址值为物理地址，但变量本身的地址要减偏移才为物理地址，因为这程序本身运行时是在虚拟地址中的。*/
static void
page_init(void) {
c0103f96:	55                   	push   %ebp
c0103f97:	89 e5                	mov    %esp,%ebp
c0103f99:	57                   	push   %edi
c0103f9a:	56                   	push   %esi
c0103f9b:	53                   	push   %ebx
c0103f9c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103fa2:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103fa9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103fb7:	c7 04 24 fb 6c 10 c0 	movl   $0xc0106cfb,(%esp)
c0103fbe:	e8 79 c3 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fca:	e9 15 01 00 00       	jmp    c01040e4 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fcf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fd2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fd5:	89 d0                	mov    %edx,%eax
c0103fd7:	c1 e0 02             	shl    $0x2,%eax
c0103fda:	01 d0                	add    %edx,%eax
c0103fdc:	c1 e0 02             	shl    $0x2,%eax
c0103fdf:	01 c8                	add    %ecx,%eax
c0103fe1:	8b 50 08             	mov    0x8(%eax),%edx
c0103fe4:	8b 40 04             	mov    0x4(%eax),%eax
c0103fe7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103fea:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ff3:	89 d0                	mov    %edx,%eax
c0103ff5:	c1 e0 02             	shl    $0x2,%eax
c0103ff8:	01 d0                	add    %edx,%eax
c0103ffa:	c1 e0 02             	shl    $0x2,%eax
c0103ffd:	01 c8                	add    %ecx,%eax
c0103fff:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104002:	8b 58 10             	mov    0x10(%eax),%ebx
c0104005:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104008:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010400b:	01 c8                	add    %ecx,%eax
c010400d:	11 da                	adc    %ebx,%edx
c010400f:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104012:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104015:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104018:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010401b:	89 d0                	mov    %edx,%eax
c010401d:	c1 e0 02             	shl    $0x2,%eax
c0104020:	01 d0                	add    %edx,%eax
c0104022:	c1 e0 02             	shl    $0x2,%eax
c0104025:	01 c8                	add    %ecx,%eax
c0104027:	83 c0 14             	add    $0x14,%eax
c010402a:	8b 00                	mov    (%eax),%eax
c010402c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104032:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104035:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104038:	83 c0 ff             	add    $0xffffffff,%eax
c010403b:	83 d2 ff             	adc    $0xffffffff,%edx
c010403e:	89 c6                	mov    %eax,%esi
c0104040:	89 d7                	mov    %edx,%edi
c0104042:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104045:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104048:	89 d0                	mov    %edx,%eax
c010404a:	c1 e0 02             	shl    $0x2,%eax
c010404d:	01 d0                	add    %edx,%eax
c010404f:	c1 e0 02             	shl    $0x2,%eax
c0104052:	01 c8                	add    %ecx,%eax
c0104054:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104057:	8b 58 10             	mov    0x10(%eax),%ebx
c010405a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104060:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104064:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104068:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010406c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010406f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104072:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104076:	89 54 24 10          	mov    %edx,0x10(%esp)
c010407a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010407e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104082:	c7 04 24 08 6d 10 c0 	movl   $0xc0106d08,(%esp)
c0104089:	e8 ae c2 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010408e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104091:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104094:	89 d0                	mov    %edx,%eax
c0104096:	c1 e0 02             	shl    $0x2,%eax
c0104099:	01 d0                	add    %edx,%eax
c010409b:	c1 e0 02             	shl    $0x2,%eax
c010409e:	01 c8                	add    %ecx,%eax
c01040a0:	83 c0 14             	add    $0x14,%eax
c01040a3:	8b 00                	mov    (%eax),%eax
c01040a5:	83 f8 01             	cmp    $0x1,%eax
c01040a8:	75 36                	jne    c01040e0 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01040aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040b0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040b3:	77 2b                	ja     c01040e0 <page_init+0x14a>
c01040b5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01040b8:	72 05                	jb     c01040bf <page_init+0x129>
c01040ba:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01040bd:	73 21                	jae    c01040e0 <page_init+0x14a>
c01040bf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040c3:	77 1b                	ja     c01040e0 <page_init+0x14a>
c01040c5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01040c9:	72 09                	jb     c01040d4 <page_init+0x13e>
c01040cb:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01040d2:	77 0c                	ja     c01040e0 <page_init+0x14a>
                maxpa = end;
c01040d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040da:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01040e0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040e7:	8b 00                	mov    (%eax),%eax
c01040e9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040ec:	0f 8f dd fe ff ff    	jg     c0103fcf <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01040f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040f6:	72 1d                	jb     c0104115 <page_init+0x17f>
c01040f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040fc:	77 09                	ja     c0104107 <page_init+0x171>
c01040fe:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104105:	76 0e                	jbe    c0104115 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104107:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010410e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }
	/*end为ucore加载的地址末尾*/
    extern char end[];

	/*pages ~ pages + (sizeof(Page))*npage 用来存页记录*/
    npage = maxpa / PGSIZE;
c0104115:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010411b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010411f:	c1 ea 0c             	shr    $0xc,%edx
c0104122:	a3 e0 88 11 c0       	mov    %eax,0xc01188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104127:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010412e:	b8 e8 89 11 c0       	mov    $0xc01189e8,%eax
c0104133:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104136:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104139:	01 d0                	add    %edx,%eax
c010413b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010413e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104141:	ba 00 00 00 00       	mov    $0x0,%edx
c0104146:	f7 75 ac             	divl   -0x54(%ebp)
c0104149:	89 d0                	mov    %edx,%eax
c010414b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010414e:	29 c2                	sub    %eax,%edx
c0104150:	89 d0                	mov    %edx,%eax
c0104152:	a3 e4 89 11 c0       	mov    %eax,0xc01189e4

	/*先全标为reserved*/
    for (i = 0; i < npage; i ++) {
c0104157:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010415e:	eb 2f                	jmp    c010418f <page_init+0x1f9>
        SetPageReserved(pages + i);
c0104160:	8b 0d e4 89 11 c0    	mov    0xc01189e4,%ecx
c0104166:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104169:	89 d0                	mov    %edx,%eax
c010416b:	c1 e0 02             	shl    $0x2,%eax
c010416e:	01 d0                	add    %edx,%eax
c0104170:	c1 e0 02             	shl    $0x2,%eax
c0104173:	01 c8                	add    %ecx,%eax
c0104175:	83 c0 04             	add    $0x4,%eax
c0104178:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010417f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104182:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104185:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104188:	0f ab 10             	bts    %edx,(%eax)
	/*pages ~ pages + (sizeof(Page))*npage 用来存页记录*/
    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

	/*先全标为reserved*/
    for (i = 0; i < npage; i ++) {
c010418b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010418f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104192:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104197:	39 c2                	cmp    %eax,%edx
c0104199:	72 c5                	jb     c0104160 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }
	
	/*free memory从存页记录的末尾开始*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010419b:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c01041a1:	89 d0                	mov    %edx,%eax
c01041a3:	c1 e0 02             	shl    $0x2,%eax
c01041a6:	01 d0                	add    %edx,%eax
c01041a8:	c1 e0 02             	shl    $0x2,%eax
c01041ab:	89 c2                	mov    %eax,%edx
c01041ad:	a1 e4 89 11 c0       	mov    0xc01189e4,%eax
c01041b2:	01 d0                	add    %edx,%eax
c01041b4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01041b7:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01041be:	77 23                	ja     c01041e3 <page_init+0x24d>
c01041c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041c7:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01041ce:	c0 
c01041cf:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c01041d6:	00 
c01041d7:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01041de:	e8 e8 ca ff ff       	call   c0100ccb <__panic>
c01041e3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041e6:	05 00 00 00 40       	add    $0x40000000,%eax
c01041eb:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*对实际空闲的内存块，reserved,free位均标0，完成初始化*/
    for (i = 0; i < memmap->nr_map; i ++) {
c01041ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041f5:	e9 74 01 00 00       	jmp    c010436e <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01041fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104200:	89 d0                	mov    %edx,%eax
c0104202:	c1 e0 02             	shl    $0x2,%eax
c0104205:	01 d0                	add    %edx,%eax
c0104207:	c1 e0 02             	shl    $0x2,%eax
c010420a:	01 c8                	add    %ecx,%eax
c010420c:	8b 50 08             	mov    0x8(%eax),%edx
c010420f:	8b 40 04             	mov    0x4(%eax),%eax
c0104212:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104215:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104218:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010421b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010421e:	89 d0                	mov    %edx,%eax
c0104220:	c1 e0 02             	shl    $0x2,%eax
c0104223:	01 d0                	add    %edx,%eax
c0104225:	c1 e0 02             	shl    $0x2,%eax
c0104228:	01 c8                	add    %ecx,%eax
c010422a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010422d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104230:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104233:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104236:	01 c8                	add    %ecx,%eax
c0104238:	11 da                	adc    %ebx,%edx
c010423a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010423d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104240:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104243:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104246:	89 d0                	mov    %edx,%eax
c0104248:	c1 e0 02             	shl    $0x2,%eax
c010424b:	01 d0                	add    %edx,%eax
c010424d:	c1 e0 02             	shl    $0x2,%eax
c0104250:	01 c8                	add    %ecx,%eax
c0104252:	83 c0 14             	add    $0x14,%eax
c0104255:	8b 00                	mov    (%eax),%eax
c0104257:	83 f8 01             	cmp    $0x1,%eax
c010425a:	0f 85 0a 01 00 00    	jne    c010436a <page_init+0x3d4>
            if (begin < freemem) {
c0104260:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104263:	ba 00 00 00 00       	mov    $0x0,%edx
c0104268:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010426b:	72 17                	jb     c0104284 <page_init+0x2ee>
c010426d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104270:	77 05                	ja     c0104277 <page_init+0x2e1>
c0104272:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104275:	76 0d                	jbe    c0104284 <page_init+0x2ee>
                begin = freemem;
c0104277:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010427a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010427d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104284:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104288:	72 1d                	jb     c01042a7 <page_init+0x311>
c010428a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010428e:	77 09                	ja     c0104299 <page_init+0x303>
c0104290:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104297:	76 0e                	jbe    c01042a7 <page_init+0x311>
                end = KMEMSIZE;
c0104299:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042a0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042ad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042b0:	0f 87 b4 00 00 00    	ja     c010436a <page_init+0x3d4>
c01042b6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042b9:	72 09                	jb     c01042c4 <page_init+0x32e>
c01042bb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042be:	0f 83 a6 00 00 00    	jae    c010436a <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01042c4:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01042cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042ce:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042d1:	01 d0                	add    %edx,%eax
c01042d3:	83 e8 01             	sub    $0x1,%eax
c01042d6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01042d9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01042dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01042e1:	f7 75 9c             	divl   -0x64(%ebp)
c01042e4:	89 d0                	mov    %edx,%eax
c01042e6:	8b 55 98             	mov    -0x68(%ebp),%edx
c01042e9:	29 c2                	sub    %eax,%edx
c01042eb:	89 d0                	mov    %edx,%eax
c01042ed:	ba 00 00 00 00       	mov    $0x0,%edx
c01042f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01042f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042fb:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01042fe:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104301:	ba 00 00 00 00       	mov    $0x0,%edx
c0104306:	89 c7                	mov    %eax,%edi
c0104308:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010430e:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104311:	89 d0                	mov    %edx,%eax
c0104313:	83 e0 00             	and    $0x0,%eax
c0104316:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104319:	8b 45 80             	mov    -0x80(%ebp),%eax
c010431c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010431f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104322:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104325:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104328:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010432b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010432e:	77 3a                	ja     c010436a <page_init+0x3d4>
c0104330:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104333:	72 05                	jb     c010433a <page_init+0x3a4>
c0104335:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104338:	73 30                	jae    c010436a <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE); /*pa2page():从内存地址找所在页的页记录的位置*/
c010433a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010433d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104340:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104343:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104346:	29 c8                	sub    %ecx,%eax
c0104348:	19 da                	sbb    %ebx,%edx
c010434a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010434e:	c1 ea 0c             	shr    $0xc,%edx
c0104351:	89 c3                	mov    %eax,%ebx
c0104353:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104356:	89 04 24             	mov    %eax,(%esp)
c0104359:	e8 bd f8 ff ff       	call   c0103c1b <pa2page>
c010435e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104362:	89 04 24             	mov    %eax,(%esp)
c0104365:	e8 78 fb ff ff       	call   c0103ee2 <init_memmap>
	
	/*free memory从存页记录的末尾开始*/
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

	/*对实际空闲的内存块，reserved,free位均标0，完成初始化*/
    for (i = 0; i < memmap->nr_map; i ++) {
c010436a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010436e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104371:	8b 00                	mov    (%eax),%eax
c0104373:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104376:	0f 8f 7e fe ff ff    	jg     c01041fa <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE); /*pa2page():从内存地址找所在页的页记录的位置*/
                }
            }
        }
    }
}
c010437c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104382:	5b                   	pop    %ebx
c0104383:	5e                   	pop    %esi
c0104384:	5f                   	pop    %edi
c0104385:	5d                   	pop    %ebp
c0104386:	c3                   	ret    

c0104387 <enable_paging>:

static void
enable_paging(void) {
c0104387:	55                   	push   %ebp
c0104388:	89 e5                	mov    %esp,%ebp
c010438a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010438d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104392:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104395:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104398:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010439b:	0f 20 c0             	mov    %cr0,%eax
c010439e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01043a1:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01043a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01043a7:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01043ae:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01043b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01043b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01043b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043bb:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01043be:	c9                   	leave  
c01043bf:	c3                   	ret    

c01043c0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043c0:	55                   	push   %ebp
c01043c1:	89 e5                	mov    %esp,%ebp
c01043c3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01043c9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043cc:	31 d0                	xor    %edx,%eax
c01043ce:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043d3:	85 c0                	test   %eax,%eax
c01043d5:	74 24                	je     c01043fb <boot_map_segment+0x3b>
c01043d7:	c7 44 24 0c 6a 6d 10 	movl   $0xc0106d6a,0xc(%esp)
c01043de:	c0 
c01043df:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c01043e6:	c0 
c01043e7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01043ee:	00 
c01043ef:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01043f6:	e8 d0 c8 ff ff       	call   c0100ccb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104402:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104405:	25 ff 0f 00 00       	and    $0xfff,%eax
c010440a:	89 c2                	mov    %eax,%edx
c010440c:	8b 45 10             	mov    0x10(%ebp),%eax
c010440f:	01 c2                	add    %eax,%edx
c0104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104414:	01 d0                	add    %edx,%eax
c0104416:	83 e8 01             	sub    $0x1,%eax
c0104419:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010441c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010441f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104424:	f7 75 f0             	divl   -0x10(%ebp)
c0104427:	89 d0                	mov    %edx,%eax
c0104429:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010442c:	29 c2                	sub    %eax,%edx
c010442e:	89 d0                	mov    %edx,%eax
c0104430:	c1 e8 0c             	shr    $0xc,%eax
c0104433:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104439:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010443c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010443f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104444:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104447:	8b 45 14             	mov    0x14(%ebp),%eax
c010444a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010444d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104455:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104458:	eb 6b                	jmp    c01044c5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010445a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104461:	00 
c0104462:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104465:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104469:	8b 45 08             	mov    0x8(%ebp),%eax
c010446c:	89 04 24             	mov    %eax,(%esp)
c010446f:	e8 cc 01 00 00       	call   c0104640 <get_pte>
c0104474:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010447b:	75 24                	jne    c01044a1 <boot_map_segment+0xe1>
c010447d:	c7 44 24 0c 96 6d 10 	movl   $0xc0106d96,0xc(%esp)
c0104484:	c0 
c0104485:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c010448c:	c0 
c010448d:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0104494:	00 
c0104495:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010449c:	e8 2a c8 ff ff       	call   c0100ccb <__panic>
        *ptep = pa | PTE_P | perm;
c01044a1:	8b 45 18             	mov    0x18(%ebp),%eax
c01044a4:	8b 55 14             	mov    0x14(%ebp),%edx
c01044a7:	09 d0                	or     %edx,%eax
c01044a9:	83 c8 01             	or     $0x1,%eax
c01044ac:	89 c2                	mov    %eax,%edx
c01044ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044b1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01044b7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044be:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044c9:	75 8f                	jne    c010445a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01044cb:	c9                   	leave  
c01044cc:	c3                   	ret    

c01044cd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044cd:	55                   	push   %ebp
c01044ce:	89 e5                	mov    %esp,%ebp
c01044d0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044da:	e8 22 fa ff ff       	call   c0103f01 <alloc_pages>
c01044df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044e6:	75 1c                	jne    c0104504 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044e8:	c7 44 24 08 a3 6d 10 	movl   $0xc0106da3,0x8(%esp)
c01044ef:	c0 
c01044f0:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01044f7:	00 
c01044f8:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01044ff:	e8 c7 c7 ff ff       	call   c0100ccb <__panic>
    }
    return page2kva(p);
c0104504:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104507:	89 04 24             	mov    %eax,(%esp)
c010450a:	e8 5b f7 ff ff       	call   c0103c6a <page2kva>
}
c010450f:	c9                   	leave  
c0104510:	c3                   	ret    

c0104511 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104511:	55                   	push   %ebp
c0104512:	89 e5                	mov    %esp,%ebp
c0104514:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104517:	e8 93 f9 ff ff       	call   c0103eaf <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010451c:	e8 75 fa ff ff       	call   c0103f96 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104521:	e8 66 04 00 00       	call   c010498c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104526:	e8 a2 ff ff ff       	call   c01044cd <boot_alloc_page>
c010452b:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
    memset(boot_pgdir, 0, PGSIZE);
c0104530:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104535:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010453c:	00 
c010453d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104544:	00 
c0104545:	89 04 24             	mov    %eax,(%esp)
c0104548:	e8 a8 1a 00 00       	call   c0105ff5 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010454d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104552:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104555:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010455c:	77 23                	ja     c0104581 <pmm_init+0x70>
c010455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104561:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104565:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010456c:	c0 
c010456d:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0104574:	00 
c0104575:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010457c:	e8 4a c7 ff ff       	call   c0100ccb <__panic>
c0104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104584:	05 00 00 00 40       	add    $0x40000000,%eax
c0104589:	a3 e0 89 11 c0       	mov    %eax,0xc01189e0

    check_pgdir();
c010458e:	e8 17 04 00 00       	call   c01049aa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104593:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104598:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010459e:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01045a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045a6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01045ad:	77 23                	ja     c01045d2 <pmm_init+0xc1>
c01045af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045b6:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c01045bd:	c0 
c01045be:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c01045c5:	00 
c01045c6:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01045cd:	e8 f9 c6 ff ff       	call   c0100ccb <__panic>
c01045d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d5:	05 00 00 00 40       	add    $0x40000000,%eax
c01045da:	83 c8 03             	or     $0x3,%eax
c01045dd:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045df:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01045e4:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045eb:	00 
c01045ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045f3:	00 
c01045f4:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045fb:	38 
c01045fc:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104603:	c0 
c0104604:	89 04 24             	mov    %eax,(%esp)
c0104607:	e8 b4 fd ff ff       	call   c01043c0 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010460c:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104611:	8b 15 e4 88 11 c0    	mov    0xc01188e4,%edx
c0104617:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010461d:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010461f:	e8 63 fd ff ff       	call   c0104387 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104624:	e8 97 f7 ff ff       	call   c0103dc0 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104629:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010462e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104634:	e8 0c 0a 00 00       	call   c0105045 <check_boot_pgdir>

    print_pgdir();
c0104639:	e8 99 0e 00 00       	call   c01054d7 <print_pgdir>

}
c010463e:	c9                   	leave  
c010463f:	c3                   	ret    

c0104640 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104640:	55                   	push   %ebp
c0104641:	89 e5                	mov    %esp,%ebp
c0104643:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104649:	c1 e8 16             	shr    $0x16,%eax
c010464c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104653:	8b 45 08             	mov    0x8(%ebp),%eax
c0104656:	01 d0                	add    %edx,%eax
c0104658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010465b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010465e:	8b 00                	mov    (%eax),%eax
c0104660:	83 e0 01             	and    $0x1,%eax
c0104663:	85 c0                	test   %eax,%eax
c0104665:	0f 85 af 00 00 00    	jne    c010471a <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c010466b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010466f:	74 15                	je     c0104686 <get_pte+0x46>
c0104671:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104678:	e8 84 f8 ff ff       	call   c0103f01 <alloc_pages>
c010467d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104680:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104684:	75 0a                	jne    c0104690 <get_pte+0x50>
            return NULL;
c0104686:	b8 00 00 00 00       	mov    $0x0,%eax
c010468b:	e9 e6 00 00 00       	jmp    c0104776 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0104690:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104697:	00 
c0104698:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469b:	89 04 24             	mov    %eax,(%esp)
c010469e:	e8 63 f6 ff ff       	call   c0103d06 <set_page_ref>
        uintptr_t pa = page2pa(page);
c01046a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a6:	89 04 24             	mov    %eax,(%esp)
c01046a9:	e8 57 f5 ff ff       	call   c0103c05 <page2pa>
c01046ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01046b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01046b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046ba:	c1 e8 0c             	shr    $0xc,%eax
c01046bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046c0:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01046c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01046c8:	72 23                	jb     c01046ed <get_pte+0xad>
c01046ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046d1:	c7 44 24 08 94 6c 10 	movl   $0xc0106c94,0x8(%esp)
c01046d8:	c0 
c01046d9:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c01046e0:	00 
c01046e1:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01046e8:	e8 de c5 ff ff       	call   c0100ccb <__panic>
c01046ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046f0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046fc:	00 
c01046fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104704:	00 
c0104705:	89 04 24             	mov    %eax,(%esp)
c0104708:	e8 e8 18 00 00       	call   c0105ff5 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010470d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104710:	83 c8 07             	or     $0x7,%eax
c0104713:	89 c2                	mov    %eax,%edx
c0104715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104718:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471d:	8b 00                	mov    (%eax),%eax
c010471f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104724:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104727:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010472a:	c1 e8 0c             	shr    $0xc,%eax
c010472d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104730:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104735:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104738:	72 23                	jb     c010475d <get_pte+0x11d>
c010473a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010473d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104741:	c7 44 24 08 94 6c 10 	movl   $0xc0106c94,0x8(%esp)
c0104748:	c0 
c0104749:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
c0104750:	00 
c0104751:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104758:	e8 6e c5 ff ff       	call   c0100ccb <__panic>
c010475d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104760:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104765:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104768:	c1 ea 0c             	shr    $0xc,%edx
c010476b:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104771:	c1 e2 02             	shl    $0x2,%edx
c0104774:	01 d0                	add    %edx,%eax
}
c0104776:	c9                   	leave  
c0104777:	c3                   	ret    

c0104778 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104778:	55                   	push   %ebp
c0104779:	89 e5                	mov    %esp,%ebp
c010477b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010477e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104785:	00 
c0104786:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104789:	89 44 24 04          	mov    %eax,0x4(%esp)
c010478d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104790:	89 04 24             	mov    %eax,(%esp)
c0104793:	e8 a8 fe ff ff       	call   c0104640 <get_pte>
c0104798:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010479b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010479f:	74 08                	je     c01047a9 <get_page+0x31>
        *ptep_store = ptep;
c01047a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01047a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047a7:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01047a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047ad:	74 1b                	je     c01047ca <get_page+0x52>
c01047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b2:	8b 00                	mov    (%eax),%eax
c01047b4:	83 e0 01             	and    $0x1,%eax
c01047b7:	85 c0                	test   %eax,%eax
c01047b9:	74 0f                	je     c01047ca <get_page+0x52>
        return pa2page(*ptep);
c01047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047be:	8b 00                	mov    (%eax),%eax
c01047c0:	89 04 24             	mov    %eax,(%esp)
c01047c3:	e8 53 f4 ff ff       	call   c0103c1b <pa2page>
c01047c8:	eb 05                	jmp    c01047cf <get_page+0x57>
    }
    return NULL;
c01047ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047cf:	c9                   	leave  
c01047d0:	c3                   	ret    

c01047d1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01047d1:	55                   	push   %ebp
c01047d2:	89 e5                	mov    %esp,%ebp
c01047d4:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01047d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01047da:	8b 00                	mov    (%eax),%eax
c01047dc:	83 e0 01             	and    $0x1,%eax
c01047df:	85 c0                	test   %eax,%eax
c01047e1:	74 4d                	je     c0104830 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01047e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01047e6:	8b 00                	mov    (%eax),%eax
c01047e8:	89 04 24             	mov    %eax,(%esp)
c01047eb:	e8 ce f4 ff ff       	call   c0103cbe <pte2page>
c01047f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c01047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f6:	89 04 24             	mov    %eax,(%esp)
c01047f9:	e8 2c f5 ff ff       	call   c0103d2a <page_ref_dec>
c01047fe:	85 c0                	test   %eax,%eax
c0104800:	75 13                	jne    c0104815 <page_remove_pte+0x44>
            free_page(page);
c0104802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104809:	00 
c010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480d:	89 04 24             	mov    %eax,(%esp)
c0104810:	e8 24 f7 ff ff       	call   c0103f39 <free_pages>
        }
        *ptep = 0;
c0104815:	8b 45 10             	mov    0x10(%ebp),%eax
c0104818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010481e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104821:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104825:	8b 45 08             	mov    0x8(%ebp),%eax
c0104828:	89 04 24             	mov    %eax,(%esp)
c010482b:	e8 ff 00 00 00       	call   c010492f <tlb_invalidate>
    }
}
c0104830:	c9                   	leave  
c0104831:	c3                   	ret    

c0104832 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104832:	55                   	push   %ebp
c0104833:	89 e5                	mov    %esp,%ebp
c0104835:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104838:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010483f:	00 
c0104840:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104843:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104847:	8b 45 08             	mov    0x8(%ebp),%eax
c010484a:	89 04 24             	mov    %eax,(%esp)
c010484d:	e8 ee fd ff ff       	call   c0104640 <get_pte>
c0104852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104859:	74 19                	je     c0104874 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104862:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104865:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104869:	8b 45 08             	mov    0x8(%ebp),%eax
c010486c:	89 04 24             	mov    %eax,(%esp)
c010486f:	e8 5d ff ff ff       	call   c01047d1 <page_remove_pte>
    }
}
c0104874:	c9                   	leave  
c0104875:	c3                   	ret    

c0104876 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104876:	55                   	push   %ebp
c0104877:	89 e5                	mov    %esp,%ebp
c0104879:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010487c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104883:	00 
c0104884:	8b 45 10             	mov    0x10(%ebp),%eax
c0104887:	89 44 24 04          	mov    %eax,0x4(%esp)
c010488b:	8b 45 08             	mov    0x8(%ebp),%eax
c010488e:	89 04 24             	mov    %eax,(%esp)
c0104891:	e8 aa fd ff ff       	call   c0104640 <get_pte>
c0104896:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010489d:	75 0a                	jne    c01048a9 <page_insert+0x33>
        return -E_NO_MEM;
c010489f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01048a4:	e9 84 00 00 00       	jmp    c010492d <page_insert+0xb7>
    }
    page_ref_inc(page);
c01048a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048ac:	89 04 24             	mov    %eax,(%esp)
c01048af:	e8 5f f4 ff ff       	call   c0103d13 <page_ref_inc>
    if (*ptep & PTE_P) {
c01048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b7:	8b 00                	mov    (%eax),%eax
c01048b9:	83 e0 01             	and    $0x1,%eax
c01048bc:	85 c0                	test   %eax,%eax
c01048be:	74 3e                	je     c01048fe <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01048c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c3:	8b 00                	mov    (%eax),%eax
c01048c5:	89 04 24             	mov    %eax,(%esp)
c01048c8:	e8 f1 f3 ff ff       	call   c0103cbe <pte2page>
c01048cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01048d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01048d6:	75 0d                	jne    c01048e5 <page_insert+0x6f>
            page_ref_dec(page);
c01048d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048db:	89 04 24             	mov    %eax,(%esp)
c01048de:	e8 47 f4 ff ff       	call   c0103d2a <page_ref_dec>
c01048e3:	eb 19                	jmp    c01048fe <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01048ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f6:	89 04 24             	mov    %eax,(%esp)
c01048f9:	e8 d3 fe ff ff       	call   c01047d1 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01048fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104901:	89 04 24             	mov    %eax,(%esp)
c0104904:	e8 fc f2 ff ff       	call   c0103c05 <page2pa>
c0104909:	0b 45 14             	or     0x14(%ebp),%eax
c010490c:	83 c8 01             	or     $0x1,%eax
c010490f:	89 c2                	mov    %eax,%edx
c0104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104914:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104916:	8b 45 10             	mov    0x10(%ebp),%eax
c0104919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010491d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104920:	89 04 24             	mov    %eax,(%esp)
c0104923:	e8 07 00 00 00       	call   c010492f <tlb_invalidate>
    return 0;
c0104928:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010492d:	c9                   	leave  
c010492e:	c3                   	ret    

c010492f <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010492f:	55                   	push   %ebp
c0104930:	89 e5                	mov    %esp,%ebp
c0104932:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104935:	0f 20 d8             	mov    %cr3,%eax
c0104938:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010493e:	89 c2                	mov    %eax,%edx
c0104940:	8b 45 08             	mov    0x8(%ebp),%eax
c0104943:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104946:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010494d:	77 23                	ja     c0104972 <tlb_invalidate+0x43>
c010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104952:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104956:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c010495d:	c0 
c010495e:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104965:	00 
c0104966:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010496d:	e8 59 c3 ff ff       	call   c0100ccb <__panic>
c0104972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104975:	05 00 00 00 40       	add    $0x40000000,%eax
c010497a:	39 c2                	cmp    %eax,%edx
c010497c:	75 0c                	jne    c010498a <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010497e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104981:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104984:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104987:	0f 01 38             	invlpg (%eax)
    }
}
c010498a:	c9                   	leave  
c010498b:	c3                   	ret    

c010498c <check_alloc_page>:

static void
check_alloc_page(void) {
c010498c:	55                   	push   %ebp
c010498d:	89 e5                	mov    %esp,%ebp
c010498f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104992:	a1 dc 89 11 c0       	mov    0xc01189dc,%eax
c0104997:	8b 40 18             	mov    0x18(%eax),%eax
c010499a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010499c:	c7 04 24 bc 6d 10 c0 	movl   $0xc0106dbc,(%esp)
c01049a3:	e8 94 b9 ff ff       	call   c010033c <cprintf>
}
c01049a8:	c9                   	leave  
c01049a9:	c3                   	ret    

c01049aa <check_pgdir>:

static void
check_pgdir(void) {
c01049aa:	55                   	push   %ebp
c01049ab:	89 e5                	mov    %esp,%ebp
c01049ad:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01049b0:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01049b5:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01049ba:	76 24                	jbe    c01049e0 <check_pgdir+0x36>
c01049bc:	c7 44 24 0c db 6d 10 	movl   $0xc0106ddb,0xc(%esp)
c01049c3:	c0 
c01049c4:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c01049cb:	c0 
c01049cc:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01049d3:	00 
c01049d4:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01049db:	e8 eb c2 ff ff       	call   c0100ccb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01049e0:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01049e5:	85 c0                	test   %eax,%eax
c01049e7:	74 0e                	je     c01049f7 <check_pgdir+0x4d>
c01049e9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01049ee:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049f3:	85 c0                	test   %eax,%eax
c01049f5:	74 24                	je     c0104a1b <check_pgdir+0x71>
c01049f7:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c01049fe:	c0 
c01049ff:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104a06:	c0 
c0104a07:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104a0e:	00 
c0104a0f:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104a16:	e8 b0 c2 ff ff       	call   c0100ccb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104a1b:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a27:	00 
c0104a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a2f:	00 
c0104a30:	89 04 24             	mov    %eax,(%esp)
c0104a33:	e8 40 fd ff ff       	call   c0104778 <get_page>
c0104a38:	85 c0                	test   %eax,%eax
c0104a3a:	74 24                	je     c0104a60 <check_pgdir+0xb6>
c0104a3c:	c7 44 24 0c 30 6e 10 	movl   $0xc0106e30,0xc(%esp)
c0104a43:	c0 
c0104a44:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104a4b:	c0 
c0104a4c:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104a53:	00 
c0104a54:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104a5b:	e8 6b c2 ff ff       	call   c0100ccb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a67:	e8 95 f4 ff ff       	call   c0103f01 <alloc_pages>
c0104a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a6f:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a7b:	00 
c0104a7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a83:	00 
c0104a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a87:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a8b:	89 04 24             	mov    %eax,(%esp)
c0104a8e:	e8 e3 fd ff ff       	call   c0104876 <page_insert>
c0104a93:	85 c0                	test   %eax,%eax
c0104a95:	74 24                	je     c0104abb <check_pgdir+0x111>
c0104a97:	c7 44 24 0c 58 6e 10 	movl   $0xc0106e58,0xc(%esp)
c0104a9e:	c0 
c0104a9f:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104aa6:	c0 
c0104aa7:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104aae:	00 
c0104aaf:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104ab6:	e8 10 c2 ff ff       	call   c0100ccb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104abb:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104ac0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ac7:	00 
c0104ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104acf:	00 
c0104ad0:	89 04 24             	mov    %eax,(%esp)
c0104ad3:	e8 68 fb ff ff       	call   c0104640 <get_pte>
c0104ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104adf:	75 24                	jne    c0104b05 <check_pgdir+0x15b>
c0104ae1:	c7 44 24 0c 84 6e 10 	movl   $0xc0106e84,0xc(%esp)
c0104ae8:	c0 
c0104ae9:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104af0:	c0 
c0104af1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104af8:	00 
c0104af9:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104b00:	e8 c6 c1 ff ff       	call   c0100ccb <__panic>
    assert(pa2page(*ptep) == p1);
c0104b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b08:	8b 00                	mov    (%eax),%eax
c0104b0a:	89 04 24             	mov    %eax,(%esp)
c0104b0d:	e8 09 f1 ff ff       	call   c0103c1b <pa2page>
c0104b12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b15:	74 24                	je     c0104b3b <check_pgdir+0x191>
c0104b17:	c7 44 24 0c b1 6e 10 	movl   $0xc0106eb1,0xc(%esp)
c0104b1e:	c0 
c0104b1f:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104b26:	c0 
c0104b27:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104b2e:	00 
c0104b2f:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104b36:	e8 90 c1 ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p1) == 1);
c0104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3e:	89 04 24             	mov    %eax,(%esp)
c0104b41:	e8 b6 f1 ff ff       	call   c0103cfc <page_ref>
c0104b46:	83 f8 01             	cmp    $0x1,%eax
c0104b49:	74 24                	je     c0104b6f <check_pgdir+0x1c5>
c0104b4b:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c0104b52:	c0 
c0104b53:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104b5a:	c0 
c0104b5b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b62:	00 
c0104b63:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104b6a:	e8 5c c1 ff ff       	call   c0100ccb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b6f:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104b74:	8b 00                	mov    (%eax),%eax
c0104b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b81:	c1 e8 0c             	shr    $0xc,%eax
c0104b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b87:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104b8c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b8f:	72 23                	jb     c0104bb4 <check_pgdir+0x20a>
c0104b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b94:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b98:	c7 44 24 08 94 6c 10 	movl   $0xc0106c94,0x8(%esp)
c0104b9f:	c0 
c0104ba0:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104ba7:	00 
c0104ba8:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104baf:	e8 17 c1 ff ff       	call   c0100ccb <__panic>
c0104bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104bbc:	83 c0 04             	add    $0x4,%eax
c0104bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104bc2:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104bc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bce:	00 
c0104bcf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bd6:	00 
c0104bd7:	89 04 24             	mov    %eax,(%esp)
c0104bda:	e8 61 fa ff ff       	call   c0104640 <get_pte>
c0104bdf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104be2:	74 24                	je     c0104c08 <check_pgdir+0x25e>
c0104be4:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104beb:	c0 
c0104bec:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104bf3:	c0 
c0104bf4:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104bfb:	00 
c0104bfc:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104c03:	e8 c3 c0 ff ff       	call   c0100ccb <__panic>

    p2 = alloc_page();
c0104c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c0f:	e8 ed f2 ff ff       	call   c0103f01 <alloc_pages>
c0104c14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104c17:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c1c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104c23:	00 
c0104c24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c2b:	00 
c0104c2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c33:	89 04 24             	mov    %eax,(%esp)
c0104c36:	e8 3b fc ff ff       	call   c0104876 <page_insert>
c0104c3b:	85 c0                	test   %eax,%eax
c0104c3d:	74 24                	je     c0104c63 <check_pgdir+0x2b9>
c0104c3f:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104c46:	c0 
c0104c47:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104c4e:	c0 
c0104c4f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104c56:	00 
c0104c57:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104c5e:	e8 68 c0 ff ff       	call   c0100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c63:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c68:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c6f:	00 
c0104c70:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c77:	00 
c0104c78:	89 04 24             	mov    %eax,(%esp)
c0104c7b:	e8 c0 f9 ff ff       	call   c0104640 <get_pte>
c0104c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c87:	75 24                	jne    c0104cad <check_pgdir+0x303>
c0104c89:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0104c90:	c0 
c0104c91:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104c98:	c0 
c0104c99:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104ca0:	00 
c0104ca1:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104ca8:	e8 1e c0 ff ff       	call   c0100ccb <__panic>
    assert(*ptep & PTE_U);
c0104cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb0:	8b 00                	mov    (%eax),%eax
c0104cb2:	83 e0 04             	and    $0x4,%eax
c0104cb5:	85 c0                	test   %eax,%eax
c0104cb7:	75 24                	jne    c0104cdd <check_pgdir+0x333>
c0104cb9:	c7 44 24 0c 68 6f 10 	movl   $0xc0106f68,0xc(%esp)
c0104cc0:	c0 
c0104cc1:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104cc8:	c0 
c0104cc9:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104cd0:	00 
c0104cd1:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104cd8:	e8 ee bf ff ff       	call   c0100ccb <__panic>
    assert(*ptep & PTE_W);
c0104cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ce0:	8b 00                	mov    (%eax),%eax
c0104ce2:	83 e0 02             	and    $0x2,%eax
c0104ce5:	85 c0                	test   %eax,%eax
c0104ce7:	75 24                	jne    c0104d0d <check_pgdir+0x363>
c0104ce9:	c7 44 24 0c 76 6f 10 	movl   $0xc0106f76,0xc(%esp)
c0104cf0:	c0 
c0104cf1:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104d00:	00 
c0104d01:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104d08:	e8 be bf ff ff       	call   c0100ccb <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104d0d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d12:	8b 00                	mov    (%eax),%eax
c0104d14:	83 e0 04             	and    $0x4,%eax
c0104d17:	85 c0                	test   %eax,%eax
c0104d19:	75 24                	jne    c0104d3f <check_pgdir+0x395>
c0104d1b:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0104d22:	c0 
c0104d23:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104d2a:	c0 
c0104d2b:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104d32:	00 
c0104d33:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104d3a:	e8 8c bf ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 1);
c0104d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d42:	89 04 24             	mov    %eax,(%esp)
c0104d45:	e8 b2 ef ff ff       	call   c0103cfc <page_ref>
c0104d4a:	83 f8 01             	cmp    $0x1,%eax
c0104d4d:	74 24                	je     c0104d73 <check_pgdir+0x3c9>
c0104d4f:	c7 44 24 0c 9a 6f 10 	movl   $0xc0106f9a,0xc(%esp)
c0104d56:	c0 
c0104d57:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104d66:	00 
c0104d67:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104d6e:	e8 58 bf ff ff       	call   c0100ccb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d73:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d78:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d7f:	00 
c0104d80:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d87:	00 
c0104d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d8f:	89 04 24             	mov    %eax,(%esp)
c0104d92:	e8 df fa ff ff       	call   c0104876 <page_insert>
c0104d97:	85 c0                	test   %eax,%eax
c0104d99:	74 24                	je     c0104dbf <check_pgdir+0x415>
c0104d9b:	c7 44 24 0c ac 6f 10 	movl   $0xc0106fac,0xc(%esp)
c0104da2:	c0 
c0104da3:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104daa:	c0 
c0104dab:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104db2:	00 
c0104db3:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104dba:	e8 0c bf ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p1) == 2);
c0104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc2:	89 04 24             	mov    %eax,(%esp)
c0104dc5:	e8 32 ef ff ff       	call   c0103cfc <page_ref>
c0104dca:	83 f8 02             	cmp    $0x2,%eax
c0104dcd:	74 24                	je     c0104df3 <check_pgdir+0x449>
c0104dcf:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c0104dd6:	c0 
c0104dd7:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104dde:	c0 
c0104ddf:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104de6:	00 
c0104de7:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104dee:	e8 d8 be ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df6:	89 04 24             	mov    %eax,(%esp)
c0104df9:	e8 fe ee ff ff       	call   c0103cfc <page_ref>
c0104dfe:	85 c0                	test   %eax,%eax
c0104e00:	74 24                	je     c0104e26 <check_pgdir+0x47c>
c0104e02:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104e09:	c0 
c0104e0a:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104e11:	c0 
c0104e12:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104e19:	00 
c0104e1a:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104e21:	e8 a5 be ff ff       	call   c0100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104e26:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e32:	00 
c0104e33:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e3a:	00 
c0104e3b:	89 04 24             	mov    %eax,(%esp)
c0104e3e:	e8 fd f7 ff ff       	call   c0104640 <get_pte>
c0104e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e4a:	75 24                	jne    c0104e70 <check_pgdir+0x4c6>
c0104e4c:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0104e53:	c0 
c0104e54:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104e5b:	c0 
c0104e5c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104e63:	00 
c0104e64:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104e6b:	e8 5b be ff ff       	call   c0100ccb <__panic>
    assert(pa2page(*ptep) == p1);
c0104e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e73:	8b 00                	mov    (%eax),%eax
c0104e75:	89 04 24             	mov    %eax,(%esp)
c0104e78:	e8 9e ed ff ff       	call   c0103c1b <pa2page>
c0104e7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e80:	74 24                	je     c0104ea6 <check_pgdir+0x4fc>
c0104e82:	c7 44 24 0c b1 6e 10 	movl   $0xc0106eb1,0xc(%esp)
c0104e89:	c0 
c0104e8a:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104e91:	c0 
c0104e92:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104e99:	00 
c0104e9a:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104ea1:	e8 25 be ff ff       	call   c0100ccb <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ea9:	8b 00                	mov    (%eax),%eax
c0104eab:	83 e0 04             	and    $0x4,%eax
c0104eae:	85 c0                	test   %eax,%eax
c0104eb0:	74 24                	je     c0104ed6 <check_pgdir+0x52c>
c0104eb2:	c7 44 24 0c fc 6f 10 	movl   $0xc0106ffc,0xc(%esp)
c0104eb9:	c0 
c0104eba:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104ec1:	c0 
c0104ec2:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104ec9:	00 
c0104eca:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104ed1:	e8 f5 bd ff ff       	call   c0100ccb <__panic>

    page_remove(boot_pgdir, 0x0);
c0104ed6:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ee2:	00 
c0104ee3:	89 04 24             	mov    %eax,(%esp)
c0104ee6:	e8 47 f9 ff ff       	call   c0104832 <page_remove>
    assert(page_ref(p1) == 1);
c0104eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eee:	89 04 24             	mov    %eax,(%esp)
c0104ef1:	e8 06 ee ff ff       	call   c0103cfc <page_ref>
c0104ef6:	83 f8 01             	cmp    $0x1,%eax
c0104ef9:	74 24                	je     c0104f1f <check_pgdir+0x575>
c0104efb:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c0104f02:	c0 
c0104f03:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104f0a:	c0 
c0104f0b:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104f12:	00 
c0104f13:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104f1a:	e8 ac bd ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f22:	89 04 24             	mov    %eax,(%esp)
c0104f25:	e8 d2 ed ff ff       	call   c0103cfc <page_ref>
c0104f2a:	85 c0                	test   %eax,%eax
c0104f2c:	74 24                	je     c0104f52 <check_pgdir+0x5a8>
c0104f2e:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104f35:	c0 
c0104f36:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104f3d:	c0 
c0104f3e:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104f45:	00 
c0104f46:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104f4d:	e8 79 bd ff ff       	call   c0100ccb <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104f52:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104f57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f5e:	00 
c0104f5f:	89 04 24             	mov    %eax,(%esp)
c0104f62:	e8 cb f8 ff ff       	call   c0104832 <page_remove>
    assert(page_ref(p1) == 0);
c0104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f6a:	89 04 24             	mov    %eax,(%esp)
c0104f6d:	e8 8a ed ff ff       	call   c0103cfc <page_ref>
c0104f72:	85 c0                	test   %eax,%eax
c0104f74:	74 24                	je     c0104f9a <check_pgdir+0x5f0>
c0104f76:	c7 44 24 0c 11 70 10 	movl   $0xc0107011,0xc(%esp)
c0104f7d:	c0 
c0104f7e:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104f85:	c0 
c0104f86:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104f8d:	00 
c0104f8e:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104f95:	e8 31 bd ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f9d:	89 04 24             	mov    %eax,(%esp)
c0104fa0:	e8 57 ed ff ff       	call   c0103cfc <page_ref>
c0104fa5:	85 c0                	test   %eax,%eax
c0104fa7:	74 24                	je     c0104fcd <check_pgdir+0x623>
c0104fa9:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104fb0:	c0 
c0104fb1:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104fb8:	c0 
c0104fb9:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104fc0:	00 
c0104fc1:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0104fc8:	e8 fe bc ff ff       	call   c0100ccb <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104fcd:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104fd2:	8b 00                	mov    (%eax),%eax
c0104fd4:	89 04 24             	mov    %eax,(%esp)
c0104fd7:	e8 3f ec ff ff       	call   c0103c1b <pa2page>
c0104fdc:	89 04 24             	mov    %eax,(%esp)
c0104fdf:	e8 18 ed ff ff       	call   c0103cfc <page_ref>
c0104fe4:	83 f8 01             	cmp    $0x1,%eax
c0104fe7:	74 24                	je     c010500d <check_pgdir+0x663>
c0104fe9:	c7 44 24 0c 24 70 10 	movl   $0xc0107024,0xc(%esp)
c0104ff0:	c0 
c0104ff1:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0104ff8:	c0 
c0104ff9:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105000:	00 
c0105001:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0105008:	e8 be bc ff ff       	call   c0100ccb <__panic>
    free_page(pa2page(boot_pgdir[0]));
c010500d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105012:	8b 00                	mov    (%eax),%eax
c0105014:	89 04 24             	mov    %eax,(%esp)
c0105017:	e8 ff eb ff ff       	call   c0103c1b <pa2page>
c010501c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105023:	00 
c0105024:	89 04 24             	mov    %eax,(%esp)
c0105027:	e8 0d ef ff ff       	call   c0103f39 <free_pages>
    boot_pgdir[0] = 0;
c010502c:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105037:	c7 04 24 4a 70 10 c0 	movl   $0xc010704a,(%esp)
c010503e:	e8 f9 b2 ff ff       	call   c010033c <cprintf>
}
c0105043:	c9                   	leave  
c0105044:	c3                   	ret    

c0105045 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105045:	55                   	push   %ebp
c0105046:	89 e5                	mov    %esp,%ebp
c0105048:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010504b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105052:	e9 ca 00 00 00       	jmp    c0105121 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105057:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010505a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010505d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105060:	c1 e8 0c             	shr    $0xc,%eax
c0105063:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105066:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c010506b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010506e:	72 23                	jb     c0105093 <check_boot_pgdir+0x4e>
c0105070:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105073:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105077:	c7 44 24 08 94 6c 10 	movl   $0xc0106c94,0x8(%esp)
c010507e:	c0 
c010507f:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105086:	00 
c0105087:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010508e:	e8 38 bc ff ff       	call   c0100ccb <__panic>
c0105093:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105096:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010509b:	89 c2                	mov    %eax,%edx
c010509d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01050a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050a9:	00 
c01050aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050ae:	89 04 24             	mov    %eax,(%esp)
c01050b1:	e8 8a f5 ff ff       	call   c0104640 <get_pte>
c01050b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01050bd:	75 24                	jne    c01050e3 <check_boot_pgdir+0x9e>
c01050bf:	c7 44 24 0c 64 70 10 	movl   $0xc0107064,0xc(%esp)
c01050c6:	c0 
c01050c7:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c01050ce:	c0 
c01050cf:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01050d6:	00 
c01050d7:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01050de:	e8 e8 bb ff ff       	call   c0100ccb <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01050e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050e6:	8b 00                	mov    (%eax),%eax
c01050e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050ed:	89 c2                	mov    %eax,%edx
c01050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f2:	39 c2                	cmp    %eax,%edx
c01050f4:	74 24                	je     c010511a <check_boot_pgdir+0xd5>
c01050f6:	c7 44 24 0c a1 70 10 	movl   $0xc01070a1,0xc(%esp)
c01050fd:	c0 
c01050fe:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0105105:	c0 
c0105106:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c010510d:	00 
c010510e:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0105115:	e8 b1 bb ff ff       	call   c0100ccb <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010511a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105121:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105124:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0105129:	39 c2                	cmp    %eax,%edx
c010512b:	0f 82 26 ff ff ff    	jb     c0105057 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105131:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105136:	05 ac 0f 00 00       	add    $0xfac,%eax
c010513b:	8b 00                	mov    (%eax),%eax
c010513d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105142:	89 c2                	mov    %eax,%edx
c0105144:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010514c:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105153:	77 23                	ja     c0105178 <check_boot_pgdir+0x133>
c0105155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105158:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010515c:	c7 44 24 08 38 6d 10 	movl   $0xc0106d38,0x8(%esp)
c0105163:	c0 
c0105164:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c010516b:	00 
c010516c:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0105173:	e8 53 bb ff ff       	call   c0100ccb <__panic>
c0105178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010517b:	05 00 00 00 40       	add    $0x40000000,%eax
c0105180:	39 c2                	cmp    %eax,%edx
c0105182:	74 24                	je     c01051a8 <check_boot_pgdir+0x163>
c0105184:	c7 44 24 0c b8 70 10 	movl   $0xc01070b8,0xc(%esp)
c010518b:	c0 
c010518c:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0105193:	c0 
c0105194:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c010519b:	00 
c010519c:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01051a3:	e8 23 bb ff ff       	call   c0100ccb <__panic>

    assert(boot_pgdir[0] == 0);
c01051a8:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01051ad:	8b 00                	mov    (%eax),%eax
c01051af:	85 c0                	test   %eax,%eax
c01051b1:	74 24                	je     c01051d7 <check_boot_pgdir+0x192>
c01051b3:	c7 44 24 0c ec 70 10 	movl   $0xc01070ec,0xc(%esp)
c01051ba:	c0 
c01051bb:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c01051c2:	c0 
c01051c3:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01051ca:	00 
c01051cb:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01051d2:	e8 f4 ba ff ff       	call   c0100ccb <__panic>

    struct Page *p;
    p = alloc_page();
c01051d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051de:	e8 1e ed ff ff       	call   c0103f01 <alloc_pages>
c01051e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01051e6:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01051eb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01051f2:	00 
c01051f3:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01051fa:	00 
c01051fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051fe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105202:	89 04 24             	mov    %eax,(%esp)
c0105205:	e8 6c f6 ff ff       	call   c0104876 <page_insert>
c010520a:	85 c0                	test   %eax,%eax
c010520c:	74 24                	je     c0105232 <check_boot_pgdir+0x1ed>
c010520e:	c7 44 24 0c 00 71 10 	movl   $0xc0107100,0xc(%esp)
c0105215:	c0 
c0105216:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c010521d:	c0 
c010521e:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105225:	00 
c0105226:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010522d:	e8 99 ba ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p) == 1);
c0105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105235:	89 04 24             	mov    %eax,(%esp)
c0105238:	e8 bf ea ff ff       	call   c0103cfc <page_ref>
c010523d:	83 f8 01             	cmp    $0x1,%eax
c0105240:	74 24                	je     c0105266 <check_boot_pgdir+0x221>
c0105242:	c7 44 24 0c 2e 71 10 	movl   $0xc010712e,0xc(%esp)
c0105249:	c0 
c010524a:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0105251:	c0 
c0105252:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105259:	00 
c010525a:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0105261:	e8 65 ba ff ff       	call   c0100ccb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105266:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010526b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105272:	00 
c0105273:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010527a:	00 
c010527b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010527e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105282:	89 04 24             	mov    %eax,(%esp)
c0105285:	e8 ec f5 ff ff       	call   c0104876 <page_insert>
c010528a:	85 c0                	test   %eax,%eax
c010528c:	74 24                	je     c01052b2 <check_boot_pgdir+0x26d>
c010528e:	c7 44 24 0c 40 71 10 	movl   $0xc0107140,0xc(%esp)
c0105295:	c0 
c0105296:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c010529d:	c0 
c010529e:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01052a5:	00 
c01052a6:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01052ad:	e8 19 ba ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p) == 2);
c01052b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052b5:	89 04 24             	mov    %eax,(%esp)
c01052b8:	e8 3f ea ff ff       	call   c0103cfc <page_ref>
c01052bd:	83 f8 02             	cmp    $0x2,%eax
c01052c0:	74 24                	je     c01052e6 <check_boot_pgdir+0x2a1>
c01052c2:	c7 44 24 0c 77 71 10 	movl   $0xc0107177,0xc(%esp)
c01052c9:	c0 
c01052ca:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c01052d1:	c0 
c01052d2:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01052d9:	00 
c01052da:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c01052e1:	e8 e5 b9 ff ff       	call   c0100ccb <__panic>

    const char *str = "ucore: Hello world!!";
c01052e6:	c7 45 dc 88 71 10 c0 	movl   $0xc0107188,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01052ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052f4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052fb:	e8 1e 0a 00 00       	call   c0105d1e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105300:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105307:	00 
c0105308:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010530f:	e8 83 0a 00 00       	call   c0105d97 <strcmp>
c0105314:	85 c0                	test   %eax,%eax
c0105316:	74 24                	je     c010533c <check_boot_pgdir+0x2f7>
c0105318:	c7 44 24 0c a0 71 10 	movl   $0xc01071a0,0xc(%esp)
c010531f:	c0 
c0105320:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c0105327:	c0 
c0105328:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c010532f:	00 
c0105330:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c0105337:	e8 8f b9 ff ff       	call   c0100ccb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010533c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533f:	89 04 24             	mov    %eax,(%esp)
c0105342:	e8 23 e9 ff ff       	call   c0103c6a <page2kva>
c0105347:	05 00 01 00 00       	add    $0x100,%eax
c010534c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010534f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105356:	e8 6b 09 00 00       	call   c0105cc6 <strlen>
c010535b:	85 c0                	test   %eax,%eax
c010535d:	74 24                	je     c0105383 <check_boot_pgdir+0x33e>
c010535f:	c7 44 24 0c d8 71 10 	movl   $0xc01071d8,0xc(%esp)
c0105366:	c0 
c0105367:	c7 44 24 08 81 6d 10 	movl   $0xc0106d81,0x8(%esp)
c010536e:	c0 
c010536f:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105376:	00 
c0105377:	c7 04 24 5c 6d 10 c0 	movl   $0xc0106d5c,(%esp)
c010537e:	e8 48 b9 ff ff       	call   c0100ccb <__panic>

    free_page(p);
c0105383:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010538a:	00 
c010538b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010538e:	89 04 24             	mov    %eax,(%esp)
c0105391:	e8 a3 eb ff ff       	call   c0103f39 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105396:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010539b:	8b 00                	mov    (%eax),%eax
c010539d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053a2:	89 04 24             	mov    %eax,(%esp)
c01053a5:	e8 71 e8 ff ff       	call   c0103c1b <pa2page>
c01053aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053b1:	00 
c01053b2:	89 04 24             	mov    %eax,(%esp)
c01053b5:	e8 7f eb ff ff       	call   c0103f39 <free_pages>
    boot_pgdir[0] = 0;
c01053ba:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01053bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01053c5:	c7 04 24 fc 71 10 c0 	movl   $0xc01071fc,(%esp)
c01053cc:	e8 6b af ff ff       	call   c010033c <cprintf>
}
c01053d1:	c9                   	leave  
c01053d2:	c3                   	ret    

c01053d3 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01053d3:	55                   	push   %ebp
c01053d4:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01053d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d9:	83 e0 04             	and    $0x4,%eax
c01053dc:	85 c0                	test   %eax,%eax
c01053de:	74 07                	je     c01053e7 <perm2str+0x14>
c01053e0:	b8 75 00 00 00       	mov    $0x75,%eax
c01053e5:	eb 05                	jmp    c01053ec <perm2str+0x19>
c01053e7:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01053ec:	a2 68 89 11 c0       	mov    %al,0xc0118968
    str[1] = 'r';
c01053f1:	c6 05 69 89 11 c0 72 	movb   $0x72,0xc0118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01053f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fb:	83 e0 02             	and    $0x2,%eax
c01053fe:	85 c0                	test   %eax,%eax
c0105400:	74 07                	je     c0105409 <perm2str+0x36>
c0105402:	b8 77 00 00 00       	mov    $0x77,%eax
c0105407:	eb 05                	jmp    c010540e <perm2str+0x3b>
c0105409:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010540e:	a2 6a 89 11 c0       	mov    %al,0xc011896a
    str[3] = '\0';
c0105413:	c6 05 6b 89 11 c0 00 	movb   $0x0,0xc011896b
    return str;
c010541a:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
}
c010541f:	5d                   	pop    %ebp
c0105420:	c3                   	ret    

c0105421 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105421:	55                   	push   %ebp
c0105422:	89 e5                	mov    %esp,%ebp
c0105424:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105427:	8b 45 10             	mov    0x10(%ebp),%eax
c010542a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010542d:	72 0a                	jb     c0105439 <get_pgtable_items+0x18>
        return 0;
c010542f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105434:	e9 9c 00 00 00       	jmp    c01054d5 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105439:	eb 04                	jmp    c010543f <get_pgtable_items+0x1e>
        start ++;
c010543b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010543f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105442:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105445:	73 18                	jae    c010545f <get_pgtable_items+0x3e>
c0105447:	8b 45 10             	mov    0x10(%ebp),%eax
c010544a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105451:	8b 45 14             	mov    0x14(%ebp),%eax
c0105454:	01 d0                	add    %edx,%eax
c0105456:	8b 00                	mov    (%eax),%eax
c0105458:	83 e0 01             	and    $0x1,%eax
c010545b:	85 c0                	test   %eax,%eax
c010545d:	74 dc                	je     c010543b <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010545f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105462:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105465:	73 69                	jae    c01054d0 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105467:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010546b:	74 08                	je     c0105475 <get_pgtable_items+0x54>
            *left_store = start;
c010546d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105470:	8b 55 10             	mov    0x10(%ebp),%edx
c0105473:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105475:	8b 45 10             	mov    0x10(%ebp),%eax
c0105478:	8d 50 01             	lea    0x1(%eax),%edx
c010547b:	89 55 10             	mov    %edx,0x10(%ebp)
c010547e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105485:	8b 45 14             	mov    0x14(%ebp),%eax
c0105488:	01 d0                	add    %edx,%eax
c010548a:	8b 00                	mov    (%eax),%eax
c010548c:	83 e0 07             	and    $0x7,%eax
c010548f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105492:	eb 04                	jmp    c0105498 <get_pgtable_items+0x77>
            start ++;
c0105494:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105498:	8b 45 10             	mov    0x10(%ebp),%eax
c010549b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010549e:	73 1d                	jae    c01054bd <get_pgtable_items+0x9c>
c01054a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01054a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01054ad:	01 d0                	add    %edx,%eax
c01054af:	8b 00                	mov    (%eax),%eax
c01054b1:	83 e0 07             	and    $0x7,%eax
c01054b4:	89 c2                	mov    %eax,%edx
c01054b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054b9:	39 c2                	cmp    %eax,%edx
c01054bb:	74 d7                	je     c0105494 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01054bd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054c1:	74 08                	je     c01054cb <get_pgtable_items+0xaa>
            *right_store = start;
c01054c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054c6:	8b 55 10             	mov    0x10(%ebp),%edx
c01054c9:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01054cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054ce:	eb 05                	jmp    c01054d5 <get_pgtable_items+0xb4>
    }
    return 0;
c01054d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054d5:	c9                   	leave  
c01054d6:	c3                   	ret    

c01054d7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01054d7:	55                   	push   %ebp
c01054d8:	89 e5                	mov    %esp,%ebp
c01054da:	57                   	push   %edi
c01054db:	56                   	push   %esi
c01054dc:	53                   	push   %ebx
c01054dd:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01054e0:	c7 04 24 1c 72 10 c0 	movl   $0xc010721c,(%esp)
c01054e7:	e8 50 ae ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01054ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01054f3:	e9 fa 00 00 00       	jmp    c01055f2 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054fb:	89 04 24             	mov    %eax,(%esp)
c01054fe:	e8 d0 fe ff ff       	call   c01053d3 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105503:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105506:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105509:	29 d1                	sub    %edx,%ecx
c010550b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010550d:	89 d6                	mov    %edx,%esi
c010550f:	c1 e6 16             	shl    $0x16,%esi
c0105512:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105515:	89 d3                	mov    %edx,%ebx
c0105517:	c1 e3 16             	shl    $0x16,%ebx
c010551a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010551d:	89 d1                	mov    %edx,%ecx
c010551f:	c1 e1 16             	shl    $0x16,%ecx
c0105522:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105525:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105528:	29 d7                	sub    %edx,%edi
c010552a:	89 fa                	mov    %edi,%edx
c010552c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105530:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105534:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105538:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010553c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105540:	c7 04 24 4d 72 10 c0 	movl   $0xc010724d,(%esp)
c0105547:	e8 f0 ad ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010554c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010554f:	c1 e0 0a             	shl    $0xa,%eax
c0105552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105555:	eb 54                	jmp    c01055ab <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010555a:	89 04 24             	mov    %eax,(%esp)
c010555d:	e8 71 fe ff ff       	call   c01053d3 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105562:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105565:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105568:	29 d1                	sub    %edx,%ecx
c010556a:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010556c:	89 d6                	mov    %edx,%esi
c010556e:	c1 e6 0c             	shl    $0xc,%esi
c0105571:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105574:	89 d3                	mov    %edx,%ebx
c0105576:	c1 e3 0c             	shl    $0xc,%ebx
c0105579:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010557c:	c1 e2 0c             	shl    $0xc,%edx
c010557f:	89 d1                	mov    %edx,%ecx
c0105581:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105584:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105587:	29 d7                	sub    %edx,%edi
c0105589:	89 fa                	mov    %edi,%edx
c010558b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010558f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105593:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010559b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010559f:	c7 04 24 6c 72 10 c0 	movl   $0xc010726c,(%esp)
c01055a6:	e8 91 ad ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01055ab:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01055b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01055b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01055b6:	89 ce                	mov    %ecx,%esi
c01055b8:	c1 e6 0a             	shl    $0xa,%esi
c01055bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01055be:	89 cb                	mov    %ecx,%ebx
c01055c0:	c1 e3 0a             	shl    $0xa,%ebx
c01055c3:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01055c6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01055ca:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01055cd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01055d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055d5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055d9:	89 74 24 04          	mov    %esi,0x4(%esp)
c01055dd:	89 1c 24             	mov    %ebx,(%esp)
c01055e0:	e8 3c fe ff ff       	call   c0105421 <get_pgtable_items>
c01055e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055ec:	0f 85 65 ff ff ff    	jne    c0105557 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01055f2:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01055f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055fa:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01055fd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105601:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105604:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105608:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010560c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105610:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105617:	00 
c0105618:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010561f:	e8 fd fd ff ff       	call   c0105421 <get_pgtable_items>
c0105624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010562b:	0f 85 c7 fe ff ff    	jne    c01054f8 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105631:	c7 04 24 90 72 10 c0 	movl   $0xc0107290,(%esp)
c0105638:	e8 ff ac ff ff       	call   c010033c <cprintf>
}
c010563d:	83 c4 4c             	add    $0x4c,%esp
c0105640:	5b                   	pop    %ebx
c0105641:	5e                   	pop    %esi
c0105642:	5f                   	pop    %edi
c0105643:	5d                   	pop    %ebp
c0105644:	c3                   	ret    

c0105645 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105645:	55                   	push   %ebp
c0105646:	89 e5                	mov    %esp,%ebp
c0105648:	83 ec 58             	sub    $0x58,%esp
c010564b:	8b 45 10             	mov    0x10(%ebp),%eax
c010564e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105651:	8b 45 14             	mov    0x14(%ebp),%eax
c0105654:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105657:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010565a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010565d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105660:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105663:	8b 45 18             	mov    0x18(%ebp),%eax
c0105666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105669:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010566c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010566f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105672:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105675:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105678:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010567b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010567f:	74 1c                	je     c010569d <printnum+0x58>
c0105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105684:	ba 00 00 00 00       	mov    $0x0,%edx
c0105689:	f7 75 e4             	divl   -0x1c(%ebp)
c010568c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010568f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105692:	ba 00 00 00 00       	mov    $0x0,%edx
c0105697:	f7 75 e4             	divl   -0x1c(%ebp)
c010569a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010569d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056a3:	f7 75 e4             	divl   -0x1c(%ebp)
c01056a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01056a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01056ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056af:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01056b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01056b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056bb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01056be:	8b 45 18             	mov    0x18(%ebp),%eax
c01056c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01056c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056c9:	77 56                	ja     c0105721 <printnum+0xdc>
c01056cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01056ce:	72 05                	jb     c01056d5 <printnum+0x90>
c01056d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01056d3:	77 4c                	ja     c0105721 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01056d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01056d8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01056db:	8b 45 20             	mov    0x20(%ebp),%eax
c01056de:	89 44 24 18          	mov    %eax,0x18(%esp)
c01056e2:	89 54 24 14          	mov    %edx,0x14(%esp)
c01056e6:	8b 45 18             	mov    0x18(%ebp),%eax
c01056e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01056ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01056f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01056fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105702:	8b 45 08             	mov    0x8(%ebp),%eax
c0105705:	89 04 24             	mov    %eax,(%esp)
c0105708:	e8 38 ff ff ff       	call   c0105645 <printnum>
c010570d:	eb 1c                	jmp    c010572b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010570f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105716:	8b 45 20             	mov    0x20(%ebp),%eax
c0105719:	89 04 24             	mov    %eax,(%esp)
c010571c:	8b 45 08             	mov    0x8(%ebp),%eax
c010571f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105721:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105725:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105729:	7f e4                	jg     c010570f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010572b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010572e:	05 44 73 10 c0       	add    $0xc0107344,%eax
c0105733:	0f b6 00             	movzbl (%eax),%eax
c0105736:	0f be c0             	movsbl %al,%eax
c0105739:	8b 55 0c             	mov    0xc(%ebp),%edx
c010573c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105740:	89 04 24             	mov    %eax,(%esp)
c0105743:	8b 45 08             	mov    0x8(%ebp),%eax
c0105746:	ff d0                	call   *%eax
}
c0105748:	c9                   	leave  
c0105749:	c3                   	ret    

c010574a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010574a:	55                   	push   %ebp
c010574b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010574d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105751:	7e 14                	jle    c0105767 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105753:	8b 45 08             	mov    0x8(%ebp),%eax
c0105756:	8b 00                	mov    (%eax),%eax
c0105758:	8d 48 08             	lea    0x8(%eax),%ecx
c010575b:	8b 55 08             	mov    0x8(%ebp),%edx
c010575e:	89 0a                	mov    %ecx,(%edx)
c0105760:	8b 50 04             	mov    0x4(%eax),%edx
c0105763:	8b 00                	mov    (%eax),%eax
c0105765:	eb 30                	jmp    c0105797 <getuint+0x4d>
    }
    else if (lflag) {
c0105767:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010576b:	74 16                	je     c0105783 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	8b 00                	mov    (%eax),%eax
c0105772:	8d 48 04             	lea    0x4(%eax),%ecx
c0105775:	8b 55 08             	mov    0x8(%ebp),%edx
c0105778:	89 0a                	mov    %ecx,(%edx)
c010577a:	8b 00                	mov    (%eax),%eax
c010577c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105781:	eb 14                	jmp    c0105797 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105783:	8b 45 08             	mov    0x8(%ebp),%eax
c0105786:	8b 00                	mov    (%eax),%eax
c0105788:	8d 48 04             	lea    0x4(%eax),%ecx
c010578b:	8b 55 08             	mov    0x8(%ebp),%edx
c010578e:	89 0a                	mov    %ecx,(%edx)
c0105790:	8b 00                	mov    (%eax),%eax
c0105792:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105797:	5d                   	pop    %ebp
c0105798:	c3                   	ret    

c0105799 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105799:	55                   	push   %ebp
c010579a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010579c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01057a0:	7e 14                	jle    c01057b6 <getint+0x1d>
        return va_arg(*ap, long long);
c01057a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a5:	8b 00                	mov    (%eax),%eax
c01057a7:	8d 48 08             	lea    0x8(%eax),%ecx
c01057aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01057ad:	89 0a                	mov    %ecx,(%edx)
c01057af:	8b 50 04             	mov    0x4(%eax),%edx
c01057b2:	8b 00                	mov    (%eax),%eax
c01057b4:	eb 28                	jmp    c01057de <getint+0x45>
    }
    else if (lflag) {
c01057b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057ba:	74 12                	je     c01057ce <getint+0x35>
        return va_arg(*ap, long);
c01057bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bf:	8b 00                	mov    (%eax),%eax
c01057c1:	8d 48 04             	lea    0x4(%eax),%ecx
c01057c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01057c7:	89 0a                	mov    %ecx,(%edx)
c01057c9:	8b 00                	mov    (%eax),%eax
c01057cb:	99                   	cltd   
c01057cc:	eb 10                	jmp    c01057de <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01057ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d1:	8b 00                	mov    (%eax),%eax
c01057d3:	8d 48 04             	lea    0x4(%eax),%ecx
c01057d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01057d9:	89 0a                	mov    %ecx,(%edx)
c01057db:	8b 00                	mov    (%eax),%eax
c01057dd:	99                   	cltd   
    }
}
c01057de:	5d                   	pop    %ebp
c01057df:	c3                   	ret    

c01057e0 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057e0:	55                   	push   %ebp
c01057e1:	89 e5                	mov    %esp,%ebp
c01057e3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01057e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01057e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01057ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105801:	8b 45 08             	mov    0x8(%ebp),%eax
c0105804:	89 04 24             	mov    %eax,(%esp)
c0105807:	e8 02 00 00 00       	call   c010580e <vprintfmt>
    va_end(ap);
}
c010580c:	c9                   	leave  
c010580d:	c3                   	ret    

c010580e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010580e:	55                   	push   %ebp
c010580f:	89 e5                	mov    %esp,%ebp
c0105811:	56                   	push   %esi
c0105812:	53                   	push   %ebx
c0105813:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105816:	eb 18                	jmp    c0105830 <vprintfmt+0x22>
            if (ch == '\0') {
c0105818:	85 db                	test   %ebx,%ebx
c010581a:	75 05                	jne    c0105821 <vprintfmt+0x13>
                return;
c010581c:	e9 d1 03 00 00       	jmp    c0105bf2 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105821:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105828:	89 1c 24             	mov    %ebx,(%esp)
c010582b:	8b 45 08             	mov    0x8(%ebp),%eax
c010582e:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105830:	8b 45 10             	mov    0x10(%ebp),%eax
c0105833:	8d 50 01             	lea    0x1(%eax),%edx
c0105836:	89 55 10             	mov    %edx,0x10(%ebp)
c0105839:	0f b6 00             	movzbl (%eax),%eax
c010583c:	0f b6 d8             	movzbl %al,%ebx
c010583f:	83 fb 25             	cmp    $0x25,%ebx
c0105842:	75 d4                	jne    c0105818 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105844:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105848:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010584f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105852:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105855:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010585c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010585f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105862:	8b 45 10             	mov    0x10(%ebp),%eax
c0105865:	8d 50 01             	lea    0x1(%eax),%edx
c0105868:	89 55 10             	mov    %edx,0x10(%ebp)
c010586b:	0f b6 00             	movzbl (%eax),%eax
c010586e:	0f b6 d8             	movzbl %al,%ebx
c0105871:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105874:	83 f8 55             	cmp    $0x55,%eax
c0105877:	0f 87 44 03 00 00    	ja     c0105bc1 <vprintfmt+0x3b3>
c010587d:	8b 04 85 68 73 10 c0 	mov    -0x3fef8c98(,%eax,4),%eax
c0105884:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105886:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010588a:	eb d6                	jmp    c0105862 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010588c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105890:	eb d0                	jmp    c0105862 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010589c:	89 d0                	mov    %edx,%eax
c010589e:	c1 e0 02             	shl    $0x2,%eax
c01058a1:	01 d0                	add    %edx,%eax
c01058a3:	01 c0                	add    %eax,%eax
c01058a5:	01 d8                	add    %ebx,%eax
c01058a7:	83 e8 30             	sub    $0x30,%eax
c01058aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01058ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b0:	0f b6 00             	movzbl (%eax),%eax
c01058b3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01058b6:	83 fb 2f             	cmp    $0x2f,%ebx
c01058b9:	7e 0b                	jle    c01058c6 <vprintfmt+0xb8>
c01058bb:	83 fb 39             	cmp    $0x39,%ebx
c01058be:	7f 06                	jg     c01058c6 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01058c0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01058c4:	eb d3                	jmp    c0105899 <vprintfmt+0x8b>
            goto process_precision;
c01058c6:	eb 33                	jmp    c01058fb <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01058c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01058cb:	8d 50 04             	lea    0x4(%eax),%edx
c01058ce:	89 55 14             	mov    %edx,0x14(%ebp)
c01058d1:	8b 00                	mov    (%eax),%eax
c01058d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01058d6:	eb 23                	jmp    c01058fb <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01058d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058dc:	79 0c                	jns    c01058ea <vprintfmt+0xdc>
                width = 0;
c01058de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058e5:	e9 78 ff ff ff       	jmp    c0105862 <vprintfmt+0x54>
c01058ea:	e9 73 ff ff ff       	jmp    c0105862 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01058ef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01058f6:	e9 67 ff ff ff       	jmp    c0105862 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01058fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058ff:	79 12                	jns    c0105913 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105904:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105907:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010590e:	e9 4f ff ff ff       	jmp    c0105862 <vprintfmt+0x54>
c0105913:	e9 4a ff ff ff       	jmp    c0105862 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105918:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010591c:	e9 41 ff ff ff       	jmp    c0105862 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105921:	8b 45 14             	mov    0x14(%ebp),%eax
c0105924:	8d 50 04             	lea    0x4(%eax),%edx
c0105927:	89 55 14             	mov    %edx,0x14(%ebp)
c010592a:	8b 00                	mov    (%eax),%eax
c010592c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010592f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105933:	89 04 24             	mov    %eax,(%esp)
c0105936:	8b 45 08             	mov    0x8(%ebp),%eax
c0105939:	ff d0                	call   *%eax
            break;
c010593b:	e9 ac 02 00 00       	jmp    c0105bec <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105940:	8b 45 14             	mov    0x14(%ebp),%eax
c0105943:	8d 50 04             	lea    0x4(%eax),%edx
c0105946:	89 55 14             	mov    %edx,0x14(%ebp)
c0105949:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010594b:	85 db                	test   %ebx,%ebx
c010594d:	79 02                	jns    c0105951 <vprintfmt+0x143>
                err = -err;
c010594f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105951:	83 fb 06             	cmp    $0x6,%ebx
c0105954:	7f 0b                	jg     c0105961 <vprintfmt+0x153>
c0105956:	8b 34 9d 28 73 10 c0 	mov    -0x3fef8cd8(,%ebx,4),%esi
c010595d:	85 f6                	test   %esi,%esi
c010595f:	75 23                	jne    c0105984 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105961:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105965:	c7 44 24 08 55 73 10 	movl   $0xc0107355,0x8(%esp)
c010596c:	c0 
c010596d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105970:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105974:	8b 45 08             	mov    0x8(%ebp),%eax
c0105977:	89 04 24             	mov    %eax,(%esp)
c010597a:	e8 61 fe ff ff       	call   c01057e0 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010597f:	e9 68 02 00 00       	jmp    c0105bec <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105984:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105988:	c7 44 24 08 5e 73 10 	movl   $0xc010735e,0x8(%esp)
c010598f:	c0 
c0105990:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105993:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105997:	8b 45 08             	mov    0x8(%ebp),%eax
c010599a:	89 04 24             	mov    %eax,(%esp)
c010599d:	e8 3e fe ff ff       	call   c01057e0 <printfmt>
            }
            break;
c01059a2:	e9 45 02 00 00       	jmp    c0105bec <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01059a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01059aa:	8d 50 04             	lea    0x4(%eax),%edx
c01059ad:	89 55 14             	mov    %edx,0x14(%ebp)
c01059b0:	8b 30                	mov    (%eax),%esi
c01059b2:	85 f6                	test   %esi,%esi
c01059b4:	75 05                	jne    c01059bb <vprintfmt+0x1ad>
                p = "(null)";
c01059b6:	be 61 73 10 c0       	mov    $0xc0107361,%esi
            }
            if (width > 0 && padc != '-') {
c01059bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059bf:	7e 3e                	jle    c01059ff <vprintfmt+0x1f1>
c01059c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01059c5:	74 38                	je     c01059ff <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01059c7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01059ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d1:	89 34 24             	mov    %esi,(%esp)
c01059d4:	e8 15 03 00 00       	call   c0105cee <strnlen>
c01059d9:	29 c3                	sub    %eax,%ebx
c01059db:	89 d8                	mov    %ebx,%eax
c01059dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059e0:	eb 17                	jmp    c01059f9 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01059e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01059e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ed:	89 04 24             	mov    %eax,(%esp)
c01059f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f3:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01059f5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059fd:	7f e3                	jg     c01059e2 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059ff:	eb 38                	jmp    c0105a39 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105a01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105a05:	74 1f                	je     c0105a26 <vprintfmt+0x218>
c0105a07:	83 fb 1f             	cmp    $0x1f,%ebx
c0105a0a:	7e 05                	jle    c0105a11 <vprintfmt+0x203>
c0105a0c:	83 fb 7e             	cmp    $0x7e,%ebx
c0105a0f:	7e 15                	jle    c0105a26 <vprintfmt+0x218>
                    putch('?', putdat);
c0105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a18:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a22:	ff d0                	call   *%eax
c0105a24:	eb 0f                	jmp    c0105a35 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105a26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2d:	89 1c 24             	mov    %ebx,(%esp)
c0105a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a33:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105a35:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a39:	89 f0                	mov    %esi,%eax
c0105a3b:	8d 70 01             	lea    0x1(%eax),%esi
c0105a3e:	0f b6 00             	movzbl (%eax),%eax
c0105a41:	0f be d8             	movsbl %al,%ebx
c0105a44:	85 db                	test   %ebx,%ebx
c0105a46:	74 10                	je     c0105a58 <vprintfmt+0x24a>
c0105a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a4c:	78 b3                	js     c0105a01 <vprintfmt+0x1f3>
c0105a4e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105a52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a56:	79 a9                	jns    c0105a01 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a58:	eb 17                	jmp    c0105a71 <vprintfmt+0x263>
                putch(' ', putdat);
c0105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a61:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6b:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a6d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a75:	7f e3                	jg     c0105a5a <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105a77:	e9 70 01 00 00       	jmp    c0105bec <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a83:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a86:	89 04 24             	mov    %eax,(%esp)
c0105a89:	e8 0b fd ff ff       	call   c0105799 <getint>
c0105a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a9a:	85 d2                	test   %edx,%edx
c0105a9c:	79 26                	jns    c0105ac4 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aaf:	ff d0                	call   *%eax
                num = -(long long)num;
c0105ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ab7:	f7 d8                	neg    %eax
c0105ab9:	83 d2 00             	adc    $0x0,%edx
c0105abc:	f7 da                	neg    %edx
c0105abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105ac4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105acb:	e9 a8 00 00 00       	jmp    c0105b78 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ad7:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ada:	89 04 24             	mov    %eax,(%esp)
c0105add:	e8 68 fc ff ff       	call   c010574a <getuint>
c0105ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105ae8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105aef:	e9 84 00 00 00       	jmp    c0105b78 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afb:	8d 45 14             	lea    0x14(%ebp),%eax
c0105afe:	89 04 24             	mov    %eax,(%esp)
c0105b01:	e8 44 fc ff ff       	call   c010574a <getuint>
c0105b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b09:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105b0c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105b13:	eb 63                	jmp    c0105b78 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b1c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b26:	ff d0                	call   *%eax
            putch('x', putdat);
c0105b28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b2f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b39:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105b3b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b3e:	8d 50 04             	lea    0x4(%eax),%edx
c0105b41:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b44:	8b 00                	mov    (%eax),%eax
c0105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105b50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105b57:	eb 1f                	jmp    c0105b78 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b60:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b63:	89 04 24             	mov    %eax,(%esp)
c0105b66:	e8 df fb ff ff       	call   c010574a <getuint>
c0105b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b71:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b78:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b7f:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b83:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b86:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b8a:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b94:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b98:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba6:	89 04 24             	mov    %eax,(%esp)
c0105ba9:	e8 97 fa ff ff       	call   c0105645 <printnum>
            break;
c0105bae:	eb 3c                	jmp    c0105bec <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bb7:	89 1c 24             	mov    %ebx,(%esp)
c0105bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbd:	ff d0                	call   *%eax
            break;
c0105bbf:	eb 2b                	jmp    c0105bec <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bc8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105bd4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bd8:	eb 04                	jmp    c0105bde <vprintfmt+0x3d0>
c0105bda:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bde:	8b 45 10             	mov    0x10(%ebp),%eax
c0105be1:	83 e8 01             	sub    $0x1,%eax
c0105be4:	0f b6 00             	movzbl (%eax),%eax
c0105be7:	3c 25                	cmp    $0x25,%al
c0105be9:	75 ef                	jne    c0105bda <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105beb:	90                   	nop
        }
    }
c0105bec:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105bed:	e9 3e fc ff ff       	jmp    c0105830 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105bf2:	83 c4 40             	add    $0x40,%esp
c0105bf5:	5b                   	pop    %ebx
c0105bf6:	5e                   	pop    %esi
c0105bf7:	5d                   	pop    %ebp
c0105bf8:	c3                   	ret    

c0105bf9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105bf9:	55                   	push   %ebp
c0105bfa:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bff:	8b 40 08             	mov    0x8(%eax),%eax
c0105c02:	8d 50 01             	lea    0x1(%eax),%edx
c0105c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c08:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0e:	8b 10                	mov    (%eax),%edx
c0105c10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c13:	8b 40 04             	mov    0x4(%eax),%eax
c0105c16:	39 c2                	cmp    %eax,%edx
c0105c18:	73 12                	jae    c0105c2c <sprintputch+0x33>
        *b->buf ++ = ch;
c0105c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c1d:	8b 00                	mov    (%eax),%eax
c0105c1f:	8d 48 01             	lea    0x1(%eax),%ecx
c0105c22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c25:	89 0a                	mov    %ecx,(%edx)
c0105c27:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c2a:	88 10                	mov    %dl,(%eax)
    }
}
c0105c2c:	5d                   	pop    %ebp
c0105c2d:	c3                   	ret    

c0105c2e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105c2e:	55                   	push   %ebp
c0105c2f:	89 e5                	mov    %esp,%ebp
c0105c31:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105c34:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c41:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c44:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c52:	89 04 24             	mov    %eax,(%esp)
c0105c55:	e8 08 00 00 00       	call   c0105c62 <vsnprintf>
c0105c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c60:	c9                   	leave  
c0105c61:	c3                   	ret    

c0105c62 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105c62:	55                   	push   %ebp
c0105c63:	89 e5                	mov    %esp,%ebp
c0105c65:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c71:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c77:	01 d0                	add    %edx,%eax
c0105c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c87:	74 0a                	je     c0105c93 <vsnprintf+0x31>
c0105c89:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c8f:	39 c2                	cmp    %eax,%edx
c0105c91:	76 07                	jbe    c0105c9a <vsnprintf+0x38>
        return -E_INVAL;
c0105c93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c98:	eb 2a                	jmp    c0105cc4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ca8:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105cab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105caf:	c7 04 24 f9 5b 10 c0 	movl   $0xc0105bf9,(%esp)
c0105cb6:	e8 53 fb ff ff       	call   c010580e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cbe:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105cc4:	c9                   	leave  
c0105cc5:	c3                   	ret    

c0105cc6 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105cc6:	55                   	push   %ebp
c0105cc7:	89 e5                	mov    %esp,%ebp
c0105cc9:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105cd3:	eb 04                	jmp    c0105cd9 <strlen+0x13>
        cnt ++;
c0105cd5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105cd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdc:	8d 50 01             	lea    0x1(%eax),%edx
c0105cdf:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ce2:	0f b6 00             	movzbl (%eax),%eax
c0105ce5:	84 c0                	test   %al,%al
c0105ce7:	75 ec                	jne    c0105cd5 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105cec:	c9                   	leave  
c0105ced:	c3                   	ret    

c0105cee <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105cee:	55                   	push   %ebp
c0105cef:	89 e5                	mov    %esp,%ebp
c0105cf1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105cfb:	eb 04                	jmp    c0105d01 <strnlen+0x13>
        cnt ++;
c0105cfd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d04:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d07:	73 10                	jae    c0105d19 <strnlen+0x2b>
c0105d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0c:	8d 50 01             	lea    0x1(%eax),%edx
c0105d0f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105d12:	0f b6 00             	movzbl (%eax),%eax
c0105d15:	84 c0                	test   %al,%al
c0105d17:	75 e4                	jne    c0105cfd <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105d1c:	c9                   	leave  
c0105d1d:	c3                   	ret    

c0105d1e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105d1e:	55                   	push   %ebp
c0105d1f:	89 e5                	mov    %esp,%ebp
c0105d21:	57                   	push   %edi
c0105d22:	56                   	push   %esi
c0105d23:	83 ec 20             	sub    $0x20,%esp
c0105d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d38:	89 d1                	mov    %edx,%ecx
c0105d3a:	89 c2                	mov    %eax,%edx
c0105d3c:	89 ce                	mov    %ecx,%esi
c0105d3e:	89 d7                	mov    %edx,%edi
c0105d40:	ac                   	lods   %ds:(%esi),%al
c0105d41:	aa                   	stos   %al,%es:(%edi)
c0105d42:	84 c0                	test   %al,%al
c0105d44:	75 fa                	jne    c0105d40 <strcpy+0x22>
c0105d46:	89 fa                	mov    %edi,%edx
c0105d48:	89 f1                	mov    %esi,%ecx
c0105d4a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d4d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105d50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105d56:	83 c4 20             	add    $0x20,%esp
c0105d59:	5e                   	pop    %esi
c0105d5a:	5f                   	pop    %edi
c0105d5b:	5d                   	pop    %ebp
c0105d5c:	c3                   	ret    

c0105d5d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105d5d:	55                   	push   %ebp
c0105d5e:	89 e5                	mov    %esp,%ebp
c0105d60:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105d69:	eb 21                	jmp    c0105d8c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6e:	0f b6 10             	movzbl (%eax),%edx
c0105d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d74:	88 10                	mov    %dl,(%eax)
c0105d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d79:	0f b6 00             	movzbl (%eax),%eax
c0105d7c:	84 c0                	test   %al,%al
c0105d7e:	74 04                	je     c0105d84 <strncpy+0x27>
            src ++;
c0105d80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105d84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d88:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d90:	75 d9                	jne    c0105d6b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d95:	c9                   	leave  
c0105d96:	c3                   	ret    

c0105d97 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d97:	55                   	push   %ebp
c0105d98:	89 e5                	mov    %esp,%ebp
c0105d9a:	57                   	push   %edi
c0105d9b:	56                   	push   %esi
c0105d9c:	83 ec 20             	sub    $0x20,%esp
c0105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105da5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105db1:	89 d1                	mov    %edx,%ecx
c0105db3:	89 c2                	mov    %eax,%edx
c0105db5:	89 ce                	mov    %ecx,%esi
c0105db7:	89 d7                	mov    %edx,%edi
c0105db9:	ac                   	lods   %ds:(%esi),%al
c0105dba:	ae                   	scas   %es:(%edi),%al
c0105dbb:	75 08                	jne    c0105dc5 <strcmp+0x2e>
c0105dbd:	84 c0                	test   %al,%al
c0105dbf:	75 f8                	jne    c0105db9 <strcmp+0x22>
c0105dc1:	31 c0                	xor    %eax,%eax
c0105dc3:	eb 04                	jmp    c0105dc9 <strcmp+0x32>
c0105dc5:	19 c0                	sbb    %eax,%eax
c0105dc7:	0c 01                	or     $0x1,%al
c0105dc9:	89 fa                	mov    %edi,%edx
c0105dcb:	89 f1                	mov    %esi,%ecx
c0105dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105dd0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105dd3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105dd9:	83 c4 20             	add    $0x20,%esp
c0105ddc:	5e                   	pop    %esi
c0105ddd:	5f                   	pop    %edi
c0105dde:	5d                   	pop    %ebp
c0105ddf:	c3                   	ret    

c0105de0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105de0:	55                   	push   %ebp
c0105de1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105de3:	eb 0c                	jmp    c0105df1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105de5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105de9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ded:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105df5:	74 1a                	je     c0105e11 <strncmp+0x31>
c0105df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfa:	0f b6 00             	movzbl (%eax),%eax
c0105dfd:	84 c0                	test   %al,%al
c0105dff:	74 10                	je     c0105e11 <strncmp+0x31>
c0105e01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e04:	0f b6 10             	movzbl (%eax),%edx
c0105e07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e0a:	0f b6 00             	movzbl (%eax),%eax
c0105e0d:	38 c2                	cmp    %al,%dl
c0105e0f:	74 d4                	je     c0105de5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e15:	74 18                	je     c0105e2f <strncmp+0x4f>
c0105e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e1a:	0f b6 00             	movzbl (%eax),%eax
c0105e1d:	0f b6 d0             	movzbl %al,%edx
c0105e20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e23:	0f b6 00             	movzbl (%eax),%eax
c0105e26:	0f b6 c0             	movzbl %al,%eax
c0105e29:	29 c2                	sub    %eax,%edx
c0105e2b:	89 d0                	mov    %edx,%eax
c0105e2d:	eb 05                	jmp    c0105e34 <strncmp+0x54>
c0105e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e34:	5d                   	pop    %ebp
c0105e35:	c3                   	ret    

c0105e36 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105e36:	55                   	push   %ebp
c0105e37:	89 e5                	mov    %esp,%ebp
c0105e39:	83 ec 04             	sub    $0x4,%esp
c0105e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e42:	eb 14                	jmp    c0105e58 <strchr+0x22>
        if (*s == c) {
c0105e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e47:	0f b6 00             	movzbl (%eax),%eax
c0105e4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e4d:	75 05                	jne    c0105e54 <strchr+0x1e>
            return (char *)s;
c0105e4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e52:	eb 13                	jmp    c0105e67 <strchr+0x31>
        }
        s ++;
c0105e54:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105e58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5b:	0f b6 00             	movzbl (%eax),%eax
c0105e5e:	84 c0                	test   %al,%al
c0105e60:	75 e2                	jne    c0105e44 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e67:	c9                   	leave  
c0105e68:	c3                   	ret    

c0105e69 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105e69:	55                   	push   %ebp
c0105e6a:	89 e5                	mov    %esp,%ebp
c0105e6c:	83 ec 04             	sub    $0x4,%esp
c0105e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e72:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e75:	eb 11                	jmp    c0105e88 <strfind+0x1f>
        if (*s == c) {
c0105e77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e7a:	0f b6 00             	movzbl (%eax),%eax
c0105e7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e80:	75 02                	jne    c0105e84 <strfind+0x1b>
            break;
c0105e82:	eb 0e                	jmp    c0105e92 <strfind+0x29>
        }
        s ++;
c0105e84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105e88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8b:	0f b6 00             	movzbl (%eax),%eax
c0105e8e:	84 c0                	test   %al,%al
c0105e90:	75 e5                	jne    c0105e77 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105e92:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e95:	c9                   	leave  
c0105e96:	c3                   	ret    

c0105e97 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e97:	55                   	push   %ebp
c0105e98:	89 e5                	mov    %esp,%ebp
c0105e9a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ea4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105eab:	eb 04                	jmp    c0105eb1 <strtol+0x1a>
        s ++;
c0105ead:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb4:	0f b6 00             	movzbl (%eax),%eax
c0105eb7:	3c 20                	cmp    $0x20,%al
c0105eb9:	74 f2                	je     c0105ead <strtol+0x16>
c0105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebe:	0f b6 00             	movzbl (%eax),%eax
c0105ec1:	3c 09                	cmp    $0x9,%al
c0105ec3:	74 e8                	je     c0105ead <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec8:	0f b6 00             	movzbl (%eax),%eax
c0105ecb:	3c 2b                	cmp    $0x2b,%al
c0105ecd:	75 06                	jne    c0105ed5 <strtol+0x3e>
        s ++;
c0105ecf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ed3:	eb 15                	jmp    c0105eea <strtol+0x53>
    }
    else if (*s == '-') {
c0105ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed8:	0f b6 00             	movzbl (%eax),%eax
c0105edb:	3c 2d                	cmp    $0x2d,%al
c0105edd:	75 0b                	jne    c0105eea <strtol+0x53>
        s ++, neg = 1;
c0105edf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ee3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105eee:	74 06                	je     c0105ef6 <strtol+0x5f>
c0105ef0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105ef4:	75 24                	jne    c0105f1a <strtol+0x83>
c0105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef9:	0f b6 00             	movzbl (%eax),%eax
c0105efc:	3c 30                	cmp    $0x30,%al
c0105efe:	75 1a                	jne    c0105f1a <strtol+0x83>
c0105f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f03:	83 c0 01             	add    $0x1,%eax
c0105f06:	0f b6 00             	movzbl (%eax),%eax
c0105f09:	3c 78                	cmp    $0x78,%al
c0105f0b:	75 0d                	jne    c0105f1a <strtol+0x83>
        s += 2, base = 16;
c0105f0d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105f11:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105f18:	eb 2a                	jmp    c0105f44 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f1e:	75 17                	jne    c0105f37 <strtol+0xa0>
c0105f20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f23:	0f b6 00             	movzbl (%eax),%eax
c0105f26:	3c 30                	cmp    $0x30,%al
c0105f28:	75 0d                	jne    c0105f37 <strtol+0xa0>
        s ++, base = 8;
c0105f2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f2e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105f35:	eb 0d                	jmp    c0105f44 <strtol+0xad>
    }
    else if (base == 0) {
c0105f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f3b:	75 07                	jne    c0105f44 <strtol+0xad>
        base = 10;
c0105f3d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f47:	0f b6 00             	movzbl (%eax),%eax
c0105f4a:	3c 2f                	cmp    $0x2f,%al
c0105f4c:	7e 1b                	jle    c0105f69 <strtol+0xd2>
c0105f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f51:	0f b6 00             	movzbl (%eax),%eax
c0105f54:	3c 39                	cmp    $0x39,%al
c0105f56:	7f 11                	jg     c0105f69 <strtol+0xd2>
            dig = *s - '0';
c0105f58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5b:	0f b6 00             	movzbl (%eax),%eax
c0105f5e:	0f be c0             	movsbl %al,%eax
c0105f61:	83 e8 30             	sub    $0x30,%eax
c0105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f67:	eb 48                	jmp    c0105fb1 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6c:	0f b6 00             	movzbl (%eax),%eax
c0105f6f:	3c 60                	cmp    $0x60,%al
c0105f71:	7e 1b                	jle    c0105f8e <strtol+0xf7>
c0105f73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f76:	0f b6 00             	movzbl (%eax),%eax
c0105f79:	3c 7a                	cmp    $0x7a,%al
c0105f7b:	7f 11                	jg     c0105f8e <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105f7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f80:	0f b6 00             	movzbl (%eax),%eax
c0105f83:	0f be c0             	movsbl %al,%eax
c0105f86:	83 e8 57             	sub    $0x57,%eax
c0105f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f8c:	eb 23                	jmp    c0105fb1 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f91:	0f b6 00             	movzbl (%eax),%eax
c0105f94:	3c 40                	cmp    $0x40,%al
c0105f96:	7e 3d                	jle    c0105fd5 <strtol+0x13e>
c0105f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f9b:	0f b6 00             	movzbl (%eax),%eax
c0105f9e:	3c 5a                	cmp    $0x5a,%al
c0105fa0:	7f 33                	jg     c0105fd5 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa5:	0f b6 00             	movzbl (%eax),%eax
c0105fa8:	0f be c0             	movsbl %al,%eax
c0105fab:	83 e8 37             	sub    $0x37,%eax
c0105fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fb4:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105fb7:	7c 02                	jl     c0105fbb <strtol+0x124>
            break;
c0105fb9:	eb 1a                	jmp    c0105fd5 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105fbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fc2:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105fc6:	89 c2                	mov    %eax,%edx
c0105fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fcb:	01 d0                	add    %edx,%eax
c0105fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105fd0:	e9 6f ff ff ff       	jmp    c0105f44 <strtol+0xad>

    if (endptr) {
c0105fd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105fd9:	74 08                	je     c0105fe3 <strtol+0x14c>
        *endptr = (char *) s;
c0105fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fde:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fe1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105fe7:	74 07                	je     c0105ff0 <strtol+0x159>
c0105fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fec:	f7 d8                	neg    %eax
c0105fee:	eb 03                	jmp    c0105ff3 <strtol+0x15c>
c0105ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105ff3:	c9                   	leave  
c0105ff4:	c3                   	ret    

c0105ff5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105ff5:	55                   	push   %ebp
c0105ff6:	89 e5                	mov    %esp,%ebp
c0105ff8:	57                   	push   %edi
c0105ff9:	83 ec 24             	sub    $0x24,%esp
c0105ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106002:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0106006:	8b 55 08             	mov    0x8(%ebp),%edx
c0106009:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010600c:	88 45 f7             	mov    %al,-0x9(%ebp)
c010600f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106012:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0106015:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0106018:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010601c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010601f:	89 d7                	mov    %edx,%edi
c0106021:	f3 aa                	rep stos %al,%es:(%edi)
c0106023:	89 fa                	mov    %edi,%edx
c0106025:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106028:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010602b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010602e:	83 c4 24             	add    $0x24,%esp
c0106031:	5f                   	pop    %edi
c0106032:	5d                   	pop    %ebp
c0106033:	c3                   	ret    

c0106034 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106034:	55                   	push   %ebp
c0106035:	89 e5                	mov    %esp,%ebp
c0106037:	57                   	push   %edi
c0106038:	56                   	push   %esi
c0106039:	53                   	push   %ebx
c010603a:	83 ec 30             	sub    $0x30,%esp
c010603d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106040:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106043:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106046:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106049:	8b 45 10             	mov    0x10(%ebp),%eax
c010604c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010604f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106052:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106055:	73 42                	jae    c0106099 <memmove+0x65>
c0106057:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010605a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010605d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106060:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106063:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106066:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106069:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010606c:	c1 e8 02             	shr    $0x2,%eax
c010606f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106074:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106077:	89 d7                	mov    %edx,%edi
c0106079:	89 c6                	mov    %eax,%esi
c010607b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010607d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106080:	83 e1 03             	and    $0x3,%ecx
c0106083:	74 02                	je     c0106087 <memmove+0x53>
c0106085:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106087:	89 f0                	mov    %esi,%eax
c0106089:	89 fa                	mov    %edi,%edx
c010608b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010608e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106091:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0106094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106097:	eb 36                	jmp    c01060cf <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106099:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010609c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010609f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060a2:	01 c2                	add    %eax,%edx
c01060a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060a7:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01060aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ad:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01060b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060b3:	89 c1                	mov    %eax,%ecx
c01060b5:	89 d8                	mov    %ebx,%eax
c01060b7:	89 d6                	mov    %edx,%esi
c01060b9:	89 c7                	mov    %eax,%edi
c01060bb:	fd                   	std    
c01060bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01060be:	fc                   	cld    
c01060bf:	89 f8                	mov    %edi,%eax
c01060c1:	89 f2                	mov    %esi,%edx
c01060c3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01060c6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01060c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01060cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01060cf:	83 c4 30             	add    $0x30,%esp
c01060d2:	5b                   	pop    %ebx
c01060d3:	5e                   	pop    %esi
c01060d4:	5f                   	pop    %edi
c01060d5:	5d                   	pop    %ebp
c01060d6:	c3                   	ret    

c01060d7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01060d7:	55                   	push   %ebp
c01060d8:	89 e5                	mov    %esp,%ebp
c01060da:	57                   	push   %edi
c01060db:	56                   	push   %esi
c01060dc:	83 ec 20             	sub    $0x20,%esp
c01060df:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01060ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01060f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060f4:	c1 e8 02             	shr    $0x2,%eax
c01060f7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01060f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ff:	89 d7                	mov    %edx,%edi
c0106101:	89 c6                	mov    %eax,%esi
c0106103:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106105:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106108:	83 e1 03             	and    $0x3,%ecx
c010610b:	74 02                	je     c010610f <memcpy+0x38>
c010610d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010610f:	89 f0                	mov    %esi,%eax
c0106111:	89 fa                	mov    %edi,%edx
c0106113:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106116:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106119:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010611c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010611f:	83 c4 20             	add    $0x20,%esp
c0106122:	5e                   	pop    %esi
c0106123:	5f                   	pop    %edi
c0106124:	5d                   	pop    %ebp
c0106125:	c3                   	ret    

c0106126 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106126:	55                   	push   %ebp
c0106127:	89 e5                	mov    %esp,%ebp
c0106129:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010612c:	8b 45 08             	mov    0x8(%ebp),%eax
c010612f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106132:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106135:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106138:	eb 30                	jmp    c010616a <memcmp+0x44>
        if (*s1 != *s2) {
c010613a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010613d:	0f b6 10             	movzbl (%eax),%edx
c0106140:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106143:	0f b6 00             	movzbl (%eax),%eax
c0106146:	38 c2                	cmp    %al,%dl
c0106148:	74 18                	je     c0106162 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010614a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010614d:	0f b6 00             	movzbl (%eax),%eax
c0106150:	0f b6 d0             	movzbl %al,%edx
c0106153:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106156:	0f b6 00             	movzbl (%eax),%eax
c0106159:	0f b6 c0             	movzbl %al,%eax
c010615c:	29 c2                	sub    %eax,%edx
c010615e:	89 d0                	mov    %edx,%eax
c0106160:	eb 1a                	jmp    c010617c <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0106162:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106166:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010616a:	8b 45 10             	mov    0x10(%ebp),%eax
c010616d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106170:	89 55 10             	mov    %edx,0x10(%ebp)
c0106173:	85 c0                	test   %eax,%eax
c0106175:	75 c3                	jne    c010613a <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106177:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010617c:	c9                   	leave  
c010617d:	c3                   	ret    
