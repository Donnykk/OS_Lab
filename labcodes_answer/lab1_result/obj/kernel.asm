
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
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	83 ec 04             	sub    $0x4,%esp
  100013:	50                   	push   %eax
  100014:	6a 00                	push   $0x0
  100016:	68 16 fa 10 00       	push   $0x10fa16
  10001b:	e8 d6 33 00 00       	call   1033f6 <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 55 15 00 00       	call   10157d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f4 80 35 10 00 	movl   $0x103580,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	push   -0xc(%ebp)
  100035:	68 9c 35 10 00       	push   $0x10359c
  10003a:	e8 cc 02 00 00       	call   10030b <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 c2 07 00 00       	call   100809 <print_kerninfo>

    grade_backtrace();
  100047:	e8 79 00 00 00       	call   1000c5 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 64 2a 00 00       	call   102ab5 <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 7c 16 00 00       	call   1016d2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 fe 17 00 00       	call   101859 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 de 0c 00 00       	call   100d3e <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 d5 15 00 00       	call   10163a <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100065:	e8 50 01 00 00       	call   1001ba <lab1_switch_test>

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	83 ec 04             	sub    $0x4,%esp
  100075:	6a 00                	push   $0x0
  100077:	6a 00                	push   $0x0
  100079:	6a 00                	push   $0x0
  10007b:	e8 d8 0b 00 00       	call   100c58 <mon_backtrace>
  100080:	83 c4 10             	add    $0x10,%esp
}
  100083:	90                   	nop
  100084:	c9                   	leave  
  100085:	c3                   	ret    

00100086 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100086:	55                   	push   %ebp
  100087:	89 e5                	mov    %esp,%ebp
  100089:	53                   	push   %ebx
  10008a:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008d:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100090:	8b 55 0c             	mov    0xc(%ebp),%edx
  100093:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100096:	8b 45 08             	mov    0x8(%ebp),%eax
  100099:	51                   	push   %ecx
  10009a:	52                   	push   %edx
  10009b:	53                   	push   %ebx
  10009c:	50                   	push   %eax
  10009d:	e8 ca ff ff ff       	call   10006c <grade_backtrace2>
  1000a2:	83 c4 10             	add    $0x10,%esp
}
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b1:	83 ec 08             	sub    $0x8,%esp
  1000b4:	ff 75 10             	push   0x10(%ebp)
  1000b7:	ff 75 08             	push   0x8(%ebp)
  1000ba:	e8 c7 ff ff ff       	call   100086 <grade_backtrace1>
  1000bf:	83 c4 10             	add    $0x10,%esp
}
  1000c2:	90                   	nop
  1000c3:	c9                   	leave  
  1000c4:	c3                   	ret    

001000c5 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c5:	55                   	push   %ebp
  1000c6:	89 e5                	mov    %esp,%ebp
  1000c8:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cb:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d0:	83 ec 04             	sub    $0x4,%esp
  1000d3:	68 00 00 ff ff       	push   $0xffff0000
  1000d8:	50                   	push   %eax
  1000d9:	6a 00                	push   $0x0
  1000db:	e8 cb ff ff ff       	call   1000ab <grade_backtrace0>
  1000e0:	83 c4 10             	add    $0x10,%esp
}
  1000e3:	90                   	nop
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 a1 35 10 00       	push   $0x1035a1
  100113:	e8 f3 01 00 00       	call   10030b <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 af 35 10 00       	push   $0x1035af
  100131:	e8 d5 01 00 00       	call   10030b <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100139:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013d:	0f b7 d0             	movzwl %ax,%edx
  100140:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100145:	83 ec 04             	sub    $0x4,%esp
  100148:	52                   	push   %edx
  100149:	50                   	push   %eax
  10014a:	68 bd 35 10 00       	push   $0x1035bd
  10014f:	e8 b7 01 00 00       	call   10030b <cprintf>
  100154:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100157:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100163:	83 ec 04             	sub    $0x4,%esp
  100166:	52                   	push   %edx
  100167:	50                   	push   %eax
  100168:	68 cb 35 10 00       	push   $0x1035cb
  10016d:	e8 99 01 00 00       	call   10030b <cprintf>
  100172:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100175:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100179:	0f b7 d0             	movzwl %ax,%edx
  10017c:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100181:	83 ec 04             	sub    $0x4,%esp
  100184:	52                   	push   %edx
  100185:	50                   	push   %eax
  100186:	68 d9 35 10 00       	push   $0x1035d9
  10018b:	e8 7b 01 00 00       	call   10030b <cprintf>
  100190:	83 c4 10             	add    $0x10,%esp
    round ++;
  100193:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100198:	83 c0 01             	add    $0x1,%eax
  10019b:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001a0:	90                   	nop
  1001a1:	c9                   	leave  
  1001a2:	c3                   	ret    

001001a3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a3:	55                   	push   %ebp
  1001a4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001a6:	83 ec 08             	sub    $0x8,%esp
  1001a9:	cd 78                	int    $0x78
  1001ab:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ad:	90                   	nop
  1001ae:	5d                   	pop    %ebp
  1001af:	c3                   	ret    

001001b0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b0:	55                   	push   %ebp
  1001b1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001b3:	cd 79                	int    $0x79
  1001b5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001b7:	90                   	nop
  1001b8:	5d                   	pop    %ebp
  1001b9:	c3                   	ret    

001001ba <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ba:	55                   	push   %ebp
  1001bb:	89 e5                	mov    %esp,%ebp
  1001bd:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c0:	e8 21 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c5:	83 ec 0c             	sub    $0xc,%esp
  1001c8:	68 e8 35 10 00       	push   $0x1035e8
  1001cd:	e8 39 01 00 00       	call   10030b <cprintf>
  1001d2:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d5:	e8 c9 ff ff ff       	call   1001a3 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001da:	e8 07 ff ff ff       	call   1000e6 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001df:	83 ec 0c             	sub    $0xc,%esp
  1001e2:	68 08 36 10 00       	push   $0x103608
  1001e7:	e8 1f 01 00 00       	call   10030b <cprintf>
  1001ec:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001ef:	e8 bc ff ff ff       	call   1001b0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f4:	e8 ed fe ff ff       	call   1000e6 <lab1_print_cur_status>
}
  1001f9:	90                   	nop
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
  1001ff:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100206:	74 13                	je     10021b <readline+0x1f>
        cprintf("%s", prompt);
  100208:	83 ec 08             	sub    $0x8,%esp
  10020b:	ff 75 08             	push   0x8(%ebp)
  10020e:	68 27 36 10 00       	push   $0x103627
  100213:	e8 f3 00 00 00       	call   10030b <cprintf>
  100218:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10021b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100222:	e8 6f 01 00 00       	call   100396 <getchar>
  100227:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10022a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10022e:	79 0a                	jns    10023a <readline+0x3e>
            return NULL;
  100230:	b8 00 00 00 00       	mov    $0x0,%eax
  100235:	e9 82 00 00 00       	jmp    1002bc <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10023a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10023e:	7e 2b                	jle    10026b <readline+0x6f>
  100240:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100247:	7f 22                	jg     10026b <readline+0x6f>
            cputchar(c);
  100249:	83 ec 0c             	sub    $0xc,%esp
  10024c:	ff 75 f0             	push   -0x10(%ebp)
  10024f:	e8 dd 00 00 00       	call   100331 <cputchar>
  100254:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10025a:	8d 50 01             	lea    0x1(%eax),%edx
  10025d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100260:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100263:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100269:	eb 4c                	jmp    1002b7 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10026b:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10026f:	75 1a                	jne    10028b <readline+0x8f>
  100271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100275:	7e 14                	jle    10028b <readline+0x8f>
            cputchar(c);
  100277:	83 ec 0c             	sub    $0xc,%esp
  10027a:	ff 75 f0             	push   -0x10(%ebp)
  10027d:	e8 af 00 00 00       	call   100331 <cputchar>
  100282:	83 c4 10             	add    $0x10,%esp
            i --;
  100285:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100289:	eb 2c                	jmp    1002b7 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10028b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10028f:	74 06                	je     100297 <readline+0x9b>
  100291:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100295:	75 8b                	jne    100222 <readline+0x26>
            cputchar(c);
  100297:	83 ec 0c             	sub    $0xc,%esp
  10029a:	ff 75 f0             	push   -0x10(%ebp)
  10029d:	e8 8f 00 00 00       	call   100331 <cputchar>
  1002a2:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1002a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a8:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002ad:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b0:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002b5:	eb 05                	jmp    1002bc <readline+0xc0>
        c = getchar();
  1002b7:	e9 66 ff ff ff       	jmp    100222 <readline+0x26>
        }
    }
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002c4:	83 ec 0c             	sub    $0xc,%esp
  1002c7:	ff 75 08             	push   0x8(%ebp)
  1002ca:	e8 df 12 00 00       	call   1015ae <cons_putc>
  1002cf:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d5:	8b 00                	mov    (%eax),%eax
  1002d7:	8d 50 01             	lea    0x1(%eax),%edx
  1002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dd:	89 10                	mov    %edx,(%eax)
}
  1002df:	90                   	nop
  1002e0:	c9                   	leave  
  1002e1:	c3                   	ret    

001002e2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e2:	55                   	push   %ebp
  1002e3:	89 e5                	mov    %esp,%ebp
  1002e5:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ef:	ff 75 0c             	push   0xc(%ebp)
  1002f2:	ff 75 08             	push   0x8(%ebp)
  1002f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002f8:	50                   	push   %eax
  1002f9:	68 be 02 10 00       	push   $0x1002be
  1002fe:	e8 63 29 00 00       	call   102c66 <vprintfmt>
  100303:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100311:	8d 45 0c             	lea    0xc(%ebp),%eax
  100314:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10031a:	83 ec 08             	sub    $0x8,%esp
  10031d:	50                   	push   %eax
  10031e:	ff 75 08             	push   0x8(%ebp)
  100321:	e8 bc ff ff ff       	call   1002e2 <vcprintf>
  100326:	83 c4 10             	add    $0x10,%esp
  100329:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032f:	c9                   	leave  
  100330:	c3                   	ret    

00100331 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100331:	55                   	push   %ebp
  100332:	89 e5                	mov    %esp,%ebp
  100334:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100337:	83 ec 0c             	sub    $0xc,%esp
  10033a:	ff 75 08             	push   0x8(%ebp)
  10033d:	e8 6c 12 00 00       	call   1015ae <cons_putc>
  100342:	83 c4 10             	add    $0x10,%esp
}
  100345:	90                   	nop
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10034e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100355:	eb 14                	jmp    10036b <cputs+0x23>
        cputch(c, &cnt);
  100357:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035b:	83 ec 08             	sub    $0x8,%esp
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	52                   	push   %edx
  100362:	50                   	push   %eax
  100363:	e8 56 ff ff ff       	call   1002be <cputch>
  100368:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  10036b:	8b 45 08             	mov    0x8(%ebp),%eax
  10036e:	8d 50 01             	lea    0x1(%eax),%edx
  100371:	89 55 08             	mov    %edx,0x8(%ebp)
  100374:	0f b6 00             	movzbl (%eax),%eax
  100377:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10037e:	75 d7                	jne    100357 <cputs+0xf>
    }
    cputch('\n', &cnt);
  100380:	83 ec 08             	sub    $0x8,%esp
  100383:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100386:	50                   	push   %eax
  100387:	6a 0a                	push   $0xa
  100389:	e8 30 ff ff ff       	call   1002be <cputch>
  10038e:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100391:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100394:	c9                   	leave  
  100395:	c3                   	ret    

00100396 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100396:	55                   	push   %ebp
  100397:	89 e5                	mov    %esp,%ebp
  100399:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10039c:	90                   	nop
  10039d:	e8 3c 12 00 00       	call   1015de <cons_getc>
  1003a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a9:	74 f2                	je     10039d <getchar+0x7>
        /* do nothing */;
    return c;
  1003ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003ae:	c9                   	leave  
  1003af:	c3                   	ret    

001003b0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b0:	55                   	push   %ebp
  1003b1:	89 e5                	mov    %esp,%ebp
  1003b3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003b9:	8b 00                	mov    (%eax),%eax
  1003bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003be:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c1:	8b 00                	mov    (%eax),%eax
  1003c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003cd:	e9 d2 00 00 00       	jmp    1004a4 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	01 d0                	add    %edx,%eax
  1003da:	89 c2                	mov    %eax,%edx
  1003dc:	c1 ea 1f             	shr    $0x1f,%edx
  1003df:	01 d0                	add    %edx,%eax
  1003e1:	d1 f8                	sar    %eax
  1003e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ec:	eb 04                	jmp    1003f2 <stab_binsearch+0x42>
            m --;
  1003ee:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003f8:	7c 1f                	jl     100419 <stab_binsearch+0x69>
  1003fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003fd:	89 d0                	mov    %edx,%eax
  1003ff:	01 c0                	add    %eax,%eax
  100401:	01 d0                	add    %edx,%eax
  100403:	c1 e0 02             	shl    $0x2,%eax
  100406:	89 c2                	mov    %eax,%edx
  100408:	8b 45 08             	mov    0x8(%ebp),%eax
  10040b:	01 d0                	add    %edx,%eax
  10040d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100411:	0f b6 c0             	movzbl %al,%eax
  100414:	39 45 14             	cmp    %eax,0x14(%ebp)
  100417:	75 d5                	jne    1003ee <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10041f:	7d 0b                	jge    10042c <stab_binsearch+0x7c>
            l = true_m + 1;
  100421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100424:	83 c0 01             	add    $0x1,%eax
  100427:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042a:	eb 78                	jmp    1004a4 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	8b 40 08             	mov    0x8(%eax),%eax
  100449:	39 45 18             	cmp    %eax,0x18(%ebp)
  10044c:	76 13                	jbe    100461 <stab_binsearch+0xb1>
            *region_left = m;
  10044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100454:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100459:	83 c0 01             	add    $0x1,%eax
  10045c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10045f:	eb 43                	jmp    1004a4 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100461:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100464:	89 d0                	mov    %edx,%eax
  100466:	01 c0                	add    %eax,%eax
  100468:	01 d0                	add    %edx,%eax
  10046a:	c1 e0 02             	shl    $0x2,%eax
  10046d:	89 c2                	mov    %eax,%edx
  10046f:	8b 45 08             	mov    0x8(%ebp),%eax
  100472:	01 d0                	add    %edx,%eax
  100474:	8b 40 08             	mov    0x8(%eax),%eax
  100477:	39 45 18             	cmp    %eax,0x18(%ebp)
  10047a:	73 16                	jae    100492 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10047f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100482:	8b 45 10             	mov    0x10(%ebp),%eax
  100485:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048a:	83 e8 01             	sub    $0x1,%eax
  10048d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100490:	eb 12                	jmp    1004a4 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100498:	89 10                	mov    %edx,(%eax)
            l = m;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a0:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1004a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004aa:	0f 8e 22 ff ff ff    	jle    1003d2 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b4:	75 0f                	jne    1004c5 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b9:	8b 00                	mov    (%eax),%eax
  1004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004be:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004c3:	eb 3f                	jmp    100504 <stab_binsearch+0x154>
        l = *region_right;
  1004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c8:	8b 00                	mov    (%eax),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004cd:	eb 04                	jmp    1004d3 <stab_binsearch+0x123>
  1004cf:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d6:	8b 00                	mov    (%eax),%eax
  1004d8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004db:	7e 1f                	jle    1004fc <stab_binsearch+0x14c>
  1004dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e0:	89 d0                	mov    %edx,%eax
  1004e2:	01 c0                	add    %eax,%eax
  1004e4:	01 d0                	add    %edx,%eax
  1004e6:	c1 e0 02             	shl    $0x2,%eax
  1004e9:	89 c2                	mov    %eax,%edx
  1004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ee:	01 d0                	add    %edx,%eax
  1004f0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f4:	0f b6 c0             	movzbl %al,%eax
  1004f7:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004fa:	75 d3                	jne    1004cf <stab_binsearch+0x11f>
        *region_left = l;
  1004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100502:	89 10                	mov    %edx,(%eax)
}
  100504:	90                   	nop
  100505:	c9                   	leave  
  100506:	c3                   	ret    

00100507 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100507:	55                   	push   %ebp
  100508:	89 e5                	mov    %esp,%ebp
  10050a:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100510:	c7 00 2c 36 10 00    	movl   $0x10362c,(%eax)
    info->eip_line = 0;
  100516:	8b 45 0c             	mov    0xc(%ebp),%eax
  100519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100520:	8b 45 0c             	mov    0xc(%ebp),%eax
  100523:	c7 40 08 2c 36 10 00 	movl   $0x10362c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	8b 55 08             	mov    0x8(%ebp),%edx
  10053a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100547:	c7 45 f4 ac 3e 10 00 	movl   $0x103eac,-0xc(%ebp)
    stab_end = __STAB_END__;
  10054e:	c7 45 f0 9c bd 10 00 	movl   $0x10bd9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100555:	c7 45 ec 9d bd 10 00 	movl   $0x10bd9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055c:	c7 45 e8 28 e7 10 00 	movl   $0x10e728,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100566:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100569:	76 0d                	jbe    100578 <debuginfo_eip+0x71>
  10056b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10056e:	83 e8 01             	sub    $0x1,%eax
  100571:	0f b6 00             	movzbl (%eax),%eax
  100574:	84 c0                	test   %al,%al
  100576:	74 0a                	je     100582 <debuginfo_eip+0x7b>
        return -1;
  100578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057d:	e9 85 02 00 00       	jmp    100807 <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100582:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10058f:	c1 f8 02             	sar    $0x2,%eax
  100592:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100598:	83 e8 01             	sub    $0x1,%eax
  10059b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10059e:	ff 75 08             	push   0x8(%ebp)
  1005a1:	6a 64                	push   $0x64
  1005a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005a6:	50                   	push   %eax
  1005a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005aa:	50                   	push   %eax
  1005ab:	ff 75 f4             	push   -0xc(%ebp)
  1005ae:	e8 fd fd ff ff       	call   1003b0 <stab_binsearch>
  1005b3:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1005b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005b9:	85 c0                	test   %eax,%eax
  1005bb:	75 0a                	jne    1005c7 <debuginfo_eip+0xc0>
        return -1;
  1005bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c2:	e9 40 02 00 00       	jmp    100807 <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005d3:	ff 75 08             	push   0x8(%ebp)
  1005d6:	6a 24                	push   $0x24
  1005d8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005db:	50                   	push   %eax
  1005dc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1005df:	50                   	push   %eax
  1005e0:	ff 75 f4             	push   -0xc(%ebp)
  1005e3:	e8 c8 fd ff ff       	call   1003b0 <stab_binsearch>
  1005e8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1005eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1005ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1005f1:	39 c2                	cmp    %eax,%edx
  1005f3:	7f 78                	jg     10066d <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1005f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1005f8:	89 c2                	mov    %eax,%edx
  1005fa:	89 d0                	mov    %edx,%eax
  1005fc:	01 c0                	add    %eax,%eax
  1005fe:	01 d0                	add    %edx,%eax
  100600:	c1 e0 02             	shl    $0x2,%eax
  100603:	89 c2                	mov    %eax,%edx
  100605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100608:	01 d0                	add    %edx,%eax
  10060a:	8b 10                	mov    (%eax),%edx
  10060c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10060f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100612:	39 c2                	cmp    %eax,%edx
  100614:	73 22                	jae    100638 <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100619:	89 c2                	mov    %eax,%edx
  10061b:	89 d0                	mov    %edx,%eax
  10061d:	01 c0                	add    %eax,%eax
  10061f:	01 d0                	add    %edx,%eax
  100621:	c1 e0 02             	shl    $0x2,%eax
  100624:	89 c2                	mov    %eax,%edx
  100626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100629:	01 d0                	add    %edx,%eax
  10062b:	8b 10                	mov    (%eax),%edx
  10062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100630:	01 c2                	add    %eax,%edx
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100638:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10063b:	89 c2                	mov    %eax,%edx
  10063d:	89 d0                	mov    %edx,%eax
  10063f:	01 c0                	add    %eax,%eax
  100641:	01 d0                	add    %edx,%eax
  100643:	c1 e0 02             	shl    $0x2,%eax
  100646:	89 c2                	mov    %eax,%edx
  100648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10064b:	01 d0                	add    %edx,%eax
  10064d:	8b 50 08             	mov    0x8(%eax),%edx
  100650:	8b 45 0c             	mov    0xc(%ebp),%eax
  100653:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100656:	8b 45 0c             	mov    0xc(%ebp),%eax
  100659:	8b 40 10             	mov    0x10(%eax),%eax
  10065c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10065f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100662:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100668:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10066b:	eb 15                	jmp    100682 <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100670:	8b 55 08             	mov    0x8(%ebp),%edx
  100673:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100679:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10067c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10067f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100682:	8b 45 0c             	mov    0xc(%ebp),%eax
  100685:	8b 40 08             	mov    0x8(%eax),%eax
  100688:	83 ec 08             	sub    $0x8,%esp
  10068b:	6a 3a                	push   $0x3a
  10068d:	50                   	push   %eax
  10068e:	e8 d7 2b 00 00       	call   10326a <strfind>
  100693:	83 c4 10             	add    $0x10,%esp
  100696:	8b 55 0c             	mov    0xc(%ebp),%edx
  100699:	8b 4a 08             	mov    0x8(%edx),%ecx
  10069c:	29 c8                	sub    %ecx,%eax
  10069e:	89 c2                	mov    %eax,%edx
  1006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a3:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006a6:	83 ec 0c             	sub    $0xc,%esp
  1006a9:	ff 75 08             	push   0x8(%ebp)
  1006ac:	6a 44                	push   $0x44
  1006ae:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006b1:	50                   	push   %eax
  1006b2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006b5:	50                   	push   %eax
  1006b6:	ff 75 f4             	push   -0xc(%ebp)
  1006b9:	e8 f2 fc ff ff       	call   1003b0 <stab_binsearch>
  1006be:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1006c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006c7:	39 c2                	cmp    %eax,%edx
  1006c9:	7f 24                	jg     1006ef <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
  1006cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1006ce:	89 c2                	mov    %eax,%edx
  1006d0:	89 d0                	mov    %edx,%eax
  1006d2:	01 c0                	add    %eax,%eax
  1006d4:	01 d0                	add    %edx,%eax
  1006d6:	c1 e0 02             	shl    $0x2,%eax
  1006d9:	89 c2                	mov    %eax,%edx
  1006db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1006e4:	0f b7 d0             	movzwl %ax,%edx
  1006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ea:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1006ed:	eb 13                	jmp    100702 <debuginfo_eip+0x1fb>
        return -1;
  1006ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f4:	e9 0e 01 00 00       	jmp    100807 <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1006f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1006fc:	83 e8 01             	sub    $0x1,%eax
  1006ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100702:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100708:	39 c2                	cmp    %eax,%edx
  10070a:	7c 56                	jl     100762 <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
  10070c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10070f:	89 c2                	mov    %eax,%edx
  100711:	89 d0                	mov    %edx,%eax
  100713:	01 c0                	add    %eax,%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	c1 e0 02             	shl    $0x2,%eax
  10071a:	89 c2                	mov    %eax,%edx
  10071c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071f:	01 d0                	add    %edx,%eax
  100721:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100725:	3c 84                	cmp    $0x84,%al
  100727:	74 39                	je     100762 <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10072c:	89 c2                	mov    %eax,%edx
  10072e:	89 d0                	mov    %edx,%eax
  100730:	01 c0                	add    %eax,%eax
  100732:	01 d0                	add    %edx,%eax
  100734:	c1 e0 02             	shl    $0x2,%eax
  100737:	89 c2                	mov    %eax,%edx
  100739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073c:	01 d0                	add    %edx,%eax
  10073e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100742:	3c 64                	cmp    $0x64,%al
  100744:	75 b3                	jne    1006f9 <debuginfo_eip+0x1f2>
  100746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	89 d0                	mov    %edx,%eax
  10074d:	01 c0                	add    %eax,%eax
  10074f:	01 d0                	add    %edx,%eax
  100751:	c1 e0 02             	shl    $0x2,%eax
  100754:	89 c2                	mov    %eax,%edx
  100756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100759:	01 d0                	add    %edx,%eax
  10075b:	8b 40 08             	mov    0x8(%eax),%eax
  10075e:	85 c0                	test   %eax,%eax
  100760:	74 97                	je     1006f9 <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100762:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100768:	39 c2                	cmp    %eax,%edx
  10076a:	7c 42                	jl     1007ae <debuginfo_eip+0x2a7>
  10076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	89 d0                	mov    %edx,%eax
  100773:	01 c0                	add    %eax,%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	c1 e0 02             	shl    $0x2,%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	8b 10                	mov    (%eax),%edx
  100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	73 21                	jae    1007ae <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 10                	mov    (%eax),%edx
  1007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a7:	01 c2                	add    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007b4:	39 c2                	cmp    %eax,%edx
  1007b6:	7d 4a                	jge    100802 <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
  1007b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007bb:	83 c0 01             	add    $0x1,%eax
  1007be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007c1:	eb 18                	jmp    1007db <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c6:	8b 40 14             	mov    0x14(%eax),%eax
  1007c9:	8d 50 01             	lea    0x1(%eax),%edx
  1007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cf:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1007d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d5:	83 c0 01             	add    $0x1,%eax
  1007d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1007db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e1:	39 c2                	cmp    %eax,%edx
  1007e3:	7d 1d                	jge    100802 <debuginfo_eip+0x2fb>
  1007e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	89 d0                	mov    %edx,%eax
  1007ec:	01 c0                	add    %eax,%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	c1 e0 02             	shl    $0x2,%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f8:	01 d0                	add    %edx,%eax
  1007fa:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fe:	3c a0                	cmp    $0xa0,%al
  100800:	74 c1                	je     1007c3 <debuginfo_eip+0x2bc>
        }
    }
    return 0;
  100802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100807:	c9                   	leave  
  100808:	c3                   	ret    

00100809 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100809:	55                   	push   %ebp
  10080a:	89 e5                	mov    %esp,%ebp
  10080c:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10080f:	83 ec 0c             	sub    $0xc,%esp
  100812:	68 36 36 10 00       	push   $0x103636
  100817:	e8 ef fa ff ff       	call   10030b <cprintf>
  10081c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10081f:	83 ec 08             	sub    $0x8,%esp
  100822:	68 00 00 10 00       	push   $0x100000
  100827:	68 4f 36 10 00       	push   $0x10364f
  10082c:	e8 da fa ff ff       	call   10030b <cprintf>
  100831:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100834:	83 ec 08             	sub    $0x8,%esp
  100837:	68 7e 35 10 00       	push   $0x10357e
  10083c:	68 67 36 10 00       	push   $0x103667
  100841:	e8 c5 fa ff ff       	call   10030b <cprintf>
  100846:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100849:	83 ec 08             	sub    $0x8,%esp
  10084c:	68 16 fa 10 00       	push   $0x10fa16
  100851:	68 7f 36 10 00       	push   $0x10367f
  100856:	e8 b0 fa ff ff       	call   10030b <cprintf>
  10085b:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10085e:	83 ec 08             	sub    $0x8,%esp
  100861:	68 68 0d 11 00       	push   $0x110d68
  100866:	68 97 36 10 00       	push   $0x103697
  10086b:	e8 9b fa ff ff       	call   10030b <cprintf>
  100870:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100873:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  100878:	2d 00 00 10 00       	sub    $0x100000,%eax
  10087d:	05 ff 03 00 00       	add    $0x3ff,%eax
  100882:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100888:	85 c0                	test   %eax,%eax
  10088a:	0f 48 c2             	cmovs  %edx,%eax
  10088d:	c1 f8 0a             	sar    $0xa,%eax
  100890:	83 ec 08             	sub    $0x8,%esp
  100893:	50                   	push   %eax
  100894:	68 b0 36 10 00       	push   $0x1036b0
  100899:	e8 6d fa ff ff       	call   10030b <cprintf>
  10089e:	83 c4 10             	add    $0x10,%esp
}
  1008a1:	90                   	nop
  1008a2:	c9                   	leave  
  1008a3:	c3                   	ret    

001008a4 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008a4:	55                   	push   %ebp
  1008a5:	89 e5                	mov    %esp,%ebp
  1008a7:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008ad:	83 ec 08             	sub    $0x8,%esp
  1008b0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008b3:	50                   	push   %eax
  1008b4:	ff 75 08             	push   0x8(%ebp)
  1008b7:	e8 4b fc ff ff       	call   100507 <debuginfo_eip>
  1008bc:	83 c4 10             	add    $0x10,%esp
  1008bf:	85 c0                	test   %eax,%eax
  1008c1:	74 15                	je     1008d8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008c3:	83 ec 08             	sub    $0x8,%esp
  1008c6:	ff 75 08             	push   0x8(%ebp)
  1008c9:	68 da 36 10 00       	push   $0x1036da
  1008ce:	e8 38 fa ff ff       	call   10030b <cprintf>
  1008d3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1008d6:	eb 65                	jmp    10093d <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1008df:	eb 1c                	jmp    1008fd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1008e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e7:	01 d0                	add    %edx,%eax
  1008e9:	0f b6 00             	movzbl (%eax),%eax
  1008ec:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1008f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008f5:	01 ca                	add    %ecx,%edx
  1008f7:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1008f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1008fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100900:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100903:	7c dc                	jl     1008e1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100905:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100913:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	29 d0                	sub    %edx,%eax
  10091b:	89 c1                	mov    %eax,%ecx
  10091d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100920:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100923:	83 ec 0c             	sub    $0xc,%esp
  100926:	51                   	push   %ecx
  100927:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092d:	51                   	push   %ecx
  10092e:	52                   	push   %edx
  10092f:	50                   	push   %eax
  100930:	68 f6 36 10 00       	push   $0x1036f6
  100935:	e8 d1 f9 ff ff       	call   10030b <cprintf>
  10093a:	83 c4 20             	add    $0x20,%esp
}
  10093d:	90                   	nop
  10093e:	c9                   	leave  
  10093f:	c3                   	ret    

00100940 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100940:	55                   	push   %ebp
  100941:	89 e5                	mov    %esp,%ebp
  100943:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100946:	8b 45 04             	mov    0x4(%ebp),%eax
  100949:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10094f:	c9                   	leave  
  100950:	c3                   	ret    

00100951 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100951:	55                   	push   %ebp
  100952:	89 e5                	mov    %esp,%ebp
  100954:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100957:	89 e8                	mov    %ebp,%eax
  100959:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10095c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  10095f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100962:	e8 d9 ff ff ff       	call   100940 <read_eip>
  100967:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  10096a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100971:	e9 8d 00 00 00       	jmp    100a03 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100976:	83 ec 04             	sub    $0x4,%esp
  100979:	ff 75 f0             	push   -0x10(%ebp)
  10097c:	ff 75 f4             	push   -0xc(%ebp)
  10097f:	68 08 37 10 00       	push   $0x103708
  100984:	e8 82 f9 ff ff       	call   10030b <cprintf>
  100989:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  10098c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10098f:	83 c0 08             	add    $0x8,%eax
  100992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10099c:	eb 26                	jmp    1009c4 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  10099e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ab:	01 d0                	add    %edx,%eax
  1009ad:	8b 00                	mov    (%eax),%eax
  1009af:	83 ec 08             	sub    $0x8,%esp
  1009b2:	50                   	push   %eax
  1009b3:	68 24 37 10 00       	push   $0x103724
  1009b8:	e8 4e f9 ff ff       	call   10030b <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  1009c0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  1009c4:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  1009c8:	7e d4                	jle    10099e <print_stackframe+0x4d>
        }
        cprintf("\n");
  1009ca:	83 ec 0c             	sub    $0xc,%esp
  1009cd:	68 2c 37 10 00       	push   $0x10372c
  1009d2:	e8 34 f9 ff ff       	call   10030b <cprintf>
  1009d7:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  1009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009dd:	83 e8 01             	sub    $0x1,%eax
  1009e0:	83 ec 0c             	sub    $0xc,%esp
  1009e3:	50                   	push   %eax
  1009e4:	e8 bb fe ff ff       	call   1008a4 <print_debuginfo>
  1009e9:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  1009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ef:	83 c0 04             	add    $0x4,%eax
  1009f2:	8b 00                	mov    (%eax),%eax
  1009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  1009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fa:	8b 00                	mov    (%eax),%eax
  1009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009ff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a07:	74 0a                	je     100a13 <print_stackframe+0xc2>
  100a09:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a0d:	0f 8e 63 ff ff ff    	jle    100976 <print_stackframe+0x25>
    }
}
  100a13:	90                   	nop
  100a14:	c9                   	leave  
  100a15:	c3                   	ret    

00100a16 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a16:	55                   	push   %ebp
  100a17:	89 e5                	mov    %esp,%ebp
  100a19:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100a1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a23:	eb 0c                	jmp    100a31 <parse+0x1b>
            *buf ++ = '\0';
  100a25:	8b 45 08             	mov    0x8(%ebp),%eax
  100a28:	8d 50 01             	lea    0x1(%eax),%edx
  100a2b:	89 55 08             	mov    %edx,0x8(%ebp)
  100a2e:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a31:	8b 45 08             	mov    0x8(%ebp),%eax
  100a34:	0f b6 00             	movzbl (%eax),%eax
  100a37:	84 c0                	test   %al,%al
  100a39:	74 1e                	je     100a59 <parse+0x43>
  100a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3e:	0f b6 00             	movzbl (%eax),%eax
  100a41:	0f be c0             	movsbl %al,%eax
  100a44:	83 ec 08             	sub    $0x8,%esp
  100a47:	50                   	push   %eax
  100a48:	68 b0 37 10 00       	push   $0x1037b0
  100a4d:	e8 e5 27 00 00       	call   103237 <strchr>
  100a52:	83 c4 10             	add    $0x10,%esp
  100a55:	85 c0                	test   %eax,%eax
  100a57:	75 cc                	jne    100a25 <parse+0xf>
        }
        if (*buf == '\0') {
  100a59:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5c:	0f b6 00             	movzbl (%eax),%eax
  100a5f:	84 c0                	test   %al,%al
  100a61:	74 65                	je     100ac8 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a63:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a67:	75 12                	jne    100a7b <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a69:	83 ec 08             	sub    $0x8,%esp
  100a6c:	6a 10                	push   $0x10
  100a6e:	68 b5 37 10 00       	push   $0x1037b5
  100a73:	e8 93 f8 ff ff       	call   10030b <cprintf>
  100a78:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7e:	8d 50 01             	lea    0x1(%eax),%edx
  100a81:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a8e:	01 c2                	add    %eax,%edx
  100a90:	8b 45 08             	mov    0x8(%ebp),%eax
  100a93:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a95:	eb 04                	jmp    100a9b <parse+0x85>
            buf ++;
  100a97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 8c                	je     100a31 <parse+0x1b>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	83 ec 08             	sub    $0x8,%esp
  100ab1:	50                   	push   %eax
  100ab2:	68 b0 37 10 00       	push   $0x1037b0
  100ab7:	e8 7b 27 00 00       	call   103237 <strchr>
  100abc:	83 c4 10             	add    $0x10,%esp
  100abf:	85 c0                	test   %eax,%eax
  100ac1:	74 d4                	je     100a97 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac3:	e9 69 ff ff ff       	jmp    100a31 <parse+0x1b>
            break;
  100ac8:	90                   	nop
        }
    }
    return argc;
  100ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100acc:	c9                   	leave  
  100acd:	c3                   	ret    

00100ace <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ace:	55                   	push   %ebp
  100acf:	89 e5                	mov    %esp,%ebp
  100ad1:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ad4:	83 ec 08             	sub    $0x8,%esp
  100ad7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ada:	50                   	push   %eax
  100adb:	ff 75 08             	push   0x8(%ebp)
  100ade:	e8 33 ff ff ff       	call   100a16 <parse>
  100ae3:	83 c4 10             	add    $0x10,%esp
  100ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100ae9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100aed:	75 0a                	jne    100af9 <runcmd+0x2b>
        return 0;
  100aef:	b8 00 00 00 00       	mov    $0x0,%eax
  100af4:	e9 83 00 00 00       	jmp    100b7c <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b00:	eb 59                	jmp    100b5b <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b02:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b08:	89 c8                	mov    %ecx,%eax
  100b0a:	01 c0                	add    %eax,%eax
  100b0c:	01 c8                	add    %ecx,%eax
  100b0e:	c1 e0 02             	shl    $0x2,%eax
  100b11:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b16:	8b 00                	mov    (%eax),%eax
  100b18:	83 ec 08             	sub    $0x8,%esp
  100b1b:	52                   	push   %edx
  100b1c:	50                   	push   %eax
  100b1d:	e8 76 26 00 00       	call   103198 <strcmp>
  100b22:	83 c4 10             	add    $0x10,%esp
  100b25:	85 c0                	test   %eax,%eax
  100b27:	75 2e                	jne    100b57 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b2c:	89 d0                	mov    %edx,%eax
  100b2e:	01 c0                	add    %eax,%eax
  100b30:	01 d0                	add    %edx,%eax
  100b32:	c1 e0 02             	shl    $0x2,%eax
  100b35:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b3a:	8b 10                	mov    (%eax),%edx
  100b3c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3f:	83 c0 04             	add    $0x4,%eax
  100b42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b45:	83 e9 01             	sub    $0x1,%ecx
  100b48:	83 ec 04             	sub    $0x4,%esp
  100b4b:	ff 75 0c             	push   0xc(%ebp)
  100b4e:	50                   	push   %eax
  100b4f:	51                   	push   %ecx
  100b50:	ff d2                	call   *%edx
  100b52:	83 c4 10             	add    $0x10,%esp
  100b55:	eb 25                	jmp    100b7c <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5e:	83 f8 02             	cmp    $0x2,%eax
  100b61:	76 9f                	jbe    100b02 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b66:	83 ec 08             	sub    $0x8,%esp
  100b69:	50                   	push   %eax
  100b6a:	68 d3 37 10 00       	push   $0x1037d3
  100b6f:	e8 97 f7 ff ff       	call   10030b <cprintf>
  100b74:	83 c4 10             	add    $0x10,%esp
    return 0;
  100b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b7c:	c9                   	leave  
  100b7d:	c3                   	ret    

00100b7e <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b7e:	55                   	push   %ebp
  100b7f:	89 e5                	mov    %esp,%ebp
  100b81:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b84:	83 ec 0c             	sub    $0xc,%esp
  100b87:	68 ec 37 10 00       	push   $0x1037ec
  100b8c:	e8 7a f7 ff ff       	call   10030b <cprintf>
  100b91:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100b94:	83 ec 0c             	sub    $0xc,%esp
  100b97:	68 14 38 10 00       	push   $0x103814
  100b9c:	e8 6a f7 ff ff       	call   10030b <cprintf>
  100ba1:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ba4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ba8:	74 0e                	je     100bb8 <kmonitor+0x3a>
        print_trapframe(tf);
  100baa:	83 ec 0c             	sub    $0xc,%esp
  100bad:	ff 75 08             	push   0x8(%ebp)
  100bb0:	e8 5e 0e 00 00       	call   101a13 <print_trapframe>
  100bb5:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bb8:	83 ec 0c             	sub    $0xc,%esp
  100bbb:	68 39 38 10 00       	push   $0x103839
  100bc0:	e8 37 f6 ff ff       	call   1001fc <readline>
  100bc5:	83 c4 10             	add    $0x10,%esp
  100bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bcf:	74 e7                	je     100bb8 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100bd1:	83 ec 08             	sub    $0x8,%esp
  100bd4:	ff 75 08             	push   0x8(%ebp)
  100bd7:	ff 75 f4             	push   -0xc(%ebp)
  100bda:	e8 ef fe ff ff       	call   100ace <runcmd>
  100bdf:	83 c4 10             	add    $0x10,%esp
  100be2:	85 c0                	test   %eax,%eax
  100be4:	78 02                	js     100be8 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100be6:	eb d0                	jmp    100bb8 <kmonitor+0x3a>
                break;
  100be8:	90                   	nop
            }
        }
    }
}
  100be9:	90                   	nop
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf9:	eb 3c                	jmp    100c37 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfe:	89 d0                	mov    %edx,%eax
  100c00:	01 c0                	add    %eax,%eax
  100c02:	01 d0                	add    %edx,%eax
  100c04:	c1 e0 02             	shl    $0x2,%eax
  100c07:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c0c:	8b 10                	mov    (%eax),%edx
  100c0e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c11:	89 c8                	mov    %ecx,%eax
  100c13:	01 c0                	add    %eax,%eax
  100c15:	01 c8                	add    %ecx,%eax
  100c17:	c1 e0 02             	shl    $0x2,%eax
  100c1a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c1f:	8b 00                	mov    (%eax),%eax
  100c21:	83 ec 04             	sub    $0x4,%esp
  100c24:	52                   	push   %edx
  100c25:	50                   	push   %eax
  100c26:	68 3d 38 10 00       	push   $0x10383d
  100c2b:	e8 db f6 ff ff       	call   10030b <cprintf>
  100c30:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100c33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	83 f8 02             	cmp    $0x2,%eax
  100c3d:	76 bc                	jbe    100bfb <mon_help+0xf>
    }
    return 0;
  100c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c44:	c9                   	leave  
  100c45:	c3                   	ret    

00100c46 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c46:	55                   	push   %ebp
  100c47:	89 e5                	mov    %esp,%ebp
  100c49:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c4c:	e8 b8 fb ff ff       	call   100809 <print_kerninfo>
    return 0;
  100c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c56:	c9                   	leave  
  100c57:	c3                   	ret    

00100c58 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c58:	55                   	push   %ebp
  100c59:	89 e5                	mov    %esp,%ebp
  100c5b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c5e:	e8 ee fc ff ff       	call   100951 <print_stackframe>
    return 0;
  100c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c68:	c9                   	leave  
  100c69:	c3                   	ret    

00100c6a <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c6a:	55                   	push   %ebp
  100c6b:	89 e5                	mov    %esp,%ebp
  100c6d:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  100c70:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100c75:	85 c0                	test   %eax,%eax
  100c77:	75 5f                	jne    100cd8 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100c79:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100c80:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c83:	8d 45 14             	lea    0x14(%ebp),%eax
  100c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c89:	83 ec 04             	sub    $0x4,%esp
  100c8c:	ff 75 0c             	push   0xc(%ebp)
  100c8f:	ff 75 08             	push   0x8(%ebp)
  100c92:	68 46 38 10 00       	push   $0x103846
  100c97:	e8 6f f6 ff ff       	call   10030b <cprintf>
  100c9c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca2:	83 ec 08             	sub    $0x8,%esp
  100ca5:	50                   	push   %eax
  100ca6:	ff 75 10             	push   0x10(%ebp)
  100ca9:	e8 34 f6 ff ff       	call   1002e2 <vcprintf>
  100cae:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100cb1:	83 ec 0c             	sub    $0xc,%esp
  100cb4:	68 62 38 10 00       	push   $0x103862
  100cb9:	e8 4d f6 ff ff       	call   10030b <cprintf>
  100cbe:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  100cc1:	83 ec 0c             	sub    $0xc,%esp
  100cc4:	68 64 38 10 00       	push   $0x103864
  100cc9:	e8 3d f6 ff ff       	call   10030b <cprintf>
  100cce:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  100cd1:	e8 7b fc ff ff       	call   100951 <print_stackframe>
  100cd6:	eb 01                	jmp    100cd9 <__panic+0x6f>
        goto panic_dead;
  100cd8:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100cd9:	e8 64 09 00 00       	call   101642 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cde:	83 ec 0c             	sub    $0xc,%esp
  100ce1:	6a 00                	push   $0x0
  100ce3:	e8 96 fe ff ff       	call   100b7e <kmonitor>
  100ce8:	83 c4 10             	add    $0x10,%esp
  100ceb:	eb f1                	jmp    100cde <__panic+0x74>

00100ced <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ced:	55                   	push   %ebp
  100cee:	89 e5                	mov    %esp,%ebp
  100cf0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cf9:	83 ec 04             	sub    $0x4,%esp
  100cfc:	ff 75 0c             	push   0xc(%ebp)
  100cff:	ff 75 08             	push   0x8(%ebp)
  100d02:	68 76 38 10 00       	push   $0x103876
  100d07:	e8 ff f5 ff ff       	call   10030b <cprintf>
  100d0c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d12:	83 ec 08             	sub    $0x8,%esp
  100d15:	50                   	push   %eax
  100d16:	ff 75 10             	push   0x10(%ebp)
  100d19:	e8 c4 f5 ff ff       	call   1002e2 <vcprintf>
  100d1e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100d21:	83 ec 0c             	sub    $0xc,%esp
  100d24:	68 62 38 10 00       	push   $0x103862
  100d29:	e8 dd f5 ff ff       	call   10030b <cprintf>
  100d2e:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100d31:	90                   	nop
  100d32:	c9                   	leave  
  100d33:	c3                   	ret    

00100d34 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d34:	55                   	push   %ebp
  100d35:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d37:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d3c:	5d                   	pop    %ebp
  100d3d:	c3                   	ret    

00100d3e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3e:	55                   	push   %ebp
  100d3f:	89 e5                	mov    %esp,%ebp
  100d41:	83 ec 18             	sub    $0x18,%esp
  100d44:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d4a:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d52:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d56:	ee                   	out    %al,(%dx)
}
  100d57:	90                   	nop
  100d58:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d62:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d66:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d6a:	ee                   	out    %al,(%dx)
}
  100d6b:	90                   	nop
  100d6c:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d72:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d76:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7e:	ee                   	out    %al,(%dx)
}
  100d7f:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d80:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100d87:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8a:	83 ec 0c             	sub    $0xc,%esp
  100d8d:	68 94 38 10 00       	push   $0x103894
  100d92:	e8 74 f5 ff ff       	call   10030b <cprintf>
  100d97:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9a:	83 ec 0c             	sub    $0xc,%esp
  100d9d:	6a 00                	push   $0x0
  100d9f:	e8 01 09 00 00       	call   1016a5 <pic_enable>
  100da4:	83 c4 10             	add    $0x10,%esp
}
  100da7:	90                   	nop
  100da8:	c9                   	leave  
  100da9:	c3                   	ret    

00100daa <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100daa:	55                   	push   %ebp
  100dab:	89 e5                	mov    %esp,%ebp
  100dad:	83 ec 10             	sub    $0x10,%esp
  100db0:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dba:	89 c2                	mov    %eax,%edx
  100dbc:	ec                   	in     (%dx),%al
  100dbd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dc0:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dca:	89 c2                	mov    %eax,%edx
  100dcc:	ec                   	in     (%dx),%al
  100dcd:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dda:	89 c2                	mov    %eax,%edx
  100ddc:	ec                   	in     (%dx),%al
  100ddd:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100de6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dea:	89 c2                	mov    %eax,%edx
  100dec:	ec                   	in     (%dx),%al
  100ded:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df0:	90                   	nop
  100df1:	c9                   	leave  
  100df2:	c3                   	ret    

00100df3 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100df3:	55                   	push   %ebp
  100df4:	89 e5                	mov    %esp,%ebp
  100df6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100df9:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e03:	0f b7 00             	movzwl (%eax),%eax
  100e06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e15:	0f b7 00             	movzwl (%eax),%eax
  100e18:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1c:	74 12                	je     100e30 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e1e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e25:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e2c:	b4 03 
  100e2e:	eb 13                	jmp    100e43 <cga_init+0x50>
    } else {
        *cp = was;
  100e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e33:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e37:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e3a:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e41:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e43:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e4a:	0f b7 c0             	movzwl %ax,%eax
  100e4d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e51:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e55:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e59:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e5d:	ee                   	out    %al,(%dx)
}
  100e5e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100e5f:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e66:	83 c0 01             	add    $0x1,%eax
  100e69:	0f b7 c0             	movzwl %ax,%eax
  100e6c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e70:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e74:	89 c2                	mov    %eax,%edx
  100e76:	ec                   	in     (%dx),%al
  100e77:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e7a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e7e:	0f b6 c0             	movzbl %al,%eax
  100e81:	c1 e0 08             	shl    $0x8,%eax
  100e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e87:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e8e:	0f b7 c0             	movzwl %ax,%eax
  100e91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e95:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ea1:	ee                   	out    %al,(%dx)
}
  100ea2:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100ea3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eaa:	83 c0 01             	add    $0x1,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb8:	89 c2                	mov    %eax,%edx
  100eba:	ec                   	in     (%dx),%al
  100ebb:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ebe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ec2:	0f b6 c0             	movzbl %al,%eax
  100ec5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;
  100ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed3:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100ed9:	90                   	nop
  100eda:	c9                   	leave  
  100edb:	c3                   	ret    

00100edc <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edc:	55                   	push   %ebp
  100edd:	89 e5                	mov    %esp,%ebp
  100edf:	83 ec 38             	sub    $0x38,%esp
  100ee2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ee8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eec:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ef0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ef4:	ee                   	out    %al,(%dx)
}
  100ef5:	90                   	nop
  100ef6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100efc:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f00:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f04:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f08:	ee                   	out    %al,(%dx)
}
  100f09:	90                   	nop
  100f0a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f10:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f14:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f18:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
}
  100f1d:	90                   	nop
  100f1e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f24:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f28:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f2c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f30:	ee                   	out    %al,(%dx)
}
  100f31:	90                   	nop
  100f32:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f38:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f3c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f40:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
}
  100f45:	90                   	nop
  100f46:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f4c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f54:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f58:	ee                   	out    %al,(%dx)
}
  100f59:	90                   	nop
  100f5a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f60:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f64:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f68:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6c:	ee                   	out    %al,(%dx)
}
  100f6d:	90                   	nop
  100f6e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f74:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f78:	89 c2                	mov    %eax,%edx
  100f7a:	ec                   	in     (%dx),%al
  100f7b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f7e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f82:	3c ff                	cmp    $0xff,%al
  100f84:	0f 95 c0             	setne  %al
  100f87:	0f b6 c0             	movzbl %al,%eax
  100f8a:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f8f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f95:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f9f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fa5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100faf:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fb4:	85 c0                	test   %eax,%eax
  100fb6:	74 0d                	je     100fc5 <serial_init+0xe9>
        pic_enable(IRQ_COM1);
  100fb8:	83 ec 0c             	sub    $0xc,%esp
  100fbb:	6a 04                	push   $0x4
  100fbd:	e8 e3 06 00 00       	call   1016a5 <pic_enable>
  100fc2:	83 c4 10             	add    $0x10,%esp
    }
}
  100fc5:	90                   	nop
  100fc6:	c9                   	leave  
  100fc7:	c3                   	ret    

00100fc8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc8:	55                   	push   %ebp
  100fc9:	89 e5                	mov    %esp,%ebp
  100fcb:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd5:	eb 09                	jmp    100fe0 <lpt_putc_sub+0x18>
        delay();
  100fd7:	e8 ce fd ff ff       	call   100daa <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff4:	84 c0                	test   %al,%al
  100ff6:	78 09                	js     101001 <lpt_putc_sub+0x39>
  100ff8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fff:	7e d6                	jle    100fd7 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101001:	8b 45 08             	mov    0x8(%ebp),%eax
  101004:	0f b6 c0             	movzbl %al,%eax
  101007:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101014:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
}
  101019:	90                   	nop
  10101a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101020:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101024:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101028:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102c:	ee                   	out    %al,(%dx)
}
  10102d:	90                   	nop
  10102e:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101034:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101038:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101040:	ee                   	out    %al,(%dx)
}
  101041:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101042:	90                   	nop
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101048:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104c:	74 0d                	je     10105b <lpt_putc+0x16>
        lpt_putc_sub(c);
  10104e:	ff 75 08             	push   0x8(%ebp)
  101051:	e8 72 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101056:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101059:	eb 1e                	jmp    101079 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10105b:	6a 08                	push   $0x8
  10105d:	e8 66 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101062:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101065:	6a 20                	push   $0x20
  101067:	e8 5c ff ff ff       	call   100fc8 <lpt_putc_sub>
  10106c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10106f:	6a 08                	push   $0x8
  101071:	e8 52 ff ff ff       	call   100fc8 <lpt_putc_sub>
  101076:	83 c4 04             	add    $0x4,%esp
}
  101079:	90                   	nop
  10107a:	c9                   	leave  
  10107b:	c3                   	ret    

0010107c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107c:	55                   	push   %ebp
  10107d:	89 e5                	mov    %esp,%ebp
  10107f:	53                   	push   %ebx
  101080:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	b0 00                	mov    $0x0,%al
  101088:	85 c0                	test   %eax,%eax
  10108a:	75 07                	jne    101093 <cga_putc+0x17>
        c |= 0x0700;
  10108c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101093:	8b 45 08             	mov    0x8(%ebp),%eax
  101096:	0f b6 c0             	movzbl %al,%eax
  101099:	83 f8 0d             	cmp    $0xd,%eax
  10109c:	74 6b                	je     101109 <cga_putc+0x8d>
  10109e:	83 f8 0d             	cmp    $0xd,%eax
  1010a1:	0f 8f 9c 00 00 00    	jg     101143 <cga_putc+0xc7>
  1010a7:	83 f8 08             	cmp    $0x8,%eax
  1010aa:	74 0a                	je     1010b6 <cga_putc+0x3a>
  1010ac:	83 f8 0a             	cmp    $0xa,%eax
  1010af:	74 48                	je     1010f9 <cga_putc+0x7d>
  1010b1:	e9 8d 00 00 00       	jmp    101143 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010b6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010bd:	66 85 c0             	test   %ax,%ax
  1010c0:	0f 84 a3 00 00 00    	je     101169 <cga_putc+0xed>
            crt_pos --;
  1010c6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010cd:	83 e8 01             	sub    $0x1,%eax
  1010d0:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d9:	b0 00                	mov    $0x0,%al
  1010db:	83 c8 20             	or     $0x20,%eax
  1010de:	89 c2                	mov    %eax,%edx
  1010e0:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1010e6:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010ed:	0f b7 c0             	movzwl %ax,%eax
  1010f0:	01 c0                	add    %eax,%eax
  1010f2:	01 c8                	add    %ecx,%eax
  1010f4:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010f7:	eb 70                	jmp    101169 <cga_putc+0xed>
    case '\n':
        crt_pos += CRT_COLS;
  1010f9:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101100:	83 c0 50             	add    $0x50,%eax
  101103:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101109:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  101110:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101117:	0f b7 c1             	movzwl %cx,%eax
  10111a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101120:	c1 e8 10             	shr    $0x10,%eax
  101123:	89 c2                	mov    %eax,%edx
  101125:	66 c1 ea 06          	shr    $0x6,%dx
  101129:	89 d0                	mov    %edx,%eax
  10112b:	c1 e0 02             	shl    $0x2,%eax
  10112e:	01 d0                	add    %edx,%eax
  101130:	c1 e0 04             	shl    $0x4,%eax
  101133:	29 c1                	sub    %eax,%ecx
  101135:	89 ca                	mov    %ecx,%edx
  101137:	89 d8                	mov    %ebx,%eax
  101139:	29 d0                	sub    %edx,%eax
  10113b:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  101141:	eb 27                	jmp    10116a <cga_putc+0xee>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101143:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101149:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101150:	8d 50 01             	lea    0x1(%eax),%edx
  101153:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  10115a:	0f b7 c0             	movzwl %ax,%eax
  10115d:	01 c0                	add    %eax,%eax
  10115f:	01 c8                	add    %ecx,%eax
  101161:	8b 55 08             	mov    0x8(%ebp),%edx
  101164:	66 89 10             	mov    %dx,(%eax)
        break;
  101167:	eb 01                	jmp    10116a <cga_putc+0xee>
        break;
  101169:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10116a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101171:	66 3d cf 07          	cmp    $0x7cf,%ax
  101175:	76 5a                	jbe    1011d1 <cga_putc+0x155>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101177:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10117c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101182:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101187:	83 ec 04             	sub    $0x4,%esp
  10118a:	68 00 0f 00 00       	push   $0xf00
  10118f:	52                   	push   %edx
  101190:	50                   	push   %eax
  101191:	e8 9e 22 00 00       	call   103434 <memmove>
  101196:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101199:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011a0:	eb 16                	jmp    1011b8 <cga_putc+0x13c>
            crt_buf[i] = 0x0700 | ' ';
  1011a2:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  1011a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011ab:	01 c0                	add    %eax,%eax
  1011ad:	01 d0                	add    %edx,%eax
  1011af:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011bf:	7e e1                	jle    1011a2 <cga_putc+0x126>
        }
        crt_pos -= CRT_COLS;
  1011c1:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011c8:	83 e8 50             	sub    $0x50,%eax
  1011cb:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011d1:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1011d8:	0f b7 c0             	movzwl %ax,%eax
  1011db:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011df:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011e3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011e7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011eb:	ee                   	out    %al,(%dx)
}
  1011ec:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ed:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f4:	66 c1 e8 08          	shr    $0x8,%ax
  1011f8:	0f b6 c0             	movzbl %al,%eax
  1011fb:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101202:	83 c2 01             	add    $0x1,%edx
  101205:	0f b7 d2             	movzwl %dx,%edx
  101208:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10120c:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10120f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101213:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101217:	ee                   	out    %al,(%dx)
}
  101218:	90                   	nop
    outb(addr_6845, 15);
  101219:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101220:	0f b7 c0             	movzwl %ax,%eax
  101223:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101227:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10122b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101233:	ee                   	out    %al,(%dx)
}
  101234:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101235:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10123c:	0f b6 c0             	movzbl %al,%eax
  10123f:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101246:	83 c2 01             	add    $0x1,%edx
  101249:	0f b7 d2             	movzwl %dx,%edx
  10124c:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101250:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101253:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101257:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
}
  10125c:	90                   	nop
}
  10125d:	90                   	nop
  10125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101261:	c9                   	leave  
  101262:	c3                   	ret    

00101263 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101263:	55                   	push   %ebp
  101264:	89 e5                	mov    %esp,%ebp
  101266:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101270:	eb 09                	jmp    10127b <serial_putc_sub+0x18>
        delay();
  101272:	e8 33 fb ff ff       	call   100daa <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101277:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10127b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101281:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101285:	89 c2                	mov    %eax,%edx
  101287:	ec                   	in     (%dx),%al
  101288:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10128f:	0f b6 c0             	movzbl %al,%eax
  101292:	83 e0 20             	and    $0x20,%eax
  101295:	85 c0                	test   %eax,%eax
  101297:	75 09                	jne    1012a2 <serial_putc_sub+0x3f>
  101299:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a0:	7e d0                	jle    101272 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ae:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b9:	ee                   	out    %al,(%dx)
}
  1012ba:	90                   	nop
}
  1012bb:	90                   	nop
  1012bc:	c9                   	leave  
  1012bd:	c3                   	ret    

001012be <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012be:	55                   	push   %ebp
  1012bf:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c5:	74 0d                	je     1012d4 <serial_putc+0x16>
        serial_putc_sub(c);
  1012c7:	ff 75 08             	push   0x8(%ebp)
  1012ca:	e8 94 ff ff ff       	call   101263 <serial_putc_sub>
  1012cf:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012d2:	eb 1e                	jmp    1012f2 <serial_putc+0x34>
        serial_putc_sub('\b');
  1012d4:	6a 08                	push   $0x8
  1012d6:	e8 88 ff ff ff       	call   101263 <serial_putc_sub>
  1012db:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012de:	6a 20                	push   $0x20
  1012e0:	e8 7e ff ff ff       	call   101263 <serial_putc_sub>
  1012e5:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012e8:	6a 08                	push   $0x8
  1012ea:	e8 74 ff ff ff       	call   101263 <serial_putc_sub>
  1012ef:	83 c4 04             	add    $0x4,%esp
}
  1012f2:	90                   	nop
  1012f3:	c9                   	leave  
  1012f4:	c3                   	ret    

001012f5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f5:	55                   	push   %ebp
  1012f6:	89 e5                	mov    %esp,%ebp
  1012f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012fb:	eb 33                	jmp    101330 <cons_intr+0x3b>
        if (c != 0) {
  1012fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101301:	74 2d                	je     101330 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101303:	a1 84 00 11 00       	mov    0x110084,%eax
  101308:	8d 50 01             	lea    0x1(%eax),%edx
  10130b:	89 15 84 00 11 00    	mov    %edx,0x110084
  101311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101314:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131a:	a1 84 00 11 00       	mov    0x110084,%eax
  10131f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101324:	75 0a                	jne    101330 <cons_intr+0x3b>
                cons.wpos = 0;
  101326:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  10132d:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101330:	8b 45 08             	mov    0x8(%ebp),%eax
  101333:	ff d0                	call   *%eax
  101335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101338:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10133c:	75 bf                	jne    1012fd <cons_intr+0x8>
            }
        }
    }
}
  10133e:	90                   	nop
  10133f:	90                   	nop
  101340:	c9                   	leave  
  101341:	c3                   	ret    

00101342 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101342:	55                   	push   %ebp
  101343:	89 e5                	mov    %esp,%ebp
  101345:	83 ec 10             	sub    $0x10,%esp
  101348:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10134e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101352:	89 c2                	mov    %eax,%edx
  101354:	ec                   	in     (%dx),%al
  101355:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101358:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	83 e0 01             	and    $0x1,%eax
  101362:	85 c0                	test   %eax,%eax
  101364:	75 07                	jne    10136d <serial_proc_data+0x2b>
        return -1;
  101366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136b:	eb 2a                	jmp    101397 <serial_proc_data+0x55>
  10136d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101373:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101377:	89 c2                	mov    %eax,%edx
  101379:	ec                   	in     (%dx),%al
  10137a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10137d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101387:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10138b:	75 07                	jne    101394 <serial_proc_data+0x52>
        c = '\b';
  10138d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101394:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101397:	c9                   	leave  
  101398:	c3                   	ret    

00101399 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101399:	55                   	push   %ebp
  10139a:	89 e5                	mov    %esp,%ebp
  10139c:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10139f:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1013a4:	85 c0                	test   %eax,%eax
  1013a6:	74 10                	je     1013b8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013a8:	83 ec 0c             	sub    $0xc,%esp
  1013ab:	68 42 13 10 00       	push   $0x101342
  1013b0:	e8 40 ff ff ff       	call   1012f5 <cons_intr>
  1013b5:	83 c4 10             	add    $0x10,%esp
    }
}
  1013b8:	90                   	nop
  1013b9:	c9                   	leave  
  1013ba:	c3                   	ret    

001013bb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013bb:	55                   	push   %ebp
  1013bc:	89 e5                	mov    %esp,%ebp
  1013be:	83 ec 28             	sub    $0x28,%esp
  1013c1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013cb:	89 c2                	mov    %eax,%edx
  1013cd:	ec                   	in     (%dx),%al
  1013ce:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d5:	0f b6 c0             	movzbl %al,%eax
  1013d8:	83 e0 01             	and    $0x1,%eax
  1013db:	85 c0                	test   %eax,%eax
  1013dd:	75 0a                	jne    1013e9 <kbd_proc_data+0x2e>
        return -1;
  1013df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e4:	e9 5e 01 00 00       	jmp    101547 <kbd_proc_data+0x18c>
  1013e9:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f3:	89 c2                	mov    %eax,%edx
  1013f5:	ec                   	in     (%dx),%al
  1013f6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013fd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101400:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101404:	75 17                	jne    10141d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101406:	a1 88 00 11 00       	mov    0x110088,%eax
  10140b:	83 c8 40             	or     $0x40,%eax
  10140e:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101413:	b8 00 00 00 00       	mov    $0x0,%eax
  101418:	e9 2a 01 00 00       	jmp    101547 <kbd_proc_data+0x18c>
    } else if (data & 0x80) {
  10141d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101421:	84 c0                	test   %al,%al
  101423:	79 47                	jns    10146c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101425:	a1 88 00 11 00       	mov    0x110088,%eax
  10142a:	83 e0 40             	and    $0x40,%eax
  10142d:	85 c0                	test   %eax,%eax
  10142f:	75 09                	jne    10143a <kbd_proc_data+0x7f>
  101431:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101435:	83 e0 7f             	and    $0x7f,%eax
  101438:	eb 04                	jmp    10143e <kbd_proc_data+0x83>
  10143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101441:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101445:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10144c:	83 c8 40             	or     $0x40,%eax
  10144f:	0f b6 c0             	movzbl %al,%eax
  101452:	f7 d0                	not    %eax
  101454:	89 c2                	mov    %eax,%edx
  101456:	a1 88 00 11 00       	mov    0x110088,%eax
  10145b:	21 d0                	and    %edx,%eax
  10145d:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101462:	b8 00 00 00 00       	mov    $0x0,%eax
  101467:	e9 db 00 00 00       	jmp    101547 <kbd_proc_data+0x18c>
    } else if (shift & E0ESC) {
  10146c:	a1 88 00 11 00       	mov    0x110088,%eax
  101471:	83 e0 40             	and    $0x40,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	74 11                	je     101489 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101478:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147c:	a1 88 00 11 00       	mov    0x110088,%eax
  101481:	83 e0 bf             	and    $0xffffffbf,%eax
  101484:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148d:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101494:	0f b6 d0             	movzbl %al,%edx
  101497:	a1 88 00 11 00       	mov    0x110088,%eax
  10149c:	09 d0                	or     %edx,%eax
  10149e:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  1014ae:	0f b6 d0             	movzbl %al,%edx
  1014b1:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b6:	31 d0                	xor    %edx,%eax
  1014b8:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014bd:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c2:	83 e0 03             	and    $0x3,%eax
  1014c5:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  1014cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d0:	01 d0                	add    %edx,%eax
  1014d2:	0f b6 00             	movzbl (%eax),%eax
  1014d5:	0f b6 c0             	movzbl %al,%eax
  1014d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014db:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e0:	83 e0 08             	and    $0x8,%eax
  1014e3:	85 c0                	test   %eax,%eax
  1014e5:	74 22                	je     101509 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e7:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014eb:	7e 0c                	jle    1014f9 <kbd_proc_data+0x13e>
  1014ed:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f1:	7f 06                	jg     1014f9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f7:	eb 10                	jmp    101509 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fd:	7e 0a                	jle    101509 <kbd_proc_data+0x14e>
  1014ff:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101503:	7f 04                	jg     101509 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101505:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101509:	a1 88 00 11 00       	mov    0x110088,%eax
  10150e:	f7 d0                	not    %eax
  101510:	83 e0 06             	and    $0x6,%eax
  101513:	85 c0                	test   %eax,%eax
  101515:	75 2d                	jne    101544 <kbd_proc_data+0x189>
  101517:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151e:	75 24                	jne    101544 <kbd_proc_data+0x189>
        cprintf("Rebooting!\n");
  101520:	83 ec 0c             	sub    $0xc,%esp
  101523:	68 af 38 10 00       	push   $0x1038af
  101528:	e8 de ed ff ff       	call   10030b <cprintf>
  10152d:	83 c4 10             	add    $0x10,%esp
  101530:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101536:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101542:	ee                   	out    %al,(%dx)
}
  101543:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10154f:	83 ec 0c             	sub    $0xc,%esp
  101552:	68 bb 13 10 00       	push   $0x1013bb
  101557:	e8 99 fd ff ff       	call   1012f5 <cons_intr>
  10155c:	83 c4 10             	add    $0x10,%esp
}
  10155f:	90                   	nop
  101560:	c9                   	leave  
  101561:	c3                   	ret    

00101562 <kbd_init>:

static void
kbd_init(void) {
  101562:	55                   	push   %ebp
  101563:	89 e5                	mov    %esp,%ebp
  101565:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101568:	e8 dc ff ff ff       	call   101549 <kbd_intr>
    pic_enable(IRQ_KBD);
  10156d:	83 ec 0c             	sub    $0xc,%esp
  101570:	6a 01                	push   $0x1
  101572:	e8 2e 01 00 00       	call   1016a5 <pic_enable>
  101577:	83 c4 10             	add    $0x10,%esp
}
  10157a:	90                   	nop
  10157b:	c9                   	leave  
  10157c:	c3                   	ret    

0010157d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157d:	55                   	push   %ebp
  10157e:	89 e5                	mov    %esp,%ebp
  101580:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101583:	e8 6b f8 ff ff       	call   100df3 <cga_init>
    serial_init();
  101588:	e8 4f f9 ff ff       	call   100edc <serial_init>
    kbd_init();
  10158d:	e8 d0 ff ff ff       	call   101562 <kbd_init>
    if (!serial_exists) {
  101592:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101597:	85 c0                	test   %eax,%eax
  101599:	75 10                	jne    1015ab <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10159b:	83 ec 0c             	sub    $0xc,%esp
  10159e:	68 bb 38 10 00       	push   $0x1038bb
  1015a3:	e8 63 ed ff ff       	call   10030b <cprintf>
  1015a8:	83 c4 10             	add    $0x10,%esp
    }
}
  1015ab:	90                   	nop
  1015ac:	c9                   	leave  
  1015ad:	c3                   	ret    

001015ae <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ae:	55                   	push   %ebp
  1015af:	89 e5                	mov    %esp,%ebp
  1015b1:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015b4:	ff 75 08             	push   0x8(%ebp)
  1015b7:	e8 89 fa ff ff       	call   101045 <lpt_putc>
  1015bc:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015bf:	83 ec 0c             	sub    $0xc,%esp
  1015c2:	ff 75 08             	push   0x8(%ebp)
  1015c5:	e8 b2 fa ff ff       	call   10107c <cga_putc>
  1015ca:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015cd:	83 ec 0c             	sub    $0xc,%esp
  1015d0:	ff 75 08             	push   0x8(%ebp)
  1015d3:	e8 e6 fc ff ff       	call   1012be <serial_putc>
  1015d8:	83 c4 10             	add    $0x10,%esp
}
  1015db:	90                   	nop
  1015dc:	c9                   	leave  
  1015dd:	c3                   	ret    

001015de <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp
  1015e1:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e4:	e8 b0 fd ff ff       	call   101399 <serial_intr>
    kbd_intr();
  1015e9:	e8 5b ff ff ff       	call   101549 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ee:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1015f4:	a1 84 00 11 00       	mov    0x110084,%eax
  1015f9:	39 c2                	cmp    %eax,%edx
  1015fb:	74 36                	je     101633 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015fd:	a1 80 00 11 00       	mov    0x110080,%eax
  101602:	8d 50 01             	lea    0x1(%eax),%edx
  101605:	89 15 80 00 11 00    	mov    %edx,0x110080
  10160b:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101612:	0f b6 c0             	movzbl %al,%eax
  101615:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101618:	a1 80 00 11 00       	mov    0x110080,%eax
  10161d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101622:	75 0a                	jne    10162e <cons_getc+0x50>
            cons.rpos = 0;
  101624:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10162b:	00 00 00 
        }
        return c;
  10162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101631:	eb 05                	jmp    101638 <cons_getc+0x5a>
    }
    return 0;
  101633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101638:	c9                   	leave  
  101639:	c3                   	ret    

0010163a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10163a:	55                   	push   %ebp
  10163b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10163d:	fb                   	sti    
}
  10163e:	90                   	nop
    sti();
}
  10163f:	90                   	nop
  101640:	5d                   	pop    %ebp
  101641:	c3                   	ret    

00101642 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101642:	55                   	push   %ebp
  101643:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101645:	fa                   	cli    
}
  101646:	90                   	nop
    cli();
}
  101647:	90                   	nop
  101648:	5d                   	pop    %ebp
  101649:	c3                   	ret    

0010164a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10164a:	55                   	push   %ebp
  10164b:	89 e5                	mov    %esp,%ebp
  10164d:	83 ec 14             	sub    $0x14,%esp
  101650:	8b 45 08             	mov    0x8(%ebp),%eax
  101653:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101657:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165b:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  101661:	a1 8c 00 11 00       	mov    0x11008c,%eax
  101666:	85 c0                	test   %eax,%eax
  101668:	74 38                	je     1016a2 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10166a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166e:	0f b6 c0             	movzbl %al,%eax
  101671:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101677:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10167a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101682:	ee                   	out    %al,(%dx)
}
  101683:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101684:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101688:	66 c1 e8 08          	shr    $0x8,%ax
  10168c:	0f b6 c0             	movzbl %al,%eax
  10168f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101695:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101698:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10169c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016a0:	ee                   	out    %al,(%dx)
}
  1016a1:	90                   	nop
    }
}
  1016a2:	90                   	nop
  1016a3:	c9                   	leave  
  1016a4:	c3                   	ret    

001016a5 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016a5:	55                   	push   %ebp
  1016a6:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ab:	ba 01 00 00 00       	mov    $0x1,%edx
  1016b0:	89 c1                	mov    %eax,%ecx
  1016b2:	d3 e2                	shl    %cl,%edx
  1016b4:	89 d0                	mov    %edx,%eax
  1016b6:	f7 d0                	not    %eax
  1016b8:	89 c2                	mov    %eax,%edx
  1016ba:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1016c1:	21 d0                	and    %edx,%eax
  1016c3:	0f b7 c0             	movzwl %ax,%eax
  1016c6:	50                   	push   %eax
  1016c7:	e8 7e ff ff ff       	call   10164a <pic_setmask>
  1016cc:	83 c4 04             	add    $0x4,%esp
}
  1016cf:	90                   	nop
  1016d0:	c9                   	leave  
  1016d1:	c3                   	ret    

001016d2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016d2:	55                   	push   %ebp
  1016d3:	89 e5                	mov    %esp,%ebp
  1016d5:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016d8:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  1016df:	00 00 00 
  1016e2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016e8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016ec:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016f0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016f4:	ee                   	out    %al,(%dx)
}
  1016f5:	90                   	nop
  1016f6:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016fc:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101700:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101704:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
}
  101709:	90                   	nop
  10170a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101710:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101714:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101718:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10171c:	ee                   	out    %al,(%dx)
}
  10171d:	90                   	nop
  10171e:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101724:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101728:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10172c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
}
  101731:	90                   	nop
  101732:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101738:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10173c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101740:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101744:	ee                   	out    %al,(%dx)
}
  101745:	90                   	nop
  101746:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10174c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101750:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101754:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
}
  101759:	90                   	nop
  10175a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101760:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101764:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101768:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
}
  10176d:	90                   	nop
  10176e:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101774:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101778:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10177c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
}
  101781:	90                   	nop
  101782:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101788:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10178c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101790:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
}
  101795:	90                   	nop
  101796:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10179c:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
}
  1017a9:	90                   	nop
  1017aa:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017b0:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017b8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
}
  1017bd:	90                   	nop
  1017be:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017c4:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017cc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
}
  1017d1:	90                   	nop
  1017d2:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017d8:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017dc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017e0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017e4:	ee                   	out    %al,(%dx)
}
  1017e5:	90                   	nop
  1017e6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017ec:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017f4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
}
  1017f9:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017fa:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101801:	66 83 f8 ff          	cmp    $0xffff,%ax
  101805:	74 13                	je     10181a <pic_init+0x148>
        pic_setmask(irq_mask);
  101807:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10180e:	0f b7 c0             	movzwl %ax,%eax
  101811:	50                   	push   %eax
  101812:	e8 33 fe ff ff       	call   10164a <pic_setmask>
  101817:	83 c4 04             	add    $0x4,%esp
    }
}
  10181a:	90                   	nop
  10181b:	c9                   	leave  
  10181c:	c3                   	ret    

0010181d <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10181d:	55                   	push   %ebp
  10181e:	89 e5                	mov    %esp,%ebp
  101820:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101823:	83 ec 08             	sub    $0x8,%esp
  101826:	6a 64                	push   $0x64
  101828:	68 e0 38 10 00       	push   $0x1038e0
  10182d:	e8 d9 ea ff ff       	call   10030b <cprintf>
  101832:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101835:	83 ec 0c             	sub    $0xc,%esp
  101838:	68 ea 38 10 00       	push   $0x1038ea
  10183d:	e8 c9 ea ff ff       	call   10030b <cprintf>
  101842:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101845:	83 ec 04             	sub    $0x4,%esp
  101848:	68 f8 38 10 00       	push   $0x1038f8
  10184d:	6a 12                	push   $0x12
  10184f:	68 0e 39 10 00       	push   $0x10390e
  101854:	e8 11 f4 ff ff       	call   100c6a <__panic>

00101859 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101859:	55                   	push   %ebp
  10185a:	89 e5                	mov    %esp,%ebp
  10185c:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10185f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101866:	e9 c3 00 00 00       	jmp    10192e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10186b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186e:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101875:	89 c2                	mov    %eax,%edx
  101877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187a:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  101881:	00 
  101882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101885:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  10188c:	00 08 00 
  10188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101892:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  101899:	00 
  10189a:	83 e2 e0             	and    $0xffffffe0,%edx
  10189d:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  1018ae:	00 
  1018af:	83 e2 1f             	and    $0x1f,%edx
  1018b2:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018c3:	00 
  1018c4:	83 e2 f0             	and    $0xfffffff0,%edx
  1018c7:	83 ca 0e             	or     $0xe,%edx
  1018ca:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d4:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018db:	00 
  1018dc:	83 e2 ef             	and    $0xffffffef,%edx
  1018df:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  1018f0:	00 
  1018f1:	83 e2 9f             	and    $0xffffff9f,%edx
  1018f4:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101905:	00 
  101906:	83 ca 80             	or     $0xffffff80,%edx
  101909:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10191a:	c1 e8 10             	shr    $0x10,%eax
  10191d:	89 c2                	mov    %eax,%edx
  10191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101922:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  101929:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10192a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	3d ff 00 00 00       	cmp    $0xff,%eax
  101936:	0f 86 2f ff ff ff    	jbe    10186b <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10193c:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101941:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  101947:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  10194e:	08 00 
  101950:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  101957:	83 e0 e0             	and    $0xffffffe0,%eax
  10195a:	a2 cc 04 11 00       	mov    %al,0x1104cc
  10195f:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  101966:	83 e0 1f             	and    $0x1f,%eax
  101969:	a2 cc 04 11 00       	mov    %al,0x1104cc
  10196e:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101975:	83 e0 f0             	and    $0xfffffff0,%eax
  101978:	83 c8 0e             	or     $0xe,%eax
  10197b:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101980:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101987:	83 e0 ef             	and    $0xffffffef,%eax
  10198a:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10198f:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101996:	83 c8 60             	or     $0x60,%eax
  101999:	a2 cd 04 11 00       	mov    %al,0x1104cd
  10199e:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019a5:	83 c8 80             	or     $0xffffff80,%eax
  1019a8:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019ad:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019b2:	c1 e8 10             	shr    $0x10,%eax
  1019b5:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  1019bb:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019c5:	0f 01 18             	lidtl  (%eax)
}
  1019c8:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  1019c9:	90                   	nop
  1019ca:	c9                   	leave  
  1019cb:	c3                   	ret    

001019cc <trapname>:

static const char *
trapname(int trapno) {
  1019cc:	55                   	push   %ebp
  1019cd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d2:	83 f8 13             	cmp    $0x13,%eax
  1019d5:	77 0c                	ja     1019e3 <trapname+0x17>
        return excnames[trapno];
  1019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019da:	8b 04 85 60 3c 10 00 	mov    0x103c60(,%eax,4),%eax
  1019e1:	eb 18                	jmp    1019fb <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019e3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019e7:	7e 0d                	jle    1019f6 <trapname+0x2a>
  1019e9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ed:	7f 07                	jg     1019f6 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ef:	b8 1f 39 10 00       	mov    $0x10391f,%eax
  1019f4:	eb 05                	jmp    1019fb <trapname+0x2f>
    }
    return "(unknown trap)";
  1019f6:	b8 32 39 10 00       	mov    $0x103932,%eax
}
  1019fb:	5d                   	pop    %ebp
  1019fc:	c3                   	ret    

001019fd <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019fd:	55                   	push   %ebp
  1019fe:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a00:	8b 45 08             	mov    0x8(%ebp),%eax
  101a03:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a07:	66 83 f8 08          	cmp    $0x8,%ax
  101a0b:	0f 94 c0             	sete   %al
  101a0e:	0f b6 c0             	movzbl %al,%eax
}
  101a11:	5d                   	pop    %ebp
  101a12:	c3                   	ret    

00101a13 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a13:	55                   	push   %ebp
  101a14:	89 e5                	mov    %esp,%ebp
  101a16:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a19:	83 ec 08             	sub    $0x8,%esp
  101a1c:	ff 75 08             	push   0x8(%ebp)
  101a1f:	68 73 39 10 00       	push   $0x103973
  101a24:	e8 e2 e8 ff ff       	call   10030b <cprintf>
  101a29:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	83 ec 0c             	sub    $0xc,%esp
  101a32:	50                   	push   %eax
  101a33:	e8 b4 01 00 00       	call   101bec <print_regs>
  101a38:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a42:	0f b7 c0             	movzwl %ax,%eax
  101a45:	83 ec 08             	sub    $0x8,%esp
  101a48:	50                   	push   %eax
  101a49:	68 84 39 10 00       	push   $0x103984
  101a4e:	e8 b8 e8 ff ff       	call   10030b <cprintf>
  101a53:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a56:	8b 45 08             	mov    0x8(%ebp),%eax
  101a59:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a5d:	0f b7 c0             	movzwl %ax,%eax
  101a60:	83 ec 08             	sub    $0x8,%esp
  101a63:	50                   	push   %eax
  101a64:	68 97 39 10 00       	push   $0x103997
  101a69:	e8 9d e8 ff ff       	call   10030b <cprintf>
  101a6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a71:	8b 45 08             	mov    0x8(%ebp),%eax
  101a74:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a78:	0f b7 c0             	movzwl %ax,%eax
  101a7b:	83 ec 08             	sub    $0x8,%esp
  101a7e:	50                   	push   %eax
  101a7f:	68 aa 39 10 00       	push   $0x1039aa
  101a84:	e8 82 e8 ff ff       	call   10030b <cprintf>
  101a89:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a93:	0f b7 c0             	movzwl %ax,%eax
  101a96:	83 ec 08             	sub    $0x8,%esp
  101a99:	50                   	push   %eax
  101a9a:	68 bd 39 10 00       	push   $0x1039bd
  101a9f:	e8 67 e8 ff ff       	call   10030b <cprintf>
  101aa4:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	8b 40 30             	mov    0x30(%eax),%eax
  101aad:	83 ec 0c             	sub    $0xc,%esp
  101ab0:	50                   	push   %eax
  101ab1:	e8 16 ff ff ff       	call   1019cc <trapname>
  101ab6:	83 c4 10             	add    $0x10,%esp
  101ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  101abc:	8b 52 30             	mov    0x30(%edx),%edx
  101abf:	83 ec 04             	sub    $0x4,%esp
  101ac2:	50                   	push   %eax
  101ac3:	52                   	push   %edx
  101ac4:	68 d0 39 10 00       	push   $0x1039d0
  101ac9:	e8 3d e8 ff ff       	call   10030b <cprintf>
  101ace:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad4:	8b 40 34             	mov    0x34(%eax),%eax
  101ad7:	83 ec 08             	sub    $0x8,%esp
  101ada:	50                   	push   %eax
  101adb:	68 e2 39 10 00       	push   $0x1039e2
  101ae0:	e8 26 e8 ff ff       	call   10030b <cprintf>
  101ae5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aeb:	8b 40 38             	mov    0x38(%eax),%eax
  101aee:	83 ec 08             	sub    $0x8,%esp
  101af1:	50                   	push   %eax
  101af2:	68 f1 39 10 00       	push   $0x1039f1
  101af7:	e8 0f e8 ff ff       	call   10030b <cprintf>
  101afc:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b06:	0f b7 c0             	movzwl %ax,%eax
  101b09:	83 ec 08             	sub    $0x8,%esp
  101b0c:	50                   	push   %eax
  101b0d:	68 00 3a 10 00       	push   $0x103a00
  101b12:	e8 f4 e7 ff ff       	call   10030b <cprintf>
  101b17:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1d:	8b 40 40             	mov    0x40(%eax),%eax
  101b20:	83 ec 08             	sub    $0x8,%esp
  101b23:	50                   	push   %eax
  101b24:	68 13 3a 10 00       	push   $0x103a13
  101b29:	e8 dd e7 ff ff       	call   10030b <cprintf>
  101b2e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b3f:	eb 3f                	jmp    101b80 <print_trapframe+0x16d>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b41:	8b 45 08             	mov    0x8(%ebp),%eax
  101b44:	8b 50 40             	mov    0x40(%eax),%edx
  101b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b4a:	21 d0                	and    %edx,%eax
  101b4c:	85 c0                	test   %eax,%eax
  101b4e:	74 29                	je     101b79 <print_trapframe+0x166>
  101b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b53:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b5a:	85 c0                	test   %eax,%eax
  101b5c:	74 1b                	je     101b79 <print_trapframe+0x166>
            cprintf("%s,", IA32flags[i]);
  101b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b61:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b68:	83 ec 08             	sub    $0x8,%esp
  101b6b:	50                   	push   %eax
  101b6c:	68 22 3a 10 00       	push   $0x103a22
  101b71:	e8 95 e7 ff ff       	call   10030b <cprintf>
  101b76:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b7d:	d1 65 f0             	shll   -0x10(%ebp)
  101b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b83:	83 f8 17             	cmp    $0x17,%eax
  101b86:	76 b9                	jbe    101b41 <print_trapframe+0x12e>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	8b 40 40             	mov    0x40(%eax),%eax
  101b8e:	c1 e8 0c             	shr    $0xc,%eax
  101b91:	83 e0 03             	and    $0x3,%eax
  101b94:	83 ec 08             	sub    $0x8,%esp
  101b97:	50                   	push   %eax
  101b98:	68 26 3a 10 00       	push   $0x103a26
  101b9d:	e8 69 e7 ff ff       	call   10030b <cprintf>
  101ba2:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101ba5:	83 ec 0c             	sub    $0xc,%esp
  101ba8:	ff 75 08             	push   0x8(%ebp)
  101bab:	e8 4d fe ff ff       	call   1019fd <trap_in_kernel>
  101bb0:	83 c4 10             	add    $0x10,%esp
  101bb3:	85 c0                	test   %eax,%eax
  101bb5:	75 32                	jne    101be9 <print_trapframe+0x1d6>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bba:	8b 40 44             	mov    0x44(%eax),%eax
  101bbd:	83 ec 08             	sub    $0x8,%esp
  101bc0:	50                   	push   %eax
  101bc1:	68 2f 3a 10 00       	push   $0x103a2f
  101bc6:	e8 40 e7 ff ff       	call   10030b <cprintf>
  101bcb:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bce:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bd5:	0f b7 c0             	movzwl %ax,%eax
  101bd8:	83 ec 08             	sub    $0x8,%esp
  101bdb:	50                   	push   %eax
  101bdc:	68 3e 3a 10 00       	push   $0x103a3e
  101be1:	e8 25 e7 ff ff       	call   10030b <cprintf>
  101be6:	83 c4 10             	add    $0x10,%esp
    }
}
  101be9:	90                   	nop
  101bea:	c9                   	leave  
  101beb:	c3                   	ret    

00101bec <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bec:	55                   	push   %ebp
  101bed:	89 e5                	mov    %esp,%ebp
  101bef:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf5:	8b 00                	mov    (%eax),%eax
  101bf7:	83 ec 08             	sub    $0x8,%esp
  101bfa:	50                   	push   %eax
  101bfb:	68 51 3a 10 00       	push   $0x103a51
  101c00:	e8 06 e7 ff ff       	call   10030b <cprintf>
  101c05:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 04             	mov    0x4(%eax),%eax
  101c0e:	83 ec 08             	sub    $0x8,%esp
  101c11:	50                   	push   %eax
  101c12:	68 60 3a 10 00       	push   $0x103a60
  101c17:	e8 ef e6 ff ff       	call   10030b <cprintf>
  101c1c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c22:	8b 40 08             	mov    0x8(%eax),%eax
  101c25:	83 ec 08             	sub    $0x8,%esp
  101c28:	50                   	push   %eax
  101c29:	68 6f 3a 10 00       	push   $0x103a6f
  101c2e:	e8 d8 e6 ff ff       	call   10030b <cprintf>
  101c33:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c36:	8b 45 08             	mov    0x8(%ebp),%eax
  101c39:	8b 40 0c             	mov    0xc(%eax),%eax
  101c3c:	83 ec 08             	sub    $0x8,%esp
  101c3f:	50                   	push   %eax
  101c40:	68 7e 3a 10 00       	push   $0x103a7e
  101c45:	e8 c1 e6 ff ff       	call   10030b <cprintf>
  101c4a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c50:	8b 40 10             	mov    0x10(%eax),%eax
  101c53:	83 ec 08             	sub    $0x8,%esp
  101c56:	50                   	push   %eax
  101c57:	68 8d 3a 10 00       	push   $0x103a8d
  101c5c:	e8 aa e6 ff ff       	call   10030b <cprintf>
  101c61:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c64:	8b 45 08             	mov    0x8(%ebp),%eax
  101c67:	8b 40 14             	mov    0x14(%eax),%eax
  101c6a:	83 ec 08             	sub    $0x8,%esp
  101c6d:	50                   	push   %eax
  101c6e:	68 9c 3a 10 00       	push   $0x103a9c
  101c73:	e8 93 e6 ff ff       	call   10030b <cprintf>
  101c78:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7e:	8b 40 18             	mov    0x18(%eax),%eax
  101c81:	83 ec 08             	sub    $0x8,%esp
  101c84:	50                   	push   %eax
  101c85:	68 ab 3a 10 00       	push   $0x103aab
  101c8a:	e8 7c e6 ff ff       	call   10030b <cprintf>
  101c8f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c98:	83 ec 08             	sub    $0x8,%esp
  101c9b:	50                   	push   %eax
  101c9c:	68 ba 3a 10 00       	push   $0x103aba
  101ca1:	e8 65 e6 ff ff       	call   10030b <cprintf>
  101ca6:	83 c4 10             	add    $0x10,%esp
}
  101ca9:	90                   	nop
  101caa:	c9                   	leave  
  101cab:	c3                   	ret    

00101cac <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cac:	55                   	push   %ebp
  101cad:	89 e5                	mov    %esp,%ebp
  101caf:	57                   	push   %edi
  101cb0:	56                   	push   %esi
  101cb1:	53                   	push   %ebx
  101cb2:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb8:	8b 40 30             	mov    0x30(%eax),%eax
  101cbb:	83 f8 79             	cmp    $0x79,%eax
  101cbe:	0f 84 50 01 00 00    	je     101e14 <trap_dispatch+0x168>
  101cc4:	83 f8 79             	cmp    $0x79,%eax
  101cc7:	0f 87 bd 01 00 00    	ja     101e8a <trap_dispatch+0x1de>
  101ccd:	83 f8 78             	cmp    $0x78,%eax
  101cd0:	0f 84 c0 00 00 00    	je     101d96 <trap_dispatch+0xea>
  101cd6:	83 f8 78             	cmp    $0x78,%eax
  101cd9:	0f 87 ab 01 00 00    	ja     101e8a <trap_dispatch+0x1de>
  101cdf:	83 f8 2f             	cmp    $0x2f,%eax
  101ce2:	0f 87 a2 01 00 00    	ja     101e8a <trap_dispatch+0x1de>
  101ce8:	83 f8 2e             	cmp    $0x2e,%eax
  101ceb:	0f 83 cf 01 00 00    	jae    101ec0 <trap_dispatch+0x214>
  101cf1:	83 f8 24             	cmp    $0x24,%eax
  101cf4:	74 52                	je     101d48 <trap_dispatch+0x9c>
  101cf6:	83 f8 24             	cmp    $0x24,%eax
  101cf9:	0f 87 8b 01 00 00    	ja     101e8a <trap_dispatch+0x1de>
  101cff:	83 f8 20             	cmp    $0x20,%eax
  101d02:	74 0a                	je     101d0e <trap_dispatch+0x62>
  101d04:	83 f8 21             	cmp    $0x21,%eax
  101d07:	74 66                	je     101d6f <trap_dispatch+0xc3>
  101d09:	e9 7c 01 00 00       	jmp    101e8a <trap_dispatch+0x1de>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d0e:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d13:	83 c0 01             	add    $0x1,%eax
  101d16:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0) {
  101d1b:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d21:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d26:	89 c8                	mov    %ecx,%eax
  101d28:	f7 e2                	mul    %edx
  101d2a:	89 d0                	mov    %edx,%eax
  101d2c:	c1 e8 05             	shr    $0x5,%eax
  101d2f:	6b d0 64             	imul   $0x64,%eax,%edx
  101d32:	89 c8                	mov    %ecx,%eax
  101d34:	29 d0                	sub    %edx,%eax
  101d36:	85 c0                	test   %eax,%eax
  101d38:	0f 85 85 01 00 00    	jne    101ec3 <trap_dispatch+0x217>
            print_ticks();
  101d3e:	e8 da fa ff ff       	call   10181d <print_ticks>
        }
        break;
  101d43:	e9 7b 01 00 00       	jmp    101ec3 <trap_dispatch+0x217>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d48:	e8 91 f8 ff ff       	call   1015de <cons_getc>
  101d4d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d50:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d54:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d58:	83 ec 04             	sub    $0x4,%esp
  101d5b:	52                   	push   %edx
  101d5c:	50                   	push   %eax
  101d5d:	68 c9 3a 10 00       	push   $0x103ac9
  101d62:	e8 a4 e5 ff ff       	call   10030b <cprintf>
  101d67:	83 c4 10             	add    $0x10,%esp
        break;
  101d6a:	e9 5b 01 00 00       	jmp    101eca <trap_dispatch+0x21e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d6f:	e8 6a f8 ff ff       	call   1015de <cons_getc>
  101d74:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d77:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d7b:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d7f:	83 ec 04             	sub    $0x4,%esp
  101d82:	52                   	push   %edx
  101d83:	50                   	push   %eax
  101d84:	68 db 3a 10 00       	push   $0x103adb
  101d89:	e8 7d e5 ff ff       	call   10030b <cprintf>
  101d8e:	83 c4 10             	add    $0x10,%esp
        break;
  101d91:	e9 34 01 00 00       	jmp    101eca <trap_dispatch+0x21e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d96:	8b 45 08             	mov    0x8(%ebp),%eax
  101d99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d9d:	66 83 f8 1b          	cmp    $0x1b,%ax
  101da1:	0f 84 1f 01 00 00    	je     101ec6 <trap_dispatch+0x21a>
            switchk2u = *tf;
  101da7:	8b 45 08             	mov    0x8(%ebp),%eax
  101daa:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101daf:	89 c3                	mov    %eax,%ebx
  101db1:	b8 13 00 00 00       	mov    $0x13,%eax
  101db6:	89 d7                	mov    %edx,%edi
  101db8:	89 de                	mov    %ebx,%esi
  101dba:	89 c1                	mov    %eax,%ecx
  101dbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101dbe:	66 c7 05 dc 00 11 00 	movw   $0x1b,0x1100dc
  101dc5:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101dc7:	66 c7 05 e8 00 11 00 	movw   $0x23,0x1100e8
  101dce:	23 00 
  101dd0:	0f b7 05 e8 00 11 00 	movzwl 0x1100e8,%eax
  101dd7:	66 a3 c8 00 11 00    	mov    %ax,0x1100c8
  101ddd:	0f b7 05 c8 00 11 00 	movzwl 0x1100c8,%eax
  101de4:	66 a3 cc 00 11 00    	mov    %ax,0x1100cc
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101dea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ded:	83 c0 44             	add    $0x44,%eax
  101df0:	a3 e4 00 11 00       	mov    %eax,0x1100e4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101df5:	a1 e0 00 11 00       	mov    0x1100e0,%eax
  101dfa:	80 cc 30             	or     $0x30,%ah
  101dfd:	a3 e0 00 11 00       	mov    %eax,0x1100e0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e02:	8b 45 08             	mov    0x8(%ebp),%eax
  101e05:	83 e8 04             	sub    $0x4,%eax
  101e08:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101e0d:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e0f:	e9 b2 00 00 00       	jmp    101ec6 <trap_dispatch+0x21a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e1b:	66 83 f8 08          	cmp    $0x8,%ax
  101e1f:	0f 84 a4 00 00 00    	je     101ec9 <trap_dispatch+0x21d>
            tf->tf_cs = KERNEL_CS;
  101e25:	8b 45 08             	mov    0x8(%ebp),%eax
  101e28:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e37:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3a:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e41:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e45:	8b 45 08             	mov    0x8(%ebp),%eax
  101e48:	8b 40 40             	mov    0x40(%eax),%eax
  101e4b:	80 e4 cf             	and    $0xcf,%ah
  101e4e:	89 c2                	mov    %eax,%edx
  101e50:	8b 45 08             	mov    0x8(%ebp),%eax
  101e53:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e56:	8b 45 08             	mov    0x8(%ebp),%eax
  101e59:	8b 40 44             	mov    0x44(%eax),%eax
  101e5c:	83 e8 44             	sub    $0x44,%eax
  101e5f:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e64:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101e69:	83 ec 04             	sub    $0x4,%esp
  101e6c:	6a 44                	push   $0x44
  101e6e:	ff 75 08             	push   0x8(%ebp)
  101e71:	50                   	push   %eax
  101e72:	e8 bd 15 00 00       	call   103434 <memmove>
  101e77:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e7a:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101e80:	8b 45 08             	mov    0x8(%ebp),%eax
  101e83:	83 e8 04             	sub    $0x4,%eax
  101e86:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e88:	eb 3f                	jmp    101ec9 <trap_dispatch+0x21d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e91:	0f b7 c0             	movzwl %ax,%eax
  101e94:	83 e0 03             	and    $0x3,%eax
  101e97:	85 c0                	test   %eax,%eax
  101e99:	75 2f                	jne    101eca <trap_dispatch+0x21e>
            print_trapframe(tf);
  101e9b:	83 ec 0c             	sub    $0xc,%esp
  101e9e:	ff 75 08             	push   0x8(%ebp)
  101ea1:	e8 6d fb ff ff       	call   101a13 <print_trapframe>
  101ea6:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101ea9:	83 ec 04             	sub    $0x4,%esp
  101eac:	68 ea 3a 10 00       	push   $0x103aea
  101eb1:	68 d2 00 00 00       	push   $0xd2
  101eb6:	68 0e 39 10 00       	push   $0x10390e
  101ebb:	e8 aa ed ff ff       	call   100c6a <__panic>
        break;
  101ec0:	90                   	nop
  101ec1:	eb 07                	jmp    101eca <trap_dispatch+0x21e>
        break;
  101ec3:	90                   	nop
  101ec4:	eb 04                	jmp    101eca <trap_dispatch+0x21e>
        break;
  101ec6:	90                   	nop
  101ec7:	eb 01                	jmp    101eca <trap_dispatch+0x21e>
        break;
  101ec9:	90                   	nop
        }
    }
}
  101eca:	90                   	nop
  101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101ece:	5b                   	pop    %ebx
  101ecf:	5e                   	pop    %esi
  101ed0:	5f                   	pop    %edi
  101ed1:	5d                   	pop    %ebp
  101ed2:	c3                   	ret    

00101ed3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ed3:	55                   	push   %ebp
  101ed4:	89 e5                	mov    %esp,%ebp
  101ed6:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ed9:	83 ec 0c             	sub    $0xc,%esp
  101edc:	ff 75 08             	push   0x8(%ebp)
  101edf:	e8 c8 fd ff ff       	call   101cac <trap_dispatch>
  101ee4:	83 c4 10             	add    $0x10,%esp
}
  101ee7:	90                   	nop
  101ee8:	c9                   	leave  
  101ee9:	c3                   	ret    

00101eea <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101eea:	1e                   	push   %ds
    pushl %es
  101eeb:	06                   	push   %es
    pushl %fs
  101eec:	0f a0                	push   %fs
    pushl %gs
  101eee:	0f a8                	push   %gs
    pushal
  101ef0:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ef1:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ef6:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ef8:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101efa:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101efb:	e8 d3 ff ff ff       	call   101ed3 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f00:	5c                   	pop    %esp

00101f01 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f01:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f02:	0f a9                	pop    %gs
    popl %fs
  101f04:	0f a1                	pop    %fs
    popl %es
  101f06:	07                   	pop    %es
    popl %ds
  101f07:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f08:	83 c4 08             	add    $0x8,%esp
    iret
  101f0b:	cf                   	iret   

00101f0c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $0
  101f0e:	6a 00                	push   $0x0
  jmp __alltraps
  101f10:	e9 d5 ff ff ff       	jmp    101eea <__alltraps>

00101f15 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $1
  101f17:	6a 01                	push   $0x1
  jmp __alltraps
  101f19:	e9 cc ff ff ff       	jmp    101eea <__alltraps>

00101f1e <vector2>:
.globl vector2
vector2:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $2
  101f20:	6a 02                	push   $0x2
  jmp __alltraps
  101f22:	e9 c3 ff ff ff       	jmp    101eea <__alltraps>

00101f27 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $3
  101f29:	6a 03                	push   $0x3
  jmp __alltraps
  101f2b:	e9 ba ff ff ff       	jmp    101eea <__alltraps>

00101f30 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $4
  101f32:	6a 04                	push   $0x4
  jmp __alltraps
  101f34:	e9 b1 ff ff ff       	jmp    101eea <__alltraps>

00101f39 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $5
  101f3b:	6a 05                	push   $0x5
  jmp __alltraps
  101f3d:	e9 a8 ff ff ff       	jmp    101eea <__alltraps>

00101f42 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $6
  101f44:	6a 06                	push   $0x6
  jmp __alltraps
  101f46:	e9 9f ff ff ff       	jmp    101eea <__alltraps>

00101f4b <vector7>:
.globl vector7
vector7:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $7
  101f4d:	6a 07                	push   $0x7
  jmp __alltraps
  101f4f:	e9 96 ff ff ff       	jmp    101eea <__alltraps>

00101f54 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f54:	6a 08                	push   $0x8
  jmp __alltraps
  101f56:	e9 8f ff ff ff       	jmp    101eea <__alltraps>

00101f5b <vector9>:
.globl vector9
vector9:
  pushl $9
  101f5b:	6a 09                	push   $0x9
  jmp __alltraps
  101f5d:	e9 88 ff ff ff       	jmp    101eea <__alltraps>

00101f62 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f62:	6a 0a                	push   $0xa
  jmp __alltraps
  101f64:	e9 81 ff ff ff       	jmp    101eea <__alltraps>

00101f69 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f69:	6a 0b                	push   $0xb
  jmp __alltraps
  101f6b:	e9 7a ff ff ff       	jmp    101eea <__alltraps>

00101f70 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f70:	6a 0c                	push   $0xc
  jmp __alltraps
  101f72:	e9 73 ff ff ff       	jmp    101eea <__alltraps>

00101f77 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f77:	6a 0d                	push   $0xd
  jmp __alltraps
  101f79:	e9 6c ff ff ff       	jmp    101eea <__alltraps>

00101f7e <vector14>:
.globl vector14
vector14:
  pushl $14
  101f7e:	6a 0e                	push   $0xe
  jmp __alltraps
  101f80:	e9 65 ff ff ff       	jmp    101eea <__alltraps>

00101f85 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $15
  101f87:	6a 0f                	push   $0xf
  jmp __alltraps
  101f89:	e9 5c ff ff ff       	jmp    101eea <__alltraps>

00101f8e <vector16>:
.globl vector16
vector16:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $16
  101f90:	6a 10                	push   $0x10
  jmp __alltraps
  101f92:	e9 53 ff ff ff       	jmp    101eea <__alltraps>

00101f97 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f97:	6a 11                	push   $0x11
  jmp __alltraps
  101f99:	e9 4c ff ff ff       	jmp    101eea <__alltraps>

00101f9e <vector18>:
.globl vector18
vector18:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $18
  101fa0:	6a 12                	push   $0x12
  jmp __alltraps
  101fa2:	e9 43 ff ff ff       	jmp    101eea <__alltraps>

00101fa7 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $19
  101fa9:	6a 13                	push   $0x13
  jmp __alltraps
  101fab:	e9 3a ff ff ff       	jmp    101eea <__alltraps>

00101fb0 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $20
  101fb2:	6a 14                	push   $0x14
  jmp __alltraps
  101fb4:	e9 31 ff ff ff       	jmp    101eea <__alltraps>

00101fb9 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $21
  101fbb:	6a 15                	push   $0x15
  jmp __alltraps
  101fbd:	e9 28 ff ff ff       	jmp    101eea <__alltraps>

00101fc2 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $22
  101fc4:	6a 16                	push   $0x16
  jmp __alltraps
  101fc6:	e9 1f ff ff ff       	jmp    101eea <__alltraps>

00101fcb <vector23>:
.globl vector23
vector23:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $23
  101fcd:	6a 17                	push   $0x17
  jmp __alltraps
  101fcf:	e9 16 ff ff ff       	jmp    101eea <__alltraps>

00101fd4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $24
  101fd6:	6a 18                	push   $0x18
  jmp __alltraps
  101fd8:	e9 0d ff ff ff       	jmp    101eea <__alltraps>

00101fdd <vector25>:
.globl vector25
vector25:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $25
  101fdf:	6a 19                	push   $0x19
  jmp __alltraps
  101fe1:	e9 04 ff ff ff       	jmp    101eea <__alltraps>

00101fe6 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $26
  101fe8:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fea:	e9 fb fe ff ff       	jmp    101eea <__alltraps>

00101fef <vector27>:
.globl vector27
vector27:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $27
  101ff1:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ff3:	e9 f2 fe ff ff       	jmp    101eea <__alltraps>

00101ff8 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $28
  101ffa:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ffc:	e9 e9 fe ff ff       	jmp    101eea <__alltraps>

00102001 <vector29>:
.globl vector29
vector29:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $29
  102003:	6a 1d                	push   $0x1d
  jmp __alltraps
  102005:	e9 e0 fe ff ff       	jmp    101eea <__alltraps>

0010200a <vector30>:
.globl vector30
vector30:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $30
  10200c:	6a 1e                	push   $0x1e
  jmp __alltraps
  10200e:	e9 d7 fe ff ff       	jmp    101eea <__alltraps>

00102013 <vector31>:
.globl vector31
vector31:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $31
  102015:	6a 1f                	push   $0x1f
  jmp __alltraps
  102017:	e9 ce fe ff ff       	jmp    101eea <__alltraps>

0010201c <vector32>:
.globl vector32
vector32:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $32
  10201e:	6a 20                	push   $0x20
  jmp __alltraps
  102020:	e9 c5 fe ff ff       	jmp    101eea <__alltraps>

00102025 <vector33>:
.globl vector33
vector33:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $33
  102027:	6a 21                	push   $0x21
  jmp __alltraps
  102029:	e9 bc fe ff ff       	jmp    101eea <__alltraps>

0010202e <vector34>:
.globl vector34
vector34:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $34
  102030:	6a 22                	push   $0x22
  jmp __alltraps
  102032:	e9 b3 fe ff ff       	jmp    101eea <__alltraps>

00102037 <vector35>:
.globl vector35
vector35:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $35
  102039:	6a 23                	push   $0x23
  jmp __alltraps
  10203b:	e9 aa fe ff ff       	jmp    101eea <__alltraps>

00102040 <vector36>:
.globl vector36
vector36:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $36
  102042:	6a 24                	push   $0x24
  jmp __alltraps
  102044:	e9 a1 fe ff ff       	jmp    101eea <__alltraps>

00102049 <vector37>:
.globl vector37
vector37:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $37
  10204b:	6a 25                	push   $0x25
  jmp __alltraps
  10204d:	e9 98 fe ff ff       	jmp    101eea <__alltraps>

00102052 <vector38>:
.globl vector38
vector38:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $38
  102054:	6a 26                	push   $0x26
  jmp __alltraps
  102056:	e9 8f fe ff ff       	jmp    101eea <__alltraps>

0010205b <vector39>:
.globl vector39
vector39:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $39
  10205d:	6a 27                	push   $0x27
  jmp __alltraps
  10205f:	e9 86 fe ff ff       	jmp    101eea <__alltraps>

00102064 <vector40>:
.globl vector40
vector40:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $40
  102066:	6a 28                	push   $0x28
  jmp __alltraps
  102068:	e9 7d fe ff ff       	jmp    101eea <__alltraps>

0010206d <vector41>:
.globl vector41
vector41:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $41
  10206f:	6a 29                	push   $0x29
  jmp __alltraps
  102071:	e9 74 fe ff ff       	jmp    101eea <__alltraps>

00102076 <vector42>:
.globl vector42
vector42:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $42
  102078:	6a 2a                	push   $0x2a
  jmp __alltraps
  10207a:	e9 6b fe ff ff       	jmp    101eea <__alltraps>

0010207f <vector43>:
.globl vector43
vector43:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $43
  102081:	6a 2b                	push   $0x2b
  jmp __alltraps
  102083:	e9 62 fe ff ff       	jmp    101eea <__alltraps>

00102088 <vector44>:
.globl vector44
vector44:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $44
  10208a:	6a 2c                	push   $0x2c
  jmp __alltraps
  10208c:	e9 59 fe ff ff       	jmp    101eea <__alltraps>

00102091 <vector45>:
.globl vector45
vector45:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $45
  102093:	6a 2d                	push   $0x2d
  jmp __alltraps
  102095:	e9 50 fe ff ff       	jmp    101eea <__alltraps>

0010209a <vector46>:
.globl vector46
vector46:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $46
  10209c:	6a 2e                	push   $0x2e
  jmp __alltraps
  10209e:	e9 47 fe ff ff       	jmp    101eea <__alltraps>

001020a3 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $47
  1020a5:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020a7:	e9 3e fe ff ff       	jmp    101eea <__alltraps>

001020ac <vector48>:
.globl vector48
vector48:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $48
  1020ae:	6a 30                	push   $0x30
  jmp __alltraps
  1020b0:	e9 35 fe ff ff       	jmp    101eea <__alltraps>

001020b5 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $49
  1020b7:	6a 31                	push   $0x31
  jmp __alltraps
  1020b9:	e9 2c fe ff ff       	jmp    101eea <__alltraps>

001020be <vector50>:
.globl vector50
vector50:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $50
  1020c0:	6a 32                	push   $0x32
  jmp __alltraps
  1020c2:	e9 23 fe ff ff       	jmp    101eea <__alltraps>

001020c7 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $51
  1020c9:	6a 33                	push   $0x33
  jmp __alltraps
  1020cb:	e9 1a fe ff ff       	jmp    101eea <__alltraps>

001020d0 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $52
  1020d2:	6a 34                	push   $0x34
  jmp __alltraps
  1020d4:	e9 11 fe ff ff       	jmp    101eea <__alltraps>

001020d9 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $53
  1020db:	6a 35                	push   $0x35
  jmp __alltraps
  1020dd:	e9 08 fe ff ff       	jmp    101eea <__alltraps>

001020e2 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $54
  1020e4:	6a 36                	push   $0x36
  jmp __alltraps
  1020e6:	e9 ff fd ff ff       	jmp    101eea <__alltraps>

001020eb <vector55>:
.globl vector55
vector55:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $55
  1020ed:	6a 37                	push   $0x37
  jmp __alltraps
  1020ef:	e9 f6 fd ff ff       	jmp    101eea <__alltraps>

001020f4 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $56
  1020f6:	6a 38                	push   $0x38
  jmp __alltraps
  1020f8:	e9 ed fd ff ff       	jmp    101eea <__alltraps>

001020fd <vector57>:
.globl vector57
vector57:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $57
  1020ff:	6a 39                	push   $0x39
  jmp __alltraps
  102101:	e9 e4 fd ff ff       	jmp    101eea <__alltraps>

00102106 <vector58>:
.globl vector58
vector58:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $58
  102108:	6a 3a                	push   $0x3a
  jmp __alltraps
  10210a:	e9 db fd ff ff       	jmp    101eea <__alltraps>

0010210f <vector59>:
.globl vector59
vector59:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $59
  102111:	6a 3b                	push   $0x3b
  jmp __alltraps
  102113:	e9 d2 fd ff ff       	jmp    101eea <__alltraps>

00102118 <vector60>:
.globl vector60
vector60:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $60
  10211a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10211c:	e9 c9 fd ff ff       	jmp    101eea <__alltraps>

00102121 <vector61>:
.globl vector61
vector61:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $61
  102123:	6a 3d                	push   $0x3d
  jmp __alltraps
  102125:	e9 c0 fd ff ff       	jmp    101eea <__alltraps>

0010212a <vector62>:
.globl vector62
vector62:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $62
  10212c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10212e:	e9 b7 fd ff ff       	jmp    101eea <__alltraps>

00102133 <vector63>:
.globl vector63
vector63:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $63
  102135:	6a 3f                	push   $0x3f
  jmp __alltraps
  102137:	e9 ae fd ff ff       	jmp    101eea <__alltraps>

0010213c <vector64>:
.globl vector64
vector64:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $64
  10213e:	6a 40                	push   $0x40
  jmp __alltraps
  102140:	e9 a5 fd ff ff       	jmp    101eea <__alltraps>

00102145 <vector65>:
.globl vector65
vector65:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $65
  102147:	6a 41                	push   $0x41
  jmp __alltraps
  102149:	e9 9c fd ff ff       	jmp    101eea <__alltraps>

0010214e <vector66>:
.globl vector66
vector66:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $66
  102150:	6a 42                	push   $0x42
  jmp __alltraps
  102152:	e9 93 fd ff ff       	jmp    101eea <__alltraps>

00102157 <vector67>:
.globl vector67
vector67:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $67
  102159:	6a 43                	push   $0x43
  jmp __alltraps
  10215b:	e9 8a fd ff ff       	jmp    101eea <__alltraps>

00102160 <vector68>:
.globl vector68
vector68:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $68
  102162:	6a 44                	push   $0x44
  jmp __alltraps
  102164:	e9 81 fd ff ff       	jmp    101eea <__alltraps>

00102169 <vector69>:
.globl vector69
vector69:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $69
  10216b:	6a 45                	push   $0x45
  jmp __alltraps
  10216d:	e9 78 fd ff ff       	jmp    101eea <__alltraps>

00102172 <vector70>:
.globl vector70
vector70:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $70
  102174:	6a 46                	push   $0x46
  jmp __alltraps
  102176:	e9 6f fd ff ff       	jmp    101eea <__alltraps>

0010217b <vector71>:
.globl vector71
vector71:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $71
  10217d:	6a 47                	push   $0x47
  jmp __alltraps
  10217f:	e9 66 fd ff ff       	jmp    101eea <__alltraps>

00102184 <vector72>:
.globl vector72
vector72:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $72
  102186:	6a 48                	push   $0x48
  jmp __alltraps
  102188:	e9 5d fd ff ff       	jmp    101eea <__alltraps>

0010218d <vector73>:
.globl vector73
vector73:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $73
  10218f:	6a 49                	push   $0x49
  jmp __alltraps
  102191:	e9 54 fd ff ff       	jmp    101eea <__alltraps>

00102196 <vector74>:
.globl vector74
vector74:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $74
  102198:	6a 4a                	push   $0x4a
  jmp __alltraps
  10219a:	e9 4b fd ff ff       	jmp    101eea <__alltraps>

0010219f <vector75>:
.globl vector75
vector75:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $75
  1021a1:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021a3:	e9 42 fd ff ff       	jmp    101eea <__alltraps>

001021a8 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $76
  1021aa:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021ac:	e9 39 fd ff ff       	jmp    101eea <__alltraps>

001021b1 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $77
  1021b3:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021b5:	e9 30 fd ff ff       	jmp    101eea <__alltraps>

001021ba <vector78>:
.globl vector78
vector78:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $78
  1021bc:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021be:	e9 27 fd ff ff       	jmp    101eea <__alltraps>

001021c3 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $79
  1021c5:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021c7:	e9 1e fd ff ff       	jmp    101eea <__alltraps>

001021cc <vector80>:
.globl vector80
vector80:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $80
  1021ce:	6a 50                	push   $0x50
  jmp __alltraps
  1021d0:	e9 15 fd ff ff       	jmp    101eea <__alltraps>

001021d5 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $81
  1021d7:	6a 51                	push   $0x51
  jmp __alltraps
  1021d9:	e9 0c fd ff ff       	jmp    101eea <__alltraps>

001021de <vector82>:
.globl vector82
vector82:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $82
  1021e0:	6a 52                	push   $0x52
  jmp __alltraps
  1021e2:	e9 03 fd ff ff       	jmp    101eea <__alltraps>

001021e7 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $83
  1021e9:	6a 53                	push   $0x53
  jmp __alltraps
  1021eb:	e9 fa fc ff ff       	jmp    101eea <__alltraps>

001021f0 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $84
  1021f2:	6a 54                	push   $0x54
  jmp __alltraps
  1021f4:	e9 f1 fc ff ff       	jmp    101eea <__alltraps>

001021f9 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $85
  1021fb:	6a 55                	push   $0x55
  jmp __alltraps
  1021fd:	e9 e8 fc ff ff       	jmp    101eea <__alltraps>

00102202 <vector86>:
.globl vector86
vector86:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $86
  102204:	6a 56                	push   $0x56
  jmp __alltraps
  102206:	e9 df fc ff ff       	jmp    101eea <__alltraps>

0010220b <vector87>:
.globl vector87
vector87:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $87
  10220d:	6a 57                	push   $0x57
  jmp __alltraps
  10220f:	e9 d6 fc ff ff       	jmp    101eea <__alltraps>

00102214 <vector88>:
.globl vector88
vector88:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $88
  102216:	6a 58                	push   $0x58
  jmp __alltraps
  102218:	e9 cd fc ff ff       	jmp    101eea <__alltraps>

0010221d <vector89>:
.globl vector89
vector89:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $89
  10221f:	6a 59                	push   $0x59
  jmp __alltraps
  102221:	e9 c4 fc ff ff       	jmp    101eea <__alltraps>

00102226 <vector90>:
.globl vector90
vector90:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $90
  102228:	6a 5a                	push   $0x5a
  jmp __alltraps
  10222a:	e9 bb fc ff ff       	jmp    101eea <__alltraps>

0010222f <vector91>:
.globl vector91
vector91:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $91
  102231:	6a 5b                	push   $0x5b
  jmp __alltraps
  102233:	e9 b2 fc ff ff       	jmp    101eea <__alltraps>

00102238 <vector92>:
.globl vector92
vector92:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $92
  10223a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10223c:	e9 a9 fc ff ff       	jmp    101eea <__alltraps>

00102241 <vector93>:
.globl vector93
vector93:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $93
  102243:	6a 5d                	push   $0x5d
  jmp __alltraps
  102245:	e9 a0 fc ff ff       	jmp    101eea <__alltraps>

0010224a <vector94>:
.globl vector94
vector94:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $94
  10224c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10224e:	e9 97 fc ff ff       	jmp    101eea <__alltraps>

00102253 <vector95>:
.globl vector95
vector95:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $95
  102255:	6a 5f                	push   $0x5f
  jmp __alltraps
  102257:	e9 8e fc ff ff       	jmp    101eea <__alltraps>

0010225c <vector96>:
.globl vector96
vector96:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $96
  10225e:	6a 60                	push   $0x60
  jmp __alltraps
  102260:	e9 85 fc ff ff       	jmp    101eea <__alltraps>

00102265 <vector97>:
.globl vector97
vector97:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $97
  102267:	6a 61                	push   $0x61
  jmp __alltraps
  102269:	e9 7c fc ff ff       	jmp    101eea <__alltraps>

0010226e <vector98>:
.globl vector98
vector98:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $98
  102270:	6a 62                	push   $0x62
  jmp __alltraps
  102272:	e9 73 fc ff ff       	jmp    101eea <__alltraps>

00102277 <vector99>:
.globl vector99
vector99:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $99
  102279:	6a 63                	push   $0x63
  jmp __alltraps
  10227b:	e9 6a fc ff ff       	jmp    101eea <__alltraps>

00102280 <vector100>:
.globl vector100
vector100:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $100
  102282:	6a 64                	push   $0x64
  jmp __alltraps
  102284:	e9 61 fc ff ff       	jmp    101eea <__alltraps>

00102289 <vector101>:
.globl vector101
vector101:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $101
  10228b:	6a 65                	push   $0x65
  jmp __alltraps
  10228d:	e9 58 fc ff ff       	jmp    101eea <__alltraps>

00102292 <vector102>:
.globl vector102
vector102:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $102
  102294:	6a 66                	push   $0x66
  jmp __alltraps
  102296:	e9 4f fc ff ff       	jmp    101eea <__alltraps>

0010229b <vector103>:
.globl vector103
vector103:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $103
  10229d:	6a 67                	push   $0x67
  jmp __alltraps
  10229f:	e9 46 fc ff ff       	jmp    101eea <__alltraps>

001022a4 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $104
  1022a6:	6a 68                	push   $0x68
  jmp __alltraps
  1022a8:	e9 3d fc ff ff       	jmp    101eea <__alltraps>

001022ad <vector105>:
.globl vector105
vector105:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $105
  1022af:	6a 69                	push   $0x69
  jmp __alltraps
  1022b1:	e9 34 fc ff ff       	jmp    101eea <__alltraps>

001022b6 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $106
  1022b8:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022ba:	e9 2b fc ff ff       	jmp    101eea <__alltraps>

001022bf <vector107>:
.globl vector107
vector107:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $107
  1022c1:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022c3:	e9 22 fc ff ff       	jmp    101eea <__alltraps>

001022c8 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $108
  1022ca:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022cc:	e9 19 fc ff ff       	jmp    101eea <__alltraps>

001022d1 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $109
  1022d3:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022d5:	e9 10 fc ff ff       	jmp    101eea <__alltraps>

001022da <vector110>:
.globl vector110
vector110:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $110
  1022dc:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022de:	e9 07 fc ff ff       	jmp    101eea <__alltraps>

001022e3 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $111
  1022e5:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022e7:	e9 fe fb ff ff       	jmp    101eea <__alltraps>

001022ec <vector112>:
.globl vector112
vector112:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $112
  1022ee:	6a 70                	push   $0x70
  jmp __alltraps
  1022f0:	e9 f5 fb ff ff       	jmp    101eea <__alltraps>

001022f5 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $113
  1022f7:	6a 71                	push   $0x71
  jmp __alltraps
  1022f9:	e9 ec fb ff ff       	jmp    101eea <__alltraps>

001022fe <vector114>:
.globl vector114
vector114:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $114
  102300:	6a 72                	push   $0x72
  jmp __alltraps
  102302:	e9 e3 fb ff ff       	jmp    101eea <__alltraps>

00102307 <vector115>:
.globl vector115
vector115:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $115
  102309:	6a 73                	push   $0x73
  jmp __alltraps
  10230b:	e9 da fb ff ff       	jmp    101eea <__alltraps>

00102310 <vector116>:
.globl vector116
vector116:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $116
  102312:	6a 74                	push   $0x74
  jmp __alltraps
  102314:	e9 d1 fb ff ff       	jmp    101eea <__alltraps>

00102319 <vector117>:
.globl vector117
vector117:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $117
  10231b:	6a 75                	push   $0x75
  jmp __alltraps
  10231d:	e9 c8 fb ff ff       	jmp    101eea <__alltraps>

00102322 <vector118>:
.globl vector118
vector118:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $118
  102324:	6a 76                	push   $0x76
  jmp __alltraps
  102326:	e9 bf fb ff ff       	jmp    101eea <__alltraps>

0010232b <vector119>:
.globl vector119
vector119:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $119
  10232d:	6a 77                	push   $0x77
  jmp __alltraps
  10232f:	e9 b6 fb ff ff       	jmp    101eea <__alltraps>

00102334 <vector120>:
.globl vector120
vector120:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $120
  102336:	6a 78                	push   $0x78
  jmp __alltraps
  102338:	e9 ad fb ff ff       	jmp    101eea <__alltraps>

0010233d <vector121>:
.globl vector121
vector121:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $121
  10233f:	6a 79                	push   $0x79
  jmp __alltraps
  102341:	e9 a4 fb ff ff       	jmp    101eea <__alltraps>

00102346 <vector122>:
.globl vector122
vector122:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $122
  102348:	6a 7a                	push   $0x7a
  jmp __alltraps
  10234a:	e9 9b fb ff ff       	jmp    101eea <__alltraps>

0010234f <vector123>:
.globl vector123
vector123:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $123
  102351:	6a 7b                	push   $0x7b
  jmp __alltraps
  102353:	e9 92 fb ff ff       	jmp    101eea <__alltraps>

00102358 <vector124>:
.globl vector124
vector124:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $124
  10235a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10235c:	e9 89 fb ff ff       	jmp    101eea <__alltraps>

00102361 <vector125>:
.globl vector125
vector125:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $125
  102363:	6a 7d                	push   $0x7d
  jmp __alltraps
  102365:	e9 80 fb ff ff       	jmp    101eea <__alltraps>

0010236a <vector126>:
.globl vector126
vector126:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $126
  10236c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10236e:	e9 77 fb ff ff       	jmp    101eea <__alltraps>

00102373 <vector127>:
.globl vector127
vector127:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $127
  102375:	6a 7f                	push   $0x7f
  jmp __alltraps
  102377:	e9 6e fb ff ff       	jmp    101eea <__alltraps>

0010237c <vector128>:
.globl vector128
vector128:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $128
  10237e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102383:	e9 62 fb ff ff       	jmp    101eea <__alltraps>

00102388 <vector129>:
.globl vector129
vector129:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $129
  10238a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10238f:	e9 56 fb ff ff       	jmp    101eea <__alltraps>

00102394 <vector130>:
.globl vector130
vector130:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $130
  102396:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10239b:	e9 4a fb ff ff       	jmp    101eea <__alltraps>

001023a0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $131
  1023a2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023a7:	e9 3e fb ff ff       	jmp    101eea <__alltraps>

001023ac <vector132>:
.globl vector132
vector132:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $132
  1023ae:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023b3:	e9 32 fb ff ff       	jmp    101eea <__alltraps>

001023b8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $133
  1023ba:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023bf:	e9 26 fb ff ff       	jmp    101eea <__alltraps>

001023c4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $134
  1023c6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023cb:	e9 1a fb ff ff       	jmp    101eea <__alltraps>

001023d0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $135
  1023d2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023d7:	e9 0e fb ff ff       	jmp    101eea <__alltraps>

001023dc <vector136>:
.globl vector136
vector136:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $136
  1023de:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023e3:	e9 02 fb ff ff       	jmp    101eea <__alltraps>

001023e8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $137
  1023ea:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023ef:	e9 f6 fa ff ff       	jmp    101eea <__alltraps>

001023f4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $138
  1023f6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023fb:	e9 ea fa ff ff       	jmp    101eea <__alltraps>

00102400 <vector139>:
.globl vector139
vector139:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $139
  102402:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102407:	e9 de fa ff ff       	jmp    101eea <__alltraps>

0010240c <vector140>:
.globl vector140
vector140:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $140
  10240e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102413:	e9 d2 fa ff ff       	jmp    101eea <__alltraps>

00102418 <vector141>:
.globl vector141
vector141:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $141
  10241a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10241f:	e9 c6 fa ff ff       	jmp    101eea <__alltraps>

00102424 <vector142>:
.globl vector142
vector142:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $142
  102426:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10242b:	e9 ba fa ff ff       	jmp    101eea <__alltraps>

00102430 <vector143>:
.globl vector143
vector143:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $143
  102432:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102437:	e9 ae fa ff ff       	jmp    101eea <__alltraps>

0010243c <vector144>:
.globl vector144
vector144:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $144
  10243e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102443:	e9 a2 fa ff ff       	jmp    101eea <__alltraps>

00102448 <vector145>:
.globl vector145
vector145:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $145
  10244a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10244f:	e9 96 fa ff ff       	jmp    101eea <__alltraps>

00102454 <vector146>:
.globl vector146
vector146:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $146
  102456:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10245b:	e9 8a fa ff ff       	jmp    101eea <__alltraps>

00102460 <vector147>:
.globl vector147
vector147:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $147
  102462:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102467:	e9 7e fa ff ff       	jmp    101eea <__alltraps>

0010246c <vector148>:
.globl vector148
vector148:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $148
  10246e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102473:	e9 72 fa ff ff       	jmp    101eea <__alltraps>

00102478 <vector149>:
.globl vector149
vector149:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $149
  10247a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10247f:	e9 66 fa ff ff       	jmp    101eea <__alltraps>

00102484 <vector150>:
.globl vector150
vector150:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $150
  102486:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10248b:	e9 5a fa ff ff       	jmp    101eea <__alltraps>

00102490 <vector151>:
.globl vector151
vector151:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $151
  102492:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102497:	e9 4e fa ff ff       	jmp    101eea <__alltraps>

0010249c <vector152>:
.globl vector152
vector152:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $152
  10249e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024a3:	e9 42 fa ff ff       	jmp    101eea <__alltraps>

001024a8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $153
  1024aa:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024af:	e9 36 fa ff ff       	jmp    101eea <__alltraps>

001024b4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $154
  1024b6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024bb:	e9 2a fa ff ff       	jmp    101eea <__alltraps>

001024c0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $155
  1024c2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024c7:	e9 1e fa ff ff       	jmp    101eea <__alltraps>

001024cc <vector156>:
.globl vector156
vector156:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $156
  1024ce:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024d3:	e9 12 fa ff ff       	jmp    101eea <__alltraps>

001024d8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $157
  1024da:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024df:	e9 06 fa ff ff       	jmp    101eea <__alltraps>

001024e4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $158
  1024e6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024eb:	e9 fa f9 ff ff       	jmp    101eea <__alltraps>

001024f0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $159
  1024f2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024f7:	e9 ee f9 ff ff       	jmp    101eea <__alltraps>

001024fc <vector160>:
.globl vector160
vector160:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $160
  1024fe:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102503:	e9 e2 f9 ff ff       	jmp    101eea <__alltraps>

00102508 <vector161>:
.globl vector161
vector161:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $161
  10250a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10250f:	e9 d6 f9 ff ff       	jmp    101eea <__alltraps>

00102514 <vector162>:
.globl vector162
vector162:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $162
  102516:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10251b:	e9 ca f9 ff ff       	jmp    101eea <__alltraps>

00102520 <vector163>:
.globl vector163
vector163:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $163
  102522:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102527:	e9 be f9 ff ff       	jmp    101eea <__alltraps>

0010252c <vector164>:
.globl vector164
vector164:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $164
  10252e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102533:	e9 b2 f9 ff ff       	jmp    101eea <__alltraps>

00102538 <vector165>:
.globl vector165
vector165:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $165
  10253a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10253f:	e9 a6 f9 ff ff       	jmp    101eea <__alltraps>

00102544 <vector166>:
.globl vector166
vector166:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $166
  102546:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10254b:	e9 9a f9 ff ff       	jmp    101eea <__alltraps>

00102550 <vector167>:
.globl vector167
vector167:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $167
  102552:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102557:	e9 8e f9 ff ff       	jmp    101eea <__alltraps>

0010255c <vector168>:
.globl vector168
vector168:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $168
  10255e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102563:	e9 82 f9 ff ff       	jmp    101eea <__alltraps>

00102568 <vector169>:
.globl vector169
vector169:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $169
  10256a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10256f:	e9 76 f9 ff ff       	jmp    101eea <__alltraps>

00102574 <vector170>:
.globl vector170
vector170:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $170
  102576:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10257b:	e9 6a f9 ff ff       	jmp    101eea <__alltraps>

00102580 <vector171>:
.globl vector171
vector171:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $171
  102582:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102587:	e9 5e f9 ff ff       	jmp    101eea <__alltraps>

0010258c <vector172>:
.globl vector172
vector172:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $172
  10258e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102593:	e9 52 f9 ff ff       	jmp    101eea <__alltraps>

00102598 <vector173>:
.globl vector173
vector173:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $173
  10259a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10259f:	e9 46 f9 ff ff       	jmp    101eea <__alltraps>

001025a4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $174
  1025a6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025ab:	e9 3a f9 ff ff       	jmp    101eea <__alltraps>

001025b0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $175
  1025b2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025b7:	e9 2e f9 ff ff       	jmp    101eea <__alltraps>

001025bc <vector176>:
.globl vector176
vector176:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $176
  1025be:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025c3:	e9 22 f9 ff ff       	jmp    101eea <__alltraps>

001025c8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $177
  1025ca:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025cf:	e9 16 f9 ff ff       	jmp    101eea <__alltraps>

001025d4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $178
  1025d6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025db:	e9 0a f9 ff ff       	jmp    101eea <__alltraps>

001025e0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $179
  1025e2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025e7:	e9 fe f8 ff ff       	jmp    101eea <__alltraps>

001025ec <vector180>:
.globl vector180
vector180:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $180
  1025ee:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025f3:	e9 f2 f8 ff ff       	jmp    101eea <__alltraps>

001025f8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $181
  1025fa:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025ff:	e9 e6 f8 ff ff       	jmp    101eea <__alltraps>

00102604 <vector182>:
.globl vector182
vector182:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $182
  102606:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10260b:	e9 da f8 ff ff       	jmp    101eea <__alltraps>

00102610 <vector183>:
.globl vector183
vector183:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $183
  102612:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102617:	e9 ce f8 ff ff       	jmp    101eea <__alltraps>

0010261c <vector184>:
.globl vector184
vector184:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $184
  10261e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102623:	e9 c2 f8 ff ff       	jmp    101eea <__alltraps>

00102628 <vector185>:
.globl vector185
vector185:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $185
  10262a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10262f:	e9 b6 f8 ff ff       	jmp    101eea <__alltraps>

00102634 <vector186>:
.globl vector186
vector186:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $186
  102636:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10263b:	e9 aa f8 ff ff       	jmp    101eea <__alltraps>

00102640 <vector187>:
.globl vector187
vector187:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $187
  102642:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102647:	e9 9e f8 ff ff       	jmp    101eea <__alltraps>

0010264c <vector188>:
.globl vector188
vector188:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $188
  10264e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102653:	e9 92 f8 ff ff       	jmp    101eea <__alltraps>

00102658 <vector189>:
.globl vector189
vector189:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $189
  10265a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10265f:	e9 86 f8 ff ff       	jmp    101eea <__alltraps>

00102664 <vector190>:
.globl vector190
vector190:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $190
  102666:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10266b:	e9 7a f8 ff ff       	jmp    101eea <__alltraps>

00102670 <vector191>:
.globl vector191
vector191:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $191
  102672:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102677:	e9 6e f8 ff ff       	jmp    101eea <__alltraps>

0010267c <vector192>:
.globl vector192
vector192:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $192
  10267e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102683:	e9 62 f8 ff ff       	jmp    101eea <__alltraps>

00102688 <vector193>:
.globl vector193
vector193:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $193
  10268a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10268f:	e9 56 f8 ff ff       	jmp    101eea <__alltraps>

00102694 <vector194>:
.globl vector194
vector194:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $194
  102696:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10269b:	e9 4a f8 ff ff       	jmp    101eea <__alltraps>

001026a0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $195
  1026a2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026a7:	e9 3e f8 ff ff       	jmp    101eea <__alltraps>

001026ac <vector196>:
.globl vector196
vector196:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $196
  1026ae:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026b3:	e9 32 f8 ff ff       	jmp    101eea <__alltraps>

001026b8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $197
  1026ba:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026bf:	e9 26 f8 ff ff       	jmp    101eea <__alltraps>

001026c4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $198
  1026c6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026cb:	e9 1a f8 ff ff       	jmp    101eea <__alltraps>

001026d0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $199
  1026d2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026d7:	e9 0e f8 ff ff       	jmp    101eea <__alltraps>

001026dc <vector200>:
.globl vector200
vector200:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $200
  1026de:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026e3:	e9 02 f8 ff ff       	jmp    101eea <__alltraps>

001026e8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $201
  1026ea:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026ef:	e9 f6 f7 ff ff       	jmp    101eea <__alltraps>

001026f4 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $202
  1026f6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026fb:	e9 ea f7 ff ff       	jmp    101eea <__alltraps>

00102700 <vector203>:
.globl vector203
vector203:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $203
  102702:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102707:	e9 de f7 ff ff       	jmp    101eea <__alltraps>

0010270c <vector204>:
.globl vector204
vector204:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $204
  10270e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102713:	e9 d2 f7 ff ff       	jmp    101eea <__alltraps>

00102718 <vector205>:
.globl vector205
vector205:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $205
  10271a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10271f:	e9 c6 f7 ff ff       	jmp    101eea <__alltraps>

00102724 <vector206>:
.globl vector206
vector206:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $206
  102726:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10272b:	e9 ba f7 ff ff       	jmp    101eea <__alltraps>

00102730 <vector207>:
.globl vector207
vector207:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $207
  102732:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102737:	e9 ae f7 ff ff       	jmp    101eea <__alltraps>

0010273c <vector208>:
.globl vector208
vector208:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $208
  10273e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102743:	e9 a2 f7 ff ff       	jmp    101eea <__alltraps>

00102748 <vector209>:
.globl vector209
vector209:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $209
  10274a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10274f:	e9 96 f7 ff ff       	jmp    101eea <__alltraps>

00102754 <vector210>:
.globl vector210
vector210:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $210
  102756:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10275b:	e9 8a f7 ff ff       	jmp    101eea <__alltraps>

00102760 <vector211>:
.globl vector211
vector211:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $211
  102762:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102767:	e9 7e f7 ff ff       	jmp    101eea <__alltraps>

0010276c <vector212>:
.globl vector212
vector212:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $212
  10276e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102773:	e9 72 f7 ff ff       	jmp    101eea <__alltraps>

00102778 <vector213>:
.globl vector213
vector213:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $213
  10277a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10277f:	e9 66 f7 ff ff       	jmp    101eea <__alltraps>

00102784 <vector214>:
.globl vector214
vector214:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $214
  102786:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10278b:	e9 5a f7 ff ff       	jmp    101eea <__alltraps>

00102790 <vector215>:
.globl vector215
vector215:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $215
  102792:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102797:	e9 4e f7 ff ff       	jmp    101eea <__alltraps>

0010279c <vector216>:
.globl vector216
vector216:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $216
  10279e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027a3:	e9 42 f7 ff ff       	jmp    101eea <__alltraps>

001027a8 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $217
  1027aa:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027af:	e9 36 f7 ff ff       	jmp    101eea <__alltraps>

001027b4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $218
  1027b6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027bb:	e9 2a f7 ff ff       	jmp    101eea <__alltraps>

001027c0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $219
  1027c2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027c7:	e9 1e f7 ff ff       	jmp    101eea <__alltraps>

001027cc <vector220>:
.globl vector220
vector220:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $220
  1027ce:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027d3:	e9 12 f7 ff ff       	jmp    101eea <__alltraps>

001027d8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $221
  1027da:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027df:	e9 06 f7 ff ff       	jmp    101eea <__alltraps>

001027e4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $222
  1027e6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027eb:	e9 fa f6 ff ff       	jmp    101eea <__alltraps>

001027f0 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $223
  1027f2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027f7:	e9 ee f6 ff ff       	jmp    101eea <__alltraps>

001027fc <vector224>:
.globl vector224
vector224:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $224
  1027fe:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102803:	e9 e2 f6 ff ff       	jmp    101eea <__alltraps>

00102808 <vector225>:
.globl vector225
vector225:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $225
  10280a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10280f:	e9 d6 f6 ff ff       	jmp    101eea <__alltraps>

00102814 <vector226>:
.globl vector226
vector226:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $226
  102816:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10281b:	e9 ca f6 ff ff       	jmp    101eea <__alltraps>

00102820 <vector227>:
.globl vector227
vector227:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $227
  102822:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102827:	e9 be f6 ff ff       	jmp    101eea <__alltraps>

0010282c <vector228>:
.globl vector228
vector228:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $228
  10282e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102833:	e9 b2 f6 ff ff       	jmp    101eea <__alltraps>

00102838 <vector229>:
.globl vector229
vector229:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $229
  10283a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10283f:	e9 a6 f6 ff ff       	jmp    101eea <__alltraps>

00102844 <vector230>:
.globl vector230
vector230:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $230
  102846:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10284b:	e9 9a f6 ff ff       	jmp    101eea <__alltraps>

00102850 <vector231>:
.globl vector231
vector231:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $231
  102852:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102857:	e9 8e f6 ff ff       	jmp    101eea <__alltraps>

0010285c <vector232>:
.globl vector232
vector232:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $232
  10285e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102863:	e9 82 f6 ff ff       	jmp    101eea <__alltraps>

00102868 <vector233>:
.globl vector233
vector233:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $233
  10286a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10286f:	e9 76 f6 ff ff       	jmp    101eea <__alltraps>

00102874 <vector234>:
.globl vector234
vector234:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $234
  102876:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10287b:	e9 6a f6 ff ff       	jmp    101eea <__alltraps>

00102880 <vector235>:
.globl vector235
vector235:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $235
  102882:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102887:	e9 5e f6 ff ff       	jmp    101eea <__alltraps>

0010288c <vector236>:
.globl vector236
vector236:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $236
  10288e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102893:	e9 52 f6 ff ff       	jmp    101eea <__alltraps>

00102898 <vector237>:
.globl vector237
vector237:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $237
  10289a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10289f:	e9 46 f6 ff ff       	jmp    101eea <__alltraps>

001028a4 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $238
  1028a6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028ab:	e9 3a f6 ff ff       	jmp    101eea <__alltraps>

001028b0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $239
  1028b2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028b7:	e9 2e f6 ff ff       	jmp    101eea <__alltraps>

001028bc <vector240>:
.globl vector240
vector240:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $240
  1028be:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028c3:	e9 22 f6 ff ff       	jmp    101eea <__alltraps>

001028c8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $241
  1028ca:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028cf:	e9 16 f6 ff ff       	jmp    101eea <__alltraps>

001028d4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028d4:	6a 00                	push   $0x0
  pushl $242
  1028d6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028db:	e9 0a f6 ff ff       	jmp    101eea <__alltraps>

001028e0 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028e0:	6a 00                	push   $0x0
  pushl $243
  1028e2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028e7:	e9 fe f5 ff ff       	jmp    101eea <__alltraps>

001028ec <vector244>:
.globl vector244
vector244:
  pushl $0
  1028ec:	6a 00                	push   $0x0
  pushl $244
  1028ee:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028f3:	e9 f2 f5 ff ff       	jmp    101eea <__alltraps>

001028f8 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028f8:	6a 00                	push   $0x0
  pushl $245
  1028fa:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028ff:	e9 e6 f5 ff ff       	jmp    101eea <__alltraps>

00102904 <vector246>:
.globl vector246
vector246:
  pushl $0
  102904:	6a 00                	push   $0x0
  pushl $246
  102906:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10290b:	e9 da f5 ff ff       	jmp    101eea <__alltraps>

00102910 <vector247>:
.globl vector247
vector247:
  pushl $0
  102910:	6a 00                	push   $0x0
  pushl $247
  102912:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102917:	e9 ce f5 ff ff       	jmp    101eea <__alltraps>

0010291c <vector248>:
.globl vector248
vector248:
  pushl $0
  10291c:	6a 00                	push   $0x0
  pushl $248
  10291e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102923:	e9 c2 f5 ff ff       	jmp    101eea <__alltraps>

00102928 <vector249>:
.globl vector249
vector249:
  pushl $0
  102928:	6a 00                	push   $0x0
  pushl $249
  10292a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10292f:	e9 b6 f5 ff ff       	jmp    101eea <__alltraps>

00102934 <vector250>:
.globl vector250
vector250:
  pushl $0
  102934:	6a 00                	push   $0x0
  pushl $250
  102936:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10293b:	e9 aa f5 ff ff       	jmp    101eea <__alltraps>

00102940 <vector251>:
.globl vector251
vector251:
  pushl $0
  102940:	6a 00                	push   $0x0
  pushl $251
  102942:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102947:	e9 9e f5 ff ff       	jmp    101eea <__alltraps>

0010294c <vector252>:
.globl vector252
vector252:
  pushl $0
  10294c:	6a 00                	push   $0x0
  pushl $252
  10294e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102953:	e9 92 f5 ff ff       	jmp    101eea <__alltraps>

00102958 <vector253>:
.globl vector253
vector253:
  pushl $0
  102958:	6a 00                	push   $0x0
  pushl $253
  10295a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10295f:	e9 86 f5 ff ff       	jmp    101eea <__alltraps>

00102964 <vector254>:
.globl vector254
vector254:
  pushl $0
  102964:	6a 00                	push   $0x0
  pushl $254
  102966:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10296b:	e9 7a f5 ff ff       	jmp    101eea <__alltraps>

00102970 <vector255>:
.globl vector255
vector255:
  pushl $0
  102970:	6a 00                	push   $0x0
  pushl $255
  102972:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102977:	e9 6e f5 ff ff       	jmp    101eea <__alltraps>

0010297c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10297c:	55                   	push   %ebp
  10297d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10297f:	8b 45 08             	mov    0x8(%ebp),%eax
  102982:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102985:	b8 23 00 00 00       	mov    $0x23,%eax
  10298a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10298c:	b8 23 00 00 00       	mov    $0x23,%eax
  102991:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102993:	b8 10 00 00 00       	mov    $0x10,%eax
  102998:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10299a:	b8 10 00 00 00       	mov    $0x10,%eax
  10299f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029a1:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029a8:	ea af 29 10 00 08 00 	ljmp   $0x8,$0x1029af
}
  1029af:	90                   	nop
  1029b0:	5d                   	pop    %ebp
  1029b1:	c3                   	ret    

001029b2 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029b2:	55                   	push   %ebp
  1029b3:	89 e5                	mov    %esp,%ebp
  1029b5:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029b8:	b8 00 09 11 00       	mov    $0x110900,%eax
  1029bd:	05 00 04 00 00       	add    $0x400,%eax
  1029c2:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  1029c7:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  1029ce:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029d0:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  1029d7:	68 00 
  1029d9:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029de:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1029e4:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  1029e9:	c1 e8 10             	shr    $0x10,%eax
  1029ec:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1029f1:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1029f8:	83 e0 f0             	and    $0xfffffff0,%eax
  1029fb:	83 c8 09             	or     $0x9,%eax
  1029fe:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a03:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a0a:	83 c8 10             	or     $0x10,%eax
  102a0d:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a12:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a19:	83 e0 9f             	and    $0xffffff9f,%eax
  102a1c:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a21:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a28:	83 c8 80             	or     $0xffffff80,%eax
  102a2b:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a30:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a37:	83 e0 f0             	and    $0xfffffff0,%eax
  102a3a:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a3f:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a46:	83 e0 ef             	and    $0xffffffef,%eax
  102a49:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a4e:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a55:	83 e0 df             	and    $0xffffffdf,%eax
  102a58:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a5d:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a64:	83 c8 40             	or     $0x40,%eax
  102a67:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a6c:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a73:	83 e0 7f             	and    $0x7f,%eax
  102a76:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a7b:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a80:	c1 e8 18             	shr    $0x18,%eax
  102a83:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102a88:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a8f:	83 e0 ef             	and    $0xffffffef,%eax
  102a92:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a97:	68 10 fa 10 00       	push   $0x10fa10
  102a9c:	e8 db fe ff ff       	call   10297c <lgdt>
  102aa1:	83 c4 04             	add    $0x4,%esp
  102aa4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102aaa:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aae:	0f 00 d8             	ltr    %ax
}
  102ab1:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102ab2:	90                   	nop
  102ab3:	c9                   	leave  
  102ab4:	c3                   	ret    

00102ab5 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ab5:	55                   	push   %ebp
  102ab6:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ab8:	e8 f5 fe ff ff       	call   1029b2 <gdt_init>
}
  102abd:	90                   	nop
  102abe:	5d                   	pop    %ebp
  102abf:	c3                   	ret    

00102ac0 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102ac0:	55                   	push   %ebp
  102ac1:	89 e5                	mov    %esp,%ebp
  102ac3:	83 ec 38             	sub    $0x38,%esp
  102ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  102ac9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102acc:	8b 45 14             	mov    0x14(%ebp),%eax
  102acf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102ad2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ad5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ad8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102adb:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102ade:	8b 45 18             	mov    0x18(%ebp),%eax
  102ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102aed:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102af6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102afa:	74 1c                	je     102b18 <printnum+0x58>
  102afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aff:	ba 00 00 00 00       	mov    $0x0,%edx
  102b04:	f7 75 e4             	divl   -0x1c(%ebp)
  102b07:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  102b12:	f7 75 e4             	divl   -0x1c(%ebp)
  102b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b1e:	f7 75 e4             	divl   -0x1c(%ebp)
  102b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b24:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b30:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b36:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b39:	8b 45 18             	mov    0x18(%ebp),%eax
  102b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  102b41:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102b44:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102b47:	19 d1                	sbb    %edx,%ecx
  102b49:	72 37                	jb     102b82 <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b4b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b4e:	83 e8 01             	sub    $0x1,%eax
  102b51:	83 ec 04             	sub    $0x4,%esp
  102b54:	ff 75 20             	push   0x20(%ebp)
  102b57:	50                   	push   %eax
  102b58:	ff 75 18             	push   0x18(%ebp)
  102b5b:	ff 75 ec             	push   -0x14(%ebp)
  102b5e:	ff 75 e8             	push   -0x18(%ebp)
  102b61:	ff 75 0c             	push   0xc(%ebp)
  102b64:	ff 75 08             	push   0x8(%ebp)
  102b67:	e8 54 ff ff ff       	call   102ac0 <printnum>
  102b6c:	83 c4 20             	add    $0x20,%esp
  102b6f:	eb 1b                	jmp    102b8c <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b71:	83 ec 08             	sub    $0x8,%esp
  102b74:	ff 75 0c             	push   0xc(%ebp)
  102b77:	ff 75 20             	push   0x20(%ebp)
  102b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7d:	ff d0                	call   *%eax
  102b7f:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  102b82:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b86:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b8a:	7f e5                	jg     102b71 <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b8f:	05 30 3d 10 00       	add    $0x103d30,%eax
  102b94:	0f b6 00             	movzbl (%eax),%eax
  102b97:	0f be c0             	movsbl %al,%eax
  102b9a:	83 ec 08             	sub    $0x8,%esp
  102b9d:	ff 75 0c             	push   0xc(%ebp)
  102ba0:	50                   	push   %eax
  102ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba4:	ff d0                	call   *%eax
  102ba6:	83 c4 10             	add    $0x10,%esp
}
  102ba9:	90                   	nop
  102baa:	c9                   	leave  
  102bab:	c3                   	ret    

00102bac <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102bac:	55                   	push   %ebp
  102bad:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102baf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bb3:	7e 14                	jle    102bc9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb8:	8b 00                	mov    (%eax),%eax
  102bba:	8d 48 08             	lea    0x8(%eax),%ecx
  102bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc0:	89 0a                	mov    %ecx,(%edx)
  102bc2:	8b 50 04             	mov    0x4(%eax),%edx
  102bc5:	8b 00                	mov    (%eax),%eax
  102bc7:	eb 30                	jmp    102bf9 <getuint+0x4d>
    }
    else if (lflag) {
  102bc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bcd:	74 16                	je     102be5 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd2:	8b 00                	mov    (%eax),%eax
  102bd4:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  102bda:	89 0a                	mov    %ecx,(%edx)
  102bdc:	8b 00                	mov    (%eax),%eax
  102bde:	ba 00 00 00 00       	mov    $0x0,%edx
  102be3:	eb 14                	jmp    102bf9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102be5:	8b 45 08             	mov    0x8(%ebp),%eax
  102be8:	8b 00                	mov    (%eax),%eax
  102bea:	8d 48 04             	lea    0x4(%eax),%ecx
  102bed:	8b 55 08             	mov    0x8(%ebp),%edx
  102bf0:	89 0a                	mov    %ecx,(%edx)
  102bf2:	8b 00                	mov    (%eax),%eax
  102bf4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102bf9:	5d                   	pop    %ebp
  102bfa:	c3                   	ret    

00102bfb <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102bfb:	55                   	push   %ebp
  102bfc:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bfe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c02:	7e 14                	jle    102c18 <getint+0x1d>
        return va_arg(*ap, long long);
  102c04:	8b 45 08             	mov    0x8(%ebp),%eax
  102c07:	8b 00                	mov    (%eax),%eax
  102c09:	8d 48 08             	lea    0x8(%eax),%ecx
  102c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  102c0f:	89 0a                	mov    %ecx,(%edx)
  102c11:	8b 50 04             	mov    0x4(%eax),%edx
  102c14:	8b 00                	mov    (%eax),%eax
  102c16:	eb 28                	jmp    102c40 <getint+0x45>
    }
    else if (lflag) {
  102c18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c1c:	74 12                	je     102c30 <getint+0x35>
        return va_arg(*ap, long);
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	8b 00                	mov    (%eax),%eax
  102c23:	8d 48 04             	lea    0x4(%eax),%ecx
  102c26:	8b 55 08             	mov    0x8(%ebp),%edx
  102c29:	89 0a                	mov    %ecx,(%edx)
  102c2b:	8b 00                	mov    (%eax),%eax
  102c2d:	99                   	cltd   
  102c2e:	eb 10                	jmp    102c40 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c30:	8b 45 08             	mov    0x8(%ebp),%eax
  102c33:	8b 00                	mov    (%eax),%eax
  102c35:	8d 48 04             	lea    0x4(%eax),%ecx
  102c38:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3b:	89 0a                	mov    %ecx,(%edx)
  102c3d:	8b 00                	mov    (%eax),%eax
  102c3f:	99                   	cltd   
    }
}
  102c40:	5d                   	pop    %ebp
  102c41:	c3                   	ret    

00102c42 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c42:	55                   	push   %ebp
  102c43:	89 e5                	mov    %esp,%ebp
  102c45:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102c48:	8d 45 14             	lea    0x14(%ebp),%eax
  102c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c51:	50                   	push   %eax
  102c52:	ff 75 10             	push   0x10(%ebp)
  102c55:	ff 75 0c             	push   0xc(%ebp)
  102c58:	ff 75 08             	push   0x8(%ebp)
  102c5b:	e8 06 00 00 00       	call   102c66 <vprintfmt>
  102c60:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102c63:	90                   	nop
  102c64:	c9                   	leave  
  102c65:	c3                   	ret    

00102c66 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c66:	55                   	push   %ebp
  102c67:	89 e5                	mov    %esp,%ebp
  102c69:	56                   	push   %esi
  102c6a:	53                   	push   %ebx
  102c6b:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c6e:	eb 17                	jmp    102c87 <vprintfmt+0x21>
            if (ch == '\0') {
  102c70:	85 db                	test   %ebx,%ebx
  102c72:	0f 84 8e 03 00 00    	je     103006 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102c78:	83 ec 08             	sub    $0x8,%esp
  102c7b:	ff 75 0c             	push   0xc(%ebp)
  102c7e:	53                   	push   %ebx
  102c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c82:	ff d0                	call   *%eax
  102c84:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c87:	8b 45 10             	mov    0x10(%ebp),%eax
  102c8a:	8d 50 01             	lea    0x1(%eax),%edx
  102c8d:	89 55 10             	mov    %edx,0x10(%ebp)
  102c90:	0f b6 00             	movzbl (%eax),%eax
  102c93:	0f b6 d8             	movzbl %al,%ebx
  102c96:	83 fb 25             	cmp    $0x25,%ebx
  102c99:	75 d5                	jne    102c70 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c9b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c9f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ca9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102cac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  102cbc:	8d 50 01             	lea    0x1(%eax),%edx
  102cbf:	89 55 10             	mov    %edx,0x10(%ebp)
  102cc2:	0f b6 00             	movzbl (%eax),%eax
  102cc5:	0f b6 d8             	movzbl %al,%ebx
  102cc8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ccb:	83 f8 55             	cmp    $0x55,%eax
  102cce:	0f 87 05 03 00 00    	ja     102fd9 <vprintfmt+0x373>
  102cd4:	8b 04 85 54 3d 10 00 	mov    0x103d54(,%eax,4),%eax
  102cdb:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cdd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102ce1:	eb d6                	jmp    102cb9 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102ce3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102ce7:	eb d0                	jmp    102cb9 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ce9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102cf0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cf3:	89 d0                	mov    %edx,%eax
  102cf5:	c1 e0 02             	shl    $0x2,%eax
  102cf8:	01 d0                	add    %edx,%eax
  102cfa:	01 c0                	add    %eax,%eax
  102cfc:	01 d8                	add    %ebx,%eax
  102cfe:	83 e8 30             	sub    $0x30,%eax
  102d01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d04:	8b 45 10             	mov    0x10(%ebp),%eax
  102d07:	0f b6 00             	movzbl (%eax),%eax
  102d0a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d0d:	83 fb 2f             	cmp    $0x2f,%ebx
  102d10:	7e 39                	jle    102d4b <vprintfmt+0xe5>
  102d12:	83 fb 39             	cmp    $0x39,%ebx
  102d15:	7f 34                	jg     102d4b <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  102d17:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102d1b:	eb d3                	jmp    102cf0 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  102d20:	8d 50 04             	lea    0x4(%eax),%edx
  102d23:	89 55 14             	mov    %edx,0x14(%ebp)
  102d26:	8b 00                	mov    (%eax),%eax
  102d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d2b:	eb 1f                	jmp    102d4c <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  102d2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d31:	79 86                	jns    102cb9 <vprintfmt+0x53>
                width = 0;
  102d33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d3a:	e9 7a ff ff ff       	jmp    102cb9 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102d3f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d46:	e9 6e ff ff ff       	jmp    102cb9 <vprintfmt+0x53>
            goto process_precision;
  102d4b:	90                   	nop

        process_precision:
            if (width < 0)
  102d4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d50:	0f 89 63 ff ff ff    	jns    102cb9 <vprintfmt+0x53>
                width = precision, precision = -1;
  102d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d59:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d5c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d63:	e9 51 ff ff ff       	jmp    102cb9 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d68:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d6c:	e9 48 ff ff ff       	jmp    102cb9 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d71:	8b 45 14             	mov    0x14(%ebp),%eax
  102d74:	8d 50 04             	lea    0x4(%eax),%edx
  102d77:	89 55 14             	mov    %edx,0x14(%ebp)
  102d7a:	8b 00                	mov    (%eax),%eax
  102d7c:	83 ec 08             	sub    $0x8,%esp
  102d7f:	ff 75 0c             	push   0xc(%ebp)
  102d82:	50                   	push   %eax
  102d83:	8b 45 08             	mov    0x8(%ebp),%eax
  102d86:	ff d0                	call   *%eax
  102d88:	83 c4 10             	add    $0x10,%esp
            break;
  102d8b:	e9 71 02 00 00       	jmp    103001 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d90:	8b 45 14             	mov    0x14(%ebp),%eax
  102d93:	8d 50 04             	lea    0x4(%eax),%edx
  102d96:	89 55 14             	mov    %edx,0x14(%ebp)
  102d99:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d9b:	85 db                	test   %ebx,%ebx
  102d9d:	79 02                	jns    102da1 <vprintfmt+0x13b>
                err = -err;
  102d9f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102da1:	83 fb 06             	cmp    $0x6,%ebx
  102da4:	7f 0b                	jg     102db1 <vprintfmt+0x14b>
  102da6:	8b 34 9d 14 3d 10 00 	mov    0x103d14(,%ebx,4),%esi
  102dad:	85 f6                	test   %esi,%esi
  102daf:	75 19                	jne    102dca <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  102db1:	53                   	push   %ebx
  102db2:	68 41 3d 10 00       	push   $0x103d41
  102db7:	ff 75 0c             	push   0xc(%ebp)
  102dba:	ff 75 08             	push   0x8(%ebp)
  102dbd:	e8 80 fe ff ff       	call   102c42 <printfmt>
  102dc2:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102dc5:	e9 37 02 00 00       	jmp    103001 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  102dca:	56                   	push   %esi
  102dcb:	68 4a 3d 10 00       	push   $0x103d4a
  102dd0:	ff 75 0c             	push   0xc(%ebp)
  102dd3:	ff 75 08             	push   0x8(%ebp)
  102dd6:	e8 67 fe ff ff       	call   102c42 <printfmt>
  102ddb:	83 c4 10             	add    $0x10,%esp
            break;
  102dde:	e9 1e 02 00 00       	jmp    103001 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102de3:	8b 45 14             	mov    0x14(%ebp),%eax
  102de6:	8d 50 04             	lea    0x4(%eax),%edx
  102de9:	89 55 14             	mov    %edx,0x14(%ebp)
  102dec:	8b 30                	mov    (%eax),%esi
  102dee:	85 f6                	test   %esi,%esi
  102df0:	75 05                	jne    102df7 <vprintfmt+0x191>
                p = "(null)";
  102df2:	be 4d 3d 10 00       	mov    $0x103d4d,%esi
            }
            if (width > 0 && padc != '-') {
  102df7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dfb:	7e 76                	jle    102e73 <vprintfmt+0x20d>
  102dfd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e01:	74 70                	je     102e73 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e06:	83 ec 08             	sub    $0x8,%esp
  102e09:	50                   	push   %eax
  102e0a:	56                   	push   %esi
  102e0b:	e8 df 02 00 00       	call   1030ef <strnlen>
  102e10:	83 c4 10             	add    $0x10,%esp
  102e13:	89 c2                	mov    %eax,%edx
  102e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e18:	29 d0                	sub    %edx,%eax
  102e1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e1d:	eb 17                	jmp    102e36 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  102e1f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e23:	83 ec 08             	sub    $0x8,%esp
  102e26:	ff 75 0c             	push   0xc(%ebp)
  102e29:	50                   	push   %eax
  102e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2d:	ff d0                	call   *%eax
  102e2f:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e32:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e3a:	7f e3                	jg     102e1f <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e3c:	eb 35                	jmp    102e73 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e42:	74 1c                	je     102e60 <vprintfmt+0x1fa>
  102e44:	83 fb 1f             	cmp    $0x1f,%ebx
  102e47:	7e 05                	jle    102e4e <vprintfmt+0x1e8>
  102e49:	83 fb 7e             	cmp    $0x7e,%ebx
  102e4c:	7e 12                	jle    102e60 <vprintfmt+0x1fa>
                    putch('?', putdat);
  102e4e:	83 ec 08             	sub    $0x8,%esp
  102e51:	ff 75 0c             	push   0xc(%ebp)
  102e54:	6a 3f                	push   $0x3f
  102e56:	8b 45 08             	mov    0x8(%ebp),%eax
  102e59:	ff d0                	call   *%eax
  102e5b:	83 c4 10             	add    $0x10,%esp
  102e5e:	eb 0f                	jmp    102e6f <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  102e60:	83 ec 08             	sub    $0x8,%esp
  102e63:	ff 75 0c             	push   0xc(%ebp)
  102e66:	53                   	push   %ebx
  102e67:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6a:	ff d0                	call   *%eax
  102e6c:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e6f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e73:	89 f0                	mov    %esi,%eax
  102e75:	8d 70 01             	lea    0x1(%eax),%esi
  102e78:	0f b6 00             	movzbl (%eax),%eax
  102e7b:	0f be d8             	movsbl %al,%ebx
  102e7e:	85 db                	test   %ebx,%ebx
  102e80:	74 26                	je     102ea8 <vprintfmt+0x242>
  102e82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e86:	78 b6                	js     102e3e <vprintfmt+0x1d8>
  102e88:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e90:	79 ac                	jns    102e3e <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  102e92:	eb 14                	jmp    102ea8 <vprintfmt+0x242>
                putch(' ', putdat);
  102e94:	83 ec 08             	sub    $0x8,%esp
  102e97:	ff 75 0c             	push   0xc(%ebp)
  102e9a:	6a 20                	push   $0x20
  102e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9f:	ff d0                	call   *%eax
  102ea1:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  102ea4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ea8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eac:	7f e6                	jg     102e94 <vprintfmt+0x22e>
            }
            break;
  102eae:	e9 4e 01 00 00       	jmp    103001 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102eb3:	83 ec 08             	sub    $0x8,%esp
  102eb6:	ff 75 e0             	push   -0x20(%ebp)
  102eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  102ebc:	50                   	push   %eax
  102ebd:	e8 39 fd ff ff       	call   102bfb <getint>
  102ec2:	83 c4 10             	add    $0x10,%esp
  102ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ed1:	85 d2                	test   %edx,%edx
  102ed3:	79 23                	jns    102ef8 <vprintfmt+0x292>
                putch('-', putdat);
  102ed5:	83 ec 08             	sub    $0x8,%esp
  102ed8:	ff 75 0c             	push   0xc(%ebp)
  102edb:	6a 2d                	push   $0x2d
  102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee0:	ff d0                	call   *%eax
  102ee2:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  102ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eeb:	f7 d8                	neg    %eax
  102eed:	83 d2 00             	adc    $0x0,%edx
  102ef0:	f7 da                	neg    %edx
  102ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102ef8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102eff:	e9 9f 00 00 00       	jmp    102fa3 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f04:	83 ec 08             	sub    $0x8,%esp
  102f07:	ff 75 e0             	push   -0x20(%ebp)
  102f0a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f0d:	50                   	push   %eax
  102f0e:	e8 99 fc ff ff       	call   102bac <getuint>
  102f13:	83 c4 10             	add    $0x10,%esp
  102f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f23:	eb 7e                	jmp    102fa3 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f25:	83 ec 08             	sub    $0x8,%esp
  102f28:	ff 75 e0             	push   -0x20(%ebp)
  102f2b:	8d 45 14             	lea    0x14(%ebp),%eax
  102f2e:	50                   	push   %eax
  102f2f:	e8 78 fc ff ff       	call   102bac <getuint>
  102f34:	83 c4 10             	add    $0x10,%esp
  102f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f3d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f44:	eb 5d                	jmp    102fa3 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  102f46:	83 ec 08             	sub    $0x8,%esp
  102f49:	ff 75 0c             	push   0xc(%ebp)
  102f4c:	6a 30                	push   $0x30
  102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f51:	ff d0                	call   *%eax
  102f53:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  102f56:	83 ec 08             	sub    $0x8,%esp
  102f59:	ff 75 0c             	push   0xc(%ebp)
  102f5c:	6a 78                	push   $0x78
  102f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f61:	ff d0                	call   *%eax
  102f63:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f66:	8b 45 14             	mov    0x14(%ebp),%eax
  102f69:	8d 50 04             	lea    0x4(%eax),%edx
  102f6c:	89 55 14             	mov    %edx,0x14(%ebp)
  102f6f:	8b 00                	mov    (%eax),%eax
  102f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f82:	eb 1f                	jmp    102fa3 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f84:	83 ec 08             	sub    $0x8,%esp
  102f87:	ff 75 e0             	push   -0x20(%ebp)
  102f8a:	8d 45 14             	lea    0x14(%ebp),%eax
  102f8d:	50                   	push   %eax
  102f8e:	e8 19 fc ff ff       	call   102bac <getuint>
  102f93:	83 c4 10             	add    $0x10,%esp
  102f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f99:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102faa:	83 ec 04             	sub    $0x4,%esp
  102fad:	52                   	push   %edx
  102fae:	ff 75 e8             	push   -0x18(%ebp)
  102fb1:	50                   	push   %eax
  102fb2:	ff 75 f4             	push   -0xc(%ebp)
  102fb5:	ff 75 f0             	push   -0x10(%ebp)
  102fb8:	ff 75 0c             	push   0xc(%ebp)
  102fbb:	ff 75 08             	push   0x8(%ebp)
  102fbe:	e8 fd fa ff ff       	call   102ac0 <printnum>
  102fc3:	83 c4 20             	add    $0x20,%esp
            break;
  102fc6:	eb 39                	jmp    103001 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fc8:	83 ec 08             	sub    $0x8,%esp
  102fcb:	ff 75 0c             	push   0xc(%ebp)
  102fce:	53                   	push   %ebx
  102fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd2:	ff d0                	call   *%eax
  102fd4:	83 c4 10             	add    $0x10,%esp
            break;
  102fd7:	eb 28                	jmp    103001 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fd9:	83 ec 08             	sub    $0x8,%esp
  102fdc:	ff 75 0c             	push   0xc(%ebp)
  102fdf:	6a 25                	push   $0x25
  102fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe4:	ff d0                	call   *%eax
  102fe6:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  102fe9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fed:	eb 04                	jmp    102ff3 <vprintfmt+0x38d>
  102fef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff6:	83 e8 01             	sub    $0x1,%eax
  102ff9:	0f b6 00             	movzbl (%eax),%eax
  102ffc:	3c 25                	cmp    $0x25,%al
  102ffe:	75 ef                	jne    102fef <vprintfmt+0x389>
                /* do nothing */;
            break;
  103000:	90                   	nop
    while (1) {
  103001:	e9 68 fc ff ff       	jmp    102c6e <vprintfmt+0x8>
                return;
  103006:	90                   	nop
        }
    }
}
  103007:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10300a:	5b                   	pop    %ebx
  10300b:	5e                   	pop    %esi
  10300c:	5d                   	pop    %ebp
  10300d:	c3                   	ret    

0010300e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10300e:	55                   	push   %ebp
  10300f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103011:	8b 45 0c             	mov    0xc(%ebp),%eax
  103014:	8b 40 08             	mov    0x8(%eax),%eax
  103017:	8d 50 01             	lea    0x1(%eax),%edx
  10301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103020:	8b 45 0c             	mov    0xc(%ebp),%eax
  103023:	8b 10                	mov    (%eax),%edx
  103025:	8b 45 0c             	mov    0xc(%ebp),%eax
  103028:	8b 40 04             	mov    0x4(%eax),%eax
  10302b:	39 c2                	cmp    %eax,%edx
  10302d:	73 12                	jae    103041 <sprintputch+0x33>
        *b->buf ++ = ch;
  10302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103032:	8b 00                	mov    (%eax),%eax
  103034:	8d 48 01             	lea    0x1(%eax),%ecx
  103037:	8b 55 0c             	mov    0xc(%ebp),%edx
  10303a:	89 0a                	mov    %ecx,(%edx)
  10303c:	8b 55 08             	mov    0x8(%ebp),%edx
  10303f:	88 10                	mov    %dl,(%eax)
    }
}
  103041:	90                   	nop
  103042:	5d                   	pop    %ebp
  103043:	c3                   	ret    

00103044 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103044:	55                   	push   %ebp
  103045:	89 e5                	mov    %esp,%ebp
  103047:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10304a:	8d 45 14             	lea    0x14(%ebp),%eax
  10304d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103053:	50                   	push   %eax
  103054:	ff 75 10             	push   0x10(%ebp)
  103057:	ff 75 0c             	push   0xc(%ebp)
  10305a:	ff 75 08             	push   0x8(%ebp)
  10305d:	e8 0b 00 00 00       	call   10306d <vsnprintf>
  103062:	83 c4 10             	add    $0x10,%esp
  103065:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103068:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10306b:	c9                   	leave  
  10306c:	c3                   	ret    

0010306d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10306d:	55                   	push   %ebp
  10306e:	89 e5                	mov    %esp,%ebp
  103070:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
  103076:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103079:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10307f:	8b 45 08             	mov    0x8(%ebp),%eax
  103082:	01 d0                	add    %edx,%eax
  103084:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103087:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10308e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103092:	74 0a                	je     10309e <vsnprintf+0x31>
  103094:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10309a:	39 c2                	cmp    %eax,%edx
  10309c:	76 07                	jbe    1030a5 <vsnprintf+0x38>
        return -E_INVAL;
  10309e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030a3:	eb 20                	jmp    1030c5 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030a5:	ff 75 14             	push   0x14(%ebp)
  1030a8:	ff 75 10             	push   0x10(%ebp)
  1030ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030ae:	50                   	push   %eax
  1030af:	68 0e 30 10 00       	push   $0x10300e
  1030b4:	e8 ad fb ff ff       	call   102c66 <vprintfmt>
  1030b9:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030bf:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030c5:	c9                   	leave  
  1030c6:	c3                   	ret    

001030c7 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030c7:	55                   	push   %ebp
  1030c8:	89 e5                	mov    %esp,%ebp
  1030ca:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030d4:	eb 04                	jmp    1030da <strlen+0x13>
        cnt ++;
  1030d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030da:	8b 45 08             	mov    0x8(%ebp),%eax
  1030dd:	8d 50 01             	lea    0x1(%eax),%edx
  1030e0:	89 55 08             	mov    %edx,0x8(%ebp)
  1030e3:	0f b6 00             	movzbl (%eax),%eax
  1030e6:	84 c0                	test   %al,%al
  1030e8:	75 ec                	jne    1030d6 <strlen+0xf>
    }
    return cnt;
  1030ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030ed:	c9                   	leave  
  1030ee:	c3                   	ret    

001030ef <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1030ef:	55                   	push   %ebp
  1030f0:	89 e5                	mov    %esp,%ebp
  1030f2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1030fc:	eb 04                	jmp    103102 <strnlen+0x13>
        cnt ++;
  1030fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103105:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103108:	73 10                	jae    10311a <strnlen+0x2b>
  10310a:	8b 45 08             	mov    0x8(%ebp),%eax
  10310d:	8d 50 01             	lea    0x1(%eax),%edx
  103110:	89 55 08             	mov    %edx,0x8(%ebp)
  103113:	0f b6 00             	movzbl (%eax),%eax
  103116:	84 c0                	test   %al,%al
  103118:	75 e4                	jne    1030fe <strnlen+0xf>
    }
    return cnt;
  10311a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10311d:	c9                   	leave  
  10311e:	c3                   	ret    

0010311f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10311f:	55                   	push   %ebp
  103120:	89 e5                	mov    %esp,%ebp
  103122:	57                   	push   %edi
  103123:	56                   	push   %esi
  103124:	83 ec 20             	sub    $0x20,%esp
  103127:	8b 45 08             	mov    0x8(%ebp),%eax
  10312a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10312d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103130:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103133:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103139:	89 d1                	mov    %edx,%ecx
  10313b:	89 c2                	mov    %eax,%edx
  10313d:	89 ce                	mov    %ecx,%esi
  10313f:	89 d7                	mov    %edx,%edi
  103141:	ac                   	lods   %ds:(%esi),%al
  103142:	aa                   	stos   %al,%es:(%edi)
  103143:	84 c0                	test   %al,%al
  103145:	75 fa                	jne    103141 <strcpy+0x22>
  103147:	89 fa                	mov    %edi,%edx
  103149:	89 f1                	mov    %esi,%ecx
  10314b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10314e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103154:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103157:	83 c4 20             	add    $0x20,%esp
  10315a:	5e                   	pop    %esi
  10315b:	5f                   	pop    %edi
  10315c:	5d                   	pop    %ebp
  10315d:	c3                   	ret    

0010315e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10315e:	55                   	push   %ebp
  10315f:	89 e5                	mov    %esp,%ebp
  103161:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103164:	8b 45 08             	mov    0x8(%ebp),%eax
  103167:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10316a:	eb 21                	jmp    10318d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316f:	0f b6 10             	movzbl (%eax),%edx
  103172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103175:	88 10                	mov    %dl,(%eax)
  103177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10317a:	0f b6 00             	movzbl (%eax),%eax
  10317d:	84 c0                	test   %al,%al
  10317f:	74 04                	je     103185 <strncpy+0x27>
            src ++;
  103181:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103185:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103189:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  10318d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103191:	75 d9                	jne    10316c <strncpy+0xe>
    }
    return dst;
  103193:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103196:	c9                   	leave  
  103197:	c3                   	ret    

00103198 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103198:	55                   	push   %ebp
  103199:	89 e5                	mov    %esp,%ebp
  10319b:	57                   	push   %edi
  10319c:	56                   	push   %esi
  10319d:	83 ec 20             	sub    $0x20,%esp
  1031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1031ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031b2:	89 d1                	mov    %edx,%ecx
  1031b4:	89 c2                	mov    %eax,%edx
  1031b6:	89 ce                	mov    %ecx,%esi
  1031b8:	89 d7                	mov    %edx,%edi
  1031ba:	ac                   	lods   %ds:(%esi),%al
  1031bb:	ae                   	scas   %es:(%edi),%al
  1031bc:	75 08                	jne    1031c6 <strcmp+0x2e>
  1031be:	84 c0                	test   %al,%al
  1031c0:	75 f8                	jne    1031ba <strcmp+0x22>
  1031c2:	31 c0                	xor    %eax,%eax
  1031c4:	eb 04                	jmp    1031ca <strcmp+0x32>
  1031c6:	19 c0                	sbb    %eax,%eax
  1031c8:	0c 01                	or     $0x1,%al
  1031ca:	89 fa                	mov    %edi,%edx
  1031cc:	89 f1                	mov    %esi,%ecx
  1031ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1031d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031da:	83 c4 20             	add    $0x20,%esp
  1031dd:	5e                   	pop    %esi
  1031de:	5f                   	pop    %edi
  1031df:	5d                   	pop    %ebp
  1031e0:	c3                   	ret    

001031e1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031e1:	55                   	push   %ebp
  1031e2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031e4:	eb 0c                	jmp    1031f2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1031e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f6:	74 1a                	je     103212 <strncmp+0x31>
  1031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fb:	0f b6 00             	movzbl (%eax),%eax
  1031fe:	84 c0                	test   %al,%al
  103200:	74 10                	je     103212 <strncmp+0x31>
  103202:	8b 45 08             	mov    0x8(%ebp),%eax
  103205:	0f b6 10             	movzbl (%eax),%edx
  103208:	8b 45 0c             	mov    0xc(%ebp),%eax
  10320b:	0f b6 00             	movzbl (%eax),%eax
  10320e:	38 c2                	cmp    %al,%dl
  103210:	74 d4                	je     1031e6 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103212:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103216:	74 18                	je     103230 <strncmp+0x4f>
  103218:	8b 45 08             	mov    0x8(%ebp),%eax
  10321b:	0f b6 00             	movzbl (%eax),%eax
  10321e:	0f b6 d0             	movzbl %al,%edx
  103221:	8b 45 0c             	mov    0xc(%ebp),%eax
  103224:	0f b6 00             	movzbl (%eax),%eax
  103227:	0f b6 c8             	movzbl %al,%ecx
  10322a:	89 d0                	mov    %edx,%eax
  10322c:	29 c8                	sub    %ecx,%eax
  10322e:	eb 05                	jmp    103235 <strncmp+0x54>
  103230:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103235:	5d                   	pop    %ebp
  103236:	c3                   	ret    

00103237 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103237:	55                   	push   %ebp
  103238:	89 e5                	mov    %esp,%ebp
  10323a:	83 ec 04             	sub    $0x4,%esp
  10323d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103240:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103243:	eb 14                	jmp    103259 <strchr+0x22>
        if (*s == c) {
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	0f b6 00             	movzbl (%eax),%eax
  10324b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10324e:	75 05                	jne    103255 <strchr+0x1e>
            return (char *)s;
  103250:	8b 45 08             	mov    0x8(%ebp),%eax
  103253:	eb 13                	jmp    103268 <strchr+0x31>
        }
        s ++;
  103255:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  103259:	8b 45 08             	mov    0x8(%ebp),%eax
  10325c:	0f b6 00             	movzbl (%eax),%eax
  10325f:	84 c0                	test   %al,%al
  103261:	75 e2                	jne    103245 <strchr+0xe>
    }
    return NULL;
  103263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103268:	c9                   	leave  
  103269:	c3                   	ret    

0010326a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10326a:	55                   	push   %ebp
  10326b:	89 e5                	mov    %esp,%ebp
  10326d:	83 ec 04             	sub    $0x4,%esp
  103270:	8b 45 0c             	mov    0xc(%ebp),%eax
  103273:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103276:	eb 0f                	jmp    103287 <strfind+0x1d>
        if (*s == c) {
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	0f b6 00             	movzbl (%eax),%eax
  10327e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103281:	74 10                	je     103293 <strfind+0x29>
            break;
        }
        s ++;
  103283:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  103287:	8b 45 08             	mov    0x8(%ebp),%eax
  10328a:	0f b6 00             	movzbl (%eax),%eax
  10328d:	84 c0                	test   %al,%al
  10328f:	75 e7                	jne    103278 <strfind+0xe>
  103291:	eb 01                	jmp    103294 <strfind+0x2a>
            break;
  103293:	90                   	nop
    }
    return (char *)s;
  103294:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103297:	c9                   	leave  
  103298:	c3                   	ret    

00103299 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103299:	55                   	push   %ebp
  10329a:	89 e5                	mov    %esp,%ebp
  10329c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10329f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032ad:	eb 04                	jmp    1032b3 <strtol+0x1a>
        s ++;
  1032af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b6:	0f b6 00             	movzbl (%eax),%eax
  1032b9:	3c 20                	cmp    $0x20,%al
  1032bb:	74 f2                	je     1032af <strtol+0x16>
  1032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c0:	0f b6 00             	movzbl (%eax),%eax
  1032c3:	3c 09                	cmp    $0x9,%al
  1032c5:	74 e8                	je     1032af <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ca:	0f b6 00             	movzbl (%eax),%eax
  1032cd:	3c 2b                	cmp    $0x2b,%al
  1032cf:	75 06                	jne    1032d7 <strtol+0x3e>
        s ++;
  1032d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032d5:	eb 15                	jmp    1032ec <strtol+0x53>
    }
    else if (*s == '-') {
  1032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032da:	0f b6 00             	movzbl (%eax),%eax
  1032dd:	3c 2d                	cmp    $0x2d,%al
  1032df:	75 0b                	jne    1032ec <strtol+0x53>
        s ++, neg = 1;
  1032e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1032ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032f0:	74 06                	je     1032f8 <strtol+0x5f>
  1032f2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1032f6:	75 24                	jne    10331c <strtol+0x83>
  1032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fb:	0f b6 00             	movzbl (%eax),%eax
  1032fe:	3c 30                	cmp    $0x30,%al
  103300:	75 1a                	jne    10331c <strtol+0x83>
  103302:	8b 45 08             	mov    0x8(%ebp),%eax
  103305:	83 c0 01             	add    $0x1,%eax
  103308:	0f b6 00             	movzbl (%eax),%eax
  10330b:	3c 78                	cmp    $0x78,%al
  10330d:	75 0d                	jne    10331c <strtol+0x83>
        s += 2, base = 16;
  10330f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103313:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10331a:	eb 2a                	jmp    103346 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10331c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103320:	75 17                	jne    103339 <strtol+0xa0>
  103322:	8b 45 08             	mov    0x8(%ebp),%eax
  103325:	0f b6 00             	movzbl (%eax),%eax
  103328:	3c 30                	cmp    $0x30,%al
  10332a:	75 0d                	jne    103339 <strtol+0xa0>
        s ++, base = 8;
  10332c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103330:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103337:	eb 0d                	jmp    103346 <strtol+0xad>
    }
    else if (base == 0) {
  103339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10333d:	75 07                	jne    103346 <strtol+0xad>
        base = 10;
  10333f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103346:	8b 45 08             	mov    0x8(%ebp),%eax
  103349:	0f b6 00             	movzbl (%eax),%eax
  10334c:	3c 2f                	cmp    $0x2f,%al
  10334e:	7e 1b                	jle    10336b <strtol+0xd2>
  103350:	8b 45 08             	mov    0x8(%ebp),%eax
  103353:	0f b6 00             	movzbl (%eax),%eax
  103356:	3c 39                	cmp    $0x39,%al
  103358:	7f 11                	jg     10336b <strtol+0xd2>
            dig = *s - '0';
  10335a:	8b 45 08             	mov    0x8(%ebp),%eax
  10335d:	0f b6 00             	movzbl (%eax),%eax
  103360:	0f be c0             	movsbl %al,%eax
  103363:	83 e8 30             	sub    $0x30,%eax
  103366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103369:	eb 48                	jmp    1033b3 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10336b:	8b 45 08             	mov    0x8(%ebp),%eax
  10336e:	0f b6 00             	movzbl (%eax),%eax
  103371:	3c 60                	cmp    $0x60,%al
  103373:	7e 1b                	jle    103390 <strtol+0xf7>
  103375:	8b 45 08             	mov    0x8(%ebp),%eax
  103378:	0f b6 00             	movzbl (%eax),%eax
  10337b:	3c 7a                	cmp    $0x7a,%al
  10337d:	7f 11                	jg     103390 <strtol+0xf7>
            dig = *s - 'a' + 10;
  10337f:	8b 45 08             	mov    0x8(%ebp),%eax
  103382:	0f b6 00             	movzbl (%eax),%eax
  103385:	0f be c0             	movsbl %al,%eax
  103388:	83 e8 57             	sub    $0x57,%eax
  10338b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10338e:	eb 23                	jmp    1033b3 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103390:	8b 45 08             	mov    0x8(%ebp),%eax
  103393:	0f b6 00             	movzbl (%eax),%eax
  103396:	3c 40                	cmp    $0x40,%al
  103398:	7e 3c                	jle    1033d6 <strtol+0x13d>
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	0f b6 00             	movzbl (%eax),%eax
  1033a0:	3c 5a                	cmp    $0x5a,%al
  1033a2:	7f 32                	jg     1033d6 <strtol+0x13d>
            dig = *s - 'A' + 10;
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	0f b6 00             	movzbl (%eax),%eax
  1033aa:	0f be c0             	movsbl %al,%eax
  1033ad:	83 e8 37             	sub    $0x37,%eax
  1033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033b9:	7d 1a                	jge    1033d5 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  1033bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033c6:	89 c2                	mov    %eax,%edx
  1033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033cb:	01 d0                	add    %edx,%eax
  1033cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1033d0:	e9 71 ff ff ff       	jmp    103346 <strtol+0xad>
            break;
  1033d5:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1033d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033da:	74 08                	je     1033e4 <strtol+0x14b>
        *endptr = (char *) s;
  1033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033df:	8b 55 08             	mov    0x8(%ebp),%edx
  1033e2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033e8:	74 07                	je     1033f1 <strtol+0x158>
  1033ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033ed:	f7 d8                	neg    %eax
  1033ef:	eb 03                	jmp    1033f4 <strtol+0x15b>
  1033f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1033f4:	c9                   	leave  
  1033f5:	c3                   	ret    

001033f6 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1033f6:	55                   	push   %ebp
  1033f7:	89 e5                	mov    %esp,%ebp
  1033f9:	57                   	push   %edi
  1033fa:	83 ec 24             	sub    $0x24,%esp
  1033fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103400:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103403:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103407:	8b 55 08             	mov    0x8(%ebp),%edx
  10340a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10340d:	88 45 f7             	mov    %al,-0x9(%ebp)
  103410:	8b 45 10             	mov    0x10(%ebp),%eax
  103413:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103416:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103419:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10341d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103420:	89 d7                	mov    %edx,%edi
  103422:	f3 aa                	rep stos %al,%es:(%edi)
  103424:	89 fa                	mov    %edi,%edx
  103426:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103429:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10342c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10342f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103432:	c9                   	leave  
  103433:	c3                   	ret    

00103434 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103434:	55                   	push   %ebp
  103435:	89 e5                	mov    %esp,%ebp
  103437:	57                   	push   %edi
  103438:	56                   	push   %esi
  103439:	53                   	push   %ebx
  10343a:	83 ec 30             	sub    $0x30,%esp
  10343d:	8b 45 08             	mov    0x8(%ebp),%eax
  103440:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103443:	8b 45 0c             	mov    0xc(%ebp),%eax
  103446:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103449:	8b 45 10             	mov    0x10(%ebp),%eax
  10344c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103452:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103455:	73 42                	jae    103499 <memmove+0x65>
  103457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10345a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10345d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103466:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103469:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10346c:	c1 e8 02             	shr    $0x2,%eax
  10346f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103471:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103477:	89 d7                	mov    %edx,%edi
  103479:	89 c6                	mov    %eax,%esi
  10347b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10347d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103480:	83 e1 03             	and    $0x3,%ecx
  103483:	74 02                	je     103487 <memmove+0x53>
  103485:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103487:	89 f0                	mov    %esi,%eax
  103489:	89 fa                	mov    %edi,%edx
  10348b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10348e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103491:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103497:	eb 36                	jmp    1034cf <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10349c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10349f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034a2:	01 c2                	add    %eax,%edx
  1034a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034a7:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ad:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b3:	89 c1                	mov    %eax,%ecx
  1034b5:	89 d8                	mov    %ebx,%eax
  1034b7:	89 d6                	mov    %edx,%esi
  1034b9:	89 c7                	mov    %eax,%edi
  1034bb:	fd                   	std    
  1034bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034be:	fc                   	cld    
  1034bf:	89 f8                	mov    %edi,%eax
  1034c1:	89 f2                	mov    %esi,%edx
  1034c3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034c6:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1034cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034cf:	83 c4 30             	add    $0x30,%esp
  1034d2:	5b                   	pop    %ebx
  1034d3:	5e                   	pop    %esi
  1034d4:	5f                   	pop    %edi
  1034d5:	5d                   	pop    %ebp
  1034d6:	c3                   	ret    

001034d7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034d7:	55                   	push   %ebp
  1034d8:	89 e5                	mov    %esp,%ebp
  1034da:	57                   	push   %edi
  1034db:	56                   	push   %esi
  1034dc:	83 ec 20             	sub    $0x20,%esp
  1034df:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034f4:	c1 e8 02             	shr    $0x2,%eax
  1034f7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ff:	89 d7                	mov    %edx,%edi
  103501:	89 c6                	mov    %eax,%esi
  103503:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103505:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103508:	83 e1 03             	and    $0x3,%ecx
  10350b:	74 02                	je     10350f <memcpy+0x38>
  10350d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10350f:	89 f0                	mov    %esi,%eax
  103511:	89 fa                	mov    %edi,%edx
  103513:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103516:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103519:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10351c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10351f:	83 c4 20             	add    $0x20,%esp
  103522:	5e                   	pop    %esi
  103523:	5f                   	pop    %edi
  103524:	5d                   	pop    %ebp
  103525:	c3                   	ret    

00103526 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103526:	55                   	push   %ebp
  103527:	89 e5                	mov    %esp,%ebp
  103529:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10352c:	8b 45 08             	mov    0x8(%ebp),%eax
  10352f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103532:	8b 45 0c             	mov    0xc(%ebp),%eax
  103535:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103538:	eb 30                	jmp    10356a <memcmp+0x44>
        if (*s1 != *s2) {
  10353a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10353d:	0f b6 10             	movzbl (%eax),%edx
  103540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103543:	0f b6 00             	movzbl (%eax),%eax
  103546:	38 c2                	cmp    %al,%dl
  103548:	74 18                	je     103562 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10354a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10354d:	0f b6 00             	movzbl (%eax),%eax
  103550:	0f b6 d0             	movzbl %al,%edx
  103553:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103556:	0f b6 00             	movzbl (%eax),%eax
  103559:	0f b6 c8             	movzbl %al,%ecx
  10355c:	89 d0                	mov    %edx,%eax
  10355e:	29 c8                	sub    %ecx,%eax
  103560:	eb 1a                	jmp    10357c <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103562:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103566:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  10356a:	8b 45 10             	mov    0x10(%ebp),%eax
  10356d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103570:	89 55 10             	mov    %edx,0x10(%ebp)
  103573:	85 c0                	test   %eax,%eax
  103575:	75 c3                	jne    10353a <memcmp+0x14>
    }
    return 0;
  103577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10357c:	c9                   	leave  
  10357d:	c3                   	ret    
