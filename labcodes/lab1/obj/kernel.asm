
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
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
  100023:	e8 89 34 00 00       	call   1034b1 <memset>

    cons_init();                // init the console
  100028:	e8 a8 15 00 00       	call   1015d5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 40 36 10 00 	movl   $0x103640,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100042:	e8 d9 02 00 00       	call   100320 <cprintf>

    print_kerninfo();
  100047:	e8 f7 07 00 00       	call   100843 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 90 00 00 00       	call   1000e1 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 b2 2a 00 00       	call   102b08 <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 d5 16 00 00       	call   101730 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 5c 18 00 00       	call   1018bc <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 11 0d 00 00       	call   100d76 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 24 16 00 00       	call   10168e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100079:	00 
  10007a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100081:	00 
  100082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100089:	e8 03 0c 00 00       	call   100c91 <mon_backtrace>
}
  10008e:	90                   	nop
  10008f:	89 ec                	mov    %ebp,%esp
  100091:	5d                   	pop    %ebp
  100092:	c3                   	ret    

00100093 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100093:	55                   	push   %ebp
  100094:	89 e5                	mov    %esp,%ebp
  100096:	83 ec 18             	sub    $0x18,%esp
  100099:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b0 ff ff ff       	call   10006c <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c0:	89 ec                	mov    %ebp,%esp
  1000c2:	5d                   	pop    %ebp
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d4:	89 04 24             	mov    %eax,(%esp)
  1000d7:	e8 b7 ff ff ff       	call   100093 <grade_backtrace1>
}
  1000dc:	90                   	nop
  1000dd:	89 ec                	mov    %ebp,%esp
  1000df:	5d                   	pop    %ebp
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e7:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ec:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f3:	ff 
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000ff:	e8 c0 ff ff ff       	call   1000c4 <grade_backtrace0>
}
  100104:	90                   	nop
  100105:	89 ec                	mov    %ebp,%esp
  100107:	5d                   	pop    %ebp
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  100138:	e8 e3 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 6f 36 10 00 	movl   $0x10366f,(%esp)
  100157:	e8 c4 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 7d 36 10 00 	movl   $0x10367d,(%esp)
  100176:	e8 a5 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 8b 36 10 00 	movl   $0x10368b,(%esp)
  100195:	e8 86 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 99 36 10 00 	movl   $0x103699,(%esp)
  1001b4:	e8 67 01 00 00       	call   100320 <cprintf>
    round ++;
  1001b9:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c4:	90                   	nop
  1001c5:	89 ec                	mov    %ebp,%esp
  1001c7:	5d                   	pop    %ebp
  1001c8:	c3                   	ret    

001001c9 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c9:	55                   	push   %ebp
  1001ca:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cc:	90                   	nop
  1001cd:	5d                   	pop    %ebp
  1001ce:	c3                   	ret    

001001cf <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cf:	55                   	push   %ebp
  1001d0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d2:	90                   	nop
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 29 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 a8 36 10 00 	movl   $0x1036a8,(%esp)
  1001e7:	e8 34 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 d8 ff ff ff       	call   1001c9 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 13 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  1001fd:	e8 1e 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c8 ff ff ff       	call   1001cf <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 fd fe ff ff       	call   100109 <lab1_print_cur_status>
}
  10020c:	90                   	nop
  10020d:	89 ec                	mov    %ebp,%esp
  10020f:	5d                   	pop    %ebp
  100210:	c3                   	ret    

00100211 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100211:	55                   	push   %ebp
  100212:	89 e5                	mov    %esp,%ebp
  100214:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10021b:	74 13                	je     100230 <readline+0x1f>
        cprintf("%s", prompt);
  10021d:	8b 45 08             	mov    0x8(%ebp),%eax
  100220:	89 44 24 04          	mov    %eax,0x4(%esp)
  100224:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  10022b:	e8 f0 00 00 00       	call   100320 <cprintf>
    }
    int i = 0, c;
  100230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100237:	e8 73 01 00 00       	call   1003af <getchar>
  10023c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100243:	79 07                	jns    10024c <readline+0x3b>
            return NULL;
  100245:	b8 00 00 00 00       	mov    $0x0,%eax
  10024a:	eb 78                	jmp    1002c4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100250:	7e 28                	jle    10027a <readline+0x69>
  100252:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100259:	7f 1f                	jg     10027a <readline+0x69>
            cputchar(c);
  10025b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025e:	89 04 24             	mov    %eax,(%esp)
  100261:	e8 e2 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100269:	8d 50 01             	lea    0x1(%eax),%edx
  10026c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100272:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100278:	eb 45                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10027a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027e:	75 16                	jne    100296 <readline+0x85>
  100280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100284:	7e 10                	jle    100296 <readline+0x85>
            cputchar(c);
  100286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100289:	89 04 24             	mov    %eax,(%esp)
  10028c:	e8 b7 00 00 00       	call   100348 <cputchar>
            i --;
  100291:	ff 4d f4             	decl   -0xc(%ebp)
  100294:	eb 29                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100296:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10029a:	74 06                	je     1002a2 <readline+0x91>
  10029c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a0:	75 95                	jne    100237 <readline+0x26>
            cputchar(c);
  1002a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a5:	89 04 24             	mov    %eax,(%esp)
  1002a8:	e8 9b 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002b5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002bd:	eb 05                	jmp    1002c4 <readline+0xb3>
        c = getchar();
  1002bf:	e9 73 ff ff ff       	jmp    100237 <readline+0x26>
        }
    }
}
  1002c4:	89 ec                	mov    %ebp,%esp
  1002c6:	5d                   	pop    %ebp
  1002c7:	c3                   	ret    

001002c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 2b 13 00 00       	call   101604 <cons_putc>
    (*cnt) ++;
  1002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dc:	8b 00                	mov    (%eax),%eax
  1002de:	8d 50 01             	lea    0x1(%eax),%edx
  1002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e4:	89 10                	mov    %edx,(%eax)
}
  1002e6:	90                   	nop
  1002e7:	89 ec                	mov    %ebp,%esp
  1002e9:	5d                   	pop    %ebp
  1002ea:	c3                   	ret    

001002eb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  100302:	89 44 24 08          	mov    %eax,0x8(%esp)
  100306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100309:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030d:	c7 04 24 c8 02 10 00 	movl   $0x1002c8,(%esp)
  100314:	e8 c3 29 00 00       	call   102cdc <vprintfmt>
    return cnt;
  100319:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031c:	89 ec                	mov    %ebp,%esp
  10031e:	5d                   	pop    %ebp
  10031f:	c3                   	ret    

00100320 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100320:	55                   	push   %ebp
  100321:	89 e5                	mov    %esp,%ebp
  100323:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100326:	8d 45 0c             	lea    0xc(%ebp),%eax
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100333:	8b 45 08             	mov    0x8(%ebp),%eax
  100336:	89 04 24             	mov    %eax,(%esp)
  100339:	e8 ad ff ff ff       	call   1002eb <vcprintf>
  10033e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100341:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100344:	89 ec                	mov    %ebp,%esp
  100346:	5d                   	pop    %ebp
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 ab 12 00 00       	call   101604 <cons_putc>
}
  100359:	90                   	nop
  10035a:	89 ec                	mov    %ebp,%esp
  10035c:	5d                   	pop    %ebp
  10035d:	c3                   	ret    

0010035e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10036b:	eb 13                	jmp    100380 <cputs+0x22>
        cputch(c, &cnt);
  10036d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100371:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100374:	89 54 24 04          	mov    %edx,0x4(%esp)
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 48 ff ff ff       	call   1002c8 <cputch>
    while ((c = *str ++) != '\0') {
  100380:	8b 45 08             	mov    0x8(%ebp),%eax
  100383:	8d 50 01             	lea    0x1(%eax),%edx
  100386:	89 55 08             	mov    %edx,0x8(%ebp)
  100389:	0f b6 00             	movzbl (%eax),%eax
  10038c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100393:	75 d8                	jne    10036d <cputs+0xf>
    }
    cputch('\n', &cnt);
  100395:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10039c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a3:	e8 20 ff ff ff       	call   1002c8 <cputch>
    return cnt;
  1003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ab:	89 ec                	mov    %ebp,%esp
  1003ad:	5d                   	pop    %ebp
  1003ae:	c3                   	ret    

001003af <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003af:	55                   	push   %ebp
  1003b0:	89 e5                	mov    %esp,%ebp
  1003b2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b5:	90                   	nop
  1003b6:	e8 75 12 00 00       	call   101630 <cons_getc>
  1003bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c2:	74 f2                	je     1003b6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c7:	89 ec                	mov    %ebp,%esp
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003dc:	8b 00                	mov    (%eax),%eax
  1003de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e8:	e9 ca 00 00 00       	jmp    1004b7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	89 c2                	mov    %eax,%edx
  1003f7:	c1 ea 1f             	shr    $0x1f,%edx
  1003fa:	01 d0                	add    %edx,%eax
  1003fc:	d1 f8                	sar    %eax
  1003fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100407:	eb 03                	jmp    10040c <stab_binsearch+0x41>
            m --;
  100409:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100412:	7c 1f                	jl     100433 <stab_binsearch+0x68>
  100414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100417:	89 d0                	mov    %edx,%eax
  100419:	01 c0                	add    %eax,%eax
  10041b:	01 d0                	add    %edx,%eax
  10041d:	c1 e0 02             	shl    $0x2,%eax
  100420:	89 c2                	mov    %eax,%edx
  100422:	8b 45 08             	mov    0x8(%ebp),%eax
  100425:	01 d0                	add    %edx,%eax
  100427:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10042b:	0f b6 c0             	movzbl %al,%eax
  10042e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100431:	75 d6                	jne    100409 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100436:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100439:	7d 09                	jge    100444 <stab_binsearch+0x79>
            l = true_m + 1;
  10043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043e:	40                   	inc    %eax
  10043f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100442:	eb 73                	jmp    1004b7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100444:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10044b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044e:	89 d0                	mov    %edx,%eax
  100450:	01 c0                	add    %eax,%eax
  100452:	01 d0                	add    %edx,%eax
  100454:	c1 e0 02             	shl    $0x2,%eax
  100457:	89 c2                	mov    %eax,%edx
  100459:	8b 45 08             	mov    0x8(%ebp),%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	8b 40 08             	mov    0x8(%eax),%eax
  100461:	39 45 18             	cmp    %eax,0x18(%ebp)
  100464:	76 11                	jbe    100477 <stab_binsearch+0xac>
            *region_left = m;
  100466:	8b 45 0c             	mov    0xc(%ebp),%eax
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100471:	40                   	inc    %eax
  100472:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100475:	eb 40                	jmp    1004b7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047a:	89 d0                	mov    %edx,%eax
  10047c:	01 c0                	add    %eax,%eax
  10047e:	01 d0                	add    %edx,%eax
  100480:	c1 e0 02             	shl    $0x2,%eax
  100483:	89 c2                	mov    %eax,%edx
  100485:	8b 45 08             	mov    0x8(%ebp),%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	8b 40 08             	mov    0x8(%eax),%eax
  10048d:	39 45 18             	cmp    %eax,0x18(%ebp)
  100490:	73 14                	jae    1004a6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  100492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100495:	8d 50 ff             	lea    -0x1(%eax),%edx
  100498:	8b 45 10             	mov    0x10(%ebp),%eax
  10049b:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	48                   	dec    %eax
  1004a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a4:	eb 11                	jmp    1004b7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ac:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 2a ff ff ff    	jle    1003ed <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004d6:	eb 3e                	jmp    100516 <stab_binsearch+0x14b>
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 03                	jmp    1004e5 <stab_binsearch+0x11a>
  1004e2:	ff 4d fc             	decl   -0x4(%ebp)
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004ed:	7e 1f                	jle    10050e <stab_binsearch+0x143>
  1004ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f2:	89 d0                	mov    %edx,%eax
  1004f4:	01 c0                	add    %eax,%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	c1 e0 02             	shl    $0x2,%eax
  1004fb:	89 c2                	mov    %eax,%edx
  1004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100506:	0f b6 c0             	movzbl %al,%eax
  100509:	39 45 14             	cmp    %eax,0x14(%ebp)
  10050c:	75 d4                	jne    1004e2 <stab_binsearch+0x117>
        *region_left = l;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 10                	mov    %edx,(%eax)
}
  100516:	90                   	nop
  100517:	89 ec                	mov    %ebp,%esp
  100519:	5d                   	pop    %ebp
  10051a:	c3                   	ret    

0010051b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10051b:	55                   	push   %ebp
  10051c:	89 e5                	mov    %esp,%ebp
  10051e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100521:	8b 45 0c             	mov    0xc(%ebp),%eax
  100524:	c7 00 ec 36 10 00    	movl   $0x1036ec,(%eax)
    info->eip_line = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	c7 40 08 ec 36 10 00 	movl   $0x1036ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100541:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054b:	8b 55 08             	mov    0x8(%ebp),%edx
  10054e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10055b:	c7 45 f4 6c 3f 10 00 	movl   $0x103f6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100562:	c7 45 f0 20 be 10 00 	movl   $0x10be20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100569:	c7 45 ec 21 be 10 00 	movl   $0x10be21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100570:	c7 45 e8 b7 e7 10 00 	movl   $0x10e7b7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057d:	76 0b                	jbe    10058a <debuginfo_eip+0x6f>
  10057f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100582:	48                   	dec    %eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x79>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 ab 02 00 00       	jmp    10083f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005a1:	c1 f8 02             	sar    $0x2,%eax
  1005a4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005aa:	48                   	dec    %eax
  1005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005bc:	00 
  1005bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ce:	89 04 24             	mov    %eax,(%esp)
  1005d1:	e8 f5 fd ff ff       	call   1003cb <stab_binsearch>
    if (lfile == 0)
  1005d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d9:	85 c0                	test   %eax,%eax
  1005db:	75 0a                	jne    1005e7 <debuginfo_eip+0xcc>
        return -1;
  1005dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e2:	e9 58 02 00 00       	jmp    10083f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fa:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100601:	00 
  100602:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100605:	89 44 24 08          	mov    %eax,0x8(%esp)
  100609:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100613:	89 04 24             	mov    %eax,(%esp)
  100616:	e8 b0 fd ff ff       	call   1003cb <stab_binsearch>

    if (lfun <= rfun) {
  10061b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10061e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100621:	39 c2                	cmp    %eax,%edx
  100623:	7f 78                	jg     10069d <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100628:	89 c2                	mov    %eax,%edx
  10062a:	89 d0                	mov    %edx,%eax
  10062c:	01 c0                	add    %eax,%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	c1 e0 02             	shl    $0x2,%eax
  100633:	89 c2                	mov    %eax,%edx
  100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100638:	01 d0                	add    %edx,%eax
  10063a:	8b 10                	mov    (%eax),%edx
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100642:	39 c2                	cmp    %eax,%edx
  100644:	73 22                	jae    100668 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100649:	89 c2                	mov    %eax,%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	8b 10                	mov    (%eax),%edx
  10065d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100660:	01 c2                	add    %eax,%edx
  100662:	8b 45 0c             	mov    0xc(%ebp),%eax
  100665:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066b:	89 c2                	mov    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	01 c0                	add    %eax,%eax
  100671:	01 d0                	add    %edx,%eax
  100673:	c1 e0 02             	shl    $0x2,%eax
  100676:	89 c2                	mov    %eax,%edx
  100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	8b 50 08             	mov    0x8(%eax),%edx
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	8b 40 10             	mov    0x10(%eax),%eax
  10068c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100698:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069b:	eb 15                	jmp    1006b2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006af:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b5:	8b 40 08             	mov    0x8(%eax),%eax
  1006b8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006bf:	00 
  1006c0:	89 04 24             	mov    %eax,(%esp)
  1006c3:	e8 61 2c 00 00       	call   103329 <strfind>
  1006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006cb:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006ce:	29 c8                	sub    %ecx,%eax
  1006d0:	89 c2                	mov    %eax,%edx
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006db:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006df:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e6:	00 
  1006e7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f8:	89 04 24             	mov    %eax,(%esp)
  1006fb:	e8 cb fc ff ff       	call   1003cb <stab_binsearch>
    if (lline <= rline) {
  100700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100703:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100706:	39 c2                	cmp    %eax,%edx
  100708:	7f 23                	jg     10072d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10070a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100723:	89 c2                	mov    %eax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 11                	jmp    10073e <debuginfo_eip+0x223>
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 08 01 00 00       	jmp    10083f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	48                   	dec    %eax
  10073b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10073e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100744:	39 c2                	cmp    %eax,%edx
  100746:	7c 56                	jl     10079e <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074b:	89 c2                	mov    %eax,%edx
  10074d:	89 d0                	mov    %edx,%eax
  10074f:	01 c0                	add    %eax,%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	c1 e0 02             	shl    $0x2,%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075b:	01 d0                	add    %edx,%eax
  10075d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100761:	3c 84                	cmp    $0x84,%al
  100763:	74 39                	je     10079e <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100768:	89 c2                	mov    %eax,%edx
  10076a:	89 d0                	mov    %edx,%eax
  10076c:	01 c0                	add    %eax,%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	c1 e0 02             	shl    $0x2,%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077e:	3c 64                	cmp    $0x64,%al
  100780:	75 b5                	jne    100737 <debuginfo_eip+0x21c>
  100782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 40 08             	mov    0x8(%eax),%eax
  10079a:	85 c0                	test   %eax,%eax
  10079c:	74 99                	je     100737 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a4:	39 c2                	cmp    %eax,%edx
  1007a6:	7c 42                	jl     1007ea <debuginfo_eip+0x2cf>
  1007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	89 d0                	mov    %edx,%eax
  1007af:	01 c0                	add    %eax,%eax
  1007b1:	01 d0                	add    %edx,%eax
  1007b3:	c1 e0 02             	shl    $0x2,%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bb:	01 d0                	add    %edx,%eax
  1007bd:	8b 10                	mov    (%eax),%edx
  1007bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007c5:	39 c2                	cmp    %eax,%edx
  1007c7:	73 21                	jae    1007ea <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cc:	89 c2                	mov    %eax,%edx
  1007ce:	89 d0                	mov    %edx,%eax
  1007d0:	01 c0                	add    %eax,%eax
  1007d2:	01 d0                	add    %edx,%eax
  1007d4:	c1 e0 02             	shl    $0x2,%eax
  1007d7:	89 c2                	mov    %eax,%edx
  1007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dc:	01 d0                	add    %edx,%eax
  1007de:	8b 10                	mov    (%eax),%edx
  1007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e3:	01 c2                	add    %eax,%edx
  1007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	7d 46                	jge    10083a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1007f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f7:	40                   	inc    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fb:	eb 16                	jmp    100813 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	8b 40 14             	mov    0x14(%eax),%eax
  100803:	8d 50 01             	lea    0x1(%eax),%edx
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10080c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080f:	40                   	inc    %eax
  100810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100813:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100819:	39 c2                	cmp    %eax,%edx
  10081b:	7d 1d                	jge    10083a <debuginfo_eip+0x31f>
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	89 d0                	mov    %edx,%eax
  100824:	01 c0                	add    %eax,%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	c1 e0 02             	shl    $0x2,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100836:	3c a0                	cmp    $0xa0,%al
  100838:	74 c3                	je     1007fd <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10083a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10083f:	89 ec                	mov    %ebp,%esp
  100841:	5d                   	pop    %ebp
  100842:	c3                   	ret    

00100843 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100843:	55                   	push   %ebp
  100844:	89 e5                	mov    %esp,%ebp
  100846:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100849:	c7 04 24 f6 36 10 00 	movl   $0x1036f6,(%esp)
  100850:	e8 cb fa ff ff       	call   100320 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100855:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085c:	00 
  10085d:	c7 04 24 0f 37 10 00 	movl   $0x10370f,(%esp)
  100864:	e8 b7 fa ff ff       	call   100320 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100869:	c7 44 24 04 3d 36 10 	movl   $0x10363d,0x4(%esp)
  100870:	00 
  100871:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  100878:	e8 a3 fa ff ff       	call   100320 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10087d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100884:	00 
  100885:	c7 04 24 3f 37 10 00 	movl   $0x10373f,(%esp)
  10088c:	e8 8f fa ff ff       	call   100320 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100891:	c7 44 24 04 68 0d 11 	movl   $0x110d68,0x4(%esp)
  100898:	00 
  100899:	c7 04 24 57 37 10 00 	movl   $0x103757,(%esp)
  1008a0:	e8 7b fa ff ff       	call   100320 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a5:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  1008aa:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008af:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008b4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ba:	85 c0                	test   %eax,%eax
  1008bc:	0f 48 c2             	cmovs  %edx,%eax
  1008bf:	c1 f8 0a             	sar    $0xa,%eax
  1008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008c6:	c7 04 24 70 37 10 00 	movl   $0x103770,(%esp)
  1008cd:	e8 4e fa ff ff       	call   100320 <cprintf>
}
  1008d2:	90                   	nop
  1008d3:	89 ec                	mov    %ebp,%esp
  1008d5:	5d                   	pop    %ebp
  1008d6:	c3                   	ret    

001008d7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	e8 29 fc ff ff       	call   10051b <debuginfo_eip>
  1008f2:	85 c0                	test   %eax,%eax
  1008f4:	74 15                	je     10090b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fd:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100904:	e8 17 fa ff ff       	call   100320 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100909:	eb 6c                	jmp    100977 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10090b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100912:	eb 1b                	jmp    10092f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091a:	01 d0                	add    %edx,%eax
  10091c:	0f b6 10             	movzbl (%eax),%edx
  10091f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100928:	01 c8                	add    %ecx,%eax
  10092a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10092c:	ff 45 f4             	incl   -0xc(%ebp)
  10092f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100935:	7c dd                	jl     100914 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100937:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100940:	01 d0                	add    %edx,%eax
  100942:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100945:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100948:	8b 45 08             	mov    0x8(%ebp),%eax
  10094b:	29 d0                	sub    %edx,%eax
  10094d:	89 c1                	mov    %eax,%ecx
  10094f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100955:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100963:	89 54 24 08          	mov    %edx,0x8(%esp)
  100967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10096b:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100972:	e8 a9 f9 ff ff       	call   100320 <cprintf>
}
  100977:	90                   	nop
  100978:	89 ec                	mov    %ebp,%esp
  10097a:	5d                   	pop    %ebp
  10097b:	c3                   	ret    

0010097c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097c:	55                   	push   %ebp
  10097d:	89 e5                	mov    %esp,%ebp
  10097f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100982:	8b 45 04             	mov    0x4(%ebp),%eax
  100985:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098b:	89 ec                	mov    %ebp,%esp
  10098d:	5d                   	pop    %ebp
  10098e:	c3                   	ret    

0010098f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100995:	89 e8                	mov    %ebp,%eax
  100997:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099a:	8b 45 e0             	mov    -0x20(%ebp),%eax
        eip = *((uint32_t *)ebp + 1);
        ebp = *((uint32_t *)ebp);
    }
    */

    uint32_t ebp = read_ebp(), eip = read_eip();
  10099d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009a0:	e8 d7 ff ff ff       	call   10097c <read_eip>
  1009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009af:	e9 84 00 00 00       	jmp    100a38 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c2:	c7 04 24 c8 37 10 00 	movl   $0x1037c8,(%esp)
  1009c9:	e8 52 f9 ff ff       	call   100320 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	83 c0 08             	add    $0x8,%eax
  1009d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  1009d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009de:	eb 24                	jmp    100a04 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  1009e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ed:	01 d0                	add    %edx,%eax
  1009ef:	8b 00                	mov    (%eax),%eax
  1009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f5:	c7 04 24 e4 37 10 00 	movl   $0x1037e4,(%esp)
  1009fc:	e8 1f f9 ff ff       	call   100320 <cprintf>
        for (j = 0; j < 4; j ++) {
  100a01:	ff 45 e8             	incl   -0x18(%ebp)
  100a04:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a08:	7e d6                	jle    1009e0 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a0a:	c7 04 24 ec 37 10 00 	movl   $0x1037ec,(%esp)
  100a11:	e8 0a f9 ff ff       	call   100320 <cprintf>
        print_debuginfo(eip - 1);
  100a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a19:	48                   	dec    %eax
  100a1a:	89 04 24             	mov    %eax,(%esp)
  100a1d:	e8 b5 fe ff ff       	call   1008d7 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a25:	83 c0 04             	add    $0x4,%eax
  100a28:	8b 00                	mov    (%eax),%eax
  100a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a30:	8b 00                	mov    (%eax),%eax
  100a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a35:	ff 45 ec             	incl   -0x14(%ebp)
  100a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a3c:	74 0a                	je     100a48 <print_stackframe+0xb9>
  100a3e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a42:	0f 8e 6c ff ff ff    	jle    1009b4 <print_stackframe+0x25>
    }
}
  100a48:	90                   	nop
  100a49:	89 ec                	mov    %ebp,%esp
  100a4b:	5d                   	pop    %ebp
  100a4c:	c3                   	ret    

00100a4d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4d:	55                   	push   %ebp
  100a4e:	89 e5                	mov    %esp,%ebp
  100a50:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5a:	eb 0c                	jmp    100a68 <parse+0x1b>
            *buf ++ = '\0';
  100a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5f:	8d 50 01             	lea    0x1(%eax),%edx
  100a62:	89 55 08             	mov    %edx,0x8(%ebp)
  100a65:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a68:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6b:	0f b6 00             	movzbl (%eax),%eax
  100a6e:	84 c0                	test   %al,%al
  100a70:	74 1d                	je     100a8f <parse+0x42>
  100a72:	8b 45 08             	mov    0x8(%ebp),%eax
  100a75:	0f b6 00             	movzbl (%eax),%eax
  100a78:	0f be c0             	movsbl %al,%eax
  100a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a7f:	c7 04 24 70 38 10 00 	movl   $0x103870,(%esp)
  100a86:	e8 6a 28 00 00       	call   1032f5 <strchr>
  100a8b:	85 c0                	test   %eax,%eax
  100a8d:	75 cd                	jne    100a5c <parse+0xf>
        }
        if (*buf == '\0') {
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	0f b6 00             	movzbl (%eax),%eax
  100a95:	84 c0                	test   %al,%al
  100a97:	74 65                	je     100afe <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a99:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a9d:	75 14                	jne    100ab3 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a9f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aa6:	00 
  100aa7:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  100aae:	e8 6d f8 ff ff       	call   100320 <cprintf>
        }
        argv[argc ++] = buf;
  100ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab6:	8d 50 01             	lea    0x1(%eax),%edx
  100ab9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100abc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ac6:	01 c2                	add    %eax,%edx
  100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  100acb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100acd:	eb 03                	jmp    100ad2 <parse+0x85>
            buf ++;
  100acf:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad5:	0f b6 00             	movzbl (%eax),%eax
  100ad8:	84 c0                	test   %al,%al
  100ada:	74 8c                	je     100a68 <parse+0x1b>
  100adc:	8b 45 08             	mov    0x8(%ebp),%eax
  100adf:	0f b6 00             	movzbl (%eax),%eax
  100ae2:	0f be c0             	movsbl %al,%eax
  100ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae9:	c7 04 24 70 38 10 00 	movl   $0x103870,(%esp)
  100af0:	e8 00 28 00 00       	call   1032f5 <strchr>
  100af5:	85 c0                	test   %eax,%eax
  100af7:	74 d6                	je     100acf <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af9:	e9 6a ff ff ff       	jmp    100a68 <parse+0x1b>
            break;
  100afe:	90                   	nop
        }
    }
    return argc;
  100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b02:	89 ec                	mov    %ebp,%esp
  100b04:	5d                   	pop    %ebp
  100b05:	c3                   	ret    

00100b06 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b06:	55                   	push   %ebp
  100b07:	89 e5                	mov    %esp,%ebp
  100b09:	83 ec 68             	sub    $0x68,%esp
  100b0c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	89 04 24             	mov    %eax,(%esp)
  100b1c:	e8 2c ff ff ff       	call   100a4d <parse>
  100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	75 0a                	jne    100b34 <runcmd+0x2e>
        return 0;
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	e9 83 00 00 00       	jmp    100bb7 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3b:	eb 5a                	jmp    100b97 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b40:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b43:	89 c8                	mov    %ecx,%eax
  100b45:	01 c0                	add    %eax,%eax
  100b47:	01 c8                	add    %ecx,%eax
  100b49:	c1 e0 02             	shl    $0x2,%eax
  100b4c:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b57:	89 04 24             	mov    %eax,(%esp)
  100b5a:	e8 fa 26 00 00       	call   103259 <strcmp>
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 31                	jne    100b94 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b66:	89 d0                	mov    %edx,%eax
  100b68:	01 c0                	add    %eax,%eax
  100b6a:	01 d0                	add    %edx,%eax
  100b6c:	c1 e0 02             	shl    $0x2,%eax
  100b6f:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b74:	8b 10                	mov    (%eax),%edx
  100b76:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b79:	83 c0 04             	add    $0x4,%eax
  100b7c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b7f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b85:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8d:	89 1c 24             	mov    %ebx,(%esp)
  100b90:	ff d2                	call   *%edx
  100b92:	eb 23                	jmp    100bb7 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b94:	ff 45 f4             	incl   -0xc(%ebp)
  100b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9a:	83 f8 02             	cmp    $0x2,%eax
  100b9d:	76 9e                	jbe    100b3d <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba6:	c7 04 24 93 38 10 00 	movl   $0x103893,(%esp)
  100bad:	e8 6e f7 ff ff       	call   100320 <cprintf>
    return 0;
  100bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bba:	89 ec                	mov    %ebp,%esp
  100bbc:	5d                   	pop    %ebp
  100bbd:	c3                   	ret    

00100bbe <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbe:	55                   	push   %ebp
  100bbf:	89 e5                	mov    %esp,%ebp
  100bc1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc4:	c7 04 24 ac 38 10 00 	movl   $0x1038ac,(%esp)
  100bcb:	e8 50 f7 ff ff       	call   100320 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd0:	c7 04 24 d4 38 10 00 	movl   $0x1038d4,(%esp)
  100bd7:	e8 44 f7 ff ff       	call   100320 <cprintf>

    if (tf != NULL) {
  100bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be0:	74 0b                	je     100bed <kmonitor+0x2f>
        print_trapframe(tf);
  100be2:	8b 45 08             	mov    0x8(%ebp),%eax
  100be5:	89 04 24             	mov    %eax,(%esp)
  100be8:	e8 8a 0e 00 00       	call   101a77 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bed:	c7 04 24 f9 38 10 00 	movl   $0x1038f9,(%esp)
  100bf4:	e8 18 f6 ff ff       	call   100211 <readline>
  100bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c00:	74 eb                	je     100bed <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c02:	8b 45 08             	mov    0x8(%ebp),%eax
  100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 f2 fe ff ff       	call   100b06 <runcmd>
  100c14:	85 c0                	test   %eax,%eax
  100c16:	78 02                	js     100c1a <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c18:	eb d3                	jmp    100bed <kmonitor+0x2f>
                break;
  100c1a:	90                   	nop
            }
        }
    }
}
  100c1b:	90                   	nop
  100c1c:	89 ec                	mov    %ebp,%esp
  100c1e:	5d                   	pop    %ebp
  100c1f:	c3                   	ret    

00100c20 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c20:	55                   	push   %ebp
  100c21:	89 e5                	mov    %esp,%ebp
  100c23:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c2d:	eb 3d                	jmp    100c6c <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c32:	89 d0                	mov    %edx,%eax
  100c34:	01 c0                	add    %eax,%eax
  100c36:	01 d0                	add    %edx,%eax
  100c38:	c1 e0 02             	shl    $0x2,%eax
  100c3b:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c40:	8b 10                	mov    (%eax),%edx
  100c42:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c45:	89 c8                	mov    %ecx,%eax
  100c47:	01 c0                	add    %eax,%eax
  100c49:	01 c8                	add    %ecx,%eax
  100c4b:	c1 e0 02             	shl    $0x2,%eax
  100c4e:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c53:	8b 00                	mov    (%eax),%eax
  100c55:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5d:	c7 04 24 fd 38 10 00 	movl   $0x1038fd,(%esp)
  100c64:	e8 b7 f6 ff ff       	call   100320 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c69:	ff 45 f4             	incl   -0xc(%ebp)
  100c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6f:	83 f8 02             	cmp    $0x2,%eax
  100c72:	76 bb                	jbe    100c2f <mon_help+0xf>
    }
    return 0;
  100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c79:	89 ec                	mov    %ebp,%esp
  100c7b:	5d                   	pop    %ebp
  100c7c:	c3                   	ret    

00100c7d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c7d:	55                   	push   %ebp
  100c7e:	89 e5                	mov    %esp,%ebp
  100c80:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c83:	e8 bb fb ff ff       	call   100843 <print_kerninfo>
    return 0;
  100c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8d:	89 ec                	mov    %ebp,%esp
  100c8f:	5d                   	pop    %ebp
  100c90:	c3                   	ret    

00100c91 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c91:	55                   	push   %ebp
  100c92:	89 e5                	mov    %esp,%ebp
  100c94:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c97:	e8 f3 fc ff ff       	call   10098f <print_stackframe>
    return 0;
  100c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca1:	89 ec                	mov    %ebp,%esp
  100ca3:	5d                   	pop    %ebp
  100ca4:	c3                   	ret    

00100ca5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
  100ca8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cab:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100cb0:	85 c0                	test   %eax,%eax
  100cb2:	75 5b                	jne    100d0f <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cb4:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100cbb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cbe:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd2:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  100cd9:	e8 42 f6 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce8:	89 04 24             	mov    %eax,(%esp)
  100ceb:	e8 fb f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100cf0:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  100cf7:	e8 24 f6 ff ff       	call   100320 <cprintf>
    
    cprintf("stack trackback:\n");
  100cfc:	c7 04 24 24 39 10 00 	movl   $0x103924,(%esp)
  100d03:	e8 18 f6 ff ff       	call   100320 <cprintf>
    print_stackframe();
  100d08:	e8 82 fc ff ff       	call   10098f <print_stackframe>
  100d0d:	eb 01                	jmp    100d10 <__panic+0x6b>
        goto panic_dead;
  100d0f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d10:	e8 81 09 00 00       	call   101696 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d1c:	e8 9d fe ff ff       	call   100bbe <kmonitor>
  100d21:	eb f2                	jmp    100d15 <__panic+0x70>

00100d23 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d23:	55                   	push   %ebp
  100d24:	89 e5                	mov    %esp,%ebp
  100d26:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d29:	8d 45 14             	lea    0x14(%ebp),%eax
  100d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d32:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d36:	8b 45 08             	mov    0x8(%ebp),%eax
  100d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3d:	c7 04 24 36 39 10 00 	movl   $0x103936,(%esp)
  100d44:	e8 d7 f5 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d50:	8b 45 10             	mov    0x10(%ebp),%eax
  100d53:	89 04 24             	mov    %eax,(%esp)
  100d56:	e8 90 f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100d5b:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  100d62:	e8 b9 f5 ff ff       	call   100320 <cprintf>
    va_end(ap);
}
  100d67:	90                   	nop
  100d68:	89 ec                	mov    %ebp,%esp
  100d6a:	5d                   	pop    %ebp
  100d6b:	c3                   	ret    

00100d6c <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d6c:	55                   	push   %ebp
  100d6d:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d6f:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d74:	5d                   	pop    %ebp
  100d75:	c3                   	ret    

00100d76 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 28             	sub    $0x28,%esp
  100d7c:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d82:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d8e:	ee                   	out    %al,(%dx)
}
  100d8f:	90                   	nop
  100d90:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d96:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d9a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d9e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da2:	ee                   	out    %al,(%dx)
}
  100da3:	90                   	nop
  100da4:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100daa:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dae:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100db2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db6:	ee                   	out    %al,(%dx)
}
  100db7:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db8:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100dbf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc2:	c7 04 24 54 39 10 00 	movl   $0x103954,(%esp)
  100dc9:	e8 52 f5 ff ff       	call   100320 <cprintf>
    pic_enable(IRQ_TIMER);
  100dce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd5:	e8 21 09 00 00       	call   1016fb <pic_enable>
}
  100dda:	90                   	nop
  100ddb:	89 ec                	mov    %ebp,%esp
  100ddd:	5d                   	pop    %ebp
  100dde:	c3                   	ret    

00100ddf <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ddf:	55                   	push   %ebp
  100de0:	89 e5                	mov    %esp,%ebp
  100de2:	83 ec 10             	sub    $0x10,%esp
  100de5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100deb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100def:	89 c2                	mov    %eax,%edx
  100df1:	ec                   	in     (%dx),%al
  100df2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100df5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dfb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dff:	89 c2                	mov    %eax,%edx
  100e01:	ec                   	in     (%dx),%al
  100e02:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e05:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e0b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e0f:	89 c2                	mov    %eax,%edx
  100e11:	ec                   	in     (%dx),%al
  100e12:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e15:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e1b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e1f:	89 c2                	mov    %eax,%edx
  100e21:	ec                   	in     (%dx),%al
  100e22:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e25:	90                   	nop
  100e26:	89 ec                	mov    %ebp,%esp
  100e28:	5d                   	pop    %ebp
  100e29:	c3                   	ret    

00100e2a <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e2a:	55                   	push   %ebp
  100e2b:	89 e5                	mov    %esp,%ebp
  100e2d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e30:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3a:	0f b7 00             	movzwl (%eax),%eax
  100e3d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e44:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4c:	0f b7 00             	movzwl (%eax),%eax
  100e4f:	0f b7 c0             	movzwl %ax,%eax
  100e52:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e57:	74 12                	je     100e6b <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e59:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e60:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e67:	b4 03 
  100e69:	eb 13                	jmp    100e7e <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e6e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e72:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e75:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e7c:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e7e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e85:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e89:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e8d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e91:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e95:	ee                   	out    %al,(%dx)
}
  100e96:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e97:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e9e:	40                   	inc    %eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eaa:	89 c2                	mov    %eax,%edx
  100eac:	ec                   	in     (%dx),%al
  100ead:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100eb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb4:	0f b6 c0             	movzbl %al,%eax
  100eb7:	c1 e0 08             	shl    $0x8,%eax
  100eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ebd:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ec4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ec8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
}
  100ed5:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed6:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100edd:	40                   	inc    %eax
  100ede:	0f b7 c0             	movzwl %ax,%eax
  100ee1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ee9:	89 c2                	mov    %eax,%edx
  100eeb:	ec                   	in     (%dx),%al
  100eec:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eef:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ef3:	0f b6 c0             	movzbl %al,%eax
  100ef6:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efc:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f0d:	90                   	nop
  100f0e:	89 ec                	mov    %ebp,%esp
  100f10:	5d                   	pop    %ebp
  100f11:	c3                   	ret    

00100f12 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f12:	55                   	push   %ebp
  100f13:	89 e5                	mov    %esp,%ebp
  100f15:	83 ec 48             	sub    $0x48,%esp
  100f18:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f1e:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f22:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f26:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f2a:	ee                   	out    %al,(%dx)
}
  100f2b:	90                   	nop
  100f2c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f32:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f36:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f3a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f3e:	ee                   	out    %al,(%dx)
}
  100f3f:	90                   	nop
  100f40:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f46:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f4a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f4e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
}
  100f53:	90                   	nop
  100f54:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f5a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f5e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f62:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f66:	ee                   	out    %al,(%dx)
}
  100f67:	90                   	nop
  100f68:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f6e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f72:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f76:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
}
  100f7b:	90                   	nop
  100f7c:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f82:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f86:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f8a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
}
  100f8f:	90                   	nop
  100f90:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f96:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f9a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
}
  100fa3:	90                   	nop
  100fa4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100faa:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fae:	89 c2                	mov    %eax,%edx
  100fb0:	ec                   	in     (%dx),%al
  100fb1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fb4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fb8:	3c ff                	cmp    $0xff,%al
  100fba:	0f 95 c0             	setne  %al
  100fbd:	0f b6 c0             	movzbl %al,%eax
  100fc0:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fc5:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fcb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fcf:	89 c2                	mov    %eax,%edx
  100fd1:	ec                   	in     (%dx),%al
  100fd2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fd5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fdb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fe5:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fea:	85 c0                	test   %eax,%eax
  100fec:	74 0c                	je     100ffa <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100fee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100ff5:	e8 01 07 00 00       	call   1016fb <pic_enable>
    }
}
  100ffa:	90                   	nop
  100ffb:	89 ec                	mov    %ebp,%esp
  100ffd:	5d                   	pop    %ebp
  100ffe:	c3                   	ret    

00100fff <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fff:	55                   	push   %ebp
  101000:	89 e5                	mov    %esp,%ebp
  101002:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10100c:	eb 08                	jmp    101016 <lpt_putc_sub+0x17>
        delay();
  10100e:	e8 cc fd ff ff       	call   100ddf <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101013:	ff 45 fc             	incl   -0x4(%ebp)
  101016:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10101c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101020:	89 c2                	mov    %eax,%edx
  101022:	ec                   	in     (%dx),%al
  101023:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101026:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10102a:	84 c0                	test   %al,%al
  10102c:	78 09                	js     101037 <lpt_putc_sub+0x38>
  10102e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101035:	7e d7                	jle    10100e <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101037:	8b 45 08             	mov    0x8(%ebp),%eax
  10103a:	0f b6 c0             	movzbl %al,%eax
  10103d:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101043:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101046:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10104a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10104e:	ee                   	out    %al,(%dx)
}
  10104f:	90                   	nop
  101050:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101056:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10105a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10105e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101062:	ee                   	out    %al,(%dx)
}
  101063:	90                   	nop
  101064:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10106a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10106e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101072:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101076:	ee                   	out    %al,(%dx)
}
  101077:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101078:	90                   	nop
  101079:	89 ec                	mov    %ebp,%esp
  10107b:	5d                   	pop    %ebp
  10107c:	c3                   	ret    

0010107d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10107d:	55                   	push   %ebp
  10107e:	89 e5                	mov    %esp,%ebp
  101080:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101083:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101087:	74 0d                	je     101096 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	89 04 24             	mov    %eax,(%esp)
  10108f:	e8 6b ff ff ff       	call   100fff <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101094:	eb 24                	jmp    1010ba <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101096:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10109d:	e8 5d ff ff ff       	call   100fff <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010a2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010a9:	e8 51 ff ff ff       	call   100fff <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ae:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010b5:	e8 45 ff ff ff       	call   100fff <lpt_putc_sub>
}
  1010ba:	90                   	nop
  1010bb:	89 ec                	mov    %ebp,%esp
  1010bd:	5d                   	pop    %ebp
  1010be:	c3                   	ret    

001010bf <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010bf:	55                   	push   %ebp
  1010c0:	89 e5                	mov    %esp,%ebp
  1010c2:	83 ec 38             	sub    $0x38,%esp
  1010c5:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cb:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010d0:	85 c0                	test   %eax,%eax
  1010d2:	75 07                	jne    1010db <cga_putc+0x1c>
        c |= 0x0700;
  1010d4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010db:	8b 45 08             	mov    0x8(%ebp),%eax
  1010de:	0f b6 c0             	movzbl %al,%eax
  1010e1:	83 f8 0d             	cmp    $0xd,%eax
  1010e4:	74 72                	je     101158 <cga_putc+0x99>
  1010e6:	83 f8 0d             	cmp    $0xd,%eax
  1010e9:	0f 8f a3 00 00 00    	jg     101192 <cga_putc+0xd3>
  1010ef:	83 f8 08             	cmp    $0x8,%eax
  1010f2:	74 0a                	je     1010fe <cga_putc+0x3f>
  1010f4:	83 f8 0a             	cmp    $0xa,%eax
  1010f7:	74 4c                	je     101145 <cga_putc+0x86>
  1010f9:	e9 94 00 00 00       	jmp    101192 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  1010fe:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101105:	85 c0                	test   %eax,%eax
  101107:	0f 84 af 00 00 00    	je     1011bc <cga_putc+0xfd>
            crt_pos --;
  10110d:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101114:	48                   	dec    %eax
  101115:	0f b7 c0             	movzwl %ax,%eax
  101118:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10111e:	8b 45 08             	mov    0x8(%ebp),%eax
  101121:	98                   	cwtl   
  101122:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101127:	98                   	cwtl   
  101128:	83 c8 20             	or     $0x20,%eax
  10112b:	98                   	cwtl   
  10112c:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101132:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101139:	01 d2                	add    %edx,%edx
  10113b:	01 ca                	add    %ecx,%edx
  10113d:	0f b7 c0             	movzwl %ax,%eax
  101140:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101143:	eb 77                	jmp    1011bc <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101145:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10114c:	83 c0 50             	add    $0x50,%eax
  10114f:	0f b7 c0             	movzwl %ax,%eax
  101152:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101158:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10115f:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101166:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10116b:	89 c8                	mov    %ecx,%eax
  10116d:	f7 e2                	mul    %edx
  10116f:	c1 ea 06             	shr    $0x6,%edx
  101172:	89 d0                	mov    %edx,%eax
  101174:	c1 e0 02             	shl    $0x2,%eax
  101177:	01 d0                	add    %edx,%eax
  101179:	c1 e0 04             	shl    $0x4,%eax
  10117c:	29 c1                	sub    %eax,%ecx
  10117e:	89 ca                	mov    %ecx,%edx
  101180:	0f b7 d2             	movzwl %dx,%edx
  101183:	89 d8                	mov    %ebx,%eax
  101185:	29 d0                	sub    %edx,%eax
  101187:	0f b7 c0             	movzwl %ax,%eax
  10118a:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  101190:	eb 2b                	jmp    1011bd <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101192:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101198:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10119f:	8d 50 01             	lea    0x1(%eax),%edx
  1011a2:	0f b7 d2             	movzwl %dx,%edx
  1011a5:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011ac:	01 c0                	add    %eax,%eax
  1011ae:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b4:	0f b7 c0             	movzwl %ax,%eax
  1011b7:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ba:	eb 01                	jmp    1011bd <cga_putc+0xfe>
        break;
  1011bc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011bd:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011c4:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011c9:	76 5e                	jbe    101229 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011cb:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011d0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011d6:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011db:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011e2:	00 
  1011e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011e7:	89 04 24             	mov    %eax,(%esp)
  1011ea:	e8 04 23 00 00       	call   1034f3 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ef:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011f6:	eb 15                	jmp    10120d <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  1011f8:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  1011fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101201:	01 c0                	add    %eax,%eax
  101203:	01 d0                	add    %edx,%eax
  101205:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120a:	ff 45 f4             	incl   -0xc(%ebp)
  10120d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101214:	7e e2                	jle    1011f8 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101216:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10121d:	83 e8 50             	sub    $0x50,%eax
  101220:	0f b7 c0             	movzwl %ax,%eax
  101223:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101229:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101230:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101234:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101238:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10123c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101240:	ee                   	out    %al,(%dx)
}
  101241:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101242:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101249:	c1 e8 08             	shr    $0x8,%eax
  10124c:	0f b7 c0             	movzwl %ax,%eax
  10124f:	0f b6 c0             	movzbl %al,%eax
  101252:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101259:	42                   	inc    %edx
  10125a:	0f b7 d2             	movzwl %dx,%edx
  10125d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101261:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101264:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101268:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
}
  10126d:	90                   	nop
    outb(addr_6845, 15);
  10126e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101275:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101279:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10127d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101281:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101285:	ee                   	out    %al,(%dx)
}
  101286:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101287:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10128e:	0f b6 c0             	movzbl %al,%eax
  101291:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101298:	42                   	inc    %edx
  101299:	0f b7 d2             	movzwl %dx,%edx
  10129c:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012a0:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012ab:	ee                   	out    %al,(%dx)
}
  1012ac:	90                   	nop
}
  1012ad:	90                   	nop
  1012ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012b1:	89 ec                	mov    %ebp,%esp
  1012b3:	5d                   	pop    %ebp
  1012b4:	c3                   	ret    

001012b5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012b5:	55                   	push   %ebp
  1012b6:	89 e5                	mov    %esp,%ebp
  1012b8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012c2:	eb 08                	jmp    1012cc <serial_putc_sub+0x17>
        delay();
  1012c4:	e8 16 fb ff ff       	call   100ddf <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c9:	ff 45 fc             	incl   -0x4(%ebp)
  1012cc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012d2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012d6:	89 c2                	mov    %eax,%edx
  1012d8:	ec                   	in     (%dx),%al
  1012d9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012dc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012e0:	0f b6 c0             	movzbl %al,%eax
  1012e3:	83 e0 20             	and    $0x20,%eax
  1012e6:	85 c0                	test   %eax,%eax
  1012e8:	75 09                	jne    1012f3 <serial_putc_sub+0x3e>
  1012ea:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012f1:	7e d1                	jle    1012c4 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1012f6:	0f b6 c0             	movzbl %al,%eax
  1012f9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ff:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101302:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101306:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10130a:	ee                   	out    %al,(%dx)
}
  10130b:	90                   	nop
}
  10130c:	90                   	nop
  10130d:	89 ec                	mov    %ebp,%esp
  10130f:	5d                   	pop    %ebp
  101310:	c3                   	ret    

00101311 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101311:	55                   	push   %ebp
  101312:	89 e5                	mov    %esp,%ebp
  101314:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101317:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10131b:	74 0d                	je     10132a <serial_putc+0x19>
        serial_putc_sub(c);
  10131d:	8b 45 08             	mov    0x8(%ebp),%eax
  101320:	89 04 24             	mov    %eax,(%esp)
  101323:	e8 8d ff ff ff       	call   1012b5 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101328:	eb 24                	jmp    10134e <serial_putc+0x3d>
        serial_putc_sub('\b');
  10132a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101331:	e8 7f ff ff ff       	call   1012b5 <serial_putc_sub>
        serial_putc_sub(' ');
  101336:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10133d:	e8 73 ff ff ff       	call   1012b5 <serial_putc_sub>
        serial_putc_sub('\b');
  101342:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101349:	e8 67 ff ff ff       	call   1012b5 <serial_putc_sub>
}
  10134e:	90                   	nop
  10134f:	89 ec                	mov    %ebp,%esp
  101351:	5d                   	pop    %ebp
  101352:	c3                   	ret    

00101353 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101353:	55                   	push   %ebp
  101354:	89 e5                	mov    %esp,%ebp
  101356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101359:	eb 33                	jmp    10138e <cons_intr+0x3b>
        if (c != 0) {
  10135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10135f:	74 2d                	je     10138e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101361:	a1 84 00 11 00       	mov    0x110084,%eax
  101366:	8d 50 01             	lea    0x1(%eax),%edx
  101369:	89 15 84 00 11 00    	mov    %edx,0x110084
  10136f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101372:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101378:	a1 84 00 11 00       	mov    0x110084,%eax
  10137d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101382:	75 0a                	jne    10138e <cons_intr+0x3b>
                cons.wpos = 0;
  101384:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  10138b:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10138e:	8b 45 08             	mov    0x8(%ebp),%eax
  101391:	ff d0                	call   *%eax
  101393:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101396:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139a:	75 bf                	jne    10135b <cons_intr+0x8>
            }
        }
    }
}
  10139c:	90                   	nop
  10139d:	90                   	nop
  10139e:	89 ec                	mov    %ebp,%esp
  1013a0:	5d                   	pop    %ebp
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	89 ec                	mov    %ebp,%esp
  1013f9:	5d                   	pop    %ebp
  1013fa:	c3                   	ret    

001013fb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fb:	55                   	push   %ebp
  1013fc:	89 e5                	mov    %esp,%ebp
  1013fe:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101401:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101406:	85 c0                	test   %eax,%eax
  101408:	74 0c                	je     101416 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140a:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  101411:	e8 3d ff ff ff       	call   101353 <cons_intr>
    }
}
  101416:	90                   	nop
  101417:	89 ec                	mov    %ebp,%esp
  101419:	5d                   	pop    %ebp
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
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10142a:	89 c2                	mov    %eax,%edx
  10142c:	ec                   	in     (%dx),%al
  10142d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101430:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101434:	0f b6 c0             	movzbl %al,%eax
  101437:	83 e0 01             	and    $0x1,%eax
  10143a:	85 c0                	test   %eax,%eax
  10143c:	75 0a                	jne    101448 <kbd_proc_data+0x2d>
        return -1;
  10143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101443:	e9 56 01 00 00       	jmp    10159e <kbd_proc_data+0x183>
  101448:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10144e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101451:	89 c2                	mov    %eax,%edx
  101453:	ec                   	in     (%dx),%al
  101454:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101457:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101462:	75 17                	jne    10147b <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101464:	a1 88 00 11 00       	mov    0x110088,%eax
  101469:	83 c8 40             	or     $0x40,%eax
  10146c:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101471:	b8 00 00 00 00       	mov    $0x0,%eax
  101476:	e9 23 01 00 00       	jmp    10159e <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	84 c0                	test   %al,%al
  101481:	79 45                	jns    1014c8 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101483:	a1 88 00 11 00       	mov    0x110088,%eax
  101488:	83 e0 40             	and    $0x40,%eax
  10148b:	85 c0                	test   %eax,%eax
  10148d:	75 08                	jne    101497 <kbd_proc_data+0x7c>
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	24 7f                	and    $0x7f,%al
  101495:	eb 04                	jmp    10149b <kbd_proc_data+0x80>
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014a9:	0c 40                	or     $0x40,%al
  1014ab:	0f b6 c0             	movzbl %al,%eax
  1014ae:	f7 d0                	not    %eax
  1014b0:	89 c2                	mov    %eax,%edx
  1014b2:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b7:	21 d0                	and    %edx,%eax
  1014b9:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014be:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c3:	e9 d6 00 00 00       	jmp    10159e <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014c8:	a1 88 00 11 00       	mov    0x110088,%eax
  1014cd:	83 e0 40             	and    $0x40,%eax
  1014d0:	85 c0                	test   %eax,%eax
  1014d2:	74 11                	je     1014e5 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d8:	a1 88 00 11 00       	mov    0x110088,%eax
  1014dd:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e0:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1014e5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e9:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014f0:	0f b6 d0             	movzbl %al,%edx
  1014f3:	a1 88 00 11 00       	mov    0x110088,%eax
  1014f8:	09 d0                	or     %edx,%eax
  1014fa:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  1014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101503:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  10150a:	0f b6 d0             	movzbl %al,%edx
  10150d:	a1 88 00 11 00       	mov    0x110088,%eax
  101512:	31 d0                	xor    %edx,%eax
  101514:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101519:	a1 88 00 11 00       	mov    0x110088,%eax
  10151e:	83 e0 03             	and    $0x3,%eax
  101521:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	01 d0                	add    %edx,%eax
  10152e:	0f b6 00             	movzbl (%eax),%eax
  101531:	0f b6 c0             	movzbl %al,%eax
  101534:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101537:	a1 88 00 11 00       	mov    0x110088,%eax
  10153c:	83 e0 08             	and    $0x8,%eax
  10153f:	85 c0                	test   %eax,%eax
  101541:	74 22                	je     101565 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101543:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101547:	7e 0c                	jle    101555 <kbd_proc_data+0x13a>
  101549:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154d:	7f 06                	jg     101555 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10154f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101553:	eb 10                	jmp    101565 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101555:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101559:	7e 0a                	jle    101565 <kbd_proc_data+0x14a>
  10155b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155f:	7f 04                	jg     101565 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101561:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101565:	a1 88 00 11 00       	mov    0x110088,%eax
  10156a:	f7 d0                	not    %eax
  10156c:	83 e0 06             	and    $0x6,%eax
  10156f:	85 c0                	test   %eax,%eax
  101571:	75 28                	jne    10159b <kbd_proc_data+0x180>
  101573:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157a:	75 1f                	jne    10159b <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  10157c:	c7 04 24 6f 39 10 00 	movl   $0x10396f,(%esp)
  101583:	e8 98 ed ff ff       	call   100320 <cprintf>
  101588:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101592:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101596:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
}
  10159a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159e:	89 ec                	mov    %ebp,%esp
  1015a0:	5d                   	pop    %ebp
  1015a1:	c3                   	ret    

001015a2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a2:	55                   	push   %ebp
  1015a3:	89 e5                	mov    %esp,%ebp
  1015a5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a8:	c7 04 24 1b 14 10 00 	movl   $0x10141b,(%esp)
  1015af:	e8 9f fd ff ff       	call   101353 <cons_intr>
}
  1015b4:	90                   	nop
  1015b5:	89 ec                	mov    %ebp,%esp
  1015b7:	5d                   	pop    %ebp
  1015b8:	c3                   	ret    

001015b9 <kbd_init>:

static void
kbd_init(void) {
  1015b9:	55                   	push   %ebp
  1015ba:	89 e5                	mov    %esp,%ebp
  1015bc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bf:	e8 de ff ff ff       	call   1015a2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cb:	e8 2b 01 00 00       	call   1016fb <pic_enable>
}
  1015d0:	90                   	nop
  1015d1:	89 ec                	mov    %ebp,%esp
  1015d3:	5d                   	pop    %ebp
  1015d4:	c3                   	ret    

001015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015db:	e8 4a f8 ff ff       	call   100e2a <cga_init>
    serial_init();
  1015e0:	e8 2d f9 ff ff       	call   100f12 <serial_init>
    kbd_init();
  1015e5:	e8 cf ff ff ff       	call   1015b9 <kbd_init>
    if (!serial_exists) {
  1015ea:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1015ef:	85 c0                	test   %eax,%eax
  1015f1:	75 0c                	jne    1015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f3:	c7 04 24 7b 39 10 00 	movl   $0x10397b,(%esp)
  1015fa:	e8 21 ed ff ff       	call   100320 <cprintf>
    }
}
  1015ff:	90                   	nop
  101600:	89 ec                	mov    %ebp,%esp
  101602:	5d                   	pop    %ebp
  101603:	c3                   	ret    

00101604 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101604:	55                   	push   %ebp
  101605:	89 e5                	mov    %esp,%ebp
  101607:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10160a:	8b 45 08             	mov    0x8(%ebp),%eax
  10160d:	89 04 24             	mov    %eax,(%esp)
  101610:	e8 68 fa ff ff       	call   10107d <lpt_putc>
    cga_putc(c);
  101615:	8b 45 08             	mov    0x8(%ebp),%eax
  101618:	89 04 24             	mov    %eax,(%esp)
  10161b:	e8 9f fa ff ff       	call   1010bf <cga_putc>
    serial_putc(c);
  101620:	8b 45 08             	mov    0x8(%ebp),%eax
  101623:	89 04 24             	mov    %eax,(%esp)
  101626:	e8 e6 fc ff ff       	call   101311 <serial_putc>
}
  10162b:	90                   	nop
  10162c:	89 ec                	mov    %ebp,%esp
  10162e:	5d                   	pop    %ebp
  10162f:	c3                   	ret    

00101630 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101636:	e8 c0 fd ff ff       	call   1013fb <serial_intr>
    kbd_intr();
  10163b:	e8 62 ff ff ff       	call   1015a2 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101640:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101646:	a1 84 00 11 00       	mov    0x110084,%eax
  10164b:	39 c2                	cmp    %eax,%edx
  10164d:	74 36                	je     101685 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10164f:	a1 80 00 11 00       	mov    0x110080,%eax
  101654:	8d 50 01             	lea    0x1(%eax),%edx
  101657:	89 15 80 00 11 00    	mov    %edx,0x110080
  10165d:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101664:	0f b6 c0             	movzbl %al,%eax
  101667:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10166a:	a1 80 00 11 00       	mov    0x110080,%eax
  10166f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101674:	75 0a                	jne    101680 <cons_getc+0x50>
            cons.rpos = 0;
  101676:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10167d:	00 00 00 
        }
        return c;
  101680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101683:	eb 05                	jmp    10168a <cons_getc+0x5a>
    }
    return 0;
  101685:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10168a:	89 ec                	mov    %ebp,%esp
  10168c:	5d                   	pop    %ebp
  10168d:	c3                   	ret    

0010168e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10168e:	55                   	push   %ebp
  10168f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101691:	fb                   	sti    
}
  101692:	90                   	nop
    sti();
}
  101693:	90                   	nop
  101694:	5d                   	pop    %ebp
  101695:	c3                   	ret    

00101696 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101696:	55                   	push   %ebp
  101697:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101699:	fa                   	cli    
}
  10169a:	90                   	nop
    cli();
}
  10169b:	90                   	nop
  10169c:	5d                   	pop    %ebp
  10169d:	c3                   	ret    

0010169e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10169e:	55                   	push   %ebp
  10169f:	89 e5                	mov    %esp,%ebp
  1016a1:	83 ec 14             	sub    $0x14,%esp
  1016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ae:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016b4:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016b9:	85 c0                	test   %eax,%eax
  1016bb:	74 39                	je     1016f6 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016c0:	0f b6 c0             	movzbl %al,%eax
  1016c3:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016c9:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016cc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
}
  1016d5:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016da:	c1 e8 08             	shr    $0x8,%eax
  1016dd:	0f b7 c0             	movzwl %ax,%eax
  1016e0:	0f b6 c0             	movzbl %al,%eax
  1016e3:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016e9:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016ec:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f4:	ee                   	out    %al,(%dx)
}
  1016f5:	90                   	nop
    }
}
  1016f6:	90                   	nop
  1016f7:	89 ec                	mov    %ebp,%esp
  1016f9:	5d                   	pop    %ebp
  1016fa:	c3                   	ret    

001016fb <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016fb:	55                   	push   %ebp
  1016fc:	89 e5                	mov    %esp,%ebp
  1016fe:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101701:	8b 45 08             	mov    0x8(%ebp),%eax
  101704:	ba 01 00 00 00       	mov    $0x1,%edx
  101709:	88 c1                	mov    %al,%cl
  10170b:	d3 e2                	shl    %cl,%edx
  10170d:	89 d0                	mov    %edx,%eax
  10170f:	98                   	cwtl   
  101710:	f7 d0                	not    %eax
  101712:	0f bf d0             	movswl %ax,%edx
  101715:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10171c:	98                   	cwtl   
  10171d:	21 d0                	and    %edx,%eax
  10171f:	98                   	cwtl   
  101720:	0f b7 c0             	movzwl %ax,%eax
  101723:	89 04 24             	mov    %eax,(%esp)
  101726:	e8 73 ff ff ff       	call   10169e <pic_setmask>
}
  10172b:	90                   	nop
  10172c:	89 ec                	mov    %ebp,%esp
  10172e:	5d                   	pop    %ebp
  10172f:	c3                   	ret    

00101730 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101730:	55                   	push   %ebp
  101731:	89 e5                	mov    %esp,%ebp
  101733:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101736:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10173d:	00 00 00 
  101740:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101746:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10174a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10174e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101752:	ee                   	out    %al,(%dx)
}
  101753:	90                   	nop
  101754:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10175a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10175e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101762:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101766:	ee                   	out    %al,(%dx)
}
  101767:	90                   	nop
  101768:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10176e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101772:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101776:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
}
  10177b:	90                   	nop
  10177c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101782:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101786:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10178a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178e:	ee                   	out    %al,(%dx)
}
  10178f:	90                   	nop
  101790:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101796:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10179a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10179e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
}
  1017a3:	90                   	nop
  1017a4:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017aa:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ae:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017b2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
}
  1017b7:	90                   	nop
  1017b8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017be:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017c6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
}
  1017cb:	90                   	nop
  1017cc:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017d2:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017da:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017de:	ee                   	out    %al,(%dx)
}
  1017df:	90                   	nop
  1017e0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017e6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017ee:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017f2:	ee                   	out    %al,(%dx)
}
  1017f3:	90                   	nop
  1017f4:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017fa:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101802:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101806:	ee                   	out    %al,(%dx)
}
  101807:	90                   	nop
  101808:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10180e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101812:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101816:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
}
  10181b:	90                   	nop
  10181c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101822:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101826:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10182a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
}
  10182f:	90                   	nop
  101830:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101836:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10183a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10183e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
}
  101843:	90                   	nop
  101844:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10184a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101852:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101856:	ee                   	out    %al,(%dx)
}
  101857:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101858:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10185f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101864:	74 0f                	je     101875 <pic_init+0x145>
        pic_setmask(irq_mask);
  101866:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10186d:	89 04 24             	mov    %eax,(%esp)
  101870:	e8 29 fe ff ff       	call   10169e <pic_setmask>
    }
}
  101875:	90                   	nop
  101876:	89 ec                	mov    %ebp,%esp
  101878:	5d                   	pop    %ebp
  101879:	c3                   	ret    

0010187a <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10187a:	55                   	push   %ebp
  10187b:	89 e5                	mov    %esp,%ebp
  10187d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101880:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101887:	00 
  101888:	c7 04 24 a0 39 10 00 	movl   $0x1039a0,(%esp)
  10188f:	e8 8c ea ff ff       	call   100320 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101894:	c7 04 24 aa 39 10 00 	movl   $0x1039aa,(%esp)
  10189b:	e8 80 ea ff ff       	call   100320 <cprintf>
    panic("EOT: kernel seems ok.");
  1018a0:	c7 44 24 08 b8 39 10 	movl   $0x1039b8,0x8(%esp)
  1018a7:	00 
  1018a8:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018af:	00 
  1018b0:	c7 04 24 ce 39 10 00 	movl   $0x1039ce,(%esp)
  1018b7:	e8 e9 f3 ff ff       	call   100ca5 <__panic>

001018bc <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018bc:	55                   	push   %ebp
  1018bd:	89 e5                	mov    %esp,%ebp
  1018bf:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c9:	e9 c4 00 00 00       	jmp    101992 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018d8:	0f b7 d0             	movzwl %ax,%edx
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  1018e5:	00 
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  1018f0:	00 08 00 
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  1018fd:	00 
  1018fe:	80 e2 e0             	and    $0xe0,%dl
  101901:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190b:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  101912:	00 
  101913:	80 e2 1f             	and    $0x1f,%dl
  101916:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101927:	00 
  101928:	80 e2 f0             	and    $0xf0,%dl
  10192b:	80 ca 0e             	or     $0xe,%dl
  10192e:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  10193f:	00 
  101940:	80 e2 ef             	and    $0xef,%dl
  101943:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101954:	00 
  101955:	80 e2 9f             	and    $0x9f,%dl
  101958:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101962:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101969:	00 
  10196a:	80 ca 80             	or     $0x80,%dl
  10196d:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10197e:	c1 e8 10             	shr    $0x10,%eax
  101981:	0f b7 d0             	movzwl %ax,%edx
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  10198e:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10198f:	ff 45 fc             	incl   -0x4(%ebp)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	3d ff 00 00 00       	cmp    $0xff,%eax
  10199a:	0f 86 2e ff ff ff    	jbe    1018ce <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019a0:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019a5:	0f b7 c0             	movzwl %ax,%eax
  1019a8:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  1019ae:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  1019b5:	08 00 
  1019b7:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019be:	24 e0                	and    $0xe0,%al
  1019c0:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019c5:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019cc:	24 1f                	and    $0x1f,%al
  1019ce:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019d3:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019da:	24 f0                	and    $0xf0,%al
  1019dc:	0c 0e                	or     $0xe,%al
  1019de:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019e3:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019ea:	24 ef                	and    $0xef,%al
  1019ec:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019f1:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019f8:	0c 60                	or     $0x60,%al
  1019fa:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019ff:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a06:	0c 80                	or     $0x80,%al
  101a08:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a0d:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a12:	c1 e8 10             	shr    $0x10,%eax
  101a15:	0f b7 c0             	movzwl %ax,%eax
  101a18:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  101a1e:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a28:	0f 01 18             	lidtl  (%eax)
}
  101a2b:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101a2c:	90                   	nop
  101a2d:	89 ec                	mov    %ebp,%esp
  101a2f:	5d                   	pop    %ebp
  101a30:	c3                   	ret    

00101a31 <trapname>:

static const char *
trapname(int trapno) {
  101a31:	55                   	push   %ebp
  101a32:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	83 f8 13             	cmp    $0x13,%eax
  101a3a:	77 0c                	ja     101a48 <trapname+0x17>
        return excnames[trapno];
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	8b 04 85 20 3d 10 00 	mov    0x103d20(,%eax,4),%eax
  101a46:	eb 18                	jmp    101a60 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a48:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a4c:	7e 0d                	jle    101a5b <trapname+0x2a>
  101a4e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a52:	7f 07                	jg     101a5b <trapname+0x2a>
        return "Hardware Interrupt";
  101a54:	b8 df 39 10 00       	mov    $0x1039df,%eax
  101a59:	eb 05                	jmp    101a60 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a5b:	b8 f2 39 10 00       	mov    $0x1039f2,%eax
}
  101a60:	5d                   	pop    %ebp
  101a61:	c3                   	ret    

00101a62 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a62:	55                   	push   %ebp
  101a63:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a65:	8b 45 08             	mov    0x8(%ebp),%eax
  101a68:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a6c:	83 f8 08             	cmp    $0x8,%eax
  101a6f:	0f 94 c0             	sete   %al
  101a72:	0f b6 c0             	movzbl %al,%eax
}
  101a75:	5d                   	pop    %ebp
  101a76:	c3                   	ret    

00101a77 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a77:	55                   	push   %ebp
  101a78:	89 e5                	mov    %esp,%ebp
  101a7a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a84:	c7 04 24 33 3a 10 00 	movl   $0x103a33,(%esp)
  101a8b:	e8 90 e8 ff ff       	call   100320 <cprintf>
    print_regs(&tf->tf_regs);
  101a90:	8b 45 08             	mov    0x8(%ebp),%eax
  101a93:	89 04 24             	mov    %eax,(%esp)
  101a96:	e8 8f 01 00 00       	call   101c2a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa6:	c7 04 24 44 3a 10 00 	movl   $0x103a44,(%esp)
  101aad:	e8 6e e8 ff ff       	call   100320 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abd:	c7 04 24 57 3a 10 00 	movl   $0x103a57,(%esp)
  101ac4:	e8 57 e8 ff ff       	call   100320 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  101acc:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad4:	c7 04 24 6a 3a 10 00 	movl   $0x103a6a,(%esp)
  101adb:	e8 40 e8 ff ff       	call   100320 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aeb:	c7 04 24 7d 3a 10 00 	movl   $0x103a7d,(%esp)
  101af2:	e8 29 e8 ff ff       	call   100320 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 30             	mov    0x30(%eax),%eax
  101afd:	89 04 24             	mov    %eax,(%esp)
  101b00:	e8 2c ff ff ff       	call   101a31 <trapname>
  101b05:	8b 55 08             	mov    0x8(%ebp),%edx
  101b08:	8b 52 30             	mov    0x30(%edx),%edx
  101b0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b13:	c7 04 24 90 3a 10 00 	movl   $0x103a90,(%esp)
  101b1a:	e8 01 e8 ff ff       	call   100320 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	8b 40 34             	mov    0x34(%eax),%eax
  101b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b29:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101b30:	e8 eb e7 ff ff       	call   100320 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b35:	8b 45 08             	mov    0x8(%ebp),%eax
  101b38:	8b 40 38             	mov    0x38(%eax),%eax
  101b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3f:	c7 04 24 b1 3a 10 00 	movl   $0x103ab1,(%esp)
  101b46:	e8 d5 e7 ff ff       	call   100320 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b56:	c7 04 24 c0 3a 10 00 	movl   $0x103ac0,(%esp)
  101b5d:	e8 be e7 ff ff       	call   100320 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b62:	8b 45 08             	mov    0x8(%ebp),%eax
  101b65:	8b 40 40             	mov    0x40(%eax),%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 d3 3a 10 00 	movl   $0x103ad3,(%esp)
  101b73:	e8 a8 e7 ff ff       	call   100320 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b7f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b86:	eb 3d                	jmp    101bc5 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	8b 50 40             	mov    0x40(%eax),%edx
  101b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b91:	21 d0                	and    %edx,%eax
  101b93:	85 c0                	test   %eax,%eax
  101b95:	74 28                	je     101bbf <print_trapframe+0x148>
  101b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b9a:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101ba1:	85 c0                	test   %eax,%eax
  101ba3:	74 1a                	je     101bbf <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba8:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb3:	c7 04 24 e2 3a 10 00 	movl   $0x103ae2,(%esp)
  101bba:	e8 61 e7 ff ff       	call   100320 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bbf:	ff 45 f4             	incl   -0xc(%ebp)
  101bc2:	d1 65 f0             	shll   -0x10(%ebp)
  101bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc8:	83 f8 17             	cmp    $0x17,%eax
  101bcb:	76 bb                	jbe    101b88 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd0:	8b 40 40             	mov    0x40(%eax),%eax
  101bd3:	c1 e8 0c             	shr    $0xc,%eax
  101bd6:	83 e0 03             	and    $0x3,%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 e6 3a 10 00 	movl   $0x103ae6,(%esp)
  101be4:	e8 37 e7 ff ff       	call   100320 <cprintf>

    if (!trap_in_kernel(tf)) {
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	89 04 24             	mov    %eax,(%esp)
  101bef:	e8 6e fe ff ff       	call   101a62 <trap_in_kernel>
  101bf4:	85 c0                	test   %eax,%eax
  101bf6:	75 2d                	jne    101c25 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 44             	mov    0x44(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101c09:	e8 12 e7 ff ff       	call   100320 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c19:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101c20:	e8 fb e6 ff ff       	call   100320 <cprintf>
    }
}
  101c25:	90                   	nop
  101c26:	89 ec                	mov    %ebp,%esp
  101c28:	5d                   	pop    %ebp
  101c29:	c3                   	ret    

00101c2a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c2a:	55                   	push   %ebp
  101c2b:	89 e5                	mov    %esp,%ebp
  101c2d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c30:	8b 45 08             	mov    0x8(%ebp),%eax
  101c33:	8b 00                	mov    (%eax),%eax
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	c7 04 24 11 3b 10 00 	movl   $0x103b11,(%esp)
  101c40:	e8 db e6 ff ff       	call   100320 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c45:	8b 45 08             	mov    0x8(%ebp),%eax
  101c48:	8b 40 04             	mov    0x4(%eax),%eax
  101c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4f:	c7 04 24 20 3b 10 00 	movl   $0x103b20,(%esp)
  101c56:	e8 c5 e6 ff ff       	call   100320 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	8b 40 08             	mov    0x8(%eax),%eax
  101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c65:	c7 04 24 2f 3b 10 00 	movl   $0x103b2f,(%esp)
  101c6c:	e8 af e6 ff ff       	call   100320 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 0c             	mov    0xc(%eax),%eax
  101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7b:	c7 04 24 3e 3b 10 00 	movl   $0x103b3e,(%esp)
  101c82:	e8 99 e6 ff ff       	call   100320 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	8b 40 10             	mov    0x10(%eax),%eax
  101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c91:	c7 04 24 4d 3b 10 00 	movl   $0x103b4d,(%esp)
  101c98:	e8 83 e6 ff ff       	call   100320 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca0:	8b 40 14             	mov    0x14(%eax),%eax
  101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca7:	c7 04 24 5c 3b 10 00 	movl   $0x103b5c,(%esp)
  101cae:	e8 6d e6 ff ff       	call   100320 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	8b 40 18             	mov    0x18(%eax),%eax
  101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbd:	c7 04 24 6b 3b 10 00 	movl   $0x103b6b,(%esp)
  101cc4:	e8 57 e6 ff ff       	call   100320 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 7a 3b 10 00 	movl   $0x103b7a,(%esp)
  101cda:	e8 41 e6 ff ff       	call   100320 <cprintf>
}
  101cdf:	90                   	nop
  101ce0:	89 ec                	mov    %ebp,%esp
  101ce2:	5d                   	pop    %ebp
  101ce3:	c3                   	ret    

00101ce4 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ce4:	55                   	push   %ebp
  101ce5:	89 e5                	mov    %esp,%ebp
  101ce7:	83 ec 28             	sub    $0x28,%esp
  101cea:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char c;

    switch (tf->tf_trapno) {
  101ced:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf0:	8b 40 30             	mov    0x30(%eax),%eax
  101cf3:	83 f8 79             	cmp    $0x79,%eax
  101cf6:	0f 84 6c 01 00 00    	je     101e68 <trap_dispatch+0x184>
  101cfc:	83 f8 79             	cmp    $0x79,%eax
  101cff:	0f 87 e0 01 00 00    	ja     101ee5 <trap_dispatch+0x201>
  101d05:	83 f8 78             	cmp    $0x78,%eax
  101d08:	0f 84 d0 00 00 00    	je     101dde <trap_dispatch+0xfa>
  101d0e:	83 f8 78             	cmp    $0x78,%eax
  101d11:	0f 87 ce 01 00 00    	ja     101ee5 <trap_dispatch+0x201>
  101d17:	83 f8 2f             	cmp    $0x2f,%eax
  101d1a:	0f 87 c5 01 00 00    	ja     101ee5 <trap_dispatch+0x201>
  101d20:	83 f8 2e             	cmp    $0x2e,%eax
  101d23:	0f 83 f1 01 00 00    	jae    101f1a <trap_dispatch+0x236>
  101d29:	83 f8 24             	cmp    $0x24,%eax
  101d2c:	74 5e                	je     101d8c <trap_dispatch+0xa8>
  101d2e:	83 f8 24             	cmp    $0x24,%eax
  101d31:	0f 87 ae 01 00 00    	ja     101ee5 <trap_dispatch+0x201>
  101d37:	83 f8 20             	cmp    $0x20,%eax
  101d3a:	74 0a                	je     101d46 <trap_dispatch+0x62>
  101d3c:	83 f8 21             	cmp    $0x21,%eax
  101d3f:	74 74                	je     101db5 <trap_dispatch+0xd1>
  101d41:	e9 9f 01 00 00       	jmp    101ee5 <trap_dispatch+0x201>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d46:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d4b:	40                   	inc    %eax
  101d4c:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0) {
  101d51:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d57:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d5c:	89 c8                	mov    %ecx,%eax
  101d5e:	f7 e2                	mul    %edx
  101d60:	c1 ea 05             	shr    $0x5,%edx
  101d63:	89 d0                	mov    %edx,%eax
  101d65:	c1 e0 02             	shl    $0x2,%eax
  101d68:	01 d0                	add    %edx,%eax
  101d6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d71:	01 d0                	add    %edx,%eax
  101d73:	c1 e0 02             	shl    $0x2,%eax
  101d76:	29 c1                	sub    %eax,%ecx
  101d78:	89 ca                	mov    %ecx,%edx
  101d7a:	85 d2                	test   %edx,%edx
  101d7c:	0f 85 9b 01 00 00    	jne    101f1d <trap_dispatch+0x239>
            print_ticks();
  101d82:	e8 f3 fa ff ff       	call   10187a <print_ticks>
        }
        break;
  101d87:	e9 91 01 00 00       	jmp    101f1d <trap_dispatch+0x239>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d8c:	e8 9f f8 ff ff       	call   101630 <cons_getc>
  101d91:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d94:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d98:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d9c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da4:	c7 04 24 89 3b 10 00 	movl   $0x103b89,(%esp)
  101dab:	e8 70 e5 ff ff       	call   100320 <cprintf>
        break;
  101db0:	e9 6f 01 00 00       	jmp    101f24 <trap_dispatch+0x240>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101db5:	e8 76 f8 ff ff       	call   101630 <cons_getc>
  101dba:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dbd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dc5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcd:	c7 04 24 9b 3b 10 00 	movl   $0x103b9b,(%esp)
  101dd4:	e8 47 e5 ff ff       	call   100320 <cprintf>
        break;
  101dd9:	e9 46 01 00 00       	jmp    101f24 <trap_dispatch+0x240>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101dde:	8b 45 08             	mov    0x8(%ebp),%eax
  101de1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de5:	83 f8 1b             	cmp    $0x1b,%eax
  101de8:	0f 84 32 01 00 00    	je     101f20 <trap_dispatch+0x23c>
            switchk2u = *tf;
  101dee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  101df1:	b8 4c 00 00 00       	mov    $0x4c,%eax
  101df6:	83 e0 fc             	and    $0xfffffffc,%eax
  101df9:	89 c3                	mov    %eax,%ebx
  101dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  101e00:	8b 14 01             	mov    (%ecx,%eax,1),%edx
  101e03:	89 90 a0 00 11 00    	mov    %edx,0x1100a0(%eax)
  101e09:	83 c0 04             	add    $0x4,%eax
  101e0c:	39 d8                	cmp    %ebx,%eax
  101e0e:	72 f0                	jb     101e00 <trap_dispatch+0x11c>
            switchk2u.tf_cs = USER_CS;
  101e10:	66 c7 05 dc 00 11 00 	movw   $0x1b,0x1100dc
  101e17:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e19:	66 c7 05 e8 00 11 00 	movw   $0x23,0x1100e8
  101e20:	23 00 
  101e22:	0f b7 05 e8 00 11 00 	movzwl 0x1100e8,%eax
  101e29:	66 a3 c8 00 11 00    	mov    %ax,0x1100c8
  101e2f:	0f b7 05 c8 00 11 00 	movzwl 0x1100c8,%eax
  101e36:	66 a3 cc 00 11 00    	mov    %ax,0x1100cc
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3f:	83 c0 44             	add    $0x44,%eax
  101e42:	a3 e4 00 11 00       	mov    %eax,0x1100e4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e47:	a1 e0 00 11 00       	mov    0x1100e0,%eax
  101e4c:	0d 00 30 00 00       	or     $0x3000,%eax
  101e51:	a3 e0 00 11 00       	mov    %eax,0x1100e0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e56:	8b 45 08             	mov    0x8(%ebp),%eax
  101e59:	83 e8 04             	sub    $0x4,%eax
  101e5c:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101e61:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e63:	e9 b8 00 00 00       	jmp    101f20 <trap_dispatch+0x23c>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e68:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e6f:	83 f8 08             	cmp    $0x8,%eax
  101e72:	0f 84 ab 00 00 00    	je     101f23 <trap_dispatch+0x23f>
            tf->tf_cs = KERNEL_CS;
  101e78:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e81:	8b 45 08             	mov    0x8(%ebp),%eax
  101e84:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e98:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9b:	8b 40 40             	mov    0x40(%eax),%eax
  101e9e:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101ea3:	89 c2                	mov    %eax,%edx
  101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea8:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101eab:	8b 45 08             	mov    0x8(%ebp),%eax
  101eae:	8b 40 44             	mov    0x44(%eax),%eax
  101eb1:	83 e8 44             	sub    $0x44,%eax
  101eb4:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101eb9:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101ebe:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ec5:	00 
  101ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  101ec9:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ecd:	89 04 24             	mov    %eax,(%esp)
  101ed0:	e8 1e 16 00 00       	call   1034f3 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ed5:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101edb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ede:	83 e8 04             	sub    $0x4,%eax
  101ee1:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ee3:	eb 3e                	jmp    101f23 <trap_dispatch+0x23f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eec:	83 e0 03             	and    $0x3,%eax
  101eef:	85 c0                	test   %eax,%eax
  101ef1:	75 31                	jne    101f24 <trap_dispatch+0x240>
            print_trapframe(tf);
  101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef6:	89 04 24             	mov    %eax,(%esp)
  101ef9:	e8 79 fb ff ff       	call   101a77 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101efe:	c7 44 24 08 aa 3b 10 	movl   $0x103baa,0x8(%esp)
  101f05:	00 
  101f06:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101f0d:	00 
  101f0e:	c7 04 24 ce 39 10 00 	movl   $0x1039ce,(%esp)
  101f15:	e8 8b ed ff ff       	call   100ca5 <__panic>
        break;
  101f1a:	90                   	nop
  101f1b:	eb 07                	jmp    101f24 <trap_dispatch+0x240>
        break;
  101f1d:	90                   	nop
  101f1e:	eb 04                	jmp    101f24 <trap_dispatch+0x240>
        break;
  101f20:	90                   	nop
  101f21:	eb 01                	jmp    101f24 <trap_dispatch+0x240>
        break;
  101f23:	90                   	nop
        }
    }
}
  101f24:	90                   	nop
  101f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101f28:	89 ec                	mov    %ebp,%esp
  101f2a:	5d                   	pop    %ebp
  101f2b:	c3                   	ret    

00101f2c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f2c:	55                   	push   %ebp
  101f2d:	89 e5                	mov    %esp,%ebp
  101f2f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f32:	8b 45 08             	mov    0x8(%ebp),%eax
  101f35:	89 04 24             	mov    %eax,(%esp)
  101f38:	e8 a7 fd ff ff       	call   101ce4 <trap_dispatch>
}
  101f3d:	90                   	nop
  101f3e:	89 ec                	mov    %ebp,%esp
  101f40:	5d                   	pop    %ebp
  101f41:	c3                   	ret    

00101f42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f42:	1e                   	push   %ds
    pushl %es
  101f43:	06                   	push   %es
    pushl %fs
  101f44:	0f a0                	push   %fs
    pushl %gs
  101f46:	0f a8                	push   %gs
    pushal
  101f48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f53:	e8 d4 ff ff ff       	call   101f2c <trap>

    # pop the pushed stack pointer
    popl %esp
  101f58:	5c                   	pop    %esp

00101f59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f5a:	0f a9                	pop    %gs
    popl %fs
  101f5c:	0f a1                	pop    %fs
    popl %es
  101f5e:	07                   	pop    %es
    popl %ds
  101f5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f60:	83 c4 08             	add    $0x8,%esp
    iret
  101f63:	cf                   	iret   

00101f64 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $0
  101f66:	6a 00                	push   $0x0
  jmp __alltraps
  101f68:	e9 d5 ff ff ff       	jmp    101f42 <__alltraps>

00101f6d <vector1>:
.globl vector1
vector1:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $1
  101f6f:	6a 01                	push   $0x1
  jmp __alltraps
  101f71:	e9 cc ff ff ff       	jmp    101f42 <__alltraps>

00101f76 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $2
  101f78:	6a 02                	push   $0x2
  jmp __alltraps
  101f7a:	e9 c3 ff ff ff       	jmp    101f42 <__alltraps>

00101f7f <vector3>:
.globl vector3
vector3:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $3
  101f81:	6a 03                	push   $0x3
  jmp __alltraps
  101f83:	e9 ba ff ff ff       	jmp    101f42 <__alltraps>

00101f88 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $4
  101f8a:	6a 04                	push   $0x4
  jmp __alltraps
  101f8c:	e9 b1 ff ff ff       	jmp    101f42 <__alltraps>

00101f91 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $5
  101f93:	6a 05                	push   $0x5
  jmp __alltraps
  101f95:	e9 a8 ff ff ff       	jmp    101f42 <__alltraps>

00101f9a <vector6>:
.globl vector6
vector6:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $6
  101f9c:	6a 06                	push   $0x6
  jmp __alltraps
  101f9e:	e9 9f ff ff ff       	jmp    101f42 <__alltraps>

00101fa3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $7
  101fa5:	6a 07                	push   $0x7
  jmp __alltraps
  101fa7:	e9 96 ff ff ff       	jmp    101f42 <__alltraps>

00101fac <vector8>:
.globl vector8
vector8:
  pushl $8
  101fac:	6a 08                	push   $0x8
  jmp __alltraps
  101fae:	e9 8f ff ff ff       	jmp    101f42 <__alltraps>

00101fb3 <vector9>:
.globl vector9
vector9:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $9
  101fb5:	6a 09                	push   $0x9
  jmp __alltraps
  101fb7:	e9 86 ff ff ff       	jmp    101f42 <__alltraps>

00101fbc <vector10>:
.globl vector10
vector10:
  pushl $10
  101fbc:	6a 0a                	push   $0xa
  jmp __alltraps
  101fbe:	e9 7f ff ff ff       	jmp    101f42 <__alltraps>

00101fc3 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fc3:	6a 0b                	push   $0xb
  jmp __alltraps
  101fc5:	e9 78 ff ff ff       	jmp    101f42 <__alltraps>

00101fca <vector12>:
.globl vector12
vector12:
  pushl $12
  101fca:	6a 0c                	push   $0xc
  jmp __alltraps
  101fcc:	e9 71 ff ff ff       	jmp    101f42 <__alltraps>

00101fd1 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fd1:	6a 0d                	push   $0xd
  jmp __alltraps
  101fd3:	e9 6a ff ff ff       	jmp    101f42 <__alltraps>

00101fd8 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fd8:	6a 0e                	push   $0xe
  jmp __alltraps
  101fda:	e9 63 ff ff ff       	jmp    101f42 <__alltraps>

00101fdf <vector15>:
.globl vector15
vector15:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $15
  101fe1:	6a 0f                	push   $0xf
  jmp __alltraps
  101fe3:	e9 5a ff ff ff       	jmp    101f42 <__alltraps>

00101fe8 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $16
  101fea:	6a 10                	push   $0x10
  jmp __alltraps
  101fec:	e9 51 ff ff ff       	jmp    101f42 <__alltraps>

00101ff1 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ff1:	6a 11                	push   $0x11
  jmp __alltraps
  101ff3:	e9 4a ff ff ff       	jmp    101f42 <__alltraps>

00101ff8 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $18
  101ffa:	6a 12                	push   $0x12
  jmp __alltraps
  101ffc:	e9 41 ff ff ff       	jmp    101f42 <__alltraps>

00102001 <vector19>:
.globl vector19
vector19:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $19
  102003:	6a 13                	push   $0x13
  jmp __alltraps
  102005:	e9 38 ff ff ff       	jmp    101f42 <__alltraps>

0010200a <vector20>:
.globl vector20
vector20:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $20
  10200c:	6a 14                	push   $0x14
  jmp __alltraps
  10200e:	e9 2f ff ff ff       	jmp    101f42 <__alltraps>

00102013 <vector21>:
.globl vector21
vector21:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $21
  102015:	6a 15                	push   $0x15
  jmp __alltraps
  102017:	e9 26 ff ff ff       	jmp    101f42 <__alltraps>

0010201c <vector22>:
.globl vector22
vector22:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $22
  10201e:	6a 16                	push   $0x16
  jmp __alltraps
  102020:	e9 1d ff ff ff       	jmp    101f42 <__alltraps>

00102025 <vector23>:
.globl vector23
vector23:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $23
  102027:	6a 17                	push   $0x17
  jmp __alltraps
  102029:	e9 14 ff ff ff       	jmp    101f42 <__alltraps>

0010202e <vector24>:
.globl vector24
vector24:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $24
  102030:	6a 18                	push   $0x18
  jmp __alltraps
  102032:	e9 0b ff ff ff       	jmp    101f42 <__alltraps>

00102037 <vector25>:
.globl vector25
vector25:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $25
  102039:	6a 19                	push   $0x19
  jmp __alltraps
  10203b:	e9 02 ff ff ff       	jmp    101f42 <__alltraps>

00102040 <vector26>:
.globl vector26
vector26:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $26
  102042:	6a 1a                	push   $0x1a
  jmp __alltraps
  102044:	e9 f9 fe ff ff       	jmp    101f42 <__alltraps>

00102049 <vector27>:
.globl vector27
vector27:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $27
  10204b:	6a 1b                	push   $0x1b
  jmp __alltraps
  10204d:	e9 f0 fe ff ff       	jmp    101f42 <__alltraps>

00102052 <vector28>:
.globl vector28
vector28:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $28
  102054:	6a 1c                	push   $0x1c
  jmp __alltraps
  102056:	e9 e7 fe ff ff       	jmp    101f42 <__alltraps>

0010205b <vector29>:
.globl vector29
vector29:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $29
  10205d:	6a 1d                	push   $0x1d
  jmp __alltraps
  10205f:	e9 de fe ff ff       	jmp    101f42 <__alltraps>

00102064 <vector30>:
.globl vector30
vector30:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $30
  102066:	6a 1e                	push   $0x1e
  jmp __alltraps
  102068:	e9 d5 fe ff ff       	jmp    101f42 <__alltraps>

0010206d <vector31>:
.globl vector31
vector31:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $31
  10206f:	6a 1f                	push   $0x1f
  jmp __alltraps
  102071:	e9 cc fe ff ff       	jmp    101f42 <__alltraps>

00102076 <vector32>:
.globl vector32
vector32:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $32
  102078:	6a 20                	push   $0x20
  jmp __alltraps
  10207a:	e9 c3 fe ff ff       	jmp    101f42 <__alltraps>

0010207f <vector33>:
.globl vector33
vector33:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $33
  102081:	6a 21                	push   $0x21
  jmp __alltraps
  102083:	e9 ba fe ff ff       	jmp    101f42 <__alltraps>

00102088 <vector34>:
.globl vector34
vector34:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $34
  10208a:	6a 22                	push   $0x22
  jmp __alltraps
  10208c:	e9 b1 fe ff ff       	jmp    101f42 <__alltraps>

00102091 <vector35>:
.globl vector35
vector35:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $35
  102093:	6a 23                	push   $0x23
  jmp __alltraps
  102095:	e9 a8 fe ff ff       	jmp    101f42 <__alltraps>

0010209a <vector36>:
.globl vector36
vector36:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $36
  10209c:	6a 24                	push   $0x24
  jmp __alltraps
  10209e:	e9 9f fe ff ff       	jmp    101f42 <__alltraps>

001020a3 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $37
  1020a5:	6a 25                	push   $0x25
  jmp __alltraps
  1020a7:	e9 96 fe ff ff       	jmp    101f42 <__alltraps>

001020ac <vector38>:
.globl vector38
vector38:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $38
  1020ae:	6a 26                	push   $0x26
  jmp __alltraps
  1020b0:	e9 8d fe ff ff       	jmp    101f42 <__alltraps>

001020b5 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $39
  1020b7:	6a 27                	push   $0x27
  jmp __alltraps
  1020b9:	e9 84 fe ff ff       	jmp    101f42 <__alltraps>

001020be <vector40>:
.globl vector40
vector40:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $40
  1020c0:	6a 28                	push   $0x28
  jmp __alltraps
  1020c2:	e9 7b fe ff ff       	jmp    101f42 <__alltraps>

001020c7 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $41
  1020c9:	6a 29                	push   $0x29
  jmp __alltraps
  1020cb:	e9 72 fe ff ff       	jmp    101f42 <__alltraps>

001020d0 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $42
  1020d2:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020d4:	e9 69 fe ff ff       	jmp    101f42 <__alltraps>

001020d9 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $43
  1020db:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020dd:	e9 60 fe ff ff       	jmp    101f42 <__alltraps>

001020e2 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $44
  1020e4:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020e6:	e9 57 fe ff ff       	jmp    101f42 <__alltraps>

001020eb <vector45>:
.globl vector45
vector45:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $45
  1020ed:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020ef:	e9 4e fe ff ff       	jmp    101f42 <__alltraps>

001020f4 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $46
  1020f6:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020f8:	e9 45 fe ff ff       	jmp    101f42 <__alltraps>

001020fd <vector47>:
.globl vector47
vector47:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $47
  1020ff:	6a 2f                	push   $0x2f
  jmp __alltraps
  102101:	e9 3c fe ff ff       	jmp    101f42 <__alltraps>

00102106 <vector48>:
.globl vector48
vector48:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $48
  102108:	6a 30                	push   $0x30
  jmp __alltraps
  10210a:	e9 33 fe ff ff       	jmp    101f42 <__alltraps>

0010210f <vector49>:
.globl vector49
vector49:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $49
  102111:	6a 31                	push   $0x31
  jmp __alltraps
  102113:	e9 2a fe ff ff       	jmp    101f42 <__alltraps>

00102118 <vector50>:
.globl vector50
vector50:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $50
  10211a:	6a 32                	push   $0x32
  jmp __alltraps
  10211c:	e9 21 fe ff ff       	jmp    101f42 <__alltraps>

00102121 <vector51>:
.globl vector51
vector51:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $51
  102123:	6a 33                	push   $0x33
  jmp __alltraps
  102125:	e9 18 fe ff ff       	jmp    101f42 <__alltraps>

0010212a <vector52>:
.globl vector52
vector52:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $52
  10212c:	6a 34                	push   $0x34
  jmp __alltraps
  10212e:	e9 0f fe ff ff       	jmp    101f42 <__alltraps>

00102133 <vector53>:
.globl vector53
vector53:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $53
  102135:	6a 35                	push   $0x35
  jmp __alltraps
  102137:	e9 06 fe ff ff       	jmp    101f42 <__alltraps>

0010213c <vector54>:
.globl vector54
vector54:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $54
  10213e:	6a 36                	push   $0x36
  jmp __alltraps
  102140:	e9 fd fd ff ff       	jmp    101f42 <__alltraps>

00102145 <vector55>:
.globl vector55
vector55:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $55
  102147:	6a 37                	push   $0x37
  jmp __alltraps
  102149:	e9 f4 fd ff ff       	jmp    101f42 <__alltraps>

0010214e <vector56>:
.globl vector56
vector56:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $56
  102150:	6a 38                	push   $0x38
  jmp __alltraps
  102152:	e9 eb fd ff ff       	jmp    101f42 <__alltraps>

00102157 <vector57>:
.globl vector57
vector57:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $57
  102159:	6a 39                	push   $0x39
  jmp __alltraps
  10215b:	e9 e2 fd ff ff       	jmp    101f42 <__alltraps>

00102160 <vector58>:
.globl vector58
vector58:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $58
  102162:	6a 3a                	push   $0x3a
  jmp __alltraps
  102164:	e9 d9 fd ff ff       	jmp    101f42 <__alltraps>

00102169 <vector59>:
.globl vector59
vector59:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $59
  10216b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10216d:	e9 d0 fd ff ff       	jmp    101f42 <__alltraps>

00102172 <vector60>:
.globl vector60
vector60:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $60
  102174:	6a 3c                	push   $0x3c
  jmp __alltraps
  102176:	e9 c7 fd ff ff       	jmp    101f42 <__alltraps>

0010217b <vector61>:
.globl vector61
vector61:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $61
  10217d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10217f:	e9 be fd ff ff       	jmp    101f42 <__alltraps>

00102184 <vector62>:
.globl vector62
vector62:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $62
  102186:	6a 3e                	push   $0x3e
  jmp __alltraps
  102188:	e9 b5 fd ff ff       	jmp    101f42 <__alltraps>

0010218d <vector63>:
.globl vector63
vector63:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $63
  10218f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102191:	e9 ac fd ff ff       	jmp    101f42 <__alltraps>

00102196 <vector64>:
.globl vector64
vector64:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $64
  102198:	6a 40                	push   $0x40
  jmp __alltraps
  10219a:	e9 a3 fd ff ff       	jmp    101f42 <__alltraps>

0010219f <vector65>:
.globl vector65
vector65:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $65
  1021a1:	6a 41                	push   $0x41
  jmp __alltraps
  1021a3:	e9 9a fd ff ff       	jmp    101f42 <__alltraps>

001021a8 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $66
  1021aa:	6a 42                	push   $0x42
  jmp __alltraps
  1021ac:	e9 91 fd ff ff       	jmp    101f42 <__alltraps>

001021b1 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $67
  1021b3:	6a 43                	push   $0x43
  jmp __alltraps
  1021b5:	e9 88 fd ff ff       	jmp    101f42 <__alltraps>

001021ba <vector68>:
.globl vector68
vector68:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $68
  1021bc:	6a 44                	push   $0x44
  jmp __alltraps
  1021be:	e9 7f fd ff ff       	jmp    101f42 <__alltraps>

001021c3 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $69
  1021c5:	6a 45                	push   $0x45
  jmp __alltraps
  1021c7:	e9 76 fd ff ff       	jmp    101f42 <__alltraps>

001021cc <vector70>:
.globl vector70
vector70:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $70
  1021ce:	6a 46                	push   $0x46
  jmp __alltraps
  1021d0:	e9 6d fd ff ff       	jmp    101f42 <__alltraps>

001021d5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $71
  1021d7:	6a 47                	push   $0x47
  jmp __alltraps
  1021d9:	e9 64 fd ff ff       	jmp    101f42 <__alltraps>

001021de <vector72>:
.globl vector72
vector72:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $72
  1021e0:	6a 48                	push   $0x48
  jmp __alltraps
  1021e2:	e9 5b fd ff ff       	jmp    101f42 <__alltraps>

001021e7 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $73
  1021e9:	6a 49                	push   $0x49
  jmp __alltraps
  1021eb:	e9 52 fd ff ff       	jmp    101f42 <__alltraps>

001021f0 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $74
  1021f2:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021f4:	e9 49 fd ff ff       	jmp    101f42 <__alltraps>

001021f9 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $75
  1021fb:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021fd:	e9 40 fd ff ff       	jmp    101f42 <__alltraps>

00102202 <vector76>:
.globl vector76
vector76:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $76
  102204:	6a 4c                	push   $0x4c
  jmp __alltraps
  102206:	e9 37 fd ff ff       	jmp    101f42 <__alltraps>

0010220b <vector77>:
.globl vector77
vector77:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $77
  10220d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10220f:	e9 2e fd ff ff       	jmp    101f42 <__alltraps>

00102214 <vector78>:
.globl vector78
vector78:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $78
  102216:	6a 4e                	push   $0x4e
  jmp __alltraps
  102218:	e9 25 fd ff ff       	jmp    101f42 <__alltraps>

0010221d <vector79>:
.globl vector79
vector79:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $79
  10221f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102221:	e9 1c fd ff ff       	jmp    101f42 <__alltraps>

00102226 <vector80>:
.globl vector80
vector80:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $80
  102228:	6a 50                	push   $0x50
  jmp __alltraps
  10222a:	e9 13 fd ff ff       	jmp    101f42 <__alltraps>

0010222f <vector81>:
.globl vector81
vector81:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $81
  102231:	6a 51                	push   $0x51
  jmp __alltraps
  102233:	e9 0a fd ff ff       	jmp    101f42 <__alltraps>

00102238 <vector82>:
.globl vector82
vector82:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $82
  10223a:	6a 52                	push   $0x52
  jmp __alltraps
  10223c:	e9 01 fd ff ff       	jmp    101f42 <__alltraps>

00102241 <vector83>:
.globl vector83
vector83:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $83
  102243:	6a 53                	push   $0x53
  jmp __alltraps
  102245:	e9 f8 fc ff ff       	jmp    101f42 <__alltraps>

0010224a <vector84>:
.globl vector84
vector84:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $84
  10224c:	6a 54                	push   $0x54
  jmp __alltraps
  10224e:	e9 ef fc ff ff       	jmp    101f42 <__alltraps>

00102253 <vector85>:
.globl vector85
vector85:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $85
  102255:	6a 55                	push   $0x55
  jmp __alltraps
  102257:	e9 e6 fc ff ff       	jmp    101f42 <__alltraps>

0010225c <vector86>:
.globl vector86
vector86:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $86
  10225e:	6a 56                	push   $0x56
  jmp __alltraps
  102260:	e9 dd fc ff ff       	jmp    101f42 <__alltraps>

00102265 <vector87>:
.globl vector87
vector87:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $87
  102267:	6a 57                	push   $0x57
  jmp __alltraps
  102269:	e9 d4 fc ff ff       	jmp    101f42 <__alltraps>

0010226e <vector88>:
.globl vector88
vector88:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $88
  102270:	6a 58                	push   $0x58
  jmp __alltraps
  102272:	e9 cb fc ff ff       	jmp    101f42 <__alltraps>

00102277 <vector89>:
.globl vector89
vector89:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $89
  102279:	6a 59                	push   $0x59
  jmp __alltraps
  10227b:	e9 c2 fc ff ff       	jmp    101f42 <__alltraps>

00102280 <vector90>:
.globl vector90
vector90:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $90
  102282:	6a 5a                	push   $0x5a
  jmp __alltraps
  102284:	e9 b9 fc ff ff       	jmp    101f42 <__alltraps>

00102289 <vector91>:
.globl vector91
vector91:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $91
  10228b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10228d:	e9 b0 fc ff ff       	jmp    101f42 <__alltraps>

00102292 <vector92>:
.globl vector92
vector92:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $92
  102294:	6a 5c                	push   $0x5c
  jmp __alltraps
  102296:	e9 a7 fc ff ff       	jmp    101f42 <__alltraps>

0010229b <vector93>:
.globl vector93
vector93:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $93
  10229d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10229f:	e9 9e fc ff ff       	jmp    101f42 <__alltraps>

001022a4 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $94
  1022a6:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022a8:	e9 95 fc ff ff       	jmp    101f42 <__alltraps>

001022ad <vector95>:
.globl vector95
vector95:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $95
  1022af:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022b1:	e9 8c fc ff ff       	jmp    101f42 <__alltraps>

001022b6 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $96
  1022b8:	6a 60                	push   $0x60
  jmp __alltraps
  1022ba:	e9 83 fc ff ff       	jmp    101f42 <__alltraps>

001022bf <vector97>:
.globl vector97
vector97:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $97
  1022c1:	6a 61                	push   $0x61
  jmp __alltraps
  1022c3:	e9 7a fc ff ff       	jmp    101f42 <__alltraps>

001022c8 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $98
  1022ca:	6a 62                	push   $0x62
  jmp __alltraps
  1022cc:	e9 71 fc ff ff       	jmp    101f42 <__alltraps>

001022d1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $99
  1022d3:	6a 63                	push   $0x63
  jmp __alltraps
  1022d5:	e9 68 fc ff ff       	jmp    101f42 <__alltraps>

001022da <vector100>:
.globl vector100
vector100:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $100
  1022dc:	6a 64                	push   $0x64
  jmp __alltraps
  1022de:	e9 5f fc ff ff       	jmp    101f42 <__alltraps>

001022e3 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $101
  1022e5:	6a 65                	push   $0x65
  jmp __alltraps
  1022e7:	e9 56 fc ff ff       	jmp    101f42 <__alltraps>

001022ec <vector102>:
.globl vector102
vector102:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $102
  1022ee:	6a 66                	push   $0x66
  jmp __alltraps
  1022f0:	e9 4d fc ff ff       	jmp    101f42 <__alltraps>

001022f5 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $103
  1022f7:	6a 67                	push   $0x67
  jmp __alltraps
  1022f9:	e9 44 fc ff ff       	jmp    101f42 <__alltraps>

001022fe <vector104>:
.globl vector104
vector104:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $104
  102300:	6a 68                	push   $0x68
  jmp __alltraps
  102302:	e9 3b fc ff ff       	jmp    101f42 <__alltraps>

00102307 <vector105>:
.globl vector105
vector105:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $105
  102309:	6a 69                	push   $0x69
  jmp __alltraps
  10230b:	e9 32 fc ff ff       	jmp    101f42 <__alltraps>

00102310 <vector106>:
.globl vector106
vector106:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $106
  102312:	6a 6a                	push   $0x6a
  jmp __alltraps
  102314:	e9 29 fc ff ff       	jmp    101f42 <__alltraps>

00102319 <vector107>:
.globl vector107
vector107:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $107
  10231b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10231d:	e9 20 fc ff ff       	jmp    101f42 <__alltraps>

00102322 <vector108>:
.globl vector108
vector108:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $108
  102324:	6a 6c                	push   $0x6c
  jmp __alltraps
  102326:	e9 17 fc ff ff       	jmp    101f42 <__alltraps>

0010232b <vector109>:
.globl vector109
vector109:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $109
  10232d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10232f:	e9 0e fc ff ff       	jmp    101f42 <__alltraps>

00102334 <vector110>:
.globl vector110
vector110:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $110
  102336:	6a 6e                	push   $0x6e
  jmp __alltraps
  102338:	e9 05 fc ff ff       	jmp    101f42 <__alltraps>

0010233d <vector111>:
.globl vector111
vector111:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $111
  10233f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102341:	e9 fc fb ff ff       	jmp    101f42 <__alltraps>

00102346 <vector112>:
.globl vector112
vector112:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $112
  102348:	6a 70                	push   $0x70
  jmp __alltraps
  10234a:	e9 f3 fb ff ff       	jmp    101f42 <__alltraps>

0010234f <vector113>:
.globl vector113
vector113:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $113
  102351:	6a 71                	push   $0x71
  jmp __alltraps
  102353:	e9 ea fb ff ff       	jmp    101f42 <__alltraps>

00102358 <vector114>:
.globl vector114
vector114:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $114
  10235a:	6a 72                	push   $0x72
  jmp __alltraps
  10235c:	e9 e1 fb ff ff       	jmp    101f42 <__alltraps>

00102361 <vector115>:
.globl vector115
vector115:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $115
  102363:	6a 73                	push   $0x73
  jmp __alltraps
  102365:	e9 d8 fb ff ff       	jmp    101f42 <__alltraps>

0010236a <vector116>:
.globl vector116
vector116:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $116
  10236c:	6a 74                	push   $0x74
  jmp __alltraps
  10236e:	e9 cf fb ff ff       	jmp    101f42 <__alltraps>

00102373 <vector117>:
.globl vector117
vector117:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $117
  102375:	6a 75                	push   $0x75
  jmp __alltraps
  102377:	e9 c6 fb ff ff       	jmp    101f42 <__alltraps>

0010237c <vector118>:
.globl vector118
vector118:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $118
  10237e:	6a 76                	push   $0x76
  jmp __alltraps
  102380:	e9 bd fb ff ff       	jmp    101f42 <__alltraps>

00102385 <vector119>:
.globl vector119
vector119:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $119
  102387:	6a 77                	push   $0x77
  jmp __alltraps
  102389:	e9 b4 fb ff ff       	jmp    101f42 <__alltraps>

0010238e <vector120>:
.globl vector120
vector120:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $120
  102390:	6a 78                	push   $0x78
  jmp __alltraps
  102392:	e9 ab fb ff ff       	jmp    101f42 <__alltraps>

00102397 <vector121>:
.globl vector121
vector121:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $121
  102399:	6a 79                	push   $0x79
  jmp __alltraps
  10239b:	e9 a2 fb ff ff       	jmp    101f42 <__alltraps>

001023a0 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $122
  1023a2:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023a4:	e9 99 fb ff ff       	jmp    101f42 <__alltraps>

001023a9 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $123
  1023ab:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023ad:	e9 90 fb ff ff       	jmp    101f42 <__alltraps>

001023b2 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $124
  1023b4:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023b6:	e9 87 fb ff ff       	jmp    101f42 <__alltraps>

001023bb <vector125>:
.globl vector125
vector125:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $125
  1023bd:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023bf:	e9 7e fb ff ff       	jmp    101f42 <__alltraps>

001023c4 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $126
  1023c6:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023c8:	e9 75 fb ff ff       	jmp    101f42 <__alltraps>

001023cd <vector127>:
.globl vector127
vector127:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $127
  1023cf:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023d1:	e9 6c fb ff ff       	jmp    101f42 <__alltraps>

001023d6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $128
  1023d8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023dd:	e9 60 fb ff ff       	jmp    101f42 <__alltraps>

001023e2 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $129
  1023e4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023e9:	e9 54 fb ff ff       	jmp    101f42 <__alltraps>

001023ee <vector130>:
.globl vector130
vector130:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $130
  1023f0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023f5:	e9 48 fb ff ff       	jmp    101f42 <__alltraps>

001023fa <vector131>:
.globl vector131
vector131:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $131
  1023fc:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102401:	e9 3c fb ff ff       	jmp    101f42 <__alltraps>

00102406 <vector132>:
.globl vector132
vector132:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $132
  102408:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10240d:	e9 30 fb ff ff       	jmp    101f42 <__alltraps>

00102412 <vector133>:
.globl vector133
vector133:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $133
  102414:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102419:	e9 24 fb ff ff       	jmp    101f42 <__alltraps>

0010241e <vector134>:
.globl vector134
vector134:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $134
  102420:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102425:	e9 18 fb ff ff       	jmp    101f42 <__alltraps>

0010242a <vector135>:
.globl vector135
vector135:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $135
  10242c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102431:	e9 0c fb ff ff       	jmp    101f42 <__alltraps>

00102436 <vector136>:
.globl vector136
vector136:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $136
  102438:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10243d:	e9 00 fb ff ff       	jmp    101f42 <__alltraps>

00102442 <vector137>:
.globl vector137
vector137:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $137
  102444:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102449:	e9 f4 fa ff ff       	jmp    101f42 <__alltraps>

0010244e <vector138>:
.globl vector138
vector138:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $138
  102450:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102455:	e9 e8 fa ff ff       	jmp    101f42 <__alltraps>

0010245a <vector139>:
.globl vector139
vector139:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $139
  10245c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102461:	e9 dc fa ff ff       	jmp    101f42 <__alltraps>

00102466 <vector140>:
.globl vector140
vector140:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $140
  102468:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10246d:	e9 d0 fa ff ff       	jmp    101f42 <__alltraps>

00102472 <vector141>:
.globl vector141
vector141:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $141
  102474:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102479:	e9 c4 fa ff ff       	jmp    101f42 <__alltraps>

0010247e <vector142>:
.globl vector142
vector142:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $142
  102480:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102485:	e9 b8 fa ff ff       	jmp    101f42 <__alltraps>

0010248a <vector143>:
.globl vector143
vector143:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $143
  10248c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102491:	e9 ac fa ff ff       	jmp    101f42 <__alltraps>

00102496 <vector144>:
.globl vector144
vector144:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $144
  102498:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10249d:	e9 a0 fa ff ff       	jmp    101f42 <__alltraps>

001024a2 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $145
  1024a4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024a9:	e9 94 fa ff ff       	jmp    101f42 <__alltraps>

001024ae <vector146>:
.globl vector146
vector146:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $146
  1024b0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024b5:	e9 88 fa ff ff       	jmp    101f42 <__alltraps>

001024ba <vector147>:
.globl vector147
vector147:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $147
  1024bc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024c1:	e9 7c fa ff ff       	jmp    101f42 <__alltraps>

001024c6 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $148
  1024c8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024cd:	e9 70 fa ff ff       	jmp    101f42 <__alltraps>

001024d2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $149
  1024d4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024d9:	e9 64 fa ff ff       	jmp    101f42 <__alltraps>

001024de <vector150>:
.globl vector150
vector150:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $150
  1024e0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024e5:	e9 58 fa ff ff       	jmp    101f42 <__alltraps>

001024ea <vector151>:
.globl vector151
vector151:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $151
  1024ec:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024f1:	e9 4c fa ff ff       	jmp    101f42 <__alltraps>

001024f6 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $152
  1024f8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024fd:	e9 40 fa ff ff       	jmp    101f42 <__alltraps>

00102502 <vector153>:
.globl vector153
vector153:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $153
  102504:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102509:	e9 34 fa ff ff       	jmp    101f42 <__alltraps>

0010250e <vector154>:
.globl vector154
vector154:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $154
  102510:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102515:	e9 28 fa ff ff       	jmp    101f42 <__alltraps>

0010251a <vector155>:
.globl vector155
vector155:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $155
  10251c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102521:	e9 1c fa ff ff       	jmp    101f42 <__alltraps>

00102526 <vector156>:
.globl vector156
vector156:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $156
  102528:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10252d:	e9 10 fa ff ff       	jmp    101f42 <__alltraps>

00102532 <vector157>:
.globl vector157
vector157:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $157
  102534:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102539:	e9 04 fa ff ff       	jmp    101f42 <__alltraps>

0010253e <vector158>:
.globl vector158
vector158:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $158
  102540:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102545:	e9 f8 f9 ff ff       	jmp    101f42 <__alltraps>

0010254a <vector159>:
.globl vector159
vector159:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $159
  10254c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102551:	e9 ec f9 ff ff       	jmp    101f42 <__alltraps>

00102556 <vector160>:
.globl vector160
vector160:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $160
  102558:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10255d:	e9 e0 f9 ff ff       	jmp    101f42 <__alltraps>

00102562 <vector161>:
.globl vector161
vector161:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $161
  102564:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102569:	e9 d4 f9 ff ff       	jmp    101f42 <__alltraps>

0010256e <vector162>:
.globl vector162
vector162:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $162
  102570:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102575:	e9 c8 f9 ff ff       	jmp    101f42 <__alltraps>

0010257a <vector163>:
.globl vector163
vector163:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $163
  10257c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102581:	e9 bc f9 ff ff       	jmp    101f42 <__alltraps>

00102586 <vector164>:
.globl vector164
vector164:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $164
  102588:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10258d:	e9 b0 f9 ff ff       	jmp    101f42 <__alltraps>

00102592 <vector165>:
.globl vector165
vector165:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $165
  102594:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102599:	e9 a4 f9 ff ff       	jmp    101f42 <__alltraps>

0010259e <vector166>:
.globl vector166
vector166:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $166
  1025a0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025a5:	e9 98 f9 ff ff       	jmp    101f42 <__alltraps>

001025aa <vector167>:
.globl vector167
vector167:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $167
  1025ac:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025b1:	e9 8c f9 ff ff       	jmp    101f42 <__alltraps>

001025b6 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $168
  1025b8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025bd:	e9 80 f9 ff ff       	jmp    101f42 <__alltraps>

001025c2 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $169
  1025c4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025c9:	e9 74 f9 ff ff       	jmp    101f42 <__alltraps>

001025ce <vector170>:
.globl vector170
vector170:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $170
  1025d0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025d5:	e9 68 f9 ff ff       	jmp    101f42 <__alltraps>

001025da <vector171>:
.globl vector171
vector171:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $171
  1025dc:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025e1:	e9 5c f9 ff ff       	jmp    101f42 <__alltraps>

001025e6 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $172
  1025e8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025ed:	e9 50 f9 ff ff       	jmp    101f42 <__alltraps>

001025f2 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $173
  1025f4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025f9:	e9 44 f9 ff ff       	jmp    101f42 <__alltraps>

001025fe <vector174>:
.globl vector174
vector174:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $174
  102600:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102605:	e9 38 f9 ff ff       	jmp    101f42 <__alltraps>

0010260a <vector175>:
.globl vector175
vector175:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $175
  10260c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102611:	e9 2c f9 ff ff       	jmp    101f42 <__alltraps>

00102616 <vector176>:
.globl vector176
vector176:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $176
  102618:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10261d:	e9 20 f9 ff ff       	jmp    101f42 <__alltraps>

00102622 <vector177>:
.globl vector177
vector177:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $177
  102624:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102629:	e9 14 f9 ff ff       	jmp    101f42 <__alltraps>

0010262e <vector178>:
.globl vector178
vector178:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $178
  102630:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102635:	e9 08 f9 ff ff       	jmp    101f42 <__alltraps>

0010263a <vector179>:
.globl vector179
vector179:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $179
  10263c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102641:	e9 fc f8 ff ff       	jmp    101f42 <__alltraps>

00102646 <vector180>:
.globl vector180
vector180:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $180
  102648:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10264d:	e9 f0 f8 ff ff       	jmp    101f42 <__alltraps>

00102652 <vector181>:
.globl vector181
vector181:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $181
  102654:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102659:	e9 e4 f8 ff ff       	jmp    101f42 <__alltraps>

0010265e <vector182>:
.globl vector182
vector182:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $182
  102660:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102665:	e9 d8 f8 ff ff       	jmp    101f42 <__alltraps>

0010266a <vector183>:
.globl vector183
vector183:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $183
  10266c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102671:	e9 cc f8 ff ff       	jmp    101f42 <__alltraps>

00102676 <vector184>:
.globl vector184
vector184:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $184
  102678:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10267d:	e9 c0 f8 ff ff       	jmp    101f42 <__alltraps>

00102682 <vector185>:
.globl vector185
vector185:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $185
  102684:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102689:	e9 b4 f8 ff ff       	jmp    101f42 <__alltraps>

0010268e <vector186>:
.globl vector186
vector186:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $186
  102690:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102695:	e9 a8 f8 ff ff       	jmp    101f42 <__alltraps>

0010269a <vector187>:
.globl vector187
vector187:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $187
  10269c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026a1:	e9 9c f8 ff ff       	jmp    101f42 <__alltraps>

001026a6 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $188
  1026a8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026ad:	e9 90 f8 ff ff       	jmp    101f42 <__alltraps>

001026b2 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $189
  1026b4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026b9:	e9 84 f8 ff ff       	jmp    101f42 <__alltraps>

001026be <vector190>:
.globl vector190
vector190:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $190
  1026c0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026c5:	e9 78 f8 ff ff       	jmp    101f42 <__alltraps>

001026ca <vector191>:
.globl vector191
vector191:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $191
  1026cc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026d1:	e9 6c f8 ff ff       	jmp    101f42 <__alltraps>

001026d6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $192
  1026d8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026dd:	e9 60 f8 ff ff       	jmp    101f42 <__alltraps>

001026e2 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $193
  1026e4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026e9:	e9 54 f8 ff ff       	jmp    101f42 <__alltraps>

001026ee <vector194>:
.globl vector194
vector194:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $194
  1026f0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026f5:	e9 48 f8 ff ff       	jmp    101f42 <__alltraps>

001026fa <vector195>:
.globl vector195
vector195:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $195
  1026fc:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102701:	e9 3c f8 ff ff       	jmp    101f42 <__alltraps>

00102706 <vector196>:
.globl vector196
vector196:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $196
  102708:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10270d:	e9 30 f8 ff ff       	jmp    101f42 <__alltraps>

00102712 <vector197>:
.globl vector197
vector197:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $197
  102714:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102719:	e9 24 f8 ff ff       	jmp    101f42 <__alltraps>

0010271e <vector198>:
.globl vector198
vector198:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $198
  102720:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102725:	e9 18 f8 ff ff       	jmp    101f42 <__alltraps>

0010272a <vector199>:
.globl vector199
vector199:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $199
  10272c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102731:	e9 0c f8 ff ff       	jmp    101f42 <__alltraps>

00102736 <vector200>:
.globl vector200
vector200:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $200
  102738:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10273d:	e9 00 f8 ff ff       	jmp    101f42 <__alltraps>

00102742 <vector201>:
.globl vector201
vector201:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $201
  102744:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102749:	e9 f4 f7 ff ff       	jmp    101f42 <__alltraps>

0010274e <vector202>:
.globl vector202
vector202:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $202
  102750:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102755:	e9 e8 f7 ff ff       	jmp    101f42 <__alltraps>

0010275a <vector203>:
.globl vector203
vector203:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $203
  10275c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102761:	e9 dc f7 ff ff       	jmp    101f42 <__alltraps>

00102766 <vector204>:
.globl vector204
vector204:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $204
  102768:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10276d:	e9 d0 f7 ff ff       	jmp    101f42 <__alltraps>

00102772 <vector205>:
.globl vector205
vector205:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $205
  102774:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102779:	e9 c4 f7 ff ff       	jmp    101f42 <__alltraps>

0010277e <vector206>:
.globl vector206
vector206:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $206
  102780:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102785:	e9 b8 f7 ff ff       	jmp    101f42 <__alltraps>

0010278a <vector207>:
.globl vector207
vector207:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $207
  10278c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102791:	e9 ac f7 ff ff       	jmp    101f42 <__alltraps>

00102796 <vector208>:
.globl vector208
vector208:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $208
  102798:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10279d:	e9 a0 f7 ff ff       	jmp    101f42 <__alltraps>

001027a2 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $209
  1027a4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027a9:	e9 94 f7 ff ff       	jmp    101f42 <__alltraps>

001027ae <vector210>:
.globl vector210
vector210:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $210
  1027b0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027b5:	e9 88 f7 ff ff       	jmp    101f42 <__alltraps>

001027ba <vector211>:
.globl vector211
vector211:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $211
  1027bc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027c1:	e9 7c f7 ff ff       	jmp    101f42 <__alltraps>

001027c6 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $212
  1027c8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027cd:	e9 70 f7 ff ff       	jmp    101f42 <__alltraps>

001027d2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $213
  1027d4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027d9:	e9 64 f7 ff ff       	jmp    101f42 <__alltraps>

001027de <vector214>:
.globl vector214
vector214:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $214
  1027e0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027e5:	e9 58 f7 ff ff       	jmp    101f42 <__alltraps>

001027ea <vector215>:
.globl vector215
vector215:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $215
  1027ec:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027f1:	e9 4c f7 ff ff       	jmp    101f42 <__alltraps>

001027f6 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $216
  1027f8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027fd:	e9 40 f7 ff ff       	jmp    101f42 <__alltraps>

00102802 <vector217>:
.globl vector217
vector217:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $217
  102804:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102809:	e9 34 f7 ff ff       	jmp    101f42 <__alltraps>

0010280e <vector218>:
.globl vector218
vector218:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $218
  102810:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102815:	e9 28 f7 ff ff       	jmp    101f42 <__alltraps>

0010281a <vector219>:
.globl vector219
vector219:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $219
  10281c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102821:	e9 1c f7 ff ff       	jmp    101f42 <__alltraps>

00102826 <vector220>:
.globl vector220
vector220:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $220
  102828:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10282d:	e9 10 f7 ff ff       	jmp    101f42 <__alltraps>

00102832 <vector221>:
.globl vector221
vector221:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $221
  102834:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102839:	e9 04 f7 ff ff       	jmp    101f42 <__alltraps>

0010283e <vector222>:
.globl vector222
vector222:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $222
  102840:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102845:	e9 f8 f6 ff ff       	jmp    101f42 <__alltraps>

0010284a <vector223>:
.globl vector223
vector223:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $223
  10284c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102851:	e9 ec f6 ff ff       	jmp    101f42 <__alltraps>

00102856 <vector224>:
.globl vector224
vector224:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $224
  102858:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10285d:	e9 e0 f6 ff ff       	jmp    101f42 <__alltraps>

00102862 <vector225>:
.globl vector225
vector225:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $225
  102864:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102869:	e9 d4 f6 ff ff       	jmp    101f42 <__alltraps>

0010286e <vector226>:
.globl vector226
vector226:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $226
  102870:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102875:	e9 c8 f6 ff ff       	jmp    101f42 <__alltraps>

0010287a <vector227>:
.globl vector227
vector227:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $227
  10287c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102881:	e9 bc f6 ff ff       	jmp    101f42 <__alltraps>

00102886 <vector228>:
.globl vector228
vector228:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $228
  102888:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10288d:	e9 b0 f6 ff ff       	jmp    101f42 <__alltraps>

00102892 <vector229>:
.globl vector229
vector229:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $229
  102894:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102899:	e9 a4 f6 ff ff       	jmp    101f42 <__alltraps>

0010289e <vector230>:
.globl vector230
vector230:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $230
  1028a0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028a5:	e9 98 f6 ff ff       	jmp    101f42 <__alltraps>

001028aa <vector231>:
.globl vector231
vector231:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $231
  1028ac:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028b1:	e9 8c f6 ff ff       	jmp    101f42 <__alltraps>

001028b6 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $232
  1028b8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028bd:	e9 80 f6 ff ff       	jmp    101f42 <__alltraps>

001028c2 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $233
  1028c4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028c9:	e9 74 f6 ff ff       	jmp    101f42 <__alltraps>

001028ce <vector234>:
.globl vector234
vector234:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $234
  1028d0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028d5:	e9 68 f6 ff ff       	jmp    101f42 <__alltraps>

001028da <vector235>:
.globl vector235
vector235:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $235
  1028dc:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028e1:	e9 5c f6 ff ff       	jmp    101f42 <__alltraps>

001028e6 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $236
  1028e8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028ed:	e9 50 f6 ff ff       	jmp    101f42 <__alltraps>

001028f2 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $237
  1028f4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028f9:	e9 44 f6 ff ff       	jmp    101f42 <__alltraps>

001028fe <vector238>:
.globl vector238
vector238:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $238
  102900:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102905:	e9 38 f6 ff ff       	jmp    101f42 <__alltraps>

0010290a <vector239>:
.globl vector239
vector239:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $239
  10290c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102911:	e9 2c f6 ff ff       	jmp    101f42 <__alltraps>

00102916 <vector240>:
.globl vector240
vector240:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $240
  102918:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10291d:	e9 20 f6 ff ff       	jmp    101f42 <__alltraps>

00102922 <vector241>:
.globl vector241
vector241:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $241
  102924:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102929:	e9 14 f6 ff ff       	jmp    101f42 <__alltraps>

0010292e <vector242>:
.globl vector242
vector242:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $242
  102930:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102935:	e9 08 f6 ff ff       	jmp    101f42 <__alltraps>

0010293a <vector243>:
.globl vector243
vector243:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $243
  10293c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102941:	e9 fc f5 ff ff       	jmp    101f42 <__alltraps>

00102946 <vector244>:
.globl vector244
vector244:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $244
  102948:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10294d:	e9 f0 f5 ff ff       	jmp    101f42 <__alltraps>

00102952 <vector245>:
.globl vector245
vector245:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $245
  102954:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102959:	e9 e4 f5 ff ff       	jmp    101f42 <__alltraps>

0010295e <vector246>:
.globl vector246
vector246:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $246
  102960:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102965:	e9 d8 f5 ff ff       	jmp    101f42 <__alltraps>

0010296a <vector247>:
.globl vector247
vector247:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $247
  10296c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102971:	e9 cc f5 ff ff       	jmp    101f42 <__alltraps>

00102976 <vector248>:
.globl vector248
vector248:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $248
  102978:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10297d:	e9 c0 f5 ff ff       	jmp    101f42 <__alltraps>

00102982 <vector249>:
.globl vector249
vector249:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $249
  102984:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102989:	e9 b4 f5 ff ff       	jmp    101f42 <__alltraps>

0010298e <vector250>:
.globl vector250
vector250:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $250
  102990:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102995:	e9 a8 f5 ff ff       	jmp    101f42 <__alltraps>

0010299a <vector251>:
.globl vector251
vector251:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $251
  10299c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029a1:	e9 9c f5 ff ff       	jmp    101f42 <__alltraps>

001029a6 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $252
  1029a8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029ad:	e9 90 f5 ff ff       	jmp    101f42 <__alltraps>

001029b2 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $253
  1029b4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029b9:	e9 84 f5 ff ff       	jmp    101f42 <__alltraps>

001029be <vector254>:
.globl vector254
vector254:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $254
  1029c0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029c5:	e9 78 f5 ff ff       	jmp    101f42 <__alltraps>

001029ca <vector255>:
.globl vector255
vector255:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $255
  1029cc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029d1:	e9 6c f5 ff ff       	jmp    101f42 <__alltraps>

001029d6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029d6:	55                   	push   %ebp
  1029d7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029dc:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029df:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029e6:	b8 23 00 00 00       	mov    $0x23,%eax
  1029eb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029ed:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f2:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029f4:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f9:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029fb:	b8 10 00 00 00       	mov    $0x10,%eax
  102a00:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a02:	ea 09 2a 10 00 08 00 	ljmp   $0x8,$0x102a09
}
  102a09:	90                   	nop
  102a0a:	5d                   	pop    %ebp
  102a0b:	c3                   	ret    

00102a0c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a0c:	55                   	push   %ebp
  102a0d:	89 e5                	mov    %esp,%ebp
  102a0f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a12:	b8 00 09 11 00       	mov    $0x110900,%eax
  102a17:	05 00 04 00 00       	add    $0x400,%eax
  102a1c:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  102a21:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  102a28:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a2a:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102a31:	68 00 
  102a33:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a38:	0f b7 c0             	movzwl %ax,%eax
  102a3b:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102a41:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a46:	c1 e8 10             	shr    $0x10,%eax
  102a49:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102a4e:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a55:	24 f0                	and    $0xf0,%al
  102a57:	0c 09                	or     $0x9,%al
  102a59:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a5e:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a65:	0c 10                	or     $0x10,%al
  102a67:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a6c:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a73:	24 9f                	and    $0x9f,%al
  102a75:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a7a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a81:	0c 80                	or     $0x80,%al
  102a83:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a88:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a8f:	24 f0                	and    $0xf0,%al
  102a91:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a96:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a9d:	24 ef                	and    $0xef,%al
  102a9f:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102aa4:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102aab:	24 df                	and    $0xdf,%al
  102aad:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ab2:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ab9:	0c 40                	or     $0x40,%al
  102abb:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ac0:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ac7:	24 7f                	and    $0x7f,%al
  102ac9:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ace:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102ad3:	c1 e8 18             	shr    $0x18,%eax
  102ad6:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102adb:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102ae2:	24 ef                	and    $0xef,%al
  102ae4:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102ae9:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102af0:	e8 e1 fe ff ff       	call   1029d6 <lgdt>
  102af5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102afb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aff:	0f 00 d8             	ltr    %ax
}
  102b02:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102b03:	90                   	nop
  102b04:	89 ec                	mov    %ebp,%esp
  102b06:	5d                   	pop    %ebp
  102b07:	c3                   	ret    

00102b08 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b0b:	e8 fc fe ff ff       	call   102a0c <gdt_init>
}
  102b10:	90                   	nop
  102b11:	5d                   	pop    %ebp
  102b12:	c3                   	ret    

00102b13 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b13:	55                   	push   %ebp
  102b14:	89 e5                	mov    %esp,%ebp
  102b16:	83 ec 58             	sub    $0x58,%esp
  102b19:	8b 45 10             	mov    0x10(%ebp),%eax
  102b1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  102b22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b2e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b31:	8b 45 18             	mov    0x18(%ebp),%eax
  102b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b40:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b4d:	74 1c                	je     102b6b <printnum+0x58>
  102b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b52:	ba 00 00 00 00       	mov    $0x0,%edx
  102b57:	f7 75 e4             	divl   -0x1c(%ebp)
  102b5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b60:	ba 00 00 00 00       	mov    $0x0,%edx
  102b65:	f7 75 e4             	divl   -0x1c(%ebp)
  102b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b71:	f7 75 e4             	divl   -0x1c(%ebp)
  102b74:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b77:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b80:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b83:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b89:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b8c:	8b 45 18             	mov    0x18(%ebp),%eax
  102b8f:	ba 00 00 00 00       	mov    $0x0,%edx
  102b94:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102b97:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102b9a:	19 d1                	sbb    %edx,%ecx
  102b9c:	72 4c                	jb     102bea <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b9e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ba1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ba4:	8b 45 20             	mov    0x20(%ebp),%eax
  102ba7:	89 44 24 18          	mov    %eax,0x18(%esp)
  102bab:	89 54 24 14          	mov    %edx,0x14(%esp)
  102baf:	8b 45 18             	mov    0x18(%ebp),%eax
  102bb2:	89 44 24 10          	mov    %eax,0x10(%esp)
  102bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bc0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bce:	89 04 24             	mov    %eax,(%esp)
  102bd1:	e8 3d ff ff ff       	call   102b13 <printnum>
  102bd6:	eb 1b                	jmp    102bf3 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bdf:	8b 45 20             	mov    0x20(%ebp),%eax
  102be2:	89 04 24             	mov    %eax,(%esp)
  102be5:	8b 45 08             	mov    0x8(%ebp),%eax
  102be8:	ff d0                	call   *%eax
        while (-- width > 0)
  102bea:	ff 4d 1c             	decl   0x1c(%ebp)
  102bed:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102bf1:	7f e5                	jg     102bd8 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102bf3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bf6:	05 f0 3d 10 00       	add    $0x103df0,%eax
  102bfb:	0f b6 00             	movzbl (%eax),%eax
  102bfe:	0f be c0             	movsbl %al,%eax
  102c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c04:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c08:	89 04 24             	mov    %eax,(%esp)
  102c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0e:	ff d0                	call   *%eax
}
  102c10:	90                   	nop
  102c11:	89 ec                	mov    %ebp,%esp
  102c13:	5d                   	pop    %ebp
  102c14:	c3                   	ret    

00102c15 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c15:	55                   	push   %ebp
  102c16:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c18:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c1c:	7e 14                	jle    102c32 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	8b 00                	mov    (%eax),%eax
  102c23:	8d 48 08             	lea    0x8(%eax),%ecx
  102c26:	8b 55 08             	mov    0x8(%ebp),%edx
  102c29:	89 0a                	mov    %ecx,(%edx)
  102c2b:	8b 50 04             	mov    0x4(%eax),%edx
  102c2e:	8b 00                	mov    (%eax),%eax
  102c30:	eb 30                	jmp    102c62 <getuint+0x4d>
    }
    else if (lflag) {
  102c32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c36:	74 16                	je     102c4e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c38:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3b:	8b 00                	mov    (%eax),%eax
  102c3d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c40:	8b 55 08             	mov    0x8(%ebp),%edx
  102c43:	89 0a                	mov    %ecx,(%edx)
  102c45:	8b 00                	mov    (%eax),%eax
  102c47:	ba 00 00 00 00       	mov    $0x0,%edx
  102c4c:	eb 14                	jmp    102c62 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c51:	8b 00                	mov    (%eax),%eax
  102c53:	8d 48 04             	lea    0x4(%eax),%ecx
  102c56:	8b 55 08             	mov    0x8(%ebp),%edx
  102c59:	89 0a                	mov    %ecx,(%edx)
  102c5b:	8b 00                	mov    (%eax),%eax
  102c5d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c62:	5d                   	pop    %ebp
  102c63:	c3                   	ret    

00102c64 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c64:	55                   	push   %ebp
  102c65:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c6b:	7e 14                	jle    102c81 <getint+0x1d>
        return va_arg(*ap, long long);
  102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c70:	8b 00                	mov    (%eax),%eax
  102c72:	8d 48 08             	lea    0x8(%eax),%ecx
  102c75:	8b 55 08             	mov    0x8(%ebp),%edx
  102c78:	89 0a                	mov    %ecx,(%edx)
  102c7a:	8b 50 04             	mov    0x4(%eax),%edx
  102c7d:	8b 00                	mov    (%eax),%eax
  102c7f:	eb 28                	jmp    102ca9 <getint+0x45>
    }
    else if (lflag) {
  102c81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c85:	74 12                	je     102c99 <getint+0x35>
        return va_arg(*ap, long);
  102c87:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8a:	8b 00                	mov    (%eax),%eax
  102c8c:	8d 48 04             	lea    0x4(%eax),%ecx
  102c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c92:	89 0a                	mov    %ecx,(%edx)
  102c94:	8b 00                	mov    (%eax),%eax
  102c96:	99                   	cltd   
  102c97:	eb 10                	jmp    102ca9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c99:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9c:	8b 00                	mov    (%eax),%eax
  102c9e:	8d 48 04             	lea    0x4(%eax),%ecx
  102ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca4:	89 0a                	mov    %ecx,(%edx)
  102ca6:	8b 00                	mov    (%eax),%eax
  102ca8:	99                   	cltd   
    }
}
  102ca9:	5d                   	pop    %ebp
  102caa:	c3                   	ret    

00102cab <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102cab:	55                   	push   %ebp
  102cac:	89 e5                	mov    %esp,%ebp
  102cae:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102cb1:	8d 45 14             	lea    0x14(%ebp),%eax
  102cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102cc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccf:	89 04 24             	mov    %eax,(%esp)
  102cd2:	e8 05 00 00 00       	call   102cdc <vprintfmt>
    va_end(ap);
}
  102cd7:	90                   	nop
  102cd8:	89 ec                	mov    %ebp,%esp
  102cda:	5d                   	pop    %ebp
  102cdb:	c3                   	ret    

00102cdc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102cdc:	55                   	push   %ebp
  102cdd:	89 e5                	mov    %esp,%ebp
  102cdf:	56                   	push   %esi
  102ce0:	53                   	push   %ebx
  102ce1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ce4:	eb 17                	jmp    102cfd <vprintfmt+0x21>
            if (ch == '\0') {
  102ce6:	85 db                	test   %ebx,%ebx
  102ce8:	0f 84 bf 03 00 00    	je     1030ad <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf5:	89 1c 24             	mov    %ebx,(%esp)
  102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfb:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  102d00:	8d 50 01             	lea    0x1(%eax),%edx
  102d03:	89 55 10             	mov    %edx,0x10(%ebp)
  102d06:	0f b6 00             	movzbl (%eax),%eax
  102d09:	0f b6 d8             	movzbl %al,%ebx
  102d0c:	83 fb 25             	cmp    $0x25,%ebx
  102d0f:	75 d5                	jne    102ce6 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d11:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d15:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d22:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d2c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  102d32:	8d 50 01             	lea    0x1(%eax),%edx
  102d35:	89 55 10             	mov    %edx,0x10(%ebp)
  102d38:	0f b6 00             	movzbl (%eax),%eax
  102d3b:	0f b6 d8             	movzbl %al,%ebx
  102d3e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d41:	83 f8 55             	cmp    $0x55,%eax
  102d44:	0f 87 37 03 00 00    	ja     103081 <vprintfmt+0x3a5>
  102d4a:	8b 04 85 14 3e 10 00 	mov    0x103e14(,%eax,4),%eax
  102d51:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d53:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d57:	eb d6                	jmp    102d2f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d59:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d5d:	eb d0                	jmp    102d2f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d5f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d69:	89 d0                	mov    %edx,%eax
  102d6b:	c1 e0 02             	shl    $0x2,%eax
  102d6e:	01 d0                	add    %edx,%eax
  102d70:	01 c0                	add    %eax,%eax
  102d72:	01 d8                	add    %ebx,%eax
  102d74:	83 e8 30             	sub    $0x30,%eax
  102d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  102d7d:	0f b6 00             	movzbl (%eax),%eax
  102d80:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d83:	83 fb 2f             	cmp    $0x2f,%ebx
  102d86:	7e 38                	jle    102dc0 <vprintfmt+0xe4>
  102d88:	83 fb 39             	cmp    $0x39,%ebx
  102d8b:	7f 33                	jg     102dc0 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102d8d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102d90:	eb d4                	jmp    102d66 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102d92:	8b 45 14             	mov    0x14(%ebp),%eax
  102d95:	8d 50 04             	lea    0x4(%eax),%edx
  102d98:	89 55 14             	mov    %edx,0x14(%ebp)
  102d9b:	8b 00                	mov    (%eax),%eax
  102d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102da0:	eb 1f                	jmp    102dc1 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102da2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102da6:	79 87                	jns    102d2f <vprintfmt+0x53>
                width = 0;
  102da8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102daf:	e9 7b ff ff ff       	jmp    102d2f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102db4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102dbb:	e9 6f ff ff ff       	jmp    102d2f <vprintfmt+0x53>
            goto process_precision;
  102dc0:	90                   	nop

        process_precision:
            if (width < 0)
  102dc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dc5:	0f 89 64 ff ff ff    	jns    102d2f <vprintfmt+0x53>
                width = precision, precision = -1;
  102dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102dd1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102dd8:	e9 52 ff ff ff       	jmp    102d2f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102ddd:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102de0:	e9 4a ff ff ff       	jmp    102d2f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102de5:	8b 45 14             	mov    0x14(%ebp),%eax
  102de8:	8d 50 04             	lea    0x4(%eax),%edx
  102deb:	89 55 14             	mov    %edx,0x14(%ebp)
  102dee:	8b 00                	mov    (%eax),%eax
  102df0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102df3:	89 54 24 04          	mov    %edx,0x4(%esp)
  102df7:	89 04 24             	mov    %eax,(%esp)
  102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfd:	ff d0                	call   *%eax
            break;
  102dff:	e9 a4 02 00 00       	jmp    1030a8 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102e04:	8b 45 14             	mov    0x14(%ebp),%eax
  102e07:	8d 50 04             	lea    0x4(%eax),%edx
  102e0a:	89 55 14             	mov    %edx,0x14(%ebp)
  102e0d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e0f:	85 db                	test   %ebx,%ebx
  102e11:	79 02                	jns    102e15 <vprintfmt+0x139>
                err = -err;
  102e13:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e15:	83 fb 06             	cmp    $0x6,%ebx
  102e18:	7f 0b                	jg     102e25 <vprintfmt+0x149>
  102e1a:	8b 34 9d d4 3d 10 00 	mov    0x103dd4(,%ebx,4),%esi
  102e21:	85 f6                	test   %esi,%esi
  102e23:	75 23                	jne    102e48 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102e25:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e29:	c7 44 24 08 01 3e 10 	movl   $0x103e01,0x8(%esp)
  102e30:	00 
  102e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e38:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3b:	89 04 24             	mov    %eax,(%esp)
  102e3e:	e8 68 fe ff ff       	call   102cab <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e43:	e9 60 02 00 00       	jmp    1030a8 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102e48:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e4c:	c7 44 24 08 0a 3e 10 	movl   $0x103e0a,0x8(%esp)
  102e53:	00 
  102e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5e:	89 04 24             	mov    %eax,(%esp)
  102e61:	e8 45 fe ff ff       	call   102cab <printfmt>
            break;
  102e66:	e9 3d 02 00 00       	jmp    1030a8 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  102e6e:	8d 50 04             	lea    0x4(%eax),%edx
  102e71:	89 55 14             	mov    %edx,0x14(%ebp)
  102e74:	8b 30                	mov    (%eax),%esi
  102e76:	85 f6                	test   %esi,%esi
  102e78:	75 05                	jne    102e7f <vprintfmt+0x1a3>
                p = "(null)";
  102e7a:	be 0d 3e 10 00       	mov    $0x103e0d,%esi
            }
            if (width > 0 && padc != '-') {
  102e7f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e83:	7e 76                	jle    102efb <vprintfmt+0x21f>
  102e85:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e89:	74 70                	je     102efb <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e92:	89 34 24             	mov    %esi,(%esp)
  102e95:	e8 16 03 00 00       	call   1031b0 <strnlen>
  102e9a:	89 c2                	mov    %eax,%edx
  102e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e9f:	29 d0                	sub    %edx,%eax
  102ea1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ea4:	eb 16                	jmp    102ebc <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102ea6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ead:	89 54 24 04          	mov    %edx,0x4(%esp)
  102eb1:	89 04 24             	mov    %eax,(%esp)
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102eb9:	ff 4d e8             	decl   -0x18(%ebp)
  102ebc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ec0:	7f e4                	jg     102ea6 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ec2:	eb 37                	jmp    102efb <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ec4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ec8:	74 1f                	je     102ee9 <vprintfmt+0x20d>
  102eca:	83 fb 1f             	cmp    $0x1f,%ebx
  102ecd:	7e 05                	jle    102ed4 <vprintfmt+0x1f8>
  102ecf:	83 fb 7e             	cmp    $0x7e,%ebx
  102ed2:	7e 15                	jle    102ee9 <vprintfmt+0x20d>
                    putch('?', putdat);
  102ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102edb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee5:	ff d0                	call   *%eax
  102ee7:	eb 0f                	jmp    102ef8 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef0:	89 1c 24             	mov    %ebx,(%esp)
  102ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef6:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ef8:	ff 4d e8             	decl   -0x18(%ebp)
  102efb:	89 f0                	mov    %esi,%eax
  102efd:	8d 70 01             	lea    0x1(%eax),%esi
  102f00:	0f b6 00             	movzbl (%eax),%eax
  102f03:	0f be d8             	movsbl %al,%ebx
  102f06:	85 db                	test   %ebx,%ebx
  102f08:	74 27                	je     102f31 <vprintfmt+0x255>
  102f0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f0e:	78 b4                	js     102ec4 <vprintfmt+0x1e8>
  102f10:	ff 4d e4             	decl   -0x1c(%ebp)
  102f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f17:	79 ab                	jns    102ec4 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102f19:	eb 16                	jmp    102f31 <vprintfmt+0x255>
                putch(' ', putdat);
  102f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f22:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f29:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2c:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102f2e:	ff 4d e8             	decl   -0x18(%ebp)
  102f31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f35:	7f e4                	jg     102f1b <vprintfmt+0x23f>
            }
            break;
  102f37:	e9 6c 01 00 00       	jmp    1030a8 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f43:	8d 45 14             	lea    0x14(%ebp),%eax
  102f46:	89 04 24             	mov    %eax,(%esp)
  102f49:	e8 16 fd ff ff       	call   102c64 <getint>
  102f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f51:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f5a:	85 d2                	test   %edx,%edx
  102f5c:	79 26                	jns    102f84 <vprintfmt+0x2a8>
                putch('-', putdat);
  102f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f61:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f65:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6f:	ff d0                	call   *%eax
                num = -(long long)num;
  102f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f77:	f7 d8                	neg    %eax
  102f79:	83 d2 00             	adc    $0x0,%edx
  102f7c:	f7 da                	neg    %edx
  102f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f81:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f84:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f8b:	e9 a8 00 00 00       	jmp    103038 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f97:	8d 45 14             	lea    0x14(%ebp),%eax
  102f9a:	89 04 24             	mov    %eax,(%esp)
  102f9d:	e8 73 fc ff ff       	call   102c15 <getuint>
  102fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102fa8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102faf:	e9 84 00 00 00       	jmp    103038 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fbb:	8d 45 14             	lea    0x14(%ebp),%eax
  102fbe:	89 04 24             	mov    %eax,(%esp)
  102fc1:	e8 4f fc ff ff       	call   102c15 <getuint>
  102fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102fcc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102fd3:	eb 63                	jmp    103038 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fdc:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe6:	ff d0                	call   *%eax
            putch('x', putdat);
  102fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fef:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  102ffe:	8d 50 04             	lea    0x4(%eax),%edx
  103001:	89 55 14             	mov    %edx,0x14(%ebp)
  103004:	8b 00                	mov    (%eax),%eax
  103006:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103009:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103010:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103017:	eb 1f                	jmp    103038 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10301c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103020:	8d 45 14             	lea    0x14(%ebp),%eax
  103023:	89 04 24             	mov    %eax,(%esp)
  103026:	e8 ea fb ff ff       	call   102c15 <getuint>
  10302b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10302e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103031:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103038:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10303f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103043:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103046:	89 54 24 14          	mov    %edx,0x14(%esp)
  10304a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103054:	89 44 24 08          	mov    %eax,0x8(%esp)
  103058:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103063:	8b 45 08             	mov    0x8(%ebp),%eax
  103066:	89 04 24             	mov    %eax,(%esp)
  103069:	e8 a5 fa ff ff       	call   102b13 <printnum>
            break;
  10306e:	eb 38                	jmp    1030a8 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103070:	8b 45 0c             	mov    0xc(%ebp),%eax
  103073:	89 44 24 04          	mov    %eax,0x4(%esp)
  103077:	89 1c 24             	mov    %ebx,(%esp)
  10307a:	8b 45 08             	mov    0x8(%ebp),%eax
  10307d:	ff d0                	call   *%eax
            break;
  10307f:	eb 27                	jmp    1030a8 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103081:	8b 45 0c             	mov    0xc(%ebp),%eax
  103084:	89 44 24 04          	mov    %eax,0x4(%esp)
  103088:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10308f:	8b 45 08             	mov    0x8(%ebp),%eax
  103092:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103094:	ff 4d 10             	decl   0x10(%ebp)
  103097:	eb 03                	jmp    10309c <vprintfmt+0x3c0>
  103099:	ff 4d 10             	decl   0x10(%ebp)
  10309c:	8b 45 10             	mov    0x10(%ebp),%eax
  10309f:	48                   	dec    %eax
  1030a0:	0f b6 00             	movzbl (%eax),%eax
  1030a3:	3c 25                	cmp    $0x25,%al
  1030a5:	75 f2                	jne    103099 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1030a7:	90                   	nop
    while (1) {
  1030a8:	e9 37 fc ff ff       	jmp    102ce4 <vprintfmt+0x8>
                return;
  1030ad:	90                   	nop
        }
    }
}
  1030ae:	83 c4 40             	add    $0x40,%esp
  1030b1:	5b                   	pop    %ebx
  1030b2:	5e                   	pop    %esi
  1030b3:	5d                   	pop    %ebp
  1030b4:	c3                   	ret    

001030b5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030b5:	55                   	push   %ebp
  1030b6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bb:	8b 40 08             	mov    0x8(%eax),%eax
  1030be:	8d 50 01             	lea    0x1(%eax),%edx
  1030c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1030c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ca:	8b 10                	mov    (%eax),%edx
  1030cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030cf:	8b 40 04             	mov    0x4(%eax),%eax
  1030d2:	39 c2                	cmp    %eax,%edx
  1030d4:	73 12                	jae    1030e8 <sprintputch+0x33>
        *b->buf ++ = ch;
  1030d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d9:	8b 00                	mov    (%eax),%eax
  1030db:	8d 48 01             	lea    0x1(%eax),%ecx
  1030de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030e1:	89 0a                	mov    %ecx,(%edx)
  1030e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e6:	88 10                	mov    %dl,(%eax)
    }
}
  1030e8:	90                   	nop
  1030e9:	5d                   	pop    %ebp
  1030ea:	c3                   	ret    

001030eb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030eb:	55                   	push   %ebp
  1030ec:	89 e5                	mov    %esp,%ebp
  1030ee:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1030f1:	8d 45 14             	lea    0x14(%ebp),%eax
  1030f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030fe:	8b 45 10             	mov    0x10(%ebp),%eax
  103101:	89 44 24 08          	mov    %eax,0x8(%esp)
  103105:	8b 45 0c             	mov    0xc(%ebp),%eax
  103108:	89 44 24 04          	mov    %eax,0x4(%esp)
  10310c:	8b 45 08             	mov    0x8(%ebp),%eax
  10310f:	89 04 24             	mov    %eax,(%esp)
  103112:	e8 0a 00 00 00       	call   103121 <vsnprintf>
  103117:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10311d:	89 ec                	mov    %ebp,%esp
  10311f:	5d                   	pop    %ebp
  103120:	c3                   	ret    

00103121 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103121:	55                   	push   %ebp
  103122:	89 e5                	mov    %esp,%ebp
  103124:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103127:	8b 45 08             	mov    0x8(%ebp),%eax
  10312a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10312d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103130:	8d 50 ff             	lea    -0x1(%eax),%edx
  103133:	8b 45 08             	mov    0x8(%ebp),%eax
  103136:	01 d0                	add    %edx,%eax
  103138:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10313b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103142:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103146:	74 0a                	je     103152 <vsnprintf+0x31>
  103148:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10314b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10314e:	39 c2                	cmp    %eax,%edx
  103150:	76 07                	jbe    103159 <vsnprintf+0x38>
        return -E_INVAL;
  103152:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103157:	eb 2a                	jmp    103183 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103159:	8b 45 14             	mov    0x14(%ebp),%eax
  10315c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103160:	8b 45 10             	mov    0x10(%ebp),%eax
  103163:	89 44 24 08          	mov    %eax,0x8(%esp)
  103167:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10316a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10316e:	c7 04 24 b5 30 10 00 	movl   $0x1030b5,(%esp)
  103175:	e8 62 fb ff ff       	call   102cdc <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10317a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10317d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103180:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103183:	89 ec                	mov    %ebp,%esp
  103185:	5d                   	pop    %ebp
  103186:	c3                   	ret    

00103187 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103187:	55                   	push   %ebp
  103188:	89 e5                	mov    %esp,%ebp
  10318a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10318d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103194:	eb 03                	jmp    103199 <strlen+0x12>
        cnt ++;
  103196:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  103199:	8b 45 08             	mov    0x8(%ebp),%eax
  10319c:	8d 50 01             	lea    0x1(%eax),%edx
  10319f:	89 55 08             	mov    %edx,0x8(%ebp)
  1031a2:	0f b6 00             	movzbl (%eax),%eax
  1031a5:	84 c0                	test   %al,%al
  1031a7:	75 ed                	jne    103196 <strlen+0xf>
    }
    return cnt;
  1031a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031ac:	89 ec                	mov    %ebp,%esp
  1031ae:	5d                   	pop    %ebp
  1031af:	c3                   	ret    

001031b0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1031b0:	55                   	push   %ebp
  1031b1:	89 e5                	mov    %esp,%ebp
  1031b3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031bd:	eb 03                	jmp    1031c2 <strnlen+0x12>
        cnt ++;
  1031bf:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031c8:	73 10                	jae    1031da <strnlen+0x2a>
  1031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cd:	8d 50 01             	lea    0x1(%eax),%edx
  1031d0:	89 55 08             	mov    %edx,0x8(%ebp)
  1031d3:	0f b6 00             	movzbl (%eax),%eax
  1031d6:	84 c0                	test   %al,%al
  1031d8:	75 e5                	jne    1031bf <strnlen+0xf>
    }
    return cnt;
  1031da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031dd:	89 ec                	mov    %ebp,%esp
  1031df:	5d                   	pop    %ebp
  1031e0:	c3                   	ret    

001031e1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1031e1:	55                   	push   %ebp
  1031e2:	89 e5                	mov    %esp,%ebp
  1031e4:	57                   	push   %edi
  1031e5:	56                   	push   %esi
  1031e6:	83 ec 20             	sub    $0x20,%esp
  1031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1031f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031fb:	89 d1                	mov    %edx,%ecx
  1031fd:	89 c2                	mov    %eax,%edx
  1031ff:	89 ce                	mov    %ecx,%esi
  103201:	89 d7                	mov    %edx,%edi
  103203:	ac                   	lods   %ds:(%esi),%al
  103204:	aa                   	stos   %al,%es:(%edi)
  103205:	84 c0                	test   %al,%al
  103207:	75 fa                	jne    103203 <strcpy+0x22>
  103209:	89 fa                	mov    %edi,%edx
  10320b:	89 f1                	mov    %esi,%ecx
  10320d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103210:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103216:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103219:	83 c4 20             	add    $0x20,%esp
  10321c:	5e                   	pop    %esi
  10321d:	5f                   	pop    %edi
  10321e:	5d                   	pop    %ebp
  10321f:	c3                   	ret    

00103220 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103220:	55                   	push   %ebp
  103221:	89 e5                	mov    %esp,%ebp
  103223:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103226:	8b 45 08             	mov    0x8(%ebp),%eax
  103229:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10322c:	eb 1e                	jmp    10324c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10322e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103231:	0f b6 10             	movzbl (%eax),%edx
  103234:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103237:	88 10                	mov    %dl,(%eax)
  103239:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10323c:	0f b6 00             	movzbl (%eax),%eax
  10323f:	84 c0                	test   %al,%al
  103241:	74 03                	je     103246 <strncpy+0x26>
            src ++;
  103243:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  103246:	ff 45 fc             	incl   -0x4(%ebp)
  103249:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  10324c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103250:	75 dc                	jne    10322e <strncpy+0xe>
    }
    return dst;
  103252:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103255:	89 ec                	mov    %ebp,%esp
  103257:	5d                   	pop    %ebp
  103258:	c3                   	ret    

00103259 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103259:	55                   	push   %ebp
  10325a:	89 e5                	mov    %esp,%ebp
  10325c:	57                   	push   %edi
  10325d:	56                   	push   %esi
  10325e:	83 ec 20             	sub    $0x20,%esp
  103261:	8b 45 08             	mov    0x8(%ebp),%eax
  103264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103267:	8b 45 0c             	mov    0xc(%ebp),%eax
  10326a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10326d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103273:	89 d1                	mov    %edx,%ecx
  103275:	89 c2                	mov    %eax,%edx
  103277:	89 ce                	mov    %ecx,%esi
  103279:	89 d7                	mov    %edx,%edi
  10327b:	ac                   	lods   %ds:(%esi),%al
  10327c:	ae                   	scas   %es:(%edi),%al
  10327d:	75 08                	jne    103287 <strcmp+0x2e>
  10327f:	84 c0                	test   %al,%al
  103281:	75 f8                	jne    10327b <strcmp+0x22>
  103283:	31 c0                	xor    %eax,%eax
  103285:	eb 04                	jmp    10328b <strcmp+0x32>
  103287:	19 c0                	sbb    %eax,%eax
  103289:	0c 01                	or     $0x1,%al
  10328b:	89 fa                	mov    %edi,%edx
  10328d:	89 f1                	mov    %esi,%ecx
  10328f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103292:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103295:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  103298:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10329b:	83 c4 20             	add    $0x20,%esp
  10329e:	5e                   	pop    %esi
  10329f:	5f                   	pop    %edi
  1032a0:	5d                   	pop    %ebp
  1032a1:	c3                   	ret    

001032a2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1032a2:	55                   	push   %ebp
  1032a3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032a5:	eb 09                	jmp    1032b0 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1032a7:	ff 4d 10             	decl   0x10(%ebp)
  1032aa:	ff 45 08             	incl   0x8(%ebp)
  1032ad:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032b4:	74 1a                	je     1032d0 <strncmp+0x2e>
  1032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b9:	0f b6 00             	movzbl (%eax),%eax
  1032bc:	84 c0                	test   %al,%al
  1032be:	74 10                	je     1032d0 <strncmp+0x2e>
  1032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c3:	0f b6 10             	movzbl (%eax),%edx
  1032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c9:	0f b6 00             	movzbl (%eax),%eax
  1032cc:	38 c2                	cmp    %al,%dl
  1032ce:	74 d7                	je     1032a7 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032d4:	74 18                	je     1032ee <strncmp+0x4c>
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	0f b6 d0             	movzbl %al,%edx
  1032df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e2:	0f b6 00             	movzbl (%eax),%eax
  1032e5:	0f b6 c8             	movzbl %al,%ecx
  1032e8:	89 d0                	mov    %edx,%eax
  1032ea:	29 c8                	sub    %ecx,%eax
  1032ec:	eb 05                	jmp    1032f3 <strncmp+0x51>
  1032ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032f3:	5d                   	pop    %ebp
  1032f4:	c3                   	ret    

001032f5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1032f5:	55                   	push   %ebp
  1032f6:	89 e5                	mov    %esp,%ebp
  1032f8:	83 ec 04             	sub    $0x4,%esp
  1032fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fe:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103301:	eb 13                	jmp    103316 <strchr+0x21>
        if (*s == c) {
  103303:	8b 45 08             	mov    0x8(%ebp),%eax
  103306:	0f b6 00             	movzbl (%eax),%eax
  103309:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10330c:	75 05                	jne    103313 <strchr+0x1e>
            return (char *)s;
  10330e:	8b 45 08             	mov    0x8(%ebp),%eax
  103311:	eb 12                	jmp    103325 <strchr+0x30>
        }
        s ++;
  103313:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103316:	8b 45 08             	mov    0x8(%ebp),%eax
  103319:	0f b6 00             	movzbl (%eax),%eax
  10331c:	84 c0                	test   %al,%al
  10331e:	75 e3                	jne    103303 <strchr+0xe>
    }
    return NULL;
  103320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103325:	89 ec                	mov    %ebp,%esp
  103327:	5d                   	pop    %ebp
  103328:	c3                   	ret    

00103329 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103329:	55                   	push   %ebp
  10332a:	89 e5                	mov    %esp,%ebp
  10332c:	83 ec 04             	sub    $0x4,%esp
  10332f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103332:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103335:	eb 0e                	jmp    103345 <strfind+0x1c>
        if (*s == c) {
  103337:	8b 45 08             	mov    0x8(%ebp),%eax
  10333a:	0f b6 00             	movzbl (%eax),%eax
  10333d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103340:	74 0f                	je     103351 <strfind+0x28>
            break;
        }
        s ++;
  103342:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103345:	8b 45 08             	mov    0x8(%ebp),%eax
  103348:	0f b6 00             	movzbl (%eax),%eax
  10334b:	84 c0                	test   %al,%al
  10334d:	75 e8                	jne    103337 <strfind+0xe>
  10334f:	eb 01                	jmp    103352 <strfind+0x29>
            break;
  103351:	90                   	nop
    }
    return (char *)s;
  103352:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103355:	89 ec                	mov    %ebp,%esp
  103357:	5d                   	pop    %ebp
  103358:	c3                   	ret    

00103359 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103359:	55                   	push   %ebp
  10335a:	89 e5                	mov    %esp,%ebp
  10335c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10335f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103366:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10336d:	eb 03                	jmp    103372 <strtol+0x19>
        s ++;
  10336f:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103372:	8b 45 08             	mov    0x8(%ebp),%eax
  103375:	0f b6 00             	movzbl (%eax),%eax
  103378:	3c 20                	cmp    $0x20,%al
  10337a:	74 f3                	je     10336f <strtol+0x16>
  10337c:	8b 45 08             	mov    0x8(%ebp),%eax
  10337f:	0f b6 00             	movzbl (%eax),%eax
  103382:	3c 09                	cmp    $0x9,%al
  103384:	74 e9                	je     10336f <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  103386:	8b 45 08             	mov    0x8(%ebp),%eax
  103389:	0f b6 00             	movzbl (%eax),%eax
  10338c:	3c 2b                	cmp    $0x2b,%al
  10338e:	75 05                	jne    103395 <strtol+0x3c>
        s ++;
  103390:	ff 45 08             	incl   0x8(%ebp)
  103393:	eb 14                	jmp    1033a9 <strtol+0x50>
    }
    else if (*s == '-') {
  103395:	8b 45 08             	mov    0x8(%ebp),%eax
  103398:	0f b6 00             	movzbl (%eax),%eax
  10339b:	3c 2d                	cmp    $0x2d,%al
  10339d:	75 0a                	jne    1033a9 <strtol+0x50>
        s ++, neg = 1;
  10339f:	ff 45 08             	incl   0x8(%ebp)
  1033a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1033a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033ad:	74 06                	je     1033b5 <strtol+0x5c>
  1033af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033b3:	75 22                	jne    1033d7 <strtol+0x7e>
  1033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b8:	0f b6 00             	movzbl (%eax),%eax
  1033bb:	3c 30                	cmp    $0x30,%al
  1033bd:	75 18                	jne    1033d7 <strtol+0x7e>
  1033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c2:	40                   	inc    %eax
  1033c3:	0f b6 00             	movzbl (%eax),%eax
  1033c6:	3c 78                	cmp    $0x78,%al
  1033c8:	75 0d                	jne    1033d7 <strtol+0x7e>
        s += 2, base = 16;
  1033ca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1033ce:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1033d5:	eb 29                	jmp    103400 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  1033d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033db:	75 16                	jne    1033f3 <strtol+0x9a>
  1033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e0:	0f b6 00             	movzbl (%eax),%eax
  1033e3:	3c 30                	cmp    $0x30,%al
  1033e5:	75 0c                	jne    1033f3 <strtol+0x9a>
        s ++, base = 8;
  1033e7:	ff 45 08             	incl   0x8(%ebp)
  1033ea:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1033f1:	eb 0d                	jmp    103400 <strtol+0xa7>
    }
    else if (base == 0) {
  1033f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033f7:	75 07                	jne    103400 <strtol+0xa7>
        base = 10;
  1033f9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103400:	8b 45 08             	mov    0x8(%ebp),%eax
  103403:	0f b6 00             	movzbl (%eax),%eax
  103406:	3c 2f                	cmp    $0x2f,%al
  103408:	7e 1b                	jle    103425 <strtol+0xcc>
  10340a:	8b 45 08             	mov    0x8(%ebp),%eax
  10340d:	0f b6 00             	movzbl (%eax),%eax
  103410:	3c 39                	cmp    $0x39,%al
  103412:	7f 11                	jg     103425 <strtol+0xcc>
            dig = *s - '0';
  103414:	8b 45 08             	mov    0x8(%ebp),%eax
  103417:	0f b6 00             	movzbl (%eax),%eax
  10341a:	0f be c0             	movsbl %al,%eax
  10341d:	83 e8 30             	sub    $0x30,%eax
  103420:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103423:	eb 48                	jmp    10346d <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103425:	8b 45 08             	mov    0x8(%ebp),%eax
  103428:	0f b6 00             	movzbl (%eax),%eax
  10342b:	3c 60                	cmp    $0x60,%al
  10342d:	7e 1b                	jle    10344a <strtol+0xf1>
  10342f:	8b 45 08             	mov    0x8(%ebp),%eax
  103432:	0f b6 00             	movzbl (%eax),%eax
  103435:	3c 7a                	cmp    $0x7a,%al
  103437:	7f 11                	jg     10344a <strtol+0xf1>
            dig = *s - 'a' + 10;
  103439:	8b 45 08             	mov    0x8(%ebp),%eax
  10343c:	0f b6 00             	movzbl (%eax),%eax
  10343f:	0f be c0             	movsbl %al,%eax
  103442:	83 e8 57             	sub    $0x57,%eax
  103445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103448:	eb 23                	jmp    10346d <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10344a:	8b 45 08             	mov    0x8(%ebp),%eax
  10344d:	0f b6 00             	movzbl (%eax),%eax
  103450:	3c 40                	cmp    $0x40,%al
  103452:	7e 3b                	jle    10348f <strtol+0x136>
  103454:	8b 45 08             	mov    0x8(%ebp),%eax
  103457:	0f b6 00             	movzbl (%eax),%eax
  10345a:	3c 5a                	cmp    $0x5a,%al
  10345c:	7f 31                	jg     10348f <strtol+0x136>
            dig = *s - 'A' + 10;
  10345e:	8b 45 08             	mov    0x8(%ebp),%eax
  103461:	0f b6 00             	movzbl (%eax),%eax
  103464:	0f be c0             	movsbl %al,%eax
  103467:	83 e8 37             	sub    $0x37,%eax
  10346a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103470:	3b 45 10             	cmp    0x10(%ebp),%eax
  103473:	7d 19                	jge    10348e <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  103475:	ff 45 08             	incl   0x8(%ebp)
  103478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10347b:	0f af 45 10          	imul   0x10(%ebp),%eax
  10347f:	89 c2                	mov    %eax,%edx
  103481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103484:	01 d0                	add    %edx,%eax
  103486:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103489:	e9 72 ff ff ff       	jmp    103400 <strtol+0xa7>
            break;
  10348e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10348f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103493:	74 08                	je     10349d <strtol+0x144>
        *endptr = (char *) s;
  103495:	8b 45 0c             	mov    0xc(%ebp),%eax
  103498:	8b 55 08             	mov    0x8(%ebp),%edx
  10349b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10349d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1034a1:	74 07                	je     1034aa <strtol+0x151>
  1034a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034a6:	f7 d8                	neg    %eax
  1034a8:	eb 03                	jmp    1034ad <strtol+0x154>
  1034aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1034ad:	89 ec                	mov    %ebp,%esp
  1034af:	5d                   	pop    %ebp
  1034b0:	c3                   	ret    

001034b1 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034b1:	55                   	push   %ebp
  1034b2:	89 e5                	mov    %esp,%ebp
  1034b4:	83 ec 28             	sub    $0x28,%esp
  1034b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bd:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1034c0:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1034ca:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1034cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1034d3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034d6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1034da:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1034dd:	89 d7                	mov    %edx,%edi
  1034df:	f3 aa                	rep stos %al,%es:(%edi)
  1034e1:	89 fa                	mov    %edi,%edx
  1034e3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1034e6:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1034ef:	89 ec                	mov    %ebp,%esp
  1034f1:	5d                   	pop    %ebp
  1034f2:	c3                   	ret    

001034f3 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1034f3:	55                   	push   %ebp
  1034f4:	89 e5                	mov    %esp,%ebp
  1034f6:	57                   	push   %edi
  1034f7:	56                   	push   %esi
  1034f8:	53                   	push   %ebx
  1034f9:	83 ec 30             	sub    $0x30,%esp
  1034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103502:	8b 45 0c             	mov    0xc(%ebp),%eax
  103505:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103508:	8b 45 10             	mov    0x10(%ebp),%eax
  10350b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10350e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103511:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103514:	73 42                	jae    103558 <memmove+0x65>
  103516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10351c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10351f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103525:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103528:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10352b:	c1 e8 02             	shr    $0x2,%eax
  10352e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103536:	89 d7                	mov    %edx,%edi
  103538:	89 c6                	mov    %eax,%esi
  10353a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10353c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10353f:	83 e1 03             	and    $0x3,%ecx
  103542:	74 02                	je     103546 <memmove+0x53>
  103544:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103546:	89 f0                	mov    %esi,%eax
  103548:	89 fa                	mov    %edi,%edx
  10354a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10354d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103550:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103556:	eb 36                	jmp    10358e <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10355b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103561:	01 c2                	add    %eax,%edx
  103563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103566:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10356c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10356f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103572:	89 c1                	mov    %eax,%ecx
  103574:	89 d8                	mov    %ebx,%eax
  103576:	89 d6                	mov    %edx,%esi
  103578:	89 c7                	mov    %eax,%edi
  10357a:	fd                   	std    
  10357b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10357d:	fc                   	cld    
  10357e:	89 f8                	mov    %edi,%eax
  103580:	89 f2                	mov    %esi,%edx
  103582:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103585:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103588:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10358b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10358e:	83 c4 30             	add    $0x30,%esp
  103591:	5b                   	pop    %ebx
  103592:	5e                   	pop    %esi
  103593:	5f                   	pop    %edi
  103594:	5d                   	pop    %ebp
  103595:	c3                   	ret    

00103596 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103596:	55                   	push   %ebp
  103597:	89 e5                	mov    %esp,%ebp
  103599:	57                   	push   %edi
  10359a:	56                   	push   %esi
  10359b:	83 ec 20             	sub    $0x20,%esp
  10359e:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1035ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1035b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b3:	c1 e8 02             	shr    $0x2,%eax
  1035b6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1035b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035be:	89 d7                	mov    %edx,%edi
  1035c0:	89 c6                	mov    %eax,%esi
  1035c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035c4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1035c7:	83 e1 03             	and    $0x3,%ecx
  1035ca:	74 02                	je     1035ce <memcpy+0x38>
  1035cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035ce:	89 f0                	mov    %esi,%eax
  1035d0:	89 fa                	mov    %edi,%edx
  1035d2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1035d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1035d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1035de:	83 c4 20             	add    $0x20,%esp
  1035e1:	5e                   	pop    %esi
  1035e2:	5f                   	pop    %edi
  1035e3:	5d                   	pop    %ebp
  1035e4:	c3                   	ret    

001035e5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1035e5:	55                   	push   %ebp
  1035e6:	89 e5                	mov    %esp,%ebp
  1035e8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1035f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1035f7:	eb 2e                	jmp    103627 <memcmp+0x42>
        if (*s1 != *s2) {
  1035f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035fc:	0f b6 10             	movzbl (%eax),%edx
  1035ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103602:	0f b6 00             	movzbl (%eax),%eax
  103605:	38 c2                	cmp    %al,%dl
  103607:	74 18                	je     103621 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10360c:	0f b6 00             	movzbl (%eax),%eax
  10360f:	0f b6 d0             	movzbl %al,%edx
  103612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103615:	0f b6 00             	movzbl (%eax),%eax
  103618:	0f b6 c8             	movzbl %al,%ecx
  10361b:	89 d0                	mov    %edx,%eax
  10361d:	29 c8                	sub    %ecx,%eax
  10361f:	eb 18                	jmp    103639 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103621:	ff 45 fc             	incl   -0x4(%ebp)
  103624:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103627:	8b 45 10             	mov    0x10(%ebp),%eax
  10362a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10362d:	89 55 10             	mov    %edx,0x10(%ebp)
  103630:	85 c0                	test   %eax,%eax
  103632:	75 c5                	jne    1035f9 <memcmp+0x14>
    }
    return 0;
  103634:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103639:	89 ec                	mov    %ebp,%esp
  10363b:	5d                   	pop    %ebp
  10363c:	c3                   	ret    
