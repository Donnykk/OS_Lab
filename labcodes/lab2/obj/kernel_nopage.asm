
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
  100059:	e8 64 6b 00 00       	call   106bc2 <memset>

    cons_init(); // init the console
  10005e:	e8 f9 15 00 00       	call   10165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 60 6d 10 00 	movl   $0x106d60,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 7c 6d 10 00 	movl   $0x106d7c,(%esp)
  100078:	e8 e8 02 00 00       	call   100365 <cprintf>

    print_kerninfo();
  10007d:	e8 06 08 00 00       	call   100888 <print_kerninfo>

    grade_backtrace();
  100082:	e8 95 00 00 00       	call   10011c <grade_backtrace>

    pmm_init(); // init physical memory management
  100087:	e8 ad 50 00 00       	call   105139 <pmm_init>

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
  10016c:	c7 04 24 81 6d 10 00 	movl   $0x106d81,(%esp)
  100173:	e8 ed 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10017c:	89 c2                	mov    %eax,%edx
  10017e:	a1 00 e0 11 00       	mov    0x11e000,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 8f 6d 10 00 	movl   $0x106d8f,(%esp)
  100192:	e8 ce 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10019b:	89 c2                	mov    %eax,%edx
  10019d:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001aa:	c7 04 24 9d 6d 10 00 	movl   $0x106d9d,(%esp)
  1001b1:	e8 af 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ba:	89 c2                	mov    %eax,%edx
  1001bc:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c9:	c7 04 24 ab 6d 10 00 	movl   $0x106dab,(%esp)
  1001d0:	e8 90 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d9:	89 c2                	mov    %eax,%edx
  1001db:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e8:	c7 04 24 b9 6d 10 00 	movl   $0x106db9,(%esp)
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
  100225:	c7 04 24 c8 6d 10 00 	movl   $0x106dc8,(%esp)
  10022c:	e8 34 01 00 00       	call   100365 <cprintf>
    lab1_switch_to_user();
  100231:	e8 ce ff ff ff       	call   100204 <lab1_switch_to_user>
    lab1_print_cur_status();
  100236:	e8 09 ff ff ff       	call   100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10023b:	c7 04 24 e8 6d 10 00 	movl   $0x106de8,(%esp)
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
  100269:	c7 04 24 07 6e 10 00 	movl   $0x106e07,(%esp)
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
  100359:	e8 8f 60 00 00       	call   1063ed <vprintfmt>
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
  100569:	c7 00 0c 6e 10 00    	movl   $0x106e0c,(%eax)
    info->eip_line = 0;
  10056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 08 0c 6e 10 00 	movl   $0x106e0c,0x8(%eax)
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
  1005a0:	c7 45 f4 98 83 10 00 	movl   $0x108398,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a7:	c7 45 f0 dc 4d 11 00 	movl   $0x114ddc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ae:	c7 45 ec dd 4d 11 00 	movl   $0x114ddd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b5:	c7 45 e8 97 86 11 00 	movl   $0x118697,-0x18(%ebp)

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
  100708:	e8 2d 63 00 00       	call   106a3a <strfind>
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
  10088e:	c7 04 24 16 6e 10 00 	movl   $0x106e16,(%esp)
  100895:	e8 cb fa ff ff       	call   100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10089a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1008a1:	00 
  1008a2:	c7 04 24 2f 6e 10 00 	movl   $0x106e2f,(%esp)
  1008a9:	e8 b7 fa ff ff       	call   100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ae:	c7 44 24 04 4e 6d 10 	movl   $0x106d4e,0x4(%esp)
  1008b5:	00 
  1008b6:	c7 04 24 47 6e 10 00 	movl   $0x106e47,(%esp)
  1008bd:	e8 a3 fa ff ff       	call   100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008c2:	c7 44 24 04 36 ba 11 	movl   $0x11ba36,0x4(%esp)
  1008c9:	00 
  1008ca:	c7 04 24 5f 6e 10 00 	movl   $0x106e5f,(%esp)
  1008d1:	e8 8f fa ff ff       	call   100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d6:	c7 44 24 04 2c ef 11 	movl   $0x11ef2c,0x4(%esp)
  1008dd:	00 
  1008de:	c7 04 24 77 6e 10 00 	movl   $0x106e77,(%esp)
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
  10090b:	c7 04 24 90 6e 10 00 	movl   $0x106e90,(%esp)
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
  100942:	c7 04 24 ba 6e 10 00 	movl   $0x106eba,(%esp)
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
  1009b0:	c7 04 24 d6 6e 10 00 	movl   $0x106ed6,(%esp)
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
  100a07:	c7 04 24 e8 6e 10 00 	movl   $0x106ee8,(%esp)
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
  100a3a:	c7 04 24 04 6f 10 00 	movl   $0x106f04,(%esp)
  100a41:	e8 1f f9 ff ff       	call   100365 <cprintf>
        for (j = 0; j < 4; j++)
  100a46:	ff 45 e8             	incl   -0x18(%ebp)
  100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4d:	7e d6                	jle    100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a4f:	c7 04 24 0c 6f 10 00 	movl   $0x106f0c,(%esp)
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
  100ac4:	c7 04 24 90 6f 10 00 	movl   $0x106f90,(%esp)
  100acb:	e8 36 5f 00 00       	call   106a06 <strchr>
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
  100aec:	c7 04 24 95 6f 10 00 	movl   $0x106f95,(%esp)
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
  100b2e:	c7 04 24 90 6f 10 00 	movl   $0x106f90,(%esp)
  100b35:	e8 cc 5e 00 00       	call   106a06 <strchr>
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
  100b9f:	e8 c6 5d 00 00       	call   10696a <strcmp>
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
  100beb:	c7 04 24 b3 6f 10 00 	movl   $0x106fb3,(%esp)
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
  100c09:	c7 04 24 cc 6f 10 00 	movl   $0x106fcc,(%esp)
  100c10:	e8 50 f7 ff ff       	call   100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c15:	c7 04 24 f4 6f 10 00 	movl   $0x106ff4,(%esp)
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
  100c32:	c7 04 24 19 70 10 00 	movl   $0x107019,(%esp)
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
  100ca2:	c7 04 24 1d 70 10 00 	movl   $0x10701d,(%esp)
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
  100d17:	c7 04 24 26 70 10 00 	movl   $0x107026,(%esp)
  100d1e:	e8 42 f6 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2d:	89 04 24             	mov    %eax,(%esp)
  100d30:	e8 fb f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100d35:	c7 04 24 42 70 10 00 	movl   $0x107042,(%esp)
  100d3c:	e8 24 f6 ff ff       	call   100365 <cprintf>

    cprintf("stack trackback:\n");
  100d41:	c7 04 24 44 70 10 00 	movl   $0x107044,(%esp)
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
  100d82:	c7 04 24 56 70 10 00 	movl   $0x107056,(%esp)
  100d89:	e8 d7 f5 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d95:	8b 45 10             	mov    0x10(%ebp),%eax
  100d98:	89 04 24             	mov    %eax,(%esp)
  100d9b:	e8 90 f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100da0:	c7 04 24 42 70 10 00 	movl   $0x107042,(%esp)
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
  100e07:	c7 04 24 74 70 10 00 	movl   $0x107074,(%esp)
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
  101271:	e8 8e 59 00 00       	call   106c04 <memmove>
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
  101603:	c7 04 24 8f 70 10 00 	movl   $0x10708f,(%esp)
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
  10167a:	c7 04 24 9b 70 10 00 	movl   $0x10709b,(%esp)
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
  101935:	c7 04 24 c0 70 10 00 	movl   $0x1070c0,(%esp)
  10193c:	e8 24 ea ff ff       	call   100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101941:	c7 04 24 ca 70 10 00 	movl   $0x1070ca,(%esp)
  101948:	e8 18 ea ff ff       	call   100365 <cprintf>
    panic("EOT: kernel seems ok.");
  10194d:	c7 44 24 08 d8 70 10 	movl   $0x1070d8,0x8(%esp)
  101954:	00 
  101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  10195c:	00 
  10195d:	c7 04 24 ee 70 10 00 	movl   $0x1070ee,(%esp)
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
  101aeb:	8b 04 85 40 74 10 00 	mov    0x107440(,%eax,4),%eax
  101af2:	eb 18                	jmp    101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101af8:	7e 0d                	jle    101b07 <trapname+0x2a>
  101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101afe:	7f 07                	jg     101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101b00:	b8 ff 70 10 00       	mov    $0x1070ff,%eax
  101b05:	eb 05                	jmp    101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
  101b07:	b8 12 71 10 00       	mov    $0x107112,%eax
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
  101b30:	c7 04 24 53 71 10 00 	movl   $0x107153,(%esp)
  101b37:	e8 29 e8 ff ff       	call   100365 <cprintf>
    print_regs(&tf->tf_regs);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	89 04 24             	mov    %eax,(%esp)
  101b42:	e8 8f 01 00 00       	call   101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 64 71 10 00 	movl   $0x107164,(%esp)
  101b59:	e8 07 e8 ff ff       	call   100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b69:	c7 04 24 77 71 10 00 	movl   $0x107177,(%esp)
  101b70:	e8 f0 e7 ff ff       	call   100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 8a 71 10 00 	movl   $0x10718a,(%esp)
  101b87:	e8 d9 e7 ff ff       	call   100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b97:	c7 04 24 9d 71 10 00 	movl   $0x10719d,(%esp)
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
  101bbf:	c7 04 24 b0 71 10 00 	movl   $0x1071b0,(%esp)
  101bc6:	e8 9a e7 ff ff       	call   100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 34             	mov    0x34(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 c2 71 10 00 	movl   $0x1071c2,(%esp)
  101bdc:	e8 84 e7 ff ff       	call   100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 38             	mov    0x38(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 d1 71 10 00 	movl   $0x1071d1,(%esp)
  101bf2:	e8 6e e7 ff ff       	call   100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 e0 71 10 00 	movl   $0x1071e0,(%esp)
  101c09:	e8 57 e7 ff ff       	call   100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 40 40             	mov    0x40(%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 f3 71 10 00 	movl   $0x1071f3,(%esp)
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
  101c5f:	c7 04 24 02 72 10 00 	movl   $0x107202,(%esp)
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
  101c89:	c7 04 24 06 72 10 00 	movl   $0x107206,(%esp)
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
  101cae:	c7 04 24 0f 72 10 00 	movl   $0x10720f,(%esp)
  101cb5:	e8 ab e6 ff ff       	call   100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc5:	c7 04 24 1e 72 10 00 	movl   $0x10721e,(%esp)
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
  101ce5:	c7 04 24 31 72 10 00 	movl   $0x107231,(%esp)
  101cec:	e8 74 e6 ff ff       	call   100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf4:	8b 40 04             	mov    0x4(%eax),%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 40 72 10 00 	movl   $0x107240,(%esp)
  101d02:	e8 5e e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	8b 40 08             	mov    0x8(%eax),%eax
  101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d11:	c7 04 24 4f 72 10 00 	movl   $0x10724f,(%esp)
  101d18:	e8 48 e6 ff ff       	call   100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d20:	8b 40 0c             	mov    0xc(%eax),%eax
  101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d27:	c7 04 24 5e 72 10 00 	movl   $0x10725e,(%esp)
  101d2e:	e8 32 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d33:	8b 45 08             	mov    0x8(%ebp),%eax
  101d36:	8b 40 10             	mov    0x10(%eax),%eax
  101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3d:	c7 04 24 6d 72 10 00 	movl   $0x10726d,(%esp)
  101d44:	e8 1c e6 ff ff       	call   100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d49:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4c:	8b 40 14             	mov    0x14(%eax),%eax
  101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d53:	c7 04 24 7c 72 10 00 	movl   $0x10727c,(%esp)
  101d5a:	e8 06 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d62:	8b 40 18             	mov    0x18(%eax),%eax
  101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d69:	c7 04 24 8b 72 10 00 	movl   $0x10728b,(%esp)
  101d70:	e8 f0 e5 ff ff       	call   100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7f:	c7 04 24 9a 72 10 00 	movl   $0x10729a,(%esp)
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
  101e34:	c7 04 24 a9 72 10 00 	movl   $0x1072a9,(%esp)
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
  101e5d:	c7 04 24 bb 72 10 00 	movl   $0x1072bb,(%esp)
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
  101f30:	c7 44 24 08 ca 72 10 	movl   $0x1072ca,0x8(%esp)
  101f37:	00 
  101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  101f3f:	00 
  101f40:	c7 04 24 ee 70 10 00 	movl   $0x1070ee,(%esp)
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
  102a64:	c7 44 24 08 90 74 10 	movl   $0x107490,0x8(%esp)
  102a6b:	00 
  102a6c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a73:	00 
  102a74:	c7 04 24 b3 74 10 00 	movl   $0x1074b3,(%esp)
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

00102aa4 <ROUND_UP_LOG>:

#define IS_POWER_OF_2(x) (!((x) & ((x)-1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int ROUND_UP_LOG(int size)
{
  102aa4:	55                   	push   %ebp
  102aa5:	89 e5                	mov    %esp,%ebp
  102aa7:	83 ec 10             	sub    $0x10,%esp
    int n = 0, tmp = size;
  102aaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (tmp >>= 1)
  102ab7:	eb 03                	jmp    102abc <ROUND_UP_LOG+0x18>
    {
        n++;
  102ab9:	ff 45 fc             	incl   -0x4(%ebp)
    while (tmp >>= 1)
  102abc:	d1 7d f8             	sarl   -0x8(%ebp)
  102abf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  102ac3:	75 f4                	jne    102ab9 <ROUND_UP_LOG+0x15>
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
    // 首先对页进行初始化
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
  102b3e:	c7 44 24 0c c1 74 10 	movl   $0x1074c1,0xc(%esp)
  102b45:	00 
  102b46:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  102b4d:	00 
  102b4e:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  102b55:	00 
  102b56:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
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
    // 获取 buddy_manager 数组的长度
    manager_size = 2 * (1 << ROUND_UP_LOG(n));
  102bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc9:	89 04 24             	mov    %eax,(%esp)
  102bcc:	e8 d3 fe ff ff       	call   102aa4 <ROUND_UP_LOG>
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
    // 调整 base
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
    // buddy数组的下标[1 … manager_size]有效
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
    cprintf("===================buddy init end===================\n");
  102cae:	c7 04 24 fc 74 10 00 	movl   $0x1074fc,(%esp)
  102cb5:	e8 ab d6 ff ff       	call   100365 <cprintf>
    cprintf("free_size = %d\n", free_page_num);
  102cba:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc3:	c7 04 24 32 75 10 00 	movl   $0x107532,(%esp)
  102cca:	e8 96 d6 ff ff       	call   100365 <cprintf>
    cprintf("buddy_size = %d\n", manager_size);
  102ccf:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd8:	c7 04 24 42 75 10 00 	movl   $0x107542,(%esp)
  102cdf:	e8 81 d6 ff ff       	call   100365 <cprintf>
    cprintf("buddy_addr = 0x%08x\n", buddy_manager);
  102ce4:	a1 80 ee 11 00       	mov    0x11ee80,%eax
  102ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ced:	c7 04 24 53 75 10 00 	movl   $0x107553,(%esp)
  102cf4:	e8 6c d6 ff ff       	call   100365 <cprintf>
    cprintf("manager_page_base = 0x%08x\n", page_base);
  102cf9:	a1 84 ee 11 00       	mov    0x11ee84,%eax
  102cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d02:	c7 04 24 68 75 10 00 	movl   $0x107568,(%esp)
  102d09:	e8 57 d6 ff ff       	call   100365 <cprintf>
    cprintf("====================================================\n");
  102d0e:	c7 04 24 84 75 10 00 	movl   $0x107584,(%esp)
  102d15:	e8 4b d6 ff ff       	call   100365 <cprintf>
}
  102d1a:	90                   	nop
  102d1b:	89 ec                	mov    %ebp,%esp
  102d1d:	5d                   	pop    %ebp
  102d1e:	c3                   	ret    

00102d1f <buddy_alloc>:

int buddy_alloc(int size)
{
  102d1f:	55                   	push   %ebp
  102d20:	89 e5                	mov    %esp,%ebp
  102d22:	83 ec 28             	sub    $0x28,%esp
  102d25:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    unsigned index = 1;
  102d28:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    unsigned offset = 0;
  102d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    unsigned node_size;
    // 将size向上取整为2的幂
    if (size <= 0)
  102d36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d3a:	7f 09                	jg     102d45 <buddy_alloc+0x26>
        size = 1;
  102d3c:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
  102d43:	eb 24                	jmp    102d69 <buddy_alloc+0x4a>
    else if (!IS_POWER_OF_2(size))
  102d45:	8b 45 08             	mov    0x8(%ebp),%eax
  102d48:	48                   	dec    %eax
  102d49:	23 45 08             	and    0x8(%ebp),%eax
  102d4c:	85 c0                	test   %eax,%eax
  102d4e:	74 19                	je     102d69 <buddy_alloc+0x4a>
        size = 1 << ROUND_UP_LOG(size);
  102d50:	8b 45 08             	mov    0x8(%ebp),%eax
  102d53:	89 04 24             	mov    %eax,(%esp)
  102d56:	e8 49 fd ff ff       	call   102aa4 <ROUND_UP_LOG>
  102d5b:	ba 01 00 00 00       	mov    $0x1,%edx
  102d60:	88 c1                	mov    %al,%cl
  102d62:	d3 e2                	shl    %cl,%edx
  102d64:	89 d0                	mov    %edx,%eax
  102d66:	89 45 08             	mov    %eax,0x8(%ebp)
    if (buddy_manager[index] < size)
  102d69:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d72:	c1 e0 02             	shl    $0x2,%eax
  102d75:	01 d0                	add    %edx,%eax
  102d77:	8b 10                	mov    (%eax),%edx
  102d79:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7c:	39 c2                	cmp    %eax,%edx
  102d7e:	73 0a                	jae    102d8a <buddy_alloc+0x6b>
        return -1;
  102d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102d85:	e9 e1 00 00 00       	jmp    102e6b <buddy_alloc+0x14c>
    // 从根节点往下深度遍历，找到恰好等于size的块
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
  102d8a:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102d8f:	89 c2                	mov    %eax,%edx
  102d91:	c1 ea 1f             	shr    $0x1f,%edx
  102d94:	01 d0                	add    %edx,%eax
  102d96:	d1 f8                	sar    %eax
  102d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d9b:	eb 2d                	jmp    102dca <buddy_alloc+0xab>
    {
        if (buddy_manager[LEFT_LEAF(index)] >= size)
  102d9d:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da6:	c1 e0 03             	shl    $0x3,%eax
  102da9:	01 d0                	add    %edx,%eax
  102dab:	8b 10                	mov    (%eax),%edx
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	39 c2                	cmp    %eax,%edx
  102db2:	72 05                	jb     102db9 <buddy_alloc+0x9a>
            index = LEFT_LEAF(index);
  102db4:	d1 65 f4             	shll   -0xc(%ebp)
  102db7:	eb 09                	jmp    102dc2 <buddy_alloc+0xa3>
        else
            index = RIGHT_LEAF(index);
  102db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbc:	01 c0                	add    %eax,%eax
  102dbe:	40                   	inc    %eax
  102dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
  102dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc5:	d1 e8                	shr    %eax
  102dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dca:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102dd0:	75 cb                	jne    102d9d <buddy_alloc+0x7e>
    }
    // 将找到的块取出分配
    buddy_manager[index] = 0;
  102dd2:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ddb:	c1 e0 02             	shl    $0x2,%eax
  102dde:	01 d0                	add    %edx,%eax
  102de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    // 计算块在所有块内存中的索引
    offset = (index)*node_size - manager_size / 2;
  102de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de9:	0f af 45 f0          	imul   -0x10(%ebp),%eax
  102ded:	89 c2                	mov    %eax,%edx
  102def:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  102df4:	89 c1                	mov    %eax,%ecx
  102df6:	c1 e9 1f             	shr    $0x1f,%ecx
  102df9:	01 c8                	add    %ecx,%eax
  102dfb:	d1 f8                	sar    %eax
  102dfd:	89 c1                	mov    %eax,%ecx
  102dff:	89 d0                	mov    %edx,%eax
  102e01:	29 c8                	sub    %ecx,%eax
  102e03:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf(" index:%u offset:%u ", index, offset);
  102e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e09:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e14:	c7 04 24 ba 75 10 00 	movl   $0x1075ba,(%esp)
  102e1b:	e8 45 d5 ff ff       	call   100365 <cprintf>
    // 向上回溯至根节点，修改沿途节点的大小
    while (index > 1)
  102e20:	eb 40                	jmp    102e62 <buddy_alloc+0x143>
    {
        index = PARENT(index);
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	d1 e8                	shr    %eax
  102e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        buddy_manager[index] = MAX(buddy_manager[LEFT_LEAF(index)], buddy_manager[RIGHT_LEAF(index)]);
  102e2a:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e33:	c1 e0 03             	shl    $0x3,%eax
  102e36:	83 c0 04             	add    $0x4,%eax
  102e39:	01 d0                	add    %edx,%eax
  102e3b:	8b 10                	mov    (%eax),%edx
  102e3d:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  102e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e46:	c1 e0 03             	shl    $0x3,%eax
  102e49:	01 c8                	add    %ecx,%eax
  102e4b:	8b 00                	mov    (%eax),%eax
  102e4d:	8b 1d 80 ee 11 00    	mov    0x11ee80,%ebx
  102e53:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  102e56:	c1 e1 02             	shl    $0x2,%ecx
  102e59:	01 d9                	add    %ebx,%ecx
  102e5b:	39 c2                	cmp    %eax,%edx
  102e5d:	0f 43 c2             	cmovae %edx,%eax
  102e60:	89 01                	mov    %eax,(%ecx)
    while (index > 1)
  102e62:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102e66:	77 ba                	ja     102e22 <buddy_alloc+0x103>
    }
    return offset;
  102e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  102e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102e6e:	89 ec                	mov    %ebp,%esp
  102e70:	5d                   	pop    %ebp
  102e71:	c3                   	ret    

00102e72 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n)
{
  102e72:	55                   	push   %ebp
  102e73:	89 e5                	mov    %esp,%ebp
  102e75:	83 ec 38             	sub    $0x38,%esp
    cprintf("alloc %u pages", n);
  102e78:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7f:	c7 04 24 cf 75 10 00 	movl   $0x1075cf,(%esp)
  102e86:	e8 da d4 ff ff       	call   100365 <cprintf>
    assert(n > 0);
  102e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102e8f:	75 24                	jne    102eb5 <buddy_alloc_pages+0x43>
  102e91:	c7 44 24 0c de 75 10 	movl   $0x1075de,0xc(%esp)
  102e98:	00 
  102e99:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  102ea0:	00 
  102ea1:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  102ea8:	00 
  102ea9:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  102eb0:	e8 35 de ff ff       	call   100cea <__panic>
    if (n > free_page_num)
  102eb5:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102eba:	39 45 08             	cmp    %eax,0x8(%ebp)
  102ebd:	76 0a                	jbe    102ec9 <buddy_alloc_pages+0x57>
        return NULL;
  102ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  102ec4:	e9 a3 00 00 00       	jmp    102f6c <buddy_alloc_pages+0xfa>
    // 获取分配的页在内存中的起始地址
    int offset = buddy_alloc(n);
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	89 04 24             	mov    %eax,(%esp)
  102ecf:	e8 4b fe ff ff       	call   102d1f <buddy_alloc>
  102ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *base = page_base + offset;
  102ed7:	8b 0d 84 ee 11 00    	mov    0x11ee84,%ecx
  102edd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ee0:	89 d0                	mov    %edx,%eax
  102ee2:	c1 e0 02             	shl    $0x2,%eax
  102ee5:	01 d0                	add    %edx,%eax
  102ee7:	c1 e0 02             	shl    $0x2,%eax
  102eea:	01 c8                	add    %ecx,%eax
  102eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct Page *page;
    // 将n向上取整，因为有round_n个块被取出
    int round_n = 1 << ROUND_UP_LOG(n);
  102eef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef2:	89 04 24             	mov    %eax,(%esp)
  102ef5:	e8 aa fb ff ff       	call   102aa4 <ROUND_UP_LOG>
  102efa:	ba 01 00 00 00       	mov    $0x1,%edx
  102eff:	88 c1                	mov    %al,%cl
  102f01:	d3 e2                	shl    %cl,%edx
  102f03:	89 d0                	mov    %edx,%eax
  102f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // 将每一个取出的块由空闲态改为保留态
    for (page = base; page != base + round_n; page++)
  102f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f0e:	eb 1e                	jmp    102f2e <buddy_alloc_pages+0xbc>
    {
        ClearPageProperty(page);
  102f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f13:	83 c0 04             	add    $0x4,%eax
  102f16:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile("btrl %1, %0"
  102f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f26:	0f b3 10             	btr    %edx,(%eax)
}
  102f29:	90                   	nop
    for (page = base; page != base + round_n; page++)
  102f2a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102f2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102f31:	89 d0                	mov    %edx,%eax
  102f33:	c1 e0 02             	shl    $0x2,%eax
  102f36:	01 d0                	add    %edx,%eax
  102f38:	c1 e0 02             	shl    $0x2,%eax
  102f3b:	89 c2                	mov    %eax,%edx
  102f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f40:	01 d0                	add    %edx,%eax
  102f42:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102f45:	75 c9                	jne    102f10 <buddy_alloc_pages+0x9e>
    }
    free_page_num -= round_n;
  102f47:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102f4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  102f4f:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    base->property = n;
  102f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f57:	8b 55 08             	mov    0x8(%ebp),%edx
  102f5a:	89 50 08             	mov    %edx,0x8(%eax)
    cprintf("finish!\n");
  102f5d:	c7 04 24 e4 75 10 00 	movl   $0x1075e4,(%esp)
  102f64:	e8 fc d3 ff ff       	call   100365 <cprintf>
    return base;
  102f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  102f6c:	89 ec                	mov    %ebp,%esp
  102f6e:	5d                   	pop    %ebp
  102f6f:	c3                   	ret    

00102f70 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n)
{
  102f70:	55                   	push   %ebp
  102f71:	89 e5                	mov    %esp,%ebp
  102f73:	83 ec 58             	sub    $0x58,%esp
    cprintf("free  %u pages", n);
  102f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f79:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7d:	c7 04 24 ed 75 10 00 	movl   $0x1075ed,(%esp)
  102f84:	e8 dc d3 ff ff       	call   100365 <cprintf>
    // STEP1: 重置pages中对应的page
    assert(n > 0);
  102f89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f8d:	75 24                	jne    102fb3 <buddy_free_pages+0x43>
  102f8f:	c7 44 24 0c de 75 10 	movl   $0x1075de,0xc(%esp)
  102f96:	00 
  102f97:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  102f9e:	00 
  102f9f:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  102fa6:	00 
  102fa7:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  102fae:	e8 37 dd ff ff       	call   100cea <__panic>
    n = 1 << ROUND_UP_LOG(n);
  102fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fb6:	89 04 24             	mov    %eax,(%esp)
  102fb9:	e8 e6 fa ff ff       	call   102aa4 <ROUND_UP_LOG>
  102fbe:	ba 01 00 00 00       	mov    $0x1,%edx
  102fc3:	88 c1                	mov    %al,%cl
  102fc5:	d3 e2                	shl    %cl,%edx
  102fc7:	89 d0                	mov    %edx,%eax
  102fc9:	89 45 0c             	mov    %eax,0xc(%ebp)
    // 保证base原先处于保留态
    assert(!PageReserved(base));
  102fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcf:	83 c0 04             	add    $0x4,%eax
  102fd2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102fdc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102fdf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fe2:	0f a3 10             	bt     %edx,(%eax)
  102fe5:	19 c0                	sbb    %eax,%eax
  102fe7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102fea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102fee:	0f 95 c0             	setne  %al
  102ff1:	0f b6 c0             	movzbl %al,%eax
  102ff4:	85 c0                	test   %eax,%eax
  102ff6:	74 24                	je     10301c <buddy_free_pages+0xac>
  102ff8:	c7 44 24 0c fc 75 10 	movl   $0x1075fc,0xc(%esp)
  102fff:	00 
  103000:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  103007:	00 
  103008:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
  10300f:	00 
  103010:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  103017:	e8 ce dc ff ff       	call   100cea <__panic>
    for (struct Page *p = base; p < base + n; p++)
  10301c:	8b 45 08             	mov    0x8(%ebp),%eax
  10301f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103022:	e9 93 00 00 00       	jmp    1030ba <buddy_free_pages+0x14a>
    {
        assert(!PageReserved(p) && !PageProperty(p)); //确认该帧已经被分配，且不是保留帧
  103027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10302a:	83 c0 04             	add    $0x4,%eax
  10302d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  103034:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103037:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10303a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10303d:	0f a3 10             	bt     %edx,(%eax)
  103040:	19 c0                	sbb    %eax,%eax
  103042:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103045:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103049:	0f 95 c0             	setne  %al
  10304c:	0f b6 c0             	movzbl %al,%eax
  10304f:	85 c0                	test   %eax,%eax
  103051:	75 2c                	jne    10307f <buddy_free_pages+0x10f>
  103053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103056:	83 c0 04             	add    $0x4,%eax
  103059:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  103060:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103063:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103066:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103069:	0f a3 10             	bt     %edx,(%eax)
  10306c:	19 c0                	sbb    %eax,%eax
  10306e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
  103071:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103075:	0f 95 c0             	setne  %al
  103078:	0f b6 c0             	movzbl %al,%eax
  10307b:	85 c0                	test   %eax,%eax
  10307d:	74 24                	je     1030a3 <buddy_free_pages+0x133>
  10307f:	c7 44 24 0c 10 76 10 	movl   $0x107610,0xc(%esp)
  103086:	00 
  103087:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  10308e:	00 
  10308f:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
  103096:	00 
  103097:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  10309e:	e8 47 dc ff ff       	call   100cea <__panic>
        // 在此作者（ZJK）认为：由于不需要property，将所有page的property flag置为0即可
        set_page_ref(p, 0);
  1030a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1030aa:	00 
  1030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030ae:	89 04 24             	mov    %eax,(%esp)
  1030b1:	e8 e0 f9 ff ff       	call   102a96 <set_page_ref>
    for (struct Page *p = base; p < base + n; p++)
  1030b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1030ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030bd:	89 d0                	mov    %edx,%eax
  1030bf:	c1 e0 02             	shl    $0x2,%eax
  1030c2:	01 d0                	add    %edx,%eax
  1030c4:	c1 e0 02             	shl    $0x2,%eax
  1030c7:	89 c2                	mov    %eax,%edx
  1030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030cc:	01 d0                	add    %edx,%eax
  1030ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1030d1:	0f 82 50 ff ff ff    	jb     103027 <buddy_free_pages+0xb7>
    }
    // STEP2: 将buddy中的对应节点释放
    // 自底向上寻找
    // 开始块序号
    unsigned offset = base - page_base;
  1030d7:	8b 15 84 ee 11 00    	mov    0x11ee84,%edx
  1030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e0:	29 d0                	sub    %edx,%eax
  1030e2:	c1 f8 02             	sar    $0x2,%eax
  1030e5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  1030eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // 对应叶节点
    unsigned index = manager_size / 2 + offset;
  1030ee:	a1 8c ee 11 00       	mov    0x11ee8c,%eax
  1030f3:	89 c2                	mov    %eax,%edx
  1030f5:	c1 ea 1f             	shr    $0x1f,%edx
  1030f8:	01 d0                	add    %edx,%eax
  1030fa:	d1 f8                	sar    %eax
  1030fc:	89 c2                	mov    %eax,%edx
  1030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103101:	01 d0                	add    %edx,%eax
  103103:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned node_size = 1;
  103106:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    // 找第一个值为0的节点
    while (node_size != n)
  10310d:	eb 35                	jmp    103144 <buddy_free_pages+0x1d4>
    {
        // 上溯
        index = PARENT(index);
  10310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103112:	d1 e8                	shr    %eax
  103114:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
  103117:	d1 65 ec             	shll   -0x14(%ebp)
        // 直到根节点都不为0，说明有误，中断
        assert(index);
  10311a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10311e:	75 24                	jne    103144 <buddy_free_pages+0x1d4>
  103120:	c7 44 24 0c 35 76 10 	movl   $0x107635,0xc(%esp)
  103127:	00 
  103128:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  10312f:	00 
  103130:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  103137:	00 
  103138:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  10313f:	e8 a6 db ff ff       	call   100cea <__panic>
    while (node_size != n)
  103144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103147:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10314a:	75 c3                	jne    10310f <buddy_free_pages+0x19f>
    }
    buddy_manager[index] = node_size;
  10314c:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103155:	c1 e0 02             	shl    $0x2,%eax
  103158:	01 c2                	add    %eax,%edx
  10315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315d:	89 02                	mov    %eax,(%edx)
    cprintf(" index:%u offset:%u ", index, offset);
  10315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103162:	89 44 24 08          	mov    %eax,0x8(%esp)
  103166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103169:	89 44 24 04          	mov    %eax,0x4(%esp)
  10316d:	c7 04 24 ba 75 10 00 	movl   $0x1075ba,(%esp)
  103174:	e8 ec d1 ff ff       	call   100365 <cprintf>
    // STEP3: 回溯直到根节点，更改沿途值
    index = PARENT(index);
  103179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317c:	d1 e8                	shr    %eax
  10317e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
  103181:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
  103184:	e9 86 00 00 00       	jmp    10320f <buddy_free_pages+0x29f>
    {
        unsigned leftSize = buddy_manager[LEFT_LEAF(index)];
  103189:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  10318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103192:	c1 e0 03             	shl    $0x3,%eax
  103195:	01 d0                	add    %edx,%eax
  103197:	8b 00                	mov    (%eax),%eax
  103199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned rightSize = buddy_manager[RIGHT_LEAF(index)];
  10319c:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031a5:	c1 e0 03             	shl    $0x3,%eax
  1031a8:	83 c0 04             	add    $0x4,%eax
  1031ab:	01 d0                	add    %edx,%eax
  1031ad:	8b 00                	mov    (%eax),%eax
  1031af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        // 左右节点均全空，连起来
        if (leftSize + rightSize == node_size)
  1031b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031b8:	01 d0                	add    %edx,%eax
  1031ba:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1031bd:	75 15                	jne    1031d4 <buddy_free_pages+0x264>
        {
            buddy_manager[index] = node_size;
  1031bf:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c8:	c1 e0 02             	shl    $0x2,%eax
  1031cb:	01 c2                	add    %eax,%edx
  1031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031d0:	89 02                	mov    %eax,(%edx)
  1031d2:	eb 30                	jmp    103204 <buddy_free_pages+0x294>
        }
        else if (leftSize > rightSize)
  1031d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  1031da:	76 15                	jbe    1031f1 <buddy_free_pages+0x281>
        {
            buddy_manager[index] = leftSize;
  1031dc:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e5:	c1 e0 02             	shl    $0x2,%eax
  1031e8:	01 c2                	add    %eax,%edx
  1031ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031ed:	89 02                	mov    %eax,(%edx)
  1031ef:	eb 13                	jmp    103204 <buddy_free_pages+0x294>
        }
        else
        {
            buddy_manager[index] = rightSize;
  1031f1:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031fa:	c1 e0 02             	shl    $0x2,%eax
  1031fd:	01 c2                	add    %eax,%edx
  1031ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103202:	89 02                	mov    %eax,(%edx)
        }
        index = PARENT(index);
  103204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103207:	d1 e8                	shr    %eax
  103209:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
  10320c:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
  10320f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103213:	0f 85 70 ff ff ff    	jne    103189 <buddy_free_pages+0x219>
    }
    // STEP4: 增加空闲页数，结束释放过程
    free_page_num += n;
  103219:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  10321e:	89 c2                	mov    %eax,%edx
  103220:	8b 45 0c             	mov    0xc(%ebp),%eax
  103223:	01 d0                	add    %edx,%eax
  103225:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    cprintf("finish!\n");
  10322a:	c7 04 24 e4 75 10 00 	movl   $0x1075e4,(%esp)
  103231:	e8 2f d1 ff ff       	call   100365 <cprintf>
}
  103236:	90                   	nop
  103237:	89 ec                	mov    %ebp,%esp
  103239:	5d                   	pop    %ebp
  10323a:	c3                   	ret    

0010323b <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
  10323b:	55                   	push   %ebp
  10323c:	89 e5                	mov    %esp,%ebp
    return free_page_num;
  10323e:	a1 88 ee 11 00       	mov    0x11ee88,%eax
}
  103243:	5d                   	pop    %ebp
  103244:	c3                   	ret    

00103245 <basic_check>:

static void
basic_check(void)
{
  103245:	55                   	push   %ebp
  103246:	89 e5                	mov    %esp,%ebp
}
  103248:	90                   	nop
  103249:	5d                   	pop    %ebp
  10324a:	c3                   	ret    

0010324b <buddy_check>:

static void
buddy_check(void)
{
  10324b:	55                   	push   %ebp
  10324c:	89 e5                	mov    %esp,%ebp
  10324e:	83 ec 38             	sub    $0x38,%esp
    cprintf("buddy check!\n");
  103251:	c7 04 24 3b 76 10 00 	movl   $0x10763b,(%esp)
  103258:	e8 08 d1 ff ff       	call   100365 <cprintf>
    struct Page *p0, *A, *B, *C, *D;
    p0 = A = B = C = D = NULL;
  10325d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103267:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10326d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103273:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103279:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
  10327c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103283:	e8 07 19 00 00       	call   104b8f <alloc_pages>
  103288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10328b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10328f:	75 24                	jne    1032b5 <buddy_check+0x6a>
  103291:	c7 44 24 0c 49 76 10 	movl   $0x107649,0xc(%esp)
  103298:	00 
  103299:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  1032a0:	00 
  1032a1:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  1032a8:	00 
  1032a9:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  1032b0:	e8 35 da ff ff       	call   100cea <__panic>
    assert((A = alloc_page()) != NULL);
  1032b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032bc:	e8 ce 18 00 00       	call   104b8f <alloc_pages>
  1032c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032c8:	75 24                	jne    1032ee <buddy_check+0xa3>
  1032ca:	c7 44 24 0c 65 76 10 	movl   $0x107665,0xc(%esp)
  1032d1:	00 
  1032d2:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  1032d9:	00 
  1032da:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1032e1:	00 
  1032e2:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  1032e9:	e8 fc d9 ff ff       	call   100cea <__panic>
    assert((B = alloc_page()) != NULL);
  1032ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032f5:	e8 95 18 00 00       	call   104b8f <alloc_pages>
  1032fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103301:	75 24                	jne    103327 <buddy_check+0xdc>
  103303:	c7 44 24 0c 80 76 10 	movl   $0x107680,0xc(%esp)
  10330a:	00 
  10330b:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  103312:	00 
  103313:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  10331a:	00 
  10331b:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  103322:	e8 c3 d9 ff ff       	call   100cea <__panic>

    assert(p0 != A && p0 != B && A != B);
  103327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10332a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  10332d:	74 10                	je     10333f <buddy_check+0xf4>
  10332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103332:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103335:	74 08                	je     10333f <buddy_check+0xf4>
  103337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10333a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10333d:	75 24                	jne    103363 <buddy_check+0x118>
  10333f:	c7 44 24 0c 9b 76 10 	movl   $0x10769b,0xc(%esp)
  103346:	00 
  103347:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  10334e:	00 
  10334f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103356:	00 
  103357:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  10335e:	e8 87 d9 ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
  103363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103366:	89 04 24             	mov    %eax,(%esp)
  103369:	e8 1e f7 ff ff       	call   102a8c <page_ref>
  10336e:	85 c0                	test   %eax,%eax
  103370:	75 1e                	jne    103390 <buddy_check+0x145>
  103372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103375:	89 04 24             	mov    %eax,(%esp)
  103378:	e8 0f f7 ff ff       	call   102a8c <page_ref>
  10337d:	85 c0                	test   %eax,%eax
  10337f:	75 0f                	jne    103390 <buddy_check+0x145>
  103381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103384:	89 04 24             	mov    %eax,(%esp)
  103387:	e8 00 f7 ff ff       	call   102a8c <page_ref>
  10338c:	85 c0                	test   %eax,%eax
  10338e:	74 24                	je     1033b4 <buddy_check+0x169>
  103390:	c7 44 24 0c b8 76 10 	movl   $0x1076b8,0xc(%esp)
  103397:	00 
  103398:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  10339f:	00 
  1033a0:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1033a7:	00 
  1033a8:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  1033af:	e8 36 d9 ff ff       	call   100cea <__panic>

    free_page(p0);
  1033b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033bb:	00 
  1033bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033bf:	89 04 24             	mov    %eax,(%esp)
  1033c2:	e8 02 18 00 00       	call   104bc9 <free_pages>
    free_page(A);
  1033c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033ce:	00 
  1033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d2:	89 04 24             	mov    %eax,(%esp)
  1033d5:	e8 ef 17 00 00       	call   104bc9 <free_pages>
    free_page(B);
  1033da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033e1:	00 
  1033e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e5:	89 04 24             	mov    %eax,(%esp)
  1033e8:	e8 dc 17 00 00       	call   104bc9 <free_pages>

    A = alloc_pages(512);
  1033ed:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  1033f4:	e8 96 17 00 00       	call   104b8f <alloc_pages>
  1033f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(512);
  1033fc:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  103403:	e8 87 17 00 00       	call   104b8f <alloc_pages>
  103408:	89 45 ec             	mov    %eax,-0x14(%ebp)
    free_pages(A, 256);
  10340b:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103412:	00 
  103413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103416:	89 04 24             	mov    %eax,(%esp)
  103419:	e8 ab 17 00 00       	call   104bc9 <free_pages>
    free_pages(B, 512);
  10341e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103425:	00 
  103426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103429:	89 04 24             	mov    %eax,(%esp)
  10342c:	e8 98 17 00 00       	call   104bc9 <free_pages>
    free_pages(A + 256, 256);
  103431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103434:	05 00 14 00 00       	add    $0x1400,%eax
  103439:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103440:	00 
  103441:	89 04 24             	mov    %eax,(%esp)
  103444:	e8 80 17 00 00       	call   104bc9 <free_pages>

    p0 = alloc_pages(8192);
  103449:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
  103450:	e8 3a 17 00 00       	call   104b8f <alloc_pages>
  103455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 == A);
  103458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10345b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  10345e:	74 24                	je     103484 <buddy_check+0x239>
  103460:	c7 44 24 0c f2 76 10 	movl   $0x1076f2,0xc(%esp)
  103467:	00 
  103468:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  10346f:	00 
  103470:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103477:	00 
  103478:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  10347f:	e8 66 d8 ff ff       	call   100cea <__panic>
    // free_pages(p0, 1024);
    //以下是根据链接中的样例测试编写的
    A = alloc_pages(128);
  103484:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  10348b:	e8 ff 16 00 00       	call   104b8f <alloc_pages>
  103490:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(64);
  103493:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  10349a:	e8 f0 16 00 00       	call   104b8f <alloc_pages>
  10349f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 检查是否相邻
    assert(A + 128 == B);
  1034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034a5:	05 00 0a 00 00       	add    $0xa00,%eax
  1034aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1034ad:	74 24                	je     1034d3 <buddy_check+0x288>
  1034af:	c7 44 24 0c fa 76 10 	movl   $0x1076fa,0xc(%esp)
  1034b6:	00 
  1034b7:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  1034be:	00 
  1034bf:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1034c6:	00 
  1034c7:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  1034ce:	e8 17 d8 ff ff       	call   100cea <__panic>
    C = alloc_pages(128);
  1034d3:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  1034da:	e8 b0 16 00 00       	call   104b8f <alloc_pages>
  1034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C有没有和A重叠
    assert(A + 256 == C);
  1034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e5:	05 00 14 00 00       	add    $0x1400,%eax
  1034ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1034ed:	74 24                	je     103513 <buddy_check+0x2c8>
  1034ef:	c7 44 24 0c 07 77 10 	movl   $0x107707,0xc(%esp)
  1034f6:	00 
  1034f7:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  1034fe:	00 
  1034ff:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  103506:	00 
  103507:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  10350e:	e8 d7 d7 ff ff       	call   100cea <__panic>
    // 释放A
    free_pages(A, 128);
  103513:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  10351a:	00 
  10351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10351e:	89 04 24             	mov    %eax,(%esp)
  103521:	e8 a3 16 00 00       	call   104bc9 <free_pages>
    D = alloc_pages(64);
  103526:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  10352d:	e8 5d 16 00 00       	call   104b8f <alloc_pages>
  103532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n", D);
  103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103538:	89 44 24 04          	mov    %eax,0x4(%esp)
  10353c:	c7 04 24 14 77 10 00 	movl   $0x107714,(%esp)
  103543:	e8 1d ce ff ff       	call   100365 <cprintf>
    // 检查D是否能够使用A刚刚释放的内存
    assert(D + 128 == B);
  103548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10354b:	05 00 0a 00 00       	add    $0xa00,%eax
  103550:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103553:	74 24                	je     103579 <buddy_check+0x32e>
  103555:	c7 44 24 0c 1a 77 10 	movl   $0x10771a,0xc(%esp)
  10355c:	00 
  10355d:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  103564:	00 
  103565:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  10356c:	00 
  10356d:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  103574:	e8 71 d7 ff ff       	call   100cea <__panic>
    free_pages(C, 128);
  103579:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  103580:	00 
  103581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103584:	89 04 24             	mov    %eax,(%esp)
  103587:	e8 3d 16 00 00       	call   104bc9 <free_pages>
    C = alloc_pages(64);
  10358c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  103593:	e8 f7 15 00 00       	call   104b8f <alloc_pages>
  103598:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C是否在B、D之间
    assert(C == D + 64 && C == B - 64);
  10359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10359e:	05 00 05 00 00       	add    $0x500,%eax
  1035a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1035a6:	75 0d                	jne    1035b5 <buddy_check+0x36a>
  1035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035ab:	2d 00 05 00 00       	sub    $0x500,%eax
  1035b0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1035b3:	74 24                	je     1035d9 <buddy_check+0x38e>
  1035b5:	c7 44 24 0c 27 77 10 	movl   $0x107727,0xc(%esp)
  1035bc:	00 
  1035bd:	c7 44 24 08 d1 74 10 	movl   $0x1074d1,0x8(%esp)
  1035c4:	00 
  1035c5:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1035cc:	00 
  1035cd:	c7 04 24 e6 74 10 00 	movl   $0x1074e6,(%esp)
  1035d4:	e8 11 d7 ff ff       	call   100cea <__panic>
    free_pages(B, 64);
  1035d9:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  1035e0:	00 
  1035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035e4:	89 04 24             	mov    %eax,(%esp)
  1035e7:	e8 dd 15 00 00       	call   104bc9 <free_pages>
    free_pages(D, 64);
  1035ec:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  1035f3:	00 
  1035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035f7:	89 04 24             	mov    %eax,(%esp)
  1035fa:	e8 ca 15 00 00       	call   104bc9 <free_pages>
    free_pages(C, 64);
  1035ff:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  103606:	00 
  103607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10360a:	89 04 24             	mov    %eax,(%esp)
  10360d:	e8 b7 15 00 00       	call   104bc9 <free_pages>
    // 全部释放
    free_pages(p0, 8192);
  103612:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
  103619:	00 
  10361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10361d:	89 04 24             	mov    %eax,(%esp)
  103620:	e8 a4 15 00 00       	call   104bc9 <free_pages>
}
  103625:	90                   	nop
  103626:	89 ec                	mov    %ebp,%esp
  103628:	5d                   	pop    %ebp
  103629:	c3                   	ret    

0010362a <page2ppn>:
page2ppn(struct Page *page) {
  10362a:	55                   	push   %ebp
  10362b:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10362d:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  103633:	8b 45 08             	mov    0x8(%ebp),%eax
  103636:	29 d0                	sub    %edx,%eax
  103638:	c1 f8 02             	sar    $0x2,%eax
  10363b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103641:	5d                   	pop    %ebp
  103642:	c3                   	ret    

00103643 <page2pa>:
page2pa(struct Page *page) {
  103643:	55                   	push   %ebp
  103644:	89 e5                	mov    %esp,%ebp
  103646:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103649:	8b 45 08             	mov    0x8(%ebp),%eax
  10364c:	89 04 24             	mov    %eax,(%esp)
  10364f:	e8 d6 ff ff ff       	call   10362a <page2ppn>
  103654:	c1 e0 0c             	shl    $0xc,%eax
}
  103657:	89 ec                	mov    %ebp,%esp
  103659:	5d                   	pop    %ebp
  10365a:	c3                   	ret    

0010365b <page_ref>:
page_ref(struct Page *page) {
  10365b:	55                   	push   %ebp
  10365c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10365e:	8b 45 08             	mov    0x8(%ebp),%eax
  103661:	8b 00                	mov    (%eax),%eax
}
  103663:	5d                   	pop    %ebp
  103664:	c3                   	ret    

00103665 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103665:	55                   	push   %ebp
  103666:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103668:	8b 45 08             	mov    0x8(%ebp),%eax
  10366b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10366e:	89 10                	mov    %edx,(%eax)
}
  103670:	90                   	nop
  103671:	5d                   	pop    %ebp
  103672:	c3                   	ret    

00103673 <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
  103673:	55                   	push   %ebp
  103674:	89 e5                	mov    %esp,%ebp
  103676:	83 ec 10             	sub    $0x10,%esp
  103679:	c7 45 fc 90 ee 11 00 	movl   $0x11ee90,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
  103680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103683:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103686:	89 50 04             	mov    %edx,0x4(%eax)
  103689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10368c:	8b 50 04             	mov    0x4(%eax),%edx
  10368f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103692:	89 10                	mov    %edx,(%eax)
}
  103694:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  103695:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  10369c:	00 00 00 
}
  10369f:	90                   	nop
  1036a0:	89 ec                	mov    %ebp,%esp
  1036a2:	5d                   	pop    %ebp
  1036a3:	c3                   	ret    

001036a4 <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
  1036a4:	55                   	push   %ebp
  1036a5:	89 e5                	mov    %esp,%ebp
  1036a7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1036aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1036ae:	75 24                	jne    1036d4 <default_init_memmap+0x30>
  1036b0:	c7 44 24 0c 70 77 10 	movl   $0x107770,0xc(%esp)
  1036b7:	00 
  1036b8:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1036bf:	00 
  1036c0:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1036c7:	00 
  1036c8:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1036cf:	e8 16 d6 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  1036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  1036da:	eb 7b                	jmp    103757 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
  1036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036df:	83 c0 04             	add    $0x4,%eax
  1036e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1036e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1036ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1036f2:	0f a3 10             	bt     %edx,(%eax)
  1036f5:	19 c0                	sbb    %eax,%eax
  1036f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1036fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036fe:	0f 95 c0             	setne  %al
  103701:	0f b6 c0             	movzbl %al,%eax
  103704:	85 c0                	test   %eax,%eax
  103706:	75 24                	jne    10372c <default_init_memmap+0x88>
  103708:	c7 44 24 0c a1 77 10 	movl   $0x1077a1,0xc(%esp)
  10370f:	00 
  103710:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103717:	00 
  103718:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  10371f:	00 
  103720:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103727:	e8 be d5 ff ff       	call   100cea <__panic>
        p->flags = 0;
  10372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10372f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
  103736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103739:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
  103740:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103747:	00 
  103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10374b:	89 04 24             	mov    %eax,(%esp)
  10374e:	e8 12 ff ff ff       	call   103665 <set_page_ref>
    for (; p != base + n; p++)
  103753:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  103757:	8b 55 0c             	mov    0xc(%ebp),%edx
  10375a:	89 d0                	mov    %edx,%eax
  10375c:	c1 e0 02             	shl    $0x2,%eax
  10375f:	01 d0                	add    %edx,%eax
  103761:	c1 e0 02             	shl    $0x2,%eax
  103764:	89 c2                	mov    %eax,%edx
  103766:	8b 45 08             	mov    0x8(%ebp),%eax
  103769:	01 d0                	add    %edx,%eax
  10376b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10376e:	0f 85 68 ff ff ff    	jne    1036dc <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
  103774:	8b 45 08             	mov    0x8(%ebp),%eax
  103777:	83 c0 04             	add    $0x4,%eax
  10377a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103781:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  103784:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103787:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10378a:	0f ab 10             	bts    %edx,(%eax)
}
  10378d:	90                   	nop
    base->property = n;
  10378e:	8b 45 08             	mov    0x8(%ebp),%eax
  103791:	8b 55 0c             	mov    0xc(%ebp),%edx
  103794:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  103797:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  10379d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037a0:	01 d0                	add    %edx,%eax
  1037a2:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
  1037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1037aa:	83 c0 0c             	add    $0xc,%eax
  1037ad:	c7 45 e4 90 ee 11 00 	movl   $0x11ee90,-0x1c(%ebp)
  1037b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
  1037b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037ba:	8b 00                	mov    (%eax),%eax
  1037bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1037bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1037c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
  1037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1037d1:	89 10                	mov    %edx,(%eax)
  1037d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037d6:	8b 10                	mov    (%eax),%edx
  1037d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1037de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1037e4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1037e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1037ed:	89 10                	mov    %edx,(%eax)
}
  1037ef:	90                   	nop
}
  1037f0:	90                   	nop
}
  1037f1:	90                   	nop
  1037f2:	89 ec                	mov    %ebp,%esp
  1037f4:	5d                   	pop    %ebp
  1037f5:	c3                   	ret    

001037f6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  1037f6:	55                   	push   %ebp
  1037f7:	89 e5                	mov    %esp,%ebp
  1037f9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1037fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103800:	75 24                	jne    103826 <default_alloc_pages+0x30>
  103802:	c7 44 24 0c 70 77 10 	movl   $0x107770,0xc(%esp)
  103809:	00 
  10380a:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103811:	00 
  103812:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  103819:	00 
  10381a:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103821:	e8 c4 d4 ff ff       	call   100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
  103826:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  10382b:	39 45 08             	cmp    %eax,0x8(%ebp)
  10382e:	76 0a                	jbe    10383a <default_alloc_pages+0x44>
    {
        return NULL;
  103830:	b8 00 00 00 00       	mov    $0x0,%eax
  103835:	e9 43 01 00 00       	jmp    10397d <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  10383a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  103841:	c7 45 f0 90 ee 11 00 	movl   $0x11ee90,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  103848:	eb 1c                	jmp    103866 <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
  10384a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10384d:	83 e8 0c             	sub    $0xc,%eax
  103850:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  103853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103856:	8b 40 08             	mov    0x8(%eax),%eax
  103859:	39 45 08             	cmp    %eax,0x8(%ebp)
  10385c:	77 08                	ja     103866 <default_alloc_pages+0x70>
        {
            page = p;
  10385e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103861:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  103864:	eb 18                	jmp    10387e <default_alloc_pages+0x88>
  103866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  10386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10386f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103875:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  10387c:	75 cc                	jne    10384a <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
  10387e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103882:	0f 84 f2 00 00 00    	je     10397a <default_alloc_pages+0x184>
    {
        if (page->property > n)
  103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10388b:	8b 40 08             	mov    0x8(%eax),%eax
  10388e:	39 45 08             	cmp    %eax,0x8(%ebp)
  103891:	0f 83 8f 00 00 00    	jae    103926 <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
  103897:	8b 55 08             	mov    0x8(%ebp),%edx
  10389a:	89 d0                	mov    %edx,%eax
  10389c:	c1 e0 02             	shl    $0x2,%eax
  10389f:	01 d0                	add    %edx,%eax
  1038a1:	c1 e0 02             	shl    $0x2,%eax
  1038a4:	89 c2                	mov    %eax,%edx
  1038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038a9:	01 d0                	add    %edx,%eax
  1038ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038b1:	8b 40 08             	mov    0x8(%eax),%eax
  1038b4:	2b 45 08             	sub    0x8(%ebp),%eax
  1038b7:	89 c2                	mov    %eax,%edx
  1038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038bc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  1038bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038c2:	83 c0 0c             	add    $0xc,%eax
  1038c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1038c8:	83 c2 0c             	add    $0xc,%edx
  1038cb:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1038ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  1038d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038d4:	8b 40 04             	mov    0x4(%eax),%eax
  1038d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1038da:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1038dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1038e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1038e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  1038e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1038e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1038ec:	89 10                	mov    %edx,(%eax)
  1038ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1038f1:	8b 10                	mov    (%eax),%edx
  1038f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1038f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1038f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1038fc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1038ff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103902:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103905:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103908:	89 10                	mov    %edx,(%eax)
}
  10390a:	90                   	nop
}
  10390b:	90                   	nop
            SetPageProperty(p);
  10390c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10390f:	83 c0 04             	add    $0x4,%eax
  103912:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  103919:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
  10391c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10391f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103922:	0f ab 10             	bts    %edx,(%eax)
}
  103925:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
  103926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103929:	83 c0 0c             	add    $0xc,%eax
  10392c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  10392f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103932:	8b 40 04             	mov    0x4(%eax),%eax
  103935:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103938:	8b 12                	mov    (%edx),%edx
  10393a:	89 55 b8             	mov    %edx,-0x48(%ebp)
  10393d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
  103940:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103943:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103946:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103949:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10394c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10394f:	89 10                	mov    %edx,(%eax)
}
  103951:	90                   	nop
}
  103952:	90                   	nop
        nr_free -= n;
  103953:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103958:	2b 45 08             	sub    0x8(%ebp),%eax
  10395b:	a3 98 ee 11 00       	mov    %eax,0x11ee98
        ClearPageProperty(page);
  103960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103963:	83 c0 04             	add    $0x4,%eax
  103966:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  10396d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
  103970:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103973:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103976:	0f b3 10             	btr    %edx,(%eax)
}
  103979:	90                   	nop
    }
    return page;
  10397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10397d:	89 ec                	mov    %ebp,%esp
  10397f:	5d                   	pop    %ebp
  103980:	c3                   	ret    

00103981 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  103981:	55                   	push   %ebp
  103982:	89 e5                	mov    %esp,%ebp
  103984:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  10398a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10398e:	75 24                	jne    1039b4 <default_free_pages+0x33>
  103990:	c7 44 24 0c 70 77 10 	movl   $0x107770,0xc(%esp)
  103997:	00 
  103998:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  10399f:	00 
  1039a0:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  1039a7:	00 
  1039a8:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1039af:	e8 36 d3 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  1039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1039b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  1039ba:	e9 9d 00 00 00       	jmp    103a5c <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  1039bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039c2:	83 c0 04             	add    $0x4,%eax
  1039c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1039cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1039cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1039d5:	0f a3 10             	bt     %edx,(%eax)
  1039d8:	19 c0                	sbb    %eax,%eax
  1039da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1039dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1039e1:	0f 95 c0             	setne  %al
  1039e4:	0f b6 c0             	movzbl %al,%eax
  1039e7:	85 c0                	test   %eax,%eax
  1039e9:	75 2c                	jne    103a17 <default_free_pages+0x96>
  1039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039ee:	83 c0 04             	add    $0x4,%eax
  1039f1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1039f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1039fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103a01:	0f a3 10             	bt     %edx,(%eax)
  103a04:	19 c0                	sbb    %eax,%eax
  103a06:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  103a09:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103a0d:	0f 95 c0             	setne  %al
  103a10:	0f b6 c0             	movzbl %al,%eax
  103a13:	85 c0                	test   %eax,%eax
  103a15:	74 24                	je     103a3b <default_free_pages+0xba>
  103a17:	c7 44 24 0c b4 77 10 	movl   $0x1077b4,0xc(%esp)
  103a1e:	00 
  103a1f:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103a26:	00 
  103a27:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  103a2e:	00 
  103a2f:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103a36:	e8 af d2 ff ff       	call   100cea <__panic>
        p->flags = 0;
  103a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  103a45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a4c:	00 
  103a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a50:	89 04 24             	mov    %eax,(%esp)
  103a53:	e8 0d fc ff ff       	call   103665 <set_page_ref>
    for (; p != base + n; p++)
  103a58:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  103a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a5f:	89 d0                	mov    %edx,%eax
  103a61:	c1 e0 02             	shl    $0x2,%eax
  103a64:	01 d0                	add    %edx,%eax
  103a66:	c1 e0 02             	shl    $0x2,%eax
  103a69:	89 c2                	mov    %eax,%edx
  103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a6e:	01 d0                	add    %edx,%eax
  103a70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a73:	0f 85 46 ff ff ff    	jne    1039bf <default_free_pages+0x3e>
    }
    base->property = n;
  103a79:	8b 45 08             	mov    0x8(%ebp),%eax
  103a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a7f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  103a82:	8b 45 08             	mov    0x8(%ebp),%eax
  103a85:	83 c0 04             	add    $0x4,%eax
  103a88:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103a8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  103a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103a95:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103a98:	0f ab 10             	bts    %edx,(%eax)
}
  103a9b:	90                   	nop
  103a9c:	c7 45 d4 90 ee 11 00 	movl   $0x11ee90,-0x2c(%ebp)
    return listelm->next;
  103aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103aa6:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  103aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
  103aac:	e9 0e 01 00 00       	jmp    103bbf <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
  103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ab4:	83 e8 0c             	sub    $0xc,%eax
  103ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103abd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ac0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103ac3:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  103ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
  103ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  103acc:	8b 50 08             	mov    0x8(%eax),%edx
  103acf:	89 d0                	mov    %edx,%eax
  103ad1:	c1 e0 02             	shl    $0x2,%eax
  103ad4:	01 d0                	add    %edx,%eax
  103ad6:	c1 e0 02             	shl    $0x2,%eax
  103ad9:	89 c2                	mov    %eax,%edx
  103adb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ade:	01 d0                	add    %edx,%eax
  103ae0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103ae3:	75 5d                	jne    103b42 <default_free_pages+0x1c1>
        {
            base->property += p->property;
  103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae8:	8b 50 08             	mov    0x8(%eax),%edx
  103aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aee:	8b 40 08             	mov    0x8(%eax),%eax
  103af1:	01 c2                	add    %eax,%edx
  103af3:	8b 45 08             	mov    0x8(%ebp),%eax
  103af6:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103afc:	83 c0 04             	add    $0x4,%eax
  103aff:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  103b06:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
  103b09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103b0c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103b0f:	0f b3 10             	btr    %edx,(%eax)
}
  103b12:	90                   	nop
            list_del(&(p->page_link));
  103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b16:	83 c0 0c             	add    $0xc,%eax
  103b19:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  103b1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103b1f:	8b 40 04             	mov    0x4(%eax),%eax
  103b22:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103b25:	8b 12                	mov    (%edx),%edx
  103b27:	89 55 c0             	mov    %edx,-0x40(%ebp)
  103b2a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  103b2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103b30:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103b33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103b36:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103b39:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103b3c:	89 10                	mov    %edx,(%eax)
}
  103b3e:	90                   	nop
}
  103b3f:	90                   	nop
  103b40:	eb 7d                	jmp    103bbf <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
  103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b45:	8b 50 08             	mov    0x8(%eax),%edx
  103b48:	89 d0                	mov    %edx,%eax
  103b4a:	c1 e0 02             	shl    $0x2,%eax
  103b4d:	01 d0                	add    %edx,%eax
  103b4f:	c1 e0 02             	shl    $0x2,%eax
  103b52:	89 c2                	mov    %eax,%edx
  103b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b57:	01 d0                	add    %edx,%eax
  103b59:	39 45 08             	cmp    %eax,0x8(%ebp)
  103b5c:	75 61                	jne    103bbf <default_free_pages+0x23e>
        {
            p->property += base->property;
  103b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b61:	8b 50 08             	mov    0x8(%eax),%edx
  103b64:	8b 45 08             	mov    0x8(%ebp),%eax
  103b67:	8b 40 08             	mov    0x8(%eax),%eax
  103b6a:	01 c2                	add    %eax,%edx
  103b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b6f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  103b72:	8b 45 08             	mov    0x8(%ebp),%eax
  103b75:	83 c0 04             	add    $0x4,%eax
  103b78:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  103b7f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
  103b82:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103b85:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103b88:	0f b3 10             	btr    %edx,(%eax)
}
  103b8b:	90                   	nop
            base = p;
  103b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b8f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  103b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b95:	83 c0 0c             	add    $0xc,%eax
  103b98:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  103b9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103b9e:	8b 40 04             	mov    0x4(%eax),%eax
  103ba1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103ba4:	8b 12                	mov    (%edx),%edx
  103ba6:	89 55 ac             	mov    %edx,-0x54(%ebp)
  103ba9:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  103bac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103baf:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103bb2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103bb5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103bb8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103bbb:	89 10                	mov    %edx,(%eax)
}
  103bbd:	90                   	nop
}
  103bbe:	90                   	nop
    while (le != &free_list)
  103bbf:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103bc6:	0f 85 e5 fe ff ff    	jne    103ab1 <default_free_pages+0x130>
        }
    }
    le = &free_list;
  103bcc:	c7 45 f0 90 ee 11 00 	movl   $0x11ee90,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
  103bd3:	eb 25                	jmp    103bfa <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
  103bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bd8:	83 e8 0c             	sub    $0xc,%eax
  103bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
  103bde:	8b 45 08             	mov    0x8(%ebp),%eax
  103be1:	8b 50 08             	mov    0x8(%eax),%edx
  103be4:	89 d0                	mov    %edx,%eax
  103be6:	c1 e0 02             	shl    $0x2,%eax
  103be9:	01 d0                	add    %edx,%eax
  103beb:	c1 e0 02             	shl    $0x2,%eax
  103bee:	89 c2                	mov    %eax,%edx
  103bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf3:	01 d0                	add    %edx,%eax
  103bf5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103bf8:	73 1a                	jae    103c14 <default_free_pages+0x293>
  103bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bfd:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  103c00:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103c03:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c09:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103c10:	75 c3                	jne    103bd5 <default_free_pages+0x254>
  103c12:	eb 01                	jmp    103c15 <default_free_pages+0x294>
        {
            break;
  103c14:	90                   	nop
        }
    }
    nr_free += n;
  103c15:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  103c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c1e:	01 d0                	add    %edx,%eax
  103c20:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    list_add_before(le, &(base->page_link));
  103c25:	8b 45 08             	mov    0x8(%ebp),%eax
  103c28:	8d 50 0c             	lea    0xc(%eax),%edx
  103c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c2e:	89 45 98             	mov    %eax,-0x68(%ebp)
  103c31:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  103c34:	8b 45 98             	mov    -0x68(%ebp),%eax
  103c37:	8b 00                	mov    (%eax),%eax
  103c39:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103c3c:	89 55 90             	mov    %edx,-0x70(%ebp)
  103c3f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  103c42:	8b 45 98             	mov    -0x68(%ebp),%eax
  103c45:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
  103c48:	8b 45 88             	mov    -0x78(%ebp),%eax
  103c4b:	8b 55 90             	mov    -0x70(%ebp),%edx
  103c4e:	89 10                	mov    %edx,(%eax)
  103c50:	8b 45 88             	mov    -0x78(%ebp),%eax
  103c53:	8b 10                	mov    (%eax),%edx
  103c55:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103c58:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103c5b:	8b 45 90             	mov    -0x70(%ebp),%eax
  103c5e:	8b 55 88             	mov    -0x78(%ebp),%edx
  103c61:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103c64:	8b 45 90             	mov    -0x70(%ebp),%eax
  103c67:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103c6a:	89 10                	mov    %edx,(%eax)
}
  103c6c:	90                   	nop
}
  103c6d:	90                   	nop
}
  103c6e:	90                   	nop
  103c6f:	89 ec                	mov    %ebp,%esp
  103c71:	5d                   	pop    %ebp
  103c72:	c3                   	ret    

00103c73 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  103c73:	55                   	push   %ebp
  103c74:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103c76:	a1 98 ee 11 00       	mov    0x11ee98,%eax
}
  103c7b:	5d                   	pop    %ebp
  103c7c:	c3                   	ret    

00103c7d <basic_check>:

static void
basic_check(void)
{
  103c7d:	55                   	push   %ebp
  103c7e:	89 e5                	mov    %esp,%ebp
  103c80:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103c96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c9d:	e8 ed 0e 00 00       	call   104b8f <alloc_pages>
  103ca2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ca5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103ca9:	75 24                	jne    103ccf <basic_check+0x52>
  103cab:	c7 44 24 0c d9 77 10 	movl   $0x1077d9,0xc(%esp)
  103cb2:	00 
  103cb3:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103cba:	00 
  103cbb:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103cc2:	00 
  103cc3:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103cca:	e8 1b d0 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  103ccf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103cd6:	e8 b4 0e 00 00       	call   104b8f <alloc_pages>
  103cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103cde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103ce2:	75 24                	jne    103d08 <basic_check+0x8b>
  103ce4:	c7 44 24 0c f5 77 10 	movl   $0x1077f5,0xc(%esp)
  103ceb:	00 
  103cec:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103cf3:	00 
  103cf4:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103cfb:	00 
  103cfc:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103d03:	e8 e2 cf ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  103d08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103d0f:	e8 7b 0e 00 00       	call   104b8f <alloc_pages>
  103d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103d1b:	75 24                	jne    103d41 <basic_check+0xc4>
  103d1d:	c7 44 24 0c 11 78 10 	movl   $0x107811,0xc(%esp)
  103d24:	00 
  103d25:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103d2c:	00 
  103d2d:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103d34:	00 
  103d35:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103d3c:	e8 a9 cf ff ff       	call   100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103d47:	74 10                	je     103d59 <basic_check+0xdc>
  103d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d4f:	74 08                	je     103d59 <basic_check+0xdc>
  103d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d57:	75 24                	jne    103d7d <basic_check+0x100>
  103d59:	c7 44 24 0c 30 78 10 	movl   $0x107830,0xc(%esp)
  103d60:	00 
  103d61:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103d68:	00 
  103d69:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103d70:	00 
  103d71:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103d78:	e8 6d cf ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d80:	89 04 24             	mov    %eax,(%esp)
  103d83:	e8 d3 f8 ff ff       	call   10365b <page_ref>
  103d88:	85 c0                	test   %eax,%eax
  103d8a:	75 1e                	jne    103daa <basic_check+0x12d>
  103d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d8f:	89 04 24             	mov    %eax,(%esp)
  103d92:	e8 c4 f8 ff ff       	call   10365b <page_ref>
  103d97:	85 c0                	test   %eax,%eax
  103d99:	75 0f                	jne    103daa <basic_check+0x12d>
  103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d9e:	89 04 24             	mov    %eax,(%esp)
  103da1:	e8 b5 f8 ff ff       	call   10365b <page_ref>
  103da6:	85 c0                	test   %eax,%eax
  103da8:	74 24                	je     103dce <basic_check+0x151>
  103daa:	c7 44 24 0c 54 78 10 	movl   $0x107854,0xc(%esp)
  103db1:	00 
  103db2:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103db9:	00 
  103dba:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103dc1:	00 
  103dc2:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103dc9:	e8 1c cf ff ff       	call   100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103dd1:	89 04 24             	mov    %eax,(%esp)
  103dd4:	e8 6a f8 ff ff       	call   103643 <page2pa>
  103dd9:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103ddf:	c1 e2 0c             	shl    $0xc,%edx
  103de2:	39 d0                	cmp    %edx,%eax
  103de4:	72 24                	jb     103e0a <basic_check+0x18d>
  103de6:	c7 44 24 0c 90 78 10 	movl   $0x107890,0xc(%esp)
  103ded:	00 
  103dee:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103df5:	00 
  103df6:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103dfd:	00 
  103dfe:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103e05:	e8 e0 ce ff ff       	call   100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e0d:	89 04 24             	mov    %eax,(%esp)
  103e10:	e8 2e f8 ff ff       	call   103643 <page2pa>
  103e15:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103e1b:	c1 e2 0c             	shl    $0xc,%edx
  103e1e:	39 d0                	cmp    %edx,%eax
  103e20:	72 24                	jb     103e46 <basic_check+0x1c9>
  103e22:	c7 44 24 0c ad 78 10 	movl   $0x1078ad,0xc(%esp)
  103e29:	00 
  103e2a:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103e31:	00 
  103e32:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103e39:	00 
  103e3a:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103e41:	e8 a4 ce ff ff       	call   100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e49:	89 04 24             	mov    %eax,(%esp)
  103e4c:	e8 f2 f7 ff ff       	call   103643 <page2pa>
  103e51:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103e57:	c1 e2 0c             	shl    $0xc,%edx
  103e5a:	39 d0                	cmp    %edx,%eax
  103e5c:	72 24                	jb     103e82 <basic_check+0x205>
  103e5e:	c7 44 24 0c ca 78 10 	movl   $0x1078ca,0xc(%esp)
  103e65:	00 
  103e66:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103e6d:	00 
  103e6e:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103e75:	00 
  103e76:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103e7d:	e8 68 ce ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  103e82:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  103e87:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  103e8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e90:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103e93:	c7 45 dc 90 ee 11 00 	movl   $0x11ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103e9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ea0:	89 50 04             	mov    %edx,0x4(%eax)
  103ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ea6:	8b 50 04             	mov    0x4(%eax),%edx
  103ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103eac:	89 10                	mov    %edx,(%eax)
}
  103eae:	90                   	nop
  103eaf:	c7 45 e0 90 ee 11 00 	movl   $0x11ee90,-0x20(%ebp)
    return list->next == list;
  103eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103eb9:	8b 40 04             	mov    0x4(%eax),%eax
  103ebc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103ebf:	0f 94 c0             	sete   %al
  103ec2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103ec5:	85 c0                	test   %eax,%eax
  103ec7:	75 24                	jne    103eed <basic_check+0x270>
  103ec9:	c7 44 24 0c e7 78 10 	movl   $0x1078e7,0xc(%esp)
  103ed0:	00 
  103ed1:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103ed8:	00 
  103ed9:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103ee0:	00 
  103ee1:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103ee8:	e8 fd cd ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  103eed:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103ef5:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  103efc:	00 00 00 

    assert(alloc_page() == NULL);
  103eff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f06:	e8 84 0c 00 00       	call   104b8f <alloc_pages>
  103f0b:	85 c0                	test   %eax,%eax
  103f0d:	74 24                	je     103f33 <basic_check+0x2b6>
  103f0f:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  103f16:	00 
  103f17:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103f1e:	00 
  103f1f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103f26:	00 
  103f27:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103f2e:	e8 b7 cd ff ff       	call   100cea <__panic>

    free_page(p0);
  103f33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f3a:	00 
  103f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f3e:	89 04 24             	mov    %eax,(%esp)
  103f41:	e8 83 0c 00 00       	call   104bc9 <free_pages>
    free_page(p1);
  103f46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f4d:	00 
  103f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f51:	89 04 24             	mov    %eax,(%esp)
  103f54:	e8 70 0c 00 00       	call   104bc9 <free_pages>
    free_page(p2);
  103f59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f60:	00 
  103f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f64:	89 04 24             	mov    %eax,(%esp)
  103f67:	e8 5d 0c 00 00       	call   104bc9 <free_pages>
    assert(nr_free == 3);
  103f6c:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103f71:	83 f8 03             	cmp    $0x3,%eax
  103f74:	74 24                	je     103f9a <basic_check+0x31d>
  103f76:	c7 44 24 0c 13 79 10 	movl   $0x107913,0xc(%esp)
  103f7d:	00 
  103f7e:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103f85:	00 
  103f86:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103f8d:	00 
  103f8e:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103f95:	e8 50 cd ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
  103f9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fa1:	e8 e9 0b 00 00       	call   104b8f <alloc_pages>
  103fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103fa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103fad:	75 24                	jne    103fd3 <basic_check+0x356>
  103faf:	c7 44 24 0c d9 77 10 	movl   $0x1077d9,0xc(%esp)
  103fb6:	00 
  103fb7:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103fbe:	00 
  103fbf:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103fc6:	00 
  103fc7:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  103fce:	e8 17 cd ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  103fd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fda:	e8 b0 0b 00 00       	call   104b8f <alloc_pages>
  103fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fe2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fe6:	75 24                	jne    10400c <basic_check+0x38f>
  103fe8:	c7 44 24 0c f5 77 10 	movl   $0x1077f5,0xc(%esp)
  103fef:	00 
  103ff0:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  103ff7:	00 
  103ff8:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103fff:	00 
  104000:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104007:	e8 de cc ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  10400c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104013:	e8 77 0b 00 00       	call   104b8f <alloc_pages>
  104018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10401b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10401f:	75 24                	jne    104045 <basic_check+0x3c8>
  104021:	c7 44 24 0c 11 78 10 	movl   $0x107811,0xc(%esp)
  104028:	00 
  104029:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104030:	00 
  104031:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104038:	00 
  104039:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104040:	e8 a5 cc ff ff       	call   100cea <__panic>

    assert(alloc_page() == NULL);
  104045:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10404c:	e8 3e 0b 00 00       	call   104b8f <alloc_pages>
  104051:	85 c0                	test   %eax,%eax
  104053:	74 24                	je     104079 <basic_check+0x3fc>
  104055:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  10405c:	00 
  10405d:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104064:	00 
  104065:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  10406c:	00 
  10406d:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104074:	e8 71 cc ff ff       	call   100cea <__panic>

    free_page(p0);
  104079:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104080:	00 
  104081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104084:	89 04 24             	mov    %eax,(%esp)
  104087:	e8 3d 0b 00 00       	call   104bc9 <free_pages>
  10408c:	c7 45 d8 90 ee 11 00 	movl   $0x11ee90,-0x28(%ebp)
  104093:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104096:	8b 40 04             	mov    0x4(%eax),%eax
  104099:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10409c:	0f 94 c0             	sete   %al
  10409f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1040a2:	85 c0                	test   %eax,%eax
  1040a4:	74 24                	je     1040ca <basic_check+0x44d>
  1040a6:	c7 44 24 0c 20 79 10 	movl   $0x107920,0xc(%esp)
  1040ad:	00 
  1040ae:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1040b5:	00 
  1040b6:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1040bd:	00 
  1040be:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1040c5:	e8 20 cc ff ff       	call   100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1040ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1040d1:	e8 b9 0a 00 00       	call   104b8f <alloc_pages>
  1040d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1040d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1040df:	74 24                	je     104105 <basic_check+0x488>
  1040e1:	c7 44 24 0c 38 79 10 	movl   $0x107938,0xc(%esp)
  1040e8:	00 
  1040e9:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1040f0:	00 
  1040f1:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1040f8:	00 
  1040f9:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104100:	e8 e5 cb ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  104105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10410c:	e8 7e 0a 00 00       	call   104b8f <alloc_pages>
  104111:	85 c0                	test   %eax,%eax
  104113:	74 24                	je     104139 <basic_check+0x4bc>
  104115:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  10411c:	00 
  10411d:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104124:	00 
  104125:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  10412c:	00 
  10412d:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104134:	e8 b1 cb ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  104139:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  10413e:	85 c0                	test   %eax,%eax
  104140:	74 24                	je     104166 <basic_check+0x4e9>
  104142:	c7 44 24 0c 51 79 10 	movl   $0x107951,0xc(%esp)
  104149:	00 
  10414a:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104151:	00 
  104152:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  104159:	00 
  10415a:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104161:	e8 84 cb ff ff       	call   100cea <__panic>
    free_list = free_list_store;
  104166:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104169:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10416c:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  104171:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    nr_free = nr_free_store;
  104177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10417a:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_page(p);
  10417f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104186:	00 
  104187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10418a:	89 04 24             	mov    %eax,(%esp)
  10418d:	e8 37 0a 00 00       	call   104bc9 <free_pages>
    free_page(p1);
  104192:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104199:	00 
  10419a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10419d:	89 04 24             	mov    %eax,(%esp)
  1041a0:	e8 24 0a 00 00       	call   104bc9 <free_pages>
    free_page(p2);
  1041a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041ac:	00 
  1041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041b0:	89 04 24             	mov    %eax,(%esp)
  1041b3:	e8 11 0a 00 00       	call   104bc9 <free_pages>
}
  1041b8:	90                   	nop
  1041b9:	89 ec                	mov    %ebp,%esp
  1041bb:	5d                   	pop    %ebp
  1041bc:	c3                   	ret    

001041bd <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  1041bd:	55                   	push   %ebp
  1041be:	89 e5                	mov    %esp,%ebp
  1041c0:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1041c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1041d4:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  1041db:	eb 6a                	jmp    104247 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
  1041dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041e0:	83 e8 0c             	sub    $0xc,%eax
  1041e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1041e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041e9:	83 c0 04             	add    $0x4,%eax
  1041ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1041f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1041f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1041f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041fc:	0f a3 10             	bt     %edx,(%eax)
  1041ff:	19 c0                	sbb    %eax,%eax
  104201:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104204:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104208:	0f 95 c0             	setne  %al
  10420b:	0f b6 c0             	movzbl %al,%eax
  10420e:	85 c0                	test   %eax,%eax
  104210:	75 24                	jne    104236 <default_check+0x79>
  104212:	c7 44 24 0c 5e 79 10 	movl   $0x10795e,0xc(%esp)
  104219:	00 
  10421a:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104221:	00 
  104222:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  104229:	00 
  10422a:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104231:	e8 b4 ca ff ff       	call   100cea <__panic>
        count++, total += p->property;
  104236:	ff 45 f4             	incl   -0xc(%ebp)
  104239:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10423c:	8b 50 08             	mov    0x8(%eax),%edx
  10423f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104242:	01 d0                	add    %edx,%eax
  104244:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10424a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  10424d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104250:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  104253:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104256:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  10425d:	0f 85 7a ff ff ff    	jne    1041dd <default_check+0x20>
    }
    assert(total == nr_free_pages());
  104263:	e8 96 09 00 00       	call   104bfe <nr_free_pages>
  104268:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10426b:	39 d0                	cmp    %edx,%eax
  10426d:	74 24                	je     104293 <default_check+0xd6>
  10426f:	c7 44 24 0c 6e 79 10 	movl   $0x10796e,0xc(%esp)
  104276:	00 
  104277:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  10427e:	00 
  10427f:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  104286:	00 
  104287:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  10428e:	e8 57 ca ff ff       	call   100cea <__panic>

    basic_check();
  104293:	e8 e5 f9 ff ff       	call   103c7d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104298:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10429f:	e8 eb 08 00 00       	call   104b8f <alloc_pages>
  1042a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1042a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1042ab:	75 24                	jne    1042d1 <default_check+0x114>
  1042ad:	c7 44 24 0c 87 79 10 	movl   $0x107987,0xc(%esp)
  1042b4:	00 
  1042b5:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1042bc:	00 
  1042bd:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1042c4:	00 
  1042c5:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1042cc:	e8 19 ca ff ff       	call   100cea <__panic>
    assert(!PageProperty(p0));
  1042d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042d4:	83 c0 04             	add    $0x4,%eax
  1042d7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1042de:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1042e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1042e7:	0f a3 10             	bt     %edx,(%eax)
  1042ea:	19 c0                	sbb    %eax,%eax
  1042ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1042ef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1042f3:	0f 95 c0             	setne  %al
  1042f6:	0f b6 c0             	movzbl %al,%eax
  1042f9:	85 c0                	test   %eax,%eax
  1042fb:	74 24                	je     104321 <default_check+0x164>
  1042fd:	c7 44 24 0c 92 79 10 	movl   $0x107992,0xc(%esp)
  104304:	00 
  104305:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  10430c:	00 
  10430d:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  104314:	00 
  104315:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  10431c:	e8 c9 c9 ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  104321:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  104326:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  10432c:	89 45 80             	mov    %eax,-0x80(%ebp)
  10432f:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104332:	c7 45 b0 90 ee 11 00 	movl   $0x11ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104339:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10433c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10433f:	89 50 04             	mov    %edx,0x4(%eax)
  104342:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104345:	8b 50 04             	mov    0x4(%eax),%edx
  104348:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10434b:	89 10                	mov    %edx,(%eax)
}
  10434d:	90                   	nop
  10434e:	c7 45 b4 90 ee 11 00 	movl   $0x11ee90,-0x4c(%ebp)
    return list->next == list;
  104355:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104358:	8b 40 04             	mov    0x4(%eax),%eax
  10435b:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  10435e:	0f 94 c0             	sete   %al
  104361:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104364:	85 c0                	test   %eax,%eax
  104366:	75 24                	jne    10438c <default_check+0x1cf>
  104368:	c7 44 24 0c e7 78 10 	movl   $0x1078e7,0xc(%esp)
  10436f:	00 
  104370:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104377:	00 
  104378:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10437f:	00 
  104380:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104387:	e8 5e c9 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  10438c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104393:	e8 f7 07 00 00       	call   104b8f <alloc_pages>
  104398:	85 c0                	test   %eax,%eax
  10439a:	74 24                	je     1043c0 <default_check+0x203>
  10439c:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  1043a3:	00 
  1043a4:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1043ab:	00 
  1043ac:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1043b3:	00 
  1043b4:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1043bb:	e8 2a c9 ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  1043c0:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1043c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1043c8:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  1043cf:	00 00 00 

    free_pages(p0 + 2, 3);
  1043d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043d5:	83 c0 28             	add    $0x28,%eax
  1043d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1043df:	00 
  1043e0:	89 04 24             	mov    %eax,(%esp)
  1043e3:	e8 e1 07 00 00       	call   104bc9 <free_pages>
    assert(alloc_pages(4) == NULL);
  1043e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1043ef:	e8 9b 07 00 00       	call   104b8f <alloc_pages>
  1043f4:	85 c0                	test   %eax,%eax
  1043f6:	74 24                	je     10441c <default_check+0x25f>
  1043f8:	c7 44 24 0c a4 79 10 	movl   $0x1079a4,0xc(%esp)
  1043ff:	00 
  104400:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104407:	00 
  104408:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  10440f:	00 
  104410:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104417:	e8 ce c8 ff ff       	call   100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10441c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10441f:	83 c0 28             	add    $0x28,%eax
  104422:	83 c0 04             	add    $0x4,%eax
  104425:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10442c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  10442f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104432:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104435:	0f a3 10             	bt     %edx,(%eax)
  104438:	19 c0                	sbb    %eax,%eax
  10443a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10443d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104441:	0f 95 c0             	setne  %al
  104444:	0f b6 c0             	movzbl %al,%eax
  104447:	85 c0                	test   %eax,%eax
  104449:	74 0e                	je     104459 <default_check+0x29c>
  10444b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10444e:	83 c0 28             	add    $0x28,%eax
  104451:	8b 40 08             	mov    0x8(%eax),%eax
  104454:	83 f8 03             	cmp    $0x3,%eax
  104457:	74 24                	je     10447d <default_check+0x2c0>
  104459:	c7 44 24 0c bc 79 10 	movl   $0x1079bc,0xc(%esp)
  104460:	00 
  104461:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104468:	00 
  104469:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104470:	00 
  104471:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104478:	e8 6d c8 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10447d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  104484:	e8 06 07 00 00       	call   104b8f <alloc_pages>
  104489:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10448c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104490:	75 24                	jne    1044b6 <default_check+0x2f9>
  104492:	c7 44 24 0c e8 79 10 	movl   $0x1079e8,0xc(%esp)
  104499:	00 
  10449a:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1044a1:	00 
  1044a2:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  1044a9:	00 
  1044aa:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1044b1:	e8 34 c8 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  1044b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044bd:	e8 cd 06 00 00       	call   104b8f <alloc_pages>
  1044c2:	85 c0                	test   %eax,%eax
  1044c4:	74 24                	je     1044ea <default_check+0x32d>
  1044c6:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  1044cd:	00 
  1044ce:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1044d5:	00 
  1044d6:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  1044dd:	00 
  1044de:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1044e5:	e8 00 c8 ff ff       	call   100cea <__panic>
    assert(p0 + 2 == p1);
  1044ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044ed:	83 c0 28             	add    $0x28,%eax
  1044f0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1044f3:	74 24                	je     104519 <default_check+0x35c>
  1044f5:	c7 44 24 0c 06 7a 10 	movl   $0x107a06,0xc(%esp)
  1044fc:	00 
  1044fd:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104504:	00 
  104505:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  10450c:	00 
  10450d:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104514:	e8 d1 c7 ff ff       	call   100cea <__panic>

    p2 = p0 + 1;
  104519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10451c:	83 c0 14             	add    $0x14,%eax
  10451f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  104522:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104529:	00 
  10452a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10452d:	89 04 24             	mov    %eax,(%esp)
  104530:	e8 94 06 00 00       	call   104bc9 <free_pages>
    free_pages(p1, 3);
  104535:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10453c:	00 
  10453d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104540:	89 04 24             	mov    %eax,(%esp)
  104543:	e8 81 06 00 00       	call   104bc9 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  104548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10454b:	83 c0 04             	add    $0x4,%eax
  10454e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  104555:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  104558:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10455b:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10455e:	0f a3 10             	bt     %edx,(%eax)
  104561:	19 c0                	sbb    %eax,%eax
  104563:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104566:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10456a:	0f 95 c0             	setne  %al
  10456d:	0f b6 c0             	movzbl %al,%eax
  104570:	85 c0                	test   %eax,%eax
  104572:	74 0b                	je     10457f <default_check+0x3c2>
  104574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104577:	8b 40 08             	mov    0x8(%eax),%eax
  10457a:	83 f8 01             	cmp    $0x1,%eax
  10457d:	74 24                	je     1045a3 <default_check+0x3e6>
  10457f:	c7 44 24 0c 14 7a 10 	movl   $0x107a14,0xc(%esp)
  104586:	00 
  104587:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  10458e:	00 
  10458f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104596:	00 
  104597:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  10459e:	e8 47 c7 ff ff       	call   100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045a6:	83 c0 04             	add    $0x4,%eax
  1045a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1045b0:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1045b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  1045b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1045b9:	0f a3 10             	bt     %edx,(%eax)
  1045bc:	19 c0                	sbb    %eax,%eax
  1045be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1045c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1045c5:	0f 95 c0             	setne  %al
  1045c8:	0f b6 c0             	movzbl %al,%eax
  1045cb:	85 c0                	test   %eax,%eax
  1045cd:	74 0b                	je     1045da <default_check+0x41d>
  1045cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045d2:	8b 40 08             	mov    0x8(%eax),%eax
  1045d5:	83 f8 03             	cmp    $0x3,%eax
  1045d8:	74 24                	je     1045fe <default_check+0x441>
  1045da:	c7 44 24 0c 3c 7a 10 	movl   $0x107a3c,0xc(%esp)
  1045e1:	00 
  1045e2:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1045e9:	00 
  1045ea:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1045f1:	00 
  1045f2:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1045f9:	e8 ec c6 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1045fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104605:	e8 85 05 00 00       	call   104b8f <alloc_pages>
  10460a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10460d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104610:	83 e8 14             	sub    $0x14,%eax
  104613:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104616:	74 24                	je     10463c <default_check+0x47f>
  104618:	c7 44 24 0c 62 7a 10 	movl   $0x107a62,0xc(%esp)
  10461f:	00 
  104620:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104627:	00 
  104628:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  10462f:	00 
  104630:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104637:	e8 ae c6 ff ff       	call   100cea <__panic>
    free_page(p0);
  10463c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104643:	00 
  104644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104647:	89 04 24             	mov    %eax,(%esp)
  10464a:	e8 7a 05 00 00       	call   104bc9 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10464f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104656:	e8 34 05 00 00       	call   104b8f <alloc_pages>
  10465b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10465e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104661:	83 c0 14             	add    $0x14,%eax
  104664:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104667:	74 24                	je     10468d <default_check+0x4d0>
  104669:	c7 44 24 0c 80 7a 10 	movl   $0x107a80,0xc(%esp)
  104670:	00 
  104671:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104678:	00 
  104679:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  104680:	00 
  104681:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104688:	e8 5d c6 ff ff       	call   100cea <__panic>

    free_pages(p0, 2);
  10468d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104694:	00 
  104695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104698:	89 04 24             	mov    %eax,(%esp)
  10469b:	e8 29 05 00 00       	call   104bc9 <free_pages>
    free_page(p2);
  1046a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046a7:	00 
  1046a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046ab:	89 04 24             	mov    %eax,(%esp)
  1046ae:	e8 16 05 00 00       	call   104bc9 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1046b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1046ba:	e8 d0 04 00 00       	call   104b8f <alloc_pages>
  1046bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1046c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1046c6:	75 24                	jne    1046ec <default_check+0x52f>
  1046c8:	c7 44 24 0c a0 7a 10 	movl   $0x107aa0,0xc(%esp)
  1046cf:	00 
  1046d0:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1046d7:	00 
  1046d8:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  1046df:	00 
  1046e0:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1046e7:	e8 fe c5 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  1046ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046f3:	e8 97 04 00 00       	call   104b8f <alloc_pages>
  1046f8:	85 c0                	test   %eax,%eax
  1046fa:	74 24                	je     104720 <default_check+0x563>
  1046fc:	c7 44 24 0c fe 78 10 	movl   $0x1078fe,0xc(%esp)
  104703:	00 
  104704:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  10470b:	00 
  10470c:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  104713:	00 
  104714:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  10471b:	e8 ca c5 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  104720:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  104725:	85 c0                	test   %eax,%eax
  104727:	74 24                	je     10474d <default_check+0x590>
  104729:	c7 44 24 0c 51 79 10 	movl   $0x107951,0xc(%esp)
  104730:	00 
  104731:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104738:	00 
  104739:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  104740:	00 
  104741:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104748:	e8 9d c5 ff ff       	call   100cea <__panic>
    nr_free = nr_free_store;
  10474d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104750:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_list = free_list_store;
  104755:	8b 45 80             	mov    -0x80(%ebp),%eax
  104758:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10475b:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  104760:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    free_pages(p0, 5);
  104766:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10476d:	00 
  10476e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104771:	89 04 24             	mov    %eax,(%esp)
  104774:	e8 50 04 00 00       	call   104bc9 <free_pages>

    le = &free_list;
  104779:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  104780:	eb 5a                	jmp    1047dc <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
  104782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104785:	8b 40 04             	mov    0x4(%eax),%eax
  104788:	8b 00                	mov    (%eax),%eax
  10478a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10478d:	75 0d                	jne    10479c <default_check+0x5df>
  10478f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104792:	8b 00                	mov    (%eax),%eax
  104794:	8b 40 04             	mov    0x4(%eax),%eax
  104797:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10479a:	74 24                	je     1047c0 <default_check+0x603>
  10479c:	c7 44 24 0c c0 7a 10 	movl   $0x107ac0,0xc(%esp)
  1047a3:	00 
  1047a4:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  1047ab:	00 
  1047ac:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  1047b3:	00 
  1047b4:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  1047bb:	e8 2a c5 ff ff       	call   100cea <__panic>
        struct Page *p = le2page(le, page_link);
  1047c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047c3:	83 e8 0c             	sub    $0xc,%eax
  1047c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  1047c9:	ff 4d f4             	decl   -0xc(%ebp)
  1047cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1047cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1047d2:	8b 48 08             	mov    0x8(%eax),%ecx
  1047d5:	89 d0                	mov    %edx,%eax
  1047d7:	29 c8                	sub    %ecx,%eax
  1047d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1047dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047df:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1047e2:	8b 45 88             	mov    -0x78(%ebp),%eax
  1047e5:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  1047e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1047eb:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  1047f2:	75 8e                	jne    104782 <default_check+0x5c5>
    }
    assert(count == 0);
  1047f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047f8:	74 24                	je     10481e <default_check+0x661>
  1047fa:	c7 44 24 0c ed 7a 10 	movl   $0x107aed,0xc(%esp)
  104801:	00 
  104802:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104809:	00 
  10480a:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  104811:	00 
  104812:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104819:	e8 cc c4 ff ff       	call   100cea <__panic>
    assert(total == 0);
  10481e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104822:	74 24                	je     104848 <default_check+0x68b>
  104824:	c7 44 24 0c f8 7a 10 	movl   $0x107af8,0xc(%esp)
  10482b:	00 
  10482c:	c7 44 24 08 76 77 10 	movl   $0x107776,0x8(%esp)
  104833:	00 
  104834:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  10483b:	00 
  10483c:	c7 04 24 8b 77 10 00 	movl   $0x10778b,(%esp)
  104843:	e8 a2 c4 ff ff       	call   100cea <__panic>
}
  104848:	90                   	nop
  104849:	89 ec                	mov    %ebp,%esp
  10484b:	5d                   	pop    %ebp
  10484c:	c3                   	ret    

0010484d <page2ppn>:
page2ppn(struct Page *page) {
  10484d:	55                   	push   %ebp
  10484e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104850:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  104856:	8b 45 08             	mov    0x8(%ebp),%eax
  104859:	29 d0                	sub    %edx,%eax
  10485b:	c1 f8 02             	sar    $0x2,%eax
  10485e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104864:	5d                   	pop    %ebp
  104865:	c3                   	ret    

00104866 <page2pa>:
page2pa(struct Page *page) {
  104866:	55                   	push   %ebp
  104867:	89 e5                	mov    %esp,%ebp
  104869:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10486c:	8b 45 08             	mov    0x8(%ebp),%eax
  10486f:	89 04 24             	mov    %eax,(%esp)
  104872:	e8 d6 ff ff ff       	call   10484d <page2ppn>
  104877:	c1 e0 0c             	shl    $0xc,%eax
}
  10487a:	89 ec                	mov    %ebp,%esp
  10487c:	5d                   	pop    %ebp
  10487d:	c3                   	ret    

0010487e <pa2page>:
pa2page(uintptr_t pa) {
  10487e:	55                   	push   %ebp
  10487f:	89 e5                	mov    %esp,%ebp
  104881:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  104884:	8b 45 08             	mov    0x8(%ebp),%eax
  104887:	c1 e8 0c             	shr    $0xc,%eax
  10488a:	89 c2                	mov    %eax,%edx
  10488c:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104891:	39 c2                	cmp    %eax,%edx
  104893:	72 1c                	jb     1048b1 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  104895:	c7 44 24 08 34 7b 10 	movl   $0x107b34,0x8(%esp)
  10489c:	00 
  10489d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1048a4:	00 
  1048a5:	c7 04 24 53 7b 10 00 	movl   $0x107b53,(%esp)
  1048ac:	e8 39 c4 ff ff       	call   100cea <__panic>
    return &pages[PPN(pa)];
  1048b1:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  1048b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ba:	c1 e8 0c             	shr    $0xc,%eax
  1048bd:	89 c2                	mov    %eax,%edx
  1048bf:	89 d0                	mov    %edx,%eax
  1048c1:	c1 e0 02             	shl    $0x2,%eax
  1048c4:	01 d0                	add    %edx,%eax
  1048c6:	c1 e0 02             	shl    $0x2,%eax
  1048c9:	01 c8                	add    %ecx,%eax
}
  1048cb:	89 ec                	mov    %ebp,%esp
  1048cd:	5d                   	pop    %ebp
  1048ce:	c3                   	ret    

001048cf <page2kva>:
page2kva(struct Page *page) {
  1048cf:	55                   	push   %ebp
  1048d0:	89 e5                	mov    %esp,%ebp
  1048d2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1048d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d8:	89 04 24             	mov    %eax,(%esp)
  1048db:	e8 86 ff ff ff       	call   104866 <page2pa>
  1048e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e6:	c1 e8 0c             	shr    $0xc,%eax
  1048e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048ec:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1048f1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1048f4:	72 23                	jb     104919 <page2kva+0x4a>
  1048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048fd:	c7 44 24 08 64 7b 10 	movl   $0x107b64,0x8(%esp)
  104904:	00 
  104905:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  10490c:	00 
  10490d:	c7 04 24 53 7b 10 00 	movl   $0x107b53,(%esp)
  104914:	e8 d1 c3 ff ff       	call   100cea <__panic>
  104919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10491c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  104921:	89 ec                	mov    %ebp,%esp
  104923:	5d                   	pop    %ebp
  104924:	c3                   	ret    

00104925 <pte2page>:
pte2page(pte_t pte) {
  104925:	55                   	push   %ebp
  104926:	89 e5                	mov    %esp,%ebp
  104928:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  10492b:	8b 45 08             	mov    0x8(%ebp),%eax
  10492e:	83 e0 01             	and    $0x1,%eax
  104931:	85 c0                	test   %eax,%eax
  104933:	75 1c                	jne    104951 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  104935:	c7 44 24 08 88 7b 10 	movl   $0x107b88,0x8(%esp)
  10493c:	00 
  10493d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  104944:	00 
  104945:	c7 04 24 53 7b 10 00 	movl   $0x107b53,(%esp)
  10494c:	e8 99 c3 ff ff       	call   100cea <__panic>
    return pa2page(PTE_ADDR(pte));
  104951:	8b 45 08             	mov    0x8(%ebp),%eax
  104954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104959:	89 04 24             	mov    %eax,(%esp)
  10495c:	e8 1d ff ff ff       	call   10487e <pa2page>
}
  104961:	89 ec                	mov    %ebp,%esp
  104963:	5d                   	pop    %ebp
  104964:	c3                   	ret    

00104965 <pde2page>:
pde2page(pde_t pde) {
  104965:	55                   	push   %ebp
  104966:	89 e5                	mov    %esp,%ebp
  104968:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  10496b:	8b 45 08             	mov    0x8(%ebp),%eax
  10496e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104973:	89 04 24             	mov    %eax,(%esp)
  104976:	e8 03 ff ff ff       	call   10487e <pa2page>
}
  10497b:	89 ec                	mov    %ebp,%esp
  10497d:	5d                   	pop    %ebp
  10497e:	c3                   	ret    

0010497f <page_ref>:
page_ref(struct Page *page) {
  10497f:	55                   	push   %ebp
  104980:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104982:	8b 45 08             	mov    0x8(%ebp),%eax
  104985:	8b 00                	mov    (%eax),%eax
}
  104987:	5d                   	pop    %ebp
  104988:	c3                   	ret    

00104989 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104989:	55                   	push   %ebp
  10498a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10498c:	8b 45 08             	mov    0x8(%ebp),%eax
  10498f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104992:	89 10                	mov    %edx,(%eax)
}
  104994:	90                   	nop
  104995:	5d                   	pop    %ebp
  104996:	c3                   	ret    

00104997 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  104997:	55                   	push   %ebp
  104998:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  10499a:	8b 45 08             	mov    0x8(%ebp),%eax
  10499d:	8b 00                	mov    (%eax),%eax
  10499f:	8d 50 01             	lea    0x1(%eax),%edx
  1049a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1049a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1049aa:	8b 00                	mov    (%eax),%eax
}
  1049ac:	5d                   	pop    %ebp
  1049ad:	c3                   	ret    

001049ae <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1049ae:	55                   	push   %ebp
  1049af:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1049b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1049b4:	8b 00                	mov    (%eax),%eax
  1049b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1049b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1049bc:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1049be:	8b 45 08             	mov    0x8(%ebp),%eax
  1049c1:	8b 00                	mov    (%eax),%eax
}
  1049c3:	5d                   	pop    %ebp
  1049c4:	c3                   	ret    

001049c5 <__intr_save>:
{
  1049c5:	55                   	push   %ebp
  1049c6:	89 e5                	mov    %esp,%ebp
  1049c8:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
  1049cb:	9c                   	pushf  
  1049cc:	58                   	pop    %eax
  1049cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
  1049d3:	25 00 02 00 00       	and    $0x200,%eax
  1049d8:	85 c0                	test   %eax,%eax
  1049da:	74 0c                	je     1049e8 <__intr_save+0x23>
        intr_disable();
  1049dc:	e8 62 cd ff ff       	call   101743 <intr_disable>
        return 1;
  1049e1:	b8 01 00 00 00       	mov    $0x1,%eax
  1049e6:	eb 05                	jmp    1049ed <__intr_save+0x28>
    return 0;
  1049e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1049ed:	89 ec                	mov    %ebp,%esp
  1049ef:	5d                   	pop    %ebp
  1049f0:	c3                   	ret    

001049f1 <__intr_restore>:
{
  1049f1:	55                   	push   %ebp
  1049f2:	89 e5                	mov    %esp,%ebp
  1049f4:	83 ec 08             	sub    $0x8,%esp
    if (flag)
  1049f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1049fb:	74 05                	je     104a02 <__intr_restore+0x11>
        intr_enable();
  1049fd:	e8 39 cd ff ff       	call   10173b <intr_enable>
}
  104a02:	90                   	nop
  104a03:	89 ec                	mov    %ebp,%esp
  104a05:	5d                   	pop    %ebp
  104a06:	c3                   	ret    

00104a07 <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
  104a07:	55                   	push   %ebp
  104a08:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
  104a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  104a0d:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
  104a10:	b8 23 00 00 00       	mov    $0x23,%eax
  104a15:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
  104a17:	b8 23 00 00 00       	mov    $0x23,%eax
  104a1c:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
  104a1e:	b8 10 00 00 00       	mov    $0x10,%eax
  104a23:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
  104a25:	b8 10 00 00 00       	mov    $0x10,%eax
  104a2a:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
  104a2c:	b8 10 00 00 00       	mov    $0x10,%eax
  104a31:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
  104a33:	ea 3a 4a 10 00 08 00 	ljmp   $0x8,$0x104a3a
}
  104a3a:	90                   	nop
  104a3b:	5d                   	pop    %ebp
  104a3c:	c3                   	ret    

00104a3d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
  104a3d:	55                   	push   %ebp
  104a3e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  104a40:	8b 45 08             	mov    0x8(%ebp),%eax
  104a43:	a3 c4 ee 11 00       	mov    %eax,0x11eec4
}
  104a48:	90                   	nop
  104a49:	5d                   	pop    %ebp
  104a4a:	c3                   	ret    

00104a4b <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
  104a4b:	55                   	push   %ebp
  104a4c:	89 e5                	mov    %esp,%ebp
  104a4e:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  104a51:	b8 00 b0 11 00       	mov    $0x11b000,%eax
  104a56:	89 04 24             	mov    %eax,(%esp)
  104a59:	e8 df ff ff ff       	call   104a3d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  104a5e:	66 c7 05 c8 ee 11 00 	movw   $0x10,0x11eec8
  104a65:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  104a67:	66 c7 05 28 ba 11 00 	movw   $0x68,0x11ba28
  104a6e:	68 00 
  104a70:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a75:	0f b7 c0             	movzwl %ax,%eax
  104a78:	66 a3 2a ba 11 00    	mov    %ax,0x11ba2a
  104a7e:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a83:	c1 e8 10             	shr    $0x10,%eax
  104a86:	a2 2c ba 11 00       	mov    %al,0x11ba2c
  104a8b:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a92:	24 f0                	and    $0xf0,%al
  104a94:	0c 09                	or     $0x9,%al
  104a96:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104a9b:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104aa2:	24 ef                	and    $0xef,%al
  104aa4:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104aa9:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104ab0:	24 9f                	and    $0x9f,%al
  104ab2:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104ab7:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104abe:	0c 80                	or     $0x80,%al
  104ac0:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104ac5:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104acc:	24 f0                	and    $0xf0,%al
  104ace:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104ad3:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104ada:	24 ef                	and    $0xef,%al
  104adc:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104ae1:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104ae8:	24 df                	and    $0xdf,%al
  104aea:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104aef:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104af6:	0c 40                	or     $0x40,%al
  104af8:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104afd:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104b04:	24 7f                	and    $0x7f,%al
  104b06:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104b0b:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104b10:	c1 e8 18             	shr    $0x18,%eax
  104b13:	a2 2f ba 11 00       	mov    %al,0x11ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104b18:	c7 04 24 30 ba 11 00 	movl   $0x11ba30,(%esp)
  104b1f:	e8 e3 fe ff ff       	call   104a07 <lgdt>
  104b24:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
  104b2a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  104b2e:	0f 00 d8             	ltr    %ax
}
  104b31:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  104b32:	90                   	nop
  104b33:	89 ec                	mov    %ebp,%esp
  104b35:	5d                   	pop    %ebp
  104b36:	c3                   	ret    

00104b37 <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
  104b37:	55                   	push   %ebp
  104b38:	89 e5                	mov    %esp,%ebp
  104b3a:	83 ec 18             	sub    $0x18,%esp
    //pmm_manager = &default_pmm_manager;
    pmm_manager = &buddy_pmm_manager;
  104b3d:	c7 05 ac ee 11 00 54 	movl   $0x107754,0x11eeac
  104b44:	77 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  104b47:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b4c:	8b 00                	mov    (%eax),%eax
  104b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b52:	c7 04 24 b4 7b 10 00 	movl   $0x107bb4,(%esp)
  104b59:	e8 07 b8 ff ff       	call   100365 <cprintf>
    pmm_manager->init();
  104b5e:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b63:	8b 40 04             	mov    0x4(%eax),%eax
  104b66:	ff d0                	call   *%eax
}
  104b68:	90                   	nop
  104b69:	89 ec                	mov    %ebp,%esp
  104b6b:	5d                   	pop    %ebp
  104b6c:	c3                   	ret    

00104b6d <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
  104b6d:	55                   	push   %ebp
  104b6e:	89 e5                	mov    %esp,%ebp
  104b70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  104b73:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b78:	8b 40 08             	mov    0x8(%eax),%eax
  104b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b82:	8b 55 08             	mov    0x8(%ebp),%edx
  104b85:	89 14 24             	mov    %edx,(%esp)
  104b88:	ff d0                	call   *%eax
}
  104b8a:	90                   	nop
  104b8b:	89 ec                	mov    %ebp,%esp
  104b8d:	5d                   	pop    %ebp
  104b8e:	c3                   	ret    

00104b8f <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
  104b8f:	55                   	push   %ebp
  104b90:	89 e5                	mov    %esp,%ebp
  104b92:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
  104b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  104b9c:	e8 24 fe ff ff       	call   1049c5 <__intr_save>
  104ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  104ba4:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  104bac:	8b 55 08             	mov    0x8(%ebp),%edx
  104baf:	89 14 24             	mov    %edx,(%esp)
  104bb2:	ff d0                	call   *%eax
  104bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bba:	89 04 24             	mov    %eax,(%esp)
  104bbd:	e8 2f fe ff ff       	call   1049f1 <__intr_restore>
    return page;
  104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104bc5:	89 ec                	mov    %ebp,%esp
  104bc7:	5d                   	pop    %ebp
  104bc8:	c3                   	ret    

00104bc9 <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
  104bc9:	55                   	push   %ebp
  104bca:	89 e5                	mov    %esp,%ebp
  104bcc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  104bcf:	e8 f1 fd ff ff       	call   1049c5 <__intr_save>
  104bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  104bd7:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104bdc:	8b 40 10             	mov    0x10(%eax),%eax
  104bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  104be2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104be6:	8b 55 08             	mov    0x8(%ebp),%edx
  104be9:	89 14 24             	mov    %edx,(%esp)
  104bec:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  104bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf1:	89 04 24             	mov    %eax,(%esp)
  104bf4:	e8 f8 fd ff ff       	call   1049f1 <__intr_restore>
}
  104bf9:	90                   	nop
  104bfa:	89 ec                	mov    %ebp,%esp
  104bfc:	5d                   	pop    %ebp
  104bfd:	c3                   	ret    

00104bfe <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
  104bfe:	55                   	push   %ebp
  104bff:	89 e5                	mov    %esp,%ebp
  104c01:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  104c04:	e8 bc fd ff ff       	call   1049c5 <__intr_save>
  104c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  104c0c:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104c11:	8b 40 14             	mov    0x14(%eax),%eax
  104c14:	ff d0                	call   *%eax
  104c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  104c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c1c:	89 04 24             	mov    %eax,(%esp)
  104c1f:	e8 cd fd ff ff       	call   1049f1 <__intr_restore>
    return ret;
  104c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104c27:	89 ec                	mov    %ebp,%esp
  104c29:	5d                   	pop    %ebp
  104c2a:	c3                   	ret    

00104c2b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
  104c2b:	55                   	push   %ebp
  104c2c:	89 e5                	mov    %esp,%ebp
  104c2e:	57                   	push   %edi
  104c2f:	56                   	push   %esi
  104c30:	53                   	push   %ebx
  104c31:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104c37:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104c3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104c45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104c4c:	c7 04 24 cb 7b 10 00 	movl   $0x107bcb,(%esp)
  104c53:	e8 0d b7 ff ff       	call   100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
  104c58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104c5f:	e9 0c 01 00 00       	jmp    104d70 <page_init+0x145>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104c64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c6a:	89 d0                	mov    %edx,%eax
  104c6c:	c1 e0 02             	shl    $0x2,%eax
  104c6f:	01 d0                	add    %edx,%eax
  104c71:	c1 e0 02             	shl    $0x2,%eax
  104c74:	01 c8                	add    %ecx,%eax
  104c76:	8b 50 08             	mov    0x8(%eax),%edx
  104c79:	8b 40 04             	mov    0x4(%eax),%eax
  104c7c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104c7f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104c82:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c85:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c88:	89 d0                	mov    %edx,%eax
  104c8a:	c1 e0 02             	shl    $0x2,%eax
  104c8d:	01 d0                	add    %edx,%eax
  104c8f:	c1 e0 02             	shl    $0x2,%eax
  104c92:	01 c8                	add    %ecx,%eax
  104c94:	8b 48 0c             	mov    0xc(%eax),%ecx
  104c97:	8b 58 10             	mov    0x10(%eax),%ebx
  104c9a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104c9d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104ca0:	01 c8                	add    %ecx,%eax
  104ca2:	11 da                	adc    %ebx,%edx
  104ca4:	89 45 98             	mov    %eax,-0x68(%ebp)
  104ca7:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104caa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104cad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104cb0:	89 d0                	mov    %edx,%eax
  104cb2:	c1 e0 02             	shl    $0x2,%eax
  104cb5:	01 d0                	add    %edx,%eax
  104cb7:	c1 e0 02             	shl    $0x2,%eax
  104cba:	01 c8                	add    %ecx,%eax
  104cbc:	83 c0 14             	add    $0x14,%eax
  104cbf:	8b 00                	mov    (%eax),%eax
  104cc1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104cc7:	8b 45 98             	mov    -0x68(%ebp),%eax
  104cca:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104ccd:	83 c0 ff             	add    $0xffffffff,%eax
  104cd0:	83 d2 ff             	adc    $0xffffffff,%edx
  104cd3:	89 c6                	mov    %eax,%esi
  104cd5:	89 d7                	mov    %edx,%edi
  104cd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104cda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104cdd:	89 d0                	mov    %edx,%eax
  104cdf:	c1 e0 02             	shl    $0x2,%eax
  104ce2:	01 d0                	add    %edx,%eax
  104ce4:	c1 e0 02             	shl    $0x2,%eax
  104ce7:	01 c8                	add    %ecx,%eax
  104ce9:	8b 48 0c             	mov    0xc(%eax),%ecx
  104cec:	8b 58 10             	mov    0x10(%eax),%ebx
  104cef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104cf5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104cf9:	89 74 24 14          	mov    %esi,0x14(%esp)
  104cfd:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104d01:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104d04:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104d07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d0b:	89 54 24 10          	mov    %edx,0x10(%esp)
  104d0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104d13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104d17:	c7 04 24 d8 7b 10 00 	movl   $0x107bd8,(%esp)
  104d1e:	e8 42 b6 ff ff       	call   100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
  104d23:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104d26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104d29:	89 d0                	mov    %edx,%eax
  104d2b:	c1 e0 02             	shl    $0x2,%eax
  104d2e:	01 d0                	add    %edx,%eax
  104d30:	c1 e0 02             	shl    $0x2,%eax
  104d33:	01 c8                	add    %ecx,%eax
  104d35:	83 c0 14             	add    $0x14,%eax
  104d38:	8b 00                	mov    (%eax),%eax
  104d3a:	83 f8 01             	cmp    $0x1,%eax
  104d3d:	75 2e                	jne    104d6d <page_init+0x142>
        {
            if (maxpa < end && begin < KMEMSIZE)
  104d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104d45:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104d48:	89 d0                	mov    %edx,%eax
  104d4a:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  104d4d:	73 1e                	jae    104d6d <page_init+0x142>
  104d4f:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  104d54:	b8 00 00 00 00       	mov    $0x0,%eax
  104d59:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104d5c:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  104d5f:	72 0c                	jb     104d6d <page_init+0x142>
            {
                maxpa = end;
  104d61:	8b 45 98             	mov    -0x68(%ebp),%eax
  104d64:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104d6a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
  104d6d:	ff 45 dc             	incl   -0x24(%ebp)
  104d70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d73:	8b 00                	mov    (%eax),%eax
  104d75:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104d78:	0f 8c e6 fe ff ff    	jl     104c64 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE)
  104d7e:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104d83:	b8 00 00 00 00       	mov    $0x0,%eax
  104d88:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104d8b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104d8e:	73 0e                	jae    104d9e <page_init+0x173>
    {
        maxpa = KMEMSIZE;
  104d90:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104d97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104da4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104da8:	c1 ea 0c             	shr    $0xc,%edx
  104dab:	a3 a4 ee 11 00       	mov    %eax,0x11eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104db0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104db7:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  104dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  104dbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104dc2:	01 d0                	add    %edx,%eax
  104dc4:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104dc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104dca:	ba 00 00 00 00       	mov    $0x0,%edx
  104dcf:	f7 75 c0             	divl   -0x40(%ebp)
  104dd2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104dd5:	29 d0                	sub    %edx,%eax
  104dd7:	a3 a0 ee 11 00       	mov    %eax,0x11eea0

    for (i = 0; i < npage; i++)
  104ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104de3:	eb 2f                	jmp    104e14 <page_init+0x1e9>
    {
        SetPageReserved(pages + i);
  104de5:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  104deb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104dee:	89 d0                	mov    %edx,%eax
  104df0:	c1 e0 02             	shl    $0x2,%eax
  104df3:	01 d0                	add    %edx,%eax
  104df5:	c1 e0 02             	shl    $0x2,%eax
  104df8:	01 c8                	add    %ecx,%eax
  104dfa:	83 c0 04             	add    $0x4,%eax
  104dfd:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  104e04:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
  104e07:	8b 45 90             	mov    -0x70(%ebp),%eax
  104e0a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104e0d:	0f ab 10             	bts    %edx,(%eax)
}
  104e10:	90                   	nop
    for (i = 0; i < npage; i++)
  104e11:	ff 45 dc             	incl   -0x24(%ebp)
  104e14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e17:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104e1c:	39 c2                	cmp    %eax,%edx
  104e1e:	72 c5                	jb     104de5 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104e20:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  104e26:	89 d0                	mov    %edx,%eax
  104e28:	c1 e0 02             	shl    $0x2,%eax
  104e2b:	01 d0                	add    %edx,%eax
  104e2d:	c1 e0 02             	shl    $0x2,%eax
  104e30:	89 c2                	mov    %eax,%edx
  104e32:	a1 a0 ee 11 00       	mov    0x11eea0,%eax
  104e37:	01 d0                	add    %edx,%eax
  104e39:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104e3c:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  104e43:	77 23                	ja     104e68 <page_init+0x23d>
  104e45:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104e48:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e4c:	c7 44 24 08 08 7c 10 	movl   $0x107c08,0x8(%esp)
  104e53:	00 
  104e54:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  104e5b:	00 
  104e5c:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  104e63:	e8 82 be ff ff       	call   100cea <__panic>
  104e68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104e6b:	05 00 00 00 40       	add    $0x40000000,%eax
  104e70:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
  104e73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104e7a:	e9 53 01 00 00       	jmp    104fd2 <page_init+0x3a7>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104e7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104e82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e85:	89 d0                	mov    %edx,%eax
  104e87:	c1 e0 02             	shl    $0x2,%eax
  104e8a:	01 d0                	add    %edx,%eax
  104e8c:	c1 e0 02             	shl    $0x2,%eax
  104e8f:	01 c8                	add    %ecx,%eax
  104e91:	8b 50 08             	mov    0x8(%eax),%edx
  104e94:	8b 40 04             	mov    0x4(%eax),%eax
  104e97:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104e9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104e9d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104ea0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ea3:	89 d0                	mov    %edx,%eax
  104ea5:	c1 e0 02             	shl    $0x2,%eax
  104ea8:	01 d0                	add    %edx,%eax
  104eaa:	c1 e0 02             	shl    $0x2,%eax
  104ead:	01 c8                	add    %ecx,%eax
  104eaf:	8b 48 0c             	mov    0xc(%eax),%ecx
  104eb2:	8b 58 10             	mov    0x10(%eax),%ebx
  104eb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104eb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ebb:	01 c8                	add    %ecx,%eax
  104ebd:	11 da                	adc    %ebx,%edx
  104ebf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104ec2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
  104ec5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104ec8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ecb:	89 d0                	mov    %edx,%eax
  104ecd:	c1 e0 02             	shl    $0x2,%eax
  104ed0:	01 d0                	add    %edx,%eax
  104ed2:	c1 e0 02             	shl    $0x2,%eax
  104ed5:	01 c8                	add    %ecx,%eax
  104ed7:	83 c0 14             	add    $0x14,%eax
  104eda:	8b 00                	mov    (%eax),%eax
  104edc:	83 f8 01             	cmp    $0x1,%eax
  104edf:	0f 85 ea 00 00 00    	jne    104fcf <page_init+0x3a4>
        {
            if (begin < freemem)
  104ee5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104ee8:	ba 00 00 00 00       	mov    $0x0,%edx
  104eed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104ef0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  104ef3:	19 d1                	sbb    %edx,%ecx
  104ef5:	73 0d                	jae    104f04 <page_init+0x2d9>
            {
                begin = freemem;
  104ef7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104efa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104efd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
  104f04:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104f09:	b8 00 00 00 00       	mov    $0x0,%eax
  104f0e:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  104f11:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104f14:	73 0e                	jae    104f24 <page_init+0x2f9>
            {
                end = KMEMSIZE;
  104f16:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104f1d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
  104f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f2a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104f2d:	89 d0                	mov    %edx,%eax
  104f2f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104f32:	0f 83 97 00 00 00    	jae    104fcf <page_init+0x3a4>
            {
                begin = ROUNDUP(begin, PGSIZE);
  104f38:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  104f3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f45:	01 d0                	add    %edx,%eax
  104f47:	48                   	dec    %eax
  104f48:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104f4b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  104f53:	f7 75 b0             	divl   -0x50(%ebp)
  104f56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104f59:	29 d0                	sub    %edx,%eax
  104f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  104f60:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104f63:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104f66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104f69:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104f6c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104f6f:	ba 00 00 00 00       	mov    $0x0,%edx
  104f74:	89 c7                	mov    %eax,%edi
  104f76:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104f7c:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104f7f:	89 d0                	mov    %edx,%eax
  104f81:	83 e0 00             	and    $0x0,%eax
  104f84:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104f87:	8b 45 80             	mov    -0x80(%ebp),%eax
  104f8a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104f8d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104f90:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
  104f93:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f99:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104f9c:	89 d0                	mov    %edx,%eax
  104f9e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104fa1:	73 2c                	jae    104fcf <page_init+0x3a4>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104fa3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104fa6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104fa9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104fac:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104faf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104fb3:	c1 ea 0c             	shr    $0xc,%edx
  104fb6:	89 c3                	mov    %eax,%ebx
  104fb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104fbb:	89 04 24             	mov    %eax,(%esp)
  104fbe:	e8 bb f8 ff ff       	call   10487e <pa2page>
  104fc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104fc7:	89 04 24             	mov    %eax,(%esp)
  104fca:	e8 9e fb ff ff       	call   104b6d <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
  104fcf:	ff 45 dc             	incl   -0x24(%ebp)
  104fd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104fd5:	8b 00                	mov    (%eax),%eax
  104fd7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fda:	0f 8c 9f fe ff ff    	jl     104e7f <page_init+0x254>
                }
            }
        }
    }
}
  104fe0:	90                   	nop
  104fe1:	90                   	nop
  104fe2:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104fe8:	5b                   	pop    %ebx
  104fe9:	5e                   	pop    %esi
  104fea:	5f                   	pop    %edi
  104feb:	5d                   	pop    %ebp
  104fec:	c3                   	ret    

00104fed <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
  104fed:	55                   	push   %ebp
  104fee:	89 e5                	mov    %esp,%ebp
  104ff0:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ff6:	33 45 14             	xor    0x14(%ebp),%eax
  104ff9:	25 ff 0f 00 00       	and    $0xfff,%eax
  104ffe:	85 c0                	test   %eax,%eax
  105000:	74 24                	je     105026 <boot_map_segment+0x39>
  105002:	c7 44 24 0c 3a 7c 10 	movl   $0x107c3a,0xc(%esp)
  105009:	00 
  10500a:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105011:	00 
  105012:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  105019:	00 
  10501a:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105021:	e8 c4 bc ff ff       	call   100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  105026:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10502d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105030:	25 ff 0f 00 00       	and    $0xfff,%eax
  105035:	89 c2                	mov    %eax,%edx
  105037:	8b 45 10             	mov    0x10(%ebp),%eax
  10503a:	01 c2                	add    %eax,%edx
  10503c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10503f:	01 d0                	add    %edx,%eax
  105041:	48                   	dec    %eax
  105042:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105048:	ba 00 00 00 00       	mov    $0x0,%edx
  10504d:	f7 75 f0             	divl   -0x10(%ebp)
  105050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105053:	29 d0                	sub    %edx,%eax
  105055:	c1 e8 0c             	shr    $0xc,%eax
  105058:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10505b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10505e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105069:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10506c:	8b 45 14             	mov    0x14(%ebp),%eax
  10506f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10507a:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  10507d:	eb 68                	jmp    1050e7 <boot_map_segment+0xfa>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
  10507f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105086:	00 
  105087:	8b 45 0c             	mov    0xc(%ebp),%eax
  10508a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10508e:	8b 45 08             	mov    0x8(%ebp),%eax
  105091:	89 04 24             	mov    %eax,(%esp)
  105094:	e8 88 01 00 00       	call   105221 <get_pte>
  105099:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10509c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1050a0:	75 24                	jne    1050c6 <boot_map_segment+0xd9>
  1050a2:	c7 44 24 0c 66 7c 10 	movl   $0x107c66,0xc(%esp)
  1050a9:	00 
  1050aa:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1050b1:	00 
  1050b2:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1050b9:	00 
  1050ba:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1050c1:	e8 24 bc ff ff       	call   100cea <__panic>
        *ptep = pa | PTE_P | perm;
  1050c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1050c9:	0b 45 18             	or     0x18(%ebp),%eax
  1050cc:	83 c8 01             	or     $0x1,%eax
  1050cf:	89 c2                	mov    %eax,%edx
  1050d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050d4:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  1050d6:	ff 4d f4             	decl   -0xc(%ebp)
  1050d9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1050e0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1050e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050eb:	75 92                	jne    10507f <boot_map_segment+0x92>
    }
}
  1050ed:	90                   	nop
  1050ee:	90                   	nop
  1050ef:	89 ec                	mov    %ebp,%esp
  1050f1:	5d                   	pop    %ebp
  1050f2:	c3                   	ret    

001050f3 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
  1050f3:	55                   	push   %ebp
  1050f4:	89 e5                	mov    %esp,%ebp
  1050f6:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1050f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105100:	e8 8a fa ff ff       	call   104b8f <alloc_pages>
  105105:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
  105108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10510c:	75 1c                	jne    10512a <boot_alloc_page+0x37>
    {
        panic("boot_alloc_page failed.\n");
  10510e:	c7 44 24 08 73 7c 10 	movl   $0x107c73,0x8(%esp)
  105115:	00 
  105116:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10511d:	00 
  10511e:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105125:	e8 c0 bb ff ff       	call   100cea <__panic>
    }
    return page2kva(p);
  10512a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10512d:	89 04 24             	mov    %eax,(%esp)
  105130:	e8 9a f7 ff ff       	call   1048cf <page2kva>
}
  105135:	89 ec                	mov    %ebp,%esp
  105137:	5d                   	pop    %ebp
  105138:	c3                   	ret    

00105139 <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
  105139:	55                   	push   %ebp
  10513a:	89 e5                	mov    %esp,%ebp
  10513c:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10513f:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105147:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10514e:	77 23                	ja     105173 <pmm_init+0x3a>
  105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105153:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105157:	c7 44 24 08 08 7c 10 	movl   $0x107c08,0x8(%esp)
  10515e:	00 
  10515f:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  105166:	00 
  105167:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  10516e:	e8 77 bb ff ff       	call   100cea <__panic>
  105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105176:	05 00 00 00 40       	add    $0x40000000,%eax
  10517b:	a3 a8 ee 11 00       	mov    %eax,0x11eea8
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  105180:	e8 b2 f9 ff ff       	call   104b37 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  105185:	e8 a1 fa ff ff       	call   104c2b <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10518a:	e8 ed 03 00 00       	call   10557c <check_alloc_page>

    check_pgdir();
  10518f:	e8 09 04 00 00       	call   10559d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  105194:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105199:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10519c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1051a3:	77 23                	ja     1051c8 <pmm_init+0x8f>
  1051a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1051ac:	c7 44 24 08 08 7c 10 	movl   $0x107c08,0x8(%esp)
  1051b3:	00 
  1051b4:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  1051bb:	00 
  1051bc:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1051c3:	e8 22 bb ff ff       	call   100cea <__panic>
  1051c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051cb:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1051d1:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1051d6:	05 ac 0f 00 00       	add    $0xfac,%eax
  1051db:	83 ca 03             	or     $0x3,%edx
  1051de:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1051e0:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1051e5:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1051ec:	00 
  1051ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1051f4:	00 
  1051f5:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1051fc:	38 
  1051fd:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  105204:	c0 
  105205:	89 04 24             	mov    %eax,(%esp)
  105208:	e8 e0 fd ff ff       	call   104fed <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10520d:	e8 39 f8 ff ff       	call   104a4b <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  105212:	e8 24 0a 00 00       	call   105c3b <check_boot_pgdir>

    print_pgdir();
  105217:	e8 a1 0e 00 00       	call   1060bd <print_pgdir>
}
  10521c:	90                   	nop
  10521d:	89 ec                	mov    %ebp,%esp
  10521f:	5d                   	pop    %ebp
  105220:	c3                   	ret    

00105221 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
  105221:	55                   	push   %ebp
  105222:	89 e5                	mov    %esp,%ebp
  105224:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep = &pgdir[PDX(la)];
  105227:	8b 45 0c             	mov    0xc(%ebp),%eax
  10522a:	c1 e8 16             	shr    $0x16,%eax
  10522d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105234:	8b 45 08             	mov    0x8(%ebp),%eax
  105237:	01 d0                	add    %edx,%eax
  105239:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
  10523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10523f:	8b 00                	mov    (%eax),%eax
  105241:	83 e0 01             	and    $0x1,%eax
  105244:	85 c0                	test   %eax,%eax
  105246:	0f 85 af 00 00 00    	jne    1052fb <get_pte+0xda>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
  10524c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105250:	74 15                	je     105267 <get_pte+0x46>
  105252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105259:	e8 31 f9 ff ff       	call   104b8f <alloc_pages>
  10525e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105265:	75 0a                	jne    105271 <get_pte+0x50>
        {
            return NULL;
  105267:	b8 00 00 00 00       	mov    $0x0,%eax
  10526c:	e9 e7 00 00 00       	jmp    105358 <get_pte+0x137>
        }
        //设置page reference
        set_page_ref(page, 1);
  105271:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105278:	00 
  105279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10527c:	89 04 24             	mov    %eax,(%esp)
  10527f:	e8 05 f7 ff ff       	call   104989 <set_page_ref>
        //得到page的线性地址
        uintptr_t pa = page2pa(page);
  105284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105287:	89 04 24             	mov    %eax,(%esp)
  10528a:	e8 d7 f5 ff ff       	call   104866 <page2pa>
  10528f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        //用memset清除page
        memset(KADDR(pa), 0, PGSIZE);
  105292:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105295:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10529b:	c1 e8 0c             	shr    $0xc,%eax
  10529e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052a1:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1052a6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1052a9:	72 23                	jb     1052ce <get_pte+0xad>
  1052ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1052b2:	c7 44 24 08 64 7b 10 	movl   $0x107b64,0x8(%esp)
  1052b9:	00 
  1052ba:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
  1052c1:	00 
  1052c2:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1052c9:	e8 1c ba ff ff       	call   100cea <__panic>
  1052ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052d1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1052d6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1052dd:	00 
  1052de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052e5:	00 
  1052e6:	89 04 24             	mov    %eax,(%esp)
  1052e9:	e8 d4 18 00 00       	call   106bc2 <memset>
        //返回PTE
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1052ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052f1:	83 c8 07             	or     $0x7,%eax
  1052f4:	89 c2                	mov    %eax,%edx
  1052f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052f9:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1052fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052fe:	8b 00                	mov    (%eax),%eax
  105300:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105305:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10530b:	c1 e8 0c             	shr    $0xc,%eax
  10530e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105311:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105316:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105319:	72 23                	jb     10533e <get_pte+0x11d>
  10531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10531e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105322:	c7 44 24 08 64 7b 10 	movl   $0x107b64,0x8(%esp)
  105329:	00 
  10532a:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
  105331:	00 
  105332:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105339:	e8 ac b9 ff ff       	call   100cea <__panic>
  10533e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105341:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105346:	89 c2                	mov    %eax,%edx
  105348:	8b 45 0c             	mov    0xc(%ebp),%eax
  10534b:	c1 e8 0c             	shr    $0xc,%eax
  10534e:	25 ff 03 00 00       	and    $0x3ff,%eax
  105353:	c1 e0 02             	shl    $0x2,%eax
  105356:	01 d0                	add    %edx,%eax
}
  105358:	89 ec                	mov    %ebp,%esp
  10535a:	5d                   	pop    %ebp
  10535b:	c3                   	ret    

0010535c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
  10535c:	55                   	push   %ebp
  10535d:	89 e5                	mov    %esp,%ebp
  10535f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  105362:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105369:	00 
  10536a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10536d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105371:	8b 45 08             	mov    0x8(%ebp),%eax
  105374:	89 04 24             	mov    %eax,(%esp)
  105377:	e8 a5 fe ff ff       	call   105221 <get_pte>
  10537c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
  10537f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105383:	74 08                	je     10538d <get_page+0x31>
    {
        *ptep_store = ptep;
  105385:	8b 45 10             	mov    0x10(%ebp),%eax
  105388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10538b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
  10538d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105391:	74 1b                	je     1053ae <get_page+0x52>
  105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105396:	8b 00                	mov    (%eax),%eax
  105398:	83 e0 01             	and    $0x1,%eax
  10539b:	85 c0                	test   %eax,%eax
  10539d:	74 0f                	je     1053ae <get_page+0x52>
    {
        return pte2page(*ptep);
  10539f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053a2:	8b 00                	mov    (%eax),%eax
  1053a4:	89 04 24             	mov    %eax,(%esp)
  1053a7:	e8 79 f5 ff ff       	call   104925 <pte2page>
  1053ac:	eb 05                	jmp    1053b3 <get_page+0x57>
    }
    return NULL;
  1053ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1053b3:	89 ec                	mov    %ebp,%esp
  1053b5:	5d                   	pop    %ebp
  1053b6:	c3                   	ret    

001053b7 <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
  1053b7:	55                   	push   %ebp
  1053b8:	89 e5                	mov    %esp,%ebp
  1053ba:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
  1053bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1053c0:	8b 00                	mov    (%eax),%eax
  1053c2:	83 e0 01             	and    $0x1,%eax
  1053c5:	85 c0                	test   %eax,%eax
  1053c7:	74 4d                	je     105416 <page_remove_pte+0x5f>
    {
        struct Page *page = pte2page(*ptep);
  1053c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1053cc:	8b 00                	mov    (%eax),%eax
  1053ce:	89 04 24             	mov    %eax,(%esp)
  1053d1:	e8 4f f5 ff ff       	call   104925 <pte2page>
  1053d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //  (page_ref_dec(page)将page的ref减1,并返回减1之后的ref
        if (page_ref_dec(page) == 0)
  1053d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053dc:	89 04 24             	mov    %eax,(%esp)
  1053df:	e8 ca f5 ff ff       	call   1049ae <page_ref_dec>
  1053e4:	85 c0                	test   %eax,%eax
  1053e6:	75 13                	jne    1053fb <page_remove_pte+0x44>
        {
            free_page(page);
  1053e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053ef:	00 
  1053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053f3:	89 04 24             	mov    %eax,(%esp)
  1053f6:	e8 ce f7 ff ff       	call   104bc9 <free_pages>
        }
        //清除第二个页表 PTE
        *ptep = 0;
  1053fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1053fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  105404:	8b 45 0c             	mov    0xc(%ebp),%eax
  105407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10540b:	8b 45 08             	mov    0x8(%ebp),%eax
  10540e:	89 04 24             	mov    %eax,(%esp)
  105411:	e8 07 01 00 00       	call   10551d <tlb_invalidate>
    }
}
  105416:	90                   	nop
  105417:	89 ec                	mov    %ebp,%esp
  105419:	5d                   	pop    %ebp
  10541a:	c3                   	ret    

0010541b <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
  10541b:	55                   	push   %ebp
  10541c:	89 e5                	mov    %esp,%ebp
  10541e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  105421:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105428:	00 
  105429:	8b 45 0c             	mov    0xc(%ebp),%eax
  10542c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105430:	8b 45 08             	mov    0x8(%ebp),%eax
  105433:	89 04 24             	mov    %eax,(%esp)
  105436:	e8 e6 fd ff ff       	call   105221 <get_pte>
  10543b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
  10543e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105442:	74 19                	je     10545d <page_remove+0x42>
    {
        page_remove_pte(pgdir, la, ptep);
  105444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105447:	89 44 24 08          	mov    %eax,0x8(%esp)
  10544b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10544e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105452:	8b 45 08             	mov    0x8(%ebp),%eax
  105455:	89 04 24             	mov    %eax,(%esp)
  105458:	e8 5a ff ff ff       	call   1053b7 <page_remove_pte>
    }
}
  10545d:	90                   	nop
  10545e:	89 ec                	mov    %ebp,%esp
  105460:	5d                   	pop    %ebp
  105461:	c3                   	ret    

00105462 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
  105462:	55                   	push   %ebp
  105463:	89 e5                	mov    %esp,%ebp
  105465:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  105468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10546f:	00 
  105470:	8b 45 10             	mov    0x10(%ebp),%eax
  105473:	89 44 24 04          	mov    %eax,0x4(%esp)
  105477:	8b 45 08             	mov    0x8(%ebp),%eax
  10547a:	89 04 24             	mov    %eax,(%esp)
  10547d:	e8 9f fd ff ff       	call   105221 <get_pte>
  105482:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
  105485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105489:	75 0a                	jne    105495 <page_insert+0x33>
    {
        return -E_NO_MEM;
  10548b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  105490:	e9 84 00 00 00       	jmp    105519 <page_insert+0xb7>
    }
    page_ref_inc(page);
  105495:	8b 45 0c             	mov    0xc(%ebp),%eax
  105498:	89 04 24             	mov    %eax,(%esp)
  10549b:	e8 f7 f4 ff ff       	call   104997 <page_ref_inc>
    if (*ptep & PTE_P)
  1054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054a3:	8b 00                	mov    (%eax),%eax
  1054a5:	83 e0 01             	and    $0x1,%eax
  1054a8:	85 c0                	test   %eax,%eax
  1054aa:	74 3e                	je     1054ea <page_insert+0x88>
    {
        struct Page *p = pte2page(*ptep);
  1054ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054af:	8b 00                	mov    (%eax),%eax
  1054b1:	89 04 24             	mov    %eax,(%esp)
  1054b4:	e8 6c f4 ff ff       	call   104925 <pte2page>
  1054b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
  1054bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054c2:	75 0d                	jne    1054d1 <page_insert+0x6f>
        {
            page_ref_dec(page);
  1054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c7:	89 04 24             	mov    %eax,(%esp)
  1054ca:	e8 df f4 ff ff       	call   1049ae <page_ref_dec>
  1054cf:	eb 19                	jmp    1054ea <page_insert+0x88>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
  1054d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1054db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054df:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e2:	89 04 24             	mov    %eax,(%esp)
  1054e5:	e8 cd fe ff ff       	call   1053b7 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1054ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054ed:	89 04 24             	mov    %eax,(%esp)
  1054f0:	e8 71 f3 ff ff       	call   104866 <page2pa>
  1054f5:	0b 45 14             	or     0x14(%ebp),%eax
  1054f8:	83 c8 01             	or     $0x1,%eax
  1054fb:	89 c2                	mov    %eax,%edx
  1054fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105500:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  105502:	8b 45 10             	mov    0x10(%ebp),%eax
  105505:	89 44 24 04          	mov    %eax,0x4(%esp)
  105509:	8b 45 08             	mov    0x8(%ebp),%eax
  10550c:	89 04 24             	mov    %eax,(%esp)
  10550f:	e8 09 00 00 00       	call   10551d <tlb_invalidate>
    return 0;
  105514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105519:	89 ec                	mov    %ebp,%esp
  10551b:	5d                   	pop    %ebp
  10551c:	c3                   	ret    

0010551d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
  10551d:	55                   	push   %ebp
  10551e:	89 e5                	mov    %esp,%ebp
  105520:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
  105523:	0f 20 d8             	mov    %cr3,%eax
  105526:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
  105529:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
  10552c:	8b 45 08             	mov    0x8(%ebp),%eax
  10552f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105532:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  105539:	77 23                	ja     10555e <tlb_invalidate+0x41>
  10553b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10553e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105542:	c7 44 24 08 08 7c 10 	movl   $0x107c08,0x8(%esp)
  105549:	00 
  10554a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  105551:	00 
  105552:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105559:	e8 8c b7 ff ff       	call   100cea <__panic>
  10555e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105561:	05 00 00 00 40       	add    $0x40000000,%eax
  105566:	39 d0                	cmp    %edx,%eax
  105568:	75 0d                	jne    105577 <tlb_invalidate+0x5a>
    {
        invlpg((void *)la);
  10556a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10556d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
  105570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105573:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
  105576:	90                   	nop
    }
}
  105577:	90                   	nop
  105578:	89 ec                	mov    %ebp,%esp
  10557a:	5d                   	pop    %ebp
  10557b:	c3                   	ret    

0010557c <check_alloc_page>:

static void
check_alloc_page(void)
{
  10557c:	55                   	push   %ebp
  10557d:	89 e5                	mov    %esp,%ebp
  10557f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  105582:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  105587:	8b 40 18             	mov    0x18(%eax),%eax
  10558a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10558c:	c7 04 24 8c 7c 10 00 	movl   $0x107c8c,(%esp)
  105593:	e8 cd ad ff ff       	call   100365 <cprintf>
}
  105598:	90                   	nop
  105599:	89 ec                	mov    %ebp,%esp
  10559b:	5d                   	pop    %ebp
  10559c:	c3                   	ret    

0010559d <check_pgdir>:

static void
check_pgdir(void)
{
  10559d:	55                   	push   %ebp
  10559e:	89 e5                	mov    %esp,%ebp
  1055a0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1055a3:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1055a8:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1055ad:	76 24                	jbe    1055d3 <check_pgdir+0x36>
  1055af:	c7 44 24 0c ab 7c 10 	movl   $0x107cab,0xc(%esp)
  1055b6:	00 
  1055b7:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1055be:	00 
  1055bf:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  1055c6:	00 
  1055c7:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1055ce:	e8 17 b7 ff ff       	call   100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1055d3:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1055d8:	85 c0                	test   %eax,%eax
  1055da:	74 0e                	je     1055ea <check_pgdir+0x4d>
  1055dc:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1055e1:	25 ff 0f 00 00       	and    $0xfff,%eax
  1055e6:	85 c0                	test   %eax,%eax
  1055e8:	74 24                	je     10560e <check_pgdir+0x71>
  1055ea:	c7 44 24 0c c8 7c 10 	movl   $0x107cc8,0xc(%esp)
  1055f1:	00 
  1055f2:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1055f9:	00 
  1055fa:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  105601:	00 
  105602:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105609:	e8 dc b6 ff ff       	call   100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10560e:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105613:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10561a:	00 
  10561b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105622:	00 
  105623:	89 04 24             	mov    %eax,(%esp)
  105626:	e8 31 fd ff ff       	call   10535c <get_page>
  10562b:	85 c0                	test   %eax,%eax
  10562d:	74 24                	je     105653 <check_pgdir+0xb6>
  10562f:	c7 44 24 0c 00 7d 10 	movl   $0x107d00,0xc(%esp)
  105636:	00 
  105637:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  10563e:	00 
  10563f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  105646:	00 
  105647:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  10564e:	e8 97 b6 ff ff       	call   100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  105653:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10565a:	e8 30 f5 ff ff       	call   104b8f <alloc_pages>
  10565f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  105662:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105667:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10566e:	00 
  10566f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105676:	00 
  105677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10567a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10567e:	89 04 24             	mov    %eax,(%esp)
  105681:	e8 dc fd ff ff       	call   105462 <page_insert>
  105686:	85 c0                	test   %eax,%eax
  105688:	74 24                	je     1056ae <check_pgdir+0x111>
  10568a:	c7 44 24 0c 28 7d 10 	movl   $0x107d28,0xc(%esp)
  105691:	00 
  105692:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105699:	00 
  10569a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  1056a1:	00 
  1056a2:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1056a9:	e8 3c b6 ff ff       	call   100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1056ae:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1056b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1056ba:	00 
  1056bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1056c2:	00 
  1056c3:	89 04 24             	mov    %eax,(%esp)
  1056c6:	e8 56 fb ff ff       	call   105221 <get_pte>
  1056cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1056d2:	75 24                	jne    1056f8 <check_pgdir+0x15b>
  1056d4:	c7 44 24 0c 54 7d 10 	movl   $0x107d54,0xc(%esp)
  1056db:	00 
  1056dc:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1056e3:	00 
  1056e4:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  1056eb:	00 
  1056ec:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1056f3:	e8 f2 b5 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  1056f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056fb:	8b 00                	mov    (%eax),%eax
  1056fd:	89 04 24             	mov    %eax,(%esp)
  105700:	e8 20 f2 ff ff       	call   104925 <pte2page>
  105705:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105708:	74 24                	je     10572e <check_pgdir+0x191>
  10570a:	c7 44 24 0c 81 7d 10 	movl   $0x107d81,0xc(%esp)
  105711:	00 
  105712:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105719:	00 
  10571a:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  105721:	00 
  105722:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105729:	e8 bc b5 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 1);
  10572e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105731:	89 04 24             	mov    %eax,(%esp)
  105734:	e8 46 f2 ff ff       	call   10497f <page_ref>
  105739:	83 f8 01             	cmp    $0x1,%eax
  10573c:	74 24                	je     105762 <check_pgdir+0x1c5>
  10573e:	c7 44 24 0c 97 7d 10 	movl   $0x107d97,0xc(%esp)
  105745:	00 
  105746:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  10574d:	00 
  10574e:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105755:	00 
  105756:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  10575d:	e8 88 b5 ff ff       	call   100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  105762:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105767:	8b 00                	mov    (%eax),%eax
  105769:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10576e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105774:	c1 e8 0c             	shr    $0xc,%eax
  105777:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10577a:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  10577f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105782:	72 23                	jb     1057a7 <check_pgdir+0x20a>
  105784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105787:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10578b:	c7 44 24 08 64 7b 10 	movl   $0x107b64,0x8(%esp)
  105792:	00 
  105793:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  10579a:	00 
  10579b:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1057a2:	e8 43 b5 ff ff       	call   100cea <__panic>
  1057a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1057af:	83 c0 04             	add    $0x4,%eax
  1057b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1057b5:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1057ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1057c1:	00 
  1057c2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1057c9:	00 
  1057ca:	89 04 24             	mov    %eax,(%esp)
  1057cd:	e8 4f fa ff ff       	call   105221 <get_pte>
  1057d2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1057d5:	74 24                	je     1057fb <check_pgdir+0x25e>
  1057d7:	c7 44 24 0c ac 7d 10 	movl   $0x107dac,0xc(%esp)
  1057de:	00 
  1057df:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1057e6:	00 
  1057e7:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  1057ee:	00 
  1057ef:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1057f6:	e8 ef b4 ff ff       	call   100cea <__panic>

    p2 = alloc_page();
  1057fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105802:	e8 88 f3 ff ff       	call   104b8f <alloc_pages>
  105807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10580a:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10580f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  105816:	00 
  105817:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10581e:	00 
  10581f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105822:	89 54 24 04          	mov    %edx,0x4(%esp)
  105826:	89 04 24             	mov    %eax,(%esp)
  105829:	e8 34 fc ff ff       	call   105462 <page_insert>
  10582e:	85 c0                	test   %eax,%eax
  105830:	74 24                	je     105856 <check_pgdir+0x2b9>
  105832:	c7 44 24 0c d4 7d 10 	movl   $0x107dd4,0xc(%esp)
  105839:	00 
  10583a:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105841:	00 
  105842:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  105849:	00 
  10584a:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105851:	e8 94 b4 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105856:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10585b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105862:	00 
  105863:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10586a:	00 
  10586b:	89 04 24             	mov    %eax,(%esp)
  10586e:	e8 ae f9 ff ff       	call   105221 <get_pte>
  105873:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10587a:	75 24                	jne    1058a0 <check_pgdir+0x303>
  10587c:	c7 44 24 0c 0c 7e 10 	movl   $0x107e0c,0xc(%esp)
  105883:	00 
  105884:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  10588b:	00 
  10588c:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  105893:	00 
  105894:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  10589b:	e8 4a b4 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_U);
  1058a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058a3:	8b 00                	mov    (%eax),%eax
  1058a5:	83 e0 04             	and    $0x4,%eax
  1058a8:	85 c0                	test   %eax,%eax
  1058aa:	75 24                	jne    1058d0 <check_pgdir+0x333>
  1058ac:	c7 44 24 0c 3c 7e 10 	movl   $0x107e3c,0xc(%esp)
  1058b3:	00 
  1058b4:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1058bb:	00 
  1058bc:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  1058c3:	00 
  1058c4:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1058cb:	e8 1a b4 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_W);
  1058d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058d3:	8b 00                	mov    (%eax),%eax
  1058d5:	83 e0 02             	and    $0x2,%eax
  1058d8:	85 c0                	test   %eax,%eax
  1058da:	75 24                	jne    105900 <check_pgdir+0x363>
  1058dc:	c7 44 24 0c 4a 7e 10 	movl   $0x107e4a,0xc(%esp)
  1058e3:	00 
  1058e4:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1058eb:	00 
  1058ec:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  1058f3:	00 
  1058f4:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1058fb:	e8 ea b3 ff ff       	call   100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
  105900:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105905:	8b 00                	mov    (%eax),%eax
  105907:	83 e0 04             	and    $0x4,%eax
  10590a:	85 c0                	test   %eax,%eax
  10590c:	75 24                	jne    105932 <check_pgdir+0x395>
  10590e:	c7 44 24 0c 58 7e 10 	movl   $0x107e58,0xc(%esp)
  105915:	00 
  105916:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  10591d:	00 
  10591e:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  105925:	00 
  105926:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  10592d:	e8 b8 b3 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 1);
  105932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105935:	89 04 24             	mov    %eax,(%esp)
  105938:	e8 42 f0 ff ff       	call   10497f <page_ref>
  10593d:	83 f8 01             	cmp    $0x1,%eax
  105940:	74 24                	je     105966 <check_pgdir+0x3c9>
  105942:	c7 44 24 0c 6e 7e 10 	movl   $0x107e6e,0xc(%esp)
  105949:	00 
  10594a:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105951:	00 
  105952:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  105959:	00 
  10595a:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105961:	e8 84 b3 ff ff       	call   100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  105966:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10596b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105972:	00 
  105973:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10597a:	00 
  10597b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10597e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105982:	89 04 24             	mov    %eax,(%esp)
  105985:	e8 d8 fa ff ff       	call   105462 <page_insert>
  10598a:	85 c0                	test   %eax,%eax
  10598c:	74 24                	je     1059b2 <check_pgdir+0x415>
  10598e:	c7 44 24 0c 80 7e 10 	movl   $0x107e80,0xc(%esp)
  105995:	00 
  105996:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  10599d:	00 
  10599e:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  1059a5:	00 
  1059a6:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1059ad:	e8 38 b3 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 2);
  1059b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059b5:	89 04 24             	mov    %eax,(%esp)
  1059b8:	e8 c2 ef ff ff       	call   10497f <page_ref>
  1059bd:	83 f8 02             	cmp    $0x2,%eax
  1059c0:	74 24                	je     1059e6 <check_pgdir+0x449>
  1059c2:	c7 44 24 0c ac 7e 10 	movl   $0x107eac,0xc(%esp)
  1059c9:	00 
  1059ca:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  1059d1:	00 
  1059d2:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  1059d9:	00 
  1059da:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  1059e1:	e8 04 b3 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  1059e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059e9:	89 04 24             	mov    %eax,(%esp)
  1059ec:	e8 8e ef ff ff       	call   10497f <page_ref>
  1059f1:	85 c0                	test   %eax,%eax
  1059f3:	74 24                	je     105a19 <check_pgdir+0x47c>
  1059f5:	c7 44 24 0c be 7e 10 	movl   $0x107ebe,0xc(%esp)
  1059fc:	00 
  1059fd:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105a04:	00 
  105a05:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  105a0c:	00 
  105a0d:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105a14:	e8 d1 b2 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105a19:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105a1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105a25:	00 
  105a26:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105a2d:	00 
  105a2e:	89 04 24             	mov    %eax,(%esp)
  105a31:	e8 eb f7 ff ff       	call   105221 <get_pte>
  105a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a3d:	75 24                	jne    105a63 <check_pgdir+0x4c6>
  105a3f:	c7 44 24 0c 0c 7e 10 	movl   $0x107e0c,0xc(%esp)
  105a46:	00 
  105a47:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105a4e:	00 
  105a4f:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  105a56:	00 
  105a57:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105a5e:	e8 87 b2 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  105a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a66:	8b 00                	mov    (%eax),%eax
  105a68:	89 04 24             	mov    %eax,(%esp)
  105a6b:	e8 b5 ee ff ff       	call   104925 <pte2page>
  105a70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105a73:	74 24                	je     105a99 <check_pgdir+0x4fc>
  105a75:	c7 44 24 0c 81 7d 10 	movl   $0x107d81,0xc(%esp)
  105a7c:	00 
  105a7d:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105a84:	00 
  105a85:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  105a8c:	00 
  105a8d:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105a94:	e8 51 b2 ff ff       	call   100cea <__panic>
    assert((*ptep & PTE_U) == 0);
  105a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a9c:	8b 00                	mov    (%eax),%eax
  105a9e:	83 e0 04             	and    $0x4,%eax
  105aa1:	85 c0                	test   %eax,%eax
  105aa3:	74 24                	je     105ac9 <check_pgdir+0x52c>
  105aa5:	c7 44 24 0c d0 7e 10 	movl   $0x107ed0,0xc(%esp)
  105aac:	00 
  105aad:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105ab4:	00 
  105ab5:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  105abc:	00 
  105abd:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105ac4:	e8 21 b2 ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, 0x0);
  105ac9:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105ace:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105ad5:	00 
  105ad6:	89 04 24             	mov    %eax,(%esp)
  105ad9:	e8 3d f9 ff ff       	call   10541b <page_remove>
    assert(page_ref(p1) == 1);
  105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ae1:	89 04 24             	mov    %eax,(%esp)
  105ae4:	e8 96 ee ff ff       	call   10497f <page_ref>
  105ae9:	83 f8 01             	cmp    $0x1,%eax
  105aec:	74 24                	je     105b12 <check_pgdir+0x575>
  105aee:	c7 44 24 0c 97 7d 10 	movl   $0x107d97,0xc(%esp)
  105af5:	00 
  105af6:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105afd:	00 
  105afe:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  105b05:	00 
  105b06:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105b0d:	e8 d8 b1 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  105b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b15:	89 04 24             	mov    %eax,(%esp)
  105b18:	e8 62 ee ff ff       	call   10497f <page_ref>
  105b1d:	85 c0                	test   %eax,%eax
  105b1f:	74 24                	je     105b45 <check_pgdir+0x5a8>
  105b21:	c7 44 24 0c be 7e 10 	movl   $0x107ebe,0xc(%esp)
  105b28:	00 
  105b29:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105b30:	00 
  105b31:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105b38:	00 
  105b39:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105b40:	e8 a5 b1 ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
  105b45:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105b4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105b51:	00 
  105b52:	89 04 24             	mov    %eax,(%esp)
  105b55:	e8 c1 f8 ff ff       	call   10541b <page_remove>
    assert(page_ref(p1) == 0);
  105b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b5d:	89 04 24             	mov    %eax,(%esp)
  105b60:	e8 1a ee ff ff       	call   10497f <page_ref>
  105b65:	85 c0                	test   %eax,%eax
  105b67:	74 24                	je     105b8d <check_pgdir+0x5f0>
  105b69:	c7 44 24 0c e5 7e 10 	movl   $0x107ee5,0xc(%esp)
  105b70:	00 
  105b71:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105b78:	00 
  105b79:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105b80:	00 
  105b81:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105b88:	e8 5d b1 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  105b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b90:	89 04 24             	mov    %eax,(%esp)
  105b93:	e8 e7 ed ff ff       	call   10497f <page_ref>
  105b98:	85 c0                	test   %eax,%eax
  105b9a:	74 24                	je     105bc0 <check_pgdir+0x623>
  105b9c:	c7 44 24 0c be 7e 10 	movl   $0x107ebe,0xc(%esp)
  105ba3:	00 
  105ba4:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105bab:	00 
  105bac:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  105bb3:	00 
  105bb4:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105bbb:	e8 2a b1 ff ff       	call   100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  105bc0:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105bc5:	8b 00                	mov    (%eax),%eax
  105bc7:	89 04 24             	mov    %eax,(%esp)
  105bca:	e8 96 ed ff ff       	call   104965 <pde2page>
  105bcf:	89 04 24             	mov    %eax,(%esp)
  105bd2:	e8 a8 ed ff ff       	call   10497f <page_ref>
  105bd7:	83 f8 01             	cmp    $0x1,%eax
  105bda:	74 24                	je     105c00 <check_pgdir+0x663>
  105bdc:	c7 44 24 0c f8 7e 10 	movl   $0x107ef8,0xc(%esp)
  105be3:	00 
  105be4:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105beb:	00 
  105bec:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  105bf3:	00 
  105bf4:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105bfb:	e8 ea b0 ff ff       	call   100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
  105c00:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c05:	8b 00                	mov    (%eax),%eax
  105c07:	89 04 24             	mov    %eax,(%esp)
  105c0a:	e8 56 ed ff ff       	call   104965 <pde2page>
  105c0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105c16:	00 
  105c17:	89 04 24             	mov    %eax,(%esp)
  105c1a:	e8 aa ef ff ff       	call   104bc9 <free_pages>
    boot_pgdir[0] = 0;
  105c1f:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105c2a:	c7 04 24 1f 7f 10 00 	movl   $0x107f1f,(%esp)
  105c31:	e8 2f a7 ff ff       	call   100365 <cprintf>
}
  105c36:	90                   	nop
  105c37:	89 ec                	mov    %ebp,%esp
  105c39:	5d                   	pop    %ebp
  105c3a:	c3                   	ret    

00105c3b <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
  105c3b:	55                   	push   %ebp
  105c3c:	89 e5                	mov    %esp,%ebp
  105c3e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
  105c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105c48:	e9 ca 00 00 00       	jmp    105d17 <check_boot_pgdir+0xdc>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c56:	c1 e8 0c             	shr    $0xc,%eax
  105c59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c5c:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105c61:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105c64:	72 23                	jb     105c89 <check_boot_pgdir+0x4e>
  105c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c6d:	c7 44 24 08 64 7b 10 	movl   $0x107b64,0x8(%esp)
  105c74:	00 
  105c75:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105c7c:	00 
  105c7d:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105c84:	e8 61 b0 ff ff       	call   100cea <__panic>
  105c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c8c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105c91:	89 c2                	mov    %eax,%edx
  105c93:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c98:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105c9f:	00 
  105ca0:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ca4:	89 04 24             	mov    %eax,(%esp)
  105ca7:	e8 75 f5 ff ff       	call   105221 <get_pte>
  105cac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105caf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105cb3:	75 24                	jne    105cd9 <check_boot_pgdir+0x9e>
  105cb5:	c7 44 24 0c 3c 7f 10 	movl   $0x107f3c,0xc(%esp)
  105cbc:	00 
  105cbd:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105cc4:	00 
  105cc5:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  105ccc:	00 
  105ccd:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105cd4:	e8 11 b0 ff ff       	call   100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105cdc:	8b 00                	mov    (%eax),%eax
  105cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105ce3:	89 c2                	mov    %eax,%edx
  105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ce8:	39 c2                	cmp    %eax,%edx
  105cea:	74 24                	je     105d10 <check_boot_pgdir+0xd5>
  105cec:	c7 44 24 0c 79 7f 10 	movl   $0x107f79,0xc(%esp)
  105cf3:	00 
  105cf4:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105cfb:	00 
  105cfc:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
  105d03:	00 
  105d04:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105d0b:	e8 da af ff ff       	call   100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE)
  105d10:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d1a:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105d1f:	39 c2                	cmp    %eax,%edx
  105d21:	0f 82 26 ff ff ff    	jb     105c4d <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105d27:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d2c:	05 ac 0f 00 00       	add    $0xfac,%eax
  105d31:	8b 00                	mov    (%eax),%eax
  105d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105d38:	89 c2                	mov    %eax,%edx
  105d3a:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d42:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105d49:	77 23                	ja     105d6e <check_boot_pgdir+0x133>
  105d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d52:	c7 44 24 08 08 7c 10 	movl   $0x107c08,0x8(%esp)
  105d59:	00 
  105d5a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
  105d61:	00 
  105d62:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105d69:	e8 7c af ff ff       	call   100cea <__panic>
  105d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d71:	05 00 00 00 40       	add    $0x40000000,%eax
  105d76:	39 d0                	cmp    %edx,%eax
  105d78:	74 24                	je     105d9e <check_boot_pgdir+0x163>
  105d7a:	c7 44 24 0c 90 7f 10 	movl   $0x107f90,0xc(%esp)
  105d81:	00 
  105d82:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105d89:	00 
  105d8a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
  105d91:	00 
  105d92:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105d99:	e8 4c af ff ff       	call   100cea <__panic>

    assert(boot_pgdir[0] == 0);
  105d9e:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105da3:	8b 00                	mov    (%eax),%eax
  105da5:	85 c0                	test   %eax,%eax
  105da7:	74 24                	je     105dcd <check_boot_pgdir+0x192>
  105da9:	c7 44 24 0c c4 7f 10 	movl   $0x107fc4,0xc(%esp)
  105db0:	00 
  105db1:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105db8:	00 
  105db9:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
  105dc0:	00 
  105dc1:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105dc8:	e8 1d af ff ff       	call   100cea <__panic>

    struct Page *p;
    p = alloc_page();
  105dcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105dd4:	e8 b6 ed ff ff       	call   104b8f <alloc_pages>
  105dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105ddc:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105de1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105de8:	00 
  105de9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105df0:	00 
  105df1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105df4:	89 54 24 04          	mov    %edx,0x4(%esp)
  105df8:	89 04 24             	mov    %eax,(%esp)
  105dfb:	e8 62 f6 ff ff       	call   105462 <page_insert>
  105e00:	85 c0                	test   %eax,%eax
  105e02:	74 24                	je     105e28 <check_boot_pgdir+0x1ed>
  105e04:	c7 44 24 0c d8 7f 10 	movl   $0x107fd8,0xc(%esp)
  105e0b:	00 
  105e0c:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105e13:	00 
  105e14:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
  105e1b:	00 
  105e1c:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105e23:	e8 c2 ae ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 1);
  105e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e2b:	89 04 24             	mov    %eax,(%esp)
  105e2e:	e8 4c eb ff ff       	call   10497f <page_ref>
  105e33:	83 f8 01             	cmp    $0x1,%eax
  105e36:	74 24                	je     105e5c <check_boot_pgdir+0x221>
  105e38:	c7 44 24 0c 06 80 10 	movl   $0x108006,0xc(%esp)
  105e3f:	00 
  105e40:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105e47:	00 
  105e48:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
  105e4f:	00 
  105e50:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105e57:	e8 8e ae ff ff       	call   100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105e5c:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105e61:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105e68:	00 
  105e69:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105e70:	00 
  105e71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e74:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e78:	89 04 24             	mov    %eax,(%esp)
  105e7b:	e8 e2 f5 ff ff       	call   105462 <page_insert>
  105e80:	85 c0                	test   %eax,%eax
  105e82:	74 24                	je     105ea8 <check_boot_pgdir+0x26d>
  105e84:	c7 44 24 0c 18 80 10 	movl   $0x108018,0xc(%esp)
  105e8b:	00 
  105e8c:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105e93:	00 
  105e94:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
  105e9b:	00 
  105e9c:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105ea3:	e8 42 ae ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 2);
  105ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eab:	89 04 24             	mov    %eax,(%esp)
  105eae:	e8 cc ea ff ff       	call   10497f <page_ref>
  105eb3:	83 f8 02             	cmp    $0x2,%eax
  105eb6:	74 24                	je     105edc <check_boot_pgdir+0x2a1>
  105eb8:	c7 44 24 0c 4f 80 10 	movl   $0x10804f,0xc(%esp)
  105ebf:	00 
  105ec0:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105ec7:	00 
  105ec8:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
  105ecf:	00 
  105ed0:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105ed7:	e8 0e ae ff ff       	call   100cea <__panic>

    const char *str = "ucore: Hello world!!";
  105edc:	c7 45 e8 60 80 10 00 	movl   $0x108060,-0x18(%ebp)
    strcpy((void *)0x100, str);
  105ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105ef1:	e8 fc 09 00 00       	call   1068f2 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105ef6:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105efd:	00 
  105efe:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105f05:	e8 60 0a 00 00       	call   10696a <strcmp>
  105f0a:	85 c0                	test   %eax,%eax
  105f0c:	74 24                	je     105f32 <check_boot_pgdir+0x2f7>
  105f0e:	c7 44 24 0c 78 80 10 	movl   $0x108078,0xc(%esp)
  105f15:	00 
  105f16:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105f1d:	00 
  105f1e:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
  105f25:	00 
  105f26:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105f2d:	e8 b8 ad ff ff       	call   100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f35:	89 04 24             	mov    %eax,(%esp)
  105f38:	e8 92 e9 ff ff       	call   1048cf <page2kva>
  105f3d:	05 00 01 00 00       	add    $0x100,%eax
  105f42:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105f45:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105f4c:	e8 47 09 00 00       	call   106898 <strlen>
  105f51:	85 c0                	test   %eax,%eax
  105f53:	74 24                	je     105f79 <check_boot_pgdir+0x33e>
  105f55:	c7 44 24 0c b0 80 10 	movl   $0x1080b0,0xc(%esp)
  105f5c:	00 
  105f5d:	c7 44 24 08 51 7c 10 	movl   $0x107c51,0x8(%esp)
  105f64:	00 
  105f65:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
  105f6c:	00 
  105f6d:	c7 04 24 2c 7c 10 00 	movl   $0x107c2c,(%esp)
  105f74:	e8 71 ad ff ff       	call   100cea <__panic>

    free_page(p);
  105f79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105f80:	00 
  105f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f84:	89 04 24             	mov    %eax,(%esp)
  105f87:	e8 3d ec ff ff       	call   104bc9 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105f8c:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105f91:	8b 00                	mov    (%eax),%eax
  105f93:	89 04 24             	mov    %eax,(%esp)
  105f96:	e8 ca e9 ff ff       	call   104965 <pde2page>
  105f9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105fa2:	00 
  105fa3:	89 04 24             	mov    %eax,(%esp)
  105fa6:	e8 1e ec ff ff       	call   104bc9 <free_pages>
    boot_pgdir[0] = 0;
  105fab:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105fb6:	c7 04 24 d4 80 10 00 	movl   $0x1080d4,(%esp)
  105fbd:	e8 a3 a3 ff ff       	call   100365 <cprintf>
}
  105fc2:	90                   	nop
  105fc3:	89 ec                	mov    %ebp,%esp
  105fc5:	5d                   	pop    %ebp
  105fc6:	c3                   	ret    

00105fc7 <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
  105fc7:	55                   	push   %ebp
  105fc8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105fca:	8b 45 08             	mov    0x8(%ebp),%eax
  105fcd:	83 e0 04             	and    $0x4,%eax
  105fd0:	85 c0                	test   %eax,%eax
  105fd2:	74 04                	je     105fd8 <perm2str+0x11>
  105fd4:	b0 75                	mov    $0x75,%al
  105fd6:	eb 02                	jmp    105fda <perm2str+0x13>
  105fd8:	b0 2d                	mov    $0x2d,%al
  105fda:	a2 28 ef 11 00       	mov    %al,0x11ef28
    str[1] = 'r';
  105fdf:	c6 05 29 ef 11 00 72 	movb   $0x72,0x11ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe9:	83 e0 02             	and    $0x2,%eax
  105fec:	85 c0                	test   %eax,%eax
  105fee:	74 04                	je     105ff4 <perm2str+0x2d>
  105ff0:	b0 77                	mov    $0x77,%al
  105ff2:	eb 02                	jmp    105ff6 <perm2str+0x2f>
  105ff4:	b0 2d                	mov    $0x2d,%al
  105ff6:	a2 2a ef 11 00       	mov    %al,0x11ef2a
    str[3] = '\0';
  105ffb:	c6 05 2b ef 11 00 00 	movb   $0x0,0x11ef2b
    return str;
  106002:	b8 28 ef 11 00       	mov    $0x11ef28,%eax
}
  106007:	5d                   	pop    %ebp
  106008:	c3                   	ret    

00106009 <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
  106009:	55                   	push   %ebp
  10600a:	89 e5                	mov    %esp,%ebp
  10600c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
  10600f:	8b 45 10             	mov    0x10(%ebp),%eax
  106012:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106015:	72 0d                	jb     106024 <get_pgtable_items+0x1b>
    {
        return 0;
  106017:	b8 00 00 00 00       	mov    $0x0,%eax
  10601c:	e9 98 00 00 00       	jmp    1060b9 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
  106021:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
  106024:	8b 45 10             	mov    0x10(%ebp),%eax
  106027:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10602a:	73 18                	jae    106044 <get_pgtable_items+0x3b>
  10602c:	8b 45 10             	mov    0x10(%ebp),%eax
  10602f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106036:	8b 45 14             	mov    0x14(%ebp),%eax
  106039:	01 d0                	add    %edx,%eax
  10603b:	8b 00                	mov    (%eax),%eax
  10603d:	83 e0 01             	and    $0x1,%eax
  106040:	85 c0                	test   %eax,%eax
  106042:	74 dd                	je     106021 <get_pgtable_items+0x18>
    }
    if (start < right)
  106044:	8b 45 10             	mov    0x10(%ebp),%eax
  106047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10604a:	73 68                	jae    1060b4 <get_pgtable_items+0xab>
    {
        if (left_store != NULL)
  10604c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  106050:	74 08                	je     10605a <get_pgtable_items+0x51>
        {
            *left_store = start;
  106052:	8b 45 18             	mov    0x18(%ebp),%eax
  106055:	8b 55 10             	mov    0x10(%ebp),%edx
  106058:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
  10605a:	8b 45 10             	mov    0x10(%ebp),%eax
  10605d:	8d 50 01             	lea    0x1(%eax),%edx
  106060:	89 55 10             	mov    %edx,0x10(%ebp)
  106063:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10606a:	8b 45 14             	mov    0x14(%ebp),%eax
  10606d:	01 d0                	add    %edx,%eax
  10606f:	8b 00                	mov    (%eax),%eax
  106071:	83 e0 07             	and    $0x7,%eax
  106074:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  106077:	eb 03                	jmp    10607c <get_pgtable_items+0x73>
        {
            start++;
  106079:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  10607c:	8b 45 10             	mov    0x10(%ebp),%eax
  10607f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106082:	73 1d                	jae    1060a1 <get_pgtable_items+0x98>
  106084:	8b 45 10             	mov    0x10(%ebp),%eax
  106087:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10608e:	8b 45 14             	mov    0x14(%ebp),%eax
  106091:	01 d0                	add    %edx,%eax
  106093:	8b 00                	mov    (%eax),%eax
  106095:	83 e0 07             	and    $0x7,%eax
  106098:	89 c2                	mov    %eax,%edx
  10609a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10609d:	39 c2                	cmp    %eax,%edx
  10609f:	74 d8                	je     106079 <get_pgtable_items+0x70>
        }
        if (right_store != NULL)
  1060a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1060a5:	74 08                	je     1060af <get_pgtable_items+0xa6>
        {
            *right_store = start;
  1060a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1060aa:	8b 55 10             	mov    0x10(%ebp),%edx
  1060ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1060af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060b2:	eb 05                	jmp    1060b9 <get_pgtable_items+0xb0>
    }
    return 0;
  1060b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1060b9:	89 ec                	mov    %ebp,%esp
  1060bb:	5d                   	pop    %ebp
  1060bc:	c3                   	ret    

001060bd <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
  1060bd:	55                   	push   %ebp
  1060be:	89 e5                	mov    %esp,%ebp
  1060c0:	57                   	push   %edi
  1060c1:	56                   	push   %esi
  1060c2:	53                   	push   %ebx
  1060c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1060c6:	c7 04 24 f4 80 10 00 	movl   $0x1080f4,(%esp)
  1060cd:	e8 93 a2 ff ff       	call   100365 <cprintf>
    size_t left, right = 0, perm;
  1060d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  1060d9:	e9 f2 00 00 00       	jmp    1061d0 <print_pgdir+0x113>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1060de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060e1:	89 04 24             	mov    %eax,(%esp)
  1060e4:	e8 de fe ff ff       	call   105fc7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1060e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1060ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1060ef:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1060f1:	89 d6                	mov    %edx,%esi
  1060f3:	c1 e6 16             	shl    $0x16,%esi
  1060f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1060f9:	89 d3                	mov    %edx,%ebx
  1060fb:	c1 e3 16             	shl    $0x16,%ebx
  1060fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106101:	89 d1                	mov    %edx,%ecx
  106103:	c1 e1 16             	shl    $0x16,%ecx
  106106:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106109:	8b 7d e0             	mov    -0x20(%ebp),%edi
  10610c:	29 fa                	sub    %edi,%edx
  10610e:	89 44 24 14          	mov    %eax,0x14(%esp)
  106112:	89 74 24 10          	mov    %esi,0x10(%esp)
  106116:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10611a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10611e:	89 54 24 04          	mov    %edx,0x4(%esp)
  106122:	c7 04 24 25 81 10 00 	movl   $0x108125,(%esp)
  106129:	e8 37 a2 ff ff       	call   100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10612e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106131:	c1 e0 0a             	shl    $0xa,%eax
  106134:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  106137:	eb 50                	jmp    106189 <print_pgdir+0xcc>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10613c:	89 04 24             	mov    %eax,(%esp)
  10613f:	e8 83 fe ff ff       	call   105fc7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  106144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106147:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  10614a:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10614c:	89 d6                	mov    %edx,%esi
  10614e:	c1 e6 0c             	shl    $0xc,%esi
  106151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106154:	89 d3                	mov    %edx,%ebx
  106156:	c1 e3 0c             	shl    $0xc,%ebx
  106159:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10615c:	89 d1                	mov    %edx,%ecx
  10615e:	c1 e1 0c             	shl    $0xc,%ecx
  106161:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106164:	8b 7d d8             	mov    -0x28(%ebp),%edi
  106167:	29 fa                	sub    %edi,%edx
  106169:	89 44 24 14          	mov    %eax,0x14(%esp)
  10616d:	89 74 24 10          	mov    %esi,0x10(%esp)
  106171:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106175:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106179:	89 54 24 04          	mov    %edx,0x4(%esp)
  10617d:	c7 04 24 44 81 10 00 	movl   $0x108144,(%esp)
  106184:	e8 dc a1 ff ff       	call   100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  106189:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  10618e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106191:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106194:	89 d3                	mov    %edx,%ebx
  106196:	c1 e3 0a             	shl    $0xa,%ebx
  106199:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10619c:	89 d1                	mov    %edx,%ecx
  10619e:	c1 e1 0a             	shl    $0xa,%ecx
  1061a1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1061a4:	89 54 24 14          	mov    %edx,0x14(%esp)
  1061a8:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1061ab:	89 54 24 10          	mov    %edx,0x10(%esp)
  1061af:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1061b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1061b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1061bb:	89 0c 24             	mov    %ecx,(%esp)
  1061be:	e8 46 fe ff ff       	call   106009 <get_pgtable_items>
  1061c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1061c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1061ca:	0f 85 69 ff ff ff    	jne    106139 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  1061d0:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1061d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1061d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1061db:	89 54 24 14          	mov    %edx,0x14(%esp)
  1061df:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1061e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  1061e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1061ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1061ee:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1061f5:	00 
  1061f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1061fd:	e8 07 fe ff ff       	call   106009 <get_pgtable_items>
  106202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106205:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106209:	0f 85 cf fe ff ff    	jne    1060de <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10620f:	c7 04 24 68 81 10 00 	movl   $0x108168,(%esp)
  106216:	e8 4a a1 ff ff       	call   100365 <cprintf>
}
  10621b:	90                   	nop
  10621c:	83 c4 4c             	add    $0x4c,%esp
  10621f:	5b                   	pop    %ebx
  106220:	5e                   	pop    %esi
  106221:	5f                   	pop    %edi
  106222:	5d                   	pop    %ebp
  106223:	c3                   	ret    

00106224 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
  106224:	55                   	push   %ebp
  106225:	89 e5                	mov    %esp,%ebp
  106227:	83 ec 58             	sub    $0x58,%esp
  10622a:	8b 45 10             	mov    0x10(%ebp),%eax
  10622d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  106230:	8b 45 14             	mov    0x14(%ebp),%eax
  106233:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106236:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106239:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10623c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10623f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  106242:	8b 45 18             	mov    0x18(%ebp),%eax
  106245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10624b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10624e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106251:	89 55 f0             	mov    %edx,-0x10(%ebp)
  106254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10625a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10625e:	74 1c                	je     10627c <printnum+0x58>
  106260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106263:	ba 00 00 00 00       	mov    $0x0,%edx
  106268:	f7 75 e4             	divl   -0x1c(%ebp)
  10626b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10626e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106271:	ba 00 00 00 00       	mov    $0x0,%edx
  106276:	f7 75 e4             	divl   -0x1c(%ebp)
  106279:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10627c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10627f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106282:	f7 75 e4             	divl   -0x1c(%ebp)
  106285:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106288:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10628b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10628e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106291:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106294:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10629a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
  10629d:	8b 45 18             	mov    0x18(%ebp),%eax
  1062a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1062a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1062a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1062ab:	19 d1                	sbb    %edx,%ecx
  1062ad:	72 4c                	jb     1062fb <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
  1062af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1062b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1062b5:	8b 45 20             	mov    0x20(%ebp),%eax
  1062b8:	89 44 24 18          	mov    %eax,0x18(%esp)
  1062bc:	89 54 24 14          	mov    %edx,0x14(%esp)
  1062c0:	8b 45 18             	mov    0x18(%ebp),%eax
  1062c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1062c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1062ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1062cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1062d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1062d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1062df:	89 04 24             	mov    %eax,(%esp)
  1062e2:	e8 3d ff ff ff       	call   106224 <printnum>
  1062e7:	eb 1b                	jmp    106304 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
  1062e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062f0:	8b 45 20             	mov    0x20(%ebp),%eax
  1062f3:	89 04 24             	mov    %eax,(%esp)
  1062f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1062f9:	ff d0                	call   *%eax
        while (--width > 0)
  1062fb:	ff 4d 1c             	decl   0x1c(%ebp)
  1062fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106302:	7f e5                	jg     1062e9 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106304:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106307:	05 1c 82 10 00       	add    $0x10821c,%eax
  10630c:	0f b6 00             	movzbl (%eax),%eax
  10630f:	0f be c0             	movsbl %al,%eax
  106312:	8b 55 0c             	mov    0xc(%ebp),%edx
  106315:	89 54 24 04          	mov    %edx,0x4(%esp)
  106319:	89 04 24             	mov    %eax,(%esp)
  10631c:	8b 45 08             	mov    0x8(%ebp),%eax
  10631f:	ff d0                	call   *%eax
}
  106321:	90                   	nop
  106322:	89 ec                	mov    %ebp,%esp
  106324:	5d                   	pop    %ebp
  106325:	c3                   	ret    

00106326 <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
  106326:	55                   	push   %ebp
  106327:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  106329:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10632d:	7e 14                	jle    106343 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
  10632f:	8b 45 08             	mov    0x8(%ebp),%eax
  106332:	8b 00                	mov    (%eax),%eax
  106334:	8d 48 08             	lea    0x8(%eax),%ecx
  106337:	8b 55 08             	mov    0x8(%ebp),%edx
  10633a:	89 0a                	mov    %ecx,(%edx)
  10633c:	8b 50 04             	mov    0x4(%eax),%edx
  10633f:	8b 00                	mov    (%eax),%eax
  106341:	eb 30                	jmp    106373 <getuint+0x4d>
    }
    else if (lflag)
  106343:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106347:	74 16                	je     10635f <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
  106349:	8b 45 08             	mov    0x8(%ebp),%eax
  10634c:	8b 00                	mov    (%eax),%eax
  10634e:	8d 48 04             	lea    0x4(%eax),%ecx
  106351:	8b 55 08             	mov    0x8(%ebp),%edx
  106354:	89 0a                	mov    %ecx,(%edx)
  106356:	8b 00                	mov    (%eax),%eax
  106358:	ba 00 00 00 00       	mov    $0x0,%edx
  10635d:	eb 14                	jmp    106373 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
  10635f:	8b 45 08             	mov    0x8(%ebp),%eax
  106362:	8b 00                	mov    (%eax),%eax
  106364:	8d 48 04             	lea    0x4(%eax),%ecx
  106367:	8b 55 08             	mov    0x8(%ebp),%edx
  10636a:	89 0a                	mov    %ecx,(%edx)
  10636c:	8b 00                	mov    (%eax),%eax
  10636e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106373:	5d                   	pop    %ebp
  106374:	c3                   	ret    

00106375 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
  106375:	55                   	push   %ebp
  106376:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  106378:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10637c:	7e 14                	jle    106392 <getint+0x1d>
    {
        return va_arg(*ap, long long);
  10637e:	8b 45 08             	mov    0x8(%ebp),%eax
  106381:	8b 00                	mov    (%eax),%eax
  106383:	8d 48 08             	lea    0x8(%eax),%ecx
  106386:	8b 55 08             	mov    0x8(%ebp),%edx
  106389:	89 0a                	mov    %ecx,(%edx)
  10638b:	8b 50 04             	mov    0x4(%eax),%edx
  10638e:	8b 00                	mov    (%eax),%eax
  106390:	eb 28                	jmp    1063ba <getint+0x45>
    }
    else if (lflag)
  106392:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106396:	74 12                	je     1063aa <getint+0x35>
    {
        return va_arg(*ap, long);
  106398:	8b 45 08             	mov    0x8(%ebp),%eax
  10639b:	8b 00                	mov    (%eax),%eax
  10639d:	8d 48 04             	lea    0x4(%eax),%ecx
  1063a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1063a3:	89 0a                	mov    %ecx,(%edx)
  1063a5:	8b 00                	mov    (%eax),%eax
  1063a7:	99                   	cltd   
  1063a8:	eb 10                	jmp    1063ba <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
  1063aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1063ad:	8b 00                	mov    (%eax),%eax
  1063af:	8d 48 04             	lea    0x4(%eax),%ecx
  1063b2:	8b 55 08             	mov    0x8(%ebp),%edx
  1063b5:	89 0a                	mov    %ecx,(%edx)
  1063b7:	8b 00                	mov    (%eax),%eax
  1063b9:	99                   	cltd   
    }
}
  1063ba:	5d                   	pop    %ebp
  1063bb:	c3                   	ret    

001063bc <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
  1063bc:	55                   	push   %ebp
  1063bd:	89 e5                	mov    %esp,%ebp
  1063bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1063c2:	8d 45 14             	lea    0x14(%ebp),%eax
  1063c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1063c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1063cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1063cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1063d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1063d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1063d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1063e0:	89 04 24             	mov    %eax,(%esp)
  1063e3:	e8 05 00 00 00       	call   1063ed <vprintfmt>
    va_end(ap);
}
  1063e8:	90                   	nop
  1063e9:	89 ec                	mov    %ebp,%esp
  1063eb:	5d                   	pop    %ebp
  1063ec:	c3                   	ret    

001063ed <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
  1063ed:	55                   	push   %ebp
  1063ee:	89 e5                	mov    %esp,%ebp
  1063f0:	56                   	push   %esi
  1063f1:	53                   	push   %ebx
  1063f2:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
  1063f5:	eb 17                	jmp    10640e <vprintfmt+0x21>
        {
            if (ch == '\0')
  1063f7:	85 db                	test   %ebx,%ebx
  1063f9:	0f 84 bf 03 00 00    	je     1067be <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
  1063ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  106402:	89 44 24 04          	mov    %eax,0x4(%esp)
  106406:	89 1c 24             	mov    %ebx,(%esp)
  106409:	8b 45 08             	mov    0x8(%ebp),%eax
  10640c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
  10640e:	8b 45 10             	mov    0x10(%ebp),%eax
  106411:	8d 50 01             	lea    0x1(%eax),%edx
  106414:	89 55 10             	mov    %edx,0x10(%ebp)
  106417:	0f b6 00             	movzbl (%eax),%eax
  10641a:	0f b6 d8             	movzbl %al,%ebx
  10641d:	83 fb 25             	cmp    $0x25,%ebx
  106420:	75 d5                	jne    1063f7 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106422:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106426:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10642d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106430:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106433:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10643a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10643d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
  106440:	8b 45 10             	mov    0x10(%ebp),%eax
  106443:	8d 50 01             	lea    0x1(%eax),%edx
  106446:	89 55 10             	mov    %edx,0x10(%ebp)
  106449:	0f b6 00             	movzbl (%eax),%eax
  10644c:	0f b6 d8             	movzbl %al,%ebx
  10644f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106452:	83 f8 55             	cmp    $0x55,%eax
  106455:	0f 87 37 03 00 00    	ja     106792 <vprintfmt+0x3a5>
  10645b:	8b 04 85 40 82 10 00 	mov    0x108240(,%eax,4),%eax
  106462:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
  106464:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106468:	eb d6                	jmp    106440 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10646a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10646e:	eb d0                	jmp    106440 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
  106470:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
  106477:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10647a:	89 d0                	mov    %edx,%eax
  10647c:	c1 e0 02             	shl    $0x2,%eax
  10647f:	01 d0                	add    %edx,%eax
  106481:	01 c0                	add    %eax,%eax
  106483:	01 d8                	add    %ebx,%eax
  106485:	83 e8 30             	sub    $0x30,%eax
  106488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10648b:	8b 45 10             	mov    0x10(%ebp),%eax
  10648e:	0f b6 00             	movzbl (%eax),%eax
  106491:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
  106494:	83 fb 2f             	cmp    $0x2f,%ebx
  106497:	7e 38                	jle    1064d1 <vprintfmt+0xe4>
  106499:	83 fb 39             	cmp    $0x39,%ebx
  10649c:	7f 33                	jg     1064d1 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
  10649e:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1064a1:	eb d4                	jmp    106477 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1064a3:	8b 45 14             	mov    0x14(%ebp),%eax
  1064a6:	8d 50 04             	lea    0x4(%eax),%edx
  1064a9:	89 55 14             	mov    %edx,0x14(%ebp)
  1064ac:	8b 00                	mov    (%eax),%eax
  1064ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1064b1:	eb 1f                	jmp    1064d2 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1064b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1064b7:	79 87                	jns    106440 <vprintfmt+0x53>
                width = 0;
  1064b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1064c0:	e9 7b ff ff ff       	jmp    106440 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1064c5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1064cc:	e9 6f ff ff ff       	jmp    106440 <vprintfmt+0x53>
            goto process_precision;
  1064d1:	90                   	nop

        process_precision:
            if (width < 0)
  1064d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1064d6:	0f 89 64 ff ff ff    	jns    106440 <vprintfmt+0x53>
                width = precision, precision = -1;
  1064dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1064e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1064e9:	e9 52 ff ff ff       	jmp    106440 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
  1064ee:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1064f1:	e9 4a ff ff ff       	jmp    106440 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1064f6:	8b 45 14             	mov    0x14(%ebp),%eax
  1064f9:	8d 50 04             	lea    0x4(%eax),%edx
  1064fc:	89 55 14             	mov    %edx,0x14(%ebp)
  1064ff:	8b 00                	mov    (%eax),%eax
  106501:	8b 55 0c             	mov    0xc(%ebp),%edx
  106504:	89 54 24 04          	mov    %edx,0x4(%esp)
  106508:	89 04 24             	mov    %eax,(%esp)
  10650b:	8b 45 08             	mov    0x8(%ebp),%eax
  10650e:	ff d0                	call   *%eax
            break;
  106510:	e9 a4 02 00 00       	jmp    1067b9 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106515:	8b 45 14             	mov    0x14(%ebp),%eax
  106518:	8d 50 04             	lea    0x4(%eax),%edx
  10651b:	89 55 14             	mov    %edx,0x14(%ebp)
  10651e:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
  106520:	85 db                	test   %ebx,%ebx
  106522:	79 02                	jns    106526 <vprintfmt+0x139>
            {
                err = -err;
  106524:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
  106526:	83 fb 06             	cmp    $0x6,%ebx
  106529:	7f 0b                	jg     106536 <vprintfmt+0x149>
  10652b:	8b 34 9d 00 82 10 00 	mov    0x108200(,%ebx,4),%esi
  106532:	85 f6                	test   %esi,%esi
  106534:	75 23                	jne    106559 <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
  106536:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10653a:	c7 44 24 08 2d 82 10 	movl   $0x10822d,0x8(%esp)
  106541:	00 
  106542:	8b 45 0c             	mov    0xc(%ebp),%eax
  106545:	89 44 24 04          	mov    %eax,0x4(%esp)
  106549:	8b 45 08             	mov    0x8(%ebp),%eax
  10654c:	89 04 24             	mov    %eax,(%esp)
  10654f:	e8 68 fe ff ff       	call   1063bc <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  106554:	e9 60 02 00 00       	jmp    1067b9 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  106559:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10655d:	c7 44 24 08 36 82 10 	movl   $0x108236,0x8(%esp)
  106564:	00 
  106565:	8b 45 0c             	mov    0xc(%ebp),%eax
  106568:	89 44 24 04          	mov    %eax,0x4(%esp)
  10656c:	8b 45 08             	mov    0x8(%ebp),%eax
  10656f:	89 04 24             	mov    %eax,(%esp)
  106572:	e8 45 fe ff ff       	call   1063bc <printfmt>
            break;
  106577:	e9 3d 02 00 00       	jmp    1067b9 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
  10657c:	8b 45 14             	mov    0x14(%ebp),%eax
  10657f:	8d 50 04             	lea    0x4(%eax),%edx
  106582:	89 55 14             	mov    %edx,0x14(%ebp)
  106585:	8b 30                	mov    (%eax),%esi
  106587:	85 f6                	test   %esi,%esi
  106589:	75 05                	jne    106590 <vprintfmt+0x1a3>
            {
                p = "(null)";
  10658b:	be 39 82 10 00       	mov    $0x108239,%esi
            }
            if (width > 0 && padc != '-')
  106590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106594:	7e 76                	jle    10660c <vprintfmt+0x21f>
  106596:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10659a:	74 70                	je     10660c <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
  10659c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10659f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065a3:	89 34 24             	mov    %esi,(%esp)
  1065a6:	e8 16 03 00 00       	call   1068c1 <strnlen>
  1065ab:	89 c2                	mov    %eax,%edx
  1065ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1065b0:	29 d0                	sub    %edx,%eax
  1065b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1065b5:	eb 16                	jmp    1065cd <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
  1065b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1065bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065be:	89 54 24 04          	mov    %edx,0x4(%esp)
  1065c2:	89 04 24             	mov    %eax,(%esp)
  1065c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1065c8:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
  1065ca:	ff 4d e8             	decl   -0x18(%ebp)
  1065cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065d1:	7f e4                	jg     1065b7 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  1065d3:	eb 37                	jmp    10660c <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
  1065d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1065d9:	74 1f                	je     1065fa <vprintfmt+0x20d>
  1065db:	83 fb 1f             	cmp    $0x1f,%ebx
  1065de:	7e 05                	jle    1065e5 <vprintfmt+0x1f8>
  1065e0:	83 fb 7e             	cmp    $0x7e,%ebx
  1065e3:	7e 15                	jle    1065fa <vprintfmt+0x20d>
                {
                    putch('?', putdat);
  1065e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1065f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1065f6:	ff d0                	call   *%eax
  1065f8:	eb 0f                	jmp    106609 <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
  1065fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  106601:	89 1c 24             	mov    %ebx,(%esp)
  106604:	8b 45 08             	mov    0x8(%ebp),%eax
  106607:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  106609:	ff 4d e8             	decl   -0x18(%ebp)
  10660c:	89 f0                	mov    %esi,%eax
  10660e:	8d 70 01             	lea    0x1(%eax),%esi
  106611:	0f b6 00             	movzbl (%eax),%eax
  106614:	0f be d8             	movsbl %al,%ebx
  106617:	85 db                	test   %ebx,%ebx
  106619:	74 27                	je     106642 <vprintfmt+0x255>
  10661b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10661f:	78 b4                	js     1065d5 <vprintfmt+0x1e8>
  106621:	ff 4d e4             	decl   -0x1c(%ebp)
  106624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106628:	79 ab                	jns    1065d5 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
  10662a:	eb 16                	jmp    106642 <vprintfmt+0x255>
            {
                putch(' ', putdat);
  10662c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10662f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106633:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10663a:	8b 45 08             	mov    0x8(%ebp),%eax
  10663d:	ff d0                	call   *%eax
            for (; width > 0; width--)
  10663f:	ff 4d e8             	decl   -0x18(%ebp)
  106642:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106646:	7f e4                	jg     10662c <vprintfmt+0x23f>
            }
            break;
  106648:	e9 6c 01 00 00       	jmp    1067b9 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10664d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106650:	89 44 24 04          	mov    %eax,0x4(%esp)
  106654:	8d 45 14             	lea    0x14(%ebp),%eax
  106657:	89 04 24             	mov    %eax,(%esp)
  10665a:	e8 16 fd ff ff       	call   106375 <getint>
  10665f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106662:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
  106665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10666b:	85 d2                	test   %edx,%edx
  10666d:	79 26                	jns    106695 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
  10666f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106672:	89 44 24 04          	mov    %eax,0x4(%esp)
  106676:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10667d:	8b 45 08             	mov    0x8(%ebp),%eax
  106680:	ff d0                	call   *%eax
                num = -(long long)num;
  106682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106688:	f7 d8                	neg    %eax
  10668a:	83 d2 00             	adc    $0x0,%edx
  10668d:	f7 da                	neg    %edx
  10668f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106692:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106695:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10669c:	e9 a8 00 00 00       	jmp    106749 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1066a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066a8:	8d 45 14             	lea    0x14(%ebp),%eax
  1066ab:	89 04 24             	mov    %eax,(%esp)
  1066ae:	e8 73 fc ff ff       	call   106326 <getuint>
  1066b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1066b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1066c0:	e9 84 00 00 00       	jmp    106749 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1066c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1066cf:	89 04 24             	mov    %eax,(%esp)
  1066d2:	e8 4f fc ff ff       	call   106326 <getuint>
  1066d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1066dd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1066e4:	eb 63                	jmp    106749 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  1066e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066ed:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1066f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1066f7:	ff d0                	call   *%eax
            putch('x', putdat);
  1066f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  106700:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106707:	8b 45 08             	mov    0x8(%ebp),%eax
  10670a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10670c:	8b 45 14             	mov    0x14(%ebp),%eax
  10670f:	8d 50 04             	lea    0x4(%eax),%edx
  106712:	89 55 14             	mov    %edx,0x14(%ebp)
  106715:	8b 00                	mov    (%eax),%eax
  106717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10671a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106721:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106728:	eb 1f                	jmp    106749 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10672a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10672d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106731:	8d 45 14             	lea    0x14(%ebp),%eax
  106734:	89 04 24             	mov    %eax,(%esp)
  106737:	e8 ea fb ff ff       	call   106326 <getuint>
  10673c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10673f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106742:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106749:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10674d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106750:	89 54 24 18          	mov    %edx,0x18(%esp)
  106754:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106757:	89 54 24 14          	mov    %edx,0x14(%esp)
  10675b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10675f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106765:	89 44 24 08          	mov    %eax,0x8(%esp)
  106769:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10676d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106770:	89 44 24 04          	mov    %eax,0x4(%esp)
  106774:	8b 45 08             	mov    0x8(%ebp),%eax
  106777:	89 04 24             	mov    %eax,(%esp)
  10677a:	e8 a5 fa ff ff       	call   106224 <printnum>
            break;
  10677f:	eb 38                	jmp    1067b9 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  106781:	8b 45 0c             	mov    0xc(%ebp),%eax
  106784:	89 44 24 04          	mov    %eax,0x4(%esp)
  106788:	89 1c 24             	mov    %ebx,(%esp)
  10678b:	8b 45 08             	mov    0x8(%ebp),%eax
  10678e:	ff d0                	call   *%eax
            break;
  106790:	eb 27                	jmp    1067b9 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106792:	8b 45 0c             	mov    0xc(%ebp),%eax
  106795:	89 44 24 04          	mov    %eax,0x4(%esp)
  106799:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1067a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1067a3:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
  1067a5:	ff 4d 10             	decl   0x10(%ebp)
  1067a8:	eb 03                	jmp    1067ad <vprintfmt+0x3c0>
  1067aa:	ff 4d 10             	decl   0x10(%ebp)
  1067ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1067b0:	48                   	dec    %eax
  1067b1:	0f b6 00             	movzbl (%eax),%eax
  1067b4:	3c 25                	cmp    $0x25,%al
  1067b6:	75 f2                	jne    1067aa <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1067b8:	90                   	nop
    {
  1067b9:	e9 37 fc ff ff       	jmp    1063f5 <vprintfmt+0x8>
                return;
  1067be:	90                   	nop
        }
    }
}
  1067bf:	83 c4 40             	add    $0x40,%esp
  1067c2:	5b                   	pop    %ebx
  1067c3:	5e                   	pop    %esi
  1067c4:	5d                   	pop    %ebp
  1067c5:	c3                   	ret    

001067c6 <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
  1067c6:	55                   	push   %ebp
  1067c7:	89 e5                	mov    %esp,%ebp
    b->cnt++;
  1067c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067cc:	8b 40 08             	mov    0x8(%eax),%eax
  1067cf:	8d 50 01             	lea    0x1(%eax),%edx
  1067d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067d5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
  1067d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067db:	8b 10                	mov    (%eax),%edx
  1067dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067e0:	8b 40 04             	mov    0x4(%eax),%eax
  1067e3:	39 c2                	cmp    %eax,%edx
  1067e5:	73 12                	jae    1067f9 <sprintputch+0x33>
    {
        *b->buf++ = ch;
  1067e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067ea:	8b 00                	mov    (%eax),%eax
  1067ec:	8d 48 01             	lea    0x1(%eax),%ecx
  1067ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  1067f2:	89 0a                	mov    %ecx,(%edx)
  1067f4:	8b 55 08             	mov    0x8(%ebp),%edx
  1067f7:	88 10                	mov    %dl,(%eax)
    }
}
  1067f9:	90                   	nop
  1067fa:	5d                   	pop    %ebp
  1067fb:	c3                   	ret    

001067fc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
  1067fc:	55                   	push   %ebp
  1067fd:	89 e5                	mov    %esp,%ebp
  1067ff:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106802:	8d 45 14             	lea    0x14(%ebp),%eax
  106805:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10680b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10680f:	8b 45 10             	mov    0x10(%ebp),%eax
  106812:	89 44 24 08          	mov    %eax,0x8(%esp)
  106816:	8b 45 0c             	mov    0xc(%ebp),%eax
  106819:	89 44 24 04          	mov    %eax,0x4(%esp)
  10681d:	8b 45 08             	mov    0x8(%ebp),%eax
  106820:	89 04 24             	mov    %eax,(%esp)
  106823:	e8 0a 00 00 00       	call   106832 <vsnprintf>
  106828:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10682b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10682e:	89 ec                	mov    %ebp,%esp
  106830:	5d                   	pop    %ebp
  106831:	c3                   	ret    

00106832 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
  106832:	55                   	push   %ebp
  106833:	89 e5                	mov    %esp,%ebp
  106835:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106838:	8b 45 08             	mov    0x8(%ebp),%eax
  10683b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10683e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106841:	8d 50 ff             	lea    -0x1(%eax),%edx
  106844:	8b 45 08             	mov    0x8(%ebp),%eax
  106847:	01 d0                	add    %edx,%eax
  106849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10684c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
  106853:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106857:	74 0a                	je     106863 <vsnprintf+0x31>
  106859:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10685c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10685f:	39 c2                	cmp    %eax,%edx
  106861:	76 07                	jbe    10686a <vsnprintf+0x38>
    {
        return -E_INVAL;
  106863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106868:	eb 2a                	jmp    106894 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
  10686a:	8b 45 14             	mov    0x14(%ebp),%eax
  10686d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106871:	8b 45 10             	mov    0x10(%ebp),%eax
  106874:	89 44 24 08          	mov    %eax,0x8(%esp)
  106878:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10687b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10687f:	c7 04 24 c6 67 10 00 	movl   $0x1067c6,(%esp)
  106886:	e8 62 fb ff ff       	call   1063ed <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10688b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10688e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106891:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106894:	89 ec                	mov    %ebp,%esp
  106896:	5d                   	pop    %ebp
  106897:	c3                   	ret    

00106898 <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
  106898:	55                   	push   %ebp
  106899:	89 e5                	mov    %esp,%ebp
  10689b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10689e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
  1068a5:	eb 03                	jmp    1068aa <strlen+0x12>
    {
        cnt++;
  1068a7:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
  1068aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1068ad:	8d 50 01             	lea    0x1(%eax),%edx
  1068b0:	89 55 08             	mov    %edx,0x8(%ebp)
  1068b3:	0f b6 00             	movzbl (%eax),%eax
  1068b6:	84 c0                	test   %al,%al
  1068b8:	75 ed                	jne    1068a7 <strlen+0xf>
    }
    return cnt;
  1068ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1068bd:	89 ec                	mov    %ebp,%esp
  1068bf:	5d                   	pop    %ebp
  1068c0:	c3                   	ret    

001068c1 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
  1068c1:	55                   	push   %ebp
  1068c2:	89 e5                	mov    %esp,%ebp
  1068c4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1068c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  1068ce:	eb 03                	jmp    1068d3 <strnlen+0x12>
    {
        cnt++;
  1068d0:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  1068d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1068d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1068d9:	73 10                	jae    1068eb <strnlen+0x2a>
  1068db:	8b 45 08             	mov    0x8(%ebp),%eax
  1068de:	8d 50 01             	lea    0x1(%eax),%edx
  1068e1:	89 55 08             	mov    %edx,0x8(%ebp)
  1068e4:	0f b6 00             	movzbl (%eax),%eax
  1068e7:	84 c0                	test   %al,%al
  1068e9:	75 e5                	jne    1068d0 <strnlen+0xf>
    }
    return cnt;
  1068eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1068ee:	89 ec                	mov    %ebp,%esp
  1068f0:	5d                   	pop    %ebp
  1068f1:	c3                   	ret    

001068f2 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
  1068f2:	55                   	push   %ebp
  1068f3:	89 e5                	mov    %esp,%ebp
  1068f5:	57                   	push   %edi
  1068f6:	56                   	push   %esi
  1068f7:	83 ec 20             	sub    $0x20,%esp
  1068fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1068fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106900:	8b 45 0c             	mov    0xc(%ebp),%eax
  106903:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
  106906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10690c:	89 d1                	mov    %edx,%ecx
  10690e:	89 c2                	mov    %eax,%edx
  106910:	89 ce                	mov    %ecx,%esi
  106912:	89 d7                	mov    %edx,%edi
  106914:	ac                   	lods   %ds:(%esi),%al
  106915:	aa                   	stos   %al,%es:(%edi)
  106916:	84 c0                	test   %al,%al
  106918:	75 fa                	jne    106914 <strcpy+0x22>
  10691a:	89 fa                	mov    %edi,%edx
  10691c:	89 f1                	mov    %esi,%ecx
  10691e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106921:	89 55 e8             	mov    %edx,-0x18(%ebp)
  106924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
  106927:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10692a:	83 c4 20             	add    $0x20,%esp
  10692d:	5e                   	pop    %esi
  10692e:	5f                   	pop    %edi
  10692f:	5d                   	pop    %ebp
  106930:	c3                   	ret    

00106931 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
  106931:	55                   	push   %ebp
  106932:	89 e5                	mov    %esp,%ebp
  106934:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  106937:	8b 45 08             	mov    0x8(%ebp),%eax
  10693a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
  10693d:	eb 1e                	jmp    10695d <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
  10693f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106942:	0f b6 10             	movzbl (%eax),%edx
  106945:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106948:	88 10                	mov    %dl,(%eax)
  10694a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10694d:	0f b6 00             	movzbl (%eax),%eax
  106950:	84 c0                	test   %al,%al
  106952:	74 03                	je     106957 <strncpy+0x26>
        {
            src++;
  106954:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
  106957:	ff 45 fc             	incl   -0x4(%ebp)
  10695a:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
  10695d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106961:	75 dc                	jne    10693f <strncpy+0xe>
    }
    return dst;
  106963:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106966:	89 ec                	mov    %ebp,%esp
  106968:	5d                   	pop    %ebp
  106969:	c3                   	ret    

0010696a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
  10696a:	55                   	push   %ebp
  10696b:	89 e5                	mov    %esp,%ebp
  10696d:	57                   	push   %edi
  10696e:	56                   	push   %esi
  10696f:	83 ec 20             	sub    $0x20,%esp
  106972:	8b 45 08             	mov    0x8(%ebp),%eax
  106975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106978:	8b 45 0c             	mov    0xc(%ebp),%eax
  10697b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
  10697e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106984:	89 d1                	mov    %edx,%ecx
  106986:	89 c2                	mov    %eax,%edx
  106988:	89 ce                	mov    %ecx,%esi
  10698a:	89 d7                	mov    %edx,%edi
  10698c:	ac                   	lods   %ds:(%esi),%al
  10698d:	ae                   	scas   %es:(%edi),%al
  10698e:	75 08                	jne    106998 <strcmp+0x2e>
  106990:	84 c0                	test   %al,%al
  106992:	75 f8                	jne    10698c <strcmp+0x22>
  106994:	31 c0                	xor    %eax,%eax
  106996:	eb 04                	jmp    10699c <strcmp+0x32>
  106998:	19 c0                	sbb    %eax,%eax
  10699a:	0c 01                	or     $0x1,%al
  10699c:	89 fa                	mov    %edi,%edx
  10699e:	89 f1                	mov    %esi,%ecx
  1069a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1069a3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1069a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1069a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1069ac:	83 c4 20             	add    $0x20,%esp
  1069af:	5e                   	pop    %esi
  1069b0:	5f                   	pop    %edi
  1069b1:	5d                   	pop    %ebp
  1069b2:	c3                   	ret    

001069b3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
  1069b3:	55                   	push   %ebp
  1069b4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  1069b6:	eb 09                	jmp    1069c1 <strncmp+0xe>
    {
        n--, s1++, s2++;
  1069b8:	ff 4d 10             	decl   0x10(%ebp)
  1069bb:	ff 45 08             	incl   0x8(%ebp)
  1069be:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  1069c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1069c5:	74 1a                	je     1069e1 <strncmp+0x2e>
  1069c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ca:	0f b6 00             	movzbl (%eax),%eax
  1069cd:	84 c0                	test   %al,%al
  1069cf:	74 10                	je     1069e1 <strncmp+0x2e>
  1069d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1069d4:	0f b6 10             	movzbl (%eax),%edx
  1069d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069da:	0f b6 00             	movzbl (%eax),%eax
  1069dd:	38 c2                	cmp    %al,%dl
  1069df:	74 d7                	je     1069b8 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1069e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1069e5:	74 18                	je     1069ff <strncmp+0x4c>
  1069e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ea:	0f b6 00             	movzbl (%eax),%eax
  1069ed:	0f b6 d0             	movzbl %al,%edx
  1069f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069f3:	0f b6 00             	movzbl (%eax),%eax
  1069f6:	0f b6 c8             	movzbl %al,%ecx
  1069f9:	89 d0                	mov    %edx,%eax
  1069fb:	29 c8                	sub    %ecx,%eax
  1069fd:	eb 05                	jmp    106a04 <strncmp+0x51>
  1069ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a04:	5d                   	pop    %ebp
  106a05:	c3                   	ret    

00106a06 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
  106a06:	55                   	push   %ebp
  106a07:	89 e5                	mov    %esp,%ebp
  106a09:	83 ec 04             	sub    $0x4,%esp
  106a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  106a12:	eb 13                	jmp    106a27 <strchr+0x21>
    {
        if (*s == c)
  106a14:	8b 45 08             	mov    0x8(%ebp),%eax
  106a17:	0f b6 00             	movzbl (%eax),%eax
  106a1a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a1d:	75 05                	jne    106a24 <strchr+0x1e>
        {
            return (char *)s;
  106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  106a22:	eb 12                	jmp    106a36 <strchr+0x30>
        }
        s++;
  106a24:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  106a27:	8b 45 08             	mov    0x8(%ebp),%eax
  106a2a:	0f b6 00             	movzbl (%eax),%eax
  106a2d:	84 c0                	test   %al,%al
  106a2f:	75 e3                	jne    106a14 <strchr+0xe>
    }
    return NULL;
  106a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a36:	89 ec                	mov    %ebp,%esp
  106a38:	5d                   	pop    %ebp
  106a39:	c3                   	ret    

00106a3a <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
  106a3a:	55                   	push   %ebp
  106a3b:	89 e5                	mov    %esp,%ebp
  106a3d:	83 ec 04             	sub    $0x4,%esp
  106a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a43:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  106a46:	eb 0e                	jmp    106a56 <strfind+0x1c>
    {
        if (*s == c)
  106a48:	8b 45 08             	mov    0x8(%ebp),%eax
  106a4b:	0f b6 00             	movzbl (%eax),%eax
  106a4e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a51:	74 0f                	je     106a62 <strfind+0x28>
        {
            break;
        }
        s++;
  106a53:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  106a56:	8b 45 08             	mov    0x8(%ebp),%eax
  106a59:	0f b6 00             	movzbl (%eax),%eax
  106a5c:	84 c0                	test   %al,%al
  106a5e:	75 e8                	jne    106a48 <strfind+0xe>
  106a60:	eb 01                	jmp    106a63 <strfind+0x29>
            break;
  106a62:	90                   	nop
    }
    return (char *)s;
  106a63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106a66:	89 ec                	mov    %ebp,%esp
  106a68:	5d                   	pop    %ebp
  106a69:	c3                   	ret    

00106a6a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
  106a6a:	55                   	push   %ebp
  106a6b:	89 e5                	mov    %esp,%ebp
  106a6d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106a70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106a77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
  106a7e:	eb 03                	jmp    106a83 <strtol+0x19>
    {
        s++;
  106a80:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
  106a83:	8b 45 08             	mov    0x8(%ebp),%eax
  106a86:	0f b6 00             	movzbl (%eax),%eax
  106a89:	3c 20                	cmp    $0x20,%al
  106a8b:	74 f3                	je     106a80 <strtol+0x16>
  106a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  106a90:	0f b6 00             	movzbl (%eax),%eax
  106a93:	3c 09                	cmp    $0x9,%al
  106a95:	74 e9                	je     106a80 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
  106a97:	8b 45 08             	mov    0x8(%ebp),%eax
  106a9a:	0f b6 00             	movzbl (%eax),%eax
  106a9d:	3c 2b                	cmp    $0x2b,%al
  106a9f:	75 05                	jne    106aa6 <strtol+0x3c>
    {
        s++;
  106aa1:	ff 45 08             	incl   0x8(%ebp)
  106aa4:	eb 14                	jmp    106aba <strtol+0x50>
    }
    else if (*s == '-')
  106aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  106aa9:	0f b6 00             	movzbl (%eax),%eax
  106aac:	3c 2d                	cmp    $0x2d,%al
  106aae:	75 0a                	jne    106aba <strtol+0x50>
    {
        s++, neg = 1;
  106ab0:	ff 45 08             	incl   0x8(%ebp)
  106ab3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  106aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106abe:	74 06                	je     106ac6 <strtol+0x5c>
  106ac0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106ac4:	75 22                	jne    106ae8 <strtol+0x7e>
  106ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  106ac9:	0f b6 00             	movzbl (%eax),%eax
  106acc:	3c 30                	cmp    $0x30,%al
  106ace:	75 18                	jne    106ae8 <strtol+0x7e>
  106ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  106ad3:	40                   	inc    %eax
  106ad4:	0f b6 00             	movzbl (%eax),%eax
  106ad7:	3c 78                	cmp    $0x78,%al
  106ad9:	75 0d                	jne    106ae8 <strtol+0x7e>
    {
        s += 2, base = 16;
  106adb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106adf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106ae6:	eb 29                	jmp    106b11 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
  106ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106aec:	75 16                	jne    106b04 <strtol+0x9a>
  106aee:	8b 45 08             	mov    0x8(%ebp),%eax
  106af1:	0f b6 00             	movzbl (%eax),%eax
  106af4:	3c 30                	cmp    $0x30,%al
  106af6:	75 0c                	jne    106b04 <strtol+0x9a>
    {
        s++, base = 8;
  106af8:	ff 45 08             	incl   0x8(%ebp)
  106afb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106b02:	eb 0d                	jmp    106b11 <strtol+0xa7>
    }
    else if (base == 0)
  106b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106b08:	75 07                	jne    106b11 <strtol+0xa7>
    {
        base = 10;
  106b0a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
  106b11:	8b 45 08             	mov    0x8(%ebp),%eax
  106b14:	0f b6 00             	movzbl (%eax),%eax
  106b17:	3c 2f                	cmp    $0x2f,%al
  106b19:	7e 1b                	jle    106b36 <strtol+0xcc>
  106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  106b1e:	0f b6 00             	movzbl (%eax),%eax
  106b21:	3c 39                	cmp    $0x39,%al
  106b23:	7f 11                	jg     106b36 <strtol+0xcc>
        {
            dig = *s - '0';
  106b25:	8b 45 08             	mov    0x8(%ebp),%eax
  106b28:	0f b6 00             	movzbl (%eax),%eax
  106b2b:	0f be c0             	movsbl %al,%eax
  106b2e:	83 e8 30             	sub    $0x30,%eax
  106b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b34:	eb 48                	jmp    106b7e <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
  106b36:	8b 45 08             	mov    0x8(%ebp),%eax
  106b39:	0f b6 00             	movzbl (%eax),%eax
  106b3c:	3c 60                	cmp    $0x60,%al
  106b3e:	7e 1b                	jle    106b5b <strtol+0xf1>
  106b40:	8b 45 08             	mov    0x8(%ebp),%eax
  106b43:	0f b6 00             	movzbl (%eax),%eax
  106b46:	3c 7a                	cmp    $0x7a,%al
  106b48:	7f 11                	jg     106b5b <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
  106b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  106b4d:	0f b6 00             	movzbl (%eax),%eax
  106b50:	0f be c0             	movsbl %al,%eax
  106b53:	83 e8 57             	sub    $0x57,%eax
  106b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b59:	eb 23                	jmp    106b7e <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
  106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  106b5e:	0f b6 00             	movzbl (%eax),%eax
  106b61:	3c 40                	cmp    $0x40,%al
  106b63:	7e 3b                	jle    106ba0 <strtol+0x136>
  106b65:	8b 45 08             	mov    0x8(%ebp),%eax
  106b68:	0f b6 00             	movzbl (%eax),%eax
  106b6b:	3c 5a                	cmp    $0x5a,%al
  106b6d:	7f 31                	jg     106ba0 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
  106b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  106b72:	0f b6 00             	movzbl (%eax),%eax
  106b75:	0f be c0             	movsbl %al,%eax
  106b78:	83 e8 37             	sub    $0x37,%eax
  106b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
  106b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b81:	3b 45 10             	cmp    0x10(%ebp),%eax
  106b84:	7d 19                	jge    106b9f <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
  106b86:	ff 45 08             	incl   0x8(%ebp)
  106b89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106b8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  106b90:	89 c2                	mov    %eax,%edx
  106b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b95:	01 d0                	add    %edx,%eax
  106b97:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
  106b9a:	e9 72 ff ff ff       	jmp    106b11 <strtol+0xa7>
            break;
  106b9f:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
  106ba0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106ba4:	74 08                	je     106bae <strtol+0x144>
    {
        *endptr = (char *)s;
  106ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  106bac:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106bb2:	74 07                	je     106bbb <strtol+0x151>
  106bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106bb7:	f7 d8                	neg    %eax
  106bb9:	eb 03                	jmp    106bbe <strtol+0x154>
  106bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106bbe:	89 ec                	mov    %ebp,%esp
  106bc0:	5d                   	pop    %ebp
  106bc1:	c3                   	ret    

00106bc2 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
  106bc2:	55                   	push   %ebp
  106bc3:	89 e5                	mov    %esp,%ebp
  106bc5:	83 ec 28             	sub    $0x28,%esp
  106bc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bce:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106bd1:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  106bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  106bd8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106bdb:	88 55 f7             	mov    %dl,-0x9(%ebp)
  106bde:	8b 45 10             	mov    0x10(%ebp),%eax
  106be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
  106be4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106be7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106beb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106bee:	89 d7                	mov    %edx,%edi
  106bf0:	f3 aa                	rep stos %al,%es:(%edi)
  106bf2:	89 fa                	mov    %edi,%edx
  106bf4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106bf7:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
  106bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106bfd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106c00:	89 ec                	mov    %ebp,%esp
  106c02:	5d                   	pop    %ebp
  106c03:	c3                   	ret    

00106c04 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
  106c04:	55                   	push   %ebp
  106c05:	89 e5                	mov    %esp,%ebp
  106c07:	57                   	push   %edi
  106c08:	56                   	push   %esi
  106c09:	53                   	push   %ebx
  106c0a:	83 ec 30             	sub    $0x30,%esp
  106c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  106c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106c19:	8b 45 10             	mov    0x10(%ebp),%eax
  106c1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
  106c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106c25:	73 42                	jae    106c69 <memmove+0x65>
  106c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  106c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106c3c:	c1 e8 02             	shr    $0x2,%eax
  106c3f:	89 c1                	mov    %eax,%ecx
    asm volatile(
  106c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c47:	89 d7                	mov    %edx,%edi
  106c49:	89 c6                	mov    %eax,%esi
  106c4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106c4d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106c50:	83 e1 03             	and    $0x3,%ecx
  106c53:	74 02                	je     106c57 <memmove+0x53>
  106c55:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c57:	89 f0                	mov    %esi,%eax
  106c59:	89 fa                	mov    %edi,%edx
  106c5b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106c5e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106c61:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106c67:	eb 36                	jmp    106c9f <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
  106c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  106c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c72:	01 c2                	add    %eax,%edx
  106c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c77:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c7d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
  106c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c83:	89 c1                	mov    %eax,%ecx
  106c85:	89 d8                	mov    %ebx,%eax
  106c87:	89 d6                	mov    %edx,%esi
  106c89:	89 c7                	mov    %eax,%edi
  106c8b:	fd                   	std    
  106c8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c8e:	fc                   	cld    
  106c8f:	89 f8                	mov    %edi,%eax
  106c91:	89 f2                	mov    %esi,%edx
  106c93:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106c96:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106c99:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106c9f:	83 c4 30             	add    $0x30,%esp
  106ca2:	5b                   	pop    %ebx
  106ca3:	5e                   	pop    %esi
  106ca4:	5f                   	pop    %edi
  106ca5:	5d                   	pop    %ebp
  106ca6:	c3                   	ret    

00106ca7 <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
  106ca7:	55                   	push   %ebp
  106ca8:	89 e5                	mov    %esp,%ebp
  106caa:	57                   	push   %edi
  106cab:	56                   	push   %esi
  106cac:	83 ec 20             	sub    $0x20,%esp
  106caf:	8b 45 08             	mov    0x8(%ebp),%eax
  106cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  106cbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  106cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106cc4:	c1 e8 02             	shr    $0x2,%eax
  106cc7:	89 c1                	mov    %eax,%ecx
    asm volatile(
  106cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106ccf:	89 d7                	mov    %edx,%edi
  106cd1:	89 c6                	mov    %eax,%esi
  106cd3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106cd5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106cd8:	83 e1 03             	and    $0x3,%ecx
  106cdb:	74 02                	je     106cdf <memcpy+0x38>
  106cdd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106cdf:	89 f0                	mov    %esi,%eax
  106ce1:	89 fa                	mov    %edi,%edx
  106ce3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106ce6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106ce9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  106cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106cef:	83 c4 20             	add    $0x20,%esp
  106cf2:	5e                   	pop    %esi
  106cf3:	5f                   	pop    %edi
  106cf4:	5d                   	pop    %ebp
  106cf5:	c3                   	ret    

00106cf6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
  106cf6:	55                   	push   %ebp
  106cf7:	89 e5                	mov    %esp,%ebp
  106cf9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  106cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
  106d08:	eb 2e                	jmp    106d38 <memcmp+0x42>
    {
        if (*s1 != *s2)
  106d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d0d:	0f b6 10             	movzbl (%eax),%edx
  106d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d13:	0f b6 00             	movzbl (%eax),%eax
  106d16:	38 c2                	cmp    %al,%dl
  106d18:	74 18                	je     106d32 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d1d:	0f b6 00             	movzbl (%eax),%eax
  106d20:	0f b6 d0             	movzbl %al,%edx
  106d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d26:	0f b6 00             	movzbl (%eax),%eax
  106d29:	0f b6 c8             	movzbl %al,%ecx
  106d2c:	89 d0                	mov    %edx,%eax
  106d2e:	29 c8                	sub    %ecx,%eax
  106d30:	eb 18                	jmp    106d4a <memcmp+0x54>
        }
        s1++, s2++;
  106d32:	ff 45 fc             	incl   -0x4(%ebp)
  106d35:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
  106d38:	8b 45 10             	mov    0x10(%ebp),%eax
  106d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  106d3e:	89 55 10             	mov    %edx,0x10(%ebp)
  106d41:	85 c0                	test   %eax,%eax
  106d43:	75 c5                	jne    106d0a <memcmp+0x14>
    }
    return 0;
  106d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106d4a:	89 ec                	mov    %ebp,%esp
  106d4c:	5d                   	pop    %ebp
  106d4d:	c3                   	ret    
