
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 c0 11 40       	mov    $0x4011c000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 c0 11 00       	mov    %eax,0x11c000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 b0 11 00       	mov    $0x11b000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void)
{
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  100041:	2d 36 ba 11 00       	sub    $0x11ba36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 ba 11 00 	movl   $0x11ba36,(%esp)
  100059:	e8 f8 6a 00 00       	call   106b56 <memset>

    cons_init(); // init the console
  10005e:	e8 f9 15 00 00       	call   10165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 00 6d 10 00 	movl   $0x106d00,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 1c 6d 10 00 	movl   $0x106d1c,(%esp)
  100078:	e8 e8 02 00 00       	call   100365 <cprintf>

    print_kerninfo();
  10007d:	e8 06 08 00 00       	call   100888 <print_kerninfo>

    grade_backtrace();
  100082:	e8 95 00 00 00       	call   10011c <grade_backtrace>

    pmm_init(); // init physical memory management
  100087:	e8 41 50 00 00       	call   1050cd <pmm_init>

    pic_init(); // init interrupt controller
  10008c:	e8 4c 17 00 00       	call   1017dd <pic_init>
    idt_init(); // init interrupt descriptor table
  100091:	e8 d3 18 00 00       	call   101969 <idt_init>

    clock_init();  // init clock interrupt
  100096:	e8 20 0d 00 00       	call   100dbb <clock_init>
    intr_enable(); // enable irq interrupt
  10009b:	e8 9b 16 00 00       	call   10173b <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    lab1_switch_test();
  1000a0:	e8 75 01 00 00       	call   10021a <lab1_switch_test>

    /* do nothing */
    while (1)
  1000a5:	eb fe                	jmp    1000a5 <kern_init+0x6f>

001000a7 <grade_backtrace2>:
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
  1000a7:	55                   	push   %ebp
  1000a8:	89 e5                	mov    %esp,%ebp
  1000aa:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b4:	00 
  1000b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bc:	00 
  1000bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c4:	e8 0d 0c 00 00       	call   100cd6 <mon_backtrace>
}
  1000c9:	90                   	nop
  1000ca:	89 ec                	mov    %ebp,%esp
  1000cc:	5d                   	pop    %ebp
  1000cd:	c3                   	ret    

001000ce <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
  1000ce:	55                   	push   %ebp
  1000cf:	89 e5                	mov    %esp,%ebp
  1000d1:	83 ec 18             	sub    $0x18,%esp
  1000d4:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ef:	89 04 24             	mov    %eax,(%esp)
  1000f2:	e8 b0 ff ff ff       	call   1000a7 <grade_backtrace2>
}
  1000f7:	90                   	nop
  1000f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000fb:	89 ec                	mov    %ebp,%esp
  1000fd:	5d                   	pop    %ebp
  1000fe:	c3                   	ret    

001000ff <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
  1000ff:	55                   	push   %ebp
  100100:	89 e5                	mov    %esp,%ebp
  100102:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100105:	8b 45 10             	mov    0x10(%ebp),%eax
  100108:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010c:	8b 45 08             	mov    0x8(%ebp),%eax
  10010f:	89 04 24             	mov    %eax,(%esp)
  100112:	e8 b7 ff ff ff       	call   1000ce <grade_backtrace1>
}
  100117:	90                   	nop
  100118:	89 ec                	mov    %ebp,%esp
  10011a:	5d                   	pop    %ebp
  10011b:	c3                   	ret    

0010011c <grade_backtrace>:

void grade_backtrace(void)
{
  10011c:	55                   	push   %ebp
  10011d:	89 e5                	mov    %esp,%ebp
  10011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100122:	b8 36 00 10 00       	mov    $0x100036,%eax
  100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10012e:	ff 
  10012f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10013a:	e8 c0 ff ff ff       	call   1000ff <grade_backtrace0>
}
  10013f:	90                   	nop
  100140:	89 ec                	mov    %ebp,%esp
  100142:	5d                   	pop    %ebp
  100143:	c3                   	ret    

00100144 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
  100144:	55                   	push   %ebp
  100145:	89 e5                	mov    %esp,%ebp
  100147:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
  10014a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10014d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100150:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100153:	8c 55 f0             	mov    %ss,-0x10(%ebp)
        "mov %%cs, %0;"
        "mov %%ds, %1;"
        "mov %%es, %2;"
        "mov %%ss, %3;"
        : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100156:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10015a:	83 e0 03             	and    $0x3,%eax
  10015d:	89 c2                	mov    %eax,%edx
  10015f:	a1 00 e0 11 00       	mov    0x11e000,%eax
  100164:	89 54 24 08          	mov    %edx,0x8(%esp)
  100168:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016c:	c7 04 24 21 6d 10 00 	movl   $0x106d21,(%esp)
  100173:	e8 ed 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10017c:	89 c2                	mov    %eax,%edx
  10017e:	a1 00 e0 11 00       	mov    0x11e000,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 2f 6d 10 00 	movl   $0x106d2f,(%esp)
  100192:	e8 ce 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10019b:	89 c2                	mov    %eax,%edx
  10019d:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001aa:	c7 04 24 3d 6d 10 00 	movl   $0x106d3d,(%esp)
  1001b1:	e8 af 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ba:	89 c2                	mov    %eax,%edx
  1001bc:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c9:	c7 04 24 4b 6d 10 00 	movl   $0x106d4b,(%esp)
  1001d0:	e8 90 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d9:	89 c2                	mov    %eax,%edx
  1001db:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e8:	c7 04 24 59 6d 10 00 	movl   $0x106d59,(%esp)
  1001ef:	e8 71 01 00 00       	call   100365 <cprintf>
    round++;
  1001f4:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001f9:	40                   	inc    %eax
  1001fa:	a3 00 e0 11 00       	mov    %eax,0x11e000
}
  1001ff:	90                   	nop
  100200:	89 ec                	mov    %ebp,%esp
  100202:	5d                   	pop    %ebp
  100203:	c3                   	ret    

00100204 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
  100204:	55                   	push   %ebp
  100205:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 : TODO
    asm volatile(
  100207:	16                   	push   %ss
  100208:	54                   	push   %esp
  100209:	cd 78                	int    $0x78
  10020b:	89 ec                	mov    %ebp,%esp
        "pushl %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU));
}
  10020d:	90                   	nop
  10020e:	5d                   	pop    %ebp
  10020f:	c3                   	ret    

00100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  100213:	cd 79                	int    $0x79
  100215:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK));
}
  100217:	90                   	nop
  100218:	5d                   	pop    %ebp
  100219:	c3                   	ret    

0010021a <lab1_switch_test>:

static void
lab1_switch_test(void)
{
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
  10021d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100220:	e8 1f ff ff ff       	call   100144 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100225:	c7 04 24 68 6d 10 00 	movl   $0x106d68,(%esp)
  10022c:	e8 34 01 00 00       	call   100365 <cprintf>
    lab1_switch_to_user();
  100231:	e8 ce ff ff ff       	call   100204 <lab1_switch_to_user>
    lab1_print_cur_status();
  100236:	e8 09 ff ff ff       	call   100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10023b:	c7 04 24 88 6d 10 00 	movl   $0x106d88,(%esp)
  100242:	e8 1e 01 00 00       	call   100365 <cprintf>
    lab1_switch_to_kernel();
  100247:	e8 c4 ff ff ff       	call   100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10024c:	e8 f3 fe ff ff       	call   100144 <lab1_print_cur_status>
}
  100251:	90                   	nop
  100252:	89 ec                	mov    %ebp,%esp
  100254:	5d                   	pop    %ebp
  100255:	c3                   	ret    

00100256 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100256:	55                   	push   %ebp
  100257:	89 e5                	mov    %esp,%ebp
  100259:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10025c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100260:	74 13                	je     100275 <readline+0x1f>
        cprintf("%s", prompt);
  100262:	8b 45 08             	mov    0x8(%ebp),%eax
  100265:	89 44 24 04          	mov    %eax,0x4(%esp)
  100269:	c7 04 24 a7 6d 10 00 	movl   $0x106da7,(%esp)
  100270:	e8 f0 00 00 00       	call   100365 <cprintf>
    }
    int i = 0, c;
  100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10027c:	e8 73 01 00 00       	call   1003f4 <getchar>
  100281:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100288:	79 07                	jns    100291 <readline+0x3b>
            return NULL;
  10028a:	b8 00 00 00 00       	mov    $0x0,%eax
  10028f:	eb 78                	jmp    100309 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100291:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100295:	7e 28                	jle    1002bf <readline+0x69>
  100297:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10029e:	7f 1f                	jg     1002bf <readline+0x69>
            cputchar(c);
  1002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a3:	89 04 24             	mov    %eax,(%esp)
  1002a6:	e8 e2 00 00 00       	call   10038d <cputchar>
            buf[i ++] = c;
  1002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002ae:	8d 50 01             	lea    0x1(%eax),%edx
  1002b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002b7:	88 90 20 e0 11 00    	mov    %dl,0x11e020(%eax)
  1002bd:	eb 45                	jmp    100304 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002bf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002c3:	75 16                	jne    1002db <readline+0x85>
  1002c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002c9:	7e 10                	jle    1002db <readline+0x85>
            cputchar(c);
  1002cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ce:	89 04 24             	mov    %eax,(%esp)
  1002d1:	e8 b7 00 00 00       	call   10038d <cputchar>
            i --;
  1002d6:	ff 4d f4             	decl   -0xc(%ebp)
  1002d9:	eb 29                	jmp    100304 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002db:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002df:	74 06                	je     1002e7 <readline+0x91>
  1002e1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002e5:	75 95                	jne    10027c <readline+0x26>
            cputchar(c);
  1002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ea:	89 04 24             	mov    %eax,(%esp)
  1002ed:	e8 9b 00 00 00       	call   10038d <cputchar>
            buf[i] = '\0';
  1002f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002f5:	05 20 e0 11 00       	add    $0x11e020,%eax
  1002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002fd:	b8 20 e0 11 00       	mov    $0x11e020,%eax
  100302:	eb 05                	jmp    100309 <readline+0xb3>
        c = getchar();
  100304:	e9 73 ff ff ff       	jmp    10027c <readline+0x26>
        }
    }
}
  100309:	89 ec                	mov    %ebp,%esp
  10030b:	5d                   	pop    %ebp
  10030c:	c3                   	ret    

0010030d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10030d:	55                   	push   %ebp
  10030e:	89 e5                	mov    %esp,%ebp
  100310:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100313:	8b 45 08             	mov    0x8(%ebp),%eax
  100316:	89 04 24             	mov    %eax,(%esp)
  100319:	e8 6d 13 00 00       	call   10168b <cons_putc>
    (*cnt) ++;
  10031e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100321:	8b 00                	mov    (%eax),%eax
  100323:	8d 50 01             	lea    0x1(%eax),%edx
  100326:	8b 45 0c             	mov    0xc(%ebp),%eax
  100329:	89 10                	mov    %edx,(%eax)
}
  10032b:	90                   	nop
  10032c:	89 ec                	mov    %ebp,%esp
  10032e:	5d                   	pop    %ebp
  10032f:	c3                   	ret    

00100330 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100330:	55                   	push   %ebp
  100331:	89 e5                	mov    %esp,%ebp
  100333:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100340:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100344:	8b 45 08             	mov    0x8(%ebp),%eax
  100347:	89 44 24 08          	mov    %eax,0x8(%esp)
  10034b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10034e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100352:	c7 04 24 0d 03 10 00 	movl   $0x10030d,(%esp)
  100359:	e8 23 60 00 00       	call   106381 <vprintfmt>
    return cnt;
  10035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100361:	89 ec                	mov    %ebp,%esp
  100363:	5d                   	pop    %ebp
  100364:	c3                   	ret    

00100365 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100365:	55                   	push   %ebp
  100366:	89 e5                	mov    %esp,%ebp
  100368:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10036b:	8d 45 0c             	lea    0xc(%ebp),%eax
  10036e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100374:	89 44 24 04          	mov    %eax,0x4(%esp)
  100378:	8b 45 08             	mov    0x8(%ebp),%eax
  10037b:	89 04 24             	mov    %eax,(%esp)
  10037e:	e8 ad ff ff ff       	call   100330 <vcprintf>
  100383:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100389:	89 ec                	mov    %ebp,%esp
  10038b:	5d                   	pop    %ebp
  10038c:	c3                   	ret    

0010038d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10038d:	55                   	push   %ebp
  10038e:	89 e5                	mov    %esp,%ebp
  100390:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100393:	8b 45 08             	mov    0x8(%ebp),%eax
  100396:	89 04 24             	mov    %eax,(%esp)
  100399:	e8 ed 12 00 00       	call   10168b <cons_putc>
}
  10039e:	90                   	nop
  10039f:	89 ec                	mov    %ebp,%esp
  1003a1:	5d                   	pop    %ebp
  1003a2:	c3                   	ret    

001003a3 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1003a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003b0:	eb 13                	jmp    1003c5 <cputs+0x22>
        cputch(c, &cnt);
  1003b2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003b6:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003bd:	89 04 24             	mov    %eax,(%esp)
  1003c0:	e8 48 ff ff ff       	call   10030d <cputch>
    while ((c = *str ++) != '\0') {
  1003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1003c8:	8d 50 01             	lea    0x1(%eax),%edx
  1003cb:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ce:	0f b6 00             	movzbl (%eax),%eax
  1003d1:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003d4:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003d8:	75 d8                	jne    1003b2 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003e8:	e8 20 ff ff ff       	call   10030d <cputch>
    return cnt;
  1003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003f0:	89 ec                	mov    %ebp,%esp
  1003f2:	5d                   	pop    %ebp
  1003f3:	c3                   	ret    

001003f4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003f4:	55                   	push   %ebp
  1003f5:	89 e5                	mov    %esp,%ebp
  1003f7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003fa:	90                   	nop
  1003fb:	e8 ca 12 00 00       	call   1016ca <cons_getc>
  100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100407:	74 f2                	je     1003fb <getchar+0x7>
        /* do nothing */;
    return c;
  100409:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10040c:	89 ec                	mov    %ebp,%esp
  10040e:	5d                   	pop    %ebp
  10040f:	c3                   	ret    

00100410 <stab_binsearch>:
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr)
{
  100410:	55                   	push   %ebp
  100411:	89 e5                	mov    %esp,%ebp
  100413:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100416:	8b 45 0c             	mov    0xc(%ebp),%eax
  100419:	8b 00                	mov    (%eax),%eax
  10041b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10041e:	8b 45 10             	mov    0x10(%ebp),%eax
  100421:	8b 00                	mov    (%eax),%eax
  100423:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r)
  10042d:	e9 ca 00 00 00       	jmp    1004fc <stab_binsearch+0xec>
    {
        int true_m = (l + r) / 2, m = true_m;
  100432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100435:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	89 c2                	mov    %eax,%edx
  10043c:	c1 ea 1f             	shr    $0x1f,%edx
  10043f:	01 d0                	add    %edx,%eax
  100441:	d1 f8                	sar    %eax
  100443:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100449:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
  10044c:	eb 03                	jmp    100451 <stab_binsearch+0x41>
        {
            m--;
  10044e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type)
  100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100457:	7c 1f                	jl     100478 <stab_binsearch+0x68>
  100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045c:	89 d0                	mov    %edx,%eax
  10045e:	01 c0                	add    %eax,%eax
  100460:	01 d0                	add    %edx,%eax
  100462:	c1 e0 02             	shl    $0x2,%eax
  100465:	89 c2                	mov    %eax,%edx
  100467:	8b 45 08             	mov    0x8(%ebp),%eax
  10046a:	01 d0                	add    %edx,%eax
  10046c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100470:	0f b6 c0             	movzbl %al,%eax
  100473:	39 45 14             	cmp    %eax,0x14(%ebp)
  100476:	75 d6                	jne    10044e <stab_binsearch+0x3e>
        }
        if (m < l)
  100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10047b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10047e:	7d 09                	jge    100489 <stab_binsearch+0x79>
        { // no match in [l, m]
            l = true_m + 1;
  100480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100483:	40                   	inc    %eax
  100484:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100487:	eb 73                	jmp    1004fc <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100489:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr)
  100490:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100493:	89 d0                	mov    %edx,%eax
  100495:	01 c0                	add    %eax,%eax
  100497:	01 d0                	add    %edx,%eax
  100499:	c1 e0 02             	shl    $0x2,%eax
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	8b 45 08             	mov    0x8(%ebp),%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	8b 40 08             	mov    0x8(%eax),%eax
  1004a6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a9:	76 11                	jbe    1004bc <stab_binsearch+0xac>
        {
            *region_left = m;
  1004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b6:	40                   	inc    %eax
  1004b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ba:	eb 40                	jmp    1004fc <stab_binsearch+0xec>
        }
        else if (stabs[m].n_value > addr)
  1004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bf:	89 d0                	mov    %edx,%eax
  1004c1:	01 c0                	add    %eax,%eax
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	c1 e0 02             	shl    $0x2,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	8b 40 08             	mov    0x8(%eax),%eax
  1004d2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004d5:	73 14                	jae    1004eb <stab_binsearch+0xdb>
        {
            *region_right = m - 1;
  1004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004da:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e5:	48                   	dec    %eax
  1004e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004e9:	eb 11                	jmp    1004fc <stab_binsearch+0xec>
        }
        else
        {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr++;
  1004f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r)
  1004fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100502:	0f 8e 2a ff ff ff    	jle    100432 <stab_binsearch+0x22>
        }
    }

    if (!any_matches)
  100508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10050c:	75 0f                	jne    10051d <stab_binsearch+0x10d>
    {
        *region_right = *region_left - 1;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	8d 50 ff             	lea    -0x1(%eax),%edx
  100516:	8b 45 10             	mov    0x10(%ebp),%eax
  100519:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l--)
            /* do nothing */;
        *region_left = l;
    }
}
  10051b:	eb 3e                	jmp    10055b <stab_binsearch+0x14b>
        l = *region_right;
  10051d:	8b 45 10             	mov    0x10(%ebp),%eax
  100520:	8b 00                	mov    (%eax),%eax
  100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l--)
  100525:	eb 03                	jmp    10052a <stab_binsearch+0x11a>
  100527:	ff 4d fc             	decl   -0x4(%ebp)
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 00                	mov    (%eax),%eax
  10052f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100532:	7e 1f                	jle    100553 <stab_binsearch+0x143>
  100534:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100537:	89 d0                	mov    %edx,%eax
  100539:	01 c0                	add    %eax,%eax
  10053b:	01 d0                	add    %edx,%eax
  10053d:	c1 e0 02             	shl    $0x2,%eax
  100540:	89 c2                	mov    %eax,%edx
  100542:	8b 45 08             	mov    0x8(%ebp),%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10054b:	0f b6 c0             	movzbl %al,%eax
  10054e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100551:	75 d4                	jne    100527 <stab_binsearch+0x117>
        *region_left = l;
  100553:	8b 45 0c             	mov    0xc(%ebp),%eax
  100556:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100559:	89 10                	mov    %edx,(%eax)
}
  10055b:	90                   	nop
  10055c:	89 ec                	mov    %ebp,%esp
  10055e:	5d                   	pop    %ebp
  10055f:	c3                   	ret    

00100560 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info)
{
  100560:	55                   	push   %ebp
  100561:	89 e5                	mov    %esp,%ebp
  100563:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100566:	8b 45 0c             	mov    0xc(%ebp),%eax
  100569:	c7 00 ac 6d 10 00    	movl   $0x106dac,(%eax)
    info->eip_line = 0;
  10056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 08 ac 6d 10 00 	movl   $0x106dac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100583:	8b 45 0c             	mov    0xc(%ebp),%eax
  100586:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10058d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100590:	8b 55 08             	mov    0x8(%ebp),%edx
  100593:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100596:	8b 45 0c             	mov    0xc(%ebp),%eax
  100599:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005a0:	c7 45 f4 78 82 10 00 	movl   $0x108278,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a7:	c7 45 f0 74 4c 11 00 	movl   $0x114c74,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ae:	c7 45 ec 75 4c 11 00 	movl   $0x114c75,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b5:	c7 45 e8 32 85 11 00 	movl   $0x118532,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
  1005bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005c2:	76 0b                	jbe    1005cf <debuginfo_eip+0x6f>
  1005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005c7:	48                   	dec    %eax
  1005c8:	0f b6 00             	movzbl (%eax),%eax
  1005cb:	84 c0                	test   %al,%al
  1005cd:	74 0a                	je     1005d9 <debuginfo_eip+0x79>
    {
        return -1;
  1005cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d4:	e9 ab 02 00 00       	jmp    100884 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005e6:	c1 f8 02             	sar    $0x2,%eax
  1005e9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ef:	48                   	dec    %eax
  1005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fa:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100601:	00 
  100602:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100605:	89 44 24 08          	mov    %eax,0x8(%esp)
  100609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100613:	89 04 24             	mov    %eax,(%esp)
  100616:	e8 f5 fd ff ff       	call   100410 <stab_binsearch>
    if (lfile == 0)
  10061b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10061e:	85 c0                	test   %eax,%eax
  100620:	75 0a                	jne    10062c <debuginfo_eip+0xcc>
        return -1;
  100622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100627:	e9 58 02 00 00       	jmp    100884 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10062c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10062f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100635:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100638:	8b 45 08             	mov    0x8(%ebp),%eax
  10063b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10063f:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100646:	00 
  100647:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10064a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10064e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100651:	89 44 24 04          	mov    %eax,0x4(%esp)
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	89 04 24             	mov    %eax,(%esp)
  10065b:	e8 b0 fd ff ff       	call   100410 <stab_binsearch>

    if (lfun <= rfun)
  100660:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100663:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	7f 78                	jg     1006e2 <debuginfo_eip+0x182>
    {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
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
  100681:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100684:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100687:	39 c2                	cmp    %eax,%edx
  100689:	73 22                	jae    1006ad <debuginfo_eip+0x14d>
        {
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10068b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068e:	89 c2                	mov    %eax,%edx
  100690:	89 d0                	mov    %edx,%eax
  100692:	01 c0                	add    %eax,%eax
  100694:	01 d0                	add    %edx,%eax
  100696:	c1 e0 02             	shl    $0x2,%eax
  100699:	89 c2                	mov    %eax,%edx
  10069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069e:	01 d0                	add    %edx,%eax
  1006a0:	8b 10                	mov    (%eax),%edx
  1006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006a5:	01 c2                	add    %eax,%edx
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b0:	89 c2                	mov    %eax,%edx
  1006b2:	89 d0                	mov    %edx,%eax
  1006b4:	01 c0                	add    %eax,%eax
  1006b6:	01 d0                	add    %edx,%eax
  1006b8:	c1 e0 02             	shl    $0x2,%eax
  1006bb:	89 c2                	mov    %eax,%edx
  1006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006c0:	01 d0                	add    %edx,%eax
  1006c2:	8b 50 08             	mov    0x8(%eax),%edx
  1006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c8:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ce:	8b 40 10             	mov    0x10(%eax),%eax
  1006d1:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006e0:	eb 15                	jmp    1006f7 <debuginfo_eip+0x197>
    }
    else
    {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1006e8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fa:	8b 40 08             	mov    0x8(%eax),%eax
  1006fd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100704:	00 
  100705:	89 04 24             	mov    %eax,(%esp)
  100708:	e8 c1 62 00 00       	call   1069ce <strfind>
  10070d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100710:	8b 4a 08             	mov    0x8(%edx),%ecx
  100713:	29 c8                	sub    %ecx,%eax
  100715:	89 c2                	mov    %eax,%edx
  100717:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071a:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10071d:	8b 45 08             	mov    0x8(%ebp),%eax
  100720:	89 44 24 10          	mov    %eax,0x10(%esp)
  100724:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10072b:	00 
  10072c:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10072f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100733:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100736:	89 44 24 04          	mov    %eax,0x4(%esp)
  10073a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073d:	89 04 24             	mov    %eax,(%esp)
  100740:	e8 cb fc ff ff       	call   100410 <stab_binsearch>
    if (lline <= rline)
  100745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100748:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10074b:	39 c2                	cmp    %eax,%edx
  10074d:	7f 23                	jg     100772 <debuginfo_eip+0x212>
    {
        info->eip_line = stabs[rline].n_desc;
  10074f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100752:	89 c2                	mov    %eax,%edx
  100754:	89 d0                	mov    %edx,%eax
  100756:	01 c0                	add    %eax,%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	c1 e0 02             	shl    $0x2,%eax
  10075d:	89 c2                	mov    %eax,%edx
  10075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100762:	01 d0                	add    %edx,%eax
  100764:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100768:	89 c2                	mov    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  100770:	eb 11                	jmp    100783 <debuginfo_eip+0x223>
        return -1;
  100772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100777:	e9 08 01 00 00       	jmp    100884 <debuginfo_eip+0x324>
    {
        lline--;
  10077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077f:	48                   	dec    %eax
  100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
  100783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	7c 56                	jl     1007e3 <debuginfo_eip+0x283>
  10078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a6:	3c 84                	cmp    $0x84,%al
  1007a8:	74 39                	je     1007e3 <debuginfo_eip+0x283>
  1007aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	89 d0                	mov    %edx,%eax
  1007b1:	01 c0                	add    %eax,%eax
  1007b3:	01 d0                	add    %edx,%eax
  1007b5:	c1 e0 02             	shl    $0x2,%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007c3:	3c 64                	cmp    $0x64,%al
  1007c5:	75 b5                	jne    10077c <debuginfo_eip+0x21c>
  1007c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ca:	89 c2                	mov    %eax,%edx
  1007cc:	89 d0                	mov    %edx,%eax
  1007ce:	01 c0                	add    %eax,%eax
  1007d0:	01 d0                	add    %edx,%eax
  1007d2:	c1 e0 02             	shl    $0x2,%eax
  1007d5:	89 c2                	mov    %eax,%edx
  1007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007da:	01 d0                	add    %edx,%eax
  1007dc:	8b 40 08             	mov    0x8(%eax),%eax
  1007df:	85 c0                	test   %eax,%eax
  1007e1:	74 99                	je     10077c <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
  1007e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e9:	39 c2                	cmp    %eax,%edx
  1007eb:	7c 42                	jl     10082f <debuginfo_eip+0x2cf>
  1007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	89 d0                	mov    %edx,%eax
  1007f4:	01 c0                	add    %eax,%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	c1 e0 02             	shl    $0x2,%eax
  1007fb:	89 c2                	mov    %eax,%edx
  1007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100800:	01 d0                	add    %edx,%eax
  100802:	8b 10                	mov    (%eax),%edx
  100804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100807:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10080a:	39 c2                	cmp    %eax,%edx
  10080c:	73 21                	jae    10082f <debuginfo_eip+0x2cf>
    {
        info->eip_file = stabstr + stabs[lline].n_strx;
  10080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100811:	89 c2                	mov    %eax,%edx
  100813:	89 d0                	mov    %edx,%eax
  100815:	01 c0                	add    %eax,%eax
  100817:	01 d0                	add    %edx,%eax
  100819:	c1 e0 02             	shl    $0x2,%eax
  10081c:	89 c2                	mov    %eax,%edx
  10081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100821:	01 d0                	add    %edx,%eax
  100823:	8b 10                	mov    (%eax),%edx
  100825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100828:	01 c2                	add    %eax,%edx
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
  10082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100832:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100835:	39 c2                	cmp    %eax,%edx
  100837:	7d 46                	jge    10087f <debuginfo_eip+0x31f>
    {
        for (lline = lfun + 1;
  100839:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10083c:	40                   	inc    %eax
  10083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100840:	eb 16                	jmp    100858 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
        {
            info->eip_fn_narg++;
  100842:	8b 45 0c             	mov    0xc(%ebp),%eax
  100845:	8b 40 14             	mov    0x14(%eax),%eax
  100848:	8d 50 01             	lea    0x1(%eax),%edx
  10084b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10084e:	89 50 14             	mov    %edx,0x14(%eax)
             lline++)
  100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100854:	40                   	inc    %eax
  100855:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10085b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10085e:	39 c2                	cmp    %eax,%edx
  100860:	7d 1d                	jge    10087f <debuginfo_eip+0x31f>
  100862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100865:	89 c2                	mov    %eax,%edx
  100867:	89 d0                	mov    %edx,%eax
  100869:	01 c0                	add    %eax,%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	c1 e0 02             	shl    $0x2,%eax
  100870:	89 c2                	mov    %eax,%edx
  100872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100875:	01 d0                	add    %edx,%eax
  100877:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10087b:	3c a0                	cmp    $0xa0,%al
  10087d:	74 c3                	je     100842 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10087f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100884:	89 ec                	mov    %ebp,%esp
  100886:	5d                   	pop    %ebp
  100887:	c3                   	ret    

00100888 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
  100888:	55                   	push   %ebp
  100889:	89 e5                	mov    %esp,%ebp
  10088b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10088e:	c7 04 24 b6 6d 10 00 	movl   $0x106db6,(%esp)
  100895:	e8 cb fa ff ff       	call   100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10089a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1008a1:	00 
  1008a2:	c7 04 24 cf 6d 10 00 	movl   $0x106dcf,(%esp)
  1008a9:	e8 b7 fa ff ff       	call   100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ae:	c7 44 24 04 e2 6c 10 	movl   $0x106ce2,0x4(%esp)
  1008b5:	00 
  1008b6:	c7 04 24 e7 6d 10 00 	movl   $0x106de7,(%esp)
  1008bd:	e8 a3 fa ff ff       	call   100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008c2:	c7 44 24 04 36 ba 11 	movl   $0x11ba36,0x4(%esp)
  1008c9:	00 
  1008ca:	c7 04 24 ff 6d 10 00 	movl   $0x106dff,(%esp)
  1008d1:	e8 8f fa ff ff       	call   100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d6:	c7 44 24 04 2c ef 11 	movl   $0x11ef2c,0x4(%esp)
  1008dd:	00 
  1008de:	c7 04 24 17 6e 10 00 	movl   $0x106e17,(%esp)
  1008e5:	e8 7b fa ff ff       	call   100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
  1008ea:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  1008ef:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ff:	85 c0                	test   %eax,%eax
  100901:	0f 48 c2             	cmovs  %edx,%eax
  100904:	c1 f8 0a             	sar    $0xa,%eax
  100907:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090b:	c7 04 24 30 6e 10 00 	movl   $0x106e30,(%esp)
  100912:	e8 4e fa ff ff       	call   100365 <cprintf>
}
  100917:	90                   	nop
  100918:	89 ec                	mov    %ebp,%esp
  10091a:	5d                   	pop    %ebp
  10091b:	c3                   	ret    

0010091c <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void print_debuginfo(uintptr_t eip)
{
  10091c:	55                   	push   %ebp
  10091d:	89 e5                	mov    %esp,%ebp
  10091f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0)
  100925:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 04 24             	mov    %eax,(%esp)
  100932:	e8 29 fc ff ff       	call   100560 <debuginfo_eip>
  100937:	85 c0                	test   %eax,%eax
  100939:	74 15                	je     100950 <print_debuginfo+0x34>
    {
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10093b:	8b 45 08             	mov    0x8(%ebp),%eax
  10093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100942:	c7 04 24 5a 6e 10 00 	movl   $0x106e5a,(%esp)
  100949:	e8 17 fa ff ff       	call   100365 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10094e:	eb 6c                	jmp    1009bc <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j++)
  100950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100957:	eb 1b                	jmp    100974 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095f:	01 d0                	add    %edx,%eax
  100961:	0f b6 10             	movzbl (%eax),%edx
  100964:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10096d:	01 c8                	add    %ecx,%eax
  10096f:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j++)
  100971:	ff 45 f4             	incl   -0xc(%ebp)
  100974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100977:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10097a:	7c dd                	jl     100959 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10097c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100985:	01 d0                	add    %edx,%eax
  100987:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10098a:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10098d:	8b 45 08             	mov    0x8(%ebp),%eax
  100990:	29 d0                	sub    %edx,%eax
  100992:	89 c1                	mov    %eax,%ecx
  100994:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100997:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10099a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10099e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b0:	c7 04 24 76 6e 10 00 	movl   $0x106e76,(%esp)
  1009b7:	e8 a9 f9 ff ff       	call   100365 <cprintf>
}
  1009bc:	90                   	nop
  1009bd:	89 ec                	mov    %ebp,%esp
  1009bf:	5d                   	pop    %ebp
  1009c0:	c3                   	ret    

001009c1 <read_eip>:

static __noinline uint32_t
read_eip(void)
{
  1009c1:	55                   	push   %ebp
  1009c2:	89 e5                	mov    %esp,%ebp
  1009c4:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0"
  1009c7:	8b 45 04             	mov    0x4(%ebp),%eax
  1009ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(eip));
    return eip;
  1009cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009d0:	89 ec                	mov    %ebp,%esp
  1009d2:	5d                   	pop    %ebp
  1009d3:	c3                   	ret    

001009d4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void print_stackframe(void)
{
  1009d4:	55                   	push   %ebp
  1009d5:	89 e5                	mov    %esp,%ebp
  1009d7:	83 ec 38             	sub    $0x38,%esp

static inline uint32_t
read_ebp(void)
{
    uint32_t ebp;
    asm volatile("movl %%ebp, %0"
  1009da:	89 e8                	mov    %ebp,%eax
  1009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
                 : "=r"(ebp));
    return ebp;
  1009df:	8b 45 e0             	mov    -0x20(%ebp),%eax
     *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009e5:	e8 d7 ff ff ff       	call   1009c1 <read_eip>
  1009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  1009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f4:	e9 84 00 00 00       	jmp    100a7d <print_stackframe+0xa9>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 88 6e 10 00 	movl   $0x106e88,(%esp)
  100a0e:	e8 52 f9 ff ff       	call   100365 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a16:	83 c0 08             	add    $0x8,%eax
  100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j++)
  100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a23:	eb 24                	jmp    100a49 <print_stackframe+0x75>
        {
            cprintf("0x%08x ", args[j]);
  100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	01 d0                	add    %edx,%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3a:	c7 04 24 a4 6e 10 00 	movl   $0x106ea4,(%esp)
  100a41:	e8 1f f9 ff ff       	call   100365 <cprintf>
        for (j = 0; j < 4; j++)
  100a46:	ff 45 e8             	incl   -0x18(%ebp)
  100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4d:	7e d6                	jle    100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a4f:	c7 04 24 ac 6e 10 00 	movl   $0x106eac,(%esp)
  100a56:	e8 0a f9 ff ff       	call   100365 <cprintf>
        print_debuginfo(eip - 1);
  100a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5e:	48                   	dec    %eax
  100a5f:	89 04 24             	mov    %eax,(%esp)
  100a62:	e8 b5 fe ff ff       	call   10091c <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6a:	83 c0 04             	add    $0x4,%eax
  100a6d:	8b 00                	mov    (%eax),%eax
  100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a75:	8b 00                	mov    (%eax),%eax
  100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a7a:	ff 45 ec             	incl   -0x14(%ebp)
  100a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a81:	74 0a                	je     100a8d <print_stackframe+0xb9>
  100a83:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a87:	0f 8e 6c ff ff ff    	jle    1009f9 <print_stackframe+0x25>
    }
}
  100a8d:	90                   	nop
  100a8e:	89 ec                	mov    %ebp,%esp
  100a90:	5d                   	pop    %ebp
  100a91:	c3                   	ret    

00100a92 <parse>:
#define WHITESPACE " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv)
{
  100a92:	55                   	push   %ebp
  100a93:	89 e5                	mov    %esp,%ebp
  100a95:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1)
    {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
  100a9f:	eb 0c                	jmp    100aad <parse+0x1b>
        {
            *buf++ = '\0';
  100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa4:	8d 50 01             	lea    0x1(%eax),%edx
  100aa7:	89 55 08             	mov    %edx,0x8(%ebp)
  100aaa:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
  100aad:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab0:	0f b6 00             	movzbl (%eax),%eax
  100ab3:	84 c0                	test   %al,%al
  100ab5:	74 1d                	je     100ad4 <parse+0x42>
  100ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aba:	0f b6 00             	movzbl (%eax),%eax
  100abd:	0f be c0             	movsbl %al,%eax
  100ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac4:	c7 04 24 30 6f 10 00 	movl   $0x106f30,(%esp)
  100acb:	e8 ca 5e 00 00       	call   10699a <strchr>
  100ad0:	85 c0                	test   %eax,%eax
  100ad2:	75 cd                	jne    100aa1 <parse+0xf>
        }
        if (*buf == '\0')
  100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad7:	0f b6 00             	movzbl (%eax),%eax
  100ada:	84 c0                	test   %al,%al
  100adc:	74 65                	je     100b43 <parse+0xb1>
        {
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1)
  100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae2:	75 14                	jne    100af8 <parse+0x66>
        {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aeb:	00 
  100aec:	c7 04 24 35 6f 10 00 	movl   $0x106f35,(%esp)
  100af3:	e8 6d f8 ff ff       	call   100365 <cprintf>
        }
        argv[argc++] = buf;
  100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afb:	8d 50 01             	lea    0x1(%eax),%edx
  100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0b:	01 c2                	add    %eax,%edx
  100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
  100b12:	eb 03                	jmp    100b17 <parse+0x85>
        {
            buf++;
  100b14:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
  100b17:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1a:	0f b6 00             	movzbl (%eax),%eax
  100b1d:	84 c0                	test   %al,%al
  100b1f:	74 8c                	je     100aad <parse+0x1b>
  100b21:	8b 45 08             	mov    0x8(%ebp),%eax
  100b24:	0f b6 00             	movzbl (%eax),%eax
  100b27:	0f be c0             	movsbl %al,%eax
  100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2e:	c7 04 24 30 6f 10 00 	movl   $0x106f30,(%esp)
  100b35:	e8 60 5e 00 00       	call   10699a <strchr>
  100b3a:	85 c0                	test   %eax,%eax
  100b3c:	74 d6                	je     100b14 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
  100b3e:	e9 6a ff ff ff       	jmp    100aad <parse+0x1b>
            break;
  100b43:	90                   	nop
        }
    }
    return argc;
  100b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b47:	89 ec                	mov    %ebp,%esp
  100b49:	5d                   	pop    %ebp
  100b4a:	c3                   	ret    

00100b4b <runcmd>:
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf)
{
  100b4b:	55                   	push   %ebp
  100b4c:	89 e5                	mov    %esp,%ebp
  100b4e:	83 ec 68             	sub    $0x68,%esp
  100b51:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5e:	89 04 24             	mov    %eax,(%esp)
  100b61:	e8 2c ff ff ff       	call   100a92 <parse>
  100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0)
  100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b6d:	75 0a                	jne    100b79 <runcmd+0x2e>
    {
        return 0;
  100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b74:	e9 83 00 00 00       	jmp    100bfc <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i++)
  100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b80:	eb 5a                	jmp    100bdc <runcmd+0x91>
    {
        if (strcmp(commands[i].name, argv[0]) == 0)
  100b82:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b88:	89 c8                	mov    %ecx,%eax
  100b8a:	01 c0                	add    %eax,%eax
  100b8c:	01 c8                	add    %ecx,%eax
  100b8e:	c1 e0 02             	shl    $0x2,%eax
  100b91:	05 00 b0 11 00       	add    $0x11b000,%eax
  100b96:	8b 00                	mov    (%eax),%eax
  100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9c:	89 04 24             	mov    %eax,(%esp)
  100b9f:	e8 5a 5d 00 00       	call   1068fe <strcmp>
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	75 31                	jne    100bd9 <runcmd+0x8e>
        {
            return commands[i].func(argc - 1, argv + 1, tf);
  100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bab:	89 d0                	mov    %edx,%eax
  100bad:	01 c0                	add    %eax,%eax
  100baf:	01 d0                	add    %edx,%eax
  100bb1:	c1 e0 02             	shl    $0x2,%eax
  100bb4:	05 08 b0 11 00       	add    $0x11b008,%eax
  100bb9:	8b 10                	mov    (%eax),%edx
  100bbb:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bbe:	83 c0 04             	add    $0x4,%eax
  100bc1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bc4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	89 1c 24             	mov    %ebx,(%esp)
  100bd5:	ff d2                	call   *%edx
  100bd7:	eb 23                	jmp    100bfc <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i++)
  100bd9:	ff 45 f4             	incl   -0xc(%ebp)
  100bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdf:	83 f8 02             	cmp    $0x2,%eax
  100be2:	76 9e                	jbe    100b82 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100beb:	c7 04 24 53 6f 10 00 	movl   $0x106f53,(%esp)
  100bf2:	e8 6e f7 ff ff       	call   100365 <cprintf>
    return 0;
  100bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bff:	89 ec                	mov    %ebp,%esp
  100c01:	5d                   	pop    %ebp
  100c02:	c3                   	ret    

00100c03 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void kmonitor(struct trapframe *tf)
{
  100c03:	55                   	push   %ebp
  100c04:	89 e5                	mov    %esp,%ebp
  100c06:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c09:	c7 04 24 6c 6f 10 00 	movl   $0x106f6c,(%esp)
  100c10:	e8 50 f7 ff ff       	call   100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c15:	c7 04 24 94 6f 10 00 	movl   $0x106f94,(%esp)
  100c1c:	e8 44 f7 ff ff       	call   100365 <cprintf>

    if (tf != NULL)
  100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c25:	74 0b                	je     100c32 <kmonitor+0x2f>
    {
        print_trapframe(tf);
  100c27:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 f1 0e 00 00       	call   101b23 <print_trapframe>
    }

    char *buf;
    while (1)
    {
        if ((buf = readline("K> ")) != NULL)
  100c32:	c7 04 24 b9 6f 10 00 	movl   $0x106fb9,(%esp)
  100c39:	e8 18 f6 ff ff       	call   100256 <readline>
  100c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c45:	74 eb                	je     100c32 <kmonitor+0x2f>
        {
            if (runcmd(buf, tf) < 0)
  100c47:	8b 45 08             	mov    0x8(%ebp),%eax
  100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c51:	89 04 24             	mov    %eax,(%esp)
  100c54:	e8 f2 fe ff ff       	call   100b4b <runcmd>
  100c59:	85 c0                	test   %eax,%eax
  100c5b:	78 02                	js     100c5f <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL)
  100c5d:	eb d3                	jmp    100c32 <kmonitor+0x2f>
            {
                break;
  100c5f:	90                   	nop
            }
        }
    }
}
  100c60:	90                   	nop
  100c61:	89 ec                	mov    %ebp,%esp
  100c63:	5d                   	pop    %ebp
  100c64:	c3                   	ret    

00100c65 <mon_help>:

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
  100c65:	55                   	push   %ebp
  100c66:	89 e5                	mov    %esp,%ebp
  100c68:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i++)
  100c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c72:	eb 3d                	jmp    100cb1 <mon_help+0x4c>
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c77:	89 d0                	mov    %edx,%eax
  100c79:	01 c0                	add    %eax,%eax
  100c7b:	01 d0                	add    %edx,%eax
  100c7d:	c1 e0 02             	shl    $0x2,%eax
  100c80:	05 04 b0 11 00       	add    $0x11b004,%eax
  100c85:	8b 10                	mov    (%eax),%edx
  100c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c8a:	89 c8                	mov    %ecx,%eax
  100c8c:	01 c0                	add    %eax,%eax
  100c8e:	01 c8                	add    %ecx,%eax
  100c90:	c1 e0 02             	shl    $0x2,%eax
  100c93:	05 00 b0 11 00       	add    $0x11b000,%eax
  100c98:	8b 00                	mov    (%eax),%eax
  100c9a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca2:	c7 04 24 bd 6f 10 00 	movl   $0x106fbd,(%esp)
  100ca9:	e8 b7 f6 ff ff       	call   100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i++)
  100cae:	ff 45 f4             	incl   -0xc(%ebp)
  100cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb4:	83 f8 02             	cmp    $0x2,%eax
  100cb7:	76 bb                	jbe    100c74 <mon_help+0xf>
    }
    return 0;
  100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbe:	89 ec                	mov    %ebp,%esp
  100cc0:	5d                   	pop    %ebp
  100cc1:	c3                   	ret    

00100cc2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
  100cc2:	55                   	push   %ebp
  100cc3:	89 e5                	mov    %esp,%ebp
  100cc5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cc8:	e8 bb fb ff ff       	call   100888 <print_kerninfo>
    return 0;
  100ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd2:	89 ec                	mov    %ebp,%esp
  100cd4:	5d                   	pop    %ebp
  100cd5:	c3                   	ret    

00100cd6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
  100cd6:	55                   	push   %ebp
  100cd7:	89 e5                	mov    %esp,%ebp
  100cd9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cdc:	e8 f3 fc ff ff       	call   1009d4 <print_stackframe>
    return 0;
  100ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ce6:	89 ec                	mov    %ebp,%esp
  100ce8:	5d                   	pop    %ebp
  100ce9:	c3                   	ret    

00100cea <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
  100cea:	55                   	push   %ebp
  100ceb:	89 e5                	mov    %esp,%ebp
  100ced:	83 ec 28             	sub    $0x28,%esp
    if (is_panic)
  100cf0:	a1 20 e4 11 00       	mov    0x11e420,%eax
  100cf5:	85 c0                	test   %eax,%eax
  100cf7:	75 5b                	jne    100d54 <__panic+0x6a>
    {
        goto panic_dead;
    }
    is_panic = 1;
  100cf9:	c7 05 20 e4 11 00 01 	movl   $0x1,0x11e420
  100d00:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d03:	8d 45 14             	lea    0x14(%ebp),%eax
  100d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d10:	8b 45 08             	mov    0x8(%ebp),%eax
  100d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d17:	c7 04 24 c6 6f 10 00 	movl   $0x106fc6,(%esp)
  100d1e:	e8 42 f6 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2d:	89 04 24             	mov    %eax,(%esp)
  100d30:	e8 fb f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100d35:	c7 04 24 e2 6f 10 00 	movl   $0x106fe2,(%esp)
  100d3c:	e8 24 f6 ff ff       	call   100365 <cprintf>

    cprintf("stack trackback:\n");
  100d41:	c7 04 24 e4 6f 10 00 	movl   $0x106fe4,(%esp)
  100d48:	e8 18 f6 ff ff       	call   100365 <cprintf>
    print_stackframe();
  100d4d:	e8 82 fc ff ff       	call   1009d4 <print_stackframe>
  100d52:	eb 01                	jmp    100d55 <__panic+0x6b>
        goto panic_dead;
  100d54:	90                   	nop

    va_end(ap);

panic_dead:
    intr_disable();
  100d55:	e8 e9 09 00 00       	call   101743 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
  100d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d61:	e8 9d fe ff ff       	call   100c03 <kmonitor>
  100d66:	eb f2                	jmp    100d5a <__panic+0x70>

00100d68 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
  100d6b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d6e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d77:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d82:	c7 04 24 f6 6f 10 00 	movl   $0x106ff6,(%esp)
  100d89:	e8 d7 f5 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d95:	8b 45 10             	mov    0x10(%ebp),%eax
  100d98:	89 04 24             	mov    %eax,(%esp)
  100d9b:	e8 90 f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100da0:	c7 04 24 e2 6f 10 00 	movl   $0x106fe2,(%esp)
  100da7:	e8 b9 f5 ff ff       	call   100365 <cprintf>
    va_end(ap);
}
  100dac:	90                   	nop
  100dad:	89 ec                	mov    %ebp,%esp
  100daf:	5d                   	pop    %ebp
  100db0:	c3                   	ret    

00100db1 <is_kernel_panic>:

bool is_kernel_panic(void)
{
  100db1:	55                   	push   %ebp
  100db2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100db4:	a1 20 e4 11 00       	mov    0x11e420,%eax
}
  100db9:	5d                   	pop    %ebp
  100dba:	c3                   	ret    

00100dbb <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 28             	sub    $0x28,%esp
  100dc1:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dc7:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100dcb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dcf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd3:	ee                   	out    %al,(%dx)
}
  100dd4:	90                   	nop
  100dd5:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ddb:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100ddf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100de7:	ee                   	out    %al,(%dx)
}
  100de8:	90                   	nop
  100de9:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100def:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100df3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100df7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dfb:	ee                   	out    %al,(%dx)
}
  100dfc:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dfd:	c7 05 24 e4 11 00 00 	movl   $0x0,0x11e424
  100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e07:	c7 04 24 14 70 10 00 	movl   $0x107014,(%esp)
  100e0e:	e8 52 f5 ff ff       	call   100365 <cprintf>
    pic_enable(IRQ_TIMER);
  100e13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e1a:	e8 89 09 00 00       	call   1017a8 <pic_enable>
}
  100e1f:	90                   	nop
  100e20:	89 ec                	mov    %ebp,%esp
  100e22:	5d                   	pop    %ebp
  100e23:	c3                   	ret    

00100e24 <__intr_save>:
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void)
{
  100e24:	55                   	push   %ebp
  100e25:	89 e5                	mov    %esp,%ebp
  100e27:	83 ec 18             	sub    $0x18,%esp

static inline uint32_t
read_eflags(void)
{
    uint32_t eflags;
    asm volatile("pushfl; popl %0"
  100e2a:	9c                   	pushf  
  100e2b:	58                   	pop    %eax
  100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                 : "=r"(eflags));
    return eflags;
  100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
  100e32:	25 00 02 00 00       	and    $0x200,%eax
  100e37:	85 c0                	test   %eax,%eax
  100e39:	74 0c                	je     100e47 <__intr_save+0x23>
    {
        intr_disable();
  100e3b:	e8 03 09 00 00       	call   101743 <intr_disable>
        return 1;
  100e40:	b8 01 00 00 00       	mov    $0x1,%eax
  100e45:	eb 05                	jmp    100e4c <__intr_save+0x28>
    }
    return 0;
  100e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e4c:	89 ec                	mov    %ebp,%esp
  100e4e:	5d                   	pop    %ebp
  100e4f:	c3                   	ret    

00100e50 <__intr_restore>:

static inline void
__intr_restore(bool flag)
{
  100e50:	55                   	push   %ebp
  100e51:	89 e5                	mov    %esp,%ebp
  100e53:	83 ec 08             	sub    $0x8,%esp
    if (flag)
  100e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e5a:	74 05                	je     100e61 <__intr_restore+0x11>
    {
        intr_enable();
  100e5c:	e8 da 08 00 00       	call   10173b <intr_enable>
    }
}
  100e61:	90                   	nop
  100e62:	89 ec                	mov    %ebp,%esp
  100e64:	5d                   	pop    %ebp
  100e65:	c3                   	ret    

00100e66 <delay>:
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void)
{
  100e66:	55                   	push   %ebp
  100e67:	89 e5                	mov    %esp,%ebp
  100e69:	83 ec 10             	sub    $0x10,%esp
  100e6c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile("inb %1, %0"
  100e72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e76:	89 c2                	mov    %eax,%edx
  100e78:	ec                   	in     (%dx),%al
  100e79:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e7c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e82:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e86:	89 c2                	mov    %eax,%edx
  100e88:	ec                   	in     (%dx),%al
  100e89:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e8c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e92:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e96:	89 c2                	mov    %eax,%edx
  100e98:	ec                   	in     (%dx),%al
  100e99:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e9c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ea2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ea6:	89 c2                	mov    %eax,%edx
  100ea8:	ec                   	in     (%dx),%al
  100ea9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eac:	90                   	nop
  100ead:	89 ec                	mov    %ebp,%esp
  100eaf:	5d                   	pop    %ebp
  100eb0:	c3                   	ret    

00100eb1 <cga_init>:

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void)
{
  100eb1:	55                   	push   %ebp
  100eb2:	89 e5                	mov    %esp,%ebp
  100eb4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100eb7:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec1:	0f b7 00             	movzwl (%eax),%eax
  100ec4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t)0xA55A;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A)
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	0f b7 00             	movzwl (%eax),%eax
  100ed6:	0f b7 c0             	movzwl %ax,%eax
  100ed9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ede:	74 12                	je     100ef2 <cga_init+0x41>
    {
        cp = (uint16_t *)(MONO_BUF + KERNBASE);
  100ee0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ee7:	66 c7 05 46 e4 11 00 	movw   $0x3b4,0x11e446
  100eee:	b4 03 
  100ef0:	eb 13                	jmp    100f05 <cga_init+0x54>
    }
    else
    {
        *cp = was;
  100ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ef9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100efc:	66 c7 05 46 e4 11 00 	movw   $0x3d4,0x11e446
  100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f05:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
}
  100f1d:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f1e:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f25:	40                   	inc    %eax
  100f26:	0f b7 c0             	movzwl %ax,%eax
  100f29:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile("inb %1, %0"
  100f2d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f31:	89 c2                	mov    %eax,%edx
  100f33:	ec                   	in     (%dx),%al
  100f34:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f37:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3b:	0f b6 c0             	movzbl %al,%eax
  100f3e:	c1 e0 08             	shl    $0x8,%eax
  100f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f44:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100f53:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f57:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f5b:	ee                   	out    %al,(%dx)
}
  100f5c:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f5d:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f64:	40                   	inc    %eax
  100f65:	0f b7 c0             	movzwl %ax,%eax
  100f68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile("inb %1, %0"
  100f6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f70:	89 c2                	mov    %eax,%edx
  100f72:	ec                   	in     (%dx),%al
  100f73:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7a:	0f b6 c0             	movzbl %al,%eax
  100f7d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t *)cp;
  100f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f83:	a3 40 e4 11 00       	mov    %eax,0x11e440
    crt_pos = pos;
  100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f8b:	0f b7 c0             	movzwl %ax,%eax
  100f8e:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
}
  100f94:	90                   	nop
  100f95:	89 ec                	mov    %ebp,%esp
  100f97:	5d                   	pop    %ebp
  100f98:	c3                   	ret    

00100f99 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void)
{
  100f99:	55                   	push   %ebp
  100f9a:	89 e5                	mov    %esp,%ebp
  100f9c:	83 ec 48             	sub    $0x48,%esp
  100f9f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fa5:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100fa9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fb1:	ee                   	out    %al,(%dx)
}
  100fb2:	90                   	nop
  100fb3:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fb9:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100fbd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fc1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fc5:	ee                   	out    %al,(%dx)
}
  100fc6:	90                   	nop
  100fc7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fcd:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100fd1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fd5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
}
  100fda:	90                   	nop
  100fdb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100fe5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fed:	ee                   	out    %al,(%dx)
}
  100fee:	90                   	nop
  100fef:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100ff5:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  100ff9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100ffd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101001:	ee                   	out    %al,(%dx)
}
  101002:	90                   	nop
  101003:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101009:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10100d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101011:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101015:	ee                   	out    %al,(%dx)
}
  101016:	90                   	nop
  101017:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10101d:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101021:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101025:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101029:	ee                   	out    %al,(%dx)
}
  10102a:	90                   	nop
  10102b:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile("inb %1, %0"
  101031:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101035:	89 c2                	mov    %eax,%edx
  101037:	ec                   	in     (%dx),%al
  101038:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10103b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10103f:	3c ff                	cmp    $0xff,%al
  101041:	0f 95 c0             	setne  %al
  101044:	0f b6 c0             	movzbl %al,%eax
  101047:	a3 48 e4 11 00       	mov    %eax,0x11e448
  10104c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile("inb %1, %0"
  101052:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101056:	89 c2                	mov    %eax,%edx
  101058:	ec                   	in     (%dx),%al
  101059:	88 45 f1             	mov    %al,-0xf(%ebp)
  10105c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101062:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101066:	89 c2                	mov    %eax,%edx
  101068:	ec                   	in     (%dx),%al
  101069:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void)inb(COM1 + COM_IIR);
    (void)inb(COM1 + COM_RX);

    if (serial_exists)
  10106c:	a1 48 e4 11 00       	mov    0x11e448,%eax
  101071:	85 c0                	test   %eax,%eax
  101073:	74 0c                	je     101081 <serial_init+0xe8>
    {
        pic_enable(IRQ_COM1);
  101075:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10107c:	e8 27 07 00 00       	call   1017a8 <pic_enable>
    }
}
  101081:	90                   	nop
  101082:	89 ec                	mov    %ebp,%esp
  101084:	5d                   	pop    %ebp
  101085:	c3                   	ret    

00101086 <lpt_putc_sub>:

static void
lpt_putc_sub(int c)
{
  101086:	55                   	push   %ebp
  101087:	89 e5                	mov    %esp,%ebp
  101089:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i++)
  10108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101093:	eb 08                	jmp    10109d <lpt_putc_sub+0x17>
    {
        delay();
  101095:	e8 cc fd ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i++)
  10109a:	ff 45 fc             	incl   -0x4(%ebp)
  10109d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010a7:	89 c2                	mov    %eax,%edx
  1010a9:	ec                   	in     (%dx),%al
  1010aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010b1:	84 c0                	test   %al,%al
  1010b3:	78 09                	js     1010be <lpt_putc_sub+0x38>
  1010b5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010bc:	7e d7                	jle    101095 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010be:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c1:	0f b6 c0             	movzbl %al,%eax
  1010c4:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010ca:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d5:	ee                   	out    %al,(%dx)
}
  1010d6:	90                   	nop
  1010d7:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010dd:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1010e1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010e9:	ee                   	out    %al,(%dx)
}
  1010ea:	90                   	nop
  1010eb:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010f1:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1010f5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010f9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010fd:	ee                   	out    %al,(%dx)
}
  1010fe:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010ff:	90                   	nop
  101100:	89 ec                	mov    %ebp,%esp
  101102:	5d                   	pop    %ebp
  101103:	c3                   	ret    

00101104 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c)
{
  101104:	55                   	push   %ebp
  101105:	89 e5                	mov    %esp,%ebp
  101107:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b')
  10110a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10110e:	74 0d                	je     10111d <lpt_putc+0x19>
    {
        lpt_putc_sub(c);
  101110:	8b 45 08             	mov    0x8(%ebp),%eax
  101113:	89 04 24             	mov    %eax,(%esp)
  101116:	e8 6b ff ff ff       	call   101086 <lpt_putc_sub>
    {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10111b:	eb 24                	jmp    101141 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10111d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101124:	e8 5d ff ff ff       	call   101086 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101129:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101130:	e8 51 ff ff ff       	call   101086 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101135:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10113c:	e8 45 ff ff ff       	call   101086 <lpt_putc_sub>
}
  101141:	90                   	nop
  101142:	89 ec                	mov    %ebp,%esp
  101144:	5d                   	pop    %ebp
  101145:	c3                   	ret    

00101146 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c)
{
  101146:	55                   	push   %ebp
  101147:	89 e5                	mov    %esp,%ebp
  101149:	83 ec 38             	sub    $0x38,%esp
  10114c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF))
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101157:	85 c0                	test   %eax,%eax
  101159:	75 07                	jne    101162 <cga_putc+0x1c>
    {
        c |= 0x0700;
  10115b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff)
  101162:	8b 45 08             	mov    0x8(%ebp),%eax
  101165:	0f b6 c0             	movzbl %al,%eax
  101168:	83 f8 0d             	cmp    $0xd,%eax
  10116b:	74 72                	je     1011df <cga_putc+0x99>
  10116d:	83 f8 0d             	cmp    $0xd,%eax
  101170:	0f 8f a3 00 00 00    	jg     101219 <cga_putc+0xd3>
  101176:	83 f8 08             	cmp    $0x8,%eax
  101179:	74 0a                	je     101185 <cga_putc+0x3f>
  10117b:	83 f8 0a             	cmp    $0xa,%eax
  10117e:	74 4c                	je     1011cc <cga_putc+0x86>
  101180:	e9 94 00 00 00       	jmp    101219 <cga_putc+0xd3>
    {
    case '\b':
        if (crt_pos > 0)
  101185:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10118c:	85 c0                	test   %eax,%eax
  10118e:	0f 84 af 00 00 00    	je     101243 <cga_putc+0xfd>
        {
            crt_pos--;
  101194:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10119b:	48                   	dec    %eax
  10119c:	0f b7 c0             	movzwl %ax,%eax
  10119f:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a8:	98                   	cwtl   
  1011a9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ae:	98                   	cwtl   
  1011af:	83 c8 20             	or     $0x20,%eax
  1011b2:	98                   	cwtl   
  1011b3:	8b 0d 40 e4 11 00    	mov    0x11e440,%ecx
  1011b9:	0f b7 15 44 e4 11 00 	movzwl 0x11e444,%edx
  1011c0:	01 d2                	add    %edx,%edx
  1011c2:	01 ca                	add    %ecx,%edx
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011ca:	eb 77                	jmp    101243 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011cc:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1011d3:	83 c0 50             	add    $0x50,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011df:	0f b7 1d 44 e4 11 00 	movzwl 0x11e444,%ebx
  1011e6:	0f b7 0d 44 e4 11 00 	movzwl 0x11e444,%ecx
  1011ed:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011f2:	89 c8                	mov    %ecx,%eax
  1011f4:	f7 e2                	mul    %edx
  1011f6:	c1 ea 06             	shr    $0x6,%edx
  1011f9:	89 d0                	mov    %edx,%eax
  1011fb:	c1 e0 02             	shl    $0x2,%eax
  1011fe:	01 d0                	add    %edx,%eax
  101200:	c1 e0 04             	shl    $0x4,%eax
  101203:	29 c1                	sub    %eax,%ecx
  101205:	89 ca                	mov    %ecx,%edx
  101207:	0f b7 d2             	movzwl %dx,%edx
  10120a:	89 d8                	mov    %ebx,%eax
  10120c:	29 d0                	sub    %edx,%eax
  10120e:	0f b7 c0             	movzwl %ax,%eax
  101211:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
        break;
  101217:	eb 2b                	jmp    101244 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos++] = c; // write the character
  101219:	8b 0d 40 e4 11 00    	mov    0x11e440,%ecx
  10121f:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  101226:	8d 50 01             	lea    0x1(%eax),%edx
  101229:	0f b7 d2             	movzwl %dx,%edx
  10122c:	66 89 15 44 e4 11 00 	mov    %dx,0x11e444
  101233:	01 c0                	add    %eax,%eax
  101235:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101238:	8b 45 08             	mov    0x8(%ebp),%eax
  10123b:	0f b7 c0             	movzwl %ax,%eax
  10123e:	66 89 02             	mov    %ax,(%edx)
        break;
  101241:	eb 01                	jmp    101244 <cga_putc+0xfe>
        break;
  101243:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE)
  101244:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101250:	76 5e                	jbe    1012b0 <cga_putc+0x16a>
    {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101252:	a1 40 e4 11 00       	mov    0x11e440,%eax
  101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10125d:	a1 40 e4 11 00       	mov    0x11e440,%eax
  101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101269:	00 
  10126a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10126e:	89 04 24             	mov    %eax,(%esp)
  101271:	e8 22 59 00 00       	call   106b98 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10127d:	eb 15                	jmp    101294 <cga_putc+0x14e>
        {
            crt_buf[i] = 0x0700 | ' ';
  10127f:	8b 15 40 e4 11 00    	mov    0x11e440,%edx
  101285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101288:	01 c0                	add    %eax,%eax
  10128a:	01 d0                	add    %edx,%eax
  10128c:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  101291:	ff 45 f4             	incl   -0xc(%ebp)
  101294:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10129b:	7e e2                	jle    10127f <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10129d:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1012a4:	83 e8 50             	sub    $0x50,%eax
  1012a7:	0f b7 c0             	movzwl %ax,%eax
  1012aa:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012b0:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  1012b7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012bb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c7:	ee                   	out    %al,(%dx)
}
  1012c8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012c9:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1012d0:	c1 e8 08             	shr    $0x8,%eax
  1012d3:	0f b7 c0             	movzwl %ax,%eax
  1012d6:	0f b6 c0             	movzbl %al,%eax
  1012d9:	0f b7 15 46 e4 11 00 	movzwl 0x11e446,%edx
  1012e0:	42                   	inc    %edx
  1012e1:	0f b7 d2             	movzwl %dx,%edx
  1012e4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012e8:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f3:	ee                   	out    %al,(%dx)
}
  1012f4:	90                   	nop
    outb(addr_6845, 15);
  1012f5:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  1012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101304:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101308:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10130c:	ee                   	out    %al,(%dx)
}
  10130d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10130e:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  101315:	0f b6 c0             	movzbl %al,%eax
  101318:	0f b7 15 46 e4 11 00 	movzwl 0x11e446,%edx
  10131f:	42                   	inc    %edx
  101320:	0f b7 d2             	movzwl %dx,%edx
  101323:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101327:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10132a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10132e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101332:	ee                   	out    %al,(%dx)
}
  101333:	90                   	nop
}
  101334:	90                   	nop
  101335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101338:	89 ec                	mov    %ebp,%esp
  10133a:	5d                   	pop    %ebp
  10133b:	c3                   	ret    

0010133c <serial_putc_sub>:

static void
serial_putc_sub(int c)
{
  10133c:	55                   	push   %ebp
  10133d:	89 e5                	mov    %esp,%ebp
  10133f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  101342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101349:	eb 08                	jmp    101353 <serial_putc_sub+0x17>
    {
        delay();
  10134b:	e8 16 fb ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  101350:	ff 45 fc             	incl   -0x4(%ebp)
  101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile("inb %1, %0"
  101359:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135d:	89 c2                	mov    %eax,%edx
  10135f:	ec                   	in     (%dx),%al
  101360:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101363:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101367:	0f b6 c0             	movzbl %al,%eax
  10136a:	83 e0 20             	and    $0x20,%eax
  10136d:	85 c0                	test   %eax,%eax
  10136f:	75 09                	jne    10137a <serial_putc_sub+0x3e>
  101371:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101378:	7e d1                	jle    10134b <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10137a:	8b 45 08             	mov    0x8(%ebp),%eax
  10137d:	0f b6 c0             	movzbl %al,%eax
  101380:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101386:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101389:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10138d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101391:	ee                   	out    %al,(%dx)
}
  101392:	90                   	nop
}
  101393:	90                   	nop
  101394:	89 ec                	mov    %ebp,%esp
  101396:	5d                   	pop    %ebp
  101397:	c3                   	ret    

00101398 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c)
{
  101398:	55                   	push   %ebp
  101399:	89 e5                	mov    %esp,%ebp
  10139b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b')
  10139e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a2:	74 0d                	je     1013b1 <serial_putc+0x19>
    {
        serial_putc_sub(c);
  1013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a7:	89 04 24             	mov    %eax,(%esp)
  1013aa:	e8 8d ff ff ff       	call   10133c <serial_putc_sub>
    {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013af:	eb 24                	jmp    1013d5 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b8:	e8 7f ff ff ff       	call   10133c <serial_putc_sub>
        serial_putc_sub(' ');
  1013bd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c4:	e8 73 ff ff ff       	call   10133c <serial_putc_sub>
        serial_putc_sub('\b');
  1013c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013d0:	e8 67 ff ff ff       	call   10133c <serial_putc_sub>
}
  1013d5:	90                   	nop
  1013d6:	89 ec                	mov    %ebp,%esp
  1013d8:	5d                   	pop    %ebp
  1013d9:	c3                   	ret    

001013da <cons_intr>:
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void))
{
  1013da:	55                   	push   %ebp
  1013db:	89 e5                	mov    %esp,%ebp
  1013dd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1)
  1013e0:	eb 33                	jmp    101415 <cons_intr+0x3b>
    {
        if (c != 0)
  1013e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e6:	74 2d                	je     101415 <cons_intr+0x3b>
        {
            cons.buf[cons.wpos++] = c;
  1013e8:	a1 64 e6 11 00       	mov    0x11e664,%eax
  1013ed:	8d 50 01             	lea    0x1(%eax),%edx
  1013f0:	89 15 64 e6 11 00    	mov    %edx,0x11e664
  1013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013f9:	88 90 60 e4 11 00    	mov    %dl,0x11e460(%eax)
            if (cons.wpos == CONSBUFSIZE)
  1013ff:	a1 64 e6 11 00       	mov    0x11e664,%eax
  101404:	3d 00 02 00 00       	cmp    $0x200,%eax
  101409:	75 0a                	jne    101415 <cons_intr+0x3b>
            {
                cons.wpos = 0;
  10140b:	c7 05 64 e6 11 00 00 	movl   $0x0,0x11e664
  101412:	00 00 00 
    while ((c = (*proc)()) != -1)
  101415:	8b 45 08             	mov    0x8(%ebp),%eax
  101418:	ff d0                	call   *%eax
  10141a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10141d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101421:	75 bf                	jne    1013e2 <cons_intr+0x8>
            }
        }
    }
}
  101423:	90                   	nop
  101424:	90                   	nop
  101425:	89 ec                	mov    %ebp,%esp
  101427:	5d                   	pop    %ebp
  101428:	c3                   	ret    

00101429 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void)
{
  101429:	55                   	push   %ebp
  10142a:	89 e5                	mov    %esp,%ebp
  10142c:	83 ec 10             	sub    $0x10,%esp
  10142f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile("inb %1, %0"
  101435:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101439:	89 c2                	mov    %eax,%edx
  10143b:	ec                   	in     (%dx),%al
  10143c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10143f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  101443:	0f b6 c0             	movzbl %al,%eax
  101446:	83 e0 01             	and    $0x1,%eax
  101449:	85 c0                	test   %eax,%eax
  10144b:	75 07                	jne    101454 <serial_proc_data+0x2b>
    {
        return -1;
  10144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101452:	eb 2a                	jmp    10147e <serial_proc_data+0x55>
  101454:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile("inb %1, %0"
  10145a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10145e:	89 c2                	mov    %eax,%edx
  101460:	ec                   	in     (%dx),%al
  101461:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101464:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101468:	0f b6 c0             	movzbl %al,%eax
  10146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127)
  10146e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101472:	75 07                	jne    10147b <serial_proc_data+0x52>
    {
        c = '\b';
  101474:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10147b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10147e:	89 ec                	mov    %ebp,%esp
  101480:	5d                   	pop    %ebp
  101481:	c3                   	ret    

00101482 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void)
{
  101482:	55                   	push   %ebp
  101483:	89 e5                	mov    %esp,%ebp
  101485:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists)
  101488:	a1 48 e4 11 00       	mov    0x11e448,%eax
  10148d:	85 c0                	test   %eax,%eax
  10148f:	74 0c                	je     10149d <serial_intr+0x1b>
    {
        cons_intr(serial_proc_data);
  101491:	c7 04 24 29 14 10 00 	movl   $0x101429,(%esp)
  101498:	e8 3d ff ff ff       	call   1013da <cons_intr>
    }
}
  10149d:	90                   	nop
  10149e:	89 ec                	mov    %ebp,%esp
  1014a0:	5d                   	pop    %ebp
  1014a1:	c3                   	ret    

001014a2 <kbd_proc_data>:
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void)
{
  1014a2:	55                   	push   %ebp
  1014a3:	89 e5                	mov    %esp,%ebp
  1014a5:	83 ec 38             	sub    $0x38,%esp
  1014a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile("inb %1, %0"
  1014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014b1:	89 c2                	mov    %eax,%edx
  1014b3:	ec                   	in     (%dx),%al
  1014b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0)
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	83 e0 01             	and    $0x1,%eax
  1014c1:	85 c0                	test   %eax,%eax
  1014c3:	75 0a                	jne    1014cf <kbd_proc_data+0x2d>
    {
        return -1;
  1014c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014ca:	e9 56 01 00 00       	jmp    101625 <kbd_proc_data+0x183>
  1014cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile("inb %1, %0"
  1014d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014d8:	89 c2                	mov    %eax,%edx
  1014da:	ec                   	in     (%dx),%al
  1014db:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014de:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0)
  1014e5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014e9:	75 17                	jne    101502 <kbd_proc_data+0x60>
    {
        // E0 escape character
        shift |= E0ESC;
  1014eb:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1014f0:	83 c8 40             	or     $0x40,%eax
  1014f3:	a3 68 e6 11 00       	mov    %eax,0x11e668
        return 0;
  1014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014fd:	e9 23 01 00 00       	jmp    101625 <kbd_proc_data+0x183>
    }
    else if (data & 0x80)
  101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101506:	84 c0                	test   %al,%al
  101508:	79 45                	jns    10154f <kbd_proc_data+0xad>
    {
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10150a:	a1 68 e6 11 00       	mov    0x11e668,%eax
  10150f:	83 e0 40             	and    $0x40,%eax
  101512:	85 c0                	test   %eax,%eax
  101514:	75 08                	jne    10151e <kbd_proc_data+0x7c>
  101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151a:	24 7f                	and    $0x7f,%al
  10151c:	eb 04                	jmp    101522 <kbd_proc_data+0x80>
  10151e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101522:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101525:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101529:	0f b6 80 40 b0 11 00 	movzbl 0x11b040(%eax),%eax
  101530:	0c 40                	or     $0x40,%al
  101532:	0f b6 c0             	movzbl %al,%eax
  101535:	f7 d0                	not    %eax
  101537:	89 c2                	mov    %eax,%edx
  101539:	a1 68 e6 11 00       	mov    0x11e668,%eax
  10153e:	21 d0                	and    %edx,%eax
  101540:	a3 68 e6 11 00       	mov    %eax,0x11e668
        return 0;
  101545:	b8 00 00 00 00       	mov    $0x0,%eax
  10154a:	e9 d6 00 00 00       	jmp    101625 <kbd_proc_data+0x183>
    }
    else if (shift & E0ESC)
  10154f:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101554:	83 e0 40             	and    $0x40,%eax
  101557:	85 c0                	test   %eax,%eax
  101559:	74 11                	je     10156c <kbd_proc_data+0xca>
    {
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10155b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10155f:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101564:	83 e0 bf             	and    $0xffffffbf,%eax
  101567:	a3 68 e6 11 00       	mov    %eax,0x11e668
    }

    shift |= shiftcode[data];
  10156c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101570:	0f b6 80 40 b0 11 00 	movzbl 0x11b040(%eax),%eax
  101577:	0f b6 d0             	movzbl %al,%edx
  10157a:	a1 68 e6 11 00       	mov    0x11e668,%eax
  10157f:	09 d0                	or     %edx,%eax
  101581:	a3 68 e6 11 00       	mov    %eax,0x11e668
    shift ^= togglecode[data];
  101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158a:	0f b6 80 40 b1 11 00 	movzbl 0x11b140(%eax),%eax
  101591:	0f b6 d0             	movzbl %al,%edx
  101594:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101599:	31 d0                	xor    %edx,%eax
  10159b:	a3 68 e6 11 00       	mov    %eax,0x11e668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a0:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015a5:	83 e0 03             	and    $0x3,%eax
  1015a8:	8b 14 85 40 b5 11 00 	mov    0x11b540(,%eax,4),%edx
  1015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b3:	01 d0                	add    %edx,%eax
  1015b5:	0f b6 00             	movzbl (%eax),%eax
  1015b8:	0f b6 c0             	movzbl %al,%eax
  1015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK)
  1015be:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015c3:	83 e0 08             	and    $0x8,%eax
  1015c6:	85 c0                	test   %eax,%eax
  1015c8:	74 22                	je     1015ec <kbd_proc_data+0x14a>
    {
        if ('a' <= c && c <= 'z')
  1015ca:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015ce:	7e 0c                	jle    1015dc <kbd_proc_data+0x13a>
  1015d0:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015d4:	7f 06                	jg     1015dc <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015d6:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015da:	eb 10                	jmp    1015ec <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015dc:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015e0:	7e 0a                	jle    1015ec <kbd_proc_data+0x14a>
  1015e2:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015e6:	7f 04                	jg     1015ec <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015e8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL)
  1015ec:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015f1:	f7 d0                	not    %eax
  1015f3:	83 e0 06             	and    $0x6,%eax
  1015f6:	85 c0                	test   %eax,%eax
  1015f8:	75 28                	jne    101622 <kbd_proc_data+0x180>
  1015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101601:	75 1f                	jne    101622 <kbd_proc_data+0x180>
    {
        cprintf("Rebooting!\n");
  101603:	c7 04 24 2f 70 10 00 	movl   $0x10702f,(%esp)
  10160a:	e8 56 ed ff ff       	call   100365 <cprintf>
  10160f:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101615:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101619:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10161d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101620:	ee                   	out    %al,(%dx)
}
  101621:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101622:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101625:	89 ec                	mov    %ebp,%esp
  101627:	5d                   	pop    %ebp
  101628:	c3                   	ret    

00101629 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void)
{
  101629:	55                   	push   %ebp
  10162a:	89 e5                	mov    %esp,%ebp
  10162c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10162f:	c7 04 24 a2 14 10 00 	movl   $0x1014a2,(%esp)
  101636:	e8 9f fd ff ff       	call   1013da <cons_intr>
}
  10163b:	90                   	nop
  10163c:	89 ec                	mov    %ebp,%esp
  10163e:	5d                   	pop    %ebp
  10163f:	c3                   	ret    

00101640 <kbd_init>:

static void
kbd_init(void)
{
  101640:	55                   	push   %ebp
  101641:	89 e5                	mov    %esp,%ebp
  101643:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101646:	e8 de ff ff ff       	call   101629 <kbd_intr>
    pic_enable(IRQ_KBD);
  10164b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101652:	e8 51 01 00 00       	call   1017a8 <pic_enable>
}
  101657:	90                   	nop
  101658:	89 ec                	mov    %ebp,%esp
  10165a:	5d                   	pop    %ebp
  10165b:	c3                   	ret    

0010165c <cons_init>:

/* cons_init - initializes the console devices */
void cons_init(void)
{
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101662:	e8 4a f8 ff ff       	call   100eb1 <cga_init>
    serial_init();
  101667:	e8 2d f9 ff ff       	call   100f99 <serial_init>
    kbd_init();
  10166c:	e8 cf ff ff ff       	call   101640 <kbd_init>
    if (!serial_exists)
  101671:	a1 48 e4 11 00       	mov    0x11e448,%eax
  101676:	85 c0                	test   %eax,%eax
  101678:	75 0c                	jne    101686 <cons_init+0x2a>
    {
        cprintf("serial port does not exist!!\n");
  10167a:	c7 04 24 3b 70 10 00 	movl   $0x10703b,(%esp)
  101681:	e8 df ec ff ff       	call   100365 <cprintf>
    }
}
  101686:	90                   	nop
  101687:	89 ec                	mov    %ebp,%esp
  101689:	5d                   	pop    %ebp
  10168a:	c3                   	ret    

0010168b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c)
{
  10168b:	55                   	push   %ebp
  10168c:	89 e5                	mov    %esp,%ebp
  10168e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101691:	e8 8e f7 ff ff       	call   100e24 <__intr_save>
  101696:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101699:	8b 45 08             	mov    0x8(%ebp),%eax
  10169c:	89 04 24             	mov    %eax,(%esp)
  10169f:	e8 60 fa ff ff       	call   101104 <lpt_putc>
        cga_putc(c);
  1016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a7:	89 04 24             	mov    %eax,(%esp)
  1016aa:	e8 97 fa ff ff       	call   101146 <cga_putc>
        serial_putc(c);
  1016af:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b2:	89 04 24             	mov    %eax,(%esp)
  1016b5:	e8 de fc ff ff       	call   101398 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016bd:	89 04 24             	mov    %eax,(%esp)
  1016c0:	e8 8b f7 ff ff       	call   100e50 <__intr_restore>
}
  1016c5:	90                   	nop
  1016c6:	89 ec                	mov    %ebp,%esp
  1016c8:	5d                   	pop    %ebp
  1016c9:	c3                   	ret    

001016ca <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void)
{
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
  1016cd:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016d7:	e8 48 f7 ff ff       	call   100e24 <__intr_save>
  1016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016df:	e8 9e fd ff ff       	call   101482 <serial_intr>
        kbd_intr();
  1016e4:	e8 40 ff ff ff       	call   101629 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos)
  1016e9:	8b 15 60 e6 11 00    	mov    0x11e660,%edx
  1016ef:	a1 64 e6 11 00       	mov    0x11e664,%eax
  1016f4:	39 c2                	cmp    %eax,%edx
  1016f6:	74 31                	je     101729 <cons_getc+0x5f>
        {
            c = cons.buf[cons.rpos++];
  1016f8:	a1 60 e6 11 00       	mov    0x11e660,%eax
  1016fd:	8d 50 01             	lea    0x1(%eax),%edx
  101700:	89 15 60 e6 11 00    	mov    %edx,0x11e660
  101706:	0f b6 80 60 e4 11 00 	movzbl 0x11e460(%eax),%eax
  10170d:	0f b6 c0             	movzbl %al,%eax
  101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE)
  101713:	a1 60 e6 11 00       	mov    0x11e660,%eax
  101718:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171d:	75 0a                	jne    101729 <cons_getc+0x5f>
            {
                cons.rpos = 0;
  10171f:	c7 05 60 e6 11 00 00 	movl   $0x0,0x11e660
  101726:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10172c:	89 04 24             	mov    %eax,(%esp)
  10172f:	e8 1c f7 ff ff       	call   100e50 <__intr_restore>
    return c;
  101734:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101737:	89 ec                	mov    %ebp,%esp
  101739:	5d                   	pop    %ebp
  10173a:	c3                   	ret    

0010173b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void)
{
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
    asm volatile("sti");
  10173e:	fb                   	sti    
}
  10173f:	90                   	nop
    sti();
}
  101740:	90                   	nop
  101741:	5d                   	pop    %ebp
  101742:	c3                   	ret    

00101743 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void)
{
  101743:	55                   	push   %ebp
  101744:	89 e5                	mov    %esp,%ebp
    asm volatile("cli" ::
  101746:	fa                   	cli    
}
  101747:	90                   	nop
    cli();
}
  101748:	90                   	nop
  101749:	5d                   	pop    %ebp
  10174a:	c3                   	ret    

0010174b <pic_setmask>:
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask)
{
  10174b:	55                   	push   %ebp
  10174c:	89 e5                	mov    %esp,%ebp
  10174e:	83 ec 14             	sub    $0x14,%esp
  101751:	8b 45 08             	mov    0x8(%ebp),%eax
  101754:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175b:	66 a3 50 b5 11 00    	mov    %ax,0x11b550
    if (did_init)
  101761:	a1 6c e6 11 00       	mov    0x11e66c,%eax
  101766:	85 c0                	test   %eax,%eax
  101768:	74 39                	je     1017a3 <pic_setmask+0x58>
    {
        outb(IO_PIC1 + 1, mask);
  10176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10176d:	0f b6 c0             	movzbl %al,%eax
  101770:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101776:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101779:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10177d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
}
  101782:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101783:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101787:	c1 e8 08             	shr    $0x8,%eax
  10178a:	0f b7 c0             	movzwl %ax,%eax
  10178d:	0f b6 c0             	movzbl %al,%eax
  101790:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101796:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101799:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10179d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017a1:	ee                   	out    %al,(%dx)
}
  1017a2:	90                   	nop
    }
}
  1017a3:	90                   	nop
  1017a4:	89 ec                	mov    %ebp,%esp
  1017a6:	5d                   	pop    %ebp
  1017a7:	c3                   	ret    

001017a8 <pic_enable>:

void pic_enable(unsigned int irq)
{
  1017a8:	55                   	push   %ebp
  1017a9:	89 e5                	mov    %esp,%ebp
  1017ab:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1017b1:	ba 01 00 00 00       	mov    $0x1,%edx
  1017b6:	88 c1                	mov    %al,%cl
  1017b8:	d3 e2                	shl    %cl,%edx
  1017ba:	89 d0                	mov    %edx,%eax
  1017bc:	98                   	cwtl   
  1017bd:	f7 d0                	not    %eax
  1017bf:	0f bf d0             	movswl %ax,%edx
  1017c2:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  1017c9:	98                   	cwtl   
  1017ca:	21 d0                	and    %edx,%eax
  1017cc:	98                   	cwtl   
  1017cd:	0f b7 c0             	movzwl %ax,%eax
  1017d0:	89 04 24             	mov    %eax,(%esp)
  1017d3:	e8 73 ff ff ff       	call   10174b <pic_setmask>
}
  1017d8:	90                   	nop
  1017d9:	89 ec                	mov    %ebp,%esp
  1017db:	5d                   	pop    %ebp
  1017dc:	c3                   	ret    

001017dd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void)
{
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
  1017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017e3:	c7 05 6c e6 11 00 01 	movl   $0x1,0x11e66c
  1017ea:	00 00 00 
  1017ed:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017f3:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1017f7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017fb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
}
  101800:	90                   	nop
  101801:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101807:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10180b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10180f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101813:	ee                   	out    %al,(%dx)
}
  101814:	90                   	nop
  101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101827:	ee                   	out    %al,(%dx)
}
  101828:	90                   	nop
  101829:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10182f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101833:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101837:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
}
  10183c:	90                   	nop
  10183d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101843:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101847:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10184b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10184f:	ee                   	out    %al,(%dx)
}
  101850:	90                   	nop
  101851:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101857:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10185b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10185f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101863:	ee                   	out    %al,(%dx)
}
  101864:	90                   	nop
  101865:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10186b:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  10186f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101873:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101877:	ee                   	out    %al,(%dx)
}
  101878:	90                   	nop
  101879:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10187f:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101883:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101887:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10188b:	ee                   	out    %al,(%dx)
}
  10188c:	90                   	nop
  10188d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101893:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  101897:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10189b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10189f:	ee                   	out    %al,(%dx)
}
  1018a0:	90                   	nop
  1018a1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018a7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1018ab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018af:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018b3:	ee                   	out    %al,(%dx)
}
  1018b4:	90                   	nop
  1018b5:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018bb:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1018bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018c7:	ee                   	out    %al,(%dx)
}
  1018c8:	90                   	nop
  1018c9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018cf:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1018d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018db:	ee                   	out    %al,(%dx)
}
  1018dc:	90                   	nop
  1018dd:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018e3:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1018e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018eb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018ef:	ee                   	out    %al,(%dx)
}
  1018f0:	90                   	nop
  1018f1:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018f7:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1018fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101903:	ee                   	out    %al,(%dx)
}
  101904:	90                   	nop
    outb(IO_PIC1, 0x0a); // read IRR by default

    outb(IO_PIC2, 0x68); // OCW3
    outb(IO_PIC2, 0x0a); // OCW3

    if (irq_mask != 0xFFFF)
  101905:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  10190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101911:	74 0f                	je     101922 <pic_init+0x145>
    {
        pic_setmask(irq_mask);
  101913:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  10191a:	89 04 24             	mov    %eax,(%esp)
  10191d:	e8 29 fe ff ff       	call   10174b <pic_setmask>
    }
}
  101922:	90                   	nop
  101923:	89 ec                	mov    %ebp,%esp
  101925:	5d                   	pop    %ebp
  101926:	c3                   	ret    

00101927 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
  101927:	55                   	push   %ebp
  101928:	89 e5                	mov    %esp,%ebp
  10192a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  10192d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101934:	00 
  101935:	c7 04 24 60 70 10 00 	movl   $0x107060,(%esp)
  10193c:	e8 24 ea ff ff       	call   100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101941:	c7 04 24 6a 70 10 00 	movl   $0x10706a,(%esp)
  101948:	e8 18 ea ff ff       	call   100365 <cprintf>
    panic("EOT: kernel seems ok.");
  10194d:	c7 44 24 08 78 70 10 	movl   $0x107078,0x8(%esp)
  101954:	00 
  101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  10195c:	00 
  10195d:	c7 04 24 8e 70 10 00 	movl   $0x10708e,(%esp)
  101964:	e8 81 f3 ff ff       	call   100cea <__panic>

00101969 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  101969:	55                   	push   %ebp
  10196a:	89 e5                	mov    %esp,%ebp
  10196c:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
  10196f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101976:	e9 c4 00 00 00       	jmp    101a3f <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197e:	8b 04 85 e0 b5 11 00 	mov    0x11b5e0(,%eax,4),%eax
  101985:	0f b7 d0             	movzwl %ax,%edx
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	66 89 14 c5 80 e6 11 	mov    %dx,0x11e680(,%eax,8)
  101992:	00 
  101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101996:	66 c7 04 c5 82 e6 11 	movw   $0x8,0x11e682(,%eax,8)
  10199d:	00 08 00 
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	0f b6 14 c5 84 e6 11 	movzbl 0x11e684(,%eax,8),%edx
  1019aa:	00 
  1019ab:	80 e2 e0             	and    $0xe0,%dl
  1019ae:	88 14 c5 84 e6 11 00 	mov    %dl,0x11e684(,%eax,8)
  1019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b8:	0f b6 14 c5 84 e6 11 	movzbl 0x11e684(,%eax,8),%edx
  1019bf:	00 
  1019c0:	80 e2 1f             	and    $0x1f,%dl
  1019c3:	88 14 c5 84 e6 11 00 	mov    %dl,0x11e684(,%eax,8)
  1019ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cd:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  1019d4:	00 
  1019d5:	80 e2 f0             	and    $0xf0,%dl
  1019d8:	80 ca 0e             	or     $0xe,%dl
  1019db:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  1019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e5:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  1019ec:	00 
  1019ed:	80 e2 ef             	and    $0xef,%dl
  1019f0:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  1019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fa:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  101a01:	00 
  101a02:	80 e2 9f             	and    $0x9f,%dl
  101a05:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0f:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  101a16:	00 
  101a17:	80 ca 80             	or     $0x80,%dl
  101a1a:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a24:	8b 04 85 e0 b5 11 00 	mov    0x11b5e0(,%eax,4),%eax
  101a2b:	c1 e8 10             	shr    $0x10,%eax
  101a2e:	0f b7 d0             	movzwl %ax,%edx
  101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a34:	66 89 14 c5 86 e6 11 	mov    %dx,0x11e686(,%eax,8)
  101a3b:	00 
    for (int i = 0; i < 256; i++)
  101a3c:	ff 45 fc             	incl   -0x4(%ebp)
  101a3f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a46:	0f 8e 2f ff ff ff    	jle    10197b <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a4c:	a1 c4 b7 11 00       	mov    0x11b7c4,%eax
  101a51:	0f b7 c0             	movzwl %ax,%eax
  101a54:	66 a3 48 ea 11 00    	mov    %ax,0x11ea48
  101a5a:	66 c7 05 4a ea 11 00 	movw   $0x8,0x11ea4a
  101a61:	08 00 
  101a63:	0f b6 05 4c ea 11 00 	movzbl 0x11ea4c,%eax
  101a6a:	24 e0                	and    $0xe0,%al
  101a6c:	a2 4c ea 11 00       	mov    %al,0x11ea4c
  101a71:	0f b6 05 4c ea 11 00 	movzbl 0x11ea4c,%eax
  101a78:	24 1f                	and    $0x1f,%al
  101a7a:	a2 4c ea 11 00       	mov    %al,0x11ea4c
  101a7f:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101a86:	24 f0                	and    $0xf0,%al
  101a88:	0c 0e                	or     $0xe,%al
  101a8a:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101a8f:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101a96:	24 ef                	and    $0xef,%al
  101a98:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101a9d:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101aa4:	0c 60                	or     $0x60,%al
  101aa6:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101aab:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101ab2:	0c 80                	or     $0x80,%al
  101ab4:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101ab9:	a1 c4 b7 11 00       	mov    0x11b7c4,%eax
  101abe:	c1 e8 10             	shr    $0x10,%eax
  101ac1:	0f b7 c0             	movzwl %ax,%eax
  101ac4:	66 a3 4e ea 11 00    	mov    %ax,0x11ea4e
  101aca:	c7 45 f8 60 b5 11 00 	movl   $0x11b560,-0x8(%ebp)
    asm volatile("lidt (%0)" ::"r"(pd)
  101ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ad4:	0f 01 18             	lidtl  (%eax)
}
  101ad7:	90                   	nop
    lidt(&idt_pd);
}
  101ad8:	90                   	nop
  101ad9:	89 ec                	mov    %ebp,%esp
  101adb:	5d                   	pop    %ebp
  101adc:	c3                   	ret    

00101add <trapname>:

static const char *
trapname(int trapno)
{
  101add:	55                   	push   %ebp
  101ade:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae3:	83 f8 13             	cmp    $0x13,%eax
  101ae6:	77 0c                	ja     101af4 <trapname+0x17>
    {
        return excnames[trapno];
  101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aeb:	8b 04 85 e0 73 10 00 	mov    0x1073e0(,%eax,4),%eax
  101af2:	eb 18                	jmp    101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101af8:	7e 0d                	jle    101b07 <trapname+0x2a>
  101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101afe:	7f 07                	jg     101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101b00:	b8 9f 70 10 00       	mov    $0x10709f,%eax
  101b05:	eb 05                	jmp    101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
  101b07:	b8 b2 70 10 00       	mov    $0x1070b2,%eax
}
  101b0c:	5d                   	pop    %ebp
  101b0d:	c3                   	ret    

00101b0e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  101b0e:	55                   	push   %ebp
  101b0f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b11:	8b 45 08             	mov    0x8(%ebp),%eax
  101b14:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b18:	83 f8 08             	cmp    $0x8,%eax
  101b1b:	0f 94 c0             	sete   %al
  101b1e:	0f b6 c0             	movzbl %al,%eax
}
  101b21:	5d                   	pop    %ebp
  101b22:	c3                   	ret    

00101b23 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  101b23:	55                   	push   %ebp
  101b24:	89 e5                	mov    %esp,%ebp
  101b26:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b30:	c7 04 24 f3 70 10 00 	movl   $0x1070f3,(%esp)
  101b37:	e8 29 e8 ff ff       	call   100365 <cprintf>
    print_regs(&tf->tf_regs);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	89 04 24             	mov    %eax,(%esp)
  101b42:	e8 8f 01 00 00       	call   101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 04 71 10 00 	movl   $0x107104,(%esp)
  101b59:	e8 07 e8 ff ff       	call   100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b69:	c7 04 24 17 71 10 00 	movl   $0x107117,(%esp)
  101b70:	e8 f0 e7 ff ff       	call   100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 2a 71 10 00 	movl   $0x10712a,(%esp)
  101b87:	e8 d9 e7 ff ff       	call   100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b97:	c7 04 24 3d 71 10 00 	movl   $0x10713d,(%esp)
  101b9e:	e8 c2 e7 ff ff       	call   100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba6:	8b 40 30             	mov    0x30(%eax),%eax
  101ba9:	89 04 24             	mov    %eax,(%esp)
  101bac:	e8 2c ff ff ff       	call   101add <trapname>
  101bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  101bb4:	8b 52 30             	mov    0x30(%edx),%edx
  101bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bbf:	c7 04 24 50 71 10 00 	movl   $0x107150,(%esp)
  101bc6:	e8 9a e7 ff ff       	call   100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 34             	mov    0x34(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 62 71 10 00 	movl   $0x107162,(%esp)
  101bdc:	e8 84 e7 ff ff       	call   100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 38             	mov    0x38(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 71 71 10 00 	movl   $0x107171,(%esp)
  101bf2:	e8 6e e7 ff ff       	call   100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 80 71 10 00 	movl   $0x107180,(%esp)
  101c09:	e8 57 e7 ff ff       	call   100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 40 40             	mov    0x40(%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 93 71 10 00 	movl   $0x107193,(%esp)
  101c1f:	e8 41 e7 ff ff       	call   100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c32:	eb 3d                	jmp    101c71 <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101c34:	8b 45 08             	mov    0x8(%ebp),%eax
  101c37:	8b 50 40             	mov    0x40(%eax),%edx
  101c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c3d:	21 d0                	and    %edx,%eax
  101c3f:	85 c0                	test   %eax,%eax
  101c41:	74 28                	je     101c6b <print_trapframe+0x148>
  101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c46:	8b 04 85 80 b5 11 00 	mov    0x11b580(,%eax,4),%eax
  101c4d:	85 c0                	test   %eax,%eax
  101c4f:	74 1a                	je     101c6b <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
  101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c54:	8b 04 85 80 b5 11 00 	mov    0x11b580(,%eax,4),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 a2 71 10 00 	movl   $0x1071a2,(%esp)
  101c66:	e8 fa e6 ff ff       	call   100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c6b:	ff 45 f4             	incl   -0xc(%ebp)
  101c6e:	d1 65 f0             	shll   -0x10(%ebp)
  101c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c74:	83 f8 17             	cmp    $0x17,%eax
  101c77:	76 bb                	jbe    101c34 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c79:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7c:	8b 40 40             	mov    0x40(%eax),%eax
  101c7f:	c1 e8 0c             	shr    $0xc,%eax
  101c82:	83 e0 03             	and    $0x3,%eax
  101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c89:	c7 04 24 a6 71 10 00 	movl   $0x1071a6,(%esp)
  101c90:	e8 d0 e6 ff ff       	call   100365 <cprintf>

    if (!trap_in_kernel(tf))
  101c95:	8b 45 08             	mov    0x8(%ebp),%eax
  101c98:	89 04 24             	mov    %eax,(%esp)
  101c9b:	e8 6e fe ff ff       	call   101b0e <trap_in_kernel>
  101ca0:	85 c0                	test   %eax,%eax
  101ca2:	75 2d                	jne    101cd1 <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca7:	8b 40 44             	mov    0x44(%eax),%eax
  101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cae:	c7 04 24 af 71 10 00 	movl   $0x1071af,(%esp)
  101cb5:	e8 ab e6 ff ff       	call   100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc5:	c7 04 24 be 71 10 00 	movl   $0x1071be,(%esp)
  101ccc:	e8 94 e6 ff ff       	call   100365 <cprintf>
    }
}
  101cd1:	90                   	nop
  101cd2:	89 ec                	mov    %ebp,%esp
  101cd4:	5d                   	pop    %ebp
  101cd5:	c3                   	ret    

00101cd6 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101cd6:	55                   	push   %ebp
  101cd7:	89 e5                	mov    %esp,%ebp
  101cd9:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdf:	8b 00                	mov    (%eax),%eax
  101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce5:	c7 04 24 d1 71 10 00 	movl   $0x1071d1,(%esp)
  101cec:	e8 74 e6 ff ff       	call   100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf4:	8b 40 04             	mov    0x4(%eax),%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 e0 71 10 00 	movl   $0x1071e0,(%esp)
  101d02:	e8 5e e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	8b 40 08             	mov    0x8(%eax),%eax
  101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d11:	c7 04 24 ef 71 10 00 	movl   $0x1071ef,(%esp)
  101d18:	e8 48 e6 ff ff       	call   100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d20:	8b 40 0c             	mov    0xc(%eax),%eax
  101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d27:	c7 04 24 fe 71 10 00 	movl   $0x1071fe,(%esp)
  101d2e:	e8 32 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d33:	8b 45 08             	mov    0x8(%ebp),%eax
  101d36:	8b 40 10             	mov    0x10(%eax),%eax
  101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3d:	c7 04 24 0d 72 10 00 	movl   $0x10720d,(%esp)
  101d44:	e8 1c e6 ff ff       	call   100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d49:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4c:	8b 40 14             	mov    0x14(%eax),%eax
  101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d53:	c7 04 24 1c 72 10 00 	movl   $0x10721c,(%esp)
  101d5a:	e8 06 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d62:	8b 40 18             	mov    0x18(%eax),%eax
  101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d69:	c7 04 24 2b 72 10 00 	movl   $0x10722b,(%esp)
  101d70:	e8 f0 e5 ff ff       	call   100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7f:	c7 04 24 3a 72 10 00 	movl   $0x10723a,(%esp)
  101d86:	e8 da e5 ff ff       	call   100365 <cprintf>
}
  101d8b:	90                   	nop
  101d8c:	89 ec                	mov    %ebp,%esp
  101d8e:	5d                   	pop    %ebp
  101d8f:	c3                   	ret    

00101d90 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
  101d90:	55                   	push   %ebp
  101d91:	89 e5                	mov    %esp,%ebp
  101d93:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
  101d96:	8b 45 08             	mov    0x8(%ebp),%eax
  101d99:	8b 40 30             	mov    0x30(%eax),%eax
  101d9c:	83 f8 79             	cmp    $0x79,%eax
  101d9f:	0f 84 1f 01 00 00    	je     101ec4 <trap_dispatch+0x134>
  101da5:	83 f8 79             	cmp    $0x79,%eax
  101da8:	0f 87 69 01 00 00    	ja     101f17 <trap_dispatch+0x187>
  101dae:	83 f8 78             	cmp    $0x78,%eax
  101db1:	0f 84 b7 00 00 00    	je     101e6e <trap_dispatch+0xde>
  101db7:	83 f8 78             	cmp    $0x78,%eax
  101dba:	0f 87 57 01 00 00    	ja     101f17 <trap_dispatch+0x187>
  101dc0:	83 f8 2f             	cmp    $0x2f,%eax
  101dc3:	0f 87 4e 01 00 00    	ja     101f17 <trap_dispatch+0x187>
  101dc9:	83 f8 2e             	cmp    $0x2e,%eax
  101dcc:	0f 83 7a 01 00 00    	jae    101f4c <trap_dispatch+0x1bc>
  101dd2:	83 f8 24             	cmp    $0x24,%eax
  101dd5:	74 45                	je     101e1c <trap_dispatch+0x8c>
  101dd7:	83 f8 24             	cmp    $0x24,%eax
  101dda:	0f 87 37 01 00 00    	ja     101f17 <trap_dispatch+0x187>
  101de0:	83 f8 20             	cmp    $0x20,%eax
  101de3:	74 0a                	je     101def <trap_dispatch+0x5f>
  101de5:	83 f8 21             	cmp    $0x21,%eax
  101de8:	74 5b                	je     101e45 <trap_dispatch+0xb5>
  101dea:	e9 28 01 00 00       	jmp    101f17 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101def:	a1 24 e4 11 00       	mov    0x11e424,%eax
  101df4:	40                   	inc    %eax
  101df5:	a3 24 e4 11 00       	mov    %eax,0x11e424
        if (ticks == TICK_NUM)
  101dfa:	a1 24 e4 11 00       	mov    0x11e424,%eax
  101dff:	83 f8 64             	cmp    $0x64,%eax
  101e02:	0f 85 47 01 00 00    	jne    101f4f <trap_dispatch+0x1bf>
        {
            ticks = 0;
  101e08:	c7 05 24 e4 11 00 00 	movl   $0x0,0x11e424
  101e0f:	00 00 00 
            print_ticks();
  101e12:	e8 10 fb ff ff       	call   101927 <print_ticks>
        }
        break;
  101e17:	e9 33 01 00 00       	jmp    101f4f <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e1c:	e8 a9 f8 ff ff       	call   1016ca <cons_getc>
  101e21:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e24:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e28:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e2c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e34:	c7 04 24 49 72 10 00 	movl   $0x107249,(%esp)
  101e3b:	e8 25 e5 ff ff       	call   100365 <cprintf>
        break;
  101e40:	e9 11 01 00 00       	jmp    101f56 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e45:	e8 80 f8 ff ff       	call   1016ca <cons_getc>
  101e4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e5d:	c7 04 24 5b 72 10 00 	movl   $0x10725b,(%esp)
  101e64:	e8 fc e4 ff ff       	call   100365 <cprintf>
        break;
  101e69:	e9 e8 00 00 00       	jmp    101f56 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
  101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e75:	83 f8 1b             	cmp    $0x1b,%eax
  101e78:	0f 84 d4 00 00 00    	je     101f52 <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
  101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e81:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e87:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e90:	8b 45 08             	mov    0x8(%ebp),%eax
  101e93:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e97:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9a:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101eac:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaf:	8b 40 40             	mov    0x40(%eax),%eax
  101eb2:	0d 00 30 00 00       	or     $0x3000,%eax
  101eb7:	89 c2                	mov    %eax,%edx
  101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebc:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101ebf:	e9 8e 00 00 00       	jmp    101f52 <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
  101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ecb:	83 f8 08             	cmp    $0x8,%eax
  101ece:	0f 84 81 00 00 00    	je     101f55 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
  101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed7:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101edd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee0:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee9:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef0:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef7:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101efb:	8b 45 08             	mov    0x8(%ebp),%eax
  101efe:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f02:	8b 45 08             	mov    0x8(%ebp),%eax
  101f05:	8b 40 40             	mov    0x40(%eax),%eax
  101f08:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f0d:	89 c2                	mov    %eax,%edx
  101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f12:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101f15:	eb 3e                	jmp    101f55 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101f17:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f1e:	83 e0 03             	and    $0x3,%eax
  101f21:	85 c0                	test   %eax,%eax
  101f23:	75 31                	jne    101f56 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
  101f25:	8b 45 08             	mov    0x8(%ebp),%eax
  101f28:	89 04 24             	mov    %eax,(%esp)
  101f2b:	e8 f3 fb ff ff       	call   101b23 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f30:	c7 44 24 08 6a 72 10 	movl   $0x10726a,0x8(%esp)
  101f37:	00 
  101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  101f3f:	00 
  101f40:	c7 04 24 8e 70 10 00 	movl   $0x10708e,(%esp)
  101f47:	e8 9e ed ff ff       	call   100cea <__panic>
        break;
  101f4c:	90                   	nop
  101f4d:	eb 07                	jmp    101f56 <trap_dispatch+0x1c6>
        break;
  101f4f:	90                   	nop
  101f50:	eb 04                	jmp    101f56 <trap_dispatch+0x1c6>
        break;
  101f52:	90                   	nop
  101f53:	eb 01                	jmp    101f56 <trap_dispatch+0x1c6>
        break;
  101f55:	90                   	nop
        }
    }
}
  101f56:	90                   	nop
  101f57:	89 ec                	mov    %ebp,%esp
  101f59:	5d                   	pop    %ebp
  101f5a:	c3                   	ret    

00101f5b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101f5b:	55                   	push   %ebp
  101f5c:	89 e5                	mov    %esp,%ebp
  101f5e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f61:	8b 45 08             	mov    0x8(%ebp),%eax
  101f64:	89 04 24             	mov    %eax,(%esp)
  101f67:	e8 24 fe ff ff       	call   101d90 <trap_dispatch>
}
  101f6c:	90                   	nop
  101f6d:	89 ec                	mov    %ebp,%esp
  101f6f:	5d                   	pop    %ebp
  101f70:	c3                   	ret    

00101f71 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f71:	1e                   	push   %ds
    pushl %es
  101f72:	06                   	push   %es
    pushl %fs
  101f73:	0f a0                	push   %fs
    pushl %gs
  101f75:	0f a8                	push   %gs
    pushal
  101f77:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f78:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f7d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f7f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f81:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f82:	e8 d4 ff ff ff       	call   101f5b <trap>

    # pop the pushed stack pointer
    popl %esp
  101f87:	5c                   	pop    %esp

00101f88 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f88:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f89:	0f a9                	pop    %gs
    popl %fs
  101f8b:	0f a1                	pop    %fs
    popl %es
  101f8d:	07                   	pop    %es
    popl %ds
  101f8e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f8f:	83 c4 08             	add    $0x8,%esp
    iret
  101f92:	cf                   	iret   

00101f93 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $0
  101f95:	6a 00                	push   $0x0
  jmp __alltraps
  101f97:	e9 d5 ff ff ff       	jmp    101f71 <__alltraps>

00101f9c <vector1>:
.globl vector1
vector1:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $1
  101f9e:	6a 01                	push   $0x1
  jmp __alltraps
  101fa0:	e9 cc ff ff ff       	jmp    101f71 <__alltraps>

00101fa5 <vector2>:
.globl vector2
vector2:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $2
  101fa7:	6a 02                	push   $0x2
  jmp __alltraps
  101fa9:	e9 c3 ff ff ff       	jmp    101f71 <__alltraps>

00101fae <vector3>:
.globl vector3
vector3:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $3
  101fb0:	6a 03                	push   $0x3
  jmp __alltraps
  101fb2:	e9 ba ff ff ff       	jmp    101f71 <__alltraps>

00101fb7 <vector4>:
.globl vector4
vector4:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $4
  101fb9:	6a 04                	push   $0x4
  jmp __alltraps
  101fbb:	e9 b1 ff ff ff       	jmp    101f71 <__alltraps>

00101fc0 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $5
  101fc2:	6a 05                	push   $0x5
  jmp __alltraps
  101fc4:	e9 a8 ff ff ff       	jmp    101f71 <__alltraps>

00101fc9 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $6
  101fcb:	6a 06                	push   $0x6
  jmp __alltraps
  101fcd:	e9 9f ff ff ff       	jmp    101f71 <__alltraps>

00101fd2 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $7
  101fd4:	6a 07                	push   $0x7
  jmp __alltraps
  101fd6:	e9 96 ff ff ff       	jmp    101f71 <__alltraps>

00101fdb <vector8>:
.globl vector8
vector8:
  pushl $8
  101fdb:	6a 08                	push   $0x8
  jmp __alltraps
  101fdd:	e9 8f ff ff ff       	jmp    101f71 <__alltraps>

00101fe2 <vector9>:
.globl vector9
vector9:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $9
  101fe4:	6a 09                	push   $0x9
  jmp __alltraps
  101fe6:	e9 86 ff ff ff       	jmp    101f71 <__alltraps>

00101feb <vector10>:
.globl vector10
vector10:
  pushl $10
  101feb:	6a 0a                	push   $0xa
  jmp __alltraps
  101fed:	e9 7f ff ff ff       	jmp    101f71 <__alltraps>

00101ff2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ff2:	6a 0b                	push   $0xb
  jmp __alltraps
  101ff4:	e9 78 ff ff ff       	jmp    101f71 <__alltraps>

00101ff9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ff9:	6a 0c                	push   $0xc
  jmp __alltraps
  101ffb:	e9 71 ff ff ff       	jmp    101f71 <__alltraps>

00102000 <vector13>:
.globl vector13
vector13:
  pushl $13
  102000:	6a 0d                	push   $0xd
  jmp __alltraps
  102002:	e9 6a ff ff ff       	jmp    101f71 <__alltraps>

00102007 <vector14>:
.globl vector14
vector14:
  pushl $14
  102007:	6a 0e                	push   $0xe
  jmp __alltraps
  102009:	e9 63 ff ff ff       	jmp    101f71 <__alltraps>

0010200e <vector15>:
.globl vector15
vector15:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $15
  102010:	6a 0f                	push   $0xf
  jmp __alltraps
  102012:	e9 5a ff ff ff       	jmp    101f71 <__alltraps>

00102017 <vector16>:
.globl vector16
vector16:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $16
  102019:	6a 10                	push   $0x10
  jmp __alltraps
  10201b:	e9 51 ff ff ff       	jmp    101f71 <__alltraps>

00102020 <vector17>:
.globl vector17
vector17:
  pushl $17
  102020:	6a 11                	push   $0x11
  jmp __alltraps
  102022:	e9 4a ff ff ff       	jmp    101f71 <__alltraps>

00102027 <vector18>:
.globl vector18
vector18:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $18
  102029:	6a 12                	push   $0x12
  jmp __alltraps
  10202b:	e9 41 ff ff ff       	jmp    101f71 <__alltraps>

00102030 <vector19>:
.globl vector19
vector19:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $19
  102032:	6a 13                	push   $0x13
  jmp __alltraps
  102034:	e9 38 ff ff ff       	jmp    101f71 <__alltraps>

00102039 <vector20>:
.globl vector20
vector20:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $20
  10203b:	6a 14                	push   $0x14
  jmp __alltraps
  10203d:	e9 2f ff ff ff       	jmp    101f71 <__alltraps>

00102042 <vector21>:
.globl vector21
vector21:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $21
  102044:	6a 15                	push   $0x15
  jmp __alltraps
  102046:	e9 26 ff ff ff       	jmp    101f71 <__alltraps>

0010204b <vector22>:
.globl vector22
vector22:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $22
  10204d:	6a 16                	push   $0x16
  jmp __alltraps
  10204f:	e9 1d ff ff ff       	jmp    101f71 <__alltraps>

00102054 <vector23>:
.globl vector23
vector23:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $23
  102056:	6a 17                	push   $0x17
  jmp __alltraps
  102058:	e9 14 ff ff ff       	jmp    101f71 <__alltraps>

0010205d <vector24>:
.globl vector24
vector24:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $24
  10205f:	6a 18                	push   $0x18
  jmp __alltraps
  102061:	e9 0b ff ff ff       	jmp    101f71 <__alltraps>

00102066 <vector25>:
.globl vector25
vector25:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $25
  102068:	6a 19                	push   $0x19
  jmp __alltraps
  10206a:	e9 02 ff ff ff       	jmp    101f71 <__alltraps>

0010206f <vector26>:
.globl vector26
vector26:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $26
  102071:	6a 1a                	push   $0x1a
  jmp __alltraps
  102073:	e9 f9 fe ff ff       	jmp    101f71 <__alltraps>

00102078 <vector27>:
.globl vector27
vector27:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $27
  10207a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10207c:	e9 f0 fe ff ff       	jmp    101f71 <__alltraps>

00102081 <vector28>:
.globl vector28
vector28:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $28
  102083:	6a 1c                	push   $0x1c
  jmp __alltraps
  102085:	e9 e7 fe ff ff       	jmp    101f71 <__alltraps>

0010208a <vector29>:
.globl vector29
vector29:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $29
  10208c:	6a 1d                	push   $0x1d
  jmp __alltraps
  10208e:	e9 de fe ff ff       	jmp    101f71 <__alltraps>

00102093 <vector30>:
.globl vector30
vector30:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $30
  102095:	6a 1e                	push   $0x1e
  jmp __alltraps
  102097:	e9 d5 fe ff ff       	jmp    101f71 <__alltraps>

0010209c <vector31>:
.globl vector31
vector31:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $31
  10209e:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020a0:	e9 cc fe ff ff       	jmp    101f71 <__alltraps>

001020a5 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $32
  1020a7:	6a 20                	push   $0x20
  jmp __alltraps
  1020a9:	e9 c3 fe ff ff       	jmp    101f71 <__alltraps>

001020ae <vector33>:
.globl vector33
vector33:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $33
  1020b0:	6a 21                	push   $0x21
  jmp __alltraps
  1020b2:	e9 ba fe ff ff       	jmp    101f71 <__alltraps>

001020b7 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $34
  1020b9:	6a 22                	push   $0x22
  jmp __alltraps
  1020bb:	e9 b1 fe ff ff       	jmp    101f71 <__alltraps>

001020c0 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $35
  1020c2:	6a 23                	push   $0x23
  jmp __alltraps
  1020c4:	e9 a8 fe ff ff       	jmp    101f71 <__alltraps>

001020c9 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $36
  1020cb:	6a 24                	push   $0x24
  jmp __alltraps
  1020cd:	e9 9f fe ff ff       	jmp    101f71 <__alltraps>

001020d2 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $37
  1020d4:	6a 25                	push   $0x25
  jmp __alltraps
  1020d6:	e9 96 fe ff ff       	jmp    101f71 <__alltraps>

001020db <vector38>:
.globl vector38
vector38:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $38
  1020dd:	6a 26                	push   $0x26
  jmp __alltraps
  1020df:	e9 8d fe ff ff       	jmp    101f71 <__alltraps>

001020e4 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $39
  1020e6:	6a 27                	push   $0x27
  jmp __alltraps
  1020e8:	e9 84 fe ff ff       	jmp    101f71 <__alltraps>

001020ed <vector40>:
.globl vector40
vector40:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $40
  1020ef:	6a 28                	push   $0x28
  jmp __alltraps
  1020f1:	e9 7b fe ff ff       	jmp    101f71 <__alltraps>

001020f6 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $41
  1020f8:	6a 29                	push   $0x29
  jmp __alltraps
  1020fa:	e9 72 fe ff ff       	jmp    101f71 <__alltraps>

001020ff <vector42>:
.globl vector42
vector42:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $42
  102101:	6a 2a                	push   $0x2a
  jmp __alltraps
  102103:	e9 69 fe ff ff       	jmp    101f71 <__alltraps>

00102108 <vector43>:
.globl vector43
vector43:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $43
  10210a:	6a 2b                	push   $0x2b
  jmp __alltraps
  10210c:	e9 60 fe ff ff       	jmp    101f71 <__alltraps>

00102111 <vector44>:
.globl vector44
vector44:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $44
  102113:	6a 2c                	push   $0x2c
  jmp __alltraps
  102115:	e9 57 fe ff ff       	jmp    101f71 <__alltraps>

0010211a <vector45>:
.globl vector45
vector45:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $45
  10211c:	6a 2d                	push   $0x2d
  jmp __alltraps
  10211e:	e9 4e fe ff ff       	jmp    101f71 <__alltraps>

00102123 <vector46>:
.globl vector46
vector46:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $46
  102125:	6a 2e                	push   $0x2e
  jmp __alltraps
  102127:	e9 45 fe ff ff       	jmp    101f71 <__alltraps>

0010212c <vector47>:
.globl vector47
vector47:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $47
  10212e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102130:	e9 3c fe ff ff       	jmp    101f71 <__alltraps>

00102135 <vector48>:
.globl vector48
vector48:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $48
  102137:	6a 30                	push   $0x30
  jmp __alltraps
  102139:	e9 33 fe ff ff       	jmp    101f71 <__alltraps>

0010213e <vector49>:
.globl vector49
vector49:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $49
  102140:	6a 31                	push   $0x31
  jmp __alltraps
  102142:	e9 2a fe ff ff       	jmp    101f71 <__alltraps>

00102147 <vector50>:
.globl vector50
vector50:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $50
  102149:	6a 32                	push   $0x32
  jmp __alltraps
  10214b:	e9 21 fe ff ff       	jmp    101f71 <__alltraps>

00102150 <vector51>:
.globl vector51
vector51:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $51
  102152:	6a 33                	push   $0x33
  jmp __alltraps
  102154:	e9 18 fe ff ff       	jmp    101f71 <__alltraps>

00102159 <vector52>:
.globl vector52
vector52:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $52
  10215b:	6a 34                	push   $0x34
  jmp __alltraps
  10215d:	e9 0f fe ff ff       	jmp    101f71 <__alltraps>

00102162 <vector53>:
.globl vector53
vector53:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $53
  102164:	6a 35                	push   $0x35
  jmp __alltraps
  102166:	e9 06 fe ff ff       	jmp    101f71 <__alltraps>

0010216b <vector54>:
.globl vector54
vector54:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $54
  10216d:	6a 36                	push   $0x36
  jmp __alltraps
  10216f:	e9 fd fd ff ff       	jmp    101f71 <__alltraps>

00102174 <vector55>:
.globl vector55
vector55:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $55
  102176:	6a 37                	push   $0x37
  jmp __alltraps
  102178:	e9 f4 fd ff ff       	jmp    101f71 <__alltraps>

0010217d <vector56>:
.globl vector56
vector56:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $56
  10217f:	6a 38                	push   $0x38
  jmp __alltraps
  102181:	e9 eb fd ff ff       	jmp    101f71 <__alltraps>

00102186 <vector57>:
.globl vector57
vector57:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $57
  102188:	6a 39                	push   $0x39
  jmp __alltraps
  10218a:	e9 e2 fd ff ff       	jmp    101f71 <__alltraps>

0010218f <vector58>:
.globl vector58
vector58:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $58
  102191:	6a 3a                	push   $0x3a
  jmp __alltraps
  102193:	e9 d9 fd ff ff       	jmp    101f71 <__alltraps>

00102198 <vector59>:
.globl vector59
vector59:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $59
  10219a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10219c:	e9 d0 fd ff ff       	jmp    101f71 <__alltraps>

001021a1 <vector60>:
.globl vector60
vector60:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $60
  1021a3:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021a5:	e9 c7 fd ff ff       	jmp    101f71 <__alltraps>

001021aa <vector61>:
.globl vector61
vector61:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $61
  1021ac:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021ae:	e9 be fd ff ff       	jmp    101f71 <__alltraps>

001021b3 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $62
  1021b5:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021b7:	e9 b5 fd ff ff       	jmp    101f71 <__alltraps>

001021bc <vector63>:
.globl vector63
vector63:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $63
  1021be:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021c0:	e9 ac fd ff ff       	jmp    101f71 <__alltraps>

001021c5 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $64
  1021c7:	6a 40                	push   $0x40
  jmp __alltraps
  1021c9:	e9 a3 fd ff ff       	jmp    101f71 <__alltraps>

001021ce <vector65>:
.globl vector65
vector65:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $65
  1021d0:	6a 41                	push   $0x41
  jmp __alltraps
  1021d2:	e9 9a fd ff ff       	jmp    101f71 <__alltraps>

001021d7 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $66
  1021d9:	6a 42                	push   $0x42
  jmp __alltraps
  1021db:	e9 91 fd ff ff       	jmp    101f71 <__alltraps>

001021e0 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $67
  1021e2:	6a 43                	push   $0x43
  jmp __alltraps
  1021e4:	e9 88 fd ff ff       	jmp    101f71 <__alltraps>

001021e9 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $68
  1021eb:	6a 44                	push   $0x44
  jmp __alltraps
  1021ed:	e9 7f fd ff ff       	jmp    101f71 <__alltraps>

001021f2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $69
  1021f4:	6a 45                	push   $0x45
  jmp __alltraps
  1021f6:	e9 76 fd ff ff       	jmp    101f71 <__alltraps>

001021fb <vector70>:
.globl vector70
vector70:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $70
  1021fd:	6a 46                	push   $0x46
  jmp __alltraps
  1021ff:	e9 6d fd ff ff       	jmp    101f71 <__alltraps>

00102204 <vector71>:
.globl vector71
vector71:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $71
  102206:	6a 47                	push   $0x47
  jmp __alltraps
  102208:	e9 64 fd ff ff       	jmp    101f71 <__alltraps>

0010220d <vector72>:
.globl vector72
vector72:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $72
  10220f:	6a 48                	push   $0x48
  jmp __alltraps
  102211:	e9 5b fd ff ff       	jmp    101f71 <__alltraps>

00102216 <vector73>:
.globl vector73
vector73:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $73
  102218:	6a 49                	push   $0x49
  jmp __alltraps
  10221a:	e9 52 fd ff ff       	jmp    101f71 <__alltraps>

0010221f <vector74>:
.globl vector74
vector74:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $74
  102221:	6a 4a                	push   $0x4a
  jmp __alltraps
  102223:	e9 49 fd ff ff       	jmp    101f71 <__alltraps>

00102228 <vector75>:
.globl vector75
vector75:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $75
  10222a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10222c:	e9 40 fd ff ff       	jmp    101f71 <__alltraps>

00102231 <vector76>:
.globl vector76
vector76:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $76
  102233:	6a 4c                	push   $0x4c
  jmp __alltraps
  102235:	e9 37 fd ff ff       	jmp    101f71 <__alltraps>

0010223a <vector77>:
.globl vector77
vector77:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $77
  10223c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10223e:	e9 2e fd ff ff       	jmp    101f71 <__alltraps>

00102243 <vector78>:
.globl vector78
vector78:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $78
  102245:	6a 4e                	push   $0x4e
  jmp __alltraps
  102247:	e9 25 fd ff ff       	jmp    101f71 <__alltraps>

0010224c <vector79>:
.globl vector79
vector79:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $79
  10224e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102250:	e9 1c fd ff ff       	jmp    101f71 <__alltraps>

00102255 <vector80>:
.globl vector80
vector80:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $80
  102257:	6a 50                	push   $0x50
  jmp __alltraps
  102259:	e9 13 fd ff ff       	jmp    101f71 <__alltraps>

0010225e <vector81>:
.globl vector81
vector81:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $81
  102260:	6a 51                	push   $0x51
  jmp __alltraps
  102262:	e9 0a fd ff ff       	jmp    101f71 <__alltraps>

00102267 <vector82>:
.globl vector82
vector82:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $82
  102269:	6a 52                	push   $0x52
  jmp __alltraps
  10226b:	e9 01 fd ff ff       	jmp    101f71 <__alltraps>

00102270 <vector83>:
.globl vector83
vector83:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $83
  102272:	6a 53                	push   $0x53
  jmp __alltraps
  102274:	e9 f8 fc ff ff       	jmp    101f71 <__alltraps>

00102279 <vector84>:
.globl vector84
vector84:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $84
  10227b:	6a 54                	push   $0x54
  jmp __alltraps
  10227d:	e9 ef fc ff ff       	jmp    101f71 <__alltraps>

00102282 <vector85>:
.globl vector85
vector85:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $85
  102284:	6a 55                	push   $0x55
  jmp __alltraps
  102286:	e9 e6 fc ff ff       	jmp    101f71 <__alltraps>

0010228b <vector86>:
.globl vector86
vector86:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $86
  10228d:	6a 56                	push   $0x56
  jmp __alltraps
  10228f:	e9 dd fc ff ff       	jmp    101f71 <__alltraps>

00102294 <vector87>:
.globl vector87
vector87:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $87
  102296:	6a 57                	push   $0x57
  jmp __alltraps
  102298:	e9 d4 fc ff ff       	jmp    101f71 <__alltraps>

0010229d <vector88>:
.globl vector88
vector88:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $88
  10229f:	6a 58                	push   $0x58
  jmp __alltraps
  1022a1:	e9 cb fc ff ff       	jmp    101f71 <__alltraps>

001022a6 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $89
  1022a8:	6a 59                	push   $0x59
  jmp __alltraps
  1022aa:	e9 c2 fc ff ff       	jmp    101f71 <__alltraps>

001022af <vector90>:
.globl vector90
vector90:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $90
  1022b1:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022b3:	e9 b9 fc ff ff       	jmp    101f71 <__alltraps>

001022b8 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $91
  1022ba:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022bc:	e9 b0 fc ff ff       	jmp    101f71 <__alltraps>

001022c1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $92
  1022c3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022c5:	e9 a7 fc ff ff       	jmp    101f71 <__alltraps>

001022ca <vector93>:
.globl vector93
vector93:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $93
  1022cc:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022ce:	e9 9e fc ff ff       	jmp    101f71 <__alltraps>

001022d3 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $94
  1022d5:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022d7:	e9 95 fc ff ff       	jmp    101f71 <__alltraps>

001022dc <vector95>:
.globl vector95
vector95:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $95
  1022de:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022e0:	e9 8c fc ff ff       	jmp    101f71 <__alltraps>

001022e5 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $96
  1022e7:	6a 60                	push   $0x60
  jmp __alltraps
  1022e9:	e9 83 fc ff ff       	jmp    101f71 <__alltraps>

001022ee <vector97>:
.globl vector97
vector97:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $97
  1022f0:	6a 61                	push   $0x61
  jmp __alltraps
  1022f2:	e9 7a fc ff ff       	jmp    101f71 <__alltraps>

001022f7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $98
  1022f9:	6a 62                	push   $0x62
  jmp __alltraps
  1022fb:	e9 71 fc ff ff       	jmp    101f71 <__alltraps>

00102300 <vector99>:
.globl vector99
vector99:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $99
  102302:	6a 63                	push   $0x63
  jmp __alltraps
  102304:	e9 68 fc ff ff       	jmp    101f71 <__alltraps>

00102309 <vector100>:
.globl vector100
vector100:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $100
  10230b:	6a 64                	push   $0x64
  jmp __alltraps
  10230d:	e9 5f fc ff ff       	jmp    101f71 <__alltraps>

00102312 <vector101>:
.globl vector101
vector101:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $101
  102314:	6a 65                	push   $0x65
  jmp __alltraps
  102316:	e9 56 fc ff ff       	jmp    101f71 <__alltraps>

0010231b <vector102>:
.globl vector102
vector102:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $102
  10231d:	6a 66                	push   $0x66
  jmp __alltraps
  10231f:	e9 4d fc ff ff       	jmp    101f71 <__alltraps>

00102324 <vector103>:
.globl vector103
vector103:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $103
  102326:	6a 67                	push   $0x67
  jmp __alltraps
  102328:	e9 44 fc ff ff       	jmp    101f71 <__alltraps>

0010232d <vector104>:
.globl vector104
vector104:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $104
  10232f:	6a 68                	push   $0x68
  jmp __alltraps
  102331:	e9 3b fc ff ff       	jmp    101f71 <__alltraps>

00102336 <vector105>:
.globl vector105
vector105:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $105
  102338:	6a 69                	push   $0x69
  jmp __alltraps
  10233a:	e9 32 fc ff ff       	jmp    101f71 <__alltraps>

0010233f <vector106>:
.globl vector106
vector106:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $106
  102341:	6a 6a                	push   $0x6a
  jmp __alltraps
  102343:	e9 29 fc ff ff       	jmp    101f71 <__alltraps>

00102348 <vector107>:
.globl vector107
vector107:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $107
  10234a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10234c:	e9 20 fc ff ff       	jmp    101f71 <__alltraps>

00102351 <vector108>:
.globl vector108
vector108:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $108
  102353:	6a 6c                	push   $0x6c
  jmp __alltraps
  102355:	e9 17 fc ff ff       	jmp    101f71 <__alltraps>

0010235a <vector109>:
.globl vector109
vector109:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $109
  10235c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10235e:	e9 0e fc ff ff       	jmp    101f71 <__alltraps>

00102363 <vector110>:
.globl vector110
vector110:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $110
  102365:	6a 6e                	push   $0x6e
  jmp __alltraps
  102367:	e9 05 fc ff ff       	jmp    101f71 <__alltraps>

0010236c <vector111>:
.globl vector111
vector111:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $111
  10236e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102370:	e9 fc fb ff ff       	jmp    101f71 <__alltraps>

00102375 <vector112>:
.globl vector112
vector112:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $112
  102377:	6a 70                	push   $0x70
  jmp __alltraps
  102379:	e9 f3 fb ff ff       	jmp    101f71 <__alltraps>

0010237e <vector113>:
.globl vector113
vector113:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $113
  102380:	6a 71                	push   $0x71
  jmp __alltraps
  102382:	e9 ea fb ff ff       	jmp    101f71 <__alltraps>

00102387 <vector114>:
.globl vector114
vector114:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $114
  102389:	6a 72                	push   $0x72
  jmp __alltraps
  10238b:	e9 e1 fb ff ff       	jmp    101f71 <__alltraps>

00102390 <vector115>:
.globl vector115
vector115:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $115
  102392:	6a 73                	push   $0x73
  jmp __alltraps
  102394:	e9 d8 fb ff ff       	jmp    101f71 <__alltraps>

00102399 <vector116>:
.globl vector116
vector116:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $116
  10239b:	6a 74                	push   $0x74
  jmp __alltraps
  10239d:	e9 cf fb ff ff       	jmp    101f71 <__alltraps>

001023a2 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $117
  1023a4:	6a 75                	push   $0x75
  jmp __alltraps
  1023a6:	e9 c6 fb ff ff       	jmp    101f71 <__alltraps>

001023ab <vector118>:
.globl vector118
vector118:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $118
  1023ad:	6a 76                	push   $0x76
  jmp __alltraps
  1023af:	e9 bd fb ff ff       	jmp    101f71 <__alltraps>

001023b4 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $119
  1023b6:	6a 77                	push   $0x77
  jmp __alltraps
  1023b8:	e9 b4 fb ff ff       	jmp    101f71 <__alltraps>

001023bd <vector120>:
.globl vector120
vector120:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $120
  1023bf:	6a 78                	push   $0x78
  jmp __alltraps
  1023c1:	e9 ab fb ff ff       	jmp    101f71 <__alltraps>

001023c6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $121
  1023c8:	6a 79                	push   $0x79
  jmp __alltraps
  1023ca:	e9 a2 fb ff ff       	jmp    101f71 <__alltraps>

001023cf <vector122>:
.globl vector122
vector122:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $122
  1023d1:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023d3:	e9 99 fb ff ff       	jmp    101f71 <__alltraps>

001023d8 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $123
  1023da:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023dc:	e9 90 fb ff ff       	jmp    101f71 <__alltraps>

001023e1 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $124
  1023e3:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023e5:	e9 87 fb ff ff       	jmp    101f71 <__alltraps>

001023ea <vector125>:
.globl vector125
vector125:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $125
  1023ec:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023ee:	e9 7e fb ff ff       	jmp    101f71 <__alltraps>

001023f3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $126
  1023f5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023f7:	e9 75 fb ff ff       	jmp    101f71 <__alltraps>

001023fc <vector127>:
.globl vector127
vector127:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $127
  1023fe:	6a 7f                	push   $0x7f
  jmp __alltraps
  102400:	e9 6c fb ff ff       	jmp    101f71 <__alltraps>

00102405 <vector128>:
.globl vector128
vector128:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $128
  102407:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10240c:	e9 60 fb ff ff       	jmp    101f71 <__alltraps>

00102411 <vector129>:
.globl vector129
vector129:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $129
  102413:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102418:	e9 54 fb ff ff       	jmp    101f71 <__alltraps>

0010241d <vector130>:
.globl vector130
vector130:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $130
  10241f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102424:	e9 48 fb ff ff       	jmp    101f71 <__alltraps>

00102429 <vector131>:
.globl vector131
vector131:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $131
  10242b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102430:	e9 3c fb ff ff       	jmp    101f71 <__alltraps>

00102435 <vector132>:
.globl vector132
vector132:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $132
  102437:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10243c:	e9 30 fb ff ff       	jmp    101f71 <__alltraps>

00102441 <vector133>:
.globl vector133
vector133:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $133
  102443:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102448:	e9 24 fb ff ff       	jmp    101f71 <__alltraps>

0010244d <vector134>:
.globl vector134
vector134:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $134
  10244f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102454:	e9 18 fb ff ff       	jmp    101f71 <__alltraps>

00102459 <vector135>:
.globl vector135
vector135:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $135
  10245b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102460:	e9 0c fb ff ff       	jmp    101f71 <__alltraps>

00102465 <vector136>:
.globl vector136
vector136:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $136
  102467:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10246c:	e9 00 fb ff ff       	jmp    101f71 <__alltraps>

00102471 <vector137>:
.globl vector137
vector137:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $137
  102473:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102478:	e9 f4 fa ff ff       	jmp    101f71 <__alltraps>

0010247d <vector138>:
.globl vector138
vector138:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $138
  10247f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102484:	e9 e8 fa ff ff       	jmp    101f71 <__alltraps>

00102489 <vector139>:
.globl vector139
vector139:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $139
  10248b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102490:	e9 dc fa ff ff       	jmp    101f71 <__alltraps>

00102495 <vector140>:
.globl vector140
vector140:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $140
  102497:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10249c:	e9 d0 fa ff ff       	jmp    101f71 <__alltraps>

001024a1 <vector141>:
.globl vector141
vector141:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $141
  1024a3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024a8:	e9 c4 fa ff ff       	jmp    101f71 <__alltraps>

001024ad <vector142>:
.globl vector142
vector142:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $142
  1024af:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024b4:	e9 b8 fa ff ff       	jmp    101f71 <__alltraps>

001024b9 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $143
  1024bb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024c0:	e9 ac fa ff ff       	jmp    101f71 <__alltraps>

001024c5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $144
  1024c7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024cc:	e9 a0 fa ff ff       	jmp    101f71 <__alltraps>

001024d1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $145
  1024d3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024d8:	e9 94 fa ff ff       	jmp    101f71 <__alltraps>

001024dd <vector146>:
.globl vector146
vector146:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $146
  1024df:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024e4:	e9 88 fa ff ff       	jmp    101f71 <__alltraps>

001024e9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $147
  1024eb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024f0:	e9 7c fa ff ff       	jmp    101f71 <__alltraps>

001024f5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $148
  1024f7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024fc:	e9 70 fa ff ff       	jmp    101f71 <__alltraps>

00102501 <vector149>:
.globl vector149
vector149:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $149
  102503:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102508:	e9 64 fa ff ff       	jmp    101f71 <__alltraps>

0010250d <vector150>:
.globl vector150
vector150:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $150
  10250f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102514:	e9 58 fa ff ff       	jmp    101f71 <__alltraps>

00102519 <vector151>:
.globl vector151
vector151:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $151
  10251b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102520:	e9 4c fa ff ff       	jmp    101f71 <__alltraps>

00102525 <vector152>:
.globl vector152
vector152:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $152
  102527:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10252c:	e9 40 fa ff ff       	jmp    101f71 <__alltraps>

00102531 <vector153>:
.globl vector153
vector153:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $153
  102533:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102538:	e9 34 fa ff ff       	jmp    101f71 <__alltraps>

0010253d <vector154>:
.globl vector154
vector154:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $154
  10253f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102544:	e9 28 fa ff ff       	jmp    101f71 <__alltraps>

00102549 <vector155>:
.globl vector155
vector155:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $155
  10254b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102550:	e9 1c fa ff ff       	jmp    101f71 <__alltraps>

00102555 <vector156>:
.globl vector156
vector156:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $156
  102557:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10255c:	e9 10 fa ff ff       	jmp    101f71 <__alltraps>

00102561 <vector157>:
.globl vector157
vector157:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $157
  102563:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102568:	e9 04 fa ff ff       	jmp    101f71 <__alltraps>

0010256d <vector158>:
.globl vector158
vector158:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $158
  10256f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102574:	e9 f8 f9 ff ff       	jmp    101f71 <__alltraps>

00102579 <vector159>:
.globl vector159
vector159:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $159
  10257b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102580:	e9 ec f9 ff ff       	jmp    101f71 <__alltraps>

00102585 <vector160>:
.globl vector160
vector160:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $160
  102587:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10258c:	e9 e0 f9 ff ff       	jmp    101f71 <__alltraps>

00102591 <vector161>:
.globl vector161
vector161:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $161
  102593:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102598:	e9 d4 f9 ff ff       	jmp    101f71 <__alltraps>

0010259d <vector162>:
.globl vector162
vector162:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $162
  10259f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025a4:	e9 c8 f9 ff ff       	jmp    101f71 <__alltraps>

001025a9 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $163
  1025ab:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025b0:	e9 bc f9 ff ff       	jmp    101f71 <__alltraps>

001025b5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $164
  1025b7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025bc:	e9 b0 f9 ff ff       	jmp    101f71 <__alltraps>

001025c1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $165
  1025c3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025c8:	e9 a4 f9 ff ff       	jmp    101f71 <__alltraps>

001025cd <vector166>:
.globl vector166
vector166:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $166
  1025cf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025d4:	e9 98 f9 ff ff       	jmp    101f71 <__alltraps>

001025d9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $167
  1025db:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025e0:	e9 8c f9 ff ff       	jmp    101f71 <__alltraps>

001025e5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $168
  1025e7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025ec:	e9 80 f9 ff ff       	jmp    101f71 <__alltraps>

001025f1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $169
  1025f3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025f8:	e9 74 f9 ff ff       	jmp    101f71 <__alltraps>

001025fd <vector170>:
.globl vector170
vector170:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $170
  1025ff:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102604:	e9 68 f9 ff ff       	jmp    101f71 <__alltraps>

00102609 <vector171>:
.globl vector171
vector171:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $171
  10260b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102610:	e9 5c f9 ff ff       	jmp    101f71 <__alltraps>

00102615 <vector172>:
.globl vector172
vector172:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $172
  102617:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10261c:	e9 50 f9 ff ff       	jmp    101f71 <__alltraps>

00102621 <vector173>:
.globl vector173
vector173:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $173
  102623:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102628:	e9 44 f9 ff ff       	jmp    101f71 <__alltraps>

0010262d <vector174>:
.globl vector174
vector174:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $174
  10262f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102634:	e9 38 f9 ff ff       	jmp    101f71 <__alltraps>

00102639 <vector175>:
.globl vector175
vector175:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $175
  10263b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102640:	e9 2c f9 ff ff       	jmp    101f71 <__alltraps>

00102645 <vector176>:
.globl vector176
vector176:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $176
  102647:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10264c:	e9 20 f9 ff ff       	jmp    101f71 <__alltraps>

00102651 <vector177>:
.globl vector177
vector177:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $177
  102653:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102658:	e9 14 f9 ff ff       	jmp    101f71 <__alltraps>

0010265d <vector178>:
.globl vector178
vector178:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $178
  10265f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102664:	e9 08 f9 ff ff       	jmp    101f71 <__alltraps>

00102669 <vector179>:
.globl vector179
vector179:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $179
  10266b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102670:	e9 fc f8 ff ff       	jmp    101f71 <__alltraps>

00102675 <vector180>:
.globl vector180
vector180:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $180
  102677:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10267c:	e9 f0 f8 ff ff       	jmp    101f71 <__alltraps>

00102681 <vector181>:
.globl vector181
vector181:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $181
  102683:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102688:	e9 e4 f8 ff ff       	jmp    101f71 <__alltraps>

0010268d <vector182>:
.globl vector182
vector182:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $182
  10268f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102694:	e9 d8 f8 ff ff       	jmp    101f71 <__alltraps>

00102699 <vector183>:
.globl vector183
vector183:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $183
  10269b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026a0:	e9 cc f8 ff ff       	jmp    101f71 <__alltraps>

001026a5 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $184
  1026a7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026ac:	e9 c0 f8 ff ff       	jmp    101f71 <__alltraps>

001026b1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $185
  1026b3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026b8:	e9 b4 f8 ff ff       	jmp    101f71 <__alltraps>

001026bd <vector186>:
.globl vector186
vector186:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $186
  1026bf:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026c4:	e9 a8 f8 ff ff       	jmp    101f71 <__alltraps>

001026c9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $187
  1026cb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026d0:	e9 9c f8 ff ff       	jmp    101f71 <__alltraps>

001026d5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $188
  1026d7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026dc:	e9 90 f8 ff ff       	jmp    101f71 <__alltraps>

001026e1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $189
  1026e3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026e8:	e9 84 f8 ff ff       	jmp    101f71 <__alltraps>

001026ed <vector190>:
.globl vector190
vector190:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $190
  1026ef:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026f4:	e9 78 f8 ff ff       	jmp    101f71 <__alltraps>

001026f9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $191
  1026fb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102700:	e9 6c f8 ff ff       	jmp    101f71 <__alltraps>

00102705 <vector192>:
.globl vector192
vector192:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $192
  102707:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10270c:	e9 60 f8 ff ff       	jmp    101f71 <__alltraps>

00102711 <vector193>:
.globl vector193
vector193:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $193
  102713:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102718:	e9 54 f8 ff ff       	jmp    101f71 <__alltraps>

0010271d <vector194>:
.globl vector194
vector194:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $194
  10271f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102724:	e9 48 f8 ff ff       	jmp    101f71 <__alltraps>

00102729 <vector195>:
.globl vector195
vector195:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $195
  10272b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102730:	e9 3c f8 ff ff       	jmp    101f71 <__alltraps>

00102735 <vector196>:
.globl vector196
vector196:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $196
  102737:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10273c:	e9 30 f8 ff ff       	jmp    101f71 <__alltraps>

00102741 <vector197>:
.globl vector197
vector197:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $197
  102743:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102748:	e9 24 f8 ff ff       	jmp    101f71 <__alltraps>

0010274d <vector198>:
.globl vector198
vector198:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $198
  10274f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102754:	e9 18 f8 ff ff       	jmp    101f71 <__alltraps>

00102759 <vector199>:
.globl vector199
vector199:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $199
  10275b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102760:	e9 0c f8 ff ff       	jmp    101f71 <__alltraps>

00102765 <vector200>:
.globl vector200
vector200:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $200
  102767:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10276c:	e9 00 f8 ff ff       	jmp    101f71 <__alltraps>

00102771 <vector201>:
.globl vector201
vector201:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $201
  102773:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102778:	e9 f4 f7 ff ff       	jmp    101f71 <__alltraps>

0010277d <vector202>:
.globl vector202
vector202:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $202
  10277f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102784:	e9 e8 f7 ff ff       	jmp    101f71 <__alltraps>

00102789 <vector203>:
.globl vector203
vector203:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $203
  10278b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102790:	e9 dc f7 ff ff       	jmp    101f71 <__alltraps>

00102795 <vector204>:
.globl vector204
vector204:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $204
  102797:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10279c:	e9 d0 f7 ff ff       	jmp    101f71 <__alltraps>

001027a1 <vector205>:
.globl vector205
vector205:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $205
  1027a3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027a8:	e9 c4 f7 ff ff       	jmp    101f71 <__alltraps>

001027ad <vector206>:
.globl vector206
vector206:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $206
  1027af:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027b4:	e9 b8 f7 ff ff       	jmp    101f71 <__alltraps>

001027b9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $207
  1027bb:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027c0:	e9 ac f7 ff ff       	jmp    101f71 <__alltraps>

001027c5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $208
  1027c7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027cc:	e9 a0 f7 ff ff       	jmp    101f71 <__alltraps>

001027d1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $209
  1027d3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027d8:	e9 94 f7 ff ff       	jmp    101f71 <__alltraps>

001027dd <vector210>:
.globl vector210
vector210:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $210
  1027df:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027e4:	e9 88 f7 ff ff       	jmp    101f71 <__alltraps>

001027e9 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $211
  1027eb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027f0:	e9 7c f7 ff ff       	jmp    101f71 <__alltraps>

001027f5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $212
  1027f7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027fc:	e9 70 f7 ff ff       	jmp    101f71 <__alltraps>

00102801 <vector213>:
.globl vector213
vector213:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $213
  102803:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102808:	e9 64 f7 ff ff       	jmp    101f71 <__alltraps>

0010280d <vector214>:
.globl vector214
vector214:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $214
  10280f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102814:	e9 58 f7 ff ff       	jmp    101f71 <__alltraps>

00102819 <vector215>:
.globl vector215
vector215:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $215
  10281b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102820:	e9 4c f7 ff ff       	jmp    101f71 <__alltraps>

00102825 <vector216>:
.globl vector216
vector216:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $216
  102827:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10282c:	e9 40 f7 ff ff       	jmp    101f71 <__alltraps>

00102831 <vector217>:
.globl vector217
vector217:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $217
  102833:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102838:	e9 34 f7 ff ff       	jmp    101f71 <__alltraps>

0010283d <vector218>:
.globl vector218
vector218:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $218
  10283f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102844:	e9 28 f7 ff ff       	jmp    101f71 <__alltraps>

00102849 <vector219>:
.globl vector219
vector219:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $219
  10284b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102850:	e9 1c f7 ff ff       	jmp    101f71 <__alltraps>

00102855 <vector220>:
.globl vector220
vector220:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $220
  102857:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10285c:	e9 10 f7 ff ff       	jmp    101f71 <__alltraps>

00102861 <vector221>:
.globl vector221
vector221:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $221
  102863:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102868:	e9 04 f7 ff ff       	jmp    101f71 <__alltraps>

0010286d <vector222>:
.globl vector222
vector222:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $222
  10286f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102874:	e9 f8 f6 ff ff       	jmp    101f71 <__alltraps>

00102879 <vector223>:
.globl vector223
vector223:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $223
  10287b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102880:	e9 ec f6 ff ff       	jmp    101f71 <__alltraps>

00102885 <vector224>:
.globl vector224
vector224:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $224
  102887:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10288c:	e9 e0 f6 ff ff       	jmp    101f71 <__alltraps>

00102891 <vector225>:
.globl vector225
vector225:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $225
  102893:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102898:	e9 d4 f6 ff ff       	jmp    101f71 <__alltraps>

0010289d <vector226>:
.globl vector226
vector226:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $226
  10289f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028a4:	e9 c8 f6 ff ff       	jmp    101f71 <__alltraps>

001028a9 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $227
  1028ab:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028b0:	e9 bc f6 ff ff       	jmp    101f71 <__alltraps>

001028b5 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $228
  1028b7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028bc:	e9 b0 f6 ff ff       	jmp    101f71 <__alltraps>

001028c1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $229
  1028c3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028c8:	e9 a4 f6 ff ff       	jmp    101f71 <__alltraps>

001028cd <vector230>:
.globl vector230
vector230:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $230
  1028cf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028d4:	e9 98 f6 ff ff       	jmp    101f71 <__alltraps>

001028d9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $231
  1028db:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028e0:	e9 8c f6 ff ff       	jmp    101f71 <__alltraps>

001028e5 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $232
  1028e7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028ec:	e9 80 f6 ff ff       	jmp    101f71 <__alltraps>

001028f1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $233
  1028f3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028f8:	e9 74 f6 ff ff       	jmp    101f71 <__alltraps>

001028fd <vector234>:
.globl vector234
vector234:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $234
  1028ff:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102904:	e9 68 f6 ff ff       	jmp    101f71 <__alltraps>

00102909 <vector235>:
.globl vector235
vector235:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $235
  10290b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102910:	e9 5c f6 ff ff       	jmp    101f71 <__alltraps>

00102915 <vector236>:
.globl vector236
vector236:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $236
  102917:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10291c:	e9 50 f6 ff ff       	jmp    101f71 <__alltraps>

00102921 <vector237>:
.globl vector237
vector237:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $237
  102923:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102928:	e9 44 f6 ff ff       	jmp    101f71 <__alltraps>

0010292d <vector238>:
.globl vector238
vector238:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $238
  10292f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102934:	e9 38 f6 ff ff       	jmp    101f71 <__alltraps>

00102939 <vector239>:
.globl vector239
vector239:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $239
  10293b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102940:	e9 2c f6 ff ff       	jmp    101f71 <__alltraps>

00102945 <vector240>:
.globl vector240
vector240:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $240
  102947:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10294c:	e9 20 f6 ff ff       	jmp    101f71 <__alltraps>

00102951 <vector241>:
.globl vector241
vector241:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $241
  102953:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102958:	e9 14 f6 ff ff       	jmp    101f71 <__alltraps>

0010295d <vector242>:
.globl vector242
vector242:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $242
  10295f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102964:	e9 08 f6 ff ff       	jmp    101f71 <__alltraps>

00102969 <vector243>:
.globl vector243
vector243:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $243
  10296b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102970:	e9 fc f5 ff ff       	jmp    101f71 <__alltraps>

00102975 <vector244>:
.globl vector244
vector244:
  pushl $0
  102975:	6a 00                	push   $0x0
  pushl $244
  102977:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10297c:	e9 f0 f5 ff ff       	jmp    101f71 <__alltraps>

00102981 <vector245>:
.globl vector245
vector245:
  pushl $0
  102981:	6a 00                	push   $0x0
  pushl $245
  102983:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102988:	e9 e4 f5 ff ff       	jmp    101f71 <__alltraps>

0010298d <vector246>:
.globl vector246
vector246:
  pushl $0
  10298d:	6a 00                	push   $0x0
  pushl $246
  10298f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102994:	e9 d8 f5 ff ff       	jmp    101f71 <__alltraps>

00102999 <vector247>:
.globl vector247
vector247:
  pushl $0
  102999:	6a 00                	push   $0x0
  pushl $247
  10299b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029a0:	e9 cc f5 ff ff       	jmp    101f71 <__alltraps>

001029a5 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029a5:	6a 00                	push   $0x0
  pushl $248
  1029a7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029ac:	e9 c0 f5 ff ff       	jmp    101f71 <__alltraps>

001029b1 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029b1:	6a 00                	push   $0x0
  pushl $249
  1029b3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029b8:	e9 b4 f5 ff ff       	jmp    101f71 <__alltraps>

001029bd <vector250>:
.globl vector250
vector250:
  pushl $0
  1029bd:	6a 00                	push   $0x0
  pushl $250
  1029bf:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029c4:	e9 a8 f5 ff ff       	jmp    101f71 <__alltraps>

001029c9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029c9:	6a 00                	push   $0x0
  pushl $251
  1029cb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029d0:	e9 9c f5 ff ff       	jmp    101f71 <__alltraps>

001029d5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029d5:	6a 00                	push   $0x0
  pushl $252
  1029d7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029dc:	e9 90 f5 ff ff       	jmp    101f71 <__alltraps>

001029e1 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029e1:	6a 00                	push   $0x0
  pushl $253
  1029e3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029e8:	e9 84 f5 ff ff       	jmp    101f71 <__alltraps>

001029ed <vector254>:
.globl vector254
vector254:
  pushl $0
  1029ed:	6a 00                	push   $0x0
  pushl $254
  1029ef:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029f4:	e9 78 f5 ff ff       	jmp    101f71 <__alltraps>

001029f9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029f9:	6a 00                	push   $0x0
  pushl $255
  1029fb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a00:	e9 6c f5 ff ff       	jmp    101f71 <__alltraps>

00102a05 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a05:	55                   	push   %ebp
  102a06:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a08:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a11:	29 d0                	sub    %edx,%eax
  102a13:	c1 f8 02             	sar    $0x2,%eax
  102a16:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a1c:	5d                   	pop    %ebp
  102a1d:	c3                   	ret    

00102a1e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a1e:	55                   	push   %ebp
  102a1f:	89 e5                	mov    %esp,%ebp
  102a21:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a24:	8b 45 08             	mov    0x8(%ebp),%eax
  102a27:	89 04 24             	mov    %eax,(%esp)
  102a2a:	e8 d6 ff ff ff       	call   102a05 <page2ppn>
  102a2f:	c1 e0 0c             	shl    $0xc,%eax
}
  102a32:	89 ec                	mov    %ebp,%esp
  102a34:	5d                   	pop    %ebp
  102a35:	c3                   	ret    

00102a36 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
  102a36:	55                   	push   %ebp
  102a37:	89 e5                	mov    %esp,%ebp
  102a39:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3f:	89 04 24             	mov    %eax,(%esp)
  102a42:	e8 d7 ff ff ff       	call   102a1e <page2pa>
  102a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a4d:	c1 e8 0c             	shr    $0xc,%eax
  102a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a53:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  102a58:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a5b:	72 23                	jb     102a80 <page2kva+0x4a>
  102a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a60:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a64:	c7 44 24 08 30 74 10 	movl   $0x107430,0x8(%esp)
  102a6b:	00 
  102a6c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a73:	00 
  102a74:	c7 04 24 53 74 10 00 	movl   $0x107453,(%esp)
  102a7b:	e8 6a e2 ff ff       	call   100cea <__panic>
  102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a83:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a88:	89 ec                	mov    %ebp,%esp
  102a8a:	5d                   	pop    %ebp
  102a8b:	c3                   	ret    

00102a8c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102a8c:	55                   	push   %ebp
  102a8d:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a92:	8b 00                	mov    (%eax),%eax
}
  102a94:	5d                   	pop    %ebp
  102a95:	c3                   	ret    

00102a96 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a96:	55                   	push   %ebp
  102a97:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a99:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a9f:	89 10                	mov    %edx,(%eax)
}
  102aa1:	90                   	nop
  102aa2:	5d                   	pop    %ebp
  102aa3:	c3                   	ret    

00102aa4 <get_proper_size>:

#define IS_POWER_OF_2(x) (!((x) & ((x)-1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int get_proper_size(int size)
{
  102aa4:	55                   	push   %ebp
  102aa5:	89 e5                	mov    %esp,%ebp
  102aa7:	83 ec 10             	sub    $0x10,%esp
    int n = 0, tmp = size;
  102aaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (tmp >>= 1)
  102ab7:	eb 03                	jmp    102abc <get_proper_size+0x18>
    {
        n++;
  102ab9:	ff 45 fc             	incl   -0x4(%ebp)
    while (tmp >>= 1)
  102abc:	d1 7d f8             	sarl   -0x8(%ebp)
  102abf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  102ac3:	75 f4                	jne    102ab9 <get_proper_size+0x15>
    }
    tmp = (size >> n) << n;
  102ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  102acb:	88 c1                	mov    %al,%cl
  102acd:	d3 fa                	sar    %cl,%edx
  102acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ad2:	88 c1                	mov    %al,%cl
  102ad4:	d3 e2                	shl    %cl,%edx
  102ad6:	89 d0                	mov    %edx,%eax
  102ad8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    n += ((size - tmp) != 0);
  102adb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ade:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102ae1:	0f 95 c0             	setne  %al
  102ae4:	0f b6 c0             	movzbl %al,%eax
  102ae7:	01 45 fc             	add    %eax,-0x4(%ebp)
    return n;
  102aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102aed:	89 ec                	mov    %ebp,%esp
  102aef:	5d                   	pop    %ebp
  102af0:	c3                   	ret    

00102af1 <buddy_init>:

int free_page_num, manager_size;

static void
buddy_init(void)
{
  102af1:	55                   	push   %ebp
  102af2:	89 e5                	mov    %esp,%ebp
    free_page_num = 0;
  102af4:	c7 05 88 ee 11 00 00 	movl   $0x0,0x11ee88
  102afb:	00 00 00 
}
  102afe:	90                   	nop
  102aff:	5d                   	pop    %ebp
  102b00:	c3                   	ret    

00102b01 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n)
{
  102b01:	55                   	push   %ebp
  102b02:	89 e5                	mov    %esp,%ebp
  102b04:	83 ec 48             	sub    $0x48,%esp
    struct Page *p;
    for (p = base; p != base + n; p++)
  102b07:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b0d:	e9 97 00 00 00       	jmp    102ba9 <buddy_init_memmap+0xa8>
    {
        assert(PageReserved(p));
  102b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b15:	83 c0 04             	add    $0x4,%eax
  102b18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102b1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * */
static inline bool
test_bit(int nr, volatile void *addr)
{
    int oldbit;
    asm volatile("btl %2, %1; sbbl %0,%0"
  102b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102b28:	0f a3 10             	bt     %edx,(%eax)
  102b2b:	19 c0                	sbb    %eax,%eax
  102b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
                 : "=r"(oldbit)
                 : "m"(*(volatile long *)addr), "Ir"(nr));
    return oldbit != 0;
  102b30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102b34:	0f 95 c0             	setne  %al
  102b37:	0f b6 c0             	movzbl %al,%eax
  102b3a:	85 c0                	test   %eax,%eax
  102b3c:	75 24                	jne    102b62 <buddy_init_memmap+0x61>
  102b3e:	c7 44 24 0c 61 74 10 	movl   $0x107461,0xc(%esp)
  102b45:	00 
  102b46:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  102b4d:	00 
  102b4e:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  102b55:	00 
  102b56:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  102b5d:	e8 88 e1 ff ff       	call   100cea <__panic>
        p->flags = p->property = 0;
  102b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b6f:	8b 50 08             	mov    0x8(%eax),%edx
  102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b75:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b7f:	00 
  102b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b83:	89 04 24             	mov    %eax,(%esp)
  102b86:	e8 0b ff ff ff       	call   102a96 <set_page_ref>
        SetPageProperty(p);
  102b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b8e:	83 c0 04             	add    $0x4,%eax
  102b91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102b98:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btsl %1, %0"
  102b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ba1:	0f ab 10             	bts    %edx,(%eax)
}
  102ba4:	90                   	nop
    for (p = base; p != base + n; p++)
  102ba5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bac:	89 d0                	mov    %edx,%eax
  102bae:	c1 e0 02             	shl    $0x2,%eax
  102bb1:	01 d0                	add    %edx,%eax
  102bb3:	c1 e0 02             	shl    $0x2,%eax
  102bb6:	89 c2                	mov    %eax,%edx
  102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbb:	01 d0                	add    %edx,%eax
  102bbd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102bc0:	0f 85 4c ff ff ff    	jne    102b12 <buddy_init_memmap+0x11>
    }
    manager_size = 2 * (1 << get_proper_size(n));
  102bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc9:	89 04 24             	mov    %eax,(%esp)
  102bcc:	e8 d3 fe ff ff       	call   102aa4 <get_proper_size>
  102bd1:	ba 02 00 00 00       	mov    $0x2,%edx
  102bd6:	88 c1                	mov    %al,%cl
  102bd8:	d3 e2                	shl    %cl,%edx
  102bda:	89 d0                	mov    %edx,%eax
  102bdc:	a3 8c ee 11 00       	mov    %eax,0x11ee8c
    // 获取 buddy_manager 的起始地址 预留base最开始的部分给 buddy_manager
    buddy_manager = (unsigned *)page2kva(base);
  102be1:	8b 45 08             	mov    0x8(%ebp),%eax
  102be4:	89 04 24             	mov    %eax,(%esp)
  102be7:	e8 4a fe ff ff       	call   102a36 <page2kva>
  102bec:	a3 80 ee 11 00       	mov    %eax,0x11ee80
    base += 4 * manager_size / 4096;
  102bf1:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102bf6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  102bfc:	85 c0                	test   %eax,%eax
  102bfe:	0f 48 c2             	cmovs  %edx,%eax
  102c01:	c1 f8 0a             	sar    $0xa,%eax
  102c04:	89 c2                	mov    %eax,%edx
  102c06:	89 d0                	mov    %edx,%eax
  102c08:	c1 e0 02             	shl    $0x2,%eax
  102c0b:	01 d0                	add    %edx,%eax
  102c0d:	c1 e0 02             	shl    $0x2,%eax
  102c10:	01 45 08             	add    %eax,0x8(%ebp)
    // page_base 用来在后续申请和释放内存的时候提供可用内存空间的起始地址
    page_base = base;
  102c13:	8b 45 08             	mov    0x8(%ebp),%eax
  102c16:	a3 84 ee 11 00       	mov    %eax,0x11ee84
    // 剩余可用页数
    free_page_num = n - 4 * manager_size / 4096;
  102c1b:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102c20:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  102c26:	85 c0                	test   %eax,%eax
  102c28:	0f 48 c2             	cmovs  %edx,%eax
  102c2b:	c1 f8 0a             	sar    $0xa,%eax
  102c2e:	89 c2                	mov    %eax,%edx
  102c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c33:	29 d0                	sub    %edx,%eax
  102c35:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    unsigned i = 1;
  102c3a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    unsigned node_size = manager_size / 2;
  102c41:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102c46:	89 c2                	mov    %eax,%edx
  102c48:	c1 ea 1f             	shr    $0x1f,%edx
  102c4b:	01 d0                	add    %edx,%eax
  102c4d:	d1 f8                	sar    %eax
  102c4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; i < manager_size; i++)
  102c52:	eb 29                	jmp    102c7d <buddy_init_memmap+0x17c>
    {
        buddy_manager[i] = node_size;
  102c54:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c5d:	c1 e0 02             	shl    $0x2,%eax
  102c60:	01 c2                	add    %eax,%edx
  102c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c65:	89 02                	mov    %eax,(%edx)
        if (IS_POWER_OF_2(i + 1))
  102c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c6a:	40                   	inc    %eax
  102c6b:	23 45 f0             	and    -0x10(%ebp),%eax
  102c6e:	85 c0                	test   %eax,%eax
  102c70:	75 08                	jne    102c7a <buddy_init_memmap+0x179>
        {
            node_size /= 2;
  102c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c75:	d1 e8                	shr    %eax
  102c77:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; i < manager_size; i++)
  102c7a:	ff 45 f0             	incl   -0x10(%ebp)
  102c7d:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102c82:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102c85:	72 cd                	jb     102c54 <buddy_init_memmap+0x153>
        }
    }
    base->property = free_page_num;
  102c87:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102c8c:	89 c2                	mov    %eax,%edx
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102c94:	8b 45 08             	mov    0x8(%ebp),%eax
  102c97:	83 c0 04             	add    $0x4,%eax
  102c9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102ca1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile("btsl %1, %0"
  102ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102caa:	0f ab 10             	bts    %edx,(%eax)
}
  102cad:	90                   	nop
}
  102cae:	90                   	nop
  102caf:	89 ec                	mov    %ebp,%esp
  102cb1:	5d                   	pop    %ebp
  102cb2:	c3                   	ret    

00102cb3 <buddy_alloc>:

int buddy_alloc(int size)
{
  102cb3:	55                   	push   %ebp
  102cb4:	89 e5                	mov    %esp,%ebp
  102cb6:	83 ec 28             	sub    $0x28,%esp
  102cb9:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    unsigned index = 1;
  102cbc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    unsigned offset = 0;
  102cc3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    unsigned node_size;
    // 将size向上取整为2的幂
    if (size <= 0)
  102cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102cce:	7f 09                	jg     102cd9 <buddy_alloc+0x26>
        size = 1;
  102cd0:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
  102cd7:	eb 24                	jmp    102cfd <buddy_alloc+0x4a>
    else if (!IS_POWER_OF_2(size))
  102cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdc:	48                   	dec    %eax
  102cdd:	23 45 08             	and    0x8(%ebp),%eax
  102ce0:	85 c0                	test   %eax,%eax
  102ce2:	74 19                	je     102cfd <buddy_alloc+0x4a>
        size = 1 << get_proper_size(size);
  102ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce7:	89 04 24             	mov    %eax,(%esp)
  102cea:	e8 b5 fd ff ff       	call   102aa4 <get_proper_size>
  102cef:	ba 01 00 00 00       	mov    $0x1,%edx
  102cf4:	88 c1                	mov    %al,%cl
  102cf6:	d3 e2                	shl    %cl,%edx
  102cf8:	89 d0                	mov    %edx,%eax
  102cfa:	89 45 08             	mov    %eax,0x8(%ebp)
    if (buddy_manager[index] < size)
  102cfd:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d06:	c1 e0 02             	shl    $0x2,%eax
  102d09:	01 d0                	add    %edx,%eax
  102d0b:	8b 10                	mov    (%eax),%edx
  102d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d10:	39 c2                	cmp    %eax,%edx
  102d12:	73 0a                	jae    102d1e <buddy_alloc+0x6b>
        return -1;
  102d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102d19:	e9 e1 00 00 00       	jmp    102dff <buddy_alloc+0x14c>
    // 从根节点往下深度遍历，找到恰好等于size的块
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
  102d1e:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102d23:	89 c2                	mov    %eax,%edx
  102d25:	c1 ea 1f             	shr    $0x1f,%edx
  102d28:	01 d0                	add    %edx,%eax
  102d2a:	d1 f8                	sar    %eax
  102d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d2f:	eb 2d                	jmp    102d5e <buddy_alloc+0xab>
    {
        if (buddy_manager[LEFT_LEAF(index)] >= size)
  102d31:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3a:	c1 e0 03             	shl    $0x3,%eax
  102d3d:	01 d0                	add    %edx,%eax
  102d3f:	8b 10                	mov    (%eax),%edx
  102d41:	8b 45 08             	mov    0x8(%ebp),%eax
  102d44:	39 c2                	cmp    %eax,%edx
  102d46:	72 05                	jb     102d4d <buddy_alloc+0x9a>
            index = LEFT_LEAF(index);
  102d48:	d1 65 f4             	shll   -0xc(%ebp)
  102d4b:	eb 09                	jmp    102d56 <buddy_alloc+0xa3>
        else
            index = RIGHT_LEAF(index);
  102d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d50:	01 c0                	add    %eax,%eax
  102d52:	40                   	inc    %eax
  102d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
  102d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d59:	d1 e8                	shr    %eax
  102d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d61:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102d64:	75 cb                	jne    102d31 <buddy_alloc+0x7e>
    }
    buddy_manager[index] = 0;
  102d66:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6f:	c1 e0 02             	shl    $0x2,%eax
  102d72:	01 d0                	add    %edx,%eax
  102d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    offset = (index)*node_size - manager_size / 2;
  102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7d:	0f af 45 f0          	imul   -0x10(%ebp),%eax
  102d81:	89 c2                	mov    %eax,%edx
  102d83:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102d88:	89 c1                	mov    %eax,%ecx
  102d8a:	c1 e9 1f             	shr    $0x1f,%ecx
  102d8d:	01 c8                	add    %ecx,%eax
  102d8f:	d1 f8                	sar    %eax
  102d91:	89 c1                	mov    %eax,%ecx
  102d93:	89 d0                	mov    %edx,%eax
  102d95:	29 c8                	sub    %ecx,%eax
  102d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf(" index:%u offset:%u ", index, offset);
  102d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da8:	c7 04 24 9a 74 10 00 	movl   $0x10749a,(%esp)
  102daf:	e8 b1 d5 ff ff       	call   100365 <cprintf>
    // 向上回溯至根节点，修改沿途节点的大小
    while (index > 1)
  102db4:	eb 40                	jmp    102df6 <buddy_alloc+0x143>
    {
        index = PARENT(index);
  102db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db9:	d1 e8                	shr    %eax
  102dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        buddy_manager[index] = MAX(buddy_manager[LEFT_LEAF(index)], buddy_manager[RIGHT_LEAF(index)]);
  102dbe:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc7:	c1 e0 03             	shl    $0x3,%eax
  102dca:	83 c0 04             	add    $0x4,%eax
  102dcd:	01 d0                	add    %edx,%eax
  102dcf:	8b 10                	mov    (%eax),%edx
  102dd1:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dda:	c1 e0 03             	shl    $0x3,%eax
  102ddd:	01 c8                	add    %ecx,%eax
  102ddf:	8b 00                	mov    (%eax),%eax
  102de1:	8b 1d 80 ee 11 00    	mov    0x11ee80,%ebx
  102de7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  102dea:	c1 e1 02             	shl    $0x2,%ecx
  102ded:	01 d9                	add    %ebx,%ecx
  102def:	39 c2                	cmp    %eax,%edx
  102df1:	0f 43 c2             	cmovae %edx,%eax
  102df4:	89 01                	mov    %eax,(%ecx)
    while (index > 1)
  102df6:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102dfa:	77 ba                	ja     102db6 <buddy_alloc+0x103>
    }
    return offset;
  102dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  102dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102e02:	89 ec                	mov    %ebp,%esp
  102e04:	5d                   	pop    %ebp
  102e05:	c3                   	ret    

00102e06 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n)
{
  102e06:	55                   	push   %ebp
  102e07:	89 e5                	mov    %esp,%ebp
  102e09:	83 ec 38             	sub    $0x38,%esp
    cprintf("alloc %u pages", n);
  102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e13:	c7 04 24 af 74 10 00 	movl   $0x1074af,(%esp)
  102e1a:	e8 46 d5 ff ff       	call   100365 <cprintf>
    assert(n > 0);
  102e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102e23:	75 24                	jne    102e49 <buddy_alloc_pages+0x43>
  102e25:	c7 44 24 0c be 74 10 	movl   $0x1074be,0xc(%esp)
  102e2c:	00 
  102e2d:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  102e34:	00 
  102e35:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  102e3c:	00 
  102e3d:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  102e44:	e8 a1 de ff ff       	call   100cea <__panic>
    if (n > free_page_num)
  102e49:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102e4e:	39 45 08             	cmp    %eax,0x8(%ebp)
  102e51:	76 0a                	jbe    102e5d <buddy_alloc_pages+0x57>
        return NULL;
  102e53:	b8 00 00 00 00       	mov    $0x0,%eax
  102e58:	e9 a3 00 00 00       	jmp    102f00 <buddy_alloc_pages+0xfa>
    // 获取分配的页在内存中的起始地址
    int offset = buddy_alloc(n);
  102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e60:	89 04 24             	mov    %eax,(%esp)
  102e63:	e8 4b fe ff ff       	call   102cb3 <buddy_alloc>
  102e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *base = page_base + offset;
  102e6b:	8b 0d 84 ee 11 00    	mov    0x11ee84,%ecx
  102e71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e74:	89 d0                	mov    %edx,%eax
  102e76:	c1 e0 02             	shl    $0x2,%eax
  102e79:	01 d0                	add    %edx,%eax
  102e7b:	c1 e0 02             	shl    $0x2,%eax
  102e7e:	01 c8                	add    %ecx,%eax
  102e80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct Page *page;
    // 将n向上取整，因为有round_n个块被取出
    int round_n = 1 << get_proper_size(n);
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	89 04 24             	mov    %eax,(%esp)
  102e89:	e8 16 fc ff ff       	call   102aa4 <get_proper_size>
  102e8e:	ba 01 00 00 00       	mov    $0x1,%edx
  102e93:	88 c1                	mov    %al,%cl
  102e95:	d3 e2                	shl    %cl,%edx
  102e97:	89 d0                	mov    %edx,%eax
  102e99:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (page = base; page != base + round_n; page++)
  102e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ea2:	eb 1e                	jmp    102ec2 <buddy_alloc_pages+0xbc>
    {
        ClearPageProperty(page);
  102ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea7:	83 c0 04             	add    $0x4,%eax
  102eaa:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102eb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile("btrl %1, %0"
  102eb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eba:	0f b3 10             	btr    %edx,(%eax)
}
  102ebd:	90                   	nop
    for (page = base; page != base + round_n; page++)
  102ebe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ec2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ec5:	89 d0                	mov    %edx,%eax
  102ec7:	c1 e0 02             	shl    $0x2,%eax
  102eca:	01 d0                	add    %edx,%eax
  102ecc:	c1 e0 02             	shl    $0x2,%eax
  102ecf:	89 c2                	mov    %eax,%edx
  102ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed4:	01 d0                	add    %edx,%eax
  102ed6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ed9:	75 c9                	jne    102ea4 <buddy_alloc_pages+0x9e>
    }
    free_page_num -= round_n;
  102edb:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102ee0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  102ee3:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    base->property = n;
  102ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  102eee:	89 50 08             	mov    %edx,0x8(%eax)
    cprintf("finish!\n");
  102ef1:	c7 04 24 c4 74 10 00 	movl   $0x1074c4,(%esp)
  102ef8:	e8 68 d4 ff ff       	call   100365 <cprintf>
    return base;
  102efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  102f00:	89 ec                	mov    %ebp,%esp
  102f02:	5d                   	pop    %ebp
  102f03:	c3                   	ret    

00102f04 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n)
{
  102f04:	55                   	push   %ebp
  102f05:	89 e5                	mov    %esp,%ebp
  102f07:	83 ec 58             	sub    $0x58,%esp
    cprintf("free  %u pages", n);
  102f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f11:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102f18:	e8 48 d4 ff ff       	call   100365 <cprintf>
    assert(n > 0);
  102f1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f21:	75 24                	jne    102f47 <buddy_free_pages+0x43>
  102f23:	c7 44 24 0c be 74 10 	movl   $0x1074be,0xc(%esp)
  102f2a:	00 
  102f2b:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  102f32:	00 
  102f33:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  102f3a:	00 
  102f3b:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  102f42:	e8 a3 dd ff ff       	call   100cea <__panic>
    n = 1 << get_proper_size(n);
  102f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4a:	89 04 24             	mov    %eax,(%esp)
  102f4d:	e8 52 fb ff ff       	call   102aa4 <get_proper_size>
  102f52:	ba 01 00 00 00       	mov    $0x1,%edx
  102f57:	88 c1                	mov    %al,%cl
  102f59:	d3 e2                	shl    %cl,%edx
  102f5b:	89 d0                	mov    %edx,%eax
  102f5d:	89 45 0c             	mov    %eax,0xc(%ebp)
    assert(!PageReserved(base));
  102f60:	8b 45 08             	mov    0x8(%ebp),%eax
  102f63:	83 c0 04             	add    $0x4,%eax
  102f66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102f70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f76:	0f a3 10             	bt     %edx,(%eax)
  102f79:	19 c0                	sbb    %eax,%eax
  102f7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102f7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102f82:	0f 95 c0             	setne  %al
  102f85:	0f b6 c0             	movzbl %al,%eax
  102f88:	85 c0                	test   %eax,%eax
  102f8a:	74 24                	je     102fb0 <buddy_free_pages+0xac>
  102f8c:	c7 44 24 0c dc 74 10 	movl   $0x1074dc,0xc(%esp)
  102f93:	00 
  102f94:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  102f9b:	00 
  102f9c:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  102fa3:	00 
  102fa4:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  102fab:	e8 3a dd ff ff       	call   100cea <__panic>
    for (struct Page *p = base; p < base + n; p++)
  102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fb6:	e9 93 00 00 00       	jmp    10304e <buddy_free_pages+0x14a>
    {
        assert(!PageReserved(p) && !PageProperty(p)); 
  102fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fbe:	83 c0 04             	add    $0x4,%eax
  102fc1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  102fc8:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102fcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102fce:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102fd1:	0f a3 10             	bt     %edx,(%eax)
  102fd4:	19 c0                	sbb    %eax,%eax
  102fd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  102fd9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  102fdd:	0f 95 c0             	setne  %al
  102fe0:	0f b6 c0             	movzbl %al,%eax
  102fe3:	85 c0                	test   %eax,%eax
  102fe5:	75 2c                	jne    103013 <buddy_free_pages+0x10f>
  102fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fea:	83 c0 04             	add    $0x4,%eax
  102fed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102ff4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102ff7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ffa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ffd:	0f a3 10             	bt     %edx,(%eax)
  103000:	19 c0                	sbb    %eax,%eax
  103002:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
  103005:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103009:	0f 95 c0             	setne  %al
  10300c:	0f b6 c0             	movzbl %al,%eax
  10300f:	85 c0                	test   %eax,%eax
  103011:	74 24                	je     103037 <buddy_free_pages+0x133>
  103013:	c7 44 24 0c f0 74 10 	movl   $0x1074f0,0xc(%esp)
  10301a:	00 
  10301b:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103022:	00 
  103023:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  10302a:	00 
  10302b:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103032:	e8 b3 dc ff ff       	call   100cea <__panic>
        set_page_ref(p, 0);
  103037:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10303e:	00 
  10303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103042:	89 04 24             	mov    %eax,(%esp)
  103045:	e8 4c fa ff ff       	call   102a96 <set_page_ref>
    for (struct Page *p = base; p < base + n; p++)
  10304a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10304e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103051:	89 d0                	mov    %edx,%eax
  103053:	c1 e0 02             	shl    $0x2,%eax
  103056:	01 d0                	add    %edx,%eax
  103058:	c1 e0 02             	shl    $0x2,%eax
  10305b:	89 c2                	mov    %eax,%edx
  10305d:	8b 45 08             	mov    0x8(%ebp),%eax
  103060:	01 d0                	add    %edx,%eax
  103062:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103065:	0f 82 50 ff ff ff    	jb     102fbb <buddy_free_pages+0xb7>
    }
    // 将buddy中的对应节点释放
    unsigned offset = base - page_base;
  10306b:	8b 15 84 ee 11 00    	mov    0x11ee84,%edx
  103071:	8b 45 08             	mov    0x8(%ebp),%eax
  103074:	29 d0                	sub    %edx,%eax
  103076:	c1 f8 02             	sar    $0x2,%eax
  103079:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  10307f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    unsigned index = manager_size / 2 + offset;
  103082:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  103087:	89 c2                	mov    %eax,%edx
  103089:	c1 ea 1f             	shr    $0x1f,%edx
  10308c:	01 d0                	add    %edx,%eax
  10308e:	d1 f8                	sar    %eax
  103090:	89 c2                	mov    %eax,%edx
  103092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103095:	01 d0                	add    %edx,%eax
  103097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned node_size = 1;
  10309a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    while (node_size != n)
  1030a1:	eb 35                	jmp    1030d8 <buddy_free_pages+0x1d4>
    {
        index = PARENT(index);
  1030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a6:	d1 e8                	shr    %eax
  1030a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
  1030ab:	d1 65 ec             	shll   -0x14(%ebp)
        assert(index);
  1030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030b2:	75 24                	jne    1030d8 <buddy_free_pages+0x1d4>
  1030b4:	c7 44 24 0c 15 75 10 	movl   $0x107515,0xc(%esp)
  1030bb:	00 
  1030bc:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  1030c3:	00 
  1030c4:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  1030cb:	00 
  1030cc:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  1030d3:	e8 12 dc ff ff       	call   100cea <__panic>
    while (node_size != n)
  1030d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1030de:	75 c3                	jne    1030a3 <buddy_free_pages+0x19f>
    }
    buddy_manager[index] = node_size;
  1030e0:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e9:	c1 e0 02             	shl    $0x2,%eax
  1030ec:	01 c2                	add    %eax,%edx
  1030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030f1:	89 02                	mov    %eax,(%edx)
    cprintf(" index:%u offset:%u ", index, offset);
  1030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103101:	c7 04 24 9a 74 10 00 	movl   $0x10749a,(%esp)
  103108:	e8 58 d2 ff ff       	call   100365 <cprintf>
    index = PARENT(index);
  10310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103110:	d1 e8                	shr    %eax
  103112:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
  103115:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
  103118:	e9 86 00 00 00       	jmp    1031a3 <buddy_free_pages+0x29f>
    {
        unsigned leftSize = buddy_manager[LEFT_LEAF(index)];
  10311d:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103126:	c1 e0 03             	shl    $0x3,%eax
  103129:	01 d0                	add    %edx,%eax
  10312b:	8b 00                	mov    (%eax),%eax
  10312d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned rightSize = buddy_manager[RIGHT_LEAF(index)];
  103130:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103139:	c1 e0 03             	shl    $0x3,%eax
  10313c:	83 c0 04             	add    $0x4,%eax
  10313f:	01 d0                	add    %edx,%eax
  103141:	8b 00                	mov    (%eax),%eax
  103143:	89 45 e0             	mov    %eax,-0x20(%ebp)
        // 左右节点均全空，连起来
        if (leftSize + rightSize == node_size)
  103146:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10314c:	01 d0                	add    %edx,%eax
  10314e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103151:	75 15                	jne    103168 <buddy_free_pages+0x264>
        {
            buddy_manager[index] = node_size;
  103153:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10315c:	c1 e0 02             	shl    $0x2,%eax
  10315f:	01 c2                	add    %eax,%edx
  103161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103164:	89 02                	mov    %eax,(%edx)
  103166:	eb 30                	jmp    103198 <buddy_free_pages+0x294>
        }
        else if (leftSize > rightSize)
  103168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10316b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  10316e:	76 15                	jbe    103185 <buddy_free_pages+0x281>
        {
            buddy_manager[index] = leftSize;
  103170:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103179:	c1 e0 02             	shl    $0x2,%eax
  10317c:	01 c2                	add    %eax,%edx
  10317e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103181:	89 02                	mov    %eax,(%edx)
  103183:	eb 13                	jmp    103198 <buddy_free_pages+0x294>
        }
        else
        {
            buddy_manager[index] = rightSize;
  103185:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  10318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10318e:	c1 e0 02             	shl    $0x2,%eax
  103191:	01 c2                	add    %eax,%edx
  103193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103196:	89 02                	mov    %eax,(%edx)
        }
        index = PARENT(index);
  103198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319b:	d1 e8                	shr    %eax
  10319d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
  1031a0:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
  1031a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031a7:	0f 85 70 ff ff ff    	jne    10311d <buddy_free_pages+0x219>
    }
    free_page_num += n;
  1031ad:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  1031b2:	89 c2                	mov    %eax,%edx
  1031b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b7:	01 d0                	add    %edx,%eax
  1031b9:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    cprintf("finish!\n");
  1031be:	c7 04 24 c4 74 10 00 	movl   $0x1074c4,(%esp)
  1031c5:	e8 9b d1 ff ff       	call   100365 <cprintf>
}
  1031ca:	90                   	nop
  1031cb:	89 ec                	mov    %ebp,%esp
  1031cd:	5d                   	pop    %ebp
  1031ce:	c3                   	ret    

001031cf <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
  1031cf:	55                   	push   %ebp
  1031d0:	89 e5                	mov    %esp,%ebp
    return free_page_num;
  1031d2:	a1 88 ee 11 00       	mov    0x11ee88,%eax
}
  1031d7:	5d                   	pop    %ebp
  1031d8:	c3                   	ret    

001031d9 <basic_check>:

static void
basic_check(void)
{
  1031d9:	55                   	push   %ebp
  1031da:	89 e5                	mov    %esp,%ebp
}
  1031dc:	90                   	nop
  1031dd:	5d                   	pop    %ebp
  1031de:	c3                   	ret    

001031df <buddy_check>:

static void
buddy_check(void)
{
  1031df:	55                   	push   %ebp
  1031e0:	89 e5                	mov    %esp,%ebp
  1031e2:	83 ec 38             	sub    $0x38,%esp
    cprintf("buddy check!\n");
  1031e5:	c7 04 24 1b 75 10 00 	movl   $0x10751b,(%esp)
  1031ec:	e8 74 d1 ff ff       	call   100365 <cprintf>
    struct Page *p0, *A, *B, *C, *D;
    p0 = A = B = C = D = NULL;
  1031f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103201:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103207:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10320d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
  103210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103217:	e8 07 19 00 00       	call   104b23 <alloc_pages>
  10321c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10321f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103223:	75 24                	jne    103249 <buddy_check+0x6a>
  103225:	c7 44 24 0c 29 75 10 	movl   $0x107529,0xc(%esp)
  10322c:	00 
  10322d:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103234:	00 
  103235:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  10323c:	00 
  10323d:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103244:	e8 a1 da ff ff       	call   100cea <__panic>
    assert((A = alloc_page()) != NULL);
  103249:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103250:	e8 ce 18 00 00       	call   104b23 <alloc_pages>
  103255:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103258:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10325c:	75 24                	jne    103282 <buddy_check+0xa3>
  10325e:	c7 44 24 0c 45 75 10 	movl   $0x107545,0xc(%esp)
  103265:	00 
  103266:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  10326d:	00 
  10326e:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  103275:	00 
  103276:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  10327d:	e8 68 da ff ff       	call   100cea <__panic>
    assert((B = alloc_page()) != NULL);
  103282:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103289:	e8 95 18 00 00       	call   104b23 <alloc_pages>
  10328e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103291:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103295:	75 24                	jne    1032bb <buddy_check+0xdc>
  103297:	c7 44 24 0c 60 75 10 	movl   $0x107560,0xc(%esp)
  10329e:	00 
  10329f:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  1032a6:	00 
  1032a7:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  1032ae:	00 
  1032af:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  1032b6:	e8 2f da ff ff       	call   100cea <__panic>

    assert(p0 != A && p0 != B && A != B);
  1032bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  1032c1:	74 10                	je     1032d3 <buddy_check+0xf4>
  1032c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032c9:	74 08                	je     1032d3 <buddy_check+0xf4>
  1032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032d1:	75 24                	jne    1032f7 <buddy_check+0x118>
  1032d3:	c7 44 24 0c 7b 75 10 	movl   $0x10757b,0xc(%esp)
  1032da:	00 
  1032db:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  1032e2:	00 
  1032e3:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  1032ea:	00 
  1032eb:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  1032f2:	e8 f3 d9 ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
  1032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032fa:	89 04 24             	mov    %eax,(%esp)
  1032fd:	e8 8a f7 ff ff       	call   102a8c <page_ref>
  103302:	85 c0                	test   %eax,%eax
  103304:	75 1e                	jne    103324 <buddy_check+0x145>
  103306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103309:	89 04 24             	mov    %eax,(%esp)
  10330c:	e8 7b f7 ff ff       	call   102a8c <page_ref>
  103311:	85 c0                	test   %eax,%eax
  103313:	75 0f                	jne    103324 <buddy_check+0x145>
  103315:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103318:	89 04 24             	mov    %eax,(%esp)
  10331b:	e8 6c f7 ff ff       	call   102a8c <page_ref>
  103320:	85 c0                	test   %eax,%eax
  103322:	74 24                	je     103348 <buddy_check+0x169>
  103324:	c7 44 24 0c 98 75 10 	movl   $0x107598,0xc(%esp)
  10332b:	00 
  10332c:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103333:	00 
  103334:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  10333b:	00 
  10333c:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103343:	e8 a2 d9 ff ff       	call   100cea <__panic>

    free_page(p0);
  103348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10334f:	00 
  103350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103353:	89 04 24             	mov    %eax,(%esp)
  103356:	e8 02 18 00 00       	call   104b5d <free_pages>
    free_page(A);
  10335b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103362:	00 
  103363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103366:	89 04 24             	mov    %eax,(%esp)
  103369:	e8 ef 17 00 00       	call   104b5d <free_pages>
    free_page(B);
  10336e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103375:	00 
  103376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103379:	89 04 24             	mov    %eax,(%esp)
  10337c:	e8 dc 17 00 00       	call   104b5d <free_pages>

    A = alloc_pages(512);
  103381:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  103388:	e8 96 17 00 00       	call   104b23 <alloc_pages>
  10338d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(512);
  103390:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  103397:	e8 87 17 00 00       	call   104b23 <alloc_pages>
  10339c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    free_pages(A, 256);
  10339f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1033a6:	00 
  1033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033aa:	89 04 24             	mov    %eax,(%esp)
  1033ad:	e8 ab 17 00 00       	call   104b5d <free_pages>
    free_pages(B, 512);
  1033b2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1033b9:	00 
  1033ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033bd:	89 04 24             	mov    %eax,(%esp)
  1033c0:	e8 98 17 00 00       	call   104b5d <free_pages>
    free_pages(A + 256, 256);
  1033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c8:	05 00 14 00 00       	add    $0x1400,%eax
  1033cd:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1033d4:	00 
  1033d5:	89 04 24             	mov    %eax,(%esp)
  1033d8:	e8 80 17 00 00       	call   104b5d <free_pages>

    p0 = alloc_pages(8192);
  1033dd:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
  1033e4:	e8 3a 17 00 00       	call   104b23 <alloc_pages>
  1033e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 == A);
  1033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  1033f2:	74 24                	je     103418 <buddy_check+0x239>
  1033f4:	c7 44 24 0c d2 75 10 	movl   $0x1075d2,0xc(%esp)
  1033fb:	00 
  1033fc:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103403:	00 
  103404:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  10340b:	00 
  10340c:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103413:	e8 d2 d8 ff ff       	call   100cea <__panic>
    A = alloc_pages(128);
  103418:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  10341f:	e8 ff 16 00 00       	call   104b23 <alloc_pages>
  103424:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(64);
  103427:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  10342e:	e8 f0 16 00 00       	call   104b23 <alloc_pages>
  103433:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 检查是否相邻
    assert(A + 128 == B);
  103436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103439:	05 00 0a 00 00       	add    $0xa00,%eax
  10343e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103441:	74 24                	je     103467 <buddy_check+0x288>
  103443:	c7 44 24 0c da 75 10 	movl   $0x1075da,0xc(%esp)
  10344a:	00 
  10344b:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103452:	00 
  103453:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  10345a:	00 
  10345b:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103462:	e8 83 d8 ff ff       	call   100cea <__panic>
    C = alloc_pages(128);
  103467:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  10346e:	e8 b0 16 00 00       	call   104b23 <alloc_pages>
  103473:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C有没有和A重叠
    assert(A + 256 == C);
  103476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103479:	05 00 14 00 00       	add    $0x1400,%eax
  10347e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103481:	74 24                	je     1034a7 <buddy_check+0x2c8>
  103483:	c7 44 24 0c e7 75 10 	movl   $0x1075e7,0xc(%esp)
  10348a:	00 
  10348b:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103492:	00 
  103493:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  10349a:	00 
  10349b:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  1034a2:	e8 43 d8 ff ff       	call   100cea <__panic>
    // 释放A
    free_pages(A, 128);
  1034a7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  1034ae:	00 
  1034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b2:	89 04 24             	mov    %eax,(%esp)
  1034b5:	e8 a3 16 00 00       	call   104b5d <free_pages>
    D = alloc_pages(64);
  1034ba:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  1034c1:	e8 5d 16 00 00       	call   104b23 <alloc_pages>
  1034c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n", D);
  1034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d0:	c7 04 24 f4 75 10 00 	movl   $0x1075f4,(%esp)
  1034d7:	e8 89 ce ff ff       	call   100365 <cprintf>
    // 检查D是否能够使用A刚刚释放的内存
    assert(D + 128 == B);
  1034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034df:	05 00 0a 00 00       	add    $0xa00,%eax
  1034e4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1034e7:	74 24                	je     10350d <buddy_check+0x32e>
  1034e9:	c7 44 24 0c fa 75 10 	movl   $0x1075fa,0xc(%esp)
  1034f0:	00 
  1034f1:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  1034f8:	00 
  1034f9:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  103500:	00 
  103501:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103508:	e8 dd d7 ff ff       	call   100cea <__panic>
    free_pages(C, 128);
  10350d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  103514:	00 
  103515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103518:	89 04 24             	mov    %eax,(%esp)
  10351b:	e8 3d 16 00 00       	call   104b5d <free_pages>
    C = alloc_pages(64);
  103520:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  103527:	e8 f7 15 00 00       	call   104b23 <alloc_pages>
  10352c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C是否在B、D之间
    assert(C == D + 64 && C == B - 64);
  10352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103532:	05 00 05 00 00       	add    $0x500,%eax
  103537:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10353a:	75 0d                	jne    103549 <buddy_check+0x36a>
  10353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10353f:	2d 00 05 00 00       	sub    $0x500,%eax
  103544:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103547:	74 24                	je     10356d <buddy_check+0x38e>
  103549:	c7 44 24 0c 07 76 10 	movl   $0x107607,0xc(%esp)
  103550:	00 
  103551:	c7 44 24 08 71 74 10 	movl   $0x107471,0x8(%esp)
  103558:	00 
  103559:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103560:	00 
  103561:	c7 04 24 86 74 10 00 	movl   $0x107486,(%esp)
  103568:	e8 7d d7 ff ff       	call   100cea <__panic>
    free_pages(B, 64);
  10356d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  103574:	00 
  103575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103578:	89 04 24             	mov    %eax,(%esp)
  10357b:	e8 dd 15 00 00       	call   104b5d <free_pages>
    free_pages(D, 64);
  103580:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  103587:	00 
  103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10358b:	89 04 24             	mov    %eax,(%esp)
  10358e:	e8 ca 15 00 00       	call   104b5d <free_pages>
    free_pages(C, 64);
  103593:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  10359a:	00 
  10359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359e:	89 04 24             	mov    %eax,(%esp)
  1035a1:	e8 b7 15 00 00       	call   104b5d <free_pages>
    // 全部释放
    free_pages(p0, 8192);
  1035a6:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
  1035ad:	00 
  1035ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035b1:	89 04 24             	mov    %eax,(%esp)
  1035b4:	e8 a4 15 00 00       	call   104b5d <free_pages>
}
  1035b9:	90                   	nop
  1035ba:	89 ec                	mov    %ebp,%esp
  1035bc:	5d                   	pop    %ebp
  1035bd:	c3                   	ret    

001035be <page2ppn>:
page2ppn(struct Page *page) {
  1035be:	55                   	push   %ebp
  1035bf:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1035c1:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  1035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ca:	29 d0                	sub    %edx,%eax
  1035cc:	c1 f8 02             	sar    $0x2,%eax
  1035cf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1035d5:	5d                   	pop    %ebp
  1035d6:	c3                   	ret    

001035d7 <page2pa>:
page2pa(struct Page *page) {
  1035d7:	55                   	push   %ebp
  1035d8:	89 e5                	mov    %esp,%ebp
  1035da:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e0:	89 04 24             	mov    %eax,(%esp)
  1035e3:	e8 d6 ff ff ff       	call   1035be <page2ppn>
  1035e8:	c1 e0 0c             	shl    $0xc,%eax
}
  1035eb:	89 ec                	mov    %ebp,%esp
  1035ed:	5d                   	pop    %ebp
  1035ee:	c3                   	ret    

001035ef <page_ref>:
page_ref(struct Page *page) {
  1035ef:	55                   	push   %ebp
  1035f0:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f5:	8b 00                	mov    (%eax),%eax
}
  1035f7:	5d                   	pop    %ebp
  1035f8:	c3                   	ret    

001035f9 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1035f9:	55                   	push   %ebp
  1035fa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  103602:	89 10                	mov    %edx,(%eax)
}
  103604:	90                   	nop
  103605:	5d                   	pop    %ebp
  103606:	c3                   	ret    

00103607 <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
  103607:	55                   	push   %ebp
  103608:	89 e5                	mov    %esp,%ebp
  10360a:	83 ec 10             	sub    $0x10,%esp
  10360d:	c7 45 fc 90 ee 11 00 	movl   $0x11ee90,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
  103614:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103617:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10361a:	89 50 04             	mov    %edx,0x4(%eax)
  10361d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103620:	8b 50 04             	mov    0x4(%eax),%edx
  103623:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103626:	89 10                	mov    %edx,(%eax)
}
  103628:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  103629:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  103630:	00 00 00 
}
  103633:	90                   	nop
  103634:	89 ec                	mov    %ebp,%esp
  103636:	5d                   	pop    %ebp
  103637:	c3                   	ret    

00103638 <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
  103638:	55                   	push   %ebp
  103639:	89 e5                	mov    %esp,%ebp
  10363b:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10363e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103642:	75 24                	jne    103668 <default_init_memmap+0x30>
  103644:	c7 44 24 0c 50 76 10 	movl   $0x107650,0xc(%esp)
  10364b:	00 
  10364c:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103653:	00 
  103654:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10365b:	00 
  10365c:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103663:	e8 82 d6 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  103668:	8b 45 08             	mov    0x8(%ebp),%eax
  10366b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  10366e:	eb 7b                	jmp    1036eb <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
  103670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103673:	83 c0 04             	add    $0x4,%eax
  103676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10367d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103683:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103686:	0f a3 10             	bt     %edx,(%eax)
  103689:	19 c0                	sbb    %eax,%eax
  10368b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10368e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103692:	0f 95 c0             	setne  %al
  103695:	0f b6 c0             	movzbl %al,%eax
  103698:	85 c0                	test   %eax,%eax
  10369a:	75 24                	jne    1036c0 <default_init_memmap+0x88>
  10369c:	c7 44 24 0c 81 76 10 	movl   $0x107681,0xc(%esp)
  1036a3:	00 
  1036a4:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1036ab:	00 
  1036ac:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  1036b3:	00 
  1036b4:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1036bb:	e8 2a d6 ff ff       	call   100cea <__panic>
        p->flags = 0;
  1036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
  1036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
  1036d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036db:	00 
  1036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036df:	89 04 24             	mov    %eax,(%esp)
  1036e2:	e8 12 ff ff ff       	call   1035f9 <set_page_ref>
    for (; p != base + n; p++)
  1036e7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1036eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036ee:	89 d0                	mov    %edx,%eax
  1036f0:	c1 e0 02             	shl    $0x2,%eax
  1036f3:	01 d0                	add    %edx,%eax
  1036f5:	c1 e0 02             	shl    $0x2,%eax
  1036f8:	89 c2                	mov    %eax,%edx
  1036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1036fd:	01 d0                	add    %edx,%eax
  1036ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103702:	0f 85 68 ff ff ff    	jne    103670 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
  103708:	8b 45 08             	mov    0x8(%ebp),%eax
  10370b:	83 c0 04             	add    $0x4,%eax
  10370e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103715:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  103718:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10371b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10371e:	0f ab 10             	bts    %edx,(%eax)
}
  103721:	90                   	nop
    base->property = n;
  103722:	8b 45 08             	mov    0x8(%ebp),%eax
  103725:	8b 55 0c             	mov    0xc(%ebp),%edx
  103728:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  10372b:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  103731:	8b 45 0c             	mov    0xc(%ebp),%eax
  103734:	01 d0                	add    %edx,%eax
  103736:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
  10373b:	8b 45 08             	mov    0x8(%ebp),%eax
  10373e:	83 c0 0c             	add    $0xc,%eax
  103741:	c7 45 e4 90 ee 11 00 	movl   $0x11ee90,-0x1c(%ebp)
  103748:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
  10374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10374e:	8b 00                	mov    (%eax),%eax
  103750:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10375c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
  10375f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103765:	89 10                	mov    %edx,(%eax)
  103767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10376a:	8b 10                	mov    (%eax),%edx
  10376c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10376f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103772:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103778:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10377b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10377e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103781:	89 10                	mov    %edx,(%eax)
}
  103783:	90                   	nop
}
  103784:	90                   	nop
}
  103785:	90                   	nop
  103786:	89 ec                	mov    %ebp,%esp
  103788:	5d                   	pop    %ebp
  103789:	c3                   	ret    

0010378a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  10378a:	55                   	push   %ebp
  10378b:	89 e5                	mov    %esp,%ebp
  10378d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  103790:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103794:	75 24                	jne    1037ba <default_alloc_pages+0x30>
  103796:	c7 44 24 0c 50 76 10 	movl   $0x107650,0xc(%esp)
  10379d:	00 
  10379e:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1037a5:	00 
  1037a6:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  1037ad:	00 
  1037ae:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1037b5:	e8 30 d5 ff ff       	call   100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
  1037ba:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1037bf:	39 45 08             	cmp    %eax,0x8(%ebp)
  1037c2:	76 0a                	jbe    1037ce <default_alloc_pages+0x44>
    {
        return NULL;
  1037c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1037c9:	e9 43 01 00 00       	jmp    103911 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  1037ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1037d5:	c7 45 f0 90 ee 11 00 	movl   $0x11ee90,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  1037dc:	eb 1c                	jmp    1037fa <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
  1037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037e1:	83 e8 0c             	sub    $0xc,%eax
  1037e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  1037e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037ea:	8b 40 08             	mov    0x8(%eax),%eax
  1037ed:	39 45 08             	cmp    %eax,0x8(%ebp)
  1037f0:	77 08                	ja     1037fa <default_alloc_pages+0x70>
        {
            page = p;
  1037f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1037f8:	eb 18                	jmp    103812 <default_alloc_pages+0x88>
  1037fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  103800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103803:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103809:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103810:	75 cc                	jne    1037de <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
  103812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103816:	0f 84 f2 00 00 00    	je     10390e <default_alloc_pages+0x184>
    {
        if (page->property > n)
  10381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10381f:	8b 40 08             	mov    0x8(%eax),%eax
  103822:	39 45 08             	cmp    %eax,0x8(%ebp)
  103825:	0f 83 8f 00 00 00    	jae    1038ba <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
  10382b:	8b 55 08             	mov    0x8(%ebp),%edx
  10382e:	89 d0                	mov    %edx,%eax
  103830:	c1 e0 02             	shl    $0x2,%eax
  103833:	01 d0                	add    %edx,%eax
  103835:	c1 e0 02             	shl    $0x2,%eax
  103838:	89 c2                	mov    %eax,%edx
  10383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10383d:	01 d0                	add    %edx,%eax
  10383f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  103842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103845:	8b 40 08             	mov    0x8(%eax),%eax
  103848:	2b 45 08             	sub    0x8(%ebp),%eax
  10384b:	89 c2                	mov    %eax,%edx
  10384d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103850:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  103853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103856:	83 c0 0c             	add    $0xc,%eax
  103859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10385c:	83 c2 0c             	add    $0xc,%edx
  10385f:	89 55 d8             	mov    %edx,-0x28(%ebp)
  103862:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  103865:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103868:	8b 40 04             	mov    0x4(%eax),%eax
  10386b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10386e:	89 55 d0             	mov    %edx,-0x30(%ebp)
  103871:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103874:	89 55 cc             	mov    %edx,-0x34(%ebp)
  103877:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  10387a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10387d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103880:	89 10                	mov    %edx,(%eax)
  103882:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103885:	8b 10                	mov    (%eax),%edx
  103887:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10388a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10388d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103890:	8b 55 c8             	mov    -0x38(%ebp),%edx
  103893:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103896:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103899:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10389c:	89 10                	mov    %edx,(%eax)
}
  10389e:	90                   	nop
}
  10389f:	90                   	nop
            SetPageProperty(p);
  1038a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038a3:	83 c0 04             	add    $0x4,%eax
  1038a6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1038ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
  1038b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1038b6:	0f ab 10             	bts    %edx,(%eax)
}
  1038b9:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
  1038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038bd:	83 c0 0c             	add    $0xc,%eax
  1038c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1038c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1038c6:	8b 40 04             	mov    0x4(%eax),%eax
  1038c9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1038cc:	8b 12                	mov    (%edx),%edx
  1038ce:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1038d1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
  1038d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1038d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1038da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1038dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1038e0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1038e3:	89 10                	mov    %edx,(%eax)
}
  1038e5:	90                   	nop
}
  1038e6:	90                   	nop
        nr_free -= n;
  1038e7:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1038ec:	2b 45 08             	sub    0x8(%ebp),%eax
  1038ef:	a3 98 ee 11 00       	mov    %eax,0x11ee98
        ClearPageProperty(page);
  1038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038f7:	83 c0 04             	add    $0x4,%eax
  1038fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  103901:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
  103904:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103907:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10390a:	0f b3 10             	btr    %edx,(%eax)
}
  10390d:	90                   	nop
    }
    return page;
  10390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103911:	89 ec                	mov    %ebp,%esp
  103913:	5d                   	pop    %ebp
  103914:	c3                   	ret    

00103915 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  103915:	55                   	push   %ebp
  103916:	89 e5                	mov    %esp,%ebp
  103918:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  10391e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103922:	75 24                	jne    103948 <default_free_pages+0x33>
  103924:	c7 44 24 0c 50 76 10 	movl   $0x107650,0xc(%esp)
  10392b:	00 
  10392c:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103933:	00 
  103934:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  10393b:	00 
  10393c:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103943:	e8 a2 d3 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  103948:	8b 45 08             	mov    0x8(%ebp),%eax
  10394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  10394e:	e9 9d 00 00 00       	jmp    1039f0 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  103953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103956:	83 c0 04             	add    $0x4,%eax
  103959:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  103960:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103966:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103969:	0f a3 10             	bt     %edx,(%eax)
  10396c:	19 c0                	sbb    %eax,%eax
  10396e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  103971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103975:	0f 95 c0             	setne  %al
  103978:	0f b6 c0             	movzbl %al,%eax
  10397b:	85 c0                	test   %eax,%eax
  10397d:	75 2c                	jne    1039ab <default_free_pages+0x96>
  10397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103982:	83 c0 04             	add    $0x4,%eax
  103985:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10398c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  10398f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103992:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103995:	0f a3 10             	bt     %edx,(%eax)
  103998:	19 c0                	sbb    %eax,%eax
  10399a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10399d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1039a1:	0f 95 c0             	setne  %al
  1039a4:	0f b6 c0             	movzbl %al,%eax
  1039a7:	85 c0                	test   %eax,%eax
  1039a9:	74 24                	je     1039cf <default_free_pages+0xba>
  1039ab:	c7 44 24 0c 94 76 10 	movl   $0x107694,0xc(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1039ba:	00 
  1039bb:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  1039c2:	00 
  1039c3:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1039ca:	e8 1b d3 ff ff       	call   100cea <__panic>
        p->flags = 0;
  1039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1039d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1039e0:	00 
  1039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039e4:	89 04 24             	mov    %eax,(%esp)
  1039e7:	e8 0d fc ff ff       	call   1035f9 <set_page_ref>
    for (; p != base + n; p++)
  1039ec:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1039f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1039f3:	89 d0                	mov    %edx,%eax
  1039f5:	c1 e0 02             	shl    $0x2,%eax
  1039f8:	01 d0                	add    %edx,%eax
  1039fa:	c1 e0 02             	shl    $0x2,%eax
  1039fd:	89 c2                	mov    %eax,%edx
  1039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103a02:	01 d0                	add    %edx,%eax
  103a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a07:	0f 85 46 ff ff ff    	jne    103953 <default_free_pages+0x3e>
    }
    base->property = n;
  103a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a13:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  103a16:	8b 45 08             	mov    0x8(%ebp),%eax
  103a19:	83 c0 04             	add    $0x4,%eax
  103a1c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103a23:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  103a26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103a2c:	0f ab 10             	bts    %edx,(%eax)
}
  103a2f:	90                   	nop
  103a30:	c7 45 d4 90 ee 11 00 	movl   $0x11ee90,-0x2c(%ebp)
    return listelm->next;
  103a37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103a3a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  103a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
  103a40:	e9 0e 01 00 00       	jmp    103b53 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
  103a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a48:	83 e8 0c             	sub    $0xc,%eax
  103a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a51:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103a54:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103a57:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  103a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
  103a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a60:	8b 50 08             	mov    0x8(%eax),%edx
  103a63:	89 d0                	mov    %edx,%eax
  103a65:	c1 e0 02             	shl    $0x2,%eax
  103a68:	01 d0                	add    %edx,%eax
  103a6a:	c1 e0 02             	shl    $0x2,%eax
  103a6d:	89 c2                	mov    %eax,%edx
  103a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  103a72:	01 d0                	add    %edx,%eax
  103a74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a77:	75 5d                	jne    103ad6 <default_free_pages+0x1c1>
        {
            base->property += p->property;
  103a79:	8b 45 08             	mov    0x8(%ebp),%eax
  103a7c:	8b 50 08             	mov    0x8(%eax),%edx
  103a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a82:	8b 40 08             	mov    0x8(%eax),%eax
  103a85:	01 c2                	add    %eax,%edx
  103a87:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  103a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a90:	83 c0 04             	add    $0x4,%eax
  103a93:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  103a9a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
  103a9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103aa0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103aa3:	0f b3 10             	btr    %edx,(%eax)
}
  103aa6:	90                   	nop
            list_del(&(p->page_link));
  103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aaa:	83 c0 0c             	add    $0xc,%eax
  103aad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  103ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ab3:	8b 40 04             	mov    0x4(%eax),%eax
  103ab6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103ab9:	8b 12                	mov    (%edx),%edx
  103abb:	89 55 c0             	mov    %edx,-0x40(%ebp)
  103abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  103ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103ac4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ac7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103aca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103acd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103ad0:	89 10                	mov    %edx,(%eax)
}
  103ad2:	90                   	nop
}
  103ad3:	90                   	nop
  103ad4:	eb 7d                	jmp    103b53 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
  103ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ad9:	8b 50 08             	mov    0x8(%eax),%edx
  103adc:	89 d0                	mov    %edx,%eax
  103ade:	c1 e0 02             	shl    $0x2,%eax
  103ae1:	01 d0                	add    %edx,%eax
  103ae3:	c1 e0 02             	shl    $0x2,%eax
  103ae6:	89 c2                	mov    %eax,%edx
  103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aeb:	01 d0                	add    %edx,%eax
  103aed:	39 45 08             	cmp    %eax,0x8(%ebp)
  103af0:	75 61                	jne    103b53 <default_free_pages+0x23e>
        {
            p->property += base->property;
  103af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103af5:	8b 50 08             	mov    0x8(%eax),%edx
  103af8:	8b 45 08             	mov    0x8(%ebp),%eax
  103afb:	8b 40 08             	mov    0x8(%eax),%eax
  103afe:	01 c2                	add    %eax,%edx
  103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b03:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  103b06:	8b 45 08             	mov    0x8(%ebp),%eax
  103b09:	83 c0 04             	add    $0x4,%eax
  103b0c:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  103b13:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
  103b16:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103b19:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103b1c:	0f b3 10             	btr    %edx,(%eax)
}
  103b1f:	90                   	nop
            base = p;
  103b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b23:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  103b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b29:	83 c0 0c             	add    $0xc,%eax
  103b2c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  103b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103b32:	8b 40 04             	mov    0x4(%eax),%eax
  103b35:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103b38:	8b 12                	mov    (%edx),%edx
  103b3a:	89 55 ac             	mov    %edx,-0x54(%ebp)
  103b3d:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  103b40:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103b43:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103b46:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103b49:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103b4c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103b4f:	89 10                	mov    %edx,(%eax)
}
  103b51:	90                   	nop
}
  103b52:	90                   	nop
    while (le != &free_list)
  103b53:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103b5a:	0f 85 e5 fe ff ff    	jne    103a45 <default_free_pages+0x130>
        }
    }
    le = &free_list;
  103b60:	c7 45 f0 90 ee 11 00 	movl   $0x11ee90,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
  103b67:	eb 25                	jmp    103b8e <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
  103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b6c:	83 e8 0c             	sub    $0xc,%eax
  103b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
  103b72:	8b 45 08             	mov    0x8(%ebp),%eax
  103b75:	8b 50 08             	mov    0x8(%eax),%edx
  103b78:	89 d0                	mov    %edx,%eax
  103b7a:	c1 e0 02             	shl    $0x2,%eax
  103b7d:	01 d0                	add    %edx,%eax
  103b7f:	c1 e0 02             	shl    $0x2,%eax
  103b82:	89 c2                	mov    %eax,%edx
  103b84:	8b 45 08             	mov    0x8(%ebp),%eax
  103b87:	01 d0                	add    %edx,%eax
  103b89:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103b8c:	73 1a                	jae    103ba8 <default_free_pages+0x293>
  103b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b91:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  103b94:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103b97:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b9d:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103ba4:	75 c3                	jne    103b69 <default_free_pages+0x254>
  103ba6:	eb 01                	jmp    103ba9 <default_free_pages+0x294>
        {
            break;
  103ba8:	90                   	nop
        }
    }
    nr_free += n;
  103ba9:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  103baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  103bb2:	01 d0                	add    %edx,%eax
  103bb4:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    list_add_before(le, &(base->page_link));
  103bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  103bbc:	8d 50 0c             	lea    0xc(%eax),%edx
  103bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bc2:	89 45 98             	mov    %eax,-0x68(%ebp)
  103bc5:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  103bc8:	8b 45 98             	mov    -0x68(%ebp),%eax
  103bcb:	8b 00                	mov    (%eax),%eax
  103bcd:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103bd0:	89 55 90             	mov    %edx,-0x70(%ebp)
  103bd3:	89 45 8c             	mov    %eax,-0x74(%ebp)
  103bd6:	8b 45 98             	mov    -0x68(%ebp),%eax
  103bd9:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
  103bdc:	8b 45 88             	mov    -0x78(%ebp),%eax
  103bdf:	8b 55 90             	mov    -0x70(%ebp),%edx
  103be2:	89 10                	mov    %edx,(%eax)
  103be4:	8b 45 88             	mov    -0x78(%ebp),%eax
  103be7:	8b 10                	mov    (%eax),%edx
  103be9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103bec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103bef:	8b 45 90             	mov    -0x70(%ebp),%eax
  103bf2:	8b 55 88             	mov    -0x78(%ebp),%edx
  103bf5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103bf8:	8b 45 90             	mov    -0x70(%ebp),%eax
  103bfb:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103bfe:	89 10                	mov    %edx,(%eax)
}
  103c00:	90                   	nop
}
  103c01:	90                   	nop
}
  103c02:	90                   	nop
  103c03:	89 ec                	mov    %ebp,%esp
  103c05:	5d                   	pop    %ebp
  103c06:	c3                   	ret    

00103c07 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  103c07:	55                   	push   %ebp
  103c08:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103c0a:	a1 98 ee 11 00       	mov    0x11ee98,%eax
}
  103c0f:	5d                   	pop    %ebp
  103c10:	c3                   	ret    

00103c11 <basic_check>:

static void
basic_check(void)
{
  103c11:	55                   	push   %ebp
  103c12:	89 e5                	mov    %esp,%ebp
  103c14:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103c2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c31:	e8 ed 0e 00 00       	call   104b23 <alloc_pages>
  103c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103c3d:	75 24                	jne    103c63 <basic_check+0x52>
  103c3f:	c7 44 24 0c b9 76 10 	movl   $0x1076b9,0xc(%esp)
  103c46:	00 
  103c47:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103c4e:	00 
  103c4f:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103c56:	00 
  103c57:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103c5e:	e8 87 d0 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  103c63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c6a:	e8 b4 0e 00 00       	call   104b23 <alloc_pages>
  103c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c76:	75 24                	jne    103c9c <basic_check+0x8b>
  103c78:	c7 44 24 0c d5 76 10 	movl   $0x1076d5,0xc(%esp)
  103c7f:	00 
  103c80:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103c87:	00 
  103c88:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103c8f:	00 
  103c90:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103c97:	e8 4e d0 ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  103c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ca3:	e8 7b 0e 00 00       	call   104b23 <alloc_pages>
  103ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103caf:	75 24                	jne    103cd5 <basic_check+0xc4>
  103cb1:	c7 44 24 0c f1 76 10 	movl   $0x1076f1,0xc(%esp)
  103cb8:	00 
  103cb9:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103cc0:	00 
  103cc1:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103cc8:	00 
  103cc9:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103cd0:	e8 15 d0 ff ff       	call   100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103cdb:	74 10                	je     103ced <basic_check+0xdc>
  103cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ce0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103ce3:	74 08                	je     103ced <basic_check+0xdc>
  103ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ce8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103ceb:	75 24                	jne    103d11 <basic_check+0x100>
  103ced:	c7 44 24 0c 10 77 10 	movl   $0x107710,0xc(%esp)
  103cf4:	00 
  103cf5:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103cfc:	00 
  103cfd:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103d04:	00 
  103d05:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103d0c:	e8 d9 cf ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d14:	89 04 24             	mov    %eax,(%esp)
  103d17:	e8 d3 f8 ff ff       	call   1035ef <page_ref>
  103d1c:	85 c0                	test   %eax,%eax
  103d1e:	75 1e                	jne    103d3e <basic_check+0x12d>
  103d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d23:	89 04 24             	mov    %eax,(%esp)
  103d26:	e8 c4 f8 ff ff       	call   1035ef <page_ref>
  103d2b:	85 c0                	test   %eax,%eax
  103d2d:	75 0f                	jne    103d3e <basic_check+0x12d>
  103d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d32:	89 04 24             	mov    %eax,(%esp)
  103d35:	e8 b5 f8 ff ff       	call   1035ef <page_ref>
  103d3a:	85 c0                	test   %eax,%eax
  103d3c:	74 24                	je     103d62 <basic_check+0x151>
  103d3e:	c7 44 24 0c 34 77 10 	movl   $0x107734,0xc(%esp)
  103d45:	00 
  103d46:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103d4d:	00 
  103d4e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103d55:	00 
  103d56:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103d5d:	e8 88 cf ff ff       	call   100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d65:	89 04 24             	mov    %eax,(%esp)
  103d68:	e8 6a f8 ff ff       	call   1035d7 <page2pa>
  103d6d:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103d73:	c1 e2 0c             	shl    $0xc,%edx
  103d76:	39 d0                	cmp    %edx,%eax
  103d78:	72 24                	jb     103d9e <basic_check+0x18d>
  103d7a:	c7 44 24 0c 70 77 10 	movl   $0x107770,0xc(%esp)
  103d81:	00 
  103d82:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103d89:	00 
  103d8a:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103d91:	00 
  103d92:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103d99:	e8 4c cf ff ff       	call   100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103da1:	89 04 24             	mov    %eax,(%esp)
  103da4:	e8 2e f8 ff ff       	call   1035d7 <page2pa>
  103da9:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103daf:	c1 e2 0c             	shl    $0xc,%edx
  103db2:	39 d0                	cmp    %edx,%eax
  103db4:	72 24                	jb     103dda <basic_check+0x1c9>
  103db6:	c7 44 24 0c 8d 77 10 	movl   $0x10778d,0xc(%esp)
  103dbd:	00 
  103dbe:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103dc5:	00 
  103dc6:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103dcd:	00 
  103dce:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103dd5:	e8 10 cf ff ff       	call   100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ddd:	89 04 24             	mov    %eax,(%esp)
  103de0:	e8 f2 f7 ff ff       	call   1035d7 <page2pa>
  103de5:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103deb:	c1 e2 0c             	shl    $0xc,%edx
  103dee:	39 d0                	cmp    %edx,%eax
  103df0:	72 24                	jb     103e16 <basic_check+0x205>
  103df2:	c7 44 24 0c aa 77 10 	movl   $0x1077aa,0xc(%esp)
  103df9:	00 
  103dfa:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103e01:	00 
  103e02:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103e09:	00 
  103e0a:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103e11:	e8 d4 ce ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  103e16:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  103e1b:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  103e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103e27:	c7 45 dc 90 ee 11 00 	movl   $0x11ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e34:	89 50 04             	mov    %edx,0x4(%eax)
  103e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e3a:	8b 50 04             	mov    0x4(%eax),%edx
  103e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e40:	89 10                	mov    %edx,(%eax)
}
  103e42:	90                   	nop
  103e43:	c7 45 e0 90 ee 11 00 	movl   $0x11ee90,-0x20(%ebp)
    return list->next == list;
  103e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e4d:	8b 40 04             	mov    0x4(%eax),%eax
  103e50:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103e53:	0f 94 c0             	sete   %al
  103e56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103e59:	85 c0                	test   %eax,%eax
  103e5b:	75 24                	jne    103e81 <basic_check+0x270>
  103e5d:	c7 44 24 0c c7 77 10 	movl   $0x1077c7,0xc(%esp)
  103e64:	00 
  103e65:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103e6c:	00 
  103e6d:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103e74:	00 
  103e75:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103e7c:	e8 69 ce ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  103e81:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103e86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103e89:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  103e90:	00 00 00 

    assert(alloc_page() == NULL);
  103e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103e9a:	e8 84 0c 00 00       	call   104b23 <alloc_pages>
  103e9f:	85 c0                	test   %eax,%eax
  103ea1:	74 24                	je     103ec7 <basic_check+0x2b6>
  103ea3:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  103eaa:	00 
  103eab:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103eb2:	00 
  103eb3:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103eba:	00 
  103ebb:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103ec2:	e8 23 ce ff ff       	call   100cea <__panic>

    free_page(p0);
  103ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103ece:	00 
  103ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ed2:	89 04 24             	mov    %eax,(%esp)
  103ed5:	e8 83 0c 00 00       	call   104b5d <free_pages>
    free_page(p1);
  103eda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103ee1:	00 
  103ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ee5:	89 04 24             	mov    %eax,(%esp)
  103ee8:	e8 70 0c 00 00       	call   104b5d <free_pages>
    free_page(p2);
  103eed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103ef4:	00 
  103ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ef8:	89 04 24             	mov    %eax,(%esp)
  103efb:	e8 5d 0c 00 00       	call   104b5d <free_pages>
    assert(nr_free == 3);
  103f00:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103f05:	83 f8 03             	cmp    $0x3,%eax
  103f08:	74 24                	je     103f2e <basic_check+0x31d>
  103f0a:	c7 44 24 0c f3 77 10 	movl   $0x1077f3,0xc(%esp)
  103f11:	00 
  103f12:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103f19:	00 
  103f1a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103f21:	00 
  103f22:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103f29:	e8 bc cd ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
  103f2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f35:	e8 e9 0b 00 00       	call   104b23 <alloc_pages>
  103f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103f3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103f41:	75 24                	jne    103f67 <basic_check+0x356>
  103f43:	c7 44 24 0c b9 76 10 	movl   $0x1076b9,0xc(%esp)
  103f4a:	00 
  103f4b:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103f52:	00 
  103f53:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103f5a:	00 
  103f5b:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103f62:	e8 83 cd ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  103f67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f6e:	e8 b0 0b 00 00       	call   104b23 <alloc_pages>
  103f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103f7a:	75 24                	jne    103fa0 <basic_check+0x38f>
  103f7c:	c7 44 24 0c d5 76 10 	movl   $0x1076d5,0xc(%esp)
  103f83:	00 
  103f84:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103f93:	00 
  103f94:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103f9b:	e8 4a cd ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  103fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fa7:	e8 77 0b 00 00       	call   104b23 <alloc_pages>
  103fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103fb3:	75 24                	jne    103fd9 <basic_check+0x3c8>
  103fb5:	c7 44 24 0c f1 76 10 	movl   $0x1076f1,0xc(%esp)
  103fbc:	00 
  103fbd:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103fc4:	00 
  103fc5:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103fcc:	00 
  103fcd:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  103fd4:	e8 11 cd ff ff       	call   100cea <__panic>

    assert(alloc_page() == NULL);
  103fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fe0:	e8 3e 0b 00 00       	call   104b23 <alloc_pages>
  103fe5:	85 c0                	test   %eax,%eax
  103fe7:	74 24                	je     10400d <basic_check+0x3fc>
  103fe9:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  103ff0:	00 
  103ff1:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  103ff8:	00 
  103ff9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104000:	00 
  104001:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104008:	e8 dd cc ff ff       	call   100cea <__panic>

    free_page(p0);
  10400d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104014:	00 
  104015:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104018:	89 04 24             	mov    %eax,(%esp)
  10401b:	e8 3d 0b 00 00       	call   104b5d <free_pages>
  104020:	c7 45 d8 90 ee 11 00 	movl   $0x11ee90,-0x28(%ebp)
  104027:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10402a:	8b 40 04             	mov    0x4(%eax),%eax
  10402d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104030:	0f 94 c0             	sete   %al
  104033:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104036:	85 c0                	test   %eax,%eax
  104038:	74 24                	je     10405e <basic_check+0x44d>
  10403a:	c7 44 24 0c 00 78 10 	movl   $0x107800,0xc(%esp)
  104041:	00 
  104042:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104049:	00 
  10404a:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104051:	00 
  104052:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104059:	e8 8c cc ff ff       	call   100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10405e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104065:	e8 b9 0a 00 00       	call   104b23 <alloc_pages>
  10406a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104070:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104073:	74 24                	je     104099 <basic_check+0x488>
  104075:	c7 44 24 0c 18 78 10 	movl   $0x107818,0xc(%esp)
  10407c:	00 
  10407d:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104084:	00 
  104085:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  10408c:	00 
  10408d:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104094:	e8 51 cc ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  104099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1040a0:	e8 7e 0a 00 00       	call   104b23 <alloc_pages>
  1040a5:	85 c0                	test   %eax,%eax
  1040a7:	74 24                	je     1040cd <basic_check+0x4bc>
  1040a9:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  1040b0:	00 
  1040b1:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1040b8:	00 
  1040b9:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1040c0:	00 
  1040c1:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1040c8:	e8 1d cc ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  1040cd:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1040d2:	85 c0                	test   %eax,%eax
  1040d4:	74 24                	je     1040fa <basic_check+0x4e9>
  1040d6:	c7 44 24 0c 31 78 10 	movl   $0x107831,0xc(%esp)
  1040dd:	00 
  1040de:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1040e5:	00 
  1040e6:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  1040ed:	00 
  1040ee:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1040f5:	e8 f0 cb ff ff       	call   100cea <__panic>
    free_list = free_list_store;
  1040fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104100:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  104105:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    nr_free = nr_free_store;
  10410b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10410e:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_page(p);
  104113:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10411a:	00 
  10411b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10411e:	89 04 24             	mov    %eax,(%esp)
  104121:	e8 37 0a 00 00       	call   104b5d <free_pages>
    free_page(p1);
  104126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10412d:	00 
  10412e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104131:	89 04 24             	mov    %eax,(%esp)
  104134:	e8 24 0a 00 00       	call   104b5d <free_pages>
    free_page(p2);
  104139:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104140:	00 
  104141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104144:	89 04 24             	mov    %eax,(%esp)
  104147:	e8 11 0a 00 00       	call   104b5d <free_pages>
}
  10414c:	90                   	nop
  10414d:	89 ec                	mov    %ebp,%esp
  10414f:	5d                   	pop    %ebp
  104150:	c3                   	ret    

00104151 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  104151:	55                   	push   %ebp
  104152:	89 e5                	mov    %esp,%ebp
  104154:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  10415a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104161:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104168:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  10416f:	eb 6a                	jmp    1041db <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
  104171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104174:	83 e8 0c             	sub    $0xc,%eax
  104177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  10417a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10417d:	83 c0 04             	add    $0x4,%eax
  104180:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104187:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  10418a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10418d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104190:	0f a3 10             	bt     %edx,(%eax)
  104193:	19 c0                	sbb    %eax,%eax
  104195:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104198:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10419c:	0f 95 c0             	setne  %al
  10419f:	0f b6 c0             	movzbl %al,%eax
  1041a2:	85 c0                	test   %eax,%eax
  1041a4:	75 24                	jne    1041ca <default_check+0x79>
  1041a6:	c7 44 24 0c 3e 78 10 	movl   $0x10783e,0xc(%esp)
  1041ad:	00 
  1041ae:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1041b5:	00 
  1041b6:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1041bd:	00 
  1041be:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1041c5:	e8 20 cb ff ff       	call   100cea <__panic>
        count++, total += p->property;
  1041ca:	ff 45 f4             	incl   -0xc(%ebp)
  1041cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041d0:	8b 50 08             	mov    0x8(%eax),%edx
  1041d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d6:	01 d0                	add    %edx,%eax
  1041d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1041db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1041e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041e4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  1041e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041ea:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  1041f1:	0f 85 7a ff ff ff    	jne    104171 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  1041f7:	e8 96 09 00 00       	call   104b92 <nr_free_pages>
  1041fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1041ff:	39 d0                	cmp    %edx,%eax
  104201:	74 24                	je     104227 <default_check+0xd6>
  104203:	c7 44 24 0c 4e 78 10 	movl   $0x10784e,0xc(%esp)
  10420a:	00 
  10420b:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104212:	00 
  104213:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  10421a:	00 
  10421b:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104222:	e8 c3 ca ff ff       	call   100cea <__panic>

    basic_check();
  104227:	e8 e5 f9 ff ff       	call   103c11 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10422c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104233:	e8 eb 08 00 00       	call   104b23 <alloc_pages>
  104238:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10423b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10423f:	75 24                	jne    104265 <default_check+0x114>
  104241:	c7 44 24 0c 67 78 10 	movl   $0x107867,0xc(%esp)
  104248:	00 
  104249:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104250:	00 
  104251:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  104258:	00 
  104259:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104260:	e8 85 ca ff ff       	call   100cea <__panic>
    assert(!PageProperty(p0));
  104265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104268:	83 c0 04             	add    $0x4,%eax
  10426b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104272:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  104275:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104278:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10427b:	0f a3 10             	bt     %edx,(%eax)
  10427e:	19 c0                	sbb    %eax,%eax
  104280:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104283:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104287:	0f 95 c0             	setne  %al
  10428a:	0f b6 c0             	movzbl %al,%eax
  10428d:	85 c0                	test   %eax,%eax
  10428f:	74 24                	je     1042b5 <default_check+0x164>
  104291:	c7 44 24 0c 72 78 10 	movl   $0x107872,0xc(%esp)
  104298:	00 
  104299:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1042a0:	00 
  1042a1:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1042a8:	00 
  1042a9:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1042b0:	e8 35 ca ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  1042b5:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  1042ba:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  1042c0:	89 45 80             	mov    %eax,-0x80(%ebp)
  1042c3:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1042c6:	c7 45 b0 90 ee 11 00 	movl   $0x11ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1042cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1042d0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1042d3:	89 50 04             	mov    %edx,0x4(%eax)
  1042d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1042d9:	8b 50 04             	mov    0x4(%eax),%edx
  1042dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1042df:	89 10                	mov    %edx,(%eax)
}
  1042e1:	90                   	nop
  1042e2:	c7 45 b4 90 ee 11 00 	movl   $0x11ee90,-0x4c(%ebp)
    return list->next == list;
  1042e9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042ec:	8b 40 04             	mov    0x4(%eax),%eax
  1042ef:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1042f2:	0f 94 c0             	sete   %al
  1042f5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1042f8:	85 c0                	test   %eax,%eax
  1042fa:	75 24                	jne    104320 <default_check+0x1cf>
  1042fc:	c7 44 24 0c c7 77 10 	movl   $0x1077c7,0xc(%esp)
  104303:	00 
  104304:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10430b:	00 
  10430c:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  104313:	00 
  104314:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10431b:	e8 ca c9 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  104320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104327:	e8 f7 07 00 00       	call   104b23 <alloc_pages>
  10432c:	85 c0                	test   %eax,%eax
  10432e:	74 24                	je     104354 <default_check+0x203>
  104330:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  104337:	00 
  104338:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10433f:	00 
  104340:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  104347:	00 
  104348:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10434f:	e8 96 c9 ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  104354:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  104359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10435c:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  104363:	00 00 00 

    free_pages(p0 + 2, 3);
  104366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104369:	83 c0 28             	add    $0x28,%eax
  10436c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104373:	00 
  104374:	89 04 24             	mov    %eax,(%esp)
  104377:	e8 e1 07 00 00       	call   104b5d <free_pages>
    assert(alloc_pages(4) == NULL);
  10437c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104383:	e8 9b 07 00 00       	call   104b23 <alloc_pages>
  104388:	85 c0                	test   %eax,%eax
  10438a:	74 24                	je     1043b0 <default_check+0x25f>
  10438c:	c7 44 24 0c 84 78 10 	movl   $0x107884,0xc(%esp)
  104393:	00 
  104394:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10439b:	00 
  10439c:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1043a3:	00 
  1043a4:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1043ab:	e8 3a c9 ff ff       	call   100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1043b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043b3:	83 c0 28             	add    $0x28,%eax
  1043b6:	83 c0 04             	add    $0x4,%eax
  1043b9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1043c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1043c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1043c6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1043c9:	0f a3 10             	bt     %edx,(%eax)
  1043cc:	19 c0                	sbb    %eax,%eax
  1043ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1043d1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1043d5:	0f 95 c0             	setne  %al
  1043d8:	0f b6 c0             	movzbl %al,%eax
  1043db:	85 c0                	test   %eax,%eax
  1043dd:	74 0e                	je     1043ed <default_check+0x29c>
  1043df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043e2:	83 c0 28             	add    $0x28,%eax
  1043e5:	8b 40 08             	mov    0x8(%eax),%eax
  1043e8:	83 f8 03             	cmp    $0x3,%eax
  1043eb:	74 24                	je     104411 <default_check+0x2c0>
  1043ed:	c7 44 24 0c 9c 78 10 	movl   $0x10789c,0xc(%esp)
  1043f4:	00 
  1043f5:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1043fc:	00 
  1043fd:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104404:	00 
  104405:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10440c:	e8 d9 c8 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104411:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  104418:	e8 06 07 00 00       	call   104b23 <alloc_pages>
  10441d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104424:	75 24                	jne    10444a <default_check+0x2f9>
  104426:	c7 44 24 0c c8 78 10 	movl   $0x1078c8,0xc(%esp)
  10442d:	00 
  10442e:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104435:	00 
  104436:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  10443d:	00 
  10443e:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104445:	e8 a0 c8 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  10444a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104451:	e8 cd 06 00 00       	call   104b23 <alloc_pages>
  104456:	85 c0                	test   %eax,%eax
  104458:	74 24                	je     10447e <default_check+0x32d>
  10445a:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  104461:	00 
  104462:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104469:	00 
  10446a:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  104471:	00 
  104472:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104479:	e8 6c c8 ff ff       	call   100cea <__panic>
    assert(p0 + 2 == p1);
  10447e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104481:	83 c0 28             	add    $0x28,%eax
  104484:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104487:	74 24                	je     1044ad <default_check+0x35c>
  104489:	c7 44 24 0c e6 78 10 	movl   $0x1078e6,0xc(%esp)
  104490:	00 
  104491:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104498:	00 
  104499:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1044a0:	00 
  1044a1:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1044a8:	e8 3d c8 ff ff       	call   100cea <__panic>

    p2 = p0 + 1;
  1044ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044b0:	83 c0 14             	add    $0x14,%eax
  1044b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1044b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044bd:	00 
  1044be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044c1:	89 04 24             	mov    %eax,(%esp)
  1044c4:	e8 94 06 00 00       	call   104b5d <free_pages>
    free_pages(p1, 3);
  1044c9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1044d0:	00 
  1044d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044d4:	89 04 24             	mov    %eax,(%esp)
  1044d7:	e8 81 06 00 00       	call   104b5d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1044dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044df:	83 c0 04             	add    $0x4,%eax
  1044e2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1044e9:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1044ec:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1044ef:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1044f2:	0f a3 10             	bt     %edx,(%eax)
  1044f5:	19 c0                	sbb    %eax,%eax
  1044f7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1044fa:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1044fe:	0f 95 c0             	setne  %al
  104501:	0f b6 c0             	movzbl %al,%eax
  104504:	85 c0                	test   %eax,%eax
  104506:	74 0b                	je     104513 <default_check+0x3c2>
  104508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10450b:	8b 40 08             	mov    0x8(%eax),%eax
  10450e:	83 f8 01             	cmp    $0x1,%eax
  104511:	74 24                	je     104537 <default_check+0x3e6>
  104513:	c7 44 24 0c f4 78 10 	movl   $0x1078f4,0xc(%esp)
  10451a:	00 
  10451b:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  104522:	00 
  104523:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10452a:	00 
  10452b:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  104532:	e8 b3 c7 ff ff       	call   100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104537:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10453a:	83 c0 04             	add    $0x4,%eax
  10453d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  104544:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  104547:	8b 45 90             	mov    -0x70(%ebp),%eax
  10454a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10454d:	0f a3 10             	bt     %edx,(%eax)
  104550:	19 c0                	sbb    %eax,%eax
  104552:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  104555:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  104559:	0f 95 c0             	setne  %al
  10455c:	0f b6 c0             	movzbl %al,%eax
  10455f:	85 c0                	test   %eax,%eax
  104561:	74 0b                	je     10456e <default_check+0x41d>
  104563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104566:	8b 40 08             	mov    0x8(%eax),%eax
  104569:	83 f8 03             	cmp    $0x3,%eax
  10456c:	74 24                	je     104592 <default_check+0x441>
  10456e:	c7 44 24 0c 1c 79 10 	movl   $0x10791c,0xc(%esp)
  104575:	00 
  104576:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10457d:	00 
  10457e:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  104585:	00 
  104586:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10458d:	e8 58 c7 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104592:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104599:	e8 85 05 00 00       	call   104b23 <alloc_pages>
  10459e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1045a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045a4:	83 e8 14             	sub    $0x14,%eax
  1045a7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1045aa:	74 24                	je     1045d0 <default_check+0x47f>
  1045ac:	c7 44 24 0c 42 79 10 	movl   $0x107942,0xc(%esp)
  1045b3:	00 
  1045b4:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1045bb:	00 
  1045bc:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  1045c3:	00 
  1045c4:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1045cb:	e8 1a c7 ff ff       	call   100cea <__panic>
    free_page(p0);
  1045d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045d7:	00 
  1045d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045db:	89 04 24             	mov    %eax,(%esp)
  1045de:	e8 7a 05 00 00       	call   104b5d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1045e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1045ea:	e8 34 05 00 00       	call   104b23 <alloc_pages>
  1045ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1045f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045f5:	83 c0 14             	add    $0x14,%eax
  1045f8:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1045fb:	74 24                	je     104621 <default_check+0x4d0>
  1045fd:	c7 44 24 0c 60 79 10 	movl   $0x107960,0xc(%esp)
  104604:	00 
  104605:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10460c:	00 
  10460d:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  104614:	00 
  104615:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10461c:	e8 c9 c6 ff ff       	call   100cea <__panic>

    free_pages(p0, 2);
  104621:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104628:	00 
  104629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10462c:	89 04 24             	mov    %eax,(%esp)
  10462f:	e8 29 05 00 00       	call   104b5d <free_pages>
    free_page(p2);
  104634:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10463b:	00 
  10463c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10463f:	89 04 24             	mov    %eax,(%esp)
  104642:	e8 16 05 00 00       	call   104b5d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  104647:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10464e:	e8 d0 04 00 00       	call   104b23 <alloc_pages>
  104653:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104656:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10465a:	75 24                	jne    104680 <default_check+0x52f>
  10465c:	c7 44 24 0c 80 79 10 	movl   $0x107980,0xc(%esp)
  104663:	00 
  104664:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10466b:	00 
  10466c:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  104673:	00 
  104674:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10467b:	e8 6a c6 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  104680:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104687:	e8 97 04 00 00       	call   104b23 <alloc_pages>
  10468c:	85 c0                	test   %eax,%eax
  10468e:	74 24                	je     1046b4 <default_check+0x563>
  104690:	c7 44 24 0c de 77 10 	movl   $0x1077de,0xc(%esp)
  104697:	00 
  104698:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10469f:	00 
  1046a0:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  1046a7:	00 
  1046a8:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1046af:	e8 36 c6 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  1046b4:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1046b9:	85 c0                	test   %eax,%eax
  1046bb:	74 24                	je     1046e1 <default_check+0x590>
  1046bd:	c7 44 24 0c 31 78 10 	movl   $0x107831,0xc(%esp)
  1046c4:	00 
  1046c5:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1046cc:	00 
  1046cd:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  1046d4:	00 
  1046d5:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1046dc:	e8 09 c6 ff ff       	call   100cea <__panic>
    nr_free = nr_free_store;
  1046e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046e4:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_list = free_list_store;
  1046e9:	8b 45 80             	mov    -0x80(%ebp),%eax
  1046ec:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1046ef:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  1046f4:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    free_pages(p0, 5);
  1046fa:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104701:	00 
  104702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104705:	89 04 24             	mov    %eax,(%esp)
  104708:	e8 50 04 00 00       	call   104b5d <free_pages>

    le = &free_list;
  10470d:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  104714:	eb 5a                	jmp    104770 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
  104716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104719:	8b 40 04             	mov    0x4(%eax),%eax
  10471c:	8b 00                	mov    (%eax),%eax
  10471e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104721:	75 0d                	jne    104730 <default_check+0x5df>
  104723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104726:	8b 00                	mov    (%eax),%eax
  104728:	8b 40 04             	mov    0x4(%eax),%eax
  10472b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10472e:	74 24                	je     104754 <default_check+0x603>
  104730:	c7 44 24 0c a0 79 10 	movl   $0x1079a0,0xc(%esp)
  104737:	00 
  104738:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10473f:	00 
  104740:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  104747:	00 
  104748:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  10474f:	e8 96 c5 ff ff       	call   100cea <__panic>
        struct Page *p = le2page(le, page_link);
  104754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104757:	83 e8 0c             	sub    $0xc,%eax
  10475a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  10475d:	ff 4d f4             	decl   -0xc(%ebp)
  104760:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104763:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104766:	8b 48 08             	mov    0x8(%eax),%ecx
  104769:	89 d0                	mov    %edx,%eax
  10476b:	29 c8                	sub    %ecx,%eax
  10476d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104773:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  104776:	8b 45 88             	mov    -0x78(%ebp),%eax
  104779:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  10477c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10477f:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  104786:	75 8e                	jne    104716 <default_check+0x5c5>
    }
    assert(count == 0);
  104788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10478c:	74 24                	je     1047b2 <default_check+0x661>
  10478e:	c7 44 24 0c cd 79 10 	movl   $0x1079cd,0xc(%esp)
  104795:	00 
  104796:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  10479d:	00 
  10479e:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  1047a5:	00 
  1047a6:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1047ad:	e8 38 c5 ff ff       	call   100cea <__panic>
    assert(total == 0);
  1047b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1047b6:	74 24                	je     1047dc <default_check+0x68b>
  1047b8:	c7 44 24 0c d8 79 10 	movl   $0x1079d8,0xc(%esp)
  1047bf:	00 
  1047c0:	c7 44 24 08 56 76 10 	movl   $0x107656,0x8(%esp)
  1047c7:	00 
  1047c8:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  1047cf:	00 
  1047d0:	c7 04 24 6b 76 10 00 	movl   $0x10766b,(%esp)
  1047d7:	e8 0e c5 ff ff       	call   100cea <__panic>
}
  1047dc:	90                   	nop
  1047dd:	89 ec                	mov    %ebp,%esp
  1047df:	5d                   	pop    %ebp
  1047e0:	c3                   	ret    

001047e1 <page2ppn>:
page2ppn(struct Page *page) {
  1047e1:	55                   	push   %ebp
  1047e2:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1047e4:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  1047ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ed:	29 d0                	sub    %edx,%eax
  1047ef:	c1 f8 02             	sar    $0x2,%eax
  1047f2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1047f8:	5d                   	pop    %ebp
  1047f9:	c3                   	ret    

001047fa <page2pa>:
page2pa(struct Page *page) {
  1047fa:	55                   	push   %ebp
  1047fb:	89 e5                	mov    %esp,%ebp
  1047fd:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104800:	8b 45 08             	mov    0x8(%ebp),%eax
  104803:	89 04 24             	mov    %eax,(%esp)
  104806:	e8 d6 ff ff ff       	call   1047e1 <page2ppn>
  10480b:	c1 e0 0c             	shl    $0xc,%eax
}
  10480e:	89 ec                	mov    %ebp,%esp
  104810:	5d                   	pop    %ebp
  104811:	c3                   	ret    

00104812 <pa2page>:
pa2page(uintptr_t pa) {
  104812:	55                   	push   %ebp
  104813:	89 e5                	mov    %esp,%ebp
  104815:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  104818:	8b 45 08             	mov    0x8(%ebp),%eax
  10481b:	c1 e8 0c             	shr    $0xc,%eax
  10481e:	89 c2                	mov    %eax,%edx
  104820:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104825:	39 c2                	cmp    %eax,%edx
  104827:	72 1c                	jb     104845 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  104829:	c7 44 24 08 14 7a 10 	movl   $0x107a14,0x8(%esp)
  104830:	00 
  104831:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  104838:	00 
  104839:	c7 04 24 33 7a 10 00 	movl   $0x107a33,(%esp)
  104840:	e8 a5 c4 ff ff       	call   100cea <__panic>
    return &pages[PPN(pa)];
  104845:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  10484b:	8b 45 08             	mov    0x8(%ebp),%eax
  10484e:	c1 e8 0c             	shr    $0xc,%eax
  104851:	89 c2                	mov    %eax,%edx
  104853:	89 d0                	mov    %edx,%eax
  104855:	c1 e0 02             	shl    $0x2,%eax
  104858:	01 d0                	add    %edx,%eax
  10485a:	c1 e0 02             	shl    $0x2,%eax
  10485d:	01 c8                	add    %ecx,%eax
}
  10485f:	89 ec                	mov    %ebp,%esp
  104861:	5d                   	pop    %ebp
  104862:	c3                   	ret    

00104863 <page2kva>:
page2kva(struct Page *page) {
  104863:	55                   	push   %ebp
  104864:	89 e5                	mov    %esp,%ebp
  104866:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  104869:	8b 45 08             	mov    0x8(%ebp),%eax
  10486c:	89 04 24             	mov    %eax,(%esp)
  10486f:	e8 86 ff ff ff       	call   1047fa <page2pa>
  104874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10487a:	c1 e8 0c             	shr    $0xc,%eax
  10487d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104880:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104885:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104888:	72 23                	jb     1048ad <page2kva+0x4a>
  10488a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10488d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104891:	c7 44 24 08 44 7a 10 	movl   $0x107a44,0x8(%esp)
  104898:	00 
  104899:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1048a0:	00 
  1048a1:	c7 04 24 33 7a 10 00 	movl   $0x107a33,(%esp)
  1048a8:	e8 3d c4 ff ff       	call   100cea <__panic>
  1048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1048b5:	89 ec                	mov    %ebp,%esp
  1048b7:	5d                   	pop    %ebp
  1048b8:	c3                   	ret    

001048b9 <pte2page>:
pte2page(pte_t pte) {
  1048b9:	55                   	push   %ebp
  1048ba:	89 e5                	mov    %esp,%ebp
  1048bc:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1048bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c2:	83 e0 01             	and    $0x1,%eax
  1048c5:	85 c0                	test   %eax,%eax
  1048c7:	75 1c                	jne    1048e5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1048c9:	c7 44 24 08 68 7a 10 	movl   $0x107a68,0x8(%esp)
  1048d0:	00 
  1048d1:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  1048d8:	00 
  1048d9:	c7 04 24 33 7a 10 00 	movl   $0x107a33,(%esp)
  1048e0:	e8 05 c4 ff ff       	call   100cea <__panic>
    return pa2page(PTE_ADDR(pte));
  1048e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1048ed:	89 04 24             	mov    %eax,(%esp)
  1048f0:	e8 1d ff ff ff       	call   104812 <pa2page>
}
  1048f5:	89 ec                	mov    %ebp,%esp
  1048f7:	5d                   	pop    %ebp
  1048f8:	c3                   	ret    

001048f9 <pde2page>:
pde2page(pde_t pde) {
  1048f9:	55                   	push   %ebp
  1048fa:	89 e5                	mov    %esp,%ebp
  1048fc:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  1048ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104907:	89 04 24             	mov    %eax,(%esp)
  10490a:	e8 03 ff ff ff       	call   104812 <pa2page>
}
  10490f:	89 ec                	mov    %ebp,%esp
  104911:	5d                   	pop    %ebp
  104912:	c3                   	ret    

00104913 <page_ref>:
page_ref(struct Page *page) {
  104913:	55                   	push   %ebp
  104914:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104916:	8b 45 08             	mov    0x8(%ebp),%eax
  104919:	8b 00                	mov    (%eax),%eax
}
  10491b:	5d                   	pop    %ebp
  10491c:	c3                   	ret    

0010491d <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10491d:	55                   	push   %ebp
  10491e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104920:	8b 45 08             	mov    0x8(%ebp),%eax
  104923:	8b 55 0c             	mov    0xc(%ebp),%edx
  104926:	89 10                	mov    %edx,(%eax)
}
  104928:	90                   	nop
  104929:	5d                   	pop    %ebp
  10492a:	c3                   	ret    

0010492b <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  10492b:	55                   	push   %ebp
  10492c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  10492e:	8b 45 08             	mov    0x8(%ebp),%eax
  104931:	8b 00                	mov    (%eax),%eax
  104933:	8d 50 01             	lea    0x1(%eax),%edx
  104936:	8b 45 08             	mov    0x8(%ebp),%eax
  104939:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10493b:	8b 45 08             	mov    0x8(%ebp),%eax
  10493e:	8b 00                	mov    (%eax),%eax
}
  104940:	5d                   	pop    %ebp
  104941:	c3                   	ret    

00104942 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  104942:	55                   	push   %ebp
  104943:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  104945:	8b 45 08             	mov    0x8(%ebp),%eax
  104948:	8b 00                	mov    (%eax),%eax
  10494a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10494d:	8b 45 08             	mov    0x8(%ebp),%eax
  104950:	89 10                	mov    %edx,(%eax)
    return page->ref;
  104952:	8b 45 08             	mov    0x8(%ebp),%eax
  104955:	8b 00                	mov    (%eax),%eax
}
  104957:	5d                   	pop    %ebp
  104958:	c3                   	ret    

00104959 <__intr_save>:
{
  104959:	55                   	push   %ebp
  10495a:	89 e5                	mov    %esp,%ebp
  10495c:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
  10495f:	9c                   	pushf  
  104960:	58                   	pop    %eax
  104961:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  104964:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
  104967:	25 00 02 00 00       	and    $0x200,%eax
  10496c:	85 c0                	test   %eax,%eax
  10496e:	74 0c                	je     10497c <__intr_save+0x23>
        intr_disable();
  104970:	e8 ce cd ff ff       	call   101743 <intr_disable>
        return 1;
  104975:	b8 01 00 00 00       	mov    $0x1,%eax
  10497a:	eb 05                	jmp    104981 <__intr_save+0x28>
    return 0;
  10497c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104981:	89 ec                	mov    %ebp,%esp
  104983:	5d                   	pop    %ebp
  104984:	c3                   	ret    

00104985 <__intr_restore>:
{
  104985:	55                   	push   %ebp
  104986:	89 e5                	mov    %esp,%ebp
  104988:	83 ec 08             	sub    $0x8,%esp
    if (flag)
  10498b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10498f:	74 05                	je     104996 <__intr_restore+0x11>
        intr_enable();
  104991:	e8 a5 cd ff ff       	call   10173b <intr_enable>
}
  104996:	90                   	nop
  104997:	89 ec                	mov    %ebp,%esp
  104999:	5d                   	pop    %ebp
  10499a:	c3                   	ret    

0010499b <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
  10499b:	55                   	push   %ebp
  10499c:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
  10499e:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a1:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
  1049a4:	b8 23 00 00 00       	mov    $0x23,%eax
  1049a9:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
  1049ab:	b8 23 00 00 00       	mov    $0x23,%eax
  1049b0:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
  1049b2:	b8 10 00 00 00       	mov    $0x10,%eax
  1049b7:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
  1049b9:	b8 10 00 00 00       	mov    $0x10,%eax
  1049be:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
  1049c0:	b8 10 00 00 00       	mov    $0x10,%eax
  1049c5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
  1049c7:	ea ce 49 10 00 08 00 	ljmp   $0x8,$0x1049ce
}
  1049ce:	90                   	nop
  1049cf:	5d                   	pop    %ebp
  1049d0:	c3                   	ret    

001049d1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
  1049d1:	55                   	push   %ebp
  1049d2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  1049d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1049d7:	a3 c4 ee 11 00       	mov    %eax,0x11eec4
}
  1049dc:	90                   	nop
  1049dd:	5d                   	pop    %ebp
  1049de:	c3                   	ret    

001049df <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
  1049df:	55                   	push   %ebp
  1049e0:	89 e5                	mov    %esp,%ebp
  1049e2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  1049e5:	b8 00 b0 11 00       	mov    $0x11b000,%eax
  1049ea:	89 04 24             	mov    %eax,(%esp)
  1049ed:	e8 df ff ff ff       	call   1049d1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  1049f2:	66 c7 05 c8 ee 11 00 	movw   $0x10,0x11eec8
  1049f9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  1049fb:	66 c7 05 28 ba 11 00 	movw   $0x68,0x11ba28
  104a02:	68 00 
  104a04:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a09:	0f b7 c0             	movzwl %ax,%eax
  104a0c:	66 a3 2a ba 11 00    	mov    %ax,0x11ba2a
  104a12:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a17:	c1 e8 10             	shr    $0x10,%eax
  104a1a:	a2 2c ba 11 00       	mov    %al,0x11ba2c
  104a1f:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a26:	24 f0                	and    $0xf0,%al
  104a28:	0c 09                	or     $0x9,%al
  104a2a:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104a2f:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a36:	24 ef                	and    $0xef,%al
  104a38:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104a3d:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a44:	24 9f                	and    $0x9f,%al
  104a46:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104a4b:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a52:	0c 80                	or     $0x80,%al
  104a54:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104a59:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104a60:	24 f0                	and    $0xf0,%al
  104a62:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104a67:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104a6e:	24 ef                	and    $0xef,%al
  104a70:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104a75:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104a7c:	24 df                	and    $0xdf,%al
  104a7e:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104a83:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104a8a:	0c 40                	or     $0x40,%al
  104a8c:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104a91:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104a98:	24 7f                	and    $0x7f,%al
  104a9a:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104a9f:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104aa4:	c1 e8 18             	shr    $0x18,%eax
  104aa7:	a2 2f ba 11 00       	mov    %al,0x11ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104aac:	c7 04 24 30 ba 11 00 	movl   $0x11ba30,(%esp)
  104ab3:	e8 e3 fe ff ff       	call   10499b <lgdt>
  104ab8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
  104abe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  104ac2:	0f 00 d8             	ltr    %ax
}
  104ac5:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  104ac6:	90                   	nop
  104ac7:	89 ec                	mov    %ebp,%esp
  104ac9:	5d                   	pop    %ebp
  104aca:	c3                   	ret    

00104acb <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
  104acb:	55                   	push   %ebp
  104acc:	89 e5                	mov    %esp,%ebp
  104ace:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  104ad1:	c7 05 ac ee 11 00 f8 	movl   $0x1079f8,0x11eeac
  104ad8:	79 10 00 
    //pmm_manager = &buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
  104adb:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104ae0:	8b 00                	mov    (%eax),%eax
  104ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ae6:	c7 04 24 94 7a 10 00 	movl   $0x107a94,(%esp)
  104aed:	e8 73 b8 ff ff       	call   100365 <cprintf>
    pmm_manager->init();
  104af2:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104af7:	8b 40 04             	mov    0x4(%eax),%eax
  104afa:	ff d0                	call   *%eax
}
  104afc:	90                   	nop
  104afd:	89 ec                	mov    %ebp,%esp
  104aff:	5d                   	pop    %ebp
  104b00:	c3                   	ret    

00104b01 <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
  104b01:	55                   	push   %ebp
  104b02:	89 e5                	mov    %esp,%ebp
  104b04:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  104b07:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b0c:	8b 40 08             	mov    0x8(%eax),%eax
  104b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b12:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b16:	8b 55 08             	mov    0x8(%ebp),%edx
  104b19:	89 14 24             	mov    %edx,(%esp)
  104b1c:	ff d0                	call   *%eax
}
  104b1e:	90                   	nop
  104b1f:	89 ec                	mov    %ebp,%esp
  104b21:	5d                   	pop    %ebp
  104b22:	c3                   	ret    

00104b23 <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
  104b23:	55                   	push   %ebp
  104b24:	89 e5                	mov    %esp,%ebp
  104b26:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
  104b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  104b30:	e8 24 fe ff ff       	call   104959 <__intr_save>
  104b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  104b38:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  104b40:	8b 55 08             	mov    0x8(%ebp),%edx
  104b43:	89 14 24             	mov    %edx,(%esp)
  104b46:	ff d0                	call   *%eax
  104b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  104b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b4e:	89 04 24             	mov    %eax,(%esp)
  104b51:	e8 2f fe ff ff       	call   104985 <__intr_restore>
    return page;
  104b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104b59:	89 ec                	mov    %ebp,%esp
  104b5b:	5d                   	pop    %ebp
  104b5c:	c3                   	ret    

00104b5d <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
  104b5d:	55                   	push   %ebp
  104b5e:	89 e5                	mov    %esp,%ebp
  104b60:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  104b63:	e8 f1 fd ff ff       	call   104959 <__intr_save>
  104b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  104b6b:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b70:	8b 40 10             	mov    0x10(%eax),%eax
  104b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b76:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  104b7d:	89 14 24             	mov    %edx,(%esp)
  104b80:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b85:	89 04 24             	mov    %eax,(%esp)
  104b88:	e8 f8 fd ff ff       	call   104985 <__intr_restore>
}
  104b8d:	90                   	nop
  104b8e:	89 ec                	mov    %ebp,%esp
  104b90:	5d                   	pop    %ebp
  104b91:	c3                   	ret    

00104b92 <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
  104b92:	55                   	push   %ebp
  104b93:	89 e5                	mov    %esp,%ebp
  104b95:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  104b98:	e8 bc fd ff ff       	call   104959 <__intr_save>
  104b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  104ba0:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104ba5:	8b 40 14             	mov    0x14(%eax),%eax
  104ba8:	ff d0                	call   *%eax
  104baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  104bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bb0:	89 04 24             	mov    %eax,(%esp)
  104bb3:	e8 cd fd ff ff       	call   104985 <__intr_restore>
    return ret;
  104bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104bbb:	89 ec                	mov    %ebp,%esp
  104bbd:	5d                   	pop    %ebp
  104bbe:	c3                   	ret    

00104bbf <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
  104bbf:	55                   	push   %ebp
  104bc0:	89 e5                	mov    %esp,%ebp
  104bc2:	57                   	push   %edi
  104bc3:	56                   	push   %esi
  104bc4:	53                   	push   %ebx
  104bc5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104bcb:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104bd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104bd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104be0:	c7 04 24 ab 7a 10 00 	movl   $0x107aab,(%esp)
  104be7:	e8 79 b7 ff ff       	call   100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
  104bec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104bf3:	e9 0c 01 00 00       	jmp    104d04 <page_init+0x145>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104bf8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104bfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104bfe:	89 d0                	mov    %edx,%eax
  104c00:	c1 e0 02             	shl    $0x2,%eax
  104c03:	01 d0                	add    %edx,%eax
  104c05:	c1 e0 02             	shl    $0x2,%eax
  104c08:	01 c8                	add    %ecx,%eax
  104c0a:	8b 50 08             	mov    0x8(%eax),%edx
  104c0d:	8b 40 04             	mov    0x4(%eax),%eax
  104c10:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104c13:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104c16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c1c:	89 d0                	mov    %edx,%eax
  104c1e:	c1 e0 02             	shl    $0x2,%eax
  104c21:	01 d0                	add    %edx,%eax
  104c23:	c1 e0 02             	shl    $0x2,%eax
  104c26:	01 c8                	add    %ecx,%eax
  104c28:	8b 48 0c             	mov    0xc(%eax),%ecx
  104c2b:	8b 58 10             	mov    0x10(%eax),%ebx
  104c2e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104c31:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104c34:	01 c8                	add    %ecx,%eax
  104c36:	11 da                	adc    %ebx,%edx
  104c38:	89 45 98             	mov    %eax,-0x68(%ebp)
  104c3b:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104c3e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c44:	89 d0                	mov    %edx,%eax
  104c46:	c1 e0 02             	shl    $0x2,%eax
  104c49:	01 d0                	add    %edx,%eax
  104c4b:	c1 e0 02             	shl    $0x2,%eax
  104c4e:	01 c8                	add    %ecx,%eax
  104c50:	83 c0 14             	add    $0x14,%eax
  104c53:	8b 00                	mov    (%eax),%eax
  104c55:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104c5b:	8b 45 98             	mov    -0x68(%ebp),%eax
  104c5e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104c61:	83 c0 ff             	add    $0xffffffff,%eax
  104c64:	83 d2 ff             	adc    $0xffffffff,%edx
  104c67:	89 c6                	mov    %eax,%esi
  104c69:	89 d7                	mov    %edx,%edi
  104c6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c71:	89 d0                	mov    %edx,%eax
  104c73:	c1 e0 02             	shl    $0x2,%eax
  104c76:	01 d0                	add    %edx,%eax
  104c78:	c1 e0 02             	shl    $0x2,%eax
  104c7b:	01 c8                	add    %ecx,%eax
  104c7d:	8b 48 0c             	mov    0xc(%eax),%ecx
  104c80:	8b 58 10             	mov    0x10(%eax),%ebx
  104c83:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104c89:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104c8d:	89 74 24 14          	mov    %esi,0x14(%esp)
  104c91:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104c95:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104c98:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c9f:	89 54 24 10          	mov    %edx,0x10(%esp)
  104ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104ca7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104cab:	c7 04 24 b8 7a 10 00 	movl   $0x107ab8,(%esp)
  104cb2:	e8 ae b6 ff ff       	call   100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
  104cb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104cba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104cbd:	89 d0                	mov    %edx,%eax
  104cbf:	c1 e0 02             	shl    $0x2,%eax
  104cc2:	01 d0                	add    %edx,%eax
  104cc4:	c1 e0 02             	shl    $0x2,%eax
  104cc7:	01 c8                	add    %ecx,%eax
  104cc9:	83 c0 14             	add    $0x14,%eax
  104ccc:	8b 00                	mov    (%eax),%eax
  104cce:	83 f8 01             	cmp    $0x1,%eax
  104cd1:	75 2e                	jne    104d01 <page_init+0x142>
        {
            if (maxpa < end && begin < KMEMSIZE)
  104cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104cd9:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104cdc:	89 d0                	mov    %edx,%eax
  104cde:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  104ce1:	73 1e                	jae    104d01 <page_init+0x142>
  104ce3:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  104ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  104ced:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104cf0:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  104cf3:	72 0c                	jb     104d01 <page_init+0x142>
            {
                maxpa = end;
  104cf5:	8b 45 98             	mov    -0x68(%ebp),%eax
  104cf8:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104cfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
  104d01:	ff 45 dc             	incl   -0x24(%ebp)
  104d04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d07:	8b 00                	mov    (%eax),%eax
  104d09:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104d0c:	0f 8c e6 fe ff ff    	jl     104bf8 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE)
  104d12:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104d17:	b8 00 00 00 00       	mov    $0x0,%eax
  104d1c:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104d1f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104d22:	73 0e                	jae    104d32 <page_init+0x173>
    {
        maxpa = KMEMSIZE;
  104d24:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104d2b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104d38:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104d3c:	c1 ea 0c             	shr    $0xc,%edx
  104d3f:	a3 a4 ee 11 00       	mov    %eax,0x11eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104d44:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104d4b:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  104d50:	8d 50 ff             	lea    -0x1(%eax),%edx
  104d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104d56:	01 d0                	add    %edx,%eax
  104d58:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104d5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  104d63:	f7 75 c0             	divl   -0x40(%ebp)
  104d66:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104d69:	29 d0                	sub    %edx,%eax
  104d6b:	a3 a0 ee 11 00       	mov    %eax,0x11eea0

    for (i = 0; i < npage; i++)
  104d70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104d77:	eb 2f                	jmp    104da8 <page_init+0x1e9>
    {
        SetPageReserved(pages + i);
  104d79:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  104d7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104d82:	89 d0                	mov    %edx,%eax
  104d84:	c1 e0 02             	shl    $0x2,%eax
  104d87:	01 d0                	add    %edx,%eax
  104d89:	c1 e0 02             	shl    $0x2,%eax
  104d8c:	01 c8                	add    %ecx,%eax
  104d8e:	83 c0 04             	add    $0x4,%eax
  104d91:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  104d98:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
  104d9b:	8b 45 90             	mov    -0x70(%ebp),%eax
  104d9e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104da1:	0f ab 10             	bts    %edx,(%eax)
}
  104da4:	90                   	nop
    for (i = 0; i < npage; i++)
  104da5:	ff 45 dc             	incl   -0x24(%ebp)
  104da8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104dab:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104db0:	39 c2                	cmp    %eax,%edx
  104db2:	72 c5                	jb     104d79 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104db4:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  104dba:	89 d0                	mov    %edx,%eax
  104dbc:	c1 e0 02             	shl    $0x2,%eax
  104dbf:	01 d0                	add    %edx,%eax
  104dc1:	c1 e0 02             	shl    $0x2,%eax
  104dc4:	89 c2                	mov    %eax,%edx
  104dc6:	a1 a0 ee 11 00       	mov    0x11eea0,%eax
  104dcb:	01 d0                	add    %edx,%eax
  104dcd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104dd0:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  104dd7:	77 23                	ja     104dfc <page_init+0x23d>
  104dd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104de0:	c7 44 24 08 e8 7a 10 	movl   $0x107ae8,0x8(%esp)
  104de7:	00 
  104de8:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  104def:	00 
  104df0:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  104df7:	e8 ee be ff ff       	call   100cea <__panic>
  104dfc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104dff:	05 00 00 00 40       	add    $0x40000000,%eax
  104e04:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
  104e07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104e0e:	e9 53 01 00 00       	jmp    104f66 <page_init+0x3a7>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104e13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104e16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e19:	89 d0                	mov    %edx,%eax
  104e1b:	c1 e0 02             	shl    $0x2,%eax
  104e1e:	01 d0                	add    %edx,%eax
  104e20:	c1 e0 02             	shl    $0x2,%eax
  104e23:	01 c8                	add    %ecx,%eax
  104e25:	8b 50 08             	mov    0x8(%eax),%edx
  104e28:	8b 40 04             	mov    0x4(%eax),%eax
  104e2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104e2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104e31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e37:	89 d0                	mov    %edx,%eax
  104e39:	c1 e0 02             	shl    $0x2,%eax
  104e3c:	01 d0                	add    %edx,%eax
  104e3e:	c1 e0 02             	shl    $0x2,%eax
  104e41:	01 c8                	add    %ecx,%eax
  104e43:	8b 48 0c             	mov    0xc(%eax),%ecx
  104e46:	8b 58 10             	mov    0x10(%eax),%ebx
  104e49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104e4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104e4f:	01 c8                	add    %ecx,%eax
  104e51:	11 da                	adc    %ebx,%edx
  104e53:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104e56:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
  104e59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e5f:	89 d0                	mov    %edx,%eax
  104e61:	c1 e0 02             	shl    $0x2,%eax
  104e64:	01 d0                	add    %edx,%eax
  104e66:	c1 e0 02             	shl    $0x2,%eax
  104e69:	01 c8                	add    %ecx,%eax
  104e6b:	83 c0 14             	add    $0x14,%eax
  104e6e:	8b 00                	mov    (%eax),%eax
  104e70:	83 f8 01             	cmp    $0x1,%eax
  104e73:	0f 85 ea 00 00 00    	jne    104f63 <page_init+0x3a4>
        {
            if (begin < freemem)
  104e79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104e7c:	ba 00 00 00 00       	mov    $0x0,%edx
  104e81:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104e84:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  104e87:	19 d1                	sbb    %edx,%ecx
  104e89:	73 0d                	jae    104e98 <page_init+0x2d9>
            {
                begin = freemem;
  104e8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104e8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104e91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
  104e98:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  104ea2:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  104ea5:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104ea8:	73 0e                	jae    104eb8 <page_init+0x2f9>
            {
                end = KMEMSIZE;
  104eaa:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104eb1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
  104eb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ebb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ebe:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104ec1:	89 d0                	mov    %edx,%eax
  104ec3:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104ec6:	0f 83 97 00 00 00    	jae    104f63 <page_init+0x3a4>
            {
                begin = ROUNDUP(begin, PGSIZE);
  104ecc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  104ed3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104ed6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104ed9:	01 d0                	add    %edx,%eax
  104edb:	48                   	dec    %eax
  104edc:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104edf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  104ee7:	f7 75 b0             	divl   -0x50(%ebp)
  104eea:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104eed:	29 d0                	sub    %edx,%eax
  104eef:	ba 00 00 00 00       	mov    $0x0,%edx
  104ef4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104efa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104efd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104f00:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104f03:	ba 00 00 00 00       	mov    $0x0,%edx
  104f08:	89 c7                	mov    %eax,%edi
  104f0a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104f10:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104f13:	89 d0                	mov    %edx,%eax
  104f15:	83 e0 00             	and    $0x0,%eax
  104f18:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104f1b:	8b 45 80             	mov    -0x80(%ebp),%eax
  104f1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104f21:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104f24:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
  104f27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f2d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104f30:	89 d0                	mov    %edx,%eax
  104f32:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104f35:	73 2c                	jae    104f63 <page_init+0x3a4>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104f37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104f3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104f3d:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104f40:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104f43:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104f47:	c1 ea 0c             	shr    $0xc,%edx
  104f4a:	89 c3                	mov    %eax,%ebx
  104f4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f4f:	89 04 24             	mov    %eax,(%esp)
  104f52:	e8 bb f8 ff ff       	call   104812 <pa2page>
  104f57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104f5b:	89 04 24             	mov    %eax,(%esp)
  104f5e:	e8 9e fb ff ff       	call   104b01 <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
  104f63:	ff 45 dc             	incl   -0x24(%ebp)
  104f66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104f69:	8b 00                	mov    (%eax),%eax
  104f6b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104f6e:	0f 8c 9f fe ff ff    	jl     104e13 <page_init+0x254>
                }
            }
        }
    }
}
  104f74:	90                   	nop
  104f75:	90                   	nop
  104f76:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104f7c:	5b                   	pop    %ebx
  104f7d:	5e                   	pop    %esi
  104f7e:	5f                   	pop    %edi
  104f7f:	5d                   	pop    %ebp
  104f80:	c3                   	ret    

00104f81 <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
  104f81:	55                   	push   %ebp
  104f82:	89 e5                	mov    %esp,%ebp
  104f84:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  104f8a:	33 45 14             	xor    0x14(%ebp),%eax
  104f8d:	25 ff 0f 00 00       	and    $0xfff,%eax
  104f92:	85 c0                	test   %eax,%eax
  104f94:	74 24                	je     104fba <boot_map_segment+0x39>
  104f96:	c7 44 24 0c 1a 7b 10 	movl   $0x107b1a,0xc(%esp)
  104f9d:	00 
  104f9e:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  104fa5:	00 
  104fa6:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  104fad:	00 
  104fae:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  104fb5:	e8 30 bd ff ff       	call   100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104fba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  104fc4:	25 ff 0f 00 00       	and    $0xfff,%eax
  104fc9:	89 c2                	mov    %eax,%edx
  104fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  104fce:	01 c2                	add    %eax,%edx
  104fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fd3:	01 d0                	add    %edx,%eax
  104fd5:	48                   	dec    %eax
  104fd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  104fe1:	f7 75 f0             	divl   -0x10(%ebp)
  104fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fe7:	29 d0                	sub    %edx,%eax
  104fe9:	c1 e8 0c             	shr    $0xc,%eax
  104fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ff2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ff8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ffd:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  105000:	8b 45 14             	mov    0x14(%ebp),%eax
  105003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10500e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  105011:	eb 68                	jmp    10507b <boot_map_segment+0xfa>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
  105013:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10501a:	00 
  10501b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10501e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105022:	8b 45 08             	mov    0x8(%ebp),%eax
  105025:	89 04 24             	mov    %eax,(%esp)
  105028:	e8 88 01 00 00       	call   1051b5 <get_pte>
  10502d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  105030:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105034:	75 24                	jne    10505a <boot_map_segment+0xd9>
  105036:	c7 44 24 0c 46 7b 10 	movl   $0x107b46,0xc(%esp)
  10503d:	00 
  10503e:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105045:	00 
  105046:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  10504d:	00 
  10504e:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105055:	e8 90 bc ff ff       	call   100cea <__panic>
        *ptep = pa | PTE_P | perm;
  10505a:	8b 45 14             	mov    0x14(%ebp),%eax
  10505d:	0b 45 18             	or     0x18(%ebp),%eax
  105060:	83 c8 01             	or     $0x1,%eax
  105063:	89 c2                	mov    %eax,%edx
  105065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105068:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  10506a:	ff 4d f4             	decl   -0xc(%ebp)
  10506d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  105074:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10507b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10507f:	75 92                	jne    105013 <boot_map_segment+0x92>
    }
}
  105081:	90                   	nop
  105082:	90                   	nop
  105083:	89 ec                	mov    %ebp,%esp
  105085:	5d                   	pop    %ebp
  105086:	c3                   	ret    

00105087 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
  105087:	55                   	push   %ebp
  105088:	89 e5                	mov    %esp,%ebp
  10508a:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10508d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105094:	e8 8a fa ff ff       	call   104b23 <alloc_pages>
  105099:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
  10509c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050a0:	75 1c                	jne    1050be <boot_alloc_page+0x37>
    {
        panic("boot_alloc_page failed.\n");
  1050a2:	c7 44 24 08 53 7b 10 	movl   $0x107b53,0x8(%esp)
  1050a9:	00 
  1050aa:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1050b1:	00 
  1050b2:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1050b9:	e8 2c bc ff ff       	call   100cea <__panic>
    }
    return page2kva(p);
  1050be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050c1:	89 04 24             	mov    %eax,(%esp)
  1050c4:	e8 9a f7 ff ff       	call   104863 <page2kva>
}
  1050c9:	89 ec                	mov    %ebp,%esp
  1050cb:	5d                   	pop    %ebp
  1050cc:	c3                   	ret    

001050cd <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
  1050cd:	55                   	push   %ebp
  1050ce:	89 e5                	mov    %esp,%ebp
  1050d0:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1050d3:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1050d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050db:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1050e2:	77 23                	ja     105107 <pmm_init+0x3a>
  1050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050eb:	c7 44 24 08 e8 7a 10 	movl   $0x107ae8,0x8(%esp)
  1050f2:	00 
  1050f3:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1050fa:	00 
  1050fb:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105102:	e8 e3 bb ff ff       	call   100cea <__panic>
  105107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10510a:	05 00 00 00 40       	add    $0x40000000,%eax
  10510f:	a3 a8 ee 11 00       	mov    %eax,0x11eea8
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  105114:	e8 b2 f9 ff ff       	call   104acb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  105119:	e8 a1 fa ff ff       	call   104bbf <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10511e:	e8 ed 03 00 00       	call   105510 <check_alloc_page>

    check_pgdir();
  105123:	e8 09 04 00 00       	call   105531 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  105128:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10512d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105130:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105137:	77 23                	ja     10515c <pmm_init+0x8f>
  105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10513c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105140:	c7 44 24 08 e8 7a 10 	movl   $0x107ae8,0x8(%esp)
  105147:	00 
  105148:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  10514f:	00 
  105150:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105157:	e8 8e bb ff ff       	call   100cea <__panic>
  10515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10515f:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  105165:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10516a:	05 ac 0f 00 00       	add    $0xfac,%eax
  10516f:	83 ca 03             	or     $0x3,%edx
  105172:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  105174:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105179:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  105180:	00 
  105181:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105188:	00 
  105189:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  105190:	38 
  105191:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  105198:	c0 
  105199:	89 04 24             	mov    %eax,(%esp)
  10519c:	e8 e0 fd ff ff       	call   104f81 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1051a1:	e8 39 f8 ff ff       	call   1049df <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1051a6:	e8 24 0a 00 00       	call   105bcf <check_boot_pgdir>

    print_pgdir();
  1051ab:	e8 a1 0e 00 00       	call   106051 <print_pgdir>
}
  1051b0:	90                   	nop
  1051b1:	89 ec                	mov    %ebp,%esp
  1051b3:	5d                   	pop    %ebp
  1051b4:	c3                   	ret    

001051b5 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
  1051b5:	55                   	push   %ebp
  1051b6:	89 e5                	mov    %esp,%ebp
  1051b8:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep = &pgdir[PDX(la)];
  1051bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051be:	c1 e8 16             	shr    $0x16,%eax
  1051c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1051cb:	01 d0                	add    %edx,%eax
  1051cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
  1051d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051d3:	8b 00                	mov    (%eax),%eax
  1051d5:	83 e0 01             	and    $0x1,%eax
  1051d8:	85 c0                	test   %eax,%eax
  1051da:	0f 85 af 00 00 00    	jne    10528f <get_pte+0xda>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
  1051e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051e4:	74 15                	je     1051fb <get_pte+0x46>
  1051e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051ed:	e8 31 f9 ff ff       	call   104b23 <alloc_pages>
  1051f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1051f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1051f9:	75 0a                	jne    105205 <get_pte+0x50>
        {
            return NULL;
  1051fb:	b8 00 00 00 00       	mov    $0x0,%eax
  105200:	e9 e7 00 00 00       	jmp    1052ec <get_pte+0x137>
        }
        //设置page reference
        set_page_ref(page, 1);
  105205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10520c:	00 
  10520d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105210:	89 04 24             	mov    %eax,(%esp)
  105213:	e8 05 f7 ff ff       	call   10491d <set_page_ref>
        //得到page的线性地址
        uintptr_t pa = page2pa(page);
  105218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10521b:	89 04 24             	mov    %eax,(%esp)
  10521e:	e8 d7 f5 ff ff       	call   1047fa <page2pa>
  105223:	89 45 ec             	mov    %eax,-0x14(%ebp)
        //用memset清除page
        memset(KADDR(pa), 0, PGSIZE);
  105226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105229:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10522c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10522f:	c1 e8 0c             	shr    $0xc,%eax
  105232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105235:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  10523a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10523d:	72 23                	jb     105262 <get_pte+0xad>
  10523f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105242:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105246:	c7 44 24 08 44 7a 10 	movl   $0x107a44,0x8(%esp)
  10524d:	00 
  10524e:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
  105255:	00 
  105256:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10525d:	e8 88 ba ff ff       	call   100cea <__panic>
  105262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105265:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10526a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105271:	00 
  105272:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105279:	00 
  10527a:	89 04 24             	mov    %eax,(%esp)
  10527d:	e8 d4 18 00 00       	call   106b56 <memset>
        //返回PTE
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  105282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105285:	83 c8 07             	or     $0x7,%eax
  105288:	89 c2                	mov    %eax,%edx
  10528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10528d:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10528f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105292:	8b 00                	mov    (%eax),%eax
  105294:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105299:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10529c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10529f:	c1 e8 0c             	shr    $0xc,%eax
  1052a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1052a5:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1052aa:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1052ad:	72 23                	jb     1052d2 <get_pte+0x11d>
  1052af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1052b6:	c7 44 24 08 44 7a 10 	movl   $0x107a44,0x8(%esp)
  1052bd:	00 
  1052be:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
  1052c5:	00 
  1052c6:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1052cd:	e8 18 ba ff ff       	call   100cea <__panic>
  1052d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1052da:	89 c2                	mov    %eax,%edx
  1052dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052df:	c1 e8 0c             	shr    $0xc,%eax
  1052e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  1052e7:	c1 e0 02             	shl    $0x2,%eax
  1052ea:	01 d0                	add    %edx,%eax
}
  1052ec:	89 ec                	mov    %ebp,%esp
  1052ee:	5d                   	pop    %ebp
  1052ef:	c3                   	ret    

001052f0 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
  1052f0:	55                   	push   %ebp
  1052f1:	89 e5                	mov    %esp,%ebp
  1052f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1052f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1052fd:	00 
  1052fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105301:	89 44 24 04          	mov    %eax,0x4(%esp)
  105305:	8b 45 08             	mov    0x8(%ebp),%eax
  105308:	89 04 24             	mov    %eax,(%esp)
  10530b:	e8 a5 fe ff ff       	call   1051b5 <get_pte>
  105310:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
  105313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105317:	74 08                	je     105321 <get_page+0x31>
    {
        *ptep_store = ptep;
  105319:	8b 45 10             	mov    0x10(%ebp),%eax
  10531c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10531f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
  105321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105325:	74 1b                	je     105342 <get_page+0x52>
  105327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10532a:	8b 00                	mov    (%eax),%eax
  10532c:	83 e0 01             	and    $0x1,%eax
  10532f:	85 c0                	test   %eax,%eax
  105331:	74 0f                	je     105342 <get_page+0x52>
    {
        return pte2page(*ptep);
  105333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105336:	8b 00                	mov    (%eax),%eax
  105338:	89 04 24             	mov    %eax,(%esp)
  10533b:	e8 79 f5 ff ff       	call   1048b9 <pte2page>
  105340:	eb 05                	jmp    105347 <get_page+0x57>
    }
    return NULL;
  105342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105347:	89 ec                	mov    %ebp,%esp
  105349:	5d                   	pop    %ebp
  10534a:	c3                   	ret    

0010534b <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
  10534b:	55                   	push   %ebp
  10534c:	89 e5                	mov    %esp,%ebp
  10534e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
  105351:	8b 45 10             	mov    0x10(%ebp),%eax
  105354:	8b 00                	mov    (%eax),%eax
  105356:	83 e0 01             	and    $0x1,%eax
  105359:	85 c0                	test   %eax,%eax
  10535b:	74 4d                	je     1053aa <page_remove_pte+0x5f>
    {
        struct Page *page = pte2page(*ptep);
  10535d:	8b 45 10             	mov    0x10(%ebp),%eax
  105360:	8b 00                	mov    (%eax),%eax
  105362:	89 04 24             	mov    %eax,(%esp)
  105365:	e8 4f f5 ff ff       	call   1048b9 <pte2page>
  10536a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //  (page_ref_dec(page)将page的ref减1,并返回减1之后的ref
        if (page_ref_dec(page) == 0)
  10536d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105370:	89 04 24             	mov    %eax,(%esp)
  105373:	e8 ca f5 ff ff       	call   104942 <page_ref_dec>
  105378:	85 c0                	test   %eax,%eax
  10537a:	75 13                	jne    10538f <page_remove_pte+0x44>
        {
            free_page(page);
  10537c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105383:	00 
  105384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105387:	89 04 24             	mov    %eax,(%esp)
  10538a:	e8 ce f7 ff ff       	call   104b5d <free_pages>
        }
        //清除第二个页表 PTE
        *ptep = 0;
  10538f:	8b 45 10             	mov    0x10(%ebp),%eax
  105392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  105398:	8b 45 0c             	mov    0xc(%ebp),%eax
  10539b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10539f:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a2:	89 04 24             	mov    %eax,(%esp)
  1053a5:	e8 07 01 00 00       	call   1054b1 <tlb_invalidate>
    }
}
  1053aa:	90                   	nop
  1053ab:	89 ec                	mov    %ebp,%esp
  1053ad:	5d                   	pop    %ebp
  1053ae:	c3                   	ret    

001053af <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
  1053af:	55                   	push   %ebp
  1053b0:	89 e5                	mov    %esp,%ebp
  1053b2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1053b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1053bc:	00 
  1053bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1053c7:	89 04 24             	mov    %eax,(%esp)
  1053ca:	e8 e6 fd ff ff       	call   1051b5 <get_pte>
  1053cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
  1053d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1053d6:	74 19                	je     1053f1 <page_remove+0x42>
    {
        page_remove_pte(pgdir, la, ptep);
  1053d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e9:	89 04 24             	mov    %eax,(%esp)
  1053ec:	e8 5a ff ff ff       	call   10534b <page_remove_pte>
    }
}
  1053f1:	90                   	nop
  1053f2:	89 ec                	mov    %ebp,%esp
  1053f4:	5d                   	pop    %ebp
  1053f5:	c3                   	ret    

001053f6 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
  1053f6:	55                   	push   %ebp
  1053f7:	89 e5                	mov    %esp,%ebp
  1053f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1053fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105403:	00 
  105404:	8b 45 10             	mov    0x10(%ebp),%eax
  105407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10540b:	8b 45 08             	mov    0x8(%ebp),%eax
  10540e:	89 04 24             	mov    %eax,(%esp)
  105411:	e8 9f fd ff ff       	call   1051b5 <get_pte>
  105416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
  105419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10541d:	75 0a                	jne    105429 <page_insert+0x33>
    {
        return -E_NO_MEM;
  10541f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  105424:	e9 84 00 00 00       	jmp    1054ad <page_insert+0xb7>
    }
    page_ref_inc(page);
  105429:	8b 45 0c             	mov    0xc(%ebp),%eax
  10542c:	89 04 24             	mov    %eax,(%esp)
  10542f:	e8 f7 f4 ff ff       	call   10492b <page_ref_inc>
    if (*ptep & PTE_P)
  105434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105437:	8b 00                	mov    (%eax),%eax
  105439:	83 e0 01             	and    $0x1,%eax
  10543c:	85 c0                	test   %eax,%eax
  10543e:	74 3e                	je     10547e <page_insert+0x88>
    {
        struct Page *p = pte2page(*ptep);
  105440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105443:	8b 00                	mov    (%eax),%eax
  105445:	89 04 24             	mov    %eax,(%esp)
  105448:	e8 6c f4 ff ff       	call   1048b9 <pte2page>
  10544d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
  105450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105453:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105456:	75 0d                	jne    105465 <page_insert+0x6f>
        {
            page_ref_dec(page);
  105458:	8b 45 0c             	mov    0xc(%ebp),%eax
  10545b:	89 04 24             	mov    %eax,(%esp)
  10545e:	e8 df f4 ff ff       	call   104942 <page_ref_dec>
  105463:	eb 19                	jmp    10547e <page_insert+0x88>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
  105465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105468:	89 44 24 08          	mov    %eax,0x8(%esp)
  10546c:	8b 45 10             	mov    0x10(%ebp),%eax
  10546f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105473:	8b 45 08             	mov    0x8(%ebp),%eax
  105476:	89 04 24             	mov    %eax,(%esp)
  105479:	e8 cd fe ff ff       	call   10534b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10547e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105481:	89 04 24             	mov    %eax,(%esp)
  105484:	e8 71 f3 ff ff       	call   1047fa <page2pa>
  105489:	0b 45 14             	or     0x14(%ebp),%eax
  10548c:	83 c8 01             	or     $0x1,%eax
  10548f:	89 c2                	mov    %eax,%edx
  105491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105494:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  105496:	8b 45 10             	mov    0x10(%ebp),%eax
  105499:	89 44 24 04          	mov    %eax,0x4(%esp)
  10549d:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a0:	89 04 24             	mov    %eax,(%esp)
  1054a3:	e8 09 00 00 00       	call   1054b1 <tlb_invalidate>
    return 0;
  1054a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1054ad:	89 ec                	mov    %ebp,%esp
  1054af:	5d                   	pop    %ebp
  1054b0:	c3                   	ret    

001054b1 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
  1054b1:	55                   	push   %ebp
  1054b2:	89 e5                	mov    %esp,%ebp
  1054b4:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
  1054b7:	0f 20 d8             	mov    %cr3,%eax
  1054ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
  1054bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
  1054c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1054cd:	77 23                	ja     1054f2 <tlb_invalidate+0x41>
  1054cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1054d6:	c7 44 24 08 e8 7a 10 	movl   $0x107ae8,0x8(%esp)
  1054dd:	00 
  1054de:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1054e5:	00 
  1054e6:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1054ed:	e8 f8 b7 ff ff       	call   100cea <__panic>
  1054f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054f5:	05 00 00 00 40       	add    $0x40000000,%eax
  1054fa:	39 d0                	cmp    %edx,%eax
  1054fc:	75 0d                	jne    10550b <tlb_invalidate+0x5a>
    {
        invlpg((void *)la);
  1054fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105501:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
  105504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105507:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
  10550a:	90                   	nop
    }
}
  10550b:	90                   	nop
  10550c:	89 ec                	mov    %ebp,%esp
  10550e:	5d                   	pop    %ebp
  10550f:	c3                   	ret    

00105510 <check_alloc_page>:

static void
check_alloc_page(void)
{
  105510:	55                   	push   %ebp
  105511:	89 e5                	mov    %esp,%ebp
  105513:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  105516:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  10551b:	8b 40 18             	mov    0x18(%eax),%eax
  10551e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  105520:	c7 04 24 6c 7b 10 00 	movl   $0x107b6c,(%esp)
  105527:	e8 39 ae ff ff       	call   100365 <cprintf>
}
  10552c:	90                   	nop
  10552d:	89 ec                	mov    %ebp,%esp
  10552f:	5d                   	pop    %ebp
  105530:	c3                   	ret    

00105531 <check_pgdir>:

static void
check_pgdir(void)
{
  105531:	55                   	push   %ebp
  105532:	89 e5                	mov    %esp,%ebp
  105534:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  105537:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  10553c:	3d 00 80 03 00       	cmp    $0x38000,%eax
  105541:	76 24                	jbe    105567 <check_pgdir+0x36>
  105543:	c7 44 24 0c 8b 7b 10 	movl   $0x107b8b,0xc(%esp)
  10554a:	00 
  10554b:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105552:	00 
  105553:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  10555a:	00 
  10555b:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105562:	e8 83 b7 ff ff       	call   100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  105567:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10556c:	85 c0                	test   %eax,%eax
  10556e:	74 0e                	je     10557e <check_pgdir+0x4d>
  105570:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105575:	25 ff 0f 00 00       	and    $0xfff,%eax
  10557a:	85 c0                	test   %eax,%eax
  10557c:	74 24                	je     1055a2 <check_pgdir+0x71>
  10557e:	c7 44 24 0c a8 7b 10 	movl   $0x107ba8,0xc(%esp)
  105585:	00 
  105586:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10558d:	00 
  10558e:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  105595:	00 
  105596:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10559d:	e8 48 b7 ff ff       	call   100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1055a2:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1055a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1055ae:	00 
  1055af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1055b6:	00 
  1055b7:	89 04 24             	mov    %eax,(%esp)
  1055ba:	e8 31 fd ff ff       	call   1052f0 <get_page>
  1055bf:	85 c0                	test   %eax,%eax
  1055c1:	74 24                	je     1055e7 <check_pgdir+0xb6>
  1055c3:	c7 44 24 0c e0 7b 10 	movl   $0x107be0,0xc(%esp)
  1055ca:	00 
  1055cb:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1055d2:	00 
  1055d3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  1055da:	00 
  1055db:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1055e2:	e8 03 b7 ff ff       	call   100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1055e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055ee:	e8 30 f5 ff ff       	call   104b23 <alloc_pages>
  1055f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1055f6:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1055fb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105602:	00 
  105603:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10560a:	00 
  10560b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10560e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105612:	89 04 24             	mov    %eax,(%esp)
  105615:	e8 dc fd ff ff       	call   1053f6 <page_insert>
  10561a:	85 c0                	test   %eax,%eax
  10561c:	74 24                	je     105642 <check_pgdir+0x111>
  10561e:	c7 44 24 0c 08 7c 10 	movl   $0x107c08,0xc(%esp)
  105625:	00 
  105626:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10562d:	00 
  10562e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  105635:	00 
  105636:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10563d:	e8 a8 b6 ff ff       	call   100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  105642:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105647:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10564e:	00 
  10564f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105656:	00 
  105657:	89 04 24             	mov    %eax,(%esp)
  10565a:	e8 56 fb ff ff       	call   1051b5 <get_pte>
  10565f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105666:	75 24                	jne    10568c <check_pgdir+0x15b>
  105668:	c7 44 24 0c 34 7c 10 	movl   $0x107c34,0xc(%esp)
  10566f:	00 
  105670:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105677:	00 
  105678:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  10567f:	00 
  105680:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105687:	e8 5e b6 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  10568c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10568f:	8b 00                	mov    (%eax),%eax
  105691:	89 04 24             	mov    %eax,(%esp)
  105694:	e8 20 f2 ff ff       	call   1048b9 <pte2page>
  105699:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10569c:	74 24                	je     1056c2 <check_pgdir+0x191>
  10569e:	c7 44 24 0c 61 7c 10 	movl   $0x107c61,0xc(%esp)
  1056a5:	00 
  1056a6:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1056ad:	00 
  1056ae:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  1056b5:	00 
  1056b6:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1056bd:	e8 28 b6 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 1);
  1056c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056c5:	89 04 24             	mov    %eax,(%esp)
  1056c8:	e8 46 f2 ff ff       	call   104913 <page_ref>
  1056cd:	83 f8 01             	cmp    $0x1,%eax
  1056d0:	74 24                	je     1056f6 <check_pgdir+0x1c5>
  1056d2:	c7 44 24 0c 77 7c 10 	movl   $0x107c77,0xc(%esp)
  1056d9:	00 
  1056da:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1056e1:	00 
  1056e2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  1056e9:	00 
  1056ea:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1056f1:	e8 f4 b5 ff ff       	call   100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1056f6:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1056fb:	8b 00                	mov    (%eax),%eax
  1056fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105702:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105708:	c1 e8 0c             	shr    $0xc,%eax
  10570b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10570e:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105713:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105716:	72 23                	jb     10573b <check_pgdir+0x20a>
  105718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10571b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10571f:	c7 44 24 08 44 7a 10 	movl   $0x107a44,0x8(%esp)
  105726:	00 
  105727:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  10572e:	00 
  10572f:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105736:	e8 af b5 ff ff       	call   100cea <__panic>
  10573b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10573e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105743:	83 c0 04             	add    $0x4,%eax
  105746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  105749:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10574e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105755:	00 
  105756:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10575d:	00 
  10575e:	89 04 24             	mov    %eax,(%esp)
  105761:	e8 4f fa ff ff       	call   1051b5 <get_pte>
  105766:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  105769:	74 24                	je     10578f <check_pgdir+0x25e>
  10576b:	c7 44 24 0c 8c 7c 10 	movl   $0x107c8c,0xc(%esp)
  105772:	00 
  105773:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10577a:	00 
  10577b:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  105782:	00 
  105783:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10578a:	e8 5b b5 ff ff       	call   100cea <__panic>

    p2 = alloc_page();
  10578f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105796:	e8 88 f3 ff ff       	call   104b23 <alloc_pages>
  10579b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10579e:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1057a3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1057aa:	00 
  1057ab:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1057b2:	00 
  1057b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ba:	89 04 24             	mov    %eax,(%esp)
  1057bd:	e8 34 fc ff ff       	call   1053f6 <page_insert>
  1057c2:	85 c0                	test   %eax,%eax
  1057c4:	74 24                	je     1057ea <check_pgdir+0x2b9>
  1057c6:	c7 44 24 0c b4 7c 10 	movl   $0x107cb4,0xc(%esp)
  1057cd:	00 
  1057ce:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1057d5:	00 
  1057d6:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  1057dd:	00 
  1057de:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1057e5:	e8 00 b5 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1057ea:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1057ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1057f6:	00 
  1057f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1057fe:	00 
  1057ff:	89 04 24             	mov    %eax,(%esp)
  105802:	e8 ae f9 ff ff       	call   1051b5 <get_pte>
  105807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10580a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10580e:	75 24                	jne    105834 <check_pgdir+0x303>
  105810:	c7 44 24 0c ec 7c 10 	movl   $0x107cec,0xc(%esp)
  105817:	00 
  105818:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10581f:	00 
  105820:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  105827:	00 
  105828:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10582f:	e8 b6 b4 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_U);
  105834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105837:	8b 00                	mov    (%eax),%eax
  105839:	83 e0 04             	and    $0x4,%eax
  10583c:	85 c0                	test   %eax,%eax
  10583e:	75 24                	jne    105864 <check_pgdir+0x333>
  105840:	c7 44 24 0c 1c 7d 10 	movl   $0x107d1c,0xc(%esp)
  105847:	00 
  105848:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10584f:	00 
  105850:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  105857:	00 
  105858:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10585f:	e8 86 b4 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_W);
  105864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105867:	8b 00                	mov    (%eax),%eax
  105869:	83 e0 02             	and    $0x2,%eax
  10586c:	85 c0                	test   %eax,%eax
  10586e:	75 24                	jne    105894 <check_pgdir+0x363>
  105870:	c7 44 24 0c 2a 7d 10 	movl   $0x107d2a,0xc(%esp)
  105877:	00 
  105878:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  10587f:	00 
  105880:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  105887:	00 
  105888:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  10588f:	e8 56 b4 ff ff       	call   100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
  105894:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105899:	8b 00                	mov    (%eax),%eax
  10589b:	83 e0 04             	and    $0x4,%eax
  10589e:	85 c0                	test   %eax,%eax
  1058a0:	75 24                	jne    1058c6 <check_pgdir+0x395>
  1058a2:	c7 44 24 0c 38 7d 10 	movl   $0x107d38,0xc(%esp)
  1058a9:	00 
  1058aa:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1058b1:	00 
  1058b2:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  1058b9:	00 
  1058ba:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1058c1:	e8 24 b4 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 1);
  1058c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058c9:	89 04 24             	mov    %eax,(%esp)
  1058cc:	e8 42 f0 ff ff       	call   104913 <page_ref>
  1058d1:	83 f8 01             	cmp    $0x1,%eax
  1058d4:	74 24                	je     1058fa <check_pgdir+0x3c9>
  1058d6:	c7 44 24 0c 4e 7d 10 	movl   $0x107d4e,0xc(%esp)
  1058dd:	00 
  1058de:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1058e5:	00 
  1058e6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  1058ed:	00 
  1058ee:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1058f5:	e8 f0 b3 ff ff       	call   100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1058fa:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1058ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105906:	00 
  105907:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10590e:	00 
  10590f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105912:	89 54 24 04          	mov    %edx,0x4(%esp)
  105916:	89 04 24             	mov    %eax,(%esp)
  105919:	e8 d8 fa ff ff       	call   1053f6 <page_insert>
  10591e:	85 c0                	test   %eax,%eax
  105920:	74 24                	je     105946 <check_pgdir+0x415>
  105922:	c7 44 24 0c 60 7d 10 	movl   $0x107d60,0xc(%esp)
  105929:	00 
  10592a:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105931:	00 
  105932:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  105939:	00 
  10593a:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105941:	e8 a4 b3 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 2);
  105946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105949:	89 04 24             	mov    %eax,(%esp)
  10594c:	e8 c2 ef ff ff       	call   104913 <page_ref>
  105951:	83 f8 02             	cmp    $0x2,%eax
  105954:	74 24                	je     10597a <check_pgdir+0x449>
  105956:	c7 44 24 0c 8c 7d 10 	movl   $0x107d8c,0xc(%esp)
  10595d:	00 
  10595e:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105965:	00 
  105966:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  10596d:	00 
  10596e:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105975:	e8 70 b3 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  10597a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10597d:	89 04 24             	mov    %eax,(%esp)
  105980:	e8 8e ef ff ff       	call   104913 <page_ref>
  105985:	85 c0                	test   %eax,%eax
  105987:	74 24                	je     1059ad <check_pgdir+0x47c>
  105989:	c7 44 24 0c 9e 7d 10 	movl   $0x107d9e,0xc(%esp)
  105990:	00 
  105991:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105998:	00 
  105999:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  1059a0:	00 
  1059a1:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1059a8:	e8 3d b3 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1059ad:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1059b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1059b9:	00 
  1059ba:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1059c1:	00 
  1059c2:	89 04 24             	mov    %eax,(%esp)
  1059c5:	e8 eb f7 ff ff       	call   1051b5 <get_pte>
  1059ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1059d1:	75 24                	jne    1059f7 <check_pgdir+0x4c6>
  1059d3:	c7 44 24 0c ec 7c 10 	movl   $0x107cec,0xc(%esp)
  1059da:	00 
  1059db:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  1059e2:	00 
  1059e3:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  1059ea:	00 
  1059eb:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  1059f2:	e8 f3 b2 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  1059f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059fa:	8b 00                	mov    (%eax),%eax
  1059fc:	89 04 24             	mov    %eax,(%esp)
  1059ff:	e8 b5 ee ff ff       	call   1048b9 <pte2page>
  105a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105a07:	74 24                	je     105a2d <check_pgdir+0x4fc>
  105a09:	c7 44 24 0c 61 7c 10 	movl   $0x107c61,0xc(%esp)
  105a10:	00 
  105a11:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105a18:	00 
  105a19:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  105a20:	00 
  105a21:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105a28:	e8 bd b2 ff ff       	call   100cea <__panic>
    assert((*ptep & PTE_U) == 0);
  105a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a30:	8b 00                	mov    (%eax),%eax
  105a32:	83 e0 04             	and    $0x4,%eax
  105a35:	85 c0                	test   %eax,%eax
  105a37:	74 24                	je     105a5d <check_pgdir+0x52c>
  105a39:	c7 44 24 0c b0 7d 10 	movl   $0x107db0,0xc(%esp)
  105a40:	00 
  105a41:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105a48:	00 
  105a49:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  105a50:	00 
  105a51:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105a58:	e8 8d b2 ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, 0x0);
  105a5d:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105a62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105a69:	00 
  105a6a:	89 04 24             	mov    %eax,(%esp)
  105a6d:	e8 3d f9 ff ff       	call   1053af <page_remove>
    assert(page_ref(p1) == 1);
  105a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a75:	89 04 24             	mov    %eax,(%esp)
  105a78:	e8 96 ee ff ff       	call   104913 <page_ref>
  105a7d:	83 f8 01             	cmp    $0x1,%eax
  105a80:	74 24                	je     105aa6 <check_pgdir+0x575>
  105a82:	c7 44 24 0c 77 7c 10 	movl   $0x107c77,0xc(%esp)
  105a89:	00 
  105a8a:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105a91:	00 
  105a92:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  105a99:	00 
  105a9a:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105aa1:	e8 44 b2 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  105aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105aa9:	89 04 24             	mov    %eax,(%esp)
  105aac:	e8 62 ee ff ff       	call   104913 <page_ref>
  105ab1:	85 c0                	test   %eax,%eax
  105ab3:	74 24                	je     105ad9 <check_pgdir+0x5a8>
  105ab5:	c7 44 24 0c 9e 7d 10 	movl   $0x107d9e,0xc(%esp)
  105abc:	00 
  105abd:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105ac4:	00 
  105ac5:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105acc:	00 
  105acd:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105ad4:	e8 11 b2 ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
  105ad9:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105ade:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105ae5:	00 
  105ae6:	89 04 24             	mov    %eax,(%esp)
  105ae9:	e8 c1 f8 ff ff       	call   1053af <page_remove>
    assert(page_ref(p1) == 0);
  105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105af1:	89 04 24             	mov    %eax,(%esp)
  105af4:	e8 1a ee ff ff       	call   104913 <page_ref>
  105af9:	85 c0                	test   %eax,%eax
  105afb:	74 24                	je     105b21 <check_pgdir+0x5f0>
  105afd:	c7 44 24 0c c5 7d 10 	movl   $0x107dc5,0xc(%esp)
  105b04:	00 
  105b05:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105b0c:	00 
  105b0d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105b14:	00 
  105b15:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105b1c:	e8 c9 b1 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  105b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b24:	89 04 24             	mov    %eax,(%esp)
  105b27:	e8 e7 ed ff ff       	call   104913 <page_ref>
  105b2c:	85 c0                	test   %eax,%eax
  105b2e:	74 24                	je     105b54 <check_pgdir+0x623>
  105b30:	c7 44 24 0c 9e 7d 10 	movl   $0x107d9e,0xc(%esp)
  105b37:	00 
  105b38:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105b3f:	00 
  105b40:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  105b47:	00 
  105b48:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105b4f:	e8 96 b1 ff ff       	call   100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  105b54:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105b59:	8b 00                	mov    (%eax),%eax
  105b5b:	89 04 24             	mov    %eax,(%esp)
  105b5e:	e8 96 ed ff ff       	call   1048f9 <pde2page>
  105b63:	89 04 24             	mov    %eax,(%esp)
  105b66:	e8 a8 ed ff ff       	call   104913 <page_ref>
  105b6b:	83 f8 01             	cmp    $0x1,%eax
  105b6e:	74 24                	je     105b94 <check_pgdir+0x663>
  105b70:	c7 44 24 0c d8 7d 10 	movl   $0x107dd8,0xc(%esp)
  105b77:	00 
  105b78:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105b7f:	00 
  105b80:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  105b87:	00 
  105b88:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105b8f:	e8 56 b1 ff ff       	call   100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
  105b94:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105b99:	8b 00                	mov    (%eax),%eax
  105b9b:	89 04 24             	mov    %eax,(%esp)
  105b9e:	e8 56 ed ff ff       	call   1048f9 <pde2page>
  105ba3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105baa:	00 
  105bab:	89 04 24             	mov    %eax,(%esp)
  105bae:	e8 aa ef ff ff       	call   104b5d <free_pages>
    boot_pgdir[0] = 0;
  105bb3:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105bbe:	c7 04 24 ff 7d 10 00 	movl   $0x107dff,(%esp)
  105bc5:	e8 9b a7 ff ff       	call   100365 <cprintf>
}
  105bca:	90                   	nop
  105bcb:	89 ec                	mov    %ebp,%esp
  105bcd:	5d                   	pop    %ebp
  105bce:	c3                   	ret    

00105bcf <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
  105bcf:	55                   	push   %ebp
  105bd0:	89 e5                	mov    %esp,%ebp
  105bd2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
  105bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105bdc:	e9 ca 00 00 00       	jmp    105cab <check_boot_pgdir+0xdc>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bea:	c1 e8 0c             	shr    $0xc,%eax
  105bed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105bf0:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105bf5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105bf8:	72 23                	jb     105c1d <check_boot_pgdir+0x4e>
  105bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c01:	c7 44 24 08 44 7a 10 	movl   $0x107a44,0x8(%esp)
  105c08:	00 
  105c09:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105c10:	00 
  105c11:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105c18:	e8 cd b0 ff ff       	call   100cea <__panic>
  105c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c20:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105c25:	89 c2                	mov    %eax,%edx
  105c27:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c2c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105c33:	00 
  105c34:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c38:	89 04 24             	mov    %eax,(%esp)
  105c3b:	e8 75 f5 ff ff       	call   1051b5 <get_pte>
  105c40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105c43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105c47:	75 24                	jne    105c6d <check_boot_pgdir+0x9e>
  105c49:	c7 44 24 0c 1c 7e 10 	movl   $0x107e1c,0xc(%esp)
  105c50:	00 
  105c51:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105c58:	00 
  105c59:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105c60:	00 
  105c61:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105c68:	e8 7d b0 ff ff       	call   100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105c6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c70:	8b 00                	mov    (%eax),%eax
  105c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105c77:	89 c2                	mov    %eax,%edx
  105c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c7c:	39 c2                	cmp    %eax,%edx
  105c7e:	74 24                	je     105ca4 <check_boot_pgdir+0xd5>
  105c80:	c7 44 24 0c 59 7e 10 	movl   $0x107e59,0xc(%esp)
  105c87:	00 
  105c88:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105c8f:	00 
  105c90:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
  105c97:	00 
  105c98:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105c9f:	e8 46 b0 ff ff       	call   100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE)
  105ca4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105cae:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105cb3:	39 c2                	cmp    %eax,%edx
  105cb5:	0f 82 26 ff ff ff    	jb     105be1 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105cbb:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105cc0:	05 ac 0f 00 00       	add    $0xfac,%eax
  105cc5:	8b 00                	mov    (%eax),%eax
  105cc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105ccc:	89 c2                	mov    %eax,%edx
  105cce:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cd6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105cdd:	77 23                	ja     105d02 <check_boot_pgdir+0x133>
  105cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ce6:	c7 44 24 08 e8 7a 10 	movl   $0x107ae8,0x8(%esp)
  105ced:	00 
  105cee:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
  105cf5:	00 
  105cf6:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105cfd:	e8 e8 af ff ff       	call   100cea <__panic>
  105d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d05:	05 00 00 00 40       	add    $0x40000000,%eax
  105d0a:	39 d0                	cmp    %edx,%eax
  105d0c:	74 24                	je     105d32 <check_boot_pgdir+0x163>
  105d0e:	c7 44 24 0c 70 7e 10 	movl   $0x107e70,0xc(%esp)
  105d15:	00 
  105d16:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105d1d:	00 
  105d1e:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
  105d25:	00 
  105d26:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105d2d:	e8 b8 af ff ff       	call   100cea <__panic>

    assert(boot_pgdir[0] == 0);
  105d32:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d37:	8b 00                	mov    (%eax),%eax
  105d39:	85 c0                	test   %eax,%eax
  105d3b:	74 24                	je     105d61 <check_boot_pgdir+0x192>
  105d3d:	c7 44 24 0c a4 7e 10 	movl   $0x107ea4,0xc(%esp)
  105d44:	00 
  105d45:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105d4c:	00 
  105d4d:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
  105d54:	00 
  105d55:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105d5c:	e8 89 af ff ff       	call   100cea <__panic>

    struct Page *p;
    p = alloc_page();
  105d61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105d68:	e8 b6 ed ff ff       	call   104b23 <alloc_pages>
  105d6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105d70:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d75:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105d7c:	00 
  105d7d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105d84:	00 
  105d85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d88:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d8c:	89 04 24             	mov    %eax,(%esp)
  105d8f:	e8 62 f6 ff ff       	call   1053f6 <page_insert>
  105d94:	85 c0                	test   %eax,%eax
  105d96:	74 24                	je     105dbc <check_boot_pgdir+0x1ed>
  105d98:	c7 44 24 0c b8 7e 10 	movl   $0x107eb8,0xc(%esp)
  105d9f:	00 
  105da0:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105da7:	00 
  105da8:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
  105daf:	00 
  105db0:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105db7:	e8 2e af ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 1);
  105dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dbf:	89 04 24             	mov    %eax,(%esp)
  105dc2:	e8 4c eb ff ff       	call   104913 <page_ref>
  105dc7:	83 f8 01             	cmp    $0x1,%eax
  105dca:	74 24                	je     105df0 <check_boot_pgdir+0x221>
  105dcc:	c7 44 24 0c e6 7e 10 	movl   $0x107ee6,0xc(%esp)
  105dd3:	00 
  105dd4:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105ddb:	00 
  105ddc:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
  105de3:	00 
  105de4:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105deb:	e8 fa ae ff ff       	call   100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105df0:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105df5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105dfc:	00 
  105dfd:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105e04:	00 
  105e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e08:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e0c:	89 04 24             	mov    %eax,(%esp)
  105e0f:	e8 e2 f5 ff ff       	call   1053f6 <page_insert>
  105e14:	85 c0                	test   %eax,%eax
  105e16:	74 24                	je     105e3c <check_boot_pgdir+0x26d>
  105e18:	c7 44 24 0c f8 7e 10 	movl   $0x107ef8,0xc(%esp)
  105e1f:	00 
  105e20:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105e27:	00 
  105e28:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
  105e2f:	00 
  105e30:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105e37:	e8 ae ae ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 2);
  105e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e3f:	89 04 24             	mov    %eax,(%esp)
  105e42:	e8 cc ea ff ff       	call   104913 <page_ref>
  105e47:	83 f8 02             	cmp    $0x2,%eax
  105e4a:	74 24                	je     105e70 <check_boot_pgdir+0x2a1>
  105e4c:	c7 44 24 0c 2f 7f 10 	movl   $0x107f2f,0xc(%esp)
  105e53:	00 
  105e54:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105e5b:	00 
  105e5c:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
  105e63:	00 
  105e64:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105e6b:	e8 7a ae ff ff       	call   100cea <__panic>

    const char *str = "ucore: Hello world!!";
  105e70:	c7 45 e8 40 7f 10 00 	movl   $0x107f40,-0x18(%ebp)
    strcpy((void *)0x100, str);
  105e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e7e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105e85:	e8 fc 09 00 00       	call   106886 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105e8a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105e91:	00 
  105e92:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105e99:	e8 60 0a 00 00       	call   1068fe <strcmp>
  105e9e:	85 c0                	test   %eax,%eax
  105ea0:	74 24                	je     105ec6 <check_boot_pgdir+0x2f7>
  105ea2:	c7 44 24 0c 58 7f 10 	movl   $0x107f58,0xc(%esp)
  105ea9:	00 
  105eaa:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105eb1:	00 
  105eb2:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
  105eb9:	00 
  105eba:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105ec1:	e8 24 ae ff ff       	call   100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ec9:	89 04 24             	mov    %eax,(%esp)
  105ecc:	e8 92 e9 ff ff       	call   104863 <page2kva>
  105ed1:	05 00 01 00 00       	add    $0x100,%eax
  105ed6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105ed9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105ee0:	e8 47 09 00 00       	call   10682c <strlen>
  105ee5:	85 c0                	test   %eax,%eax
  105ee7:	74 24                	je     105f0d <check_boot_pgdir+0x33e>
  105ee9:	c7 44 24 0c 90 7f 10 	movl   $0x107f90,0xc(%esp)
  105ef0:	00 
  105ef1:	c7 44 24 08 31 7b 10 	movl   $0x107b31,0x8(%esp)
  105ef8:	00 
  105ef9:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
  105f00:	00 
  105f01:	c7 04 24 0c 7b 10 00 	movl   $0x107b0c,(%esp)
  105f08:	e8 dd ad ff ff       	call   100cea <__panic>

    free_page(p);
  105f0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105f14:	00 
  105f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f18:	89 04 24             	mov    %eax,(%esp)
  105f1b:	e8 3d ec ff ff       	call   104b5d <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105f20:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105f25:	8b 00                	mov    (%eax),%eax
  105f27:	89 04 24             	mov    %eax,(%esp)
  105f2a:	e8 ca e9 ff ff       	call   1048f9 <pde2page>
  105f2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105f36:	00 
  105f37:	89 04 24             	mov    %eax,(%esp)
  105f3a:	e8 1e ec ff ff       	call   104b5d <free_pages>
    boot_pgdir[0] = 0;
  105f3f:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105f4a:	c7 04 24 b4 7f 10 00 	movl   $0x107fb4,(%esp)
  105f51:	e8 0f a4 ff ff       	call   100365 <cprintf>
}
  105f56:	90                   	nop
  105f57:	89 ec                	mov    %ebp,%esp
  105f59:	5d                   	pop    %ebp
  105f5a:	c3                   	ret    

00105f5b <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
  105f5b:	55                   	push   %ebp
  105f5c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f61:	83 e0 04             	and    $0x4,%eax
  105f64:	85 c0                	test   %eax,%eax
  105f66:	74 04                	je     105f6c <perm2str+0x11>
  105f68:	b0 75                	mov    $0x75,%al
  105f6a:	eb 02                	jmp    105f6e <perm2str+0x13>
  105f6c:	b0 2d                	mov    $0x2d,%al
  105f6e:	a2 28 ef 11 00       	mov    %al,0x11ef28
    str[1] = 'r';
  105f73:	c6 05 29 ef 11 00 72 	movb   $0x72,0x11ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f7d:	83 e0 02             	and    $0x2,%eax
  105f80:	85 c0                	test   %eax,%eax
  105f82:	74 04                	je     105f88 <perm2str+0x2d>
  105f84:	b0 77                	mov    $0x77,%al
  105f86:	eb 02                	jmp    105f8a <perm2str+0x2f>
  105f88:	b0 2d                	mov    $0x2d,%al
  105f8a:	a2 2a ef 11 00       	mov    %al,0x11ef2a
    str[3] = '\0';
  105f8f:	c6 05 2b ef 11 00 00 	movb   $0x0,0x11ef2b
    return str;
  105f96:	b8 28 ef 11 00       	mov    $0x11ef28,%eax
}
  105f9b:	5d                   	pop    %ebp
  105f9c:	c3                   	ret    

00105f9d <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
  105f9d:	55                   	push   %ebp
  105f9e:	89 e5                	mov    %esp,%ebp
  105fa0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
  105fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  105fa6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105fa9:	72 0d                	jb     105fb8 <get_pgtable_items+0x1b>
    {
        return 0;
  105fab:	b8 00 00 00 00       	mov    $0x0,%eax
  105fb0:	e9 98 00 00 00       	jmp    10604d <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
  105fb5:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
  105fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  105fbb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105fbe:	73 18                	jae    105fd8 <get_pgtable_items+0x3b>
  105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  105fc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105fca:	8b 45 14             	mov    0x14(%ebp),%eax
  105fcd:	01 d0                	add    %edx,%eax
  105fcf:	8b 00                	mov    (%eax),%eax
  105fd1:	83 e0 01             	and    $0x1,%eax
  105fd4:	85 c0                	test   %eax,%eax
  105fd6:	74 dd                	je     105fb5 <get_pgtable_items+0x18>
    }
    if (start < right)
  105fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  105fdb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105fde:	73 68                	jae    106048 <get_pgtable_items+0xab>
    {
        if (left_store != NULL)
  105fe0:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105fe4:	74 08                	je     105fee <get_pgtable_items+0x51>
        {
            *left_store = start;
  105fe6:	8b 45 18             	mov    0x18(%ebp),%eax
  105fe9:	8b 55 10             	mov    0x10(%ebp),%edx
  105fec:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
  105fee:	8b 45 10             	mov    0x10(%ebp),%eax
  105ff1:	8d 50 01             	lea    0x1(%eax),%edx
  105ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  105ff7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  106001:	01 d0                	add    %edx,%eax
  106003:	8b 00                	mov    (%eax),%eax
  106005:	83 e0 07             	and    $0x7,%eax
  106008:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  10600b:	eb 03                	jmp    106010 <get_pgtable_items+0x73>
        {
            start++;
  10600d:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  106010:	8b 45 10             	mov    0x10(%ebp),%eax
  106013:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106016:	73 1d                	jae    106035 <get_pgtable_items+0x98>
  106018:	8b 45 10             	mov    0x10(%ebp),%eax
  10601b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106022:	8b 45 14             	mov    0x14(%ebp),%eax
  106025:	01 d0                	add    %edx,%eax
  106027:	8b 00                	mov    (%eax),%eax
  106029:	83 e0 07             	and    $0x7,%eax
  10602c:	89 c2                	mov    %eax,%edx
  10602e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106031:	39 c2                	cmp    %eax,%edx
  106033:	74 d8                	je     10600d <get_pgtable_items+0x70>
        }
        if (right_store != NULL)
  106035:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106039:	74 08                	je     106043 <get_pgtable_items+0xa6>
        {
            *right_store = start;
  10603b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10603e:	8b 55 10             	mov    0x10(%ebp),%edx
  106041:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  106043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106046:	eb 05                	jmp    10604d <get_pgtable_items+0xb0>
    }
    return 0;
  106048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10604d:	89 ec                	mov    %ebp,%esp
  10604f:	5d                   	pop    %ebp
  106050:	c3                   	ret    

00106051 <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
  106051:	55                   	push   %ebp
  106052:	89 e5                	mov    %esp,%ebp
  106054:	57                   	push   %edi
  106055:	56                   	push   %esi
  106056:	53                   	push   %ebx
  106057:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10605a:	c7 04 24 d4 7f 10 00 	movl   $0x107fd4,(%esp)
  106061:	e8 ff a2 ff ff       	call   100365 <cprintf>
    size_t left, right = 0, perm;
  106066:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  10606d:	e9 f2 00 00 00       	jmp    106164 <print_pgdir+0x113>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106075:	89 04 24             	mov    %eax,(%esp)
  106078:	e8 de fe ff ff       	call   105f5b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10607d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106080:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  106083:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106085:	89 d6                	mov    %edx,%esi
  106087:	c1 e6 16             	shl    $0x16,%esi
  10608a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10608d:	89 d3                	mov    %edx,%ebx
  10608f:	c1 e3 16             	shl    $0x16,%ebx
  106092:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106095:	89 d1                	mov    %edx,%ecx
  106097:	c1 e1 16             	shl    $0x16,%ecx
  10609a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10609d:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1060a0:	29 fa                	sub    %edi,%edx
  1060a2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1060a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1060aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1060ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1060b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1060b6:	c7 04 24 05 80 10 00 	movl   $0x108005,(%esp)
  1060bd:	e8 a3 a2 ff ff       	call   100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1060c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1060c5:	c1 e0 0a             	shl    $0xa,%eax
  1060c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  1060cb:	eb 50                	jmp    10611d <print_pgdir+0xcc>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1060cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060d0:	89 04 24             	mov    %eax,(%esp)
  1060d3:	e8 83 fe ff ff       	call   105f5b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1060d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1060db:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  1060de:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1060e0:	89 d6                	mov    %edx,%esi
  1060e2:	c1 e6 0c             	shl    $0xc,%esi
  1060e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1060e8:	89 d3                	mov    %edx,%ebx
  1060ea:	c1 e3 0c             	shl    $0xc,%ebx
  1060ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1060f0:	89 d1                	mov    %edx,%ecx
  1060f2:	c1 e1 0c             	shl    $0xc,%ecx
  1060f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1060f8:	8b 7d d8             	mov    -0x28(%ebp),%edi
  1060fb:	29 fa                	sub    %edi,%edx
  1060fd:	89 44 24 14          	mov    %eax,0x14(%esp)
  106101:	89 74 24 10          	mov    %esi,0x10(%esp)
  106105:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106109:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10610d:	89 54 24 04          	mov    %edx,0x4(%esp)
  106111:	c7 04 24 24 80 10 00 	movl   $0x108024,(%esp)
  106118:	e8 48 a2 ff ff       	call   100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  10611d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  106122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106125:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106128:	89 d3                	mov    %edx,%ebx
  10612a:	c1 e3 0a             	shl    $0xa,%ebx
  10612d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106130:	89 d1                	mov    %edx,%ecx
  106132:	c1 e1 0a             	shl    $0xa,%ecx
  106135:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  106138:	89 54 24 14          	mov    %edx,0x14(%esp)
  10613c:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10613f:	89 54 24 10          	mov    %edx,0x10(%esp)
  106143:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106147:	89 44 24 08          	mov    %eax,0x8(%esp)
  10614b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10614f:	89 0c 24             	mov    %ecx,(%esp)
  106152:	e8 46 fe ff ff       	call   105f9d <get_pgtable_items>
  106157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10615a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10615e:	0f 85 69 ff ff ff    	jne    1060cd <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  106164:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  106169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10616c:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10616f:	89 54 24 14          	mov    %edx,0x14(%esp)
  106173:	8d 55 e0             	lea    -0x20(%ebp),%edx
  106176:	89 54 24 10          	mov    %edx,0x10(%esp)
  10617a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10617e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106182:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106189:	00 
  10618a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106191:	e8 07 fe ff ff       	call   105f9d <get_pgtable_items>
  106196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106199:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10619d:	0f 85 cf fe ff ff    	jne    106072 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1061a3:	c7 04 24 48 80 10 00 	movl   $0x108048,(%esp)
  1061aa:	e8 b6 a1 ff ff       	call   100365 <cprintf>
}
  1061af:	90                   	nop
  1061b0:	83 c4 4c             	add    $0x4c,%esp
  1061b3:	5b                   	pop    %ebx
  1061b4:	5e                   	pop    %esi
  1061b5:	5f                   	pop    %edi
  1061b6:	5d                   	pop    %ebp
  1061b7:	c3                   	ret    

001061b8 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
  1061b8:	55                   	push   %ebp
  1061b9:	89 e5                	mov    %esp,%ebp
  1061bb:	83 ec 58             	sub    $0x58,%esp
  1061be:	8b 45 10             	mov    0x10(%ebp),%eax
  1061c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1061c4:	8b 45 14             	mov    0x14(%ebp),%eax
  1061c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1061ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1061cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1061d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1061d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1061d6:	8b 45 18             	mov    0x18(%ebp),%eax
  1061d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1061dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1061e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1061e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1061e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1061ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1061f2:	74 1c                	je     106210 <printnum+0x58>
  1061f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061f7:	ba 00 00 00 00       	mov    $0x0,%edx
  1061fc:	f7 75 e4             	divl   -0x1c(%ebp)
  1061ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
  106202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106205:	ba 00 00 00 00       	mov    $0x0,%edx
  10620a:	f7 75 e4             	divl   -0x1c(%ebp)
  10620d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106216:	f7 75 e4             	divl   -0x1c(%ebp)
  106219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10621c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10621f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106222:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106225:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106228:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10622b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10622e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
  106231:	8b 45 18             	mov    0x18(%ebp),%eax
  106234:	ba 00 00 00 00       	mov    $0x0,%edx
  106239:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10623c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10623f:	19 d1                	sbb    %edx,%ecx
  106241:	72 4c                	jb     10628f <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
  106243:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106246:	8d 50 ff             	lea    -0x1(%eax),%edx
  106249:	8b 45 20             	mov    0x20(%ebp),%eax
  10624c:	89 44 24 18          	mov    %eax,0x18(%esp)
  106250:	89 54 24 14          	mov    %edx,0x14(%esp)
  106254:	8b 45 18             	mov    0x18(%ebp),%eax
  106257:	89 44 24 10          	mov    %eax,0x10(%esp)
  10625b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10625e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106261:	89 44 24 08          	mov    %eax,0x8(%esp)
  106265:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106269:	8b 45 0c             	mov    0xc(%ebp),%eax
  10626c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106270:	8b 45 08             	mov    0x8(%ebp),%eax
  106273:	89 04 24             	mov    %eax,(%esp)
  106276:	e8 3d ff ff ff       	call   1061b8 <printnum>
  10627b:	eb 1b                	jmp    106298 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
  10627d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106280:	89 44 24 04          	mov    %eax,0x4(%esp)
  106284:	8b 45 20             	mov    0x20(%ebp),%eax
  106287:	89 04 24             	mov    %eax,(%esp)
  10628a:	8b 45 08             	mov    0x8(%ebp),%eax
  10628d:	ff d0                	call   *%eax
        while (--width > 0)
  10628f:	ff 4d 1c             	decl   0x1c(%ebp)
  106292:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106296:	7f e5                	jg     10627d <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106298:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10629b:	05 fc 80 10 00       	add    $0x1080fc,%eax
  1062a0:	0f b6 00             	movzbl (%eax),%eax
  1062a3:	0f be c0             	movsbl %al,%eax
  1062a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1062a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1062ad:	89 04 24             	mov    %eax,(%esp)
  1062b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1062b3:	ff d0                	call   *%eax
}
  1062b5:	90                   	nop
  1062b6:	89 ec                	mov    %ebp,%esp
  1062b8:	5d                   	pop    %ebp
  1062b9:	c3                   	ret    

001062ba <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
  1062ba:	55                   	push   %ebp
  1062bb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  1062bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1062c1:	7e 14                	jle    1062d7 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
  1062c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1062c6:	8b 00                	mov    (%eax),%eax
  1062c8:	8d 48 08             	lea    0x8(%eax),%ecx
  1062cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1062ce:	89 0a                	mov    %ecx,(%edx)
  1062d0:	8b 50 04             	mov    0x4(%eax),%edx
  1062d3:	8b 00                	mov    (%eax),%eax
  1062d5:	eb 30                	jmp    106307 <getuint+0x4d>
    }
    else if (lflag)
  1062d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1062db:	74 16                	je     1062f3 <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
  1062dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1062e0:	8b 00                	mov    (%eax),%eax
  1062e2:	8d 48 04             	lea    0x4(%eax),%ecx
  1062e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1062e8:	89 0a                	mov    %ecx,(%edx)
  1062ea:	8b 00                	mov    (%eax),%eax
  1062ec:	ba 00 00 00 00       	mov    $0x0,%edx
  1062f1:	eb 14                	jmp    106307 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
  1062f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1062f6:	8b 00                	mov    (%eax),%eax
  1062f8:	8d 48 04             	lea    0x4(%eax),%ecx
  1062fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1062fe:	89 0a                	mov    %ecx,(%edx)
  106300:	8b 00                	mov    (%eax),%eax
  106302:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106307:	5d                   	pop    %ebp
  106308:	c3                   	ret    

00106309 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
  106309:	55                   	push   %ebp
  10630a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  10630c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106310:	7e 14                	jle    106326 <getint+0x1d>
    {
        return va_arg(*ap, long long);
  106312:	8b 45 08             	mov    0x8(%ebp),%eax
  106315:	8b 00                	mov    (%eax),%eax
  106317:	8d 48 08             	lea    0x8(%eax),%ecx
  10631a:	8b 55 08             	mov    0x8(%ebp),%edx
  10631d:	89 0a                	mov    %ecx,(%edx)
  10631f:	8b 50 04             	mov    0x4(%eax),%edx
  106322:	8b 00                	mov    (%eax),%eax
  106324:	eb 28                	jmp    10634e <getint+0x45>
    }
    else if (lflag)
  106326:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10632a:	74 12                	je     10633e <getint+0x35>
    {
        return va_arg(*ap, long);
  10632c:	8b 45 08             	mov    0x8(%ebp),%eax
  10632f:	8b 00                	mov    (%eax),%eax
  106331:	8d 48 04             	lea    0x4(%eax),%ecx
  106334:	8b 55 08             	mov    0x8(%ebp),%edx
  106337:	89 0a                	mov    %ecx,(%edx)
  106339:	8b 00                	mov    (%eax),%eax
  10633b:	99                   	cltd   
  10633c:	eb 10                	jmp    10634e <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
  10633e:	8b 45 08             	mov    0x8(%ebp),%eax
  106341:	8b 00                	mov    (%eax),%eax
  106343:	8d 48 04             	lea    0x4(%eax),%ecx
  106346:	8b 55 08             	mov    0x8(%ebp),%edx
  106349:	89 0a                	mov    %ecx,(%edx)
  10634b:	8b 00                	mov    (%eax),%eax
  10634d:	99                   	cltd   
    }
}
  10634e:	5d                   	pop    %ebp
  10634f:	c3                   	ret    

00106350 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
  106350:	55                   	push   %ebp
  106351:	89 e5                	mov    %esp,%ebp
  106353:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  106356:	8d 45 14             	lea    0x14(%ebp),%eax
  106359:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10635c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10635f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106363:	8b 45 10             	mov    0x10(%ebp),%eax
  106366:	89 44 24 08          	mov    %eax,0x8(%esp)
  10636a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10636d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106371:	8b 45 08             	mov    0x8(%ebp),%eax
  106374:	89 04 24             	mov    %eax,(%esp)
  106377:	e8 05 00 00 00       	call   106381 <vprintfmt>
    va_end(ap);
}
  10637c:	90                   	nop
  10637d:	89 ec                	mov    %ebp,%esp
  10637f:	5d                   	pop    %ebp
  106380:	c3                   	ret    

00106381 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
  106381:	55                   	push   %ebp
  106382:	89 e5                	mov    %esp,%ebp
  106384:	56                   	push   %esi
  106385:	53                   	push   %ebx
  106386:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
  106389:	eb 17                	jmp    1063a2 <vprintfmt+0x21>
        {
            if (ch == '\0')
  10638b:	85 db                	test   %ebx,%ebx
  10638d:	0f 84 bf 03 00 00    	je     106752 <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
  106393:	8b 45 0c             	mov    0xc(%ebp),%eax
  106396:	89 44 24 04          	mov    %eax,0x4(%esp)
  10639a:	89 1c 24             	mov    %ebx,(%esp)
  10639d:	8b 45 08             	mov    0x8(%ebp),%eax
  1063a0:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
  1063a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1063a5:	8d 50 01             	lea    0x1(%eax),%edx
  1063a8:	89 55 10             	mov    %edx,0x10(%ebp)
  1063ab:	0f b6 00             	movzbl (%eax),%eax
  1063ae:	0f b6 d8             	movzbl %al,%ebx
  1063b1:	83 fb 25             	cmp    $0x25,%ebx
  1063b4:	75 d5                	jne    10638b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1063b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1063ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1063c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1063c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1063ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
  1063d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1063d7:	8d 50 01             	lea    0x1(%eax),%edx
  1063da:	89 55 10             	mov    %edx,0x10(%ebp)
  1063dd:	0f b6 00             	movzbl (%eax),%eax
  1063e0:	0f b6 d8             	movzbl %al,%ebx
  1063e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1063e6:	83 f8 55             	cmp    $0x55,%eax
  1063e9:	0f 87 37 03 00 00    	ja     106726 <vprintfmt+0x3a5>
  1063ef:	8b 04 85 20 81 10 00 	mov    0x108120(,%eax,4),%eax
  1063f6:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
  1063f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1063fc:	eb d6                	jmp    1063d4 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1063fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106402:	eb d0                	jmp    1063d4 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
  106404:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
  10640b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10640e:	89 d0                	mov    %edx,%eax
  106410:	c1 e0 02             	shl    $0x2,%eax
  106413:	01 d0                	add    %edx,%eax
  106415:	01 c0                	add    %eax,%eax
  106417:	01 d8                	add    %ebx,%eax
  106419:	83 e8 30             	sub    $0x30,%eax
  10641c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10641f:	8b 45 10             	mov    0x10(%ebp),%eax
  106422:	0f b6 00             	movzbl (%eax),%eax
  106425:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
  106428:	83 fb 2f             	cmp    $0x2f,%ebx
  10642b:	7e 38                	jle    106465 <vprintfmt+0xe4>
  10642d:	83 fb 39             	cmp    $0x39,%ebx
  106430:	7f 33                	jg     106465 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
  106432:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  106435:	eb d4                	jmp    10640b <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  106437:	8b 45 14             	mov    0x14(%ebp),%eax
  10643a:	8d 50 04             	lea    0x4(%eax),%edx
  10643d:	89 55 14             	mov    %edx,0x14(%ebp)
  106440:	8b 00                	mov    (%eax),%eax
  106442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106445:	eb 1f                	jmp    106466 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  106447:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10644b:	79 87                	jns    1063d4 <vprintfmt+0x53>
                width = 0;
  10644d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106454:	e9 7b ff ff ff       	jmp    1063d4 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  106459:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106460:	e9 6f ff ff ff       	jmp    1063d4 <vprintfmt+0x53>
            goto process_precision;
  106465:	90                   	nop

        process_precision:
            if (width < 0)
  106466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10646a:	0f 89 64 ff ff ff    	jns    1063d4 <vprintfmt+0x53>
                width = precision, precision = -1;
  106470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106473:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10647d:	e9 52 ff ff ff       	jmp    1063d4 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
  106482:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  106485:	e9 4a ff ff ff       	jmp    1063d4 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10648a:	8b 45 14             	mov    0x14(%ebp),%eax
  10648d:	8d 50 04             	lea    0x4(%eax),%edx
  106490:	89 55 14             	mov    %edx,0x14(%ebp)
  106493:	8b 00                	mov    (%eax),%eax
  106495:	8b 55 0c             	mov    0xc(%ebp),%edx
  106498:	89 54 24 04          	mov    %edx,0x4(%esp)
  10649c:	89 04 24             	mov    %eax,(%esp)
  10649f:	8b 45 08             	mov    0x8(%ebp),%eax
  1064a2:	ff d0                	call   *%eax
            break;
  1064a4:	e9 a4 02 00 00       	jmp    10674d <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1064a9:	8b 45 14             	mov    0x14(%ebp),%eax
  1064ac:	8d 50 04             	lea    0x4(%eax),%edx
  1064af:	89 55 14             	mov    %edx,0x14(%ebp)
  1064b2:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
  1064b4:	85 db                	test   %ebx,%ebx
  1064b6:	79 02                	jns    1064ba <vprintfmt+0x139>
            {
                err = -err;
  1064b8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
  1064ba:	83 fb 06             	cmp    $0x6,%ebx
  1064bd:	7f 0b                	jg     1064ca <vprintfmt+0x149>
  1064bf:	8b 34 9d e0 80 10 00 	mov    0x1080e0(,%ebx,4),%esi
  1064c6:	85 f6                	test   %esi,%esi
  1064c8:	75 23                	jne    1064ed <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
  1064ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1064ce:	c7 44 24 08 0d 81 10 	movl   $0x10810d,0x8(%esp)
  1064d5:	00 
  1064d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1064e0:	89 04 24             	mov    %eax,(%esp)
  1064e3:	e8 68 fe ff ff       	call   106350 <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1064e8:	e9 60 02 00 00       	jmp    10674d <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1064ed:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1064f1:	c7 44 24 08 16 81 10 	movl   $0x108116,0x8(%esp)
  1064f8:	00 
  1064f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  106500:	8b 45 08             	mov    0x8(%ebp),%eax
  106503:	89 04 24             	mov    %eax,(%esp)
  106506:	e8 45 fe ff ff       	call   106350 <printfmt>
            break;
  10650b:	e9 3d 02 00 00       	jmp    10674d <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
  106510:	8b 45 14             	mov    0x14(%ebp),%eax
  106513:	8d 50 04             	lea    0x4(%eax),%edx
  106516:	89 55 14             	mov    %edx,0x14(%ebp)
  106519:	8b 30                	mov    (%eax),%esi
  10651b:	85 f6                	test   %esi,%esi
  10651d:	75 05                	jne    106524 <vprintfmt+0x1a3>
            {
                p = "(null)";
  10651f:	be 19 81 10 00       	mov    $0x108119,%esi
            }
            if (width > 0 && padc != '-')
  106524:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106528:	7e 76                	jle    1065a0 <vprintfmt+0x21f>
  10652a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10652e:	74 70                	je     1065a0 <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
  106530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106533:	89 44 24 04          	mov    %eax,0x4(%esp)
  106537:	89 34 24             	mov    %esi,(%esp)
  10653a:	e8 16 03 00 00       	call   106855 <strnlen>
  10653f:	89 c2                	mov    %eax,%edx
  106541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106544:	29 d0                	sub    %edx,%eax
  106546:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106549:	eb 16                	jmp    106561 <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
  10654b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10654f:	8b 55 0c             	mov    0xc(%ebp),%edx
  106552:	89 54 24 04          	mov    %edx,0x4(%esp)
  106556:	89 04 24             	mov    %eax,(%esp)
  106559:	8b 45 08             	mov    0x8(%ebp),%eax
  10655c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
  10655e:	ff 4d e8             	decl   -0x18(%ebp)
  106561:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106565:	7f e4                	jg     10654b <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  106567:	eb 37                	jmp    1065a0 <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
  106569:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10656d:	74 1f                	je     10658e <vprintfmt+0x20d>
  10656f:	83 fb 1f             	cmp    $0x1f,%ebx
  106572:	7e 05                	jle    106579 <vprintfmt+0x1f8>
  106574:	83 fb 7e             	cmp    $0x7e,%ebx
  106577:	7e 15                	jle    10658e <vprintfmt+0x20d>
                {
                    putch('?', putdat);
  106579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10657c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106580:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106587:	8b 45 08             	mov    0x8(%ebp),%eax
  10658a:	ff d0                	call   *%eax
  10658c:	eb 0f                	jmp    10659d <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
  10658e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106591:	89 44 24 04          	mov    %eax,0x4(%esp)
  106595:	89 1c 24             	mov    %ebx,(%esp)
  106598:	8b 45 08             	mov    0x8(%ebp),%eax
  10659b:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  10659d:	ff 4d e8             	decl   -0x18(%ebp)
  1065a0:	89 f0                	mov    %esi,%eax
  1065a2:	8d 70 01             	lea    0x1(%eax),%esi
  1065a5:	0f b6 00             	movzbl (%eax),%eax
  1065a8:	0f be d8             	movsbl %al,%ebx
  1065ab:	85 db                	test   %ebx,%ebx
  1065ad:	74 27                	je     1065d6 <vprintfmt+0x255>
  1065af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1065b3:	78 b4                	js     106569 <vprintfmt+0x1e8>
  1065b5:	ff 4d e4             	decl   -0x1c(%ebp)
  1065b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1065bc:	79 ab                	jns    106569 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
  1065be:	eb 16                	jmp    1065d6 <vprintfmt+0x255>
            {
                putch(' ', putdat);
  1065c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1065ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1065d1:	ff d0                	call   *%eax
            for (; width > 0; width--)
  1065d3:	ff 4d e8             	decl   -0x18(%ebp)
  1065d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065da:	7f e4                	jg     1065c0 <vprintfmt+0x23f>
            }
            break;
  1065dc:	e9 6c 01 00 00       	jmp    10674d <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1065e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1065e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065e8:	8d 45 14             	lea    0x14(%ebp),%eax
  1065eb:	89 04 24             	mov    %eax,(%esp)
  1065ee:	e8 16 fd ff ff       	call   106309 <getint>
  1065f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1065f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
  1065f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1065fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1065ff:	85 d2                	test   %edx,%edx
  106601:	79 26                	jns    106629 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
  106603:	8b 45 0c             	mov    0xc(%ebp),%eax
  106606:	89 44 24 04          	mov    %eax,0x4(%esp)
  10660a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  106611:	8b 45 08             	mov    0x8(%ebp),%eax
  106614:	ff d0                	call   *%eax
                num = -(long long)num;
  106616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10661c:	f7 d8                	neg    %eax
  10661e:	83 d2 00             	adc    $0x0,%edx
  106621:	f7 da                	neg    %edx
  106623:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106626:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106629:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106630:	e9 a8 00 00 00       	jmp    1066dd <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  106635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10663c:	8d 45 14             	lea    0x14(%ebp),%eax
  10663f:	89 04 24             	mov    %eax,(%esp)
  106642:	e8 73 fc ff ff       	call   1062ba <getuint>
  106647:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10664a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10664d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106654:	e9 84 00 00 00       	jmp    1066dd <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10665c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106660:	8d 45 14             	lea    0x14(%ebp),%eax
  106663:	89 04 24             	mov    %eax,(%esp)
  106666:	e8 4f fc ff ff       	call   1062ba <getuint>
  10666b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10666e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106671:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106678:	eb 63                	jmp    1066dd <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10667a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10667d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106681:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106688:	8b 45 08             	mov    0x8(%ebp),%eax
  10668b:	ff d0                	call   *%eax
            putch('x', putdat);
  10668d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106690:	89 44 24 04          	mov    %eax,0x4(%esp)
  106694:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10669b:	8b 45 08             	mov    0x8(%ebp),%eax
  10669e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1066a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1066a3:	8d 50 04             	lea    0x4(%eax),%edx
  1066a6:	89 55 14             	mov    %edx,0x14(%ebp)
  1066a9:	8b 00                	mov    (%eax),%eax
  1066ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1066b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1066bc:	eb 1f                	jmp    1066dd <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1066be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066c5:	8d 45 14             	lea    0x14(%ebp),%eax
  1066c8:	89 04 24             	mov    %eax,(%esp)
  1066cb:	e8 ea fb ff ff       	call   1062ba <getuint>
  1066d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1066d6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1066dd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1066e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1066e4:	89 54 24 18          	mov    %edx,0x18(%esp)
  1066e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1066eb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1066ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  1066f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1066f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1066fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106701:	8b 45 0c             	mov    0xc(%ebp),%eax
  106704:	89 44 24 04          	mov    %eax,0x4(%esp)
  106708:	8b 45 08             	mov    0x8(%ebp),%eax
  10670b:	89 04 24             	mov    %eax,(%esp)
  10670e:	e8 a5 fa ff ff       	call   1061b8 <printnum>
            break;
  106713:	eb 38                	jmp    10674d <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106715:	8b 45 0c             	mov    0xc(%ebp),%eax
  106718:	89 44 24 04          	mov    %eax,0x4(%esp)
  10671c:	89 1c 24             	mov    %ebx,(%esp)
  10671f:	8b 45 08             	mov    0x8(%ebp),%eax
  106722:	ff d0                	call   *%eax
            break;
  106724:	eb 27                	jmp    10674d <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106726:	8b 45 0c             	mov    0xc(%ebp),%eax
  106729:	89 44 24 04          	mov    %eax,0x4(%esp)
  10672d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106734:	8b 45 08             	mov    0x8(%ebp),%eax
  106737:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
  106739:	ff 4d 10             	decl   0x10(%ebp)
  10673c:	eb 03                	jmp    106741 <vprintfmt+0x3c0>
  10673e:	ff 4d 10             	decl   0x10(%ebp)
  106741:	8b 45 10             	mov    0x10(%ebp),%eax
  106744:	48                   	dec    %eax
  106745:	0f b6 00             	movzbl (%eax),%eax
  106748:	3c 25                	cmp    $0x25,%al
  10674a:	75 f2                	jne    10673e <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  10674c:	90                   	nop
    {
  10674d:	e9 37 fc ff ff       	jmp    106389 <vprintfmt+0x8>
                return;
  106752:	90                   	nop
        }
    }
}
  106753:	83 c4 40             	add    $0x40,%esp
  106756:	5b                   	pop    %ebx
  106757:	5e                   	pop    %esi
  106758:	5d                   	pop    %ebp
  106759:	c3                   	ret    

0010675a <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
  10675a:	55                   	push   %ebp
  10675b:	89 e5                	mov    %esp,%ebp
    b->cnt++;
  10675d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106760:	8b 40 08             	mov    0x8(%eax),%eax
  106763:	8d 50 01             	lea    0x1(%eax),%edx
  106766:	8b 45 0c             	mov    0xc(%ebp),%eax
  106769:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
  10676c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10676f:	8b 10                	mov    (%eax),%edx
  106771:	8b 45 0c             	mov    0xc(%ebp),%eax
  106774:	8b 40 04             	mov    0x4(%eax),%eax
  106777:	39 c2                	cmp    %eax,%edx
  106779:	73 12                	jae    10678d <sprintputch+0x33>
    {
        *b->buf++ = ch;
  10677b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10677e:	8b 00                	mov    (%eax),%eax
  106780:	8d 48 01             	lea    0x1(%eax),%ecx
  106783:	8b 55 0c             	mov    0xc(%ebp),%edx
  106786:	89 0a                	mov    %ecx,(%edx)
  106788:	8b 55 08             	mov    0x8(%ebp),%edx
  10678b:	88 10                	mov    %dl,(%eax)
    }
}
  10678d:	90                   	nop
  10678e:	5d                   	pop    %ebp
  10678f:	c3                   	ret    

00106790 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
  106790:	55                   	push   %ebp
  106791:	89 e5                	mov    %esp,%ebp
  106793:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106796:	8d 45 14             	lea    0x14(%ebp),%eax
  106799:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10679c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10679f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1067a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1067a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1067aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1067b4:	89 04 24             	mov    %eax,(%esp)
  1067b7:	e8 0a 00 00 00       	call   1067c6 <vsnprintf>
  1067bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1067bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1067c2:	89 ec                	mov    %ebp,%esp
  1067c4:	5d                   	pop    %ebp
  1067c5:	c3                   	ret    

001067c6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
  1067c6:	55                   	push   %ebp
  1067c7:	89 e5                	mov    %esp,%ebp
  1067c9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1067cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1067cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1067d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1067d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1067db:	01 d0                	add    %edx,%eax
  1067dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1067e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
  1067e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1067eb:	74 0a                	je     1067f7 <vsnprintf+0x31>
  1067ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1067f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067f3:	39 c2                	cmp    %eax,%edx
  1067f5:	76 07                	jbe    1067fe <vsnprintf+0x38>
    {
        return -E_INVAL;
  1067f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1067fc:	eb 2a                	jmp    106828 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
  1067fe:	8b 45 14             	mov    0x14(%ebp),%eax
  106801:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106805:	8b 45 10             	mov    0x10(%ebp),%eax
  106808:	89 44 24 08          	mov    %eax,0x8(%esp)
  10680c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10680f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106813:	c7 04 24 5a 67 10 00 	movl   $0x10675a,(%esp)
  10681a:	e8 62 fb ff ff       	call   106381 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10681f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106822:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106825:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106828:	89 ec                	mov    %ebp,%esp
  10682a:	5d                   	pop    %ebp
  10682b:	c3                   	ret    

0010682c <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
  10682c:	55                   	push   %ebp
  10682d:	89 e5                	mov    %esp,%ebp
  10682f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106832:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
  106839:	eb 03                	jmp    10683e <strlen+0x12>
    {
        cnt++;
  10683b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
  10683e:	8b 45 08             	mov    0x8(%ebp),%eax
  106841:	8d 50 01             	lea    0x1(%eax),%edx
  106844:	89 55 08             	mov    %edx,0x8(%ebp)
  106847:	0f b6 00             	movzbl (%eax),%eax
  10684a:	84 c0                	test   %al,%al
  10684c:	75 ed                	jne    10683b <strlen+0xf>
    }
    return cnt;
  10684e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106851:	89 ec                	mov    %ebp,%esp
  106853:	5d                   	pop    %ebp
  106854:	c3                   	ret    

00106855 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
  106855:	55                   	push   %ebp
  106856:	89 e5                	mov    %esp,%ebp
  106858:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10685b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  106862:	eb 03                	jmp    106867 <strnlen+0x12>
    {
        cnt++;
  106864:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  106867:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10686a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10686d:	73 10                	jae    10687f <strnlen+0x2a>
  10686f:	8b 45 08             	mov    0x8(%ebp),%eax
  106872:	8d 50 01             	lea    0x1(%eax),%edx
  106875:	89 55 08             	mov    %edx,0x8(%ebp)
  106878:	0f b6 00             	movzbl (%eax),%eax
  10687b:	84 c0                	test   %al,%al
  10687d:	75 e5                	jne    106864 <strnlen+0xf>
    }
    return cnt;
  10687f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106882:	89 ec                	mov    %ebp,%esp
  106884:	5d                   	pop    %ebp
  106885:	c3                   	ret    

00106886 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
  106886:	55                   	push   %ebp
  106887:	89 e5                	mov    %esp,%ebp
  106889:	57                   	push   %edi
  10688a:	56                   	push   %esi
  10688b:	83 ec 20             	sub    $0x20,%esp
  10688e:	8b 45 08             	mov    0x8(%ebp),%eax
  106891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106894:	8b 45 0c             	mov    0xc(%ebp),%eax
  106897:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
  10689a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10689d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1068a0:	89 d1                	mov    %edx,%ecx
  1068a2:	89 c2                	mov    %eax,%edx
  1068a4:	89 ce                	mov    %ecx,%esi
  1068a6:	89 d7                	mov    %edx,%edi
  1068a8:	ac                   	lods   %ds:(%esi),%al
  1068a9:	aa                   	stos   %al,%es:(%edi)
  1068aa:	84 c0                	test   %al,%al
  1068ac:	75 fa                	jne    1068a8 <strcpy+0x22>
  1068ae:	89 fa                	mov    %edi,%edx
  1068b0:	89 f1                	mov    %esi,%ecx
  1068b2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1068b5:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1068b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
  1068bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1068be:	83 c4 20             	add    $0x20,%esp
  1068c1:	5e                   	pop    %esi
  1068c2:	5f                   	pop    %edi
  1068c3:	5d                   	pop    %ebp
  1068c4:	c3                   	ret    

001068c5 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
  1068c5:	55                   	push   %ebp
  1068c6:	89 e5                	mov    %esp,%ebp
  1068c8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1068cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1068ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
  1068d1:	eb 1e                	jmp    1068f1 <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
  1068d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1068d6:	0f b6 10             	movzbl (%eax),%edx
  1068d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1068dc:	88 10                	mov    %dl,(%eax)
  1068de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1068e1:	0f b6 00             	movzbl (%eax),%eax
  1068e4:	84 c0                	test   %al,%al
  1068e6:	74 03                	je     1068eb <strncpy+0x26>
        {
            src++;
  1068e8:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
  1068eb:	ff 45 fc             	incl   -0x4(%ebp)
  1068ee:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
  1068f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1068f5:	75 dc                	jne    1068d3 <strncpy+0xe>
    }
    return dst;
  1068f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1068fa:	89 ec                	mov    %ebp,%esp
  1068fc:	5d                   	pop    %ebp
  1068fd:	c3                   	ret    

001068fe <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
  1068fe:	55                   	push   %ebp
  1068ff:	89 e5                	mov    %esp,%ebp
  106901:	57                   	push   %edi
  106902:	56                   	push   %esi
  106903:	83 ec 20             	sub    $0x20,%esp
  106906:	8b 45 08             	mov    0x8(%ebp),%eax
  106909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10690c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10690f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
  106912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106918:	89 d1                	mov    %edx,%ecx
  10691a:	89 c2                	mov    %eax,%edx
  10691c:	89 ce                	mov    %ecx,%esi
  10691e:	89 d7                	mov    %edx,%edi
  106920:	ac                   	lods   %ds:(%esi),%al
  106921:	ae                   	scas   %es:(%edi),%al
  106922:	75 08                	jne    10692c <strcmp+0x2e>
  106924:	84 c0                	test   %al,%al
  106926:	75 f8                	jne    106920 <strcmp+0x22>
  106928:	31 c0                	xor    %eax,%eax
  10692a:	eb 04                	jmp    106930 <strcmp+0x32>
  10692c:	19 c0                	sbb    %eax,%eax
  10692e:	0c 01                	or     $0x1,%al
  106930:	89 fa                	mov    %edi,%edx
  106932:	89 f1                	mov    %esi,%ecx
  106934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106937:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10693a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  10693d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  106940:	83 c4 20             	add    $0x20,%esp
  106943:	5e                   	pop    %esi
  106944:	5f                   	pop    %edi
  106945:	5d                   	pop    %ebp
  106946:	c3                   	ret    

00106947 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
  106947:	55                   	push   %ebp
  106948:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  10694a:	eb 09                	jmp    106955 <strncmp+0xe>
    {
        n--, s1++, s2++;
  10694c:	ff 4d 10             	decl   0x10(%ebp)
  10694f:	ff 45 08             	incl   0x8(%ebp)
  106952:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  106955:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106959:	74 1a                	je     106975 <strncmp+0x2e>
  10695b:	8b 45 08             	mov    0x8(%ebp),%eax
  10695e:	0f b6 00             	movzbl (%eax),%eax
  106961:	84 c0                	test   %al,%al
  106963:	74 10                	je     106975 <strncmp+0x2e>
  106965:	8b 45 08             	mov    0x8(%ebp),%eax
  106968:	0f b6 10             	movzbl (%eax),%edx
  10696b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10696e:	0f b6 00             	movzbl (%eax),%eax
  106971:	38 c2                	cmp    %al,%dl
  106973:	74 d7                	je     10694c <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  106975:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106979:	74 18                	je     106993 <strncmp+0x4c>
  10697b:	8b 45 08             	mov    0x8(%ebp),%eax
  10697e:	0f b6 00             	movzbl (%eax),%eax
  106981:	0f b6 d0             	movzbl %al,%edx
  106984:	8b 45 0c             	mov    0xc(%ebp),%eax
  106987:	0f b6 00             	movzbl (%eax),%eax
  10698a:	0f b6 c8             	movzbl %al,%ecx
  10698d:	89 d0                	mov    %edx,%eax
  10698f:	29 c8                	sub    %ecx,%eax
  106991:	eb 05                	jmp    106998 <strncmp+0x51>
  106993:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106998:	5d                   	pop    %ebp
  106999:	c3                   	ret    

0010699a <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
  10699a:	55                   	push   %ebp
  10699b:	89 e5                	mov    %esp,%ebp
  10699d:	83 ec 04             	sub    $0x4,%esp
  1069a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069a3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  1069a6:	eb 13                	jmp    1069bb <strchr+0x21>
    {
        if (*s == c)
  1069a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ab:	0f b6 00             	movzbl (%eax),%eax
  1069ae:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1069b1:	75 05                	jne    1069b8 <strchr+0x1e>
        {
            return (char *)s;
  1069b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1069b6:	eb 12                	jmp    1069ca <strchr+0x30>
        }
        s++;
  1069b8:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  1069bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1069be:	0f b6 00             	movzbl (%eax),%eax
  1069c1:	84 c0                	test   %al,%al
  1069c3:	75 e3                	jne    1069a8 <strchr+0xe>
    }
    return NULL;
  1069c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1069ca:	89 ec                	mov    %ebp,%esp
  1069cc:	5d                   	pop    %ebp
  1069cd:	c3                   	ret    

001069ce <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
  1069ce:	55                   	push   %ebp
  1069cf:	89 e5                	mov    %esp,%ebp
  1069d1:	83 ec 04             	sub    $0x4,%esp
  1069d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069d7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  1069da:	eb 0e                	jmp    1069ea <strfind+0x1c>
    {
        if (*s == c)
  1069dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1069df:	0f b6 00             	movzbl (%eax),%eax
  1069e2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1069e5:	74 0f                	je     1069f6 <strfind+0x28>
        {
            break;
        }
        s++;
  1069e7:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  1069ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ed:	0f b6 00             	movzbl (%eax),%eax
  1069f0:	84 c0                	test   %al,%al
  1069f2:	75 e8                	jne    1069dc <strfind+0xe>
  1069f4:	eb 01                	jmp    1069f7 <strfind+0x29>
            break;
  1069f6:	90                   	nop
    }
    return (char *)s;
  1069f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1069fa:	89 ec                	mov    %ebp,%esp
  1069fc:	5d                   	pop    %ebp
  1069fd:	c3                   	ret    

001069fe <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
  1069fe:	55                   	push   %ebp
  1069ff:	89 e5                	mov    %esp,%ebp
  106a01:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106a0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
  106a12:	eb 03                	jmp    106a17 <strtol+0x19>
    {
        s++;
  106a14:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
  106a17:	8b 45 08             	mov    0x8(%ebp),%eax
  106a1a:	0f b6 00             	movzbl (%eax),%eax
  106a1d:	3c 20                	cmp    $0x20,%al
  106a1f:	74 f3                	je     106a14 <strtol+0x16>
  106a21:	8b 45 08             	mov    0x8(%ebp),%eax
  106a24:	0f b6 00             	movzbl (%eax),%eax
  106a27:	3c 09                	cmp    $0x9,%al
  106a29:	74 e9                	je     106a14 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
  106a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  106a2e:	0f b6 00             	movzbl (%eax),%eax
  106a31:	3c 2b                	cmp    $0x2b,%al
  106a33:	75 05                	jne    106a3a <strtol+0x3c>
    {
        s++;
  106a35:	ff 45 08             	incl   0x8(%ebp)
  106a38:	eb 14                	jmp    106a4e <strtol+0x50>
    }
    else if (*s == '-')
  106a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  106a3d:	0f b6 00             	movzbl (%eax),%eax
  106a40:	3c 2d                	cmp    $0x2d,%al
  106a42:	75 0a                	jne    106a4e <strtol+0x50>
    {
        s++, neg = 1;
  106a44:	ff 45 08             	incl   0x8(%ebp)
  106a47:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  106a4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106a52:	74 06                	je     106a5a <strtol+0x5c>
  106a54:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106a58:	75 22                	jne    106a7c <strtol+0x7e>
  106a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  106a5d:	0f b6 00             	movzbl (%eax),%eax
  106a60:	3c 30                	cmp    $0x30,%al
  106a62:	75 18                	jne    106a7c <strtol+0x7e>
  106a64:	8b 45 08             	mov    0x8(%ebp),%eax
  106a67:	40                   	inc    %eax
  106a68:	0f b6 00             	movzbl (%eax),%eax
  106a6b:	3c 78                	cmp    $0x78,%al
  106a6d:	75 0d                	jne    106a7c <strtol+0x7e>
    {
        s += 2, base = 16;
  106a6f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106a73:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106a7a:	eb 29                	jmp    106aa5 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
  106a7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106a80:	75 16                	jne    106a98 <strtol+0x9a>
  106a82:	8b 45 08             	mov    0x8(%ebp),%eax
  106a85:	0f b6 00             	movzbl (%eax),%eax
  106a88:	3c 30                	cmp    $0x30,%al
  106a8a:	75 0c                	jne    106a98 <strtol+0x9a>
    {
        s++, base = 8;
  106a8c:	ff 45 08             	incl   0x8(%ebp)
  106a8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106a96:	eb 0d                	jmp    106aa5 <strtol+0xa7>
    }
    else if (base == 0)
  106a98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106a9c:	75 07                	jne    106aa5 <strtol+0xa7>
    {
        base = 10;
  106a9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
  106aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  106aa8:	0f b6 00             	movzbl (%eax),%eax
  106aab:	3c 2f                	cmp    $0x2f,%al
  106aad:	7e 1b                	jle    106aca <strtol+0xcc>
  106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  106ab2:	0f b6 00             	movzbl (%eax),%eax
  106ab5:	3c 39                	cmp    $0x39,%al
  106ab7:	7f 11                	jg     106aca <strtol+0xcc>
        {
            dig = *s - '0';
  106ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  106abc:	0f b6 00             	movzbl (%eax),%eax
  106abf:	0f be c0             	movsbl %al,%eax
  106ac2:	83 e8 30             	sub    $0x30,%eax
  106ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106ac8:	eb 48                	jmp    106b12 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
  106aca:	8b 45 08             	mov    0x8(%ebp),%eax
  106acd:	0f b6 00             	movzbl (%eax),%eax
  106ad0:	3c 60                	cmp    $0x60,%al
  106ad2:	7e 1b                	jle    106aef <strtol+0xf1>
  106ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  106ad7:	0f b6 00             	movzbl (%eax),%eax
  106ada:	3c 7a                	cmp    $0x7a,%al
  106adc:	7f 11                	jg     106aef <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
  106ade:	8b 45 08             	mov    0x8(%ebp),%eax
  106ae1:	0f b6 00             	movzbl (%eax),%eax
  106ae4:	0f be c0             	movsbl %al,%eax
  106ae7:	83 e8 57             	sub    $0x57,%eax
  106aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106aed:	eb 23                	jmp    106b12 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
  106aef:	8b 45 08             	mov    0x8(%ebp),%eax
  106af2:	0f b6 00             	movzbl (%eax),%eax
  106af5:	3c 40                	cmp    $0x40,%al
  106af7:	7e 3b                	jle    106b34 <strtol+0x136>
  106af9:	8b 45 08             	mov    0x8(%ebp),%eax
  106afc:	0f b6 00             	movzbl (%eax),%eax
  106aff:	3c 5a                	cmp    $0x5a,%al
  106b01:	7f 31                	jg     106b34 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
  106b03:	8b 45 08             	mov    0x8(%ebp),%eax
  106b06:	0f b6 00             	movzbl (%eax),%eax
  106b09:	0f be c0             	movsbl %al,%eax
  106b0c:	83 e8 37             	sub    $0x37,%eax
  106b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
  106b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b15:	3b 45 10             	cmp    0x10(%ebp),%eax
  106b18:	7d 19                	jge    106b33 <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
  106b1a:	ff 45 08             	incl   0x8(%ebp)
  106b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  106b24:	89 c2                	mov    %eax,%edx
  106b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b29:	01 d0                	add    %edx,%eax
  106b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
  106b2e:	e9 72 ff ff ff       	jmp    106aa5 <strtol+0xa7>
            break;
  106b33:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
  106b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106b38:	74 08                	je     106b42 <strtol+0x144>
    {
        *endptr = (char *)s;
  106b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  106b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  106b40:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106b46:	74 07                	je     106b4f <strtol+0x151>
  106b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106b4b:	f7 d8                	neg    %eax
  106b4d:	eb 03                	jmp    106b52 <strtol+0x154>
  106b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106b52:	89 ec                	mov    %ebp,%esp
  106b54:	5d                   	pop    %ebp
  106b55:	c3                   	ret    

00106b56 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
  106b56:	55                   	push   %ebp
  106b57:	89 e5                	mov    %esp,%ebp
  106b59:	83 ec 28             	sub    $0x28,%esp
  106b5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106b62:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106b65:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  106b69:	8b 45 08             	mov    0x8(%ebp),%eax
  106b6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106b6f:	88 55 f7             	mov    %dl,-0x9(%ebp)
  106b72:	8b 45 10             	mov    0x10(%ebp),%eax
  106b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
  106b78:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106b7b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106b7f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106b82:	89 d7                	mov    %edx,%edi
  106b84:	f3 aa                	rep stos %al,%es:(%edi)
  106b86:	89 fa                	mov    %edi,%edx
  106b88:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106b8b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
  106b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106b91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106b94:	89 ec                	mov    %ebp,%esp
  106b96:	5d                   	pop    %ebp
  106b97:	c3                   	ret    

00106b98 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
  106b98:	55                   	push   %ebp
  106b99:	89 e5                	mov    %esp,%ebp
  106b9b:	57                   	push   %edi
  106b9c:	56                   	push   %esi
  106b9d:	53                   	push   %ebx
  106b9e:	83 ec 30             	sub    $0x30,%esp
  106ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  106ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  106baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106bad:	8b 45 10             	mov    0x10(%ebp),%eax
  106bb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
  106bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106bb6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106bb9:	73 42                	jae    106bfd <memmove+0x65>
  106bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106bc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106bca:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  106bcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106bd0:	c1 e8 02             	shr    $0x2,%eax
  106bd3:	89 c1                	mov    %eax,%ecx
    asm volatile(
  106bd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106bdb:	89 d7                	mov    %edx,%edi
  106bdd:	89 c6                	mov    %eax,%esi
  106bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106be1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106be4:	83 e1 03             	and    $0x3,%ecx
  106be7:	74 02                	je     106beb <memmove+0x53>
  106be9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106beb:	89 f0                	mov    %esi,%eax
  106bed:	89 fa                	mov    %edi,%edx
  106bef:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106bf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106bf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106bfb:	eb 36                	jmp    106c33 <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
  106bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c00:	8d 50 ff             	lea    -0x1(%eax),%edx
  106c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c06:	01 c2                	add    %eax,%edx
  106c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c0b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c11:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
  106c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c17:	89 c1                	mov    %eax,%ecx
  106c19:	89 d8                	mov    %ebx,%eax
  106c1b:	89 d6                	mov    %edx,%esi
  106c1d:	89 c7                	mov    %eax,%edi
  106c1f:	fd                   	std    
  106c20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c22:	fc                   	cld    
  106c23:	89 f8                	mov    %edi,%eax
  106c25:	89 f2                	mov    %esi,%edx
  106c27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106c2a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106c2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106c33:	83 c4 30             	add    $0x30,%esp
  106c36:	5b                   	pop    %ebx
  106c37:	5e                   	pop    %esi
  106c38:	5f                   	pop    %edi
  106c39:	5d                   	pop    %ebp
  106c3a:	c3                   	ret    

00106c3b <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
  106c3b:	55                   	push   %ebp
  106c3c:	89 e5                	mov    %esp,%ebp
  106c3e:	57                   	push   %edi
  106c3f:	56                   	push   %esi
  106c40:	83 ec 20             	sub    $0x20,%esp
  106c43:	8b 45 08             	mov    0x8(%ebp),%eax
  106c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  106c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  106c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c58:	c1 e8 02             	shr    $0x2,%eax
  106c5b:	89 c1                	mov    %eax,%ecx
    asm volatile(
  106c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c63:	89 d7                	mov    %edx,%edi
  106c65:	89 c6                	mov    %eax,%esi
  106c67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106c69:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106c6c:	83 e1 03             	and    $0x3,%ecx
  106c6f:	74 02                	je     106c73 <memcpy+0x38>
  106c71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c73:	89 f0                	mov    %esi,%eax
  106c75:	89 fa                	mov    %edi,%edx
  106c77:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106c7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  106c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106c83:	83 c4 20             	add    $0x20,%esp
  106c86:	5e                   	pop    %esi
  106c87:	5f                   	pop    %edi
  106c88:	5d                   	pop    %ebp
  106c89:	c3                   	ret    

00106c8a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
  106c8a:	55                   	push   %ebp
  106c8b:	89 e5                	mov    %esp,%ebp
  106c8d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106c90:	8b 45 08             	mov    0x8(%ebp),%eax
  106c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c99:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
  106c9c:	eb 2e                	jmp    106ccc <memcmp+0x42>
    {
        if (*s1 != *s2)
  106c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106ca1:	0f b6 10             	movzbl (%eax),%edx
  106ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106ca7:	0f b6 00             	movzbl (%eax),%eax
  106caa:	38 c2                	cmp    %al,%dl
  106cac:	74 18                	je     106cc6 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106cb1:	0f b6 00             	movzbl (%eax),%eax
  106cb4:	0f b6 d0             	movzbl %al,%edx
  106cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106cba:	0f b6 00             	movzbl (%eax),%eax
  106cbd:	0f b6 c8             	movzbl %al,%ecx
  106cc0:	89 d0                	mov    %edx,%eax
  106cc2:	29 c8                	sub    %ecx,%eax
  106cc4:	eb 18                	jmp    106cde <memcmp+0x54>
        }
        s1++, s2++;
  106cc6:	ff 45 fc             	incl   -0x4(%ebp)
  106cc9:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
  106ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  106ccf:	8d 50 ff             	lea    -0x1(%eax),%edx
  106cd2:	89 55 10             	mov    %edx,0x10(%ebp)
  106cd5:	85 c0                	test   %eax,%eax
  106cd7:	75 c5                	jne    106c9e <memcmp+0x14>
    }
    return 0;
  106cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106cde:	89 ec                	mov    %ebp,%esp
  106ce0:	5d                   	pop    %ebp
  106ce1:	c3                   	ret    
