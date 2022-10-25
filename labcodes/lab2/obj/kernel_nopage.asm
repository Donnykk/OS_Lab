
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 90 11 40       	mov    $0x40119000,%eax
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
  100020:	a3 00 90 11 00       	mov    %eax,0x119000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 80 11 00       	mov    $0x118000,%esp
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
  10003c:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  100041:	2d 36 8a 11 00       	sub    $0x118a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 8a 11 00 	movl   $0x118a36,(%esp)
  100059:	e8 9e 5d 00 00       	call   105dfc <memset>

    cons_init(); // init the console
  10005e:	e8 f9 15 00 00       	call   10165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 a0 5f 10 00 	movl   $0x105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 bc 5f 10 00 	movl   $0x105fbc,(%esp)
  100078:	e8 e8 02 00 00       	call   100365 <cprintf>

    print_kerninfo();
  10007d:	e8 06 08 00 00       	call   100888 <print_kerninfo>

    grade_backtrace();
  100082:	e8 95 00 00 00       	call   10011c <grade_backtrace>

    pmm_init(); // init physical memory management
  100087:	e8 7a 44 00 00       	call   104506 <pmm_init>

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
  10015f:	a1 00 b0 11 00       	mov    0x11b000,%eax
  100164:	89 54 24 08          	mov    %edx,0x8(%esp)
  100168:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016c:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  100173:	e8 ed 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10017c:	89 c2                	mov    %eax,%edx
  10017e:	a1 00 b0 11 00       	mov    0x11b000,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  100192:	e8 ce 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10019b:	89 c2                	mov    %eax,%edx
  10019d:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001aa:	c7 04 24 dd 5f 10 00 	movl   $0x105fdd,(%esp)
  1001b1:	e8 af 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ba:	89 c2                	mov    %eax,%edx
  1001bc:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c9:	c7 04 24 eb 5f 10 00 	movl   $0x105feb,(%esp)
  1001d0:	e8 90 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d9:	89 c2                	mov    %eax,%edx
  1001db:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e8:	c7 04 24 f9 5f 10 00 	movl   $0x105ff9,(%esp)
  1001ef:	e8 71 01 00 00       	call   100365 <cprintf>
    round++;
  1001f4:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001f9:	40                   	inc    %eax
  1001fa:	a3 00 b0 11 00       	mov    %eax,0x11b000
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
  100225:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  10022c:	e8 34 01 00 00       	call   100365 <cprintf>
    lab1_switch_to_user();
  100231:	e8 ce ff ff ff       	call   100204 <lab1_switch_to_user>
    lab1_print_cur_status();
  100236:	e8 09 ff ff ff       	call   100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10023b:	c7 04 24 28 60 10 00 	movl   $0x106028,(%esp)
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
  100269:	c7 04 24 47 60 10 00 	movl   $0x106047,(%esp)
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
  1002b7:	88 90 20 b0 11 00    	mov    %dl,0x11b020(%eax)
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
  1002f5:	05 20 b0 11 00       	add    $0x11b020,%eax
  1002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002fd:	b8 20 b0 11 00       	mov    $0x11b020,%eax
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
  100359:	e8 c9 52 00 00       	call   105627 <vprintfmt>
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
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
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

    while (l <= r) {
  10042d:	e9 ca 00 00 00       	jmp    1004fc <stab_binsearch+0xec>
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
        while (m >= l && stabs[m].n_type != type) {
  10044c:	eb 03                	jmp    100451 <stab_binsearch+0x41>
            m --;
  10044e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
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
        if (m < l) {    // no match in [l, m]
  100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10047b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10047e:	7d 09                	jge    100489 <stab_binsearch+0x79>
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
        if (stabs[m].n_value < addr) {
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
            *region_left = m;
  1004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b6:	40                   	inc    %eax
  1004b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ba:	eb 40                	jmp    1004fc <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
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
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100502:	0f 8e 2a ff ff ff    	jle    100432 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10050c:	75 0f                	jne    10051d <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	8d 50 ff             	lea    -0x1(%eax),%edx
  100516:	8b 45 10             	mov    0x10(%ebp),%eax
  100519:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10051b:	eb 3e                	jmp    10055b <stab_binsearch+0x14b>
        l = *region_right;
  10051d:	8b 45 10             	mov    0x10(%ebp),%eax
  100520:	8b 00                	mov    (%eax),%eax
  100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
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
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100560:	55                   	push   %ebp
  100561:	89 e5                	mov    %esp,%ebp
  100563:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100566:	8b 45 0c             	mov    0xc(%ebp),%eax
  100569:	c7 00 4c 60 10 00    	movl   $0x10604c,(%eax)
    info->eip_line = 0;
  10056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 08 4c 60 10 00 	movl   $0x10604c,0x8(%eax)
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
  1005a0:	c7 45 f4 f8 72 10 00 	movl   $0x1072f8,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a7:	c7 45 f0 f0 28 11 00 	movl   $0x1128f0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ae:	c7 45 ec f1 28 11 00 	movl   $0x1128f1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b5:	c7 45 e8 5f 5e 11 00 	movl   $0x115e5f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005c2:	76 0b                	jbe    1005cf <debuginfo_eip+0x6f>
  1005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005c7:	48                   	dec    %eax
  1005c8:	0f b6 00             	movzbl (%eax),%eax
  1005cb:	84 c0                	test   %al,%al
  1005cd:	74 0a                	je     1005d9 <debuginfo_eip+0x79>
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

    if (lfun <= rfun) {
  100660:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100663:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	7f 78                	jg     1006e2 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
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
    } else {
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
  100708:	e8 67 55 00 00       	call   105c74 <strfind>
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
    if (lline <= rline) {
  100745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100748:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10074b:	39 c2                	cmp    %eax,%edx
  10074d:	7f 23                	jg     100772 <debuginfo_eip+0x212>
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
    while (lline >= lfile
  100770:	eb 11                	jmp    100783 <debuginfo_eip+0x223>
        return -1;
  100772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100777:	e9 08 01 00 00       	jmp    100884 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077f:	48                   	dec    %eax
  100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	7c 56                	jl     1007e3 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
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
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
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
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
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
    if (lfun < rfun) {
  10082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100832:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100835:	39 c2                	cmp    %eax,%edx
  100837:	7d 46                	jge    10087f <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100839:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10083c:	40                   	inc    %eax
  10083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100840:	eb 16                	jmp    100858 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100842:	8b 45 0c             	mov    0xc(%ebp),%eax
  100845:	8b 40 14             	mov    0x14(%eax),%eax
  100848:	8d 50 01             	lea    0x1(%eax),%edx
  10084b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10084e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
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
void
print_kerninfo(void) {
  100888:	55                   	push   %ebp
  100889:	89 e5                	mov    %esp,%ebp
  10088b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10088e:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  100895:	e8 cb fa ff ff       	call   100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10089a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1008a1:	00 
  1008a2:	c7 04 24 6f 60 10 00 	movl   $0x10606f,(%esp)
  1008a9:	e8 b7 fa ff ff       	call   100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ae:	c7 44 24 04 88 5f 10 	movl   $0x105f88,0x4(%esp)
  1008b5:	00 
  1008b6:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  1008bd:	e8 a3 fa ff ff       	call   100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008c2:	c7 44 24 04 36 8a 11 	movl   $0x118a36,0x4(%esp)
  1008c9:	00 
  1008ca:	c7 04 24 9f 60 10 00 	movl   $0x10609f,(%esp)
  1008d1:	e8 8f fa ff ff       	call   100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d6:	c7 44 24 04 2c bf 11 	movl   $0x11bf2c,0x4(%esp)
  1008dd:	00 
  1008de:	c7 04 24 b7 60 10 00 	movl   $0x1060b7,(%esp)
  1008e5:	e8 7b fa ff ff       	call   100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008ea:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  1008ef:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ff:	85 c0                	test   %eax,%eax
  100901:	0f 48 c2             	cmovs  %edx,%eax
  100904:	c1 f8 0a             	sar    $0xa,%eax
  100907:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090b:	c7 04 24 d0 60 10 00 	movl   $0x1060d0,(%esp)
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
void
print_debuginfo(uintptr_t eip) {
  10091c:	55                   	push   %ebp
  10091d:	89 e5                	mov    %esp,%ebp
  10091f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100925:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 04 24             	mov    %eax,(%esp)
  100932:	e8 29 fc ff ff       	call   100560 <debuginfo_eip>
  100937:	85 c0                	test   %eax,%eax
  100939:	74 15                	je     100950 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10093b:	8b 45 08             	mov    0x8(%ebp),%eax
  10093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100942:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
  100949:	e8 17 fa ff ff       	call   100365 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10094e:	eb 6c                	jmp    1009bc <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
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
        for (j = 0; j < info.eip_fn_namelen; j ++) {
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
  1009b0:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  1009b7:	e8 a9 f9 ff ff       	call   100365 <cprintf>
}
  1009bc:	90                   	nop
  1009bd:	89 ec                	mov    %ebp,%esp
  1009bf:	5d                   	pop    %ebp
  1009c0:	c3                   	ret    

001009c1 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009c1:	55                   	push   %ebp
  1009c2:	89 e5                	mov    %esp,%ebp
  1009c4:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009c7:	8b 45 04             	mov    0x4(%ebp),%eax
  1009ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
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
void
print_stackframe(void) {
  1009d4:	55                   	push   %ebp
  1009d5:	89 e5                	mov    %esp,%ebp
  1009d7:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009da:	89 e8                	mov    %ebp,%eax
  1009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
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
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f4:	e9 84 00 00 00       	jmp    100a7d <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 28 61 10 00 	movl   $0x106128,(%esp)
  100a0e:	e8 52 f9 ff ff       	call   100365 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a16:	83 c0 08             	add    $0x8,%eax
  100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a23:	eb 24                	jmp    100a49 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	01 d0                	add    %edx,%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3a:	c7 04 24 44 61 10 00 	movl   $0x106144,(%esp)
  100a41:	e8 1f f9 ff ff       	call   100365 <cprintf>
        for (j = 0; j < 4; j ++) {
  100a46:	ff 45 e8             	incl   -0x18(%ebp)
  100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4d:	7e d6                	jle    100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a4f:	c7 04 24 4c 61 10 00 	movl   $0x10614c,(%esp)
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
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
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
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a92:	55                   	push   %ebp
  100a93:	89 e5                	mov    %esp,%ebp
  100a95:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9f:	eb 0c                	jmp    100aad <parse+0x1b>
            *buf ++ = '\0';
  100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa4:	8d 50 01             	lea    0x1(%eax),%edx
  100aa7:	89 55 08             	mov    %edx,0x8(%ebp)
  100aaa:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aad:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab0:	0f b6 00             	movzbl (%eax),%eax
  100ab3:	84 c0                	test   %al,%al
  100ab5:	74 1d                	je     100ad4 <parse+0x42>
  100ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aba:	0f b6 00             	movzbl (%eax),%eax
  100abd:	0f be c0             	movsbl %al,%eax
  100ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac4:	c7 04 24 d0 61 10 00 	movl   $0x1061d0,(%esp)
  100acb:	e8 70 51 00 00       	call   105c40 <strchr>
  100ad0:	85 c0                	test   %eax,%eax
  100ad2:	75 cd                	jne    100aa1 <parse+0xf>
        }
        if (*buf == '\0') {
  100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad7:	0f b6 00             	movzbl (%eax),%eax
  100ada:	84 c0                	test   %al,%al
  100adc:	74 65                	je     100b43 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae2:	75 14                	jne    100af8 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aeb:	00 
  100aec:	c7 04 24 d5 61 10 00 	movl   $0x1061d5,(%esp)
  100af3:	e8 6d f8 ff ff       	call   100365 <cprintf>
        }
        argv[argc ++] = buf;
  100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afb:	8d 50 01             	lea    0x1(%eax),%edx
  100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0b:	01 c2                	add    %eax,%edx
  100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b12:	eb 03                	jmp    100b17 <parse+0x85>
            buf ++;
  100b14:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b17:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1a:	0f b6 00             	movzbl (%eax),%eax
  100b1d:	84 c0                	test   %al,%al
  100b1f:	74 8c                	je     100aad <parse+0x1b>
  100b21:	8b 45 08             	mov    0x8(%ebp),%eax
  100b24:	0f b6 00             	movzbl (%eax),%eax
  100b27:	0f be c0             	movsbl %al,%eax
  100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2e:	c7 04 24 d0 61 10 00 	movl   $0x1061d0,(%esp)
  100b35:	e8 06 51 00 00       	call   105c40 <strchr>
  100b3a:	85 c0                	test   %eax,%eax
  100b3c:	74 d6                	je     100b14 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
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
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
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
    if (argc == 0) {
  100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b6d:	75 0a                	jne    100b79 <runcmd+0x2e>
        return 0;
  100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b74:	e9 83 00 00 00       	jmp    100bfc <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b80:	eb 5a                	jmp    100bdc <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b82:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b88:	89 c8                	mov    %ecx,%eax
  100b8a:	01 c0                	add    %eax,%eax
  100b8c:	01 c8                	add    %ecx,%eax
  100b8e:	c1 e0 02             	shl    $0x2,%eax
  100b91:	05 00 80 11 00       	add    $0x118000,%eax
  100b96:	8b 00                	mov    (%eax),%eax
  100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9c:	89 04 24             	mov    %eax,(%esp)
  100b9f:	e8 00 50 00 00       	call   105ba4 <strcmp>
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	75 31                	jne    100bd9 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bab:	89 d0                	mov    %edx,%eax
  100bad:	01 c0                	add    %eax,%eax
  100baf:	01 d0                	add    %edx,%eax
  100bb1:	c1 e0 02             	shl    $0x2,%eax
  100bb4:	05 08 80 11 00       	add    $0x118008,%eax
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
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd9:	ff 45 f4             	incl   -0xc(%ebp)
  100bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdf:	83 f8 02             	cmp    $0x2,%eax
  100be2:	76 9e                	jbe    100b82 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100beb:	c7 04 24 f3 61 10 00 	movl   $0x1061f3,(%esp)
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

void
kmonitor(struct trapframe *tf) {
  100c03:	55                   	push   %ebp
  100c04:	89 e5                	mov    %esp,%ebp
  100c06:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c09:	c7 04 24 0c 62 10 00 	movl   $0x10620c,(%esp)
  100c10:	e8 50 f7 ff ff       	call   100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c15:	c7 04 24 34 62 10 00 	movl   $0x106234,(%esp)
  100c1c:	e8 44 f7 ff ff       	call   100365 <cprintf>

    if (tf != NULL) {
  100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c25:	74 0b                	je     100c32 <kmonitor+0x2f>
        print_trapframe(tf);
  100c27:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 f1 0e 00 00       	call   101b23 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c32:	c7 04 24 59 62 10 00 	movl   $0x106259,(%esp)
  100c39:	e8 18 f6 ff ff       	call   100256 <readline>
  100c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c45:	74 eb                	je     100c32 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c47:	8b 45 08             	mov    0x8(%ebp),%eax
  100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c51:	89 04 24             	mov    %eax,(%esp)
  100c54:	e8 f2 fe ff ff       	call   100b4b <runcmd>
  100c59:	85 c0                	test   %eax,%eax
  100c5b:	78 02                	js     100c5f <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c5d:	eb d3                	jmp    100c32 <kmonitor+0x2f>
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
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c65:	55                   	push   %ebp
  100c66:	89 e5                	mov    %esp,%ebp
  100c68:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c72:	eb 3d                	jmp    100cb1 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c77:	89 d0                	mov    %edx,%eax
  100c79:	01 c0                	add    %eax,%eax
  100c7b:	01 d0                	add    %edx,%eax
  100c7d:	c1 e0 02             	shl    $0x2,%eax
  100c80:	05 04 80 11 00       	add    $0x118004,%eax
  100c85:	8b 10                	mov    (%eax),%edx
  100c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c8a:	89 c8                	mov    %ecx,%eax
  100c8c:	01 c0                	add    %eax,%eax
  100c8e:	01 c8                	add    %ecx,%eax
  100c90:	c1 e0 02             	shl    $0x2,%eax
  100c93:	05 00 80 11 00       	add    $0x118000,%eax
  100c98:	8b 00                	mov    (%eax),%eax
  100c9a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca2:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
  100ca9:	e8 b7 f6 ff ff       	call   100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
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
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
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
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
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
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cea:	55                   	push   %ebp
  100ceb:	89 e5                	mov    %esp,%ebp
  100ced:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cf0:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100cf5:	85 c0                	test   %eax,%eax
  100cf7:	75 5b                	jne    100d54 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cf9:	c7 05 20 b4 11 00 01 	movl   $0x1,0x11b420
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
  100d17:	c7 04 24 66 62 10 00 	movl   $0x106266,(%esp)
  100d1e:	e8 42 f6 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2d:	89 04 24             	mov    %eax,(%esp)
  100d30:	e8 fb f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100d35:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100d3c:	e8 24 f6 ff ff       	call   100365 <cprintf>
    
    cprintf("stack trackback:\n");
  100d41:	c7 04 24 84 62 10 00 	movl   $0x106284,(%esp)
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
    while (1) {
        kmonitor(NULL);
  100d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d61:	e8 9d fe ff ff       	call   100c03 <kmonitor>
  100d66:	eb f2                	jmp    100d5a <__panic+0x70>

00100d68 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
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
  100d82:	c7 04 24 96 62 10 00 	movl   $0x106296,(%esp)
  100d89:	e8 d7 f5 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d95:	8b 45 10             	mov    0x10(%ebp),%eax
  100d98:	89 04 24             	mov    %eax,(%esp)
  100d9b:	e8 90 f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100da0:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100da7:	e8 b9 f5 ff ff       	call   100365 <cprintf>
    va_end(ap);
}
  100dac:	90                   	nop
  100dad:	89 ec                	mov    %ebp,%esp
  100daf:	5d                   	pop    %ebp
  100db0:	c3                   	ret    

00100db1 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100db1:	55                   	push   %ebp
  100db2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100db4:	a1 20 b4 11 00       	mov    0x11b420,%eax
}
  100db9:	5d                   	pop    %ebp
  100dba:	c3                   	ret    

00100dbb <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 28             	sub    $0x28,%esp
  100dc1:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dc7:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dcb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dcf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd3:	ee                   	out    %al,(%dx)
}
  100dd4:	90                   	nop
  100dd5:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ddb:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ddf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100de7:	ee                   	out    %al,(%dx)
}
  100de8:	90                   	nop
  100de9:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100def:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
  100dfd:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e07:	c7 04 24 b4 62 10 00 	movl   $0x1062b4,(%esp)
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
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e24:	55                   	push   %ebp
  100e25:	89 e5                	mov    %esp,%ebp
  100e27:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e2a:	9c                   	pushf  
  100e2b:	58                   	pop    %eax
  100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e32:	25 00 02 00 00       	and    $0x200,%eax
  100e37:	85 c0                	test   %eax,%eax
  100e39:	74 0c                	je     100e47 <__intr_save+0x23>
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
__intr_restore(bool flag) {
  100e50:	55                   	push   %ebp
  100e51:	89 e5                	mov    %esp,%ebp
  100e53:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e5a:	74 05                	je     100e61 <__intr_restore+0x11>
        intr_enable();
  100e5c:	e8 da 08 00 00       	call   10173b <intr_enable>
    }
}
  100e61:	90                   	nop
  100e62:	89 ec                	mov    %ebp,%esp
  100e64:	5d                   	pop    %ebp
  100e65:	c3                   	ret    

00100e66 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e66:	55                   	push   %ebp
  100e67:	89 e5                	mov    %esp,%ebp
  100e69:	83 ec 10             	sub    $0x10,%esp
  100e6c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eb1:	55                   	push   %ebp
  100eb2:	89 e5                	mov    %esp,%ebp
  100eb4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100eb7:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec1:	0f b7 00             	movzwl (%eax),%eax
  100ec4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	0f b7 00             	movzwl (%eax),%eax
  100ed6:	0f b7 c0             	movzwl %ax,%eax
  100ed9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ede:	74 12                	je     100ef2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ee0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ee7:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
  100eee:	b4 03 
  100ef0:	eb 13                	jmp    100f05 <cga_init+0x54>
    } else {
        *cp = was;
  100ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ef9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100efc:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f05:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
}
  100f1d:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f1e:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f25:	40                   	inc    %eax
  100f26:	0f b7 c0             	movzwl %ax,%eax
  100f29:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
  100f44:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f53:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f57:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f5b:	ee                   	out    %al,(%dx)
}
  100f5c:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f5d:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f64:	40                   	inc    %eax
  100f65:	0f b7 c0             	movzwl %ax,%eax
  100f68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f70:	89 c2                	mov    %eax,%edx
  100f72:	ec                   	in     (%dx),%al
  100f73:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7a:	0f b6 c0             	movzbl %al,%eax
  100f7d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f83:	a3 40 b4 11 00       	mov    %eax,0x11b440
    crt_pos = pos;
  100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f8b:	0f b7 c0             	movzwl %ax,%eax
  100f8e:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
}
  100f94:	90                   	nop
  100f95:	89 ec                	mov    %ebp,%esp
  100f97:	5d                   	pop    %ebp
  100f98:	c3                   	ret    

00100f99 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f99:	55                   	push   %ebp
  100f9a:	89 e5                	mov    %esp,%ebp
  100f9c:	83 ec 48             	sub    $0x48,%esp
  100f9f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fa5:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fa9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fb1:	ee                   	out    %al,(%dx)
}
  100fb2:	90                   	nop
  100fb3:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fb9:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fbd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fc1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fc5:	ee                   	out    %al,(%dx)
}
  100fc6:	90                   	nop
  100fc7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fcd:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fd5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
}
  100fda:	90                   	nop
  100fdb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fed:	ee                   	out    %al,(%dx)
}
  100fee:	90                   	nop
  100fef:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100ff5:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100ffd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101001:	ee                   	out    %al,(%dx)
}
  101002:	90                   	nop
  101003:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101009:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10100d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101011:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101015:	ee                   	out    %al,(%dx)
}
  101016:	90                   	nop
  101017:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10101d:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101021:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101025:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101029:	ee                   	out    %al,(%dx)
}
  10102a:	90                   	nop
  10102b:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
  101047:	a3 48 b4 11 00       	mov    %eax,0x11b448
  10104c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101052:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101056:	89 c2                	mov    %eax,%edx
  101058:	ec                   	in     (%dx),%al
  101059:	88 45 f1             	mov    %al,-0xf(%ebp)
  10105c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101062:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101066:	89 c2                	mov    %eax,%edx
  101068:	ec                   	in     (%dx),%al
  101069:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10106c:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101071:	85 c0                	test   %eax,%eax
  101073:	74 0c                	je     101081 <serial_init+0xe8>
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
lpt_putc_sub(int c) {
  101086:	55                   	push   %ebp
  101087:	89 e5                	mov    %esp,%ebp
  101089:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101093:	eb 08                	jmp    10109d <lpt_putc_sub+0x17>
        delay();
  101095:	e8 cc fd ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d5:	ee                   	out    %al,(%dx)
}
  1010d6:	90                   	nop
  1010d7:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010dd:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010e9:	ee                   	out    %al,(%dx)
}
  1010ea:	90                   	nop
  1010eb:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010f1:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
lpt_putc(int c) {
  101104:	55                   	push   %ebp
  101105:	89 e5                	mov    %esp,%ebp
  101107:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10110a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10110e:	74 0d                	je     10111d <lpt_putc+0x19>
        lpt_putc_sub(c);
  101110:	8b 45 08             	mov    0x8(%ebp),%eax
  101113:	89 04 24             	mov    %eax,(%esp)
  101116:	e8 6b ff ff ff       	call   101086 <lpt_putc_sub>
    else {
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
cga_putc(int c) {
  101146:	55                   	push   %ebp
  101147:	89 e5                	mov    %esp,%ebp
  101149:	83 ec 38             	sub    $0x38,%esp
  10114c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101157:	85 c0                	test   %eax,%eax
  101159:	75 07                	jne    101162 <cga_putc+0x1c>
        c |= 0x0700;
  10115b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
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
    case '\b':
        if (crt_pos > 0) {
  101185:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10118c:	85 c0                	test   %eax,%eax
  10118e:	0f 84 af 00 00 00    	je     101243 <cga_putc+0xfd>
            crt_pos --;
  101194:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10119b:	48                   	dec    %eax
  10119c:	0f b7 c0             	movzwl %ax,%eax
  10119f:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a8:	98                   	cwtl   
  1011a9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ae:	98                   	cwtl   
  1011af:	83 c8 20             	or     $0x20,%eax
  1011b2:	98                   	cwtl   
  1011b3:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  1011b9:	0f b7 15 44 b4 11 00 	movzwl 0x11b444,%edx
  1011c0:	01 d2                	add    %edx,%edx
  1011c2:	01 ca                	add    %ecx,%edx
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011ca:	eb 77                	jmp    101243 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011cc:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011d3:	83 c0 50             	add    $0x50,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011df:	0f b7 1d 44 b4 11 00 	movzwl 0x11b444,%ebx
  1011e6:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
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
  101211:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
        break;
  101217:	eb 2b                	jmp    101244 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101219:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  10121f:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101226:	8d 50 01             	lea    0x1(%eax),%edx
  101229:	0f b7 d2             	movzwl %dx,%edx
  10122c:	66 89 15 44 b4 11 00 	mov    %dx,0x11b444
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
    if (crt_pos >= CRT_SIZE) {
  101244:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101250:	76 5e                	jbe    1012b0 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101252:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10125d:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101269:	00 
  10126a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10126e:	89 04 24             	mov    %eax,(%esp)
  101271:	e8 c8 4b 00 00       	call   105e3e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10127d:	eb 15                	jmp    101294 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  10127f:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
  101285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101288:	01 c0                	add    %eax,%eax
  10128a:	01 d0                	add    %edx,%eax
  10128c:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101291:	ff 45 f4             	incl   -0xc(%ebp)
  101294:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10129b:	7e e2                	jle    10127f <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10129d:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012a4:	83 e8 50             	sub    $0x50,%eax
  1012a7:	0f b7 c0             	movzwl %ax,%eax
  1012aa:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012b0:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012b7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012bb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c7:	ee                   	out    %al,(%dx)
}
  1012c8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012c9:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012d0:	c1 e8 08             	shr    $0x8,%eax
  1012d3:	0f b7 c0             	movzwl %ax,%eax
  1012d6:	0f b6 c0             	movzbl %al,%eax
  1012d9:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  1012e0:	42                   	inc    %edx
  1012e1:	0f b7 d2             	movzwl %dx,%edx
  1012e4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012e8:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f3:	ee                   	out    %al,(%dx)
}
  1012f4:	90                   	nop
    outb(addr_6845, 15);
  1012f5:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101304:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101308:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10130c:	ee                   	out    %al,(%dx)
}
  10130d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10130e:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101315:	0f b6 c0             	movzbl %al,%eax
  101318:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  10131f:	42                   	inc    %edx
  101320:	0f b7 d2             	movzwl %dx,%edx
  101323:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101327:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
serial_putc_sub(int c) {
  10133c:	55                   	push   %ebp
  10133d:	89 e5                	mov    %esp,%ebp
  10133f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101349:	eb 08                	jmp    101353 <serial_putc_sub+0x17>
        delay();
  10134b:	e8 16 fb ff ff       	call   100e66 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101350:	ff 45 fc             	incl   -0x4(%ebp)
  101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
  1013aa:	e8 8d ff ff ff       	call   10133c <serial_putc_sub>
    else {
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
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013da:	55                   	push   %ebp
  1013db:	89 e5                	mov    %esp,%ebp
  1013dd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013e0:	eb 33                	jmp    101415 <cons_intr+0x3b>
        if (c != 0) {
  1013e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e6:	74 2d                	je     101415 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013e8:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013ed:	8d 50 01             	lea    0x1(%eax),%edx
  1013f0:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  1013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013f9:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013ff:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101404:	3d 00 02 00 00       	cmp    $0x200,%eax
  101409:	75 0a                	jne    101415 <cons_intr+0x3b>
                cons.wpos = 0;
  10140b:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
  101412:	00 00 00 
    while ((c = (*proc)()) != -1) {
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
serial_proc_data(void) {
  101429:	55                   	push   %ebp
  10142a:	89 e5                	mov    %esp,%ebp
  10142c:	83 ec 10             	sub    $0x10,%esp
  10142f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101435:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101439:	89 c2                	mov    %eax,%edx
  10143b:	ec                   	in     (%dx),%al
  10143c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10143f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101443:	0f b6 c0             	movzbl %al,%eax
  101446:	83 e0 01             	and    $0x1,%eax
  101449:	85 c0                	test   %eax,%eax
  10144b:	75 07                	jne    101454 <serial_proc_data+0x2b>
        return -1;
  10144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101452:	eb 2a                	jmp    10147e <serial_proc_data+0x55>
  101454:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
    if (c == 127) {
  10146e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101472:	75 07                	jne    10147b <serial_proc_data+0x52>
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
void
serial_intr(void) {
  101482:	55                   	push   %ebp
  101483:	89 e5                	mov    %esp,%ebp
  101485:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101488:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10148d:	85 c0                	test   %eax,%eax
  10148f:	74 0c                	je     10149d <serial_intr+0x1b>
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
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a2:	55                   	push   %ebp
  1014a3:	89 e5                	mov    %esp,%ebp
  1014a5:	83 ec 38             	sub    $0x38,%esp
  1014a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014b1:	89 c2                	mov    %eax,%edx
  1014b3:	ec                   	in     (%dx),%al
  1014b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	83 e0 01             	and    $0x1,%eax
  1014c1:	85 c0                	test   %eax,%eax
  1014c3:	75 0a                	jne    1014cf <kbd_proc_data+0x2d>
        return -1;
  1014c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014ca:	e9 56 01 00 00       	jmp    101625 <kbd_proc_data+0x183>
  1014cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014d8:	89 c2                	mov    %eax,%edx
  1014da:	ec                   	in     (%dx),%al
  1014db:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014de:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014e5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014e9:	75 17                	jne    101502 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014eb:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014f0:	83 c8 40             	or     $0x40,%eax
  1014f3:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  1014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014fd:	e9 23 01 00 00       	jmp    101625 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101506:	84 c0                	test   %al,%al
  101508:	79 45                	jns    10154f <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10150a:	a1 68 b6 11 00       	mov    0x11b668,%eax
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
  101529:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101530:	0c 40                	or     $0x40,%al
  101532:	0f b6 c0             	movzbl %al,%eax
  101535:	f7 d0                	not    %eax
  101537:	89 c2                	mov    %eax,%edx
  101539:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10153e:	21 d0                	and    %edx,%eax
  101540:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  101545:	b8 00 00 00 00       	mov    $0x0,%eax
  10154a:	e9 d6 00 00 00       	jmp    101625 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  10154f:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101554:	83 e0 40             	and    $0x40,%eax
  101557:	85 c0                	test   %eax,%eax
  101559:	74 11                	je     10156c <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10155b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10155f:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101564:	83 e0 bf             	and    $0xffffffbf,%eax
  101567:	a3 68 b6 11 00       	mov    %eax,0x11b668
    }

    shift |= shiftcode[data];
  10156c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101570:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101577:	0f b6 d0             	movzbl %al,%edx
  10157a:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10157f:	09 d0                	or     %edx,%eax
  101581:	a3 68 b6 11 00       	mov    %eax,0x11b668
    shift ^= togglecode[data];
  101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158a:	0f b6 80 40 81 11 00 	movzbl 0x118140(%eax),%eax
  101591:	0f b6 d0             	movzbl %al,%edx
  101594:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101599:	31 d0                	xor    %edx,%eax
  10159b:	a3 68 b6 11 00       	mov    %eax,0x11b668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a0:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015a5:	83 e0 03             	and    $0x3,%eax
  1015a8:	8b 14 85 40 85 11 00 	mov    0x118540(,%eax,4),%edx
  1015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b3:	01 d0                	add    %edx,%eax
  1015b5:	0f b6 00             	movzbl (%eax),%eax
  1015b8:	0f b6 c0             	movzbl %al,%eax
  1015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015be:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015c3:	83 e0 08             	and    $0x8,%eax
  1015c6:	85 c0                	test   %eax,%eax
  1015c8:	74 22                	je     1015ec <kbd_proc_data+0x14a>
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
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015ec:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015f1:	f7 d0                	not    %eax
  1015f3:	83 e0 06             	and    $0x6,%eax
  1015f6:	85 c0                	test   %eax,%eax
  1015f8:	75 28                	jne    101622 <kbd_proc_data+0x180>
  1015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101601:	75 1f                	jne    101622 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101603:	c7 04 24 cf 62 10 00 	movl   $0x1062cf,(%esp)
  10160a:	e8 56 ed ff ff       	call   100365 <cprintf>
  10160f:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101615:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
kbd_intr(void) {
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
kbd_init(void) {
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
void
cons_init(void) {
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101662:	e8 4a f8 ff ff       	call   100eb1 <cga_init>
    serial_init();
  101667:	e8 2d f9 ff ff       	call   100f99 <serial_init>
    kbd_init();
  10166c:	e8 cf ff ff ff       	call   101640 <kbd_init>
    if (!serial_exists) {
  101671:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101676:	85 c0                	test   %eax,%eax
  101678:	75 0c                	jne    101686 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10167a:	c7 04 24 db 62 10 00 	movl   $0x1062db,(%esp)
  101681:	e8 df ec ff ff       	call   100365 <cprintf>
    }
}
  101686:	90                   	nop
  101687:	89 ec                	mov    %ebp,%esp
  101689:	5d                   	pop    %ebp
  10168a:	c3                   	ret    

0010168b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
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
int
cons_getc(void) {
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
        if (cons.rpos != cons.wpos) {
  1016e9:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  1016ef:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1016f4:	39 c2                	cmp    %eax,%edx
  1016f6:	74 31                	je     101729 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016f8:	a1 60 b6 11 00       	mov    0x11b660,%eax
  1016fd:	8d 50 01             	lea    0x1(%eax),%edx
  101700:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  101706:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  10170d:	0f b6 c0             	movzbl %al,%eax
  101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101713:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101718:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171d:	75 0a                	jne    101729 <cons_getc+0x5f>
                cons.rpos = 0;
  10171f:	c7 05 60 b6 11 00 00 	movl   $0x0,0x11b660
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
void
intr_enable(void) {
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
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
void
intr_disable(void) {
  101743:	55                   	push   %ebp
  101744:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101746:	fa                   	cli    
}
  101747:	90                   	nop
    cli();
}
  101748:	90                   	nop
  101749:	5d                   	pop    %ebp
  10174a:	c3                   	ret    

0010174b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10174b:	55                   	push   %ebp
  10174c:	89 e5                	mov    %esp,%ebp
  10174e:	83 ec 14             	sub    $0x14,%esp
  101751:	8b 45 08             	mov    0x8(%ebp),%eax
  101754:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175b:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init) {
  101761:	a1 6c b6 11 00       	mov    0x11b66c,%eax
  101766:	85 c0                	test   %eax,%eax
  101768:	74 39                	je     1017a3 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10176d:	0f b6 c0             	movzbl %al,%eax
  101770:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101776:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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

void
pic_enable(unsigned int irq) {
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
  1017c2:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
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
void
pic_init(void) {
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
  1017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017e3:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
  1017ea:	00 00 00 
  1017ed:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017f3:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017f7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017fb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
}
  101800:	90                   	nop
  101801:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101807:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10180b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10180f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101813:	ee                   	out    %al,(%dx)
}
  101814:	90                   	nop
  101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101827:	ee                   	out    %al,(%dx)
}
  101828:	90                   	nop
  101829:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10182f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101833:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101837:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
}
  10183c:	90                   	nop
  10183d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101843:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101847:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10184b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10184f:	ee                   	out    %al,(%dx)
}
  101850:	90                   	nop
  101851:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101857:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10185f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101863:	ee                   	out    %al,(%dx)
}
  101864:	90                   	nop
  101865:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10186b:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10186f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101873:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101877:	ee                   	out    %al,(%dx)
}
  101878:	90                   	nop
  101879:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10187f:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101883:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101887:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10188b:	ee                   	out    %al,(%dx)
}
  10188c:	90                   	nop
  10188d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101893:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101897:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10189b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10189f:	ee                   	out    %al,(%dx)
}
  1018a0:	90                   	nop
  1018a1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018a7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018af:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018b3:	ee                   	out    %al,(%dx)
}
  1018b4:	90                   	nop
  1018b5:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018bb:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018c7:	ee                   	out    %al,(%dx)
}
  1018c8:	90                   	nop
  1018c9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018cf:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018db:	ee                   	out    %al,(%dx)
}
  1018dc:	90                   	nop
  1018dd:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018e3:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018eb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018ef:	ee                   	out    %al,(%dx)
}
  1018f0:	90                   	nop
  1018f1:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018f7:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101903:	ee                   	out    %al,(%dx)
}
  101904:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101905:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  10190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101911:	74 0f                	je     101922 <pic_init+0x145>
        pic_setmask(irq_mask);
  101913:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
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
  101935:	c7 04 24 00 63 10 00 	movl   $0x106300,(%esp)
  10193c:	e8 24 ea ff ff       	call   100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101941:	c7 04 24 0a 63 10 00 	movl   $0x10630a,(%esp)
  101948:	e8 18 ea ff ff       	call   100365 <cprintf>
    panic("EOT: kernel seems ok.");
  10194d:	c7 44 24 08 18 63 10 	movl   $0x106318,0x8(%esp)
  101954:	00 
  101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  10195c:	00 
  10195d:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
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
  10197e:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101985:	0f b7 d0             	movzwl %ax,%edx
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	66 89 14 c5 80 b6 11 	mov    %dx,0x11b680(,%eax,8)
  101992:	00 
  101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101996:	66 c7 04 c5 82 b6 11 	movw   $0x8,0x11b682(,%eax,8)
  10199d:	00 08 00 
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  1019aa:	00 
  1019ab:	80 e2 e0             	and    $0xe0,%dl
  1019ae:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b8:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  1019bf:	00 
  1019c0:	80 e2 1f             	and    $0x1f,%dl
  1019c3:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cd:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019d4:	00 
  1019d5:	80 e2 f0             	and    $0xf0,%dl
  1019d8:	80 ca 0e             	or     $0xe,%dl
  1019db:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e5:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019ec:	00 
  1019ed:	80 e2 ef             	and    $0xef,%dl
  1019f0:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fa:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101a01:	00 
  101a02:	80 e2 9f             	and    $0x9f,%dl
  101a05:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0f:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101a16:	00 
  101a17:	80 ca 80             	or     $0x80,%dl
  101a1a:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a24:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101a2b:	c1 e8 10             	shr    $0x10,%eax
  101a2e:	0f b7 d0             	movzwl %ax,%edx
  101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a34:	66 89 14 c5 86 b6 11 	mov    %dx,0x11b686(,%eax,8)
  101a3b:	00 
    for (int i = 0; i < 256; i++)
  101a3c:	ff 45 fc             	incl   -0x4(%ebp)
  101a3f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a46:	0f 8e 2f ff ff ff    	jle    10197b <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a4c:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101a51:	0f b7 c0             	movzwl %ax,%eax
  101a54:	66 a3 48 ba 11 00    	mov    %ax,0x11ba48
  101a5a:	66 c7 05 4a ba 11 00 	movw   $0x8,0x11ba4a
  101a61:	08 00 
  101a63:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a6a:	24 e0                	and    $0xe0,%al
  101a6c:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a71:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a78:	24 1f                	and    $0x1f,%al
  101a7a:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a7f:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a86:	24 f0                	and    $0xf0,%al
  101a88:	0c 0e                	or     $0xe,%al
  101a8a:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a8f:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a96:	24 ef                	and    $0xef,%al
  101a98:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a9d:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101aa4:	0c 60                	or     $0x60,%al
  101aa6:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101aab:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101ab2:	0c 80                	or     $0x80,%al
  101ab4:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101ab9:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101abe:	c1 e8 10             	shr    $0x10,%eax
  101ac1:	0f b7 c0             	movzwl %ax,%eax
  101ac4:	66 a3 4e ba 11 00    	mov    %ax,0x11ba4e
  101aca:	c7 45 f8 60 85 11 00 	movl   $0x118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
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
  101aeb:	8b 04 85 80 66 10 00 	mov    0x106680(,%eax,4),%eax
  101af2:	eb 18                	jmp    101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101af8:	7e 0d                	jle    101b07 <trapname+0x2a>
  101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101afe:	7f 07                	jg     101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101b00:	b8 3f 63 10 00       	mov    $0x10633f,%eax
  101b05:	eb 05                	jmp    101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
  101b07:	b8 52 63 10 00       	mov    $0x106352,%eax
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
  101b30:	c7 04 24 93 63 10 00 	movl   $0x106393,(%esp)
  101b37:	e8 29 e8 ff ff       	call   100365 <cprintf>
    print_regs(&tf->tf_regs);
  101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3f:	89 04 24             	mov    %eax,(%esp)
  101b42:	e8 8f 01 00 00       	call   101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 a4 63 10 00 	movl   $0x1063a4,(%esp)
  101b59:	e8 07 e8 ff ff       	call   100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b69:	c7 04 24 b7 63 10 00 	movl   $0x1063b7,(%esp)
  101b70:	e8 f0 e7 ff ff       	call   100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  101b87:	e8 d9 e7 ff ff       	call   100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b97:	c7 04 24 dd 63 10 00 	movl   $0x1063dd,(%esp)
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
  101bbf:	c7 04 24 f0 63 10 00 	movl   $0x1063f0,(%esp)
  101bc6:	e8 9a e7 ff ff       	call   100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 34             	mov    0x34(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  101bdc:	e8 84 e7 ff ff       	call   100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 38             	mov    0x38(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 11 64 10 00 	movl   $0x106411,(%esp)
  101bf2:	e8 6e e7 ff ff       	call   100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 20 64 10 00 	movl   $0x106420,(%esp)
  101c09:	e8 57 e7 ff ff       	call   100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	8b 40 40             	mov    0x40(%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 33 64 10 00 	movl   $0x106433,(%esp)
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
  101c46:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c4d:	85 c0                	test   %eax,%eax
  101c4f:	74 1a                	je     101c6b <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
  101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c54:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
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
  101c89:	c7 04 24 46 64 10 00 	movl   $0x106446,(%esp)
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
  101cae:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  101cb5:	e8 ab e6 ff ff       	call   100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cba:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc5:	c7 04 24 5e 64 10 00 	movl   $0x10645e,(%esp)
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
  101ce5:	c7 04 24 71 64 10 00 	movl   $0x106471,(%esp)
  101cec:	e8 74 e6 ff ff       	call   100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf4:	8b 40 04             	mov    0x4(%eax),%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 80 64 10 00 	movl   $0x106480,(%esp)
  101d02:	e8 5e e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	8b 40 08             	mov    0x8(%eax),%eax
  101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d11:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101d18:	e8 48 e6 ff ff       	call   100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d20:	8b 40 0c             	mov    0xc(%eax),%eax
  101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d27:	c7 04 24 9e 64 10 00 	movl   $0x10649e,(%esp)
  101d2e:	e8 32 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d33:	8b 45 08             	mov    0x8(%ebp),%eax
  101d36:	8b 40 10             	mov    0x10(%eax),%eax
  101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3d:	c7 04 24 ad 64 10 00 	movl   $0x1064ad,(%esp)
  101d44:	e8 1c e6 ff ff       	call   100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d49:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4c:	8b 40 14             	mov    0x14(%eax),%eax
  101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d53:	c7 04 24 bc 64 10 00 	movl   $0x1064bc,(%esp)
  101d5a:	e8 06 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d62:	8b 40 18             	mov    0x18(%eax),%eax
  101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d69:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  101d70:	e8 f0 e5 ff ff       	call   100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7f:	c7 04 24 da 64 10 00 	movl   $0x1064da,(%esp)
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
  101def:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101df4:	40                   	inc    %eax
  101df5:	a3 24 b4 11 00       	mov    %eax,0x11b424
        if (ticks == TICK_NUM)
  101dfa:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101dff:	83 f8 64             	cmp    $0x64,%eax
  101e02:	0f 85 47 01 00 00    	jne    101f4f <trap_dispatch+0x1bf>
        {
            ticks = 0;
  101e08:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
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
  101e34:	c7 04 24 e9 64 10 00 	movl   $0x1064e9,(%esp)
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
  101e5d:	c7 04 24 fb 64 10 00 	movl   $0x1064fb,(%esp)
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
  101f30:	c7 44 24 08 0a 65 10 	movl   $0x10650a,0x8(%esp)
  101f37:	00 
  101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  101f3f:	00 
  101f40:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
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
  102a08:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
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

00102a36 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102a36:	55                   	push   %ebp
  102a37:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a39:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3c:	8b 00                	mov    (%eax),%eax
}
  102a3e:	5d                   	pop    %ebp
  102a3f:	c3                   	ret    

00102a40 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a40:	55                   	push   %ebp
  102a41:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a43:	8b 45 08             	mov    0x8(%ebp),%eax
  102a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a49:	89 10                	mov    %edx,(%eax)
}
  102a4b:	90                   	nop
  102a4c:	5d                   	pop    %ebp
  102a4d:	c3                   	ret    

00102a4e <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
  102a4e:	55                   	push   %ebp
  102a4f:	89 e5                	mov    %esp,%ebp
  102a51:	83 ec 10             	sub    $0x10,%esp
  102a54:	c7 45 fc 80 be 11 00 	movl   $0x11be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a61:	89 50 04             	mov    %edx,0x4(%eax)
  102a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a67:	8b 50 04             	mov    0x4(%eax),%edx
  102a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a6d:	89 10                	mov    %edx,(%eax)
}
  102a6f:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  102a70:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102a77:	00 00 00 
}
  102a7a:	90                   	nop
  102a7b:	89 ec                	mov    %ebp,%esp
  102a7d:	5d                   	pop    %ebp
  102a7e:	c3                   	ret    

00102a7f <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
  102a7f:	55                   	push   %ebp
  102a80:	89 e5                	mov    %esp,%ebp
  102a82:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a89:	75 24                	jne    102aaf <default_init_memmap+0x30>
  102a8b:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102a92:	00 
  102a93:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102a9a:	00 
  102a9b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102aa2:	00 
  102aa3:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102aaa:	e8 3b e2 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102ab5:	eb 7b                	jmp    102b32 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
  102ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aba:	83 c0 04             	add    $0x4,%eax
  102abd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102acd:	0f a3 10             	bt     %edx,(%eax)
  102ad0:	19 c0                	sbb    %eax,%eax
  102ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ad9:	0f 95 c0             	setne  %al
  102adc:	0f b6 c0             	movzbl %al,%eax
  102adf:	85 c0                	test   %eax,%eax
  102ae1:	75 24                	jne    102b07 <default_init_memmap+0x88>
  102ae3:	c7 44 24 0c 01 67 10 	movl   $0x106701,0xc(%esp)
  102aea:	00 
  102aeb:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102af2:	00 
  102af3:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102afa:	00 
  102afb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102b02:	e8 e3 e1 ff ff       	call   100cea <__panic>
        p->flags = 0;
  102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
  102b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
  102b1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b22:	00 
  102b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b26:	89 04 24             	mov    %eax,(%esp)
  102b29:	e8 12 ff ff ff       	call   102a40 <set_page_ref>
    for (; p != base + n; p++)
  102b2e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b35:	89 d0                	mov    %edx,%eax
  102b37:	c1 e0 02             	shl    $0x2,%eax
  102b3a:	01 d0                	add    %edx,%eax
  102b3c:	c1 e0 02             	shl    $0x2,%eax
  102b3f:	89 c2                	mov    %eax,%edx
  102b41:	8b 45 08             	mov    0x8(%ebp),%eax
  102b44:	01 d0                	add    %edx,%eax
  102b46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102b49:	0f 85 68 ff ff ff    	jne    102ab7 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
  102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b52:	83 c0 04             	add    $0x4,%eax
  102b55:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b62:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b65:	0f ab 10             	bts    %edx,(%eax)
}
  102b68:	90                   	nop
    base->property = n;
  102b69:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b6f:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102b72:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b7b:	01 d0                	add    %edx,%eax
  102b7d:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
  102b82:	8b 45 08             	mov    0x8(%ebp),%eax
  102b85:	83 c0 0c             	add    $0xc,%eax
  102b88:	c7 45 e4 80 be 11 00 	movl   $0x11be80,-0x1c(%ebp)
  102b8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b95:	8b 00                	mov    (%eax),%eax
  102b97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ba3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ba6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ba9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102bac:	89 10                	mov    %edx,(%eax)
  102bae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bb1:	8b 10                	mov    (%eax),%edx
  102bb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bb6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102bbf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bc5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bc8:	89 10                	mov    %edx,(%eax)
}
  102bca:	90                   	nop
}
  102bcb:	90                   	nop
}
  102bcc:	90                   	nop
  102bcd:	89 ec                	mov    %ebp,%esp
  102bcf:	5d                   	pop    %ebp
  102bd0:	c3                   	ret    

00102bd1 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  102bd1:	55                   	push   %ebp
  102bd2:	89 e5                	mov    %esp,%ebp
  102bd4:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102bdb:	75 24                	jne    102c01 <default_alloc_pages+0x30>
  102bdd:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102be4:	00 
  102be5:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102bec:	00 
  102bed:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  102bf4:	00 
  102bf5:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102bfc:	e8 e9 e0 ff ff       	call   100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
  102c01:	a1 88 be 11 00       	mov    0x11be88,%eax
  102c06:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c09:	76 0a                	jbe    102c15 <default_alloc_pages+0x44>
    {
        return NULL;
  102c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  102c10:	e9 43 01 00 00       	jmp    102d58 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  102c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102c1c:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  102c23:	eb 1c                	jmp    102c41 <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
  102c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c28:	83 e8 0c             	sub    $0xc,%eax
  102c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  102c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c31:	8b 40 08             	mov    0x8(%eax),%eax
  102c34:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c37:	77 08                	ja     102c41 <default_alloc_pages+0x70>
        {
            page = p;
  102c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102c3f:	eb 18                	jmp    102c59 <default_alloc_pages+0x88>
  102c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c4a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c50:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102c57:	75 cc                	jne    102c25 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
  102c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c5d:	0f 84 f2 00 00 00    	je     102d55 <default_alloc_pages+0x184>
    {
        if (page->property > n)
  102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c66:	8b 40 08             	mov    0x8(%eax),%eax
  102c69:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c6c:	0f 83 8f 00 00 00    	jae    102d01 <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
  102c72:	8b 55 08             	mov    0x8(%ebp),%edx
  102c75:	89 d0                	mov    %edx,%eax
  102c77:	c1 e0 02             	shl    $0x2,%eax
  102c7a:	01 d0                	add    %edx,%eax
  102c7c:	c1 e0 02             	shl    $0x2,%eax
  102c7f:	89 c2                	mov    %eax,%edx
  102c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c84:	01 d0                	add    %edx,%eax
  102c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8c:	8b 40 08             	mov    0x8(%eax),%eax
  102c8f:	2b 45 08             	sub    0x8(%ebp),%eax
  102c92:	89 c2                	mov    %eax,%edx
  102c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c97:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  102c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c9d:	83 c0 0c             	add    $0xc,%eax
  102ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ca3:	83 c2 0c             	add    $0xc,%edx
  102ca6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102ca9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  102cac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102caf:	8b 40 04             	mov    0x4(%eax),%eax
  102cb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cb5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102cb8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cbb:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102cbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  102cc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cc7:	89 10                	mov    %edx,(%eax)
  102cc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ccc:	8b 10                	mov    (%eax),%edx
  102cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cd1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102cda:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cdd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ce0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ce3:	89 10                	mov    %edx,(%eax)
}
  102ce5:	90                   	nop
}
  102ce6:	90                   	nop
            SetPageProperty(p);
  102ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cea:	83 c0 04             	add    $0x4,%eax
  102ced:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102cf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cfd:	0f ab 10             	bts    %edx,(%eax)
}
  102d00:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
  102d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d04:	83 c0 0c             	add    $0xc,%eax
  102d07:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  102d0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d0d:	8b 40 04             	mov    0x4(%eax),%eax
  102d10:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d13:	8b 12                	mov    (%edx),%edx
  102d15:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d18:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d1b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d1e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d21:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d27:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d2a:	89 10                	mov    %edx,(%eax)
}
  102d2c:	90                   	nop
}
  102d2d:	90                   	nop
        nr_free -= n;
  102d2e:	a1 88 be 11 00       	mov    0x11be88,%eax
  102d33:	2b 45 08             	sub    0x8(%ebp),%eax
  102d36:	a3 88 be 11 00       	mov    %eax,0x11be88
        ClearPageProperty(page);
  102d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3e:	83 c0 04             	add    $0x4,%eax
  102d41:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d51:	0f b3 10             	btr    %edx,(%eax)
}
  102d54:	90                   	nop
    }
    return page;
  102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d58:	89 ec                	mov    %ebp,%esp
  102d5a:	5d                   	pop    %ebp
  102d5b:	c3                   	ret    

00102d5c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  102d5c:	55                   	push   %ebp
  102d5d:	89 e5                	mov    %esp,%ebp
  102d5f:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  102d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d69:	75 24                	jne    102d8f <default_free_pages+0x33>
  102d6b:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102d72:	00 
  102d73:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102d7a:	00 
  102d7b:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  102d82:	00 
  102d83:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102d8a:	e8 5b df ff ff       	call   100cea <__panic>
    struct Page *p = base;
  102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102d95:	e9 9d 00 00 00       	jmp    102e37 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  102d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9d:	83 c0 04             	add    $0x4,%eax
  102da0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102db0:	0f a3 10             	bt     %edx,(%eax)
  102db3:	19 c0                	sbb    %eax,%eax
  102db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dbc:	0f 95 c0             	setne  %al
  102dbf:	0f b6 c0             	movzbl %al,%eax
  102dc2:	85 c0                	test   %eax,%eax
  102dc4:	75 2c                	jne    102df2 <default_free_pages+0x96>
  102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc9:	83 c0 04             	add    $0x4,%eax
  102dcc:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102dd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102dd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102ddc:	0f a3 10             	bt     %edx,(%eax)
  102ddf:	19 c0                	sbb    %eax,%eax
  102de1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102de4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102de8:	0f 95 c0             	setne  %al
  102deb:	0f b6 c0             	movzbl %al,%eax
  102dee:	85 c0                	test   %eax,%eax
  102df0:	74 24                	je     102e16 <default_free_pages+0xba>
  102df2:	c7 44 24 0c 14 67 10 	movl   $0x106714,0xc(%esp)
  102df9:	00 
  102dfa:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102e01:	00 
  102e02:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102e09:	00 
  102e0a:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102e11:	e8 d4 de ff ff       	call   100cea <__panic>
        p->flags = 0;
  102e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102e20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e27:	00 
  102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2b:	89 04 24             	mov    %eax,(%esp)
  102e2e:	e8 0d fc ff ff       	call   102a40 <set_page_ref>
    for (; p != base + n; p++)
  102e33:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e3a:	89 d0                	mov    %edx,%eax
  102e3c:	c1 e0 02             	shl    $0x2,%eax
  102e3f:	01 d0                	add    %edx,%eax
  102e41:	c1 e0 02             	shl    $0x2,%eax
  102e44:	89 c2                	mov    %eax,%edx
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	01 d0                	add    %edx,%eax
  102e4b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e4e:	0f 85 46 ff ff ff    	jne    102d9a <default_free_pages+0x3e>
    }
    base->property = n;
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e5a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e60:	83 c0 04             	add    $0x4,%eax
  102e63:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102e6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e70:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e73:	0f ab 10             	bts    %edx,(%eax)
}
  102e76:	90                   	nop
  102e77:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
    return listelm->next;
  102e7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102e81:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
  102e87:	e9 0e 01 00 00       	jmp    102f9a <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
  102e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e8f:	83 e8 0c             	sub    $0xc,%eax
  102e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e98:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102e9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e9e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
  102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea7:	8b 50 08             	mov    0x8(%eax),%edx
  102eaa:	89 d0                	mov    %edx,%eax
  102eac:	c1 e0 02             	shl    $0x2,%eax
  102eaf:	01 d0                	add    %edx,%eax
  102eb1:	c1 e0 02             	shl    $0x2,%eax
  102eb4:	89 c2                	mov    %eax,%edx
  102eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb9:	01 d0                	add    %edx,%eax
  102ebb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ebe:	75 5d                	jne    102f1d <default_free_pages+0x1c1>
        {
            base->property += p->property;
  102ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec3:	8b 50 08             	mov    0x8(%eax),%edx
  102ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ec9:	8b 40 08             	mov    0x8(%eax),%eax
  102ecc:	01 c2                	add    %eax,%edx
  102ece:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed7:	83 c0 04             	add    $0x4,%eax
  102eda:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102ee1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ee4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ee7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102eea:	0f b3 10             	btr    %edx,(%eax)
}
  102eed:	90                   	nop
            list_del(&(p->page_link));
  102eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ef1:	83 c0 0c             	add    $0xc,%eax
  102ef4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102ef7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102efa:	8b 40 04             	mov    0x4(%eax),%eax
  102efd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102f00:	8b 12                	mov    (%edx),%edx
  102f02:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102f05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  102f08:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102f0b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102f0e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f11:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f14:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102f17:	89 10                	mov    %edx,(%eax)
}
  102f19:	90                   	nop
}
  102f1a:	90                   	nop
  102f1b:	eb 7d                	jmp    102f9a <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
  102f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f20:	8b 50 08             	mov    0x8(%eax),%edx
  102f23:	89 d0                	mov    %edx,%eax
  102f25:	c1 e0 02             	shl    $0x2,%eax
  102f28:	01 d0                	add    %edx,%eax
  102f2a:	c1 e0 02             	shl    $0x2,%eax
  102f2d:	89 c2                	mov    %eax,%edx
  102f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f32:	01 d0                	add    %edx,%eax
  102f34:	39 45 08             	cmp    %eax,0x8(%ebp)
  102f37:	75 61                	jne    102f9a <default_free_pages+0x23e>
        {
            p->property += base->property;
  102f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f3c:	8b 50 08             	mov    0x8(%eax),%edx
  102f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f42:	8b 40 08             	mov    0x8(%eax),%eax
  102f45:	01 c2                	add    %eax,%edx
  102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f50:	83 c0 04             	add    $0x4,%eax
  102f53:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102f5a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f60:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f63:	0f b3 10             	btr    %edx,(%eax)
}
  102f66:	90                   	nop
            base = p;
  102f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f6a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f70:	83 c0 0c             	add    $0xc,%eax
  102f73:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f79:	8b 40 04             	mov    0x4(%eax),%eax
  102f7c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102f7f:	8b 12                	mov    (%edx),%edx
  102f81:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102f84:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102f87:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f8a:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f8d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f90:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f93:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102f96:	89 10                	mov    %edx,(%eax)
}
  102f98:	90                   	nop
}
  102f99:	90                   	nop
    while (le != &free_list)
  102f9a:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102fa1:	0f 85 e5 fe ff ff    	jne    102e8c <default_free_pages+0x130>
        }
    }
    le = &free_list;
  102fa7:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
  102fae:	eb 25                	jmp    102fd5 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
  102fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb3:	83 e8 0c             	sub    $0xc,%eax
  102fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
  102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbc:	8b 50 08             	mov    0x8(%eax),%edx
  102fbf:	89 d0                	mov    %edx,%eax
  102fc1:	c1 e0 02             	shl    $0x2,%eax
  102fc4:	01 d0                	add    %edx,%eax
  102fc6:	c1 e0 02             	shl    $0x2,%eax
  102fc9:	89 c2                	mov    %eax,%edx
  102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fce:	01 d0                	add    %edx,%eax
  102fd0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102fd3:	73 1a                	jae    102fef <default_free_pages+0x293>
  102fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fd8:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  102fdb:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102fde:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe4:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102feb:	75 c3                	jne    102fb0 <default_free_pages+0x254>
  102fed:	eb 01                	jmp    102ff0 <default_free_pages+0x294>
        {
            break;
  102fef:	90                   	nop
        }
    }
    nr_free += n;
  102ff0:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff9:	01 d0                	add    %edx,%eax
  102ffb:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(le, &(base->page_link));
  103000:	8b 45 08             	mov    0x8(%ebp),%eax
  103003:	8d 50 0c             	lea    0xc(%eax),%edx
  103006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103009:	89 45 98             	mov    %eax,-0x68(%ebp)
  10300c:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  10300f:	8b 45 98             	mov    -0x68(%ebp),%eax
  103012:	8b 00                	mov    (%eax),%eax
  103014:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103017:	89 55 90             	mov    %edx,-0x70(%ebp)
  10301a:	89 45 8c             	mov    %eax,-0x74(%ebp)
  10301d:	8b 45 98             	mov    -0x68(%ebp),%eax
  103020:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
  103023:	8b 45 88             	mov    -0x78(%ebp),%eax
  103026:	8b 55 90             	mov    -0x70(%ebp),%edx
  103029:	89 10                	mov    %edx,(%eax)
  10302b:	8b 45 88             	mov    -0x78(%ebp),%eax
  10302e:	8b 10                	mov    (%eax),%edx
  103030:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103033:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103036:	8b 45 90             	mov    -0x70(%ebp),%eax
  103039:	8b 55 88             	mov    -0x78(%ebp),%edx
  10303c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10303f:	8b 45 90             	mov    -0x70(%ebp),%eax
  103042:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103045:	89 10                	mov    %edx,(%eax)
}
  103047:	90                   	nop
}
  103048:	90                   	nop
}
  103049:	90                   	nop
  10304a:	89 ec                	mov    %ebp,%esp
  10304c:	5d                   	pop    %ebp
  10304d:	c3                   	ret    

0010304e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  10304e:	55                   	push   %ebp
  10304f:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103051:	a1 88 be 11 00       	mov    0x11be88,%eax
}
  103056:	5d                   	pop    %ebp
  103057:	c3                   	ret    

00103058 <basic_check>:

static void
basic_check(void)
{
  103058:	55                   	push   %ebp
  103059:	89 e5                	mov    %esp,%ebp
  10305b:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10305e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103068:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103078:	e8 df 0e 00 00       	call   103f5c <alloc_pages>
  10307d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103080:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103084:	75 24                	jne    1030aa <basic_check+0x52>
  103086:	c7 44 24 0c 39 67 10 	movl   $0x106739,0xc(%esp)
  10308d:	00 
  10308e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103095:	00 
  103096:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10309d:	00 
  10309e:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1030a5:	e8 40 dc ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030b1:	e8 a6 0e 00 00       	call   103f5c <alloc_pages>
  1030b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030bd:	75 24                	jne    1030e3 <basic_check+0x8b>
  1030bf:	c7 44 24 0c 55 67 10 	movl   $0x106755,0xc(%esp)
  1030c6:	00 
  1030c7:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1030ce:	00 
  1030cf:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1030d6:	00 
  1030d7:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1030de:	e8 07 dc ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030ea:	e8 6d 0e 00 00       	call   103f5c <alloc_pages>
  1030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030f6:	75 24                	jne    10311c <basic_check+0xc4>
  1030f8:	c7 44 24 0c 71 67 10 	movl   $0x106771,0xc(%esp)
  1030ff:	00 
  103100:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103107:	00 
  103108:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10310f:	00 
  103110:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103117:	e8 ce db ff ff       	call   100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10311c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10311f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103122:	74 10                	je     103134 <basic_check+0xdc>
  103124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10312a:	74 08                	je     103134 <basic_check+0xdc>
  10312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103132:	75 24                	jne    103158 <basic_check+0x100>
  103134:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  10313b:	00 
  10313c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103143:	00 
  103144:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10314b:	00 
  10314c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103153:	e8 92 db ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315b:	89 04 24             	mov    %eax,(%esp)
  10315e:	e8 d3 f8 ff ff       	call   102a36 <page_ref>
  103163:	85 c0                	test   %eax,%eax
  103165:	75 1e                	jne    103185 <basic_check+0x12d>
  103167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316a:	89 04 24             	mov    %eax,(%esp)
  10316d:	e8 c4 f8 ff ff       	call   102a36 <page_ref>
  103172:	85 c0                	test   %eax,%eax
  103174:	75 0f                	jne    103185 <basic_check+0x12d>
  103176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103179:	89 04 24             	mov    %eax,(%esp)
  10317c:	e8 b5 f8 ff ff       	call   102a36 <page_ref>
  103181:	85 c0                	test   %eax,%eax
  103183:	74 24                	je     1031a9 <basic_check+0x151>
  103185:	c7 44 24 0c b4 67 10 	movl   $0x1067b4,0xc(%esp)
  10318c:	00 
  10318d:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103194:	00 
  103195:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  10319c:	00 
  10319d:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031a4:	e8 41 db ff ff       	call   100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031ac:	89 04 24             	mov    %eax,(%esp)
  1031af:	e8 6a f8 ff ff       	call   102a1e <page2pa>
  1031b4:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1031ba:	c1 e2 0c             	shl    $0xc,%edx
  1031bd:	39 d0                	cmp    %edx,%eax
  1031bf:	72 24                	jb     1031e5 <basic_check+0x18d>
  1031c1:	c7 44 24 0c f0 67 10 	movl   $0x1067f0,0xc(%esp)
  1031c8:	00 
  1031c9:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1031d0:	00 
  1031d1:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1031d8:	00 
  1031d9:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031e0:	e8 05 db ff ff       	call   100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e8:	89 04 24             	mov    %eax,(%esp)
  1031eb:	e8 2e f8 ff ff       	call   102a1e <page2pa>
  1031f0:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1031f6:	c1 e2 0c             	shl    $0xc,%edx
  1031f9:	39 d0                	cmp    %edx,%eax
  1031fb:	72 24                	jb     103221 <basic_check+0x1c9>
  1031fd:	c7 44 24 0c 0d 68 10 	movl   $0x10680d,0xc(%esp)
  103204:	00 
  103205:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10320c:	00 
  10320d:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103214:	00 
  103215:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10321c:	e8 c9 da ff ff       	call   100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103224:	89 04 24             	mov    %eax,(%esp)
  103227:	e8 f2 f7 ff ff       	call   102a1e <page2pa>
  10322c:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  103232:	c1 e2 0c             	shl    $0xc,%edx
  103235:	39 d0                	cmp    %edx,%eax
  103237:	72 24                	jb     10325d <basic_check+0x205>
  103239:	c7 44 24 0c 2a 68 10 	movl   $0x10682a,0xc(%esp)
  103240:	00 
  103241:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103248:	00 
  103249:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103250:	00 
  103251:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103258:	e8 8d da ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  10325d:	a1 80 be 11 00       	mov    0x11be80,%eax
  103262:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103268:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10326b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10326e:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103278:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10327b:	89 50 04             	mov    %edx,0x4(%eax)
  10327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103281:	8b 50 04             	mov    0x4(%eax),%edx
  103284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103287:	89 10                	mov    %edx,(%eax)
}
  103289:	90                   	nop
  10328a:	c7 45 e0 80 be 11 00 	movl   $0x11be80,-0x20(%ebp)
    return list->next == list;
  103291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103294:	8b 40 04             	mov    0x4(%eax),%eax
  103297:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10329a:	0f 94 c0             	sete   %al
  10329d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032a0:	85 c0                	test   %eax,%eax
  1032a2:	75 24                	jne    1032c8 <basic_check+0x270>
  1032a4:	c7 44 24 0c 47 68 10 	movl   $0x106847,0xc(%esp)
  1032ab:	00 
  1032ac:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1032b3:	00 
  1032b4:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1032bb:	00 
  1032bc:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1032c3:	e8 22 da ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  1032c8:	a1 88 be 11 00       	mov    0x11be88,%eax
  1032cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032d0:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1032d7:	00 00 00 

    assert(alloc_page() == NULL);
  1032da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032e1:	e8 76 0c 00 00       	call   103f5c <alloc_pages>
  1032e6:	85 c0                	test   %eax,%eax
  1032e8:	74 24                	je     10330e <basic_check+0x2b6>
  1032ea:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  1032f1:	00 
  1032f2:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1032f9:	00 
  1032fa:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103301:	00 
  103302:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103309:	e8 dc d9 ff ff       	call   100cea <__panic>

    free_page(p0);
  10330e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103315:	00 
  103316:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103319:	89 04 24             	mov    %eax,(%esp)
  10331c:	e8 75 0c 00 00       	call   103f96 <free_pages>
    free_page(p1);
  103321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103328:	00 
  103329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10332c:	89 04 24             	mov    %eax,(%esp)
  10332f:	e8 62 0c 00 00       	call   103f96 <free_pages>
    free_page(p2);
  103334:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333b:	00 
  10333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10333f:	89 04 24             	mov    %eax,(%esp)
  103342:	e8 4f 0c 00 00       	call   103f96 <free_pages>
    assert(nr_free == 3);
  103347:	a1 88 be 11 00       	mov    0x11be88,%eax
  10334c:	83 f8 03             	cmp    $0x3,%eax
  10334f:	74 24                	je     103375 <basic_check+0x31d>
  103351:	c7 44 24 0c 73 68 10 	movl   $0x106873,0xc(%esp)
  103358:	00 
  103359:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103360:	00 
  103361:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103368:	00 
  103369:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103370:	e8 75 d9 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
  103375:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10337c:	e8 db 0b 00 00       	call   103f5c <alloc_pages>
  103381:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103384:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103388:	75 24                	jne    1033ae <basic_check+0x356>
  10338a:	c7 44 24 0c 39 67 10 	movl   $0x106739,0xc(%esp)
  103391:	00 
  103392:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103399:	00 
  10339a:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1033a1:	00 
  1033a2:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1033a9:	e8 3c d9 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033b5:	e8 a2 0b 00 00       	call   103f5c <alloc_pages>
  1033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033c1:	75 24                	jne    1033e7 <basic_check+0x38f>
  1033c3:	c7 44 24 0c 55 67 10 	movl   $0x106755,0xc(%esp)
  1033ca:	00 
  1033cb:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1033d2:	00 
  1033d3:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1033da:	00 
  1033db:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1033e2:	e8 03 d9 ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033ee:	e8 69 0b 00 00       	call   103f5c <alloc_pages>
  1033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033fa:	75 24                	jne    103420 <basic_check+0x3c8>
  1033fc:	c7 44 24 0c 71 67 10 	movl   $0x106771,0xc(%esp)
  103403:	00 
  103404:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10340b:	00 
  10340c:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103413:	00 
  103414:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10341b:	e8 ca d8 ff ff       	call   100cea <__panic>

    assert(alloc_page() == NULL);
  103420:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103427:	e8 30 0b 00 00       	call   103f5c <alloc_pages>
  10342c:	85 c0                	test   %eax,%eax
  10342e:	74 24                	je     103454 <basic_check+0x3fc>
  103430:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  103437:	00 
  103438:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10343f:	00 
  103440:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  103447:	00 
  103448:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10344f:	e8 96 d8 ff ff       	call   100cea <__panic>

    free_page(p0);
  103454:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10345b:	00 
  10345c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10345f:	89 04 24             	mov    %eax,(%esp)
  103462:	e8 2f 0b 00 00       	call   103f96 <free_pages>
  103467:	c7 45 d8 80 be 11 00 	movl   $0x11be80,-0x28(%ebp)
  10346e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103471:	8b 40 04             	mov    0x4(%eax),%eax
  103474:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103477:	0f 94 c0             	sete   %al
  10347a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10347d:	85 c0                	test   %eax,%eax
  10347f:	74 24                	je     1034a5 <basic_check+0x44d>
  103481:	c7 44 24 0c 80 68 10 	movl   $0x106880,0xc(%esp)
  103488:	00 
  103489:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103490:	00 
  103491:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103498:	00 
  103499:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1034a0:	e8 45 d8 ff ff       	call   100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034ac:	e8 ab 0a 00 00       	call   103f5c <alloc_pages>
  1034b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034ba:	74 24                	je     1034e0 <basic_check+0x488>
  1034bc:	c7 44 24 0c 98 68 10 	movl   $0x106898,0xc(%esp)
  1034c3:	00 
  1034c4:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1034cb:	00 
  1034cc:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1034d3:	00 
  1034d4:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1034db:	e8 0a d8 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  1034e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034e7:	e8 70 0a 00 00       	call   103f5c <alloc_pages>
  1034ec:	85 c0                	test   %eax,%eax
  1034ee:	74 24                	je     103514 <basic_check+0x4bc>
  1034f0:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  1034f7:	00 
  1034f8:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1034ff:	00 
  103500:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  103507:	00 
  103508:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10350f:	e8 d6 d7 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  103514:	a1 88 be 11 00       	mov    0x11be88,%eax
  103519:	85 c0                	test   %eax,%eax
  10351b:	74 24                	je     103541 <basic_check+0x4e9>
  10351d:	c7 44 24 0c b1 68 10 	movl   $0x1068b1,0xc(%esp)
  103524:	00 
  103525:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10352c:	00 
  10352d:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103534:	00 
  103535:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10353c:	e8 a9 d7 ff ff       	call   100cea <__panic>
    free_list = free_list_store;
  103541:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103544:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103547:	a3 80 be 11 00       	mov    %eax,0x11be80
  10354c:	89 15 84 be 11 00    	mov    %edx,0x11be84
    nr_free = nr_free_store;
  103552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103555:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_page(p);
  10355a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103561:	00 
  103562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103565:	89 04 24             	mov    %eax,(%esp)
  103568:	e8 29 0a 00 00       	call   103f96 <free_pages>
    free_page(p1);
  10356d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103574:	00 
  103575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103578:	89 04 24             	mov    %eax,(%esp)
  10357b:	e8 16 0a 00 00       	call   103f96 <free_pages>
    free_page(p2);
  103580:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103587:	00 
  103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10358b:	89 04 24             	mov    %eax,(%esp)
  10358e:	e8 03 0a 00 00       	call   103f96 <free_pages>
}
  103593:	90                   	nop
  103594:	89 ec                	mov    %ebp,%esp
  103596:	5d                   	pop    %ebp
  103597:	c3                   	ret    

00103598 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  103598:	55                   	push   %ebp
  103599:	89 e5                	mov    %esp,%ebp
  10359b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1035a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035af:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  1035b6:	eb 6a                	jmp    103622 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
  1035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035bb:	83 e8 0c             	sub    $0xc,%eax
  1035be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1035c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035c4:	83 c0 04             	add    $0x4,%eax
  1035c7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035d4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035d7:	0f a3 10             	bt     %edx,(%eax)
  1035da:	19 c0                	sbb    %eax,%eax
  1035dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035e3:	0f 95 c0             	setne  %al
  1035e6:	0f b6 c0             	movzbl %al,%eax
  1035e9:	85 c0                	test   %eax,%eax
  1035eb:	75 24                	jne    103611 <default_check+0x79>
  1035ed:	c7 44 24 0c be 68 10 	movl   $0x1068be,0xc(%esp)
  1035f4:	00 
  1035f5:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1035fc:	00 
  1035fd:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103604:	00 
  103605:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10360c:	e8 d9 d6 ff ff       	call   100cea <__panic>
        count++, total += p->property;
  103611:	ff 45 f4             	incl   -0xc(%ebp)
  103614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103617:	8b 50 08             	mov    0x8(%eax),%edx
  10361a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10361d:	01 d0                	add    %edx,%eax
  10361f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103625:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103628:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10362b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  10362e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103631:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103638:	0f 85 7a ff ff ff    	jne    1035b8 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10363e:	e8 88 09 00 00       	call   103fcb <nr_free_pages>
  103643:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103646:	39 d0                	cmp    %edx,%eax
  103648:	74 24                	je     10366e <default_check+0xd6>
  10364a:	c7 44 24 0c ce 68 10 	movl   $0x1068ce,0xc(%esp)
  103651:	00 
  103652:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103659:	00 
  10365a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  103661:	00 
  103662:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103669:	e8 7c d6 ff ff       	call   100cea <__panic>

    basic_check();
  10366e:	e8 e5 f9 ff ff       	call   103058 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103673:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10367a:	e8 dd 08 00 00       	call   103f5c <alloc_pages>
  10367f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103682:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103686:	75 24                	jne    1036ac <default_check+0x114>
  103688:	c7 44 24 0c e7 68 10 	movl   $0x1068e7,0xc(%esp)
  10368f:	00 
  103690:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103697:	00 
  103698:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10369f:	00 
  1036a0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1036a7:	e8 3e d6 ff ff       	call   100cea <__panic>
    assert(!PageProperty(p0));
  1036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036af:	83 c0 04             	add    $0x4,%eax
  1036b2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036bf:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036c2:	0f a3 10             	bt     %edx,(%eax)
  1036c5:	19 c0                	sbb    %eax,%eax
  1036c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036ca:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036ce:	0f 95 c0             	setne  %al
  1036d1:	0f b6 c0             	movzbl %al,%eax
  1036d4:	85 c0                	test   %eax,%eax
  1036d6:	74 24                	je     1036fc <default_check+0x164>
  1036d8:	c7 44 24 0c f2 68 10 	movl   $0x1068f2,0xc(%esp)
  1036df:	00 
  1036e0:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1036e7:	00 
  1036e8:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1036ef:	00 
  1036f0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1036f7:	e8 ee d5 ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  1036fc:	a1 80 be 11 00       	mov    0x11be80,%eax
  103701:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103707:	89 45 80             	mov    %eax,-0x80(%ebp)
  10370a:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10370d:	c7 45 b0 80 be 11 00 	movl   $0x11be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  103714:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103717:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10371a:	89 50 04             	mov    %edx,0x4(%eax)
  10371d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103720:	8b 50 04             	mov    0x4(%eax),%edx
  103723:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103726:	89 10                	mov    %edx,(%eax)
}
  103728:	90                   	nop
  103729:	c7 45 b4 80 be 11 00 	movl   $0x11be80,-0x4c(%ebp)
    return list->next == list;
  103730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103733:	8b 40 04             	mov    0x4(%eax),%eax
  103736:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103739:	0f 94 c0             	sete   %al
  10373c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10373f:	85 c0                	test   %eax,%eax
  103741:	75 24                	jne    103767 <default_check+0x1cf>
  103743:	c7 44 24 0c 47 68 10 	movl   $0x106847,0xc(%esp)
  10374a:	00 
  10374b:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103752:	00 
  103753:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10375a:	00 
  10375b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103762:	e8 83 d5 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  103767:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10376e:	e8 e9 07 00 00       	call   103f5c <alloc_pages>
  103773:	85 c0                	test   %eax,%eax
  103775:	74 24                	je     10379b <default_check+0x203>
  103777:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  10377e:	00 
  10377f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103786:	00 
  103787:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  10378e:	00 
  10378f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103796:	e8 4f d5 ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  10379b:	a1 88 be 11 00       	mov    0x11be88,%eax
  1037a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1037a3:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1037aa:	00 00 00 

    free_pages(p0 + 2, 3);
  1037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037b0:	83 c0 28             	add    $0x28,%eax
  1037b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037ba:	00 
  1037bb:	89 04 24             	mov    %eax,(%esp)
  1037be:	e8 d3 07 00 00       	call   103f96 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037ca:	e8 8d 07 00 00       	call   103f5c <alloc_pages>
  1037cf:	85 c0                	test   %eax,%eax
  1037d1:	74 24                	je     1037f7 <default_check+0x25f>
  1037d3:	c7 44 24 0c 04 69 10 	movl   $0x106904,0xc(%esp)
  1037da:	00 
  1037db:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1037e2:	00 
  1037e3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1037ea:	00 
  1037eb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1037f2:	e8 f3 d4 ff ff       	call   100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037fa:	83 c0 28             	add    $0x28,%eax
  1037fd:	83 c0 04             	add    $0x4,%eax
  103800:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103807:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10380a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10380d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103810:	0f a3 10             	bt     %edx,(%eax)
  103813:	19 c0                	sbb    %eax,%eax
  103815:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103818:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10381c:	0f 95 c0             	setne  %al
  10381f:	0f b6 c0             	movzbl %al,%eax
  103822:	85 c0                	test   %eax,%eax
  103824:	74 0e                	je     103834 <default_check+0x29c>
  103826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103829:	83 c0 28             	add    $0x28,%eax
  10382c:	8b 40 08             	mov    0x8(%eax),%eax
  10382f:	83 f8 03             	cmp    $0x3,%eax
  103832:	74 24                	je     103858 <default_check+0x2c0>
  103834:	c7 44 24 0c 1c 69 10 	movl   $0x10691c,0xc(%esp)
  10383b:	00 
  10383c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103843:	00 
  103844:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10384b:	00 
  10384c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103853:	e8 92 d4 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103858:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10385f:	e8 f8 06 00 00       	call   103f5c <alloc_pages>
  103864:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103867:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10386b:	75 24                	jne    103891 <default_check+0x2f9>
  10386d:	c7 44 24 0c 48 69 10 	movl   $0x106948,0xc(%esp)
  103874:	00 
  103875:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10387c:	00 
  10387d:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103884:	00 
  103885:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10388c:	e8 59 d4 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  103891:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103898:	e8 bf 06 00 00       	call   103f5c <alloc_pages>
  10389d:	85 c0                	test   %eax,%eax
  10389f:	74 24                	je     1038c5 <default_check+0x32d>
  1038a1:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  1038a8:	00 
  1038a9:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038b0:	00 
  1038b1:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  1038b8:	00 
  1038b9:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1038c0:	e8 25 d4 ff ff       	call   100cea <__panic>
    assert(p0 + 2 == p1);
  1038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038c8:	83 c0 28             	add    $0x28,%eax
  1038cb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1038ce:	74 24                	je     1038f4 <default_check+0x35c>
  1038d0:	c7 44 24 0c 66 69 10 	movl   $0x106966,0xc(%esp)
  1038d7:	00 
  1038d8:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038df:	00 
  1038e0:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1038e7:	00 
  1038e8:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1038ef:	e8 f6 d3 ff ff       	call   100cea <__panic>

    p2 = p0 + 1;
  1038f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038f7:	83 c0 14             	add    $0x14,%eax
  1038fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1038fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103904:	00 
  103905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103908:	89 04 24             	mov    %eax,(%esp)
  10390b:	e8 86 06 00 00       	call   103f96 <free_pages>
    free_pages(p1, 3);
  103910:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103917:	00 
  103918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10391b:	89 04 24             	mov    %eax,(%esp)
  10391e:	e8 73 06 00 00       	call   103f96 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103926:	83 c0 04             	add    $0x4,%eax
  103929:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103930:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103933:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103936:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103939:	0f a3 10             	bt     %edx,(%eax)
  10393c:	19 c0                	sbb    %eax,%eax
  10393e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103941:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103945:	0f 95 c0             	setne  %al
  103948:	0f b6 c0             	movzbl %al,%eax
  10394b:	85 c0                	test   %eax,%eax
  10394d:	74 0b                	je     10395a <default_check+0x3c2>
  10394f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103952:	8b 40 08             	mov    0x8(%eax),%eax
  103955:	83 f8 01             	cmp    $0x1,%eax
  103958:	74 24                	je     10397e <default_check+0x3e6>
  10395a:	c7 44 24 0c 74 69 10 	movl   $0x106974,0xc(%esp)
  103961:	00 
  103962:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103969:	00 
  10396a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  103971:	00 
  103972:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103979:	e8 6c d3 ff ff       	call   100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10397e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103981:	83 c0 04             	add    $0x4,%eax
  103984:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10398b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10398e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103991:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103994:	0f a3 10             	bt     %edx,(%eax)
  103997:	19 c0                	sbb    %eax,%eax
  103999:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10399c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1039a0:	0f 95 c0             	setne  %al
  1039a3:	0f b6 c0             	movzbl %al,%eax
  1039a6:	85 c0                	test   %eax,%eax
  1039a8:	74 0b                	je     1039b5 <default_check+0x41d>
  1039aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039ad:	8b 40 08             	mov    0x8(%eax),%eax
  1039b0:	83 f8 03             	cmp    $0x3,%eax
  1039b3:	74 24                	je     1039d9 <default_check+0x441>
  1039b5:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  1039bc:	00 
  1039bd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1039c4:	00 
  1039c5:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1039cc:	00 
  1039cd:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1039d4:	e8 11 d3 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039e0:	e8 77 05 00 00       	call   103f5c <alloc_pages>
  1039e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039eb:	83 e8 14             	sub    $0x14,%eax
  1039ee:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039f1:	74 24                	je     103a17 <default_check+0x47f>
  1039f3:	c7 44 24 0c c2 69 10 	movl   $0x1069c2,0xc(%esp)
  1039fa:	00 
  1039fb:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103a02:	00 
  103a03:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  103a0a:	00 
  103a0b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103a12:	e8 d3 d2 ff ff       	call   100cea <__panic>
    free_page(p0);
  103a17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a1e:	00 
  103a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a22:	89 04 24             	mov    %eax,(%esp)
  103a25:	e8 6c 05 00 00       	call   103f96 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a2a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a31:	e8 26 05 00 00       	call   103f5c <alloc_pages>
  103a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a3c:	83 c0 14             	add    $0x14,%eax
  103a3f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a42:	74 24                	je     103a68 <default_check+0x4d0>
  103a44:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  103a4b:	00 
  103a4c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103a53:	00 
  103a54:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  103a5b:	00 
  103a5c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103a63:	e8 82 d2 ff ff       	call   100cea <__panic>

    free_pages(p0, 2);
  103a68:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a6f:	00 
  103a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a73:	89 04 24             	mov    %eax,(%esp)
  103a76:	e8 1b 05 00 00       	call   103f96 <free_pages>
    free_page(p2);
  103a7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a82:	00 
  103a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a86:	89 04 24             	mov    %eax,(%esp)
  103a89:	e8 08 05 00 00       	call   103f96 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a8e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a95:	e8 c2 04 00 00       	call   103f5c <alloc_pages>
  103a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103aa1:	75 24                	jne    103ac7 <default_check+0x52f>
  103aa3:	c7 44 24 0c 00 6a 10 	movl   $0x106a00,0xc(%esp)
  103aaa:	00 
  103aab:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103ab2:	00 
  103ab3:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103aba:	00 
  103abb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103ac2:	e8 23 d2 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  103ac7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ace:	e8 89 04 00 00       	call   103f5c <alloc_pages>
  103ad3:	85 c0                	test   %eax,%eax
  103ad5:	74 24                	je     103afb <default_check+0x563>
  103ad7:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  103ade:	00 
  103adf:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103ae6:	00 
  103ae7:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  103aee:	00 
  103aef:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103af6:	e8 ef d1 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  103afb:	a1 88 be 11 00       	mov    0x11be88,%eax
  103b00:	85 c0                	test   %eax,%eax
  103b02:	74 24                	je     103b28 <default_check+0x590>
  103b04:	c7 44 24 0c b1 68 10 	movl   $0x1068b1,0xc(%esp)
  103b0b:	00 
  103b0c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103b13:	00 
  103b14:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  103b1b:	00 
  103b1c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103b23:	e8 c2 d1 ff ff       	call   100cea <__panic>
    nr_free = nr_free_store;
  103b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b2b:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_list = free_list_store;
  103b30:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b33:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b36:	a3 80 be 11 00       	mov    %eax,0x11be80
  103b3b:	89 15 84 be 11 00    	mov    %edx,0x11be84
    free_pages(p0, 5);
  103b41:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b48:	00 
  103b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b4c:	89 04 24             	mov    %eax,(%esp)
  103b4f:	e8 42 04 00 00       	call   103f96 <free_pages>

    le = &free_list;
  103b54:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  103b5b:	eb 5a                	jmp    103bb7 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
  103b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b60:	8b 40 04             	mov    0x4(%eax),%eax
  103b63:	8b 00                	mov    (%eax),%eax
  103b65:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b68:	75 0d                	jne    103b77 <default_check+0x5df>
  103b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b6d:	8b 00                	mov    (%eax),%eax
  103b6f:	8b 40 04             	mov    0x4(%eax),%eax
  103b72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b75:	74 24                	je     103b9b <default_check+0x603>
  103b77:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  103b7e:	00 
  103b7f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103b86:	00 
  103b87:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  103b8e:	00 
  103b8f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103b96:	e8 4f d1 ff ff       	call   100cea <__panic>
        struct Page *p = le2page(le, page_link);
  103b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b9e:	83 e8 0c             	sub    $0xc,%eax
  103ba1:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  103ba4:	ff 4d f4             	decl   -0xc(%ebp)
  103ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103baa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103bad:	8b 48 08             	mov    0x8(%eax),%ecx
  103bb0:	89 d0                	mov    %edx,%eax
  103bb2:	29 c8                	sub    %ecx,%eax
  103bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bba:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103bbd:	8b 45 88             	mov    -0x78(%ebp),%eax
  103bc0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103bc6:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103bcd:	75 8e                	jne    103b5d <default_check+0x5c5>
    }
    assert(count == 0);
  103bcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bd3:	74 24                	je     103bf9 <default_check+0x661>
  103bd5:	c7 44 24 0c 4d 6a 10 	movl   $0x106a4d,0xc(%esp)
  103bdc:	00 
  103bdd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103be4:	00 
  103be5:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  103bec:	00 
  103bed:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103bf4:	e8 f1 d0 ff ff       	call   100cea <__panic>
    assert(total == 0);
  103bf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bfd:	74 24                	je     103c23 <default_check+0x68b>
  103bff:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  103c06:	00 
  103c07:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103c0e:	00 
  103c0f:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  103c16:	00 
  103c17:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103c1e:	e8 c7 d0 ff ff       	call   100cea <__panic>
}
  103c23:	90                   	nop
  103c24:	89 ec                	mov    %ebp,%esp
  103c26:	5d                   	pop    %ebp
  103c27:	c3                   	ret    

00103c28 <page2ppn>:
page2ppn(struct Page *page) {
  103c28:	55                   	push   %ebp
  103c29:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c2b:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  103c31:	8b 45 08             	mov    0x8(%ebp),%eax
  103c34:	29 d0                	sub    %edx,%eax
  103c36:	c1 f8 02             	sar    $0x2,%eax
  103c39:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c3f:	5d                   	pop    %ebp
  103c40:	c3                   	ret    

00103c41 <page2pa>:
page2pa(struct Page *page) {
  103c41:	55                   	push   %ebp
  103c42:	89 e5                	mov    %esp,%ebp
  103c44:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c47:	8b 45 08             	mov    0x8(%ebp),%eax
  103c4a:	89 04 24             	mov    %eax,(%esp)
  103c4d:	e8 d6 ff ff ff       	call   103c28 <page2ppn>
  103c52:	c1 e0 0c             	shl    $0xc,%eax
}
  103c55:	89 ec                	mov    %ebp,%esp
  103c57:	5d                   	pop    %ebp
  103c58:	c3                   	ret    

00103c59 <pa2page>:
pa2page(uintptr_t pa) {
  103c59:	55                   	push   %ebp
  103c5a:	89 e5                	mov    %esp,%ebp
  103c5c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c62:	c1 e8 0c             	shr    $0xc,%eax
  103c65:	89 c2                	mov    %eax,%edx
  103c67:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103c6c:	39 c2                	cmp    %eax,%edx
  103c6e:	72 1c                	jb     103c8c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c70:	c7 44 24 08 94 6a 10 	movl   $0x106a94,0x8(%esp)
  103c77:	00 
  103c78:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c7f:	00 
  103c80:	c7 04 24 b3 6a 10 00 	movl   $0x106ab3,(%esp)
  103c87:	e8 5e d0 ff ff       	call   100cea <__panic>
    return &pages[PPN(pa)];
  103c8c:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103c92:	8b 45 08             	mov    0x8(%ebp),%eax
  103c95:	c1 e8 0c             	shr    $0xc,%eax
  103c98:	89 c2                	mov    %eax,%edx
  103c9a:	89 d0                	mov    %edx,%eax
  103c9c:	c1 e0 02             	shl    $0x2,%eax
  103c9f:	01 d0                	add    %edx,%eax
  103ca1:	c1 e0 02             	shl    $0x2,%eax
  103ca4:	01 c8                	add    %ecx,%eax
}
  103ca6:	89 ec                	mov    %ebp,%esp
  103ca8:	5d                   	pop    %ebp
  103ca9:	c3                   	ret    

00103caa <page2kva>:
page2kva(struct Page *page) {
  103caa:	55                   	push   %ebp
  103cab:	89 e5                	mov    %esp,%ebp
  103cad:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  103cb3:	89 04 24             	mov    %eax,(%esp)
  103cb6:	e8 86 ff ff ff       	call   103c41 <page2pa>
  103cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cc1:	c1 e8 0c             	shr    $0xc,%eax
  103cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103cc7:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103ccc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ccf:	72 23                	jb     103cf4 <page2kva+0x4a>
  103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cd4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103cd8:	c7 44 24 08 c4 6a 10 	movl   $0x106ac4,0x8(%esp)
  103cdf:	00 
  103ce0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ce7:	00 
  103ce8:	c7 04 24 b3 6a 10 00 	movl   $0x106ab3,(%esp)
  103cef:	e8 f6 cf ff ff       	call   100cea <__panic>
  103cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cf7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cfc:	89 ec                	mov    %ebp,%esp
  103cfe:	5d                   	pop    %ebp
  103cff:	c3                   	ret    

00103d00 <pte2page>:
pte2page(pte_t pte) {
  103d00:	55                   	push   %ebp
  103d01:	89 e5                	mov    %esp,%ebp
  103d03:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103d06:	8b 45 08             	mov    0x8(%ebp),%eax
  103d09:	83 e0 01             	and    $0x1,%eax
  103d0c:	85 c0                	test   %eax,%eax
  103d0e:	75 1c                	jne    103d2c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103d10:	c7 44 24 08 e8 6a 10 	movl   $0x106ae8,0x8(%esp)
  103d17:	00 
  103d18:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103d1f:	00 
  103d20:	c7 04 24 b3 6a 10 00 	movl   $0x106ab3,(%esp)
  103d27:	e8 be cf ff ff       	call   100cea <__panic>
    return pa2page(PTE_ADDR(pte));
  103d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d34:	89 04 24             	mov    %eax,(%esp)
  103d37:	e8 1d ff ff ff       	call   103c59 <pa2page>
}
  103d3c:	89 ec                	mov    %ebp,%esp
  103d3e:	5d                   	pop    %ebp
  103d3f:	c3                   	ret    

00103d40 <pde2page>:
pde2page(pde_t pde) {
  103d40:	55                   	push   %ebp
  103d41:	89 e5                	mov    %esp,%ebp
  103d43:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d46:	8b 45 08             	mov    0x8(%ebp),%eax
  103d49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d4e:	89 04 24             	mov    %eax,(%esp)
  103d51:	e8 03 ff ff ff       	call   103c59 <pa2page>
}
  103d56:	89 ec                	mov    %ebp,%esp
  103d58:	5d                   	pop    %ebp
  103d59:	c3                   	ret    

00103d5a <page_ref>:
page_ref(struct Page *page) {
  103d5a:	55                   	push   %ebp
  103d5b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d60:	8b 00                	mov    (%eax),%eax
}
  103d62:	5d                   	pop    %ebp
  103d63:	c3                   	ret    

00103d64 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d64:	55                   	push   %ebp
  103d65:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d67:	8b 45 08             	mov    0x8(%ebp),%eax
  103d6a:	8b 00                	mov    (%eax),%eax
  103d6c:	8d 50 01             	lea    0x1(%eax),%edx
  103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  103d72:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d74:	8b 45 08             	mov    0x8(%ebp),%eax
  103d77:	8b 00                	mov    (%eax),%eax
}
  103d79:	5d                   	pop    %ebp
  103d7a:	c3                   	ret    

00103d7b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d7b:	55                   	push   %ebp
  103d7c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  103d81:	8b 00                	mov    (%eax),%eax
  103d83:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d86:	8b 45 08             	mov    0x8(%ebp),%eax
  103d89:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8e:	8b 00                	mov    (%eax),%eax
}
  103d90:	5d                   	pop    %ebp
  103d91:	c3                   	ret    

00103d92 <__intr_save>:
__intr_save(void) {
  103d92:	55                   	push   %ebp
  103d93:	89 e5                	mov    %esp,%ebp
  103d95:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d98:	9c                   	pushf  
  103d99:	58                   	pop    %eax
  103d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103da0:	25 00 02 00 00       	and    $0x200,%eax
  103da5:	85 c0                	test   %eax,%eax
  103da7:	74 0c                	je     103db5 <__intr_save+0x23>
        intr_disable();
  103da9:	e8 95 d9 ff ff       	call   101743 <intr_disable>
        return 1;
  103dae:	b8 01 00 00 00       	mov    $0x1,%eax
  103db3:	eb 05                	jmp    103dba <__intr_save+0x28>
    return 0;
  103db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103dba:	89 ec                	mov    %ebp,%esp
  103dbc:	5d                   	pop    %ebp
  103dbd:	c3                   	ret    

00103dbe <__intr_restore>:
__intr_restore(bool flag) {
  103dbe:	55                   	push   %ebp
  103dbf:	89 e5                	mov    %esp,%ebp
  103dc1:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103dc8:	74 05                	je     103dcf <__intr_restore+0x11>
        intr_enable();
  103dca:	e8 6c d9 ff ff       	call   10173b <intr_enable>
}
  103dcf:	90                   	nop
  103dd0:	89 ec                	mov    %ebp,%esp
  103dd2:	5d                   	pop    %ebp
  103dd3:	c3                   	ret    

00103dd4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103dd4:	55                   	push   %ebp
  103dd5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  103dda:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103ddd:	b8 23 00 00 00       	mov    $0x23,%eax
  103de2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103de4:	b8 23 00 00 00       	mov    $0x23,%eax
  103de9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103deb:	b8 10 00 00 00       	mov    $0x10,%eax
  103df0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103df2:	b8 10 00 00 00       	mov    $0x10,%eax
  103df7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103df9:	b8 10 00 00 00       	mov    $0x10,%eax
  103dfe:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103e00:	ea 07 3e 10 00 08 00 	ljmp   $0x8,$0x103e07
}
  103e07:	90                   	nop
  103e08:	5d                   	pop    %ebp
  103e09:	c3                   	ret    

00103e0a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103e0a:	55                   	push   %ebp
  103e0b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103e10:	a3 c4 be 11 00       	mov    %eax,0x11bec4
}
  103e15:	90                   	nop
  103e16:	5d                   	pop    %ebp
  103e17:	c3                   	ret    

00103e18 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103e18:	55                   	push   %ebp
  103e19:	89 e5                	mov    %esp,%ebp
  103e1b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103e1e:	b8 00 80 11 00       	mov    $0x118000,%eax
  103e23:	89 04 24             	mov    %eax,(%esp)
  103e26:	e8 df ff ff ff       	call   103e0a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e2b:	66 c7 05 c8 be 11 00 	movw   $0x10,0x11bec8
  103e32:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e34:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103e3b:	68 00 
  103e3d:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e42:	0f b7 c0             	movzwl %ax,%eax
  103e45:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103e4b:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e50:	c1 e8 10             	shr    $0x10,%eax
  103e53:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103e58:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e5f:	24 f0                	and    $0xf0,%al
  103e61:	0c 09                	or     $0x9,%al
  103e63:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e68:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e6f:	24 ef                	and    $0xef,%al
  103e71:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e76:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e7d:	24 9f                	and    $0x9f,%al
  103e7f:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e84:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e8b:	0c 80                	or     $0x80,%al
  103e8d:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e92:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e99:	24 f0                	and    $0xf0,%al
  103e9b:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ea0:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ea7:	24 ef                	and    $0xef,%al
  103ea9:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eae:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103eb5:	24 df                	and    $0xdf,%al
  103eb7:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ebc:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ec3:	0c 40                	or     $0x40,%al
  103ec5:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eca:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ed1:	24 7f                	and    $0x7f,%al
  103ed3:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ed8:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103edd:	c1 e8 18             	shr    $0x18,%eax
  103ee0:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ee5:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103eec:	e8 e3 fe ff ff       	call   103dd4 <lgdt>
  103ef1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103ef7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103efb:	0f 00 d8             	ltr    %ax
}
  103efe:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103eff:	90                   	nop
  103f00:	89 ec                	mov    %ebp,%esp
  103f02:	5d                   	pop    %ebp
  103f03:	c3                   	ret    

00103f04 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103f04:	55                   	push   %ebp
  103f05:	89 e5                	mov    %esp,%ebp
  103f07:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103f0a:	c7 05 ac be 11 00 78 	movl   $0x106a78,0x11beac
  103f11:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103f14:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f19:	8b 00                	mov    (%eax),%eax
  103f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f1f:	c7 04 24 14 6b 10 00 	movl   $0x106b14,(%esp)
  103f26:	e8 3a c4 ff ff       	call   100365 <cprintf>
    pmm_manager->init();
  103f2b:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f30:	8b 40 04             	mov    0x4(%eax),%eax
  103f33:	ff d0                	call   *%eax
}
  103f35:	90                   	nop
  103f36:	89 ec                	mov    %ebp,%esp
  103f38:	5d                   	pop    %ebp
  103f39:	c3                   	ret    

00103f3a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f3a:	55                   	push   %ebp
  103f3b:	89 e5                	mov    %esp,%ebp
  103f3d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f40:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f45:	8b 40 08             	mov    0x8(%eax),%eax
  103f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  103f52:	89 14 24             	mov    %edx,(%esp)
  103f55:	ff d0                	call   *%eax
}
  103f57:	90                   	nop
  103f58:	89 ec                	mov    %ebp,%esp
  103f5a:	5d                   	pop    %ebp
  103f5b:	c3                   	ret    

00103f5c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f5c:	55                   	push   %ebp
  103f5d:	89 e5                	mov    %esp,%ebp
  103f5f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f69:	e8 24 fe ff ff       	call   103d92 <__intr_save>
  103f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f71:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f76:	8b 40 0c             	mov    0xc(%eax),%eax
  103f79:	8b 55 08             	mov    0x8(%ebp),%edx
  103f7c:	89 14 24             	mov    %edx,(%esp)
  103f7f:	ff d0                	call   *%eax
  103f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f87:	89 04 24             	mov    %eax,(%esp)
  103f8a:	e8 2f fe ff ff       	call   103dbe <__intr_restore>
    return page;
  103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f92:	89 ec                	mov    %ebp,%esp
  103f94:	5d                   	pop    %ebp
  103f95:	c3                   	ret    

00103f96 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f96:	55                   	push   %ebp
  103f97:	89 e5                	mov    %esp,%ebp
  103f99:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f9c:	e8 f1 fd ff ff       	call   103d92 <__intr_save>
  103fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103fa4:	a1 ac be 11 00       	mov    0x11beac,%eax
  103fa9:	8b 40 10             	mov    0x10(%eax),%eax
  103fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  103faf:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  103fb6:	89 14 24             	mov    %edx,(%esp)
  103fb9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fbe:	89 04 24             	mov    %eax,(%esp)
  103fc1:	e8 f8 fd ff ff       	call   103dbe <__intr_restore>
}
  103fc6:	90                   	nop
  103fc7:	89 ec                	mov    %ebp,%esp
  103fc9:	5d                   	pop    %ebp
  103fca:	c3                   	ret    

00103fcb <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103fcb:	55                   	push   %ebp
  103fcc:	89 e5                	mov    %esp,%ebp
  103fce:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103fd1:	e8 bc fd ff ff       	call   103d92 <__intr_save>
  103fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103fd9:	a1 ac be 11 00       	mov    0x11beac,%eax
  103fde:	8b 40 14             	mov    0x14(%eax),%eax
  103fe1:	ff d0                	call   *%eax
  103fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fe9:	89 04 24             	mov    %eax,(%esp)
  103fec:	e8 cd fd ff ff       	call   103dbe <__intr_restore>
    return ret;
  103ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103ff4:	89 ec                	mov    %ebp,%esp
  103ff6:	5d                   	pop    %ebp
  103ff7:	c3                   	ret    

00103ff8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103ff8:	55                   	push   %ebp
  103ff9:	89 e5                	mov    %esp,%ebp
  103ffb:	57                   	push   %edi
  103ffc:	56                   	push   %esi
  103ffd:	53                   	push   %ebx
  103ffe:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104004:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  10400b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104012:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104019:	c7 04 24 2b 6b 10 00 	movl   $0x106b2b,(%esp)
  104020:	e8 40 c3 ff ff       	call   100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104025:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10402c:	e9 0c 01 00 00       	jmp    10413d <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104031:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104034:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104037:	89 d0                	mov    %edx,%eax
  104039:	c1 e0 02             	shl    $0x2,%eax
  10403c:	01 d0                	add    %edx,%eax
  10403e:	c1 e0 02             	shl    $0x2,%eax
  104041:	01 c8                	add    %ecx,%eax
  104043:	8b 50 08             	mov    0x8(%eax),%edx
  104046:	8b 40 04             	mov    0x4(%eax),%eax
  104049:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10404c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10404f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104052:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104055:	89 d0                	mov    %edx,%eax
  104057:	c1 e0 02             	shl    $0x2,%eax
  10405a:	01 d0                	add    %edx,%eax
  10405c:	c1 e0 02             	shl    $0x2,%eax
  10405f:	01 c8                	add    %ecx,%eax
  104061:	8b 48 0c             	mov    0xc(%eax),%ecx
  104064:	8b 58 10             	mov    0x10(%eax),%ebx
  104067:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10406a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10406d:	01 c8                	add    %ecx,%eax
  10406f:	11 da                	adc    %ebx,%edx
  104071:	89 45 98             	mov    %eax,-0x68(%ebp)
  104074:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104077:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10407a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10407d:	89 d0                	mov    %edx,%eax
  10407f:	c1 e0 02             	shl    $0x2,%eax
  104082:	01 d0                	add    %edx,%eax
  104084:	c1 e0 02             	shl    $0x2,%eax
  104087:	01 c8                	add    %ecx,%eax
  104089:	83 c0 14             	add    $0x14,%eax
  10408c:	8b 00                	mov    (%eax),%eax
  10408e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104094:	8b 45 98             	mov    -0x68(%ebp),%eax
  104097:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10409a:	83 c0 ff             	add    $0xffffffff,%eax
  10409d:	83 d2 ff             	adc    $0xffffffff,%edx
  1040a0:	89 c6                	mov    %eax,%esi
  1040a2:	89 d7                	mov    %edx,%edi
  1040a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040aa:	89 d0                	mov    %edx,%eax
  1040ac:	c1 e0 02             	shl    $0x2,%eax
  1040af:	01 d0                	add    %edx,%eax
  1040b1:	c1 e0 02             	shl    $0x2,%eax
  1040b4:	01 c8                	add    %ecx,%eax
  1040b6:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040b9:	8b 58 10             	mov    0x10(%eax),%ebx
  1040bc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1040c2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1040c6:	89 74 24 14          	mov    %esi,0x14(%esp)
  1040ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1040ce:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040d1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040d8:	89 54 24 10          	mov    %edx,0x10(%esp)
  1040dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040e4:	c7 04 24 38 6b 10 00 	movl   $0x106b38,(%esp)
  1040eb:	e8 75 c2 ff ff       	call   100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040f6:	89 d0                	mov    %edx,%eax
  1040f8:	c1 e0 02             	shl    $0x2,%eax
  1040fb:	01 d0                	add    %edx,%eax
  1040fd:	c1 e0 02             	shl    $0x2,%eax
  104100:	01 c8                	add    %ecx,%eax
  104102:	83 c0 14             	add    $0x14,%eax
  104105:	8b 00                	mov    (%eax),%eax
  104107:	83 f8 01             	cmp    $0x1,%eax
  10410a:	75 2e                	jne    10413a <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  10410c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10410f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104112:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104115:	89 d0                	mov    %edx,%eax
  104117:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  10411a:	73 1e                	jae    10413a <page_init+0x142>
  10411c:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  104121:	b8 00 00 00 00       	mov    $0x0,%eax
  104126:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104129:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  10412c:	72 0c                	jb     10413a <page_init+0x142>
                maxpa = end;
  10412e:	8b 45 98             	mov    -0x68(%ebp),%eax
  104131:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104134:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104137:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  10413a:	ff 45 dc             	incl   -0x24(%ebp)
  10413d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104140:	8b 00                	mov    (%eax),%eax
  104142:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104145:	0f 8c e6 fe ff ff    	jl     104031 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10414b:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104150:	b8 00 00 00 00       	mov    $0x0,%eax
  104155:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104158:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  10415b:	73 0e                	jae    10416b <page_init+0x173>
        maxpa = KMEMSIZE;
  10415d:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10416b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10416e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104171:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104175:	c1 ea 0c             	shr    $0xc,%edx
  104178:	a3 a4 be 11 00       	mov    %eax,0x11bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10417d:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104184:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  104189:	8d 50 ff             	lea    -0x1(%eax),%edx
  10418c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10418f:	01 d0                	add    %edx,%eax
  104191:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104194:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104197:	ba 00 00 00 00       	mov    $0x0,%edx
  10419c:	f7 75 c0             	divl   -0x40(%ebp)
  10419f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041a2:	29 d0                	sub    %edx,%eax
  1041a4:	a3 a0 be 11 00       	mov    %eax,0x11bea0

    for (i = 0; i < npage; i ++) {
  1041a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041b0:	eb 2f                	jmp    1041e1 <page_init+0x1e9>
        SetPageReserved(pages + i);
  1041b2:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  1041b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041bb:	89 d0                	mov    %edx,%eax
  1041bd:	c1 e0 02             	shl    $0x2,%eax
  1041c0:	01 d0                	add    %edx,%eax
  1041c2:	c1 e0 02             	shl    $0x2,%eax
  1041c5:	01 c8                	add    %ecx,%eax
  1041c7:	83 c0 04             	add    $0x4,%eax
  1041ca:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  1041d1:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1041d4:	8b 45 90             	mov    -0x70(%ebp),%eax
  1041d7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1041da:	0f ab 10             	bts    %edx,(%eax)
}
  1041dd:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1041de:	ff 45 dc             	incl   -0x24(%ebp)
  1041e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041e4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1041e9:	39 c2                	cmp    %eax,%edx
  1041eb:	72 c5                	jb     1041b2 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041ed:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1041f3:	89 d0                	mov    %edx,%eax
  1041f5:	c1 e0 02             	shl    $0x2,%eax
  1041f8:	01 d0                	add    %edx,%eax
  1041fa:	c1 e0 02             	shl    $0x2,%eax
  1041fd:	89 c2                	mov    %eax,%edx
  1041ff:	a1 a0 be 11 00       	mov    0x11bea0,%eax
  104204:	01 d0                	add    %edx,%eax
  104206:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104209:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  104210:	77 23                	ja     104235 <page_init+0x23d>
  104212:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104215:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104219:	c7 44 24 08 68 6b 10 	movl   $0x106b68,0x8(%esp)
  104220:	00 
  104221:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104228:	00 
  104229:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104230:	e8 b5 ca ff ff       	call   100cea <__panic>
  104235:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104238:	05 00 00 00 40       	add    $0x40000000,%eax
  10423d:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104240:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104247:	e9 53 01 00 00       	jmp    10439f <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10424c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10424f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104252:	89 d0                	mov    %edx,%eax
  104254:	c1 e0 02             	shl    $0x2,%eax
  104257:	01 d0                	add    %edx,%eax
  104259:	c1 e0 02             	shl    $0x2,%eax
  10425c:	01 c8                	add    %ecx,%eax
  10425e:	8b 50 08             	mov    0x8(%eax),%edx
  104261:	8b 40 04             	mov    0x4(%eax),%eax
  104264:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104267:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10426a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10426d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104270:	89 d0                	mov    %edx,%eax
  104272:	c1 e0 02             	shl    $0x2,%eax
  104275:	01 d0                	add    %edx,%eax
  104277:	c1 e0 02             	shl    $0x2,%eax
  10427a:	01 c8                	add    %ecx,%eax
  10427c:	8b 48 0c             	mov    0xc(%eax),%ecx
  10427f:	8b 58 10             	mov    0x10(%eax),%ebx
  104282:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104285:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104288:	01 c8                	add    %ecx,%eax
  10428a:	11 da                	adc    %ebx,%edx
  10428c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10428f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104292:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104295:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104298:	89 d0                	mov    %edx,%eax
  10429a:	c1 e0 02             	shl    $0x2,%eax
  10429d:	01 d0                	add    %edx,%eax
  10429f:	c1 e0 02             	shl    $0x2,%eax
  1042a2:	01 c8                	add    %ecx,%eax
  1042a4:	83 c0 14             	add    $0x14,%eax
  1042a7:	8b 00                	mov    (%eax),%eax
  1042a9:	83 f8 01             	cmp    $0x1,%eax
  1042ac:	0f 85 ea 00 00 00    	jne    10439c <page_init+0x3a4>
            if (begin < freemem) {
  1042b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042b5:	ba 00 00 00 00       	mov    $0x0,%edx
  1042ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1042bd:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1042c0:	19 d1                	sbb    %edx,%ecx
  1042c2:	73 0d                	jae    1042d1 <page_init+0x2d9>
                begin = freemem;
  1042c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042d1:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1042d6:	b8 00 00 00 00       	mov    $0x0,%eax
  1042db:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1042de:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042e1:	73 0e                	jae    1042f1 <page_init+0x2f9>
                end = KMEMSIZE;
  1042e3:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042ea:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042f7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042fa:	89 d0                	mov    %edx,%eax
  1042fc:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042ff:	0f 83 97 00 00 00    	jae    10439c <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  104305:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10430c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10430f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104312:	01 d0                	add    %edx,%eax
  104314:	48                   	dec    %eax
  104315:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104318:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10431b:	ba 00 00 00 00       	mov    $0x0,%edx
  104320:	f7 75 b0             	divl   -0x50(%ebp)
  104323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104326:	29 d0                	sub    %edx,%eax
  104328:	ba 00 00 00 00       	mov    $0x0,%edx
  10432d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104330:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104333:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104336:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104339:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10433c:	ba 00 00 00 00       	mov    $0x0,%edx
  104341:	89 c7                	mov    %eax,%edi
  104343:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104349:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10434c:	89 d0                	mov    %edx,%eax
  10434e:	83 e0 00             	and    $0x0,%eax
  104351:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104354:	8b 45 80             	mov    -0x80(%ebp),%eax
  104357:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10435a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10435d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104360:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104363:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104366:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104369:	89 d0                	mov    %edx,%eax
  10436b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10436e:	73 2c                	jae    10439c <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104370:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104373:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104376:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104379:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10437c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104380:	c1 ea 0c             	shr    $0xc,%edx
  104383:	89 c3                	mov    %eax,%ebx
  104385:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104388:	89 04 24             	mov    %eax,(%esp)
  10438b:	e8 c9 f8 ff ff       	call   103c59 <pa2page>
  104390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104394:	89 04 24             	mov    %eax,(%esp)
  104397:	e8 9e fb ff ff       	call   103f3a <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10439c:	ff 45 dc             	incl   -0x24(%ebp)
  10439f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043a2:	8b 00                	mov    (%eax),%eax
  1043a4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1043a7:	0f 8c 9f fe ff ff    	jl     10424c <page_init+0x254>
                }
            }
        }
    }
}
  1043ad:	90                   	nop
  1043ae:	90                   	nop
  1043af:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043b5:	5b                   	pop    %ebx
  1043b6:	5e                   	pop    %esi
  1043b7:	5f                   	pop    %edi
  1043b8:	5d                   	pop    %ebp
  1043b9:	c3                   	ret    

001043ba <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043ba:	55                   	push   %ebp
  1043bb:	89 e5                	mov    %esp,%ebp
  1043bd:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043c3:	33 45 14             	xor    0x14(%ebp),%eax
  1043c6:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043cb:	85 c0                	test   %eax,%eax
  1043cd:	74 24                	je     1043f3 <boot_map_segment+0x39>
  1043cf:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  1043d6:	00 
  1043d7:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  1043de:	00 
  1043df:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1043e6:	00 
  1043e7:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1043ee:	e8 f7 c8 ff ff       	call   100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1043fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043fd:	25 ff 0f 00 00       	and    $0xfff,%eax
  104402:	89 c2                	mov    %eax,%edx
  104404:	8b 45 10             	mov    0x10(%ebp),%eax
  104407:	01 c2                	add    %eax,%edx
  104409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10440c:	01 d0                	add    %edx,%eax
  10440e:	48                   	dec    %eax
  10440f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104415:	ba 00 00 00 00       	mov    $0x0,%edx
  10441a:	f7 75 f0             	divl   -0x10(%ebp)
  10441d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104420:	29 d0                	sub    %edx,%eax
  104422:	c1 e8 0c             	shr    $0xc,%eax
  104425:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104428:	8b 45 0c             	mov    0xc(%ebp),%eax
  10442b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10442e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104436:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104439:	8b 45 14             	mov    0x14(%ebp),%eax
  10443c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10443f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104447:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10444a:	eb 68                	jmp    1044b4 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10444c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104453:	00 
  104454:	8b 45 0c             	mov    0xc(%ebp),%eax
  104457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10445b:	8b 45 08             	mov    0x8(%ebp),%eax
  10445e:	89 04 24             	mov    %eax,(%esp)
  104461:	e8 88 01 00 00       	call   1045ee <get_pte>
  104466:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10446d:	75 24                	jne    104493 <boot_map_segment+0xd9>
  10446f:	c7 44 24 0c c6 6b 10 	movl   $0x106bc6,0xc(%esp)
  104476:	00 
  104477:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  10447e:	00 
  10447f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104486:	00 
  104487:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  10448e:	e8 57 c8 ff ff       	call   100cea <__panic>
        *ptep = pa | PTE_P | perm;
  104493:	8b 45 14             	mov    0x14(%ebp),%eax
  104496:	0b 45 18             	or     0x18(%ebp),%eax
  104499:	83 c8 01             	or     $0x1,%eax
  10449c:	89 c2                	mov    %eax,%edx
  10449e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044a1:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044a3:	ff 4d f4             	decl   -0xc(%ebp)
  1044a6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044ad:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b8:	75 92                	jne    10444c <boot_map_segment+0x92>
    }
}
  1044ba:	90                   	nop
  1044bb:	90                   	nop
  1044bc:	89 ec                	mov    %ebp,%esp
  1044be:	5d                   	pop    %ebp
  1044bf:	c3                   	ret    

001044c0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044c0:	55                   	push   %ebp
  1044c1:	89 e5                	mov    %esp,%ebp
  1044c3:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044cd:	e8 8a fa ff ff       	call   103f5c <alloc_pages>
  1044d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044d9:	75 1c                	jne    1044f7 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044db:	c7 44 24 08 d3 6b 10 	movl   $0x106bd3,0x8(%esp)
  1044e2:	00 
  1044e3:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1044ea:	00 
  1044eb:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1044f2:	e8 f3 c7 ff ff       	call   100cea <__panic>
    }
    return page2kva(p);
  1044f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fa:	89 04 24             	mov    %eax,(%esp)
  1044fd:	e8 a8 f7 ff ff       	call   103caa <page2kva>
}
  104502:	89 ec                	mov    %ebp,%esp
  104504:	5d                   	pop    %ebp
  104505:	c3                   	ret    

00104506 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104506:	55                   	push   %ebp
  104507:	89 e5                	mov    %esp,%ebp
  104509:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10450c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104511:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104514:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10451b:	77 23                	ja     104540 <pmm_init+0x3a>
  10451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104520:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104524:	c7 44 24 08 68 6b 10 	movl   $0x106b68,0x8(%esp)
  10452b:	00 
  10452c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104533:	00 
  104534:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  10453b:	e8 aa c7 ff ff       	call   100cea <__panic>
  104540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104543:	05 00 00 00 40       	add    $0x40000000,%eax
  104548:	a3 a8 be 11 00       	mov    %eax,0x11bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10454d:	e8 b2 f9 ff ff       	call   103f04 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104552:	e8 a1 fa ff ff       	call   103ff8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104557:	e8 5a 02 00 00       	call   1047b6 <check_alloc_page>

    check_pgdir();
  10455c:	e8 76 02 00 00       	call   1047d7 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104561:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104566:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104569:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104570:	77 23                	ja     104595 <pmm_init+0x8f>
  104572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104575:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104579:	c7 44 24 08 68 6b 10 	movl   $0x106b68,0x8(%esp)
  104580:	00 
  104581:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104588:	00 
  104589:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104590:	e8 55 c7 ff ff       	call   100cea <__panic>
  104595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104598:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10459e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1045a3:	05 ac 0f 00 00       	add    $0xfac,%eax
  1045a8:	83 ca 03             	or     $0x3,%edx
  1045ab:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045ad:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1045b2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045b9:	00 
  1045ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045c1:	00 
  1045c2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045c9:	38 
  1045ca:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045d1:	c0 
  1045d2:	89 04 24             	mov    %eax,(%esp)
  1045d5:	e8 e0 fd ff ff       	call   1043ba <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045da:	e8 39 f8 ff ff       	call   103e18 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045df:	e8 91 08 00 00       	call   104e75 <check_boot_pgdir>

    print_pgdir();
  1045e4:	e8 0e 0d 00 00       	call   1052f7 <print_pgdir>

}
  1045e9:	90                   	nop
  1045ea:	89 ec                	mov    %ebp,%esp
  1045ec:	5d                   	pop    %ebp
  1045ed:	c3                   	ret    

001045ee <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045ee:	55                   	push   %ebp
  1045ef:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1045f1:	90                   	nop
  1045f2:	5d                   	pop    %ebp
  1045f3:	c3                   	ret    

001045f4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1045f4:	55                   	push   %ebp
  1045f5:	89 e5                	mov    %esp,%ebp
  1045f7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104601:	00 
  104602:	8b 45 0c             	mov    0xc(%ebp),%eax
  104605:	89 44 24 04          	mov    %eax,0x4(%esp)
  104609:	8b 45 08             	mov    0x8(%ebp),%eax
  10460c:	89 04 24             	mov    %eax,(%esp)
  10460f:	e8 da ff ff ff       	call   1045ee <get_pte>
  104614:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10461b:	74 08                	je     104625 <get_page+0x31>
        *ptep_store = ptep;
  10461d:	8b 45 10             	mov    0x10(%ebp),%eax
  104620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104623:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104629:	74 1b                	je     104646 <get_page+0x52>
  10462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462e:	8b 00                	mov    (%eax),%eax
  104630:	83 e0 01             	and    $0x1,%eax
  104633:	85 c0                	test   %eax,%eax
  104635:	74 0f                	je     104646 <get_page+0x52>
        return pte2page(*ptep);
  104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10463a:	8b 00                	mov    (%eax),%eax
  10463c:	89 04 24             	mov    %eax,(%esp)
  10463f:	e8 bc f6 ff ff       	call   103d00 <pte2page>
  104644:	eb 05                	jmp    10464b <get_page+0x57>
    }
    return NULL;
  104646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10464b:	89 ec                	mov    %ebp,%esp
  10464d:	5d                   	pop    %ebp
  10464e:	c3                   	ret    

0010464f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10464f:	55                   	push   %ebp
  104650:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104652:	90                   	nop
  104653:	5d                   	pop    %ebp
  104654:	c3                   	ret    

00104655 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104655:	55                   	push   %ebp
  104656:	89 e5                	mov    %esp,%ebp
  104658:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10465b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104662:	00 
  104663:	8b 45 0c             	mov    0xc(%ebp),%eax
  104666:	89 44 24 04          	mov    %eax,0x4(%esp)
  10466a:	8b 45 08             	mov    0x8(%ebp),%eax
  10466d:	89 04 24             	mov    %eax,(%esp)
  104670:	e8 79 ff ff ff       	call   1045ee <get_pte>
  104675:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104678:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10467c:	74 19                	je     104697 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10467e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104681:	89 44 24 08          	mov    %eax,0x8(%esp)
  104685:	8b 45 0c             	mov    0xc(%ebp),%eax
  104688:	89 44 24 04          	mov    %eax,0x4(%esp)
  10468c:	8b 45 08             	mov    0x8(%ebp),%eax
  10468f:	89 04 24             	mov    %eax,(%esp)
  104692:	e8 b8 ff ff ff       	call   10464f <page_remove_pte>
    }
}
  104697:	90                   	nop
  104698:	89 ec                	mov    %ebp,%esp
  10469a:	5d                   	pop    %ebp
  10469b:	c3                   	ret    

0010469c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10469c:	55                   	push   %ebp
  10469d:	89 e5                	mov    %esp,%ebp
  10469f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1046a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046a9:	00 
  1046aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b4:	89 04 24             	mov    %eax,(%esp)
  1046b7:	e8 32 ff ff ff       	call   1045ee <get_pte>
  1046bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046c3:	75 0a                	jne    1046cf <page_insert+0x33>
        return -E_NO_MEM;
  1046c5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046ca:	e9 84 00 00 00       	jmp    104753 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046d2:	89 04 24             	mov    %eax,(%esp)
  1046d5:	e8 8a f6 ff ff       	call   103d64 <page_ref_inc>
    if (*ptep & PTE_P) {
  1046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046dd:	8b 00                	mov    (%eax),%eax
  1046df:	83 e0 01             	and    $0x1,%eax
  1046e2:	85 c0                	test   %eax,%eax
  1046e4:	74 3e                	je     104724 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e9:	8b 00                	mov    (%eax),%eax
  1046eb:	89 04 24             	mov    %eax,(%esp)
  1046ee:	e8 0d f6 ff ff       	call   103d00 <pte2page>
  1046f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046fc:	75 0d                	jne    10470b <page_insert+0x6f>
            page_ref_dec(page);
  1046fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104701:	89 04 24             	mov    %eax,(%esp)
  104704:	e8 72 f6 ff ff       	call   103d7b <page_ref_dec>
  104709:	eb 19                	jmp    104724 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10470b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10470e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104712:	8b 45 10             	mov    0x10(%ebp),%eax
  104715:	89 44 24 04          	mov    %eax,0x4(%esp)
  104719:	8b 45 08             	mov    0x8(%ebp),%eax
  10471c:	89 04 24             	mov    %eax,(%esp)
  10471f:	e8 2b ff ff ff       	call   10464f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104724:	8b 45 0c             	mov    0xc(%ebp),%eax
  104727:	89 04 24             	mov    %eax,(%esp)
  10472a:	e8 12 f5 ff ff       	call   103c41 <page2pa>
  10472f:	0b 45 14             	or     0x14(%ebp),%eax
  104732:	83 c8 01             	or     $0x1,%eax
  104735:	89 c2                	mov    %eax,%edx
  104737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10473a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10473c:	8b 45 10             	mov    0x10(%ebp),%eax
  10473f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104743:	8b 45 08             	mov    0x8(%ebp),%eax
  104746:	89 04 24             	mov    %eax,(%esp)
  104749:	e8 09 00 00 00       	call   104757 <tlb_invalidate>
    return 0;
  10474e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104753:	89 ec                	mov    %ebp,%esp
  104755:	5d                   	pop    %ebp
  104756:	c3                   	ret    

00104757 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104757:	55                   	push   %ebp
  104758:	89 e5                	mov    %esp,%ebp
  10475a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10475d:	0f 20 d8             	mov    %cr3,%eax
  104760:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104763:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  104766:	8b 45 08             	mov    0x8(%ebp),%eax
  104769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10476c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104773:	77 23                	ja     104798 <tlb_invalidate+0x41>
  104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104778:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10477c:	c7 44 24 08 68 6b 10 	movl   $0x106b68,0x8(%esp)
  104783:	00 
  104784:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  10478b:	00 
  10478c:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104793:	e8 52 c5 ff ff       	call   100cea <__panic>
  104798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479b:	05 00 00 00 40       	add    $0x40000000,%eax
  1047a0:	39 d0                	cmp    %edx,%eax
  1047a2:	75 0d                	jne    1047b1 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  1047a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1047aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047ad:	0f 01 38             	invlpg (%eax)
}
  1047b0:	90                   	nop
    }
}
  1047b1:	90                   	nop
  1047b2:	89 ec                	mov    %ebp,%esp
  1047b4:	5d                   	pop    %ebp
  1047b5:	c3                   	ret    

001047b6 <check_alloc_page>:

static void
check_alloc_page(void) {
  1047b6:	55                   	push   %ebp
  1047b7:	89 e5                	mov    %esp,%ebp
  1047b9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047bc:	a1 ac be 11 00       	mov    0x11beac,%eax
  1047c1:	8b 40 18             	mov    0x18(%eax),%eax
  1047c4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047c6:	c7 04 24 ec 6b 10 00 	movl   $0x106bec,(%esp)
  1047cd:	e8 93 bb ff ff       	call   100365 <cprintf>
}
  1047d2:	90                   	nop
  1047d3:	89 ec                	mov    %ebp,%esp
  1047d5:	5d                   	pop    %ebp
  1047d6:	c3                   	ret    

001047d7 <check_pgdir>:

static void
check_pgdir(void) {
  1047d7:	55                   	push   %ebp
  1047d8:	89 e5                	mov    %esp,%ebp
  1047da:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047dd:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1047e2:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047e7:	76 24                	jbe    10480d <check_pgdir+0x36>
  1047e9:	c7 44 24 0c 0b 6c 10 	movl   $0x106c0b,0xc(%esp)
  1047f0:	00 
  1047f1:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  1047f8:	00 
  1047f9:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  104800:	00 
  104801:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104808:	e8 dd c4 ff ff       	call   100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10480d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104812:	85 c0                	test   %eax,%eax
  104814:	74 0e                	je     104824 <check_pgdir+0x4d>
  104816:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10481b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104820:	85 c0                	test   %eax,%eax
  104822:	74 24                	je     104848 <check_pgdir+0x71>
  104824:	c7 44 24 0c 28 6c 10 	movl   $0x106c28,0xc(%esp)
  10482b:	00 
  10482c:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104833:	00 
  104834:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  10483b:	00 
  10483c:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104843:	e8 a2 c4 ff ff       	call   100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104848:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10484d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104854:	00 
  104855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10485c:	00 
  10485d:	89 04 24             	mov    %eax,(%esp)
  104860:	e8 8f fd ff ff       	call   1045f4 <get_page>
  104865:	85 c0                	test   %eax,%eax
  104867:	74 24                	je     10488d <check_pgdir+0xb6>
  104869:	c7 44 24 0c 60 6c 10 	movl   $0x106c60,0xc(%esp)
  104870:	00 
  104871:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104878:	00 
  104879:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  104880:	00 
  104881:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104888:	e8 5d c4 ff ff       	call   100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10488d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104894:	e8 c3 f6 ff ff       	call   103f5c <alloc_pages>
  104899:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10489c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1048a8:	00 
  1048a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048b0:	00 
  1048b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048b8:	89 04 24             	mov    %eax,(%esp)
  1048bb:	e8 dc fd ff ff       	call   10469c <page_insert>
  1048c0:	85 c0                	test   %eax,%eax
  1048c2:	74 24                	je     1048e8 <check_pgdir+0x111>
  1048c4:	c7 44 24 0c 88 6c 10 	movl   $0x106c88,0xc(%esp)
  1048cb:	00 
  1048cc:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  1048d3:	00 
  1048d4:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1048db:	00 
  1048dc:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1048e3:	e8 02 c4 ff ff       	call   100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048e8:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048f4:	00 
  1048f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048fc:	00 
  1048fd:	89 04 24             	mov    %eax,(%esp)
  104900:	e8 e9 fc ff ff       	call   1045ee <get_pte>
  104905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104908:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10490c:	75 24                	jne    104932 <check_pgdir+0x15b>
  10490e:	c7 44 24 0c b4 6c 10 	movl   $0x106cb4,0xc(%esp)
  104915:	00 
  104916:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  10491d:	00 
  10491e:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  104925:	00 
  104926:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  10492d:	e8 b8 c3 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  104932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104935:	8b 00                	mov    (%eax),%eax
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 c1 f3 ff ff       	call   103d00 <pte2page>
  10493f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104942:	74 24                	je     104968 <check_pgdir+0x191>
  104944:	c7 44 24 0c e1 6c 10 	movl   $0x106ce1,0xc(%esp)
  10494b:	00 
  10494c:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104953:	00 
  104954:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  10495b:	00 
  10495c:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104963:	e8 82 c3 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 1);
  104968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10496b:	89 04 24             	mov    %eax,(%esp)
  10496e:	e8 e7 f3 ff ff       	call   103d5a <page_ref>
  104973:	83 f8 01             	cmp    $0x1,%eax
  104976:	74 24                	je     10499c <check_pgdir+0x1c5>
  104978:	c7 44 24 0c f7 6c 10 	movl   $0x106cf7,0xc(%esp)
  10497f:	00 
  104980:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104987:	00 
  104988:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10498f:	00 
  104990:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104997:	e8 4e c3 ff ff       	call   100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10499c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1049a1:	8b 00                	mov    (%eax),%eax
  1049a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1049a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ae:	c1 e8 0c             	shr    $0xc,%eax
  1049b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1049b4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1049b9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049bc:	72 23                	jb     1049e1 <check_pgdir+0x20a>
  1049be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049c5:	c7 44 24 08 c4 6a 10 	movl   $0x106ac4,0x8(%esp)
  1049cc:	00 
  1049cd:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1049d4:	00 
  1049d5:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1049dc:	e8 09 c3 ff ff       	call   100cea <__panic>
  1049e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049e4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049e9:	83 c0 04             	add    $0x4,%eax
  1049ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049ef:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1049f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049fb:	00 
  1049fc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a03:	00 
  104a04:	89 04 24             	mov    %eax,(%esp)
  104a07:	e8 e2 fb ff ff       	call   1045ee <get_pte>
  104a0c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a0f:	74 24                	je     104a35 <check_pgdir+0x25e>
  104a11:	c7 44 24 0c 0c 6d 10 	movl   $0x106d0c,0xc(%esp)
  104a18:	00 
  104a19:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104a20:	00 
  104a21:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  104a28:	00 
  104a29:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104a30:	e8 b5 c2 ff ff       	call   100cea <__panic>

    p2 = alloc_page();
  104a35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a3c:	e8 1b f5 ff ff       	call   103f5c <alloc_pages>
  104a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a44:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a49:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a50:	00 
  104a51:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a58:	00 
  104a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a60:	89 04 24             	mov    %eax,(%esp)
  104a63:	e8 34 fc ff ff       	call   10469c <page_insert>
  104a68:	85 c0                	test   %eax,%eax
  104a6a:	74 24                	je     104a90 <check_pgdir+0x2b9>
  104a6c:	c7 44 24 0c 34 6d 10 	movl   $0x106d34,0xc(%esp)
  104a73:	00 
  104a74:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104a7b:	00 
  104a7c:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  104a83:	00 
  104a84:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104a8b:	e8 5a c2 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a90:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a9c:	00 
  104a9d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104aa4:	00 
  104aa5:	89 04 24             	mov    %eax,(%esp)
  104aa8:	e8 41 fb ff ff       	call   1045ee <get_pte>
  104aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ab0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ab4:	75 24                	jne    104ada <check_pgdir+0x303>
  104ab6:	c7 44 24 0c 6c 6d 10 	movl   $0x106d6c,0xc(%esp)
  104abd:	00 
  104abe:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104ac5:	00 
  104ac6:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  104acd:	00 
  104ace:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104ad5:	e8 10 c2 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_U);
  104ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104add:	8b 00                	mov    (%eax),%eax
  104adf:	83 e0 04             	and    $0x4,%eax
  104ae2:	85 c0                	test   %eax,%eax
  104ae4:	75 24                	jne    104b0a <check_pgdir+0x333>
  104ae6:	c7 44 24 0c 9c 6d 10 	movl   $0x106d9c,0xc(%esp)
  104aed:	00 
  104aee:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104af5:	00 
  104af6:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104afd:	00 
  104afe:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104b05:	e8 e0 c1 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_W);
  104b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b0d:	8b 00                	mov    (%eax),%eax
  104b0f:	83 e0 02             	and    $0x2,%eax
  104b12:	85 c0                	test   %eax,%eax
  104b14:	75 24                	jne    104b3a <check_pgdir+0x363>
  104b16:	c7 44 24 0c aa 6d 10 	movl   $0x106daa,0xc(%esp)
  104b1d:	00 
  104b1e:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104b25:	00 
  104b26:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104b2d:	00 
  104b2e:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104b35:	e8 b0 c1 ff ff       	call   100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b3a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b3f:	8b 00                	mov    (%eax),%eax
  104b41:	83 e0 04             	and    $0x4,%eax
  104b44:	85 c0                	test   %eax,%eax
  104b46:	75 24                	jne    104b6c <check_pgdir+0x395>
  104b48:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104b4f:	00 
  104b50:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104b57:	00 
  104b58:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104b5f:	00 
  104b60:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104b67:	e8 7e c1 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 1);
  104b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b6f:	89 04 24             	mov    %eax,(%esp)
  104b72:	e8 e3 f1 ff ff       	call   103d5a <page_ref>
  104b77:	83 f8 01             	cmp    $0x1,%eax
  104b7a:	74 24                	je     104ba0 <check_pgdir+0x3c9>
  104b7c:	c7 44 24 0c ce 6d 10 	movl   $0x106dce,0xc(%esp)
  104b83:	00 
  104b84:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104b8b:	00 
  104b8c:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104b93:	00 
  104b94:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104b9b:	e8 4a c1 ff ff       	call   100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104ba0:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ba5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104bac:	00 
  104bad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bb4:	00 
  104bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bbc:	89 04 24             	mov    %eax,(%esp)
  104bbf:	e8 d8 fa ff ff       	call   10469c <page_insert>
  104bc4:	85 c0                	test   %eax,%eax
  104bc6:	74 24                	je     104bec <check_pgdir+0x415>
  104bc8:	c7 44 24 0c e0 6d 10 	movl   $0x106de0,0xc(%esp)
  104bcf:	00 
  104bd0:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104bd7:	00 
  104bd8:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104bdf:	00 
  104be0:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104be7:	e8 fe c0 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 2);
  104bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bef:	89 04 24             	mov    %eax,(%esp)
  104bf2:	e8 63 f1 ff ff       	call   103d5a <page_ref>
  104bf7:	83 f8 02             	cmp    $0x2,%eax
  104bfa:	74 24                	je     104c20 <check_pgdir+0x449>
  104bfc:	c7 44 24 0c 0c 6e 10 	movl   $0x106e0c,0xc(%esp)
  104c03:	00 
  104c04:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104c0b:	00 
  104c0c:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104c13:	00 
  104c14:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104c1b:	e8 ca c0 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c23:	89 04 24             	mov    %eax,(%esp)
  104c26:	e8 2f f1 ff ff       	call   103d5a <page_ref>
  104c2b:	85 c0                	test   %eax,%eax
  104c2d:	74 24                	je     104c53 <check_pgdir+0x47c>
  104c2f:	c7 44 24 0c 1e 6e 10 	movl   $0x106e1e,0xc(%esp)
  104c36:	00 
  104c37:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104c3e:	00 
  104c3f:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104c46:	00 
  104c47:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104c4e:	e8 97 c0 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c53:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104c58:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c5f:	00 
  104c60:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c67:	00 
  104c68:	89 04 24             	mov    %eax,(%esp)
  104c6b:	e8 7e f9 ff ff       	call   1045ee <get_pte>
  104c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c77:	75 24                	jne    104c9d <check_pgdir+0x4c6>
  104c79:	c7 44 24 0c 6c 6d 10 	movl   $0x106d6c,0xc(%esp)
  104c80:	00 
  104c81:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104c88:	00 
  104c89:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104c90:	00 
  104c91:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104c98:	e8 4d c0 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  104c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca0:	8b 00                	mov    (%eax),%eax
  104ca2:	89 04 24             	mov    %eax,(%esp)
  104ca5:	e8 56 f0 ff ff       	call   103d00 <pte2page>
  104caa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104cad:	74 24                	je     104cd3 <check_pgdir+0x4fc>
  104caf:	c7 44 24 0c e1 6c 10 	movl   $0x106ce1,0xc(%esp)
  104cb6:	00 
  104cb7:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104cbe:	00 
  104cbf:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104cc6:	00 
  104cc7:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104cce:	e8 17 c0 ff ff       	call   100cea <__panic>
    assert((*ptep & PTE_U) == 0);
  104cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd6:	8b 00                	mov    (%eax),%eax
  104cd8:	83 e0 04             	and    $0x4,%eax
  104cdb:	85 c0                	test   %eax,%eax
  104cdd:	74 24                	je     104d03 <check_pgdir+0x52c>
  104cdf:	c7 44 24 0c 30 6e 10 	movl   $0x106e30,0xc(%esp)
  104ce6:	00 
  104ce7:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104cee:	00 
  104cef:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104cf6:	00 
  104cf7:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104cfe:	e8 e7 bf ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, 0x0);
  104d03:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d0f:	00 
  104d10:	89 04 24             	mov    %eax,(%esp)
  104d13:	e8 3d f9 ff ff       	call   104655 <page_remove>
    assert(page_ref(p1) == 1);
  104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d1b:	89 04 24             	mov    %eax,(%esp)
  104d1e:	e8 37 f0 ff ff       	call   103d5a <page_ref>
  104d23:	83 f8 01             	cmp    $0x1,%eax
  104d26:	74 24                	je     104d4c <check_pgdir+0x575>
  104d28:	c7 44 24 0c f7 6c 10 	movl   $0x106cf7,0xc(%esp)
  104d2f:	00 
  104d30:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104d37:	00 
  104d38:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104d3f:	00 
  104d40:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104d47:	e8 9e bf ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d4f:	89 04 24             	mov    %eax,(%esp)
  104d52:	e8 03 f0 ff ff       	call   103d5a <page_ref>
  104d57:	85 c0                	test   %eax,%eax
  104d59:	74 24                	je     104d7f <check_pgdir+0x5a8>
  104d5b:	c7 44 24 0c 1e 6e 10 	movl   $0x106e1e,0xc(%esp)
  104d62:	00 
  104d63:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104d6a:	00 
  104d6b:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104d72:	00 
  104d73:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104d7a:	e8 6b bf ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d7f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d84:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d8b:	00 
  104d8c:	89 04 24             	mov    %eax,(%esp)
  104d8f:	e8 c1 f8 ff ff       	call   104655 <page_remove>
    assert(page_ref(p1) == 0);
  104d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d97:	89 04 24             	mov    %eax,(%esp)
  104d9a:	e8 bb ef ff ff       	call   103d5a <page_ref>
  104d9f:	85 c0                	test   %eax,%eax
  104da1:	74 24                	je     104dc7 <check_pgdir+0x5f0>
  104da3:	c7 44 24 0c 45 6e 10 	movl   $0x106e45,0xc(%esp)
  104daa:	00 
  104dab:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104db2:	00 
  104db3:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104dba:	00 
  104dbb:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104dc2:	e8 23 bf ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dca:	89 04 24             	mov    %eax,(%esp)
  104dcd:	e8 88 ef ff ff       	call   103d5a <page_ref>
  104dd2:	85 c0                	test   %eax,%eax
  104dd4:	74 24                	je     104dfa <check_pgdir+0x623>
  104dd6:	c7 44 24 0c 1e 6e 10 	movl   $0x106e1e,0xc(%esp)
  104ddd:	00 
  104dde:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104de5:	00 
  104de6:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104ded:	00 
  104dee:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104df5:	e8 f0 be ff ff       	call   100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104dfa:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104dff:	8b 00                	mov    (%eax),%eax
  104e01:	89 04 24             	mov    %eax,(%esp)
  104e04:	e8 37 ef ff ff       	call   103d40 <pde2page>
  104e09:	89 04 24             	mov    %eax,(%esp)
  104e0c:	e8 49 ef ff ff       	call   103d5a <page_ref>
  104e11:	83 f8 01             	cmp    $0x1,%eax
  104e14:	74 24                	je     104e3a <check_pgdir+0x663>
  104e16:	c7 44 24 0c 58 6e 10 	movl   $0x106e58,0xc(%esp)
  104e1d:	00 
  104e1e:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104e25:	00 
  104e26:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104e2d:	00 
  104e2e:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104e35:	e8 b0 be ff ff       	call   100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104e3a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e3f:	8b 00                	mov    (%eax),%eax
  104e41:	89 04 24             	mov    %eax,(%esp)
  104e44:	e8 f7 ee ff ff       	call   103d40 <pde2page>
  104e49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e50:	00 
  104e51:	89 04 24             	mov    %eax,(%esp)
  104e54:	e8 3d f1 ff ff       	call   103f96 <free_pages>
    boot_pgdir[0] = 0;
  104e59:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e64:	c7 04 24 7f 6e 10 00 	movl   $0x106e7f,(%esp)
  104e6b:	e8 f5 b4 ff ff       	call   100365 <cprintf>
}
  104e70:	90                   	nop
  104e71:	89 ec                	mov    %ebp,%esp
  104e73:	5d                   	pop    %ebp
  104e74:	c3                   	ret    

00104e75 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e75:	55                   	push   %ebp
  104e76:	89 e5                	mov    %esp,%ebp
  104e78:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e82:	e9 ca 00 00 00       	jmp    104f51 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e90:	c1 e8 0c             	shr    $0xc,%eax
  104e93:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104e96:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104e9b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104e9e:	72 23                	jb     104ec3 <check_boot_pgdir+0x4e>
  104ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ea7:	c7 44 24 08 c4 6a 10 	movl   $0x106ac4,0x8(%esp)
  104eae:	00 
  104eaf:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104eb6:	00 
  104eb7:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104ebe:	e8 27 be ff ff       	call   100cea <__panic>
  104ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ec6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ecb:	89 c2                	mov    %eax,%edx
  104ecd:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ed2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ed9:	00 
  104eda:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ede:	89 04 24             	mov    %eax,(%esp)
  104ee1:	e8 08 f7 ff ff       	call   1045ee <get_pte>
  104ee6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ee9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104eed:	75 24                	jne    104f13 <check_boot_pgdir+0x9e>
  104eef:	c7 44 24 0c 9c 6e 10 	movl   $0x106e9c,0xc(%esp)
  104ef6:	00 
  104ef7:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104efe:	00 
  104eff:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104f06:	00 
  104f07:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104f0e:	e8 d7 bd ff ff       	call   100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f16:	8b 00                	mov    (%eax),%eax
  104f18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f1d:	89 c2                	mov    %eax,%edx
  104f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f22:	39 c2                	cmp    %eax,%edx
  104f24:	74 24                	je     104f4a <check_boot_pgdir+0xd5>
  104f26:	c7 44 24 0c d9 6e 10 	movl   $0x106ed9,0xc(%esp)
  104f2d:	00 
  104f2e:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104f35:	00 
  104f36:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104f3d:	00 
  104f3e:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104f45:	e8 a0 bd ff ff       	call   100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104f4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f54:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104f59:	39 c2                	cmp    %eax,%edx
  104f5b:	0f 82 26 ff ff ff    	jb     104e87 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f61:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f66:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f6b:	8b 00                	mov    (%eax),%eax
  104f6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f72:	89 c2                	mov    %eax,%edx
  104f74:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f7c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104f83:	77 23                	ja     104fa8 <check_boot_pgdir+0x133>
  104f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f88:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f8c:	c7 44 24 08 68 6b 10 	movl   $0x106b68,0x8(%esp)
  104f93:	00 
  104f94:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104f9b:	00 
  104f9c:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104fa3:	e8 42 bd ff ff       	call   100cea <__panic>
  104fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fab:	05 00 00 00 40       	add    $0x40000000,%eax
  104fb0:	39 d0                	cmp    %edx,%eax
  104fb2:	74 24                	je     104fd8 <check_boot_pgdir+0x163>
  104fb4:	c7 44 24 0c f0 6e 10 	movl   $0x106ef0,0xc(%esp)
  104fbb:	00 
  104fbc:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104fc3:	00 
  104fc4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104fcb:	00 
  104fcc:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  104fd3:	e8 12 bd ff ff       	call   100cea <__panic>

    assert(boot_pgdir[0] == 0);
  104fd8:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104fdd:	8b 00                	mov    (%eax),%eax
  104fdf:	85 c0                	test   %eax,%eax
  104fe1:	74 24                	je     105007 <check_boot_pgdir+0x192>
  104fe3:	c7 44 24 0c 24 6f 10 	movl   $0x106f24,0xc(%esp)
  104fea:	00 
  104feb:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  104ff2:	00 
  104ff3:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104ffa:	00 
  104ffb:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  105002:	e8 e3 bc ff ff       	call   100cea <__panic>

    struct Page *p;
    p = alloc_page();
  105007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10500e:	e8 49 ef ff ff       	call   103f5c <alloc_pages>
  105013:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105016:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10501b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105022:	00 
  105023:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10502a:	00 
  10502b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10502e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105032:	89 04 24             	mov    %eax,(%esp)
  105035:	e8 62 f6 ff ff       	call   10469c <page_insert>
  10503a:	85 c0                	test   %eax,%eax
  10503c:	74 24                	je     105062 <check_boot_pgdir+0x1ed>
  10503e:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  105045:	00 
  105046:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  10504d:	00 
  10504e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  105055:	00 
  105056:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  10505d:	e8 88 bc ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 1);
  105062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105065:	89 04 24             	mov    %eax,(%esp)
  105068:	e8 ed ec ff ff       	call   103d5a <page_ref>
  10506d:	83 f8 01             	cmp    $0x1,%eax
  105070:	74 24                	je     105096 <check_boot_pgdir+0x221>
  105072:	c7 44 24 0c 66 6f 10 	movl   $0x106f66,0xc(%esp)
  105079:	00 
  10507a:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  105081:	00 
  105082:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  105089:	00 
  10508a:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  105091:	e8 54 bc ff ff       	call   100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105096:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10509b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050a2:	00 
  1050a3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050aa:	00 
  1050ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050b2:	89 04 24             	mov    %eax,(%esp)
  1050b5:	e8 e2 f5 ff ff       	call   10469c <page_insert>
  1050ba:	85 c0                	test   %eax,%eax
  1050bc:	74 24                	je     1050e2 <check_boot_pgdir+0x26d>
  1050be:	c7 44 24 0c 78 6f 10 	movl   $0x106f78,0xc(%esp)
  1050c5:	00 
  1050c6:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  1050cd:	00 
  1050ce:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  1050d5:	00 
  1050d6:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1050dd:	e8 08 bc ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 2);
  1050e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050e5:	89 04 24             	mov    %eax,(%esp)
  1050e8:	e8 6d ec ff ff       	call   103d5a <page_ref>
  1050ed:	83 f8 02             	cmp    $0x2,%eax
  1050f0:	74 24                	je     105116 <check_boot_pgdir+0x2a1>
  1050f2:	c7 44 24 0c af 6f 10 	movl   $0x106faf,0xc(%esp)
  1050f9:	00 
  1050fa:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  105101:	00 
  105102:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105109:	00 
  10510a:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  105111:	e8 d4 bb ff ff       	call   100cea <__panic>

    const char *str = "ucore: Hello world!!";
  105116:	c7 45 e8 c0 6f 10 00 	movl   $0x106fc0,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10511d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105120:	89 44 24 04          	mov    %eax,0x4(%esp)
  105124:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10512b:	e8 fc 09 00 00       	call   105b2c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105130:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105137:	00 
  105138:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10513f:	e8 60 0a 00 00       	call   105ba4 <strcmp>
  105144:	85 c0                	test   %eax,%eax
  105146:	74 24                	je     10516c <check_boot_pgdir+0x2f7>
  105148:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  10514f:	00 
  105150:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  105157:	00 
  105158:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  10515f:	00 
  105160:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  105167:	e8 7e bb ff ff       	call   100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10516c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10516f:	89 04 24             	mov    %eax,(%esp)
  105172:	e8 33 eb ff ff       	call   103caa <page2kva>
  105177:	05 00 01 00 00       	add    $0x100,%eax
  10517c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10517f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105186:	e8 47 09 00 00       	call   105ad2 <strlen>
  10518b:	85 c0                	test   %eax,%eax
  10518d:	74 24                	je     1051b3 <check_boot_pgdir+0x33e>
  10518f:	c7 44 24 0c 10 70 10 	movl   $0x107010,0xc(%esp)
  105196:	00 
  105197:	c7 44 24 08 b1 6b 10 	movl   $0x106bb1,0x8(%esp)
  10519e:	00 
  10519f:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  1051a6:	00 
  1051a7:	c7 04 24 8c 6b 10 00 	movl   $0x106b8c,(%esp)
  1051ae:	e8 37 bb ff ff       	call   100cea <__panic>

    free_page(p);
  1051b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051ba:	00 
  1051bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051be:	89 04 24             	mov    %eax,(%esp)
  1051c1:	e8 d0 ed ff ff       	call   103f96 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1051c6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051cb:	8b 00                	mov    (%eax),%eax
  1051cd:	89 04 24             	mov    %eax,(%esp)
  1051d0:	e8 6b eb ff ff       	call   103d40 <pde2page>
  1051d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051dc:	00 
  1051dd:	89 04 24             	mov    %eax,(%esp)
  1051e0:	e8 b1 ed ff ff       	call   103f96 <free_pages>
    boot_pgdir[0] = 0;
  1051e5:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051f0:	c7 04 24 34 70 10 00 	movl   $0x107034,(%esp)
  1051f7:	e8 69 b1 ff ff       	call   100365 <cprintf>
}
  1051fc:	90                   	nop
  1051fd:	89 ec                	mov    %ebp,%esp
  1051ff:	5d                   	pop    %ebp
  105200:	c3                   	ret    

00105201 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105201:	55                   	push   %ebp
  105202:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105204:	8b 45 08             	mov    0x8(%ebp),%eax
  105207:	83 e0 04             	and    $0x4,%eax
  10520a:	85 c0                	test   %eax,%eax
  10520c:	74 04                	je     105212 <perm2str+0x11>
  10520e:	b0 75                	mov    $0x75,%al
  105210:	eb 02                	jmp    105214 <perm2str+0x13>
  105212:	b0 2d                	mov    $0x2d,%al
  105214:	a2 28 bf 11 00       	mov    %al,0x11bf28
    str[1] = 'r';
  105219:	c6 05 29 bf 11 00 72 	movb   $0x72,0x11bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105220:	8b 45 08             	mov    0x8(%ebp),%eax
  105223:	83 e0 02             	and    $0x2,%eax
  105226:	85 c0                	test   %eax,%eax
  105228:	74 04                	je     10522e <perm2str+0x2d>
  10522a:	b0 77                	mov    $0x77,%al
  10522c:	eb 02                	jmp    105230 <perm2str+0x2f>
  10522e:	b0 2d                	mov    $0x2d,%al
  105230:	a2 2a bf 11 00       	mov    %al,0x11bf2a
    str[3] = '\0';
  105235:	c6 05 2b bf 11 00 00 	movb   $0x0,0x11bf2b
    return str;
  10523c:	b8 28 bf 11 00       	mov    $0x11bf28,%eax
}
  105241:	5d                   	pop    %ebp
  105242:	c3                   	ret    

00105243 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105243:	55                   	push   %ebp
  105244:	89 e5                	mov    %esp,%ebp
  105246:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105249:	8b 45 10             	mov    0x10(%ebp),%eax
  10524c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10524f:	72 0d                	jb     10525e <get_pgtable_items+0x1b>
        return 0;
  105251:	b8 00 00 00 00       	mov    $0x0,%eax
  105256:	e9 98 00 00 00       	jmp    1052f3 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10525b:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10525e:	8b 45 10             	mov    0x10(%ebp),%eax
  105261:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105264:	73 18                	jae    10527e <get_pgtable_items+0x3b>
  105266:	8b 45 10             	mov    0x10(%ebp),%eax
  105269:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105270:	8b 45 14             	mov    0x14(%ebp),%eax
  105273:	01 d0                	add    %edx,%eax
  105275:	8b 00                	mov    (%eax),%eax
  105277:	83 e0 01             	and    $0x1,%eax
  10527a:	85 c0                	test   %eax,%eax
  10527c:	74 dd                	je     10525b <get_pgtable_items+0x18>
    }
    if (start < right) {
  10527e:	8b 45 10             	mov    0x10(%ebp),%eax
  105281:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105284:	73 68                	jae    1052ee <get_pgtable_items+0xab>
        if (left_store != NULL) {
  105286:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10528a:	74 08                	je     105294 <get_pgtable_items+0x51>
            *left_store = start;
  10528c:	8b 45 18             	mov    0x18(%ebp),%eax
  10528f:	8b 55 10             	mov    0x10(%ebp),%edx
  105292:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105294:	8b 45 10             	mov    0x10(%ebp),%eax
  105297:	8d 50 01             	lea    0x1(%eax),%edx
  10529a:	89 55 10             	mov    %edx,0x10(%ebp)
  10529d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052a4:	8b 45 14             	mov    0x14(%ebp),%eax
  1052a7:	01 d0                	add    %edx,%eax
  1052a9:	8b 00                	mov    (%eax),%eax
  1052ab:	83 e0 07             	and    $0x7,%eax
  1052ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052b1:	eb 03                	jmp    1052b6 <get_pgtable_items+0x73>
            start ++;
  1052b3:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052bc:	73 1d                	jae    1052db <get_pgtable_items+0x98>
  1052be:	8b 45 10             	mov    0x10(%ebp),%eax
  1052c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1052cb:	01 d0                	add    %edx,%eax
  1052cd:	8b 00                	mov    (%eax),%eax
  1052cf:	83 e0 07             	and    $0x7,%eax
  1052d2:	89 c2                	mov    %eax,%edx
  1052d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052d7:	39 c2                	cmp    %eax,%edx
  1052d9:	74 d8                	je     1052b3 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1052db:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052df:	74 08                	je     1052e9 <get_pgtable_items+0xa6>
            *right_store = start;
  1052e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052e4:	8b 55 10             	mov    0x10(%ebp),%edx
  1052e7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052ec:	eb 05                	jmp    1052f3 <get_pgtable_items+0xb0>
    }
    return 0;
  1052ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052f3:	89 ec                	mov    %ebp,%esp
  1052f5:	5d                   	pop    %ebp
  1052f6:	c3                   	ret    

001052f7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052f7:	55                   	push   %ebp
  1052f8:	89 e5                	mov    %esp,%ebp
  1052fa:	57                   	push   %edi
  1052fb:	56                   	push   %esi
  1052fc:	53                   	push   %ebx
  1052fd:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105300:	c7 04 24 54 70 10 00 	movl   $0x107054,(%esp)
  105307:	e8 59 b0 ff ff       	call   100365 <cprintf>
    size_t left, right = 0, perm;
  10530c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105313:	e9 f2 00 00 00       	jmp    10540a <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10531b:	89 04 24             	mov    %eax,(%esp)
  10531e:	e8 de fe ff ff       	call   105201 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105323:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105326:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105329:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10532b:	89 d6                	mov    %edx,%esi
  10532d:	c1 e6 16             	shl    $0x16,%esi
  105330:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105333:	89 d3                	mov    %edx,%ebx
  105335:	c1 e3 16             	shl    $0x16,%ebx
  105338:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10533b:	89 d1                	mov    %edx,%ecx
  10533d:	c1 e1 16             	shl    $0x16,%ecx
  105340:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105343:	8b 7d e0             	mov    -0x20(%ebp),%edi
  105346:	29 fa                	sub    %edi,%edx
  105348:	89 44 24 14          	mov    %eax,0x14(%esp)
  10534c:	89 74 24 10          	mov    %esi,0x10(%esp)
  105350:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105354:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105358:	89 54 24 04          	mov    %edx,0x4(%esp)
  10535c:	c7 04 24 85 70 10 00 	movl   $0x107085,(%esp)
  105363:	e8 fd af ff ff       	call   100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
  105368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10536b:	c1 e0 0a             	shl    $0xa,%eax
  10536e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105371:	eb 50                	jmp    1053c3 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105376:	89 04 24             	mov    %eax,(%esp)
  105379:	e8 83 fe ff ff       	call   105201 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10537e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105381:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105384:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105386:	89 d6                	mov    %edx,%esi
  105388:	c1 e6 0c             	shl    $0xc,%esi
  10538b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10538e:	89 d3                	mov    %edx,%ebx
  105390:	c1 e3 0c             	shl    $0xc,%ebx
  105393:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105396:	89 d1                	mov    %edx,%ecx
  105398:	c1 e1 0c             	shl    $0xc,%ecx
  10539b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10539e:	8b 7d d8             	mov    -0x28(%ebp),%edi
  1053a1:	29 fa                	sub    %edi,%edx
  1053a3:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053a7:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053b7:	c7 04 24 a4 70 10 00 	movl   $0x1070a4,(%esp)
  1053be:	e8 a2 af ff ff       	call   100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053c3:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1053c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053ce:	89 d3                	mov    %edx,%ebx
  1053d0:	c1 e3 0a             	shl    $0xa,%ebx
  1053d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053d6:	89 d1                	mov    %edx,%ecx
  1053d8:	c1 e1 0a             	shl    $0xa,%ecx
  1053db:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1053de:	89 54 24 14          	mov    %edx,0x14(%esp)
  1053e2:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1053e5:	89 54 24 10          	mov    %edx,0x10(%esp)
  1053e9:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1053ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053f5:	89 0c 24             	mov    %ecx,(%esp)
  1053f8:	e8 46 fe ff ff       	call   105243 <get_pgtable_items>
  1053fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105400:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105404:	0f 85 69 ff ff ff    	jne    105373 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10540a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10540f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105412:	8d 55 dc             	lea    -0x24(%ebp),%edx
  105415:	89 54 24 14          	mov    %edx,0x14(%esp)
  105419:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10541c:	89 54 24 10          	mov    %edx,0x10(%esp)
  105420:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105424:	89 44 24 08          	mov    %eax,0x8(%esp)
  105428:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10542f:	00 
  105430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105437:	e8 07 fe ff ff       	call   105243 <get_pgtable_items>
  10543c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10543f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105443:	0f 85 cf fe ff ff    	jne    105318 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105449:	c7 04 24 c8 70 10 00 	movl   $0x1070c8,(%esp)
  105450:	e8 10 af ff ff       	call   100365 <cprintf>
}
  105455:	90                   	nop
  105456:	83 c4 4c             	add    $0x4c,%esp
  105459:	5b                   	pop    %ebx
  10545a:	5e                   	pop    %esi
  10545b:	5f                   	pop    %edi
  10545c:	5d                   	pop    %ebp
  10545d:	c3                   	ret    

0010545e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10545e:	55                   	push   %ebp
  10545f:	89 e5                	mov    %esp,%ebp
  105461:	83 ec 58             	sub    $0x58,%esp
  105464:	8b 45 10             	mov    0x10(%ebp),%eax
  105467:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10546a:	8b 45 14             	mov    0x14(%ebp),%eax
  10546d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105470:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105473:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105476:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105479:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10547c:	8b 45 18             	mov    0x18(%ebp),%eax
  10547f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105485:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105488:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10548b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10548e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105491:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105498:	74 1c                	je     1054b6 <printnum+0x58>
  10549a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10549d:	ba 00 00 00 00       	mov    $0x0,%edx
  1054a2:	f7 75 e4             	divl   -0x1c(%ebp)
  1054a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1054b0:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054bc:	f7 75 e4             	divl   -0x1c(%ebp)
  1054bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054d4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054d7:	8b 45 18             	mov    0x18(%ebp),%eax
  1054da:	ba 00 00 00 00       	mov    $0x0,%edx
  1054df:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1054e2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1054e5:	19 d1                	sbb    %edx,%ecx
  1054e7:	72 4c                	jb     105535 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054ef:	8b 45 20             	mov    0x20(%ebp),%eax
  1054f2:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054f6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054fa:	8b 45 18             	mov    0x18(%ebp),%eax
  1054fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  105501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105507:	89 44 24 08          	mov    %eax,0x8(%esp)
  10550b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10550f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105512:	89 44 24 04          	mov    %eax,0x4(%esp)
  105516:	8b 45 08             	mov    0x8(%ebp),%eax
  105519:	89 04 24             	mov    %eax,(%esp)
  10551c:	e8 3d ff ff ff       	call   10545e <printnum>
  105521:	eb 1b                	jmp    10553e <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105523:	8b 45 0c             	mov    0xc(%ebp),%eax
  105526:	89 44 24 04          	mov    %eax,0x4(%esp)
  10552a:	8b 45 20             	mov    0x20(%ebp),%eax
  10552d:	89 04 24             	mov    %eax,(%esp)
  105530:	8b 45 08             	mov    0x8(%ebp),%eax
  105533:	ff d0                	call   *%eax
        while (-- width > 0)
  105535:	ff 4d 1c             	decl   0x1c(%ebp)
  105538:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10553c:	7f e5                	jg     105523 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10553e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105541:	05 7c 71 10 00       	add    $0x10717c,%eax
  105546:	0f b6 00             	movzbl (%eax),%eax
  105549:	0f be c0             	movsbl %al,%eax
  10554c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10554f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105553:	89 04 24             	mov    %eax,(%esp)
  105556:	8b 45 08             	mov    0x8(%ebp),%eax
  105559:	ff d0                	call   *%eax
}
  10555b:	90                   	nop
  10555c:	89 ec                	mov    %ebp,%esp
  10555e:	5d                   	pop    %ebp
  10555f:	c3                   	ret    

00105560 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105560:	55                   	push   %ebp
  105561:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105567:	7e 14                	jle    10557d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105569:	8b 45 08             	mov    0x8(%ebp),%eax
  10556c:	8b 00                	mov    (%eax),%eax
  10556e:	8d 48 08             	lea    0x8(%eax),%ecx
  105571:	8b 55 08             	mov    0x8(%ebp),%edx
  105574:	89 0a                	mov    %ecx,(%edx)
  105576:	8b 50 04             	mov    0x4(%eax),%edx
  105579:	8b 00                	mov    (%eax),%eax
  10557b:	eb 30                	jmp    1055ad <getuint+0x4d>
    }
    else if (lflag) {
  10557d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105581:	74 16                	je     105599 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105583:	8b 45 08             	mov    0x8(%ebp),%eax
  105586:	8b 00                	mov    (%eax),%eax
  105588:	8d 48 04             	lea    0x4(%eax),%ecx
  10558b:	8b 55 08             	mov    0x8(%ebp),%edx
  10558e:	89 0a                	mov    %ecx,(%edx)
  105590:	8b 00                	mov    (%eax),%eax
  105592:	ba 00 00 00 00       	mov    $0x0,%edx
  105597:	eb 14                	jmp    1055ad <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105599:	8b 45 08             	mov    0x8(%ebp),%eax
  10559c:	8b 00                	mov    (%eax),%eax
  10559e:	8d 48 04             	lea    0x4(%eax),%ecx
  1055a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055a4:	89 0a                	mov    %ecx,(%edx)
  1055a6:	8b 00                	mov    (%eax),%eax
  1055a8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055ad:	5d                   	pop    %ebp
  1055ae:	c3                   	ret    

001055af <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055af:	55                   	push   %ebp
  1055b0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055b6:	7e 14                	jle    1055cc <getint+0x1d>
        return va_arg(*ap, long long);
  1055b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1055bb:	8b 00                	mov    (%eax),%eax
  1055bd:	8d 48 08             	lea    0x8(%eax),%ecx
  1055c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c3:	89 0a                	mov    %ecx,(%edx)
  1055c5:	8b 50 04             	mov    0x4(%eax),%edx
  1055c8:	8b 00                	mov    (%eax),%eax
  1055ca:	eb 28                	jmp    1055f4 <getint+0x45>
    }
    else if (lflag) {
  1055cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055d0:	74 12                	je     1055e4 <getint+0x35>
        return va_arg(*ap, long);
  1055d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d5:	8b 00                	mov    (%eax),%eax
  1055d7:	8d 48 04             	lea    0x4(%eax),%ecx
  1055da:	8b 55 08             	mov    0x8(%ebp),%edx
  1055dd:	89 0a                	mov    %ecx,(%edx)
  1055df:	8b 00                	mov    (%eax),%eax
  1055e1:	99                   	cltd   
  1055e2:	eb 10                	jmp    1055f4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e7:	8b 00                	mov    (%eax),%eax
  1055e9:	8d 48 04             	lea    0x4(%eax),%ecx
  1055ec:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ef:	89 0a                	mov    %ecx,(%edx)
  1055f1:	8b 00                	mov    (%eax),%eax
  1055f3:	99                   	cltd   
    }
}
  1055f4:	5d                   	pop    %ebp
  1055f5:	c3                   	ret    

001055f6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055f6:	55                   	push   %ebp
  1055f7:	89 e5                	mov    %esp,%ebp
  1055f9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055fc:	8d 45 14             	lea    0x14(%ebp),%eax
  1055ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105605:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105609:	8b 45 10             	mov    0x10(%ebp),%eax
  10560c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105610:	8b 45 0c             	mov    0xc(%ebp),%eax
  105613:	89 44 24 04          	mov    %eax,0x4(%esp)
  105617:	8b 45 08             	mov    0x8(%ebp),%eax
  10561a:	89 04 24             	mov    %eax,(%esp)
  10561d:	e8 05 00 00 00       	call   105627 <vprintfmt>
    va_end(ap);
}
  105622:	90                   	nop
  105623:	89 ec                	mov    %ebp,%esp
  105625:	5d                   	pop    %ebp
  105626:	c3                   	ret    

00105627 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105627:	55                   	push   %ebp
  105628:	89 e5                	mov    %esp,%ebp
  10562a:	56                   	push   %esi
  10562b:	53                   	push   %ebx
  10562c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10562f:	eb 17                	jmp    105648 <vprintfmt+0x21>
            if (ch == '\0') {
  105631:	85 db                	test   %ebx,%ebx
  105633:	0f 84 bf 03 00 00    	je     1059f8 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105640:	89 1c 24             	mov    %ebx,(%esp)
  105643:	8b 45 08             	mov    0x8(%ebp),%eax
  105646:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105648:	8b 45 10             	mov    0x10(%ebp),%eax
  10564b:	8d 50 01             	lea    0x1(%eax),%edx
  10564e:	89 55 10             	mov    %edx,0x10(%ebp)
  105651:	0f b6 00             	movzbl (%eax),%eax
  105654:	0f b6 d8             	movzbl %al,%ebx
  105657:	83 fb 25             	cmp    $0x25,%ebx
  10565a:	75 d5                	jne    105631 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10565c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105660:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10566a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10566d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105677:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10567a:	8b 45 10             	mov    0x10(%ebp),%eax
  10567d:	8d 50 01             	lea    0x1(%eax),%edx
  105680:	89 55 10             	mov    %edx,0x10(%ebp)
  105683:	0f b6 00             	movzbl (%eax),%eax
  105686:	0f b6 d8             	movzbl %al,%ebx
  105689:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10568c:	83 f8 55             	cmp    $0x55,%eax
  10568f:	0f 87 37 03 00 00    	ja     1059cc <vprintfmt+0x3a5>
  105695:	8b 04 85 a0 71 10 00 	mov    0x1071a0(,%eax,4),%eax
  10569c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10569e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056a2:	eb d6                	jmp    10567a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056a8:	eb d0                	jmp    10567a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056b4:	89 d0                	mov    %edx,%eax
  1056b6:	c1 e0 02             	shl    $0x2,%eax
  1056b9:	01 d0                	add    %edx,%eax
  1056bb:	01 c0                	add    %eax,%eax
  1056bd:	01 d8                	add    %ebx,%eax
  1056bf:	83 e8 30             	sub    $0x30,%eax
  1056c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c8:	0f b6 00             	movzbl (%eax),%eax
  1056cb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056ce:	83 fb 2f             	cmp    $0x2f,%ebx
  1056d1:	7e 38                	jle    10570b <vprintfmt+0xe4>
  1056d3:	83 fb 39             	cmp    $0x39,%ebx
  1056d6:	7f 33                	jg     10570b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1056d8:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1056db:	eb d4                	jmp    1056b1 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1056dd:	8b 45 14             	mov    0x14(%ebp),%eax
  1056e0:	8d 50 04             	lea    0x4(%eax),%edx
  1056e3:	89 55 14             	mov    %edx,0x14(%ebp)
  1056e6:	8b 00                	mov    (%eax),%eax
  1056e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056eb:	eb 1f                	jmp    10570c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1056ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056f1:	79 87                	jns    10567a <vprintfmt+0x53>
                width = 0;
  1056f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056fa:	e9 7b ff ff ff       	jmp    10567a <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1056ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105706:	e9 6f ff ff ff       	jmp    10567a <vprintfmt+0x53>
            goto process_precision;
  10570b:	90                   	nop

        process_precision:
            if (width < 0)
  10570c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105710:	0f 89 64 ff ff ff    	jns    10567a <vprintfmt+0x53>
                width = precision, precision = -1;
  105716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105719:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10571c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105723:	e9 52 ff ff ff       	jmp    10567a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105728:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10572b:	e9 4a ff ff ff       	jmp    10567a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105730:	8b 45 14             	mov    0x14(%ebp),%eax
  105733:	8d 50 04             	lea    0x4(%eax),%edx
  105736:	89 55 14             	mov    %edx,0x14(%ebp)
  105739:	8b 00                	mov    (%eax),%eax
  10573b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10573e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105742:	89 04 24             	mov    %eax,(%esp)
  105745:	8b 45 08             	mov    0x8(%ebp),%eax
  105748:	ff d0                	call   *%eax
            break;
  10574a:	e9 a4 02 00 00       	jmp    1059f3 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10574f:	8b 45 14             	mov    0x14(%ebp),%eax
  105752:	8d 50 04             	lea    0x4(%eax),%edx
  105755:	89 55 14             	mov    %edx,0x14(%ebp)
  105758:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10575a:	85 db                	test   %ebx,%ebx
  10575c:	79 02                	jns    105760 <vprintfmt+0x139>
                err = -err;
  10575e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105760:	83 fb 06             	cmp    $0x6,%ebx
  105763:	7f 0b                	jg     105770 <vprintfmt+0x149>
  105765:	8b 34 9d 60 71 10 00 	mov    0x107160(,%ebx,4),%esi
  10576c:	85 f6                	test   %esi,%esi
  10576e:	75 23                	jne    105793 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105770:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105774:	c7 44 24 08 8d 71 10 	movl   $0x10718d,0x8(%esp)
  10577b:	00 
  10577c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105783:	8b 45 08             	mov    0x8(%ebp),%eax
  105786:	89 04 24             	mov    %eax,(%esp)
  105789:	e8 68 fe ff ff       	call   1055f6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10578e:	e9 60 02 00 00       	jmp    1059f3 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105793:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105797:	c7 44 24 08 96 71 10 	movl   $0x107196,0x8(%esp)
  10579e:	00 
  10579f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a9:	89 04 24             	mov    %eax,(%esp)
  1057ac:	e8 45 fe ff ff       	call   1055f6 <printfmt>
            break;
  1057b1:	e9 3d 02 00 00       	jmp    1059f3 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057b6:	8b 45 14             	mov    0x14(%ebp),%eax
  1057b9:	8d 50 04             	lea    0x4(%eax),%edx
  1057bc:	89 55 14             	mov    %edx,0x14(%ebp)
  1057bf:	8b 30                	mov    (%eax),%esi
  1057c1:	85 f6                	test   %esi,%esi
  1057c3:	75 05                	jne    1057ca <vprintfmt+0x1a3>
                p = "(null)";
  1057c5:	be 99 71 10 00       	mov    $0x107199,%esi
            }
            if (width > 0 && padc != '-') {
  1057ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057ce:	7e 76                	jle    105846 <vprintfmt+0x21f>
  1057d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057d4:	74 70                	je     105846 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057dd:	89 34 24             	mov    %esi,(%esp)
  1057e0:	e8 16 03 00 00       	call   105afb <strnlen>
  1057e5:	89 c2                	mov    %eax,%edx
  1057e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057ea:	29 d0                	sub    %edx,%eax
  1057ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057ef:	eb 16                	jmp    105807 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1057f1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057fc:	89 04 24             	mov    %eax,(%esp)
  1057ff:	8b 45 08             	mov    0x8(%ebp),%eax
  105802:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105804:	ff 4d e8             	decl   -0x18(%ebp)
  105807:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10580b:	7f e4                	jg     1057f1 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10580d:	eb 37                	jmp    105846 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10580f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105813:	74 1f                	je     105834 <vprintfmt+0x20d>
  105815:	83 fb 1f             	cmp    $0x1f,%ebx
  105818:	7e 05                	jle    10581f <vprintfmt+0x1f8>
  10581a:	83 fb 7e             	cmp    $0x7e,%ebx
  10581d:	7e 15                	jle    105834 <vprintfmt+0x20d>
                    putch('?', putdat);
  10581f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105822:	89 44 24 04          	mov    %eax,0x4(%esp)
  105826:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10582d:	8b 45 08             	mov    0x8(%ebp),%eax
  105830:	ff d0                	call   *%eax
  105832:	eb 0f                	jmp    105843 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105834:	8b 45 0c             	mov    0xc(%ebp),%eax
  105837:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583b:	89 1c 24             	mov    %ebx,(%esp)
  10583e:	8b 45 08             	mov    0x8(%ebp),%eax
  105841:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105843:	ff 4d e8             	decl   -0x18(%ebp)
  105846:	89 f0                	mov    %esi,%eax
  105848:	8d 70 01             	lea    0x1(%eax),%esi
  10584b:	0f b6 00             	movzbl (%eax),%eax
  10584e:	0f be d8             	movsbl %al,%ebx
  105851:	85 db                	test   %ebx,%ebx
  105853:	74 27                	je     10587c <vprintfmt+0x255>
  105855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105859:	78 b4                	js     10580f <vprintfmt+0x1e8>
  10585b:	ff 4d e4             	decl   -0x1c(%ebp)
  10585e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105862:	79 ab                	jns    10580f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105864:	eb 16                	jmp    10587c <vprintfmt+0x255>
                putch(' ', putdat);
  105866:	8b 45 0c             	mov    0xc(%ebp),%eax
  105869:	89 44 24 04          	mov    %eax,0x4(%esp)
  10586d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105874:	8b 45 08             	mov    0x8(%ebp),%eax
  105877:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105879:	ff 4d e8             	decl   -0x18(%ebp)
  10587c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105880:	7f e4                	jg     105866 <vprintfmt+0x23f>
            }
            break;
  105882:	e9 6c 01 00 00       	jmp    1059f3 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10588a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10588e:	8d 45 14             	lea    0x14(%ebp),%eax
  105891:	89 04 24             	mov    %eax,(%esp)
  105894:	e8 16 fd ff ff       	call   1055af <getint>
  105899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10589c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10589f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058a5:	85 d2                	test   %edx,%edx
  1058a7:	79 26                	jns    1058cf <vprintfmt+0x2a8>
                putch('-', putdat);
  1058a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ba:	ff d0                	call   *%eax
                num = -(long long)num;
  1058bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058c2:	f7 d8                	neg    %eax
  1058c4:	83 d2 00             	adc    $0x0,%edx
  1058c7:	f7 da                	neg    %edx
  1058c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058d6:	e9 a8 00 00 00       	jmp    105983 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e2:	8d 45 14             	lea    0x14(%ebp),%eax
  1058e5:	89 04 24             	mov    %eax,(%esp)
  1058e8:	e8 73 fc ff ff       	call   105560 <getuint>
  1058ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058fa:	e9 84 00 00 00       	jmp    105983 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105902:	89 44 24 04          	mov    %eax,0x4(%esp)
  105906:	8d 45 14             	lea    0x14(%ebp),%eax
  105909:	89 04 24             	mov    %eax,(%esp)
  10590c:	e8 4f fc ff ff       	call   105560 <getuint>
  105911:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105914:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105917:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10591e:	eb 63                	jmp    105983 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105920:	8b 45 0c             	mov    0xc(%ebp),%eax
  105923:	89 44 24 04          	mov    %eax,0x4(%esp)
  105927:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10592e:	8b 45 08             	mov    0x8(%ebp),%eax
  105931:	ff d0                	call   *%eax
            putch('x', putdat);
  105933:	8b 45 0c             	mov    0xc(%ebp),%eax
  105936:	89 44 24 04          	mov    %eax,0x4(%esp)
  10593a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105941:	8b 45 08             	mov    0x8(%ebp),%eax
  105944:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105946:	8b 45 14             	mov    0x14(%ebp),%eax
  105949:	8d 50 04             	lea    0x4(%eax),%edx
  10594c:	89 55 14             	mov    %edx,0x14(%ebp)
  10594f:	8b 00                	mov    (%eax),%eax
  105951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10595b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105962:	eb 1f                	jmp    105983 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596b:	8d 45 14             	lea    0x14(%ebp),%eax
  10596e:	89 04 24             	mov    %eax,(%esp)
  105971:	e8 ea fb ff ff       	call   105560 <getuint>
  105976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105979:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10597c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105983:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10598a:	89 54 24 18          	mov    %edx,0x18(%esp)
  10598e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105991:	89 54 24 14          	mov    %edx,0x14(%esp)
  105995:	89 44 24 10          	mov    %eax,0x10(%esp)
  105999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10599c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10599f:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b1:	89 04 24             	mov    %eax,(%esp)
  1059b4:	e8 a5 fa ff ff       	call   10545e <printnum>
            break;
  1059b9:	eb 38                	jmp    1059f3 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c2:	89 1c 24             	mov    %ebx,(%esp)
  1059c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c8:	ff d0                	call   *%eax
            break;
  1059ca:	eb 27                	jmp    1059f3 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059da:	8b 45 08             	mov    0x8(%ebp),%eax
  1059dd:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059df:	ff 4d 10             	decl   0x10(%ebp)
  1059e2:	eb 03                	jmp    1059e7 <vprintfmt+0x3c0>
  1059e4:	ff 4d 10             	decl   0x10(%ebp)
  1059e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1059ea:	48                   	dec    %eax
  1059eb:	0f b6 00             	movzbl (%eax),%eax
  1059ee:	3c 25                	cmp    $0x25,%al
  1059f0:	75 f2                	jne    1059e4 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1059f2:	90                   	nop
    while (1) {
  1059f3:	e9 37 fc ff ff       	jmp    10562f <vprintfmt+0x8>
                return;
  1059f8:	90                   	nop
        }
    }
}
  1059f9:	83 c4 40             	add    $0x40,%esp
  1059fc:	5b                   	pop    %ebx
  1059fd:	5e                   	pop    %esi
  1059fe:	5d                   	pop    %ebp
  1059ff:	c3                   	ret    

00105a00 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a00:	55                   	push   %ebp
  105a01:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a06:	8b 40 08             	mov    0x8(%eax),%eax
  105a09:	8d 50 01             	lea    0x1(%eax),%edx
  105a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a15:	8b 10                	mov    (%eax),%edx
  105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1a:	8b 40 04             	mov    0x4(%eax),%eax
  105a1d:	39 c2                	cmp    %eax,%edx
  105a1f:	73 12                	jae    105a33 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a24:	8b 00                	mov    (%eax),%eax
  105a26:	8d 48 01             	lea    0x1(%eax),%ecx
  105a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a2c:	89 0a                	mov    %ecx,(%edx)
  105a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  105a31:	88 10                	mov    %dl,(%eax)
    }
}
  105a33:	90                   	nop
  105a34:	5d                   	pop    %ebp
  105a35:	c3                   	ret    

00105a36 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a36:	55                   	push   %ebp
  105a37:	89 e5                	mov    %esp,%ebp
  105a39:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a3c:	8d 45 14             	lea    0x14(%ebp),%eax
  105a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a49:	8b 45 10             	mov    0x10(%ebp),%eax
  105a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a57:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5a:	89 04 24             	mov    %eax,(%esp)
  105a5d:	e8 0a 00 00 00       	call   105a6c <vsnprintf>
  105a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a68:	89 ec                	mov    %ebp,%esp
  105a6a:	5d                   	pop    %ebp
  105a6b:	c3                   	ret    

00105a6c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a6c:	55                   	push   %ebp
  105a6d:	89 e5                	mov    %esp,%ebp
  105a6f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a72:	8b 45 08             	mov    0x8(%ebp),%eax
  105a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a81:	01 d0                	add    %edx,%eax
  105a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a91:	74 0a                	je     105a9d <vsnprintf+0x31>
  105a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a99:	39 c2                	cmp    %eax,%edx
  105a9b:	76 07                	jbe    105aa4 <vsnprintf+0x38>
        return -E_INVAL;
  105a9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105aa2:	eb 2a                	jmp    105ace <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  105aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105aab:	8b 45 10             	mov    0x10(%ebp),%eax
  105aae:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ab2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab9:	c7 04 24 00 5a 10 00 	movl   $0x105a00,(%esp)
  105ac0:	e8 62 fb ff ff       	call   105627 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ac8:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ace:	89 ec                	mov    %ebp,%esp
  105ad0:	5d                   	pop    %ebp
  105ad1:	c3                   	ret    

00105ad2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105ad2:	55                   	push   %ebp
  105ad3:	89 e5                	mov    %esp,%ebp
  105ad5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105adf:	eb 03                	jmp    105ae4 <strlen+0x12>
        cnt ++;
  105ae1:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae7:	8d 50 01             	lea    0x1(%eax),%edx
  105aea:	89 55 08             	mov    %edx,0x8(%ebp)
  105aed:	0f b6 00             	movzbl (%eax),%eax
  105af0:	84 c0                	test   %al,%al
  105af2:	75 ed                	jne    105ae1 <strlen+0xf>
    }
    return cnt;
  105af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105af7:	89 ec                	mov    %ebp,%esp
  105af9:	5d                   	pop    %ebp
  105afa:	c3                   	ret    

00105afb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105afb:	55                   	push   %ebp
  105afc:	89 e5                	mov    %esp,%ebp
  105afe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b08:	eb 03                	jmp    105b0d <strnlen+0x12>
        cnt ++;
  105b0a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b13:	73 10                	jae    105b25 <strnlen+0x2a>
  105b15:	8b 45 08             	mov    0x8(%ebp),%eax
  105b18:	8d 50 01             	lea    0x1(%eax),%edx
  105b1b:	89 55 08             	mov    %edx,0x8(%ebp)
  105b1e:	0f b6 00             	movzbl (%eax),%eax
  105b21:	84 c0                	test   %al,%al
  105b23:	75 e5                	jne    105b0a <strnlen+0xf>
    }
    return cnt;
  105b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b28:	89 ec                	mov    %ebp,%esp
  105b2a:	5d                   	pop    %ebp
  105b2b:	c3                   	ret    

00105b2c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b2c:	55                   	push   %ebp
  105b2d:	89 e5                	mov    %esp,%ebp
  105b2f:	57                   	push   %edi
  105b30:	56                   	push   %esi
  105b31:	83 ec 20             	sub    $0x20,%esp
  105b34:	8b 45 08             	mov    0x8(%ebp),%eax
  105b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b46:	89 d1                	mov    %edx,%ecx
  105b48:	89 c2                	mov    %eax,%edx
  105b4a:	89 ce                	mov    %ecx,%esi
  105b4c:	89 d7                	mov    %edx,%edi
  105b4e:	ac                   	lods   %ds:(%esi),%al
  105b4f:	aa                   	stos   %al,%es:(%edi)
  105b50:	84 c0                	test   %al,%al
  105b52:	75 fa                	jne    105b4e <strcpy+0x22>
  105b54:	89 fa                	mov    %edi,%edx
  105b56:	89 f1                	mov    %esi,%ecx
  105b58:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b5b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b64:	83 c4 20             	add    $0x20,%esp
  105b67:	5e                   	pop    %esi
  105b68:	5f                   	pop    %edi
  105b69:	5d                   	pop    %ebp
  105b6a:	c3                   	ret    

00105b6b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b6b:	55                   	push   %ebp
  105b6c:	89 e5                	mov    %esp,%ebp
  105b6e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b71:	8b 45 08             	mov    0x8(%ebp),%eax
  105b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b77:	eb 1e                	jmp    105b97 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7c:	0f b6 10             	movzbl (%eax),%edx
  105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b82:	88 10                	mov    %dl,(%eax)
  105b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b87:	0f b6 00             	movzbl (%eax),%eax
  105b8a:	84 c0                	test   %al,%al
  105b8c:	74 03                	je     105b91 <strncpy+0x26>
            src ++;
  105b8e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105b91:	ff 45 fc             	incl   -0x4(%ebp)
  105b94:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105b97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b9b:	75 dc                	jne    105b79 <strncpy+0xe>
    }
    return dst;
  105b9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ba0:	89 ec                	mov    %ebp,%esp
  105ba2:	5d                   	pop    %ebp
  105ba3:	c3                   	ret    

00105ba4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105ba4:	55                   	push   %ebp
  105ba5:	89 e5                	mov    %esp,%ebp
  105ba7:	57                   	push   %edi
  105ba8:	56                   	push   %esi
  105ba9:	83 ec 20             	sub    $0x20,%esp
  105bac:	8b 45 08             	mov    0x8(%ebp),%eax
  105baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bbe:	89 d1                	mov    %edx,%ecx
  105bc0:	89 c2                	mov    %eax,%edx
  105bc2:	89 ce                	mov    %ecx,%esi
  105bc4:	89 d7                	mov    %edx,%edi
  105bc6:	ac                   	lods   %ds:(%esi),%al
  105bc7:	ae                   	scas   %es:(%edi),%al
  105bc8:	75 08                	jne    105bd2 <strcmp+0x2e>
  105bca:	84 c0                	test   %al,%al
  105bcc:	75 f8                	jne    105bc6 <strcmp+0x22>
  105bce:	31 c0                	xor    %eax,%eax
  105bd0:	eb 04                	jmp    105bd6 <strcmp+0x32>
  105bd2:	19 c0                	sbb    %eax,%eax
  105bd4:	0c 01                	or     $0x1,%al
  105bd6:	89 fa                	mov    %edi,%edx
  105bd8:	89 f1                	mov    %esi,%ecx
  105bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bdd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105be0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105be6:	83 c4 20             	add    $0x20,%esp
  105be9:	5e                   	pop    %esi
  105bea:	5f                   	pop    %edi
  105beb:	5d                   	pop    %ebp
  105bec:	c3                   	ret    

00105bed <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bed:	55                   	push   %ebp
  105bee:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bf0:	eb 09                	jmp    105bfb <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105bf2:	ff 4d 10             	decl   0x10(%ebp)
  105bf5:	ff 45 08             	incl   0x8(%ebp)
  105bf8:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bff:	74 1a                	je     105c1b <strncmp+0x2e>
  105c01:	8b 45 08             	mov    0x8(%ebp),%eax
  105c04:	0f b6 00             	movzbl (%eax),%eax
  105c07:	84 c0                	test   %al,%al
  105c09:	74 10                	je     105c1b <strncmp+0x2e>
  105c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0e:	0f b6 10             	movzbl (%eax),%edx
  105c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c14:	0f b6 00             	movzbl (%eax),%eax
  105c17:	38 c2                	cmp    %al,%dl
  105c19:	74 d7                	je     105bf2 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c1f:	74 18                	je     105c39 <strncmp+0x4c>
  105c21:	8b 45 08             	mov    0x8(%ebp),%eax
  105c24:	0f b6 00             	movzbl (%eax),%eax
  105c27:	0f b6 d0             	movzbl %al,%edx
  105c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c2d:	0f b6 00             	movzbl (%eax),%eax
  105c30:	0f b6 c8             	movzbl %al,%ecx
  105c33:	89 d0                	mov    %edx,%eax
  105c35:	29 c8                	sub    %ecx,%eax
  105c37:	eb 05                	jmp    105c3e <strncmp+0x51>
  105c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c3e:	5d                   	pop    %ebp
  105c3f:	c3                   	ret    

00105c40 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c40:	55                   	push   %ebp
  105c41:	89 e5                	mov    %esp,%ebp
  105c43:	83 ec 04             	sub    $0x4,%esp
  105c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c49:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c4c:	eb 13                	jmp    105c61 <strchr+0x21>
        if (*s == c) {
  105c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c51:	0f b6 00             	movzbl (%eax),%eax
  105c54:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c57:	75 05                	jne    105c5e <strchr+0x1e>
            return (char *)s;
  105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5c:	eb 12                	jmp    105c70 <strchr+0x30>
        }
        s ++;
  105c5e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105c61:	8b 45 08             	mov    0x8(%ebp),%eax
  105c64:	0f b6 00             	movzbl (%eax),%eax
  105c67:	84 c0                	test   %al,%al
  105c69:	75 e3                	jne    105c4e <strchr+0xe>
    }
    return NULL;
  105c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c70:	89 ec                	mov    %ebp,%esp
  105c72:	5d                   	pop    %ebp
  105c73:	c3                   	ret    

00105c74 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c74:	55                   	push   %ebp
  105c75:	89 e5                	mov    %esp,%ebp
  105c77:	83 ec 04             	sub    $0x4,%esp
  105c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c7d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c80:	eb 0e                	jmp    105c90 <strfind+0x1c>
        if (*s == c) {
  105c82:	8b 45 08             	mov    0x8(%ebp),%eax
  105c85:	0f b6 00             	movzbl (%eax),%eax
  105c88:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c8b:	74 0f                	je     105c9c <strfind+0x28>
            break;
        }
        s ++;
  105c8d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105c90:	8b 45 08             	mov    0x8(%ebp),%eax
  105c93:	0f b6 00             	movzbl (%eax),%eax
  105c96:	84 c0                	test   %al,%al
  105c98:	75 e8                	jne    105c82 <strfind+0xe>
  105c9a:	eb 01                	jmp    105c9d <strfind+0x29>
            break;
  105c9c:	90                   	nop
    }
    return (char *)s;
  105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ca0:	89 ec                	mov    %ebp,%esp
  105ca2:	5d                   	pop    %ebp
  105ca3:	c3                   	ret    

00105ca4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ca4:	55                   	push   %ebp
  105ca5:	89 e5                	mov    %esp,%ebp
  105ca7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cb8:	eb 03                	jmp    105cbd <strtol+0x19>
        s ++;
  105cba:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc0:	0f b6 00             	movzbl (%eax),%eax
  105cc3:	3c 20                	cmp    $0x20,%al
  105cc5:	74 f3                	je     105cba <strtol+0x16>
  105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cca:	0f b6 00             	movzbl (%eax),%eax
  105ccd:	3c 09                	cmp    $0x9,%al
  105ccf:	74 e9                	je     105cba <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd4:	0f b6 00             	movzbl (%eax),%eax
  105cd7:	3c 2b                	cmp    $0x2b,%al
  105cd9:	75 05                	jne    105ce0 <strtol+0x3c>
        s ++;
  105cdb:	ff 45 08             	incl   0x8(%ebp)
  105cde:	eb 14                	jmp    105cf4 <strtol+0x50>
    }
    else if (*s == '-') {
  105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce3:	0f b6 00             	movzbl (%eax),%eax
  105ce6:	3c 2d                	cmp    $0x2d,%al
  105ce8:	75 0a                	jne    105cf4 <strtol+0x50>
        s ++, neg = 1;
  105cea:	ff 45 08             	incl   0x8(%ebp)
  105ced:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cf8:	74 06                	je     105d00 <strtol+0x5c>
  105cfa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cfe:	75 22                	jne    105d22 <strtol+0x7e>
  105d00:	8b 45 08             	mov    0x8(%ebp),%eax
  105d03:	0f b6 00             	movzbl (%eax),%eax
  105d06:	3c 30                	cmp    $0x30,%al
  105d08:	75 18                	jne    105d22 <strtol+0x7e>
  105d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0d:	40                   	inc    %eax
  105d0e:	0f b6 00             	movzbl (%eax),%eax
  105d11:	3c 78                	cmp    $0x78,%al
  105d13:	75 0d                	jne    105d22 <strtol+0x7e>
        s += 2, base = 16;
  105d15:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d19:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d20:	eb 29                	jmp    105d4b <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d26:	75 16                	jne    105d3e <strtol+0x9a>
  105d28:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2b:	0f b6 00             	movzbl (%eax),%eax
  105d2e:	3c 30                	cmp    $0x30,%al
  105d30:	75 0c                	jne    105d3e <strtol+0x9a>
        s ++, base = 8;
  105d32:	ff 45 08             	incl   0x8(%ebp)
  105d35:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d3c:	eb 0d                	jmp    105d4b <strtol+0xa7>
    }
    else if (base == 0) {
  105d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d42:	75 07                	jne    105d4b <strtol+0xa7>
        base = 10;
  105d44:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4e:	0f b6 00             	movzbl (%eax),%eax
  105d51:	3c 2f                	cmp    $0x2f,%al
  105d53:	7e 1b                	jle    105d70 <strtol+0xcc>
  105d55:	8b 45 08             	mov    0x8(%ebp),%eax
  105d58:	0f b6 00             	movzbl (%eax),%eax
  105d5b:	3c 39                	cmp    $0x39,%al
  105d5d:	7f 11                	jg     105d70 <strtol+0xcc>
            dig = *s - '0';
  105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d62:	0f b6 00             	movzbl (%eax),%eax
  105d65:	0f be c0             	movsbl %al,%eax
  105d68:	83 e8 30             	sub    $0x30,%eax
  105d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d6e:	eb 48                	jmp    105db8 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d70:	8b 45 08             	mov    0x8(%ebp),%eax
  105d73:	0f b6 00             	movzbl (%eax),%eax
  105d76:	3c 60                	cmp    $0x60,%al
  105d78:	7e 1b                	jle    105d95 <strtol+0xf1>
  105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7d:	0f b6 00             	movzbl (%eax),%eax
  105d80:	3c 7a                	cmp    $0x7a,%al
  105d82:	7f 11                	jg     105d95 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105d84:	8b 45 08             	mov    0x8(%ebp),%eax
  105d87:	0f b6 00             	movzbl (%eax),%eax
  105d8a:	0f be c0             	movsbl %al,%eax
  105d8d:	83 e8 57             	sub    $0x57,%eax
  105d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d93:	eb 23                	jmp    105db8 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d95:	8b 45 08             	mov    0x8(%ebp),%eax
  105d98:	0f b6 00             	movzbl (%eax),%eax
  105d9b:	3c 40                	cmp    $0x40,%al
  105d9d:	7e 3b                	jle    105dda <strtol+0x136>
  105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105da2:	0f b6 00             	movzbl (%eax),%eax
  105da5:	3c 5a                	cmp    $0x5a,%al
  105da7:	7f 31                	jg     105dda <strtol+0x136>
            dig = *s - 'A' + 10;
  105da9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dac:	0f b6 00             	movzbl (%eax),%eax
  105daf:	0f be c0             	movsbl %al,%eax
  105db2:	83 e8 37             	sub    $0x37,%eax
  105db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  105dbe:	7d 19                	jge    105dd9 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105dc0:	ff 45 08             	incl   0x8(%ebp)
  105dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dc6:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dca:	89 c2                	mov    %eax,%edx
  105dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dcf:	01 d0                	add    %edx,%eax
  105dd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105dd4:	e9 72 ff ff ff       	jmp    105d4b <strtol+0xa7>
            break;
  105dd9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dde:	74 08                	je     105de8 <strtol+0x144>
        *endptr = (char *) s;
  105de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de3:	8b 55 08             	mov    0x8(%ebp),%edx
  105de6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105de8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105dec:	74 07                	je     105df5 <strtol+0x151>
  105dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105df1:	f7 d8                	neg    %eax
  105df3:	eb 03                	jmp    105df8 <strtol+0x154>
  105df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105df8:	89 ec                	mov    %ebp,%esp
  105dfa:	5d                   	pop    %ebp
  105dfb:	c3                   	ret    

00105dfc <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105dfc:	55                   	push   %ebp
  105dfd:	89 e5                	mov    %esp,%ebp
  105dff:	83 ec 28             	sub    $0x28,%esp
  105e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e08:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e0b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e12:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105e15:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105e18:	8b 45 10             	mov    0x10(%ebp),%eax
  105e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e21:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e25:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e28:	89 d7                	mov    %edx,%edi
  105e2a:	f3 aa                	rep stos %al,%es:(%edi)
  105e2c:	89 fa                	mov    %edi,%edx
  105e2e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e31:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e37:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e3a:	89 ec                	mov    %ebp,%esp
  105e3c:	5d                   	pop    %ebp
  105e3d:	c3                   	ret    

00105e3e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e3e:	55                   	push   %ebp
  105e3f:	89 e5                	mov    %esp,%ebp
  105e41:	57                   	push   %edi
  105e42:	56                   	push   %esi
  105e43:	53                   	push   %ebx
  105e44:	83 ec 30             	sub    $0x30,%esp
  105e47:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e53:	8b 45 10             	mov    0x10(%ebp),%eax
  105e56:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e5f:	73 42                	jae    105ea3 <memmove+0x65>
  105e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e70:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e76:	c1 e8 02             	shr    $0x2,%eax
  105e79:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105e7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e81:	89 d7                	mov    %edx,%edi
  105e83:	89 c6                	mov    %eax,%esi
  105e85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e87:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e8a:	83 e1 03             	and    $0x3,%ecx
  105e8d:	74 02                	je     105e91 <memmove+0x53>
  105e8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e91:	89 f0                	mov    %esi,%eax
  105e93:	89 fa                	mov    %edi,%edx
  105e95:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105ea1:	eb 36                	jmp    105ed9 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eac:	01 c2                	add    %eax,%edx
  105eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eb7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ebd:	89 c1                	mov    %eax,%ecx
  105ebf:	89 d8                	mov    %ebx,%eax
  105ec1:	89 d6                	mov    %edx,%esi
  105ec3:	89 c7                	mov    %eax,%edi
  105ec5:	fd                   	std    
  105ec6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ec8:	fc                   	cld    
  105ec9:	89 f8                	mov    %edi,%eax
  105ecb:	89 f2                	mov    %esi,%edx
  105ecd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ed0:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ed3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ed9:	83 c4 30             	add    $0x30,%esp
  105edc:	5b                   	pop    %ebx
  105edd:	5e                   	pop    %esi
  105ede:	5f                   	pop    %edi
  105edf:	5d                   	pop    %ebp
  105ee0:	c3                   	ret    

00105ee1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ee1:	55                   	push   %ebp
  105ee2:	89 e5                	mov    %esp,%ebp
  105ee4:	57                   	push   %edi
  105ee5:	56                   	push   %esi
  105ee6:	83 ec 20             	sub    $0x20,%esp
  105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  105eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  105ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105efe:	c1 e8 02             	shr    $0x2,%eax
  105f01:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f09:	89 d7                	mov    %edx,%edi
  105f0b:	89 c6                	mov    %eax,%esi
  105f0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f0f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f12:	83 e1 03             	and    $0x3,%ecx
  105f15:	74 02                	je     105f19 <memcpy+0x38>
  105f17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f19:	89 f0                	mov    %esi,%eax
  105f1b:	89 fa                	mov    %edi,%edx
  105f1d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f23:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f29:	83 c4 20             	add    $0x20,%esp
  105f2c:	5e                   	pop    %esi
  105f2d:	5f                   	pop    %edi
  105f2e:	5d                   	pop    %ebp
  105f2f:	c3                   	ret    

00105f30 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f30:	55                   	push   %ebp
  105f31:	89 e5                	mov    %esp,%ebp
  105f33:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f36:	8b 45 08             	mov    0x8(%ebp),%eax
  105f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f42:	eb 2e                	jmp    105f72 <memcmp+0x42>
        if (*s1 != *s2) {
  105f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f47:	0f b6 10             	movzbl (%eax),%edx
  105f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f4d:	0f b6 00             	movzbl (%eax),%eax
  105f50:	38 c2                	cmp    %al,%dl
  105f52:	74 18                	je     105f6c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f57:	0f b6 00             	movzbl (%eax),%eax
  105f5a:	0f b6 d0             	movzbl %al,%edx
  105f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f60:	0f b6 00             	movzbl (%eax),%eax
  105f63:	0f b6 c8             	movzbl %al,%ecx
  105f66:	89 d0                	mov    %edx,%eax
  105f68:	29 c8                	sub    %ecx,%eax
  105f6a:	eb 18                	jmp    105f84 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105f6c:	ff 45 fc             	incl   -0x4(%ebp)
  105f6f:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105f72:	8b 45 10             	mov    0x10(%ebp),%eax
  105f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f78:	89 55 10             	mov    %edx,0x10(%ebp)
  105f7b:	85 c0                	test   %eax,%eax
  105f7d:	75 c5                	jne    105f44 <memcmp+0x14>
    }
    return 0;
  105f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f84:	89 ec                	mov    %ebp,%esp
  105f86:	5d                   	pop    %ebp
  105f87:	c3                   	ret    
