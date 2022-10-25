
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
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
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
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
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 b0 11 c0 	movl   $0xc011b000,(%esp)
c0100059:	e8 9e 5d 00 00       	call   c0105dfc <memset>

    cons_init(); // init the console
c010005e:	e8 f9 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 a0 5f 10 c0 	movl   $0xc0105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 bc 5f 10 c0 	movl   $0xc0105fbc,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 95 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init(); // init physical memory management
c0100087:	e8 7a 44 00 00       	call   c0104506 <pmm_init>

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
c010015f:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 c1 5f 10 c0 	movl   $0xc0105fc1,(%esp)
c0100173:	e8 ed 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	89 c2                	mov    %eax,%edx
c010017e:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100183:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100187:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018b:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c0100192:	e8 ce 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019b:	89 c2                	mov    %eax,%edx
c010019d:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001aa:	c7 04 24 dd 5f 10 c0 	movl   $0xc0105fdd,(%esp)
c01001b1:	e8 af 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ba:	89 c2                	mov    %eax,%edx
c01001bc:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c9:	c7 04 24 eb 5f 10 c0 	movl   $0xc0105feb,(%esp)
c01001d0:	e8 90 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d9:	89 c2                	mov    %eax,%edx
c01001db:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e8:	c7 04 24 f9 5f 10 c0 	movl   $0xc0105ff9,(%esp)
c01001ef:	e8 71 01 00 00       	call   c0100365 <cprintf>
    round++;
c01001f4:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001f9:	40                   	inc    %eax
c01001fa:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
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
c0100225:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 ce ff ff ff       	call   c0100204 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 09 ff ff ff       	call   c0100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 28 60 10 c0 	movl   $0xc0106028,(%esp)
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
c0100269:	c7 04 24 47 60 10 c0 	movl   $0xc0106047,(%esp)
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
c01002b7:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
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
c01002f5:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fd:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
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
c0100359:	e8 c9 52 00 00       	call   c0105627 <vprintfmt>
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
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
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

    while (l <= r) {
c010042d:	e9 ca 00 00 00       	jmp    c01004fc <stab_binsearch+0xec>
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
        while (m >= l && stabs[m].n_type != type) {
c010044c:	eb 03                	jmp    c0100451 <stab_binsearch+0x41>
            m --;
c010044e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
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
        if (m < l) {    // no match in [l, m]
c0100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010047b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010047e:	7d 09                	jge    c0100489 <stab_binsearch+0x79>
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
        if (stabs[m].n_value < addr) {
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
            *region_left = m;
c01004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004b6:	40                   	inc    %eax
c01004b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ba:	eb 40                	jmp    c01004fc <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
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
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100502:	0f 8e 2a ff ff ff    	jle    c0100432 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c0100508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010050c:	75 0f                	jne    c010051d <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c010050e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100516:	8b 45 10             	mov    0x10(%ebp),%eax
c0100519:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010051b:	eb 3e                	jmp    c010055b <stab_binsearch+0x14b>
        l = *region_right;
c010051d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100520:	8b 00                	mov    (%eax),%eax
c0100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
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
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100560:	55                   	push   %ebp
c0100561:	89 e5                	mov    %esp,%ebp
c0100563:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100566:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100569:	c7 00 4c 60 10 c0    	movl   $0xc010604c,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 4c 60 10 c0 	movl   $0xc010604c,0x8(%eax)
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
c01005a0:	c7 45 f4 f8 72 10 c0 	movl   $0xc01072f8,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 f0 28 11 c0 	movl   $0xc01128f0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec f1 28 11 c0 	movl   $0xc01128f1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 5f 5e 11 c0 	movl   $0xc0115e5f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005c2:	76 0b                	jbe    c01005cf <debuginfo_eip+0x6f>
c01005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c7:	48                   	dec    %eax
c01005c8:	0f b6 00             	movzbl (%eax),%eax
c01005cb:	84 c0                	test   %al,%al
c01005cd:	74 0a                	je     c01005d9 <debuginfo_eip+0x79>
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

    if (lfun <= rfun) {
c0100660:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100663:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	7f 78                	jg     c01006e2 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
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
    } else {
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
c0100708:	e8 67 55 00 00       	call   c0105c74 <strfind>
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
    if (lline <= rline) {
c0100745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100748:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074b:	39 c2                	cmp    %eax,%edx
c010074d:	7f 23                	jg     c0100772 <debuginfo_eip+0x212>
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
    while (lline >= lfile
c0100770:	eb 11                	jmp    c0100783 <debuginfo_eip+0x223>
        return -1;
c0100772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100777:	e9 08 01 00 00       	jmp    c0100884 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077f:	48                   	dec    %eax
c0100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	7c 56                	jl     c01007e3 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
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
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
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
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
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
    if (lfun < rfun) {
c010082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100832:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100835:	39 c2                	cmp    %eax,%edx
c0100837:	7d 46                	jge    c010087f <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c0100839:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010083c:	40                   	inc    %eax
c010083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100840:	eb 16                	jmp    c0100858 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	8b 40 14             	mov    0x14(%eax),%eax
c0100848:	8d 50 01             	lea    0x1(%eax),%edx
c010084b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
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
void
print_kerninfo(void) {
c0100888:	55                   	push   %ebp
c0100889:	89 e5                	mov    %esp,%ebp
c010088b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088e:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 6f 60 10 c0 	movl   $0xc010606f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 88 5f 10 	movl   $0xc0105f88,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 9f 60 10 c0 	movl   $0xc010609f,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 2c bf 11 	movl   $0xc011bf2c,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 b7 60 10 c0 	movl   $0xc01060b7,(%esp)
c01008e5:	e8 7b fa ff ff       	call   c0100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008ea:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c01008ef:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ff:	85 c0                	test   %eax,%eax
c0100901:	0f 48 c2             	cmovs  %edx,%eax
c0100904:	c1 f8 0a             	sar    $0xa,%eax
c0100907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090b:	c7 04 24 d0 60 10 c0 	movl   $0xc01060d0,(%esp)
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
void
print_debuginfo(uintptr_t eip) {
c010091c:	55                   	push   %ebp
c010091d:	89 e5                	mov    %esp,%ebp
c010091f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100925:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 04 24             	mov    %eax,(%esp)
c0100932:	e8 29 fc ff ff       	call   c0100560 <debuginfo_eip>
c0100937:	85 c0                	test   %eax,%eax
c0100939:	74 15                	je     c0100950 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093b:	8b 45 08             	mov    0x8(%ebp),%eax
c010093e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100942:	c7 04 24 fa 60 10 c0 	movl   $0xc01060fa,(%esp)
c0100949:	e8 17 fa ff ff       	call   c0100365 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010094e:	eb 6c                	jmp    c01009bc <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
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
        for (j = 0; j < info.eip_fn_namelen; j ++) {
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
c01009b0:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c01009b7:	e8 a9 f9 ff ff       	call   c0100365 <cprintf>
}
c01009bc:	90                   	nop
c01009bd:	89 ec                	mov    %ebp,%esp
c01009bf:	5d                   	pop    %ebp
c01009c0:	c3                   	ret    

c01009c1 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c1:	55                   	push   %ebp
c01009c2:	89 e5                	mov    %esp,%ebp
c01009c4:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c7:	8b 45 04             	mov    0x4(%ebp),%eax
c01009ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
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
void
print_stackframe(void) {
c01009d4:	55                   	push   %ebp
c01009d5:	89 e5                	mov    %esp,%ebp
c01009d7:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009da:	89 e8                	mov    %ebp,%eax
c01009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
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
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f4:	e9 84 00 00 00       	jmp    c0100a7d <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 28 61 10 c0 	movl   $0xc0106128,(%esp)
c0100a0e:	e8 52 f9 ff ff       	call   c0100365 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a16:	83 c0 08             	add    $0x8,%eax
c0100a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a23:	eb 24                	jmp    c0100a49 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
c0100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a32:	01 d0                	add    %edx,%eax
c0100a34:	8b 00                	mov    (%eax),%eax
c0100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3a:	c7 04 24 44 61 10 c0 	movl   $0xc0106144,(%esp)
c0100a41:	e8 1f f9 ff ff       	call   c0100365 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100a46:	ff 45 e8             	incl   -0x18(%ebp)
c0100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4d:	7e d6                	jle    c0100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a4f:	c7 04 24 4c 61 10 c0 	movl   $0xc010614c,(%esp)
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
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
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
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a92:	55                   	push   %ebp
c0100a93:	89 e5                	mov    %esp,%ebp
c0100a95:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9f:	eb 0c                	jmp    c0100aad <parse+0x1b>
            *buf ++ = '\0';
c0100aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa4:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa7:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aaa:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab0:	0f b6 00             	movzbl (%eax),%eax
c0100ab3:	84 c0                	test   %al,%al
c0100ab5:	74 1d                	je     c0100ad4 <parse+0x42>
c0100ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aba:	0f b6 00             	movzbl (%eax),%eax
c0100abd:	0f be c0             	movsbl %al,%eax
c0100ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac4:	c7 04 24 d0 61 10 c0 	movl   $0xc01061d0,(%esp)
c0100acb:	e8 70 51 00 00       	call   c0105c40 <strchr>
c0100ad0:	85 c0                	test   %eax,%eax
c0100ad2:	75 cd                	jne    c0100aa1 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad7:	0f b6 00             	movzbl (%eax),%eax
c0100ada:	84 c0                	test   %al,%al
c0100adc:	74 65                	je     c0100b43 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 d5 61 10 c0 	movl   $0xc01061d5,(%esp)
c0100af3:	e8 6d f8 ff ff       	call   c0100365 <cprintf>
        }
        argv[argc ++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	eb 03                	jmp    c0100b17 <parse+0x85>
            buf ++;
c0100b14:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	84 c0                	test   %al,%al
c0100b1f:	74 8c                	je     c0100aad <parse+0x1b>
c0100b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b24:	0f b6 00             	movzbl (%eax),%eax
c0100b27:	0f be c0             	movsbl %al,%eax
c0100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2e:	c7 04 24 d0 61 10 c0 	movl   $0xc01061d0,(%esp)
c0100b35:	e8 06 51 00 00       	call   c0105c40 <strchr>
c0100b3a:	85 c0                	test   %eax,%eax
c0100b3c:	74 d6                	je     c0100b14 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
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
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
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
    if (argc == 0) {
c0100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6d:	75 0a                	jne    c0100b79 <runcmd+0x2e>
        return 0;
c0100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b74:	e9 83 00 00 00       	jmp    c0100bfc <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b80:	eb 5a                	jmp    c0100bdc <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b82:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b88:	89 c8                	mov    %ecx,%eax
c0100b8a:	01 c0                	add    %eax,%eax
c0100b8c:	01 c8                	add    %ecx,%eax
c0100b8e:	c1 e0 02             	shl    $0x2,%eax
c0100b91:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 00 50 00 00       	call   c0105ba4 <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 31                	jne    c0100bd9 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 08 80 11 c0       	add    $0xc0118008,%eax
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
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd9:	ff 45 f4             	incl   -0xc(%ebp)
c0100bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdf:	83 f8 02             	cmp    $0x2,%eax
c0100be2:	76 9e                	jbe    c0100b82 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100beb:	c7 04 24 f3 61 10 c0 	movl   $0xc01061f3,(%esp)
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

void
kmonitor(struct trapframe *tf) {
c0100c03:	55                   	push   %ebp
c0100c04:	89 e5                	mov    %esp,%ebp
c0100c06:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c09:	c7 04 24 0c 62 10 c0 	movl   $0xc010620c,(%esp)
c0100c10:	e8 50 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c15:	c7 04 24 34 62 10 c0 	movl   $0xc0106234,(%esp)
c0100c1c:	e8 44 f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL) {
c0100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c25:	74 0b                	je     c0100c32 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2a:	89 04 24             	mov    %eax,(%esp)
c0100c2d:	e8 f1 0e 00 00       	call   c0101b23 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c32:	c7 04 24 59 62 10 c0 	movl   $0xc0106259,(%esp)
c0100c39:	e8 18 f6 ff ff       	call   c0100256 <readline>
c0100c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c45:	74 eb                	je     c0100c32 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c51:	89 04 24             	mov    %eax,(%esp)
c0100c54:	e8 f2 fe ff ff       	call   c0100b4b <runcmd>
c0100c59:	85 c0                	test   %eax,%eax
c0100c5b:	78 02                	js     c0100c5f <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c5d:	eb d3                	jmp    c0100c32 <kmonitor+0x2f>
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
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c65:	55                   	push   %ebp
c0100c66:	89 e5                	mov    %esp,%ebp
c0100c68:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c72:	eb 3d                	jmp    c0100cb1 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c77:	89 d0                	mov    %edx,%eax
c0100c79:	01 c0                	add    %eax,%eax
c0100c7b:	01 d0                	add    %edx,%eax
c0100c7d:	c1 e0 02             	shl    $0x2,%eax
c0100c80:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c85:	8b 10                	mov    (%eax),%edx
c0100c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c8a:	89 c8                	mov    %ecx,%eax
c0100c8c:	01 c0                	add    %eax,%eax
c0100c8e:	01 c8                	add    %ecx,%eax
c0100c90:	c1 e0 02             	shl    $0x2,%eax
c0100c93:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c98:	8b 00                	mov    (%eax),%eax
c0100c9a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca2:	c7 04 24 5d 62 10 c0 	movl   $0xc010625d,(%esp)
c0100ca9:	e8 b7 f6 ff ff       	call   c0100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
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
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
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
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
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
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cea:	55                   	push   %ebp
c0100ceb:	89 e5                	mov    %esp,%ebp
c0100ced:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cf0:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100cf5:	85 c0                	test   %eax,%eax
c0100cf7:	75 5b                	jne    c0100d54 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cf9:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
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
c0100d17:	c7 04 24 66 62 10 c0 	movl   $0xc0106266,(%esp)
c0100d1e:	e8 42 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2d:	89 04 24             	mov    %eax,(%esp)
c0100d30:	e8 fb f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d35:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100d3c:	e8 24 f6 ff ff       	call   c0100365 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d41:	c7 04 24 84 62 10 c0 	movl   $0xc0106284,(%esp)
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
    while (1) {
        kmonitor(NULL);
c0100d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d61:	e8 9d fe ff ff       	call   c0100c03 <kmonitor>
c0100d66:	eb f2                	jmp    c0100d5a <__panic+0x70>

c0100d68 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
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
c0100d82:	c7 04 24 96 62 10 c0 	movl   $0xc0106296,(%esp)
c0100d89:	e8 d7 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d95:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d98:	89 04 24             	mov    %eax,(%esp)
c0100d9b:	e8 90 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da0:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100da7:	e8 b9 f5 ff ff       	call   c0100365 <cprintf>
    va_end(ap);
}
c0100dac:	90                   	nop
c0100dad:	89 ec                	mov    %ebp,%esp
c0100daf:	5d                   	pop    %ebp
c0100db0:	c3                   	ret    

c0100db1 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100db4:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100db9:	5d                   	pop    %ebp
c0100dba:	c3                   	ret    

c0100dbb <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dbb:	55                   	push   %ebp
c0100dbc:	89 e5                	mov    %esp,%ebp
c0100dbe:	83 ec 28             	sub    $0x28,%esp
c0100dc1:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dc7:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dcb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd3:	ee                   	out    %al,(%dx)
}
c0100dd4:	90                   	nop
c0100dd5:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ddb:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ddf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100de3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100de7:	ee                   	out    %al,(%dx)
}
c0100de8:	90                   	nop
c0100de9:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100def:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
c0100dfd:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e07:	c7 04 24 b4 62 10 c0 	movl   $0xc01062b4,(%esp)
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
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e24:	55                   	push   %ebp
c0100e25:	89 e5                	mov    %esp,%ebp
c0100e27:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e2a:	9c                   	pushf  
c0100e2b:	58                   	pop    %eax
c0100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e32:	25 00 02 00 00       	and    $0x200,%eax
c0100e37:	85 c0                	test   %eax,%eax
c0100e39:	74 0c                	je     c0100e47 <__intr_save+0x23>
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
__intr_restore(bool flag) {
c0100e50:	55                   	push   %ebp
c0100e51:	89 e5                	mov    %esp,%ebp
c0100e53:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e5a:	74 05                	je     c0100e61 <__intr_restore+0x11>
        intr_enable();
c0100e5c:	e8 da 08 00 00       	call   c010173b <intr_enable>
    }
}
c0100e61:	90                   	nop
c0100e62:	89 ec                	mov    %ebp,%esp
c0100e64:	5d                   	pop    %ebp
c0100e65:	c3                   	ret    

c0100e66 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e66:	55                   	push   %ebp
c0100e67:	89 e5                	mov    %esp,%ebp
c0100e69:	83 ec 10             	sub    $0x10,%esp
c0100e6c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eb1:	55                   	push   %ebp
c0100eb2:	89 e5                	mov    %esp,%ebp
c0100eb4:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100eb7:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 00             	movzwl (%eax),%eax
c0100ec4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ecb:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed3:	0f b7 00             	movzwl (%eax),%eax
c0100ed6:	0f b7 c0             	movzwl %ax,%eax
c0100ed9:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ede:	74 12                	je     c0100ef2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ee0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ee7:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100eee:	b4 03 
c0100ef0:	eb 13                	jmp    c0100f05 <cga_init+0x54>
    } else {
        *cp = was;
c0100ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ef9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100efc:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f05:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
}
c0100f1d:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f1e:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f25:	40                   	inc    %eax
c0100f26:	0f b7 c0             	movzwl %ax,%eax
c0100f29:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
c0100f44:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f53:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f57:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f5b:	ee                   	out    %al,(%dx)
}
c0100f5c:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f5d:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f64:	40                   	inc    %eax
c0100f65:	0f b7 c0             	movzwl %ax,%eax
c0100f68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f70:	89 c2                	mov    %eax,%edx
c0100f72:	ec                   	in     (%dx),%al
c0100f73:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7a:	0f b6 c0             	movzbl %al,%eax
c0100f7d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f83:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f8b:	0f b7 c0             	movzwl %ax,%eax
c0100f8e:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100f94:	90                   	nop
c0100f95:	89 ec                	mov    %ebp,%esp
c0100f97:	5d                   	pop    %ebp
c0100f98:	c3                   	ret    

c0100f99 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f99:	55                   	push   %ebp
c0100f9a:	89 e5                	mov    %esp,%ebp
c0100f9c:	83 ec 48             	sub    $0x48,%esp
c0100f9f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fa5:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fb1:	ee                   	out    %al,(%dx)
}
c0100fb2:	90                   	nop
c0100fb3:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fb9:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fbd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fc1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fc5:	ee                   	out    %al,(%dx)
}
c0100fc6:	90                   	nop
c0100fc7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fcd:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fd5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
}
c0100fda:	90                   	nop
c0100fdb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fed:	ee                   	out    %al,(%dx)
}
c0100fee:	90                   	nop
c0100fef:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ff5:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100ffd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101001:	ee                   	out    %al,(%dx)
}
c0101002:	90                   	nop
c0101003:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101009:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010100d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101011:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101015:	ee                   	out    %al,(%dx)
}
c0101016:	90                   	nop
c0101017:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010101d:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101021:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101025:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101029:	ee                   	out    %al,(%dx)
}
c010102a:	90                   	nop
c010102b:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
c0101047:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c010104c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101052:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101056:	89 c2                	mov    %eax,%edx
c0101058:	ec                   	in     (%dx),%al
c0101059:	88 45 f1             	mov    %al,-0xf(%ebp)
c010105c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101062:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101066:	89 c2                	mov    %eax,%edx
c0101068:	ec                   	in     (%dx),%al
c0101069:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010106c:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101071:	85 c0                	test   %eax,%eax
c0101073:	74 0c                	je     c0101081 <serial_init+0xe8>
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
lpt_putc_sub(int c) {
c0101086:	55                   	push   %ebp
c0101087:	89 e5                	mov    %esp,%ebp
c0101089:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101093:	eb 08                	jmp    c010109d <lpt_putc_sub+0x17>
        delay();
c0101095:	e8 cc fd ff ff       	call   c0100e66 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d5:	ee                   	out    %al,(%dx)
}
c01010d6:	90                   	nop
c01010d7:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010dd:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
}
c01010ea:	90                   	nop
c01010eb:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010f1:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
lpt_putc(int c) {
c0101104:	55                   	push   %ebp
c0101105:	89 e5                	mov    %esp,%ebp
c0101107:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010110a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010110e:	74 0d                	je     c010111d <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101110:	8b 45 08             	mov    0x8(%ebp),%eax
c0101113:	89 04 24             	mov    %eax,(%esp)
c0101116:	e8 6b ff ff ff       	call   c0101086 <lpt_putc_sub>
    else {
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
cga_putc(int c) {
c0101146:	55                   	push   %ebp
c0101147:	89 e5                	mov    %esp,%ebp
c0101149:	83 ec 38             	sub    $0x38,%esp
c010114c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101157:	85 c0                	test   %eax,%eax
c0101159:	75 07                	jne    c0101162 <cga_putc+0x1c>
        c |= 0x0700;
c010115b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
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
    case '\b':
        if (crt_pos > 0) {
c0101185:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010118c:	85 c0                	test   %eax,%eax
c010118e:	0f 84 af 00 00 00    	je     c0101243 <cga_putc+0xfd>
            crt_pos --;
c0101194:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010119b:	48                   	dec    %eax
c010119c:	0f b7 c0             	movzwl %ax,%eax
c010119f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a8:	98                   	cwtl   
c01011a9:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ae:	98                   	cwtl   
c01011af:	83 c8 20             	or     $0x20,%eax
c01011b2:	98                   	cwtl   
c01011b3:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011b9:	0f b7 15 44 b4 11 c0 	movzwl 0xc011b444,%edx
c01011c0:	01 d2                	add    %edx,%edx
c01011c2:	01 ca                	add    %ecx,%edx
c01011c4:	0f b7 c0             	movzwl %ax,%eax
c01011c7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011ca:	eb 77                	jmp    c0101243 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011cc:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011d3:	83 c0 50             	add    $0x50,%eax
c01011d6:	0f b7 c0             	movzwl %ax,%eax
c01011d9:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011df:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c01011e6:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
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
c0101211:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101217:	eb 2b                	jmp    c0101244 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101219:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010121f:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101226:	8d 50 01             	lea    0x1(%eax),%edx
c0101229:	0f b7 d2             	movzwl %dx,%edx
c010122c:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
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
    if (crt_pos >= CRT_SIZE) {
c0101244:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101250:	76 5e                	jbe    c01012b0 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101252:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125d:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101269:	00 
c010126a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126e:	89 04 24             	mov    %eax,(%esp)
c0101271:	e8 c8 4b 00 00       	call   c0105e3e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127d:	eb 15                	jmp    c0101294 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c010127f:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c0101285:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101288:	01 c0                	add    %eax,%eax
c010128a:	01 d0                	add    %edx,%eax
c010128c:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101291:	ff 45 f4             	incl   -0xc(%ebp)
c0101294:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010129b:	7e e2                	jle    c010127f <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c010129d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012a4:	83 e8 50             	sub    $0x50,%eax
c01012a7:	0f b7 c0             	movzwl %ax,%eax
c01012aa:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012b0:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012b7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012bb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012c9:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012d0:	c1 e8 08             	shr    $0x8,%eax
c01012d3:	0f b7 c0             	movzwl %ax,%eax
c01012d6:	0f b6 c0             	movzbl %al,%eax
c01012d9:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012e0:	42                   	inc    %edx
c01012e1:	0f b7 d2             	movzwl %dx,%edx
c01012e4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012e8:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012f3:	ee                   	out    %al,(%dx)
}
c01012f4:	90                   	nop
    outb(addr_6845, 15);
c01012f5:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101304:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101308:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130c:	ee                   	out    %al,(%dx)
}
c010130d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010130e:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101315:	0f b6 c0             	movzbl %al,%eax
c0101318:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c010131f:	42                   	inc    %edx
c0101320:	0f b7 d2             	movzwl %dx,%edx
c0101323:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101327:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
serial_putc_sub(int c) {
c010133c:	55                   	push   %ebp
c010133d:	89 e5                	mov    %esp,%ebp
c010133f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101349:	eb 08                	jmp    c0101353 <serial_putc_sub+0x17>
        delay();
c010134b:	e8 16 fb ff ff       	call   c0100e66 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101350:	ff 45 fc             	incl   -0x4(%ebp)
c0101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
serial_putc(int c) {
c0101398:	55                   	push   %ebp
c0101399:	89 e5                	mov    %esp,%ebp
c010139b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010139e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a2:	74 0d                	je     c01013b1 <serial_putc+0x19>
        serial_putc_sub(c);
c01013a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a7:	89 04 24             	mov    %eax,(%esp)
c01013aa:	e8 8d ff ff ff       	call   c010133c <serial_putc_sub>
    else {
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
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013da:	55                   	push   %ebp
c01013db:	89 e5                	mov    %esp,%ebp
c01013dd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013e0:	eb 33                	jmp    c0101415 <cons_intr+0x3b>
        if (c != 0) {
c01013e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e6:	74 2d                	je     c0101415 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013e8:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013ed:	8d 50 01             	lea    0x1(%eax),%edx
c01013f0:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c01013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f9:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013ff:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101404:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101409:	75 0a                	jne    c0101415 <cons_intr+0x3b>
                cons.wpos = 0;
c010140b:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101412:	00 00 00 
    while ((c = (*proc)()) != -1) {
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
serial_proc_data(void) {
c0101429:	55                   	push   %ebp
c010142a:	89 e5                	mov    %esp,%ebp
c010142c:	83 ec 10             	sub    $0x10,%esp
c010142f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101435:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101439:	89 c2                	mov    %eax,%edx
c010143b:	ec                   	in     (%dx),%al
c010143c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010143f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101443:	0f b6 c0             	movzbl %al,%eax
c0101446:	83 e0 01             	and    $0x1,%eax
c0101449:	85 c0                	test   %eax,%eax
c010144b:	75 07                	jne    c0101454 <serial_proc_data+0x2b>
        return -1;
c010144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101452:	eb 2a                	jmp    c010147e <serial_proc_data+0x55>
c0101454:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
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
    if (c == 127) {
c010146e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101472:	75 07                	jne    c010147b <serial_proc_data+0x52>
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
void
serial_intr(void) {
c0101482:	55                   	push   %ebp
c0101483:	89 e5                	mov    %esp,%ebp
c0101485:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101488:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010148d:	85 c0                	test   %eax,%eax
c010148f:	74 0c                	je     c010149d <serial_intr+0x1b>
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
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a2:	55                   	push   %ebp
c01014a3:	89 e5                	mov    %esp,%ebp
c01014a5:	83 ec 38             	sub    $0x38,%esp
c01014a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014b1:	89 c2                	mov    %eax,%edx
c01014b3:	ec                   	in     (%dx),%al
c01014b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014bb:	0f b6 c0             	movzbl %al,%eax
c01014be:	83 e0 01             	and    $0x1,%eax
c01014c1:	85 c0                	test   %eax,%eax
c01014c3:	75 0a                	jne    c01014cf <kbd_proc_data+0x2d>
        return -1;
c01014c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014ca:	e9 56 01 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
c01014cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014d8:	89 c2                	mov    %eax,%edx
c01014da:	ec                   	in     (%dx),%al
c01014db:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014de:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014e5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014e9:	75 17                	jne    c0101502 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014eb:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014f0:	83 c8 40             	or     $0x40,%eax
c01014f3:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014f8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014fd:	e9 23 01 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101506:	84 c0                	test   %al,%al
c0101508:	79 45                	jns    c010154f <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010150a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
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
c0101529:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101530:	0c 40                	or     $0x40,%al
c0101532:	0f b6 c0             	movzbl %al,%eax
c0101535:	f7 d0                	not    %eax
c0101537:	89 c2                	mov    %eax,%edx
c0101539:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010153e:	21 d0                	and    %edx,%eax
c0101540:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101545:	b8 00 00 00 00       	mov    $0x0,%eax
c010154a:	e9 d6 00 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c010154f:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101554:	83 e0 40             	and    $0x40,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	74 11                	je     c010156c <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010155b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010155f:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101564:	83 e0 bf             	and    $0xffffffbf,%eax
c0101567:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c010156c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101570:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101577:	0f b6 d0             	movzbl %al,%edx
c010157a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010157f:	09 d0                	or     %edx,%eax
c0101581:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158a:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c0101591:	0f b6 d0             	movzbl %al,%edx
c0101594:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101599:	31 d0                	xor    %edx,%eax
c010159b:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a0:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015a5:	83 e0 03             	and    $0x3,%eax
c01015a8:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b3:	01 d0                	add    %edx,%eax
c01015b5:	0f b6 00             	movzbl (%eax),%eax
c01015b8:	0f b6 c0             	movzbl %al,%eax
c01015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015be:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015c3:	83 e0 08             	and    $0x8,%eax
c01015c6:	85 c0                	test   %eax,%eax
c01015c8:	74 22                	je     c01015ec <kbd_proc_data+0x14a>
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
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015ec:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015f1:	f7 d0                	not    %eax
c01015f3:	83 e0 06             	and    $0x6,%eax
c01015f6:	85 c0                	test   %eax,%eax
c01015f8:	75 28                	jne    c0101622 <kbd_proc_data+0x180>
c01015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101601:	75 1f                	jne    c0101622 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101603:	c7 04 24 cf 62 10 c0 	movl   $0xc01062cf,(%esp)
c010160a:	e8 56 ed ff ff       	call   c0100365 <cprintf>
c010160f:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101615:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
kbd_intr(void) {
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
kbd_init(void) {
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
void
cons_init(void) {
c010165c:	55                   	push   %ebp
c010165d:	89 e5                	mov    %esp,%ebp
c010165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101662:	e8 4a f8 ff ff       	call   c0100eb1 <cga_init>
    serial_init();
c0101667:	e8 2d f9 ff ff       	call   c0100f99 <serial_init>
    kbd_init();
c010166c:	e8 cf ff ff ff       	call   c0101640 <kbd_init>
    if (!serial_exists) {
c0101671:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101676:	85 c0                	test   %eax,%eax
c0101678:	75 0c                	jne    c0101686 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010167a:	c7 04 24 db 62 10 c0 	movl   $0xc01062db,(%esp)
c0101681:	e8 df ec ff ff       	call   c0100365 <cprintf>
    }
}
c0101686:	90                   	nop
c0101687:	89 ec                	mov    %ebp,%esp
c0101689:	5d                   	pop    %ebp
c010168a:	c3                   	ret    

c010168b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
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
int
cons_getc(void) {
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
        if (cons.rpos != cons.wpos) {
c01016e9:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c01016ef:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01016f4:	39 c2                	cmp    %eax,%edx
c01016f6:	74 31                	je     c0101729 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016f8:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016fd:	8d 50 01             	lea    0x1(%eax),%edx
c0101700:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101706:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101713:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101718:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171d:	75 0a                	jne    c0101729 <cons_getc+0x5f>
                cons.rpos = 0;
c010171f:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
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
void
intr_enable(void) {
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
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
void
intr_disable(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101746:	fa                   	cli    
}
c0101747:	90                   	nop
    cli();
}
c0101748:	90                   	nop
c0101749:	5d                   	pop    %ebp
c010174a:	c3                   	ret    

c010174b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010174b:	55                   	push   %ebp
c010174c:	89 e5                	mov    %esp,%ebp
c010174e:	83 ec 14             	sub    $0x14,%esp
c0101751:	8b 45 08             	mov    0x8(%ebp),%eax
c0101754:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101758:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010175b:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c0101761:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c0101766:	85 c0                	test   %eax,%eax
c0101768:	74 39                	je     c01017a3 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c010176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010176d:	0f b6 c0             	movzbl %al,%eax
c0101770:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101776:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
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

void
pic_enable(unsigned int irq) {
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
c01017c2:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
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
void
pic_init(void) {
c01017dd:	55                   	push   %ebp
c01017de:	89 e5                	mov    %esp,%ebp
c01017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017e3:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c01017ea:	00 00 00 
c01017ed:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017f3:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017fb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
}
c0101800:	90                   	nop
c0101801:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101807:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010180f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
}
c0101814:	90                   	nop
c0101815:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181b:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010181f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101823:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
}
c0101828:	90                   	nop
c0101829:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010182f:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101833:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101837:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
}
c010183c:	90                   	nop
c010183d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101843:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101847:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010184b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010184f:	ee                   	out    %al,(%dx)
}
c0101850:	90                   	nop
c0101851:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101857:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010185f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101863:	ee                   	out    %al,(%dx)
}
c0101864:	90                   	nop
c0101865:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c010186b:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101873:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101877:	ee                   	out    %al,(%dx)
}
c0101878:	90                   	nop
c0101879:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c010187f:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101883:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101887:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010188b:	ee                   	out    %al,(%dx)
}
c010188c:	90                   	nop
c010188d:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101893:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101897:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010189b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010189f:	ee                   	out    %al,(%dx)
}
c01018a0:	90                   	nop
c01018a1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018a7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018af:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018b3:	ee                   	out    %al,(%dx)
}
c01018b4:	90                   	nop
c01018b5:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018bb:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018c7:	ee                   	out    %al,(%dx)
}
c01018c8:	90                   	nop
c01018c9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018cf:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018db:	ee                   	out    %al,(%dx)
}
c01018dc:	90                   	nop
c01018dd:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018e3:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018eb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018ef:	ee                   	out    %al,(%dx)
}
c01018f0:	90                   	nop
c01018f1:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018f7:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01018ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101903:	ee                   	out    %al,(%dx)
}
c0101904:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101905:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c010190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101911:	74 0f                	je     c0101922 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101913:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
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
c0101935:	c7 04 24 00 63 10 c0 	movl   $0xc0106300,(%esp)
c010193c:	e8 24 ea ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101941:	c7 04 24 0a 63 10 c0 	movl   $0xc010630a,(%esp)
c0101948:	e8 18 ea ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c010194d:	c7 44 24 08 18 63 10 	movl   $0xc0106318,0x8(%esp)
c0101954:	c0 
c0101955:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
c010195c:	00 
c010195d:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
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
c010197e:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101985:	0f b7 d0             	movzwl %ax,%edx
c0101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198b:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c0101992:	c0 
c0101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101996:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c010199d:	c0 08 00 
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019aa:	c0 
c01019ab:	80 e2 e0             	and    $0xe0,%dl
c01019ae:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b8:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019bf:	c0 
c01019c0:	80 e2 1f             	and    $0x1f,%dl
c01019c3:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cd:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019d4:	c0 
c01019d5:	80 e2 f0             	and    $0xf0,%dl
c01019d8:	80 ca 0e             	or     $0xe,%dl
c01019db:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e5:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019ec:	c0 
c01019ed:	80 e2 ef             	and    $0xef,%dl
c01019f0:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fa:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101a01:	c0 
c0101a02:	80 e2 9f             	and    $0x9f,%dl
c0101a05:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0f:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101a16:	c0 
c0101a17:	80 ca 80             	or     $0x80,%dl
c0101a1a:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a24:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101a2b:	c1 e8 10             	shr    $0x10,%eax
c0101a2e:	0f b7 d0             	movzwl %ax,%edx
c0101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a34:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c0101a3b:	c0 
    for (int i = 0; i < 256; i++)
c0101a3c:	ff 45 fc             	incl   -0x4(%ebp)
c0101a3f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a46:	0f 8e 2f ff ff ff    	jle    c010197b <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a4c:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101a51:	0f b7 c0             	movzwl %ax,%eax
c0101a54:	66 a3 48 ba 11 c0    	mov    %ax,0xc011ba48
c0101a5a:	66 c7 05 4a ba 11 c0 	movw   $0x8,0xc011ba4a
c0101a61:	08 00 
c0101a63:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a6a:	24 e0                	and    $0xe0,%al
c0101a6c:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a71:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a78:	24 1f                	and    $0x1f,%al
c0101a7a:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a7f:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a86:	24 f0                	and    $0xf0,%al
c0101a88:	0c 0e                	or     $0xe,%al
c0101a8a:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a8f:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a96:	24 ef                	and    $0xef,%al
c0101a98:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a9d:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101aa4:	0c 60                	or     $0x60,%al
c0101aa6:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101aab:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101ab2:	0c 80                	or     $0x80,%al
c0101ab4:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101ab9:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101abe:	c1 e8 10             	shr    $0x10,%eax
c0101ac1:	0f b7 c0             	movzwl %ax,%eax
c0101ac4:	66 a3 4e ba 11 c0    	mov    %ax,0xc011ba4e
c0101aca:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
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
c0101aeb:	8b 04 85 80 66 10 c0 	mov    -0x3fef9980(,%eax,4),%eax
c0101af2:	eb 18                	jmp    c0101b0c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
c0101af4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101af8:	7e 0d                	jle    c0101b07 <trapname+0x2a>
c0101afa:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101afe:	7f 07                	jg     c0101b07 <trapname+0x2a>
    {
        return "Hardware Interrupt";
c0101b00:	b8 3f 63 10 c0       	mov    $0xc010633f,%eax
c0101b05:	eb 05                	jmp    c0101b0c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b07:	b8 52 63 10 c0       	mov    $0xc0106352,%eax
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
c0101b30:	c7 04 24 93 63 10 c0 	movl   $0xc0106393,(%esp)
c0101b37:	e8 29 e8 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3f:	89 04 24             	mov    %eax,(%esp)
c0101b42:	e8 8f 01 00 00       	call   c0101cd6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b52:	c7 04 24 a4 63 10 c0 	movl   $0xc01063a4,(%esp)
c0101b59:	e8 07 e8 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b61:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b69:	c7 04 24 b7 63 10 c0 	movl   $0xc01063b7,(%esp)
c0101b70:	e8 f0 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c0101b87:	e8 d9 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b97:	c7 04 24 dd 63 10 c0 	movl   $0xc01063dd,(%esp)
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
c0101bbf:	c7 04 24 f0 63 10 c0 	movl   $0xc01063f0,(%esp)
c0101bc6:	e8 9a e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 34             	mov    0x34(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0101bdc:	e8 84 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 38             	mov    0x38(%eax),%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 11 64 10 c0 	movl   $0xc0106411,(%esp)
c0101bf2:	e8 6e e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c02:	c7 04 24 20 64 10 c0 	movl   $0xc0106420,(%esp)
c0101c09:	e8 57 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c11:	8b 40 40             	mov    0x40(%eax),%eax
c0101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c18:	c7 04 24 33 64 10 c0 	movl   $0xc0106433,(%esp)
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
c0101c46:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c4d:	85 c0                	test   %eax,%eax
c0101c4f:	74 1a                	je     c0101c6b <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
c0101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c54:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5f:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
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
c0101c89:	c7 04 24 46 64 10 c0 	movl   $0xc0106446,(%esp)
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
c0101cae:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
c0101cb5:	e8 ab e6 ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbd:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc5:	c7 04 24 5e 64 10 c0 	movl   $0xc010645e,(%esp)
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
c0101ce5:	c7 04 24 71 64 10 c0 	movl   $0xc0106471,(%esp)
c0101cec:	e8 74 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf4:	8b 40 04             	mov    0x4(%eax),%eax
c0101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfb:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
c0101d02:	e8 5e e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0a:	8b 40 08             	mov    0x8(%eax),%eax
c0101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d11:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101d18:	e8 48 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d20:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d27:	c7 04 24 9e 64 10 c0 	movl   $0xc010649e,(%esp)
c0101d2e:	e8 32 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d36:	8b 40 10             	mov    0x10(%eax),%eax
c0101d39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3d:	c7 04 24 ad 64 10 c0 	movl   $0xc01064ad,(%esp)
c0101d44:	e8 1c e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4c:	8b 40 14             	mov    0x14(%eax),%eax
c0101d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d53:	c7 04 24 bc 64 10 c0 	movl   $0xc01064bc,(%esp)
c0101d5a:	e8 06 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d62:	8b 40 18             	mov    0x18(%eax),%eax
c0101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d69:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0101d70:	e8 f0 e5 ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7f:	c7 04 24 da 64 10 c0 	movl   $0xc01064da,(%esp)
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
c0101def:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101df4:	40                   	inc    %eax
c0101df5:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks == TICK_NUM)
c0101dfa:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101dff:	83 f8 64             	cmp    $0x64,%eax
c0101e02:	0f 85 47 01 00 00    	jne    c0101f4f <trap_dispatch+0x1bf>
        {
            ticks = 0;
c0101e08:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
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
c0101e34:	c7 04 24 e9 64 10 c0 	movl   $0xc01064e9,(%esp)
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
c0101e5d:	c7 04 24 fb 64 10 c0 	movl   $0xc01064fb,(%esp)
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
c0101f30:	c7 44 24 08 0a 65 10 	movl   $0xc010650a,0x8(%esp)
c0101f37:	c0 
c0101f38:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0101f3f:	00 
c0101f40:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
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
c0102a08:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
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

c0102a36 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102a36:	55                   	push   %ebp
c0102a37:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3c:	8b 00                	mov    (%eax),%eax
}
c0102a3e:	5d                   	pop    %ebp
c0102a3f:	c3                   	ret    

c0102a40 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a40:	55                   	push   %ebp
c0102a41:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a49:	89 10                	mov    %edx,(%eax)
}
c0102a4b:	90                   	nop
c0102a4c:	5d                   	pop    %ebp
c0102a4d:	c3                   	ret    

c0102a4e <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
c0102a4e:	55                   	push   %ebp
c0102a4f:	89 e5                	mov    %esp,%ebp
c0102a51:	83 ec 10             	sub    $0x10,%esp
c0102a54:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a61:	89 50 04             	mov    %edx,0x4(%eax)
c0102a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a67:	8b 50 04             	mov    0x4(%eax),%edx
c0102a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a6d:	89 10                	mov    %edx,(%eax)
}
c0102a6f:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0102a70:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102a77:	00 00 00 
}
c0102a7a:	90                   	nop
c0102a7b:	89 ec                	mov    %ebp,%esp
c0102a7d:	5d                   	pop    %ebp
c0102a7e:	c3                   	ret    

c0102a7f <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
c0102a7f:	55                   	push   %ebp
c0102a80:	89 e5                	mov    %esp,%ebp
c0102a82:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a89:	75 24                	jne    c0102aaf <default_init_memmap+0x30>
c0102a8b:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102a92:	c0 
c0102a93:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102a9a:	c0 
c0102a9b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102aa2:	00 
c0102aa3:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102aaa:	e8 3b e2 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102ab5:	eb 7b                	jmp    c0102b32 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
c0102ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aba:	83 c0 04             	add    $0x4,%eax
c0102abd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102acd:	0f a3 10             	bt     %edx,(%eax)
c0102ad0:	19 c0                	sbb    %eax,%eax
c0102ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102ad9:	0f 95 c0             	setne  %al
c0102adc:	0f b6 c0             	movzbl %al,%eax
c0102adf:	85 c0                	test   %eax,%eax
c0102ae1:	75 24                	jne    c0102b07 <default_init_memmap+0x88>
c0102ae3:	c7 44 24 0c 01 67 10 	movl   $0xc0106701,0xc(%esp)
c0102aea:	c0 
c0102aeb:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102af2:	c0 
c0102af3:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102afa:	00 
c0102afb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102b02:	e8 e3 e1 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c0102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
c0102b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
c0102b1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102b22:	00 
c0102b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b26:	89 04 24             	mov    %eax,(%esp)
c0102b29:	e8 12 ff ff ff       	call   c0102a40 <set_page_ref>
    for (; p != base + n; p++)
c0102b2e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102b32:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b35:	89 d0                	mov    %edx,%eax
c0102b37:	c1 e0 02             	shl    $0x2,%eax
c0102b3a:	01 d0                	add    %edx,%eax
c0102b3c:	c1 e0 02             	shl    $0x2,%eax
c0102b3f:	89 c2                	mov    %eax,%edx
c0102b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b44:	01 d0                	add    %edx,%eax
c0102b46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102b49:	0f 85 68 ff ff ff    	jne    c0102ab7 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
c0102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b52:	83 c0 04             	add    $0x4,%eax
c0102b55:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b62:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b65:	0f ab 10             	bts    %edx,(%eax)
}
c0102b68:	90                   	nop
    base->property = n;
c0102b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b6f:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102b72:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102b78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b7b:	01 d0                	add    %edx,%eax
c0102b7d:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
c0102b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b85:	83 c0 0c             	add    $0xc,%eax
c0102b88:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c0102b8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b95:	8b 00                	mov    (%eax),%eax
c0102b97:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ba3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ba6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ba9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102bac:	89 10                	mov    %edx,(%eax)
c0102bae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bb1:	8b 10                	mov    (%eax),%edx
c0102bb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bb6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bbc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102bbf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bc5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bc8:	89 10                	mov    %edx,(%eax)
}
c0102bca:	90                   	nop
}
c0102bcb:	90                   	nop
}
c0102bcc:	90                   	nop
c0102bcd:	89 ec                	mov    %ebp,%esp
c0102bcf:	5d                   	pop    %ebp
c0102bd0:	c3                   	ret    

c0102bd1 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0102bd1:	55                   	push   %ebp
c0102bd2:	89 e5                	mov    %esp,%ebp
c0102bd4:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bdb:	75 24                	jne    c0102c01 <default_alloc_pages+0x30>
c0102bdd:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102be4:	c0 
c0102be5:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102bec:	c0 
c0102bed:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0102bf4:	00 
c0102bf5:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102bfc:	e8 e9 e0 ff ff       	call   c0100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
c0102c01:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102c06:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c09:	76 0a                	jbe    c0102c15 <default_alloc_pages+0x44>
    {
        return NULL;
c0102c0b:	b8 00 00 00 00       	mov    $0x0,%eax
c0102c10:	e9 43 01 00 00       	jmp    c0102d58 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c0102c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102c1c:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0102c23:	eb 1c                	jmp    c0102c41 <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
c0102c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c28:	83 e8 0c             	sub    $0xc,%eax
c0102c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c0102c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c31:	8b 40 08             	mov    0x8(%eax),%eax
c0102c34:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c37:	77 08                	ja     c0102c41 <default_alloc_pages+0x70>
        {
            page = p;
c0102c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102c3f:	eb 18                	jmp    c0102c59 <default_alloc_pages+0x88>
c0102c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c4a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c50:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102c57:	75 cc                	jne    c0102c25 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c0102c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c5d:	0f 84 f2 00 00 00    	je     c0102d55 <default_alloc_pages+0x184>
    {
        if (page->property > n)
c0102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c66:	8b 40 08             	mov    0x8(%eax),%eax
c0102c69:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c6c:	0f 83 8f 00 00 00    	jae    c0102d01 <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
c0102c72:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c75:	89 d0                	mov    %edx,%eax
c0102c77:	c1 e0 02             	shl    $0x2,%eax
c0102c7a:	01 d0                	add    %edx,%eax
c0102c7c:	c1 e0 02             	shl    $0x2,%eax
c0102c7f:	89 c2                	mov    %eax,%edx
c0102c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c84:	01 d0                	add    %edx,%eax
c0102c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c8c:	8b 40 08             	mov    0x8(%eax),%eax
c0102c8f:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c92:	89 c2                	mov    %eax,%edx
c0102c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c97:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c9d:	83 c0 0c             	add    $0xc,%eax
c0102ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102ca3:	83 c2 0c             	add    $0xc,%edx
c0102ca6:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102ca9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102cac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102caf:	8b 40 04             	mov    0x4(%eax),%eax
c0102cb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cb5:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102cb8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cbb:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102cbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0102cc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cc7:	89 10                	mov    %edx,(%eax)
c0102cc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ccc:	8b 10                	mov    (%eax),%edx
c0102cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cd1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102cda:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cdd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ce0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ce3:	89 10                	mov    %edx,(%eax)
}
c0102ce5:	90                   	nop
}
c0102ce6:	90                   	nop
            SetPageProperty(p);
c0102ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cea:	83 c0 04             	add    $0x4,%eax
c0102ced:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102cf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cfd:	0f ab 10             	bts    %edx,(%eax)
}
c0102d00:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
c0102d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d04:	83 c0 0c             	add    $0xc,%eax
c0102d07:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d0d:	8b 40 04             	mov    0x4(%eax),%eax
c0102d10:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d13:	8b 12                	mov    (%edx),%edx
c0102d15:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d18:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d1b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d1e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d21:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d27:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d2a:	89 10                	mov    %edx,(%eax)
}
c0102d2c:	90                   	nop
}
c0102d2d:	90                   	nop
        nr_free -= n;
c0102d2e:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102d33:	2b 45 08             	sub    0x8(%ebp),%eax
c0102d36:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d3e:	83 c0 04             	add    $0x4,%eax
c0102d41:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d51:	0f b3 10             	btr    %edx,(%eax)
}
c0102d54:	90                   	nop
    }
    return page;
c0102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d58:	89 ec                	mov    %ebp,%esp
c0102d5a:	5d                   	pop    %ebp
c0102d5b:	c3                   	ret    

c0102d5c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0102d5c:	55                   	push   %ebp
c0102d5d:	89 e5                	mov    %esp,%ebp
c0102d5f:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d69:	75 24                	jne    c0102d8f <default_free_pages+0x33>
c0102d6b:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102d72:	c0 
c0102d73:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102d7a:	c0 
c0102d7b:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102d82:	00 
c0102d83:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102d8a:	e8 5b df ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102d95:	e9 9d 00 00 00       	jmp    c0102e37 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0102d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9d:	83 c0 04             	add    $0x4,%eax
c0102da0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dad:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102db0:	0f a3 10             	bt     %edx,(%eax)
c0102db3:	19 c0                	sbb    %eax,%eax
c0102db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dbc:	0f 95 c0             	setne  %al
c0102dbf:	0f b6 c0             	movzbl %al,%eax
c0102dc2:	85 c0                	test   %eax,%eax
c0102dc4:	75 2c                	jne    c0102df2 <default_free_pages+0x96>
c0102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc9:	83 c0 04             	add    $0x4,%eax
c0102dcc:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102dd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102dd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102ddc:	0f a3 10             	bt     %edx,(%eax)
c0102ddf:	19 c0                	sbb    %eax,%eax
c0102de1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102de4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102de8:	0f 95 c0             	setne  %al
c0102deb:	0f b6 c0             	movzbl %al,%eax
c0102dee:	85 c0                	test   %eax,%eax
c0102df0:	74 24                	je     c0102e16 <default_free_pages+0xba>
c0102df2:	c7 44 24 0c 14 67 10 	movl   $0xc0106714,0xc(%esp)
c0102df9:	c0 
c0102dfa:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102e01:	c0 
c0102e02:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0102e09:	00 
c0102e0a:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102e11:	e8 d4 de ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c0102e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102e20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e27:	00 
c0102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2b:	89 04 24             	mov    %eax,(%esp)
c0102e2e:	e8 0d fc ff ff       	call   c0102a40 <set_page_ref>
    for (; p != base + n; p++)
c0102e33:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102e37:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e3a:	89 d0                	mov    %edx,%eax
c0102e3c:	c1 e0 02             	shl    $0x2,%eax
c0102e3f:	01 d0                	add    %edx,%eax
c0102e41:	c1 e0 02             	shl    $0x2,%eax
c0102e44:	89 c2                	mov    %eax,%edx
c0102e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e49:	01 d0                	add    %edx,%eax
c0102e4b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e4e:	0f 85 46 ff ff ff    	jne    c0102d9a <default_free_pages+0x3e>
    }
    base->property = n;
c0102e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e5a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e60:	83 c0 04             	add    $0x4,%eax
c0102e63:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102e6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e70:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e73:	0f ab 10             	bts    %edx,(%eax)
}
c0102e76:	90                   	nop
c0102e77:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102e7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102e81:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
c0102e87:	e9 0e 01 00 00       	jmp    c0102f9a <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
c0102e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e8f:	83 e8 0c             	sub    $0xc,%eax
c0102e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e98:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102e9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e9e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
c0102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea7:	8b 50 08             	mov    0x8(%eax),%edx
c0102eaa:	89 d0                	mov    %edx,%eax
c0102eac:	c1 e0 02             	shl    $0x2,%eax
c0102eaf:	01 d0                	add    %edx,%eax
c0102eb1:	c1 e0 02             	shl    $0x2,%eax
c0102eb4:	89 c2                	mov    %eax,%edx
c0102eb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eb9:	01 d0                	add    %edx,%eax
c0102ebb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ebe:	75 5d                	jne    c0102f1d <default_free_pages+0x1c1>
        {
            base->property += p->property;
c0102ec0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec3:	8b 50 08             	mov    0x8(%eax),%edx
c0102ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ec9:	8b 40 08             	mov    0x8(%eax),%eax
c0102ecc:	01 c2                	add    %eax,%edx
c0102ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ed1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed7:	83 c0 04             	add    $0x4,%eax
c0102eda:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102ee1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ee4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ee7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102eea:	0f b3 10             	btr    %edx,(%eax)
}
c0102eed:	90                   	nop
            list_del(&(p->page_link));
c0102eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ef1:	83 c0 0c             	add    $0xc,%eax
c0102ef4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102ef7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102efa:	8b 40 04             	mov    0x4(%eax),%eax
c0102efd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102f00:	8b 12                	mov    (%edx),%edx
c0102f02:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102f05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102f08:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102f0b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102f0e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f11:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f14:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102f17:	89 10                	mov    %edx,(%eax)
}
c0102f19:	90                   	nop
}
c0102f1a:	90                   	nop
c0102f1b:	eb 7d                	jmp    c0102f9a <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
c0102f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f20:	8b 50 08             	mov    0x8(%eax),%edx
c0102f23:	89 d0                	mov    %edx,%eax
c0102f25:	c1 e0 02             	shl    $0x2,%eax
c0102f28:	01 d0                	add    %edx,%eax
c0102f2a:	c1 e0 02             	shl    $0x2,%eax
c0102f2d:	89 c2                	mov    %eax,%edx
c0102f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f32:	01 d0                	add    %edx,%eax
c0102f34:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102f37:	75 61                	jne    c0102f9a <default_free_pages+0x23e>
        {
            p->property += base->property;
c0102f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f3c:	8b 50 08             	mov    0x8(%eax),%edx
c0102f3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f42:	8b 40 08             	mov    0x8(%eax),%eax
c0102f45:	01 c2                	add    %eax,%edx
c0102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f50:	83 c0 04             	add    $0x4,%eax
c0102f53:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102f5a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f60:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f63:	0f b3 10             	btr    %edx,(%eax)
}
c0102f66:	90                   	nop
            base = p;
c0102f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f6a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f70:	83 c0 0c             	add    $0xc,%eax
c0102f73:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f76:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f79:	8b 40 04             	mov    0x4(%eax),%eax
c0102f7c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102f7f:	8b 12                	mov    (%edx),%edx
c0102f81:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102f84:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102f87:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f8a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f8d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f90:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f93:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102f96:	89 10                	mov    %edx,(%eax)
}
c0102f98:	90                   	nop
}
c0102f99:	90                   	nop
    while (le != &free_list)
c0102f9a:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102fa1:	0f 85 e5 fe ff ff    	jne    c0102e8c <default_free_pages+0x130>
        }
    }
    le = &free_list;
c0102fa7:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
c0102fae:	eb 25                	jmp    c0102fd5 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
c0102fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb3:	83 e8 0c             	sub    $0xc,%eax
c0102fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
c0102fb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fbc:	8b 50 08             	mov    0x8(%eax),%edx
c0102fbf:	89 d0                	mov    %edx,%eax
c0102fc1:	c1 e0 02             	shl    $0x2,%eax
c0102fc4:	01 d0                	add    %edx,%eax
c0102fc6:	c1 e0 02             	shl    $0x2,%eax
c0102fc9:	89 c2                	mov    %eax,%edx
c0102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fce:	01 d0                	add    %edx,%eax
c0102fd0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102fd3:	73 1a                	jae    c0102fef <default_free_pages+0x293>
c0102fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fd8:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0102fdb:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102fde:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fe4:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102feb:	75 c3                	jne    c0102fb0 <default_free_pages+0x254>
c0102fed:	eb 01                	jmp    c0102ff0 <default_free_pages+0x294>
        {
            break;
c0102fef:	90                   	nop
        }
    }
    nr_free += n;
c0102ff0:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ff9:	01 d0                	add    %edx,%eax
c0102ffb:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(le, &(base->page_link));
c0103000:	8b 45 08             	mov    0x8(%ebp),%eax
c0103003:	8d 50 0c             	lea    0xc(%eax),%edx
c0103006:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103009:	89 45 98             	mov    %eax,-0x68(%ebp)
c010300c:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010300f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103012:	8b 00                	mov    (%eax),%eax
c0103014:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103017:	89 55 90             	mov    %edx,-0x70(%ebp)
c010301a:	89 45 8c             	mov    %eax,-0x74(%ebp)
c010301d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103020:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
c0103023:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103026:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103029:	89 10                	mov    %edx,(%eax)
c010302b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010302e:	8b 10                	mov    (%eax),%edx
c0103030:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103033:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103036:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103039:	8b 55 88             	mov    -0x78(%ebp),%edx
c010303c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010303f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103042:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103045:	89 10                	mov    %edx,(%eax)
}
c0103047:	90                   	nop
}
c0103048:	90                   	nop
}
c0103049:	90                   	nop
c010304a:	89 ec                	mov    %ebp,%esp
c010304c:	5d                   	pop    %ebp
c010304d:	c3                   	ret    

c010304e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c010304e:	55                   	push   %ebp
c010304f:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103051:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0103056:	5d                   	pop    %ebp
c0103057:	c3                   	ret    

c0103058 <basic_check>:

static void
basic_check(void)
{
c0103058:	55                   	push   %ebp
c0103059:	89 e5                	mov    %esp,%ebp
c010305b:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010305e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103065:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103068:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010306e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103078:	e8 df 0e 00 00       	call   c0103f5c <alloc_pages>
c010307d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103080:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103084:	75 24                	jne    c01030aa <basic_check+0x52>
c0103086:	c7 44 24 0c 39 67 10 	movl   $0xc0106739,0xc(%esp)
c010308d:	c0 
c010308e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103095:	c0 
c0103096:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010309d:	00 
c010309e:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01030a5:	e8 40 dc ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030b1:	e8 a6 0e 00 00       	call   c0103f5c <alloc_pages>
c01030b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030bd:	75 24                	jne    c01030e3 <basic_check+0x8b>
c01030bf:	c7 44 24 0c 55 67 10 	movl   $0xc0106755,0xc(%esp)
c01030c6:	c0 
c01030c7:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01030ce:	c0 
c01030cf:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01030d6:	00 
c01030d7:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01030de:	e8 07 dc ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030ea:	e8 6d 0e 00 00       	call   c0103f5c <alloc_pages>
c01030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030f6:	75 24                	jne    c010311c <basic_check+0xc4>
c01030f8:	c7 44 24 0c 71 67 10 	movl   $0xc0106771,0xc(%esp)
c01030ff:	c0 
c0103100:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103107:	c0 
c0103108:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010310f:	00 
c0103110:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103117:	e8 ce db ff ff       	call   c0100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010311c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010311f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103122:	74 10                	je     c0103134 <basic_check+0xdc>
c0103124:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103127:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010312a:	74 08                	je     c0103134 <basic_check+0xdc>
c010312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103132:	75 24                	jne    c0103158 <basic_check+0x100>
c0103134:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c010313b:	c0 
c010313c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103143:	c0 
c0103144:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010314b:	00 
c010314c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103153:	e8 92 db ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103158:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010315b:	89 04 24             	mov    %eax,(%esp)
c010315e:	e8 d3 f8 ff ff       	call   c0102a36 <page_ref>
c0103163:	85 c0                	test   %eax,%eax
c0103165:	75 1e                	jne    c0103185 <basic_check+0x12d>
c0103167:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010316a:	89 04 24             	mov    %eax,(%esp)
c010316d:	e8 c4 f8 ff ff       	call   c0102a36 <page_ref>
c0103172:	85 c0                	test   %eax,%eax
c0103174:	75 0f                	jne    c0103185 <basic_check+0x12d>
c0103176:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103179:	89 04 24             	mov    %eax,(%esp)
c010317c:	e8 b5 f8 ff ff       	call   c0102a36 <page_ref>
c0103181:	85 c0                	test   %eax,%eax
c0103183:	74 24                	je     c01031a9 <basic_check+0x151>
c0103185:	c7 44 24 0c b4 67 10 	movl   $0xc01067b4,0xc(%esp)
c010318c:	c0 
c010318d:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103194:	c0 
c0103195:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010319c:	00 
c010319d:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031a4:	e8 41 db ff ff       	call   c0100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031ac:	89 04 24             	mov    %eax,(%esp)
c01031af:	e8 6a f8 ff ff       	call   c0102a1e <page2pa>
c01031b4:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01031ba:	c1 e2 0c             	shl    $0xc,%edx
c01031bd:	39 d0                	cmp    %edx,%eax
c01031bf:	72 24                	jb     c01031e5 <basic_check+0x18d>
c01031c1:	c7 44 24 0c f0 67 10 	movl   $0xc01067f0,0xc(%esp)
c01031c8:	c0 
c01031c9:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01031d0:	c0 
c01031d1:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01031d8:	00 
c01031d9:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031e0:	e8 05 db ff ff       	call   c0100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e8:	89 04 24             	mov    %eax,(%esp)
c01031eb:	e8 2e f8 ff ff       	call   c0102a1e <page2pa>
c01031f0:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01031f6:	c1 e2 0c             	shl    $0xc,%edx
c01031f9:	39 d0                	cmp    %edx,%eax
c01031fb:	72 24                	jb     c0103221 <basic_check+0x1c9>
c01031fd:	c7 44 24 0c 0d 68 10 	movl   $0xc010680d,0xc(%esp)
c0103204:	c0 
c0103205:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010320c:	c0 
c010320d:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103214:	00 
c0103215:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010321c:	e8 c9 da ff ff       	call   c0100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103221:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103224:	89 04 24             	mov    %eax,(%esp)
c0103227:	e8 f2 f7 ff ff       	call   c0102a1e <page2pa>
c010322c:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103232:	c1 e2 0c             	shl    $0xc,%edx
c0103235:	39 d0                	cmp    %edx,%eax
c0103237:	72 24                	jb     c010325d <basic_check+0x205>
c0103239:	c7 44 24 0c 2a 68 10 	movl   $0xc010682a,0xc(%esp)
c0103240:	c0 
c0103241:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103248:	c0 
c0103249:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103250:	00 
c0103251:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103258:	e8 8d da ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c010325d:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103262:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103268:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010326b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010326e:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103275:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103278:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010327b:	89 50 04             	mov    %edx,0x4(%eax)
c010327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103281:	8b 50 04             	mov    0x4(%eax),%edx
c0103284:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103287:	89 10                	mov    %edx,(%eax)
}
c0103289:	90                   	nop
c010328a:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c0103291:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103294:	8b 40 04             	mov    0x4(%eax),%eax
c0103297:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010329a:	0f 94 c0             	sete   %al
c010329d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032a0:	85 c0                	test   %eax,%eax
c01032a2:	75 24                	jne    c01032c8 <basic_check+0x270>
c01032a4:	c7 44 24 0c 47 68 10 	movl   $0xc0106847,0xc(%esp)
c01032ab:	c0 
c01032ac:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01032b3:	c0 
c01032b4:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01032bb:	00 
c01032bc:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01032c3:	e8 22 da ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c01032c8:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01032cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032d0:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01032d7:	00 00 00 

    assert(alloc_page() == NULL);
c01032da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032e1:	e8 76 0c 00 00       	call   c0103f5c <alloc_pages>
c01032e6:	85 c0                	test   %eax,%eax
c01032e8:	74 24                	je     c010330e <basic_check+0x2b6>
c01032ea:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c01032f1:	c0 
c01032f2:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01032f9:	c0 
c01032fa:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103301:	00 
c0103302:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103309:	e8 dc d9 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c010330e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103315:	00 
c0103316:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103319:	89 04 24             	mov    %eax,(%esp)
c010331c:	e8 75 0c 00 00       	call   c0103f96 <free_pages>
    free_page(p1);
c0103321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103328:	00 
c0103329:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010332c:	89 04 24             	mov    %eax,(%esp)
c010332f:	e8 62 0c 00 00       	call   c0103f96 <free_pages>
    free_page(p2);
c0103334:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010333b:	00 
c010333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333f:	89 04 24             	mov    %eax,(%esp)
c0103342:	e8 4f 0c 00 00       	call   c0103f96 <free_pages>
    assert(nr_free == 3);
c0103347:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010334c:	83 f8 03             	cmp    $0x3,%eax
c010334f:	74 24                	je     c0103375 <basic_check+0x31d>
c0103351:	c7 44 24 0c 73 68 10 	movl   $0xc0106873,0xc(%esp)
c0103358:	c0 
c0103359:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103360:	c0 
c0103361:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103368:	00 
c0103369:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103370:	e8 75 d9 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103375:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010337c:	e8 db 0b 00 00       	call   c0103f5c <alloc_pages>
c0103381:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103384:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103388:	75 24                	jne    c01033ae <basic_check+0x356>
c010338a:	c7 44 24 0c 39 67 10 	movl   $0xc0106739,0xc(%esp)
c0103391:	c0 
c0103392:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103399:	c0 
c010339a:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01033a1:	00 
c01033a2:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01033a9:	e8 3c d9 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033b5:	e8 a2 0b 00 00       	call   c0103f5c <alloc_pages>
c01033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033c1:	75 24                	jne    c01033e7 <basic_check+0x38f>
c01033c3:	c7 44 24 0c 55 67 10 	movl   $0xc0106755,0xc(%esp)
c01033ca:	c0 
c01033cb:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01033d2:	c0 
c01033d3:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01033da:	00 
c01033db:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01033e2:	e8 03 d9 ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033ee:	e8 69 0b 00 00       	call   c0103f5c <alloc_pages>
c01033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033fa:	75 24                	jne    c0103420 <basic_check+0x3c8>
c01033fc:	c7 44 24 0c 71 67 10 	movl   $0xc0106771,0xc(%esp)
c0103403:	c0 
c0103404:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010340b:	c0 
c010340c:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103413:	00 
c0103414:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010341b:	e8 ca d8 ff ff       	call   c0100cea <__panic>

    assert(alloc_page() == NULL);
c0103420:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103427:	e8 30 0b 00 00       	call   c0103f5c <alloc_pages>
c010342c:	85 c0                	test   %eax,%eax
c010342e:	74 24                	je     c0103454 <basic_check+0x3fc>
c0103430:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c0103437:	c0 
c0103438:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010343f:	c0 
c0103440:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103447:	00 
c0103448:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010344f:	e8 96 d8 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103454:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010345b:	00 
c010345c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010345f:	89 04 24             	mov    %eax,(%esp)
c0103462:	e8 2f 0b 00 00       	call   c0103f96 <free_pages>
c0103467:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c010346e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103471:	8b 40 04             	mov    0x4(%eax),%eax
c0103474:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103477:	0f 94 c0             	sete   %al
c010347a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010347d:	85 c0                	test   %eax,%eax
c010347f:	74 24                	je     c01034a5 <basic_check+0x44d>
c0103481:	c7 44 24 0c 80 68 10 	movl   $0xc0106880,0xc(%esp)
c0103488:	c0 
c0103489:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103490:	c0 
c0103491:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103498:	00 
c0103499:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01034a0:	e8 45 d8 ff ff       	call   c0100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034ac:	e8 ab 0a 00 00       	call   c0103f5c <alloc_pages>
c01034b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034ba:	74 24                	je     c01034e0 <basic_check+0x488>
c01034bc:	c7 44 24 0c 98 68 10 	movl   $0xc0106898,0xc(%esp)
c01034c3:	c0 
c01034c4:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01034cb:	c0 
c01034cc:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01034d3:	00 
c01034d4:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01034db:	e8 0a d8 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c01034e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034e7:	e8 70 0a 00 00       	call   c0103f5c <alloc_pages>
c01034ec:	85 c0                	test   %eax,%eax
c01034ee:	74 24                	je     c0103514 <basic_check+0x4bc>
c01034f0:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c01034f7:	c0 
c01034f8:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01034ff:	c0 
c0103500:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103507:	00 
c0103508:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010350f:	e8 d6 d7 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0103514:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103519:	85 c0                	test   %eax,%eax
c010351b:	74 24                	je     c0103541 <basic_check+0x4e9>
c010351d:	c7 44 24 0c b1 68 10 	movl   $0xc01068b1,0xc(%esp)
c0103524:	c0 
c0103525:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010352c:	c0 
c010352d:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103534:	00 
c0103535:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010353c:	e8 a9 d7 ff ff       	call   c0100cea <__panic>
    free_list = free_list_store;
c0103541:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103544:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103547:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c010354c:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c0103552:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103555:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c010355a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103561:	00 
c0103562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103565:	89 04 24             	mov    %eax,(%esp)
c0103568:	e8 29 0a 00 00       	call   c0103f96 <free_pages>
    free_page(p1);
c010356d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103574:	00 
c0103575:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103578:	89 04 24             	mov    %eax,(%esp)
c010357b:	e8 16 0a 00 00       	call   c0103f96 <free_pages>
    free_page(p2);
c0103580:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103587:	00 
c0103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358b:	89 04 24             	mov    %eax,(%esp)
c010358e:	e8 03 0a 00 00       	call   c0103f96 <free_pages>
}
c0103593:	90                   	nop
c0103594:	89 ec                	mov    %ebp,%esp
c0103596:	5d                   	pop    %ebp
c0103597:	c3                   	ret    

c0103598 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c0103598:	55                   	push   %ebp
c0103599:	89 e5                	mov    %esp,%ebp
c010359b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01035a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035af:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c01035b6:	eb 6a                	jmp    c0103622 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c01035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035bb:	83 e8 0c             	sub    $0xc,%eax
c01035be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01035c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035c4:	83 c0 04             	add    $0x4,%eax
c01035c7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035d4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035d7:	0f a3 10             	bt     %edx,(%eax)
c01035da:	19 c0                	sbb    %eax,%eax
c01035dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035e3:	0f 95 c0             	setne  %al
c01035e6:	0f b6 c0             	movzbl %al,%eax
c01035e9:	85 c0                	test   %eax,%eax
c01035eb:	75 24                	jne    c0103611 <default_check+0x79>
c01035ed:	c7 44 24 0c be 68 10 	movl   $0xc01068be,0xc(%esp)
c01035f4:	c0 
c01035f5:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01035fc:	c0 
c01035fd:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0103604:	00 
c0103605:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010360c:	e8 d9 d6 ff ff       	call   c0100cea <__panic>
        count++, total += p->property;
c0103611:	ff 45 f4             	incl   -0xc(%ebp)
c0103614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103617:	8b 50 08             	mov    0x8(%eax),%edx
c010361a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010361d:	01 d0                	add    %edx,%eax
c010361f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103622:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103625:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103628:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010362b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c010362e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103631:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103638:	0f 85 7a ff ff ff    	jne    c01035b8 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010363e:	e8 88 09 00 00       	call   c0103fcb <nr_free_pages>
c0103643:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103646:	39 d0                	cmp    %edx,%eax
c0103648:	74 24                	je     c010366e <default_check+0xd6>
c010364a:	c7 44 24 0c ce 68 10 	movl   $0xc01068ce,0xc(%esp)
c0103651:	c0 
c0103652:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103659:	c0 
c010365a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103661:	00 
c0103662:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103669:	e8 7c d6 ff ff       	call   c0100cea <__panic>

    basic_check();
c010366e:	e8 e5 f9 ff ff       	call   c0103058 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103673:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010367a:	e8 dd 08 00 00       	call   c0103f5c <alloc_pages>
c010367f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103682:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103686:	75 24                	jne    c01036ac <default_check+0x114>
c0103688:	c7 44 24 0c e7 68 10 	movl   $0xc01068e7,0xc(%esp)
c010368f:	c0 
c0103690:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103697:	c0 
c0103698:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010369f:	00 
c01036a0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01036a7:	e8 3e d6 ff ff       	call   c0100cea <__panic>
    assert(!PageProperty(p0));
c01036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036af:	83 c0 04             	add    $0x4,%eax
c01036b2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036bf:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036c2:	0f a3 10             	bt     %edx,(%eax)
c01036c5:	19 c0                	sbb    %eax,%eax
c01036c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036ca:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036ce:	0f 95 c0             	setne  %al
c01036d1:	0f b6 c0             	movzbl %al,%eax
c01036d4:	85 c0                	test   %eax,%eax
c01036d6:	74 24                	je     c01036fc <default_check+0x164>
c01036d8:	c7 44 24 0c f2 68 10 	movl   $0xc01068f2,0xc(%esp)
c01036df:	c0 
c01036e0:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01036e7:	c0 
c01036e8:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01036ef:	00 
c01036f0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01036f7:	e8 ee d5 ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c01036fc:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103701:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103707:	89 45 80             	mov    %eax,-0x80(%ebp)
c010370a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010370d:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103714:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103717:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010371a:	89 50 04             	mov    %edx,0x4(%eax)
c010371d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103720:	8b 50 04             	mov    0x4(%eax),%edx
c0103723:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103726:	89 10                	mov    %edx,(%eax)
}
c0103728:	90                   	nop
c0103729:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c0103730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103733:	8b 40 04             	mov    0x4(%eax),%eax
c0103736:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103739:	0f 94 c0             	sete   %al
c010373c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010373f:	85 c0                	test   %eax,%eax
c0103741:	75 24                	jne    c0103767 <default_check+0x1cf>
c0103743:	c7 44 24 0c 47 68 10 	movl   $0xc0106847,0xc(%esp)
c010374a:	c0 
c010374b:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103752:	c0 
c0103753:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010375a:	00 
c010375b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103762:	e8 83 d5 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103767:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010376e:	e8 e9 07 00 00       	call   c0103f5c <alloc_pages>
c0103773:	85 c0                	test   %eax,%eax
c0103775:	74 24                	je     c010379b <default_check+0x203>
c0103777:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c010377e:	c0 
c010377f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103786:	c0 
c0103787:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010378e:	00 
c010378f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103796:	e8 4f d5 ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c010379b:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01037a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01037a3:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01037aa:	00 00 00 

    free_pages(p0 + 2, 3);
c01037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037b0:	83 c0 28             	add    $0x28,%eax
c01037b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037ba:	00 
c01037bb:	89 04 24             	mov    %eax,(%esp)
c01037be:	e8 d3 07 00 00       	call   c0103f96 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037ca:	e8 8d 07 00 00       	call   c0103f5c <alloc_pages>
c01037cf:	85 c0                	test   %eax,%eax
c01037d1:	74 24                	je     c01037f7 <default_check+0x25f>
c01037d3:	c7 44 24 0c 04 69 10 	movl   $0xc0106904,0xc(%esp)
c01037da:	c0 
c01037db:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01037e2:	c0 
c01037e3:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01037ea:	00 
c01037eb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01037f2:	e8 f3 d4 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037fa:	83 c0 28             	add    $0x28,%eax
c01037fd:	83 c0 04             	add    $0x4,%eax
c0103800:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103807:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010380a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010380d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103810:	0f a3 10             	bt     %edx,(%eax)
c0103813:	19 c0                	sbb    %eax,%eax
c0103815:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103818:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010381c:	0f 95 c0             	setne  %al
c010381f:	0f b6 c0             	movzbl %al,%eax
c0103822:	85 c0                	test   %eax,%eax
c0103824:	74 0e                	je     c0103834 <default_check+0x29c>
c0103826:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103829:	83 c0 28             	add    $0x28,%eax
c010382c:	8b 40 08             	mov    0x8(%eax),%eax
c010382f:	83 f8 03             	cmp    $0x3,%eax
c0103832:	74 24                	je     c0103858 <default_check+0x2c0>
c0103834:	c7 44 24 0c 1c 69 10 	movl   $0xc010691c,0xc(%esp)
c010383b:	c0 
c010383c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103843:	c0 
c0103844:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010384b:	00 
c010384c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103853:	e8 92 d4 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103858:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010385f:	e8 f8 06 00 00       	call   c0103f5c <alloc_pages>
c0103864:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103867:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010386b:	75 24                	jne    c0103891 <default_check+0x2f9>
c010386d:	c7 44 24 0c 48 69 10 	movl   $0xc0106948,0xc(%esp)
c0103874:	c0 
c0103875:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010387c:	c0 
c010387d:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103884:	00 
c0103885:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010388c:	e8 59 d4 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103891:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103898:	e8 bf 06 00 00       	call   c0103f5c <alloc_pages>
c010389d:	85 c0                	test   %eax,%eax
c010389f:	74 24                	je     c01038c5 <default_check+0x32d>
c01038a1:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c01038a8:	c0 
c01038a9:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038b0:	c0 
c01038b1:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01038b8:	00 
c01038b9:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01038c0:	e8 25 d4 ff ff       	call   c0100cea <__panic>
    assert(p0 + 2 == p1);
c01038c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038c8:	83 c0 28             	add    $0x28,%eax
c01038cb:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01038ce:	74 24                	je     c01038f4 <default_check+0x35c>
c01038d0:	c7 44 24 0c 66 69 10 	movl   $0xc0106966,0xc(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038df:	c0 
c01038e0:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01038e7:	00 
c01038e8:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01038ef:	e8 f6 d3 ff ff       	call   c0100cea <__panic>

    p2 = p0 + 1;
c01038f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038f7:	83 c0 14             	add    $0x14,%eax
c01038fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103904:	00 
c0103905:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103908:	89 04 24             	mov    %eax,(%esp)
c010390b:	e8 86 06 00 00       	call   c0103f96 <free_pages>
    free_pages(p1, 3);
c0103910:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103917:	00 
c0103918:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010391b:	89 04 24             	mov    %eax,(%esp)
c010391e:	e8 73 06 00 00       	call   c0103f96 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103923:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103926:	83 c0 04             	add    $0x4,%eax
c0103929:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103930:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103933:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103936:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103939:	0f a3 10             	bt     %edx,(%eax)
c010393c:	19 c0                	sbb    %eax,%eax
c010393e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103941:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103945:	0f 95 c0             	setne  %al
c0103948:	0f b6 c0             	movzbl %al,%eax
c010394b:	85 c0                	test   %eax,%eax
c010394d:	74 0b                	je     c010395a <default_check+0x3c2>
c010394f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103952:	8b 40 08             	mov    0x8(%eax),%eax
c0103955:	83 f8 01             	cmp    $0x1,%eax
c0103958:	74 24                	je     c010397e <default_check+0x3e6>
c010395a:	c7 44 24 0c 74 69 10 	movl   $0xc0106974,0xc(%esp)
c0103961:	c0 
c0103962:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103969:	c0 
c010396a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0103971:	00 
c0103972:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103979:	e8 6c d3 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010397e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103981:	83 c0 04             	add    $0x4,%eax
c0103984:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010398b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010398e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103991:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103994:	0f a3 10             	bt     %edx,(%eax)
c0103997:	19 c0                	sbb    %eax,%eax
c0103999:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010399c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01039a0:	0f 95 c0             	setne  %al
c01039a3:	0f b6 c0             	movzbl %al,%eax
c01039a6:	85 c0                	test   %eax,%eax
c01039a8:	74 0b                	je     c01039b5 <default_check+0x41d>
c01039aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039ad:	8b 40 08             	mov    0x8(%eax),%eax
c01039b0:	83 f8 03             	cmp    $0x3,%eax
c01039b3:	74 24                	je     c01039d9 <default_check+0x441>
c01039b5:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c01039bc:	c0 
c01039bd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01039c4:	c0 
c01039c5:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01039cc:	00 
c01039cd:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01039d4:	e8 11 d3 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039e0:	e8 77 05 00 00       	call   c0103f5c <alloc_pages>
c01039e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039eb:	83 e8 14             	sub    $0x14,%eax
c01039ee:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039f1:	74 24                	je     c0103a17 <default_check+0x47f>
c01039f3:	c7 44 24 0c c2 69 10 	movl   $0xc01069c2,0xc(%esp)
c01039fa:	c0 
c01039fb:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103a02:	c0 
c0103a03:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0103a0a:	00 
c0103a0b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103a12:	e8 d3 d2 ff ff       	call   c0100cea <__panic>
    free_page(p0);
c0103a17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a1e:	00 
c0103a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a22:	89 04 24             	mov    %eax,(%esp)
c0103a25:	e8 6c 05 00 00       	call   c0103f96 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a2a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a31:	e8 26 05 00 00       	call   c0103f5c <alloc_pages>
c0103a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a3c:	83 c0 14             	add    $0x14,%eax
c0103a3f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a42:	74 24                	je     c0103a68 <default_check+0x4d0>
c0103a44:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c0103a4b:	c0 
c0103a4c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103a53:	c0 
c0103a54:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0103a5b:	00 
c0103a5c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103a63:	e8 82 d2 ff ff       	call   c0100cea <__panic>

    free_pages(p0, 2);
c0103a68:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a6f:	00 
c0103a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a73:	89 04 24             	mov    %eax,(%esp)
c0103a76:	e8 1b 05 00 00       	call   c0103f96 <free_pages>
    free_page(p2);
c0103a7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a82:	00 
c0103a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a86:	89 04 24             	mov    %eax,(%esp)
c0103a89:	e8 08 05 00 00       	call   c0103f96 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a8e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a95:	e8 c2 04 00 00       	call   c0103f5c <alloc_pages>
c0103a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103aa1:	75 24                	jne    c0103ac7 <default_check+0x52f>
c0103aa3:	c7 44 24 0c 00 6a 10 	movl   $0xc0106a00,0xc(%esp)
c0103aaa:	c0 
c0103aab:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103ab2:	c0 
c0103ab3:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103aba:	00 
c0103abb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103ac2:	e8 23 d2 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103ac7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ace:	e8 89 04 00 00       	call   c0103f5c <alloc_pages>
c0103ad3:	85 c0                	test   %eax,%eax
c0103ad5:	74 24                	je     c0103afb <default_check+0x563>
c0103ad7:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c0103ade:	c0 
c0103adf:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103ae6:	c0 
c0103ae7:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0103aee:	00 
c0103aef:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103af6:	e8 ef d1 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0103afb:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103b00:	85 c0                	test   %eax,%eax
c0103b02:	74 24                	je     c0103b28 <default_check+0x590>
c0103b04:	c7 44 24 0c b1 68 10 	movl   $0xc01068b1,0xc(%esp)
c0103b0b:	c0 
c0103b0c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103b13:	c0 
c0103b14:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103b1b:	00 
c0103b1c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103b23:	e8 c2 d1 ff ff       	call   c0100cea <__panic>
    nr_free = nr_free_store;
c0103b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b2b:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c0103b30:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b33:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b36:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103b3b:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c0103b41:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b48:	00 
c0103b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b4c:	89 04 24             	mov    %eax,(%esp)
c0103b4f:	e8 42 04 00 00       	call   c0103f96 <free_pages>

    le = &free_list;
c0103b54:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103b5b:	eb 5a                	jmp    c0103bb7 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
c0103b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b60:	8b 40 04             	mov    0x4(%eax),%eax
c0103b63:	8b 00                	mov    (%eax),%eax
c0103b65:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b68:	75 0d                	jne    c0103b77 <default_check+0x5df>
c0103b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b6d:	8b 00                	mov    (%eax),%eax
c0103b6f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b75:	74 24                	je     c0103b9b <default_check+0x603>
c0103b77:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c0103b7e:	c0 
c0103b7f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103b86:	c0 
c0103b87:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0103b8e:	00 
c0103b8f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103b96:	e8 4f d1 ff ff       	call   c0100cea <__panic>
        struct Page *p = le2page(le, page_link);
c0103b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b9e:	83 e8 0c             	sub    $0xc,%eax
c0103ba1:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103ba4:	ff 4d f4             	decl   -0xc(%ebp)
c0103ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103baa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bad:	8b 48 08             	mov    0x8(%eax),%ecx
c0103bb0:	89 d0                	mov    %edx,%eax
c0103bb2:	29 c8                	sub    %ecx,%eax
c0103bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bba:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103bbd:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bc0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bc6:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103bcd:	75 8e                	jne    c0103b5d <default_check+0x5c5>
    }
    assert(count == 0);
c0103bcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bd3:	74 24                	je     c0103bf9 <default_check+0x661>
c0103bd5:	c7 44 24 0c 4d 6a 10 	movl   $0xc0106a4d,0xc(%esp)
c0103bdc:	c0 
c0103bdd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103be4:	c0 
c0103be5:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0103bec:	00 
c0103bed:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103bf4:	e8 f1 d0 ff ff       	call   c0100cea <__panic>
    assert(total == 0);
c0103bf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bfd:	74 24                	je     c0103c23 <default_check+0x68b>
c0103bff:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c0103c06:	c0 
c0103c07:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103c0e:	c0 
c0103c0f:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c0103c16:	00 
c0103c17:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103c1e:	e8 c7 d0 ff ff       	call   c0100cea <__panic>
}
c0103c23:	90                   	nop
c0103c24:	89 ec                	mov    %ebp,%esp
c0103c26:	5d                   	pop    %ebp
c0103c27:	c3                   	ret    

c0103c28 <page2ppn>:
page2ppn(struct Page *page) {
c0103c28:	55                   	push   %ebp
c0103c29:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c2b:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0103c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c34:	29 d0                	sub    %edx,%eax
c0103c36:	c1 f8 02             	sar    $0x2,%eax
c0103c39:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c3f:	5d                   	pop    %ebp
c0103c40:	c3                   	ret    

c0103c41 <page2pa>:
page2pa(struct Page *page) {
c0103c41:	55                   	push   %ebp
c0103c42:	89 e5                	mov    %esp,%ebp
c0103c44:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c4a:	89 04 24             	mov    %eax,(%esp)
c0103c4d:	e8 d6 ff ff ff       	call   c0103c28 <page2ppn>
c0103c52:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c55:	89 ec                	mov    %ebp,%esp
c0103c57:	5d                   	pop    %ebp
c0103c58:	c3                   	ret    

c0103c59 <pa2page>:
pa2page(uintptr_t pa) {
c0103c59:	55                   	push   %ebp
c0103c5a:	89 e5                	mov    %esp,%ebp
c0103c5c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c62:	c1 e8 0c             	shr    $0xc,%eax
c0103c65:	89 c2                	mov    %eax,%edx
c0103c67:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103c6c:	39 c2                	cmp    %eax,%edx
c0103c6e:	72 1c                	jb     c0103c8c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c70:	c7 44 24 08 94 6a 10 	movl   $0xc0106a94,0x8(%esp)
c0103c77:	c0 
c0103c78:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c7f:	00 
c0103c80:	c7 04 24 b3 6a 10 c0 	movl   $0xc0106ab3,(%esp)
c0103c87:	e8 5e d0 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c0103c8c:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c95:	c1 e8 0c             	shr    $0xc,%eax
c0103c98:	89 c2                	mov    %eax,%edx
c0103c9a:	89 d0                	mov    %edx,%eax
c0103c9c:	c1 e0 02             	shl    $0x2,%eax
c0103c9f:	01 d0                	add    %edx,%eax
c0103ca1:	c1 e0 02             	shl    $0x2,%eax
c0103ca4:	01 c8                	add    %ecx,%eax
}
c0103ca6:	89 ec                	mov    %ebp,%esp
c0103ca8:	5d                   	pop    %ebp
c0103ca9:	c3                   	ret    

c0103caa <page2kva>:
page2kva(struct Page *page) {
c0103caa:	55                   	push   %ebp
c0103cab:	89 e5                	mov    %esp,%ebp
c0103cad:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cb3:	89 04 24             	mov    %eax,(%esp)
c0103cb6:	e8 86 ff ff ff       	call   c0103c41 <page2pa>
c0103cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc1:	c1 e8 0c             	shr    $0xc,%eax
c0103cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cc7:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103ccc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ccf:	72 23                	jb     c0103cf4 <page2kva+0x4a>
c0103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cd4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103cd8:	c7 44 24 08 c4 6a 10 	movl   $0xc0106ac4,0x8(%esp)
c0103cdf:	c0 
c0103ce0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ce7:	00 
c0103ce8:	c7 04 24 b3 6a 10 c0 	movl   $0xc0106ab3,(%esp)
c0103cef:	e8 f6 cf ff ff       	call   c0100cea <__panic>
c0103cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cf7:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cfc:	89 ec                	mov    %ebp,%esp
c0103cfe:	5d                   	pop    %ebp
c0103cff:	c3                   	ret    

c0103d00 <pte2page>:
pte2page(pte_t pte) {
c0103d00:	55                   	push   %ebp
c0103d01:	89 e5                	mov    %esp,%ebp
c0103d03:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d09:	83 e0 01             	and    $0x1,%eax
c0103d0c:	85 c0                	test   %eax,%eax
c0103d0e:	75 1c                	jne    c0103d2c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103d10:	c7 44 24 08 e8 6a 10 	movl   $0xc0106ae8,0x8(%esp)
c0103d17:	c0 
c0103d18:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103d1f:	00 
c0103d20:	c7 04 24 b3 6a 10 c0 	movl   $0xc0106ab3,(%esp)
c0103d27:	e8 be cf ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d34:	89 04 24             	mov    %eax,(%esp)
c0103d37:	e8 1d ff ff ff       	call   c0103c59 <pa2page>
}
c0103d3c:	89 ec                	mov    %ebp,%esp
c0103d3e:	5d                   	pop    %ebp
c0103d3f:	c3                   	ret    

c0103d40 <pde2page>:
pde2page(pde_t pde) {
c0103d40:	55                   	push   %ebp
c0103d41:	89 e5                	mov    %esp,%ebp
c0103d43:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d4e:	89 04 24             	mov    %eax,(%esp)
c0103d51:	e8 03 ff ff ff       	call   c0103c59 <pa2page>
}
c0103d56:	89 ec                	mov    %ebp,%esp
c0103d58:	5d                   	pop    %ebp
c0103d59:	c3                   	ret    

c0103d5a <page_ref>:
page_ref(struct Page *page) {
c0103d5a:	55                   	push   %ebp
c0103d5b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d60:	8b 00                	mov    (%eax),%eax
}
c0103d62:	5d                   	pop    %ebp
c0103d63:	c3                   	ret    

c0103d64 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d64:	55                   	push   %ebp
c0103d65:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6a:	8b 00                	mov    (%eax),%eax
c0103d6c:	8d 50 01             	lea    0x1(%eax),%edx
c0103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d72:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d77:	8b 00                	mov    (%eax),%eax
}
c0103d79:	5d                   	pop    %ebp
c0103d7a:	c3                   	ret    

c0103d7b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d7b:	55                   	push   %ebp
c0103d7c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d81:	8b 00                	mov    (%eax),%eax
c0103d83:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d86:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d89:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8e:	8b 00                	mov    (%eax),%eax
}
c0103d90:	5d                   	pop    %ebp
c0103d91:	c3                   	ret    

c0103d92 <__intr_save>:
__intr_save(void) {
c0103d92:	55                   	push   %ebp
c0103d93:	89 e5                	mov    %esp,%ebp
c0103d95:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d98:	9c                   	pushf  
c0103d99:	58                   	pop    %eax
c0103d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103da0:	25 00 02 00 00       	and    $0x200,%eax
c0103da5:	85 c0                	test   %eax,%eax
c0103da7:	74 0c                	je     c0103db5 <__intr_save+0x23>
        intr_disable();
c0103da9:	e8 95 d9 ff ff       	call   c0101743 <intr_disable>
        return 1;
c0103dae:	b8 01 00 00 00       	mov    $0x1,%eax
c0103db3:	eb 05                	jmp    c0103dba <__intr_save+0x28>
    return 0;
c0103db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103dba:	89 ec                	mov    %ebp,%esp
c0103dbc:	5d                   	pop    %ebp
c0103dbd:	c3                   	ret    

c0103dbe <__intr_restore>:
__intr_restore(bool flag) {
c0103dbe:	55                   	push   %ebp
c0103dbf:	89 e5                	mov    %esp,%ebp
c0103dc1:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103dc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103dc8:	74 05                	je     c0103dcf <__intr_restore+0x11>
        intr_enable();
c0103dca:	e8 6c d9 ff ff       	call   c010173b <intr_enable>
}
c0103dcf:	90                   	nop
c0103dd0:	89 ec                	mov    %ebp,%esp
c0103dd2:	5d                   	pop    %ebp
c0103dd3:	c3                   	ret    

c0103dd4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103dd4:	55                   	push   %ebp
c0103dd5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dda:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ddd:	b8 23 00 00 00       	mov    $0x23,%eax
c0103de2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103de4:	b8 23 00 00 00       	mov    $0x23,%eax
c0103de9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103deb:	b8 10 00 00 00       	mov    $0x10,%eax
c0103df0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103df2:	b8 10 00 00 00       	mov    $0x10,%eax
c0103df7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103df9:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dfe:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103e00:	ea 07 3e 10 c0 08 00 	ljmp   $0x8,$0xc0103e07
}
c0103e07:	90                   	nop
c0103e08:	5d                   	pop    %ebp
c0103e09:	c3                   	ret    

c0103e0a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103e0a:	55                   	push   %ebp
c0103e0b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e10:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103e15:	90                   	nop
c0103e16:	5d                   	pop    %ebp
c0103e17:	c3                   	ret    

c0103e18 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e18:	55                   	push   %ebp
c0103e19:	89 e5                	mov    %esp,%ebp
c0103e1b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103e1e:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103e23:	89 04 24             	mov    %eax,(%esp)
c0103e26:	e8 df ff ff ff       	call   c0103e0a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e2b:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103e32:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e34:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103e3b:	68 00 
c0103e3d:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e42:	0f b7 c0             	movzwl %ax,%eax
c0103e45:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103e4b:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e50:	c1 e8 10             	shr    $0x10,%eax
c0103e53:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103e58:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e5f:	24 f0                	and    $0xf0,%al
c0103e61:	0c 09                	or     $0x9,%al
c0103e63:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e68:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e6f:	24 ef                	and    $0xef,%al
c0103e71:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e76:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e7d:	24 9f                	and    $0x9f,%al
c0103e7f:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e84:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e8b:	0c 80                	or     $0x80,%al
c0103e8d:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e92:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e99:	24 f0                	and    $0xf0,%al
c0103e9b:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ea0:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ea7:	24 ef                	and    $0xef,%al
c0103ea9:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eae:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103eb5:	24 df                	and    $0xdf,%al
c0103eb7:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ebc:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ec3:	0c 40                	or     $0x40,%al
c0103ec5:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eca:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ed1:	24 7f                	and    $0x7f,%al
c0103ed3:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ed8:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103edd:	c1 e8 18             	shr    $0x18,%eax
c0103ee0:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ee5:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103eec:	e8 e3 fe ff ff       	call   c0103dd4 <lgdt>
c0103ef1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ef7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103efb:	0f 00 d8             	ltr    %ax
}
c0103efe:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103eff:	90                   	nop
c0103f00:	89 ec                	mov    %ebp,%esp
c0103f02:	5d                   	pop    %ebp
c0103f03:	c3                   	ret    

c0103f04 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103f04:	55                   	push   %ebp
c0103f05:	89 e5                	mov    %esp,%ebp
c0103f07:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103f0a:	c7 05 ac be 11 c0 78 	movl   $0xc0106a78,0xc011beac
c0103f11:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f14:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f19:	8b 00                	mov    (%eax),%eax
c0103f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f1f:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0103f26:	e8 3a c4 ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c0103f2b:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f30:	8b 40 04             	mov    0x4(%eax),%eax
c0103f33:	ff d0                	call   *%eax
}
c0103f35:	90                   	nop
c0103f36:	89 ec                	mov    %ebp,%esp
c0103f38:	5d                   	pop    %ebp
c0103f39:	c3                   	ret    

c0103f3a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f3a:	55                   	push   %ebp
c0103f3b:	89 e5                	mov    %esp,%ebp
c0103f3d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f40:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f45:	8b 40 08             	mov    0x8(%eax),%eax
c0103f48:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f4b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f52:	89 14 24             	mov    %edx,(%esp)
c0103f55:	ff d0                	call   *%eax
}
c0103f57:	90                   	nop
c0103f58:	89 ec                	mov    %ebp,%esp
c0103f5a:	5d                   	pop    %ebp
c0103f5b:	c3                   	ret    

c0103f5c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f5c:	55                   	push   %ebp
c0103f5d:	89 e5                	mov    %esp,%ebp
c0103f5f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f69:	e8 24 fe ff ff       	call   c0103d92 <__intr_save>
c0103f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f71:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f76:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f79:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f7c:	89 14 24             	mov    %edx,(%esp)
c0103f7f:	ff d0                	call   *%eax
c0103f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f87:	89 04 24             	mov    %eax,(%esp)
c0103f8a:	e8 2f fe ff ff       	call   c0103dbe <__intr_restore>
    return page;
c0103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f92:	89 ec                	mov    %ebp,%esp
c0103f94:	5d                   	pop    %ebp
c0103f95:	c3                   	ret    

c0103f96 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f96:	55                   	push   %ebp
c0103f97:	89 e5                	mov    %esp,%ebp
c0103f99:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f9c:	e8 f1 fd ff ff       	call   c0103d92 <__intr_save>
c0103fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103fa4:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103fa9:	8b 40 10             	mov    0x10(%eax),%eax
c0103fac:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103faf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fb3:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fb6:	89 14 24             	mov    %edx,(%esp)
c0103fb9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fbe:	89 04 24             	mov    %eax,(%esp)
c0103fc1:	e8 f8 fd ff ff       	call   c0103dbe <__intr_restore>
}
c0103fc6:	90                   	nop
c0103fc7:	89 ec                	mov    %ebp,%esp
c0103fc9:	5d                   	pop    %ebp
c0103fca:	c3                   	ret    

c0103fcb <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fcb:	55                   	push   %ebp
c0103fcc:	89 e5                	mov    %esp,%ebp
c0103fce:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fd1:	e8 bc fd ff ff       	call   c0103d92 <__intr_save>
c0103fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fd9:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103fde:	8b 40 14             	mov    0x14(%eax),%eax
c0103fe1:	ff d0                	call   *%eax
c0103fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fe9:	89 04 24             	mov    %eax,(%esp)
c0103fec:	e8 cd fd ff ff       	call   c0103dbe <__intr_restore>
    return ret;
c0103ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103ff4:	89 ec                	mov    %ebp,%esp
c0103ff6:	5d                   	pop    %ebp
c0103ff7:	c3                   	ret    

c0103ff8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103ff8:	55                   	push   %ebp
c0103ff9:	89 e5                	mov    %esp,%ebp
c0103ffb:	57                   	push   %edi
c0103ffc:	56                   	push   %esi
c0103ffd:	53                   	push   %ebx
c0103ffe:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104004:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010400b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104012:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104019:	c7 04 24 2b 6b 10 c0 	movl   $0xc0106b2b,(%esp)
c0104020:	e8 40 c3 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104025:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010402c:	e9 0c 01 00 00       	jmp    c010413d <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104031:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104034:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104037:	89 d0                	mov    %edx,%eax
c0104039:	c1 e0 02             	shl    $0x2,%eax
c010403c:	01 d0                	add    %edx,%eax
c010403e:	c1 e0 02             	shl    $0x2,%eax
c0104041:	01 c8                	add    %ecx,%eax
c0104043:	8b 50 08             	mov    0x8(%eax),%edx
c0104046:	8b 40 04             	mov    0x4(%eax),%eax
c0104049:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010404c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010404f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104052:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104055:	89 d0                	mov    %edx,%eax
c0104057:	c1 e0 02             	shl    $0x2,%eax
c010405a:	01 d0                	add    %edx,%eax
c010405c:	c1 e0 02             	shl    $0x2,%eax
c010405f:	01 c8                	add    %ecx,%eax
c0104061:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104064:	8b 58 10             	mov    0x10(%eax),%ebx
c0104067:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010406a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010406d:	01 c8                	add    %ecx,%eax
c010406f:	11 da                	adc    %ebx,%edx
c0104071:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104074:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104077:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010407a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010407d:	89 d0                	mov    %edx,%eax
c010407f:	c1 e0 02             	shl    $0x2,%eax
c0104082:	01 d0                	add    %edx,%eax
c0104084:	c1 e0 02             	shl    $0x2,%eax
c0104087:	01 c8                	add    %ecx,%eax
c0104089:	83 c0 14             	add    $0x14,%eax
c010408c:	8b 00                	mov    (%eax),%eax
c010408e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104094:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104097:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010409a:	83 c0 ff             	add    $0xffffffff,%eax
c010409d:	83 d2 ff             	adc    $0xffffffff,%edx
c01040a0:	89 c6                	mov    %eax,%esi
c01040a2:	89 d7                	mov    %edx,%edi
c01040a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040aa:	89 d0                	mov    %edx,%eax
c01040ac:	c1 e0 02             	shl    $0x2,%eax
c01040af:	01 d0                	add    %edx,%eax
c01040b1:	c1 e0 02             	shl    $0x2,%eax
c01040b4:	01 c8                	add    %ecx,%eax
c01040b6:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040b9:	8b 58 10             	mov    0x10(%eax),%ebx
c01040bc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01040c2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040c6:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040ce:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040d1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040d8:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040e4:	c7 04 24 38 6b 10 c0 	movl   $0xc0106b38,(%esp)
c01040eb:	e8 75 c2 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040f6:	89 d0                	mov    %edx,%eax
c01040f8:	c1 e0 02             	shl    $0x2,%eax
c01040fb:	01 d0                	add    %edx,%eax
c01040fd:	c1 e0 02             	shl    $0x2,%eax
c0104100:	01 c8                	add    %ecx,%eax
c0104102:	83 c0 14             	add    $0x14,%eax
c0104105:	8b 00                	mov    (%eax),%eax
c0104107:	83 f8 01             	cmp    $0x1,%eax
c010410a:	75 2e                	jne    c010413a <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c010410c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010410f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104112:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104115:	89 d0                	mov    %edx,%eax
c0104117:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c010411a:	73 1e                	jae    c010413a <page_init+0x142>
c010411c:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0104121:	b8 00 00 00 00       	mov    $0x0,%eax
c0104126:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104129:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c010412c:	72 0c                	jb     c010413a <page_init+0x142>
                maxpa = end;
c010412e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104131:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104134:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104137:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c010413a:	ff 45 dc             	incl   -0x24(%ebp)
c010413d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104140:	8b 00                	mov    (%eax),%eax
c0104142:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104145:	0f 8c e6 fe ff ff    	jl     c0104031 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010414b:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104150:	b8 00 00 00 00       	mov    $0x0,%eax
c0104155:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104158:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c010415b:	73 0e                	jae    c010416b <page_init+0x173>
        maxpa = KMEMSIZE;
c010415d:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010416b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010416e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104171:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104175:	c1 ea 0c             	shr    $0xc,%edx
c0104178:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010417d:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104184:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0104189:	8d 50 ff             	lea    -0x1(%eax),%edx
c010418c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010418f:	01 d0                	add    %edx,%eax
c0104191:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104194:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104197:	ba 00 00 00 00       	mov    $0x0,%edx
c010419c:	f7 75 c0             	divl   -0x40(%ebp)
c010419f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041a2:	29 d0                	sub    %edx,%eax
c01041a4:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c01041a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041b0:	eb 2f                	jmp    c01041e1 <page_init+0x1e9>
        SetPageReserved(pages + i);
c01041b2:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c01041b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041bb:	89 d0                	mov    %edx,%eax
c01041bd:	c1 e0 02             	shl    $0x2,%eax
c01041c0:	01 d0                	add    %edx,%eax
c01041c2:	c1 e0 02             	shl    $0x2,%eax
c01041c5:	01 c8                	add    %ecx,%eax
c01041c7:	83 c0 04             	add    $0x4,%eax
c01041ca:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01041d1:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041d4:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041d7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041da:	0f ab 10             	bts    %edx,(%eax)
}
c01041dd:	90                   	nop
    for (i = 0; i < npage; i ++) {
c01041de:	ff 45 dc             	incl   -0x24(%ebp)
c01041e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041e4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01041e9:	39 c2                	cmp    %eax,%edx
c01041eb:	72 c5                	jb     c01041b2 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041ed:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01041f3:	89 d0                	mov    %edx,%eax
c01041f5:	c1 e0 02             	shl    $0x2,%eax
c01041f8:	01 d0                	add    %edx,%eax
c01041fa:	c1 e0 02             	shl    $0x2,%eax
c01041fd:	89 c2                	mov    %eax,%edx
c01041ff:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c0104204:	01 d0                	add    %edx,%eax
c0104206:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104209:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104210:	77 23                	ja     c0104235 <page_init+0x23d>
c0104212:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104215:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104219:	c7 44 24 08 68 6b 10 	movl   $0xc0106b68,0x8(%esp)
c0104220:	c0 
c0104221:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104228:	00 
c0104229:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104230:	e8 b5 ca ff ff       	call   c0100cea <__panic>
c0104235:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104238:	05 00 00 00 40       	add    $0x40000000,%eax
c010423d:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104240:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104247:	e9 53 01 00 00       	jmp    c010439f <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010424c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010424f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104252:	89 d0                	mov    %edx,%eax
c0104254:	c1 e0 02             	shl    $0x2,%eax
c0104257:	01 d0                	add    %edx,%eax
c0104259:	c1 e0 02             	shl    $0x2,%eax
c010425c:	01 c8                	add    %ecx,%eax
c010425e:	8b 50 08             	mov    0x8(%eax),%edx
c0104261:	8b 40 04             	mov    0x4(%eax),%eax
c0104264:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104267:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010426a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010426d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104270:	89 d0                	mov    %edx,%eax
c0104272:	c1 e0 02             	shl    $0x2,%eax
c0104275:	01 d0                	add    %edx,%eax
c0104277:	c1 e0 02             	shl    $0x2,%eax
c010427a:	01 c8                	add    %ecx,%eax
c010427c:	8b 48 0c             	mov    0xc(%eax),%ecx
c010427f:	8b 58 10             	mov    0x10(%eax),%ebx
c0104282:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104285:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104288:	01 c8                	add    %ecx,%eax
c010428a:	11 da                	adc    %ebx,%edx
c010428c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010428f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104292:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104295:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104298:	89 d0                	mov    %edx,%eax
c010429a:	c1 e0 02             	shl    $0x2,%eax
c010429d:	01 d0                	add    %edx,%eax
c010429f:	c1 e0 02             	shl    $0x2,%eax
c01042a2:	01 c8                	add    %ecx,%eax
c01042a4:	83 c0 14             	add    $0x14,%eax
c01042a7:	8b 00                	mov    (%eax),%eax
c01042a9:	83 f8 01             	cmp    $0x1,%eax
c01042ac:	0f 85 ea 00 00 00    	jne    c010439c <page_init+0x3a4>
            if (begin < freemem) {
c01042b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01042ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01042bd:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01042c0:	19 d1                	sbb    %edx,%ecx
c01042c2:	73 0d                	jae    c01042d1 <page_init+0x2d9>
                begin = freemem;
c01042c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042d1:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01042d6:	b8 00 00 00 00       	mov    $0x0,%eax
c01042db:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01042de:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042e1:	73 0e                	jae    c01042f1 <page_init+0x2f9>
                end = KMEMSIZE;
c01042e3:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042ea:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042f7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042fa:	89 d0                	mov    %edx,%eax
c01042fc:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042ff:	0f 83 97 00 00 00    	jae    c010439c <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c0104305:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010430c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010430f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104312:	01 d0                	add    %edx,%eax
c0104314:	48                   	dec    %eax
c0104315:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104318:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010431b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104320:	f7 75 b0             	divl   -0x50(%ebp)
c0104323:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104326:	29 d0                	sub    %edx,%eax
c0104328:	ba 00 00 00 00       	mov    $0x0,%edx
c010432d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104330:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104333:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104336:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104339:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010433c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104341:	89 c7                	mov    %eax,%edi
c0104343:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104349:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010434c:	89 d0                	mov    %edx,%eax
c010434e:	83 e0 00             	and    $0x0,%eax
c0104351:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104354:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104357:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010435a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010435d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104360:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104363:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104366:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104369:	89 d0                	mov    %edx,%eax
c010436b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010436e:	73 2c                	jae    c010439c <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104370:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104373:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104376:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104379:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010437c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104380:	c1 ea 0c             	shr    $0xc,%edx
c0104383:	89 c3                	mov    %eax,%ebx
c0104385:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104388:	89 04 24             	mov    %eax,(%esp)
c010438b:	e8 c9 f8 ff ff       	call   c0103c59 <pa2page>
c0104390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104394:	89 04 24             	mov    %eax,(%esp)
c0104397:	e8 9e fb ff ff       	call   c0103f3a <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010439c:	ff 45 dc             	incl   -0x24(%ebp)
c010439f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043a2:	8b 00                	mov    (%eax),%eax
c01043a4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01043a7:	0f 8c 9f fe ff ff    	jl     c010424c <page_init+0x254>
                }
            }
        }
    }
}
c01043ad:	90                   	nop
c01043ae:	90                   	nop
c01043af:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043b5:	5b                   	pop    %ebx
c01043b6:	5e                   	pop    %esi
c01043b7:	5f                   	pop    %edi
c01043b8:	5d                   	pop    %ebp
c01043b9:	c3                   	ret    

c01043ba <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043ba:	55                   	push   %ebp
c01043bb:	89 e5                	mov    %esp,%ebp
c01043bd:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043c3:	33 45 14             	xor    0x14(%ebp),%eax
c01043c6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043cb:	85 c0                	test   %eax,%eax
c01043cd:	74 24                	je     c01043f3 <boot_map_segment+0x39>
c01043cf:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c01043d6:	c0 
c01043d7:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c01043de:	c0 
c01043df:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01043e6:	00 
c01043e7:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01043ee:	e8 f7 c8 ff ff       	call   c0100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01043fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043fd:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104402:	89 c2                	mov    %eax,%edx
c0104404:	8b 45 10             	mov    0x10(%ebp),%eax
c0104407:	01 c2                	add    %eax,%edx
c0104409:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010440c:	01 d0                	add    %edx,%eax
c010440e:	48                   	dec    %eax
c010440f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104412:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104415:	ba 00 00 00 00       	mov    $0x0,%edx
c010441a:	f7 75 f0             	divl   -0x10(%ebp)
c010441d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104420:	29 d0                	sub    %edx,%eax
c0104422:	c1 e8 0c             	shr    $0xc,%eax
c0104425:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010442b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010442e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104436:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104439:	8b 45 14             	mov    0x14(%ebp),%eax
c010443c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010443f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104447:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010444a:	eb 68                	jmp    c01044b4 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010444c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104453:	00 
c0104454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104457:	89 44 24 04          	mov    %eax,0x4(%esp)
c010445b:	8b 45 08             	mov    0x8(%ebp),%eax
c010445e:	89 04 24             	mov    %eax,(%esp)
c0104461:	e8 88 01 00 00       	call   c01045ee <get_pte>
c0104466:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010446d:	75 24                	jne    c0104493 <boot_map_segment+0xd9>
c010446f:	c7 44 24 0c c6 6b 10 	movl   $0xc0106bc6,0xc(%esp)
c0104476:	c0 
c0104477:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c010447e:	c0 
c010447f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104486:	00 
c0104487:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c010448e:	e8 57 c8 ff ff       	call   c0100cea <__panic>
        *ptep = pa | PTE_P | perm;
c0104493:	8b 45 14             	mov    0x14(%ebp),%eax
c0104496:	0b 45 18             	or     0x18(%ebp),%eax
c0104499:	83 c8 01             	or     $0x1,%eax
c010449c:	89 c2                	mov    %eax,%edx
c010449e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044a1:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044a3:	ff 4d f4             	decl   -0xc(%ebp)
c01044a6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044ad:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b8:	75 92                	jne    c010444c <boot_map_segment+0x92>
    }
}
c01044ba:	90                   	nop
c01044bb:	90                   	nop
c01044bc:	89 ec                	mov    %ebp,%esp
c01044be:	5d                   	pop    %ebp
c01044bf:	c3                   	ret    

c01044c0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044c0:	55                   	push   %ebp
c01044c1:	89 e5                	mov    %esp,%ebp
c01044c3:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044cd:	e8 8a fa ff ff       	call   c0103f5c <alloc_pages>
c01044d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d9:	75 1c                	jne    c01044f7 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044db:	c7 44 24 08 d3 6b 10 	movl   $0xc0106bd3,0x8(%esp)
c01044e2:	c0 
c01044e3:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01044ea:	00 
c01044eb:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01044f2:	e8 f3 c7 ff ff       	call   c0100cea <__panic>
    }
    return page2kva(p);
c01044f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fa:	89 04 24             	mov    %eax,(%esp)
c01044fd:	e8 a8 f7 ff ff       	call   c0103caa <page2kva>
}
c0104502:	89 ec                	mov    %ebp,%esp
c0104504:	5d                   	pop    %ebp
c0104505:	c3                   	ret    

c0104506 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104506:	55                   	push   %ebp
c0104507:	89 e5                	mov    %esp,%ebp
c0104509:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010450c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104511:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104514:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010451b:	77 23                	ja     c0104540 <pmm_init+0x3a>
c010451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104520:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104524:	c7 44 24 08 68 6b 10 	movl   $0xc0106b68,0x8(%esp)
c010452b:	c0 
c010452c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104533:	00 
c0104534:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c010453b:	e8 aa c7 ff ff       	call   c0100cea <__panic>
c0104540:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104543:	05 00 00 00 40       	add    $0x40000000,%eax
c0104548:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010454d:	e8 b2 f9 ff ff       	call   c0103f04 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104552:	e8 a1 fa ff ff       	call   c0103ff8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104557:	e8 5a 02 00 00       	call   c01047b6 <check_alloc_page>

    check_pgdir();
c010455c:	e8 76 02 00 00       	call   c01047d7 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104561:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104566:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104569:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104570:	77 23                	ja     c0104595 <pmm_init+0x8f>
c0104572:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104575:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104579:	c7 44 24 08 68 6b 10 	movl   $0xc0106b68,0x8(%esp)
c0104580:	c0 
c0104581:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104588:	00 
c0104589:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104590:	e8 55 c7 ff ff       	call   c0100cea <__panic>
c0104595:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104598:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010459e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045a3:	05 ac 0f 00 00       	add    $0xfac,%eax
c01045a8:	83 ca 03             	or     $0x3,%edx
c01045ab:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045ad:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045b2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045b9:	00 
c01045ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045c1:	00 
c01045c2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045c9:	38 
c01045ca:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045d1:	c0 
c01045d2:	89 04 24             	mov    %eax,(%esp)
c01045d5:	e8 e0 fd ff ff       	call   c01043ba <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045da:	e8 39 f8 ff ff       	call   c0103e18 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045df:	e8 91 08 00 00       	call   c0104e75 <check_boot_pgdir>

    print_pgdir();
c01045e4:	e8 0e 0d 00 00       	call   c01052f7 <print_pgdir>

}
c01045e9:	90                   	nop
c01045ea:	89 ec                	mov    %ebp,%esp
c01045ec:	5d                   	pop    %ebp
c01045ed:	c3                   	ret    

c01045ee <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045ee:	55                   	push   %ebp
c01045ef:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01045f1:	90                   	nop
c01045f2:	5d                   	pop    %ebp
c01045f3:	c3                   	ret    

c01045f4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01045f4:	55                   	push   %ebp
c01045f5:	89 e5                	mov    %esp,%ebp
c01045f7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104601:	00 
c0104602:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104605:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104609:	8b 45 08             	mov    0x8(%ebp),%eax
c010460c:	89 04 24             	mov    %eax,(%esp)
c010460f:	e8 da ff ff ff       	call   c01045ee <get_pte>
c0104614:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010461b:	74 08                	je     c0104625 <get_page+0x31>
        *ptep_store = ptep;
c010461d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104620:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104623:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104629:	74 1b                	je     c0104646 <get_page+0x52>
c010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462e:	8b 00                	mov    (%eax),%eax
c0104630:	83 e0 01             	and    $0x1,%eax
c0104633:	85 c0                	test   %eax,%eax
c0104635:	74 0f                	je     c0104646 <get_page+0x52>
        return pte2page(*ptep);
c0104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463a:	8b 00                	mov    (%eax),%eax
c010463c:	89 04 24             	mov    %eax,(%esp)
c010463f:	e8 bc f6 ff ff       	call   c0103d00 <pte2page>
c0104644:	eb 05                	jmp    c010464b <get_page+0x57>
    }
    return NULL;
c0104646:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010464b:	89 ec                	mov    %ebp,%esp
c010464d:	5d                   	pop    %ebp
c010464e:	c3                   	ret    

c010464f <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010464f:	55                   	push   %ebp
c0104650:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104652:	90                   	nop
c0104653:	5d                   	pop    %ebp
c0104654:	c3                   	ret    

c0104655 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104655:	55                   	push   %ebp
c0104656:	89 e5                	mov    %esp,%ebp
c0104658:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010465b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104662:	00 
c0104663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104666:	89 44 24 04          	mov    %eax,0x4(%esp)
c010466a:	8b 45 08             	mov    0x8(%ebp),%eax
c010466d:	89 04 24             	mov    %eax,(%esp)
c0104670:	e8 79 ff ff ff       	call   c01045ee <get_pte>
c0104675:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104678:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010467c:	74 19                	je     c0104697 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010467e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104681:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104688:	89 44 24 04          	mov    %eax,0x4(%esp)
c010468c:	8b 45 08             	mov    0x8(%ebp),%eax
c010468f:	89 04 24             	mov    %eax,(%esp)
c0104692:	e8 b8 ff ff ff       	call   c010464f <page_remove_pte>
    }
}
c0104697:	90                   	nop
c0104698:	89 ec                	mov    %ebp,%esp
c010469a:	5d                   	pop    %ebp
c010469b:	c3                   	ret    

c010469c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010469c:	55                   	push   %ebp
c010469d:	89 e5                	mov    %esp,%ebp
c010469f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01046a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046a9:	00 
c01046aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b4:	89 04 24             	mov    %eax,(%esp)
c01046b7:	e8 32 ff ff ff       	call   c01045ee <get_pte>
c01046bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046c3:	75 0a                	jne    c01046cf <page_insert+0x33>
        return -E_NO_MEM;
c01046c5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046ca:	e9 84 00 00 00       	jmp    c0104753 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046d2:	89 04 24             	mov    %eax,(%esp)
c01046d5:	e8 8a f6 ff ff       	call   c0103d64 <page_ref_inc>
    if (*ptep & PTE_P) {
c01046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046dd:	8b 00                	mov    (%eax),%eax
c01046df:	83 e0 01             	and    $0x1,%eax
c01046e2:	85 c0                	test   %eax,%eax
c01046e4:	74 3e                	je     c0104724 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e9:	8b 00                	mov    (%eax),%eax
c01046eb:	89 04 24             	mov    %eax,(%esp)
c01046ee:	e8 0d f6 ff ff       	call   c0103d00 <pte2page>
c01046f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046fc:	75 0d                	jne    c010470b <page_insert+0x6f>
            page_ref_dec(page);
c01046fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104701:	89 04 24             	mov    %eax,(%esp)
c0104704:	e8 72 f6 ff ff       	call   c0103d7b <page_ref_dec>
c0104709:	eb 19                	jmp    c0104724 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010470b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104712:	8b 45 10             	mov    0x10(%ebp),%eax
c0104715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104719:	8b 45 08             	mov    0x8(%ebp),%eax
c010471c:	89 04 24             	mov    %eax,(%esp)
c010471f:	e8 2b ff ff ff       	call   c010464f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104724:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104727:	89 04 24             	mov    %eax,(%esp)
c010472a:	e8 12 f5 ff ff       	call   c0103c41 <page2pa>
c010472f:	0b 45 14             	or     0x14(%ebp),%eax
c0104732:	83 c8 01             	or     $0x1,%eax
c0104735:	89 c2                	mov    %eax,%edx
c0104737:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010473c:	8b 45 10             	mov    0x10(%ebp),%eax
c010473f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104743:	8b 45 08             	mov    0x8(%ebp),%eax
c0104746:	89 04 24             	mov    %eax,(%esp)
c0104749:	e8 09 00 00 00       	call   c0104757 <tlb_invalidate>
    return 0;
c010474e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104753:	89 ec                	mov    %ebp,%esp
c0104755:	5d                   	pop    %ebp
c0104756:	c3                   	ret    

c0104757 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104757:	55                   	push   %ebp
c0104758:	89 e5                	mov    %esp,%ebp
c010475a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010475d:	0f 20 d8             	mov    %cr3,%eax
c0104760:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104763:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104766:	8b 45 08             	mov    0x8(%ebp),%eax
c0104769:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010476c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104773:	77 23                	ja     c0104798 <tlb_invalidate+0x41>
c0104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104778:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010477c:	c7 44 24 08 68 6b 10 	movl   $0xc0106b68,0x8(%esp)
c0104783:	c0 
c0104784:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c010478b:	00 
c010478c:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104793:	e8 52 c5 ff ff       	call   c0100cea <__panic>
c0104798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479b:	05 00 00 00 40       	add    $0x40000000,%eax
c01047a0:	39 d0                	cmp    %edx,%eax
c01047a2:	75 0d                	jne    c01047b1 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c01047a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01047aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ad:	0f 01 38             	invlpg (%eax)
}
c01047b0:	90                   	nop
    }
}
c01047b1:	90                   	nop
c01047b2:	89 ec                	mov    %ebp,%esp
c01047b4:	5d                   	pop    %ebp
c01047b5:	c3                   	ret    

c01047b6 <check_alloc_page>:

static void
check_alloc_page(void) {
c01047b6:	55                   	push   %ebp
c01047b7:	89 e5                	mov    %esp,%ebp
c01047b9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047bc:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c01047c1:	8b 40 18             	mov    0x18(%eax),%eax
c01047c4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047c6:	c7 04 24 ec 6b 10 c0 	movl   $0xc0106bec,(%esp)
c01047cd:	e8 93 bb ff ff       	call   c0100365 <cprintf>
}
c01047d2:	90                   	nop
c01047d3:	89 ec                	mov    %ebp,%esp
c01047d5:	5d                   	pop    %ebp
c01047d6:	c3                   	ret    

c01047d7 <check_pgdir>:

static void
check_pgdir(void) {
c01047d7:	55                   	push   %ebp
c01047d8:	89 e5                	mov    %esp,%ebp
c01047da:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047dd:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01047e2:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047e7:	76 24                	jbe    c010480d <check_pgdir+0x36>
c01047e9:	c7 44 24 0c 0b 6c 10 	movl   $0xc0106c0b,0xc(%esp)
c01047f0:	c0 
c01047f1:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c01047f8:	c0 
c01047f9:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c0104800:	00 
c0104801:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104808:	e8 dd c4 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010480d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104812:	85 c0                	test   %eax,%eax
c0104814:	74 0e                	je     c0104824 <check_pgdir+0x4d>
c0104816:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010481b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104820:	85 c0                	test   %eax,%eax
c0104822:	74 24                	je     c0104848 <check_pgdir+0x71>
c0104824:	c7 44 24 0c 28 6c 10 	movl   $0xc0106c28,0xc(%esp)
c010482b:	c0 
c010482c:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104833:	c0 
c0104834:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c010483b:	00 
c010483c:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104843:	e8 a2 c4 ff ff       	call   c0100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104848:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010484d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104854:	00 
c0104855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010485c:	00 
c010485d:	89 04 24             	mov    %eax,(%esp)
c0104860:	e8 8f fd ff ff       	call   c01045f4 <get_page>
c0104865:	85 c0                	test   %eax,%eax
c0104867:	74 24                	je     c010488d <check_pgdir+0xb6>
c0104869:	c7 44 24 0c 60 6c 10 	movl   $0xc0106c60,0xc(%esp)
c0104870:	c0 
c0104871:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104878:	c0 
c0104879:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c0104880:	00 
c0104881:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104888:	e8 5d c4 ff ff       	call   c0100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010488d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104894:	e8 c3 f6 ff ff       	call   c0103f5c <alloc_pages>
c0104899:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010489c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048a8:	00 
c01048a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048b0:	00 
c01048b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048b8:	89 04 24             	mov    %eax,(%esp)
c01048bb:	e8 dc fd ff ff       	call   c010469c <page_insert>
c01048c0:	85 c0                	test   %eax,%eax
c01048c2:	74 24                	je     c01048e8 <check_pgdir+0x111>
c01048c4:	c7 44 24 0c 88 6c 10 	movl   $0xc0106c88,0xc(%esp)
c01048cb:	c0 
c01048cc:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c01048d3:	c0 
c01048d4:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01048db:	00 
c01048dc:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01048e3:	e8 02 c4 ff ff       	call   c0100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048e8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048f4:	00 
c01048f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048fc:	00 
c01048fd:	89 04 24             	mov    %eax,(%esp)
c0104900:	e8 e9 fc ff ff       	call   c01045ee <get_pte>
c0104905:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104908:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010490c:	75 24                	jne    c0104932 <check_pgdir+0x15b>
c010490e:	c7 44 24 0c b4 6c 10 	movl   $0xc0106cb4,0xc(%esp)
c0104915:	c0 
c0104916:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c010491d:	c0 
c010491e:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0104925:	00 
c0104926:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c010492d:	e8 b8 c3 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0104932:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104935:	8b 00                	mov    (%eax),%eax
c0104937:	89 04 24             	mov    %eax,(%esp)
c010493a:	e8 c1 f3 ff ff       	call   c0103d00 <pte2page>
c010493f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104942:	74 24                	je     c0104968 <check_pgdir+0x191>
c0104944:	c7 44 24 0c e1 6c 10 	movl   $0xc0106ce1,0xc(%esp)
c010494b:	c0 
c010494c:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104953:	c0 
c0104954:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c010495b:	00 
c010495c:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104963:	e8 82 c3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 1);
c0104968:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010496b:	89 04 24             	mov    %eax,(%esp)
c010496e:	e8 e7 f3 ff ff       	call   c0103d5a <page_ref>
c0104973:	83 f8 01             	cmp    $0x1,%eax
c0104976:	74 24                	je     c010499c <check_pgdir+0x1c5>
c0104978:	c7 44 24 0c f7 6c 10 	movl   $0xc0106cf7,0xc(%esp)
c010497f:	c0 
c0104980:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104987:	c0 
c0104988:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010498f:	00 
c0104990:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104997:	e8 4e c3 ff ff       	call   c0100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010499c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049a1:	8b 00                	mov    (%eax),%eax
c01049a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ae:	c1 e8 0c             	shr    $0xc,%eax
c01049b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049b4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01049b9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049bc:	72 23                	jb     c01049e1 <check_pgdir+0x20a>
c01049be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049c5:	c7 44 24 08 c4 6a 10 	movl   $0xc0106ac4,0x8(%esp)
c01049cc:	c0 
c01049cd:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01049d4:	00 
c01049d5:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01049dc:	e8 09 c3 ff ff       	call   c0100cea <__panic>
c01049e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049e9:	83 c0 04             	add    $0x4,%eax
c01049ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049ef:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049fb:	00 
c01049fc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a03:	00 
c0104a04:	89 04 24             	mov    %eax,(%esp)
c0104a07:	e8 e2 fb ff ff       	call   c01045ee <get_pte>
c0104a0c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a0f:	74 24                	je     c0104a35 <check_pgdir+0x25e>
c0104a11:	c7 44 24 0c 0c 6d 10 	movl   $0xc0106d0c,0xc(%esp)
c0104a18:	c0 
c0104a19:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104a20:	c0 
c0104a21:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0104a28:	00 
c0104a29:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104a30:	e8 b5 c2 ff ff       	call   c0100cea <__panic>

    p2 = alloc_page();
c0104a35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a3c:	e8 1b f5 ff ff       	call   c0103f5c <alloc_pages>
c0104a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a44:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a49:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a50:	00 
c0104a51:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a58:	00 
c0104a59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a60:	89 04 24             	mov    %eax,(%esp)
c0104a63:	e8 34 fc ff ff       	call   c010469c <page_insert>
c0104a68:	85 c0                	test   %eax,%eax
c0104a6a:	74 24                	je     c0104a90 <check_pgdir+0x2b9>
c0104a6c:	c7 44 24 0c 34 6d 10 	movl   $0xc0106d34,0xc(%esp)
c0104a73:	c0 
c0104a74:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104a7b:	c0 
c0104a7c:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0104a83:	00 
c0104a84:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104a8b:	e8 5a c2 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a90:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a9c:	00 
c0104a9d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104aa4:	00 
c0104aa5:	89 04 24             	mov    %eax,(%esp)
c0104aa8:	e8 41 fb ff ff       	call   c01045ee <get_pte>
c0104aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ab4:	75 24                	jne    c0104ada <check_pgdir+0x303>
c0104ab6:	c7 44 24 0c 6c 6d 10 	movl   $0xc0106d6c,0xc(%esp)
c0104abd:	c0 
c0104abe:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104ac5:	c0 
c0104ac6:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0104acd:	00 
c0104ace:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104ad5:	e8 10 c2 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_U);
c0104ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104add:	8b 00                	mov    (%eax),%eax
c0104adf:	83 e0 04             	and    $0x4,%eax
c0104ae2:	85 c0                	test   %eax,%eax
c0104ae4:	75 24                	jne    c0104b0a <check_pgdir+0x333>
c0104ae6:	c7 44 24 0c 9c 6d 10 	movl   $0xc0106d9c,0xc(%esp)
c0104aed:	c0 
c0104aee:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104af5:	c0 
c0104af6:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104afd:	00 
c0104afe:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104b05:	e8 e0 c1 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_W);
c0104b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b0d:	8b 00                	mov    (%eax),%eax
c0104b0f:	83 e0 02             	and    $0x2,%eax
c0104b12:	85 c0                	test   %eax,%eax
c0104b14:	75 24                	jne    c0104b3a <check_pgdir+0x363>
c0104b16:	c7 44 24 0c aa 6d 10 	movl   $0xc0106daa,0xc(%esp)
c0104b1d:	c0 
c0104b1e:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104b25:	c0 
c0104b26:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104b2d:	00 
c0104b2e:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104b35:	e8 b0 c1 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b3a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b3f:	8b 00                	mov    (%eax),%eax
c0104b41:	83 e0 04             	and    $0x4,%eax
c0104b44:	85 c0                	test   %eax,%eax
c0104b46:	75 24                	jne    c0104b6c <check_pgdir+0x395>
c0104b48:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104b4f:	c0 
c0104b50:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104b57:	c0 
c0104b58:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104b5f:	00 
c0104b60:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104b67:	e8 7e c1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 1);
c0104b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b6f:	89 04 24             	mov    %eax,(%esp)
c0104b72:	e8 e3 f1 ff ff       	call   c0103d5a <page_ref>
c0104b77:	83 f8 01             	cmp    $0x1,%eax
c0104b7a:	74 24                	je     c0104ba0 <check_pgdir+0x3c9>
c0104b7c:	c7 44 24 0c ce 6d 10 	movl   $0xc0106dce,0xc(%esp)
c0104b83:	c0 
c0104b84:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104b8b:	c0 
c0104b8c:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104b93:	00 
c0104b94:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104b9b:	e8 4a c1 ff ff       	call   c0100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104ba0:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ba5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bac:	00 
c0104bad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bb4:	00 
c0104bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bbc:	89 04 24             	mov    %eax,(%esp)
c0104bbf:	e8 d8 fa ff ff       	call   c010469c <page_insert>
c0104bc4:	85 c0                	test   %eax,%eax
c0104bc6:	74 24                	je     c0104bec <check_pgdir+0x415>
c0104bc8:	c7 44 24 0c e0 6d 10 	movl   $0xc0106de0,0xc(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104bd7:	c0 
c0104bd8:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104bdf:	00 
c0104be0:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104be7:	e8 fe c0 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 2);
c0104bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bef:	89 04 24             	mov    %eax,(%esp)
c0104bf2:	e8 63 f1 ff ff       	call   c0103d5a <page_ref>
c0104bf7:	83 f8 02             	cmp    $0x2,%eax
c0104bfa:	74 24                	je     c0104c20 <check_pgdir+0x449>
c0104bfc:	c7 44 24 0c 0c 6e 10 	movl   $0xc0106e0c,0xc(%esp)
c0104c03:	c0 
c0104c04:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104c0b:	c0 
c0104c0c:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104c13:	00 
c0104c14:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104c1b:	e8 ca c0 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c23:	89 04 24             	mov    %eax,(%esp)
c0104c26:	e8 2f f1 ff ff       	call   c0103d5a <page_ref>
c0104c2b:	85 c0                	test   %eax,%eax
c0104c2d:	74 24                	je     c0104c53 <check_pgdir+0x47c>
c0104c2f:	c7 44 24 0c 1e 6e 10 	movl   $0xc0106e1e,0xc(%esp)
c0104c36:	c0 
c0104c37:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104c3e:	c0 
c0104c3f:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104c46:	00 
c0104c47:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104c4e:	e8 97 c0 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c53:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c58:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c5f:	00 
c0104c60:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c67:	00 
c0104c68:	89 04 24             	mov    %eax,(%esp)
c0104c6b:	e8 7e f9 ff ff       	call   c01045ee <get_pte>
c0104c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c77:	75 24                	jne    c0104c9d <check_pgdir+0x4c6>
c0104c79:	c7 44 24 0c 6c 6d 10 	movl   $0xc0106d6c,0xc(%esp)
c0104c80:	c0 
c0104c81:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104c88:	c0 
c0104c89:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104c90:	00 
c0104c91:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104c98:	e8 4d c0 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0104c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca0:	8b 00                	mov    (%eax),%eax
c0104ca2:	89 04 24             	mov    %eax,(%esp)
c0104ca5:	e8 56 f0 ff ff       	call   c0103d00 <pte2page>
c0104caa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104cad:	74 24                	je     c0104cd3 <check_pgdir+0x4fc>
c0104caf:	c7 44 24 0c e1 6c 10 	movl   $0xc0106ce1,0xc(%esp)
c0104cb6:	c0 
c0104cb7:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104cbe:	c0 
c0104cbf:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104cc6:	00 
c0104cc7:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104cce:	e8 17 c0 ff ff       	call   c0100cea <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd6:	8b 00                	mov    (%eax),%eax
c0104cd8:	83 e0 04             	and    $0x4,%eax
c0104cdb:	85 c0                	test   %eax,%eax
c0104cdd:	74 24                	je     c0104d03 <check_pgdir+0x52c>
c0104cdf:	c7 44 24 0c 30 6e 10 	movl   $0xc0106e30,0xc(%esp)
c0104ce6:	c0 
c0104ce7:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104cee:	c0 
c0104cef:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104cf6:	00 
c0104cf7:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104cfe:	e8 e7 bf ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d03:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d0f:	00 
c0104d10:	89 04 24             	mov    %eax,(%esp)
c0104d13:	e8 3d f9 ff ff       	call   c0104655 <page_remove>
    assert(page_ref(p1) == 1);
c0104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1b:	89 04 24             	mov    %eax,(%esp)
c0104d1e:	e8 37 f0 ff ff       	call   c0103d5a <page_ref>
c0104d23:	83 f8 01             	cmp    $0x1,%eax
c0104d26:	74 24                	je     c0104d4c <check_pgdir+0x575>
c0104d28:	c7 44 24 0c f7 6c 10 	movl   $0xc0106cf7,0xc(%esp)
c0104d2f:	c0 
c0104d30:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104d37:	c0 
c0104d38:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104d3f:	00 
c0104d40:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104d47:	e8 9e bf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d4f:	89 04 24             	mov    %eax,(%esp)
c0104d52:	e8 03 f0 ff ff       	call   c0103d5a <page_ref>
c0104d57:	85 c0                	test   %eax,%eax
c0104d59:	74 24                	je     c0104d7f <check_pgdir+0x5a8>
c0104d5b:	c7 44 24 0c 1e 6e 10 	movl   $0xc0106e1e,0xc(%esp)
c0104d62:	c0 
c0104d63:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104d6a:	c0 
c0104d6b:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104d72:	00 
c0104d73:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104d7a:	e8 6b bf ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d7f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d84:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d8b:	00 
c0104d8c:	89 04 24             	mov    %eax,(%esp)
c0104d8f:	e8 c1 f8 ff ff       	call   c0104655 <page_remove>
    assert(page_ref(p1) == 0);
c0104d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d97:	89 04 24             	mov    %eax,(%esp)
c0104d9a:	e8 bb ef ff ff       	call   c0103d5a <page_ref>
c0104d9f:	85 c0                	test   %eax,%eax
c0104da1:	74 24                	je     c0104dc7 <check_pgdir+0x5f0>
c0104da3:	c7 44 24 0c 45 6e 10 	movl   $0xc0106e45,0xc(%esp)
c0104daa:	c0 
c0104dab:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104db2:	c0 
c0104db3:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104dba:	00 
c0104dbb:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104dc2:	e8 23 bf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dca:	89 04 24             	mov    %eax,(%esp)
c0104dcd:	e8 88 ef ff ff       	call   c0103d5a <page_ref>
c0104dd2:	85 c0                	test   %eax,%eax
c0104dd4:	74 24                	je     c0104dfa <check_pgdir+0x623>
c0104dd6:	c7 44 24 0c 1e 6e 10 	movl   $0xc0106e1e,0xc(%esp)
c0104ddd:	c0 
c0104dde:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104de5:	c0 
c0104de6:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104ded:	00 
c0104dee:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104df5:	e8 f0 be ff ff       	call   c0100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104dfa:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104dff:	8b 00                	mov    (%eax),%eax
c0104e01:	89 04 24             	mov    %eax,(%esp)
c0104e04:	e8 37 ef ff ff       	call   c0103d40 <pde2page>
c0104e09:	89 04 24             	mov    %eax,(%esp)
c0104e0c:	e8 49 ef ff ff       	call   c0103d5a <page_ref>
c0104e11:	83 f8 01             	cmp    $0x1,%eax
c0104e14:	74 24                	je     c0104e3a <check_pgdir+0x663>
c0104e16:	c7 44 24 0c 58 6e 10 	movl   $0xc0106e58,0xc(%esp)
c0104e1d:	c0 
c0104e1e:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104e25:	c0 
c0104e26:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104e2d:	00 
c0104e2e:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104e35:	e8 b0 be ff ff       	call   c0100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e3a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e3f:	8b 00                	mov    (%eax),%eax
c0104e41:	89 04 24             	mov    %eax,(%esp)
c0104e44:	e8 f7 ee ff ff       	call   c0103d40 <pde2page>
c0104e49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e50:	00 
c0104e51:	89 04 24             	mov    %eax,(%esp)
c0104e54:	e8 3d f1 ff ff       	call   c0103f96 <free_pages>
    boot_pgdir[0] = 0;
c0104e59:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e64:	c7 04 24 7f 6e 10 c0 	movl   $0xc0106e7f,(%esp)
c0104e6b:	e8 f5 b4 ff ff       	call   c0100365 <cprintf>
}
c0104e70:	90                   	nop
c0104e71:	89 ec                	mov    %ebp,%esp
c0104e73:	5d                   	pop    %ebp
c0104e74:	c3                   	ret    

c0104e75 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e75:	55                   	push   %ebp
c0104e76:	89 e5                	mov    %esp,%ebp
c0104e78:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e82:	e9 ca 00 00 00       	jmp    c0104f51 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e90:	c1 e8 0c             	shr    $0xc,%eax
c0104e93:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e96:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104e9b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104e9e:	72 23                	jb     c0104ec3 <check_boot_pgdir+0x4e>
c0104ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ea7:	c7 44 24 08 c4 6a 10 	movl   $0xc0106ac4,0x8(%esp)
c0104eae:	c0 
c0104eaf:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104eb6:	00 
c0104eb7:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104ebe:	e8 27 be ff ff       	call   c0100cea <__panic>
c0104ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ec6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ecb:	89 c2                	mov    %eax,%edx
c0104ecd:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ed2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ed9:	00 
c0104eda:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ede:	89 04 24             	mov    %eax,(%esp)
c0104ee1:	e8 08 f7 ff ff       	call   c01045ee <get_pte>
c0104ee6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ee9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104eed:	75 24                	jne    c0104f13 <check_boot_pgdir+0x9e>
c0104eef:	c7 44 24 0c 9c 6e 10 	movl   $0xc0106e9c,0xc(%esp)
c0104ef6:	c0 
c0104ef7:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104efe:	c0 
c0104eff:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104f06:	00 
c0104f07:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104f0e:	e8 d7 bd ff ff       	call   c0100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f13:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f16:	8b 00                	mov    (%eax),%eax
c0104f18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f1d:	89 c2                	mov    %eax,%edx
c0104f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f22:	39 c2                	cmp    %eax,%edx
c0104f24:	74 24                	je     c0104f4a <check_boot_pgdir+0xd5>
c0104f26:	c7 44 24 0c d9 6e 10 	movl   $0xc0106ed9,0xc(%esp)
c0104f2d:	c0 
c0104f2e:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104f35:	c0 
c0104f36:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104f3d:	00 
c0104f3e:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104f45:	e8 a0 bd ff ff       	call   c0100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104f4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f54:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104f59:	39 c2                	cmp    %eax,%edx
c0104f5b:	0f 82 26 ff ff ff    	jb     c0104e87 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f61:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f66:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f6b:	8b 00                	mov    (%eax),%eax
c0104f6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f72:	89 c2                	mov    %eax,%edx
c0104f74:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f7c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104f83:	77 23                	ja     c0104fa8 <check_boot_pgdir+0x133>
c0104f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f88:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f8c:	c7 44 24 08 68 6b 10 	movl   $0xc0106b68,0x8(%esp)
c0104f93:	c0 
c0104f94:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104f9b:	00 
c0104f9c:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104fa3:	e8 42 bd ff ff       	call   c0100cea <__panic>
c0104fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fab:	05 00 00 00 40       	add    $0x40000000,%eax
c0104fb0:	39 d0                	cmp    %edx,%eax
c0104fb2:	74 24                	je     c0104fd8 <check_boot_pgdir+0x163>
c0104fb4:	c7 44 24 0c f0 6e 10 	movl   $0xc0106ef0,0xc(%esp)
c0104fbb:	c0 
c0104fbc:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104fc3:	c0 
c0104fc4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104fcb:	00 
c0104fcc:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0104fd3:	e8 12 bd ff ff       	call   c0100cea <__panic>

    assert(boot_pgdir[0] == 0);
c0104fd8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104fdd:	8b 00                	mov    (%eax),%eax
c0104fdf:	85 c0                	test   %eax,%eax
c0104fe1:	74 24                	je     c0105007 <check_boot_pgdir+0x192>
c0104fe3:	c7 44 24 0c 24 6f 10 	movl   $0xc0106f24,0xc(%esp)
c0104fea:	c0 
c0104feb:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0104ff2:	c0 
c0104ff3:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104ffa:	00 
c0104ffb:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0105002:	e8 e3 bc ff ff       	call   c0100cea <__panic>

    struct Page *p;
    p = alloc_page();
c0105007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010500e:	e8 49 ef ff ff       	call   c0103f5c <alloc_pages>
c0105013:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105016:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010501b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105022:	00 
c0105023:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010502a:	00 
c010502b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010502e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105032:	89 04 24             	mov    %eax,(%esp)
c0105035:	e8 62 f6 ff ff       	call   c010469c <page_insert>
c010503a:	85 c0                	test   %eax,%eax
c010503c:	74 24                	je     c0105062 <check_boot_pgdir+0x1ed>
c010503e:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0105045:	c0 
c0105046:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c010504d:	c0 
c010504e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0105055:	00 
c0105056:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c010505d:	e8 88 bc ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 1);
c0105062:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105065:	89 04 24             	mov    %eax,(%esp)
c0105068:	e8 ed ec ff ff       	call   c0103d5a <page_ref>
c010506d:	83 f8 01             	cmp    $0x1,%eax
c0105070:	74 24                	je     c0105096 <check_boot_pgdir+0x221>
c0105072:	c7 44 24 0c 66 6f 10 	movl   $0xc0106f66,0xc(%esp)
c0105079:	c0 
c010507a:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0105081:	c0 
c0105082:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105089:	00 
c010508a:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0105091:	e8 54 bc ff ff       	call   c0100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105096:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010509b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050a2:	00 
c01050a3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050aa:	00 
c01050ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050ae:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050b2:	89 04 24             	mov    %eax,(%esp)
c01050b5:	e8 e2 f5 ff ff       	call   c010469c <page_insert>
c01050ba:	85 c0                	test   %eax,%eax
c01050bc:	74 24                	je     c01050e2 <check_boot_pgdir+0x26d>
c01050be:	c7 44 24 0c 78 6f 10 	movl   $0xc0106f78,0xc(%esp)
c01050c5:	c0 
c01050c6:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c01050cd:	c0 
c01050ce:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c01050d5:	00 
c01050d6:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01050dd:	e8 08 bc ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 2);
c01050e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050e5:	89 04 24             	mov    %eax,(%esp)
c01050e8:	e8 6d ec ff ff       	call   c0103d5a <page_ref>
c01050ed:	83 f8 02             	cmp    $0x2,%eax
c01050f0:	74 24                	je     c0105116 <check_boot_pgdir+0x2a1>
c01050f2:	c7 44 24 0c af 6f 10 	movl   $0xc0106faf,0xc(%esp)
c01050f9:	c0 
c01050fa:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0105101:	c0 
c0105102:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105109:	00 
c010510a:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0105111:	e8 d4 bb ff ff       	call   c0100cea <__panic>

    const char *str = "ucore: Hello world!!";
c0105116:	c7 45 e8 c0 6f 10 c0 	movl   $0xc0106fc0,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010511d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105120:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105124:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010512b:	e8 fc 09 00 00       	call   c0105b2c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105130:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105137:	00 
c0105138:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010513f:	e8 60 0a 00 00       	call   c0105ba4 <strcmp>
c0105144:	85 c0                	test   %eax,%eax
c0105146:	74 24                	je     c010516c <check_boot_pgdir+0x2f7>
c0105148:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c010514f:	c0 
c0105150:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c0105157:	c0 
c0105158:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c010515f:	00 
c0105160:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c0105167:	e8 7e bb ff ff       	call   c0100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010516c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010516f:	89 04 24             	mov    %eax,(%esp)
c0105172:	e8 33 eb ff ff       	call   c0103caa <page2kva>
c0105177:	05 00 01 00 00       	add    $0x100,%eax
c010517c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010517f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105186:	e8 47 09 00 00       	call   c0105ad2 <strlen>
c010518b:	85 c0                	test   %eax,%eax
c010518d:	74 24                	je     c01051b3 <check_boot_pgdir+0x33e>
c010518f:	c7 44 24 0c 10 70 10 	movl   $0xc0107010,0xc(%esp)
c0105196:	c0 
c0105197:	c7 44 24 08 b1 6b 10 	movl   $0xc0106bb1,0x8(%esp)
c010519e:	c0 
c010519f:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01051a6:	00 
c01051a7:	c7 04 24 8c 6b 10 c0 	movl   $0xc0106b8c,(%esp)
c01051ae:	e8 37 bb ff ff       	call   c0100cea <__panic>

    free_page(p);
c01051b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051ba:	00 
c01051bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051be:	89 04 24             	mov    %eax,(%esp)
c01051c1:	e8 d0 ed ff ff       	call   c0103f96 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01051c6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051cb:	8b 00                	mov    (%eax),%eax
c01051cd:	89 04 24             	mov    %eax,(%esp)
c01051d0:	e8 6b eb ff ff       	call   c0103d40 <pde2page>
c01051d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051dc:	00 
c01051dd:	89 04 24             	mov    %eax,(%esp)
c01051e0:	e8 b1 ed ff ff       	call   c0103f96 <free_pages>
    boot_pgdir[0] = 0;
c01051e5:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051f0:	c7 04 24 34 70 10 c0 	movl   $0xc0107034,(%esp)
c01051f7:	e8 69 b1 ff ff       	call   c0100365 <cprintf>
}
c01051fc:	90                   	nop
c01051fd:	89 ec                	mov    %ebp,%esp
c01051ff:	5d                   	pop    %ebp
c0105200:	c3                   	ret    

c0105201 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105201:	55                   	push   %ebp
c0105202:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105204:	8b 45 08             	mov    0x8(%ebp),%eax
c0105207:	83 e0 04             	and    $0x4,%eax
c010520a:	85 c0                	test   %eax,%eax
c010520c:	74 04                	je     c0105212 <perm2str+0x11>
c010520e:	b0 75                	mov    $0x75,%al
c0105210:	eb 02                	jmp    c0105214 <perm2str+0x13>
c0105212:	b0 2d                	mov    $0x2d,%al
c0105214:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0105219:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105220:	8b 45 08             	mov    0x8(%ebp),%eax
c0105223:	83 e0 02             	and    $0x2,%eax
c0105226:	85 c0                	test   %eax,%eax
c0105228:	74 04                	je     c010522e <perm2str+0x2d>
c010522a:	b0 77                	mov    $0x77,%al
c010522c:	eb 02                	jmp    c0105230 <perm2str+0x2f>
c010522e:	b0 2d                	mov    $0x2d,%al
c0105230:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0105235:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c010523c:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c0105241:	5d                   	pop    %ebp
c0105242:	c3                   	ret    

c0105243 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105243:	55                   	push   %ebp
c0105244:	89 e5                	mov    %esp,%ebp
c0105246:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105249:	8b 45 10             	mov    0x10(%ebp),%eax
c010524c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010524f:	72 0d                	jb     c010525e <get_pgtable_items+0x1b>
        return 0;
c0105251:	b8 00 00 00 00       	mov    $0x0,%eax
c0105256:	e9 98 00 00 00       	jmp    c01052f3 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010525b:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010525e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105261:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105264:	73 18                	jae    c010527e <get_pgtable_items+0x3b>
c0105266:	8b 45 10             	mov    0x10(%ebp),%eax
c0105269:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105270:	8b 45 14             	mov    0x14(%ebp),%eax
c0105273:	01 d0                	add    %edx,%eax
c0105275:	8b 00                	mov    (%eax),%eax
c0105277:	83 e0 01             	and    $0x1,%eax
c010527a:	85 c0                	test   %eax,%eax
c010527c:	74 dd                	je     c010525b <get_pgtable_items+0x18>
    }
    if (start < right) {
c010527e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105281:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105284:	73 68                	jae    c01052ee <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105286:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010528a:	74 08                	je     c0105294 <get_pgtable_items+0x51>
            *left_store = start;
c010528c:	8b 45 18             	mov    0x18(%ebp),%eax
c010528f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105292:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105294:	8b 45 10             	mov    0x10(%ebp),%eax
c0105297:	8d 50 01             	lea    0x1(%eax),%edx
c010529a:	89 55 10             	mov    %edx,0x10(%ebp)
c010529d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052a4:	8b 45 14             	mov    0x14(%ebp),%eax
c01052a7:	01 d0                	add    %edx,%eax
c01052a9:	8b 00                	mov    (%eax),%eax
c01052ab:	83 e0 07             	and    $0x7,%eax
c01052ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052b1:	eb 03                	jmp    c01052b6 <get_pgtable_items+0x73>
            start ++;
c01052b3:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052bc:	73 1d                	jae    c01052db <get_pgtable_items+0x98>
c01052be:	8b 45 10             	mov    0x10(%ebp),%eax
c01052c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01052cb:	01 d0                	add    %edx,%eax
c01052cd:	8b 00                	mov    (%eax),%eax
c01052cf:	83 e0 07             	and    $0x7,%eax
c01052d2:	89 c2                	mov    %eax,%edx
c01052d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052d7:	39 c2                	cmp    %eax,%edx
c01052d9:	74 d8                	je     c01052b3 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01052db:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052df:	74 08                	je     c01052e9 <get_pgtable_items+0xa6>
            *right_store = start;
c01052e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052e4:	8b 55 10             	mov    0x10(%ebp),%edx
c01052e7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052ec:	eb 05                	jmp    c01052f3 <get_pgtable_items+0xb0>
    }
    return 0;
c01052ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052f3:	89 ec                	mov    %ebp,%esp
c01052f5:	5d                   	pop    %ebp
c01052f6:	c3                   	ret    

c01052f7 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052f7:	55                   	push   %ebp
c01052f8:	89 e5                	mov    %esp,%ebp
c01052fa:	57                   	push   %edi
c01052fb:	56                   	push   %esi
c01052fc:	53                   	push   %ebx
c01052fd:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105300:	c7 04 24 54 70 10 c0 	movl   $0xc0107054,(%esp)
c0105307:	e8 59 b0 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c010530c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105313:	e9 f2 00 00 00       	jmp    c010540a <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010531b:	89 04 24             	mov    %eax,(%esp)
c010531e:	e8 de fe ff ff       	call   c0105201 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105323:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105326:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105329:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010532b:	89 d6                	mov    %edx,%esi
c010532d:	c1 e6 16             	shl    $0x16,%esi
c0105330:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105333:	89 d3                	mov    %edx,%ebx
c0105335:	c1 e3 16             	shl    $0x16,%ebx
c0105338:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010533b:	89 d1                	mov    %edx,%ecx
c010533d:	c1 e1 16             	shl    $0x16,%ecx
c0105340:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105343:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105346:	29 fa                	sub    %edi,%edx
c0105348:	89 44 24 14          	mov    %eax,0x14(%esp)
c010534c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105350:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105354:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105358:	89 54 24 04          	mov    %edx,0x4(%esp)
c010535c:	c7 04 24 85 70 10 c0 	movl   $0xc0107085,(%esp)
c0105363:	e8 fd af ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0105368:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010536b:	c1 e0 0a             	shl    $0xa,%eax
c010536e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105371:	eb 50                	jmp    c01053c3 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105376:	89 04 24             	mov    %eax,(%esp)
c0105379:	e8 83 fe ff ff       	call   c0105201 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010537e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105381:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105384:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105386:	89 d6                	mov    %edx,%esi
c0105388:	c1 e6 0c             	shl    $0xc,%esi
c010538b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010538e:	89 d3                	mov    %edx,%ebx
c0105390:	c1 e3 0c             	shl    $0xc,%ebx
c0105393:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105396:	89 d1                	mov    %edx,%ecx
c0105398:	c1 e1 0c             	shl    $0xc,%ecx
c010539b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010539e:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01053a1:	29 fa                	sub    %edi,%edx
c01053a3:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053a7:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053b7:	c7 04 24 a4 70 10 c0 	movl   $0xc01070a4,(%esp)
c01053be:	e8 a2 af ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053c3:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01053c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053ce:	89 d3                	mov    %edx,%ebx
c01053d0:	c1 e3 0a             	shl    $0xa,%ebx
c01053d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053d6:	89 d1                	mov    %edx,%ecx
c01053d8:	c1 e1 0a             	shl    $0xa,%ecx
c01053db:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01053de:	89 54 24 14          	mov    %edx,0x14(%esp)
c01053e2:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01053e5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01053e9:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01053ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01053f5:	89 0c 24             	mov    %ecx,(%esp)
c01053f8:	e8 46 fe ff ff       	call   c0105243 <get_pgtable_items>
c01053fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105400:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105404:	0f 85 69 ff ff ff    	jne    c0105373 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010540a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010540f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105412:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105415:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105419:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010541c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105420:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105424:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105428:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010542f:	00 
c0105430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105437:	e8 07 fe ff ff       	call   c0105243 <get_pgtable_items>
c010543c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010543f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105443:	0f 85 cf fe ff ff    	jne    c0105318 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105449:	c7 04 24 c8 70 10 c0 	movl   $0xc01070c8,(%esp)
c0105450:	e8 10 af ff ff       	call   c0100365 <cprintf>
}
c0105455:	90                   	nop
c0105456:	83 c4 4c             	add    $0x4c,%esp
c0105459:	5b                   	pop    %ebx
c010545a:	5e                   	pop    %esi
c010545b:	5f                   	pop    %edi
c010545c:	5d                   	pop    %ebp
c010545d:	c3                   	ret    

c010545e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010545e:	55                   	push   %ebp
c010545f:	89 e5                	mov    %esp,%ebp
c0105461:	83 ec 58             	sub    $0x58,%esp
c0105464:	8b 45 10             	mov    0x10(%ebp),%eax
c0105467:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010546a:	8b 45 14             	mov    0x14(%ebp),%eax
c010546d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105470:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105473:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105476:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105479:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010547c:	8b 45 18             	mov    0x18(%ebp),%eax
c010547f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105482:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105485:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105488:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010548b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010548e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105491:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105498:	74 1c                	je     c01054b6 <printnum+0x58>
c010549a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010549d:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a2:	f7 75 e4             	divl   -0x1c(%ebp)
c01054a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01054b0:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054bc:	f7 75 e4             	divl   -0x1c(%ebp)
c01054bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054d4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054d7:	8b 45 18             	mov    0x18(%ebp),%eax
c01054da:	ba 00 00 00 00       	mov    $0x0,%edx
c01054df:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01054e2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01054e5:	19 d1                	sbb    %edx,%ecx
c01054e7:	72 4c                	jb     c0105535 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054ec:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054ef:	8b 45 20             	mov    0x20(%ebp),%eax
c01054f2:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054f6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01054fd:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105501:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105504:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105507:	89 44 24 08          	mov    %eax,0x8(%esp)
c010550b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010550f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105512:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105516:	8b 45 08             	mov    0x8(%ebp),%eax
c0105519:	89 04 24             	mov    %eax,(%esp)
c010551c:	e8 3d ff ff ff       	call   c010545e <printnum>
c0105521:	eb 1b                	jmp    c010553e <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105523:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105526:	89 44 24 04          	mov    %eax,0x4(%esp)
c010552a:	8b 45 20             	mov    0x20(%ebp),%eax
c010552d:	89 04 24             	mov    %eax,(%esp)
c0105530:	8b 45 08             	mov    0x8(%ebp),%eax
c0105533:	ff d0                	call   *%eax
        while (-- width > 0)
c0105535:	ff 4d 1c             	decl   0x1c(%ebp)
c0105538:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010553c:	7f e5                	jg     c0105523 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010553e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105541:	05 7c 71 10 c0       	add    $0xc010717c,%eax
c0105546:	0f b6 00             	movzbl (%eax),%eax
c0105549:	0f be c0             	movsbl %al,%eax
c010554c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010554f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105553:	89 04 24             	mov    %eax,(%esp)
c0105556:	8b 45 08             	mov    0x8(%ebp),%eax
c0105559:	ff d0                	call   *%eax
}
c010555b:	90                   	nop
c010555c:	89 ec                	mov    %ebp,%esp
c010555e:	5d                   	pop    %ebp
c010555f:	c3                   	ret    

c0105560 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105560:	55                   	push   %ebp
c0105561:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105567:	7e 14                	jle    c010557d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105569:	8b 45 08             	mov    0x8(%ebp),%eax
c010556c:	8b 00                	mov    (%eax),%eax
c010556e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105571:	8b 55 08             	mov    0x8(%ebp),%edx
c0105574:	89 0a                	mov    %ecx,(%edx)
c0105576:	8b 50 04             	mov    0x4(%eax),%edx
c0105579:	8b 00                	mov    (%eax),%eax
c010557b:	eb 30                	jmp    c01055ad <getuint+0x4d>
    }
    else if (lflag) {
c010557d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105581:	74 16                	je     c0105599 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105583:	8b 45 08             	mov    0x8(%ebp),%eax
c0105586:	8b 00                	mov    (%eax),%eax
c0105588:	8d 48 04             	lea    0x4(%eax),%ecx
c010558b:	8b 55 08             	mov    0x8(%ebp),%edx
c010558e:	89 0a                	mov    %ecx,(%edx)
c0105590:	8b 00                	mov    (%eax),%eax
c0105592:	ba 00 00 00 00       	mov    $0x0,%edx
c0105597:	eb 14                	jmp    c01055ad <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105599:	8b 45 08             	mov    0x8(%ebp),%eax
c010559c:	8b 00                	mov    (%eax),%eax
c010559e:	8d 48 04             	lea    0x4(%eax),%ecx
c01055a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a4:	89 0a                	mov    %ecx,(%edx)
c01055a6:	8b 00                	mov    (%eax),%eax
c01055a8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055ad:	5d                   	pop    %ebp
c01055ae:	c3                   	ret    

c01055af <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055af:	55                   	push   %ebp
c01055b0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055b6:	7e 14                	jle    c01055cc <getint+0x1d>
        return va_arg(*ap, long long);
c01055b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bb:	8b 00                	mov    (%eax),%eax
c01055bd:	8d 48 08             	lea    0x8(%eax),%ecx
c01055c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c3:	89 0a                	mov    %ecx,(%edx)
c01055c5:	8b 50 04             	mov    0x4(%eax),%edx
c01055c8:	8b 00                	mov    (%eax),%eax
c01055ca:	eb 28                	jmp    c01055f4 <getint+0x45>
    }
    else if (lflag) {
c01055cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055d0:	74 12                	je     c01055e4 <getint+0x35>
        return va_arg(*ap, long);
c01055d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d5:	8b 00                	mov    (%eax),%eax
c01055d7:	8d 48 04             	lea    0x4(%eax),%ecx
c01055da:	8b 55 08             	mov    0x8(%ebp),%edx
c01055dd:	89 0a                	mov    %ecx,(%edx)
c01055df:	8b 00                	mov    (%eax),%eax
c01055e1:	99                   	cltd   
c01055e2:	eb 10                	jmp    c01055f4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e7:	8b 00                	mov    (%eax),%eax
c01055e9:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ec:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ef:	89 0a                	mov    %ecx,(%edx)
c01055f1:	8b 00                	mov    (%eax),%eax
c01055f3:	99                   	cltd   
    }
}
c01055f4:	5d                   	pop    %ebp
c01055f5:	c3                   	ret    

c01055f6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055f6:	55                   	push   %ebp
c01055f7:	89 e5                	mov    %esp,%ebp
c01055f9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055fc:	8d 45 14             	lea    0x14(%ebp),%eax
c01055ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105605:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105609:	8b 45 10             	mov    0x10(%ebp),%eax
c010560c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105617:	8b 45 08             	mov    0x8(%ebp),%eax
c010561a:	89 04 24             	mov    %eax,(%esp)
c010561d:	e8 05 00 00 00       	call   c0105627 <vprintfmt>
    va_end(ap);
}
c0105622:	90                   	nop
c0105623:	89 ec                	mov    %ebp,%esp
c0105625:	5d                   	pop    %ebp
c0105626:	c3                   	ret    

c0105627 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105627:	55                   	push   %ebp
c0105628:	89 e5                	mov    %esp,%ebp
c010562a:	56                   	push   %esi
c010562b:	53                   	push   %ebx
c010562c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010562f:	eb 17                	jmp    c0105648 <vprintfmt+0x21>
            if (ch == '\0') {
c0105631:	85 db                	test   %ebx,%ebx
c0105633:	0f 84 bf 03 00 00    	je     c01059f8 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105640:	89 1c 24             	mov    %ebx,(%esp)
c0105643:	8b 45 08             	mov    0x8(%ebp),%eax
c0105646:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105648:	8b 45 10             	mov    0x10(%ebp),%eax
c010564b:	8d 50 01             	lea    0x1(%eax),%edx
c010564e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105651:	0f b6 00             	movzbl (%eax),%eax
c0105654:	0f b6 d8             	movzbl %al,%ebx
c0105657:	83 fb 25             	cmp    $0x25,%ebx
c010565a:	75 d5                	jne    c0105631 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010565c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105660:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010566a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010566d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105677:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010567a:	8b 45 10             	mov    0x10(%ebp),%eax
c010567d:	8d 50 01             	lea    0x1(%eax),%edx
c0105680:	89 55 10             	mov    %edx,0x10(%ebp)
c0105683:	0f b6 00             	movzbl (%eax),%eax
c0105686:	0f b6 d8             	movzbl %al,%ebx
c0105689:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010568c:	83 f8 55             	cmp    $0x55,%eax
c010568f:	0f 87 37 03 00 00    	ja     c01059cc <vprintfmt+0x3a5>
c0105695:	8b 04 85 a0 71 10 c0 	mov    -0x3fef8e60(,%eax,4),%eax
c010569c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010569e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056a2:	eb d6                	jmp    c010567a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056a8:	eb d0                	jmp    c010567a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056b4:	89 d0                	mov    %edx,%eax
c01056b6:	c1 e0 02             	shl    $0x2,%eax
c01056b9:	01 d0                	add    %edx,%eax
c01056bb:	01 c0                	add    %eax,%eax
c01056bd:	01 d8                	add    %ebx,%eax
c01056bf:	83 e8 30             	sub    $0x30,%eax
c01056c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c8:	0f b6 00             	movzbl (%eax),%eax
c01056cb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056ce:	83 fb 2f             	cmp    $0x2f,%ebx
c01056d1:	7e 38                	jle    c010570b <vprintfmt+0xe4>
c01056d3:	83 fb 39             	cmp    $0x39,%ebx
c01056d6:	7f 33                	jg     c010570b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c01056d8:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01056db:	eb d4                	jmp    c01056b1 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e0:	8d 50 04             	lea    0x4(%eax),%edx
c01056e3:	89 55 14             	mov    %edx,0x14(%ebp)
c01056e6:	8b 00                	mov    (%eax),%eax
c01056e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056eb:	eb 1f                	jmp    c010570c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01056ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056f1:	79 87                	jns    c010567a <vprintfmt+0x53>
                width = 0;
c01056f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056fa:	e9 7b ff ff ff       	jmp    c010567a <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01056ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105706:	e9 6f ff ff ff       	jmp    c010567a <vprintfmt+0x53>
            goto process_precision;
c010570b:	90                   	nop

        process_precision:
            if (width < 0)
c010570c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105710:	0f 89 64 ff ff ff    	jns    c010567a <vprintfmt+0x53>
                width = precision, precision = -1;
c0105716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105719:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010571c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105723:	e9 52 ff ff ff       	jmp    c010567a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105728:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010572b:	e9 4a ff ff ff       	jmp    c010567a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105730:	8b 45 14             	mov    0x14(%ebp),%eax
c0105733:	8d 50 04             	lea    0x4(%eax),%edx
c0105736:	89 55 14             	mov    %edx,0x14(%ebp)
c0105739:	8b 00                	mov    (%eax),%eax
c010573b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010573e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105742:	89 04 24             	mov    %eax,(%esp)
c0105745:	8b 45 08             	mov    0x8(%ebp),%eax
c0105748:	ff d0                	call   *%eax
            break;
c010574a:	e9 a4 02 00 00       	jmp    c01059f3 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010574f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105752:	8d 50 04             	lea    0x4(%eax),%edx
c0105755:	89 55 14             	mov    %edx,0x14(%ebp)
c0105758:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010575a:	85 db                	test   %ebx,%ebx
c010575c:	79 02                	jns    c0105760 <vprintfmt+0x139>
                err = -err;
c010575e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105760:	83 fb 06             	cmp    $0x6,%ebx
c0105763:	7f 0b                	jg     c0105770 <vprintfmt+0x149>
c0105765:	8b 34 9d 60 71 10 c0 	mov    -0x3fef8ea0(,%ebx,4),%esi
c010576c:	85 f6                	test   %esi,%esi
c010576e:	75 23                	jne    c0105793 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105770:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105774:	c7 44 24 08 8d 71 10 	movl   $0xc010718d,0x8(%esp)
c010577b:	c0 
c010577c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105783:	8b 45 08             	mov    0x8(%ebp),%eax
c0105786:	89 04 24             	mov    %eax,(%esp)
c0105789:	e8 68 fe ff ff       	call   c01055f6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010578e:	e9 60 02 00 00       	jmp    c01059f3 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105793:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105797:	c7 44 24 08 96 71 10 	movl   $0xc0107196,0x8(%esp)
c010579e:	c0 
c010579f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a9:	89 04 24             	mov    %eax,(%esp)
c01057ac:	e8 45 fe ff ff       	call   c01055f6 <printfmt>
            break;
c01057b1:	e9 3d 02 00 00       	jmp    c01059f3 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057b6:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b9:	8d 50 04             	lea    0x4(%eax),%edx
c01057bc:	89 55 14             	mov    %edx,0x14(%ebp)
c01057bf:	8b 30                	mov    (%eax),%esi
c01057c1:	85 f6                	test   %esi,%esi
c01057c3:	75 05                	jne    c01057ca <vprintfmt+0x1a3>
                p = "(null)";
c01057c5:	be 99 71 10 c0       	mov    $0xc0107199,%esi
            }
            if (width > 0 && padc != '-') {
c01057ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057ce:	7e 76                	jle    c0105846 <vprintfmt+0x21f>
c01057d0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057d4:	74 70                	je     c0105846 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057dd:	89 34 24             	mov    %esi,(%esp)
c01057e0:	e8 16 03 00 00       	call   c0105afb <strnlen>
c01057e5:	89 c2                	mov    %eax,%edx
c01057e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057ea:	29 d0                	sub    %edx,%eax
c01057ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ef:	eb 16                	jmp    c0105807 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c01057f1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057fc:	89 04 24             	mov    %eax,(%esp)
c01057ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105802:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105804:	ff 4d e8             	decl   -0x18(%ebp)
c0105807:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010580b:	7f e4                	jg     c01057f1 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010580d:	eb 37                	jmp    c0105846 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010580f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105813:	74 1f                	je     c0105834 <vprintfmt+0x20d>
c0105815:	83 fb 1f             	cmp    $0x1f,%ebx
c0105818:	7e 05                	jle    c010581f <vprintfmt+0x1f8>
c010581a:	83 fb 7e             	cmp    $0x7e,%ebx
c010581d:	7e 15                	jle    c0105834 <vprintfmt+0x20d>
                    putch('?', putdat);
c010581f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105822:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105826:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105830:	ff d0                	call   *%eax
c0105832:	eb 0f                	jmp    c0105843 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105834:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105837:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583b:	89 1c 24             	mov    %ebx,(%esp)
c010583e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105841:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105843:	ff 4d e8             	decl   -0x18(%ebp)
c0105846:	89 f0                	mov    %esi,%eax
c0105848:	8d 70 01             	lea    0x1(%eax),%esi
c010584b:	0f b6 00             	movzbl (%eax),%eax
c010584e:	0f be d8             	movsbl %al,%ebx
c0105851:	85 db                	test   %ebx,%ebx
c0105853:	74 27                	je     c010587c <vprintfmt+0x255>
c0105855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105859:	78 b4                	js     c010580f <vprintfmt+0x1e8>
c010585b:	ff 4d e4             	decl   -0x1c(%ebp)
c010585e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105862:	79 ab                	jns    c010580f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105864:	eb 16                	jmp    c010587c <vprintfmt+0x255>
                putch(' ', putdat);
c0105866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105869:	89 44 24 04          	mov    %eax,0x4(%esp)
c010586d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105874:	8b 45 08             	mov    0x8(%ebp),%eax
c0105877:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105879:	ff 4d e8             	decl   -0x18(%ebp)
c010587c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105880:	7f e4                	jg     c0105866 <vprintfmt+0x23f>
            }
            break;
c0105882:	e9 6c 01 00 00       	jmp    c01059f3 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105887:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010588a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010588e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105891:	89 04 24             	mov    %eax,(%esp)
c0105894:	e8 16 fd ff ff       	call   c01055af <getint>
c0105899:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010589c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010589f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058a5:	85 d2                	test   %edx,%edx
c01058a7:	79 26                	jns    c01058cf <vprintfmt+0x2a8>
                putch('-', putdat);
c01058a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ba:	ff d0                	call   *%eax
                num = -(long long)num;
c01058bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058c2:	f7 d8                	neg    %eax
c01058c4:	83 d2 00             	adc    $0x0,%edx
c01058c7:	f7 da                	neg    %edx
c01058c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058d6:	e9 a8 00 00 00       	jmp    c0105983 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e2:	8d 45 14             	lea    0x14(%ebp),%eax
c01058e5:	89 04 24             	mov    %eax,(%esp)
c01058e8:	e8 73 fc ff ff       	call   c0105560 <getuint>
c01058ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058fa:	e9 84 00 00 00       	jmp    c0105983 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105902:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105906:	8d 45 14             	lea    0x14(%ebp),%eax
c0105909:	89 04 24             	mov    %eax,(%esp)
c010590c:	e8 4f fc ff ff       	call   c0105560 <getuint>
c0105911:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105914:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105917:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010591e:	eb 63                	jmp    c0105983 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105920:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105923:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105927:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010592e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105931:	ff d0                	call   *%eax
            putch('x', putdat);
c0105933:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105936:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105941:	8b 45 08             	mov    0x8(%ebp),%eax
c0105944:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105946:	8b 45 14             	mov    0x14(%ebp),%eax
c0105949:	8d 50 04             	lea    0x4(%eax),%edx
c010594c:	89 55 14             	mov    %edx,0x14(%ebp)
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010595b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105962:	eb 1f                	jmp    c0105983 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105964:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105967:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596b:	8d 45 14             	lea    0x14(%ebp),%eax
c010596e:	89 04 24             	mov    %eax,(%esp)
c0105971:	e8 ea fb ff ff       	call   c0105560 <getuint>
c0105976:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105979:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010597c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105983:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105987:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010598a:	89 54 24 18          	mov    %edx,0x18(%esp)
c010598e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105991:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105995:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105999:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010599c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010599f:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059a3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b1:	89 04 24             	mov    %eax,(%esp)
c01059b4:	e8 a5 fa ff ff       	call   c010545e <printnum>
            break;
c01059b9:	eb 38                	jmp    c01059f3 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c2:	89 1c 24             	mov    %ebx,(%esp)
c01059c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c8:	ff d0                	call   *%eax
            break;
c01059ca:	eb 27                	jmp    c01059f3 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059da:	8b 45 08             	mov    0x8(%ebp),%eax
c01059dd:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059df:	ff 4d 10             	decl   0x10(%ebp)
c01059e2:	eb 03                	jmp    c01059e7 <vprintfmt+0x3c0>
c01059e4:	ff 4d 10             	decl   0x10(%ebp)
c01059e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ea:	48                   	dec    %eax
c01059eb:	0f b6 00             	movzbl (%eax),%eax
c01059ee:	3c 25                	cmp    $0x25,%al
c01059f0:	75 f2                	jne    c01059e4 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c01059f2:	90                   	nop
    while (1) {
c01059f3:	e9 37 fc ff ff       	jmp    c010562f <vprintfmt+0x8>
                return;
c01059f8:	90                   	nop
        }
    }
}
c01059f9:	83 c4 40             	add    $0x40,%esp
c01059fc:	5b                   	pop    %ebx
c01059fd:	5e                   	pop    %esi
c01059fe:	5d                   	pop    %ebp
c01059ff:	c3                   	ret    

c0105a00 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a00:	55                   	push   %ebp
c0105a01:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a06:	8b 40 08             	mov    0x8(%eax),%eax
c0105a09:	8d 50 01             	lea    0x1(%eax),%edx
c0105a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a15:	8b 10                	mov    (%eax),%edx
c0105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1a:	8b 40 04             	mov    0x4(%eax),%eax
c0105a1d:	39 c2                	cmp    %eax,%edx
c0105a1f:	73 12                	jae    c0105a33 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a24:	8b 00                	mov    (%eax),%eax
c0105a26:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a29:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a2c:	89 0a                	mov    %ecx,(%edx)
c0105a2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a31:	88 10                	mov    %dl,(%eax)
    }
}
c0105a33:	90                   	nop
c0105a34:	5d                   	pop    %ebp
c0105a35:	c3                   	ret    

c0105a36 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a36:	55                   	push   %ebp
c0105a37:	89 e5                	mov    %esp,%ebp
c0105a39:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a3c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a45:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a49:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5a:	89 04 24             	mov    %eax,(%esp)
c0105a5d:	e8 0a 00 00 00       	call   c0105a6c <vsnprintf>
c0105a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a68:	89 ec                	mov    %ebp,%esp
c0105a6a:	5d                   	pop    %ebp
c0105a6b:	c3                   	ret    

c0105a6c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a6c:	55                   	push   %ebp
c0105a6d:	89 e5                	mov    %esp,%ebp
c0105a6f:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a81:	01 d0                	add    %edx,%eax
c0105a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a91:	74 0a                	je     c0105a9d <vsnprintf+0x31>
c0105a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a99:	39 c2                	cmp    %eax,%edx
c0105a9b:	76 07                	jbe    c0105aa4 <vsnprintf+0x38>
        return -E_INVAL;
c0105a9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105aa2:	eb 2a                	jmp    c0105ace <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105aa4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aab:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aae:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ab2:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab9:	c7 04 24 00 5a 10 c0 	movl   $0xc0105a00,(%esp)
c0105ac0:	e8 62 fb ff ff       	call   c0105627 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ac8:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ace:	89 ec                	mov    %ebp,%esp
c0105ad0:	5d                   	pop    %ebp
c0105ad1:	c3                   	ret    

c0105ad2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105ad2:	55                   	push   %ebp
c0105ad3:	89 e5                	mov    %esp,%ebp
c0105ad5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105adf:	eb 03                	jmp    c0105ae4 <strlen+0x12>
        cnt ++;
c0105ae1:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae7:	8d 50 01             	lea    0x1(%eax),%edx
c0105aea:	89 55 08             	mov    %edx,0x8(%ebp)
c0105aed:	0f b6 00             	movzbl (%eax),%eax
c0105af0:	84 c0                	test   %al,%al
c0105af2:	75 ed                	jne    c0105ae1 <strlen+0xf>
    }
    return cnt;
c0105af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105af7:	89 ec                	mov    %ebp,%esp
c0105af9:	5d                   	pop    %ebp
c0105afa:	c3                   	ret    

c0105afb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105afb:	55                   	push   %ebp
c0105afc:	89 e5                	mov    %esp,%ebp
c0105afe:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b08:	eb 03                	jmp    c0105b0d <strnlen+0x12>
        cnt ++;
c0105b0a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b10:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b13:	73 10                	jae    c0105b25 <strnlen+0x2a>
c0105b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b18:	8d 50 01             	lea    0x1(%eax),%edx
c0105b1b:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b1e:	0f b6 00             	movzbl (%eax),%eax
c0105b21:	84 c0                	test   %al,%al
c0105b23:	75 e5                	jne    c0105b0a <strnlen+0xf>
    }
    return cnt;
c0105b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b28:	89 ec                	mov    %ebp,%esp
c0105b2a:	5d                   	pop    %ebp
c0105b2b:	c3                   	ret    

c0105b2c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b2c:	55                   	push   %ebp
c0105b2d:	89 e5                	mov    %esp,%ebp
c0105b2f:	57                   	push   %edi
c0105b30:	56                   	push   %esi
c0105b31:	83 ec 20             	sub    $0x20,%esp
c0105b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b46:	89 d1                	mov    %edx,%ecx
c0105b48:	89 c2                	mov    %eax,%edx
c0105b4a:	89 ce                	mov    %ecx,%esi
c0105b4c:	89 d7                	mov    %edx,%edi
c0105b4e:	ac                   	lods   %ds:(%esi),%al
c0105b4f:	aa                   	stos   %al,%es:(%edi)
c0105b50:	84 c0                	test   %al,%al
c0105b52:	75 fa                	jne    c0105b4e <strcpy+0x22>
c0105b54:	89 fa                	mov    %edi,%edx
c0105b56:	89 f1                	mov    %esi,%ecx
c0105b58:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b5b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b64:	83 c4 20             	add    $0x20,%esp
c0105b67:	5e                   	pop    %esi
c0105b68:	5f                   	pop    %edi
c0105b69:	5d                   	pop    %ebp
c0105b6a:	c3                   	ret    

c0105b6b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b6b:	55                   	push   %ebp
c0105b6c:	89 e5                	mov    %esp,%ebp
c0105b6e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b77:	eb 1e                	jmp    c0105b97 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7c:	0f b6 10             	movzbl (%eax),%edx
c0105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b82:	88 10                	mov    %dl,(%eax)
c0105b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b87:	0f b6 00             	movzbl (%eax),%eax
c0105b8a:	84 c0                	test   %al,%al
c0105b8c:	74 03                	je     c0105b91 <strncpy+0x26>
            src ++;
c0105b8e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105b91:	ff 45 fc             	incl   -0x4(%ebp)
c0105b94:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105b97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b9b:	75 dc                	jne    c0105b79 <strncpy+0xe>
    }
    return dst;
c0105b9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ba0:	89 ec                	mov    %ebp,%esp
c0105ba2:	5d                   	pop    %ebp
c0105ba3:	c3                   	ret    

c0105ba4 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105ba4:	55                   	push   %ebp
c0105ba5:	89 e5                	mov    %esp,%ebp
c0105ba7:	57                   	push   %edi
c0105ba8:	56                   	push   %esi
c0105ba9:	83 ec 20             	sub    $0x20,%esp
c0105bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bbe:	89 d1                	mov    %edx,%ecx
c0105bc0:	89 c2                	mov    %eax,%edx
c0105bc2:	89 ce                	mov    %ecx,%esi
c0105bc4:	89 d7                	mov    %edx,%edi
c0105bc6:	ac                   	lods   %ds:(%esi),%al
c0105bc7:	ae                   	scas   %es:(%edi),%al
c0105bc8:	75 08                	jne    c0105bd2 <strcmp+0x2e>
c0105bca:	84 c0                	test   %al,%al
c0105bcc:	75 f8                	jne    c0105bc6 <strcmp+0x22>
c0105bce:	31 c0                	xor    %eax,%eax
c0105bd0:	eb 04                	jmp    c0105bd6 <strcmp+0x32>
c0105bd2:	19 c0                	sbb    %eax,%eax
c0105bd4:	0c 01                	or     $0x1,%al
c0105bd6:	89 fa                	mov    %edi,%edx
c0105bd8:	89 f1                	mov    %esi,%ecx
c0105bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bdd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105be0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105be6:	83 c4 20             	add    $0x20,%esp
c0105be9:	5e                   	pop    %esi
c0105bea:	5f                   	pop    %edi
c0105beb:	5d                   	pop    %ebp
c0105bec:	c3                   	ret    

c0105bed <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bed:	55                   	push   %ebp
c0105bee:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bf0:	eb 09                	jmp    c0105bfb <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105bf2:	ff 4d 10             	decl   0x10(%ebp)
c0105bf5:	ff 45 08             	incl   0x8(%ebp)
c0105bf8:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bff:	74 1a                	je     c0105c1b <strncmp+0x2e>
c0105c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c04:	0f b6 00             	movzbl (%eax),%eax
c0105c07:	84 c0                	test   %al,%al
c0105c09:	74 10                	je     c0105c1b <strncmp+0x2e>
c0105c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0e:	0f b6 10             	movzbl (%eax),%edx
c0105c11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c14:	0f b6 00             	movzbl (%eax),%eax
c0105c17:	38 c2                	cmp    %al,%dl
c0105c19:	74 d7                	je     c0105bf2 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c1f:	74 18                	je     c0105c39 <strncmp+0x4c>
c0105c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c24:	0f b6 00             	movzbl (%eax),%eax
c0105c27:	0f b6 d0             	movzbl %al,%edx
c0105c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c2d:	0f b6 00             	movzbl (%eax),%eax
c0105c30:	0f b6 c8             	movzbl %al,%ecx
c0105c33:	89 d0                	mov    %edx,%eax
c0105c35:	29 c8                	sub    %ecx,%eax
c0105c37:	eb 05                	jmp    c0105c3e <strncmp+0x51>
c0105c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c3e:	5d                   	pop    %ebp
c0105c3f:	c3                   	ret    

c0105c40 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c40:	55                   	push   %ebp
c0105c41:	89 e5                	mov    %esp,%ebp
c0105c43:	83 ec 04             	sub    $0x4,%esp
c0105c46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c49:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c4c:	eb 13                	jmp    c0105c61 <strchr+0x21>
        if (*s == c) {
c0105c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c51:	0f b6 00             	movzbl (%eax),%eax
c0105c54:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c57:	75 05                	jne    c0105c5e <strchr+0x1e>
            return (char *)s;
c0105c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5c:	eb 12                	jmp    c0105c70 <strchr+0x30>
        }
        s ++;
c0105c5e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c64:	0f b6 00             	movzbl (%eax),%eax
c0105c67:	84 c0                	test   %al,%al
c0105c69:	75 e3                	jne    c0105c4e <strchr+0xe>
    }
    return NULL;
c0105c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c70:	89 ec                	mov    %ebp,%esp
c0105c72:	5d                   	pop    %ebp
c0105c73:	c3                   	ret    

c0105c74 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c74:	55                   	push   %ebp
c0105c75:	89 e5                	mov    %esp,%ebp
c0105c77:	83 ec 04             	sub    $0x4,%esp
c0105c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c7d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c80:	eb 0e                	jmp    c0105c90 <strfind+0x1c>
        if (*s == c) {
c0105c82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c85:	0f b6 00             	movzbl (%eax),%eax
c0105c88:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c8b:	74 0f                	je     c0105c9c <strfind+0x28>
            break;
        }
        s ++;
c0105c8d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c93:	0f b6 00             	movzbl (%eax),%eax
c0105c96:	84 c0                	test   %al,%al
c0105c98:	75 e8                	jne    c0105c82 <strfind+0xe>
c0105c9a:	eb 01                	jmp    c0105c9d <strfind+0x29>
            break;
c0105c9c:	90                   	nop
    }
    return (char *)s;
c0105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ca0:	89 ec                	mov    %ebp,%esp
c0105ca2:	5d                   	pop    %ebp
c0105ca3:	c3                   	ret    

c0105ca4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ca4:	55                   	push   %ebp
c0105ca5:	89 e5                	mov    %esp,%ebp
c0105ca7:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cb8:	eb 03                	jmp    c0105cbd <strtol+0x19>
        s ++;
c0105cba:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc0:	0f b6 00             	movzbl (%eax),%eax
c0105cc3:	3c 20                	cmp    $0x20,%al
c0105cc5:	74 f3                	je     c0105cba <strtol+0x16>
c0105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cca:	0f b6 00             	movzbl (%eax),%eax
c0105ccd:	3c 09                	cmp    $0x9,%al
c0105ccf:	74 e9                	je     c0105cba <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105cd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd4:	0f b6 00             	movzbl (%eax),%eax
c0105cd7:	3c 2b                	cmp    $0x2b,%al
c0105cd9:	75 05                	jne    c0105ce0 <strtol+0x3c>
        s ++;
c0105cdb:	ff 45 08             	incl   0x8(%ebp)
c0105cde:	eb 14                	jmp    c0105cf4 <strtol+0x50>
    }
    else if (*s == '-') {
c0105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce3:	0f b6 00             	movzbl (%eax),%eax
c0105ce6:	3c 2d                	cmp    $0x2d,%al
c0105ce8:	75 0a                	jne    c0105cf4 <strtol+0x50>
        s ++, neg = 1;
c0105cea:	ff 45 08             	incl   0x8(%ebp)
c0105ced:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cf8:	74 06                	je     c0105d00 <strtol+0x5c>
c0105cfa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cfe:	75 22                	jne    c0105d22 <strtol+0x7e>
c0105d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d03:	0f b6 00             	movzbl (%eax),%eax
c0105d06:	3c 30                	cmp    $0x30,%al
c0105d08:	75 18                	jne    c0105d22 <strtol+0x7e>
c0105d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0d:	40                   	inc    %eax
c0105d0e:	0f b6 00             	movzbl (%eax),%eax
c0105d11:	3c 78                	cmp    $0x78,%al
c0105d13:	75 0d                	jne    c0105d22 <strtol+0x7e>
        s += 2, base = 16;
c0105d15:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d19:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d20:	eb 29                	jmp    c0105d4b <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d26:	75 16                	jne    c0105d3e <strtol+0x9a>
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2b:	0f b6 00             	movzbl (%eax),%eax
c0105d2e:	3c 30                	cmp    $0x30,%al
c0105d30:	75 0c                	jne    c0105d3e <strtol+0x9a>
        s ++, base = 8;
c0105d32:	ff 45 08             	incl   0x8(%ebp)
c0105d35:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d3c:	eb 0d                	jmp    c0105d4b <strtol+0xa7>
    }
    else if (base == 0) {
c0105d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d42:	75 07                	jne    c0105d4b <strtol+0xa7>
        base = 10;
c0105d44:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4e:	0f b6 00             	movzbl (%eax),%eax
c0105d51:	3c 2f                	cmp    $0x2f,%al
c0105d53:	7e 1b                	jle    c0105d70 <strtol+0xcc>
c0105d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d58:	0f b6 00             	movzbl (%eax),%eax
c0105d5b:	3c 39                	cmp    $0x39,%al
c0105d5d:	7f 11                	jg     c0105d70 <strtol+0xcc>
            dig = *s - '0';
c0105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d62:	0f b6 00             	movzbl (%eax),%eax
c0105d65:	0f be c0             	movsbl %al,%eax
c0105d68:	83 e8 30             	sub    $0x30,%eax
c0105d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d6e:	eb 48                	jmp    c0105db8 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d73:	0f b6 00             	movzbl (%eax),%eax
c0105d76:	3c 60                	cmp    $0x60,%al
c0105d78:	7e 1b                	jle    c0105d95 <strtol+0xf1>
c0105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7d:	0f b6 00             	movzbl (%eax),%eax
c0105d80:	3c 7a                	cmp    $0x7a,%al
c0105d82:	7f 11                	jg     c0105d95 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d87:	0f b6 00             	movzbl (%eax),%eax
c0105d8a:	0f be c0             	movsbl %al,%eax
c0105d8d:	83 e8 57             	sub    $0x57,%eax
c0105d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d93:	eb 23                	jmp    c0105db8 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d98:	0f b6 00             	movzbl (%eax),%eax
c0105d9b:	3c 40                	cmp    $0x40,%al
c0105d9d:	7e 3b                	jle    c0105dda <strtol+0x136>
c0105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da2:	0f b6 00             	movzbl (%eax),%eax
c0105da5:	3c 5a                	cmp    $0x5a,%al
c0105da7:	7f 31                	jg     c0105dda <strtol+0x136>
            dig = *s - 'A' + 10;
c0105da9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dac:	0f b6 00             	movzbl (%eax),%eax
c0105daf:	0f be c0             	movsbl %al,%eax
c0105db2:	83 e8 37             	sub    $0x37,%eax
c0105db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dbb:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105dbe:	7d 19                	jge    c0105dd9 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105dc0:	ff 45 08             	incl   0x8(%ebp)
c0105dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dc6:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dca:	89 c2                	mov    %eax,%edx
c0105dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dcf:	01 d0                	add    %edx,%eax
c0105dd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105dd4:	e9 72 ff ff ff       	jmp    c0105d4b <strtol+0xa7>
            break;
c0105dd9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dde:	74 08                	je     c0105de8 <strtol+0x144>
        *endptr = (char *) s;
c0105de0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de3:	8b 55 08             	mov    0x8(%ebp),%edx
c0105de6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105de8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dec:	74 07                	je     c0105df5 <strtol+0x151>
c0105dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105df1:	f7 d8                	neg    %eax
c0105df3:	eb 03                	jmp    c0105df8 <strtol+0x154>
c0105df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105df8:	89 ec                	mov    %ebp,%esp
c0105dfa:	5d                   	pop    %ebp
c0105dfb:	c3                   	ret    

c0105dfc <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105dfc:	55                   	push   %ebp
c0105dfd:	89 e5                	mov    %esp,%ebp
c0105dff:	83 ec 28             	sub    $0x28,%esp
c0105e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105e05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e08:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e0b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e12:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105e15:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105e18:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e21:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e25:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e28:	89 d7                	mov    %edx,%edi
c0105e2a:	f3 aa                	rep stos %al,%es:(%edi)
c0105e2c:	89 fa                	mov    %edi,%edx
c0105e2e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e31:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e37:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105e3a:	89 ec                	mov    %ebp,%esp
c0105e3c:	5d                   	pop    %ebp
c0105e3d:	c3                   	ret    

c0105e3e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e3e:	55                   	push   %ebp
c0105e3f:	89 e5                	mov    %esp,%ebp
c0105e41:	57                   	push   %edi
c0105e42:	56                   	push   %esi
c0105e43:	53                   	push   %ebx
c0105e44:	83 ec 30             	sub    $0x30,%esp
c0105e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e50:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e53:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e56:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e5f:	73 42                	jae    c0105ea3 <memmove+0x65>
c0105e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e70:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e76:	c1 e8 02             	shr    $0x2,%eax
c0105e79:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e81:	89 d7                	mov    %edx,%edi
c0105e83:	89 c6                	mov    %eax,%esi
c0105e85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e87:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e8a:	83 e1 03             	and    $0x3,%ecx
c0105e8d:	74 02                	je     c0105e91 <memmove+0x53>
c0105e8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e91:	89 f0                	mov    %esi,%eax
c0105e93:	89 fa                	mov    %edi,%edx
c0105e95:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105ea1:	eb 36                	jmp    c0105ed9 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eac:	01 c2                	add    %eax,%edx
c0105eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ebd:	89 c1                	mov    %eax,%ecx
c0105ebf:	89 d8                	mov    %ebx,%eax
c0105ec1:	89 d6                	mov    %edx,%esi
c0105ec3:	89 c7                	mov    %eax,%edi
c0105ec5:	fd                   	std    
c0105ec6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ec8:	fc                   	cld    
c0105ec9:	89 f8                	mov    %edi,%eax
c0105ecb:	89 f2                	mov    %esi,%edx
c0105ecd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ed0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ed3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ed9:	83 c4 30             	add    $0x30,%esp
c0105edc:	5b                   	pop    %ebx
c0105edd:	5e                   	pop    %esi
c0105ede:	5f                   	pop    %edi
c0105edf:	5d                   	pop    %ebp
c0105ee0:	c3                   	ret    

c0105ee1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ee1:	55                   	push   %ebp
c0105ee2:	89 e5                	mov    %esp,%ebp
c0105ee4:	57                   	push   %edi
c0105ee5:	56                   	push   %esi
c0105ee6:	83 ec 20             	sub    $0x20,%esp
c0105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ef5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105efe:	c1 e8 02             	shr    $0x2,%eax
c0105f01:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f09:	89 d7                	mov    %edx,%edi
c0105f0b:	89 c6                	mov    %eax,%esi
c0105f0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f0f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f12:	83 e1 03             	and    $0x3,%ecx
c0105f15:	74 02                	je     c0105f19 <memcpy+0x38>
c0105f17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f19:	89 f0                	mov    %esi,%eax
c0105f1b:	89 fa                	mov    %edi,%edx
c0105f1d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f20:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f23:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f29:	83 c4 20             	add    $0x20,%esp
c0105f2c:	5e                   	pop    %esi
c0105f2d:	5f                   	pop    %edi
c0105f2e:	5d                   	pop    %ebp
c0105f2f:	c3                   	ret    

c0105f30 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f30:	55                   	push   %ebp
c0105f31:	89 e5                	mov    %esp,%ebp
c0105f33:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f42:	eb 2e                	jmp    c0105f72 <memcmp+0x42>
        if (*s1 != *s2) {
c0105f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f47:	0f b6 10             	movzbl (%eax),%edx
c0105f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f4d:	0f b6 00             	movzbl (%eax),%eax
c0105f50:	38 c2                	cmp    %al,%dl
c0105f52:	74 18                	je     c0105f6c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f57:	0f b6 00             	movzbl (%eax),%eax
c0105f5a:	0f b6 d0             	movzbl %al,%edx
c0105f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f60:	0f b6 00             	movzbl (%eax),%eax
c0105f63:	0f b6 c8             	movzbl %al,%ecx
c0105f66:	89 d0                	mov    %edx,%eax
c0105f68:	29 c8                	sub    %ecx,%eax
c0105f6a:	eb 18                	jmp    c0105f84 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105f6c:	ff 45 fc             	incl   -0x4(%ebp)
c0105f6f:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105f72:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f75:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f78:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f7b:	85 c0                	test   %eax,%eax
c0105f7d:	75 c5                	jne    c0105f44 <memcmp+0x14>
    }
    return 0;
c0105f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f84:	89 ec                	mov    %ebp,%esp
c0105f86:	5d                   	pop    %ebp
c0105f87:	c3                   	ret    
