
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
  100059:	e8 95 5d 00 00       	call   105df3 <memset>

    cons_init(); // init the console
  10005e:	e8 f9 15 00 00       	call   10165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 80 5f 10 00 	movl   $0x105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 9c 5f 10 00 	movl   $0x105f9c,(%esp)
  100078:	e8 e8 02 00 00       	call   100365 <cprintf>

    print_kerninfo();
  10007d:	e8 06 08 00 00       	call   100888 <print_kerninfo>

    grade_backtrace();
  100082:	e8 95 00 00 00       	call   10011c <grade_backtrace>

    pmm_init(); // init physical memory management
  100087:	e8 57 44 00 00       	call   1044e3 <pmm_init>

    pic_init(); // init interrupt controller
  10008c:	e8 4c 17 00 00       	call   1017dd <pic_init>
    idt_init(); // init interrupt descriptor table
  100091:	e8 b0 18 00 00       	call   101946 <idt_init>

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
  10016c:	c7 04 24 a1 5f 10 00 	movl   $0x105fa1,(%esp)
  100173:	e8 ed 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10017c:	89 c2                	mov    %eax,%edx
  10017e:	a1 00 b0 11 00       	mov    0x11b000,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 af 5f 10 00 	movl   $0x105faf,(%esp)
  100192:	e8 ce 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10019b:	89 c2                	mov    %eax,%edx
  10019d:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001aa:	c7 04 24 bd 5f 10 00 	movl   $0x105fbd,(%esp)
  1001b1:	e8 af 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ba:	89 c2                	mov    %eax,%edx
  1001bc:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c9:	c7 04 24 cb 5f 10 00 	movl   $0x105fcb,(%esp)
  1001d0:	e8 90 01 00 00       	call   100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d9:	89 c2                	mov    %eax,%edx
  1001db:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e8:	c7 04 24 d9 5f 10 00 	movl   $0x105fd9,(%esp)
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
  100225:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  10022c:	e8 34 01 00 00       	call   100365 <cprintf>
    lab1_switch_to_user();
  100231:	e8 ce ff ff ff       	call   100204 <lab1_switch_to_user>
    lab1_print_cur_status();
  100236:	e8 09 ff ff ff       	call   100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10023b:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
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
  100269:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
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
  100359:	e8 c0 52 00 00       	call   10561e <vprintfmt>
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
  100569:	c7 00 2c 60 10 00    	movl   $0x10602c,(%eax)
    info->eip_line = 0;
  10056f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 08 2c 60 10 00 	movl   $0x10602c,0x8(%eax)
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
  1005a0:	c7 45 f4 b8 72 10 00 	movl   $0x1072b8,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a7:	c7 45 f0 ec 28 11 00 	movl   $0x1128ec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ae:	c7 45 ec ed 28 11 00 	movl   $0x1128ed,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b5:	c7 45 e8 67 5e 11 00 	movl   $0x115e67,-0x18(%ebp)

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
  100708:	e8 5e 55 00 00       	call   105c6b <strfind>
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
  10088e:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  100895:	e8 cb fa ff ff       	call   100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10089a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1008a1:	00 
  1008a2:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  1008a9:	e8 b7 fa ff ff       	call   100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ae:	c7 44 24 04 7f 5f 10 	movl   $0x105f7f,0x4(%esp)
  1008b5:	00 
  1008b6:	c7 04 24 67 60 10 00 	movl   $0x106067,(%esp)
  1008bd:	e8 a3 fa ff ff       	call   100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008c2:	c7 44 24 04 36 8a 11 	movl   $0x118a36,0x4(%esp)
  1008c9:	00 
  1008ca:	c7 04 24 7f 60 10 00 	movl   $0x10607f,(%esp)
  1008d1:	e8 8f fa ff ff       	call   100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d6:	c7 44 24 04 2c bf 11 	movl   $0x11bf2c,0x4(%esp)
  1008dd:	00 
  1008de:	c7 04 24 97 60 10 00 	movl   $0x106097,(%esp)
  1008e5:	e8 7b fa ff ff       	call   100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
  1008ea:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  1008ef:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ff:	85 c0                	test   %eax,%eax
  100901:	0f 48 c2             	cmovs  %edx,%eax
  100904:	c1 f8 0a             	sar    $0xa,%eax
  100907:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090b:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
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
  100942:	c7 04 24 da 60 10 00 	movl   $0x1060da,(%esp)
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
  1009b0:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
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
  100a07:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
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
  100a3a:	c7 04 24 24 61 10 00 	movl   $0x106124,(%esp)
  100a41:	e8 1f f9 ff ff       	call   100365 <cprintf>
        for (j = 0; j < 4; j++)
  100a46:	ff 45 e8             	incl   -0x18(%ebp)
  100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4d:	7e d6                	jle    100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a4f:	c7 04 24 2c 61 10 00 	movl   $0x10612c,(%esp)
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
  100ac4:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100acb:	e8 67 51 00 00       	call   105c37 <strchr>
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
  100aec:	c7 04 24 b5 61 10 00 	movl   $0x1061b5,(%esp)
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
  100b2e:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100b35:	e8 fd 50 00 00       	call   105c37 <strchr>
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
  100b91:	05 00 80 11 00       	add    $0x118000,%eax
  100b96:	8b 00                	mov    (%eax),%eax
  100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9c:	89 04 24             	mov    %eax,(%esp)
  100b9f:	e8 f7 4f 00 00       	call   105b9b <strcmp>
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	75 31                	jne    100bd9 <runcmd+0x8e>
        {
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
  100beb:	c7 04 24 d3 61 10 00 	movl   $0x1061d3,(%esp)
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
  100c09:	c7 04 24 ec 61 10 00 	movl   $0x1061ec,(%esp)
  100c10:	e8 50 f7 ff ff       	call   100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c15:	c7 04 24 14 62 10 00 	movl   $0x106214,(%esp)
  100c1c:	e8 44 f7 ff ff       	call   100365 <cprintf>

    if (tf != NULL)
  100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c25:	74 0b                	je     100c32 <kmonitor+0x2f>
    {
        print_trapframe(tf);
  100c27:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 ce 0e 00 00       	call   101b00 <print_trapframe>
    }

    char *buf;
    while (1)
    {
        if ((buf = readline("K> ")) != NULL)
  100c32:	c7 04 24 39 62 10 00 	movl   $0x106239,(%esp)
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
  100ca2:	c7 04 24 3d 62 10 00 	movl   $0x10623d,(%esp)
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
  100cf0:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100cf5:	85 c0                	test   %eax,%eax
  100cf7:	75 5b                	jne    100d54 <__panic+0x6a>
    {
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
  100d17:	c7 04 24 46 62 10 00 	movl   $0x106246,(%esp)
  100d1e:	e8 42 f6 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2d:	89 04 24             	mov    %eax,(%esp)
  100d30:	e8 fb f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100d35:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100d3c:	e8 24 f6 ff ff       	call   100365 <cprintf>

    cprintf("stack trackback:\n");
  100d41:	c7 04 24 64 62 10 00 	movl   $0x106264,(%esp)
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
  100d82:	c7 04 24 76 62 10 00 	movl   $0x106276,(%esp)
  100d89:	e8 d7 f5 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d95:	8b 45 10             	mov    0x10(%ebp),%eax
  100d98:	89 04 24             	mov    %eax,(%esp)
  100d9b:	e8 90 f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100da0:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
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
  100db4:	a1 20 b4 11 00       	mov    0x11b420,%eax
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
  100dfd:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e07:	c7 04 24 94 62 10 00 	movl   $0x106294,(%esp)
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
  100ee7:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
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
  100efc:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f05:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
  100f44:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
  101047:	a3 48 b4 11 00       	mov    %eax,0x11b448
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
  10106c:	a1 48 b4 11 00       	mov    0x11b448,%eax
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
  101185:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10118c:	85 c0                	test   %eax,%eax
  10118e:	0f 84 af 00 00 00    	je     101243 <cga_putc+0xfd>
        {
            crt_pos--;
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
        crt_buf[crt_pos++] = c; // write the character
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
    if (crt_pos >= CRT_SIZE)
  101244:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101250:	76 5e                	jbe    1012b0 <cga_putc+0x16a>
    {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101252:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10125d:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101269:	00 
  10126a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10126e:	89 04 24             	mov    %eax,(%esp)
  101271:	e8 bf 4b 00 00       	call   105e35 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10127d:	eb 15                	jmp    101294 <cga_putc+0x14e>
        {
            crt_buf[i] = 0x0700 | ' ';
  10127f:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
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
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
  1012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f3:	ee                   	out    %al,(%dx)
}
  1012f4:	90                   	nop
    outb(addr_6845, 15);
  1012f5:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
  1013e8:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013ed:	8d 50 01             	lea    0x1(%eax),%edx
  1013f0:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  1013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013f9:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE)
  1013ff:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101404:	3d 00 02 00 00       	cmp    $0x200,%eax
  101409:	75 0a                	jne    101415 <cons_intr+0x3b>
            {
                cons.wpos = 0;
  10140b:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
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
  101488:	a1 48 b4 11 00       	mov    0x11b448,%eax
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
  1014eb:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014f0:	83 c8 40             	or     $0x40,%eax
  1014f3:	a3 68 b6 11 00       	mov    %eax,0x11b668
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
    }
    else if (shift & E0ESC)
  10154f:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101554:	83 e0 40             	and    $0x40,%eax
  101557:	85 c0                	test   %eax,%eax
  101559:	74 11                	je     10156c <kbd_proc_data+0xca>
    {
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
    if (shift & CAPSLOCK)
  1015be:	a1 68 b6 11 00       	mov    0x11b668,%eax
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
  1015ec:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015f1:	f7 d0                	not    %eax
  1015f3:	83 e0 06             	and    $0x6,%eax
  1015f6:	85 c0                	test   %eax,%eax
  1015f8:	75 28                	jne    101622 <kbd_proc_data+0x180>
  1015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101601:	75 1f                	jne    101622 <kbd_proc_data+0x180>
    {
        cprintf("Rebooting!\n");
  101603:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
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
  101671:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101676:	85 c0                	test   %eax,%eax
  101678:	75 0c                	jne    101686 <cons_init+0x2a>
    {
        cprintf("serial port does not exist!!\n");
  10167a:	c7 04 24 bb 62 10 00 	movl   $0x1062bb,(%esp)
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
  1016e9:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  1016ef:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1016f4:	39 c2                	cmp    %eax,%edx
  1016f6:	74 31                	je     101729 <cons_getc+0x5f>
        {
            c = cons.buf[cons.rpos++];
  1016f8:	a1 60 b6 11 00       	mov    0x11b660,%eax
  1016fd:	8d 50 01             	lea    0x1(%eax),%edx
  101700:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  101706:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  10170d:	0f b6 c0             	movzbl %al,%eax
  101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE)
  101713:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101718:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171d:	75 0a                	jne    101729 <cons_getc+0x5f>
            {
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
  10175b:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init)
  101761:	a1 6c b6 11 00       	mov    0x11b66c,%eax
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
void pic_init(void)
{
  1017dd:	55                   	push   %ebp
  1017de:	89 e5                	mov    %esp,%ebp
  1017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017e3:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
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
  101905:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  10190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101911:	74 0f                	je     101922 <pic_init+0x145>
    {
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
  101935:	c7 04 24 e0 62 10 00 	movl   $0x1062e0,(%esp)
  10193c:	e8 24 ea ff ff       	call   100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101941:	90                   	nop
  101942:	89 ec                	mov    %ebp,%esp
  101944:	5d                   	pop    %ebp
  101945:	c3                   	ret    

00101946 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  101946:	55                   	push   %ebp
  101947:	89 e5                	mov    %esp,%ebp
  101949:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
  10194c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101953:	e9 c4 00 00 00       	jmp    101a1c <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101962:	0f b7 d0             	movzwl %ax,%edx
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	66 89 14 c5 80 b6 11 	mov    %dx,0x11b680(,%eax,8)
  10196f:	00 
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	66 c7 04 c5 82 b6 11 	movw   $0x8,0x11b682(,%eax,8)
  10197a:	00 08 00 
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  101987:	00 
  101988:	80 e2 e0             	and    $0xe0,%dl
  10198b:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  10199c:	00 
  10199d:	80 e2 1f             	and    $0x1f,%dl
  1019a0:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019aa:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019b1:	00 
  1019b2:	80 e2 f0             	and    $0xf0,%dl
  1019b5:	80 ca 0e             	or     $0xe,%dl
  1019b8:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c2:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019c9:	00 
  1019ca:	80 e2 ef             	and    $0xef,%dl
  1019cd:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d7:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019de:	00 
  1019df:	80 e2 9f             	and    $0x9f,%dl
  1019e2:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ec:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019f3:	00 
  1019f4:	80 ca 80             	or     $0x80,%dl
  1019f7:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a01:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101a08:	c1 e8 10             	shr    $0x10,%eax
  101a0b:	0f b7 d0             	movzwl %ax,%edx
  101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a11:	66 89 14 c5 86 b6 11 	mov    %dx,0x11b686(,%eax,8)
  101a18:	00 
    for (int i = 0; i < 256; i++)
  101a19:	ff 45 fc             	incl   -0x4(%ebp)
  101a1c:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a23:	0f 8e 2f ff ff ff    	jle    101958 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a29:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101a2e:	0f b7 c0             	movzwl %ax,%eax
  101a31:	66 a3 48 ba 11 00    	mov    %ax,0x11ba48
  101a37:	66 c7 05 4a ba 11 00 	movw   $0x8,0x11ba4a
  101a3e:	08 00 
  101a40:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a47:	24 e0                	and    $0xe0,%al
  101a49:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a4e:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a55:	24 1f                	and    $0x1f,%al
  101a57:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a5c:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a63:	24 f0                	and    $0xf0,%al
  101a65:	0c 0e                	or     $0xe,%al
  101a67:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a6c:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a73:	24 ef                	and    $0xef,%al
  101a75:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a7a:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a81:	0c 60                	or     $0x60,%al
  101a83:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a88:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a8f:	0c 80                	or     $0x80,%al
  101a91:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a96:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101a9b:	c1 e8 10             	shr    $0x10,%eax
  101a9e:	0f b7 c0             	movzwl %ax,%eax
  101aa1:	66 a3 4e ba 11 00    	mov    %ax,0x11ba4e
  101aa7:	c7 45 f8 60 85 11 00 	movl   $0x118560,-0x8(%ebp)
    asm volatile("lidt (%0)" ::"r"(pd)
  101aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ab1:	0f 01 18             	lidtl  (%eax)
}
  101ab4:	90                   	nop
    lidt(&idt_pd);
}
  101ab5:	90                   	nop
  101ab6:	89 ec                	mov    %ebp,%esp
  101ab8:	5d                   	pop    %ebp
  101ab9:	c3                   	ret    

00101aba <trapname>:

static const char *
trapname(int trapno)
{
  101aba:	55                   	push   %ebp
  101abb:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  101abd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac0:	83 f8 13             	cmp    $0x13,%eax
  101ac3:	77 0c                	ja     101ad1 <trapname+0x17>
    {
        return excnames[trapno];
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 04 85 40 66 10 00 	mov    0x106640(,%eax,4),%eax
  101acf:	eb 18                	jmp    101ae9 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101ad1:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ad5:	7e 0d                	jle    101ae4 <trapname+0x2a>
  101ad7:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101adb:	7f 07                	jg     101ae4 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101add:	b8 ea 62 10 00       	mov    $0x1062ea,%eax
  101ae2:	eb 05                	jmp    101ae9 <trapname+0x2f>
    }
    return "(unknown trap)";
  101ae4:	b8 fd 62 10 00       	mov    $0x1062fd,%eax
}
  101ae9:	5d                   	pop    %ebp
  101aea:	c3                   	ret    

00101aeb <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  101aeb:	55                   	push   %ebp
  101aec:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101aee:	8b 45 08             	mov    0x8(%ebp),%eax
  101af1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af5:	83 f8 08             	cmp    $0x8,%eax
  101af8:	0f 94 c0             	sete   %al
  101afb:	0f b6 c0             	movzbl %al,%eax
}
  101afe:	5d                   	pop    %ebp
  101aff:	c3                   	ret    

00101b00 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  101b00:	55                   	push   %ebp
  101b01:	89 e5                	mov    %esp,%ebp
  101b03:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0d:	c7 04 24 3e 63 10 00 	movl   $0x10633e,(%esp)
  101b14:	e8 4c e8 ff ff       	call   100365 <cprintf>
    print_regs(&tf->tf_regs);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	89 04 24             	mov    %eax,(%esp)
  101b1f:	e8 8f 01 00 00       	call   101cb3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 4f 63 10 00 	movl   $0x10634f,(%esp)
  101b36:	e8 2a e8 ff ff       	call   100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b46:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  101b4d:	e8 13 e8 ff ff       	call   100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5d:	c7 04 24 75 63 10 00 	movl   $0x106375,(%esp)
  101b64:	e8 fc e7 ff ff       	call   100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b69:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b74:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  101b7b:	e8 e5 e7 ff ff       	call   100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b80:	8b 45 08             	mov    0x8(%ebp),%eax
  101b83:	8b 40 30             	mov    0x30(%eax),%eax
  101b86:	89 04 24             	mov    %eax,(%esp)
  101b89:	e8 2c ff ff ff       	call   101aba <trapname>
  101b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  101b91:	8b 52 30             	mov    0x30(%edx),%edx
  101b94:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b98:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b9c:	c7 04 24 9b 63 10 00 	movl   $0x10639b,(%esp)
  101ba3:	e8 bd e7 ff ff       	call   100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	8b 40 34             	mov    0x34(%eax),%eax
  101bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb2:	c7 04 24 ad 63 10 00 	movl   $0x1063ad,(%esp)
  101bb9:	e8 a7 e7 ff ff       	call   100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	8b 40 38             	mov    0x38(%eax),%eax
  101bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc8:	c7 04 24 bc 63 10 00 	movl   $0x1063bc,(%esp)
  101bcf:	e8 91 e7 ff ff       	call   100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdf:	c7 04 24 cb 63 10 00 	movl   $0x1063cb,(%esp)
  101be6:	e8 7a e7 ff ff       	call   100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101beb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bee:	8b 40 40             	mov    0x40(%eax),%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 de 63 10 00 	movl   $0x1063de,(%esp)
  101bfc:	e8 64 e7 ff ff       	call   100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c08:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c0f:	eb 3d                	jmp    101c4e <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101c11:	8b 45 08             	mov    0x8(%ebp),%eax
  101c14:	8b 50 40             	mov    0x40(%eax),%edx
  101c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c1a:	21 d0                	and    %edx,%eax
  101c1c:	85 c0                	test   %eax,%eax
  101c1e:	74 28                	je     101c48 <print_trapframe+0x148>
  101c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c23:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c2a:	85 c0                	test   %eax,%eax
  101c2c:	74 1a                	je     101c48 <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
  101c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c31:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 ed 63 10 00 	movl   $0x1063ed,(%esp)
  101c43:	e8 1d e7 ff ff       	call   100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c48:	ff 45 f4             	incl   -0xc(%ebp)
  101c4b:	d1 65 f0             	shll   -0x10(%ebp)
  101c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c51:	83 f8 17             	cmp    $0x17,%eax
  101c54:	76 bb                	jbe    101c11 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c56:	8b 45 08             	mov    0x8(%ebp),%eax
  101c59:	8b 40 40             	mov    0x40(%eax),%eax
  101c5c:	c1 e8 0c             	shr    $0xc,%eax
  101c5f:	83 e0 03             	and    $0x3,%eax
  101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c66:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101c6d:	e8 f3 e6 ff ff       	call   100365 <cprintf>

    if (!trap_in_kernel(tf))
  101c72:	8b 45 08             	mov    0x8(%ebp),%eax
  101c75:	89 04 24             	mov    %eax,(%esp)
  101c78:	e8 6e fe ff ff       	call   101aeb <trap_in_kernel>
  101c7d:	85 c0                	test   %eax,%eax
  101c7f:	75 2d                	jne    101cae <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	8b 40 44             	mov    0x44(%eax),%eax
  101c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8b:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101c92:	e8 ce e6 ff ff       	call   100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c97:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca2:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101ca9:	e8 b7 e6 ff ff       	call   100365 <cprintf>
    }
}
  101cae:	90                   	nop
  101caf:	89 ec                	mov    %ebp,%esp
  101cb1:	5d                   	pop    %ebp
  101cb2:	c3                   	ret    

00101cb3 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101cb3:	55                   	push   %ebp
  101cb4:	89 e5                	mov    %esp,%ebp
  101cb6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbc:	8b 00                	mov    (%eax),%eax
  101cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc2:	c7 04 24 1c 64 10 00 	movl   $0x10641c,(%esp)
  101cc9:	e8 97 e6 ff ff       	call   100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cce:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd1:	8b 40 04             	mov    0x4(%eax),%eax
  101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd8:	c7 04 24 2b 64 10 00 	movl   $0x10642b,(%esp)
  101cdf:	e8 81 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce7:	8b 40 08             	mov    0x8(%eax),%eax
  101cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cee:	c7 04 24 3a 64 10 00 	movl   $0x10643a,(%esp)
  101cf5:	e8 6b e6 ff ff       	call   100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  101d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d04:	c7 04 24 49 64 10 00 	movl   $0x106449,(%esp)
  101d0b:	e8 55 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d10:	8b 45 08             	mov    0x8(%ebp),%eax
  101d13:	8b 40 10             	mov    0x10(%eax),%eax
  101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1a:	c7 04 24 58 64 10 00 	movl   $0x106458,(%esp)
  101d21:	e8 3f e6 ff ff       	call   100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d26:	8b 45 08             	mov    0x8(%ebp),%eax
  101d29:	8b 40 14             	mov    0x14(%eax),%eax
  101d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d30:	c7 04 24 67 64 10 00 	movl   $0x106467,(%esp)
  101d37:	e8 29 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3f:	8b 40 18             	mov    0x18(%eax),%eax
  101d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d46:	c7 04 24 76 64 10 00 	movl   $0x106476,(%esp)
  101d4d:	e8 13 e6 ff ff       	call   100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d52:	8b 45 08             	mov    0x8(%ebp),%eax
  101d55:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5c:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
  101d63:	e8 fd e5 ff ff       	call   100365 <cprintf>
}
  101d68:	90                   	nop
  101d69:	89 ec                	mov    %ebp,%esp
  101d6b:	5d                   	pop    %ebp
  101d6c:	c3                   	ret    

00101d6d <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
  101d6d:	55                   	push   %ebp
  101d6e:	89 e5                	mov    %esp,%ebp
  101d70:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	8b 40 30             	mov    0x30(%eax),%eax
  101d79:	83 f8 79             	cmp    $0x79,%eax
  101d7c:	0f 84 1f 01 00 00    	je     101ea1 <trap_dispatch+0x134>
  101d82:	83 f8 79             	cmp    $0x79,%eax
  101d85:	0f 87 69 01 00 00    	ja     101ef4 <trap_dispatch+0x187>
  101d8b:	83 f8 78             	cmp    $0x78,%eax
  101d8e:	0f 84 b7 00 00 00    	je     101e4b <trap_dispatch+0xde>
  101d94:	83 f8 78             	cmp    $0x78,%eax
  101d97:	0f 87 57 01 00 00    	ja     101ef4 <trap_dispatch+0x187>
  101d9d:	83 f8 2f             	cmp    $0x2f,%eax
  101da0:	0f 87 4e 01 00 00    	ja     101ef4 <trap_dispatch+0x187>
  101da6:	83 f8 2e             	cmp    $0x2e,%eax
  101da9:	0f 83 7a 01 00 00    	jae    101f29 <trap_dispatch+0x1bc>
  101daf:	83 f8 24             	cmp    $0x24,%eax
  101db2:	74 45                	je     101df9 <trap_dispatch+0x8c>
  101db4:	83 f8 24             	cmp    $0x24,%eax
  101db7:	0f 87 37 01 00 00    	ja     101ef4 <trap_dispatch+0x187>
  101dbd:	83 f8 20             	cmp    $0x20,%eax
  101dc0:	74 0a                	je     101dcc <trap_dispatch+0x5f>
  101dc2:	83 f8 21             	cmp    $0x21,%eax
  101dc5:	74 5b                	je     101e22 <trap_dispatch+0xb5>
  101dc7:	e9 28 01 00 00       	jmp    101ef4 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101dcc:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101dd1:	40                   	inc    %eax
  101dd2:	a3 24 b4 11 00       	mov    %eax,0x11b424
        if (ticks == TICK_NUM)
  101dd7:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101ddc:	83 f8 64             	cmp    $0x64,%eax
  101ddf:	0f 85 47 01 00 00    	jne    101f2c <trap_dispatch+0x1bf>
        {
            ticks = 0;
  101de5:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  101dec:	00 00 00 
            print_ticks();
  101def:	e8 33 fb ff ff       	call   101927 <print_ticks>
        }
        break;
  101df4:	e9 33 01 00 00       	jmp    101f2c <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101df9:	e8 cc f8 ff ff       	call   1016ca <cons_getc>
  101dfe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e09:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e11:	c7 04 24 94 64 10 00 	movl   $0x106494,(%esp)
  101e18:	e8 48 e5 ff ff       	call   100365 <cprintf>
        break;
  101e1d:	e9 11 01 00 00       	jmp    101f33 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e22:	e8 a3 f8 ff ff       	call   1016ca <cons_getc>
  101e27:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e2a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e2e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e32:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e3a:	c7 04 24 a6 64 10 00 	movl   $0x1064a6,(%esp)
  101e41:	e8 1f e5 ff ff       	call   100365 <cprintf>
        break;
  101e46:	e9 e8 00 00 00       	jmp    101f33 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e52:	83 f8 1b             	cmp    $0x1b,%eax
  101e55:	0f 84 d4 00 00 00    	je     101f2f <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
  101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e64:	8b 45 08             	mov    0x8(%ebp),%eax
  101e67:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e70:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e74:	8b 45 08             	mov    0x8(%ebp),%eax
  101e77:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e82:	8b 45 08             	mov    0x8(%ebp),%eax
  101e85:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101e89:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8c:	8b 40 40             	mov    0x40(%eax),%eax
  101e8f:	0d 00 30 00 00       	or     $0x3000,%eax
  101e94:	89 c2                	mov    %eax,%edx
  101e96:	8b 45 08             	mov    0x8(%ebp),%eax
  101e99:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101e9c:	e9 8e 00 00 00       	jmp    101f2f <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
  101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea8:	83 f8 08             	cmp    $0x8,%eax
  101eab:	0f 84 81 00 00 00    	je     101f32 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
  101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101eba:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebd:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101eca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecd:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  101edb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	8b 40 40             	mov    0x40(%eax),%eax
  101ee5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101eea:	89 c2                	mov    %eax,%edx
  101eec:	8b 45 08             	mov    0x8(%ebp),%eax
  101eef:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101ef2:	eb 3e                	jmp    101f32 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101efb:	83 e0 03             	and    $0x3,%eax
  101efe:	85 c0                	test   %eax,%eax
  101f00:	75 31                	jne    101f33 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
  101f02:	8b 45 08             	mov    0x8(%ebp),%eax
  101f05:	89 04 24             	mov    %eax,(%esp)
  101f08:	e8 f3 fb ff ff       	call   101b00 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f0d:	c7 44 24 08 b5 64 10 	movl   $0x1064b5,0x8(%esp)
  101f14:	00 
  101f15:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  101f1c:	00 
  101f1d:	c7 04 24 d1 64 10 00 	movl   $0x1064d1,(%esp)
  101f24:	e8 c1 ed ff ff       	call   100cea <__panic>
        break;
  101f29:	90                   	nop
  101f2a:	eb 07                	jmp    101f33 <trap_dispatch+0x1c6>
        break;
  101f2c:	90                   	nop
  101f2d:	eb 04                	jmp    101f33 <trap_dispatch+0x1c6>
        break;
  101f2f:	90                   	nop
  101f30:	eb 01                	jmp    101f33 <trap_dispatch+0x1c6>
        break;
  101f32:	90                   	nop
        }
    }
}
  101f33:	90                   	nop
  101f34:	89 ec                	mov    %ebp,%esp
  101f36:	5d                   	pop    %ebp
  101f37:	c3                   	ret    

00101f38 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101f38:	55                   	push   %ebp
  101f39:	89 e5                	mov    %esp,%ebp
  101f3b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f41:	89 04 24             	mov    %eax,(%esp)
  101f44:	e8 24 fe ff ff       	call   101d6d <trap_dispatch>
}
  101f49:	90                   	nop
  101f4a:	89 ec                	mov    %ebp,%esp
  101f4c:	5d                   	pop    %ebp
  101f4d:	c3                   	ret    

00101f4e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f4e:	1e                   	push   %ds
    pushl %es
  101f4f:	06                   	push   %es
    pushl %fs
  101f50:	0f a0                	push   %fs
    pushl %gs
  101f52:	0f a8                	push   %gs
    pushal
  101f54:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f55:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f5a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f5c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f5e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f5f:	e8 d4 ff ff ff       	call   101f38 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f64:	5c                   	pop    %esp

00101f65 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f65:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f66:	0f a9                	pop    %gs
    popl %fs
  101f68:	0f a1                	pop    %fs
    popl %es
  101f6a:	07                   	pop    %es
    popl %ds
  101f6b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f6c:	83 c4 08             	add    $0x8,%esp
    iret
  101f6f:	cf                   	iret   

00101f70 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $0
  101f72:	6a 00                	push   $0x0
  jmp __alltraps
  101f74:	e9 d5 ff ff ff       	jmp    101f4e <__alltraps>

00101f79 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $1
  101f7b:	6a 01                	push   $0x1
  jmp __alltraps
  101f7d:	e9 cc ff ff ff       	jmp    101f4e <__alltraps>

00101f82 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $2
  101f84:	6a 02                	push   $0x2
  jmp __alltraps
  101f86:	e9 c3 ff ff ff       	jmp    101f4e <__alltraps>

00101f8b <vector3>:
.globl vector3
vector3:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $3
  101f8d:	6a 03                	push   $0x3
  jmp __alltraps
  101f8f:	e9 ba ff ff ff       	jmp    101f4e <__alltraps>

00101f94 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $4
  101f96:	6a 04                	push   $0x4
  jmp __alltraps
  101f98:	e9 b1 ff ff ff       	jmp    101f4e <__alltraps>

00101f9d <vector5>:
.globl vector5
vector5:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $5
  101f9f:	6a 05                	push   $0x5
  jmp __alltraps
  101fa1:	e9 a8 ff ff ff       	jmp    101f4e <__alltraps>

00101fa6 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $6
  101fa8:	6a 06                	push   $0x6
  jmp __alltraps
  101faa:	e9 9f ff ff ff       	jmp    101f4e <__alltraps>

00101faf <vector7>:
.globl vector7
vector7:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $7
  101fb1:	6a 07                	push   $0x7
  jmp __alltraps
  101fb3:	e9 96 ff ff ff       	jmp    101f4e <__alltraps>

00101fb8 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fb8:	6a 08                	push   $0x8
  jmp __alltraps
  101fba:	e9 8f ff ff ff       	jmp    101f4e <__alltraps>

00101fbf <vector9>:
.globl vector9
vector9:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $9
  101fc1:	6a 09                	push   $0x9
  jmp __alltraps
  101fc3:	e9 86 ff ff ff       	jmp    101f4e <__alltraps>

00101fc8 <vector10>:
.globl vector10
vector10:
  pushl $10
  101fc8:	6a 0a                	push   $0xa
  jmp __alltraps
  101fca:	e9 7f ff ff ff       	jmp    101f4e <__alltraps>

00101fcf <vector11>:
.globl vector11
vector11:
  pushl $11
  101fcf:	6a 0b                	push   $0xb
  jmp __alltraps
  101fd1:	e9 78 ff ff ff       	jmp    101f4e <__alltraps>

00101fd6 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fd6:	6a 0c                	push   $0xc
  jmp __alltraps
  101fd8:	e9 71 ff ff ff       	jmp    101f4e <__alltraps>

00101fdd <vector13>:
.globl vector13
vector13:
  pushl $13
  101fdd:	6a 0d                	push   $0xd
  jmp __alltraps
  101fdf:	e9 6a ff ff ff       	jmp    101f4e <__alltraps>

00101fe4 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fe4:	6a 0e                	push   $0xe
  jmp __alltraps
  101fe6:	e9 63 ff ff ff       	jmp    101f4e <__alltraps>

00101feb <vector15>:
.globl vector15
vector15:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $15
  101fed:	6a 0f                	push   $0xf
  jmp __alltraps
  101fef:	e9 5a ff ff ff       	jmp    101f4e <__alltraps>

00101ff4 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $16
  101ff6:	6a 10                	push   $0x10
  jmp __alltraps
  101ff8:	e9 51 ff ff ff       	jmp    101f4e <__alltraps>

00101ffd <vector17>:
.globl vector17
vector17:
  pushl $17
  101ffd:	6a 11                	push   $0x11
  jmp __alltraps
  101fff:	e9 4a ff ff ff       	jmp    101f4e <__alltraps>

00102004 <vector18>:
.globl vector18
vector18:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $18
  102006:	6a 12                	push   $0x12
  jmp __alltraps
  102008:	e9 41 ff ff ff       	jmp    101f4e <__alltraps>

0010200d <vector19>:
.globl vector19
vector19:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $19
  10200f:	6a 13                	push   $0x13
  jmp __alltraps
  102011:	e9 38 ff ff ff       	jmp    101f4e <__alltraps>

00102016 <vector20>:
.globl vector20
vector20:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $20
  102018:	6a 14                	push   $0x14
  jmp __alltraps
  10201a:	e9 2f ff ff ff       	jmp    101f4e <__alltraps>

0010201f <vector21>:
.globl vector21
vector21:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $21
  102021:	6a 15                	push   $0x15
  jmp __alltraps
  102023:	e9 26 ff ff ff       	jmp    101f4e <__alltraps>

00102028 <vector22>:
.globl vector22
vector22:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $22
  10202a:	6a 16                	push   $0x16
  jmp __alltraps
  10202c:	e9 1d ff ff ff       	jmp    101f4e <__alltraps>

00102031 <vector23>:
.globl vector23
vector23:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $23
  102033:	6a 17                	push   $0x17
  jmp __alltraps
  102035:	e9 14 ff ff ff       	jmp    101f4e <__alltraps>

0010203a <vector24>:
.globl vector24
vector24:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $24
  10203c:	6a 18                	push   $0x18
  jmp __alltraps
  10203e:	e9 0b ff ff ff       	jmp    101f4e <__alltraps>

00102043 <vector25>:
.globl vector25
vector25:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $25
  102045:	6a 19                	push   $0x19
  jmp __alltraps
  102047:	e9 02 ff ff ff       	jmp    101f4e <__alltraps>

0010204c <vector26>:
.globl vector26
vector26:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $26
  10204e:	6a 1a                	push   $0x1a
  jmp __alltraps
  102050:	e9 f9 fe ff ff       	jmp    101f4e <__alltraps>

00102055 <vector27>:
.globl vector27
vector27:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $27
  102057:	6a 1b                	push   $0x1b
  jmp __alltraps
  102059:	e9 f0 fe ff ff       	jmp    101f4e <__alltraps>

0010205e <vector28>:
.globl vector28
vector28:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $28
  102060:	6a 1c                	push   $0x1c
  jmp __alltraps
  102062:	e9 e7 fe ff ff       	jmp    101f4e <__alltraps>

00102067 <vector29>:
.globl vector29
vector29:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $29
  102069:	6a 1d                	push   $0x1d
  jmp __alltraps
  10206b:	e9 de fe ff ff       	jmp    101f4e <__alltraps>

00102070 <vector30>:
.globl vector30
vector30:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $30
  102072:	6a 1e                	push   $0x1e
  jmp __alltraps
  102074:	e9 d5 fe ff ff       	jmp    101f4e <__alltraps>

00102079 <vector31>:
.globl vector31
vector31:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $31
  10207b:	6a 1f                	push   $0x1f
  jmp __alltraps
  10207d:	e9 cc fe ff ff       	jmp    101f4e <__alltraps>

00102082 <vector32>:
.globl vector32
vector32:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $32
  102084:	6a 20                	push   $0x20
  jmp __alltraps
  102086:	e9 c3 fe ff ff       	jmp    101f4e <__alltraps>

0010208b <vector33>:
.globl vector33
vector33:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $33
  10208d:	6a 21                	push   $0x21
  jmp __alltraps
  10208f:	e9 ba fe ff ff       	jmp    101f4e <__alltraps>

00102094 <vector34>:
.globl vector34
vector34:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $34
  102096:	6a 22                	push   $0x22
  jmp __alltraps
  102098:	e9 b1 fe ff ff       	jmp    101f4e <__alltraps>

0010209d <vector35>:
.globl vector35
vector35:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $35
  10209f:	6a 23                	push   $0x23
  jmp __alltraps
  1020a1:	e9 a8 fe ff ff       	jmp    101f4e <__alltraps>

001020a6 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $36
  1020a8:	6a 24                	push   $0x24
  jmp __alltraps
  1020aa:	e9 9f fe ff ff       	jmp    101f4e <__alltraps>

001020af <vector37>:
.globl vector37
vector37:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $37
  1020b1:	6a 25                	push   $0x25
  jmp __alltraps
  1020b3:	e9 96 fe ff ff       	jmp    101f4e <__alltraps>

001020b8 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $38
  1020ba:	6a 26                	push   $0x26
  jmp __alltraps
  1020bc:	e9 8d fe ff ff       	jmp    101f4e <__alltraps>

001020c1 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $39
  1020c3:	6a 27                	push   $0x27
  jmp __alltraps
  1020c5:	e9 84 fe ff ff       	jmp    101f4e <__alltraps>

001020ca <vector40>:
.globl vector40
vector40:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $40
  1020cc:	6a 28                	push   $0x28
  jmp __alltraps
  1020ce:	e9 7b fe ff ff       	jmp    101f4e <__alltraps>

001020d3 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $41
  1020d5:	6a 29                	push   $0x29
  jmp __alltraps
  1020d7:	e9 72 fe ff ff       	jmp    101f4e <__alltraps>

001020dc <vector42>:
.globl vector42
vector42:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $42
  1020de:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020e0:	e9 69 fe ff ff       	jmp    101f4e <__alltraps>

001020e5 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $43
  1020e7:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020e9:	e9 60 fe ff ff       	jmp    101f4e <__alltraps>

001020ee <vector44>:
.globl vector44
vector44:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $44
  1020f0:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020f2:	e9 57 fe ff ff       	jmp    101f4e <__alltraps>

001020f7 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $45
  1020f9:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020fb:	e9 4e fe ff ff       	jmp    101f4e <__alltraps>

00102100 <vector46>:
.globl vector46
vector46:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $46
  102102:	6a 2e                	push   $0x2e
  jmp __alltraps
  102104:	e9 45 fe ff ff       	jmp    101f4e <__alltraps>

00102109 <vector47>:
.globl vector47
vector47:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $47
  10210b:	6a 2f                	push   $0x2f
  jmp __alltraps
  10210d:	e9 3c fe ff ff       	jmp    101f4e <__alltraps>

00102112 <vector48>:
.globl vector48
vector48:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $48
  102114:	6a 30                	push   $0x30
  jmp __alltraps
  102116:	e9 33 fe ff ff       	jmp    101f4e <__alltraps>

0010211b <vector49>:
.globl vector49
vector49:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $49
  10211d:	6a 31                	push   $0x31
  jmp __alltraps
  10211f:	e9 2a fe ff ff       	jmp    101f4e <__alltraps>

00102124 <vector50>:
.globl vector50
vector50:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $50
  102126:	6a 32                	push   $0x32
  jmp __alltraps
  102128:	e9 21 fe ff ff       	jmp    101f4e <__alltraps>

0010212d <vector51>:
.globl vector51
vector51:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $51
  10212f:	6a 33                	push   $0x33
  jmp __alltraps
  102131:	e9 18 fe ff ff       	jmp    101f4e <__alltraps>

00102136 <vector52>:
.globl vector52
vector52:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $52
  102138:	6a 34                	push   $0x34
  jmp __alltraps
  10213a:	e9 0f fe ff ff       	jmp    101f4e <__alltraps>

0010213f <vector53>:
.globl vector53
vector53:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $53
  102141:	6a 35                	push   $0x35
  jmp __alltraps
  102143:	e9 06 fe ff ff       	jmp    101f4e <__alltraps>

00102148 <vector54>:
.globl vector54
vector54:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $54
  10214a:	6a 36                	push   $0x36
  jmp __alltraps
  10214c:	e9 fd fd ff ff       	jmp    101f4e <__alltraps>

00102151 <vector55>:
.globl vector55
vector55:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $55
  102153:	6a 37                	push   $0x37
  jmp __alltraps
  102155:	e9 f4 fd ff ff       	jmp    101f4e <__alltraps>

0010215a <vector56>:
.globl vector56
vector56:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $56
  10215c:	6a 38                	push   $0x38
  jmp __alltraps
  10215e:	e9 eb fd ff ff       	jmp    101f4e <__alltraps>

00102163 <vector57>:
.globl vector57
vector57:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $57
  102165:	6a 39                	push   $0x39
  jmp __alltraps
  102167:	e9 e2 fd ff ff       	jmp    101f4e <__alltraps>

0010216c <vector58>:
.globl vector58
vector58:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $58
  10216e:	6a 3a                	push   $0x3a
  jmp __alltraps
  102170:	e9 d9 fd ff ff       	jmp    101f4e <__alltraps>

00102175 <vector59>:
.globl vector59
vector59:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $59
  102177:	6a 3b                	push   $0x3b
  jmp __alltraps
  102179:	e9 d0 fd ff ff       	jmp    101f4e <__alltraps>

0010217e <vector60>:
.globl vector60
vector60:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $60
  102180:	6a 3c                	push   $0x3c
  jmp __alltraps
  102182:	e9 c7 fd ff ff       	jmp    101f4e <__alltraps>

00102187 <vector61>:
.globl vector61
vector61:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $61
  102189:	6a 3d                	push   $0x3d
  jmp __alltraps
  10218b:	e9 be fd ff ff       	jmp    101f4e <__alltraps>

00102190 <vector62>:
.globl vector62
vector62:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $62
  102192:	6a 3e                	push   $0x3e
  jmp __alltraps
  102194:	e9 b5 fd ff ff       	jmp    101f4e <__alltraps>

00102199 <vector63>:
.globl vector63
vector63:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $63
  10219b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10219d:	e9 ac fd ff ff       	jmp    101f4e <__alltraps>

001021a2 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $64
  1021a4:	6a 40                	push   $0x40
  jmp __alltraps
  1021a6:	e9 a3 fd ff ff       	jmp    101f4e <__alltraps>

001021ab <vector65>:
.globl vector65
vector65:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $65
  1021ad:	6a 41                	push   $0x41
  jmp __alltraps
  1021af:	e9 9a fd ff ff       	jmp    101f4e <__alltraps>

001021b4 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $66
  1021b6:	6a 42                	push   $0x42
  jmp __alltraps
  1021b8:	e9 91 fd ff ff       	jmp    101f4e <__alltraps>

001021bd <vector67>:
.globl vector67
vector67:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $67
  1021bf:	6a 43                	push   $0x43
  jmp __alltraps
  1021c1:	e9 88 fd ff ff       	jmp    101f4e <__alltraps>

001021c6 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $68
  1021c8:	6a 44                	push   $0x44
  jmp __alltraps
  1021ca:	e9 7f fd ff ff       	jmp    101f4e <__alltraps>

001021cf <vector69>:
.globl vector69
vector69:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $69
  1021d1:	6a 45                	push   $0x45
  jmp __alltraps
  1021d3:	e9 76 fd ff ff       	jmp    101f4e <__alltraps>

001021d8 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $70
  1021da:	6a 46                	push   $0x46
  jmp __alltraps
  1021dc:	e9 6d fd ff ff       	jmp    101f4e <__alltraps>

001021e1 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $71
  1021e3:	6a 47                	push   $0x47
  jmp __alltraps
  1021e5:	e9 64 fd ff ff       	jmp    101f4e <__alltraps>

001021ea <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $72
  1021ec:	6a 48                	push   $0x48
  jmp __alltraps
  1021ee:	e9 5b fd ff ff       	jmp    101f4e <__alltraps>

001021f3 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $73
  1021f5:	6a 49                	push   $0x49
  jmp __alltraps
  1021f7:	e9 52 fd ff ff       	jmp    101f4e <__alltraps>

001021fc <vector74>:
.globl vector74
vector74:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $74
  1021fe:	6a 4a                	push   $0x4a
  jmp __alltraps
  102200:	e9 49 fd ff ff       	jmp    101f4e <__alltraps>

00102205 <vector75>:
.globl vector75
vector75:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $75
  102207:	6a 4b                	push   $0x4b
  jmp __alltraps
  102209:	e9 40 fd ff ff       	jmp    101f4e <__alltraps>

0010220e <vector76>:
.globl vector76
vector76:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $76
  102210:	6a 4c                	push   $0x4c
  jmp __alltraps
  102212:	e9 37 fd ff ff       	jmp    101f4e <__alltraps>

00102217 <vector77>:
.globl vector77
vector77:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $77
  102219:	6a 4d                	push   $0x4d
  jmp __alltraps
  10221b:	e9 2e fd ff ff       	jmp    101f4e <__alltraps>

00102220 <vector78>:
.globl vector78
vector78:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $78
  102222:	6a 4e                	push   $0x4e
  jmp __alltraps
  102224:	e9 25 fd ff ff       	jmp    101f4e <__alltraps>

00102229 <vector79>:
.globl vector79
vector79:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $79
  10222b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10222d:	e9 1c fd ff ff       	jmp    101f4e <__alltraps>

00102232 <vector80>:
.globl vector80
vector80:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $80
  102234:	6a 50                	push   $0x50
  jmp __alltraps
  102236:	e9 13 fd ff ff       	jmp    101f4e <__alltraps>

0010223b <vector81>:
.globl vector81
vector81:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $81
  10223d:	6a 51                	push   $0x51
  jmp __alltraps
  10223f:	e9 0a fd ff ff       	jmp    101f4e <__alltraps>

00102244 <vector82>:
.globl vector82
vector82:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $82
  102246:	6a 52                	push   $0x52
  jmp __alltraps
  102248:	e9 01 fd ff ff       	jmp    101f4e <__alltraps>

0010224d <vector83>:
.globl vector83
vector83:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $83
  10224f:	6a 53                	push   $0x53
  jmp __alltraps
  102251:	e9 f8 fc ff ff       	jmp    101f4e <__alltraps>

00102256 <vector84>:
.globl vector84
vector84:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $84
  102258:	6a 54                	push   $0x54
  jmp __alltraps
  10225a:	e9 ef fc ff ff       	jmp    101f4e <__alltraps>

0010225f <vector85>:
.globl vector85
vector85:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $85
  102261:	6a 55                	push   $0x55
  jmp __alltraps
  102263:	e9 e6 fc ff ff       	jmp    101f4e <__alltraps>

00102268 <vector86>:
.globl vector86
vector86:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $86
  10226a:	6a 56                	push   $0x56
  jmp __alltraps
  10226c:	e9 dd fc ff ff       	jmp    101f4e <__alltraps>

00102271 <vector87>:
.globl vector87
vector87:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $87
  102273:	6a 57                	push   $0x57
  jmp __alltraps
  102275:	e9 d4 fc ff ff       	jmp    101f4e <__alltraps>

0010227a <vector88>:
.globl vector88
vector88:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $88
  10227c:	6a 58                	push   $0x58
  jmp __alltraps
  10227e:	e9 cb fc ff ff       	jmp    101f4e <__alltraps>

00102283 <vector89>:
.globl vector89
vector89:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $89
  102285:	6a 59                	push   $0x59
  jmp __alltraps
  102287:	e9 c2 fc ff ff       	jmp    101f4e <__alltraps>

0010228c <vector90>:
.globl vector90
vector90:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $90
  10228e:	6a 5a                	push   $0x5a
  jmp __alltraps
  102290:	e9 b9 fc ff ff       	jmp    101f4e <__alltraps>

00102295 <vector91>:
.globl vector91
vector91:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $91
  102297:	6a 5b                	push   $0x5b
  jmp __alltraps
  102299:	e9 b0 fc ff ff       	jmp    101f4e <__alltraps>

0010229e <vector92>:
.globl vector92
vector92:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $92
  1022a0:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022a2:	e9 a7 fc ff ff       	jmp    101f4e <__alltraps>

001022a7 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $93
  1022a9:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022ab:	e9 9e fc ff ff       	jmp    101f4e <__alltraps>

001022b0 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $94
  1022b2:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022b4:	e9 95 fc ff ff       	jmp    101f4e <__alltraps>

001022b9 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $95
  1022bb:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022bd:	e9 8c fc ff ff       	jmp    101f4e <__alltraps>

001022c2 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $96
  1022c4:	6a 60                	push   $0x60
  jmp __alltraps
  1022c6:	e9 83 fc ff ff       	jmp    101f4e <__alltraps>

001022cb <vector97>:
.globl vector97
vector97:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $97
  1022cd:	6a 61                	push   $0x61
  jmp __alltraps
  1022cf:	e9 7a fc ff ff       	jmp    101f4e <__alltraps>

001022d4 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $98
  1022d6:	6a 62                	push   $0x62
  jmp __alltraps
  1022d8:	e9 71 fc ff ff       	jmp    101f4e <__alltraps>

001022dd <vector99>:
.globl vector99
vector99:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $99
  1022df:	6a 63                	push   $0x63
  jmp __alltraps
  1022e1:	e9 68 fc ff ff       	jmp    101f4e <__alltraps>

001022e6 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $100
  1022e8:	6a 64                	push   $0x64
  jmp __alltraps
  1022ea:	e9 5f fc ff ff       	jmp    101f4e <__alltraps>

001022ef <vector101>:
.globl vector101
vector101:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $101
  1022f1:	6a 65                	push   $0x65
  jmp __alltraps
  1022f3:	e9 56 fc ff ff       	jmp    101f4e <__alltraps>

001022f8 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $102
  1022fa:	6a 66                	push   $0x66
  jmp __alltraps
  1022fc:	e9 4d fc ff ff       	jmp    101f4e <__alltraps>

00102301 <vector103>:
.globl vector103
vector103:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $103
  102303:	6a 67                	push   $0x67
  jmp __alltraps
  102305:	e9 44 fc ff ff       	jmp    101f4e <__alltraps>

0010230a <vector104>:
.globl vector104
vector104:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $104
  10230c:	6a 68                	push   $0x68
  jmp __alltraps
  10230e:	e9 3b fc ff ff       	jmp    101f4e <__alltraps>

00102313 <vector105>:
.globl vector105
vector105:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $105
  102315:	6a 69                	push   $0x69
  jmp __alltraps
  102317:	e9 32 fc ff ff       	jmp    101f4e <__alltraps>

0010231c <vector106>:
.globl vector106
vector106:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $106
  10231e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102320:	e9 29 fc ff ff       	jmp    101f4e <__alltraps>

00102325 <vector107>:
.globl vector107
vector107:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $107
  102327:	6a 6b                	push   $0x6b
  jmp __alltraps
  102329:	e9 20 fc ff ff       	jmp    101f4e <__alltraps>

0010232e <vector108>:
.globl vector108
vector108:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $108
  102330:	6a 6c                	push   $0x6c
  jmp __alltraps
  102332:	e9 17 fc ff ff       	jmp    101f4e <__alltraps>

00102337 <vector109>:
.globl vector109
vector109:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $109
  102339:	6a 6d                	push   $0x6d
  jmp __alltraps
  10233b:	e9 0e fc ff ff       	jmp    101f4e <__alltraps>

00102340 <vector110>:
.globl vector110
vector110:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $110
  102342:	6a 6e                	push   $0x6e
  jmp __alltraps
  102344:	e9 05 fc ff ff       	jmp    101f4e <__alltraps>

00102349 <vector111>:
.globl vector111
vector111:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $111
  10234b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10234d:	e9 fc fb ff ff       	jmp    101f4e <__alltraps>

00102352 <vector112>:
.globl vector112
vector112:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $112
  102354:	6a 70                	push   $0x70
  jmp __alltraps
  102356:	e9 f3 fb ff ff       	jmp    101f4e <__alltraps>

0010235b <vector113>:
.globl vector113
vector113:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $113
  10235d:	6a 71                	push   $0x71
  jmp __alltraps
  10235f:	e9 ea fb ff ff       	jmp    101f4e <__alltraps>

00102364 <vector114>:
.globl vector114
vector114:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $114
  102366:	6a 72                	push   $0x72
  jmp __alltraps
  102368:	e9 e1 fb ff ff       	jmp    101f4e <__alltraps>

0010236d <vector115>:
.globl vector115
vector115:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $115
  10236f:	6a 73                	push   $0x73
  jmp __alltraps
  102371:	e9 d8 fb ff ff       	jmp    101f4e <__alltraps>

00102376 <vector116>:
.globl vector116
vector116:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $116
  102378:	6a 74                	push   $0x74
  jmp __alltraps
  10237a:	e9 cf fb ff ff       	jmp    101f4e <__alltraps>

0010237f <vector117>:
.globl vector117
vector117:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $117
  102381:	6a 75                	push   $0x75
  jmp __alltraps
  102383:	e9 c6 fb ff ff       	jmp    101f4e <__alltraps>

00102388 <vector118>:
.globl vector118
vector118:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $118
  10238a:	6a 76                	push   $0x76
  jmp __alltraps
  10238c:	e9 bd fb ff ff       	jmp    101f4e <__alltraps>

00102391 <vector119>:
.globl vector119
vector119:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $119
  102393:	6a 77                	push   $0x77
  jmp __alltraps
  102395:	e9 b4 fb ff ff       	jmp    101f4e <__alltraps>

0010239a <vector120>:
.globl vector120
vector120:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $120
  10239c:	6a 78                	push   $0x78
  jmp __alltraps
  10239e:	e9 ab fb ff ff       	jmp    101f4e <__alltraps>

001023a3 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $121
  1023a5:	6a 79                	push   $0x79
  jmp __alltraps
  1023a7:	e9 a2 fb ff ff       	jmp    101f4e <__alltraps>

001023ac <vector122>:
.globl vector122
vector122:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $122
  1023ae:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023b0:	e9 99 fb ff ff       	jmp    101f4e <__alltraps>

001023b5 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $123
  1023b7:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023b9:	e9 90 fb ff ff       	jmp    101f4e <__alltraps>

001023be <vector124>:
.globl vector124
vector124:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $124
  1023c0:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023c2:	e9 87 fb ff ff       	jmp    101f4e <__alltraps>

001023c7 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $125
  1023c9:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023cb:	e9 7e fb ff ff       	jmp    101f4e <__alltraps>

001023d0 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $126
  1023d2:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023d4:	e9 75 fb ff ff       	jmp    101f4e <__alltraps>

001023d9 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $127
  1023db:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023dd:	e9 6c fb ff ff       	jmp    101f4e <__alltraps>

001023e2 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $128
  1023e4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023e9:	e9 60 fb ff ff       	jmp    101f4e <__alltraps>

001023ee <vector129>:
.globl vector129
vector129:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $129
  1023f0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023f5:	e9 54 fb ff ff       	jmp    101f4e <__alltraps>

001023fa <vector130>:
.globl vector130
vector130:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $130
  1023fc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102401:	e9 48 fb ff ff       	jmp    101f4e <__alltraps>

00102406 <vector131>:
.globl vector131
vector131:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $131
  102408:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10240d:	e9 3c fb ff ff       	jmp    101f4e <__alltraps>

00102412 <vector132>:
.globl vector132
vector132:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $132
  102414:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102419:	e9 30 fb ff ff       	jmp    101f4e <__alltraps>

0010241e <vector133>:
.globl vector133
vector133:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $133
  102420:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102425:	e9 24 fb ff ff       	jmp    101f4e <__alltraps>

0010242a <vector134>:
.globl vector134
vector134:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $134
  10242c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102431:	e9 18 fb ff ff       	jmp    101f4e <__alltraps>

00102436 <vector135>:
.globl vector135
vector135:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $135
  102438:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10243d:	e9 0c fb ff ff       	jmp    101f4e <__alltraps>

00102442 <vector136>:
.globl vector136
vector136:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $136
  102444:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102449:	e9 00 fb ff ff       	jmp    101f4e <__alltraps>

0010244e <vector137>:
.globl vector137
vector137:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $137
  102450:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102455:	e9 f4 fa ff ff       	jmp    101f4e <__alltraps>

0010245a <vector138>:
.globl vector138
vector138:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $138
  10245c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102461:	e9 e8 fa ff ff       	jmp    101f4e <__alltraps>

00102466 <vector139>:
.globl vector139
vector139:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $139
  102468:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10246d:	e9 dc fa ff ff       	jmp    101f4e <__alltraps>

00102472 <vector140>:
.globl vector140
vector140:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $140
  102474:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102479:	e9 d0 fa ff ff       	jmp    101f4e <__alltraps>

0010247e <vector141>:
.globl vector141
vector141:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $141
  102480:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102485:	e9 c4 fa ff ff       	jmp    101f4e <__alltraps>

0010248a <vector142>:
.globl vector142
vector142:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $142
  10248c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102491:	e9 b8 fa ff ff       	jmp    101f4e <__alltraps>

00102496 <vector143>:
.globl vector143
vector143:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $143
  102498:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10249d:	e9 ac fa ff ff       	jmp    101f4e <__alltraps>

001024a2 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $144
  1024a4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024a9:	e9 a0 fa ff ff       	jmp    101f4e <__alltraps>

001024ae <vector145>:
.globl vector145
vector145:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $145
  1024b0:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024b5:	e9 94 fa ff ff       	jmp    101f4e <__alltraps>

001024ba <vector146>:
.globl vector146
vector146:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $146
  1024bc:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024c1:	e9 88 fa ff ff       	jmp    101f4e <__alltraps>

001024c6 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $147
  1024c8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024cd:	e9 7c fa ff ff       	jmp    101f4e <__alltraps>

001024d2 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $148
  1024d4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024d9:	e9 70 fa ff ff       	jmp    101f4e <__alltraps>

001024de <vector149>:
.globl vector149
vector149:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $149
  1024e0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024e5:	e9 64 fa ff ff       	jmp    101f4e <__alltraps>

001024ea <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $150
  1024ec:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024f1:	e9 58 fa ff ff       	jmp    101f4e <__alltraps>

001024f6 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $151
  1024f8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024fd:	e9 4c fa ff ff       	jmp    101f4e <__alltraps>

00102502 <vector152>:
.globl vector152
vector152:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $152
  102504:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102509:	e9 40 fa ff ff       	jmp    101f4e <__alltraps>

0010250e <vector153>:
.globl vector153
vector153:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $153
  102510:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102515:	e9 34 fa ff ff       	jmp    101f4e <__alltraps>

0010251a <vector154>:
.globl vector154
vector154:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $154
  10251c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102521:	e9 28 fa ff ff       	jmp    101f4e <__alltraps>

00102526 <vector155>:
.globl vector155
vector155:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $155
  102528:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10252d:	e9 1c fa ff ff       	jmp    101f4e <__alltraps>

00102532 <vector156>:
.globl vector156
vector156:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $156
  102534:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102539:	e9 10 fa ff ff       	jmp    101f4e <__alltraps>

0010253e <vector157>:
.globl vector157
vector157:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $157
  102540:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102545:	e9 04 fa ff ff       	jmp    101f4e <__alltraps>

0010254a <vector158>:
.globl vector158
vector158:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $158
  10254c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102551:	e9 f8 f9 ff ff       	jmp    101f4e <__alltraps>

00102556 <vector159>:
.globl vector159
vector159:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $159
  102558:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10255d:	e9 ec f9 ff ff       	jmp    101f4e <__alltraps>

00102562 <vector160>:
.globl vector160
vector160:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $160
  102564:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102569:	e9 e0 f9 ff ff       	jmp    101f4e <__alltraps>

0010256e <vector161>:
.globl vector161
vector161:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $161
  102570:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102575:	e9 d4 f9 ff ff       	jmp    101f4e <__alltraps>

0010257a <vector162>:
.globl vector162
vector162:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $162
  10257c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102581:	e9 c8 f9 ff ff       	jmp    101f4e <__alltraps>

00102586 <vector163>:
.globl vector163
vector163:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $163
  102588:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10258d:	e9 bc f9 ff ff       	jmp    101f4e <__alltraps>

00102592 <vector164>:
.globl vector164
vector164:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $164
  102594:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102599:	e9 b0 f9 ff ff       	jmp    101f4e <__alltraps>

0010259e <vector165>:
.globl vector165
vector165:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $165
  1025a0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025a5:	e9 a4 f9 ff ff       	jmp    101f4e <__alltraps>

001025aa <vector166>:
.globl vector166
vector166:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $166
  1025ac:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025b1:	e9 98 f9 ff ff       	jmp    101f4e <__alltraps>

001025b6 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $167
  1025b8:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025bd:	e9 8c f9 ff ff       	jmp    101f4e <__alltraps>

001025c2 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $168
  1025c4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025c9:	e9 80 f9 ff ff       	jmp    101f4e <__alltraps>

001025ce <vector169>:
.globl vector169
vector169:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $169
  1025d0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025d5:	e9 74 f9 ff ff       	jmp    101f4e <__alltraps>

001025da <vector170>:
.globl vector170
vector170:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $170
  1025dc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025e1:	e9 68 f9 ff ff       	jmp    101f4e <__alltraps>

001025e6 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $171
  1025e8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025ed:	e9 5c f9 ff ff       	jmp    101f4e <__alltraps>

001025f2 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $172
  1025f4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025f9:	e9 50 f9 ff ff       	jmp    101f4e <__alltraps>

001025fe <vector173>:
.globl vector173
vector173:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $173
  102600:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102605:	e9 44 f9 ff ff       	jmp    101f4e <__alltraps>

0010260a <vector174>:
.globl vector174
vector174:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $174
  10260c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102611:	e9 38 f9 ff ff       	jmp    101f4e <__alltraps>

00102616 <vector175>:
.globl vector175
vector175:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $175
  102618:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10261d:	e9 2c f9 ff ff       	jmp    101f4e <__alltraps>

00102622 <vector176>:
.globl vector176
vector176:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $176
  102624:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102629:	e9 20 f9 ff ff       	jmp    101f4e <__alltraps>

0010262e <vector177>:
.globl vector177
vector177:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $177
  102630:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102635:	e9 14 f9 ff ff       	jmp    101f4e <__alltraps>

0010263a <vector178>:
.globl vector178
vector178:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $178
  10263c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102641:	e9 08 f9 ff ff       	jmp    101f4e <__alltraps>

00102646 <vector179>:
.globl vector179
vector179:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $179
  102648:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10264d:	e9 fc f8 ff ff       	jmp    101f4e <__alltraps>

00102652 <vector180>:
.globl vector180
vector180:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $180
  102654:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102659:	e9 f0 f8 ff ff       	jmp    101f4e <__alltraps>

0010265e <vector181>:
.globl vector181
vector181:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $181
  102660:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102665:	e9 e4 f8 ff ff       	jmp    101f4e <__alltraps>

0010266a <vector182>:
.globl vector182
vector182:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $182
  10266c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102671:	e9 d8 f8 ff ff       	jmp    101f4e <__alltraps>

00102676 <vector183>:
.globl vector183
vector183:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $183
  102678:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10267d:	e9 cc f8 ff ff       	jmp    101f4e <__alltraps>

00102682 <vector184>:
.globl vector184
vector184:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $184
  102684:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102689:	e9 c0 f8 ff ff       	jmp    101f4e <__alltraps>

0010268e <vector185>:
.globl vector185
vector185:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $185
  102690:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102695:	e9 b4 f8 ff ff       	jmp    101f4e <__alltraps>

0010269a <vector186>:
.globl vector186
vector186:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $186
  10269c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026a1:	e9 a8 f8 ff ff       	jmp    101f4e <__alltraps>

001026a6 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $187
  1026a8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026ad:	e9 9c f8 ff ff       	jmp    101f4e <__alltraps>

001026b2 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $188
  1026b4:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026b9:	e9 90 f8 ff ff       	jmp    101f4e <__alltraps>

001026be <vector189>:
.globl vector189
vector189:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $189
  1026c0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026c5:	e9 84 f8 ff ff       	jmp    101f4e <__alltraps>

001026ca <vector190>:
.globl vector190
vector190:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $190
  1026cc:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026d1:	e9 78 f8 ff ff       	jmp    101f4e <__alltraps>

001026d6 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $191
  1026d8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026dd:	e9 6c f8 ff ff       	jmp    101f4e <__alltraps>

001026e2 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $192
  1026e4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026e9:	e9 60 f8 ff ff       	jmp    101f4e <__alltraps>

001026ee <vector193>:
.globl vector193
vector193:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $193
  1026f0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026f5:	e9 54 f8 ff ff       	jmp    101f4e <__alltraps>

001026fa <vector194>:
.globl vector194
vector194:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $194
  1026fc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102701:	e9 48 f8 ff ff       	jmp    101f4e <__alltraps>

00102706 <vector195>:
.globl vector195
vector195:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $195
  102708:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10270d:	e9 3c f8 ff ff       	jmp    101f4e <__alltraps>

00102712 <vector196>:
.globl vector196
vector196:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $196
  102714:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102719:	e9 30 f8 ff ff       	jmp    101f4e <__alltraps>

0010271e <vector197>:
.globl vector197
vector197:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $197
  102720:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102725:	e9 24 f8 ff ff       	jmp    101f4e <__alltraps>

0010272a <vector198>:
.globl vector198
vector198:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $198
  10272c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102731:	e9 18 f8 ff ff       	jmp    101f4e <__alltraps>

00102736 <vector199>:
.globl vector199
vector199:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $199
  102738:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10273d:	e9 0c f8 ff ff       	jmp    101f4e <__alltraps>

00102742 <vector200>:
.globl vector200
vector200:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $200
  102744:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102749:	e9 00 f8 ff ff       	jmp    101f4e <__alltraps>

0010274e <vector201>:
.globl vector201
vector201:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $201
  102750:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102755:	e9 f4 f7 ff ff       	jmp    101f4e <__alltraps>

0010275a <vector202>:
.globl vector202
vector202:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $202
  10275c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102761:	e9 e8 f7 ff ff       	jmp    101f4e <__alltraps>

00102766 <vector203>:
.globl vector203
vector203:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $203
  102768:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10276d:	e9 dc f7 ff ff       	jmp    101f4e <__alltraps>

00102772 <vector204>:
.globl vector204
vector204:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $204
  102774:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102779:	e9 d0 f7 ff ff       	jmp    101f4e <__alltraps>

0010277e <vector205>:
.globl vector205
vector205:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $205
  102780:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102785:	e9 c4 f7 ff ff       	jmp    101f4e <__alltraps>

0010278a <vector206>:
.globl vector206
vector206:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $206
  10278c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102791:	e9 b8 f7 ff ff       	jmp    101f4e <__alltraps>

00102796 <vector207>:
.globl vector207
vector207:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $207
  102798:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10279d:	e9 ac f7 ff ff       	jmp    101f4e <__alltraps>

001027a2 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $208
  1027a4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027a9:	e9 a0 f7 ff ff       	jmp    101f4e <__alltraps>

001027ae <vector209>:
.globl vector209
vector209:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $209
  1027b0:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027b5:	e9 94 f7 ff ff       	jmp    101f4e <__alltraps>

001027ba <vector210>:
.globl vector210
vector210:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $210
  1027bc:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027c1:	e9 88 f7 ff ff       	jmp    101f4e <__alltraps>

001027c6 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $211
  1027c8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027cd:	e9 7c f7 ff ff       	jmp    101f4e <__alltraps>

001027d2 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $212
  1027d4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027d9:	e9 70 f7 ff ff       	jmp    101f4e <__alltraps>

001027de <vector213>:
.globl vector213
vector213:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $213
  1027e0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027e5:	e9 64 f7 ff ff       	jmp    101f4e <__alltraps>

001027ea <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $214
  1027ec:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027f1:	e9 58 f7 ff ff       	jmp    101f4e <__alltraps>

001027f6 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $215
  1027f8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027fd:	e9 4c f7 ff ff       	jmp    101f4e <__alltraps>

00102802 <vector216>:
.globl vector216
vector216:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $216
  102804:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102809:	e9 40 f7 ff ff       	jmp    101f4e <__alltraps>

0010280e <vector217>:
.globl vector217
vector217:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $217
  102810:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102815:	e9 34 f7 ff ff       	jmp    101f4e <__alltraps>

0010281a <vector218>:
.globl vector218
vector218:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $218
  10281c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102821:	e9 28 f7 ff ff       	jmp    101f4e <__alltraps>

00102826 <vector219>:
.globl vector219
vector219:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $219
  102828:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10282d:	e9 1c f7 ff ff       	jmp    101f4e <__alltraps>

00102832 <vector220>:
.globl vector220
vector220:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $220
  102834:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102839:	e9 10 f7 ff ff       	jmp    101f4e <__alltraps>

0010283e <vector221>:
.globl vector221
vector221:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $221
  102840:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102845:	e9 04 f7 ff ff       	jmp    101f4e <__alltraps>

0010284a <vector222>:
.globl vector222
vector222:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $222
  10284c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102851:	e9 f8 f6 ff ff       	jmp    101f4e <__alltraps>

00102856 <vector223>:
.globl vector223
vector223:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $223
  102858:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10285d:	e9 ec f6 ff ff       	jmp    101f4e <__alltraps>

00102862 <vector224>:
.globl vector224
vector224:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $224
  102864:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102869:	e9 e0 f6 ff ff       	jmp    101f4e <__alltraps>

0010286e <vector225>:
.globl vector225
vector225:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $225
  102870:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102875:	e9 d4 f6 ff ff       	jmp    101f4e <__alltraps>

0010287a <vector226>:
.globl vector226
vector226:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $226
  10287c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102881:	e9 c8 f6 ff ff       	jmp    101f4e <__alltraps>

00102886 <vector227>:
.globl vector227
vector227:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $227
  102888:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10288d:	e9 bc f6 ff ff       	jmp    101f4e <__alltraps>

00102892 <vector228>:
.globl vector228
vector228:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $228
  102894:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102899:	e9 b0 f6 ff ff       	jmp    101f4e <__alltraps>

0010289e <vector229>:
.globl vector229
vector229:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $229
  1028a0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028a5:	e9 a4 f6 ff ff       	jmp    101f4e <__alltraps>

001028aa <vector230>:
.globl vector230
vector230:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $230
  1028ac:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028b1:	e9 98 f6 ff ff       	jmp    101f4e <__alltraps>

001028b6 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $231
  1028b8:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028bd:	e9 8c f6 ff ff       	jmp    101f4e <__alltraps>

001028c2 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $232
  1028c4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028c9:	e9 80 f6 ff ff       	jmp    101f4e <__alltraps>

001028ce <vector233>:
.globl vector233
vector233:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $233
  1028d0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028d5:	e9 74 f6 ff ff       	jmp    101f4e <__alltraps>

001028da <vector234>:
.globl vector234
vector234:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $234
  1028dc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028e1:	e9 68 f6 ff ff       	jmp    101f4e <__alltraps>

001028e6 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $235
  1028e8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028ed:	e9 5c f6 ff ff       	jmp    101f4e <__alltraps>

001028f2 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $236
  1028f4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028f9:	e9 50 f6 ff ff       	jmp    101f4e <__alltraps>

001028fe <vector237>:
.globl vector237
vector237:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $237
  102900:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102905:	e9 44 f6 ff ff       	jmp    101f4e <__alltraps>

0010290a <vector238>:
.globl vector238
vector238:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $238
  10290c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102911:	e9 38 f6 ff ff       	jmp    101f4e <__alltraps>

00102916 <vector239>:
.globl vector239
vector239:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $239
  102918:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10291d:	e9 2c f6 ff ff       	jmp    101f4e <__alltraps>

00102922 <vector240>:
.globl vector240
vector240:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $240
  102924:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102929:	e9 20 f6 ff ff       	jmp    101f4e <__alltraps>

0010292e <vector241>:
.globl vector241
vector241:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $241
  102930:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102935:	e9 14 f6 ff ff       	jmp    101f4e <__alltraps>

0010293a <vector242>:
.globl vector242
vector242:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $242
  10293c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102941:	e9 08 f6 ff ff       	jmp    101f4e <__alltraps>

00102946 <vector243>:
.globl vector243
vector243:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $243
  102948:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10294d:	e9 fc f5 ff ff       	jmp    101f4e <__alltraps>

00102952 <vector244>:
.globl vector244
vector244:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $244
  102954:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102959:	e9 f0 f5 ff ff       	jmp    101f4e <__alltraps>

0010295e <vector245>:
.globl vector245
vector245:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $245
  102960:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102965:	e9 e4 f5 ff ff       	jmp    101f4e <__alltraps>

0010296a <vector246>:
.globl vector246
vector246:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $246
  10296c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102971:	e9 d8 f5 ff ff       	jmp    101f4e <__alltraps>

00102976 <vector247>:
.globl vector247
vector247:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $247
  102978:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10297d:	e9 cc f5 ff ff       	jmp    101f4e <__alltraps>

00102982 <vector248>:
.globl vector248
vector248:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $248
  102984:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102989:	e9 c0 f5 ff ff       	jmp    101f4e <__alltraps>

0010298e <vector249>:
.globl vector249
vector249:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $249
  102990:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102995:	e9 b4 f5 ff ff       	jmp    101f4e <__alltraps>

0010299a <vector250>:
.globl vector250
vector250:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $250
  10299c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029a1:	e9 a8 f5 ff ff       	jmp    101f4e <__alltraps>

001029a6 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $251
  1029a8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029ad:	e9 9c f5 ff ff       	jmp    101f4e <__alltraps>

001029b2 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $252
  1029b4:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029b9:	e9 90 f5 ff ff       	jmp    101f4e <__alltraps>

001029be <vector253>:
.globl vector253
vector253:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $253
  1029c0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029c5:	e9 84 f5 ff ff       	jmp    101f4e <__alltraps>

001029ca <vector254>:
.globl vector254
vector254:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $254
  1029cc:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029d1:	e9 78 f5 ff ff       	jmp    101f4e <__alltraps>

001029d6 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $255
  1029d8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029dd:	e9 6c f5 ff ff       	jmp    101f4e <__alltraps>

001029e2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029e2:	55                   	push   %ebp
  1029e3:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1029e5:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  1029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ee:	29 d0                	sub    %edx,%eax
  1029f0:	c1 f8 02             	sar    $0x2,%eax
  1029f3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1029f9:	5d                   	pop    %ebp
  1029fa:	c3                   	ret    

001029fb <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029fb:	55                   	push   %ebp
  1029fc:	89 e5                	mov    %esp,%ebp
  1029fe:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a01:	8b 45 08             	mov    0x8(%ebp),%eax
  102a04:	89 04 24             	mov    %eax,(%esp)
  102a07:	e8 d6 ff ff ff       	call   1029e2 <page2ppn>
  102a0c:	c1 e0 0c             	shl    $0xc,%eax
}
  102a0f:	89 ec                	mov    %ebp,%esp
  102a11:	5d                   	pop    %ebp
  102a12:	c3                   	ret    

00102a13 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102a13:	55                   	push   %ebp
  102a14:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a16:	8b 45 08             	mov    0x8(%ebp),%eax
  102a19:	8b 00                	mov    (%eax),%eax
}
  102a1b:	5d                   	pop    %ebp
  102a1c:	c3                   	ret    

00102a1d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a1d:	55                   	push   %ebp
  102a1e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a20:	8b 45 08             	mov    0x8(%ebp),%eax
  102a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a26:	89 10                	mov    %edx,(%eax)
}
  102a28:	90                   	nop
  102a29:	5d                   	pop    %ebp
  102a2a:	c3                   	ret    

00102a2b <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
  102a2b:	55                   	push   %ebp
  102a2c:	89 e5                	mov    %esp,%ebp
  102a2e:	83 ec 10             	sub    $0x10,%esp
  102a31:	c7 45 fc 80 be 11 00 	movl   $0x11be80,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
  102a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a3e:	89 50 04             	mov    %edx,0x4(%eax)
  102a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a44:	8b 50 04             	mov    0x4(%eax),%edx
  102a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a4a:	89 10                	mov    %edx,(%eax)
}
  102a4c:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  102a4d:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102a54:	00 00 00 
}
  102a57:	90                   	nop
  102a58:	89 ec                	mov    %ebp,%esp
  102a5a:	5d                   	pop    %ebp
  102a5b:	c3                   	ret    

00102a5c <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
  102a5c:	55                   	push   %ebp
  102a5d:	89 e5                	mov    %esp,%ebp
  102a5f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102a62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a66:	75 24                	jne    102a8c <default_init_memmap+0x30>
  102a68:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  102a6f:	00 
  102a70:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102a77:	00 
  102a78:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102a7f:	00 
  102a80:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102a87:	e8 5e e2 ff ff       	call   100cea <__panic>
    struct Page *p = base;
  102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102a92:	eb 7b                	jmp    102b0f <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
  102a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a97:	83 c0 04             	add    $0x4,%eax
  102a9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * */
static inline bool
test_bit(int nr, volatile void *addr)
{
    int oldbit;
    asm volatile("btl %2, %1; sbbl %0,%0"
  102aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aa7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102aaa:	0f a3 10             	bt     %edx,(%eax)
  102aad:	19 c0                	sbb    %eax,%eax
  102aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
                 : "=r"(oldbit)
                 : "m"(*(volatile long *)addr), "Ir"(nr));
    return oldbit != 0;
  102ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ab6:	0f 95 c0             	setne  %al
  102ab9:	0f b6 c0             	movzbl %al,%eax
  102abc:	85 c0                	test   %eax,%eax
  102abe:	75 24                	jne    102ae4 <default_init_memmap+0x88>
  102ac0:	c7 44 24 0c c1 66 10 	movl   $0x1066c1,0xc(%esp)
  102ac7:	00 
  102ac8:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102acf:	00 
  102ad0:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102ad7:	00 
  102ad8:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102adf:	e8 06 e2 ff ff       	call   100cea <__panic>
        p->flags = 0;
  102ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
  102aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
  102af8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102aff:	00 
  102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b03:	89 04 24             	mov    %eax,(%esp)
  102b06:	e8 12 ff ff ff       	call   102a1d <set_page_ref>
    for (; p != base + n; p++)
  102b0b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b12:	89 d0                	mov    %edx,%eax
  102b14:	c1 e0 02             	shl    $0x2,%eax
  102b17:	01 d0                	add    %edx,%eax
  102b19:	c1 e0 02             	shl    $0x2,%eax
  102b1c:	89 c2                	mov    %eax,%edx
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	01 d0                	add    %edx,%eax
  102b23:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102b26:	0f 85 68 ff ff ff    	jne    102a94 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
  102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2f:	83 c0 04             	add    $0x4,%eax
  102b32:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b39:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  102b3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b42:	0f ab 10             	bts    %edx,(%eax)
}
  102b45:	90                   	nop
    base->property = n;
  102b46:	8b 45 08             	mov    0x8(%ebp),%eax
  102b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b4c:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102b4f:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b58:	01 d0                	add    %edx,%eax
  102b5a:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
  102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b62:	83 c0 0c             	add    $0xc,%eax
  102b65:	c7 45 e4 80 be 11 00 	movl   $0x11be80,-0x1c(%ebp)
  102b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
  102b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b72:	8b 00                	mov    (%eax),%eax
  102b74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
  102b83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b89:	89 10                	mov    %edx,(%eax)
  102b8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b8e:	8b 10                	mov    (%eax),%edx
  102b90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b9c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ba2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102ba5:	89 10                	mov    %edx,(%eax)
}
  102ba7:	90                   	nop
}
  102ba8:	90                   	nop
}
  102ba9:	90                   	nop
  102baa:	89 ec                	mov    %ebp,%esp
  102bac:	5d                   	pop    %ebp
  102bad:	c3                   	ret    

00102bae <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  102bae:	55                   	push   %ebp
  102baf:	89 e5                	mov    %esp,%ebp
  102bb1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102bb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102bb8:	75 24                	jne    102bde <default_alloc_pages+0x30>
  102bba:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  102bc1:	00 
  102bc2:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102bc9:	00 
  102bca:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  102bd1:	00 
  102bd2:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102bd9:	e8 0c e1 ff ff       	call   100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
  102bde:	a1 88 be 11 00       	mov    0x11be88,%eax
  102be3:	39 45 08             	cmp    %eax,0x8(%ebp)
  102be6:	76 0a                	jbe    102bf2 <default_alloc_pages+0x44>
    {
        return NULL;
  102be8:	b8 00 00 00 00       	mov    $0x0,%eax
  102bed:	e9 43 01 00 00       	jmp    102d35 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  102bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102bf9:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  102c00:	eb 1c                	jmp    102c1e <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
  102c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c05:	83 e8 0c             	sub    $0xc,%eax
  102c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  102c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c0e:	8b 40 08             	mov    0x8(%eax),%eax
  102c11:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c14:	77 08                	ja     102c1e <default_alloc_pages+0x70>
        {
            page = p;
  102c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102c1c:	eb 18                	jmp    102c36 <default_alloc_pages+0x88>
  102c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c27:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c2d:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102c34:	75 cc                	jne    102c02 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
  102c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c3a:	0f 84 f2 00 00 00    	je     102d32 <default_alloc_pages+0x184>
    {
        if (page->property > n)
  102c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c43:	8b 40 08             	mov    0x8(%eax),%eax
  102c46:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c49:	0f 83 8f 00 00 00    	jae    102cde <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
  102c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c52:	89 d0                	mov    %edx,%eax
  102c54:	c1 e0 02             	shl    $0x2,%eax
  102c57:	01 d0                	add    %edx,%eax
  102c59:	c1 e0 02             	shl    $0x2,%eax
  102c5c:	89 c2                	mov    %eax,%edx
  102c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c61:	01 d0                	add    %edx,%eax
  102c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c69:	8b 40 08             	mov    0x8(%eax),%eax
  102c6c:	2b 45 08             	sub    0x8(%ebp),%eax
  102c6f:	89 c2                	mov    %eax,%edx
  102c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c74:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  102c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c7a:	83 c0 0c             	add    $0xc,%eax
  102c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c80:	83 c2 0c             	add    $0xc,%edx
  102c83:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102c86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  102c89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c8c:	8b 40 04             	mov    0x4(%eax),%eax
  102c8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c92:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102c95:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c98:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102c9b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  102c9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ca1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102ca4:	89 10                	mov    %edx,(%eax)
  102ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ca9:	8b 10                	mov    (%eax),%edx
  102cab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cae:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cb4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102cb7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cbd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102cc0:	89 10                	mov    %edx,(%eax)
}
  102cc2:	90                   	nop
}
  102cc3:	90                   	nop
            SetPageProperty(p);
  102cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cc7:	83 c0 04             	add    $0x4,%eax
  102cca:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
  102cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cda:	0f ab 10             	bts    %edx,(%eax)
}
  102cdd:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
  102cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce1:	83 c0 0c             	add    $0xc,%eax
  102ce4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  102ce7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102cea:	8b 40 04             	mov    0x4(%eax),%eax
  102ced:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cf0:	8b 12                	mov    (%edx),%edx
  102cf2:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102cf5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
  102cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cfb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102cfe:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d04:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d07:	89 10                	mov    %edx,(%eax)
}
  102d09:	90                   	nop
}
  102d0a:	90                   	nop
        nr_free -= n;
  102d0b:	a1 88 be 11 00       	mov    0x11be88,%eax
  102d10:	2b 45 08             	sub    0x8(%ebp),%eax
  102d13:	a3 88 be 11 00       	mov    %eax,0x11be88
        ClearPageProperty(page);
  102d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d1b:	83 c0 04             	add    $0x4,%eax
  102d1e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d25:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
  102d28:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d2e:	0f b3 10             	btr    %edx,(%eax)
}
  102d31:	90                   	nop
    }
    return page;
  102d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d35:	89 ec                	mov    %ebp,%esp
  102d37:	5d                   	pop    %ebp
  102d38:	c3                   	ret    

00102d39 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  102d39:	55                   	push   %ebp
  102d3a:	89 e5                	mov    %esp,%ebp
  102d3c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  102d42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d46:	75 24                	jne    102d6c <default_free_pages+0x33>
  102d48:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  102d4f:	00 
  102d50:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102d57:	00 
  102d58:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  102d5f:	00 
  102d60:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102d67:	e8 7e df ff ff       	call   100cea <__panic>
    struct Page *p = base;
  102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102d72:	e9 9d 00 00 00       	jmp    102e14 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  102d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7a:	83 c0 04             	add    $0x4,%eax
  102d7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102d84:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d8d:	0f a3 10             	bt     %edx,(%eax)
  102d90:	19 c0                	sbb    %eax,%eax
  102d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102d95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d99:	0f 95 c0             	setne  %al
  102d9c:	0f b6 c0             	movzbl %al,%eax
  102d9f:	85 c0                	test   %eax,%eax
  102da1:	75 2c                	jne    102dcf <default_free_pages+0x96>
  102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da6:	83 c0 04             	add    $0x4,%eax
  102da9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102db0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  102db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102db6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102db9:	0f a3 10             	bt     %edx,(%eax)
  102dbc:	19 c0                	sbb    %eax,%eax
  102dbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102dc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102dc5:	0f 95 c0             	setne  %al
  102dc8:	0f b6 c0             	movzbl %al,%eax
  102dcb:	85 c0                	test   %eax,%eax
  102dcd:	74 24                	je     102df3 <default_free_pages+0xba>
  102dcf:	c7 44 24 0c d4 66 10 	movl   $0x1066d4,0xc(%esp)
  102dd6:	00 
  102dd7:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102dde:	00 
  102ddf:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102de6:	00 
  102de7:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102dee:	e8 f7 de ff ff       	call   100cea <__panic>
        p->flags = 0;
  102df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102dfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e04:	00 
  102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e08:	89 04 24             	mov    %eax,(%esp)
  102e0b:	e8 0d fc ff ff       	call   102a1d <set_page_ref>
    for (; p != base + n; p++)
  102e10:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e17:	89 d0                	mov    %edx,%eax
  102e19:	c1 e0 02             	shl    $0x2,%eax
  102e1c:	01 d0                	add    %edx,%eax
  102e1e:	c1 e0 02             	shl    $0x2,%eax
  102e21:	89 c2                	mov    %eax,%edx
  102e23:	8b 45 08             	mov    0x8(%ebp),%eax
  102e26:	01 d0                	add    %edx,%eax
  102e28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e2b:	0f 85 46 ff ff ff    	jne    102d77 <default_free_pages+0x3e>
    }
    base->property = n;
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e37:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3d:	83 c0 04             	add    $0x4,%eax
  102e40:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102e47:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
  102e4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e4d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e50:	0f ab 10             	bts    %edx,(%eax)
}
  102e53:	90                   	nop
  102e54:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
    return listelm->next;
  102e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102e5e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
  102e64:	e9 0e 01 00 00       	jmp    102f77 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
  102e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e6c:	83 e8 0c             	sub    $0xc,%eax
  102e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e75:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102e78:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e7b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
  102e81:	8b 45 08             	mov    0x8(%ebp),%eax
  102e84:	8b 50 08             	mov    0x8(%eax),%edx
  102e87:	89 d0                	mov    %edx,%eax
  102e89:	c1 e0 02             	shl    $0x2,%eax
  102e8c:	01 d0                	add    %edx,%eax
  102e8e:	c1 e0 02             	shl    $0x2,%eax
  102e91:	89 c2                	mov    %eax,%edx
  102e93:	8b 45 08             	mov    0x8(%ebp),%eax
  102e96:	01 d0                	add    %edx,%eax
  102e98:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e9b:	75 5d                	jne    102efa <default_free_pages+0x1c1>
        {
            base->property += p->property;
  102e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea0:	8b 50 08             	mov    0x8(%eax),%edx
  102ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea6:	8b 40 08             	mov    0x8(%eax),%eax
  102ea9:	01 c2                	add    %eax,%edx
  102eab:	8b 45 08             	mov    0x8(%ebp),%eax
  102eae:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb4:	83 c0 04             	add    $0x4,%eax
  102eb7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102ebe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
  102ec1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ec4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102ec7:	0f b3 10             	btr    %edx,(%eax)
}
  102eca:	90                   	nop
            list_del(&(p->page_link));
  102ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ece:	83 c0 0c             	add    $0xc,%eax
  102ed1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102ed4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ed7:	8b 40 04             	mov    0x4(%eax),%eax
  102eda:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102edd:	8b 12                	mov    (%edx),%edx
  102edf:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102ee2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  102ee5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ee8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102eeb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102eee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ef1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ef4:	89 10                	mov    %edx,(%eax)
}
  102ef6:	90                   	nop
}
  102ef7:	90                   	nop
  102ef8:	eb 7d                	jmp    102f77 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
  102efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efd:	8b 50 08             	mov    0x8(%eax),%edx
  102f00:	89 d0                	mov    %edx,%eax
  102f02:	c1 e0 02             	shl    $0x2,%eax
  102f05:	01 d0                	add    %edx,%eax
  102f07:	c1 e0 02             	shl    $0x2,%eax
  102f0a:	89 c2                	mov    %eax,%edx
  102f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f0f:	01 d0                	add    %edx,%eax
  102f11:	39 45 08             	cmp    %eax,0x8(%ebp)
  102f14:	75 61                	jne    102f77 <default_free_pages+0x23e>
        {
            p->property += base->property;
  102f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f19:	8b 50 08             	mov    0x8(%eax),%edx
  102f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1f:	8b 40 08             	mov    0x8(%eax),%eax
  102f22:	01 c2                	add    %eax,%edx
  102f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f27:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2d:	83 c0 04             	add    $0x4,%eax
  102f30:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102f37:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
  102f3a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f3d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f40:	0f b3 10             	btr    %edx,(%eax)
}
  102f43:	90                   	nop
            base = p;
  102f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f47:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4d:	83 c0 0c             	add    $0xc,%eax
  102f50:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f53:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f56:	8b 40 04             	mov    0x4(%eax),%eax
  102f59:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102f5c:	8b 12                	mov    (%edx),%edx
  102f5e:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102f61:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102f64:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f67:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f6a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f6d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f70:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102f73:	89 10                	mov    %edx,(%eax)
}
  102f75:	90                   	nop
}
  102f76:	90                   	nop
    while (le != &free_list)
  102f77:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102f7e:	0f 85 e5 fe ff ff    	jne    102e69 <default_free_pages+0x130>
        }
    }
    le = &free_list;
  102f84:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
  102f8b:	eb 25                	jmp    102fb2 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
  102f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f90:	83 e8 0c             	sub    $0xc,%eax
  102f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
  102f96:	8b 45 08             	mov    0x8(%ebp),%eax
  102f99:	8b 50 08             	mov    0x8(%eax),%edx
  102f9c:	89 d0                	mov    %edx,%eax
  102f9e:	c1 e0 02             	shl    $0x2,%eax
  102fa1:	01 d0                	add    %edx,%eax
  102fa3:	c1 e0 02             	shl    $0x2,%eax
  102fa6:	89 c2                	mov    %eax,%edx
  102fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fab:	01 d0                	add    %edx,%eax
  102fad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102fb0:	73 1a                	jae    102fcc <default_free_pages+0x293>
  102fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb5:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  102fb8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102fbb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc1:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102fc8:	75 c3                	jne    102f8d <default_free_pages+0x254>
  102fca:	eb 01                	jmp    102fcd <default_free_pages+0x294>
        {
            break;
  102fcc:	90                   	nop
        }
    }
    nr_free += n;
  102fcd:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd6:	01 d0                	add    %edx,%eax
  102fd8:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(le, &(base->page_link));
  102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe0:	8d 50 0c             	lea    0xc(%eax),%edx
  102fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fe6:	89 45 98             	mov    %eax,-0x68(%ebp)
  102fe9:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102fec:	8b 45 98             	mov    -0x68(%ebp),%eax
  102fef:	8b 00                	mov    (%eax),%eax
  102ff1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102ff4:	89 55 90             	mov    %edx,-0x70(%ebp)
  102ff7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  102ffa:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ffd:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
  103000:	8b 45 88             	mov    -0x78(%ebp),%eax
  103003:	8b 55 90             	mov    -0x70(%ebp),%edx
  103006:	89 10                	mov    %edx,(%eax)
  103008:	8b 45 88             	mov    -0x78(%ebp),%eax
  10300b:	8b 10                	mov    (%eax),%edx
  10300d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103010:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103013:	8b 45 90             	mov    -0x70(%ebp),%eax
  103016:	8b 55 88             	mov    -0x78(%ebp),%edx
  103019:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10301c:	8b 45 90             	mov    -0x70(%ebp),%eax
  10301f:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103022:	89 10                	mov    %edx,(%eax)
}
  103024:	90                   	nop
}
  103025:	90                   	nop
}
  103026:	90                   	nop
  103027:	89 ec                	mov    %ebp,%esp
  103029:	5d                   	pop    %ebp
  10302a:	c3                   	ret    

0010302b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  10302b:	55                   	push   %ebp
  10302c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10302e:	a1 88 be 11 00       	mov    0x11be88,%eax
}
  103033:	5d                   	pop    %ebp
  103034:	c3                   	ret    

00103035 <basic_check>:

static void
basic_check(void)
{
  103035:	55                   	push   %ebp
  103036:	89 e5                	mov    %esp,%ebp
  103038:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10303b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103045:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10304e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103055:	e8 df 0e 00 00       	call   103f39 <alloc_pages>
  10305a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10305d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103061:	75 24                	jne    103087 <basic_check+0x52>
  103063:	c7 44 24 0c f9 66 10 	movl   $0x1066f9,0xc(%esp)
  10306a:	00 
  10306b:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103072:	00 
  103073:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10307a:	00 
  10307b:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103082:	e8 63 dc ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  103087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10308e:	e8 a6 0e 00 00       	call   103f39 <alloc_pages>
  103093:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103096:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10309a:	75 24                	jne    1030c0 <basic_check+0x8b>
  10309c:	c7 44 24 0c 15 67 10 	movl   $0x106715,0xc(%esp)
  1030a3:	00 
  1030a4:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1030ab:	00 
  1030ac:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1030b3:	00 
  1030b4:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1030bb:	e8 2a dc ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030c7:	e8 6d 0e 00 00       	call   103f39 <alloc_pages>
  1030cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030d3:	75 24                	jne    1030f9 <basic_check+0xc4>
  1030d5:	c7 44 24 0c 31 67 10 	movl   $0x106731,0xc(%esp)
  1030dc:	00 
  1030dd:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1030e4:	00 
  1030e5:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1030ec:	00 
  1030ed:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1030f4:	e8 f1 db ff ff       	call   100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1030f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030ff:	74 10                	je     103111 <basic_check+0xdc>
  103101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103104:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103107:	74 08                	je     103111 <basic_check+0xdc>
  103109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10310c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10310f:	75 24                	jne    103135 <basic_check+0x100>
  103111:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  103118:	00 
  103119:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103120:	00 
  103121:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103128:	00 
  103129:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103130:	e8 b5 db ff ff       	call   100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103138:	89 04 24             	mov    %eax,(%esp)
  10313b:	e8 d3 f8 ff ff       	call   102a13 <page_ref>
  103140:	85 c0                	test   %eax,%eax
  103142:	75 1e                	jne    103162 <basic_check+0x12d>
  103144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103147:	89 04 24             	mov    %eax,(%esp)
  10314a:	e8 c4 f8 ff ff       	call   102a13 <page_ref>
  10314f:	85 c0                	test   %eax,%eax
  103151:	75 0f                	jne    103162 <basic_check+0x12d>
  103153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103156:	89 04 24             	mov    %eax,(%esp)
  103159:	e8 b5 f8 ff ff       	call   102a13 <page_ref>
  10315e:	85 c0                	test   %eax,%eax
  103160:	74 24                	je     103186 <basic_check+0x151>
  103162:	c7 44 24 0c 74 67 10 	movl   $0x106774,0xc(%esp)
  103169:	00 
  10316a:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103171:	00 
  103172:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103179:	00 
  10317a:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103181:	e8 64 db ff ff       	call   100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103189:	89 04 24             	mov    %eax,(%esp)
  10318c:	e8 6a f8 ff ff       	call   1029fb <page2pa>
  103191:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  103197:	c1 e2 0c             	shl    $0xc,%edx
  10319a:	39 d0                	cmp    %edx,%eax
  10319c:	72 24                	jb     1031c2 <basic_check+0x18d>
  10319e:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  1031a5:	00 
  1031a6:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1031ad:	00 
  1031ae:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1031b5:	00 
  1031b6:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1031bd:	e8 28 db ff ff       	call   100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c5:	89 04 24             	mov    %eax,(%esp)
  1031c8:	e8 2e f8 ff ff       	call   1029fb <page2pa>
  1031cd:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1031d3:	c1 e2 0c             	shl    $0xc,%edx
  1031d6:	39 d0                	cmp    %edx,%eax
  1031d8:	72 24                	jb     1031fe <basic_check+0x1c9>
  1031da:	c7 44 24 0c cd 67 10 	movl   $0x1067cd,0xc(%esp)
  1031e1:	00 
  1031e2:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1031e9:	00 
  1031ea:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  1031f1:	00 
  1031f2:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1031f9:	e8 ec da ff ff       	call   100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103201:	89 04 24             	mov    %eax,(%esp)
  103204:	e8 f2 f7 ff ff       	call   1029fb <page2pa>
  103209:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  10320f:	c1 e2 0c             	shl    $0xc,%edx
  103212:	39 d0                	cmp    %edx,%eax
  103214:	72 24                	jb     10323a <basic_check+0x205>
  103216:	c7 44 24 0c ea 67 10 	movl   $0x1067ea,0xc(%esp)
  10321d:	00 
  10321e:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103225:	00 
  103226:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  10322d:	00 
  10322e:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103235:	e8 b0 da ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  10323a:	a1 80 be 11 00       	mov    0x11be80,%eax
  10323f:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103245:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103248:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10324b:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103255:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103258:	89 50 04             	mov    %edx,0x4(%eax)
  10325b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10325e:	8b 50 04             	mov    0x4(%eax),%edx
  103261:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103264:	89 10                	mov    %edx,(%eax)
}
  103266:	90                   	nop
  103267:	c7 45 e0 80 be 11 00 	movl   $0x11be80,-0x20(%ebp)
    return list->next == list;
  10326e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103271:	8b 40 04             	mov    0x4(%eax),%eax
  103274:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103277:	0f 94 c0             	sete   %al
  10327a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10327d:	85 c0                	test   %eax,%eax
  10327f:	75 24                	jne    1032a5 <basic_check+0x270>
  103281:	c7 44 24 0c 07 68 10 	movl   $0x106807,0xc(%esp)
  103288:	00 
  103289:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103290:	00 
  103291:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103298:	00 
  103299:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1032a0:	e8 45 da ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  1032a5:	a1 88 be 11 00       	mov    0x11be88,%eax
  1032aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032ad:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1032b4:	00 00 00 

    assert(alloc_page() == NULL);
  1032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032be:	e8 76 0c 00 00       	call   103f39 <alloc_pages>
  1032c3:	85 c0                	test   %eax,%eax
  1032c5:	74 24                	je     1032eb <basic_check+0x2b6>
  1032c7:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  1032ce:	00 
  1032cf:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1032d6:	00 
  1032d7:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1032de:	00 
  1032df:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1032e6:	e8 ff d9 ff ff       	call   100cea <__panic>

    free_page(p0);
  1032eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032f2:	00 
  1032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032f6:	89 04 24             	mov    %eax,(%esp)
  1032f9:	e8 75 0c 00 00       	call   103f73 <free_pages>
    free_page(p1);
  1032fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103305:	00 
  103306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103309:	89 04 24             	mov    %eax,(%esp)
  10330c:	e8 62 0c 00 00       	call   103f73 <free_pages>
    free_page(p2);
  103311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103318:	00 
  103319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10331c:	89 04 24             	mov    %eax,(%esp)
  10331f:	e8 4f 0c 00 00       	call   103f73 <free_pages>
    assert(nr_free == 3);
  103324:	a1 88 be 11 00       	mov    0x11be88,%eax
  103329:	83 f8 03             	cmp    $0x3,%eax
  10332c:	74 24                	je     103352 <basic_check+0x31d>
  10332e:	c7 44 24 0c 33 68 10 	movl   $0x106833,0xc(%esp)
  103335:	00 
  103336:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10333d:	00 
  10333e:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103345:	00 
  103346:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10334d:	e8 98 d9 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
  103352:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103359:	e8 db 0b 00 00       	call   103f39 <alloc_pages>
  10335e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103361:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103365:	75 24                	jne    10338b <basic_check+0x356>
  103367:	c7 44 24 0c f9 66 10 	movl   $0x1066f9,0xc(%esp)
  10336e:	00 
  10336f:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103376:	00 
  103377:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10337e:	00 
  10337f:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103386:	e8 5f d9 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
  10338b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103392:	e8 a2 0b 00 00       	call   103f39 <alloc_pages>
  103397:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10339a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10339e:	75 24                	jne    1033c4 <basic_check+0x38f>
  1033a0:	c7 44 24 0c 15 67 10 	movl   $0x106715,0xc(%esp)
  1033a7:	00 
  1033a8:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1033af:	00 
  1033b0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1033b7:	00 
  1033b8:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1033bf:	e8 26 d9 ff ff       	call   100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033cb:	e8 69 0b 00 00       	call   103f39 <alloc_pages>
  1033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033d7:	75 24                	jne    1033fd <basic_check+0x3c8>
  1033d9:	c7 44 24 0c 31 67 10 	movl   $0x106731,0xc(%esp)
  1033e0:	00 
  1033e1:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1033e8:	00 
  1033e9:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1033f0:	00 
  1033f1:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1033f8:	e8 ed d8 ff ff       	call   100cea <__panic>

    assert(alloc_page() == NULL);
  1033fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103404:	e8 30 0b 00 00       	call   103f39 <alloc_pages>
  103409:	85 c0                	test   %eax,%eax
  10340b:	74 24                	je     103431 <basic_check+0x3fc>
  10340d:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  103414:	00 
  103415:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10341c:	00 
  10341d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  103424:	00 
  103425:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10342c:	e8 b9 d8 ff ff       	call   100cea <__panic>

    free_page(p0);
  103431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103438:	00 
  103439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10343c:	89 04 24             	mov    %eax,(%esp)
  10343f:	e8 2f 0b 00 00       	call   103f73 <free_pages>
  103444:	c7 45 d8 80 be 11 00 	movl   $0x11be80,-0x28(%ebp)
  10344b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10344e:	8b 40 04             	mov    0x4(%eax),%eax
  103451:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103454:	0f 94 c0             	sete   %al
  103457:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10345a:	85 c0                	test   %eax,%eax
  10345c:	74 24                	je     103482 <basic_check+0x44d>
  10345e:	c7 44 24 0c 40 68 10 	movl   $0x106840,0xc(%esp)
  103465:	00 
  103466:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10346d:	00 
  10346e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103475:	00 
  103476:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10347d:	e8 68 d8 ff ff       	call   100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103489:	e8 ab 0a 00 00       	call   103f39 <alloc_pages>
  10348e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103494:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103497:	74 24                	je     1034bd <basic_check+0x488>
  103499:	c7 44 24 0c 58 68 10 	movl   $0x106858,0xc(%esp)
  1034a0:	00 
  1034a1:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1034a8:	00 
  1034a9:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1034b0:	00 
  1034b1:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1034b8:	e8 2d d8 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  1034bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034c4:	e8 70 0a 00 00       	call   103f39 <alloc_pages>
  1034c9:	85 c0                	test   %eax,%eax
  1034cb:	74 24                	je     1034f1 <basic_check+0x4bc>
  1034cd:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  1034d4:	00 
  1034d5:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1034dc:	00 
  1034dd:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1034e4:	00 
  1034e5:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1034ec:	e8 f9 d7 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  1034f1:	a1 88 be 11 00       	mov    0x11be88,%eax
  1034f6:	85 c0                	test   %eax,%eax
  1034f8:	74 24                	je     10351e <basic_check+0x4e9>
  1034fa:	c7 44 24 0c 71 68 10 	movl   $0x106871,0xc(%esp)
  103501:	00 
  103502:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103509:	00 
  10350a:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103511:	00 
  103512:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103519:	e8 cc d7 ff ff       	call   100cea <__panic>
    free_list = free_list_store;
  10351e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103521:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103524:	a3 80 be 11 00       	mov    %eax,0x11be80
  103529:	89 15 84 be 11 00    	mov    %edx,0x11be84
    nr_free = nr_free_store;
  10352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103532:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_page(p);
  103537:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10353e:	00 
  10353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103542:	89 04 24             	mov    %eax,(%esp)
  103545:	e8 29 0a 00 00       	call   103f73 <free_pages>
    free_page(p1);
  10354a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103551:	00 
  103552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103555:	89 04 24             	mov    %eax,(%esp)
  103558:	e8 16 0a 00 00       	call   103f73 <free_pages>
    free_page(p2);
  10355d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103564:	00 
  103565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103568:	89 04 24             	mov    %eax,(%esp)
  10356b:	e8 03 0a 00 00       	call   103f73 <free_pages>
}
  103570:	90                   	nop
  103571:	89 ec                	mov    %ebp,%esp
  103573:	5d                   	pop    %ebp
  103574:	c3                   	ret    

00103575 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  103575:	55                   	push   %ebp
  103576:	89 e5                	mov    %esp,%ebp
  103578:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  10357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10358c:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  103593:	eb 6a                	jmp    1035ff <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
  103595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103598:	83 e8 0c             	sub    $0xc,%eax
  10359b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  10359e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035a1:	83 c0 04             	add    $0x4,%eax
  1035a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1035ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035b4:	0f a3 10             	bt     %edx,(%eax)
  1035b7:	19 c0                	sbb    %eax,%eax
  1035b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035bc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035c0:	0f 95 c0             	setne  %al
  1035c3:	0f b6 c0             	movzbl %al,%eax
  1035c6:	85 c0                	test   %eax,%eax
  1035c8:	75 24                	jne    1035ee <default_check+0x79>
  1035ca:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1035d1:	00 
  1035d2:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1035d9:	00 
  1035da:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1035e1:	00 
  1035e2:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1035e9:	e8 fc d6 ff ff       	call   100cea <__panic>
        count++, total += p->property;
  1035ee:	ff 45 f4             	incl   -0xc(%ebp)
  1035f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035f4:	8b 50 08             	mov    0x8(%eax),%edx
  1035f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035fa:	01 d0                	add    %edx,%eax
  1035fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103602:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103605:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103608:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  10360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10360e:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103615:	0f 85 7a ff ff ff    	jne    103595 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10361b:	e8 88 09 00 00       	call   103fa8 <nr_free_pages>
  103620:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103623:	39 d0                	cmp    %edx,%eax
  103625:	74 24                	je     10364b <default_check+0xd6>
  103627:	c7 44 24 0c 8e 68 10 	movl   $0x10688e,0xc(%esp)
  10362e:	00 
  10362f:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103636:	00 
  103637:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  10363e:	00 
  10363f:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103646:	e8 9f d6 ff ff       	call   100cea <__panic>

    basic_check();
  10364b:	e8 e5 f9 ff ff       	call   103035 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103650:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103657:	e8 dd 08 00 00       	call   103f39 <alloc_pages>
  10365c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10365f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103663:	75 24                	jne    103689 <default_check+0x114>
  103665:	c7 44 24 0c a7 68 10 	movl   $0x1068a7,0xc(%esp)
  10366c:	00 
  10366d:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103674:	00 
  103675:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10367c:	00 
  10367d:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103684:	e8 61 d6 ff ff       	call   100cea <__panic>
    assert(!PageProperty(p0));
  103689:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10368c:	83 c0 04             	add    $0x4,%eax
  10368f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103696:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103699:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10369c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10369f:	0f a3 10             	bt     %edx,(%eax)
  1036a2:	19 c0                	sbb    %eax,%eax
  1036a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036ab:	0f 95 c0             	setne  %al
  1036ae:	0f b6 c0             	movzbl %al,%eax
  1036b1:	85 c0                	test   %eax,%eax
  1036b3:	74 24                	je     1036d9 <default_check+0x164>
  1036b5:	c7 44 24 0c b2 68 10 	movl   $0x1068b2,0xc(%esp)
  1036bc:	00 
  1036bd:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1036c4:	00 
  1036c5:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1036cc:	00 
  1036cd:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1036d4:	e8 11 d6 ff ff       	call   100cea <__panic>

    list_entry_t free_list_store = free_list;
  1036d9:	a1 80 be 11 00       	mov    0x11be80,%eax
  1036de:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  1036e4:	89 45 80             	mov    %eax,-0x80(%ebp)
  1036e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1036ea:	c7 45 b0 80 be 11 00 	movl   $0x11be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1036f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1036f7:	89 50 04             	mov    %edx,0x4(%eax)
  1036fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036fd:	8b 50 04             	mov    0x4(%eax),%edx
  103700:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103703:	89 10                	mov    %edx,(%eax)
}
  103705:	90                   	nop
  103706:	c7 45 b4 80 be 11 00 	movl   $0x11be80,-0x4c(%ebp)
    return list->next == list;
  10370d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103710:	8b 40 04             	mov    0x4(%eax),%eax
  103713:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103716:	0f 94 c0             	sete   %al
  103719:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10371c:	85 c0                	test   %eax,%eax
  10371e:	75 24                	jne    103744 <default_check+0x1cf>
  103720:	c7 44 24 0c 07 68 10 	movl   $0x106807,0xc(%esp)
  103727:	00 
  103728:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10372f:	00 
  103730:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103737:	00 
  103738:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10373f:	e8 a6 d5 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10374b:	e8 e9 07 00 00       	call   103f39 <alloc_pages>
  103750:	85 c0                	test   %eax,%eax
  103752:	74 24                	je     103778 <default_check+0x203>
  103754:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  10375b:	00 
  10375c:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103763:	00 
  103764:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  10376b:	00 
  10376c:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103773:	e8 72 d5 ff ff       	call   100cea <__panic>

    unsigned int nr_free_store = nr_free;
  103778:	a1 88 be 11 00       	mov    0x11be88,%eax
  10377d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  103780:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  103787:	00 00 00 

    free_pages(p0 + 2, 3);
  10378a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10378d:	83 c0 28             	add    $0x28,%eax
  103790:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103797:	00 
  103798:	89 04 24             	mov    %eax,(%esp)
  10379b:	e8 d3 07 00 00       	call   103f73 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037a0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037a7:	e8 8d 07 00 00       	call   103f39 <alloc_pages>
  1037ac:	85 c0                	test   %eax,%eax
  1037ae:	74 24                	je     1037d4 <default_check+0x25f>
  1037b0:	c7 44 24 0c c4 68 10 	movl   $0x1068c4,0xc(%esp)
  1037b7:	00 
  1037b8:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1037bf:	00 
  1037c0:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1037c7:	00 
  1037c8:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1037cf:	e8 16 d5 ff ff       	call   100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037d7:	83 c0 28             	add    $0x28,%eax
  1037da:	83 c0 04             	add    $0x4,%eax
  1037dd:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  1037e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1037ea:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1037ed:	0f a3 10             	bt     %edx,(%eax)
  1037f0:	19 c0                	sbb    %eax,%eax
  1037f2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1037f5:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1037f9:	0f 95 c0             	setne  %al
  1037fc:	0f b6 c0             	movzbl %al,%eax
  1037ff:	85 c0                	test   %eax,%eax
  103801:	74 0e                	je     103811 <default_check+0x29c>
  103803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103806:	83 c0 28             	add    $0x28,%eax
  103809:	8b 40 08             	mov    0x8(%eax),%eax
  10380c:	83 f8 03             	cmp    $0x3,%eax
  10380f:	74 24                	je     103835 <default_check+0x2c0>
  103811:	c7 44 24 0c dc 68 10 	movl   $0x1068dc,0xc(%esp)
  103818:	00 
  103819:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103820:	00 
  103821:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103828:	00 
  103829:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103830:	e8 b5 d4 ff ff       	call   100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103835:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10383c:	e8 f8 06 00 00       	call   103f39 <alloc_pages>
  103841:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103844:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103848:	75 24                	jne    10386e <default_check+0x2f9>
  10384a:	c7 44 24 0c 08 69 10 	movl   $0x106908,0xc(%esp)
  103851:	00 
  103852:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103859:	00 
  10385a:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103861:	00 
  103862:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103869:	e8 7c d4 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  10386e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103875:	e8 bf 06 00 00       	call   103f39 <alloc_pages>
  10387a:	85 c0                	test   %eax,%eax
  10387c:	74 24                	je     1038a2 <default_check+0x32d>
  10387e:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  103885:	00 
  103886:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10388d:	00 
  10388e:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  103895:	00 
  103896:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10389d:	e8 48 d4 ff ff       	call   100cea <__panic>
    assert(p0 + 2 == p1);
  1038a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038a5:	83 c0 28             	add    $0x28,%eax
  1038a8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1038ab:	74 24                	je     1038d1 <default_check+0x35c>
  1038ad:	c7 44 24 0c 26 69 10 	movl   $0x106926,0xc(%esp)
  1038b4:	00 
  1038b5:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1038bc:	00 
  1038bd:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1038c4:	00 
  1038c5:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1038cc:	e8 19 d4 ff ff       	call   100cea <__panic>

    p2 = p0 + 1;
  1038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038d4:	83 c0 14             	add    $0x14,%eax
  1038d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1038da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038e1:	00 
  1038e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038e5:	89 04 24             	mov    %eax,(%esp)
  1038e8:	e8 86 06 00 00       	call   103f73 <free_pages>
    free_pages(p1, 3);
  1038ed:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1038f4:	00 
  1038f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038f8:	89 04 24             	mov    %eax,(%esp)
  1038fb:	e8 73 06 00 00       	call   103f73 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103903:	83 c0 04             	add    $0x4,%eax
  103906:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10390d:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  103910:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103913:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103916:	0f a3 10             	bt     %edx,(%eax)
  103919:	19 c0                	sbb    %eax,%eax
  10391b:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10391e:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103922:	0f 95 c0             	setne  %al
  103925:	0f b6 c0             	movzbl %al,%eax
  103928:	85 c0                	test   %eax,%eax
  10392a:	74 0b                	je     103937 <default_check+0x3c2>
  10392c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10392f:	8b 40 08             	mov    0x8(%eax),%eax
  103932:	83 f8 01             	cmp    $0x1,%eax
  103935:	74 24                	je     10395b <default_check+0x3e6>
  103937:	c7 44 24 0c 34 69 10 	movl   $0x106934,0xc(%esp)
  10393e:	00 
  10393f:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103946:	00 
  103947:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10394e:	00 
  10394f:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103956:	e8 8f d3 ff ff       	call   100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10395b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10395e:	83 c0 04             	add    $0x4,%eax
  103961:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103968:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
  10396b:	8b 45 90             	mov    -0x70(%ebp),%eax
  10396e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103971:	0f a3 10             	bt     %edx,(%eax)
  103974:	19 c0                	sbb    %eax,%eax
  103976:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103979:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10397d:	0f 95 c0             	setne  %al
  103980:	0f b6 c0             	movzbl %al,%eax
  103983:	85 c0                	test   %eax,%eax
  103985:	74 0b                	je     103992 <default_check+0x41d>
  103987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10398a:	8b 40 08             	mov    0x8(%eax),%eax
  10398d:	83 f8 03             	cmp    $0x3,%eax
  103990:	74 24                	je     1039b6 <default_check+0x441>
  103992:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103999:	00 
  10399a:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1039a1:	00 
  1039a2:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1039a9:	00 
  1039aa:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1039b1:	e8 34 d3 ff ff       	call   100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039bd:	e8 77 05 00 00       	call   103f39 <alloc_pages>
  1039c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039c8:	83 e8 14             	sub    $0x14,%eax
  1039cb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039ce:	74 24                	je     1039f4 <default_check+0x47f>
  1039d0:	c7 44 24 0c 82 69 10 	movl   $0x106982,0xc(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1039df:	00 
  1039e0:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  1039e7:	00 
  1039e8:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1039ef:	e8 f6 d2 ff ff       	call   100cea <__panic>
    free_page(p0);
  1039f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039fb:	00 
  1039fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039ff:	89 04 24             	mov    %eax,(%esp)
  103a02:	e8 6c 05 00 00       	call   103f73 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a07:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a0e:	e8 26 05 00 00       	call   103f39 <alloc_pages>
  103a13:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a19:	83 c0 14             	add    $0x14,%eax
  103a1c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a1f:	74 24                	je     103a45 <default_check+0x4d0>
  103a21:	c7 44 24 0c a0 69 10 	movl   $0x1069a0,0xc(%esp)
  103a28:	00 
  103a29:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103a30:	00 
  103a31:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  103a38:	00 
  103a39:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103a40:	e8 a5 d2 ff ff       	call   100cea <__panic>

    free_pages(p0, 2);
  103a45:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a4c:	00 
  103a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a50:	89 04 24             	mov    %eax,(%esp)
  103a53:	e8 1b 05 00 00       	call   103f73 <free_pages>
    free_page(p2);
  103a58:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a5f:	00 
  103a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a63:	89 04 24             	mov    %eax,(%esp)
  103a66:	e8 08 05 00 00       	call   103f73 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a6b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a72:	e8 c2 04 00 00       	call   103f39 <alloc_pages>
  103a77:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103a7e:	75 24                	jne    103aa4 <default_check+0x52f>
  103a80:	c7 44 24 0c c0 69 10 	movl   $0x1069c0,0xc(%esp)
  103a87:	00 
  103a88:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103a8f:	00 
  103a90:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103a97:	00 
  103a98:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103a9f:	e8 46 d2 ff ff       	call   100cea <__panic>
    assert(alloc_page() == NULL);
  103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103aab:	e8 89 04 00 00       	call   103f39 <alloc_pages>
  103ab0:	85 c0                	test   %eax,%eax
  103ab2:	74 24                	je     103ad8 <default_check+0x563>
  103ab4:	c7 44 24 0c 1e 68 10 	movl   $0x10681e,0xc(%esp)
  103abb:	00 
  103abc:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103ac3:	00 
  103ac4:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  103acb:	00 
  103acc:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103ad3:	e8 12 d2 ff ff       	call   100cea <__panic>

    assert(nr_free == 0);
  103ad8:	a1 88 be 11 00       	mov    0x11be88,%eax
  103add:	85 c0                	test   %eax,%eax
  103adf:	74 24                	je     103b05 <default_check+0x590>
  103ae1:	c7 44 24 0c 71 68 10 	movl   $0x106871,0xc(%esp)
  103ae8:	00 
  103ae9:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103af0:	00 
  103af1:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  103af8:	00 
  103af9:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103b00:	e8 e5 d1 ff ff       	call   100cea <__panic>
    nr_free = nr_free_store;
  103b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b08:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_list = free_list_store;
  103b0d:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b10:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b13:	a3 80 be 11 00       	mov    %eax,0x11be80
  103b18:	89 15 84 be 11 00    	mov    %edx,0x11be84
    free_pages(p0, 5);
  103b1e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b25:	00 
  103b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b29:	89 04 24             	mov    %eax,(%esp)
  103b2c:	e8 42 04 00 00       	call   103f73 <free_pages>

    le = &free_list;
  103b31:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  103b38:	eb 5a                	jmp    103b94 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
  103b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b3d:	8b 40 04             	mov    0x4(%eax),%eax
  103b40:	8b 00                	mov    (%eax),%eax
  103b42:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b45:	75 0d                	jne    103b54 <default_check+0x5df>
  103b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b4a:	8b 00                	mov    (%eax),%eax
  103b4c:	8b 40 04             	mov    0x4(%eax),%eax
  103b4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b52:	74 24                	je     103b78 <default_check+0x603>
  103b54:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  103b5b:	00 
  103b5c:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103b63:	00 
  103b64:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  103b6b:	00 
  103b6c:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103b73:	e8 72 d1 ff ff       	call   100cea <__panic>
        struct Page *p = le2page(le, page_link);
  103b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b7b:	83 e8 0c             	sub    $0xc,%eax
  103b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  103b81:	ff 4d f4             	decl   -0xc(%ebp)
  103b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b8a:	8b 48 08             	mov    0x8(%eax),%ecx
  103b8d:	89 d0                	mov    %edx,%eax
  103b8f:	29 c8                	sub    %ecx,%eax
  103b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b97:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103b9a:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b9d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ba3:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103baa:	75 8e                	jne    103b3a <default_check+0x5c5>
    }
    assert(count == 0);
  103bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bb0:	74 24                	je     103bd6 <default_check+0x661>
  103bb2:	c7 44 24 0c 0d 6a 10 	movl   $0x106a0d,0xc(%esp)
  103bb9:	00 
  103bba:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103bc1:	00 
  103bc2:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  103bc9:	00 
  103bca:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103bd1:	e8 14 d1 ff ff       	call   100cea <__panic>
    assert(total == 0);
  103bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bda:	74 24                	je     103c00 <default_check+0x68b>
  103bdc:	c7 44 24 0c 18 6a 10 	movl   $0x106a18,0xc(%esp)
  103be3:	00 
  103be4:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103beb:	00 
  103bec:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  103bf3:	00 
  103bf4:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103bfb:	e8 ea d0 ff ff       	call   100cea <__panic>
}
  103c00:	90                   	nop
  103c01:	89 ec                	mov    %ebp,%esp
  103c03:	5d                   	pop    %ebp
  103c04:	c3                   	ret    

00103c05 <page2ppn>:
page2ppn(struct Page *page) {
  103c05:	55                   	push   %ebp
  103c06:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c08:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  103c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  103c11:	29 d0                	sub    %edx,%eax
  103c13:	c1 f8 02             	sar    $0x2,%eax
  103c16:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c1c:	5d                   	pop    %ebp
  103c1d:	c3                   	ret    

00103c1e <page2pa>:
page2pa(struct Page *page) {
  103c1e:	55                   	push   %ebp
  103c1f:	89 e5                	mov    %esp,%ebp
  103c21:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c24:	8b 45 08             	mov    0x8(%ebp),%eax
  103c27:	89 04 24             	mov    %eax,(%esp)
  103c2a:	e8 d6 ff ff ff       	call   103c05 <page2ppn>
  103c2f:	c1 e0 0c             	shl    $0xc,%eax
}
  103c32:	89 ec                	mov    %ebp,%esp
  103c34:	5d                   	pop    %ebp
  103c35:	c3                   	ret    

00103c36 <pa2page>:
pa2page(uintptr_t pa) {
  103c36:	55                   	push   %ebp
  103c37:	89 e5                	mov    %esp,%ebp
  103c39:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3f:	c1 e8 0c             	shr    $0xc,%eax
  103c42:	89 c2                	mov    %eax,%edx
  103c44:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103c49:	39 c2                	cmp    %eax,%edx
  103c4b:	72 1c                	jb     103c69 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c4d:	c7 44 24 08 54 6a 10 	movl   $0x106a54,0x8(%esp)
  103c54:	00 
  103c55:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c5c:	00 
  103c5d:	c7 04 24 73 6a 10 00 	movl   $0x106a73,(%esp)
  103c64:	e8 81 d0 ff ff       	call   100cea <__panic>
    return &pages[PPN(pa)];
  103c69:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c72:	c1 e8 0c             	shr    $0xc,%eax
  103c75:	89 c2                	mov    %eax,%edx
  103c77:	89 d0                	mov    %edx,%eax
  103c79:	c1 e0 02             	shl    $0x2,%eax
  103c7c:	01 d0                	add    %edx,%eax
  103c7e:	c1 e0 02             	shl    $0x2,%eax
  103c81:	01 c8                	add    %ecx,%eax
}
  103c83:	89 ec                	mov    %ebp,%esp
  103c85:	5d                   	pop    %ebp
  103c86:	c3                   	ret    

00103c87 <page2kva>:
page2kva(struct Page *page) {
  103c87:	55                   	push   %ebp
  103c88:	89 e5                	mov    %esp,%ebp
  103c8a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c90:	89 04 24             	mov    %eax,(%esp)
  103c93:	e8 86 ff ff ff       	call   103c1e <page2pa>
  103c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c9e:	c1 e8 0c             	shr    $0xc,%eax
  103ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ca4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103ca9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103cac:	72 23                	jb     103cd1 <page2kva+0x4a>
  103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103cb5:	c7 44 24 08 84 6a 10 	movl   $0x106a84,0x8(%esp)
  103cbc:	00 
  103cbd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103cc4:	00 
  103cc5:	c7 04 24 73 6a 10 00 	movl   $0x106a73,(%esp)
  103ccc:	e8 19 d0 ff ff       	call   100cea <__panic>
  103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cd4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103cd9:	89 ec                	mov    %ebp,%esp
  103cdb:	5d                   	pop    %ebp
  103cdc:	c3                   	ret    

00103cdd <pte2page>:
pte2page(pte_t pte) {
  103cdd:	55                   	push   %ebp
  103cde:	89 e5                	mov    %esp,%ebp
  103ce0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce6:	83 e0 01             	and    $0x1,%eax
  103ce9:	85 c0                	test   %eax,%eax
  103ceb:	75 1c                	jne    103d09 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ced:	c7 44 24 08 a8 6a 10 	movl   $0x106aa8,0x8(%esp)
  103cf4:	00 
  103cf5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cfc:	00 
  103cfd:	c7 04 24 73 6a 10 00 	movl   $0x106a73,(%esp)
  103d04:	e8 e1 cf ff ff       	call   100cea <__panic>
    return pa2page(PTE_ADDR(pte));
  103d09:	8b 45 08             	mov    0x8(%ebp),%eax
  103d0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d11:	89 04 24             	mov    %eax,(%esp)
  103d14:	e8 1d ff ff ff       	call   103c36 <pa2page>
}
  103d19:	89 ec                	mov    %ebp,%esp
  103d1b:	5d                   	pop    %ebp
  103d1c:	c3                   	ret    

00103d1d <pde2page>:
pde2page(pde_t pde) {
  103d1d:	55                   	push   %ebp
  103d1e:	89 e5                	mov    %esp,%ebp
  103d20:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d23:	8b 45 08             	mov    0x8(%ebp),%eax
  103d26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d2b:	89 04 24             	mov    %eax,(%esp)
  103d2e:	e8 03 ff ff ff       	call   103c36 <pa2page>
}
  103d33:	89 ec                	mov    %ebp,%esp
  103d35:	5d                   	pop    %ebp
  103d36:	c3                   	ret    

00103d37 <page_ref>:
page_ref(struct Page *page) {
  103d37:	55                   	push   %ebp
  103d38:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3d:	8b 00                	mov    (%eax),%eax
}
  103d3f:	5d                   	pop    %ebp
  103d40:	c3                   	ret    

00103d41 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d41:	55                   	push   %ebp
  103d42:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d44:	8b 45 08             	mov    0x8(%ebp),%eax
  103d47:	8b 00                	mov    (%eax),%eax
  103d49:	8d 50 01             	lea    0x1(%eax),%edx
  103d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d4f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d51:	8b 45 08             	mov    0x8(%ebp),%eax
  103d54:	8b 00                	mov    (%eax),%eax
}
  103d56:	5d                   	pop    %ebp
  103d57:	c3                   	ret    

00103d58 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d58:	55                   	push   %ebp
  103d59:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d5e:	8b 00                	mov    (%eax),%eax
  103d60:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d63:	8b 45 08             	mov    0x8(%ebp),%eax
  103d66:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d68:	8b 45 08             	mov    0x8(%ebp),%eax
  103d6b:	8b 00                	mov    (%eax),%eax
}
  103d6d:	5d                   	pop    %ebp
  103d6e:	c3                   	ret    

00103d6f <__intr_save>:
{
  103d6f:	55                   	push   %ebp
  103d70:	89 e5                	mov    %esp,%ebp
  103d72:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
  103d75:	9c                   	pushf  
  103d76:	58                   	pop    %eax
  103d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
  103d7d:	25 00 02 00 00       	and    $0x200,%eax
  103d82:	85 c0                	test   %eax,%eax
  103d84:	74 0c                	je     103d92 <__intr_save+0x23>
        intr_disable();
  103d86:	e8 b8 d9 ff ff       	call   101743 <intr_disable>
        return 1;
  103d8b:	b8 01 00 00 00       	mov    $0x1,%eax
  103d90:	eb 05                	jmp    103d97 <__intr_save+0x28>
    return 0;
  103d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d97:	89 ec                	mov    %ebp,%esp
  103d99:	5d                   	pop    %ebp
  103d9a:	c3                   	ret    

00103d9b <__intr_restore>:
{
  103d9b:	55                   	push   %ebp
  103d9c:	89 e5                	mov    %esp,%ebp
  103d9e:	83 ec 08             	sub    $0x8,%esp
    if (flag)
  103da1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103da5:	74 05                	je     103dac <__intr_restore+0x11>
        intr_enable();
  103da7:	e8 8f d9 ff ff       	call   10173b <intr_enable>
}
  103dac:	90                   	nop
  103dad:	89 ec                	mov    %ebp,%esp
  103daf:	5d                   	pop    %ebp
  103db0:	c3                   	ret    

00103db1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103db1:	55                   	push   %ebp
  103db2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103db4:	8b 45 08             	mov    0x8(%ebp),%eax
  103db7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103dba:	b8 23 00 00 00       	mov    $0x23,%eax
  103dbf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103dc1:	b8 23 00 00 00       	mov    $0x23,%eax
  103dc6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103dc8:	b8 10 00 00 00       	mov    $0x10,%eax
  103dcd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103dcf:	b8 10 00 00 00       	mov    $0x10,%eax
  103dd4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103dd6:	b8 10 00 00 00       	mov    $0x10,%eax
  103ddb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103ddd:	ea e4 3d 10 00 08 00 	ljmp   $0x8,$0x103de4
}
  103de4:	90                   	nop
  103de5:	5d                   	pop    %ebp
  103de6:	c3                   	ret    

00103de7 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103de7:	55                   	push   %ebp
  103de8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103dea:	8b 45 08             	mov    0x8(%ebp),%eax
  103ded:	a3 c4 be 11 00       	mov    %eax,0x11bec4
}
  103df2:	90                   	nop
  103df3:	5d                   	pop    %ebp
  103df4:	c3                   	ret    

00103df5 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103df5:	55                   	push   %ebp
  103df6:	89 e5                	mov    %esp,%ebp
  103df8:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103dfb:	b8 00 80 11 00       	mov    $0x118000,%eax
  103e00:	89 04 24             	mov    %eax,(%esp)
  103e03:	e8 df ff ff ff       	call   103de7 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e08:	66 c7 05 c8 be 11 00 	movw   $0x10,0x11bec8
  103e0f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e11:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103e18:	68 00 
  103e1a:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e1f:	0f b7 c0             	movzwl %ax,%eax
  103e22:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103e28:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e2d:	c1 e8 10             	shr    $0x10,%eax
  103e30:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103e35:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e3c:	24 f0                	and    $0xf0,%al
  103e3e:	0c 09                	or     $0x9,%al
  103e40:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e45:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e4c:	24 ef                	and    $0xef,%al
  103e4e:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e53:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e5a:	24 9f                	and    $0x9f,%al
  103e5c:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e61:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e68:	0c 80                	or     $0x80,%al
  103e6a:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e6f:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e76:	24 f0                	and    $0xf0,%al
  103e78:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e7d:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e84:	24 ef                	and    $0xef,%al
  103e86:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e8b:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e92:	24 df                	and    $0xdf,%al
  103e94:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e99:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ea0:	0c 40                	or     $0x40,%al
  103ea2:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ea7:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103eae:	24 7f                	and    $0x7f,%al
  103eb0:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eb5:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103eba:	c1 e8 18             	shr    $0x18,%eax
  103ebd:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ec2:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103ec9:	e8 e3 fe ff ff       	call   103db1 <lgdt>
  103ece:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
  103ed4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103ed8:	0f 00 d8             	ltr    %ax
}
  103edb:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103edc:	90                   	nop
  103edd:	89 ec                	mov    %ebp,%esp
  103edf:	5d                   	pop    %ebp
  103ee0:	c3                   	ret    

00103ee1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103ee1:	55                   	push   %ebp
  103ee2:	89 e5                	mov    %esp,%ebp
  103ee4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ee7:	c7 05 ac be 11 00 38 	movl   $0x106a38,0x11beac
  103eee:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ef1:	a1 ac be 11 00       	mov    0x11beac,%eax
  103ef6:	8b 00                	mov    (%eax),%eax
  103ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  103efc:	c7 04 24 d4 6a 10 00 	movl   $0x106ad4,(%esp)
  103f03:	e8 5d c4 ff ff       	call   100365 <cprintf>
    pmm_manager->init();
  103f08:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f0d:	8b 40 04             	mov    0x4(%eax),%eax
  103f10:	ff d0                	call   *%eax
}
  103f12:	90                   	nop
  103f13:	89 ec                	mov    %ebp,%esp
  103f15:	5d                   	pop    %ebp
  103f16:	c3                   	ret    

00103f17 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f17:	55                   	push   %ebp
  103f18:	89 e5                	mov    %esp,%ebp
  103f1a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f1d:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f22:	8b 40 08             	mov    0x8(%eax),%eax
  103f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f28:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  103f2f:	89 14 24             	mov    %edx,(%esp)
  103f32:	ff d0                	call   *%eax
}
  103f34:	90                   	nop
  103f35:	89 ec                	mov    %ebp,%esp
  103f37:	5d                   	pop    %ebp
  103f38:	c3                   	ret    

00103f39 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f39:	55                   	push   %ebp
  103f3a:	89 e5                	mov    %esp,%ebp
  103f3c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f46:	e8 24 fe ff ff       	call   103d6f <__intr_save>
  103f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f4e:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f53:	8b 40 0c             	mov    0xc(%eax),%eax
  103f56:	8b 55 08             	mov    0x8(%ebp),%edx
  103f59:	89 14 24             	mov    %edx,(%esp)
  103f5c:	ff d0                	call   *%eax
  103f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f64:	89 04 24             	mov    %eax,(%esp)
  103f67:	e8 2f fe ff ff       	call   103d9b <__intr_restore>
    return page;
  103f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f6f:	89 ec                	mov    %ebp,%esp
  103f71:	5d                   	pop    %ebp
  103f72:	c3                   	ret    

00103f73 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f73:	55                   	push   %ebp
  103f74:	89 e5                	mov    %esp,%ebp
  103f76:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f79:	e8 f1 fd ff ff       	call   103d6f <__intr_save>
  103f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f81:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f86:	8b 40 10             	mov    0x10(%eax),%eax
  103f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f90:	8b 55 08             	mov    0x8(%ebp),%edx
  103f93:	89 14 24             	mov    %edx,(%esp)
  103f96:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f9b:	89 04 24             	mov    %eax,(%esp)
  103f9e:	e8 f8 fd ff ff       	call   103d9b <__intr_restore>
}
  103fa3:	90                   	nop
  103fa4:	89 ec                	mov    %ebp,%esp
  103fa6:	5d                   	pop    %ebp
  103fa7:	c3                   	ret    

00103fa8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103fa8:	55                   	push   %ebp
  103fa9:	89 e5                	mov    %esp,%ebp
  103fab:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103fae:	e8 bc fd ff ff       	call   103d6f <__intr_save>
  103fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103fb6:	a1 ac be 11 00       	mov    0x11beac,%eax
  103fbb:	8b 40 14             	mov    0x14(%eax),%eax
  103fbe:	ff d0                	call   *%eax
  103fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fc6:	89 04 24             	mov    %eax,(%esp)
  103fc9:	e8 cd fd ff ff       	call   103d9b <__intr_restore>
    return ret;
  103fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103fd1:	89 ec                	mov    %ebp,%esp
  103fd3:	5d                   	pop    %ebp
  103fd4:	c3                   	ret    

00103fd5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103fd5:	55                   	push   %ebp
  103fd6:	89 e5                	mov    %esp,%ebp
  103fd8:	57                   	push   %edi
  103fd9:	56                   	push   %esi
  103fda:	53                   	push   %ebx
  103fdb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103fe1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103fe8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103ff6:	c7 04 24 eb 6a 10 00 	movl   $0x106aeb,(%esp)
  103ffd:	e8 63 c3 ff ff       	call   100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104002:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104009:	e9 0c 01 00 00       	jmp    10411a <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10400e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104011:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104014:	89 d0                	mov    %edx,%eax
  104016:	c1 e0 02             	shl    $0x2,%eax
  104019:	01 d0                	add    %edx,%eax
  10401b:	c1 e0 02             	shl    $0x2,%eax
  10401e:	01 c8                	add    %ecx,%eax
  104020:	8b 50 08             	mov    0x8(%eax),%edx
  104023:	8b 40 04             	mov    0x4(%eax),%eax
  104026:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104029:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10402c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10402f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104032:	89 d0                	mov    %edx,%eax
  104034:	c1 e0 02             	shl    $0x2,%eax
  104037:	01 d0                	add    %edx,%eax
  104039:	c1 e0 02             	shl    $0x2,%eax
  10403c:	01 c8                	add    %ecx,%eax
  10403e:	8b 48 0c             	mov    0xc(%eax),%ecx
  104041:	8b 58 10             	mov    0x10(%eax),%ebx
  104044:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104047:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10404a:	01 c8                	add    %ecx,%eax
  10404c:	11 da                	adc    %ebx,%edx
  10404e:	89 45 98             	mov    %eax,-0x68(%ebp)
  104051:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104054:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104057:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405a:	89 d0                	mov    %edx,%eax
  10405c:	c1 e0 02             	shl    $0x2,%eax
  10405f:	01 d0                	add    %edx,%eax
  104061:	c1 e0 02             	shl    $0x2,%eax
  104064:	01 c8                	add    %ecx,%eax
  104066:	83 c0 14             	add    $0x14,%eax
  104069:	8b 00                	mov    (%eax),%eax
  10406b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104071:	8b 45 98             	mov    -0x68(%ebp),%eax
  104074:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104077:	83 c0 ff             	add    $0xffffffff,%eax
  10407a:	83 d2 ff             	adc    $0xffffffff,%edx
  10407d:	89 c6                	mov    %eax,%esi
  10407f:	89 d7                	mov    %edx,%edi
  104081:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104084:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104087:	89 d0                	mov    %edx,%eax
  104089:	c1 e0 02             	shl    $0x2,%eax
  10408c:	01 d0                	add    %edx,%eax
  10408e:	c1 e0 02             	shl    $0x2,%eax
  104091:	01 c8                	add    %ecx,%eax
  104093:	8b 48 0c             	mov    0xc(%eax),%ecx
  104096:	8b 58 10             	mov    0x10(%eax),%ebx
  104099:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10409f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1040a3:	89 74 24 14          	mov    %esi,0x14(%esp)
  1040a7:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1040ab:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040ae:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040b5:	89 54 24 10          	mov    %edx,0x10(%esp)
  1040b9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040c1:	c7 04 24 f8 6a 10 00 	movl   $0x106af8,(%esp)
  1040c8:	e8 98 c2 ff ff       	call   100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040cd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040d3:	89 d0                	mov    %edx,%eax
  1040d5:	c1 e0 02             	shl    $0x2,%eax
  1040d8:	01 d0                	add    %edx,%eax
  1040da:	c1 e0 02             	shl    $0x2,%eax
  1040dd:	01 c8                	add    %ecx,%eax
  1040df:	83 c0 14             	add    $0x14,%eax
  1040e2:	8b 00                	mov    (%eax),%eax
  1040e4:	83 f8 01             	cmp    $0x1,%eax
  1040e7:	75 2e                	jne    104117 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  1040e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040ef:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1040f2:	89 d0                	mov    %edx,%eax
  1040f4:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  1040f7:	73 1e                	jae    104117 <page_init+0x142>
  1040f9:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1040fe:	b8 00 00 00 00       	mov    $0x0,%eax
  104103:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104106:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  104109:	72 0c                	jb     104117 <page_init+0x142>
                maxpa = end;
  10410b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10410e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104111:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104114:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  104117:	ff 45 dc             	incl   -0x24(%ebp)
  10411a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10411d:	8b 00                	mov    (%eax),%eax
  10411f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104122:	0f 8c e6 fe ff ff    	jl     10400e <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104128:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10412d:	b8 00 00 00 00       	mov    $0x0,%eax
  104132:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104135:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104138:	73 0e                	jae    104148 <page_init+0x173>
        maxpa = KMEMSIZE;
  10413a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104141:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104148:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10414b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10414e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104152:	c1 ea 0c             	shr    $0xc,%edx
  104155:	a3 a4 be 11 00       	mov    %eax,0x11bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10415a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104161:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  104166:	8d 50 ff             	lea    -0x1(%eax),%edx
  104169:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10416c:	01 d0                	add    %edx,%eax
  10416e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104171:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104174:	ba 00 00 00 00       	mov    $0x0,%edx
  104179:	f7 75 c0             	divl   -0x40(%ebp)
  10417c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10417f:	29 d0                	sub    %edx,%eax
  104181:	a3 a0 be 11 00       	mov    %eax,0x11bea0

    for (i = 0; i < npage; i ++) {
  104186:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10418d:	eb 2f                	jmp    1041be <page_init+0x1e9>
        SetPageReserved(pages + i);
  10418f:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  104195:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104198:	89 d0                	mov    %edx,%eax
  10419a:	c1 e0 02             	shl    $0x2,%eax
  10419d:	01 d0                	add    %edx,%eax
  10419f:	c1 e0 02             	shl    $0x2,%eax
  1041a2:	01 c8                	add    %ecx,%eax
  1041a4:	83 c0 04             	add    $0x4,%eax
  1041a7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  1041ae:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
  1041b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  1041b4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1041b7:	0f ab 10             	bts    %edx,(%eax)
}
  1041ba:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1041bb:	ff 45 dc             	incl   -0x24(%ebp)
  1041be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041c1:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1041c6:	39 c2                	cmp    %eax,%edx
  1041c8:	72 c5                	jb     10418f <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041ca:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1041d0:	89 d0                	mov    %edx,%eax
  1041d2:	c1 e0 02             	shl    $0x2,%eax
  1041d5:	01 d0                	add    %edx,%eax
  1041d7:	c1 e0 02             	shl    $0x2,%eax
  1041da:	89 c2                	mov    %eax,%edx
  1041dc:	a1 a0 be 11 00       	mov    0x11bea0,%eax
  1041e1:	01 d0                	add    %edx,%eax
  1041e3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1041e6:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1041ed:	77 23                	ja     104212 <page_init+0x23d>
  1041ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1041f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041f6:	c7 44 24 08 28 6b 10 	movl   $0x106b28,0x8(%esp)
  1041fd:	00 
  1041fe:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104205:	00 
  104206:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10420d:	e8 d8 ca ff ff       	call   100cea <__panic>
  104212:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104215:	05 00 00 00 40       	add    $0x40000000,%eax
  10421a:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10421d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104224:	e9 53 01 00 00       	jmp    10437c <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104229:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10422c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10422f:	89 d0                	mov    %edx,%eax
  104231:	c1 e0 02             	shl    $0x2,%eax
  104234:	01 d0                	add    %edx,%eax
  104236:	c1 e0 02             	shl    $0x2,%eax
  104239:	01 c8                	add    %ecx,%eax
  10423b:	8b 50 08             	mov    0x8(%eax),%edx
  10423e:	8b 40 04             	mov    0x4(%eax),%eax
  104241:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104244:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104247:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10424a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10424d:	89 d0                	mov    %edx,%eax
  10424f:	c1 e0 02             	shl    $0x2,%eax
  104252:	01 d0                	add    %edx,%eax
  104254:	c1 e0 02             	shl    $0x2,%eax
  104257:	01 c8                	add    %ecx,%eax
  104259:	8b 48 0c             	mov    0xc(%eax),%ecx
  10425c:	8b 58 10             	mov    0x10(%eax),%ebx
  10425f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104265:	01 c8                	add    %ecx,%eax
  104267:	11 da                	adc    %ebx,%edx
  104269:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10426c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10426f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104272:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104275:	89 d0                	mov    %edx,%eax
  104277:	c1 e0 02             	shl    $0x2,%eax
  10427a:	01 d0                	add    %edx,%eax
  10427c:	c1 e0 02             	shl    $0x2,%eax
  10427f:	01 c8                	add    %ecx,%eax
  104281:	83 c0 14             	add    $0x14,%eax
  104284:	8b 00                	mov    (%eax),%eax
  104286:	83 f8 01             	cmp    $0x1,%eax
  104289:	0f 85 ea 00 00 00    	jne    104379 <page_init+0x3a4>
            if (begin < freemem) {
  10428f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104292:	ba 00 00 00 00       	mov    $0x0,%edx
  104297:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10429a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10429d:	19 d1                	sbb    %edx,%ecx
  10429f:	73 0d                	jae    1042ae <page_init+0x2d9>
                begin = freemem;
  1042a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042ae:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1042b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1042b8:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1042bb:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042be:	73 0e                	jae    1042ce <page_init+0x2f9>
                end = KMEMSIZE;
  1042c0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042c7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042d4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042d7:	89 d0                	mov    %edx,%eax
  1042d9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042dc:	0f 83 97 00 00 00    	jae    104379 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  1042e2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1042e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1042ef:	01 d0                	add    %edx,%eax
  1042f1:	48                   	dec    %eax
  1042f2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1042f5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1042f8:	ba 00 00 00 00       	mov    $0x0,%edx
  1042fd:	f7 75 b0             	divl   -0x50(%ebp)
  104300:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104303:	29 d0                	sub    %edx,%eax
  104305:	ba 00 00 00 00       	mov    $0x0,%edx
  10430a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10430d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104310:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104313:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104316:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104319:	ba 00 00 00 00       	mov    $0x0,%edx
  10431e:	89 c7                	mov    %eax,%edi
  104320:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104326:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104329:	89 d0                	mov    %edx,%eax
  10432b:	83 e0 00             	and    $0x0,%eax
  10432e:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104331:	8b 45 80             	mov    -0x80(%ebp),%eax
  104334:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104337:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10433a:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10433d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104340:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104343:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104346:	89 d0                	mov    %edx,%eax
  104348:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10434b:	73 2c                	jae    104379 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10434d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104350:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104353:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104356:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104359:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10435d:	c1 ea 0c             	shr    $0xc,%edx
  104360:	89 c3                	mov    %eax,%ebx
  104362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104365:	89 04 24             	mov    %eax,(%esp)
  104368:	e8 c9 f8 ff ff       	call   103c36 <pa2page>
  10436d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104371:	89 04 24             	mov    %eax,(%esp)
  104374:	e8 9e fb ff ff       	call   103f17 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  104379:	ff 45 dc             	incl   -0x24(%ebp)
  10437c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10437f:	8b 00                	mov    (%eax),%eax
  104381:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104384:	0f 8c 9f fe ff ff    	jl     104229 <page_init+0x254>
                }
            }
        }
    }
}
  10438a:	90                   	nop
  10438b:	90                   	nop
  10438c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104392:	5b                   	pop    %ebx
  104393:	5e                   	pop    %esi
  104394:	5f                   	pop    %edi
  104395:	5d                   	pop    %ebp
  104396:	c3                   	ret    

00104397 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104397:	55                   	push   %ebp
  104398:	89 e5                	mov    %esp,%ebp
  10439a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10439d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043a0:	33 45 14             	xor    0x14(%ebp),%eax
  1043a3:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043a8:	85 c0                	test   %eax,%eax
  1043aa:	74 24                	je     1043d0 <boot_map_segment+0x39>
  1043ac:	c7 44 24 0c 5a 6b 10 	movl   $0x106b5a,0xc(%esp)
  1043b3:	00 
  1043b4:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  1043bb:	00 
  1043bc:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1043c3:	00 
  1043c4:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1043cb:	e8 1a c9 ff ff       	call   100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1043d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043da:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043df:	89 c2                	mov    %eax,%edx
  1043e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1043e4:	01 c2                	add    %eax,%edx
  1043e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043e9:	01 d0                	add    %edx,%eax
  1043eb:	48                   	dec    %eax
  1043ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1043ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043f2:	ba 00 00 00 00       	mov    $0x0,%edx
  1043f7:	f7 75 f0             	divl   -0x10(%ebp)
  1043fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043fd:	29 d0                	sub    %edx,%eax
  1043ff:	c1 e8 0c             	shr    $0xc,%eax
  104402:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104405:	8b 45 0c             	mov    0xc(%ebp),%eax
  104408:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10440b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10440e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104413:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104416:	8b 45 14             	mov    0x14(%ebp),%eax
  104419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10441c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10441f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104424:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104427:	eb 68                	jmp    104491 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104429:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104430:	00 
  104431:	8b 45 0c             	mov    0xc(%ebp),%eax
  104434:	89 44 24 04          	mov    %eax,0x4(%esp)
  104438:	8b 45 08             	mov    0x8(%ebp),%eax
  10443b:	89 04 24             	mov    %eax,(%esp)
  10443e:	e8 88 01 00 00       	call   1045cb <get_pte>
  104443:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104446:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10444a:	75 24                	jne    104470 <boot_map_segment+0xd9>
  10444c:	c7 44 24 0c 86 6b 10 	movl   $0x106b86,0xc(%esp)
  104453:	00 
  104454:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10445b:	00 
  10445c:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104463:	00 
  104464:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10446b:	e8 7a c8 ff ff       	call   100cea <__panic>
        *ptep = pa | PTE_P | perm;
  104470:	8b 45 14             	mov    0x14(%ebp),%eax
  104473:	0b 45 18             	or     0x18(%ebp),%eax
  104476:	83 c8 01             	or     $0x1,%eax
  104479:	89 c2                	mov    %eax,%edx
  10447b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10447e:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104480:	ff 4d f4             	decl   -0xc(%ebp)
  104483:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10448a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104495:	75 92                	jne    104429 <boot_map_segment+0x92>
    }
}
  104497:	90                   	nop
  104498:	90                   	nop
  104499:	89 ec                	mov    %ebp,%esp
  10449b:	5d                   	pop    %ebp
  10449c:	c3                   	ret    

0010449d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10449d:	55                   	push   %ebp
  10449e:	89 e5                	mov    %esp,%ebp
  1044a0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044aa:	e8 8a fa ff ff       	call   103f39 <alloc_pages>
  1044af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b6:	75 1c                	jne    1044d4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044b8:	c7 44 24 08 93 6b 10 	movl   $0x106b93,0x8(%esp)
  1044bf:	00 
  1044c0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1044c7:	00 
  1044c8:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1044cf:	e8 16 c8 ff ff       	call   100cea <__panic>
    }
    return page2kva(p);
  1044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d7:	89 04 24             	mov    %eax,(%esp)
  1044da:	e8 a8 f7 ff ff       	call   103c87 <page2kva>
}
  1044df:	89 ec                	mov    %ebp,%esp
  1044e1:	5d                   	pop    %ebp
  1044e2:	c3                   	ret    

001044e3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1044e3:	55                   	push   %ebp
  1044e4:	89 e5                	mov    %esp,%ebp
  1044e6:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1044e9:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1044ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1044f1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1044f8:	77 23                	ja     10451d <pmm_init+0x3a>
  1044fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104501:	c7 44 24 08 28 6b 10 	movl   $0x106b28,0x8(%esp)
  104508:	00 
  104509:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104510:	00 
  104511:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104518:	e8 cd c7 ff ff       	call   100cea <__panic>
  10451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104520:	05 00 00 00 40       	add    $0x40000000,%eax
  104525:	a3 a8 be 11 00       	mov    %eax,0x11bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10452a:	e8 b2 f9 ff ff       	call   103ee1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10452f:	e8 a1 fa ff ff       	call   103fd5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104534:	e8 74 02 00 00       	call   1047ad <check_alloc_page>

    check_pgdir();
  104539:	e8 90 02 00 00       	call   1047ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10453e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104543:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104546:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10454d:	77 23                	ja     104572 <pmm_init+0x8f>
  10454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104552:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104556:	c7 44 24 08 28 6b 10 	movl   $0x106b28,0x8(%esp)
  10455d:	00 
  10455e:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104565:	00 
  104566:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10456d:	e8 78 c7 ff ff       	call   100cea <__panic>
  104572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104575:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10457b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104580:	05 ac 0f 00 00       	add    $0xfac,%eax
  104585:	83 ca 03             	or     $0x3,%edx
  104588:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10458a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10458f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104596:	00 
  104597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10459e:	00 
  10459f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045a6:	38 
  1045a7:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045ae:	c0 
  1045af:	89 04 24             	mov    %eax,(%esp)
  1045b2:	e8 e0 fd ff ff       	call   104397 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045b7:	e8 39 f8 ff ff       	call   103df5 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045bc:	e8 ab 08 00 00       	call   104e6c <check_boot_pgdir>

    print_pgdir();
  1045c1:	e8 28 0d 00 00       	call   1052ee <print_pgdir>

}
  1045c6:	90                   	nop
  1045c7:	89 ec                	mov    %ebp,%esp
  1045c9:	5d                   	pop    %ebp
  1045ca:	c3                   	ret    

001045cb <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045cb:	55                   	push   %ebp
  1045cc:	89 e5                	mov    %esp,%ebp
  1045ce:	83 ec 10             	sub    $0x10,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    pde_t *pdep = &pgdir[PDX(la)];
  1045d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045d4:	c1 e8 16             	shr    $0x16,%eax
  1045d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045de:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e1:	01 d0                	add    %edx,%eax
  1045e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1045e6:	90                   	nop
  1045e7:	89 ec                	mov    %ebp,%esp
  1045e9:	5d                   	pop    %ebp
  1045ea:	c3                   	ret    

001045eb <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1045eb:	55                   	push   %ebp
  1045ec:	89 e5                	mov    %esp,%ebp
  1045ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045f8:	00 
  1045f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104600:	8b 45 08             	mov    0x8(%ebp),%eax
  104603:	89 04 24             	mov    %eax,(%esp)
  104606:	e8 c0 ff ff ff       	call   1045cb <get_pte>
  10460b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10460e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104612:	74 08                	je     10461c <get_page+0x31>
        *ptep_store = ptep;
  104614:	8b 45 10             	mov    0x10(%ebp),%eax
  104617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10461a:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10461c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104620:	74 1b                	je     10463d <get_page+0x52>
  104622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104625:	8b 00                	mov    (%eax),%eax
  104627:	83 e0 01             	and    $0x1,%eax
  10462a:	85 c0                	test   %eax,%eax
  10462c:	74 0f                	je     10463d <get_page+0x52>
        return pte2page(*ptep);
  10462e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104631:	8b 00                	mov    (%eax),%eax
  104633:	89 04 24             	mov    %eax,(%esp)
  104636:	e8 a2 f6 ff ff       	call   103cdd <pte2page>
  10463b:	eb 05                	jmp    104642 <get_page+0x57>
    }
    return NULL;
  10463d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104642:	89 ec                	mov    %ebp,%esp
  104644:	5d                   	pop    %ebp
  104645:	c3                   	ret    

00104646 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104646:	55                   	push   %ebp
  104647:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104649:	90                   	nop
  10464a:	5d                   	pop    %ebp
  10464b:	c3                   	ret    

0010464c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10464c:	55                   	push   %ebp
  10464d:	89 e5                	mov    %esp,%ebp
  10464f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104652:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104659:	00 
  10465a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104661:	8b 45 08             	mov    0x8(%ebp),%eax
  104664:	89 04 24             	mov    %eax,(%esp)
  104667:	e8 5f ff ff ff       	call   1045cb <get_pte>
  10466c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10466f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104673:	74 19                	je     10468e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104678:	89 44 24 08          	mov    %eax,0x8(%esp)
  10467c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10467f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104683:	8b 45 08             	mov    0x8(%ebp),%eax
  104686:	89 04 24             	mov    %eax,(%esp)
  104689:	e8 b8 ff ff ff       	call   104646 <page_remove_pte>
    }
}
  10468e:	90                   	nop
  10468f:	89 ec                	mov    %ebp,%esp
  104691:	5d                   	pop    %ebp
  104692:	c3                   	ret    

00104693 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104693:	55                   	push   %ebp
  104694:	89 e5                	mov    %esp,%ebp
  104696:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104699:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046a0:	00 
  1046a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1046a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ab:	89 04 24             	mov    %eax,(%esp)
  1046ae:	e8 18 ff ff ff       	call   1045cb <get_pte>
  1046b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ba:	75 0a                	jne    1046c6 <page_insert+0x33>
        return -E_NO_MEM;
  1046bc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046c1:	e9 84 00 00 00       	jmp    10474a <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c9:	89 04 24             	mov    %eax,(%esp)
  1046cc:	e8 70 f6 ff ff       	call   103d41 <page_ref_inc>
    if (*ptep & PTE_P) {
  1046d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d4:	8b 00                	mov    (%eax),%eax
  1046d6:	83 e0 01             	and    $0x1,%eax
  1046d9:	85 c0                	test   %eax,%eax
  1046db:	74 3e                	je     10471b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e0:	8b 00                	mov    (%eax),%eax
  1046e2:	89 04 24             	mov    %eax,(%esp)
  1046e5:	e8 f3 f5 ff ff       	call   103cdd <pte2page>
  1046ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046f3:	75 0d                	jne    104702 <page_insert+0x6f>
            page_ref_dec(page);
  1046f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f8:	89 04 24             	mov    %eax,(%esp)
  1046fb:	e8 58 f6 ff ff       	call   103d58 <page_ref_dec>
  104700:	eb 19                	jmp    10471b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104705:	89 44 24 08          	mov    %eax,0x8(%esp)
  104709:	8b 45 10             	mov    0x10(%ebp),%eax
  10470c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104710:	8b 45 08             	mov    0x8(%ebp),%eax
  104713:	89 04 24             	mov    %eax,(%esp)
  104716:	e8 2b ff ff ff       	call   104646 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10471b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10471e:	89 04 24             	mov    %eax,(%esp)
  104721:	e8 f8 f4 ff ff       	call   103c1e <page2pa>
  104726:	0b 45 14             	or     0x14(%ebp),%eax
  104729:	83 c8 01             	or     $0x1,%eax
  10472c:	89 c2                	mov    %eax,%edx
  10472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104731:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104733:	8b 45 10             	mov    0x10(%ebp),%eax
  104736:	89 44 24 04          	mov    %eax,0x4(%esp)
  10473a:	8b 45 08             	mov    0x8(%ebp),%eax
  10473d:	89 04 24             	mov    %eax,(%esp)
  104740:	e8 09 00 00 00       	call   10474e <tlb_invalidate>
    return 0;
  104745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10474a:	89 ec                	mov    %ebp,%esp
  10474c:	5d                   	pop    %ebp
  10474d:	c3                   	ret    

0010474e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10474e:	55                   	push   %ebp
  10474f:	89 e5                	mov    %esp,%ebp
  104751:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
  104754:	0f 20 d8             	mov    %cr3,%eax
  104757:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
  10475a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10475d:	8b 45 08             	mov    0x8(%ebp),%eax
  104760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104763:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10476a:	77 23                	ja     10478f <tlb_invalidate+0x41>
  10476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104773:	c7 44 24 08 28 6b 10 	movl   $0x106b28,0x8(%esp)
  10477a:	00 
  10477b:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
  104782:	00 
  104783:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10478a:	e8 5b c5 ff ff       	call   100cea <__panic>
  10478f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104792:	05 00 00 00 40       	add    $0x40000000,%eax
  104797:	39 d0                	cmp    %edx,%eax
  104799:	75 0d                	jne    1047a8 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  10479b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10479e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
  1047a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047a4:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
  1047a7:	90                   	nop
    }
}
  1047a8:	90                   	nop
  1047a9:	89 ec                	mov    %ebp,%esp
  1047ab:	5d                   	pop    %ebp
  1047ac:	c3                   	ret    

001047ad <check_alloc_page>:

static void
check_alloc_page(void) {
  1047ad:	55                   	push   %ebp
  1047ae:	89 e5                	mov    %esp,%ebp
  1047b0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047b3:	a1 ac be 11 00       	mov    0x11beac,%eax
  1047b8:	8b 40 18             	mov    0x18(%eax),%eax
  1047bb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047bd:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1047c4:	e8 9c bb ff ff       	call   100365 <cprintf>
}
  1047c9:	90                   	nop
  1047ca:	89 ec                	mov    %ebp,%esp
  1047cc:	5d                   	pop    %ebp
  1047cd:	c3                   	ret    

001047ce <check_pgdir>:

static void
check_pgdir(void) {
  1047ce:	55                   	push   %ebp
  1047cf:	89 e5                	mov    %esp,%ebp
  1047d1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047d4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1047d9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047de:	76 24                	jbe    104804 <check_pgdir+0x36>
  1047e0:	c7 44 24 0c cb 6b 10 	movl   $0x106bcb,0xc(%esp)
  1047e7:	00 
  1047e8:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  1047ef:	00 
  1047f0:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  1047f7:	00 
  1047f8:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1047ff:	e8 e6 c4 ff ff       	call   100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104804:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104809:	85 c0                	test   %eax,%eax
  10480b:	74 0e                	je     10481b <check_pgdir+0x4d>
  10480d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104812:	25 ff 0f 00 00       	and    $0xfff,%eax
  104817:	85 c0                	test   %eax,%eax
  104819:	74 24                	je     10483f <check_pgdir+0x71>
  10481b:	c7 44 24 0c e8 6b 10 	movl   $0x106be8,0xc(%esp)
  104822:	00 
  104823:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10482a:	00 
  10482b:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
  104832:	00 
  104833:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10483a:	e8 ab c4 ff ff       	call   100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10483f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104844:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10484b:	00 
  10484c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104853:	00 
  104854:	89 04 24             	mov    %eax,(%esp)
  104857:	e8 8f fd ff ff       	call   1045eb <get_page>
  10485c:	85 c0                	test   %eax,%eax
  10485e:	74 24                	je     104884 <check_pgdir+0xb6>
  104860:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104867:	00 
  104868:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10486f:	00 
  104870:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
  104877:	00 
  104878:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10487f:	e8 66 c4 ff ff       	call   100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104884:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10488b:	e8 a9 f6 ff ff       	call   103f39 <alloc_pages>
  104890:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104893:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104898:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10489f:	00 
  1048a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048a7:	00 
  1048a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048af:	89 04 24             	mov    %eax,(%esp)
  1048b2:	e8 dc fd ff ff       	call   104693 <page_insert>
  1048b7:	85 c0                	test   %eax,%eax
  1048b9:	74 24                	je     1048df <check_pgdir+0x111>
  1048bb:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  1048c2:	00 
  1048c3:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  1048ca:	00 
  1048cb:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  1048d2:	00 
  1048d3:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1048da:	e8 0b c4 ff ff       	call   100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048df:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048eb:	00 
  1048ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048f3:	00 
  1048f4:	89 04 24             	mov    %eax,(%esp)
  1048f7:	e8 cf fc ff ff       	call   1045cb <get_pte>
  1048fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104903:	75 24                	jne    104929 <check_pgdir+0x15b>
  104905:	c7 44 24 0c 74 6c 10 	movl   $0x106c74,0xc(%esp)
  10490c:	00 
  10490d:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104914:	00 
  104915:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10491c:	00 
  10491d:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104924:	e8 c1 c3 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  104929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10492c:	8b 00                	mov    (%eax),%eax
  10492e:	89 04 24             	mov    %eax,(%esp)
  104931:	e8 a7 f3 ff ff       	call   103cdd <pte2page>
  104936:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104939:	74 24                	je     10495f <check_pgdir+0x191>
  10493b:	c7 44 24 0c a1 6c 10 	movl   $0x106ca1,0xc(%esp)
  104942:	00 
  104943:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10494a:	00 
  10494b:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  104952:	00 
  104953:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10495a:	e8 8b c3 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 1);
  10495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104962:	89 04 24             	mov    %eax,(%esp)
  104965:	e8 cd f3 ff ff       	call   103d37 <page_ref>
  10496a:	83 f8 01             	cmp    $0x1,%eax
  10496d:	74 24                	je     104993 <check_pgdir+0x1c5>
  10496f:	c7 44 24 0c b7 6c 10 	movl   $0x106cb7,0xc(%esp)
  104976:	00 
  104977:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10497e:	00 
  10497f:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104986:	00 
  104987:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10498e:	e8 57 c3 ff ff       	call   100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104993:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104998:	8b 00                	mov    (%eax),%eax
  10499a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10499f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049a5:	c1 e8 0c             	shr    $0xc,%eax
  1049a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1049ab:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1049b0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049b3:	72 23                	jb     1049d8 <check_pgdir+0x20a>
  1049b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049bc:	c7 44 24 08 84 6a 10 	movl   $0x106a84,0x8(%esp)
  1049c3:	00 
  1049c4:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
  1049cb:	00 
  1049cc:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1049d3:	e8 12 c3 ff ff       	call   100cea <__panic>
  1049d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049db:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049e0:	83 c0 04             	add    $0x4,%eax
  1049e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049e6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1049eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049f2:	00 
  1049f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049fa:	00 
  1049fb:	89 04 24             	mov    %eax,(%esp)
  1049fe:	e8 c8 fb ff ff       	call   1045cb <get_pte>
  104a03:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a06:	74 24                	je     104a2c <check_pgdir+0x25e>
  104a08:	c7 44 24 0c cc 6c 10 	movl   $0x106ccc,0xc(%esp)
  104a0f:	00 
  104a10:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104a17:	00 
  104a18:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
  104a1f:	00 
  104a20:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104a27:	e8 be c2 ff ff       	call   100cea <__panic>

    p2 = alloc_page();
  104a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a33:	e8 01 f5 ff ff       	call   103f39 <alloc_pages>
  104a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a3b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a40:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a47:	00 
  104a48:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a4f:	00 
  104a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a53:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a57:	89 04 24             	mov    %eax,(%esp)
  104a5a:	e8 34 fc ff ff       	call   104693 <page_insert>
  104a5f:	85 c0                	test   %eax,%eax
  104a61:	74 24                	je     104a87 <check_pgdir+0x2b9>
  104a63:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  104a6a:	00 
  104a6b:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104a72:	00 
  104a73:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104a7a:	00 
  104a7b:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104a82:	e8 63 c2 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a87:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a93:	00 
  104a94:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a9b:	00 
  104a9c:	89 04 24             	mov    %eax,(%esp)
  104a9f:	e8 27 fb ff ff       	call   1045cb <get_pte>
  104aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104aa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104aab:	75 24                	jne    104ad1 <check_pgdir+0x303>
  104aad:	c7 44 24 0c 2c 6d 10 	movl   $0x106d2c,0xc(%esp)
  104ab4:	00 
  104ab5:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104abc:	00 
  104abd:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104ac4:	00 
  104ac5:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104acc:	e8 19 c2 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_U);
  104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad4:	8b 00                	mov    (%eax),%eax
  104ad6:	83 e0 04             	and    $0x4,%eax
  104ad9:	85 c0                	test   %eax,%eax
  104adb:	75 24                	jne    104b01 <check_pgdir+0x333>
  104add:	c7 44 24 0c 5c 6d 10 	movl   $0x106d5c,0xc(%esp)
  104ae4:	00 
  104ae5:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104aec:	00 
  104aed:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104af4:	00 
  104af5:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104afc:	e8 e9 c1 ff ff       	call   100cea <__panic>
    assert(*ptep & PTE_W);
  104b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b04:	8b 00                	mov    (%eax),%eax
  104b06:	83 e0 02             	and    $0x2,%eax
  104b09:	85 c0                	test   %eax,%eax
  104b0b:	75 24                	jne    104b31 <check_pgdir+0x363>
  104b0d:	c7 44 24 0c 6a 6d 10 	movl   $0x106d6a,0xc(%esp)
  104b14:	00 
  104b15:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104b24:	00 
  104b25:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104b2c:	e8 b9 c1 ff ff       	call   100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b31:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b36:	8b 00                	mov    (%eax),%eax
  104b38:	83 e0 04             	and    $0x4,%eax
  104b3b:	85 c0                	test   %eax,%eax
  104b3d:	75 24                	jne    104b63 <check_pgdir+0x395>
  104b3f:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  104b46:	00 
  104b47:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  104b56:	00 
  104b57:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104b5e:	e8 87 c1 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 1);
  104b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b66:	89 04 24             	mov    %eax,(%esp)
  104b69:	e8 c9 f1 ff ff       	call   103d37 <page_ref>
  104b6e:	83 f8 01             	cmp    $0x1,%eax
  104b71:	74 24                	je     104b97 <check_pgdir+0x3c9>
  104b73:	c7 44 24 0c 8e 6d 10 	movl   $0x106d8e,0xc(%esp)
  104b7a:	00 
  104b7b:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104b82:	00 
  104b83:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104b8a:	00 
  104b8b:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104b92:	e8 53 c1 ff ff       	call   100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b97:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b9c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104ba3:	00 
  104ba4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bab:	00 
  104bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104baf:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bb3:	89 04 24             	mov    %eax,(%esp)
  104bb6:	e8 d8 fa ff ff       	call   104693 <page_insert>
  104bbb:	85 c0                	test   %eax,%eax
  104bbd:	74 24                	je     104be3 <check_pgdir+0x415>
  104bbf:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104bc6:	00 
  104bc7:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104bce:	00 
  104bcf:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104bd6:	00 
  104bd7:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104bde:	e8 07 c1 ff ff       	call   100cea <__panic>
    assert(page_ref(p1) == 2);
  104be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be6:	89 04 24             	mov    %eax,(%esp)
  104be9:	e8 49 f1 ff ff       	call   103d37 <page_ref>
  104bee:	83 f8 02             	cmp    $0x2,%eax
  104bf1:	74 24                	je     104c17 <check_pgdir+0x449>
  104bf3:	c7 44 24 0c cc 6d 10 	movl   $0x106dcc,0xc(%esp)
  104bfa:	00 
  104bfb:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104c02:	00 
  104c03:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104c0a:	00 
  104c0b:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104c12:	e8 d3 c0 ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c1a:	89 04 24             	mov    %eax,(%esp)
  104c1d:	e8 15 f1 ff ff       	call   103d37 <page_ref>
  104c22:	85 c0                	test   %eax,%eax
  104c24:	74 24                	je     104c4a <check_pgdir+0x47c>
  104c26:	c7 44 24 0c de 6d 10 	movl   $0x106dde,0xc(%esp)
  104c2d:	00 
  104c2e:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104c35:	00 
  104c36:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104c3d:	00 
  104c3e:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104c45:	e8 a0 c0 ff ff       	call   100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c4a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104c4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c56:	00 
  104c57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c5e:	00 
  104c5f:	89 04 24             	mov    %eax,(%esp)
  104c62:	e8 64 f9 ff ff       	call   1045cb <get_pte>
  104c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c6e:	75 24                	jne    104c94 <check_pgdir+0x4c6>
  104c70:	c7 44 24 0c 2c 6d 10 	movl   $0x106d2c,0xc(%esp)
  104c77:	00 
  104c78:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104c7f:	00 
  104c80:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104c87:	00 
  104c88:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104c8f:	e8 56 c0 ff ff       	call   100cea <__panic>
    assert(pte2page(*ptep) == p1);
  104c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c97:	8b 00                	mov    (%eax),%eax
  104c99:	89 04 24             	mov    %eax,(%esp)
  104c9c:	e8 3c f0 ff ff       	call   103cdd <pte2page>
  104ca1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ca4:	74 24                	je     104cca <check_pgdir+0x4fc>
  104ca6:	c7 44 24 0c a1 6c 10 	movl   $0x106ca1,0xc(%esp)
  104cad:	00 
  104cae:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104cb5:	00 
  104cb6:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104cbd:	00 
  104cbe:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104cc5:	e8 20 c0 ff ff       	call   100cea <__panic>
    assert((*ptep & PTE_U) == 0);
  104cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ccd:	8b 00                	mov    (%eax),%eax
  104ccf:	83 e0 04             	and    $0x4,%eax
  104cd2:	85 c0                	test   %eax,%eax
  104cd4:	74 24                	je     104cfa <check_pgdir+0x52c>
  104cd6:	c7 44 24 0c f0 6d 10 	movl   $0x106df0,0xc(%esp)
  104cdd:	00 
  104cde:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104ce5:	00 
  104ce6:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  104ced:	00 
  104cee:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104cf5:	e8 f0 bf ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, 0x0);
  104cfa:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104cff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d06:	00 
  104d07:	89 04 24             	mov    %eax,(%esp)
  104d0a:	e8 3d f9 ff ff       	call   10464c <page_remove>
    assert(page_ref(p1) == 1);
  104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d12:	89 04 24             	mov    %eax,(%esp)
  104d15:	e8 1d f0 ff ff       	call   103d37 <page_ref>
  104d1a:	83 f8 01             	cmp    $0x1,%eax
  104d1d:	74 24                	je     104d43 <check_pgdir+0x575>
  104d1f:	c7 44 24 0c b7 6c 10 	movl   $0x106cb7,0xc(%esp)
  104d26:	00 
  104d27:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104d2e:	00 
  104d2f:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  104d36:	00 
  104d37:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104d3e:	e8 a7 bf ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d46:	89 04 24             	mov    %eax,(%esp)
  104d49:	e8 e9 ef ff ff       	call   103d37 <page_ref>
  104d4e:	85 c0                	test   %eax,%eax
  104d50:	74 24                	je     104d76 <check_pgdir+0x5a8>
  104d52:	c7 44 24 0c de 6d 10 	movl   $0x106dde,0xc(%esp)
  104d59:	00 
  104d5a:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104d61:	00 
  104d62:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104d69:	00 
  104d6a:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104d71:	e8 74 bf ff ff       	call   100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d76:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d7b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d82:	00 
  104d83:	89 04 24             	mov    %eax,(%esp)
  104d86:	e8 c1 f8 ff ff       	call   10464c <page_remove>
    assert(page_ref(p1) == 0);
  104d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d8e:	89 04 24             	mov    %eax,(%esp)
  104d91:	e8 a1 ef ff ff       	call   103d37 <page_ref>
  104d96:	85 c0                	test   %eax,%eax
  104d98:	74 24                	je     104dbe <check_pgdir+0x5f0>
  104d9a:	c7 44 24 0c 05 6e 10 	movl   $0x106e05,0xc(%esp)
  104da1:	00 
  104da2:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104da9:	00 
  104daa:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104db1:	00 
  104db2:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104db9:	e8 2c bf ff ff       	call   100cea <__panic>
    assert(page_ref(p2) == 0);
  104dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dc1:	89 04 24             	mov    %eax,(%esp)
  104dc4:	e8 6e ef ff ff       	call   103d37 <page_ref>
  104dc9:	85 c0                	test   %eax,%eax
  104dcb:	74 24                	je     104df1 <check_pgdir+0x623>
  104dcd:	c7 44 24 0c de 6d 10 	movl   $0x106dde,0xc(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104de4:	00 
  104de5:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104dec:	e8 f9 be ff ff       	call   100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104df1:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104df6:	8b 00                	mov    (%eax),%eax
  104df8:	89 04 24             	mov    %eax,(%esp)
  104dfb:	e8 1d ef ff ff       	call   103d1d <pde2page>
  104e00:	89 04 24             	mov    %eax,(%esp)
  104e03:	e8 2f ef ff ff       	call   103d37 <page_ref>
  104e08:	83 f8 01             	cmp    $0x1,%eax
  104e0b:	74 24                	je     104e31 <check_pgdir+0x663>
  104e0d:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104e14:	00 
  104e15:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104e1c:	00 
  104e1d:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104e24:	00 
  104e25:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104e2c:	e8 b9 be ff ff       	call   100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104e31:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e36:	8b 00                	mov    (%eax),%eax
  104e38:	89 04 24             	mov    %eax,(%esp)
  104e3b:	e8 dd ee ff ff       	call   103d1d <pde2page>
  104e40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e47:	00 
  104e48:	89 04 24             	mov    %eax,(%esp)
  104e4b:	e8 23 f1 ff ff       	call   103f73 <free_pages>
    boot_pgdir[0] = 0;
  104e50:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e5b:	c7 04 24 3f 6e 10 00 	movl   $0x106e3f,(%esp)
  104e62:	e8 fe b4 ff ff       	call   100365 <cprintf>
}
  104e67:	90                   	nop
  104e68:	89 ec                	mov    %ebp,%esp
  104e6a:	5d                   	pop    %ebp
  104e6b:	c3                   	ret    

00104e6c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e6c:	55                   	push   %ebp
  104e6d:	89 e5                	mov    %esp,%ebp
  104e6f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e79:	e9 ca 00 00 00       	jmp    104f48 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e87:	c1 e8 0c             	shr    $0xc,%eax
  104e8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104e8d:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104e92:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104e95:	72 23                	jb     104eba <check_boot_pgdir+0x4e>
  104e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e9e:	c7 44 24 08 84 6a 10 	movl   $0x106a84,0x8(%esp)
  104ea5:	00 
  104ea6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104ead:	00 
  104eae:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104eb5:	e8 30 be ff ff       	call   100cea <__panic>
  104eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ebd:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ec2:	89 c2                	mov    %eax,%edx
  104ec4:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ec9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ed0:	00 
  104ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ed5:	89 04 24             	mov    %eax,(%esp)
  104ed8:	e8 ee f6 ff ff       	call   1045cb <get_pte>
  104edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ee0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104ee4:	75 24                	jne    104f0a <check_boot_pgdir+0x9e>
  104ee6:	c7 44 24 0c 5c 6e 10 	movl   $0x106e5c,0xc(%esp)
  104eed:	00 
  104eee:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104ef5:	00 
  104ef6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104efd:	00 
  104efe:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104f05:	e8 e0 bd ff ff       	call   100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f0d:	8b 00                	mov    (%eax),%eax
  104f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f14:	89 c2                	mov    %eax,%edx
  104f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f19:	39 c2                	cmp    %eax,%edx
  104f1b:	74 24                	je     104f41 <check_boot_pgdir+0xd5>
  104f1d:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104f24:	00 
  104f25:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104f2c:	00 
  104f2d:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104f34:	00 
  104f35:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104f3c:	e8 a9 bd ff ff       	call   100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104f41:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f4b:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104f50:	39 c2                	cmp    %eax,%edx
  104f52:	0f 82 26 ff ff ff    	jb     104e7e <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f58:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f5d:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f62:	8b 00                	mov    (%eax),%eax
  104f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f69:	89 c2                	mov    %eax,%edx
  104f6b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f73:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104f7a:	77 23                	ja     104f9f <check_boot_pgdir+0x133>
  104f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f83:	c7 44 24 08 28 6b 10 	movl   $0x106b28,0x8(%esp)
  104f8a:	00 
  104f8b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104f92:	00 
  104f93:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104f9a:	e8 4b bd ff ff       	call   100cea <__panic>
  104f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fa2:	05 00 00 00 40       	add    $0x40000000,%eax
  104fa7:	39 d0                	cmp    %edx,%eax
  104fa9:	74 24                	je     104fcf <check_boot_pgdir+0x163>
  104fab:	c7 44 24 0c b0 6e 10 	movl   $0x106eb0,0xc(%esp)
  104fb2:	00 
  104fb3:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104fba:	00 
  104fbb:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104fc2:	00 
  104fc3:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104fca:	e8 1b bd ff ff       	call   100cea <__panic>

    assert(boot_pgdir[0] == 0);
  104fcf:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104fd4:	8b 00                	mov    (%eax),%eax
  104fd6:	85 c0                	test   %eax,%eax
  104fd8:	74 24                	je     104ffe <check_boot_pgdir+0x192>
  104fda:	c7 44 24 0c e4 6e 10 	movl   $0x106ee4,0xc(%esp)
  104fe1:	00 
  104fe2:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  104fe9:	00 
  104fea:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104ff1:	00 
  104ff2:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  104ff9:	e8 ec bc ff ff       	call   100cea <__panic>

    struct Page *p;
    p = alloc_page();
  104ffe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105005:	e8 2f ef ff ff       	call   103f39 <alloc_pages>
  10500a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10500d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105012:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105019:	00 
  10501a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105021:	00 
  105022:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105025:	89 54 24 04          	mov    %edx,0x4(%esp)
  105029:	89 04 24             	mov    %eax,(%esp)
  10502c:	e8 62 f6 ff ff       	call   104693 <page_insert>
  105031:	85 c0                	test   %eax,%eax
  105033:	74 24                	je     105059 <check_boot_pgdir+0x1ed>
  105035:	c7 44 24 0c f8 6e 10 	movl   $0x106ef8,0xc(%esp)
  10503c:	00 
  10503d:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  105044:	00 
  105045:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  10504c:	00 
  10504d:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  105054:	e8 91 bc ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 1);
  105059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10505c:	89 04 24             	mov    %eax,(%esp)
  10505f:	e8 d3 ec ff ff       	call   103d37 <page_ref>
  105064:	83 f8 01             	cmp    $0x1,%eax
  105067:	74 24                	je     10508d <check_boot_pgdir+0x221>
  105069:	c7 44 24 0c 26 6f 10 	movl   $0x106f26,0xc(%esp)
  105070:	00 
  105071:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  105078:	00 
  105079:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105080:	00 
  105081:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  105088:	e8 5d bc ff ff       	call   100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10508d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105092:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105099:	00 
  10509a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050a1:	00 
  1050a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050a9:	89 04 24             	mov    %eax,(%esp)
  1050ac:	e8 e2 f5 ff ff       	call   104693 <page_insert>
  1050b1:	85 c0                	test   %eax,%eax
  1050b3:	74 24                	je     1050d9 <check_boot_pgdir+0x26d>
  1050b5:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  1050bc:	00 
  1050bd:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  1050c4:	00 
  1050c5:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  1050cc:	00 
  1050cd:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1050d4:	e8 11 bc ff ff       	call   100cea <__panic>
    assert(page_ref(p) == 2);
  1050d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050dc:	89 04 24             	mov    %eax,(%esp)
  1050df:	e8 53 ec ff ff       	call   103d37 <page_ref>
  1050e4:	83 f8 02             	cmp    $0x2,%eax
  1050e7:	74 24                	je     10510d <check_boot_pgdir+0x2a1>
  1050e9:	c7 44 24 0c 6f 6f 10 	movl   $0x106f6f,0xc(%esp)
  1050f0:	00 
  1050f1:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  1050f8:	00 
  1050f9:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  105100:	00 
  105101:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  105108:	e8 dd bb ff ff       	call   100cea <__panic>

    const char *str = "ucore: Hello world!!";
  10510d:	c7 45 e8 80 6f 10 00 	movl   $0x106f80,-0x18(%ebp)
    strcpy((void *)0x100, str);
  105114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105117:	89 44 24 04          	mov    %eax,0x4(%esp)
  10511b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105122:	e8 fc 09 00 00       	call   105b23 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105127:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10512e:	00 
  10512f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105136:	e8 60 0a 00 00       	call   105b9b <strcmp>
  10513b:	85 c0                	test   %eax,%eax
  10513d:	74 24                	je     105163 <check_boot_pgdir+0x2f7>
  10513f:	c7 44 24 0c 98 6f 10 	movl   $0x106f98,0xc(%esp)
  105146:	00 
  105147:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  10514e:	00 
  10514f:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  105156:	00 
  105157:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  10515e:	e8 87 bb ff ff       	call   100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105163:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105166:	89 04 24             	mov    %eax,(%esp)
  105169:	e8 19 eb ff ff       	call   103c87 <page2kva>
  10516e:	05 00 01 00 00       	add    $0x100,%eax
  105173:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105176:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10517d:	e8 47 09 00 00       	call   105ac9 <strlen>
  105182:	85 c0                	test   %eax,%eax
  105184:	74 24                	je     1051aa <check_boot_pgdir+0x33e>
  105186:	c7 44 24 0c d0 6f 10 	movl   $0x106fd0,0xc(%esp)
  10518d:	00 
  10518e:	c7 44 24 08 71 6b 10 	movl   $0x106b71,0x8(%esp)
  105195:	00 
  105196:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  10519d:	00 
  10519e:	c7 04 24 4c 6b 10 00 	movl   $0x106b4c,(%esp)
  1051a5:	e8 40 bb ff ff       	call   100cea <__panic>

    free_page(p);
  1051aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051b1:	00 
  1051b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051b5:	89 04 24             	mov    %eax,(%esp)
  1051b8:	e8 b6 ed ff ff       	call   103f73 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1051bd:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051c2:	8b 00                	mov    (%eax),%eax
  1051c4:	89 04 24             	mov    %eax,(%esp)
  1051c7:	e8 51 eb ff ff       	call   103d1d <pde2page>
  1051cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051d3:	00 
  1051d4:	89 04 24             	mov    %eax,(%esp)
  1051d7:	e8 97 ed ff ff       	call   103f73 <free_pages>
    boot_pgdir[0] = 0;
  1051dc:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051e7:	c7 04 24 f4 6f 10 00 	movl   $0x106ff4,(%esp)
  1051ee:	e8 72 b1 ff ff       	call   100365 <cprintf>
}
  1051f3:	90                   	nop
  1051f4:	89 ec                	mov    %ebp,%esp
  1051f6:	5d                   	pop    %ebp
  1051f7:	c3                   	ret    

001051f8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051f8:	55                   	push   %ebp
  1051f9:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1051fe:	83 e0 04             	and    $0x4,%eax
  105201:	85 c0                	test   %eax,%eax
  105203:	74 04                	je     105209 <perm2str+0x11>
  105205:	b0 75                	mov    $0x75,%al
  105207:	eb 02                	jmp    10520b <perm2str+0x13>
  105209:	b0 2d                	mov    $0x2d,%al
  10520b:	a2 28 bf 11 00       	mov    %al,0x11bf28
    str[1] = 'r';
  105210:	c6 05 29 bf 11 00 72 	movb   $0x72,0x11bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105217:	8b 45 08             	mov    0x8(%ebp),%eax
  10521a:	83 e0 02             	and    $0x2,%eax
  10521d:	85 c0                	test   %eax,%eax
  10521f:	74 04                	je     105225 <perm2str+0x2d>
  105221:	b0 77                	mov    $0x77,%al
  105223:	eb 02                	jmp    105227 <perm2str+0x2f>
  105225:	b0 2d                	mov    $0x2d,%al
  105227:	a2 2a bf 11 00       	mov    %al,0x11bf2a
    str[3] = '\0';
  10522c:	c6 05 2b bf 11 00 00 	movb   $0x0,0x11bf2b
    return str;
  105233:	b8 28 bf 11 00       	mov    $0x11bf28,%eax
}
  105238:	5d                   	pop    %ebp
  105239:	c3                   	ret    

0010523a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10523a:	55                   	push   %ebp
  10523b:	89 e5                	mov    %esp,%ebp
  10523d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105240:	8b 45 10             	mov    0x10(%ebp),%eax
  105243:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105246:	72 0d                	jb     105255 <get_pgtable_items+0x1b>
        return 0;
  105248:	b8 00 00 00 00       	mov    $0x0,%eax
  10524d:	e9 98 00 00 00       	jmp    1052ea <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  105252:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  105255:	8b 45 10             	mov    0x10(%ebp),%eax
  105258:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525b:	73 18                	jae    105275 <get_pgtable_items+0x3b>
  10525d:	8b 45 10             	mov    0x10(%ebp),%eax
  105260:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105267:	8b 45 14             	mov    0x14(%ebp),%eax
  10526a:	01 d0                	add    %edx,%eax
  10526c:	8b 00                	mov    (%eax),%eax
  10526e:	83 e0 01             	and    $0x1,%eax
  105271:	85 c0                	test   %eax,%eax
  105273:	74 dd                	je     105252 <get_pgtable_items+0x18>
    }
    if (start < right) {
  105275:	8b 45 10             	mov    0x10(%ebp),%eax
  105278:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10527b:	73 68                	jae    1052e5 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  10527d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105281:	74 08                	je     10528b <get_pgtable_items+0x51>
            *left_store = start;
  105283:	8b 45 18             	mov    0x18(%ebp),%eax
  105286:	8b 55 10             	mov    0x10(%ebp),%edx
  105289:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10528b:	8b 45 10             	mov    0x10(%ebp),%eax
  10528e:	8d 50 01             	lea    0x1(%eax),%edx
  105291:	89 55 10             	mov    %edx,0x10(%ebp)
  105294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10529b:	8b 45 14             	mov    0x14(%ebp),%eax
  10529e:	01 d0                	add    %edx,%eax
  1052a0:	8b 00                	mov    (%eax),%eax
  1052a2:	83 e0 07             	and    $0x7,%eax
  1052a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052a8:	eb 03                	jmp    1052ad <get_pgtable_items+0x73>
            start ++;
  1052aa:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052b3:	73 1d                	jae    1052d2 <get_pgtable_items+0x98>
  1052b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1052c2:	01 d0                	add    %edx,%eax
  1052c4:	8b 00                	mov    (%eax),%eax
  1052c6:	83 e0 07             	and    $0x7,%eax
  1052c9:	89 c2                	mov    %eax,%edx
  1052cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052ce:	39 c2                	cmp    %eax,%edx
  1052d0:	74 d8                	je     1052aa <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1052d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052d6:	74 08                	je     1052e0 <get_pgtable_items+0xa6>
            *right_store = start;
  1052d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052db:	8b 55 10             	mov    0x10(%ebp),%edx
  1052de:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052e3:	eb 05                	jmp    1052ea <get_pgtable_items+0xb0>
    }
    return 0;
  1052e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052ea:	89 ec                	mov    %ebp,%esp
  1052ec:	5d                   	pop    %ebp
  1052ed:	c3                   	ret    

001052ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052ee:	55                   	push   %ebp
  1052ef:	89 e5                	mov    %esp,%ebp
  1052f1:	57                   	push   %edi
  1052f2:	56                   	push   %esi
  1052f3:	53                   	push   %ebx
  1052f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052f7:	c7 04 24 14 70 10 00 	movl   $0x107014,(%esp)
  1052fe:	e8 62 b0 ff ff       	call   100365 <cprintf>
    size_t left, right = 0, perm;
  105303:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10530a:	e9 f2 00 00 00       	jmp    105401 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10530f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105312:	89 04 24             	mov    %eax,(%esp)
  105315:	e8 de fe ff ff       	call   1051f8 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10531a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10531d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105320:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105322:	89 d6                	mov    %edx,%esi
  105324:	c1 e6 16             	shl    $0x16,%esi
  105327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10532a:	89 d3                	mov    %edx,%ebx
  10532c:	c1 e3 16             	shl    $0x16,%ebx
  10532f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105332:	89 d1                	mov    %edx,%ecx
  105334:	c1 e1 16             	shl    $0x16,%ecx
  105337:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10533a:	8b 7d e0             	mov    -0x20(%ebp),%edi
  10533d:	29 fa                	sub    %edi,%edx
  10533f:	89 44 24 14          	mov    %eax,0x14(%esp)
  105343:	89 74 24 10          	mov    %esi,0x10(%esp)
  105347:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10534b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10534f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105353:	c7 04 24 45 70 10 00 	movl   $0x107045,(%esp)
  10535a:	e8 06 b0 ff ff       	call   100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10535f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105362:	c1 e0 0a             	shl    $0xa,%eax
  105365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105368:	eb 50                	jmp    1053ba <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10536a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10536d:	89 04 24             	mov    %eax,(%esp)
  105370:	e8 83 fe ff ff       	call   1051f8 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105375:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105378:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  10537b:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10537d:	89 d6                	mov    %edx,%esi
  10537f:	c1 e6 0c             	shl    $0xc,%esi
  105382:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105385:	89 d3                	mov    %edx,%ebx
  105387:	c1 e3 0c             	shl    $0xc,%ebx
  10538a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10538d:	89 d1                	mov    %edx,%ecx
  10538f:	c1 e1 0c             	shl    $0xc,%ecx
  105392:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105395:	8b 7d d8             	mov    -0x28(%ebp),%edi
  105398:	29 fa                	sub    %edi,%edx
  10539a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10539e:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053ae:	c7 04 24 64 70 10 00 	movl   $0x107064,(%esp)
  1053b5:	e8 ab af ff ff       	call   100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053ba:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1053bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053c5:	89 d3                	mov    %edx,%ebx
  1053c7:	c1 e3 0a             	shl    $0xa,%ebx
  1053ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053cd:	89 d1                	mov    %edx,%ecx
  1053cf:	c1 e1 0a             	shl    $0xa,%ecx
  1053d2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1053d5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1053d9:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1053dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  1053e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1053e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053ec:	89 0c 24             	mov    %ecx,(%esp)
  1053ef:	e8 46 fe ff ff       	call   10523a <get_pgtable_items>
  1053f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053fb:	0f 85 69 ff ff ff    	jne    10536a <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105401:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  105406:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105409:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10540c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105410:	8d 55 e0             	lea    -0x20(%ebp),%edx
  105413:	89 54 24 10          	mov    %edx,0x10(%esp)
  105417:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10541b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10541f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105426:	00 
  105427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10542e:	e8 07 fe ff ff       	call   10523a <get_pgtable_items>
  105433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105436:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10543a:	0f 85 cf fe ff ff    	jne    10530f <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105440:	c7 04 24 88 70 10 00 	movl   $0x107088,(%esp)
  105447:	e8 19 af ff ff       	call   100365 <cprintf>
}
  10544c:	90                   	nop
  10544d:	83 c4 4c             	add    $0x4c,%esp
  105450:	5b                   	pop    %ebx
  105451:	5e                   	pop    %esi
  105452:	5f                   	pop    %edi
  105453:	5d                   	pop    %ebp
  105454:	c3                   	ret    

00105455 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
  105455:	55                   	push   %ebp
  105456:	89 e5                	mov    %esp,%ebp
  105458:	83 ec 58             	sub    $0x58,%esp
  10545b:	8b 45 10             	mov    0x10(%ebp),%eax
  10545e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105461:	8b 45 14             	mov    0x14(%ebp),%eax
  105464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105467:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10546a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10546d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105470:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105473:	8b 45 18             	mov    0x18(%ebp),%eax
  105476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10547c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10547f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105482:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105488:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10548b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10548f:	74 1c                	je     1054ad <printnum+0x58>
  105491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105494:	ba 00 00 00 00       	mov    $0x0,%edx
  105499:	f7 75 e4             	divl   -0x1c(%ebp)
  10549c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10549f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1054a7:	f7 75 e4             	divl   -0x1c(%ebp)
  1054aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054b3:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054cb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
  1054ce:	8b 45 18             	mov    0x18(%ebp),%eax
  1054d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1054d6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1054d9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1054dc:	19 d1                	sbb    %edx,%ecx
  1054de:	72 4c                	jb     10552c <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
  1054e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054e6:	8b 45 20             	mov    0x20(%ebp),%eax
  1054e9:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054ed:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054f1:	8b 45 18             	mov    0x18(%ebp),%eax
  1054f4:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  105502:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105506:	8b 45 0c             	mov    0xc(%ebp),%eax
  105509:	89 44 24 04          	mov    %eax,0x4(%esp)
  10550d:	8b 45 08             	mov    0x8(%ebp),%eax
  105510:	89 04 24             	mov    %eax,(%esp)
  105513:	e8 3d ff ff ff       	call   105455 <printnum>
  105518:	eb 1b                	jmp    105535 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
  10551a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10551d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105521:	8b 45 20             	mov    0x20(%ebp),%eax
  105524:	89 04 24             	mov    %eax,(%esp)
  105527:	8b 45 08             	mov    0x8(%ebp),%eax
  10552a:	ff d0                	call   *%eax
        while (--width > 0)
  10552c:	ff 4d 1c             	decl   0x1c(%ebp)
  10552f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105533:	7f e5                	jg     10551a <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105535:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105538:	05 3c 71 10 00       	add    $0x10713c,%eax
  10553d:	0f b6 00             	movzbl (%eax),%eax
  105540:	0f be c0             	movsbl %al,%eax
  105543:	8b 55 0c             	mov    0xc(%ebp),%edx
  105546:	89 54 24 04          	mov    %edx,0x4(%esp)
  10554a:	89 04 24             	mov    %eax,(%esp)
  10554d:	8b 45 08             	mov    0x8(%ebp),%eax
  105550:	ff d0                	call   *%eax
}
  105552:	90                   	nop
  105553:	89 ec                	mov    %ebp,%esp
  105555:	5d                   	pop    %ebp
  105556:	c3                   	ret    

00105557 <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
  105557:	55                   	push   %ebp
  105558:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  10555a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10555e:	7e 14                	jle    105574 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
  105560:	8b 45 08             	mov    0x8(%ebp),%eax
  105563:	8b 00                	mov    (%eax),%eax
  105565:	8d 48 08             	lea    0x8(%eax),%ecx
  105568:	8b 55 08             	mov    0x8(%ebp),%edx
  10556b:	89 0a                	mov    %ecx,(%edx)
  10556d:	8b 50 04             	mov    0x4(%eax),%edx
  105570:	8b 00                	mov    (%eax),%eax
  105572:	eb 30                	jmp    1055a4 <getuint+0x4d>
    }
    else if (lflag)
  105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105578:	74 16                	je     105590 <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
  10557a:	8b 45 08             	mov    0x8(%ebp),%eax
  10557d:	8b 00                	mov    (%eax),%eax
  10557f:	8d 48 04             	lea    0x4(%eax),%ecx
  105582:	8b 55 08             	mov    0x8(%ebp),%edx
  105585:	89 0a                	mov    %ecx,(%edx)
  105587:	8b 00                	mov    (%eax),%eax
  105589:	ba 00 00 00 00       	mov    $0x0,%edx
  10558e:	eb 14                	jmp    1055a4 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
  105590:	8b 45 08             	mov    0x8(%ebp),%eax
  105593:	8b 00                	mov    (%eax),%eax
  105595:	8d 48 04             	lea    0x4(%eax),%ecx
  105598:	8b 55 08             	mov    0x8(%ebp),%edx
  10559b:	89 0a                	mov    %ecx,(%edx)
  10559d:	8b 00                	mov    (%eax),%eax
  10559f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055a4:	5d                   	pop    %ebp
  1055a5:	c3                   	ret    

001055a6 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
  1055a6:	55                   	push   %ebp
  1055a7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
  1055a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055ad:	7e 14                	jle    1055c3 <getint+0x1d>
    {
        return va_arg(*ap, long long);
  1055af:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b2:	8b 00                	mov    (%eax),%eax
  1055b4:	8d 48 08             	lea    0x8(%eax),%ecx
  1055b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ba:	89 0a                	mov    %ecx,(%edx)
  1055bc:	8b 50 04             	mov    0x4(%eax),%edx
  1055bf:	8b 00                	mov    (%eax),%eax
  1055c1:	eb 28                	jmp    1055eb <getint+0x45>
    }
    else if (lflag)
  1055c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055c7:	74 12                	je     1055db <getint+0x35>
    {
        return va_arg(*ap, long);
  1055c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055cc:	8b 00                	mov    (%eax),%eax
  1055ce:	8d 48 04             	lea    0x4(%eax),%ecx
  1055d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055d4:	89 0a                	mov    %ecx,(%edx)
  1055d6:	8b 00                	mov    (%eax),%eax
  1055d8:	99                   	cltd   
  1055d9:	eb 10                	jmp    1055eb <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
  1055db:	8b 45 08             	mov    0x8(%ebp),%eax
  1055de:	8b 00                	mov    (%eax),%eax
  1055e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1055e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1055e6:	89 0a                	mov    %ecx,(%edx)
  1055e8:	8b 00                	mov    (%eax),%eax
  1055ea:	99                   	cltd   
    }
}
  1055eb:	5d                   	pop    %ebp
  1055ec:	c3                   	ret    

001055ed <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
  1055ed:	55                   	push   %ebp
  1055ee:	89 e5                	mov    %esp,%ebp
  1055f0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055f3:	8d 45 14             	lea    0x14(%ebp),%eax
  1055f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105600:	8b 45 10             	mov    0x10(%ebp),%eax
  105603:	89 44 24 08          	mov    %eax,0x8(%esp)
  105607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10560a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560e:	8b 45 08             	mov    0x8(%ebp),%eax
  105611:	89 04 24             	mov    %eax,(%esp)
  105614:	e8 05 00 00 00       	call   10561e <vprintfmt>
    va_end(ap);
}
  105619:	90                   	nop
  10561a:	89 ec                	mov    %ebp,%esp
  10561c:	5d                   	pop    %ebp
  10561d:	c3                   	ret    

0010561e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
  10561e:	55                   	push   %ebp
  10561f:	89 e5                	mov    %esp,%ebp
  105621:	56                   	push   %esi
  105622:	53                   	push   %ebx
  105623:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
  105626:	eb 17                	jmp    10563f <vprintfmt+0x21>
        {
            if (ch == '\0')
  105628:	85 db                	test   %ebx,%ebx
  10562a:	0f 84 bf 03 00 00    	je     1059ef <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
  105630:	8b 45 0c             	mov    0xc(%ebp),%eax
  105633:	89 44 24 04          	mov    %eax,0x4(%esp)
  105637:	89 1c 24             	mov    %ebx,(%esp)
  10563a:	8b 45 08             	mov    0x8(%ebp),%eax
  10563d:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
  10563f:	8b 45 10             	mov    0x10(%ebp),%eax
  105642:	8d 50 01             	lea    0x1(%eax),%edx
  105645:	89 55 10             	mov    %edx,0x10(%ebp)
  105648:	0f b6 00             	movzbl (%eax),%eax
  10564b:	0f b6 d8             	movzbl %al,%ebx
  10564e:	83 fb 25             	cmp    $0x25,%ebx
  105651:	75 d5                	jne    105628 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105653:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105657:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10565e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105661:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105664:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10566b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10566e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
  105671:	8b 45 10             	mov    0x10(%ebp),%eax
  105674:	8d 50 01             	lea    0x1(%eax),%edx
  105677:	89 55 10             	mov    %edx,0x10(%ebp)
  10567a:	0f b6 00             	movzbl (%eax),%eax
  10567d:	0f b6 d8             	movzbl %al,%ebx
  105680:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105683:	83 f8 55             	cmp    $0x55,%eax
  105686:	0f 87 37 03 00 00    	ja     1059c3 <vprintfmt+0x3a5>
  10568c:	8b 04 85 60 71 10 00 	mov    0x107160(,%eax,4),%eax
  105693:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
  105695:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105699:	eb d6                	jmp    105671 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10569b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10569f:	eb d0                	jmp    105671 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
  1056a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
  1056a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056ab:	89 d0                	mov    %edx,%eax
  1056ad:	c1 e0 02             	shl    $0x2,%eax
  1056b0:	01 d0                	add    %edx,%eax
  1056b2:	01 c0                	add    %eax,%eax
  1056b4:	01 d8                	add    %ebx,%eax
  1056b6:	83 e8 30             	sub    $0x30,%eax
  1056b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1056bf:	0f b6 00             	movzbl (%eax),%eax
  1056c2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
  1056c5:	83 fb 2f             	cmp    $0x2f,%ebx
  1056c8:	7e 38                	jle    105702 <vprintfmt+0xe4>
  1056ca:	83 fb 39             	cmp    $0x39,%ebx
  1056cd:	7f 33                	jg     105702 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
  1056cf:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1056d2:	eb d4                	jmp    1056a8 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1056d4:	8b 45 14             	mov    0x14(%ebp),%eax
  1056d7:	8d 50 04             	lea    0x4(%eax),%edx
  1056da:	89 55 14             	mov    %edx,0x14(%ebp)
  1056dd:	8b 00                	mov    (%eax),%eax
  1056df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056e2:	eb 1f                	jmp    105703 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1056e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056e8:	79 87                	jns    105671 <vprintfmt+0x53>
                width = 0;
  1056ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056f1:	e9 7b ff ff ff       	jmp    105671 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1056f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056fd:	e9 6f ff ff ff       	jmp    105671 <vprintfmt+0x53>
            goto process_precision;
  105702:	90                   	nop

        process_precision:
            if (width < 0)
  105703:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105707:	0f 89 64 ff ff ff    	jns    105671 <vprintfmt+0x53>
                width = precision, precision = -1;
  10570d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105710:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105713:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10571a:	e9 52 ff ff ff       	jmp    105671 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
  10571f:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105722:	e9 4a ff ff ff       	jmp    105671 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105727:	8b 45 14             	mov    0x14(%ebp),%eax
  10572a:	8d 50 04             	lea    0x4(%eax),%edx
  10572d:	89 55 14             	mov    %edx,0x14(%ebp)
  105730:	8b 00                	mov    (%eax),%eax
  105732:	8b 55 0c             	mov    0xc(%ebp),%edx
  105735:	89 54 24 04          	mov    %edx,0x4(%esp)
  105739:	89 04 24             	mov    %eax,(%esp)
  10573c:	8b 45 08             	mov    0x8(%ebp),%eax
  10573f:	ff d0                	call   *%eax
            break;
  105741:	e9 a4 02 00 00       	jmp    1059ea <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105746:	8b 45 14             	mov    0x14(%ebp),%eax
  105749:	8d 50 04             	lea    0x4(%eax),%edx
  10574c:	89 55 14             	mov    %edx,0x14(%ebp)
  10574f:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
  105751:	85 db                	test   %ebx,%ebx
  105753:	79 02                	jns    105757 <vprintfmt+0x139>
            {
                err = -err;
  105755:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
  105757:	83 fb 06             	cmp    $0x6,%ebx
  10575a:	7f 0b                	jg     105767 <vprintfmt+0x149>
  10575c:	8b 34 9d 20 71 10 00 	mov    0x107120(,%ebx,4),%esi
  105763:	85 f6                	test   %esi,%esi
  105765:	75 23                	jne    10578a <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
  105767:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10576b:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  105772:	00 
  105773:	8b 45 0c             	mov    0xc(%ebp),%eax
  105776:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577a:	8b 45 08             	mov    0x8(%ebp),%eax
  10577d:	89 04 24             	mov    %eax,(%esp)
  105780:	e8 68 fe ff ff       	call   1055ed <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105785:	e9 60 02 00 00       	jmp    1059ea <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  10578a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10578e:	c7 44 24 08 56 71 10 	movl   $0x107156,0x8(%esp)
  105795:	00 
  105796:	8b 45 0c             	mov    0xc(%ebp),%eax
  105799:	89 44 24 04          	mov    %eax,0x4(%esp)
  10579d:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a0:	89 04 24             	mov    %eax,(%esp)
  1057a3:	e8 45 fe ff ff       	call   1055ed <printfmt>
            break;
  1057a8:	e9 3d 02 00 00       	jmp    1059ea <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
  1057ad:	8b 45 14             	mov    0x14(%ebp),%eax
  1057b0:	8d 50 04             	lea    0x4(%eax),%edx
  1057b3:	89 55 14             	mov    %edx,0x14(%ebp)
  1057b6:	8b 30                	mov    (%eax),%esi
  1057b8:	85 f6                	test   %esi,%esi
  1057ba:	75 05                	jne    1057c1 <vprintfmt+0x1a3>
            {
                p = "(null)";
  1057bc:	be 59 71 10 00       	mov    $0x107159,%esi
            }
            if (width > 0 && padc != '-')
  1057c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057c5:	7e 76                	jle    10583d <vprintfmt+0x21f>
  1057c7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057cb:	74 70                	je     10583d <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
  1057cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d4:	89 34 24             	mov    %esi,(%esp)
  1057d7:	e8 16 03 00 00       	call   105af2 <strnlen>
  1057dc:	89 c2                	mov    %eax,%edx
  1057de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057e1:	29 d0                	sub    %edx,%eax
  1057e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057e6:	eb 16                	jmp    1057fe <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
  1057e8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057f3:	89 04 24             	mov    %eax,(%esp)
  1057f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f9:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
  1057fb:	ff 4d e8             	decl   -0x18(%ebp)
  1057fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105802:	7f e4                	jg     1057e8 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  105804:	eb 37                	jmp    10583d <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
  105806:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10580a:	74 1f                	je     10582b <vprintfmt+0x20d>
  10580c:	83 fb 1f             	cmp    $0x1f,%ebx
  10580f:	7e 05                	jle    105816 <vprintfmt+0x1f8>
  105811:	83 fb 7e             	cmp    $0x7e,%ebx
  105814:	7e 15                	jle    10582b <vprintfmt+0x20d>
                {
                    putch('?', putdat);
  105816:	8b 45 0c             	mov    0xc(%ebp),%eax
  105819:	89 44 24 04          	mov    %eax,0x4(%esp)
  10581d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105824:	8b 45 08             	mov    0x8(%ebp),%eax
  105827:	ff d0                	call   *%eax
  105829:	eb 0f                	jmp    10583a <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
  10582b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105832:	89 1c 24             	mov    %ebx,(%esp)
  105835:	8b 45 08             	mov    0x8(%ebp),%eax
  105838:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  10583a:	ff 4d e8             	decl   -0x18(%ebp)
  10583d:	89 f0                	mov    %esi,%eax
  10583f:	8d 70 01             	lea    0x1(%eax),%esi
  105842:	0f b6 00             	movzbl (%eax),%eax
  105845:	0f be d8             	movsbl %al,%ebx
  105848:	85 db                	test   %ebx,%ebx
  10584a:	74 27                	je     105873 <vprintfmt+0x255>
  10584c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105850:	78 b4                	js     105806 <vprintfmt+0x1e8>
  105852:	ff 4d e4             	decl   -0x1c(%ebp)
  105855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105859:	79 ab                	jns    105806 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
  10585b:	eb 16                	jmp    105873 <vprintfmt+0x255>
            {
                putch(' ', putdat);
  10585d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105860:	89 44 24 04          	mov    %eax,0x4(%esp)
  105864:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10586b:	8b 45 08             	mov    0x8(%ebp),%eax
  10586e:	ff d0                	call   *%eax
            for (; width > 0; width--)
  105870:	ff 4d e8             	decl   -0x18(%ebp)
  105873:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105877:	7f e4                	jg     10585d <vprintfmt+0x23f>
            }
            break;
  105879:	e9 6c 01 00 00       	jmp    1059ea <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10587e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105881:	89 44 24 04          	mov    %eax,0x4(%esp)
  105885:	8d 45 14             	lea    0x14(%ebp),%eax
  105888:	89 04 24             	mov    %eax,(%esp)
  10588b:	e8 16 fd ff ff       	call   1055a6 <getint>
  105890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105893:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
  105896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10589c:	85 d2                	test   %edx,%edx
  10589e:	79 26                	jns    1058c6 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
  1058a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b1:	ff d0                	call   *%eax
                num = -(long long)num;
  1058b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058b9:	f7 d8                	neg    %eax
  1058bb:	83 d2 00             	adc    $0x0,%edx
  1058be:	f7 da                	neg    %edx
  1058c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058cd:	e9 a8 00 00 00       	jmp    10597a <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d9:	8d 45 14             	lea    0x14(%ebp),%eax
  1058dc:	89 04 24             	mov    %eax,(%esp)
  1058df:	e8 73 fc ff ff       	call   105557 <getuint>
  1058e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058f1:	e9 84 00 00 00       	jmp    10597a <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fd:	8d 45 14             	lea    0x14(%ebp),%eax
  105900:	89 04 24             	mov    %eax,(%esp)
  105903:	e8 4f fc ff ff       	call   105557 <getuint>
  105908:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10590b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10590e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105915:	eb 63                	jmp    10597a <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105917:	8b 45 0c             	mov    0xc(%ebp),%eax
  10591a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105925:	8b 45 08             	mov    0x8(%ebp),%eax
  105928:	ff d0                	call   *%eax
            putch('x', putdat);
  10592a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105931:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105938:	8b 45 08             	mov    0x8(%ebp),%eax
  10593b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10593d:	8b 45 14             	mov    0x14(%ebp),%eax
  105940:	8d 50 04             	lea    0x4(%eax),%edx
  105943:	89 55 14             	mov    %edx,0x14(%ebp)
  105946:	8b 00                	mov    (%eax),%eax
  105948:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10594b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105952:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105959:	eb 1f                	jmp    10597a <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10595b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10595e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105962:	8d 45 14             	lea    0x14(%ebp),%eax
  105965:	89 04 24             	mov    %eax,(%esp)
  105968:	e8 ea fb ff ff       	call   105557 <getuint>
  10596d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105970:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105973:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10597a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10597e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105981:	89 54 24 18          	mov    %edx,0x18(%esp)
  105985:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105988:	89 54 24 14          	mov    %edx,0x14(%esp)
  10598c:	89 44 24 10          	mov    %eax,0x10(%esp)
  105990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105996:	89 44 24 08          	mov    %eax,0x8(%esp)
  10599a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10599e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a8:	89 04 24             	mov    %eax,(%esp)
  1059ab:	e8 a5 fa ff ff       	call   105455 <printnum>
            break;
  1059b0:	eb 38                	jmp    1059ea <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b9:	89 1c 24             	mov    %ebx,(%esp)
  1059bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bf:	ff d0                	call   *%eax
            break;
  1059c1:	eb 27                	jmp    1059ea <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ca:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d4:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
  1059d6:	ff 4d 10             	decl   0x10(%ebp)
  1059d9:	eb 03                	jmp    1059de <vprintfmt+0x3c0>
  1059db:	ff 4d 10             	decl   0x10(%ebp)
  1059de:	8b 45 10             	mov    0x10(%ebp),%eax
  1059e1:	48                   	dec    %eax
  1059e2:	0f b6 00             	movzbl (%eax),%eax
  1059e5:	3c 25                	cmp    $0x25,%al
  1059e7:	75 f2                	jne    1059db <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1059e9:	90                   	nop
    {
  1059ea:	e9 37 fc ff ff       	jmp    105626 <vprintfmt+0x8>
                return;
  1059ef:	90                   	nop
        }
    }
}
  1059f0:	83 c4 40             	add    $0x40,%esp
  1059f3:	5b                   	pop    %ebx
  1059f4:	5e                   	pop    %esi
  1059f5:	5d                   	pop    %ebp
  1059f6:	c3                   	ret    

001059f7 <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
  1059f7:	55                   	push   %ebp
  1059f8:	89 e5                	mov    %esp,%ebp
    b->cnt++;
  1059fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059fd:	8b 40 08             	mov    0x8(%eax),%eax
  105a00:	8d 50 01             	lea    0x1(%eax),%edx
  105a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a06:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
  105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0c:	8b 10                	mov    (%eax),%edx
  105a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a11:	8b 40 04             	mov    0x4(%eax),%eax
  105a14:	39 c2                	cmp    %eax,%edx
  105a16:	73 12                	jae    105a2a <sprintputch+0x33>
    {
        *b->buf++ = ch;
  105a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1b:	8b 00                	mov    (%eax),%eax
  105a1d:	8d 48 01             	lea    0x1(%eax),%ecx
  105a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a23:	89 0a                	mov    %ecx,(%edx)
  105a25:	8b 55 08             	mov    0x8(%ebp),%edx
  105a28:	88 10                	mov    %dl,(%eax)
    }
}
  105a2a:	90                   	nop
  105a2b:	5d                   	pop    %ebp
  105a2c:	c3                   	ret    

00105a2d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
  105a2d:	55                   	push   %ebp
  105a2e:	89 e5                	mov    %esp,%ebp
  105a30:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a33:	8d 45 14             	lea    0x14(%ebp),%eax
  105a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a40:	8b 45 10             	mov    0x10(%ebp),%eax
  105a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a51:	89 04 24             	mov    %eax,(%esp)
  105a54:	e8 0a 00 00 00       	call   105a63 <vsnprintf>
  105a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a5f:	89 ec                	mov    %ebp,%esp
  105a61:	5d                   	pop    %ebp
  105a62:	c3                   	ret    

00105a63 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
  105a63:	55                   	push   %ebp
  105a64:	89 e5                	mov    %esp,%ebp
  105a66:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a69:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a72:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a75:	8b 45 08             	mov    0x8(%ebp),%eax
  105a78:	01 d0                	add    %edx,%eax
  105a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
  105a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a88:	74 0a                	je     105a94 <vsnprintf+0x31>
  105a8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a90:	39 c2                	cmp    %eax,%edx
  105a92:	76 07                	jbe    105a9b <vsnprintf+0x38>
    {
        return -E_INVAL;
  105a94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a99:	eb 2a                	jmp    105ac5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
  105a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  105a9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  105aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  105aa9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab0:	c7 04 24 f7 59 10 00 	movl   $0x1059f7,(%esp)
  105ab7:	e8 62 fb ff ff       	call   10561e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105abf:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ac5:	89 ec                	mov    %ebp,%esp
  105ac7:	5d                   	pop    %ebp
  105ac8:	c3                   	ret    

00105ac9 <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
  105ac9:	55                   	push   %ebp
  105aca:	89 e5                	mov    %esp,%ebp
  105acc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105acf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
  105ad6:	eb 03                	jmp    105adb <strlen+0x12>
    {
        cnt++;
  105ad8:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
  105adb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ade:	8d 50 01             	lea    0x1(%eax),%edx
  105ae1:	89 55 08             	mov    %edx,0x8(%ebp)
  105ae4:	0f b6 00             	movzbl (%eax),%eax
  105ae7:	84 c0                	test   %al,%al
  105ae9:	75 ed                	jne    105ad8 <strlen+0xf>
    }
    return cnt;
  105aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105aee:	89 ec                	mov    %ebp,%esp
  105af0:	5d                   	pop    %ebp
  105af1:	c3                   	ret    

00105af2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
  105af2:	55                   	push   %ebp
  105af3:	89 e5                	mov    %esp,%ebp
  105af5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  105aff:	eb 03                	jmp    105b04 <strnlen+0x12>
    {
        cnt++;
  105b01:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
  105b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b07:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b0a:	73 10                	jae    105b1c <strnlen+0x2a>
  105b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0f:	8d 50 01             	lea    0x1(%eax),%edx
  105b12:	89 55 08             	mov    %edx,0x8(%ebp)
  105b15:	0f b6 00             	movzbl (%eax),%eax
  105b18:	84 c0                	test   %al,%al
  105b1a:	75 e5                	jne    105b01 <strnlen+0xf>
    }
    return cnt;
  105b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b1f:	89 ec                	mov    %ebp,%esp
  105b21:	5d                   	pop    %ebp
  105b22:	c3                   	ret    

00105b23 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
  105b23:	55                   	push   %ebp
  105b24:	89 e5                	mov    %esp,%ebp
  105b26:	57                   	push   %edi
  105b27:	56                   	push   %esi
  105b28:	83 ec 20             	sub    $0x20,%esp
  105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
  105b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b3d:	89 d1                	mov    %edx,%ecx
  105b3f:	89 c2                	mov    %eax,%edx
  105b41:	89 ce                	mov    %ecx,%esi
  105b43:	89 d7                	mov    %edx,%edi
  105b45:	ac                   	lods   %ds:(%esi),%al
  105b46:	aa                   	stos   %al,%es:(%edi)
  105b47:	84 c0                	test   %al,%al
  105b49:	75 fa                	jne    105b45 <strcpy+0x22>
  105b4b:	89 fa                	mov    %edi,%edx
  105b4d:	89 f1                	mov    %esi,%ecx
  105b4f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b52:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
  105b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b5b:	83 c4 20             	add    $0x20,%esp
  105b5e:	5e                   	pop    %esi
  105b5f:	5f                   	pop    %edi
  105b60:	5d                   	pop    %ebp
  105b61:	c3                   	ret    

00105b62 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
  105b62:	55                   	push   %ebp
  105b63:	89 e5                	mov    %esp,%ebp
  105b65:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b68:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
  105b6e:	eb 1e                	jmp    105b8e <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
  105b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b73:	0f b6 10             	movzbl (%eax),%edx
  105b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b79:	88 10                	mov    %dl,(%eax)
  105b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b7e:	0f b6 00             	movzbl (%eax),%eax
  105b81:	84 c0                	test   %al,%al
  105b83:	74 03                	je     105b88 <strncpy+0x26>
        {
            src++;
  105b85:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
  105b88:	ff 45 fc             	incl   -0x4(%ebp)
  105b8b:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
  105b8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b92:	75 dc                	jne    105b70 <strncpy+0xe>
    }
    return dst;
  105b94:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b97:	89 ec                	mov    %ebp,%esp
  105b99:	5d                   	pop    %ebp
  105b9a:	c3                   	ret    

00105b9b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
  105b9b:	55                   	push   %ebp
  105b9c:	89 e5                	mov    %esp,%ebp
  105b9e:	57                   	push   %edi
  105b9f:	56                   	push   %esi
  105ba0:	83 ec 20             	sub    $0x20,%esp
  105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
  105baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bb5:	89 d1                	mov    %edx,%ecx
  105bb7:	89 c2                	mov    %eax,%edx
  105bb9:	89 ce                	mov    %ecx,%esi
  105bbb:	89 d7                	mov    %edx,%edi
  105bbd:	ac                   	lods   %ds:(%esi),%al
  105bbe:	ae                   	scas   %es:(%edi),%al
  105bbf:	75 08                	jne    105bc9 <strcmp+0x2e>
  105bc1:	84 c0                	test   %al,%al
  105bc3:	75 f8                	jne    105bbd <strcmp+0x22>
  105bc5:	31 c0                	xor    %eax,%eax
  105bc7:	eb 04                	jmp    105bcd <strcmp+0x32>
  105bc9:	19 c0                	sbb    %eax,%eax
  105bcb:	0c 01                	or     $0x1,%al
  105bcd:	89 fa                	mov    %edi,%edx
  105bcf:	89 f1                	mov    %esi,%ecx
  105bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bd4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bd7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bdd:	83 c4 20             	add    $0x20,%esp
  105be0:	5e                   	pop    %esi
  105be1:	5f                   	pop    %edi
  105be2:	5d                   	pop    %ebp
  105be3:	c3                   	ret    

00105be4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
  105be4:	55                   	push   %ebp
  105be5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  105be7:	eb 09                	jmp    105bf2 <strncmp+0xe>
    {
        n--, s1++, s2++;
  105be9:	ff 4d 10             	decl   0x10(%ebp)
  105bec:	ff 45 08             	incl   0x8(%ebp)
  105bef:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
  105bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bf6:	74 1a                	je     105c12 <strncmp+0x2e>
  105bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfb:	0f b6 00             	movzbl (%eax),%eax
  105bfe:	84 c0                	test   %al,%al
  105c00:	74 10                	je     105c12 <strncmp+0x2e>
  105c02:	8b 45 08             	mov    0x8(%ebp),%eax
  105c05:	0f b6 10             	movzbl (%eax),%edx
  105c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0b:	0f b6 00             	movzbl (%eax),%eax
  105c0e:	38 c2                	cmp    %al,%dl
  105c10:	74 d7                	je     105be9 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c16:	74 18                	je     105c30 <strncmp+0x4c>
  105c18:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1b:	0f b6 00             	movzbl (%eax),%eax
  105c1e:	0f b6 d0             	movzbl %al,%edx
  105c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c24:	0f b6 00             	movzbl (%eax),%eax
  105c27:	0f b6 c8             	movzbl %al,%ecx
  105c2a:	89 d0                	mov    %edx,%eax
  105c2c:	29 c8                	sub    %ecx,%eax
  105c2e:	eb 05                	jmp    105c35 <strncmp+0x51>
  105c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c35:	5d                   	pop    %ebp
  105c36:	c3                   	ret    

00105c37 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
  105c37:	55                   	push   %ebp
  105c38:	89 e5                	mov    %esp,%ebp
  105c3a:	83 ec 04             	sub    $0x4,%esp
  105c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c40:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  105c43:	eb 13                	jmp    105c58 <strchr+0x21>
    {
        if (*s == c)
  105c45:	8b 45 08             	mov    0x8(%ebp),%eax
  105c48:	0f b6 00             	movzbl (%eax),%eax
  105c4b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c4e:	75 05                	jne    105c55 <strchr+0x1e>
        {
            return (char *)s;
  105c50:	8b 45 08             	mov    0x8(%ebp),%eax
  105c53:	eb 12                	jmp    105c67 <strchr+0x30>
        }
        s++;
  105c55:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  105c58:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5b:	0f b6 00             	movzbl (%eax),%eax
  105c5e:	84 c0                	test   %al,%al
  105c60:	75 e3                	jne    105c45 <strchr+0xe>
    }
    return NULL;
  105c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c67:	89 ec                	mov    %ebp,%esp
  105c69:	5d                   	pop    %ebp
  105c6a:	c3                   	ret    

00105c6b <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
  105c6b:	55                   	push   %ebp
  105c6c:	89 e5                	mov    %esp,%ebp
  105c6e:	83 ec 04             	sub    $0x4,%esp
  105c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c74:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
  105c77:	eb 0e                	jmp    105c87 <strfind+0x1c>
    {
        if (*s == c)
  105c79:	8b 45 08             	mov    0x8(%ebp),%eax
  105c7c:	0f b6 00             	movzbl (%eax),%eax
  105c7f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c82:	74 0f                	je     105c93 <strfind+0x28>
        {
            break;
        }
        s++;
  105c84:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
  105c87:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8a:	0f b6 00             	movzbl (%eax),%eax
  105c8d:	84 c0                	test   %al,%al
  105c8f:	75 e8                	jne    105c79 <strfind+0xe>
  105c91:	eb 01                	jmp    105c94 <strfind+0x29>
            break;
  105c93:	90                   	nop
    }
    return (char *)s;
  105c94:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c97:	89 ec                	mov    %ebp,%esp
  105c99:	5d                   	pop    %ebp
  105c9a:	c3                   	ret    

00105c9b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
  105c9b:	55                   	push   %ebp
  105c9c:	89 e5                	mov    %esp,%ebp
  105c9e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ca8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
  105caf:	eb 03                	jmp    105cb4 <strtol+0x19>
    {
        s++;
  105cb1:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
  105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb7:	0f b6 00             	movzbl (%eax),%eax
  105cba:	3c 20                	cmp    $0x20,%al
  105cbc:	74 f3                	je     105cb1 <strtol+0x16>
  105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc1:	0f b6 00             	movzbl (%eax),%eax
  105cc4:	3c 09                	cmp    $0x9,%al
  105cc6:	74 e9                	je     105cb1 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
  105cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccb:	0f b6 00             	movzbl (%eax),%eax
  105cce:	3c 2b                	cmp    $0x2b,%al
  105cd0:	75 05                	jne    105cd7 <strtol+0x3c>
    {
        s++;
  105cd2:	ff 45 08             	incl   0x8(%ebp)
  105cd5:	eb 14                	jmp    105ceb <strtol+0x50>
    }
    else if (*s == '-')
  105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cda:	0f b6 00             	movzbl (%eax),%eax
  105cdd:	3c 2d                	cmp    $0x2d,%al
  105cdf:	75 0a                	jne    105ceb <strtol+0x50>
    {
        s++, neg = 1;
  105ce1:	ff 45 08             	incl   0x8(%ebp)
  105ce4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  105ceb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cef:	74 06                	je     105cf7 <strtol+0x5c>
  105cf1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cf5:	75 22                	jne    105d19 <strtol+0x7e>
  105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfa:	0f b6 00             	movzbl (%eax),%eax
  105cfd:	3c 30                	cmp    $0x30,%al
  105cff:	75 18                	jne    105d19 <strtol+0x7e>
  105d01:	8b 45 08             	mov    0x8(%ebp),%eax
  105d04:	40                   	inc    %eax
  105d05:	0f b6 00             	movzbl (%eax),%eax
  105d08:	3c 78                	cmp    $0x78,%al
  105d0a:	75 0d                	jne    105d19 <strtol+0x7e>
    {
        s += 2, base = 16;
  105d0c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d10:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d17:	eb 29                	jmp    105d42 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
  105d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d1d:	75 16                	jne    105d35 <strtol+0x9a>
  105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d22:	0f b6 00             	movzbl (%eax),%eax
  105d25:	3c 30                	cmp    $0x30,%al
  105d27:	75 0c                	jne    105d35 <strtol+0x9a>
    {
        s++, base = 8;
  105d29:	ff 45 08             	incl   0x8(%ebp)
  105d2c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d33:	eb 0d                	jmp    105d42 <strtol+0xa7>
    }
    else if (base == 0)
  105d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d39:	75 07                	jne    105d42 <strtol+0xa7>
    {
        base = 10;
  105d3b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
  105d42:	8b 45 08             	mov    0x8(%ebp),%eax
  105d45:	0f b6 00             	movzbl (%eax),%eax
  105d48:	3c 2f                	cmp    $0x2f,%al
  105d4a:	7e 1b                	jle    105d67 <strtol+0xcc>
  105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4f:	0f b6 00             	movzbl (%eax),%eax
  105d52:	3c 39                	cmp    $0x39,%al
  105d54:	7f 11                	jg     105d67 <strtol+0xcc>
        {
            dig = *s - '0';
  105d56:	8b 45 08             	mov    0x8(%ebp),%eax
  105d59:	0f b6 00             	movzbl (%eax),%eax
  105d5c:	0f be c0             	movsbl %al,%eax
  105d5f:	83 e8 30             	sub    $0x30,%eax
  105d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d65:	eb 48                	jmp    105daf <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
  105d67:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6a:	0f b6 00             	movzbl (%eax),%eax
  105d6d:	3c 60                	cmp    $0x60,%al
  105d6f:	7e 1b                	jle    105d8c <strtol+0xf1>
  105d71:	8b 45 08             	mov    0x8(%ebp),%eax
  105d74:	0f b6 00             	movzbl (%eax),%eax
  105d77:	3c 7a                	cmp    $0x7a,%al
  105d79:	7f 11                	jg     105d8c <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
  105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7e:	0f b6 00             	movzbl (%eax),%eax
  105d81:	0f be c0             	movsbl %al,%eax
  105d84:	83 e8 57             	sub    $0x57,%eax
  105d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d8a:	eb 23                	jmp    105daf <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
  105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8f:	0f b6 00             	movzbl (%eax),%eax
  105d92:	3c 40                	cmp    $0x40,%al
  105d94:	7e 3b                	jle    105dd1 <strtol+0x136>
  105d96:	8b 45 08             	mov    0x8(%ebp),%eax
  105d99:	0f b6 00             	movzbl (%eax),%eax
  105d9c:	3c 5a                	cmp    $0x5a,%al
  105d9e:	7f 31                	jg     105dd1 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
  105da0:	8b 45 08             	mov    0x8(%ebp),%eax
  105da3:	0f b6 00             	movzbl (%eax),%eax
  105da6:	0f be c0             	movsbl %al,%eax
  105da9:	83 e8 37             	sub    $0x37,%eax
  105dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
  105daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105db2:	3b 45 10             	cmp    0x10(%ebp),%eax
  105db5:	7d 19                	jge    105dd0 <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
  105db7:	ff 45 08             	incl   0x8(%ebp)
  105dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dbd:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dc1:	89 c2                	mov    %eax,%edx
  105dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dc6:	01 d0                	add    %edx,%eax
  105dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
  105dcb:	e9 72 ff ff ff       	jmp    105d42 <strtol+0xa7>
            break;
  105dd0:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
  105dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dd5:	74 08                	je     105ddf <strtol+0x144>
    {
        *endptr = (char *)s;
  105dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dda:	8b 55 08             	mov    0x8(%ebp),%edx
  105ddd:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105de3:	74 07                	je     105dec <strtol+0x151>
  105de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105de8:	f7 d8                	neg    %eax
  105dea:	eb 03                	jmp    105def <strtol+0x154>
  105dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105def:	89 ec                	mov    %ebp,%esp
  105df1:	5d                   	pop    %ebp
  105df2:	c3                   	ret    

00105df3 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
  105df3:	55                   	push   %ebp
  105df4:	89 e5                	mov    %esp,%ebp
  105df6:	83 ec 28             	sub    $0x28,%esp
  105df9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e02:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105e06:	8b 45 08             	mov    0x8(%ebp),%eax
  105e09:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105e0c:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  105e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
  105e15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e18:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e1c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e1f:	89 d7                	mov    %edx,%edi
  105e21:	f3 aa                	rep stos %al,%es:(%edi)
  105e23:	89 fa                	mov    %edi,%edx
  105e25:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e28:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
  105e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e31:	89 ec                	mov    %ebp,%esp
  105e33:	5d                   	pop    %ebp
  105e34:	c3                   	ret    

00105e35 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
  105e35:	55                   	push   %ebp
  105e36:	89 e5                	mov    %esp,%ebp
  105e38:	57                   	push   %edi
  105e39:	56                   	push   %esi
  105e3a:	53                   	push   %ebx
  105e3b:	83 ec 30             	sub    $0x30,%esp
  105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  105e4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
  105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e56:	73 42                	jae    105e9a <memmove+0x65>
  105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e67:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  105e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e6d:	c1 e8 02             	shr    $0x2,%eax
  105e70:	89 c1                	mov    %eax,%ecx
    asm volatile(
  105e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e78:	89 d7                	mov    %edx,%edi
  105e7a:	89 c6                	mov    %eax,%esi
  105e7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e7e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e81:	83 e1 03             	and    $0x3,%ecx
  105e84:	74 02                	je     105e88 <memmove+0x53>
  105e86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e88:	89 f0                	mov    %esi,%eax
  105e8a:	89 fa                	mov    %edi,%edx
  105e8c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e8f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e92:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105e98:	eb 36                	jmp    105ed0 <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
  105e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ea3:	01 c2                	add    %eax,%edx
  105ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ea8:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eae:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
  105eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb4:	89 c1                	mov    %eax,%ecx
  105eb6:	89 d8                	mov    %ebx,%eax
  105eb8:	89 d6                	mov    %edx,%esi
  105eba:	89 c7                	mov    %eax,%edi
  105ebc:	fd                   	std    
  105ebd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ebf:	fc                   	cld    
  105ec0:	89 f8                	mov    %edi,%eax
  105ec2:	89 f2                	mov    %esi,%edx
  105ec4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ec7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105eca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ed0:	83 c4 30             	add    $0x30,%esp
  105ed3:	5b                   	pop    %ebx
  105ed4:	5e                   	pop    %esi
  105ed5:	5f                   	pop    %edi
  105ed6:	5d                   	pop    %ebp
  105ed7:	c3                   	ret    

00105ed8 <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
  105ed8:	55                   	push   %ebp
  105ed9:	89 e5                	mov    %esp,%ebp
  105edb:	57                   	push   %edi
  105edc:	56                   	push   %esi
  105edd:	83 ec 20             	sub    $0x20,%esp
  105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eec:	8b 45 10             	mov    0x10(%ebp),%eax
  105eef:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
  105ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ef5:	c1 e8 02             	shr    $0x2,%eax
  105ef8:	89 c1                	mov    %eax,%ecx
    asm volatile(
  105efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f00:	89 d7                	mov    %edx,%edi
  105f02:	89 c6                	mov    %eax,%esi
  105f04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f09:	83 e1 03             	and    $0x3,%ecx
  105f0c:	74 02                	je     105f10 <memcpy+0x38>
  105f0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f10:	89 f0                	mov    %esi,%eax
  105f12:	89 fa                	mov    %edi,%edx
  105f14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f20:	83 c4 20             	add    $0x20,%esp
  105f23:	5e                   	pop    %esi
  105f24:	5f                   	pop    %edi
  105f25:	5d                   	pop    %ebp
  105f26:	c3                   	ret    

00105f27 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
  105f27:	55                   	push   %ebp
  105f28:	89 e5                	mov    %esp,%ebp
  105f2a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f36:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
  105f39:	eb 2e                	jmp    105f69 <memcmp+0x42>
    {
        if (*s1 != *s2)
  105f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f3e:	0f b6 10             	movzbl (%eax),%edx
  105f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f44:	0f b6 00             	movzbl (%eax),%eax
  105f47:	38 c2                	cmp    %al,%dl
  105f49:	74 18                	je     105f63 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f4e:	0f b6 00             	movzbl (%eax),%eax
  105f51:	0f b6 d0             	movzbl %al,%edx
  105f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f57:	0f b6 00             	movzbl (%eax),%eax
  105f5a:	0f b6 c8             	movzbl %al,%ecx
  105f5d:	89 d0                	mov    %edx,%eax
  105f5f:	29 c8                	sub    %ecx,%eax
  105f61:	eb 18                	jmp    105f7b <memcmp+0x54>
        }
        s1++, s2++;
  105f63:	ff 45 fc             	incl   -0x4(%ebp)
  105f66:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
  105f69:	8b 45 10             	mov    0x10(%ebp),%eax
  105f6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f6f:	89 55 10             	mov    %edx,0x10(%ebp)
  105f72:	85 c0                	test   %eax,%eax
  105f74:	75 c5                	jne    105f3b <memcmp+0x14>
    }
    return 0;
  105f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f7b:	89 ec                	mov    %ebp,%esp
  105f7d:	5d                   	pop    %ebp
  105f7e:	c3                   	ret    
