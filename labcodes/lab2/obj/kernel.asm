
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 c0 11 00       	mov    $0x11c000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 c0 11 c0       	mov    %eax,0xc011c000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 b0 11 c0       	mov    $0xc011b000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void)
{
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c0100041:	2d 00 e0 11 c0       	sub    $0xc011e000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 e0 11 c0 	movl   $0xc011e000,(%esp)
c0100059:	e8 f8 6a 00 00       	call   c0106b56 <memset>

    cons_init(); // init the console
c010005e:	e8 f9 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 00 6d 10 c0 	movl   $0xc0106d00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 1c 6d 10 c0 	movl   $0xc0106d1c,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 95 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init(); // init physical memory management
c0100087:	e8 41 50 00 00       	call   c01050cd <pmm_init>

    pic_init(); // init interrupt controller
c010008c:	e8 4c 17 00 00       	call   c01017dd <pic_init>
    idt_init(); // init interrupt descriptor table
c0100091:	e8 d3 18 00 00       	call   c0101969 <idt_init>

    clock_init();  // init clock interrupt
c0100096:	e8 20 0d 00 00       	call   c0100dbb <clock_init>
    intr_enable(); // enable irq interrupt
c010009b:	e8 9b 16 00 00       	call   c010173b <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    lab1_switch_test();
c01000a0:	e8 75 01 00 00       	call   c010021a <lab1_switch_test>

    /* do nothing */
    while (1)
c01000a5:	eb fe                	jmp    c01000a5 <kern_init+0x6f>

c01000a7 <grade_backtrace2>:
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
c01000a7:	55                   	push   %ebp
c01000a8:	89 e5                	mov    %esp,%ebp
c01000aa:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b4:	00 
c01000b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bc:	00 
c01000bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c4:	e8 0d 0c 00 00       	call   c0100cd6 <mon_backtrace>
}
c01000c9:	90                   	nop
c01000ca:	89 ec                	mov    %ebp,%esp
c01000cc:	5d                   	pop    %ebp
c01000cd:	c3                   	ret    

c01000ce <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
c01000ce:	55                   	push   %ebp
c01000cf:	89 e5                	mov    %esp,%ebp
c01000d1:	83 ec 18             	sub    $0x18,%esp
c01000d4:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000dd:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ef:	89 04 24             	mov    %eax,(%esp)
c01000f2:	e8 b0 ff ff ff       	call   c01000a7 <grade_backtrace2>
}
c01000f7:	90                   	nop
c01000f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000fb:	89 ec                	mov    %ebp,%esp
c01000fd:	5d                   	pop    %ebp
c01000fe:	c3                   	ret    

c01000ff <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
c01000ff:	55                   	push   %ebp
c0100100:	89 e5                	mov    %esp,%ebp
c0100102:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100105:	8b 45 10             	mov    0x10(%ebp),%eax
c0100108:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010c:	8b 45 08             	mov    0x8(%ebp),%eax
c010010f:	89 04 24             	mov    %eax,(%esp)
c0100112:	e8 b7 ff ff ff       	call   c01000ce <grade_backtrace1>
}
c0100117:	90                   	nop
c0100118:	89 ec                	mov    %ebp,%esp
c010011a:	5d                   	pop    %ebp
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void grade_backtrace(void)
{
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c0 ff ff ff       	call   c01000ff <grade_backtrace0>
}
c010013f:	90                   	nop
c0100140:	89 ec                	mov    %ebp,%esp
c0100142:	5d                   	pop    %ebp
c0100143:	c3                   	ret    

c0100144 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
c0100144:	55                   	push   %ebp
c0100145:	89 e5                	mov    %esp,%ebp
c0100147:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
c010014a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100150:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100153:	8c 55 f0             	mov    %ss,-0x10(%ebp)
        "mov %%cs, %0;"
        "mov %%ds, %1;"
        "mov %%es, %2;"
        "mov %%ss, %3;"
        : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100156:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 21 6d 10 c0 	movl   $0xc0106d21,(%esp)
c0100173:	e8 ed 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	89 c2                	mov    %eax,%edx
c010017e:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c0100183:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100187:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018b:	c7 04 24 2f 6d 10 c0 	movl   $0xc0106d2f,(%esp)
c0100192:	e8 ce 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019b:	89 c2                	mov    %eax,%edx
c010019d:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001aa:	c7 04 24 3d 6d 10 c0 	movl   $0xc0106d3d,(%esp)
c01001b1:	e8 af 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ba:	89 c2                	mov    %eax,%edx
c01001bc:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c9:	c7 04 24 4b 6d 10 c0 	movl   $0xc0106d4b,(%esp)
c01001d0:	e8 90 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d9:	89 c2                	mov    %eax,%edx
c01001db:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e8:	c7 04 24 59 6d 10 c0 	movl   $0xc0106d59,(%esp)
c01001ef:	e8 71 01 00 00       	call   c0100365 <cprintf>
    round++;
c01001f4:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001f9:	40                   	inc    %eax
c01001fa:	a3 00 e0 11 c0       	mov    %eax,0xc011e000
}
c01001ff:	90                   	nop
c0100200:	89 ec                	mov    %ebp,%esp
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 : TODO
    asm volatile(
c0100207:	16                   	push   %ss
c0100208:	54                   	push   %esp
c0100209:	cd 78                	int    $0x78
c010020b:	89 ec                	mov    %ebp,%esp
        "pushl %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU));
}
c010020d:	90                   	nop
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 :  TODO
    asm volatile(
c0100213:	cd 79                	int    $0x79
c0100215:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK));
}
c0100217:	90                   	nop
c0100218:	5d                   	pop    %ebp
c0100219:	c3                   	ret    

c010021a <lab1_switch_test>:

static void
lab1_switch_test(void)
{
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100220:	e8 1f ff ff ff       	call   c0100144 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100225:	c7 04 24 68 6d 10 c0 	movl   $0xc0106d68,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 ce ff ff ff       	call   c0100204 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 09 ff ff ff       	call   c0100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 88 6d 10 c0 	movl   $0xc0106d88,(%esp)
c0100242:	e8 1e 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_kernel();
c0100247:	e8 c4 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024c:	e8 f3 fe ff ff       	call   c0100144 <lab1_print_cur_status>
}
c0100251:	90                   	nop
c0100252:	89 ec                	mov    %ebp,%esp
c0100254:	5d                   	pop    %ebp
c0100255:	c3                   	ret    

c0100256 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100256:	55                   	push   %ebp
c0100257:	89 e5                	mov    %esp,%ebp
c0100259:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010025c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100260:	74 13                	je     c0100275 <readline+0x1f>
        cprintf("%s", prompt);
c0100262:	8b 45 08             	mov    0x8(%ebp),%eax
c0100265:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100269:	c7 04 24 a7 6d 10 c0 	movl   $0xc0106da7,(%esp)
c0100270:	e8 f0 00 00 00       	call   c0100365 <cprintf>
    }
    int i = 0, c;
c0100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010027c:	e8 73 01 00 00       	call   c01003f4 <getchar>
c0100281:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100288:	79 07                	jns    c0100291 <readline+0x3b>
            return NULL;
c010028a:	b8 00 00 00 00       	mov    $0x0,%eax
c010028f:	eb 78                	jmp    c0100309 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100291:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100295:	7e 28                	jle    c01002bf <readline+0x69>
c0100297:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010029e:	7f 1f                	jg     c01002bf <readline+0x69>
            cputchar(c);
c01002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a3:	89 04 24             	mov    %eax,(%esp)
c01002a6:	e8 e2 00 00 00       	call   c010038d <cputchar>
            buf[i ++] = c;
c01002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ae:	8d 50 01             	lea    0x1(%eax),%edx
c01002b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002b7:	88 90 20 e0 11 c0    	mov    %dl,-0x3fee1fe0(%eax)
c01002bd:	eb 45                	jmp    c0100304 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002bf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002c3:	75 16                	jne    c01002db <readline+0x85>
c01002c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c9:	7e 10                	jle    c01002db <readline+0x85>
            cputchar(c);
c01002cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ce:	89 04 24             	mov    %eax,(%esp)
c01002d1:	e8 b7 00 00 00       	call   c010038d <cputchar>
            i --;
c01002d6:	ff 4d f4             	decl   -0xc(%ebp)
c01002d9:	eb 29                	jmp    c0100304 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002db:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002df:	74 06                	je     c01002e7 <readline+0x91>
c01002e1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002e5:	75 95                	jne    c010027c <readline+0x26>
            cputchar(c);
c01002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ea:	89 04 24             	mov    %eax,(%esp)
c01002ed:	e8 9b 00 00 00       	call   c010038d <cputchar>
            buf[i] = '\0';
c01002f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002f5:	05 20 e0 11 c0       	add    $0xc011e020,%eax
c01002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fd:	b8 20 e0 11 c0       	mov    $0xc011e020,%eax
c0100302:	eb 05                	jmp    c0100309 <readline+0xb3>
        c = getchar();
c0100304:	e9 73 ff ff ff       	jmp    c010027c <readline+0x26>
        }
    }
}
c0100309:	89 ec                	mov    %ebp,%esp
c010030b:	5d                   	pop    %ebp
c010030c:	c3                   	ret    

c010030d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010030d:	55                   	push   %ebp
c010030e:	89 e5                	mov    %esp,%ebp
c0100310:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100313:	8b 45 08             	mov    0x8(%ebp),%eax
c0100316:	89 04 24             	mov    %eax,(%esp)
c0100319:	e8 6d 13 00 00       	call   c010168b <cons_putc>
    (*cnt) ++;
c010031e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100321:	8b 00                	mov    (%eax),%eax
c0100323:	8d 50 01             	lea    0x1(%eax),%edx
c0100326:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100329:	89 10                	mov    %edx,(%eax)
}
c010032b:	90                   	nop
c010032c:	89 ec                	mov    %ebp,%esp
c010032e:	5d                   	pop    %ebp
c010032f:	c3                   	ret    

c0100330 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100330:	55                   	push   %ebp
c0100331:	89 e5                	mov    %esp,%ebp
c0100333:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010033d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100340:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100344:	8b 45 08             	mov    0x8(%ebp),%eax
c0100347:	89 44 24 08          	mov    %eax,0x8(%esp)
c010034b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010034e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100352:	c7 04 24 0d 03 10 c0 	movl   $0xc010030d,(%esp)
c0100359:	e8 23 60 00 00       	call   c0106381 <vprintfmt>
    return cnt;
c010035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100361:	89 ec                	mov    %ebp,%esp
c0100363:	5d                   	pop    %ebp
c0100364:	c3                   	ret    

c0100365 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100365:	55                   	push   %ebp
c0100366:	89 e5                	mov    %esp,%ebp
c0100368:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010036b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010036e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100374:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100378:	8b 45 08             	mov    0x8(%ebp),%eax
c010037b:	89 04 24             	mov    %eax,(%esp)
c010037e:	e8 ad ff ff ff       	call   c0100330 <vcprintf>
c0100383:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100389:	89 ec                	mov    %ebp,%esp
c010038b:	5d                   	pop    %ebp
c010038c:	c3                   	ret    

c010038d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010038d:	55                   	push   %ebp
c010038e:	89 e5                	mov    %esp,%ebp
c0100390:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100393:	8b 45 08             	mov    0x8(%ebp),%eax
c0100396:	89 04 24             	mov    %eax,(%esp)
c0100399:	e8 ed 12 00 00       	call   c010168b <cons_putc>
}
c010039e:	90                   	nop
c010039f:	89 ec                	mov    %ebp,%esp
c01003a1:	5d                   	pop    %ebp
c01003a2:	c3                   	ret    

c01003a3 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01003a3:	55                   	push   %ebp
c01003a4:	89 e5                	mov    %esp,%ebp
c01003a6:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01003a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003b0:	eb 13                	jmp    c01003c5 <cputs+0x22>
        cputch(c, &cnt);
c01003b2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003b6:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003bd:	89 04 24             	mov    %eax,(%esp)
c01003c0:	e8 48 ff ff ff       	call   c010030d <cputch>
    while ((c = *str ++) != '\0') {
c01003c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01003c8:	8d 50 01             	lea    0x1(%eax),%edx
c01003cb:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ce:	0f b6 00             	movzbl (%eax),%eax
c01003d1:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003d4:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003d8:	75 d8                	jne    c01003b2 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003da:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003e1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003e8:	e8 20 ff ff ff       	call   c010030d <cputch>
    return cnt;
c01003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003f0:	89 ec                	mov    %ebp,%esp
c01003f2:	5d                   	pop    %ebp
c01003f3:	c3                   	ret    

c01003f4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003fa:	90                   	nop
c01003fb:	e8 ca 12 00 00       	call   c01016ca <cons_getc>
c0100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100407:	74 f2                	je     c01003fb <getchar+0x7>
        /* do nothing */;
    return c;
c0100409:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010040c:	89 ec                	mov    %ebp,%esp
c010040e:	5d                   	pop    %ebp
c010040f:	c3                   	ret    

c0100410 <stab_binsearch>:
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
               int type, uintptr_t addr)
{
c0100410:	55                   	push   %ebp
c0100411:	89 e5                	mov    %esp,%ebp
c0100413:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100416:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100419:	8b 00                	mov    (%eax),%eax
c010041b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010041e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100421:	8b 00                	mov    (%eax),%eax
c0100423:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r)
c010042d:	e9 ca 00 00 00       	jmp    c01004fc <stab_binsearch+0xec>
    {
        int true_m = (l + r) / 2, m = true_m;
c0100432:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100435:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	89 c2                	mov    %eax,%edx
c010043c:	c1 ea 1f             	shr    $0x1f,%edx
c010043f:	01 d0                	add    %edx,%eax
c0100441:	d1 f8                	sar    %eax
c0100443:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100446:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100449:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
c010044c:	eb 03                	jmp    c0100451 <stab_binsearch+0x41>
        {
            m--;
c010044e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type)
c0100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100457:	7c 1f                	jl     c0100478 <stab_binsearch+0x68>
c0100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010045c:	89 d0                	mov    %edx,%eax
c010045e:	01 c0                	add    %eax,%eax
c0100460:	01 d0                	add    %edx,%eax
c0100462:	c1 e0 02             	shl    $0x2,%eax
c0100465:	89 c2                	mov    %eax,%edx
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	01 d0                	add    %edx,%eax
c010046c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100470:	0f b6 c0             	movzbl %al,%eax
c0100473:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100476:	75 d6                	jne    c010044e <stab_binsearch+0x3e>
        }
        if (m < l)
c0100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010047b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010047e:	7d 09                	jge    c0100489 <stab_binsearch+0x79>
        { // no match in [l, m]
            l = true_m + 1;
c0100480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100483:	40                   	inc    %eax
c0100484:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100487:	eb 73                	jmp    c01004fc <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100489:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr)
c0100490:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100493:	89 d0                	mov    %edx,%eax
c0100495:	01 c0                	add    %eax,%eax
c0100497:	01 d0                	add    %edx,%eax
c0100499:	c1 e0 02             	shl    $0x2,%eax
c010049c:	89 c2                	mov    %eax,%edx
c010049e:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	8b 40 08             	mov    0x8(%eax),%eax
c01004a6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a9:	76 11                	jbe    c01004bc <stab_binsearch+0xac>
        {
            *region_left = m;
c01004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004b6:	40                   	inc    %eax
c01004b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ba:	eb 40                	jmp    c01004fc <stab_binsearch+0xec>
        }
        else if (stabs[m].n_value > addr)
c01004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004bf:	89 d0                	mov    %edx,%eax
c01004c1:	01 c0                	add    %eax,%eax
c01004c3:	01 d0                	add    %edx,%eax
c01004c5:	c1 e0 02             	shl    $0x2,%eax
c01004c8:	89 c2                	mov    %eax,%edx
c01004ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cd:	01 d0                	add    %edx,%eax
c01004cf:	8b 40 08             	mov    0x8(%eax),%eax
c01004d2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004d5:	73 14                	jae    c01004eb <stab_binsearch+0xdb>
        {
            *region_right = m - 1;
c01004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e5:	48                   	dec    %eax
c01004e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e9:	eb 11                	jmp    c01004fc <stab_binsearch+0xec>
        }
        else
        {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr++;
c01004f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r)
c01004fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100502:	0f 8e 2a ff ff ff    	jle    c0100432 <stab_binsearch+0x22>
        }
    }

    if (!any_matches)
c0100508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010050c:	75 0f                	jne    c010051d <stab_binsearch+0x10d>
    {
        *region_right = *region_left - 1;
c010050e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100516:	8b 45 10             	mov    0x10(%ebp),%eax
c0100519:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l--)
            /* do nothing */;
        *region_left = l;
    }
}
c010051b:	eb 3e                	jmp    c010055b <stab_binsearch+0x14b>
        l = *region_right;
c010051d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100520:	8b 00                	mov    (%eax),%eax
c0100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l--)
c0100525:	eb 03                	jmp    c010052a <stab_binsearch+0x11a>
c0100527:	ff 4d fc             	decl   -0x4(%ebp)
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 00                	mov    (%eax),%eax
c010052f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100532:	7e 1f                	jle    c0100553 <stab_binsearch+0x143>
c0100534:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100537:	89 d0                	mov    %edx,%eax
c0100539:	01 c0                	add    %eax,%eax
c010053b:	01 d0                	add    %edx,%eax
c010053d:	c1 e0 02             	shl    $0x2,%eax
c0100540:	89 c2                	mov    %eax,%edx
c0100542:	8b 45 08             	mov    0x8(%ebp),%eax
c0100545:	01 d0                	add    %edx,%eax
c0100547:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010054b:	0f b6 c0             	movzbl %al,%eax
c010054e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100551:	75 d4                	jne    c0100527 <stab_binsearch+0x117>
        *region_left = l;
c0100553:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100556:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100559:	89 10                	mov    %edx,(%eax)
}
c010055b:	90                   	nop
c010055c:	89 ec                	mov    %ebp,%esp
c010055e:	5d                   	pop    %ebp
c010055f:	c3                   	ret    

c0100560 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info)
{
c0100560:	55                   	push   %ebp
c0100561:	89 e5                	mov    %esp,%ebp
c0100563:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100566:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100569:	c7 00 ac 6d 10 c0    	movl   $0xc0106dac,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 ac 6d 10 c0 	movl   $0xc0106dac,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100583:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100586:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010058d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100590:	8b 55 08             	mov    0x8(%ebp),%edx
c0100593:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100599:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01005a0:	c7 45 f4 78 82 10 c0 	movl   $0xc0108278,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 74 4c 11 c0 	movl   $0xc0114c74,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec 75 4c 11 c0 	movl   $0xc0114c75,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 32 85 11 c0 	movl   $0xc0118532,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
c01005bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005c2:	76 0b                	jbe    c01005cf <debuginfo_eip+0x6f>
c01005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c7:	48                   	dec    %eax
c01005c8:	0f b6 00             	movzbl (%eax),%eax
c01005cb:	84 c0                	test   %al,%al
c01005cd:	74 0a                	je     c01005d9 <debuginfo_eip+0x79>
    {
        return -1;
c01005cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005d4:	e9 ab 02 00 00       	jmp    c0100884 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e3:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005e6:	c1 f8 02             	sar    $0x2,%eax
c01005e9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005ef:	48                   	dec    %eax
c01005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005fa:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100601:	00 
c0100602:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100605:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010060c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100613:	89 04 24             	mov    %eax,(%esp)
c0100616:	e8 f5 fd ff ff       	call   c0100410 <stab_binsearch>
    if (lfile == 0)
c010061b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061e:	85 c0                	test   %eax,%eax
c0100620:	75 0a                	jne    c010062c <debuginfo_eip+0xcc>
        return -1;
c0100622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100627:	e9 58 02 00 00       	jmp    c0100884 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010062c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100632:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100635:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100638:	8b 45 08             	mov    0x8(%ebp),%eax
c010063b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010063f:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100646:	00 
c0100647:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010064a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010064e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100651:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	89 04 24             	mov    %eax,(%esp)
c010065b:	e8 b0 fd ff ff       	call   c0100410 <stab_binsearch>

    if (lfun <= rfun)
c0100660:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100663:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	7f 78                	jg     c01006e2 <debuginfo_eip+0x182>
    {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
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
c0100681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100684:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100687:	39 c2                	cmp    %eax,%edx
c0100689:	73 22                	jae    c01006ad <debuginfo_eip+0x14d>
        {
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010068b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068e:	89 c2                	mov    %eax,%edx
c0100690:	89 d0                	mov    %edx,%eax
c0100692:	01 c0                	add    %eax,%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	c1 e0 02             	shl    $0x2,%eax
c0100699:	89 c2                	mov    %eax,%edx
c010069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069e:	01 d0                	add    %edx,%eax
c01006a0:	8b 10                	mov    (%eax),%edx
c01006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006a5:	01 c2                	add    %eax,%edx
c01006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006aa:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b0:	89 c2                	mov    %eax,%edx
c01006b2:	89 d0                	mov    %edx,%eax
c01006b4:	01 c0                	add    %eax,%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	c1 e0 02             	shl    $0x2,%eax
c01006bb:	89 c2                	mov    %eax,%edx
c01006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006c0:	01 d0                	add    %edx,%eax
c01006c2:	8b 50 08             	mov    0x8(%eax),%edx
c01006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c8:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ce:	8b 40 10             	mov    0x10(%eax),%eax
c01006d1:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006da:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006e0:	eb 15                	jmp    c01006f7 <debuginfo_eip+0x197>
    }
    else
    {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fa:	8b 40 08             	mov    0x8(%eax),%eax
c01006fd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100704:	00 
c0100705:	89 04 24             	mov    %eax,(%esp)
c0100708:	e8 c1 62 00 00       	call   c01069ce <strfind>
c010070d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100710:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100713:	29 c8                	sub    %ecx,%eax
c0100715:	89 c2                	mov    %eax,%edx
c0100717:	8b 45 0c             	mov    0xc(%ebp),%eax
c010071a:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010071d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100720:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100724:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010072b:	00 
c010072c:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010072f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100733:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100736:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073d:	89 04 24             	mov    %eax,(%esp)
c0100740:	e8 cb fc ff ff       	call   c0100410 <stab_binsearch>
    if (lline <= rline)
c0100745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100748:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074b:	39 c2                	cmp    %eax,%edx
c010074d:	7f 23                	jg     c0100772 <debuginfo_eip+0x212>
    {
        info->eip_line = stabs[rline].n_desc;
c010074f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100752:	89 c2                	mov    %eax,%edx
c0100754:	89 d0                	mov    %edx,%eax
c0100756:	01 c0                	add    %eax,%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	c1 e0 02             	shl    $0x2,%eax
c010075d:	89 c2                	mov    %eax,%edx
c010075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100762:	01 d0                	add    %edx,%eax
c0100764:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100768:	89 c2                	mov    %eax,%edx
c010076a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
c0100770:	eb 11                	jmp    c0100783 <debuginfo_eip+0x223>
        return -1;
c0100772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100777:	e9 08 01 00 00       	jmp    c0100884 <debuginfo_eip+0x324>
    {
        lline--;
c010077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077f:	48                   	dec    %eax
c0100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
c0100783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	7c 56                	jl     c01007e3 <debuginfo_eip+0x283>
c010078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	89 d0                	mov    %edx,%eax
c0100794:	01 c0                	add    %eax,%eax
c0100796:	01 d0                	add    %edx,%eax
c0100798:	c1 e0 02             	shl    $0x2,%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a6:	3c 84                	cmp    $0x84,%al
c01007a8:	74 39                	je     c01007e3 <debuginfo_eip+0x283>
c01007aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ad:	89 c2                	mov    %eax,%edx
c01007af:	89 d0                	mov    %edx,%eax
c01007b1:	01 c0                	add    %eax,%eax
c01007b3:	01 d0                	add    %edx,%eax
c01007b5:	c1 e0 02             	shl    $0x2,%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007c3:	3c 64                	cmp    $0x64,%al
c01007c5:	75 b5                	jne    c010077c <debuginfo_eip+0x21c>
c01007c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ca:	89 c2                	mov    %eax,%edx
c01007cc:	89 d0                	mov    %edx,%eax
c01007ce:	01 c0                	add    %eax,%eax
c01007d0:	01 d0                	add    %edx,%eax
c01007d2:	c1 e0 02             	shl    $0x2,%eax
c01007d5:	89 c2                	mov    %eax,%edx
c01007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007da:	01 d0                	add    %edx,%eax
c01007dc:	8b 40 08             	mov    0x8(%eax),%eax
c01007df:	85 c0                	test   %eax,%eax
c01007e1:	74 99                	je     c010077c <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
c01007e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e9:	39 c2                	cmp    %eax,%edx
c01007eb:	7c 42                	jl     c010082f <debuginfo_eip+0x2cf>
c01007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f0:	89 c2                	mov    %eax,%edx
c01007f2:	89 d0                	mov    %edx,%eax
c01007f4:	01 c0                	add    %eax,%eax
c01007f6:	01 d0                	add    %edx,%eax
c01007f8:	c1 e0 02             	shl    $0x2,%eax
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100800:	01 d0                	add    %edx,%eax
c0100802:	8b 10                	mov    (%eax),%edx
c0100804:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100807:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010080a:	39 c2                	cmp    %eax,%edx
c010080c:	73 21                	jae    c010082f <debuginfo_eip+0x2cf>
    {
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	89 d0                	mov    %edx,%eax
c0100815:	01 c0                	add    %eax,%eax
c0100817:	01 d0                	add    %edx,%eax
c0100819:	c1 e0 02             	shl    $0x2,%eax
c010081c:	89 c2                	mov    %eax,%edx
c010081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100821:	01 d0                	add    %edx,%eax
c0100823:	8b 10                	mov    (%eax),%edx
c0100825:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100828:	01 c2                	add    %eax,%edx
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
c010082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100832:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100835:	39 c2                	cmp    %eax,%edx
c0100837:	7d 46                	jge    c010087f <debuginfo_eip+0x31f>
    {
        for (lline = lfun + 1;
c0100839:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010083c:	40                   	inc    %eax
c010083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100840:	eb 16                	jmp    c0100858 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
        {
            info->eip_fn_narg++;
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	8b 40 14             	mov    0x14(%eax),%eax
c0100848:	8d 50 01             	lea    0x1(%eax),%edx
c010084b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084e:	89 50 14             	mov    %edx,0x14(%eax)
             lline++)
c0100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100854:	40                   	inc    %eax
c0100855:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010085e:	39 c2                	cmp    %eax,%edx
c0100860:	7d 1d                	jge    c010087f <debuginfo_eip+0x31f>
c0100862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	89 d0                	mov    %edx,%eax
c0100869:	01 c0                	add    %eax,%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	c1 e0 02             	shl    $0x2,%eax
c0100870:	89 c2                	mov    %eax,%edx
c0100872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100875:	01 d0                	add    %edx,%eax
c0100877:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087b:	3c a0                	cmp    $0xa0,%al
c010087d:	74 c3                	je     c0100842 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c010087f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100884:	89 ec                	mov    %ebp,%esp
c0100886:	5d                   	pop    %ebp
c0100887:	c3                   	ret    

c0100888 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
c0100888:	55                   	push   %ebp
c0100889:	89 e5                	mov    %esp,%ebp
c010088b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088e:	c7 04 24 b6 6d 10 c0 	movl   $0xc0106db6,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 cf 6d 10 c0 	movl   $0xc0106dcf,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 e2 6c 10 	movl   $0xc0106ce2,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 e7 6d 10 c0 	movl   $0xc0106de7,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 e0 11 	movl   $0xc011e000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 ff 6d 10 c0 	movl   $0xc0106dff,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 2c ef 11 	movl   $0xc011ef2c,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 17 6e 10 c0 	movl   $0xc0106e17,(%esp)
c01008e5:	e8 7b fa ff ff       	call   c0100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
c01008ea:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c01008ef:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ff:	85 c0                	test   %eax,%eax
c0100901:	0f 48 c2             	cmovs  %edx,%eax
c0100904:	c1 f8 0a             	sar    $0xa,%eax
c0100907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090b:	c7 04 24 30 6e 10 c0 	movl   $0xc0106e30,(%esp)
c0100912:	e8 4e fa ff ff       	call   c0100365 <cprintf>
}
c0100917:	90                   	nop
c0100918:	89 ec                	mov    %ebp,%esp
c010091a:	5d                   	pop    %ebp
c010091b:	c3                   	ret    

c010091c <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void print_debuginfo(uintptr_t eip)
{
c010091c:	55                   	push   %ebp
c010091d:	89 e5                	mov    %esp,%ebp
c010091f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0)
c0100925:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 04 24             	mov    %eax,(%esp)
c0100932:	e8 29 fc ff ff       	call   c0100560 <debuginfo_eip>
c0100937:	85 c0                	test   %eax,%eax
c0100939:	74 15                	je     c0100950 <print_debuginfo+0x34>
    {
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093b:	8b 45 08             	mov    0x8(%ebp),%eax
c010093e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100942:	c7 04 24 5a 6e 10 c0 	movl   $0xc0106e5a,(%esp)
c0100949:	e8 17 fa ff ff       	call   c0100365 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010094e:	eb 6c                	jmp    c01009bc <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j++)
c0100950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100957:	eb 1b                	jmp    c0100974 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095f:	01 d0                	add    %edx,%eax
c0100961:	0f b6 10             	movzbl (%eax),%edx
c0100964:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096d:	01 c8                	add    %ecx,%eax
c010096f:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j++)
c0100971:	ff 45 f4             	incl   -0xc(%ebp)
c0100974:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100977:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010097a:	7c dd                	jl     c0100959 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010097c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100985:	01 d0                	add    %edx,%eax
c0100987:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010098a:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100990:	29 d0                	sub    %edx,%eax
c0100992:	89 c1                	mov    %eax,%ecx
c0100994:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100997:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010099e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b0:	c7 04 24 76 6e 10 c0 	movl   $0xc0106e76,(%esp)
c01009b7:	e8 a9 f9 ff ff       	call   c0100365 <cprintf>
}
c01009bc:	90                   	nop
c01009bd:	89 ec                	mov    %ebp,%esp
c01009bf:	5d                   	pop    %ebp
c01009c0:	c3                   	ret    

c01009c1 <read_eip>:

static __noinline uint32_t
read_eip(void)
{
c01009c1:	55                   	push   %ebp
c01009c2:	89 e5                	mov    %esp,%ebp
c01009c4:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0"
c01009c7:	8b 45 04             	mov    0x4(%ebp),%eax
c01009ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(eip));
    return eip;
c01009cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009d0:	89 ec                	mov    %ebp,%esp
c01009d2:	5d                   	pop    %ebp
c01009d3:	c3                   	ret    

c01009d4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void print_stackframe(void)
{
c01009d4:	55                   	push   %ebp
c01009d5:	89 e5                	mov    %esp,%ebp
c01009d7:	83 ec 38             	sub    $0x38,%esp

static inline uint32_t
read_ebp(void)
{
    uint32_t ebp;
    asm volatile("movl %%ebp, %0"
c01009da:	89 e8                	mov    %ebp,%eax
c01009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
                 : "=r"(ebp));
    return ebp;
c01009df:	8b 45 e0             	mov    -0x20(%ebp),%eax
     *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e5:	e8 d7 ff ff ff       	call   c01009c1 <read_eip>
c01009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c01009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f4:	e9 84 00 00 00       	jmp    c0100a7d <print_stackframe+0xa9>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 88 6e 10 c0 	movl   $0xc0106e88,(%esp)
c0100a0e:	e8 52 f9 ff ff       	call   c0100365 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a16:	83 c0 08             	add    $0x8,%eax
c0100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j++)
c0100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a23:	eb 24                	jmp    c0100a49 <print_stackframe+0x75>
        {
            cprintf("0x%08x ", args[j]);
c0100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a32:	01 d0                	add    %edx,%eax
c0100a34:	8b 00                	mov    (%eax),%eax
c0100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3a:	c7 04 24 a4 6e 10 c0 	movl   $0xc0106ea4,(%esp)
c0100a41:	e8 1f f9 ff ff       	call   c0100365 <cprintf>
        for (j = 0; j < 4; j++)
c0100a46:	ff 45 e8             	incl   -0x18(%ebp)
c0100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4d:	7e d6                	jle    c0100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a4f:	c7 04 24 ac 6e 10 c0 	movl   $0xc0106eac,(%esp)
c0100a56:	e8 0a f9 ff ff       	call   c0100365 <cprintf>
        print_debuginfo(eip - 1);
c0100a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5e:	48                   	dec    %eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b5 fe ff ff       	call   c010091c <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c0100a7a:	ff 45 ec             	incl   -0x14(%ebp)
c0100a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a81:	74 0a                	je     c0100a8d <print_stackframe+0xb9>
c0100a83:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a87:	0f 8e 6c ff ff ff    	jle    c01009f9 <print_stackframe+0x25>
    }
}
c0100a8d:	90                   	nop
c0100a8e:	89 ec                	mov    %ebp,%esp
c0100a90:	5d                   	pop    %ebp
c0100a91:	c3                   	ret    

c0100a92 <parse>:
#define WHITESPACE " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv)
{
c0100a92:	55                   	push   %ebp
c0100a93:	89 e5                	mov    %esp,%ebp
c0100a95:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1)
    {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
c0100a9f:	eb 0c                	jmp    c0100aad <parse+0x1b>
        {
            *buf++ = '\0';
c0100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa4:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa7:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aaa:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
c0100aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab0:	0f b6 00             	movzbl (%eax),%eax
c0100ab3:	84 c0                	test   %al,%al
c0100ab5:	74 1d                	je     c0100ad4 <parse+0x42>
c0100ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aba:	0f b6 00             	movzbl (%eax),%eax
c0100abd:	0f be c0             	movsbl %al,%eax
c0100ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac4:	c7 04 24 30 6f 10 c0 	movl   $0xc0106f30,(%esp)
c0100acb:	e8 ca 5e 00 00       	call   c010699a <strchr>
c0100ad0:	85 c0                	test   %eax,%eax
c0100ad2:	75 cd                	jne    c0100aa1 <parse+0xf>
        }
        if (*buf == '\0')
c0100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad7:	0f b6 00             	movzbl (%eax),%eax
c0100ada:	84 c0                	test   %al,%al
c0100adc:	74 65                	je     c0100b43 <parse+0xb1>
        {
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1)
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x66>
        {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 35 6f 10 c0 	movl   $0xc0106f35,(%esp)
c0100af3:	e8 6d f8 ff ff       	call   c0100365 <cprintf>
        }
        argv[argc++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
c0100b12:	eb 03                	jmp    c0100b17 <parse+0x85>
        {
            buf++;
c0100b14:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	84 c0                	test   %al,%al
c0100b1f:	74 8c                	je     c0100aad <parse+0x1b>
c0100b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b24:	0f b6 00             	movzbl (%eax),%eax
c0100b27:	0f be c0             	movsbl %al,%eax
c0100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2e:	c7 04 24 30 6f 10 c0 	movl   $0xc0106f30,(%esp)
c0100b35:	e8 60 5e 00 00       	call   c010699a <strchr>
c0100b3a:	85 c0                	test   %eax,%eax
c0100b3c:	74 d6                	je     c0100b14 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
c0100b3e:	e9 6a ff ff ff       	jmp    c0100aad <parse+0x1b>
            break;
c0100b43:	90                   	nop
        }
    }
    return argc;
c0100b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b47:	89 ec                	mov    %ebp,%esp
c0100b49:	5d                   	pop    %ebp
c0100b4a:	c3                   	ret    

c0100b4b <runcmd>:
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf)
{
c0100b4b:	55                   	push   %ebp
c0100b4c:	89 e5                	mov    %esp,%ebp
c0100b4e:	83 ec 68             	sub    $0x68,%esp
c0100b51:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5e:	89 04 24             	mov    %eax,(%esp)
c0100b61:	e8 2c ff ff ff       	call   c0100a92 <parse>
c0100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0)
c0100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6d:	75 0a                	jne    c0100b79 <runcmd+0x2e>
    {
        return 0;
c0100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b74:	e9 83 00 00 00       	jmp    c0100bfc <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i++)
c0100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b80:	eb 5a                	jmp    c0100bdc <runcmd+0x91>
    {
        if (strcmp(commands[i].name, argv[0]) == 0)
c0100b82:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b88:	89 c8                	mov    %ecx,%eax
c0100b8a:	01 c0                	add    %eax,%eax
c0100b8c:	01 c8                	add    %ecx,%eax
c0100b8e:	c1 e0 02             	shl    $0x2,%eax
c0100b91:	05 00 b0 11 c0       	add    $0xc011b000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 5a 5d 00 00       	call   c01068fe <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 31                	jne    c0100bd9 <runcmd+0x8e>
        {
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 08 b0 11 c0       	add    $0xc011b008,%eax
c0100bb9:	8b 10                	mov    (%eax),%edx
c0100bbb:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bbe:	83 c0 04             	add    $0x4,%eax
c0100bc1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bc4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	89 1c 24             	mov    %ebx,(%esp)
c0100bd5:	ff d2                	call   *%edx
c0100bd7:	eb 23                	jmp    c0100bfc <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i++)
c0100bd9:	ff 45 f4             	incl   -0xc(%ebp)
c0100bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdf:	83 f8 02             	cmp    $0x2,%eax
c0100be2:	76 9e                	jbe    c0100b82 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100beb:	c7 04 24 53 6f 10 c0 	movl   $0xc0106f53,(%esp)
c0100bf2:	e8 6e f7 ff ff       	call   c0100365 <cprintf>
    return 0;
c0100bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bff:	89 ec                	mov    %ebp,%esp
c0100c01:	5d                   	pop    %ebp
c0100c02:	c3                   	ret    

c0100c03 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void kmonitor(struct trapframe *tf)
{
c0100c03:	55                   	push   %ebp
c0100c04:	89 e5                	mov    %esp,%ebp
c0100c06:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c09:	c7 04 24 6c 6f 10 c0 	movl   $0xc0106f6c,(%esp)
c0100c10:	e8 50 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c15:	c7 04 24 94 6f 10 c0 	movl   $0xc0106f94,(%esp)
c0100c1c:	e8 44 f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL)
c0100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c25:	74 0b                	je     c0100c32 <kmonitor+0x2f>
    {
        print_trapframe(tf);
c0100c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2a:	89 04 24             	mov    %eax,(%esp)
c0100c2d:	e8 f1 0e 00 00       	call   c0101b23 <print_trapframe>
    }

    char *buf;
    while (1)
    {
        if ((buf = readline("K> ")) != NULL)
c0100c32:	c7 04 24 b9 6f 10 c0 	movl   $0xc0106fb9,(%esp)
c0100c39:	e8 18 f6 ff ff       	call   c0100256 <readline>
c0100c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c45:	74 eb                	je     c0100c32 <kmonitor+0x2f>
        {
            if (runcmd(buf, tf) < 0)
c0100c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c51:	89 04 24             	mov    %eax,(%esp)
c0100c54:	e8 f2 fe ff ff       	call   c0100b4b <runcmd>
c0100c59:	85 c0                	test   %eax,%eax
c0100c5b:	78 02                	js     c0100c5f <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL)
c0100c5d:	eb d3                	jmp    c0100c32 <kmonitor+0x2f>
            {
                break;
c0100c5f:	90                   	nop
            }
        }
    }
}
c0100c60:	90                   	nop
c0100c61:	89 ec                	mov    %ebp,%esp
c0100c63:	5d                   	pop    %ebp
c0100c64:	c3                   	ret    

c0100c65 <mon_help>:

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
c0100c65:	55                   	push   %ebp
c0100c66:	89 e5                	mov    %esp,%ebp
c0100c68:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i++)
c0100c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c72:	eb 3d                	jmp    c0100cb1 <mon_help+0x4c>
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c77:	89 d0                	mov    %edx,%eax
c0100c79:	01 c0                	add    %eax,%eax
c0100c7b:	01 d0                	add    %edx,%eax
c0100c7d:	c1 e0 02             	shl    $0x2,%eax
c0100c80:	05 04 b0 11 c0       	add    $0xc011b004,%eax
c0100c85:	8b 10                	mov    (%eax),%edx
c0100c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c8a:	89 c8                	mov    %ecx,%eax
c0100c8c:	01 c0                	add    %eax,%eax
c0100c8e:	01 c8                	add    %ecx,%eax
c0100c90:	c1 e0 02             	shl    $0x2,%eax
c0100c93:	05 00 b0 11 c0       	add    $0xc011b000,%eax
c0100c98:	8b 00                	mov    (%eax),%eax
c0100c9a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca2:	c7 04 24 bd 6f 10 c0 	movl   $0xc0106fbd,(%esp)
c0100ca9:	e8 b7 f6 ff ff       	call   c0100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i++)
c0100cae:	ff 45 f4             	incl   -0xc(%ebp)
c0100cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb4:	83 f8 02             	cmp    $0x2,%eax
c0100cb7:	76 bb                	jbe    c0100c74 <mon_help+0xf>
    }
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	89 ec                	mov    %ebp,%esp
c0100cc0:	5d                   	pop    %ebp
c0100cc1:	c3                   	ret    

c0100cc2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
c0100cc2:	55                   	push   %ebp
c0100cc3:	89 e5                	mov    %esp,%ebp
c0100cc5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc8:	e8 bb fb ff ff       	call   c0100888 <print_kerninfo>
    return 0;
c0100ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd2:	89 ec                	mov    %ebp,%esp
c0100cd4:	5d                   	pop    %ebp
c0100cd5:	c3                   	ret    

c0100cd6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
c0100cd6:	55                   	push   %ebp
c0100cd7:	89 e5                	mov    %esp,%ebp
c0100cd9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cdc:	e8 f3 fc ff ff       	call   c01009d4 <print_stackframe>
    return 0;
c0100ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce6:	89 ec                	mov    %ebp,%esp
c0100ce8:	5d                   	pop    %ebp
c0100ce9:	c3                   	ret    

c0100cea <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
c0100cea:	55                   	push   %ebp
c0100ceb:	89 e5                	mov    %esp,%ebp
c0100ced:	83 ec 28             	sub    $0x28,%esp
    if (is_panic)
c0100cf0:	a1 20 e4 11 c0       	mov    0xc011e420,%eax
c0100cf5:	85 c0                	test   %eax,%eax
c0100cf7:	75 5b                	jne    c0100d54 <__panic+0x6a>
    {
        goto panic_dead;
    }
    is_panic = 1;
c0100cf9:	c7 05 20 e4 11 c0 01 	movl   $0x1,0xc011e420
c0100d00:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d03:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d17:	c7 04 24 c6 6f 10 c0 	movl   $0xc0106fc6,(%esp)
c0100d1e:	e8 42 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2d:	89 04 24             	mov    %eax,(%esp)
c0100d30:	e8 fb f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d35:	c7 04 24 e2 6f 10 c0 	movl   $0xc0106fe2,(%esp)
c0100d3c:	e8 24 f6 ff ff       	call   c0100365 <cprintf>

    cprintf("stack trackback:\n");
c0100d41:	c7 04 24 e4 6f 10 c0 	movl   $0xc0106fe4,(%esp)
c0100d48:	e8 18 f6 ff ff       	call   c0100365 <cprintf>
    print_stackframe();
c0100d4d:	e8 82 fc ff ff       	call   c01009d4 <print_stackframe>
c0100d52:	eb 01                	jmp    c0100d55 <__panic+0x6b>
        goto panic_dead;
c0100d54:	90                   	nop

    va_end(ap);

panic_dead:
    intr_disable();
c0100d55:	e8 e9 09 00 00       	call   c0101743 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
c0100d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d61:	e8 9d fe ff ff       	call   c0100c03 <kmonitor>
c0100d66:	eb f2                	jmp    c0100d5a <__panic+0x70>

c0100d68 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
c0100d68:	55                   	push   %ebp
c0100d69:	89 e5                	mov    %esp,%ebp
c0100d6b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d6e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d77:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d82:	c7 04 24 f6 6f 10 c0 	movl   $0xc0106ff6,(%esp)
c0100d89:	e8 d7 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d95:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d98:	89 04 24             	mov    %eax,(%esp)
c0100d9b:	e8 90 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da0:	c7 04 24 e2 6f 10 c0 	movl   $0xc0106fe2,(%esp)
c0100da7:	e8 b9 f5 ff ff       	call   c0100365 <cprintf>
    va_end(ap);
}
c0100dac:	90                   	nop
c0100dad:	89 ec                	mov    %ebp,%esp
c0100daf:	5d                   	pop    %ebp
c0100db0:	c3                   	ret    

c0100db1 <is_kernel_panic>:

bool is_kernel_panic(void)
{
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100db4:	a1 20 e4 11 c0       	mov    0xc011e420,%eax
}
c0100db9:	5d                   	pop    %ebp
c0100dba:	c3                   	ret    

c0100dbb <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
c0100dbb:	55                   	push   %ebp
c0100dbc:	89 e5                	mov    %esp,%ebp
c0100dbe:	83 ec 28             	sub    $0x28,%esp
c0100dc1:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dc7:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100dcb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd3:	ee                   	out    %al,(%dx)
}
c0100dd4:	90                   	nop
c0100dd5:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ddb:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100ddf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100de3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100de7:	ee                   	out    %al,(%dx)
}
c0100de8:	90                   	nop
c0100de9:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100def:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100df3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100df7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dfb:	ee                   	out    %al,(%dx)
}
c0100dfc:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dfd:	c7 05 24 e4 11 c0 00 	movl   $0x0,0xc011e424
c0100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e07:	c7 04 24 14 70 10 c0 	movl   $0xc0107014,(%esp)
c0100e0e:	e8 52 f5 ff ff       	call   c0100365 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e1a:	e8 89 09 00 00       	call   c01017a8 <pic_enable>
}
c0100e1f:	90                   	nop
c0100e20:	89 ec                	mov    %ebp,%esp
c0100e22:	5d                   	pop    %ebp
c0100e23:	c3                   	ret    

c0100e24 <__intr_save>:
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void)
{
c0100e24:	55                   	push   %ebp
c0100e25:	89 e5                	mov    %esp,%ebp
c0100e27:	83 ec 18             	sub    $0x18,%esp

static inline uint32_t
read_eflags(void)
{
    uint32_t eflags;
    asm volatile("pushfl; popl %0"
c0100e2a:	9c                   	pushf  
c0100e2b:	58                   	pop    %eax
c0100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                 : "=r"(eflags));
    return eflags;
c0100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
c0100e32:	25 00 02 00 00       	and    $0x200,%eax
c0100e37:	85 c0                	test   %eax,%eax
c0100e39:	74 0c                	je     c0100e47 <__intr_save+0x23>
    {
        intr_disable();
c0100e3b:	e8 03 09 00 00       	call   c0101743 <intr_disable>
        return 1;
c0100e40:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e45:	eb 05                	jmp    c0100e4c <__intr_save+0x28>
    }
    return 0;
c0100e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e4c:	89 ec                	mov    %ebp,%esp
c0100e4e:	5d                   	pop    %ebp
c0100e4f:	c3                   	ret    

c0100e50 <__intr_restore>:

static inline void
__intr_restore(bool flag)
{
c0100e50:	55                   	push   %ebp
c0100e51:	89 e5                	mov    %esp,%ebp
c0100e53:	83 ec 08             	sub    $0x8,%esp
    if (flag)
c0100e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e5a:	74 05                	je     c0100e61 <__intr_restore+0x11>
    {
        intr_enable();
c0100e5c:	e8 da 08 00 00       	call   c010173b <intr_enable>
    }
}
c0100e61:	90                   	nop
c0100e62:	89 ec                	mov    %ebp,%esp
c0100e64:	5d                   	pop    %ebp
c0100e65:	c3                   	ret    

c0100e66 <delay>:
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void)
{
c0100e66:	55                   	push   %ebp
c0100e67:	89 e5                	mov    %esp,%ebp
c0100e69:	83 ec 10             	sub    $0x10,%esp
c0100e6c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile("inb %1, %0"
c0100e72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e76:	89 c2                	mov    %eax,%edx
c0100e78:	ec                   	in     (%dx),%al
c0100e79:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e7c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e82:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e86:	89 c2                	mov    %eax,%edx
c0100e88:	ec                   	in     (%dx),%al
c0100e89:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e8c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e92:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e96:	89 c2                	mov    %eax,%edx
c0100e98:	ec                   	in     (%dx),%al
c0100e99:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e9c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ea2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ea6:	89 c2                	mov    %eax,%edx
c0100ea8:	ec                   	in     (%dx),%al
c0100ea9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eac:	90                   	nop
c0100ead:	89 ec                	mov    %ebp,%esp
c0100eaf:	5d                   	pop    %ebp
c0100eb0:	c3                   	ret    

c0100eb1 <cga_init>:

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void)
{
c0100eb1:	55                   	push   %ebp
c0100eb2:	89 e5                	mov    %esp,%ebp
c0100eb4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100eb7:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 00             	movzwl (%eax),%eax
c0100ec4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t)0xA55A;
c0100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ecb:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A)
c0100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed3:	0f b7 00             	movzwl (%eax),%eax
c0100ed6:	0f b7 c0             	movzwl %ax,%eax
c0100ed9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ede:	74 12                	je     c0100ef2 <cga_init+0x41>
    {
        cp = (uint16_t *)(MONO_BUF + KERNBASE);
c0100ee0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ee7:	66 c7 05 46 e4 11 c0 	movw   $0x3b4,0xc011e446
c0100eee:	b4 03 
c0100ef0:	eb 13                	jmp    c0100f05 <cga_init+0x54>
    }
    else
    {
        *cp = was;
c0100ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ef9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100efc:	66 c7 05 46 e4 11 c0 	movw   $0x3d4,0xc011e446
c0100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f05:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
}
c0100f1d:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f1e:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f25:	40                   	inc    %eax
c0100f26:	0f b7 c0             	movzwl %ax,%eax
c0100f29:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile("inb %1, %0"
c0100f2d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f31:	89 c2                	mov    %eax,%edx
c0100f33:	ec                   	in     (%dx),%al
c0100f34:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f37:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3b:	0f b6 c0             	movzbl %al,%eax
c0100f3e:	c1 e0 08             	shl    $0x8,%eax
c0100f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f44:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100f53:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f57:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f5b:	ee                   	out    %al,(%dx)
}
c0100f5c:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f5d:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f64:	40                   	inc    %eax
c0100f65:	0f b7 c0             	movzwl %ax,%eax
c0100f68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile("inb %1, %0"
c0100f6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f70:	89 c2                	mov    %eax,%edx
c0100f72:	ec                   	in     (%dx),%al
c0100f73:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7a:	0f b6 c0             	movzbl %al,%eax
c0100f7d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t *)cp;
c0100f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f83:	a3 40 e4 11 c0       	mov    %eax,0xc011e440
    crt_pos = pos;
c0100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f8b:	0f b7 c0             	movzwl %ax,%eax
c0100f8e:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
}
c0100f94:	90                   	nop
c0100f95:	89 ec                	mov    %ebp,%esp
c0100f97:	5d                   	pop    %ebp
c0100f98:	c3                   	ret    

c0100f99 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void)
{
c0100f99:	55                   	push   %ebp
c0100f9a:	89 e5                	mov    %esp,%ebp
c0100f9c:	83 ec 48             	sub    $0x48,%esp
c0100f9f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fa5:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100fa9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fb1:	ee                   	out    %al,(%dx)
}
c0100fb2:	90                   	nop
c0100fb3:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fb9:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100fbd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fc1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fc5:	ee                   	out    %al,(%dx)
}
c0100fc6:	90                   	nop
c0100fc7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fcd:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100fd1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fd5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
}
c0100fda:	90                   	nop
c0100fdb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100fe5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fed:	ee                   	out    %al,(%dx)
}
c0100fee:	90                   	nop
c0100fef:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ff5:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0100ff9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100ffd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101001:	ee                   	out    %al,(%dx)
}
c0101002:	90                   	nop
c0101003:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101009:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010100d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101011:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101015:	ee                   	out    %al,(%dx)
}
c0101016:	90                   	nop
c0101017:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010101d:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101021:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101025:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101029:	ee                   	out    %al,(%dx)
}
c010102a:	90                   	nop
c010102b:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile("inb %1, %0"
c0101031:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101035:	89 c2                	mov    %eax,%edx
c0101037:	ec                   	in     (%dx),%al
c0101038:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010103b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010103f:	3c ff                	cmp    $0xff,%al
c0101041:	0f 95 c0             	setne  %al
c0101044:	0f b6 c0             	movzbl %al,%eax
c0101047:	a3 48 e4 11 c0       	mov    %eax,0xc011e448
c010104c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile("inb %1, %0"
c0101052:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101056:	89 c2                	mov    %eax,%edx
c0101058:	ec                   	in     (%dx),%al
c0101059:	88 45 f1             	mov    %al,-0xf(%ebp)
c010105c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101062:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101066:	89 c2                	mov    %eax,%edx
c0101068:	ec                   	in     (%dx),%al
c0101069:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void)inb(COM1 + COM_IIR);
    (void)inb(COM1 + COM_RX);

    if (serial_exists)
c010106c:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c0101071:	85 c0                	test   %eax,%eax
c0101073:	74 0c                	je     c0101081 <serial_init+0xe8>
    {
        pic_enable(IRQ_COM1);
c0101075:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010107c:	e8 27 07 00 00       	call   c01017a8 <pic_enable>
    }
}
c0101081:	90                   	nop
c0101082:	89 ec                	mov    %ebp,%esp
c0101084:	5d                   	pop    %ebp
c0101085:	c3                   	ret    

c0101086 <lpt_putc_sub>:

static void
lpt_putc_sub(int c)
{
c0101086:	55                   	push   %ebp
c0101087:	89 e5                	mov    %esp,%ebp
c0101089:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i++)
c010108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101093:	eb 08                	jmp    c010109d <lpt_putc_sub+0x17>
    {
        delay();
c0101095:	e8 cc fd ff ff       	call   c0100e66 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i++)
c010109a:	ff 45 fc             	incl   -0x4(%ebp)
c010109d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010a7:	89 c2                	mov    %eax,%edx
c01010a9:	ec                   	in     (%dx),%al
c01010aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010b1:	84 c0                	test   %al,%al
c01010b3:	78 09                	js     c01010be <lpt_putc_sub+0x38>
c01010b5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010bc:	7e d7                	jle    c0101095 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010be:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c1:	0f b6 c0             	movzbl %al,%eax
c01010c4:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010ca:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d5:	ee                   	out    %al,(%dx)
}
c01010d6:	90                   	nop
c01010d7:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010dd:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01010e1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
}
c01010ea:	90                   	nop
c01010eb:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010f1:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01010f5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010f9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010fd:	ee                   	out    %al,(%dx)
}
c01010fe:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010ff:	90                   	nop
c0101100:	89 ec                	mov    %ebp,%esp
c0101102:	5d                   	pop    %ebp
c0101103:	c3                   	ret    

c0101104 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c)
{
c0101104:	55                   	push   %ebp
c0101105:	89 e5                	mov    %esp,%ebp
c0101107:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b')
c010110a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010110e:	74 0d                	je     c010111d <lpt_putc+0x19>
    {
        lpt_putc_sub(c);
c0101110:	8b 45 08             	mov    0x8(%ebp),%eax
c0101113:	89 04 24             	mov    %eax,(%esp)
c0101116:	e8 6b ff ff ff       	call   c0101086 <lpt_putc_sub>
    {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010111b:	eb 24                	jmp    c0101141 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010111d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101124:	e8 5d ff ff ff       	call   c0101086 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101129:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101130:	e8 51 ff ff ff       	call   c0101086 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101135:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010113c:	e8 45 ff ff ff       	call   c0101086 <lpt_putc_sub>
}
c0101141:	90                   	nop
c0101142:	89 ec                	mov    %ebp,%esp
c0101144:	5d                   	pop    %ebp
c0101145:	c3                   	ret    

c0101146 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c)
{
c0101146:	55                   	push   %ebp
c0101147:	89 e5                	mov    %esp,%ebp
c0101149:	83 ec 38             	sub    $0x38,%esp
c010114c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF))
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101157:	85 c0                	test   %eax,%eax
c0101159:	75 07                	jne    c0101162 <cga_putc+0x1c>
    {
        c |= 0x0700;
c010115b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff)
c0101162:	8b 45 08             	mov    0x8(%ebp),%eax
c0101165:	0f b6 c0             	movzbl %al,%eax
c0101168:	83 f8 0d             	cmp    $0xd,%eax
c010116b:	74 72                	je     c01011df <cga_putc+0x99>
c010116d:	83 f8 0d             	cmp    $0xd,%eax
c0101170:	0f 8f a3 00 00 00    	jg     c0101219 <cga_putc+0xd3>
c0101176:	83 f8 08             	cmp    $0x8,%eax
c0101179:	74 0a                	je     c0101185 <cga_putc+0x3f>
c010117b:	83 f8 0a             	cmp    $0xa,%eax
c010117e:	74 4c                	je     c01011cc <cga_putc+0x86>
c0101180:	e9 94 00 00 00       	jmp    c0101219 <cga_putc+0xd3>
    {
    case '\b':
        if (crt_pos > 0)
c0101185:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010118c:	85 c0                	test   %eax,%eax
c010118e:	0f 84 af 00 00 00    	je     c0101243 <cga_putc+0xfd>
        {
            crt_pos--;
c0101194:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010119b:	48                   	dec    %eax
c010119c:	0f b7 c0             	movzwl %ax,%eax
c010119f:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a8:	98                   	cwtl   
c01011a9:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ae:	98                   	cwtl   
c01011af:	83 c8 20             	or     $0x20,%eax
c01011b2:	98                   	cwtl   
c01011b3:	8b 0d 40 e4 11 c0    	mov    0xc011e440,%ecx
c01011b9:	0f b7 15 44 e4 11 c0 	movzwl 0xc011e444,%edx
c01011c0:	01 d2                	add    %edx,%edx
c01011c2:	01 ca                	add    %ecx,%edx
c01011c4:	0f b7 c0             	movzwl %ax,%eax
c01011c7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011ca:	eb 77                	jmp    c0101243 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011cc:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01011d3:	83 c0 50             	add    $0x50,%eax
c01011d6:	0f b7 c0             	movzwl %ax,%eax
c01011d9:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011df:	0f b7 1d 44 e4 11 c0 	movzwl 0xc011e444,%ebx
c01011e6:	0f b7 0d 44 e4 11 c0 	movzwl 0xc011e444,%ecx
c01011ed:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011f2:	89 c8                	mov    %ecx,%eax
c01011f4:	f7 e2                	mul    %edx
c01011f6:	c1 ea 06             	shr    $0x6,%edx
c01011f9:	89 d0                	mov    %edx,%eax
c01011fb:	c1 e0 02             	shl    $0x2,%eax
c01011fe:	01 d0                	add    %edx,%eax
c0101200:	c1 e0 04             	shl    $0x4,%eax
c0101203:	29 c1                	sub    %eax,%ecx
c0101205:	89 ca                	mov    %ecx,%edx
c0101207:	0f b7 d2             	movzwl %dx,%edx
c010120a:	89 d8                	mov    %ebx,%eax
c010120c:	29 d0                	sub    %edx,%eax
c010120e:	0f b7 c0             	movzwl %ax,%eax
c0101211:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
        break;
c0101217:	eb 2b                	jmp    c0101244 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos++] = c; // write the character
c0101219:	8b 0d 40 e4 11 c0    	mov    0xc011e440,%ecx
c010121f:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c0101226:	8d 50 01             	lea    0x1(%eax),%edx
c0101229:	0f b7 d2             	movzwl %dx,%edx
c010122c:	66 89 15 44 e4 11 c0 	mov    %dx,0xc011e444
c0101233:	01 c0                	add    %eax,%eax
c0101235:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101238:	8b 45 08             	mov    0x8(%ebp),%eax
c010123b:	0f b7 c0             	movzwl %ax,%eax
c010123e:	66 89 02             	mov    %ax,(%edx)
        break;
c0101241:	eb 01                	jmp    c0101244 <cga_putc+0xfe>
        break;
c0101243:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE)
c0101244:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101250:	76 5e                	jbe    c01012b0 <cga_putc+0x16a>
    {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101252:	a1 40 e4 11 c0       	mov    0xc011e440,%eax
c0101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125d:	a1 40 e4 11 c0       	mov    0xc011e440,%eax
c0101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101269:	00 
c010126a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126e:	89 04 24             	mov    %eax,(%esp)
c0101271:	e8 22 59 00 00       	call   c0106b98 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
c0101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127d:	eb 15                	jmp    c0101294 <cga_putc+0x14e>
        {
            crt_buf[i] = 0x0700 | ' ';
c010127f:	8b 15 40 e4 11 c0    	mov    0xc011e440,%edx
c0101285:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101288:	01 c0                	add    %eax,%eax
c010128a:	01 d0                	add    %edx,%eax
c010128c:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
c0101291:	ff 45 f4             	incl   -0xc(%ebp)
c0101294:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010129b:	7e e2                	jle    c010127f <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c010129d:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01012a4:	83 e8 50             	sub    $0x50,%eax
c01012a7:	0f b7 c0             	movzwl %ax,%eax
c01012aa:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012b0:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c01012b7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012bb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012c9:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01012d0:	c1 e8 08             	shr    $0x8,%eax
c01012d3:	0f b7 c0             	movzwl %ax,%eax
c01012d6:	0f b6 c0             	movzbl %al,%eax
c01012d9:	0f b7 15 46 e4 11 c0 	movzwl 0xc011e446,%edx
c01012e0:	42                   	inc    %edx
c01012e1:	0f b7 d2             	movzwl %dx,%edx
c01012e4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012e8:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012f3:	ee                   	out    %al,(%dx)
}
c01012f4:	90                   	nop
    outb(addr_6845, 15);
c01012f5:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c01012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101304:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101308:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130c:	ee                   	out    %al,(%dx)
}
c010130d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010130e:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c0101315:	0f b6 c0             	movzbl %al,%eax
c0101318:	0f b7 15 46 e4 11 c0 	movzwl 0xc011e446,%edx
c010131f:	42                   	inc    %edx
c0101320:	0f b7 d2             	movzwl %dx,%edx
c0101323:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101327:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010132a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010132e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101332:	ee                   	out    %al,(%dx)
}
c0101333:	90                   	nop
}
c0101334:	90                   	nop
c0101335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101338:	89 ec                	mov    %ebp,%esp
c010133a:	5d                   	pop    %ebp
c010133b:	c3                   	ret    

c010133c <serial_putc_sub>:

static void
serial_putc_sub(int c)
{
c010133c:	55                   	push   %ebp
c010133d:	89 e5                	mov    %esp,%ebp
c010133f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
c0101342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101349:	eb 08                	jmp    c0101353 <serial_putc_sub+0x17>
    {
        delay();
c010134b:	e8 16 fb ff ff       	call   c0100e66 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
c0101350:	ff 45 fc             	incl   -0x4(%ebp)
c0101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile("inb %1, %0"
c0101359:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010135d:	89 c2                	mov    %eax,%edx
c010135f:	ec                   	in     (%dx),%al
c0101360:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101363:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101367:	0f b6 c0             	movzbl %al,%eax
c010136a:	83 e0 20             	and    $0x20,%eax
c010136d:	85 c0                	test   %eax,%eax
c010136f:	75 09                	jne    c010137a <serial_putc_sub+0x3e>
c0101371:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101378:	7e d1                	jle    c010134b <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c010137a:	8b 45 08             	mov    0x8(%ebp),%eax
c010137d:	0f b6 c0             	movzbl %al,%eax
c0101380:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101386:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101389:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010138d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101391:	ee                   	out    %al,(%dx)
}
c0101392:	90                   	nop
}
c0101393:	90                   	nop
c0101394:	89 ec                	mov    %ebp,%esp
c0101396:	5d                   	pop    %ebp
c0101397:	c3                   	ret    

c0101398 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c)
{
c0101398:	55                   	push   %ebp
c0101399:	89 e5                	mov    %esp,%ebp
c010139b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b')
c010139e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a2:	74 0d                	je     c01013b1 <serial_putc+0x19>
    {
        serial_putc_sub(c);
c01013a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a7:	89 04 24             	mov    %eax,(%esp)
c01013aa:	e8 8d ff ff ff       	call   c010133c <serial_putc_sub>
    {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013af:	eb 24                	jmp    c01013d5 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013b8:	e8 7f ff ff ff       	call   c010133c <serial_putc_sub>
        serial_putc_sub(' ');
c01013bd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013c4:	e8 73 ff ff ff       	call   c010133c <serial_putc_sub>
        serial_putc_sub('\b');
c01013c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013d0:	e8 67 ff ff ff       	call   c010133c <serial_putc_sub>
}
c01013d5:	90                   	nop
c01013d6:	89 ec                	mov    %ebp,%esp
c01013d8:	5d                   	pop    %ebp
c01013d9:	c3                   	ret    

c01013da <cons_intr>:
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void))
{
c01013da:	55                   	push   %ebp
c01013db:	89 e5                	mov    %esp,%ebp
c01013dd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1)
c01013e0:	eb 33                	jmp    c0101415 <cons_intr+0x3b>
    {
        if (c != 0)
c01013e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e6:	74 2d                	je     c0101415 <cons_intr+0x3b>
        {
            cons.buf[cons.wpos++] = c;
c01013e8:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c01013ed:	8d 50 01             	lea    0x1(%eax),%edx
c01013f0:	89 15 64 e6 11 c0    	mov    %edx,0xc011e664
c01013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f9:	88 90 60 e4 11 c0    	mov    %dl,-0x3fee1ba0(%eax)
            if (cons.wpos == CONSBUFSIZE)
c01013ff:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c0101404:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101409:	75 0a                	jne    c0101415 <cons_intr+0x3b>
            {
                cons.wpos = 0;
c010140b:	c7 05 64 e6 11 c0 00 	movl   $0x0,0xc011e664
c0101412:	00 00 00 
    while ((c = (*proc)()) != -1)
c0101415:	8b 45 08             	mov    0x8(%ebp),%eax
c0101418:	ff d0                	call   *%eax
c010141a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010141d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101421:	75 bf                	jne    c01013e2 <cons_intr+0x8>
            }
        }
    }
}
c0101423:	90                   	nop
c0101424:	90                   	nop
c0101425:	89 ec                	mov    %ebp,%esp
c0101427:	5d                   	pop    %ebp
c0101428:	c3                   	ret    

c0101429 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void)
{
c0101429:	55                   	push   %ebp
c010142a:	89 e5                	mov    %esp,%ebp
c010142c:	83 ec 10             	sub    $0x10,%esp
c010142f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile("inb %1, %0"
c0101435:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101439:	89 c2                	mov    %eax,%edx
c010143b:	ec                   	in     (%dx),%al
c010143c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010143f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
c0101443:	0f b6 c0             	movzbl %al,%eax
c0101446:	83 e0 01             	and    $0x1,%eax
c0101449:	85 c0                	test   %eax,%eax
c010144b:	75 07                	jne    c0101454 <serial_proc_data+0x2b>
    {
        return -1;
c010144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101452:	eb 2a                	jmp    c010147e <serial_proc_data+0x55>
c0101454:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile("inb %1, %0"
c010145a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010145e:	89 c2                	mov    %eax,%edx
c0101460:	ec                   	in     (%dx),%al
c0101461:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101464:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101468:	0f b6 c0             	movzbl %al,%eax
c010146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127)
c010146e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101472:	75 07                	jne    c010147b <serial_proc_data+0x52>
    {
        c = '\b';
c0101474:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010147b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010147e:	89 ec                	mov    %ebp,%esp
c0101480:	5d                   	pop    %ebp
c0101481:	c3                   	ret    

c0101482 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void)
{
c0101482:	55                   	push   %ebp
c0101483:	89 e5                	mov    %esp,%ebp
c0101485:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists)
c0101488:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c010148d:	85 c0                	test   %eax,%eax
c010148f:	74 0c                	je     c010149d <serial_intr+0x1b>
    {
        cons_intr(serial_proc_data);
c0101491:	c7 04 24 29 14 10 c0 	movl   $0xc0101429,(%esp)
c0101498:	e8 3d ff ff ff       	call   c01013da <cons_intr>
    }
}
c010149d:	90                   	nop
c010149e:	89 ec                	mov    %ebp,%esp
c01014a0:	5d                   	pop    %ebp
c01014a1:	c3                   	ret    

c01014a2 <kbd_proc_data>:
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void)
{
c01014a2:	55                   	push   %ebp
c01014a3:	89 e5                	mov    %esp,%ebp
c01014a5:	83 ec 38             	sub    $0x38,%esp
c01014a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile("inb %1, %0"
c01014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014b1:	89 c2                	mov    %eax,%edx
c01014b3:	ec                   	in     (%dx),%al
c01014b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0)
c01014bb:	0f b6 c0             	movzbl %al,%eax
c01014be:	83 e0 01             	and    $0x1,%eax
c01014c1:	85 c0                	test   %eax,%eax
c01014c3:	75 0a                	jne    c01014cf <kbd_proc_data+0x2d>
    {
        return -1;
c01014c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014ca:	e9 56 01 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
c01014cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile("inb %1, %0"
c01014d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014d8:	89 c2                	mov    %eax,%edx
c01014da:	ec                   	in     (%dx),%al
c01014db:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014de:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0)
c01014e5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014e9:	75 17                	jne    c0101502 <kbd_proc_data+0x60>
    {
        // E0 escape character
        shift |= E0ESC;
c01014eb:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01014f0:	83 c8 40             	or     $0x40,%eax
c01014f3:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
        return 0;
c01014f8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014fd:	e9 23 01 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    }
    else if (data & 0x80)
c0101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101506:	84 c0                	test   %al,%al
c0101508:	79 45                	jns    c010154f <kbd_proc_data+0xad>
    {
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010150a:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c010150f:	83 e0 40             	and    $0x40,%eax
c0101512:	85 c0                	test   %eax,%eax
c0101514:	75 08                	jne    c010151e <kbd_proc_data+0x7c>
c0101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151a:	24 7f                	and    $0x7f,%al
c010151c:	eb 04                	jmp    c0101522 <kbd_proc_data+0x80>
c010151e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101522:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101525:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101529:	0f b6 80 40 b0 11 c0 	movzbl -0x3fee4fc0(%eax),%eax
c0101530:	0c 40                	or     $0x40,%al
c0101532:	0f b6 c0             	movzbl %al,%eax
c0101535:	f7 d0                	not    %eax
c0101537:	89 c2                	mov    %eax,%edx
c0101539:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c010153e:	21 d0                	and    %edx,%eax
c0101540:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
        return 0;
c0101545:	b8 00 00 00 00       	mov    $0x0,%eax
c010154a:	e9 d6 00 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    }
    else if (shift & E0ESC)
c010154f:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101554:	83 e0 40             	and    $0x40,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	74 11                	je     c010156c <kbd_proc_data+0xca>
    {
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010155b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010155f:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101564:	83 e0 bf             	and    $0xffffffbf,%eax
c0101567:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
    }

    shift |= shiftcode[data];
c010156c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101570:	0f b6 80 40 b0 11 c0 	movzbl -0x3fee4fc0(%eax),%eax
c0101577:	0f b6 d0             	movzbl %al,%edx
c010157a:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c010157f:	09 d0                	or     %edx,%eax
c0101581:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
    shift ^= togglecode[data];
c0101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158a:	0f b6 80 40 b1 11 c0 	movzbl -0x3fee4ec0(%eax),%eax
c0101591:	0f b6 d0             	movzbl %al,%edx
c0101594:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101599:	31 d0                	xor    %edx,%eax
c010159b:	a3 68 e6 11 c0       	mov    %eax,0xc011e668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a0:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015a5:	83 e0 03             	and    $0x3,%eax
c01015a8:	8b 14 85 40 b5 11 c0 	mov    -0x3fee4ac0(,%eax,4),%edx
c01015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b3:	01 d0                	add    %edx,%eax
c01015b5:	0f b6 00             	movzbl (%eax),%eax
c01015b8:	0f b6 c0             	movzbl %al,%eax
c01015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK)
c01015be:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015c3:	83 e0 08             	and    $0x8,%eax
c01015c6:	85 c0                	test   %eax,%eax
c01015c8:	74 22                	je     c01015ec <kbd_proc_data+0x14a>
    {
        if ('a' <= c && c <= 'z')
c01015ca:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015ce:	7e 0c                	jle    c01015dc <kbd_proc_data+0x13a>
c01015d0:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015d4:	7f 06                	jg     c01015dc <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015d6:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015da:	eb 10                	jmp    c01015ec <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015dc:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015e0:	7e 0a                	jle    c01015ec <kbd_proc_data+0x14a>
c01015e2:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015e6:	7f 04                	jg     c01015ec <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015e8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL)
c01015ec:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015f1:	f7 d0                	not    %eax
c01015f3:	83 e0 06             	and    $0x6,%eax
c01015f6:	85 c0                	test   %eax,%eax
c01015f8:	75 28                	jne    c0101622 <kbd_proc_data+0x180>
c01015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101601:	75 1f                	jne    c0101622 <kbd_proc_data+0x180>
    {
        cprintf("Rebooting!\n");
c0101603:	c7 04 24 2f 70 10 c0 	movl   $0xc010702f,(%esp)
c010160a:	e8 56 ed ff ff       	call   c0100365 <cprintf>
c010160f:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101615:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101619:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010161d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101620:	ee                   	out    %al,(%dx)
}
c0101621:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101622:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101625:	89 ec                	mov    %ebp,%esp
c0101627:	5d                   	pop    %ebp
c0101628:	c3                   	ret    

c0101629 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void)
{
c0101629:	55                   	push   %ebp
c010162a:	89 e5                	mov    %esp,%ebp
c010162c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010162f:	c7 04 24 a2 14 10 c0 	movl   $0xc01014a2,(%esp)
c0101636:	e8 9f fd ff ff       	call   c01013da <cons_intr>
}
c010163b:	90                   	nop
c010163c:	89 ec                	mov    %ebp,%esp
c010163e:	5d                   	pop    %ebp
c010163f:	c3                   	ret    

c0101640 <kbd_init>:

static void
kbd_init(void)
{
c0101640:	55                   	push   %ebp
c0101641:	89 e5                	mov    %esp,%ebp
c0101643:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101646:	e8 de ff ff ff       	call   c0101629 <kbd_intr>
    pic_enable(IRQ_KBD);
c010164b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101652:	e8 51 01 00 00       	call   c01017a8 <pic_enable>
}
c0101657:	90                   	nop
c0101658:	89 ec                	mov    %ebp,%esp
c010165a:	5d                   	pop    %ebp
c010165b:	c3                   	ret    

c010165c <cons_init>:

/* cons_init - initializes the console devices */
void cons_init(void)
{
c010165c:	55                   	push   %ebp
c010165d:	89 e5                	mov    %esp,%ebp
c010165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101662:	e8 4a f8 ff ff       	call   c0100eb1 <cga_init>
    serial_init();
c0101667:	e8 2d f9 ff ff       	call   c0100f99 <serial_init>
    kbd_init();
c010166c:	e8 cf ff ff ff       	call   c0101640 <kbd_init>
    if (!serial_exists)
c0101671:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c0101676:	85 c0                	test   %eax,%eax
c0101678:	75 0c                	jne    c0101686 <cons_init+0x2a>
    {
        cprintf("serial port does not exist!!\n");
c010167a:	c7 04 24 3b 70 10 c0 	movl   $0xc010703b,(%esp)
c0101681:	e8 df ec ff ff       	call   c0100365 <cprintf>
    }
}
c0101686:	90                   	nop
c0101687:	89 ec                	mov    %ebp,%esp
c0101689:	5d                   	pop    %ebp
c010168a:	c3                   	ret    

c010168b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c)
{
c010168b:	55                   	push   %ebp
c010168c:	89 e5                	mov    %esp,%ebp
c010168e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101691:	e8 8e f7 ff ff       	call   c0100e24 <__intr_save>
c0101696:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101699:	8b 45 08             	mov    0x8(%ebp),%eax
c010169c:	89 04 24             	mov    %eax,(%esp)
c010169f:	e8 60 fa ff ff       	call   c0101104 <lpt_putc>
        cga_putc(c);
c01016a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a7:	89 04 24             	mov    %eax,(%esp)
c01016aa:	e8 97 fa ff ff       	call   c0101146 <cga_putc>
        serial_putc(c);
c01016af:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b2:	89 04 24             	mov    %eax,(%esp)
c01016b5:	e8 de fc ff ff       	call   c0101398 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016bd:	89 04 24             	mov    %eax,(%esp)
c01016c0:	e8 8b f7 ff ff       	call   c0100e50 <__intr_restore>
}
c01016c5:	90                   	nop
c01016c6:	89 ec                	mov    %ebp,%esp
c01016c8:	5d                   	pop    %ebp
c01016c9:	c3                   	ret    

c01016ca <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void)
{
c01016ca:	55                   	push   %ebp
c01016cb:	89 e5                	mov    %esp,%ebp
c01016cd:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016d7:	e8 48 f7 ff ff       	call   c0100e24 <__intr_save>
c01016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016df:	e8 9e fd ff ff       	call   c0101482 <serial_intr>
        kbd_intr();
c01016e4:	e8 40 ff ff ff       	call   c0101629 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos)
c01016e9:	8b 15 60 e6 11 c0    	mov    0xc011e660,%edx
c01016ef:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c01016f4:	39 c2                	cmp    %eax,%edx
c01016f6:	74 31                	je     c0101729 <cons_getc+0x5f>
        {
            c = cons.buf[cons.rpos++];
c01016f8:	a1 60 e6 11 c0       	mov    0xc011e660,%eax
c01016fd:	8d 50 01             	lea    0x1(%eax),%edx
c0101700:	89 15 60 e6 11 c0    	mov    %edx,0xc011e660
c0101706:	0f b6 80 60 e4 11 c0 	movzbl -0x3fee1ba0(%eax),%eax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE)
c0101713:	a1 60 e6 11 c0       	mov    0xc011e660,%eax
c0101718:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171d:	75 0a                	jne    c0101729 <cons_getc+0x5f>
            {
                cons.rpos = 0;
c010171f:	c7 05 60 e6 11 c0 00 	movl   $0x0,0xc011e660
c0101726:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101729:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010172c:	89 04 24             	mov    %eax,(%esp)
c010172f:	e8 1c f7 ff ff       	call   c0100e50 <__intr_restore>
    return c;
c0101734:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101737:	89 ec                	mov    %ebp,%esp
c0101739:	5d                   	pop    %ebp
c010173a:	c3                   	ret    

c010173b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void)
{
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
    asm volatile("sti");
c010173e:	fb                   	sti    
}
c010173f:	90                   	nop
    sti();
}
c0101740:	90                   	nop
c0101741:	5d                   	pop    %ebp
c0101742:	c3                   	ret    

c0101743 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void)
{
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
    asm volatile("cli" ::
c0101746:	fa                   	cli    
}
c0101747:	90                   	nop
    cli();
}
c0101748:	90                   	nop
c0101749:	5d                   	pop    %ebp
c010174a:	c3                   	ret    

c010174b <pic_setmask>:
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask)
{
c010174b:	55                   	push   %ebp
c010174c:	89 e5                	mov    %esp,%ebp
c010174e:	83 ec 14             	sub    $0x14,%esp
c0101751:	8b 45 08             	mov    0x8(%ebp),%eax
c0101754:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101758:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010175b:	66 a3 50 b5 11 c0    	mov    %ax,0xc011b550
    if (did_init)
c0101761:	a1 6c e6 11 c0       	mov    0xc011e66c,%eax
c0101766:	85 c0                	test   %eax,%eax
c0101768:	74 39                	je     c01017a3 <pic_setmask+0x58>
    {
        outb(IO_PIC1 + 1, mask);
c010176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010176d:	0f b6 c0             	movzbl %al,%eax
c0101770:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101776:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101779:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010177d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
}
c0101782:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101783:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101787:	c1 e8 08             	shr    $0x8,%eax
c010178a:	0f b7 c0             	movzwl %ax,%eax
c010178d:	0f b6 c0             	movzbl %al,%eax
c0101790:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101796:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101799:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010179d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017a1:	ee                   	out    %al,(%dx)
}
c01017a2:	90                   	nop
    }
}
c01017a3:	90                   	nop
c01017a4:	89 ec                	mov    %ebp,%esp
c01017a6:	5d                   	pop    %ebp
c01017a7:	c3                   	ret    

c01017a8 <pic_enable>:

void pic_enable(unsigned int irq)
{
c01017a8:	55                   	push   %ebp
c01017a9:	89 e5                	mov    %esp,%ebp
c01017ab:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01017b1:	ba 01 00 00 00       	mov    $0x1,%edx
c01017b6:	88 c1                	mov    %al,%cl
c01017b8:	d3 e2                	shl    %cl,%edx
c01017ba:	89 d0                	mov    %edx,%eax
c01017bc:	98                   	cwtl   
c01017bd:	f7 d0                	not    %eax
c01017bf:	0f bf d0             	movswl %ax,%edx
c01017c2:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c01017c9:	98                   	cwtl   
c01017ca:	21 d0                	and    %edx,%eax
c01017cc:	98                   	cwtl   
c01017cd:	0f b7 c0             	movzwl %ax,%eax
c01017d0:	89 04 24             	mov    %eax,(%esp)
c01017d3:	e8 73 ff ff ff       	call   c010174b <pic_setmask>
}
c01017d8:	90                   	nop
c01017d9:	89 ec                	mov    %ebp,%esp
c01017db:	5d                   	pop    %ebp
c01017dc:	c3                   	ret    

c01017dd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void)
{
c01017dd:	55                   	push   %ebp
c01017de:	89 e5                	mov    %esp,%ebp
c01017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017e3:	c7 05 6c e6 11 c0 01 	movl   $0x1,0xc011e66c
c01017ea:	00 00 00 
c01017ed:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017f3:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01017f7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017fb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
}
c0101800:	90                   	nop
c0101801:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101807:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010180b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010180f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
}
c0101814:	90                   	nop
c0101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
}
c0101828:	90                   	nop
c0101829:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010182f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101833:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101837:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
}
c010183c:	90                   	nop
c010183d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101843:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101847:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010184b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010184f:	ee                   	out    %al,(%dx)
}
c0101850:	90                   	nop
c0101851:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101857:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010185b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010185f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101863:	ee                   	out    %al,(%dx)
}
c0101864:	90                   	nop
c0101865:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c010186b:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c010186f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101873:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101877:	ee                   	out    %al,(%dx)
}
c0101878:	90                   	nop
c0101879:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c010187f:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101883:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101887:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010188b:	ee                   	out    %al,(%dx)
}
c010188c:	90                   	nop
c010188d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101893:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c0101897:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010189b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010189f:	ee                   	out    %al,(%dx)
}
c01018a0:	90                   	nop
c01018a1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018a7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01018ab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018af:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018b3:	ee                   	out    %al,(%dx)
}
c01018b4:	90                   	nop
c01018b5:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018bb:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01018bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018c7:	ee                   	out    %al,(%dx)
}
c01018c8:	90                   	nop
c01018c9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018cf:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01018d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018db:	ee                   	out    %al,(%dx)
}
c01018dc:	90                   	nop
c01018dd:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018e3:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01018e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018eb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018ef:	ee                   	out    %al,(%dx)
}
c01018f0:	90                   	nop
c01018f1:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018f7:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01018fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01018ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101903:	ee                   	out    %al,(%dx)
}
c0101904:	90                   	nop
    outb(IO_PIC1, 0x0a); // read IRR by default

    outb(IO_PIC2, 0x68); // OCW3
    outb(IO_PIC2, 0x0a); // OCW3

    if (irq_mask != 0xFFFF)
c0101905:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c010190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101911:	74 0f                	je     c0101922 <pic_init+0x145>
    {
        pic_setmask(irq_mask);
c0101913:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c010191a:	89 04 24             	mov    %eax,(%esp)
c010191d:	e8 29 fe ff ff       	call   c010174b <pic_setmask>
    }
}
c0101922:	90                   	nop
c0101923:	89 ec                	mov    %ebp,%esp
c0101925:	5d                   	pop    %ebp
c0101926:	c3                   	ret    

c0101927 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
c0101927:	55                   	push   %ebp
c0101928:	89 e5                	mov    %esp,%ebp
c010192a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
c010192d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101934:	00 
c0101935:	c7 04 24 60 70 10 c0 	movl   $0xc0107060,(%esp)
c010193c:	e8 24 ea ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101941:	c7 04 24 6a 70 10 c0 	movl   $0xc010706a,(%esp)
c0101948:	e8 18 ea ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c010194d:	c7 44 24 08 78 70 10 	movl   $0xc0107078,0x8(%esp)
c0101954:	c0 
c0101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
c010195c:	00 
c010195d:	c7 04 24 8e 70 10 c0 	movl   $0xc010708e,(%esp)
c0101964:	e8 81 f3 ff ff       	call   c0100cea <__panic>

c0101969 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
c0101969:	55                   	push   %ebp
c010196a:	89 e5                	mov    %esp,%ebp
c010196c:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
c010196f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101976:	e9 c4 00 00 00       	jmp    c0101a3f <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197e:	8b 04 85 e0 b5 11 c0 	mov    -0x3fee4a20(,%eax,4),%eax
c0101985:	0f b7 d0             	movzwl %ax,%edx
c0101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198b:	66 89 14 c5 80 e6 11 	mov    %dx,-0x3fee1980(,%eax,8)
c0101992:	c0 
c0101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101996:	66 c7 04 c5 82 e6 11 	movw   $0x8,-0x3fee197e(,%eax,8)
c010199d:	c0 08 00 
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	0f b6 14 c5 84 e6 11 	movzbl -0x3fee197c(,%eax,8),%edx
c01019aa:	c0 
c01019ab:	80 e2 e0             	and    $0xe0,%dl
c01019ae:	88 14 c5 84 e6 11 c0 	mov    %dl,-0x3fee197c(,%eax,8)
c01019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b8:	0f b6 14 c5 84 e6 11 	movzbl -0x3fee197c(,%eax,8),%edx
c01019bf:	c0 
c01019c0:	80 e2 1f             	and    $0x1f,%dl
c01019c3:	88 14 c5 84 e6 11 c0 	mov    %dl,-0x3fee197c(,%eax,8)
c01019ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cd:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c01019d4:	c0 
c01019d5:	80 e2 f0             	and    $0xf0,%dl
c01019d8:	80 ca 0e             	or     $0xe,%dl
c01019db:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c01019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e5:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c01019ec:	c0 
c01019ed:	80 e2 ef             	and    $0xef,%dl
c01019f0:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c01019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fa:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c0101a01:	c0 
c0101a02:	80 e2 9f             	and    $0x9f,%dl
c0101a05:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c0101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0f:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c0101a16:	c0 
c0101a17:	80 ca 80             	or     $0x80,%dl
c0101a1a:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c0101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a24:	8b 04 85 e0 b5 11 c0 	mov    -0x3fee4a20(,%eax,4),%eax
c0101a2b:	c1 e8 10             	shr    $0x10,%eax
c0101a2e:	0f b7 d0             	movzwl %ax,%edx
c0101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a34:	66 89 14 c5 86 e6 11 	mov    %dx,-0x3fee197a(,%eax,8)
c0101a3b:	c0 
    for (int i = 0; i < 256; i++)
c0101a3c:	ff 45 fc             	incl   -0x4(%ebp)
c0101a3f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a46:	0f 8e 2f ff ff ff    	jle    c010197b <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a4c:	a1 c4 b7 11 c0       	mov    0xc011b7c4,%eax
c0101a51:	0f b7 c0             	movzwl %ax,%eax
c0101a54:	66 a3 48 ea 11 c0    	mov    %ax,0xc011ea48
c0101a5a:	66 c7 05 4a ea 11 c0 	movw   $0x8,0xc011ea4a
c0101a61:	08 00 
c0101a63:	0f b6 05 4c ea 11 c0 	movzbl 0xc011ea4c,%eax
c0101a6a:	24 e0                	and    $0xe0,%al
c0101a6c:	a2 4c ea 11 c0       	mov    %al,0xc011ea4c
c0101a71:	0f b6 05 4c ea 11 c0 	movzbl 0xc011ea4c,%eax
c0101a78:	24 1f                	and    $0x1f,%al
c0101a7a:	a2 4c ea 11 c0       	mov    %al,0xc011ea4c
c0101a7f:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101a86:	24 f0                	and    $0xf0,%al
c0101a88:	0c 0e                	or     $0xe,%al
c0101a8a:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101a8f:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101a96:	24 ef                	and    $0xef,%al
c0101a98:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101a9d:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101aa4:	0c 60                	or     $0x60,%al
c0101aa6:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101aab:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101ab2:	0c 80                	or     $0x80,%al
c0101ab4:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101ab9:	a1 c4 b7 11 c0       	mov    0xc011b7c4,%eax
c0101abe:	c1 e8 10             	shr    $0x10,%eax
c0101ac1:	0f b7 c0             	movzwl %ax,%eax
c0101ac4:	66 a3 4e ea 11 c0    	mov    %ax,0xc011ea4e
c0101aca:	c7 45 f8 60 b5 11 c0 	movl   $0xc011b560,-0x8(%ebp)
    asm volatile("lidt (%0)" ::"r"(pd)
c0101ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ad4:	0f 01 18             	lidtl  (%eax)
}
c0101ad7:	90                   	nop
    lidt(&idt_pd);
}
c0101ad8:	90                   	nop
c0101ad9:	89 ec                	mov    %ebp,%esp
c0101adb:	5d                   	pop    %ebp
c0101adc:	c3                   	ret    

c0101add <trapname>:

static const char *
trapname(int trapno)
{
c0101add:	55                   	push   %ebp
c0101ade:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
c0101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae3:	83 f8 13             	cmp    $0x13,%eax
c0101ae6:	77 0c                	ja     c0101af4 <trapname+0x17>
    {
        return excnames[trapno];
c0101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aeb:	8b 04 85 e0 73 10 c0 	mov    -0x3fef8c20(,%eax,4),%eax
c0101af2:	eb 18                	jmp    c0101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
c0101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101af8:	7e 0d                	jle    c0101b07 <trapname+0x2a>
c0101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101afe:	7f 07                	jg     c0101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
c0101b00:	b8 9f 70 10 c0       	mov    $0xc010709f,%eax
c0101b05:	eb 05                	jmp    c0101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b07:	b8 b2 70 10 c0       	mov    $0xc01070b2,%eax
}
c0101b0c:	5d                   	pop    %ebp
c0101b0d:	c3                   	ret    

c0101b0e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
c0101b0e:	55                   	push   %ebp
c0101b0f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b14:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b18:	83 f8 08             	cmp    $0x8,%eax
c0101b1b:	0f 94 c0             	sete   %al
c0101b1e:	0f b6 c0             	movzbl %al,%eax
}
c0101b21:	5d                   	pop    %ebp
c0101b22:	c3                   	ret    

c0101b23 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
c0101b23:	55                   	push   %ebp
c0101b24:	89 e5                	mov    %esp,%ebp
c0101b26:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b30:	c7 04 24 f3 70 10 c0 	movl   $0xc01070f3,(%esp)
c0101b37:	e8 29 e8 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	89 04 24             	mov    %eax,(%esp)
c0101b42:	e8 8f 01 00 00       	call   c0101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b52:	c7 04 24 04 71 10 c0 	movl   $0xc0107104,(%esp)
c0101b59:	e8 07 e8 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b69:	c7 04 24 17 71 10 c0 	movl   $0xc0107117,(%esp)
c0101b70:	e8 f0 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 2a 71 10 c0 	movl   $0xc010712a,(%esp)
c0101b87:	e8 d9 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b97:	c7 04 24 3d 71 10 c0 	movl   $0xc010713d,(%esp)
c0101b9e:	e8 c2 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba6:	8b 40 30             	mov    0x30(%eax),%eax
c0101ba9:	89 04 24             	mov    %eax,(%esp)
c0101bac:	e8 2c ff ff ff       	call   c0101add <trapname>
c0101bb1:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bb4:	8b 52 30             	mov    0x30(%edx),%edx
c0101bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101bbf:	c7 04 24 50 71 10 c0 	movl   $0xc0107150,(%esp)
c0101bc6:	e8 9a e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 34             	mov    0x34(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 62 71 10 c0 	movl   $0xc0107162,(%esp)
c0101bdc:	e8 84 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 38             	mov    0x38(%eax),%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 71 71 10 c0 	movl   $0xc0107171,(%esp)
c0101bf2:	e8 6e e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c02:	c7 04 24 80 71 10 c0 	movl   $0xc0107180,(%esp)
c0101c09:	e8 57 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c11:	8b 40 40             	mov    0x40(%eax),%eax
c0101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c18:	c7 04 24 93 71 10 c0 	movl   $0xc0107193,(%esp)
c0101c1f:	e8 41 e7 ff ff       	call   c0100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c32:	eb 3d                	jmp    c0101c71 <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
c0101c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c37:	8b 50 40             	mov    0x40(%eax),%edx
c0101c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c3d:	21 d0                	and    %edx,%eax
c0101c3f:	85 c0                	test   %eax,%eax
c0101c41:	74 28                	je     c0101c6b <print_trapframe+0x148>
c0101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c46:	8b 04 85 80 b5 11 c0 	mov    -0x3fee4a80(,%eax,4),%eax
c0101c4d:	85 c0                	test   %eax,%eax
c0101c4f:	74 1a                	je     c0101c6b <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
c0101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c54:	8b 04 85 80 b5 11 c0 	mov    -0x3fee4a80(,%eax,4),%eax
c0101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5f:	c7 04 24 a2 71 10 c0 	movl   $0xc01071a2,(%esp)
c0101c66:	e8 fa e6 ff ff       	call   c0100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c6b:	ff 45 f4             	incl   -0xc(%ebp)
c0101c6e:	d1 65 f0             	shll   -0x10(%ebp)
c0101c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c74:	83 f8 17             	cmp    $0x17,%eax
c0101c77:	76 bb                	jbe    c0101c34 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7c:	8b 40 40             	mov    0x40(%eax),%eax
c0101c7f:	c1 e8 0c             	shr    $0xc,%eax
c0101c82:	83 e0 03             	and    $0x3,%eax
c0101c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c89:	c7 04 24 a6 71 10 c0 	movl   $0xc01071a6,(%esp)
c0101c90:	e8 d0 e6 ff ff       	call   c0100365 <cprintf>

    if (!trap_in_kernel(tf))
c0101c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c98:	89 04 24             	mov    %eax,(%esp)
c0101c9b:	e8 6e fe ff ff       	call   c0101b0e <trap_in_kernel>
c0101ca0:	85 c0                	test   %eax,%eax
c0101ca2:	75 2d                	jne    c0101cd1 <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca7:	8b 40 44             	mov    0x44(%eax),%eax
c0101caa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cae:	c7 04 24 af 71 10 c0 	movl   $0xc01071af,(%esp)
c0101cb5:	e8 ab e6 ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc5:	c7 04 24 be 71 10 c0 	movl   $0xc01071be,(%esp)
c0101ccc:	e8 94 e6 ff ff       	call   c0100365 <cprintf>
    }
}
c0101cd1:	90                   	nop
c0101cd2:	89 ec                	mov    %ebp,%esp
c0101cd4:	5d                   	pop    %ebp
c0101cd5:	c3                   	ret    

c0101cd6 <print_regs>:

void print_regs(struct pushregs *regs)
{
c0101cd6:	55                   	push   %ebp
c0101cd7:	89 e5                	mov    %esp,%ebp
c0101cd9:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdf:	8b 00                	mov    (%eax),%eax
c0101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce5:	c7 04 24 d1 71 10 c0 	movl   $0xc01071d1,(%esp)
c0101cec:	e8 74 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf4:	8b 40 04             	mov    0x4(%eax),%eax
c0101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfb:	c7 04 24 e0 71 10 c0 	movl   $0xc01071e0,(%esp)
c0101d02:	e8 5e e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0a:	8b 40 08             	mov    0x8(%eax),%eax
c0101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d11:	c7 04 24 ef 71 10 c0 	movl   $0xc01071ef,(%esp)
c0101d18:	e8 48 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d20:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d27:	c7 04 24 fe 71 10 c0 	movl   $0xc01071fe,(%esp)
c0101d2e:	e8 32 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d36:	8b 40 10             	mov    0x10(%eax),%eax
c0101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3d:	c7 04 24 0d 72 10 c0 	movl   $0xc010720d,(%esp)
c0101d44:	e8 1c e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4c:	8b 40 14             	mov    0x14(%eax),%eax
c0101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d53:	c7 04 24 1c 72 10 c0 	movl   $0xc010721c,(%esp)
c0101d5a:	e8 06 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d62:	8b 40 18             	mov    0x18(%eax),%eax
c0101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d69:	c7 04 24 2b 72 10 c0 	movl   $0xc010722b,(%esp)
c0101d70:	e8 f0 e5 ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7f:	c7 04 24 3a 72 10 c0 	movl   $0xc010723a,(%esp)
c0101d86:	e8 da e5 ff ff       	call   c0100365 <cprintf>
}
c0101d8b:	90                   	nop
c0101d8c:	89 ec                	mov    %ebp,%esp
c0101d8e:	5d                   	pop    %ebp
c0101d8f:	c3                   	ret    

c0101d90 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
c0101d90:	55                   	push   %ebp
c0101d91:	89 e5                	mov    %esp,%ebp
c0101d93:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
c0101d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d99:	8b 40 30             	mov    0x30(%eax),%eax
c0101d9c:	83 f8 79             	cmp    $0x79,%eax
c0101d9f:	0f 84 1f 01 00 00    	je     c0101ec4 <trap_dispatch+0x134>
c0101da5:	83 f8 79             	cmp    $0x79,%eax
c0101da8:	0f 87 69 01 00 00    	ja     c0101f17 <trap_dispatch+0x187>
c0101dae:	83 f8 78             	cmp    $0x78,%eax
c0101db1:	0f 84 b7 00 00 00    	je     c0101e6e <trap_dispatch+0xde>
c0101db7:	83 f8 78             	cmp    $0x78,%eax
c0101dba:	0f 87 57 01 00 00    	ja     c0101f17 <trap_dispatch+0x187>
c0101dc0:	83 f8 2f             	cmp    $0x2f,%eax
c0101dc3:	0f 87 4e 01 00 00    	ja     c0101f17 <trap_dispatch+0x187>
c0101dc9:	83 f8 2e             	cmp    $0x2e,%eax
c0101dcc:	0f 83 7a 01 00 00    	jae    c0101f4c <trap_dispatch+0x1bc>
c0101dd2:	83 f8 24             	cmp    $0x24,%eax
c0101dd5:	74 45                	je     c0101e1c <trap_dispatch+0x8c>
c0101dd7:	83 f8 24             	cmp    $0x24,%eax
c0101dda:	0f 87 37 01 00 00    	ja     c0101f17 <trap_dispatch+0x187>
c0101de0:	83 f8 20             	cmp    $0x20,%eax
c0101de3:	74 0a                	je     c0101def <trap_dispatch+0x5f>
c0101de5:	83 f8 21             	cmp    $0x21,%eax
c0101de8:	74 5b                	je     c0101e45 <trap_dispatch+0xb5>
c0101dea:	e9 28 01 00 00       	jmp    c0101f17 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101def:	a1 24 e4 11 c0       	mov    0xc011e424,%eax
c0101df4:	40                   	inc    %eax
c0101df5:	a3 24 e4 11 c0       	mov    %eax,0xc011e424
        if (ticks == TICK_NUM)
c0101dfa:	a1 24 e4 11 c0       	mov    0xc011e424,%eax
c0101dff:	83 f8 64             	cmp    $0x64,%eax
c0101e02:	0f 85 47 01 00 00    	jne    c0101f4f <trap_dispatch+0x1bf>
        {
            ticks = 0;
c0101e08:	c7 05 24 e4 11 c0 00 	movl   $0x0,0xc011e424
c0101e0f:	00 00 00 
            print_ticks();
c0101e12:	e8 10 fb ff ff       	call   c0101927 <print_ticks>
        }
        break;
c0101e17:	e9 33 01 00 00       	jmp    c0101f4f <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e1c:	e8 a9 f8 ff ff       	call   c01016ca <cons_getc>
c0101e21:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e24:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e28:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e2c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e34:	c7 04 24 49 72 10 c0 	movl   $0xc0107249,(%esp)
c0101e3b:	e8 25 e5 ff ff       	call   c0100365 <cprintf>
        break;
c0101e40:	e9 11 01 00 00       	jmp    c0101f56 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e45:	e8 80 f8 ff ff       	call   c01016ca <cons_getc>
c0101e4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e5d:	c7 04 24 5b 72 10 c0 	movl   $0xc010725b,(%esp)
c0101e64:	e8 fc e4 ff ff       	call   c0100365 <cprintf>
        break;
c0101e69:	e9 e8 00 00 00       	jmp    c0101f56 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
c0101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e75:	83 f8 1b             	cmp    $0x1b,%eax
c0101e78:	0f 84 d4 00 00 00    	je     c0101f52 <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
c0101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e81:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101e87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101e90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e93:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9a:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
c0101eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaf:	8b 40 40             	mov    0x40(%eax),%eax
c0101eb2:	0d 00 30 00 00       	or     $0x3000,%eax
c0101eb7:	89 c2                	mov    %eax,%edx
c0101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebc:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101ebf:	e9 8e 00 00 00       	jmp    c0101f52 <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
c0101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ecb:	83 f8 08             	cmp    $0x8,%eax
c0101ece:	0f 84 81 00 00 00    	je     c0101f55 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
c0101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed7:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
c0101edd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee0:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee9:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef0:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef7:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efe:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f05:	8b 40 40             	mov    0x40(%eax),%eax
c0101f08:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f0d:	89 c2                	mov    %eax,%edx
c0101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f12:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101f15:	eb 3e                	jmp    c0101f55 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
c0101f17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f1e:	83 e0 03             	and    $0x3,%eax
c0101f21:	85 c0                	test   %eax,%eax
c0101f23:	75 31                	jne    c0101f56 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
c0101f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f28:	89 04 24             	mov    %eax,(%esp)
c0101f2b:	e8 f3 fb ff ff       	call   c0101b23 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f30:	c7 44 24 08 6a 72 10 	movl   $0xc010726a,0x8(%esp)
c0101f37:	c0 
c0101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0101f3f:	00 
c0101f40:	c7 04 24 8e 70 10 c0 	movl   $0xc010708e,(%esp)
c0101f47:	e8 9e ed ff ff       	call   c0100cea <__panic>
        break;
c0101f4c:	90                   	nop
c0101f4d:	eb 07                	jmp    c0101f56 <trap_dispatch+0x1c6>
        break;
c0101f4f:	90                   	nop
c0101f50:	eb 04                	jmp    c0101f56 <trap_dispatch+0x1c6>
        break;
c0101f52:	90                   	nop
c0101f53:	eb 01                	jmp    c0101f56 <trap_dispatch+0x1c6>
        break;
c0101f55:	90                   	nop
        }
    }
}
c0101f56:	90                   	nop
c0101f57:	89 ec                	mov    %ebp,%esp
c0101f59:	5d                   	pop    %ebp
c0101f5a:	c3                   	ret    

c0101f5b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
c0101f5b:	55                   	push   %ebp
c0101f5c:	89 e5                	mov    %esp,%ebp
c0101f5e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f64:	89 04 24             	mov    %eax,(%esp)
c0101f67:	e8 24 fe ff ff       	call   c0101d90 <trap_dispatch>
}
c0101f6c:	90                   	nop
c0101f6d:	89 ec                	mov    %ebp,%esp
c0101f6f:	5d                   	pop    %ebp
c0101f70:	c3                   	ret    

c0101f71 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101f71:	1e                   	push   %ds
    pushl %es
c0101f72:	06                   	push   %es
    pushl %fs
c0101f73:	0f a0                	push   %fs
    pushl %gs
c0101f75:	0f a8                	push   %gs
    pushal
c0101f77:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101f78:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f7d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f7f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f81:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f82:	e8 d4 ff ff ff       	call   c0101f5b <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f87:	5c                   	pop    %esp

c0101f88 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f88:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f89:	0f a9                	pop    %gs
    popl %fs
c0101f8b:	0f a1                	pop    %fs
    popl %es
c0101f8d:	07                   	pop    %es
    popl %ds
c0101f8e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f8f:	83 c4 08             	add    $0x8,%esp
    iret
c0101f92:	cf                   	iret   

c0101f93 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $0
c0101f95:	6a 00                	push   $0x0
  jmp __alltraps
c0101f97:	e9 d5 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101f9c <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $1
c0101f9e:	6a 01                	push   $0x1
  jmp __alltraps
c0101fa0:	e9 cc ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fa5 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $2
c0101fa7:	6a 02                	push   $0x2
  jmp __alltraps
c0101fa9:	e9 c3 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fae <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $3
c0101fb0:	6a 03                	push   $0x3
  jmp __alltraps
c0101fb2:	e9 ba ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fb7 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $4
c0101fb9:	6a 04                	push   $0x4
  jmp __alltraps
c0101fbb:	e9 b1 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fc0 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $5
c0101fc2:	6a 05                	push   $0x5
  jmp __alltraps
c0101fc4:	e9 a8 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fc9 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $6
c0101fcb:	6a 06                	push   $0x6
  jmp __alltraps
c0101fcd:	e9 9f ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fd2 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $7
c0101fd4:	6a 07                	push   $0x7
  jmp __alltraps
c0101fd6:	e9 96 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fdb <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fdb:	6a 08                	push   $0x8
  jmp __alltraps
c0101fdd:	e9 8f ff ff ff       	jmp    c0101f71 <__alltraps>

c0101fe2 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $9
c0101fe4:	6a 09                	push   $0x9
  jmp __alltraps
c0101fe6:	e9 86 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101feb <vector10>:
.globl vector10
vector10:
  pushl $10
c0101feb:	6a 0a                	push   $0xa
  jmp __alltraps
c0101fed:	e9 7f ff ff ff       	jmp    c0101f71 <__alltraps>

c0101ff2 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ff2:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ff4:	e9 78 ff ff ff       	jmp    c0101f71 <__alltraps>

c0101ff9 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ff9:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ffb:	e9 71 ff ff ff       	jmp    c0101f71 <__alltraps>

c0102000 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102000:	6a 0d                	push   $0xd
  jmp __alltraps
c0102002:	e9 6a ff ff ff       	jmp    c0101f71 <__alltraps>

c0102007 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102007:	6a 0e                	push   $0xe
  jmp __alltraps
c0102009:	e9 63 ff ff ff       	jmp    c0101f71 <__alltraps>

c010200e <vector15>:
.globl vector15
vector15:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $15
c0102010:	6a 0f                	push   $0xf
  jmp __alltraps
c0102012:	e9 5a ff ff ff       	jmp    c0101f71 <__alltraps>

c0102017 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $16
c0102019:	6a 10                	push   $0x10
  jmp __alltraps
c010201b:	e9 51 ff ff ff       	jmp    c0101f71 <__alltraps>

c0102020 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102020:	6a 11                	push   $0x11
  jmp __alltraps
c0102022:	e9 4a ff ff ff       	jmp    c0101f71 <__alltraps>

c0102027 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $18
c0102029:	6a 12                	push   $0x12
  jmp __alltraps
c010202b:	e9 41 ff ff ff       	jmp    c0101f71 <__alltraps>

c0102030 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $19
c0102032:	6a 13                	push   $0x13
  jmp __alltraps
c0102034:	e9 38 ff ff ff       	jmp    c0101f71 <__alltraps>

c0102039 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $20
c010203b:	6a 14                	push   $0x14
  jmp __alltraps
c010203d:	e9 2f ff ff ff       	jmp    c0101f71 <__alltraps>

c0102042 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $21
c0102044:	6a 15                	push   $0x15
  jmp __alltraps
c0102046:	e9 26 ff ff ff       	jmp    c0101f71 <__alltraps>

c010204b <vector22>:
.globl vector22
vector22:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $22
c010204d:	6a 16                	push   $0x16
  jmp __alltraps
c010204f:	e9 1d ff ff ff       	jmp    c0101f71 <__alltraps>

c0102054 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $23
c0102056:	6a 17                	push   $0x17
  jmp __alltraps
c0102058:	e9 14 ff ff ff       	jmp    c0101f71 <__alltraps>

c010205d <vector24>:
.globl vector24
vector24:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $24
c010205f:	6a 18                	push   $0x18
  jmp __alltraps
c0102061:	e9 0b ff ff ff       	jmp    c0101f71 <__alltraps>

c0102066 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $25
c0102068:	6a 19                	push   $0x19
  jmp __alltraps
c010206a:	e9 02 ff ff ff       	jmp    c0101f71 <__alltraps>

c010206f <vector26>:
.globl vector26
vector26:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $26
c0102071:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102073:	e9 f9 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102078 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $27
c010207a:	6a 1b                	push   $0x1b
  jmp __alltraps
c010207c:	e9 f0 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102081 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $28
c0102083:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102085:	e9 e7 fe ff ff       	jmp    c0101f71 <__alltraps>

c010208a <vector29>:
.globl vector29
vector29:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $29
c010208c:	6a 1d                	push   $0x1d
  jmp __alltraps
c010208e:	e9 de fe ff ff       	jmp    c0101f71 <__alltraps>

c0102093 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $30
c0102095:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102097:	e9 d5 fe ff ff       	jmp    c0101f71 <__alltraps>

c010209c <vector31>:
.globl vector31
vector31:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $31
c010209e:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020a0:	e9 cc fe ff ff       	jmp    c0101f71 <__alltraps>

c01020a5 <vector32>:
.globl vector32
vector32:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $32
c01020a7:	6a 20                	push   $0x20
  jmp __alltraps
c01020a9:	e9 c3 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020ae <vector33>:
.globl vector33
vector33:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $33
c01020b0:	6a 21                	push   $0x21
  jmp __alltraps
c01020b2:	e9 ba fe ff ff       	jmp    c0101f71 <__alltraps>

c01020b7 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $34
c01020b9:	6a 22                	push   $0x22
  jmp __alltraps
c01020bb:	e9 b1 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020c0 <vector35>:
.globl vector35
vector35:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $35
c01020c2:	6a 23                	push   $0x23
  jmp __alltraps
c01020c4:	e9 a8 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020c9 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $36
c01020cb:	6a 24                	push   $0x24
  jmp __alltraps
c01020cd:	e9 9f fe ff ff       	jmp    c0101f71 <__alltraps>

c01020d2 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $37
c01020d4:	6a 25                	push   $0x25
  jmp __alltraps
c01020d6:	e9 96 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020db <vector38>:
.globl vector38
vector38:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $38
c01020dd:	6a 26                	push   $0x26
  jmp __alltraps
c01020df:	e9 8d fe ff ff       	jmp    c0101f71 <__alltraps>

c01020e4 <vector39>:
.globl vector39
vector39:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $39
c01020e6:	6a 27                	push   $0x27
  jmp __alltraps
c01020e8:	e9 84 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020ed <vector40>:
.globl vector40
vector40:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $40
c01020ef:	6a 28                	push   $0x28
  jmp __alltraps
c01020f1:	e9 7b fe ff ff       	jmp    c0101f71 <__alltraps>

c01020f6 <vector41>:
.globl vector41
vector41:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $41
c01020f8:	6a 29                	push   $0x29
  jmp __alltraps
c01020fa:	e9 72 fe ff ff       	jmp    c0101f71 <__alltraps>

c01020ff <vector42>:
.globl vector42
vector42:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $42
c0102101:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102103:	e9 69 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102108 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $43
c010210a:	6a 2b                	push   $0x2b
  jmp __alltraps
c010210c:	e9 60 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102111 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $44
c0102113:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102115:	e9 57 fe ff ff       	jmp    c0101f71 <__alltraps>

c010211a <vector45>:
.globl vector45
vector45:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $45
c010211c:	6a 2d                	push   $0x2d
  jmp __alltraps
c010211e:	e9 4e fe ff ff       	jmp    c0101f71 <__alltraps>

c0102123 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $46
c0102125:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102127:	e9 45 fe ff ff       	jmp    c0101f71 <__alltraps>

c010212c <vector47>:
.globl vector47
vector47:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $47
c010212e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102130:	e9 3c fe ff ff       	jmp    c0101f71 <__alltraps>

c0102135 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $48
c0102137:	6a 30                	push   $0x30
  jmp __alltraps
c0102139:	e9 33 fe ff ff       	jmp    c0101f71 <__alltraps>

c010213e <vector49>:
.globl vector49
vector49:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $49
c0102140:	6a 31                	push   $0x31
  jmp __alltraps
c0102142:	e9 2a fe ff ff       	jmp    c0101f71 <__alltraps>

c0102147 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $50
c0102149:	6a 32                	push   $0x32
  jmp __alltraps
c010214b:	e9 21 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102150 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $51
c0102152:	6a 33                	push   $0x33
  jmp __alltraps
c0102154:	e9 18 fe ff ff       	jmp    c0101f71 <__alltraps>

c0102159 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $52
c010215b:	6a 34                	push   $0x34
  jmp __alltraps
c010215d:	e9 0f fe ff ff       	jmp    c0101f71 <__alltraps>

c0102162 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $53
c0102164:	6a 35                	push   $0x35
  jmp __alltraps
c0102166:	e9 06 fe ff ff       	jmp    c0101f71 <__alltraps>

c010216b <vector54>:
.globl vector54
vector54:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $54
c010216d:	6a 36                	push   $0x36
  jmp __alltraps
c010216f:	e9 fd fd ff ff       	jmp    c0101f71 <__alltraps>

c0102174 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $55
c0102176:	6a 37                	push   $0x37
  jmp __alltraps
c0102178:	e9 f4 fd ff ff       	jmp    c0101f71 <__alltraps>

c010217d <vector56>:
.globl vector56
vector56:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $56
c010217f:	6a 38                	push   $0x38
  jmp __alltraps
c0102181:	e9 eb fd ff ff       	jmp    c0101f71 <__alltraps>

c0102186 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $57
c0102188:	6a 39                	push   $0x39
  jmp __alltraps
c010218a:	e9 e2 fd ff ff       	jmp    c0101f71 <__alltraps>

c010218f <vector58>:
.globl vector58
vector58:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $58
c0102191:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102193:	e9 d9 fd ff ff       	jmp    c0101f71 <__alltraps>

c0102198 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $59
c010219a:	6a 3b                	push   $0x3b
  jmp __alltraps
c010219c:	e9 d0 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021a1 <vector60>:
.globl vector60
vector60:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $60
c01021a3:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021a5:	e9 c7 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021aa <vector61>:
.globl vector61
vector61:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $61
c01021ac:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021ae:	e9 be fd ff ff       	jmp    c0101f71 <__alltraps>

c01021b3 <vector62>:
.globl vector62
vector62:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $62
c01021b5:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021b7:	e9 b5 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021bc <vector63>:
.globl vector63
vector63:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $63
c01021be:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021c0:	e9 ac fd ff ff       	jmp    c0101f71 <__alltraps>

c01021c5 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $64
c01021c7:	6a 40                	push   $0x40
  jmp __alltraps
c01021c9:	e9 a3 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021ce <vector65>:
.globl vector65
vector65:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $65
c01021d0:	6a 41                	push   $0x41
  jmp __alltraps
c01021d2:	e9 9a fd ff ff       	jmp    c0101f71 <__alltraps>

c01021d7 <vector66>:
.globl vector66
vector66:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $66
c01021d9:	6a 42                	push   $0x42
  jmp __alltraps
c01021db:	e9 91 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021e0 <vector67>:
.globl vector67
vector67:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $67
c01021e2:	6a 43                	push   $0x43
  jmp __alltraps
c01021e4:	e9 88 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021e9 <vector68>:
.globl vector68
vector68:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $68
c01021eb:	6a 44                	push   $0x44
  jmp __alltraps
c01021ed:	e9 7f fd ff ff       	jmp    c0101f71 <__alltraps>

c01021f2 <vector69>:
.globl vector69
vector69:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $69
c01021f4:	6a 45                	push   $0x45
  jmp __alltraps
c01021f6:	e9 76 fd ff ff       	jmp    c0101f71 <__alltraps>

c01021fb <vector70>:
.globl vector70
vector70:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $70
c01021fd:	6a 46                	push   $0x46
  jmp __alltraps
c01021ff:	e9 6d fd ff ff       	jmp    c0101f71 <__alltraps>

c0102204 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $71
c0102206:	6a 47                	push   $0x47
  jmp __alltraps
c0102208:	e9 64 fd ff ff       	jmp    c0101f71 <__alltraps>

c010220d <vector72>:
.globl vector72
vector72:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $72
c010220f:	6a 48                	push   $0x48
  jmp __alltraps
c0102211:	e9 5b fd ff ff       	jmp    c0101f71 <__alltraps>

c0102216 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $73
c0102218:	6a 49                	push   $0x49
  jmp __alltraps
c010221a:	e9 52 fd ff ff       	jmp    c0101f71 <__alltraps>

c010221f <vector74>:
.globl vector74
vector74:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $74
c0102221:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102223:	e9 49 fd ff ff       	jmp    c0101f71 <__alltraps>

c0102228 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $75
c010222a:	6a 4b                	push   $0x4b
  jmp __alltraps
c010222c:	e9 40 fd ff ff       	jmp    c0101f71 <__alltraps>

c0102231 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $76
c0102233:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102235:	e9 37 fd ff ff       	jmp    c0101f71 <__alltraps>

c010223a <vector77>:
.globl vector77
vector77:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $77
c010223c:	6a 4d                	push   $0x4d
  jmp __alltraps
c010223e:	e9 2e fd ff ff       	jmp    c0101f71 <__alltraps>

c0102243 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $78
c0102245:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102247:	e9 25 fd ff ff       	jmp    c0101f71 <__alltraps>

c010224c <vector79>:
.globl vector79
vector79:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $79
c010224e:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102250:	e9 1c fd ff ff       	jmp    c0101f71 <__alltraps>

c0102255 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $80
c0102257:	6a 50                	push   $0x50
  jmp __alltraps
c0102259:	e9 13 fd ff ff       	jmp    c0101f71 <__alltraps>

c010225e <vector81>:
.globl vector81
vector81:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $81
c0102260:	6a 51                	push   $0x51
  jmp __alltraps
c0102262:	e9 0a fd ff ff       	jmp    c0101f71 <__alltraps>

c0102267 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $82
c0102269:	6a 52                	push   $0x52
  jmp __alltraps
c010226b:	e9 01 fd ff ff       	jmp    c0101f71 <__alltraps>

c0102270 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $83
c0102272:	6a 53                	push   $0x53
  jmp __alltraps
c0102274:	e9 f8 fc ff ff       	jmp    c0101f71 <__alltraps>

c0102279 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $84
c010227b:	6a 54                	push   $0x54
  jmp __alltraps
c010227d:	e9 ef fc ff ff       	jmp    c0101f71 <__alltraps>

c0102282 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $85
c0102284:	6a 55                	push   $0x55
  jmp __alltraps
c0102286:	e9 e6 fc ff ff       	jmp    c0101f71 <__alltraps>

c010228b <vector86>:
.globl vector86
vector86:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $86
c010228d:	6a 56                	push   $0x56
  jmp __alltraps
c010228f:	e9 dd fc ff ff       	jmp    c0101f71 <__alltraps>

c0102294 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $87
c0102296:	6a 57                	push   $0x57
  jmp __alltraps
c0102298:	e9 d4 fc ff ff       	jmp    c0101f71 <__alltraps>

c010229d <vector88>:
.globl vector88
vector88:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $88
c010229f:	6a 58                	push   $0x58
  jmp __alltraps
c01022a1:	e9 cb fc ff ff       	jmp    c0101f71 <__alltraps>

c01022a6 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $89
c01022a8:	6a 59                	push   $0x59
  jmp __alltraps
c01022aa:	e9 c2 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022af <vector90>:
.globl vector90
vector90:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $90
c01022b1:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022b3:	e9 b9 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022b8 <vector91>:
.globl vector91
vector91:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $91
c01022ba:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022bc:	e9 b0 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022c1 <vector92>:
.globl vector92
vector92:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $92
c01022c3:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022c5:	e9 a7 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022ca <vector93>:
.globl vector93
vector93:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $93
c01022cc:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022ce:	e9 9e fc ff ff       	jmp    c0101f71 <__alltraps>

c01022d3 <vector94>:
.globl vector94
vector94:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $94
c01022d5:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022d7:	e9 95 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022dc <vector95>:
.globl vector95
vector95:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $95
c01022de:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022e0:	e9 8c fc ff ff       	jmp    c0101f71 <__alltraps>

c01022e5 <vector96>:
.globl vector96
vector96:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $96
c01022e7:	6a 60                	push   $0x60
  jmp __alltraps
c01022e9:	e9 83 fc ff ff       	jmp    c0101f71 <__alltraps>

c01022ee <vector97>:
.globl vector97
vector97:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $97
c01022f0:	6a 61                	push   $0x61
  jmp __alltraps
c01022f2:	e9 7a fc ff ff       	jmp    c0101f71 <__alltraps>

c01022f7 <vector98>:
.globl vector98
vector98:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $98
c01022f9:	6a 62                	push   $0x62
  jmp __alltraps
c01022fb:	e9 71 fc ff ff       	jmp    c0101f71 <__alltraps>

c0102300 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $99
c0102302:	6a 63                	push   $0x63
  jmp __alltraps
c0102304:	e9 68 fc ff ff       	jmp    c0101f71 <__alltraps>

c0102309 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $100
c010230b:	6a 64                	push   $0x64
  jmp __alltraps
c010230d:	e9 5f fc ff ff       	jmp    c0101f71 <__alltraps>

c0102312 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $101
c0102314:	6a 65                	push   $0x65
  jmp __alltraps
c0102316:	e9 56 fc ff ff       	jmp    c0101f71 <__alltraps>

c010231b <vector102>:
.globl vector102
vector102:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $102
c010231d:	6a 66                	push   $0x66
  jmp __alltraps
c010231f:	e9 4d fc ff ff       	jmp    c0101f71 <__alltraps>

c0102324 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $103
c0102326:	6a 67                	push   $0x67
  jmp __alltraps
c0102328:	e9 44 fc ff ff       	jmp    c0101f71 <__alltraps>

c010232d <vector104>:
.globl vector104
vector104:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $104
c010232f:	6a 68                	push   $0x68
  jmp __alltraps
c0102331:	e9 3b fc ff ff       	jmp    c0101f71 <__alltraps>

c0102336 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $105
c0102338:	6a 69                	push   $0x69
  jmp __alltraps
c010233a:	e9 32 fc ff ff       	jmp    c0101f71 <__alltraps>

c010233f <vector106>:
.globl vector106
vector106:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $106
c0102341:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102343:	e9 29 fc ff ff       	jmp    c0101f71 <__alltraps>

c0102348 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $107
c010234a:	6a 6b                	push   $0x6b
  jmp __alltraps
c010234c:	e9 20 fc ff ff       	jmp    c0101f71 <__alltraps>

c0102351 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $108
c0102353:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102355:	e9 17 fc ff ff       	jmp    c0101f71 <__alltraps>

c010235a <vector109>:
.globl vector109
vector109:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $109
c010235c:	6a 6d                	push   $0x6d
  jmp __alltraps
c010235e:	e9 0e fc ff ff       	jmp    c0101f71 <__alltraps>

c0102363 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $110
c0102365:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102367:	e9 05 fc ff ff       	jmp    c0101f71 <__alltraps>

c010236c <vector111>:
.globl vector111
vector111:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $111
c010236e:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102370:	e9 fc fb ff ff       	jmp    c0101f71 <__alltraps>

c0102375 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $112
c0102377:	6a 70                	push   $0x70
  jmp __alltraps
c0102379:	e9 f3 fb ff ff       	jmp    c0101f71 <__alltraps>

c010237e <vector113>:
.globl vector113
vector113:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $113
c0102380:	6a 71                	push   $0x71
  jmp __alltraps
c0102382:	e9 ea fb ff ff       	jmp    c0101f71 <__alltraps>

c0102387 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $114
c0102389:	6a 72                	push   $0x72
  jmp __alltraps
c010238b:	e9 e1 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102390 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $115
c0102392:	6a 73                	push   $0x73
  jmp __alltraps
c0102394:	e9 d8 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102399 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $116
c010239b:	6a 74                	push   $0x74
  jmp __alltraps
c010239d:	e9 cf fb ff ff       	jmp    c0101f71 <__alltraps>

c01023a2 <vector117>:
.globl vector117
vector117:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $117
c01023a4:	6a 75                	push   $0x75
  jmp __alltraps
c01023a6:	e9 c6 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023ab <vector118>:
.globl vector118
vector118:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $118
c01023ad:	6a 76                	push   $0x76
  jmp __alltraps
c01023af:	e9 bd fb ff ff       	jmp    c0101f71 <__alltraps>

c01023b4 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $119
c01023b6:	6a 77                	push   $0x77
  jmp __alltraps
c01023b8:	e9 b4 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023bd <vector120>:
.globl vector120
vector120:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $120
c01023bf:	6a 78                	push   $0x78
  jmp __alltraps
c01023c1:	e9 ab fb ff ff       	jmp    c0101f71 <__alltraps>

c01023c6 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $121
c01023c8:	6a 79                	push   $0x79
  jmp __alltraps
c01023ca:	e9 a2 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023cf <vector122>:
.globl vector122
vector122:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $122
c01023d1:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023d3:	e9 99 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023d8 <vector123>:
.globl vector123
vector123:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $123
c01023da:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023dc:	e9 90 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023e1 <vector124>:
.globl vector124
vector124:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $124
c01023e3:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023e5:	e9 87 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023ea <vector125>:
.globl vector125
vector125:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $125
c01023ec:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023ee:	e9 7e fb ff ff       	jmp    c0101f71 <__alltraps>

c01023f3 <vector126>:
.globl vector126
vector126:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $126
c01023f5:	6a 7e                	push   $0x7e
  jmp __alltraps
c01023f7:	e9 75 fb ff ff       	jmp    c0101f71 <__alltraps>

c01023fc <vector127>:
.globl vector127
vector127:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $127
c01023fe:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102400:	e9 6c fb ff ff       	jmp    c0101f71 <__alltraps>

c0102405 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $128
c0102407:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010240c:	e9 60 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102411 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $129
c0102413:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102418:	e9 54 fb ff ff       	jmp    c0101f71 <__alltraps>

c010241d <vector130>:
.globl vector130
vector130:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $130
c010241f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102424:	e9 48 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102429 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $131
c010242b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102430:	e9 3c fb ff ff       	jmp    c0101f71 <__alltraps>

c0102435 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $132
c0102437:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010243c:	e9 30 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102441 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $133
c0102443:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102448:	e9 24 fb ff ff       	jmp    c0101f71 <__alltraps>

c010244d <vector134>:
.globl vector134
vector134:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $134
c010244f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102454:	e9 18 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102459 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $135
c010245b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102460:	e9 0c fb ff ff       	jmp    c0101f71 <__alltraps>

c0102465 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $136
c0102467:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010246c:	e9 00 fb ff ff       	jmp    c0101f71 <__alltraps>

c0102471 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $137
c0102473:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102478:	e9 f4 fa ff ff       	jmp    c0101f71 <__alltraps>

c010247d <vector138>:
.globl vector138
vector138:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $138
c010247f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102484:	e9 e8 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102489 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $139
c010248b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102490:	e9 dc fa ff ff       	jmp    c0101f71 <__alltraps>

c0102495 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $140
c0102497:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010249c:	e9 d0 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024a1 <vector141>:
.globl vector141
vector141:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $141
c01024a3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024a8:	e9 c4 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024ad <vector142>:
.globl vector142
vector142:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $142
c01024af:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024b4:	e9 b8 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024b9 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $143
c01024bb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024c0:	e9 ac fa ff ff       	jmp    c0101f71 <__alltraps>

c01024c5 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $144
c01024c7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024cc:	e9 a0 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024d1 <vector145>:
.globl vector145
vector145:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $145
c01024d3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024d8:	e9 94 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024dd <vector146>:
.globl vector146
vector146:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $146
c01024df:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024e4:	e9 88 fa ff ff       	jmp    c0101f71 <__alltraps>

c01024e9 <vector147>:
.globl vector147
vector147:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $147
c01024eb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024f0:	e9 7c fa ff ff       	jmp    c0101f71 <__alltraps>

c01024f5 <vector148>:
.globl vector148
vector148:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $148
c01024f7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024fc:	e9 70 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102501 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $149
c0102503:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102508:	e9 64 fa ff ff       	jmp    c0101f71 <__alltraps>

c010250d <vector150>:
.globl vector150
vector150:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $150
c010250f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102514:	e9 58 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102519 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $151
c010251b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102520:	e9 4c fa ff ff       	jmp    c0101f71 <__alltraps>

c0102525 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $152
c0102527:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010252c:	e9 40 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102531 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $153
c0102533:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102538:	e9 34 fa ff ff       	jmp    c0101f71 <__alltraps>

c010253d <vector154>:
.globl vector154
vector154:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $154
c010253f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102544:	e9 28 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102549 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $155
c010254b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102550:	e9 1c fa ff ff       	jmp    c0101f71 <__alltraps>

c0102555 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $156
c0102557:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010255c:	e9 10 fa ff ff       	jmp    c0101f71 <__alltraps>

c0102561 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $157
c0102563:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102568:	e9 04 fa ff ff       	jmp    c0101f71 <__alltraps>

c010256d <vector158>:
.globl vector158
vector158:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $158
c010256f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102574:	e9 f8 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102579 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $159
c010257b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102580:	e9 ec f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102585 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $160
c0102587:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010258c:	e9 e0 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102591 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $161
c0102593:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102598:	e9 d4 f9 ff ff       	jmp    c0101f71 <__alltraps>

c010259d <vector162>:
.globl vector162
vector162:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $162
c010259f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025a4:	e9 c8 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025a9 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $163
c01025ab:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025b0:	e9 bc f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025b5 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $164
c01025b7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025bc:	e9 b0 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025c1 <vector165>:
.globl vector165
vector165:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $165
c01025c3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025c8:	e9 a4 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025cd <vector166>:
.globl vector166
vector166:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $166
c01025cf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025d4:	e9 98 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025d9 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $167
c01025db:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025e0:	e9 8c f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025e5 <vector168>:
.globl vector168
vector168:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $168
c01025e7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025ec:	e9 80 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025f1 <vector169>:
.globl vector169
vector169:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $169
c01025f3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025f8:	e9 74 f9 ff ff       	jmp    c0101f71 <__alltraps>

c01025fd <vector170>:
.globl vector170
vector170:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $170
c01025ff:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102604:	e9 68 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102609 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $171
c010260b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102610:	e9 5c f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102615 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $172
c0102617:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010261c:	e9 50 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102621 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $173
c0102623:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102628:	e9 44 f9 ff ff       	jmp    c0101f71 <__alltraps>

c010262d <vector174>:
.globl vector174
vector174:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $174
c010262f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102634:	e9 38 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102639 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $175
c010263b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102640:	e9 2c f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102645 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $176
c0102647:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010264c:	e9 20 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102651 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $177
c0102653:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102658:	e9 14 f9 ff ff       	jmp    c0101f71 <__alltraps>

c010265d <vector178>:
.globl vector178
vector178:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $178
c010265f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102664:	e9 08 f9 ff ff       	jmp    c0101f71 <__alltraps>

c0102669 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $179
c010266b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102670:	e9 fc f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102675 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $180
c0102677:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010267c:	e9 f0 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102681 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $181
c0102683:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102688:	e9 e4 f8 ff ff       	jmp    c0101f71 <__alltraps>

c010268d <vector182>:
.globl vector182
vector182:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $182
c010268f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102694:	e9 d8 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102699 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $183
c010269b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026a0:	e9 cc f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026a5 <vector184>:
.globl vector184
vector184:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $184
c01026a7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026ac:	e9 c0 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026b1 <vector185>:
.globl vector185
vector185:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $185
c01026b3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026b8:	e9 b4 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026bd <vector186>:
.globl vector186
vector186:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $186
c01026bf:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026c4:	e9 a8 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026c9 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $187
c01026cb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026d0:	e9 9c f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026d5 <vector188>:
.globl vector188
vector188:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $188
c01026d7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026dc:	e9 90 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026e1 <vector189>:
.globl vector189
vector189:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $189
c01026e3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026e8:	e9 84 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026ed <vector190>:
.globl vector190
vector190:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $190
c01026ef:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026f4:	e9 78 f8 ff ff       	jmp    c0101f71 <__alltraps>

c01026f9 <vector191>:
.globl vector191
vector191:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $191
c01026fb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102700:	e9 6c f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102705 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $192
c0102707:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010270c:	e9 60 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102711 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $193
c0102713:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102718:	e9 54 f8 ff ff       	jmp    c0101f71 <__alltraps>

c010271d <vector194>:
.globl vector194
vector194:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $194
c010271f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102724:	e9 48 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102729 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $195
c010272b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102730:	e9 3c f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102735 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $196
c0102737:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010273c:	e9 30 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102741 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $197
c0102743:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102748:	e9 24 f8 ff ff       	jmp    c0101f71 <__alltraps>

c010274d <vector198>:
.globl vector198
vector198:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $198
c010274f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102754:	e9 18 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102759 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $199
c010275b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102760:	e9 0c f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102765 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $200
c0102767:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010276c:	e9 00 f8 ff ff       	jmp    c0101f71 <__alltraps>

c0102771 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $201
c0102773:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102778:	e9 f4 f7 ff ff       	jmp    c0101f71 <__alltraps>

c010277d <vector202>:
.globl vector202
vector202:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $202
c010277f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102784:	e9 e8 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102789 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $203
c010278b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102790:	e9 dc f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102795 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $204
c0102797:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010279c:	e9 d0 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027a1 <vector205>:
.globl vector205
vector205:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $205
c01027a3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027a8:	e9 c4 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027ad <vector206>:
.globl vector206
vector206:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $206
c01027af:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027b4:	e9 b8 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027b9 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $207
c01027bb:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027c0:	e9 ac f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027c5 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $208
c01027c7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027cc:	e9 a0 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027d1 <vector209>:
.globl vector209
vector209:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $209
c01027d3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027d8:	e9 94 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027dd <vector210>:
.globl vector210
vector210:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $210
c01027df:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027e4:	e9 88 f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027e9 <vector211>:
.globl vector211
vector211:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $211
c01027eb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027f0:	e9 7c f7 ff ff       	jmp    c0101f71 <__alltraps>

c01027f5 <vector212>:
.globl vector212
vector212:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $212
c01027f7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027fc:	e9 70 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102801 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $213
c0102803:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102808:	e9 64 f7 ff ff       	jmp    c0101f71 <__alltraps>

c010280d <vector214>:
.globl vector214
vector214:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $214
c010280f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102814:	e9 58 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102819 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $215
c010281b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102820:	e9 4c f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102825 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $216
c0102827:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010282c:	e9 40 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102831 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $217
c0102833:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102838:	e9 34 f7 ff ff       	jmp    c0101f71 <__alltraps>

c010283d <vector218>:
.globl vector218
vector218:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $218
c010283f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102844:	e9 28 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102849 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $219
c010284b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102850:	e9 1c f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102855 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $220
c0102857:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010285c:	e9 10 f7 ff ff       	jmp    c0101f71 <__alltraps>

c0102861 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $221
c0102863:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102868:	e9 04 f7 ff ff       	jmp    c0101f71 <__alltraps>

c010286d <vector222>:
.globl vector222
vector222:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $222
c010286f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102874:	e9 f8 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102879 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $223
c010287b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102880:	e9 ec f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102885 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $224
c0102887:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010288c:	e9 e0 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102891 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $225
c0102893:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102898:	e9 d4 f6 ff ff       	jmp    c0101f71 <__alltraps>

c010289d <vector226>:
.globl vector226
vector226:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $226
c010289f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028a4:	e9 c8 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028a9 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $227
c01028ab:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028b0:	e9 bc f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028b5 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $228
c01028b7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028bc:	e9 b0 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028c1 <vector229>:
.globl vector229
vector229:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $229
c01028c3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028c8:	e9 a4 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028cd <vector230>:
.globl vector230
vector230:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $230
c01028cf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028d4:	e9 98 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028d9 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $231
c01028db:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028e0:	e9 8c f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028e5 <vector232>:
.globl vector232
vector232:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $232
c01028e7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028ec:	e9 80 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028f1 <vector233>:
.globl vector233
vector233:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $233
c01028f3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028f8:	e9 74 f6 ff ff       	jmp    c0101f71 <__alltraps>

c01028fd <vector234>:
.globl vector234
vector234:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $234
c01028ff:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102904:	e9 68 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102909 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $235
c010290b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102910:	e9 5c f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102915 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $236
c0102917:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010291c:	e9 50 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102921 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $237
c0102923:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102928:	e9 44 f6 ff ff       	jmp    c0101f71 <__alltraps>

c010292d <vector238>:
.globl vector238
vector238:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $238
c010292f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102934:	e9 38 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102939 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $239
c010293b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102940:	e9 2c f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102945 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $240
c0102947:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010294c:	e9 20 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102951 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $241
c0102953:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102958:	e9 14 f6 ff ff       	jmp    c0101f71 <__alltraps>

c010295d <vector242>:
.globl vector242
vector242:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $242
c010295f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102964:	e9 08 f6 ff ff       	jmp    c0101f71 <__alltraps>

c0102969 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $243
c010296b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102970:	e9 fc f5 ff ff       	jmp    c0101f71 <__alltraps>

c0102975 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $244
c0102977:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010297c:	e9 f0 f5 ff ff       	jmp    c0101f71 <__alltraps>

c0102981 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $245
c0102983:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102988:	e9 e4 f5 ff ff       	jmp    c0101f71 <__alltraps>

c010298d <vector246>:
.globl vector246
vector246:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $246
c010298f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102994:	e9 d8 f5 ff ff       	jmp    c0101f71 <__alltraps>

c0102999 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $247
c010299b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029a0:	e9 cc f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029a5 <vector248>:
.globl vector248
vector248:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $248
c01029a7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029ac:	e9 c0 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029b1 <vector249>:
.globl vector249
vector249:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $249
c01029b3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029b8:	e9 b4 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029bd <vector250>:
.globl vector250
vector250:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $250
c01029bf:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029c4:	e9 a8 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029c9 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $251
c01029cb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029d0:	e9 9c f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029d5 <vector252>:
.globl vector252
vector252:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $252
c01029d7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029dc:	e9 90 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029e1 <vector253>:
.globl vector253
vector253:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $253
c01029e3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029e8:	e9 84 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029ed <vector254>:
.globl vector254
vector254:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $254
c01029ef:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029f4:	e9 78 f5 ff ff       	jmp    c0101f71 <__alltraps>

c01029f9 <vector255>:
.globl vector255
vector255:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $255
c01029fb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a00:	e9 6c f5 ff ff       	jmp    c0101f71 <__alltraps>

c0102a05 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a05:	55                   	push   %ebp
c0102a06:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a08:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c0102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a11:	29 d0                	sub    %edx,%eax
c0102a13:	c1 f8 02             	sar    $0x2,%eax
c0102a16:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a1c:	5d                   	pop    %ebp
c0102a1d:	c3                   	ret    

c0102a1e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a1e:	55                   	push   %ebp
c0102a1f:	89 e5                	mov    %esp,%ebp
c0102a21:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a27:	89 04 24             	mov    %eax,(%esp)
c0102a2a:	e8 d6 ff ff ff       	call   c0102a05 <page2ppn>
c0102a2f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a32:	89 ec                	mov    %ebp,%esp
c0102a34:	5d                   	pop    %ebp
c0102a35:	c3                   	ret    

c0102a36 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0102a36:	55                   	push   %ebp
c0102a37:	89 e5                	mov    %esp,%ebp
c0102a39:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3f:	89 04 24             	mov    %eax,(%esp)
c0102a42:	e8 d7 ff ff ff       	call   c0102a1e <page2pa>
c0102a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a4d:	c1 e8 0c             	shr    $0xc,%eax
c0102a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a53:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0102a58:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a5b:	72 23                	jb     c0102a80 <page2kva+0x4a>
c0102a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a60:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a64:	c7 44 24 08 30 74 10 	movl   $0xc0107430,0x8(%esp)
c0102a6b:	c0 
c0102a6c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a73:	00 
c0102a74:	c7 04 24 53 74 10 c0 	movl   $0xc0107453,(%esp)
c0102a7b:	e8 6a e2 ff ff       	call   c0100cea <__panic>
c0102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a83:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a88:	89 ec                	mov    %ebp,%esp
c0102a8a:	5d                   	pop    %ebp
c0102a8b:	c3                   	ret    

c0102a8c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102a8c:	55                   	push   %ebp
c0102a8d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a92:	8b 00                	mov    (%eax),%eax
}
c0102a94:	5d                   	pop    %ebp
c0102a95:	c3                   	ret    

c0102a96 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a96:	55                   	push   %ebp
c0102a97:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a9f:	89 10                	mov    %edx,(%eax)
}
c0102aa1:	90                   	nop
c0102aa2:	5d                   	pop    %ebp
c0102aa3:	c3                   	ret    

c0102aa4 <get_proper_size>:

#define IS_POWER_OF_2(x) (!((x) & ((x)-1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int get_proper_size(int size)
{
c0102aa4:	55                   	push   %ebp
c0102aa5:	89 e5                	mov    %esp,%ebp
c0102aa7:	83 ec 10             	sub    $0x10,%esp
    int n = 0, tmp = size;
c0102aaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (tmp >>= 1)
c0102ab7:	eb 03                	jmp    c0102abc <get_proper_size+0x18>
    {
        n++;
c0102ab9:	ff 45 fc             	incl   -0x4(%ebp)
    while (tmp >>= 1)
c0102abc:	d1 7d f8             	sarl   -0x8(%ebp)
c0102abf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102ac3:	75 f4                	jne    c0102ab9 <get_proper_size+0x15>
    }
    tmp = (size >> n) << n;
c0102ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ac8:	8b 55 08             	mov    0x8(%ebp),%edx
c0102acb:	88 c1                	mov    %al,%cl
c0102acd:	d3 fa                	sar    %cl,%edx
c0102acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ad2:	88 c1                	mov    %al,%cl
c0102ad4:	d3 e2                	shl    %cl,%edx
c0102ad6:	89 d0                	mov    %edx,%eax
c0102ad8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    n += ((size - tmp) != 0);
c0102adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ade:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102ae1:	0f 95 c0             	setne  %al
c0102ae4:	0f b6 c0             	movzbl %al,%eax
c0102ae7:	01 45 fc             	add    %eax,-0x4(%ebp)
    return n;
c0102aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102aed:	89 ec                	mov    %ebp,%esp
c0102aef:	5d                   	pop    %ebp
c0102af0:	c3                   	ret    

c0102af1 <buddy_init>:

int free_page_num, manager_size;

static void
buddy_init(void)
{
c0102af1:	55                   	push   %ebp
c0102af2:	89 e5                	mov    %esp,%ebp
    free_page_num = 0;
c0102af4:	c7 05 88 ee 11 c0 00 	movl   $0x0,0xc011ee88
c0102afb:	00 00 00 
}
c0102afe:	90                   	nop
c0102aff:	5d                   	pop    %ebp
c0102b00:	c3                   	ret    

c0102b01 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n)
{
c0102b01:	55                   	push   %ebp
c0102b02:	89 e5                	mov    %esp,%ebp
c0102b04:	83 ec 48             	sub    $0x48,%esp
    struct Page *p;
    for (p = base; p != base + n; p++)
c0102b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b0d:	e9 97 00 00 00       	jmp    c0102ba9 <buddy_init_memmap+0xa8>
    {
        assert(PageReserved(p));
c0102b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b15:	83 c0 04             	add    $0x4,%eax
c0102b18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102b1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * */
static inline bool
test_bit(int nr, volatile void *addr)
{
    int oldbit;
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102b28:	0f a3 10             	bt     %edx,(%eax)
c0102b2b:	19 c0                	sbb    %eax,%eax
c0102b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
                 : "=r"(oldbit)
                 : "m"(*(volatile long *)addr), "Ir"(nr));
    return oldbit != 0;
c0102b30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102b34:	0f 95 c0             	setne  %al
c0102b37:	0f b6 c0             	movzbl %al,%eax
c0102b3a:	85 c0                	test   %eax,%eax
c0102b3c:	75 24                	jne    c0102b62 <buddy_init_memmap+0x61>
c0102b3e:	c7 44 24 0c 61 74 10 	movl   $0xc0107461,0xc(%esp)
c0102b45:	c0 
c0102b46:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0102b4d:	c0 
c0102b4e:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
c0102b55:	00 
c0102b56:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0102b5d:	e8 88 e1 ff ff       	call   c0100cea <__panic>
        p->flags = p->property = 0;
c0102b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b6f:	8b 50 08             	mov    0x8(%eax),%edx
c0102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b75:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102b7f:	00 
c0102b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b83:	89 04 24             	mov    %eax,(%esp)
c0102b86:	e8 0b ff ff ff       	call   c0102a96 <set_page_ref>
        SetPageProperty(p);
c0102b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b8e:	83 c0 04             	add    $0x4,%eax
c0102b91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102b98:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btsl %1, %0"
c0102b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ba1:	0f ab 10             	bts    %edx,(%eax)
}
c0102ba4:	90                   	nop
    for (p = base; p != base + n; p++)
c0102ba5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bac:	89 d0                	mov    %edx,%eax
c0102bae:	c1 e0 02             	shl    $0x2,%eax
c0102bb1:	01 d0                	add    %edx,%eax
c0102bb3:	c1 e0 02             	shl    $0x2,%eax
c0102bb6:	89 c2                	mov    %eax,%edx
c0102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbb:	01 d0                	add    %edx,%eax
c0102bbd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102bc0:	0f 85 4c ff ff ff    	jne    c0102b12 <buddy_init_memmap+0x11>
    }
    manager_size = 2 * (1 << get_proper_size(n));
c0102bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bc9:	89 04 24             	mov    %eax,(%esp)
c0102bcc:	e8 d3 fe ff ff       	call   c0102aa4 <get_proper_size>
c0102bd1:	ba 02 00 00 00       	mov    $0x2,%edx
c0102bd6:	88 c1                	mov    %al,%cl
c0102bd8:	d3 e2                	shl    %cl,%edx
c0102bda:	89 d0                	mov    %edx,%eax
c0102bdc:	a3 8c ee 11 c0       	mov    %eax,0xc011ee8c
    // 获取 buddy_manager 的起始地址 预留base最开始的部分给 buddy_manager
    buddy_manager = (unsigned *)page2kva(base);
c0102be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be4:	89 04 24             	mov    %eax,(%esp)
c0102be7:	e8 4a fe ff ff       	call   c0102a36 <page2kva>
c0102bec:	a3 80 ee 11 c0       	mov    %eax,0xc011ee80
    base += 4 * manager_size / 4096;
c0102bf1:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102bf6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0102bfc:	85 c0                	test   %eax,%eax
c0102bfe:	0f 48 c2             	cmovs  %edx,%eax
c0102c01:	c1 f8 0a             	sar    $0xa,%eax
c0102c04:	89 c2                	mov    %eax,%edx
c0102c06:	89 d0                	mov    %edx,%eax
c0102c08:	c1 e0 02             	shl    $0x2,%eax
c0102c0b:	01 d0                	add    %edx,%eax
c0102c0d:	c1 e0 02             	shl    $0x2,%eax
c0102c10:	01 45 08             	add    %eax,0x8(%ebp)
    // page_base 用来在后续申请和释放内存的时候提供可用内存空间的起始地址
    page_base = base;
c0102c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c16:	a3 84 ee 11 c0       	mov    %eax,0xc011ee84
    // 剩余可用页数
    free_page_num = n - 4 * manager_size / 4096;
c0102c1b:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102c20:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0102c26:	85 c0                	test   %eax,%eax
c0102c28:	0f 48 c2             	cmovs  %edx,%eax
c0102c2b:	c1 f8 0a             	sar    $0xa,%eax
c0102c2e:	89 c2                	mov    %eax,%edx
c0102c30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c33:	29 d0                	sub    %edx,%eax
c0102c35:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    unsigned i = 1;
c0102c3a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    unsigned node_size = manager_size / 2;
c0102c41:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102c46:	89 c2                	mov    %eax,%edx
c0102c48:	c1 ea 1f             	shr    $0x1f,%edx
c0102c4b:	01 d0                	add    %edx,%eax
c0102c4d:	d1 f8                	sar    %eax
c0102c4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; i < manager_size; i++)
c0102c52:	eb 29                	jmp    c0102c7d <buddy_init_memmap+0x17c>
    {
        buddy_manager[i] = node_size;
c0102c54:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c5d:	c1 e0 02             	shl    $0x2,%eax
c0102c60:	01 c2                	add    %eax,%edx
c0102c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c65:	89 02                	mov    %eax,(%edx)
        if (IS_POWER_OF_2(i + 1))
c0102c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c6a:	40                   	inc    %eax
c0102c6b:	23 45 f0             	and    -0x10(%ebp),%eax
c0102c6e:	85 c0                	test   %eax,%eax
c0102c70:	75 08                	jne    c0102c7a <buddy_init_memmap+0x179>
        {
            node_size /= 2;
c0102c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c75:	d1 e8                	shr    %eax
c0102c77:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; i < manager_size; i++)
c0102c7a:	ff 45 f0             	incl   -0x10(%ebp)
c0102c7d:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102c82:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102c85:	72 cd                	jb     c0102c54 <buddy_init_memmap+0x153>
        }
    }
    base->property = free_page_num;
c0102c87:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102c8c:	89 c2                	mov    %eax,%edx
c0102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c91:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c97:	83 c0 04             	add    $0x4,%eax
c0102c9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102ca1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile("btsl %1, %0"
c0102ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102caa:	0f ab 10             	bts    %edx,(%eax)
}
c0102cad:	90                   	nop
}
c0102cae:	90                   	nop
c0102caf:	89 ec                	mov    %ebp,%esp
c0102cb1:	5d                   	pop    %ebp
c0102cb2:	c3                   	ret    

c0102cb3 <buddy_alloc>:

int buddy_alloc(int size)
{
c0102cb3:	55                   	push   %ebp
c0102cb4:	89 e5                	mov    %esp,%ebp
c0102cb6:	83 ec 28             	sub    $0x28,%esp
c0102cb9:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    unsigned index = 1;
c0102cbc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    unsigned offset = 0;
c0102cc3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    unsigned node_size;
    // 将size向上取整为2的幂
    if (size <= 0)
c0102cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102cce:	7f 09                	jg     c0102cd9 <buddy_alloc+0x26>
        size = 1;
c0102cd0:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
c0102cd7:	eb 24                	jmp    c0102cfd <buddy_alloc+0x4a>
    else if (!IS_POWER_OF_2(size))
c0102cd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdc:	48                   	dec    %eax
c0102cdd:	23 45 08             	and    0x8(%ebp),%eax
c0102ce0:	85 c0                	test   %eax,%eax
c0102ce2:	74 19                	je     c0102cfd <buddy_alloc+0x4a>
        size = 1 << get_proper_size(size);
c0102ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce7:	89 04 24             	mov    %eax,(%esp)
c0102cea:	e8 b5 fd ff ff       	call   c0102aa4 <get_proper_size>
c0102cef:	ba 01 00 00 00       	mov    $0x1,%edx
c0102cf4:	88 c1                	mov    %al,%cl
c0102cf6:	d3 e2                	shl    %cl,%edx
c0102cf8:	89 d0                	mov    %edx,%eax
c0102cfa:	89 45 08             	mov    %eax,0x8(%ebp)
    if (buddy_manager[index] < size)
c0102cfd:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d06:	c1 e0 02             	shl    $0x2,%eax
c0102d09:	01 d0                	add    %edx,%eax
c0102d0b:	8b 10                	mov    (%eax),%edx
c0102d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d10:	39 c2                	cmp    %eax,%edx
c0102d12:	73 0a                	jae    c0102d1e <buddy_alloc+0x6b>
        return -1;
c0102d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102d19:	e9 e1 00 00 00       	jmp    c0102dff <buddy_alloc+0x14c>
    // 从根节点往下深度遍历，找到恰好等于size的块
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
c0102d1e:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102d23:	89 c2                	mov    %eax,%edx
c0102d25:	c1 ea 1f             	shr    $0x1f,%edx
c0102d28:	01 d0                	add    %edx,%eax
c0102d2a:	d1 f8                	sar    %eax
c0102d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d2f:	eb 2d                	jmp    c0102d5e <buddy_alloc+0xab>
    {
        if (buddy_manager[LEFT_LEAF(index)] >= size)
c0102d31:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d3a:	c1 e0 03             	shl    $0x3,%eax
c0102d3d:	01 d0                	add    %edx,%eax
c0102d3f:	8b 10                	mov    (%eax),%edx
c0102d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d44:	39 c2                	cmp    %eax,%edx
c0102d46:	72 05                	jb     c0102d4d <buddy_alloc+0x9a>
            index = LEFT_LEAF(index);
c0102d48:	d1 65 f4             	shll   -0xc(%ebp)
c0102d4b:	eb 09                	jmp    c0102d56 <buddy_alloc+0xa3>
        else
            index = RIGHT_LEAF(index);
c0102d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d50:	01 c0                	add    %eax,%eax
c0102d52:	40                   	inc    %eax
c0102d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
c0102d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d59:	d1 e8                	shr    %eax
c0102d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d61:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102d64:	75 cb                	jne    c0102d31 <buddy_alloc+0x7e>
    }
    buddy_manager[index] = 0;
c0102d66:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6f:	c1 e0 02             	shl    $0x2,%eax
c0102d72:	01 d0                	add    %edx,%eax
c0102d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    offset = (index)*node_size - manager_size / 2;
c0102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7d:	0f af 45 f0          	imul   -0x10(%ebp),%eax
c0102d81:	89 c2                	mov    %eax,%edx
c0102d83:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102d88:	89 c1                	mov    %eax,%ecx
c0102d8a:	c1 e9 1f             	shr    $0x1f,%ecx
c0102d8d:	01 c8                	add    %ecx,%eax
c0102d8f:	d1 f8                	sar    %eax
c0102d91:	89 c1                	mov    %eax,%ecx
c0102d93:	89 d0                	mov    %edx,%eax
c0102d95:	29 c8                	sub    %ecx,%eax
c0102d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf(" index:%u offset:%u ", index, offset);
c0102d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102da8:	c7 04 24 9a 74 10 c0 	movl   $0xc010749a,(%esp)
c0102daf:	e8 b1 d5 ff ff       	call   c0100365 <cprintf>
    // 向上回溯至根节点，修改沿途节点的大小
    while (index > 1)
c0102db4:	eb 40                	jmp    c0102df6 <buddy_alloc+0x143>
    {
        index = PARENT(index);
c0102db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db9:	d1 e8                	shr    %eax
c0102dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        buddy_manager[index] = MAX(buddy_manager[LEFT_LEAF(index)], buddy_manager[RIGHT_LEAF(index)]);
c0102dbe:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc7:	c1 e0 03             	shl    $0x3,%eax
c0102dca:	83 c0 04             	add    $0x4,%eax
c0102dcd:	01 d0                	add    %edx,%eax
c0102dcf:	8b 10                	mov    (%eax),%edx
c0102dd1:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c0102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dda:	c1 e0 03             	shl    $0x3,%eax
c0102ddd:	01 c8                	add    %ecx,%eax
c0102ddf:	8b 00                	mov    (%eax),%eax
c0102de1:	8b 1d 80 ee 11 c0    	mov    0xc011ee80,%ebx
c0102de7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0102dea:	c1 e1 02             	shl    $0x2,%ecx
c0102ded:	01 d9                	add    %ebx,%ecx
c0102def:	39 c2                	cmp    %eax,%edx
c0102df1:	0f 43 c2             	cmovae %edx,%eax
c0102df4:	89 01                	mov    %eax,(%ecx)
    while (index > 1)
c0102df6:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
c0102dfa:	77 ba                	ja     c0102db6 <buddy_alloc+0x103>
    }
    return offset;
c0102dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
c0102dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102e02:	89 ec                	mov    %ebp,%esp
c0102e04:	5d                   	pop    %ebp
c0102e05:	c3                   	ret    

c0102e06 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n)
{
c0102e06:	55                   	push   %ebp
c0102e07:	89 e5                	mov    %esp,%ebp
c0102e09:	83 ec 38             	sub    $0x38,%esp
    cprintf("alloc %u pages", n);
c0102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e13:	c7 04 24 af 74 10 c0 	movl   $0xc01074af,(%esp)
c0102e1a:	e8 46 d5 ff ff       	call   c0100365 <cprintf>
    assert(n > 0);
c0102e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102e23:	75 24                	jne    c0102e49 <buddy_alloc_pages+0x43>
c0102e25:	c7 44 24 0c be 74 10 	movl   $0xc01074be,0xc(%esp)
c0102e2c:	c0 
c0102e2d:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0102e34:	c0 
c0102e35:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0102e3c:	00 
c0102e3d:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0102e44:	e8 a1 de ff ff       	call   c0100cea <__panic>
    if (n > free_page_num)
c0102e49:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102e4e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e51:	76 0a                	jbe    c0102e5d <buddy_alloc_pages+0x57>
        return NULL;
c0102e53:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e58:	e9 a3 00 00 00       	jmp    c0102f00 <buddy_alloc_pages+0xfa>
    // 获取分配的页在内存中的起始地址
    int offset = buddy_alloc(n);
c0102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e60:	89 04 24             	mov    %eax,(%esp)
c0102e63:	e8 4b fe ff ff       	call   c0102cb3 <buddy_alloc>
c0102e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *base = page_base + offset;
c0102e6b:	8b 0d 84 ee 11 c0    	mov    0xc011ee84,%ecx
c0102e71:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102e74:	89 d0                	mov    %edx,%eax
c0102e76:	c1 e0 02             	shl    $0x2,%eax
c0102e79:	01 d0                	add    %edx,%eax
c0102e7b:	c1 e0 02             	shl    $0x2,%eax
c0102e7e:	01 c8                	add    %ecx,%eax
c0102e80:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct Page *page;
    // 将n向上取整，因为有round_n个块被取出
    int round_n = 1 << get_proper_size(n);
c0102e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e86:	89 04 24             	mov    %eax,(%esp)
c0102e89:	e8 16 fc ff ff       	call   c0102aa4 <get_proper_size>
c0102e8e:	ba 01 00 00 00       	mov    $0x1,%edx
c0102e93:	88 c1                	mov    %al,%cl
c0102e95:	d3 e2                	shl    %cl,%edx
c0102e97:	89 d0                	mov    %edx,%eax
c0102e99:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (page = base; page != base + round_n; page++)
c0102e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ea2:	eb 1e                	jmp    c0102ec2 <buddy_alloc_pages+0xbc>
    {
        ClearPageProperty(page);
c0102ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea7:	83 c0 04             	add    $0x4,%eax
c0102eaa:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102eb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile("btrl %1, %0"
c0102eb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102eb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102eba:	0f b3 10             	btr    %edx,(%eax)
}
c0102ebd:	90                   	nop
    for (page = base; page != base + round_n; page++)
c0102ebe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ec2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102ec5:	89 d0                	mov    %edx,%eax
c0102ec7:	c1 e0 02             	shl    $0x2,%eax
c0102eca:	01 d0                	add    %edx,%eax
c0102ecc:	c1 e0 02             	shl    $0x2,%eax
c0102ecf:	89 c2                	mov    %eax,%edx
c0102ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ed4:	01 d0                	add    %edx,%eax
c0102ed6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ed9:	75 c9                	jne    c0102ea4 <buddy_alloc_pages+0x9e>
    }
    free_page_num -= round_n;
c0102edb:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102ee0:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0102ee3:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    base->property = n;
c0102ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102eeb:	8b 55 08             	mov    0x8(%ebp),%edx
c0102eee:	89 50 08             	mov    %edx,0x8(%eax)
    cprintf("finish!\n");
c0102ef1:	c7 04 24 c4 74 10 c0 	movl   $0xc01074c4,(%esp)
c0102ef8:	e8 68 d4 ff ff       	call   c0100365 <cprintf>
    return base;
c0102efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
c0102f00:	89 ec                	mov    %ebp,%esp
c0102f02:	5d                   	pop    %ebp
c0102f03:	c3                   	ret    

c0102f04 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n)
{
c0102f04:	55                   	push   %ebp
c0102f05:	89 e5                	mov    %esp,%ebp
c0102f07:	83 ec 58             	sub    $0x58,%esp
    cprintf("free  %u pages", n);
c0102f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102f11:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102f18:	e8 48 d4 ff ff       	call   c0100365 <cprintf>
    assert(n > 0);
c0102f1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102f21:	75 24                	jne    c0102f47 <buddy_free_pages+0x43>
c0102f23:	c7 44 24 0c be 74 10 	movl   $0xc01074be,0xc(%esp)
c0102f2a:	c0 
c0102f2b:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0102f32:	c0 
c0102f33:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0102f3a:	00 
c0102f3b:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0102f42:	e8 a3 dd ff ff       	call   c0100cea <__panic>
    n = 1 << get_proper_size(n);
c0102f47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f4a:	89 04 24             	mov    %eax,(%esp)
c0102f4d:	e8 52 fb ff ff       	call   c0102aa4 <get_proper_size>
c0102f52:	ba 01 00 00 00       	mov    $0x1,%edx
c0102f57:	88 c1                	mov    %al,%cl
c0102f59:	d3 e2                	shl    %cl,%edx
c0102f5b:	89 d0                	mov    %edx,%eax
c0102f5d:	89 45 0c             	mov    %eax,0xc(%ebp)
    assert(!PageReserved(base));
c0102f60:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f63:	83 c0 04             	add    $0x4,%eax
c0102f66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102f70:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102f73:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f76:	0f a3 10             	bt     %edx,(%eax)
c0102f79:	19 c0                	sbb    %eax,%eax
c0102f7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102f7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102f82:	0f 95 c0             	setne  %al
c0102f85:	0f b6 c0             	movzbl %al,%eax
c0102f88:	85 c0                	test   %eax,%eax
c0102f8a:	74 24                	je     c0102fb0 <buddy_free_pages+0xac>
c0102f8c:	c7 44 24 0c dc 74 10 	movl   $0xc01074dc,0xc(%esp)
c0102f93:	c0 
c0102f94:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0102f9b:	c0 
c0102f9c:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0102fa3:	00 
c0102fa4:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0102fab:	e8 3a dd ff ff       	call   c0100cea <__panic>
    for (struct Page *p = base; p < base + n; p++)
c0102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fb6:	e9 93 00 00 00       	jmp    c010304e <buddy_free_pages+0x14a>
    {
        assert(!PageReserved(p) && !PageProperty(p)); 
c0102fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fbe:	83 c0 04             	add    $0x4,%eax
c0102fc1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c0102fc8:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102fcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102fce:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102fd1:	0f a3 10             	bt     %edx,(%eax)
c0102fd4:	19 c0                	sbb    %eax,%eax
c0102fd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0102fd9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0102fdd:	0f 95 c0             	setne  %al
c0102fe0:	0f b6 c0             	movzbl %al,%eax
c0102fe3:	85 c0                	test   %eax,%eax
c0102fe5:	75 2c                	jne    c0103013 <buddy_free_pages+0x10f>
c0102fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fea:	83 c0 04             	add    $0x4,%eax
c0102fed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102ff4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102ff7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ffa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ffd:	0f a3 10             	bt     %edx,(%eax)
c0103000:	19 c0                	sbb    %eax,%eax
c0103002:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0103005:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103009:	0f 95 c0             	setne  %al
c010300c:	0f b6 c0             	movzbl %al,%eax
c010300f:	85 c0                	test   %eax,%eax
c0103011:	74 24                	je     c0103037 <buddy_free_pages+0x133>
c0103013:	c7 44 24 0c f0 74 10 	movl   $0xc01074f0,0xc(%esp)
c010301a:	c0 
c010301b:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103022:	c0 
c0103023:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c010302a:	00 
c010302b:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103032:	e8 b3 dc ff ff       	call   c0100cea <__panic>
        set_page_ref(p, 0);
c0103037:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010303e:	00 
c010303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103042:	89 04 24             	mov    %eax,(%esp)
c0103045:	e8 4c fa ff ff       	call   c0102a96 <set_page_ref>
    for (struct Page *p = base; p < base + n; p++)
c010304a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010304e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103051:	89 d0                	mov    %edx,%eax
c0103053:	c1 e0 02             	shl    $0x2,%eax
c0103056:	01 d0                	add    %edx,%eax
c0103058:	c1 e0 02             	shl    $0x2,%eax
c010305b:	89 c2                	mov    %eax,%edx
c010305d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103060:	01 d0                	add    %edx,%eax
c0103062:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103065:	0f 82 50 ff ff ff    	jb     c0102fbb <buddy_free_pages+0xb7>
    }
    // 将buddy中的对应节点释放
    unsigned offset = base - page_base;
c010306b:	8b 15 84 ee 11 c0    	mov    0xc011ee84,%edx
c0103071:	8b 45 08             	mov    0x8(%ebp),%eax
c0103074:	29 d0                	sub    %edx,%eax
c0103076:	c1 f8 02             	sar    $0x2,%eax
c0103079:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c010307f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    unsigned index = manager_size / 2 + offset;
c0103082:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0103087:	89 c2                	mov    %eax,%edx
c0103089:	c1 ea 1f             	shr    $0x1f,%edx
c010308c:	01 d0                	add    %edx,%eax
c010308e:	d1 f8                	sar    %eax
c0103090:	89 c2                	mov    %eax,%edx
c0103092:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103095:	01 d0                	add    %edx,%eax
c0103097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned node_size = 1;
c010309a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    while (node_size != n)
c01030a1:	eb 35                	jmp    c01030d8 <buddy_free_pages+0x1d4>
    {
        index = PARENT(index);
c01030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030a6:	d1 e8                	shr    %eax
c01030a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
c01030ab:	d1 65 ec             	shll   -0x14(%ebp)
        assert(index);
c01030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030b2:	75 24                	jne    c01030d8 <buddy_free_pages+0x1d4>
c01030b4:	c7 44 24 0c 15 75 10 	movl   $0xc0107515,0xc(%esp)
c01030bb:	c0 
c01030bc:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c01030c3:	c0 
c01030c4:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01030cb:	00 
c01030cc:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c01030d3:	e8 12 dc ff ff       	call   c0100cea <__panic>
    while (node_size != n)
c01030d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030db:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01030de:	75 c3                	jne    c01030a3 <buddy_free_pages+0x19f>
    }
    buddy_manager[index] = node_size;
c01030e0:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e9:	c1 e0 02             	shl    $0x2,%eax
c01030ec:	01 c2                	add    %eax,%edx
c01030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030f1:	89 02                	mov    %eax,(%edx)
    cprintf(" index:%u offset:%u ", index, offset);
c01030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103101:	c7 04 24 9a 74 10 c0 	movl   $0xc010749a,(%esp)
c0103108:	e8 58 d2 ff ff       	call   c0100365 <cprintf>
    index = PARENT(index);
c010310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103110:	d1 e8                	shr    %eax
c0103112:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
c0103115:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
c0103118:	e9 86 00 00 00       	jmp    c01031a3 <buddy_free_pages+0x29f>
    {
        unsigned leftSize = buddy_manager[LEFT_LEAF(index)];
c010311d:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103123:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103126:	c1 e0 03             	shl    $0x3,%eax
c0103129:	01 d0                	add    %edx,%eax
c010312b:	8b 00                	mov    (%eax),%eax
c010312d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned rightSize = buddy_manager[RIGHT_LEAF(index)];
c0103130:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103136:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103139:	c1 e0 03             	shl    $0x3,%eax
c010313c:	83 c0 04             	add    $0x4,%eax
c010313f:	01 d0                	add    %edx,%eax
c0103141:	8b 00                	mov    (%eax),%eax
c0103143:	89 45 e0             	mov    %eax,-0x20(%ebp)
        // 左右节点均全空，连起来
        if (leftSize + rightSize == node_size)
c0103146:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103149:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010314c:	01 d0                	add    %edx,%eax
c010314e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103151:	75 15                	jne    c0103168 <buddy_free_pages+0x264>
        {
            buddy_manager[index] = node_size;
c0103153:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103159:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010315c:	c1 e0 02             	shl    $0x2,%eax
c010315f:	01 c2                	add    %eax,%edx
c0103161:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103164:	89 02                	mov    %eax,(%edx)
c0103166:	eb 30                	jmp    c0103198 <buddy_free_pages+0x294>
        }
        else if (leftSize > rightSize)
c0103168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010316b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010316e:	76 15                	jbe    c0103185 <buddy_free_pages+0x281>
        {
            buddy_manager[index] = leftSize;
c0103170:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103179:	c1 e0 02             	shl    $0x2,%eax
c010317c:	01 c2                	add    %eax,%edx
c010317e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103181:	89 02                	mov    %eax,(%edx)
c0103183:	eb 13                	jmp    c0103198 <buddy_free_pages+0x294>
        }
        else
        {
            buddy_manager[index] = rightSize;
c0103185:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c010318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010318e:	c1 e0 02             	shl    $0x2,%eax
c0103191:	01 c2                	add    %eax,%edx
c0103193:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103196:	89 02                	mov    %eax,(%edx)
        }
        index = PARENT(index);
c0103198:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010319b:	d1 e8                	shr    %eax
c010319d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
c01031a0:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
c01031a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031a7:	0f 85 70 ff ff ff    	jne    c010311d <buddy_free_pages+0x219>
    }
    free_page_num += n;
c01031ad:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c01031b2:	89 c2                	mov    %eax,%edx
c01031b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031b7:	01 d0                	add    %edx,%eax
c01031b9:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    cprintf("finish!\n");
c01031be:	c7 04 24 c4 74 10 c0 	movl   $0xc01074c4,(%esp)
c01031c5:	e8 9b d1 ff ff       	call   c0100365 <cprintf>
}
c01031ca:	90                   	nop
c01031cb:	89 ec                	mov    %ebp,%esp
c01031cd:	5d                   	pop    %ebp
c01031ce:	c3                   	ret    

c01031cf <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
c01031cf:	55                   	push   %ebp
c01031d0:	89 e5                	mov    %esp,%ebp
    return free_page_num;
c01031d2:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
}
c01031d7:	5d                   	pop    %ebp
c01031d8:	c3                   	ret    

c01031d9 <basic_check>:

static void
basic_check(void)
{
c01031d9:	55                   	push   %ebp
c01031da:	89 e5                	mov    %esp,%ebp
}
c01031dc:	90                   	nop
c01031dd:	5d                   	pop    %ebp
c01031de:	c3                   	ret    

c01031df <buddy_check>:

static void
buddy_check(void)
{
c01031df:	55                   	push   %ebp
c01031e0:	89 e5                	mov    %esp,%ebp
c01031e2:	83 ec 38             	sub    $0x38,%esp
    cprintf("buddy check!\n");
c01031e5:	c7 04 24 1b 75 10 c0 	movl   $0xc010751b,(%esp)
c01031ec:	e8 74 d1 ff ff       	call   c0100365 <cprintf>
    struct Page *p0, *A, *B, *C, *D;
    p0 = A = B = C = D = NULL;
c01031f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103201:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103204:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103207:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010320d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
c0103210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103217:	e8 07 19 00 00       	call   c0104b23 <alloc_pages>
c010321c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010321f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103223:	75 24                	jne    c0103249 <buddy_check+0x6a>
c0103225:	c7 44 24 0c 29 75 10 	movl   $0xc0107529,0xc(%esp)
c010322c:	c0 
c010322d:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103234:	c0 
c0103235:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010323c:	00 
c010323d:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103244:	e8 a1 da ff ff       	call   c0100cea <__panic>
    assert((A = alloc_page()) != NULL);
c0103249:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103250:	e8 ce 18 00 00       	call   c0104b23 <alloc_pages>
c0103255:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103258:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010325c:	75 24                	jne    c0103282 <buddy_check+0xa3>
c010325e:	c7 44 24 0c 45 75 10 	movl   $0xc0107545,0xc(%esp)
c0103265:	c0 
c0103266:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c010326d:	c0 
c010326e:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0103275:	00 
c0103276:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c010327d:	e8 68 da ff ff       	call   c0100cea <__panic>
    assert((B = alloc_page()) != NULL);
c0103282:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103289:	e8 95 18 00 00       	call   c0104b23 <alloc_pages>
c010328e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103291:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103295:	75 24                	jne    c01032bb <buddy_check+0xdc>
c0103297:	c7 44 24 0c 60 75 10 	movl   $0xc0107560,0xc(%esp)
c010329e:	c0 
c010329f:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c01032a6:	c0 
c01032a7:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c01032ae:	00 
c01032af:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c01032b6:	e8 2f da ff ff       	call   c0100cea <__panic>

    assert(p0 != A && p0 != B && A != B);
c01032bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01032c1:	74 10                	je     c01032d3 <buddy_check+0xf4>
c01032c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032c9:	74 08                	je     c01032d3 <buddy_check+0xf4>
c01032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032d1:	75 24                	jne    c01032f7 <buddy_check+0x118>
c01032d3:	c7 44 24 0c 7b 75 10 	movl   $0xc010757b,0xc(%esp)
c01032da:	c0 
c01032db:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c01032e2:	c0 
c01032e3:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01032ea:	00 
c01032eb:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c01032f2:	e8 f3 d9 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
c01032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032fa:	89 04 24             	mov    %eax,(%esp)
c01032fd:	e8 8a f7 ff ff       	call   c0102a8c <page_ref>
c0103302:	85 c0                	test   %eax,%eax
c0103304:	75 1e                	jne    c0103324 <buddy_check+0x145>
c0103306:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103309:	89 04 24             	mov    %eax,(%esp)
c010330c:	e8 7b f7 ff ff       	call   c0102a8c <page_ref>
c0103311:	85 c0                	test   %eax,%eax
c0103313:	75 0f                	jne    c0103324 <buddy_check+0x145>
c0103315:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103318:	89 04 24             	mov    %eax,(%esp)
c010331b:	e8 6c f7 ff ff       	call   c0102a8c <page_ref>
c0103320:	85 c0                	test   %eax,%eax
c0103322:	74 24                	je     c0103348 <buddy_check+0x169>
c0103324:	c7 44 24 0c 98 75 10 	movl   $0xc0107598,0xc(%esp)
c010332b:	c0 
c010332c:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103333:	c0 
c0103334:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c010333b:	00 
c010333c:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103343:	e8 a2 d9 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010334f:	00 
c0103350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103353:	89 04 24             	mov    %eax,(%esp)
c0103356:	e8 02 18 00 00       	call   c0104b5d <free_pages>
    free_page(A);
c010335b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103362:	00 
c0103363:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103366:	89 04 24             	mov    %eax,(%esp)
c0103369:	e8 ef 17 00 00       	call   c0104b5d <free_pages>
    free_page(B);
c010336e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103375:	00 
c0103376:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103379:	89 04 24             	mov    %eax,(%esp)
c010337c:	e8 dc 17 00 00       	call   c0104b5d <free_pages>

    A = alloc_pages(512);
c0103381:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
c0103388:	e8 96 17 00 00       	call   c0104b23 <alloc_pages>
c010338d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(512);
c0103390:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
c0103397:	e8 87 17 00 00       	call   c0104b23 <alloc_pages>
c010339c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    free_pages(A, 256);
c010339f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01033a6:	00 
c01033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033aa:	89 04 24             	mov    %eax,(%esp)
c01033ad:	e8 ab 17 00 00       	call   c0104b5d <free_pages>
    free_pages(B, 512);
c01033b2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01033b9:	00 
c01033ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033bd:	89 04 24             	mov    %eax,(%esp)
c01033c0:	e8 98 17 00 00       	call   c0104b5d <free_pages>
    free_pages(A + 256, 256);
c01033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033c8:	05 00 14 00 00       	add    $0x1400,%eax
c01033cd:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01033d4:	00 
c01033d5:	89 04 24             	mov    %eax,(%esp)
c01033d8:	e8 80 17 00 00       	call   c0104b5d <free_pages>

    p0 = alloc_pages(8192);
c01033dd:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
c01033e4:	e8 3a 17 00 00       	call   c0104b23 <alloc_pages>
c01033e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 == A);
c01033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01033f2:	74 24                	je     c0103418 <buddy_check+0x239>
c01033f4:	c7 44 24 0c d2 75 10 	movl   $0xc01075d2,0xc(%esp)
c01033fb:	c0 
c01033fc:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103403:	c0 
c0103404:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c010340b:	00 
c010340c:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103413:	e8 d2 d8 ff ff       	call   c0100cea <__panic>
    A = alloc_pages(128);
c0103418:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
c010341f:	e8 ff 16 00 00       	call   c0104b23 <alloc_pages>
c0103424:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(64);
c0103427:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c010342e:	e8 f0 16 00 00       	call   c0104b23 <alloc_pages>
c0103433:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 检查是否相邻
    assert(A + 128 == B);
c0103436:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103439:	05 00 0a 00 00       	add    $0xa00,%eax
c010343e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103441:	74 24                	je     c0103467 <buddy_check+0x288>
c0103443:	c7 44 24 0c da 75 10 	movl   $0xc01075da,0xc(%esp)
c010344a:	c0 
c010344b:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103452:	c0 
c0103453:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c010345a:	00 
c010345b:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103462:	e8 83 d8 ff ff       	call   c0100cea <__panic>
    C = alloc_pages(128);
c0103467:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
c010346e:	e8 b0 16 00 00       	call   c0104b23 <alloc_pages>
c0103473:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C有没有和A重叠
    assert(A + 256 == C);
c0103476:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103479:	05 00 14 00 00       	add    $0x1400,%eax
c010347e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103481:	74 24                	je     c01034a7 <buddy_check+0x2c8>
c0103483:	c7 44 24 0c e7 75 10 	movl   $0xc01075e7,0xc(%esp)
c010348a:	c0 
c010348b:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103492:	c0 
c0103493:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010349a:	00 
c010349b:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c01034a2:	e8 43 d8 ff ff       	call   c0100cea <__panic>
    // 释放A
    free_pages(A, 128);
c01034a7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c01034ae:	00 
c01034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034b2:	89 04 24             	mov    %eax,(%esp)
c01034b5:	e8 a3 16 00 00       	call   c0104b5d <free_pages>
    D = alloc_pages(64);
c01034ba:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c01034c1:	e8 5d 16 00 00       	call   c0104b23 <alloc_pages>
c01034c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n", D);
c01034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034d0:	c7 04 24 f4 75 10 c0 	movl   $0xc01075f4,(%esp)
c01034d7:	e8 89 ce ff ff       	call   c0100365 <cprintf>
    // 检查D是否能够使用A刚刚释放的内存
    assert(D + 128 == B);
c01034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034df:	05 00 0a 00 00       	add    $0xa00,%eax
c01034e4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01034e7:	74 24                	je     c010350d <buddy_check+0x32e>
c01034e9:	c7 44 24 0c fa 75 10 	movl   $0xc01075fa,0xc(%esp)
c01034f0:	c0 
c01034f1:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c01034f8:	c0 
c01034f9:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103500:	00 
c0103501:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103508:	e8 dd d7 ff ff       	call   c0100cea <__panic>
    free_pages(C, 128);
c010350d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0103514:	00 
c0103515:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103518:	89 04 24             	mov    %eax,(%esp)
c010351b:	e8 3d 16 00 00       	call   c0104b5d <free_pages>
    C = alloc_pages(64);
c0103520:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c0103527:	e8 f7 15 00 00       	call   c0104b23 <alloc_pages>
c010352c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C是否在B、D之间
    assert(C == D + 64 && C == B - 64);
c010352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103532:	05 00 05 00 00       	add    $0x500,%eax
c0103537:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010353a:	75 0d                	jne    c0103549 <buddy_check+0x36a>
c010353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010353f:	2d 00 05 00 00       	sub    $0x500,%eax
c0103544:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103547:	74 24                	je     c010356d <buddy_check+0x38e>
c0103549:	c7 44 24 0c 07 76 10 	movl   $0xc0107607,0xc(%esp)
c0103550:	c0 
c0103551:	c7 44 24 08 71 74 10 	movl   $0xc0107471,0x8(%esp)
c0103558:	c0 
c0103559:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103560:	00 
c0103561:	c7 04 24 86 74 10 c0 	movl   $0xc0107486,(%esp)
c0103568:	e8 7d d7 ff ff       	call   c0100cea <__panic>
    free_pages(B, 64);
c010356d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0103574:	00 
c0103575:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103578:	89 04 24             	mov    %eax,(%esp)
c010357b:	e8 dd 15 00 00       	call   c0104b5d <free_pages>
    free_pages(D, 64);
c0103580:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0103587:	00 
c0103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358b:	89 04 24             	mov    %eax,(%esp)
c010358e:	e8 ca 15 00 00       	call   c0104b5d <free_pages>
    free_pages(C, 64);
c0103593:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c010359a:	00 
c010359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010359e:	89 04 24             	mov    %eax,(%esp)
c01035a1:	e8 b7 15 00 00       	call   c0104b5d <free_pages>
    // 全部释放
    free_pages(p0, 8192);
c01035a6:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
c01035ad:	00 
c01035ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035b1:	89 04 24             	mov    %eax,(%esp)
c01035b4:	e8 a4 15 00 00       	call   c0104b5d <free_pages>
}
c01035b9:	90                   	nop
c01035ba:	89 ec                	mov    %ebp,%esp
c01035bc:	5d                   	pop    %ebp
c01035bd:	c3                   	ret    

c01035be <page2ppn>:
page2ppn(struct Page *page) {
c01035be:	55                   	push   %ebp
c01035bf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01035c1:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c01035c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ca:	29 d0                	sub    %edx,%eax
c01035cc:	c1 f8 02             	sar    $0x2,%eax
c01035cf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01035d5:	5d                   	pop    %ebp
c01035d6:	c3                   	ret    

c01035d7 <page2pa>:
page2pa(struct Page *page) {
c01035d7:	55                   	push   %ebp
c01035d8:	89 e5                	mov    %esp,%ebp
c01035da:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01035dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e0:	89 04 24             	mov    %eax,(%esp)
c01035e3:	e8 d6 ff ff ff       	call   c01035be <page2ppn>
c01035e8:	c1 e0 0c             	shl    $0xc,%eax
}
c01035eb:	89 ec                	mov    %ebp,%esp
c01035ed:	5d                   	pop    %ebp
c01035ee:	c3                   	ret    

c01035ef <page_ref>:
page_ref(struct Page *page) {
c01035ef:	55                   	push   %ebp
c01035f0:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01035f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f5:	8b 00                	mov    (%eax),%eax
}
c01035f7:	5d                   	pop    %ebp
c01035f8:	c3                   	ret    

c01035f9 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01035f9:	55                   	push   %ebp
c01035fa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01035fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103602:	89 10                	mov    %edx,(%eax)
}
c0103604:	90                   	nop
c0103605:	5d                   	pop    %ebp
c0103606:	c3                   	ret    

c0103607 <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
c0103607:	55                   	push   %ebp
c0103608:	89 e5                	mov    %esp,%ebp
c010360a:	83 ec 10             	sub    $0x10,%esp
c010360d:	c7 45 fc 90 ee 11 c0 	movl   $0xc011ee90,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
c0103614:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103617:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010361a:	89 50 04             	mov    %edx,0x4(%eax)
c010361d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103620:	8b 50 04             	mov    0x4(%eax),%edx
c0103623:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103626:	89 10                	mov    %edx,(%eax)
}
c0103628:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0103629:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c0103630:	00 00 00 
}
c0103633:	90                   	nop
c0103634:	89 ec                	mov    %ebp,%esp
c0103636:	5d                   	pop    %ebp
c0103637:	c3                   	ret    

c0103638 <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
c0103638:	55                   	push   %ebp
c0103639:	89 e5                	mov    %esp,%ebp
c010363b:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010363e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103642:	75 24                	jne    c0103668 <default_init_memmap+0x30>
c0103644:	c7 44 24 0c 50 76 10 	movl   $0xc0107650,0xc(%esp)
c010364b:	c0 
c010364c:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103653:	c0 
c0103654:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010365b:	00 
c010365c:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103663:	e8 82 d6 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0103668:	8b 45 08             	mov    0x8(%ebp),%eax
c010366b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c010366e:	eb 7b                	jmp    c01036eb <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
c0103670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103673:	83 c0 04             	add    $0x4,%eax
c0103676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010367d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103680:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103683:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103686:	0f a3 10             	bt     %edx,(%eax)
c0103689:	19 c0                	sbb    %eax,%eax
c010368b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010368e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103692:	0f 95 c0             	setne  %al
c0103695:	0f b6 c0             	movzbl %al,%eax
c0103698:	85 c0                	test   %eax,%eax
c010369a:	75 24                	jne    c01036c0 <default_init_memmap+0x88>
c010369c:	c7 44 24 0c 81 76 10 	movl   $0xc0107681,0xc(%esp)
c01036a3:	c0 
c01036a4:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01036ab:	c0 
c01036ac:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c01036b3:	00 
c01036b4:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01036bb:	e8 2a d6 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c01036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
c01036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
c01036d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036db:	00 
c01036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036df:	89 04 24             	mov    %eax,(%esp)
c01036e2:	e8 12 ff ff ff       	call   c01035f9 <set_page_ref>
    for (; p != base + n; p++)
c01036e7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01036eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036ee:	89 d0                	mov    %edx,%eax
c01036f0:	c1 e0 02             	shl    $0x2,%eax
c01036f3:	01 d0                	add    %edx,%eax
c01036f5:	c1 e0 02             	shl    $0x2,%eax
c01036f8:	89 c2                	mov    %eax,%edx
c01036fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fd:	01 d0                	add    %edx,%eax
c01036ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103702:	0f 85 68 ff ff ff    	jne    c0103670 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
c0103708:	8b 45 08             	mov    0x8(%ebp),%eax
c010370b:	83 c0 04             	add    $0x4,%eax
c010370e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103715:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0103718:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010371b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010371e:	0f ab 10             	bts    %edx,(%eax)
}
c0103721:	90                   	nop
    base->property = n;
c0103722:	8b 45 08             	mov    0x8(%ebp),%eax
c0103725:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103728:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c010372b:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c0103731:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103734:	01 d0                	add    %edx,%eax
c0103736:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
c010373b:	8b 45 08             	mov    0x8(%ebp),%eax
c010373e:	83 c0 0c             	add    $0xc,%eax
c0103741:	c7 45 e4 90 ee 11 c0 	movl   $0xc011ee90,-0x1c(%ebp)
c0103748:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
c010374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010374e:	8b 00                	mov    (%eax),%eax
c0103750:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103753:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0103756:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010375c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
c010375f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103762:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103765:	89 10                	mov    %edx,(%eax)
c0103767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010376a:	8b 10                	mov    (%eax),%edx
c010376c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010376f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103772:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103778:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010377b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010377e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103781:	89 10                	mov    %edx,(%eax)
}
c0103783:	90                   	nop
}
c0103784:	90                   	nop
}
c0103785:	90                   	nop
c0103786:	89 ec                	mov    %ebp,%esp
c0103788:	5d                   	pop    %ebp
c0103789:	c3                   	ret    

c010378a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c010378a:	55                   	push   %ebp
c010378b:	89 e5                	mov    %esp,%ebp
c010378d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103790:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103794:	75 24                	jne    c01037ba <default_alloc_pages+0x30>
c0103796:	c7 44 24 0c 50 76 10 	movl   $0xc0107650,0xc(%esp)
c010379d:	c0 
c010379e:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01037a5:	c0 
c01037a6:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c01037ad:	00 
c01037ae:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01037b5:	e8 30 d5 ff ff       	call   c0100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
c01037ba:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01037bf:	39 45 08             	cmp    %eax,0x8(%ebp)
c01037c2:	76 0a                	jbe    c01037ce <default_alloc_pages+0x44>
    {
        return NULL;
c01037c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01037c9:	e9 43 01 00 00       	jmp    c0103911 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c01037ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01037d5:	c7 45 f0 90 ee 11 c0 	movl   $0xc011ee90,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c01037dc:	eb 1c                	jmp    c01037fa <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
c01037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037e1:	83 e8 0c             	sub    $0xc,%eax
c01037e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c01037e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ea:	8b 40 08             	mov    0x8(%eax),%eax
c01037ed:	39 45 08             	cmp    %eax,0x8(%ebp)
c01037f0:	77 08                	ja     c01037fa <default_alloc_pages+0x70>
        {
            page = p;
c01037f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01037f8:	eb 18                	jmp    c0103812 <default_alloc_pages+0x88>
c01037fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0103800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103803:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103806:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103809:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103810:	75 cc                	jne    c01037de <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c0103812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103816:	0f 84 f2 00 00 00    	je     c010390e <default_alloc_pages+0x184>
    {
        if (page->property > n)
c010381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010381f:	8b 40 08             	mov    0x8(%eax),%eax
c0103822:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103825:	0f 83 8f 00 00 00    	jae    c01038ba <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
c010382b:	8b 55 08             	mov    0x8(%ebp),%edx
c010382e:	89 d0                	mov    %edx,%eax
c0103830:	c1 e0 02             	shl    $0x2,%eax
c0103833:	01 d0                	add    %edx,%eax
c0103835:	c1 e0 02             	shl    $0x2,%eax
c0103838:	89 c2                	mov    %eax,%edx
c010383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010383d:	01 d0                	add    %edx,%eax
c010383f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103845:	8b 40 08             	mov    0x8(%eax),%eax
c0103848:	2b 45 08             	sub    0x8(%ebp),%eax
c010384b:	89 c2                	mov    %eax,%edx
c010384d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103850:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0103853:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103856:	83 c0 0c             	add    $0xc,%eax
c0103859:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010385c:	83 c2 0c             	add    $0xc,%edx
c010385f:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0103862:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0103865:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103868:	8b 40 04             	mov    0x4(%eax),%eax
c010386b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010386e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103871:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103874:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103877:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c010387a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010387d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103880:	89 10                	mov    %edx,(%eax)
c0103882:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103885:	8b 10                	mov    (%eax),%edx
c0103887:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010388a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010388d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103890:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103893:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103896:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103899:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010389c:	89 10                	mov    %edx,(%eax)
}
c010389e:	90                   	nop
}
c010389f:	90                   	nop
            SetPageProperty(p);
c01038a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038a3:	83 c0 04             	add    $0x4,%eax
c01038a6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01038ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
c01038b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01038b6:	0f ab 10             	bts    %edx,(%eax)
}
c01038b9:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
c01038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038bd:	83 c0 0c             	add    $0xc,%eax
c01038c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01038c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01038c6:	8b 40 04             	mov    0x4(%eax),%eax
c01038c9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01038cc:	8b 12                	mov    (%edx),%edx
c01038ce:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01038d1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
c01038d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01038d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01038da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01038dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01038e0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01038e3:	89 10                	mov    %edx,(%eax)
}
c01038e5:	90                   	nop
}
c01038e6:	90                   	nop
        nr_free -= n;
c01038e7:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01038ec:	2b 45 08             	sub    0x8(%ebp),%eax
c01038ef:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
        ClearPageProperty(page);
c01038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038f7:	83 c0 04             	add    $0x4,%eax
c01038fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103901:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
c0103904:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103907:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010390a:	0f b3 10             	btr    %edx,(%eax)
}
c010390d:	90                   	nop
    }
    return page;
c010390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103911:	89 ec                	mov    %ebp,%esp
c0103913:	5d                   	pop    %ebp
c0103914:	c3                   	ret    

c0103915 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0103915:	55                   	push   %ebp
c0103916:	89 e5                	mov    %esp,%ebp
c0103918:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010391e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103922:	75 24                	jne    c0103948 <default_free_pages+0x33>
c0103924:	c7 44 24 0c 50 76 10 	movl   $0xc0107650,0xc(%esp)
c010392b:	c0 
c010392c:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103933:	c0 
c0103934:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c010393b:	00 
c010393c:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103943:	e8 a2 d3 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0103948:	8b 45 08             	mov    0x8(%ebp),%eax
c010394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c010394e:	e9 9d 00 00 00       	jmp    c01039f0 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0103953:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103956:	83 c0 04             	add    $0x4,%eax
c0103959:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103960:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103963:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103966:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103969:	0f a3 10             	bt     %edx,(%eax)
c010396c:	19 c0                	sbb    %eax,%eax
c010396e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103975:	0f 95 c0             	setne  %al
c0103978:	0f b6 c0             	movzbl %al,%eax
c010397b:	85 c0                	test   %eax,%eax
c010397d:	75 2c                	jne    c01039ab <default_free_pages+0x96>
c010397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103982:	83 c0 04             	add    $0x4,%eax
c0103985:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010398c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c010398f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103992:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103995:	0f a3 10             	bt     %edx,(%eax)
c0103998:	19 c0                	sbb    %eax,%eax
c010399a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010399d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01039a1:	0f 95 c0             	setne  %al
c01039a4:	0f b6 c0             	movzbl %al,%eax
c01039a7:	85 c0                	test   %eax,%eax
c01039a9:	74 24                	je     c01039cf <default_free_pages+0xba>
c01039ab:	c7 44 24 0c 94 76 10 	movl   $0xc0107694,0xc(%esp)
c01039b2:	c0 
c01039b3:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01039ba:	c0 
c01039bb:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c01039c2:	00 
c01039c3:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01039ca:	e8 1b d3 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c01039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01039d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039e0:	00 
c01039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e4:	89 04 24             	mov    %eax,(%esp)
c01039e7:	e8 0d fc ff ff       	call   c01035f9 <set_page_ref>
    for (; p != base + n; p++)
c01039ec:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01039f0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039f3:	89 d0                	mov    %edx,%eax
c01039f5:	c1 e0 02             	shl    $0x2,%eax
c01039f8:	01 d0                	add    %edx,%eax
c01039fa:	c1 e0 02             	shl    $0x2,%eax
c01039fd:	89 c2                	mov    %eax,%edx
c01039ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a02:	01 d0                	add    %edx,%eax
c0103a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a07:	0f 85 46 ff ff ff    	jne    c0103953 <default_free_pages+0x3e>
    }
    base->property = n;
c0103a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a13:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a19:	83 c0 04             	add    $0x4,%eax
c0103a1c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103a23:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0103a26:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103a2c:	0f ab 10             	bts    %edx,(%eax)
}
c0103a2f:	90                   	nop
c0103a30:	c7 45 d4 90 ee 11 c0 	movl   $0xc011ee90,-0x2c(%ebp)
    return listelm->next;
c0103a37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103a3a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
c0103a40:	e9 0e 01 00 00       	jmp    c0103b53 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
c0103a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a48:	83 e8 0c             	sub    $0xc,%eax
c0103a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a51:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103a54:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a57:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
c0103a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a60:	8b 50 08             	mov    0x8(%eax),%edx
c0103a63:	89 d0                	mov    %edx,%eax
c0103a65:	c1 e0 02             	shl    $0x2,%eax
c0103a68:	01 d0                	add    %edx,%eax
c0103a6a:	c1 e0 02             	shl    $0x2,%eax
c0103a6d:	89 c2                	mov    %eax,%edx
c0103a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a72:	01 d0                	add    %edx,%eax
c0103a74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a77:	75 5d                	jne    c0103ad6 <default_free_pages+0x1c1>
        {
            base->property += p->property;
c0103a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7c:	8b 50 08             	mov    0x8(%eax),%edx
c0103a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a82:	8b 40 08             	mov    0x8(%eax),%eax
c0103a85:	01 c2                	add    %eax,%edx
c0103a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a90:	83 c0 04             	add    $0x4,%eax
c0103a93:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103a9a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
c0103a9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103aa0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103aa3:	0f b3 10             	btr    %edx,(%eax)
}
c0103aa6:	90                   	nop
            list_del(&(p->page_link));
c0103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aaa:	83 c0 0c             	add    $0xc,%eax
c0103aad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103ab0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ab3:	8b 40 04             	mov    0x4(%eax),%eax
c0103ab6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103ab9:	8b 12                	mov    (%edx),%edx
c0103abb:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0103ac1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103ac4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ac7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103aca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103acd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ad0:	89 10                	mov    %edx,(%eax)
}
c0103ad2:	90                   	nop
}
c0103ad3:	90                   	nop
c0103ad4:	eb 7d                	jmp    c0103b53 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
c0103ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad9:	8b 50 08             	mov    0x8(%eax),%edx
c0103adc:	89 d0                	mov    %edx,%eax
c0103ade:	c1 e0 02             	shl    $0x2,%eax
c0103ae1:	01 d0                	add    %edx,%eax
c0103ae3:	c1 e0 02             	shl    $0x2,%eax
c0103ae6:	89 c2                	mov    %eax,%edx
c0103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aeb:	01 d0                	add    %edx,%eax
c0103aed:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103af0:	75 61                	jne    c0103b53 <default_free_pages+0x23e>
        {
            p->property += base->property;
c0103af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af5:	8b 50 08             	mov    0x8(%eax),%edx
c0103af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afb:	8b 40 08             	mov    0x8(%eax),%eax
c0103afe:	01 c2                	add    %eax,%edx
c0103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b03:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b09:	83 c0 04             	add    $0x4,%eax
c0103b0c:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0103b13:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
c0103b16:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103b19:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103b1c:	0f b3 10             	btr    %edx,(%eax)
}
c0103b1f:	90                   	nop
            base = p;
c0103b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b23:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0103b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b29:	83 c0 0c             	add    $0xc,%eax
c0103b2c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103b32:	8b 40 04             	mov    0x4(%eax),%eax
c0103b35:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103b38:	8b 12                	mov    (%edx),%edx
c0103b3a:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103b3d:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0103b40:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103b43:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103b46:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103b49:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103b4c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103b4f:	89 10                	mov    %edx,(%eax)
}
c0103b51:	90                   	nop
}
c0103b52:	90                   	nop
    while (le != &free_list)
c0103b53:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103b5a:	0f 85 e5 fe ff ff    	jne    c0103a45 <default_free_pages+0x130>
        }
    }
    le = &free_list;
c0103b60:	c7 45 f0 90 ee 11 c0 	movl   $0xc011ee90,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
c0103b67:	eb 25                	jmp    c0103b8e <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
c0103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b6c:	83 e8 0c             	sub    $0xc,%eax
c0103b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
c0103b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b75:	8b 50 08             	mov    0x8(%eax),%edx
c0103b78:	89 d0                	mov    %edx,%eax
c0103b7a:	c1 e0 02             	shl    $0x2,%eax
c0103b7d:	01 d0                	add    %edx,%eax
c0103b7f:	c1 e0 02             	shl    $0x2,%eax
c0103b82:	89 c2                	mov    %eax,%edx
c0103b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b87:	01 d0                	add    %edx,%eax
c0103b89:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103b8c:	73 1a                	jae    c0103ba8 <default_free_pages+0x293>
c0103b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b91:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0103b94:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103b97:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b9d:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103ba4:	75 c3                	jne    c0103b69 <default_free_pages+0x254>
c0103ba6:	eb 01                	jmp    c0103ba9 <default_free_pages+0x294>
        {
            break;
c0103ba8:	90                   	nop
        }
    }
    nr_free += n;
c0103ba9:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c0103baf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bb2:	01 d0                	add    %edx,%eax
c0103bb4:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    list_add_before(le, &(base->page_link));
c0103bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bbc:	8d 50 0c             	lea    0xc(%eax),%edx
c0103bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bc2:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103bc5:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0103bc8:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103bcb:	8b 00                	mov    (%eax),%eax
c0103bcd:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103bd0:	89 55 90             	mov    %edx,-0x70(%ebp)
c0103bd3:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0103bd6:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103bd9:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
c0103bdc:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bdf:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103be2:	89 10                	mov    %edx,(%eax)
c0103be4:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103be7:	8b 10                	mov    (%eax),%edx
c0103be9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103bec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103bef:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103bf2:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103bf5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103bf8:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103bfb:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103bfe:	89 10                	mov    %edx,(%eax)
}
c0103c00:	90                   	nop
}
c0103c01:	90                   	nop
}
c0103c02:	90                   	nop
c0103c03:	89 ec                	mov    %ebp,%esp
c0103c05:	5d                   	pop    %ebp
c0103c06:	c3                   	ret    

c0103c07 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c0103c07:	55                   	push   %ebp
c0103c08:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103c0a:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
}
c0103c0f:	5d                   	pop    %ebp
c0103c10:	c3                   	ret    

c0103c11 <basic_check>:

static void
basic_check(void)
{
c0103c11:	55                   	push   %ebp
c0103c12:	89 e5                	mov    %esp,%ebp
c0103c14:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103c2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c31:	e8 ed 0e 00 00       	call   c0104b23 <alloc_pages>
c0103c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c3d:	75 24                	jne    c0103c63 <basic_check+0x52>
c0103c3f:	c7 44 24 0c b9 76 10 	movl   $0xc01076b9,0xc(%esp)
c0103c46:	c0 
c0103c47:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103c4e:	c0 
c0103c4f:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103c56:	00 
c0103c57:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103c5e:	e8 87 d0 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103c63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c6a:	e8 b4 0e 00 00       	call   c0104b23 <alloc_pages>
c0103c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c76:	75 24                	jne    c0103c9c <basic_check+0x8b>
c0103c78:	c7 44 24 0c d5 76 10 	movl   $0xc01076d5,0xc(%esp)
c0103c7f:	c0 
c0103c80:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103c87:	c0 
c0103c88:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103c8f:	00 
c0103c90:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103c97:	e8 4e d0 ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ca3:	e8 7b 0e 00 00       	call   c0104b23 <alloc_pages>
c0103ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103caf:	75 24                	jne    c0103cd5 <basic_check+0xc4>
c0103cb1:	c7 44 24 0c f1 76 10 	movl   $0xc01076f1,0xc(%esp)
c0103cb8:	c0 
c0103cb9:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103cc8:	00 
c0103cc9:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103cd0:	e8 15 d0 ff ff       	call   c0100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103cdb:	74 10                	je     c0103ced <basic_check+0xdc>
c0103cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ce0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103ce3:	74 08                	je     c0103ced <basic_check+0xdc>
c0103ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103ceb:	75 24                	jne    c0103d11 <basic_check+0x100>
c0103ced:	c7 44 24 0c 10 77 10 	movl   $0xc0107710,0xc(%esp)
c0103cf4:	c0 
c0103cf5:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103cfc:	c0 
c0103cfd:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103d04:	00 
c0103d05:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103d0c:	e8 d9 cf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d14:	89 04 24             	mov    %eax,(%esp)
c0103d17:	e8 d3 f8 ff ff       	call   c01035ef <page_ref>
c0103d1c:	85 c0                	test   %eax,%eax
c0103d1e:	75 1e                	jne    c0103d3e <basic_check+0x12d>
c0103d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d23:	89 04 24             	mov    %eax,(%esp)
c0103d26:	e8 c4 f8 ff ff       	call   c01035ef <page_ref>
c0103d2b:	85 c0                	test   %eax,%eax
c0103d2d:	75 0f                	jne    c0103d3e <basic_check+0x12d>
c0103d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d32:	89 04 24             	mov    %eax,(%esp)
c0103d35:	e8 b5 f8 ff ff       	call   c01035ef <page_ref>
c0103d3a:	85 c0                	test   %eax,%eax
c0103d3c:	74 24                	je     c0103d62 <basic_check+0x151>
c0103d3e:	c7 44 24 0c 34 77 10 	movl   $0xc0107734,0xc(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103d4d:	c0 
c0103d4e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103d55:	00 
c0103d56:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103d5d:	e8 88 cf ff ff       	call   c0100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d65:	89 04 24             	mov    %eax,(%esp)
c0103d68:	e8 6a f8 ff ff       	call   c01035d7 <page2pa>
c0103d6d:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103d73:	c1 e2 0c             	shl    $0xc,%edx
c0103d76:	39 d0                	cmp    %edx,%eax
c0103d78:	72 24                	jb     c0103d9e <basic_check+0x18d>
c0103d7a:	c7 44 24 0c 70 77 10 	movl   $0xc0107770,0xc(%esp)
c0103d81:	c0 
c0103d82:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103d89:	c0 
c0103d8a:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103d91:	00 
c0103d92:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103d99:	e8 4c cf ff ff       	call   c0100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da1:	89 04 24             	mov    %eax,(%esp)
c0103da4:	e8 2e f8 ff ff       	call   c01035d7 <page2pa>
c0103da9:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103daf:	c1 e2 0c             	shl    $0xc,%edx
c0103db2:	39 d0                	cmp    %edx,%eax
c0103db4:	72 24                	jb     c0103dda <basic_check+0x1c9>
c0103db6:	c7 44 24 0c 8d 77 10 	movl   $0xc010778d,0xc(%esp)
c0103dbd:	c0 
c0103dbe:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103dc5:	c0 
c0103dc6:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103dcd:	00 
c0103dce:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103dd5:	e8 10 cf ff ff       	call   c0100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ddd:	89 04 24             	mov    %eax,(%esp)
c0103de0:	e8 f2 f7 ff ff       	call   c01035d7 <page2pa>
c0103de5:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103deb:	c1 e2 0c             	shl    $0xc,%edx
c0103dee:	39 d0                	cmp    %edx,%eax
c0103df0:	72 24                	jb     c0103e16 <basic_check+0x205>
c0103df2:	c7 44 24 0c aa 77 10 	movl   $0xc01077aa,0xc(%esp)
c0103df9:	c0 
c0103dfa:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103e01:	c0 
c0103e02:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103e09:	00 
c0103e0a:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103e11:	e8 d4 ce ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c0103e16:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c0103e1b:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c0103e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e27:	c7 45 dc 90 ee 11 c0 	movl   $0xc011ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e34:	89 50 04             	mov    %edx,0x4(%eax)
c0103e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e3a:	8b 50 04             	mov    0x4(%eax),%edx
c0103e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e40:	89 10                	mov    %edx,(%eax)
}
c0103e42:	90                   	nop
c0103e43:	c7 45 e0 90 ee 11 c0 	movl   $0xc011ee90,-0x20(%ebp)
    return list->next == list;
c0103e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103e50:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103e53:	0f 94 c0             	sete   %al
c0103e56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e59:	85 c0                	test   %eax,%eax
c0103e5b:	75 24                	jne    c0103e81 <basic_check+0x270>
c0103e5d:	c7 44 24 0c c7 77 10 	movl   $0xc01077c7,0xc(%esp)
c0103e64:	c0 
c0103e65:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103e6c:	c0 
c0103e6d:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103e74:	00 
c0103e75:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103e7c:	e8 69 ce ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c0103e81:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103e86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103e89:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c0103e90:	00 00 00 

    assert(alloc_page() == NULL);
c0103e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e9a:	e8 84 0c 00 00       	call   c0104b23 <alloc_pages>
c0103e9f:	85 c0                	test   %eax,%eax
c0103ea1:	74 24                	je     c0103ec7 <basic_check+0x2b6>
c0103ea3:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c0103eaa:	c0 
c0103eab:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103eb2:	c0 
c0103eb3:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103eba:	00 
c0103ebb:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103ec2:	e8 23 ce ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ece:	00 
c0103ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ed2:	89 04 24             	mov    %eax,(%esp)
c0103ed5:	e8 83 0c 00 00       	call   c0104b5d <free_pages>
    free_page(p1);
c0103eda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ee1:	00 
c0103ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ee5:	89 04 24             	mov    %eax,(%esp)
c0103ee8:	e8 70 0c 00 00       	call   c0104b5d <free_pages>
    free_page(p2);
c0103eed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ef4:	00 
c0103ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ef8:	89 04 24             	mov    %eax,(%esp)
c0103efb:	e8 5d 0c 00 00       	call   c0104b5d <free_pages>
    assert(nr_free == 3);
c0103f00:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103f05:	83 f8 03             	cmp    $0x3,%eax
c0103f08:	74 24                	je     c0103f2e <basic_check+0x31d>
c0103f0a:	c7 44 24 0c f3 77 10 	movl   $0xc01077f3,0xc(%esp)
c0103f11:	c0 
c0103f12:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103f19:	c0 
c0103f1a:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103f21:	00 
c0103f22:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103f29:	e8 bc cd ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103f2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f35:	e8 e9 0b 00 00       	call   c0104b23 <alloc_pages>
c0103f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103f41:	75 24                	jne    c0103f67 <basic_check+0x356>
c0103f43:	c7 44 24 0c b9 76 10 	movl   $0xc01076b9,0xc(%esp)
c0103f4a:	c0 
c0103f4b:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103f52:	c0 
c0103f53:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f5a:	00 
c0103f5b:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103f62:	e8 83 cd ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103f67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f6e:	e8 b0 0b 00 00       	call   c0104b23 <alloc_pages>
c0103f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103f7a:	75 24                	jne    c0103fa0 <basic_check+0x38f>
c0103f7c:	c7 44 24 0c d5 76 10 	movl   $0xc01076d5,0xc(%esp)
c0103f83:	c0 
c0103f84:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103f93:	00 
c0103f94:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103f9b:	e8 4a cd ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fa7:	e8 77 0b 00 00       	call   c0104b23 <alloc_pages>
c0103fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103fb3:	75 24                	jne    c0103fd9 <basic_check+0x3c8>
c0103fb5:	c7 44 24 0c f1 76 10 	movl   $0xc01076f1,0xc(%esp)
c0103fbc:	c0 
c0103fbd:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103fc4:	c0 
c0103fc5:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103fcc:	00 
c0103fcd:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0103fd4:	e8 11 cd ff ff       	call   c0100cea <__panic>

    assert(alloc_page() == NULL);
c0103fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fe0:	e8 3e 0b 00 00       	call   c0104b23 <alloc_pages>
c0103fe5:	85 c0                	test   %eax,%eax
c0103fe7:	74 24                	je     c010400d <basic_check+0x3fc>
c0103fe9:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c0103ff0:	c0 
c0103ff1:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0103ff8:	c0 
c0103ff9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104000:	00 
c0104001:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104008:	e8 dd cc ff ff       	call   c0100cea <__panic>

    free_page(p0);
c010400d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104014:	00 
c0104015:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104018:	89 04 24             	mov    %eax,(%esp)
c010401b:	e8 3d 0b 00 00       	call   c0104b5d <free_pages>
c0104020:	c7 45 d8 90 ee 11 c0 	movl   $0xc011ee90,-0x28(%ebp)
c0104027:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010402a:	8b 40 04             	mov    0x4(%eax),%eax
c010402d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104030:	0f 94 c0             	sete   %al
c0104033:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104036:	85 c0                	test   %eax,%eax
c0104038:	74 24                	je     c010405e <basic_check+0x44d>
c010403a:	c7 44 24 0c 00 78 10 	movl   $0xc0107800,0xc(%esp)
c0104041:	c0 
c0104042:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104049:	c0 
c010404a:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104051:	00 
c0104052:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104059:	e8 8c cc ff ff       	call   c0100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010405e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104065:	e8 b9 0a 00 00       	call   c0104b23 <alloc_pages>
c010406a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104070:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104073:	74 24                	je     c0104099 <basic_check+0x488>
c0104075:	c7 44 24 0c 18 78 10 	movl   $0xc0107818,0xc(%esp)
c010407c:	c0 
c010407d:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104084:	c0 
c0104085:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c010408c:	00 
c010408d:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104094:	e8 51 cc ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040a0:	e8 7e 0a 00 00       	call   c0104b23 <alloc_pages>
c01040a5:	85 c0                	test   %eax,%eax
c01040a7:	74 24                	je     c01040cd <basic_check+0x4bc>
c01040a9:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c01040b0:	c0 
c01040b1:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01040b8:	c0 
c01040b9:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01040c0:	00 
c01040c1:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01040c8:	e8 1d cc ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c01040cd:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01040d2:	85 c0                	test   %eax,%eax
c01040d4:	74 24                	je     c01040fa <basic_check+0x4e9>
c01040d6:	c7 44 24 0c 31 78 10 	movl   $0xc0107831,0xc(%esp)
c01040dd:	c0 
c01040de:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01040ed:	00 
c01040ee:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01040f5:	e8 f0 cb ff ff       	call   c0100cea <__panic>
    free_list = free_list_store;
c01040fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104100:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c0104105:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    nr_free = nr_free_store;
c010410b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010410e:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_page(p);
c0104113:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010411a:	00 
c010411b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010411e:	89 04 24             	mov    %eax,(%esp)
c0104121:	e8 37 0a 00 00       	call   c0104b5d <free_pages>
    free_page(p1);
c0104126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010412d:	00 
c010412e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104131:	89 04 24             	mov    %eax,(%esp)
c0104134:	e8 24 0a 00 00       	call   c0104b5d <free_pages>
    free_page(p2);
c0104139:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104140:	00 
c0104141:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104144:	89 04 24             	mov    %eax,(%esp)
c0104147:	e8 11 0a 00 00       	call   c0104b5d <free_pages>
}
c010414c:	90                   	nop
c010414d:	89 ec                	mov    %ebp,%esp
c010414f:	5d                   	pop    %ebp
c0104150:	c3                   	ret    

c0104151 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c0104151:	55                   	push   %ebp
c0104152:	89 e5                	mov    %esp,%ebp
c0104154:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c010415a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104161:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104168:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c010416f:	eb 6a                	jmp    c01041db <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c0104171:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104174:	83 e8 0c             	sub    $0xc,%eax
c0104177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c010417a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010417d:	83 c0 04             	add    $0x4,%eax
c0104180:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104187:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c010418a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010418d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104190:	0f a3 10             	bt     %edx,(%eax)
c0104193:	19 c0                	sbb    %eax,%eax
c0104195:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104198:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010419c:	0f 95 c0             	setne  %al
c010419f:	0f b6 c0             	movzbl %al,%eax
c01041a2:	85 c0                	test   %eax,%eax
c01041a4:	75 24                	jne    c01041ca <default_check+0x79>
c01041a6:	c7 44 24 0c 3e 78 10 	movl   $0xc010783e,0xc(%esp)
c01041ad:	c0 
c01041ae:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01041b5:	c0 
c01041b6:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01041bd:	00 
c01041be:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01041c5:	e8 20 cb ff ff       	call   c0100cea <__panic>
        count++, total += p->property;
c01041ca:	ff 45 f4             	incl   -0xc(%ebp)
c01041cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041d0:	8b 50 08             	mov    0x8(%eax),%edx
c01041d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d6:	01 d0                	add    %edx,%eax
c01041d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01041e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041e4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01041e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041ea:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c01041f1:	0f 85 7a ff ff ff    	jne    c0104171 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01041f7:	e8 96 09 00 00       	call   c0104b92 <nr_free_pages>
c01041fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01041ff:	39 d0                	cmp    %edx,%eax
c0104201:	74 24                	je     c0104227 <default_check+0xd6>
c0104203:	c7 44 24 0c 4e 78 10 	movl   $0xc010784e,0xc(%esp)
c010420a:	c0 
c010420b:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104212:	c0 
c0104213:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010421a:	00 
c010421b:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104222:	e8 c3 ca ff ff       	call   c0100cea <__panic>

    basic_check();
c0104227:	e8 e5 f9 ff ff       	call   c0103c11 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010422c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104233:	e8 eb 08 00 00       	call   c0104b23 <alloc_pages>
c0104238:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010423b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010423f:	75 24                	jne    c0104265 <default_check+0x114>
c0104241:	c7 44 24 0c 67 78 10 	movl   $0xc0107867,0xc(%esp)
c0104248:	c0 
c0104249:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104250:	c0 
c0104251:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104258:	00 
c0104259:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104260:	e8 85 ca ff ff       	call   c0100cea <__panic>
    assert(!PageProperty(p0));
c0104265:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104268:	83 c0 04             	add    $0x4,%eax
c010426b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104272:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0104275:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104278:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010427b:	0f a3 10             	bt     %edx,(%eax)
c010427e:	19 c0                	sbb    %eax,%eax
c0104280:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104283:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104287:	0f 95 c0             	setne  %al
c010428a:	0f b6 c0             	movzbl %al,%eax
c010428d:	85 c0                	test   %eax,%eax
c010428f:	74 24                	je     c01042b5 <default_check+0x164>
c0104291:	c7 44 24 0c 72 78 10 	movl   $0xc0107872,0xc(%esp)
c0104298:	c0 
c0104299:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01042a0:	c0 
c01042a1:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01042a8:	00 
c01042a9:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01042b0:	e8 35 ca ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c01042b5:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c01042ba:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c01042c0:	89 45 80             	mov    %eax,-0x80(%ebp)
c01042c3:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01042c6:	c7 45 b0 90 ee 11 c0 	movl   $0xc011ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01042cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042d0:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01042d3:	89 50 04             	mov    %edx,0x4(%eax)
c01042d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042d9:	8b 50 04             	mov    0x4(%eax),%edx
c01042dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042df:	89 10                	mov    %edx,(%eax)
}
c01042e1:	90                   	nop
c01042e2:	c7 45 b4 90 ee 11 c0 	movl   $0xc011ee90,-0x4c(%ebp)
    return list->next == list;
c01042e9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042ec:	8b 40 04             	mov    0x4(%eax),%eax
c01042ef:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01042f2:	0f 94 c0             	sete   %al
c01042f5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01042f8:	85 c0                	test   %eax,%eax
c01042fa:	75 24                	jne    c0104320 <default_check+0x1cf>
c01042fc:	c7 44 24 0c c7 77 10 	movl   $0xc01077c7,0xc(%esp)
c0104303:	c0 
c0104304:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010430b:	c0 
c010430c:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0104313:	00 
c0104314:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010431b:	e8 ca c9 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104327:	e8 f7 07 00 00       	call   c0104b23 <alloc_pages>
c010432c:	85 c0                	test   %eax,%eax
c010432e:	74 24                	je     c0104354 <default_check+0x203>
c0104330:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c0104337:	c0 
c0104338:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010433f:	c0 
c0104340:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0104347:	00 
c0104348:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010434f:	e8 96 c9 ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c0104354:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0104359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010435c:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c0104363:	00 00 00 

    free_pages(p0 + 2, 3);
c0104366:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104369:	83 c0 28             	add    $0x28,%eax
c010436c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104373:	00 
c0104374:	89 04 24             	mov    %eax,(%esp)
c0104377:	e8 e1 07 00 00       	call   c0104b5d <free_pages>
    assert(alloc_pages(4) == NULL);
c010437c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104383:	e8 9b 07 00 00       	call   c0104b23 <alloc_pages>
c0104388:	85 c0                	test   %eax,%eax
c010438a:	74 24                	je     c01043b0 <default_check+0x25f>
c010438c:	c7 44 24 0c 84 78 10 	movl   $0xc0107884,0xc(%esp)
c0104393:	c0 
c0104394:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010439b:	c0 
c010439c:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01043a3:	00 
c01043a4:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01043ab:	e8 3a c9 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01043b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043b3:	83 c0 28             	add    $0x28,%eax
c01043b6:	83 c0 04             	add    $0x4,%eax
c01043b9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01043c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01043c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01043c6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01043c9:	0f a3 10             	bt     %edx,(%eax)
c01043cc:	19 c0                	sbb    %eax,%eax
c01043ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01043d1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01043d5:	0f 95 c0             	setne  %al
c01043d8:	0f b6 c0             	movzbl %al,%eax
c01043db:	85 c0                	test   %eax,%eax
c01043dd:	74 0e                	je     c01043ed <default_check+0x29c>
c01043df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043e2:	83 c0 28             	add    $0x28,%eax
c01043e5:	8b 40 08             	mov    0x8(%eax),%eax
c01043e8:	83 f8 03             	cmp    $0x3,%eax
c01043eb:	74 24                	je     c0104411 <default_check+0x2c0>
c01043ed:	c7 44 24 0c 9c 78 10 	movl   $0xc010789c,0xc(%esp)
c01043f4:	c0 
c01043f5:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01043fc:	c0 
c01043fd:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104404:	00 
c0104405:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010440c:	e8 d9 c8 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104411:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104418:	e8 06 07 00 00       	call   c0104b23 <alloc_pages>
c010441d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104424:	75 24                	jne    c010444a <default_check+0x2f9>
c0104426:	c7 44 24 0c c8 78 10 	movl   $0xc01078c8,0xc(%esp)
c010442d:	c0 
c010442e:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104435:	c0 
c0104436:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c010443d:	00 
c010443e:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104445:	e8 a0 c8 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c010444a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104451:	e8 cd 06 00 00       	call   c0104b23 <alloc_pages>
c0104456:	85 c0                	test   %eax,%eax
c0104458:	74 24                	je     c010447e <default_check+0x32d>
c010445a:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c0104461:	c0 
c0104462:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104469:	c0 
c010446a:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0104471:	00 
c0104472:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104479:	e8 6c c8 ff ff       	call   c0100cea <__panic>
    assert(p0 + 2 == p1);
c010447e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104481:	83 c0 28             	add    $0x28,%eax
c0104484:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104487:	74 24                	je     c01044ad <default_check+0x35c>
c0104489:	c7 44 24 0c e6 78 10 	movl   $0xc01078e6,0xc(%esp)
c0104490:	c0 
c0104491:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104498:	c0 
c0104499:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01044a0:	00 
c01044a1:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01044a8:	e8 3d c8 ff ff       	call   c0100cea <__panic>

    p2 = p0 + 1;
c01044ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044b0:	83 c0 14             	add    $0x14,%eax
c01044b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01044b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044bd:	00 
c01044be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044c1:	89 04 24             	mov    %eax,(%esp)
c01044c4:	e8 94 06 00 00       	call   c0104b5d <free_pages>
    free_pages(p1, 3);
c01044c9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01044d0:	00 
c01044d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044d4:	89 04 24             	mov    %eax,(%esp)
c01044d7:	e8 81 06 00 00       	call   c0104b5d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01044dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044df:	83 c0 04             	add    $0x4,%eax
c01044e2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01044e9:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01044ec:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01044ef:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01044f2:	0f a3 10             	bt     %edx,(%eax)
c01044f5:	19 c0                	sbb    %eax,%eax
c01044f7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01044fa:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01044fe:	0f 95 c0             	setne  %al
c0104501:	0f b6 c0             	movzbl %al,%eax
c0104504:	85 c0                	test   %eax,%eax
c0104506:	74 0b                	je     c0104513 <default_check+0x3c2>
c0104508:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010450b:	8b 40 08             	mov    0x8(%eax),%eax
c010450e:	83 f8 01             	cmp    $0x1,%eax
c0104511:	74 24                	je     c0104537 <default_check+0x3e6>
c0104513:	c7 44 24 0c f4 78 10 	movl   $0xc01078f4,0xc(%esp)
c010451a:	c0 
c010451b:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c0104522:	c0 
c0104523:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010452a:	00 
c010452b:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c0104532:	e8 b3 c7 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104537:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010453a:	83 c0 04             	add    $0x4,%eax
c010453d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104544:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0104547:	8b 45 90             	mov    -0x70(%ebp),%eax
c010454a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010454d:	0f a3 10             	bt     %edx,(%eax)
c0104550:	19 c0                	sbb    %eax,%eax
c0104552:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104555:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104559:	0f 95 c0             	setne  %al
c010455c:	0f b6 c0             	movzbl %al,%eax
c010455f:	85 c0                	test   %eax,%eax
c0104561:	74 0b                	je     c010456e <default_check+0x41d>
c0104563:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104566:	8b 40 08             	mov    0x8(%eax),%eax
c0104569:	83 f8 03             	cmp    $0x3,%eax
c010456c:	74 24                	je     c0104592 <default_check+0x441>
c010456e:	c7 44 24 0c 1c 79 10 	movl   $0xc010791c,0xc(%esp)
c0104575:	c0 
c0104576:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010457d:	c0 
c010457e:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104585:	00 
c0104586:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010458d:	e8 58 c7 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104592:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104599:	e8 85 05 00 00       	call   c0104b23 <alloc_pages>
c010459e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01045a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045a4:	83 e8 14             	sub    $0x14,%eax
c01045a7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01045aa:	74 24                	je     c01045d0 <default_check+0x47f>
c01045ac:	c7 44 24 0c 42 79 10 	movl   $0xc0107942,0xc(%esp)
c01045b3:	c0 
c01045b4:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01045bb:	c0 
c01045bc:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01045c3:	00 
c01045c4:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01045cb:	e8 1a c7 ff ff       	call   c0100cea <__panic>
    free_page(p0);
c01045d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045d7:	00 
c01045d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045db:	89 04 24             	mov    %eax,(%esp)
c01045de:	e8 7a 05 00 00       	call   c0104b5d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01045e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01045ea:	e8 34 05 00 00       	call   c0104b23 <alloc_pages>
c01045ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01045f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045f5:	83 c0 14             	add    $0x14,%eax
c01045f8:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01045fb:	74 24                	je     c0104621 <default_check+0x4d0>
c01045fd:	c7 44 24 0c 60 79 10 	movl   $0xc0107960,0xc(%esp)
c0104604:	c0 
c0104605:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010460c:	c0 
c010460d:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104614:	00 
c0104615:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010461c:	e8 c9 c6 ff ff       	call   c0100cea <__panic>

    free_pages(p0, 2);
c0104621:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104628:	00 
c0104629:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010462c:	89 04 24             	mov    %eax,(%esp)
c010462f:	e8 29 05 00 00       	call   c0104b5d <free_pages>
    free_page(p2);
c0104634:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010463b:	00 
c010463c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010463f:	89 04 24             	mov    %eax,(%esp)
c0104642:	e8 16 05 00 00       	call   c0104b5d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104647:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010464e:	e8 d0 04 00 00       	call   c0104b23 <alloc_pages>
c0104653:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104656:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010465a:	75 24                	jne    c0104680 <default_check+0x52f>
c010465c:	c7 44 24 0c 80 79 10 	movl   $0xc0107980,0xc(%esp)
c0104663:	c0 
c0104664:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010466b:	c0 
c010466c:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0104673:	00 
c0104674:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010467b:	e8 6a c6 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104680:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104687:	e8 97 04 00 00       	call   c0104b23 <alloc_pages>
c010468c:	85 c0                	test   %eax,%eax
c010468e:	74 24                	je     c01046b4 <default_check+0x563>
c0104690:	c7 44 24 0c de 77 10 	movl   $0xc01077de,0xc(%esp)
c0104697:	c0 
c0104698:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010469f:	c0 
c01046a0:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c01046a7:	00 
c01046a8:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01046af:	e8 36 c6 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c01046b4:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01046b9:	85 c0                	test   %eax,%eax
c01046bb:	74 24                	je     c01046e1 <default_check+0x590>
c01046bd:	c7 44 24 0c 31 78 10 	movl   $0xc0107831,0xc(%esp)
c01046c4:	c0 
c01046c5:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01046cc:	c0 
c01046cd:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c01046d4:	00 
c01046d5:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01046dc:	e8 09 c6 ff ff       	call   c0100cea <__panic>
    nr_free = nr_free_store;
c01046e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046e4:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_list = free_list_store;
c01046e9:	8b 45 80             	mov    -0x80(%ebp),%eax
c01046ec:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01046ef:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c01046f4:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    free_pages(p0, 5);
c01046fa:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104701:	00 
c0104702:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104705:	89 04 24             	mov    %eax,(%esp)
c0104708:	e8 50 04 00 00       	call   c0104b5d <free_pages>

    le = &free_list;
c010470d:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0104714:	eb 5a                	jmp    c0104770 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
c0104716:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104719:	8b 40 04             	mov    0x4(%eax),%eax
c010471c:	8b 00                	mov    (%eax),%eax
c010471e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104721:	75 0d                	jne    c0104730 <default_check+0x5df>
c0104723:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104726:	8b 00                	mov    (%eax),%eax
c0104728:	8b 40 04             	mov    0x4(%eax),%eax
c010472b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010472e:	74 24                	je     c0104754 <default_check+0x603>
c0104730:	c7 44 24 0c a0 79 10 	movl   $0xc01079a0,0xc(%esp)
c0104737:	c0 
c0104738:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010473f:	c0 
c0104740:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0104747:	00 
c0104748:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c010474f:	e8 96 c5 ff ff       	call   c0100cea <__panic>
        struct Page *p = le2page(le, page_link);
c0104754:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104757:	83 e8 0c             	sub    $0xc,%eax
c010475a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c010475d:	ff 4d f4             	decl   -0xc(%ebp)
c0104760:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104763:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104766:	8b 48 08             	mov    0x8(%eax),%ecx
c0104769:	89 d0                	mov    %edx,%eax
c010476b:	29 c8                	sub    %ecx,%eax
c010476d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104770:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104773:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0104776:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104779:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c010477c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010477f:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c0104786:	75 8e                	jne    c0104716 <default_check+0x5c5>
    }
    assert(count == 0);
c0104788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010478c:	74 24                	je     c01047b2 <default_check+0x661>
c010478e:	c7 44 24 0c cd 79 10 	movl   $0xc01079cd,0xc(%esp)
c0104795:	c0 
c0104796:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c010479d:	c0 
c010479e:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c01047a5:	00 
c01047a6:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01047ad:	e8 38 c5 ff ff       	call   c0100cea <__panic>
    assert(total == 0);
c01047b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047b6:	74 24                	je     c01047dc <default_check+0x68b>
c01047b8:	c7 44 24 0c d8 79 10 	movl   $0xc01079d8,0xc(%esp)
c01047bf:	c0 
c01047c0:	c7 44 24 08 56 76 10 	movl   $0xc0107656,0x8(%esp)
c01047c7:	c0 
c01047c8:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c01047cf:	00 
c01047d0:	c7 04 24 6b 76 10 c0 	movl   $0xc010766b,(%esp)
c01047d7:	e8 0e c5 ff ff       	call   c0100cea <__panic>
}
c01047dc:	90                   	nop
c01047dd:	89 ec                	mov    %ebp,%esp
c01047df:	5d                   	pop    %ebp
c01047e0:	c3                   	ret    

c01047e1 <page2ppn>:
page2ppn(struct Page *page) {
c01047e1:	55                   	push   %ebp
c01047e2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01047e4:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c01047ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ed:	29 d0                	sub    %edx,%eax
c01047ef:	c1 f8 02             	sar    $0x2,%eax
c01047f2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01047f8:	5d                   	pop    %ebp
c01047f9:	c3                   	ret    

c01047fa <page2pa>:
page2pa(struct Page *page) {
c01047fa:	55                   	push   %ebp
c01047fb:	89 e5                	mov    %esp,%ebp
c01047fd:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104800:	8b 45 08             	mov    0x8(%ebp),%eax
c0104803:	89 04 24             	mov    %eax,(%esp)
c0104806:	e8 d6 ff ff ff       	call   c01047e1 <page2ppn>
c010480b:	c1 e0 0c             	shl    $0xc,%eax
}
c010480e:	89 ec                	mov    %ebp,%esp
c0104810:	5d                   	pop    %ebp
c0104811:	c3                   	ret    

c0104812 <pa2page>:
pa2page(uintptr_t pa) {
c0104812:	55                   	push   %ebp
c0104813:	89 e5                	mov    %esp,%ebp
c0104815:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104818:	8b 45 08             	mov    0x8(%ebp),%eax
c010481b:	c1 e8 0c             	shr    $0xc,%eax
c010481e:	89 c2                	mov    %eax,%edx
c0104820:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104825:	39 c2                	cmp    %eax,%edx
c0104827:	72 1c                	jb     c0104845 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104829:	c7 44 24 08 14 7a 10 	movl   $0xc0107a14,0x8(%esp)
c0104830:	c0 
c0104831:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0104838:	00 
c0104839:	c7 04 24 33 7a 10 c0 	movl   $0xc0107a33,(%esp)
c0104840:	e8 a5 c4 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c0104845:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c010484b:	8b 45 08             	mov    0x8(%ebp),%eax
c010484e:	c1 e8 0c             	shr    $0xc,%eax
c0104851:	89 c2                	mov    %eax,%edx
c0104853:	89 d0                	mov    %edx,%eax
c0104855:	c1 e0 02             	shl    $0x2,%eax
c0104858:	01 d0                	add    %edx,%eax
c010485a:	c1 e0 02             	shl    $0x2,%eax
c010485d:	01 c8                	add    %ecx,%eax
}
c010485f:	89 ec                	mov    %ebp,%esp
c0104861:	5d                   	pop    %ebp
c0104862:	c3                   	ret    

c0104863 <page2kva>:
page2kva(struct Page *page) {
c0104863:	55                   	push   %ebp
c0104864:	89 e5                	mov    %esp,%ebp
c0104866:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104869:	8b 45 08             	mov    0x8(%ebp),%eax
c010486c:	89 04 24             	mov    %eax,(%esp)
c010486f:	e8 86 ff ff ff       	call   c01047fa <page2pa>
c0104874:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487a:	c1 e8 0c             	shr    $0xc,%eax
c010487d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104880:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104885:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104888:	72 23                	jb     c01048ad <page2kva+0x4a>
c010488a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010488d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104891:	c7 44 24 08 44 7a 10 	movl   $0xc0107a44,0x8(%esp)
c0104898:	c0 
c0104899:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01048a0:	00 
c01048a1:	c7 04 24 33 7a 10 c0 	movl   $0xc0107a33,(%esp)
c01048a8:	e8 3d c4 ff ff       	call   c0100cea <__panic>
c01048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01048b5:	89 ec                	mov    %ebp,%esp
c01048b7:	5d                   	pop    %ebp
c01048b8:	c3                   	ret    

c01048b9 <pte2page>:
pte2page(pte_t pte) {
c01048b9:	55                   	push   %ebp
c01048ba:	89 e5                	mov    %esp,%ebp
c01048bc:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01048bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c2:	83 e0 01             	and    $0x1,%eax
c01048c5:	85 c0                	test   %eax,%eax
c01048c7:	75 1c                	jne    c01048e5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01048c9:	c7 44 24 08 68 7a 10 	movl   $0xc0107a68,0x8(%esp)
c01048d0:	c0 
c01048d1:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01048d8:	00 
c01048d9:	c7 04 24 33 7a 10 c0 	movl   $0xc0107a33,(%esp)
c01048e0:	e8 05 c4 ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c01048e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048ed:	89 04 24             	mov    %eax,(%esp)
c01048f0:	e8 1d ff ff ff       	call   c0104812 <pa2page>
}
c01048f5:	89 ec                	mov    %ebp,%esp
c01048f7:	5d                   	pop    %ebp
c01048f8:	c3                   	ret    

c01048f9 <pde2page>:
pde2page(pde_t pde) {
c01048f9:	55                   	push   %ebp
c01048fa:	89 e5                	mov    %esp,%ebp
c01048fc:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01048ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104907:	89 04 24             	mov    %eax,(%esp)
c010490a:	e8 03 ff ff ff       	call   c0104812 <pa2page>
}
c010490f:	89 ec                	mov    %ebp,%esp
c0104911:	5d                   	pop    %ebp
c0104912:	c3                   	ret    

c0104913 <page_ref>:
page_ref(struct Page *page) {
c0104913:	55                   	push   %ebp
c0104914:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104916:	8b 45 08             	mov    0x8(%ebp),%eax
c0104919:	8b 00                	mov    (%eax),%eax
}
c010491b:	5d                   	pop    %ebp
c010491c:	c3                   	ret    

c010491d <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010491d:	55                   	push   %ebp
c010491e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104920:	8b 45 08             	mov    0x8(%ebp),%eax
c0104923:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104926:	89 10                	mov    %edx,(%eax)
}
c0104928:	90                   	nop
c0104929:	5d                   	pop    %ebp
c010492a:	c3                   	ret    

c010492b <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010492b:	55                   	push   %ebp
c010492c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010492e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104931:	8b 00                	mov    (%eax),%eax
c0104933:	8d 50 01             	lea    0x1(%eax),%edx
c0104936:	8b 45 08             	mov    0x8(%ebp),%eax
c0104939:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010493b:	8b 45 08             	mov    0x8(%ebp),%eax
c010493e:	8b 00                	mov    (%eax),%eax
}
c0104940:	5d                   	pop    %ebp
c0104941:	c3                   	ret    

c0104942 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104942:	55                   	push   %ebp
c0104943:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104945:	8b 45 08             	mov    0x8(%ebp),%eax
c0104948:	8b 00                	mov    (%eax),%eax
c010494a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010494d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104950:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104952:	8b 45 08             	mov    0x8(%ebp),%eax
c0104955:	8b 00                	mov    (%eax),%eax
}
c0104957:	5d                   	pop    %ebp
c0104958:	c3                   	ret    

c0104959 <__intr_save>:
{
c0104959:	55                   	push   %ebp
c010495a:	89 e5                	mov    %esp,%ebp
c010495c:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
c010495f:	9c                   	pushf  
c0104960:	58                   	pop    %eax
c0104961:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104964:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
c0104967:	25 00 02 00 00       	and    $0x200,%eax
c010496c:	85 c0                	test   %eax,%eax
c010496e:	74 0c                	je     c010497c <__intr_save+0x23>
        intr_disable();
c0104970:	e8 ce cd ff ff       	call   c0101743 <intr_disable>
        return 1;
c0104975:	b8 01 00 00 00       	mov    $0x1,%eax
c010497a:	eb 05                	jmp    c0104981 <__intr_save+0x28>
    return 0;
c010497c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104981:	89 ec                	mov    %ebp,%esp
c0104983:	5d                   	pop    %ebp
c0104984:	c3                   	ret    

c0104985 <__intr_restore>:
{
c0104985:	55                   	push   %ebp
c0104986:	89 e5                	mov    %esp,%ebp
c0104988:	83 ec 08             	sub    $0x8,%esp
    if (flag)
c010498b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010498f:	74 05                	je     c0104996 <__intr_restore+0x11>
        intr_enable();
c0104991:	e8 a5 cd ff ff       	call   c010173b <intr_enable>
}
c0104996:	90                   	nop
c0104997:	89 ec                	mov    %ebp,%esp
c0104999:	5d                   	pop    %ebp
c010499a:	c3                   	ret    

c010499b <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
c010499b:	55                   	push   %ebp
c010499c:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
c010499e:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a1:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
c01049a4:	b8 23 00 00 00       	mov    $0x23,%eax
c01049a9:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
c01049ab:	b8 23 00 00 00       	mov    $0x23,%eax
c01049b0:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
c01049b2:	b8 10 00 00 00       	mov    $0x10,%eax
c01049b7:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
c01049b9:	b8 10 00 00 00       	mov    $0x10,%eax
c01049be:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
c01049c0:	b8 10 00 00 00       	mov    $0x10,%eax
c01049c5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
c01049c7:	ea ce 49 10 c0 08 00 	ljmp   $0x8,$0xc01049ce
}
c01049ce:	90                   	nop
c01049cf:	5d                   	pop    %ebp
c01049d0:	c3                   	ret    

c01049d1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
c01049d1:	55                   	push   %ebp
c01049d2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01049d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01049d7:	a3 c4 ee 11 c0       	mov    %eax,0xc011eec4
}
c01049dc:	90                   	nop
c01049dd:	5d                   	pop    %ebp
c01049de:	c3                   	ret    

c01049df <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
c01049df:	55                   	push   %ebp
c01049e0:	89 e5                	mov    %esp,%ebp
c01049e2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01049e5:	b8 00 b0 11 c0       	mov    $0xc011b000,%eax
c01049ea:	89 04 24             	mov    %eax,(%esp)
c01049ed:	e8 df ff ff ff       	call   c01049d1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01049f2:	66 c7 05 c8 ee 11 c0 	movw   $0x10,0xc011eec8
c01049f9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01049fb:	66 c7 05 28 ba 11 c0 	movw   $0x68,0xc011ba28
c0104a02:	68 00 
c0104a04:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a09:	0f b7 c0             	movzwl %ax,%eax
c0104a0c:	66 a3 2a ba 11 c0    	mov    %ax,0xc011ba2a
c0104a12:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a17:	c1 e8 10             	shr    $0x10,%eax
c0104a1a:	a2 2c ba 11 c0       	mov    %al,0xc011ba2c
c0104a1f:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a26:	24 f0                	and    $0xf0,%al
c0104a28:	0c 09                	or     $0x9,%al
c0104a2a:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104a2f:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a36:	24 ef                	and    $0xef,%al
c0104a38:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104a3d:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a44:	24 9f                	and    $0x9f,%al
c0104a46:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104a4b:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a52:	0c 80                	or     $0x80,%al
c0104a54:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104a59:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104a60:	24 f0                	and    $0xf0,%al
c0104a62:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104a67:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104a6e:	24 ef                	and    $0xef,%al
c0104a70:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104a75:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104a7c:	24 df                	and    $0xdf,%al
c0104a7e:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104a83:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104a8a:	0c 40                	or     $0x40,%al
c0104a8c:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104a91:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104a98:	24 7f                	and    $0x7f,%al
c0104a9a:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104a9f:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104aa4:	c1 e8 18             	shr    $0x18,%eax
c0104aa7:	a2 2f ba 11 c0       	mov    %al,0xc011ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104aac:	c7 04 24 30 ba 11 c0 	movl   $0xc011ba30,(%esp)
c0104ab3:	e8 e3 fe ff ff       	call   c010499b <lgdt>
c0104ab8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
c0104abe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104ac2:	0f 00 d8             	ltr    %ax
}
c0104ac5:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0104ac6:	90                   	nop
c0104ac7:	89 ec                	mov    %ebp,%esp
c0104ac9:	5d                   	pop    %ebp
c0104aca:	c3                   	ret    

c0104acb <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
c0104acb:	55                   	push   %ebp
c0104acc:	89 e5                	mov    %esp,%ebp
c0104ace:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104ad1:	c7 05 ac ee 11 c0 f8 	movl   $0xc01079f8,0xc011eeac
c0104ad8:	79 10 c0 
    //pmm_manager = &buddy_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
c0104adb:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104ae0:	8b 00                	mov    (%eax),%eax
c0104ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ae6:	c7 04 24 94 7a 10 c0 	movl   $0xc0107a94,(%esp)
c0104aed:	e8 73 b8 ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c0104af2:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104af7:	8b 40 04             	mov    0x4(%eax),%eax
c0104afa:	ff d0                	call   *%eax
}
c0104afc:	90                   	nop
c0104afd:	89 ec                	mov    %ebp,%esp
c0104aff:	5d                   	pop    %ebp
c0104b00:	c3                   	ret    

c0104b01 <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
c0104b01:	55                   	push   %ebp
c0104b02:	89 e5                	mov    %esp,%ebp
c0104b04:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104b07:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b0c:	8b 40 08             	mov    0x8(%eax),%eax
c0104b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b12:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b16:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b19:	89 14 24             	mov    %edx,(%esp)
c0104b1c:	ff d0                	call   *%eax
}
c0104b1e:	90                   	nop
c0104b1f:	89 ec                	mov    %ebp,%esp
c0104b21:	5d                   	pop    %ebp
c0104b22:	c3                   	ret    

c0104b23 <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
c0104b23:	55                   	push   %ebp
c0104b24:	89 e5                	mov    %esp,%ebp
c0104b26:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c0104b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0104b30:	e8 24 fe ff ff       	call   c0104959 <__intr_save>
c0104b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0104b38:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b3d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104b40:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b43:	89 14 24             	mov    %edx,(%esp)
c0104b46:	ff d0                	call   *%eax
c0104b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0104b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b4e:	89 04 24             	mov    %eax,(%esp)
c0104b51:	e8 2f fe ff ff       	call   c0104985 <__intr_restore>
    return page;
c0104b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104b59:	89 ec                	mov    %ebp,%esp
c0104b5b:	5d                   	pop    %ebp
c0104b5c:	c3                   	ret    

c0104b5d <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
c0104b5d:	55                   	push   %ebp
c0104b5e:	89 e5                	mov    %esp,%ebp
c0104b60:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104b63:	e8 f1 fd ff ff       	call   c0104959 <__intr_save>
c0104b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104b6b:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b70:	8b 40 10             	mov    0x10(%eax),%eax
c0104b73:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b76:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b7a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b7d:	89 14 24             	mov    %edx,(%esp)
c0104b80:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b85:	89 04 24             	mov    %eax,(%esp)
c0104b88:	e8 f8 fd ff ff       	call   c0104985 <__intr_restore>
}
c0104b8d:	90                   	nop
c0104b8e:	89 ec                	mov    %ebp,%esp
c0104b90:	5d                   	pop    %ebp
c0104b91:	c3                   	ret    

c0104b92 <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
c0104b92:	55                   	push   %ebp
c0104b93:	89 e5                	mov    %esp,%ebp
c0104b95:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104b98:	e8 bc fd ff ff       	call   c0104959 <__intr_save>
c0104b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104ba0:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104ba5:	8b 40 14             	mov    0x14(%eax),%eax
c0104ba8:	ff d0                	call   *%eax
c0104baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb0:	89 04 24             	mov    %eax,(%esp)
c0104bb3:	e8 cd fd ff ff       	call   c0104985 <__intr_restore>
    return ret;
c0104bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104bbb:	89 ec                	mov    %ebp,%esp
c0104bbd:	5d                   	pop    %ebp
c0104bbe:	c3                   	ret    

c0104bbf <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
c0104bbf:	55                   	push   %ebp
c0104bc0:	89 e5                	mov    %esp,%ebp
c0104bc2:	57                   	push   %edi
c0104bc3:	56                   	push   %esi
c0104bc4:	53                   	push   %ebx
c0104bc5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104bcb:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104bd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104bd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104be0:	c7 04 24 ab 7a 10 c0 	movl   $0xc0107aab,(%esp)
c0104be7:	e8 79 b7 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
c0104bec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104bf3:	e9 0c 01 00 00       	jmp    c0104d04 <page_init+0x145>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104bf8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104bfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104bfe:	89 d0                	mov    %edx,%eax
c0104c00:	c1 e0 02             	shl    $0x2,%eax
c0104c03:	01 d0                	add    %edx,%eax
c0104c05:	c1 e0 02             	shl    $0x2,%eax
c0104c08:	01 c8                	add    %ecx,%eax
c0104c0a:	8b 50 08             	mov    0x8(%eax),%edx
c0104c0d:	8b 40 04             	mov    0x4(%eax),%eax
c0104c10:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104c13:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104c16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c19:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c1c:	89 d0                	mov    %edx,%eax
c0104c1e:	c1 e0 02             	shl    $0x2,%eax
c0104c21:	01 d0                	add    %edx,%eax
c0104c23:	c1 e0 02             	shl    $0x2,%eax
c0104c26:	01 c8                	add    %ecx,%eax
c0104c28:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104c2b:	8b 58 10             	mov    0x10(%eax),%ebx
c0104c2e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104c31:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104c34:	01 c8                	add    %ecx,%eax
c0104c36:	11 da                	adc    %ebx,%edx
c0104c38:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104c3b:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104c3e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c44:	89 d0                	mov    %edx,%eax
c0104c46:	c1 e0 02             	shl    $0x2,%eax
c0104c49:	01 d0                	add    %edx,%eax
c0104c4b:	c1 e0 02             	shl    $0x2,%eax
c0104c4e:	01 c8                	add    %ecx,%eax
c0104c50:	83 c0 14             	add    $0x14,%eax
c0104c53:	8b 00                	mov    (%eax),%eax
c0104c55:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104c5b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104c5e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104c61:	83 c0 ff             	add    $0xffffffff,%eax
c0104c64:	83 d2 ff             	adc    $0xffffffff,%edx
c0104c67:	89 c6                	mov    %eax,%esi
c0104c69:	89 d7                	mov    %edx,%edi
c0104c6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c71:	89 d0                	mov    %edx,%eax
c0104c73:	c1 e0 02             	shl    $0x2,%eax
c0104c76:	01 d0                	add    %edx,%eax
c0104c78:	c1 e0 02             	shl    $0x2,%eax
c0104c7b:	01 c8                	add    %ecx,%eax
c0104c7d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104c80:	8b 58 10             	mov    0x10(%eax),%ebx
c0104c83:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104c89:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104c8d:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104c91:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104c95:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104c98:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c9f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104ca7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104cab:	c7 04 24 b8 7a 10 c0 	movl   $0xc0107ab8,(%esp)
c0104cb2:	e8 ae b6 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
c0104cb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104cba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cbd:	89 d0                	mov    %edx,%eax
c0104cbf:	c1 e0 02             	shl    $0x2,%eax
c0104cc2:	01 d0                	add    %edx,%eax
c0104cc4:	c1 e0 02             	shl    $0x2,%eax
c0104cc7:	01 c8                	add    %ecx,%eax
c0104cc9:	83 c0 14             	add    $0x14,%eax
c0104ccc:	8b 00                	mov    (%eax),%eax
c0104cce:	83 f8 01             	cmp    $0x1,%eax
c0104cd1:	75 2e                	jne    c0104d01 <page_init+0x142>
        {
            if (maxpa < end && begin < KMEMSIZE)
c0104cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104cd9:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104cdc:	89 d0                	mov    %edx,%eax
c0104cde:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104ce1:	73 1e                	jae    c0104d01 <page_init+0x142>
c0104ce3:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0104ce8:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ced:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104cf0:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104cf3:	72 0c                	jb     c0104d01 <page_init+0x142>
            {
                maxpa = end;
c0104cf5:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104cf8:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104cfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
c0104d01:	ff 45 dc             	incl   -0x24(%ebp)
c0104d04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d07:	8b 00                	mov    (%eax),%eax
c0104d09:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d0c:	0f 8c e6 fe ff ff    	jl     c0104bf8 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE)
c0104d12:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104d17:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d1c:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104d1f:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104d22:	73 0e                	jae    c0104d32 <page_init+0x173>
    {
        maxpa = KMEMSIZE;
c0104d24:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104d2b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d38:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104d3c:	c1 ea 0c             	shr    $0xc,%edx
c0104d3f:	a3 a4 ee 11 c0       	mov    %eax,0xc011eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104d44:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104d4b:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c0104d50:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104d56:	01 d0                	add    %edx,%eax
c0104d58:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104d5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104d5e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104d63:	f7 75 c0             	divl   -0x40(%ebp)
c0104d66:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104d69:	29 d0                	sub    %edx,%eax
c0104d6b:	a3 a0 ee 11 c0       	mov    %eax,0xc011eea0

    for (i = 0; i < npage; i++)
c0104d70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104d77:	eb 2f                	jmp    c0104da8 <page_init+0x1e9>
    {
        SetPageReserved(pages + i);
c0104d79:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c0104d7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104d82:	89 d0                	mov    %edx,%eax
c0104d84:	c1 e0 02             	shl    $0x2,%eax
c0104d87:	01 d0                	add    %edx,%eax
c0104d89:	c1 e0 02             	shl    $0x2,%eax
c0104d8c:	01 c8                	add    %ecx,%eax
c0104d8e:	83 c0 04             	add    $0x4,%eax
c0104d91:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104d98:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
c0104d9b:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104d9e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104da1:	0f ab 10             	bts    %edx,(%eax)
}
c0104da4:	90                   	nop
    for (i = 0; i < npage; i++)
c0104da5:	ff 45 dc             	incl   -0x24(%ebp)
c0104da8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104dab:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104db0:	39 c2                	cmp    %eax,%edx
c0104db2:	72 c5                	jb     c0104d79 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104db4:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0104dba:	89 d0                	mov    %edx,%eax
c0104dbc:	c1 e0 02             	shl    $0x2,%eax
c0104dbf:	01 d0                	add    %edx,%eax
c0104dc1:	c1 e0 02             	shl    $0x2,%eax
c0104dc4:	89 c2                	mov    %eax,%edx
c0104dc6:	a1 a0 ee 11 c0       	mov    0xc011eea0,%eax
c0104dcb:	01 d0                	add    %edx,%eax
c0104dcd:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104dd0:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104dd7:	77 23                	ja     c0104dfc <page_init+0x23d>
c0104dd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104de0:	c7 44 24 08 e8 7a 10 	movl   $0xc0107ae8,0x8(%esp)
c0104de7:	c0 
c0104de8:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104def:	00 
c0104df0:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0104df7:	e8 ee be ff ff       	call   c0100cea <__panic>
c0104dfc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104dff:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e04:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
c0104e07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e0e:	e9 53 01 00 00       	jmp    c0104f66 <page_init+0x3a7>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e19:	89 d0                	mov    %edx,%eax
c0104e1b:	c1 e0 02             	shl    $0x2,%eax
c0104e1e:	01 d0                	add    %edx,%eax
c0104e20:	c1 e0 02             	shl    $0x2,%eax
c0104e23:	01 c8                	add    %ecx,%eax
c0104e25:	8b 50 08             	mov    0x8(%eax),%edx
c0104e28:	8b 40 04             	mov    0x4(%eax),%eax
c0104e2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104e2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104e31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e37:	89 d0                	mov    %edx,%eax
c0104e39:	c1 e0 02             	shl    $0x2,%eax
c0104e3c:	01 d0                	add    %edx,%eax
c0104e3e:	c1 e0 02             	shl    $0x2,%eax
c0104e41:	01 c8                	add    %ecx,%eax
c0104e43:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e46:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e49:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e4f:	01 c8                	add    %ecx,%eax
c0104e51:	11 da                	adc    %ebx,%edx
c0104e53:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104e56:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
c0104e59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e5f:	89 d0                	mov    %edx,%eax
c0104e61:	c1 e0 02             	shl    $0x2,%eax
c0104e64:	01 d0                	add    %edx,%eax
c0104e66:	c1 e0 02             	shl    $0x2,%eax
c0104e69:	01 c8                	add    %ecx,%eax
c0104e6b:	83 c0 14             	add    $0x14,%eax
c0104e6e:	8b 00                	mov    (%eax),%eax
c0104e70:	83 f8 01             	cmp    $0x1,%eax
c0104e73:	0f 85 ea 00 00 00    	jne    c0104f63 <page_init+0x3a4>
        {
            if (begin < freemem)
c0104e79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104e7c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104e81:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104e84:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104e87:	19 d1                	sbb    %edx,%ecx
c0104e89:	73 0d                	jae    c0104e98 <page_init+0x2d9>
            {
                begin = freemem;
c0104e8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104e8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104e91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
c0104e98:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104e9d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ea2:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104ea5:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104ea8:	73 0e                	jae    c0104eb8 <page_init+0x2f9>
            {
                end = KMEMSIZE;
c0104eaa:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104eb1:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
c0104eb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ebb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ebe:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104ec1:	89 d0                	mov    %edx,%eax
c0104ec3:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104ec6:	0f 83 97 00 00 00    	jae    c0104f63 <page_init+0x3a4>
            {
                begin = ROUNDUP(begin, PGSIZE);
c0104ecc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0104ed3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104ed6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ed9:	01 d0                	add    %edx,%eax
c0104edb:	48                   	dec    %eax
c0104edc:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104edf:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104ee2:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ee7:	f7 75 b0             	divl   -0x50(%ebp)
c0104eea:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104eed:	29 d0                	sub    %edx,%eax
c0104eef:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ef4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104efa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104efd:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104f00:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f03:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f08:	89 c7                	mov    %eax,%edi
c0104f0a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104f10:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104f13:	89 d0                	mov    %edx,%eax
c0104f15:	83 e0 00             	and    $0x0,%eax
c0104f18:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104f1b:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104f1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f21:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104f24:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
c0104f27:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f2d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104f30:	89 d0                	mov    %edx,%eax
c0104f32:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104f35:	73 2c                	jae    c0104f63 <page_init+0x3a4>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104f37:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104f3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104f3d:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104f40:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104f43:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104f47:	c1 ea 0c             	shr    $0xc,%edx
c0104f4a:	89 c3                	mov    %eax,%ebx
c0104f4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f4f:	89 04 24             	mov    %eax,(%esp)
c0104f52:	e8 bb f8 ff ff       	call   c0104812 <pa2page>
c0104f57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104f5b:	89 04 24             	mov    %eax,(%esp)
c0104f5e:	e8 9e fb ff ff       	call   c0104b01 <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
c0104f63:	ff 45 dc             	incl   -0x24(%ebp)
c0104f66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f69:	8b 00                	mov    (%eax),%eax
c0104f6b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104f6e:	0f 8c 9f fe ff ff    	jl     c0104e13 <page_init+0x254>
                }
            }
        }
    }
}
c0104f74:	90                   	nop
c0104f75:	90                   	nop
c0104f76:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104f7c:	5b                   	pop    %ebx
c0104f7d:	5e                   	pop    %esi
c0104f7e:	5f                   	pop    %edi
c0104f7f:	5d                   	pop    %ebp
c0104f80:	c3                   	ret    

c0104f81 <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
c0104f81:	55                   	push   %ebp
c0104f82:	89 e5                	mov    %esp,%ebp
c0104f84:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104f87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f8a:	33 45 14             	xor    0x14(%ebp),%eax
c0104f8d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104f92:	85 c0                	test   %eax,%eax
c0104f94:	74 24                	je     c0104fba <boot_map_segment+0x39>
c0104f96:	c7 44 24 0c 1a 7b 10 	movl   $0xc0107b1a,0xc(%esp)
c0104f9d:	c0 
c0104f9e:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0104fa5:	c0 
c0104fa6:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104fad:	00 
c0104fae:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0104fb5:	e8 30 bd ff ff       	call   c0100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104fba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fc4:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104fc9:	89 c2                	mov    %eax,%edx
c0104fcb:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fce:	01 c2                	add    %eax,%edx
c0104fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fd3:	01 d0                	add    %edx,%eax
c0104fd5:	48                   	dec    %eax
c0104fd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fdc:	ba 00 00 00 00       	mov    $0x0,%edx
c0104fe1:	f7 75 f0             	divl   -0x10(%ebp)
c0104fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fe7:	29 d0                	sub    %edx,%eax
c0104fe9:	c1 e8 0c             	shr    $0xc,%eax
c0104fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104fef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ff2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ff8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ffd:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105000:	8b 45 14             	mov    0x14(%ebp),%eax
c0105003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010500e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c0105011:	eb 68                	jmp    c010507b <boot_map_segment+0xfa>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105013:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010501a:	00 
c010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010501e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105022:	8b 45 08             	mov    0x8(%ebp),%eax
c0105025:	89 04 24             	mov    %eax,(%esp)
c0105028:	e8 88 01 00 00       	call   c01051b5 <get_pte>
c010502d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105030:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105034:	75 24                	jne    c010505a <boot_map_segment+0xd9>
c0105036:	c7 44 24 0c 46 7b 10 	movl   $0xc0107b46,0xc(%esp)
c010503d:	c0 
c010503e:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105045:	c0 
c0105046:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c010504d:	00 
c010504e:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105055:	e8 90 bc ff ff       	call   c0100cea <__panic>
        *ptep = pa | PTE_P | perm;
c010505a:	8b 45 14             	mov    0x14(%ebp),%eax
c010505d:	0b 45 18             	or     0x18(%ebp),%eax
c0105060:	83 c8 01             	or     $0x1,%eax
c0105063:	89 c2                	mov    %eax,%edx
c0105065:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105068:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c010506a:	ff 4d f4             	decl   -0xc(%ebp)
c010506d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105074:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010507b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010507f:	75 92                	jne    c0105013 <boot_map_segment+0x92>
    }
}
c0105081:	90                   	nop
c0105082:	90                   	nop
c0105083:	89 ec                	mov    %ebp,%esp
c0105085:	5d                   	pop    %ebp
c0105086:	c3                   	ret    

c0105087 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
c0105087:	55                   	push   %ebp
c0105088:	89 e5                	mov    %esp,%ebp
c010508a:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010508d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105094:	e8 8a fa ff ff       	call   c0104b23 <alloc_pages>
c0105099:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
c010509c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050a0:	75 1c                	jne    c01050be <boot_alloc_page+0x37>
    {
        panic("boot_alloc_page failed.\n");
c01050a2:	c7 44 24 08 53 7b 10 	movl   $0xc0107b53,0x8(%esp)
c01050a9:	c0 
c01050aa:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01050b1:	00 
c01050b2:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01050b9:	e8 2c bc ff ff       	call   c0100cea <__panic>
    }
    return page2kva(p);
c01050be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c1:	89 04 24             	mov    %eax,(%esp)
c01050c4:	e8 9a f7 ff ff       	call   c0104863 <page2kva>
}
c01050c9:	89 ec                	mov    %ebp,%esp
c01050cb:	5d                   	pop    %ebp
c01050cc:	c3                   	ret    

c01050cd <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
c01050cd:	55                   	push   %ebp
c01050ce:	89 e5                	mov    %esp,%ebp
c01050d0:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01050d3:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01050d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050db:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01050e2:	77 23                	ja     c0105107 <pmm_init+0x3a>
c01050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050eb:	c7 44 24 08 e8 7a 10 	movl   $0xc0107ae8,0x8(%esp)
c01050f2:	c0 
c01050f3:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01050fa:	00 
c01050fb:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105102:	e8 e3 bb ff ff       	call   c0100cea <__panic>
c0105107:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010510a:	05 00 00 00 40       	add    $0x40000000,%eax
c010510f:	a3 a8 ee 11 c0       	mov    %eax,0xc011eea8
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105114:	e8 b2 f9 ff ff       	call   c0104acb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105119:	e8 a1 fa ff ff       	call   c0104bbf <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010511e:	e8 ed 03 00 00       	call   c0105510 <check_alloc_page>

    check_pgdir();
c0105123:	e8 09 04 00 00       	call   c0105531 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105128:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010512d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105130:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105137:	77 23                	ja     c010515c <pmm_init+0x8f>
c0105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010513c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105140:	c7 44 24 08 e8 7a 10 	movl   $0xc0107ae8,0x8(%esp)
c0105147:	c0 
c0105148:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c010514f:	00 
c0105150:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105157:	e8 8e bb ff ff       	call   c0100cea <__panic>
c010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010515f:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0105165:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010516a:	05 ac 0f 00 00       	add    $0xfac,%eax
c010516f:	83 ca 03             	or     $0x3,%edx
c0105172:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105174:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105179:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105180:	00 
c0105181:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105188:	00 
c0105189:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105190:	38 
c0105191:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105198:	c0 
c0105199:	89 04 24             	mov    %eax,(%esp)
c010519c:	e8 e0 fd ff ff       	call   c0104f81 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01051a1:	e8 39 f8 ff ff       	call   c01049df <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01051a6:	e8 24 0a 00 00       	call   c0105bcf <check_boot_pgdir>

    print_pgdir();
c01051ab:	e8 a1 0e 00 00       	call   c0106051 <print_pgdir>
}
c01051b0:	90                   	nop
c01051b1:	89 ec                	mov    %ebp,%esp
c01051b3:	5d                   	pop    %ebp
c01051b4:	c3                   	ret    

c01051b5 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
c01051b5:	55                   	push   %ebp
c01051b6:	89 e5                	mov    %esp,%ebp
c01051b8:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep = &pgdir[PDX(la)];
c01051bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051be:	c1 e8 16             	shr    $0x16,%eax
c01051c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cb:	01 d0                	add    %edx,%eax
c01051cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
c01051d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d3:	8b 00                	mov    (%eax),%eax
c01051d5:	83 e0 01             	and    $0x1,%eax
c01051d8:	85 c0                	test   %eax,%eax
c01051da:	0f 85 af 00 00 00    	jne    c010528f <get_pte+0xda>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
c01051e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051e4:	74 15                	je     c01051fb <get_pte+0x46>
c01051e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051ed:	e8 31 f9 ff ff       	call   c0104b23 <alloc_pages>
c01051f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01051f9:	75 0a                	jne    c0105205 <get_pte+0x50>
        {
            return NULL;
c01051fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0105200:	e9 e7 00 00 00       	jmp    c01052ec <get_pte+0x137>
        }
        //设置page reference
        set_page_ref(page, 1);
c0105205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010520c:	00 
c010520d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105210:	89 04 24             	mov    %eax,(%esp)
c0105213:	e8 05 f7 ff ff       	call   c010491d <set_page_ref>
        //得到page的线性地址
        uintptr_t pa = page2pa(page);
c0105218:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010521b:	89 04 24             	mov    %eax,(%esp)
c010521e:	e8 d7 f5 ff ff       	call   c01047fa <page2pa>
c0105223:	89 45 ec             	mov    %eax,-0x14(%ebp)
        //用memset清除page
        memset(KADDR(pa), 0, PGSIZE);
c0105226:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105229:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010522c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010522f:	c1 e8 0c             	shr    $0xc,%eax
c0105232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105235:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c010523a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010523d:	72 23                	jb     c0105262 <get_pte+0xad>
c010523f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105242:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105246:	c7 44 24 08 44 7a 10 	movl   $0xc0107a44,0x8(%esp)
c010524d:	c0 
c010524e:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
c0105255:	00 
c0105256:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010525d:	e8 88 ba ff ff       	call   c0100cea <__panic>
c0105262:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105265:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010526a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105271:	00 
c0105272:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105279:	00 
c010527a:	89 04 24             	mov    %eax,(%esp)
c010527d:	e8 d4 18 00 00       	call   c0106b56 <memset>
        //返回PTE
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0105282:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105285:	83 c8 07             	or     $0x7,%eax
c0105288:	89 c2                	mov    %eax,%edx
c010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010528d:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010528f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105292:	8b 00                	mov    (%eax),%eax
c0105294:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105299:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010529c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010529f:	c1 e8 0c             	shr    $0xc,%eax
c01052a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01052a5:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01052aa:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01052ad:	72 23                	jb     c01052d2 <get_pte+0x11d>
c01052af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01052b6:	c7 44 24 08 44 7a 10 	movl   $0xc0107a44,0x8(%esp)
c01052bd:	c0 
c01052be:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
c01052c5:	00 
c01052c6:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01052cd:	e8 18 ba ff ff       	call   c0100cea <__panic>
c01052d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01052da:	89 c2                	mov    %eax,%edx
c01052dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052df:	c1 e8 0c             	shr    $0xc,%eax
c01052e2:	25 ff 03 00 00       	and    $0x3ff,%eax
c01052e7:	c1 e0 02             	shl    $0x2,%eax
c01052ea:	01 d0                	add    %edx,%eax
}
c01052ec:	89 ec                	mov    %ebp,%esp
c01052ee:	5d                   	pop    %ebp
c01052ef:	c3                   	ret    

c01052f0 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
c01052f0:	55                   	push   %ebp
c01052f1:	89 e5                	mov    %esp,%ebp
c01052f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01052f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052fd:	00 
c01052fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105301:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105305:	8b 45 08             	mov    0x8(%ebp),%eax
c0105308:	89 04 24             	mov    %eax,(%esp)
c010530b:	e8 a5 fe ff ff       	call   c01051b5 <get_pte>
c0105310:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
c0105313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105317:	74 08                	je     c0105321 <get_page+0x31>
    {
        *ptep_store = ptep;
c0105319:	8b 45 10             	mov    0x10(%ebp),%eax
c010531c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010531f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
c0105321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105325:	74 1b                	je     c0105342 <get_page+0x52>
c0105327:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010532a:	8b 00                	mov    (%eax),%eax
c010532c:	83 e0 01             	and    $0x1,%eax
c010532f:	85 c0                	test   %eax,%eax
c0105331:	74 0f                	je     c0105342 <get_page+0x52>
    {
        return pte2page(*ptep);
c0105333:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105336:	8b 00                	mov    (%eax),%eax
c0105338:	89 04 24             	mov    %eax,(%esp)
c010533b:	e8 79 f5 ff ff       	call   c01048b9 <pte2page>
c0105340:	eb 05                	jmp    c0105347 <get_page+0x57>
    }
    return NULL;
c0105342:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105347:	89 ec                	mov    %ebp,%esp
c0105349:	5d                   	pop    %ebp
c010534a:	c3                   	ret    

c010534b <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
c010534b:	55                   	push   %ebp
c010534c:	89 e5                	mov    %esp,%ebp
c010534e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
c0105351:	8b 45 10             	mov    0x10(%ebp),%eax
c0105354:	8b 00                	mov    (%eax),%eax
c0105356:	83 e0 01             	and    $0x1,%eax
c0105359:	85 c0                	test   %eax,%eax
c010535b:	74 4d                	je     c01053aa <page_remove_pte+0x5f>
    {
        struct Page *page = pte2page(*ptep);
c010535d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105360:	8b 00                	mov    (%eax),%eax
c0105362:	89 04 24             	mov    %eax,(%esp)
c0105365:	e8 4f f5 ff ff       	call   c01048b9 <pte2page>
c010536a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //  (page_ref_dec(page)将page的ref减1,并返回减1之后的ref
        if (page_ref_dec(page) == 0)
c010536d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105370:	89 04 24             	mov    %eax,(%esp)
c0105373:	e8 ca f5 ff ff       	call   c0104942 <page_ref_dec>
c0105378:	85 c0                	test   %eax,%eax
c010537a:	75 13                	jne    c010538f <page_remove_pte+0x44>
        {
            free_page(page);
c010537c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105383:	00 
c0105384:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105387:	89 04 24             	mov    %eax,(%esp)
c010538a:	e8 ce f7 ff ff       	call   c0104b5d <free_pages>
        }
        //清除第二个页表 PTE
        *ptep = 0;
c010538f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105398:	8b 45 0c             	mov    0xc(%ebp),%eax
c010539b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010539f:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a2:	89 04 24             	mov    %eax,(%esp)
c01053a5:	e8 07 01 00 00       	call   c01054b1 <tlb_invalidate>
    }
}
c01053aa:	90                   	nop
c01053ab:	89 ec                	mov    %ebp,%esp
c01053ad:	5d                   	pop    %ebp
c01053ae:	c3                   	ret    

c01053af <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
c01053af:	55                   	push   %ebp
c01053b0:	89 e5                	mov    %esp,%ebp
c01053b2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01053b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053bc:	00 
c01053bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01053c7:	89 04 24             	mov    %eax,(%esp)
c01053ca:	e8 e6 fd ff ff       	call   c01051b5 <get_pte>
c01053cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
c01053d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053d6:	74 19                	je     c01053f1 <page_remove+0x42>
    {
        page_remove_pte(pgdir, la, ptep);
c01053d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e9:	89 04 24             	mov    %eax,(%esp)
c01053ec:	e8 5a ff ff ff       	call   c010534b <page_remove_pte>
    }
}
c01053f1:	90                   	nop
c01053f2:	89 ec                	mov    %ebp,%esp
c01053f4:	5d                   	pop    %ebp
c01053f5:	c3                   	ret    

c01053f6 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
c01053f6:	55                   	push   %ebp
c01053f7:	89 e5                	mov    %esp,%ebp
c01053f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01053fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105403:	00 
c0105404:	8b 45 10             	mov    0x10(%ebp),%eax
c0105407:	89 44 24 04          	mov    %eax,0x4(%esp)
c010540b:	8b 45 08             	mov    0x8(%ebp),%eax
c010540e:	89 04 24             	mov    %eax,(%esp)
c0105411:	e8 9f fd ff ff       	call   c01051b5 <get_pte>
c0105416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
c0105419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010541d:	75 0a                	jne    c0105429 <page_insert+0x33>
    {
        return -E_NO_MEM;
c010541f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105424:	e9 84 00 00 00       	jmp    c01054ad <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105429:	8b 45 0c             	mov    0xc(%ebp),%eax
c010542c:	89 04 24             	mov    %eax,(%esp)
c010542f:	e8 f7 f4 ff ff       	call   c010492b <page_ref_inc>
    if (*ptep & PTE_P)
c0105434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105437:	8b 00                	mov    (%eax),%eax
c0105439:	83 e0 01             	and    $0x1,%eax
c010543c:	85 c0                	test   %eax,%eax
c010543e:	74 3e                	je     c010547e <page_insert+0x88>
    {
        struct Page *p = pte2page(*ptep);
c0105440:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105443:	8b 00                	mov    (%eax),%eax
c0105445:	89 04 24             	mov    %eax,(%esp)
c0105448:	e8 6c f4 ff ff       	call   c01048b9 <pte2page>
c010544d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
c0105450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105453:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105456:	75 0d                	jne    c0105465 <page_insert+0x6f>
        {
            page_ref_dec(page);
c0105458:	8b 45 0c             	mov    0xc(%ebp),%eax
c010545b:	89 04 24             	mov    %eax,(%esp)
c010545e:	e8 df f4 ff ff       	call   c0104942 <page_ref_dec>
c0105463:	eb 19                	jmp    c010547e <page_insert+0x88>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
c0105465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105468:	89 44 24 08          	mov    %eax,0x8(%esp)
c010546c:	8b 45 10             	mov    0x10(%ebp),%eax
c010546f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105473:	8b 45 08             	mov    0x8(%ebp),%eax
c0105476:	89 04 24             	mov    %eax,(%esp)
c0105479:	e8 cd fe ff ff       	call   c010534b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010547e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105481:	89 04 24             	mov    %eax,(%esp)
c0105484:	e8 71 f3 ff ff       	call   c01047fa <page2pa>
c0105489:	0b 45 14             	or     0x14(%ebp),%eax
c010548c:	83 c8 01             	or     $0x1,%eax
c010548f:	89 c2                	mov    %eax,%edx
c0105491:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105494:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105496:	8b 45 10             	mov    0x10(%ebp),%eax
c0105499:	89 44 24 04          	mov    %eax,0x4(%esp)
c010549d:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a0:	89 04 24             	mov    %eax,(%esp)
c01054a3:	e8 09 00 00 00       	call   c01054b1 <tlb_invalidate>
    return 0;
c01054a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01054ad:	89 ec                	mov    %ebp,%esp
c01054af:	5d                   	pop    %ebp
c01054b0:	c3                   	ret    

c01054b1 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
c01054b1:	55                   	push   %ebp
c01054b2:	89 e5                	mov    %esp,%ebp
c01054b4:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
c01054b7:	0f 20 d8             	mov    %cr3,%eax
c01054ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
c01054bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
c01054c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01054cd:	77 23                	ja     c01054f2 <tlb_invalidate+0x41>
c01054cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054d6:	c7 44 24 08 e8 7a 10 	movl   $0xc0107ae8,0x8(%esp)
c01054dd:	c0 
c01054de:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01054e5:	00 
c01054e6:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01054ed:	e8 f8 b7 ff ff       	call   c0100cea <__panic>
c01054f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054f5:	05 00 00 00 40       	add    $0x40000000,%eax
c01054fa:	39 d0                	cmp    %edx,%eax
c01054fc:	75 0d                	jne    c010550b <tlb_invalidate+0x5a>
    {
        invlpg((void *)la);
c01054fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105501:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
c0105504:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105507:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
c010550a:	90                   	nop
    }
}
c010550b:	90                   	nop
c010550c:	89 ec                	mov    %ebp,%esp
c010550e:	5d                   	pop    %ebp
c010550f:	c3                   	ret    

c0105510 <check_alloc_page>:

static void
check_alloc_page(void)
{
c0105510:	55                   	push   %ebp
c0105511:	89 e5                	mov    %esp,%ebp
c0105513:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105516:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c010551b:	8b 40 18             	mov    0x18(%eax),%eax
c010551e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105520:	c7 04 24 6c 7b 10 c0 	movl   $0xc0107b6c,(%esp)
c0105527:	e8 39 ae ff ff       	call   c0100365 <cprintf>
}
c010552c:	90                   	nop
c010552d:	89 ec                	mov    %ebp,%esp
c010552f:	5d                   	pop    %ebp
c0105530:	c3                   	ret    

c0105531 <check_pgdir>:

static void
check_pgdir(void)
{
c0105531:	55                   	push   %ebp
c0105532:	89 e5                	mov    %esp,%ebp
c0105534:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105537:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c010553c:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105541:	76 24                	jbe    c0105567 <check_pgdir+0x36>
c0105543:	c7 44 24 0c 8b 7b 10 	movl   $0xc0107b8b,0xc(%esp)
c010554a:	c0 
c010554b:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105552:	c0 
c0105553:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c010555a:	00 
c010555b:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105562:	e8 83 b7 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105567:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010556c:	85 c0                	test   %eax,%eax
c010556e:	74 0e                	je     c010557e <check_pgdir+0x4d>
c0105570:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105575:	25 ff 0f 00 00       	and    $0xfff,%eax
c010557a:	85 c0                	test   %eax,%eax
c010557c:	74 24                	je     c01055a2 <check_pgdir+0x71>
c010557e:	c7 44 24 0c a8 7b 10 	movl   $0xc0107ba8,0xc(%esp)
c0105585:	c0 
c0105586:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010558d:	c0 
c010558e:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0105595:	00 
c0105596:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010559d:	e8 48 b7 ff ff       	call   c0100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01055a2:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01055a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055ae:	00 
c01055af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01055b6:	00 
c01055b7:	89 04 24             	mov    %eax,(%esp)
c01055ba:	e8 31 fd ff ff       	call   c01052f0 <get_page>
c01055bf:	85 c0                	test   %eax,%eax
c01055c1:	74 24                	je     c01055e7 <check_pgdir+0xb6>
c01055c3:	c7 44 24 0c e0 7b 10 	movl   $0xc0107be0,0xc(%esp)
c01055ca:	c0 
c01055cb:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01055d2:	c0 
c01055d3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c01055da:	00 
c01055db:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01055e2:	e8 03 b7 ff ff       	call   c0100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01055e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055ee:	e8 30 f5 ff ff       	call   c0104b23 <alloc_pages>
c01055f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01055f6:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01055fb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105602:	00 
c0105603:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010560a:	00 
c010560b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010560e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105612:	89 04 24             	mov    %eax,(%esp)
c0105615:	e8 dc fd ff ff       	call   c01053f6 <page_insert>
c010561a:	85 c0                	test   %eax,%eax
c010561c:	74 24                	je     c0105642 <check_pgdir+0x111>
c010561e:	c7 44 24 0c 08 7c 10 	movl   $0xc0107c08,0xc(%esp)
c0105625:	c0 
c0105626:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010562d:	c0 
c010562e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0105635:	00 
c0105636:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010563d:	e8 a8 b6 ff ff       	call   c0100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105642:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105647:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010564e:	00 
c010564f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105656:	00 
c0105657:	89 04 24             	mov    %eax,(%esp)
c010565a:	e8 56 fb ff ff       	call   c01051b5 <get_pte>
c010565f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105666:	75 24                	jne    c010568c <check_pgdir+0x15b>
c0105668:	c7 44 24 0c 34 7c 10 	movl   $0xc0107c34,0xc(%esp)
c010566f:	c0 
c0105670:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105677:	c0 
c0105678:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010567f:	00 
c0105680:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105687:	e8 5e b6 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c010568c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010568f:	8b 00                	mov    (%eax),%eax
c0105691:	89 04 24             	mov    %eax,(%esp)
c0105694:	e8 20 f2 ff ff       	call   c01048b9 <pte2page>
c0105699:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010569c:	74 24                	je     c01056c2 <check_pgdir+0x191>
c010569e:	c7 44 24 0c 61 7c 10 	movl   $0xc0107c61,0xc(%esp)
c01056a5:	c0 
c01056a6:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01056ad:	c0 
c01056ae:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01056b5:	00 
c01056b6:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01056bd:	e8 28 b6 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 1);
c01056c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c5:	89 04 24             	mov    %eax,(%esp)
c01056c8:	e8 46 f2 ff ff       	call   c0104913 <page_ref>
c01056cd:	83 f8 01             	cmp    $0x1,%eax
c01056d0:	74 24                	je     c01056f6 <check_pgdir+0x1c5>
c01056d2:	c7 44 24 0c 77 7c 10 	movl   $0xc0107c77,0xc(%esp)
c01056d9:	c0 
c01056da:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01056e1:	c0 
c01056e2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01056e9:	00 
c01056ea:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01056f1:	e8 f4 b5 ff ff       	call   c0100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01056f6:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01056fb:	8b 00                	mov    (%eax),%eax
c01056fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105702:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105705:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105708:	c1 e8 0c             	shr    $0xc,%eax
c010570b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010570e:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105713:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105716:	72 23                	jb     c010573b <check_pgdir+0x20a>
c0105718:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010571b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010571f:	c7 44 24 08 44 7a 10 	movl   $0xc0107a44,0x8(%esp)
c0105726:	c0 
c0105727:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c010572e:	00 
c010572f:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105736:	e8 af b5 ff ff       	call   c0100cea <__panic>
c010573b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010573e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105743:	83 c0 04             	add    $0x4,%eax
c0105746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105749:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010574e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105755:	00 
c0105756:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010575d:	00 
c010575e:	89 04 24             	mov    %eax,(%esp)
c0105761:	e8 4f fa ff ff       	call   c01051b5 <get_pte>
c0105766:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105769:	74 24                	je     c010578f <check_pgdir+0x25e>
c010576b:	c7 44 24 0c 8c 7c 10 	movl   $0xc0107c8c,0xc(%esp)
c0105772:	c0 
c0105773:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010577a:	c0 
c010577b:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105782:	00 
c0105783:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010578a:	e8 5b b5 ff ff       	call   c0100cea <__panic>

    p2 = alloc_page();
c010578f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105796:	e8 88 f3 ff ff       	call   c0104b23 <alloc_pages>
c010579b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010579e:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01057a3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01057aa:	00 
c01057ab:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01057b2:	00 
c01057b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ba:	89 04 24             	mov    %eax,(%esp)
c01057bd:	e8 34 fc ff ff       	call   c01053f6 <page_insert>
c01057c2:	85 c0                	test   %eax,%eax
c01057c4:	74 24                	je     c01057ea <check_pgdir+0x2b9>
c01057c6:	c7 44 24 0c b4 7c 10 	movl   $0xc0107cb4,0xc(%esp)
c01057cd:	c0 
c01057ce:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01057d5:	c0 
c01057d6:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01057dd:	00 
c01057de:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01057e5:	e8 00 b5 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01057ea:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01057ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01057f6:	00 
c01057f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057fe:	00 
c01057ff:	89 04 24             	mov    %eax,(%esp)
c0105802:	e8 ae f9 ff ff       	call   c01051b5 <get_pte>
c0105807:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010580a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010580e:	75 24                	jne    c0105834 <check_pgdir+0x303>
c0105810:	c7 44 24 0c ec 7c 10 	movl   $0xc0107cec,0xc(%esp)
c0105817:	c0 
c0105818:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010581f:	c0 
c0105820:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105827:	00 
c0105828:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010582f:	e8 b6 b4 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_U);
c0105834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105837:	8b 00                	mov    (%eax),%eax
c0105839:	83 e0 04             	and    $0x4,%eax
c010583c:	85 c0                	test   %eax,%eax
c010583e:	75 24                	jne    c0105864 <check_pgdir+0x333>
c0105840:	c7 44 24 0c 1c 7d 10 	movl   $0xc0107d1c,0xc(%esp)
c0105847:	c0 
c0105848:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010584f:	c0 
c0105850:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105857:	00 
c0105858:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010585f:	e8 86 b4 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_W);
c0105864:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105867:	8b 00                	mov    (%eax),%eax
c0105869:	83 e0 02             	and    $0x2,%eax
c010586c:	85 c0                	test   %eax,%eax
c010586e:	75 24                	jne    c0105894 <check_pgdir+0x363>
c0105870:	c7 44 24 0c 2a 7d 10 	movl   $0xc0107d2a,0xc(%esp)
c0105877:	c0 
c0105878:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c010587f:	c0 
c0105880:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105887:	00 
c0105888:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c010588f:	e8 56 b4 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105894:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105899:	8b 00                	mov    (%eax),%eax
c010589b:	83 e0 04             	and    $0x4,%eax
c010589e:	85 c0                	test   %eax,%eax
c01058a0:	75 24                	jne    c01058c6 <check_pgdir+0x395>
c01058a2:	c7 44 24 0c 38 7d 10 	movl   $0xc0107d38,0xc(%esp)
c01058a9:	c0 
c01058aa:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01058b1:	c0 
c01058b2:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01058b9:	00 
c01058ba:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01058c1:	e8 24 b4 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 1);
c01058c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058c9:	89 04 24             	mov    %eax,(%esp)
c01058cc:	e8 42 f0 ff ff       	call   c0104913 <page_ref>
c01058d1:	83 f8 01             	cmp    $0x1,%eax
c01058d4:	74 24                	je     c01058fa <check_pgdir+0x3c9>
c01058d6:	c7 44 24 0c 4e 7d 10 	movl   $0xc0107d4e,0xc(%esp)
c01058dd:	c0 
c01058de:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01058e5:	c0 
c01058e6:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01058ed:	00 
c01058ee:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01058f5:	e8 f0 b3 ff ff       	call   c0100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01058fa:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01058ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105906:	00 
c0105907:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010590e:	00 
c010590f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105912:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105916:	89 04 24             	mov    %eax,(%esp)
c0105919:	e8 d8 fa ff ff       	call   c01053f6 <page_insert>
c010591e:	85 c0                	test   %eax,%eax
c0105920:	74 24                	je     c0105946 <check_pgdir+0x415>
c0105922:	c7 44 24 0c 60 7d 10 	movl   $0xc0107d60,0xc(%esp)
c0105929:	c0 
c010592a:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105931:	c0 
c0105932:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105939:	00 
c010593a:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105941:	e8 a4 b3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 2);
c0105946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105949:	89 04 24             	mov    %eax,(%esp)
c010594c:	e8 c2 ef ff ff       	call   c0104913 <page_ref>
c0105951:	83 f8 02             	cmp    $0x2,%eax
c0105954:	74 24                	je     c010597a <check_pgdir+0x449>
c0105956:	c7 44 24 0c 8c 7d 10 	movl   $0xc0107d8c,0xc(%esp)
c010595d:	c0 
c010595e:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105965:	c0 
c0105966:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c010596d:	00 
c010596e:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105975:	e8 70 b3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c010597a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010597d:	89 04 24             	mov    %eax,(%esp)
c0105980:	e8 8e ef ff ff       	call   c0104913 <page_ref>
c0105985:	85 c0                	test   %eax,%eax
c0105987:	74 24                	je     c01059ad <check_pgdir+0x47c>
c0105989:	c7 44 24 0c 9e 7d 10 	movl   $0xc0107d9e,0xc(%esp)
c0105990:	c0 
c0105991:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105998:	c0 
c0105999:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c01059a0:	00 
c01059a1:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01059a8:	e8 3d b3 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01059ad:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01059b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059b9:	00 
c01059ba:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01059c1:	00 
c01059c2:	89 04 24             	mov    %eax,(%esp)
c01059c5:	e8 eb f7 ff ff       	call   c01051b5 <get_pte>
c01059ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059d1:	75 24                	jne    c01059f7 <check_pgdir+0x4c6>
c01059d3:	c7 44 24 0c ec 7c 10 	movl   $0xc0107cec,0xc(%esp)
c01059da:	c0 
c01059db:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c01059e2:	c0 
c01059e3:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01059ea:	00 
c01059eb:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c01059f2:	e8 f3 b2 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c01059f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059fa:	8b 00                	mov    (%eax),%eax
c01059fc:	89 04 24             	mov    %eax,(%esp)
c01059ff:	e8 b5 ee ff ff       	call   c01048b9 <pte2page>
c0105a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105a07:	74 24                	je     c0105a2d <check_pgdir+0x4fc>
c0105a09:	c7 44 24 0c 61 7c 10 	movl   $0xc0107c61,0xc(%esp)
c0105a10:	c0 
c0105a11:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105a18:	c0 
c0105a19:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105a20:	00 
c0105a21:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105a28:	e8 bd b2 ff ff       	call   c0100cea <__panic>
    assert((*ptep & PTE_U) == 0);
c0105a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a30:	8b 00                	mov    (%eax),%eax
c0105a32:	83 e0 04             	and    $0x4,%eax
c0105a35:	85 c0                	test   %eax,%eax
c0105a37:	74 24                	je     c0105a5d <check_pgdir+0x52c>
c0105a39:	c7 44 24 0c b0 7d 10 	movl   $0xc0107db0,0xc(%esp)
c0105a40:	c0 
c0105a41:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105a48:	c0 
c0105a49:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105a50:	00 
c0105a51:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105a58:	e8 8d b2 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, 0x0);
c0105a5d:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105a62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a69:	00 
c0105a6a:	89 04 24             	mov    %eax,(%esp)
c0105a6d:	e8 3d f9 ff ff       	call   c01053af <page_remove>
    assert(page_ref(p1) == 1);
c0105a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a75:	89 04 24             	mov    %eax,(%esp)
c0105a78:	e8 96 ee ff ff       	call   c0104913 <page_ref>
c0105a7d:	83 f8 01             	cmp    $0x1,%eax
c0105a80:	74 24                	je     c0105aa6 <check_pgdir+0x575>
c0105a82:	c7 44 24 0c 77 7c 10 	movl   $0xc0107c77,0xc(%esp)
c0105a89:	c0 
c0105a8a:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105a91:	c0 
c0105a92:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105a99:	00 
c0105a9a:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105aa1:	e8 44 b2 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0105aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aa9:	89 04 24             	mov    %eax,(%esp)
c0105aac:	e8 62 ee ff ff       	call   c0104913 <page_ref>
c0105ab1:	85 c0                	test   %eax,%eax
c0105ab3:	74 24                	je     c0105ad9 <check_pgdir+0x5a8>
c0105ab5:	c7 44 24 0c 9e 7d 10 	movl   $0xc0107d9e,0xc(%esp)
c0105abc:	c0 
c0105abd:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105ac4:	c0 
c0105ac5:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105acc:	00 
c0105acd:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105ad4:	e8 11 b2 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105ad9:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105ade:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ae5:	00 
c0105ae6:	89 04 24             	mov    %eax,(%esp)
c0105ae9:	e8 c1 f8 ff ff       	call   c01053af <page_remove>
    assert(page_ref(p1) == 0);
c0105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af1:	89 04 24             	mov    %eax,(%esp)
c0105af4:	e8 1a ee ff ff       	call   c0104913 <page_ref>
c0105af9:	85 c0                	test   %eax,%eax
c0105afb:	74 24                	je     c0105b21 <check_pgdir+0x5f0>
c0105afd:	c7 44 24 0c c5 7d 10 	movl   $0xc0107dc5,0xc(%esp)
c0105b04:	c0 
c0105b05:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105b0c:	c0 
c0105b0d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105b14:	00 
c0105b15:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105b1c:	e8 c9 b1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0105b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b24:	89 04 24             	mov    %eax,(%esp)
c0105b27:	e8 e7 ed ff ff       	call   c0104913 <page_ref>
c0105b2c:	85 c0                	test   %eax,%eax
c0105b2e:	74 24                	je     c0105b54 <check_pgdir+0x623>
c0105b30:	c7 44 24 0c 9e 7d 10 	movl   $0xc0107d9e,0xc(%esp)
c0105b37:	c0 
c0105b38:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105b3f:	c0 
c0105b40:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105b47:	00 
c0105b48:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105b4f:	e8 96 b1 ff ff       	call   c0100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105b54:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105b59:	8b 00                	mov    (%eax),%eax
c0105b5b:	89 04 24             	mov    %eax,(%esp)
c0105b5e:	e8 96 ed ff ff       	call   c01048f9 <pde2page>
c0105b63:	89 04 24             	mov    %eax,(%esp)
c0105b66:	e8 a8 ed ff ff       	call   c0104913 <page_ref>
c0105b6b:	83 f8 01             	cmp    $0x1,%eax
c0105b6e:	74 24                	je     c0105b94 <check_pgdir+0x663>
c0105b70:	c7 44 24 0c d8 7d 10 	movl   $0xc0107dd8,0xc(%esp)
c0105b77:	c0 
c0105b78:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105b7f:	c0 
c0105b80:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105b87:	00 
c0105b88:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105b8f:	e8 56 b1 ff ff       	call   c0100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105b94:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105b99:	8b 00                	mov    (%eax),%eax
c0105b9b:	89 04 24             	mov    %eax,(%esp)
c0105b9e:	e8 56 ed ff ff       	call   c01048f9 <pde2page>
c0105ba3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105baa:	00 
c0105bab:	89 04 24             	mov    %eax,(%esp)
c0105bae:	e8 aa ef ff ff       	call   c0104b5d <free_pages>
    boot_pgdir[0] = 0;
c0105bb3:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105bbe:	c7 04 24 ff 7d 10 c0 	movl   $0xc0107dff,(%esp)
c0105bc5:	e8 9b a7 ff ff       	call   c0100365 <cprintf>
}
c0105bca:	90                   	nop
c0105bcb:	89 ec                	mov    %ebp,%esp
c0105bcd:	5d                   	pop    %ebp
c0105bce:	c3                   	ret    

c0105bcf <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
c0105bcf:	55                   	push   %ebp
c0105bd0:	89 e5                	mov    %esp,%ebp
c0105bd2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
c0105bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105bdc:	e9 ca 00 00 00       	jmp    c0105cab <check_boot_pgdir+0xdc>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bea:	c1 e8 0c             	shr    $0xc,%eax
c0105bed:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105bf0:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105bf5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105bf8:	72 23                	jb     c0105c1d <check_boot_pgdir+0x4e>
c0105bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c01:	c7 44 24 08 44 7a 10 	movl   $0xc0107a44,0x8(%esp)
c0105c08:	c0 
c0105c09:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105c10:	00 
c0105c11:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105c18:	e8 cd b0 ff ff       	call   c0100cea <__panic>
c0105c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c20:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105c25:	89 c2                	mov    %eax,%edx
c0105c27:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c2c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c33:	00 
c0105c34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c38:	89 04 24             	mov    %eax,(%esp)
c0105c3b:	e8 75 f5 ff ff       	call   c01051b5 <get_pte>
c0105c40:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105c43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105c47:	75 24                	jne    c0105c6d <check_boot_pgdir+0x9e>
c0105c49:	c7 44 24 0c 1c 7e 10 	movl   $0xc0107e1c,0xc(%esp)
c0105c50:	c0 
c0105c51:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105c58:	c0 
c0105c59:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105c60:	00 
c0105c61:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105c68:	e8 7d b0 ff ff       	call   c0100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105c6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c70:	8b 00                	mov    (%eax),%eax
c0105c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105c77:	89 c2                	mov    %eax,%edx
c0105c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c7c:	39 c2                	cmp    %eax,%edx
c0105c7e:	74 24                	je     c0105ca4 <check_boot_pgdir+0xd5>
c0105c80:	c7 44 24 0c 59 7e 10 	movl   $0xc0107e59,0xc(%esp)
c0105c87:	c0 
c0105c88:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105c8f:	c0 
c0105c90:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0105c97:	00 
c0105c98:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105c9f:	e8 46 b0 ff ff       	call   c0100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE)
c0105ca4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cae:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105cb3:	39 c2                	cmp    %eax,%edx
c0105cb5:	0f 82 26 ff ff ff    	jb     c0105be1 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105cbb:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105cc0:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105cc5:	8b 00                	mov    (%eax),%eax
c0105cc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ccc:	89 c2                	mov    %eax,%edx
c0105cce:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cd6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105cdd:	77 23                	ja     c0105d02 <check_boot_pgdir+0x133>
c0105cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ce6:	c7 44 24 08 e8 7a 10 	movl   $0xc0107ae8,0x8(%esp)
c0105ced:	c0 
c0105cee:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105cf5:	00 
c0105cf6:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105cfd:	e8 e8 af ff ff       	call   c0100cea <__panic>
c0105d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d05:	05 00 00 00 40       	add    $0x40000000,%eax
c0105d0a:	39 d0                	cmp    %edx,%eax
c0105d0c:	74 24                	je     c0105d32 <check_boot_pgdir+0x163>
c0105d0e:	c7 44 24 0c 70 7e 10 	movl   $0xc0107e70,0xc(%esp)
c0105d15:	c0 
c0105d16:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105d1d:	c0 
c0105d1e:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105d25:	00 
c0105d26:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105d2d:	e8 b8 af ff ff       	call   c0100cea <__panic>

    assert(boot_pgdir[0] == 0);
c0105d32:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d37:	8b 00                	mov    (%eax),%eax
c0105d39:	85 c0                	test   %eax,%eax
c0105d3b:	74 24                	je     c0105d61 <check_boot_pgdir+0x192>
c0105d3d:	c7 44 24 0c a4 7e 10 	movl   $0xc0107ea4,0xc(%esp)
c0105d44:	c0 
c0105d45:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105d4c:	c0 
c0105d4d:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c0105d54:	00 
c0105d55:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105d5c:	e8 89 af ff ff       	call   c0100cea <__panic>

    struct Page *p;
    p = alloc_page();
c0105d61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d68:	e8 b6 ed ff ff       	call   c0104b23 <alloc_pages>
c0105d6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105d70:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d75:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105d7c:	00 
c0105d7d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105d84:	00 
c0105d85:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d88:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d8c:	89 04 24             	mov    %eax,(%esp)
c0105d8f:	e8 62 f6 ff ff       	call   c01053f6 <page_insert>
c0105d94:	85 c0                	test   %eax,%eax
c0105d96:	74 24                	je     c0105dbc <check_boot_pgdir+0x1ed>
c0105d98:	c7 44 24 0c b8 7e 10 	movl   $0xc0107eb8,0xc(%esp)
c0105d9f:	c0 
c0105da0:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105da7:	c0 
c0105da8:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105daf:	00 
c0105db0:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105db7:	e8 2e af ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 1);
c0105dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dbf:	89 04 24             	mov    %eax,(%esp)
c0105dc2:	e8 4c eb ff ff       	call   c0104913 <page_ref>
c0105dc7:	83 f8 01             	cmp    $0x1,%eax
c0105dca:	74 24                	je     c0105df0 <check_boot_pgdir+0x221>
c0105dcc:	c7 44 24 0c e6 7e 10 	movl   $0xc0107ee6,0xc(%esp)
c0105dd3:	c0 
c0105dd4:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105ddb:	c0 
c0105ddc:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105de3:	00 
c0105de4:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105deb:	e8 fa ae ff ff       	call   c0100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105df0:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105df5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105dfc:	00 
c0105dfd:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105e04:	00 
c0105e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e08:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e0c:	89 04 24             	mov    %eax,(%esp)
c0105e0f:	e8 e2 f5 ff ff       	call   c01053f6 <page_insert>
c0105e14:	85 c0                	test   %eax,%eax
c0105e16:	74 24                	je     c0105e3c <check_boot_pgdir+0x26d>
c0105e18:	c7 44 24 0c f8 7e 10 	movl   $0xc0107ef8,0xc(%esp)
c0105e1f:	c0 
c0105e20:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105e27:	c0 
c0105e28:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105e2f:	00 
c0105e30:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105e37:	e8 ae ae ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 2);
c0105e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e3f:	89 04 24             	mov    %eax,(%esp)
c0105e42:	e8 cc ea ff ff       	call   c0104913 <page_ref>
c0105e47:	83 f8 02             	cmp    $0x2,%eax
c0105e4a:	74 24                	je     c0105e70 <check_boot_pgdir+0x2a1>
c0105e4c:	c7 44 24 0c 2f 7f 10 	movl   $0xc0107f2f,0xc(%esp)
c0105e53:	c0 
c0105e54:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105e5b:	c0 
c0105e5c:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0105e63:	00 
c0105e64:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105e6b:	e8 7a ae ff ff       	call   c0100cea <__panic>

    const char *str = "ucore: Hello world!!";
c0105e70:	c7 45 e8 40 7f 10 c0 	movl   $0xc0107f40,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e7e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105e85:	e8 fc 09 00 00       	call   c0106886 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105e8a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105e91:	00 
c0105e92:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105e99:	e8 60 0a 00 00       	call   c01068fe <strcmp>
c0105e9e:	85 c0                	test   %eax,%eax
c0105ea0:	74 24                	je     c0105ec6 <check_boot_pgdir+0x2f7>
c0105ea2:	c7 44 24 0c 58 7f 10 	movl   $0xc0107f58,0xc(%esp)
c0105ea9:	c0 
c0105eaa:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105eb1:	c0 
c0105eb2:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0105eb9:	00 
c0105eba:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105ec1:	e8 24 ae ff ff       	call   c0100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ec9:	89 04 24             	mov    %eax,(%esp)
c0105ecc:	e8 92 e9 ff ff       	call   c0104863 <page2kva>
c0105ed1:	05 00 01 00 00       	add    $0x100,%eax
c0105ed6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105ed9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105ee0:	e8 47 09 00 00       	call   c010682c <strlen>
c0105ee5:	85 c0                	test   %eax,%eax
c0105ee7:	74 24                	je     c0105f0d <check_boot_pgdir+0x33e>
c0105ee9:	c7 44 24 0c 90 7f 10 	movl   $0xc0107f90,0xc(%esp)
c0105ef0:	c0 
c0105ef1:	c7 44 24 08 31 7b 10 	movl   $0xc0107b31,0x8(%esp)
c0105ef8:	c0 
c0105ef9:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0105f00:	00 
c0105f01:	c7 04 24 0c 7b 10 c0 	movl   $0xc0107b0c,(%esp)
c0105f08:	e8 dd ad ff ff       	call   c0100cea <__panic>

    free_page(p);
c0105f0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f14:	00 
c0105f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f18:	89 04 24             	mov    %eax,(%esp)
c0105f1b:	e8 3d ec ff ff       	call   c0104b5d <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105f20:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105f25:	8b 00                	mov    (%eax),%eax
c0105f27:	89 04 24             	mov    %eax,(%esp)
c0105f2a:	e8 ca e9 ff ff       	call   c01048f9 <pde2page>
c0105f2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f36:	00 
c0105f37:	89 04 24             	mov    %eax,(%esp)
c0105f3a:	e8 1e ec ff ff       	call   c0104b5d <free_pages>
    boot_pgdir[0] = 0;
c0105f3f:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105f4a:	c7 04 24 b4 7f 10 c0 	movl   $0xc0107fb4,(%esp)
c0105f51:	e8 0f a4 ff ff       	call   c0100365 <cprintf>
}
c0105f56:	90                   	nop
c0105f57:	89 ec                	mov    %ebp,%esp
c0105f59:	5d                   	pop    %ebp
c0105f5a:	c3                   	ret    

c0105f5b <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
c0105f5b:	55                   	push   %ebp
c0105f5c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f61:	83 e0 04             	and    $0x4,%eax
c0105f64:	85 c0                	test   %eax,%eax
c0105f66:	74 04                	je     c0105f6c <perm2str+0x11>
c0105f68:	b0 75                	mov    $0x75,%al
c0105f6a:	eb 02                	jmp    c0105f6e <perm2str+0x13>
c0105f6c:	b0 2d                	mov    $0x2d,%al
c0105f6e:	a2 28 ef 11 c0       	mov    %al,0xc011ef28
    str[1] = 'r';
c0105f73:	c6 05 29 ef 11 c0 72 	movb   $0x72,0xc011ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f7d:	83 e0 02             	and    $0x2,%eax
c0105f80:	85 c0                	test   %eax,%eax
c0105f82:	74 04                	je     c0105f88 <perm2str+0x2d>
c0105f84:	b0 77                	mov    $0x77,%al
c0105f86:	eb 02                	jmp    c0105f8a <perm2str+0x2f>
c0105f88:	b0 2d                	mov    $0x2d,%al
c0105f8a:	a2 2a ef 11 c0       	mov    %al,0xc011ef2a
    str[3] = '\0';
c0105f8f:	c6 05 2b ef 11 c0 00 	movb   $0x0,0xc011ef2b
    return str;
c0105f96:	b8 28 ef 11 c0       	mov    $0xc011ef28,%eax
}
c0105f9b:	5d                   	pop    %ebp
c0105f9c:	c3                   	ret    

c0105f9d <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
c0105f9d:	55                   	push   %ebp
c0105f9e:	89 e5                	mov    %esp,%ebp
c0105fa0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
c0105fa3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fa6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105fa9:	72 0d                	jb     c0105fb8 <get_pgtable_items+0x1b>
    {
        return 0;
c0105fab:	b8 00 00 00 00       	mov    $0x0,%eax
c0105fb0:	e9 98 00 00 00       	jmp    c010604d <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
c0105fb5:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
c0105fb8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fbb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105fbe:	73 18                	jae    c0105fd8 <get_pgtable_items+0x3b>
c0105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105fca:	8b 45 14             	mov    0x14(%ebp),%eax
c0105fcd:	01 d0                	add    %edx,%eax
c0105fcf:	8b 00                	mov    (%eax),%eax
c0105fd1:	83 e0 01             	and    $0x1,%eax
c0105fd4:	85 c0                	test   %eax,%eax
c0105fd6:	74 dd                	je     c0105fb5 <get_pgtable_items+0x18>
    }
    if (start < right)
c0105fd8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fdb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105fde:	73 68                	jae    c0106048 <get_pgtable_items+0xab>
    {
        if (left_store != NULL)
c0105fe0:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105fe4:	74 08                	je     c0105fee <get_pgtable_items+0x51>
        {
            *left_store = start;
c0105fe6:	8b 45 18             	mov    0x18(%ebp),%eax
c0105fe9:	8b 55 10             	mov    0x10(%ebp),%edx
c0105fec:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c0105fee:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ff1:	8d 50 01             	lea    0x1(%eax),%edx
c0105ff4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ff7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105ffe:	8b 45 14             	mov    0x14(%ebp),%eax
c0106001:	01 d0                	add    %edx,%eax
c0106003:	8b 00                	mov    (%eax),%eax
c0106005:	83 e0 07             	and    $0x7,%eax
c0106008:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c010600b:	eb 03                	jmp    c0106010 <get_pgtable_items+0x73>
        {
            start++;
c010600d:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c0106010:	8b 45 10             	mov    0x10(%ebp),%eax
c0106013:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106016:	73 1d                	jae    c0106035 <get_pgtable_items+0x98>
c0106018:	8b 45 10             	mov    0x10(%ebp),%eax
c010601b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106022:	8b 45 14             	mov    0x14(%ebp),%eax
c0106025:	01 d0                	add    %edx,%eax
c0106027:	8b 00                	mov    (%eax),%eax
c0106029:	83 e0 07             	and    $0x7,%eax
c010602c:	89 c2                	mov    %eax,%edx
c010602e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106031:	39 c2                	cmp    %eax,%edx
c0106033:	74 d8                	je     c010600d <get_pgtable_items+0x70>
        }
        if (right_store != NULL)
c0106035:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106039:	74 08                	je     c0106043 <get_pgtable_items+0xa6>
        {
            *right_store = start;
c010603b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010603e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106041:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106043:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106046:	eb 05                	jmp    c010604d <get_pgtable_items+0xb0>
    }
    return 0;
c0106048:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010604d:	89 ec                	mov    %ebp,%esp
c010604f:	5d                   	pop    %ebp
c0106050:	c3                   	ret    

c0106051 <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
c0106051:	55                   	push   %ebp
c0106052:	89 e5                	mov    %esp,%ebp
c0106054:	57                   	push   %edi
c0106055:	56                   	push   %esi
c0106056:	53                   	push   %ebx
c0106057:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010605a:	c7 04 24 d4 7f 10 c0 	movl   $0xc0107fd4,(%esp)
c0106061:	e8 ff a2 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c0106066:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c010606d:	e9 f2 00 00 00       	jmp    c0106164 <print_pgdir+0x113>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106075:	89 04 24             	mov    %eax,(%esp)
c0106078:	e8 de fe ff ff       	call   c0105f5b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010607d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106080:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106083:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106085:	89 d6                	mov    %edx,%esi
c0106087:	c1 e6 16             	shl    $0x16,%esi
c010608a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010608d:	89 d3                	mov    %edx,%ebx
c010608f:	c1 e3 16             	shl    $0x16,%ebx
c0106092:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106095:	89 d1                	mov    %edx,%ecx
c0106097:	c1 e1 16             	shl    $0x16,%ecx
c010609a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010609d:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01060a0:	29 fa                	sub    %edi,%edx
c01060a2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01060a6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01060aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01060ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01060b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060b6:	c7 04 24 05 80 10 c0 	movl   $0xc0108005,(%esp)
c01060bd:	e8 a3 a2 ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01060c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01060c5:	c1 e0 0a             	shl    $0xa,%eax
c01060c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c01060cb:	eb 50                	jmp    c010611d <print_pgdir+0xcc>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01060cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060d0:	89 04 24             	mov    %eax,(%esp)
c01060d3:	e8 83 fe ff ff       	call   c0105f5b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01060d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01060db:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01060de:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01060e0:	89 d6                	mov    %edx,%esi
c01060e2:	c1 e6 0c             	shl    $0xc,%esi
c01060e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01060e8:	89 d3                	mov    %edx,%ebx
c01060ea:	c1 e3 0c             	shl    $0xc,%ebx
c01060ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01060f0:	89 d1                	mov    %edx,%ecx
c01060f2:	c1 e1 0c             	shl    $0xc,%ecx
c01060f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01060f8:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01060fb:	29 fa                	sub    %edi,%edx
c01060fd:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106101:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106105:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106109:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010610d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106111:	c7 04 24 24 80 10 c0 	movl   $0xc0108024,(%esp)
c0106118:	e8 48 a2 ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c010611d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0106122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106125:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106128:	89 d3                	mov    %edx,%ebx
c010612a:	c1 e3 0a             	shl    $0xa,%ebx
c010612d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106130:	89 d1                	mov    %edx,%ecx
c0106132:	c1 e1 0a             	shl    $0xa,%ecx
c0106135:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0106138:	89 54 24 14          	mov    %edx,0x14(%esp)
c010613c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010613f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106143:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106147:	89 44 24 08          	mov    %eax,0x8(%esp)
c010614b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010614f:	89 0c 24             	mov    %ecx,(%esp)
c0106152:	e8 46 fe ff ff       	call   c0105f9d <get_pgtable_items>
c0106157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010615a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010615e:	0f 85 69 ff ff ff    	jne    c01060cd <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c0106164:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0106169:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010616c:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010616f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106173:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0106176:	89 54 24 10          	mov    %edx,0x10(%esp)
c010617a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010617e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106182:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106189:	00 
c010618a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106191:	e8 07 fe ff ff       	call   c0105f9d <get_pgtable_items>
c0106196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106199:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010619d:	0f 85 cf fe ff ff    	jne    c0106072 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01061a3:	c7 04 24 48 80 10 c0 	movl   $0xc0108048,(%esp)
c01061aa:	e8 b6 a1 ff ff       	call   c0100365 <cprintf>
}
c01061af:	90                   	nop
c01061b0:	83 c4 4c             	add    $0x4c,%esp
c01061b3:	5b                   	pop    %ebx
c01061b4:	5e                   	pop    %esi
c01061b5:	5f                   	pop    %edi
c01061b6:	5d                   	pop    %ebp
c01061b7:	c3                   	ret    

c01061b8 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
c01061b8:	55                   	push   %ebp
c01061b9:	89 e5                	mov    %esp,%ebp
c01061bb:	83 ec 58             	sub    $0x58,%esp
c01061be:	8b 45 10             	mov    0x10(%ebp),%eax
c01061c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01061c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01061c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01061ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01061cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01061d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01061d6:	8b 45 18             	mov    0x18(%ebp),%eax
c01061d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061df:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01061e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01061e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01061ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061f2:	74 1c                	je     c0106210 <printnum+0x58>
c01061f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061f7:	ba 00 00 00 00       	mov    $0x0,%edx
c01061fc:	f7 75 e4             	divl   -0x1c(%ebp)
c01061ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0106202:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106205:	ba 00 00 00 00       	mov    $0x0,%edx
c010620a:	f7 75 e4             	divl   -0x1c(%ebp)
c010620d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106210:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106213:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106216:	f7 75 e4             	divl   -0x1c(%ebp)
c0106219:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010621c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010621f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106222:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106225:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106228:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010622b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010622e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
c0106231:	8b 45 18             	mov    0x18(%ebp),%eax
c0106234:	ba 00 00 00 00       	mov    $0x0,%edx
c0106239:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010623c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010623f:	19 d1                	sbb    %edx,%ecx
c0106241:	72 4c                	jb     c010628f <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
c0106243:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106246:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106249:	8b 45 20             	mov    0x20(%ebp),%eax
c010624c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0106250:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106254:	8b 45 18             	mov    0x18(%ebp),%eax
c0106257:	89 44 24 10          	mov    %eax,0x10(%esp)
c010625b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010625e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106261:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106265:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106269:	8b 45 0c             	mov    0xc(%ebp),%eax
c010626c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106270:	8b 45 08             	mov    0x8(%ebp),%eax
c0106273:	89 04 24             	mov    %eax,(%esp)
c0106276:	e8 3d ff ff ff       	call   c01061b8 <printnum>
c010627b:	eb 1b                	jmp    c0106298 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
c010627d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106280:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106284:	8b 45 20             	mov    0x20(%ebp),%eax
c0106287:	89 04 24             	mov    %eax,(%esp)
c010628a:	8b 45 08             	mov    0x8(%ebp),%eax
c010628d:	ff d0                	call   *%eax
        while (--width > 0)
c010628f:	ff 4d 1c             	decl   0x1c(%ebp)
c0106292:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106296:	7f e5                	jg     c010627d <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106298:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010629b:	05 fc 80 10 c0       	add    $0xc01080fc,%eax
c01062a0:	0f b6 00             	movzbl (%eax),%eax
c01062a3:	0f be c0             	movsbl %al,%eax
c01062a6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01062a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062ad:	89 04 24             	mov    %eax,(%esp)
c01062b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01062b3:	ff d0                	call   *%eax
}
c01062b5:	90                   	nop
c01062b6:	89 ec                	mov    %ebp,%esp
c01062b8:	5d                   	pop    %ebp
c01062b9:	c3                   	ret    

c01062ba <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
c01062ba:	55                   	push   %ebp
c01062bb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c01062bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01062c1:	7e 14                	jle    c01062d7 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
c01062c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01062c6:	8b 00                	mov    (%eax),%eax
c01062c8:	8d 48 08             	lea    0x8(%eax),%ecx
c01062cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01062ce:	89 0a                	mov    %ecx,(%edx)
c01062d0:	8b 50 04             	mov    0x4(%eax),%edx
c01062d3:	8b 00                	mov    (%eax),%eax
c01062d5:	eb 30                	jmp    c0106307 <getuint+0x4d>
    }
    else if (lflag)
c01062d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01062db:	74 16                	je     c01062f3 <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
c01062dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01062e0:	8b 00                	mov    (%eax),%eax
c01062e2:	8d 48 04             	lea    0x4(%eax),%ecx
c01062e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01062e8:	89 0a                	mov    %ecx,(%edx)
c01062ea:	8b 00                	mov    (%eax),%eax
c01062ec:	ba 00 00 00 00       	mov    $0x0,%edx
c01062f1:	eb 14                	jmp    c0106307 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
c01062f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01062f6:	8b 00                	mov    (%eax),%eax
c01062f8:	8d 48 04             	lea    0x4(%eax),%ecx
c01062fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01062fe:	89 0a                	mov    %ecx,(%edx)
c0106300:	8b 00                	mov    (%eax),%eax
c0106302:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106307:	5d                   	pop    %ebp
c0106308:	c3                   	ret    

c0106309 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
c0106309:	55                   	push   %ebp
c010630a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c010630c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106310:	7e 14                	jle    c0106326 <getint+0x1d>
    {
        return va_arg(*ap, long long);
c0106312:	8b 45 08             	mov    0x8(%ebp),%eax
c0106315:	8b 00                	mov    (%eax),%eax
c0106317:	8d 48 08             	lea    0x8(%eax),%ecx
c010631a:	8b 55 08             	mov    0x8(%ebp),%edx
c010631d:	89 0a                	mov    %ecx,(%edx)
c010631f:	8b 50 04             	mov    0x4(%eax),%edx
c0106322:	8b 00                	mov    (%eax),%eax
c0106324:	eb 28                	jmp    c010634e <getint+0x45>
    }
    else if (lflag)
c0106326:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010632a:	74 12                	je     c010633e <getint+0x35>
    {
        return va_arg(*ap, long);
c010632c:	8b 45 08             	mov    0x8(%ebp),%eax
c010632f:	8b 00                	mov    (%eax),%eax
c0106331:	8d 48 04             	lea    0x4(%eax),%ecx
c0106334:	8b 55 08             	mov    0x8(%ebp),%edx
c0106337:	89 0a                	mov    %ecx,(%edx)
c0106339:	8b 00                	mov    (%eax),%eax
c010633b:	99                   	cltd   
c010633c:	eb 10                	jmp    c010634e <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
c010633e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106341:	8b 00                	mov    (%eax),%eax
c0106343:	8d 48 04             	lea    0x4(%eax),%ecx
c0106346:	8b 55 08             	mov    0x8(%ebp),%edx
c0106349:	89 0a                	mov    %ecx,(%edx)
c010634b:	8b 00                	mov    (%eax),%eax
c010634d:	99                   	cltd   
    }
}
c010634e:	5d                   	pop    %ebp
c010634f:	c3                   	ret    

c0106350 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
c0106350:	55                   	push   %ebp
c0106351:	89 e5                	mov    %esp,%ebp
c0106353:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0106356:	8d 45 14             	lea    0x14(%ebp),%eax
c0106359:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010635c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010635f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106363:	8b 45 10             	mov    0x10(%ebp),%eax
c0106366:	89 44 24 08          	mov    %eax,0x8(%esp)
c010636a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010636d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106371:	8b 45 08             	mov    0x8(%ebp),%eax
c0106374:	89 04 24             	mov    %eax,(%esp)
c0106377:	e8 05 00 00 00       	call   c0106381 <vprintfmt>
    va_end(ap);
}
c010637c:	90                   	nop
c010637d:	89 ec                	mov    %ebp,%esp
c010637f:	5d                   	pop    %ebp
c0106380:	c3                   	ret    

c0106381 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
c0106381:	55                   	push   %ebp
c0106382:	89 e5                	mov    %esp,%ebp
c0106384:	56                   	push   %esi
c0106385:	53                   	push   %ebx
c0106386:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
c0106389:	eb 17                	jmp    c01063a2 <vprintfmt+0x21>
        {
            if (ch == '\0')
c010638b:	85 db                	test   %ebx,%ebx
c010638d:	0f 84 bf 03 00 00    	je     c0106752 <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
c0106393:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106396:	89 44 24 04          	mov    %eax,0x4(%esp)
c010639a:	89 1c 24             	mov    %ebx,(%esp)
c010639d:	8b 45 08             	mov    0x8(%ebp),%eax
c01063a0:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
c01063a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01063a5:	8d 50 01             	lea    0x1(%eax),%edx
c01063a8:	89 55 10             	mov    %edx,0x10(%ebp)
c01063ab:	0f b6 00             	movzbl (%eax),%eax
c01063ae:	0f b6 d8             	movzbl %al,%ebx
c01063b1:	83 fb 25             	cmp    $0x25,%ebx
c01063b4:	75 d5                	jne    c010638b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01063b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01063ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01063c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01063c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01063ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01063d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
c01063d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01063d7:	8d 50 01             	lea    0x1(%eax),%edx
c01063da:	89 55 10             	mov    %edx,0x10(%ebp)
c01063dd:	0f b6 00             	movzbl (%eax),%eax
c01063e0:	0f b6 d8             	movzbl %al,%ebx
c01063e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01063e6:	83 f8 55             	cmp    $0x55,%eax
c01063e9:	0f 87 37 03 00 00    	ja     c0106726 <vprintfmt+0x3a5>
c01063ef:	8b 04 85 20 81 10 c0 	mov    -0x3fef7ee0(,%eax,4),%eax
c01063f6:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
c01063f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01063fc:	eb d6                	jmp    c01063d4 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01063fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106402:	eb d0                	jmp    c01063d4 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
c0106404:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
c010640b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010640e:	89 d0                	mov    %edx,%eax
c0106410:	c1 e0 02             	shl    $0x2,%eax
c0106413:	01 d0                	add    %edx,%eax
c0106415:	01 c0                	add    %eax,%eax
c0106417:	01 d8                	add    %ebx,%eax
c0106419:	83 e8 30             	sub    $0x30,%eax
c010641c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010641f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106422:	0f b6 00             	movzbl (%eax),%eax
c0106425:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
c0106428:	83 fb 2f             	cmp    $0x2f,%ebx
c010642b:	7e 38                	jle    c0106465 <vprintfmt+0xe4>
c010642d:	83 fb 39             	cmp    $0x39,%ebx
c0106430:	7f 33                	jg     c0106465 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
c0106432:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0106435:	eb d4                	jmp    c010640b <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0106437:	8b 45 14             	mov    0x14(%ebp),%eax
c010643a:	8d 50 04             	lea    0x4(%eax),%edx
c010643d:	89 55 14             	mov    %edx,0x14(%ebp)
c0106440:	8b 00                	mov    (%eax),%eax
c0106442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106445:	eb 1f                	jmp    c0106466 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0106447:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010644b:	79 87                	jns    c01063d4 <vprintfmt+0x53>
                width = 0;
c010644d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106454:	e9 7b ff ff ff       	jmp    c01063d4 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0106459:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106460:	e9 6f ff ff ff       	jmp    c01063d4 <vprintfmt+0x53>
            goto process_precision;
c0106465:	90                   	nop

        process_precision:
            if (width < 0)
c0106466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010646a:	0f 89 64 ff ff ff    	jns    c01063d4 <vprintfmt+0x53>
                width = precision, precision = -1;
c0106470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106473:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010647d:	e9 52 ff ff ff       	jmp    c01063d4 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
c0106482:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0106485:	e9 4a ff ff ff       	jmp    c01063d4 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010648a:	8b 45 14             	mov    0x14(%ebp),%eax
c010648d:	8d 50 04             	lea    0x4(%eax),%edx
c0106490:	89 55 14             	mov    %edx,0x14(%ebp)
c0106493:	8b 00                	mov    (%eax),%eax
c0106495:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106498:	89 54 24 04          	mov    %edx,0x4(%esp)
c010649c:	89 04 24             	mov    %eax,(%esp)
c010649f:	8b 45 08             	mov    0x8(%ebp),%eax
c01064a2:	ff d0                	call   *%eax
            break;
c01064a4:	e9 a4 02 00 00       	jmp    c010674d <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01064a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01064ac:	8d 50 04             	lea    0x4(%eax),%edx
c01064af:	89 55 14             	mov    %edx,0x14(%ebp)
c01064b2:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
c01064b4:	85 db                	test   %ebx,%ebx
c01064b6:	79 02                	jns    c01064ba <vprintfmt+0x139>
            {
                err = -err;
c01064b8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
c01064ba:	83 fb 06             	cmp    $0x6,%ebx
c01064bd:	7f 0b                	jg     c01064ca <vprintfmt+0x149>
c01064bf:	8b 34 9d e0 80 10 c0 	mov    -0x3fef7f20(,%ebx,4),%esi
c01064c6:	85 f6                	test   %esi,%esi
c01064c8:	75 23                	jne    c01064ed <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
c01064ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01064ce:	c7 44 24 08 0d 81 10 	movl   $0xc010810d,0x8(%esp)
c01064d5:	c0 
c01064d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01064dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01064e0:	89 04 24             	mov    %eax,(%esp)
c01064e3:	e8 68 fe ff ff       	call   c0106350 <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01064e8:	e9 60 02 00 00       	jmp    c010674d <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01064ed:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01064f1:	c7 44 24 08 16 81 10 	movl   $0xc0108116,0x8(%esp)
c01064f8:	c0 
c01064f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106500:	8b 45 08             	mov    0x8(%ebp),%eax
c0106503:	89 04 24             	mov    %eax,(%esp)
c0106506:	e8 45 fe ff ff       	call   c0106350 <printfmt>
            break;
c010650b:	e9 3d 02 00 00       	jmp    c010674d <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
c0106510:	8b 45 14             	mov    0x14(%ebp),%eax
c0106513:	8d 50 04             	lea    0x4(%eax),%edx
c0106516:	89 55 14             	mov    %edx,0x14(%ebp)
c0106519:	8b 30                	mov    (%eax),%esi
c010651b:	85 f6                	test   %esi,%esi
c010651d:	75 05                	jne    c0106524 <vprintfmt+0x1a3>
            {
                p = "(null)";
c010651f:	be 19 81 10 c0       	mov    $0xc0108119,%esi
            }
            if (width > 0 && padc != '-')
c0106524:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106528:	7e 76                	jle    c01065a0 <vprintfmt+0x21f>
c010652a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010652e:	74 70                	je     c01065a0 <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
c0106530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106533:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106537:	89 34 24             	mov    %esi,(%esp)
c010653a:	e8 16 03 00 00       	call   c0106855 <strnlen>
c010653f:	89 c2                	mov    %eax,%edx
c0106541:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106544:	29 d0                	sub    %edx,%eax
c0106546:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106549:	eb 16                	jmp    c0106561 <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
c010654b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010654f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106552:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106556:	89 04 24             	mov    %eax,(%esp)
c0106559:	8b 45 08             	mov    0x8(%ebp),%eax
c010655c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
c010655e:	ff 4d e8             	decl   -0x18(%ebp)
c0106561:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106565:	7f e4                	jg     c010654b <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0106567:	eb 37                	jmp    c01065a0 <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
c0106569:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010656d:	74 1f                	je     c010658e <vprintfmt+0x20d>
c010656f:	83 fb 1f             	cmp    $0x1f,%ebx
c0106572:	7e 05                	jle    c0106579 <vprintfmt+0x1f8>
c0106574:	83 fb 7e             	cmp    $0x7e,%ebx
c0106577:	7e 15                	jle    c010658e <vprintfmt+0x20d>
                {
                    putch('?', putdat);
c0106579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010657c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106580:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106587:	8b 45 08             	mov    0x8(%ebp),%eax
c010658a:	ff d0                	call   *%eax
c010658c:	eb 0f                	jmp    c010659d <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
c010658e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106591:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106595:	89 1c 24             	mov    %ebx,(%esp)
c0106598:	8b 45 08             	mov    0x8(%ebp),%eax
c010659b:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c010659d:	ff 4d e8             	decl   -0x18(%ebp)
c01065a0:	89 f0                	mov    %esi,%eax
c01065a2:	8d 70 01             	lea    0x1(%eax),%esi
c01065a5:	0f b6 00             	movzbl (%eax),%eax
c01065a8:	0f be d8             	movsbl %al,%ebx
c01065ab:	85 db                	test   %ebx,%ebx
c01065ad:	74 27                	je     c01065d6 <vprintfmt+0x255>
c01065af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01065b3:	78 b4                	js     c0106569 <vprintfmt+0x1e8>
c01065b5:	ff 4d e4             	decl   -0x1c(%ebp)
c01065b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01065bc:	79 ab                	jns    c0106569 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
c01065be:	eb 16                	jmp    c01065d6 <vprintfmt+0x255>
            {
                putch(' ', putdat);
c01065c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01065ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01065d1:	ff d0                	call   *%eax
            for (; width > 0; width--)
c01065d3:	ff 4d e8             	decl   -0x18(%ebp)
c01065d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01065da:	7f e4                	jg     c01065c0 <vprintfmt+0x23f>
            }
            break;
c01065dc:	e9 6c 01 00 00       	jmp    c010674d <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01065e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01065e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065e8:	8d 45 14             	lea    0x14(%ebp),%eax
c01065eb:	89 04 24             	mov    %eax,(%esp)
c01065ee:	e8 16 fd ff ff       	call   c0106309 <getint>
c01065f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
c01065f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01065ff:	85 d2                	test   %edx,%edx
c0106601:	79 26                	jns    c0106629 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
c0106603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106606:	89 44 24 04          	mov    %eax,0x4(%esp)
c010660a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0106611:	8b 45 08             	mov    0x8(%ebp),%eax
c0106614:	ff d0                	call   *%eax
                num = -(long long)num;
c0106616:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106619:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010661c:	f7 d8                	neg    %eax
c010661e:	83 d2 00             	adc    $0x0,%edx
c0106621:	f7 da                	neg    %edx
c0106623:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106626:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106629:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106630:	e9 a8 00 00 00       	jmp    c01066dd <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106635:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010663c:	8d 45 14             	lea    0x14(%ebp),%eax
c010663f:	89 04 24             	mov    %eax,(%esp)
c0106642:	e8 73 fc ff ff       	call   c01062ba <getuint>
c0106647:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010664a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010664d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106654:	e9 84 00 00 00       	jmp    c01066dd <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106659:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010665c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106660:	8d 45 14             	lea    0x14(%ebp),%eax
c0106663:	89 04 24             	mov    %eax,(%esp)
c0106666:	e8 4f fc ff ff       	call   c01062ba <getuint>
c010666b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010666e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106671:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106678:	eb 63                	jmp    c01066dd <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010667a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010667d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106681:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106688:	8b 45 08             	mov    0x8(%ebp),%eax
c010668b:	ff d0                	call   *%eax
            putch('x', putdat);
c010668d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106690:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106694:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010669b:	8b 45 08             	mov    0x8(%ebp),%eax
c010669e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01066a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01066a3:	8d 50 04             	lea    0x4(%eax),%edx
c01066a6:	89 55 14             	mov    %edx,0x14(%ebp)
c01066a9:	8b 00                	mov    (%eax),%eax
c01066ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01066b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01066bc:	eb 1f                	jmp    c01066dd <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01066be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066c5:	8d 45 14             	lea    0x14(%ebp),%eax
c01066c8:	89 04 24             	mov    %eax,(%esp)
c01066cb:	e8 ea fb ff ff       	call   c01062ba <getuint>
c01066d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01066d6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01066dd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01066e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066e4:	89 54 24 18          	mov    %edx,0x18(%esp)
c01066e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01066eb:	89 54 24 14          	mov    %edx,0x14(%esp)
c01066ef:	89 44 24 10          	mov    %eax,0x10(%esp)
c01066f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01066f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01066fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106701:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106704:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106708:	8b 45 08             	mov    0x8(%ebp),%eax
c010670b:	89 04 24             	mov    %eax,(%esp)
c010670e:	e8 a5 fa ff ff       	call   c01061b8 <printnum>
            break;
c0106713:	eb 38                	jmp    c010674d <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106715:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106718:	89 44 24 04          	mov    %eax,0x4(%esp)
c010671c:	89 1c 24             	mov    %ebx,(%esp)
c010671f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106722:	ff d0                	call   *%eax
            break;
c0106724:	eb 27                	jmp    c010674d <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106726:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010672d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106734:	8b 45 08             	mov    0x8(%ebp),%eax
c0106737:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
c0106739:	ff 4d 10             	decl   0x10(%ebp)
c010673c:	eb 03                	jmp    c0106741 <vprintfmt+0x3c0>
c010673e:	ff 4d 10             	decl   0x10(%ebp)
c0106741:	8b 45 10             	mov    0x10(%ebp),%eax
c0106744:	48                   	dec    %eax
c0106745:	0f b6 00             	movzbl (%eax),%eax
c0106748:	3c 25                	cmp    $0x25,%al
c010674a:	75 f2                	jne    c010673e <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c010674c:	90                   	nop
    {
c010674d:	e9 37 fc ff ff       	jmp    c0106389 <vprintfmt+0x8>
                return;
c0106752:	90                   	nop
        }
    }
}
c0106753:	83 c4 40             	add    $0x40,%esp
c0106756:	5b                   	pop    %ebx
c0106757:	5e                   	pop    %esi
c0106758:	5d                   	pop    %ebp
c0106759:	c3                   	ret    

c010675a <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
c010675a:	55                   	push   %ebp
c010675b:	89 e5                	mov    %esp,%ebp
    b->cnt++;
c010675d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106760:	8b 40 08             	mov    0x8(%eax),%eax
c0106763:	8d 50 01             	lea    0x1(%eax),%edx
c0106766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106769:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
c010676c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010676f:	8b 10                	mov    (%eax),%edx
c0106771:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106774:	8b 40 04             	mov    0x4(%eax),%eax
c0106777:	39 c2                	cmp    %eax,%edx
c0106779:	73 12                	jae    c010678d <sprintputch+0x33>
    {
        *b->buf++ = ch;
c010677b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010677e:	8b 00                	mov    (%eax),%eax
c0106780:	8d 48 01             	lea    0x1(%eax),%ecx
c0106783:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106786:	89 0a                	mov    %ecx,(%edx)
c0106788:	8b 55 08             	mov    0x8(%ebp),%edx
c010678b:	88 10                	mov    %dl,(%eax)
    }
}
c010678d:	90                   	nop
c010678e:	5d                   	pop    %ebp
c010678f:	c3                   	ret    

c0106790 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
c0106790:	55                   	push   %ebp
c0106791:	89 e5                	mov    %esp,%ebp
c0106793:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106796:	8d 45 14             	lea    0x14(%ebp),%eax
c0106799:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010679c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010679f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01067a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01067b4:	89 04 24             	mov    %eax,(%esp)
c01067b7:	e8 0a 00 00 00       	call   c01067c6 <vsnprintf>
c01067bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01067bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01067c2:	89 ec                	mov    %ebp,%esp
c01067c4:	5d                   	pop    %ebp
c01067c5:	c3                   	ret    

c01067c6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
c01067c6:	55                   	push   %ebp
c01067c7:	89 e5                	mov    %esp,%ebp
c01067c9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01067cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01067cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01067d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067d5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01067d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01067db:	01 d0                	add    %edx,%eax
c01067dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
c01067e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01067eb:	74 0a                	je     c01067f7 <vsnprintf+0x31>
c01067ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01067f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067f3:	39 c2                	cmp    %eax,%edx
c01067f5:	76 07                	jbe    c01067fe <vsnprintf+0x38>
    {
        return -E_INVAL;
c01067f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01067fc:	eb 2a                	jmp    c0106828 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
c01067fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0106801:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106805:	8b 45 10             	mov    0x10(%ebp),%eax
c0106808:	89 44 24 08          	mov    %eax,0x8(%esp)
c010680c:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010680f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106813:	c7 04 24 5a 67 10 c0 	movl   $0xc010675a,(%esp)
c010681a:	e8 62 fb ff ff       	call   c0106381 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010681f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106822:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106825:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106828:	89 ec                	mov    %ebp,%esp
c010682a:	5d                   	pop    %ebp
c010682b:	c3                   	ret    

c010682c <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
c010682c:	55                   	push   %ebp
c010682d:	89 e5                	mov    %esp,%ebp
c010682f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106832:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
c0106839:	eb 03                	jmp    c010683e <strlen+0x12>
    {
        cnt++;
c010683b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
c010683e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106841:	8d 50 01             	lea    0x1(%eax),%edx
c0106844:	89 55 08             	mov    %edx,0x8(%ebp)
c0106847:	0f b6 00             	movzbl (%eax),%eax
c010684a:	84 c0                	test   %al,%al
c010684c:	75 ed                	jne    c010683b <strlen+0xf>
    }
    return cnt;
c010684e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106851:	89 ec                	mov    %ebp,%esp
c0106853:	5d                   	pop    %ebp
c0106854:	c3                   	ret    

c0106855 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
c0106855:	55                   	push   %ebp
c0106856:	89 e5                	mov    %esp,%ebp
c0106858:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010685b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c0106862:	eb 03                	jmp    c0106867 <strnlen+0x12>
    {
        cnt++;
c0106864:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c0106867:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010686a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010686d:	73 10                	jae    c010687f <strnlen+0x2a>
c010686f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106872:	8d 50 01             	lea    0x1(%eax),%edx
c0106875:	89 55 08             	mov    %edx,0x8(%ebp)
c0106878:	0f b6 00             	movzbl (%eax),%eax
c010687b:	84 c0                	test   %al,%al
c010687d:	75 e5                	jne    c0106864 <strnlen+0xf>
    }
    return cnt;
c010687f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106882:	89 ec                	mov    %ebp,%esp
c0106884:	5d                   	pop    %ebp
c0106885:	c3                   	ret    

c0106886 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
c0106886:	55                   	push   %ebp
c0106887:	89 e5                	mov    %esp,%ebp
c0106889:	57                   	push   %edi
c010688a:	56                   	push   %esi
c010688b:	83 ec 20             	sub    $0x20,%esp
c010688e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106891:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106894:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106897:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
c010689a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010689d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068a0:	89 d1                	mov    %edx,%ecx
c01068a2:	89 c2                	mov    %eax,%edx
c01068a4:	89 ce                	mov    %ecx,%esi
c01068a6:	89 d7                	mov    %edx,%edi
c01068a8:	ac                   	lods   %ds:(%esi),%al
c01068a9:	aa                   	stos   %al,%es:(%edi)
c01068aa:	84 c0                	test   %al,%al
c01068ac:	75 fa                	jne    c01068a8 <strcpy+0x22>
c01068ae:	89 fa                	mov    %edi,%edx
c01068b0:	89 f1                	mov    %esi,%ecx
c01068b2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01068b5:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01068b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
c01068bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01068be:	83 c4 20             	add    $0x20,%esp
c01068c1:	5e                   	pop    %esi
c01068c2:	5f                   	pop    %edi
c01068c3:	5d                   	pop    %ebp
c01068c4:	c3                   	ret    

c01068c5 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
c01068c5:	55                   	push   %ebp
c01068c6:	89 e5                	mov    %esp,%ebp
c01068c8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01068cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01068ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
c01068d1:	eb 1e                	jmp    c01068f1 <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
c01068d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01068d6:	0f b6 10             	movzbl (%eax),%edx
c01068d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068dc:	88 10                	mov    %dl,(%eax)
c01068de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068e1:	0f b6 00             	movzbl (%eax),%eax
c01068e4:	84 c0                	test   %al,%al
c01068e6:	74 03                	je     c01068eb <strncpy+0x26>
        {
            src++;
c01068e8:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
c01068eb:	ff 45 fc             	incl   -0x4(%ebp)
c01068ee:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
c01068f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01068f5:	75 dc                	jne    c01068d3 <strncpy+0xe>
    }
    return dst;
c01068f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01068fa:	89 ec                	mov    %ebp,%esp
c01068fc:	5d                   	pop    %ebp
c01068fd:	c3                   	ret    

c01068fe <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
c01068fe:	55                   	push   %ebp
c01068ff:	89 e5                	mov    %esp,%ebp
c0106901:	57                   	push   %edi
c0106902:	56                   	push   %esi
c0106903:	83 ec 20             	sub    $0x20,%esp
c0106906:	8b 45 08             	mov    0x8(%ebp),%eax
c0106909:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010690c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010690f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
c0106912:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106915:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106918:	89 d1                	mov    %edx,%ecx
c010691a:	89 c2                	mov    %eax,%edx
c010691c:	89 ce                	mov    %ecx,%esi
c010691e:	89 d7                	mov    %edx,%edi
c0106920:	ac                   	lods   %ds:(%esi),%al
c0106921:	ae                   	scas   %es:(%edi),%al
c0106922:	75 08                	jne    c010692c <strcmp+0x2e>
c0106924:	84 c0                	test   %al,%al
c0106926:	75 f8                	jne    c0106920 <strcmp+0x22>
c0106928:	31 c0                	xor    %eax,%eax
c010692a:	eb 04                	jmp    c0106930 <strcmp+0x32>
c010692c:	19 c0                	sbb    %eax,%eax
c010692e:	0c 01                	or     $0x1,%al
c0106930:	89 fa                	mov    %edi,%edx
c0106932:	89 f1                	mov    %esi,%ecx
c0106934:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106937:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010693a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010693d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0106940:	83 c4 20             	add    $0x20,%esp
c0106943:	5e                   	pop    %esi
c0106944:	5f                   	pop    %edi
c0106945:	5d                   	pop    %ebp
c0106946:	c3                   	ret    

c0106947 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
c0106947:	55                   	push   %ebp
c0106948:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c010694a:	eb 09                	jmp    c0106955 <strncmp+0xe>
    {
        n--, s1++, s2++;
c010694c:	ff 4d 10             	decl   0x10(%ebp)
c010694f:	ff 45 08             	incl   0x8(%ebp)
c0106952:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c0106955:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106959:	74 1a                	je     c0106975 <strncmp+0x2e>
c010695b:	8b 45 08             	mov    0x8(%ebp),%eax
c010695e:	0f b6 00             	movzbl (%eax),%eax
c0106961:	84 c0                	test   %al,%al
c0106963:	74 10                	je     c0106975 <strncmp+0x2e>
c0106965:	8b 45 08             	mov    0x8(%ebp),%eax
c0106968:	0f b6 10             	movzbl (%eax),%edx
c010696b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010696e:	0f b6 00             	movzbl (%eax),%eax
c0106971:	38 c2                	cmp    %al,%dl
c0106973:	74 d7                	je     c010694c <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106975:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106979:	74 18                	je     c0106993 <strncmp+0x4c>
c010697b:	8b 45 08             	mov    0x8(%ebp),%eax
c010697e:	0f b6 00             	movzbl (%eax),%eax
c0106981:	0f b6 d0             	movzbl %al,%edx
c0106984:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106987:	0f b6 00             	movzbl (%eax),%eax
c010698a:	0f b6 c8             	movzbl %al,%ecx
c010698d:	89 d0                	mov    %edx,%eax
c010698f:	29 c8                	sub    %ecx,%eax
c0106991:	eb 05                	jmp    c0106998 <strncmp+0x51>
c0106993:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106998:	5d                   	pop    %ebp
c0106999:	c3                   	ret    

c010699a <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
c010699a:	55                   	push   %ebp
c010699b:	89 e5                	mov    %esp,%ebp
c010699d:	83 ec 04             	sub    $0x4,%esp
c01069a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069a3:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c01069a6:	eb 13                	jmp    c01069bb <strchr+0x21>
    {
        if (*s == c)
c01069a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ab:	0f b6 00             	movzbl (%eax),%eax
c01069ae:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01069b1:	75 05                	jne    c01069b8 <strchr+0x1e>
        {
            return (char *)s;
c01069b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01069b6:	eb 12                	jmp    c01069ca <strchr+0x30>
        }
        s++;
c01069b8:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c01069bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01069be:	0f b6 00             	movzbl (%eax),%eax
c01069c1:	84 c0                	test   %al,%al
c01069c3:	75 e3                	jne    c01069a8 <strchr+0xe>
    }
    return NULL;
c01069c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01069ca:	89 ec                	mov    %ebp,%esp
c01069cc:	5d                   	pop    %ebp
c01069cd:	c3                   	ret    

c01069ce <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
c01069ce:	55                   	push   %ebp
c01069cf:	89 e5                	mov    %esp,%ebp
c01069d1:	83 ec 04             	sub    $0x4,%esp
c01069d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069d7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c01069da:	eb 0e                	jmp    c01069ea <strfind+0x1c>
    {
        if (*s == c)
c01069dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01069df:	0f b6 00             	movzbl (%eax),%eax
c01069e2:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01069e5:	74 0f                	je     c01069f6 <strfind+0x28>
        {
            break;
        }
        s++;
c01069e7:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c01069ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ed:	0f b6 00             	movzbl (%eax),%eax
c01069f0:	84 c0                	test   %al,%al
c01069f2:	75 e8                	jne    c01069dc <strfind+0xe>
c01069f4:	eb 01                	jmp    c01069f7 <strfind+0x29>
            break;
c01069f6:	90                   	nop
    }
    return (char *)s;
c01069f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01069fa:	89 ec                	mov    %ebp,%esp
c01069fc:	5d                   	pop    %ebp
c01069fd:	c3                   	ret    

c01069fe <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
c01069fe:	55                   	push   %ebp
c01069ff:	89 e5                	mov    %esp,%ebp
c0106a01:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0106a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0106a0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
c0106a12:	eb 03                	jmp    c0106a17 <strtol+0x19>
    {
        s++;
c0106a14:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
c0106a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a1a:	0f b6 00             	movzbl (%eax),%eax
c0106a1d:	3c 20                	cmp    $0x20,%al
c0106a1f:	74 f3                	je     c0106a14 <strtol+0x16>
c0106a21:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a24:	0f b6 00             	movzbl (%eax),%eax
c0106a27:	3c 09                	cmp    $0x9,%al
c0106a29:	74 e9                	je     c0106a14 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
c0106a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a2e:	0f b6 00             	movzbl (%eax),%eax
c0106a31:	3c 2b                	cmp    $0x2b,%al
c0106a33:	75 05                	jne    c0106a3a <strtol+0x3c>
    {
        s++;
c0106a35:	ff 45 08             	incl   0x8(%ebp)
c0106a38:	eb 14                	jmp    c0106a4e <strtol+0x50>
    }
    else if (*s == '-')
c0106a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a3d:	0f b6 00             	movzbl (%eax),%eax
c0106a40:	3c 2d                	cmp    $0x2d,%al
c0106a42:	75 0a                	jne    c0106a4e <strtol+0x50>
    {
        s++, neg = 1;
c0106a44:	ff 45 08             	incl   0x8(%ebp)
c0106a47:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
c0106a4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106a52:	74 06                	je     c0106a5a <strtol+0x5c>
c0106a54:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0106a58:	75 22                	jne    c0106a7c <strtol+0x7e>
c0106a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a5d:	0f b6 00             	movzbl (%eax),%eax
c0106a60:	3c 30                	cmp    $0x30,%al
c0106a62:	75 18                	jne    c0106a7c <strtol+0x7e>
c0106a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a67:	40                   	inc    %eax
c0106a68:	0f b6 00             	movzbl (%eax),%eax
c0106a6b:	3c 78                	cmp    $0x78,%al
c0106a6d:	75 0d                	jne    c0106a7c <strtol+0x7e>
    {
        s += 2, base = 16;
c0106a6f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106a73:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0106a7a:	eb 29                	jmp    c0106aa5 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
c0106a7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106a80:	75 16                	jne    c0106a98 <strtol+0x9a>
c0106a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a85:	0f b6 00             	movzbl (%eax),%eax
c0106a88:	3c 30                	cmp    $0x30,%al
c0106a8a:	75 0c                	jne    c0106a98 <strtol+0x9a>
    {
        s++, base = 8;
c0106a8c:	ff 45 08             	incl   0x8(%ebp)
c0106a8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106a96:	eb 0d                	jmp    c0106aa5 <strtol+0xa7>
    }
    else if (base == 0)
c0106a98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106a9c:	75 07                	jne    c0106aa5 <strtol+0xa7>
    {
        base = 10;
c0106a9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
c0106aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa8:	0f b6 00             	movzbl (%eax),%eax
c0106aab:	3c 2f                	cmp    $0x2f,%al
c0106aad:	7e 1b                	jle    c0106aca <strtol+0xcc>
c0106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ab2:	0f b6 00             	movzbl (%eax),%eax
c0106ab5:	3c 39                	cmp    $0x39,%al
c0106ab7:	7f 11                	jg     c0106aca <strtol+0xcc>
        {
            dig = *s - '0';
c0106ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106abc:	0f b6 00             	movzbl (%eax),%eax
c0106abf:	0f be c0             	movsbl %al,%eax
c0106ac2:	83 e8 30             	sub    $0x30,%eax
c0106ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ac8:	eb 48                	jmp    c0106b12 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
c0106aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0106acd:	0f b6 00             	movzbl (%eax),%eax
c0106ad0:	3c 60                	cmp    $0x60,%al
c0106ad2:	7e 1b                	jle    c0106aef <strtol+0xf1>
c0106ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad7:	0f b6 00             	movzbl (%eax),%eax
c0106ada:	3c 7a                	cmp    $0x7a,%al
c0106adc:	7f 11                	jg     c0106aef <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
c0106ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ae1:	0f b6 00             	movzbl (%eax),%eax
c0106ae4:	0f be c0             	movsbl %al,%eax
c0106ae7:	83 e8 57             	sub    $0x57,%eax
c0106aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106aed:	eb 23                	jmp    c0106b12 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
c0106aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0106af2:	0f b6 00             	movzbl (%eax),%eax
c0106af5:	3c 40                	cmp    $0x40,%al
c0106af7:	7e 3b                	jle    c0106b34 <strtol+0x136>
c0106af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106afc:	0f b6 00             	movzbl (%eax),%eax
c0106aff:	3c 5a                	cmp    $0x5a,%al
c0106b01:	7f 31                	jg     c0106b34 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
c0106b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b06:	0f b6 00             	movzbl (%eax),%eax
c0106b09:	0f be c0             	movsbl %al,%eax
c0106b0c:	83 e8 37             	sub    $0x37,%eax
c0106b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
c0106b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b15:	3b 45 10             	cmp    0x10(%ebp),%eax
c0106b18:	7d 19                	jge    c0106b33 <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
c0106b1a:	ff 45 08             	incl   0x8(%ebp)
c0106b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106b20:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106b24:	89 c2                	mov    %eax,%edx
c0106b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b29:	01 d0                	add    %edx,%eax
c0106b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
c0106b2e:	e9 72 ff ff ff       	jmp    c0106aa5 <strtol+0xa7>
            break;
c0106b33:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
c0106b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106b38:	74 08                	je     c0106b42 <strtol+0x144>
    {
        *endptr = (char *)s;
c0106b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106b40:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106b46:	74 07                	je     c0106b4f <strtol+0x151>
c0106b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106b4b:	f7 d8                	neg    %eax
c0106b4d:	eb 03                	jmp    c0106b52 <strtol+0x154>
c0106b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106b52:	89 ec                	mov    %ebp,%esp
c0106b54:	5d                   	pop    %ebp
c0106b55:	c3                   	ret    

c0106b56 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
c0106b56:	55                   	push   %ebp
c0106b57:	89 e5                	mov    %esp,%ebp
c0106b59:	83 ec 28             	sub    $0x28,%esp
c0106b5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0106b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b62:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106b65:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0106b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0106b6f:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0106b72:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
c0106b78:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0106b7b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0106b7f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106b82:	89 d7                	mov    %edx,%edi
c0106b84:	f3 aa                	rep stos %al,%es:(%edi)
c0106b86:	89 fa                	mov    %edi,%edx
c0106b88:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106b8b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
c0106b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0106b91:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0106b94:	89 ec                	mov    %ebp,%esp
c0106b96:	5d                   	pop    %ebp
c0106b97:	c3                   	ret    

c0106b98 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
c0106b98:	55                   	push   %ebp
c0106b99:	89 e5                	mov    %esp,%ebp
c0106b9b:	57                   	push   %edi
c0106b9c:	56                   	push   %esi
c0106b9d:	53                   	push   %ebx
c0106b9e:	83 ec 30             	sub    $0x30,%esp
c0106ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106bad:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
c0106bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bb6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106bb9:	73 42                	jae    c0106bfd <memmove+0x65>
c0106bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bca:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0106bcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106bd0:	c1 e8 02             	shr    $0x2,%eax
c0106bd3:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0106bd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106bdb:	89 d7                	mov    %edx,%edi
c0106bdd:	89 c6                	mov    %eax,%esi
c0106bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106be1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106be4:	83 e1 03             	and    $0x3,%ecx
c0106be7:	74 02                	je     c0106beb <memmove+0x53>
c0106be9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106beb:	89 f0                	mov    %esi,%eax
c0106bed:	89 fa                	mov    %edi,%edx
c0106bef:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106bf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106bf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0106bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0106bfb:	eb 36                	jmp    c0106c33 <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
c0106bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c00:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c06:	01 c2                	add    %eax,%edx
c0106c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c0b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c11:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
c0106c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c17:	89 c1                	mov    %eax,%ecx
c0106c19:	89 d8                	mov    %ebx,%eax
c0106c1b:	89 d6                	mov    %edx,%esi
c0106c1d:	89 c7                	mov    %eax,%edi
c0106c1f:	fd                   	std    
c0106c20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106c22:	fc                   	cld    
c0106c23:	89 f8                	mov    %edi,%eax
c0106c25:	89 f2                	mov    %esi,%edx
c0106c27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106c2a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106c2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106c33:	83 c4 30             	add    $0x30,%esp
c0106c36:	5b                   	pop    %ebx
c0106c37:	5e                   	pop    %esi
c0106c38:	5f                   	pop    %edi
c0106c39:	5d                   	pop    %ebp
c0106c3a:	c3                   	ret    

c0106c3b <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
c0106c3b:	55                   	push   %ebp
c0106c3c:	89 e5                	mov    %esp,%ebp
c0106c3e:	57                   	push   %edi
c0106c3f:	56                   	push   %esi
c0106c40:	83 ec 20             	sub    $0x20,%esp
c0106c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0106c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c58:	c1 e8 02             	shr    $0x2,%eax
c0106c5b:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0106c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c63:	89 d7                	mov    %edx,%edi
c0106c65:	89 c6                	mov    %eax,%esi
c0106c67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106c69:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106c6c:	83 e1 03             	and    $0x3,%ecx
c0106c6f:	74 02                	je     c0106c73 <memcpy+0x38>
c0106c71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106c73:	89 f0                	mov    %esi,%eax
c0106c75:	89 fa                	mov    %edi,%edx
c0106c77:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106c7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0106c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106c83:	83 c4 20             	add    $0x20,%esp
c0106c86:	5e                   	pop    %esi
c0106c87:	5f                   	pop    %edi
c0106c88:	5d                   	pop    %ebp
c0106c89:	c3                   	ret    

c0106c8a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
c0106c8a:	55                   	push   %ebp
c0106c8b:	89 e5                	mov    %esp,%ebp
c0106c8d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106c96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c99:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
c0106c9c:	eb 2e                	jmp    c0106ccc <memcmp+0x42>
    {
        if (*s1 != *s2)
c0106c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ca1:	0f b6 10             	movzbl (%eax),%edx
c0106ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106ca7:	0f b6 00             	movzbl (%eax),%eax
c0106caa:	38 c2                	cmp    %al,%dl
c0106cac:	74 18                	je     c0106cc6 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cb1:	0f b6 00             	movzbl (%eax),%eax
c0106cb4:	0f b6 d0             	movzbl %al,%edx
c0106cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106cba:	0f b6 00             	movzbl (%eax),%eax
c0106cbd:	0f b6 c8             	movzbl %al,%ecx
c0106cc0:	89 d0                	mov    %edx,%eax
c0106cc2:	29 c8                	sub    %ecx,%eax
c0106cc4:	eb 18                	jmp    c0106cde <memcmp+0x54>
        }
        s1++, s2++;
c0106cc6:	ff 45 fc             	incl   -0x4(%ebp)
c0106cc9:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
c0106ccc:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ccf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106cd2:	89 55 10             	mov    %edx,0x10(%ebp)
c0106cd5:	85 c0                	test   %eax,%eax
c0106cd7:	75 c5                	jne    c0106c9e <memcmp+0x14>
    }
    return 0;
c0106cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cde:	89 ec                	mov    %ebp,%esp
c0106ce0:	5d                   	pop    %ebp
c0106ce1:	c3                   	ret    
