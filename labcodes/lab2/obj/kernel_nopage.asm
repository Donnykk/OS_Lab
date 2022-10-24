
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
  100059:	e8 ac 5d 00 00       	call   105e0a <memset>

    cons_init(); // init the console
  10005e:	e8 07 16 00 00       	call   10166a <cons_init>

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
  100087:	e8 88 44 00 00       	call   104514 <pmm_init>

    pic_init(); // init interrupt controller
  10008c:	e8 5a 17 00 00       	call   1017eb <pic_init>
    idt_init(); // init interrupt descriptor table
  100091:	e8 e1 18 00 00       	call   101977 <idt_init>

    clock_init();  // init clock interrupt
  100096:	e8 2e 0d 00 00       	call   100dc9 <clock_init>
    intr_enable(); // enable irq interrupt
  10009b:	e8 a9 16 00 00       	call   101749 <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    // lab1_switch_test();
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
  1000c4:	e8 1b 0c 00 00       	call   100ce4 <mon_backtrace>
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
  100319:	e8 7b 13 00 00       	call   101699 <cons_putc>
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
  100359:	e8 d7 52 00 00       	call   105635 <vprintfmt>
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
  100399:	e8 fb 12 00 00       	call   101699 <cons_putc>
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
  1003fb:	e8 d8 12 00 00       	call   1016d8 <cons_getc>
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
  1005a0:	c7 45 f4 18 73 10 00 	movl   $0x107318,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a7:	c7 45 f0 1c 29 11 00 	movl   $0x11291c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005ae:	c7 45 ec 1d 29 11 00 	movl   $0x11291d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b5:	c7 45 e8 97 5e 11 00 	movl   $0x115e97,-0x18(%ebp)

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
  100708:	e8 75 55 00 00       	call   105c82 <strfind>
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
  10088e:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  100895:	e8 cb fa ff ff       	call   100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10089a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1008a1:	00 
  1008a2:	c7 04 24 6f 60 10 00 	movl   $0x10606f,(%esp)
  1008a9:	e8 b7 fa ff ff       	call   100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008ae:	c7 44 24 04 96 5f 10 	movl   $0x105f96,0x4(%esp)
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
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
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
  100942:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
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
  1009b0:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
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
  1009d7:	83 ec 58             	sub    $0x58,%esp
  1009da:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009dd:	89 e8                	mov    %ebp,%eax
  1009df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    uint32_t ebp = read_ebp();
  1009e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  1009e8:	e8 d4 ff ff ff       	call   1009c1 <read_eip>
  1009ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4];

    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
  1009f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f7:	e9 91 00 00 00       	jmp    100a8d <print_stackframe+0xb9>
    {
        cprintf("ebp: 0x%08x eip: 0x%08x ", ebp, eip);
  1009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0a:	c7 04 24 28 61 10 00 	movl   $0x106128,(%esp)
  100a11:	e8 4f f9 ff ff       	call   100365 <cprintf>

        for (int j = 0; j < 4; j++)
  100a16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a1d:	eb 1e                	jmp    100a3d <print_stackframe+0x69>
            args[j] = *((uint32_t *)ebp + j + 2);
  100a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2c:	01 d0                	add    %edx,%eax
  100a2e:	83 c0 08             	add    $0x8,%eax
  100a31:	8b 10                	mov    (%eax),%edx
  100a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a36:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
        for (int j = 0; j < 4; j++)
  100a3a:	ff 45 e8             	incl   -0x18(%ebp)
  100a3d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a41:	7e dc                	jle    100a1f <print_stackframe+0x4b>
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
  100a43:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a46:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a49:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a4f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a57:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5f:	c7 04 24 44 61 10 00 	movl   $0x106144,(%esp)
  100a66:	e8 fa f8 ff ff       	call   100365 <cprintf>
        print_debuginfo(eip - 1);
  100a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a6e:	48                   	dec    %eax
  100a6f:	89 04 24             	mov    %eax,(%esp)
  100a72:	e8 a5 fe ff ff       	call   10091c <print_debuginfo>

        eip = *((uint32_t *)ebp + 1);
  100a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7a:	83 c0 04             	add    $0x4,%eax
  100a7d:	8b 00                	mov    (%eax),%eax
  100a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *((uint32_t *)ebp);
  100a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a85:	8b 00                	mov    (%eax),%eax
  100a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
  100a8a:	ff 45 ec             	incl   -0x14(%ebp)
  100a8d:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100a91:	0f 8e 65 ff ff ff    	jle    1009fc <print_stackframe+0x28>
    }
}
  100a97:	90                   	nop
  100a98:	90                   	nop
  100a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a9c:	89 ec                	mov    %ebp,%esp
  100a9e:	5d                   	pop    %ebp
  100a9f:	c3                   	ret    

00100aa0 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aa0:	55                   	push   %ebp
  100aa1:	89 e5                	mov    %esp,%ebp
  100aa3:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100aa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aad:	eb 0c                	jmp    100abb <parse+0x1b>
            *buf ++ = '\0';
  100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab2:	8d 50 01             	lea    0x1(%eax),%edx
  100ab5:	89 55 08             	mov    %edx,0x8(%ebp)
  100ab8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	74 1d                	je     100ae2 <parse+0x42>
  100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac8:	0f b6 00             	movzbl (%eax),%eax
  100acb:	0f be c0             	movsbl %al,%eax
  100ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad2:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  100ad9:	e8 70 51 00 00       	call   105c4e <strchr>
  100ade:	85 c0                	test   %eax,%eax
  100ae0:	75 cd                	jne    100aaf <parse+0xf>
        }
        if (*buf == '\0') {
  100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae5:	0f b6 00             	movzbl (%eax),%eax
  100ae8:	84 c0                	test   %al,%al
  100aea:	74 65                	je     100b51 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aec:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100af0:	75 14                	jne    100b06 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100af2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100af9:	00 
  100afa:	c7 04 24 ed 61 10 00 	movl   $0x1061ed,(%esp)
  100b01:	e8 5f f8 ff ff       	call   100365 <cprintf>
        }
        argv[argc ++] = buf;
  100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b09:	8d 50 01             	lea    0x1(%eax),%edx
  100b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b19:	01 c2                	add    %eax,%edx
  100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b20:	eb 03                	jmp    100b25 <parse+0x85>
            buf ++;
  100b22:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	0f b6 00             	movzbl (%eax),%eax
  100b2b:	84 c0                	test   %al,%al
  100b2d:	74 8c                	je     100abb <parse+0x1b>
  100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b32:	0f b6 00             	movzbl (%eax),%eax
  100b35:	0f be c0             	movsbl %al,%eax
  100b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3c:	c7 04 24 e8 61 10 00 	movl   $0x1061e8,(%esp)
  100b43:	e8 06 51 00 00       	call   105c4e <strchr>
  100b48:	85 c0                	test   %eax,%eax
  100b4a:	74 d6                	je     100b22 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b4c:	e9 6a ff ff ff       	jmp    100abb <parse+0x1b>
            break;
  100b51:	90                   	nop
        }
    }
    return argc;
  100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b55:	89 ec                	mov    %ebp,%esp
  100b57:	5d                   	pop    %ebp
  100b58:	c3                   	ret    

00100b59 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b59:	55                   	push   %ebp
  100b5a:	89 e5                	mov    %esp,%ebp
  100b5c:	83 ec 68             	sub    $0x68,%esp
  100b5f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b62:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b69:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6c:	89 04 24             	mov    %eax,(%esp)
  100b6f:	e8 2c ff ff ff       	call   100aa0 <parse>
  100b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b7b:	75 0a                	jne    100b87 <runcmd+0x2e>
        return 0;
  100b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b82:	e9 83 00 00 00       	jmp    100c0a <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b8e:	eb 5a                	jmp    100bea <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b90:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b93:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b96:	89 c8                	mov    %ecx,%eax
  100b98:	01 c0                	add    %eax,%eax
  100b9a:	01 c8                	add    %ecx,%eax
  100b9c:	c1 e0 02             	shl    $0x2,%eax
  100b9f:	05 00 80 11 00       	add    $0x118000,%eax
  100ba4:	8b 00                	mov    (%eax),%eax
  100ba6:	89 54 24 04          	mov    %edx,0x4(%esp)
  100baa:	89 04 24             	mov    %eax,(%esp)
  100bad:	e8 00 50 00 00       	call   105bb2 <strcmp>
  100bb2:	85 c0                	test   %eax,%eax
  100bb4:	75 31                	jne    100be7 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bb9:	89 d0                	mov    %edx,%eax
  100bbb:	01 c0                	add    %eax,%eax
  100bbd:	01 d0                	add    %edx,%eax
  100bbf:	c1 e0 02             	shl    $0x2,%eax
  100bc2:	05 08 80 11 00       	add    $0x118008,%eax
  100bc7:	8b 10                	mov    (%eax),%edx
  100bc9:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bcc:	83 c0 04             	add    $0x4,%eax
  100bcf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bd2:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bd8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be0:	89 1c 24             	mov    %ebx,(%esp)
  100be3:	ff d2                	call   *%edx
  100be5:	eb 23                	jmp    100c0a <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100be7:	ff 45 f4             	incl   -0xc(%ebp)
  100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bed:	83 f8 02             	cmp    $0x2,%eax
  100bf0:	76 9e                	jbe    100b90 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bf2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf9:	c7 04 24 0b 62 10 00 	movl   $0x10620b,(%esp)
  100c00:	e8 60 f7 ff ff       	call   100365 <cprintf>
    return 0;
  100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100c0d:	89 ec                	mov    %ebp,%esp
  100c0f:	5d                   	pop    %ebp
  100c10:	c3                   	ret    

00100c11 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c11:	55                   	push   %ebp
  100c12:	89 e5                	mov    %esp,%ebp
  100c14:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c17:	c7 04 24 24 62 10 00 	movl   $0x106224,(%esp)
  100c1e:	e8 42 f7 ff ff       	call   100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c23:	c7 04 24 4c 62 10 00 	movl   $0x10624c,(%esp)
  100c2a:	e8 36 f7 ff ff       	call   100365 <cprintf>

    if (tf != NULL) {
  100c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c33:	74 0b                	je     100c40 <kmonitor+0x2f>
        print_trapframe(tf);
  100c35:	8b 45 08             	mov    0x8(%ebp),%eax
  100c38:	89 04 24             	mov    %eax,(%esp)
  100c3b:	e8 f1 0e 00 00       	call   101b31 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c40:	c7 04 24 71 62 10 00 	movl   $0x106271,(%esp)
  100c47:	e8 0a f6 ff ff       	call   100256 <readline>
  100c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c53:	74 eb                	je     100c40 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c55:	8b 45 08             	mov    0x8(%ebp),%eax
  100c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5f:	89 04 24             	mov    %eax,(%esp)
  100c62:	e8 f2 fe ff ff       	call   100b59 <runcmd>
  100c67:	85 c0                	test   %eax,%eax
  100c69:	78 02                	js     100c6d <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c6b:	eb d3                	jmp    100c40 <kmonitor+0x2f>
                break;
  100c6d:	90                   	nop
            }
        }
    }
}
  100c6e:	90                   	nop
  100c6f:	89 ec                	mov    %ebp,%esp
  100c71:	5d                   	pop    %ebp
  100c72:	c3                   	ret    

00100c73 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c73:	55                   	push   %ebp
  100c74:	89 e5                	mov    %esp,%ebp
  100c76:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c80:	eb 3d                	jmp    100cbf <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c85:	89 d0                	mov    %edx,%eax
  100c87:	01 c0                	add    %eax,%eax
  100c89:	01 d0                	add    %edx,%eax
  100c8b:	c1 e0 02             	shl    $0x2,%eax
  100c8e:	05 04 80 11 00       	add    $0x118004,%eax
  100c93:	8b 10                	mov    (%eax),%edx
  100c95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c98:	89 c8                	mov    %ecx,%eax
  100c9a:	01 c0                	add    %eax,%eax
  100c9c:	01 c8                	add    %ecx,%eax
  100c9e:	c1 e0 02             	shl    $0x2,%eax
  100ca1:	05 00 80 11 00       	add    $0x118000,%eax
  100ca6:	8b 00                	mov    (%eax),%eax
  100ca8:	89 54 24 08          	mov    %edx,0x8(%esp)
  100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb0:	c7 04 24 75 62 10 00 	movl   $0x106275,(%esp)
  100cb7:	e8 a9 f6 ff ff       	call   100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cbc:	ff 45 f4             	incl   -0xc(%ebp)
  100cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc2:	83 f8 02             	cmp    $0x2,%eax
  100cc5:	76 bb                	jbe    100c82 <mon_help+0xf>
    }
    return 0;
  100cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccc:	89 ec                	mov    %ebp,%esp
  100cce:	5d                   	pop    %ebp
  100ccf:	c3                   	ret    

00100cd0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cd0:	55                   	push   %ebp
  100cd1:	89 e5                	mov    %esp,%ebp
  100cd3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cd6:	e8 ad fb ff ff       	call   100888 <print_kerninfo>
    return 0;
  100cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ce0:	89 ec                	mov    %ebp,%esp
  100ce2:	5d                   	pop    %ebp
  100ce3:	c3                   	ret    

00100ce4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ce4:	55                   	push   %ebp
  100ce5:	89 e5                	mov    %esp,%ebp
  100ce7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cea:	e8 e5 fc ff ff       	call   1009d4 <print_stackframe>
    return 0;
  100cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cf4:	89 ec                	mov    %ebp,%esp
  100cf6:	5d                   	pop    %ebp
  100cf7:	c3                   	ret    

00100cf8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cf8:	55                   	push   %ebp
  100cf9:	89 e5                	mov    %esp,%ebp
  100cfb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cfe:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100d03:	85 c0                	test   %eax,%eax
  100d05:	75 5b                	jne    100d62 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100d07:	c7 05 20 b4 11 00 01 	movl   $0x1,0x11b420
  100d0e:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d11:	8d 45 14             	lea    0x14(%ebp),%eax
  100d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d25:	c7 04 24 7e 62 10 00 	movl   $0x10627e,(%esp)
  100d2c:	e8 34 f6 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d38:	8b 45 10             	mov    0x10(%ebp),%eax
  100d3b:	89 04 24             	mov    %eax,(%esp)
  100d3e:	e8 ed f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100d43:	c7 04 24 9a 62 10 00 	movl   $0x10629a,(%esp)
  100d4a:	e8 16 f6 ff ff       	call   100365 <cprintf>
    
    cprintf("stack trackback:\n");
  100d4f:	c7 04 24 9c 62 10 00 	movl   $0x10629c,(%esp)
  100d56:	e8 0a f6 ff ff       	call   100365 <cprintf>
    print_stackframe();
  100d5b:	e8 74 fc ff ff       	call   1009d4 <print_stackframe>
  100d60:	eb 01                	jmp    100d63 <__panic+0x6b>
        goto panic_dead;
  100d62:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d63:	e8 e9 09 00 00       	call   101751 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d6f:	e8 9d fe ff ff       	call   100c11 <kmonitor>
  100d74:	eb f2                	jmp    100d68 <__panic+0x70>

00100d76 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d7c:	8d 45 14             	lea    0x14(%ebp),%eax
  100d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d85:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d89:	8b 45 08             	mov    0x8(%ebp),%eax
  100d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d90:	c7 04 24 ae 62 10 00 	movl   $0x1062ae,(%esp)
  100d97:	e8 c9 f5 ff ff       	call   100365 <cprintf>
    vcprintf(fmt, ap);
  100d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100da3:	8b 45 10             	mov    0x10(%ebp),%eax
  100da6:	89 04 24             	mov    %eax,(%esp)
  100da9:	e8 82 f5 ff ff       	call   100330 <vcprintf>
    cprintf("\n");
  100dae:	c7 04 24 9a 62 10 00 	movl   $0x10629a,(%esp)
  100db5:	e8 ab f5 ff ff       	call   100365 <cprintf>
    va_end(ap);
}
  100dba:	90                   	nop
  100dbb:	89 ec                	mov    %ebp,%esp
  100dbd:	5d                   	pop    %ebp
  100dbe:	c3                   	ret    

00100dbf <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100dbf:	55                   	push   %ebp
  100dc0:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100dc2:	a1 20 b4 11 00       	mov    0x11b420,%eax
}
  100dc7:	5d                   	pop    %ebp
  100dc8:	c3                   	ret    

00100dc9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dc9:	55                   	push   %ebp
  100dca:	89 e5                	mov    %esp,%ebp
  100dcc:	83 ec 28             	sub    $0x28,%esp
  100dcf:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dd5:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ddd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de1:	ee                   	out    %al,(%dx)
}
  100de2:	90                   	nop
  100de3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100de9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ded:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100df1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100df5:	ee                   	out    %al,(%dx)
}
  100df6:	90                   	nop
  100df7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dfd:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e01:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e05:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e09:	ee                   	out    %al,(%dx)
}
  100e0a:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e0b:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  100e12:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e15:	c7 04 24 cc 62 10 00 	movl   $0x1062cc,(%esp)
  100e1c:	e8 44 f5 ff ff       	call   100365 <cprintf>
    pic_enable(IRQ_TIMER);
  100e21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e28:	e8 89 09 00 00       	call   1017b6 <pic_enable>
}
  100e2d:	90                   	nop
  100e2e:	89 ec                	mov    %ebp,%esp
  100e30:	5d                   	pop    %ebp
  100e31:	c3                   	ret    

00100e32 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e32:	55                   	push   %ebp
  100e33:	89 e5                	mov    %esp,%ebp
  100e35:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e38:	9c                   	pushf  
  100e39:	58                   	pop    %eax
  100e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e40:	25 00 02 00 00       	and    $0x200,%eax
  100e45:	85 c0                	test   %eax,%eax
  100e47:	74 0c                	je     100e55 <__intr_save+0x23>
        intr_disable();
  100e49:	e8 03 09 00 00       	call   101751 <intr_disable>
        return 1;
  100e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  100e53:	eb 05                	jmp    100e5a <__intr_save+0x28>
    }
    return 0;
  100e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e5a:	89 ec                	mov    %ebp,%esp
  100e5c:	5d                   	pop    %ebp
  100e5d:	c3                   	ret    

00100e5e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e5e:	55                   	push   %ebp
  100e5f:	89 e5                	mov    %esp,%ebp
  100e61:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e68:	74 05                	je     100e6f <__intr_restore+0x11>
        intr_enable();
  100e6a:	e8 da 08 00 00       	call   101749 <intr_enable>
    }
}
  100e6f:	90                   	nop
  100e70:	89 ec                	mov    %ebp,%esp
  100e72:	5d                   	pop    %ebp
  100e73:	c3                   	ret    

00100e74 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e74:	55                   	push   %ebp
  100e75:	89 e5                	mov    %esp,%ebp
  100e77:	83 ec 10             	sub    $0x10,%esp
  100e7a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e80:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e84:	89 c2                	mov    %eax,%edx
  100e86:	ec                   	in     (%dx),%al
  100e87:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e8a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e90:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e94:	89 c2                	mov    %eax,%edx
  100e96:	ec                   	in     (%dx),%al
  100e97:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e9a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ea0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ea4:	89 c2                	mov    %eax,%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	88 45 f9             	mov    %al,-0x7(%ebp)
  100eaa:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100eb0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100eb4:	89 c2                	mov    %eax,%edx
  100eb6:	ec                   	in     (%dx),%al
  100eb7:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eba:	90                   	nop
  100ebb:	89 ec                	mov    %ebp,%esp
  100ebd:	5d                   	pop    %ebp
  100ebe:	c3                   	ret    

00100ebf <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ebf:	55                   	push   %ebp
  100ec0:	89 e5                	mov    %esp,%ebp
  100ec2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ec5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecf:	0f b7 00             	movzwl (%eax),%eax
  100ed2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee1:	0f b7 00             	movzwl (%eax),%eax
  100ee4:	0f b7 c0             	movzwl %ax,%eax
  100ee7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eec:	74 12                	je     100f00 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eee:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ef5:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
  100efc:	b4 03 
  100efe:	eb 13                	jmp    100f13 <cga_init+0x54>
    } else {
        *cp = was;
  100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f03:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f07:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f0a:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100f11:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f13:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f1a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f1e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f22:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f26:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f2a:	ee                   	out    %al,(%dx)
}
  100f2b:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f2c:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f33:	40                   	inc    %eax
  100f34:	0f b7 c0             	movzwl %ax,%eax
  100f37:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f3f:	89 c2                	mov    %eax,%edx
  100f41:	ec                   	in     (%dx),%al
  100f42:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f45:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f49:	0f b6 c0             	movzbl %al,%eax
  100f4c:	c1 e0 08             	shl    $0x8,%eax
  100f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f52:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f59:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f5d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f61:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f65:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f69:	ee                   	out    %al,(%dx)
}
  100f6a:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f6b:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f72:	40                   	inc    %eax
  100f73:	0f b7 c0             	movzwl %ax,%eax
  100f76:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f7a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f7e:	89 c2                	mov    %eax,%edx
  100f80:	ec                   	in     (%dx),%al
  100f81:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f88:	0f b6 c0             	movzbl %al,%eax
  100f8b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f91:	a3 40 b4 11 00       	mov    %eax,0x11b440
    crt_pos = pos;
  100f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f99:	0f b7 c0             	movzwl %ax,%eax
  100f9c:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
}
  100fa2:	90                   	nop
  100fa3:	89 ec                	mov    %ebp,%esp
  100fa5:	5d                   	pop    %ebp
  100fa6:	c3                   	ret    

00100fa7 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fa7:	55                   	push   %ebp
  100fa8:	89 e5                	mov    %esp,%ebp
  100faa:	83 ec 48             	sub    $0x48,%esp
  100fad:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fb3:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fb7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fbb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
}
  100fc0:	90                   	nop
  100fc1:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fc7:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fcb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fcf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fd3:	ee                   	out    %al,(%dx)
}
  100fd4:	90                   	nop
  100fd5:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fdb:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fdf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fe3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fe7:	ee                   	out    %al,(%dx)
}
  100fe8:	90                   	nop
  100fe9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fef:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ffb:	ee                   	out    %al,(%dx)
}
  100ffc:	90                   	nop
  100ffd:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101003:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101007:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10100b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10100f:	ee                   	out    %al,(%dx)
}
  101010:	90                   	nop
  101011:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101017:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10101b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10101f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
}
  101024:	90                   	nop
  101025:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10102b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10102f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101033:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101037:	ee                   	out    %al,(%dx)
}
  101038:	90                   	nop
  101039:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10103f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101043:	89 c2                	mov    %eax,%edx
  101045:	ec                   	in     (%dx),%al
  101046:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101049:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10104d:	3c ff                	cmp    $0xff,%al
  10104f:	0f 95 c0             	setne  %al
  101052:	0f b6 c0             	movzbl %al,%eax
  101055:	a3 48 b4 11 00       	mov    %eax,0x11b448
  10105a:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101060:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101064:	89 c2                	mov    %eax,%edx
  101066:	ec                   	in     (%dx),%al
  101067:	88 45 f1             	mov    %al,-0xf(%ebp)
  10106a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101070:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101074:	89 c2                	mov    %eax,%edx
  101076:	ec                   	in     (%dx),%al
  101077:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10107a:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10107f:	85 c0                	test   %eax,%eax
  101081:	74 0c                	je     10108f <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  101083:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10108a:	e8 27 07 00 00       	call   1017b6 <pic_enable>
    }
}
  10108f:	90                   	nop
  101090:	89 ec                	mov    %ebp,%esp
  101092:	5d                   	pop    %ebp
  101093:	c3                   	ret    

00101094 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101094:	55                   	push   %ebp
  101095:	89 e5                	mov    %esp,%ebp
  101097:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010a1:	eb 08                	jmp    1010ab <lpt_putc_sub+0x17>
        delay();
  1010a3:	e8 cc fd ff ff       	call   100e74 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010a8:	ff 45 fc             	incl   -0x4(%ebp)
  1010ab:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010b5:	89 c2                	mov    %eax,%edx
  1010b7:	ec                   	in     (%dx),%al
  1010b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010bf:	84 c0                	test   %al,%al
  1010c1:	78 09                	js     1010cc <lpt_putc_sub+0x38>
  1010c3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010ca:	7e d7                	jle    1010a3 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cf:	0f b6 c0             	movzbl %al,%eax
  1010d2:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010d8:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010db:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010df:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010e3:	ee                   	out    %al,(%dx)
}
  1010e4:	90                   	nop
  1010e5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010eb:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010ef:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010f3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010f7:	ee                   	out    %al,(%dx)
}
  1010f8:	90                   	nop
  1010f9:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010ff:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101103:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101107:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10110b:	ee                   	out    %al,(%dx)
}
  10110c:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10110d:	90                   	nop
  10110e:	89 ec                	mov    %ebp,%esp
  101110:	5d                   	pop    %ebp
  101111:	c3                   	ret    

00101112 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101112:	55                   	push   %ebp
  101113:	89 e5                	mov    %esp,%ebp
  101115:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101118:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10111c:	74 0d                	je     10112b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10111e:	8b 45 08             	mov    0x8(%ebp),%eax
  101121:	89 04 24             	mov    %eax,(%esp)
  101124:	e8 6b ff ff ff       	call   101094 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101129:	eb 24                	jmp    10114f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10112b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101132:	e8 5d ff ff ff       	call   101094 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101137:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10113e:	e8 51 ff ff ff       	call   101094 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101143:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10114a:	e8 45 ff ff ff       	call   101094 <lpt_putc_sub>
}
  10114f:	90                   	nop
  101150:	89 ec                	mov    %ebp,%esp
  101152:	5d                   	pop    %ebp
  101153:	c3                   	ret    

00101154 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101154:	55                   	push   %ebp
  101155:	89 e5                	mov    %esp,%ebp
  101157:	83 ec 38             	sub    $0x38,%esp
  10115a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  10115d:	8b 45 08             	mov    0x8(%ebp),%eax
  101160:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101165:	85 c0                	test   %eax,%eax
  101167:	75 07                	jne    101170 <cga_putc+0x1c>
        c |= 0x0700;
  101169:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101170:	8b 45 08             	mov    0x8(%ebp),%eax
  101173:	0f b6 c0             	movzbl %al,%eax
  101176:	83 f8 0d             	cmp    $0xd,%eax
  101179:	74 72                	je     1011ed <cga_putc+0x99>
  10117b:	83 f8 0d             	cmp    $0xd,%eax
  10117e:	0f 8f a3 00 00 00    	jg     101227 <cga_putc+0xd3>
  101184:	83 f8 08             	cmp    $0x8,%eax
  101187:	74 0a                	je     101193 <cga_putc+0x3f>
  101189:	83 f8 0a             	cmp    $0xa,%eax
  10118c:	74 4c                	je     1011da <cga_putc+0x86>
  10118e:	e9 94 00 00 00       	jmp    101227 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101193:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10119a:	85 c0                	test   %eax,%eax
  10119c:	0f 84 af 00 00 00    	je     101251 <cga_putc+0xfd>
            crt_pos --;
  1011a2:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011a9:	48                   	dec    %eax
  1011aa:	0f b7 c0             	movzwl %ax,%eax
  1011ad:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b6:	98                   	cwtl   
  1011b7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011bc:	98                   	cwtl   
  1011bd:	83 c8 20             	or     $0x20,%eax
  1011c0:	98                   	cwtl   
  1011c1:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  1011c7:	0f b7 15 44 b4 11 00 	movzwl 0x11b444,%edx
  1011ce:	01 d2                	add    %edx,%edx
  1011d0:	01 ca                	add    %ecx,%edx
  1011d2:	0f b7 c0             	movzwl %ax,%eax
  1011d5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011d8:	eb 77                	jmp    101251 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011da:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011e1:	83 c0 50             	add    $0x50,%eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011ed:	0f b7 1d 44 b4 11 00 	movzwl 0x11b444,%ebx
  1011f4:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
  1011fb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101200:	89 c8                	mov    %ecx,%eax
  101202:	f7 e2                	mul    %edx
  101204:	c1 ea 06             	shr    $0x6,%edx
  101207:	89 d0                	mov    %edx,%eax
  101209:	c1 e0 02             	shl    $0x2,%eax
  10120c:	01 d0                	add    %edx,%eax
  10120e:	c1 e0 04             	shl    $0x4,%eax
  101211:	29 c1                	sub    %eax,%ecx
  101213:	89 ca                	mov    %ecx,%edx
  101215:	0f b7 d2             	movzwl %dx,%edx
  101218:	89 d8                	mov    %ebx,%eax
  10121a:	29 d0                	sub    %edx,%eax
  10121c:	0f b7 c0             	movzwl %ax,%eax
  10121f:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
        break;
  101225:	eb 2b                	jmp    101252 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101227:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  10122d:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101234:	8d 50 01             	lea    0x1(%eax),%edx
  101237:	0f b7 d2             	movzwl %dx,%edx
  10123a:	66 89 15 44 b4 11 00 	mov    %dx,0x11b444
  101241:	01 c0                	add    %eax,%eax
  101243:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101246:	8b 45 08             	mov    0x8(%ebp),%eax
  101249:	0f b7 c0             	movzwl %ax,%eax
  10124c:	66 89 02             	mov    %ax,(%edx)
        break;
  10124f:	eb 01                	jmp    101252 <cga_putc+0xfe>
        break;
  101251:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101252:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101259:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10125e:	76 5e                	jbe    1012be <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101260:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101265:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10126b:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101270:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101277:	00 
  101278:	89 54 24 04          	mov    %edx,0x4(%esp)
  10127c:	89 04 24             	mov    %eax,(%esp)
  10127f:	e8 c8 4b 00 00       	call   105e4c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101284:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10128b:	eb 15                	jmp    1012a2 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  10128d:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
  101293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101296:	01 c0                	add    %eax,%eax
  101298:	01 d0                	add    %edx,%eax
  10129a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10129f:	ff 45 f4             	incl   -0xc(%ebp)
  1012a2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012a9:	7e e2                	jle    10128d <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  1012ab:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012b2:	83 e8 50             	sub    $0x50,%eax
  1012b5:	0f b7 c0             	movzwl %ax,%eax
  1012b8:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012be:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012c5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012c9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012d5:	ee                   	out    %al,(%dx)
}
  1012d6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012d7:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012de:	c1 e8 08             	shr    $0x8,%eax
  1012e1:	0f b7 c0             	movzwl %ax,%eax
  1012e4:	0f b6 c0             	movzbl %al,%eax
  1012e7:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  1012ee:	42                   	inc    %edx
  1012ef:	0f b7 d2             	movzwl %dx,%edx
  1012f2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012f6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012fd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101301:	ee                   	out    %al,(%dx)
}
  101302:	90                   	nop
    outb(addr_6845, 15);
  101303:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  10130a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10130e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101312:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101316:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10131a:	ee                   	out    %al,(%dx)
}
  10131b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10131c:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101323:	0f b6 c0             	movzbl %al,%eax
  101326:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  10132d:	42                   	inc    %edx
  10132e:	0f b7 d2             	movzwl %dx,%edx
  101331:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101335:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101338:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10133c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101340:	ee                   	out    %al,(%dx)
}
  101341:	90                   	nop
}
  101342:	90                   	nop
  101343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101346:	89 ec                	mov    %ebp,%esp
  101348:	5d                   	pop    %ebp
  101349:	c3                   	ret    

0010134a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10134a:	55                   	push   %ebp
  10134b:	89 e5                	mov    %esp,%ebp
  10134d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101357:	eb 08                	jmp    101361 <serial_putc_sub+0x17>
        delay();
  101359:	e8 16 fb ff ff       	call   100e74 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10135e:	ff 45 fc             	incl   -0x4(%ebp)
  101361:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101367:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136b:	89 c2                	mov    %eax,%edx
  10136d:	ec                   	in     (%dx),%al
  10136e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101371:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101375:	0f b6 c0             	movzbl %al,%eax
  101378:	83 e0 20             	and    $0x20,%eax
  10137b:	85 c0                	test   %eax,%eax
  10137d:	75 09                	jne    101388 <serial_putc_sub+0x3e>
  10137f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101386:	7e d1                	jle    101359 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101388:	8b 45 08             	mov    0x8(%ebp),%eax
  10138b:	0f b6 c0             	movzbl %al,%eax
  10138e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101394:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101397:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10139b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10139f:	ee                   	out    %al,(%dx)
}
  1013a0:	90                   	nop
}
  1013a1:	90                   	nop
  1013a2:	89 ec                	mov    %ebp,%esp
  1013a4:	5d                   	pop    %ebp
  1013a5:	c3                   	ret    

001013a6 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013a6:	55                   	push   %ebp
  1013a7:	89 e5                	mov    %esp,%ebp
  1013a9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013b0:	74 0d                	je     1013bf <serial_putc+0x19>
        serial_putc_sub(c);
  1013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b5:	89 04 24             	mov    %eax,(%esp)
  1013b8:	e8 8d ff ff ff       	call   10134a <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013bd:	eb 24                	jmp    1013e3 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013bf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013c6:	e8 7f ff ff ff       	call   10134a <serial_putc_sub>
        serial_putc_sub(' ');
  1013cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013d2:	e8 73 ff ff ff       	call   10134a <serial_putc_sub>
        serial_putc_sub('\b');
  1013d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013de:	e8 67 ff ff ff       	call   10134a <serial_putc_sub>
}
  1013e3:	90                   	nop
  1013e4:	89 ec                	mov    %ebp,%esp
  1013e6:	5d                   	pop    %ebp
  1013e7:	c3                   	ret    

001013e8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013e8:	55                   	push   %ebp
  1013e9:	89 e5                	mov    %esp,%ebp
  1013eb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013ee:	eb 33                	jmp    101423 <cons_intr+0x3b>
        if (c != 0) {
  1013f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013f4:	74 2d                	je     101423 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013f6:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013fb:	8d 50 01             	lea    0x1(%eax),%edx
  1013fe:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  101404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101407:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10140d:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101412:	3d 00 02 00 00       	cmp    $0x200,%eax
  101417:	75 0a                	jne    101423 <cons_intr+0x3b>
                cons.wpos = 0;
  101419:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
  101420:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101423:	8b 45 08             	mov    0x8(%ebp),%eax
  101426:	ff d0                	call   *%eax
  101428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10142b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10142f:	75 bf                	jne    1013f0 <cons_intr+0x8>
            }
        }
    }
}
  101431:	90                   	nop
  101432:	90                   	nop
  101433:	89 ec                	mov    %ebp,%esp
  101435:	5d                   	pop    %ebp
  101436:	c3                   	ret    

00101437 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101437:	55                   	push   %ebp
  101438:	89 e5                	mov    %esp,%ebp
  10143a:	83 ec 10             	sub    $0x10,%esp
  10143d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101443:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101447:	89 c2                	mov    %eax,%edx
  101449:	ec                   	in     (%dx),%al
  10144a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10144d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101451:	0f b6 c0             	movzbl %al,%eax
  101454:	83 e0 01             	and    $0x1,%eax
  101457:	85 c0                	test   %eax,%eax
  101459:	75 07                	jne    101462 <serial_proc_data+0x2b>
        return -1;
  10145b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101460:	eb 2a                	jmp    10148c <serial_proc_data+0x55>
  101462:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101468:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10146c:	89 c2                	mov    %eax,%edx
  10146e:	ec                   	in     (%dx),%al
  10146f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101472:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101476:	0f b6 c0             	movzbl %al,%eax
  101479:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10147c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101480:	75 07                	jne    101489 <serial_proc_data+0x52>
        c = '\b';
  101482:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101489:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10148c:	89 ec                	mov    %ebp,%esp
  10148e:	5d                   	pop    %ebp
  10148f:	c3                   	ret    

00101490 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101490:	55                   	push   %ebp
  101491:	89 e5                	mov    %esp,%ebp
  101493:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101496:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10149b:	85 c0                	test   %eax,%eax
  10149d:	74 0c                	je     1014ab <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10149f:	c7 04 24 37 14 10 00 	movl   $0x101437,(%esp)
  1014a6:	e8 3d ff ff ff       	call   1013e8 <cons_intr>
    }
}
  1014ab:	90                   	nop
  1014ac:	89 ec                	mov    %ebp,%esp
  1014ae:	5d                   	pop    %ebp
  1014af:	c3                   	ret    

001014b0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014b0:	55                   	push   %ebp
  1014b1:	89 e5                	mov    %esp,%ebp
  1014b3:	83 ec 38             	sub    $0x38,%esp
  1014b6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014bf:	89 c2                	mov    %eax,%edx
  1014c1:	ec                   	in     (%dx),%al
  1014c2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014c9:	0f b6 c0             	movzbl %al,%eax
  1014cc:	83 e0 01             	and    $0x1,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	75 0a                	jne    1014dd <kbd_proc_data+0x2d>
        return -1;
  1014d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014d8:	e9 56 01 00 00       	jmp    101633 <kbd_proc_data+0x183>
  1014dd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014e6:	89 c2                	mov    %eax,%edx
  1014e8:	ec                   	in     (%dx),%al
  1014e9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014ec:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014f0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014f3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014f7:	75 17                	jne    101510 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014f9:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014fe:	83 c8 40             	or     $0x40,%eax
  101501:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  101506:	b8 00 00 00 00       	mov    $0x0,%eax
  10150b:	e9 23 01 00 00       	jmp    101633 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	84 c0                	test   %al,%al
  101516:	79 45                	jns    10155d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101518:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10151d:	83 e0 40             	and    $0x40,%eax
  101520:	85 c0                	test   %eax,%eax
  101522:	75 08                	jne    10152c <kbd_proc_data+0x7c>
  101524:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101528:	24 7f                	and    $0x7f,%al
  10152a:	eb 04                	jmp    101530 <kbd_proc_data+0x80>
  10152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101530:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101533:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101537:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  10153e:	0c 40                	or     $0x40,%al
  101540:	0f b6 c0             	movzbl %al,%eax
  101543:	f7 d0                	not    %eax
  101545:	89 c2                	mov    %eax,%edx
  101547:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10154c:	21 d0                	and    %edx,%eax
  10154e:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  101553:	b8 00 00 00 00       	mov    $0x0,%eax
  101558:	e9 d6 00 00 00       	jmp    101633 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  10155d:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101562:	83 e0 40             	and    $0x40,%eax
  101565:	85 c0                	test   %eax,%eax
  101567:	74 11                	je     10157a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101569:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10156d:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101572:	83 e0 bf             	and    $0xffffffbf,%eax
  101575:	a3 68 b6 11 00       	mov    %eax,0x11b668
    }

    shift |= shiftcode[data];
  10157a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157e:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101585:	0f b6 d0             	movzbl %al,%edx
  101588:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10158d:	09 d0                	or     %edx,%eax
  10158f:	a3 68 b6 11 00       	mov    %eax,0x11b668
    shift ^= togglecode[data];
  101594:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101598:	0f b6 80 40 81 11 00 	movzbl 0x118140(%eax),%eax
  10159f:	0f b6 d0             	movzbl %al,%edx
  1015a2:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015a7:	31 d0                	xor    %edx,%eax
  1015a9:	a3 68 b6 11 00       	mov    %eax,0x11b668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015ae:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015b3:	83 e0 03             	and    $0x3,%eax
  1015b6:	8b 14 85 40 85 11 00 	mov    0x118540(,%eax,4),%edx
  1015bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c1:	01 d0                	add    %edx,%eax
  1015c3:	0f b6 00             	movzbl (%eax),%eax
  1015c6:	0f b6 c0             	movzbl %al,%eax
  1015c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015cc:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015d1:	83 e0 08             	and    $0x8,%eax
  1015d4:	85 c0                	test   %eax,%eax
  1015d6:	74 22                	je     1015fa <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015d8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015dc:	7e 0c                	jle    1015ea <kbd_proc_data+0x13a>
  1015de:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015e2:	7f 06                	jg     1015ea <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015e4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015e8:	eb 10                	jmp    1015fa <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015ea:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015ee:	7e 0a                	jle    1015fa <kbd_proc_data+0x14a>
  1015f0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015f4:	7f 04                	jg     1015fa <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015f6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015fa:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015ff:	f7 d0                	not    %eax
  101601:	83 e0 06             	and    $0x6,%eax
  101604:	85 c0                	test   %eax,%eax
  101606:	75 28                	jne    101630 <kbd_proc_data+0x180>
  101608:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10160f:	75 1f                	jne    101630 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101611:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  101618:	e8 48 ed ff ff       	call   100365 <cprintf>
  10161d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101623:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101627:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10162b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10162e:	ee                   	out    %al,(%dx)
}
  10162f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101633:	89 ec                	mov    %ebp,%esp
  101635:	5d                   	pop    %ebp
  101636:	c3                   	ret    

00101637 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10163d:	c7 04 24 b0 14 10 00 	movl   $0x1014b0,(%esp)
  101644:	e8 9f fd ff ff       	call   1013e8 <cons_intr>
}
  101649:	90                   	nop
  10164a:	89 ec                	mov    %ebp,%esp
  10164c:	5d                   	pop    %ebp
  10164d:	c3                   	ret    

0010164e <kbd_init>:

static void
kbd_init(void) {
  10164e:	55                   	push   %ebp
  10164f:	89 e5                	mov    %esp,%ebp
  101651:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101654:	e8 de ff ff ff       	call   101637 <kbd_intr>
    pic_enable(IRQ_KBD);
  101659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101660:	e8 51 01 00 00       	call   1017b6 <pic_enable>
}
  101665:	90                   	nop
  101666:	89 ec                	mov    %ebp,%esp
  101668:	5d                   	pop    %ebp
  101669:	c3                   	ret    

0010166a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10166a:	55                   	push   %ebp
  10166b:	89 e5                	mov    %esp,%ebp
  10166d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101670:	e8 4a f8 ff ff       	call   100ebf <cga_init>
    serial_init();
  101675:	e8 2d f9 ff ff       	call   100fa7 <serial_init>
    kbd_init();
  10167a:	e8 cf ff ff ff       	call   10164e <kbd_init>
    if (!serial_exists) {
  10167f:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101684:	85 c0                	test   %eax,%eax
  101686:	75 0c                	jne    101694 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101688:	c7 04 24 f3 62 10 00 	movl   $0x1062f3,(%esp)
  10168f:	e8 d1 ec ff ff       	call   100365 <cprintf>
    }
}
  101694:	90                   	nop
  101695:	89 ec                	mov    %ebp,%esp
  101697:	5d                   	pop    %ebp
  101698:	c3                   	ret    

00101699 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101699:	55                   	push   %ebp
  10169a:	89 e5                	mov    %esp,%ebp
  10169c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10169f:	e8 8e f7 ff ff       	call   100e32 <__intr_save>
  1016a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016aa:	89 04 24             	mov    %eax,(%esp)
  1016ad:	e8 60 fa ff ff       	call   101112 <lpt_putc>
        cga_putc(c);
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	89 04 24             	mov    %eax,(%esp)
  1016b8:	e8 97 fa ff ff       	call   101154 <cga_putc>
        serial_putc(c);
  1016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c0:	89 04 24             	mov    %eax,(%esp)
  1016c3:	e8 de fc ff ff       	call   1013a6 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016cb:	89 04 24             	mov    %eax,(%esp)
  1016ce:	e8 8b f7 ff ff       	call   100e5e <__intr_restore>
}
  1016d3:	90                   	nop
  1016d4:	89 ec                	mov    %ebp,%esp
  1016d6:	5d                   	pop    %ebp
  1016d7:	c3                   	ret    

001016d8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016d8:	55                   	push   %ebp
  1016d9:	89 e5                	mov    %esp,%ebp
  1016db:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016e5:	e8 48 f7 ff ff       	call   100e32 <__intr_save>
  1016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016ed:	e8 9e fd ff ff       	call   101490 <serial_intr>
        kbd_intr();
  1016f2:	e8 40 ff ff ff       	call   101637 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016f7:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  1016fd:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101702:	39 c2                	cmp    %eax,%edx
  101704:	74 31                	je     101737 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101706:	a1 60 b6 11 00       	mov    0x11b660,%eax
  10170b:	8d 50 01             	lea    0x1(%eax),%edx
  10170e:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  101714:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  10171b:	0f b6 c0             	movzbl %al,%eax
  10171e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101721:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101726:	3d 00 02 00 00       	cmp    $0x200,%eax
  10172b:	75 0a                	jne    101737 <cons_getc+0x5f>
                cons.rpos = 0;
  10172d:	c7 05 60 b6 11 00 00 	movl   $0x0,0x11b660
  101734:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10173a:	89 04 24             	mov    %eax,(%esp)
  10173d:	e8 1c f7 ff ff       	call   100e5e <__intr_restore>
    return c;
  101742:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101745:	89 ec                	mov    %ebp,%esp
  101747:	5d                   	pop    %ebp
  101748:	c3                   	ret    

00101749 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101749:	55                   	push   %ebp
  10174a:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10174c:	fb                   	sti    
}
  10174d:	90                   	nop
    sti();
}
  10174e:	90                   	nop
  10174f:	5d                   	pop    %ebp
  101750:	c3                   	ret    

00101751 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101751:	55                   	push   %ebp
  101752:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101754:	fa                   	cli    
}
  101755:	90                   	nop
    cli();
}
  101756:	90                   	nop
  101757:	5d                   	pop    %ebp
  101758:	c3                   	ret    

00101759 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101759:	55                   	push   %ebp
  10175a:	89 e5                	mov    %esp,%ebp
  10175c:	83 ec 14             	sub    $0x14,%esp
  10175f:	8b 45 08             	mov    0x8(%ebp),%eax
  101762:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101769:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init) {
  10176f:	a1 6c b6 11 00       	mov    0x11b66c,%eax
  101774:	85 c0                	test   %eax,%eax
  101776:	74 39                	je     1017b1 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  101778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10177b:	0f b6 c0             	movzbl %al,%eax
  10177e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101784:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101787:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10178b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
}
  101790:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101791:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101795:	c1 e8 08             	shr    $0x8,%eax
  101798:	0f b7 c0             	movzwl %ax,%eax
  10179b:	0f b6 c0             	movzbl %al,%eax
  10179e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017a4:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017a7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ab:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017af:	ee                   	out    %al,(%dx)
}
  1017b0:	90                   	nop
    }
}
  1017b1:	90                   	nop
  1017b2:	89 ec                	mov    %ebp,%esp
  1017b4:	5d                   	pop    %ebp
  1017b5:	c3                   	ret    

001017b6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017b6:	55                   	push   %ebp
  1017b7:	89 e5                	mov    %esp,%ebp
  1017b9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1017bf:	ba 01 00 00 00       	mov    $0x1,%edx
  1017c4:	88 c1                	mov    %al,%cl
  1017c6:	d3 e2                	shl    %cl,%edx
  1017c8:	89 d0                	mov    %edx,%eax
  1017ca:	98                   	cwtl   
  1017cb:	f7 d0                	not    %eax
  1017cd:	0f bf d0             	movswl %ax,%edx
  1017d0:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  1017d7:	98                   	cwtl   
  1017d8:	21 d0                	and    %edx,%eax
  1017da:	98                   	cwtl   
  1017db:	0f b7 c0             	movzwl %ax,%eax
  1017de:	89 04 24             	mov    %eax,(%esp)
  1017e1:	e8 73 ff ff ff       	call   101759 <pic_setmask>
}
  1017e6:	90                   	nop
  1017e7:	89 ec                	mov    %ebp,%esp
  1017e9:	5d                   	pop    %ebp
  1017ea:	c3                   	ret    

001017eb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017eb:	55                   	push   %ebp
  1017ec:	89 e5                	mov    %esp,%ebp
  1017ee:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017f1:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
  1017f8:	00 00 00 
  1017fb:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101801:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101805:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101809:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10180d:	ee                   	out    %al,(%dx)
}
  10180e:	90                   	nop
  10180f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101815:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101819:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10181d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101821:	ee                   	out    %al,(%dx)
}
  101822:	90                   	nop
  101823:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101829:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10182d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101831:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101835:	ee                   	out    %al,(%dx)
}
  101836:	90                   	nop
  101837:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10183d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101841:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101845:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101849:	ee                   	out    %al,(%dx)
}
  10184a:	90                   	nop
  10184b:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101851:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101855:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101859:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10185d:	ee                   	out    %al,(%dx)
}
  10185e:	90                   	nop
  10185f:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101865:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101869:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10186d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101871:	ee                   	out    %al,(%dx)
}
  101872:	90                   	nop
  101873:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101879:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10187d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101881:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101885:	ee                   	out    %al,(%dx)
}
  101886:	90                   	nop
  101887:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10188d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101891:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101895:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101899:	ee                   	out    %al,(%dx)
}
  10189a:	90                   	nop
  10189b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018a1:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018a5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018a9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018ad:	ee                   	out    %al,(%dx)
}
  1018ae:	90                   	nop
  1018af:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018b5:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018bd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018c1:	ee                   	out    %al,(%dx)
}
  1018c2:	90                   	nop
  1018c3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018c9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018cd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018d1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018d5:	ee                   	out    %al,(%dx)
}
  1018d6:	90                   	nop
  1018d7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018dd:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018e5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018e9:	ee                   	out    %al,(%dx)
}
  1018ea:	90                   	nop
  1018eb:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018f1:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018f5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018f9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018fd:	ee                   	out    %al,(%dx)
}
  1018fe:	90                   	nop
  1018ff:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101905:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101909:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10190d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101911:	ee                   	out    %al,(%dx)
}
  101912:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101913:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  10191a:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10191f:	74 0f                	je     101930 <pic_init+0x145>
        pic_setmask(irq_mask);
  101921:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101928:	89 04 24             	mov    %eax,(%esp)
  10192b:	e8 29 fe ff ff       	call   101759 <pic_setmask>
    }
}
  101930:	90                   	nop
  101931:	89 ec                	mov    %ebp,%esp
  101933:	5d                   	pop    %ebp
  101934:	c3                   	ret    

00101935 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
  101935:	55                   	push   %ebp
  101936:	89 e5                	mov    %esp,%ebp
  101938:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  10193b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101942:	00 
  101943:	c7 04 24 20 63 10 00 	movl   $0x106320,(%esp)
  10194a:	e8 16 ea ff ff       	call   100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10194f:	c7 04 24 2a 63 10 00 	movl   $0x10632a,(%esp)
  101956:	e8 0a ea ff ff       	call   100365 <cprintf>
    panic("EOT: kernel seems ok.");
  10195b:	c7 44 24 08 38 63 10 	movl   $0x106338,0x8(%esp)
  101962:	00 
  101963:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  10196a:	00 
  10196b:	c7 04 24 4e 63 10 00 	movl   $0x10634e,(%esp)
  101972:	e8 81 f3 ff ff       	call   100cf8 <__panic>

00101977 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  101977:	55                   	push   %ebp
  101978:	89 e5                	mov    %esp,%ebp
  10197a:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
  10197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101984:	e9 c4 00 00 00       	jmp    101a4d <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198c:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101993:	0f b7 d0             	movzwl %ax,%edx
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	66 89 14 c5 80 b6 11 	mov    %dx,0x11b680(,%eax,8)
  1019a0:	00 
  1019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a4:	66 c7 04 c5 82 b6 11 	movw   $0x8,0x11b682(,%eax,8)
  1019ab:	00 08 00 
  1019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b1:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  1019b8:	00 
  1019b9:	80 e2 e0             	and    $0xe0,%dl
  1019bc:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  1019cd:	00 
  1019ce:	80 e2 1f             	and    $0x1f,%dl
  1019d1:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019db:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019e2:	00 
  1019e3:	80 e2 f0             	and    $0xf0,%dl
  1019e6:	80 ca 0e             	or     $0xe,%dl
  1019e9:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f3:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019fa:	00 
  1019fb:	80 e2 ef             	and    $0xef,%dl
  1019fe:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a08:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101a0f:	00 
  101a10:	80 e2 9f             	and    $0x9f,%dl
  101a13:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1d:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101a24:	00 
  101a25:	80 ca 80             	or     $0x80,%dl
  101a28:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101a39:	c1 e8 10             	shr    $0x10,%eax
  101a3c:	0f b7 d0             	movzwl %ax,%edx
  101a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a42:	66 89 14 c5 86 b6 11 	mov    %dx,0x11b686(,%eax,8)
  101a49:	00 
    for (int i = 0; i < 256; i++)
  101a4a:	ff 45 fc             	incl   -0x4(%ebp)
  101a4d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a54:	0f 8e 2f ff ff ff    	jle    101989 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a5a:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101a5f:	0f b7 c0             	movzwl %ax,%eax
  101a62:	66 a3 48 ba 11 00    	mov    %ax,0x11ba48
  101a68:	66 c7 05 4a ba 11 00 	movw   $0x8,0x11ba4a
  101a6f:	08 00 
  101a71:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a78:	24 e0                	and    $0xe0,%al
  101a7a:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a7f:	0f b6 05 4c ba 11 00 	movzbl 0x11ba4c,%eax
  101a86:	24 1f                	and    $0x1f,%al
  101a88:	a2 4c ba 11 00       	mov    %al,0x11ba4c
  101a8d:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101a94:	24 f0                	and    $0xf0,%al
  101a96:	0c 0e                	or     $0xe,%al
  101a98:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101a9d:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101aa4:	24 ef                	and    $0xef,%al
  101aa6:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101aab:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101ab2:	0c 60                	or     $0x60,%al
  101ab4:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101ab9:	0f b6 05 4d ba 11 00 	movzbl 0x11ba4d,%eax
  101ac0:	0c 80                	or     $0x80,%al
  101ac2:	a2 4d ba 11 00       	mov    %al,0x11ba4d
  101ac7:	a1 c4 87 11 00       	mov    0x1187c4,%eax
  101acc:	c1 e8 10             	shr    $0x10,%eax
  101acf:	0f b7 c0             	movzwl %ax,%eax
  101ad2:	66 a3 4e ba 11 00    	mov    %ax,0x11ba4e
  101ad8:	c7 45 f8 60 85 11 00 	movl   $0x118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ae2:	0f 01 18             	lidtl  (%eax)
}
  101ae5:	90                   	nop
    lidt(&idt_pd);
}
  101ae6:	90                   	nop
  101ae7:	89 ec                	mov    %ebp,%esp
  101ae9:	5d                   	pop    %ebp
  101aea:	c3                   	ret    

00101aeb <trapname>:

static const char *
trapname(int trapno)
{
  101aeb:	55                   	push   %ebp
  101aec:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  101aee:	8b 45 08             	mov    0x8(%ebp),%eax
  101af1:	83 f8 13             	cmp    $0x13,%eax
  101af4:	77 0c                	ja     101b02 <trapname+0x17>
    {
        return excnames[trapno];
  101af6:	8b 45 08             	mov    0x8(%ebp),%eax
  101af9:	8b 04 85 a0 66 10 00 	mov    0x1066a0(,%eax,4),%eax
  101b00:	eb 18                	jmp    101b1a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101b02:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b06:	7e 0d                	jle    101b15 <trapname+0x2a>
  101b08:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b0c:	7f 07                	jg     101b15 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101b0e:	b8 5f 63 10 00       	mov    $0x10635f,%eax
  101b13:	eb 05                	jmp    101b1a <trapname+0x2f>
    }
    return "(unknown trap)";
  101b15:	b8 72 63 10 00       	mov    $0x106372,%eax
}
  101b1a:	5d                   	pop    %ebp
  101b1b:	c3                   	ret    

00101b1c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  101b1c:	55                   	push   %ebp
  101b1d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b26:	83 f8 08             	cmp    $0x8,%eax
  101b29:	0f 94 c0             	sete   %al
  101b2c:	0f b6 c0             	movzbl %al,%eax
}
  101b2f:	5d                   	pop    %ebp
  101b30:	c3                   	ret    

00101b31 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  101b31:	55                   	push   %ebp
  101b32:	89 e5                	mov    %esp,%ebp
  101b34:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b37:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 b3 63 10 00 	movl   $0x1063b3,(%esp)
  101b45:	e8 1b e8 ff ff       	call   100365 <cprintf>
    print_regs(&tf->tf_regs);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	89 04 24             	mov    %eax,(%esp)
  101b50:	e8 8f 01 00 00       	call   101ce4 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b60:	c7 04 24 c4 63 10 00 	movl   $0x1063c4,(%esp)
  101b67:	e8 f9 e7 ff ff       	call   100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b77:	c7 04 24 d7 63 10 00 	movl   $0x1063d7,(%esp)
  101b7e:	e8 e2 e7 ff ff       	call   100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b83:	8b 45 08             	mov    0x8(%ebp),%eax
  101b86:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8e:	c7 04 24 ea 63 10 00 	movl   $0x1063ea,(%esp)
  101b95:	e8 cb e7 ff ff       	call   100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba5:	c7 04 24 fd 63 10 00 	movl   $0x1063fd,(%esp)
  101bac:	e8 b4 e7 ff ff       	call   100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	8b 40 30             	mov    0x30(%eax),%eax
  101bb7:	89 04 24             	mov    %eax,(%esp)
  101bba:	e8 2c ff ff ff       	call   101aeb <trapname>
  101bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  101bc2:	8b 52 30             	mov    0x30(%edx),%edx
  101bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bc9:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bcd:	c7 04 24 10 64 10 00 	movl   $0x106410,(%esp)
  101bd4:	e8 8c e7 ff ff       	call   100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 34             	mov    0x34(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 22 64 10 00 	movl   $0x106422,(%esp)
  101bea:	e8 76 e7 ff ff       	call   100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 38             	mov    0x38(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 31 64 10 00 	movl   $0x106431,(%esp)
  101c00:	e8 60 e7 ff ff       	call   100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 40 64 10 00 	movl   $0x106440,(%esp)
  101c17:	e8 49 e7 ff ff       	call   100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	8b 40 40             	mov    0x40(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 53 64 10 00 	movl   $0x106453,(%esp)
  101c2d:	e8 33 e7 ff ff       	call   100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c39:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c40:	eb 3d                	jmp    101c7f <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101c42:	8b 45 08             	mov    0x8(%ebp),%eax
  101c45:	8b 50 40             	mov    0x40(%eax),%edx
  101c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c4b:	21 d0                	and    %edx,%eax
  101c4d:	85 c0                	test   %eax,%eax
  101c4f:	74 28                	je     101c79 <print_trapframe+0x148>
  101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c54:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c5b:	85 c0                	test   %eax,%eax
  101c5d:	74 1a                	je     101c79 <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
  101c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c62:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6d:	c7 04 24 62 64 10 00 	movl   $0x106462,(%esp)
  101c74:	e8 ec e6 ff ff       	call   100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c79:	ff 45 f4             	incl   -0xc(%ebp)
  101c7c:	d1 65 f0             	shll   -0x10(%ebp)
  101c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c82:	83 f8 17             	cmp    $0x17,%eax
  101c85:	76 bb                	jbe    101c42 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	8b 40 40             	mov    0x40(%eax),%eax
  101c8d:	c1 e8 0c             	shr    $0xc,%eax
  101c90:	83 e0 03             	and    $0x3,%eax
  101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c97:	c7 04 24 66 64 10 00 	movl   $0x106466,(%esp)
  101c9e:	e8 c2 e6 ff ff       	call   100365 <cprintf>

    if (!trap_in_kernel(tf))
  101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca6:	89 04 24             	mov    %eax,(%esp)
  101ca9:	e8 6e fe ff ff       	call   101b1c <trap_in_kernel>
  101cae:	85 c0                	test   %eax,%eax
  101cb0:	75 2d                	jne    101cdf <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb5:	8b 40 44             	mov    0x44(%eax),%eax
  101cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbc:	c7 04 24 6f 64 10 00 	movl   $0x10646f,(%esp)
  101cc3:	e8 9d e6 ff ff       	call   100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 7e 64 10 00 	movl   $0x10647e,(%esp)
  101cda:	e8 86 e6 ff ff       	call   100365 <cprintf>
    }
}
  101cdf:	90                   	nop
  101ce0:	89 ec                	mov    %ebp,%esp
  101ce2:	5d                   	pop    %ebp
  101ce3:	c3                   	ret    

00101ce4 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101ce4:	55                   	push   %ebp
  101ce5:	89 e5                	mov    %esp,%ebp
  101ce7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ced:	8b 00                	mov    (%eax),%eax
  101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf3:	c7 04 24 91 64 10 00 	movl   $0x106491,(%esp)
  101cfa:	e8 66 e6 ff ff       	call   100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cff:	8b 45 08             	mov    0x8(%ebp),%eax
  101d02:	8b 40 04             	mov    0x4(%eax),%eax
  101d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d09:	c7 04 24 a0 64 10 00 	movl   $0x1064a0,(%esp)
  101d10:	e8 50 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d15:	8b 45 08             	mov    0x8(%ebp),%eax
  101d18:	8b 40 08             	mov    0x8(%eax),%eax
  101d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1f:	c7 04 24 af 64 10 00 	movl   $0x1064af,(%esp)
  101d26:	e8 3a e6 ff ff       	call   100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  101d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d35:	c7 04 24 be 64 10 00 	movl   $0x1064be,(%esp)
  101d3c:	e8 24 e6 ff ff       	call   100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d41:	8b 45 08             	mov    0x8(%ebp),%eax
  101d44:	8b 40 10             	mov    0x10(%eax),%eax
  101d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4b:	c7 04 24 cd 64 10 00 	movl   $0x1064cd,(%esp)
  101d52:	e8 0e e6 ff ff       	call   100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d57:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5a:	8b 40 14             	mov    0x14(%eax),%eax
  101d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d61:	c7 04 24 dc 64 10 00 	movl   $0x1064dc,(%esp)
  101d68:	e8 f8 e5 ff ff       	call   100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d70:	8b 40 18             	mov    0x18(%eax),%eax
  101d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d77:	c7 04 24 eb 64 10 00 	movl   $0x1064eb,(%esp)
  101d7e:	e8 e2 e5 ff ff       	call   100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d83:	8b 45 08             	mov    0x8(%ebp),%eax
  101d86:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8d:	c7 04 24 fa 64 10 00 	movl   $0x1064fa,(%esp)
  101d94:	e8 cc e5 ff ff       	call   100365 <cprintf>
}
  101d99:	90                   	nop
  101d9a:	89 ec                	mov    %ebp,%esp
  101d9c:	5d                   	pop    %ebp
  101d9d:	c3                   	ret    

00101d9e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
  101d9e:	55                   	push   %ebp
  101d9f:	89 e5                	mov    %esp,%ebp
  101da1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
  101da4:	8b 45 08             	mov    0x8(%ebp),%eax
  101da7:	8b 40 30             	mov    0x30(%eax),%eax
  101daa:	83 f8 79             	cmp    $0x79,%eax
  101dad:	0f 84 1f 01 00 00    	je     101ed2 <trap_dispatch+0x134>
  101db3:	83 f8 79             	cmp    $0x79,%eax
  101db6:	0f 87 69 01 00 00    	ja     101f25 <trap_dispatch+0x187>
  101dbc:	83 f8 78             	cmp    $0x78,%eax
  101dbf:	0f 84 b7 00 00 00    	je     101e7c <trap_dispatch+0xde>
  101dc5:	83 f8 78             	cmp    $0x78,%eax
  101dc8:	0f 87 57 01 00 00    	ja     101f25 <trap_dispatch+0x187>
  101dce:	83 f8 2f             	cmp    $0x2f,%eax
  101dd1:	0f 87 4e 01 00 00    	ja     101f25 <trap_dispatch+0x187>
  101dd7:	83 f8 2e             	cmp    $0x2e,%eax
  101dda:	0f 83 7a 01 00 00    	jae    101f5a <trap_dispatch+0x1bc>
  101de0:	83 f8 24             	cmp    $0x24,%eax
  101de3:	74 45                	je     101e2a <trap_dispatch+0x8c>
  101de5:	83 f8 24             	cmp    $0x24,%eax
  101de8:	0f 87 37 01 00 00    	ja     101f25 <trap_dispatch+0x187>
  101dee:	83 f8 20             	cmp    $0x20,%eax
  101df1:	74 0a                	je     101dfd <trap_dispatch+0x5f>
  101df3:	83 f8 21             	cmp    $0x21,%eax
  101df6:	74 5b                	je     101e53 <trap_dispatch+0xb5>
  101df8:	e9 28 01 00 00       	jmp    101f25 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101dfd:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101e02:	40                   	inc    %eax
  101e03:	a3 24 b4 11 00       	mov    %eax,0x11b424
        if (ticks == TICK_NUM)
  101e08:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101e0d:	83 f8 64             	cmp    $0x64,%eax
  101e10:	0f 85 47 01 00 00    	jne    101f5d <trap_dispatch+0x1bf>
        {
            ticks = 0;
  101e16:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  101e1d:	00 00 00 
            print_ticks();
  101e20:	e8 10 fb ff ff       	call   101935 <print_ticks>
        }
        break;
  101e25:	e9 33 01 00 00       	jmp    101f5d <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e2a:	e8 a9 f8 ff ff       	call   1016d8 <cons_getc>
  101e2f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e32:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e36:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e42:	c7 04 24 09 65 10 00 	movl   $0x106509,(%esp)
  101e49:	e8 17 e5 ff ff       	call   100365 <cprintf>
        break;
  101e4e:	e9 11 01 00 00       	jmp    101f64 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e53:	e8 80 f8 ff ff       	call   1016d8 <cons_getc>
  101e58:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e5b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e5f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e63:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e6b:	c7 04 24 1b 65 10 00 	movl   $0x10651b,(%esp)
  101e72:	e8 ee e4 ff ff       	call   100365 <cprintf>
        break;
  101e77:	e9 e8 00 00 00       	jmp    101f64 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
  101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e83:	83 f8 1b             	cmp    $0x1b,%eax
  101e86:	0f 84 d4 00 00 00    	je     101f60 <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
  101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101e95:	8b 45 08             	mov    0x8(%ebp),%eax
  101e98:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea8:	66 89 50 28          	mov    %dx,0x28(%eax)
  101eac:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaf:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb6:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101eba:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebd:	8b 40 40             	mov    0x40(%eax),%eax
  101ec0:	0d 00 30 00 00       	or     $0x3000,%eax
  101ec5:	89 c2                	mov    %eax,%edx
  101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  101eca:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101ecd:	e9 8e 00 00 00       	jmp    101f60 <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
  101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ed9:	83 f8 08             	cmp    $0x8,%eax
  101edc:	0f 84 81 00 00 00    	je     101f63 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
  101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee5:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101eee:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101efb:	8b 45 08             	mov    0x8(%ebp),%eax
  101efe:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f02:	8b 45 08             	mov    0x8(%ebp),%eax
  101f05:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f09:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f10:	8b 45 08             	mov    0x8(%ebp),%eax
  101f13:	8b 40 40             	mov    0x40(%eax),%eax
  101f16:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f1b:	89 c2                	mov    %eax,%edx
  101f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f20:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101f23:	eb 3e                	jmp    101f63 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101f25:	8b 45 08             	mov    0x8(%ebp),%eax
  101f28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f2c:	83 e0 03             	and    $0x3,%eax
  101f2f:	85 c0                	test   %eax,%eax
  101f31:	75 31                	jne    101f64 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
  101f33:	8b 45 08             	mov    0x8(%ebp),%eax
  101f36:	89 04 24             	mov    %eax,(%esp)
  101f39:	e8 f3 fb ff ff       	call   101b31 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f3e:	c7 44 24 08 2a 65 10 	movl   $0x10652a,0x8(%esp)
  101f45:	00 
  101f46:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  101f4d:	00 
  101f4e:	c7 04 24 4e 63 10 00 	movl   $0x10634e,(%esp)
  101f55:	e8 9e ed ff ff       	call   100cf8 <__panic>
        break;
  101f5a:	90                   	nop
  101f5b:	eb 07                	jmp    101f64 <trap_dispatch+0x1c6>
        break;
  101f5d:	90                   	nop
  101f5e:	eb 04                	jmp    101f64 <trap_dispatch+0x1c6>
        break;
  101f60:	90                   	nop
  101f61:	eb 01                	jmp    101f64 <trap_dispatch+0x1c6>
        break;
  101f63:	90                   	nop
        }
    }
}
  101f64:	90                   	nop
  101f65:	89 ec                	mov    %ebp,%esp
  101f67:	5d                   	pop    %ebp
  101f68:	c3                   	ret    

00101f69 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101f69:	55                   	push   %ebp
  101f6a:	89 e5                	mov    %esp,%ebp
  101f6c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f72:	89 04 24             	mov    %eax,(%esp)
  101f75:	e8 24 fe ff ff       	call   101d9e <trap_dispatch>
}
  101f7a:	90                   	nop
  101f7b:	89 ec                	mov    %ebp,%esp
  101f7d:	5d                   	pop    %ebp
  101f7e:	c3                   	ret    

00101f7f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f7f:	1e                   	push   %ds
    pushl %es
  101f80:	06                   	push   %es
    pushl %fs
  101f81:	0f a0                	push   %fs
    pushl %gs
  101f83:	0f a8                	push   %gs
    pushal
  101f85:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f86:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f8b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f8d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f8f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f90:	e8 d4 ff ff ff       	call   101f69 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f95:	5c                   	pop    %esp

00101f96 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f96:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f97:	0f a9                	pop    %gs
    popl %fs
  101f99:	0f a1                	pop    %fs
    popl %es
  101f9b:	07                   	pop    %es
    popl %ds
  101f9c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f9d:	83 c4 08             	add    $0x8,%esp
    iret
  101fa0:	cf                   	iret   

00101fa1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $0
  101fa3:	6a 00                	push   $0x0
  jmp __alltraps
  101fa5:	e9 d5 ff ff ff       	jmp    101f7f <__alltraps>

00101faa <vector1>:
.globl vector1
vector1:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $1
  101fac:	6a 01                	push   $0x1
  jmp __alltraps
  101fae:	e9 cc ff ff ff       	jmp    101f7f <__alltraps>

00101fb3 <vector2>:
.globl vector2
vector2:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $2
  101fb5:	6a 02                	push   $0x2
  jmp __alltraps
  101fb7:	e9 c3 ff ff ff       	jmp    101f7f <__alltraps>

00101fbc <vector3>:
.globl vector3
vector3:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $3
  101fbe:	6a 03                	push   $0x3
  jmp __alltraps
  101fc0:	e9 ba ff ff ff       	jmp    101f7f <__alltraps>

00101fc5 <vector4>:
.globl vector4
vector4:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $4
  101fc7:	6a 04                	push   $0x4
  jmp __alltraps
  101fc9:	e9 b1 ff ff ff       	jmp    101f7f <__alltraps>

00101fce <vector5>:
.globl vector5
vector5:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $5
  101fd0:	6a 05                	push   $0x5
  jmp __alltraps
  101fd2:	e9 a8 ff ff ff       	jmp    101f7f <__alltraps>

00101fd7 <vector6>:
.globl vector6
vector6:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $6
  101fd9:	6a 06                	push   $0x6
  jmp __alltraps
  101fdb:	e9 9f ff ff ff       	jmp    101f7f <__alltraps>

00101fe0 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $7
  101fe2:	6a 07                	push   $0x7
  jmp __alltraps
  101fe4:	e9 96 ff ff ff       	jmp    101f7f <__alltraps>

00101fe9 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fe9:	6a 08                	push   $0x8
  jmp __alltraps
  101feb:	e9 8f ff ff ff       	jmp    101f7f <__alltraps>

00101ff0 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $9
  101ff2:	6a 09                	push   $0x9
  jmp __alltraps
  101ff4:	e9 86 ff ff ff       	jmp    101f7f <__alltraps>

00101ff9 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ff9:	6a 0a                	push   $0xa
  jmp __alltraps
  101ffb:	e9 7f ff ff ff       	jmp    101f7f <__alltraps>

00102000 <vector11>:
.globl vector11
vector11:
  pushl $11
  102000:	6a 0b                	push   $0xb
  jmp __alltraps
  102002:	e9 78 ff ff ff       	jmp    101f7f <__alltraps>

00102007 <vector12>:
.globl vector12
vector12:
  pushl $12
  102007:	6a 0c                	push   $0xc
  jmp __alltraps
  102009:	e9 71 ff ff ff       	jmp    101f7f <__alltraps>

0010200e <vector13>:
.globl vector13
vector13:
  pushl $13
  10200e:	6a 0d                	push   $0xd
  jmp __alltraps
  102010:	e9 6a ff ff ff       	jmp    101f7f <__alltraps>

00102015 <vector14>:
.globl vector14
vector14:
  pushl $14
  102015:	6a 0e                	push   $0xe
  jmp __alltraps
  102017:	e9 63 ff ff ff       	jmp    101f7f <__alltraps>

0010201c <vector15>:
.globl vector15
vector15:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $15
  10201e:	6a 0f                	push   $0xf
  jmp __alltraps
  102020:	e9 5a ff ff ff       	jmp    101f7f <__alltraps>

00102025 <vector16>:
.globl vector16
vector16:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $16
  102027:	6a 10                	push   $0x10
  jmp __alltraps
  102029:	e9 51 ff ff ff       	jmp    101f7f <__alltraps>

0010202e <vector17>:
.globl vector17
vector17:
  pushl $17
  10202e:	6a 11                	push   $0x11
  jmp __alltraps
  102030:	e9 4a ff ff ff       	jmp    101f7f <__alltraps>

00102035 <vector18>:
.globl vector18
vector18:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $18
  102037:	6a 12                	push   $0x12
  jmp __alltraps
  102039:	e9 41 ff ff ff       	jmp    101f7f <__alltraps>

0010203e <vector19>:
.globl vector19
vector19:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $19
  102040:	6a 13                	push   $0x13
  jmp __alltraps
  102042:	e9 38 ff ff ff       	jmp    101f7f <__alltraps>

00102047 <vector20>:
.globl vector20
vector20:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $20
  102049:	6a 14                	push   $0x14
  jmp __alltraps
  10204b:	e9 2f ff ff ff       	jmp    101f7f <__alltraps>

00102050 <vector21>:
.globl vector21
vector21:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $21
  102052:	6a 15                	push   $0x15
  jmp __alltraps
  102054:	e9 26 ff ff ff       	jmp    101f7f <__alltraps>

00102059 <vector22>:
.globl vector22
vector22:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $22
  10205b:	6a 16                	push   $0x16
  jmp __alltraps
  10205d:	e9 1d ff ff ff       	jmp    101f7f <__alltraps>

00102062 <vector23>:
.globl vector23
vector23:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $23
  102064:	6a 17                	push   $0x17
  jmp __alltraps
  102066:	e9 14 ff ff ff       	jmp    101f7f <__alltraps>

0010206b <vector24>:
.globl vector24
vector24:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $24
  10206d:	6a 18                	push   $0x18
  jmp __alltraps
  10206f:	e9 0b ff ff ff       	jmp    101f7f <__alltraps>

00102074 <vector25>:
.globl vector25
vector25:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $25
  102076:	6a 19                	push   $0x19
  jmp __alltraps
  102078:	e9 02 ff ff ff       	jmp    101f7f <__alltraps>

0010207d <vector26>:
.globl vector26
vector26:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $26
  10207f:	6a 1a                	push   $0x1a
  jmp __alltraps
  102081:	e9 f9 fe ff ff       	jmp    101f7f <__alltraps>

00102086 <vector27>:
.globl vector27
vector27:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $27
  102088:	6a 1b                	push   $0x1b
  jmp __alltraps
  10208a:	e9 f0 fe ff ff       	jmp    101f7f <__alltraps>

0010208f <vector28>:
.globl vector28
vector28:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $28
  102091:	6a 1c                	push   $0x1c
  jmp __alltraps
  102093:	e9 e7 fe ff ff       	jmp    101f7f <__alltraps>

00102098 <vector29>:
.globl vector29
vector29:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $29
  10209a:	6a 1d                	push   $0x1d
  jmp __alltraps
  10209c:	e9 de fe ff ff       	jmp    101f7f <__alltraps>

001020a1 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $30
  1020a3:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020a5:	e9 d5 fe ff ff       	jmp    101f7f <__alltraps>

001020aa <vector31>:
.globl vector31
vector31:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $31
  1020ac:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020ae:	e9 cc fe ff ff       	jmp    101f7f <__alltraps>

001020b3 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $32
  1020b5:	6a 20                	push   $0x20
  jmp __alltraps
  1020b7:	e9 c3 fe ff ff       	jmp    101f7f <__alltraps>

001020bc <vector33>:
.globl vector33
vector33:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $33
  1020be:	6a 21                	push   $0x21
  jmp __alltraps
  1020c0:	e9 ba fe ff ff       	jmp    101f7f <__alltraps>

001020c5 <vector34>:
.globl vector34
vector34:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $34
  1020c7:	6a 22                	push   $0x22
  jmp __alltraps
  1020c9:	e9 b1 fe ff ff       	jmp    101f7f <__alltraps>

001020ce <vector35>:
.globl vector35
vector35:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $35
  1020d0:	6a 23                	push   $0x23
  jmp __alltraps
  1020d2:	e9 a8 fe ff ff       	jmp    101f7f <__alltraps>

001020d7 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $36
  1020d9:	6a 24                	push   $0x24
  jmp __alltraps
  1020db:	e9 9f fe ff ff       	jmp    101f7f <__alltraps>

001020e0 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $37
  1020e2:	6a 25                	push   $0x25
  jmp __alltraps
  1020e4:	e9 96 fe ff ff       	jmp    101f7f <__alltraps>

001020e9 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $38
  1020eb:	6a 26                	push   $0x26
  jmp __alltraps
  1020ed:	e9 8d fe ff ff       	jmp    101f7f <__alltraps>

001020f2 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $39
  1020f4:	6a 27                	push   $0x27
  jmp __alltraps
  1020f6:	e9 84 fe ff ff       	jmp    101f7f <__alltraps>

001020fb <vector40>:
.globl vector40
vector40:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $40
  1020fd:	6a 28                	push   $0x28
  jmp __alltraps
  1020ff:	e9 7b fe ff ff       	jmp    101f7f <__alltraps>

00102104 <vector41>:
.globl vector41
vector41:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $41
  102106:	6a 29                	push   $0x29
  jmp __alltraps
  102108:	e9 72 fe ff ff       	jmp    101f7f <__alltraps>

0010210d <vector42>:
.globl vector42
vector42:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $42
  10210f:	6a 2a                	push   $0x2a
  jmp __alltraps
  102111:	e9 69 fe ff ff       	jmp    101f7f <__alltraps>

00102116 <vector43>:
.globl vector43
vector43:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $43
  102118:	6a 2b                	push   $0x2b
  jmp __alltraps
  10211a:	e9 60 fe ff ff       	jmp    101f7f <__alltraps>

0010211f <vector44>:
.globl vector44
vector44:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $44
  102121:	6a 2c                	push   $0x2c
  jmp __alltraps
  102123:	e9 57 fe ff ff       	jmp    101f7f <__alltraps>

00102128 <vector45>:
.globl vector45
vector45:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $45
  10212a:	6a 2d                	push   $0x2d
  jmp __alltraps
  10212c:	e9 4e fe ff ff       	jmp    101f7f <__alltraps>

00102131 <vector46>:
.globl vector46
vector46:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $46
  102133:	6a 2e                	push   $0x2e
  jmp __alltraps
  102135:	e9 45 fe ff ff       	jmp    101f7f <__alltraps>

0010213a <vector47>:
.globl vector47
vector47:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $47
  10213c:	6a 2f                	push   $0x2f
  jmp __alltraps
  10213e:	e9 3c fe ff ff       	jmp    101f7f <__alltraps>

00102143 <vector48>:
.globl vector48
vector48:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $48
  102145:	6a 30                	push   $0x30
  jmp __alltraps
  102147:	e9 33 fe ff ff       	jmp    101f7f <__alltraps>

0010214c <vector49>:
.globl vector49
vector49:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $49
  10214e:	6a 31                	push   $0x31
  jmp __alltraps
  102150:	e9 2a fe ff ff       	jmp    101f7f <__alltraps>

00102155 <vector50>:
.globl vector50
vector50:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $50
  102157:	6a 32                	push   $0x32
  jmp __alltraps
  102159:	e9 21 fe ff ff       	jmp    101f7f <__alltraps>

0010215e <vector51>:
.globl vector51
vector51:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $51
  102160:	6a 33                	push   $0x33
  jmp __alltraps
  102162:	e9 18 fe ff ff       	jmp    101f7f <__alltraps>

00102167 <vector52>:
.globl vector52
vector52:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $52
  102169:	6a 34                	push   $0x34
  jmp __alltraps
  10216b:	e9 0f fe ff ff       	jmp    101f7f <__alltraps>

00102170 <vector53>:
.globl vector53
vector53:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $53
  102172:	6a 35                	push   $0x35
  jmp __alltraps
  102174:	e9 06 fe ff ff       	jmp    101f7f <__alltraps>

00102179 <vector54>:
.globl vector54
vector54:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $54
  10217b:	6a 36                	push   $0x36
  jmp __alltraps
  10217d:	e9 fd fd ff ff       	jmp    101f7f <__alltraps>

00102182 <vector55>:
.globl vector55
vector55:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $55
  102184:	6a 37                	push   $0x37
  jmp __alltraps
  102186:	e9 f4 fd ff ff       	jmp    101f7f <__alltraps>

0010218b <vector56>:
.globl vector56
vector56:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $56
  10218d:	6a 38                	push   $0x38
  jmp __alltraps
  10218f:	e9 eb fd ff ff       	jmp    101f7f <__alltraps>

00102194 <vector57>:
.globl vector57
vector57:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $57
  102196:	6a 39                	push   $0x39
  jmp __alltraps
  102198:	e9 e2 fd ff ff       	jmp    101f7f <__alltraps>

0010219d <vector58>:
.globl vector58
vector58:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $58
  10219f:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021a1:	e9 d9 fd ff ff       	jmp    101f7f <__alltraps>

001021a6 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $59
  1021a8:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021aa:	e9 d0 fd ff ff       	jmp    101f7f <__alltraps>

001021af <vector60>:
.globl vector60
vector60:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $60
  1021b1:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021b3:	e9 c7 fd ff ff       	jmp    101f7f <__alltraps>

001021b8 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $61
  1021ba:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021bc:	e9 be fd ff ff       	jmp    101f7f <__alltraps>

001021c1 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $62
  1021c3:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021c5:	e9 b5 fd ff ff       	jmp    101f7f <__alltraps>

001021ca <vector63>:
.globl vector63
vector63:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $63
  1021cc:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021ce:	e9 ac fd ff ff       	jmp    101f7f <__alltraps>

001021d3 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $64
  1021d5:	6a 40                	push   $0x40
  jmp __alltraps
  1021d7:	e9 a3 fd ff ff       	jmp    101f7f <__alltraps>

001021dc <vector65>:
.globl vector65
vector65:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $65
  1021de:	6a 41                	push   $0x41
  jmp __alltraps
  1021e0:	e9 9a fd ff ff       	jmp    101f7f <__alltraps>

001021e5 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $66
  1021e7:	6a 42                	push   $0x42
  jmp __alltraps
  1021e9:	e9 91 fd ff ff       	jmp    101f7f <__alltraps>

001021ee <vector67>:
.globl vector67
vector67:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $67
  1021f0:	6a 43                	push   $0x43
  jmp __alltraps
  1021f2:	e9 88 fd ff ff       	jmp    101f7f <__alltraps>

001021f7 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $68
  1021f9:	6a 44                	push   $0x44
  jmp __alltraps
  1021fb:	e9 7f fd ff ff       	jmp    101f7f <__alltraps>

00102200 <vector69>:
.globl vector69
vector69:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $69
  102202:	6a 45                	push   $0x45
  jmp __alltraps
  102204:	e9 76 fd ff ff       	jmp    101f7f <__alltraps>

00102209 <vector70>:
.globl vector70
vector70:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $70
  10220b:	6a 46                	push   $0x46
  jmp __alltraps
  10220d:	e9 6d fd ff ff       	jmp    101f7f <__alltraps>

00102212 <vector71>:
.globl vector71
vector71:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $71
  102214:	6a 47                	push   $0x47
  jmp __alltraps
  102216:	e9 64 fd ff ff       	jmp    101f7f <__alltraps>

0010221b <vector72>:
.globl vector72
vector72:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $72
  10221d:	6a 48                	push   $0x48
  jmp __alltraps
  10221f:	e9 5b fd ff ff       	jmp    101f7f <__alltraps>

00102224 <vector73>:
.globl vector73
vector73:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $73
  102226:	6a 49                	push   $0x49
  jmp __alltraps
  102228:	e9 52 fd ff ff       	jmp    101f7f <__alltraps>

0010222d <vector74>:
.globl vector74
vector74:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $74
  10222f:	6a 4a                	push   $0x4a
  jmp __alltraps
  102231:	e9 49 fd ff ff       	jmp    101f7f <__alltraps>

00102236 <vector75>:
.globl vector75
vector75:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $75
  102238:	6a 4b                	push   $0x4b
  jmp __alltraps
  10223a:	e9 40 fd ff ff       	jmp    101f7f <__alltraps>

0010223f <vector76>:
.globl vector76
vector76:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $76
  102241:	6a 4c                	push   $0x4c
  jmp __alltraps
  102243:	e9 37 fd ff ff       	jmp    101f7f <__alltraps>

00102248 <vector77>:
.globl vector77
vector77:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $77
  10224a:	6a 4d                	push   $0x4d
  jmp __alltraps
  10224c:	e9 2e fd ff ff       	jmp    101f7f <__alltraps>

00102251 <vector78>:
.globl vector78
vector78:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $78
  102253:	6a 4e                	push   $0x4e
  jmp __alltraps
  102255:	e9 25 fd ff ff       	jmp    101f7f <__alltraps>

0010225a <vector79>:
.globl vector79
vector79:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $79
  10225c:	6a 4f                	push   $0x4f
  jmp __alltraps
  10225e:	e9 1c fd ff ff       	jmp    101f7f <__alltraps>

00102263 <vector80>:
.globl vector80
vector80:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $80
  102265:	6a 50                	push   $0x50
  jmp __alltraps
  102267:	e9 13 fd ff ff       	jmp    101f7f <__alltraps>

0010226c <vector81>:
.globl vector81
vector81:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $81
  10226e:	6a 51                	push   $0x51
  jmp __alltraps
  102270:	e9 0a fd ff ff       	jmp    101f7f <__alltraps>

00102275 <vector82>:
.globl vector82
vector82:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $82
  102277:	6a 52                	push   $0x52
  jmp __alltraps
  102279:	e9 01 fd ff ff       	jmp    101f7f <__alltraps>

0010227e <vector83>:
.globl vector83
vector83:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $83
  102280:	6a 53                	push   $0x53
  jmp __alltraps
  102282:	e9 f8 fc ff ff       	jmp    101f7f <__alltraps>

00102287 <vector84>:
.globl vector84
vector84:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $84
  102289:	6a 54                	push   $0x54
  jmp __alltraps
  10228b:	e9 ef fc ff ff       	jmp    101f7f <__alltraps>

00102290 <vector85>:
.globl vector85
vector85:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $85
  102292:	6a 55                	push   $0x55
  jmp __alltraps
  102294:	e9 e6 fc ff ff       	jmp    101f7f <__alltraps>

00102299 <vector86>:
.globl vector86
vector86:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $86
  10229b:	6a 56                	push   $0x56
  jmp __alltraps
  10229d:	e9 dd fc ff ff       	jmp    101f7f <__alltraps>

001022a2 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $87
  1022a4:	6a 57                	push   $0x57
  jmp __alltraps
  1022a6:	e9 d4 fc ff ff       	jmp    101f7f <__alltraps>

001022ab <vector88>:
.globl vector88
vector88:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $88
  1022ad:	6a 58                	push   $0x58
  jmp __alltraps
  1022af:	e9 cb fc ff ff       	jmp    101f7f <__alltraps>

001022b4 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $89
  1022b6:	6a 59                	push   $0x59
  jmp __alltraps
  1022b8:	e9 c2 fc ff ff       	jmp    101f7f <__alltraps>

001022bd <vector90>:
.globl vector90
vector90:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $90
  1022bf:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022c1:	e9 b9 fc ff ff       	jmp    101f7f <__alltraps>

001022c6 <vector91>:
.globl vector91
vector91:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $91
  1022c8:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022ca:	e9 b0 fc ff ff       	jmp    101f7f <__alltraps>

001022cf <vector92>:
.globl vector92
vector92:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $92
  1022d1:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022d3:	e9 a7 fc ff ff       	jmp    101f7f <__alltraps>

001022d8 <vector93>:
.globl vector93
vector93:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $93
  1022da:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022dc:	e9 9e fc ff ff       	jmp    101f7f <__alltraps>

001022e1 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $94
  1022e3:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022e5:	e9 95 fc ff ff       	jmp    101f7f <__alltraps>

001022ea <vector95>:
.globl vector95
vector95:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $95
  1022ec:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022ee:	e9 8c fc ff ff       	jmp    101f7f <__alltraps>

001022f3 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $96
  1022f5:	6a 60                	push   $0x60
  jmp __alltraps
  1022f7:	e9 83 fc ff ff       	jmp    101f7f <__alltraps>

001022fc <vector97>:
.globl vector97
vector97:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $97
  1022fe:	6a 61                	push   $0x61
  jmp __alltraps
  102300:	e9 7a fc ff ff       	jmp    101f7f <__alltraps>

00102305 <vector98>:
.globl vector98
vector98:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $98
  102307:	6a 62                	push   $0x62
  jmp __alltraps
  102309:	e9 71 fc ff ff       	jmp    101f7f <__alltraps>

0010230e <vector99>:
.globl vector99
vector99:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $99
  102310:	6a 63                	push   $0x63
  jmp __alltraps
  102312:	e9 68 fc ff ff       	jmp    101f7f <__alltraps>

00102317 <vector100>:
.globl vector100
vector100:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $100
  102319:	6a 64                	push   $0x64
  jmp __alltraps
  10231b:	e9 5f fc ff ff       	jmp    101f7f <__alltraps>

00102320 <vector101>:
.globl vector101
vector101:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $101
  102322:	6a 65                	push   $0x65
  jmp __alltraps
  102324:	e9 56 fc ff ff       	jmp    101f7f <__alltraps>

00102329 <vector102>:
.globl vector102
vector102:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $102
  10232b:	6a 66                	push   $0x66
  jmp __alltraps
  10232d:	e9 4d fc ff ff       	jmp    101f7f <__alltraps>

00102332 <vector103>:
.globl vector103
vector103:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $103
  102334:	6a 67                	push   $0x67
  jmp __alltraps
  102336:	e9 44 fc ff ff       	jmp    101f7f <__alltraps>

0010233b <vector104>:
.globl vector104
vector104:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $104
  10233d:	6a 68                	push   $0x68
  jmp __alltraps
  10233f:	e9 3b fc ff ff       	jmp    101f7f <__alltraps>

00102344 <vector105>:
.globl vector105
vector105:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $105
  102346:	6a 69                	push   $0x69
  jmp __alltraps
  102348:	e9 32 fc ff ff       	jmp    101f7f <__alltraps>

0010234d <vector106>:
.globl vector106
vector106:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $106
  10234f:	6a 6a                	push   $0x6a
  jmp __alltraps
  102351:	e9 29 fc ff ff       	jmp    101f7f <__alltraps>

00102356 <vector107>:
.globl vector107
vector107:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $107
  102358:	6a 6b                	push   $0x6b
  jmp __alltraps
  10235a:	e9 20 fc ff ff       	jmp    101f7f <__alltraps>

0010235f <vector108>:
.globl vector108
vector108:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $108
  102361:	6a 6c                	push   $0x6c
  jmp __alltraps
  102363:	e9 17 fc ff ff       	jmp    101f7f <__alltraps>

00102368 <vector109>:
.globl vector109
vector109:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $109
  10236a:	6a 6d                	push   $0x6d
  jmp __alltraps
  10236c:	e9 0e fc ff ff       	jmp    101f7f <__alltraps>

00102371 <vector110>:
.globl vector110
vector110:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $110
  102373:	6a 6e                	push   $0x6e
  jmp __alltraps
  102375:	e9 05 fc ff ff       	jmp    101f7f <__alltraps>

0010237a <vector111>:
.globl vector111
vector111:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $111
  10237c:	6a 6f                	push   $0x6f
  jmp __alltraps
  10237e:	e9 fc fb ff ff       	jmp    101f7f <__alltraps>

00102383 <vector112>:
.globl vector112
vector112:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $112
  102385:	6a 70                	push   $0x70
  jmp __alltraps
  102387:	e9 f3 fb ff ff       	jmp    101f7f <__alltraps>

0010238c <vector113>:
.globl vector113
vector113:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $113
  10238e:	6a 71                	push   $0x71
  jmp __alltraps
  102390:	e9 ea fb ff ff       	jmp    101f7f <__alltraps>

00102395 <vector114>:
.globl vector114
vector114:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $114
  102397:	6a 72                	push   $0x72
  jmp __alltraps
  102399:	e9 e1 fb ff ff       	jmp    101f7f <__alltraps>

0010239e <vector115>:
.globl vector115
vector115:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $115
  1023a0:	6a 73                	push   $0x73
  jmp __alltraps
  1023a2:	e9 d8 fb ff ff       	jmp    101f7f <__alltraps>

001023a7 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $116
  1023a9:	6a 74                	push   $0x74
  jmp __alltraps
  1023ab:	e9 cf fb ff ff       	jmp    101f7f <__alltraps>

001023b0 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $117
  1023b2:	6a 75                	push   $0x75
  jmp __alltraps
  1023b4:	e9 c6 fb ff ff       	jmp    101f7f <__alltraps>

001023b9 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $118
  1023bb:	6a 76                	push   $0x76
  jmp __alltraps
  1023bd:	e9 bd fb ff ff       	jmp    101f7f <__alltraps>

001023c2 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $119
  1023c4:	6a 77                	push   $0x77
  jmp __alltraps
  1023c6:	e9 b4 fb ff ff       	jmp    101f7f <__alltraps>

001023cb <vector120>:
.globl vector120
vector120:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $120
  1023cd:	6a 78                	push   $0x78
  jmp __alltraps
  1023cf:	e9 ab fb ff ff       	jmp    101f7f <__alltraps>

001023d4 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $121
  1023d6:	6a 79                	push   $0x79
  jmp __alltraps
  1023d8:	e9 a2 fb ff ff       	jmp    101f7f <__alltraps>

001023dd <vector122>:
.globl vector122
vector122:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $122
  1023df:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023e1:	e9 99 fb ff ff       	jmp    101f7f <__alltraps>

001023e6 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $123
  1023e8:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023ea:	e9 90 fb ff ff       	jmp    101f7f <__alltraps>

001023ef <vector124>:
.globl vector124
vector124:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $124
  1023f1:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023f3:	e9 87 fb ff ff       	jmp    101f7f <__alltraps>

001023f8 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $125
  1023fa:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023fc:	e9 7e fb ff ff       	jmp    101f7f <__alltraps>

00102401 <vector126>:
.globl vector126
vector126:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $126
  102403:	6a 7e                	push   $0x7e
  jmp __alltraps
  102405:	e9 75 fb ff ff       	jmp    101f7f <__alltraps>

0010240a <vector127>:
.globl vector127
vector127:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $127
  10240c:	6a 7f                	push   $0x7f
  jmp __alltraps
  10240e:	e9 6c fb ff ff       	jmp    101f7f <__alltraps>

00102413 <vector128>:
.globl vector128
vector128:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $128
  102415:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10241a:	e9 60 fb ff ff       	jmp    101f7f <__alltraps>

0010241f <vector129>:
.globl vector129
vector129:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $129
  102421:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102426:	e9 54 fb ff ff       	jmp    101f7f <__alltraps>

0010242b <vector130>:
.globl vector130
vector130:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $130
  10242d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102432:	e9 48 fb ff ff       	jmp    101f7f <__alltraps>

00102437 <vector131>:
.globl vector131
vector131:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $131
  102439:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10243e:	e9 3c fb ff ff       	jmp    101f7f <__alltraps>

00102443 <vector132>:
.globl vector132
vector132:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $132
  102445:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10244a:	e9 30 fb ff ff       	jmp    101f7f <__alltraps>

0010244f <vector133>:
.globl vector133
vector133:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $133
  102451:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102456:	e9 24 fb ff ff       	jmp    101f7f <__alltraps>

0010245b <vector134>:
.globl vector134
vector134:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $134
  10245d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102462:	e9 18 fb ff ff       	jmp    101f7f <__alltraps>

00102467 <vector135>:
.globl vector135
vector135:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $135
  102469:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10246e:	e9 0c fb ff ff       	jmp    101f7f <__alltraps>

00102473 <vector136>:
.globl vector136
vector136:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $136
  102475:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10247a:	e9 00 fb ff ff       	jmp    101f7f <__alltraps>

0010247f <vector137>:
.globl vector137
vector137:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $137
  102481:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102486:	e9 f4 fa ff ff       	jmp    101f7f <__alltraps>

0010248b <vector138>:
.globl vector138
vector138:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $138
  10248d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102492:	e9 e8 fa ff ff       	jmp    101f7f <__alltraps>

00102497 <vector139>:
.globl vector139
vector139:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $139
  102499:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10249e:	e9 dc fa ff ff       	jmp    101f7f <__alltraps>

001024a3 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $140
  1024a5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024aa:	e9 d0 fa ff ff       	jmp    101f7f <__alltraps>

001024af <vector141>:
.globl vector141
vector141:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $141
  1024b1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024b6:	e9 c4 fa ff ff       	jmp    101f7f <__alltraps>

001024bb <vector142>:
.globl vector142
vector142:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $142
  1024bd:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024c2:	e9 b8 fa ff ff       	jmp    101f7f <__alltraps>

001024c7 <vector143>:
.globl vector143
vector143:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $143
  1024c9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024ce:	e9 ac fa ff ff       	jmp    101f7f <__alltraps>

001024d3 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $144
  1024d5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024da:	e9 a0 fa ff ff       	jmp    101f7f <__alltraps>

001024df <vector145>:
.globl vector145
vector145:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $145
  1024e1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024e6:	e9 94 fa ff ff       	jmp    101f7f <__alltraps>

001024eb <vector146>:
.globl vector146
vector146:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $146
  1024ed:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024f2:	e9 88 fa ff ff       	jmp    101f7f <__alltraps>

001024f7 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $147
  1024f9:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024fe:	e9 7c fa ff ff       	jmp    101f7f <__alltraps>

00102503 <vector148>:
.globl vector148
vector148:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $148
  102505:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10250a:	e9 70 fa ff ff       	jmp    101f7f <__alltraps>

0010250f <vector149>:
.globl vector149
vector149:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $149
  102511:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102516:	e9 64 fa ff ff       	jmp    101f7f <__alltraps>

0010251b <vector150>:
.globl vector150
vector150:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $150
  10251d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102522:	e9 58 fa ff ff       	jmp    101f7f <__alltraps>

00102527 <vector151>:
.globl vector151
vector151:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $151
  102529:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10252e:	e9 4c fa ff ff       	jmp    101f7f <__alltraps>

00102533 <vector152>:
.globl vector152
vector152:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $152
  102535:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10253a:	e9 40 fa ff ff       	jmp    101f7f <__alltraps>

0010253f <vector153>:
.globl vector153
vector153:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $153
  102541:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102546:	e9 34 fa ff ff       	jmp    101f7f <__alltraps>

0010254b <vector154>:
.globl vector154
vector154:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $154
  10254d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102552:	e9 28 fa ff ff       	jmp    101f7f <__alltraps>

00102557 <vector155>:
.globl vector155
vector155:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $155
  102559:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10255e:	e9 1c fa ff ff       	jmp    101f7f <__alltraps>

00102563 <vector156>:
.globl vector156
vector156:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $156
  102565:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10256a:	e9 10 fa ff ff       	jmp    101f7f <__alltraps>

0010256f <vector157>:
.globl vector157
vector157:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $157
  102571:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102576:	e9 04 fa ff ff       	jmp    101f7f <__alltraps>

0010257b <vector158>:
.globl vector158
vector158:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $158
  10257d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102582:	e9 f8 f9 ff ff       	jmp    101f7f <__alltraps>

00102587 <vector159>:
.globl vector159
vector159:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $159
  102589:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10258e:	e9 ec f9 ff ff       	jmp    101f7f <__alltraps>

00102593 <vector160>:
.globl vector160
vector160:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $160
  102595:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10259a:	e9 e0 f9 ff ff       	jmp    101f7f <__alltraps>

0010259f <vector161>:
.globl vector161
vector161:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $161
  1025a1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025a6:	e9 d4 f9 ff ff       	jmp    101f7f <__alltraps>

001025ab <vector162>:
.globl vector162
vector162:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $162
  1025ad:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025b2:	e9 c8 f9 ff ff       	jmp    101f7f <__alltraps>

001025b7 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $163
  1025b9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025be:	e9 bc f9 ff ff       	jmp    101f7f <__alltraps>

001025c3 <vector164>:
.globl vector164
vector164:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $164
  1025c5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025ca:	e9 b0 f9 ff ff       	jmp    101f7f <__alltraps>

001025cf <vector165>:
.globl vector165
vector165:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $165
  1025d1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025d6:	e9 a4 f9 ff ff       	jmp    101f7f <__alltraps>

001025db <vector166>:
.globl vector166
vector166:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $166
  1025dd:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025e2:	e9 98 f9 ff ff       	jmp    101f7f <__alltraps>

001025e7 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $167
  1025e9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025ee:	e9 8c f9 ff ff       	jmp    101f7f <__alltraps>

001025f3 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $168
  1025f5:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025fa:	e9 80 f9 ff ff       	jmp    101f7f <__alltraps>

001025ff <vector169>:
.globl vector169
vector169:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $169
  102601:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102606:	e9 74 f9 ff ff       	jmp    101f7f <__alltraps>

0010260b <vector170>:
.globl vector170
vector170:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $170
  10260d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102612:	e9 68 f9 ff ff       	jmp    101f7f <__alltraps>

00102617 <vector171>:
.globl vector171
vector171:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $171
  102619:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10261e:	e9 5c f9 ff ff       	jmp    101f7f <__alltraps>

00102623 <vector172>:
.globl vector172
vector172:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $172
  102625:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10262a:	e9 50 f9 ff ff       	jmp    101f7f <__alltraps>

0010262f <vector173>:
.globl vector173
vector173:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $173
  102631:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102636:	e9 44 f9 ff ff       	jmp    101f7f <__alltraps>

0010263b <vector174>:
.globl vector174
vector174:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $174
  10263d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102642:	e9 38 f9 ff ff       	jmp    101f7f <__alltraps>

00102647 <vector175>:
.globl vector175
vector175:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $175
  102649:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10264e:	e9 2c f9 ff ff       	jmp    101f7f <__alltraps>

00102653 <vector176>:
.globl vector176
vector176:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $176
  102655:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10265a:	e9 20 f9 ff ff       	jmp    101f7f <__alltraps>

0010265f <vector177>:
.globl vector177
vector177:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $177
  102661:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102666:	e9 14 f9 ff ff       	jmp    101f7f <__alltraps>

0010266b <vector178>:
.globl vector178
vector178:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $178
  10266d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102672:	e9 08 f9 ff ff       	jmp    101f7f <__alltraps>

00102677 <vector179>:
.globl vector179
vector179:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $179
  102679:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10267e:	e9 fc f8 ff ff       	jmp    101f7f <__alltraps>

00102683 <vector180>:
.globl vector180
vector180:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $180
  102685:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10268a:	e9 f0 f8 ff ff       	jmp    101f7f <__alltraps>

0010268f <vector181>:
.globl vector181
vector181:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $181
  102691:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102696:	e9 e4 f8 ff ff       	jmp    101f7f <__alltraps>

0010269b <vector182>:
.globl vector182
vector182:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $182
  10269d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026a2:	e9 d8 f8 ff ff       	jmp    101f7f <__alltraps>

001026a7 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $183
  1026a9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026ae:	e9 cc f8 ff ff       	jmp    101f7f <__alltraps>

001026b3 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $184
  1026b5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026ba:	e9 c0 f8 ff ff       	jmp    101f7f <__alltraps>

001026bf <vector185>:
.globl vector185
vector185:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $185
  1026c1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026c6:	e9 b4 f8 ff ff       	jmp    101f7f <__alltraps>

001026cb <vector186>:
.globl vector186
vector186:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $186
  1026cd:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026d2:	e9 a8 f8 ff ff       	jmp    101f7f <__alltraps>

001026d7 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $187
  1026d9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026de:	e9 9c f8 ff ff       	jmp    101f7f <__alltraps>

001026e3 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $188
  1026e5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026ea:	e9 90 f8 ff ff       	jmp    101f7f <__alltraps>

001026ef <vector189>:
.globl vector189
vector189:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $189
  1026f1:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026f6:	e9 84 f8 ff ff       	jmp    101f7f <__alltraps>

001026fb <vector190>:
.globl vector190
vector190:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $190
  1026fd:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102702:	e9 78 f8 ff ff       	jmp    101f7f <__alltraps>

00102707 <vector191>:
.globl vector191
vector191:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $191
  102709:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10270e:	e9 6c f8 ff ff       	jmp    101f7f <__alltraps>

00102713 <vector192>:
.globl vector192
vector192:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $192
  102715:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10271a:	e9 60 f8 ff ff       	jmp    101f7f <__alltraps>

0010271f <vector193>:
.globl vector193
vector193:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $193
  102721:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102726:	e9 54 f8 ff ff       	jmp    101f7f <__alltraps>

0010272b <vector194>:
.globl vector194
vector194:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $194
  10272d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102732:	e9 48 f8 ff ff       	jmp    101f7f <__alltraps>

00102737 <vector195>:
.globl vector195
vector195:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $195
  102739:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10273e:	e9 3c f8 ff ff       	jmp    101f7f <__alltraps>

00102743 <vector196>:
.globl vector196
vector196:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $196
  102745:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10274a:	e9 30 f8 ff ff       	jmp    101f7f <__alltraps>

0010274f <vector197>:
.globl vector197
vector197:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $197
  102751:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102756:	e9 24 f8 ff ff       	jmp    101f7f <__alltraps>

0010275b <vector198>:
.globl vector198
vector198:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $198
  10275d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102762:	e9 18 f8 ff ff       	jmp    101f7f <__alltraps>

00102767 <vector199>:
.globl vector199
vector199:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $199
  102769:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10276e:	e9 0c f8 ff ff       	jmp    101f7f <__alltraps>

00102773 <vector200>:
.globl vector200
vector200:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $200
  102775:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10277a:	e9 00 f8 ff ff       	jmp    101f7f <__alltraps>

0010277f <vector201>:
.globl vector201
vector201:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $201
  102781:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102786:	e9 f4 f7 ff ff       	jmp    101f7f <__alltraps>

0010278b <vector202>:
.globl vector202
vector202:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $202
  10278d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102792:	e9 e8 f7 ff ff       	jmp    101f7f <__alltraps>

00102797 <vector203>:
.globl vector203
vector203:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $203
  102799:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10279e:	e9 dc f7 ff ff       	jmp    101f7f <__alltraps>

001027a3 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $204
  1027a5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027aa:	e9 d0 f7 ff ff       	jmp    101f7f <__alltraps>

001027af <vector205>:
.globl vector205
vector205:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $205
  1027b1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027b6:	e9 c4 f7 ff ff       	jmp    101f7f <__alltraps>

001027bb <vector206>:
.globl vector206
vector206:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $206
  1027bd:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027c2:	e9 b8 f7 ff ff       	jmp    101f7f <__alltraps>

001027c7 <vector207>:
.globl vector207
vector207:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $207
  1027c9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027ce:	e9 ac f7 ff ff       	jmp    101f7f <__alltraps>

001027d3 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $208
  1027d5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027da:	e9 a0 f7 ff ff       	jmp    101f7f <__alltraps>

001027df <vector209>:
.globl vector209
vector209:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $209
  1027e1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027e6:	e9 94 f7 ff ff       	jmp    101f7f <__alltraps>

001027eb <vector210>:
.globl vector210
vector210:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $210
  1027ed:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027f2:	e9 88 f7 ff ff       	jmp    101f7f <__alltraps>

001027f7 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $211
  1027f9:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027fe:	e9 7c f7 ff ff       	jmp    101f7f <__alltraps>

00102803 <vector212>:
.globl vector212
vector212:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $212
  102805:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10280a:	e9 70 f7 ff ff       	jmp    101f7f <__alltraps>

0010280f <vector213>:
.globl vector213
vector213:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $213
  102811:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102816:	e9 64 f7 ff ff       	jmp    101f7f <__alltraps>

0010281b <vector214>:
.globl vector214
vector214:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $214
  10281d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102822:	e9 58 f7 ff ff       	jmp    101f7f <__alltraps>

00102827 <vector215>:
.globl vector215
vector215:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $215
  102829:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10282e:	e9 4c f7 ff ff       	jmp    101f7f <__alltraps>

00102833 <vector216>:
.globl vector216
vector216:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $216
  102835:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10283a:	e9 40 f7 ff ff       	jmp    101f7f <__alltraps>

0010283f <vector217>:
.globl vector217
vector217:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $217
  102841:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102846:	e9 34 f7 ff ff       	jmp    101f7f <__alltraps>

0010284b <vector218>:
.globl vector218
vector218:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $218
  10284d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102852:	e9 28 f7 ff ff       	jmp    101f7f <__alltraps>

00102857 <vector219>:
.globl vector219
vector219:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $219
  102859:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10285e:	e9 1c f7 ff ff       	jmp    101f7f <__alltraps>

00102863 <vector220>:
.globl vector220
vector220:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $220
  102865:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10286a:	e9 10 f7 ff ff       	jmp    101f7f <__alltraps>

0010286f <vector221>:
.globl vector221
vector221:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $221
  102871:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102876:	e9 04 f7 ff ff       	jmp    101f7f <__alltraps>

0010287b <vector222>:
.globl vector222
vector222:
  pushl $0
  10287b:	6a 00                	push   $0x0
  pushl $222
  10287d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102882:	e9 f8 f6 ff ff       	jmp    101f7f <__alltraps>

00102887 <vector223>:
.globl vector223
vector223:
  pushl $0
  102887:	6a 00                	push   $0x0
  pushl $223
  102889:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10288e:	e9 ec f6 ff ff       	jmp    101f7f <__alltraps>

00102893 <vector224>:
.globl vector224
vector224:
  pushl $0
  102893:	6a 00                	push   $0x0
  pushl $224
  102895:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10289a:	e9 e0 f6 ff ff       	jmp    101f7f <__alltraps>

0010289f <vector225>:
.globl vector225
vector225:
  pushl $0
  10289f:	6a 00                	push   $0x0
  pushl $225
  1028a1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028a6:	e9 d4 f6 ff ff       	jmp    101f7f <__alltraps>

001028ab <vector226>:
.globl vector226
vector226:
  pushl $0
  1028ab:	6a 00                	push   $0x0
  pushl $226
  1028ad:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028b2:	e9 c8 f6 ff ff       	jmp    101f7f <__alltraps>

001028b7 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028b7:	6a 00                	push   $0x0
  pushl $227
  1028b9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028be:	e9 bc f6 ff ff       	jmp    101f7f <__alltraps>

001028c3 <vector228>:
.globl vector228
vector228:
  pushl $0
  1028c3:	6a 00                	push   $0x0
  pushl $228
  1028c5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028ca:	e9 b0 f6 ff ff       	jmp    101f7f <__alltraps>

001028cf <vector229>:
.globl vector229
vector229:
  pushl $0
  1028cf:	6a 00                	push   $0x0
  pushl $229
  1028d1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028d6:	e9 a4 f6 ff ff       	jmp    101f7f <__alltraps>

001028db <vector230>:
.globl vector230
vector230:
  pushl $0
  1028db:	6a 00                	push   $0x0
  pushl $230
  1028dd:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028e2:	e9 98 f6 ff ff       	jmp    101f7f <__alltraps>

001028e7 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028e7:	6a 00                	push   $0x0
  pushl $231
  1028e9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028ee:	e9 8c f6 ff ff       	jmp    101f7f <__alltraps>

001028f3 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028f3:	6a 00                	push   $0x0
  pushl $232
  1028f5:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028fa:	e9 80 f6 ff ff       	jmp    101f7f <__alltraps>

001028ff <vector233>:
.globl vector233
vector233:
  pushl $0
  1028ff:	6a 00                	push   $0x0
  pushl $233
  102901:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102906:	e9 74 f6 ff ff       	jmp    101f7f <__alltraps>

0010290b <vector234>:
.globl vector234
vector234:
  pushl $0
  10290b:	6a 00                	push   $0x0
  pushl $234
  10290d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102912:	e9 68 f6 ff ff       	jmp    101f7f <__alltraps>

00102917 <vector235>:
.globl vector235
vector235:
  pushl $0
  102917:	6a 00                	push   $0x0
  pushl $235
  102919:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10291e:	e9 5c f6 ff ff       	jmp    101f7f <__alltraps>

00102923 <vector236>:
.globl vector236
vector236:
  pushl $0
  102923:	6a 00                	push   $0x0
  pushl $236
  102925:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10292a:	e9 50 f6 ff ff       	jmp    101f7f <__alltraps>

0010292f <vector237>:
.globl vector237
vector237:
  pushl $0
  10292f:	6a 00                	push   $0x0
  pushl $237
  102931:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102936:	e9 44 f6 ff ff       	jmp    101f7f <__alltraps>

0010293b <vector238>:
.globl vector238
vector238:
  pushl $0
  10293b:	6a 00                	push   $0x0
  pushl $238
  10293d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102942:	e9 38 f6 ff ff       	jmp    101f7f <__alltraps>

00102947 <vector239>:
.globl vector239
vector239:
  pushl $0
  102947:	6a 00                	push   $0x0
  pushl $239
  102949:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10294e:	e9 2c f6 ff ff       	jmp    101f7f <__alltraps>

00102953 <vector240>:
.globl vector240
vector240:
  pushl $0
  102953:	6a 00                	push   $0x0
  pushl $240
  102955:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10295a:	e9 20 f6 ff ff       	jmp    101f7f <__alltraps>

0010295f <vector241>:
.globl vector241
vector241:
  pushl $0
  10295f:	6a 00                	push   $0x0
  pushl $241
  102961:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102966:	e9 14 f6 ff ff       	jmp    101f7f <__alltraps>

0010296b <vector242>:
.globl vector242
vector242:
  pushl $0
  10296b:	6a 00                	push   $0x0
  pushl $242
  10296d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102972:	e9 08 f6 ff ff       	jmp    101f7f <__alltraps>

00102977 <vector243>:
.globl vector243
vector243:
  pushl $0
  102977:	6a 00                	push   $0x0
  pushl $243
  102979:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10297e:	e9 fc f5 ff ff       	jmp    101f7f <__alltraps>

00102983 <vector244>:
.globl vector244
vector244:
  pushl $0
  102983:	6a 00                	push   $0x0
  pushl $244
  102985:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10298a:	e9 f0 f5 ff ff       	jmp    101f7f <__alltraps>

0010298f <vector245>:
.globl vector245
vector245:
  pushl $0
  10298f:	6a 00                	push   $0x0
  pushl $245
  102991:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102996:	e9 e4 f5 ff ff       	jmp    101f7f <__alltraps>

0010299b <vector246>:
.globl vector246
vector246:
  pushl $0
  10299b:	6a 00                	push   $0x0
  pushl $246
  10299d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029a2:	e9 d8 f5 ff ff       	jmp    101f7f <__alltraps>

001029a7 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029a7:	6a 00                	push   $0x0
  pushl $247
  1029a9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029ae:	e9 cc f5 ff ff       	jmp    101f7f <__alltraps>

001029b3 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029b3:	6a 00                	push   $0x0
  pushl $248
  1029b5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029ba:	e9 c0 f5 ff ff       	jmp    101f7f <__alltraps>

001029bf <vector249>:
.globl vector249
vector249:
  pushl $0
  1029bf:	6a 00                	push   $0x0
  pushl $249
  1029c1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029c6:	e9 b4 f5 ff ff       	jmp    101f7f <__alltraps>

001029cb <vector250>:
.globl vector250
vector250:
  pushl $0
  1029cb:	6a 00                	push   $0x0
  pushl $250
  1029cd:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029d2:	e9 a8 f5 ff ff       	jmp    101f7f <__alltraps>

001029d7 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029d7:	6a 00                	push   $0x0
  pushl $251
  1029d9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029de:	e9 9c f5 ff ff       	jmp    101f7f <__alltraps>

001029e3 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029e3:	6a 00                	push   $0x0
  pushl $252
  1029e5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029ea:	e9 90 f5 ff ff       	jmp    101f7f <__alltraps>

001029ef <vector253>:
.globl vector253
vector253:
  pushl $0
  1029ef:	6a 00                	push   $0x0
  pushl $253
  1029f1:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029f6:	e9 84 f5 ff ff       	jmp    101f7f <__alltraps>

001029fb <vector254>:
.globl vector254
vector254:
  pushl $0
  1029fb:	6a 00                	push   $0x0
  pushl $254
  1029fd:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a02:	e9 78 f5 ff ff       	jmp    101f7f <__alltraps>

00102a07 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a07:	6a 00                	push   $0x0
  pushl $255
  102a09:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a0e:	e9 6c f5 ff ff       	jmp    101f7f <__alltraps>

00102a13 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a13:	55                   	push   %ebp
  102a14:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a16:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1f:	29 d0                	sub    %edx,%eax
  102a21:	c1 f8 02             	sar    $0x2,%eax
  102a24:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a2a:	5d                   	pop    %ebp
  102a2b:	c3                   	ret    

00102a2c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a2c:	55                   	push   %ebp
  102a2d:	89 e5                	mov    %esp,%ebp
  102a2f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a32:	8b 45 08             	mov    0x8(%ebp),%eax
  102a35:	89 04 24             	mov    %eax,(%esp)
  102a38:	e8 d6 ff ff ff       	call   102a13 <page2ppn>
  102a3d:	c1 e0 0c             	shl    $0xc,%eax
}
  102a40:	89 ec                	mov    %ebp,%esp
  102a42:	5d                   	pop    %ebp
  102a43:	c3                   	ret    

00102a44 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102a44:	55                   	push   %ebp
  102a45:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a47:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4a:	8b 00                	mov    (%eax),%eax
}
  102a4c:	5d                   	pop    %ebp
  102a4d:	c3                   	ret    

00102a4e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a4e:	55                   	push   %ebp
  102a4f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a51:	8b 45 08             	mov    0x8(%ebp),%eax
  102a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a57:	89 10                	mov    %edx,(%eax)
}
  102a59:	90                   	nop
  102a5a:	5d                   	pop    %ebp
  102a5b:	c3                   	ret    

00102a5c <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
  102a5c:	55                   	push   %ebp
  102a5d:	89 e5                	mov    %esp,%ebp
  102a5f:	83 ec 10             	sub    $0x10,%esp
  102a62:	c7 45 fc 80 be 11 00 	movl   $0x11be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102a6f:	89 50 04             	mov    %edx,0x4(%eax)
  102a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a75:	8b 50 04             	mov    0x4(%eax),%edx
  102a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a7b:	89 10                	mov    %edx,(%eax)
}
  102a7d:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  102a7e:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102a85:	00 00 00 
}
  102a88:	90                   	nop
  102a89:	89 ec                	mov    %ebp,%esp
  102a8b:	5d                   	pop    %ebp
  102a8c:	c3                   	ret    

00102a8d <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
  102a8d:	55                   	push   %ebp
  102a8e:	89 e5                	mov    %esp,%ebp
  102a90:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a97:	75 24                	jne    102abd <default_init_memmap+0x30>
  102a99:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  102aa0:	00 
  102aa1:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102aa8:	00 
  102aa9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102ab0:	00 
  102ab1:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102ab8:	e8 3b e2 ff ff       	call   100cf8 <__panic>
    struct Page *p = base;
  102abd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102ac3:	eb 7b                	jmp    102b40 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
  102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac8:	83 c0 04             	add    $0x4,%eax
  102acb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102adb:	0f a3 10             	bt     %edx,(%eax)
  102ade:	19 c0                	sbb    %eax,%eax
  102ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102ae3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ae7:	0f 95 c0             	setne  %al
  102aea:	0f b6 c0             	movzbl %al,%eax
  102aed:	85 c0                	test   %eax,%eax
  102aef:	75 24                	jne    102b15 <default_init_memmap+0x88>
  102af1:	c7 44 24 0c 21 67 10 	movl   $0x106721,0xc(%esp)
  102af8:	00 
  102af9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102b00:	00 
  102b01:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102b08:	00 
  102b09:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102b10:	e8 e3 e1 ff ff       	call   100cf8 <__panic>
        p->flags = 0;
  102b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
  102b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
  102b29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b30:	00 
  102b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b34:	89 04 24             	mov    %eax,(%esp)
  102b37:	e8 12 ff ff ff       	call   102a4e <set_page_ref>
    for (; p != base + n; p++)
  102b3c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b43:	89 d0                	mov    %edx,%eax
  102b45:	c1 e0 02             	shl    $0x2,%eax
  102b48:	01 d0                	add    %edx,%eax
  102b4a:	c1 e0 02             	shl    $0x2,%eax
  102b4d:	89 c2                	mov    %eax,%edx
  102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b52:	01 d0                	add    %edx,%eax
  102b54:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102b57:	0f 85 68 ff ff ff    	jne    102ac5 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
  102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b60:	83 c0 04             	add    $0x4,%eax
  102b63:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b70:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b73:	0f ab 10             	bts    %edx,(%eax)
}
  102b76:	90                   	nop
    base->property = n;
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b7d:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102b80:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b89:	01 d0                	add    %edx,%eax
  102b8b:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
  102b90:	8b 45 08             	mov    0x8(%ebp),%eax
  102b93:	83 c0 0c             	add    $0xc,%eax
  102b96:	c7 45 e4 80 be 11 00 	movl   $0x11be80,-0x1c(%ebp)
  102b9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ba3:	8b 00                	mov    (%eax),%eax
  102ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102ba8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102bab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102bba:	89 10                	mov    %edx,(%eax)
  102bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bbf:	8b 10                	mov    (%eax),%edx
  102bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bc4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102bcd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bd3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bd6:	89 10                	mov    %edx,(%eax)
}
  102bd8:	90                   	nop
}
  102bd9:	90                   	nop
}
  102bda:	90                   	nop
  102bdb:	89 ec                	mov    %ebp,%esp
  102bdd:	5d                   	pop    %ebp
  102bde:	c3                   	ret    

00102bdf <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  102bdf:	55                   	push   %ebp
  102be0:	89 e5                	mov    %esp,%ebp
  102be2:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102be9:	75 24                	jne    102c0f <default_alloc_pages+0x30>
  102beb:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  102bf2:	00 
  102bf3:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102bfa:	00 
  102bfb:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  102c02:	00 
  102c03:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102c0a:	e8 e9 e0 ff ff       	call   100cf8 <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
  102c0f:	a1 88 be 11 00       	mov    0x11be88,%eax
  102c14:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c17:	76 0a                	jbe    102c23 <default_alloc_pages+0x44>
    {
        return NULL;
  102c19:	b8 00 00 00 00       	mov    $0x0,%eax
  102c1e:	e9 43 01 00 00       	jmp    102d66 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  102c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102c2a:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  102c31:	eb 1c                	jmp    102c4f <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
  102c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c36:	83 e8 0c             	sub    $0xc,%eax
  102c39:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  102c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c3f:	8b 40 08             	mov    0x8(%eax),%eax
  102c42:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c45:	77 08                	ja     102c4f <default_alloc_pages+0x70>
        {
            page = p;
  102c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102c4d:	eb 18                	jmp    102c67 <default_alloc_pages+0x88>
  102c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c58:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c5e:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102c65:	75 cc                	jne    102c33 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
  102c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c6b:	0f 84 f2 00 00 00    	je     102d63 <default_alloc_pages+0x184>
    {
        if (page->property > n)
  102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c74:	8b 40 08             	mov    0x8(%eax),%eax
  102c77:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c7a:	0f 83 8f 00 00 00    	jae    102d0f <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
  102c80:	8b 55 08             	mov    0x8(%ebp),%edx
  102c83:	89 d0                	mov    %edx,%eax
  102c85:	c1 e0 02             	shl    $0x2,%eax
  102c88:	01 d0                	add    %edx,%eax
  102c8a:	c1 e0 02             	shl    $0x2,%eax
  102c8d:	89 c2                	mov    %eax,%edx
  102c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c92:	01 d0                	add    %edx,%eax
  102c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9a:	8b 40 08             	mov    0x8(%eax),%eax
  102c9d:	2b 45 08             	sub    0x8(%ebp),%eax
  102ca0:	89 c2                	mov    %eax,%edx
  102ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ca5:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  102ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cab:	83 c0 0c             	add    $0xc,%eax
  102cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb1:	83 c2 0c             	add    $0xc,%edx
  102cb4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102cb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  102cba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102cbd:	8b 40 04             	mov    0x4(%eax),%eax
  102cc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cc3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102cc6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cc9:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102ccc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  102ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cd2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cd5:	89 10                	mov    %edx,(%eax)
  102cd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cda:	8b 10                	mov    (%eax),%edx
  102cdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cdf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ce5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ce8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ceb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102cf1:	89 10                	mov    %edx,(%eax)
}
  102cf3:	90                   	nop
}
  102cf4:	90                   	nop
            SetPageProperty(p);
  102cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cf8:	83 c0 04             	add    $0x4,%eax
  102cfb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102d02:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102d0b:	0f ab 10             	bts    %edx,(%eax)
}
  102d0e:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
  102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d12:	83 c0 0c             	add    $0xc,%eax
  102d15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  102d18:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d1b:	8b 40 04             	mov    0x4(%eax),%eax
  102d1e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d21:	8b 12                	mov    (%edx),%edx
  102d23:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d2c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d2f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d35:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d38:	89 10                	mov    %edx,(%eax)
}
  102d3a:	90                   	nop
}
  102d3b:	90                   	nop
        nr_free -= n;
  102d3c:	a1 88 be 11 00       	mov    0x11be88,%eax
  102d41:	2b 45 08             	sub    0x8(%ebp),%eax
  102d44:	a3 88 be 11 00       	mov    %eax,0x11be88
        ClearPageProperty(page);
  102d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d4c:	83 c0 04             	add    $0x4,%eax
  102d4f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d5c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d5f:	0f b3 10             	btr    %edx,(%eax)
}
  102d62:	90                   	nop
    }
    return page;
  102d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d66:	89 ec                	mov    %ebp,%esp
  102d68:	5d                   	pop    %ebp
  102d69:	c3                   	ret    

00102d6a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  102d6a:	55                   	push   %ebp
  102d6b:	89 e5                	mov    %esp,%ebp
  102d6d:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  102d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d77:	75 24                	jne    102d9d <default_free_pages+0x33>
  102d79:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  102d80:	00 
  102d81:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102d88:	00 
  102d89:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  102d90:	00 
  102d91:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102d98:	e8 5b df ff ff       	call   100cf8 <__panic>
    struct Page *p = base;
  102d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  102da3:	e9 9d 00 00 00       	jmp    102e45 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dab:	83 c0 04             	add    $0x4,%eax
  102dae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102db5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102dbe:	0f a3 10             	bt     %edx,(%eax)
  102dc1:	19 c0                	sbb    %eax,%eax
  102dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dca:	0f 95 c0             	setne  %al
  102dcd:	0f b6 c0             	movzbl %al,%eax
  102dd0:	85 c0                	test   %eax,%eax
  102dd2:	75 2c                	jne    102e00 <default_free_pages+0x96>
  102dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd7:	83 c0 04             	add    $0x4,%eax
  102dda:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102de1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102dea:	0f a3 10             	bt     %edx,(%eax)
  102ded:	19 c0                	sbb    %eax,%eax
  102def:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102df2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102df6:	0f 95 c0             	setne  %al
  102df9:	0f b6 c0             	movzbl %al,%eax
  102dfc:	85 c0                	test   %eax,%eax
  102dfe:	74 24                	je     102e24 <default_free_pages+0xba>
  102e00:	c7 44 24 0c 34 67 10 	movl   $0x106734,0xc(%esp)
  102e07:	00 
  102e08:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  102e0f:	00 
  102e10:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102e17:	00 
  102e18:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  102e1f:	e8 d4 de ff ff       	call   100cf8 <__panic>
        p->flags = 0;
  102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e35:	00 
  102e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e39:	89 04 24             	mov    %eax,(%esp)
  102e3c:	e8 0d fc ff ff       	call   102a4e <set_page_ref>
    for (; p != base + n; p++)
  102e41:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e48:	89 d0                	mov    %edx,%eax
  102e4a:	c1 e0 02             	shl    $0x2,%eax
  102e4d:	01 d0                	add    %edx,%eax
  102e4f:	c1 e0 02             	shl    $0x2,%eax
  102e52:	89 c2                	mov    %eax,%edx
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	01 d0                	add    %edx,%eax
  102e59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e5c:	0f 85 46 ff ff ff    	jne    102da8 <default_free_pages+0x3e>
    }
    base->property = n;
  102e62:	8b 45 08             	mov    0x8(%ebp),%eax
  102e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e68:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6e:	83 c0 04             	add    $0x4,%eax
  102e71:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102e78:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102e7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e81:	0f ab 10             	bts    %edx,(%eax)
}
  102e84:	90                   	nop
  102e85:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
    return listelm->next;
  102e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102e8f:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
  102e95:	e9 0e 01 00 00       	jmp    102fa8 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
  102e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e9d:	83 e8 0c             	sub    $0xc,%eax
  102ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ea9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102eac:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb5:	8b 50 08             	mov    0x8(%eax),%edx
  102eb8:	89 d0                	mov    %edx,%eax
  102eba:	c1 e0 02             	shl    $0x2,%eax
  102ebd:	01 d0                	add    %edx,%eax
  102ebf:	c1 e0 02             	shl    $0x2,%eax
  102ec2:	89 c2                	mov    %eax,%edx
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	01 d0                	add    %edx,%eax
  102ec9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ecc:	75 5d                	jne    102f2b <default_free_pages+0x1c1>
        {
            base->property += p->property;
  102ece:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed1:	8b 50 08             	mov    0x8(%eax),%edx
  102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed7:	8b 40 08             	mov    0x8(%eax),%eax
  102eda:	01 c2                	add    %eax,%edx
  102edc:	8b 45 08             	mov    0x8(%ebp),%eax
  102edf:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee5:	83 c0 04             	add    $0x4,%eax
  102ee8:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102eef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ef2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ef5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102ef8:	0f b3 10             	btr    %edx,(%eax)
}
  102efb:	90                   	nop
            list_del(&(p->page_link));
  102efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eff:	83 c0 0c             	add    $0xc,%eax
  102f02:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f08:	8b 40 04             	mov    0x4(%eax),%eax
  102f0b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102f0e:	8b 12                	mov    (%edx),%edx
  102f10:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102f13:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  102f16:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102f19:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102f1c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102f22:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102f25:	89 10                	mov    %edx,(%eax)
}
  102f27:	90                   	nop
}
  102f28:	90                   	nop
  102f29:	eb 7d                	jmp    102fa8 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
  102f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2e:	8b 50 08             	mov    0x8(%eax),%edx
  102f31:	89 d0                	mov    %edx,%eax
  102f33:	c1 e0 02             	shl    $0x2,%eax
  102f36:	01 d0                	add    %edx,%eax
  102f38:	c1 e0 02             	shl    $0x2,%eax
  102f3b:	89 c2                	mov    %eax,%edx
  102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f40:	01 d0                	add    %edx,%eax
  102f42:	39 45 08             	cmp    %eax,0x8(%ebp)
  102f45:	75 61                	jne    102fa8 <default_free_pages+0x23e>
        {
            p->property += base->property;
  102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f4a:	8b 50 08             	mov    0x8(%eax),%edx
  102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f50:	8b 40 08             	mov    0x8(%eax),%eax
  102f53:	01 c2                	add    %eax,%edx
  102f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f58:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5e:	83 c0 04             	add    $0x4,%eax
  102f61:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102f68:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f6b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f6e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f71:	0f b3 10             	btr    %edx,(%eax)
}
  102f74:	90                   	nop
            base = p;
  102f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f78:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f7e:	83 c0 0c             	add    $0xc,%eax
  102f81:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f87:	8b 40 04             	mov    0x4(%eax),%eax
  102f8a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102f8d:	8b 12                	mov    (%edx),%edx
  102f8f:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102f92:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102f95:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f98:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f9b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102fa1:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102fa4:	89 10                	mov    %edx,(%eax)
}
  102fa6:	90                   	nop
}
  102fa7:	90                   	nop
    while (le != &free_list)
  102fa8:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102faf:	0f 85 e5 fe ff ff    	jne    102e9a <default_free_pages+0x130>
        }
    }
    le = &free_list;
  102fb5:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
  102fbc:	eb 25                	jmp    102fe3 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
  102fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc1:	83 e8 0c             	sub    $0xc,%eax
  102fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
  102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fca:	8b 50 08             	mov    0x8(%eax),%edx
  102fcd:	89 d0                	mov    %edx,%eax
  102fcf:	c1 e0 02             	shl    $0x2,%eax
  102fd2:	01 d0                	add    %edx,%eax
  102fd4:	c1 e0 02             	shl    $0x2,%eax
  102fd7:	89 c2                	mov    %eax,%edx
  102fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdc:	01 d0                	add    %edx,%eax
  102fde:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102fe1:	73 1a                	jae    102ffd <default_free_pages+0x293>
  102fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fe6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  102fe9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102fec:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  102fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff2:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102ff9:	75 c3                	jne    102fbe <default_free_pages+0x254>
  102ffb:	eb 01                	jmp    102ffe <default_free_pages+0x294>
        {
            break;
  102ffd:	90                   	nop
        }
    }
    nr_free += n;
  102ffe:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  103004:	8b 45 0c             	mov    0xc(%ebp),%eax
  103007:	01 d0                	add    %edx,%eax
  103009:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add_before(le, &(base->page_link));
  10300e:	8b 45 08             	mov    0x8(%ebp),%eax
  103011:	8d 50 0c             	lea    0xc(%eax),%edx
  103014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103017:	89 45 98             	mov    %eax,-0x68(%ebp)
  10301a:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  10301d:	8b 45 98             	mov    -0x68(%ebp),%eax
  103020:	8b 00                	mov    (%eax),%eax
  103022:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103025:	89 55 90             	mov    %edx,-0x70(%ebp)
  103028:	89 45 8c             	mov    %eax,-0x74(%ebp)
  10302b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10302e:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
  103031:	8b 45 88             	mov    -0x78(%ebp),%eax
  103034:	8b 55 90             	mov    -0x70(%ebp),%edx
  103037:	89 10                	mov    %edx,(%eax)
  103039:	8b 45 88             	mov    -0x78(%ebp),%eax
  10303c:	8b 10                	mov    (%eax),%edx
  10303e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103041:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103044:	8b 45 90             	mov    -0x70(%ebp),%eax
  103047:	8b 55 88             	mov    -0x78(%ebp),%edx
  10304a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10304d:	8b 45 90             	mov    -0x70(%ebp),%eax
  103050:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103053:	89 10                	mov    %edx,(%eax)
}
  103055:	90                   	nop
}
  103056:	90                   	nop
}
  103057:	90                   	nop
  103058:	89 ec                	mov    %ebp,%esp
  10305a:	5d                   	pop    %ebp
  10305b:	c3                   	ret    

0010305c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  10305c:	55                   	push   %ebp
  10305d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10305f:	a1 88 be 11 00       	mov    0x11be88,%eax
}
  103064:	5d                   	pop    %ebp
  103065:	c3                   	ret    

00103066 <basic_check>:

static void
basic_check(void)
{
  103066:	55                   	push   %ebp
  103067:	89 e5                	mov    %esp,%ebp
  103069:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10306c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103076:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10307f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103086:	e8 df 0e 00 00       	call   103f6a <alloc_pages>
  10308b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10308e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103092:	75 24                	jne    1030b8 <basic_check+0x52>
  103094:	c7 44 24 0c 59 67 10 	movl   $0x106759,0xc(%esp)
  10309b:	00 
  10309c:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1030a3:	00 
  1030a4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1030ab:	00 
  1030ac:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1030b3:	e8 40 dc ff ff       	call   100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030bf:	e8 a6 0e 00 00       	call   103f6a <alloc_pages>
  1030c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030cb:	75 24                	jne    1030f1 <basic_check+0x8b>
  1030cd:	c7 44 24 0c 75 67 10 	movl   $0x106775,0xc(%esp)
  1030d4:	00 
  1030d5:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1030dc:	00 
  1030dd:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1030e4:	00 
  1030e5:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1030ec:	e8 07 dc ff ff       	call   100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030f8:	e8 6d 0e 00 00       	call   103f6a <alloc_pages>
  1030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103104:	75 24                	jne    10312a <basic_check+0xc4>
  103106:	c7 44 24 0c 91 67 10 	movl   $0x106791,0xc(%esp)
  10310d:	00 
  10310e:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103115:	00 
  103116:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10311d:	00 
  10311e:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103125:	e8 ce db ff ff       	call   100cf8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10312d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103130:	74 10                	je     103142 <basic_check+0xdc>
  103132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103135:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103138:	74 08                	je     103142 <basic_check+0xdc>
  10313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103140:	75 24                	jne    103166 <basic_check+0x100>
  103142:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  103149:	00 
  10314a:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103151:	00 
  103152:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103159:	00 
  10315a:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103161:	e8 92 db ff ff       	call   100cf8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103169:	89 04 24             	mov    %eax,(%esp)
  10316c:	e8 d3 f8 ff ff       	call   102a44 <page_ref>
  103171:	85 c0                	test   %eax,%eax
  103173:	75 1e                	jne    103193 <basic_check+0x12d>
  103175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103178:	89 04 24             	mov    %eax,(%esp)
  10317b:	e8 c4 f8 ff ff       	call   102a44 <page_ref>
  103180:	85 c0                	test   %eax,%eax
  103182:	75 0f                	jne    103193 <basic_check+0x12d>
  103184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103187:	89 04 24             	mov    %eax,(%esp)
  10318a:	e8 b5 f8 ff ff       	call   102a44 <page_ref>
  10318f:	85 c0                	test   %eax,%eax
  103191:	74 24                	je     1031b7 <basic_check+0x151>
  103193:	c7 44 24 0c d4 67 10 	movl   $0x1067d4,0xc(%esp)
  10319a:	00 
  10319b:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1031a2:	00 
  1031a3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  1031aa:	00 
  1031ab:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1031b2:	e8 41 db ff ff       	call   100cf8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1031b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031ba:	89 04 24             	mov    %eax,(%esp)
  1031bd:	e8 6a f8 ff ff       	call   102a2c <page2pa>
  1031c2:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1031c8:	c1 e2 0c             	shl    $0xc,%edx
  1031cb:	39 d0                	cmp    %edx,%eax
  1031cd:	72 24                	jb     1031f3 <basic_check+0x18d>
  1031cf:	c7 44 24 0c 10 68 10 	movl   $0x106810,0xc(%esp)
  1031d6:	00 
  1031d7:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1031de:	00 
  1031df:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1031e6:	00 
  1031e7:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1031ee:	e8 05 db ff ff       	call   100cf8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f6:	89 04 24             	mov    %eax,(%esp)
  1031f9:	e8 2e f8 ff ff       	call   102a2c <page2pa>
  1031fe:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  103204:	c1 e2 0c             	shl    $0xc,%edx
  103207:	39 d0                	cmp    %edx,%eax
  103209:	72 24                	jb     10322f <basic_check+0x1c9>
  10320b:	c7 44 24 0c 2d 68 10 	movl   $0x10682d,0xc(%esp)
  103212:	00 
  103213:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10321a:	00 
  10321b:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103222:	00 
  103223:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10322a:	e8 c9 da ff ff       	call   100cf8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103232:	89 04 24             	mov    %eax,(%esp)
  103235:	e8 f2 f7 ff ff       	call   102a2c <page2pa>
  10323a:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  103240:	c1 e2 0c             	shl    $0xc,%edx
  103243:	39 d0                	cmp    %edx,%eax
  103245:	72 24                	jb     10326b <basic_check+0x205>
  103247:	c7 44 24 0c 4a 68 10 	movl   $0x10684a,0xc(%esp)
  10324e:	00 
  10324f:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103256:	00 
  103257:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  10325e:	00 
  10325f:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103266:	e8 8d da ff ff       	call   100cf8 <__panic>

    list_entry_t free_list_store = free_list;
  10326b:	a1 80 be 11 00       	mov    0x11be80,%eax
  103270:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103276:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103279:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10327c:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103283:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103286:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103289:	89 50 04             	mov    %edx,0x4(%eax)
  10328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10328f:	8b 50 04             	mov    0x4(%eax),%edx
  103292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103295:	89 10                	mov    %edx,(%eax)
}
  103297:	90                   	nop
  103298:	c7 45 e0 80 be 11 00 	movl   $0x11be80,-0x20(%ebp)
    return list->next == list;
  10329f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032a2:	8b 40 04             	mov    0x4(%eax),%eax
  1032a5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1032a8:	0f 94 c0             	sete   %al
  1032ab:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032ae:	85 c0                	test   %eax,%eax
  1032b0:	75 24                	jne    1032d6 <basic_check+0x270>
  1032b2:	c7 44 24 0c 67 68 10 	movl   $0x106867,0xc(%esp)
  1032b9:	00 
  1032ba:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1032c1:	00 
  1032c2:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1032c9:	00 
  1032ca:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1032d1:	e8 22 da ff ff       	call   100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
  1032d6:	a1 88 be 11 00       	mov    0x11be88,%eax
  1032db:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032de:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1032e5:	00 00 00 

    assert(alloc_page() == NULL);
  1032e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032ef:	e8 76 0c 00 00       	call   103f6a <alloc_pages>
  1032f4:	85 c0                	test   %eax,%eax
  1032f6:	74 24                	je     10331c <basic_check+0x2b6>
  1032f8:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1032ff:	00 
  103300:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103307:	00 
  103308:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  10330f:	00 
  103310:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103317:	e8 dc d9 ff ff       	call   100cf8 <__panic>

    free_page(p0);
  10331c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103323:	00 
  103324:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103327:	89 04 24             	mov    %eax,(%esp)
  10332a:	e8 75 0c 00 00       	call   103fa4 <free_pages>
    free_page(p1);
  10332f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103336:	00 
  103337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333a:	89 04 24             	mov    %eax,(%esp)
  10333d:	e8 62 0c 00 00       	call   103fa4 <free_pages>
    free_page(p2);
  103342:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103349:	00 
  10334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10334d:	89 04 24             	mov    %eax,(%esp)
  103350:	e8 4f 0c 00 00       	call   103fa4 <free_pages>
    assert(nr_free == 3);
  103355:	a1 88 be 11 00       	mov    0x11be88,%eax
  10335a:	83 f8 03             	cmp    $0x3,%eax
  10335d:	74 24                	je     103383 <basic_check+0x31d>
  10335f:	c7 44 24 0c 93 68 10 	movl   $0x106893,0xc(%esp)
  103366:	00 
  103367:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10336e:	00 
  10336f:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103376:	00 
  103377:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10337e:	e8 75 d9 ff ff       	call   100cf8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10338a:	e8 db 0b 00 00       	call   103f6a <alloc_pages>
  10338f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103392:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103396:	75 24                	jne    1033bc <basic_check+0x356>
  103398:	c7 44 24 0c 59 67 10 	movl   $0x106759,0xc(%esp)
  10339f:	00 
  1033a0:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1033a7:	00 
  1033a8:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1033af:	00 
  1033b0:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1033b7:	e8 3c d9 ff ff       	call   100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c3:	e8 a2 0b 00 00       	call   103f6a <alloc_pages>
  1033c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033cf:	75 24                	jne    1033f5 <basic_check+0x38f>
  1033d1:	c7 44 24 0c 75 67 10 	movl   $0x106775,0xc(%esp)
  1033d8:	00 
  1033d9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1033e0:	00 
  1033e1:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1033e8:	00 
  1033e9:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1033f0:	e8 03 d9 ff ff       	call   100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033fc:	e8 69 0b 00 00       	call   103f6a <alloc_pages>
  103401:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103408:	75 24                	jne    10342e <basic_check+0x3c8>
  10340a:	c7 44 24 0c 91 67 10 	movl   $0x106791,0xc(%esp)
  103411:	00 
  103412:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103419:	00 
  10341a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103421:	00 
  103422:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103429:	e8 ca d8 ff ff       	call   100cf8 <__panic>

    assert(alloc_page() == NULL);
  10342e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103435:	e8 30 0b 00 00       	call   103f6a <alloc_pages>
  10343a:	85 c0                	test   %eax,%eax
  10343c:	74 24                	je     103462 <basic_check+0x3fc>
  10343e:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103445:	00 
  103446:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10344d:	00 
  10344e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  103455:	00 
  103456:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10345d:	e8 96 d8 ff ff       	call   100cf8 <__panic>

    free_page(p0);
  103462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103469:	00 
  10346a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10346d:	89 04 24             	mov    %eax,(%esp)
  103470:	e8 2f 0b 00 00       	call   103fa4 <free_pages>
  103475:	c7 45 d8 80 be 11 00 	movl   $0x11be80,-0x28(%ebp)
  10347c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10347f:	8b 40 04             	mov    0x4(%eax),%eax
  103482:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103485:	0f 94 c0             	sete   %al
  103488:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10348b:	85 c0                	test   %eax,%eax
  10348d:	74 24                	je     1034b3 <basic_check+0x44d>
  10348f:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  103496:	00 
  103497:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10349e:	00 
  10349f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1034a6:	00 
  1034a7:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1034ae:	e8 45 d8 ff ff       	call   100cf8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034ba:	e8 ab 0a 00 00       	call   103f6a <alloc_pages>
  1034bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034c8:	74 24                	je     1034ee <basic_check+0x488>
  1034ca:	c7 44 24 0c b8 68 10 	movl   $0x1068b8,0xc(%esp)
  1034d1:	00 
  1034d2:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1034d9:	00 
  1034da:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1034e1:	00 
  1034e2:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1034e9:	e8 0a d8 ff ff       	call   100cf8 <__panic>
    assert(alloc_page() == NULL);
  1034ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034f5:	e8 70 0a 00 00       	call   103f6a <alloc_pages>
  1034fa:	85 c0                	test   %eax,%eax
  1034fc:	74 24                	je     103522 <basic_check+0x4bc>
  1034fe:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103505:	00 
  103506:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10350d:	00 
  10350e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  103515:	00 
  103516:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10351d:	e8 d6 d7 ff ff       	call   100cf8 <__panic>

    assert(nr_free == 0);
  103522:	a1 88 be 11 00       	mov    0x11be88,%eax
  103527:	85 c0                	test   %eax,%eax
  103529:	74 24                	je     10354f <basic_check+0x4e9>
  10352b:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  103532:	00 
  103533:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10353a:	00 
  10353b:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103542:	00 
  103543:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10354a:	e8 a9 d7 ff ff       	call   100cf8 <__panic>
    free_list = free_list_store;
  10354f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103552:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103555:	a3 80 be 11 00       	mov    %eax,0x11be80
  10355a:	89 15 84 be 11 00    	mov    %edx,0x11be84
    nr_free = nr_free_store;
  103560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103563:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_page(p);
  103568:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10356f:	00 
  103570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103573:	89 04 24             	mov    %eax,(%esp)
  103576:	e8 29 0a 00 00       	call   103fa4 <free_pages>
    free_page(p1);
  10357b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103582:	00 
  103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103586:	89 04 24             	mov    %eax,(%esp)
  103589:	e8 16 0a 00 00       	call   103fa4 <free_pages>
    free_page(p2);
  10358e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103595:	00 
  103596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103599:	89 04 24             	mov    %eax,(%esp)
  10359c:	e8 03 0a 00 00       	call   103fa4 <free_pages>
}
  1035a1:	90                   	nop
  1035a2:	89 ec                	mov    %ebp,%esp
  1035a4:	5d                   	pop    %ebp
  1035a5:	c3                   	ret    

001035a6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  1035a6:	55                   	push   %ebp
  1035a7:	89 e5                	mov    %esp,%ebp
  1035a9:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1035af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035bd:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  1035c4:	eb 6a                	jmp    103630 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
  1035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c9:	83 e8 0c             	sub    $0xc,%eax
  1035cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1035cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035d2:	83 c0 04             	add    $0x4,%eax
  1035d5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1035dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035e5:	0f a3 10             	bt     %edx,(%eax)
  1035e8:	19 c0                	sbb    %eax,%eax
  1035ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035f1:	0f 95 c0             	setne  %al
  1035f4:	0f b6 c0             	movzbl %al,%eax
  1035f7:	85 c0                	test   %eax,%eax
  1035f9:	75 24                	jne    10361f <default_check+0x79>
  1035fb:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  103602:	00 
  103603:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10360a:	00 
  10360b:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103612:	00 
  103613:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10361a:	e8 d9 d6 ff ff       	call   100cf8 <__panic>
        count++, total += p->property;
  10361f:	ff 45 f4             	incl   -0xc(%ebp)
  103622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103625:	8b 50 08             	mov    0x8(%eax),%edx
  103628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10362b:	01 d0                	add    %edx,%eax
  10362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103633:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103636:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103639:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  10363c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10363f:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103646:	0f 85 7a ff ff ff    	jne    1035c6 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10364c:	e8 88 09 00 00       	call   103fd9 <nr_free_pages>
  103651:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103654:	39 d0                	cmp    %edx,%eax
  103656:	74 24                	je     10367c <default_check+0xd6>
  103658:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  10365f:	00 
  103660:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103667:	00 
  103668:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  10366f:	00 
  103670:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103677:	e8 7c d6 ff ff       	call   100cf8 <__panic>

    basic_check();
  10367c:	e8 e5 f9 ff ff       	call   103066 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103681:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103688:	e8 dd 08 00 00       	call   103f6a <alloc_pages>
  10368d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103690:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103694:	75 24                	jne    1036ba <default_check+0x114>
  103696:	c7 44 24 0c 07 69 10 	movl   $0x106907,0xc(%esp)
  10369d:	00 
  10369e:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1036a5:	00 
  1036a6:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1036ad:	00 
  1036ae:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1036b5:	e8 3e d6 ff ff       	call   100cf8 <__panic>
    assert(!PageProperty(p0));
  1036ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036bd:	83 c0 04             	add    $0x4,%eax
  1036c0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1036c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1036cd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1036d0:	0f a3 10             	bt     %edx,(%eax)
  1036d3:	19 c0                	sbb    %eax,%eax
  1036d5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1036d8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1036dc:	0f 95 c0             	setne  %al
  1036df:	0f b6 c0             	movzbl %al,%eax
  1036e2:	85 c0                	test   %eax,%eax
  1036e4:	74 24                	je     10370a <default_check+0x164>
  1036e6:	c7 44 24 0c 12 69 10 	movl   $0x106912,0xc(%esp)
  1036ed:	00 
  1036ee:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1036f5:	00 
  1036f6:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1036fd:	00 
  1036fe:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103705:	e8 ee d5 ff ff       	call   100cf8 <__panic>

    list_entry_t free_list_store = free_list;
  10370a:	a1 80 be 11 00       	mov    0x11be80,%eax
  10370f:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103715:	89 45 80             	mov    %eax,-0x80(%ebp)
  103718:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10371b:	c7 45 b0 80 be 11 00 	movl   $0x11be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  103722:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103725:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103728:	89 50 04             	mov    %edx,0x4(%eax)
  10372b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10372e:	8b 50 04             	mov    0x4(%eax),%edx
  103731:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103734:	89 10                	mov    %edx,(%eax)
}
  103736:	90                   	nop
  103737:	c7 45 b4 80 be 11 00 	movl   $0x11be80,-0x4c(%ebp)
    return list->next == list;
  10373e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103741:	8b 40 04             	mov    0x4(%eax),%eax
  103744:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103747:	0f 94 c0             	sete   %al
  10374a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10374d:	85 c0                	test   %eax,%eax
  10374f:	75 24                	jne    103775 <default_check+0x1cf>
  103751:	c7 44 24 0c 67 68 10 	movl   $0x106867,0xc(%esp)
  103758:	00 
  103759:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103760:	00 
  103761:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103768:	00 
  103769:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103770:	e8 83 d5 ff ff       	call   100cf8 <__panic>
    assert(alloc_page() == NULL);
  103775:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10377c:	e8 e9 07 00 00       	call   103f6a <alloc_pages>
  103781:	85 c0                	test   %eax,%eax
  103783:	74 24                	je     1037a9 <default_check+0x203>
  103785:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  10378c:	00 
  10378d:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103794:	00 
  103795:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  10379c:	00 
  10379d:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1037a4:	e8 4f d5 ff ff       	call   100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
  1037a9:	a1 88 be 11 00       	mov    0x11be88,%eax
  1037ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1037b1:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1037b8:	00 00 00 

    free_pages(p0 + 2, 3);
  1037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037be:	83 c0 28             	add    $0x28,%eax
  1037c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1037c8:	00 
  1037c9:	89 04 24             	mov    %eax,(%esp)
  1037cc:	e8 d3 07 00 00       	call   103fa4 <free_pages>
    assert(alloc_pages(4) == NULL);
  1037d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1037d8:	e8 8d 07 00 00       	call   103f6a <alloc_pages>
  1037dd:	85 c0                	test   %eax,%eax
  1037df:	74 24                	je     103805 <default_check+0x25f>
  1037e1:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  1037e8:	00 
  1037e9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1037f8:	00 
  1037f9:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103800:	e8 f3 d4 ff ff       	call   100cf8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103808:	83 c0 28             	add    $0x28,%eax
  10380b:	83 c0 04             	add    $0x4,%eax
  10380e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103815:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103818:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10381b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10381e:	0f a3 10             	bt     %edx,(%eax)
  103821:	19 c0                	sbb    %eax,%eax
  103823:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103826:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10382a:	0f 95 c0             	setne  %al
  10382d:	0f b6 c0             	movzbl %al,%eax
  103830:	85 c0                	test   %eax,%eax
  103832:	74 0e                	je     103842 <default_check+0x29c>
  103834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103837:	83 c0 28             	add    $0x28,%eax
  10383a:	8b 40 08             	mov    0x8(%eax),%eax
  10383d:	83 f8 03             	cmp    $0x3,%eax
  103840:	74 24                	je     103866 <default_check+0x2c0>
  103842:	c7 44 24 0c 3c 69 10 	movl   $0x10693c,0xc(%esp)
  103849:	00 
  10384a:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103851:	00 
  103852:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103859:	00 
  10385a:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103861:	e8 92 d4 ff ff       	call   100cf8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103866:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10386d:	e8 f8 06 00 00       	call   103f6a <alloc_pages>
  103872:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103875:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103879:	75 24                	jne    10389f <default_check+0x2f9>
  10387b:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  103882:	00 
  103883:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  10388a:	00 
  10388b:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103892:	00 
  103893:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  10389a:	e8 59 d4 ff ff       	call   100cf8 <__panic>
    assert(alloc_page() == NULL);
  10389f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038a6:	e8 bf 06 00 00       	call   103f6a <alloc_pages>
  1038ab:	85 c0                	test   %eax,%eax
  1038ad:	74 24                	je     1038d3 <default_check+0x32d>
  1038af:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  1038b6:	00 
  1038b7:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1038be:	00 
  1038bf:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  1038c6:	00 
  1038c7:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1038ce:	e8 25 d4 ff ff       	call   100cf8 <__panic>
    assert(p0 + 2 == p1);
  1038d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038d6:	83 c0 28             	add    $0x28,%eax
  1038d9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1038dc:	74 24                	je     103902 <default_check+0x35c>
  1038de:	c7 44 24 0c 86 69 10 	movl   $0x106986,0xc(%esp)
  1038e5:	00 
  1038e6:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1038ed:	00 
  1038ee:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1038f5:	00 
  1038f6:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1038fd:	e8 f6 d3 ff ff       	call   100cf8 <__panic>

    p2 = p0 + 1;
  103902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103905:	83 c0 14             	add    $0x14,%eax
  103908:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  10390b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103912:	00 
  103913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103916:	89 04 24             	mov    %eax,(%esp)
  103919:	e8 86 06 00 00       	call   103fa4 <free_pages>
    free_pages(p1, 3);
  10391e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103925:	00 
  103926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103929:	89 04 24             	mov    %eax,(%esp)
  10392c:	e8 73 06 00 00       	call   103fa4 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103934:	83 c0 04             	add    $0x4,%eax
  103937:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10393e:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103941:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103944:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103947:	0f a3 10             	bt     %edx,(%eax)
  10394a:	19 c0                	sbb    %eax,%eax
  10394c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10394f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103953:	0f 95 c0             	setne  %al
  103956:	0f b6 c0             	movzbl %al,%eax
  103959:	85 c0                	test   %eax,%eax
  10395b:	74 0b                	je     103968 <default_check+0x3c2>
  10395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103960:	8b 40 08             	mov    0x8(%eax),%eax
  103963:	83 f8 01             	cmp    $0x1,%eax
  103966:	74 24                	je     10398c <default_check+0x3e6>
  103968:	c7 44 24 0c 94 69 10 	movl   $0x106994,0xc(%esp)
  10396f:	00 
  103970:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103977:	00 
  103978:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10397f:	00 
  103980:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103987:	e8 6c d3 ff ff       	call   100cf8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10398c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10398f:	83 c0 04             	add    $0x4,%eax
  103992:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103999:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10399c:	8b 45 90             	mov    -0x70(%ebp),%eax
  10399f:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1039a2:	0f a3 10             	bt     %edx,(%eax)
  1039a5:	19 c0                	sbb    %eax,%eax
  1039a7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1039aa:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1039ae:	0f 95 c0             	setne  %al
  1039b1:	0f b6 c0             	movzbl %al,%eax
  1039b4:	85 c0                	test   %eax,%eax
  1039b6:	74 0b                	je     1039c3 <default_check+0x41d>
  1039b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039bb:	8b 40 08             	mov    0x8(%eax),%eax
  1039be:	83 f8 03             	cmp    $0x3,%eax
  1039c1:	74 24                	je     1039e7 <default_check+0x441>
  1039c3:	c7 44 24 0c bc 69 10 	movl   $0x1069bc,0xc(%esp)
  1039ca:	00 
  1039cb:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  1039d2:	00 
  1039d3:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1039da:	00 
  1039db:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  1039e2:	e8 11 d3 ff ff       	call   100cf8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039ee:	e8 77 05 00 00       	call   103f6a <alloc_pages>
  1039f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039f9:	83 e8 14             	sub    $0x14,%eax
  1039fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039ff:	74 24                	je     103a25 <default_check+0x47f>
  103a01:	c7 44 24 0c e2 69 10 	movl   $0x1069e2,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103a20:	e8 d3 d2 ff ff       	call   100cf8 <__panic>
    free_page(p0);
  103a25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a2c:	00 
  103a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a30:	89 04 24             	mov    %eax,(%esp)
  103a33:	e8 6c 05 00 00       	call   103fa4 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a38:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a3f:	e8 26 05 00 00       	call   103f6a <alloc_pages>
  103a44:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a4a:	83 c0 14             	add    $0x14,%eax
  103a4d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a50:	74 24                	je     103a76 <default_check+0x4d0>
  103a52:	c7 44 24 0c 00 6a 10 	movl   $0x106a00,0xc(%esp)
  103a59:	00 
  103a5a:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103a61:	00 
  103a62:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  103a69:	00 
  103a6a:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103a71:	e8 82 d2 ff ff       	call   100cf8 <__panic>

    free_pages(p0, 2);
  103a76:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a7d:	00 
  103a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a81:	89 04 24             	mov    %eax,(%esp)
  103a84:	e8 1b 05 00 00       	call   103fa4 <free_pages>
    free_page(p2);
  103a89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a90:	00 
  103a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a94:	89 04 24             	mov    %eax,(%esp)
  103a97:	e8 08 05 00 00       	call   103fa4 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a9c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103aa3:	e8 c2 04 00 00       	call   103f6a <alloc_pages>
  103aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103aab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103aaf:	75 24                	jne    103ad5 <default_check+0x52f>
  103ab1:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  103ab8:	00 
  103ab9:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103ac0:	00 
  103ac1:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103ac8:	00 
  103ac9:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103ad0:	e8 23 d2 ff ff       	call   100cf8 <__panic>
    assert(alloc_page() == NULL);
  103ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103adc:	e8 89 04 00 00       	call   103f6a <alloc_pages>
  103ae1:	85 c0                	test   %eax,%eax
  103ae3:	74 24                	je     103b09 <default_check+0x563>
  103ae5:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103aec:	00 
  103aed:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103af4:	00 
  103af5:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  103afc:	00 
  103afd:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103b04:	e8 ef d1 ff ff       	call   100cf8 <__panic>

    assert(nr_free == 0);
  103b09:	a1 88 be 11 00       	mov    0x11be88,%eax
  103b0e:	85 c0                	test   %eax,%eax
  103b10:	74 24                	je     103b36 <default_check+0x590>
  103b12:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  103b19:	00 
  103b1a:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103b21:	00 
  103b22:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  103b29:	00 
  103b2a:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103b31:	e8 c2 d1 ff ff       	call   100cf8 <__panic>
    nr_free = nr_free_store;
  103b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b39:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_list = free_list_store;
  103b3e:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b41:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b44:	a3 80 be 11 00       	mov    %eax,0x11be80
  103b49:	89 15 84 be 11 00    	mov    %edx,0x11be84
    free_pages(p0, 5);
  103b4f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b56:	00 
  103b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b5a:	89 04 24             	mov    %eax,(%esp)
  103b5d:	e8 42 04 00 00       	call   103fa4 <free_pages>

    le = &free_list;
  103b62:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  103b69:	eb 5a                	jmp    103bc5 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
  103b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b6e:	8b 40 04             	mov    0x4(%eax),%eax
  103b71:	8b 00                	mov    (%eax),%eax
  103b73:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b76:	75 0d                	jne    103b85 <default_check+0x5df>
  103b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b7b:	8b 00                	mov    (%eax),%eax
  103b7d:	8b 40 04             	mov    0x4(%eax),%eax
  103b80:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b83:	74 24                	je     103ba9 <default_check+0x603>
  103b85:	c7 44 24 0c 40 6a 10 	movl   $0x106a40,0xc(%esp)
  103b8c:	00 
  103b8d:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103b94:	00 
  103b95:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
  103b9c:	00 
  103b9d:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103ba4:	e8 4f d1 ff ff       	call   100cf8 <__panic>
        struct Page *p = le2page(le, page_link);
  103ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bac:	83 e8 0c             	sub    $0xc,%eax
  103baf:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  103bb2:	ff 4d f4             	decl   -0xc(%ebp)
  103bb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103bb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103bbb:	8b 48 08             	mov    0x8(%eax),%ecx
  103bbe:	89 d0                	mov    %edx,%eax
  103bc0:	29 c8                	sub    %ecx,%eax
  103bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bc8:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103bcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  103bce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  103bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103bd4:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103bdb:	75 8e                	jne    103b6b <default_check+0x5c5>
    }
    assert(count == 0);
  103bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103be1:	74 24                	je     103c07 <default_check+0x661>
  103be3:	c7 44 24 0c 6d 6a 10 	movl   $0x106a6d,0xc(%esp)
  103bea:	00 
  103beb:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103bf2:	00 
  103bf3:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  103bfa:	00 
  103bfb:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103c02:	e8 f1 d0 ff ff       	call   100cf8 <__panic>
    assert(total == 0);
  103c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c0b:	74 24                	je     103c31 <default_check+0x68b>
  103c0d:	c7 44 24 0c 78 6a 10 	movl   $0x106a78,0xc(%esp)
  103c14:	00 
  103c15:	c7 44 24 08 f6 66 10 	movl   $0x1066f6,0x8(%esp)
  103c1c:	00 
  103c1d:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  103c24:	00 
  103c25:	c7 04 24 0b 67 10 00 	movl   $0x10670b,(%esp)
  103c2c:	e8 c7 d0 ff ff       	call   100cf8 <__panic>
}
  103c31:	90                   	nop
  103c32:	89 ec                	mov    %ebp,%esp
  103c34:	5d                   	pop    %ebp
  103c35:	c3                   	ret    

00103c36 <page2ppn>:
page2ppn(struct Page *page) {
  103c36:	55                   	push   %ebp
  103c37:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c39:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c42:	29 d0                	sub    %edx,%eax
  103c44:	c1 f8 02             	sar    $0x2,%eax
  103c47:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c4d:	5d                   	pop    %ebp
  103c4e:	c3                   	ret    

00103c4f <page2pa>:
page2pa(struct Page *page) {
  103c4f:	55                   	push   %ebp
  103c50:	89 e5                	mov    %esp,%ebp
  103c52:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c55:	8b 45 08             	mov    0x8(%ebp),%eax
  103c58:	89 04 24             	mov    %eax,(%esp)
  103c5b:	e8 d6 ff ff ff       	call   103c36 <page2ppn>
  103c60:	c1 e0 0c             	shl    $0xc,%eax
}
  103c63:	89 ec                	mov    %ebp,%esp
  103c65:	5d                   	pop    %ebp
  103c66:	c3                   	ret    

00103c67 <pa2page>:
pa2page(uintptr_t pa) {
  103c67:	55                   	push   %ebp
  103c68:	89 e5                	mov    %esp,%ebp
  103c6a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  103c70:	c1 e8 0c             	shr    $0xc,%eax
  103c73:	89 c2                	mov    %eax,%edx
  103c75:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103c7a:	39 c2                	cmp    %eax,%edx
  103c7c:	72 1c                	jb     103c9a <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c7e:	c7 44 24 08 b4 6a 10 	movl   $0x106ab4,0x8(%esp)
  103c85:	00 
  103c86:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c8d:	00 
  103c8e:	c7 04 24 d3 6a 10 00 	movl   $0x106ad3,(%esp)
  103c95:	e8 5e d0 ff ff       	call   100cf8 <__panic>
    return &pages[PPN(pa)];
  103c9a:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca3:	c1 e8 0c             	shr    $0xc,%eax
  103ca6:	89 c2                	mov    %eax,%edx
  103ca8:	89 d0                	mov    %edx,%eax
  103caa:	c1 e0 02             	shl    $0x2,%eax
  103cad:	01 d0                	add    %edx,%eax
  103caf:	c1 e0 02             	shl    $0x2,%eax
  103cb2:	01 c8                	add    %ecx,%eax
}
  103cb4:	89 ec                	mov    %ebp,%esp
  103cb6:	5d                   	pop    %ebp
  103cb7:	c3                   	ret    

00103cb8 <page2kva>:
page2kva(struct Page *page) {
  103cb8:	55                   	push   %ebp
  103cb9:	89 e5                	mov    %esp,%ebp
  103cbb:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc1:	89 04 24             	mov    %eax,(%esp)
  103cc4:	e8 86 ff ff ff       	call   103c4f <page2pa>
  103cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ccf:	c1 e8 0c             	shr    $0xc,%eax
  103cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103cd5:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103cda:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103cdd:	72 23                	jb     103d02 <page2kva+0x4a>
  103cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ce6:	c7 44 24 08 e4 6a 10 	movl   $0x106ae4,0x8(%esp)
  103ced:	00 
  103cee:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103cf5:	00 
  103cf6:	c7 04 24 d3 6a 10 00 	movl   $0x106ad3,(%esp)
  103cfd:	e8 f6 cf ff ff       	call   100cf8 <__panic>
  103d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d05:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103d0a:	89 ec                	mov    %ebp,%esp
  103d0c:	5d                   	pop    %ebp
  103d0d:	c3                   	ret    

00103d0e <pte2page>:
pte2page(pte_t pte) {
  103d0e:	55                   	push   %ebp
  103d0f:	89 e5                	mov    %esp,%ebp
  103d11:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103d14:	8b 45 08             	mov    0x8(%ebp),%eax
  103d17:	83 e0 01             	and    $0x1,%eax
  103d1a:	85 c0                	test   %eax,%eax
  103d1c:	75 1c                	jne    103d3a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103d1e:	c7 44 24 08 08 6b 10 	movl   $0x106b08,0x8(%esp)
  103d25:	00 
  103d26:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103d2d:	00 
  103d2e:	c7 04 24 d3 6a 10 00 	movl   $0x106ad3,(%esp)
  103d35:	e8 be cf ff ff       	call   100cf8 <__panic>
    return pa2page(PTE_ADDR(pte));
  103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d42:	89 04 24             	mov    %eax,(%esp)
  103d45:	e8 1d ff ff ff       	call   103c67 <pa2page>
}
  103d4a:	89 ec                	mov    %ebp,%esp
  103d4c:	5d                   	pop    %ebp
  103d4d:	c3                   	ret    

00103d4e <pde2page>:
pde2page(pde_t pde) {
  103d4e:	55                   	push   %ebp
  103d4f:	89 e5                	mov    %esp,%ebp
  103d51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d54:	8b 45 08             	mov    0x8(%ebp),%eax
  103d57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d5c:	89 04 24             	mov    %eax,(%esp)
  103d5f:	e8 03 ff ff ff       	call   103c67 <pa2page>
}
  103d64:	89 ec                	mov    %ebp,%esp
  103d66:	5d                   	pop    %ebp
  103d67:	c3                   	ret    

00103d68 <page_ref>:
page_ref(struct Page *page) {
  103d68:	55                   	push   %ebp
  103d69:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d6e:	8b 00                	mov    (%eax),%eax
}
  103d70:	5d                   	pop    %ebp
  103d71:	c3                   	ret    

00103d72 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d72:	55                   	push   %ebp
  103d73:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d75:	8b 45 08             	mov    0x8(%ebp),%eax
  103d78:	8b 00                	mov    (%eax),%eax
  103d7a:	8d 50 01             	lea    0x1(%eax),%edx
  103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d80:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d82:	8b 45 08             	mov    0x8(%ebp),%eax
  103d85:	8b 00                	mov    (%eax),%eax
}
  103d87:	5d                   	pop    %ebp
  103d88:	c3                   	ret    

00103d89 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d89:	55                   	push   %ebp
  103d8a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8f:	8b 00                	mov    (%eax),%eax
  103d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d94:	8b 45 08             	mov    0x8(%ebp),%eax
  103d97:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d99:	8b 45 08             	mov    0x8(%ebp),%eax
  103d9c:	8b 00                	mov    (%eax),%eax
}
  103d9e:	5d                   	pop    %ebp
  103d9f:	c3                   	ret    

00103da0 <__intr_save>:
__intr_save(void) {
  103da0:	55                   	push   %ebp
  103da1:	89 e5                	mov    %esp,%ebp
  103da3:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103da6:	9c                   	pushf  
  103da7:	58                   	pop    %eax
  103da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103dae:	25 00 02 00 00       	and    $0x200,%eax
  103db3:	85 c0                	test   %eax,%eax
  103db5:	74 0c                	je     103dc3 <__intr_save+0x23>
        intr_disable();
  103db7:	e8 95 d9 ff ff       	call   101751 <intr_disable>
        return 1;
  103dbc:	b8 01 00 00 00       	mov    $0x1,%eax
  103dc1:	eb 05                	jmp    103dc8 <__intr_save+0x28>
    return 0;
  103dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103dc8:	89 ec                	mov    %ebp,%esp
  103dca:	5d                   	pop    %ebp
  103dcb:	c3                   	ret    

00103dcc <__intr_restore>:
__intr_restore(bool flag) {
  103dcc:	55                   	push   %ebp
  103dcd:	89 e5                	mov    %esp,%ebp
  103dcf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103dd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103dd6:	74 05                	je     103ddd <__intr_restore+0x11>
        intr_enable();
  103dd8:	e8 6c d9 ff ff       	call   101749 <intr_enable>
}
  103ddd:	90                   	nop
  103dde:	89 ec                	mov    %ebp,%esp
  103de0:	5d                   	pop    %ebp
  103de1:	c3                   	ret    

00103de2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103de2:	55                   	push   %ebp
  103de3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103de5:	8b 45 08             	mov    0x8(%ebp),%eax
  103de8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103deb:	b8 23 00 00 00       	mov    $0x23,%eax
  103df0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103df2:	b8 23 00 00 00       	mov    $0x23,%eax
  103df7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103df9:	b8 10 00 00 00       	mov    $0x10,%eax
  103dfe:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103e00:	b8 10 00 00 00       	mov    $0x10,%eax
  103e05:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103e07:	b8 10 00 00 00       	mov    $0x10,%eax
  103e0c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103e0e:	ea 15 3e 10 00 08 00 	ljmp   $0x8,$0x103e15
}
  103e15:	90                   	nop
  103e16:	5d                   	pop    %ebp
  103e17:	c3                   	ret    

00103e18 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103e18:	55                   	push   %ebp
  103e19:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  103e1e:	a3 c4 be 11 00       	mov    %eax,0x11bec4
}
  103e23:	90                   	nop
  103e24:	5d                   	pop    %ebp
  103e25:	c3                   	ret    

00103e26 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103e26:	55                   	push   %ebp
  103e27:	89 e5                	mov    %esp,%ebp
  103e29:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103e2c:	b8 00 80 11 00       	mov    $0x118000,%eax
  103e31:	89 04 24             	mov    %eax,(%esp)
  103e34:	e8 df ff ff ff       	call   103e18 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e39:	66 c7 05 c8 be 11 00 	movw   $0x10,0x11bec8
  103e40:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e42:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103e49:	68 00 
  103e4b:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e50:	0f b7 c0             	movzwl %ax,%eax
  103e53:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103e59:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103e5e:	c1 e8 10             	shr    $0x10,%eax
  103e61:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103e66:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e6d:	24 f0                	and    $0xf0,%al
  103e6f:	0c 09                	or     $0x9,%al
  103e71:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e76:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e7d:	24 ef                	and    $0xef,%al
  103e7f:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e84:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e8b:	24 9f                	and    $0x9f,%al
  103e8d:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e92:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e99:	0c 80                	or     $0x80,%al
  103e9b:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103ea0:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ea7:	24 f0                	and    $0xf0,%al
  103ea9:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eae:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103eb5:	24 ef                	and    $0xef,%al
  103eb7:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ebc:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ec3:	24 df                	and    $0xdf,%al
  103ec5:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eca:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ed1:	0c 40                	or     $0x40,%al
  103ed3:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ed8:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103edf:	24 7f                	and    $0x7f,%al
  103ee1:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ee6:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103eeb:	c1 e8 18             	shr    $0x18,%eax
  103eee:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ef3:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103efa:	e8 e3 fe ff ff       	call   103de2 <lgdt>
  103eff:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103f05:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103f09:	0f 00 d8             	ltr    %ax
}
  103f0c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103f0d:	90                   	nop
  103f0e:	89 ec                	mov    %ebp,%esp
  103f10:	5d                   	pop    %ebp
  103f11:	c3                   	ret    

00103f12 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103f12:	55                   	push   %ebp
  103f13:	89 e5                	mov    %esp,%ebp
  103f15:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103f18:	c7 05 ac be 11 00 98 	movl   $0x106a98,0x11beac
  103f1f:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103f22:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f27:	8b 00                	mov    (%eax),%eax
  103f29:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f2d:	c7 04 24 34 6b 10 00 	movl   $0x106b34,(%esp)
  103f34:	e8 2c c4 ff ff       	call   100365 <cprintf>
    pmm_manager->init();
  103f39:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f3e:	8b 40 04             	mov    0x4(%eax),%eax
  103f41:	ff d0                	call   *%eax
}
  103f43:	90                   	nop
  103f44:	89 ec                	mov    %ebp,%esp
  103f46:	5d                   	pop    %ebp
  103f47:	c3                   	ret    

00103f48 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f48:	55                   	push   %ebp
  103f49:	89 e5                	mov    %esp,%ebp
  103f4b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f4e:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f53:	8b 40 08             	mov    0x8(%eax),%eax
  103f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f59:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  103f60:	89 14 24             	mov    %edx,(%esp)
  103f63:	ff d0                	call   *%eax
}
  103f65:	90                   	nop
  103f66:	89 ec                	mov    %ebp,%esp
  103f68:	5d                   	pop    %ebp
  103f69:	c3                   	ret    

00103f6a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f6a:	55                   	push   %ebp
  103f6b:	89 e5                	mov    %esp,%ebp
  103f6d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f77:	e8 24 fe ff ff       	call   103da0 <__intr_save>
  103f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f7f:	a1 ac be 11 00       	mov    0x11beac,%eax
  103f84:	8b 40 0c             	mov    0xc(%eax),%eax
  103f87:	8b 55 08             	mov    0x8(%ebp),%edx
  103f8a:	89 14 24             	mov    %edx,(%esp)
  103f8d:	ff d0                	call   *%eax
  103f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f95:	89 04 24             	mov    %eax,(%esp)
  103f98:	e8 2f fe ff ff       	call   103dcc <__intr_restore>
    return page;
  103f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103fa0:	89 ec                	mov    %ebp,%esp
  103fa2:	5d                   	pop    %ebp
  103fa3:	c3                   	ret    

00103fa4 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103fa4:	55                   	push   %ebp
  103fa5:	89 e5                	mov    %esp,%ebp
  103fa7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103faa:	e8 f1 fd ff ff       	call   103da0 <__intr_save>
  103faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103fb2:	a1 ac be 11 00       	mov    0x11beac,%eax
  103fb7:	8b 40 10             	mov    0x10(%eax),%eax
  103fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  103fbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  103fc4:	89 14 24             	mov    %edx,(%esp)
  103fc7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fcc:	89 04 24             	mov    %eax,(%esp)
  103fcf:	e8 f8 fd ff ff       	call   103dcc <__intr_restore>
}
  103fd4:	90                   	nop
  103fd5:	89 ec                	mov    %ebp,%esp
  103fd7:	5d                   	pop    %ebp
  103fd8:	c3                   	ret    

00103fd9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103fd9:	55                   	push   %ebp
  103fda:	89 e5                	mov    %esp,%ebp
  103fdc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103fdf:	e8 bc fd ff ff       	call   103da0 <__intr_save>
  103fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103fe7:	a1 ac be 11 00       	mov    0x11beac,%eax
  103fec:	8b 40 14             	mov    0x14(%eax),%eax
  103fef:	ff d0                	call   *%eax
  103ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff7:	89 04 24             	mov    %eax,(%esp)
  103ffa:	e8 cd fd ff ff       	call   103dcc <__intr_restore>
    return ret;
  103fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104002:	89 ec                	mov    %ebp,%esp
  104004:	5d                   	pop    %ebp
  104005:	c3                   	ret    

00104006 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  104006:	55                   	push   %ebp
  104007:	89 e5                	mov    %esp,%ebp
  104009:	57                   	push   %edi
  10400a:	56                   	push   %esi
  10400b:	53                   	push   %ebx
  10400c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104012:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104019:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104020:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104027:	c7 04 24 4b 6b 10 00 	movl   $0x106b4b,(%esp)
  10402e:	e8 32 c3 ff ff       	call   100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104033:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10403a:	e9 0c 01 00 00       	jmp    10414b <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10403f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104042:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104045:	89 d0                	mov    %edx,%eax
  104047:	c1 e0 02             	shl    $0x2,%eax
  10404a:	01 d0                	add    %edx,%eax
  10404c:	c1 e0 02             	shl    $0x2,%eax
  10404f:	01 c8                	add    %ecx,%eax
  104051:	8b 50 08             	mov    0x8(%eax),%edx
  104054:	8b 40 04             	mov    0x4(%eax),%eax
  104057:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10405a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10405d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104060:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104063:	89 d0                	mov    %edx,%eax
  104065:	c1 e0 02             	shl    $0x2,%eax
  104068:	01 d0                	add    %edx,%eax
  10406a:	c1 e0 02             	shl    $0x2,%eax
  10406d:	01 c8                	add    %ecx,%eax
  10406f:	8b 48 0c             	mov    0xc(%eax),%ecx
  104072:	8b 58 10             	mov    0x10(%eax),%ebx
  104075:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104078:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10407b:	01 c8                	add    %ecx,%eax
  10407d:	11 da                	adc    %ebx,%edx
  10407f:	89 45 98             	mov    %eax,-0x68(%ebp)
  104082:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104085:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104088:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10408b:	89 d0                	mov    %edx,%eax
  10408d:	c1 e0 02             	shl    $0x2,%eax
  104090:	01 d0                	add    %edx,%eax
  104092:	c1 e0 02             	shl    $0x2,%eax
  104095:	01 c8                	add    %ecx,%eax
  104097:	83 c0 14             	add    $0x14,%eax
  10409a:	8b 00                	mov    (%eax),%eax
  10409c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1040a2:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040a5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1040a8:	83 c0 ff             	add    $0xffffffff,%eax
  1040ab:	83 d2 ff             	adc    $0xffffffff,%edx
  1040ae:	89 c6                	mov    %eax,%esi
  1040b0:	89 d7                	mov    %edx,%edi
  1040b2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040b8:	89 d0                	mov    %edx,%eax
  1040ba:	c1 e0 02             	shl    $0x2,%eax
  1040bd:	01 d0                	add    %edx,%eax
  1040bf:	c1 e0 02             	shl    $0x2,%eax
  1040c2:	01 c8                	add    %ecx,%eax
  1040c4:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040c7:	8b 58 10             	mov    0x10(%eax),%ebx
  1040ca:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1040d0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1040d4:	89 74 24 14          	mov    %esi,0x14(%esp)
  1040d8:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1040dc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040df:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1040e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040e6:	89 54 24 10          	mov    %edx,0x10(%esp)
  1040ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040f2:	c7 04 24 58 6b 10 00 	movl   $0x106b58,(%esp)
  1040f9:	e8 67 c2 ff ff       	call   100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040fe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104101:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104104:	89 d0                	mov    %edx,%eax
  104106:	c1 e0 02             	shl    $0x2,%eax
  104109:	01 d0                	add    %edx,%eax
  10410b:	c1 e0 02             	shl    $0x2,%eax
  10410e:	01 c8                	add    %ecx,%eax
  104110:	83 c0 14             	add    $0x14,%eax
  104113:	8b 00                	mov    (%eax),%eax
  104115:	83 f8 01             	cmp    $0x1,%eax
  104118:	75 2e                	jne    104148 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  10411a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10411d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104120:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104123:	89 d0                	mov    %edx,%eax
  104125:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  104128:	73 1e                	jae    104148 <page_init+0x142>
  10412a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  10412f:	b8 00 00 00 00       	mov    $0x0,%eax
  104134:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104137:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  10413a:	72 0c                	jb     104148 <page_init+0x142>
                maxpa = end;
  10413c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10413f:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104142:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104145:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  104148:	ff 45 dc             	incl   -0x24(%ebp)
  10414b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10414e:	8b 00                	mov    (%eax),%eax
  104150:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104153:	0f 8c e6 fe ff ff    	jl     10403f <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104159:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10415e:	b8 00 00 00 00       	mov    $0x0,%eax
  104163:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104166:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104169:	73 0e                	jae    104179 <page_init+0x173>
        maxpa = KMEMSIZE;
  10416b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104172:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104179:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10417c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10417f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104183:	c1 ea 0c             	shr    $0xc,%edx
  104186:	a3 a4 be 11 00       	mov    %eax,0x11bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10418b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104192:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  104197:	8d 50 ff             	lea    -0x1(%eax),%edx
  10419a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10419d:	01 d0                	add    %edx,%eax
  10419f:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1041a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041a5:	ba 00 00 00 00       	mov    $0x0,%edx
  1041aa:	f7 75 c0             	divl   -0x40(%ebp)
  1041ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041b0:	29 d0                	sub    %edx,%eax
  1041b2:	a3 a0 be 11 00       	mov    %eax,0x11bea0

    for (i = 0; i < npage; i ++) {
  1041b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041be:	eb 2f                	jmp    1041ef <page_init+0x1e9>
        SetPageReserved(pages + i);
  1041c0:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  1041c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041c9:	89 d0                	mov    %edx,%eax
  1041cb:	c1 e0 02             	shl    $0x2,%eax
  1041ce:	01 d0                	add    %edx,%eax
  1041d0:	c1 e0 02             	shl    $0x2,%eax
  1041d3:	01 c8                	add    %ecx,%eax
  1041d5:	83 c0 04             	add    $0x4,%eax
  1041d8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  1041df:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1041e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  1041e5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1041e8:	0f ab 10             	bts    %edx,(%eax)
}
  1041eb:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1041ec:	ff 45 dc             	incl   -0x24(%ebp)
  1041ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041f2:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1041f7:	39 c2                	cmp    %eax,%edx
  1041f9:	72 c5                	jb     1041c0 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041fb:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  104201:	89 d0                	mov    %edx,%eax
  104203:	c1 e0 02             	shl    $0x2,%eax
  104206:	01 d0                	add    %edx,%eax
  104208:	c1 e0 02             	shl    $0x2,%eax
  10420b:	89 c2                	mov    %eax,%edx
  10420d:	a1 a0 be 11 00       	mov    0x11bea0,%eax
  104212:	01 d0                	add    %edx,%eax
  104214:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104217:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  10421e:	77 23                	ja     104243 <page_init+0x23d>
  104220:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104227:	c7 44 24 08 88 6b 10 	movl   $0x106b88,0x8(%esp)
  10422e:	00 
  10422f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104236:	00 
  104237:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10423e:	e8 b5 ca ff ff       	call   100cf8 <__panic>
  104243:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104246:	05 00 00 00 40       	add    $0x40000000,%eax
  10424b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10424e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104255:	e9 53 01 00 00       	jmp    1043ad <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10425a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10425d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104260:	89 d0                	mov    %edx,%eax
  104262:	c1 e0 02             	shl    $0x2,%eax
  104265:	01 d0                	add    %edx,%eax
  104267:	c1 e0 02             	shl    $0x2,%eax
  10426a:	01 c8                	add    %ecx,%eax
  10426c:	8b 50 08             	mov    0x8(%eax),%edx
  10426f:	8b 40 04             	mov    0x4(%eax),%eax
  104272:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104275:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104278:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10427b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10427e:	89 d0                	mov    %edx,%eax
  104280:	c1 e0 02             	shl    $0x2,%eax
  104283:	01 d0                	add    %edx,%eax
  104285:	c1 e0 02             	shl    $0x2,%eax
  104288:	01 c8                	add    %ecx,%eax
  10428a:	8b 48 0c             	mov    0xc(%eax),%ecx
  10428d:	8b 58 10             	mov    0x10(%eax),%ebx
  104290:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104293:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104296:	01 c8                	add    %ecx,%eax
  104298:	11 da                	adc    %ebx,%edx
  10429a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10429d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1042a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1042a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042a6:	89 d0                	mov    %edx,%eax
  1042a8:	c1 e0 02             	shl    $0x2,%eax
  1042ab:	01 d0                	add    %edx,%eax
  1042ad:	c1 e0 02             	shl    $0x2,%eax
  1042b0:	01 c8                	add    %ecx,%eax
  1042b2:	83 c0 14             	add    $0x14,%eax
  1042b5:	8b 00                	mov    (%eax),%eax
  1042b7:	83 f8 01             	cmp    $0x1,%eax
  1042ba:	0f 85 ea 00 00 00    	jne    1043aa <page_init+0x3a4>
            if (begin < freemem) {
  1042c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042c3:	ba 00 00 00 00       	mov    $0x0,%edx
  1042c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1042cb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1042ce:	19 d1                	sbb    %edx,%ecx
  1042d0:	73 0d                	jae    1042df <page_init+0x2d9>
                begin = freemem;
  1042d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1042d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042df:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1042e4:	b8 00 00 00 00       	mov    $0x0,%eax
  1042e9:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1042ec:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042ef:	73 0e                	jae    1042ff <page_init+0x2f9>
                end = KMEMSIZE;
  1042f1:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042f8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104302:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104305:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104308:	89 d0                	mov    %edx,%eax
  10430a:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10430d:	0f 83 97 00 00 00    	jae    1043aa <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  104313:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10431a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10431d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104320:	01 d0                	add    %edx,%eax
  104322:	48                   	dec    %eax
  104323:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104326:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104329:	ba 00 00 00 00       	mov    $0x0,%edx
  10432e:	f7 75 b0             	divl   -0x50(%ebp)
  104331:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104334:	29 d0                	sub    %edx,%eax
  104336:	ba 00 00 00 00       	mov    $0x0,%edx
  10433b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10433e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104341:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104344:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104347:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10434a:	ba 00 00 00 00       	mov    $0x0,%edx
  10434f:	89 c7                	mov    %eax,%edi
  104351:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104357:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10435a:	89 d0                	mov    %edx,%eax
  10435c:	83 e0 00             	and    $0x0,%eax
  10435f:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104362:	8b 45 80             	mov    -0x80(%ebp),%eax
  104365:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104368:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10436b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10436e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104371:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104374:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104377:	89 d0                	mov    %edx,%eax
  104379:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10437c:	73 2c                	jae    1043aa <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10437e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104381:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104384:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104387:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10438a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10438e:	c1 ea 0c             	shr    $0xc,%edx
  104391:	89 c3                	mov    %eax,%ebx
  104393:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104396:	89 04 24             	mov    %eax,(%esp)
  104399:	e8 c9 f8 ff ff       	call   103c67 <pa2page>
  10439e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1043a2:	89 04 24             	mov    %eax,(%esp)
  1043a5:	e8 9e fb ff ff       	call   103f48 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1043aa:	ff 45 dc             	incl   -0x24(%ebp)
  1043ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043b0:	8b 00                	mov    (%eax),%eax
  1043b2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1043b5:	0f 8c 9f fe ff ff    	jl     10425a <page_init+0x254>
                }
            }
        }
    }
}
  1043bb:	90                   	nop
  1043bc:	90                   	nop
  1043bd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043c3:	5b                   	pop    %ebx
  1043c4:	5e                   	pop    %esi
  1043c5:	5f                   	pop    %edi
  1043c6:	5d                   	pop    %ebp
  1043c7:	c3                   	ret    

001043c8 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1043c8:	55                   	push   %ebp
  1043c9:	89 e5                	mov    %esp,%ebp
  1043cb:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1043ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043d1:	33 45 14             	xor    0x14(%ebp),%eax
  1043d4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043d9:	85 c0                	test   %eax,%eax
  1043db:	74 24                	je     104401 <boot_map_segment+0x39>
  1043dd:	c7 44 24 0c ba 6b 10 	movl   $0x106bba,0xc(%esp)
  1043e4:	00 
  1043e5:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  1043ec:	00 
  1043ed:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1043f4:	00 
  1043f5:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1043fc:	e8 f7 c8 ff ff       	call   100cf8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104401:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10440b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104410:	89 c2                	mov    %eax,%edx
  104412:	8b 45 10             	mov    0x10(%ebp),%eax
  104415:	01 c2                	add    %eax,%edx
  104417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10441a:	01 d0                	add    %edx,%eax
  10441c:	48                   	dec    %eax
  10441d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104423:	ba 00 00 00 00       	mov    $0x0,%edx
  104428:	f7 75 f0             	divl   -0x10(%ebp)
  10442b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10442e:	29 d0                	sub    %edx,%eax
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
  104458:	eb 68                	jmp    1044c2 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10445a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104461:	00 
  104462:	8b 45 0c             	mov    0xc(%ebp),%eax
  104465:	89 44 24 04          	mov    %eax,0x4(%esp)
  104469:	8b 45 08             	mov    0x8(%ebp),%eax
  10446c:	89 04 24             	mov    %eax,(%esp)
  10446f:	e8 88 01 00 00       	call   1045fc <get_pte>
  104474:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10447b:	75 24                	jne    1044a1 <boot_map_segment+0xd9>
  10447d:	c7 44 24 0c e6 6b 10 	movl   $0x106be6,0xc(%esp)
  104484:	00 
  104485:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  10448c:	00 
  10448d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104494:	00 
  104495:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10449c:	e8 57 c8 ff ff       	call   100cf8 <__panic>
        *ptep = pa | PTE_P | perm;
  1044a1:	8b 45 14             	mov    0x14(%ebp),%eax
  1044a4:	0b 45 18             	or     0x18(%ebp),%eax
  1044a7:	83 c8 01             	or     $0x1,%eax
  1044aa:	89 c2                	mov    %eax,%edx
  1044ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044af:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044b1:	ff 4d f4             	decl   -0xc(%ebp)
  1044b4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1044bb:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1044c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044c6:	75 92                	jne    10445a <boot_map_segment+0x92>
    }
}
  1044c8:	90                   	nop
  1044c9:	90                   	nop
  1044ca:	89 ec                	mov    %ebp,%esp
  1044cc:	5d                   	pop    %ebp
  1044cd:	c3                   	ret    

001044ce <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044ce:	55                   	push   %ebp
  1044cf:	89 e5                	mov    %esp,%ebp
  1044d1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044db:	e8 8a fa ff ff       	call   103f6a <alloc_pages>
  1044e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044e7:	75 1c                	jne    104505 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044e9:	c7 44 24 08 f3 6b 10 	movl   $0x106bf3,0x8(%esp)
  1044f0:	00 
  1044f1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1044f8:	00 
  1044f9:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104500:	e8 f3 c7 ff ff       	call   100cf8 <__panic>
    }
    return page2kva(p);
  104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104508:	89 04 24             	mov    %eax,(%esp)
  10450b:	e8 a8 f7 ff ff       	call   103cb8 <page2kva>
}
  104510:	89 ec                	mov    %ebp,%esp
  104512:	5d                   	pop    %ebp
  104513:	c3                   	ret    

00104514 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104514:	55                   	push   %ebp
  104515:	89 e5                	mov    %esp,%ebp
  104517:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10451a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10451f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104522:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104529:	77 23                	ja     10454e <pmm_init+0x3a>
  10452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104532:	c7 44 24 08 88 6b 10 	movl   $0x106b88,0x8(%esp)
  104539:	00 
  10453a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104541:	00 
  104542:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104549:	e8 aa c7 ff ff       	call   100cf8 <__panic>
  10454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104551:	05 00 00 00 40       	add    $0x40000000,%eax
  104556:	a3 a8 be 11 00       	mov    %eax,0x11bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10455b:	e8 b2 f9 ff ff       	call   103f12 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104560:	e8 a1 fa ff ff       	call   104006 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104565:	e8 5a 02 00 00       	call   1047c4 <check_alloc_page>

    check_pgdir();
  10456a:	e8 76 02 00 00       	call   1047e5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10456f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104574:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104577:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10457e:	77 23                	ja     1045a3 <pmm_init+0x8f>
  104580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104583:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104587:	c7 44 24 08 88 6b 10 	movl   $0x106b88,0x8(%esp)
  10458e:	00 
  10458f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104596:	00 
  104597:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10459e:	e8 55 c7 ff ff       	call   100cf8 <__panic>
  1045a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a6:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1045ac:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1045b1:	05 ac 0f 00 00       	add    $0xfac,%eax
  1045b6:	83 ca 03             	or     $0x3,%edx
  1045b9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045bb:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1045c0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045c7:	00 
  1045c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045cf:	00 
  1045d0:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045d7:	38 
  1045d8:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045df:	c0 
  1045e0:	89 04 24             	mov    %eax,(%esp)
  1045e3:	e8 e0 fd ff ff       	call   1043c8 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045e8:	e8 39 f8 ff ff       	call   103e26 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045ed:	e8 91 08 00 00       	call   104e83 <check_boot_pgdir>

    print_pgdir();
  1045f2:	e8 0e 0d 00 00       	call   105305 <print_pgdir>

}
  1045f7:	90                   	nop
  1045f8:	89 ec                	mov    %ebp,%esp
  1045fa:	5d                   	pop    %ebp
  1045fb:	c3                   	ret    

001045fc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045fc:	55                   	push   %ebp
  1045fd:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1045ff:	90                   	nop
  104600:	5d                   	pop    %ebp
  104601:	c3                   	ret    

00104602 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104602:	55                   	push   %ebp
  104603:	89 e5                	mov    %esp,%ebp
  104605:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104608:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10460f:	00 
  104610:	8b 45 0c             	mov    0xc(%ebp),%eax
  104613:	89 44 24 04          	mov    %eax,0x4(%esp)
  104617:	8b 45 08             	mov    0x8(%ebp),%eax
  10461a:	89 04 24             	mov    %eax,(%esp)
  10461d:	e8 da ff ff ff       	call   1045fc <get_pte>
  104622:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104629:	74 08                	je     104633 <get_page+0x31>
        *ptep_store = ptep;
  10462b:	8b 45 10             	mov    0x10(%ebp),%eax
  10462e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104631:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104637:	74 1b                	je     104654 <get_page+0x52>
  104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10463c:	8b 00                	mov    (%eax),%eax
  10463e:	83 e0 01             	and    $0x1,%eax
  104641:	85 c0                	test   %eax,%eax
  104643:	74 0f                	je     104654 <get_page+0x52>
        return pte2page(*ptep);
  104645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104648:	8b 00                	mov    (%eax),%eax
  10464a:	89 04 24             	mov    %eax,(%esp)
  10464d:	e8 bc f6 ff ff       	call   103d0e <pte2page>
  104652:	eb 05                	jmp    104659 <get_page+0x57>
    }
    return NULL;
  104654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104659:	89 ec                	mov    %ebp,%esp
  10465b:	5d                   	pop    %ebp
  10465c:	c3                   	ret    

0010465d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10465d:	55                   	push   %ebp
  10465e:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104660:	90                   	nop
  104661:	5d                   	pop    %ebp
  104662:	c3                   	ret    

00104663 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104663:	55                   	push   %ebp
  104664:	89 e5                	mov    %esp,%ebp
  104666:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104669:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104670:	00 
  104671:	8b 45 0c             	mov    0xc(%ebp),%eax
  104674:	89 44 24 04          	mov    %eax,0x4(%esp)
  104678:	8b 45 08             	mov    0x8(%ebp),%eax
  10467b:	89 04 24             	mov    %eax,(%esp)
  10467e:	e8 79 ff ff ff       	call   1045fc <get_pte>
  104683:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104686:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10468a:	74 19                	je     1046a5 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10468c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10468f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104693:	8b 45 0c             	mov    0xc(%ebp),%eax
  104696:	89 44 24 04          	mov    %eax,0x4(%esp)
  10469a:	8b 45 08             	mov    0x8(%ebp),%eax
  10469d:	89 04 24             	mov    %eax,(%esp)
  1046a0:	e8 b8 ff ff ff       	call   10465d <page_remove_pte>
    }
}
  1046a5:	90                   	nop
  1046a6:	89 ec                	mov    %ebp,%esp
  1046a8:	5d                   	pop    %ebp
  1046a9:	c3                   	ret    

001046aa <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1046aa:	55                   	push   %ebp
  1046ab:	89 e5                	mov    %esp,%ebp
  1046ad:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1046b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046b7:	00 
  1046b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1046bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c2:	89 04 24             	mov    %eax,(%esp)
  1046c5:	e8 32 ff ff ff       	call   1045fc <get_pte>
  1046ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046d1:	75 0a                	jne    1046dd <page_insert+0x33>
        return -E_NO_MEM;
  1046d3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046d8:	e9 84 00 00 00       	jmp    104761 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e0:	89 04 24             	mov    %eax,(%esp)
  1046e3:	e8 8a f6 ff ff       	call   103d72 <page_ref_inc>
    if (*ptep & PTE_P) {
  1046e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046eb:	8b 00                	mov    (%eax),%eax
  1046ed:	83 e0 01             	and    $0x1,%eax
  1046f0:	85 c0                	test   %eax,%eax
  1046f2:	74 3e                	je     104732 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f7:	8b 00                	mov    (%eax),%eax
  1046f9:	89 04 24             	mov    %eax,(%esp)
  1046fc:	e8 0d f6 ff ff       	call   103d0e <pte2page>
  104701:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104707:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10470a:	75 0d                	jne    104719 <page_insert+0x6f>
            page_ref_dec(page);
  10470c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10470f:	89 04 24             	mov    %eax,(%esp)
  104712:	e8 72 f6 ff ff       	call   103d89 <page_ref_dec>
  104717:	eb 19                	jmp    104732 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104720:	8b 45 10             	mov    0x10(%ebp),%eax
  104723:	89 44 24 04          	mov    %eax,0x4(%esp)
  104727:	8b 45 08             	mov    0x8(%ebp),%eax
  10472a:	89 04 24             	mov    %eax,(%esp)
  10472d:	e8 2b ff ff ff       	call   10465d <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104732:	8b 45 0c             	mov    0xc(%ebp),%eax
  104735:	89 04 24             	mov    %eax,(%esp)
  104738:	e8 12 f5 ff ff       	call   103c4f <page2pa>
  10473d:	0b 45 14             	or     0x14(%ebp),%eax
  104740:	83 c8 01             	or     $0x1,%eax
  104743:	89 c2                	mov    %eax,%edx
  104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104748:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10474a:	8b 45 10             	mov    0x10(%ebp),%eax
  10474d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104751:	8b 45 08             	mov    0x8(%ebp),%eax
  104754:	89 04 24             	mov    %eax,(%esp)
  104757:	e8 09 00 00 00       	call   104765 <tlb_invalidate>
    return 0;
  10475c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104761:	89 ec                	mov    %ebp,%esp
  104763:	5d                   	pop    %ebp
  104764:	c3                   	ret    

00104765 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104765:	55                   	push   %ebp
  104766:	89 e5                	mov    %esp,%ebp
  104768:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10476b:	0f 20 d8             	mov    %cr3,%eax
  10476e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104771:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  104774:	8b 45 08             	mov    0x8(%ebp),%eax
  104777:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10477a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104781:	77 23                	ja     1047a6 <tlb_invalidate+0x41>
  104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104786:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10478a:	c7 44 24 08 88 6b 10 	movl   $0x106b88,0x8(%esp)
  104791:	00 
  104792:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  104799:	00 
  10479a:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1047a1:	e8 52 c5 ff ff       	call   100cf8 <__panic>
  1047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a9:	05 00 00 00 40       	add    $0x40000000,%eax
  1047ae:	39 d0                	cmp    %edx,%eax
  1047b0:	75 0d                	jne    1047bf <tlb_invalidate+0x5a>
        invlpg((void *)la);
  1047b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1047b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047bb:	0f 01 38             	invlpg (%eax)
}
  1047be:	90                   	nop
    }
}
  1047bf:	90                   	nop
  1047c0:	89 ec                	mov    %ebp,%esp
  1047c2:	5d                   	pop    %ebp
  1047c3:	c3                   	ret    

001047c4 <check_alloc_page>:

static void
check_alloc_page(void) {
  1047c4:	55                   	push   %ebp
  1047c5:	89 e5                	mov    %esp,%ebp
  1047c7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047ca:	a1 ac be 11 00       	mov    0x11beac,%eax
  1047cf:	8b 40 18             	mov    0x18(%eax),%eax
  1047d2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047d4:	c7 04 24 0c 6c 10 00 	movl   $0x106c0c,(%esp)
  1047db:	e8 85 bb ff ff       	call   100365 <cprintf>
}
  1047e0:	90                   	nop
  1047e1:	89 ec                	mov    %ebp,%esp
  1047e3:	5d                   	pop    %ebp
  1047e4:	c3                   	ret    

001047e5 <check_pgdir>:

static void
check_pgdir(void) {
  1047e5:	55                   	push   %ebp
  1047e6:	89 e5                	mov    %esp,%ebp
  1047e8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047eb:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1047f0:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047f5:	76 24                	jbe    10481b <check_pgdir+0x36>
  1047f7:	c7 44 24 0c 2b 6c 10 	movl   $0x106c2b,0xc(%esp)
  1047fe:	00 
  1047ff:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104806:	00 
  104807:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  10480e:	00 
  10480f:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104816:	e8 dd c4 ff ff       	call   100cf8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10481b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104820:	85 c0                	test   %eax,%eax
  104822:	74 0e                	je     104832 <check_pgdir+0x4d>
  104824:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104829:	25 ff 0f 00 00       	and    $0xfff,%eax
  10482e:	85 c0                	test   %eax,%eax
  104830:	74 24                	je     104856 <check_pgdir+0x71>
  104832:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  104839:	00 
  10483a:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104841:	00 
  104842:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  104849:	00 
  10484a:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104851:	e8 a2 c4 ff ff       	call   100cf8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104856:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10485b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104862:	00 
  104863:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10486a:	00 
  10486b:	89 04 24             	mov    %eax,(%esp)
  10486e:	e8 8f fd ff ff       	call   104602 <get_page>
  104873:	85 c0                	test   %eax,%eax
  104875:	74 24                	je     10489b <check_pgdir+0xb6>
  104877:	c7 44 24 0c 80 6c 10 	movl   $0x106c80,0xc(%esp)
  10487e:	00 
  10487f:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104886:	00 
  104887:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  10488e:	00 
  10488f:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104896:	e8 5d c4 ff ff       	call   100cf8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10489b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048a2:	e8 c3 f6 ff ff       	call   103f6a <alloc_pages>
  1048a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1048aa:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1048b6:	00 
  1048b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048be:	00 
  1048bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048c6:	89 04 24             	mov    %eax,(%esp)
  1048c9:	e8 dc fd ff ff       	call   1046aa <page_insert>
  1048ce:	85 c0                	test   %eax,%eax
  1048d0:	74 24                	je     1048f6 <check_pgdir+0x111>
  1048d2:	c7 44 24 0c a8 6c 10 	movl   $0x106ca8,0xc(%esp)
  1048d9:	00 
  1048da:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  1048e1:	00 
  1048e2:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1048e9:	00 
  1048ea:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1048f1:	e8 02 c4 ff ff       	call   100cf8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048f6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104902:	00 
  104903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10490a:	00 
  10490b:	89 04 24             	mov    %eax,(%esp)
  10490e:	e8 e9 fc ff ff       	call   1045fc <get_pte>
  104913:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104916:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10491a:	75 24                	jne    104940 <check_pgdir+0x15b>
  10491c:	c7 44 24 0c d4 6c 10 	movl   $0x106cd4,0xc(%esp)
  104923:	00 
  104924:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  10492b:	00 
  10492c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  104933:	00 
  104934:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10493b:	e8 b8 c3 ff ff       	call   100cf8 <__panic>
    assert(pte2page(*ptep) == p1);
  104940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104943:	8b 00                	mov    (%eax),%eax
  104945:	89 04 24             	mov    %eax,(%esp)
  104948:	e8 c1 f3 ff ff       	call   103d0e <pte2page>
  10494d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104950:	74 24                	je     104976 <check_pgdir+0x191>
  104952:	c7 44 24 0c 01 6d 10 	movl   $0x106d01,0xc(%esp)
  104959:	00 
  10495a:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104961:	00 
  104962:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  104969:	00 
  10496a:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104971:	e8 82 c3 ff ff       	call   100cf8 <__panic>
    assert(page_ref(p1) == 1);
  104976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104979:	89 04 24             	mov    %eax,(%esp)
  10497c:	e8 e7 f3 ff ff       	call   103d68 <page_ref>
  104981:	83 f8 01             	cmp    $0x1,%eax
  104984:	74 24                	je     1049aa <check_pgdir+0x1c5>
  104986:	c7 44 24 0c 17 6d 10 	movl   $0x106d17,0xc(%esp)
  10498d:	00 
  10498e:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104995:	00 
  104996:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10499d:	00 
  10499e:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1049a5:	e8 4e c3 ff ff       	call   100cf8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1049aa:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1049af:	8b 00                	mov    (%eax),%eax
  1049b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1049b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049bc:	c1 e8 0c             	shr    $0xc,%eax
  1049bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1049c2:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1049c7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049ca:	72 23                	jb     1049ef <check_pgdir+0x20a>
  1049cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049d3:	c7 44 24 08 e4 6a 10 	movl   $0x106ae4,0x8(%esp)
  1049da:	00 
  1049db:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1049e2:	00 
  1049e3:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1049ea:	e8 09 c3 ff ff       	call   100cf8 <__panic>
  1049ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049f2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049f7:	83 c0 04             	add    $0x4,%eax
  1049fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049fd:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a09:	00 
  104a0a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a11:	00 
  104a12:	89 04 24             	mov    %eax,(%esp)
  104a15:	e8 e2 fb ff ff       	call   1045fc <get_pte>
  104a1a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a1d:	74 24                	je     104a43 <check_pgdir+0x25e>
  104a1f:	c7 44 24 0c 2c 6d 10 	movl   $0x106d2c,0xc(%esp)
  104a26:	00 
  104a27:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104a2e:	00 
  104a2f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  104a36:	00 
  104a37:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104a3e:	e8 b5 c2 ff ff       	call   100cf8 <__panic>

    p2 = alloc_page();
  104a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a4a:	e8 1b f5 ff ff       	call   103f6a <alloc_pages>
  104a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a52:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a5e:	00 
  104a5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a66:	00 
  104a67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a6e:	89 04 24             	mov    %eax,(%esp)
  104a71:	e8 34 fc ff ff       	call   1046aa <page_insert>
  104a76:	85 c0                	test   %eax,%eax
  104a78:	74 24                	je     104a9e <check_pgdir+0x2b9>
  104a7a:	c7 44 24 0c 54 6d 10 	movl   $0x106d54,0xc(%esp)
  104a81:	00 
  104a82:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104a89:	00 
  104a8a:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  104a91:	00 
  104a92:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104a99:	e8 5a c2 ff ff       	call   100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a9e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104aa3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aaa:	00 
  104aab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ab2:	00 
  104ab3:	89 04 24             	mov    %eax,(%esp)
  104ab6:	e8 41 fb ff ff       	call   1045fc <get_pte>
  104abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ac2:	75 24                	jne    104ae8 <check_pgdir+0x303>
  104ac4:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  104acb:	00 
  104acc:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104ad3:	00 
  104ad4:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  104adb:	00 
  104adc:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104ae3:	e8 10 c2 ff ff       	call   100cf8 <__panic>
    assert(*ptep & PTE_U);
  104ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aeb:	8b 00                	mov    (%eax),%eax
  104aed:	83 e0 04             	and    $0x4,%eax
  104af0:	85 c0                	test   %eax,%eax
  104af2:	75 24                	jne    104b18 <check_pgdir+0x333>
  104af4:	c7 44 24 0c bc 6d 10 	movl   $0x106dbc,0xc(%esp)
  104afb:	00 
  104afc:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104b03:	00 
  104b04:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104b0b:	00 
  104b0c:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104b13:	e8 e0 c1 ff ff       	call   100cf8 <__panic>
    assert(*ptep & PTE_W);
  104b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b1b:	8b 00                	mov    (%eax),%eax
  104b1d:	83 e0 02             	and    $0x2,%eax
  104b20:	85 c0                	test   %eax,%eax
  104b22:	75 24                	jne    104b48 <check_pgdir+0x363>
  104b24:	c7 44 24 0c ca 6d 10 	movl   $0x106dca,0xc(%esp)
  104b2b:	00 
  104b2c:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104b33:	00 
  104b34:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104b3b:	00 
  104b3c:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104b43:	e8 b0 c1 ff ff       	call   100cf8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b48:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b4d:	8b 00                	mov    (%eax),%eax
  104b4f:	83 e0 04             	and    $0x4,%eax
  104b52:	85 c0                	test   %eax,%eax
  104b54:	75 24                	jne    104b7a <check_pgdir+0x395>
  104b56:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  104b5d:	00 
  104b5e:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104b65:	00 
  104b66:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104b6d:	00 
  104b6e:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104b75:	e8 7e c1 ff ff       	call   100cf8 <__panic>
    assert(page_ref(p2) == 1);
  104b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b7d:	89 04 24             	mov    %eax,(%esp)
  104b80:	e8 e3 f1 ff ff       	call   103d68 <page_ref>
  104b85:	83 f8 01             	cmp    $0x1,%eax
  104b88:	74 24                	je     104bae <check_pgdir+0x3c9>
  104b8a:	c7 44 24 0c ee 6d 10 	movl   $0x106dee,0xc(%esp)
  104b91:	00 
  104b92:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104b99:	00 
  104b9a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104ba1:	00 
  104ba2:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104ba9:	e8 4a c1 ff ff       	call   100cf8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104bae:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104bb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104bba:	00 
  104bbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bc2:	00 
  104bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104bc6:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bca:	89 04 24             	mov    %eax,(%esp)
  104bcd:	e8 d8 fa ff ff       	call   1046aa <page_insert>
  104bd2:	85 c0                	test   %eax,%eax
  104bd4:	74 24                	je     104bfa <check_pgdir+0x415>
  104bd6:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104bdd:	00 
  104bde:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104be5:	00 
  104be6:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104bed:	00 
  104bee:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104bf5:	e8 fe c0 ff ff       	call   100cf8 <__panic>
    assert(page_ref(p1) == 2);
  104bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bfd:	89 04 24             	mov    %eax,(%esp)
  104c00:	e8 63 f1 ff ff       	call   103d68 <page_ref>
  104c05:	83 f8 02             	cmp    $0x2,%eax
  104c08:	74 24                	je     104c2e <check_pgdir+0x449>
  104c0a:	c7 44 24 0c 2c 6e 10 	movl   $0x106e2c,0xc(%esp)
  104c11:	00 
  104c12:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104c19:	00 
  104c1a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104c21:	00 
  104c22:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104c29:	e8 ca c0 ff ff       	call   100cf8 <__panic>
    assert(page_ref(p2) == 0);
  104c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c31:	89 04 24             	mov    %eax,(%esp)
  104c34:	e8 2f f1 ff ff       	call   103d68 <page_ref>
  104c39:	85 c0                	test   %eax,%eax
  104c3b:	74 24                	je     104c61 <check_pgdir+0x47c>
  104c3d:	c7 44 24 0c 3e 6e 10 	movl   $0x106e3e,0xc(%esp)
  104c44:	00 
  104c45:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104c4c:	00 
  104c4d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104c54:	00 
  104c55:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104c5c:	e8 97 c0 ff ff       	call   100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c61:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104c66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c6d:	00 
  104c6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c75:	00 
  104c76:	89 04 24             	mov    %eax,(%esp)
  104c79:	e8 7e f9 ff ff       	call   1045fc <get_pte>
  104c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c85:	75 24                	jne    104cab <check_pgdir+0x4c6>
  104c87:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  104c8e:	00 
  104c8f:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104c96:	00 
  104c97:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104c9e:	00 
  104c9f:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104ca6:	e8 4d c0 ff ff       	call   100cf8 <__panic>
    assert(pte2page(*ptep) == p1);
  104cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cae:	8b 00                	mov    (%eax),%eax
  104cb0:	89 04 24             	mov    %eax,(%esp)
  104cb3:	e8 56 f0 ff ff       	call   103d0e <pte2page>
  104cb8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104cbb:	74 24                	je     104ce1 <check_pgdir+0x4fc>
  104cbd:	c7 44 24 0c 01 6d 10 	movl   $0x106d01,0xc(%esp)
  104cc4:	00 
  104cc5:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104ccc:	00 
  104ccd:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104cd4:	00 
  104cd5:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104cdc:	e8 17 c0 ff ff       	call   100cf8 <__panic>
    assert((*ptep & PTE_U) == 0);
  104ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce4:	8b 00                	mov    (%eax),%eax
  104ce6:	83 e0 04             	and    $0x4,%eax
  104ce9:	85 c0                	test   %eax,%eax
  104ceb:	74 24                	je     104d11 <check_pgdir+0x52c>
  104ced:	c7 44 24 0c 50 6e 10 	movl   $0x106e50,0xc(%esp)
  104cf4:	00 
  104cf5:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104cfc:	00 
  104cfd:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104d04:	00 
  104d05:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104d0c:	e8 e7 bf ff ff       	call   100cf8 <__panic>

    page_remove(boot_pgdir, 0x0);
  104d11:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d1d:	00 
  104d1e:	89 04 24             	mov    %eax,(%esp)
  104d21:	e8 3d f9 ff ff       	call   104663 <page_remove>
    assert(page_ref(p1) == 1);
  104d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d29:	89 04 24             	mov    %eax,(%esp)
  104d2c:	e8 37 f0 ff ff       	call   103d68 <page_ref>
  104d31:	83 f8 01             	cmp    $0x1,%eax
  104d34:	74 24                	je     104d5a <check_pgdir+0x575>
  104d36:	c7 44 24 0c 17 6d 10 	movl   $0x106d17,0xc(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104d45:	00 
  104d46:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104d4d:	00 
  104d4e:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104d55:	e8 9e bf ff ff       	call   100cf8 <__panic>
    assert(page_ref(p2) == 0);
  104d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d5d:	89 04 24             	mov    %eax,(%esp)
  104d60:	e8 03 f0 ff ff       	call   103d68 <page_ref>
  104d65:	85 c0                	test   %eax,%eax
  104d67:	74 24                	je     104d8d <check_pgdir+0x5a8>
  104d69:	c7 44 24 0c 3e 6e 10 	movl   $0x106e3e,0xc(%esp)
  104d70:	00 
  104d71:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104d78:	00 
  104d79:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104d80:	00 
  104d81:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104d88:	e8 6b bf ff ff       	call   100cf8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d8d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d92:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d99:	00 
  104d9a:	89 04 24             	mov    %eax,(%esp)
  104d9d:	e8 c1 f8 ff ff       	call   104663 <page_remove>
    assert(page_ref(p1) == 0);
  104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104da5:	89 04 24             	mov    %eax,(%esp)
  104da8:	e8 bb ef ff ff       	call   103d68 <page_ref>
  104dad:	85 c0                	test   %eax,%eax
  104daf:	74 24                	je     104dd5 <check_pgdir+0x5f0>
  104db1:	c7 44 24 0c 65 6e 10 	movl   $0x106e65,0xc(%esp)
  104db8:	00 
  104db9:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104dc0:	00 
  104dc1:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104dc8:	00 
  104dc9:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104dd0:	e8 23 bf ff ff       	call   100cf8 <__panic>
    assert(page_ref(p2) == 0);
  104dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dd8:	89 04 24             	mov    %eax,(%esp)
  104ddb:	e8 88 ef ff ff       	call   103d68 <page_ref>
  104de0:	85 c0                	test   %eax,%eax
  104de2:	74 24                	je     104e08 <check_pgdir+0x623>
  104de4:	c7 44 24 0c 3e 6e 10 	movl   $0x106e3e,0xc(%esp)
  104deb:	00 
  104dec:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104df3:	00 
  104df4:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104dfb:	00 
  104dfc:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104e03:	e8 f0 be ff ff       	call   100cf8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104e08:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e0d:	8b 00                	mov    (%eax),%eax
  104e0f:	89 04 24             	mov    %eax,(%esp)
  104e12:	e8 37 ef ff ff       	call   103d4e <pde2page>
  104e17:	89 04 24             	mov    %eax,(%esp)
  104e1a:	e8 49 ef ff ff       	call   103d68 <page_ref>
  104e1f:	83 f8 01             	cmp    $0x1,%eax
  104e22:	74 24                	je     104e48 <check_pgdir+0x663>
  104e24:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104e2b:	00 
  104e2c:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104e33:	00 
  104e34:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104e3b:	00 
  104e3c:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104e43:	e8 b0 be ff ff       	call   100cf8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104e48:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e4d:	8b 00                	mov    (%eax),%eax
  104e4f:	89 04 24             	mov    %eax,(%esp)
  104e52:	e8 f7 ee ff ff       	call   103d4e <pde2page>
  104e57:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e5e:	00 
  104e5f:	89 04 24             	mov    %eax,(%esp)
  104e62:	e8 3d f1 ff ff       	call   103fa4 <free_pages>
    boot_pgdir[0] = 0;
  104e67:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e72:	c7 04 24 9f 6e 10 00 	movl   $0x106e9f,(%esp)
  104e79:	e8 e7 b4 ff ff       	call   100365 <cprintf>
}
  104e7e:	90                   	nop
  104e7f:	89 ec                	mov    %ebp,%esp
  104e81:	5d                   	pop    %ebp
  104e82:	c3                   	ret    

00104e83 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e83:	55                   	push   %ebp
  104e84:	89 e5                	mov    %esp,%ebp
  104e86:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e90:	e9 ca 00 00 00       	jmp    104f5f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e9e:	c1 e8 0c             	shr    $0xc,%eax
  104ea1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104ea4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104ea9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104eac:	72 23                	jb     104ed1 <check_boot_pgdir+0x4e>
  104eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104eb5:	c7 44 24 08 e4 6a 10 	movl   $0x106ae4,0x8(%esp)
  104ebc:	00 
  104ebd:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104ec4:	00 
  104ec5:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104ecc:	e8 27 be ff ff       	call   100cf8 <__panic>
  104ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ed4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ed9:	89 c2                	mov    %eax,%edx
  104edb:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ee0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ee7:	00 
  104ee8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104eec:	89 04 24             	mov    %eax,(%esp)
  104eef:	e8 08 f7 ff ff       	call   1045fc <get_pte>
  104ef4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ef7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104efb:	75 24                	jne    104f21 <check_boot_pgdir+0x9e>
  104efd:	c7 44 24 0c bc 6e 10 	movl   $0x106ebc,0xc(%esp)
  104f04:	00 
  104f05:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104f0c:	00 
  104f0d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104f14:	00 
  104f15:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104f1c:	e8 d7 bd ff ff       	call   100cf8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f24:	8b 00                	mov    (%eax),%eax
  104f26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f2b:	89 c2                	mov    %eax,%edx
  104f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f30:	39 c2                	cmp    %eax,%edx
  104f32:	74 24                	je     104f58 <check_boot_pgdir+0xd5>
  104f34:	c7 44 24 0c f9 6e 10 	movl   $0x106ef9,0xc(%esp)
  104f3b:	00 
  104f3c:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104f43:	00 
  104f44:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104f4b:	00 
  104f4c:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104f53:	e8 a0 bd ff ff       	call   100cf8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104f58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f62:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104f67:	39 c2                	cmp    %eax,%edx
  104f69:	0f 82 26 ff ff ff    	jb     104e95 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f6f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f74:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f79:	8b 00                	mov    (%eax),%eax
  104f7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f80:	89 c2                	mov    %eax,%edx
  104f82:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f8a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104f91:	77 23                	ja     104fb6 <check_boot_pgdir+0x133>
  104f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f96:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f9a:	c7 44 24 08 88 6b 10 	movl   $0x106b88,0x8(%esp)
  104fa1:	00 
  104fa2:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104fa9:	00 
  104faa:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104fb1:	e8 42 bd ff ff       	call   100cf8 <__panic>
  104fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fb9:	05 00 00 00 40       	add    $0x40000000,%eax
  104fbe:	39 d0                	cmp    %edx,%eax
  104fc0:	74 24                	je     104fe6 <check_boot_pgdir+0x163>
  104fc2:	c7 44 24 0c 10 6f 10 	movl   $0x106f10,0xc(%esp)
  104fc9:	00 
  104fca:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  104fd1:	00 
  104fd2:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104fd9:	00 
  104fda:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  104fe1:	e8 12 bd ff ff       	call   100cf8 <__panic>

    assert(boot_pgdir[0] == 0);
  104fe6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104feb:	8b 00                	mov    (%eax),%eax
  104fed:	85 c0                	test   %eax,%eax
  104fef:	74 24                	je     105015 <check_boot_pgdir+0x192>
  104ff1:	c7 44 24 0c 44 6f 10 	movl   $0x106f44,0xc(%esp)
  104ff8:	00 
  104ff9:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  105000:	00 
  105001:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  105008:	00 
  105009:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  105010:	e8 e3 bc ff ff       	call   100cf8 <__panic>

    struct Page *p;
    p = alloc_page();
  105015:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10501c:	e8 49 ef ff ff       	call   103f6a <alloc_pages>
  105021:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105024:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105030:	00 
  105031:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105038:	00 
  105039:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10503c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105040:	89 04 24             	mov    %eax,(%esp)
  105043:	e8 62 f6 ff ff       	call   1046aa <page_insert>
  105048:	85 c0                	test   %eax,%eax
  10504a:	74 24                	je     105070 <check_boot_pgdir+0x1ed>
  10504c:	c7 44 24 0c 58 6f 10 	movl   $0x106f58,0xc(%esp)
  105053:	00 
  105054:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  10505b:	00 
  10505c:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  105063:	00 
  105064:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10506b:	e8 88 bc ff ff       	call   100cf8 <__panic>
    assert(page_ref(p) == 1);
  105070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105073:	89 04 24             	mov    %eax,(%esp)
  105076:	e8 ed ec ff ff       	call   103d68 <page_ref>
  10507b:	83 f8 01             	cmp    $0x1,%eax
  10507e:	74 24                	je     1050a4 <check_boot_pgdir+0x221>
  105080:	c7 44 24 0c 86 6f 10 	movl   $0x106f86,0xc(%esp)
  105087:	00 
  105088:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  10508f:	00 
  105090:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  105097:	00 
  105098:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10509f:	e8 54 bc ff ff       	call   100cf8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1050a4:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1050a9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050b0:	00 
  1050b1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050b8:	00 
  1050b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050c0:	89 04 24             	mov    %eax,(%esp)
  1050c3:	e8 e2 f5 ff ff       	call   1046aa <page_insert>
  1050c8:	85 c0                	test   %eax,%eax
  1050ca:	74 24                	je     1050f0 <check_boot_pgdir+0x26d>
  1050cc:	c7 44 24 0c 98 6f 10 	movl   $0x106f98,0xc(%esp)
  1050d3:	00 
  1050d4:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  1050db:	00 
  1050dc:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  1050e3:	00 
  1050e4:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1050eb:	e8 08 bc ff ff       	call   100cf8 <__panic>
    assert(page_ref(p) == 2);
  1050f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050f3:	89 04 24             	mov    %eax,(%esp)
  1050f6:	e8 6d ec ff ff       	call   103d68 <page_ref>
  1050fb:	83 f8 02             	cmp    $0x2,%eax
  1050fe:	74 24                	je     105124 <check_boot_pgdir+0x2a1>
  105100:	c7 44 24 0c cf 6f 10 	movl   $0x106fcf,0xc(%esp)
  105107:	00 
  105108:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  10510f:	00 
  105110:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105117:	00 
  105118:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  10511f:	e8 d4 bb ff ff       	call   100cf8 <__panic>

    const char *str = "ucore: Hello world!!";
  105124:	c7 45 e8 e0 6f 10 00 	movl   $0x106fe0,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10512b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10512e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105132:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105139:	e8 fc 09 00 00       	call   105b3a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10513e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105145:	00 
  105146:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10514d:	e8 60 0a 00 00       	call   105bb2 <strcmp>
  105152:	85 c0                	test   %eax,%eax
  105154:	74 24                	je     10517a <check_boot_pgdir+0x2f7>
  105156:	c7 44 24 0c f8 6f 10 	movl   $0x106ff8,0xc(%esp)
  10515d:	00 
  10515e:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  105165:	00 
  105166:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  10516d:	00 
  10516e:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  105175:	e8 7e bb ff ff       	call   100cf8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10517a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10517d:	89 04 24             	mov    %eax,(%esp)
  105180:	e8 33 eb ff ff       	call   103cb8 <page2kva>
  105185:	05 00 01 00 00       	add    $0x100,%eax
  10518a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10518d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105194:	e8 47 09 00 00       	call   105ae0 <strlen>
  105199:	85 c0                	test   %eax,%eax
  10519b:	74 24                	je     1051c1 <check_boot_pgdir+0x33e>
  10519d:	c7 44 24 0c 30 70 10 	movl   $0x107030,0xc(%esp)
  1051a4:	00 
  1051a5:	c7 44 24 08 d1 6b 10 	movl   $0x106bd1,0x8(%esp)
  1051ac:	00 
  1051ad:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  1051b4:	00 
  1051b5:	c7 04 24 ac 6b 10 00 	movl   $0x106bac,(%esp)
  1051bc:	e8 37 bb ff ff       	call   100cf8 <__panic>

    free_page(p);
  1051c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051c8:	00 
  1051c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051cc:	89 04 24             	mov    %eax,(%esp)
  1051cf:	e8 d0 ed ff ff       	call   103fa4 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1051d4:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051d9:	8b 00                	mov    (%eax),%eax
  1051db:	89 04 24             	mov    %eax,(%esp)
  1051de:	e8 6b eb ff ff       	call   103d4e <pde2page>
  1051e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051ea:	00 
  1051eb:	89 04 24             	mov    %eax,(%esp)
  1051ee:	e8 b1 ed ff ff       	call   103fa4 <free_pages>
    boot_pgdir[0] = 0;
  1051f3:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1051f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051fe:	c7 04 24 54 70 10 00 	movl   $0x107054,(%esp)
  105205:	e8 5b b1 ff ff       	call   100365 <cprintf>
}
  10520a:	90                   	nop
  10520b:	89 ec                	mov    %ebp,%esp
  10520d:	5d                   	pop    %ebp
  10520e:	c3                   	ret    

0010520f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10520f:	55                   	push   %ebp
  105210:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105212:	8b 45 08             	mov    0x8(%ebp),%eax
  105215:	83 e0 04             	and    $0x4,%eax
  105218:	85 c0                	test   %eax,%eax
  10521a:	74 04                	je     105220 <perm2str+0x11>
  10521c:	b0 75                	mov    $0x75,%al
  10521e:	eb 02                	jmp    105222 <perm2str+0x13>
  105220:	b0 2d                	mov    $0x2d,%al
  105222:	a2 28 bf 11 00       	mov    %al,0x11bf28
    str[1] = 'r';
  105227:	c6 05 29 bf 11 00 72 	movb   $0x72,0x11bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10522e:	8b 45 08             	mov    0x8(%ebp),%eax
  105231:	83 e0 02             	and    $0x2,%eax
  105234:	85 c0                	test   %eax,%eax
  105236:	74 04                	je     10523c <perm2str+0x2d>
  105238:	b0 77                	mov    $0x77,%al
  10523a:	eb 02                	jmp    10523e <perm2str+0x2f>
  10523c:	b0 2d                	mov    $0x2d,%al
  10523e:	a2 2a bf 11 00       	mov    %al,0x11bf2a
    str[3] = '\0';
  105243:	c6 05 2b bf 11 00 00 	movb   $0x0,0x11bf2b
    return str;
  10524a:	b8 28 bf 11 00       	mov    $0x11bf28,%eax
}
  10524f:	5d                   	pop    %ebp
  105250:	c3                   	ret    

00105251 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105251:	55                   	push   %ebp
  105252:	89 e5                	mov    %esp,%ebp
  105254:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105257:	8b 45 10             	mov    0x10(%ebp),%eax
  10525a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525d:	72 0d                	jb     10526c <get_pgtable_items+0x1b>
        return 0;
  10525f:	b8 00 00 00 00       	mov    $0x0,%eax
  105264:	e9 98 00 00 00       	jmp    105301 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  105269:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10526c:	8b 45 10             	mov    0x10(%ebp),%eax
  10526f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105272:	73 18                	jae    10528c <get_pgtable_items+0x3b>
  105274:	8b 45 10             	mov    0x10(%ebp),%eax
  105277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10527e:	8b 45 14             	mov    0x14(%ebp),%eax
  105281:	01 d0                	add    %edx,%eax
  105283:	8b 00                	mov    (%eax),%eax
  105285:	83 e0 01             	and    $0x1,%eax
  105288:	85 c0                	test   %eax,%eax
  10528a:	74 dd                	je     105269 <get_pgtable_items+0x18>
    }
    if (start < right) {
  10528c:	8b 45 10             	mov    0x10(%ebp),%eax
  10528f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105292:	73 68                	jae    1052fc <get_pgtable_items+0xab>
        if (left_store != NULL) {
  105294:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105298:	74 08                	je     1052a2 <get_pgtable_items+0x51>
            *left_store = start;
  10529a:	8b 45 18             	mov    0x18(%ebp),%eax
  10529d:	8b 55 10             	mov    0x10(%ebp),%edx
  1052a0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1052a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1052a5:	8d 50 01             	lea    0x1(%eax),%edx
  1052a8:	89 55 10             	mov    %edx,0x10(%ebp)
  1052ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052b2:	8b 45 14             	mov    0x14(%ebp),%eax
  1052b5:	01 d0                	add    %edx,%eax
  1052b7:	8b 00                	mov    (%eax),%eax
  1052b9:	83 e0 07             	and    $0x7,%eax
  1052bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052bf:	eb 03                	jmp    1052c4 <get_pgtable_items+0x73>
            start ++;
  1052c1:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1052c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052ca:	73 1d                	jae    1052e9 <get_pgtable_items+0x98>
  1052cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1052d9:	01 d0                	add    %edx,%eax
  1052db:	8b 00                	mov    (%eax),%eax
  1052dd:	83 e0 07             	and    $0x7,%eax
  1052e0:	89 c2                	mov    %eax,%edx
  1052e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052e5:	39 c2                	cmp    %eax,%edx
  1052e7:	74 d8                	je     1052c1 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1052e9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052ed:	74 08                	je     1052f7 <get_pgtable_items+0xa6>
            *right_store = start;
  1052ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052f2:	8b 55 10             	mov    0x10(%ebp),%edx
  1052f5:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052fa:	eb 05                	jmp    105301 <get_pgtable_items+0xb0>
    }
    return 0;
  1052fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105301:	89 ec                	mov    %ebp,%esp
  105303:	5d                   	pop    %ebp
  105304:	c3                   	ret    

00105305 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105305:	55                   	push   %ebp
  105306:	89 e5                	mov    %esp,%ebp
  105308:	57                   	push   %edi
  105309:	56                   	push   %esi
  10530a:	53                   	push   %ebx
  10530b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10530e:	c7 04 24 74 70 10 00 	movl   $0x107074,(%esp)
  105315:	e8 4b b0 ff ff       	call   100365 <cprintf>
    size_t left, right = 0, perm;
  10531a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105321:	e9 f2 00 00 00       	jmp    105418 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105329:	89 04 24             	mov    %eax,(%esp)
  10532c:	e8 de fe ff ff       	call   10520f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105331:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105334:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105337:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105339:	89 d6                	mov    %edx,%esi
  10533b:	c1 e6 16             	shl    $0x16,%esi
  10533e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105341:	89 d3                	mov    %edx,%ebx
  105343:	c1 e3 16             	shl    $0x16,%ebx
  105346:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105349:	89 d1                	mov    %edx,%ecx
  10534b:	c1 e1 16             	shl    $0x16,%ecx
  10534e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105351:	8b 7d e0             	mov    -0x20(%ebp),%edi
  105354:	29 fa                	sub    %edi,%edx
  105356:	89 44 24 14          	mov    %eax,0x14(%esp)
  10535a:	89 74 24 10          	mov    %esi,0x10(%esp)
  10535e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105362:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105366:	89 54 24 04          	mov    %edx,0x4(%esp)
  10536a:	c7 04 24 a5 70 10 00 	movl   $0x1070a5,(%esp)
  105371:	e8 ef af ff ff       	call   100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
  105376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105379:	c1 e0 0a             	shl    $0xa,%eax
  10537c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10537f:	eb 50                	jmp    1053d1 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105384:	89 04 24             	mov    %eax,(%esp)
  105387:	e8 83 fe ff ff       	call   10520f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10538c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10538f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105392:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105394:	89 d6                	mov    %edx,%esi
  105396:	c1 e6 0c             	shl    $0xc,%esi
  105399:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10539c:	89 d3                	mov    %edx,%ebx
  10539e:	c1 e3 0c             	shl    $0xc,%ebx
  1053a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053a4:	89 d1                	mov    %edx,%ecx
  1053a6:	c1 e1 0c             	shl    $0xc,%ecx
  1053a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053ac:	8b 7d d8             	mov    -0x28(%ebp),%edi
  1053af:	29 fa                	sub    %edi,%edx
  1053b1:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053b5:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053b9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053c5:	c7 04 24 c4 70 10 00 	movl   $0x1070c4,(%esp)
  1053cc:	e8 94 af ff ff       	call   100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053d1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1053d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053dc:	89 d3                	mov    %edx,%ebx
  1053de:	c1 e3 0a             	shl    $0xa,%ebx
  1053e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053e4:	89 d1                	mov    %edx,%ecx
  1053e6:	c1 e1 0a             	shl    $0xa,%ecx
  1053e9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1053ec:	89 54 24 14          	mov    %edx,0x14(%esp)
  1053f0:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1053f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  1053f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1053fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105403:	89 0c 24             	mov    %ecx,(%esp)
  105406:	e8 46 fe ff ff       	call   105251 <get_pgtable_items>
  10540b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10540e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105412:	0f 85 69 ff ff ff    	jne    105381 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105418:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10541d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105420:	8d 55 dc             	lea    -0x24(%ebp),%edx
  105423:	89 54 24 14          	mov    %edx,0x14(%esp)
  105427:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10542a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10542e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105432:	89 44 24 08          	mov    %eax,0x8(%esp)
  105436:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10543d:	00 
  10543e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105445:	e8 07 fe ff ff       	call   105251 <get_pgtable_items>
  10544a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10544d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105451:	0f 85 cf fe ff ff    	jne    105326 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105457:	c7 04 24 e8 70 10 00 	movl   $0x1070e8,(%esp)
  10545e:	e8 02 af ff ff       	call   100365 <cprintf>
}
  105463:	90                   	nop
  105464:	83 c4 4c             	add    $0x4c,%esp
  105467:	5b                   	pop    %ebx
  105468:	5e                   	pop    %esi
  105469:	5f                   	pop    %edi
  10546a:	5d                   	pop    %ebp
  10546b:	c3                   	ret    

0010546c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10546c:	55                   	push   %ebp
  10546d:	89 e5                	mov    %esp,%ebp
  10546f:	83 ec 58             	sub    $0x58,%esp
  105472:	8b 45 10             	mov    0x10(%ebp),%eax
  105475:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105478:	8b 45 14             	mov    0x14(%ebp),%eax
  10547b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10547e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105481:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105484:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105487:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10548a:	8b 45 18             	mov    0x18(%ebp),%eax
  10548d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105499:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10549c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10549f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1054a6:	74 1c                	je     1054c4 <printnum+0x58>
  1054a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1054b0:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054b9:	ba 00 00 00 00       	mov    $0x0,%edx
  1054be:	f7 75 e4             	divl   -0x1c(%ebp)
  1054c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054ca:	f7 75 e4             	divl   -0x1c(%ebp)
  1054cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054dc:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054e2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054e5:	8b 45 18             	mov    0x18(%ebp),%eax
  1054e8:	ba 00 00 00 00       	mov    $0x0,%edx
  1054ed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1054f0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1054f3:	19 d1                	sbb    %edx,%ecx
  1054f5:	72 4c                	jb     105543 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054fd:	8b 45 20             	mov    0x20(%ebp),%eax
  105500:	89 44 24 18          	mov    %eax,0x18(%esp)
  105504:	89 54 24 14          	mov    %edx,0x14(%esp)
  105508:	8b 45 18             	mov    0x18(%ebp),%eax
  10550b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10550f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105512:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105515:	89 44 24 08          	mov    %eax,0x8(%esp)
  105519:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10551d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105520:	89 44 24 04          	mov    %eax,0x4(%esp)
  105524:	8b 45 08             	mov    0x8(%ebp),%eax
  105527:	89 04 24             	mov    %eax,(%esp)
  10552a:	e8 3d ff ff ff       	call   10546c <printnum>
  10552f:	eb 1b                	jmp    10554c <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105531:	8b 45 0c             	mov    0xc(%ebp),%eax
  105534:	89 44 24 04          	mov    %eax,0x4(%esp)
  105538:	8b 45 20             	mov    0x20(%ebp),%eax
  10553b:	89 04 24             	mov    %eax,(%esp)
  10553e:	8b 45 08             	mov    0x8(%ebp),%eax
  105541:	ff d0                	call   *%eax
        while (-- width > 0)
  105543:	ff 4d 1c             	decl   0x1c(%ebp)
  105546:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10554a:	7f e5                	jg     105531 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10554c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10554f:	05 9c 71 10 00       	add    $0x10719c,%eax
  105554:	0f b6 00             	movzbl (%eax),%eax
  105557:	0f be c0             	movsbl %al,%eax
  10555a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10555d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105561:	89 04 24             	mov    %eax,(%esp)
  105564:	8b 45 08             	mov    0x8(%ebp),%eax
  105567:	ff d0                	call   *%eax
}
  105569:	90                   	nop
  10556a:	89 ec                	mov    %ebp,%esp
  10556c:	5d                   	pop    %ebp
  10556d:	c3                   	ret    

0010556e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10556e:	55                   	push   %ebp
  10556f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105575:	7e 14                	jle    10558b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105577:	8b 45 08             	mov    0x8(%ebp),%eax
  10557a:	8b 00                	mov    (%eax),%eax
  10557c:	8d 48 08             	lea    0x8(%eax),%ecx
  10557f:	8b 55 08             	mov    0x8(%ebp),%edx
  105582:	89 0a                	mov    %ecx,(%edx)
  105584:	8b 50 04             	mov    0x4(%eax),%edx
  105587:	8b 00                	mov    (%eax),%eax
  105589:	eb 30                	jmp    1055bb <getuint+0x4d>
    }
    else if (lflag) {
  10558b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10558f:	74 16                	je     1055a7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105591:	8b 45 08             	mov    0x8(%ebp),%eax
  105594:	8b 00                	mov    (%eax),%eax
  105596:	8d 48 04             	lea    0x4(%eax),%ecx
  105599:	8b 55 08             	mov    0x8(%ebp),%edx
  10559c:	89 0a                	mov    %ecx,(%edx)
  10559e:	8b 00                	mov    (%eax),%eax
  1055a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1055a5:	eb 14                	jmp    1055bb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1055a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055aa:	8b 00                	mov    (%eax),%eax
  1055ac:	8d 48 04             	lea    0x4(%eax),%ecx
  1055af:	8b 55 08             	mov    0x8(%ebp),%edx
  1055b2:	89 0a                	mov    %ecx,(%edx)
  1055b4:	8b 00                	mov    (%eax),%eax
  1055b6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055bb:	5d                   	pop    %ebp
  1055bc:	c3                   	ret    

001055bd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055bd:	55                   	push   %ebp
  1055be:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055c4:	7e 14                	jle    1055da <getint+0x1d>
        return va_arg(*ap, long long);
  1055c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c9:	8b 00                	mov    (%eax),%eax
  1055cb:	8d 48 08             	lea    0x8(%eax),%ecx
  1055ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1055d1:	89 0a                	mov    %ecx,(%edx)
  1055d3:	8b 50 04             	mov    0x4(%eax),%edx
  1055d6:	8b 00                	mov    (%eax),%eax
  1055d8:	eb 28                	jmp    105602 <getint+0x45>
    }
    else if (lflag) {
  1055da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055de:	74 12                	je     1055f2 <getint+0x35>
        return va_arg(*ap, long);
  1055e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e3:	8b 00                	mov    (%eax),%eax
  1055e5:	8d 48 04             	lea    0x4(%eax),%ecx
  1055e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055eb:	89 0a                	mov    %ecx,(%edx)
  1055ed:	8b 00                	mov    (%eax),%eax
  1055ef:	99                   	cltd   
  1055f0:	eb 10                	jmp    105602 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f5:	8b 00                	mov    (%eax),%eax
  1055f7:	8d 48 04             	lea    0x4(%eax),%ecx
  1055fa:	8b 55 08             	mov    0x8(%ebp),%edx
  1055fd:	89 0a                	mov    %ecx,(%edx)
  1055ff:	8b 00                	mov    (%eax),%eax
  105601:	99                   	cltd   
    }
}
  105602:	5d                   	pop    %ebp
  105603:	c3                   	ret    

00105604 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105604:	55                   	push   %ebp
  105605:	89 e5                	mov    %esp,%ebp
  105607:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10560a:	8d 45 14             	lea    0x14(%ebp),%eax
  10560d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105613:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105617:	8b 45 10             	mov    0x10(%ebp),%eax
  10561a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10561e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105621:	89 44 24 04          	mov    %eax,0x4(%esp)
  105625:	8b 45 08             	mov    0x8(%ebp),%eax
  105628:	89 04 24             	mov    %eax,(%esp)
  10562b:	e8 05 00 00 00       	call   105635 <vprintfmt>
    va_end(ap);
}
  105630:	90                   	nop
  105631:	89 ec                	mov    %ebp,%esp
  105633:	5d                   	pop    %ebp
  105634:	c3                   	ret    

00105635 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105635:	55                   	push   %ebp
  105636:	89 e5                	mov    %esp,%ebp
  105638:	56                   	push   %esi
  105639:	53                   	push   %ebx
  10563a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10563d:	eb 17                	jmp    105656 <vprintfmt+0x21>
            if (ch == '\0') {
  10563f:	85 db                	test   %ebx,%ebx
  105641:	0f 84 bf 03 00 00    	je     105a06 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105647:	8b 45 0c             	mov    0xc(%ebp),%eax
  10564a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10564e:	89 1c 24             	mov    %ebx,(%esp)
  105651:	8b 45 08             	mov    0x8(%ebp),%eax
  105654:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105656:	8b 45 10             	mov    0x10(%ebp),%eax
  105659:	8d 50 01             	lea    0x1(%eax),%edx
  10565c:	89 55 10             	mov    %edx,0x10(%ebp)
  10565f:	0f b6 00             	movzbl (%eax),%eax
  105662:	0f b6 d8             	movzbl %al,%ebx
  105665:	83 fb 25             	cmp    $0x25,%ebx
  105668:	75 d5                	jne    10563f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10566a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10566e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105678:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10567b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105682:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105685:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105688:	8b 45 10             	mov    0x10(%ebp),%eax
  10568b:	8d 50 01             	lea    0x1(%eax),%edx
  10568e:	89 55 10             	mov    %edx,0x10(%ebp)
  105691:	0f b6 00             	movzbl (%eax),%eax
  105694:	0f b6 d8             	movzbl %al,%ebx
  105697:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10569a:	83 f8 55             	cmp    $0x55,%eax
  10569d:	0f 87 37 03 00 00    	ja     1059da <vprintfmt+0x3a5>
  1056a3:	8b 04 85 c0 71 10 00 	mov    0x1071c0(,%eax,4),%eax
  1056aa:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1056ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056b0:	eb d6                	jmp    105688 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056b6:	eb d0                	jmp    105688 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056c2:	89 d0                	mov    %edx,%eax
  1056c4:	c1 e0 02             	shl    $0x2,%eax
  1056c7:	01 d0                	add    %edx,%eax
  1056c9:	01 c0                	add    %eax,%eax
  1056cb:	01 d8                	add    %ebx,%eax
  1056cd:	83 e8 30             	sub    $0x30,%eax
  1056d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1056d6:	0f b6 00             	movzbl (%eax),%eax
  1056d9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056dc:	83 fb 2f             	cmp    $0x2f,%ebx
  1056df:	7e 38                	jle    105719 <vprintfmt+0xe4>
  1056e1:	83 fb 39             	cmp    $0x39,%ebx
  1056e4:	7f 33                	jg     105719 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1056e6:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1056e9:	eb d4                	jmp    1056bf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1056eb:	8b 45 14             	mov    0x14(%ebp),%eax
  1056ee:	8d 50 04             	lea    0x4(%eax),%edx
  1056f1:	89 55 14             	mov    %edx,0x14(%ebp)
  1056f4:	8b 00                	mov    (%eax),%eax
  1056f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056f9:	eb 1f                	jmp    10571a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1056fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056ff:	79 87                	jns    105688 <vprintfmt+0x53>
                width = 0;
  105701:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105708:	e9 7b ff ff ff       	jmp    105688 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10570d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105714:	e9 6f ff ff ff       	jmp    105688 <vprintfmt+0x53>
            goto process_precision;
  105719:	90                   	nop

        process_precision:
            if (width < 0)
  10571a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10571e:	0f 89 64 ff ff ff    	jns    105688 <vprintfmt+0x53>
                width = precision, precision = -1;
  105724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105727:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10572a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105731:	e9 52 ff ff ff       	jmp    105688 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105736:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105739:	e9 4a ff ff ff       	jmp    105688 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10573e:	8b 45 14             	mov    0x14(%ebp),%eax
  105741:	8d 50 04             	lea    0x4(%eax),%edx
  105744:	89 55 14             	mov    %edx,0x14(%ebp)
  105747:	8b 00                	mov    (%eax),%eax
  105749:	8b 55 0c             	mov    0xc(%ebp),%edx
  10574c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105750:	89 04 24             	mov    %eax,(%esp)
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	ff d0                	call   *%eax
            break;
  105758:	e9 a4 02 00 00       	jmp    105a01 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10575d:	8b 45 14             	mov    0x14(%ebp),%eax
  105760:	8d 50 04             	lea    0x4(%eax),%edx
  105763:	89 55 14             	mov    %edx,0x14(%ebp)
  105766:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105768:	85 db                	test   %ebx,%ebx
  10576a:	79 02                	jns    10576e <vprintfmt+0x139>
                err = -err;
  10576c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10576e:	83 fb 06             	cmp    $0x6,%ebx
  105771:	7f 0b                	jg     10577e <vprintfmt+0x149>
  105773:	8b 34 9d 80 71 10 00 	mov    0x107180(,%ebx,4),%esi
  10577a:	85 f6                	test   %esi,%esi
  10577c:	75 23                	jne    1057a1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  10577e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105782:	c7 44 24 08 ad 71 10 	movl   $0x1071ad,0x8(%esp)
  105789:	00 
  10578a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105791:	8b 45 08             	mov    0x8(%ebp),%eax
  105794:	89 04 24             	mov    %eax,(%esp)
  105797:	e8 68 fe ff ff       	call   105604 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10579c:	e9 60 02 00 00       	jmp    105a01 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1057a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1057a5:	c7 44 24 08 b6 71 10 	movl   $0x1071b6,0x8(%esp)
  1057ac:	00 
  1057ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b7:	89 04 24             	mov    %eax,(%esp)
  1057ba:	e8 45 fe ff ff       	call   105604 <printfmt>
            break;
  1057bf:	e9 3d 02 00 00       	jmp    105a01 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057c4:	8b 45 14             	mov    0x14(%ebp),%eax
  1057c7:	8d 50 04             	lea    0x4(%eax),%edx
  1057ca:	89 55 14             	mov    %edx,0x14(%ebp)
  1057cd:	8b 30                	mov    (%eax),%esi
  1057cf:	85 f6                	test   %esi,%esi
  1057d1:	75 05                	jne    1057d8 <vprintfmt+0x1a3>
                p = "(null)";
  1057d3:	be b9 71 10 00       	mov    $0x1071b9,%esi
            }
            if (width > 0 && padc != '-') {
  1057d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057dc:	7e 76                	jle    105854 <vprintfmt+0x21f>
  1057de:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057e2:	74 70                	je     105854 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057eb:	89 34 24             	mov    %esi,(%esp)
  1057ee:	e8 16 03 00 00       	call   105b09 <strnlen>
  1057f3:	89 c2                	mov    %eax,%edx
  1057f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057f8:	29 d0                	sub    %edx,%eax
  1057fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057fd:	eb 16                	jmp    105815 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1057ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105803:	8b 55 0c             	mov    0xc(%ebp),%edx
  105806:	89 54 24 04          	mov    %edx,0x4(%esp)
  10580a:	89 04 24             	mov    %eax,(%esp)
  10580d:	8b 45 08             	mov    0x8(%ebp),%eax
  105810:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105812:	ff 4d e8             	decl   -0x18(%ebp)
  105815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105819:	7f e4                	jg     1057ff <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10581b:	eb 37                	jmp    105854 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10581d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105821:	74 1f                	je     105842 <vprintfmt+0x20d>
  105823:	83 fb 1f             	cmp    $0x1f,%ebx
  105826:	7e 05                	jle    10582d <vprintfmt+0x1f8>
  105828:	83 fb 7e             	cmp    $0x7e,%ebx
  10582b:	7e 15                	jle    105842 <vprintfmt+0x20d>
                    putch('?', putdat);
  10582d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105830:	89 44 24 04          	mov    %eax,0x4(%esp)
  105834:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10583b:	8b 45 08             	mov    0x8(%ebp),%eax
  10583e:	ff d0                	call   *%eax
  105840:	eb 0f                	jmp    105851 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105842:	8b 45 0c             	mov    0xc(%ebp),%eax
  105845:	89 44 24 04          	mov    %eax,0x4(%esp)
  105849:	89 1c 24             	mov    %ebx,(%esp)
  10584c:	8b 45 08             	mov    0x8(%ebp),%eax
  10584f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105851:	ff 4d e8             	decl   -0x18(%ebp)
  105854:	89 f0                	mov    %esi,%eax
  105856:	8d 70 01             	lea    0x1(%eax),%esi
  105859:	0f b6 00             	movzbl (%eax),%eax
  10585c:	0f be d8             	movsbl %al,%ebx
  10585f:	85 db                	test   %ebx,%ebx
  105861:	74 27                	je     10588a <vprintfmt+0x255>
  105863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105867:	78 b4                	js     10581d <vprintfmt+0x1e8>
  105869:	ff 4d e4             	decl   -0x1c(%ebp)
  10586c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105870:	79 ab                	jns    10581d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105872:	eb 16                	jmp    10588a <vprintfmt+0x255>
                putch(' ', putdat);
  105874:	8b 45 0c             	mov    0xc(%ebp),%eax
  105877:	89 44 24 04          	mov    %eax,0x4(%esp)
  10587b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105882:	8b 45 08             	mov    0x8(%ebp),%eax
  105885:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105887:	ff 4d e8             	decl   -0x18(%ebp)
  10588a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10588e:	7f e4                	jg     105874 <vprintfmt+0x23f>
            }
            break;
  105890:	e9 6c 01 00 00       	jmp    105a01 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105898:	89 44 24 04          	mov    %eax,0x4(%esp)
  10589c:	8d 45 14             	lea    0x14(%ebp),%eax
  10589f:	89 04 24             	mov    %eax,(%esp)
  1058a2:	e8 16 fd ff ff       	call   1055bd <getint>
  1058a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058b3:	85 d2                	test   %edx,%edx
  1058b5:	79 26                	jns    1058dd <vprintfmt+0x2a8>
                putch('-', putdat);
  1058b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058be:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c8:	ff d0                	call   *%eax
                num = -(long long)num;
  1058ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058d0:	f7 d8                	neg    %eax
  1058d2:	83 d2 00             	adc    $0x0,%edx
  1058d5:	f7 da                	neg    %edx
  1058d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058e4:	e9 a8 00 00 00       	jmp    105991 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1058f3:	89 04 24             	mov    %eax,(%esp)
  1058f6:	e8 73 fc ff ff       	call   10556e <getuint>
  1058fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105901:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105908:	e9 84 00 00 00       	jmp    105991 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10590d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105910:	89 44 24 04          	mov    %eax,0x4(%esp)
  105914:	8d 45 14             	lea    0x14(%ebp),%eax
  105917:	89 04 24             	mov    %eax,(%esp)
  10591a:	e8 4f fc ff ff       	call   10556e <getuint>
  10591f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105922:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105925:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10592c:	eb 63                	jmp    105991 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10592e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105931:	89 44 24 04          	mov    %eax,0x4(%esp)
  105935:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10593c:	8b 45 08             	mov    0x8(%ebp),%eax
  10593f:	ff d0                	call   *%eax
            putch('x', putdat);
  105941:	8b 45 0c             	mov    0xc(%ebp),%eax
  105944:	89 44 24 04          	mov    %eax,0x4(%esp)
  105948:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10594f:	8b 45 08             	mov    0x8(%ebp),%eax
  105952:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105954:	8b 45 14             	mov    0x14(%ebp),%eax
  105957:	8d 50 04             	lea    0x4(%eax),%edx
  10595a:	89 55 14             	mov    %edx,0x14(%ebp)
  10595d:	8b 00                	mov    (%eax),%eax
  10595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105969:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105970:	eb 1f                	jmp    105991 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105972:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105975:	89 44 24 04          	mov    %eax,0x4(%esp)
  105979:	8d 45 14             	lea    0x14(%ebp),%eax
  10597c:	89 04 24             	mov    %eax,(%esp)
  10597f:	e8 ea fb ff ff       	call   10556e <getuint>
  105984:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105987:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10598a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105991:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105998:	89 54 24 18          	mov    %edx,0x18(%esp)
  10599c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10599f:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1059a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bf:	89 04 24             	mov    %eax,(%esp)
  1059c2:	e8 a5 fa ff ff       	call   10546c <printnum>
            break;
  1059c7:	eb 38                	jmp    105a01 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d0:	89 1c 24             	mov    %ebx,(%esp)
  1059d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d6:	ff d0                	call   *%eax
            break;
  1059d8:	eb 27                	jmp    105a01 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059eb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059ed:	ff 4d 10             	decl   0x10(%ebp)
  1059f0:	eb 03                	jmp    1059f5 <vprintfmt+0x3c0>
  1059f2:	ff 4d 10             	decl   0x10(%ebp)
  1059f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1059f8:	48                   	dec    %eax
  1059f9:	0f b6 00             	movzbl (%eax),%eax
  1059fc:	3c 25                	cmp    $0x25,%al
  1059fe:	75 f2                	jne    1059f2 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105a00:	90                   	nop
    while (1) {
  105a01:	e9 37 fc ff ff       	jmp    10563d <vprintfmt+0x8>
                return;
  105a06:	90                   	nop
        }
    }
}
  105a07:	83 c4 40             	add    $0x40,%esp
  105a0a:	5b                   	pop    %ebx
  105a0b:	5e                   	pop    %esi
  105a0c:	5d                   	pop    %ebp
  105a0d:	c3                   	ret    

00105a0e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a0e:	55                   	push   %ebp
  105a0f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a14:	8b 40 08             	mov    0x8(%eax),%eax
  105a17:	8d 50 01             	lea    0x1(%eax),%edx
  105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a23:	8b 10                	mov    (%eax),%edx
  105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a28:	8b 40 04             	mov    0x4(%eax),%eax
  105a2b:	39 c2                	cmp    %eax,%edx
  105a2d:	73 12                	jae    105a41 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a32:	8b 00                	mov    (%eax),%eax
  105a34:	8d 48 01             	lea    0x1(%eax),%ecx
  105a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a3a:	89 0a                	mov    %ecx,(%edx)
  105a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  105a3f:	88 10                	mov    %dl,(%eax)
    }
}
  105a41:	90                   	nop
  105a42:	5d                   	pop    %ebp
  105a43:	c3                   	ret    

00105a44 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a44:	55                   	push   %ebp
  105a45:	89 e5                	mov    %esp,%ebp
  105a47:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a4a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a57:	8b 45 10             	mov    0x10(%ebp),%eax
  105a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a65:	8b 45 08             	mov    0x8(%ebp),%eax
  105a68:	89 04 24             	mov    %eax,(%esp)
  105a6b:	e8 0a 00 00 00       	call   105a7a <vsnprintf>
  105a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a76:	89 ec                	mov    %ebp,%esp
  105a78:	5d                   	pop    %ebp
  105a79:	c3                   	ret    

00105a7a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a7a:	55                   	push   %ebp
  105a7b:	89 e5                	mov    %esp,%ebp
  105a7d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a80:	8b 45 08             	mov    0x8(%ebp),%eax
  105a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a89:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8f:	01 d0                	add    %edx,%eax
  105a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a9f:	74 0a                	je     105aab <vsnprintf+0x31>
  105aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aa7:	39 c2                	cmp    %eax,%edx
  105aa9:	76 07                	jbe    105ab2 <vsnprintf+0x38>
        return -E_INVAL;
  105aab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105ab0:	eb 2a                	jmp    105adc <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  105ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  105abc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ac0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac7:	c7 04 24 0e 5a 10 00 	movl   $0x105a0e,(%esp)
  105ace:	e8 62 fb ff ff       	call   105635 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ad6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105adc:	89 ec                	mov    %ebp,%esp
  105ade:	5d                   	pop    %ebp
  105adf:	c3                   	ret    

00105ae0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105ae0:	55                   	push   %ebp
  105ae1:	89 e5                	mov    %esp,%ebp
  105ae3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105aed:	eb 03                	jmp    105af2 <strlen+0x12>
        cnt ++;
  105aef:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105af2:	8b 45 08             	mov    0x8(%ebp),%eax
  105af5:	8d 50 01             	lea    0x1(%eax),%edx
  105af8:	89 55 08             	mov    %edx,0x8(%ebp)
  105afb:	0f b6 00             	movzbl (%eax),%eax
  105afe:	84 c0                	test   %al,%al
  105b00:	75 ed                	jne    105aef <strlen+0xf>
    }
    return cnt;
  105b02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b05:	89 ec                	mov    %ebp,%esp
  105b07:	5d                   	pop    %ebp
  105b08:	c3                   	ret    

00105b09 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b09:	55                   	push   %ebp
  105b0a:	89 e5                	mov    %esp,%ebp
  105b0c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b16:	eb 03                	jmp    105b1b <strnlen+0x12>
        cnt ++;
  105b18:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b21:	73 10                	jae    105b33 <strnlen+0x2a>
  105b23:	8b 45 08             	mov    0x8(%ebp),%eax
  105b26:	8d 50 01             	lea    0x1(%eax),%edx
  105b29:	89 55 08             	mov    %edx,0x8(%ebp)
  105b2c:	0f b6 00             	movzbl (%eax),%eax
  105b2f:	84 c0                	test   %al,%al
  105b31:	75 e5                	jne    105b18 <strnlen+0xf>
    }
    return cnt;
  105b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b36:	89 ec                	mov    %ebp,%esp
  105b38:	5d                   	pop    %ebp
  105b39:	c3                   	ret    

00105b3a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b3a:	55                   	push   %ebp
  105b3b:	89 e5                	mov    %esp,%ebp
  105b3d:	57                   	push   %edi
  105b3e:	56                   	push   %esi
  105b3f:	83 ec 20             	sub    $0x20,%esp
  105b42:	8b 45 08             	mov    0x8(%ebp),%eax
  105b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b54:	89 d1                	mov    %edx,%ecx
  105b56:	89 c2                	mov    %eax,%edx
  105b58:	89 ce                	mov    %ecx,%esi
  105b5a:	89 d7                	mov    %edx,%edi
  105b5c:	ac                   	lods   %ds:(%esi),%al
  105b5d:	aa                   	stos   %al,%es:(%edi)
  105b5e:	84 c0                	test   %al,%al
  105b60:	75 fa                	jne    105b5c <strcpy+0x22>
  105b62:	89 fa                	mov    %edi,%edx
  105b64:	89 f1                	mov    %esi,%ecx
  105b66:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b69:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b72:	83 c4 20             	add    $0x20,%esp
  105b75:	5e                   	pop    %esi
  105b76:	5f                   	pop    %edi
  105b77:	5d                   	pop    %ebp
  105b78:	c3                   	ret    

00105b79 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b79:	55                   	push   %ebp
  105b7a:	89 e5                	mov    %esp,%ebp
  105b7c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b82:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b85:	eb 1e                	jmp    105ba5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8a:	0f b6 10             	movzbl (%eax),%edx
  105b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b90:	88 10                	mov    %dl,(%eax)
  105b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b95:	0f b6 00             	movzbl (%eax),%eax
  105b98:	84 c0                	test   %al,%al
  105b9a:	74 03                	je     105b9f <strncpy+0x26>
            src ++;
  105b9c:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105b9f:	ff 45 fc             	incl   -0x4(%ebp)
  105ba2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105ba5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ba9:	75 dc                	jne    105b87 <strncpy+0xe>
    }
    return dst;
  105bab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bae:	89 ec                	mov    %ebp,%esp
  105bb0:	5d                   	pop    %ebp
  105bb1:	c3                   	ret    

00105bb2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105bb2:	55                   	push   %ebp
  105bb3:	89 e5                	mov    %esp,%ebp
  105bb5:	57                   	push   %edi
  105bb6:	56                   	push   %esi
  105bb7:	83 ec 20             	sub    $0x20,%esp
  105bba:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bcc:	89 d1                	mov    %edx,%ecx
  105bce:	89 c2                	mov    %eax,%edx
  105bd0:	89 ce                	mov    %ecx,%esi
  105bd2:	89 d7                	mov    %edx,%edi
  105bd4:	ac                   	lods   %ds:(%esi),%al
  105bd5:	ae                   	scas   %es:(%edi),%al
  105bd6:	75 08                	jne    105be0 <strcmp+0x2e>
  105bd8:	84 c0                	test   %al,%al
  105bda:	75 f8                	jne    105bd4 <strcmp+0x22>
  105bdc:	31 c0                	xor    %eax,%eax
  105bde:	eb 04                	jmp    105be4 <strcmp+0x32>
  105be0:	19 c0                	sbb    %eax,%eax
  105be2:	0c 01                	or     $0x1,%al
  105be4:	89 fa                	mov    %edi,%edx
  105be6:	89 f1                	mov    %esi,%ecx
  105be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105beb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bf4:	83 c4 20             	add    $0x20,%esp
  105bf7:	5e                   	pop    %esi
  105bf8:	5f                   	pop    %edi
  105bf9:	5d                   	pop    %ebp
  105bfa:	c3                   	ret    

00105bfb <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bfb:	55                   	push   %ebp
  105bfc:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bfe:	eb 09                	jmp    105c09 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105c00:	ff 4d 10             	decl   0x10(%ebp)
  105c03:	ff 45 08             	incl   0x8(%ebp)
  105c06:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c0d:	74 1a                	je     105c29 <strncmp+0x2e>
  105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c12:	0f b6 00             	movzbl (%eax),%eax
  105c15:	84 c0                	test   %al,%al
  105c17:	74 10                	je     105c29 <strncmp+0x2e>
  105c19:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1c:	0f b6 10             	movzbl (%eax),%edx
  105c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c22:	0f b6 00             	movzbl (%eax),%eax
  105c25:	38 c2                	cmp    %al,%dl
  105c27:	74 d7                	je     105c00 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c2d:	74 18                	je     105c47 <strncmp+0x4c>
  105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c32:	0f b6 00             	movzbl (%eax),%eax
  105c35:	0f b6 d0             	movzbl %al,%edx
  105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3b:	0f b6 00             	movzbl (%eax),%eax
  105c3e:	0f b6 c8             	movzbl %al,%ecx
  105c41:	89 d0                	mov    %edx,%eax
  105c43:	29 c8                	sub    %ecx,%eax
  105c45:	eb 05                	jmp    105c4c <strncmp+0x51>
  105c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c4c:	5d                   	pop    %ebp
  105c4d:	c3                   	ret    

00105c4e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c4e:	55                   	push   %ebp
  105c4f:	89 e5                	mov    %esp,%ebp
  105c51:	83 ec 04             	sub    $0x4,%esp
  105c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c57:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c5a:	eb 13                	jmp    105c6f <strchr+0x21>
        if (*s == c) {
  105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5f:	0f b6 00             	movzbl (%eax),%eax
  105c62:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c65:	75 05                	jne    105c6c <strchr+0x1e>
            return (char *)s;
  105c67:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6a:	eb 12                	jmp    105c7e <strchr+0x30>
        }
        s ++;
  105c6c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c72:	0f b6 00             	movzbl (%eax),%eax
  105c75:	84 c0                	test   %al,%al
  105c77:	75 e3                	jne    105c5c <strchr+0xe>
    }
    return NULL;
  105c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c7e:	89 ec                	mov    %ebp,%esp
  105c80:	5d                   	pop    %ebp
  105c81:	c3                   	ret    

00105c82 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c82:	55                   	push   %ebp
  105c83:	89 e5                	mov    %esp,%ebp
  105c85:	83 ec 04             	sub    $0x4,%esp
  105c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c8e:	eb 0e                	jmp    105c9e <strfind+0x1c>
        if (*s == c) {
  105c90:	8b 45 08             	mov    0x8(%ebp),%eax
  105c93:	0f b6 00             	movzbl (%eax),%eax
  105c96:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105c99:	74 0f                	je     105caa <strfind+0x28>
            break;
        }
        s ++;
  105c9b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca1:	0f b6 00             	movzbl (%eax),%eax
  105ca4:	84 c0                	test   %al,%al
  105ca6:	75 e8                	jne    105c90 <strfind+0xe>
  105ca8:	eb 01                	jmp    105cab <strfind+0x29>
            break;
  105caa:	90                   	nop
    }
    return (char *)s;
  105cab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105cae:	89 ec                	mov    %ebp,%esp
  105cb0:	5d                   	pop    %ebp
  105cb1:	c3                   	ret    

00105cb2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105cb2:	55                   	push   %ebp
  105cb3:	89 e5                	mov    %esp,%ebp
  105cb5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cc6:	eb 03                	jmp    105ccb <strtol+0x19>
        s ++;
  105cc8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  105cce:	0f b6 00             	movzbl (%eax),%eax
  105cd1:	3c 20                	cmp    $0x20,%al
  105cd3:	74 f3                	je     105cc8 <strtol+0x16>
  105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd8:	0f b6 00             	movzbl (%eax),%eax
  105cdb:	3c 09                	cmp    $0x9,%al
  105cdd:	74 e9                	je     105cc8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce2:	0f b6 00             	movzbl (%eax),%eax
  105ce5:	3c 2b                	cmp    $0x2b,%al
  105ce7:	75 05                	jne    105cee <strtol+0x3c>
        s ++;
  105ce9:	ff 45 08             	incl   0x8(%ebp)
  105cec:	eb 14                	jmp    105d02 <strtol+0x50>
    }
    else if (*s == '-') {
  105cee:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf1:	0f b6 00             	movzbl (%eax),%eax
  105cf4:	3c 2d                	cmp    $0x2d,%al
  105cf6:	75 0a                	jne    105d02 <strtol+0x50>
        s ++, neg = 1;
  105cf8:	ff 45 08             	incl   0x8(%ebp)
  105cfb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d06:	74 06                	je     105d0e <strtol+0x5c>
  105d08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d0c:	75 22                	jne    105d30 <strtol+0x7e>
  105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d11:	0f b6 00             	movzbl (%eax),%eax
  105d14:	3c 30                	cmp    $0x30,%al
  105d16:	75 18                	jne    105d30 <strtol+0x7e>
  105d18:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1b:	40                   	inc    %eax
  105d1c:	0f b6 00             	movzbl (%eax),%eax
  105d1f:	3c 78                	cmp    $0x78,%al
  105d21:	75 0d                	jne    105d30 <strtol+0x7e>
        s += 2, base = 16;
  105d23:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d27:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d2e:	eb 29                	jmp    105d59 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d34:	75 16                	jne    105d4c <strtol+0x9a>
  105d36:	8b 45 08             	mov    0x8(%ebp),%eax
  105d39:	0f b6 00             	movzbl (%eax),%eax
  105d3c:	3c 30                	cmp    $0x30,%al
  105d3e:	75 0c                	jne    105d4c <strtol+0x9a>
        s ++, base = 8;
  105d40:	ff 45 08             	incl   0x8(%ebp)
  105d43:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d4a:	eb 0d                	jmp    105d59 <strtol+0xa7>
    }
    else if (base == 0) {
  105d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d50:	75 07                	jne    105d59 <strtol+0xa7>
        base = 10;
  105d52:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d59:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5c:	0f b6 00             	movzbl (%eax),%eax
  105d5f:	3c 2f                	cmp    $0x2f,%al
  105d61:	7e 1b                	jle    105d7e <strtol+0xcc>
  105d63:	8b 45 08             	mov    0x8(%ebp),%eax
  105d66:	0f b6 00             	movzbl (%eax),%eax
  105d69:	3c 39                	cmp    $0x39,%al
  105d6b:	7f 11                	jg     105d7e <strtol+0xcc>
            dig = *s - '0';
  105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d70:	0f b6 00             	movzbl (%eax),%eax
  105d73:	0f be c0             	movsbl %al,%eax
  105d76:	83 e8 30             	sub    $0x30,%eax
  105d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d7c:	eb 48                	jmp    105dc6 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d81:	0f b6 00             	movzbl (%eax),%eax
  105d84:	3c 60                	cmp    $0x60,%al
  105d86:	7e 1b                	jle    105da3 <strtol+0xf1>
  105d88:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8b:	0f b6 00             	movzbl (%eax),%eax
  105d8e:	3c 7a                	cmp    $0x7a,%al
  105d90:	7f 11                	jg     105da3 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105d92:	8b 45 08             	mov    0x8(%ebp),%eax
  105d95:	0f b6 00             	movzbl (%eax),%eax
  105d98:	0f be c0             	movsbl %al,%eax
  105d9b:	83 e8 57             	sub    $0x57,%eax
  105d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105da1:	eb 23                	jmp    105dc6 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105da3:	8b 45 08             	mov    0x8(%ebp),%eax
  105da6:	0f b6 00             	movzbl (%eax),%eax
  105da9:	3c 40                	cmp    $0x40,%al
  105dab:	7e 3b                	jle    105de8 <strtol+0x136>
  105dad:	8b 45 08             	mov    0x8(%ebp),%eax
  105db0:	0f b6 00             	movzbl (%eax),%eax
  105db3:	3c 5a                	cmp    $0x5a,%al
  105db5:	7f 31                	jg     105de8 <strtol+0x136>
            dig = *s - 'A' + 10;
  105db7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dba:	0f b6 00             	movzbl (%eax),%eax
  105dbd:	0f be c0             	movsbl %al,%eax
  105dc0:	83 e8 37             	sub    $0x37,%eax
  105dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  105dcc:	7d 19                	jge    105de7 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105dce:	ff 45 08             	incl   0x8(%ebp)
  105dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dd8:	89 c2                	mov    %eax,%edx
  105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ddd:	01 d0                	add    %edx,%eax
  105ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105de2:	e9 72 ff ff ff       	jmp    105d59 <strtol+0xa7>
            break;
  105de7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dec:	74 08                	je     105df6 <strtol+0x144>
        *endptr = (char *) s;
  105dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df1:	8b 55 08             	mov    0x8(%ebp),%edx
  105df4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105dfa:	74 07                	je     105e03 <strtol+0x151>
  105dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dff:	f7 d8                	neg    %eax
  105e01:	eb 03                	jmp    105e06 <strtol+0x154>
  105e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e06:	89 ec                	mov    %ebp,%esp
  105e08:	5d                   	pop    %ebp
  105e09:	c3                   	ret    

00105e0a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e0a:	55                   	push   %ebp
  105e0b:	89 e5                	mov    %esp,%ebp
  105e0d:	83 ec 28             	sub    $0x28,%esp
  105e10:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e16:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e19:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105e23:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105e26:	8b 45 10             	mov    0x10(%ebp),%eax
  105e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e33:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e36:	89 d7                	mov    %edx,%edi
  105e38:	f3 aa                	rep stos %al,%es:(%edi)
  105e3a:	89 fa                	mov    %edi,%edx
  105e3c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e3f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e48:	89 ec                	mov    %ebp,%esp
  105e4a:	5d                   	pop    %ebp
  105e4b:	c3                   	ret    

00105e4c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e4c:	55                   	push   %ebp
  105e4d:	89 e5                	mov    %esp,%ebp
  105e4f:	57                   	push   %edi
  105e50:	56                   	push   %esi
  105e51:	53                   	push   %ebx
  105e52:	83 ec 30             	sub    $0x30,%esp
  105e55:	8b 45 08             	mov    0x8(%ebp),%eax
  105e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e61:	8b 45 10             	mov    0x10(%ebp),%eax
  105e64:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e6d:	73 42                	jae    105eb1 <memmove+0x65>
  105e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e84:	c1 e8 02             	shr    $0x2,%eax
  105e87:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105e89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e8f:	89 d7                	mov    %edx,%edi
  105e91:	89 c6                	mov    %eax,%esi
  105e93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e95:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e98:	83 e1 03             	and    $0x3,%ecx
  105e9b:	74 02                	je     105e9f <memmove+0x53>
  105e9d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e9f:	89 f0                	mov    %esi,%eax
  105ea1:	89 fa                	mov    %edi,%edx
  105ea3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ea6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ea9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105eaf:	eb 36                	jmp    105ee7 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eba:	01 c2                	add    %eax,%edx
  105ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ebf:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ecb:	89 c1                	mov    %eax,%ecx
  105ecd:	89 d8                	mov    %ebx,%eax
  105ecf:	89 d6                	mov    %edx,%esi
  105ed1:	89 c7                	mov    %eax,%edi
  105ed3:	fd                   	std    
  105ed4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ed6:	fc                   	cld    
  105ed7:	89 f8                	mov    %edi,%eax
  105ed9:	89 f2                	mov    %esi,%edx
  105edb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ede:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ee1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ee7:	83 c4 30             	add    $0x30,%esp
  105eea:	5b                   	pop    %ebx
  105eeb:	5e                   	pop    %esi
  105eec:	5f                   	pop    %edi
  105eed:	5d                   	pop    %ebp
  105eee:	c3                   	ret    

00105eef <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105eef:	55                   	push   %ebp
  105ef0:	89 e5                	mov    %esp,%ebp
  105ef2:	57                   	push   %edi
  105ef3:	56                   	push   %esi
  105ef4:	83 ec 20             	sub    $0x20,%esp
  105ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f03:	8b 45 10             	mov    0x10(%ebp),%eax
  105f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f0c:	c1 e8 02             	shr    $0x2,%eax
  105f0f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105f11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f17:	89 d7                	mov    %edx,%edi
  105f19:	89 c6                	mov    %eax,%esi
  105f1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f1d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f20:	83 e1 03             	and    $0x3,%ecx
  105f23:	74 02                	je     105f27 <memcpy+0x38>
  105f25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f27:	89 f0                	mov    %esi,%eax
  105f29:	89 fa                	mov    %edi,%edx
  105f2b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f31:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f37:	83 c4 20             	add    $0x20,%esp
  105f3a:	5e                   	pop    %esi
  105f3b:	5f                   	pop    %edi
  105f3c:	5d                   	pop    %ebp
  105f3d:	c3                   	ret    

00105f3e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f3e:	55                   	push   %ebp
  105f3f:	89 e5                	mov    %esp,%ebp
  105f41:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f44:	8b 45 08             	mov    0x8(%ebp),%eax
  105f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f50:	eb 2e                	jmp    105f80 <memcmp+0x42>
        if (*s1 != *s2) {
  105f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f55:	0f b6 10             	movzbl (%eax),%edx
  105f58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f5b:	0f b6 00             	movzbl (%eax),%eax
  105f5e:	38 c2                	cmp    %al,%dl
  105f60:	74 18                	je     105f7a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f65:	0f b6 00             	movzbl (%eax),%eax
  105f68:	0f b6 d0             	movzbl %al,%edx
  105f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f6e:	0f b6 00             	movzbl (%eax),%eax
  105f71:	0f b6 c8             	movzbl %al,%ecx
  105f74:	89 d0                	mov    %edx,%eax
  105f76:	29 c8                	sub    %ecx,%eax
  105f78:	eb 18                	jmp    105f92 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105f7a:	ff 45 fc             	incl   -0x4(%ebp)
  105f7d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105f80:	8b 45 10             	mov    0x10(%ebp),%eax
  105f83:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f86:	89 55 10             	mov    %edx,0x10(%ebp)
  105f89:	85 c0                	test   %eax,%eax
  105f8b:	75 c5                	jne    105f52 <memcmp+0x14>
    }
    return 0;
  105f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f92:	89 ec                	mov    %ebp,%esp
  105f94:	5d                   	pop    %ebp
  105f95:	c3                   	ret    
