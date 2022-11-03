
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
c0100059:	e8 95 5d 00 00       	call   c0105df3 <memset>

    cons_init(); // init the console
c010005e:	e8 f9 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 80 5f 10 c0 	movl   $0xc0105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 95 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init(); // init physical memory management
c0100087:	e8 57 44 00 00       	call   c01044e3 <pmm_init>

    pic_init(); // init interrupt controller
c010008c:	e8 4c 17 00 00       	call   c01017dd <pic_init>
    idt_init(); // init interrupt descriptor table
c0100091:	e8 b0 18 00 00       	call   c0101946 <idt_init>

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
c010016c:	c7 04 24 a1 5f 10 c0 	movl   $0xc0105fa1,(%esp)
c0100173:	e8 ed 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	89 c2                	mov    %eax,%edx
c010017e:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100183:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100187:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018b:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c0100192:	e8 ce 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100197:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019b:	89 c2                	mov    %eax,%edx
c010019d:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001aa:	c7 04 24 bd 5f 10 c0 	movl   $0xc0105fbd,(%esp)
c01001b1:	e8 af 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ba:	89 c2                	mov    %eax,%edx
c01001bc:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c9:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c01001d0:	e8 90 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d9:	89 c2                	mov    %eax,%edx
c01001db:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e8:	c7 04 24 d9 5f 10 c0 	movl   $0xc0105fd9,(%esp)
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
c0100225:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 ce ff ff ff       	call   c0100204 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 09 ff ff ff       	call   c0100144 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
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
c0100269:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
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
c0100359:	e8 c0 52 00 00       	call   c010561e <vprintfmt>
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
c0100569:	c7 00 2c 60 10 c0    	movl   $0xc010602c,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 2c 60 10 c0 	movl   $0xc010602c,0x8(%eax)
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
c01005a0:	c7 45 f4 b8 72 10 c0 	movl   $0xc01072b8,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 ec 28 11 c0 	movl   $0xc01128ec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec ed 28 11 c0 	movl   $0xc01128ed,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 67 5e 11 c0 	movl   $0xc0115e67,-0x18(%ebp)

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
c0100708:	e8 5e 55 00 00       	call   c0105c6b <strfind>
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
c010088e:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 7f 5f 10 	movl   $0xc0105f7f,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 7f 60 10 c0 	movl   $0xc010607f,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 2c bf 11 	movl   $0xc011bf2c,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 97 60 10 c0 	movl   $0xc0106097,(%esp)
c01008e5:	e8 7b fa ff ff       	call   c0100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
c01008ea:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c01008ef:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ff:	85 c0                	test   %eax,%eax
c0100901:	0f 48 c2             	cmovs  %edx,%eax
c0100904:	c1 f8 0a             	sar    $0xa,%eax
c0100907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090b:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
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
c0100942:	c7 04 24 da 60 10 c0 	movl   $0xc01060da,(%esp)
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
c01009b0:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
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
c0100a07:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
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
c0100a3a:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100a41:	e8 1f f9 ff ff       	call   c0100365 <cprintf>
        for (j = 0; j < 4; j++)
c0100a46:	ff 45 e8             	incl   -0x18(%ebp)
c0100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4d:	7e d6                	jle    c0100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a4f:	c7 04 24 2c 61 10 c0 	movl   $0xc010612c,(%esp)
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
c0100ac4:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100acb:	e8 67 51 00 00       	call   c0105c37 <strchr>
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
c0100aec:	c7 04 24 b5 61 10 c0 	movl   $0xc01061b5,(%esp)
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
c0100b2e:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100b35:	e8 fd 50 00 00       	call   c0105c37 <strchr>
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
c0100b91:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 f7 4f 00 00       	call   c0105b9b <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 31                	jne    c0100bd9 <runcmd+0x8e>
        {
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
c0100beb:	c7 04 24 d3 61 10 c0 	movl   $0xc01061d3,(%esp)
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
c0100c09:	c7 04 24 ec 61 10 c0 	movl   $0xc01061ec,(%esp)
c0100c10:	e8 50 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c15:	c7 04 24 14 62 10 c0 	movl   $0xc0106214,(%esp)
c0100c1c:	e8 44 f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL)
c0100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c25:	74 0b                	je     c0100c32 <kmonitor+0x2f>
    {
        print_trapframe(tf);
c0100c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2a:	89 04 24             	mov    %eax,(%esp)
c0100c2d:	e8 ce 0e 00 00       	call   c0101b00 <print_trapframe>
    }

    char *buf;
    while (1)
    {
        if ((buf = readline("K> ")) != NULL)
c0100c32:	c7 04 24 39 62 10 c0 	movl   $0xc0106239,(%esp)
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
c0100ca2:	c7 04 24 3d 62 10 c0 	movl   $0xc010623d,(%esp)
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
c0100cf0:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100cf5:	85 c0                	test   %eax,%eax
c0100cf7:	75 5b                	jne    c0100d54 <__panic+0x6a>
    {
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
c0100d17:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c0100d1e:	e8 42 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2d:	89 04 24             	mov    %eax,(%esp)
c0100d30:	e8 fb f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d35:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d3c:	e8 24 f6 ff ff       	call   c0100365 <cprintf>

    cprintf("stack trackback:\n");
c0100d41:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
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
c0100d82:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
c0100d89:	e8 d7 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d95:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d98:	89 04 24             	mov    %eax,(%esp)
c0100d9b:	e8 90 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da0:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
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
c0100db4:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
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
c0100dfd:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e07:	c7 04 24 94 62 10 c0 	movl   $0xc0106294,(%esp)
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
c0100ee7:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
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
c0100efc:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f05:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
c0100f44:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
c0101047:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
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
c010106c:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
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
c0101185:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010118c:	85 c0                	test   %eax,%eax
c010118e:	0f 84 af 00 00 00    	je     c0101243 <cga_putc+0xfd>
        {
            crt_pos--;
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
        crt_buf[crt_pos++] = c; // write the character
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
    if (crt_pos >= CRT_SIZE)
c0101244:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101250:	76 5e                	jbe    c01012b0 <cga_putc+0x16a>
    {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101252:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125d:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101269:	00 
c010126a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126e:	89 04 24             	mov    %eax,(%esp)
c0101271:	e8 bf 4b 00 00       	call   c0105e35 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
c0101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127d:	eb 15                	jmp    c0101294 <cga_putc+0x14e>
        {
            crt_buf[i] = 0x0700 | ' ';
c010127f:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
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
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
c01012eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012f3:	ee                   	out    %al,(%dx)
}
c01012f4:	90                   	nop
    outb(addr_6845, 15);
c01012f5:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile("outb %0, %1" ::"a"(data), "d"(port)
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
c01013e8:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013ed:	8d 50 01             	lea    0x1(%eax),%edx
c01013f0:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c01013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f9:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE)
c01013ff:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101404:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101409:	75 0a                	jne    c0101415 <cons_intr+0x3b>
            {
                cons.wpos = 0;
c010140b:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
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
c0101488:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
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
c01014eb:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014f0:	83 c8 40             	or     $0x40,%eax
c01014f3:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
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
    }
    else if (shift & E0ESC)
c010154f:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101554:	83 e0 40             	and    $0x40,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	74 11                	je     c010156c <kbd_proc_data+0xca>
    {
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
    if (shift & CAPSLOCK)
c01015be:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
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
c01015ec:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015f1:	f7 d0                	not    %eax
c01015f3:	83 e0 06             	and    $0x6,%eax
c01015f6:	85 c0                	test   %eax,%eax
c01015f8:	75 28                	jne    c0101622 <kbd_proc_data+0x180>
c01015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101601:	75 1f                	jne    c0101622 <kbd_proc_data+0x180>
    {
        cprintf("Rebooting!\n");
c0101603:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
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
c0101671:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101676:	85 c0                	test   %eax,%eax
c0101678:	75 0c                	jne    c0101686 <cons_init+0x2a>
    {
        cprintf("serial port does not exist!!\n");
c010167a:	c7 04 24 bb 62 10 c0 	movl   $0xc01062bb,(%esp)
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
c01016e9:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c01016ef:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01016f4:	39 c2                	cmp    %eax,%edx
c01016f6:	74 31                	je     c0101729 <cons_getc+0x5f>
        {
            c = cons.buf[cons.rpos++];
c01016f8:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016fd:	8d 50 01             	lea    0x1(%eax),%edx
c0101700:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101706:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE)
c0101713:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101718:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171d:	75 0a                	jne    c0101729 <cons_getc+0x5f>
            {
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
c010175b:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init)
c0101761:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
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
void pic_init(void)
{
c01017dd:	55                   	push   %ebp
c01017de:	89 e5                	mov    %esp,%ebp
c01017e0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017e3:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
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
c0101905:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c010190c:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101911:	74 0f                	je     c0101922 <pic_init+0x145>
    {
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
c0101935:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c010193c:	e8 24 ea ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101941:	90                   	nop
c0101942:	89 ec                	mov    %ebp,%esp
c0101944:	5d                   	pop    %ebp
c0101945:	c3                   	ret    

c0101946 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
c0101946:	55                   	push   %ebp
c0101947:	89 e5                	mov    %esp,%ebp
c0101949:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
c010194c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101953:	e9 c4 00 00 00       	jmp    c0101a1c <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101962:	0f b7 d0             	movzwl %ax,%edx
c0101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101968:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c010196f:	c0 
c0101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101973:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c010197a:	c0 08 00 
c010197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101980:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c0101987:	c0 
c0101988:	80 e2 e0             	and    $0xe0,%dl
c010198b:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c0101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101995:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c010199c:	c0 
c010199d:	80 e2 1f             	and    $0x1f,%dl
c01019a0:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019aa:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019b1:	c0 
c01019b2:	80 e2 f0             	and    $0xf0,%dl
c01019b5:	80 ca 0e             	or     $0xe,%dl
c01019b8:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c2:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019c9:	c0 
c01019ca:	80 e2 ef             	and    $0xef,%dl
c01019cd:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d7:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019de:	c0 
c01019df:	80 e2 9f             	and    $0x9f,%dl
c01019e2:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ec:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019f3:	c0 
c01019f4:	80 ca 80             	or     $0x80,%dl
c01019f7:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a01:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101a08:	c1 e8 10             	shr    $0x10,%eax
c0101a0b:	0f b7 d0             	movzwl %ax,%edx
c0101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a11:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c0101a18:	c0 
    for (int i = 0; i < 256; i++)
c0101a19:	ff 45 fc             	incl   -0x4(%ebp)
c0101a1c:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a23:	0f 8e 2f ff ff ff    	jle    c0101958 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a29:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101a2e:	0f b7 c0             	movzwl %ax,%eax
c0101a31:	66 a3 48 ba 11 c0    	mov    %ax,0xc011ba48
c0101a37:	66 c7 05 4a ba 11 c0 	movw   $0x8,0xc011ba4a
c0101a3e:	08 00 
c0101a40:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a47:	24 e0                	and    $0xe0,%al
c0101a49:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a4e:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a55:	24 1f                	and    $0x1f,%al
c0101a57:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a5c:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a63:	24 f0                	and    $0xf0,%al
c0101a65:	0c 0e                	or     $0xe,%al
c0101a67:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a6c:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a73:	24 ef                	and    $0xef,%al
c0101a75:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a7a:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a81:	0c 60                	or     $0x60,%al
c0101a83:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a88:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a8f:	0c 80                	or     $0x80,%al
c0101a91:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a96:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101a9b:	c1 e8 10             	shr    $0x10,%eax
c0101a9e:	0f b7 c0             	movzwl %ax,%eax
c0101aa1:	66 a3 4e ba 11 c0    	mov    %ax,0xc011ba4e
c0101aa7:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile("lidt (%0)" ::"r"(pd)
c0101aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ab1:	0f 01 18             	lidtl  (%eax)
}
c0101ab4:	90                   	nop
    lidt(&idt_pd);
}
c0101ab5:	90                   	nop
c0101ab6:	89 ec                	mov    %ebp,%esp
c0101ab8:	5d                   	pop    %ebp
c0101ab9:	c3                   	ret    

c0101aba <trapname>:

static const char *
trapname(int trapno)
{
c0101aba:	55                   	push   %ebp
c0101abb:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
c0101abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac0:	83 f8 13             	cmp    $0x13,%eax
c0101ac3:	77 0c                	ja     c0101ad1 <trapname+0x17>
    {
        return excnames[trapno];
c0101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac8:	8b 04 85 40 66 10 c0 	mov    -0x3fef99c0(,%eax,4),%eax
c0101acf:	eb 18                	jmp    c0101ae9 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
c0101ad1:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ad5:	7e 0d                	jle    c0101ae4 <trapname+0x2a>
c0101ad7:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101adb:	7f 07                	jg     c0101ae4 <trapname+0x2a>
    {
        return "Hardware Interrupt";
c0101add:	b8 ea 62 10 c0       	mov    $0xc01062ea,%eax
c0101ae2:	eb 05                	jmp    c0101ae9 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101ae4:	b8 fd 62 10 c0       	mov    $0xc01062fd,%eax
}
c0101ae9:	5d                   	pop    %ebp
c0101aea:	c3                   	ret    

c0101aeb <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
c0101aeb:	55                   	push   %ebp
c0101aec:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101af5:	83 f8 08             	cmp    $0x8,%eax
c0101af8:	0f 94 c0             	sete   %al
c0101afb:	0f b6 c0             	movzbl %al,%eax
}
c0101afe:	5d                   	pop    %ebp
c0101aff:	c3                   	ret    

c0101b00 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
c0101b00:	55                   	push   %ebp
c0101b01:	89 e5                	mov    %esp,%ebp
c0101b03:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0d:	c7 04 24 3e 63 10 c0 	movl   $0xc010633e,(%esp)
c0101b14:	e8 4c e8 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0101b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1c:	89 04 24             	mov    %eax,(%esp)
c0101b1f:	e8 8f 01 00 00       	call   c0101cb3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2f:	c7 04 24 4f 63 10 c0 	movl   $0xc010634f,(%esp)
c0101b36:	e8 2a e8 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b46:	c7 04 24 62 63 10 c0 	movl   $0xc0106362,(%esp)
c0101b4d:	e8 13 e8 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b55:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5d:	c7 04 24 75 63 10 c0 	movl   $0xc0106375,(%esp)
c0101b64:	e8 fc e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b74:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0101b7b:	e8 e5 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b83:	8b 40 30             	mov    0x30(%eax),%eax
c0101b86:	89 04 24             	mov    %eax,(%esp)
c0101b89:	e8 2c ff ff ff       	call   c0101aba <trapname>
c0101b8e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b91:	8b 52 30             	mov    0x30(%edx),%edx
c0101b94:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b9c:	c7 04 24 9b 63 10 c0 	movl   $0xc010639b,(%esp)
c0101ba3:	e8 bd e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bab:	8b 40 34             	mov    0x34(%eax),%eax
c0101bae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb2:	c7 04 24 ad 63 10 c0 	movl   $0xc01063ad,(%esp)
c0101bb9:	e8 a7 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc1:	8b 40 38             	mov    0x38(%eax),%eax
c0101bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc8:	c7 04 24 bc 63 10 c0 	movl   $0xc01063bc,(%esp)
c0101bcf:	e8 91 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdf:	c7 04 24 cb 63 10 c0 	movl   $0xc01063cb,(%esp)
c0101be6:	e8 7a e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bee:	8b 40 40             	mov    0x40(%eax),%eax
c0101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf5:	c7 04 24 de 63 10 c0 	movl   $0xc01063de,(%esp)
c0101bfc:	e8 64 e7 ff ff       	call   c0100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c08:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c0f:	eb 3d                	jmp    c0101c4e <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
c0101c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c14:	8b 50 40             	mov    0x40(%eax),%edx
c0101c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c1a:	21 d0                	and    %edx,%eax
c0101c1c:	85 c0                	test   %eax,%eax
c0101c1e:	74 28                	je     c0101c48 <print_trapframe+0x148>
c0101c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c23:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c2a:	85 c0                	test   %eax,%eax
c0101c2c:	74 1a                	je     c0101c48 <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
c0101c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c31:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3c:	c7 04 24 ed 63 10 c0 	movl   $0xc01063ed,(%esp)
c0101c43:	e8 1d e7 ff ff       	call   c0100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c48:	ff 45 f4             	incl   -0xc(%ebp)
c0101c4b:	d1 65 f0             	shll   -0x10(%ebp)
c0101c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c51:	83 f8 17             	cmp    $0x17,%eax
c0101c54:	76 bb                	jbe    c0101c11 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c59:	8b 40 40             	mov    0x40(%eax),%eax
c0101c5c:	c1 e8 0c             	shr    $0xc,%eax
c0101c5f:	83 e0 03             	and    $0x3,%eax
c0101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c66:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101c6d:	e8 f3 e6 ff ff       	call   c0100365 <cprintf>

    if (!trap_in_kernel(tf))
c0101c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c75:	89 04 24             	mov    %eax,(%esp)
c0101c78:	e8 6e fe ff ff       	call   c0101aeb <trap_in_kernel>
c0101c7d:	85 c0                	test   %eax,%eax
c0101c7f:	75 2d                	jne    c0101cae <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c84:	8b 40 44             	mov    0x44(%eax),%eax
c0101c87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8b:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101c92:	e8 ce e6 ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca2:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101ca9:	e8 b7 e6 ff ff       	call   c0100365 <cprintf>
    }
}
c0101cae:	90                   	nop
c0101caf:	89 ec                	mov    %ebp,%esp
c0101cb1:	5d                   	pop    %ebp
c0101cb2:	c3                   	ret    

c0101cb3 <print_regs>:

void print_regs(struct pushregs *regs)
{
c0101cb3:	55                   	push   %ebp
c0101cb4:	89 e5                	mov    %esp,%ebp
c0101cb6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbc:	8b 00                	mov    (%eax),%eax
c0101cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc2:	c7 04 24 1c 64 10 c0 	movl   $0xc010641c,(%esp)
c0101cc9:	e8 97 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd1:	8b 40 04             	mov    0x4(%eax),%eax
c0101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd8:	c7 04 24 2b 64 10 c0 	movl   $0xc010642b,(%esp)
c0101cdf:	e8 81 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce7:	8b 40 08             	mov    0x8(%eax),%eax
c0101cea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cee:	c7 04 24 3a 64 10 c0 	movl   $0xc010643a,(%esp)
c0101cf5:	e8 6b e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfd:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d04:	c7 04 24 49 64 10 c0 	movl   $0xc0106449,(%esp)
c0101d0b:	e8 55 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d13:	8b 40 10             	mov    0x10(%eax),%eax
c0101d16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1a:	c7 04 24 58 64 10 c0 	movl   $0xc0106458,(%esp)
c0101d21:	e8 3f e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d29:	8b 40 14             	mov    0x14(%eax),%eax
c0101d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d30:	c7 04 24 67 64 10 c0 	movl   $0xc0106467,(%esp)
c0101d37:	e8 29 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3f:	8b 40 18             	mov    0x18(%eax),%eax
c0101d42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d46:	c7 04 24 76 64 10 c0 	movl   $0xc0106476,(%esp)
c0101d4d:	e8 13 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d55:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5c:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101d63:	e8 fd e5 ff ff       	call   c0100365 <cprintf>
}
c0101d68:	90                   	nop
c0101d69:	89 ec                	mov    %ebp,%esp
c0101d6b:	5d                   	pop    %ebp
c0101d6c:	c3                   	ret    

c0101d6d <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
c0101d6d:	55                   	push   %ebp
c0101d6e:	89 e5                	mov    %esp,%ebp
c0101d70:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
c0101d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d76:	8b 40 30             	mov    0x30(%eax),%eax
c0101d79:	83 f8 79             	cmp    $0x79,%eax
c0101d7c:	0f 84 1f 01 00 00    	je     c0101ea1 <trap_dispatch+0x134>
c0101d82:	83 f8 79             	cmp    $0x79,%eax
c0101d85:	0f 87 69 01 00 00    	ja     c0101ef4 <trap_dispatch+0x187>
c0101d8b:	83 f8 78             	cmp    $0x78,%eax
c0101d8e:	0f 84 b7 00 00 00    	je     c0101e4b <trap_dispatch+0xde>
c0101d94:	83 f8 78             	cmp    $0x78,%eax
c0101d97:	0f 87 57 01 00 00    	ja     c0101ef4 <trap_dispatch+0x187>
c0101d9d:	83 f8 2f             	cmp    $0x2f,%eax
c0101da0:	0f 87 4e 01 00 00    	ja     c0101ef4 <trap_dispatch+0x187>
c0101da6:	83 f8 2e             	cmp    $0x2e,%eax
c0101da9:	0f 83 7a 01 00 00    	jae    c0101f29 <trap_dispatch+0x1bc>
c0101daf:	83 f8 24             	cmp    $0x24,%eax
c0101db2:	74 45                	je     c0101df9 <trap_dispatch+0x8c>
c0101db4:	83 f8 24             	cmp    $0x24,%eax
c0101db7:	0f 87 37 01 00 00    	ja     c0101ef4 <trap_dispatch+0x187>
c0101dbd:	83 f8 20             	cmp    $0x20,%eax
c0101dc0:	74 0a                	je     c0101dcc <trap_dispatch+0x5f>
c0101dc2:	83 f8 21             	cmp    $0x21,%eax
c0101dc5:	74 5b                	je     c0101e22 <trap_dispatch+0xb5>
c0101dc7:	e9 28 01 00 00       	jmp    c0101ef4 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101dcc:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101dd1:	40                   	inc    %eax
c0101dd2:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks == TICK_NUM)
c0101dd7:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101ddc:	83 f8 64             	cmp    $0x64,%eax
c0101ddf:	0f 85 47 01 00 00    	jne    c0101f2c <trap_dispatch+0x1bf>
        {
            ticks = 0;
c0101de5:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0101dec:	00 00 00 
            print_ticks();
c0101def:	e8 33 fb ff ff       	call   c0101927 <print_ticks>
        }
        break;
c0101df4:	e9 33 01 00 00       	jmp    c0101f2c <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101df9:	e8 cc f8 ff ff       	call   c01016ca <cons_getc>
c0101dfe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e09:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e11:	c7 04 24 94 64 10 c0 	movl   $0xc0106494,(%esp)
c0101e18:	e8 48 e5 ff ff       	call   c0100365 <cprintf>
        break;
c0101e1d:	e9 11 01 00 00       	jmp    c0101f33 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e22:	e8 a3 f8 ff ff       	call   c01016ca <cons_getc>
c0101e27:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e2a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e2e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e32:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e3a:	c7 04 24 a6 64 10 c0 	movl   $0xc01064a6,(%esp)
c0101e41:	e8 1f e5 ff ff       	call   c0100365 <cprintf>
        break;
c0101e46:	e9 e8 00 00 00       	jmp    c0101f33 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
c0101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e52:	83 f8 1b             	cmp    $0x1b,%eax
c0101e55:	0f 84 d4 00 00 00    	je     c0101f2f <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
c0101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101e64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e67:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e70:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101e74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e77:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e85:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
c0101e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8c:	8b 40 40             	mov    0x40(%eax),%eax
c0101e8f:	0d 00 30 00 00       	or     $0x3000,%eax
c0101e94:	89 c2                	mov    %eax,%edx
c0101e96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e99:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101e9c:	e9 8e 00 00 00       	jmp    c0101f2f <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
c0101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea8:	83 f8 08             	cmp    $0x8,%eax
c0101eab:	0f 84 81 00 00 00    	je     c0101f32 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
c0101eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
c0101eba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebd:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecd:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101edb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee2:	8b 40 40             	mov    0x40(%eax),%eax
c0101ee5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101eea:	89 c2                	mov    %eax,%edx
c0101eec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eef:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101ef2:	eb 3e                	jmp    c0101f32 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
c0101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101efb:	83 e0 03             	and    $0x3,%eax
c0101efe:	85 c0                	test   %eax,%eax
c0101f00:	75 31                	jne    c0101f33 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
c0101f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f05:	89 04 24             	mov    %eax,(%esp)
c0101f08:	e8 f3 fb ff ff       	call   c0101b00 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f0d:	c7 44 24 08 b5 64 10 	movl   $0xc01064b5,0x8(%esp)
c0101f14:	c0 
c0101f15:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0101f1c:	00 
c0101f1d:	c7 04 24 d1 64 10 c0 	movl   $0xc01064d1,(%esp)
c0101f24:	e8 c1 ed ff ff       	call   c0100cea <__panic>
        break;
c0101f29:	90                   	nop
c0101f2a:	eb 07                	jmp    c0101f33 <trap_dispatch+0x1c6>
        break;
c0101f2c:	90                   	nop
c0101f2d:	eb 04                	jmp    c0101f33 <trap_dispatch+0x1c6>
        break;
c0101f2f:	90                   	nop
c0101f30:	eb 01                	jmp    c0101f33 <trap_dispatch+0x1c6>
        break;
c0101f32:	90                   	nop
        }
    }
}
c0101f33:	90                   	nop
c0101f34:	89 ec                	mov    %ebp,%esp
c0101f36:	5d                   	pop    %ebp
c0101f37:	c3                   	ret    

c0101f38 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
c0101f38:	55                   	push   %ebp
c0101f39:	89 e5                	mov    %esp,%ebp
c0101f3b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f41:	89 04 24             	mov    %eax,(%esp)
c0101f44:	e8 24 fe ff ff       	call   c0101d6d <trap_dispatch>
}
c0101f49:	90                   	nop
c0101f4a:	89 ec                	mov    %ebp,%esp
c0101f4c:	5d                   	pop    %ebp
c0101f4d:	c3                   	ret    

c0101f4e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101f4e:	1e                   	push   %ds
    pushl %es
c0101f4f:	06                   	push   %es
    pushl %fs
c0101f50:	0f a0                	push   %fs
    pushl %gs
c0101f52:	0f a8                	push   %gs
    pushal
c0101f54:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101f55:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f5a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f5c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f5e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f5f:	e8 d4 ff ff ff       	call   c0101f38 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f64:	5c                   	pop    %esp

c0101f65 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f65:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f66:	0f a9                	pop    %gs
    popl %fs
c0101f68:	0f a1                	pop    %fs
    popl %es
c0101f6a:	07                   	pop    %es
    popl %ds
c0101f6b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f6c:	83 c4 08             	add    $0x8,%esp
    iret
c0101f6f:	cf                   	iret   

c0101f70 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f70:	6a 00                	push   $0x0
  pushl $0
c0101f72:	6a 00                	push   $0x0
  jmp __alltraps
c0101f74:	e9 d5 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101f79 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f79:	6a 00                	push   $0x0
  pushl $1
c0101f7b:	6a 01                	push   $0x1
  jmp __alltraps
c0101f7d:	e9 cc ff ff ff       	jmp    c0101f4e <__alltraps>

c0101f82 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f82:	6a 00                	push   $0x0
  pushl $2
c0101f84:	6a 02                	push   $0x2
  jmp __alltraps
c0101f86:	e9 c3 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101f8b <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f8b:	6a 00                	push   $0x0
  pushl $3
c0101f8d:	6a 03                	push   $0x3
  jmp __alltraps
c0101f8f:	e9 ba ff ff ff       	jmp    c0101f4e <__alltraps>

c0101f94 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f94:	6a 00                	push   $0x0
  pushl $4
c0101f96:	6a 04                	push   $0x4
  jmp __alltraps
c0101f98:	e9 b1 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101f9d <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f9d:	6a 00                	push   $0x0
  pushl $5
c0101f9f:	6a 05                	push   $0x5
  jmp __alltraps
c0101fa1:	e9 a8 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fa6 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fa6:	6a 00                	push   $0x0
  pushl $6
c0101fa8:	6a 06                	push   $0x6
  jmp __alltraps
c0101faa:	e9 9f ff ff ff       	jmp    c0101f4e <__alltraps>

c0101faf <vector7>:
.globl vector7
vector7:
  pushl $0
c0101faf:	6a 00                	push   $0x0
  pushl $7
c0101fb1:	6a 07                	push   $0x7
  jmp __alltraps
c0101fb3:	e9 96 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fb8 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fb8:	6a 08                	push   $0x8
  jmp __alltraps
c0101fba:	e9 8f ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fbf <vector9>:
.globl vector9
vector9:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $9
c0101fc1:	6a 09                	push   $0x9
  jmp __alltraps
c0101fc3:	e9 86 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fc8 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101fc8:	6a 0a                	push   $0xa
  jmp __alltraps
c0101fca:	e9 7f ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fcf <vector11>:
.globl vector11
vector11:
  pushl $11
c0101fcf:	6a 0b                	push   $0xb
  jmp __alltraps
c0101fd1:	e9 78 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fd6 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101fd6:	6a 0c                	push   $0xc
  jmp __alltraps
c0101fd8:	e9 71 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fdd <vector13>:
.globl vector13
vector13:
  pushl $13
c0101fdd:	6a 0d                	push   $0xd
  jmp __alltraps
c0101fdf:	e9 6a ff ff ff       	jmp    c0101f4e <__alltraps>

c0101fe4 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101fe4:	6a 0e                	push   $0xe
  jmp __alltraps
c0101fe6:	e9 63 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101feb <vector15>:
.globl vector15
vector15:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $15
c0101fed:	6a 0f                	push   $0xf
  jmp __alltraps
c0101fef:	e9 5a ff ff ff       	jmp    c0101f4e <__alltraps>

c0101ff4 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $16
c0101ff6:	6a 10                	push   $0x10
  jmp __alltraps
c0101ff8:	e9 51 ff ff ff       	jmp    c0101f4e <__alltraps>

c0101ffd <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ffd:	6a 11                	push   $0x11
  jmp __alltraps
c0101fff:	e9 4a ff ff ff       	jmp    c0101f4e <__alltraps>

c0102004 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $18
c0102006:	6a 12                	push   $0x12
  jmp __alltraps
c0102008:	e9 41 ff ff ff       	jmp    c0101f4e <__alltraps>

c010200d <vector19>:
.globl vector19
vector19:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $19
c010200f:	6a 13                	push   $0x13
  jmp __alltraps
c0102011:	e9 38 ff ff ff       	jmp    c0101f4e <__alltraps>

c0102016 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $20
c0102018:	6a 14                	push   $0x14
  jmp __alltraps
c010201a:	e9 2f ff ff ff       	jmp    c0101f4e <__alltraps>

c010201f <vector21>:
.globl vector21
vector21:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $21
c0102021:	6a 15                	push   $0x15
  jmp __alltraps
c0102023:	e9 26 ff ff ff       	jmp    c0101f4e <__alltraps>

c0102028 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $22
c010202a:	6a 16                	push   $0x16
  jmp __alltraps
c010202c:	e9 1d ff ff ff       	jmp    c0101f4e <__alltraps>

c0102031 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $23
c0102033:	6a 17                	push   $0x17
  jmp __alltraps
c0102035:	e9 14 ff ff ff       	jmp    c0101f4e <__alltraps>

c010203a <vector24>:
.globl vector24
vector24:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $24
c010203c:	6a 18                	push   $0x18
  jmp __alltraps
c010203e:	e9 0b ff ff ff       	jmp    c0101f4e <__alltraps>

c0102043 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $25
c0102045:	6a 19                	push   $0x19
  jmp __alltraps
c0102047:	e9 02 ff ff ff       	jmp    c0101f4e <__alltraps>

c010204c <vector26>:
.globl vector26
vector26:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $26
c010204e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102050:	e9 f9 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102055 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $27
c0102057:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102059:	e9 f0 fe ff ff       	jmp    c0101f4e <__alltraps>

c010205e <vector28>:
.globl vector28
vector28:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $28
c0102060:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102062:	e9 e7 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102067 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $29
c0102069:	6a 1d                	push   $0x1d
  jmp __alltraps
c010206b:	e9 de fe ff ff       	jmp    c0101f4e <__alltraps>

c0102070 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $30
c0102072:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102074:	e9 d5 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102079 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $31
c010207b:	6a 1f                	push   $0x1f
  jmp __alltraps
c010207d:	e9 cc fe ff ff       	jmp    c0101f4e <__alltraps>

c0102082 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $32
c0102084:	6a 20                	push   $0x20
  jmp __alltraps
c0102086:	e9 c3 fe ff ff       	jmp    c0101f4e <__alltraps>

c010208b <vector33>:
.globl vector33
vector33:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $33
c010208d:	6a 21                	push   $0x21
  jmp __alltraps
c010208f:	e9 ba fe ff ff       	jmp    c0101f4e <__alltraps>

c0102094 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $34
c0102096:	6a 22                	push   $0x22
  jmp __alltraps
c0102098:	e9 b1 fe ff ff       	jmp    c0101f4e <__alltraps>

c010209d <vector35>:
.globl vector35
vector35:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $35
c010209f:	6a 23                	push   $0x23
  jmp __alltraps
c01020a1:	e9 a8 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020a6 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $36
c01020a8:	6a 24                	push   $0x24
  jmp __alltraps
c01020aa:	e9 9f fe ff ff       	jmp    c0101f4e <__alltraps>

c01020af <vector37>:
.globl vector37
vector37:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $37
c01020b1:	6a 25                	push   $0x25
  jmp __alltraps
c01020b3:	e9 96 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020b8 <vector38>:
.globl vector38
vector38:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $38
c01020ba:	6a 26                	push   $0x26
  jmp __alltraps
c01020bc:	e9 8d fe ff ff       	jmp    c0101f4e <__alltraps>

c01020c1 <vector39>:
.globl vector39
vector39:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $39
c01020c3:	6a 27                	push   $0x27
  jmp __alltraps
c01020c5:	e9 84 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020ca <vector40>:
.globl vector40
vector40:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $40
c01020cc:	6a 28                	push   $0x28
  jmp __alltraps
c01020ce:	e9 7b fe ff ff       	jmp    c0101f4e <__alltraps>

c01020d3 <vector41>:
.globl vector41
vector41:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $41
c01020d5:	6a 29                	push   $0x29
  jmp __alltraps
c01020d7:	e9 72 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020dc <vector42>:
.globl vector42
vector42:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $42
c01020de:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020e0:	e9 69 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020e5 <vector43>:
.globl vector43
vector43:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $43
c01020e7:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020e9:	e9 60 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020ee <vector44>:
.globl vector44
vector44:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $44
c01020f0:	6a 2c                	push   $0x2c
  jmp __alltraps
c01020f2:	e9 57 fe ff ff       	jmp    c0101f4e <__alltraps>

c01020f7 <vector45>:
.globl vector45
vector45:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $45
c01020f9:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020fb:	e9 4e fe ff ff       	jmp    c0101f4e <__alltraps>

c0102100 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $46
c0102102:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102104:	e9 45 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102109 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $47
c010210b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010210d:	e9 3c fe ff ff       	jmp    c0101f4e <__alltraps>

c0102112 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $48
c0102114:	6a 30                	push   $0x30
  jmp __alltraps
c0102116:	e9 33 fe ff ff       	jmp    c0101f4e <__alltraps>

c010211b <vector49>:
.globl vector49
vector49:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $49
c010211d:	6a 31                	push   $0x31
  jmp __alltraps
c010211f:	e9 2a fe ff ff       	jmp    c0101f4e <__alltraps>

c0102124 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $50
c0102126:	6a 32                	push   $0x32
  jmp __alltraps
c0102128:	e9 21 fe ff ff       	jmp    c0101f4e <__alltraps>

c010212d <vector51>:
.globl vector51
vector51:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $51
c010212f:	6a 33                	push   $0x33
  jmp __alltraps
c0102131:	e9 18 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102136 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $52
c0102138:	6a 34                	push   $0x34
  jmp __alltraps
c010213a:	e9 0f fe ff ff       	jmp    c0101f4e <__alltraps>

c010213f <vector53>:
.globl vector53
vector53:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $53
c0102141:	6a 35                	push   $0x35
  jmp __alltraps
c0102143:	e9 06 fe ff ff       	jmp    c0101f4e <__alltraps>

c0102148 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $54
c010214a:	6a 36                	push   $0x36
  jmp __alltraps
c010214c:	e9 fd fd ff ff       	jmp    c0101f4e <__alltraps>

c0102151 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $55
c0102153:	6a 37                	push   $0x37
  jmp __alltraps
c0102155:	e9 f4 fd ff ff       	jmp    c0101f4e <__alltraps>

c010215a <vector56>:
.globl vector56
vector56:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $56
c010215c:	6a 38                	push   $0x38
  jmp __alltraps
c010215e:	e9 eb fd ff ff       	jmp    c0101f4e <__alltraps>

c0102163 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $57
c0102165:	6a 39                	push   $0x39
  jmp __alltraps
c0102167:	e9 e2 fd ff ff       	jmp    c0101f4e <__alltraps>

c010216c <vector58>:
.globl vector58
vector58:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $58
c010216e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102170:	e9 d9 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102175 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $59
c0102177:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102179:	e9 d0 fd ff ff       	jmp    c0101f4e <__alltraps>

c010217e <vector60>:
.globl vector60
vector60:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $60
c0102180:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102182:	e9 c7 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102187 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $61
c0102189:	6a 3d                	push   $0x3d
  jmp __alltraps
c010218b:	e9 be fd ff ff       	jmp    c0101f4e <__alltraps>

c0102190 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $62
c0102192:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102194:	e9 b5 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102199 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $63
c010219b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010219d:	e9 ac fd ff ff       	jmp    c0101f4e <__alltraps>

c01021a2 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $64
c01021a4:	6a 40                	push   $0x40
  jmp __alltraps
c01021a6:	e9 a3 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021ab <vector65>:
.globl vector65
vector65:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $65
c01021ad:	6a 41                	push   $0x41
  jmp __alltraps
c01021af:	e9 9a fd ff ff       	jmp    c0101f4e <__alltraps>

c01021b4 <vector66>:
.globl vector66
vector66:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $66
c01021b6:	6a 42                	push   $0x42
  jmp __alltraps
c01021b8:	e9 91 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021bd <vector67>:
.globl vector67
vector67:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $67
c01021bf:	6a 43                	push   $0x43
  jmp __alltraps
c01021c1:	e9 88 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021c6 <vector68>:
.globl vector68
vector68:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $68
c01021c8:	6a 44                	push   $0x44
  jmp __alltraps
c01021ca:	e9 7f fd ff ff       	jmp    c0101f4e <__alltraps>

c01021cf <vector69>:
.globl vector69
vector69:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $69
c01021d1:	6a 45                	push   $0x45
  jmp __alltraps
c01021d3:	e9 76 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021d8 <vector70>:
.globl vector70
vector70:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $70
c01021da:	6a 46                	push   $0x46
  jmp __alltraps
c01021dc:	e9 6d fd ff ff       	jmp    c0101f4e <__alltraps>

c01021e1 <vector71>:
.globl vector71
vector71:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $71
c01021e3:	6a 47                	push   $0x47
  jmp __alltraps
c01021e5:	e9 64 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021ea <vector72>:
.globl vector72
vector72:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $72
c01021ec:	6a 48                	push   $0x48
  jmp __alltraps
c01021ee:	e9 5b fd ff ff       	jmp    c0101f4e <__alltraps>

c01021f3 <vector73>:
.globl vector73
vector73:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $73
c01021f5:	6a 49                	push   $0x49
  jmp __alltraps
c01021f7:	e9 52 fd ff ff       	jmp    c0101f4e <__alltraps>

c01021fc <vector74>:
.globl vector74
vector74:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $74
c01021fe:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102200:	e9 49 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102205 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $75
c0102207:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102209:	e9 40 fd ff ff       	jmp    c0101f4e <__alltraps>

c010220e <vector76>:
.globl vector76
vector76:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $76
c0102210:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102212:	e9 37 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102217 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $77
c0102219:	6a 4d                	push   $0x4d
  jmp __alltraps
c010221b:	e9 2e fd ff ff       	jmp    c0101f4e <__alltraps>

c0102220 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $78
c0102222:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102224:	e9 25 fd ff ff       	jmp    c0101f4e <__alltraps>

c0102229 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $79
c010222b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010222d:	e9 1c fd ff ff       	jmp    c0101f4e <__alltraps>

c0102232 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $80
c0102234:	6a 50                	push   $0x50
  jmp __alltraps
c0102236:	e9 13 fd ff ff       	jmp    c0101f4e <__alltraps>

c010223b <vector81>:
.globl vector81
vector81:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $81
c010223d:	6a 51                	push   $0x51
  jmp __alltraps
c010223f:	e9 0a fd ff ff       	jmp    c0101f4e <__alltraps>

c0102244 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $82
c0102246:	6a 52                	push   $0x52
  jmp __alltraps
c0102248:	e9 01 fd ff ff       	jmp    c0101f4e <__alltraps>

c010224d <vector83>:
.globl vector83
vector83:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $83
c010224f:	6a 53                	push   $0x53
  jmp __alltraps
c0102251:	e9 f8 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102256 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $84
c0102258:	6a 54                	push   $0x54
  jmp __alltraps
c010225a:	e9 ef fc ff ff       	jmp    c0101f4e <__alltraps>

c010225f <vector85>:
.globl vector85
vector85:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $85
c0102261:	6a 55                	push   $0x55
  jmp __alltraps
c0102263:	e9 e6 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102268 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $86
c010226a:	6a 56                	push   $0x56
  jmp __alltraps
c010226c:	e9 dd fc ff ff       	jmp    c0101f4e <__alltraps>

c0102271 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $87
c0102273:	6a 57                	push   $0x57
  jmp __alltraps
c0102275:	e9 d4 fc ff ff       	jmp    c0101f4e <__alltraps>

c010227a <vector88>:
.globl vector88
vector88:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $88
c010227c:	6a 58                	push   $0x58
  jmp __alltraps
c010227e:	e9 cb fc ff ff       	jmp    c0101f4e <__alltraps>

c0102283 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $89
c0102285:	6a 59                	push   $0x59
  jmp __alltraps
c0102287:	e9 c2 fc ff ff       	jmp    c0101f4e <__alltraps>

c010228c <vector90>:
.globl vector90
vector90:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $90
c010228e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102290:	e9 b9 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102295 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $91
c0102297:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102299:	e9 b0 fc ff ff       	jmp    c0101f4e <__alltraps>

c010229e <vector92>:
.globl vector92
vector92:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $92
c01022a0:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022a2:	e9 a7 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022a7 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $93
c01022a9:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022ab:	e9 9e fc ff ff       	jmp    c0101f4e <__alltraps>

c01022b0 <vector94>:
.globl vector94
vector94:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $94
c01022b2:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022b4:	e9 95 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022b9 <vector95>:
.globl vector95
vector95:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $95
c01022bb:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022bd:	e9 8c fc ff ff       	jmp    c0101f4e <__alltraps>

c01022c2 <vector96>:
.globl vector96
vector96:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $96
c01022c4:	6a 60                	push   $0x60
  jmp __alltraps
c01022c6:	e9 83 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022cb <vector97>:
.globl vector97
vector97:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $97
c01022cd:	6a 61                	push   $0x61
  jmp __alltraps
c01022cf:	e9 7a fc ff ff       	jmp    c0101f4e <__alltraps>

c01022d4 <vector98>:
.globl vector98
vector98:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $98
c01022d6:	6a 62                	push   $0x62
  jmp __alltraps
c01022d8:	e9 71 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022dd <vector99>:
.globl vector99
vector99:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $99
c01022df:	6a 63                	push   $0x63
  jmp __alltraps
c01022e1:	e9 68 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022e6 <vector100>:
.globl vector100
vector100:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $100
c01022e8:	6a 64                	push   $0x64
  jmp __alltraps
c01022ea:	e9 5f fc ff ff       	jmp    c0101f4e <__alltraps>

c01022ef <vector101>:
.globl vector101
vector101:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $101
c01022f1:	6a 65                	push   $0x65
  jmp __alltraps
c01022f3:	e9 56 fc ff ff       	jmp    c0101f4e <__alltraps>

c01022f8 <vector102>:
.globl vector102
vector102:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $102
c01022fa:	6a 66                	push   $0x66
  jmp __alltraps
c01022fc:	e9 4d fc ff ff       	jmp    c0101f4e <__alltraps>

c0102301 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $103
c0102303:	6a 67                	push   $0x67
  jmp __alltraps
c0102305:	e9 44 fc ff ff       	jmp    c0101f4e <__alltraps>

c010230a <vector104>:
.globl vector104
vector104:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $104
c010230c:	6a 68                	push   $0x68
  jmp __alltraps
c010230e:	e9 3b fc ff ff       	jmp    c0101f4e <__alltraps>

c0102313 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $105
c0102315:	6a 69                	push   $0x69
  jmp __alltraps
c0102317:	e9 32 fc ff ff       	jmp    c0101f4e <__alltraps>

c010231c <vector106>:
.globl vector106
vector106:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $106
c010231e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102320:	e9 29 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102325 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $107
c0102327:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102329:	e9 20 fc ff ff       	jmp    c0101f4e <__alltraps>

c010232e <vector108>:
.globl vector108
vector108:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $108
c0102330:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102332:	e9 17 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102337 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $109
c0102339:	6a 6d                	push   $0x6d
  jmp __alltraps
c010233b:	e9 0e fc ff ff       	jmp    c0101f4e <__alltraps>

c0102340 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $110
c0102342:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102344:	e9 05 fc ff ff       	jmp    c0101f4e <__alltraps>

c0102349 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $111
c010234b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010234d:	e9 fc fb ff ff       	jmp    c0101f4e <__alltraps>

c0102352 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $112
c0102354:	6a 70                	push   $0x70
  jmp __alltraps
c0102356:	e9 f3 fb ff ff       	jmp    c0101f4e <__alltraps>

c010235b <vector113>:
.globl vector113
vector113:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $113
c010235d:	6a 71                	push   $0x71
  jmp __alltraps
c010235f:	e9 ea fb ff ff       	jmp    c0101f4e <__alltraps>

c0102364 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $114
c0102366:	6a 72                	push   $0x72
  jmp __alltraps
c0102368:	e9 e1 fb ff ff       	jmp    c0101f4e <__alltraps>

c010236d <vector115>:
.globl vector115
vector115:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $115
c010236f:	6a 73                	push   $0x73
  jmp __alltraps
c0102371:	e9 d8 fb ff ff       	jmp    c0101f4e <__alltraps>

c0102376 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $116
c0102378:	6a 74                	push   $0x74
  jmp __alltraps
c010237a:	e9 cf fb ff ff       	jmp    c0101f4e <__alltraps>

c010237f <vector117>:
.globl vector117
vector117:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $117
c0102381:	6a 75                	push   $0x75
  jmp __alltraps
c0102383:	e9 c6 fb ff ff       	jmp    c0101f4e <__alltraps>

c0102388 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $118
c010238a:	6a 76                	push   $0x76
  jmp __alltraps
c010238c:	e9 bd fb ff ff       	jmp    c0101f4e <__alltraps>

c0102391 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $119
c0102393:	6a 77                	push   $0x77
  jmp __alltraps
c0102395:	e9 b4 fb ff ff       	jmp    c0101f4e <__alltraps>

c010239a <vector120>:
.globl vector120
vector120:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $120
c010239c:	6a 78                	push   $0x78
  jmp __alltraps
c010239e:	e9 ab fb ff ff       	jmp    c0101f4e <__alltraps>

c01023a3 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $121
c01023a5:	6a 79                	push   $0x79
  jmp __alltraps
c01023a7:	e9 a2 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023ac <vector122>:
.globl vector122
vector122:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $122
c01023ae:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023b0:	e9 99 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023b5 <vector123>:
.globl vector123
vector123:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $123
c01023b7:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023b9:	e9 90 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023be <vector124>:
.globl vector124
vector124:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $124
c01023c0:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023c2:	e9 87 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023c7 <vector125>:
.globl vector125
vector125:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $125
c01023c9:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023cb:	e9 7e fb ff ff       	jmp    c0101f4e <__alltraps>

c01023d0 <vector126>:
.globl vector126
vector126:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $126
c01023d2:	6a 7e                	push   $0x7e
  jmp __alltraps
c01023d4:	e9 75 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023d9 <vector127>:
.globl vector127
vector127:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $127
c01023db:	6a 7f                	push   $0x7f
  jmp __alltraps
c01023dd:	e9 6c fb ff ff       	jmp    c0101f4e <__alltraps>

c01023e2 <vector128>:
.globl vector128
vector128:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $128
c01023e4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023e9:	e9 60 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023ee <vector129>:
.globl vector129
vector129:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $129
c01023f0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01023f5:	e9 54 fb ff ff       	jmp    c0101f4e <__alltraps>

c01023fa <vector130>:
.globl vector130
vector130:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $130
c01023fc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102401:	e9 48 fb ff ff       	jmp    c0101f4e <__alltraps>

c0102406 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $131
c0102408:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010240d:	e9 3c fb ff ff       	jmp    c0101f4e <__alltraps>

c0102412 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $132
c0102414:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102419:	e9 30 fb ff ff       	jmp    c0101f4e <__alltraps>

c010241e <vector133>:
.globl vector133
vector133:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $133
c0102420:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102425:	e9 24 fb ff ff       	jmp    c0101f4e <__alltraps>

c010242a <vector134>:
.globl vector134
vector134:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $134
c010242c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102431:	e9 18 fb ff ff       	jmp    c0101f4e <__alltraps>

c0102436 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $135
c0102438:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010243d:	e9 0c fb ff ff       	jmp    c0101f4e <__alltraps>

c0102442 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $136
c0102444:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102449:	e9 00 fb ff ff       	jmp    c0101f4e <__alltraps>

c010244e <vector137>:
.globl vector137
vector137:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $137
c0102450:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102455:	e9 f4 fa ff ff       	jmp    c0101f4e <__alltraps>

c010245a <vector138>:
.globl vector138
vector138:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $138
c010245c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102461:	e9 e8 fa ff ff       	jmp    c0101f4e <__alltraps>

c0102466 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $139
c0102468:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010246d:	e9 dc fa ff ff       	jmp    c0101f4e <__alltraps>

c0102472 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $140
c0102474:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102479:	e9 d0 fa ff ff       	jmp    c0101f4e <__alltraps>

c010247e <vector141>:
.globl vector141
vector141:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $141
c0102480:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102485:	e9 c4 fa ff ff       	jmp    c0101f4e <__alltraps>

c010248a <vector142>:
.globl vector142
vector142:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $142
c010248c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102491:	e9 b8 fa ff ff       	jmp    c0101f4e <__alltraps>

c0102496 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $143
c0102498:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010249d:	e9 ac fa ff ff       	jmp    c0101f4e <__alltraps>

c01024a2 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $144
c01024a4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024a9:	e9 a0 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024ae <vector145>:
.globl vector145
vector145:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $145
c01024b0:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024b5:	e9 94 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024ba <vector146>:
.globl vector146
vector146:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $146
c01024bc:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024c1:	e9 88 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024c6 <vector147>:
.globl vector147
vector147:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $147
c01024c8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024cd:	e9 7c fa ff ff       	jmp    c0101f4e <__alltraps>

c01024d2 <vector148>:
.globl vector148
vector148:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $148
c01024d4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024d9:	e9 70 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024de <vector149>:
.globl vector149
vector149:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $149
c01024e0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024e5:	e9 64 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024ea <vector150>:
.globl vector150
vector150:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $150
c01024ec:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01024f1:	e9 58 fa ff ff       	jmp    c0101f4e <__alltraps>

c01024f6 <vector151>:
.globl vector151
vector151:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $151
c01024f8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024fd:	e9 4c fa ff ff       	jmp    c0101f4e <__alltraps>

c0102502 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $152
c0102504:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102509:	e9 40 fa ff ff       	jmp    c0101f4e <__alltraps>

c010250e <vector153>:
.globl vector153
vector153:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $153
c0102510:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102515:	e9 34 fa ff ff       	jmp    c0101f4e <__alltraps>

c010251a <vector154>:
.globl vector154
vector154:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $154
c010251c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102521:	e9 28 fa ff ff       	jmp    c0101f4e <__alltraps>

c0102526 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $155
c0102528:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010252d:	e9 1c fa ff ff       	jmp    c0101f4e <__alltraps>

c0102532 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $156
c0102534:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102539:	e9 10 fa ff ff       	jmp    c0101f4e <__alltraps>

c010253e <vector157>:
.globl vector157
vector157:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $157
c0102540:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102545:	e9 04 fa ff ff       	jmp    c0101f4e <__alltraps>

c010254a <vector158>:
.globl vector158
vector158:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $158
c010254c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102551:	e9 f8 f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102556 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $159
c0102558:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010255d:	e9 ec f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102562 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $160
c0102564:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102569:	e9 e0 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010256e <vector161>:
.globl vector161
vector161:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $161
c0102570:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102575:	e9 d4 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010257a <vector162>:
.globl vector162
vector162:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $162
c010257c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102581:	e9 c8 f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102586 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $163
c0102588:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010258d:	e9 bc f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102592 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $164
c0102594:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102599:	e9 b0 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010259e <vector165>:
.globl vector165
vector165:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $165
c01025a0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025a5:	e9 a4 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025aa <vector166>:
.globl vector166
vector166:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $166
c01025ac:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025b1:	e9 98 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025b6 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $167
c01025b8:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025bd:	e9 8c f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025c2 <vector168>:
.globl vector168
vector168:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $168
c01025c4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025c9:	e9 80 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025ce <vector169>:
.globl vector169
vector169:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $169
c01025d0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025d5:	e9 74 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025da <vector170>:
.globl vector170
vector170:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $170
c01025dc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025e1:	e9 68 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025e6 <vector171>:
.globl vector171
vector171:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $171
c01025e8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01025ed:	e9 5c f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025f2 <vector172>:
.globl vector172
vector172:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $172
c01025f4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01025f9:	e9 50 f9 ff ff       	jmp    c0101f4e <__alltraps>

c01025fe <vector173>:
.globl vector173
vector173:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $173
c0102600:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102605:	e9 44 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010260a <vector174>:
.globl vector174
vector174:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $174
c010260c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102611:	e9 38 f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102616 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $175
c0102618:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010261d:	e9 2c f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102622 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $176
c0102624:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102629:	e9 20 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010262e <vector177>:
.globl vector177
vector177:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $177
c0102630:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102635:	e9 14 f9 ff ff       	jmp    c0101f4e <__alltraps>

c010263a <vector178>:
.globl vector178
vector178:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $178
c010263c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102641:	e9 08 f9 ff ff       	jmp    c0101f4e <__alltraps>

c0102646 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $179
c0102648:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010264d:	e9 fc f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102652 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $180
c0102654:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102659:	e9 f0 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010265e <vector181>:
.globl vector181
vector181:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $181
c0102660:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102665:	e9 e4 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010266a <vector182>:
.globl vector182
vector182:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $182
c010266c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102671:	e9 d8 f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102676 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $183
c0102678:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010267d:	e9 cc f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102682 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $184
c0102684:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102689:	e9 c0 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010268e <vector185>:
.globl vector185
vector185:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $185
c0102690:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102695:	e9 b4 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010269a <vector186>:
.globl vector186
vector186:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $186
c010269c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026a1:	e9 a8 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026a6 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $187
c01026a8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026ad:	e9 9c f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026b2 <vector188>:
.globl vector188
vector188:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $188
c01026b4:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026b9:	e9 90 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026be <vector189>:
.globl vector189
vector189:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $189
c01026c0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026c5:	e9 84 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026ca <vector190>:
.globl vector190
vector190:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $190
c01026cc:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026d1:	e9 78 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026d6 <vector191>:
.globl vector191
vector191:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $191
c01026d8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01026dd:	e9 6c f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026e2 <vector192>:
.globl vector192
vector192:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $192
c01026e4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026e9:	e9 60 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026ee <vector193>:
.globl vector193
vector193:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $193
c01026f0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01026f5:	e9 54 f8 ff ff       	jmp    c0101f4e <__alltraps>

c01026fa <vector194>:
.globl vector194
vector194:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $194
c01026fc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102701:	e9 48 f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102706 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $195
c0102708:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010270d:	e9 3c f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102712 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $196
c0102714:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102719:	e9 30 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010271e <vector197>:
.globl vector197
vector197:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $197
c0102720:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102725:	e9 24 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010272a <vector198>:
.globl vector198
vector198:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $198
c010272c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102731:	e9 18 f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102736 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $199
c0102738:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010273d:	e9 0c f8 ff ff       	jmp    c0101f4e <__alltraps>

c0102742 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $200
c0102744:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102749:	e9 00 f8 ff ff       	jmp    c0101f4e <__alltraps>

c010274e <vector201>:
.globl vector201
vector201:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $201
c0102750:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102755:	e9 f4 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010275a <vector202>:
.globl vector202
vector202:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $202
c010275c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102761:	e9 e8 f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102766 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $203
c0102768:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010276d:	e9 dc f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102772 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $204
c0102774:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102779:	e9 d0 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010277e <vector205>:
.globl vector205
vector205:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $205
c0102780:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102785:	e9 c4 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010278a <vector206>:
.globl vector206
vector206:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $206
c010278c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102791:	e9 b8 f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102796 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $207
c0102798:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010279d:	e9 ac f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027a2 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $208
c01027a4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027a9:	e9 a0 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027ae <vector209>:
.globl vector209
vector209:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $209
c01027b0:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027b5:	e9 94 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027ba <vector210>:
.globl vector210
vector210:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $210
c01027bc:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027c1:	e9 88 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027c6 <vector211>:
.globl vector211
vector211:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $211
c01027c8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027cd:	e9 7c f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027d2 <vector212>:
.globl vector212
vector212:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $212
c01027d4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027d9:	e9 70 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027de <vector213>:
.globl vector213
vector213:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $213
c01027e0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027e5:	e9 64 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027ea <vector214>:
.globl vector214
vector214:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $214
c01027ec:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01027f1:	e9 58 f7 ff ff       	jmp    c0101f4e <__alltraps>

c01027f6 <vector215>:
.globl vector215
vector215:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $215
c01027f8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027fd:	e9 4c f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102802 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $216
c0102804:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102809:	e9 40 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010280e <vector217>:
.globl vector217
vector217:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $217
c0102810:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102815:	e9 34 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010281a <vector218>:
.globl vector218
vector218:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $218
c010281c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102821:	e9 28 f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102826 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $219
c0102828:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010282d:	e9 1c f7 ff ff       	jmp    c0101f4e <__alltraps>

c0102832 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $220
c0102834:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102839:	e9 10 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010283e <vector221>:
.globl vector221
vector221:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $221
c0102840:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102845:	e9 04 f7 ff ff       	jmp    c0101f4e <__alltraps>

c010284a <vector222>:
.globl vector222
vector222:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $222
c010284c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102851:	e9 f8 f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102856 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $223
c0102858:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010285d:	e9 ec f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102862 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $224
c0102864:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102869:	e9 e0 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010286e <vector225>:
.globl vector225
vector225:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $225
c0102870:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102875:	e9 d4 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010287a <vector226>:
.globl vector226
vector226:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $226
c010287c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102881:	e9 c8 f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102886 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $227
c0102888:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010288d:	e9 bc f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102892 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $228
c0102894:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102899:	e9 b0 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010289e <vector229>:
.globl vector229
vector229:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $229
c01028a0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028a5:	e9 a4 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028aa <vector230>:
.globl vector230
vector230:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $230
c01028ac:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028b1:	e9 98 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028b6 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $231
c01028b8:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028bd:	e9 8c f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028c2 <vector232>:
.globl vector232
vector232:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $232
c01028c4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028c9:	e9 80 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028ce <vector233>:
.globl vector233
vector233:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $233
c01028d0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028d5:	e9 74 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028da <vector234>:
.globl vector234
vector234:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $234
c01028dc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028e1:	e9 68 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028e6 <vector235>:
.globl vector235
vector235:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $235
c01028e8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01028ed:	e9 5c f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028f2 <vector236>:
.globl vector236
vector236:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $236
c01028f4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01028f9:	e9 50 f6 ff ff       	jmp    c0101f4e <__alltraps>

c01028fe <vector237>:
.globl vector237
vector237:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $237
c0102900:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102905:	e9 44 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010290a <vector238>:
.globl vector238
vector238:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $238
c010290c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102911:	e9 38 f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102916 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $239
c0102918:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010291d:	e9 2c f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102922 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $240
c0102924:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102929:	e9 20 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010292e <vector241>:
.globl vector241
vector241:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $241
c0102930:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102935:	e9 14 f6 ff ff       	jmp    c0101f4e <__alltraps>

c010293a <vector242>:
.globl vector242
vector242:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $242
c010293c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102941:	e9 08 f6 ff ff       	jmp    c0101f4e <__alltraps>

c0102946 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $243
c0102948:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010294d:	e9 fc f5 ff ff       	jmp    c0101f4e <__alltraps>

c0102952 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $244
c0102954:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102959:	e9 f0 f5 ff ff       	jmp    c0101f4e <__alltraps>

c010295e <vector245>:
.globl vector245
vector245:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $245
c0102960:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102965:	e9 e4 f5 ff ff       	jmp    c0101f4e <__alltraps>

c010296a <vector246>:
.globl vector246
vector246:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $246
c010296c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102971:	e9 d8 f5 ff ff       	jmp    c0101f4e <__alltraps>

c0102976 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $247
c0102978:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010297d:	e9 cc f5 ff ff       	jmp    c0101f4e <__alltraps>

c0102982 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $248
c0102984:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102989:	e9 c0 f5 ff ff       	jmp    c0101f4e <__alltraps>

c010298e <vector249>:
.globl vector249
vector249:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $249
c0102990:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102995:	e9 b4 f5 ff ff       	jmp    c0101f4e <__alltraps>

c010299a <vector250>:
.globl vector250
vector250:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $250
c010299c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029a1:	e9 a8 f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029a6 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $251
c01029a8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029ad:	e9 9c f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029b2 <vector252>:
.globl vector252
vector252:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $252
c01029b4:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029b9:	e9 90 f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029be <vector253>:
.globl vector253
vector253:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $253
c01029c0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029c5:	e9 84 f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029ca <vector254>:
.globl vector254
vector254:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $254
c01029cc:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029d1:	e9 78 f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029d6 <vector255>:
.globl vector255
vector255:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $255
c01029d8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01029dd:	e9 6c f5 ff ff       	jmp    c0101f4e <__alltraps>

c01029e2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01029e2:	55                   	push   %ebp
c01029e3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01029e5:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01029eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ee:	29 d0                	sub    %edx,%eax
c01029f0:	c1 f8 02             	sar    $0x2,%eax
c01029f3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01029f9:	5d                   	pop    %ebp
c01029fa:	c3                   	ret    

c01029fb <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01029fb:	55                   	push   %ebp
c01029fc:	89 e5                	mov    %esp,%ebp
c01029fe:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a04:	89 04 24             	mov    %eax,(%esp)
c0102a07:	e8 d6 ff ff ff       	call   c01029e2 <page2ppn>
c0102a0c:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a0f:	89 ec                	mov    %ebp,%esp
c0102a11:	5d                   	pop    %ebp
c0102a12:	c3                   	ret    

c0102a13 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102a13:	55                   	push   %ebp
c0102a14:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a19:	8b 00                	mov    (%eax),%eax
}
c0102a1b:	5d                   	pop    %ebp
c0102a1c:	c3                   	ret    

c0102a1d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a1d:	55                   	push   %ebp
c0102a1e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a23:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a26:	89 10                	mov    %edx,(%eax)
}
c0102a28:	90                   	nop
c0102a29:	5d                   	pop    %ebp
c0102a2a:	c3                   	ret    

c0102a2b <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
c0102a2b:	55                   	push   %ebp
c0102a2c:	89 e5                	mov    %esp,%ebp
c0102a2e:	83 ec 10             	sub    $0x10,%esp
c0102a31:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm)
{
    elm->prev = elm->next = elm;
c0102a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a3e:	89 50 04             	mov    %edx,0x4(%eax)
c0102a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a44:	8b 50 04             	mov    0x4(%eax),%edx
c0102a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a4a:	89 10                	mov    %edx,(%eax)
}
c0102a4c:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0102a4d:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102a54:	00 00 00 
}
c0102a57:	90                   	nop
c0102a58:	89 ec                	mov    %ebp,%esp
c0102a5a:	5d                   	pop    %ebp
c0102a5b:	c3                   	ret    

c0102a5c <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
c0102a5c:	55                   	push   %ebp
c0102a5d:	89 e5                	mov    %esp,%ebp
c0102a5f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102a62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a66:	75 24                	jne    c0102a8c <default_init_memmap+0x30>
c0102a68:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0102a6f:	c0 
c0102a70:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102a77:	c0 
c0102a78:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102a7f:	00 
c0102a80:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102a87:	e8 5e e2 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102a92:	eb 7b                	jmp    c0102b0f <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
c0102a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a97:	83 c0 04             	add    $0x4,%eax
c0102a9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * */
static inline bool
test_bit(int nr, volatile void *addr)
{
    int oldbit;
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102aa7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102aaa:	0f a3 10             	bt     %edx,(%eax)
c0102aad:	19 c0                	sbb    %eax,%eax
c0102aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
                 : "=r"(oldbit)
                 : "m"(*(volatile long *)addr), "Ir"(nr));
    return oldbit != 0;
c0102ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102ab6:	0f 95 c0             	setne  %al
c0102ab9:	0f b6 c0             	movzbl %al,%eax
c0102abc:	85 c0                	test   %eax,%eax
c0102abe:	75 24                	jne    c0102ae4 <default_init_memmap+0x88>
c0102ac0:	c7 44 24 0c c1 66 10 	movl   $0xc01066c1,0xc(%esp)
c0102ac7:	c0 
c0102ac8:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102acf:	c0 
c0102ad0:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102ad7:	00 
c0102ad8:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102adf:	e8 06 e2 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c0102ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
c0102aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
c0102af8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102aff:	00 
c0102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b03:	89 04 24             	mov    %eax,(%esp)
c0102b06:	e8 12 ff ff ff       	call   c0102a1d <set_page_ref>
    for (; p != base + n; p++)
c0102b0b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b12:	89 d0                	mov    %edx,%eax
c0102b14:	c1 e0 02             	shl    $0x2,%eax
c0102b17:	01 d0                	add    %edx,%eax
c0102b19:	c1 e0 02             	shl    $0x2,%eax
c0102b1c:	89 c2                	mov    %eax,%edx
c0102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b21:	01 d0                	add    %edx,%eax
c0102b23:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102b26:	0f 85 68 ff ff ff    	jne    c0102a94 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
c0102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b2f:	83 c0 04             	add    $0x4,%eax
c0102b32:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b39:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0102b3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b42:	0f ab 10             	bts    %edx,(%eax)
}
c0102b45:	90                   	nop
    base->property = n;
c0102b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b49:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b4c:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102b4f:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102b55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b58:	01 d0                	add    %edx,%eax
c0102b5a:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
c0102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b62:	83 c0 0c             	add    $0xc,%eax
c0102b65:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c0102b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm)
{
    __list_add(elm, listelm->prev, listelm);
c0102b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b72:	8b 00                	mov    (%eax),%eax
c0102b74:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b77:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next)
{
    prev->next = next->prev = elm;
c0102b83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b89:	89 10                	mov    %edx,(%eax)
c0102b8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b8e:	8b 10                	mov    (%eax),%edx
c0102b90:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b93:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b96:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b9c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ba2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102ba5:	89 10                	mov    %edx,(%eax)
}
c0102ba7:	90                   	nop
}
c0102ba8:	90                   	nop
}
c0102ba9:	90                   	nop
c0102baa:	89 ec                	mov    %ebp,%esp
c0102bac:	5d                   	pop    %ebp
c0102bad:	c3                   	ret    

c0102bae <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0102bae:	55                   	push   %ebp
c0102baf:	89 e5                	mov    %esp,%ebp
c0102bb1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102bb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bb8:	75 24                	jne    c0102bde <default_alloc_pages+0x30>
c0102bba:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0102bc1:	c0 
c0102bc2:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102bc9:	c0 
c0102bca:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0102bd1:	00 
c0102bd2:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102bd9:	e8 0c e1 ff ff       	call   c0100cea <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
c0102bde:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102be3:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102be6:	76 0a                	jbe    c0102bf2 <default_alloc_pages+0x44>
    {
        return NULL;
c0102be8:	b8 00 00 00 00       	mov    $0x0,%eax
c0102bed:	e9 43 01 00 00       	jmp    c0102d35 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c0102bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102bf9:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0102c00:	eb 1c                	jmp    c0102c1e <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
c0102c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c05:	83 e8 0c             	sub    $0xc,%eax
c0102c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c0102c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c0e:	8b 40 08             	mov    0x8(%eax),%eax
c0102c11:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c14:	77 08                	ja     c0102c1e <default_alloc_pages+0x70>
        {
            page = p;
c0102c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102c1c:	eb 18                	jmp    c0102c36 <default_alloc_pages+0x88>
c0102c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c27:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c2d:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102c34:	75 cc                	jne    c0102c02 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c0102c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c3a:	0f 84 f2 00 00 00    	je     c0102d32 <default_alloc_pages+0x184>
    {
        if (page->property > n)
c0102c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c43:	8b 40 08             	mov    0x8(%eax),%eax
c0102c46:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c49:	0f 83 8f 00 00 00    	jae    c0102cde <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
c0102c4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c52:	89 d0                	mov    %edx,%eax
c0102c54:	c1 e0 02             	shl    $0x2,%eax
c0102c57:	01 d0                	add    %edx,%eax
c0102c59:	c1 e0 02             	shl    $0x2,%eax
c0102c5c:	89 c2                	mov    %eax,%edx
c0102c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c61:	01 d0                	add    %edx,%eax
c0102c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c69:	8b 40 08             	mov    0x8(%eax),%eax
c0102c6c:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c6f:	89 c2                	mov    %eax,%edx
c0102c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c74:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c7a:	83 c0 0c             	add    $0xc,%eax
c0102c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102c80:	83 c2 0c             	add    $0xc,%edx
c0102c83:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102c86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102c89:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c8c:	8b 40 04             	mov    0x4(%eax),%eax
c0102c8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c92:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102c95:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c98:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102c9b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0102c9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ca1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102ca4:	89 10                	mov    %edx,(%eax)
c0102ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ca9:	8b 10                	mov    (%eax),%edx
c0102cab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cae:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cb1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cb4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102cb7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cba:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cbd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102cc0:	89 10                	mov    %edx,(%eax)
}
c0102cc2:	90                   	nop
}
c0102cc3:	90                   	nop
            SetPageProperty(p);
c0102cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cc7:	83 c0 04             	add    $0x4,%eax
c0102cca:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btsl %1, %0"
c0102cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cda:	0f ab 10             	bts    %edx,(%eax)
}
c0102cdd:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
c0102cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce1:	83 c0 0c             	add    $0xc,%eax
c0102ce4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102ce7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102cea:	8b 40 04             	mov    0x4(%eax),%eax
c0102ced:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cf0:	8b 12                	mov    (%edx),%edx
c0102cf2:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102cf5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next)
{
    prev->next = next;
c0102cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cfb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102cfe:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d04:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d07:	89 10                	mov    %edx,(%eax)
}
c0102d09:	90                   	nop
}
c0102d0a:	90                   	nop
        nr_free -= n;
c0102d0b:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102d10:	2b 45 08             	sub    0x8(%ebp),%eax
c0102d13:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d1b:	83 c0 04             	add    $0x4,%eax
c0102d1e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d25:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile("btrl %1, %0"
c0102d28:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d2e:	0f b3 10             	btr    %edx,(%eax)
}
c0102d31:	90                   	nop
    }
    return page;
c0102d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d35:	89 ec                	mov    %ebp,%esp
c0102d37:	5d                   	pop    %ebp
c0102d38:	c3                   	ret    

c0102d39 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0102d39:	55                   	push   %ebp
c0102d3a:	89 e5                	mov    %esp,%ebp
c0102d3c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102d42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d46:	75 24                	jne    c0102d6c <default_free_pages+0x33>
c0102d48:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0102d4f:	c0 
c0102d50:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102d57:	c0 
c0102d58:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102d5f:	00 
c0102d60:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102d67:	e8 7e df ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102d72:	e9 9d 00 00 00       	jmp    c0102e14 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0102d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7a:	83 c0 04             	add    $0x4,%eax
c0102d7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102d84:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102d8d:	0f a3 10             	bt     %edx,(%eax)
c0102d90:	19 c0                	sbb    %eax,%eax
c0102d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102d95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d99:	0f 95 c0             	setne  %al
c0102d9c:	0f b6 c0             	movzbl %al,%eax
c0102d9f:	85 c0                	test   %eax,%eax
c0102da1:	75 2c                	jne    c0102dcf <default_free_pages+0x96>
c0102da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da6:	83 c0 04             	add    $0x4,%eax
c0102da9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102db0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0102db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102db6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102db9:	0f a3 10             	bt     %edx,(%eax)
c0102dbc:	19 c0                	sbb    %eax,%eax
c0102dbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102dc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102dc5:	0f 95 c0             	setne  %al
c0102dc8:	0f b6 c0             	movzbl %al,%eax
c0102dcb:	85 c0                	test   %eax,%eax
c0102dcd:	74 24                	je     c0102df3 <default_free_pages+0xba>
c0102dcf:	c7 44 24 0c d4 66 10 	movl   $0xc01066d4,0xc(%esp)
c0102dd6:	c0 
c0102dd7:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102dde:	c0 
c0102ddf:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0102de6:	00 
c0102de7:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102dee:	e8 f7 de ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c0102df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102dfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e04:	00 
c0102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e08:	89 04 24             	mov    %eax,(%esp)
c0102e0b:	e8 0d fc ff ff       	call   c0102a1d <set_page_ref>
    for (; p != base + n; p++)
c0102e10:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102e14:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e17:	89 d0                	mov    %edx,%eax
c0102e19:	c1 e0 02             	shl    $0x2,%eax
c0102e1c:	01 d0                	add    %edx,%eax
c0102e1e:	c1 e0 02             	shl    $0x2,%eax
c0102e21:	89 c2                	mov    %eax,%edx
c0102e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e26:	01 d0                	add    %edx,%eax
c0102e28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e2b:	0f 85 46 ff ff ff    	jne    c0102d77 <default_free_pages+0x3e>
    }
    base->property = n;
c0102e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e34:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e37:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102e3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3d:	83 c0 04             	add    $0x4,%eax
c0102e40:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102e47:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btsl %1, %0"
c0102e4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e4d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e50:	0f ab 10             	bts    %edx,(%eax)
}
c0102e53:	90                   	nop
c0102e54:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102e5e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
c0102e64:	e9 0e 01 00 00       	jmp    c0102f77 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
c0102e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e6c:	83 e8 0c             	sub    $0xc,%eax
c0102e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e75:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102e78:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e7b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
c0102e81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e84:	8b 50 08             	mov    0x8(%eax),%edx
c0102e87:	89 d0                	mov    %edx,%eax
c0102e89:	c1 e0 02             	shl    $0x2,%eax
c0102e8c:	01 d0                	add    %edx,%eax
c0102e8e:	c1 e0 02             	shl    $0x2,%eax
c0102e91:	89 c2                	mov    %eax,%edx
c0102e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e96:	01 d0                	add    %edx,%eax
c0102e98:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e9b:	75 5d                	jne    c0102efa <default_free_pages+0x1c1>
        {
            base->property += p->property;
c0102e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea0:	8b 50 08             	mov    0x8(%eax),%edx
c0102ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea6:	8b 40 08             	mov    0x8(%eax),%eax
c0102ea9:	01 c2                	add    %eax,%edx
c0102eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eae:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb4:	83 c0 04             	add    $0x4,%eax
c0102eb7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102ebe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile("btrl %1, %0"
c0102ec1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ec4:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102ec7:	0f b3 10             	btr    %edx,(%eax)
}
c0102eca:	90                   	nop
            list_del(&(p->page_link));
c0102ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ece:	83 c0 0c             	add    $0xc,%eax
c0102ed1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102ed4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ed7:	8b 40 04             	mov    0x4(%eax),%eax
c0102eda:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102edd:	8b 12                	mov    (%edx),%edx
c0102edf:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102ee2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102ee5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ee8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102eeb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102eee:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ef1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ef4:	89 10                	mov    %edx,(%eax)
}
c0102ef6:	90                   	nop
}
c0102ef7:	90                   	nop
c0102ef8:	eb 7d                	jmp    c0102f77 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
c0102efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efd:	8b 50 08             	mov    0x8(%eax),%edx
c0102f00:	89 d0                	mov    %edx,%eax
c0102f02:	c1 e0 02             	shl    $0x2,%eax
c0102f05:	01 d0                	add    %edx,%eax
c0102f07:	c1 e0 02             	shl    $0x2,%eax
c0102f0a:	89 c2                	mov    %eax,%edx
c0102f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0f:	01 d0                	add    %edx,%eax
c0102f11:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102f14:	75 61                	jne    c0102f77 <default_free_pages+0x23e>
        {
            p->property += base->property;
c0102f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f19:	8b 50 08             	mov    0x8(%eax),%edx
c0102f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f1f:	8b 40 08             	mov    0x8(%eax),%eax
c0102f22:	01 c2                	add    %eax,%edx
c0102f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f27:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f2d:	83 c0 04             	add    $0x4,%eax
c0102f30:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102f37:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile("btrl %1, %0"
c0102f3a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f3d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f40:	0f b3 10             	btr    %edx,(%eax)
}
c0102f43:	90                   	nop
            base = p;
c0102f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f47:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4d:	83 c0 0c             	add    $0xc,%eax
c0102f50:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f53:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f56:	8b 40 04             	mov    0x4(%eax),%eax
c0102f59:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102f5c:	8b 12                	mov    (%edx),%edx
c0102f5e:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102f61:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102f64:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f67:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f6a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f6d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f70:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102f73:	89 10                	mov    %edx,(%eax)
}
c0102f75:	90                   	nop
}
c0102f76:	90                   	nop
    while (le != &free_list)
c0102f77:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102f7e:	0f 85 e5 fe ff ff    	jne    c0102e69 <default_free_pages+0x130>
        }
    }
    le = &free_list;
c0102f84:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
c0102f8b:	eb 25                	jmp    c0102fb2 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
c0102f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f90:	83 e8 0c             	sub    $0xc,%eax
c0102f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
c0102f96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f99:	8b 50 08             	mov    0x8(%eax),%edx
c0102f9c:	89 d0                	mov    %edx,%eax
c0102f9e:	c1 e0 02             	shl    $0x2,%eax
c0102fa1:	01 d0                	add    %edx,%eax
c0102fa3:	c1 e0 02             	shl    $0x2,%eax
c0102fa6:	89 c2                	mov    %eax,%edx
c0102fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fab:	01 d0                	add    %edx,%eax
c0102fad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102fb0:	73 1a                	jae    c0102fcc <default_free_pages+0x293>
c0102fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb5:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0102fb8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102fbb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fc1:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102fc8:	75 c3                	jne    c0102f8d <default_free_pages+0x254>
c0102fca:	eb 01                	jmp    c0102fcd <default_free_pages+0x294>
        {
            break;
c0102fcc:	90                   	nop
        }
    }
    nr_free += n;
c0102fcd:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fd6:	01 d0                	add    %edx,%eax
c0102fd8:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(le, &(base->page_link));
c0102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fe0:	8d 50 0c             	lea    0xc(%eax),%edx
c0102fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fe6:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102fe9:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102fec:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fef:	8b 00                	mov    (%eax),%eax
c0102ff1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102ff4:	89 55 90             	mov    %edx,-0x70(%ebp)
c0102ff7:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0102ffa:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ffd:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
c0103000:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103003:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103006:	89 10                	mov    %edx,(%eax)
c0103008:	8b 45 88             	mov    -0x78(%ebp),%eax
c010300b:	8b 10                	mov    (%eax),%edx
c010300d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103010:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103013:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103016:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103019:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010301c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010301f:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103022:	89 10                	mov    %edx,(%eax)
}
c0103024:	90                   	nop
}
c0103025:	90                   	nop
}
c0103026:	90                   	nop
c0103027:	89 ec                	mov    %ebp,%esp
c0103029:	5d                   	pop    %ebp
c010302a:	c3                   	ret    

c010302b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c010302b:	55                   	push   %ebp
c010302c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010302e:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0103033:	5d                   	pop    %ebp
c0103034:	c3                   	ret    

c0103035 <basic_check>:

static void
basic_check(void)
{
c0103035:	55                   	push   %ebp
c0103036:	89 e5                	mov    %esp,%ebp
c0103038:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010303b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103042:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103045:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103048:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010304b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010304e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103055:	e8 df 0e 00 00       	call   c0103f39 <alloc_pages>
c010305a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010305d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103061:	75 24                	jne    c0103087 <basic_check+0x52>
c0103063:	c7 44 24 0c f9 66 10 	movl   $0xc01066f9,0xc(%esp)
c010306a:	c0 
c010306b:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103072:	c0 
c0103073:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010307a:	00 
c010307b:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103082:	e8 63 dc ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010308e:	e8 a6 0e 00 00       	call   c0103f39 <alloc_pages>
c0103093:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103096:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010309a:	75 24                	jne    c01030c0 <basic_check+0x8b>
c010309c:	c7 44 24 0c 15 67 10 	movl   $0xc0106715,0xc(%esp)
c01030a3:	c0 
c01030a4:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01030ab:	c0 
c01030ac:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01030b3:	00 
c01030b4:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01030bb:	e8 2a dc ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030c7:	e8 6d 0e 00 00       	call   c0103f39 <alloc_pages>
c01030cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030d3:	75 24                	jne    c01030f9 <basic_check+0xc4>
c01030d5:	c7 44 24 0c 31 67 10 	movl   $0xc0106731,0xc(%esp)
c01030dc:	c0 
c01030dd:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01030e4:	c0 
c01030e5:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01030ec:	00 
c01030ed:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01030f4:	e8 f1 db ff ff       	call   c0100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01030f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030ff:	74 10                	je     c0103111 <basic_check+0xdc>
c0103101:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103104:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103107:	74 08                	je     c0103111 <basic_check+0xdc>
c0103109:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010310c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010310f:	75 24                	jne    c0103135 <basic_check+0x100>
c0103111:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0103118:	c0 
c0103119:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103120:	c0 
c0103121:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103128:	00 
c0103129:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103130:	e8 b5 db ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103135:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103138:	89 04 24             	mov    %eax,(%esp)
c010313b:	e8 d3 f8 ff ff       	call   c0102a13 <page_ref>
c0103140:	85 c0                	test   %eax,%eax
c0103142:	75 1e                	jne    c0103162 <basic_check+0x12d>
c0103144:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103147:	89 04 24             	mov    %eax,(%esp)
c010314a:	e8 c4 f8 ff ff       	call   c0102a13 <page_ref>
c010314f:	85 c0                	test   %eax,%eax
c0103151:	75 0f                	jne    c0103162 <basic_check+0x12d>
c0103153:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103156:	89 04 24             	mov    %eax,(%esp)
c0103159:	e8 b5 f8 ff ff       	call   c0102a13 <page_ref>
c010315e:	85 c0                	test   %eax,%eax
c0103160:	74 24                	je     c0103186 <basic_check+0x151>
c0103162:	c7 44 24 0c 74 67 10 	movl   $0xc0106774,0xc(%esp)
c0103169:	c0 
c010316a:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103171:	c0 
c0103172:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103179:	00 
c010317a:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103181:	e8 64 db ff ff       	call   c0100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103186:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103189:	89 04 24             	mov    %eax,(%esp)
c010318c:	e8 6a f8 ff ff       	call   c01029fb <page2pa>
c0103191:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103197:	c1 e2 0c             	shl    $0xc,%edx
c010319a:	39 d0                	cmp    %edx,%eax
c010319c:	72 24                	jb     c01031c2 <basic_check+0x18d>
c010319e:	c7 44 24 0c b0 67 10 	movl   $0xc01067b0,0xc(%esp)
c01031a5:	c0 
c01031a6:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01031ad:	c0 
c01031ae:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01031b5:	00 
c01031b6:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01031bd:	e8 28 db ff ff       	call   c0100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031c5:	89 04 24             	mov    %eax,(%esp)
c01031c8:	e8 2e f8 ff ff       	call   c01029fb <page2pa>
c01031cd:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01031d3:	c1 e2 0c             	shl    $0xc,%edx
c01031d6:	39 d0                	cmp    %edx,%eax
c01031d8:	72 24                	jb     c01031fe <basic_check+0x1c9>
c01031da:	c7 44 24 0c cd 67 10 	movl   $0xc01067cd,0xc(%esp)
c01031e1:	c0 
c01031e2:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01031e9:	c0 
c01031ea:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01031f1:	00 
c01031f2:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01031f9:	e8 ec da ff ff       	call   c0100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103201:	89 04 24             	mov    %eax,(%esp)
c0103204:	e8 f2 f7 ff ff       	call   c01029fb <page2pa>
c0103209:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010320f:	c1 e2 0c             	shl    $0xc,%edx
c0103212:	39 d0                	cmp    %edx,%eax
c0103214:	72 24                	jb     c010323a <basic_check+0x205>
c0103216:	c7 44 24 0c ea 67 10 	movl   $0xc01067ea,0xc(%esp)
c010321d:	c0 
c010321e:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103225:	c0 
c0103226:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c010322d:	00 
c010322e:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103235:	e8 b0 da ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c010323a:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010323f:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103245:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103248:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010324b:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103252:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103255:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103258:	89 50 04             	mov    %edx,0x4(%eax)
c010325b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010325e:	8b 50 04             	mov    0x4(%eax),%edx
c0103261:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103264:	89 10                	mov    %edx,(%eax)
}
c0103266:	90                   	nop
c0103267:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c010326e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103271:	8b 40 04             	mov    0x4(%eax),%eax
c0103274:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103277:	0f 94 c0             	sete   %al
c010327a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010327d:	85 c0                	test   %eax,%eax
c010327f:	75 24                	jne    c01032a5 <basic_check+0x270>
c0103281:	c7 44 24 0c 07 68 10 	movl   $0xc0106807,0xc(%esp)
c0103288:	c0 
c0103289:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103290:	c0 
c0103291:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103298:	00 
c0103299:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01032a0:	e8 45 da ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c01032a5:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01032aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032ad:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01032b4:	00 00 00 

    assert(alloc_page() == NULL);
c01032b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032be:	e8 76 0c 00 00       	call   c0103f39 <alloc_pages>
c01032c3:	85 c0                	test   %eax,%eax
c01032c5:	74 24                	je     c01032eb <basic_check+0x2b6>
c01032c7:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c01032ce:	c0 
c01032cf:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01032d6:	c0 
c01032d7:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01032de:	00 
c01032df:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01032e6:	e8 ff d9 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c01032eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032f2:	00 
c01032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032f6:	89 04 24             	mov    %eax,(%esp)
c01032f9:	e8 75 0c 00 00       	call   c0103f73 <free_pages>
    free_page(p1);
c01032fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103305:	00 
c0103306:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103309:	89 04 24             	mov    %eax,(%esp)
c010330c:	e8 62 0c 00 00       	call   c0103f73 <free_pages>
    free_page(p2);
c0103311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103318:	00 
c0103319:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331c:	89 04 24             	mov    %eax,(%esp)
c010331f:	e8 4f 0c 00 00       	call   c0103f73 <free_pages>
    assert(nr_free == 3);
c0103324:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103329:	83 f8 03             	cmp    $0x3,%eax
c010332c:	74 24                	je     c0103352 <basic_check+0x31d>
c010332e:	c7 44 24 0c 33 68 10 	movl   $0xc0106833,0xc(%esp)
c0103335:	c0 
c0103336:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010333d:	c0 
c010333e:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103345:	00 
c0103346:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010334d:	e8 98 d9 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103352:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103359:	e8 db 0b 00 00       	call   c0103f39 <alloc_pages>
c010335e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103361:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103365:	75 24                	jne    c010338b <basic_check+0x356>
c0103367:	c7 44 24 0c f9 66 10 	movl   $0xc01066f9,0xc(%esp)
c010336e:	c0 
c010336f:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103376:	c0 
c0103377:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010337e:	00 
c010337f:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103386:	e8 5f d9 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c010338b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103392:	e8 a2 0b 00 00       	call   c0103f39 <alloc_pages>
c0103397:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010339a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010339e:	75 24                	jne    c01033c4 <basic_check+0x38f>
c01033a0:	c7 44 24 0c 15 67 10 	movl   $0xc0106715,0xc(%esp)
c01033a7:	c0 
c01033a8:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01033af:	c0 
c01033b0:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01033b7:	00 
c01033b8:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01033bf:	e8 26 d9 ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033cb:	e8 69 0b 00 00       	call   c0103f39 <alloc_pages>
c01033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033d7:	75 24                	jne    c01033fd <basic_check+0x3c8>
c01033d9:	c7 44 24 0c 31 67 10 	movl   $0xc0106731,0xc(%esp)
c01033e0:	c0 
c01033e1:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01033e8:	c0 
c01033e9:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01033f0:	00 
c01033f1:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01033f8:	e8 ed d8 ff ff       	call   c0100cea <__panic>

    assert(alloc_page() == NULL);
c01033fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103404:	e8 30 0b 00 00       	call   c0103f39 <alloc_pages>
c0103409:	85 c0                	test   %eax,%eax
c010340b:	74 24                	je     c0103431 <basic_check+0x3fc>
c010340d:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c0103414:	c0 
c0103415:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010341c:	c0 
c010341d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103424:	00 
c0103425:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010342c:	e8 b9 d8 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103438:	00 
c0103439:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010343c:	89 04 24             	mov    %eax,(%esp)
c010343f:	e8 2f 0b 00 00       	call   c0103f73 <free_pages>
c0103444:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c010344b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010344e:	8b 40 04             	mov    0x4(%eax),%eax
c0103451:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103454:	0f 94 c0             	sete   %al
c0103457:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010345a:	85 c0                	test   %eax,%eax
c010345c:	74 24                	je     c0103482 <basic_check+0x44d>
c010345e:	c7 44 24 0c 40 68 10 	movl   $0xc0106840,0xc(%esp)
c0103465:	c0 
c0103466:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010346d:	c0 
c010346e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103475:	00 
c0103476:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010347d:	e8 68 d8 ff ff       	call   c0100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103482:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103489:	e8 ab 0a 00 00       	call   c0103f39 <alloc_pages>
c010348e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103494:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103497:	74 24                	je     c01034bd <basic_check+0x488>
c0103499:	c7 44 24 0c 58 68 10 	movl   $0xc0106858,0xc(%esp)
c01034a0:	c0 
c01034a1:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01034a8:	c0 
c01034a9:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01034b0:	00 
c01034b1:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01034b8:	e8 2d d8 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c01034bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034c4:	e8 70 0a 00 00       	call   c0103f39 <alloc_pages>
c01034c9:	85 c0                	test   %eax,%eax
c01034cb:	74 24                	je     c01034f1 <basic_check+0x4bc>
c01034cd:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c01034d4:	c0 
c01034d5:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01034dc:	c0 
c01034dd:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01034e4:	00 
c01034e5:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01034ec:	e8 f9 d7 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c01034f1:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01034f6:	85 c0                	test   %eax,%eax
c01034f8:	74 24                	je     c010351e <basic_check+0x4e9>
c01034fa:	c7 44 24 0c 71 68 10 	movl   $0xc0106871,0xc(%esp)
c0103501:	c0 
c0103502:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103509:	c0 
c010350a:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103511:	00 
c0103512:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103519:	e8 cc d7 ff ff       	call   c0100cea <__panic>
    free_list = free_list_store;
c010351e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103521:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103524:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103529:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c010352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103532:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c0103537:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010353e:	00 
c010353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103542:	89 04 24             	mov    %eax,(%esp)
c0103545:	e8 29 0a 00 00       	call   c0103f73 <free_pages>
    free_page(p1);
c010354a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103551:	00 
c0103552:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103555:	89 04 24             	mov    %eax,(%esp)
c0103558:	e8 16 0a 00 00       	call   c0103f73 <free_pages>
    free_page(p2);
c010355d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103564:	00 
c0103565:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103568:	89 04 24             	mov    %eax,(%esp)
c010356b:	e8 03 0a 00 00       	call   c0103f73 <free_pages>
}
c0103570:	90                   	nop
c0103571:	89 ec                	mov    %ebp,%esp
c0103573:	5d                   	pop    %ebp
c0103574:	c3                   	ret    

c0103575 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c0103575:	55                   	push   %ebp
c0103576:	89 e5                	mov    %esp,%ebp
c0103578:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c010357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010358c:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103593:	eb 6a                	jmp    c01035ff <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c0103595:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103598:	83 e8 0c             	sub    $0xc,%eax
c010359b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c010359e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035a1:	83 c0 04             	add    $0x4,%eax
c01035a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01035ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035b4:	0f a3 10             	bt     %edx,(%eax)
c01035b7:	19 c0                	sbb    %eax,%eax
c01035b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035bc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035c0:	0f 95 c0             	setne  %al
c01035c3:	0f b6 c0             	movzbl %al,%eax
c01035c6:	85 c0                	test   %eax,%eax
c01035c8:	75 24                	jne    c01035ee <default_check+0x79>
c01035ca:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01035d1:	c0 
c01035d2:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01035d9:	c0 
c01035da:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01035e1:	00 
c01035e2:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01035e9:	e8 fc d6 ff ff       	call   c0100cea <__panic>
        count++, total += p->property;
c01035ee:	ff 45 f4             	incl   -0xc(%ebp)
c01035f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035f4:	8b 50 08             	mov    0x8(%eax),%edx
c01035f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035fa:	01 d0                	add    %edx,%eax
c01035fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103602:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103605:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103608:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c010360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010360e:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103615:	0f 85 7a ff ff ff    	jne    c0103595 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010361b:	e8 88 09 00 00       	call   c0103fa8 <nr_free_pages>
c0103620:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103623:	39 d0                	cmp    %edx,%eax
c0103625:	74 24                	je     c010364b <default_check+0xd6>
c0103627:	c7 44 24 0c 8e 68 10 	movl   $0xc010688e,0xc(%esp)
c010362e:	c0 
c010362f:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103636:	c0 
c0103637:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010363e:	00 
c010363f:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103646:	e8 9f d6 ff ff       	call   c0100cea <__panic>

    basic_check();
c010364b:	e8 e5 f9 ff ff       	call   c0103035 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103650:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103657:	e8 dd 08 00 00       	call   c0103f39 <alloc_pages>
c010365c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010365f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103663:	75 24                	jne    c0103689 <default_check+0x114>
c0103665:	c7 44 24 0c a7 68 10 	movl   $0xc01068a7,0xc(%esp)
c010366c:	c0 
c010366d:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103674:	c0 
c0103675:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010367c:	00 
c010367d:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103684:	e8 61 d6 ff ff       	call   c0100cea <__panic>
    assert(!PageProperty(p0));
c0103689:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010368c:	83 c0 04             	add    $0x4,%eax
c010368f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103696:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103699:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010369c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010369f:	0f a3 10             	bt     %edx,(%eax)
c01036a2:	19 c0                	sbb    %eax,%eax
c01036a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036ab:	0f 95 c0             	setne  %al
c01036ae:	0f b6 c0             	movzbl %al,%eax
c01036b1:	85 c0                	test   %eax,%eax
c01036b3:	74 24                	je     c01036d9 <default_check+0x164>
c01036b5:	c7 44 24 0c b2 68 10 	movl   $0xc01068b2,0xc(%esp)
c01036bc:	c0 
c01036bd:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01036c4:	c0 
c01036c5:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01036cc:	00 
c01036cd:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01036d4:	e8 11 d6 ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c01036d9:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01036de:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c01036e4:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036ea:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01036f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01036f7:	89 50 04             	mov    %edx,0x4(%eax)
c01036fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036fd:	8b 50 04             	mov    0x4(%eax),%edx
c0103700:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103703:	89 10                	mov    %edx,(%eax)
}
c0103705:	90                   	nop
c0103706:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c010370d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103710:	8b 40 04             	mov    0x4(%eax),%eax
c0103713:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103716:	0f 94 c0             	sete   %al
c0103719:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010371c:	85 c0                	test   %eax,%eax
c010371e:	75 24                	jne    c0103744 <default_check+0x1cf>
c0103720:	c7 44 24 0c 07 68 10 	movl   $0xc0106807,0xc(%esp)
c0103727:	c0 
c0103728:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010372f:	c0 
c0103730:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103737:	00 
c0103738:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010373f:	e8 a6 d5 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010374b:	e8 e9 07 00 00       	call   c0103f39 <alloc_pages>
c0103750:	85 c0                	test   %eax,%eax
c0103752:	74 24                	je     c0103778 <default_check+0x203>
c0103754:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c010375b:	c0 
c010375c:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103763:	c0 
c0103764:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010376b:	00 
c010376c:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103773:	e8 72 d5 ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c0103778:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010377d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103780:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0103787:	00 00 00 

    free_pages(p0 + 2, 3);
c010378a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010378d:	83 c0 28             	add    $0x28,%eax
c0103790:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103797:	00 
c0103798:	89 04 24             	mov    %eax,(%esp)
c010379b:	e8 d3 07 00 00       	call   c0103f73 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037a0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037a7:	e8 8d 07 00 00       	call   c0103f39 <alloc_pages>
c01037ac:	85 c0                	test   %eax,%eax
c01037ae:	74 24                	je     c01037d4 <default_check+0x25f>
c01037b0:	c7 44 24 0c c4 68 10 	movl   $0xc01068c4,0xc(%esp)
c01037b7:	c0 
c01037b8:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01037bf:	c0 
c01037c0:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01037c7:	00 
c01037c8:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01037cf:	e8 16 d5 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037d7:	83 c0 28             	add    $0x28,%eax
c01037da:	83 c0 04             	add    $0x4,%eax
c01037dd:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c01037e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037ea:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037ed:	0f a3 10             	bt     %edx,(%eax)
c01037f0:	19 c0                	sbb    %eax,%eax
c01037f2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01037f5:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01037f9:	0f 95 c0             	setne  %al
c01037fc:	0f b6 c0             	movzbl %al,%eax
c01037ff:	85 c0                	test   %eax,%eax
c0103801:	74 0e                	je     c0103811 <default_check+0x29c>
c0103803:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103806:	83 c0 28             	add    $0x28,%eax
c0103809:	8b 40 08             	mov    0x8(%eax),%eax
c010380c:	83 f8 03             	cmp    $0x3,%eax
c010380f:	74 24                	je     c0103835 <default_check+0x2c0>
c0103811:	c7 44 24 0c dc 68 10 	movl   $0xc01068dc,0xc(%esp)
c0103818:	c0 
c0103819:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103820:	c0 
c0103821:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103828:	00 
c0103829:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103830:	e8 b5 d4 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103835:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010383c:	e8 f8 06 00 00       	call   c0103f39 <alloc_pages>
c0103841:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103844:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103848:	75 24                	jne    c010386e <default_check+0x2f9>
c010384a:	c7 44 24 0c 08 69 10 	movl   $0xc0106908,0xc(%esp)
c0103851:	c0 
c0103852:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103859:	c0 
c010385a:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103861:	00 
c0103862:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103869:	e8 7c d4 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c010386e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103875:	e8 bf 06 00 00       	call   c0103f39 <alloc_pages>
c010387a:	85 c0                	test   %eax,%eax
c010387c:	74 24                	je     c01038a2 <default_check+0x32d>
c010387e:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c0103885:	c0 
c0103886:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010388d:	c0 
c010388e:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103895:	00 
c0103896:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010389d:	e8 48 d4 ff ff       	call   c0100cea <__panic>
    assert(p0 + 2 == p1);
c01038a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038a5:	83 c0 28             	add    $0x28,%eax
c01038a8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01038ab:	74 24                	je     c01038d1 <default_check+0x35c>
c01038ad:	c7 44 24 0c 26 69 10 	movl   $0xc0106926,0xc(%esp)
c01038b4:	c0 
c01038b5:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01038bc:	c0 
c01038bd:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01038c4:	00 
c01038c5:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01038cc:	e8 19 d4 ff ff       	call   c0100cea <__panic>

    p2 = p0 + 1;
c01038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038d4:	83 c0 14             	add    $0x14,%eax
c01038d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038e1:	00 
c01038e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038e5:	89 04 24             	mov    %eax,(%esp)
c01038e8:	e8 86 06 00 00       	call   c0103f73 <free_pages>
    free_pages(p1, 3);
c01038ed:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01038f4:	00 
c01038f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038f8:	89 04 24             	mov    %eax,(%esp)
c01038fb:	e8 73 06 00 00       	call   c0103f73 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103900:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103903:	83 c0 04             	add    $0x4,%eax
c0103906:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010390d:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c0103910:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103913:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103916:	0f a3 10             	bt     %edx,(%eax)
c0103919:	19 c0                	sbb    %eax,%eax
c010391b:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010391e:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103922:	0f 95 c0             	setne  %al
c0103925:	0f b6 c0             	movzbl %al,%eax
c0103928:	85 c0                	test   %eax,%eax
c010392a:	74 0b                	je     c0103937 <default_check+0x3c2>
c010392c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010392f:	8b 40 08             	mov    0x8(%eax),%eax
c0103932:	83 f8 01             	cmp    $0x1,%eax
c0103935:	74 24                	je     c010395b <default_check+0x3e6>
c0103937:	c7 44 24 0c 34 69 10 	movl   $0xc0106934,0xc(%esp)
c010393e:	c0 
c010393f:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103946:	c0 
c0103947:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010394e:	00 
c010394f:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103956:	e8 8f d3 ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010395b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010395e:	83 c0 04             	add    $0x4,%eax
c0103961:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103968:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btl %2, %1; sbbl %0,%0"
c010396b:	8b 45 90             	mov    -0x70(%ebp),%eax
c010396e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103971:	0f a3 10             	bt     %edx,(%eax)
c0103974:	19 c0                	sbb    %eax,%eax
c0103976:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103979:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010397d:	0f 95 c0             	setne  %al
c0103980:	0f b6 c0             	movzbl %al,%eax
c0103983:	85 c0                	test   %eax,%eax
c0103985:	74 0b                	je     c0103992 <default_check+0x41d>
c0103987:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010398a:	8b 40 08             	mov    0x8(%eax),%eax
c010398d:	83 f8 03             	cmp    $0x3,%eax
c0103990:	74 24                	je     c01039b6 <default_check+0x441>
c0103992:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103999:	c0 
c010399a:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01039a1:	c0 
c01039a2:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01039a9:	00 
c01039aa:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01039b1:	e8 34 d3 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039bd:	e8 77 05 00 00       	call   c0103f39 <alloc_pages>
c01039c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039c8:	83 e8 14             	sub    $0x14,%eax
c01039cb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039ce:	74 24                	je     c01039f4 <default_check+0x47f>
c01039d0:	c7 44 24 0c 82 69 10 	movl   $0xc0106982,0xc(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01039df:	c0 
c01039e0:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01039e7:	00 
c01039e8:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01039ef:	e8 f6 d2 ff ff       	call   c0100cea <__panic>
    free_page(p0);
c01039f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039fb:	00 
c01039fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039ff:	89 04 24             	mov    %eax,(%esp)
c0103a02:	e8 6c 05 00 00       	call   c0103f73 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a07:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a0e:	e8 26 05 00 00       	call   c0103f39 <alloc_pages>
c0103a13:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a16:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a19:	83 c0 14             	add    $0x14,%eax
c0103a1c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a1f:	74 24                	je     c0103a45 <default_check+0x4d0>
c0103a21:	c7 44 24 0c a0 69 10 	movl   $0xc01069a0,0xc(%esp)
c0103a28:	c0 
c0103a29:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103a30:	c0 
c0103a31:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0103a38:	00 
c0103a39:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103a40:	e8 a5 d2 ff ff       	call   c0100cea <__panic>

    free_pages(p0, 2);
c0103a45:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a4c:	00 
c0103a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a50:	89 04 24             	mov    %eax,(%esp)
c0103a53:	e8 1b 05 00 00       	call   c0103f73 <free_pages>
    free_page(p2);
c0103a58:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a5f:	00 
c0103a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a63:	89 04 24             	mov    %eax,(%esp)
c0103a66:	e8 08 05 00 00       	call   c0103f73 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a6b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a72:	e8 c2 04 00 00       	call   c0103f39 <alloc_pages>
c0103a77:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103a7e:	75 24                	jne    c0103aa4 <default_check+0x52f>
c0103a80:	c7 44 24 0c c0 69 10 	movl   $0xc01069c0,0xc(%esp)
c0103a87:	c0 
c0103a88:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103a8f:	c0 
c0103a90:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103a97:	00 
c0103a98:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103a9f:	e8 46 d2 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aab:	e8 89 04 00 00       	call   c0103f39 <alloc_pages>
c0103ab0:	85 c0                	test   %eax,%eax
c0103ab2:	74 24                	je     c0103ad8 <default_check+0x563>
c0103ab4:	c7 44 24 0c 1e 68 10 	movl   $0xc010681e,0xc(%esp)
c0103abb:	c0 
c0103abc:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103ac3:	c0 
c0103ac4:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0103acb:	00 
c0103acc:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103ad3:	e8 12 d2 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0103ad8:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103add:	85 c0                	test   %eax,%eax
c0103adf:	74 24                	je     c0103b05 <default_check+0x590>
c0103ae1:	c7 44 24 0c 71 68 10 	movl   $0xc0106871,0xc(%esp)
c0103ae8:	c0 
c0103ae9:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103af0:	c0 
c0103af1:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103af8:	00 
c0103af9:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103b00:	e8 e5 d1 ff ff       	call   c0100cea <__panic>
    nr_free = nr_free_store;
c0103b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b08:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c0103b0d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b10:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b13:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103b18:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c0103b1e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b25:	00 
c0103b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b29:	89 04 24             	mov    %eax,(%esp)
c0103b2c:	e8 42 04 00 00       	call   c0103f73 <free_pages>

    le = &free_list;
c0103b31:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103b38:	eb 5a                	jmp    c0103b94 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
c0103b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3d:	8b 40 04             	mov    0x4(%eax),%eax
c0103b40:	8b 00                	mov    (%eax),%eax
c0103b42:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b45:	75 0d                	jne    c0103b54 <default_check+0x5df>
c0103b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b4a:	8b 00                	mov    (%eax),%eax
c0103b4c:	8b 40 04             	mov    0x4(%eax),%eax
c0103b4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b52:	74 24                	je     c0103b78 <default_check+0x603>
c0103b54:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c0103b5b:	c0 
c0103b5c:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103b63:	c0 
c0103b64:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0103b6b:	00 
c0103b6c:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103b73:	e8 72 d1 ff ff       	call   c0100cea <__panic>
        struct Page *p = le2page(le, page_link);
c0103b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7b:	83 e8 0c             	sub    $0xc,%eax
c0103b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103b81:	ff 4d f4             	decl   -0xc(%ebp)
c0103b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b87:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b8a:	8b 48 08             	mov    0x8(%eax),%ecx
c0103b8d:	89 d0                	mov    %edx,%eax
c0103b8f:	29 c8                	sub    %ecx,%eax
c0103b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b97:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103b9a:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b9d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ba3:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103baa:	75 8e                	jne    c0103b3a <default_check+0x5c5>
    }
    assert(count == 0);
c0103bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bb0:	74 24                	je     c0103bd6 <default_check+0x661>
c0103bb2:	c7 44 24 0c 0d 6a 10 	movl   $0xc0106a0d,0xc(%esp)
c0103bb9:	c0 
c0103bba:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103bc1:	c0 
c0103bc2:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0103bc9:	00 
c0103bca:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103bd1:	e8 14 d1 ff ff       	call   c0100cea <__panic>
    assert(total == 0);
c0103bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bda:	74 24                	je     c0103c00 <default_check+0x68b>
c0103bdc:	c7 44 24 0c 18 6a 10 	movl   $0xc0106a18,0xc(%esp)
c0103be3:	c0 
c0103be4:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103beb:	c0 
c0103bec:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c0103bf3:	00 
c0103bf4:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103bfb:	e8 ea d0 ff ff       	call   c0100cea <__panic>
}
c0103c00:	90                   	nop
c0103c01:	89 ec                	mov    %ebp,%esp
c0103c03:	5d                   	pop    %ebp
c0103c04:	c3                   	ret    

c0103c05 <page2ppn>:
page2ppn(struct Page *page) {
c0103c05:	55                   	push   %ebp
c0103c06:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c08:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0103c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c11:	29 d0                	sub    %edx,%eax
c0103c13:	c1 f8 02             	sar    $0x2,%eax
c0103c16:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c1c:	5d                   	pop    %ebp
c0103c1d:	c3                   	ret    

c0103c1e <page2pa>:
page2pa(struct Page *page) {
c0103c1e:	55                   	push   %ebp
c0103c1f:	89 e5                	mov    %esp,%ebp
c0103c21:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c27:	89 04 24             	mov    %eax,(%esp)
c0103c2a:	e8 d6 ff ff ff       	call   c0103c05 <page2ppn>
c0103c2f:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c32:	89 ec                	mov    %ebp,%esp
c0103c34:	5d                   	pop    %ebp
c0103c35:	c3                   	ret    

c0103c36 <pa2page>:
pa2page(uintptr_t pa) {
c0103c36:	55                   	push   %ebp
c0103c37:	89 e5                	mov    %esp,%ebp
c0103c39:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3f:	c1 e8 0c             	shr    $0xc,%eax
c0103c42:	89 c2                	mov    %eax,%edx
c0103c44:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103c49:	39 c2                	cmp    %eax,%edx
c0103c4b:	72 1c                	jb     c0103c69 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c4d:	c7 44 24 08 54 6a 10 	movl   $0xc0106a54,0x8(%esp)
c0103c54:	c0 
c0103c55:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c5c:	00 
c0103c5d:	c7 04 24 73 6a 10 c0 	movl   $0xc0106a73,(%esp)
c0103c64:	e8 81 d0 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c0103c69:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c72:	c1 e8 0c             	shr    $0xc,%eax
c0103c75:	89 c2                	mov    %eax,%edx
c0103c77:	89 d0                	mov    %edx,%eax
c0103c79:	c1 e0 02             	shl    $0x2,%eax
c0103c7c:	01 d0                	add    %edx,%eax
c0103c7e:	c1 e0 02             	shl    $0x2,%eax
c0103c81:	01 c8                	add    %ecx,%eax
}
c0103c83:	89 ec                	mov    %ebp,%esp
c0103c85:	5d                   	pop    %ebp
c0103c86:	c3                   	ret    

c0103c87 <page2kva>:
page2kva(struct Page *page) {
c0103c87:	55                   	push   %ebp
c0103c88:	89 e5                	mov    %esp,%ebp
c0103c8a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c90:	89 04 24             	mov    %eax,(%esp)
c0103c93:	e8 86 ff ff ff       	call   c0103c1e <page2pa>
c0103c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9e:	c1 e8 0c             	shr    $0xc,%eax
c0103ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ca4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103ca9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103cac:	72 23                	jb     c0103cd1 <page2kva+0x4a>
c0103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103cb5:	c7 44 24 08 84 6a 10 	movl   $0xc0106a84,0x8(%esp)
c0103cbc:	c0 
c0103cbd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cc4:	00 
c0103cc5:	c7 04 24 73 6a 10 c0 	movl   $0xc0106a73,(%esp)
c0103ccc:	e8 19 d0 ff ff       	call   c0100cea <__panic>
c0103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cd4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103cd9:	89 ec                	mov    %ebp,%esp
c0103cdb:	5d                   	pop    %ebp
c0103cdc:	c3                   	ret    

c0103cdd <pte2page>:
pte2page(pte_t pte) {
c0103cdd:	55                   	push   %ebp
c0103cde:	89 e5                	mov    %esp,%ebp
c0103ce0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce6:	83 e0 01             	and    $0x1,%eax
c0103ce9:	85 c0                	test   %eax,%eax
c0103ceb:	75 1c                	jne    c0103d09 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ced:	c7 44 24 08 a8 6a 10 	movl   $0xc0106aa8,0x8(%esp)
c0103cf4:	c0 
c0103cf5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cfc:	00 
c0103cfd:	c7 04 24 73 6a 10 c0 	movl   $0xc0106a73,(%esp)
c0103d04:	e8 e1 cf ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d11:	89 04 24             	mov    %eax,(%esp)
c0103d14:	e8 1d ff ff ff       	call   c0103c36 <pa2page>
}
c0103d19:	89 ec                	mov    %ebp,%esp
c0103d1b:	5d                   	pop    %ebp
c0103d1c:	c3                   	ret    

c0103d1d <pde2page>:
pde2page(pde_t pde) {
c0103d1d:	55                   	push   %ebp
c0103d1e:	89 e5                	mov    %esp,%ebp
c0103d20:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d2b:	89 04 24             	mov    %eax,(%esp)
c0103d2e:	e8 03 ff ff ff       	call   c0103c36 <pa2page>
}
c0103d33:	89 ec                	mov    %ebp,%esp
c0103d35:	5d                   	pop    %ebp
c0103d36:	c3                   	ret    

c0103d37 <page_ref>:
page_ref(struct Page *page) {
c0103d37:	55                   	push   %ebp
c0103d38:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3d:	8b 00                	mov    (%eax),%eax
}
c0103d3f:	5d                   	pop    %ebp
c0103d40:	c3                   	ret    

c0103d41 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d41:	55                   	push   %ebp
c0103d42:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d47:	8b 00                	mov    (%eax),%eax
c0103d49:	8d 50 01             	lea    0x1(%eax),%edx
c0103d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d4f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d54:	8b 00                	mov    (%eax),%eax
}
c0103d56:	5d                   	pop    %ebp
c0103d57:	c3                   	ret    

c0103d58 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d58:	55                   	push   %ebp
c0103d59:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d5e:	8b 00                	mov    (%eax),%eax
c0103d60:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d66:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6b:	8b 00                	mov    (%eax),%eax
}
c0103d6d:	5d                   	pop    %ebp
c0103d6e:	c3                   	ret    

c0103d6f <__intr_save>:
{
c0103d6f:	55                   	push   %ebp
c0103d70:	89 e5                	mov    %esp,%ebp
c0103d72:	83 ec 18             	sub    $0x18,%esp
    asm volatile("pushfl; popl %0"
c0103d75:	9c                   	pushf  
c0103d76:	58                   	pop    %eax
c0103d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF)
c0103d7d:	25 00 02 00 00       	and    $0x200,%eax
c0103d82:	85 c0                	test   %eax,%eax
c0103d84:	74 0c                	je     c0103d92 <__intr_save+0x23>
        intr_disable();
c0103d86:	e8 b8 d9 ff ff       	call   c0101743 <intr_disable>
        return 1;
c0103d8b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d90:	eb 05                	jmp    c0103d97 <__intr_save+0x28>
    return 0;
c0103d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d97:	89 ec                	mov    %ebp,%esp
c0103d99:	5d                   	pop    %ebp
c0103d9a:	c3                   	ret    

c0103d9b <__intr_restore>:
{
c0103d9b:	55                   	push   %ebp
c0103d9c:	89 e5                	mov    %esp,%ebp
c0103d9e:	83 ec 08             	sub    $0x8,%esp
    if (flag)
c0103da1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103da5:	74 05                	je     c0103dac <__intr_restore+0x11>
        intr_enable();
c0103da7:	e8 8f d9 ff ff       	call   c010173b <intr_enable>
}
c0103dac:	90                   	nop
c0103dad:	89 ec                	mov    %ebp,%esp
c0103daf:	5d                   	pop    %ebp
c0103db0:	c3                   	ret    

c0103db1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103db1:	55                   	push   %ebp
c0103db2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103dba:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dbf:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103dc1:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dc6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103dc8:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dcd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103dcf:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dd4:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103dd6:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ddb:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103ddd:	ea e4 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103de4
}
c0103de4:	90                   	nop
c0103de5:	5d                   	pop    %ebp
c0103de6:	c3                   	ret    

c0103de7 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103de7:	55                   	push   %ebp
c0103de8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ded:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103df2:	90                   	nop
c0103df3:	5d                   	pop    %ebp
c0103df4:	c3                   	ret    

c0103df5 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103df5:	55                   	push   %ebp
c0103df6:	89 e5                	mov    %esp,%ebp
c0103df8:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103dfb:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103e00:	89 04 24             	mov    %eax,(%esp)
c0103e03:	e8 df ff ff ff       	call   c0103de7 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e08:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103e0f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e11:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103e18:	68 00 
c0103e1a:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e1f:	0f b7 c0             	movzwl %ax,%eax
c0103e22:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103e28:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e2d:	c1 e8 10             	shr    $0x10,%eax
c0103e30:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103e35:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e3c:	24 f0                	and    $0xf0,%al
c0103e3e:	0c 09                	or     $0x9,%al
c0103e40:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e45:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e4c:	24 ef                	and    $0xef,%al
c0103e4e:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e53:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e5a:	24 9f                	and    $0x9f,%al
c0103e5c:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e61:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e68:	0c 80                	or     $0x80,%al
c0103e6a:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e6f:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e76:	24 f0                	and    $0xf0,%al
c0103e78:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e7d:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e84:	24 ef                	and    $0xef,%al
c0103e86:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e8b:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e92:	24 df                	and    $0xdf,%al
c0103e94:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e99:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ea0:	0c 40                	or     $0x40,%al
c0103ea2:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ea7:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103eae:	24 7f                	and    $0x7f,%al
c0103eb0:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eb5:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103eba:	c1 e8 18             	shr    $0x18,%eax
c0103ebd:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ec2:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103ec9:	e8 e3 fe ff ff       	call   c0103db1 <lgdt>
c0103ece:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile("ltr %0" ::"r"(sel)
c0103ed4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103ed8:	0f 00 d8             	ltr    %ax
}
c0103edb:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103edc:	90                   	nop
c0103edd:	89 ec                	mov    %ebp,%esp
c0103edf:	5d                   	pop    %ebp
c0103ee0:	c3                   	ret    

c0103ee1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ee1:	55                   	push   %ebp
c0103ee2:	89 e5                	mov    %esp,%ebp
c0103ee4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ee7:	c7 05 ac be 11 c0 38 	movl   $0xc0106a38,0xc011beac
c0103eee:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ef1:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103ef6:	8b 00                	mov    (%eax),%eax
c0103ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103efc:	c7 04 24 d4 6a 10 c0 	movl   $0xc0106ad4,(%esp)
c0103f03:	e8 5d c4 ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c0103f08:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f0d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f10:	ff d0                	call   *%eax
}
c0103f12:	90                   	nop
c0103f13:	89 ec                	mov    %ebp,%esp
c0103f15:	5d                   	pop    %ebp
c0103f16:	c3                   	ret    

c0103f17 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f17:	55                   	push   %ebp
c0103f18:	89 e5                	mov    %esp,%ebp
c0103f1a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f1d:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f22:	8b 40 08             	mov    0x8(%eax),%eax
c0103f25:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f28:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f2c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f2f:	89 14 24             	mov    %edx,(%esp)
c0103f32:	ff d0                	call   *%eax
}
c0103f34:	90                   	nop
c0103f35:	89 ec                	mov    %ebp,%esp
c0103f37:	5d                   	pop    %ebp
c0103f38:	c3                   	ret    

c0103f39 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f39:	55                   	push   %ebp
c0103f3a:	89 e5                	mov    %esp,%ebp
c0103f3c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f46:	e8 24 fe ff ff       	call   c0103d6f <__intr_save>
c0103f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f4e:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f53:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f56:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f59:	89 14 24             	mov    %edx,(%esp)
c0103f5c:	ff d0                	call   *%eax
c0103f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f64:	89 04 24             	mov    %eax,(%esp)
c0103f67:	e8 2f fe ff ff       	call   c0103d9b <__intr_restore>
    return page;
c0103f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f6f:	89 ec                	mov    %ebp,%esp
c0103f71:	5d                   	pop    %ebp
c0103f72:	c3                   	ret    

c0103f73 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f73:	55                   	push   %ebp
c0103f74:	89 e5                	mov    %esp,%ebp
c0103f76:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f79:	e8 f1 fd ff ff       	call   c0103d6f <__intr_save>
c0103f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f81:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f86:	8b 40 10             	mov    0x10(%eax),%eax
c0103f89:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f8c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f90:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f93:	89 14 24             	mov    %edx,(%esp)
c0103f96:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f9b:	89 04 24             	mov    %eax,(%esp)
c0103f9e:	e8 f8 fd ff ff       	call   c0103d9b <__intr_restore>
}
c0103fa3:	90                   	nop
c0103fa4:	89 ec                	mov    %ebp,%esp
c0103fa6:	5d                   	pop    %ebp
c0103fa7:	c3                   	ret    

c0103fa8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fa8:	55                   	push   %ebp
c0103fa9:	89 e5                	mov    %esp,%ebp
c0103fab:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fae:	e8 bc fd ff ff       	call   c0103d6f <__intr_save>
c0103fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fb6:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103fbb:	8b 40 14             	mov    0x14(%eax),%eax
c0103fbe:	ff d0                	call   *%eax
c0103fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fc6:	89 04 24             	mov    %eax,(%esp)
c0103fc9:	e8 cd fd ff ff       	call   c0103d9b <__intr_restore>
    return ret;
c0103fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fd1:	89 ec                	mov    %ebp,%esp
c0103fd3:	5d                   	pop    %ebp
c0103fd4:	c3                   	ret    

c0103fd5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fd5:	55                   	push   %ebp
c0103fd6:	89 e5                	mov    %esp,%ebp
c0103fd8:	57                   	push   %edi
c0103fd9:	56                   	push   %esi
c0103fda:	53                   	push   %ebx
c0103fdb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103fe1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103fe8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103ff6:	c7 04 24 eb 6a 10 c0 	movl   $0xc0106aeb,(%esp)
c0103ffd:	e8 63 c3 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104002:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104009:	e9 0c 01 00 00       	jmp    c010411a <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010400e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104011:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104014:	89 d0                	mov    %edx,%eax
c0104016:	c1 e0 02             	shl    $0x2,%eax
c0104019:	01 d0                	add    %edx,%eax
c010401b:	c1 e0 02             	shl    $0x2,%eax
c010401e:	01 c8                	add    %ecx,%eax
c0104020:	8b 50 08             	mov    0x8(%eax),%edx
c0104023:	8b 40 04             	mov    0x4(%eax),%eax
c0104026:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104029:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010402c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010402f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104032:	89 d0                	mov    %edx,%eax
c0104034:	c1 e0 02             	shl    $0x2,%eax
c0104037:	01 d0                	add    %edx,%eax
c0104039:	c1 e0 02             	shl    $0x2,%eax
c010403c:	01 c8                	add    %ecx,%eax
c010403e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104041:	8b 58 10             	mov    0x10(%eax),%ebx
c0104044:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104047:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010404a:	01 c8                	add    %ecx,%eax
c010404c:	11 da                	adc    %ebx,%edx
c010404e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104051:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104054:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104057:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405a:	89 d0                	mov    %edx,%eax
c010405c:	c1 e0 02             	shl    $0x2,%eax
c010405f:	01 d0                	add    %edx,%eax
c0104061:	c1 e0 02             	shl    $0x2,%eax
c0104064:	01 c8                	add    %ecx,%eax
c0104066:	83 c0 14             	add    $0x14,%eax
c0104069:	8b 00                	mov    (%eax),%eax
c010406b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104071:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104074:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104077:	83 c0 ff             	add    $0xffffffff,%eax
c010407a:	83 d2 ff             	adc    $0xffffffff,%edx
c010407d:	89 c6                	mov    %eax,%esi
c010407f:	89 d7                	mov    %edx,%edi
c0104081:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104084:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104087:	89 d0                	mov    %edx,%eax
c0104089:	c1 e0 02             	shl    $0x2,%eax
c010408c:	01 d0                	add    %edx,%eax
c010408e:	c1 e0 02             	shl    $0x2,%eax
c0104091:	01 c8                	add    %ecx,%eax
c0104093:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104096:	8b 58 10             	mov    0x10(%eax),%ebx
c0104099:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010409f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040a3:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040a7:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040ab:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040ae:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040b5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040b9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040c1:	c7 04 24 f8 6a 10 c0 	movl   $0xc0106af8,(%esp)
c01040c8:	e8 98 c2 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040cd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040d3:	89 d0                	mov    %edx,%eax
c01040d5:	c1 e0 02             	shl    $0x2,%eax
c01040d8:	01 d0                	add    %edx,%eax
c01040da:	c1 e0 02             	shl    $0x2,%eax
c01040dd:	01 c8                	add    %ecx,%eax
c01040df:	83 c0 14             	add    $0x14,%eax
c01040e2:	8b 00                	mov    (%eax),%eax
c01040e4:	83 f8 01             	cmp    $0x1,%eax
c01040e7:	75 2e                	jne    c0104117 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c01040e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040ef:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01040f2:	89 d0                	mov    %edx,%eax
c01040f4:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c01040f7:	73 1e                	jae    c0104117 <page_init+0x142>
c01040f9:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01040fe:	b8 00 00 00 00       	mov    $0x0,%eax
c0104103:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104106:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104109:	72 0c                	jb     c0104117 <page_init+0x142>
                maxpa = end;
c010410b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010410e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104111:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104114:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104117:	ff 45 dc             	incl   -0x24(%ebp)
c010411a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010411d:	8b 00                	mov    (%eax),%eax
c010411f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104122:	0f 8c e6 fe ff ff    	jl     c010400e <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104128:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010412d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104132:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104135:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104138:	73 0e                	jae    c0104148 <page_init+0x173>
        maxpa = KMEMSIZE;
c010413a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104141:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104148:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010414b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010414e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104152:	c1 ea 0c             	shr    $0xc,%edx
c0104155:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010415a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104161:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0104166:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104169:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010416c:	01 d0                	add    %edx,%eax
c010416e:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104171:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104174:	ba 00 00 00 00       	mov    $0x0,%edx
c0104179:	f7 75 c0             	divl   -0x40(%ebp)
c010417c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010417f:	29 d0                	sub    %edx,%eax
c0104181:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c0104186:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010418d:	eb 2f                	jmp    c01041be <page_init+0x1e9>
        SetPageReserved(pages + i);
c010418f:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0104195:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104198:	89 d0                	mov    %edx,%eax
c010419a:	c1 e0 02             	shl    $0x2,%eax
c010419d:	01 d0                	add    %edx,%eax
c010419f:	c1 e0 02             	shl    $0x2,%eax
c01041a2:	01 c8                	add    %ecx,%eax
c01041a4:	83 c0 04             	add    $0x4,%eax
c01041a7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01041ae:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile("btsl %1, %0"
c01041b1:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041b4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041b7:	0f ab 10             	bts    %edx,(%eax)
}
c01041ba:	90                   	nop
    for (i = 0; i < npage; i ++) {
c01041bb:	ff 45 dc             	incl   -0x24(%ebp)
c01041be:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041c1:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01041c6:	39 c2                	cmp    %eax,%edx
c01041c8:	72 c5                	jb     c010418f <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041ca:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01041d0:	89 d0                	mov    %edx,%eax
c01041d2:	c1 e0 02             	shl    $0x2,%eax
c01041d5:	01 d0                	add    %edx,%eax
c01041d7:	c1 e0 02             	shl    $0x2,%eax
c01041da:	89 c2                	mov    %eax,%edx
c01041dc:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c01041e1:	01 d0                	add    %edx,%eax
c01041e3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01041e6:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01041ed:	77 23                	ja     c0104212 <page_init+0x23d>
c01041ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041f6:	c7 44 24 08 28 6b 10 	movl   $0xc0106b28,0x8(%esp)
c01041fd:	c0 
c01041fe:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104205:	00 
c0104206:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010420d:	e8 d8 ca ff ff       	call   c0100cea <__panic>
c0104212:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104215:	05 00 00 00 40       	add    $0x40000000,%eax
c010421a:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010421d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104224:	e9 53 01 00 00       	jmp    c010437c <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104229:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010422c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010422f:	89 d0                	mov    %edx,%eax
c0104231:	c1 e0 02             	shl    $0x2,%eax
c0104234:	01 d0                	add    %edx,%eax
c0104236:	c1 e0 02             	shl    $0x2,%eax
c0104239:	01 c8                	add    %ecx,%eax
c010423b:	8b 50 08             	mov    0x8(%eax),%edx
c010423e:	8b 40 04             	mov    0x4(%eax),%eax
c0104241:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104244:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104247:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010424a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010424d:	89 d0                	mov    %edx,%eax
c010424f:	c1 e0 02             	shl    $0x2,%eax
c0104252:	01 d0                	add    %edx,%eax
c0104254:	c1 e0 02             	shl    $0x2,%eax
c0104257:	01 c8                	add    %ecx,%eax
c0104259:	8b 48 0c             	mov    0xc(%eax),%ecx
c010425c:	8b 58 10             	mov    0x10(%eax),%ebx
c010425f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104265:	01 c8                	add    %ecx,%eax
c0104267:	11 da                	adc    %ebx,%edx
c0104269:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010426c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010426f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104272:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104275:	89 d0                	mov    %edx,%eax
c0104277:	c1 e0 02             	shl    $0x2,%eax
c010427a:	01 d0                	add    %edx,%eax
c010427c:	c1 e0 02             	shl    $0x2,%eax
c010427f:	01 c8                	add    %ecx,%eax
c0104281:	83 c0 14             	add    $0x14,%eax
c0104284:	8b 00                	mov    (%eax),%eax
c0104286:	83 f8 01             	cmp    $0x1,%eax
c0104289:	0f 85 ea 00 00 00    	jne    c0104379 <page_init+0x3a4>
            if (begin < freemem) {
c010428f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104292:	ba 00 00 00 00       	mov    $0x0,%edx
c0104297:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010429a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010429d:	19 d1                	sbb    %edx,%ecx
c010429f:	73 0d                	jae    c01042ae <page_init+0x2d9>
                begin = freemem;
c01042a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042ae:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01042b3:	b8 00 00 00 00       	mov    $0x0,%eax
c01042b8:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01042bb:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042be:	73 0e                	jae    c01042ce <page_init+0x2f9>
                end = KMEMSIZE;
c01042c0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042c7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042d4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042d7:	89 d0                	mov    %edx,%eax
c01042d9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042dc:	0f 83 97 00 00 00    	jae    c0104379 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c01042e2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01042e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042ef:	01 d0                	add    %edx,%eax
c01042f1:	48                   	dec    %eax
c01042f2:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01042f5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01042f8:	ba 00 00 00 00       	mov    $0x0,%edx
c01042fd:	f7 75 b0             	divl   -0x50(%ebp)
c0104300:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104303:	29 d0                	sub    %edx,%eax
c0104305:	ba 00 00 00 00       	mov    $0x0,%edx
c010430a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010430d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104310:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104313:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104316:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104319:	ba 00 00 00 00       	mov    $0x0,%edx
c010431e:	89 c7                	mov    %eax,%edi
c0104320:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104326:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104329:	89 d0                	mov    %edx,%eax
c010432b:	83 e0 00             	and    $0x0,%eax
c010432e:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104331:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104334:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104337:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010433a:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010433d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104340:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104343:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104346:	89 d0                	mov    %edx,%eax
c0104348:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010434b:	73 2c                	jae    c0104379 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010434d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104350:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104353:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104356:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104359:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010435d:	c1 ea 0c             	shr    $0xc,%edx
c0104360:	89 c3                	mov    %eax,%ebx
c0104362:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104365:	89 04 24             	mov    %eax,(%esp)
c0104368:	e8 c9 f8 ff ff       	call   c0103c36 <pa2page>
c010436d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104371:	89 04 24             	mov    %eax,(%esp)
c0104374:	e8 9e fb ff ff       	call   c0103f17 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0104379:	ff 45 dc             	incl   -0x24(%ebp)
c010437c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010437f:	8b 00                	mov    (%eax),%eax
c0104381:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104384:	0f 8c 9f fe ff ff    	jl     c0104229 <page_init+0x254>
                }
            }
        }
    }
}
c010438a:	90                   	nop
c010438b:	90                   	nop
c010438c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104392:	5b                   	pop    %ebx
c0104393:	5e                   	pop    %esi
c0104394:	5f                   	pop    %edi
c0104395:	5d                   	pop    %ebp
c0104396:	c3                   	ret    

c0104397 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104397:	55                   	push   %ebp
c0104398:	89 e5                	mov    %esp,%ebp
c010439a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010439d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043a0:	33 45 14             	xor    0x14(%ebp),%eax
c01043a3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043a8:	85 c0                	test   %eax,%eax
c01043aa:	74 24                	je     c01043d0 <boot_map_segment+0x39>
c01043ac:	c7 44 24 0c 5a 6b 10 	movl   $0xc0106b5a,0xc(%esp)
c01043b3:	c0 
c01043b4:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c01043bb:	c0 
c01043bc:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01043c3:	00 
c01043c4:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01043cb:	e8 1a c9 ff ff       	call   c0100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01043d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043da:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043df:	89 c2                	mov    %eax,%edx
c01043e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01043e4:	01 c2                	add    %eax,%edx
c01043e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043e9:	01 d0                	add    %edx,%eax
c01043eb:	48                   	dec    %eax
c01043ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043f2:	ba 00 00 00 00       	mov    $0x0,%edx
c01043f7:	f7 75 f0             	divl   -0x10(%ebp)
c01043fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043fd:	29 d0                	sub    %edx,%eax
c01043ff:	c1 e8 0c             	shr    $0xc,%eax
c0104402:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104405:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104408:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010440b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010440e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104413:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104416:	8b 45 14             	mov    0x14(%ebp),%eax
c0104419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010441c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104424:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104427:	eb 68                	jmp    c0104491 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104429:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104430:	00 
c0104431:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104434:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104438:	8b 45 08             	mov    0x8(%ebp),%eax
c010443b:	89 04 24             	mov    %eax,(%esp)
c010443e:	e8 88 01 00 00       	call   c01045cb <get_pte>
c0104443:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104446:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010444a:	75 24                	jne    c0104470 <boot_map_segment+0xd9>
c010444c:	c7 44 24 0c 86 6b 10 	movl   $0xc0106b86,0xc(%esp)
c0104453:	c0 
c0104454:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010445b:	c0 
c010445c:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104463:	00 
c0104464:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010446b:	e8 7a c8 ff ff       	call   c0100cea <__panic>
        *ptep = pa | PTE_P | perm;
c0104470:	8b 45 14             	mov    0x14(%ebp),%eax
c0104473:	0b 45 18             	or     0x18(%ebp),%eax
c0104476:	83 c8 01             	or     $0x1,%eax
c0104479:	89 c2                	mov    %eax,%edx
c010447b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010447e:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104480:	ff 4d f4             	decl   -0xc(%ebp)
c0104483:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010448a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104495:	75 92                	jne    c0104429 <boot_map_segment+0x92>
    }
}
c0104497:	90                   	nop
c0104498:	90                   	nop
c0104499:	89 ec                	mov    %ebp,%esp
c010449b:	5d                   	pop    %ebp
c010449c:	c3                   	ret    

c010449d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010449d:	55                   	push   %ebp
c010449e:	89 e5                	mov    %esp,%ebp
c01044a0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044aa:	e8 8a fa ff ff       	call   c0103f39 <alloc_pages>
c01044af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b6:	75 1c                	jne    c01044d4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044b8:	c7 44 24 08 93 6b 10 	movl   $0xc0106b93,0x8(%esp)
c01044bf:	c0 
c01044c0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01044c7:	00 
c01044c8:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01044cf:	e8 16 c8 ff ff       	call   c0100cea <__panic>
    }
    return page2kva(p);
c01044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d7:	89 04 24             	mov    %eax,(%esp)
c01044da:	e8 a8 f7 ff ff       	call   c0103c87 <page2kva>
}
c01044df:	89 ec                	mov    %ebp,%esp
c01044e1:	5d                   	pop    %ebp
c01044e2:	c3                   	ret    

c01044e3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01044e3:	55                   	push   %ebp
c01044e4:	89 e5                	mov    %esp,%ebp
c01044e6:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01044e9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044f1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044f8:	77 23                	ja     c010451d <pmm_init+0x3a>
c01044fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104501:	c7 44 24 08 28 6b 10 	movl   $0xc0106b28,0x8(%esp)
c0104508:	c0 
c0104509:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104510:	00 
c0104511:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104518:	e8 cd c7 ff ff       	call   c0100cea <__panic>
c010451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104520:	05 00 00 00 40       	add    $0x40000000,%eax
c0104525:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010452a:	e8 b2 f9 ff ff       	call   c0103ee1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010452f:	e8 a1 fa ff ff       	call   c0103fd5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104534:	e8 74 02 00 00       	call   c01047ad <check_alloc_page>

    check_pgdir();
c0104539:	e8 90 02 00 00       	call   c01047ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010453e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104543:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104546:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010454d:	77 23                	ja     c0104572 <pmm_init+0x8f>
c010454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104552:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104556:	c7 44 24 08 28 6b 10 	movl   $0xc0106b28,0x8(%esp)
c010455d:	c0 
c010455e:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104565:	00 
c0104566:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010456d:	e8 78 c7 ff ff       	call   c0100cea <__panic>
c0104572:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104575:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010457b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104580:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104585:	83 ca 03             	or     $0x3,%edx
c0104588:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010458a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010458f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104596:	00 
c0104597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010459e:	00 
c010459f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045a6:	38 
c01045a7:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045ae:	c0 
c01045af:	89 04 24             	mov    %eax,(%esp)
c01045b2:	e8 e0 fd ff ff       	call   c0104397 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045b7:	e8 39 f8 ff ff       	call   c0103df5 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045bc:	e8 ab 08 00 00       	call   c0104e6c <check_boot_pgdir>

    print_pgdir();
c01045c1:	e8 28 0d 00 00       	call   c01052ee <print_pgdir>

}
c01045c6:	90                   	nop
c01045c7:	89 ec                	mov    %ebp,%esp
c01045c9:	5d                   	pop    %ebp
c01045ca:	c3                   	ret    

c01045cb <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045cb:	55                   	push   %ebp
c01045cc:	89 e5                	mov    %esp,%ebp
c01045ce:	83 ec 10             	sub    $0x10,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    pde_t *pdep = &pgdir[PDX(la)];
c01045d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d4:	c1 e8 16             	shr    $0x16,%eax
c01045d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045de:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e1:	01 d0                	add    %edx,%eax
c01045e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01045e6:	90                   	nop
c01045e7:	89 ec                	mov    %ebp,%esp
c01045e9:	5d                   	pop    %ebp
c01045ea:	c3                   	ret    

c01045eb <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01045eb:	55                   	push   %ebp
c01045ec:	89 e5                	mov    %esp,%ebp
c01045ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045f8:	00 
c01045f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104600:	8b 45 08             	mov    0x8(%ebp),%eax
c0104603:	89 04 24             	mov    %eax,(%esp)
c0104606:	e8 c0 ff ff ff       	call   c01045cb <get_pte>
c010460b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010460e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104612:	74 08                	je     c010461c <get_page+0x31>
        *ptep_store = ptep;
c0104614:	8b 45 10             	mov    0x10(%ebp),%eax
c0104617:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010461a:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010461c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104620:	74 1b                	je     c010463d <get_page+0x52>
c0104622:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104625:	8b 00                	mov    (%eax),%eax
c0104627:	83 e0 01             	and    $0x1,%eax
c010462a:	85 c0                	test   %eax,%eax
c010462c:	74 0f                	je     c010463d <get_page+0x52>
        return pte2page(*ptep);
c010462e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104631:	8b 00                	mov    (%eax),%eax
c0104633:	89 04 24             	mov    %eax,(%esp)
c0104636:	e8 a2 f6 ff ff       	call   c0103cdd <pte2page>
c010463b:	eb 05                	jmp    c0104642 <get_page+0x57>
    }
    return NULL;
c010463d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104642:	89 ec                	mov    %ebp,%esp
c0104644:	5d                   	pop    %ebp
c0104645:	c3                   	ret    

c0104646 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104646:	55                   	push   %ebp
c0104647:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104649:	90                   	nop
c010464a:	5d                   	pop    %ebp
c010464b:	c3                   	ret    

c010464c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010464c:	55                   	push   %ebp
c010464d:	89 e5                	mov    %esp,%ebp
c010464f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104652:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104659:	00 
c010465a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104661:	8b 45 08             	mov    0x8(%ebp),%eax
c0104664:	89 04 24             	mov    %eax,(%esp)
c0104667:	e8 5f ff ff ff       	call   c01045cb <get_pte>
c010466c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010466f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104673:	74 19                	je     c010468e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104675:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104678:	89 44 24 08          	mov    %eax,0x8(%esp)
c010467c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010467f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104683:	8b 45 08             	mov    0x8(%ebp),%eax
c0104686:	89 04 24             	mov    %eax,(%esp)
c0104689:	e8 b8 ff ff ff       	call   c0104646 <page_remove_pte>
    }
}
c010468e:	90                   	nop
c010468f:	89 ec                	mov    %ebp,%esp
c0104691:	5d                   	pop    %ebp
c0104692:	c3                   	ret    

c0104693 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104693:	55                   	push   %ebp
c0104694:	89 e5                	mov    %esp,%ebp
c0104696:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104699:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046a0:	00 
c01046a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01046a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ab:	89 04 24             	mov    %eax,(%esp)
c01046ae:	e8 18 ff ff ff       	call   c01045cb <get_pte>
c01046b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ba:	75 0a                	jne    c01046c6 <page_insert+0x33>
        return -E_NO_MEM;
c01046bc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046c1:	e9 84 00 00 00       	jmp    c010474a <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c9:	89 04 24             	mov    %eax,(%esp)
c01046cc:	e8 70 f6 ff ff       	call   c0103d41 <page_ref_inc>
    if (*ptep & PTE_P) {
c01046d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d4:	8b 00                	mov    (%eax),%eax
c01046d6:	83 e0 01             	and    $0x1,%eax
c01046d9:	85 c0                	test   %eax,%eax
c01046db:	74 3e                	je     c010471b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e0:	8b 00                	mov    (%eax),%eax
c01046e2:	89 04 24             	mov    %eax,(%esp)
c01046e5:	e8 f3 f5 ff ff       	call   c0103cdd <pte2page>
c01046ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046f3:	75 0d                	jne    c0104702 <page_insert+0x6f>
            page_ref_dec(page);
c01046f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f8:	89 04 24             	mov    %eax,(%esp)
c01046fb:	e8 58 f6 ff ff       	call   c0103d58 <page_ref_dec>
c0104700:	eb 19                	jmp    c010471b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104705:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104709:	8b 45 10             	mov    0x10(%ebp),%eax
c010470c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104710:	8b 45 08             	mov    0x8(%ebp),%eax
c0104713:	89 04 24             	mov    %eax,(%esp)
c0104716:	e8 2b ff ff ff       	call   c0104646 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010471b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010471e:	89 04 24             	mov    %eax,(%esp)
c0104721:	e8 f8 f4 ff ff       	call   c0103c1e <page2pa>
c0104726:	0b 45 14             	or     0x14(%ebp),%eax
c0104729:	83 c8 01             	or     $0x1,%eax
c010472c:	89 c2                	mov    %eax,%edx
c010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104731:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104733:	8b 45 10             	mov    0x10(%ebp),%eax
c0104736:	89 44 24 04          	mov    %eax,0x4(%esp)
c010473a:	8b 45 08             	mov    0x8(%ebp),%eax
c010473d:	89 04 24             	mov    %eax,(%esp)
c0104740:	e8 09 00 00 00       	call   c010474e <tlb_invalidate>
    return 0;
c0104745:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010474a:	89 ec                	mov    %ebp,%esp
c010474c:	5d                   	pop    %ebp
c010474d:	c3                   	ret    

c010474e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010474e:	55                   	push   %ebp
c010474f:	89 e5                	mov    %esp,%ebp
c0104751:	83 ec 28             	sub    $0x28,%esp

static inline uintptr_t
rcr3(void)
{
    uintptr_t cr3;
    asm volatile("mov %%cr3, %0"
c0104754:	0f 20 d8             	mov    %cr3,%eax
c0104757:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 : "=r"(cr3)::"memory");
    return cr3;
c010475a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010475d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104760:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104763:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010476a:	77 23                	ja     c010478f <tlb_invalidate+0x41>
c010476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104773:	c7 44 24 08 28 6b 10 	movl   $0xc0106b28,0x8(%esp)
c010477a:	c0 
c010477b:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
c0104782:	00 
c0104783:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010478a:	e8 5b c5 ff ff       	call   c0100cea <__panic>
c010478f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104792:	05 00 00 00 40       	add    $0x40000000,%eax
c0104797:	39 d0                	cmp    %edx,%eax
c0104799:	75 0d                	jne    c01047a8 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c010479b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010479e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr)
{
    asm volatile("invlpg (%0)" ::"r"(addr)
c01047a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a4:	0f 01 38             	invlpg (%eax)
                 : "memory");
}
c01047a7:	90                   	nop
    }
}
c01047a8:	90                   	nop
c01047a9:	89 ec                	mov    %ebp,%esp
c01047ab:	5d                   	pop    %ebp
c01047ac:	c3                   	ret    

c01047ad <check_alloc_page>:

static void
check_alloc_page(void) {
c01047ad:	55                   	push   %ebp
c01047ae:	89 e5                	mov    %esp,%ebp
c01047b0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047b3:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c01047b8:	8b 40 18             	mov    0x18(%eax),%eax
c01047bb:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047bd:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01047c4:	e8 9c bb ff ff       	call   c0100365 <cprintf>
}
c01047c9:	90                   	nop
c01047ca:	89 ec                	mov    %ebp,%esp
c01047cc:	5d                   	pop    %ebp
c01047cd:	c3                   	ret    

c01047ce <check_pgdir>:

static void
check_pgdir(void) {
c01047ce:	55                   	push   %ebp
c01047cf:	89 e5                	mov    %esp,%ebp
c01047d1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047d4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01047d9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047de:	76 24                	jbe    c0104804 <check_pgdir+0x36>
c01047e0:	c7 44 24 0c cb 6b 10 	movl   $0xc0106bcb,0xc(%esp)
c01047e7:	c0 
c01047e8:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c01047ef:	c0 
c01047f0:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c01047f7:	00 
c01047f8:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01047ff:	e8 e6 c4 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104804:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104809:	85 c0                	test   %eax,%eax
c010480b:	74 0e                	je     c010481b <check_pgdir+0x4d>
c010480d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104812:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104817:	85 c0                	test   %eax,%eax
c0104819:	74 24                	je     c010483f <check_pgdir+0x71>
c010481b:	c7 44 24 0c e8 6b 10 	movl   $0xc0106be8,0xc(%esp)
c0104822:	c0 
c0104823:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010482a:	c0 
c010482b:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
c0104832:	00 
c0104833:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010483a:	e8 ab c4 ff ff       	call   c0100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010483f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104844:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010484b:	00 
c010484c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104853:	00 
c0104854:	89 04 24             	mov    %eax,(%esp)
c0104857:	e8 8f fd ff ff       	call   c01045eb <get_page>
c010485c:	85 c0                	test   %eax,%eax
c010485e:	74 24                	je     c0104884 <check_pgdir+0xb6>
c0104860:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104867:	c0 
c0104868:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010486f:	c0 
c0104870:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c0104877:	00 
c0104878:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010487f:	e8 66 c4 ff ff       	call   c0100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104884:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010488b:	e8 a9 f6 ff ff       	call   c0103f39 <alloc_pages>
c0104890:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104893:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104898:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010489f:	00 
c01048a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048a7:	00 
c01048a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048ab:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048af:	89 04 24             	mov    %eax,(%esp)
c01048b2:	e8 dc fd ff ff       	call   c0104693 <page_insert>
c01048b7:	85 c0                	test   %eax,%eax
c01048b9:	74 24                	je     c01048df <check_pgdir+0x111>
c01048bb:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c01048c2:	c0 
c01048c3:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c01048ca:	c0 
c01048cb:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c01048d2:	00 
c01048d3:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01048da:	e8 0b c4 ff ff       	call   c0100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048df:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048eb:	00 
c01048ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048f3:	00 
c01048f4:	89 04 24             	mov    %eax,(%esp)
c01048f7:	e8 cf fc ff ff       	call   c01045cb <get_pte>
c01048fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104903:	75 24                	jne    c0104929 <check_pgdir+0x15b>
c0104905:	c7 44 24 0c 74 6c 10 	movl   $0xc0106c74,0xc(%esp)
c010490c:	c0 
c010490d:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104914:	c0 
c0104915:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010491c:	00 
c010491d:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104924:	e8 c1 c3 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0104929:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010492c:	8b 00                	mov    (%eax),%eax
c010492e:	89 04 24             	mov    %eax,(%esp)
c0104931:	e8 a7 f3 ff ff       	call   c0103cdd <pte2page>
c0104936:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104939:	74 24                	je     c010495f <check_pgdir+0x191>
c010493b:	c7 44 24 0c a1 6c 10 	movl   $0xc0106ca1,0xc(%esp)
c0104942:	c0 
c0104943:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010494a:	c0 
c010494b:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0104952:	00 
c0104953:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010495a:	e8 8b c3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 1);
c010495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104962:	89 04 24             	mov    %eax,(%esp)
c0104965:	e8 cd f3 ff ff       	call   c0103d37 <page_ref>
c010496a:	83 f8 01             	cmp    $0x1,%eax
c010496d:	74 24                	je     c0104993 <check_pgdir+0x1c5>
c010496f:	c7 44 24 0c b7 6c 10 	movl   $0xc0106cb7,0xc(%esp)
c0104976:	c0 
c0104977:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010497e:	c0 
c010497f:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104986:	00 
c0104987:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010498e:	e8 57 c3 ff ff       	call   c0100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104993:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104998:	8b 00                	mov    (%eax),%eax
c010499a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010499f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049a5:	c1 e8 0c             	shr    $0xc,%eax
c01049a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049ab:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01049b0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049b3:	72 23                	jb     c01049d8 <check_pgdir+0x20a>
c01049b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049bc:	c7 44 24 08 84 6a 10 	movl   $0xc0106a84,0x8(%esp)
c01049c3:	c0 
c01049c4:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c01049cb:	00 
c01049cc:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01049d3:	e8 12 c3 ff ff       	call   c0100cea <__panic>
c01049d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049db:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049e0:	83 c0 04             	add    $0x4,%eax
c01049e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049e6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049f2:	00 
c01049f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049fa:	00 
c01049fb:	89 04 24             	mov    %eax,(%esp)
c01049fe:	e8 c8 fb ff ff       	call   c01045cb <get_pte>
c0104a03:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a06:	74 24                	je     c0104a2c <check_pgdir+0x25e>
c0104a08:	c7 44 24 0c cc 6c 10 	movl   $0xc0106ccc,0xc(%esp)
c0104a0f:	c0 
c0104a10:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104a17:	c0 
c0104a18:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c0104a1f:	00 
c0104a20:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104a27:	e8 be c2 ff ff       	call   c0100cea <__panic>

    p2 = alloc_page();
c0104a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a33:	e8 01 f5 ff ff       	call   c0103f39 <alloc_pages>
c0104a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a3b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a40:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a47:	00 
c0104a48:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a4f:	00 
c0104a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a53:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a57:	89 04 24             	mov    %eax,(%esp)
c0104a5a:	e8 34 fc ff ff       	call   c0104693 <page_insert>
c0104a5f:	85 c0                	test   %eax,%eax
c0104a61:	74 24                	je     c0104a87 <check_pgdir+0x2b9>
c0104a63:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104a6a:	c0 
c0104a6b:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104a72:	c0 
c0104a73:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104a7a:	00 
c0104a7b:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104a82:	e8 63 c2 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a87:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a93:	00 
c0104a94:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a9b:	00 
c0104a9c:	89 04 24             	mov    %eax,(%esp)
c0104a9f:	e8 27 fb ff ff       	call   c01045cb <get_pte>
c0104aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104aa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104aab:	75 24                	jne    c0104ad1 <check_pgdir+0x303>
c0104aad:	c7 44 24 0c 2c 6d 10 	movl   $0xc0106d2c,0xc(%esp)
c0104ab4:	c0 
c0104ab5:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104abc:	c0 
c0104abd:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104ac4:	00 
c0104ac5:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104acc:	e8 19 c2 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_U);
c0104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad4:	8b 00                	mov    (%eax),%eax
c0104ad6:	83 e0 04             	and    $0x4,%eax
c0104ad9:	85 c0                	test   %eax,%eax
c0104adb:	75 24                	jne    c0104b01 <check_pgdir+0x333>
c0104add:	c7 44 24 0c 5c 6d 10 	movl   $0xc0106d5c,0xc(%esp)
c0104ae4:	c0 
c0104ae5:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104aec:	c0 
c0104aed:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104af4:	00 
c0104af5:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104afc:	e8 e9 c1 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_W);
c0104b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b04:	8b 00                	mov    (%eax),%eax
c0104b06:	83 e0 02             	and    $0x2,%eax
c0104b09:	85 c0                	test   %eax,%eax
c0104b0b:	75 24                	jne    c0104b31 <check_pgdir+0x363>
c0104b0d:	c7 44 24 0c 6a 6d 10 	movl   $0xc0106d6a,0xc(%esp)
c0104b14:	c0 
c0104b15:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104b24:	00 
c0104b25:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104b2c:	e8 b9 c1 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b31:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b36:	8b 00                	mov    (%eax),%eax
c0104b38:	83 e0 04             	and    $0x4,%eax
c0104b3b:	85 c0                	test   %eax,%eax
c0104b3d:	75 24                	jne    c0104b63 <check_pgdir+0x395>
c0104b3f:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0104b56:	00 
c0104b57:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104b5e:	e8 87 c1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 1);
c0104b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b66:	89 04 24             	mov    %eax,(%esp)
c0104b69:	e8 c9 f1 ff ff       	call   c0103d37 <page_ref>
c0104b6e:	83 f8 01             	cmp    $0x1,%eax
c0104b71:	74 24                	je     c0104b97 <check_pgdir+0x3c9>
c0104b73:	c7 44 24 0c 8e 6d 10 	movl   $0xc0106d8e,0xc(%esp)
c0104b7a:	c0 
c0104b7b:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104b82:	c0 
c0104b83:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104b8a:	00 
c0104b8b:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104b92:	e8 53 c1 ff ff       	call   c0100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b97:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b9c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104ba3:	00 
c0104ba4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bab:	00 
c0104bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104baf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bb3:	89 04 24             	mov    %eax,(%esp)
c0104bb6:	e8 d8 fa ff ff       	call   c0104693 <page_insert>
c0104bbb:	85 c0                	test   %eax,%eax
c0104bbd:	74 24                	je     c0104be3 <check_pgdir+0x415>
c0104bbf:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104bc6:	c0 
c0104bc7:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104bce:	c0 
c0104bcf:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104bd6:	00 
c0104bd7:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104bde:	e8 07 c1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 2);
c0104be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be6:	89 04 24             	mov    %eax,(%esp)
c0104be9:	e8 49 f1 ff ff       	call   c0103d37 <page_ref>
c0104bee:	83 f8 02             	cmp    $0x2,%eax
c0104bf1:	74 24                	je     c0104c17 <check_pgdir+0x449>
c0104bf3:	c7 44 24 0c cc 6d 10 	movl   $0xc0106dcc,0xc(%esp)
c0104bfa:	c0 
c0104bfb:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104c02:	c0 
c0104c03:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104c0a:	00 
c0104c0b:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104c12:	e8 d3 c0 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c1a:	89 04 24             	mov    %eax,(%esp)
c0104c1d:	e8 15 f1 ff ff       	call   c0103d37 <page_ref>
c0104c22:	85 c0                	test   %eax,%eax
c0104c24:	74 24                	je     c0104c4a <check_pgdir+0x47c>
c0104c26:	c7 44 24 0c de 6d 10 	movl   $0xc0106dde,0xc(%esp)
c0104c2d:	c0 
c0104c2e:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104c35:	c0 
c0104c36:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104c3d:	00 
c0104c3e:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104c45:	e8 a0 c0 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c4a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c56:	00 
c0104c57:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c5e:	00 
c0104c5f:	89 04 24             	mov    %eax,(%esp)
c0104c62:	e8 64 f9 ff ff       	call   c01045cb <get_pte>
c0104c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c6e:	75 24                	jne    c0104c94 <check_pgdir+0x4c6>
c0104c70:	c7 44 24 0c 2c 6d 10 	movl   $0xc0106d2c,0xc(%esp)
c0104c77:	c0 
c0104c78:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104c7f:	c0 
c0104c80:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104c87:	00 
c0104c88:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104c8f:	e8 56 c0 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0104c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c97:	8b 00                	mov    (%eax),%eax
c0104c99:	89 04 24             	mov    %eax,(%esp)
c0104c9c:	e8 3c f0 ff ff       	call   c0103cdd <pte2page>
c0104ca1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ca4:	74 24                	je     c0104cca <check_pgdir+0x4fc>
c0104ca6:	c7 44 24 0c a1 6c 10 	movl   $0xc0106ca1,0xc(%esp)
c0104cad:	c0 
c0104cae:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104cb5:	c0 
c0104cb6:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104cbd:	00 
c0104cbe:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104cc5:	e8 20 c0 ff ff       	call   c0100cea <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ccd:	8b 00                	mov    (%eax),%eax
c0104ccf:	83 e0 04             	and    $0x4,%eax
c0104cd2:	85 c0                	test   %eax,%eax
c0104cd4:	74 24                	je     c0104cfa <check_pgdir+0x52c>
c0104cd6:	c7 44 24 0c f0 6d 10 	movl   $0xc0106df0,0xc(%esp)
c0104cdd:	c0 
c0104cde:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104ce5:	c0 
c0104ce6:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104ced:	00 
c0104cee:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104cf5:	e8 f0 bf ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, 0x0);
c0104cfa:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104cff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d06:	00 
c0104d07:	89 04 24             	mov    %eax,(%esp)
c0104d0a:	e8 3d f9 ff ff       	call   c010464c <page_remove>
    assert(page_ref(p1) == 1);
c0104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d12:	89 04 24             	mov    %eax,(%esp)
c0104d15:	e8 1d f0 ff ff       	call   c0103d37 <page_ref>
c0104d1a:	83 f8 01             	cmp    $0x1,%eax
c0104d1d:	74 24                	je     c0104d43 <check_pgdir+0x575>
c0104d1f:	c7 44 24 0c b7 6c 10 	movl   $0xc0106cb7,0xc(%esp)
c0104d26:	c0 
c0104d27:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0104d36:	00 
c0104d37:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104d3e:	e8 a7 bf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d46:	89 04 24             	mov    %eax,(%esp)
c0104d49:	e8 e9 ef ff ff       	call   c0103d37 <page_ref>
c0104d4e:	85 c0                	test   %eax,%eax
c0104d50:	74 24                	je     c0104d76 <check_pgdir+0x5a8>
c0104d52:	c7 44 24 0c de 6d 10 	movl   $0xc0106dde,0xc(%esp)
c0104d59:	c0 
c0104d5a:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104d61:	c0 
c0104d62:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104d69:	00 
c0104d6a:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104d71:	e8 74 bf ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d76:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d7b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d82:	00 
c0104d83:	89 04 24             	mov    %eax,(%esp)
c0104d86:	e8 c1 f8 ff ff       	call   c010464c <page_remove>
    assert(page_ref(p1) == 0);
c0104d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d8e:	89 04 24             	mov    %eax,(%esp)
c0104d91:	e8 a1 ef ff ff       	call   c0103d37 <page_ref>
c0104d96:	85 c0                	test   %eax,%eax
c0104d98:	74 24                	je     c0104dbe <check_pgdir+0x5f0>
c0104d9a:	c7 44 24 0c 05 6e 10 	movl   $0xc0106e05,0xc(%esp)
c0104da1:	c0 
c0104da2:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104da9:	c0 
c0104daa:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104db1:	00 
c0104db2:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104db9:	e8 2c bf ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0104dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc1:	89 04 24             	mov    %eax,(%esp)
c0104dc4:	e8 6e ef ff ff       	call   c0103d37 <page_ref>
c0104dc9:	85 c0                	test   %eax,%eax
c0104dcb:	74 24                	je     c0104df1 <check_pgdir+0x623>
c0104dcd:	c7 44 24 0c de 6d 10 	movl   $0xc0106dde,0xc(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104de4:	00 
c0104de5:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104dec:	e8 f9 be ff ff       	call   c0100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104df1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104df6:	8b 00                	mov    (%eax),%eax
c0104df8:	89 04 24             	mov    %eax,(%esp)
c0104dfb:	e8 1d ef ff ff       	call   c0103d1d <pde2page>
c0104e00:	89 04 24             	mov    %eax,(%esp)
c0104e03:	e8 2f ef ff ff       	call   c0103d37 <page_ref>
c0104e08:	83 f8 01             	cmp    $0x1,%eax
c0104e0b:	74 24                	je     c0104e31 <check_pgdir+0x663>
c0104e0d:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104e14:	c0 
c0104e15:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104e1c:	c0 
c0104e1d:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104e24:	00 
c0104e25:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104e2c:	e8 b9 be ff ff       	call   c0100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e31:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e36:	8b 00                	mov    (%eax),%eax
c0104e38:	89 04 24             	mov    %eax,(%esp)
c0104e3b:	e8 dd ee ff ff       	call   c0103d1d <pde2page>
c0104e40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e47:	00 
c0104e48:	89 04 24             	mov    %eax,(%esp)
c0104e4b:	e8 23 f1 ff ff       	call   c0103f73 <free_pages>
    boot_pgdir[0] = 0;
c0104e50:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e5b:	c7 04 24 3f 6e 10 c0 	movl   $0xc0106e3f,(%esp)
c0104e62:	e8 fe b4 ff ff       	call   c0100365 <cprintf>
}
c0104e67:	90                   	nop
c0104e68:	89 ec                	mov    %ebp,%esp
c0104e6a:	5d                   	pop    %ebp
c0104e6b:	c3                   	ret    

c0104e6c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e6c:	55                   	push   %ebp
c0104e6d:	89 e5                	mov    %esp,%ebp
c0104e6f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e79:	e9 ca 00 00 00       	jmp    c0104f48 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e87:	c1 e8 0c             	shr    $0xc,%eax
c0104e8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e8d:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104e92:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104e95:	72 23                	jb     c0104eba <check_boot_pgdir+0x4e>
c0104e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e9e:	c7 44 24 08 84 6a 10 	movl   $0xc0106a84,0x8(%esp)
c0104ea5:	c0 
c0104ea6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104ead:	00 
c0104eae:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104eb5:	e8 30 be ff ff       	call   c0100cea <__panic>
c0104eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ebd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ec2:	89 c2                	mov    %eax,%edx
c0104ec4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ec9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ed0:	00 
c0104ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ed5:	89 04 24             	mov    %eax,(%esp)
c0104ed8:	e8 ee f6 ff ff       	call   c01045cb <get_pte>
c0104edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ee0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104ee4:	75 24                	jne    c0104f0a <check_boot_pgdir+0x9e>
c0104ee6:	c7 44 24 0c 5c 6e 10 	movl   $0xc0106e5c,0xc(%esp)
c0104eed:	c0 
c0104eee:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104ef5:	c0 
c0104ef6:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104efd:	00 
c0104efe:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104f05:	e8 e0 bd ff ff       	call   c0100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f0d:	8b 00                	mov    (%eax),%eax
c0104f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f14:	89 c2                	mov    %eax,%edx
c0104f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f19:	39 c2                	cmp    %eax,%edx
c0104f1b:	74 24                	je     c0104f41 <check_boot_pgdir+0xd5>
c0104f1d:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104f24:	c0 
c0104f25:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104f2c:	c0 
c0104f2d:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104f34:	00 
c0104f35:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104f3c:	e8 a9 bd ff ff       	call   c0100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104f41:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f4b:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104f50:	39 c2                	cmp    %eax,%edx
c0104f52:	0f 82 26 ff ff ff    	jb     c0104e7e <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f58:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f5d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f62:	8b 00                	mov    (%eax),%eax
c0104f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f69:	89 c2                	mov    %eax,%edx
c0104f6b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f73:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104f7a:	77 23                	ja     c0104f9f <check_boot_pgdir+0x133>
c0104f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f83:	c7 44 24 08 28 6b 10 	movl   $0xc0106b28,0x8(%esp)
c0104f8a:	c0 
c0104f8b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104f92:	00 
c0104f93:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104f9a:	e8 4b bd ff ff       	call   c0100cea <__panic>
c0104f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fa2:	05 00 00 00 40       	add    $0x40000000,%eax
c0104fa7:	39 d0                	cmp    %edx,%eax
c0104fa9:	74 24                	je     c0104fcf <check_boot_pgdir+0x163>
c0104fab:	c7 44 24 0c b0 6e 10 	movl   $0xc0106eb0,0xc(%esp)
c0104fb2:	c0 
c0104fb3:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104fba:	c0 
c0104fbb:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104fc2:	00 
c0104fc3:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104fca:	e8 1b bd ff ff       	call   c0100cea <__panic>

    assert(boot_pgdir[0] == 0);
c0104fcf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104fd4:	8b 00                	mov    (%eax),%eax
c0104fd6:	85 c0                	test   %eax,%eax
c0104fd8:	74 24                	je     c0104ffe <check_boot_pgdir+0x192>
c0104fda:	c7 44 24 0c e4 6e 10 	movl   $0xc0106ee4,0xc(%esp)
c0104fe1:	c0 
c0104fe2:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0104fe9:	c0 
c0104fea:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104ff1:	00 
c0104ff2:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0104ff9:	e8 ec bc ff ff       	call   c0100cea <__panic>

    struct Page *p;
    p = alloc_page();
c0104ffe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105005:	e8 2f ef ff ff       	call   c0103f39 <alloc_pages>
c010500a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010500d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105012:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105019:	00 
c010501a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105021:	00 
c0105022:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105025:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105029:	89 04 24             	mov    %eax,(%esp)
c010502c:	e8 62 f6 ff ff       	call   c0104693 <page_insert>
c0105031:	85 c0                	test   %eax,%eax
c0105033:	74 24                	je     c0105059 <check_boot_pgdir+0x1ed>
c0105035:	c7 44 24 0c f8 6e 10 	movl   $0xc0106ef8,0xc(%esp)
c010503c:	c0 
c010503d:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0105044:	c0 
c0105045:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c010504c:	00 
c010504d:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0105054:	e8 91 bc ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 1);
c0105059:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010505c:	89 04 24             	mov    %eax,(%esp)
c010505f:	e8 d3 ec ff ff       	call   c0103d37 <page_ref>
c0105064:	83 f8 01             	cmp    $0x1,%eax
c0105067:	74 24                	je     c010508d <check_boot_pgdir+0x221>
c0105069:	c7 44 24 0c 26 6f 10 	movl   $0xc0106f26,0xc(%esp)
c0105070:	c0 
c0105071:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0105078:	c0 
c0105079:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105080:	00 
c0105081:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0105088:	e8 5d bc ff ff       	call   c0100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010508d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105092:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105099:	00 
c010509a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050a1:	00 
c01050a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050a9:	89 04 24             	mov    %eax,(%esp)
c01050ac:	e8 e2 f5 ff ff       	call   c0104693 <page_insert>
c01050b1:	85 c0                	test   %eax,%eax
c01050b3:	74 24                	je     c01050d9 <check_boot_pgdir+0x26d>
c01050b5:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c01050bc:	c0 
c01050bd:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c01050c4:	c0 
c01050c5:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c01050cc:	00 
c01050cd:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01050d4:	e8 11 bc ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 2);
c01050d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050dc:	89 04 24             	mov    %eax,(%esp)
c01050df:	e8 53 ec ff ff       	call   c0103d37 <page_ref>
c01050e4:	83 f8 02             	cmp    $0x2,%eax
c01050e7:	74 24                	je     c010510d <check_boot_pgdir+0x2a1>
c01050e9:	c7 44 24 0c 6f 6f 10 	movl   $0xc0106f6f,0xc(%esp)
c01050f0:	c0 
c01050f1:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c01050f8:	c0 
c01050f9:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0105100:	00 
c0105101:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c0105108:	e8 dd bb ff ff       	call   c0100cea <__panic>

    const char *str = "ucore: Hello world!!";
c010510d:	c7 45 e8 80 6f 10 c0 	movl   $0xc0106f80,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105114:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105117:	89 44 24 04          	mov    %eax,0x4(%esp)
c010511b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105122:	e8 fc 09 00 00       	call   c0105b23 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105127:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010512e:	00 
c010512f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105136:	e8 60 0a 00 00       	call   c0105b9b <strcmp>
c010513b:	85 c0                	test   %eax,%eax
c010513d:	74 24                	je     c0105163 <check_boot_pgdir+0x2f7>
c010513f:	c7 44 24 0c 98 6f 10 	movl   $0xc0106f98,0xc(%esp)
c0105146:	c0 
c0105147:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c010514e:	c0 
c010514f:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105156:	00 
c0105157:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c010515e:	e8 87 bb ff ff       	call   c0100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105163:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105166:	89 04 24             	mov    %eax,(%esp)
c0105169:	e8 19 eb ff ff       	call   c0103c87 <page2kva>
c010516e:	05 00 01 00 00       	add    $0x100,%eax
c0105173:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105176:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010517d:	e8 47 09 00 00       	call   c0105ac9 <strlen>
c0105182:	85 c0                	test   %eax,%eax
c0105184:	74 24                	je     c01051aa <check_boot_pgdir+0x33e>
c0105186:	c7 44 24 0c d0 6f 10 	movl   $0xc0106fd0,0xc(%esp)
c010518d:	c0 
c010518e:	c7 44 24 08 71 6b 10 	movl   $0xc0106b71,0x8(%esp)
c0105195:	c0 
c0105196:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c010519d:	00 
c010519e:	c7 04 24 4c 6b 10 c0 	movl   $0xc0106b4c,(%esp)
c01051a5:	e8 40 bb ff ff       	call   c0100cea <__panic>

    free_page(p);
c01051aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051b1:	00 
c01051b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051b5:	89 04 24             	mov    %eax,(%esp)
c01051b8:	e8 b6 ed ff ff       	call   c0103f73 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01051bd:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051c2:	8b 00                	mov    (%eax),%eax
c01051c4:	89 04 24             	mov    %eax,(%esp)
c01051c7:	e8 51 eb ff ff       	call   c0103d1d <pde2page>
c01051cc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051d3:	00 
c01051d4:	89 04 24             	mov    %eax,(%esp)
c01051d7:	e8 97 ed ff ff       	call   c0103f73 <free_pages>
    boot_pgdir[0] = 0;
c01051dc:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051e7:	c7 04 24 f4 6f 10 c0 	movl   $0xc0106ff4,(%esp)
c01051ee:	e8 72 b1 ff ff       	call   c0100365 <cprintf>
}
c01051f3:	90                   	nop
c01051f4:	89 ec                	mov    %ebp,%esp
c01051f6:	5d                   	pop    %ebp
c01051f7:	c3                   	ret    

c01051f8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051f8:	55                   	push   %ebp
c01051f9:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fe:	83 e0 04             	and    $0x4,%eax
c0105201:	85 c0                	test   %eax,%eax
c0105203:	74 04                	je     c0105209 <perm2str+0x11>
c0105205:	b0 75                	mov    $0x75,%al
c0105207:	eb 02                	jmp    c010520b <perm2str+0x13>
c0105209:	b0 2d                	mov    $0x2d,%al
c010520b:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0105210:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105217:	8b 45 08             	mov    0x8(%ebp),%eax
c010521a:	83 e0 02             	and    $0x2,%eax
c010521d:	85 c0                	test   %eax,%eax
c010521f:	74 04                	je     c0105225 <perm2str+0x2d>
c0105221:	b0 77                	mov    $0x77,%al
c0105223:	eb 02                	jmp    c0105227 <perm2str+0x2f>
c0105225:	b0 2d                	mov    $0x2d,%al
c0105227:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c010522c:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c0105233:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c0105238:	5d                   	pop    %ebp
c0105239:	c3                   	ret    

c010523a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010523a:	55                   	push   %ebp
c010523b:	89 e5                	mov    %esp,%ebp
c010523d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105240:	8b 45 10             	mov    0x10(%ebp),%eax
c0105243:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105246:	72 0d                	jb     c0105255 <get_pgtable_items+0x1b>
        return 0;
c0105248:	b8 00 00 00 00       	mov    $0x0,%eax
c010524d:	e9 98 00 00 00       	jmp    c01052ea <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105252:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0105255:	8b 45 10             	mov    0x10(%ebp),%eax
c0105258:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525b:	73 18                	jae    c0105275 <get_pgtable_items+0x3b>
c010525d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105260:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105267:	8b 45 14             	mov    0x14(%ebp),%eax
c010526a:	01 d0                	add    %edx,%eax
c010526c:	8b 00                	mov    (%eax),%eax
c010526e:	83 e0 01             	and    $0x1,%eax
c0105271:	85 c0                	test   %eax,%eax
c0105273:	74 dd                	je     c0105252 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0105275:	8b 45 10             	mov    0x10(%ebp),%eax
c0105278:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010527b:	73 68                	jae    c01052e5 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c010527d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105281:	74 08                	je     c010528b <get_pgtable_items+0x51>
            *left_store = start;
c0105283:	8b 45 18             	mov    0x18(%ebp),%eax
c0105286:	8b 55 10             	mov    0x10(%ebp),%edx
c0105289:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010528b:	8b 45 10             	mov    0x10(%ebp),%eax
c010528e:	8d 50 01             	lea    0x1(%eax),%edx
c0105291:	89 55 10             	mov    %edx,0x10(%ebp)
c0105294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010529b:	8b 45 14             	mov    0x14(%ebp),%eax
c010529e:	01 d0                	add    %edx,%eax
c01052a0:	8b 00                	mov    (%eax),%eax
c01052a2:	83 e0 07             	and    $0x7,%eax
c01052a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052a8:	eb 03                	jmp    c01052ad <get_pgtable_items+0x73>
            start ++;
c01052aa:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052b3:	73 1d                	jae    c01052d2 <get_pgtable_items+0x98>
c01052b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052bf:	8b 45 14             	mov    0x14(%ebp),%eax
c01052c2:	01 d0                	add    %edx,%eax
c01052c4:	8b 00                	mov    (%eax),%eax
c01052c6:	83 e0 07             	and    $0x7,%eax
c01052c9:	89 c2                	mov    %eax,%edx
c01052cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052ce:	39 c2                	cmp    %eax,%edx
c01052d0:	74 d8                	je     c01052aa <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01052d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052d6:	74 08                	je     c01052e0 <get_pgtable_items+0xa6>
            *right_store = start;
c01052d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052db:	8b 55 10             	mov    0x10(%ebp),%edx
c01052de:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052e3:	eb 05                	jmp    c01052ea <get_pgtable_items+0xb0>
    }
    return 0;
c01052e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052ea:	89 ec                	mov    %ebp,%esp
c01052ec:	5d                   	pop    %ebp
c01052ed:	c3                   	ret    

c01052ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052ee:	55                   	push   %ebp
c01052ef:	89 e5                	mov    %esp,%ebp
c01052f1:	57                   	push   %edi
c01052f2:	56                   	push   %esi
c01052f3:	53                   	push   %ebx
c01052f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052f7:	c7 04 24 14 70 10 c0 	movl   $0xc0107014,(%esp)
c01052fe:	e8 62 b0 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c0105303:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010530a:	e9 f2 00 00 00       	jmp    c0105401 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010530f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105312:	89 04 24             	mov    %eax,(%esp)
c0105315:	e8 de fe ff ff       	call   c01051f8 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010531a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010531d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105320:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105322:	89 d6                	mov    %edx,%esi
c0105324:	c1 e6 16             	shl    $0x16,%esi
c0105327:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010532a:	89 d3                	mov    %edx,%ebx
c010532c:	c1 e3 16             	shl    $0x16,%ebx
c010532f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105332:	89 d1                	mov    %edx,%ecx
c0105334:	c1 e1 16             	shl    $0x16,%ecx
c0105337:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010533a:	8b 7d e0             	mov    -0x20(%ebp),%edi
c010533d:	29 fa                	sub    %edi,%edx
c010533f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105343:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105347:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010534b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010534f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105353:	c7 04 24 45 70 10 c0 	movl   $0xc0107045,(%esp)
c010535a:	e8 06 b0 ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010535f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105362:	c1 e0 0a             	shl    $0xa,%eax
c0105365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105368:	eb 50                	jmp    c01053ba <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010536a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010536d:	89 04 24             	mov    %eax,(%esp)
c0105370:	e8 83 fe ff ff       	call   c01051f8 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105375:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105378:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010537b:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010537d:	89 d6                	mov    %edx,%esi
c010537f:	c1 e6 0c             	shl    $0xc,%esi
c0105382:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105385:	89 d3                	mov    %edx,%ebx
c0105387:	c1 e3 0c             	shl    $0xc,%ebx
c010538a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010538d:	89 d1                	mov    %edx,%ecx
c010538f:	c1 e1 0c             	shl    $0xc,%ecx
c0105392:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105395:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105398:	29 fa                	sub    %edi,%edx
c010539a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010539e:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053ae:	c7 04 24 64 70 10 c0 	movl   $0xc0107064,(%esp)
c01053b5:	e8 ab af ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053ba:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01053bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053c5:	89 d3                	mov    %edx,%ebx
c01053c7:	c1 e3 0a             	shl    $0xa,%ebx
c01053ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053cd:	89 d1                	mov    %edx,%ecx
c01053cf:	c1 e1 0a             	shl    $0xa,%ecx
c01053d2:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01053d5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01053d9:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01053dc:	89 54 24 10          	mov    %edx,0x10(%esp)
c01053e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01053e4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01053ec:	89 0c 24             	mov    %ecx,(%esp)
c01053ef:	e8 46 fe ff ff       	call   c010523a <get_pgtable_items>
c01053f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053fb:	0f 85 69 ff ff ff    	jne    c010536a <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105401:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0105406:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105409:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010540c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105410:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0105413:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105417:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010541b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010541f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105426:	00 
c0105427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010542e:	e8 07 fe ff ff       	call   c010523a <get_pgtable_items>
c0105433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105436:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010543a:	0f 85 cf fe ff ff    	jne    c010530f <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105440:	c7 04 24 88 70 10 c0 	movl   $0xc0107088,(%esp)
c0105447:	e8 19 af ff ff       	call   c0100365 <cprintf>
}
c010544c:	90                   	nop
c010544d:	83 c4 4c             	add    $0x4c,%esp
c0105450:	5b                   	pop    %ebx
c0105451:	5e                   	pop    %esi
c0105452:	5f                   	pop    %edi
c0105453:	5d                   	pop    %ebp
c0105454:	c3                   	ret    

c0105455 <printnum>:
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
c0105455:	55                   	push   %ebp
c0105456:	89 e5                	mov    %esp,%ebp
c0105458:	83 ec 58             	sub    $0x58,%esp
c010545b:	8b 45 10             	mov    0x10(%ebp),%eax
c010545e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105461:	8b 45 14             	mov    0x14(%ebp),%eax
c0105464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105467:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010546a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010546d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105470:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105473:	8b 45 18             	mov    0x18(%ebp),%eax
c0105476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105479:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010547c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010547f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105482:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105485:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105488:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010548b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010548f:	74 1c                	je     c01054ad <printnum+0x58>
c0105491:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105494:	ba 00 00 00 00       	mov    $0x0,%edx
c0105499:	f7 75 e4             	divl   -0x1c(%ebp)
c010549c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010549f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a2:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a7:	f7 75 e4             	divl   -0x1c(%ebp)
c01054aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054b3:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054cb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base)
c01054ce:	8b 45 18             	mov    0x18(%ebp),%eax
c01054d1:	ba 00 00 00 00       	mov    $0x0,%edx
c01054d6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01054d9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01054dc:	19 d1                	sbb    %edx,%ecx
c01054de:	72 4c                	jb     c010552c <printnum+0xd7>
    {
        printnum(putch, putdat, result, base, width - 1, padc);
c01054e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054e3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054e6:	8b 45 20             	mov    0x20(%ebp),%eax
c01054e9:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054ed:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054f1:	8b 45 18             	mov    0x18(%ebp),%eax
c01054f4:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054fe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105502:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105506:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105509:	89 44 24 04          	mov    %eax,0x4(%esp)
c010550d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105510:	89 04 24             	mov    %eax,(%esp)
c0105513:	e8 3d ff ff ff       	call   c0105455 <printnum>
c0105518:	eb 1b                	jmp    c0105535 <printnum+0xe0>
    }
    else
    {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
c010551a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010551d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105521:	8b 45 20             	mov    0x20(%ebp),%eax
c0105524:	89 04 24             	mov    %eax,(%esp)
c0105527:	8b 45 08             	mov    0x8(%ebp),%eax
c010552a:	ff d0                	call   *%eax
        while (--width > 0)
c010552c:	ff 4d 1c             	decl   0x1c(%ebp)
c010552f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105533:	7f e5                	jg     c010551a <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105535:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105538:	05 3c 71 10 c0       	add    $0xc010713c,%eax
c010553d:	0f b6 00             	movzbl (%eax),%eax
c0105540:	0f be c0             	movsbl %al,%eax
c0105543:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105546:	89 54 24 04          	mov    %edx,0x4(%esp)
c010554a:	89 04 24             	mov    %eax,(%esp)
c010554d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105550:	ff d0                	call   *%eax
}
c0105552:	90                   	nop
c0105553:	89 ec                	mov    %ebp,%esp
c0105555:	5d                   	pop    %ebp
c0105556:	c3                   	ret    

c0105557 <getuint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag)
{
c0105557:	55                   	push   %ebp
c0105558:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c010555a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010555e:	7e 14                	jle    c0105574 <getuint+0x1d>
    {
        return va_arg(*ap, unsigned long long);
c0105560:	8b 45 08             	mov    0x8(%ebp),%eax
c0105563:	8b 00                	mov    (%eax),%eax
c0105565:	8d 48 08             	lea    0x8(%eax),%ecx
c0105568:	8b 55 08             	mov    0x8(%ebp),%edx
c010556b:	89 0a                	mov    %ecx,(%edx)
c010556d:	8b 50 04             	mov    0x4(%eax),%edx
c0105570:	8b 00                	mov    (%eax),%eax
c0105572:	eb 30                	jmp    c01055a4 <getuint+0x4d>
    }
    else if (lflag)
c0105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105578:	74 16                	je     c0105590 <getuint+0x39>
    {
        return va_arg(*ap, unsigned long);
c010557a:	8b 45 08             	mov    0x8(%ebp),%eax
c010557d:	8b 00                	mov    (%eax),%eax
c010557f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105582:	8b 55 08             	mov    0x8(%ebp),%edx
c0105585:	89 0a                	mov    %ecx,(%edx)
c0105587:	8b 00                	mov    (%eax),%eax
c0105589:	ba 00 00 00 00       	mov    $0x0,%edx
c010558e:	eb 14                	jmp    c01055a4 <getuint+0x4d>
    }
    else
    {
        return va_arg(*ap, unsigned int);
c0105590:	8b 45 08             	mov    0x8(%ebp),%eax
c0105593:	8b 00                	mov    (%eax),%eax
c0105595:	8d 48 04             	lea    0x4(%eax),%ecx
c0105598:	8b 55 08             	mov    0x8(%ebp),%edx
c010559b:	89 0a                	mov    %ecx,(%edx)
c010559d:	8b 00                	mov    (%eax),%eax
c010559f:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055a4:	5d                   	pop    %ebp
c01055a5:	c3                   	ret    

c01055a6 <getint>:
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag)
{
c01055a6:	55                   	push   %ebp
c01055a7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2)
c01055a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055ad:	7e 14                	jle    c01055c3 <getint+0x1d>
    {
        return va_arg(*ap, long long);
c01055af:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b2:	8b 00                	mov    (%eax),%eax
c01055b4:	8d 48 08             	lea    0x8(%eax),%ecx
c01055b7:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ba:	89 0a                	mov    %ecx,(%edx)
c01055bc:	8b 50 04             	mov    0x4(%eax),%edx
c01055bf:	8b 00                	mov    (%eax),%eax
c01055c1:	eb 28                	jmp    c01055eb <getint+0x45>
    }
    else if (lflag)
c01055c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055c7:	74 12                	je     c01055db <getint+0x35>
    {
        return va_arg(*ap, long);
c01055c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055cc:	8b 00                	mov    (%eax),%eax
c01055ce:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d4:	89 0a                	mov    %ecx,(%edx)
c01055d6:	8b 00                	mov    (%eax),%eax
c01055d8:	99                   	cltd   
c01055d9:	eb 10                	jmp    c01055eb <getint+0x45>
    }
    else
    {
        return va_arg(*ap, int);
c01055db:	8b 45 08             	mov    0x8(%ebp),%eax
c01055de:	8b 00                	mov    (%eax),%eax
c01055e0:	8d 48 04             	lea    0x4(%eax),%ecx
c01055e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01055e6:	89 0a                	mov    %ecx,(%edx)
c01055e8:	8b 00                	mov    (%eax),%eax
c01055ea:	99                   	cltd   
    }
}
c01055eb:	5d                   	pop    %ebp
c01055ec:	c3                   	ret    

c01055ed <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...)
{
c01055ed:	55                   	push   %ebp
c01055ee:	89 e5                	mov    %esp,%ebp
c01055f0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055f3:	8d 45 14             	lea    0x14(%ebp),%eax
c01055f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105600:	8b 45 10             	mov    0x10(%ebp),%eax
c0105603:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105607:	8b 45 0c             	mov    0xc(%ebp),%eax
c010560a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010560e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105611:	89 04 24             	mov    %eax,(%esp)
c0105614:	e8 05 00 00 00       	call   c010561e <vprintfmt>
    va_end(ap);
}
c0105619:	90                   	nop
c010561a:	89 ec                	mov    %ebp,%esp
c010561c:	5d                   	pop    %ebp
c010561d:	c3                   	ret    

c010561e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void vprintfmt(void (*putch)(int, void *), void *putdat, const char *fmt, va_list ap)
{
c010561e:	55                   	push   %ebp
c010561f:	89 e5                	mov    %esp,%ebp
c0105621:	56                   	push   %esi
c0105622:	53                   	push   %ebx
c0105623:	83 ec 40             	sub    $0x40,%esp
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1)
    {
        while ((ch = *(unsigned char *)fmt++) != '%')
c0105626:	eb 17                	jmp    c010563f <vprintfmt+0x21>
        {
            if (ch == '\0')
c0105628:	85 db                	test   %ebx,%ebx
c010562a:	0f 84 bf 03 00 00    	je     c01059ef <vprintfmt+0x3d1>
            {
                return;
            }
            putch(ch, putdat);
c0105630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105633:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105637:	89 1c 24             	mov    %ebx,(%esp)
c010563a:	8b 45 08             	mov    0x8(%ebp),%eax
c010563d:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt++) != '%')
c010563f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105642:	8d 50 01             	lea    0x1(%eax),%edx
c0105645:	89 55 10             	mov    %edx,0x10(%ebp)
c0105648:	0f b6 00             	movzbl (%eax),%eax
c010564b:	0f b6 d8             	movzbl %al,%ebx
c010564e:	83 fb 25             	cmp    $0x25,%ebx
c0105651:	75 d5                	jne    c0105628 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105653:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105657:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010565e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105661:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105664:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010566b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010566e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt++)
c0105671:	8b 45 10             	mov    0x10(%ebp),%eax
c0105674:	8d 50 01             	lea    0x1(%eax),%edx
c0105677:	89 55 10             	mov    %edx,0x10(%ebp)
c010567a:	0f b6 00             	movzbl (%eax),%eax
c010567d:	0f b6 d8             	movzbl %al,%ebx
c0105680:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105683:	83 f8 55             	cmp    $0x55,%eax
c0105686:	0f 87 37 03 00 00    	ja     c01059c3 <vprintfmt+0x3a5>
c010568c:	8b 04 85 60 71 10 c0 	mov    -0x3fef8ea0(,%eax,4),%eax
c0105693:	ff e0                	jmp    *%eax
        {

        // flag to pad on the right
        case '-':
            padc = '-';
c0105695:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105699:	eb d6                	jmp    c0105671 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010569b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010569f:	eb d0                	jmp    c0105671 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0;; ++fmt)
c01056a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            {
                precision = precision * 10 + ch - '0';
c01056a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056ab:	89 d0                	mov    %edx,%eax
c01056ad:	c1 e0 02             	shl    $0x2,%eax
c01056b0:	01 d0                	add    %edx,%eax
c01056b2:	01 c0                	add    %eax,%eax
c01056b4:	01 d8                	add    %ebx,%eax
c01056b6:	83 e8 30             	sub    $0x30,%eax
c01056b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01056bf:	0f b6 00             	movzbl (%eax),%eax
c01056c2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9')
c01056c5:	83 fb 2f             	cmp    $0x2f,%ebx
c01056c8:	7e 38                	jle    c0105702 <vprintfmt+0xe4>
c01056ca:	83 fb 39             	cmp    $0x39,%ebx
c01056cd:	7f 33                	jg     c0105702 <vprintfmt+0xe4>
            for (precision = 0;; ++fmt)
c01056cf:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01056d2:	eb d4                	jmp    c01056a8 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056d4:	8b 45 14             	mov    0x14(%ebp),%eax
c01056d7:	8d 50 04             	lea    0x4(%eax),%edx
c01056da:	89 55 14             	mov    %edx,0x14(%ebp)
c01056dd:	8b 00                	mov    (%eax),%eax
c01056df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056e2:	eb 1f                	jmp    c0105703 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01056e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056e8:	79 87                	jns    c0105671 <vprintfmt+0x53>
                width = 0;
c01056ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056f1:	e9 7b ff ff ff       	jmp    c0105671 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01056f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056fd:	e9 6f ff ff ff       	jmp    c0105671 <vprintfmt+0x53>
            goto process_precision;
c0105702:	90                   	nop

        process_precision:
            if (width < 0)
c0105703:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105707:	0f 89 64 ff ff ff    	jns    c0105671 <vprintfmt+0x53>
                width = precision, precision = -1;
c010570d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105710:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105713:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010571a:	e9 52 ff ff ff       	jmp    c0105671 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag++;
c010571f:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105722:	e9 4a ff ff ff       	jmp    c0105671 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105727:	8b 45 14             	mov    0x14(%ebp),%eax
c010572a:	8d 50 04             	lea    0x4(%eax),%edx
c010572d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105730:	8b 00                	mov    (%eax),%eax
c0105732:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105735:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105739:	89 04 24             	mov    %eax,(%esp)
c010573c:	8b 45 08             	mov    0x8(%ebp),%eax
c010573f:	ff d0                	call   *%eax
            break;
c0105741:	e9 a4 02 00 00       	jmp    c01059ea <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105746:	8b 45 14             	mov    0x14(%ebp),%eax
c0105749:	8d 50 04             	lea    0x4(%eax),%edx
c010574c:	89 55 14             	mov    %edx,0x14(%ebp)
c010574f:	8b 18                	mov    (%eax),%ebx
            if (err < 0)
c0105751:	85 db                	test   %ebx,%ebx
c0105753:	79 02                	jns    c0105757 <vprintfmt+0x139>
            {
                err = -err;
c0105755:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL)
c0105757:	83 fb 06             	cmp    $0x6,%ebx
c010575a:	7f 0b                	jg     c0105767 <vprintfmt+0x149>
c010575c:	8b 34 9d 20 71 10 c0 	mov    -0x3fef8ee0(,%ebx,4),%esi
c0105763:	85 f6                	test   %esi,%esi
c0105765:	75 23                	jne    c010578a <vprintfmt+0x16c>
            {
                printfmt(putch, putdat, "error %d", err);
c0105767:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010576b:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0105772:	c0 
c0105773:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105776:	89 44 24 04          	mov    %eax,0x4(%esp)
c010577a:	8b 45 08             	mov    0x8(%ebp),%eax
c010577d:	89 04 24             	mov    %eax,(%esp)
c0105780:	e8 68 fe ff ff       	call   c01055ed <printfmt>
            }
            else
            {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105785:	e9 60 02 00 00       	jmp    c01059ea <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c010578a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010578e:	c7 44 24 08 56 71 10 	movl   $0xc0107156,0x8(%esp)
c0105795:	c0 
c0105796:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105799:	89 44 24 04          	mov    %eax,0x4(%esp)
c010579d:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a0:	89 04 24             	mov    %eax,(%esp)
c01057a3:	e8 45 fe ff ff       	call   c01055ed <printfmt>
            break;
c01057a8:	e9 3d 02 00 00       	jmp    c01059ea <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
c01057ad:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b0:	8d 50 04             	lea    0x4(%eax),%edx
c01057b3:	89 55 14             	mov    %edx,0x14(%ebp)
c01057b6:	8b 30                	mov    (%eax),%esi
c01057b8:	85 f6                	test   %esi,%esi
c01057ba:	75 05                	jne    c01057c1 <vprintfmt+0x1a3>
            {
                p = "(null)";
c01057bc:	be 59 71 10 c0       	mov    $0xc0107159,%esi
            }
            if (width > 0 && padc != '-')
c01057c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057c5:	7e 76                	jle    c010583d <vprintfmt+0x21f>
c01057c7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057cb:	74 70                	je     c010583d <vprintfmt+0x21f>
            {
                for (width -= strnlen(p, precision); width > 0; width--)
c01057cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d4:	89 34 24             	mov    %esi,(%esp)
c01057d7:	e8 16 03 00 00       	call   c0105af2 <strnlen>
c01057dc:	89 c2                	mov    %eax,%edx
c01057de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e1:	29 d0                	sub    %edx,%eax
c01057e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057e6:	eb 16                	jmp    c01057fe <vprintfmt+0x1e0>
                {
                    putch(padc, putdat);
c01057e8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057f3:	89 04 24             	mov    %eax,(%esp)
c01057f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f9:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width--)
c01057fb:	ff 4d e8             	decl   -0x18(%ebp)
c01057fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105802:	7f e4                	jg     c01057e8 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c0105804:	eb 37                	jmp    c010583d <vprintfmt+0x21f>
            {
                if (altflag && (ch < ' ' || ch > '~'))
c0105806:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010580a:	74 1f                	je     c010582b <vprintfmt+0x20d>
c010580c:	83 fb 1f             	cmp    $0x1f,%ebx
c010580f:	7e 05                	jle    c0105816 <vprintfmt+0x1f8>
c0105811:	83 fb 7e             	cmp    $0x7e,%ebx
c0105814:	7e 15                	jle    c010582b <vprintfmt+0x20d>
                {
                    putch('?', putdat);
c0105816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105824:	8b 45 08             	mov    0x8(%ebp),%eax
c0105827:	ff d0                	call   *%eax
c0105829:	eb 0f                	jmp    c010583a <vprintfmt+0x21c>
                }
                else
                {
                    putch(ch, putdat);
c010582b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105832:	89 1c 24             	mov    %ebx,(%esp)
c0105835:	8b 45 08             	mov    0x8(%ebp),%eax
c0105838:	ff d0                	call   *%eax
            for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
c010583a:	ff 4d e8             	decl   -0x18(%ebp)
c010583d:	89 f0                	mov    %esi,%eax
c010583f:	8d 70 01             	lea    0x1(%eax),%esi
c0105842:	0f b6 00             	movzbl (%eax),%eax
c0105845:	0f be d8             	movsbl %al,%ebx
c0105848:	85 db                	test   %ebx,%ebx
c010584a:	74 27                	je     c0105873 <vprintfmt+0x255>
c010584c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105850:	78 b4                	js     c0105806 <vprintfmt+0x1e8>
c0105852:	ff 4d e4             	decl   -0x1c(%ebp)
c0105855:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105859:	79 ab                	jns    c0105806 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width--)
c010585b:	eb 16                	jmp    c0105873 <vprintfmt+0x255>
            {
                putch(' ', putdat);
c010585d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105860:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105864:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010586b:	8b 45 08             	mov    0x8(%ebp),%eax
c010586e:	ff d0                	call   *%eax
            for (; width > 0; width--)
c0105870:	ff 4d e8             	decl   -0x18(%ebp)
c0105873:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105877:	7f e4                	jg     c010585d <vprintfmt+0x23f>
            }
            break;
c0105879:	e9 6c 01 00 00       	jmp    c01059ea <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010587e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105881:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105885:	8d 45 14             	lea    0x14(%ebp),%eax
c0105888:	89 04 24             	mov    %eax,(%esp)
c010588b:	e8 16 fd ff ff       	call   c01055a6 <getint>
c0105890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105893:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0)
c0105896:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105899:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010589c:	85 d2                	test   %edx,%edx
c010589e:	79 26                	jns    c01058c6 <vprintfmt+0x2a8>
            {
                putch('-', putdat);
c01058a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b1:	ff d0                	call   *%eax
                num = -(long long)num;
c01058b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058b9:	f7 d8                	neg    %eax
c01058bb:	83 d2 00             	adc    $0x0,%edx
c01058be:	f7 da                	neg    %edx
c01058c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058c6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058cd:	e9 a8 00 00 00       	jmp    c010597a <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01058dc:	89 04 24             	mov    %eax,(%esp)
c01058df:	e8 73 fc ff ff       	call   c0105557 <getuint>
c01058e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058f1:	e9 84 00 00 00       	jmp    c010597a <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0105900:	89 04 24             	mov    %eax,(%esp)
c0105903:	e8 4f fc ff ff       	call   c0105557 <getuint>
c0105908:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010590b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010590e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105915:	eb 63                	jmp    c010597a <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105917:	8b 45 0c             	mov    0xc(%ebp),%eax
c010591a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105925:	8b 45 08             	mov    0x8(%ebp),%eax
c0105928:	ff d0                	call   *%eax
            putch('x', putdat);
c010592a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105931:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105938:	8b 45 08             	mov    0x8(%ebp),%eax
c010593b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010593d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105940:	8d 50 04             	lea    0x4(%eax),%edx
c0105943:	89 55 14             	mov    %edx,0x14(%ebp)
c0105946:	8b 00                	mov    (%eax),%eax
c0105948:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010594b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105952:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105959:	eb 1f                	jmp    c010597a <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010595b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010595e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105962:	8d 45 14             	lea    0x14(%ebp),%eax
c0105965:	89 04 24             	mov    %eax,(%esp)
c0105968:	e8 ea fb ff ff       	call   c0105557 <getuint>
c010596d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105970:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105973:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010597a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010597e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105981:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105985:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105988:	89 54 24 14          	mov    %edx,0x14(%esp)
c010598c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105990:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105993:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105996:	89 44 24 08          	mov    %eax,0x8(%esp)
c010599a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010599e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a8:	89 04 24             	mov    %eax,(%esp)
c01059ab:	e8 a5 fa ff ff       	call   c0105455 <printnum>
            break;
c01059b0:	eb 38                	jmp    c01059ea <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b9:	89 1c 24             	mov    %ebx,(%esp)
c01059bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bf:	ff d0                	call   *%eax
            break;
c01059c1:	eb 27                	jmp    c01059ea <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ca:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d4:	ff d0                	call   *%eax
            for (fmt--; fmt[-1] != '%'; fmt--)
c01059d6:	ff 4d 10             	decl   0x10(%ebp)
c01059d9:	eb 03                	jmp    c01059de <vprintfmt+0x3c0>
c01059db:	ff 4d 10             	decl   0x10(%ebp)
c01059de:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e1:	48                   	dec    %eax
c01059e2:	0f b6 00             	movzbl (%eax),%eax
c01059e5:	3c 25                	cmp    $0x25,%al
c01059e7:	75 f2                	jne    c01059db <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c01059e9:	90                   	nop
    {
c01059ea:	e9 37 fc ff ff       	jmp    c0105626 <vprintfmt+0x8>
                return;
c01059ef:	90                   	nop
        }
    }
}
c01059f0:	83 c4 40             	add    $0x40,%esp
c01059f3:	5b                   	pop    %ebx
c01059f4:	5e                   	pop    %esi
c01059f5:	5d                   	pop    %ebp
c01059f6:	c3                   	ret    

c01059f7 <sprintputch>:
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b)
{
c01059f7:	55                   	push   %ebp
c01059f8:	89 e5                	mov    %esp,%ebp
    b->cnt++;
c01059fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fd:	8b 40 08             	mov    0x8(%eax),%eax
c0105a00:	8d 50 01             	lea    0x1(%eax),%edx
c0105a03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a06:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
c0105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0c:	8b 10                	mov    (%eax),%edx
c0105a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a11:	8b 40 04             	mov    0x4(%eax),%eax
c0105a14:	39 c2                	cmp    %eax,%edx
c0105a16:	73 12                	jae    c0105a2a <sprintputch+0x33>
    {
        *b->buf++ = ch;
c0105a18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1b:	8b 00                	mov    (%eax),%eax
c0105a1d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a20:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a23:	89 0a                	mov    %ecx,(%edx)
c0105a25:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a28:	88 10                	mov    %dl,(%eax)
    }
}
c0105a2a:	90                   	nop
c0105a2b:	5d                   	pop    %ebp
c0105a2c:	c3                   	ret    

c0105a2d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int snprintf(char *str, size_t size, const char *fmt, ...)
{
c0105a2d:	55                   	push   %ebp
c0105a2e:	89 e5                	mov    %esp,%ebp
c0105a30:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a33:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a40:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a43:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	89 04 24             	mov    %eax,(%esp)
c0105a54:	e8 0a 00 00 00       	call   c0105a63 <vsnprintf>
c0105a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a5f:	89 ec                	mov    %ebp,%esp
c0105a61:	5d                   	pop    %ebp
c0105a62:	c3                   	ret    

c0105a63 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int vsnprintf(char *str, size_t size, const char *fmt, va_list ap)
{
c0105a63:	55                   	push   %ebp
c0105a64:	89 e5                	mov    %esp,%ebp
c0105a66:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a72:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a78:	01 d0                	add    %edx,%eax
c0105a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf)
c0105a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a88:	74 0a                	je     c0105a94 <vsnprintf+0x31>
c0105a8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a90:	39 c2                	cmp    %eax,%edx
c0105a92:	76 07                	jbe    c0105a9b <vsnprintf+0x38>
    {
        return -E_INVAL;
c0105a94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a99:	eb 2a                	jmp    c0105ac5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void *)sprintputch, &b, fmt, ap);
c0105a9b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aa2:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105aa9:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105aac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab0:	c7 04 24 f7 59 10 c0 	movl   $0xc01059f7,(%esp)
c0105ab7:	e8 62 fb ff ff       	call   c010561e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105abf:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ac5:	89 ec                	mov    %ebp,%esp
c0105ac7:	5d                   	pop    %ebp
c0105ac8:	c3                   	ret    

c0105ac9 <strlen>:
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s)
{
c0105ac9:	55                   	push   %ebp
c0105aca:	89 e5                	mov    %esp,%ebp
c0105acc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105acf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s++ != '\0')
c0105ad6:	eb 03                	jmp    c0105adb <strlen+0x12>
    {
        cnt++;
c0105ad8:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s++ != '\0')
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	8d 50 01             	lea    0x1(%eax),%edx
c0105ae1:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ae4:	0f b6 00             	movzbl (%eax),%eax
c0105ae7:	84 c0                	test   %al,%al
c0105ae9:	75 ed                	jne    c0105ad8 <strlen+0xf>
    }
    return cnt;
c0105aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105aee:	89 ec                	mov    %ebp,%esp
c0105af0:	5d                   	pop    %ebp
c0105af1:	c3                   	ret    

c0105af2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len)
{
c0105af2:	55                   	push   %ebp
c0105af3:	89 e5                	mov    %esp,%ebp
c0105af5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105af8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c0105aff:	eb 03                	jmp    c0105b04 <strnlen+0x12>
    {
        cnt++;
c0105b01:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s++ != '\0')
c0105b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b07:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b0a:	73 10                	jae    c0105b1c <strnlen+0x2a>
c0105b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0f:	8d 50 01             	lea    0x1(%eax),%edx
c0105b12:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b15:	0f b6 00             	movzbl (%eax),%eax
c0105b18:	84 c0                	test   %al,%al
c0105b1a:	75 e5                	jne    c0105b01 <strnlen+0xf>
    }
    return cnt;
c0105b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b1f:	89 ec                	mov    %ebp,%esp
c0105b21:	5d                   	pop    %ebp
c0105b22:	c3                   	ret    

c0105b23 <strcpy>:
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src)
{
c0105b23:	55                   	push   %ebp
c0105b24:	89 e5                	mov    %esp,%ebp
c0105b26:	57                   	push   %edi
c0105b27:	56                   	push   %esi
c0105b28:	83 ec 20             	sub    $0x20,%esp
c0105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src)
{
    int d0, d1, d2;
    asm volatile(
c0105b37:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b3d:	89 d1                	mov    %edx,%ecx
c0105b3f:	89 c2                	mov    %eax,%edx
c0105b41:	89 ce                	mov    %ecx,%esi
c0105b43:	89 d7                	mov    %edx,%edi
c0105b45:	ac                   	lods   %ds:(%esi),%al
c0105b46:	aa                   	stos   %al,%es:(%edi)
c0105b47:	84 c0                	test   %al,%al
c0105b49:	75 fa                	jne    c0105b45 <strcpy+0x22>
c0105b4b:	89 fa                	mov    %edi,%edx
c0105b4d:	89 f1                	mov    %esi,%ecx
c0105b4f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b52:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S"(d0), "=&D"(d1), "=&a"(d2)
        : "0"(src), "1"(dst)
        : "memory");
    return dst;
c0105b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p++ = *src++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b5b:	83 c4 20             	add    $0x20,%esp
c0105b5e:	5e                   	pop    %esi
c0105b5f:	5f                   	pop    %edi
c0105b60:	5d                   	pop    %ebp
c0105b61:	c3                   	ret    

c0105b62 <strncpy>:
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len)
{
c0105b62:	55                   	push   %ebp
c0105b63:	89 e5                	mov    %esp,%ebp
c0105b65:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0)
c0105b6e:	eb 1e                	jmp    c0105b8e <strncpy+0x2c>
    {
        if ((*p = *src) != '\0')
c0105b70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b73:	0f b6 10             	movzbl (%eax),%edx
c0105b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b79:	88 10                	mov    %dl,(%eax)
c0105b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b7e:	0f b6 00             	movzbl (%eax),%eax
c0105b81:	84 c0                	test   %al,%al
c0105b83:	74 03                	je     c0105b88 <strncpy+0x26>
        {
            src++;
c0105b85:	ff 45 0c             	incl   0xc(%ebp)
        }
        p++, len--;
c0105b88:	ff 45 fc             	incl   -0x4(%ebp)
c0105b8b:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0)
c0105b8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b92:	75 dc                	jne    c0105b70 <strncpy+0xe>
    }
    return dst;
c0105b94:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b97:	89 ec                	mov    %ebp,%esp
c0105b99:	5d                   	pop    %ebp
c0105b9a:	c3                   	ret    

c0105b9b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int strcmp(const char *s1, const char *s2)
{
c0105b9b:	55                   	push   %ebp
c0105b9c:	89 e5                	mov    %esp,%ebp
c0105b9e:	57                   	push   %edi
c0105b9f:	56                   	push   %esi
c0105ba0:	83 ec 20             	sub    $0x20,%esp
c0105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile(
c0105baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bb5:	89 d1                	mov    %edx,%ecx
c0105bb7:	89 c2                	mov    %eax,%edx
c0105bb9:	89 ce                	mov    %ecx,%esi
c0105bbb:	89 d7                	mov    %edx,%edi
c0105bbd:	ac                   	lods   %ds:(%esi),%al
c0105bbe:	ae                   	scas   %es:(%edi),%al
c0105bbf:	75 08                	jne    c0105bc9 <strcmp+0x2e>
c0105bc1:	84 c0                	test   %al,%al
c0105bc3:	75 f8                	jne    c0105bbd <strcmp+0x22>
c0105bc5:	31 c0                	xor    %eax,%eax
c0105bc7:	eb 04                	jmp    c0105bcd <strcmp+0x32>
c0105bc9:	19 c0                	sbb    %eax,%eax
c0105bcb:	0c 01                	or     $0x1,%al
c0105bcd:	89 fa                	mov    %edi,%edx
c0105bcf:	89 f1                	mov    %esi,%ecx
c0105bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bd4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bd7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
    {
        s1++, s2++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bdd:	83 c4 20             	add    $0x20,%esp
c0105be0:	5e                   	pop    %esi
c0105be1:	5f                   	pop    %edi
c0105be2:	5d                   	pop    %ebp
c0105be3:	c3                   	ret    

c0105be4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int strncmp(const char *s1, const char *s2, size_t n)
{
c0105be4:	55                   	push   %ebp
c0105be5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c0105be7:	eb 09                	jmp    c0105bf2 <strncmp+0xe>
    {
        n--, s1++, s2++;
c0105be9:	ff 4d 10             	decl   0x10(%ebp)
c0105bec:	ff 45 08             	incl   0x8(%ebp)
c0105bef:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2)
c0105bf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bf6:	74 1a                	je     c0105c12 <strncmp+0x2e>
c0105bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfb:	0f b6 00             	movzbl (%eax),%eax
c0105bfe:	84 c0                	test   %al,%al
c0105c00:	74 10                	je     c0105c12 <strncmp+0x2e>
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	0f b6 10             	movzbl (%eax),%edx
c0105c08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0b:	0f b6 00             	movzbl (%eax),%eax
c0105c0e:	38 c2                	cmp    %al,%dl
c0105c10:	74 d7                	je     c0105be9 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c16:	74 18                	je     c0105c30 <strncmp+0x4c>
c0105c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1b:	0f b6 00             	movzbl (%eax),%eax
c0105c1e:	0f b6 d0             	movzbl %al,%edx
c0105c21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c24:	0f b6 00             	movzbl (%eax),%eax
c0105c27:	0f b6 c8             	movzbl %al,%ecx
c0105c2a:	89 d0                	mov    %edx,%eax
c0105c2c:	29 c8                	sub    %ecx,%eax
c0105c2e:	eb 05                	jmp    c0105c35 <strncmp+0x51>
c0105c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c35:	5d                   	pop    %ebp
c0105c36:	c3                   	ret    

c0105c37 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c)
{
c0105c37:	55                   	push   %ebp
c0105c38:	89 e5                	mov    %esp,%ebp
c0105c3a:	83 ec 04             	sub    $0x4,%esp
c0105c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c40:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c0105c43:	eb 13                	jmp    c0105c58 <strchr+0x21>
    {
        if (*s == c)
c0105c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c48:	0f b6 00             	movzbl (%eax),%eax
c0105c4b:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c4e:	75 05                	jne    c0105c55 <strchr+0x1e>
        {
            return (char *)s;
c0105c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c53:	eb 12                	jmp    c0105c67 <strchr+0x30>
        }
        s++;
c0105c55:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c0105c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5b:	0f b6 00             	movzbl (%eax),%eax
c0105c5e:	84 c0                	test   %al,%al
c0105c60:	75 e3                	jne    c0105c45 <strchr+0xe>
    }
    return NULL;
c0105c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c67:	89 ec                	mov    %ebp,%esp
c0105c69:	5d                   	pop    %ebp
c0105c6a:	c3                   	ret    

c0105c6b <strfind>:
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c)
{
c0105c6b:	55                   	push   %ebp
c0105c6c:	89 e5                	mov    %esp,%ebp
c0105c6e:	83 ec 04             	sub    $0x4,%esp
c0105c71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c74:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0')
c0105c77:	eb 0e                	jmp    c0105c87 <strfind+0x1c>
    {
        if (*s == c)
c0105c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7c:	0f b6 00             	movzbl (%eax),%eax
c0105c7f:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c82:	74 0f                	je     c0105c93 <strfind+0x28>
        {
            break;
        }
        s++;
c0105c84:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0')
c0105c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8a:	0f b6 00             	movzbl (%eax),%eax
c0105c8d:	84 c0                	test   %al,%al
c0105c8f:	75 e8                	jne    c0105c79 <strfind+0xe>
c0105c91:	eb 01                	jmp    c0105c94 <strfind+0x29>
            break;
c0105c93:	90                   	nop
    }
    return (char *)s;
c0105c94:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c97:	89 ec                	mov    %ebp,%esp
c0105c99:	5d                   	pop    %ebp
c0105c9a:	c3                   	ret    

c0105c9b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long strtol(const char *s, char **endptr, int base)
{
c0105c9b:	55                   	push   %ebp
c0105c9c:	89 e5                	mov    %esp,%ebp
c0105c9e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ca8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
c0105caf:	eb 03                	jmp    c0105cb4 <strtol+0x19>
    {
        s++;
c0105cb1:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t')
c0105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb7:	0f b6 00             	movzbl (%eax),%eax
c0105cba:	3c 20                	cmp    $0x20,%al
c0105cbc:	74 f3                	je     c0105cb1 <strtol+0x16>
c0105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc1:	0f b6 00             	movzbl (%eax),%eax
c0105cc4:	3c 09                	cmp    $0x9,%al
c0105cc6:	74 e9                	je     c0105cb1 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+')
c0105cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccb:	0f b6 00             	movzbl (%eax),%eax
c0105cce:	3c 2b                	cmp    $0x2b,%al
c0105cd0:	75 05                	jne    c0105cd7 <strtol+0x3c>
    {
        s++;
c0105cd2:	ff 45 08             	incl   0x8(%ebp)
c0105cd5:	eb 14                	jmp    c0105ceb <strtol+0x50>
    }
    else if (*s == '-')
c0105cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cda:	0f b6 00             	movzbl (%eax),%eax
c0105cdd:	3c 2d                	cmp    $0x2d,%al
c0105cdf:	75 0a                	jne    c0105ceb <strtol+0x50>
    {
        s++, neg = 1;
c0105ce1:	ff 45 08             	incl   0x8(%ebp)
c0105ce4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
c0105ceb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cef:	74 06                	je     c0105cf7 <strtol+0x5c>
c0105cf1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cf5:	75 22                	jne    c0105d19 <strtol+0x7e>
c0105cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfa:	0f b6 00             	movzbl (%eax),%eax
c0105cfd:	3c 30                	cmp    $0x30,%al
c0105cff:	75 18                	jne    c0105d19 <strtol+0x7e>
c0105d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d04:	40                   	inc    %eax
c0105d05:	0f b6 00             	movzbl (%eax),%eax
c0105d08:	3c 78                	cmp    $0x78,%al
c0105d0a:	75 0d                	jne    c0105d19 <strtol+0x7e>
    {
        s += 2, base = 16;
c0105d0c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d10:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d17:	eb 29                	jmp    c0105d42 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0')
c0105d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d1d:	75 16                	jne    c0105d35 <strtol+0x9a>
c0105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d22:	0f b6 00             	movzbl (%eax),%eax
c0105d25:	3c 30                	cmp    $0x30,%al
c0105d27:	75 0c                	jne    c0105d35 <strtol+0x9a>
    {
        s++, base = 8;
c0105d29:	ff 45 08             	incl   0x8(%ebp)
c0105d2c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d33:	eb 0d                	jmp    c0105d42 <strtol+0xa7>
    }
    else if (base == 0)
c0105d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d39:	75 07                	jne    c0105d42 <strtol+0xa7>
    {
        base = 10;
c0105d3b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    // digits
    while (1)
    {
        int dig;

        if (*s >= '0' && *s <= '9')
c0105d42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d45:	0f b6 00             	movzbl (%eax),%eax
c0105d48:	3c 2f                	cmp    $0x2f,%al
c0105d4a:	7e 1b                	jle    c0105d67 <strtol+0xcc>
c0105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4f:	0f b6 00             	movzbl (%eax),%eax
c0105d52:	3c 39                	cmp    $0x39,%al
c0105d54:	7f 11                	jg     c0105d67 <strtol+0xcc>
        {
            dig = *s - '0';
c0105d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d59:	0f b6 00             	movzbl (%eax),%eax
c0105d5c:	0f be c0             	movsbl %al,%eax
c0105d5f:	83 e8 30             	sub    $0x30,%eax
c0105d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d65:	eb 48                	jmp    c0105daf <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z')
c0105d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6a:	0f b6 00             	movzbl (%eax),%eax
c0105d6d:	3c 60                	cmp    $0x60,%al
c0105d6f:	7e 1b                	jle    c0105d8c <strtol+0xf1>
c0105d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d74:	0f b6 00             	movzbl (%eax),%eax
c0105d77:	3c 7a                	cmp    $0x7a,%al
c0105d79:	7f 11                	jg     c0105d8c <strtol+0xf1>
        {
            dig = *s - 'a' + 10;
c0105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7e:	0f b6 00             	movzbl (%eax),%eax
c0105d81:	0f be c0             	movsbl %al,%eax
c0105d84:	83 e8 57             	sub    $0x57,%eax
c0105d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d8a:	eb 23                	jmp    c0105daf <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z')
c0105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8f:	0f b6 00             	movzbl (%eax),%eax
c0105d92:	3c 40                	cmp    $0x40,%al
c0105d94:	7e 3b                	jle    c0105dd1 <strtol+0x136>
c0105d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d99:	0f b6 00             	movzbl (%eax),%eax
c0105d9c:	3c 5a                	cmp    $0x5a,%al
c0105d9e:	7f 31                	jg     c0105dd1 <strtol+0x136>
        {
            dig = *s - 'A' + 10;
c0105da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da3:	0f b6 00             	movzbl (%eax),%eax
c0105da6:	0f be c0             	movsbl %al,%eax
c0105da9:	83 e8 37             	sub    $0x37,%eax
c0105dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else
        {
            break;
        }
        if (dig >= base)
c0105daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105db5:	7d 19                	jge    c0105dd0 <strtol+0x135>
        {
            break;
        }
        s++, val = (val * base) + dig;
c0105db7:	ff 45 08             	incl   0x8(%ebp)
c0105dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dbd:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dc1:	89 c2                	mov    %eax,%edx
c0105dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dc6:	01 d0                	add    %edx,%eax
c0105dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    {
c0105dcb:	e9 72 ff ff ff       	jmp    c0105d42 <strtol+0xa7>
            break;
c0105dd0:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr)
c0105dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dd5:	74 08                	je     c0105ddf <strtol+0x144>
    {
        *endptr = (char *)s;
c0105dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dda:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ddd:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105de3:	74 07                	je     c0105dec <strtol+0x151>
c0105de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105de8:	f7 d8                	neg    %eax
c0105dea:	eb 03                	jmp    c0105def <strtol+0x154>
c0105dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105def:	89 ec                	mov    %ebp,%esp
c0105df1:	5d                   	pop    %ebp
c0105df2:	c3                   	ret    

c0105df3 <memset>:
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n)
{
c0105df3:	55                   	push   %ebp
c0105df4:	89 e5                	mov    %esp,%ebp
c0105df6:	83 ec 28             	sub    $0x28,%esp
c0105df9:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dff:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e02:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e09:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105e0c:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105e0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n)
{
    int d0, d1;
    asm volatile(
c0105e15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e18:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e1c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e1f:	89 d7                	mov    %edx,%edi
c0105e21:	f3 aa                	rep stos %al,%es:(%edi)
c0105e23:	89 fa                	mov    %edi,%edx
c0105e25:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e28:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c"(d0), "=&D"(d1)
        : "0"(n), "a"(c), "1"(s)
        : "memory");
    return s;
c0105e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    {
        *p++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e2e:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105e31:	89 ec                	mov    %ebp,%esp
c0105e33:	5d                   	pop    %ebp
c0105e34:	c3                   	ret    

c0105e35 <memmove>:
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n)
{
c0105e35:	55                   	push   %ebp
c0105e36:	89 e5                	mov    %esp,%ebp
c0105e38:	57                   	push   %edi
c0105e39:	56                   	push   %esi
c0105e3a:	53                   	push   %ebx
c0105e3b:	83 ec 30             	sub    $0x30,%esp
c0105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e4a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n)
{
    if (dst < src)
c0105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e56:	73 42                	jae    c0105e9a <memmove+0x65>
c0105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e67:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c"(d0), "=&D"(d1), "=&S"(d2)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0105e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e6d:	c1 e8 02             	shr    $0x2,%eax
c0105e70:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0105e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e78:	89 d7                	mov    %edx,%edi
c0105e7a:	89 c6                	mov    %eax,%esi
c0105e7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e7e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e81:	83 e1 03             	and    $0x3,%ecx
c0105e84:	74 02                	je     c0105e88 <memmove+0x53>
c0105e86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e88:	89 f0                	mov    %esi,%eax
c0105e8a:	89 fa                	mov    %edi,%edx
c0105e8c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e8f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e92:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105e98:	eb 36                	jmp    c0105ed0 <memmove+0x9b>
        : "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
c0105e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea3:	01 c2                	add    %eax,%edx
c0105ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ea8:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eae:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile(
c0105eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb4:	89 c1                	mov    %eax,%ecx
c0105eb6:	89 d8                	mov    %ebx,%eax
c0105eb8:	89 d6                	mov    %edx,%esi
c0105eba:	89 c7                	mov    %eax,%edi
c0105ebc:	fd                   	std    
c0105ebd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ebf:	fc                   	cld    
c0105ec0:	89 f8                	mov    %edi,%eax
c0105ec2:	89 f2                	mov    %esi,%edx
c0105ec4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ec7:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105eca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d++ = *s++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ed0:	83 c4 30             	add    $0x30,%esp
c0105ed3:	5b                   	pop    %ebx
c0105ed4:	5e                   	pop    %esi
c0105ed5:	5f                   	pop    %edi
c0105ed6:	5d                   	pop    %ebp
c0105ed7:	c3                   	ret    

c0105ed8 <memcpy>:
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n)
{
c0105ed8:	55                   	push   %ebp
c0105ed9:	89 e5                	mov    %esp,%ebp
c0105edb:	57                   	push   %edi
c0105edc:	56                   	push   %esi
c0105edd:	83 ec 20             	sub    $0x20,%esp
c0105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eec:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eef:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0"(n / 4), "g"(n), "1"(dst), "2"(src)
c0105ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef5:	c1 e8 02             	shr    $0x2,%eax
c0105ef8:	89 c1                	mov    %eax,%ecx
    asm volatile(
c0105efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f00:	89 d7                	mov    %edx,%edi
c0105f02:	89 c6                	mov    %eax,%esi
c0105f04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f09:	83 e1 03             	and    $0x3,%ecx
c0105f0c:	74 02                	je     c0105f10 <memcpy+0x38>
c0105f0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f10:	89 f0                	mov    %esi,%eax
c0105f12:	89 fa                	mov    %edi,%edx
c0105f14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    {
        *d++ = *s++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f20:	83 c4 20             	add    $0x20,%esp
c0105f23:	5e                   	pop    %esi
c0105f24:	5f                   	pop    %edi
c0105f25:	5d                   	pop    %ebp
c0105f26:	c3                   	ret    

c0105f27 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int memcmp(const void *v1, const void *v2, size_t n)
{
c0105f27:	55                   	push   %ebp
c0105f28:	89 e5                	mov    %esp,%ebp
c0105f2a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f36:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n-- > 0)
c0105f39:	eb 2e                	jmp    c0105f69 <memcmp+0x42>
    {
        if (*s1 != *s2)
c0105f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f3e:	0f b6 10             	movzbl (%eax),%edx
c0105f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f44:	0f b6 00             	movzbl (%eax),%eax
c0105f47:	38 c2                	cmp    %al,%dl
c0105f49:	74 18                	je     c0105f63 <memcmp+0x3c>
        {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f4e:	0f b6 00             	movzbl (%eax),%eax
c0105f51:	0f b6 d0             	movzbl %al,%edx
c0105f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f57:	0f b6 00             	movzbl (%eax),%eax
c0105f5a:	0f b6 c8             	movzbl %al,%ecx
c0105f5d:	89 d0                	mov    %edx,%eax
c0105f5f:	29 c8                	sub    %ecx,%eax
c0105f61:	eb 18                	jmp    c0105f7b <memcmp+0x54>
        }
        s1++, s2++;
c0105f63:	ff 45 fc             	incl   -0x4(%ebp)
c0105f66:	ff 45 f8             	incl   -0x8(%ebp)
    while (n-- > 0)
c0105f69:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f6c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f6f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f72:	85 c0                	test   %eax,%eax
c0105f74:	75 c5                	jne    c0105f3b <memcmp+0x14>
    }
    return 0;
c0105f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f7b:	89 ec                	mov    %ebp,%esp
c0105f7d:	5d                   	pop    %ebp
c0105f7e:	c3                   	ret    
