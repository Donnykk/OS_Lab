
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 28 34 00 00       	call   103450 <memset>

    cons_init(); // init the console
  100028:	e8 c5 15 00 00       	call   1015f2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100042:	e8 e8 02 00 00       	call   10032f <cprintf>

    print_kerninfo();
  100047:	e8 06 08 00 00       	call   100852 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 95 00 00 00       	call   1000e6 <grade_backtrace>

    pmm_init(); // init physical memory management
  100051:	e8 51 2a 00 00       	call   102aa7 <pmm_init>

    pic_init(); // init interrupt controller
  100056:	e8 f2 16 00 00       	call   10174d <pic_init>
    idt_init(); // init interrupt descriptor table
  10005b:	e8 79 18 00 00       	call   1018d9 <idt_init>

    clock_init();  // init clock interrupt
  100060:	e8 2e 0d 00 00       	call   100d93 <clock_init>
    intr_enable(); // enable irq interrupt
  100065:	e8 41 16 00 00       	call   1016ab <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    lab1_switch_test();
  10006a:	e8 75 01 00 00       	call   1001e4 <lab1_switch_test>

    /* do nothing */
    while (1)
  10006f:	eb fe                	jmp    10006f <kern_init+0x6f>

00100071 <grade_backtrace2>:
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100077:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007e:	00 
  10007f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100086:	00 
  100087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008e:	e8 1b 0c 00 00       	call   100cae <mon_backtrace>
}
  100093:	90                   	nop
  100094:	89 ec                	mov    %ebp,%esp
  100096:	5d                   	pop    %ebp
  100097:	c3                   	ret    

00100098 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
  100098:	55                   	push   %ebp
  100099:	89 e5                	mov    %esp,%ebp
  10009b:	83 ec 18             	sub    $0x18,%esp
  10009e:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b0 ff ff ff       	call   100071 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	89 04 24             	mov    %eax,(%esp)
  1000dc:	e8 b7 ff ff ff       	call   100098 <grade_backtrace1>
}
  1000e1:	90                   	nop
  1000e2:	89 ec                	mov    %ebp,%esp
  1000e4:	5d                   	pop    %ebp
  1000e5:	c3                   	ret    

001000e6 <grade_backtrace>:

void grade_backtrace(void)
{
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ec:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f1:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f8:	ff 
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100104:	e8 c0 ff ff ff       	call   1000c9 <grade_backtrace0>
}
  100109:	90                   	nop
  10010a:	89 ec                	mov    %ebp,%esp
  10010c:	5d                   	pop    %ebp
  10010d:	c3                   	ret    

0010010e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
  10010e:	55                   	push   %ebp
  10010f:	89 e5                	mov    %esp,%ebp
  100111:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
  100114:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100117:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
        "mov %%cs, %0;"
        "mov %%ds, %1;"
        "mov %%es, %2;"
        "mov %%ss, %3;"
        : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100120:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100124:	83 e0 03             	and    $0x3,%eax
  100127:	89 c2                	mov    %eax,%edx
  100129:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10012e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100132:	89 44 24 04          	mov    %eax,0x4(%esp)
  100136:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  10013d:	e8 ed 01 00 00       	call   10032f <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100142:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  10015c:	e8 ce 01 00 00       	call   10032f <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100161:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100165:	89 c2                	mov    %eax,%edx
  100167:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10016c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100170:	89 44 24 04          	mov    %eax,0x4(%esp)
  100174:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  10017b:	e8 af 01 00 00       	call   10032f <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	89 c2                	mov    %eax,%edx
  100186:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10018b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100193:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  10019a:	e8 90 01 00 00       	call   10032f <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a3:	89 c2                	mov    %eax,%edx
  1001a5:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b9:	e8 71 01 00 00       	call   10032f <cprintf>
    round++;
  1001be:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001c3:	40                   	inc    %eax
  1001c4:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c9:	90                   	nop
  1001ca:	89 ec                	mov    %ebp,%esp
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 : TODO
    asm volatile(
  1001d1:	16                   	push   %ss
  1001d2:	54                   	push   %esp
  1001d3:	cd 78                	int    $0x78
  1001d5:	89 ec                	mov    %ebp,%esp
        "pushl %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU));
}
  1001d7:	90                   	nop
  1001d8:	5d                   	pop    %ebp
  1001d9:	c3                   	ret    

001001da <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
  1001da:	55                   	push   %ebp
  1001db:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  1001dd:	cd 79                	int    $0x79
  1001df:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK));
}
  1001e1:	90                   	nop
  1001e2:	5d                   	pop    %ebp
  1001e3:	c3                   	ret    

001001e4 <lab1_switch_test>:

static void
lab1_switch_test(void)
{
  1001e4:	55                   	push   %ebp
  1001e5:	89 e5                	mov    %esp,%ebp
  1001e7:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001ea:	e8 1f ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001ef:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001f6:	e8 34 01 00 00       	call   10032f <cprintf>
    lab1_switch_to_user();
  1001fb:	e8 ce ff ff ff       	call   1001ce <lab1_switch_to_user>
    lab1_print_cur_status();
  100200:	e8 09 ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100205:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  10020c:	e8 1e 01 00 00       	call   10032f <cprintf>
    lab1_switch_to_kernel();
  100211:	e8 c4 ff ff ff       	call   1001da <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100216:	e8 f3 fe ff ff       	call   10010e <lab1_print_cur_status>
}
  10021b:	90                   	nop
  10021c:	89 ec                	mov    %ebp,%esp
  10021e:	5d                   	pop    %ebp
  10021f:	c3                   	ret    

00100220 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100220:	55                   	push   %ebp
  100221:	89 e5                	mov    %esp,%ebp
  100223:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10022a:	74 13                	je     10023f <readline+0x1f>
        cprintf("%s", prompt);
  10022c:	8b 45 08             	mov    0x8(%ebp),%eax
  10022f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100233:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  10023a:	e8 f0 00 00 00       	call   10032f <cprintf>
    }
    int i = 0, c;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100246:	e8 73 01 00 00       	call   1003be <getchar>
  10024b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10024e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100252:	79 07                	jns    10025b <readline+0x3b>
            return NULL;
  100254:	b8 00 00 00 00       	mov    $0x0,%eax
  100259:	eb 78                	jmp    1002d3 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10025b:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10025f:	7e 28                	jle    100289 <readline+0x69>
  100261:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100268:	7f 1f                	jg     100289 <readline+0x69>
            cputchar(c);
  10026a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026d:	89 04 24             	mov    %eax,(%esp)
  100270:	e8 e2 00 00 00       	call   100357 <cputchar>
            buf[i ++] = c;
  100275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100278:	8d 50 01             	lea    0x1(%eax),%edx
  10027b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10027e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100281:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100287:	eb 45                	jmp    1002ce <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100289:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10028d:	75 16                	jne    1002a5 <readline+0x85>
  10028f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100293:	7e 10                	jle    1002a5 <readline+0x85>
            cputchar(c);
  100295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100298:	89 04 24             	mov    %eax,(%esp)
  10029b:	e8 b7 00 00 00       	call   100357 <cputchar>
            i --;
  1002a0:	ff 4d f4             	decl   -0xc(%ebp)
  1002a3:	eb 29                	jmp    1002ce <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002a5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a9:	74 06                	je     1002b1 <readline+0x91>
  1002ab:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002af:	75 95                	jne    100246 <readline+0x26>
            cputchar(c);
  1002b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b4:	89 04 24             	mov    %eax,(%esp)
  1002b7:	e8 9b 00 00 00       	call   100357 <cputchar>
            buf[i] = '\0';
  1002bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002bf:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002c4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c7:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002cc:	eb 05                	jmp    1002d3 <readline+0xb3>
        c = getchar();
  1002ce:	e9 73 ff ff ff       	jmp    100246 <readline+0x26>
        }
    }
}
  1002d3:	89 ec                	mov    %ebp,%esp
  1002d5:	5d                   	pop    %ebp
  1002d6:	c3                   	ret    

001002d7 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002d7:	55                   	push   %ebp
  1002d8:	89 e5                	mov    %esp,%ebp
  1002da:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e0:	89 04 24             	mov    %eax,(%esp)
  1002e3:	e8 39 13 00 00       	call   101621 <cons_putc>
    (*cnt) ++;
  1002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002eb:	8b 00                	mov    (%eax),%eax
  1002ed:	8d 50 01             	lea    0x1(%eax),%edx
  1002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f3:	89 10                	mov    %edx,(%eax)
}
  1002f5:	90                   	nop
  1002f6:	89 ec                	mov    %ebp,%esp
  1002f8:	5d                   	pop    %ebp
  1002f9:	c3                   	ret    

001002fa <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002fa:	55                   	push   %ebp
  1002fb:	89 e5                	mov    %esp,%ebp
  1002fd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100307:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10030e:	8b 45 08             	mov    0x8(%ebp),%eax
  100311:	89 44 24 08          	mov    %eax,0x8(%esp)
  100315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100318:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031c:	c7 04 24 d7 02 10 00 	movl   $0x1002d7,(%esp)
  100323:	e8 53 29 00 00       	call   102c7b <vprintfmt>
    return cnt;
  100328:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032b:	89 ec                	mov    %ebp,%esp
  10032d:	5d                   	pop    %ebp
  10032e:	c3                   	ret    

0010032f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10032f:	55                   	push   %ebp
  100330:	89 e5                	mov    %esp,%ebp
  100332:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100335:	8d 45 0c             	lea    0xc(%ebp),%eax
  100338:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10033e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100342:	8b 45 08             	mov    0x8(%ebp),%eax
  100345:	89 04 24             	mov    %eax,(%esp)
  100348:	e8 ad ff ff ff       	call   1002fa <vcprintf>
  10034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100350:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100353:	89 ec                	mov    %ebp,%esp
  100355:	5d                   	pop    %ebp
  100356:	c3                   	ret    

00100357 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100357:	55                   	push   %ebp
  100358:	89 e5                	mov    %esp,%ebp
  10035a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10035d:	8b 45 08             	mov    0x8(%ebp),%eax
  100360:	89 04 24             	mov    %eax,(%esp)
  100363:	e8 b9 12 00 00       	call   101621 <cons_putc>
}
  100368:	90                   	nop
  100369:	89 ec                	mov    %ebp,%esp
  10036b:	5d                   	pop    %ebp
  10036c:	c3                   	ret    

0010036d <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10036d:	55                   	push   %ebp
  10036e:	89 e5                	mov    %esp,%ebp
  100370:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10037a:	eb 13                	jmp    10038f <cputs+0x22>
        cputch(c, &cnt);
  10037c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100380:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100383:	89 54 24 04          	mov    %edx,0x4(%esp)
  100387:	89 04 24             	mov    %eax,(%esp)
  10038a:	e8 48 ff ff ff       	call   1002d7 <cputch>
    while ((c = *str ++) != '\0') {
  10038f:	8b 45 08             	mov    0x8(%ebp),%eax
  100392:	8d 50 01             	lea    0x1(%eax),%edx
  100395:	89 55 08             	mov    %edx,0x8(%ebp)
  100398:	0f b6 00             	movzbl (%eax),%eax
  10039b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10039e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003a2:	75 d8                	jne    10037c <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ab:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003b2:	e8 20 ff ff ff       	call   1002d7 <cputch>
    return cnt;
  1003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ba:	89 ec                	mov    %ebp,%esp
  1003bc:	5d                   	pop    %ebp
  1003bd:	c3                   	ret    

001003be <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003be:	55                   	push   %ebp
  1003bf:	89 e5                	mov    %esp,%ebp
  1003c1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003c4:	90                   	nop
  1003c5:	e8 83 12 00 00       	call   10164d <cons_getc>
  1003ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d1:	74 f2                	je     1003c5 <getchar+0x7>
        /* do nothing */;
    return c;
  1003d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d6:	89 ec                	mov    %ebp,%esp
  1003d8:	5d                   	pop    %ebp
  1003d9:	c3                   	ret    

001003da <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003da:	55                   	push   %ebp
  1003db:	89 e5                	mov    %esp,%ebp
  1003dd:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e3:	8b 00                	mov    (%eax),%eax
  1003e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1003eb:	8b 00                	mov    (%eax),%eax
  1003ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003f7:	e9 ca 00 00 00       	jmp    1004c6 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	01 d0                	add    %edx,%eax
  100404:	89 c2                	mov    %eax,%edx
  100406:	c1 ea 1f             	shr    $0x1f,%edx
  100409:	01 d0                	add    %edx,%eax
  10040b:	d1 f8                	sar    %eax
  10040d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100413:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100416:	eb 03                	jmp    10041b <stab_binsearch+0x41>
            m --;
  100418:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10041b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100421:	7c 1f                	jl     100442 <stab_binsearch+0x68>
  100423:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100426:	89 d0                	mov    %edx,%eax
  100428:	01 c0                	add    %eax,%eax
  10042a:	01 d0                	add    %edx,%eax
  10042c:	c1 e0 02             	shl    $0x2,%eax
  10042f:	89 c2                	mov    %eax,%edx
  100431:	8b 45 08             	mov    0x8(%ebp),%eax
  100434:	01 d0                	add    %edx,%eax
  100436:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043a:	0f b6 c0             	movzbl %al,%eax
  10043d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100440:	75 d6                	jne    100418 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100448:	7d 09                	jge    100453 <stab_binsearch+0x79>
            l = true_m + 1;
  10044a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10044d:	40                   	inc    %eax
  10044e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100451:	eb 73                	jmp    1004c6 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100453:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10045a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045d:	89 d0                	mov    %edx,%eax
  10045f:	01 c0                	add    %eax,%eax
  100461:	01 d0                	add    %edx,%eax
  100463:	c1 e0 02             	shl    $0x2,%eax
  100466:	89 c2                	mov    %eax,%edx
  100468:	8b 45 08             	mov    0x8(%ebp),%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	8b 40 08             	mov    0x8(%eax),%eax
  100470:	39 45 18             	cmp    %eax,0x18(%ebp)
  100473:	76 11                	jbe    100486 <stab_binsearch+0xac>
            *region_left = m;
  100475:	8b 45 0c             	mov    0xc(%ebp),%eax
  100478:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047b:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10047d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100480:	40                   	inc    %eax
  100481:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100484:	eb 40                	jmp    1004c6 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100486:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100489:	89 d0                	mov    %edx,%eax
  10048b:	01 c0                	add    %eax,%eax
  10048d:	01 d0                	add    %edx,%eax
  10048f:	c1 e0 02             	shl    $0x2,%eax
  100492:	89 c2                	mov    %eax,%edx
  100494:	8b 45 08             	mov    0x8(%ebp),%eax
  100497:	01 d0                	add    %edx,%eax
  100499:	8b 40 08             	mov    0x8(%eax),%eax
  10049c:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049f:	73 14                	jae    1004b5 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004aa:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004af:	48                   	dec    %eax
  1004b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b3:	eb 11                	jmp    1004c6 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bb:	89 10                	mov    %edx,(%eax)
            l = m;
  1004bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004c3:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004cc:	0f 8e 2a ff ff ff    	jle    1003fc <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004d6:	75 0f                	jne    1004e7 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e3:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004e5:	eb 3e                	jmp    100525 <stab_binsearch+0x14b>
        l = *region_right;
  1004e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ea:	8b 00                	mov    (%eax),%eax
  1004ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004ef:	eb 03                	jmp    1004f4 <stab_binsearch+0x11a>
  1004f1:	ff 4d fc             	decl   -0x4(%ebp)
  1004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f7:	8b 00                	mov    (%eax),%eax
  1004f9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004fc:	7e 1f                	jle    10051d <stab_binsearch+0x143>
  1004fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100501:	89 d0                	mov    %edx,%eax
  100503:	01 c0                	add    %eax,%eax
  100505:	01 d0                	add    %edx,%eax
  100507:	c1 e0 02             	shl    $0x2,%eax
  10050a:	89 c2                	mov    %eax,%edx
  10050c:	8b 45 08             	mov    0x8(%ebp),%eax
  10050f:	01 d0                	add    %edx,%eax
  100511:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100515:	0f b6 c0             	movzbl %al,%eax
  100518:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051b:	75 d4                	jne    1004f1 <stab_binsearch+0x117>
        *region_left = l;
  10051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100520:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100523:	89 10                	mov    %edx,(%eax)
}
  100525:	90                   	nop
  100526:	89 ec                	mov    %ebp,%esp
  100528:	5d                   	pop    %ebp
  100529:	c3                   	ret    

0010052a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10052a:	55                   	push   %ebp
  10052b:	89 e5                	mov    %esp,%ebp
  10052d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100530:	8b 45 0c             	mov    0xc(%ebp),%eax
  100533:	c7 00 8c 36 10 00    	movl   $0x10368c,(%eax)
    info->eip_line = 0;
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100543:	8b 45 0c             	mov    0xc(%ebp),%eax
  100546:	c7 40 08 8c 36 10 00 	movl   $0x10368c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100550:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	8b 55 08             	mov    0x8(%ebp),%edx
  10055d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10056a:	c7 45 f4 2c 3f 10 00 	movl   $0x103f2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100571:	c7 45 f0 8c bd 10 00 	movl   $0x10bd8c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100578:	c7 45 ec 8d bd 10 00 	movl   $0x10bd8d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10057f:	c7 45 e8 2f e7 10 00 	movl   $0x10e72f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100589:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10058c:	76 0b                	jbe    100599 <debuginfo_eip+0x6f>
  10058e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100591:	48                   	dec    %eax
  100592:	0f b6 00             	movzbl (%eax),%eax
  100595:	84 c0                	test   %al,%al
  100597:	74 0a                	je     1005a3 <debuginfo_eip+0x79>
        return -1;
  100599:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10059e:	e9 ab 02 00 00       	jmp    10084e <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ad:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005b0:	c1 f8 02             	sar    $0x2,%eax
  1005b3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005b9:	48                   	dec    %eax
  1005ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005c4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005cb:	00 
  1005cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005dd:	89 04 24             	mov    %eax,(%esp)
  1005e0:	e8 f5 fd ff ff       	call   1003da <stab_binsearch>
    if (lfile == 0)
  1005e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e8:	85 c0                	test   %eax,%eax
  1005ea:	75 0a                	jne    1005f6 <debuginfo_eip+0xcc>
        return -1;
  1005ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f1:	e9 58 02 00 00       	jmp    10084e <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100602:	8b 45 08             	mov    0x8(%ebp),%eax
  100605:	89 44 24 10          	mov    %eax,0x10(%esp)
  100609:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100610:	00 
  100611:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100614:	89 44 24 08          	mov    %eax,0x8(%esp)
  100618:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10061b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100622:	89 04 24             	mov    %eax,(%esp)
  100625:	e8 b0 fd ff ff       	call   1003da <stab_binsearch>

    if (lfun <= rfun) {
  10062a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10062d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100630:	39 c2                	cmp    %eax,%edx
  100632:	7f 78                	jg     1006ac <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100634:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100637:	89 c2                	mov    %eax,%edx
  100639:	89 d0                	mov    %edx,%eax
  10063b:	01 c0                	add    %eax,%eax
  10063d:	01 d0                	add    %edx,%eax
  10063f:	c1 e0 02             	shl    $0x2,%eax
  100642:	89 c2                	mov    %eax,%edx
  100644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100647:	01 d0                	add    %edx,%eax
  100649:	8b 10                	mov    (%eax),%edx
  10064b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100651:	39 c2                	cmp    %eax,%edx
  100653:	73 22                	jae    100677 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100658:	89 c2                	mov    %eax,%edx
  10065a:	89 d0                	mov    %edx,%eax
  10065c:	01 c0                	add    %eax,%eax
  10065e:	01 d0                	add    %edx,%eax
  100660:	c1 e0 02             	shl    $0x2,%eax
  100663:	89 c2                	mov    %eax,%edx
  100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100668:	01 d0                	add    %edx,%eax
  10066a:	8b 10                	mov    (%eax),%edx
  10066c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066f:	01 c2                	add    %eax,%edx
  100671:	8b 45 0c             	mov    0xc(%ebp),%eax
  100674:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100677:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067a:	89 c2                	mov    %eax,%edx
  10067c:	89 d0                	mov    %edx,%eax
  10067e:	01 c0                	add    %eax,%eax
  100680:	01 d0                	add    %edx,%eax
  100682:	c1 e0 02             	shl    $0x2,%eax
  100685:	89 c2                	mov    %eax,%edx
  100687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068a:	01 d0                	add    %edx,%eax
  10068c:	8b 50 08             	mov    0x8(%eax),%edx
  10068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100692:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100695:	8b 45 0c             	mov    0xc(%ebp),%eax
  100698:	8b 40 10             	mov    0x10(%eax),%eax
  10069b:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006aa:	eb 15                	jmp    1006c1 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 55 08             	mov    0x8(%ebp),%edx
  1006b2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006be:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 40 08             	mov    0x8(%eax),%eax
  1006c7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ce:	00 
  1006cf:	89 04 24             	mov    %eax,(%esp)
  1006d2:	e8 f1 2b 00 00       	call   1032c8 <strfind>
  1006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006da:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006dd:	29 c8                	sub    %ecx,%eax
  1006df:	89 c2                	mov    %eax,%edx
  1006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e4:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ee:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f5:	00 
  1006f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100700:	89 44 24 04          	mov    %eax,0x4(%esp)
  100704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100707:	89 04 24             	mov    %eax,(%esp)
  10070a:	e8 cb fc ff ff       	call   1003da <stab_binsearch>
    if (lline <= rline) {
  10070f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100712:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100715:	39 c2                	cmp    %eax,%edx
  100717:	7f 23                	jg     10073c <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  100719:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10071c:	89 c2                	mov    %eax,%edx
  10071e:	89 d0                	mov    %edx,%eax
  100720:	01 c0                	add    %eax,%eax
  100722:	01 d0                	add    %edx,%eax
  100724:	c1 e0 02             	shl    $0x2,%eax
  100727:	89 c2                	mov    %eax,%edx
  100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072c:	01 d0                	add    %edx,%eax
  10072e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073a:	eb 11                	jmp    10074d <debuginfo_eip+0x223>
        return -1;
  10073c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100741:	e9 08 01 00 00       	jmp    10084e <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100749:	48                   	dec    %eax
  10074a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10074d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100753:	39 c2                	cmp    %eax,%edx
  100755:	7c 56                	jl     1007ad <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100757:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	89 d0                	mov    %edx,%eax
  10075e:	01 c0                	add    %eax,%eax
  100760:	01 d0                	add    %edx,%eax
  100762:	c1 e0 02             	shl    $0x2,%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100770:	3c 84                	cmp    $0x84,%al
  100772:	74 39                	je     1007ad <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100777:	89 c2                	mov    %eax,%edx
  100779:	89 d0                	mov    %edx,%eax
  10077b:	01 c0                	add    %eax,%eax
  10077d:	01 d0                	add    %edx,%eax
  10077f:	c1 e0 02             	shl    $0x2,%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078d:	3c 64                	cmp    $0x64,%al
  10078f:	75 b5                	jne    100746 <debuginfo_eip+0x21c>
  100791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100794:	89 c2                	mov    %eax,%edx
  100796:	89 d0                	mov    %edx,%eax
  100798:	01 c0                	add    %eax,%eax
  10079a:	01 d0                	add    %edx,%eax
  10079c:	c1 e0 02             	shl    $0x2,%eax
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	8b 40 08             	mov    0x8(%eax),%eax
  1007a9:	85 c0                	test   %eax,%eax
  1007ab:	74 99                	je     100746 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b3:	39 c2                	cmp    %eax,%edx
  1007b5:	7c 42                	jl     1007f9 <debuginfo_eip+0x2cf>
  1007b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ba:	89 c2                	mov    %eax,%edx
  1007bc:	89 d0                	mov    %edx,%eax
  1007be:	01 c0                	add    %eax,%eax
  1007c0:	01 d0                	add    %edx,%eax
  1007c2:	c1 e0 02             	shl    $0x2,%eax
  1007c5:	89 c2                	mov    %eax,%edx
  1007c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ca:	01 d0                	add    %edx,%eax
  1007cc:	8b 10                	mov    (%eax),%edx
  1007ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007d4:	39 c2                	cmp    %eax,%edx
  1007d6:	73 21                	jae    1007f9 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007db:	89 c2                	mov    %eax,%edx
  1007dd:	89 d0                	mov    %edx,%eax
  1007df:	01 c0                	add    %eax,%eax
  1007e1:	01 d0                	add    %edx,%eax
  1007e3:	c1 e0 02             	shl    $0x2,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007eb:	01 d0                	add    %edx,%eax
  1007ed:	8b 10                	mov    (%eax),%edx
  1007ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f2:	01 c2                	add    %eax,%edx
  1007f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f7:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ff:	39 c2                	cmp    %eax,%edx
  100801:	7d 46                	jge    100849 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100803:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100806:	40                   	inc    %eax
  100807:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080a:	eb 16                	jmp    100822 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10080c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080f:	8b 40 14             	mov    0x14(%eax),%eax
  100812:	8d 50 01             	lea    0x1(%eax),%edx
  100815:	8b 45 0c             	mov    0xc(%ebp),%eax
  100818:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10081b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081e:	40                   	inc    %eax
  10081f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100825:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100828:	39 c2                	cmp    %eax,%edx
  10082a:	7d 1d                	jge    100849 <debuginfo_eip+0x31f>
  10082c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082f:	89 c2                	mov    %eax,%edx
  100831:	89 d0                	mov    %edx,%eax
  100833:	01 c0                	add    %eax,%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	c1 e0 02             	shl    $0x2,%eax
  10083a:	89 c2                	mov    %eax,%edx
  10083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100845:	3c a0                	cmp    $0xa0,%al
  100847:	74 c3                	je     10080c <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10084e:	89 ec                	mov    %ebp,%esp
  100850:	5d                   	pop    %ebp
  100851:	c3                   	ret    

00100852 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100852:	55                   	push   %ebp
  100853:	89 e5                	mov    %esp,%ebp
  100855:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100858:	c7 04 24 96 36 10 00 	movl   $0x103696,(%esp)
  10085f:	e8 cb fa ff ff       	call   10032f <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100864:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086b:	00 
  10086c:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  100873:	e8 b7 fa ff ff       	call   10032f <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100878:	c7 44 24 04 dc 35 10 	movl   $0x1035dc,0x4(%esp)
  10087f:	00 
  100880:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  100887:	e8 a3 fa ff ff       	call   10032f <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10088c:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100893:	00 
  100894:	c7 04 24 df 36 10 00 	movl   $0x1036df,(%esp)
  10089b:	e8 8f fa ff ff       	call   10032f <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a0:	c7 44 24 04 68 0d 11 	movl   $0x110d68,0x4(%esp)
  1008a7:	00 
  1008a8:	c7 04 24 f7 36 10 00 	movl   $0x1036f7,(%esp)
  1008af:	e8 7b fa ff ff       	call   10032f <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b4:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  1008b9:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008be:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008c3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c9:	85 c0                	test   %eax,%eax
  1008cb:	0f 48 c2             	cmovs  %edx,%eax
  1008ce:	c1 f8 0a             	sar    $0xa,%eax
  1008d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d5:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  1008dc:	e8 4e fa ff ff       	call   10032f <cprintf>
}
  1008e1:	90                   	nop
  1008e2:	89 ec                	mov    %ebp,%esp
  1008e4:	5d                   	pop    %ebp
  1008e5:	c3                   	ret    

001008e6 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e6:	55                   	push   %ebp
  1008e7:	89 e5                	mov    %esp,%ebp
  1008e9:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f9:	89 04 24             	mov    %eax,(%esp)
  1008fc:	e8 29 fc ff ff       	call   10052a <debuginfo_eip>
  100901:	85 c0                	test   %eax,%eax
  100903:	74 15                	je     10091a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100905:	8b 45 08             	mov    0x8(%ebp),%eax
  100908:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090c:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100913:	e8 17 fa ff ff       	call   10032f <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100918:	eb 6c                	jmp    100986 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10091a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100921:	eb 1b                	jmp    10093e <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100929:	01 d0                	add    %edx,%eax
  10092b:	0f b6 10             	movzbl (%eax),%edx
  10092e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100937:	01 c8                	add    %ecx,%eax
  100939:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093b:	ff 45 f4             	incl   -0xc(%ebp)
  10093e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100941:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100944:	7c dd                	jl     100923 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100946:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10094c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10094f:	01 d0                	add    %edx,%eax
  100951:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100954:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100957:	8b 45 08             	mov    0x8(%ebp),%eax
  10095a:	29 d0                	sub    %edx,%eax
  10095c:	89 c1                	mov    %eax,%ecx
  10095e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100961:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100964:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100968:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100972:	89 54 24 08          	mov    %edx,0x8(%esp)
  100976:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097a:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100981:	e8 a9 f9 ff ff       	call   10032f <cprintf>
}
  100986:	90                   	nop
  100987:	89 ec                	mov    %ebp,%esp
  100989:	5d                   	pop    %ebp
  10098a:	c3                   	ret    

0010098b <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098b:	55                   	push   %ebp
  10098c:	89 e5                	mov    %esp,%ebp
  10098e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100991:	8b 45 04             	mov    0x4(%ebp),%eax
  100994:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100997:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099a:	89 ec                	mov    %ebp,%esp
  10099c:	5d                   	pop    %ebp
  10099d:	c3                   	ret    

0010099e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10099e:	55                   	push   %ebp
  10099f:	89 e5                	mov    %esp,%ebp
  1009a1:	83 ec 58             	sub    $0x58,%esp
  1009a4:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a7:	89 e8                	mov    %ebp,%eax
  1009a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp = read_ebp();
  1009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  1009b2:	e8 d4 ff ff ff       	call   10098b <read_eip>
  1009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4];

    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
  1009ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c1:	e9 91 00 00 00       	jmp    100a57 <print_stackframe+0xb9>
    {
        cprintf("ebp: 0x%08x eip: 0x%08x ", ebp, eip);
  1009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d4:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  1009db:	e8 4f f9 ff ff       	call   10032f <cprintf>

        for (int j = 0; j < 4; j++)
  1009e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009e7:	eb 1e                	jmp    100a07 <print_stackframe+0x69>
            args[j] = *((uint32_t *)ebp + j + 2);
  1009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f6:	01 d0                	add    %edx,%eax
  1009f8:	83 c0 08             	add    $0x8,%eax
  1009fb:	8b 10                	mov    (%eax),%edx
  1009fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a00:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
        for (int j = 0; j < 4; j++)
  100a04:	ff 45 e8             	incl   -0x18(%ebp)
  100a07:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0b:	7e dc                	jle    1009e9 <print_stackframe+0x4b>
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
  100a0d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a10:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a13:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a19:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a1d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a21:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a29:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100a30:	e8 fa f8 ff ff       	call   10032f <cprintf>
        print_debuginfo(eip - 1);
  100a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a38:	48                   	dec    %eax
  100a39:	89 04 24             	mov    %eax,(%esp)
  100a3c:	e8 a5 fe ff ff       	call   1008e6 <print_debuginfo>

        eip = *((uint32_t *)ebp + 1);
  100a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a44:	83 c0 04             	add    $0x4,%eax
  100a47:	8b 00                	mov    (%eax),%eax
  100a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *((uint32_t *)ebp);
  100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4f:	8b 00                	mov    (%eax),%eax
  100a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
  100a54:	ff 45 ec             	incl   -0x14(%ebp)
  100a57:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100a5b:	0f 8e 65 ff ff ff    	jle    1009c6 <print_stackframe+0x28>
    }
}
  100a61:	90                   	nop
  100a62:	90                   	nop
  100a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a66:	89 ec                	mov    %ebp,%esp
  100a68:	5d                   	pop    %ebp
  100a69:	c3                   	ret    

00100a6a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a6a:	55                   	push   %ebp
  100a6b:	89 e5                	mov    %esp,%ebp
  100a6d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a77:	eb 0c                	jmp    100a85 <parse+0x1b>
            *buf ++ = '\0';
  100a79:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7c:	8d 50 01             	lea    0x1(%eax),%edx
  100a7f:	89 55 08             	mov    %edx,0x8(%ebp)
  100a82:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a85:	8b 45 08             	mov    0x8(%ebp),%eax
  100a88:	0f b6 00             	movzbl (%eax),%eax
  100a8b:	84 c0                	test   %al,%al
  100a8d:	74 1d                	je     100aac <parse+0x42>
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	0f b6 00             	movzbl (%eax),%eax
  100a95:	0f be c0             	movsbl %al,%eax
  100a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a9c:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  100aa3:	e8 ec 27 00 00       	call   103294 <strchr>
  100aa8:	85 c0                	test   %eax,%eax
  100aaa:	75 cd                	jne    100a79 <parse+0xf>
        }
        if (*buf == '\0') {
  100aac:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaf:	0f b6 00             	movzbl (%eax),%eax
  100ab2:	84 c0                	test   %al,%al
  100ab4:	74 65                	je     100b1b <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aba:	75 14                	jne    100ad0 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100abc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ac3:	00 
  100ac4:	c7 04 24 2d 38 10 00 	movl   $0x10382d,(%esp)
  100acb:	e8 5f f8 ff ff       	call   10032f <cprintf>
        }
        argv[argc ++] = buf;
  100ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad3:	8d 50 01             	lea    0x1(%eax),%edx
  100ad6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae3:	01 c2                	add    %eax,%edx
  100ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aea:	eb 03                	jmp    100aef <parse+0x85>
            buf ++;
  100aec:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aef:	8b 45 08             	mov    0x8(%ebp),%eax
  100af2:	0f b6 00             	movzbl (%eax),%eax
  100af5:	84 c0                	test   %al,%al
  100af7:	74 8c                	je     100a85 <parse+0x1b>
  100af9:	8b 45 08             	mov    0x8(%ebp),%eax
  100afc:	0f b6 00             	movzbl (%eax),%eax
  100aff:	0f be c0             	movsbl %al,%eax
  100b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b06:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  100b0d:	e8 82 27 00 00       	call   103294 <strchr>
  100b12:	85 c0                	test   %eax,%eax
  100b14:	74 d6                	je     100aec <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	e9 6a ff ff ff       	jmp    100a85 <parse+0x1b>
            break;
  100b1b:	90                   	nop
        }
    }
    return argc;
  100b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b1f:	89 ec                	mov    %ebp,%esp
  100b21:	5d                   	pop    %ebp
  100b22:	c3                   	ret    

00100b23 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b23:	55                   	push   %ebp
  100b24:	89 e5                	mov    %esp,%ebp
  100b26:	83 ec 68             	sub    $0x68,%esp
  100b29:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b2c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b33:	8b 45 08             	mov    0x8(%ebp),%eax
  100b36:	89 04 24             	mov    %eax,(%esp)
  100b39:	e8 2c ff ff ff       	call   100a6a <parse>
  100b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b45:	75 0a                	jne    100b51 <runcmd+0x2e>
        return 0;
  100b47:	b8 00 00 00 00       	mov    $0x0,%eax
  100b4c:	e9 83 00 00 00       	jmp    100bd4 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b58:	eb 5a                	jmp    100bb4 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b5a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b5d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b60:	89 c8                	mov    %ecx,%eax
  100b62:	01 c0                	add    %eax,%eax
  100b64:	01 c8                	add    %ecx,%eax
  100b66:	c1 e0 02             	shl    $0x2,%eax
  100b69:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b6e:	8b 00                	mov    (%eax),%eax
  100b70:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b74:	89 04 24             	mov    %eax,(%esp)
  100b77:	e8 7c 26 00 00       	call   1031f8 <strcmp>
  100b7c:	85 c0                	test   %eax,%eax
  100b7e:	75 31                	jne    100bb1 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b83:	89 d0                	mov    %edx,%eax
  100b85:	01 c0                	add    %eax,%eax
  100b87:	01 d0                	add    %edx,%eax
  100b89:	c1 e0 02             	shl    $0x2,%eax
  100b8c:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b91:	8b 10                	mov    (%eax),%edx
  100b93:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b96:	83 c0 04             	add    $0x4,%eax
  100b99:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b9c:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ba2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100baa:	89 1c 24             	mov    %ebx,(%esp)
  100bad:	ff d2                	call   *%edx
  100baf:	eb 23                	jmp    100bd4 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb1:	ff 45 f4             	incl   -0xc(%ebp)
  100bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb7:	83 f8 02             	cmp    $0x2,%eax
  100bba:	76 9e                	jbe    100b5a <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc3:	c7 04 24 4b 38 10 00 	movl   $0x10384b,(%esp)
  100bca:	e8 60 f7 ff ff       	call   10032f <cprintf>
    return 0;
  100bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bd7:	89 ec                	mov    %ebp,%esp
  100bd9:	5d                   	pop    %ebp
  100bda:	c3                   	ret    

00100bdb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bdb:	55                   	push   %ebp
  100bdc:	89 e5                	mov    %esp,%ebp
  100bde:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be1:	c7 04 24 64 38 10 00 	movl   $0x103864,(%esp)
  100be8:	e8 42 f7 ff ff       	call   10032f <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bed:	c7 04 24 8c 38 10 00 	movl   $0x10388c,(%esp)
  100bf4:	e8 36 f7 ff ff       	call   10032f <cprintf>

    if (tf != NULL) {
  100bf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bfd:	74 0b                	je     100c0a <kmonitor+0x2f>
        print_trapframe(tf);
  100bff:	8b 45 08             	mov    0x8(%ebp),%eax
  100c02:	89 04 24             	mov    %eax,(%esp)
  100c05:	e8 89 0e 00 00       	call   101a93 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c0a:	c7 04 24 b1 38 10 00 	movl   $0x1038b1,(%esp)
  100c11:	e8 0a f6 ff ff       	call   100220 <readline>
  100c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c1d:	74 eb                	je     100c0a <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c29:	89 04 24             	mov    %eax,(%esp)
  100c2c:	e8 f2 fe ff ff       	call   100b23 <runcmd>
  100c31:	85 c0                	test   %eax,%eax
  100c33:	78 02                	js     100c37 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c35:	eb d3                	jmp    100c0a <kmonitor+0x2f>
                break;
  100c37:	90                   	nop
            }
        }
    }
}
  100c38:	90                   	nop
  100c39:	89 ec                	mov    %ebp,%esp
  100c3b:	5d                   	pop    %ebp
  100c3c:	c3                   	ret    

00100c3d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3d:	55                   	push   %ebp
  100c3e:	89 e5                	mov    %esp,%ebp
  100c40:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c4a:	eb 3d                	jmp    100c89 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4f:	89 d0                	mov    %edx,%eax
  100c51:	01 c0                	add    %eax,%eax
  100c53:	01 d0                	add    %edx,%eax
  100c55:	c1 e0 02             	shl    $0x2,%eax
  100c58:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c5d:	8b 10                	mov    (%eax),%edx
  100c5f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c62:	89 c8                	mov    %ecx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 c8                	add    %ecx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c70:	8b 00                	mov    (%eax),%eax
  100c72:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7a:	c7 04 24 b5 38 10 00 	movl   $0x1038b5,(%esp)
  100c81:	e8 a9 f6 ff ff       	call   10032f <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c86:	ff 45 f4             	incl   -0xc(%ebp)
  100c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c8c:	83 f8 02             	cmp    $0x2,%eax
  100c8f:	76 bb                	jbe    100c4c <mon_help+0xf>
    }
    return 0;
  100c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c96:	89 ec                	mov    %ebp,%esp
  100c98:	5d                   	pop    %ebp
  100c99:	c3                   	ret    

00100c9a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c9a:	55                   	push   %ebp
  100c9b:	89 e5                	mov    %esp,%ebp
  100c9d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca0:	e8 ad fb ff ff       	call   100852 <print_kerninfo>
    return 0;
  100ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100caa:	89 ec                	mov    %ebp,%esp
  100cac:	5d                   	pop    %ebp
  100cad:	c3                   	ret    

00100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cae:	55                   	push   %ebp
  100caf:	89 e5                	mov    %esp,%ebp
  100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb4:	e8 e5 fc ff ff       	call   10099e <print_stackframe>
    return 0;
  100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbe:	89 ec                	mov    %ebp,%esp
  100cc0:	5d                   	pop    %ebp
  100cc1:	c3                   	ret    

00100cc2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc2:	55                   	push   %ebp
  100cc3:	89 e5                	mov    %esp,%ebp
  100cc5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc8:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100ccd:	85 c0                	test   %eax,%eax
  100ccf:	75 5b                	jne    100d2c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cd1:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100cd8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cdb:	8d 45 14             	lea    0x14(%ebp),%eax
  100cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cef:	c7 04 24 be 38 10 00 	movl   $0x1038be,(%esp)
  100cf6:	e8 34 f6 ff ff       	call   10032f <cprintf>
    vcprintf(fmt, ap);
  100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d02:	8b 45 10             	mov    0x10(%ebp),%eax
  100d05:	89 04 24             	mov    %eax,(%esp)
  100d08:	e8 ed f5 ff ff       	call   1002fa <vcprintf>
    cprintf("\n");
  100d0d:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  100d14:	e8 16 f6 ff ff       	call   10032f <cprintf>
    
    cprintf("stack trackback:\n");
  100d19:	c7 04 24 dc 38 10 00 	movl   $0x1038dc,(%esp)
  100d20:	e8 0a f6 ff ff       	call   10032f <cprintf>
    print_stackframe();
  100d25:	e8 74 fc ff ff       	call   10099e <print_stackframe>
  100d2a:	eb 01                	jmp    100d2d <__panic+0x6b>
        goto panic_dead;
  100d2c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d2d:	e8 81 09 00 00       	call   1016b3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d39:	e8 9d fe ff ff       	call   100bdb <kmonitor>
  100d3e:	eb f2                	jmp    100d32 <__panic+0x70>

00100d40 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
  100d43:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d46:	8d 45 14             	lea    0x14(%ebp),%eax
  100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d53:	8b 45 08             	mov    0x8(%ebp),%eax
  100d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5a:	c7 04 24 ee 38 10 00 	movl   $0x1038ee,(%esp)
  100d61:	e8 c9 f5 ff ff       	call   10032f <cprintf>
    vcprintf(fmt, ap);
  100d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d70:	89 04 24             	mov    %eax,(%esp)
  100d73:	e8 82 f5 ff ff       	call   1002fa <vcprintf>
    cprintf("\n");
  100d78:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  100d7f:	e8 ab f5 ff ff       	call   10032f <cprintf>
    va_end(ap);
}
  100d84:	90                   	nop
  100d85:	89 ec                	mov    %ebp,%esp
  100d87:	5d                   	pop    %ebp
  100d88:	c3                   	ret    

00100d89 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d8c:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d91:	5d                   	pop    %ebp
  100d92:	c3                   	ret    

00100d93 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d93:	55                   	push   %ebp
  100d94:	89 e5                	mov    %esp,%ebp
  100d96:	83 ec 28             	sub    $0x28,%esp
  100d99:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d9f:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100da3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dab:	ee                   	out    %al,(%dx)
}
  100dac:	90                   	nop
  100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbf:	ee                   	out    %al,(%dx)
}
  100dc0:	90                   	nop
  100dc1:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dc7:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dcb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dcf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd3:	ee                   	out    %al,(%dx)
}
  100dd4:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd5:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100ddc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddf:	c7 04 24 0c 39 10 00 	movl   $0x10390c,(%esp)
  100de6:	e8 44 f5 ff ff       	call   10032f <cprintf>
    pic_enable(IRQ_TIMER);
  100deb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df2:	e8 21 09 00 00       	call   101718 <pic_enable>
}
  100df7:	90                   	nop
  100df8:	89 ec                	mov    %ebp,%esp
  100dfa:	5d                   	pop    %ebp
  100dfb:	c3                   	ret    

00100dfc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dfc:	55                   	push   %ebp
  100dfd:	89 e5                	mov    %esp,%ebp
  100dff:	83 ec 10             	sub    $0x10,%esp
  100e02:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e08:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e12:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e18:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e1c:	89 c2                	mov    %eax,%edx
  100e1e:	ec                   	in     (%dx),%al
  100e1f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e22:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e28:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e2c:	89 c2                	mov    %eax,%edx
  100e2e:	ec                   	in     (%dx),%al
  100e2f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e32:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e38:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3c:	89 c2                	mov    %eax,%edx
  100e3e:	ec                   	in     (%dx),%al
  100e3f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e42:	90                   	nop
  100e43:	89 ec                	mov    %ebp,%esp
  100e45:	5d                   	pop    %ebp
  100e46:	c3                   	ret    

00100e47 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e47:	55                   	push   %ebp
  100e48:	89 e5                	mov    %esp,%ebp
  100e4a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e4d:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e57:	0f b7 00             	movzwl (%eax),%eax
  100e5a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e61:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e69:	0f b7 00             	movzwl (%eax),%eax
  100e6c:	0f b7 c0             	movzwl %ax,%eax
  100e6f:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e74:	74 12                	je     100e88 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e76:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e7d:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e84:	b4 03 
  100e86:	eb 13                	jmp    100e9b <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e8f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e92:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e99:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e9b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ea2:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ea6:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eaa:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eae:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100eb2:	ee                   	out    %al,(%dx)
}
  100eb3:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100eb4:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ebb:	40                   	inc    %eax
  100ebc:	0f b7 c0             	movzwl %ax,%eax
  100ebf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ec7:	89 c2                	mov    %eax,%edx
  100ec9:	ec                   	in     (%dx),%al
  100eca:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ecd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ed1:	0f b6 c0             	movzbl %al,%eax
  100ed4:	c1 e0 08             	shl    $0x8,%eax
  100ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eda:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ee1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ee5:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eed:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ef1:	ee                   	out    %al,(%dx)
}
  100ef2:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ef3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100efa:	40                   	inc    %eax
  100efb:	0f b7 c0             	movzwl %ax,%eax
  100efe:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f02:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f06:	89 c2                	mov    %eax,%edx
  100f08:	ec                   	in     (%dx),%al
  100f09:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f0c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f10:	0f b6 c0             	movzbl %al,%eax
  100f13:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f19:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f21:	0f b7 c0             	movzwl %ax,%eax
  100f24:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f2a:	90                   	nop
  100f2b:	89 ec                	mov    %ebp,%esp
  100f2d:	5d                   	pop    %ebp
  100f2e:	c3                   	ret    

00100f2f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f2f:	55                   	push   %ebp
  100f30:	89 e5                	mov    %esp,%ebp
  100f32:	83 ec 48             	sub    $0x48,%esp
  100f35:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f3b:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f3f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f43:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f47:	ee                   	out    %al,(%dx)
}
  100f48:	90                   	nop
  100f49:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f4f:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f53:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f57:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f5b:	ee                   	out    %al,(%dx)
}
  100f5c:	90                   	nop
  100f5d:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f63:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f67:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f6b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
}
  100f70:	90                   	nop
  100f71:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f77:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f7b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f7f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f83:	ee                   	out    %al,(%dx)
}
  100f84:	90                   	nop
  100f85:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f8b:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f93:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f97:	ee                   	out    %al,(%dx)
}
  100f98:	90                   	nop
  100f99:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f9f:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fa7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fab:	ee                   	out    %al,(%dx)
}
  100fac:	90                   	nop
  100fad:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fbb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
}
  100fc0:	90                   	nop
  100fc1:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fc7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fcb:	89 c2                	mov    %eax,%edx
  100fcd:	ec                   	in     (%dx),%al
  100fce:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fd1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fd5:	3c ff                	cmp    $0xff,%al
  100fd7:	0f 95 c0             	setne  %al
  100fda:	0f b6 c0             	movzbl %al,%eax
  100fdd:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fe2:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fe8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ff2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100ff8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ffc:	89 c2                	mov    %eax,%edx
  100ffe:	ec                   	in     (%dx),%al
  100fff:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101002:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101007:	85 c0                	test   %eax,%eax
  101009:	74 0c                	je     101017 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  10100b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101012:	e8 01 07 00 00       	call   101718 <pic_enable>
    }
}
  101017:	90                   	nop
  101018:	89 ec                	mov    %ebp,%esp
  10101a:	5d                   	pop    %ebp
  10101b:	c3                   	ret    

0010101c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10101c:	55                   	push   %ebp
  10101d:	89 e5                	mov    %esp,%ebp
  10101f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101029:	eb 08                	jmp    101033 <lpt_putc_sub+0x17>
        delay();
  10102b:	e8 cc fd ff ff       	call   100dfc <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101030:	ff 45 fc             	incl   -0x4(%ebp)
  101033:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101039:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10103d:	89 c2                	mov    %eax,%edx
  10103f:	ec                   	in     (%dx),%al
  101040:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101043:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101047:	84 c0                	test   %al,%al
  101049:	78 09                	js     101054 <lpt_putc_sub+0x38>
  10104b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101052:	7e d7                	jle    10102b <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101054:	8b 45 08             	mov    0x8(%ebp),%eax
  101057:	0f b6 c0             	movzbl %al,%eax
  10105a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101060:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101063:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101067:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10106b:	ee                   	out    %al,(%dx)
}
  10106c:	90                   	nop
  10106d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101073:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101077:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10107b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10107f:	ee                   	out    %al,(%dx)
}
  101080:	90                   	nop
  101081:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101087:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10108b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10108f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101093:	ee                   	out    %al,(%dx)
}
  101094:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101095:	90                   	nop
  101096:	89 ec                	mov    %ebp,%esp
  101098:	5d                   	pop    %ebp
  101099:	c3                   	ret    

0010109a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109a:	55                   	push   %ebp
  10109b:	89 e5                	mov    %esp,%ebp
  10109d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a4:	74 0d                	je     1010b3 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a9:	89 04 24             	mov    %eax,(%esp)
  1010ac:	e8 6b ff ff ff       	call   10101c <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b1:	eb 24                	jmp    1010d7 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010b3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ba:	e8 5d ff ff ff       	call   10101c <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010bf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010c6:	e8 51 ff ff ff       	call   10101c <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010cb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d2:	e8 45 ff ff ff       	call   10101c <lpt_putc_sub>
}
  1010d7:	90                   	nop
  1010d8:	89 ec                	mov    %ebp,%esp
  1010da:	5d                   	pop    %ebp
  1010db:	c3                   	ret    

001010dc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010dc:	55                   	push   %ebp
  1010dd:	89 e5                	mov    %esp,%ebp
  1010df:	83 ec 38             	sub    $0x38,%esp
  1010e2:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e8:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ed:	85 c0                	test   %eax,%eax
  1010ef:	75 07                	jne    1010f8 <cga_putc+0x1c>
        c |= 0x0700;
  1010f1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fb:	0f b6 c0             	movzbl %al,%eax
  1010fe:	83 f8 0d             	cmp    $0xd,%eax
  101101:	74 72                	je     101175 <cga_putc+0x99>
  101103:	83 f8 0d             	cmp    $0xd,%eax
  101106:	0f 8f a3 00 00 00    	jg     1011af <cga_putc+0xd3>
  10110c:	83 f8 08             	cmp    $0x8,%eax
  10110f:	74 0a                	je     10111b <cga_putc+0x3f>
  101111:	83 f8 0a             	cmp    $0xa,%eax
  101114:	74 4c                	je     101162 <cga_putc+0x86>
  101116:	e9 94 00 00 00       	jmp    1011af <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101122:	85 c0                	test   %eax,%eax
  101124:	0f 84 af 00 00 00    	je     1011d9 <cga_putc+0xfd>
            crt_pos --;
  10112a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101131:	48                   	dec    %eax
  101132:	0f b7 c0             	movzwl %ax,%eax
  101135:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113b:	8b 45 08             	mov    0x8(%ebp),%eax
  10113e:	98                   	cwtl   
  10113f:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101144:	98                   	cwtl   
  101145:	83 c8 20             	or     $0x20,%eax
  101148:	98                   	cwtl   
  101149:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10114f:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101156:	01 d2                	add    %edx,%edx
  101158:	01 ca                	add    %ecx,%edx
  10115a:	0f b7 c0             	movzwl %ax,%eax
  10115d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101160:	eb 77                	jmp    1011d9 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101162:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101169:	83 c0 50             	add    $0x50,%eax
  10116c:	0f b7 c0             	movzwl %ax,%eax
  10116f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101175:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10117c:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101183:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101188:	89 c8                	mov    %ecx,%eax
  10118a:	f7 e2                	mul    %edx
  10118c:	c1 ea 06             	shr    $0x6,%edx
  10118f:	89 d0                	mov    %edx,%eax
  101191:	c1 e0 02             	shl    $0x2,%eax
  101194:	01 d0                	add    %edx,%eax
  101196:	c1 e0 04             	shl    $0x4,%eax
  101199:	29 c1                	sub    %eax,%ecx
  10119b:	89 ca                	mov    %ecx,%edx
  10119d:	0f b7 d2             	movzwl %dx,%edx
  1011a0:	89 d8                	mov    %ebx,%eax
  1011a2:	29 d0                	sub    %edx,%eax
  1011a4:	0f b7 c0             	movzwl %ax,%eax
  1011a7:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011ad:	eb 2b                	jmp    1011da <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011af:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011b5:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011bc:	8d 50 01             	lea    0x1(%eax),%edx
  1011bf:	0f b7 d2             	movzwl %dx,%edx
  1011c2:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011c9:	01 c0                	add    %eax,%eax
  1011cb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d1:	0f b7 c0             	movzwl %ax,%eax
  1011d4:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d7:	eb 01                	jmp    1011da <cga_putc+0xfe>
        break;
  1011d9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011da:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011e1:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011e6:	76 5e                	jbe    101246 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e8:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011ed:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f3:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011f8:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ff:	00 
  101200:	89 54 24 04          	mov    %edx,0x4(%esp)
  101204:	89 04 24             	mov    %eax,(%esp)
  101207:	e8 86 22 00 00       	call   103492 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101213:	eb 15                	jmp    10122a <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101215:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10121e:	01 c0                	add    %eax,%eax
  101220:	01 d0                	add    %edx,%eax
  101222:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101227:	ff 45 f4             	incl   -0xc(%ebp)
  10122a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101231:	7e e2                	jle    101215 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101233:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10123a:	83 e8 50             	sub    $0x50,%eax
  10123d:	0f b7 c0             	movzwl %ax,%eax
  101240:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101246:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10124d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101251:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101255:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101259:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10125d:	ee                   	out    %al,(%dx)
}
  10125e:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10125f:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101266:	c1 e8 08             	shr    $0x8,%eax
  101269:	0f b7 c0             	movzwl %ax,%eax
  10126c:	0f b6 c0             	movzbl %al,%eax
  10126f:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101276:	42                   	inc    %edx
  101277:	0f b7 d2             	movzwl %dx,%edx
  10127a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10127e:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101281:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101285:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101289:	ee                   	out    %al,(%dx)
}
  10128a:	90                   	nop
    outb(addr_6845, 15);
  10128b:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101292:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101296:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10129e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012a2:	ee                   	out    %al,(%dx)
}
  1012a3:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012a4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012ab:	0f b6 c0             	movzbl %al,%eax
  1012ae:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012b5:	42                   	inc    %edx
  1012b6:	0f b7 d2             	movzwl %dx,%edx
  1012b9:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012bd:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012c4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012c8:	ee                   	out    %al,(%dx)
}
  1012c9:	90                   	nop
}
  1012ca:	90                   	nop
  1012cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012ce:	89 ec                	mov    %ebp,%esp
  1012d0:	5d                   	pop    %ebp
  1012d1:	c3                   	ret    

001012d2 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d2:	55                   	push   %ebp
  1012d3:	89 e5                	mov    %esp,%ebp
  1012d5:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012df:	eb 08                	jmp    1012e9 <serial_putc_sub+0x17>
        delay();
  1012e1:	e8 16 fb ff ff       	call   100dfc <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e6:	ff 45 fc             	incl   -0x4(%ebp)
  1012e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f3:	89 c2                	mov    %eax,%edx
  1012f5:	ec                   	in     (%dx),%al
  1012f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012fd:	0f b6 c0             	movzbl %al,%eax
  101300:	83 e0 20             	and    $0x20,%eax
  101303:	85 c0                	test   %eax,%eax
  101305:	75 09                	jne    101310 <serial_putc_sub+0x3e>
  101307:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10130e:	7e d1                	jle    1012e1 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	0f b6 c0             	movzbl %al,%eax
  101316:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10131c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10131f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101323:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101327:	ee                   	out    %al,(%dx)
}
  101328:	90                   	nop
}
  101329:	90                   	nop
  10132a:	89 ec                	mov    %ebp,%esp
  10132c:	5d                   	pop    %ebp
  10132d:	c3                   	ret    

0010132e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10132e:	55                   	push   %ebp
  10132f:	89 e5                	mov    %esp,%ebp
  101331:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101334:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101338:	74 0d                	je     101347 <serial_putc+0x19>
        serial_putc_sub(c);
  10133a:	8b 45 08             	mov    0x8(%ebp),%eax
  10133d:	89 04 24             	mov    %eax,(%esp)
  101340:	e8 8d ff ff ff       	call   1012d2 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101345:	eb 24                	jmp    10136b <serial_putc+0x3d>
        serial_putc_sub('\b');
  101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134e:	e8 7f ff ff ff       	call   1012d2 <serial_putc_sub>
        serial_putc_sub(' ');
  101353:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10135a:	e8 73 ff ff ff       	call   1012d2 <serial_putc_sub>
        serial_putc_sub('\b');
  10135f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101366:	e8 67 ff ff ff       	call   1012d2 <serial_putc_sub>
}
  10136b:	90                   	nop
  10136c:	89 ec                	mov    %ebp,%esp
  10136e:	5d                   	pop    %ebp
  10136f:	c3                   	ret    

00101370 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101370:	55                   	push   %ebp
  101371:	89 e5                	mov    %esp,%ebp
  101373:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101376:	eb 33                	jmp    1013ab <cons_intr+0x3b>
        if (c != 0) {
  101378:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10137c:	74 2d                	je     1013ab <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10137e:	a1 84 00 11 00       	mov    0x110084,%eax
  101383:	8d 50 01             	lea    0x1(%eax),%edx
  101386:	89 15 84 00 11 00    	mov    %edx,0x110084
  10138c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10138f:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101395:	a1 84 00 11 00       	mov    0x110084,%eax
  10139a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10139f:	75 0a                	jne    1013ab <cons_intr+0x3b>
                cons.wpos = 0;
  1013a1:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013a8:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ae:	ff d0                	call   *%eax
  1013b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b7:	75 bf                	jne    101378 <cons_intr+0x8>
            }
        }
    }
}
  1013b9:	90                   	nop
  1013ba:	90                   	nop
  1013bb:	89 ec                	mov    %ebp,%esp
  1013bd:	5d                   	pop    %ebp
  1013be:	c3                   	ret    

001013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013bf:	55                   	push   %ebp
  1013c0:	89 e5                	mov    %esp,%ebp
  1013c2:	83 ec 10             	sub    $0x10,%esp
  1013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013cf:	89 c2                	mov    %eax,%edx
  1013d1:	ec                   	in     (%dx),%al
  1013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d9:	0f b6 c0             	movzbl %al,%eax
  1013dc:	83 e0 01             	and    $0x1,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 07                	jne    1013ea <serial_proc_data+0x2b>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	eb 2a                	jmp    101414 <serial_proc_data+0x55>
  1013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f4:	89 c2                	mov    %eax,%edx
  1013f6:	ec                   	in     (%dx),%al
  1013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013fe:	0f b6 c0             	movzbl %al,%eax
  101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101408:	75 07                	jne    101411 <serial_proc_data+0x52>
        c = '\b';
  10140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101414:	89 ec                	mov    %ebp,%esp
  101416:	5d                   	pop    %ebp
  101417:	c3                   	ret    

00101418 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101418:	55                   	push   %ebp
  101419:	89 e5                	mov    %esp,%ebp
  10141b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10141e:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101423:	85 c0                	test   %eax,%eax
  101425:	74 0c                	je     101433 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101427:	c7 04 24 bf 13 10 00 	movl   $0x1013bf,(%esp)
  10142e:	e8 3d ff ff ff       	call   101370 <cons_intr>
    }
}
  101433:	90                   	nop
  101434:	89 ec                	mov    %ebp,%esp
  101436:	5d                   	pop    %ebp
  101437:	c3                   	ret    

00101438 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101438:	55                   	push   %ebp
  101439:	89 e5                	mov    %esp,%ebp
  10143b:	83 ec 38             	sub    $0x38,%esp
  10143e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101447:	89 c2                	mov    %eax,%edx
  101449:	ec                   	in     (%dx),%al
  10144a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10144d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101451:	0f b6 c0             	movzbl %al,%eax
  101454:	83 e0 01             	and    $0x1,%eax
  101457:	85 c0                	test   %eax,%eax
  101459:	75 0a                	jne    101465 <kbd_proc_data+0x2d>
        return -1;
  10145b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101460:	e9 56 01 00 00       	jmp    1015bb <kbd_proc_data+0x183>
  101465:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10146b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10146e:	89 c2                	mov    %eax,%edx
  101470:	ec                   	in     (%dx),%al
  101471:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101474:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101478:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10147b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10147f:	75 17                	jne    101498 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101481:	a1 88 00 11 00       	mov    0x110088,%eax
  101486:	83 c8 40             	or     $0x40,%eax
  101489:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10148e:	b8 00 00 00 00       	mov    $0x0,%eax
  101493:	e9 23 01 00 00       	jmp    1015bb <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101498:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149c:	84 c0                	test   %al,%al
  10149e:	79 45                	jns    1014e5 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014a0:	a1 88 00 11 00       	mov    0x110088,%eax
  1014a5:	83 e0 40             	and    $0x40,%eax
  1014a8:	85 c0                	test   %eax,%eax
  1014aa:	75 08                	jne    1014b4 <kbd_proc_data+0x7c>
  1014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b0:	24 7f                	and    $0x7f,%al
  1014b2:	eb 04                	jmp    1014b8 <kbd_proc_data+0x80>
  1014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014bb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bf:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014c6:	0c 40                	or     $0x40,%al
  1014c8:	0f b6 c0             	movzbl %al,%eax
  1014cb:	f7 d0                	not    %eax
  1014cd:	89 c2                	mov    %eax,%edx
  1014cf:	a1 88 00 11 00       	mov    0x110088,%eax
  1014d4:	21 d0                	and    %edx,%eax
  1014d6:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014db:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e0:	e9 d6 00 00 00       	jmp    1015bb <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014e5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ea:	83 e0 40             	and    $0x40,%eax
  1014ed:	85 c0                	test   %eax,%eax
  1014ef:	74 11                	je     101502 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014f1:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014fa:	83 e0 bf             	and    $0xffffffbf,%eax
  1014fd:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101506:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10150d:	0f b6 d0             	movzbl %al,%edx
  101510:	a1 88 00 11 00       	mov    0x110088,%eax
  101515:	09 d0                	or     %edx,%eax
  101517:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101520:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101527:	0f b6 d0             	movzbl %al,%edx
  10152a:	a1 88 00 11 00       	mov    0x110088,%eax
  10152f:	31 d0                	xor    %edx,%eax
  101531:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101536:	a1 88 00 11 00       	mov    0x110088,%eax
  10153b:	83 e0 03             	and    $0x3,%eax
  10153e:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101549:	01 d0                	add    %edx,%eax
  10154b:	0f b6 00             	movzbl (%eax),%eax
  10154e:	0f b6 c0             	movzbl %al,%eax
  101551:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101554:	a1 88 00 11 00       	mov    0x110088,%eax
  101559:	83 e0 08             	and    $0x8,%eax
  10155c:	85 c0                	test   %eax,%eax
  10155e:	74 22                	je     101582 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101560:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101564:	7e 0c                	jle    101572 <kbd_proc_data+0x13a>
  101566:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10156a:	7f 06                	jg     101572 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10156c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101570:	eb 10                	jmp    101582 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101572:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101576:	7e 0a                	jle    101582 <kbd_proc_data+0x14a>
  101578:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10157c:	7f 04                	jg     101582 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10157e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101582:	a1 88 00 11 00       	mov    0x110088,%eax
  101587:	f7 d0                	not    %eax
  101589:	83 e0 06             	and    $0x6,%eax
  10158c:	85 c0                	test   %eax,%eax
  10158e:	75 28                	jne    1015b8 <kbd_proc_data+0x180>
  101590:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101597:	75 1f                	jne    1015b8 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101599:	c7 04 24 27 39 10 00 	movl   $0x103927,(%esp)
  1015a0:	e8 8a ed ff ff       	call   10032f <cprintf>
  1015a5:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015ab:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015b6:	ee                   	out    %al,(%dx)
}
  1015b7:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015bb:	89 ec                	mov    %ebp,%esp
  1015bd:	5d                   	pop    %ebp
  1015be:	c3                   	ret    

001015bf <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015bf:	55                   	push   %ebp
  1015c0:	89 e5                	mov    %esp,%ebp
  1015c2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c5:	c7 04 24 38 14 10 00 	movl   $0x101438,(%esp)
  1015cc:	e8 9f fd ff ff       	call   101370 <cons_intr>
}
  1015d1:	90                   	nop
  1015d2:	89 ec                	mov    %ebp,%esp
  1015d4:	5d                   	pop    %ebp
  1015d5:	c3                   	ret    

001015d6 <kbd_init>:

static void
kbd_init(void) {
  1015d6:	55                   	push   %ebp
  1015d7:	89 e5                	mov    %esp,%ebp
  1015d9:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015dc:	e8 de ff ff ff       	call   1015bf <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e8:	e8 2b 01 00 00       	call   101718 <pic_enable>
}
  1015ed:	90                   	nop
  1015ee:	89 ec                	mov    %ebp,%esp
  1015f0:	5d                   	pop    %ebp
  1015f1:	c3                   	ret    

001015f2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f2:	55                   	push   %ebp
  1015f3:	89 e5                	mov    %esp,%ebp
  1015f5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015f8:	e8 4a f8 ff ff       	call   100e47 <cga_init>
    serial_init();
  1015fd:	e8 2d f9 ff ff       	call   100f2f <serial_init>
    kbd_init();
  101602:	e8 cf ff ff ff       	call   1015d6 <kbd_init>
    if (!serial_exists) {
  101607:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10160c:	85 c0                	test   %eax,%eax
  10160e:	75 0c                	jne    10161c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101610:	c7 04 24 33 39 10 00 	movl   $0x103933,(%esp)
  101617:	e8 13 ed ff ff       	call   10032f <cprintf>
    }
}
  10161c:	90                   	nop
  10161d:	89 ec                	mov    %ebp,%esp
  10161f:	5d                   	pop    %ebp
  101620:	c3                   	ret    

00101621 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101621:	55                   	push   %ebp
  101622:	89 e5                	mov    %esp,%ebp
  101624:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101627:	8b 45 08             	mov    0x8(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 68 fa ff ff       	call   10109a <lpt_putc>
    cga_putc(c);
  101632:	8b 45 08             	mov    0x8(%ebp),%eax
  101635:	89 04 24             	mov    %eax,(%esp)
  101638:	e8 9f fa ff ff       	call   1010dc <cga_putc>
    serial_putc(c);
  10163d:	8b 45 08             	mov    0x8(%ebp),%eax
  101640:	89 04 24             	mov    %eax,(%esp)
  101643:	e8 e6 fc ff ff       	call   10132e <serial_putc>
}
  101648:	90                   	nop
  101649:	89 ec                	mov    %ebp,%esp
  10164b:	5d                   	pop    %ebp
  10164c:	c3                   	ret    

0010164d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101653:	e8 c0 fd ff ff       	call   101418 <serial_intr>
    kbd_intr();
  101658:	e8 62 ff ff ff       	call   1015bf <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10165d:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101663:	a1 84 00 11 00       	mov    0x110084,%eax
  101668:	39 c2                	cmp    %eax,%edx
  10166a:	74 36                	je     1016a2 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10166c:	a1 80 00 11 00       	mov    0x110080,%eax
  101671:	8d 50 01             	lea    0x1(%eax),%edx
  101674:	89 15 80 00 11 00    	mov    %edx,0x110080
  10167a:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101681:	0f b6 c0             	movzbl %al,%eax
  101684:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101687:	a1 80 00 11 00       	mov    0x110080,%eax
  10168c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101691:	75 0a                	jne    10169d <cons_getc+0x50>
            cons.rpos = 0;
  101693:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10169a:	00 00 00 
        }
        return c;
  10169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016a0:	eb 05                	jmp    1016a7 <cons_getc+0x5a>
    }
    return 0;
  1016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016a7:	89 ec                	mov    %ebp,%esp
  1016a9:	5d                   	pop    %ebp
  1016aa:	c3                   	ret    

001016ab <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ab:	55                   	push   %ebp
  1016ac:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ae:	fb                   	sti    
}
  1016af:	90                   	nop
    sti();
}
  1016b0:	90                   	nop
  1016b1:	5d                   	pop    %ebp
  1016b2:	c3                   	ret    

001016b3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b3:	55                   	push   %ebp
  1016b4:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016b6:	fa                   	cli    
}
  1016b7:	90                   	nop
    cli();
}
  1016b8:	90                   	nop
  1016b9:	5d                   	pop    %ebp
  1016ba:	c3                   	ret    

001016bb <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016bb:	55                   	push   %ebp
  1016bc:	89 e5                	mov    %esp,%ebp
  1016be:	83 ec 14             	sub    $0x14,%esp
  1016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016cb:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016d1:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016d6:	85 c0                	test   %eax,%eax
  1016d8:	74 39                	je     101713 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016dd:	0f b6 c0             	movzbl %al,%eax
  1016e0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016e6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016e9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ed:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f1:	ee                   	out    %al,(%dx)
}
  1016f2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f7:	c1 e8 08             	shr    $0x8,%eax
  1016fa:	0f b7 c0             	movzwl %ax,%eax
  1016fd:	0f b6 c0             	movzbl %al,%eax
  101700:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101706:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101709:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10170d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101711:	ee                   	out    %al,(%dx)
}
  101712:	90                   	nop
    }
}
  101713:	90                   	nop
  101714:	89 ec                	mov    %ebp,%esp
  101716:	5d                   	pop    %ebp
  101717:	c3                   	ret    

00101718 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101718:	55                   	push   %ebp
  101719:	89 e5                	mov    %esp,%ebp
  10171b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10171e:	8b 45 08             	mov    0x8(%ebp),%eax
  101721:	ba 01 00 00 00       	mov    $0x1,%edx
  101726:	88 c1                	mov    %al,%cl
  101728:	d3 e2                	shl    %cl,%edx
  10172a:	89 d0                	mov    %edx,%eax
  10172c:	98                   	cwtl   
  10172d:	f7 d0                	not    %eax
  10172f:	0f bf d0             	movswl %ax,%edx
  101732:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101739:	98                   	cwtl   
  10173a:	21 d0                	and    %edx,%eax
  10173c:	98                   	cwtl   
  10173d:	0f b7 c0             	movzwl %ax,%eax
  101740:	89 04 24             	mov    %eax,(%esp)
  101743:	e8 73 ff ff ff       	call   1016bb <pic_setmask>
}
  101748:	90                   	nop
  101749:	89 ec                	mov    %ebp,%esp
  10174b:	5d                   	pop    %ebp
  10174c:	c3                   	ret    

0010174d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10174d:	55                   	push   %ebp
  10174e:	89 e5                	mov    %esp,%ebp
  101750:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101753:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10175a:	00 00 00 
  10175d:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101763:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101767:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10176b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
}
  101770:	90                   	nop
  101771:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101777:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10177b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10177f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
}
  101784:	90                   	nop
  101785:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10178b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10178f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101793:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
}
  101798:	90                   	nop
  101799:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10179f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a3:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a7:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ab:	ee                   	out    %al,(%dx)
}
  1017ac:	90                   	nop
  1017ad:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017b3:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b7:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017bb:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
}
  1017c0:	90                   	nop
  1017c1:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017c7:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017cb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017cf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017d3:	ee                   	out    %al,(%dx)
}
  1017d4:	90                   	nop
  1017d5:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017db:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017df:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
}
  1017e8:	90                   	nop
  1017e9:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017ef:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017f7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017fb:	ee                   	out    %al,(%dx)
}
  1017fc:	90                   	nop
  1017fd:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101803:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101807:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10180b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10180f:	ee                   	out    %al,(%dx)
}
  101810:	90                   	nop
  101811:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101817:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10181f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
}
  101824:	90                   	nop
  101825:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10182b:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101833:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101837:	ee                   	out    %al,(%dx)
}
  101838:	90                   	nop
  101839:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10183f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101843:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101847:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
}
  10184c:	90                   	nop
  10184d:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101853:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101857:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10185b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10185f:	ee                   	out    %al,(%dx)
}
  101860:	90                   	nop
  101861:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101867:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10186b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10186f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101873:	ee                   	out    %al,(%dx)
}
  101874:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101875:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10187c:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101881:	74 0f                	je     101892 <pic_init+0x145>
        pic_setmask(irq_mask);
  101883:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10188a:	89 04 24             	mov    %eax,(%esp)
  10188d:	e8 29 fe ff ff       	call   1016bb <pic_setmask>
    }
}
  101892:	90                   	nop
  101893:	89 ec                	mov    %ebp,%esp
  101895:	5d                   	pop    %ebp
  101896:	c3                   	ret    

00101897 <print_ticks>:
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks()
{
  101897:	55                   	push   %ebp
  101898:	89 e5                	mov    %esp,%ebp
  10189a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  10189d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018a4:	00 
  1018a5:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  1018ac:	e8 7e ea ff ff       	call   10032f <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018b1:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  1018b8:	e8 72 ea ff ff       	call   10032f <cprintf>
    panic("EOT: kernel seems ok.");
  1018bd:	c7 44 24 08 78 39 10 	movl   $0x103978,0x8(%esp)
  1018c4:	00 
  1018c5:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  1018cc:	00 
  1018cd:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  1018d4:	e8 e9 f3 ff ff       	call   100cc2 <__panic>

001018d9 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  1018d9:	55                   	push   %ebp
  1018da:	89 e5                	mov    %esp,%ebp
  1018dc:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
  1018df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018e6:	e9 c4 00 00 00       	jmp    1019af <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ee:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018f5:	0f b7 d0             	movzwl %ax,%edx
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  101902:	00 
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  10190d:	00 08 00 
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10191a:	00 
  10191b:	80 e2 e0             	and    $0xe0,%dl
  10191e:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101928:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10192f:	00 
  101930:	80 e2 1f             	and    $0x1f,%dl
  101933:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  10193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193d:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101944:	00 
  101945:	80 e2 f0             	and    $0xf0,%dl
  101948:	80 ca 0e             	or     $0xe,%dl
  10194b:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  10195c:	00 
  10195d:	80 e2 ef             	and    $0xef,%dl
  101960:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196a:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101971:	00 
  101972:	80 e2 9f             	and    $0x9f,%dl
  101975:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197f:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101986:	00 
  101987:	80 ca 80             	or     $0x80,%dl
  10198a:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101994:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10199b:	c1 e8 10             	shr    $0x10,%eax
  10199e:	0f b7 d0             	movzwl %ax,%edx
  1019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a4:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  1019ab:	00 
    for (int i = 0; i < 256; i++)
  1019ac:	ff 45 fc             	incl   -0x4(%ebp)
  1019af:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019b6:	0f 8e 2f ff ff ff    	jle    1018eb <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019bc:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019c1:	0f b7 c0             	movzwl %ax,%eax
  1019c4:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  1019ca:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  1019d1:	08 00 
  1019d3:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019da:	24 e0                	and    $0xe0,%al
  1019dc:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019e1:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019e8:	24 1f                	and    $0x1f,%al
  1019ea:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019ef:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019f6:	24 f0                	and    $0xf0,%al
  1019f8:	0c 0e                	or     $0xe,%al
  1019fa:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019ff:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a06:	24 ef                	and    $0xef,%al
  101a08:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a0d:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a14:	0c 60                	or     $0x60,%al
  101a16:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a1b:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a22:	0c 80                	or     $0x80,%al
  101a24:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a29:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a2e:	c1 e8 10             	shr    $0x10,%eax
  101a31:	0f b7 c0             	movzwl %ax,%eax
  101a34:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  101a3a:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a44:	0f 01 18             	lidtl  (%eax)
}
  101a47:	90                   	nop
    lidt(&idt_pd);
}
  101a48:	90                   	nop
  101a49:	89 ec                	mov    %ebp,%esp
  101a4b:	5d                   	pop    %ebp
  101a4c:	c3                   	ret    

00101a4d <trapname>:

static const char *
trapname(int trapno)
{
  101a4d:	55                   	push   %ebp
  101a4e:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  101a50:	8b 45 08             	mov    0x8(%ebp),%eax
  101a53:	83 f8 13             	cmp    $0x13,%eax
  101a56:	77 0c                	ja     101a64 <trapname+0x17>
    {
        return excnames[trapno];
  101a58:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5b:	8b 04 85 e0 3c 10 00 	mov    0x103ce0(,%eax,4),%eax
  101a62:	eb 18                	jmp    101a7c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101a64:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a68:	7e 0d                	jle    101a77 <trapname+0x2a>
  101a6a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6e:	7f 07                	jg     101a77 <trapname+0x2a>
    {
        return "Hardware Interrupt";
  101a70:	b8 9f 39 10 00       	mov    $0x10399f,%eax
  101a75:	eb 05                	jmp    101a7c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a77:	b8 b2 39 10 00       	mov    $0x1039b2,%eax
}
  101a7c:	5d                   	pop    %ebp
  101a7d:	c3                   	ret    

00101a7e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  101a7e:	55                   	push   %ebp
  101a7f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a88:	83 f8 08             	cmp    $0x8,%eax
  101a8b:	0f 94 c0             	sete   %al
  101a8e:	0f b6 c0             	movzbl %al,%eax
}
  101a91:	5d                   	pop    %ebp
  101a92:	c3                   	ret    

00101a93 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  101a93:	55                   	push   %ebp
  101a94:	89 e5                	mov    %esp,%ebp
  101a96:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa0:	c7 04 24 f3 39 10 00 	movl   $0x1039f3,(%esp)
  101aa7:	e8 83 e8 ff ff       	call   10032f <cprintf>
    print_regs(&tf->tf_regs);
  101aac:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaf:	89 04 24             	mov    %eax,(%esp)
  101ab2:	e8 8f 01 00 00       	call   101c46 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aba:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac2:	c7 04 24 04 3a 10 00 	movl   $0x103a04,(%esp)
  101ac9:	e8 61 e8 ff ff       	call   10032f <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad9:	c7 04 24 17 3a 10 00 	movl   $0x103a17,(%esp)
  101ae0:	e8 4a e8 ff ff       	call   10032f <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101af7:	e8 33 e8 ff ff       	call   10032f <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b07:	c7 04 24 3d 3a 10 00 	movl   $0x103a3d,(%esp)
  101b0e:	e8 1c e8 ff ff       	call   10032f <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b13:	8b 45 08             	mov    0x8(%ebp),%eax
  101b16:	8b 40 30             	mov    0x30(%eax),%eax
  101b19:	89 04 24             	mov    %eax,(%esp)
  101b1c:	e8 2c ff ff ff       	call   101a4d <trapname>
  101b21:	8b 55 08             	mov    0x8(%ebp),%edx
  101b24:	8b 52 30             	mov    0x30(%edx),%edx
  101b27:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b2b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b2f:	c7 04 24 50 3a 10 00 	movl   $0x103a50,(%esp)
  101b36:	e8 f4 e7 ff ff       	call   10032f <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	8b 40 34             	mov    0x34(%eax),%eax
  101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b45:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101b4c:	e8 de e7 ff ff       	call   10032f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	8b 40 38             	mov    0x38(%eax),%eax
  101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5b:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  101b62:	e8 c8 e7 ff ff       	call   10032f <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  101b79:	e8 b1 e7 ff ff       	call   10032f <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	8b 40 40             	mov    0x40(%eax),%eax
  101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b88:	c7 04 24 93 3a 10 00 	movl   $0x103a93,(%esp)
  101b8f:	e8 9b e7 ff ff       	call   10032f <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ba2:	eb 3d                	jmp    101be1 <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	8b 50 40             	mov    0x40(%eax),%edx
  101baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bad:	21 d0                	and    %edx,%eax
  101baf:	85 c0                	test   %eax,%eax
  101bb1:	74 28                	je     101bdb <print_trapframe+0x148>
  101bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb6:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bbd:	85 c0                	test   %eax,%eax
  101bbf:	74 1a                	je     101bdb <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
  101bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc4:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcf:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101bd6:	e8 54 e7 ff ff       	call   10032f <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101bdb:	ff 45 f4             	incl   -0xc(%ebp)
  101bde:	d1 65 f0             	shll   -0x10(%ebp)
  101be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be4:	83 f8 17             	cmp    $0x17,%eax
  101be7:	76 bb                	jbe    101ba4 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	8b 40 40             	mov    0x40(%eax),%eax
  101bef:	c1 e8 0c             	shr    $0xc,%eax
  101bf2:	83 e0 03             	and    $0x3,%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  101c00:	e8 2a e7 ff ff       	call   10032f <cprintf>

    if (!trap_in_kernel(tf))
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	89 04 24             	mov    %eax,(%esp)
  101c0b:	e8 6e fe ff ff       	call   101a7e <trap_in_kernel>
  101c10:	85 c0                	test   %eax,%eax
  101c12:	75 2d                	jne    101c41 <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c14:	8b 45 08             	mov    0x8(%ebp),%eax
  101c17:	8b 40 44             	mov    0x44(%eax),%eax
  101c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1e:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101c25:	e8 05 e7 ff ff       	call   10032f <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c35:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101c3c:	e8 ee e6 ff ff       	call   10032f <cprintf>
    }
}
  101c41:	90                   	nop
  101c42:	89 ec                	mov    %ebp,%esp
  101c44:	5d                   	pop    %ebp
  101c45:	c3                   	ret    

00101c46 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101c46:	55                   	push   %ebp
  101c47:	89 e5                	mov    %esp,%ebp
  101c49:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4f:	8b 00                	mov    (%eax),%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101c5c:	e8 ce e6 ff ff       	call   10032f <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 04             	mov    0x4(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101c72:	e8 b8 e6 ff ff       	call   10032f <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 08             	mov    0x8(%eax),%eax
  101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c81:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101c88:	e8 a2 e6 ff ff       	call   10032f <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	8b 40 0c             	mov    0xc(%eax),%eax
  101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c97:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101c9e:	e8 8c e6 ff ff       	call   10032f <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca6:	8b 40 10             	mov    0x10(%eax),%eax
  101ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cad:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101cb4:	e8 76 e6 ff ff       	call   10032f <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbc:	8b 40 14             	mov    0x14(%eax),%eax
  101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc3:	c7 04 24 1c 3b 10 00 	movl   $0x103b1c,(%esp)
  101cca:	e8 60 e6 ff ff       	call   10032f <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd2:	8b 40 18             	mov    0x18(%eax),%eax
  101cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd9:	c7 04 24 2b 3b 10 00 	movl   $0x103b2b,(%esp)
  101ce0:	e8 4a e6 ff ff       	call   10032f <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cef:	c7 04 24 3a 3b 10 00 	movl   $0x103b3a,(%esp)
  101cf6:	e8 34 e6 ff ff       	call   10032f <cprintf>
}
  101cfb:	90                   	nop
  101cfc:	89 ec                	mov    %ebp,%esp
  101cfe:	5d                   	pop    %ebp
  101cff:	c3                   	ret    

00101d00 <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
  101d00:	55                   	push   %ebp
  101d01:	89 e5                	mov    %esp,%ebp
  101d03:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
  101d06:	8b 45 08             	mov    0x8(%ebp),%eax
  101d09:	8b 40 30             	mov    0x30(%eax),%eax
  101d0c:	83 f8 79             	cmp    $0x79,%eax
  101d0f:	0f 84 1f 01 00 00    	je     101e34 <trap_dispatch+0x134>
  101d15:	83 f8 79             	cmp    $0x79,%eax
  101d18:	0f 87 69 01 00 00    	ja     101e87 <trap_dispatch+0x187>
  101d1e:	83 f8 78             	cmp    $0x78,%eax
  101d21:	0f 84 b7 00 00 00    	je     101dde <trap_dispatch+0xde>
  101d27:	83 f8 78             	cmp    $0x78,%eax
  101d2a:	0f 87 57 01 00 00    	ja     101e87 <trap_dispatch+0x187>
  101d30:	83 f8 2f             	cmp    $0x2f,%eax
  101d33:	0f 87 4e 01 00 00    	ja     101e87 <trap_dispatch+0x187>
  101d39:	83 f8 2e             	cmp    $0x2e,%eax
  101d3c:	0f 83 7a 01 00 00    	jae    101ebc <trap_dispatch+0x1bc>
  101d42:	83 f8 24             	cmp    $0x24,%eax
  101d45:	74 45                	je     101d8c <trap_dispatch+0x8c>
  101d47:	83 f8 24             	cmp    $0x24,%eax
  101d4a:	0f 87 37 01 00 00    	ja     101e87 <trap_dispatch+0x187>
  101d50:	83 f8 20             	cmp    $0x20,%eax
  101d53:	74 0a                	je     101d5f <trap_dispatch+0x5f>
  101d55:	83 f8 21             	cmp    $0x21,%eax
  101d58:	74 5b                	je     101db5 <trap_dispatch+0xb5>
  101d5a:	e9 28 01 00 00       	jmp    101e87 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d5f:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d64:	40                   	inc    %eax
  101d65:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks == TICK_NUM)
  101d6a:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d6f:	83 f8 64             	cmp    $0x64,%eax
  101d72:	0f 85 47 01 00 00    	jne    101ebf <trap_dispatch+0x1bf>
        {
            ticks = 0;
  101d78:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  101d7f:	00 00 00 
            print_ticks();
  101d82:	e8 10 fb ff ff       	call   101897 <print_ticks>
        }
        break;
  101d87:	e9 33 01 00 00       	jmp    101ebf <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d8c:	e8 bc f8 ff ff       	call   10164d <cons_getc>
  101d91:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d94:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d98:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d9c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da4:	c7 04 24 49 3b 10 00 	movl   $0x103b49,(%esp)
  101dab:	e8 7f e5 ff ff       	call   10032f <cprintf>
        break;
  101db0:	e9 11 01 00 00       	jmp    101ec6 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101db5:	e8 93 f8 ff ff       	call   10164d <cons_getc>
  101dba:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dbd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dc5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcd:	c7 04 24 5b 3b 10 00 	movl   $0x103b5b,(%esp)
  101dd4:	e8 56 e5 ff ff       	call   10032f <cprintf>
        break;
  101dd9:	e9 e8 00 00 00       	jmp    101ec6 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
  101dde:	8b 45 08             	mov    0x8(%ebp),%eax
  101de1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de5:	83 f8 1b             	cmp    $0x1b,%eax
  101de8:	0f 84 d4 00 00 00    	je     101ec2 <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
  101dee:	8b 45 08             	mov    0x8(%ebp),%eax
  101df1:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101df7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfa:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e07:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0a:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e11:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e15:	8b 45 08             	mov    0x8(%ebp),%eax
  101e18:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1f:	8b 40 40             	mov    0x40(%eax),%eax
  101e22:	0d 00 30 00 00       	or     $0x3000,%eax
  101e27:	89 c2                	mov    %eax,%edx
  101e29:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2c:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101e2f:	e9 8e 00 00 00       	jmp    101ec2 <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
  101e34:	8b 45 08             	mov    0x8(%ebp),%eax
  101e37:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e3b:	83 f8 08             	cmp    $0x8,%eax
  101e3e:	0f 84 81 00 00 00    	je     101ec5 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
  101e44:	8b 45 08             	mov    0x8(%ebp),%eax
  101e47:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
  101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e50:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101e56:	8b 45 08             	mov    0x8(%ebp),%eax
  101e59:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e60:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e64:	8b 45 08             	mov    0x8(%ebp),%eax
  101e67:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	8b 40 40             	mov    0x40(%eax),%eax
  101e78:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101e7d:	89 c2                	mov    %eax,%edx
  101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e82:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101e85:	eb 3e                	jmp    101ec5 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101e87:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8e:	83 e0 03             	and    $0x3,%eax
  101e91:	85 c0                	test   %eax,%eax
  101e93:	75 31                	jne    101ec6 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
  101e95:	8b 45 08             	mov    0x8(%ebp),%eax
  101e98:	89 04 24             	mov    %eax,(%esp)
  101e9b:	e8 f3 fb ff ff       	call   101a93 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ea0:	c7 44 24 08 6a 3b 10 	movl   $0x103b6a,0x8(%esp)
  101ea7:	00 
  101ea8:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  101eaf:	00 
  101eb0:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101eb7:	e8 06 ee ff ff       	call   100cc2 <__panic>
        break;
  101ebc:	90                   	nop
  101ebd:	eb 07                	jmp    101ec6 <trap_dispatch+0x1c6>
        break;
  101ebf:	90                   	nop
  101ec0:	eb 04                	jmp    101ec6 <trap_dispatch+0x1c6>
        break;
  101ec2:	90                   	nop
  101ec3:	eb 01                	jmp    101ec6 <trap_dispatch+0x1c6>
        break;
  101ec5:	90                   	nop
        }
    }
}
  101ec6:	90                   	nop
  101ec7:	89 ec                	mov    %ebp,%esp
  101ec9:	5d                   	pop    %ebp
  101eca:	c3                   	ret    

00101ecb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101ecb:	55                   	push   %ebp
  101ecc:	89 e5                	mov    %esp,%ebp
  101ece:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	89 04 24             	mov    %eax,(%esp)
  101ed7:	e8 24 fe ff ff       	call   101d00 <trap_dispatch>
}
  101edc:	90                   	nop
  101edd:	89 ec                	mov    %ebp,%esp
  101edf:	5d                   	pop    %ebp
  101ee0:	c3                   	ret    

00101ee1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ee1:	1e                   	push   %ds
    pushl %es
  101ee2:	06                   	push   %es
    pushl %fs
  101ee3:	0f a0                	push   %fs
    pushl %gs
  101ee5:	0f a8                	push   %gs
    pushal
  101ee7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ee8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101eed:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101eef:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ef1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ef2:	e8 d4 ff ff ff       	call   101ecb <trap>

    # pop the pushed stack pointer
    popl %esp
  101ef7:	5c                   	pop    %esp

00101ef8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ef8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ef9:	0f a9                	pop    %gs
    popl %fs
  101efb:	0f a1                	pop    %fs
    popl %es
  101efd:	07                   	pop    %es
    popl %ds
  101efe:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eff:	83 c4 08             	add    $0x8,%esp
    iret
  101f02:	cf                   	iret   

00101f03 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $0
  101f05:	6a 00                	push   $0x0
  jmp __alltraps
  101f07:	e9 d5 ff ff ff       	jmp    101ee1 <__alltraps>

00101f0c <vector1>:
.globl vector1
vector1:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $1
  101f0e:	6a 01                	push   $0x1
  jmp __alltraps
  101f10:	e9 cc ff ff ff       	jmp    101ee1 <__alltraps>

00101f15 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $2
  101f17:	6a 02                	push   $0x2
  jmp __alltraps
  101f19:	e9 c3 ff ff ff       	jmp    101ee1 <__alltraps>

00101f1e <vector3>:
.globl vector3
vector3:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $3
  101f20:	6a 03                	push   $0x3
  jmp __alltraps
  101f22:	e9 ba ff ff ff       	jmp    101ee1 <__alltraps>

00101f27 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $4
  101f29:	6a 04                	push   $0x4
  jmp __alltraps
  101f2b:	e9 b1 ff ff ff       	jmp    101ee1 <__alltraps>

00101f30 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $5
  101f32:	6a 05                	push   $0x5
  jmp __alltraps
  101f34:	e9 a8 ff ff ff       	jmp    101ee1 <__alltraps>

00101f39 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $6
  101f3b:	6a 06                	push   $0x6
  jmp __alltraps
  101f3d:	e9 9f ff ff ff       	jmp    101ee1 <__alltraps>

00101f42 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $7
  101f44:	6a 07                	push   $0x7
  jmp __alltraps
  101f46:	e9 96 ff ff ff       	jmp    101ee1 <__alltraps>

00101f4b <vector8>:
.globl vector8
vector8:
  pushl $8
  101f4b:	6a 08                	push   $0x8
  jmp __alltraps
  101f4d:	e9 8f ff ff ff       	jmp    101ee1 <__alltraps>

00101f52 <vector9>:
.globl vector9
vector9:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $9
  101f54:	6a 09                	push   $0x9
  jmp __alltraps
  101f56:	e9 86 ff ff ff       	jmp    101ee1 <__alltraps>

00101f5b <vector10>:
.globl vector10
vector10:
  pushl $10
  101f5b:	6a 0a                	push   $0xa
  jmp __alltraps
  101f5d:	e9 7f ff ff ff       	jmp    101ee1 <__alltraps>

00101f62 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f62:	6a 0b                	push   $0xb
  jmp __alltraps
  101f64:	e9 78 ff ff ff       	jmp    101ee1 <__alltraps>

00101f69 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f69:	6a 0c                	push   $0xc
  jmp __alltraps
  101f6b:	e9 71 ff ff ff       	jmp    101ee1 <__alltraps>

00101f70 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f70:	6a 0d                	push   $0xd
  jmp __alltraps
  101f72:	e9 6a ff ff ff       	jmp    101ee1 <__alltraps>

00101f77 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f77:	6a 0e                	push   $0xe
  jmp __alltraps
  101f79:	e9 63 ff ff ff       	jmp    101ee1 <__alltraps>

00101f7e <vector15>:
.globl vector15
vector15:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $15
  101f80:	6a 0f                	push   $0xf
  jmp __alltraps
  101f82:	e9 5a ff ff ff       	jmp    101ee1 <__alltraps>

00101f87 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $16
  101f89:	6a 10                	push   $0x10
  jmp __alltraps
  101f8b:	e9 51 ff ff ff       	jmp    101ee1 <__alltraps>

00101f90 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f90:	6a 11                	push   $0x11
  jmp __alltraps
  101f92:	e9 4a ff ff ff       	jmp    101ee1 <__alltraps>

00101f97 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $18
  101f99:	6a 12                	push   $0x12
  jmp __alltraps
  101f9b:	e9 41 ff ff ff       	jmp    101ee1 <__alltraps>

00101fa0 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $19
  101fa2:	6a 13                	push   $0x13
  jmp __alltraps
  101fa4:	e9 38 ff ff ff       	jmp    101ee1 <__alltraps>

00101fa9 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $20
  101fab:	6a 14                	push   $0x14
  jmp __alltraps
  101fad:	e9 2f ff ff ff       	jmp    101ee1 <__alltraps>

00101fb2 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $21
  101fb4:	6a 15                	push   $0x15
  jmp __alltraps
  101fb6:	e9 26 ff ff ff       	jmp    101ee1 <__alltraps>

00101fbb <vector22>:
.globl vector22
vector22:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $22
  101fbd:	6a 16                	push   $0x16
  jmp __alltraps
  101fbf:	e9 1d ff ff ff       	jmp    101ee1 <__alltraps>

00101fc4 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $23
  101fc6:	6a 17                	push   $0x17
  jmp __alltraps
  101fc8:	e9 14 ff ff ff       	jmp    101ee1 <__alltraps>

00101fcd <vector24>:
.globl vector24
vector24:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $24
  101fcf:	6a 18                	push   $0x18
  jmp __alltraps
  101fd1:	e9 0b ff ff ff       	jmp    101ee1 <__alltraps>

00101fd6 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $25
  101fd8:	6a 19                	push   $0x19
  jmp __alltraps
  101fda:	e9 02 ff ff ff       	jmp    101ee1 <__alltraps>

00101fdf <vector26>:
.globl vector26
vector26:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $26
  101fe1:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fe3:	e9 f9 fe ff ff       	jmp    101ee1 <__alltraps>

00101fe8 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $27
  101fea:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fec:	e9 f0 fe ff ff       	jmp    101ee1 <__alltraps>

00101ff1 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $28
  101ff3:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ff5:	e9 e7 fe ff ff       	jmp    101ee1 <__alltraps>

00101ffa <vector29>:
.globl vector29
vector29:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $29
  101ffc:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ffe:	e9 de fe ff ff       	jmp    101ee1 <__alltraps>

00102003 <vector30>:
.globl vector30
vector30:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $30
  102005:	6a 1e                	push   $0x1e
  jmp __alltraps
  102007:	e9 d5 fe ff ff       	jmp    101ee1 <__alltraps>

0010200c <vector31>:
.globl vector31
vector31:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $31
  10200e:	6a 1f                	push   $0x1f
  jmp __alltraps
  102010:	e9 cc fe ff ff       	jmp    101ee1 <__alltraps>

00102015 <vector32>:
.globl vector32
vector32:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $32
  102017:	6a 20                	push   $0x20
  jmp __alltraps
  102019:	e9 c3 fe ff ff       	jmp    101ee1 <__alltraps>

0010201e <vector33>:
.globl vector33
vector33:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $33
  102020:	6a 21                	push   $0x21
  jmp __alltraps
  102022:	e9 ba fe ff ff       	jmp    101ee1 <__alltraps>

00102027 <vector34>:
.globl vector34
vector34:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $34
  102029:	6a 22                	push   $0x22
  jmp __alltraps
  10202b:	e9 b1 fe ff ff       	jmp    101ee1 <__alltraps>

00102030 <vector35>:
.globl vector35
vector35:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $35
  102032:	6a 23                	push   $0x23
  jmp __alltraps
  102034:	e9 a8 fe ff ff       	jmp    101ee1 <__alltraps>

00102039 <vector36>:
.globl vector36
vector36:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $36
  10203b:	6a 24                	push   $0x24
  jmp __alltraps
  10203d:	e9 9f fe ff ff       	jmp    101ee1 <__alltraps>

00102042 <vector37>:
.globl vector37
vector37:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $37
  102044:	6a 25                	push   $0x25
  jmp __alltraps
  102046:	e9 96 fe ff ff       	jmp    101ee1 <__alltraps>

0010204b <vector38>:
.globl vector38
vector38:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $38
  10204d:	6a 26                	push   $0x26
  jmp __alltraps
  10204f:	e9 8d fe ff ff       	jmp    101ee1 <__alltraps>

00102054 <vector39>:
.globl vector39
vector39:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $39
  102056:	6a 27                	push   $0x27
  jmp __alltraps
  102058:	e9 84 fe ff ff       	jmp    101ee1 <__alltraps>

0010205d <vector40>:
.globl vector40
vector40:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $40
  10205f:	6a 28                	push   $0x28
  jmp __alltraps
  102061:	e9 7b fe ff ff       	jmp    101ee1 <__alltraps>

00102066 <vector41>:
.globl vector41
vector41:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $41
  102068:	6a 29                	push   $0x29
  jmp __alltraps
  10206a:	e9 72 fe ff ff       	jmp    101ee1 <__alltraps>

0010206f <vector42>:
.globl vector42
vector42:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $42
  102071:	6a 2a                	push   $0x2a
  jmp __alltraps
  102073:	e9 69 fe ff ff       	jmp    101ee1 <__alltraps>

00102078 <vector43>:
.globl vector43
vector43:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $43
  10207a:	6a 2b                	push   $0x2b
  jmp __alltraps
  10207c:	e9 60 fe ff ff       	jmp    101ee1 <__alltraps>

00102081 <vector44>:
.globl vector44
vector44:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $44
  102083:	6a 2c                	push   $0x2c
  jmp __alltraps
  102085:	e9 57 fe ff ff       	jmp    101ee1 <__alltraps>

0010208a <vector45>:
.globl vector45
vector45:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $45
  10208c:	6a 2d                	push   $0x2d
  jmp __alltraps
  10208e:	e9 4e fe ff ff       	jmp    101ee1 <__alltraps>

00102093 <vector46>:
.globl vector46
vector46:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $46
  102095:	6a 2e                	push   $0x2e
  jmp __alltraps
  102097:	e9 45 fe ff ff       	jmp    101ee1 <__alltraps>

0010209c <vector47>:
.globl vector47
vector47:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $47
  10209e:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020a0:	e9 3c fe ff ff       	jmp    101ee1 <__alltraps>

001020a5 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $48
  1020a7:	6a 30                	push   $0x30
  jmp __alltraps
  1020a9:	e9 33 fe ff ff       	jmp    101ee1 <__alltraps>

001020ae <vector49>:
.globl vector49
vector49:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $49
  1020b0:	6a 31                	push   $0x31
  jmp __alltraps
  1020b2:	e9 2a fe ff ff       	jmp    101ee1 <__alltraps>

001020b7 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $50
  1020b9:	6a 32                	push   $0x32
  jmp __alltraps
  1020bb:	e9 21 fe ff ff       	jmp    101ee1 <__alltraps>

001020c0 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $51
  1020c2:	6a 33                	push   $0x33
  jmp __alltraps
  1020c4:	e9 18 fe ff ff       	jmp    101ee1 <__alltraps>

001020c9 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $52
  1020cb:	6a 34                	push   $0x34
  jmp __alltraps
  1020cd:	e9 0f fe ff ff       	jmp    101ee1 <__alltraps>

001020d2 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $53
  1020d4:	6a 35                	push   $0x35
  jmp __alltraps
  1020d6:	e9 06 fe ff ff       	jmp    101ee1 <__alltraps>

001020db <vector54>:
.globl vector54
vector54:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $54
  1020dd:	6a 36                	push   $0x36
  jmp __alltraps
  1020df:	e9 fd fd ff ff       	jmp    101ee1 <__alltraps>

001020e4 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $55
  1020e6:	6a 37                	push   $0x37
  jmp __alltraps
  1020e8:	e9 f4 fd ff ff       	jmp    101ee1 <__alltraps>

001020ed <vector56>:
.globl vector56
vector56:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $56
  1020ef:	6a 38                	push   $0x38
  jmp __alltraps
  1020f1:	e9 eb fd ff ff       	jmp    101ee1 <__alltraps>

001020f6 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $57
  1020f8:	6a 39                	push   $0x39
  jmp __alltraps
  1020fa:	e9 e2 fd ff ff       	jmp    101ee1 <__alltraps>

001020ff <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $58
  102101:	6a 3a                	push   $0x3a
  jmp __alltraps
  102103:	e9 d9 fd ff ff       	jmp    101ee1 <__alltraps>

00102108 <vector59>:
.globl vector59
vector59:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $59
  10210a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10210c:	e9 d0 fd ff ff       	jmp    101ee1 <__alltraps>

00102111 <vector60>:
.globl vector60
vector60:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $60
  102113:	6a 3c                	push   $0x3c
  jmp __alltraps
  102115:	e9 c7 fd ff ff       	jmp    101ee1 <__alltraps>

0010211a <vector61>:
.globl vector61
vector61:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $61
  10211c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10211e:	e9 be fd ff ff       	jmp    101ee1 <__alltraps>

00102123 <vector62>:
.globl vector62
vector62:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $62
  102125:	6a 3e                	push   $0x3e
  jmp __alltraps
  102127:	e9 b5 fd ff ff       	jmp    101ee1 <__alltraps>

0010212c <vector63>:
.globl vector63
vector63:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $63
  10212e:	6a 3f                	push   $0x3f
  jmp __alltraps
  102130:	e9 ac fd ff ff       	jmp    101ee1 <__alltraps>

00102135 <vector64>:
.globl vector64
vector64:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $64
  102137:	6a 40                	push   $0x40
  jmp __alltraps
  102139:	e9 a3 fd ff ff       	jmp    101ee1 <__alltraps>

0010213e <vector65>:
.globl vector65
vector65:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $65
  102140:	6a 41                	push   $0x41
  jmp __alltraps
  102142:	e9 9a fd ff ff       	jmp    101ee1 <__alltraps>

00102147 <vector66>:
.globl vector66
vector66:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $66
  102149:	6a 42                	push   $0x42
  jmp __alltraps
  10214b:	e9 91 fd ff ff       	jmp    101ee1 <__alltraps>

00102150 <vector67>:
.globl vector67
vector67:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $67
  102152:	6a 43                	push   $0x43
  jmp __alltraps
  102154:	e9 88 fd ff ff       	jmp    101ee1 <__alltraps>

00102159 <vector68>:
.globl vector68
vector68:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $68
  10215b:	6a 44                	push   $0x44
  jmp __alltraps
  10215d:	e9 7f fd ff ff       	jmp    101ee1 <__alltraps>

00102162 <vector69>:
.globl vector69
vector69:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $69
  102164:	6a 45                	push   $0x45
  jmp __alltraps
  102166:	e9 76 fd ff ff       	jmp    101ee1 <__alltraps>

0010216b <vector70>:
.globl vector70
vector70:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $70
  10216d:	6a 46                	push   $0x46
  jmp __alltraps
  10216f:	e9 6d fd ff ff       	jmp    101ee1 <__alltraps>

00102174 <vector71>:
.globl vector71
vector71:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $71
  102176:	6a 47                	push   $0x47
  jmp __alltraps
  102178:	e9 64 fd ff ff       	jmp    101ee1 <__alltraps>

0010217d <vector72>:
.globl vector72
vector72:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $72
  10217f:	6a 48                	push   $0x48
  jmp __alltraps
  102181:	e9 5b fd ff ff       	jmp    101ee1 <__alltraps>

00102186 <vector73>:
.globl vector73
vector73:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $73
  102188:	6a 49                	push   $0x49
  jmp __alltraps
  10218a:	e9 52 fd ff ff       	jmp    101ee1 <__alltraps>

0010218f <vector74>:
.globl vector74
vector74:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $74
  102191:	6a 4a                	push   $0x4a
  jmp __alltraps
  102193:	e9 49 fd ff ff       	jmp    101ee1 <__alltraps>

00102198 <vector75>:
.globl vector75
vector75:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $75
  10219a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10219c:	e9 40 fd ff ff       	jmp    101ee1 <__alltraps>

001021a1 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $76
  1021a3:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021a5:	e9 37 fd ff ff       	jmp    101ee1 <__alltraps>

001021aa <vector77>:
.globl vector77
vector77:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $77
  1021ac:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021ae:	e9 2e fd ff ff       	jmp    101ee1 <__alltraps>

001021b3 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $78
  1021b5:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021b7:	e9 25 fd ff ff       	jmp    101ee1 <__alltraps>

001021bc <vector79>:
.globl vector79
vector79:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $79
  1021be:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021c0:	e9 1c fd ff ff       	jmp    101ee1 <__alltraps>

001021c5 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $80
  1021c7:	6a 50                	push   $0x50
  jmp __alltraps
  1021c9:	e9 13 fd ff ff       	jmp    101ee1 <__alltraps>

001021ce <vector81>:
.globl vector81
vector81:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $81
  1021d0:	6a 51                	push   $0x51
  jmp __alltraps
  1021d2:	e9 0a fd ff ff       	jmp    101ee1 <__alltraps>

001021d7 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $82
  1021d9:	6a 52                	push   $0x52
  jmp __alltraps
  1021db:	e9 01 fd ff ff       	jmp    101ee1 <__alltraps>

001021e0 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $83
  1021e2:	6a 53                	push   $0x53
  jmp __alltraps
  1021e4:	e9 f8 fc ff ff       	jmp    101ee1 <__alltraps>

001021e9 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $84
  1021eb:	6a 54                	push   $0x54
  jmp __alltraps
  1021ed:	e9 ef fc ff ff       	jmp    101ee1 <__alltraps>

001021f2 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $85
  1021f4:	6a 55                	push   $0x55
  jmp __alltraps
  1021f6:	e9 e6 fc ff ff       	jmp    101ee1 <__alltraps>

001021fb <vector86>:
.globl vector86
vector86:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $86
  1021fd:	6a 56                	push   $0x56
  jmp __alltraps
  1021ff:	e9 dd fc ff ff       	jmp    101ee1 <__alltraps>

00102204 <vector87>:
.globl vector87
vector87:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $87
  102206:	6a 57                	push   $0x57
  jmp __alltraps
  102208:	e9 d4 fc ff ff       	jmp    101ee1 <__alltraps>

0010220d <vector88>:
.globl vector88
vector88:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $88
  10220f:	6a 58                	push   $0x58
  jmp __alltraps
  102211:	e9 cb fc ff ff       	jmp    101ee1 <__alltraps>

00102216 <vector89>:
.globl vector89
vector89:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $89
  102218:	6a 59                	push   $0x59
  jmp __alltraps
  10221a:	e9 c2 fc ff ff       	jmp    101ee1 <__alltraps>

0010221f <vector90>:
.globl vector90
vector90:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $90
  102221:	6a 5a                	push   $0x5a
  jmp __alltraps
  102223:	e9 b9 fc ff ff       	jmp    101ee1 <__alltraps>

00102228 <vector91>:
.globl vector91
vector91:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $91
  10222a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10222c:	e9 b0 fc ff ff       	jmp    101ee1 <__alltraps>

00102231 <vector92>:
.globl vector92
vector92:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $92
  102233:	6a 5c                	push   $0x5c
  jmp __alltraps
  102235:	e9 a7 fc ff ff       	jmp    101ee1 <__alltraps>

0010223a <vector93>:
.globl vector93
vector93:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $93
  10223c:	6a 5d                	push   $0x5d
  jmp __alltraps
  10223e:	e9 9e fc ff ff       	jmp    101ee1 <__alltraps>

00102243 <vector94>:
.globl vector94
vector94:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $94
  102245:	6a 5e                	push   $0x5e
  jmp __alltraps
  102247:	e9 95 fc ff ff       	jmp    101ee1 <__alltraps>

0010224c <vector95>:
.globl vector95
vector95:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $95
  10224e:	6a 5f                	push   $0x5f
  jmp __alltraps
  102250:	e9 8c fc ff ff       	jmp    101ee1 <__alltraps>

00102255 <vector96>:
.globl vector96
vector96:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $96
  102257:	6a 60                	push   $0x60
  jmp __alltraps
  102259:	e9 83 fc ff ff       	jmp    101ee1 <__alltraps>

0010225e <vector97>:
.globl vector97
vector97:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $97
  102260:	6a 61                	push   $0x61
  jmp __alltraps
  102262:	e9 7a fc ff ff       	jmp    101ee1 <__alltraps>

00102267 <vector98>:
.globl vector98
vector98:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $98
  102269:	6a 62                	push   $0x62
  jmp __alltraps
  10226b:	e9 71 fc ff ff       	jmp    101ee1 <__alltraps>

00102270 <vector99>:
.globl vector99
vector99:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $99
  102272:	6a 63                	push   $0x63
  jmp __alltraps
  102274:	e9 68 fc ff ff       	jmp    101ee1 <__alltraps>

00102279 <vector100>:
.globl vector100
vector100:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $100
  10227b:	6a 64                	push   $0x64
  jmp __alltraps
  10227d:	e9 5f fc ff ff       	jmp    101ee1 <__alltraps>

00102282 <vector101>:
.globl vector101
vector101:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $101
  102284:	6a 65                	push   $0x65
  jmp __alltraps
  102286:	e9 56 fc ff ff       	jmp    101ee1 <__alltraps>

0010228b <vector102>:
.globl vector102
vector102:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $102
  10228d:	6a 66                	push   $0x66
  jmp __alltraps
  10228f:	e9 4d fc ff ff       	jmp    101ee1 <__alltraps>

00102294 <vector103>:
.globl vector103
vector103:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $103
  102296:	6a 67                	push   $0x67
  jmp __alltraps
  102298:	e9 44 fc ff ff       	jmp    101ee1 <__alltraps>

0010229d <vector104>:
.globl vector104
vector104:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $104
  10229f:	6a 68                	push   $0x68
  jmp __alltraps
  1022a1:	e9 3b fc ff ff       	jmp    101ee1 <__alltraps>

001022a6 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $105
  1022a8:	6a 69                	push   $0x69
  jmp __alltraps
  1022aa:	e9 32 fc ff ff       	jmp    101ee1 <__alltraps>

001022af <vector106>:
.globl vector106
vector106:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $106
  1022b1:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022b3:	e9 29 fc ff ff       	jmp    101ee1 <__alltraps>

001022b8 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $107
  1022ba:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022bc:	e9 20 fc ff ff       	jmp    101ee1 <__alltraps>

001022c1 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $108
  1022c3:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022c5:	e9 17 fc ff ff       	jmp    101ee1 <__alltraps>

001022ca <vector109>:
.globl vector109
vector109:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $109
  1022cc:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022ce:	e9 0e fc ff ff       	jmp    101ee1 <__alltraps>

001022d3 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $110
  1022d5:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022d7:	e9 05 fc ff ff       	jmp    101ee1 <__alltraps>

001022dc <vector111>:
.globl vector111
vector111:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $111
  1022de:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022e0:	e9 fc fb ff ff       	jmp    101ee1 <__alltraps>

001022e5 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $112
  1022e7:	6a 70                	push   $0x70
  jmp __alltraps
  1022e9:	e9 f3 fb ff ff       	jmp    101ee1 <__alltraps>

001022ee <vector113>:
.globl vector113
vector113:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $113
  1022f0:	6a 71                	push   $0x71
  jmp __alltraps
  1022f2:	e9 ea fb ff ff       	jmp    101ee1 <__alltraps>

001022f7 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $114
  1022f9:	6a 72                	push   $0x72
  jmp __alltraps
  1022fb:	e9 e1 fb ff ff       	jmp    101ee1 <__alltraps>

00102300 <vector115>:
.globl vector115
vector115:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $115
  102302:	6a 73                	push   $0x73
  jmp __alltraps
  102304:	e9 d8 fb ff ff       	jmp    101ee1 <__alltraps>

00102309 <vector116>:
.globl vector116
vector116:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $116
  10230b:	6a 74                	push   $0x74
  jmp __alltraps
  10230d:	e9 cf fb ff ff       	jmp    101ee1 <__alltraps>

00102312 <vector117>:
.globl vector117
vector117:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $117
  102314:	6a 75                	push   $0x75
  jmp __alltraps
  102316:	e9 c6 fb ff ff       	jmp    101ee1 <__alltraps>

0010231b <vector118>:
.globl vector118
vector118:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $118
  10231d:	6a 76                	push   $0x76
  jmp __alltraps
  10231f:	e9 bd fb ff ff       	jmp    101ee1 <__alltraps>

00102324 <vector119>:
.globl vector119
vector119:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $119
  102326:	6a 77                	push   $0x77
  jmp __alltraps
  102328:	e9 b4 fb ff ff       	jmp    101ee1 <__alltraps>

0010232d <vector120>:
.globl vector120
vector120:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $120
  10232f:	6a 78                	push   $0x78
  jmp __alltraps
  102331:	e9 ab fb ff ff       	jmp    101ee1 <__alltraps>

00102336 <vector121>:
.globl vector121
vector121:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $121
  102338:	6a 79                	push   $0x79
  jmp __alltraps
  10233a:	e9 a2 fb ff ff       	jmp    101ee1 <__alltraps>

0010233f <vector122>:
.globl vector122
vector122:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $122
  102341:	6a 7a                	push   $0x7a
  jmp __alltraps
  102343:	e9 99 fb ff ff       	jmp    101ee1 <__alltraps>

00102348 <vector123>:
.globl vector123
vector123:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $123
  10234a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10234c:	e9 90 fb ff ff       	jmp    101ee1 <__alltraps>

00102351 <vector124>:
.globl vector124
vector124:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $124
  102353:	6a 7c                	push   $0x7c
  jmp __alltraps
  102355:	e9 87 fb ff ff       	jmp    101ee1 <__alltraps>

0010235a <vector125>:
.globl vector125
vector125:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $125
  10235c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10235e:	e9 7e fb ff ff       	jmp    101ee1 <__alltraps>

00102363 <vector126>:
.globl vector126
vector126:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $126
  102365:	6a 7e                	push   $0x7e
  jmp __alltraps
  102367:	e9 75 fb ff ff       	jmp    101ee1 <__alltraps>

0010236c <vector127>:
.globl vector127
vector127:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $127
  10236e:	6a 7f                	push   $0x7f
  jmp __alltraps
  102370:	e9 6c fb ff ff       	jmp    101ee1 <__alltraps>

00102375 <vector128>:
.globl vector128
vector128:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $128
  102377:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10237c:	e9 60 fb ff ff       	jmp    101ee1 <__alltraps>

00102381 <vector129>:
.globl vector129
vector129:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $129
  102383:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102388:	e9 54 fb ff ff       	jmp    101ee1 <__alltraps>

0010238d <vector130>:
.globl vector130
vector130:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $130
  10238f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102394:	e9 48 fb ff ff       	jmp    101ee1 <__alltraps>

00102399 <vector131>:
.globl vector131
vector131:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $131
  10239b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023a0:	e9 3c fb ff ff       	jmp    101ee1 <__alltraps>

001023a5 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $132
  1023a7:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023ac:	e9 30 fb ff ff       	jmp    101ee1 <__alltraps>

001023b1 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $133
  1023b3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023b8:	e9 24 fb ff ff       	jmp    101ee1 <__alltraps>

001023bd <vector134>:
.globl vector134
vector134:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $134
  1023bf:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023c4:	e9 18 fb ff ff       	jmp    101ee1 <__alltraps>

001023c9 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $135
  1023cb:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023d0:	e9 0c fb ff ff       	jmp    101ee1 <__alltraps>

001023d5 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $136
  1023d7:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023dc:	e9 00 fb ff ff       	jmp    101ee1 <__alltraps>

001023e1 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $137
  1023e3:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023e8:	e9 f4 fa ff ff       	jmp    101ee1 <__alltraps>

001023ed <vector138>:
.globl vector138
vector138:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $138
  1023ef:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023f4:	e9 e8 fa ff ff       	jmp    101ee1 <__alltraps>

001023f9 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $139
  1023fb:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102400:	e9 dc fa ff ff       	jmp    101ee1 <__alltraps>

00102405 <vector140>:
.globl vector140
vector140:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $140
  102407:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10240c:	e9 d0 fa ff ff       	jmp    101ee1 <__alltraps>

00102411 <vector141>:
.globl vector141
vector141:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $141
  102413:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102418:	e9 c4 fa ff ff       	jmp    101ee1 <__alltraps>

0010241d <vector142>:
.globl vector142
vector142:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $142
  10241f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102424:	e9 b8 fa ff ff       	jmp    101ee1 <__alltraps>

00102429 <vector143>:
.globl vector143
vector143:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $143
  10242b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102430:	e9 ac fa ff ff       	jmp    101ee1 <__alltraps>

00102435 <vector144>:
.globl vector144
vector144:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $144
  102437:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10243c:	e9 a0 fa ff ff       	jmp    101ee1 <__alltraps>

00102441 <vector145>:
.globl vector145
vector145:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $145
  102443:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102448:	e9 94 fa ff ff       	jmp    101ee1 <__alltraps>

0010244d <vector146>:
.globl vector146
vector146:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $146
  10244f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102454:	e9 88 fa ff ff       	jmp    101ee1 <__alltraps>

00102459 <vector147>:
.globl vector147
vector147:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $147
  10245b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102460:	e9 7c fa ff ff       	jmp    101ee1 <__alltraps>

00102465 <vector148>:
.globl vector148
vector148:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $148
  102467:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10246c:	e9 70 fa ff ff       	jmp    101ee1 <__alltraps>

00102471 <vector149>:
.globl vector149
vector149:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $149
  102473:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102478:	e9 64 fa ff ff       	jmp    101ee1 <__alltraps>

0010247d <vector150>:
.globl vector150
vector150:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $150
  10247f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102484:	e9 58 fa ff ff       	jmp    101ee1 <__alltraps>

00102489 <vector151>:
.globl vector151
vector151:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $151
  10248b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102490:	e9 4c fa ff ff       	jmp    101ee1 <__alltraps>

00102495 <vector152>:
.globl vector152
vector152:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $152
  102497:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10249c:	e9 40 fa ff ff       	jmp    101ee1 <__alltraps>

001024a1 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $153
  1024a3:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024a8:	e9 34 fa ff ff       	jmp    101ee1 <__alltraps>

001024ad <vector154>:
.globl vector154
vector154:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $154
  1024af:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024b4:	e9 28 fa ff ff       	jmp    101ee1 <__alltraps>

001024b9 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $155
  1024bb:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024c0:	e9 1c fa ff ff       	jmp    101ee1 <__alltraps>

001024c5 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $156
  1024c7:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024cc:	e9 10 fa ff ff       	jmp    101ee1 <__alltraps>

001024d1 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $157
  1024d3:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024d8:	e9 04 fa ff ff       	jmp    101ee1 <__alltraps>

001024dd <vector158>:
.globl vector158
vector158:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $158
  1024df:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024e4:	e9 f8 f9 ff ff       	jmp    101ee1 <__alltraps>

001024e9 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $159
  1024eb:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024f0:	e9 ec f9 ff ff       	jmp    101ee1 <__alltraps>

001024f5 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $160
  1024f7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024fc:	e9 e0 f9 ff ff       	jmp    101ee1 <__alltraps>

00102501 <vector161>:
.globl vector161
vector161:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $161
  102503:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102508:	e9 d4 f9 ff ff       	jmp    101ee1 <__alltraps>

0010250d <vector162>:
.globl vector162
vector162:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $162
  10250f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102514:	e9 c8 f9 ff ff       	jmp    101ee1 <__alltraps>

00102519 <vector163>:
.globl vector163
vector163:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $163
  10251b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102520:	e9 bc f9 ff ff       	jmp    101ee1 <__alltraps>

00102525 <vector164>:
.globl vector164
vector164:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $164
  102527:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10252c:	e9 b0 f9 ff ff       	jmp    101ee1 <__alltraps>

00102531 <vector165>:
.globl vector165
vector165:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $165
  102533:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102538:	e9 a4 f9 ff ff       	jmp    101ee1 <__alltraps>

0010253d <vector166>:
.globl vector166
vector166:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $166
  10253f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102544:	e9 98 f9 ff ff       	jmp    101ee1 <__alltraps>

00102549 <vector167>:
.globl vector167
vector167:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $167
  10254b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102550:	e9 8c f9 ff ff       	jmp    101ee1 <__alltraps>

00102555 <vector168>:
.globl vector168
vector168:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $168
  102557:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10255c:	e9 80 f9 ff ff       	jmp    101ee1 <__alltraps>

00102561 <vector169>:
.globl vector169
vector169:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $169
  102563:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102568:	e9 74 f9 ff ff       	jmp    101ee1 <__alltraps>

0010256d <vector170>:
.globl vector170
vector170:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $170
  10256f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102574:	e9 68 f9 ff ff       	jmp    101ee1 <__alltraps>

00102579 <vector171>:
.globl vector171
vector171:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $171
  10257b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102580:	e9 5c f9 ff ff       	jmp    101ee1 <__alltraps>

00102585 <vector172>:
.globl vector172
vector172:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $172
  102587:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10258c:	e9 50 f9 ff ff       	jmp    101ee1 <__alltraps>

00102591 <vector173>:
.globl vector173
vector173:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $173
  102593:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102598:	e9 44 f9 ff ff       	jmp    101ee1 <__alltraps>

0010259d <vector174>:
.globl vector174
vector174:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $174
  10259f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025a4:	e9 38 f9 ff ff       	jmp    101ee1 <__alltraps>

001025a9 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $175
  1025ab:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025b0:	e9 2c f9 ff ff       	jmp    101ee1 <__alltraps>

001025b5 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $176
  1025b7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025bc:	e9 20 f9 ff ff       	jmp    101ee1 <__alltraps>

001025c1 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $177
  1025c3:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025c8:	e9 14 f9 ff ff       	jmp    101ee1 <__alltraps>

001025cd <vector178>:
.globl vector178
vector178:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $178
  1025cf:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025d4:	e9 08 f9 ff ff       	jmp    101ee1 <__alltraps>

001025d9 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $179
  1025db:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025e0:	e9 fc f8 ff ff       	jmp    101ee1 <__alltraps>

001025e5 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $180
  1025e7:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025ec:	e9 f0 f8 ff ff       	jmp    101ee1 <__alltraps>

001025f1 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $181
  1025f3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025f8:	e9 e4 f8 ff ff       	jmp    101ee1 <__alltraps>

001025fd <vector182>:
.globl vector182
vector182:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $182
  1025ff:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102604:	e9 d8 f8 ff ff       	jmp    101ee1 <__alltraps>

00102609 <vector183>:
.globl vector183
vector183:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $183
  10260b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102610:	e9 cc f8 ff ff       	jmp    101ee1 <__alltraps>

00102615 <vector184>:
.globl vector184
vector184:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $184
  102617:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10261c:	e9 c0 f8 ff ff       	jmp    101ee1 <__alltraps>

00102621 <vector185>:
.globl vector185
vector185:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $185
  102623:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102628:	e9 b4 f8 ff ff       	jmp    101ee1 <__alltraps>

0010262d <vector186>:
.globl vector186
vector186:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $186
  10262f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102634:	e9 a8 f8 ff ff       	jmp    101ee1 <__alltraps>

00102639 <vector187>:
.globl vector187
vector187:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $187
  10263b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102640:	e9 9c f8 ff ff       	jmp    101ee1 <__alltraps>

00102645 <vector188>:
.globl vector188
vector188:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $188
  102647:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10264c:	e9 90 f8 ff ff       	jmp    101ee1 <__alltraps>

00102651 <vector189>:
.globl vector189
vector189:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $189
  102653:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102658:	e9 84 f8 ff ff       	jmp    101ee1 <__alltraps>

0010265d <vector190>:
.globl vector190
vector190:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $190
  10265f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102664:	e9 78 f8 ff ff       	jmp    101ee1 <__alltraps>

00102669 <vector191>:
.globl vector191
vector191:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $191
  10266b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102670:	e9 6c f8 ff ff       	jmp    101ee1 <__alltraps>

00102675 <vector192>:
.globl vector192
vector192:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $192
  102677:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10267c:	e9 60 f8 ff ff       	jmp    101ee1 <__alltraps>

00102681 <vector193>:
.globl vector193
vector193:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $193
  102683:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102688:	e9 54 f8 ff ff       	jmp    101ee1 <__alltraps>

0010268d <vector194>:
.globl vector194
vector194:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $194
  10268f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102694:	e9 48 f8 ff ff       	jmp    101ee1 <__alltraps>

00102699 <vector195>:
.globl vector195
vector195:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $195
  10269b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026a0:	e9 3c f8 ff ff       	jmp    101ee1 <__alltraps>

001026a5 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $196
  1026a7:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026ac:	e9 30 f8 ff ff       	jmp    101ee1 <__alltraps>

001026b1 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $197
  1026b3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026b8:	e9 24 f8 ff ff       	jmp    101ee1 <__alltraps>

001026bd <vector198>:
.globl vector198
vector198:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $198
  1026bf:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026c4:	e9 18 f8 ff ff       	jmp    101ee1 <__alltraps>

001026c9 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $199
  1026cb:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026d0:	e9 0c f8 ff ff       	jmp    101ee1 <__alltraps>

001026d5 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $200
  1026d7:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026dc:	e9 00 f8 ff ff       	jmp    101ee1 <__alltraps>

001026e1 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $201
  1026e3:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026e8:	e9 f4 f7 ff ff       	jmp    101ee1 <__alltraps>

001026ed <vector202>:
.globl vector202
vector202:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $202
  1026ef:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026f4:	e9 e8 f7 ff ff       	jmp    101ee1 <__alltraps>

001026f9 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $203
  1026fb:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102700:	e9 dc f7 ff ff       	jmp    101ee1 <__alltraps>

00102705 <vector204>:
.globl vector204
vector204:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $204
  102707:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10270c:	e9 d0 f7 ff ff       	jmp    101ee1 <__alltraps>

00102711 <vector205>:
.globl vector205
vector205:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $205
  102713:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102718:	e9 c4 f7 ff ff       	jmp    101ee1 <__alltraps>

0010271d <vector206>:
.globl vector206
vector206:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $206
  10271f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102724:	e9 b8 f7 ff ff       	jmp    101ee1 <__alltraps>

00102729 <vector207>:
.globl vector207
vector207:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $207
  10272b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102730:	e9 ac f7 ff ff       	jmp    101ee1 <__alltraps>

00102735 <vector208>:
.globl vector208
vector208:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $208
  102737:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10273c:	e9 a0 f7 ff ff       	jmp    101ee1 <__alltraps>

00102741 <vector209>:
.globl vector209
vector209:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $209
  102743:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102748:	e9 94 f7 ff ff       	jmp    101ee1 <__alltraps>

0010274d <vector210>:
.globl vector210
vector210:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $210
  10274f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102754:	e9 88 f7 ff ff       	jmp    101ee1 <__alltraps>

00102759 <vector211>:
.globl vector211
vector211:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $211
  10275b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102760:	e9 7c f7 ff ff       	jmp    101ee1 <__alltraps>

00102765 <vector212>:
.globl vector212
vector212:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $212
  102767:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10276c:	e9 70 f7 ff ff       	jmp    101ee1 <__alltraps>

00102771 <vector213>:
.globl vector213
vector213:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $213
  102773:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102778:	e9 64 f7 ff ff       	jmp    101ee1 <__alltraps>

0010277d <vector214>:
.globl vector214
vector214:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $214
  10277f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102784:	e9 58 f7 ff ff       	jmp    101ee1 <__alltraps>

00102789 <vector215>:
.globl vector215
vector215:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $215
  10278b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102790:	e9 4c f7 ff ff       	jmp    101ee1 <__alltraps>

00102795 <vector216>:
.globl vector216
vector216:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $216
  102797:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10279c:	e9 40 f7 ff ff       	jmp    101ee1 <__alltraps>

001027a1 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $217
  1027a3:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027a8:	e9 34 f7 ff ff       	jmp    101ee1 <__alltraps>

001027ad <vector218>:
.globl vector218
vector218:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $218
  1027af:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027b4:	e9 28 f7 ff ff       	jmp    101ee1 <__alltraps>

001027b9 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $219
  1027bb:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027c0:	e9 1c f7 ff ff       	jmp    101ee1 <__alltraps>

001027c5 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $220
  1027c7:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027cc:	e9 10 f7 ff ff       	jmp    101ee1 <__alltraps>

001027d1 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $221
  1027d3:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027d8:	e9 04 f7 ff ff       	jmp    101ee1 <__alltraps>

001027dd <vector222>:
.globl vector222
vector222:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $222
  1027df:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027e4:	e9 f8 f6 ff ff       	jmp    101ee1 <__alltraps>

001027e9 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $223
  1027eb:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027f0:	e9 ec f6 ff ff       	jmp    101ee1 <__alltraps>

001027f5 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $224
  1027f7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027fc:	e9 e0 f6 ff ff       	jmp    101ee1 <__alltraps>

00102801 <vector225>:
.globl vector225
vector225:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $225
  102803:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102808:	e9 d4 f6 ff ff       	jmp    101ee1 <__alltraps>

0010280d <vector226>:
.globl vector226
vector226:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $226
  10280f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102814:	e9 c8 f6 ff ff       	jmp    101ee1 <__alltraps>

00102819 <vector227>:
.globl vector227
vector227:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $227
  10281b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102820:	e9 bc f6 ff ff       	jmp    101ee1 <__alltraps>

00102825 <vector228>:
.globl vector228
vector228:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $228
  102827:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10282c:	e9 b0 f6 ff ff       	jmp    101ee1 <__alltraps>

00102831 <vector229>:
.globl vector229
vector229:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $229
  102833:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102838:	e9 a4 f6 ff ff       	jmp    101ee1 <__alltraps>

0010283d <vector230>:
.globl vector230
vector230:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $230
  10283f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102844:	e9 98 f6 ff ff       	jmp    101ee1 <__alltraps>

00102849 <vector231>:
.globl vector231
vector231:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $231
  10284b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102850:	e9 8c f6 ff ff       	jmp    101ee1 <__alltraps>

00102855 <vector232>:
.globl vector232
vector232:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $232
  102857:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10285c:	e9 80 f6 ff ff       	jmp    101ee1 <__alltraps>

00102861 <vector233>:
.globl vector233
vector233:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $233
  102863:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102868:	e9 74 f6 ff ff       	jmp    101ee1 <__alltraps>

0010286d <vector234>:
.globl vector234
vector234:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $234
  10286f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102874:	e9 68 f6 ff ff       	jmp    101ee1 <__alltraps>

00102879 <vector235>:
.globl vector235
vector235:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $235
  10287b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102880:	e9 5c f6 ff ff       	jmp    101ee1 <__alltraps>

00102885 <vector236>:
.globl vector236
vector236:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $236
  102887:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10288c:	e9 50 f6 ff ff       	jmp    101ee1 <__alltraps>

00102891 <vector237>:
.globl vector237
vector237:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $237
  102893:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102898:	e9 44 f6 ff ff       	jmp    101ee1 <__alltraps>

0010289d <vector238>:
.globl vector238
vector238:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $238
  10289f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028a4:	e9 38 f6 ff ff       	jmp    101ee1 <__alltraps>

001028a9 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $239
  1028ab:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028b0:	e9 2c f6 ff ff       	jmp    101ee1 <__alltraps>

001028b5 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $240
  1028b7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028bc:	e9 20 f6 ff ff       	jmp    101ee1 <__alltraps>

001028c1 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $241
  1028c3:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028c8:	e9 14 f6 ff ff       	jmp    101ee1 <__alltraps>

001028cd <vector242>:
.globl vector242
vector242:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $242
  1028cf:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028d4:	e9 08 f6 ff ff       	jmp    101ee1 <__alltraps>

001028d9 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $243
  1028db:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028e0:	e9 fc f5 ff ff       	jmp    101ee1 <__alltraps>

001028e5 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $244
  1028e7:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028ec:	e9 f0 f5 ff ff       	jmp    101ee1 <__alltraps>

001028f1 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $245
  1028f3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028f8:	e9 e4 f5 ff ff       	jmp    101ee1 <__alltraps>

001028fd <vector246>:
.globl vector246
vector246:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $246
  1028ff:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102904:	e9 d8 f5 ff ff       	jmp    101ee1 <__alltraps>

00102909 <vector247>:
.globl vector247
vector247:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $247
  10290b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102910:	e9 cc f5 ff ff       	jmp    101ee1 <__alltraps>

00102915 <vector248>:
.globl vector248
vector248:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $248
  102917:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10291c:	e9 c0 f5 ff ff       	jmp    101ee1 <__alltraps>

00102921 <vector249>:
.globl vector249
vector249:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $249
  102923:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102928:	e9 b4 f5 ff ff       	jmp    101ee1 <__alltraps>

0010292d <vector250>:
.globl vector250
vector250:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $250
  10292f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102934:	e9 a8 f5 ff ff       	jmp    101ee1 <__alltraps>

00102939 <vector251>:
.globl vector251
vector251:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $251
  10293b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102940:	e9 9c f5 ff ff       	jmp    101ee1 <__alltraps>

00102945 <vector252>:
.globl vector252
vector252:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $252
  102947:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10294c:	e9 90 f5 ff ff       	jmp    101ee1 <__alltraps>

00102951 <vector253>:
.globl vector253
vector253:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $253
  102953:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102958:	e9 84 f5 ff ff       	jmp    101ee1 <__alltraps>

0010295d <vector254>:
.globl vector254
vector254:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $254
  10295f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102964:	e9 78 f5 ff ff       	jmp    101ee1 <__alltraps>

00102969 <vector255>:
.globl vector255
vector255:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $255
  10296b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102970:	e9 6c f5 ff ff       	jmp    101ee1 <__alltraps>

00102975 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102975:	55                   	push   %ebp
  102976:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102978:	8b 45 08             	mov    0x8(%ebp),%eax
  10297b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10297e:	b8 23 00 00 00       	mov    $0x23,%eax
  102983:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102985:	b8 23 00 00 00       	mov    $0x23,%eax
  10298a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10298c:	b8 10 00 00 00       	mov    $0x10,%eax
  102991:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102993:	b8 10 00 00 00       	mov    $0x10,%eax
  102998:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10299a:	b8 10 00 00 00       	mov    $0x10,%eax
  10299f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029a1:	ea a8 29 10 00 08 00 	ljmp   $0x8,$0x1029a8
}
  1029a8:	90                   	nop
  1029a9:	5d                   	pop    %ebp
  1029aa:	c3                   	ret    

001029ab <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029ab:	55                   	push   %ebp
  1029ac:	89 e5                	mov    %esp,%ebp
  1029ae:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029b1:	b8 00 09 11 00       	mov    $0x110900,%eax
  1029b6:	05 00 04 00 00       	add    $0x400,%eax
  1029bb:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  1029c0:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  1029c7:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029c9:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1029d0:	68 00 
  1029d2:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029d7:	0f b7 c0             	movzwl %ax,%eax
  1029da:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1029e0:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029e5:	c1 e8 10             	shr    $0x10,%eax
  1029e8:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1029ed:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1029f4:	24 f0                	and    $0xf0,%al
  1029f6:	0c 09                	or     $0x9,%al
  1029f8:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1029fd:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a04:	0c 10                	or     $0x10,%al
  102a06:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a0b:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a12:	24 9f                	and    $0x9f,%al
  102a14:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a19:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a20:	0c 80                	or     $0x80,%al
  102a22:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a27:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a2e:	24 f0                	and    $0xf0,%al
  102a30:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a35:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a3c:	24 ef                	and    $0xef,%al
  102a3e:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a43:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a4a:	24 df                	and    $0xdf,%al
  102a4c:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a51:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a58:	0c 40                	or     $0x40,%al
  102a5a:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a5f:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a66:	24 7f                	and    $0x7f,%al
  102a68:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a6d:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a72:	c1 e8 18             	shr    $0x18,%eax
  102a75:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102a7a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a81:	24 ef                	and    $0xef,%al
  102a83:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a88:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102a8f:	e8 e1 fe ff ff       	call   102975 <lgdt>
  102a94:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a9a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a9e:	0f 00 d8             	ltr    %ax
}
  102aa1:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102aa2:	90                   	nop
  102aa3:	89 ec                	mov    %ebp,%esp
  102aa5:	5d                   	pop    %ebp
  102aa6:	c3                   	ret    

00102aa7 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102aa7:	55                   	push   %ebp
  102aa8:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102aaa:	e8 fc fe ff ff       	call   1029ab <gdt_init>
}
  102aaf:	90                   	nop
  102ab0:	5d                   	pop    %ebp
  102ab1:	c3                   	ret    

00102ab2 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102ab2:	55                   	push   %ebp
  102ab3:	89 e5                	mov    %esp,%ebp
  102ab5:	83 ec 58             	sub    $0x58,%esp
  102ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  102abb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102abe:	8b 45 14             	mov    0x14(%ebp),%eax
  102ac1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102ac4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ac7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102acd:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102ad0:	8b 45 18             	mov    0x18(%ebp),%eax
  102ad3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ad9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102adc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102adf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102aec:	74 1c                	je     102b0a <printnum+0x58>
  102aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af1:	ba 00 00 00 00       	mov    $0x0,%edx
  102af6:	f7 75 e4             	divl   -0x1c(%ebp)
  102af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aff:	ba 00 00 00 00       	mov    $0x0,%edx
  102b04:	f7 75 e4             	divl   -0x1c(%ebp)
  102b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b10:	f7 75 e4             	divl   -0x1c(%ebp)
  102b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b22:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b28:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b2b:	8b 45 18             	mov    0x18(%ebp),%eax
  102b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  102b33:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102b36:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102b39:	19 d1                	sbb    %edx,%ecx
  102b3b:	72 4c                	jb     102b89 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b3d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b43:	8b 45 20             	mov    0x20(%ebp),%eax
  102b46:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b4a:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b4e:	8b 45 18             	mov    0x18(%ebp),%eax
  102b51:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b5f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6d:	89 04 24             	mov    %eax,(%esp)
  102b70:	e8 3d ff ff ff       	call   102ab2 <printnum>
  102b75:	eb 1b                	jmp    102b92 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b7e:	8b 45 20             	mov    0x20(%ebp),%eax
  102b81:	89 04 24             	mov    %eax,(%esp)
  102b84:	8b 45 08             	mov    0x8(%ebp),%eax
  102b87:	ff d0                	call   *%eax
        while (-- width > 0)
  102b89:	ff 4d 1c             	decl   0x1c(%ebp)
  102b8c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b90:	7f e5                	jg     102b77 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b95:	05 b0 3d 10 00       	add    $0x103db0,%eax
  102b9a:	0f b6 00             	movzbl (%eax),%eax
  102b9d:	0f be c0             	movsbl %al,%eax
  102ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ba3:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ba7:	89 04 24             	mov    %eax,(%esp)
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	ff d0                	call   *%eax
}
  102baf:	90                   	nop
  102bb0:	89 ec                	mov    %ebp,%esp
  102bb2:	5d                   	pop    %ebp
  102bb3:	c3                   	ret    

00102bb4 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102bb4:	55                   	push   %ebp
  102bb5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bb7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bbb:	7e 14                	jle    102bd1 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc0:	8b 00                	mov    (%eax),%eax
  102bc2:	8d 48 08             	lea    0x8(%eax),%ecx
  102bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc8:	89 0a                	mov    %ecx,(%edx)
  102bca:	8b 50 04             	mov    0x4(%eax),%edx
  102bcd:	8b 00                	mov    (%eax),%eax
  102bcf:	eb 30                	jmp    102c01 <getuint+0x4d>
    }
    else if (lflag) {
  102bd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bd5:	74 16                	je     102bed <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bda:	8b 00                	mov    (%eax),%eax
  102bdc:	8d 48 04             	lea    0x4(%eax),%ecx
  102bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  102be2:	89 0a                	mov    %ecx,(%edx)
  102be4:	8b 00                	mov    (%eax),%eax
  102be6:	ba 00 00 00 00       	mov    $0x0,%edx
  102beb:	eb 14                	jmp    102c01 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bed:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf0:	8b 00                	mov    (%eax),%eax
  102bf2:	8d 48 04             	lea    0x4(%eax),%ecx
  102bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  102bf8:	89 0a                	mov    %ecx,(%edx)
  102bfa:	8b 00                	mov    (%eax),%eax
  102bfc:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c01:	5d                   	pop    %ebp
  102c02:	c3                   	ret    

00102c03 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c03:	55                   	push   %ebp
  102c04:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c06:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c0a:	7e 14                	jle    102c20 <getint+0x1d>
        return va_arg(*ap, long long);
  102c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0f:	8b 00                	mov    (%eax),%eax
  102c11:	8d 48 08             	lea    0x8(%eax),%ecx
  102c14:	8b 55 08             	mov    0x8(%ebp),%edx
  102c17:	89 0a                	mov    %ecx,(%edx)
  102c19:	8b 50 04             	mov    0x4(%eax),%edx
  102c1c:	8b 00                	mov    (%eax),%eax
  102c1e:	eb 28                	jmp    102c48 <getint+0x45>
    }
    else if (lflag) {
  102c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c24:	74 12                	je     102c38 <getint+0x35>
        return va_arg(*ap, long);
  102c26:	8b 45 08             	mov    0x8(%ebp),%eax
  102c29:	8b 00                	mov    (%eax),%eax
  102c2b:	8d 48 04             	lea    0x4(%eax),%ecx
  102c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  102c31:	89 0a                	mov    %ecx,(%edx)
  102c33:	8b 00                	mov    (%eax),%eax
  102c35:	99                   	cltd   
  102c36:	eb 10                	jmp    102c48 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c38:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3b:	8b 00                	mov    (%eax),%eax
  102c3d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c40:	8b 55 08             	mov    0x8(%ebp),%edx
  102c43:	89 0a                	mov    %ecx,(%edx)
  102c45:	8b 00                	mov    (%eax),%eax
  102c47:	99                   	cltd   
    }
}
  102c48:	5d                   	pop    %ebp
  102c49:	c3                   	ret    

00102c4a <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c4a:	55                   	push   %ebp
  102c4b:	89 e5                	mov    %esp,%ebp
  102c4d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c50:	8d 45 14             	lea    0x14(%ebp),%eax
  102c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  102c60:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	89 04 24             	mov    %eax,(%esp)
  102c71:	e8 05 00 00 00       	call   102c7b <vprintfmt>
    va_end(ap);
}
  102c76:	90                   	nop
  102c77:	89 ec                	mov    %ebp,%esp
  102c79:	5d                   	pop    %ebp
  102c7a:	c3                   	ret    

00102c7b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c7b:	55                   	push   %ebp
  102c7c:	89 e5                	mov    %esp,%ebp
  102c7e:	56                   	push   %esi
  102c7f:	53                   	push   %ebx
  102c80:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c83:	eb 17                	jmp    102c9c <vprintfmt+0x21>
            if (ch == '\0') {
  102c85:	85 db                	test   %ebx,%ebx
  102c87:	0f 84 bf 03 00 00    	je     10304c <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c94:	89 1c 24             	mov    %ebx,(%esp)
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  102c9f:	8d 50 01             	lea    0x1(%eax),%edx
  102ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  102ca5:	0f b6 00             	movzbl (%eax),%eax
  102ca8:	0f b6 d8             	movzbl %al,%ebx
  102cab:	83 fb 25             	cmp    $0x25,%ebx
  102cae:	75 d5                	jne    102c85 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102cb0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102cb4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102cc1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ccb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cce:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd1:	8d 50 01             	lea    0x1(%eax),%edx
  102cd4:	89 55 10             	mov    %edx,0x10(%ebp)
  102cd7:	0f b6 00             	movzbl (%eax),%eax
  102cda:	0f b6 d8             	movzbl %al,%ebx
  102cdd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ce0:	83 f8 55             	cmp    $0x55,%eax
  102ce3:	0f 87 37 03 00 00    	ja     103020 <vprintfmt+0x3a5>
  102ce9:	8b 04 85 d4 3d 10 00 	mov    0x103dd4(,%eax,4),%eax
  102cf0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cf2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cf6:	eb d6                	jmp    102cce <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cf8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cfc:	eb d0                	jmp    102cce <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cfe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d08:	89 d0                	mov    %edx,%eax
  102d0a:	c1 e0 02             	shl    $0x2,%eax
  102d0d:	01 d0                	add    %edx,%eax
  102d0f:	01 c0                	add    %eax,%eax
  102d11:	01 d8                	add    %ebx,%eax
  102d13:	83 e8 30             	sub    $0x30,%eax
  102d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d19:	8b 45 10             	mov    0x10(%ebp),%eax
  102d1c:	0f b6 00             	movzbl (%eax),%eax
  102d1f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d22:	83 fb 2f             	cmp    $0x2f,%ebx
  102d25:	7e 38                	jle    102d5f <vprintfmt+0xe4>
  102d27:	83 fb 39             	cmp    $0x39,%ebx
  102d2a:	7f 33                	jg     102d5f <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102d2c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102d2f:	eb d4                	jmp    102d05 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102d31:	8b 45 14             	mov    0x14(%ebp),%eax
  102d34:	8d 50 04             	lea    0x4(%eax),%edx
  102d37:	89 55 14             	mov    %edx,0x14(%ebp)
  102d3a:	8b 00                	mov    (%eax),%eax
  102d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d3f:	eb 1f                	jmp    102d60 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102d41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d45:	79 87                	jns    102cce <vprintfmt+0x53>
                width = 0;
  102d47:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d4e:	e9 7b ff ff ff       	jmp    102cce <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102d53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d5a:	e9 6f ff ff ff       	jmp    102cce <vprintfmt+0x53>
            goto process_precision;
  102d5f:	90                   	nop

        process_precision:
            if (width < 0)
  102d60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d64:	0f 89 64 ff ff ff    	jns    102cce <vprintfmt+0x53>
                width = precision, precision = -1;
  102d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d70:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d77:	e9 52 ff ff ff       	jmp    102cce <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d7c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102d7f:	e9 4a ff ff ff       	jmp    102cce <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d84:	8b 45 14             	mov    0x14(%ebp),%eax
  102d87:	8d 50 04             	lea    0x4(%eax),%edx
  102d8a:	89 55 14             	mov    %edx,0x14(%ebp)
  102d8d:	8b 00                	mov    (%eax),%eax
  102d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d92:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d96:	89 04 24             	mov    %eax,(%esp)
  102d99:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9c:	ff d0                	call   *%eax
            break;
  102d9e:	e9 a4 02 00 00       	jmp    103047 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102da3:	8b 45 14             	mov    0x14(%ebp),%eax
  102da6:	8d 50 04             	lea    0x4(%eax),%edx
  102da9:	89 55 14             	mov    %edx,0x14(%ebp)
  102dac:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102dae:	85 db                	test   %ebx,%ebx
  102db0:	79 02                	jns    102db4 <vprintfmt+0x139>
                err = -err;
  102db2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102db4:	83 fb 06             	cmp    $0x6,%ebx
  102db7:	7f 0b                	jg     102dc4 <vprintfmt+0x149>
  102db9:	8b 34 9d 94 3d 10 00 	mov    0x103d94(,%ebx,4),%esi
  102dc0:	85 f6                	test   %esi,%esi
  102dc2:	75 23                	jne    102de7 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102dc4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102dc8:	c7 44 24 08 c1 3d 10 	movl   $0x103dc1,0x8(%esp)
  102dcf:	00 
  102dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	89 04 24             	mov    %eax,(%esp)
  102ddd:	e8 68 fe ff ff       	call   102c4a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102de2:	e9 60 02 00 00       	jmp    103047 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102de7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102deb:	c7 44 24 08 ca 3d 10 	movl   $0x103dca,0x8(%esp)
  102df2:	00 
  102df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfd:	89 04 24             	mov    %eax,(%esp)
  102e00:	e8 45 fe ff ff       	call   102c4a <printfmt>
            break;
  102e05:	e9 3d 02 00 00       	jmp    103047 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  102e0d:	8d 50 04             	lea    0x4(%eax),%edx
  102e10:	89 55 14             	mov    %edx,0x14(%ebp)
  102e13:	8b 30                	mov    (%eax),%esi
  102e15:	85 f6                	test   %esi,%esi
  102e17:	75 05                	jne    102e1e <vprintfmt+0x1a3>
                p = "(null)";
  102e19:	be cd 3d 10 00       	mov    $0x103dcd,%esi
            }
            if (width > 0 && padc != '-') {
  102e1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e22:	7e 76                	jle    102e9a <vprintfmt+0x21f>
  102e24:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e28:	74 70                	je     102e9a <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e31:	89 34 24             	mov    %esi,(%esp)
  102e34:	e8 16 03 00 00       	call   10314f <strnlen>
  102e39:	89 c2                	mov    %eax,%edx
  102e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e3e:	29 d0                	sub    %edx,%eax
  102e40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e43:	eb 16                	jmp    102e5b <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102e45:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e50:	89 04 24             	mov    %eax,(%esp)
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e58:	ff 4d e8             	decl   -0x18(%ebp)
  102e5b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e5f:	7f e4                	jg     102e45 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e61:	eb 37                	jmp    102e9a <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e63:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e67:	74 1f                	je     102e88 <vprintfmt+0x20d>
  102e69:	83 fb 1f             	cmp    $0x1f,%ebx
  102e6c:	7e 05                	jle    102e73 <vprintfmt+0x1f8>
  102e6e:	83 fb 7e             	cmp    $0x7e,%ebx
  102e71:	7e 15                	jle    102e88 <vprintfmt+0x20d>
                    putch('?', putdat);
  102e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e76:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e81:	8b 45 08             	mov    0x8(%ebp),%eax
  102e84:	ff d0                	call   *%eax
  102e86:	eb 0f                	jmp    102e97 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8f:	89 1c 24             	mov    %ebx,(%esp)
  102e92:	8b 45 08             	mov    0x8(%ebp),%eax
  102e95:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e97:	ff 4d e8             	decl   -0x18(%ebp)
  102e9a:	89 f0                	mov    %esi,%eax
  102e9c:	8d 70 01             	lea    0x1(%eax),%esi
  102e9f:	0f b6 00             	movzbl (%eax),%eax
  102ea2:	0f be d8             	movsbl %al,%ebx
  102ea5:	85 db                	test   %ebx,%ebx
  102ea7:	74 27                	je     102ed0 <vprintfmt+0x255>
  102ea9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ead:	78 b4                	js     102e63 <vprintfmt+0x1e8>
  102eaf:	ff 4d e4             	decl   -0x1c(%ebp)
  102eb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102eb6:	79 ab                	jns    102e63 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102eb8:	eb 16                	jmp    102ed0 <vprintfmt+0x255>
                putch(' ', putdat);
  102eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ec1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecb:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102ecd:	ff 4d e8             	decl   -0x18(%ebp)
  102ed0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ed4:	7f e4                	jg     102eba <vprintfmt+0x23f>
            }
            break;
  102ed6:	e9 6c 01 00 00       	jmp    103047 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee2:	8d 45 14             	lea    0x14(%ebp),%eax
  102ee5:	89 04 24             	mov    %eax,(%esp)
  102ee8:	e8 16 fd ff ff       	call   102c03 <getint>
  102eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ef9:	85 d2                	test   %edx,%edx
  102efb:	79 26                	jns    102f23 <vprintfmt+0x2a8>
                putch('-', putdat);
  102efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f00:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f04:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0e:	ff d0                	call   *%eax
                num = -(long long)num;
  102f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f16:	f7 d8                	neg    %eax
  102f18:	83 d2 00             	adc    $0x0,%edx
  102f1b:	f7 da                	neg    %edx
  102f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f20:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f2a:	e9 a8 00 00 00       	jmp    102fd7 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f36:	8d 45 14             	lea    0x14(%ebp),%eax
  102f39:	89 04 24             	mov    %eax,(%esp)
  102f3c:	e8 73 fc ff ff       	call   102bb4 <getuint>
  102f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f44:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f4e:	e9 84 00 00 00       	jmp    102fd7 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f5a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f5d:	89 04 24             	mov    %eax,(%esp)
  102f60:	e8 4f fc ff ff       	call   102bb4 <getuint>
  102f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f68:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f6b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f72:	eb 63                	jmp    102fd7 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f82:	8b 45 08             	mov    0x8(%ebp),%eax
  102f85:	ff d0                	call   *%eax
            putch('x', putdat);
  102f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f8e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f95:	8b 45 08             	mov    0x8(%ebp),%eax
  102f98:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f9a:	8b 45 14             	mov    0x14(%ebp),%eax
  102f9d:	8d 50 04             	lea    0x4(%eax),%edx
  102fa0:	89 55 14             	mov    %edx,0x14(%ebp)
  102fa3:	8b 00                	mov    (%eax),%eax
  102fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102faf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fb6:	eb 1f                	jmp    102fd7 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fbf:	8d 45 14             	lea    0x14(%ebp),%eax
  102fc2:	89 04 24             	mov    %eax,(%esp)
  102fc5:	e8 ea fb ff ff       	call   102bb4 <getuint>
  102fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fd7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fde:	89 54 24 18          	mov    %edx,0x18(%esp)
  102fe2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fe5:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fe9:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ff3:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ff7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  103002:	8b 45 08             	mov    0x8(%ebp),%eax
  103005:	89 04 24             	mov    %eax,(%esp)
  103008:	e8 a5 fa ff ff       	call   102ab2 <printnum>
            break;
  10300d:	eb 38                	jmp    103047 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103012:	89 44 24 04          	mov    %eax,0x4(%esp)
  103016:	89 1c 24             	mov    %ebx,(%esp)
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	ff d0                	call   *%eax
            break;
  10301e:	eb 27                	jmp    103047 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103020:	8b 45 0c             	mov    0xc(%ebp),%eax
  103023:	89 44 24 04          	mov    %eax,0x4(%esp)
  103027:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10302e:	8b 45 08             	mov    0x8(%ebp),%eax
  103031:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103033:	ff 4d 10             	decl   0x10(%ebp)
  103036:	eb 03                	jmp    10303b <vprintfmt+0x3c0>
  103038:	ff 4d 10             	decl   0x10(%ebp)
  10303b:	8b 45 10             	mov    0x10(%ebp),%eax
  10303e:	48                   	dec    %eax
  10303f:	0f b6 00             	movzbl (%eax),%eax
  103042:	3c 25                	cmp    $0x25,%al
  103044:	75 f2                	jne    103038 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  103046:	90                   	nop
    while (1) {
  103047:	e9 37 fc ff ff       	jmp    102c83 <vprintfmt+0x8>
                return;
  10304c:	90                   	nop
        }
    }
}
  10304d:	83 c4 40             	add    $0x40,%esp
  103050:	5b                   	pop    %ebx
  103051:	5e                   	pop    %esi
  103052:	5d                   	pop    %ebp
  103053:	c3                   	ret    

00103054 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103054:	55                   	push   %ebp
  103055:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103057:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305a:	8b 40 08             	mov    0x8(%eax),%eax
  10305d:	8d 50 01             	lea    0x1(%eax),%edx
  103060:	8b 45 0c             	mov    0xc(%ebp),%eax
  103063:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103066:	8b 45 0c             	mov    0xc(%ebp),%eax
  103069:	8b 10                	mov    (%eax),%edx
  10306b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306e:	8b 40 04             	mov    0x4(%eax),%eax
  103071:	39 c2                	cmp    %eax,%edx
  103073:	73 12                	jae    103087 <sprintputch+0x33>
        *b->buf ++ = ch;
  103075:	8b 45 0c             	mov    0xc(%ebp),%eax
  103078:	8b 00                	mov    (%eax),%eax
  10307a:	8d 48 01             	lea    0x1(%eax),%ecx
  10307d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103080:	89 0a                	mov    %ecx,(%edx)
  103082:	8b 55 08             	mov    0x8(%ebp),%edx
  103085:	88 10                	mov    %dl,(%eax)
    }
}
  103087:	90                   	nop
  103088:	5d                   	pop    %ebp
  103089:	c3                   	ret    

0010308a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10308a:	55                   	push   %ebp
  10308b:	89 e5                	mov    %esp,%ebp
  10308d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103090:	8d 45 14             	lea    0x14(%ebp),%eax
  103093:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103099:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10309d:	8b 45 10             	mov    0x10(%ebp),%eax
  1030a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ae:	89 04 24             	mov    %eax,(%esp)
  1030b1:	e8 0a 00 00 00       	call   1030c0 <vsnprintf>
  1030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030bc:	89 ec                	mov    %ebp,%esp
  1030be:	5d                   	pop    %ebp
  1030bf:	c3                   	ret    

001030c0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030c0:	55                   	push   %ebp
  1030c1:	89 e5                	mov    %esp,%ebp
  1030c3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d5:	01 d0                	add    %edx,%eax
  1030d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030e5:	74 0a                	je     1030f1 <vsnprintf+0x31>
  1030e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ed:	39 c2                	cmp    %eax,%edx
  1030ef:	76 07                	jbe    1030f8 <vsnprintf+0x38>
        return -E_INVAL;
  1030f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030f6:	eb 2a                	jmp    103122 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030f8:	8b 45 14             	mov    0x14(%ebp),%eax
  1030fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030ff:	8b 45 10             	mov    0x10(%ebp),%eax
  103102:	89 44 24 08          	mov    %eax,0x8(%esp)
  103106:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103109:	89 44 24 04          	mov    %eax,0x4(%esp)
  10310d:	c7 04 24 54 30 10 00 	movl   $0x103054,(%esp)
  103114:	e8 62 fb ff ff       	call   102c7b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10311c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103122:	89 ec                	mov    %ebp,%esp
  103124:	5d                   	pop    %ebp
  103125:	c3                   	ret    

00103126 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103126:	55                   	push   %ebp
  103127:	89 e5                	mov    %esp,%ebp
  103129:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10312c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103133:	eb 03                	jmp    103138 <strlen+0x12>
        cnt ++;
  103135:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  103138:	8b 45 08             	mov    0x8(%ebp),%eax
  10313b:	8d 50 01             	lea    0x1(%eax),%edx
  10313e:	89 55 08             	mov    %edx,0x8(%ebp)
  103141:	0f b6 00             	movzbl (%eax),%eax
  103144:	84 c0                	test   %al,%al
  103146:	75 ed                	jne    103135 <strlen+0xf>
    }
    return cnt;
  103148:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10314b:	89 ec                	mov    %ebp,%esp
  10314d:	5d                   	pop    %ebp
  10314e:	c3                   	ret    

0010314f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10314f:	55                   	push   %ebp
  103150:	89 e5                	mov    %esp,%ebp
  103152:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103155:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10315c:	eb 03                	jmp    103161 <strnlen+0x12>
        cnt ++;
  10315e:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103164:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103167:	73 10                	jae    103179 <strnlen+0x2a>
  103169:	8b 45 08             	mov    0x8(%ebp),%eax
  10316c:	8d 50 01             	lea    0x1(%eax),%edx
  10316f:	89 55 08             	mov    %edx,0x8(%ebp)
  103172:	0f b6 00             	movzbl (%eax),%eax
  103175:	84 c0                	test   %al,%al
  103177:	75 e5                	jne    10315e <strnlen+0xf>
    }
    return cnt;
  103179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10317c:	89 ec                	mov    %ebp,%esp
  10317e:	5d                   	pop    %ebp
  10317f:	c3                   	ret    

00103180 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103180:	55                   	push   %ebp
  103181:	89 e5                	mov    %esp,%ebp
  103183:	57                   	push   %edi
  103184:	56                   	push   %esi
  103185:	83 ec 20             	sub    $0x20,%esp
  103188:	8b 45 08             	mov    0x8(%ebp),%eax
  10318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10318e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103191:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10319a:	89 d1                	mov    %edx,%ecx
  10319c:	89 c2                	mov    %eax,%edx
  10319e:	89 ce                	mov    %ecx,%esi
  1031a0:	89 d7                	mov    %edx,%edi
  1031a2:	ac                   	lods   %ds:(%esi),%al
  1031a3:	aa                   	stos   %al,%es:(%edi)
  1031a4:	84 c0                	test   %al,%al
  1031a6:	75 fa                	jne    1031a2 <strcpy+0x22>
  1031a8:	89 fa                	mov    %edi,%edx
  1031aa:	89 f1                	mov    %esi,%ecx
  1031ac:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031af:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1031b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031b8:	83 c4 20             	add    $0x20,%esp
  1031bb:	5e                   	pop    %esi
  1031bc:	5f                   	pop    %edi
  1031bd:	5d                   	pop    %ebp
  1031be:	c3                   	ret    

001031bf <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031bf:	55                   	push   %ebp
  1031c0:	89 e5                	mov    %esp,%ebp
  1031c2:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031cb:	eb 1e                	jmp    1031eb <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1031cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031d0:	0f b6 10             	movzbl (%eax),%edx
  1031d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031d6:	88 10                	mov    %dl,(%eax)
  1031d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031db:	0f b6 00             	movzbl (%eax),%eax
  1031de:	84 c0                	test   %al,%al
  1031e0:	74 03                	je     1031e5 <strncpy+0x26>
            src ++;
  1031e2:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1031e5:	ff 45 fc             	incl   -0x4(%ebp)
  1031e8:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1031eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031ef:	75 dc                	jne    1031cd <strncpy+0xe>
    }
    return dst;
  1031f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031f4:	89 ec                	mov    %ebp,%esp
  1031f6:	5d                   	pop    %ebp
  1031f7:	c3                   	ret    

001031f8 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031f8:	55                   	push   %ebp
  1031f9:	89 e5                	mov    %esp,%ebp
  1031fb:	57                   	push   %edi
  1031fc:	56                   	push   %esi
  1031fd:	83 ec 20             	sub    $0x20,%esp
  103200:	8b 45 08             	mov    0x8(%ebp),%eax
  103203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103206:	8b 45 0c             	mov    0xc(%ebp),%eax
  103209:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10320c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103212:	89 d1                	mov    %edx,%ecx
  103214:	89 c2                	mov    %eax,%edx
  103216:	89 ce                	mov    %ecx,%esi
  103218:	89 d7                	mov    %edx,%edi
  10321a:	ac                   	lods   %ds:(%esi),%al
  10321b:	ae                   	scas   %es:(%edi),%al
  10321c:	75 08                	jne    103226 <strcmp+0x2e>
  10321e:	84 c0                	test   %al,%al
  103220:	75 f8                	jne    10321a <strcmp+0x22>
  103222:	31 c0                	xor    %eax,%eax
  103224:	eb 04                	jmp    10322a <strcmp+0x32>
  103226:	19 c0                	sbb    %eax,%eax
  103228:	0c 01                	or     $0x1,%al
  10322a:	89 fa                	mov    %edi,%edx
  10322c:	89 f1                	mov    %esi,%ecx
  10322e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103231:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103234:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  103237:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10323a:	83 c4 20             	add    $0x20,%esp
  10323d:	5e                   	pop    %esi
  10323e:	5f                   	pop    %edi
  10323f:	5d                   	pop    %ebp
  103240:	c3                   	ret    

00103241 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103241:	55                   	push   %ebp
  103242:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103244:	eb 09                	jmp    10324f <strncmp+0xe>
        n --, s1 ++, s2 ++;
  103246:	ff 4d 10             	decl   0x10(%ebp)
  103249:	ff 45 08             	incl   0x8(%ebp)
  10324c:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10324f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103253:	74 1a                	je     10326f <strncmp+0x2e>
  103255:	8b 45 08             	mov    0x8(%ebp),%eax
  103258:	0f b6 00             	movzbl (%eax),%eax
  10325b:	84 c0                	test   %al,%al
  10325d:	74 10                	je     10326f <strncmp+0x2e>
  10325f:	8b 45 08             	mov    0x8(%ebp),%eax
  103262:	0f b6 10             	movzbl (%eax),%edx
  103265:	8b 45 0c             	mov    0xc(%ebp),%eax
  103268:	0f b6 00             	movzbl (%eax),%eax
  10326b:	38 c2                	cmp    %al,%dl
  10326d:	74 d7                	je     103246 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10326f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103273:	74 18                	je     10328d <strncmp+0x4c>
  103275:	8b 45 08             	mov    0x8(%ebp),%eax
  103278:	0f b6 00             	movzbl (%eax),%eax
  10327b:	0f b6 d0             	movzbl %al,%edx
  10327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103281:	0f b6 00             	movzbl (%eax),%eax
  103284:	0f b6 c8             	movzbl %al,%ecx
  103287:	89 d0                	mov    %edx,%eax
  103289:	29 c8                	sub    %ecx,%eax
  10328b:	eb 05                	jmp    103292 <strncmp+0x51>
  10328d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103292:	5d                   	pop    %ebp
  103293:	c3                   	ret    

00103294 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103294:	55                   	push   %ebp
  103295:	89 e5                	mov    %esp,%ebp
  103297:	83 ec 04             	sub    $0x4,%esp
  10329a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10329d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032a0:	eb 13                	jmp    1032b5 <strchr+0x21>
        if (*s == c) {
  1032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a5:	0f b6 00             	movzbl (%eax),%eax
  1032a8:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1032ab:	75 05                	jne    1032b2 <strchr+0x1e>
            return (char *)s;
  1032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b0:	eb 12                	jmp    1032c4 <strchr+0x30>
        }
        s ++;
  1032b2:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b8:	0f b6 00             	movzbl (%eax),%eax
  1032bb:	84 c0                	test   %al,%al
  1032bd:	75 e3                	jne    1032a2 <strchr+0xe>
    }
    return NULL;
  1032bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032c4:	89 ec                	mov    %ebp,%esp
  1032c6:	5d                   	pop    %ebp
  1032c7:	c3                   	ret    

001032c8 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032c8:	55                   	push   %ebp
  1032c9:	89 e5                	mov    %esp,%ebp
  1032cb:	83 ec 04             	sub    $0x4,%esp
  1032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032d4:	eb 0e                	jmp    1032e4 <strfind+0x1c>
        if (*s == c) {
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1032df:	74 0f                	je     1032f0 <strfind+0x28>
            break;
        }
        s ++;
  1032e1:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e7:	0f b6 00             	movzbl (%eax),%eax
  1032ea:	84 c0                	test   %al,%al
  1032ec:	75 e8                	jne    1032d6 <strfind+0xe>
  1032ee:	eb 01                	jmp    1032f1 <strfind+0x29>
            break;
  1032f0:	90                   	nop
    }
    return (char *)s;
  1032f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032f4:	89 ec                	mov    %ebp,%esp
  1032f6:	5d                   	pop    %ebp
  1032f7:	c3                   	ret    

001032f8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032f8:	55                   	push   %ebp
  1032f9:	89 e5                	mov    %esp,%ebp
  1032fb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103305:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10330c:	eb 03                	jmp    103311 <strtol+0x19>
        s ++;
  10330e:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103311:	8b 45 08             	mov    0x8(%ebp),%eax
  103314:	0f b6 00             	movzbl (%eax),%eax
  103317:	3c 20                	cmp    $0x20,%al
  103319:	74 f3                	je     10330e <strtol+0x16>
  10331b:	8b 45 08             	mov    0x8(%ebp),%eax
  10331e:	0f b6 00             	movzbl (%eax),%eax
  103321:	3c 09                	cmp    $0x9,%al
  103323:	74 e9                	je     10330e <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  103325:	8b 45 08             	mov    0x8(%ebp),%eax
  103328:	0f b6 00             	movzbl (%eax),%eax
  10332b:	3c 2b                	cmp    $0x2b,%al
  10332d:	75 05                	jne    103334 <strtol+0x3c>
        s ++;
  10332f:	ff 45 08             	incl   0x8(%ebp)
  103332:	eb 14                	jmp    103348 <strtol+0x50>
    }
    else if (*s == '-') {
  103334:	8b 45 08             	mov    0x8(%ebp),%eax
  103337:	0f b6 00             	movzbl (%eax),%eax
  10333a:	3c 2d                	cmp    $0x2d,%al
  10333c:	75 0a                	jne    103348 <strtol+0x50>
        s ++, neg = 1;
  10333e:	ff 45 08             	incl   0x8(%ebp)
  103341:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103348:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10334c:	74 06                	je     103354 <strtol+0x5c>
  10334e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103352:	75 22                	jne    103376 <strtol+0x7e>
  103354:	8b 45 08             	mov    0x8(%ebp),%eax
  103357:	0f b6 00             	movzbl (%eax),%eax
  10335a:	3c 30                	cmp    $0x30,%al
  10335c:	75 18                	jne    103376 <strtol+0x7e>
  10335e:	8b 45 08             	mov    0x8(%ebp),%eax
  103361:	40                   	inc    %eax
  103362:	0f b6 00             	movzbl (%eax),%eax
  103365:	3c 78                	cmp    $0x78,%al
  103367:	75 0d                	jne    103376 <strtol+0x7e>
        s += 2, base = 16;
  103369:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10336d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103374:	eb 29                	jmp    10339f <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  103376:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10337a:	75 16                	jne    103392 <strtol+0x9a>
  10337c:	8b 45 08             	mov    0x8(%ebp),%eax
  10337f:	0f b6 00             	movzbl (%eax),%eax
  103382:	3c 30                	cmp    $0x30,%al
  103384:	75 0c                	jne    103392 <strtol+0x9a>
        s ++, base = 8;
  103386:	ff 45 08             	incl   0x8(%ebp)
  103389:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103390:	eb 0d                	jmp    10339f <strtol+0xa7>
    }
    else if (base == 0) {
  103392:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103396:	75 07                	jne    10339f <strtol+0xa7>
        base = 10;
  103398:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10339f:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a2:	0f b6 00             	movzbl (%eax),%eax
  1033a5:	3c 2f                	cmp    $0x2f,%al
  1033a7:	7e 1b                	jle    1033c4 <strtol+0xcc>
  1033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ac:	0f b6 00             	movzbl (%eax),%eax
  1033af:	3c 39                	cmp    $0x39,%al
  1033b1:	7f 11                	jg     1033c4 <strtol+0xcc>
            dig = *s - '0';
  1033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b6:	0f b6 00             	movzbl (%eax),%eax
  1033b9:	0f be c0             	movsbl %al,%eax
  1033bc:	83 e8 30             	sub    $0x30,%eax
  1033bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033c2:	eb 48                	jmp    10340c <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c7:	0f b6 00             	movzbl (%eax),%eax
  1033ca:	3c 60                	cmp    $0x60,%al
  1033cc:	7e 1b                	jle    1033e9 <strtol+0xf1>
  1033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d1:	0f b6 00             	movzbl (%eax),%eax
  1033d4:	3c 7a                	cmp    $0x7a,%al
  1033d6:	7f 11                	jg     1033e9 <strtol+0xf1>
            dig = *s - 'a' + 10;
  1033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033db:	0f b6 00             	movzbl (%eax),%eax
  1033de:	0f be c0             	movsbl %al,%eax
  1033e1:	83 e8 57             	sub    $0x57,%eax
  1033e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033e7:	eb 23                	jmp    10340c <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ec:	0f b6 00             	movzbl (%eax),%eax
  1033ef:	3c 40                	cmp    $0x40,%al
  1033f1:	7e 3b                	jle    10342e <strtol+0x136>
  1033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f6:	0f b6 00             	movzbl (%eax),%eax
  1033f9:	3c 5a                	cmp    $0x5a,%al
  1033fb:	7f 31                	jg     10342e <strtol+0x136>
            dig = *s - 'A' + 10;
  1033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103400:	0f b6 00             	movzbl (%eax),%eax
  103403:	0f be c0             	movsbl %al,%eax
  103406:	83 e8 37             	sub    $0x37,%eax
  103409:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340f:	3b 45 10             	cmp    0x10(%ebp),%eax
  103412:	7d 19                	jge    10342d <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  103414:	ff 45 08             	incl   0x8(%ebp)
  103417:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10341a:	0f af 45 10          	imul   0x10(%ebp),%eax
  10341e:	89 c2                	mov    %eax,%edx
  103420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103423:	01 d0                	add    %edx,%eax
  103425:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103428:	e9 72 ff ff ff       	jmp    10339f <strtol+0xa7>
            break;
  10342d:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10342e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103432:	74 08                	je     10343c <strtol+0x144>
        *endptr = (char *) s;
  103434:	8b 45 0c             	mov    0xc(%ebp),%eax
  103437:	8b 55 08             	mov    0x8(%ebp),%edx
  10343a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10343c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103440:	74 07                	je     103449 <strtol+0x151>
  103442:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103445:	f7 d8                	neg    %eax
  103447:	eb 03                	jmp    10344c <strtol+0x154>
  103449:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10344c:	89 ec                	mov    %ebp,%esp
  10344e:	5d                   	pop    %ebp
  10344f:	c3                   	ret    

00103450 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103450:	55                   	push   %ebp
  103451:	89 e5                	mov    %esp,%ebp
  103453:	83 ec 28             	sub    $0x28,%esp
  103456:	89 7d fc             	mov    %edi,-0x4(%ebp)
  103459:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10345f:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103463:	8b 45 08             	mov    0x8(%ebp),%eax
  103466:	89 45 f8             	mov    %eax,-0x8(%ebp)
  103469:	88 55 f7             	mov    %dl,-0x9(%ebp)
  10346c:	8b 45 10             	mov    0x10(%ebp),%eax
  10346f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103472:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103475:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103479:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10347c:	89 d7                	mov    %edx,%edi
  10347e:	f3 aa                	rep stos %al,%es:(%edi)
  103480:	89 fa                	mov    %edi,%edx
  103482:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103485:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103488:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10348b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10348e:	89 ec                	mov    %ebp,%esp
  103490:	5d                   	pop    %ebp
  103491:	c3                   	ret    

00103492 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103492:	55                   	push   %ebp
  103493:	89 e5                	mov    %esp,%ebp
  103495:	57                   	push   %edi
  103496:	56                   	push   %esi
  103497:	53                   	push   %ebx
  103498:	83 ec 30             	sub    $0x30,%esp
  10349b:	8b 45 08             	mov    0x8(%ebp),%eax
  10349e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1034aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1034ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034b3:	73 42                	jae    1034f7 <memmove+0x65>
  1034b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034ca:	c1 e8 02             	shr    $0x2,%eax
  1034cd:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1034cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034d5:	89 d7                	mov    %edx,%edi
  1034d7:	89 c6                	mov    %eax,%esi
  1034d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034de:	83 e1 03             	and    $0x3,%ecx
  1034e1:	74 02                	je     1034e5 <memmove+0x53>
  1034e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034e5:	89 f0                	mov    %esi,%eax
  1034e7:	89 fa                	mov    %edi,%edx
  1034e9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1034f5:	eb 36                	jmp    10352d <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103500:	01 c2                	add    %eax,%edx
  103502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103505:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10350b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103511:	89 c1                	mov    %eax,%ecx
  103513:	89 d8                	mov    %ebx,%eax
  103515:	89 d6                	mov    %edx,%esi
  103517:	89 c7                	mov    %eax,%edi
  103519:	fd                   	std    
  10351a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10351c:	fc                   	cld    
  10351d:	89 f8                	mov    %edi,%eax
  10351f:	89 f2                	mov    %esi,%edx
  103521:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103524:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103527:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10352d:	83 c4 30             	add    $0x30,%esp
  103530:	5b                   	pop    %ebx
  103531:	5e                   	pop    %esi
  103532:	5f                   	pop    %edi
  103533:	5d                   	pop    %ebp
  103534:	c3                   	ret    

00103535 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103535:	55                   	push   %ebp
  103536:	89 e5                	mov    %esp,%ebp
  103538:	57                   	push   %edi
  103539:	56                   	push   %esi
  10353a:	83 ec 20             	sub    $0x20,%esp
  10353d:	8b 45 08             	mov    0x8(%ebp),%eax
  103540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103543:	8b 45 0c             	mov    0xc(%ebp),%eax
  103546:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103549:	8b 45 10             	mov    0x10(%ebp),%eax
  10354c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103552:	c1 e8 02             	shr    $0x2,%eax
  103555:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10355d:	89 d7                	mov    %edx,%edi
  10355f:	89 c6                	mov    %eax,%esi
  103561:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103563:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103566:	83 e1 03             	and    $0x3,%ecx
  103569:	74 02                	je     10356d <memcpy+0x38>
  10356b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10356d:	89 f0                	mov    %esi,%eax
  10356f:	89 fa                	mov    %edi,%edx
  103571:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103574:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103577:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10357d:	83 c4 20             	add    $0x20,%esp
  103580:	5e                   	pop    %esi
  103581:	5f                   	pop    %edi
  103582:	5d                   	pop    %ebp
  103583:	c3                   	ret    

00103584 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103584:	55                   	push   %ebp
  103585:	89 e5                	mov    %esp,%ebp
  103587:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10358a:	8b 45 08             	mov    0x8(%ebp),%eax
  10358d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103590:	8b 45 0c             	mov    0xc(%ebp),%eax
  103593:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103596:	eb 2e                	jmp    1035c6 <memcmp+0x42>
        if (*s1 != *s2) {
  103598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10359b:	0f b6 10             	movzbl (%eax),%edx
  10359e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035a1:	0f b6 00             	movzbl (%eax),%eax
  1035a4:	38 c2                	cmp    %al,%dl
  1035a6:	74 18                	je     1035c0 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1035a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035ab:	0f b6 00             	movzbl (%eax),%eax
  1035ae:	0f b6 d0             	movzbl %al,%edx
  1035b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035b4:	0f b6 00             	movzbl (%eax),%eax
  1035b7:	0f b6 c8             	movzbl %al,%ecx
  1035ba:	89 d0                	mov    %edx,%eax
  1035bc:	29 c8                	sub    %ecx,%eax
  1035be:	eb 18                	jmp    1035d8 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1035c0:	ff 45 fc             	incl   -0x4(%ebp)
  1035c3:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1035c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1035c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1035cf:	85 c0                	test   %eax,%eax
  1035d1:	75 c5                	jne    103598 <memcmp+0x14>
    }
    return 0;
  1035d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035d8:	89 ec                	mov    %ebp,%esp
  1035da:	5d                   	pop    %ebp
  1035db:	c3                   	ret    
