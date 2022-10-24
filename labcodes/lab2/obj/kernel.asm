
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
c0100059:	e8 ac 5d 00 00       	call   c0105e0a <memset>

    cons_init(); // init the console
c010005e:	e8 07 16 00 00       	call   c010166a <cons_init>

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
c0100087:	e8 88 44 00 00       	call   c0104514 <pmm_init>

    pic_init(); // init interrupt controller
c010008c:	e8 5a 17 00 00       	call   c01017eb <pic_init>
    idt_init(); // init interrupt descriptor table
c0100091:	e8 e1 18 00 00       	call   c0101977 <idt_init>

    clock_init();  // init clock interrupt
c0100096:	e8 2e 0d 00 00       	call   c0100dc9 <clock_init>
    intr_enable(); // enable irq interrupt
c010009b:	e8 a9 16 00 00       	call   c0101749 <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    // lab1_switch_test();
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
c01000c4:	e8 1b 0c 00 00       	call   c0100ce4 <mon_backtrace>
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
c0100319:	e8 7b 13 00 00       	call   c0101699 <cons_putc>
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
c0100359:	e8 d7 52 00 00       	call   c0105635 <vprintfmt>
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
c0100399:	e8 fb 12 00 00       	call   c0101699 <cons_putc>
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
c01003fb:	e8 d8 12 00 00       	call   c01016d8 <cons_getc>
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
c01005a0:	c7 45 f4 18 73 10 c0 	movl   $0xc0107318,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 1c 29 11 c0 	movl   $0xc011291c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec 1d 29 11 c0 	movl   $0xc011291d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 97 5e 11 c0 	movl   $0xc0115e97,-0x18(%ebp)

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
c0100708:	e8 75 55 00 00       	call   c0105c82 <strfind>
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
c010088e:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 6f 60 10 c0 	movl   $0xc010606f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 96 5f 10 	movl   $0xc0105f96,0x4(%esp)
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
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
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
c0100942:	c7 04 24 fa 60 10 c0 	movl   $0xc01060fa,(%esp)
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
c01009b0:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
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
c01009d7:	83 ec 58             	sub    $0x58,%esp
c01009da:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009dd:	89 e8                	mov    %ebp,%eax
c01009df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    uint32_t ebp = read_ebp();
c01009e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c01009e8:	e8 d4 ff ff ff       	call   c01009c1 <read_eip>
c01009ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t args[4];

    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
c01009f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f7:	e9 91 00 00 00       	jmp    c0100a8d <print_stackframe+0xb9>
    {
        cprintf("ebp: 0x%08x eip: 0x%08x ", ebp, eip);
c01009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0a:	c7 04 24 28 61 10 c0 	movl   $0xc0106128,(%esp)
c0100a11:	e8 4f f9 ff ff       	call   c0100365 <cprintf>

        for (int j = 0; j < 4; j++)
c0100a16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a1d:	eb 1e                	jmp    c0100a3d <print_stackframe+0x69>
            args[j] = *((uint32_t *)ebp + j + 2);
c0100a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2c:	01 d0                	add    %edx,%eax
c0100a2e:	83 c0 08             	add    $0x8,%eax
c0100a31:	8b 10                	mov    (%eax),%edx
c0100a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a36:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
        for (int j = 0; j < 4; j++)
c0100a3a:	ff 45 e8             	incl   -0x18(%ebp)
c0100a3d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a41:	7e dc                	jle    c0100a1f <print_stackframe+0x4b>
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n", args[0], args[1], args[2], args[3]);
c0100a43:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c0100a46:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100a49:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a4f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a57:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5f:	c7 04 24 44 61 10 c0 	movl   $0xc0106144,(%esp)
c0100a66:	e8 fa f8 ff ff       	call   c0100365 <cprintf>
        print_debuginfo(eip - 1);
c0100a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a6e:	48                   	dec    %eax
c0100a6f:	89 04 24             	mov    %eax,(%esp)
c0100a72:	e8 a5 fe ff ff       	call   c010091c <print_debuginfo>

        eip = *((uint32_t *)ebp + 1);
c0100a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7a:	83 c0 04             	add    $0x4,%eax
c0100a7d:	8b 00                	mov    (%eax),%eax
c0100a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *((uint32_t *)ebp);
c0100a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a85:	8b 00                	mov    (%eax),%eax
c0100a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i = 0; i <= STACKFRAME_DEPTH; i++)
c0100a8a:	ff 45 ec             	incl   -0x14(%ebp)
c0100a8d:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
c0100a91:	0f 8e 65 ff ff ff    	jle    c01009fc <print_stackframe+0x28>
    }
}
c0100a97:	90                   	nop
c0100a98:	90                   	nop
c0100a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a9c:	89 ec                	mov    %ebp,%esp
c0100a9e:	5d                   	pop    %ebp
c0100a9f:	c3                   	ret    

c0100aa0 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aa0:	55                   	push   %ebp
c0100aa1:	89 e5                	mov    %esp,%ebp
c0100aa3:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100aa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aad:	eb 0c                	jmp    c0100abb <parse+0x1b>
            *buf ++ = '\0';
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	8d 50 01             	lea    0x1(%eax),%edx
c0100ab5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ab8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	74 1d                	je     c0100ae2 <parse+0x42>
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	0f b6 00             	movzbl (%eax),%eax
c0100acb:	0f be c0             	movsbl %al,%eax
c0100ace:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad2:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c0100ad9:	e8 70 51 00 00       	call   c0105c4e <strchr>
c0100ade:	85 c0                	test   %eax,%eax
c0100ae0:	75 cd                	jne    c0100aaf <parse+0xf>
        }
        if (*buf == '\0') {
c0100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae5:	0f b6 00             	movzbl (%eax),%eax
c0100ae8:	84 c0                	test   %al,%al
c0100aea:	74 65                	je     c0100b51 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100aec:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100af0:	75 14                	jne    c0100b06 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100af2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100af9:	00 
c0100afa:	c7 04 24 ed 61 10 c0 	movl   $0xc01061ed,(%esp)
c0100b01:	e8 5f f8 ff ff       	call   c0100365 <cprintf>
        }
        argv[argc ++] = buf;
c0100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b09:	8d 50 01             	lea    0x1(%eax),%edx
c0100b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b19:	01 c2                	add    %eax,%edx
c0100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b20:	eb 03                	jmp    c0100b25 <parse+0x85>
            buf ++;
c0100b22:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	0f b6 00             	movzbl (%eax),%eax
c0100b2b:	84 c0                	test   %al,%al
c0100b2d:	74 8c                	je     c0100abb <parse+0x1b>
c0100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b32:	0f b6 00             	movzbl (%eax),%eax
c0100b35:	0f be c0             	movsbl %al,%eax
c0100b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3c:	c7 04 24 e8 61 10 c0 	movl   $0xc01061e8,(%esp)
c0100b43:	e8 06 51 00 00       	call   c0105c4e <strchr>
c0100b48:	85 c0                	test   %eax,%eax
c0100b4a:	74 d6                	je     c0100b22 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b4c:	e9 6a ff ff ff       	jmp    c0100abb <parse+0x1b>
            break;
c0100b51:	90                   	nop
        }
    }
    return argc;
c0100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b55:	89 ec                	mov    %ebp,%esp
c0100b57:	5d                   	pop    %ebp
c0100b58:	c3                   	ret    

c0100b59 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b59:	55                   	push   %ebp
c0100b5a:	89 e5                	mov    %esp,%ebp
c0100b5c:	83 ec 68             	sub    $0x68,%esp
c0100b5f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b62:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6c:	89 04 24             	mov    %eax,(%esp)
c0100b6f:	e8 2c ff ff ff       	call   c0100aa0 <parse>
c0100b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b7b:	75 0a                	jne    c0100b87 <runcmd+0x2e>
        return 0;
c0100b7d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b82:	e9 83 00 00 00       	jmp    c0100c0a <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b8e:	eb 5a                	jmp    c0100bea <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b90:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b93:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b96:	89 c8                	mov    %ecx,%eax
c0100b98:	01 c0                	add    %eax,%eax
c0100b9a:	01 c8                	add    %ecx,%eax
c0100b9c:	c1 e0 02             	shl    $0x2,%eax
c0100b9f:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100ba4:	8b 00                	mov    (%eax),%eax
c0100ba6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100baa:	89 04 24             	mov    %eax,(%esp)
c0100bad:	e8 00 50 00 00       	call   c0105bb2 <strcmp>
c0100bb2:	85 c0                	test   %eax,%eax
c0100bb4:	75 31                	jne    c0100be7 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb9:	89 d0                	mov    %edx,%eax
c0100bbb:	01 c0                	add    %eax,%eax
c0100bbd:	01 d0                	add    %edx,%eax
c0100bbf:	c1 e0 02             	shl    $0x2,%eax
c0100bc2:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100bc7:	8b 10                	mov    (%eax),%edx
c0100bc9:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bcc:	83 c0 04             	add    $0x4,%eax
c0100bcf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bd2:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bd8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be0:	89 1c 24             	mov    %ebx,(%esp)
c0100be3:	ff d2                	call   *%edx
c0100be5:	eb 23                	jmp    c0100c0a <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be7:	ff 45 f4             	incl   -0xc(%ebp)
c0100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bed:	83 f8 02             	cmp    $0x2,%eax
c0100bf0:	76 9e                	jbe    c0100b90 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bf2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf9:	c7 04 24 0b 62 10 c0 	movl   $0xc010620b,(%esp)
c0100c00:	e8 60 f7 ff ff       	call   c0100365 <cprintf>
    return 0;
c0100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100c0d:	89 ec                	mov    %ebp,%esp
c0100c0f:	5d                   	pop    %ebp
c0100c10:	c3                   	ret    

c0100c11 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c11:	55                   	push   %ebp
c0100c12:	89 e5                	mov    %esp,%ebp
c0100c14:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c17:	c7 04 24 24 62 10 c0 	movl   $0xc0106224,(%esp)
c0100c1e:	e8 42 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c23:	c7 04 24 4c 62 10 c0 	movl   $0xc010624c,(%esp)
c0100c2a:	e8 36 f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL) {
c0100c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c33:	74 0b                	je     c0100c40 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c38:	89 04 24             	mov    %eax,(%esp)
c0100c3b:	e8 f1 0e 00 00       	call   c0101b31 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c40:	c7 04 24 71 62 10 c0 	movl   $0xc0106271,(%esp)
c0100c47:	e8 0a f6 ff ff       	call   c0100256 <readline>
c0100c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c53:	74 eb                	je     c0100c40 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c55:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5f:	89 04 24             	mov    %eax,(%esp)
c0100c62:	e8 f2 fe ff ff       	call   c0100b59 <runcmd>
c0100c67:	85 c0                	test   %eax,%eax
c0100c69:	78 02                	js     c0100c6d <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c6b:	eb d3                	jmp    c0100c40 <kmonitor+0x2f>
                break;
c0100c6d:	90                   	nop
            }
        }
    }
}
c0100c6e:	90                   	nop
c0100c6f:	89 ec                	mov    %ebp,%esp
c0100c71:	5d                   	pop    %ebp
c0100c72:	c3                   	ret    

c0100c73 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c73:	55                   	push   %ebp
c0100c74:	89 e5                	mov    %esp,%ebp
c0100c76:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c80:	eb 3d                	jmp    c0100cbf <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c85:	89 d0                	mov    %edx,%eax
c0100c87:	01 c0                	add    %eax,%eax
c0100c89:	01 d0                	add    %edx,%eax
c0100c8b:	c1 e0 02             	shl    $0x2,%eax
c0100c8e:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c93:	8b 10                	mov    (%eax),%edx
c0100c95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c98:	89 c8                	mov    %ecx,%eax
c0100c9a:	01 c0                	add    %eax,%eax
c0100c9c:	01 c8                	add    %ecx,%eax
c0100c9e:	c1 e0 02             	shl    $0x2,%eax
c0100ca1:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100ca6:	8b 00                	mov    (%eax),%eax
c0100ca8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb0:	c7 04 24 75 62 10 c0 	movl   $0xc0106275,(%esp)
c0100cb7:	e8 a9 f6 ff ff       	call   c0100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cbc:	ff 45 f4             	incl   -0xc(%ebp)
c0100cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc2:	83 f8 02             	cmp    $0x2,%eax
c0100cc5:	76 bb                	jbe    c0100c82 <mon_help+0xf>
    }
    return 0;
c0100cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccc:	89 ec                	mov    %ebp,%esp
c0100cce:	5d                   	pop    %ebp
c0100ccf:	c3                   	ret    

c0100cd0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cd0:	55                   	push   %ebp
c0100cd1:	89 e5                	mov    %esp,%ebp
c0100cd3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cd6:	e8 ad fb ff ff       	call   c0100888 <print_kerninfo>
    return 0;
c0100cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce0:	89 ec                	mov    %ebp,%esp
c0100ce2:	5d                   	pop    %ebp
c0100ce3:	c3                   	ret    

c0100ce4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ce4:	55                   	push   %ebp
c0100ce5:	89 e5                	mov    %esp,%ebp
c0100ce7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cea:	e8 e5 fc ff ff       	call   c01009d4 <print_stackframe>
    return 0;
c0100cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf4:	89 ec                	mov    %ebp,%esp
c0100cf6:	5d                   	pop    %ebp
c0100cf7:	c3                   	ret    

c0100cf8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cf8:	55                   	push   %ebp
c0100cf9:	89 e5                	mov    %esp,%ebp
c0100cfb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cfe:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100d03:	85 c0                	test   %eax,%eax
c0100d05:	75 5b                	jne    c0100d62 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100d07:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100d0e:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d11:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d25:	c7 04 24 7e 62 10 c0 	movl   $0xc010627e,(%esp)
c0100d2c:	e8 34 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d38:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d3b:	89 04 24             	mov    %eax,(%esp)
c0100d3e:	e8 ed f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d43:	c7 04 24 9a 62 10 c0 	movl   $0xc010629a,(%esp)
c0100d4a:	e8 16 f6 ff ff       	call   c0100365 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d4f:	c7 04 24 9c 62 10 c0 	movl   $0xc010629c,(%esp)
c0100d56:	e8 0a f6 ff ff       	call   c0100365 <cprintf>
    print_stackframe();
c0100d5b:	e8 74 fc ff ff       	call   c01009d4 <print_stackframe>
c0100d60:	eb 01                	jmp    c0100d63 <__panic+0x6b>
        goto panic_dead;
c0100d62:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d63:	e8 e9 09 00 00       	call   c0101751 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d6f:	e8 9d fe ff ff       	call   c0100c11 <kmonitor>
c0100d74:	eb f2                	jmp    c0100d68 <__panic+0x70>

c0100d76 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
c0100d79:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d7c:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d85:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d89:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d90:	c7 04 24 ae 62 10 c0 	movl   $0xc01062ae,(%esp)
c0100d97:	e8 c9 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100da3:	8b 45 10             	mov    0x10(%ebp),%eax
c0100da6:	89 04 24             	mov    %eax,(%esp)
c0100da9:	e8 82 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100dae:	c7 04 24 9a 62 10 c0 	movl   $0xc010629a,(%esp)
c0100db5:	e8 ab f5 ff ff       	call   c0100365 <cprintf>
    va_end(ap);
}
c0100dba:	90                   	nop
c0100dbb:	89 ec                	mov    %ebp,%esp
c0100dbd:	5d                   	pop    %ebp
c0100dbe:	c3                   	ret    

c0100dbf <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100dbf:	55                   	push   %ebp
c0100dc0:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100dc2:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100dc7:	5d                   	pop    %ebp
c0100dc8:	c3                   	ret    

c0100dc9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dc9:	55                   	push   %ebp
c0100dca:	89 e5                	mov    %esp,%ebp
c0100dcc:	83 ec 28             	sub    $0x28,%esp
c0100dcf:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dd5:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ddd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100de1:	ee                   	out    %al,(%dx)
}
c0100de2:	90                   	nop
c0100de3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100de9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ded:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100df1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100df5:	ee                   	out    %al,(%dx)
}
c0100df6:	90                   	nop
c0100df7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100dfd:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e01:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e05:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e09:	ee                   	out    %al,(%dx)
}
c0100e0a:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e0b:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100e12:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e15:	c7 04 24 cc 62 10 c0 	movl   $0xc01062cc,(%esp)
c0100e1c:	e8 44 f5 ff ff       	call   c0100365 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e28:	e8 89 09 00 00       	call   c01017b6 <pic_enable>
}
c0100e2d:	90                   	nop
c0100e2e:	89 ec                	mov    %ebp,%esp
c0100e30:	5d                   	pop    %ebp
c0100e31:	c3                   	ret    

c0100e32 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e32:	55                   	push   %ebp
c0100e33:	89 e5                	mov    %esp,%ebp
c0100e35:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e38:	9c                   	pushf  
c0100e39:	58                   	pop    %eax
c0100e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e40:	25 00 02 00 00       	and    $0x200,%eax
c0100e45:	85 c0                	test   %eax,%eax
c0100e47:	74 0c                	je     c0100e55 <__intr_save+0x23>
        intr_disable();
c0100e49:	e8 03 09 00 00       	call   c0101751 <intr_disable>
        return 1;
c0100e4e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e53:	eb 05                	jmp    c0100e5a <__intr_save+0x28>
    }
    return 0;
c0100e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e5a:	89 ec                	mov    %ebp,%esp
c0100e5c:	5d                   	pop    %ebp
c0100e5d:	c3                   	ret    

c0100e5e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e5e:	55                   	push   %ebp
c0100e5f:	89 e5                	mov    %esp,%ebp
c0100e61:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e68:	74 05                	je     c0100e6f <__intr_restore+0x11>
        intr_enable();
c0100e6a:	e8 da 08 00 00       	call   c0101749 <intr_enable>
    }
}
c0100e6f:	90                   	nop
c0100e70:	89 ec                	mov    %ebp,%esp
c0100e72:	5d                   	pop    %ebp
c0100e73:	c3                   	ret    

c0100e74 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e74:	55                   	push   %ebp
c0100e75:	89 e5                	mov    %esp,%ebp
c0100e77:	83 ec 10             	sub    $0x10,%esp
c0100e7a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e80:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e84:	89 c2                	mov    %eax,%edx
c0100e86:	ec                   	in     (%dx),%al
c0100e87:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e8a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e90:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e94:	89 c2                	mov    %eax,%edx
c0100e96:	ec                   	in     (%dx),%al
c0100e97:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e9a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ea0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ea4:	89 c2                	mov    %eax,%edx
c0100ea6:	ec                   	in     (%dx),%al
c0100ea7:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100eaa:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100eb0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100eb4:	89 c2                	mov    %eax,%edx
c0100eb6:	ec                   	in     (%dx),%al
c0100eb7:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eba:	90                   	nop
c0100ebb:	89 ec                	mov    %ebp,%esp
c0100ebd:	5d                   	pop    %ebp
c0100ebe:	c3                   	ret    

c0100ebf <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ebf:	55                   	push   %ebp
c0100ec0:	89 e5                	mov    %esp,%ebp
c0100ec2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ec5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ecf:	0f b7 00             	movzwl (%eax),%eax
c0100ed2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ee1:	0f b7 00             	movzwl (%eax),%eax
c0100ee4:	0f b7 c0             	movzwl %ax,%eax
c0100ee7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100eec:	74 12                	je     c0100f00 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eee:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ef5:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100efc:	b4 03 
c0100efe:	eb 13                	jmp    c0100f13 <cga_init+0x54>
    } else {
        *cp = was;
c0100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f03:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f07:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f0a:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100f11:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f13:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f1a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f1e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f22:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f26:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f2a:	ee                   	out    %al,(%dx)
}
c0100f2b:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f2c:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f33:	40                   	inc    %eax
c0100f34:	0f b7 c0             	movzwl %ax,%eax
c0100f37:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f3f:	89 c2                	mov    %eax,%edx
c0100f41:	ec                   	in     (%dx),%al
c0100f42:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f45:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f49:	0f b6 c0             	movzbl %al,%eax
c0100f4c:	c1 e0 08             	shl    $0x8,%eax
c0100f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f52:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f59:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f5d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f61:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f65:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f69:	ee                   	out    %al,(%dx)
}
c0100f6a:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f6b:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f72:	40                   	inc    %eax
c0100f73:	0f b7 c0             	movzwl %ax,%eax
c0100f76:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f7a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f7e:	89 c2                	mov    %eax,%edx
c0100f80:	ec                   	in     (%dx),%al
c0100f81:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f88:	0f b6 c0             	movzbl %al,%eax
c0100f8b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f91:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f99:	0f b7 c0             	movzwl %ax,%eax
c0100f9c:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100fa2:	90                   	nop
c0100fa3:	89 ec                	mov    %ebp,%esp
c0100fa5:	5d                   	pop    %ebp
c0100fa6:	c3                   	ret    

c0100fa7 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fa7:	55                   	push   %ebp
c0100fa8:	89 e5                	mov    %esp,%ebp
c0100faa:	83 ec 48             	sub    $0x48,%esp
c0100fad:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fb3:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fb7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fbb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fbf:	ee                   	out    %al,(%dx)
}
c0100fc0:	90                   	nop
c0100fc1:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fc7:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fcb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fcf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fd3:	ee                   	out    %al,(%dx)
}
c0100fd4:	90                   	nop
c0100fd5:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fdb:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fe3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fe7:	ee                   	out    %al,(%dx)
}
c0100fe8:	90                   	nop
c0100fe9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fef:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ffb:	ee                   	out    %al,(%dx)
}
c0100ffc:	90                   	nop
c0100ffd:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101003:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101007:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010100b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010100f:	ee                   	out    %al,(%dx)
}
c0101010:	90                   	nop
c0101011:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101017:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010101f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101023:	ee                   	out    %al,(%dx)
}
c0101024:	90                   	nop
c0101025:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010102b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101033:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101037:	ee                   	out    %al,(%dx)
}
c0101038:	90                   	nop
c0101039:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010103f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101043:	89 c2                	mov    %eax,%edx
c0101045:	ec                   	in     (%dx),%al
c0101046:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101049:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010104d:	3c ff                	cmp    $0xff,%al
c010104f:	0f 95 c0             	setne  %al
c0101052:	0f b6 c0             	movzbl %al,%eax
c0101055:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c010105a:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101060:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101064:	89 c2                	mov    %eax,%edx
c0101066:	ec                   	in     (%dx),%al
c0101067:	88 45 f1             	mov    %al,-0xf(%ebp)
c010106a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101070:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101074:	89 c2                	mov    %eax,%edx
c0101076:	ec                   	in     (%dx),%al
c0101077:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010107a:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010107f:	85 c0                	test   %eax,%eax
c0101081:	74 0c                	je     c010108f <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101083:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010108a:	e8 27 07 00 00       	call   c01017b6 <pic_enable>
    }
}
c010108f:	90                   	nop
c0101090:	89 ec                	mov    %ebp,%esp
c0101092:	5d                   	pop    %ebp
c0101093:	c3                   	ret    

c0101094 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101094:	55                   	push   %ebp
c0101095:	89 e5                	mov    %esp,%ebp
c0101097:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010a1:	eb 08                	jmp    c01010ab <lpt_putc_sub+0x17>
        delay();
c01010a3:	e8 cc fd ff ff       	call   c0100e74 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010a8:	ff 45 fc             	incl   -0x4(%ebp)
c01010ab:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010b5:	89 c2                	mov    %eax,%edx
c01010b7:	ec                   	in     (%dx),%al
c01010b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010bf:	84 c0                	test   %al,%al
c01010c1:	78 09                	js     c01010cc <lpt_putc_sub+0x38>
c01010c3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010ca:	7e d7                	jle    c01010a3 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cf:	0f b6 c0             	movzbl %al,%eax
c01010d2:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010d8:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010db:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010df:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010e3:	ee                   	out    %al,(%dx)
}
c01010e4:	90                   	nop
c01010e5:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010eb:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010ef:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010f3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010f7:	ee                   	out    %al,(%dx)
}
c01010f8:	90                   	nop
c01010f9:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010ff:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101103:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101107:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010110b:	ee                   	out    %al,(%dx)
}
c010110c:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010110d:	90                   	nop
c010110e:	89 ec                	mov    %ebp,%esp
c0101110:	5d                   	pop    %ebp
c0101111:	c3                   	ret    

c0101112 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101112:	55                   	push   %ebp
c0101113:	89 e5                	mov    %esp,%ebp
c0101115:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101118:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010111c:	74 0d                	je     c010112b <lpt_putc+0x19>
        lpt_putc_sub(c);
c010111e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101121:	89 04 24             	mov    %eax,(%esp)
c0101124:	e8 6b ff ff ff       	call   c0101094 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101129:	eb 24                	jmp    c010114f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010112b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101132:	e8 5d ff ff ff       	call   c0101094 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101137:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010113e:	e8 51 ff ff ff       	call   c0101094 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101143:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010114a:	e8 45 ff ff ff       	call   c0101094 <lpt_putc_sub>
}
c010114f:	90                   	nop
c0101150:	89 ec                	mov    %ebp,%esp
c0101152:	5d                   	pop    %ebp
c0101153:	c3                   	ret    

c0101154 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101154:	55                   	push   %ebp
c0101155:	89 e5                	mov    %esp,%ebp
c0101157:	83 ec 38             	sub    $0x38,%esp
c010115a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c010115d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101160:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101165:	85 c0                	test   %eax,%eax
c0101167:	75 07                	jne    c0101170 <cga_putc+0x1c>
        c |= 0x0700;
c0101169:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101170:	8b 45 08             	mov    0x8(%ebp),%eax
c0101173:	0f b6 c0             	movzbl %al,%eax
c0101176:	83 f8 0d             	cmp    $0xd,%eax
c0101179:	74 72                	je     c01011ed <cga_putc+0x99>
c010117b:	83 f8 0d             	cmp    $0xd,%eax
c010117e:	0f 8f a3 00 00 00    	jg     c0101227 <cga_putc+0xd3>
c0101184:	83 f8 08             	cmp    $0x8,%eax
c0101187:	74 0a                	je     c0101193 <cga_putc+0x3f>
c0101189:	83 f8 0a             	cmp    $0xa,%eax
c010118c:	74 4c                	je     c01011da <cga_putc+0x86>
c010118e:	e9 94 00 00 00       	jmp    c0101227 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c0101193:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010119a:	85 c0                	test   %eax,%eax
c010119c:	0f 84 af 00 00 00    	je     c0101251 <cga_putc+0xfd>
            crt_pos --;
c01011a2:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011a9:	48                   	dec    %eax
c01011aa:	0f b7 c0             	movzwl %ax,%eax
c01011ad:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b6:	98                   	cwtl   
c01011b7:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011bc:	98                   	cwtl   
c01011bd:	83 c8 20             	or     $0x20,%eax
c01011c0:	98                   	cwtl   
c01011c1:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011c7:	0f b7 15 44 b4 11 c0 	movzwl 0xc011b444,%edx
c01011ce:	01 d2                	add    %edx,%edx
c01011d0:	01 ca                	add    %ecx,%edx
c01011d2:	0f b7 c0             	movzwl %ax,%eax
c01011d5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011d8:	eb 77                	jmp    c0101251 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011da:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011e1:	83 c0 50             	add    $0x50,%eax
c01011e4:	0f b7 c0             	movzwl %ax,%eax
c01011e7:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011ed:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c01011f4:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c01011fb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101200:	89 c8                	mov    %ecx,%eax
c0101202:	f7 e2                	mul    %edx
c0101204:	c1 ea 06             	shr    $0x6,%edx
c0101207:	89 d0                	mov    %edx,%eax
c0101209:	c1 e0 02             	shl    $0x2,%eax
c010120c:	01 d0                	add    %edx,%eax
c010120e:	c1 e0 04             	shl    $0x4,%eax
c0101211:	29 c1                	sub    %eax,%ecx
c0101213:	89 ca                	mov    %ecx,%edx
c0101215:	0f b7 d2             	movzwl %dx,%edx
c0101218:	89 d8                	mov    %ebx,%eax
c010121a:	29 d0                	sub    %edx,%eax
c010121c:	0f b7 c0             	movzwl %ax,%eax
c010121f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101225:	eb 2b                	jmp    c0101252 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101227:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010122d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101234:	8d 50 01             	lea    0x1(%eax),%edx
c0101237:	0f b7 d2             	movzwl %dx,%edx
c010123a:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c0101241:	01 c0                	add    %eax,%eax
c0101243:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101246:	8b 45 08             	mov    0x8(%ebp),%eax
c0101249:	0f b7 c0             	movzwl %ax,%eax
c010124c:	66 89 02             	mov    %ax,(%edx)
        break;
c010124f:	eb 01                	jmp    c0101252 <cga_putc+0xfe>
        break;
c0101251:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101252:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101259:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c010125e:	76 5e                	jbe    c01012be <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101260:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101265:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010126b:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101270:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101277:	00 
c0101278:	89 54 24 04          	mov    %edx,0x4(%esp)
c010127c:	89 04 24             	mov    %eax,(%esp)
c010127f:	e8 c8 4b 00 00       	call   c0105e4c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101284:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010128b:	eb 15                	jmp    c01012a2 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c010128d:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c0101293:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101296:	01 c0                	add    %eax,%eax
c0101298:	01 d0                	add    %edx,%eax
c010129a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010129f:	ff 45 f4             	incl   -0xc(%ebp)
c01012a2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012a9:	7e e2                	jle    c010128d <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c01012ab:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012b2:	83 e8 50             	sub    $0x50,%eax
c01012b5:	0f b7 c0             	movzwl %ax,%eax
c01012b8:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012be:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012c5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012c9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d5:	ee                   	out    %al,(%dx)
}
c01012d6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012d7:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012de:	c1 e8 08             	shr    $0x8,%eax
c01012e1:	0f b7 c0             	movzwl %ax,%eax
c01012e4:	0f b6 c0             	movzbl %al,%eax
c01012e7:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012ee:	42                   	inc    %edx
c01012ef:	0f b7 d2             	movzwl %dx,%edx
c01012f2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012f6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012fd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101301:	ee                   	out    %al,(%dx)
}
c0101302:	90                   	nop
    outb(addr_6845, 15);
c0101303:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c010130a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010130e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101312:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101316:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010131a:	ee                   	out    %al,(%dx)
}
c010131b:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010131c:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101323:	0f b6 c0             	movzbl %al,%eax
c0101326:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c010132d:	42                   	inc    %edx
c010132e:	0f b7 d2             	movzwl %dx,%edx
c0101331:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101335:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101338:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010133c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101340:	ee                   	out    %al,(%dx)
}
c0101341:	90                   	nop
}
c0101342:	90                   	nop
c0101343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101346:	89 ec                	mov    %ebp,%esp
c0101348:	5d                   	pop    %ebp
c0101349:	c3                   	ret    

c010134a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010134a:	55                   	push   %ebp
c010134b:	89 e5                	mov    %esp,%ebp
c010134d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101357:	eb 08                	jmp    c0101361 <serial_putc_sub+0x17>
        delay();
c0101359:	e8 16 fb ff ff       	call   c0100e74 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010135e:	ff 45 fc             	incl   -0x4(%ebp)
c0101361:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101367:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010136b:	89 c2                	mov    %eax,%edx
c010136d:	ec                   	in     (%dx),%al
c010136e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101371:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101375:	0f b6 c0             	movzbl %al,%eax
c0101378:	83 e0 20             	and    $0x20,%eax
c010137b:	85 c0                	test   %eax,%eax
c010137d:	75 09                	jne    c0101388 <serial_putc_sub+0x3e>
c010137f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101386:	7e d1                	jle    c0101359 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101388:	8b 45 08             	mov    0x8(%ebp),%eax
c010138b:	0f b6 c0             	movzbl %al,%eax
c010138e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101394:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101397:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010139b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010139f:	ee                   	out    %al,(%dx)
}
c01013a0:	90                   	nop
}
c01013a1:	90                   	nop
c01013a2:	89 ec                	mov    %ebp,%esp
c01013a4:	5d                   	pop    %ebp
c01013a5:	c3                   	ret    

c01013a6 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013a6:	55                   	push   %ebp
c01013a7:	89 e5                	mov    %esp,%ebp
c01013a9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013b0:	74 0d                	je     c01013bf <serial_putc+0x19>
        serial_putc_sub(c);
c01013b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b5:	89 04 24             	mov    %eax,(%esp)
c01013b8:	e8 8d ff ff ff       	call   c010134a <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013bd:	eb 24                	jmp    c01013e3 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013bf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013c6:	e8 7f ff ff ff       	call   c010134a <serial_putc_sub>
        serial_putc_sub(' ');
c01013cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013d2:	e8 73 ff ff ff       	call   c010134a <serial_putc_sub>
        serial_putc_sub('\b');
c01013d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013de:	e8 67 ff ff ff       	call   c010134a <serial_putc_sub>
}
c01013e3:	90                   	nop
c01013e4:	89 ec                	mov    %ebp,%esp
c01013e6:	5d                   	pop    %ebp
c01013e7:	c3                   	ret    

c01013e8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013e8:	55                   	push   %ebp
c01013e9:	89 e5                	mov    %esp,%ebp
c01013eb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013ee:	eb 33                	jmp    c0101423 <cons_intr+0x3b>
        if (c != 0) {
c01013f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013f4:	74 2d                	je     c0101423 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013f6:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013fb:	8d 50 01             	lea    0x1(%eax),%edx
c01013fe:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c0101404:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101407:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010140d:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101412:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101417:	75 0a                	jne    c0101423 <cons_intr+0x3b>
                cons.wpos = 0;
c0101419:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101420:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101423:	8b 45 08             	mov    0x8(%ebp),%eax
c0101426:	ff d0                	call   *%eax
c0101428:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010142b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010142f:	75 bf                	jne    c01013f0 <cons_intr+0x8>
            }
        }
    }
}
c0101431:	90                   	nop
c0101432:	90                   	nop
c0101433:	89 ec                	mov    %ebp,%esp
c0101435:	5d                   	pop    %ebp
c0101436:	c3                   	ret    

c0101437 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101437:	55                   	push   %ebp
c0101438:	89 e5                	mov    %esp,%ebp
c010143a:	83 ec 10             	sub    $0x10,%esp
c010143d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101443:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101447:	89 c2                	mov    %eax,%edx
c0101449:	ec                   	in     (%dx),%al
c010144a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010144d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101451:	0f b6 c0             	movzbl %al,%eax
c0101454:	83 e0 01             	and    $0x1,%eax
c0101457:	85 c0                	test   %eax,%eax
c0101459:	75 07                	jne    c0101462 <serial_proc_data+0x2b>
        return -1;
c010145b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101460:	eb 2a                	jmp    c010148c <serial_proc_data+0x55>
c0101462:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101468:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010146c:	89 c2                	mov    %eax,%edx
c010146e:	ec                   	in     (%dx),%al
c010146f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101472:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101476:	0f b6 c0             	movzbl %al,%eax
c0101479:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010147c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101480:	75 07                	jne    c0101489 <serial_proc_data+0x52>
        c = '\b';
c0101482:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101489:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010148c:	89 ec                	mov    %ebp,%esp
c010148e:	5d                   	pop    %ebp
c010148f:	c3                   	ret    

c0101490 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101490:	55                   	push   %ebp
c0101491:	89 e5                	mov    %esp,%ebp
c0101493:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101496:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010149b:	85 c0                	test   %eax,%eax
c010149d:	74 0c                	je     c01014ab <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010149f:	c7 04 24 37 14 10 c0 	movl   $0xc0101437,(%esp)
c01014a6:	e8 3d ff ff ff       	call   c01013e8 <cons_intr>
    }
}
c01014ab:	90                   	nop
c01014ac:	89 ec                	mov    %ebp,%esp
c01014ae:	5d                   	pop    %ebp
c01014af:	c3                   	ret    

c01014b0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014b0:	55                   	push   %ebp
c01014b1:	89 e5                	mov    %esp,%ebp
c01014b3:	83 ec 38             	sub    $0x38,%esp
c01014b6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014bf:	89 c2                	mov    %eax,%edx
c01014c1:	ec                   	in     (%dx),%al
c01014c2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014c9:	0f b6 c0             	movzbl %al,%eax
c01014cc:	83 e0 01             	and    $0x1,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	75 0a                	jne    c01014dd <kbd_proc_data+0x2d>
        return -1;
c01014d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014d8:	e9 56 01 00 00       	jmp    c0101633 <kbd_proc_data+0x183>
c01014dd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014e6:	89 c2                	mov    %eax,%edx
c01014e8:	ec                   	in     (%dx),%al
c01014e9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014ec:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014f0:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014f3:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014f7:	75 17                	jne    c0101510 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014f9:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014fe:	83 c8 40             	or     $0x40,%eax
c0101501:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101506:	b8 00 00 00 00       	mov    $0x0,%eax
c010150b:	e9 23 01 00 00       	jmp    c0101633 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	84 c0                	test   %al,%al
c0101516:	79 45                	jns    c010155d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101518:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010151d:	83 e0 40             	and    $0x40,%eax
c0101520:	85 c0                	test   %eax,%eax
c0101522:	75 08                	jne    c010152c <kbd_proc_data+0x7c>
c0101524:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101528:	24 7f                	and    $0x7f,%al
c010152a:	eb 04                	jmp    c0101530 <kbd_proc_data+0x80>
c010152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101530:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101533:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101537:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c010153e:	0c 40                	or     $0x40,%al
c0101540:	0f b6 c0             	movzbl %al,%eax
c0101543:	f7 d0                	not    %eax
c0101545:	89 c2                	mov    %eax,%edx
c0101547:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010154c:	21 d0                	and    %edx,%eax
c010154e:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101553:	b8 00 00 00 00       	mov    $0x0,%eax
c0101558:	e9 d6 00 00 00       	jmp    c0101633 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c010155d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101562:	83 e0 40             	and    $0x40,%eax
c0101565:	85 c0                	test   %eax,%eax
c0101567:	74 11                	je     c010157a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101569:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010156d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101572:	83 e0 bf             	and    $0xffffffbf,%eax
c0101575:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c010157a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157e:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101585:	0f b6 d0             	movzbl %al,%edx
c0101588:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010158d:	09 d0                	or     %edx,%eax
c010158f:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101594:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101598:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c010159f:	0f b6 d0             	movzbl %al,%edx
c01015a2:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015a7:	31 d0                	xor    %edx,%eax
c01015a9:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015ae:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015b3:	83 e0 03             	and    $0x3,%eax
c01015b6:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01015bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c1:	01 d0                	add    %edx,%eax
c01015c3:	0f b6 00             	movzbl (%eax),%eax
c01015c6:	0f b6 c0             	movzbl %al,%eax
c01015c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015cc:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015d1:	83 e0 08             	and    $0x8,%eax
c01015d4:	85 c0                	test   %eax,%eax
c01015d6:	74 22                	je     c01015fa <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015d8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015dc:	7e 0c                	jle    c01015ea <kbd_proc_data+0x13a>
c01015de:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015e2:	7f 06                	jg     c01015ea <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015e4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015e8:	eb 10                	jmp    c01015fa <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015ea:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015ee:	7e 0a                	jle    c01015fa <kbd_proc_data+0x14a>
c01015f0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015f4:	7f 04                	jg     c01015fa <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015f6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015fa:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015ff:	f7 d0                	not    %eax
c0101601:	83 e0 06             	and    $0x6,%eax
c0101604:	85 c0                	test   %eax,%eax
c0101606:	75 28                	jne    c0101630 <kbd_proc_data+0x180>
c0101608:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010160f:	75 1f                	jne    c0101630 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101611:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0101618:	e8 48 ed ff ff       	call   c0100365 <cprintf>
c010161d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101623:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101627:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010162b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010162e:	ee                   	out    %al,(%dx)
}
c010162f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101633:	89 ec                	mov    %ebp,%esp
c0101635:	5d                   	pop    %ebp
c0101636:	c3                   	ret    

c0101637 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101637:	55                   	push   %ebp
c0101638:	89 e5                	mov    %esp,%ebp
c010163a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010163d:	c7 04 24 b0 14 10 c0 	movl   $0xc01014b0,(%esp)
c0101644:	e8 9f fd ff ff       	call   c01013e8 <cons_intr>
}
c0101649:	90                   	nop
c010164a:	89 ec                	mov    %ebp,%esp
c010164c:	5d                   	pop    %ebp
c010164d:	c3                   	ret    

c010164e <kbd_init>:

static void
kbd_init(void) {
c010164e:	55                   	push   %ebp
c010164f:	89 e5                	mov    %esp,%ebp
c0101651:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101654:	e8 de ff ff ff       	call   c0101637 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101660:	e8 51 01 00 00       	call   c01017b6 <pic_enable>
}
c0101665:	90                   	nop
c0101666:	89 ec                	mov    %ebp,%esp
c0101668:	5d                   	pop    %ebp
c0101669:	c3                   	ret    

c010166a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010166a:	55                   	push   %ebp
c010166b:	89 e5                	mov    %esp,%ebp
c010166d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101670:	e8 4a f8 ff ff       	call   c0100ebf <cga_init>
    serial_init();
c0101675:	e8 2d f9 ff ff       	call   c0100fa7 <serial_init>
    kbd_init();
c010167a:	e8 cf ff ff ff       	call   c010164e <kbd_init>
    if (!serial_exists) {
c010167f:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101684:	85 c0                	test   %eax,%eax
c0101686:	75 0c                	jne    c0101694 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101688:	c7 04 24 f3 62 10 c0 	movl   $0xc01062f3,(%esp)
c010168f:	e8 d1 ec ff ff       	call   c0100365 <cprintf>
    }
}
c0101694:	90                   	nop
c0101695:	89 ec                	mov    %ebp,%esp
c0101697:	5d                   	pop    %ebp
c0101698:	c3                   	ret    

c0101699 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101699:	55                   	push   %ebp
c010169a:	89 e5                	mov    %esp,%ebp
c010169c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010169f:	e8 8e f7 ff ff       	call   c0100e32 <__intr_save>
c01016a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016aa:	89 04 24             	mov    %eax,(%esp)
c01016ad:	e8 60 fa ff ff       	call   c0101112 <lpt_putc>
        cga_putc(c);
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	89 04 24             	mov    %eax,(%esp)
c01016b8:	e8 97 fa ff ff       	call   c0101154 <cga_putc>
        serial_putc(c);
c01016bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c0:	89 04 24             	mov    %eax,(%esp)
c01016c3:	e8 de fc ff ff       	call   c01013a6 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016cb:	89 04 24             	mov    %eax,(%esp)
c01016ce:	e8 8b f7 ff ff       	call   c0100e5e <__intr_restore>
}
c01016d3:	90                   	nop
c01016d4:	89 ec                	mov    %ebp,%esp
c01016d6:	5d                   	pop    %ebp
c01016d7:	c3                   	ret    

c01016d8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016d8:	55                   	push   %ebp
c01016d9:	89 e5                	mov    %esp,%ebp
c01016db:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e5:	e8 48 f7 ff ff       	call   c0100e32 <__intr_save>
c01016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016ed:	e8 9e fd ff ff       	call   c0101490 <serial_intr>
        kbd_intr();
c01016f2:	e8 40 ff ff ff       	call   c0101637 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016f7:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c01016fd:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101702:	39 c2                	cmp    %eax,%edx
c0101704:	74 31                	je     c0101737 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101706:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c010170b:	8d 50 01             	lea    0x1(%eax),%edx
c010170e:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101714:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010171b:	0f b6 c0             	movzbl %al,%eax
c010171e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101721:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101726:	3d 00 02 00 00       	cmp    $0x200,%eax
c010172b:	75 0a                	jne    c0101737 <cons_getc+0x5f>
                cons.rpos = 0;
c010172d:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c0101734:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101737:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010173a:	89 04 24             	mov    %eax,(%esp)
c010173d:	e8 1c f7 ff ff       	call   c0100e5e <__intr_restore>
    return c;
c0101742:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101745:	89 ec                	mov    %ebp,%esp
c0101747:	5d                   	pop    %ebp
c0101748:	c3                   	ret    

c0101749 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101749:	55                   	push   %ebp
c010174a:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010174c:	fb                   	sti    
}
c010174d:	90                   	nop
    sti();
}
c010174e:	90                   	nop
c010174f:	5d                   	pop    %ebp
c0101750:	c3                   	ret    

c0101751 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101751:	55                   	push   %ebp
c0101752:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101754:	fa                   	cli    
}
c0101755:	90                   	nop
    cli();
}
c0101756:	90                   	nop
c0101757:	5d                   	pop    %ebp
c0101758:	c3                   	ret    

c0101759 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101759:	55                   	push   %ebp
c010175a:	89 e5                	mov    %esp,%ebp
c010175c:	83 ec 14             	sub    $0x14,%esp
c010175f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101762:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101766:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101769:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c010176f:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c0101774:	85 c0                	test   %eax,%eax
c0101776:	74 39                	je     c01017b1 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101778:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010177b:	0f b6 c0             	movzbl %al,%eax
c010177e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101784:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101787:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010178b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010178f:	ee                   	out    %al,(%dx)
}
c0101790:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101791:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101795:	c1 e8 08             	shr    $0x8,%eax
c0101798:	0f b7 c0             	movzwl %ax,%eax
c010179b:	0f b6 c0             	movzbl %al,%eax
c010179e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017a4:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017ab:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
}
c01017b0:	90                   	nop
    }
}
c01017b1:	90                   	nop
c01017b2:	89 ec                	mov    %ebp,%esp
c01017b4:	5d                   	pop    %ebp
c01017b5:	c3                   	ret    

c01017b6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017b6:	55                   	push   %ebp
c01017b7:	89 e5                	mov    %esp,%ebp
c01017b9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bf:	ba 01 00 00 00       	mov    $0x1,%edx
c01017c4:	88 c1                	mov    %al,%cl
c01017c6:	d3 e2                	shl    %cl,%edx
c01017c8:	89 d0                	mov    %edx,%eax
c01017ca:	98                   	cwtl   
c01017cb:	f7 d0                	not    %eax
c01017cd:	0f bf d0             	movswl %ax,%edx
c01017d0:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01017d7:	98                   	cwtl   
c01017d8:	21 d0                	and    %edx,%eax
c01017da:	98                   	cwtl   
c01017db:	0f b7 c0             	movzwl %ax,%eax
c01017de:	89 04 24             	mov    %eax,(%esp)
c01017e1:	e8 73 ff ff ff       	call   c0101759 <pic_setmask>
}
c01017e6:	90                   	nop
c01017e7:	89 ec                	mov    %ebp,%esp
c01017e9:	5d                   	pop    %ebp
c01017ea:	c3                   	ret    

c01017eb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017eb:	55                   	push   %ebp
c01017ec:	89 e5                	mov    %esp,%ebp
c01017ee:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017f1:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c01017f8:	00 00 00 
c01017fb:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101801:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101805:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101809:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010180d:	ee                   	out    %al,(%dx)
}
c010180e:	90                   	nop
c010180f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101815:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101819:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010181d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101821:	ee                   	out    %al,(%dx)
}
c0101822:	90                   	nop
c0101823:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101829:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010182d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101831:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101835:	ee                   	out    %al,(%dx)
}
c0101836:	90                   	nop
c0101837:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010183d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101841:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101845:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101849:	ee                   	out    %al,(%dx)
}
c010184a:	90                   	nop
c010184b:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101851:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101855:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101859:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010185d:	ee                   	out    %al,(%dx)
}
c010185e:	90                   	nop
c010185f:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101865:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101869:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010186d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101871:	ee                   	out    %al,(%dx)
}
c0101872:	90                   	nop
c0101873:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101879:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010187d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101881:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101885:	ee                   	out    %al,(%dx)
}
c0101886:	90                   	nop
c0101887:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c010188d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101891:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101895:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101899:	ee                   	out    %al,(%dx)
}
c010189a:	90                   	nop
c010189b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018a1:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018a9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018ad:	ee                   	out    %al,(%dx)
}
c01018ae:	90                   	nop
c01018af:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018b5:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018bd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018c1:	ee                   	out    %al,(%dx)
}
c01018c2:	90                   	nop
c01018c3:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018c9:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018cd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018d1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018d5:	ee                   	out    %al,(%dx)
}
c01018d6:	90                   	nop
c01018d7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018dd:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018e5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018e9:	ee                   	out    %al,(%dx)
}
c01018ea:	90                   	nop
c01018eb:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018f1:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018f9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018fd:	ee                   	out    %al,(%dx)
}
c01018fe:	90                   	nop
c01018ff:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101905:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101909:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010190d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101911:	ee                   	out    %al,(%dx)
}
c0101912:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101913:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c010191a:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010191f:	74 0f                	je     c0101930 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101921:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101928:	89 04 24             	mov    %eax,(%esp)
c010192b:	e8 29 fe ff ff       	call   c0101759 <pic_setmask>
    }
}
c0101930:	90                   	nop
c0101931:	89 ec                	mov    %ebp,%esp
c0101933:	5d                   	pop    %ebp
c0101934:	c3                   	ret    

c0101935 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
c0101935:	55                   	push   %ebp
c0101936:	89 e5                	mov    %esp,%ebp
c0101938:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
c010193b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101942:	00 
c0101943:	c7 04 24 20 63 10 c0 	movl   $0xc0106320,(%esp)
c010194a:	e8 16 ea ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010194f:	c7 04 24 2a 63 10 c0 	movl   $0xc010632a,(%esp)
c0101956:	e8 0a ea ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c010195b:	c7 44 24 08 38 63 10 	movl   $0xc0106338,0x8(%esp)
c0101962:	c0 
c0101963:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
c010196a:	00 
c010196b:	c7 04 24 4e 63 10 c0 	movl   $0xc010634e,(%esp)
c0101972:	e8 81 f3 ff ff       	call   c0100cf8 <__panic>

c0101977 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
c0101977:	55                   	push   %ebp
c0101978:	89 e5                	mov    %esp,%ebp
c010197a:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; i++)
c010197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101984:	e9 c4 00 00 00       	jmp    c0101a4d <idt_init+0xd6>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198c:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101993:	0f b7 d0             	movzwl %ax,%edx
c0101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101999:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c01019a0:	c0 
c01019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a4:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c01019ab:	c0 08 00 
c01019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b1:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019b8:	c0 
c01019b9:	80 e2 e0             	and    $0xe0,%dl
c01019bc:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c6:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019cd:	c0 
c01019ce:	80 e2 1f             	and    $0x1f,%dl
c01019d1:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019db:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019e2:	c0 
c01019e3:	80 e2 f0             	and    $0xf0,%dl
c01019e6:	80 ca 0e             	or     $0xe,%dl
c01019e9:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f3:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019fa:	c0 
c01019fb:	80 e2 ef             	and    $0xef,%dl
c01019fe:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a08:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101a0f:	c0 
c0101a10:	80 e2 9f             	and    $0x9f,%dl
c0101a13:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1d:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101a24:	c0 
c0101a25:	80 ca 80             	or     $0x80,%dl
c0101a28:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101a39:	c1 e8 10             	shr    $0x10,%eax
c0101a3c:	0f b7 d0             	movzwl %ax,%edx
c0101a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a42:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c0101a49:	c0 
    for (int i = 0; i < 256; i++)
c0101a4a:	ff 45 fc             	incl   -0x4(%ebp)
c0101a4d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a54:	0f 8e 2f ff ff ff    	jle    c0101989 <idt_init+0x12>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a5a:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101a5f:	0f b7 c0             	movzwl %ax,%eax
c0101a62:	66 a3 48 ba 11 c0    	mov    %ax,0xc011ba48
c0101a68:	66 c7 05 4a ba 11 c0 	movw   $0x8,0xc011ba4a
c0101a6f:	08 00 
c0101a71:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a78:	24 e0                	and    $0xe0,%al
c0101a7a:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a7f:	0f b6 05 4c ba 11 c0 	movzbl 0xc011ba4c,%eax
c0101a86:	24 1f                	and    $0x1f,%al
c0101a88:	a2 4c ba 11 c0       	mov    %al,0xc011ba4c
c0101a8d:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101a94:	24 f0                	and    $0xf0,%al
c0101a96:	0c 0e                	or     $0xe,%al
c0101a98:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101a9d:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101aa4:	24 ef                	and    $0xef,%al
c0101aa6:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101aab:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101ab2:	0c 60                	or     $0x60,%al
c0101ab4:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101ab9:	0f b6 05 4d ba 11 c0 	movzbl 0xc011ba4d,%eax
c0101ac0:	0c 80                	or     $0x80,%al
c0101ac2:	a2 4d ba 11 c0       	mov    %al,0xc011ba4d
c0101ac7:	a1 c4 87 11 c0       	mov    0xc01187c4,%eax
c0101acc:	c1 e8 10             	shr    $0x10,%eax
c0101acf:	0f b7 c0             	movzwl %ax,%eax
c0101ad2:	66 a3 4e ba 11 c0    	mov    %ax,0xc011ba4e
c0101ad8:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ae2:	0f 01 18             	lidtl  (%eax)
}
c0101ae5:	90                   	nop
    lidt(&idt_pd);
}
c0101ae6:	90                   	nop
c0101ae7:	89 ec                	mov    %ebp,%esp
c0101ae9:	5d                   	pop    %ebp
c0101aea:	c3                   	ret    

c0101aeb <trapname>:

static const char *
trapname(int trapno)
{
c0101aeb:	55                   	push   %ebp
c0101aec:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
c0101aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af1:	83 f8 13             	cmp    $0x13,%eax
c0101af4:	77 0c                	ja     c0101b02 <trapname+0x17>
    {
        return excnames[trapno];
c0101af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af9:	8b 04 85 a0 66 10 c0 	mov    -0x3fef9960(,%eax,4),%eax
c0101b00:	eb 18                	jmp    c0101b1a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
c0101b02:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b06:	7e 0d                	jle    c0101b15 <trapname+0x2a>
c0101b08:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b0c:	7f 07                	jg     c0101b15 <trapname+0x2a>
    {
        return "Hardware Interrupt";
c0101b0e:	b8 5f 63 10 c0       	mov    $0xc010635f,%eax
c0101b13:	eb 05                	jmp    c0101b1a <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b15:	b8 72 63 10 c0       	mov    $0xc0106372,%eax
}
c0101b1a:	5d                   	pop    %ebp
c0101b1b:	c3                   	ret    

c0101b1c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
c0101b1c:	55                   	push   %ebp
c0101b1d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b22:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b26:	83 f8 08             	cmp    $0x8,%eax
c0101b29:	0f 94 c0             	sete   %al
c0101b2c:	0f b6 c0             	movzbl %al,%eax
}
c0101b2f:	5d                   	pop    %ebp
c0101b30:	c3                   	ret    

c0101b31 <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
c0101b31:	55                   	push   %ebp
c0101b32:	89 e5                	mov    %esp,%ebp
c0101b34:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3e:	c7 04 24 b3 63 10 c0 	movl   $0xc01063b3,(%esp)
c0101b45:	e8 1b e8 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4d:	89 04 24             	mov    %eax,(%esp)
c0101b50:	e8 8f 01 00 00       	call   c0101ce4 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b58:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b60:	c7 04 24 c4 63 10 c0 	movl   $0xc01063c4,(%esp)
c0101b67:	e8 f9 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b77:	c7 04 24 d7 63 10 c0 	movl   $0xc01063d7,(%esp)
c0101b7e:	e8 e2 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b86:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8e:	c7 04 24 ea 63 10 c0 	movl   $0xc01063ea,(%esp)
c0101b95:	e8 cb e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba5:	c7 04 24 fd 63 10 c0 	movl   $0xc01063fd,(%esp)
c0101bac:	e8 b4 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb4:	8b 40 30             	mov    0x30(%eax),%eax
c0101bb7:	89 04 24             	mov    %eax,(%esp)
c0101bba:	e8 2c ff ff ff       	call   c0101aeb <trapname>
c0101bbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bc2:	8b 52 30             	mov    0x30(%edx),%edx
c0101bc5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bc9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101bcd:	c7 04 24 10 64 10 c0 	movl   $0xc0106410,(%esp)
c0101bd4:	e8 8c e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdc:	8b 40 34             	mov    0x34(%eax),%eax
c0101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be3:	c7 04 24 22 64 10 c0 	movl   $0xc0106422,(%esp)
c0101bea:	e8 76 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf2:	8b 40 38             	mov    0x38(%eax),%eax
c0101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf9:	c7 04 24 31 64 10 c0 	movl   $0xc0106431,(%esp)
c0101c00:	e8 60 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c10:	c7 04 24 40 64 10 c0 	movl   $0xc0106440,(%esp)
c0101c17:	e8 49 e7 ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	8b 40 40             	mov    0x40(%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 53 64 10 c0 	movl   $0xc0106453,(%esp)
c0101c2d:	e8 33 e7 ff ff       	call   c0100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c39:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c40:	eb 3d                	jmp    c0101c7f <print_trapframe+0x14e>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
c0101c42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c45:	8b 50 40             	mov    0x40(%eax),%edx
c0101c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c4b:	21 d0                	and    %edx,%eax
c0101c4d:	85 c0                	test   %eax,%eax
c0101c4f:	74 28                	je     c0101c79 <print_trapframe+0x148>
c0101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c54:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c5b:	85 c0                	test   %eax,%eax
c0101c5d:	74 1a                	je     c0101c79 <print_trapframe+0x148>
        {
            cprintf("%s,", IA32flags[i]);
c0101c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c62:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101c69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6d:	c7 04 24 62 64 10 c0 	movl   $0xc0106462,(%esp)
c0101c74:	e8 ec e6 ff ff       	call   c0100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
c0101c79:	ff 45 f4             	incl   -0xc(%ebp)
c0101c7c:	d1 65 f0             	shll   -0x10(%ebp)
c0101c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c82:	83 f8 17             	cmp    $0x17,%eax
c0101c85:	76 bb                	jbe    c0101c42 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8a:	8b 40 40             	mov    0x40(%eax),%eax
c0101c8d:	c1 e8 0c             	shr    $0xc,%eax
c0101c90:	83 e0 03             	and    $0x3,%eax
c0101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c97:	c7 04 24 66 64 10 c0 	movl   $0xc0106466,(%esp)
c0101c9e:	e8 c2 e6 ff ff       	call   c0100365 <cprintf>

    if (!trap_in_kernel(tf))
c0101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca6:	89 04 24             	mov    %eax,(%esp)
c0101ca9:	e8 6e fe ff ff       	call   c0101b1c <trap_in_kernel>
c0101cae:	85 c0                	test   %eax,%eax
c0101cb0:	75 2d                	jne    c0101cdf <print_trapframe+0x1ae>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb5:	8b 40 44             	mov    0x44(%eax),%eax
c0101cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbc:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c0101cc3:	e8 9d e6 ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ccb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd3:	c7 04 24 7e 64 10 c0 	movl   $0xc010647e,(%esp)
c0101cda:	e8 86 e6 ff ff       	call   c0100365 <cprintf>
    }
}
c0101cdf:	90                   	nop
c0101ce0:	89 ec                	mov    %ebp,%esp
c0101ce2:	5d                   	pop    %ebp
c0101ce3:	c3                   	ret    

c0101ce4 <print_regs>:

void print_regs(struct pushregs *regs)
{
c0101ce4:	55                   	push   %ebp
c0101ce5:	89 e5                	mov    %esp,%ebp
c0101ce7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ced:	8b 00                	mov    (%eax),%eax
c0101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf3:	c7 04 24 91 64 10 c0 	movl   $0xc0106491,(%esp)
c0101cfa:	e8 66 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d02:	8b 40 04             	mov    0x4(%eax),%eax
c0101d05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d09:	c7 04 24 a0 64 10 c0 	movl   $0xc01064a0,(%esp)
c0101d10:	e8 50 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d18:	8b 40 08             	mov    0x8(%eax),%eax
c0101d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1f:	c7 04 24 af 64 10 c0 	movl   $0xc01064af,(%esp)
c0101d26:	e8 3a e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2e:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d35:	c7 04 24 be 64 10 c0 	movl   $0xc01064be,(%esp)
c0101d3c:	e8 24 e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d44:	8b 40 10             	mov    0x10(%eax),%eax
c0101d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d4b:	c7 04 24 cd 64 10 c0 	movl   $0xc01064cd,(%esp)
c0101d52:	e8 0e e6 ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5a:	8b 40 14             	mov    0x14(%eax),%eax
c0101d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d61:	c7 04 24 dc 64 10 c0 	movl   $0xc01064dc,(%esp)
c0101d68:	e8 f8 e5 ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d70:	8b 40 18             	mov    0x18(%eax),%eax
c0101d73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d77:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0101d7e:	e8 e2 e5 ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d86:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8d:	c7 04 24 fa 64 10 c0 	movl   $0xc01064fa,(%esp)
c0101d94:	e8 cc e5 ff ff       	call   c0100365 <cprintf>
}
c0101d99:	90                   	nop
c0101d9a:	89 ec                	mov    %ebp,%esp
c0101d9c:	5d                   	pop    %ebp
c0101d9d:	c3                   	ret    

c0101d9e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf)
{
c0101d9e:	55                   	push   %ebp
c0101d9f:	89 e5                	mov    %esp,%ebp
c0101da1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
c0101da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da7:	8b 40 30             	mov    0x30(%eax),%eax
c0101daa:	83 f8 79             	cmp    $0x79,%eax
c0101dad:	0f 84 1f 01 00 00    	je     c0101ed2 <trap_dispatch+0x134>
c0101db3:	83 f8 79             	cmp    $0x79,%eax
c0101db6:	0f 87 69 01 00 00    	ja     c0101f25 <trap_dispatch+0x187>
c0101dbc:	83 f8 78             	cmp    $0x78,%eax
c0101dbf:	0f 84 b7 00 00 00    	je     c0101e7c <trap_dispatch+0xde>
c0101dc5:	83 f8 78             	cmp    $0x78,%eax
c0101dc8:	0f 87 57 01 00 00    	ja     c0101f25 <trap_dispatch+0x187>
c0101dce:	83 f8 2f             	cmp    $0x2f,%eax
c0101dd1:	0f 87 4e 01 00 00    	ja     c0101f25 <trap_dispatch+0x187>
c0101dd7:	83 f8 2e             	cmp    $0x2e,%eax
c0101dda:	0f 83 7a 01 00 00    	jae    c0101f5a <trap_dispatch+0x1bc>
c0101de0:	83 f8 24             	cmp    $0x24,%eax
c0101de3:	74 45                	je     c0101e2a <trap_dispatch+0x8c>
c0101de5:	83 f8 24             	cmp    $0x24,%eax
c0101de8:	0f 87 37 01 00 00    	ja     c0101f25 <trap_dispatch+0x187>
c0101dee:	83 f8 20             	cmp    $0x20,%eax
c0101df1:	74 0a                	je     c0101dfd <trap_dispatch+0x5f>
c0101df3:	83 f8 21             	cmp    $0x21,%eax
c0101df6:	74 5b                	je     c0101e53 <trap_dispatch+0xb5>
c0101df8:	e9 28 01 00 00       	jmp    c0101f25 <trap_dispatch+0x187>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101dfd:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101e02:	40                   	inc    %eax
c0101e03:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks == TICK_NUM)
c0101e08:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101e0d:	83 f8 64             	cmp    $0x64,%eax
c0101e10:	0f 85 47 01 00 00    	jne    c0101f5d <trap_dispatch+0x1bf>
        {
            ticks = 0;
c0101e16:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0101e1d:	00 00 00 
            print_ticks();
c0101e20:	e8 10 fb ff ff       	call   c0101935 <print_ticks>
        }
        break;
c0101e25:	e9 33 01 00 00       	jmp    c0101f5d <trap_dispatch+0x1bf>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e2a:	e8 a9 f8 ff ff       	call   c01016d8 <cons_getc>
c0101e2f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e32:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e36:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e3a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e42:	c7 04 24 09 65 10 c0 	movl   $0xc0106509,(%esp)
c0101e49:	e8 17 e5 ff ff       	call   c0100365 <cprintf>
        break;
c0101e4e:	e9 11 01 00 00       	jmp    c0101f64 <trap_dispatch+0x1c6>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e53:	e8 80 f8 ff ff       	call   c01016d8 <cons_getc>
c0101e58:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e5b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e5f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e63:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e6b:	c7 04 24 1b 65 10 c0 	movl   $0xc010651b,(%esp)
c0101e72:	e8 ee e4 ff ff       	call   c0100365 <cprintf>
        break;
c0101e77:	e9 e8 00 00 00       	jmp    c0101f64 <trap_dispatch+0x1c6>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS)
c0101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e83:	83 f8 1b             	cmp    $0x1b,%eax
c0101e86:	0f 84 d4 00 00 00    	je     c0101f60 <trap_dispatch+0x1c2>
        {
            tf->tf_cs = USER_CS;
c0101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101e95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e98:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea8:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101eac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaf:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb6:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
c0101eba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebd:	8b 40 40             	mov    0x40(%eax),%eax
c0101ec0:	0d 00 30 00 00       	or     $0x3000,%eax
c0101ec5:	89 c2                	mov    %eax,%edx
c0101ec7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eca:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101ecd:	e9 8e 00 00 00       	jmp    c0101f60 <trap_dispatch+0x1c2>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS)
c0101ed2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ed9:	83 f8 08             	cmp    $0x8,%eax
c0101edc:	0f 84 81 00 00 00    	je     c0101f63 <trap_dispatch+0x1c5>
        {
            tf->tf_cs = KERNEL_CS;
c0101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee5:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = KERNEL_DS;
c0101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eee:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
c0101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efe:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f05:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f13:	8b 40 40             	mov    0x40(%eax),%eax
c0101f16:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f1b:	89 c2                	mov    %eax,%edx
c0101f1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f20:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0101f23:	eb 3e                	jmp    c0101f63 <trap_dispatch+0x1c5>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
c0101f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f2c:	83 e0 03             	and    $0x3,%eax
c0101f2f:	85 c0                	test   %eax,%eax
c0101f31:	75 31                	jne    c0101f64 <trap_dispatch+0x1c6>
        {
            print_trapframe(tf);
c0101f33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f36:	89 04 24             	mov    %eax,(%esp)
c0101f39:	e8 f3 fb ff ff       	call   c0101b31 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f3e:	c7 44 24 08 2a 65 10 	movl   $0xc010652a,0x8(%esp)
c0101f45:	c0 
c0101f46:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0101f4d:	00 
c0101f4e:	c7 04 24 4e 63 10 c0 	movl   $0xc010634e,(%esp)
c0101f55:	e8 9e ed ff ff       	call   c0100cf8 <__panic>
        break;
c0101f5a:	90                   	nop
c0101f5b:	eb 07                	jmp    c0101f64 <trap_dispatch+0x1c6>
        break;
c0101f5d:	90                   	nop
c0101f5e:	eb 04                	jmp    c0101f64 <trap_dispatch+0x1c6>
        break;
c0101f60:	90                   	nop
c0101f61:	eb 01                	jmp    c0101f64 <trap_dispatch+0x1c6>
        break;
c0101f63:	90                   	nop
        }
    }
}
c0101f64:	90                   	nop
c0101f65:	89 ec                	mov    %ebp,%esp
c0101f67:	5d                   	pop    %ebp
c0101f68:	c3                   	ret    

c0101f69 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
c0101f69:	55                   	push   %ebp
c0101f6a:	89 e5                	mov    %esp,%ebp
c0101f6c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f72:	89 04 24             	mov    %eax,(%esp)
c0101f75:	e8 24 fe ff ff       	call   c0101d9e <trap_dispatch>
}
c0101f7a:	90                   	nop
c0101f7b:	89 ec                	mov    %ebp,%esp
c0101f7d:	5d                   	pop    %ebp
c0101f7e:	c3                   	ret    

c0101f7f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101f7f:	1e                   	push   %ds
    pushl %es
c0101f80:	06                   	push   %es
    pushl %fs
c0101f81:	0f a0                	push   %fs
    pushl %gs
c0101f83:	0f a8                	push   %gs
    pushal
c0101f85:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101f86:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f8b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f8d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f8f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f90:	e8 d4 ff ff ff       	call   c0101f69 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f95:	5c                   	pop    %esp

c0101f96 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f96:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f97:	0f a9                	pop    %gs
    popl %fs
c0101f99:	0f a1                	pop    %fs
    popl %es
c0101f9b:	07                   	pop    %es
    popl %ds
c0101f9c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f9d:	83 c4 08             	add    $0x8,%esp
    iret
c0101fa0:	cf                   	iret   

c0101fa1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  jmp __alltraps
c0101fa5:	e9 d5 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101faa <vector1>:
.globl vector1
vector1:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $1
c0101fac:	6a 01                	push   $0x1
  jmp __alltraps
c0101fae:	e9 cc ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fb3 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $2
c0101fb5:	6a 02                	push   $0x2
  jmp __alltraps
c0101fb7:	e9 c3 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fbc <vector3>:
.globl vector3
vector3:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $3
c0101fbe:	6a 03                	push   $0x3
  jmp __alltraps
c0101fc0:	e9 ba ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fc5 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $4
c0101fc7:	6a 04                	push   $0x4
  jmp __alltraps
c0101fc9:	e9 b1 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fce <vector5>:
.globl vector5
vector5:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $5
c0101fd0:	6a 05                	push   $0x5
  jmp __alltraps
c0101fd2:	e9 a8 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fd7 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $6
c0101fd9:	6a 06                	push   $0x6
  jmp __alltraps
c0101fdb:	e9 9f ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fe0 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $7
c0101fe2:	6a 07                	push   $0x7
  jmp __alltraps
c0101fe4:	e9 96 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101fe9 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fe9:	6a 08                	push   $0x8
  jmp __alltraps
c0101feb:	e9 8f ff ff ff       	jmp    c0101f7f <__alltraps>

c0101ff0 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $9
c0101ff2:	6a 09                	push   $0x9
  jmp __alltraps
c0101ff4:	e9 86 ff ff ff       	jmp    c0101f7f <__alltraps>

c0101ff9 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ff9:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ffb:	e9 7f ff ff ff       	jmp    c0101f7f <__alltraps>

c0102000 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102000:	6a 0b                	push   $0xb
  jmp __alltraps
c0102002:	e9 78 ff ff ff       	jmp    c0101f7f <__alltraps>

c0102007 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102007:	6a 0c                	push   $0xc
  jmp __alltraps
c0102009:	e9 71 ff ff ff       	jmp    c0101f7f <__alltraps>

c010200e <vector13>:
.globl vector13
vector13:
  pushl $13
c010200e:	6a 0d                	push   $0xd
  jmp __alltraps
c0102010:	e9 6a ff ff ff       	jmp    c0101f7f <__alltraps>

c0102015 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102015:	6a 0e                	push   $0xe
  jmp __alltraps
c0102017:	e9 63 ff ff ff       	jmp    c0101f7f <__alltraps>

c010201c <vector15>:
.globl vector15
vector15:
  pushl $0
c010201c:	6a 00                	push   $0x0
  pushl $15
c010201e:	6a 0f                	push   $0xf
  jmp __alltraps
c0102020:	e9 5a ff ff ff       	jmp    c0101f7f <__alltraps>

c0102025 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102025:	6a 00                	push   $0x0
  pushl $16
c0102027:	6a 10                	push   $0x10
  jmp __alltraps
c0102029:	e9 51 ff ff ff       	jmp    c0101f7f <__alltraps>

c010202e <vector17>:
.globl vector17
vector17:
  pushl $17
c010202e:	6a 11                	push   $0x11
  jmp __alltraps
c0102030:	e9 4a ff ff ff       	jmp    c0101f7f <__alltraps>

c0102035 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $18
c0102037:	6a 12                	push   $0x12
  jmp __alltraps
c0102039:	e9 41 ff ff ff       	jmp    c0101f7f <__alltraps>

c010203e <vector19>:
.globl vector19
vector19:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $19
c0102040:	6a 13                	push   $0x13
  jmp __alltraps
c0102042:	e9 38 ff ff ff       	jmp    c0101f7f <__alltraps>

c0102047 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $20
c0102049:	6a 14                	push   $0x14
  jmp __alltraps
c010204b:	e9 2f ff ff ff       	jmp    c0101f7f <__alltraps>

c0102050 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $21
c0102052:	6a 15                	push   $0x15
  jmp __alltraps
c0102054:	e9 26 ff ff ff       	jmp    c0101f7f <__alltraps>

c0102059 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $22
c010205b:	6a 16                	push   $0x16
  jmp __alltraps
c010205d:	e9 1d ff ff ff       	jmp    c0101f7f <__alltraps>

c0102062 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $23
c0102064:	6a 17                	push   $0x17
  jmp __alltraps
c0102066:	e9 14 ff ff ff       	jmp    c0101f7f <__alltraps>

c010206b <vector24>:
.globl vector24
vector24:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $24
c010206d:	6a 18                	push   $0x18
  jmp __alltraps
c010206f:	e9 0b ff ff ff       	jmp    c0101f7f <__alltraps>

c0102074 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $25
c0102076:	6a 19                	push   $0x19
  jmp __alltraps
c0102078:	e9 02 ff ff ff       	jmp    c0101f7f <__alltraps>

c010207d <vector26>:
.globl vector26
vector26:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $26
c010207f:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102081:	e9 f9 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102086 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $27
c0102088:	6a 1b                	push   $0x1b
  jmp __alltraps
c010208a:	e9 f0 fe ff ff       	jmp    c0101f7f <__alltraps>

c010208f <vector28>:
.globl vector28
vector28:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $28
c0102091:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102093:	e9 e7 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102098 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $29
c010209a:	6a 1d                	push   $0x1d
  jmp __alltraps
c010209c:	e9 de fe ff ff       	jmp    c0101f7f <__alltraps>

c01020a1 <vector30>:
.globl vector30
vector30:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $30
c01020a3:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020a5:	e9 d5 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020aa <vector31>:
.globl vector31
vector31:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $31
c01020ac:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020ae:	e9 cc fe ff ff       	jmp    c0101f7f <__alltraps>

c01020b3 <vector32>:
.globl vector32
vector32:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $32
c01020b5:	6a 20                	push   $0x20
  jmp __alltraps
c01020b7:	e9 c3 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020bc <vector33>:
.globl vector33
vector33:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $33
c01020be:	6a 21                	push   $0x21
  jmp __alltraps
c01020c0:	e9 ba fe ff ff       	jmp    c0101f7f <__alltraps>

c01020c5 <vector34>:
.globl vector34
vector34:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $34
c01020c7:	6a 22                	push   $0x22
  jmp __alltraps
c01020c9:	e9 b1 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020ce <vector35>:
.globl vector35
vector35:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $35
c01020d0:	6a 23                	push   $0x23
  jmp __alltraps
c01020d2:	e9 a8 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020d7 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $36
c01020d9:	6a 24                	push   $0x24
  jmp __alltraps
c01020db:	e9 9f fe ff ff       	jmp    c0101f7f <__alltraps>

c01020e0 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $37
c01020e2:	6a 25                	push   $0x25
  jmp __alltraps
c01020e4:	e9 96 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020e9 <vector38>:
.globl vector38
vector38:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $38
c01020eb:	6a 26                	push   $0x26
  jmp __alltraps
c01020ed:	e9 8d fe ff ff       	jmp    c0101f7f <__alltraps>

c01020f2 <vector39>:
.globl vector39
vector39:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $39
c01020f4:	6a 27                	push   $0x27
  jmp __alltraps
c01020f6:	e9 84 fe ff ff       	jmp    c0101f7f <__alltraps>

c01020fb <vector40>:
.globl vector40
vector40:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $40
c01020fd:	6a 28                	push   $0x28
  jmp __alltraps
c01020ff:	e9 7b fe ff ff       	jmp    c0101f7f <__alltraps>

c0102104 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $41
c0102106:	6a 29                	push   $0x29
  jmp __alltraps
c0102108:	e9 72 fe ff ff       	jmp    c0101f7f <__alltraps>

c010210d <vector42>:
.globl vector42
vector42:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $42
c010210f:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102111:	e9 69 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102116 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $43
c0102118:	6a 2b                	push   $0x2b
  jmp __alltraps
c010211a:	e9 60 fe ff ff       	jmp    c0101f7f <__alltraps>

c010211f <vector44>:
.globl vector44
vector44:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $44
c0102121:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102123:	e9 57 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102128 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $45
c010212a:	6a 2d                	push   $0x2d
  jmp __alltraps
c010212c:	e9 4e fe ff ff       	jmp    c0101f7f <__alltraps>

c0102131 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $46
c0102133:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102135:	e9 45 fe ff ff       	jmp    c0101f7f <__alltraps>

c010213a <vector47>:
.globl vector47
vector47:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $47
c010213c:	6a 2f                	push   $0x2f
  jmp __alltraps
c010213e:	e9 3c fe ff ff       	jmp    c0101f7f <__alltraps>

c0102143 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $48
c0102145:	6a 30                	push   $0x30
  jmp __alltraps
c0102147:	e9 33 fe ff ff       	jmp    c0101f7f <__alltraps>

c010214c <vector49>:
.globl vector49
vector49:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $49
c010214e:	6a 31                	push   $0x31
  jmp __alltraps
c0102150:	e9 2a fe ff ff       	jmp    c0101f7f <__alltraps>

c0102155 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $50
c0102157:	6a 32                	push   $0x32
  jmp __alltraps
c0102159:	e9 21 fe ff ff       	jmp    c0101f7f <__alltraps>

c010215e <vector51>:
.globl vector51
vector51:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $51
c0102160:	6a 33                	push   $0x33
  jmp __alltraps
c0102162:	e9 18 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102167 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $52
c0102169:	6a 34                	push   $0x34
  jmp __alltraps
c010216b:	e9 0f fe ff ff       	jmp    c0101f7f <__alltraps>

c0102170 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $53
c0102172:	6a 35                	push   $0x35
  jmp __alltraps
c0102174:	e9 06 fe ff ff       	jmp    c0101f7f <__alltraps>

c0102179 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $54
c010217b:	6a 36                	push   $0x36
  jmp __alltraps
c010217d:	e9 fd fd ff ff       	jmp    c0101f7f <__alltraps>

c0102182 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $55
c0102184:	6a 37                	push   $0x37
  jmp __alltraps
c0102186:	e9 f4 fd ff ff       	jmp    c0101f7f <__alltraps>

c010218b <vector56>:
.globl vector56
vector56:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $56
c010218d:	6a 38                	push   $0x38
  jmp __alltraps
c010218f:	e9 eb fd ff ff       	jmp    c0101f7f <__alltraps>

c0102194 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $57
c0102196:	6a 39                	push   $0x39
  jmp __alltraps
c0102198:	e9 e2 fd ff ff       	jmp    c0101f7f <__alltraps>

c010219d <vector58>:
.globl vector58
vector58:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $58
c010219f:	6a 3a                	push   $0x3a
  jmp __alltraps
c01021a1:	e9 d9 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021a6 <vector59>:
.globl vector59
vector59:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $59
c01021a8:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021aa:	e9 d0 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021af <vector60>:
.globl vector60
vector60:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $60
c01021b1:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021b3:	e9 c7 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021b8 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $61
c01021ba:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021bc:	e9 be fd ff ff       	jmp    c0101f7f <__alltraps>

c01021c1 <vector62>:
.globl vector62
vector62:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $62
c01021c3:	6a 3e                	push   $0x3e
  jmp __alltraps
c01021c5:	e9 b5 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021ca <vector63>:
.globl vector63
vector63:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $63
c01021cc:	6a 3f                	push   $0x3f
  jmp __alltraps
c01021ce:	e9 ac fd ff ff       	jmp    c0101f7f <__alltraps>

c01021d3 <vector64>:
.globl vector64
vector64:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $64
c01021d5:	6a 40                	push   $0x40
  jmp __alltraps
c01021d7:	e9 a3 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021dc <vector65>:
.globl vector65
vector65:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $65
c01021de:	6a 41                	push   $0x41
  jmp __alltraps
c01021e0:	e9 9a fd ff ff       	jmp    c0101f7f <__alltraps>

c01021e5 <vector66>:
.globl vector66
vector66:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $66
c01021e7:	6a 42                	push   $0x42
  jmp __alltraps
c01021e9:	e9 91 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021ee <vector67>:
.globl vector67
vector67:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $67
c01021f0:	6a 43                	push   $0x43
  jmp __alltraps
c01021f2:	e9 88 fd ff ff       	jmp    c0101f7f <__alltraps>

c01021f7 <vector68>:
.globl vector68
vector68:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $68
c01021f9:	6a 44                	push   $0x44
  jmp __alltraps
c01021fb:	e9 7f fd ff ff       	jmp    c0101f7f <__alltraps>

c0102200 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $69
c0102202:	6a 45                	push   $0x45
  jmp __alltraps
c0102204:	e9 76 fd ff ff       	jmp    c0101f7f <__alltraps>

c0102209 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $70
c010220b:	6a 46                	push   $0x46
  jmp __alltraps
c010220d:	e9 6d fd ff ff       	jmp    c0101f7f <__alltraps>

c0102212 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $71
c0102214:	6a 47                	push   $0x47
  jmp __alltraps
c0102216:	e9 64 fd ff ff       	jmp    c0101f7f <__alltraps>

c010221b <vector72>:
.globl vector72
vector72:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $72
c010221d:	6a 48                	push   $0x48
  jmp __alltraps
c010221f:	e9 5b fd ff ff       	jmp    c0101f7f <__alltraps>

c0102224 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $73
c0102226:	6a 49                	push   $0x49
  jmp __alltraps
c0102228:	e9 52 fd ff ff       	jmp    c0101f7f <__alltraps>

c010222d <vector74>:
.globl vector74
vector74:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $74
c010222f:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102231:	e9 49 fd ff ff       	jmp    c0101f7f <__alltraps>

c0102236 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $75
c0102238:	6a 4b                	push   $0x4b
  jmp __alltraps
c010223a:	e9 40 fd ff ff       	jmp    c0101f7f <__alltraps>

c010223f <vector76>:
.globl vector76
vector76:
  pushl $0
c010223f:	6a 00                	push   $0x0
  pushl $76
c0102241:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102243:	e9 37 fd ff ff       	jmp    c0101f7f <__alltraps>

c0102248 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $77
c010224a:	6a 4d                	push   $0x4d
  jmp __alltraps
c010224c:	e9 2e fd ff ff       	jmp    c0101f7f <__alltraps>

c0102251 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $78
c0102253:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102255:	e9 25 fd ff ff       	jmp    c0101f7f <__alltraps>

c010225a <vector79>:
.globl vector79
vector79:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $79
c010225c:	6a 4f                	push   $0x4f
  jmp __alltraps
c010225e:	e9 1c fd ff ff       	jmp    c0101f7f <__alltraps>

c0102263 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $80
c0102265:	6a 50                	push   $0x50
  jmp __alltraps
c0102267:	e9 13 fd ff ff       	jmp    c0101f7f <__alltraps>

c010226c <vector81>:
.globl vector81
vector81:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $81
c010226e:	6a 51                	push   $0x51
  jmp __alltraps
c0102270:	e9 0a fd ff ff       	jmp    c0101f7f <__alltraps>

c0102275 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $82
c0102277:	6a 52                	push   $0x52
  jmp __alltraps
c0102279:	e9 01 fd ff ff       	jmp    c0101f7f <__alltraps>

c010227e <vector83>:
.globl vector83
vector83:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $83
c0102280:	6a 53                	push   $0x53
  jmp __alltraps
c0102282:	e9 f8 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102287 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $84
c0102289:	6a 54                	push   $0x54
  jmp __alltraps
c010228b:	e9 ef fc ff ff       	jmp    c0101f7f <__alltraps>

c0102290 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $85
c0102292:	6a 55                	push   $0x55
  jmp __alltraps
c0102294:	e9 e6 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102299 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $86
c010229b:	6a 56                	push   $0x56
  jmp __alltraps
c010229d:	e9 dd fc ff ff       	jmp    c0101f7f <__alltraps>

c01022a2 <vector87>:
.globl vector87
vector87:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $87
c01022a4:	6a 57                	push   $0x57
  jmp __alltraps
c01022a6:	e9 d4 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022ab <vector88>:
.globl vector88
vector88:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $88
c01022ad:	6a 58                	push   $0x58
  jmp __alltraps
c01022af:	e9 cb fc ff ff       	jmp    c0101f7f <__alltraps>

c01022b4 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $89
c01022b6:	6a 59                	push   $0x59
  jmp __alltraps
c01022b8:	e9 c2 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022bd <vector90>:
.globl vector90
vector90:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $90
c01022bf:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022c1:	e9 b9 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022c6 <vector91>:
.globl vector91
vector91:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $91
c01022c8:	6a 5b                	push   $0x5b
  jmp __alltraps
c01022ca:	e9 b0 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022cf <vector92>:
.globl vector92
vector92:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $92
c01022d1:	6a 5c                	push   $0x5c
  jmp __alltraps
c01022d3:	e9 a7 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022d8 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $93
c01022da:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022dc:	e9 9e fc ff ff       	jmp    c0101f7f <__alltraps>

c01022e1 <vector94>:
.globl vector94
vector94:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $94
c01022e3:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022e5:	e9 95 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022ea <vector95>:
.globl vector95
vector95:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $95
c01022ec:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022ee:	e9 8c fc ff ff       	jmp    c0101f7f <__alltraps>

c01022f3 <vector96>:
.globl vector96
vector96:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $96
c01022f5:	6a 60                	push   $0x60
  jmp __alltraps
c01022f7:	e9 83 fc ff ff       	jmp    c0101f7f <__alltraps>

c01022fc <vector97>:
.globl vector97
vector97:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $97
c01022fe:	6a 61                	push   $0x61
  jmp __alltraps
c0102300:	e9 7a fc ff ff       	jmp    c0101f7f <__alltraps>

c0102305 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $98
c0102307:	6a 62                	push   $0x62
  jmp __alltraps
c0102309:	e9 71 fc ff ff       	jmp    c0101f7f <__alltraps>

c010230e <vector99>:
.globl vector99
vector99:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $99
c0102310:	6a 63                	push   $0x63
  jmp __alltraps
c0102312:	e9 68 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102317 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $100
c0102319:	6a 64                	push   $0x64
  jmp __alltraps
c010231b:	e9 5f fc ff ff       	jmp    c0101f7f <__alltraps>

c0102320 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $101
c0102322:	6a 65                	push   $0x65
  jmp __alltraps
c0102324:	e9 56 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102329 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $102
c010232b:	6a 66                	push   $0x66
  jmp __alltraps
c010232d:	e9 4d fc ff ff       	jmp    c0101f7f <__alltraps>

c0102332 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $103
c0102334:	6a 67                	push   $0x67
  jmp __alltraps
c0102336:	e9 44 fc ff ff       	jmp    c0101f7f <__alltraps>

c010233b <vector104>:
.globl vector104
vector104:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $104
c010233d:	6a 68                	push   $0x68
  jmp __alltraps
c010233f:	e9 3b fc ff ff       	jmp    c0101f7f <__alltraps>

c0102344 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $105
c0102346:	6a 69                	push   $0x69
  jmp __alltraps
c0102348:	e9 32 fc ff ff       	jmp    c0101f7f <__alltraps>

c010234d <vector106>:
.globl vector106
vector106:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $106
c010234f:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102351:	e9 29 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102356 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $107
c0102358:	6a 6b                	push   $0x6b
  jmp __alltraps
c010235a:	e9 20 fc ff ff       	jmp    c0101f7f <__alltraps>

c010235f <vector108>:
.globl vector108
vector108:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $108
c0102361:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102363:	e9 17 fc ff ff       	jmp    c0101f7f <__alltraps>

c0102368 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $109
c010236a:	6a 6d                	push   $0x6d
  jmp __alltraps
c010236c:	e9 0e fc ff ff       	jmp    c0101f7f <__alltraps>

c0102371 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $110
c0102373:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102375:	e9 05 fc ff ff       	jmp    c0101f7f <__alltraps>

c010237a <vector111>:
.globl vector111
vector111:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $111
c010237c:	6a 6f                	push   $0x6f
  jmp __alltraps
c010237e:	e9 fc fb ff ff       	jmp    c0101f7f <__alltraps>

c0102383 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $112
c0102385:	6a 70                	push   $0x70
  jmp __alltraps
c0102387:	e9 f3 fb ff ff       	jmp    c0101f7f <__alltraps>

c010238c <vector113>:
.globl vector113
vector113:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $113
c010238e:	6a 71                	push   $0x71
  jmp __alltraps
c0102390:	e9 ea fb ff ff       	jmp    c0101f7f <__alltraps>

c0102395 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $114
c0102397:	6a 72                	push   $0x72
  jmp __alltraps
c0102399:	e9 e1 fb ff ff       	jmp    c0101f7f <__alltraps>

c010239e <vector115>:
.globl vector115
vector115:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $115
c01023a0:	6a 73                	push   $0x73
  jmp __alltraps
c01023a2:	e9 d8 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023a7 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $116
c01023a9:	6a 74                	push   $0x74
  jmp __alltraps
c01023ab:	e9 cf fb ff ff       	jmp    c0101f7f <__alltraps>

c01023b0 <vector117>:
.globl vector117
vector117:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $117
c01023b2:	6a 75                	push   $0x75
  jmp __alltraps
c01023b4:	e9 c6 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023b9 <vector118>:
.globl vector118
vector118:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $118
c01023bb:	6a 76                	push   $0x76
  jmp __alltraps
c01023bd:	e9 bd fb ff ff       	jmp    c0101f7f <__alltraps>

c01023c2 <vector119>:
.globl vector119
vector119:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $119
c01023c4:	6a 77                	push   $0x77
  jmp __alltraps
c01023c6:	e9 b4 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023cb <vector120>:
.globl vector120
vector120:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $120
c01023cd:	6a 78                	push   $0x78
  jmp __alltraps
c01023cf:	e9 ab fb ff ff       	jmp    c0101f7f <__alltraps>

c01023d4 <vector121>:
.globl vector121
vector121:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $121
c01023d6:	6a 79                	push   $0x79
  jmp __alltraps
c01023d8:	e9 a2 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023dd <vector122>:
.globl vector122
vector122:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $122
c01023df:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023e1:	e9 99 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023e6 <vector123>:
.globl vector123
vector123:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $123
c01023e8:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023ea:	e9 90 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023ef <vector124>:
.globl vector124
vector124:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $124
c01023f1:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023f3:	e9 87 fb ff ff       	jmp    c0101f7f <__alltraps>

c01023f8 <vector125>:
.globl vector125
vector125:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $125
c01023fa:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023fc:	e9 7e fb ff ff       	jmp    c0101f7f <__alltraps>

c0102401 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $126
c0102403:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102405:	e9 75 fb ff ff       	jmp    c0101f7f <__alltraps>

c010240a <vector127>:
.globl vector127
vector127:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $127
c010240c:	6a 7f                	push   $0x7f
  jmp __alltraps
c010240e:	e9 6c fb ff ff       	jmp    c0101f7f <__alltraps>

c0102413 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $128
c0102415:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010241a:	e9 60 fb ff ff       	jmp    c0101f7f <__alltraps>

c010241f <vector129>:
.globl vector129
vector129:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $129
c0102421:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102426:	e9 54 fb ff ff       	jmp    c0101f7f <__alltraps>

c010242b <vector130>:
.globl vector130
vector130:
  pushl $0
c010242b:	6a 00                	push   $0x0
  pushl $130
c010242d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102432:	e9 48 fb ff ff       	jmp    c0101f7f <__alltraps>

c0102437 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102437:	6a 00                	push   $0x0
  pushl $131
c0102439:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010243e:	e9 3c fb ff ff       	jmp    c0101f7f <__alltraps>

c0102443 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $132
c0102445:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010244a:	e9 30 fb ff ff       	jmp    c0101f7f <__alltraps>

c010244f <vector133>:
.globl vector133
vector133:
  pushl $0
c010244f:	6a 00                	push   $0x0
  pushl $133
c0102451:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102456:	e9 24 fb ff ff       	jmp    c0101f7f <__alltraps>

c010245b <vector134>:
.globl vector134
vector134:
  pushl $0
c010245b:	6a 00                	push   $0x0
  pushl $134
c010245d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102462:	e9 18 fb ff ff       	jmp    c0101f7f <__alltraps>

c0102467 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $135
c0102469:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010246e:	e9 0c fb ff ff       	jmp    c0101f7f <__alltraps>

c0102473 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102473:	6a 00                	push   $0x0
  pushl $136
c0102475:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010247a:	e9 00 fb ff ff       	jmp    c0101f7f <__alltraps>

c010247f <vector137>:
.globl vector137
vector137:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $137
c0102481:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102486:	e9 f4 fa ff ff       	jmp    c0101f7f <__alltraps>

c010248b <vector138>:
.globl vector138
vector138:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $138
c010248d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102492:	e9 e8 fa ff ff       	jmp    c0101f7f <__alltraps>

c0102497 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102497:	6a 00                	push   $0x0
  pushl $139
c0102499:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010249e:	e9 dc fa ff ff       	jmp    c0101f7f <__alltraps>

c01024a3 <vector140>:
.globl vector140
vector140:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $140
c01024a5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024aa:	e9 d0 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024af <vector141>:
.globl vector141
vector141:
  pushl $0
c01024af:	6a 00                	push   $0x0
  pushl $141
c01024b1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024b6:	e9 c4 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024bb <vector142>:
.globl vector142
vector142:
  pushl $0
c01024bb:	6a 00                	push   $0x0
  pushl $142
c01024bd:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024c2:	e9 b8 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024c7 <vector143>:
.globl vector143
vector143:
  pushl $0
c01024c7:	6a 00                	push   $0x0
  pushl $143
c01024c9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01024ce:	e9 ac fa ff ff       	jmp    c0101f7f <__alltraps>

c01024d3 <vector144>:
.globl vector144
vector144:
  pushl $0
c01024d3:	6a 00                	push   $0x0
  pushl $144
c01024d5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024da:	e9 a0 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024df <vector145>:
.globl vector145
vector145:
  pushl $0
c01024df:	6a 00                	push   $0x0
  pushl $145
c01024e1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024e6:	e9 94 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024eb <vector146>:
.globl vector146
vector146:
  pushl $0
c01024eb:	6a 00                	push   $0x0
  pushl $146
c01024ed:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024f2:	e9 88 fa ff ff       	jmp    c0101f7f <__alltraps>

c01024f7 <vector147>:
.globl vector147
vector147:
  pushl $0
c01024f7:	6a 00                	push   $0x0
  pushl $147
c01024f9:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024fe:	e9 7c fa ff ff       	jmp    c0101f7f <__alltraps>

c0102503 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102503:	6a 00                	push   $0x0
  pushl $148
c0102505:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010250a:	e9 70 fa ff ff       	jmp    c0101f7f <__alltraps>

c010250f <vector149>:
.globl vector149
vector149:
  pushl $0
c010250f:	6a 00                	push   $0x0
  pushl $149
c0102511:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102516:	e9 64 fa ff ff       	jmp    c0101f7f <__alltraps>

c010251b <vector150>:
.globl vector150
vector150:
  pushl $0
c010251b:	6a 00                	push   $0x0
  pushl $150
c010251d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102522:	e9 58 fa ff ff       	jmp    c0101f7f <__alltraps>

c0102527 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102527:	6a 00                	push   $0x0
  pushl $151
c0102529:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010252e:	e9 4c fa ff ff       	jmp    c0101f7f <__alltraps>

c0102533 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102533:	6a 00                	push   $0x0
  pushl $152
c0102535:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010253a:	e9 40 fa ff ff       	jmp    c0101f7f <__alltraps>

c010253f <vector153>:
.globl vector153
vector153:
  pushl $0
c010253f:	6a 00                	push   $0x0
  pushl $153
c0102541:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102546:	e9 34 fa ff ff       	jmp    c0101f7f <__alltraps>

c010254b <vector154>:
.globl vector154
vector154:
  pushl $0
c010254b:	6a 00                	push   $0x0
  pushl $154
c010254d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102552:	e9 28 fa ff ff       	jmp    c0101f7f <__alltraps>

c0102557 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102557:	6a 00                	push   $0x0
  pushl $155
c0102559:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010255e:	e9 1c fa ff ff       	jmp    c0101f7f <__alltraps>

c0102563 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102563:	6a 00                	push   $0x0
  pushl $156
c0102565:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010256a:	e9 10 fa ff ff       	jmp    c0101f7f <__alltraps>

c010256f <vector157>:
.globl vector157
vector157:
  pushl $0
c010256f:	6a 00                	push   $0x0
  pushl $157
c0102571:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102576:	e9 04 fa ff ff       	jmp    c0101f7f <__alltraps>

c010257b <vector158>:
.globl vector158
vector158:
  pushl $0
c010257b:	6a 00                	push   $0x0
  pushl $158
c010257d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102582:	e9 f8 f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102587 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102587:	6a 00                	push   $0x0
  pushl $159
c0102589:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010258e:	e9 ec f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102593 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102593:	6a 00                	push   $0x0
  pushl $160
c0102595:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010259a:	e9 e0 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010259f <vector161>:
.globl vector161
vector161:
  pushl $0
c010259f:	6a 00                	push   $0x0
  pushl $161
c01025a1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025a6:	e9 d4 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025ab <vector162>:
.globl vector162
vector162:
  pushl $0
c01025ab:	6a 00                	push   $0x0
  pushl $162
c01025ad:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025b2:	e9 c8 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025b7 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025b7:	6a 00                	push   $0x0
  pushl $163
c01025b9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025be:	e9 bc f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025c3 <vector164>:
.globl vector164
vector164:
  pushl $0
c01025c3:	6a 00                	push   $0x0
  pushl $164
c01025c5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01025ca:	e9 b0 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025cf <vector165>:
.globl vector165
vector165:
  pushl $0
c01025cf:	6a 00                	push   $0x0
  pushl $165
c01025d1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01025d6:	e9 a4 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025db <vector166>:
.globl vector166
vector166:
  pushl $0
c01025db:	6a 00                	push   $0x0
  pushl $166
c01025dd:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025e2:	e9 98 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025e7 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025e7:	6a 00                	push   $0x0
  pushl $167
c01025e9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025ee:	e9 8c f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025f3 <vector168>:
.globl vector168
vector168:
  pushl $0
c01025f3:	6a 00                	push   $0x0
  pushl $168
c01025f5:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025fa:	e9 80 f9 ff ff       	jmp    c0101f7f <__alltraps>

c01025ff <vector169>:
.globl vector169
vector169:
  pushl $0
c01025ff:	6a 00                	push   $0x0
  pushl $169
c0102601:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102606:	e9 74 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010260b <vector170>:
.globl vector170
vector170:
  pushl $0
c010260b:	6a 00                	push   $0x0
  pushl $170
c010260d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102612:	e9 68 f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102617 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102617:	6a 00                	push   $0x0
  pushl $171
c0102619:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010261e:	e9 5c f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102623 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $172
c0102625:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010262a:	e9 50 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010262f <vector173>:
.globl vector173
vector173:
  pushl $0
c010262f:	6a 00                	push   $0x0
  pushl $173
c0102631:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102636:	e9 44 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010263b <vector174>:
.globl vector174
vector174:
  pushl $0
c010263b:	6a 00                	push   $0x0
  pushl $174
c010263d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102642:	e9 38 f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102647 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $175
c0102649:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010264e:	e9 2c f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102653 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102653:	6a 00                	push   $0x0
  pushl $176
c0102655:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010265a:	e9 20 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010265f <vector177>:
.globl vector177
vector177:
  pushl $0
c010265f:	6a 00                	push   $0x0
  pushl $177
c0102661:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102666:	e9 14 f9 ff ff       	jmp    c0101f7f <__alltraps>

c010266b <vector178>:
.globl vector178
vector178:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $178
c010266d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102672:	e9 08 f9 ff ff       	jmp    c0101f7f <__alltraps>

c0102677 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102677:	6a 00                	push   $0x0
  pushl $179
c0102679:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010267e:	e9 fc f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102683 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102683:	6a 00                	push   $0x0
  pushl $180
c0102685:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010268a:	e9 f0 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010268f <vector181>:
.globl vector181
vector181:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $181
c0102691:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102696:	e9 e4 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010269b <vector182>:
.globl vector182
vector182:
  pushl $0
c010269b:	6a 00                	push   $0x0
  pushl $182
c010269d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01026a2:	e9 d8 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026a7 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026a7:	6a 00                	push   $0x0
  pushl $183
c01026a9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026ae:	e9 cc f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026b3 <vector184>:
.globl vector184
vector184:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $184
c01026b5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026ba:	e9 c0 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026bf <vector185>:
.globl vector185
vector185:
  pushl $0
c01026bf:	6a 00                	push   $0x0
  pushl $185
c01026c1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01026c6:	e9 b4 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026cb <vector186>:
.globl vector186
vector186:
  pushl $0
c01026cb:	6a 00                	push   $0x0
  pushl $186
c01026cd:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01026d2:	e9 a8 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026d7 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $187
c01026d9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026de:	e9 9c f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026e3 <vector188>:
.globl vector188
vector188:
  pushl $0
c01026e3:	6a 00                	push   $0x0
  pushl $188
c01026e5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026ea:	e9 90 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026ef <vector189>:
.globl vector189
vector189:
  pushl $0
c01026ef:	6a 00                	push   $0x0
  pushl $189
c01026f1:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026f6:	e9 84 f8 ff ff       	jmp    c0101f7f <__alltraps>

c01026fb <vector190>:
.globl vector190
vector190:
  pushl $0
c01026fb:	6a 00                	push   $0x0
  pushl $190
c01026fd:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102702:	e9 78 f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102707 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102707:	6a 00                	push   $0x0
  pushl $191
c0102709:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010270e:	e9 6c f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102713 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102713:	6a 00                	push   $0x0
  pushl $192
c0102715:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010271a:	e9 60 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010271f <vector193>:
.globl vector193
vector193:
  pushl $0
c010271f:	6a 00                	push   $0x0
  pushl $193
c0102721:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102726:	e9 54 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010272b <vector194>:
.globl vector194
vector194:
  pushl $0
c010272b:	6a 00                	push   $0x0
  pushl $194
c010272d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102732:	e9 48 f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102737 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102737:	6a 00                	push   $0x0
  pushl $195
c0102739:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010273e:	e9 3c f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102743 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102743:	6a 00                	push   $0x0
  pushl $196
c0102745:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010274a:	e9 30 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010274f <vector197>:
.globl vector197
vector197:
  pushl $0
c010274f:	6a 00                	push   $0x0
  pushl $197
c0102751:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102756:	e9 24 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010275b <vector198>:
.globl vector198
vector198:
  pushl $0
c010275b:	6a 00                	push   $0x0
  pushl $198
c010275d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102762:	e9 18 f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102767 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $199
c0102769:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010276e:	e9 0c f8 ff ff       	jmp    c0101f7f <__alltraps>

c0102773 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $200
c0102775:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010277a:	e9 00 f8 ff ff       	jmp    c0101f7f <__alltraps>

c010277f <vector201>:
.globl vector201
vector201:
  pushl $0
c010277f:	6a 00                	push   $0x0
  pushl $201
c0102781:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102786:	e9 f4 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010278b <vector202>:
.globl vector202
vector202:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $202
c010278d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102792:	e9 e8 f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102797 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $203
c0102799:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010279e:	e9 dc f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027a3 <vector204>:
.globl vector204
vector204:
  pushl $0
c01027a3:	6a 00                	push   $0x0
  pushl $204
c01027a5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027aa:	e9 d0 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027af <vector205>:
.globl vector205
vector205:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $205
c01027b1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027b6:	e9 c4 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027bb <vector206>:
.globl vector206
vector206:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $206
c01027bd:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027c2:	e9 b8 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027c7 <vector207>:
.globl vector207
vector207:
  pushl $0
c01027c7:	6a 00                	push   $0x0
  pushl $207
c01027c9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01027ce:	e9 ac f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027d3 <vector208>:
.globl vector208
vector208:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $208
c01027d5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027da:	e9 a0 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027df <vector209>:
.globl vector209
vector209:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $209
c01027e1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027e6:	e9 94 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027eb <vector210>:
.globl vector210
vector210:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $210
c01027ed:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027f2:	e9 88 f7 ff ff       	jmp    c0101f7f <__alltraps>

c01027f7 <vector211>:
.globl vector211
vector211:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $211
c01027f9:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027fe:	e9 7c f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102803 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $212
c0102805:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010280a:	e9 70 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010280f <vector213>:
.globl vector213
vector213:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $213
c0102811:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102816:	e9 64 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010281b <vector214>:
.globl vector214
vector214:
  pushl $0
c010281b:	6a 00                	push   $0x0
  pushl $214
c010281d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102822:	e9 58 f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102827 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $215
c0102829:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010282e:	e9 4c f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102833 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $216
c0102835:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010283a:	e9 40 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010283f <vector217>:
.globl vector217
vector217:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $217
c0102841:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102846:	e9 34 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010284b <vector218>:
.globl vector218
vector218:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $218
c010284d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102852:	e9 28 f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102857 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $219
c0102859:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010285e:	e9 1c f7 ff ff       	jmp    c0101f7f <__alltraps>

c0102863 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $220
c0102865:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010286a:	e9 10 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010286f <vector221>:
.globl vector221
vector221:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $221
c0102871:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102876:	e9 04 f7 ff ff       	jmp    c0101f7f <__alltraps>

c010287b <vector222>:
.globl vector222
vector222:
  pushl $0
c010287b:	6a 00                	push   $0x0
  pushl $222
c010287d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102882:	e9 f8 f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102887 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $223
c0102889:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010288e:	e9 ec f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102893 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $224
c0102895:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010289a:	e9 e0 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010289f <vector225>:
.globl vector225
vector225:
  pushl $0
c010289f:	6a 00                	push   $0x0
  pushl $225
c01028a1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028a6:	e9 d4 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028ab <vector226>:
.globl vector226
vector226:
  pushl $0
c01028ab:	6a 00                	push   $0x0
  pushl $226
c01028ad:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028b2:	e9 c8 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028b7 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028b7:	6a 00                	push   $0x0
  pushl $227
c01028b9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028be:	e9 bc f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028c3 <vector228>:
.globl vector228
vector228:
  pushl $0
c01028c3:	6a 00                	push   $0x0
  pushl $228
c01028c5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01028ca:	e9 b0 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028cf <vector229>:
.globl vector229
vector229:
  pushl $0
c01028cf:	6a 00                	push   $0x0
  pushl $229
c01028d1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01028d6:	e9 a4 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028db <vector230>:
.globl vector230
vector230:
  pushl $0
c01028db:	6a 00                	push   $0x0
  pushl $230
c01028dd:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028e2:	e9 98 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028e7 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028e7:	6a 00                	push   $0x0
  pushl $231
c01028e9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028ee:	e9 8c f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028f3 <vector232>:
.globl vector232
vector232:
  pushl $0
c01028f3:	6a 00                	push   $0x0
  pushl $232
c01028f5:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028fa:	e9 80 f6 ff ff       	jmp    c0101f7f <__alltraps>

c01028ff <vector233>:
.globl vector233
vector233:
  pushl $0
c01028ff:	6a 00                	push   $0x0
  pushl $233
c0102901:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102906:	e9 74 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010290b <vector234>:
.globl vector234
vector234:
  pushl $0
c010290b:	6a 00                	push   $0x0
  pushl $234
c010290d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102912:	e9 68 f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102917 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102917:	6a 00                	push   $0x0
  pushl $235
c0102919:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010291e:	e9 5c f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102923 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102923:	6a 00                	push   $0x0
  pushl $236
c0102925:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010292a:	e9 50 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010292f <vector237>:
.globl vector237
vector237:
  pushl $0
c010292f:	6a 00                	push   $0x0
  pushl $237
c0102931:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102936:	e9 44 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010293b <vector238>:
.globl vector238
vector238:
  pushl $0
c010293b:	6a 00                	push   $0x0
  pushl $238
c010293d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102942:	e9 38 f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102947 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102947:	6a 00                	push   $0x0
  pushl $239
c0102949:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010294e:	e9 2c f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102953 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102953:	6a 00                	push   $0x0
  pushl $240
c0102955:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010295a:	e9 20 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010295f <vector241>:
.globl vector241
vector241:
  pushl $0
c010295f:	6a 00                	push   $0x0
  pushl $241
c0102961:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102966:	e9 14 f6 ff ff       	jmp    c0101f7f <__alltraps>

c010296b <vector242>:
.globl vector242
vector242:
  pushl $0
c010296b:	6a 00                	push   $0x0
  pushl $242
c010296d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102972:	e9 08 f6 ff ff       	jmp    c0101f7f <__alltraps>

c0102977 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102977:	6a 00                	push   $0x0
  pushl $243
c0102979:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010297e:	e9 fc f5 ff ff       	jmp    c0101f7f <__alltraps>

c0102983 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102983:	6a 00                	push   $0x0
  pushl $244
c0102985:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010298a:	e9 f0 f5 ff ff       	jmp    c0101f7f <__alltraps>

c010298f <vector245>:
.globl vector245
vector245:
  pushl $0
c010298f:	6a 00                	push   $0x0
  pushl $245
c0102991:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102996:	e9 e4 f5 ff ff       	jmp    c0101f7f <__alltraps>

c010299b <vector246>:
.globl vector246
vector246:
  pushl $0
c010299b:	6a 00                	push   $0x0
  pushl $246
c010299d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01029a2:	e9 d8 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029a7 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029a7:	6a 00                	push   $0x0
  pushl $247
c01029a9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029ae:	e9 cc f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029b3 <vector248>:
.globl vector248
vector248:
  pushl $0
c01029b3:	6a 00                	push   $0x0
  pushl $248
c01029b5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029ba:	e9 c0 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029bf <vector249>:
.globl vector249
vector249:
  pushl $0
c01029bf:	6a 00                	push   $0x0
  pushl $249
c01029c1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01029c6:	e9 b4 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029cb <vector250>:
.globl vector250
vector250:
  pushl $0
c01029cb:	6a 00                	push   $0x0
  pushl $250
c01029cd:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01029d2:	e9 a8 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029d7 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029d7:	6a 00                	push   $0x0
  pushl $251
c01029d9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029de:	e9 9c f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029e3 <vector252>:
.globl vector252
vector252:
  pushl $0
c01029e3:	6a 00                	push   $0x0
  pushl $252
c01029e5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029ea:	e9 90 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029ef <vector253>:
.globl vector253
vector253:
  pushl $0
c01029ef:	6a 00                	push   $0x0
  pushl $253
c01029f1:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029f6:	e9 84 f5 ff ff       	jmp    c0101f7f <__alltraps>

c01029fb <vector254>:
.globl vector254
vector254:
  pushl $0
c01029fb:	6a 00                	push   $0x0
  pushl $254
c01029fd:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a02:	e9 78 f5 ff ff       	jmp    c0101f7f <__alltraps>

c0102a07 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a07:	6a 00                	push   $0x0
  pushl $255
c0102a09:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a0e:	e9 6c f5 ff ff       	jmp    c0101f7f <__alltraps>

c0102a13 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a13:	55                   	push   %ebp
c0102a14:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a16:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1f:	29 d0                	sub    %edx,%eax
c0102a21:	c1 f8 02             	sar    $0x2,%eax
c0102a24:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a2a:	5d                   	pop    %ebp
c0102a2b:	c3                   	ret    

c0102a2c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a2c:	55                   	push   %ebp
c0102a2d:	89 e5                	mov    %esp,%ebp
c0102a2f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a35:	89 04 24             	mov    %eax,(%esp)
c0102a38:	e8 d6 ff ff ff       	call   c0102a13 <page2ppn>
c0102a3d:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a40:	89 ec                	mov    %ebp,%esp
c0102a42:	5d                   	pop    %ebp
c0102a43:	c3                   	ret    

c0102a44 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102a44:	55                   	push   %ebp
c0102a45:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4a:	8b 00                	mov    (%eax),%eax
}
c0102a4c:	5d                   	pop    %ebp
c0102a4d:	c3                   	ret    

c0102a4e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a4e:	55                   	push   %ebp
c0102a4f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a54:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a57:	89 10                	mov    %edx,(%eax)
}
c0102a59:	90                   	nop
c0102a5a:	5d                   	pop    %ebp
c0102a5b:	c3                   	ret    

c0102a5c <default_init>:
#define free_list (free_area.free_list) //列表头
#define nr_free (free_area.nr_free)     //空页数

static void
default_init(void)
{
c0102a5c:	55                   	push   %ebp
c0102a5d:	89 e5                	mov    %esp,%ebp
c0102a5f:	83 ec 10             	sub    $0x10,%esp
c0102a62:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a6f:	89 50 04             	mov    %edx,0x4(%eax)
c0102a72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a75:	8b 50 04             	mov    0x4(%eax),%edx
c0102a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a7b:	89 10                	mov    %edx,(%eax)
}
c0102a7d:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0102a7e:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102a85:	00 00 00 
}
c0102a88:	90                   	nop
c0102a89:	89 ec                	mov    %ebp,%esp
c0102a8b:	5d                   	pop    %ebp
c0102a8c:	c3                   	ret    

c0102a8d <default_init_memmap>:

//初始化空闲列表
static void
default_init_memmap(struct Page *base, size_t n)
{
c0102a8d:	55                   	push   %ebp
c0102a8e:	89 e5                	mov    %esp,%ebp
c0102a90:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a97:	75 24                	jne    c0102abd <default_init_memmap+0x30>
c0102a99:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c0102aa0:	c0 
c0102aa1:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102aa8:	c0 
c0102aa9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102ab0:	00 
c0102ab1:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102ab8:	e8 3b e2 ff ff       	call   c0100cf8 <__panic>
    struct Page *p = base;
c0102abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102ac3:	eb 7b                	jmp    c0102b40 <default_init_memmap+0xb3>
    {
        assert(PageReserved(p)); //检查是否为保留页
c0102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac8:	83 c0 04             	add    $0x4,%eax
c0102acb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102adb:	0f a3 10             	bt     %edx,(%eax)
c0102ade:	19 c0                	sbb    %eax,%eax
c0102ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102ae3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102ae7:	0f 95 c0             	setne  %al
c0102aea:	0f b6 c0             	movzbl %al,%eax
c0102aed:	85 c0                	test   %eax,%eax
c0102aef:	75 24                	jne    c0102b15 <default_init_memmap+0x88>
c0102af1:	c7 44 24 0c 21 67 10 	movl   $0xc0106721,0xc(%esp)
c0102af8:	c0 
c0102af9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102b00:	c0 
c0102b01:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102b08:	00 
c0102b09:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102b10:	e8 e3 e1 ff ff       	call   c0100cf8 <__panic>
        p->flags = 0;
c0102b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;    //设置标记，flag为0表示可以分配,property为0表示不是base
c0102b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0); //清空引用此页的虚拟页个数
c0102b29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102b30:	00 
c0102b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b34:	89 04 24             	mov    %eax,(%esp)
c0102b37:	e8 12 ff ff ff       	call   c0102a4e <set_page_ref>
    for (; p != base + n; p++)
c0102b3c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102b40:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b43:	89 d0                	mov    %edx,%eax
c0102b45:	c1 e0 02             	shl    $0x2,%eax
c0102b48:	01 d0                	add    %edx,%eax
c0102b4a:	c1 e0 02             	shl    $0x2,%eax
c0102b4d:	89 c2                	mov    %eax,%edx
c0102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b52:	01 d0                	add    %edx,%eax
c0102b54:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102b57:	0f 85 68 ff ff ff    	jne    c0102ac5 <default_init_memmap+0x38>
    }
    SetPageProperty(base); //块首页标志位设置为1
c0102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b60:	83 c0 04             	add    $0x4,%eax
c0102b63:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b70:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b73:	0f ab 10             	bts    %edx,(%eax)
}
c0102b76:	90                   	nop
    base->property = n;
c0102b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b7d:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102b80:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102b86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b89:	01 d0                	add    %edx,%eax
c0102b8b:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(&free_list, &(base->page_link)); //插入空闲页的链表里面
c0102b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b93:	83 c0 0c             	add    $0xc,%eax
c0102b96:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c0102b9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ba3:	8b 00                	mov    (%eax),%eax
c0102ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102ba8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102bab:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102bba:	89 10                	mov    %edx,(%eax)
c0102bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bbf:	8b 10                	mov    (%eax),%edx
c0102bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bc4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102bcd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bd3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bd6:	89 10                	mov    %edx,(%eax)
}
c0102bd8:	90                   	nop
}
c0102bd9:	90                   	nop
}
c0102bda:	90                   	nop
c0102bdb:	89 ec                	mov    %ebp,%esp
c0102bdd:	5d                   	pop    %ebp
c0102bde:	c3                   	ret    

c0102bdf <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0102bdf:	55                   	push   %ebp
c0102be0:	89 e5                	mov    %esp,%ebp
c0102be2:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102be9:	75 24                	jne    c0102c0f <default_alloc_pages+0x30>
c0102beb:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c0102bf2:	c0 
c0102bf3:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102bfa:	c0 
c0102bfb:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0102c02:	00 
c0102c03:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102c0a:	e8 e9 e0 ff ff       	call   c0100cf8 <__panic>
    if (n > nr_free) //如果所有的空闲页的加起来的大小都不够，那直接返回NULL
c0102c0f:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102c14:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c17:	76 0a                	jbe    c0102c23 <default_alloc_pages+0x44>
    {
        return NULL;
c0102c19:	b8 00 00 00 00       	mov    $0x0,%eax
c0102c1e:	e9 43 01 00 00       	jmp    c0102d66 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c0102c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102c2a:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c0102c31:	eb 1c                	jmp    c0102c4f <default_alloc_pages+0x70>
    {
        // 由链表元素获得对应的Page指针p
        struct Page *p = le2page(le, page_link);
c0102c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c36:	83 e8 0c             	sub    $0xc,%eax
c0102c39:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c0102c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c3f:	8b 40 08             	mov    0x8(%eax),%eax
c0102c42:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c45:	77 08                	ja     c0102c4f <default_alloc_pages+0x70>
        {
            page = p;
c0102c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102c4d:	eb 18                	jmp    c0102c67 <default_alloc_pages+0x88>
c0102c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c58:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c5e:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102c65:	75 cc                	jne    c0102c33 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c0102c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c6b:	0f 84 f2 00 00 00    	je     c0102d63 <default_alloc_pages+0x184>
    {
        if (page->property > n)
c0102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c74:	8b 40 08             	mov    0x8(%eax),%eax
c0102c77:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c7a:	0f 83 8f 00 00 00    	jae    c0102d0f <default_alloc_pages+0x130>
        {
            //如果页块大小大于所需大小，分割页块
            struct Page *p = page + n;
c0102c80:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c83:	89 d0                	mov    %edx,%eax
c0102c85:	c1 e0 02             	shl    $0x2,%eax
c0102c88:	01 d0                	add    %edx,%eax
c0102c8a:	c1 e0 02             	shl    $0x2,%eax
c0102c8d:	89 c2                	mov    %eax,%edx
c0102c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c92:	01 d0                	add    %edx,%eax
c0102c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c9a:	8b 40 08             	mov    0x8(%eax),%eax
c0102c9d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ca0:	89 c2                	mov    %eax,%edx
c0102ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ca5:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cab:	83 c0 0c             	add    $0xc,%eax
c0102cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102cb1:	83 c2 0c             	add    $0xc,%edx
c0102cb4:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102cb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102cba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102cbd:	8b 40 04             	mov    0x4(%eax),%eax
c0102cc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cc3:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102cc6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cc9:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102ccc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0102ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cd2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cd5:	89 10                	mov    %edx,(%eax)
c0102cd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cda:	8b 10                	mov    (%eax),%edx
c0102cdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cdf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ce2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ce5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ce8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ceb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cee:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102cf1:	89 10                	mov    %edx,(%eax)
}
c0102cf3:	90                   	nop
}
c0102cf4:	90                   	nop
            SetPageProperty(p);
c0102cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cf8:	83 c0 04             	add    $0x4,%eax
c0102cfb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102d02:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d08:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102d0b:	0f ab 10             	bts    %edx,(%eax)
}
c0102d0e:	90                   	nop
        }
        // 在空闲页链表中删除刚刚分配的空闲块
        list_del(&(page->page_link));
c0102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d12:	83 c0 0c             	add    $0xc,%eax
c0102d15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d18:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d1b:	8b 40 04             	mov    0x4(%eax),%eax
c0102d1e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d21:	8b 12                	mov    (%edx),%edx
c0102d23:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d29:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d2c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d2f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d35:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d38:	89 10                	mov    %edx,(%eax)
}
c0102d3a:	90                   	nop
}
c0102d3b:	90                   	nop
        nr_free -= n;
c0102d3c:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102d41:	2b 45 08             	sub    0x8(%ebp),%eax
c0102d44:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4c:	83 c0 04             	add    $0x4,%eax
c0102d4f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d59:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d5c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d5f:	0f b3 10             	btr    %edx,(%eax)
}
c0102d62:	90                   	nop
    }
    return page;
c0102d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d66:	89 ec                	mov    %ebp,%esp
c0102d68:	5d                   	pop    %ebp
c0102d69:	c3                   	ret    

c0102d6a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c0102d6a:	55                   	push   %ebp
c0102d6b:	89 e5                	mov    %esp,%ebp
c0102d6d:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d77:	75 24                	jne    c0102d9d <default_free_pages+0x33>
c0102d79:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c0102d80:	c0 
c0102d81:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102d88:	c0 
c0102d89:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102d90:	00 
c0102d91:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102d98:	e8 5b df ff ff       	call   c0100cf8 <__panic>
    struct Page *p = base;
c0102d9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0102da3:	e9 9d 00 00 00       	jmp    c0102e45 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0102da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dab:	83 c0 04             	add    $0x4,%eax
c0102dae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102db5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102dbe:	0f a3 10             	bt     %edx,(%eax)
c0102dc1:	19 c0                	sbb    %eax,%eax
c0102dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dca:	0f 95 c0             	setne  %al
c0102dcd:	0f b6 c0             	movzbl %al,%eax
c0102dd0:	85 c0                	test   %eax,%eax
c0102dd2:	75 2c                	jne    c0102e00 <default_free_pages+0x96>
c0102dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd7:	83 c0 04             	add    $0x4,%eax
c0102dda:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102de1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102dea:	0f a3 10             	bt     %edx,(%eax)
c0102ded:	19 c0                	sbb    %eax,%eax
c0102def:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102df2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102df6:	0f 95 c0             	setne  %al
c0102df9:	0f b6 c0             	movzbl %al,%eax
c0102dfc:	85 c0                	test   %eax,%eax
c0102dfe:	74 24                	je     c0102e24 <default_free_pages+0xba>
c0102e00:	c7 44 24 0c 34 67 10 	movl   $0xc0106734,0xc(%esp)
c0102e07:	c0 
c0102e08:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0102e0f:	c0 
c0102e10:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0102e17:	00 
c0102e18:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0102e1f:	e8 d4 de ff ff       	call   c0100cf8 <__panic>
        p->flags = 0;
c0102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e35:	00 
c0102e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e39:	89 04 24             	mov    %eax,(%esp)
c0102e3c:	e8 0d fc ff ff       	call   c0102a4e <set_page_ref>
    for (; p != base + n; p++)
c0102e41:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102e45:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e48:	89 d0                	mov    %edx,%eax
c0102e4a:	c1 e0 02             	shl    $0x2,%eax
c0102e4d:	01 d0                	add    %edx,%eax
c0102e4f:	c1 e0 02             	shl    $0x2,%eax
c0102e52:	89 c2                	mov    %eax,%edx
c0102e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e57:	01 d0                	add    %edx,%eax
c0102e59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e5c:	0f 85 46 ff ff ff    	jne    c0102da8 <default_free_pages+0x3e>
    }
    base->property = n;
c0102e62:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e65:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e68:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6e:	83 c0 04             	add    $0x4,%eax
c0102e71:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102e78:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102e7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e81:	0f ab 10             	bts    %edx,(%eax)
}
c0102e84:	90                   	nop
c0102e85:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102e8f:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 遍历空闲链表，查看能否将释放块合并到合适的页块中
    while (le != &free_list)
c0102e95:	e9 0e 01 00 00       	jmp    c0102fa8 <default_free_pages+0x23e>
    {
        p = le2page(le, page_link);
c0102e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e9d:	83 e8 0c             	sub    $0xc,%eax
c0102ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ea9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102eac:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // 如果释放块在下一个空闲块起始页的前面，那么进行合并
        if (base + base->property == p)
c0102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eb5:	8b 50 08             	mov    0x8(%eax),%edx
c0102eb8:	89 d0                	mov    %edx,%eax
c0102eba:	c1 e0 02             	shl    $0x2,%eax
c0102ebd:	01 d0                	add    %edx,%eax
c0102ebf:	c1 e0 02             	shl    $0x2,%eax
c0102ec2:	89 c2                	mov    %eax,%edx
c0102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec7:	01 d0                	add    %edx,%eax
c0102ec9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ecc:	75 5d                	jne    c0102f2b <default_free_pages+0x1c1>
        {
            base->property += p->property;
c0102ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ed1:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed7:	8b 40 08             	mov    0x8(%eax),%eax
c0102eda:	01 c2                	add    %eax,%edx
c0102edc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102edf:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee5:	83 c0 04             	add    $0x4,%eax
c0102ee8:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102eef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ef2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ef5:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102ef8:	0f b3 10             	btr    %edx,(%eax)
}
c0102efb:	90                   	nop
            list_del(&(p->page_link));
c0102efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eff:	83 c0 0c             	add    $0xc,%eax
c0102f02:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f08:	8b 40 04             	mov    0x4(%eax),%eax
c0102f0b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102f0e:	8b 12                	mov    (%edx),%edx
c0102f10:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102f13:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102f16:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102f19:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102f1c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f22:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102f25:	89 10                	mov    %edx,(%eax)
}
c0102f27:	90                   	nop
}
c0102f28:	90                   	nop
c0102f29:	eb 7d                	jmp    c0102fa8 <default_free_pages+0x23e>
        }
        // 如果释放块的起始页在上一个空闲块的后面，那么进行合并
        else if (p + p->property == base)
c0102f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2e:	8b 50 08             	mov    0x8(%eax),%edx
c0102f31:	89 d0                	mov    %edx,%eax
c0102f33:	c1 e0 02             	shl    $0x2,%eax
c0102f36:	01 d0                	add    %edx,%eax
c0102f38:	c1 e0 02             	shl    $0x2,%eax
c0102f3b:	89 c2                	mov    %eax,%edx
c0102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f40:	01 d0                	add    %edx,%eax
c0102f42:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102f45:	75 61                	jne    c0102fa8 <default_free_pages+0x23e>
        {
            p->property += base->property;
c0102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4a:	8b 50 08             	mov    0x8(%eax),%edx
c0102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f50:	8b 40 08             	mov    0x8(%eax),%eax
c0102f53:	01 c2                	add    %eax,%edx
c0102f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f58:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102f5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f5e:	83 c0 04             	add    $0x4,%eax
c0102f61:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102f68:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f6b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f6e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f71:	0f b3 10             	btr    %edx,(%eax)
}
c0102f74:	90                   	nop
            base = p;
c0102f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f78:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7e:	83 c0 0c             	add    $0xc,%eax
c0102f81:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f84:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f87:	8b 40 04             	mov    0x4(%eax),%eax
c0102f8a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102f8d:	8b 12                	mov    (%edx),%edx
c0102f8f:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102f92:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102f95:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f98:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f9b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102fa1:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102fa4:	89 10                	mov    %edx,(%eax)
}
c0102fa6:	90                   	nop
}
c0102fa7:	90                   	nop
    while (le != &free_list)
c0102fa8:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102faf:	0f 85 e5 fe ff ff    	jne    c0102e9a <default_free_pages+0x130>
        }
    }
    le = &free_list;
c0102fb5:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // 遍历空闲链表，将合并好之后的页块加回空闲链表
    while ((le = list_next(le)) != &free_list)
c0102fbc:	eb 25                	jmp    c0102fe3 <default_free_pages+0x279>
    {
        p = le2page(le, page_link);
c0102fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fc1:	83 e8 0c             	sub    $0xc,%eax
c0102fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 找到能够方向新的合并块的位置
        if (base + base->property <= p)
c0102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fca:	8b 50 08             	mov    0x8(%eax),%edx
c0102fcd:	89 d0                	mov    %edx,%eax
c0102fcf:	c1 e0 02             	shl    $0x2,%eax
c0102fd2:	01 d0                	add    %edx,%eax
c0102fd4:	c1 e0 02             	shl    $0x2,%eax
c0102fd7:	89 c2                	mov    %eax,%edx
c0102fd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fdc:	01 d0                	add    %edx,%eax
c0102fde:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102fe1:	73 1a                	jae    c0102ffd <default_free_pages+0x293>
c0102fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fe6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0102fe9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102fec:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0102fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ff2:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102ff9:	75 c3                	jne    c0102fbe <default_free_pages+0x254>
c0102ffb:	eb 01                	jmp    c0102ffe <default_free_pages+0x294>
        {
            break;
c0102ffd:	90                   	nop
        }
    }
    nr_free += n;
c0102ffe:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0103004:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103007:	01 d0                	add    %edx,%eax
c0103009:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(le, &(base->page_link));
c010300e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103011:	8d 50 0c             	lea    0xc(%eax),%edx
c0103014:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103017:	89 45 98             	mov    %eax,-0x68(%ebp)
c010301a:	89 55 94             	mov    %edx,-0x6c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010301d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103020:	8b 00                	mov    (%eax),%eax
c0103022:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103025:	89 55 90             	mov    %edx,-0x70(%ebp)
c0103028:	89 45 8c             	mov    %eax,-0x74(%ebp)
c010302b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010302e:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next->prev = elm;
c0103031:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103034:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103037:	89 10                	mov    %edx,(%eax)
c0103039:	8b 45 88             	mov    -0x78(%ebp),%eax
c010303c:	8b 10                	mov    (%eax),%edx
c010303e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103041:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103044:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103047:	8b 55 88             	mov    -0x78(%ebp),%edx
c010304a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010304d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103050:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103053:	89 10                	mov    %edx,(%eax)
}
c0103055:	90                   	nop
}
c0103056:	90                   	nop
}
c0103057:	90                   	nop
c0103058:	89 ec                	mov    %ebp,%esp
c010305a:	5d                   	pop    %ebp
c010305b:	c3                   	ret    

c010305c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c010305c:	55                   	push   %ebp
c010305d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010305f:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0103064:	5d                   	pop    %ebp
c0103065:	c3                   	ret    

c0103066 <basic_check>:

static void
basic_check(void)
{
c0103066:	55                   	push   %ebp
c0103067:	89 e5                	mov    %esp,%ebp
c0103069:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010306c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103073:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103076:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103079:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010307c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010307f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103086:	e8 df 0e 00 00       	call   c0103f6a <alloc_pages>
c010308b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010308e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103092:	75 24                	jne    c01030b8 <basic_check+0x52>
c0103094:	c7 44 24 0c 59 67 10 	movl   $0xc0106759,0xc(%esp)
c010309b:	c0 
c010309c:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01030a3:	c0 
c01030a4:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01030ab:	00 
c01030ac:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01030b3:	e8 40 dc ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030bf:	e8 a6 0e 00 00       	call   c0103f6a <alloc_pages>
c01030c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030cb:	75 24                	jne    c01030f1 <basic_check+0x8b>
c01030cd:	c7 44 24 0c 75 67 10 	movl   $0xc0106775,0xc(%esp)
c01030d4:	c0 
c01030d5:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01030dc:	c0 
c01030dd:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01030e4:	00 
c01030e5:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01030ec:	e8 07 dc ff ff       	call   c0100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030f8:	e8 6d 0e 00 00       	call   c0103f6a <alloc_pages>
c01030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103104:	75 24                	jne    c010312a <basic_check+0xc4>
c0103106:	c7 44 24 0c 91 67 10 	movl   $0xc0106791,0xc(%esp)
c010310d:	c0 
c010310e:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103115:	c0 
c0103116:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010311d:	00 
c010311e:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103125:	e8 ce db ff ff       	call   c0100cf8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010312d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103130:	74 10                	je     c0103142 <basic_check+0xdc>
c0103132:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103135:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103138:	74 08                	je     c0103142 <basic_check+0xdc>
c010313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010313d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103140:	75 24                	jne    c0103166 <basic_check+0x100>
c0103142:	c7 44 24 0c b0 67 10 	movl   $0xc01067b0,0xc(%esp)
c0103149:	c0 
c010314a:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103151:	c0 
c0103152:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103159:	00 
c010315a:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103161:	e8 92 db ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103166:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103169:	89 04 24             	mov    %eax,(%esp)
c010316c:	e8 d3 f8 ff ff       	call   c0102a44 <page_ref>
c0103171:	85 c0                	test   %eax,%eax
c0103173:	75 1e                	jne    c0103193 <basic_check+0x12d>
c0103175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103178:	89 04 24             	mov    %eax,(%esp)
c010317b:	e8 c4 f8 ff ff       	call   c0102a44 <page_ref>
c0103180:	85 c0                	test   %eax,%eax
c0103182:	75 0f                	jne    c0103193 <basic_check+0x12d>
c0103184:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103187:	89 04 24             	mov    %eax,(%esp)
c010318a:	e8 b5 f8 ff ff       	call   c0102a44 <page_ref>
c010318f:	85 c0                	test   %eax,%eax
c0103191:	74 24                	je     c01031b7 <basic_check+0x151>
c0103193:	c7 44 24 0c d4 67 10 	movl   $0xc01067d4,0xc(%esp)
c010319a:	c0 
c010319b:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01031a2:	c0 
c01031a3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01031aa:	00 
c01031ab:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01031b2:	e8 41 db ff ff       	call   c0100cf8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01031b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031ba:	89 04 24             	mov    %eax,(%esp)
c01031bd:	e8 6a f8 ff ff       	call   c0102a2c <page2pa>
c01031c2:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01031c8:	c1 e2 0c             	shl    $0xc,%edx
c01031cb:	39 d0                	cmp    %edx,%eax
c01031cd:	72 24                	jb     c01031f3 <basic_check+0x18d>
c01031cf:	c7 44 24 0c 10 68 10 	movl   $0xc0106810,0xc(%esp)
c01031d6:	c0 
c01031d7:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01031de:	c0 
c01031df:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01031e6:	00 
c01031e7:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01031ee:	e8 05 db ff ff       	call   c0100cf8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031f6:	89 04 24             	mov    %eax,(%esp)
c01031f9:	e8 2e f8 ff ff       	call   c0102a2c <page2pa>
c01031fe:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103204:	c1 e2 0c             	shl    $0xc,%edx
c0103207:	39 d0                	cmp    %edx,%eax
c0103209:	72 24                	jb     c010322f <basic_check+0x1c9>
c010320b:	c7 44 24 0c 2d 68 10 	movl   $0xc010682d,0xc(%esp)
c0103212:	c0 
c0103213:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010321a:	c0 
c010321b:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103222:	00 
c0103223:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010322a:	e8 c9 da ff ff       	call   c0100cf8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103232:	89 04 24             	mov    %eax,(%esp)
c0103235:	e8 f2 f7 ff ff       	call   c0102a2c <page2pa>
c010323a:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103240:	c1 e2 0c             	shl    $0xc,%edx
c0103243:	39 d0                	cmp    %edx,%eax
c0103245:	72 24                	jb     c010326b <basic_check+0x205>
c0103247:	c7 44 24 0c 4a 68 10 	movl   $0xc010684a,0xc(%esp)
c010324e:	c0 
c010324f:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103256:	c0 
c0103257:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c010325e:	00 
c010325f:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103266:	e8 8d da ff ff       	call   c0100cf8 <__panic>

    list_entry_t free_list_store = free_list;
c010326b:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103270:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103276:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103279:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010327c:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103283:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103286:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103289:	89 50 04             	mov    %edx,0x4(%eax)
c010328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010328f:	8b 50 04             	mov    0x4(%eax),%edx
c0103292:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103295:	89 10                	mov    %edx,(%eax)
}
c0103297:	90                   	nop
c0103298:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c010329f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032a2:	8b 40 04             	mov    0x4(%eax),%eax
c01032a5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01032a8:	0f 94 c0             	sete   %al
c01032ab:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032ae:	85 c0                	test   %eax,%eax
c01032b0:	75 24                	jne    c01032d6 <basic_check+0x270>
c01032b2:	c7 44 24 0c 67 68 10 	movl   $0xc0106867,0xc(%esp)
c01032b9:	c0 
c01032ba:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01032c1:	c0 
c01032c2:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01032c9:	00 
c01032ca:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01032d1:	e8 22 da ff ff       	call   c0100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
c01032d6:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01032db:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032de:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01032e5:	00 00 00 

    assert(alloc_page() == NULL);
c01032e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032ef:	e8 76 0c 00 00       	call   c0103f6a <alloc_pages>
c01032f4:	85 c0                	test   %eax,%eax
c01032f6:	74 24                	je     c010331c <basic_check+0x2b6>
c01032f8:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01032ff:	c0 
c0103300:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103307:	c0 
c0103308:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010330f:	00 
c0103310:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103317:	e8 dc d9 ff ff       	call   c0100cf8 <__panic>

    free_page(p0);
c010331c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103323:	00 
c0103324:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103327:	89 04 24             	mov    %eax,(%esp)
c010332a:	e8 75 0c 00 00       	call   c0103fa4 <free_pages>
    free_page(p1);
c010332f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103336:	00 
c0103337:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333a:	89 04 24             	mov    %eax,(%esp)
c010333d:	e8 62 0c 00 00       	call   c0103fa4 <free_pages>
    free_page(p2);
c0103342:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103349:	00 
c010334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334d:	89 04 24             	mov    %eax,(%esp)
c0103350:	e8 4f 0c 00 00       	call   c0103fa4 <free_pages>
    assert(nr_free == 3);
c0103355:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010335a:	83 f8 03             	cmp    $0x3,%eax
c010335d:	74 24                	je     c0103383 <basic_check+0x31d>
c010335f:	c7 44 24 0c 93 68 10 	movl   $0xc0106893,0xc(%esp)
c0103366:	c0 
c0103367:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010336e:	c0 
c010336f:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103376:	00 
c0103377:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010337e:	e8 75 d9 ff ff       	call   c0100cf8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010338a:	e8 db 0b 00 00       	call   c0103f6a <alloc_pages>
c010338f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103392:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103396:	75 24                	jne    c01033bc <basic_check+0x356>
c0103398:	c7 44 24 0c 59 67 10 	movl   $0xc0106759,0xc(%esp)
c010339f:	c0 
c01033a0:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01033a7:	c0 
c01033a8:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01033af:	00 
c01033b0:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01033b7:	e8 3c d9 ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033c3:	e8 a2 0b 00 00       	call   c0103f6a <alloc_pages>
c01033c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033cf:	75 24                	jne    c01033f5 <basic_check+0x38f>
c01033d1:	c7 44 24 0c 75 67 10 	movl   $0xc0106775,0xc(%esp)
c01033d8:	c0 
c01033d9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01033e0:	c0 
c01033e1:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01033e8:	00 
c01033e9:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01033f0:	e8 03 d9 ff ff       	call   c0100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033fc:	e8 69 0b 00 00       	call   c0103f6a <alloc_pages>
c0103401:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103408:	75 24                	jne    c010342e <basic_check+0x3c8>
c010340a:	c7 44 24 0c 91 67 10 	movl   $0xc0106791,0xc(%esp)
c0103411:	c0 
c0103412:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103419:	c0 
c010341a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103421:	00 
c0103422:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103429:	e8 ca d8 ff ff       	call   c0100cf8 <__panic>

    assert(alloc_page() == NULL);
c010342e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103435:	e8 30 0b 00 00       	call   c0103f6a <alloc_pages>
c010343a:	85 c0                	test   %eax,%eax
c010343c:	74 24                	je     c0103462 <basic_check+0x3fc>
c010343e:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103445:	c0 
c0103446:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010344d:	c0 
c010344e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103455:	00 
c0103456:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010345d:	e8 96 d8 ff ff       	call   c0100cf8 <__panic>

    free_page(p0);
c0103462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103469:	00 
c010346a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346d:	89 04 24             	mov    %eax,(%esp)
c0103470:	e8 2f 0b 00 00       	call   c0103fa4 <free_pages>
c0103475:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c010347c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010347f:	8b 40 04             	mov    0x4(%eax),%eax
c0103482:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103485:	0f 94 c0             	sete   %al
c0103488:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010348b:	85 c0                	test   %eax,%eax
c010348d:	74 24                	je     c01034b3 <basic_check+0x44d>
c010348f:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c0103496:	c0 
c0103497:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010349e:	c0 
c010349f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01034a6:	00 
c01034a7:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01034ae:	e8 45 d8 ff ff       	call   c0100cf8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034ba:	e8 ab 0a 00 00       	call   c0103f6a <alloc_pages>
c01034bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01034c8:	74 24                	je     c01034ee <basic_check+0x488>
c01034ca:	c7 44 24 0c b8 68 10 	movl   $0xc01068b8,0xc(%esp)
c01034d1:	c0 
c01034d2:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01034d9:	c0 
c01034da:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01034e1:	00 
c01034e2:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01034e9:	e8 0a d8 ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c01034ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034f5:	e8 70 0a 00 00       	call   c0103f6a <alloc_pages>
c01034fa:	85 c0                	test   %eax,%eax
c01034fc:	74 24                	je     c0103522 <basic_check+0x4bc>
c01034fe:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103505:	c0 
c0103506:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010350d:	c0 
c010350e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103515:	00 
c0103516:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010351d:	e8 d6 d7 ff ff       	call   c0100cf8 <__panic>

    assert(nr_free == 0);
c0103522:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103527:	85 c0                	test   %eax,%eax
c0103529:	74 24                	je     c010354f <basic_check+0x4e9>
c010352b:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c0103532:	c0 
c0103533:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010353a:	c0 
c010353b:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103542:	00 
c0103543:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010354a:	e8 a9 d7 ff ff       	call   c0100cf8 <__panic>
    free_list = free_list_store;
c010354f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103552:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103555:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c010355a:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c0103560:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103563:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c0103568:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010356f:	00 
c0103570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103573:	89 04 24             	mov    %eax,(%esp)
c0103576:	e8 29 0a 00 00       	call   c0103fa4 <free_pages>
    free_page(p1);
c010357b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103582:	00 
c0103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103586:	89 04 24             	mov    %eax,(%esp)
c0103589:	e8 16 0a 00 00       	call   c0103fa4 <free_pages>
    free_page(p2);
c010358e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103595:	00 
c0103596:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103599:	89 04 24             	mov    %eax,(%esp)
c010359c:	e8 03 0a 00 00       	call   c0103fa4 <free_pages>
}
c01035a1:	90                   	nop
c01035a2:	89 ec                	mov    %ebp,%esp
c01035a4:	5d                   	pop    %ebp
c01035a5:	c3                   	ret    

c01035a6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c01035a6:	55                   	push   %ebp
c01035a7:	89 e5                	mov    %esp,%ebp
c01035a9:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01035af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035bd:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c01035c4:	eb 6a                	jmp    c0103630 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c01035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c9:	83 e8 0c             	sub    $0xc,%eax
c01035cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01035cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035d2:	83 c0 04             	add    $0x4,%eax
c01035d5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01035dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035df:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035e5:	0f a3 10             	bt     %edx,(%eax)
c01035e8:	19 c0                	sbb    %eax,%eax
c01035ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035f1:	0f 95 c0             	setne  %al
c01035f4:	0f b6 c0             	movzbl %al,%eax
c01035f7:	85 c0                	test   %eax,%eax
c01035f9:	75 24                	jne    c010361f <default_check+0x79>
c01035fb:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c0103602:	c0 
c0103603:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010360a:	c0 
c010360b:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0103612:	00 
c0103613:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010361a:	e8 d9 d6 ff ff       	call   c0100cf8 <__panic>
        count++, total += p->property;
c010361f:	ff 45 f4             	incl   -0xc(%ebp)
c0103622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103625:	8b 50 08             	mov    0x8(%eax),%edx
c0103628:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010362b:	01 d0                	add    %edx,%eax
c010362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103630:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103633:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103636:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103639:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c010363c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010363f:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103646:	0f 85 7a ff ff ff    	jne    c01035c6 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010364c:	e8 88 09 00 00       	call   c0103fd9 <nr_free_pages>
c0103651:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103654:	39 d0                	cmp    %edx,%eax
c0103656:	74 24                	je     c010367c <default_check+0xd6>
c0103658:	c7 44 24 0c ee 68 10 	movl   $0xc01068ee,0xc(%esp)
c010365f:	c0 
c0103660:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103667:	c0 
c0103668:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010366f:	00 
c0103670:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103677:	e8 7c d6 ff ff       	call   c0100cf8 <__panic>

    basic_check();
c010367c:	e8 e5 f9 ff ff       	call   c0103066 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103681:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103688:	e8 dd 08 00 00       	call   c0103f6a <alloc_pages>
c010368d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103690:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103694:	75 24                	jne    c01036ba <default_check+0x114>
c0103696:	c7 44 24 0c 07 69 10 	movl   $0xc0106907,0xc(%esp)
c010369d:	c0 
c010369e:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01036a5:	c0 
c01036a6:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01036ad:	00 
c01036ae:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01036b5:	e8 3e d6 ff ff       	call   c0100cf8 <__panic>
    assert(!PageProperty(p0));
c01036ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036bd:	83 c0 04             	add    $0x4,%eax
c01036c0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01036c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01036cd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036d0:	0f a3 10             	bt     %edx,(%eax)
c01036d3:	19 c0                	sbb    %eax,%eax
c01036d5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01036d8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01036dc:	0f 95 c0             	setne  %al
c01036df:	0f b6 c0             	movzbl %al,%eax
c01036e2:	85 c0                	test   %eax,%eax
c01036e4:	74 24                	je     c010370a <default_check+0x164>
c01036e6:	c7 44 24 0c 12 69 10 	movl   $0xc0106912,0xc(%esp)
c01036ed:	c0 
c01036ee:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01036f5:	c0 
c01036f6:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01036fd:	00 
c01036fe:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103705:	e8 ee d5 ff ff       	call   c0100cf8 <__panic>

    list_entry_t free_list_store = free_list;
c010370a:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010370f:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103715:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103718:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010371b:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103722:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103725:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103728:	89 50 04             	mov    %edx,0x4(%eax)
c010372b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010372e:	8b 50 04             	mov    0x4(%eax),%edx
c0103731:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103734:	89 10                	mov    %edx,(%eax)
}
c0103736:	90                   	nop
c0103737:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c010373e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103741:	8b 40 04             	mov    0x4(%eax),%eax
c0103744:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103747:	0f 94 c0             	sete   %al
c010374a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010374d:	85 c0                	test   %eax,%eax
c010374f:	75 24                	jne    c0103775 <default_check+0x1cf>
c0103751:	c7 44 24 0c 67 68 10 	movl   $0xc0106867,0xc(%esp)
c0103758:	c0 
c0103759:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103760:	c0 
c0103761:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103768:	00 
c0103769:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103770:	e8 83 d5 ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c0103775:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010377c:	e8 e9 07 00 00       	call   c0103f6a <alloc_pages>
c0103781:	85 c0                	test   %eax,%eax
c0103783:	74 24                	je     c01037a9 <default_check+0x203>
c0103785:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c010378c:	c0 
c010378d:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103794:	c0 
c0103795:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010379c:	00 
c010379d:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01037a4:	e8 4f d5 ff ff       	call   c0100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
c01037a9:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01037ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01037b1:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01037b8:	00 00 00 

    free_pages(p0 + 2, 3);
c01037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037be:	83 c0 28             	add    $0x28,%eax
c01037c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01037c8:	00 
c01037c9:	89 04 24             	mov    %eax,(%esp)
c01037cc:	e8 d3 07 00 00       	call   c0103fa4 <free_pages>
    assert(alloc_pages(4) == NULL);
c01037d1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01037d8:	e8 8d 07 00 00       	call   c0103f6a <alloc_pages>
c01037dd:	85 c0                	test   %eax,%eax
c01037df:	74 24                	je     c0103805 <default_check+0x25f>
c01037e1:	c7 44 24 0c 24 69 10 	movl   $0xc0106924,0xc(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01037f8:	00 
c01037f9:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103800:	e8 f3 d4 ff ff       	call   c0100cf8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103805:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103808:	83 c0 28             	add    $0x28,%eax
c010380b:	83 c0 04             	add    $0x4,%eax
c010380e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103815:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103818:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010381b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010381e:	0f a3 10             	bt     %edx,(%eax)
c0103821:	19 c0                	sbb    %eax,%eax
c0103823:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103826:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010382a:	0f 95 c0             	setne  %al
c010382d:	0f b6 c0             	movzbl %al,%eax
c0103830:	85 c0                	test   %eax,%eax
c0103832:	74 0e                	je     c0103842 <default_check+0x29c>
c0103834:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103837:	83 c0 28             	add    $0x28,%eax
c010383a:	8b 40 08             	mov    0x8(%eax),%eax
c010383d:	83 f8 03             	cmp    $0x3,%eax
c0103840:	74 24                	je     c0103866 <default_check+0x2c0>
c0103842:	c7 44 24 0c 3c 69 10 	movl   $0xc010693c,0xc(%esp)
c0103849:	c0 
c010384a:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103851:	c0 
c0103852:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103859:	00 
c010385a:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103861:	e8 92 d4 ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103866:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010386d:	e8 f8 06 00 00       	call   c0103f6a <alloc_pages>
c0103872:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103875:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103879:	75 24                	jne    c010389f <default_check+0x2f9>
c010387b:	c7 44 24 0c 68 69 10 	movl   $0xc0106968,0xc(%esp)
c0103882:	c0 
c0103883:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c010388a:	c0 
c010388b:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103892:	00 
c0103893:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c010389a:	e8 59 d4 ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c010389f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038a6:	e8 bf 06 00 00       	call   c0103f6a <alloc_pages>
c01038ab:	85 c0                	test   %eax,%eax
c01038ad:	74 24                	je     c01038d3 <default_check+0x32d>
c01038af:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c01038b6:	c0 
c01038b7:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01038be:	c0 
c01038bf:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01038c6:	00 
c01038c7:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01038ce:	e8 25 d4 ff ff       	call   c0100cf8 <__panic>
    assert(p0 + 2 == p1);
c01038d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038d6:	83 c0 28             	add    $0x28,%eax
c01038d9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01038dc:	74 24                	je     c0103902 <default_check+0x35c>
c01038de:	c7 44 24 0c 86 69 10 	movl   $0xc0106986,0xc(%esp)
c01038e5:	c0 
c01038e6:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01038ed:	c0 
c01038ee:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01038f5:	00 
c01038f6:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01038fd:	e8 f6 d3 ff ff       	call   c0100cf8 <__panic>

    p2 = p0 + 1;
c0103902:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103905:	83 c0 14             	add    $0x14,%eax
c0103908:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010390b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103912:	00 
c0103913:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103916:	89 04 24             	mov    %eax,(%esp)
c0103919:	e8 86 06 00 00       	call   c0103fa4 <free_pages>
    free_pages(p1, 3);
c010391e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103925:	00 
c0103926:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103929:	89 04 24             	mov    %eax,(%esp)
c010392c:	e8 73 06 00 00       	call   c0103fa4 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103931:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103934:	83 c0 04             	add    $0x4,%eax
c0103937:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010393e:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103941:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103944:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103947:	0f a3 10             	bt     %edx,(%eax)
c010394a:	19 c0                	sbb    %eax,%eax
c010394c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010394f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103953:	0f 95 c0             	setne  %al
c0103956:	0f b6 c0             	movzbl %al,%eax
c0103959:	85 c0                	test   %eax,%eax
c010395b:	74 0b                	je     c0103968 <default_check+0x3c2>
c010395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103960:	8b 40 08             	mov    0x8(%eax),%eax
c0103963:	83 f8 01             	cmp    $0x1,%eax
c0103966:	74 24                	je     c010398c <default_check+0x3e6>
c0103968:	c7 44 24 0c 94 69 10 	movl   $0xc0106994,0xc(%esp)
c010396f:	c0 
c0103970:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103977:	c0 
c0103978:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010397f:	00 
c0103980:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103987:	e8 6c d3 ff ff       	call   c0100cf8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010398c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010398f:	83 c0 04             	add    $0x4,%eax
c0103992:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103999:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010399c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010399f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01039a2:	0f a3 10             	bt     %edx,(%eax)
c01039a5:	19 c0                	sbb    %eax,%eax
c01039a7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01039aa:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01039ae:	0f 95 c0             	setne  %al
c01039b1:	0f b6 c0             	movzbl %al,%eax
c01039b4:	85 c0                	test   %eax,%eax
c01039b6:	74 0b                	je     c01039c3 <default_check+0x41d>
c01039b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039bb:	8b 40 08             	mov    0x8(%eax),%eax
c01039be:	83 f8 03             	cmp    $0x3,%eax
c01039c1:	74 24                	je     c01039e7 <default_check+0x441>
c01039c3:	c7 44 24 0c bc 69 10 	movl   $0xc01069bc,0xc(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01039da:	00 
c01039db:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c01039e2:	e8 11 d3 ff ff       	call   c0100cf8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039ee:	e8 77 05 00 00       	call   c0103f6a <alloc_pages>
c01039f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039f9:	83 e8 14             	sub    $0x14,%eax
c01039fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039ff:	74 24                	je     c0103a25 <default_check+0x47f>
c0103a01:	c7 44 24 0c e2 69 10 	movl   $0xc01069e2,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103a20:	e8 d3 d2 ff ff       	call   c0100cf8 <__panic>
    free_page(p0);
c0103a25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a2c:	00 
c0103a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a30:	89 04 24             	mov    %eax,(%esp)
c0103a33:	e8 6c 05 00 00       	call   c0103fa4 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a38:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a3f:	e8 26 05 00 00       	call   c0103f6a <alloc_pages>
c0103a44:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a4a:	83 c0 14             	add    $0x14,%eax
c0103a4d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a50:	74 24                	je     c0103a76 <default_check+0x4d0>
c0103a52:	c7 44 24 0c 00 6a 10 	movl   $0xc0106a00,0xc(%esp)
c0103a59:	c0 
c0103a5a:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103a61:	c0 
c0103a62:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0103a69:	00 
c0103a6a:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103a71:	e8 82 d2 ff ff       	call   c0100cf8 <__panic>

    free_pages(p0, 2);
c0103a76:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a7d:	00 
c0103a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a81:	89 04 24             	mov    %eax,(%esp)
c0103a84:	e8 1b 05 00 00       	call   c0103fa4 <free_pages>
    free_page(p2);
c0103a89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a90:	00 
c0103a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a94:	89 04 24             	mov    %eax,(%esp)
c0103a97:	e8 08 05 00 00       	call   c0103fa4 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a9c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103aa3:	e8 c2 04 00 00       	call   c0103f6a <alloc_pages>
c0103aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103aab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103aaf:	75 24                	jne    c0103ad5 <default_check+0x52f>
c0103ab1:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c0103ab8:	c0 
c0103ab9:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103ac0:	c0 
c0103ac1:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103ac8:	00 
c0103ac9:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103ad0:	e8 23 d2 ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c0103ad5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103adc:	e8 89 04 00 00       	call   c0103f6a <alloc_pages>
c0103ae1:	85 c0                	test   %eax,%eax
c0103ae3:	74 24                	je     c0103b09 <default_check+0x563>
c0103ae5:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103aec:	c0 
c0103aed:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103af4:	c0 
c0103af5:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0103afc:	00 
c0103afd:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103b04:	e8 ef d1 ff ff       	call   c0100cf8 <__panic>

    assert(nr_free == 0);
c0103b09:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103b0e:	85 c0                	test   %eax,%eax
c0103b10:	74 24                	je     c0103b36 <default_check+0x590>
c0103b12:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c0103b19:	c0 
c0103b1a:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103b21:	c0 
c0103b22:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103b29:	00 
c0103b2a:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103b31:	e8 c2 d1 ff ff       	call   c0100cf8 <__panic>
    nr_free = nr_free_store;
c0103b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b39:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c0103b3e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b41:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b44:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103b49:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c0103b4f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b56:	00 
c0103b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b5a:	89 04 24             	mov    %eax,(%esp)
c0103b5d:	e8 42 04 00 00       	call   c0103fa4 <free_pages>

    le = &free_list;
c0103b62:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103b69:	eb 5a                	jmp    c0103bc5 <default_check+0x61f>
    {
        assert(le->next->prev == le && le->prev->next == le);
c0103b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b6e:	8b 40 04             	mov    0x4(%eax),%eax
c0103b71:	8b 00                	mov    (%eax),%eax
c0103b73:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b76:	75 0d                	jne    c0103b85 <default_check+0x5df>
c0103b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7b:	8b 00                	mov    (%eax),%eax
c0103b7d:	8b 40 04             	mov    0x4(%eax),%eax
c0103b80:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b83:	74 24                	je     c0103ba9 <default_check+0x603>
c0103b85:	c7 44 24 0c 40 6a 10 	movl   $0xc0106a40,0xc(%esp)
c0103b8c:	c0 
c0103b8d:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103b94:	c0 
c0103b95:	c7 44 24 04 4e 01 00 	movl   $0x14e,0x4(%esp)
c0103b9c:	00 
c0103b9d:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103ba4:	e8 4f d1 ff ff       	call   c0100cf8 <__panic>
        struct Page *p = le2page(le, page_link);
c0103ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bac:	83 e8 0c             	sub    $0xc,%eax
c0103baf:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0103bb2:	ff 4d f4             	decl   -0xc(%ebp)
c0103bb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103bb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bbb:	8b 48 08             	mov    0x8(%eax),%ecx
c0103bbe:	89 d0                	mov    %edx,%eax
c0103bc0:	29 c8                	sub    %ecx,%eax
c0103bc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bc8:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103bcb:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bd4:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103bdb:	75 8e                	jne    c0103b6b <default_check+0x5c5>
    }
    assert(count == 0);
c0103bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103be1:	74 24                	je     c0103c07 <default_check+0x661>
c0103be3:	c7 44 24 0c 6d 6a 10 	movl   $0xc0106a6d,0xc(%esp)
c0103bea:	c0 
c0103beb:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103bf2:	c0 
c0103bf3:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0103bfa:	00 
c0103bfb:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103c02:	e8 f1 d0 ff ff       	call   c0100cf8 <__panic>
    assert(total == 0);
c0103c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c0b:	74 24                	je     c0103c31 <default_check+0x68b>
c0103c0d:	c7 44 24 0c 78 6a 10 	movl   $0xc0106a78,0xc(%esp)
c0103c14:	c0 
c0103c15:	c7 44 24 08 f6 66 10 	movl   $0xc01066f6,0x8(%esp)
c0103c1c:	c0 
c0103c1d:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c0103c24:	00 
c0103c25:	c7 04 24 0b 67 10 c0 	movl   $0xc010670b,(%esp)
c0103c2c:	e8 c7 d0 ff ff       	call   c0100cf8 <__panic>
}
c0103c31:	90                   	nop
c0103c32:	89 ec                	mov    %ebp,%esp
c0103c34:	5d                   	pop    %ebp
c0103c35:	c3                   	ret    

c0103c36 <page2ppn>:
page2ppn(struct Page *page) {
c0103c36:	55                   	push   %ebp
c0103c37:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c39:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c42:	29 d0                	sub    %edx,%eax
c0103c44:	c1 f8 02             	sar    $0x2,%eax
c0103c47:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c4d:	5d                   	pop    %ebp
c0103c4e:	c3                   	ret    

c0103c4f <page2pa>:
page2pa(struct Page *page) {
c0103c4f:	55                   	push   %ebp
c0103c50:	89 e5                	mov    %esp,%ebp
c0103c52:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c58:	89 04 24             	mov    %eax,(%esp)
c0103c5b:	e8 d6 ff ff ff       	call   c0103c36 <page2ppn>
c0103c60:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c63:	89 ec                	mov    %ebp,%esp
c0103c65:	5d                   	pop    %ebp
c0103c66:	c3                   	ret    

c0103c67 <pa2page>:
pa2page(uintptr_t pa) {
c0103c67:	55                   	push   %ebp
c0103c68:	89 e5                	mov    %esp,%ebp
c0103c6a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c70:	c1 e8 0c             	shr    $0xc,%eax
c0103c73:	89 c2                	mov    %eax,%edx
c0103c75:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103c7a:	39 c2                	cmp    %eax,%edx
c0103c7c:	72 1c                	jb     c0103c9a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c7e:	c7 44 24 08 b4 6a 10 	movl   $0xc0106ab4,0x8(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c8d:	00 
c0103c8e:	c7 04 24 d3 6a 10 c0 	movl   $0xc0106ad3,(%esp)
c0103c95:	e8 5e d0 ff ff       	call   c0100cf8 <__panic>
    return &pages[PPN(pa)];
c0103c9a:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca3:	c1 e8 0c             	shr    $0xc,%eax
c0103ca6:	89 c2                	mov    %eax,%edx
c0103ca8:	89 d0                	mov    %edx,%eax
c0103caa:	c1 e0 02             	shl    $0x2,%eax
c0103cad:	01 d0                	add    %edx,%eax
c0103caf:	c1 e0 02             	shl    $0x2,%eax
c0103cb2:	01 c8                	add    %ecx,%eax
}
c0103cb4:	89 ec                	mov    %ebp,%esp
c0103cb6:	5d                   	pop    %ebp
c0103cb7:	c3                   	ret    

c0103cb8 <page2kva>:
page2kva(struct Page *page) {
c0103cb8:	55                   	push   %ebp
c0103cb9:	89 e5                	mov    %esp,%ebp
c0103cbb:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc1:	89 04 24             	mov    %eax,(%esp)
c0103cc4:	e8 86 ff ff ff       	call   c0103c4f <page2pa>
c0103cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ccf:	c1 e8 0c             	shr    $0xc,%eax
c0103cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cd5:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103cda:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103cdd:	72 23                	jb     c0103d02 <page2kva+0x4a>
c0103cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ce6:	c7 44 24 08 e4 6a 10 	movl   $0xc0106ae4,0x8(%esp)
c0103ced:	c0 
c0103cee:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cf5:	00 
c0103cf6:	c7 04 24 d3 6a 10 c0 	movl   $0xc0106ad3,(%esp)
c0103cfd:	e8 f6 cf ff ff       	call   c0100cf8 <__panic>
c0103d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d05:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103d0a:	89 ec                	mov    %ebp,%esp
c0103d0c:	5d                   	pop    %ebp
c0103d0d:	c3                   	ret    

c0103d0e <pte2page>:
pte2page(pte_t pte) {
c0103d0e:	55                   	push   %ebp
c0103d0f:	89 e5                	mov    %esp,%ebp
c0103d11:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d17:	83 e0 01             	and    $0x1,%eax
c0103d1a:	85 c0                	test   %eax,%eax
c0103d1c:	75 1c                	jne    c0103d3a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103d1e:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0103d25:	c0 
c0103d26:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103d2d:	00 
c0103d2e:	c7 04 24 d3 6a 10 c0 	movl   $0xc0106ad3,(%esp)
c0103d35:	e8 be cf ff ff       	call   c0100cf8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d42:	89 04 24             	mov    %eax,(%esp)
c0103d45:	e8 1d ff ff ff       	call   c0103c67 <pa2page>
}
c0103d4a:	89 ec                	mov    %ebp,%esp
c0103d4c:	5d                   	pop    %ebp
c0103d4d:	c3                   	ret    

c0103d4e <pde2page>:
pde2page(pde_t pde) {
c0103d4e:	55                   	push   %ebp
c0103d4f:	89 e5                	mov    %esp,%ebp
c0103d51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d5c:	89 04 24             	mov    %eax,(%esp)
c0103d5f:	e8 03 ff ff ff       	call   c0103c67 <pa2page>
}
c0103d64:	89 ec                	mov    %ebp,%esp
c0103d66:	5d                   	pop    %ebp
c0103d67:	c3                   	ret    

c0103d68 <page_ref>:
page_ref(struct Page *page) {
c0103d68:	55                   	push   %ebp
c0103d69:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6e:	8b 00                	mov    (%eax),%eax
}
c0103d70:	5d                   	pop    %ebp
c0103d71:	c3                   	ret    

c0103d72 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d72:	55                   	push   %ebp
c0103d73:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d78:	8b 00                	mov    (%eax),%eax
c0103d7a:	8d 50 01             	lea    0x1(%eax),%edx
c0103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d80:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d85:	8b 00                	mov    (%eax),%eax
}
c0103d87:	5d                   	pop    %ebp
c0103d88:	c3                   	ret    

c0103d89 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d89:	55                   	push   %ebp
c0103d8a:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8f:	8b 00                	mov    (%eax),%eax
c0103d91:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d97:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9c:	8b 00                	mov    (%eax),%eax
}
c0103d9e:	5d                   	pop    %ebp
c0103d9f:	c3                   	ret    

c0103da0 <__intr_save>:
__intr_save(void) {
c0103da0:	55                   	push   %ebp
c0103da1:	89 e5                	mov    %esp,%ebp
c0103da3:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103da6:	9c                   	pushf  
c0103da7:	58                   	pop    %eax
c0103da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103dae:	25 00 02 00 00       	and    $0x200,%eax
c0103db3:	85 c0                	test   %eax,%eax
c0103db5:	74 0c                	je     c0103dc3 <__intr_save+0x23>
        intr_disable();
c0103db7:	e8 95 d9 ff ff       	call   c0101751 <intr_disable>
        return 1;
c0103dbc:	b8 01 00 00 00       	mov    $0x1,%eax
c0103dc1:	eb 05                	jmp    c0103dc8 <__intr_save+0x28>
    return 0;
c0103dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103dc8:	89 ec                	mov    %ebp,%esp
c0103dca:	5d                   	pop    %ebp
c0103dcb:	c3                   	ret    

c0103dcc <__intr_restore>:
__intr_restore(bool flag) {
c0103dcc:	55                   	push   %ebp
c0103dcd:	89 e5                	mov    %esp,%ebp
c0103dcf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103dd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103dd6:	74 05                	je     c0103ddd <__intr_restore+0x11>
        intr_enable();
c0103dd8:	e8 6c d9 ff ff       	call   c0101749 <intr_enable>
}
c0103ddd:	90                   	nop
c0103dde:	89 ec                	mov    %ebp,%esp
c0103de0:	5d                   	pop    %ebp
c0103de1:	c3                   	ret    

c0103de2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103de2:	55                   	push   %ebp
c0103de3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103de8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103deb:	b8 23 00 00 00       	mov    $0x23,%eax
c0103df0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103df2:	b8 23 00 00 00       	mov    $0x23,%eax
c0103df7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103df9:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dfe:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103e00:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e05:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103e07:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e0c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103e0e:	ea 15 3e 10 c0 08 00 	ljmp   $0x8,$0xc0103e15
}
c0103e15:	90                   	nop
c0103e16:	5d                   	pop    %ebp
c0103e17:	c3                   	ret    

c0103e18 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103e18:	55                   	push   %ebp
c0103e19:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e1e:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103e23:	90                   	nop
c0103e24:	5d                   	pop    %ebp
c0103e25:	c3                   	ret    

c0103e26 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e26:	55                   	push   %ebp
c0103e27:	89 e5                	mov    %esp,%ebp
c0103e29:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103e2c:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103e31:	89 04 24             	mov    %eax,(%esp)
c0103e34:	e8 df ff ff ff       	call   c0103e18 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e39:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103e40:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e42:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103e49:	68 00 
c0103e4b:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e50:	0f b7 c0             	movzwl %ax,%eax
c0103e53:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103e59:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103e5e:	c1 e8 10             	shr    $0x10,%eax
c0103e61:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103e66:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e6d:	24 f0                	and    $0xf0,%al
c0103e6f:	0c 09                	or     $0x9,%al
c0103e71:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e76:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e7d:	24 ef                	and    $0xef,%al
c0103e7f:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e84:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e8b:	24 9f                	and    $0x9f,%al
c0103e8d:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e92:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e99:	0c 80                	or     $0x80,%al
c0103e9b:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ea0:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ea7:	24 f0                	and    $0xf0,%al
c0103ea9:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eae:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103eb5:	24 ef                	and    $0xef,%al
c0103eb7:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ebc:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ec3:	24 df                	and    $0xdf,%al
c0103ec5:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eca:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ed1:	0c 40                	or     $0x40,%al
c0103ed3:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ed8:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103edf:	24 7f                	and    $0x7f,%al
c0103ee1:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ee6:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103eeb:	c1 e8 18             	shr    $0x18,%eax
c0103eee:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ef3:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103efa:	e8 e3 fe ff ff       	call   c0103de2 <lgdt>
c0103eff:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103f05:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103f09:	0f 00 d8             	ltr    %ax
}
c0103f0c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103f0d:	90                   	nop
c0103f0e:	89 ec                	mov    %ebp,%esp
c0103f10:	5d                   	pop    %ebp
c0103f11:	c3                   	ret    

c0103f12 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103f12:	55                   	push   %ebp
c0103f13:	89 e5                	mov    %esp,%ebp
c0103f15:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103f18:	c7 05 ac be 11 c0 98 	movl   $0xc0106a98,0xc011beac
c0103f1f:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f22:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f27:	8b 00                	mov    (%eax),%eax
c0103f29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f2d:	c7 04 24 34 6b 10 c0 	movl   $0xc0106b34,(%esp)
c0103f34:	e8 2c c4 ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c0103f39:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f3e:	8b 40 04             	mov    0x4(%eax),%eax
c0103f41:	ff d0                	call   *%eax
}
c0103f43:	90                   	nop
c0103f44:	89 ec                	mov    %ebp,%esp
c0103f46:	5d                   	pop    %ebp
c0103f47:	c3                   	ret    

c0103f48 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f48:	55                   	push   %ebp
c0103f49:	89 e5                	mov    %esp,%ebp
c0103f4b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f4e:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f53:	8b 40 08             	mov    0x8(%eax),%eax
c0103f56:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f59:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f5d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f60:	89 14 24             	mov    %edx,(%esp)
c0103f63:	ff d0                	call   *%eax
}
c0103f65:	90                   	nop
c0103f66:	89 ec                	mov    %ebp,%esp
c0103f68:	5d                   	pop    %ebp
c0103f69:	c3                   	ret    

c0103f6a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f6a:	55                   	push   %ebp
c0103f6b:	89 e5                	mov    %esp,%ebp
c0103f6d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f77:	e8 24 fe ff ff       	call   c0103da0 <__intr_save>
c0103f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f7f:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103f84:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f87:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f8a:	89 14 24             	mov    %edx,(%esp)
c0103f8d:	ff d0                	call   *%eax
c0103f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f95:	89 04 24             	mov    %eax,(%esp)
c0103f98:	e8 2f fe ff ff       	call   c0103dcc <__intr_restore>
    return page;
c0103f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103fa0:	89 ec                	mov    %ebp,%esp
c0103fa2:	5d                   	pop    %ebp
c0103fa3:	c3                   	ret    

c0103fa4 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103fa4:	55                   	push   %ebp
c0103fa5:	89 e5                	mov    %esp,%ebp
c0103fa7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103faa:	e8 f1 fd ff ff       	call   c0103da0 <__intr_save>
c0103faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103fb2:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103fb7:	8b 40 10             	mov    0x10(%eax),%eax
c0103fba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fc1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fc4:	89 14 24             	mov    %edx,(%esp)
c0103fc7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fcc:	89 04 24             	mov    %eax,(%esp)
c0103fcf:	e8 f8 fd ff ff       	call   c0103dcc <__intr_restore>
}
c0103fd4:	90                   	nop
c0103fd5:	89 ec                	mov    %ebp,%esp
c0103fd7:	5d                   	pop    %ebp
c0103fd8:	c3                   	ret    

c0103fd9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fd9:	55                   	push   %ebp
c0103fda:	89 e5                	mov    %esp,%ebp
c0103fdc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fdf:	e8 bc fd ff ff       	call   c0103da0 <__intr_save>
c0103fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fe7:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103fec:	8b 40 14             	mov    0x14(%eax),%eax
c0103fef:	ff d0                	call   *%eax
c0103ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff7:	89 04 24             	mov    %eax,(%esp)
c0103ffa:	e8 cd fd ff ff       	call   c0103dcc <__intr_restore>
    return ret;
c0103fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104002:	89 ec                	mov    %ebp,%esp
c0104004:	5d                   	pop    %ebp
c0104005:	c3                   	ret    

c0104006 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104006:	55                   	push   %ebp
c0104007:	89 e5                	mov    %esp,%ebp
c0104009:	57                   	push   %edi
c010400a:	56                   	push   %esi
c010400b:	53                   	push   %ebx
c010400c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104012:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104019:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104020:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104027:	c7 04 24 4b 6b 10 c0 	movl   $0xc0106b4b,(%esp)
c010402e:	e8 32 c3 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104033:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010403a:	e9 0c 01 00 00       	jmp    c010414b <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010403f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104042:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104045:	89 d0                	mov    %edx,%eax
c0104047:	c1 e0 02             	shl    $0x2,%eax
c010404a:	01 d0                	add    %edx,%eax
c010404c:	c1 e0 02             	shl    $0x2,%eax
c010404f:	01 c8                	add    %ecx,%eax
c0104051:	8b 50 08             	mov    0x8(%eax),%edx
c0104054:	8b 40 04             	mov    0x4(%eax),%eax
c0104057:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010405a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010405d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104060:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104063:	89 d0                	mov    %edx,%eax
c0104065:	c1 e0 02             	shl    $0x2,%eax
c0104068:	01 d0                	add    %edx,%eax
c010406a:	c1 e0 02             	shl    $0x2,%eax
c010406d:	01 c8                	add    %ecx,%eax
c010406f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104072:	8b 58 10             	mov    0x10(%eax),%ebx
c0104075:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104078:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010407b:	01 c8                	add    %ecx,%eax
c010407d:	11 da                	adc    %ebx,%edx
c010407f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104082:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104085:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104088:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010408b:	89 d0                	mov    %edx,%eax
c010408d:	c1 e0 02             	shl    $0x2,%eax
c0104090:	01 d0                	add    %edx,%eax
c0104092:	c1 e0 02             	shl    $0x2,%eax
c0104095:	01 c8                	add    %ecx,%eax
c0104097:	83 c0 14             	add    $0x14,%eax
c010409a:	8b 00                	mov    (%eax),%eax
c010409c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01040a2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040a5:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01040a8:	83 c0 ff             	add    $0xffffffff,%eax
c01040ab:	83 d2 ff             	adc    $0xffffffff,%edx
c01040ae:	89 c6                	mov    %eax,%esi
c01040b0:	89 d7                	mov    %edx,%edi
c01040b2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040b8:	89 d0                	mov    %edx,%eax
c01040ba:	c1 e0 02             	shl    $0x2,%eax
c01040bd:	01 d0                	add    %edx,%eax
c01040bf:	c1 e0 02             	shl    $0x2,%eax
c01040c2:	01 c8                	add    %ecx,%eax
c01040c4:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040c7:	8b 58 10             	mov    0x10(%eax),%ebx
c01040ca:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01040d0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040d4:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040d8:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040dc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040df:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01040e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040e6:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040f2:	c7 04 24 58 6b 10 c0 	movl   $0xc0106b58,(%esp)
c01040f9:	e8 67 c2 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040fe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104101:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104104:	89 d0                	mov    %edx,%eax
c0104106:	c1 e0 02             	shl    $0x2,%eax
c0104109:	01 d0                	add    %edx,%eax
c010410b:	c1 e0 02             	shl    $0x2,%eax
c010410e:	01 c8                	add    %ecx,%eax
c0104110:	83 c0 14             	add    $0x14,%eax
c0104113:	8b 00                	mov    (%eax),%eax
c0104115:	83 f8 01             	cmp    $0x1,%eax
c0104118:	75 2e                	jne    c0104148 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c010411a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010411d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104120:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104123:	89 d0                	mov    %edx,%eax
c0104125:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104128:	73 1e                	jae    c0104148 <page_init+0x142>
c010412a:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c010412f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104134:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104137:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c010413a:	72 0c                	jb     c0104148 <page_init+0x142>
                maxpa = end;
c010413c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010413f:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104142:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104145:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104148:	ff 45 dc             	incl   -0x24(%ebp)
c010414b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010414e:	8b 00                	mov    (%eax),%eax
c0104150:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104153:	0f 8c e6 fe ff ff    	jl     c010403f <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104159:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010415e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104163:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104166:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104169:	73 0e                	jae    c0104179 <page_init+0x173>
        maxpa = KMEMSIZE;
c010416b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104172:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104179:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010417c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010417f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104183:	c1 ea 0c             	shr    $0xc,%edx
c0104186:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010418b:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104192:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0104197:	8d 50 ff             	lea    -0x1(%eax),%edx
c010419a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010419d:	01 d0                	add    %edx,%eax
c010419f:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01041a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041a5:	ba 00 00 00 00       	mov    $0x0,%edx
c01041aa:	f7 75 c0             	divl   -0x40(%ebp)
c01041ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041b0:	29 d0                	sub    %edx,%eax
c01041b2:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c01041b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041be:	eb 2f                	jmp    c01041ef <page_init+0x1e9>
        SetPageReserved(pages + i);
c01041c0:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c01041c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041c9:	89 d0                	mov    %edx,%eax
c01041cb:	c1 e0 02             	shl    $0x2,%eax
c01041ce:	01 d0                	add    %edx,%eax
c01041d0:	c1 e0 02             	shl    $0x2,%eax
c01041d3:	01 c8                	add    %ecx,%eax
c01041d5:	83 c0 04             	add    $0x4,%eax
c01041d8:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01041df:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041e2:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041e5:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041e8:	0f ab 10             	bts    %edx,(%eax)
}
c01041eb:	90                   	nop
    for (i = 0; i < npage; i ++) {
c01041ec:	ff 45 dc             	incl   -0x24(%ebp)
c01041ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041f2:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01041f7:	39 c2                	cmp    %eax,%edx
c01041f9:	72 c5                	jb     c01041c0 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041fb:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0104201:	89 d0                	mov    %edx,%eax
c0104203:	c1 e0 02             	shl    $0x2,%eax
c0104206:	01 d0                	add    %edx,%eax
c0104208:	c1 e0 02             	shl    $0x2,%eax
c010420b:	89 c2                	mov    %eax,%edx
c010420d:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c0104212:	01 d0                	add    %edx,%eax
c0104214:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104217:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010421e:	77 23                	ja     c0104243 <page_init+0x23d>
c0104220:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104223:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104227:	c7 44 24 08 88 6b 10 	movl   $0xc0106b88,0x8(%esp)
c010422e:	c0 
c010422f:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104236:	00 
c0104237:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010423e:	e8 b5 ca ff ff       	call   c0100cf8 <__panic>
c0104243:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104246:	05 00 00 00 40       	add    $0x40000000,%eax
c010424b:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010424e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104255:	e9 53 01 00 00       	jmp    c01043ad <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010425a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010425d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104260:	89 d0                	mov    %edx,%eax
c0104262:	c1 e0 02             	shl    $0x2,%eax
c0104265:	01 d0                	add    %edx,%eax
c0104267:	c1 e0 02             	shl    $0x2,%eax
c010426a:	01 c8                	add    %ecx,%eax
c010426c:	8b 50 08             	mov    0x8(%eax),%edx
c010426f:	8b 40 04             	mov    0x4(%eax),%eax
c0104272:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104275:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104278:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010427b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010427e:	89 d0                	mov    %edx,%eax
c0104280:	c1 e0 02             	shl    $0x2,%eax
c0104283:	01 d0                	add    %edx,%eax
c0104285:	c1 e0 02             	shl    $0x2,%eax
c0104288:	01 c8                	add    %ecx,%eax
c010428a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010428d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104290:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104293:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104296:	01 c8                	add    %ecx,%eax
c0104298:	11 da                	adc    %ebx,%edx
c010429a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010429d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01042a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01042a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042a6:	89 d0                	mov    %edx,%eax
c01042a8:	c1 e0 02             	shl    $0x2,%eax
c01042ab:	01 d0                	add    %edx,%eax
c01042ad:	c1 e0 02             	shl    $0x2,%eax
c01042b0:	01 c8                	add    %ecx,%eax
c01042b2:	83 c0 14             	add    $0x14,%eax
c01042b5:	8b 00                	mov    (%eax),%eax
c01042b7:	83 f8 01             	cmp    $0x1,%eax
c01042ba:	0f 85 ea 00 00 00    	jne    c01043aa <page_init+0x3a4>
            if (begin < freemem) {
c01042c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042c3:	ba 00 00 00 00       	mov    $0x0,%edx
c01042c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01042cb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01042ce:	19 d1                	sbb    %edx,%ecx
c01042d0:	73 0d                	jae    c01042df <page_init+0x2d9>
                begin = freemem;
c01042d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042df:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01042e4:	b8 00 00 00 00       	mov    $0x0,%eax
c01042e9:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01042ec:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042ef:	73 0e                	jae    c01042ff <page_init+0x2f9>
                end = KMEMSIZE;
c01042f1:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042f8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104302:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104305:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104308:	89 d0                	mov    %edx,%eax
c010430a:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010430d:	0f 83 97 00 00 00    	jae    c01043aa <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c0104313:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010431a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010431d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104320:	01 d0                	add    %edx,%eax
c0104322:	48                   	dec    %eax
c0104323:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104326:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104329:	ba 00 00 00 00       	mov    $0x0,%edx
c010432e:	f7 75 b0             	divl   -0x50(%ebp)
c0104331:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104334:	29 d0                	sub    %edx,%eax
c0104336:	ba 00 00 00 00       	mov    $0x0,%edx
c010433b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010433e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104341:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104344:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104347:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010434a:	ba 00 00 00 00       	mov    $0x0,%edx
c010434f:	89 c7                	mov    %eax,%edi
c0104351:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104357:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010435a:	89 d0                	mov    %edx,%eax
c010435c:	83 e0 00             	and    $0x0,%eax
c010435f:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104362:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104365:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104368:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010436b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010436e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104371:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104374:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104377:	89 d0                	mov    %edx,%eax
c0104379:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010437c:	73 2c                	jae    c01043aa <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010437e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104381:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104384:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104387:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010438a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010438e:	c1 ea 0c             	shr    $0xc,%edx
c0104391:	89 c3                	mov    %eax,%ebx
c0104393:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104396:	89 04 24             	mov    %eax,(%esp)
c0104399:	e8 c9 f8 ff ff       	call   c0103c67 <pa2page>
c010439e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01043a2:	89 04 24             	mov    %eax,(%esp)
c01043a5:	e8 9e fb ff ff       	call   c0103f48 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01043aa:	ff 45 dc             	incl   -0x24(%ebp)
c01043ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043b0:	8b 00                	mov    (%eax),%eax
c01043b2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01043b5:	0f 8c 9f fe ff ff    	jl     c010425a <page_init+0x254>
                }
            }
        }
    }
}
c01043bb:	90                   	nop
c01043bc:	90                   	nop
c01043bd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043c3:	5b                   	pop    %ebx
c01043c4:	5e                   	pop    %esi
c01043c5:	5f                   	pop    %edi
c01043c6:	5d                   	pop    %ebp
c01043c7:	c3                   	ret    

c01043c8 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01043c8:	55                   	push   %ebp
c01043c9:	89 e5                	mov    %esp,%ebp
c01043cb:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01043ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043d1:	33 45 14             	xor    0x14(%ebp),%eax
c01043d4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043d9:	85 c0                	test   %eax,%eax
c01043db:	74 24                	je     c0104401 <boot_map_segment+0x39>
c01043dd:	c7 44 24 0c ba 6b 10 	movl   $0xc0106bba,0xc(%esp)
c01043e4:	c0 
c01043e5:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c01043ec:	c0 
c01043ed:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01043f4:	00 
c01043f5:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01043fc:	e8 f7 c8 ff ff       	call   c0100cf8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104401:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010440b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104410:	89 c2                	mov    %eax,%edx
c0104412:	8b 45 10             	mov    0x10(%ebp),%eax
c0104415:	01 c2                	add    %eax,%edx
c0104417:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010441a:	01 d0                	add    %edx,%eax
c010441c:	48                   	dec    %eax
c010441d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104420:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104423:	ba 00 00 00 00       	mov    $0x0,%edx
c0104428:	f7 75 f0             	divl   -0x10(%ebp)
c010442b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010442e:	29 d0                	sub    %edx,%eax
c0104430:	c1 e8 0c             	shr    $0xc,%eax
c0104433:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104439:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010443c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010443f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104444:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104447:	8b 45 14             	mov    0x14(%ebp),%eax
c010444a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010444d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104450:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104455:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104458:	eb 68                	jmp    c01044c2 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010445a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104461:	00 
c0104462:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104465:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104469:	8b 45 08             	mov    0x8(%ebp),%eax
c010446c:	89 04 24             	mov    %eax,(%esp)
c010446f:	e8 88 01 00 00       	call   c01045fc <get_pte>
c0104474:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010447b:	75 24                	jne    c01044a1 <boot_map_segment+0xd9>
c010447d:	c7 44 24 0c e6 6b 10 	movl   $0xc0106be6,0xc(%esp)
c0104484:	c0 
c0104485:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c010448c:	c0 
c010448d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104494:	00 
c0104495:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010449c:	e8 57 c8 ff ff       	call   c0100cf8 <__panic>
        *ptep = pa | PTE_P | perm;
c01044a1:	8b 45 14             	mov    0x14(%ebp),%eax
c01044a4:	0b 45 18             	or     0x18(%ebp),%eax
c01044a7:	83 c8 01             	or     $0x1,%eax
c01044aa:	89 c2                	mov    %eax,%edx
c01044ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044af:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044b1:	ff 4d f4             	decl   -0xc(%ebp)
c01044b4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01044bb:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01044c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044c6:	75 92                	jne    c010445a <boot_map_segment+0x92>
    }
}
c01044c8:	90                   	nop
c01044c9:	90                   	nop
c01044ca:	89 ec                	mov    %ebp,%esp
c01044cc:	5d                   	pop    %ebp
c01044cd:	c3                   	ret    

c01044ce <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044ce:	55                   	push   %ebp
c01044cf:	89 e5                	mov    %esp,%ebp
c01044d1:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044db:	e8 8a fa ff ff       	call   c0103f6a <alloc_pages>
c01044e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044e7:	75 1c                	jne    c0104505 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044e9:	c7 44 24 08 f3 6b 10 	movl   $0xc0106bf3,0x8(%esp)
c01044f0:	c0 
c01044f1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01044f8:	00 
c01044f9:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104500:	e8 f3 c7 ff ff       	call   c0100cf8 <__panic>
    }
    return page2kva(p);
c0104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104508:	89 04 24             	mov    %eax,(%esp)
c010450b:	e8 a8 f7 ff ff       	call   c0103cb8 <page2kva>
}
c0104510:	89 ec                	mov    %ebp,%esp
c0104512:	5d                   	pop    %ebp
c0104513:	c3                   	ret    

c0104514 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104514:	55                   	push   %ebp
c0104515:	89 e5                	mov    %esp,%ebp
c0104517:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010451a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010451f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104522:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104529:	77 23                	ja     c010454e <pmm_init+0x3a>
c010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104532:	c7 44 24 08 88 6b 10 	movl   $0xc0106b88,0x8(%esp)
c0104539:	c0 
c010453a:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104541:	00 
c0104542:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104549:	e8 aa c7 ff ff       	call   c0100cf8 <__panic>
c010454e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104551:	05 00 00 00 40       	add    $0x40000000,%eax
c0104556:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010455b:	e8 b2 f9 ff ff       	call   c0103f12 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104560:	e8 a1 fa ff ff       	call   c0104006 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104565:	e8 5a 02 00 00       	call   c01047c4 <check_alloc_page>

    check_pgdir();
c010456a:	e8 76 02 00 00       	call   c01047e5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010456f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104574:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104577:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010457e:	77 23                	ja     c01045a3 <pmm_init+0x8f>
c0104580:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104583:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104587:	c7 44 24 08 88 6b 10 	movl   $0xc0106b88,0x8(%esp)
c010458e:	c0 
c010458f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104596:	00 
c0104597:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010459e:	e8 55 c7 ff ff       	call   c0100cf8 <__panic>
c01045a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a6:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01045ac:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045b1:	05 ac 0f 00 00       	add    $0xfac,%eax
c01045b6:	83 ca 03             	or     $0x3,%edx
c01045b9:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045bb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045c0:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045c7:	00 
c01045c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045cf:	00 
c01045d0:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045d7:	38 
c01045d8:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045df:	c0 
c01045e0:	89 04 24             	mov    %eax,(%esp)
c01045e3:	e8 e0 fd ff ff       	call   c01043c8 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045e8:	e8 39 f8 ff ff       	call   c0103e26 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045ed:	e8 91 08 00 00       	call   c0104e83 <check_boot_pgdir>

    print_pgdir();
c01045f2:	e8 0e 0d 00 00       	call   c0105305 <print_pgdir>

}
c01045f7:	90                   	nop
c01045f8:	89 ec                	mov    %ebp,%esp
c01045fa:	5d                   	pop    %ebp
c01045fb:	c3                   	ret    

c01045fc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045fc:	55                   	push   %ebp
c01045fd:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01045ff:	90                   	nop
c0104600:	5d                   	pop    %ebp
c0104601:	c3                   	ret    

c0104602 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104602:	55                   	push   %ebp
c0104603:	89 e5                	mov    %esp,%ebp
c0104605:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104608:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010460f:	00 
c0104610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104617:	8b 45 08             	mov    0x8(%ebp),%eax
c010461a:	89 04 24             	mov    %eax,(%esp)
c010461d:	e8 da ff ff ff       	call   c01045fc <get_pte>
c0104622:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104629:	74 08                	je     c0104633 <get_page+0x31>
        *ptep_store = ptep;
c010462b:	8b 45 10             	mov    0x10(%ebp),%eax
c010462e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104631:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104637:	74 1b                	je     c0104654 <get_page+0x52>
c0104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463c:	8b 00                	mov    (%eax),%eax
c010463e:	83 e0 01             	and    $0x1,%eax
c0104641:	85 c0                	test   %eax,%eax
c0104643:	74 0f                	je     c0104654 <get_page+0x52>
        return pte2page(*ptep);
c0104645:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104648:	8b 00                	mov    (%eax),%eax
c010464a:	89 04 24             	mov    %eax,(%esp)
c010464d:	e8 bc f6 ff ff       	call   c0103d0e <pte2page>
c0104652:	eb 05                	jmp    c0104659 <get_page+0x57>
    }
    return NULL;
c0104654:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104659:	89 ec                	mov    %ebp,%esp
c010465b:	5d                   	pop    %ebp
c010465c:	c3                   	ret    

c010465d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010465d:	55                   	push   %ebp
c010465e:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104660:	90                   	nop
c0104661:	5d                   	pop    %ebp
c0104662:	c3                   	ret    

c0104663 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104663:	55                   	push   %ebp
c0104664:	89 e5                	mov    %esp,%ebp
c0104666:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104669:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104670:	00 
c0104671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104674:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104678:	8b 45 08             	mov    0x8(%ebp),%eax
c010467b:	89 04 24             	mov    %eax,(%esp)
c010467e:	e8 79 ff ff ff       	call   c01045fc <get_pte>
c0104683:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104686:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010468a:	74 19                	je     c01046a5 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010468c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010468f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104696:	89 44 24 04          	mov    %eax,0x4(%esp)
c010469a:	8b 45 08             	mov    0x8(%ebp),%eax
c010469d:	89 04 24             	mov    %eax,(%esp)
c01046a0:	e8 b8 ff ff ff       	call   c010465d <page_remove_pte>
    }
}
c01046a5:	90                   	nop
c01046a6:	89 ec                	mov    %ebp,%esp
c01046a8:	5d                   	pop    %ebp
c01046a9:	c3                   	ret    

c01046aa <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01046aa:	55                   	push   %ebp
c01046ab:	89 e5                	mov    %esp,%ebp
c01046ad:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01046b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046b7:	00 
c01046b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01046bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c2:	89 04 24             	mov    %eax,(%esp)
c01046c5:	e8 32 ff ff ff       	call   c01045fc <get_pte>
c01046ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046d1:	75 0a                	jne    c01046dd <page_insert+0x33>
        return -E_NO_MEM;
c01046d3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046d8:	e9 84 00 00 00       	jmp    c0104761 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e0:	89 04 24             	mov    %eax,(%esp)
c01046e3:	e8 8a f6 ff ff       	call   c0103d72 <page_ref_inc>
    if (*ptep & PTE_P) {
c01046e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046eb:	8b 00                	mov    (%eax),%eax
c01046ed:	83 e0 01             	and    $0x1,%eax
c01046f0:	85 c0                	test   %eax,%eax
c01046f2:	74 3e                	je     c0104732 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f7:	8b 00                	mov    (%eax),%eax
c01046f9:	89 04 24             	mov    %eax,(%esp)
c01046fc:	e8 0d f6 ff ff       	call   c0103d0e <pte2page>
c0104701:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104704:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104707:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010470a:	75 0d                	jne    c0104719 <page_insert+0x6f>
            page_ref_dec(page);
c010470c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010470f:	89 04 24             	mov    %eax,(%esp)
c0104712:	e8 72 f6 ff ff       	call   c0103d89 <page_ref_dec>
c0104717:	eb 19                	jmp    c0104732 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104720:	8b 45 10             	mov    0x10(%ebp),%eax
c0104723:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104727:	8b 45 08             	mov    0x8(%ebp),%eax
c010472a:	89 04 24             	mov    %eax,(%esp)
c010472d:	e8 2b ff ff ff       	call   c010465d <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104732:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104735:	89 04 24             	mov    %eax,(%esp)
c0104738:	e8 12 f5 ff ff       	call   c0103c4f <page2pa>
c010473d:	0b 45 14             	or     0x14(%ebp),%eax
c0104740:	83 c8 01             	or     $0x1,%eax
c0104743:	89 c2                	mov    %eax,%edx
c0104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104748:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010474a:	8b 45 10             	mov    0x10(%ebp),%eax
c010474d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104751:	8b 45 08             	mov    0x8(%ebp),%eax
c0104754:	89 04 24             	mov    %eax,(%esp)
c0104757:	e8 09 00 00 00       	call   c0104765 <tlb_invalidate>
    return 0;
c010475c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104761:	89 ec                	mov    %ebp,%esp
c0104763:	5d                   	pop    %ebp
c0104764:	c3                   	ret    

c0104765 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104765:	55                   	push   %ebp
c0104766:	89 e5                	mov    %esp,%ebp
c0104768:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010476b:	0f 20 d8             	mov    %cr3,%eax
c010476e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104771:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104774:	8b 45 08             	mov    0x8(%ebp),%eax
c0104777:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010477a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104781:	77 23                	ja     c01047a6 <tlb_invalidate+0x41>
c0104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104786:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010478a:	c7 44 24 08 88 6b 10 	movl   $0xc0106b88,0x8(%esp)
c0104791:	c0 
c0104792:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c0104799:	00 
c010479a:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01047a1:	e8 52 c5 ff ff       	call   c0100cf8 <__panic>
c01047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a9:	05 00 00 00 40       	add    $0x40000000,%eax
c01047ae:	39 d0                	cmp    %edx,%eax
c01047b0:	75 0d                	jne    c01047bf <tlb_invalidate+0x5a>
        invlpg((void *)la);
c01047b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01047b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047bb:	0f 01 38             	invlpg (%eax)
}
c01047be:	90                   	nop
    }
}
c01047bf:	90                   	nop
c01047c0:	89 ec                	mov    %ebp,%esp
c01047c2:	5d                   	pop    %ebp
c01047c3:	c3                   	ret    

c01047c4 <check_alloc_page>:

static void
check_alloc_page(void) {
c01047c4:	55                   	push   %ebp
c01047c5:	89 e5                	mov    %esp,%ebp
c01047c7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047ca:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c01047cf:	8b 40 18             	mov    0x18(%eax),%eax
c01047d2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047d4:	c7 04 24 0c 6c 10 c0 	movl   $0xc0106c0c,(%esp)
c01047db:	e8 85 bb ff ff       	call   c0100365 <cprintf>
}
c01047e0:	90                   	nop
c01047e1:	89 ec                	mov    %ebp,%esp
c01047e3:	5d                   	pop    %ebp
c01047e4:	c3                   	ret    

c01047e5 <check_pgdir>:

static void
check_pgdir(void) {
c01047e5:	55                   	push   %ebp
c01047e6:	89 e5                	mov    %esp,%ebp
c01047e8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047eb:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01047f0:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047f5:	76 24                	jbe    c010481b <check_pgdir+0x36>
c01047f7:	c7 44 24 0c 2b 6c 10 	movl   $0xc0106c2b,0xc(%esp)
c01047fe:	c0 
c01047ff:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104806:	c0 
c0104807:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c010480e:	00 
c010480f:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104816:	e8 dd c4 ff ff       	call   c0100cf8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010481b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104820:	85 c0                	test   %eax,%eax
c0104822:	74 0e                	je     c0104832 <check_pgdir+0x4d>
c0104824:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104829:	25 ff 0f 00 00       	and    $0xfff,%eax
c010482e:	85 c0                	test   %eax,%eax
c0104830:	74 24                	je     c0104856 <check_pgdir+0x71>
c0104832:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c0104839:	c0 
c010483a:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104841:	c0 
c0104842:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0104849:	00 
c010484a:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104851:	e8 a2 c4 ff ff       	call   c0100cf8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104856:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010485b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104862:	00 
c0104863:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010486a:	00 
c010486b:	89 04 24             	mov    %eax,(%esp)
c010486e:	e8 8f fd ff ff       	call   c0104602 <get_page>
c0104873:	85 c0                	test   %eax,%eax
c0104875:	74 24                	je     c010489b <check_pgdir+0xb6>
c0104877:	c7 44 24 0c 80 6c 10 	movl   $0xc0106c80,0xc(%esp)
c010487e:	c0 
c010487f:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104886:	c0 
c0104887:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c010488e:	00 
c010488f:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104896:	e8 5d c4 ff ff       	call   c0100cf8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010489b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048a2:	e8 c3 f6 ff ff       	call   c0103f6a <alloc_pages>
c01048a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01048aa:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048af:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048b6:	00 
c01048b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048be:	00 
c01048bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048c6:	89 04 24             	mov    %eax,(%esp)
c01048c9:	e8 dc fd ff ff       	call   c01046aa <page_insert>
c01048ce:	85 c0                	test   %eax,%eax
c01048d0:	74 24                	je     c01048f6 <check_pgdir+0x111>
c01048d2:	c7 44 24 0c a8 6c 10 	movl   $0xc0106ca8,0xc(%esp)
c01048d9:	c0 
c01048da:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c01048e1:	c0 
c01048e2:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01048e9:	00 
c01048ea:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01048f1:	e8 02 c4 ff ff       	call   c0100cf8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048f6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104902:	00 
c0104903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010490a:	00 
c010490b:	89 04 24             	mov    %eax,(%esp)
c010490e:	e8 e9 fc ff ff       	call   c01045fc <get_pte>
c0104913:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104916:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010491a:	75 24                	jne    c0104940 <check_pgdir+0x15b>
c010491c:	c7 44 24 0c d4 6c 10 	movl   $0xc0106cd4,0xc(%esp)
c0104923:	c0 
c0104924:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c010492b:	c0 
c010492c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0104933:	00 
c0104934:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010493b:	e8 b8 c3 ff ff       	call   c0100cf8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104940:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104943:	8b 00                	mov    (%eax),%eax
c0104945:	89 04 24             	mov    %eax,(%esp)
c0104948:	e8 c1 f3 ff ff       	call   c0103d0e <pte2page>
c010494d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104950:	74 24                	je     c0104976 <check_pgdir+0x191>
c0104952:	c7 44 24 0c 01 6d 10 	movl   $0xc0106d01,0xc(%esp)
c0104959:	c0 
c010495a:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104961:	c0 
c0104962:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0104969:	00 
c010496a:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104971:	e8 82 c3 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p1) == 1);
c0104976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104979:	89 04 24             	mov    %eax,(%esp)
c010497c:	e8 e7 f3 ff ff       	call   c0103d68 <page_ref>
c0104981:	83 f8 01             	cmp    $0x1,%eax
c0104984:	74 24                	je     c01049aa <check_pgdir+0x1c5>
c0104986:	c7 44 24 0c 17 6d 10 	movl   $0xc0106d17,0xc(%esp)
c010498d:	c0 
c010498e:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104995:	c0 
c0104996:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010499d:	00 
c010499e:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01049a5:	e8 4e c3 ff ff       	call   c0100cf8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01049aa:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049af:	8b 00                	mov    (%eax),%eax
c01049b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049bc:	c1 e8 0c             	shr    $0xc,%eax
c01049bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049c2:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01049c7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049ca:	72 23                	jb     c01049ef <check_pgdir+0x20a>
c01049cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049d3:	c7 44 24 08 e4 6a 10 	movl   $0xc0106ae4,0x8(%esp)
c01049da:	c0 
c01049db:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01049e2:	00 
c01049e3:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01049ea:	e8 09 c3 ff ff       	call   c0100cf8 <__panic>
c01049ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049f2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049f7:	83 c0 04             	add    $0x4,%eax
c01049fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049fd:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a09:	00 
c0104a0a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a11:	00 
c0104a12:	89 04 24             	mov    %eax,(%esp)
c0104a15:	e8 e2 fb ff ff       	call   c01045fc <get_pte>
c0104a1a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a1d:	74 24                	je     c0104a43 <check_pgdir+0x25e>
c0104a1f:	c7 44 24 0c 2c 6d 10 	movl   $0xc0106d2c,0xc(%esp)
c0104a26:	c0 
c0104a27:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104a2e:	c0 
c0104a2f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0104a36:	00 
c0104a37:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104a3e:	e8 b5 c2 ff ff       	call   c0100cf8 <__panic>

    p2 = alloc_page();
c0104a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a4a:	e8 1b f5 ff ff       	call   c0103f6a <alloc_pages>
c0104a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a52:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a5e:	00 
c0104a5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a66:	00 
c0104a67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a6e:	89 04 24             	mov    %eax,(%esp)
c0104a71:	e8 34 fc ff ff       	call   c01046aa <page_insert>
c0104a76:	85 c0                	test   %eax,%eax
c0104a78:	74 24                	je     c0104a9e <check_pgdir+0x2b9>
c0104a7a:	c7 44 24 0c 54 6d 10 	movl   $0xc0106d54,0xc(%esp)
c0104a81:	c0 
c0104a82:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104a89:	c0 
c0104a8a:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0104a91:	00 
c0104a92:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104a99:	e8 5a c2 ff ff       	call   c0100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a9e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104aa3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aaa:	00 
c0104aab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ab2:	00 
c0104ab3:	89 04 24             	mov    %eax,(%esp)
c0104ab6:	e8 41 fb ff ff       	call   c01045fc <get_pte>
c0104abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ac2:	75 24                	jne    c0104ae8 <check_pgdir+0x303>
c0104ac4:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c0104acb:	c0 
c0104acc:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104ad3:	c0 
c0104ad4:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0104adb:	00 
c0104adc:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104ae3:	e8 10 c2 ff ff       	call   c0100cf8 <__panic>
    assert(*ptep & PTE_U);
c0104ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aeb:	8b 00                	mov    (%eax),%eax
c0104aed:	83 e0 04             	and    $0x4,%eax
c0104af0:	85 c0                	test   %eax,%eax
c0104af2:	75 24                	jne    c0104b18 <check_pgdir+0x333>
c0104af4:	c7 44 24 0c bc 6d 10 	movl   $0xc0106dbc,0xc(%esp)
c0104afb:	c0 
c0104afc:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104b03:	c0 
c0104b04:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104b0b:	00 
c0104b0c:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104b13:	e8 e0 c1 ff ff       	call   c0100cf8 <__panic>
    assert(*ptep & PTE_W);
c0104b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b1b:	8b 00                	mov    (%eax),%eax
c0104b1d:	83 e0 02             	and    $0x2,%eax
c0104b20:	85 c0                	test   %eax,%eax
c0104b22:	75 24                	jne    c0104b48 <check_pgdir+0x363>
c0104b24:	c7 44 24 0c ca 6d 10 	movl   $0xc0106dca,0xc(%esp)
c0104b2b:	c0 
c0104b2c:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104b33:	c0 
c0104b34:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104b3b:	00 
c0104b3c:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104b43:	e8 b0 c1 ff ff       	call   c0100cf8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b48:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b4d:	8b 00                	mov    (%eax),%eax
c0104b4f:	83 e0 04             	and    $0x4,%eax
c0104b52:	85 c0                	test   %eax,%eax
c0104b54:	75 24                	jne    c0104b7a <check_pgdir+0x395>
c0104b56:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c0104b5d:	c0 
c0104b5e:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104b65:	c0 
c0104b66:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104b6d:	00 
c0104b6e:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104b75:	e8 7e c1 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 1);
c0104b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b7d:	89 04 24             	mov    %eax,(%esp)
c0104b80:	e8 e3 f1 ff ff       	call   c0103d68 <page_ref>
c0104b85:	83 f8 01             	cmp    $0x1,%eax
c0104b88:	74 24                	je     c0104bae <check_pgdir+0x3c9>
c0104b8a:	c7 44 24 0c ee 6d 10 	movl   $0xc0106dee,0xc(%esp)
c0104b91:	c0 
c0104b92:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104b99:	c0 
c0104b9a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104ba1:	00 
c0104ba2:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104ba9:	e8 4a c1 ff ff       	call   c0100cf8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104bae:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bba:	00 
c0104bbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bc2:	00 
c0104bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104bc6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bca:	89 04 24             	mov    %eax,(%esp)
c0104bcd:	e8 d8 fa ff ff       	call   c01046aa <page_insert>
c0104bd2:	85 c0                	test   %eax,%eax
c0104bd4:	74 24                	je     c0104bfa <check_pgdir+0x415>
c0104bd6:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104bdd:	c0 
c0104bde:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104be5:	c0 
c0104be6:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104bed:	00 
c0104bee:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104bf5:	e8 fe c0 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p1) == 2);
c0104bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bfd:	89 04 24             	mov    %eax,(%esp)
c0104c00:	e8 63 f1 ff ff       	call   c0103d68 <page_ref>
c0104c05:	83 f8 02             	cmp    $0x2,%eax
c0104c08:	74 24                	je     c0104c2e <check_pgdir+0x449>
c0104c0a:	c7 44 24 0c 2c 6e 10 	movl   $0xc0106e2c,0xc(%esp)
c0104c11:	c0 
c0104c12:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104c19:	c0 
c0104c1a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104c21:	00 
c0104c22:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104c29:	e8 ca c0 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0104c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c31:	89 04 24             	mov    %eax,(%esp)
c0104c34:	e8 2f f1 ff ff       	call   c0103d68 <page_ref>
c0104c39:	85 c0                	test   %eax,%eax
c0104c3b:	74 24                	je     c0104c61 <check_pgdir+0x47c>
c0104c3d:	c7 44 24 0c 3e 6e 10 	movl   $0xc0106e3e,0xc(%esp)
c0104c44:	c0 
c0104c45:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104c4c:	c0 
c0104c4d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104c54:	00 
c0104c55:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104c5c:	e8 97 c0 ff ff       	call   c0100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c61:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c6d:	00 
c0104c6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c75:	00 
c0104c76:	89 04 24             	mov    %eax,(%esp)
c0104c79:	e8 7e f9 ff ff       	call   c01045fc <get_pte>
c0104c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c85:	75 24                	jne    c0104cab <check_pgdir+0x4c6>
c0104c87:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c0104c8e:	c0 
c0104c8f:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104c96:	c0 
c0104c97:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104c9e:	00 
c0104c9f:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104ca6:	e8 4d c0 ff ff       	call   c0100cf8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cae:	8b 00                	mov    (%eax),%eax
c0104cb0:	89 04 24             	mov    %eax,(%esp)
c0104cb3:	e8 56 f0 ff ff       	call   c0103d0e <pte2page>
c0104cb8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104cbb:	74 24                	je     c0104ce1 <check_pgdir+0x4fc>
c0104cbd:	c7 44 24 0c 01 6d 10 	movl   $0xc0106d01,0xc(%esp)
c0104cc4:	c0 
c0104cc5:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104ccc:	c0 
c0104ccd:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104cd4:	00 
c0104cd5:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104cdc:	e8 17 c0 ff ff       	call   c0100cf8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ce4:	8b 00                	mov    (%eax),%eax
c0104ce6:	83 e0 04             	and    $0x4,%eax
c0104ce9:	85 c0                	test   %eax,%eax
c0104ceb:	74 24                	je     c0104d11 <check_pgdir+0x52c>
c0104ced:	c7 44 24 0c 50 6e 10 	movl   $0xc0106e50,0xc(%esp)
c0104cf4:	c0 
c0104cf5:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104cfc:	c0 
c0104cfd:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104d04:	00 
c0104d05:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104d0c:	e8 e7 bf ff ff       	call   c0100cf8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d11:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d1d:	00 
c0104d1e:	89 04 24             	mov    %eax,(%esp)
c0104d21:	e8 3d f9 ff ff       	call   c0104663 <page_remove>
    assert(page_ref(p1) == 1);
c0104d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d29:	89 04 24             	mov    %eax,(%esp)
c0104d2c:	e8 37 f0 ff ff       	call   c0103d68 <page_ref>
c0104d31:	83 f8 01             	cmp    $0x1,%eax
c0104d34:	74 24                	je     c0104d5a <check_pgdir+0x575>
c0104d36:	c7 44 24 0c 17 6d 10 	movl   $0xc0106d17,0xc(%esp)
c0104d3d:	c0 
c0104d3e:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104d45:	c0 
c0104d46:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104d4d:	00 
c0104d4e:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104d55:	e8 9e bf ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0104d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d5d:	89 04 24             	mov    %eax,(%esp)
c0104d60:	e8 03 f0 ff ff       	call   c0103d68 <page_ref>
c0104d65:	85 c0                	test   %eax,%eax
c0104d67:	74 24                	je     c0104d8d <check_pgdir+0x5a8>
c0104d69:	c7 44 24 0c 3e 6e 10 	movl   $0xc0106e3e,0xc(%esp)
c0104d70:	c0 
c0104d71:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104d78:	c0 
c0104d79:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104d80:	00 
c0104d81:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104d88:	e8 6b bf ff ff       	call   c0100cf8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d8d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d92:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d99:	00 
c0104d9a:	89 04 24             	mov    %eax,(%esp)
c0104d9d:	e8 c1 f8 ff ff       	call   c0104663 <page_remove>
    assert(page_ref(p1) == 0);
c0104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104da5:	89 04 24             	mov    %eax,(%esp)
c0104da8:	e8 bb ef ff ff       	call   c0103d68 <page_ref>
c0104dad:	85 c0                	test   %eax,%eax
c0104daf:	74 24                	je     c0104dd5 <check_pgdir+0x5f0>
c0104db1:	c7 44 24 0c 65 6e 10 	movl   $0xc0106e65,0xc(%esp)
c0104db8:	c0 
c0104db9:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104dc0:	c0 
c0104dc1:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104dc8:	00 
c0104dc9:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104dd0:	e8 23 bf ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0104dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dd8:	89 04 24             	mov    %eax,(%esp)
c0104ddb:	e8 88 ef ff ff       	call   c0103d68 <page_ref>
c0104de0:	85 c0                	test   %eax,%eax
c0104de2:	74 24                	je     c0104e08 <check_pgdir+0x623>
c0104de4:	c7 44 24 0c 3e 6e 10 	movl   $0xc0106e3e,0xc(%esp)
c0104deb:	c0 
c0104dec:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104df3:	c0 
c0104df4:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104dfb:	00 
c0104dfc:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104e03:	e8 f0 be ff ff       	call   c0100cf8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104e08:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e0d:	8b 00                	mov    (%eax),%eax
c0104e0f:	89 04 24             	mov    %eax,(%esp)
c0104e12:	e8 37 ef ff ff       	call   c0103d4e <pde2page>
c0104e17:	89 04 24             	mov    %eax,(%esp)
c0104e1a:	e8 49 ef ff ff       	call   c0103d68 <page_ref>
c0104e1f:	83 f8 01             	cmp    $0x1,%eax
c0104e22:	74 24                	je     c0104e48 <check_pgdir+0x663>
c0104e24:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c0104e2b:	c0 
c0104e2c:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104e33:	c0 
c0104e34:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104e3b:	00 
c0104e3c:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104e43:	e8 b0 be ff ff       	call   c0100cf8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e48:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e4d:	8b 00                	mov    (%eax),%eax
c0104e4f:	89 04 24             	mov    %eax,(%esp)
c0104e52:	e8 f7 ee ff ff       	call   c0103d4e <pde2page>
c0104e57:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e5e:	00 
c0104e5f:	89 04 24             	mov    %eax,(%esp)
c0104e62:	e8 3d f1 ff ff       	call   c0103fa4 <free_pages>
    boot_pgdir[0] = 0;
c0104e67:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e72:	c7 04 24 9f 6e 10 c0 	movl   $0xc0106e9f,(%esp)
c0104e79:	e8 e7 b4 ff ff       	call   c0100365 <cprintf>
}
c0104e7e:	90                   	nop
c0104e7f:	89 ec                	mov    %ebp,%esp
c0104e81:	5d                   	pop    %ebp
c0104e82:	c3                   	ret    

c0104e83 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e83:	55                   	push   %ebp
c0104e84:	89 e5                	mov    %esp,%ebp
c0104e86:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e90:	e9 ca 00 00 00       	jmp    c0104f5f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e9e:	c1 e8 0c             	shr    $0xc,%eax
c0104ea1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ea4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104ea9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104eac:	72 23                	jb     c0104ed1 <check_boot_pgdir+0x4e>
c0104eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104eb5:	c7 44 24 08 e4 6a 10 	movl   $0xc0106ae4,0x8(%esp)
c0104ebc:	c0 
c0104ebd:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104ec4:	00 
c0104ec5:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104ecc:	e8 27 be ff ff       	call   c0100cf8 <__panic>
c0104ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ed4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ed9:	89 c2                	mov    %eax,%edx
c0104edb:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ee0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ee7:	00 
c0104ee8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104eec:	89 04 24             	mov    %eax,(%esp)
c0104eef:	e8 08 f7 ff ff       	call   c01045fc <get_pte>
c0104ef4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ef7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104efb:	75 24                	jne    c0104f21 <check_boot_pgdir+0x9e>
c0104efd:	c7 44 24 0c bc 6e 10 	movl   $0xc0106ebc,0xc(%esp)
c0104f04:	c0 
c0104f05:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104f0c:	c0 
c0104f0d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104f14:	00 
c0104f15:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104f1c:	e8 d7 bd ff ff       	call   c0100cf8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f24:	8b 00                	mov    (%eax),%eax
c0104f26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f2b:	89 c2                	mov    %eax,%edx
c0104f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f30:	39 c2                	cmp    %eax,%edx
c0104f32:	74 24                	je     c0104f58 <check_boot_pgdir+0xd5>
c0104f34:	c7 44 24 0c f9 6e 10 	movl   $0xc0106ef9,0xc(%esp)
c0104f3b:	c0 
c0104f3c:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104f43:	c0 
c0104f44:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104f4b:	00 
c0104f4c:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104f53:	e8 a0 bd ff ff       	call   c0100cf8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104f58:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f62:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104f67:	39 c2                	cmp    %eax,%edx
c0104f69:	0f 82 26 ff ff ff    	jb     c0104e95 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f6f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f74:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f79:	8b 00                	mov    (%eax),%eax
c0104f7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f80:	89 c2                	mov    %eax,%edx
c0104f82:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f8a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104f91:	77 23                	ja     c0104fb6 <check_boot_pgdir+0x133>
c0104f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f9a:	c7 44 24 08 88 6b 10 	movl   $0xc0106b88,0x8(%esp)
c0104fa1:	c0 
c0104fa2:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104fa9:	00 
c0104faa:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104fb1:	e8 42 bd ff ff       	call   c0100cf8 <__panic>
c0104fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fb9:	05 00 00 00 40       	add    $0x40000000,%eax
c0104fbe:	39 d0                	cmp    %edx,%eax
c0104fc0:	74 24                	je     c0104fe6 <check_boot_pgdir+0x163>
c0104fc2:	c7 44 24 0c 10 6f 10 	movl   $0xc0106f10,0xc(%esp)
c0104fc9:	c0 
c0104fca:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0104fd1:	c0 
c0104fd2:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104fd9:	00 
c0104fda:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0104fe1:	e8 12 bd ff ff       	call   c0100cf8 <__panic>

    assert(boot_pgdir[0] == 0);
c0104fe6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104feb:	8b 00                	mov    (%eax),%eax
c0104fed:	85 c0                	test   %eax,%eax
c0104fef:	74 24                	je     c0105015 <check_boot_pgdir+0x192>
c0104ff1:	c7 44 24 0c 44 6f 10 	movl   $0xc0106f44,0xc(%esp)
c0104ff8:	c0 
c0104ff9:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0105000:	c0 
c0105001:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0105008:	00 
c0105009:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0105010:	e8 e3 bc ff ff       	call   c0100cf8 <__panic>

    struct Page *p;
    p = alloc_page();
c0105015:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010501c:	e8 49 ef ff ff       	call   c0103f6a <alloc_pages>
c0105021:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105024:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105030:	00 
c0105031:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105038:	00 
c0105039:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010503c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105040:	89 04 24             	mov    %eax,(%esp)
c0105043:	e8 62 f6 ff ff       	call   c01046aa <page_insert>
c0105048:	85 c0                	test   %eax,%eax
c010504a:	74 24                	je     c0105070 <check_boot_pgdir+0x1ed>
c010504c:	c7 44 24 0c 58 6f 10 	movl   $0xc0106f58,0xc(%esp)
c0105053:	c0 
c0105054:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c010505b:	c0 
c010505c:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0105063:	00 
c0105064:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010506b:	e8 88 bc ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p) == 1);
c0105070:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105073:	89 04 24             	mov    %eax,(%esp)
c0105076:	e8 ed ec ff ff       	call   c0103d68 <page_ref>
c010507b:	83 f8 01             	cmp    $0x1,%eax
c010507e:	74 24                	je     c01050a4 <check_boot_pgdir+0x221>
c0105080:	c7 44 24 0c 86 6f 10 	movl   $0xc0106f86,0xc(%esp)
c0105087:	c0 
c0105088:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c010508f:	c0 
c0105090:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105097:	00 
c0105098:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010509f:	e8 54 bc ff ff       	call   c0100cf8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01050a4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01050a9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050b0:	00 
c01050b1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050b8:	00 
c01050b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050c0:	89 04 24             	mov    %eax,(%esp)
c01050c3:	e8 e2 f5 ff ff       	call   c01046aa <page_insert>
c01050c8:	85 c0                	test   %eax,%eax
c01050ca:	74 24                	je     c01050f0 <check_boot_pgdir+0x26d>
c01050cc:	c7 44 24 0c 98 6f 10 	movl   $0xc0106f98,0xc(%esp)
c01050d3:	c0 
c01050d4:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c01050db:	c0 
c01050dc:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c01050e3:	00 
c01050e4:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01050eb:	e8 08 bc ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p) == 2);
c01050f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050f3:	89 04 24             	mov    %eax,(%esp)
c01050f6:	e8 6d ec ff ff       	call   c0103d68 <page_ref>
c01050fb:	83 f8 02             	cmp    $0x2,%eax
c01050fe:	74 24                	je     c0105124 <check_boot_pgdir+0x2a1>
c0105100:	c7 44 24 0c cf 6f 10 	movl   $0xc0106fcf,0xc(%esp)
c0105107:	c0 
c0105108:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c010510f:	c0 
c0105110:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105117:	00 
c0105118:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c010511f:	e8 d4 bb ff ff       	call   c0100cf8 <__panic>

    const char *str = "ucore: Hello world!!";
c0105124:	c7 45 e8 e0 6f 10 c0 	movl   $0xc0106fe0,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010512b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010512e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105132:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105139:	e8 fc 09 00 00       	call   c0105b3a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010513e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105145:	00 
c0105146:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010514d:	e8 60 0a 00 00       	call   c0105bb2 <strcmp>
c0105152:	85 c0                	test   %eax,%eax
c0105154:	74 24                	je     c010517a <check_boot_pgdir+0x2f7>
c0105156:	c7 44 24 0c f8 6f 10 	movl   $0xc0106ff8,0xc(%esp)
c010515d:	c0 
c010515e:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c0105165:	c0 
c0105166:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c010516d:	00 
c010516e:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c0105175:	e8 7e bb ff ff       	call   c0100cf8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010517a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010517d:	89 04 24             	mov    %eax,(%esp)
c0105180:	e8 33 eb ff ff       	call   c0103cb8 <page2kva>
c0105185:	05 00 01 00 00       	add    $0x100,%eax
c010518a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010518d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105194:	e8 47 09 00 00       	call   c0105ae0 <strlen>
c0105199:	85 c0                	test   %eax,%eax
c010519b:	74 24                	je     c01051c1 <check_boot_pgdir+0x33e>
c010519d:	c7 44 24 0c 30 70 10 	movl   $0xc0107030,0xc(%esp)
c01051a4:	c0 
c01051a5:	c7 44 24 08 d1 6b 10 	movl   $0xc0106bd1,0x8(%esp)
c01051ac:	c0 
c01051ad:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01051b4:	00 
c01051b5:	c7 04 24 ac 6b 10 c0 	movl   $0xc0106bac,(%esp)
c01051bc:	e8 37 bb ff ff       	call   c0100cf8 <__panic>

    free_page(p);
c01051c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051c8:	00 
c01051c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051cc:	89 04 24             	mov    %eax,(%esp)
c01051cf:	e8 d0 ed ff ff       	call   c0103fa4 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01051d4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051d9:	8b 00                	mov    (%eax),%eax
c01051db:	89 04 24             	mov    %eax,(%esp)
c01051de:	e8 6b eb ff ff       	call   c0103d4e <pde2page>
c01051e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051ea:	00 
c01051eb:	89 04 24             	mov    %eax,(%esp)
c01051ee:	e8 b1 ed ff ff       	call   c0103fa4 <free_pages>
    boot_pgdir[0] = 0;
c01051f3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01051f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051fe:	c7 04 24 54 70 10 c0 	movl   $0xc0107054,(%esp)
c0105205:	e8 5b b1 ff ff       	call   c0100365 <cprintf>
}
c010520a:	90                   	nop
c010520b:	89 ec                	mov    %ebp,%esp
c010520d:	5d                   	pop    %ebp
c010520e:	c3                   	ret    

c010520f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010520f:	55                   	push   %ebp
c0105210:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105212:	8b 45 08             	mov    0x8(%ebp),%eax
c0105215:	83 e0 04             	and    $0x4,%eax
c0105218:	85 c0                	test   %eax,%eax
c010521a:	74 04                	je     c0105220 <perm2str+0x11>
c010521c:	b0 75                	mov    $0x75,%al
c010521e:	eb 02                	jmp    c0105222 <perm2str+0x13>
c0105220:	b0 2d                	mov    $0x2d,%al
c0105222:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0105227:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010522e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105231:	83 e0 02             	and    $0x2,%eax
c0105234:	85 c0                	test   %eax,%eax
c0105236:	74 04                	je     c010523c <perm2str+0x2d>
c0105238:	b0 77                	mov    $0x77,%al
c010523a:	eb 02                	jmp    c010523e <perm2str+0x2f>
c010523c:	b0 2d                	mov    $0x2d,%al
c010523e:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0105243:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c010524a:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c010524f:	5d                   	pop    %ebp
c0105250:	c3                   	ret    

c0105251 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105251:	55                   	push   %ebp
c0105252:	89 e5                	mov    %esp,%ebp
c0105254:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105257:	8b 45 10             	mov    0x10(%ebp),%eax
c010525a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525d:	72 0d                	jb     c010526c <get_pgtable_items+0x1b>
        return 0;
c010525f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105264:	e9 98 00 00 00       	jmp    c0105301 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105269:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010526c:	8b 45 10             	mov    0x10(%ebp),%eax
c010526f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105272:	73 18                	jae    c010528c <get_pgtable_items+0x3b>
c0105274:	8b 45 10             	mov    0x10(%ebp),%eax
c0105277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010527e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105281:	01 d0                	add    %edx,%eax
c0105283:	8b 00                	mov    (%eax),%eax
c0105285:	83 e0 01             	and    $0x1,%eax
c0105288:	85 c0                	test   %eax,%eax
c010528a:	74 dd                	je     c0105269 <get_pgtable_items+0x18>
    }
    if (start < right) {
c010528c:	8b 45 10             	mov    0x10(%ebp),%eax
c010528f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105292:	73 68                	jae    c01052fc <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105294:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105298:	74 08                	je     c01052a2 <get_pgtable_items+0x51>
            *left_store = start;
c010529a:	8b 45 18             	mov    0x18(%ebp),%eax
c010529d:	8b 55 10             	mov    0x10(%ebp),%edx
c01052a0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01052a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01052a5:	8d 50 01             	lea    0x1(%eax),%edx
c01052a8:	89 55 10             	mov    %edx,0x10(%ebp)
c01052ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01052b5:	01 d0                	add    %edx,%eax
c01052b7:	8b 00                	mov    (%eax),%eax
c01052b9:	83 e0 07             	and    $0x7,%eax
c01052bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052bf:	eb 03                	jmp    c01052c4 <get_pgtable_items+0x73>
            start ++;
c01052c1:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01052c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052ca:	73 1d                	jae    c01052e9 <get_pgtable_items+0x98>
c01052cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01052cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01052d9:	01 d0                	add    %edx,%eax
c01052db:	8b 00                	mov    (%eax),%eax
c01052dd:	83 e0 07             	and    $0x7,%eax
c01052e0:	89 c2                	mov    %eax,%edx
c01052e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052e5:	39 c2                	cmp    %eax,%edx
c01052e7:	74 d8                	je     c01052c1 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01052e9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052ed:	74 08                	je     c01052f7 <get_pgtable_items+0xa6>
            *right_store = start;
c01052ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052f2:	8b 55 10             	mov    0x10(%ebp),%edx
c01052f5:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052fa:	eb 05                	jmp    c0105301 <get_pgtable_items+0xb0>
    }
    return 0;
c01052fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105301:	89 ec                	mov    %ebp,%esp
c0105303:	5d                   	pop    %ebp
c0105304:	c3                   	ret    

c0105305 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105305:	55                   	push   %ebp
c0105306:	89 e5                	mov    %esp,%ebp
c0105308:	57                   	push   %edi
c0105309:	56                   	push   %esi
c010530a:	53                   	push   %ebx
c010530b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010530e:	c7 04 24 74 70 10 c0 	movl   $0xc0107074,(%esp)
c0105315:	e8 4b b0 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c010531a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105321:	e9 f2 00 00 00       	jmp    c0105418 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105329:	89 04 24             	mov    %eax,(%esp)
c010532c:	e8 de fe ff ff       	call   c010520f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105331:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105334:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105337:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105339:	89 d6                	mov    %edx,%esi
c010533b:	c1 e6 16             	shl    $0x16,%esi
c010533e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105341:	89 d3                	mov    %edx,%ebx
c0105343:	c1 e3 16             	shl    $0x16,%ebx
c0105346:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105349:	89 d1                	mov    %edx,%ecx
c010534b:	c1 e1 16             	shl    $0x16,%ecx
c010534e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105351:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105354:	29 fa                	sub    %edi,%edx
c0105356:	89 44 24 14          	mov    %eax,0x14(%esp)
c010535a:	89 74 24 10          	mov    %esi,0x10(%esp)
c010535e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105362:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105366:	89 54 24 04          	mov    %edx,0x4(%esp)
c010536a:	c7 04 24 a5 70 10 c0 	movl   $0xc01070a5,(%esp)
c0105371:	e8 ef af ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0105376:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105379:	c1 e0 0a             	shl    $0xa,%eax
c010537c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010537f:	eb 50                	jmp    c01053d1 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105384:	89 04 24             	mov    %eax,(%esp)
c0105387:	e8 83 fe ff ff       	call   c010520f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010538c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010538f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105392:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105394:	89 d6                	mov    %edx,%esi
c0105396:	c1 e6 0c             	shl    $0xc,%esi
c0105399:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010539c:	89 d3                	mov    %edx,%ebx
c010539e:	c1 e3 0c             	shl    $0xc,%ebx
c01053a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053a4:	89 d1                	mov    %edx,%ecx
c01053a6:	c1 e1 0c             	shl    $0xc,%ecx
c01053a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053ac:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01053af:	29 fa                	sub    %edi,%edx
c01053b1:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053b5:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053b9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053c1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053c5:	c7 04 24 c4 70 10 c0 	movl   $0xc01070c4,(%esp)
c01053cc:	e8 94 af ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053d1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01053d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053dc:	89 d3                	mov    %edx,%ebx
c01053de:	c1 e3 0a             	shl    $0xa,%ebx
c01053e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053e4:	89 d1                	mov    %edx,%ecx
c01053e6:	c1 e1 0a             	shl    $0xa,%ecx
c01053e9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01053ec:	89 54 24 14          	mov    %edx,0x14(%esp)
c01053f0:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01053f3:	89 54 24 10          	mov    %edx,0x10(%esp)
c01053f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01053fb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105403:	89 0c 24             	mov    %ecx,(%esp)
c0105406:	e8 46 fe ff ff       	call   c0105251 <get_pgtable_items>
c010540b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010540e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105412:	0f 85 69 ff ff ff    	jne    c0105381 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105418:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010541d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105420:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105423:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105427:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010542a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010542e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105432:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105436:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010543d:	00 
c010543e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105445:	e8 07 fe ff ff       	call   c0105251 <get_pgtable_items>
c010544a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010544d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105451:	0f 85 cf fe ff ff    	jne    c0105326 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105457:	c7 04 24 e8 70 10 c0 	movl   $0xc01070e8,(%esp)
c010545e:	e8 02 af ff ff       	call   c0100365 <cprintf>
}
c0105463:	90                   	nop
c0105464:	83 c4 4c             	add    $0x4c,%esp
c0105467:	5b                   	pop    %ebx
c0105468:	5e                   	pop    %esi
c0105469:	5f                   	pop    %edi
c010546a:	5d                   	pop    %ebp
c010546b:	c3                   	ret    

c010546c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010546c:	55                   	push   %ebp
c010546d:	89 e5                	mov    %esp,%ebp
c010546f:	83 ec 58             	sub    $0x58,%esp
c0105472:	8b 45 10             	mov    0x10(%ebp),%eax
c0105475:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105478:	8b 45 14             	mov    0x14(%ebp),%eax
c010547b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010547e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105481:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105484:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105487:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010548a:	8b 45 18             	mov    0x18(%ebp),%eax
c010548d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105490:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105493:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105496:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105499:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010549c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010549f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054a6:	74 1c                	je     c01054c4 <printnum+0x58>
c01054a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01054b0:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b9:	ba 00 00 00 00       	mov    $0x0,%edx
c01054be:	f7 75 e4             	divl   -0x1c(%ebp)
c01054c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054ca:	f7 75 e4             	divl   -0x1c(%ebp)
c01054cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054dc:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054e2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054e5:	8b 45 18             	mov    0x18(%ebp),%eax
c01054e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01054f0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01054f3:	19 d1                	sbb    %edx,%ecx
c01054f5:	72 4c                	jb     c0105543 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054fa:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054fd:	8b 45 20             	mov    0x20(%ebp),%eax
c0105500:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105504:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105508:	8b 45 18             	mov    0x18(%ebp),%eax
c010550b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010550f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105512:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105515:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105519:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010551d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105520:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105524:	8b 45 08             	mov    0x8(%ebp),%eax
c0105527:	89 04 24             	mov    %eax,(%esp)
c010552a:	e8 3d ff ff ff       	call   c010546c <printnum>
c010552f:	eb 1b                	jmp    c010554c <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105531:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105534:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105538:	8b 45 20             	mov    0x20(%ebp),%eax
c010553b:	89 04 24             	mov    %eax,(%esp)
c010553e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105541:	ff d0                	call   *%eax
        while (-- width > 0)
c0105543:	ff 4d 1c             	decl   0x1c(%ebp)
c0105546:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010554a:	7f e5                	jg     c0105531 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010554c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010554f:	05 9c 71 10 c0       	add    $0xc010719c,%eax
c0105554:	0f b6 00             	movzbl (%eax),%eax
c0105557:	0f be c0             	movsbl %al,%eax
c010555a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010555d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105561:	89 04 24             	mov    %eax,(%esp)
c0105564:	8b 45 08             	mov    0x8(%ebp),%eax
c0105567:	ff d0                	call   *%eax
}
c0105569:	90                   	nop
c010556a:	89 ec                	mov    %ebp,%esp
c010556c:	5d                   	pop    %ebp
c010556d:	c3                   	ret    

c010556e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010556e:	55                   	push   %ebp
c010556f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105575:	7e 14                	jle    c010558b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105577:	8b 45 08             	mov    0x8(%ebp),%eax
c010557a:	8b 00                	mov    (%eax),%eax
c010557c:	8d 48 08             	lea    0x8(%eax),%ecx
c010557f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105582:	89 0a                	mov    %ecx,(%edx)
c0105584:	8b 50 04             	mov    0x4(%eax),%edx
c0105587:	8b 00                	mov    (%eax),%eax
c0105589:	eb 30                	jmp    c01055bb <getuint+0x4d>
    }
    else if (lflag) {
c010558b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010558f:	74 16                	je     c01055a7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105591:	8b 45 08             	mov    0x8(%ebp),%eax
c0105594:	8b 00                	mov    (%eax),%eax
c0105596:	8d 48 04             	lea    0x4(%eax),%ecx
c0105599:	8b 55 08             	mov    0x8(%ebp),%edx
c010559c:	89 0a                	mov    %ecx,(%edx)
c010559e:	8b 00                	mov    (%eax),%eax
c01055a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01055a5:	eb 14                	jmp    c01055bb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055aa:	8b 00                	mov    (%eax),%eax
c01055ac:	8d 48 04             	lea    0x4(%eax),%ecx
c01055af:	8b 55 08             	mov    0x8(%ebp),%edx
c01055b2:	89 0a                	mov    %ecx,(%edx)
c01055b4:	8b 00                	mov    (%eax),%eax
c01055b6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055bb:	5d                   	pop    %ebp
c01055bc:	c3                   	ret    

c01055bd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055bd:	55                   	push   %ebp
c01055be:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055c4:	7e 14                	jle    c01055da <getint+0x1d>
        return va_arg(*ap, long long);
c01055c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c9:	8b 00                	mov    (%eax),%eax
c01055cb:	8d 48 08             	lea    0x8(%eax),%ecx
c01055ce:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d1:	89 0a                	mov    %ecx,(%edx)
c01055d3:	8b 50 04             	mov    0x4(%eax),%edx
c01055d6:	8b 00                	mov    (%eax),%eax
c01055d8:	eb 28                	jmp    c0105602 <getint+0x45>
    }
    else if (lflag) {
c01055da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055de:	74 12                	je     c01055f2 <getint+0x35>
        return va_arg(*ap, long);
c01055e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e3:	8b 00                	mov    (%eax),%eax
c01055e5:	8d 48 04             	lea    0x4(%eax),%ecx
c01055e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055eb:	89 0a                	mov    %ecx,(%edx)
c01055ed:	8b 00                	mov    (%eax),%eax
c01055ef:	99                   	cltd   
c01055f0:	eb 10                	jmp    c0105602 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f5:	8b 00                	mov    (%eax),%eax
c01055f7:	8d 48 04             	lea    0x4(%eax),%ecx
c01055fa:	8b 55 08             	mov    0x8(%ebp),%edx
c01055fd:	89 0a                	mov    %ecx,(%edx)
c01055ff:	8b 00                	mov    (%eax),%eax
c0105601:	99                   	cltd   
    }
}
c0105602:	5d                   	pop    %ebp
c0105603:	c3                   	ret    

c0105604 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105604:	55                   	push   %ebp
c0105605:	89 e5                	mov    %esp,%ebp
c0105607:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010560a:	8d 45 14             	lea    0x14(%ebp),%eax
c010560d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105610:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105613:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105617:	8b 45 10             	mov    0x10(%ebp),%eax
c010561a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010561e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105621:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105625:	8b 45 08             	mov    0x8(%ebp),%eax
c0105628:	89 04 24             	mov    %eax,(%esp)
c010562b:	e8 05 00 00 00       	call   c0105635 <vprintfmt>
    va_end(ap);
}
c0105630:	90                   	nop
c0105631:	89 ec                	mov    %ebp,%esp
c0105633:	5d                   	pop    %ebp
c0105634:	c3                   	ret    

c0105635 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105635:	55                   	push   %ebp
c0105636:	89 e5                	mov    %esp,%ebp
c0105638:	56                   	push   %esi
c0105639:	53                   	push   %ebx
c010563a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010563d:	eb 17                	jmp    c0105656 <vprintfmt+0x21>
            if (ch == '\0') {
c010563f:	85 db                	test   %ebx,%ebx
c0105641:	0f 84 bf 03 00 00    	je     c0105a06 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105647:	8b 45 0c             	mov    0xc(%ebp),%eax
c010564a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010564e:	89 1c 24             	mov    %ebx,(%esp)
c0105651:	8b 45 08             	mov    0x8(%ebp),%eax
c0105654:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105656:	8b 45 10             	mov    0x10(%ebp),%eax
c0105659:	8d 50 01             	lea    0x1(%eax),%edx
c010565c:	89 55 10             	mov    %edx,0x10(%ebp)
c010565f:	0f b6 00             	movzbl (%eax),%eax
c0105662:	0f b6 d8             	movzbl %al,%ebx
c0105665:	83 fb 25             	cmp    $0x25,%ebx
c0105668:	75 d5                	jne    c010563f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010566a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010566e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105678:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010567b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105682:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105685:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105688:	8b 45 10             	mov    0x10(%ebp),%eax
c010568b:	8d 50 01             	lea    0x1(%eax),%edx
c010568e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105691:	0f b6 00             	movzbl (%eax),%eax
c0105694:	0f b6 d8             	movzbl %al,%ebx
c0105697:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010569a:	83 f8 55             	cmp    $0x55,%eax
c010569d:	0f 87 37 03 00 00    	ja     c01059da <vprintfmt+0x3a5>
c01056a3:	8b 04 85 c0 71 10 c0 	mov    -0x3fef8e40(,%eax,4),%eax
c01056aa:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01056ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056b0:	eb d6                	jmp    c0105688 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056b6:	eb d0                	jmp    c0105688 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056c2:	89 d0                	mov    %edx,%eax
c01056c4:	c1 e0 02             	shl    $0x2,%eax
c01056c7:	01 d0                	add    %edx,%eax
c01056c9:	01 c0                	add    %eax,%eax
c01056cb:	01 d8                	add    %ebx,%eax
c01056cd:	83 e8 30             	sub    $0x30,%eax
c01056d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01056d6:	0f b6 00             	movzbl (%eax),%eax
c01056d9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056dc:	83 fb 2f             	cmp    $0x2f,%ebx
c01056df:	7e 38                	jle    c0105719 <vprintfmt+0xe4>
c01056e1:	83 fb 39             	cmp    $0x39,%ebx
c01056e4:	7f 33                	jg     c0105719 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c01056e6:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01056e9:	eb d4                	jmp    c01056bf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056eb:	8b 45 14             	mov    0x14(%ebp),%eax
c01056ee:	8d 50 04             	lea    0x4(%eax),%edx
c01056f1:	89 55 14             	mov    %edx,0x14(%ebp)
c01056f4:	8b 00                	mov    (%eax),%eax
c01056f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056f9:	eb 1f                	jmp    c010571a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01056fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056ff:	79 87                	jns    c0105688 <vprintfmt+0x53>
                width = 0;
c0105701:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105708:	e9 7b ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010570d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105714:	e9 6f ff ff ff       	jmp    c0105688 <vprintfmt+0x53>
            goto process_precision;
c0105719:	90                   	nop

        process_precision:
            if (width < 0)
c010571a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010571e:	0f 89 64 ff ff ff    	jns    c0105688 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105727:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010572a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105731:	e9 52 ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105736:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105739:	e9 4a ff ff ff       	jmp    c0105688 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010573e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105741:	8d 50 04             	lea    0x4(%eax),%edx
c0105744:	89 55 14             	mov    %edx,0x14(%ebp)
c0105747:	8b 00                	mov    (%eax),%eax
c0105749:	8b 55 0c             	mov    0xc(%ebp),%edx
c010574c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105750:	89 04 24             	mov    %eax,(%esp)
c0105753:	8b 45 08             	mov    0x8(%ebp),%eax
c0105756:	ff d0                	call   *%eax
            break;
c0105758:	e9 a4 02 00 00       	jmp    c0105a01 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010575d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105760:	8d 50 04             	lea    0x4(%eax),%edx
c0105763:	89 55 14             	mov    %edx,0x14(%ebp)
c0105766:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105768:	85 db                	test   %ebx,%ebx
c010576a:	79 02                	jns    c010576e <vprintfmt+0x139>
                err = -err;
c010576c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010576e:	83 fb 06             	cmp    $0x6,%ebx
c0105771:	7f 0b                	jg     c010577e <vprintfmt+0x149>
c0105773:	8b 34 9d 80 71 10 c0 	mov    -0x3fef8e80(,%ebx,4),%esi
c010577a:	85 f6                	test   %esi,%esi
c010577c:	75 23                	jne    c01057a1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c010577e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105782:	c7 44 24 08 ad 71 10 	movl   $0xc01071ad,0x8(%esp)
c0105789:	c0 
c010578a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105791:	8b 45 08             	mov    0x8(%ebp),%eax
c0105794:	89 04 24             	mov    %eax,(%esp)
c0105797:	e8 68 fe ff ff       	call   c0105604 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010579c:	e9 60 02 00 00       	jmp    c0105a01 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01057a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01057a5:	c7 44 24 08 b6 71 10 	movl   $0xc01071b6,0x8(%esp)
c01057ac:	c0 
c01057ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b7:	89 04 24             	mov    %eax,(%esp)
c01057ba:	e8 45 fe ff ff       	call   c0105604 <printfmt>
            break;
c01057bf:	e9 3d 02 00 00       	jmp    c0105a01 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01057c7:	8d 50 04             	lea    0x4(%eax),%edx
c01057ca:	89 55 14             	mov    %edx,0x14(%ebp)
c01057cd:	8b 30                	mov    (%eax),%esi
c01057cf:	85 f6                	test   %esi,%esi
c01057d1:	75 05                	jne    c01057d8 <vprintfmt+0x1a3>
                p = "(null)";
c01057d3:	be b9 71 10 c0       	mov    $0xc01071b9,%esi
            }
            if (width > 0 && padc != '-') {
c01057d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057dc:	7e 76                	jle    c0105854 <vprintfmt+0x21f>
c01057de:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057e2:	74 70                	je     c0105854 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057eb:	89 34 24             	mov    %esi,(%esp)
c01057ee:	e8 16 03 00 00       	call   c0105b09 <strnlen>
c01057f3:	89 c2                	mov    %eax,%edx
c01057f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057f8:	29 d0                	sub    %edx,%eax
c01057fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057fd:	eb 16                	jmp    c0105815 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c01057ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105803:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105806:	89 54 24 04          	mov    %edx,0x4(%esp)
c010580a:	89 04 24             	mov    %eax,(%esp)
c010580d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105810:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105812:	ff 4d e8             	decl   -0x18(%ebp)
c0105815:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105819:	7f e4                	jg     c01057ff <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010581b:	eb 37                	jmp    c0105854 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010581d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105821:	74 1f                	je     c0105842 <vprintfmt+0x20d>
c0105823:	83 fb 1f             	cmp    $0x1f,%ebx
c0105826:	7e 05                	jle    c010582d <vprintfmt+0x1f8>
c0105828:	83 fb 7e             	cmp    $0x7e,%ebx
c010582b:	7e 15                	jle    c0105842 <vprintfmt+0x20d>
                    putch('?', putdat);
c010582d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105830:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105834:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010583b:	8b 45 08             	mov    0x8(%ebp),%eax
c010583e:	ff d0                	call   *%eax
c0105840:	eb 0f                	jmp    c0105851 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105845:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105849:	89 1c 24             	mov    %ebx,(%esp)
c010584c:	8b 45 08             	mov    0x8(%ebp),%eax
c010584f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105851:	ff 4d e8             	decl   -0x18(%ebp)
c0105854:	89 f0                	mov    %esi,%eax
c0105856:	8d 70 01             	lea    0x1(%eax),%esi
c0105859:	0f b6 00             	movzbl (%eax),%eax
c010585c:	0f be d8             	movsbl %al,%ebx
c010585f:	85 db                	test   %ebx,%ebx
c0105861:	74 27                	je     c010588a <vprintfmt+0x255>
c0105863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105867:	78 b4                	js     c010581d <vprintfmt+0x1e8>
c0105869:	ff 4d e4             	decl   -0x1c(%ebp)
c010586c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105870:	79 ab                	jns    c010581d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105872:	eb 16                	jmp    c010588a <vprintfmt+0x255>
                putch(' ', putdat);
c0105874:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105877:	89 44 24 04          	mov    %eax,0x4(%esp)
c010587b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105882:	8b 45 08             	mov    0x8(%ebp),%eax
c0105885:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105887:	ff 4d e8             	decl   -0x18(%ebp)
c010588a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010588e:	7f e4                	jg     c0105874 <vprintfmt+0x23f>
            }
            break;
c0105890:	e9 6c 01 00 00       	jmp    c0105a01 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105895:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105898:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589c:	8d 45 14             	lea    0x14(%ebp),%eax
c010589f:	89 04 24             	mov    %eax,(%esp)
c01058a2:	e8 16 fd ff ff       	call   c01055bd <getint>
c01058a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058b3:	85 d2                	test   %edx,%edx
c01058b5:	79 26                	jns    c01058dd <vprintfmt+0x2a8>
                putch('-', putdat);
c01058b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058be:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c8:	ff d0                	call   *%eax
                num = -(long long)num;
c01058ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058d0:	f7 d8                	neg    %eax
c01058d2:	83 d2 00             	adc    $0x0,%edx
c01058d5:	f7 da                	neg    %edx
c01058d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058e4:	e9 a8 00 00 00       	jmp    c0105991 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f0:	8d 45 14             	lea    0x14(%ebp),%eax
c01058f3:	89 04 24             	mov    %eax,(%esp)
c01058f6:	e8 73 fc ff ff       	call   c010556e <getuint>
c01058fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105901:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105908:	e9 84 00 00 00       	jmp    c0105991 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010590d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105910:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105914:	8d 45 14             	lea    0x14(%ebp),%eax
c0105917:	89 04 24             	mov    %eax,(%esp)
c010591a:	e8 4f fc ff ff       	call   c010556e <getuint>
c010591f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105922:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105925:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010592c:	eb 63                	jmp    c0105991 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010592e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105931:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105935:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010593c:	8b 45 08             	mov    0x8(%ebp),%eax
c010593f:	ff d0                	call   *%eax
            putch('x', putdat);
c0105941:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105944:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105948:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010594f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105952:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105954:	8b 45 14             	mov    0x14(%ebp),%eax
c0105957:	8d 50 04             	lea    0x4(%eax),%edx
c010595a:	89 55 14             	mov    %edx,0x14(%ebp)
c010595d:	8b 00                	mov    (%eax),%eax
c010595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105969:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105970:	eb 1f                	jmp    c0105991 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105972:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105975:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105979:	8d 45 14             	lea    0x14(%ebp),%eax
c010597c:	89 04 24             	mov    %eax,(%esp)
c010597f:	e8 ea fb ff ff       	call   c010556e <getuint>
c0105984:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105987:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010598a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105991:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105998:	89 54 24 18          	mov    %edx,0x18(%esp)
c010599c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010599f:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059a3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01059a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059ad:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bf:	89 04 24             	mov    %eax,(%esp)
c01059c2:	e8 a5 fa ff ff       	call   c010546c <printnum>
            break;
c01059c7:	eb 38                	jmp    c0105a01 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d0:	89 1c 24             	mov    %ebx,(%esp)
c01059d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d6:	ff d0                	call   *%eax
            break;
c01059d8:	eb 27                	jmp    c0105a01 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059eb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059ed:	ff 4d 10             	decl   0x10(%ebp)
c01059f0:	eb 03                	jmp    c01059f5 <vprintfmt+0x3c0>
c01059f2:	ff 4d 10             	decl   0x10(%ebp)
c01059f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01059f8:	48                   	dec    %eax
c01059f9:	0f b6 00             	movzbl (%eax),%eax
c01059fc:	3c 25                	cmp    $0x25,%al
c01059fe:	75 f2                	jne    c01059f2 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105a00:	90                   	nop
    while (1) {
c0105a01:	e9 37 fc ff ff       	jmp    c010563d <vprintfmt+0x8>
                return;
c0105a06:	90                   	nop
        }
    }
}
c0105a07:	83 c4 40             	add    $0x40,%esp
c0105a0a:	5b                   	pop    %ebx
c0105a0b:	5e                   	pop    %esi
c0105a0c:	5d                   	pop    %ebp
c0105a0d:	c3                   	ret    

c0105a0e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a0e:	55                   	push   %ebp
c0105a0f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a14:	8b 40 08             	mov    0x8(%eax),%eax
c0105a17:	8d 50 01             	lea    0x1(%eax),%edx
c0105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a23:	8b 10                	mov    (%eax),%edx
c0105a25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a28:	8b 40 04             	mov    0x4(%eax),%eax
c0105a2b:	39 c2                	cmp    %eax,%edx
c0105a2d:	73 12                	jae    c0105a41 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a32:	8b 00                	mov    (%eax),%eax
c0105a34:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a37:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a3a:	89 0a                	mov    %ecx,(%edx)
c0105a3c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a3f:	88 10                	mov    %dl,(%eax)
    }
}
c0105a41:	90                   	nop
c0105a42:	5d                   	pop    %ebp
c0105a43:	c3                   	ret    

c0105a44 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a44:	55                   	push   %ebp
c0105a45:	89 e5                	mov    %esp,%ebp
c0105a47:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a4a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a68:	89 04 24             	mov    %eax,(%esp)
c0105a6b:	e8 0a 00 00 00       	call   c0105a7a <vsnprintf>
c0105a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a76:	89 ec                	mov    %ebp,%esp
c0105a78:	5d                   	pop    %ebp
c0105a79:	c3                   	ret    

c0105a7a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a7a:	55                   	push   %ebp
c0105a7b:	89 e5                	mov    %esp,%ebp
c0105a7d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a83:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a89:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8f:	01 d0                	add    %edx,%eax
c0105a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a9f:	74 0a                	je     c0105aab <vsnprintf+0x31>
c0105aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa7:	39 c2                	cmp    %eax,%edx
c0105aa9:	76 07                	jbe    c0105ab2 <vsnprintf+0x38>
        return -E_INVAL;
c0105aab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105ab0:	eb 2a                	jmp    c0105adc <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105ab2:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ab9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105abc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ac0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac7:	c7 04 24 0e 5a 10 c0 	movl   $0xc0105a0e,(%esp)
c0105ace:	e8 62 fb ff ff       	call   c0105635 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105adc:	89 ec                	mov    %ebp,%esp
c0105ade:	5d                   	pop    %ebp
c0105adf:	c3                   	ret    

c0105ae0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105ae0:	55                   	push   %ebp
c0105ae1:	89 e5                	mov    %esp,%ebp
c0105ae3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105aed:	eb 03                	jmp    c0105af2 <strlen+0x12>
        cnt ++;
c0105aef:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af5:	8d 50 01             	lea    0x1(%eax),%edx
c0105af8:	89 55 08             	mov    %edx,0x8(%ebp)
c0105afb:	0f b6 00             	movzbl (%eax),%eax
c0105afe:	84 c0                	test   %al,%al
c0105b00:	75 ed                	jne    c0105aef <strlen+0xf>
    }
    return cnt;
c0105b02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b05:	89 ec                	mov    %ebp,%esp
c0105b07:	5d                   	pop    %ebp
c0105b08:	c3                   	ret    

c0105b09 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b09:	55                   	push   %ebp
c0105b0a:	89 e5                	mov    %esp,%ebp
c0105b0c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b16:	eb 03                	jmp    c0105b1b <strnlen+0x12>
        cnt ++;
c0105b18:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b21:	73 10                	jae    c0105b33 <strnlen+0x2a>
c0105b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b26:	8d 50 01             	lea    0x1(%eax),%edx
c0105b29:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b2c:	0f b6 00             	movzbl (%eax),%eax
c0105b2f:	84 c0                	test   %al,%al
c0105b31:	75 e5                	jne    c0105b18 <strnlen+0xf>
    }
    return cnt;
c0105b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b36:	89 ec                	mov    %ebp,%esp
c0105b38:	5d                   	pop    %ebp
c0105b39:	c3                   	ret    

c0105b3a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b3a:	55                   	push   %ebp
c0105b3b:	89 e5                	mov    %esp,%ebp
c0105b3d:	57                   	push   %edi
c0105b3e:	56                   	push   %esi
c0105b3f:	83 ec 20             	sub    $0x20,%esp
c0105b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b54:	89 d1                	mov    %edx,%ecx
c0105b56:	89 c2                	mov    %eax,%edx
c0105b58:	89 ce                	mov    %ecx,%esi
c0105b5a:	89 d7                	mov    %edx,%edi
c0105b5c:	ac                   	lods   %ds:(%esi),%al
c0105b5d:	aa                   	stos   %al,%es:(%edi)
c0105b5e:	84 c0                	test   %al,%al
c0105b60:	75 fa                	jne    c0105b5c <strcpy+0x22>
c0105b62:	89 fa                	mov    %edi,%edx
c0105b64:	89 f1                	mov    %esi,%ecx
c0105b66:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b69:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b72:	83 c4 20             	add    $0x20,%esp
c0105b75:	5e                   	pop    %esi
c0105b76:	5f                   	pop    %edi
c0105b77:	5d                   	pop    %ebp
c0105b78:	c3                   	ret    

c0105b79 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b79:	55                   	push   %ebp
c0105b7a:	89 e5                	mov    %esp,%ebp
c0105b7c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b82:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b85:	eb 1e                	jmp    c0105ba5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8a:	0f b6 10             	movzbl (%eax),%edx
c0105b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b90:	88 10                	mov    %dl,(%eax)
c0105b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b95:	0f b6 00             	movzbl (%eax),%eax
c0105b98:	84 c0                	test   %al,%al
c0105b9a:	74 03                	je     c0105b9f <strncpy+0x26>
            src ++;
c0105b9c:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105b9f:	ff 45 fc             	incl   -0x4(%ebp)
c0105ba2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105ba5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ba9:	75 dc                	jne    c0105b87 <strncpy+0xe>
    }
    return dst;
c0105bab:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bae:	89 ec                	mov    %ebp,%esp
c0105bb0:	5d                   	pop    %ebp
c0105bb1:	c3                   	ret    

c0105bb2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105bb2:	55                   	push   %ebp
c0105bb3:	89 e5                	mov    %esp,%ebp
c0105bb5:	57                   	push   %edi
c0105bb6:	56                   	push   %esi
c0105bb7:	83 ec 20             	sub    $0x20,%esp
c0105bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bcc:	89 d1                	mov    %edx,%ecx
c0105bce:	89 c2                	mov    %eax,%edx
c0105bd0:	89 ce                	mov    %ecx,%esi
c0105bd2:	89 d7                	mov    %edx,%edi
c0105bd4:	ac                   	lods   %ds:(%esi),%al
c0105bd5:	ae                   	scas   %es:(%edi),%al
c0105bd6:	75 08                	jne    c0105be0 <strcmp+0x2e>
c0105bd8:	84 c0                	test   %al,%al
c0105bda:	75 f8                	jne    c0105bd4 <strcmp+0x22>
c0105bdc:	31 c0                	xor    %eax,%eax
c0105bde:	eb 04                	jmp    c0105be4 <strcmp+0x32>
c0105be0:	19 c0                	sbb    %eax,%eax
c0105be2:	0c 01                	or     $0x1,%al
c0105be4:	89 fa                	mov    %edi,%edx
c0105be6:	89 f1                	mov    %esi,%ecx
c0105be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105beb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bf4:	83 c4 20             	add    $0x20,%esp
c0105bf7:	5e                   	pop    %esi
c0105bf8:	5f                   	pop    %edi
c0105bf9:	5d                   	pop    %ebp
c0105bfa:	c3                   	ret    

c0105bfb <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bfb:	55                   	push   %ebp
c0105bfc:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bfe:	eb 09                	jmp    c0105c09 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105c00:	ff 4d 10             	decl   0x10(%ebp)
c0105c03:	ff 45 08             	incl   0x8(%ebp)
c0105c06:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c0d:	74 1a                	je     c0105c29 <strncmp+0x2e>
c0105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c12:	0f b6 00             	movzbl (%eax),%eax
c0105c15:	84 c0                	test   %al,%al
c0105c17:	74 10                	je     c0105c29 <strncmp+0x2e>
c0105c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1c:	0f b6 10             	movzbl (%eax),%edx
c0105c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c22:	0f b6 00             	movzbl (%eax),%eax
c0105c25:	38 c2                	cmp    %al,%dl
c0105c27:	74 d7                	je     c0105c00 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c2d:	74 18                	je     c0105c47 <strncmp+0x4c>
c0105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c32:	0f b6 00             	movzbl (%eax),%eax
c0105c35:	0f b6 d0             	movzbl %al,%edx
c0105c38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3b:	0f b6 00             	movzbl (%eax),%eax
c0105c3e:	0f b6 c8             	movzbl %al,%ecx
c0105c41:	89 d0                	mov    %edx,%eax
c0105c43:	29 c8                	sub    %ecx,%eax
c0105c45:	eb 05                	jmp    c0105c4c <strncmp+0x51>
c0105c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c4c:	5d                   	pop    %ebp
c0105c4d:	c3                   	ret    

c0105c4e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c4e:	55                   	push   %ebp
c0105c4f:	89 e5                	mov    %esp,%ebp
c0105c51:	83 ec 04             	sub    $0x4,%esp
c0105c54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c57:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c5a:	eb 13                	jmp    c0105c6f <strchr+0x21>
        if (*s == c) {
c0105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5f:	0f b6 00             	movzbl (%eax),%eax
c0105c62:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c65:	75 05                	jne    c0105c6c <strchr+0x1e>
            return (char *)s;
c0105c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6a:	eb 12                	jmp    c0105c7e <strchr+0x30>
        }
        s ++;
c0105c6c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	0f b6 00             	movzbl (%eax),%eax
c0105c75:	84 c0                	test   %al,%al
c0105c77:	75 e3                	jne    c0105c5c <strchr+0xe>
    }
    return NULL;
c0105c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c7e:	89 ec                	mov    %ebp,%esp
c0105c80:	5d                   	pop    %ebp
c0105c81:	c3                   	ret    

c0105c82 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c82:	55                   	push   %ebp
c0105c83:	89 e5                	mov    %esp,%ebp
c0105c85:	83 ec 04             	sub    $0x4,%esp
c0105c88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c8e:	eb 0e                	jmp    c0105c9e <strfind+0x1c>
        if (*s == c) {
c0105c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c93:	0f b6 00             	movzbl (%eax),%eax
c0105c96:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105c99:	74 0f                	je     c0105caa <strfind+0x28>
            break;
        }
        s ++;
c0105c9b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca1:	0f b6 00             	movzbl (%eax),%eax
c0105ca4:	84 c0                	test   %al,%al
c0105ca6:	75 e8                	jne    c0105c90 <strfind+0xe>
c0105ca8:	eb 01                	jmp    c0105cab <strfind+0x29>
            break;
c0105caa:	90                   	nop
    }
    return (char *)s;
c0105cab:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105cae:	89 ec                	mov    %ebp,%esp
c0105cb0:	5d                   	pop    %ebp
c0105cb1:	c3                   	ret    

c0105cb2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105cb2:	55                   	push   %ebp
c0105cb3:	89 e5                	mov    %esp,%ebp
c0105cb5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cc6:	eb 03                	jmp    c0105ccb <strtol+0x19>
        s ++;
c0105cc8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cce:	0f b6 00             	movzbl (%eax),%eax
c0105cd1:	3c 20                	cmp    $0x20,%al
c0105cd3:	74 f3                	je     c0105cc8 <strtol+0x16>
c0105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd8:	0f b6 00             	movzbl (%eax),%eax
c0105cdb:	3c 09                	cmp    $0x9,%al
c0105cdd:	74 e9                	je     c0105cc8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce2:	0f b6 00             	movzbl (%eax),%eax
c0105ce5:	3c 2b                	cmp    $0x2b,%al
c0105ce7:	75 05                	jne    c0105cee <strtol+0x3c>
        s ++;
c0105ce9:	ff 45 08             	incl   0x8(%ebp)
c0105cec:	eb 14                	jmp    c0105d02 <strtol+0x50>
    }
    else if (*s == '-') {
c0105cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf1:	0f b6 00             	movzbl (%eax),%eax
c0105cf4:	3c 2d                	cmp    $0x2d,%al
c0105cf6:	75 0a                	jne    c0105d02 <strtol+0x50>
        s ++, neg = 1;
c0105cf8:	ff 45 08             	incl   0x8(%ebp)
c0105cfb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d06:	74 06                	je     c0105d0e <strtol+0x5c>
c0105d08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d0c:	75 22                	jne    c0105d30 <strtol+0x7e>
c0105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d11:	0f b6 00             	movzbl (%eax),%eax
c0105d14:	3c 30                	cmp    $0x30,%al
c0105d16:	75 18                	jne    c0105d30 <strtol+0x7e>
c0105d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1b:	40                   	inc    %eax
c0105d1c:	0f b6 00             	movzbl (%eax),%eax
c0105d1f:	3c 78                	cmp    $0x78,%al
c0105d21:	75 0d                	jne    c0105d30 <strtol+0x7e>
        s += 2, base = 16;
c0105d23:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d27:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d2e:	eb 29                	jmp    c0105d59 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d34:	75 16                	jne    c0105d4c <strtol+0x9a>
c0105d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d39:	0f b6 00             	movzbl (%eax),%eax
c0105d3c:	3c 30                	cmp    $0x30,%al
c0105d3e:	75 0c                	jne    c0105d4c <strtol+0x9a>
        s ++, base = 8;
c0105d40:	ff 45 08             	incl   0x8(%ebp)
c0105d43:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d4a:	eb 0d                	jmp    c0105d59 <strtol+0xa7>
    }
    else if (base == 0) {
c0105d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d50:	75 07                	jne    c0105d59 <strtol+0xa7>
        base = 10;
c0105d52:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5c:	0f b6 00             	movzbl (%eax),%eax
c0105d5f:	3c 2f                	cmp    $0x2f,%al
c0105d61:	7e 1b                	jle    c0105d7e <strtol+0xcc>
c0105d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d66:	0f b6 00             	movzbl (%eax),%eax
c0105d69:	3c 39                	cmp    $0x39,%al
c0105d6b:	7f 11                	jg     c0105d7e <strtol+0xcc>
            dig = *s - '0';
c0105d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d70:	0f b6 00             	movzbl (%eax),%eax
c0105d73:	0f be c0             	movsbl %al,%eax
c0105d76:	83 e8 30             	sub    $0x30,%eax
c0105d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d7c:	eb 48                	jmp    c0105dc6 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d81:	0f b6 00             	movzbl (%eax),%eax
c0105d84:	3c 60                	cmp    $0x60,%al
c0105d86:	7e 1b                	jle    c0105da3 <strtol+0xf1>
c0105d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8b:	0f b6 00             	movzbl (%eax),%eax
c0105d8e:	3c 7a                	cmp    $0x7a,%al
c0105d90:	7f 11                	jg     c0105da3 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105d92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d95:	0f b6 00             	movzbl (%eax),%eax
c0105d98:	0f be c0             	movsbl %al,%eax
c0105d9b:	83 e8 57             	sub    $0x57,%eax
c0105d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105da1:	eb 23                	jmp    c0105dc6 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105da3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da6:	0f b6 00             	movzbl (%eax),%eax
c0105da9:	3c 40                	cmp    $0x40,%al
c0105dab:	7e 3b                	jle    c0105de8 <strtol+0x136>
c0105dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db0:	0f b6 00             	movzbl (%eax),%eax
c0105db3:	3c 5a                	cmp    $0x5a,%al
c0105db5:	7f 31                	jg     c0105de8 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dba:	0f b6 00             	movzbl (%eax),%eax
c0105dbd:	0f be c0             	movsbl %al,%eax
c0105dc0:	83 e8 37             	sub    $0x37,%eax
c0105dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dc9:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105dcc:	7d 19                	jge    c0105de7 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105dce:	ff 45 08             	incl   0x8(%ebp)
c0105dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd4:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dd8:	89 c2                	mov    %eax,%edx
c0105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ddd:	01 d0                	add    %edx,%eax
c0105ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105de2:	e9 72 ff ff ff       	jmp    c0105d59 <strtol+0xa7>
            break;
c0105de7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dec:	74 08                	je     c0105df6 <strtol+0x144>
        *endptr = (char *) s;
c0105dee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105df4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dfa:	74 07                	je     c0105e03 <strtol+0x151>
c0105dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dff:	f7 d8                	neg    %eax
c0105e01:	eb 03                	jmp    c0105e06 <strtol+0x154>
c0105e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e06:	89 ec                	mov    %ebp,%esp
c0105e08:	5d                   	pop    %ebp
c0105e09:	c3                   	ret    

c0105e0a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e0a:	55                   	push   %ebp
c0105e0b:	89 e5                	mov    %esp,%ebp
c0105e0d:	83 ec 28             	sub    $0x28,%esp
c0105e10:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105e13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e16:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e19:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105e23:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105e26:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e33:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e36:	89 d7                	mov    %edx,%edi
c0105e38:	f3 aa                	rep stos %al,%es:(%edi)
c0105e3a:	89 fa                	mov    %edi,%edx
c0105e3c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e3f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e45:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105e48:	89 ec                	mov    %ebp,%esp
c0105e4a:	5d                   	pop    %ebp
c0105e4b:	c3                   	ret    

c0105e4c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e4c:	55                   	push   %ebp
c0105e4d:	89 e5                	mov    %esp,%ebp
c0105e4f:	57                   	push   %edi
c0105e50:	56                   	push   %esi
c0105e51:	53                   	push   %ebx
c0105e52:	83 ec 30             	sub    $0x30,%esp
c0105e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e61:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e64:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e6d:	73 42                	jae    c0105eb1 <memmove+0x65>
c0105e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e81:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e84:	c1 e8 02             	shr    $0x2,%eax
c0105e87:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e8f:	89 d7                	mov    %edx,%edi
c0105e91:	89 c6                	mov    %eax,%esi
c0105e93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e95:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e98:	83 e1 03             	and    $0x3,%ecx
c0105e9b:	74 02                	je     c0105e9f <memmove+0x53>
c0105e9d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e9f:	89 f0                	mov    %esi,%eax
c0105ea1:	89 fa                	mov    %edi,%edx
c0105ea3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ea6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ea9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105eaf:	eb 36                	jmp    c0105ee7 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eba:	01 c2                	add    %eax,%edx
c0105ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ebf:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ecb:	89 c1                	mov    %eax,%ecx
c0105ecd:	89 d8                	mov    %ebx,%eax
c0105ecf:	89 d6                	mov    %edx,%esi
c0105ed1:	89 c7                	mov    %eax,%edi
c0105ed3:	fd                   	std    
c0105ed4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ed6:	fc                   	cld    
c0105ed7:	89 f8                	mov    %edi,%eax
c0105ed9:	89 f2                	mov    %esi,%edx
c0105edb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ede:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ee1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ee7:	83 c4 30             	add    $0x30,%esp
c0105eea:	5b                   	pop    %ebx
c0105eeb:	5e                   	pop    %esi
c0105eec:	5f                   	pop    %edi
c0105eed:	5d                   	pop    %ebp
c0105eee:	c3                   	ret    

c0105eef <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105eef:	55                   	push   %ebp
c0105ef0:	89 e5                	mov    %esp,%ebp
c0105ef2:	57                   	push   %edi
c0105ef3:	56                   	push   %esi
c0105ef4:	83 ec 20             	sub    $0x20,%esp
c0105ef7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105efd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f03:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f06:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f0c:	c1 e8 02             	shr    $0x2,%eax
c0105f0f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105f11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f17:	89 d7                	mov    %edx,%edi
c0105f19:	89 c6                	mov    %eax,%esi
c0105f1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f1d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f20:	83 e1 03             	and    $0x3,%ecx
c0105f23:	74 02                	je     c0105f27 <memcpy+0x38>
c0105f25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f27:	89 f0                	mov    %esi,%eax
c0105f29:	89 fa                	mov    %edi,%edx
c0105f2b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f31:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f37:	83 c4 20             	add    $0x20,%esp
c0105f3a:	5e                   	pop    %esi
c0105f3b:	5f                   	pop    %edi
c0105f3c:	5d                   	pop    %ebp
c0105f3d:	c3                   	ret    

c0105f3e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f3e:	55                   	push   %ebp
c0105f3f:	89 e5                	mov    %esp,%ebp
c0105f41:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f50:	eb 2e                	jmp    c0105f80 <memcmp+0x42>
        if (*s1 != *s2) {
c0105f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f55:	0f b6 10             	movzbl (%eax),%edx
c0105f58:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f5b:	0f b6 00             	movzbl (%eax),%eax
c0105f5e:	38 c2                	cmp    %al,%dl
c0105f60:	74 18                	je     c0105f7a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f65:	0f b6 00             	movzbl (%eax),%eax
c0105f68:	0f b6 d0             	movzbl %al,%edx
c0105f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f6e:	0f b6 00             	movzbl (%eax),%eax
c0105f71:	0f b6 c8             	movzbl %al,%ecx
c0105f74:	89 d0                	mov    %edx,%eax
c0105f76:	29 c8                	sub    %ecx,%eax
c0105f78:	eb 18                	jmp    c0105f92 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105f7a:	ff 45 fc             	incl   -0x4(%ebp)
c0105f7d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105f80:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f83:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f86:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f89:	85 c0                	test   %eax,%eax
c0105f8b:	75 c5                	jne    c0105f52 <memcmp+0x14>
    }
    return 0;
c0105f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f92:	89 ec                	mov    %ebp,%esp
c0105f94:	5d                   	pop    %ebp
c0105f95:	c3                   	ret    
