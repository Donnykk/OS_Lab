
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
c0100059:	e8 64 6b 00 00       	call   c0106bc2 <memset>

    cons_init(); // init the console
c010005e:	e8 f9 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 60 6d 10 c0 	movl   $0xc0106d60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 7c 6d 10 c0 	movl   $0xc0106d7c,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 95 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init(); // init physical memory management
c0100087:	e8 ad 50 00 00       	call   c0105139 <pmm_init>

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
c010016c:	c7 04 24 81 6d 10 c0 	movl   $0xc0106d81,(%esp)
c0100173:	e8 ed 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	89 c2                	mov    %eax,%edx
c010017e:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c0100183:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100187:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018b:	c7 04 24 8f 6d 10 c0 	movl   $0xc0106d8f,(%esp)
c0100192:	e8 ce 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019b:	89 c2                	mov    %eax,%edx
c010019d:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001aa:	c7 04 24 9d 6d 10 c0 	movl   $0xc0106d9d,(%esp)
c01001b1:	e8 af 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ba:	89 c2                	mov    %eax,%edx
c01001bc:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c9:	c7 04 24 ab 6d 10 c0 	movl   $0xc0106dab,(%esp)
c01001d0:	e8 90 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d9:	89 c2                	mov    %eax,%edx
c01001db:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e8:	c7 04 24 b9 6d 10 c0 	movl   $0xc0106db9,(%esp)
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
c0100225:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 ce ff ff ff       	call   c0100204 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 09 ff ff ff       	call   c0100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 e8 6d 10 c0 	movl   $0xc0106de8,(%esp)
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
c0100269:	c7 04 24 07 6e 10 c0 	movl   $0xc0106e07,(%esp)
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
c0100359:	e8 8f 60 00 00       	call   c01063ed <vprintfmt>
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
c0100569:	c7 00 0c 6e 10 c0    	movl   $0xc0106e0c,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 0c 6e 10 c0 	movl   $0xc0106e0c,0x8(%eax)
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
c01005a0:	c7 45 f4 98 83 10 c0 	movl   $0xc0108398,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 dc 4d 11 c0 	movl   $0xc0114ddc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec dd 4d 11 c0 	movl   $0xc0114ddd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 97 86 11 c0 	movl   $0xc0118697,-0x18(%ebp)

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
c0100708:	e8 2d 63 00 00       	call   c0106a3a <strfind>
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
c010088e:	c7 04 24 16 6e 10 c0 	movl   $0xc0106e16,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 2f 6e 10 c0 	movl   $0xc0106e2f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 4e 6d 10 	movl   $0xc0106d4e,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 47 6e 10 c0 	movl   $0xc0106e47,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 e0 11 	movl   $0xc011e000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 5f 6e 10 c0 	movl   $0xc0106e5f,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 2c ef 11 	movl   $0xc011ef2c,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 77 6e 10 c0 	movl   $0xc0106e77,(%esp)
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
c010090b:	c7 04 24 90 6e 10 c0 	movl   $0xc0106e90,(%esp)
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
c0100942:	c7 04 24 ba 6e 10 c0 	movl   $0xc0106eba,(%esp)
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
c01009b0:	c7 04 24 d6 6e 10 c0 	movl   $0xc0106ed6,(%esp)
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
c0100a07:	c7 04 24 e8 6e 10 c0 	movl   $0xc0106ee8,(%esp)
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
c0100a3a:	c7 04 24 04 6f 10 c0 	movl   $0xc0106f04,(%esp)
c0100a41:	e8 1f f9 ff ff       	call   c0100365 <cprintf>
        for (j = 0; j < 4; j++)
c0100a46:	ff 45 e8             	incl   -0x18(%ebp)
c0100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4d:	7e d6                	jle    c0100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a4f:	c7 04 24 0c 6f 10 c0 	movl   $0xc0106f0c,(%esp)
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
c0100ac4:	c7 04 24 90 6f 10 c0 	movl   $0xc0106f90,(%esp)
c0100acb:	e8 36 5f 00 00       	call   c0106a06 <strchr>
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
c0100aec:	c7 04 24 95 6f 10 c0 	movl   $0xc0106f95,(%esp)
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
c0100b2e:	c7 04 24 90 6f 10 c0 	movl   $0xc0106f90,(%esp)
c0100b35:	e8 cc 5e 00 00       	call   c0106a06 <strchr>
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
c0100b9f:	e8 c6 5d 00 00       	call   c010696a <strcmp>
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
c0100beb:	c7 04 24 b3 6f 10 c0 	movl   $0xc0106fb3,(%esp)
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
c0100c09:	c7 04 24 cc 6f 10 c0 	movl   $0xc0106fcc,(%esp)
c0100c10:	e8 50 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c15:	c7 04 24 f4 6f 10 c0 	movl   $0xc0106ff4,(%esp)
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
c0100c32:	c7 04 24 19 70 10 c0 	movl   $0xc0107019,(%esp)
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
c0100ca2:	c7 04 24 1d 70 10 c0 	movl   $0xc010701d,(%esp)
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
c0100d17:	c7 04 24 26 70 10 c0 	movl   $0xc0107026,(%esp)
c0100d1e:	e8 42 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2d:	89 04 24             	mov    %eax,(%esp)
c0100d30:	e8 fb f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d35:	c7 04 24 42 70 10 c0 	movl   $0xc0107042,(%esp)
c0100d3c:	e8 24 f6 ff ff       	call   c0100365 <cprintf>

    cprintf("stack trackback:\n");
c0100d41:	c7 04 24 44 70 10 c0 	movl   $0xc0107044,(%esp)
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
c0100d82:	c7 04 24 56 70 10 c0 	movl   $0xc0107056,(%esp)
c0100d89:	e8 d7 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d95:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d98:	89 04 24             	mov    %eax,(%esp)
c0100d9b:	e8 90 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da0:	c7 04 24 42 70 10 c0 	movl   $0xc0107042,(%esp)
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
c0100e07:	c7 04 24 74 70 10 c0 	movl   $0xc0107074,(%esp)
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
c0101271:	e8 8e 59 00 00       	call   c0106c04 <memmove>
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
c0101603:	c7 04 24 8f 70 10 c0 	movl   $0xc010708f,(%esp)
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
c010167a:	c7 04 24 9b 70 10 c0 	movl   $0xc010709b,(%esp)
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
c0101935:	c7 04 24 c0 70 10 c0 	movl   $0xc01070c0,(%esp)
c010193c:	e8 24 ea ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101941:	c7 04 24 ca 70 10 c0 	movl   $0xc01070ca,(%esp)
c0101948:	e8 18 ea ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c010194d:	c7 44 24 08 d8 70 10 	movl   $0xc01070d8,0x8(%esp)
c0101954:	c0 
c0101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
c010195c:	00 
c010195d:	c7 04 24 ee 70 10 c0 	movl   $0xc01070ee,(%esp)
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
c0101aeb:	8b 04 85 40 74 10 c0 	mov    -0x3fef8bc0(,%eax,4),%eax
c0101af2:	eb 18                	jmp    c0101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
c0101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101af8:	7e 0d                	jle    c0101b07 <trapname+0x2a>
c0101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101afe:	7f 07                	jg     c0101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
c0101b00:	b8 ff 70 10 c0       	mov    $0xc01070ff,%eax
c0101b05:	eb 05                	jmp    c0101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b07:	b8 12 71 10 c0       	mov    $0xc0107112,%eax
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
c0101b30:	c7 04 24 53 71 10 c0 	movl   $0xc0107153,(%esp)
c0101b37:	e8 29 e8 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	89 04 24             	mov    %eax,(%esp)
c0101b42:	e8 8f 01 00 00       	call   c0101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b52:	c7 04 24 64 71 10 c0 	movl   $0xc0107164,(%esp)
c0101b59:	e8 07 e8 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b69:	c7 04 24 77 71 10 c0 	movl   $0xc0107177,(%esp)
c0101b70:	e8 f0 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 8a 71 10 c0 	movl   $0xc010718a,(%esp)
c0101b87:	e8 d9 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b97:	c7 04 24 9d 71 10 c0 	movl   $0xc010719d,(%esp)
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
c0101bbf:	c7 04 24 b0 71 10 c0 	movl   $0xc01071b0,(%esp)
c0101bc6:	e8 9a e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 34             	mov    0x34(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 c2 71 10 c0 	movl   $0xc01071c2,(%esp)
c0101bdc:	e8 84 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 38             	mov    0x38(%eax),%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 d1 71 10 c0 	movl   $0xc01071d1,(%esp)
c0101bf2:	e8 6e e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c02:	c7 04 24 e0 71 10 c0 	movl   $0xc01071e0,(%esp)
c0101c09:	e8 57 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c11:	8b 40 40             	mov    0x40(%eax),%eax
c0101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c18:	c7 04 24 f3 71 10 c0 	movl   $0xc01071f3,(%esp)
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
c0101c5f:	c7 04 24 02 72 10 c0 	movl   $0xc0107202,(%esp)
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
c0101c89:	c7 04 24 06 72 10 c0 	movl   $0xc0107206,(%esp)
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
c0101cae:	c7 04 24 0f 72 10 c0 	movl   $0xc010720f,(%esp)
c0101cb5:	e8 ab e6 ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc5:	c7 04 24 1e 72 10 c0 	movl   $0xc010721e,(%esp)
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
c0101ce5:	c7 04 24 31 72 10 c0 	movl   $0xc0107231,(%esp)
c0101cec:	e8 74 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf4:	8b 40 04             	mov    0x4(%eax),%eax
c0101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfb:	c7 04 24 40 72 10 c0 	movl   $0xc0107240,(%esp)
c0101d02:	e8 5e e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0a:	8b 40 08             	mov    0x8(%eax),%eax
c0101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d11:	c7 04 24 4f 72 10 c0 	movl   $0xc010724f,(%esp)
c0101d18:	e8 48 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d20:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d27:	c7 04 24 5e 72 10 c0 	movl   $0xc010725e,(%esp)
c0101d2e:	e8 32 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d36:	8b 40 10             	mov    0x10(%eax),%eax
c0101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3d:	c7 04 24 6d 72 10 c0 	movl   $0xc010726d,(%esp)
c0101d44:	e8 1c e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4c:	8b 40 14             	mov    0x14(%eax),%eax
c0101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d53:	c7 04 24 7c 72 10 c0 	movl   $0xc010727c,(%esp)
c0101d5a:	e8 06 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d62:	8b 40 18             	mov    0x18(%eax),%eax
c0101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d69:	c7 04 24 8b 72 10 c0 	movl   $0xc010728b,(%esp)
c0101d70:	e8 f0 e5 ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7f:	c7 04 24 9a 72 10 c0 	movl   $0xc010729a,(%esp)
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
c0101e34:	c7 04 24 a9 72 10 c0 	movl   $0xc01072a9,(%esp)
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
c0101e5d:	c7 04 24 bb 72 10 c0 	movl   $0xc01072bb,(%esp)
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
c0101f30:	c7 44 24 08 ca 72 10 	movl   $0xc01072ca,0x8(%esp)
c0101f37:	c0 
c0101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0101f3f:	00 
c0101f40:	c7 04 24 ee 70 10 c0 	movl   $0xc01070ee,(%esp)
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
c0102a64:	c7 44 24 08 90 74 10 	movl   $0xc0107490,0x8(%esp)
c0102a6b:	c0 
c0102a6c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a73:	00 
c0102a74:	c7 04 24 b3 74 10 c0 	movl   $0xc01074b3,(%esp)
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

c0102aa4 <ROUND_UP_LOG>:

#define IS_POWER_OF_2(x) (!((x) & ((x)-1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int ROUND_UP_LOG(int size)
{
c0102aa4:	55                   	push   %ebp
c0102aa5:	89 e5                	mov    %esp,%ebp
c0102aa7:	83 ec 10             	sub    $0x10,%esp
    int n = 0, tmp = size;
c0102aaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (tmp >>= 1)
c0102ab7:	eb 03                	jmp    c0102abc <ROUND_UP_LOG+0x18>
    {
        n++;
c0102ab9:	ff 45 fc             	incl   -0x4(%ebp)
    while (tmp >>= 1)
c0102abc:	d1 7d f8             	sarl   -0x8(%ebp)
c0102abf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102ac3:	75 f4                	jne    c0102ab9 <ROUND_UP_LOG+0x15>
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
    // 首先对页进行初始化
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
c0102b3e:	c7 44 24 0c c1 74 10 	movl   $0xc01074c1,0xc(%esp)
c0102b45:	c0 
c0102b46:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0102b4d:	c0 
c0102b4e:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
c0102b55:	00 
c0102b56:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
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
    // 获取 buddy_manager 数组的长度
    manager_size = 2 * (1 << ROUND_UP_LOG(n));
c0102bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bc9:	89 04 24             	mov    %eax,(%esp)
c0102bcc:	e8 d3 fe ff ff       	call   c0102aa4 <ROUND_UP_LOG>
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
    // 调整 base
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
    // buddy数组的下标[1 … manager_size]有效
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
    cprintf("===================buddy init end===================\n");
c0102cae:	c7 04 24 fc 74 10 c0 	movl   $0xc01074fc,(%esp)
c0102cb5:	e8 ab d6 ff ff       	call   c0100365 <cprintf>
    cprintf("free_size = %d\n", free_page_num);
c0102cba:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cc3:	c7 04 24 32 75 10 c0 	movl   $0xc0107532,(%esp)
c0102cca:	e8 96 d6 ff ff       	call   c0100365 <cprintf>
    cprintf("buddy_size = %d\n", manager_size);
c0102ccf:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cd8:	c7 04 24 42 75 10 c0 	movl   $0xc0107542,(%esp)
c0102cdf:	e8 81 d6 ff ff       	call   c0100365 <cprintf>
    cprintf("buddy_addr = 0x%08x\n", buddy_manager);
c0102ce4:	a1 80 ee 11 c0       	mov    0xc011ee80,%eax
c0102ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102ced:	c7 04 24 53 75 10 c0 	movl   $0xc0107553,(%esp)
c0102cf4:	e8 6c d6 ff ff       	call   c0100365 <cprintf>
    cprintf("manager_page_base = 0x%08x\n", page_base);
c0102cf9:	a1 84 ee 11 c0       	mov    0xc011ee84,%eax
c0102cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102d02:	c7 04 24 68 75 10 c0 	movl   $0xc0107568,(%esp)
c0102d09:	e8 57 d6 ff ff       	call   c0100365 <cprintf>
    cprintf("====================================================\n");
c0102d0e:	c7 04 24 84 75 10 c0 	movl   $0xc0107584,(%esp)
c0102d15:	e8 4b d6 ff ff       	call   c0100365 <cprintf>
}
c0102d1a:	90                   	nop
c0102d1b:	89 ec                	mov    %ebp,%esp
c0102d1d:	5d                   	pop    %ebp
c0102d1e:	c3                   	ret    

c0102d1f <buddy_alloc>:

int buddy_alloc(int size)
{
c0102d1f:	55                   	push   %ebp
c0102d20:	89 e5                	mov    %esp,%ebp
c0102d22:	83 ec 28             	sub    $0x28,%esp
c0102d25:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    unsigned index = 1;
c0102d28:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    unsigned offset = 0;
c0102d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    unsigned node_size;
    // 将size向上取整为2的幂
    if (size <= 0)
c0102d36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d3a:	7f 09                	jg     c0102d45 <buddy_alloc+0x26>
        size = 1;
c0102d3c:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
c0102d43:	eb 24                	jmp    c0102d69 <buddy_alloc+0x4a>
    else if (!IS_POWER_OF_2(size))
c0102d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d48:	48                   	dec    %eax
c0102d49:	23 45 08             	and    0x8(%ebp),%eax
c0102d4c:	85 c0                	test   %eax,%eax
c0102d4e:	74 19                	je     c0102d69 <buddy_alloc+0x4a>
        size = 1 << ROUND_UP_LOG(size);
c0102d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d53:	89 04 24             	mov    %eax,(%esp)
c0102d56:	e8 49 fd ff ff       	call   c0102aa4 <ROUND_UP_LOG>
c0102d5b:	ba 01 00 00 00       	mov    $0x1,%edx
c0102d60:	88 c1                	mov    %al,%cl
c0102d62:	d3 e2                	shl    %cl,%edx
c0102d64:	89 d0                	mov    %edx,%eax
c0102d66:	89 45 08             	mov    %eax,0x8(%ebp)
    if (buddy_manager[index] < size)
c0102d69:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d72:	c1 e0 02             	shl    $0x2,%eax
c0102d75:	01 d0                	add    %edx,%eax
c0102d77:	8b 10                	mov    (%eax),%edx
c0102d79:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7c:	39 c2                	cmp    %eax,%edx
c0102d7e:	73 0a                	jae    c0102d8a <buddy_alloc+0x6b>
        return -1;
c0102d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102d85:	e9 e1 00 00 00       	jmp    c0102e6b <buddy_alloc+0x14c>
    // 从根节点往下深度遍历，找到恰好等于size的块
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
c0102d8a:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102d8f:	89 c2                	mov    %eax,%edx
c0102d91:	c1 ea 1f             	shr    $0x1f,%edx
c0102d94:	01 d0                	add    %edx,%eax
c0102d96:	d1 f8                	sar    %eax
c0102d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d9b:	eb 2d                	jmp    c0102dca <buddy_alloc+0xab>
    {
        if (buddy_manager[LEFT_LEAF(index)] >= size)
c0102d9d:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da6:	c1 e0 03             	shl    $0x3,%eax
c0102da9:	01 d0                	add    %edx,%eax
c0102dab:	8b 10                	mov    (%eax),%edx
c0102dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db0:	39 c2                	cmp    %eax,%edx
c0102db2:	72 05                	jb     c0102db9 <buddy_alloc+0x9a>
            index = LEFT_LEAF(index);
c0102db4:	d1 65 f4             	shll   -0xc(%ebp)
c0102db7:	eb 09                	jmp    c0102dc2 <buddy_alloc+0xa3>
        else
            index = RIGHT_LEAF(index);
c0102db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbc:	01 c0                	add    %eax,%eax
c0102dbe:	40                   	inc    %eax
c0102dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (node_size = manager_size / 2; node_size != size; node_size /= 2)
c0102dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dc5:	d1 e8                	shr    %eax
c0102dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102dd0:	75 cb                	jne    c0102d9d <buddy_alloc+0x7e>
    }
    // 将找到的块取出分配
    buddy_manager[index] = 0;
c0102dd2:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ddb:	c1 e0 02             	shl    $0x2,%eax
c0102dde:	01 d0                	add    %edx,%eax
c0102de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    // 计算块在所有块内存中的索引
    offset = (index)*node_size - manager_size / 2;
c0102de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de9:	0f af 45 f0          	imul   -0x10(%ebp),%eax
c0102ded:	89 c2                	mov    %eax,%edx
c0102def:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c0102df4:	89 c1                	mov    %eax,%ecx
c0102df6:	c1 e9 1f             	shr    $0x1f,%ecx
c0102df9:	01 c8                	add    %ecx,%eax
c0102dfb:	d1 f8                	sar    %eax
c0102dfd:	89 c1                	mov    %eax,%ecx
c0102dff:	89 d0                	mov    %edx,%eax
c0102e01:	29 c8                	sub    %ecx,%eax
c0102e03:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf(" index:%u offset:%u ", index, offset);
c0102e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e09:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e14:	c7 04 24 ba 75 10 c0 	movl   $0xc01075ba,(%esp)
c0102e1b:	e8 45 d5 ff ff       	call   c0100365 <cprintf>
    // 向上回溯至根节点，修改沿途节点的大小
    while (index > 1)
c0102e20:	eb 40                	jmp    c0102e62 <buddy_alloc+0x143>
    {
        index = PARENT(index);
c0102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e25:	d1 e8                	shr    %eax
c0102e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        buddy_manager[index] = MAX(buddy_manager[LEFT_LEAF(index)], buddy_manager[RIGHT_LEAF(index)]);
c0102e2a:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e33:	c1 e0 03             	shl    $0x3,%eax
c0102e36:	83 c0 04             	add    $0x4,%eax
c0102e39:	01 d0                	add    %edx,%eax
c0102e3b:	8b 10                	mov    (%eax),%edx
c0102e3d:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c0102e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e46:	c1 e0 03             	shl    $0x3,%eax
c0102e49:	01 c8                	add    %ecx,%eax
c0102e4b:	8b 00                	mov    (%eax),%eax
c0102e4d:	8b 1d 80 ee 11 c0    	mov    0xc011ee80,%ebx
c0102e53:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0102e56:	c1 e1 02             	shl    $0x2,%ecx
c0102e59:	01 d9                	add    %ebx,%ecx
c0102e5b:	39 c2                	cmp    %eax,%edx
c0102e5d:	0f 43 c2             	cmovae %edx,%eax
c0102e60:	89 01                	mov    %eax,(%ecx)
    while (index > 1)
c0102e62:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
c0102e66:	77 ba                	ja     c0102e22 <buddy_alloc+0x103>
    }
    return offset;
c0102e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
c0102e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102e6e:	89 ec                	mov    %ebp,%esp
c0102e70:	5d                   	pop    %ebp
c0102e71:	c3                   	ret    

c0102e72 <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n)
{
c0102e72:	55                   	push   %ebp
c0102e73:	89 e5                	mov    %esp,%ebp
c0102e75:	83 ec 38             	sub    $0x38,%esp
    cprintf("alloc %u pages", n);
c0102e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e7f:	c7 04 24 cf 75 10 c0 	movl   $0xc01075cf,(%esp)
c0102e86:	e8 da d4 ff ff       	call   c0100365 <cprintf>
    assert(n > 0);
c0102e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102e8f:	75 24                	jne    c0102eb5 <buddy_alloc_pages+0x43>
c0102e91:	c7 44 24 0c de 75 10 	movl   $0xc01075de,0xc(%esp)
c0102e98:	c0 
c0102e99:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0102ea0:	c0 
c0102ea1:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0102ea8:	00 
c0102ea9:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c0102eb0:	e8 35 de ff ff       	call   c0100cea <__panic>
    if (n > free_page_num)
c0102eb5:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102eba:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102ebd:	76 0a                	jbe    c0102ec9 <buddy_alloc_pages+0x57>
        return NULL;
c0102ebf:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ec4:	e9 a3 00 00 00       	jmp    c0102f6c <buddy_alloc_pages+0xfa>
    // 获取分配的页在内存中的起始地址
    int offset = buddy_alloc(n);
c0102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ecc:	89 04 24             	mov    %eax,(%esp)
c0102ecf:	e8 4b fe ff ff       	call   c0102d1f <buddy_alloc>
c0102ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *base = page_base + offset;
c0102ed7:	8b 0d 84 ee 11 c0    	mov    0xc011ee84,%ecx
c0102edd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102ee0:	89 d0                	mov    %edx,%eax
c0102ee2:	c1 e0 02             	shl    $0x2,%eax
c0102ee5:	01 d0                	add    %edx,%eax
c0102ee7:	c1 e0 02             	shl    $0x2,%eax
c0102eea:	01 c8                	add    %ecx,%eax
c0102eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    struct Page *page;
    // 将n向上取整，因为有round_n个块被取出
    int round_n = 1 << ROUND_UP_LOG(n);
c0102eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef2:	89 04 24             	mov    %eax,(%esp)
c0102ef5:	e8 aa fb ff ff       	call   c0102aa4 <ROUND_UP_LOG>
c0102efa:	ba 01 00 00 00       	mov    $0x1,%edx
c0102eff:	88 c1                	mov    %al,%cl
c0102f01:	d3 e2                	shl    %cl,%edx
c0102f03:	89 d0                	mov    %edx,%eax
c0102f05:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // 将每一个取出的块由空闲态改为保留态
    for (page = base; page != base + round_n; page++)
c0102f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f0e:	eb 1e                	jmp    c0102f2e <buddy_alloc_pages+0xbc>
    {
        ClearPageProperty(page);
c0102f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f13:	83 c0 04             	add    $0x4,%eax
c0102f16:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile("btrl %1, %0"
c0102f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f26:	0f b3 10             	btr    %edx,(%eax)
}
c0102f29:	90                   	nop
    for (page = base; page != base + round_n; page++)
c0102f2a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102f2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102f31:	89 d0                	mov    %edx,%eax
c0102f33:	c1 e0 02             	shl    $0x2,%eax
c0102f36:	01 d0                	add    %edx,%eax
c0102f38:	c1 e0 02             	shl    $0x2,%eax
c0102f3b:	89 c2                	mov    %eax,%edx
c0102f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f40:	01 d0                	add    %edx,%eax
c0102f42:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102f45:	75 c9                	jne    c0102f10 <buddy_alloc_pages+0x9e>
    }
    free_page_num -= round_n;
c0102f47:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102f4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0102f4f:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    base->property = n;
c0102f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f57:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f5a:	89 50 08             	mov    %edx,0x8(%eax)
    cprintf("finish!\n");
c0102f5d:	c7 04 24 e4 75 10 c0 	movl   $0xc01075e4,(%esp)
c0102f64:	e8 fc d3 ff ff       	call   c0100365 <cprintf>
    return base;
c0102f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
c0102f6c:	89 ec                	mov    %ebp,%esp
c0102f6e:	5d                   	pop    %ebp
c0102f6f:	c3                   	ret    

c0102f70 <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n)
{
c0102f70:	55                   	push   %ebp
c0102f71:	89 e5                	mov    %esp,%ebp
c0102f73:	83 ec 58             	sub    $0x58,%esp
    cprintf("free  %u pages", n);
c0102f76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102f7d:	c7 04 24 ed 75 10 c0 	movl   $0xc01075ed,(%esp)
c0102f84:	e8 dc d3 ff ff       	call   c0100365 <cprintf>
    // STEP1: 重置pages中对应的page
    assert(n > 0);
c0102f89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102f8d:	75 24                	jne    c0102fb3 <buddy_free_pages+0x43>
c0102f8f:	c7 44 24 0c de 75 10 	movl   $0xc01075de,0xc(%esp)
c0102f96:	c0 
c0102f97:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0102f9e:	c0 
c0102f9f:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
c0102fa6:	00 
c0102fa7:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c0102fae:	e8 37 dd ff ff       	call   c0100cea <__panic>
    n = 1 << ROUND_UP_LOG(n);
c0102fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fb6:	89 04 24             	mov    %eax,(%esp)
c0102fb9:	e8 e6 fa ff ff       	call   c0102aa4 <ROUND_UP_LOG>
c0102fbe:	ba 01 00 00 00       	mov    $0x1,%edx
c0102fc3:	88 c1                	mov    %al,%cl
c0102fc5:	d3 e2                	shl    %cl,%edx
c0102fc7:	89 d0                	mov    %edx,%eax
c0102fc9:	89 45 0c             	mov    %eax,0xc(%ebp)
    // 保证base原先处于保留态
    assert(!PageReserved(base));
c0102fcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fcf:	83 c0 04             	add    $0x4,%eax
c0102fd2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102fdc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102fdf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe2:	0f a3 10             	bt     %edx,(%eax)
c0102fe5:	19 c0                	sbb    %eax,%eax
c0102fe7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102fea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102fee:	0f 95 c0             	setne  %al
c0102ff1:	0f b6 c0             	movzbl %al,%eax
c0102ff4:	85 c0                	test   %eax,%eax
c0102ff6:	74 24                	je     c010301c <buddy_free_pages+0xac>
c0102ff8:	c7 44 24 0c fc 75 10 	movl   $0xc01075fc,0xc(%esp)
c0102fff:	c0 
c0103000:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0103007:	c0 
c0103008:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
c010300f:	00 
c0103010:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c0103017:	e8 ce dc ff ff       	call   c0100cea <__panic>
    for (struct Page *p = base; p < base + n; p++)
c010301c:	8b 45 08             	mov    0x8(%ebp),%eax
c010301f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103022:	e9 93 00 00 00       	jmp    c01030ba <buddy_free_pages+0x14a>
    {
        assert(!PageReserved(p) && !PageProperty(p)); //确认该帧已经被分配，且不是保留帧
c0103027:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010302a:	83 c0 04             	add    $0x4,%eax
c010302d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c0103034:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103037:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010303a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010303d:	0f a3 10             	bt     %edx,(%eax)
c0103040:	19 c0                	sbb    %eax,%eax
c0103042:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103045:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103049:	0f 95 c0             	setne  %al
c010304c:	0f b6 c0             	movzbl %al,%eax
c010304f:	85 c0                	test   %eax,%eax
c0103051:	75 2c                	jne    c010307f <buddy_free_pages+0x10f>
c0103053:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103056:	83 c0 04             	add    $0x4,%eax
c0103059:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103060:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103063:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103066:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103069:	0f a3 10             	bt     %edx,(%eax)
c010306c:	19 c0                	sbb    %eax,%eax
c010306e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0103071:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103075:	0f 95 c0             	setne  %al
c0103078:	0f b6 c0             	movzbl %al,%eax
c010307b:	85 c0                	test   %eax,%eax
c010307d:	74 24                	je     c01030a3 <buddy_free_pages+0x133>
c010307f:	c7 44 24 0c 10 76 10 	movl   $0xc0107610,0xc(%esp)
c0103086:	c0 
c0103087:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c010308e:	c0 
c010308f:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0103096:	00 
c0103097:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c010309e:	e8 47 dc ff ff       	call   c0100cea <__panic>
        // 在此作者（ZJK）认为：由于不需要property，将所有page的property flag置为0即可
        set_page_ref(p, 0);
c01030a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01030aa:	00 
c01030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030ae:	89 04 24             	mov    %eax,(%esp)
c01030b1:	e8 e0 f9 ff ff       	call   c0102a96 <set_page_ref>
    for (struct Page *p = base; p < base + n; p++)
c01030b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01030ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01030bd:	89 d0                	mov    %edx,%eax
c01030bf:	c1 e0 02             	shl    $0x2,%eax
c01030c2:	01 d0                	add    %edx,%eax
c01030c4:	c1 e0 02             	shl    $0x2,%eax
c01030c7:	89 c2                	mov    %eax,%edx
c01030c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01030cc:	01 d0                	add    %edx,%eax
c01030ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01030d1:	0f 82 50 ff ff ff    	jb     c0103027 <buddy_free_pages+0xb7>
    }
    // STEP2: 将buddy中的对应节点释放
    // 自底向上寻找
    // 开始块序号
    unsigned offset = base - page_base;
c01030d7:	8b 15 84 ee 11 c0    	mov    0xc011ee84,%edx
c01030dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01030e0:	29 d0                	sub    %edx,%eax
c01030e2:	c1 f8 02             	sar    $0x2,%eax
c01030e5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c01030eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    // 对应叶节点
    unsigned index = manager_size / 2 + offset;
c01030ee:	a1 8c ee 11 c0       	mov    0xc011ee8c,%eax
c01030f3:	89 c2                	mov    %eax,%edx
c01030f5:	c1 ea 1f             	shr    $0x1f,%edx
c01030f8:	01 d0                	add    %edx,%eax
c01030fa:	d1 f8                	sar    %eax
c01030fc:	89 c2                	mov    %eax,%edx
c01030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103101:	01 d0                	add    %edx,%eax
c0103103:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned node_size = 1;
c0103106:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    // 找第一个值为0的节点
    while (node_size != n)
c010310d:	eb 35                	jmp    c0103144 <buddy_free_pages+0x1d4>
    {
        // 上溯
        index = PARENT(index);
c010310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103112:	d1 e8                	shr    %eax
c0103114:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
c0103117:	d1 65 ec             	shll   -0x14(%ebp)
        // 直到根节点都不为0，说明有误，中断
        assert(index);
c010311a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010311e:	75 24                	jne    c0103144 <buddy_free_pages+0x1d4>
c0103120:	c7 44 24 0c 35 76 10 	movl   $0xc0107635,0xc(%esp)
c0103127:	c0 
c0103128:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c010312f:	c0 
c0103130:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103137:	00 
c0103138:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c010313f:	e8 a6 db ff ff       	call   c0100cea <__panic>
    while (node_size != n)
c0103144:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103147:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010314a:	75 c3                	jne    c010310f <buddy_free_pages+0x19f>
    }
    buddy_manager[index] = node_size;
c010314c:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103152:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103155:	c1 e0 02             	shl    $0x2,%eax
c0103158:	01 c2                	add    %eax,%edx
c010315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010315d:	89 02                	mov    %eax,(%edx)
    cprintf(" index:%u offset:%u ", index, offset);
c010315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103162:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103166:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103169:	89 44 24 04          	mov    %eax,0x4(%esp)
c010316d:	c7 04 24 ba 75 10 c0 	movl   $0xc01075ba,(%esp)
c0103174:	e8 ec d1 ff ff       	call   c0100365 <cprintf>
    // STEP3: 回溯直到根节点，更改沿途值
    index = PARENT(index);
c0103179:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010317c:	d1 e8                	shr    %eax
c010317e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;
c0103181:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
c0103184:	e9 86 00 00 00       	jmp    c010320f <buddy_free_pages+0x29f>
    {
        unsigned leftSize = buddy_manager[LEFT_LEAF(index)];
c0103189:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c010318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103192:	c1 e0 03             	shl    $0x3,%eax
c0103195:	01 d0                	add    %edx,%eax
c0103197:	8b 00                	mov    (%eax),%eax
c0103199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned rightSize = buddy_manager[RIGHT_LEAF(index)];
c010319c:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031a5:	c1 e0 03             	shl    $0x3,%eax
c01031a8:	83 c0 04             	add    $0x4,%eax
c01031ab:	01 d0                	add    %edx,%eax
c01031ad:	8b 00                	mov    (%eax),%eax
c01031af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        // 左右节点均全空，连起来
        if (leftSize + rightSize == node_size)
c01031b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01031b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031b8:	01 d0                	add    %edx,%eax
c01031ba:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01031bd:	75 15                	jne    c01031d4 <buddy_free_pages+0x264>
        {
            buddy_manager[index] = node_size;
c01031bf:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031c8:	c1 e0 02             	shl    $0x2,%eax
c01031cb:	01 c2                	add    %eax,%edx
c01031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031d0:	89 02                	mov    %eax,(%edx)
c01031d2:	eb 30                	jmp    c0103204 <buddy_free_pages+0x294>
        }
        else if (leftSize > rightSize)
c01031d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01031da:	76 15                	jbe    c01031f1 <buddy_free_pages+0x281>
        {
            buddy_manager[index] = leftSize;
c01031dc:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e5:	c1 e0 02             	shl    $0x2,%eax
c01031e8:	01 c2                	add    %eax,%edx
c01031ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031ed:	89 02                	mov    %eax,(%edx)
c01031ef:	eb 13                	jmp    c0103204 <buddy_free_pages+0x294>
        }
        else
        {
            buddy_manager[index] = rightSize;
c01031f1:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031fa:	c1 e0 02             	shl    $0x2,%eax
c01031fd:	01 c2                	add    %eax,%edx
c01031ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103202:	89 02                	mov    %eax,(%edx)
        }
        index = PARENT(index);
c0103204:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103207:	d1 e8                	shr    %eax
c0103209:	89 45 f0             	mov    %eax,-0x10(%ebp)
        node_size *= 2;
c010320c:	d1 65 ec             	shll   -0x14(%ebp)
    while (index)
c010320f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103213:	0f 85 70 ff ff ff    	jne    c0103189 <buddy_free_pages+0x219>
    }
    // STEP4: 增加空闲页数，结束释放过程
    free_page_num += n;
c0103219:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c010321e:	89 c2                	mov    %eax,%edx
c0103220:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103223:	01 d0                	add    %edx,%eax
c0103225:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    cprintf("finish!\n");
c010322a:	c7 04 24 e4 75 10 c0 	movl   $0xc01075e4,(%esp)
c0103231:	e8 2f d1 ff ff       	call   c0100365 <cprintf>
}
c0103236:	90                   	nop
c0103237:	89 ec                	mov    %ebp,%esp
c0103239:	5d                   	pop    %ebp
c010323a:	c3                   	ret    

c010323b <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void)
{
c010323b:	55                   	push   %ebp
c010323c:	89 e5                	mov    %esp,%ebp
    return free_page_num;
c010323e:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
}
c0103243:	5d                   	pop    %ebp
c0103244:	c3                   	ret    

c0103245 <basic_check>:

static void
basic_check(void)
{
c0103245:	55                   	push   %ebp
c0103246:	89 e5                	mov    %esp,%ebp
}
c0103248:	90                   	nop
c0103249:	5d                   	pop    %ebp
c010324a:	c3                   	ret    

c010324b <buddy_check>:

static void
buddy_check(void)
{
c010324b:	55                   	push   %ebp
c010324c:	89 e5                	mov    %esp,%ebp
c010324e:	83 ec 38             	sub    $0x38,%esp
    cprintf("buddy check!\n");
c0103251:	c7 04 24 3b 76 10 c0 	movl   $0xc010763b,(%esp)
c0103258:	e8 08 d1 ff ff       	call   c0100365 <cprintf>
    struct Page *p0, *A, *B, *C, *D;
    p0 = A = B = C = D = NULL;
c010325d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103264:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103267:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010326d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103270:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103273:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103276:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103279:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
c010327c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103283:	e8 07 19 00 00       	call   c0104b8f <alloc_pages>
c0103288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010328b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010328f:	75 24                	jne    c01032b5 <buddy_check+0x6a>
c0103291:	c7 44 24 0c 49 76 10 	movl   $0xc0107649,0xc(%esp)
c0103298:	c0 
c0103299:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c01032a0:	c0 
c01032a1:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01032a8:	00 
c01032a9:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c01032b0:	e8 35 da ff ff       	call   c0100cea <__panic>
    assert((A = alloc_page()) != NULL);
c01032b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032bc:	e8 ce 18 00 00       	call   c0104b8f <alloc_pages>
c01032c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032c8:	75 24                	jne    c01032ee <buddy_check+0xa3>
c01032ca:	c7 44 24 0c 65 76 10 	movl   $0xc0107665,0xc(%esp)
c01032d1:	c0 
c01032d2:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c01032d9:	c0 
c01032da:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01032e1:	00 
c01032e2:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c01032e9:	e8 fc d9 ff ff       	call   c0100cea <__panic>
    assert((B = alloc_page()) != NULL);
c01032ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f5:	e8 95 18 00 00       	call   c0104b8f <alloc_pages>
c01032fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103301:	75 24                	jne    c0103327 <buddy_check+0xdc>
c0103303:	c7 44 24 0c 80 76 10 	movl   $0xc0107680,0xc(%esp)
c010330a:	c0 
c010330b:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0103312:	c0 
c0103313:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010331a:	00 
c010331b:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c0103322:	e8 c3 d9 ff ff       	call   c0100cea <__panic>

    assert(p0 != A && p0 != B && A != B);
c0103327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010332a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010332d:	74 10                	je     c010333f <buddy_check+0xf4>
c010332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103332:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103335:	74 08                	je     c010333f <buddy_check+0xf4>
c0103337:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010333a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010333d:	75 24                	jne    c0103363 <buddy_check+0x118>
c010333f:	c7 44 24 0c 9b 76 10 	movl   $0xc010769b,0xc(%esp)
c0103346:	c0 
c0103347:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c010334e:	c0 
c010334f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103356:	00 
c0103357:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c010335e:	e8 87 d9 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
c0103363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103366:	89 04 24             	mov    %eax,(%esp)
c0103369:	e8 1e f7 ff ff       	call   c0102a8c <page_ref>
c010336e:	85 c0                	test   %eax,%eax
c0103370:	75 1e                	jne    c0103390 <buddy_check+0x145>
c0103372:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103375:	89 04 24             	mov    %eax,(%esp)
c0103378:	e8 0f f7 ff ff       	call   c0102a8c <page_ref>
c010337d:	85 c0                	test   %eax,%eax
c010337f:	75 0f                	jne    c0103390 <buddy_check+0x145>
c0103381:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103384:	89 04 24             	mov    %eax,(%esp)
c0103387:	e8 00 f7 ff ff       	call   c0102a8c <page_ref>
c010338c:	85 c0                	test   %eax,%eax
c010338e:	74 24                	je     c01033b4 <buddy_check+0x169>
c0103390:	c7 44 24 0c b8 76 10 	movl   $0xc01076b8,0xc(%esp)
c0103397:	c0 
c0103398:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c010339f:	c0 
c01033a0:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01033a7:	00 
c01033a8:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c01033af:	e8 36 d9 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c01033b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033bb:	00 
c01033bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033bf:	89 04 24             	mov    %eax,(%esp)
c01033c2:	e8 02 18 00 00       	call   c0104bc9 <free_pages>
    free_page(A);
c01033c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033ce:	00 
c01033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d2:	89 04 24             	mov    %eax,(%esp)
c01033d5:	e8 ef 17 00 00       	call   c0104bc9 <free_pages>
    free_page(B);
c01033da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033e1:	00 
c01033e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e5:	89 04 24             	mov    %eax,(%esp)
c01033e8:	e8 dc 17 00 00       	call   c0104bc9 <free_pages>

    A = alloc_pages(512);
c01033ed:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
c01033f4:	e8 96 17 00 00       	call   c0104b8f <alloc_pages>
c01033f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(512);
c01033fc:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
c0103403:	e8 87 17 00 00       	call   c0104b8f <alloc_pages>
c0103408:	89 45 ec             	mov    %eax,-0x14(%ebp)
    free_pages(A, 256);
c010340b:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103412:	00 
c0103413:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103416:	89 04 24             	mov    %eax,(%esp)
c0103419:	e8 ab 17 00 00       	call   c0104bc9 <free_pages>
    free_pages(B, 512);
c010341e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103425:	00 
c0103426:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103429:	89 04 24             	mov    %eax,(%esp)
c010342c:	e8 98 17 00 00       	call   c0104bc9 <free_pages>
    free_pages(A + 256, 256);
c0103431:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103434:	05 00 14 00 00       	add    $0x1400,%eax
c0103439:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103440:	00 
c0103441:	89 04 24             	mov    %eax,(%esp)
c0103444:	e8 80 17 00 00       	call   c0104bc9 <free_pages>

    p0 = alloc_pages(8192);
c0103449:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
c0103450:	e8 3a 17 00 00       	call   c0104b8f <alloc_pages>
c0103455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 == A);
c0103458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010345b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010345e:	74 24                	je     c0103484 <buddy_check+0x239>
c0103460:	c7 44 24 0c f2 76 10 	movl   $0xc01076f2,0xc(%esp)
c0103467:	c0 
c0103468:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c010346f:	c0 
c0103470:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103477:	00 
c0103478:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c010347f:	e8 66 d8 ff ff       	call   c0100cea <__panic>
    // free_pages(p0, 1024);
    //以下是根据链接中的样例测试编写的
    A = alloc_pages(128);
c0103484:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
c010348b:	e8 ff 16 00 00       	call   c0104b8f <alloc_pages>
c0103490:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B = alloc_pages(64);
c0103493:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c010349a:	e8 f0 16 00 00       	call   c0104b8f <alloc_pages>
c010349f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 检查是否相邻
    assert(A + 128 == B);
c01034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034a5:	05 00 0a 00 00       	add    $0xa00,%eax
c01034aa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01034ad:	74 24                	je     c01034d3 <buddy_check+0x288>
c01034af:	c7 44 24 0c fa 76 10 	movl   $0xc01076fa,0xc(%esp)
c01034b6:	c0 
c01034b7:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c01034be:	c0 
c01034bf:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01034c6:	00 
c01034c7:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c01034ce:	e8 17 d8 ff ff       	call   c0100cea <__panic>
    C = alloc_pages(128);
c01034d3:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
c01034da:	e8 b0 16 00 00       	call   c0104b8f <alloc_pages>
c01034df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C有没有和A重叠
    assert(A + 256 == C);
c01034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034e5:	05 00 14 00 00       	add    $0x1400,%eax
c01034ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01034ed:	74 24                	je     c0103513 <buddy_check+0x2c8>
c01034ef:	c7 44 24 0c 07 77 10 	movl   $0xc0107707,0xc(%esp)
c01034f6:	c0 
c01034f7:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c01034fe:	c0 
c01034ff:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103506:	00 
c0103507:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c010350e:	e8 d7 d7 ff ff       	call   c0100cea <__panic>
    // 释放A
    free_pages(A, 128);
c0103513:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c010351a:	00 
c010351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010351e:	89 04 24             	mov    %eax,(%esp)
c0103521:	e8 a3 16 00 00       	call   c0104bc9 <free_pages>
    D = alloc_pages(64);
c0103526:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c010352d:	e8 5d 16 00 00       	call   c0104b8f <alloc_pages>
c0103532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n", D);
c0103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103538:	89 44 24 04          	mov    %eax,0x4(%esp)
c010353c:	c7 04 24 14 77 10 c0 	movl   $0xc0107714,(%esp)
c0103543:	e8 1d ce ff ff       	call   c0100365 <cprintf>
    // 检查D是否能够使用A刚刚释放的内存
    assert(D + 128 == B);
c0103548:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010354b:	05 00 0a 00 00       	add    $0xa00,%eax
c0103550:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103553:	74 24                	je     c0103579 <buddy_check+0x32e>
c0103555:	c7 44 24 0c 1a 77 10 	movl   $0xc010771a,0xc(%esp)
c010355c:	c0 
c010355d:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c0103564:	c0 
c0103565:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010356c:	00 
c010356d:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c0103574:	e8 71 d7 ff ff       	call   c0100cea <__panic>
    free_pages(C, 128);
c0103579:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0103580:	00 
c0103581:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103584:	89 04 24             	mov    %eax,(%esp)
c0103587:	e8 3d 16 00 00       	call   c0104bc9 <free_pages>
    C = alloc_pages(64);
c010358c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
c0103593:	e8 f7 15 00 00       	call   c0104b8f <alloc_pages>
c0103598:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查C是否在B、D之间
    assert(C == D + 64 && C == B - 64);
c010359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359e:	05 00 05 00 00       	add    $0x500,%eax
c01035a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01035a6:	75 0d                	jne    c01035b5 <buddy_check+0x36a>
c01035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035ab:	2d 00 05 00 00       	sub    $0x500,%eax
c01035b0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01035b3:	74 24                	je     c01035d9 <buddy_check+0x38e>
c01035b5:	c7 44 24 0c 27 77 10 	movl   $0xc0107727,0xc(%esp)
c01035bc:	c0 
c01035bd:	c7 44 24 08 d1 74 10 	movl   $0xc01074d1,0x8(%esp)
c01035c4:	c0 
c01035c5:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01035cc:	00 
c01035cd:	c7 04 24 e6 74 10 c0 	movl   $0xc01074e6,(%esp)
c01035d4:	e8 11 d7 ff ff       	call   c0100cea <__panic>
    free_pages(B, 64);
c01035d9:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c01035e0:	00 
c01035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035e4:	89 04 24             	mov    %eax,(%esp)
c01035e7:	e8 dd 15 00 00       	call   c0104bc9 <free_pages>
    free_pages(D, 64);
c01035ec:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c01035f3:	00 
c01035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f7:	89 04 24             	mov    %eax,(%esp)
c01035fa:	e8 ca 15 00 00       	call   c0104bc9 <free_pages>
    free_pages(C, 64);
c01035ff:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0103606:	00 
c0103607:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360a:	89 04 24             	mov    %eax,(%esp)
c010360d:	e8 b7 15 00 00       	call   c0104bc9 <free_pages>
    // 全部释放
    free_pages(p0, 8192);
c0103612:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
c0103619:	00 
c010361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010361d:	89 04 24             	mov    %eax,(%esp)
c0103620:	e8 a4 15 00 00       	call   c0104bc9 <free_pages>
}
c0103625:	90                   	nop
c0103626:	89 ec                	mov    %ebp,%esp
c0103628:	5d                   	pop    %ebp
c0103629:	c3                   	ret    

c010362a <page2ppn>:
page2ppn(struct Page *page) {
c010362a:	55                   	push   %ebp
c010362b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010362d:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c0103633:	8b 45 08             	mov    0x8(%ebp),%eax
c0103636:	29 d0                	sub    %edx,%eax
c0103638:	c1 f8 02             	sar    $0x2,%eax
c010363b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103641:	5d                   	pop    %ebp
c0103642:	c3                   	ret    

c0103643 <page2pa>:
page2pa(struct Page *page) {
c0103643:	55                   	push   %ebp
c0103644:	89 e5                	mov    %esp,%ebp
c0103646:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103649:	8b 45 08             	mov    0x8(%ebp),%eax
c010364c:	89 04 24             	mov    %eax,(%esp)
c010364f:	e8 d6 ff ff ff       	call   c010362a <page2ppn>
c0103654:	c1 e0 0c             	shl    $0xc,%eax
}
c0103657:	89 ec                	mov    %ebp,%esp
c0103659:	5d                   	pop    %ebp
c010365a:	c3                   	ret    

c010365b <page_ref>:
page_ref(struct Page *page) {
c010365b:	55                   	push   %ebp
c010365c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010365e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103661:	8b 00                	mov    (%eax),%eax
}
c0103663:	5d                   	pop    %ebp
c0103664:	c3                   	ret    

c0103665 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103665:	55                   	push   %ebp
c0103666:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103668:	8b 45 08             	mov    0x8(%ebp),%eax
c010366b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010366e:	89 10                	mov    %edx,(%eax)
}
c0103670:	90                   	nop
c0103671:	5d                   	pop    %ebp
c0103672:	c3                   	ret    

c0103673 <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
c0103673:	55                   	push   %ebp
c0103674:	89 e5                	mov    %esp,%ebp
c0103676:	83 ec 10             	sub    $0x10,%esp
c0103679:	c7 45 fc 90 ee 11 c0 	movl   $0xc011ee90,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
c0103680:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103683:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103686:	89 50 04             	mov    %edx,0x4(%eax)
c0103689:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010368c:	8b 50 04             	mov    0x4(%eax),%edx
c010368f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103692:	89 10                	mov    %edx,(%eax)
}
c0103694:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0103695:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c010369c:	00 00 00 
}
c010369f:	90                   	nop
c01036a0:	89 ec                	mov    %ebp,%esp
c01036a2:	5d                   	pop    %ebp
c01036a3:	c3                   	ret    

c01036a4 <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
c01036a4:	55                   	push   %ebp
c01036a5:	89 e5                	mov    %esp,%ebp
c01036a7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01036aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01036ae:	75 24                	jne    c01036d4 <default_init_memmap+0x30>
c01036b0:	c7 44 24 0c 70 77 10 	movl   $0xc0107770,0xc(%esp)
c01036b7:	c0 
c01036b8:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01036bf:	c0 
c01036c0:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01036c7:	00 
c01036c8:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01036cf:	e8 16 d6 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c01036d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c01036da:	eb 7b                	jmp    c0103757 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
c01036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036df:	83 c0 04             	add    $0x4,%eax
c01036e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01036e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01036ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01036f2:	0f a3 10             	bt     %edx,(%eax)
c01036f5:	19 c0                	sbb    %eax,%eax
c01036f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01036fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01036fe:	0f 95 c0             	setne  %al
c0103701:	0f b6 c0             	movzbl %al,%eax
c0103704:	85 c0                	test   %eax,%eax
c0103706:	75 24                	jne    c010372c <default_init_memmap+0x88>
c0103708:	c7 44 24 0c a1 77 10 	movl   $0xc01077a1,0xc(%esp)
c010370f:	c0 
c0103710:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103717:	c0 
c0103718:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c010371f:	00 
c0103720:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103727:	e8 be d5 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c010372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010372f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
c0103736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103739:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
c0103740:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103747:	00 
c0103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010374b:	89 04 24             	mov    %eax,(%esp)
c010374e:	e8 12 ff ff ff       	call   c0103665 <set_page_ref>
    for (; p != base + n; p++)
c0103753:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103757:	8b 55 0c             	mov    0xc(%ebp),%edx
c010375a:	89 d0                	mov    %edx,%eax
c010375c:	c1 e0 02             	shl    $0x2,%eax
c010375f:	01 d0                	add    %edx,%eax
c0103761:	c1 e0 02             	shl    $0x2,%eax
c0103764:	89 c2                	mov    %eax,%edx
c0103766:	8b 45 08             	mov    0x8(%ebp),%eax
c0103769:	01 d0                	add    %edx,%eax
c010376b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010376e:	0f 85 68 ff ff ff    	jne    c01036dc <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
c0103774:	8b 45 08             	mov    0x8(%ebp),%eax
c0103777:	83 c0 04             	add    $0x4,%eax
c010377a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103781:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0103784:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103787:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010378a:	0f ab 10             	bts    %edx,(%eax)
}
c010378d:	90                   	nop
    base->property = n;
c010378e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103791:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103794:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0103797:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c010379d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037a0:	01 d0                	add    %edx,%eax
c01037a2:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
c01037a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01037aa:	83 c0 0c             	add    $0xc,%eax
c01037ad:	c7 45 e4 90 ee 11 c0 	movl   $0xc011ee90,-0x1c(%ebp)
c01037b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
c01037b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ba:	8b 00                	mov    (%eax),%eax
c01037bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01037bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01037c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
c01037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01037ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01037d1:	89 10                	mov    %edx,(%eax)
c01037d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01037d6:	8b 10                	mov    (%eax),%edx
c01037d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01037de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01037e4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01037e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01037ed:	89 10                	mov    %edx,(%eax)
}
c01037ef:	90                   	nop
}
c01037f0:	90                   	nop
}
c01037f1:	90                   	nop
c01037f2:	89 ec                	mov    %ebp,%esp
c01037f4:	5d                   	pop    %ebp
c01037f5:	c3                   	ret    

c01037f6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c01037f6:	55                   	push   %ebp
c01037f7:	89 e5                	mov    %esp,%ebp
c01037f9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01037fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103800:	75 24                	jne    c0103826 <default_alloc_pages+0x30>
c0103802:	c7 44 24 0c 70 77 10 	movl   $0xc0107770,0xc(%esp)
c0103809:	c0 
c010380a:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103811:	c0 
c0103812:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0103819:	00 
c010381a:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103821:	e8 c4 d4 ff ff       	call   c0100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
c0103826:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c010382b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010382e:	76 0a                	jbe    c010383a <default_alloc_pages+0x44>
    {
        return NULL;
c0103830:	b8 00 00 00 00       	mov    $0x0,%eax
c0103835:	e9 43 01 00 00       	jmp    c010397d <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c010383a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103841:	c7 45 f0 90 ee 11 c0 	movl   $0xc011ee90,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103848:	eb 1c                	jmp    c0103866 <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
c010384a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010384d:	83 e8 0c             	sub    $0xc,%eax
c0103850:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c0103853:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103856:	8b 40 08             	mov    0x8(%eax),%eax
c0103859:	39 45 08             	cmp    %eax,0x8(%ebp)
c010385c:	77 08                	ja     c0103866 <default_alloc_pages+0x70>
        {
            page = p;
c010385e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103861:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103864:	eb 18                	jmp    c010387e <default_alloc_pages+0x88>
c0103866:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c010386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010386f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103872:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103875:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c010387c:	75 cc                	jne    c010384a <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c010387e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103882:	0f 84 f2 00 00 00    	je     c010397a <default_alloc_pages+0x184>
    {
        if (page->property > n)
c0103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010388b:	8b 40 08             	mov    0x8(%eax),%eax
c010388e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103891:	0f 83 8f 00 00 00    	jae    c0103926 <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
c0103897:	8b 55 08             	mov    0x8(%ebp),%edx
c010389a:	89 d0                	mov    %edx,%eax
c010389c:	c1 e0 02             	shl    $0x2,%eax
c010389f:	01 d0                	add    %edx,%eax
c01038a1:	c1 e0 02             	shl    $0x2,%eax
c01038a4:	89 c2                	mov    %eax,%edx
c01038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a9:	01 d0                	add    %edx,%eax
c01038ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038b1:	8b 40 08             	mov    0x8(%eax),%eax
c01038b4:	2b 45 08             	sub    0x8(%ebp),%eax
c01038b7:	89 c2                	mov    %eax,%edx
c01038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038bc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01038bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038c2:	83 c0 0c             	add    $0xc,%eax
c01038c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038c8:	83 c2 0c             	add    $0xc,%edx
c01038cb:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01038ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01038d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038d4:	8b 40 04             	mov    0x4(%eax),%eax
c01038d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01038da:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01038dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01038e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01038e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c01038e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01038e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01038ec:	89 10                	mov    %edx,(%eax)
c01038ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01038f1:	8b 10                	mov    (%eax),%edx
c01038f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01038f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038fc:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01038ff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103902:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103905:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103908:	89 10                	mov    %edx,(%eax)
}
c010390a:	90                   	nop
}
c010390b:	90                   	nop
            SetPageProperty(p);
c010390c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010390f:	83 c0 04             	add    $0x4,%eax
c0103912:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103919:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
c010391c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010391f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103922:	0f ab 10             	bts    %edx,(%eax)
}
c0103925:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
c0103926:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103929:	83 c0 0c             	add    $0xc,%eax
c010392c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c010392f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103932:	8b 40 04             	mov    0x4(%eax),%eax
c0103935:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103938:	8b 12                	mov    (%edx),%edx
c010393a:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010393d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
c0103940:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103943:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103946:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103949:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010394c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010394f:	89 10                	mov    %edx,(%eax)
}
c0103951:	90                   	nop
}
c0103952:	90                   	nop
        nr_free -= n;
c0103953:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103958:	2b 45 08             	sub    0x8(%ebp),%eax
c010395b:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
        ClearPageProperty(page);
c0103960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103963:	83 c0 04             	add    $0x4,%eax
c0103966:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010396d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
c0103970:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103973:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103976:	0f b3 10             	btr    %edx,(%eax)
}
c0103979:	90                   	nop
    }
    return page;
c010397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010397d:	89 ec                	mov    %ebp,%esp
c010397f:	5d                   	pop    %ebp
c0103980:	c3                   	ret    

c0103981 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0103981:	55                   	push   %ebp
c0103982:	89 e5                	mov    %esp,%ebp
c0103984:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010398a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010398e:	75 24                	jne    c01039b4 <default_free_pages+0x33>
c0103990:	c7 44 24 0c 70 77 10 	movl   $0xc0107770,0xc(%esp)
c0103997:	c0 
c0103998:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c010399f:	c0 
c01039a0:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c01039a7:	00 
c01039a8:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01039af:	e8 36 d3 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c01039b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c01039ba:	e9 9d 00 00 00       	jmp    c0103a5c <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c01039bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c2:	83 c0 04             	add    $0x4,%eax
c01039c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01039cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01039cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01039d5:	0f a3 10             	bt     %edx,(%eax)
c01039d8:	19 c0                	sbb    %eax,%eax
c01039da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01039dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01039e1:	0f 95 c0             	setne  %al
c01039e4:	0f b6 c0             	movzbl %al,%eax
c01039e7:	85 c0                	test   %eax,%eax
c01039e9:	75 2c                	jne    c0103a17 <default_free_pages+0x96>
c01039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ee:	83 c0 04             	add    $0x4,%eax
c01039f1:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01039f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01039fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a01:	0f a3 10             	bt     %edx,(%eax)
c0103a04:	19 c0                	sbb    %eax,%eax
c0103a06:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0103a09:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103a0d:	0f 95 c0             	setne  %al
c0103a10:	0f b6 c0             	movzbl %al,%eax
c0103a13:	85 c0                	test   %eax,%eax
c0103a15:	74 24                	je     c0103a3b <default_free_pages+0xba>
c0103a17:	c7 44 24 0c b4 77 10 	movl   $0xc01077b4,0xc(%esp)
c0103a1e:	c0 
c0103a1f:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103a26:	c0 
c0103a27:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103a2e:	00 
c0103a2f:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103a36:	e8 af d2 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c0103a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0103a45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a4c:	00 
c0103a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a50:	89 04 24             	mov    %eax,(%esp)
c0103a53:	e8 0d fc ff ff       	call   c0103665 <set_page_ref>
    for (; p != base + n; p++)
c0103a58:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a5f:	89 d0                	mov    %edx,%eax
c0103a61:	c1 e0 02             	shl    $0x2,%eax
c0103a64:	01 d0                	add    %edx,%eax
c0103a66:	c1 e0 02             	shl    $0x2,%eax
c0103a69:	89 c2                	mov    %eax,%edx
c0103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6e:	01 d0                	add    %edx,%eax
c0103a70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a73:	0f 85 46 ff ff ff    	jne    c01039bf <default_free_pages+0x3e>
    }
    base->property = n;
c0103a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a7f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a85:	83 c0 04             	add    $0x4,%eax
c0103a88:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103a8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0103a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a95:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103a98:	0f ab 10             	bts    %edx,(%eax)
}
c0103a9b:	90                   	nop
c0103a9c:	c7 45 d4 90 ee 11 c0 	movl   $0xc011ee90,-0x2c(%ebp)
    return listelm->next;
c0103aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103aa6:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
c0103aac:	e9 0e 01 00 00       	jmp    c0103bbf <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
c0103ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab4:	83 e8 0c             	sub    $0xc,%eax
c0103ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103abd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ac0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103ac3:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
c0103ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103acc:	8b 50 08             	mov    0x8(%eax),%edx
c0103acf:	89 d0                	mov    %edx,%eax
c0103ad1:	c1 e0 02             	shl    $0x2,%eax
c0103ad4:	01 d0                	add    %edx,%eax
c0103ad6:	c1 e0 02             	shl    $0x2,%eax
c0103ad9:	89 c2                	mov    %eax,%edx
c0103adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ade:	01 d0                	add    %edx,%eax
c0103ae0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103ae3:	75 5d                	jne    c0103b42 <default_free_pages+0x1c1>
        {
            base->property += p->property;
c0103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae8:	8b 50 08             	mov    0x8(%eax),%edx
c0103aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aee:	8b 40 08             	mov    0x8(%eax),%eax
c0103af1:	01 c2                	add    %eax,%edx
c0103af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af6:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afc:	83 c0 04             	add    $0x4,%eax
c0103aff:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103b06:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
c0103b09:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103b0c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103b0f:	0f b3 10             	btr    %edx,(%eax)
}
c0103b12:	90                   	nop
            list_del(&(p->page_link));
c0103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b16:	83 c0 0c             	add    $0xc,%eax
c0103b19:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103b1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103b1f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b22:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103b25:	8b 12                	mov    (%edx),%edx
c0103b27:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103b2a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0103b2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103b30:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103b33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103b36:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103b39:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103b3c:	89 10                	mov    %edx,(%eax)
}
c0103b3e:	90                   	nop
}
c0103b3f:	90                   	nop
c0103b40:	eb 7d                	jmp    c0103bbf <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
c0103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b45:	8b 50 08             	mov    0x8(%eax),%edx
c0103b48:	89 d0                	mov    %edx,%eax
c0103b4a:	c1 e0 02             	shl    $0x2,%eax
c0103b4d:	01 d0                	add    %edx,%eax
c0103b4f:	c1 e0 02             	shl    $0x2,%eax
c0103b52:	89 c2                	mov    %eax,%edx
c0103b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b57:	01 d0                	add    %edx,%eax
c0103b59:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103b5c:	75 61                	jne    c0103bbf <default_free_pages+0x23e>
        {
            p->property += base->property;
c0103b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b61:	8b 50 08             	mov    0x8(%eax),%edx
c0103b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b67:	8b 40 08             	mov    0x8(%eax),%eax
c0103b6a:	01 c2                	add    %eax,%edx
c0103b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b6f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b75:	83 c0 04             	add    $0x4,%eax
c0103b78:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0103b7f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
c0103b82:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103b85:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103b88:	0f b3 10             	btr    %edx,(%eax)
}
c0103b8b:	90                   	nop
            base = p;
c0103b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b8f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0103b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b95:	83 c0 0c             	add    $0xc,%eax
c0103b98:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103b9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103b9e:	8b 40 04             	mov    0x4(%eax),%eax
c0103ba1:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103ba4:	8b 12                	mov    (%edx),%edx
c0103ba6:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103ba9:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0103bac:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103baf:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103bb2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103bb5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103bb8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103bbb:	89 10                	mov    %edx,(%eax)
}
c0103bbd:	90                   	nop
}
c0103bbe:	90                   	nop
    while (le != &free_list)
c0103bbf:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103bc6:	0f 85 e5 fe ff ff    	jne    c0103ab1 <default_free_pages+0x130>
        }
    }
    le = &free_list;
c0103bcc:	c7 45 f0 90 ee 11 c0 	movl   $0xc011ee90,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
c0103bd3:	eb 25                	jmp    c0103bfa <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
c0103bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bd8:	83 e8 0c             	sub    $0xc,%eax
c0103bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
c0103bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be1:	8b 50 08             	mov    0x8(%eax),%edx
c0103be4:	89 d0                	mov    %edx,%eax
c0103be6:	c1 e0 02             	shl    $0x2,%eax
c0103be9:	01 d0                	add    %edx,%eax
c0103beb:	c1 e0 02             	shl    $0x2,%eax
c0103bee:	89 c2                	mov    %eax,%edx
c0103bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf3:	01 d0                	add    %edx,%eax
c0103bf5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103bf8:	73 1a                	jae    c0103c14 <default_free_pages+0x293>
c0103bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bfd:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0103c00:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103c03:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c09:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103c10:	75 c3                	jne    c0103bd5 <default_free_pages+0x254>
c0103c12:	eb 01                	jmp    c0103c15 <default_free_pages+0x294>
        {
            break;
c0103c14:	90                   	nop
        }
    }
    nr_free += n;
c0103c15:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c0103c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c1e:	01 d0                	add    %edx,%eax
c0103c20:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    list_add_before(le, &(base->page_link));
c0103c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c28:	8d 50 0c             	lea    0xc(%eax),%edx
c0103c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c2e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103c31:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0103c34:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103c37:	8b 00                	mov    (%eax),%eax
c0103c39:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103c3c:	89 55 90             	mov    %edx,-0x70(%ebp)
c0103c3f:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0103c42:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103c45:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
c0103c48:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103c4b:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103c4e:	89 10                	mov    %edx,(%eax)
c0103c50:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103c53:	8b 10                	mov    (%eax),%edx
c0103c55:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103c58:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103c5b:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103c5e:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103c61:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103c64:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103c67:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103c6a:	89 10                	mov    %edx,(%eax)
}
c0103c6c:	90                   	nop
}
c0103c6d:	90                   	nop
}
c0103c6e:	90                   	nop
c0103c6f:	89 ec                	mov    %ebp,%esp
c0103c71:	5d                   	pop    %ebp
c0103c72:	c3                   	ret    

c0103c73 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c0103c73:	55                   	push   %ebp
c0103c74:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103c76:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
}
c0103c7b:	5d                   	pop    %ebp
c0103c7c:	c3                   	ret    

c0103c7d <basic_check>:

static void
basic_check(void)
{
c0103c7d:	55                   	push   %ebp
c0103c7e:	89 e5                	mov    %esp,%ebp
c0103c80:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103c96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c9d:	e8 ed 0e 00 00       	call   c0104b8f <alloc_pages>
c0103ca2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ca5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103ca9:	75 24                	jne    c0103ccf <basic_check+0x52>
c0103cab:	c7 44 24 0c d9 77 10 	movl   $0xc01077d9,0xc(%esp)
c0103cb2:	c0 
c0103cb3:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103cba:	c0 
c0103cbb:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103cc2:	00 
c0103cc3:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103cca:	e8 1b d0 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103ccf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cd6:	e8 b4 0e 00 00       	call   c0104b8f <alloc_pages>
c0103cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ce2:	75 24                	jne    c0103d08 <basic_check+0x8b>
c0103ce4:	c7 44 24 0c f5 77 10 	movl   $0xc01077f5,0xc(%esp)
c0103ceb:	c0 
c0103cec:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103cf3:	c0 
c0103cf4:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103cfb:	00 
c0103cfc:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103d03:	e8 e2 cf ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103d08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d0f:	e8 7b 0e 00 00       	call   c0104b8f <alloc_pages>
c0103d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d1b:	75 24                	jne    c0103d41 <basic_check+0xc4>
c0103d1d:	c7 44 24 0c 11 78 10 	movl   $0xc0107811,0xc(%esp)
c0103d24:	c0 
c0103d25:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103d2c:	c0 
c0103d2d:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103d34:	00 
c0103d35:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103d3c:	e8 a9 cf ff ff       	call   c0100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103d47:	74 10                	je     c0103d59 <basic_check+0xdc>
c0103d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d4f:	74 08                	je     c0103d59 <basic_check+0xdc>
c0103d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d57:	75 24                	jne    c0103d7d <basic_check+0x100>
c0103d59:	c7 44 24 0c 30 78 10 	movl   $0xc0107830,0xc(%esp)
c0103d60:	c0 
c0103d61:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103d68:	c0 
c0103d69:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103d70:	00 
c0103d71:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103d78:	e8 6d cf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d80:	89 04 24             	mov    %eax,(%esp)
c0103d83:	e8 d3 f8 ff ff       	call   c010365b <page_ref>
c0103d88:	85 c0                	test   %eax,%eax
c0103d8a:	75 1e                	jne    c0103daa <basic_check+0x12d>
c0103d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d8f:	89 04 24             	mov    %eax,(%esp)
c0103d92:	e8 c4 f8 ff ff       	call   c010365b <page_ref>
c0103d97:	85 c0                	test   %eax,%eax
c0103d99:	75 0f                	jne    c0103daa <basic_check+0x12d>
c0103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d9e:	89 04 24             	mov    %eax,(%esp)
c0103da1:	e8 b5 f8 ff ff       	call   c010365b <page_ref>
c0103da6:	85 c0                	test   %eax,%eax
c0103da8:	74 24                	je     c0103dce <basic_check+0x151>
c0103daa:	c7 44 24 0c 54 78 10 	movl   $0xc0107854,0xc(%esp)
c0103db1:	c0 
c0103db2:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103db9:	c0 
c0103dba:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103dc1:	00 
c0103dc2:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103dc9:	e8 1c cf ff ff       	call   c0100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dd1:	89 04 24             	mov    %eax,(%esp)
c0103dd4:	e8 6a f8 ff ff       	call   c0103643 <page2pa>
c0103dd9:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103ddf:	c1 e2 0c             	shl    $0xc,%edx
c0103de2:	39 d0                	cmp    %edx,%eax
c0103de4:	72 24                	jb     c0103e0a <basic_check+0x18d>
c0103de6:	c7 44 24 0c 90 78 10 	movl   $0xc0107890,0xc(%esp)
c0103ded:	c0 
c0103dee:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103df5:	c0 
c0103df6:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103dfd:	00 
c0103dfe:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103e05:	e8 e0 ce ff ff       	call   c0100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e0d:	89 04 24             	mov    %eax,(%esp)
c0103e10:	e8 2e f8 ff ff       	call   c0103643 <page2pa>
c0103e15:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103e1b:	c1 e2 0c             	shl    $0xc,%edx
c0103e1e:	39 d0                	cmp    %edx,%eax
c0103e20:	72 24                	jb     c0103e46 <basic_check+0x1c9>
c0103e22:	c7 44 24 0c ad 78 10 	movl   $0xc01078ad,0xc(%esp)
c0103e29:	c0 
c0103e2a:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103e31:	c0 
c0103e32:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103e39:	00 
c0103e3a:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103e41:	e8 a4 ce ff ff       	call   c0100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e49:	89 04 24             	mov    %eax,(%esp)
c0103e4c:	e8 f2 f7 ff ff       	call   c0103643 <page2pa>
c0103e51:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103e57:	c1 e2 0c             	shl    $0xc,%edx
c0103e5a:	39 d0                	cmp    %edx,%eax
c0103e5c:	72 24                	jb     c0103e82 <basic_check+0x205>
c0103e5e:	c7 44 24 0c ca 78 10 	movl   $0xc01078ca,0xc(%esp)
c0103e65:	c0 
c0103e66:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103e6d:	c0 
c0103e6e:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103e75:	00 
c0103e76:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103e7d:	e8 68 ce ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c0103e82:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c0103e87:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c0103e8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e90:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e93:	c7 45 dc 90 ee 11 c0 	movl   $0xc011ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103e9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea0:	89 50 04             	mov    %edx,0x4(%eax)
c0103ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ea6:	8b 50 04             	mov    0x4(%eax),%edx
c0103ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103eac:	89 10                	mov    %edx,(%eax)
}
c0103eae:	90                   	nop
c0103eaf:	c7 45 e0 90 ee 11 c0 	movl   $0xc011ee90,-0x20(%ebp)
    return list->next == list;
c0103eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eb9:	8b 40 04             	mov    0x4(%eax),%eax
c0103ebc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103ebf:	0f 94 c0             	sete   %al
c0103ec2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ec5:	85 c0                	test   %eax,%eax
c0103ec7:	75 24                	jne    c0103eed <basic_check+0x270>
c0103ec9:	c7 44 24 0c e7 78 10 	movl   $0xc01078e7,0xc(%esp)
c0103ed0:	c0 
c0103ed1:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103ed8:	c0 
c0103ed9:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103ee0:	00 
c0103ee1:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103ee8:	e8 fd cd ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c0103eed:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103ef5:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c0103efc:	00 00 00 

    assert(alloc_page() == NULL);
c0103eff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f06:	e8 84 0c 00 00       	call   c0104b8f <alloc_pages>
c0103f0b:	85 c0                	test   %eax,%eax
c0103f0d:	74 24                	je     c0103f33 <basic_check+0x2b6>
c0103f0f:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c0103f16:	c0 
c0103f17:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103f1e:	c0 
c0103f1f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103f26:	00 
c0103f27:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103f2e:	e8 b7 cd ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103f33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f3a:	00 
c0103f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f3e:	89 04 24             	mov    %eax,(%esp)
c0103f41:	e8 83 0c 00 00       	call   c0104bc9 <free_pages>
    free_page(p1);
c0103f46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f4d:	00 
c0103f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f51:	89 04 24             	mov    %eax,(%esp)
c0103f54:	e8 70 0c 00 00       	call   c0104bc9 <free_pages>
    free_page(p2);
c0103f59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f60:	00 
c0103f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f64:	89 04 24             	mov    %eax,(%esp)
c0103f67:	e8 5d 0c 00 00       	call   c0104bc9 <free_pages>
    assert(nr_free == 3);
c0103f6c:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103f71:	83 f8 03             	cmp    $0x3,%eax
c0103f74:	74 24                	je     c0103f9a <basic_check+0x31d>
c0103f76:	c7 44 24 0c 13 79 10 	movl   $0xc0107913,0xc(%esp)
c0103f7d:	c0 
c0103f7e:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103f85:	c0 
c0103f86:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103f8d:	00 
c0103f8e:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103f95:	e8 50 cd ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103f9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fa1:	e8 e9 0b 00 00       	call   c0104b8f <alloc_pages>
c0103fa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103fa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103fad:	75 24                	jne    c0103fd3 <basic_check+0x356>
c0103faf:	c7 44 24 0c d9 77 10 	movl   $0xc01077d9,0xc(%esp)
c0103fb6:	c0 
c0103fb7:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103fbe:	c0 
c0103fbf:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103fc6:	00 
c0103fc7:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0103fce:	e8 17 cd ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103fd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fda:	e8 b0 0b 00 00       	call   c0104b8f <alloc_pages>
c0103fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fe2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103fe6:	75 24                	jne    c010400c <basic_check+0x38f>
c0103fe8:	c7 44 24 0c f5 77 10 	movl   $0xc01077f5,0xc(%esp)
c0103fef:	c0 
c0103ff0:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0103ff7:	c0 
c0103ff8:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103fff:	00 
c0104000:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104007:	e8 de cc ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c010400c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104013:	e8 77 0b 00 00       	call   c0104b8f <alloc_pages>
c0104018:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010401b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010401f:	75 24                	jne    c0104045 <basic_check+0x3c8>
c0104021:	c7 44 24 0c 11 78 10 	movl   $0xc0107811,0xc(%esp)
c0104028:	c0 
c0104029:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104030:	c0 
c0104031:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104038:	00 
c0104039:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104040:	e8 a5 cc ff ff       	call   c0100cea <__panic>

    assert(alloc_page() == NULL);
c0104045:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010404c:	e8 3e 0b 00 00       	call   c0104b8f <alloc_pages>
c0104051:	85 c0                	test   %eax,%eax
c0104053:	74 24                	je     c0104079 <basic_check+0x3fc>
c0104055:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c010405c:	c0 
c010405d:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104064:	c0 
c0104065:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010406c:	00 
c010406d:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104074:	e8 71 cc ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0104079:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104080:	00 
c0104081:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104084:	89 04 24             	mov    %eax,(%esp)
c0104087:	e8 3d 0b 00 00       	call   c0104bc9 <free_pages>
c010408c:	c7 45 d8 90 ee 11 c0 	movl   $0xc011ee90,-0x28(%ebp)
c0104093:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104096:	8b 40 04             	mov    0x4(%eax),%eax
c0104099:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010409c:	0f 94 c0             	sete   %al
c010409f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01040a2:	85 c0                	test   %eax,%eax
c01040a4:	74 24                	je     c01040ca <basic_check+0x44d>
c01040a6:	c7 44 24 0c 20 79 10 	movl   $0xc0107920,0xc(%esp)
c01040ad:	c0 
c01040ae:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01040b5:	c0 
c01040b6:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01040bd:	00 
c01040be:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01040c5:	e8 20 cc ff ff       	call   c0100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01040ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040d1:	e8 b9 0a 00 00       	call   c0104b8f <alloc_pages>
c01040d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01040df:	74 24                	je     c0104105 <basic_check+0x488>
c01040e1:	c7 44 24 0c 38 79 10 	movl   $0xc0107938,0xc(%esp)
c01040e8:	c0 
c01040e9:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01040f0:	c0 
c01040f1:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01040f8:	00 
c01040f9:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104100:	e8 e5 cb ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010410c:	e8 7e 0a 00 00       	call   c0104b8f <alloc_pages>
c0104111:	85 c0                	test   %eax,%eax
c0104113:	74 24                	je     c0104139 <basic_check+0x4bc>
c0104115:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c010411c:	c0 
c010411d:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104124:	c0 
c0104125:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c010412c:	00 
c010412d:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104134:	e8 b1 cb ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0104139:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c010413e:	85 c0                	test   %eax,%eax
c0104140:	74 24                	je     c0104166 <basic_check+0x4e9>
c0104142:	c7 44 24 0c 51 79 10 	movl   $0xc0107951,0xc(%esp)
c0104149:	c0 
c010414a:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104151:	c0 
c0104152:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0104159:	00 
c010415a:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104161:	e8 84 cb ff ff       	call   c0100cea <__panic>
    free_list = free_list_store;
c0104166:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104169:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010416c:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c0104171:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    nr_free = nr_free_store;
c0104177:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010417a:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_page(p);
c010417f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104186:	00 
c0104187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010418a:	89 04 24             	mov    %eax,(%esp)
c010418d:	e8 37 0a 00 00       	call   c0104bc9 <free_pages>
    free_page(p1);
c0104192:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104199:	00 
c010419a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010419d:	89 04 24             	mov    %eax,(%esp)
c01041a0:	e8 24 0a 00 00       	call   c0104bc9 <free_pages>
    free_page(p2);
c01041a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041ac:	00 
c01041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041b0:	89 04 24             	mov    %eax,(%esp)
c01041b3:	e8 11 0a 00 00       	call   c0104bc9 <free_pages>
}
c01041b8:	90                   	nop
c01041b9:	89 ec                	mov    %ebp,%esp
c01041bb:	5d                   	pop    %ebp
c01041bc:	c3                   	ret    

c01041bd <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c01041bd:	55                   	push   %ebp
c01041be:	89 e5                	mov    %esp,%ebp
c01041c0:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01041c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01041cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01041d4:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c01041db:	eb 6a                	jmp    c0104247 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c01041dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041e0:	83 e8 0c             	sub    $0xc,%eax
c01041e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01041e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041e9:	83 c0 04             	add    $0x4,%eax
c01041ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01041f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01041f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01041f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041fc:	0f a3 10             	bt     %edx,(%eax)
c01041ff:	19 c0                	sbb    %eax,%eax
c0104201:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104204:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104208:	0f 95 c0             	setne  %al
c010420b:	0f b6 c0             	movzbl %al,%eax
c010420e:	85 c0                	test   %eax,%eax
c0104210:	75 24                	jne    c0104236 <default_check+0x79>
c0104212:	c7 44 24 0c 5e 79 10 	movl   $0xc010795e,0xc(%esp)
c0104219:	c0 
c010421a:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104221:	c0 
c0104222:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0104229:	00 
c010422a:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104231:	e8 b4 ca ff ff       	call   c0100cea <__panic>
        count++, total += p->property;
c0104236:	ff 45 f4             	incl   -0xc(%ebp)
c0104239:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010423c:	8b 50 08             	mov    0x8(%eax),%edx
c010423f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104242:	01 d0                	add    %edx,%eax
c0104244:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104247:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010424a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010424d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104250:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0104253:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104256:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c010425d:	0f 85 7a ff ff ff    	jne    c01041dd <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104263:	e8 96 09 00 00       	call   c0104bfe <nr_free_pages>
c0104268:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010426b:	39 d0                	cmp    %edx,%eax
c010426d:	74 24                	je     c0104293 <default_check+0xd6>
c010426f:	c7 44 24 0c 6e 79 10 	movl   $0xc010796e,0xc(%esp)
c0104276:	c0 
c0104277:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c010427e:	c0 
c010427f:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104286:	00 
c0104287:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c010428e:	e8 57 ca ff ff       	call   c0100cea <__panic>

    basic_check();
c0104293:	e8 e5 f9 ff ff       	call   c0103c7d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104298:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010429f:	e8 eb 08 00 00       	call   c0104b8f <alloc_pages>
c01042a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01042a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01042ab:	75 24                	jne    c01042d1 <default_check+0x114>
c01042ad:	c7 44 24 0c 87 79 10 	movl   $0xc0107987,0xc(%esp)
c01042b4:	c0 
c01042b5:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01042bc:	c0 
c01042bd:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01042c4:	00 
c01042c5:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01042cc:	e8 19 ca ff ff       	call   c0100cea <__panic>
    assert(!PageProperty(p0));
c01042d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042d4:	83 c0 04             	add    $0x4,%eax
c01042d7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01042de:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01042e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01042e7:	0f a3 10             	bt     %edx,(%eax)
c01042ea:	19 c0                	sbb    %eax,%eax
c01042ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01042ef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01042f3:	0f 95 c0             	setne  %al
c01042f6:	0f b6 c0             	movzbl %al,%eax
c01042f9:	85 c0                	test   %eax,%eax
c01042fb:	74 24                	je     c0104321 <default_check+0x164>
c01042fd:	c7 44 24 0c 92 79 10 	movl   $0xc0107992,0xc(%esp)
c0104304:	c0 
c0104305:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c010430c:	c0 
c010430d:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0104314:	00 
c0104315:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c010431c:	e8 c9 c9 ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c0104321:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c0104326:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c010432c:	89 45 80             	mov    %eax,-0x80(%ebp)
c010432f:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104332:	c7 45 b0 90 ee 11 c0 	movl   $0xc011ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104339:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010433c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010433f:	89 50 04             	mov    %edx,0x4(%eax)
c0104342:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104345:	8b 50 04             	mov    0x4(%eax),%edx
c0104348:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010434b:	89 10                	mov    %edx,(%eax)
}
c010434d:	90                   	nop
c010434e:	c7 45 b4 90 ee 11 c0 	movl   $0xc011ee90,-0x4c(%ebp)
    return list->next == list;
c0104355:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104358:	8b 40 04             	mov    0x4(%eax),%eax
c010435b:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c010435e:	0f 94 c0             	sete   %al
c0104361:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104364:	85 c0                	test   %eax,%eax
c0104366:	75 24                	jne    c010438c <default_check+0x1cf>
c0104368:	c7 44 24 0c e7 78 10 	movl   $0xc01078e7,0xc(%esp)
c010436f:	c0 
c0104370:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104377:	c0 
c0104378:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010437f:	00 
c0104380:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104387:	e8 5e c9 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c010438c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104393:	e8 f7 07 00 00       	call   c0104b8f <alloc_pages>
c0104398:	85 c0                	test   %eax,%eax
c010439a:	74 24                	je     c01043c0 <default_check+0x203>
c010439c:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c01043a3:	c0 
c01043a4:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01043ab:	c0 
c01043ac:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01043b3:	00 
c01043b4:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01043bb:	e8 2a c9 ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c01043c0:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01043c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01043c8:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c01043cf:	00 00 00 

    free_pages(p0 + 2, 3);
c01043d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043d5:	83 c0 28             	add    $0x28,%eax
c01043d8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01043df:	00 
c01043e0:	89 04 24             	mov    %eax,(%esp)
c01043e3:	e8 e1 07 00 00       	call   c0104bc9 <free_pages>
    assert(alloc_pages(4) == NULL);
c01043e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01043ef:	e8 9b 07 00 00       	call   c0104b8f <alloc_pages>
c01043f4:	85 c0                	test   %eax,%eax
c01043f6:	74 24                	je     c010441c <default_check+0x25f>
c01043f8:	c7 44 24 0c a4 79 10 	movl   $0xc01079a4,0xc(%esp)
c01043ff:	c0 
c0104400:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104407:	c0 
c0104408:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c010440f:	00 
c0104410:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104417:	e8 ce c8 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010441c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010441f:	83 c0 28             	add    $0x28,%eax
c0104422:	83 c0 04             	add    $0x4,%eax
c0104425:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010442c:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c010442f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104432:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104435:	0f a3 10             	bt     %edx,(%eax)
c0104438:	19 c0                	sbb    %eax,%eax
c010443a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010443d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104441:	0f 95 c0             	setne  %al
c0104444:	0f b6 c0             	movzbl %al,%eax
c0104447:	85 c0                	test   %eax,%eax
c0104449:	74 0e                	je     c0104459 <default_check+0x29c>
c010444b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010444e:	83 c0 28             	add    $0x28,%eax
c0104451:	8b 40 08             	mov    0x8(%eax),%eax
c0104454:	83 f8 03             	cmp    $0x3,%eax
c0104457:	74 24                	je     c010447d <default_check+0x2c0>
c0104459:	c7 44 24 0c bc 79 10 	movl   $0xc01079bc,0xc(%esp)
c0104460:	c0 
c0104461:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104468:	c0 
c0104469:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104470:	00 
c0104471:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104478:	e8 6d c8 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010447d:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104484:	e8 06 07 00 00       	call   c0104b8f <alloc_pages>
c0104489:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010448c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104490:	75 24                	jne    c01044b6 <default_check+0x2f9>
c0104492:	c7 44 24 0c e8 79 10 	movl   $0xc01079e8,0xc(%esp)
c0104499:	c0 
c010449a:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01044a1:	c0 
c01044a2:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c01044a9:	00 
c01044aa:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01044b1:	e8 34 c8 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c01044b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044bd:	e8 cd 06 00 00       	call   c0104b8f <alloc_pages>
c01044c2:	85 c0                	test   %eax,%eax
c01044c4:	74 24                	je     c01044ea <default_check+0x32d>
c01044c6:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01044d5:	c0 
c01044d6:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01044dd:	00 
c01044de:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01044e5:	e8 00 c8 ff ff       	call   c0100cea <__panic>
    assert(p0 + 2 == p1);
c01044ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044ed:	83 c0 28             	add    $0x28,%eax
c01044f0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01044f3:	74 24                	je     c0104519 <default_check+0x35c>
c01044f5:	c7 44 24 0c 06 7a 10 	movl   $0xc0107a06,0xc(%esp)
c01044fc:	c0 
c01044fd:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104504:	c0 
c0104505:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010450c:	00 
c010450d:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104514:	e8 d1 c7 ff ff       	call   c0100cea <__panic>

    p2 = p0 + 1;
c0104519:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010451c:	83 c0 14             	add    $0x14,%eax
c010451f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104522:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104529:	00 
c010452a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010452d:	89 04 24             	mov    %eax,(%esp)
c0104530:	e8 94 06 00 00       	call   c0104bc9 <free_pages>
    free_pages(p1, 3);
c0104535:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010453c:	00 
c010453d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104540:	89 04 24             	mov    %eax,(%esp)
c0104543:	e8 81 06 00 00       	call   c0104bc9 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104548:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010454b:	83 c0 04             	add    $0x4,%eax
c010454e:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104555:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0104558:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010455b:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010455e:	0f a3 10             	bt     %edx,(%eax)
c0104561:	19 c0                	sbb    %eax,%eax
c0104563:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104566:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010456a:	0f 95 c0             	setne  %al
c010456d:	0f b6 c0             	movzbl %al,%eax
c0104570:	85 c0                	test   %eax,%eax
c0104572:	74 0b                	je     c010457f <default_check+0x3c2>
c0104574:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104577:	8b 40 08             	mov    0x8(%eax),%eax
c010457a:	83 f8 01             	cmp    $0x1,%eax
c010457d:	74 24                	je     c01045a3 <default_check+0x3e6>
c010457f:	c7 44 24 0c 14 7a 10 	movl   $0xc0107a14,0xc(%esp)
c0104586:	c0 
c0104587:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c010458e:	c0 
c010458f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104596:	00 
c0104597:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c010459e:	e8 47 c7 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045a6:	83 c0 04             	add    $0x4,%eax
c01045a9:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01045b0:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01045b3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01045b6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01045b9:	0f a3 10             	bt     %edx,(%eax)
c01045bc:	19 c0                	sbb    %eax,%eax
c01045be:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01045c1:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01045c5:	0f 95 c0             	setne  %al
c01045c8:	0f b6 c0             	movzbl %al,%eax
c01045cb:	85 c0                	test   %eax,%eax
c01045cd:	74 0b                	je     c01045da <default_check+0x41d>
c01045cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045d2:	8b 40 08             	mov    0x8(%eax),%eax
c01045d5:	83 f8 03             	cmp    $0x3,%eax
c01045d8:	74 24                	je     c01045fe <default_check+0x441>
c01045da:	c7 44 24 0c 3c 7a 10 	movl   $0xc0107a3c,0xc(%esp)
c01045e1:	c0 
c01045e2:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01045e9:	c0 
c01045ea:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01045f1:	00 
c01045f2:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01045f9:	e8 ec c6 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01045fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104605:	e8 85 05 00 00       	call   c0104b8f <alloc_pages>
c010460a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010460d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104610:	83 e8 14             	sub    $0x14,%eax
c0104613:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104616:	74 24                	je     c010463c <default_check+0x47f>
c0104618:	c7 44 24 0c 62 7a 10 	movl   $0xc0107a62,0xc(%esp)
c010461f:	c0 
c0104620:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104627:	c0 
c0104628:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c010462f:	00 
c0104630:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104637:	e8 ae c6 ff ff       	call   c0100cea <__panic>
    free_page(p0);
c010463c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104643:	00 
c0104644:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104647:	89 04 24             	mov    %eax,(%esp)
c010464a:	e8 7a 05 00 00       	call   c0104bc9 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010464f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104656:	e8 34 05 00 00       	call   c0104b8f <alloc_pages>
c010465b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010465e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104661:	83 c0 14             	add    $0x14,%eax
c0104664:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104667:	74 24                	je     c010468d <default_check+0x4d0>
c0104669:	c7 44 24 0c 80 7a 10 	movl   $0xc0107a80,0xc(%esp)
c0104670:	c0 
c0104671:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104678:	c0 
c0104679:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104680:	00 
c0104681:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104688:	e8 5d c6 ff ff       	call   c0100cea <__panic>

    free_pages(p0, 2);
c010468d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104694:	00 
c0104695:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104698:	89 04 24             	mov    %eax,(%esp)
c010469b:	e8 29 05 00 00       	call   c0104bc9 <free_pages>
    free_page(p2);
c01046a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046a7:	00 
c01046a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046ab:	89 04 24             	mov    %eax,(%esp)
c01046ae:	e8 16 05 00 00       	call   c0104bc9 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01046b3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01046ba:	e8 d0 04 00 00       	call   c0104b8f <alloc_pages>
c01046bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01046c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01046c6:	75 24                	jne    c01046ec <default_check+0x52f>
c01046c8:	c7 44 24 0c a0 7a 10 	movl   $0xc0107aa0,0xc(%esp)
c01046cf:	c0 
c01046d0:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01046d7:	c0 
c01046d8:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c01046df:	00 
c01046e0:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01046e7:	e8 fe c5 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c01046ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046f3:	e8 97 04 00 00       	call   c0104b8f <alloc_pages>
c01046f8:	85 c0                	test   %eax,%eax
c01046fa:	74 24                	je     c0104720 <default_check+0x563>
c01046fc:	c7 44 24 0c fe 78 10 	movl   $0xc01078fe,0xc(%esp)
c0104703:	c0 
c0104704:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c010470b:	c0 
c010470c:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0104713:	00 
c0104714:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c010471b:	e8 ca c5 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0104720:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0104725:	85 c0                	test   %eax,%eax
c0104727:	74 24                	je     c010474d <default_check+0x590>
c0104729:	c7 44 24 0c 51 79 10 	movl   $0xc0107951,0xc(%esp)
c0104730:	c0 
c0104731:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104738:	c0 
c0104739:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104740:	00 
c0104741:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104748:	e8 9d c5 ff ff       	call   c0100cea <__panic>
    nr_free = nr_free_store;
c010474d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104750:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_list = free_list_store;
c0104755:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104758:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010475b:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c0104760:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    free_pages(p0, 5);
c0104766:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010476d:	00 
c010476e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104771:	89 04 24             	mov    %eax,(%esp)
c0104774:	e8 50 04 00 00       	call   c0104bc9 <free_pages>

    le = &free_list;
c0104779:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0104780:	eb 5a                	jmp    c01047dc <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
c0104782:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104785:	8b 40 04             	mov    0x4(%eax),%eax
c0104788:	8b 00                	mov    (%eax),%eax
c010478a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010478d:	75 0d                	jne    c010479c <default_check+0x5df>
c010478f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104792:	8b 00                	mov    (%eax),%eax
c0104794:	8b 40 04             	mov    0x4(%eax),%eax
c0104797:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010479a:	74 24                	je     c01047c0 <default_check+0x603>
c010479c:	c7 44 24 0c c0 7a 10 	movl   $0xc0107ac0,0xc(%esp)
c01047a3:	c0 
c01047a4:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c01047ab:	c0 
c01047ac:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c01047b3:	00 
c01047b4:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c01047bb:	e8 2a c5 ff ff       	call   c0100cea <__panic>
        struct Page *p = le2page(le, page_link);
c01047c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047c3:	83 e8 0c             	sub    $0xc,%eax
c01047c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c01047c9:	ff 4d f4             	decl   -0xc(%ebp)
c01047cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047d2:	8b 48 08             	mov    0x8(%eax),%ecx
c01047d5:	89 d0                	mov    %edx,%eax
c01047d7:	29 c8                	sub    %ecx,%eax
c01047d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047df:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01047e2:	8b 45 88             	mov    -0x78(%ebp),%eax
c01047e5:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01047e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01047eb:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c01047f2:	75 8e                	jne    c0104782 <default_check+0x5c5>
    }
    assert(count == 0);
c01047f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047f8:	74 24                	je     c010481e <default_check+0x661>
c01047fa:	c7 44 24 0c ed 7a 10 	movl   $0xc0107aed,0xc(%esp)
c0104801:	c0 
c0104802:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104809:	c0 
c010480a:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0104811:	00 
c0104812:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104819:	e8 cc c4 ff ff       	call   c0100cea <__panic>
    assert(total == 0);
c010481e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104822:	74 24                	je     c0104848 <default_check+0x68b>
c0104824:	c7 44 24 0c f8 7a 10 	movl   $0xc0107af8,0xc(%esp)
c010482b:	c0 
c010482c:	c7 44 24 08 76 77 10 	movl   $0xc0107776,0x8(%esp)
c0104833:	c0 
c0104834:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c010483b:	00 
c010483c:	c7 04 24 8b 77 10 c0 	movl   $0xc010778b,(%esp)
c0104843:	e8 a2 c4 ff ff       	call   c0100cea <__panic>
}
c0104848:	90                   	nop
c0104849:	89 ec                	mov    %ebp,%esp
c010484b:	5d                   	pop    %ebp
c010484c:	c3                   	ret    

c010484d <page2ppn>:
page2ppn(struct Page *page) {
c010484d:	55                   	push   %ebp
c010484e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104850:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c0104856:	8b 45 08             	mov    0x8(%ebp),%eax
c0104859:	29 d0                	sub    %edx,%eax
c010485b:	c1 f8 02             	sar    $0x2,%eax
c010485e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104864:	5d                   	pop    %ebp
c0104865:	c3                   	ret    

c0104866 <page2pa>:
page2pa(struct Page *page) {
c0104866:	55                   	push   %ebp
c0104867:	89 e5                	mov    %esp,%ebp
c0104869:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010486c:	8b 45 08             	mov    0x8(%ebp),%eax
c010486f:	89 04 24             	mov    %eax,(%esp)
c0104872:	e8 d6 ff ff ff       	call   c010484d <page2ppn>
c0104877:	c1 e0 0c             	shl    $0xc,%eax
}
c010487a:	89 ec                	mov    %ebp,%esp
c010487c:	5d                   	pop    %ebp
c010487d:	c3                   	ret    

c010487e <pa2page>:
pa2page(uintptr_t pa) {
c010487e:	55                   	push   %ebp
c010487f:	89 e5                	mov    %esp,%ebp
c0104881:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104884:	8b 45 08             	mov    0x8(%ebp),%eax
c0104887:	c1 e8 0c             	shr    $0xc,%eax
c010488a:	89 c2                	mov    %eax,%edx
c010488c:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104891:	39 c2                	cmp    %eax,%edx
c0104893:	72 1c                	jb     c01048b1 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104895:	c7 44 24 08 34 7b 10 	movl   $0xc0107b34,0x8(%esp)
c010489c:	c0 
c010489d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01048a4:	00 
c01048a5:	c7 04 24 53 7b 10 c0 	movl   $0xc0107b53,(%esp)
c01048ac:	e8 39 c4 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c01048b1:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c01048b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ba:	c1 e8 0c             	shr    $0xc,%eax
c01048bd:	89 c2                	mov    %eax,%edx
c01048bf:	89 d0                	mov    %edx,%eax
c01048c1:	c1 e0 02             	shl    $0x2,%eax
c01048c4:	01 d0                	add    %edx,%eax
c01048c6:	c1 e0 02             	shl    $0x2,%eax
c01048c9:	01 c8                	add    %ecx,%eax
}
c01048cb:	89 ec                	mov    %ebp,%esp
c01048cd:	5d                   	pop    %ebp
c01048ce:	c3                   	ret    

c01048cf <page2kva>:
page2kva(struct Page *page) {
c01048cf:	55                   	push   %ebp
c01048d0:	89 e5                	mov    %esp,%ebp
c01048d2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01048d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d8:	89 04 24             	mov    %eax,(%esp)
c01048db:	e8 86 ff ff ff       	call   c0104866 <page2pa>
c01048e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e6:	c1 e8 0c             	shr    $0xc,%eax
c01048e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ec:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01048f1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01048f4:	72 23                	jb     c0104919 <page2kva+0x4a>
c01048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048fd:	c7 44 24 08 64 7b 10 	movl   $0xc0107b64,0x8(%esp)
c0104904:	c0 
c0104905:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c010490c:	00 
c010490d:	c7 04 24 53 7b 10 c0 	movl   $0xc0107b53,(%esp)
c0104914:	e8 d1 c3 ff ff       	call   c0100cea <__panic>
c0104919:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010491c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104921:	89 ec                	mov    %ebp,%esp
c0104923:	5d                   	pop    %ebp
c0104924:	c3                   	ret    

c0104925 <pte2page>:
pte2page(pte_t pte) {
c0104925:	55                   	push   %ebp
c0104926:	89 e5                	mov    %esp,%ebp
c0104928:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010492b:	8b 45 08             	mov    0x8(%ebp),%eax
c010492e:	83 e0 01             	and    $0x1,%eax
c0104931:	85 c0                	test   %eax,%eax
c0104933:	75 1c                	jne    c0104951 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104935:	c7 44 24 08 88 7b 10 	movl   $0xc0107b88,0x8(%esp)
c010493c:	c0 
c010493d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0104944:	00 
c0104945:	c7 04 24 53 7b 10 c0 	movl   $0xc0107b53,(%esp)
c010494c:	e8 99 c3 ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c0104951:	8b 45 08             	mov    0x8(%ebp),%eax
c0104954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104959:	89 04 24             	mov    %eax,(%esp)
c010495c:	e8 1d ff ff ff       	call   c010487e <pa2page>
}
c0104961:	89 ec                	mov    %ebp,%esp
c0104963:	5d                   	pop    %ebp
c0104964:	c3                   	ret    

c0104965 <pde2page>:
pde2page(pde_t pde) {
c0104965:	55                   	push   %ebp
c0104966:	89 e5                	mov    %esp,%ebp
c0104968:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010496b:	8b 45 08             	mov    0x8(%ebp),%eax
c010496e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104973:	89 04 24             	mov    %eax,(%esp)
c0104976:	e8 03 ff ff ff       	call   c010487e <pa2page>
}
c010497b:	89 ec                	mov    %ebp,%esp
c010497d:	5d                   	pop    %ebp
c010497e:	c3                   	ret    

c010497f <page_ref>:
page_ref(struct Page *page) {
c010497f:	55                   	push   %ebp
c0104980:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104982:	8b 45 08             	mov    0x8(%ebp),%eax
c0104985:	8b 00                	mov    (%eax),%eax
}
c0104987:	5d                   	pop    %ebp
c0104988:	c3                   	ret    

c0104989 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104989:	55                   	push   %ebp
c010498a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010498c:	8b 45 08             	mov    0x8(%ebp),%eax
c010498f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104992:	89 10                	mov    %edx,(%eax)
}
c0104994:	90                   	nop
c0104995:	5d                   	pop    %ebp
c0104996:	c3                   	ret    

c0104997 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104997:	55                   	push   %ebp
c0104998:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010499a:	8b 45 08             	mov    0x8(%ebp),%eax
c010499d:	8b 00                	mov    (%eax),%eax
c010499f:	8d 50 01             	lea    0x1(%eax),%edx
c01049a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01049a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01049aa:	8b 00                	mov    (%eax),%eax
}
c01049ac:	5d                   	pop    %ebp
c01049ad:	c3                   	ret    

c01049ae <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01049ae:	55                   	push   %ebp
c01049af:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01049b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01049b4:	8b 00                	mov    (%eax),%eax
c01049b6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01049b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01049bc:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01049be:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c1:	8b 00                	mov    (%eax),%eax
}
c01049c3:	5d                   	pop    %ebp
c01049c4:	c3                   	ret    

c01049c5 <__intr_save>:
{
c01049c5:	55                   	push   %ebp
c01049c6:	89 e5                	mov    %esp,%ebp
c01049c8:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
c01049cb:	9c                   	pushf  
c01049cc:	58                   	pop    %eax
c01049cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
c01049d3:	25 00 02 00 00       	and    $0x200,%eax
c01049d8:	85 c0                	test   %eax,%eax
c01049da:	74 0c                	je     c01049e8 <__intr_save+0x23>
        intr_disable();
c01049dc:	e8 62 cd ff ff       	call   c0101743 <intr_disable>
        return 1;
c01049e1:	b8 01 00 00 00       	mov    $0x1,%eax
c01049e6:	eb 05                	jmp    c01049ed <__intr_save+0x28>
    return 0;
c01049e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049ed:	89 ec                	mov    %ebp,%esp
c01049ef:	5d                   	pop    %ebp
c01049f0:	c3                   	ret    

c01049f1 <__intr_restore>:
{
c01049f1:	55                   	push   %ebp
c01049f2:	89 e5                	mov    %esp,%ebp
c01049f4:	83 ec 08             	sub    $0x8,%esp
    if (flag)
c01049f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049fb:	74 05                	je     c0104a02 <__intr_restore+0x11>
        intr_enable();
c01049fd:	e8 39 cd ff ff       	call   c010173b <intr_enable>
}
c0104a02:	90                   	nop
c0104a03:	89 ec                	mov    %ebp,%esp
c0104a05:	5d                   	pop    %ebp
c0104a06:	c3                   	ret    

c0104a07 <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
c0104a07:	55                   	push   %ebp
c0104a08:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
c0104a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a0d:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
c0104a10:	b8 23 00 00 00       	mov    $0x23,%eax
c0104a15:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
c0104a17:	b8 23 00 00 00       	mov    $0x23,%eax
c0104a1c:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
c0104a1e:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a23:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
c0104a25:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a2a:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
c0104a2c:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a31:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
c0104a33:	ea 3a 4a 10 c0 08 00 	ljmp   $0x8,$0xc0104a3a
}
c0104a3a:	90                   	nop
c0104a3b:	5d                   	pop    %ebp
c0104a3c:	c3                   	ret    

c0104a3d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
c0104a3d:	55                   	push   %ebp
c0104a3e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a43:	a3 c4 ee 11 c0       	mov    %eax,0xc011eec4
}
c0104a48:	90                   	nop
c0104a49:	5d                   	pop    %ebp
c0104a4a:	c3                   	ret    

c0104a4b <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
c0104a4b:	55                   	push   %ebp
c0104a4c:	89 e5                	mov    %esp,%ebp
c0104a4e:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104a51:	b8 00 b0 11 c0       	mov    $0xc011b000,%eax
c0104a56:	89 04 24             	mov    %eax,(%esp)
c0104a59:	e8 df ff ff ff       	call   c0104a3d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104a5e:	66 c7 05 c8 ee 11 c0 	movw   $0x10,0xc011eec8
c0104a65:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104a67:	66 c7 05 28 ba 11 c0 	movw   $0x68,0xc011ba28
c0104a6e:	68 00 
c0104a70:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a75:	0f b7 c0             	movzwl %ax,%eax
c0104a78:	66 a3 2a ba 11 c0    	mov    %ax,0xc011ba2a
c0104a7e:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a83:	c1 e8 10             	shr    $0x10,%eax
c0104a86:	a2 2c ba 11 c0       	mov    %al,0xc011ba2c
c0104a8b:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a92:	24 f0                	and    $0xf0,%al
c0104a94:	0c 09                	or     $0x9,%al
c0104a96:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104a9b:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104aa2:	24 ef                	and    $0xef,%al
c0104aa4:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104aa9:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104ab0:	24 9f                	and    $0x9f,%al
c0104ab2:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104ab7:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104abe:	0c 80                	or     $0x80,%al
c0104ac0:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104ac5:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104acc:	24 f0                	and    $0xf0,%al
c0104ace:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104ad3:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104ada:	24 ef                	and    $0xef,%al
c0104adc:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104ae1:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104ae8:	24 df                	and    $0xdf,%al
c0104aea:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104aef:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104af6:	0c 40                	or     $0x40,%al
c0104af8:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104afd:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104b04:	24 7f                	and    $0x7f,%al
c0104b06:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104b0b:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104b10:	c1 e8 18             	shr    $0x18,%eax
c0104b13:	a2 2f ba 11 c0       	mov    %al,0xc011ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104b18:	c7 04 24 30 ba 11 c0 	movl   $0xc011ba30,(%esp)
c0104b1f:	e8 e3 fe ff ff       	call   c0104a07 <lgdt>
c0104b24:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
c0104b2a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104b2e:	0f 00 d8             	ltr    %ax
}
c0104b31:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0104b32:	90                   	nop
c0104b33:	89 ec                	mov    %ebp,%esp
c0104b35:	5d                   	pop    %ebp
c0104b36:	c3                   	ret    

c0104b37 <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
c0104b37:	55                   	push   %ebp
c0104b38:	89 e5                	mov    %esp,%ebp
c0104b3a:	83 ec 18             	sub    $0x18,%esp
    //pmm_manager = &default_pmm_manager;
    pmm_manager = &buddy_pmm_manager;
c0104b3d:	c7 05 ac ee 11 c0 54 	movl   $0xc0107754,0xc011eeac
c0104b44:	77 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104b47:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b4c:	8b 00                	mov    (%eax),%eax
c0104b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b52:	c7 04 24 b4 7b 10 c0 	movl   $0xc0107bb4,(%esp)
c0104b59:	e8 07 b8 ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c0104b5e:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b63:	8b 40 04             	mov    0x4(%eax),%eax
c0104b66:	ff d0                	call   *%eax
}
c0104b68:	90                   	nop
c0104b69:	89 ec                	mov    %ebp,%esp
c0104b6b:	5d                   	pop    %ebp
c0104b6c:	c3                   	ret    

c0104b6d <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
c0104b6d:	55                   	push   %ebp
c0104b6e:	89 e5                	mov    %esp,%ebp
c0104b70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104b73:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b78:	8b 40 08             	mov    0x8(%eax),%eax
c0104b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b7e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b82:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b85:	89 14 24             	mov    %edx,(%esp)
c0104b88:	ff d0                	call   *%eax
}
c0104b8a:	90                   	nop
c0104b8b:	89 ec                	mov    %ebp,%esp
c0104b8d:	5d                   	pop    %ebp
c0104b8e:	c3                   	ret    

c0104b8f <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
c0104b8f:	55                   	push   %ebp
c0104b90:	89 e5                	mov    %esp,%ebp
c0104b92:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c0104b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0104b9c:	e8 24 fe ff ff       	call   c01049c5 <__intr_save>
c0104ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0104ba4:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104ba9:	8b 40 0c             	mov    0xc(%eax),%eax
c0104bac:	8b 55 08             	mov    0x8(%ebp),%edx
c0104baf:	89 14 24             	mov    %edx,(%esp)
c0104bb2:	ff d0                	call   *%eax
c0104bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bba:	89 04 24             	mov    %eax,(%esp)
c0104bbd:	e8 2f fe ff ff       	call   c01049f1 <__intr_restore>
    return page;
c0104bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104bc5:	89 ec                	mov    %ebp,%esp
c0104bc7:	5d                   	pop    %ebp
c0104bc8:	c3                   	ret    

c0104bc9 <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
c0104bc9:	55                   	push   %ebp
c0104bca:	89 e5                	mov    %esp,%ebp
c0104bcc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104bcf:	e8 f1 fd ff ff       	call   c01049c5 <__intr_save>
c0104bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104bd7:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104bdc:	8b 40 10             	mov    0x10(%eax),%eax
c0104bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104be2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104be6:	8b 55 08             	mov    0x8(%ebp),%edx
c0104be9:	89 14 24             	mov    %edx,(%esp)
c0104bec:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf1:	89 04 24             	mov    %eax,(%esp)
c0104bf4:	e8 f8 fd ff ff       	call   c01049f1 <__intr_restore>
}
c0104bf9:	90                   	nop
c0104bfa:	89 ec                	mov    %ebp,%esp
c0104bfc:	5d                   	pop    %ebp
c0104bfd:	c3                   	ret    

c0104bfe <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
c0104bfe:	55                   	push   %ebp
c0104bff:	89 e5                	mov    %esp,%ebp
c0104c01:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104c04:	e8 bc fd ff ff       	call   c01049c5 <__intr_save>
c0104c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104c0c:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104c11:	8b 40 14             	mov    0x14(%eax),%eax
c0104c14:	ff d0                	call   *%eax
c0104c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1c:	89 04 24             	mov    %eax,(%esp)
c0104c1f:	e8 cd fd ff ff       	call   c01049f1 <__intr_restore>
    return ret;
c0104c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104c27:	89 ec                	mov    %ebp,%esp
c0104c29:	5d                   	pop    %ebp
c0104c2a:	c3                   	ret    

c0104c2b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
c0104c2b:	55                   	push   %ebp
c0104c2c:	89 e5                	mov    %esp,%ebp
c0104c2e:	57                   	push   %edi
c0104c2f:	56                   	push   %esi
c0104c30:	53                   	push   %ebx
c0104c31:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104c37:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104c3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104c45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104c4c:	c7 04 24 cb 7b 10 c0 	movl   $0xc0107bcb,(%esp)
c0104c53:	e8 0d b7 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
c0104c58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104c5f:	e9 0c 01 00 00       	jmp    c0104d70 <page_init+0x145>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104c64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c67:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c6a:	89 d0                	mov    %edx,%eax
c0104c6c:	c1 e0 02             	shl    $0x2,%eax
c0104c6f:	01 d0                	add    %edx,%eax
c0104c71:	c1 e0 02             	shl    $0x2,%eax
c0104c74:	01 c8                	add    %ecx,%eax
c0104c76:	8b 50 08             	mov    0x8(%eax),%edx
c0104c79:	8b 40 04             	mov    0x4(%eax),%eax
c0104c7c:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104c7f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104c82:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c85:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c88:	89 d0                	mov    %edx,%eax
c0104c8a:	c1 e0 02             	shl    $0x2,%eax
c0104c8d:	01 d0                	add    %edx,%eax
c0104c8f:	c1 e0 02             	shl    $0x2,%eax
c0104c92:	01 c8                	add    %ecx,%eax
c0104c94:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104c97:	8b 58 10             	mov    0x10(%eax),%ebx
c0104c9a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104c9d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104ca0:	01 c8                	add    %ecx,%eax
c0104ca2:	11 da                	adc    %ebx,%edx
c0104ca4:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104ca7:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104caa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104cad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cb0:	89 d0                	mov    %edx,%eax
c0104cb2:	c1 e0 02             	shl    $0x2,%eax
c0104cb5:	01 d0                	add    %edx,%eax
c0104cb7:	c1 e0 02             	shl    $0x2,%eax
c0104cba:	01 c8                	add    %ecx,%eax
c0104cbc:	83 c0 14             	add    $0x14,%eax
c0104cbf:	8b 00                	mov    (%eax),%eax
c0104cc1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104cc7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104cca:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104ccd:	83 c0 ff             	add    $0xffffffff,%eax
c0104cd0:	83 d2 ff             	adc    $0xffffffff,%edx
c0104cd3:	89 c6                	mov    %eax,%esi
c0104cd5:	89 d7                	mov    %edx,%edi
c0104cd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104cda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cdd:	89 d0                	mov    %edx,%eax
c0104cdf:	c1 e0 02             	shl    $0x2,%eax
c0104ce2:	01 d0                	add    %edx,%eax
c0104ce4:	c1 e0 02             	shl    $0x2,%eax
c0104ce7:	01 c8                	add    %ecx,%eax
c0104ce9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104cec:	8b 58 10             	mov    0x10(%eax),%ebx
c0104cef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104cf5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104cf9:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104cfd:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104d01:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104d04:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104d07:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d0b:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104d0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104d13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104d17:	c7 04 24 d8 7b 10 c0 	movl   $0xc0107bd8,(%esp)
c0104d1e:	e8 42 b6 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
c0104d23:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104d26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104d29:	89 d0                	mov    %edx,%eax
c0104d2b:	c1 e0 02             	shl    $0x2,%eax
c0104d2e:	01 d0                	add    %edx,%eax
c0104d30:	c1 e0 02             	shl    $0x2,%eax
c0104d33:	01 c8                	add    %ecx,%eax
c0104d35:	83 c0 14             	add    $0x14,%eax
c0104d38:	8b 00                	mov    (%eax),%eax
c0104d3a:	83 f8 01             	cmp    $0x1,%eax
c0104d3d:	75 2e                	jne    c0104d6d <page_init+0x142>
        {
            if (maxpa < end && begin < KMEMSIZE)
c0104d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d45:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104d48:	89 d0                	mov    %edx,%eax
c0104d4a:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104d4d:	73 1e                	jae    c0104d6d <page_init+0x142>
c0104d4f:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0104d54:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d59:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104d5c:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104d5f:	72 0c                	jb     c0104d6d <page_init+0x142>
            {
                maxpa = end;
c0104d61:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104d64:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104d6a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
c0104d6d:	ff 45 dc             	incl   -0x24(%ebp)
c0104d70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d73:	8b 00                	mov    (%eax),%eax
c0104d75:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d78:	0f 8c e6 fe ff ff    	jl     c0104c64 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE)
c0104d7e:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104d83:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d88:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104d8b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104d8e:	73 0e                	jae    c0104d9e <page_init+0x173>
    {
        maxpa = KMEMSIZE;
c0104d90:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104d97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104da4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104da8:	c1 ea 0c             	shr    $0xc,%edx
c0104dab:	a3 a4 ee 11 c0       	mov    %eax,0xc011eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104db0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104db7:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c0104dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104dbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104dc2:	01 d0                	add    %edx,%eax
c0104dc4:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104dc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104dca:	ba 00 00 00 00       	mov    $0x0,%edx
c0104dcf:	f7 75 c0             	divl   -0x40(%ebp)
c0104dd2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104dd5:	29 d0                	sub    %edx,%eax
c0104dd7:	a3 a0 ee 11 c0       	mov    %eax,0xc011eea0

    for (i = 0; i < npage; i++)
c0104ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104de3:	eb 2f                	jmp    c0104e14 <page_init+0x1e9>
    {
        SetPageReserved(pages + i);
c0104de5:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c0104deb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104dee:	89 d0                	mov    %edx,%eax
c0104df0:	c1 e0 02             	shl    $0x2,%eax
c0104df3:	01 d0                	add    %edx,%eax
c0104df5:	c1 e0 02             	shl    $0x2,%eax
c0104df8:	01 c8                	add    %ecx,%eax
c0104dfa:	83 c0 04             	add    $0x4,%eax
c0104dfd:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104e04:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
c0104e07:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104e0a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104e0d:	0f ab 10             	bts    %edx,(%eax)
}
c0104e10:	90                   	nop
    for (i = 0; i < npage; i++)
c0104e11:	ff 45 dc             	incl   -0x24(%ebp)
c0104e14:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e17:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104e1c:	39 c2                	cmp    %eax,%edx
c0104e1e:	72 c5                	jb     c0104de5 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104e20:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0104e26:	89 d0                	mov    %edx,%eax
c0104e28:	c1 e0 02             	shl    $0x2,%eax
c0104e2b:	01 d0                	add    %edx,%eax
c0104e2d:	c1 e0 02             	shl    $0x2,%eax
c0104e30:	89 c2                	mov    %eax,%edx
c0104e32:	a1 a0 ee 11 c0       	mov    0xc011eea0,%eax
c0104e37:	01 d0                	add    %edx,%eax
c0104e39:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e3c:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104e43:	77 23                	ja     c0104e68 <page_init+0x23d>
c0104e45:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e48:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e4c:	c7 44 24 08 08 7c 10 	movl   $0xc0107c08,0x8(%esp)
c0104e53:	c0 
c0104e54:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104e5b:	00 
c0104e5c:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0104e63:	e8 82 be ff ff       	call   c0100cea <__panic>
c0104e68:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e6b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e70:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
c0104e73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e7a:	e9 53 01 00 00       	jmp    c0104fd2 <page_init+0x3a7>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e85:	89 d0                	mov    %edx,%eax
c0104e87:	c1 e0 02             	shl    $0x2,%eax
c0104e8a:	01 d0                	add    %edx,%eax
c0104e8c:	c1 e0 02             	shl    $0x2,%eax
c0104e8f:	01 c8                	add    %ecx,%eax
c0104e91:	8b 50 08             	mov    0x8(%eax),%edx
c0104e94:	8b 40 04             	mov    0x4(%eax),%eax
c0104e97:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104e9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104e9d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ea0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ea3:	89 d0                	mov    %edx,%eax
c0104ea5:	c1 e0 02             	shl    $0x2,%eax
c0104ea8:	01 d0                	add    %edx,%eax
c0104eaa:	c1 e0 02             	shl    $0x2,%eax
c0104ead:	01 c8                	add    %ecx,%eax
c0104eaf:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104eb2:	8b 58 10             	mov    0x10(%eax),%ebx
c0104eb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104eb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ebb:	01 c8                	add    %ecx,%eax
c0104ebd:	11 da                	adc    %ebx,%edx
c0104ebf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104ec2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
c0104ec5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ec8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ecb:	89 d0                	mov    %edx,%eax
c0104ecd:	c1 e0 02             	shl    $0x2,%eax
c0104ed0:	01 d0                	add    %edx,%eax
c0104ed2:	c1 e0 02             	shl    $0x2,%eax
c0104ed5:	01 c8                	add    %ecx,%eax
c0104ed7:	83 c0 14             	add    $0x14,%eax
c0104eda:	8b 00                	mov    (%eax),%eax
c0104edc:	83 f8 01             	cmp    $0x1,%eax
c0104edf:	0f 85 ea 00 00 00    	jne    c0104fcf <page_init+0x3a4>
        {
            if (begin < freemem)
c0104ee5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104ee8:	ba 00 00 00 00       	mov    $0x0,%edx
c0104eed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104ef0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104ef3:	19 d1                	sbb    %edx,%ecx
c0104ef5:	73 0d                	jae    c0104f04 <page_init+0x2d9>
            {
                begin = freemem;
c0104ef7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104efa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104efd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
c0104f04:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104f09:	b8 00 00 00 00       	mov    $0x0,%eax
c0104f0e:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104f11:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104f14:	73 0e                	jae    c0104f24 <page_init+0x2f9>
            {
                end = KMEMSIZE;
c0104f16:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104f1d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
c0104f24:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f2a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104f2d:	89 d0                	mov    %edx,%eax
c0104f2f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104f32:	0f 83 97 00 00 00    	jae    c0104fcf <page_init+0x3a4>
            {
                begin = ROUNDUP(begin, PGSIZE);
c0104f38:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0104f3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104f42:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f45:	01 d0                	add    %edx,%eax
c0104f47:	48                   	dec    %eax
c0104f48:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104f4b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f4e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f53:	f7 75 b0             	divl   -0x50(%ebp)
c0104f56:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f59:	29 d0                	sub    %edx,%eax
c0104f5b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f60:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f63:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104f66:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104f69:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104f6c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f6f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f74:	89 c7                	mov    %eax,%edi
c0104f76:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104f7c:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104f7f:	89 d0                	mov    %edx,%eax
c0104f81:	83 e0 00             	and    $0x0,%eax
c0104f84:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104f87:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104f8a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f8d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104f90:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
c0104f93:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f99:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104f9c:	89 d0                	mov    %edx,%eax
c0104f9e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104fa1:	73 2c                	jae    c0104fcf <page_init+0x3a4>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104fa3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104fa6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104fa9:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104fac:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104faf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104fb3:	c1 ea 0c             	shr    $0xc,%edx
c0104fb6:	89 c3                	mov    %eax,%ebx
c0104fb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104fbb:	89 04 24             	mov    %eax,(%esp)
c0104fbe:	e8 bb f8 ff ff       	call   c010487e <pa2page>
c0104fc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104fc7:	89 04 24             	mov    %eax,(%esp)
c0104fca:	e8 9e fb ff ff       	call   c0104b6d <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
c0104fcf:	ff 45 dc             	incl   -0x24(%ebp)
c0104fd2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104fd5:	8b 00                	mov    (%eax),%eax
c0104fd7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fda:	0f 8c 9f fe ff ff    	jl     c0104e7f <page_init+0x254>
                }
            }
        }
    }
}
c0104fe0:	90                   	nop
c0104fe1:	90                   	nop
c0104fe2:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104fe8:	5b                   	pop    %ebx
c0104fe9:	5e                   	pop    %esi
c0104fea:	5f                   	pop    %edi
c0104feb:	5d                   	pop    %ebp
c0104fec:	c3                   	ret    

c0104fed <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
c0104fed:	55                   	push   %ebp
c0104fee:	89 e5                	mov    %esp,%ebp
c0104ff0:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ff6:	33 45 14             	xor    0x14(%ebp),%eax
c0104ff9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104ffe:	85 c0                	test   %eax,%eax
c0105000:	74 24                	je     c0105026 <boot_map_segment+0x39>
c0105002:	c7 44 24 0c 3a 7c 10 	movl   $0xc0107c3a,0xc(%esp)
c0105009:	c0 
c010500a:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105011:	c0 
c0105012:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0105019:	00 
c010501a:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105021:	e8 c4 bc ff ff       	call   c0100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105026:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010502d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105030:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105035:	89 c2                	mov    %eax,%edx
c0105037:	8b 45 10             	mov    0x10(%ebp),%eax
c010503a:	01 c2                	add    %eax,%edx
c010503c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010503f:	01 d0                	add    %edx,%eax
c0105041:	48                   	dec    %eax
c0105042:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105045:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105048:	ba 00 00 00 00       	mov    $0x0,%edx
c010504d:	f7 75 f0             	divl   -0x10(%ebp)
c0105050:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105053:	29 d0                	sub    %edx,%eax
c0105055:	c1 e8 0c             	shr    $0xc,%eax
c0105058:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010505b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010505e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105061:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105069:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010506c:	8b 45 14             	mov    0x14(%ebp),%eax
c010506f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010507a:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c010507d:	eb 68                	jmp    c01050e7 <boot_map_segment+0xfa>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
c010507f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105086:	00 
c0105087:	8b 45 0c             	mov    0xc(%ebp),%eax
c010508a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010508e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105091:	89 04 24             	mov    %eax,(%esp)
c0105094:	e8 88 01 00 00       	call   c0105221 <get_pte>
c0105099:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010509c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01050a0:	75 24                	jne    c01050c6 <boot_map_segment+0xd9>
c01050a2:	c7 44 24 0c 66 7c 10 	movl   $0xc0107c66,0xc(%esp)
c01050a9:	c0 
c01050aa:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01050b1:	c0 
c01050b2:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01050b9:	00 
c01050ba:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01050c1:	e8 24 bc ff ff       	call   c0100cea <__panic>
        *ptep = pa | PTE_P | perm;
c01050c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01050c9:	0b 45 18             	or     0x18(%ebp),%eax
c01050cc:	83 c8 01             	or     $0x1,%eax
c01050cf:	89 c2                	mov    %eax,%edx
c01050d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050d4:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c01050d6:	ff 4d f4             	decl   -0xc(%ebp)
c01050d9:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01050e0:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01050e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050eb:	75 92                	jne    c010507f <boot_map_segment+0x92>
    }
}
c01050ed:	90                   	nop
c01050ee:	90                   	nop
c01050ef:	89 ec                	mov    %ebp,%esp
c01050f1:	5d                   	pop    %ebp
c01050f2:	c3                   	ret    

c01050f3 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
c01050f3:	55                   	push   %ebp
c01050f4:	89 e5                	mov    %esp,%ebp
c01050f6:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01050f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105100:	e8 8a fa ff ff       	call   c0104b8f <alloc_pages>
c0105105:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
c0105108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010510c:	75 1c                	jne    c010512a <boot_alloc_page+0x37>
    {
        panic("boot_alloc_page failed.\n");
c010510e:	c7 44 24 08 73 7c 10 	movl   $0xc0107c73,0x8(%esp)
c0105115:	c0 
c0105116:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010511d:	00 
c010511e:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105125:	e8 c0 bb ff ff       	call   c0100cea <__panic>
    }
    return page2kva(p);
c010512a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010512d:	89 04 24             	mov    %eax,(%esp)
c0105130:	e8 9a f7 ff ff       	call   c01048cf <page2kva>
}
c0105135:	89 ec                	mov    %ebp,%esp
c0105137:	5d                   	pop    %ebp
c0105138:	c3                   	ret    

c0105139 <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
c0105139:	55                   	push   %ebp
c010513a:	89 e5                	mov    %esp,%ebp
c010513c:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010513f:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105144:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105147:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010514e:	77 23                	ja     c0105173 <pmm_init+0x3a>
c0105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105153:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105157:	c7 44 24 08 08 7c 10 	movl   $0xc0107c08,0x8(%esp)
c010515e:	c0 
c010515f:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0105166:	00 
c0105167:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c010516e:	e8 77 bb ff ff       	call   c0100cea <__panic>
c0105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105176:	05 00 00 00 40       	add    $0x40000000,%eax
c010517b:	a3 a8 ee 11 c0       	mov    %eax,0xc011eea8
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105180:	e8 b2 f9 ff ff       	call   c0104b37 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105185:	e8 a1 fa ff ff       	call   c0104c2b <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010518a:	e8 ed 03 00 00       	call   c010557c <check_alloc_page>

    check_pgdir();
c010518f:	e8 09 04 00 00       	call   c010559d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105194:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105199:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010519c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01051a3:	77 23                	ja     c01051c8 <pmm_init+0x8f>
c01051a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051ac:	c7 44 24 08 08 7c 10 	movl   $0xc0107c08,0x8(%esp)
c01051b3:	c0 
c01051b4:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c01051bb:	00 
c01051bc:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01051c3:	e8 22 bb ff ff       	call   c0100cea <__panic>
c01051c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051cb:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01051d1:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01051d6:	05 ac 0f 00 00       	add    $0xfac,%eax
c01051db:	83 ca 03             	or     $0x3,%edx
c01051de:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01051e0:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01051e5:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01051ec:	00 
c01051ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01051f4:	00 
c01051f5:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01051fc:	38 
c01051fd:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105204:	c0 
c0105205:	89 04 24             	mov    %eax,(%esp)
c0105208:	e8 e0 fd ff ff       	call   c0104fed <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010520d:	e8 39 f8 ff ff       	call   c0104a4b <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105212:	e8 24 0a 00 00       	call   c0105c3b <check_boot_pgdir>

    print_pgdir();
c0105217:	e8 a1 0e 00 00       	call   c01060bd <print_pgdir>
}
c010521c:	90                   	nop
c010521d:	89 ec                	mov    %ebp,%esp
c010521f:	5d                   	pop    %ebp
c0105220:	c3                   	ret    

c0105221 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
c0105221:	55                   	push   %ebp
c0105222:	89 e5                	mov    %esp,%ebp
c0105224:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep = &pgdir[PDX(la)];
c0105227:	8b 45 0c             	mov    0xc(%ebp),%eax
c010522a:	c1 e8 16             	shr    $0x16,%eax
c010522d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105234:	8b 45 08             	mov    0x8(%ebp),%eax
c0105237:	01 d0                	add    %edx,%eax
c0105239:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
c010523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010523f:	8b 00                	mov    (%eax),%eax
c0105241:	83 e0 01             	and    $0x1,%eax
c0105244:	85 c0                	test   %eax,%eax
c0105246:	0f 85 af 00 00 00    	jne    c01052fb <get_pte+0xda>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
c010524c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105250:	74 15                	je     c0105267 <get_pte+0x46>
c0105252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105259:	e8 31 f9 ff ff       	call   c0104b8f <alloc_pages>
c010525e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105265:	75 0a                	jne    c0105271 <get_pte+0x50>
        {
            return NULL;
c0105267:	b8 00 00 00 00       	mov    $0x0,%eax
c010526c:	e9 e7 00 00 00       	jmp    c0105358 <get_pte+0x137>
        }
        //设置page reference
        set_page_ref(page, 1);
c0105271:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105278:	00 
c0105279:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010527c:	89 04 24             	mov    %eax,(%esp)
c010527f:	e8 05 f7 ff ff       	call   c0104989 <set_page_ref>
        //得到page的线性地址
        uintptr_t pa = page2pa(page);
c0105284:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105287:	89 04 24             	mov    %eax,(%esp)
c010528a:	e8 d7 f5 ff ff       	call   c0104866 <page2pa>
c010528f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        //用memset清除page
        memset(KADDR(pa), 0, PGSIZE);
c0105292:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105295:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105298:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010529b:	c1 e8 0c             	shr    $0xc,%eax
c010529e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052a1:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01052a6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01052a9:	72 23                	jb     c01052ce <get_pte+0xad>
c01052ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01052b2:	c7 44 24 08 64 7b 10 	movl   $0xc0107b64,0x8(%esp)
c01052b9:	c0 
c01052ba:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
c01052c1:	00 
c01052c2:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01052c9:	e8 1c ba ff ff       	call   c0100cea <__panic>
c01052ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052d1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01052d6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01052dd:	00 
c01052de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052e5:	00 
c01052e6:	89 04 24             	mov    %eax,(%esp)
c01052e9:	e8 d4 18 00 00       	call   c0106bc2 <memset>
        //返回PTE
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01052ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052f1:	83 c8 07             	or     $0x7,%eax
c01052f4:	89 c2                	mov    %eax,%edx
c01052f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052f9:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01052fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052fe:	8b 00                	mov    (%eax),%eax
c0105300:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105305:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105308:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010530b:	c1 e8 0c             	shr    $0xc,%eax
c010530e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105311:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105316:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105319:	72 23                	jb     c010533e <get_pte+0x11d>
c010531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010531e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105322:	c7 44 24 08 64 7b 10 	movl   $0xc0107b64,0x8(%esp)
c0105329:	c0 
c010532a:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
c0105331:	00 
c0105332:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105339:	e8 ac b9 ff ff       	call   c0100cea <__panic>
c010533e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105341:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105346:	89 c2                	mov    %eax,%edx
c0105348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010534b:	c1 e8 0c             	shr    $0xc,%eax
c010534e:	25 ff 03 00 00       	and    $0x3ff,%eax
c0105353:	c1 e0 02             	shl    $0x2,%eax
c0105356:	01 d0                	add    %edx,%eax
}
c0105358:	89 ec                	mov    %ebp,%esp
c010535a:	5d                   	pop    %ebp
c010535b:	c3                   	ret    

c010535c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
c010535c:	55                   	push   %ebp
c010535d:	89 e5                	mov    %esp,%ebp
c010535f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105362:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105369:	00 
c010536a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010536d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105371:	8b 45 08             	mov    0x8(%ebp),%eax
c0105374:	89 04 24             	mov    %eax,(%esp)
c0105377:	e8 a5 fe ff ff       	call   c0105221 <get_pte>
c010537c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
c010537f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105383:	74 08                	je     c010538d <get_page+0x31>
    {
        *ptep_store = ptep;
c0105385:	8b 45 10             	mov    0x10(%ebp),%eax
c0105388:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010538b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
c010538d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105391:	74 1b                	je     c01053ae <get_page+0x52>
c0105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105396:	8b 00                	mov    (%eax),%eax
c0105398:	83 e0 01             	and    $0x1,%eax
c010539b:	85 c0                	test   %eax,%eax
c010539d:	74 0f                	je     c01053ae <get_page+0x52>
    {
        return pte2page(*ptep);
c010539f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053a2:	8b 00                	mov    (%eax),%eax
c01053a4:	89 04 24             	mov    %eax,(%esp)
c01053a7:	e8 79 f5 ff ff       	call   c0104925 <pte2page>
c01053ac:	eb 05                	jmp    c01053b3 <get_page+0x57>
    }
    return NULL;
c01053ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053b3:	89 ec                	mov    %ebp,%esp
c01053b5:	5d                   	pop    %ebp
c01053b6:	c3                   	ret    

c01053b7 <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
c01053b7:	55                   	push   %ebp
c01053b8:	89 e5                	mov    %esp,%ebp
c01053ba:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
c01053bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c0:	8b 00                	mov    (%eax),%eax
c01053c2:	83 e0 01             	and    $0x1,%eax
c01053c5:	85 c0                	test   %eax,%eax
c01053c7:	74 4d                	je     c0105416 <page_remove_pte+0x5f>
    {
        struct Page *page = pte2page(*ptep);
c01053c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01053cc:	8b 00                	mov    (%eax),%eax
c01053ce:	89 04 24             	mov    %eax,(%esp)
c01053d1:	e8 4f f5 ff ff       	call   c0104925 <pte2page>
c01053d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //  (page_ref_dec(page)将page的ref减1,并返回减1之后的ref
        if (page_ref_dec(page) == 0)
c01053d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053dc:	89 04 24             	mov    %eax,(%esp)
c01053df:	e8 ca f5 ff ff       	call   c01049ae <page_ref_dec>
c01053e4:	85 c0                	test   %eax,%eax
c01053e6:	75 13                	jne    c01053fb <page_remove_pte+0x44>
        {
            free_page(page);
c01053e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053ef:	00 
c01053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053f3:	89 04 24             	mov    %eax,(%esp)
c01053f6:	e8 ce f7 ff ff       	call   c0104bc9 <free_pages>
        }
        //清除第二个页表 PTE
        *ptep = 0;
c01053fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01053fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105407:	89 44 24 04          	mov    %eax,0x4(%esp)
c010540b:	8b 45 08             	mov    0x8(%ebp),%eax
c010540e:	89 04 24             	mov    %eax,(%esp)
c0105411:	e8 07 01 00 00       	call   c010551d <tlb_invalidate>
    }
}
c0105416:	90                   	nop
c0105417:	89 ec                	mov    %ebp,%esp
c0105419:	5d                   	pop    %ebp
c010541a:	c3                   	ret    

c010541b <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
c010541b:	55                   	push   %ebp
c010541c:	89 e5                	mov    %esp,%ebp
c010541e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105421:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105428:	00 
c0105429:	8b 45 0c             	mov    0xc(%ebp),%eax
c010542c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105430:	8b 45 08             	mov    0x8(%ebp),%eax
c0105433:	89 04 24             	mov    %eax,(%esp)
c0105436:	e8 e6 fd ff ff       	call   c0105221 <get_pte>
c010543b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
c010543e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105442:	74 19                	je     c010545d <page_remove+0x42>
    {
        page_remove_pte(pgdir, la, ptep);
c0105444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105447:	89 44 24 08          	mov    %eax,0x8(%esp)
c010544b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010544e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105452:	8b 45 08             	mov    0x8(%ebp),%eax
c0105455:	89 04 24             	mov    %eax,(%esp)
c0105458:	e8 5a ff ff ff       	call   c01053b7 <page_remove_pte>
    }
}
c010545d:	90                   	nop
c010545e:	89 ec                	mov    %ebp,%esp
c0105460:	5d                   	pop    %ebp
c0105461:	c3                   	ret    

c0105462 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
c0105462:	55                   	push   %ebp
c0105463:	89 e5                	mov    %esp,%ebp
c0105465:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010546f:	00 
c0105470:	8b 45 10             	mov    0x10(%ebp),%eax
c0105473:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105477:	8b 45 08             	mov    0x8(%ebp),%eax
c010547a:	89 04 24             	mov    %eax,(%esp)
c010547d:	e8 9f fd ff ff       	call   c0105221 <get_pte>
c0105482:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
c0105485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105489:	75 0a                	jne    c0105495 <page_insert+0x33>
    {
        return -E_NO_MEM;
c010548b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105490:	e9 84 00 00 00       	jmp    c0105519 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105495:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105498:	89 04 24             	mov    %eax,(%esp)
c010549b:	e8 f7 f4 ff ff       	call   c0104997 <page_ref_inc>
    if (*ptep & PTE_P)
c01054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054a3:	8b 00                	mov    (%eax),%eax
c01054a5:	83 e0 01             	and    $0x1,%eax
c01054a8:	85 c0                	test   %eax,%eax
c01054aa:	74 3e                	je     c01054ea <page_insert+0x88>
    {
        struct Page *p = pte2page(*ptep);
c01054ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054af:	8b 00                	mov    (%eax),%eax
c01054b1:	89 04 24             	mov    %eax,(%esp)
c01054b4:	e8 6c f4 ff ff       	call   c0104925 <pte2page>
c01054b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
c01054bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054c2:	75 0d                	jne    c01054d1 <page_insert+0x6f>
        {
            page_ref_dec(page);
c01054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c7:	89 04 24             	mov    %eax,(%esp)
c01054ca:	e8 df f4 ff ff       	call   c01049ae <page_ref_dec>
c01054cf:	eb 19                	jmp    c01054ea <page_insert+0x88>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
c01054d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054d4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01054db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054df:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e2:	89 04 24             	mov    %eax,(%esp)
c01054e5:	e8 cd fe ff ff       	call   c01053b7 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01054ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ed:	89 04 24             	mov    %eax,(%esp)
c01054f0:	e8 71 f3 ff ff       	call   c0104866 <page2pa>
c01054f5:	0b 45 14             	or     0x14(%ebp),%eax
c01054f8:	83 c8 01             	or     $0x1,%eax
c01054fb:	89 c2                	mov    %eax,%edx
c01054fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105500:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105502:	8b 45 10             	mov    0x10(%ebp),%eax
c0105505:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105509:	8b 45 08             	mov    0x8(%ebp),%eax
c010550c:	89 04 24             	mov    %eax,(%esp)
c010550f:	e8 09 00 00 00       	call   c010551d <tlb_invalidate>
    return 0;
c0105514:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105519:	89 ec                	mov    %ebp,%esp
c010551b:	5d                   	pop    %ebp
c010551c:	c3                   	ret    

c010551d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
c010551d:	55                   	push   %ebp
c010551e:	89 e5                	mov    %esp,%ebp
c0105520:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
c0105523:	0f 20 d8             	mov    %cr3,%eax
c0105526:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
c0105529:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
c010552c:	8b 45 08             	mov    0x8(%ebp),%eax
c010552f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105532:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105539:	77 23                	ja     c010555e <tlb_invalidate+0x41>
c010553b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010553e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105542:	c7 44 24 08 08 7c 10 	movl   $0xc0107c08,0x8(%esp)
c0105549:	c0 
c010554a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0105551:	00 
c0105552:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105559:	e8 8c b7 ff ff       	call   c0100cea <__panic>
c010555e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105561:	05 00 00 00 40       	add    $0x40000000,%eax
c0105566:	39 d0                	cmp    %edx,%eax
c0105568:	75 0d                	jne    c0105577 <tlb_invalidate+0x5a>
    {
        invlpg((void *)la);
c010556a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010556d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
c0105570:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105573:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
c0105576:	90                   	nop
    }
}
c0105577:	90                   	nop
c0105578:	89 ec                	mov    %ebp,%esp
c010557a:	5d                   	pop    %ebp
c010557b:	c3                   	ret    

c010557c <check_alloc_page>:

static void
check_alloc_page(void)
{
c010557c:	55                   	push   %ebp
c010557d:	89 e5                	mov    %esp,%ebp
c010557f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105582:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0105587:	8b 40 18             	mov    0x18(%eax),%eax
c010558a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010558c:	c7 04 24 8c 7c 10 c0 	movl   $0xc0107c8c,(%esp)
c0105593:	e8 cd ad ff ff       	call   c0100365 <cprintf>
}
c0105598:	90                   	nop
c0105599:	89 ec                	mov    %ebp,%esp
c010559b:	5d                   	pop    %ebp
c010559c:	c3                   	ret    

c010559d <check_pgdir>:

static void
check_pgdir(void)
{
c010559d:	55                   	push   %ebp
c010559e:	89 e5                	mov    %esp,%ebp
c01055a0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01055a3:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01055a8:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01055ad:	76 24                	jbe    c01055d3 <check_pgdir+0x36>
c01055af:	c7 44 24 0c ab 7c 10 	movl   $0xc0107cab,0xc(%esp)
c01055b6:	c0 
c01055b7:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01055be:	c0 
c01055bf:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c01055c6:	00 
c01055c7:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01055ce:	e8 17 b7 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01055d3:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01055d8:	85 c0                	test   %eax,%eax
c01055da:	74 0e                	je     c01055ea <check_pgdir+0x4d>
c01055dc:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01055e1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01055e6:	85 c0                	test   %eax,%eax
c01055e8:	74 24                	je     c010560e <check_pgdir+0x71>
c01055ea:	c7 44 24 0c c8 7c 10 	movl   $0xc0107cc8,0xc(%esp)
c01055f1:	c0 
c01055f2:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01055f9:	c0 
c01055fa:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0105601:	00 
c0105602:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105609:	e8 dc b6 ff ff       	call   c0100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010560e:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105613:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010561a:	00 
c010561b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105622:	00 
c0105623:	89 04 24             	mov    %eax,(%esp)
c0105626:	e8 31 fd ff ff       	call   c010535c <get_page>
c010562b:	85 c0                	test   %eax,%eax
c010562d:	74 24                	je     c0105653 <check_pgdir+0xb6>
c010562f:	c7 44 24 0c 00 7d 10 	movl   $0xc0107d00,0xc(%esp)
c0105636:	c0 
c0105637:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c010563e:	c0 
c010563f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0105646:	00 
c0105647:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c010564e:	e8 97 b6 ff ff       	call   c0100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105653:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010565a:	e8 30 f5 ff ff       	call   c0104b8f <alloc_pages>
c010565f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105662:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105667:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010566e:	00 
c010566f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105676:	00 
c0105677:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010567a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010567e:	89 04 24             	mov    %eax,(%esp)
c0105681:	e8 dc fd ff ff       	call   c0105462 <page_insert>
c0105686:	85 c0                	test   %eax,%eax
c0105688:	74 24                	je     c01056ae <check_pgdir+0x111>
c010568a:	c7 44 24 0c 28 7d 10 	movl   $0xc0107d28,0xc(%esp)
c0105691:	c0 
c0105692:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105699:	c0 
c010569a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c01056a1:	00 
c01056a2:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01056a9:	e8 3c b6 ff ff       	call   c0100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01056ae:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01056b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056ba:	00 
c01056bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056c2:	00 
c01056c3:	89 04 24             	mov    %eax,(%esp)
c01056c6:	e8 56 fb ff ff       	call   c0105221 <get_pte>
c01056cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056d2:	75 24                	jne    c01056f8 <check_pgdir+0x15b>
c01056d4:	c7 44 24 0c 54 7d 10 	movl   $0xc0107d54,0xc(%esp)
c01056db:	c0 
c01056dc:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01056e3:	c0 
c01056e4:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c01056eb:	00 
c01056ec:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01056f3:	e8 f2 b5 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c01056f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056fb:	8b 00                	mov    (%eax),%eax
c01056fd:	89 04 24             	mov    %eax,(%esp)
c0105700:	e8 20 f2 ff ff       	call   c0104925 <pte2page>
c0105705:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105708:	74 24                	je     c010572e <check_pgdir+0x191>
c010570a:	c7 44 24 0c 81 7d 10 	movl   $0xc0107d81,0xc(%esp)
c0105711:	c0 
c0105712:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105719:	c0 
c010571a:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0105721:	00 
c0105722:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105729:	e8 bc b5 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 1);
c010572e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105731:	89 04 24             	mov    %eax,(%esp)
c0105734:	e8 46 f2 ff ff       	call   c010497f <page_ref>
c0105739:	83 f8 01             	cmp    $0x1,%eax
c010573c:	74 24                	je     c0105762 <check_pgdir+0x1c5>
c010573e:	c7 44 24 0c 97 7d 10 	movl   $0xc0107d97,0xc(%esp)
c0105745:	c0 
c0105746:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c010574d:	c0 
c010574e:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105755:	00 
c0105756:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c010575d:	e8 88 b5 ff ff       	call   c0100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105762:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105767:	8b 00                	mov    (%eax),%eax
c0105769:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010576e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105771:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105774:	c1 e8 0c             	shr    $0xc,%eax
c0105777:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010577a:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c010577f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105782:	72 23                	jb     c01057a7 <check_pgdir+0x20a>
c0105784:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105787:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010578b:	c7 44 24 08 64 7b 10 	movl   $0xc0107b64,0x8(%esp)
c0105792:	c0 
c0105793:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c010579a:	00 
c010579b:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01057a2:	e8 43 b5 ff ff       	call   c0100cea <__panic>
c01057a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057aa:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01057af:	83 c0 04             	add    $0x4,%eax
c01057b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01057b5:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01057ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01057c1:	00 
c01057c2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057c9:	00 
c01057ca:	89 04 24             	mov    %eax,(%esp)
c01057cd:	e8 4f fa ff ff       	call   c0105221 <get_pte>
c01057d2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01057d5:	74 24                	je     c01057fb <check_pgdir+0x25e>
c01057d7:	c7 44 24 0c ac 7d 10 	movl   $0xc0107dac,0xc(%esp)
c01057de:	c0 
c01057df:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01057e6:	c0 
c01057e7:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c01057ee:	00 
c01057ef:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01057f6:	e8 ef b4 ff ff       	call   c0100cea <__panic>

    p2 = alloc_page();
c01057fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105802:	e8 88 f3 ff ff       	call   c0104b8f <alloc_pages>
c0105807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010580a:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010580f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105816:	00 
c0105817:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010581e:	00 
c010581f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105822:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105826:	89 04 24             	mov    %eax,(%esp)
c0105829:	e8 34 fc ff ff       	call   c0105462 <page_insert>
c010582e:	85 c0                	test   %eax,%eax
c0105830:	74 24                	je     c0105856 <check_pgdir+0x2b9>
c0105832:	c7 44 24 0c d4 7d 10 	movl   $0xc0107dd4,0xc(%esp)
c0105839:	c0 
c010583a:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105841:	c0 
c0105842:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105849:	00 
c010584a:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105851:	e8 94 b4 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105856:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010585b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105862:	00 
c0105863:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010586a:	00 
c010586b:	89 04 24             	mov    %eax,(%esp)
c010586e:	e8 ae f9 ff ff       	call   c0105221 <get_pte>
c0105873:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010587a:	75 24                	jne    c01058a0 <check_pgdir+0x303>
c010587c:	c7 44 24 0c 0c 7e 10 	movl   $0xc0107e0c,0xc(%esp)
c0105883:	c0 
c0105884:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c010588b:	c0 
c010588c:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105893:	00 
c0105894:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c010589b:	e8 4a b4 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_U);
c01058a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a3:	8b 00                	mov    (%eax),%eax
c01058a5:	83 e0 04             	and    $0x4,%eax
c01058a8:	85 c0                	test   %eax,%eax
c01058aa:	75 24                	jne    c01058d0 <check_pgdir+0x333>
c01058ac:	c7 44 24 0c 3c 7e 10 	movl   $0xc0107e3c,0xc(%esp)
c01058b3:	c0 
c01058b4:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01058bb:	c0 
c01058bc:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c01058c3:	00 
c01058c4:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01058cb:	e8 1a b4 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_W);
c01058d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d3:	8b 00                	mov    (%eax),%eax
c01058d5:	83 e0 02             	and    $0x2,%eax
c01058d8:	85 c0                	test   %eax,%eax
c01058da:	75 24                	jne    c0105900 <check_pgdir+0x363>
c01058dc:	c7 44 24 0c 4a 7e 10 	movl   $0xc0107e4a,0xc(%esp)
c01058e3:	c0 
c01058e4:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01058eb:	c0 
c01058ec:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01058f3:	00 
c01058f4:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01058fb:	e8 ea b3 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105900:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105905:	8b 00                	mov    (%eax),%eax
c0105907:	83 e0 04             	and    $0x4,%eax
c010590a:	85 c0                	test   %eax,%eax
c010590c:	75 24                	jne    c0105932 <check_pgdir+0x395>
c010590e:	c7 44 24 0c 58 7e 10 	movl   $0xc0107e58,0xc(%esp)
c0105915:	c0 
c0105916:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c010591d:	c0 
c010591e:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0105925:	00 
c0105926:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c010592d:	e8 b8 b3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 1);
c0105932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105935:	89 04 24             	mov    %eax,(%esp)
c0105938:	e8 42 f0 ff ff       	call   c010497f <page_ref>
c010593d:	83 f8 01             	cmp    $0x1,%eax
c0105940:	74 24                	je     c0105966 <check_pgdir+0x3c9>
c0105942:	c7 44 24 0c 6e 7e 10 	movl   $0xc0107e6e,0xc(%esp)
c0105949:	c0 
c010594a:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105951:	c0 
c0105952:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105959:	00 
c010595a:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105961:	e8 84 b3 ff ff       	call   c0100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105966:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010596b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105972:	00 
c0105973:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010597a:	00 
c010597b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010597e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105982:	89 04 24             	mov    %eax,(%esp)
c0105985:	e8 d8 fa ff ff       	call   c0105462 <page_insert>
c010598a:	85 c0                	test   %eax,%eax
c010598c:	74 24                	je     c01059b2 <check_pgdir+0x415>
c010598e:	c7 44 24 0c 80 7e 10 	movl   $0xc0107e80,0xc(%esp)
c0105995:	c0 
c0105996:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c010599d:	c0 
c010599e:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01059a5:	00 
c01059a6:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01059ad:	e8 38 b3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 2);
c01059b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059b5:	89 04 24             	mov    %eax,(%esp)
c01059b8:	e8 c2 ef ff ff       	call   c010497f <page_ref>
c01059bd:	83 f8 02             	cmp    $0x2,%eax
c01059c0:	74 24                	je     c01059e6 <check_pgdir+0x449>
c01059c2:	c7 44 24 0c ac 7e 10 	movl   $0xc0107eac,0xc(%esp)
c01059c9:	c0 
c01059ca:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c01059d1:	c0 
c01059d2:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c01059d9:	00 
c01059da:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c01059e1:	e8 04 b3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c01059e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059e9:	89 04 24             	mov    %eax,(%esp)
c01059ec:	e8 8e ef ff ff       	call   c010497f <page_ref>
c01059f1:	85 c0                	test   %eax,%eax
c01059f3:	74 24                	je     c0105a19 <check_pgdir+0x47c>
c01059f5:	c7 44 24 0c be 7e 10 	movl   $0xc0107ebe,0xc(%esp)
c01059fc:	c0 
c01059fd:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105a04:	c0 
c0105a05:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105a0c:	00 
c0105a0d:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105a14:	e8 d1 b2 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105a19:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105a1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a25:	00 
c0105a26:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105a2d:	00 
c0105a2e:	89 04 24             	mov    %eax,(%esp)
c0105a31:	e8 eb f7 ff ff       	call   c0105221 <get_pte>
c0105a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a3d:	75 24                	jne    c0105a63 <check_pgdir+0x4c6>
c0105a3f:	c7 44 24 0c 0c 7e 10 	movl   $0xc0107e0c,0xc(%esp)
c0105a46:	c0 
c0105a47:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105a4e:	c0 
c0105a4f:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105a56:	00 
c0105a57:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105a5e:	e8 87 b2 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0105a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a66:	8b 00                	mov    (%eax),%eax
c0105a68:	89 04 24             	mov    %eax,(%esp)
c0105a6b:	e8 b5 ee ff ff       	call   c0104925 <pte2page>
c0105a70:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105a73:	74 24                	je     c0105a99 <check_pgdir+0x4fc>
c0105a75:	c7 44 24 0c 81 7d 10 	movl   $0xc0107d81,0xc(%esp)
c0105a7c:	c0 
c0105a7d:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105a84:	c0 
c0105a85:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105a8c:	00 
c0105a8d:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105a94:	e8 51 b2 ff ff       	call   c0100cea <__panic>
    assert((*ptep & PTE_U) == 0);
c0105a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a9c:	8b 00                	mov    (%eax),%eax
c0105a9e:	83 e0 04             	and    $0x4,%eax
c0105aa1:	85 c0                	test   %eax,%eax
c0105aa3:	74 24                	je     c0105ac9 <check_pgdir+0x52c>
c0105aa5:	c7 44 24 0c d0 7e 10 	movl   $0xc0107ed0,0xc(%esp)
c0105aac:	c0 
c0105aad:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105ab4:	c0 
c0105ab5:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105abc:	00 
c0105abd:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105ac4:	e8 21 b2 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, 0x0);
c0105ac9:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105ace:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105ad5:	00 
c0105ad6:	89 04 24             	mov    %eax,(%esp)
c0105ad9:	e8 3d f9 ff ff       	call   c010541b <page_remove>
    assert(page_ref(p1) == 1);
c0105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae1:	89 04 24             	mov    %eax,(%esp)
c0105ae4:	e8 96 ee ff ff       	call   c010497f <page_ref>
c0105ae9:	83 f8 01             	cmp    $0x1,%eax
c0105aec:	74 24                	je     c0105b12 <check_pgdir+0x575>
c0105aee:	c7 44 24 0c 97 7d 10 	movl   $0xc0107d97,0xc(%esp)
c0105af5:	c0 
c0105af6:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105afd:	c0 
c0105afe:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105b05:	00 
c0105b06:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105b0d:	e8 d8 b1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0105b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b15:	89 04 24             	mov    %eax,(%esp)
c0105b18:	e8 62 ee ff ff       	call   c010497f <page_ref>
c0105b1d:	85 c0                	test   %eax,%eax
c0105b1f:	74 24                	je     c0105b45 <check_pgdir+0x5a8>
c0105b21:	c7 44 24 0c be 7e 10 	movl   $0xc0107ebe,0xc(%esp)
c0105b28:	c0 
c0105b29:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105b30:	c0 
c0105b31:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105b38:	00 
c0105b39:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105b40:	e8 a5 b1 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105b45:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105b4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b51:	00 
c0105b52:	89 04 24             	mov    %eax,(%esp)
c0105b55:	e8 c1 f8 ff ff       	call   c010541b <page_remove>
    assert(page_ref(p1) == 0);
c0105b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b5d:	89 04 24             	mov    %eax,(%esp)
c0105b60:	e8 1a ee ff ff       	call   c010497f <page_ref>
c0105b65:	85 c0                	test   %eax,%eax
c0105b67:	74 24                	je     c0105b8d <check_pgdir+0x5f0>
c0105b69:	c7 44 24 0c e5 7e 10 	movl   $0xc0107ee5,0xc(%esp)
c0105b70:	c0 
c0105b71:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105b78:	c0 
c0105b79:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105b80:	00 
c0105b81:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105b88:	e8 5d b1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0105b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b90:	89 04 24             	mov    %eax,(%esp)
c0105b93:	e8 e7 ed ff ff       	call   c010497f <page_ref>
c0105b98:	85 c0                	test   %eax,%eax
c0105b9a:	74 24                	je     c0105bc0 <check_pgdir+0x623>
c0105b9c:	c7 44 24 0c be 7e 10 	movl   $0xc0107ebe,0xc(%esp)
c0105ba3:	c0 
c0105ba4:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105bab:	c0 
c0105bac:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105bb3:	00 
c0105bb4:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105bbb:	e8 2a b1 ff ff       	call   c0100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105bc0:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105bc5:	8b 00                	mov    (%eax),%eax
c0105bc7:	89 04 24             	mov    %eax,(%esp)
c0105bca:	e8 96 ed ff ff       	call   c0104965 <pde2page>
c0105bcf:	89 04 24             	mov    %eax,(%esp)
c0105bd2:	e8 a8 ed ff ff       	call   c010497f <page_ref>
c0105bd7:	83 f8 01             	cmp    $0x1,%eax
c0105bda:	74 24                	je     c0105c00 <check_pgdir+0x663>
c0105bdc:	c7 44 24 0c f8 7e 10 	movl   $0xc0107ef8,0xc(%esp)
c0105be3:	c0 
c0105be4:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105beb:	c0 
c0105bec:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105bf3:	00 
c0105bf4:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105bfb:	e8 ea b0 ff ff       	call   c0100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105c00:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c05:	8b 00                	mov    (%eax),%eax
c0105c07:	89 04 24             	mov    %eax,(%esp)
c0105c0a:	e8 56 ed ff ff       	call   c0104965 <pde2page>
c0105c0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c16:	00 
c0105c17:	89 04 24             	mov    %eax,(%esp)
c0105c1a:	e8 aa ef ff ff       	call   c0104bc9 <free_pages>
    boot_pgdir[0] = 0;
c0105c1f:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105c2a:	c7 04 24 1f 7f 10 c0 	movl   $0xc0107f1f,(%esp)
c0105c31:	e8 2f a7 ff ff       	call   c0100365 <cprintf>
}
c0105c36:	90                   	nop
c0105c37:	89 ec                	mov    %ebp,%esp
c0105c39:	5d                   	pop    %ebp
c0105c3a:	c3                   	ret    

c0105c3b <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
c0105c3b:	55                   	push   %ebp
c0105c3c:	89 e5                	mov    %esp,%ebp
c0105c3e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
c0105c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105c48:	e9 ca 00 00 00       	jmp    c0105d17 <check_boot_pgdir+0xdc>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c56:	c1 e8 0c             	shr    $0xc,%eax
c0105c59:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c5c:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105c61:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105c64:	72 23                	jb     c0105c89 <check_boot_pgdir+0x4e>
c0105c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c69:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c6d:	c7 44 24 08 64 7b 10 	movl   $0xc0107b64,0x8(%esp)
c0105c74:	c0 
c0105c75:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105c7c:	00 
c0105c7d:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105c84:	e8 61 b0 ff ff       	call   c0100cea <__panic>
c0105c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c8c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105c91:	89 c2                	mov    %eax,%edx
c0105c93:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c98:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c9f:	00 
c0105ca0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ca4:	89 04 24             	mov    %eax,(%esp)
c0105ca7:	e8 75 f5 ff ff       	call   c0105221 <get_pte>
c0105cac:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105caf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105cb3:	75 24                	jne    c0105cd9 <check_boot_pgdir+0x9e>
c0105cb5:	c7 44 24 0c 3c 7f 10 	movl   $0xc0107f3c,0xc(%esp)
c0105cbc:	c0 
c0105cbd:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105cc4:	c0 
c0105cc5:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105ccc:	00 
c0105ccd:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105cd4:	e8 11 b0 ff ff       	call   c0100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cdc:	8b 00                	mov    (%eax),%eax
c0105cde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ce3:	89 c2                	mov    %eax,%edx
c0105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce8:	39 c2                	cmp    %eax,%edx
c0105cea:	74 24                	je     c0105d10 <check_boot_pgdir+0xd5>
c0105cec:	c7 44 24 0c 79 7f 10 	movl   $0xc0107f79,0xc(%esp)
c0105cf3:	c0 
c0105cf4:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105cfb:	c0 
c0105cfc:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0105d03:	00 
c0105d04:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105d0b:	e8 da af ff ff       	call   c0100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE)
c0105d10:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d1a:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105d1f:	39 c2                	cmp    %eax,%edx
c0105d21:	0f 82 26 ff ff ff    	jb     c0105c4d <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105d27:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d2c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105d31:	8b 00                	mov    (%eax),%eax
c0105d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105d38:	89 c2                	mov    %eax,%edx
c0105d3a:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d42:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105d49:	77 23                	ja     c0105d6e <check_boot_pgdir+0x133>
c0105d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d52:	c7 44 24 08 08 7c 10 	movl   $0xc0107c08,0x8(%esp)
c0105d59:	c0 
c0105d5a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105d61:	00 
c0105d62:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105d69:	e8 7c af ff ff       	call   c0100cea <__panic>
c0105d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d71:	05 00 00 00 40       	add    $0x40000000,%eax
c0105d76:	39 d0                	cmp    %edx,%eax
c0105d78:	74 24                	je     c0105d9e <check_boot_pgdir+0x163>
c0105d7a:	c7 44 24 0c 90 7f 10 	movl   $0xc0107f90,0xc(%esp)
c0105d81:	c0 
c0105d82:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105d89:	c0 
c0105d8a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105d91:	00 
c0105d92:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105d99:	e8 4c af ff ff       	call   c0100cea <__panic>

    assert(boot_pgdir[0] == 0);
c0105d9e:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105da3:	8b 00                	mov    (%eax),%eax
c0105da5:	85 c0                	test   %eax,%eax
c0105da7:	74 24                	je     c0105dcd <check_boot_pgdir+0x192>
c0105da9:	c7 44 24 0c c4 7f 10 	movl   $0xc0107fc4,0xc(%esp)
c0105db0:	c0 
c0105db1:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105db8:	c0 
c0105db9:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c0105dc0:	00 
c0105dc1:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105dc8:	e8 1d af ff ff       	call   c0100cea <__panic>

    struct Page *p;
    p = alloc_page();
c0105dcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105dd4:	e8 b6 ed ff ff       	call   c0104b8f <alloc_pages>
c0105dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105ddc:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105de1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105de8:	00 
c0105de9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105df0:	00 
c0105df1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105df4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105df8:	89 04 24             	mov    %eax,(%esp)
c0105dfb:	e8 62 f6 ff ff       	call   c0105462 <page_insert>
c0105e00:	85 c0                	test   %eax,%eax
c0105e02:	74 24                	je     c0105e28 <check_boot_pgdir+0x1ed>
c0105e04:	c7 44 24 0c d8 7f 10 	movl   $0xc0107fd8,0xc(%esp)
c0105e0b:	c0 
c0105e0c:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105e13:	c0 
c0105e14:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105e1b:	00 
c0105e1c:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105e23:	e8 c2 ae ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 1);
c0105e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e2b:	89 04 24             	mov    %eax,(%esp)
c0105e2e:	e8 4c eb ff ff       	call   c010497f <page_ref>
c0105e33:	83 f8 01             	cmp    $0x1,%eax
c0105e36:	74 24                	je     c0105e5c <check_boot_pgdir+0x221>
c0105e38:	c7 44 24 0c 06 80 10 	movl   $0xc0108006,0xc(%esp)
c0105e3f:	c0 
c0105e40:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105e47:	c0 
c0105e48:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105e4f:	00 
c0105e50:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105e57:	e8 8e ae ff ff       	call   c0100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105e5c:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105e61:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105e68:	00 
c0105e69:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105e70:	00 
c0105e71:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e74:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e78:	89 04 24             	mov    %eax,(%esp)
c0105e7b:	e8 e2 f5 ff ff       	call   c0105462 <page_insert>
c0105e80:	85 c0                	test   %eax,%eax
c0105e82:	74 24                	je     c0105ea8 <check_boot_pgdir+0x26d>
c0105e84:	c7 44 24 0c 18 80 10 	movl   $0xc0108018,0xc(%esp)
c0105e8b:	c0 
c0105e8c:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105e93:	c0 
c0105e94:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105e9b:	00 
c0105e9c:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105ea3:	e8 42 ae ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 2);
c0105ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eab:	89 04 24             	mov    %eax,(%esp)
c0105eae:	e8 cc ea ff ff       	call   c010497f <page_ref>
c0105eb3:	83 f8 02             	cmp    $0x2,%eax
c0105eb6:	74 24                	je     c0105edc <check_boot_pgdir+0x2a1>
c0105eb8:	c7 44 24 0c 4f 80 10 	movl   $0xc010804f,0xc(%esp)
c0105ebf:	c0 
c0105ec0:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105ec7:	c0 
c0105ec8:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0105ecf:	00 
c0105ed0:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105ed7:	e8 0e ae ff ff       	call   c0100cea <__panic>

    const char *str = "ucore: Hello world!!";
c0105edc:	c7 45 e8 60 80 10 c0 	movl   $0xc0108060,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105ef1:	e8 fc 09 00 00       	call   c01068f2 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105ef6:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105efd:	00 
c0105efe:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105f05:	e8 60 0a 00 00       	call   c010696a <strcmp>
c0105f0a:	85 c0                	test   %eax,%eax
c0105f0c:	74 24                	je     c0105f32 <check_boot_pgdir+0x2f7>
c0105f0e:	c7 44 24 0c 78 80 10 	movl   $0xc0108078,0xc(%esp)
c0105f15:	c0 
c0105f16:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105f1d:	c0 
c0105f1e:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0105f25:	00 
c0105f26:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105f2d:	e8 b8 ad ff ff       	call   c0100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f35:	89 04 24             	mov    %eax,(%esp)
c0105f38:	e8 92 e9 ff ff       	call   c01048cf <page2kva>
c0105f3d:	05 00 01 00 00       	add    $0x100,%eax
c0105f42:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105f45:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105f4c:	e8 47 09 00 00       	call   c0106898 <strlen>
c0105f51:	85 c0                	test   %eax,%eax
c0105f53:	74 24                	je     c0105f79 <check_boot_pgdir+0x33e>
c0105f55:	c7 44 24 0c b0 80 10 	movl   $0xc01080b0,0xc(%esp)
c0105f5c:	c0 
c0105f5d:	c7 44 24 08 51 7c 10 	movl   $0xc0107c51,0x8(%esp)
c0105f64:	c0 
c0105f65:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0105f6c:	00 
c0105f6d:	c7 04 24 2c 7c 10 c0 	movl   $0xc0107c2c,(%esp)
c0105f74:	e8 71 ad ff ff       	call   c0100cea <__panic>

    free_page(p);
c0105f79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f80:	00 
c0105f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f84:	89 04 24             	mov    %eax,(%esp)
c0105f87:	e8 3d ec ff ff       	call   c0104bc9 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105f8c:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105f91:	8b 00                	mov    (%eax),%eax
c0105f93:	89 04 24             	mov    %eax,(%esp)
c0105f96:	e8 ca e9 ff ff       	call   c0104965 <pde2page>
c0105f9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105fa2:	00 
c0105fa3:	89 04 24             	mov    %eax,(%esp)
c0105fa6:	e8 1e ec ff ff       	call   c0104bc9 <free_pages>
    boot_pgdir[0] = 0;
c0105fab:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105fb6:	c7 04 24 d4 80 10 c0 	movl   $0xc01080d4,(%esp)
c0105fbd:	e8 a3 a3 ff ff       	call   c0100365 <cprintf>
}
c0105fc2:	90                   	nop
c0105fc3:	89 ec                	mov    %ebp,%esp
c0105fc5:	5d                   	pop    %ebp
c0105fc6:	c3                   	ret    

c0105fc7 <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
c0105fc7:	55                   	push   %ebp
c0105fc8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fcd:	83 e0 04             	and    $0x4,%eax
c0105fd0:	85 c0                	test   %eax,%eax
c0105fd2:	74 04                	je     c0105fd8 <perm2str+0x11>
c0105fd4:	b0 75                	mov    $0x75,%al
c0105fd6:	eb 02                	jmp    c0105fda <perm2str+0x13>
c0105fd8:	b0 2d                	mov    $0x2d,%al
c0105fda:	a2 28 ef 11 c0       	mov    %al,0xc011ef28
    str[1] = 'r';
c0105fdf:	c6 05 29 ef 11 c0 72 	movb   $0x72,0xc011ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe9:	83 e0 02             	and    $0x2,%eax
c0105fec:	85 c0                	test   %eax,%eax
c0105fee:	74 04                	je     c0105ff4 <perm2str+0x2d>
c0105ff0:	b0 77                	mov    $0x77,%al
c0105ff2:	eb 02                	jmp    c0105ff6 <perm2str+0x2f>
c0105ff4:	b0 2d                	mov    $0x2d,%al
c0105ff6:	a2 2a ef 11 c0       	mov    %al,0xc011ef2a
    str[3] = '\0';
c0105ffb:	c6 05 2b ef 11 c0 00 	movb   $0x0,0xc011ef2b
    return str;
c0106002:	b8 28 ef 11 c0       	mov    $0xc011ef28,%eax
}
c0106007:	5d                   	pop    %ebp
c0106008:	c3                   	ret    

c0106009 <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
c0106009:	55                   	push   %ebp
c010600a:	89 e5                	mov    %esp,%ebp
c010600c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
c010600f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106012:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106015:	72 0d                	jb     c0106024 <get_pgtable_items+0x1b>
    {
        return 0;
c0106017:	b8 00 00 00 00       	mov    $0x0,%eax
c010601c:	e9 98 00 00 00       	jmp    c01060b9 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
c0106021:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
c0106024:	8b 45 10             	mov    0x10(%ebp),%eax
c0106027:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010602a:	73 18                	jae    c0106044 <get_pgtable_items+0x3b>
c010602c:	8b 45 10             	mov    0x10(%ebp),%eax
c010602f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106036:	8b 45 14             	mov    0x14(%ebp),%eax
c0106039:	01 d0                	add    %edx,%eax
c010603b:	8b 00                	mov    (%eax),%eax
c010603d:	83 e0 01             	and    $0x1,%eax
c0106040:	85 c0                	test   %eax,%eax
c0106042:	74 dd                	je     c0106021 <get_pgtable_items+0x18>
    }
    if (start < right)
c0106044:	8b 45 10             	mov    0x10(%ebp),%eax
c0106047:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010604a:	73 68                	jae    c01060b4 <get_pgtable_items+0xab>
    {
        if (left_store != NULL)
c010604c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106050:	74 08                	je     c010605a <get_pgtable_items+0x51>
        {
            *left_store = start;
c0106052:	8b 45 18             	mov    0x18(%ebp),%eax
c0106055:	8b 55 10             	mov    0x10(%ebp),%edx
c0106058:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c010605a:	8b 45 10             	mov    0x10(%ebp),%eax
c010605d:	8d 50 01             	lea    0x1(%eax),%edx
c0106060:	89 55 10             	mov    %edx,0x10(%ebp)
c0106063:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010606a:	8b 45 14             	mov    0x14(%ebp),%eax
c010606d:	01 d0                	add    %edx,%eax
c010606f:	8b 00                	mov    (%eax),%eax
c0106071:	83 e0 07             	and    $0x7,%eax
c0106074:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c0106077:	eb 03                	jmp    c010607c <get_pgtable_items+0x73>
        {
            start++;
c0106079:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c010607c:	8b 45 10             	mov    0x10(%ebp),%eax
c010607f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106082:	73 1d                	jae    c01060a1 <get_pgtable_items+0x98>
c0106084:	8b 45 10             	mov    0x10(%ebp),%eax
c0106087:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010608e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106091:	01 d0                	add    %edx,%eax
c0106093:	8b 00                	mov    (%eax),%eax
c0106095:	83 e0 07             	and    $0x7,%eax
c0106098:	89 c2                	mov    %eax,%edx
c010609a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010609d:	39 c2                	cmp    %eax,%edx
c010609f:	74 d8                	je     c0106079 <get_pgtable_items+0x70>
        }
        if (right_store != NULL)
c01060a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01060a5:	74 08                	je     c01060af <get_pgtable_items+0xa6>
        {
            *right_store = start;
c01060a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01060aa:	8b 55 10             	mov    0x10(%ebp),%edx
c01060ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01060af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060b2:	eb 05                	jmp    c01060b9 <get_pgtable_items+0xb0>
    }
    return 0;
c01060b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060b9:	89 ec                	mov    %ebp,%esp
c01060bb:	5d                   	pop    %ebp
c01060bc:	c3                   	ret    

c01060bd <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
c01060bd:	55                   	push   %ebp
c01060be:	89 e5                	mov    %esp,%ebp
c01060c0:	57                   	push   %edi
c01060c1:	56                   	push   %esi
c01060c2:	53                   	push   %ebx
c01060c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01060c6:	c7 04 24 f4 80 10 c0 	movl   $0xc01080f4,(%esp)
c01060cd:	e8 93 a2 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c01060d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c01060d9:	e9 f2 00 00 00       	jmp    c01061d0 <print_pgdir+0x113>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01060de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060e1:	89 04 24             	mov    %eax,(%esp)
c01060e4:	e8 de fe ff ff       	call   c0105fc7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01060e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01060ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01060ef:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01060f1:	89 d6                	mov    %edx,%esi
c01060f3:	c1 e6 16             	shl    $0x16,%esi
c01060f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01060f9:	89 d3                	mov    %edx,%ebx
c01060fb:	c1 e3 16             	shl    $0x16,%ebx
c01060fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106101:	89 d1                	mov    %edx,%ecx
c0106103:	c1 e1 16             	shl    $0x16,%ecx
c0106106:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106109:	8b 7d e0             	mov    -0x20(%ebp),%edi
c010610c:	29 fa                	sub    %edi,%edx
c010610e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106112:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106116:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010611a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010611e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106122:	c7 04 24 25 81 10 c0 	movl   $0xc0108125,(%esp)
c0106129:	e8 37 a2 ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010612e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106131:	c1 e0 0a             	shl    $0xa,%eax
c0106134:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0106137:	eb 50                	jmp    c0106189 <print_pgdir+0xcc>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010613c:	89 04 24             	mov    %eax,(%esp)
c010613f:	e8 83 fe ff ff       	call   c0105fc7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106147:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010614a:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010614c:	89 d6                	mov    %edx,%esi
c010614e:	c1 e6 0c             	shl    $0xc,%esi
c0106151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106154:	89 d3                	mov    %edx,%ebx
c0106156:	c1 e3 0c             	shl    $0xc,%ebx
c0106159:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010615c:	89 d1                	mov    %edx,%ecx
c010615e:	c1 e1 0c             	shl    $0xc,%ecx
c0106161:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106164:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0106167:	29 fa                	sub    %edi,%edx
c0106169:	89 44 24 14          	mov    %eax,0x14(%esp)
c010616d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106171:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106175:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106179:	89 54 24 04          	mov    %edx,0x4(%esp)
c010617d:	c7 04 24 44 81 10 c0 	movl   $0xc0108144,(%esp)
c0106184:	e8 dc a1 ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0106189:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010618e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106191:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106194:	89 d3                	mov    %edx,%ebx
c0106196:	c1 e3 0a             	shl    $0xa,%ebx
c0106199:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010619c:	89 d1                	mov    %edx,%ecx
c010619e:	c1 e1 0a             	shl    $0xa,%ecx
c01061a1:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01061a4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01061a8:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01061ab:	89 54 24 10          	mov    %edx,0x10(%esp)
c01061af:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01061b3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01061bb:	89 0c 24             	mov    %ecx,(%esp)
c01061be:	e8 46 fe ff ff       	call   c0106009 <get_pgtable_items>
c01061c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01061ca:	0f 85 69 ff ff ff    	jne    c0106139 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c01061d0:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01061d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01061db:	89 54 24 14          	mov    %edx,0x14(%esp)
c01061df:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01061e2:	89 54 24 10          	mov    %edx,0x10(%esp)
c01061e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01061ea:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061ee:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01061f5:	00 
c01061f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01061fd:	e8 07 fe ff ff       	call   c0106009 <get_pgtable_items>
c0106202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106205:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106209:	0f 85 cf fe ff ff    	jne    c01060de <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010620f:	c7 04 24 68 81 10 c0 	movl   $0xc0108168,(%esp)
c0106216:	e8 4a a1 ff ff       	call   c0100365 <cprintf>
}
c010621b:	90                   	nop
c010621c:	83 c4 4c             	add    $0x4c,%esp
c010621f:	5b                   	pop    %ebx
c0106220:	5e                   	pop    %esi
c0106221:	5f                   	pop    %edi
c0106222:	5d                   	pop    %ebp
c0106223:	c3                   	ret    

c0106224 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
c0106224:	55                   	push   %ebp
c0106225:	89 e5                	mov    %esp,%ebp
c0106227:	83 ec 58             	sub    $0x58,%esp
c010622a:	8b 45 10             	mov    0x10(%ebp),%eax
c010622d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106230:	8b 45 14             	mov    0x14(%ebp),%eax
c0106233:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106236:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106239:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010623c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010623f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0106242:	8b 45 18             	mov    0x18(%ebp),%eax
c0106245:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106248:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010624b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010624e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106251:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0106254:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106257:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010625a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010625e:	74 1c                	je     c010627c <printnum+0x58>
c0106260:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106263:	ba 00 00 00 00       	mov    $0x0,%edx
c0106268:	f7 75 e4             	divl   -0x1c(%ebp)
c010626b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010626e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106271:	ba 00 00 00 00       	mov    $0x0,%edx
c0106276:	f7 75 e4             	divl   -0x1c(%ebp)
c0106279:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010627c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010627f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106282:	f7 75 e4             	divl   -0x1c(%ebp)
c0106285:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106288:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010628b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010628e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106291:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106294:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0106297:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010629a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
c010629d:	8b 45 18             	mov    0x18(%ebp),%eax
c01062a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01062a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01062a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01062ab:	19 d1                	sbb    %edx,%ecx
c01062ad:	72 4c                	jb     c01062fb <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
c01062af:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01062b2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01062b5:	8b 45 20             	mov    0x20(%ebp),%eax
c01062b8:	89 44 24 18          	mov    %eax,0x18(%esp)
c01062bc:	89 54 24 14          	mov    %edx,0x14(%esp)
c01062c0:	8b 45 18             	mov    0x18(%ebp),%eax
c01062c3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01062c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062cd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01062d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01062df:	89 04 24             	mov    %eax,(%esp)
c01062e2:	e8 3d ff ff ff       	call   c0106224 <printnum>
c01062e7:	eb 1b                	jmp    c0106304 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
c01062e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062f0:	8b 45 20             	mov    0x20(%ebp),%eax
c01062f3:	89 04 24             	mov    %eax,(%esp)
c01062f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01062f9:	ff d0                	call   *%eax
        while (--width > 0)
c01062fb:	ff 4d 1c             	decl   0x1c(%ebp)
c01062fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106302:	7f e5                	jg     c01062e9 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106304:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106307:	05 1c 82 10 c0       	add    $0xc010821c,%eax
c010630c:	0f b6 00             	movzbl (%eax),%eax
c010630f:	0f be c0             	movsbl %al,%eax
c0106312:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106315:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106319:	89 04 24             	mov    %eax,(%esp)
c010631c:	8b 45 08             	mov    0x8(%ebp),%eax
c010631f:	ff d0                	call   *%eax
}
c0106321:	90                   	nop
c0106322:	89 ec                	mov    %ebp,%esp
c0106324:	5d                   	pop    %ebp
c0106325:	c3                   	ret    

c0106326 <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
c0106326:	55                   	push   %ebp
c0106327:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c0106329:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010632d:	7e 14                	jle    c0106343 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
c010632f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106332:	8b 00                	mov    (%eax),%eax
c0106334:	8d 48 08             	lea    0x8(%eax),%ecx
c0106337:	8b 55 08             	mov    0x8(%ebp),%edx
c010633a:	89 0a                	mov    %ecx,(%edx)
c010633c:	8b 50 04             	mov    0x4(%eax),%edx
c010633f:	8b 00                	mov    (%eax),%eax
c0106341:	eb 30                	jmp    c0106373 <getuint+0x4d>
    }
    else if (lflag)
c0106343:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106347:	74 16                	je     c010635f <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
c0106349:	8b 45 08             	mov    0x8(%ebp),%eax
c010634c:	8b 00                	mov    (%eax),%eax
c010634e:	8d 48 04             	lea    0x4(%eax),%ecx
c0106351:	8b 55 08             	mov    0x8(%ebp),%edx
c0106354:	89 0a                	mov    %ecx,(%edx)
c0106356:	8b 00                	mov    (%eax),%eax
c0106358:	ba 00 00 00 00       	mov    $0x0,%edx
c010635d:	eb 14                	jmp    c0106373 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
c010635f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106362:	8b 00                	mov    (%eax),%eax
c0106364:	8d 48 04             	lea    0x4(%eax),%ecx
c0106367:	8b 55 08             	mov    0x8(%ebp),%edx
c010636a:	89 0a                	mov    %ecx,(%edx)
c010636c:	8b 00                	mov    (%eax),%eax
c010636e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0106373:	5d                   	pop    %ebp
c0106374:	c3                   	ret    

c0106375 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
c0106375:	55                   	push   %ebp
c0106376:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c0106378:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010637c:	7e 14                	jle    c0106392 <getint+0x1d>
    {
        return va_arg(*ap, long long);
c010637e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106381:	8b 00                	mov    (%eax),%eax
c0106383:	8d 48 08             	lea    0x8(%eax),%ecx
c0106386:	8b 55 08             	mov    0x8(%ebp),%edx
c0106389:	89 0a                	mov    %ecx,(%edx)
c010638b:	8b 50 04             	mov    0x4(%eax),%edx
c010638e:	8b 00                	mov    (%eax),%eax
c0106390:	eb 28                	jmp    c01063ba <getint+0x45>
    }
    else if (lflag)
c0106392:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106396:	74 12                	je     c01063aa <getint+0x35>
    {
        return va_arg(*ap, long);
c0106398:	8b 45 08             	mov    0x8(%ebp),%eax
c010639b:	8b 00                	mov    (%eax),%eax
c010639d:	8d 48 04             	lea    0x4(%eax),%ecx
c01063a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01063a3:	89 0a                	mov    %ecx,(%edx)
c01063a5:	8b 00                	mov    (%eax),%eax
c01063a7:	99                   	cltd   
c01063a8:	eb 10                	jmp    c01063ba <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
c01063aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ad:	8b 00                	mov    (%eax),%eax
c01063af:	8d 48 04             	lea    0x4(%eax),%ecx
c01063b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01063b5:	89 0a                	mov    %ecx,(%edx)
c01063b7:	8b 00                	mov    (%eax),%eax
c01063b9:	99                   	cltd   
    }
}
c01063ba:	5d                   	pop    %ebp
c01063bb:	c3                   	ret    

c01063bc <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
c01063bc:	55                   	push   %ebp
c01063bd:	89 e5                	mov    %esp,%ebp
c01063bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01063c2:	8d 45 14             	lea    0x14(%ebp),%eax
c01063c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01063c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01063cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01063d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01063e0:	89 04 24             	mov    %eax,(%esp)
c01063e3:	e8 05 00 00 00       	call   c01063ed <vprintfmt>
    va_end(ap);
}
c01063e8:	90                   	nop
c01063e9:	89 ec                	mov    %ebp,%esp
c01063eb:	5d                   	pop    %ebp
c01063ec:	c3                   	ret    

c01063ed <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
c01063ed:	55                   	push   %ebp
c01063ee:	89 e5                	mov    %esp,%ebp
c01063f0:	56                   	push   %esi
c01063f1:	53                   	push   %ebx
c01063f2:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
c01063f5:	eb 17                	jmp    c010640e <vprintfmt+0x21>
        {
            if (ch == '\0')
c01063f7:	85 db                	test   %ebx,%ebx
c01063f9:	0f 84 bf 03 00 00    	je     c01067be <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
c01063ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106402:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106406:	89 1c 24             	mov    %ebx,(%esp)
c0106409:	8b 45 08             	mov    0x8(%ebp),%eax
c010640c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
c010640e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106411:	8d 50 01             	lea    0x1(%eax),%edx
c0106414:	89 55 10             	mov    %edx,0x10(%ebp)
c0106417:	0f b6 00             	movzbl (%eax),%eax
c010641a:	0f b6 d8             	movzbl %al,%ebx
c010641d:	83 fb 25             	cmp    $0x25,%ebx
c0106420:	75 d5                	jne    c01063f7 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106422:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106426:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010642d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106430:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106433:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010643a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010643d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
c0106440:	8b 45 10             	mov    0x10(%ebp),%eax
c0106443:	8d 50 01             	lea    0x1(%eax),%edx
c0106446:	89 55 10             	mov    %edx,0x10(%ebp)
c0106449:	0f b6 00             	movzbl (%eax),%eax
c010644c:	0f b6 d8             	movzbl %al,%ebx
c010644f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106452:	83 f8 55             	cmp    $0x55,%eax
c0106455:	0f 87 37 03 00 00    	ja     c0106792 <vprintfmt+0x3a5>
c010645b:	8b 04 85 40 82 10 c0 	mov    -0x3fef7dc0(,%eax,4),%eax
c0106462:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
c0106464:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106468:	eb d6                	jmp    c0106440 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010646a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010646e:	eb d0                	jmp    c0106440 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
c0106470:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
c0106477:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010647a:	89 d0                	mov    %edx,%eax
c010647c:	c1 e0 02             	shl    $0x2,%eax
c010647f:	01 d0                	add    %edx,%eax
c0106481:	01 c0                	add    %eax,%eax
c0106483:	01 d8                	add    %ebx,%eax
c0106485:	83 e8 30             	sub    $0x30,%eax
c0106488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010648b:	8b 45 10             	mov    0x10(%ebp),%eax
c010648e:	0f b6 00             	movzbl (%eax),%eax
c0106491:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
c0106494:	83 fb 2f             	cmp    $0x2f,%ebx
c0106497:	7e 38                	jle    c01064d1 <vprintfmt+0xe4>
c0106499:	83 fb 39             	cmp    $0x39,%ebx
c010649c:	7f 33                	jg     c01064d1 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
c010649e:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01064a1:	eb d4                	jmp    c0106477 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01064a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01064a6:	8d 50 04             	lea    0x4(%eax),%edx
c01064a9:	89 55 14             	mov    %edx,0x14(%ebp)
c01064ac:	8b 00                	mov    (%eax),%eax
c01064ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01064b1:	eb 1f                	jmp    c01064d2 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01064b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01064b7:	79 87                	jns    c0106440 <vprintfmt+0x53>
                width = 0;
c01064b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01064c0:	e9 7b ff ff ff       	jmp    c0106440 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01064c5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01064cc:	e9 6f ff ff ff       	jmp    c0106440 <vprintfmt+0x53>
            goto process_precision;
c01064d1:	90                   	nop

        process_precision:
            if (width < 0)
c01064d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01064d6:	0f 89 64 ff ff ff    	jns    c0106440 <vprintfmt+0x53>
                width = precision, precision = -1;
c01064dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01064e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01064e9:	e9 52 ff ff ff       	jmp    c0106440 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
c01064ee:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01064f1:	e9 4a ff ff ff       	jmp    c0106440 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01064f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01064f9:	8d 50 04             	lea    0x4(%eax),%edx
c01064fc:	89 55 14             	mov    %edx,0x14(%ebp)
c01064ff:	8b 00                	mov    (%eax),%eax
c0106501:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106504:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106508:	89 04 24             	mov    %eax,(%esp)
c010650b:	8b 45 08             	mov    0x8(%ebp),%eax
c010650e:	ff d0                	call   *%eax
            break;
c0106510:	e9 a4 02 00 00       	jmp    c01067b9 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106515:	8b 45 14             	mov    0x14(%ebp),%eax
c0106518:	8d 50 04             	lea    0x4(%eax),%edx
c010651b:	89 55 14             	mov    %edx,0x14(%ebp)
c010651e:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
c0106520:	85 db                	test   %ebx,%ebx
c0106522:	79 02                	jns    c0106526 <vprintfmt+0x139>
            {
                err = -err;
c0106524:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
c0106526:	83 fb 06             	cmp    $0x6,%ebx
c0106529:	7f 0b                	jg     c0106536 <vprintfmt+0x149>
c010652b:	8b 34 9d 00 82 10 c0 	mov    -0x3fef7e00(,%ebx,4),%esi
c0106532:	85 f6                	test   %esi,%esi
c0106534:	75 23                	jne    c0106559 <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
c0106536:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010653a:	c7 44 24 08 2d 82 10 	movl   $0xc010822d,0x8(%esp)
c0106541:	c0 
c0106542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106545:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106549:	8b 45 08             	mov    0x8(%ebp),%eax
c010654c:	89 04 24             	mov    %eax,(%esp)
c010654f:	e8 68 fe ff ff       	call   c01063bc <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106554:	e9 60 02 00 00       	jmp    c01067b9 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0106559:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010655d:	c7 44 24 08 36 82 10 	movl   $0xc0108236,0x8(%esp)
c0106564:	c0 
c0106565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010656c:	8b 45 08             	mov    0x8(%ebp),%eax
c010656f:	89 04 24             	mov    %eax,(%esp)
c0106572:	e8 45 fe ff ff       	call   c01063bc <printfmt>
            break;
c0106577:	e9 3d 02 00 00       	jmp    c01067b9 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
c010657c:	8b 45 14             	mov    0x14(%ebp),%eax
c010657f:	8d 50 04             	lea    0x4(%eax),%edx
c0106582:	89 55 14             	mov    %edx,0x14(%ebp)
c0106585:	8b 30                	mov    (%eax),%esi
c0106587:	85 f6                	test   %esi,%esi
c0106589:	75 05                	jne    c0106590 <vprintfmt+0x1a3>
            {
                p = "(null)";
c010658b:	be 39 82 10 c0       	mov    $0xc0108239,%esi
            }
            if (width > 0 && padc != '-')
c0106590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106594:	7e 76                	jle    c010660c <vprintfmt+0x21f>
c0106596:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010659a:	74 70                	je     c010660c <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
c010659c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010659f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065a3:	89 34 24             	mov    %esi,(%esp)
c01065a6:	e8 16 03 00 00       	call   c01068c1 <strnlen>
c01065ab:	89 c2                	mov    %eax,%edx
c01065ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065b0:	29 d0                	sub    %edx,%eax
c01065b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01065b5:	eb 16                	jmp    c01065cd <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
c01065b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01065bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065be:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065c2:	89 04 24             	mov    %eax,(%esp)
c01065c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01065c8:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
c01065ca:	ff 4d e8             	decl   -0x18(%ebp)
c01065cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01065d1:	7f e4                	jg     c01065b7 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c01065d3:	eb 37                	jmp    c010660c <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
c01065d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01065d9:	74 1f                	je     c01065fa <vprintfmt+0x20d>
c01065db:	83 fb 1f             	cmp    $0x1f,%ebx
c01065de:	7e 05                	jle    c01065e5 <vprintfmt+0x1f8>
c01065e0:	83 fb 7e             	cmp    $0x7e,%ebx
c01065e3:	7e 15                	jle    c01065fa <vprintfmt+0x20d>
                {
                    putch('?', putdat);
c01065e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01065f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01065f6:	ff d0                	call   *%eax
c01065f8:	eb 0f                	jmp    c0106609 <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
c01065fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106601:	89 1c 24             	mov    %ebx,(%esp)
c0106604:	8b 45 08             	mov    0x8(%ebp),%eax
c0106607:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0106609:	ff 4d e8             	decl   -0x18(%ebp)
c010660c:	89 f0                	mov    %esi,%eax
c010660e:	8d 70 01             	lea    0x1(%eax),%esi
c0106611:	0f b6 00             	movzbl (%eax),%eax
c0106614:	0f be d8             	movsbl %al,%ebx
c0106617:	85 db                	test   %ebx,%ebx
c0106619:	74 27                	je     c0106642 <vprintfmt+0x255>
c010661b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010661f:	78 b4                	js     c01065d5 <vprintfmt+0x1e8>
c0106621:	ff 4d e4             	decl   -0x1c(%ebp)
c0106624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106628:	79 ab                	jns    c01065d5 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
c010662a:	eb 16                	jmp    c0106642 <vprintfmt+0x255>
            {
                putch(' ', putdat);
c010662c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010662f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106633:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010663a:	8b 45 08             	mov    0x8(%ebp),%eax
c010663d:	ff d0                	call   *%eax
            for (; width > 0; width--)
c010663f:	ff 4d e8             	decl   -0x18(%ebp)
c0106642:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106646:	7f e4                	jg     c010662c <vprintfmt+0x23f>
            }
            break;
c0106648:	e9 6c 01 00 00       	jmp    c01067b9 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010664d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106650:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106654:	8d 45 14             	lea    0x14(%ebp),%eax
c0106657:	89 04 24             	mov    %eax,(%esp)
c010665a:	e8 16 fd ff ff       	call   c0106375 <getint>
c010665f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106662:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
c0106665:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106668:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010666b:	85 d2                	test   %edx,%edx
c010666d:	79 26                	jns    c0106695 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
c010666f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106672:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106676:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010667d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106680:	ff d0                	call   *%eax
                num = -(long long)num;
c0106682:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106685:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106688:	f7 d8                	neg    %eax
c010668a:	83 d2 00             	adc    $0x0,%edx
c010668d:	f7 da                	neg    %edx
c010668f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106692:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106695:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010669c:	e9 a8 00 00 00       	jmp    c0106749 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01066a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066a8:	8d 45 14             	lea    0x14(%ebp),%eax
c01066ab:	89 04 24             	mov    %eax,(%esp)
c01066ae:	e8 73 fc ff ff       	call   c0106326 <getuint>
c01066b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01066b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01066c0:	e9 84 00 00 00       	jmp    c0106749 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01066c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066cc:	8d 45 14             	lea    0x14(%ebp),%eax
c01066cf:	89 04 24             	mov    %eax,(%esp)
c01066d2:	e8 4f fc ff ff       	call   c0106326 <getuint>
c01066d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01066dd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01066e4:	eb 63                	jmp    c0106749 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c01066e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01066e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066ed:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01066f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01066f7:	ff d0                	call   *%eax
            putch('x', putdat);
c01066f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01066fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106700:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106707:	8b 45 08             	mov    0x8(%ebp),%eax
c010670a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010670c:	8b 45 14             	mov    0x14(%ebp),%eax
c010670f:	8d 50 04             	lea    0x4(%eax),%edx
c0106712:	89 55 14             	mov    %edx,0x14(%ebp)
c0106715:	8b 00                	mov    (%eax),%eax
c0106717:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010671a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106721:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106728:	eb 1f                	jmp    c0106749 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010672a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010672d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106731:	8d 45 14             	lea    0x14(%ebp),%eax
c0106734:	89 04 24             	mov    %eax,(%esp)
c0106737:	e8 ea fb ff ff       	call   c0106326 <getuint>
c010673c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010673f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106742:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106749:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010674d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106750:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106754:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106757:	89 54 24 14          	mov    %edx,0x14(%esp)
c010675b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010675f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106762:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106765:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106769:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010676d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106770:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106774:	8b 45 08             	mov    0x8(%ebp),%eax
c0106777:	89 04 24             	mov    %eax,(%esp)
c010677a:	e8 a5 fa ff ff       	call   c0106224 <printnum>
            break;
c010677f:	eb 38                	jmp    c01067b9 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106781:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106784:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106788:	89 1c 24             	mov    %ebx,(%esp)
c010678b:	8b 45 08             	mov    0x8(%ebp),%eax
c010678e:	ff d0                	call   *%eax
            break;
c0106790:	eb 27                	jmp    c01067b9 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106792:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106795:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106799:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01067a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01067a3:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
c01067a5:	ff 4d 10             	decl   0x10(%ebp)
c01067a8:	eb 03                	jmp    c01067ad <vprintfmt+0x3c0>
c01067aa:	ff 4d 10             	decl   0x10(%ebp)
c01067ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01067b0:	48                   	dec    %eax
c01067b1:	0f b6 00             	movzbl (%eax),%eax
c01067b4:	3c 25                	cmp    $0x25,%al
c01067b6:	75 f2                	jne    c01067aa <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c01067b8:	90                   	nop
    {
c01067b9:	e9 37 fc ff ff       	jmp    c01063f5 <vprintfmt+0x8>
                return;
c01067be:	90                   	nop
        }
    }
}
c01067bf:	83 c4 40             	add    $0x40,%esp
c01067c2:	5b                   	pop    %ebx
c01067c3:	5e                   	pop    %esi
c01067c4:	5d                   	pop    %ebp
c01067c5:	c3                   	ret    

c01067c6 <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
c01067c6:	55                   	push   %ebp
c01067c7:	89 e5                	mov    %esp,%ebp
    b->cnt++;
c01067c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067cc:	8b 40 08             	mov    0x8(%eax),%eax
c01067cf:	8d 50 01             	lea    0x1(%eax),%edx
c01067d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067d5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
c01067d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067db:	8b 10                	mov    (%eax),%edx
c01067dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067e0:	8b 40 04             	mov    0x4(%eax),%eax
c01067e3:	39 c2                	cmp    %eax,%edx
c01067e5:	73 12                	jae    c01067f9 <sprintputch+0x33>
    {
        *b->buf++ = ch;
c01067e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067ea:	8b 00                	mov    (%eax),%eax
c01067ec:	8d 48 01             	lea    0x1(%eax),%ecx
c01067ef:	8b 55 0c             	mov    0xc(%ebp),%edx
c01067f2:	89 0a                	mov    %ecx,(%edx)
c01067f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01067f7:	88 10                	mov    %dl,(%eax)
    }
}
c01067f9:	90                   	nop
c01067fa:	5d                   	pop    %ebp
c01067fb:	c3                   	ret    

c01067fc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
c01067fc:	55                   	push   %ebp
c01067fd:	89 e5                	mov    %esp,%ebp
c01067ff:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106802:	8d 45 14             	lea    0x14(%ebp),%eax
c0106805:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106808:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010680b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010680f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106812:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010681d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106820:	89 04 24             	mov    %eax,(%esp)
c0106823:	e8 0a 00 00 00       	call   c0106832 <vsnprintf>
c0106828:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010682b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010682e:	89 ec                	mov    %ebp,%esp
c0106830:	5d                   	pop    %ebp
c0106831:	c3                   	ret    

c0106832 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
c0106832:	55                   	push   %ebp
c0106833:	89 e5                	mov    %esp,%ebp
c0106835:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106838:	8b 45 08             	mov    0x8(%ebp),%eax
c010683b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010683e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106841:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106844:	8b 45 08             	mov    0x8(%ebp),%eax
c0106847:	01 d0                	add    %edx,%eax
c0106849:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010684c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
c0106853:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106857:	74 0a                	je     c0106863 <vsnprintf+0x31>
c0106859:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010685c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010685f:	39 c2                	cmp    %eax,%edx
c0106861:	76 07                	jbe    c010686a <vsnprintf+0x38>
    {
        return -E_INVAL;
c0106863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106868:	eb 2a                	jmp    c0106894 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
c010686a:	8b 45 14             	mov    0x14(%ebp),%eax
c010686d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106871:	8b 45 10             	mov    0x10(%ebp),%eax
c0106874:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106878:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010687b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010687f:	c7 04 24 c6 67 10 c0 	movl   $0xc01067c6,(%esp)
c0106886:	e8 62 fb ff ff       	call   c01063ed <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010688b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010688e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106891:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106894:	89 ec                	mov    %ebp,%esp
c0106896:	5d                   	pop    %ebp
c0106897:	c3                   	ret    

c0106898 <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
c0106898:	55                   	push   %ebp
c0106899:	89 e5                	mov    %esp,%ebp
c010689b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010689e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
c01068a5:	eb 03                	jmp    c01068aa <strlen+0x12>
    {
        cnt++;
c01068a7:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
c01068aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01068ad:	8d 50 01             	lea    0x1(%eax),%edx
c01068b0:	89 55 08             	mov    %edx,0x8(%ebp)
c01068b3:	0f b6 00             	movzbl (%eax),%eax
c01068b6:	84 c0                	test   %al,%al
c01068b8:	75 ed                	jne    c01068a7 <strlen+0xf>
    }
    return cnt;
c01068ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01068bd:	89 ec                	mov    %ebp,%esp
c01068bf:	5d                   	pop    %ebp
c01068c0:	c3                   	ret    

c01068c1 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
c01068c1:	55                   	push   %ebp
c01068c2:	89 e5                	mov    %esp,%ebp
c01068c4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01068c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c01068ce:	eb 03                	jmp    c01068d3 <strnlen+0x12>
    {
        cnt++;
c01068d0:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c01068d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01068d9:	73 10                	jae    c01068eb <strnlen+0x2a>
c01068db:	8b 45 08             	mov    0x8(%ebp),%eax
c01068de:	8d 50 01             	lea    0x1(%eax),%edx
c01068e1:	89 55 08             	mov    %edx,0x8(%ebp)
c01068e4:	0f b6 00             	movzbl (%eax),%eax
c01068e7:	84 c0                	test   %al,%al
c01068e9:	75 e5                	jne    c01068d0 <strnlen+0xf>
    }
    return cnt;
c01068eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01068ee:	89 ec                	mov    %ebp,%esp
c01068f0:	5d                   	pop    %ebp
c01068f1:	c3                   	ret    

c01068f2 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
c01068f2:	55                   	push   %ebp
c01068f3:	89 e5                	mov    %esp,%ebp
c01068f5:	57                   	push   %edi
c01068f6:	56                   	push   %esi
c01068f7:	83 ec 20             	sub    $0x20,%esp
c01068fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01068fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106900:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106903:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
c0106906:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010690c:	89 d1                	mov    %edx,%ecx
c010690e:	89 c2                	mov    %eax,%edx
c0106910:	89 ce                	mov    %ecx,%esi
c0106912:	89 d7                	mov    %edx,%edi
c0106914:	ac                   	lods   %ds:(%esi),%al
c0106915:	aa                   	stos   %al,%es:(%edi)
c0106916:	84 c0                	test   %al,%al
c0106918:	75 fa                	jne    c0106914 <strcpy+0x22>
c010691a:	89 fa                	mov    %edi,%edx
c010691c:	89 f1                	mov    %esi,%ecx
c010691e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106921:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
c0106927:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010692a:	83 c4 20             	add    $0x20,%esp
c010692d:	5e                   	pop    %esi
c010692e:	5f                   	pop    %edi
c010692f:	5d                   	pop    %ebp
c0106930:	c3                   	ret    

c0106931 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
c0106931:	55                   	push   %ebp
c0106932:	89 e5                	mov    %esp,%ebp
c0106934:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0106937:	8b 45 08             	mov    0x8(%ebp),%eax
c010693a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
c010693d:	eb 1e                	jmp    c010695d <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
c010693f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106942:	0f b6 10             	movzbl (%eax),%edx
c0106945:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106948:	88 10                	mov    %dl,(%eax)
c010694a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010694d:	0f b6 00             	movzbl (%eax),%eax
c0106950:	84 c0                	test   %al,%al
c0106952:	74 03                	je     c0106957 <strncpy+0x26>
        {
            src++;
c0106954:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
c0106957:	ff 45 fc             	incl   -0x4(%ebp)
c010695a:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
c010695d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106961:	75 dc                	jne    c010693f <strncpy+0xe>
    }
    return dst;
c0106963:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106966:	89 ec                	mov    %ebp,%esp
c0106968:	5d                   	pop    %ebp
c0106969:	c3                   	ret    

c010696a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
c010696a:	55                   	push   %ebp
c010696b:	89 e5                	mov    %esp,%ebp
c010696d:	57                   	push   %edi
c010696e:	56                   	push   %esi
c010696f:	83 ec 20             	sub    $0x20,%esp
c0106972:	8b 45 08             	mov    0x8(%ebp),%eax
c0106975:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106978:	8b 45 0c             	mov    0xc(%ebp),%eax
c010697b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
c010697e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106981:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106984:	89 d1                	mov    %edx,%ecx
c0106986:	89 c2                	mov    %eax,%edx
c0106988:	89 ce                	mov    %ecx,%esi
c010698a:	89 d7                	mov    %edx,%edi
c010698c:	ac                   	lods   %ds:(%esi),%al
c010698d:	ae                   	scas   %es:(%edi),%al
c010698e:	75 08                	jne    c0106998 <strcmp+0x2e>
c0106990:	84 c0                	test   %al,%al
c0106992:	75 f8                	jne    c010698c <strcmp+0x22>
c0106994:	31 c0                	xor    %eax,%eax
c0106996:	eb 04                	jmp    c010699c <strcmp+0x32>
c0106998:	19 c0                	sbb    %eax,%eax
c010699a:	0c 01                	or     $0x1,%al
c010699c:	89 fa                	mov    %edi,%edx
c010699e:	89 f1                	mov    %esi,%ecx
c01069a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01069a3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01069a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01069a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01069ac:	83 c4 20             	add    $0x20,%esp
c01069af:	5e                   	pop    %esi
c01069b0:	5f                   	pop    %edi
c01069b1:	5d                   	pop    %ebp
c01069b2:	c3                   	ret    

c01069b3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
c01069b3:	55                   	push   %ebp
c01069b4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c01069b6:	eb 09                	jmp    c01069c1 <strncmp+0xe>
    {
        n--, s1++, s2++;
c01069b8:	ff 4d 10             	decl   0x10(%ebp)
c01069bb:	ff 45 08             	incl   0x8(%ebp)
c01069be:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c01069c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01069c5:	74 1a                	je     c01069e1 <strncmp+0x2e>
c01069c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ca:	0f b6 00             	movzbl (%eax),%eax
c01069cd:	84 c0                	test   %al,%al
c01069cf:	74 10                	je     c01069e1 <strncmp+0x2e>
c01069d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01069d4:	0f b6 10             	movzbl (%eax),%edx
c01069d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069da:	0f b6 00             	movzbl (%eax),%eax
c01069dd:	38 c2                	cmp    %al,%dl
c01069df:	74 d7                	je     c01069b8 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01069e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01069e5:	74 18                	je     c01069ff <strncmp+0x4c>
c01069e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ea:	0f b6 00             	movzbl (%eax),%eax
c01069ed:	0f b6 d0             	movzbl %al,%edx
c01069f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069f3:	0f b6 00             	movzbl (%eax),%eax
c01069f6:	0f b6 c8             	movzbl %al,%ecx
c01069f9:	89 d0                	mov    %edx,%eax
c01069fb:	29 c8                	sub    %ecx,%eax
c01069fd:	eb 05                	jmp    c0106a04 <strncmp+0x51>
c01069ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a04:	5d                   	pop    %ebp
c0106a05:	c3                   	ret    

c0106a06 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
c0106a06:	55                   	push   %ebp
c0106a07:	89 e5                	mov    %esp,%ebp
c0106a09:	83 ec 04             	sub    $0x4,%esp
c0106a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c0106a12:	eb 13                	jmp    c0106a27 <strchr+0x21>
    {
        if (*s == c)
c0106a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a17:	0f b6 00             	movzbl (%eax),%eax
c0106a1a:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0106a1d:	75 05                	jne    c0106a24 <strchr+0x1e>
        {
            return (char *)s;
c0106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a22:	eb 12                	jmp    c0106a36 <strchr+0x30>
        }
        s++;
c0106a24:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c0106a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a2a:	0f b6 00             	movzbl (%eax),%eax
c0106a2d:	84 c0                	test   %al,%al
c0106a2f:	75 e3                	jne    c0106a14 <strchr+0xe>
    }
    return NULL;
c0106a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a36:	89 ec                	mov    %ebp,%esp
c0106a38:	5d                   	pop    %ebp
c0106a39:	c3                   	ret    

c0106a3a <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
c0106a3a:	55                   	push   %ebp
c0106a3b:	89 e5                	mov    %esp,%ebp
c0106a3d:	83 ec 04             	sub    $0x4,%esp
c0106a40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a43:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c0106a46:	eb 0e                	jmp    c0106a56 <strfind+0x1c>
    {
        if (*s == c)
c0106a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a4b:	0f b6 00             	movzbl (%eax),%eax
c0106a4e:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0106a51:	74 0f                	je     c0106a62 <strfind+0x28>
        {
            break;
        }
        s++;
c0106a53:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c0106a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a59:	0f b6 00             	movzbl (%eax),%eax
c0106a5c:	84 c0                	test   %al,%al
c0106a5e:	75 e8                	jne    c0106a48 <strfind+0xe>
c0106a60:	eb 01                	jmp    c0106a63 <strfind+0x29>
            break;
c0106a62:	90                   	nop
    }
    return (char *)s;
c0106a63:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106a66:	89 ec                	mov    %ebp,%esp
c0106a68:	5d                   	pop    %ebp
c0106a69:	c3                   	ret    

c0106a6a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
c0106a6a:	55                   	push   %ebp
c0106a6b:	89 e5                	mov    %esp,%ebp
c0106a6d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0106a70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0106a77:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
c0106a7e:	eb 03                	jmp    c0106a83 <strtol+0x19>
    {
        s++;
c0106a80:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
c0106a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a86:	0f b6 00             	movzbl (%eax),%eax
c0106a89:	3c 20                	cmp    $0x20,%al
c0106a8b:	74 f3                	je     c0106a80 <strtol+0x16>
c0106a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a90:	0f b6 00             	movzbl (%eax),%eax
c0106a93:	3c 09                	cmp    $0x9,%al
c0106a95:	74 e9                	je     c0106a80 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
c0106a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a9a:	0f b6 00             	movzbl (%eax),%eax
c0106a9d:	3c 2b                	cmp    $0x2b,%al
c0106a9f:	75 05                	jne    c0106aa6 <strtol+0x3c>
    {
        s++;
c0106aa1:	ff 45 08             	incl   0x8(%ebp)
c0106aa4:	eb 14                	jmp    c0106aba <strtol+0x50>
    }
    else if (*s == '-')
c0106aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa9:	0f b6 00             	movzbl (%eax),%eax
c0106aac:	3c 2d                	cmp    $0x2d,%al
c0106aae:	75 0a                	jne    c0106aba <strtol+0x50>
    {
        s++, neg = 1;
c0106ab0:	ff 45 08             	incl   0x8(%ebp)
c0106ab3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
c0106aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106abe:	74 06                	je     c0106ac6 <strtol+0x5c>
c0106ac0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0106ac4:	75 22                	jne    c0106ae8 <strtol+0x7e>
c0106ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac9:	0f b6 00             	movzbl (%eax),%eax
c0106acc:	3c 30                	cmp    $0x30,%al
c0106ace:	75 18                	jne    c0106ae8 <strtol+0x7e>
c0106ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad3:	40                   	inc    %eax
c0106ad4:	0f b6 00             	movzbl (%eax),%eax
c0106ad7:	3c 78                	cmp    $0x78,%al
c0106ad9:	75 0d                	jne    c0106ae8 <strtol+0x7e>
    {
        s += 2, base = 16;
c0106adb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106adf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0106ae6:	eb 29                	jmp    c0106b11 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
c0106ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106aec:	75 16                	jne    c0106b04 <strtol+0x9a>
c0106aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0106af1:	0f b6 00             	movzbl (%eax),%eax
c0106af4:	3c 30                	cmp    $0x30,%al
c0106af6:	75 0c                	jne    c0106b04 <strtol+0x9a>
    {
        s++, base = 8;
c0106af8:	ff 45 08             	incl   0x8(%ebp)
c0106afb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106b02:	eb 0d                	jmp    c0106b11 <strtol+0xa7>
    }
    else if (base == 0)
c0106b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106b08:	75 07                	jne    c0106b11 <strtol+0xa7>
    {
        base = 10;
c0106b0a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
c0106b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b14:	0f b6 00             	movzbl (%eax),%eax
c0106b17:	3c 2f                	cmp    $0x2f,%al
c0106b19:	7e 1b                	jle    c0106b36 <strtol+0xcc>
c0106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b1e:	0f b6 00             	movzbl (%eax),%eax
c0106b21:	3c 39                	cmp    $0x39,%al
c0106b23:	7f 11                	jg     c0106b36 <strtol+0xcc>
        {
            dig = *s - '0';
c0106b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b28:	0f b6 00             	movzbl (%eax),%eax
c0106b2b:	0f be c0             	movsbl %al,%eax
c0106b2e:	83 e8 30             	sub    $0x30,%eax
c0106b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106b34:	eb 48                	jmp    c0106b7e <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
c0106b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b39:	0f b6 00             	movzbl (%eax),%eax
c0106b3c:	3c 60                	cmp    $0x60,%al
c0106b3e:	7e 1b                	jle    c0106b5b <strtol+0xf1>
c0106b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b43:	0f b6 00             	movzbl (%eax),%eax
c0106b46:	3c 7a                	cmp    $0x7a,%al
c0106b48:	7f 11                	jg     c0106b5b <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
c0106b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b4d:	0f b6 00             	movzbl (%eax),%eax
c0106b50:	0f be c0             	movsbl %al,%eax
c0106b53:	83 e8 57             	sub    $0x57,%eax
c0106b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106b59:	eb 23                	jmp    c0106b7e <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
c0106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b5e:	0f b6 00             	movzbl (%eax),%eax
c0106b61:	3c 40                	cmp    $0x40,%al
c0106b63:	7e 3b                	jle    c0106ba0 <strtol+0x136>
c0106b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b68:	0f b6 00             	movzbl (%eax),%eax
c0106b6b:	3c 5a                	cmp    $0x5a,%al
c0106b6d:	7f 31                	jg     c0106ba0 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
c0106b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b72:	0f b6 00             	movzbl (%eax),%eax
c0106b75:	0f be c0             	movsbl %al,%eax
c0106b78:	83 e8 37             	sub    $0x37,%eax
c0106b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
c0106b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b81:	3b 45 10             	cmp    0x10(%ebp),%eax
c0106b84:	7d 19                	jge    c0106b9f <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
c0106b86:	ff 45 08             	incl   0x8(%ebp)
c0106b89:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106b8c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106b90:	89 c2                	mov    %eax,%edx
c0106b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b95:	01 d0                	add    %edx,%eax
c0106b97:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
c0106b9a:	e9 72 ff ff ff       	jmp    c0106b11 <strtol+0xa7>
            break;
c0106b9f:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
c0106ba0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106ba4:	74 08                	je     c0106bae <strtol+0x144>
    {
        *endptr = (char *)s;
c0106ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ba9:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bac:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106bb2:	74 07                	je     c0106bbb <strtol+0x151>
c0106bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106bb7:	f7 d8                	neg    %eax
c0106bb9:	eb 03                	jmp    c0106bbe <strtol+0x154>
c0106bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106bbe:	89 ec                	mov    %ebp,%esp
c0106bc0:	5d                   	pop    %ebp
c0106bc1:	c3                   	ret    

c0106bc2 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
c0106bc2:	55                   	push   %ebp
c0106bc3:	89 e5                	mov    %esp,%ebp
c0106bc5:	83 ec 28             	sub    $0x28,%esp
c0106bc8:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0106bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bce:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106bd1:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0106bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0106bdb:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0106bde:	8b 45 10             	mov    0x10(%ebp),%eax
c0106be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
c0106be4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0106be7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0106beb:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106bee:	89 d7                	mov    %edx,%edi
c0106bf0:	f3 aa                	rep stos %al,%es:(%edi)
c0106bf2:	89 fa                	mov    %edi,%edx
c0106bf4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106bf7:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
c0106bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0106bfd:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0106c00:	89 ec                	mov    %ebp,%esp
c0106c02:	5d                   	pop    %ebp
c0106c03:	c3                   	ret    

c0106c04 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
c0106c04:	55                   	push   %ebp
c0106c05:	89 e5                	mov    %esp,%ebp
c0106c07:	57                   	push   %edi
c0106c08:	56                   	push   %esi
c0106c09:	53                   	push   %ebx
c0106c0a:	83 ec 30             	sub    $0x30,%esp
c0106c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c19:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
c0106c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106c25:	73 42                	jae    c0106c69 <memmove+0x65>
c0106c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0106c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c3c:	c1 e8 02             	shr    $0x2,%eax
c0106c3f:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0106c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c47:	89 d7                	mov    %edx,%edi
c0106c49:	89 c6                	mov    %eax,%esi
c0106c4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106c4d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106c50:	83 e1 03             	and    $0x3,%ecx
c0106c53:	74 02                	je     c0106c57 <memmove+0x53>
c0106c55:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106c57:	89 f0                	mov    %esi,%eax
c0106c59:	89 fa                	mov    %edi,%edx
c0106c5b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106c5e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106c61:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0106c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0106c67:	eb 36                	jmp    c0106c9f <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
c0106c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c72:	01 c2                	add    %eax,%edx
c0106c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c77:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c7d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
c0106c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c83:	89 c1                	mov    %eax,%ecx
c0106c85:	89 d8                	mov    %ebx,%eax
c0106c87:	89 d6                	mov    %edx,%esi
c0106c89:	89 c7                	mov    %eax,%edi
c0106c8b:	fd                   	std    
c0106c8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106c8e:	fc                   	cld    
c0106c8f:	89 f8                	mov    %edi,%eax
c0106c91:	89 f2                	mov    %esi,%edx
c0106c93:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106c96:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106c99:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106c9f:	83 c4 30             	add    $0x30,%esp
c0106ca2:	5b                   	pop    %ebx
c0106ca3:	5e                   	pop    %esi
c0106ca4:	5f                   	pop    %edi
c0106ca5:	5d                   	pop    %ebp
c0106ca6:	c3                   	ret    

c0106ca7 <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
c0106ca7:	55                   	push   %ebp
c0106ca8:	89 e5                	mov    %esp,%ebp
c0106caa:	57                   	push   %edi
c0106cab:	56                   	push   %esi
c0106cac:	83 ec 20             	sub    $0x20,%esp
c0106caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0106cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106cc4:	c1 e8 02             	shr    $0x2,%eax
c0106cc7:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0106cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ccf:	89 d7                	mov    %edx,%edi
c0106cd1:	89 c6                	mov    %eax,%esi
c0106cd3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106cd5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106cd8:	83 e1 03             	and    $0x3,%ecx
c0106cdb:	74 02                	je     c0106cdf <memcpy+0x38>
c0106cdd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106cdf:	89 f0                	mov    %esi,%eax
c0106ce1:	89 fa                	mov    %edi,%edx
c0106ce3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106ce6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106ce9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0106cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106cef:	83 c4 20             	add    $0x20,%esp
c0106cf2:	5e                   	pop    %esi
c0106cf3:	5f                   	pop    %edi
c0106cf4:	5d                   	pop    %ebp
c0106cf5:	c3                   	ret    

c0106cf6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
c0106cf6:	55                   	push   %ebp
c0106cf7:	89 e5                	mov    %esp,%ebp
c0106cf9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106d02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
c0106d08:	eb 2e                	jmp    c0106d38 <memcmp+0x42>
    {
        if (*s1 != *s2)
c0106d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d0d:	0f b6 10             	movzbl (%eax),%edx
c0106d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106d13:	0f b6 00             	movzbl (%eax),%eax
c0106d16:	38 c2                	cmp    %al,%dl
c0106d18:	74 18                	je     c0106d32 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d1d:	0f b6 00             	movzbl (%eax),%eax
c0106d20:	0f b6 d0             	movzbl %al,%edx
c0106d23:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106d26:	0f b6 00             	movzbl (%eax),%eax
c0106d29:	0f b6 c8             	movzbl %al,%ecx
c0106d2c:	89 d0                	mov    %edx,%eax
c0106d2e:	29 c8                	sub    %ecx,%eax
c0106d30:	eb 18                	jmp    c0106d4a <memcmp+0x54>
        }
        s1++, s2++;
c0106d32:	ff 45 fc             	incl   -0x4(%ebp)
c0106d35:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
c0106d38:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106d3e:	89 55 10             	mov    %edx,0x10(%ebp)
c0106d41:	85 c0                	test   %eax,%eax
c0106d43:	75 c5                	jne    c0106d0a <memcmp+0x14>
    }
    return 0;
c0106d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d4a:	89 ec                	mov    %ebp,%esp
c0106d4c:	5d                   	pop    %ebp
c0106d4d:	c3                   	ret    
