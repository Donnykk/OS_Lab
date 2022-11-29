
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 50 12 00       	mov    $0x125000,%eax
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
c0100020:	a3 00 50 12 c0       	mov    %eax,0xc0125000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 14 81 12 c0       	mov    $0xc0128114,%eax
c0100041:	2d 00 70 12 c0       	sub    $0xc0127000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 70 12 c0 	movl   $0xc0127000,(%esp)
c0100059:	e8 a3 95 00 00       	call   c0109601 <memset>

    cons_init();                // init the console
c010005e:	e8 f9 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 a0 97 10 c0 	movl   $0xc01097a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 bc 97 10 c0 	movl   $0xc01097bc,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 9f 00 00 00       	call   c0100126 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 2a 4d 00 00       	call   c0104db6 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 a9 1f 00 00       	call   c010203a <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 30 21 00 00       	call   c01021c6 <idt_init>

    vmm_init();                 // init virtual memory management
c0100096:	e8 d5 7f 00 00       	call   c0108070 <vmm_init>

    ide_init();                 // init ide devices
c010009b:	e8 f6 16 00 00       	call   c0101796 <ide_init>
    swap_init();                // init swap
c01000a0:	e8 90 60 00 00       	call   c0106135 <swap_init>

    clock_init();               // init clock interrupt
c01000a5:	e8 11 0d 00 00       	call   c0100dbb <clock_init>
    intr_enable();              // enable irq interrupt
c01000aa:	e8 e9 1e 00 00       	call   c0101f98 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000af:	eb fe                	jmp    c01000af <kern_init+0x79>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 03 0c 00 00       	call   c0100cd6 <mon_backtrace>
}
c01000d3:	90                   	nop
c01000d4:	89 ec                	mov    %ebp,%esp
c01000d6:	5d                   	pop    %ebp
c01000d7:	c3                   	ret    

c01000d8 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d8:	55                   	push   %ebp
c01000d9:	89 e5                	mov    %esp,%ebp
c01000db:	83 ec 18             	sub    $0x18,%esp
c01000de:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e7:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ed:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f9:	89 04 24             	mov    %eax,(%esp)
c01000fc:	e8 b0 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c0100101:	90                   	nop
c0100102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100105:	89 ec                	mov    %ebp,%esp
c0100107:	5d                   	pop    %ebp
c0100108:	c3                   	ret    

c0100109 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100112:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100116:	8b 45 08             	mov    0x8(%ebp),%eax
c0100119:	89 04 24             	mov    %eax,(%esp)
c010011c:	e8 b7 ff ff ff       	call   c01000d8 <grade_backtrace1>
}
c0100121:	90                   	nop
c0100122:	89 ec                	mov    %ebp,%esp
c0100124:	5d                   	pop    %ebp
c0100125:	c3                   	ret    

c0100126 <grade_backtrace>:

void
grade_backtrace(void) {
c0100126:	55                   	push   %ebp
c0100127:	89 e5                	mov    %esp,%ebp
c0100129:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012c:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100131:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100138:	ff 
c0100139:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100144:	e8 c0 ff ff ff       	call   c0100109 <grade_backtrace0>
}
c0100149:	90                   	nop
c010014a:	89 ec                	mov    %ebp,%esp
c010014c:	5d                   	pop    %ebp
c010014d:	c3                   	ret    

c010014e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 c1 97 10 c0 	movl   $0xc01097c1,(%esp)
c010017d:	e8 e3 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 cf 97 10 c0 	movl   $0xc01097cf,(%esp)
c010019c:	e8 c4 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 dd 97 10 c0 	movl   $0xc01097dd,(%esp)
c01001bb:	e8 a5 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01001da:	e8 86 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 f9 97 10 c0 	movl   $0xc01097f9,(%esp)
c01001f9:	e8 67 01 00 00       	call   c0100365 <cprintf>
    round ++;
c01001fe:	a1 00 70 12 c0       	mov    0xc0127000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 70 12 c0       	mov    %eax,0xc0127000
}
c0100209:	90                   	nop
c010020a:	89 ec                	mov    %ebp,%esp
c010020c:	5d                   	pop    %ebp
c010020d:	c3                   	ret    

c010020e <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020e:	55                   	push   %ebp
c010020f:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100211:	90                   	nop
c0100212:	5d                   	pop    %ebp
c0100213:	c3                   	ret    

c0100214 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100214:	55                   	push   %ebp
c0100215:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100217:	90                   	nop
c0100218:	5d                   	pop    %ebp
c0100219:	c3                   	ret    

c010021a <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100220:	e8 29 ff ff ff       	call   c010014e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100225:	c7 04 24 08 98 10 c0 	movl   $0xc0109808,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 d8 ff ff ff       	call   c010020e <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 13 ff ff ff       	call   c010014e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 28 98 10 c0 	movl   $0xc0109828,(%esp)
c0100242:	e8 1e 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_kernel();
c0100247:	e8 c8 ff ff ff       	call   c0100214 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024c:	e8 fd fe ff ff       	call   c010014e <lab1_print_cur_status>
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
c0100269:	c7 04 24 47 98 10 c0 	movl   $0xc0109847,(%esp)
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
c01002b7:	88 90 20 70 12 c0    	mov    %dl,-0x3fed8fe0(%eax)
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
c01002f5:	05 20 70 12 c0       	add    $0xc0127020,%eax
c01002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fd:	b8 20 70 12 c0       	mov    $0xc0127020,%eax
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
c0100359:	e8 f6 89 00 00       	call   c0108d54 <vprintfmt>
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
c0100569:	c7 00 4c 98 10 c0    	movl   $0xc010984c,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 4c 98 10 c0 	movl   $0xc010984c,0x8(%eax)
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
c01005a0:	c7 45 f4 64 bb 10 c0 	movl   $0xc010bb64,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 c4 c9 11 c0 	movl   $0xc011c9c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec c5 c9 11 c0 	movl   $0xc011c9c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 c1 1d 12 c0 	movl   $0xc0121dc1,-0x18(%ebp)

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
c0100708:	e8 6c 8d 00 00       	call   c0109479 <strfind>
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
c010088e:	c7 04 24 56 98 10 c0 	movl   $0xc0109856,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 6f 98 10 c0 	movl   $0xc010986f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 8d 97 10 	movl   $0xc010978d,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 87 98 10 c0 	movl   $0xc0109887,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 70 12 	movl   $0xc0127000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 9f 98 10 c0 	movl   $0xc010989f,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 14 81 12 	movl   $0xc0128114,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 b7 98 10 c0 	movl   $0xc01098b7,(%esp)
c01008e5:	e8 7b fa ff ff       	call   c0100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
c01008ea:	b8 14 81 12 c0       	mov    $0xc0128114,%eax
c01008ef:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ff:	85 c0                	test   %eax,%eax
c0100901:	0f 48 c2             	cmovs  %edx,%eax
c0100904:	c1 f8 0a             	sar    $0xa,%eax
c0100907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090b:	c7 04 24 d0 98 10 c0 	movl   $0xc01098d0,(%esp)
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
c0100942:	c7 04 24 fa 98 10 c0 	movl   $0xc01098fa,(%esp)
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
c01009b0:	c7 04 24 16 99 10 c0 	movl   $0xc0109916,(%esp)
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
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c01009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f4:	e9 84 00 00 00       	jmp    c0100a7d <print_stackframe+0xa9>
    {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 28 99 10 c0 	movl   $0xc0109928,(%esp)
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
c0100a3a:	c7 04 24 44 99 10 c0 	movl   $0xc0109944,(%esp)
c0100a41:	e8 1f f9 ff ff       	call   c0100365 <cprintf>
        for (j = 0; j < 4; j++)
c0100a46:	ff 45 e8             	incl   -0x18(%ebp)
c0100a49:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4d:	7e d6                	jle    c0100a25 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a4f:	c7 04 24 4c 99 10 c0 	movl   $0xc010994c,(%esp)
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
c0100ac4:	c7 04 24 d0 99 10 c0 	movl   $0xc01099d0,(%esp)
c0100acb:	e8 75 89 00 00       	call   c0109445 <strchr>
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
c0100aec:	c7 04 24 d5 99 10 c0 	movl   $0xc01099d5,(%esp)
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
c0100b2e:	c7 04 24 d0 99 10 c0 	movl   $0xc01099d0,(%esp)
c0100b35:	e8 0b 89 00 00       	call   c0109445 <strchr>
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
c0100b91:	05 00 40 12 c0       	add    $0xc0124000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 05 88 00 00       	call   c01093a9 <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 31                	jne    c0100bd9 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 08 40 12 c0       	add    $0xc0124008,%eax
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
c0100beb:	c7 04 24 f3 99 10 c0 	movl   $0xc01099f3,(%esp)
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
c0100c09:	c7 04 24 0c 9a 10 c0 	movl   $0xc0109a0c,(%esp)
c0100c10:	e8 50 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c15:	c7 04 24 34 9a 10 c0 	movl   $0xc0109a34,(%esp)
c0100c1c:	e8 44 f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL) {
c0100c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c25:	74 0b                	je     c0100c32 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2a:	89 04 24             	mov    %eax,(%esp)
c0100c2d:	e8 d1 16 00 00       	call   c0102303 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c32:	c7 04 24 59 9a 10 c0 	movl   $0xc0109a59,(%esp)
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
c0100c80:	05 04 40 12 c0       	add    $0xc0124004,%eax
c0100c85:	8b 10                	mov    (%eax),%edx
c0100c87:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c8a:	89 c8                	mov    %ecx,%eax
c0100c8c:	01 c0                	add    %eax,%eax
c0100c8e:	01 c8                	add    %ecx,%eax
c0100c90:	c1 e0 02             	shl    $0x2,%eax
c0100c93:	05 00 40 12 c0       	add    $0xc0124000,%eax
c0100c98:	8b 00                	mov    (%eax),%eax
c0100c9a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca2:	c7 04 24 5d 9a 10 c0 	movl   $0xc0109a5d,(%esp)
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
c0100cf0:	a1 20 74 12 c0       	mov    0xc0127420,%eax
c0100cf5:	85 c0                	test   %eax,%eax
c0100cf7:	75 5b                	jne    c0100d54 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cf9:	c7 05 20 74 12 c0 01 	movl   $0x1,0xc0127420
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
c0100d17:	c7 04 24 66 9a 10 c0 	movl   $0xc0109a66,(%esp)
c0100d1e:	e8 42 f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d2d:	89 04 24             	mov    %eax,(%esp)
c0100d30:	e8 fb f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d35:	c7 04 24 82 9a 10 c0 	movl   $0xc0109a82,(%esp)
c0100d3c:	e8 24 f6 ff ff       	call   c0100365 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d41:	c7 04 24 84 9a 10 c0 	movl   $0xc0109a84,(%esp)
c0100d48:	e8 18 f6 ff ff       	call   c0100365 <cprintf>
    print_stackframe();
c0100d4d:	e8 82 fc ff ff       	call   c01009d4 <print_stackframe>
c0100d52:	eb 01                	jmp    c0100d55 <__panic+0x6b>
        goto panic_dead;
c0100d54:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d55:	e8 46 12 00 00       	call   c0101fa0 <intr_disable>
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
c0100d82:	c7 04 24 96 9a 10 c0 	movl   $0xc0109a96,(%esp)
c0100d89:	e8 d7 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d95:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d98:	89 04 24             	mov    %eax,(%esp)
c0100d9b:	e8 90 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da0:	c7 04 24 82 9a 10 c0 	movl   $0xc0109a82,(%esp)
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
c0100db4:	a1 20 74 12 c0       	mov    0xc0127420,%eax
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
c0100dfd:	c7 05 24 74 12 c0 00 	movl   $0x0,0xc0127424
c0100e04:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e07:	c7 04 24 b4 9a 10 c0 	movl   $0xc0109ab4,(%esp)
c0100e0e:	e8 52 f5 ff ff       	call   c0100365 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e1a:	e8 e6 11 00 00       	call   c0102005 <pic_enable>
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
c0100e3b:	e8 60 11 00 00       	call   c0101fa0 <intr_disable>
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
c0100e5c:	e8 37 11 00 00       	call   c0101f98 <intr_enable>
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
c0100ee7:	66 c7 05 46 74 12 c0 	movw   $0x3b4,0xc0127446
c0100eee:	b4 03 
c0100ef0:	eb 13                	jmp    c0100f05 <cga_init+0x54>
    } else {
        *cp = was;
c0100ef2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ef9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100efc:	66 c7 05 46 74 12 c0 	movw   $0x3d4,0xc0127446
c0100f03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f05:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
c0100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f10:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
}
c0100f1d:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f1e:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
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
c0100f44:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
c0100f4b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f4f:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f53:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f57:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f5b:	ee                   	out    %al,(%dx)
}
c0100f5c:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f5d:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
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
c0100f83:	a3 40 74 12 c0       	mov    %eax,0xc0127440
    crt_pos = pos;
c0100f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f8b:	0f b7 c0             	movzwl %ax,%eax
c0100f8e:	66 a3 44 74 12 c0    	mov    %ax,0xc0127444
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
c0101047:	a3 48 74 12 c0       	mov    %eax,0xc0127448
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
c010106c:	a1 48 74 12 c0       	mov    0xc0127448,%eax
c0101071:	85 c0                	test   %eax,%eax
c0101073:	74 0c                	je     c0101081 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101075:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010107c:	e8 84 0f 00 00       	call   c0102005 <pic_enable>
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
c0101185:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c010118c:	85 c0                	test   %eax,%eax
c010118e:	0f 84 af 00 00 00    	je     c0101243 <cga_putc+0xfd>
            crt_pos --;
c0101194:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c010119b:	48                   	dec    %eax
c010119c:	0f b7 c0             	movzwl %ax,%eax
c010119f:	66 a3 44 74 12 c0    	mov    %ax,0xc0127444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a8:	98                   	cwtl   
c01011a9:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011ae:	98                   	cwtl   
c01011af:	83 c8 20             	or     $0x20,%eax
c01011b2:	98                   	cwtl   
c01011b3:	8b 0d 40 74 12 c0    	mov    0xc0127440,%ecx
c01011b9:	0f b7 15 44 74 12 c0 	movzwl 0xc0127444,%edx
c01011c0:	01 d2                	add    %edx,%edx
c01011c2:	01 ca                	add    %ecx,%edx
c01011c4:	0f b7 c0             	movzwl %ax,%eax
c01011c7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011ca:	eb 77                	jmp    c0101243 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011cc:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c01011d3:	83 c0 50             	add    $0x50,%eax
c01011d6:	0f b7 c0             	movzwl %ax,%eax
c01011d9:	66 a3 44 74 12 c0    	mov    %ax,0xc0127444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011df:	0f b7 1d 44 74 12 c0 	movzwl 0xc0127444,%ebx
c01011e6:	0f b7 0d 44 74 12 c0 	movzwl 0xc0127444,%ecx
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
c0101211:	66 a3 44 74 12 c0    	mov    %ax,0xc0127444
        break;
c0101217:	eb 2b                	jmp    c0101244 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101219:	8b 0d 40 74 12 c0    	mov    0xc0127440,%ecx
c010121f:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c0101226:	8d 50 01             	lea    0x1(%eax),%edx
c0101229:	0f b7 d2             	movzwl %dx,%edx
c010122c:	66 89 15 44 74 12 c0 	mov    %dx,0xc0127444
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
c0101244:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c010124b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101250:	76 5e                	jbe    c01012b0 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101252:	a1 40 74 12 c0       	mov    0xc0127440,%eax
c0101257:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010125d:	a1 40 74 12 c0       	mov    0xc0127440,%eax
c0101262:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101269:	00 
c010126a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010126e:	89 04 24             	mov    %eax,(%esp)
c0101271:	e8 cd 83 00 00       	call   c0109643 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101276:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010127d:	eb 15                	jmp    c0101294 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c010127f:	8b 15 40 74 12 c0    	mov    0xc0127440,%edx
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
c010129d:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c01012a4:	83 e8 50             	sub    $0x50,%eax
c01012a7:	0f b7 c0             	movzwl %ax,%eax
c01012aa:	66 a3 44 74 12 c0    	mov    %ax,0xc0127444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012b0:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
c01012b7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012bb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012c9:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c01012d0:	c1 e8 08             	shr    $0x8,%eax
c01012d3:	0f b7 c0             	movzwl %ax,%eax
c01012d6:	0f b6 c0             	movzbl %al,%eax
c01012d9:	0f b7 15 46 74 12 c0 	movzwl 0xc0127446,%edx
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
c01012f5:	0f b7 05 46 74 12 c0 	movzwl 0xc0127446,%eax
c01012fc:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101300:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101304:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101308:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130c:	ee                   	out    %al,(%dx)
}
c010130d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010130e:	0f b7 05 44 74 12 c0 	movzwl 0xc0127444,%eax
c0101315:	0f b6 c0             	movzbl %al,%eax
c0101318:	0f b7 15 46 74 12 c0 	movzwl 0xc0127446,%edx
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
c01013e8:	a1 64 76 12 c0       	mov    0xc0127664,%eax
c01013ed:	8d 50 01             	lea    0x1(%eax),%edx
c01013f0:	89 15 64 76 12 c0    	mov    %edx,0xc0127664
c01013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013f9:	88 90 60 74 12 c0    	mov    %dl,-0x3fed8ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013ff:	a1 64 76 12 c0       	mov    0xc0127664,%eax
c0101404:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101409:	75 0a                	jne    c0101415 <cons_intr+0x3b>
                cons.wpos = 0;
c010140b:	c7 05 64 76 12 c0 00 	movl   $0x0,0xc0127664
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
c0101488:	a1 48 74 12 c0       	mov    0xc0127448,%eax
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
c01014eb:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c01014f0:	83 c8 40             	or     $0x40,%eax
c01014f3:	a3 68 76 12 c0       	mov    %eax,0xc0127668
        return 0;
c01014f8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014fd:	e9 23 01 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101506:	84 c0                	test   %al,%al
c0101508:	79 45                	jns    c010154f <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010150a:	a1 68 76 12 c0       	mov    0xc0127668,%eax
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
c0101529:	0f b6 80 40 40 12 c0 	movzbl -0x3fedbfc0(%eax),%eax
c0101530:	0c 40                	or     $0x40,%al
c0101532:	0f b6 c0             	movzbl %al,%eax
c0101535:	f7 d0                	not    %eax
c0101537:	89 c2                	mov    %eax,%edx
c0101539:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c010153e:	21 d0                	and    %edx,%eax
c0101540:	a3 68 76 12 c0       	mov    %eax,0xc0127668
        return 0;
c0101545:	b8 00 00 00 00       	mov    $0x0,%eax
c010154a:	e9 d6 00 00 00       	jmp    c0101625 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c010154f:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c0101554:	83 e0 40             	and    $0x40,%eax
c0101557:	85 c0                	test   %eax,%eax
c0101559:	74 11                	je     c010156c <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010155b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010155f:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c0101564:	83 e0 bf             	and    $0xffffffbf,%eax
c0101567:	a3 68 76 12 c0       	mov    %eax,0xc0127668
    }

    shift |= shiftcode[data];
c010156c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101570:	0f b6 80 40 40 12 c0 	movzbl -0x3fedbfc0(%eax),%eax
c0101577:	0f b6 d0             	movzbl %al,%edx
c010157a:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c010157f:	09 d0                	or     %edx,%eax
c0101581:	a3 68 76 12 c0       	mov    %eax,0xc0127668
    shift ^= togglecode[data];
c0101586:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158a:	0f b6 80 40 41 12 c0 	movzbl -0x3fedbec0(%eax),%eax
c0101591:	0f b6 d0             	movzbl %al,%edx
c0101594:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c0101599:	31 d0                	xor    %edx,%eax
c010159b:	a3 68 76 12 c0       	mov    %eax,0xc0127668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a0:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c01015a5:	83 e0 03             	and    $0x3,%eax
c01015a8:	8b 14 85 40 45 12 c0 	mov    -0x3fedbac0(,%eax,4),%edx
c01015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b3:	01 d0                	add    %edx,%eax
c01015b5:	0f b6 00             	movzbl (%eax),%eax
c01015b8:	0f b6 c0             	movzbl %al,%eax
c01015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015be:	a1 68 76 12 c0       	mov    0xc0127668,%eax
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
c01015ec:	a1 68 76 12 c0       	mov    0xc0127668,%eax
c01015f1:	f7 d0                	not    %eax
c01015f3:	83 e0 06             	and    $0x6,%eax
c01015f6:	85 c0                	test   %eax,%eax
c01015f8:	75 28                	jne    c0101622 <kbd_proc_data+0x180>
c01015fa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101601:	75 1f                	jne    c0101622 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101603:	c7 04 24 cf 9a 10 c0 	movl   $0xc0109acf,(%esp)
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
c0101652:	e8 ae 09 00 00       	call   c0102005 <pic_enable>
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
c0101671:	a1 48 74 12 c0       	mov    0xc0127448,%eax
c0101676:	85 c0                	test   %eax,%eax
c0101678:	75 0c                	jne    c0101686 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010167a:	c7 04 24 db 9a 10 c0 	movl   $0xc0109adb,(%esp)
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
c01016e9:	8b 15 60 76 12 c0    	mov    0xc0127660,%edx
c01016ef:	a1 64 76 12 c0       	mov    0xc0127664,%eax
c01016f4:	39 c2                	cmp    %eax,%edx
c01016f6:	74 31                	je     c0101729 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016f8:	a1 60 76 12 c0       	mov    0xc0127660,%eax
c01016fd:	8d 50 01             	lea    0x1(%eax),%edx
c0101700:	89 15 60 76 12 c0    	mov    %edx,0xc0127660
c0101706:	0f b6 80 60 74 12 c0 	movzbl -0x3fed8ba0(%eax),%eax
c010170d:	0f b6 c0             	movzbl %al,%eax
c0101710:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101713:	a1 60 76 12 c0       	mov    0xc0127660,%eax
c0101718:	3d 00 02 00 00       	cmp    $0x200,%eax
c010171d:	75 0a                	jne    c0101729 <cons_getc+0x5f>
                cons.rpos = 0;
c010171f:	c7 05 60 76 12 c0 00 	movl   $0x0,0xc0127660
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

c010173b <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
c010173e:	83 ec 14             	sub    $0x14,%esp
c0101741:	8b 45 08             	mov    0x8(%ebp),%eax
c0101744:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0101748:	90                   	nop
c0101749:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010174c:	83 c0 07             	add    $0x7,%eax
c010174f:	0f b7 c0             	movzwl %ax,%eax
c0101752:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101756:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010175a:	89 c2                	mov    %eax,%edx
c010175c:	ec                   	in     (%dx),%al
c010175d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101760:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101764:	0f b6 c0             	movzbl %al,%eax
c0101767:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010176a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010176d:	25 80 00 00 00       	and    $0x80,%eax
c0101772:	85 c0                	test   %eax,%eax
c0101774:	75 d3                	jne    c0101749 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101776:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010177a:	74 11                	je     c010178d <ide_wait_ready+0x52>
c010177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010177f:	83 e0 21             	and    $0x21,%eax
c0101782:	85 c0                	test   %eax,%eax
c0101784:	74 07                	je     c010178d <ide_wait_ready+0x52>
        return -1;
c0101786:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010178b:	eb 05                	jmp    c0101792 <ide_wait_ready+0x57>
    }
    return 0;
c010178d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101792:	89 ec                	mov    %ebp,%esp
c0101794:	5d                   	pop    %ebp
c0101795:	c3                   	ret    

c0101796 <ide_init>:

void
ide_init(void) {
c0101796:	55                   	push   %ebp
c0101797:	89 e5                	mov    %esp,%ebp
c0101799:	57                   	push   %edi
c010179a:	53                   	push   %ebx
c010179b:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01017a1:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c01017a7:	e9 bd 02 00 00       	jmp    c0101a69 <ide_init+0x2d3>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c01017ac:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017b0:	89 d0                	mov    %edx,%eax
c01017b2:	c1 e0 03             	shl    $0x3,%eax
c01017b5:	29 d0                	sub    %edx,%eax
c01017b7:	c1 e0 03             	shl    $0x3,%eax
c01017ba:	05 80 76 12 c0       	add    $0xc0127680,%eax
c01017bf:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c01017c2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017c6:	d1 e8                	shr    %eax
c01017c8:	0f b7 c0             	movzwl %ax,%eax
c01017cb:	8b 04 85 fc 9a 10 c0 	mov    -0x3fef6504(,%eax,4),%eax
c01017d2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c01017d6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017e1:	00 
c01017e2:	89 04 24             	mov    %eax,(%esp)
c01017e5:	e8 51 ff ff ff       	call   c010173b <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c01017ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017ee:	c1 e0 04             	shl    $0x4,%eax
c01017f1:	24 10                	and    $0x10,%al
c01017f3:	0c e0                	or     $0xe0,%al
c01017f5:	0f b6 c0             	movzbl %al,%eax
c01017f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017fc:	83 c2 06             	add    $0x6,%edx
c01017ff:	0f b7 d2             	movzwl %dx,%edx
c0101802:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0101806:	88 45 c9             	mov    %al,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101809:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010180d:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101811:	ee                   	out    %al,(%dx)
}
c0101812:	90                   	nop
        ide_wait_ready(iobase, 0);
c0101813:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101817:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010181e:	00 
c010181f:	89 04 24             	mov    %eax,(%esp)
c0101822:	e8 14 ff ff ff       	call   c010173b <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0101827:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010182b:	83 c0 07             	add    $0x7,%eax
c010182e:	0f b7 c0             	movzwl %ax,%eax
c0101831:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c0101835:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
}
c0101842:	90                   	nop
        ide_wait_ready(iobase, 0);
c0101843:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101847:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010184e:	00 
c010184f:	89 04 24             	mov    %eax,(%esp)
c0101852:	e8 e4 fe ff ff       	call   c010173b <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0101857:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010185b:	83 c0 07             	add    $0x7,%eax
c010185e:	0f b7 c0             	movzwl %ax,%eax
c0101861:	66 89 45 d2          	mov    %ax,-0x2e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101865:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101869:	89 c2                	mov    %eax,%edx
c010186b:	ec                   	in     (%dx),%al
c010186c:	88 45 d1             	mov    %al,-0x2f(%ebp)
    return data;
c010186f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101873:	84 c0                	test   %al,%al
c0101875:	0f 84 e4 01 00 00    	je     c0101a5f <ide_init+0x2c9>
c010187b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010187f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101886:	00 
c0101887:	89 04 24             	mov    %eax,(%esp)
c010188a:	e8 ac fe ff ff       	call   c010173b <ide_wait_ready>
c010188f:	85 c0                	test   %eax,%eax
c0101891:	0f 85 c8 01 00 00    	jne    c0101a5f <ide_init+0x2c9>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101897:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010189b:	89 d0                	mov    %edx,%eax
c010189d:	c1 e0 03             	shl    $0x3,%eax
c01018a0:	29 d0                	sub    %edx,%eax
c01018a2:	c1 e0 03             	shl    $0x3,%eax
c01018a5:	05 80 76 12 c0       	add    $0xc0127680,%eax
c01018aa:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c01018ad:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01018b4:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c01018ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01018bd:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c01018c4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01018c7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c01018ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01018cd:	89 cb                	mov    %ecx,%ebx
c01018cf:	89 df                	mov    %ebx,%edi
c01018d1:	89 c1                	mov    %eax,%ecx
c01018d3:	fc                   	cld    
c01018d4:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01018d6:	89 c8                	mov    %ecx,%eax
c01018d8:	89 fb                	mov    %edi,%ebx
c01018da:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c01018dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
}
c01018e0:	90                   	nop

        unsigned char *ident = (unsigned char *)buffer;
c01018e1:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c01018e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c01018ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ed:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c01018f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c01018f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018f9:	25 00 00 00 04       	and    $0x4000000,%eax
c01018fe:	85 c0                	test   %eax,%eax
c0101900:	74 0e                	je     c0101910 <ide_init+0x17a>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101905:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010190b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010190e:	eb 09                	jmp    c0101919 <ide_init+0x183>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101913:	8b 40 78             	mov    0x78(%eax),%eax
c0101916:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101919:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010191d:	89 d0                	mov    %edx,%eax
c010191f:	c1 e0 03             	shl    $0x3,%eax
c0101922:	29 d0                	sub    %edx,%eax
c0101924:	c1 e0 03             	shl    $0x3,%eax
c0101927:	8d 90 84 76 12 c0    	lea    -0x3fed897c(%eax),%edx
c010192d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101930:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0101932:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101936:	89 d0                	mov    %edx,%eax
c0101938:	c1 e0 03             	shl    $0x3,%eax
c010193b:	29 d0                	sub    %edx,%eax
c010193d:	c1 e0 03             	shl    $0x3,%eax
c0101940:	8d 90 88 76 12 c0    	lea    -0x3fed8978(%eax),%edx
c0101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101949:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c010194b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010194e:	83 c0 62             	add    $0x62,%eax
c0101951:	0f b7 00             	movzwl (%eax),%eax
c0101954:	25 00 02 00 00       	and    $0x200,%eax
c0101959:	85 c0                	test   %eax,%eax
c010195b:	75 24                	jne    c0101981 <ide_init+0x1eb>
c010195d:	c7 44 24 0c 04 9b 10 	movl   $0xc0109b04,0xc(%esp)
c0101964:	c0 
c0101965:	c7 44 24 08 47 9b 10 	movl   $0xc0109b47,0x8(%esp)
c010196c:	c0 
c010196d:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101974:	00 
c0101975:	c7 04 24 5c 9b 10 c0 	movl   $0xc0109b5c,(%esp)
c010197c:	e8 69 f3 ff ff       	call   c0100cea <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101981:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101985:	89 d0                	mov    %edx,%eax
c0101987:	c1 e0 03             	shl    $0x3,%eax
c010198a:	29 d0                	sub    %edx,%eax
c010198c:	c1 e0 03             	shl    $0x3,%eax
c010198f:	05 80 76 12 c0       	add    $0xc0127680,%eax
c0101994:	83 c0 0c             	add    $0xc,%eax
c0101997:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010199a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010199d:	83 c0 36             	add    $0x36,%eax
c01019a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c01019a3:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c01019aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01019b1:	eb 34                	jmp    c01019e7 <ide_init+0x251>
            model[i] = data[i + 1], model[i + 1] = data[i];
c01019b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019b6:	8d 50 01             	lea    0x1(%eax),%edx
c01019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01019bc:	01 c2                	add    %eax,%edx
c01019be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01019c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019c4:	01 c8                	add    %ecx,%eax
c01019c6:	0f b6 12             	movzbl (%edx),%edx
c01019c9:	88 10                	mov    %dl,(%eax)
c01019cb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01019ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019d1:	01 c2                	add    %eax,%edx
c01019d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019d6:	8d 48 01             	lea    0x1(%eax),%ecx
c01019d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01019dc:	01 c8                	add    %ecx,%eax
c01019de:	0f b6 12             	movzbl (%edx),%edx
c01019e1:	88 10                	mov    %dl,(%eax)
        for (i = 0; i < length; i += 2) {
c01019e3:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c01019e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c01019ed:	72 c4                	jb     c01019b3 <ide_init+0x21d>
        }
        do {
            model[i] = '\0';
c01019ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019f5:	01 d0                	add    %edx,%eax
c01019f7:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c01019fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019fd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a00:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a03:	85 c0                	test   %eax,%eax
c0101a05:	74 0f                	je     c0101a16 <ide_init+0x280>
c0101a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a0d:	01 d0                	add    %edx,%eax
c0101a0f:	0f b6 00             	movzbl (%eax),%eax
c0101a12:	3c 20                	cmp    $0x20,%al
c0101a14:	74 d9                	je     c01019ef <ide_init+0x259>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a16:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101a1a:	89 d0                	mov    %edx,%eax
c0101a1c:	c1 e0 03             	shl    $0x3,%eax
c0101a1f:	29 d0                	sub    %edx,%eax
c0101a21:	c1 e0 03             	shl    $0x3,%eax
c0101a24:	05 80 76 12 c0       	add    $0xc0127680,%eax
c0101a29:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101a2c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101a30:	89 d0                	mov    %edx,%eax
c0101a32:	c1 e0 03             	shl    $0x3,%eax
c0101a35:	29 d0                	sub    %edx,%eax
c0101a37:	c1 e0 03             	shl    $0x3,%eax
c0101a3a:	05 88 76 12 c0       	add    $0xc0127688,%eax
c0101a3f:	8b 10                	mov    (%eax),%edx
c0101a41:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a45:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101a49:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a51:	c7 04 24 6e 9b 10 c0 	movl   $0xc0109b6e,(%esp)
c0101a58:	e8 08 e9 ff ff       	call   c0100365 <cprintf>
c0101a5d:	eb 01                	jmp    c0101a60 <ide_init+0x2ca>
            continue ;
c0101a5f:	90                   	nop
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a60:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a64:	40                   	inc    %eax
c0101a65:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a69:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a6d:	83 f8 03             	cmp    $0x3,%eax
c0101a70:	0f 86 36 fd ff ff    	jbe    c01017ac <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a76:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a7d:	e8 83 05 00 00       	call   c0102005 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a82:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a89:	e8 77 05 00 00       	call   c0102005 <pic_enable>
}
c0101a8e:	90                   	nop
c0101a8f:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a95:	5b                   	pop    %ebx
c0101a96:	5f                   	pop    %edi
c0101a97:	5d                   	pop    %ebp
c0101a98:	c3                   	ret    

c0101a99 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a99:	55                   	push   %ebp
c0101a9a:	89 e5                	mov    %esp,%ebp
c0101a9c:	83 ec 04             	sub    $0x4,%esp
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101aa6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aaa:	83 f8 03             	cmp    $0x3,%eax
c0101aad:	77 21                	ja     c0101ad0 <ide_device_valid+0x37>
c0101aaf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101ab3:	89 d0                	mov    %edx,%eax
c0101ab5:	c1 e0 03             	shl    $0x3,%eax
c0101ab8:	29 d0                	sub    %edx,%eax
c0101aba:	c1 e0 03             	shl    $0x3,%eax
c0101abd:	05 80 76 12 c0       	add    $0xc0127680,%eax
c0101ac2:	0f b6 00             	movzbl (%eax),%eax
c0101ac5:	84 c0                	test   %al,%al
c0101ac7:	74 07                	je     c0101ad0 <ide_device_valid+0x37>
c0101ac9:	b8 01 00 00 00       	mov    $0x1,%eax
c0101ace:	eb 05                	jmp    c0101ad5 <ide_device_valid+0x3c>
c0101ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ad5:	89 ec                	mov    %ebp,%esp
c0101ad7:	5d                   	pop    %ebp
c0101ad8:	c3                   	ret    

c0101ad9 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101ad9:	55                   	push   %ebp
c0101ada:	89 e5                	mov    %esp,%ebp
c0101adc:	83 ec 08             	sub    $0x8,%esp
c0101adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101ae6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aea:	89 04 24             	mov    %eax,(%esp)
c0101aed:	e8 a7 ff ff ff       	call   c0101a99 <ide_device_valid>
c0101af2:	85 c0                	test   %eax,%eax
c0101af4:	74 17                	je     c0101b0d <ide_device_size+0x34>
        return ide_devices[ideno].size;
c0101af6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101afa:	89 d0                	mov    %edx,%eax
c0101afc:	c1 e0 03             	shl    $0x3,%eax
c0101aff:	29 d0                	sub    %edx,%eax
c0101b01:	c1 e0 03             	shl    $0x3,%eax
c0101b04:	05 88 76 12 c0       	add    $0xc0127688,%eax
c0101b09:	8b 00                	mov    (%eax),%eax
c0101b0b:	eb 05                	jmp    c0101b12 <ide_device_size+0x39>
    }
    return 0;
c0101b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b12:	89 ec                	mov    %ebp,%esp
c0101b14:	5d                   	pop    %ebp
c0101b15:	c3                   	ret    

c0101b16 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101b16:	55                   	push   %ebp
c0101b17:	89 e5                	mov    %esp,%ebp
c0101b19:	57                   	push   %edi
c0101b1a:	53                   	push   %ebx
c0101b1b:	83 ec 50             	sub    $0x50,%esp
c0101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b21:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101b25:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101b2c:	77 23                	ja     c0101b51 <ide_read_secs+0x3b>
c0101b2e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b32:	83 f8 03             	cmp    $0x3,%eax
c0101b35:	77 1a                	ja     c0101b51 <ide_read_secs+0x3b>
c0101b37:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c0101b3b:	89 d0                	mov    %edx,%eax
c0101b3d:	c1 e0 03             	shl    $0x3,%eax
c0101b40:	29 d0                	sub    %edx,%eax
c0101b42:	c1 e0 03             	shl    $0x3,%eax
c0101b45:	05 80 76 12 c0       	add    $0xc0127680,%eax
c0101b4a:	0f b6 00             	movzbl (%eax),%eax
c0101b4d:	84 c0                	test   %al,%al
c0101b4f:	75 24                	jne    c0101b75 <ide_read_secs+0x5f>
c0101b51:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c0101b58:	c0 
c0101b59:	c7 44 24 08 47 9b 10 	movl   $0xc0109b47,0x8(%esp)
c0101b60:	c0 
c0101b61:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b68:	00 
c0101b69:	c7 04 24 5c 9b 10 c0 	movl   $0xc0109b5c,(%esp)
c0101b70:	e8 75 f1 ff ff       	call   c0100cea <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b75:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b7c:	77 0f                	ja     c0101b8d <ide_read_secs+0x77>
c0101b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b81:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b84:	01 d0                	add    %edx,%eax
c0101b86:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b8b:	76 24                	jbe    c0101bb1 <ide_read_secs+0x9b>
c0101b8d:	c7 44 24 0c b4 9b 10 	movl   $0xc0109bb4,0xc(%esp)
c0101b94:	c0 
c0101b95:	c7 44 24 08 47 9b 10 	movl   $0xc0109b47,0x8(%esp)
c0101b9c:	c0 
c0101b9d:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101ba4:	00 
c0101ba5:	c7 04 24 5c 9b 10 c0 	movl   $0xc0109b5c,(%esp)
c0101bac:	e8 39 f1 ff ff       	call   c0100cea <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101bb1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bb5:	d1 e8                	shr    %eax
c0101bb7:	0f b7 c0             	movzwl %ax,%eax
c0101bba:	8b 04 85 fc 9a 10 c0 	mov    -0x3fef6504(,%eax,4),%eax
c0101bc1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101bc5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc9:	d1 e8                	shr    %eax
c0101bcb:	0f b7 c0             	movzwl %ax,%eax
c0101bce:	0f b7 04 85 fe 9a 10 	movzwl -0x3fef6502(,%eax,4),%eax
c0101bd5:	c0 
c0101bd6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101bda:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101bde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101be5:	00 
c0101be6:	89 04 24             	mov    %eax,(%esp)
c0101be9:	e8 4d fb ff ff       	call   c010173b <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bf1:	83 c0 02             	add    $0x2,%eax
c0101bf4:	0f b7 c0             	movzwl %ax,%eax
c0101bf7:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101bfb:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bff:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c03:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c07:	ee                   	out    %al,(%dx)
}
c0101c08:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101c09:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c0c:	0f b6 c0             	movzbl %al,%eax
c0101c0f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c13:	83 c2 02             	add    $0x2,%edx
c0101c16:	0f b7 d2             	movzwl %dx,%edx
c0101c19:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c1d:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c20:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c24:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c28:	ee                   	out    %al,(%dx)
}
c0101c29:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c2d:	0f b6 c0             	movzbl %al,%eax
c0101c30:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c34:	83 c2 03             	add    $0x3,%edx
c0101c37:	0f b7 d2             	movzwl %dx,%edx
c0101c3a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c3e:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c41:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c45:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c49:	ee                   	out    %al,(%dx)
}
c0101c4a:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c4e:	c1 e8 08             	shr    $0x8,%eax
c0101c51:	0f b6 c0             	movzbl %al,%eax
c0101c54:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c58:	83 c2 04             	add    $0x4,%edx
c0101c5b:	0f b7 d2             	movzwl %dx,%edx
c0101c5e:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c62:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c65:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c69:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c6d:	ee                   	out    %al,(%dx)
}
c0101c6e:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c72:	c1 e8 10             	shr    $0x10,%eax
c0101c75:	0f b6 c0             	movzbl %al,%eax
c0101c78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c7c:	83 c2 05             	add    $0x5,%edx
c0101c7f:	0f b7 d2             	movzwl %dx,%edx
c0101c82:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101c86:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c89:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101c8d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101c91:	ee                   	out    %al,(%dx)
}
c0101c92:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101c96:	c0 e0 04             	shl    $0x4,%al
c0101c99:	24 10                	and    $0x10,%al
c0101c9b:	88 c2                	mov    %al,%dl
c0101c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ca0:	c1 e8 18             	shr    $0x18,%eax
c0101ca3:	24 0f                	and    $0xf,%al
c0101ca5:	08 d0                	or     %dl,%al
c0101ca7:	0c e0                	or     $0xe0,%al
c0101ca9:	0f b6 c0             	movzbl %al,%eax
c0101cac:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cb0:	83 c2 06             	add    $0x6,%edx
c0101cb3:	0f b7 d2             	movzwl %dx,%edx
c0101cb6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cba:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101cbd:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cc1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cc5:	ee                   	out    %al,(%dx)
}
c0101cc6:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101cc7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ccb:	83 c0 07             	add    $0x7,%eax
c0101cce:	0f b7 c0             	movzwl %ax,%eax
c0101cd1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101cd5:	c6 45 ed 20          	movb   $0x20,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101cd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101cdd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ce1:	ee                   	out    %al,(%dx)
}
c0101ce2:	90                   	nop

    int ret = 0;
c0101ce3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cea:	eb 58                	jmp    c0101d44 <ide_read_secs+0x22e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101cec:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cf0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101cf7:	00 
c0101cf8:	89 04 24             	mov    %eax,(%esp)
c0101cfb:	e8 3b fa ff ff       	call   c010173b <ide_wait_ready>
c0101d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d07:	75 43                	jne    c0101d4c <ide_read_secs+0x236>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d09:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101d10:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d13:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101d16:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101d1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101d20:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101d26:	89 cb                	mov    %ecx,%ebx
c0101d28:	89 df                	mov    %ebx,%edi
c0101d2a:	89 c1                	mov    %eax,%ecx
c0101d2c:	fc                   	cld    
c0101d2d:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101d2f:	89 c8                	mov    %ecx,%eax
c0101d31:	89 fb                	mov    %edi,%ebx
c0101d33:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101d36:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101d39:	90                   	nop
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d3a:	ff 4d 14             	decl   0x14(%ebp)
c0101d3d:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101d44:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101d48:	75 a2                	jne    c0101cec <ide_read_secs+0x1d6>
    }

out:
c0101d4a:	eb 01                	jmp    c0101d4d <ide_read_secs+0x237>
            goto out;
c0101d4c:	90                   	nop
    return ret;
c0101d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101d50:	83 c4 50             	add    $0x50,%esp
c0101d53:	5b                   	pop    %ebx
c0101d54:	5f                   	pop    %edi
c0101d55:	5d                   	pop    %ebp
c0101d56:	c3                   	ret    

c0101d57 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d57:	55                   	push   %ebp
c0101d58:	89 e5                	mov    %esp,%ebp
c0101d5a:	56                   	push   %esi
c0101d5b:	53                   	push   %ebx
c0101d5c:	83 ec 50             	sub    $0x50,%esp
c0101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d62:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d66:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d6d:	77 23                	ja     c0101d92 <ide_write_secs+0x3b>
c0101d6f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d73:	83 f8 03             	cmp    $0x3,%eax
c0101d76:	77 1a                	ja     c0101d92 <ide_write_secs+0x3b>
c0101d78:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c0101d7c:	89 d0                	mov    %edx,%eax
c0101d7e:	c1 e0 03             	shl    $0x3,%eax
c0101d81:	29 d0                	sub    %edx,%eax
c0101d83:	c1 e0 03             	shl    $0x3,%eax
c0101d86:	05 80 76 12 c0       	add    $0xc0127680,%eax
c0101d8b:	0f b6 00             	movzbl (%eax),%eax
c0101d8e:	84 c0                	test   %al,%al
c0101d90:	75 24                	jne    c0101db6 <ide_write_secs+0x5f>
c0101d92:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c0101d99:	c0 
c0101d9a:	c7 44 24 08 47 9b 10 	movl   $0xc0109b47,0x8(%esp)
c0101da1:	c0 
c0101da2:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101da9:	00 
c0101daa:	c7 04 24 5c 9b 10 c0 	movl   $0xc0109b5c,(%esp)
c0101db1:	e8 34 ef ff ff       	call   c0100cea <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101db6:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101dbd:	77 0f                	ja     c0101dce <ide_write_secs+0x77>
c0101dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101dc2:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dc5:	01 d0                	add    %edx,%eax
c0101dc7:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101dcc:	76 24                	jbe    c0101df2 <ide_write_secs+0x9b>
c0101dce:	c7 44 24 0c b4 9b 10 	movl   $0xc0109bb4,0xc(%esp)
c0101dd5:	c0 
c0101dd6:	c7 44 24 08 47 9b 10 	movl   $0xc0109b47,0x8(%esp)
c0101ddd:	c0 
c0101dde:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101de5:	00 
c0101de6:	c7 04 24 5c 9b 10 c0 	movl   $0xc0109b5c,(%esp)
c0101ded:	e8 f8 ee ff ff       	call   c0100cea <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101df2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101df6:	d1 e8                	shr    %eax
c0101df8:	0f b7 c0             	movzwl %ax,%eax
c0101dfb:	8b 04 85 fc 9a 10 c0 	mov    -0x3fef6504(,%eax,4),%eax
c0101e02:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e06:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e0a:	d1 e8                	shr    %eax
c0101e0c:	0f b7 c0             	movzwl %ax,%eax
c0101e0f:	0f b7 04 85 fe 9a 10 	movzwl -0x3fef6502(,%eax,4),%eax
c0101e16:	c0 
c0101e17:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101e1b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101e26:	00 
c0101e27:	89 04 24             	mov    %eax,(%esp)
c0101e2a:	e8 0c f9 ff ff       	call   c010173b <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e32:	83 c0 02             	add    $0x2,%eax
c0101e35:	0f b7 c0             	movzwl %ax,%eax
c0101e38:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101e3c:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e40:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101e44:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101e48:	ee                   	out    %al,(%dx)
}
c0101e49:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101e4a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e4d:	0f b6 c0             	movzbl %al,%eax
c0101e50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e54:	83 c2 02             	add    $0x2,%edx
c0101e57:	0f b7 d2             	movzwl %dx,%edx
c0101e5a:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e5e:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e61:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e65:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e69:	ee                   	out    %al,(%dx)
}
c0101e6a:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e6e:	0f b6 c0             	movzbl %al,%eax
c0101e71:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e75:	83 c2 03             	add    $0x3,%edx
c0101e78:	0f b7 d2             	movzwl %dx,%edx
c0101e7b:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e7f:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e82:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e86:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e8a:	ee                   	out    %al,(%dx)
}
c0101e8b:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8f:	c1 e8 08             	shr    $0x8,%eax
c0101e92:	0f b6 c0             	movzbl %al,%eax
c0101e95:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e99:	83 c2 04             	add    $0x4,%edx
c0101e9c:	0f b7 d2             	movzwl %dx,%edx
c0101e9f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101ea3:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ea6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101eaa:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101eae:	ee                   	out    %al,(%dx)
}
c0101eaf:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eb3:	c1 e8 10             	shr    $0x10,%eax
c0101eb6:	0f b6 c0             	movzbl %al,%eax
c0101eb9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ebd:	83 c2 05             	add    $0x5,%edx
c0101ec0:	0f b7 d2             	movzwl %dx,%edx
c0101ec3:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101ec7:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101eca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ece:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101ed2:	ee                   	out    %al,(%dx)
}
c0101ed3:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101ed4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101ed7:	c0 e0 04             	shl    $0x4,%al
c0101eda:	24 10                	and    $0x10,%al
c0101edc:	88 c2                	mov    %al,%dl
c0101ede:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ee1:	c1 e8 18             	shr    $0x18,%eax
c0101ee4:	24 0f                	and    $0xf,%al
c0101ee6:	08 d0                	or     %dl,%al
c0101ee8:	0c e0                	or     $0xe0,%al
c0101eea:	0f b6 c0             	movzbl %al,%eax
c0101eed:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ef1:	83 c2 06             	add    $0x6,%edx
c0101ef4:	0f b7 d2             	movzwl %dx,%edx
c0101ef7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101efb:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101efe:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101f02:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101f06:	ee                   	out    %al,(%dx)
}
c0101f07:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f08:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f0c:	83 c0 07             	add    $0x7,%eax
c0101f0f:	0f b7 c0             	movzwl %ax,%eax
c0101f12:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101f16:	c6 45 ed 30          	movb   $0x30,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f1a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101f1e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101f22:	ee                   	out    %al,(%dx)
}
c0101f23:	90                   	nop

    int ret = 0;
c0101f24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f2b:	eb 58                	jmp    c0101f85 <ide_write_secs+0x22e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101f2d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101f38:	00 
c0101f39:	89 04 24             	mov    %eax,(%esp)
c0101f3c:	e8 fa f7 ff ff       	call   c010173b <ide_wait_ready>
c0101f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101f48:	75 43                	jne    c0101f8d <ide_write_secs+0x236>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101f4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f51:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f54:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f57:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101f5e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f61:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f64:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f67:	89 cb                	mov    %ecx,%ebx
c0101f69:	89 de                	mov    %ebx,%esi
c0101f6b:	89 c1                	mov    %eax,%ecx
c0101f6d:	fc                   	cld    
c0101f6e:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f70:	89 c8                	mov    %ecx,%eax
c0101f72:	89 f3                	mov    %esi,%ebx
c0101f74:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f77:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101f7a:	90                   	nop
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f7b:	ff 4d 14             	decl   0x14(%ebp)
c0101f7e:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f85:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f89:	75 a2                	jne    c0101f2d <ide_write_secs+0x1d6>
    }

out:
c0101f8b:	eb 01                	jmp    c0101f8e <ide_write_secs+0x237>
            goto out;
c0101f8d:	90                   	nop
    return ret;
c0101f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f91:	83 c4 50             	add    $0x50,%esp
c0101f94:	5b                   	pop    %ebx
c0101f95:	5e                   	pop    %esi
c0101f96:	5d                   	pop    %ebp
c0101f97:	c3                   	ret    

c0101f98 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f98:	55                   	push   %ebp
c0101f99:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101f9b:	fb                   	sti    
}
c0101f9c:	90                   	nop
    sti();
}
c0101f9d:	90                   	nop
c0101f9e:	5d                   	pop    %ebp
c0101f9f:	c3                   	ret    

c0101fa0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101fa0:	55                   	push   %ebp
c0101fa1:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101fa3:	fa                   	cli    
}
c0101fa4:	90                   	nop
    cli();
}
c0101fa5:	90                   	nop
c0101fa6:	5d                   	pop    %ebp
c0101fa7:	c3                   	ret    

c0101fa8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101fa8:	55                   	push   %ebp
c0101fa9:	89 e5                	mov    %esp,%ebp
c0101fab:	83 ec 14             	sub    $0x14,%esp
c0101fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101fb8:	66 a3 50 45 12 c0    	mov    %ax,0xc0124550
    if (did_init) {
c0101fbe:	a1 60 77 12 c0       	mov    0xc0127760,%eax
c0101fc3:	85 c0                	test   %eax,%eax
c0101fc5:	74 39                	je     c0102000 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101fca:	0f b6 c0             	movzbl %al,%eax
c0101fcd:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101fd3:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fd6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fda:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fde:	ee                   	out    %al,(%dx)
}
c0101fdf:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101fe0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101fe4:	c1 e8 08             	shr    $0x8,%eax
c0101fe7:	0f b7 c0             	movzwl %ax,%eax
c0101fea:	0f b6 c0             	movzbl %al,%eax
c0101fed:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101ff3:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ff6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ffa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101ffe:	ee                   	out    %al,(%dx)
}
c0101fff:	90                   	nop
    }
}
c0102000:	90                   	nop
c0102001:	89 ec                	mov    %ebp,%esp
c0102003:	5d                   	pop    %ebp
c0102004:	c3                   	ret    

c0102005 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0102005:	55                   	push   %ebp
c0102006:	89 e5                	mov    %esp,%ebp
c0102008:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010200b:	8b 45 08             	mov    0x8(%ebp),%eax
c010200e:	ba 01 00 00 00       	mov    $0x1,%edx
c0102013:	88 c1                	mov    %al,%cl
c0102015:	d3 e2                	shl    %cl,%edx
c0102017:	89 d0                	mov    %edx,%eax
c0102019:	98                   	cwtl   
c010201a:	f7 d0                	not    %eax
c010201c:	0f bf d0             	movswl %ax,%edx
c010201f:	0f b7 05 50 45 12 c0 	movzwl 0xc0124550,%eax
c0102026:	98                   	cwtl   
c0102027:	21 d0                	and    %edx,%eax
c0102029:	98                   	cwtl   
c010202a:	0f b7 c0             	movzwl %ax,%eax
c010202d:	89 04 24             	mov    %eax,(%esp)
c0102030:	e8 73 ff ff ff       	call   c0101fa8 <pic_setmask>
}
c0102035:	90                   	nop
c0102036:	89 ec                	mov    %ebp,%esp
c0102038:	5d                   	pop    %ebp
c0102039:	c3                   	ret    

c010203a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010203a:	55                   	push   %ebp
c010203b:	89 e5                	mov    %esp,%ebp
c010203d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0102040:	c7 05 60 77 12 c0 01 	movl   $0x1,0xc0127760
c0102047:	00 00 00 
c010204a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0102050:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102054:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0102058:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010205c:	ee                   	out    %al,(%dx)
}
c010205d:	90                   	nop
c010205e:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0102064:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102068:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010206c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0102070:	ee                   	out    %al,(%dx)
}
c0102071:	90                   	nop
c0102072:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0102078:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010207c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0102080:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0102084:	ee                   	out    %al,(%dx)
}
c0102085:	90                   	nop
c0102086:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010208c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102090:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102094:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102098:	ee                   	out    %al,(%dx)
}
c0102099:	90                   	nop
c010209a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01020a0:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020a4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01020a8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020ac:	ee                   	out    %al,(%dx)
}
c01020ad:	90                   	nop
c01020ae:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01020b4:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020b8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01020bc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01020c0:	ee                   	out    %al,(%dx)
}
c01020c1:	90                   	nop
c01020c2:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01020c8:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020cc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01020d0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01020d4:	ee                   	out    %al,(%dx)
}
c01020d5:	90                   	nop
c01020d6:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01020dc:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020e0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01020e4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01020e8:	ee                   	out    %al,(%dx)
}
c01020e9:	90                   	nop
c01020ea:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01020f0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01020f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01020fc:	ee                   	out    %al,(%dx)
}
c01020fd:	90                   	nop
c01020fe:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0102104:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102108:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010210c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102110:	ee                   	out    %al,(%dx)
}
c0102111:	90                   	nop
c0102112:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0102118:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010211c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102120:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102124:	ee                   	out    %al,(%dx)
}
c0102125:	90                   	nop
c0102126:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010212c:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102130:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102134:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102138:	ee                   	out    %al,(%dx)
}
c0102139:	90                   	nop
c010213a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0102140:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102144:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102148:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010214c:	ee                   	out    %al,(%dx)
}
c010214d:	90                   	nop
c010214e:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0102154:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102158:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010215c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102160:	ee                   	out    %al,(%dx)
}
c0102161:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102162:	0f b7 05 50 45 12 c0 	movzwl 0xc0124550,%eax
c0102169:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010216e:	74 0f                	je     c010217f <pic_init+0x145>
        pic_setmask(irq_mask);
c0102170:	0f b7 05 50 45 12 c0 	movzwl 0xc0124550,%eax
c0102177:	89 04 24             	mov    %eax,(%esp)
c010217a:	e8 29 fe ff ff       	call   c0101fa8 <pic_setmask>
    }
}
c010217f:	90                   	nop
c0102180:	89 ec                	mov    %ebp,%esp
c0102182:	5d                   	pop    %ebp
c0102183:	c3                   	ret    

c0102184 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102184:	55                   	push   %ebp
c0102185:	89 e5                	mov    %esp,%ebp
c0102187:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010218a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102191:	00 
c0102192:	c7 04 24 00 9c 10 c0 	movl   $0xc0109c00,(%esp)
c0102199:	e8 c7 e1 ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010219e:	c7 04 24 0a 9c 10 c0 	movl   $0xc0109c0a,(%esp)
c01021a5:	e8 bb e1 ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c01021aa:	c7 44 24 08 18 9c 10 	movl   $0xc0109c18,0x8(%esp)
c01021b1:	c0 
c01021b2:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01021b9:	00 
c01021ba:	c7 04 24 2e 9c 10 c0 	movl   $0xc0109c2e,(%esp)
c01021c1:	e8 24 eb ff ff       	call   c0100cea <__panic>

c01021c6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01021c6:	55                   	push   %ebp
c01021c7:	89 e5                	mov    %esp,%ebp
c01021c9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01021d3:	e9 c4 00 00 00       	jmp    c010229c <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01021d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021db:	8b 04 85 e0 45 12 c0 	mov    -0x3fedba20(,%eax,4),%eax
c01021e2:	0f b7 d0             	movzwl %ax,%edx
c01021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e8:	66 89 14 c5 80 77 12 	mov    %dx,-0x3fed8880(,%eax,8)
c01021ef:	c0 
c01021f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f3:	66 c7 04 c5 82 77 12 	movw   $0x8,-0x3fed887e(,%eax,8)
c01021fa:	c0 08 00 
c01021fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102200:	0f b6 14 c5 84 77 12 	movzbl -0x3fed887c(,%eax,8),%edx
c0102207:	c0 
c0102208:	80 e2 e0             	and    $0xe0,%dl
c010220b:	88 14 c5 84 77 12 c0 	mov    %dl,-0x3fed887c(,%eax,8)
c0102212:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102215:	0f b6 14 c5 84 77 12 	movzbl -0x3fed887c(,%eax,8),%edx
c010221c:	c0 
c010221d:	80 e2 1f             	and    $0x1f,%dl
c0102220:	88 14 c5 84 77 12 c0 	mov    %dl,-0x3fed887c(,%eax,8)
c0102227:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010222a:	0f b6 14 c5 85 77 12 	movzbl -0x3fed887b(,%eax,8),%edx
c0102231:	c0 
c0102232:	80 e2 f0             	and    $0xf0,%dl
c0102235:	80 ca 0e             	or     $0xe,%dl
c0102238:	88 14 c5 85 77 12 c0 	mov    %dl,-0x3fed887b(,%eax,8)
c010223f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102242:	0f b6 14 c5 85 77 12 	movzbl -0x3fed887b(,%eax,8),%edx
c0102249:	c0 
c010224a:	80 e2 ef             	and    $0xef,%dl
c010224d:	88 14 c5 85 77 12 c0 	mov    %dl,-0x3fed887b(,%eax,8)
c0102254:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102257:	0f b6 14 c5 85 77 12 	movzbl -0x3fed887b(,%eax,8),%edx
c010225e:	c0 
c010225f:	80 e2 9f             	and    $0x9f,%dl
c0102262:	88 14 c5 85 77 12 c0 	mov    %dl,-0x3fed887b(,%eax,8)
c0102269:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226c:	0f b6 14 c5 85 77 12 	movzbl -0x3fed887b(,%eax,8),%edx
c0102273:	c0 
c0102274:	80 ca 80             	or     $0x80,%dl
c0102277:	88 14 c5 85 77 12 c0 	mov    %dl,-0x3fed887b(,%eax,8)
c010227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102281:	8b 04 85 e0 45 12 c0 	mov    -0x3fedba20(,%eax,4),%eax
c0102288:	c1 e8 10             	shr    $0x10,%eax
c010228b:	0f b7 d0             	movzwl %ax,%edx
c010228e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102291:	66 89 14 c5 86 77 12 	mov    %dx,-0x3fed887a(,%eax,8)
c0102298:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102299:	ff 45 fc             	incl   -0x4(%ebp)
c010229c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229f:	3d ff 00 00 00       	cmp    $0xff,%eax
c01022a4:	0f 86 2e ff ff ff    	jbe    c01021d8 <idt_init+0x12>
c01022aa:	c7 45 f8 60 45 12 c0 	movl   $0xc0124560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022b4:	0f 01 18             	lidtl  (%eax)
}
c01022b7:	90                   	nop
    }
    lidt(&idt_pd);
}
c01022b8:	90                   	nop
c01022b9:	89 ec                	mov    %ebp,%esp
c01022bb:	5d                   	pop    %ebp
c01022bc:	c3                   	ret    

c01022bd <trapname>:

static const char *
trapname(int trapno) {
c01022bd:	55                   	push   %ebp
c01022be:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c3:	83 f8 13             	cmp    $0x13,%eax
c01022c6:	77 0c                	ja     c01022d4 <trapname+0x17>
        return excnames[trapno];
c01022c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cb:	8b 04 85 80 a0 10 c0 	mov    -0x3fef5f80(,%eax,4),%eax
c01022d2:	eb 18                	jmp    c01022ec <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022d4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022d8:	7e 0d                	jle    c01022e7 <trapname+0x2a>
c01022da:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022de:	7f 07                	jg     c01022e7 <trapname+0x2a>
        return "Hardware Interrupt";
c01022e0:	b8 3f 9c 10 c0       	mov    $0xc0109c3f,%eax
c01022e5:	eb 05                	jmp    c01022ec <trapname+0x2f>
    }
    return "(unknown trap)";
c01022e7:	b8 52 9c 10 c0       	mov    $0xc0109c52,%eax
}
c01022ec:	5d                   	pop    %ebp
c01022ed:	c3                   	ret    

c01022ee <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022ee:	55                   	push   %ebp
c01022ef:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022f8:	83 f8 08             	cmp    $0x8,%eax
c01022fb:	0f 94 c0             	sete   %al
c01022fe:	0f b6 c0             	movzbl %al,%eax
}
c0102301:	5d                   	pop    %ebp
c0102302:	c3                   	ret    

c0102303 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102303:	55                   	push   %ebp
c0102304:	89 e5                	mov    %esp,%ebp
c0102306:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102309:	8b 45 08             	mov    0x8(%ebp),%eax
c010230c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102310:	c7 04 24 93 9c 10 c0 	movl   $0xc0109c93,(%esp)
c0102317:	e8 49 e0 ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c010231c:	8b 45 08             	mov    0x8(%ebp),%eax
c010231f:	89 04 24             	mov    %eax,(%esp)
c0102322:	e8 8f 01 00 00       	call   c01024b6 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102327:	8b 45 08             	mov    0x8(%ebp),%eax
c010232a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010232e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102332:	c7 04 24 a4 9c 10 c0 	movl   $0xc0109ca4,(%esp)
c0102339:	e8 27 e0 ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010233e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102341:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102345:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102349:	c7 04 24 b7 9c 10 c0 	movl   $0xc0109cb7,(%esp)
c0102350:	e8 10 e0 ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102355:	8b 45 08             	mov    0x8(%ebp),%eax
c0102358:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010235c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102360:	c7 04 24 ca 9c 10 c0 	movl   $0xc0109cca,(%esp)
c0102367:	e8 f9 df ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010236c:	8b 45 08             	mov    0x8(%ebp),%eax
c010236f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102373:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102377:	c7 04 24 dd 9c 10 c0 	movl   $0xc0109cdd,(%esp)
c010237e:	e8 e2 df ff ff       	call   c0100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102383:	8b 45 08             	mov    0x8(%ebp),%eax
c0102386:	8b 40 30             	mov    0x30(%eax),%eax
c0102389:	89 04 24             	mov    %eax,(%esp)
c010238c:	e8 2c ff ff ff       	call   c01022bd <trapname>
c0102391:	8b 55 08             	mov    0x8(%ebp),%edx
c0102394:	8b 52 30             	mov    0x30(%edx),%edx
c0102397:	89 44 24 08          	mov    %eax,0x8(%esp)
c010239b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010239f:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c01023a6:	e8 ba df ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ae:	8b 40 34             	mov    0x34(%eax),%eax
c01023b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b5:	c7 04 24 02 9d 10 c0 	movl   $0xc0109d02,(%esp)
c01023bc:	e8 a4 df ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c4:	8b 40 38             	mov    0x38(%eax),%eax
c01023c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023cb:	c7 04 24 11 9d 10 c0 	movl   $0xc0109d11,(%esp)
c01023d2:	e8 8e df ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023da:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e2:	c7 04 24 20 9d 10 c0 	movl   $0xc0109d20,(%esp)
c01023e9:	e8 77 df ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f1:	8b 40 40             	mov    0x40(%eax),%eax
c01023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f8:	c7 04 24 33 9d 10 c0 	movl   $0xc0109d33,(%esp)
c01023ff:	e8 61 df ff ff       	call   c0100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010240b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102412:	eb 3d                	jmp    c0102451 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102414:	8b 45 08             	mov    0x8(%ebp),%eax
c0102417:	8b 50 40             	mov    0x40(%eax),%edx
c010241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010241d:	21 d0                	and    %edx,%eax
c010241f:	85 c0                	test   %eax,%eax
c0102421:	74 28                	je     c010244b <print_trapframe+0x148>
c0102423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102426:	8b 04 85 80 45 12 c0 	mov    -0x3fedba80(,%eax,4),%eax
c010242d:	85 c0                	test   %eax,%eax
c010242f:	74 1a                	je     c010244b <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0102431:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102434:	8b 04 85 80 45 12 c0 	mov    -0x3fedba80(,%eax,4),%eax
c010243b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010243f:	c7 04 24 42 9d 10 c0 	movl   $0xc0109d42,(%esp)
c0102446:	e8 1a df ff ff       	call   c0100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010244b:	ff 45 f4             	incl   -0xc(%ebp)
c010244e:	d1 65 f0             	shll   -0x10(%ebp)
c0102451:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102454:	83 f8 17             	cmp    $0x17,%eax
c0102457:	76 bb                	jbe    c0102414 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102459:	8b 45 08             	mov    0x8(%ebp),%eax
c010245c:	8b 40 40             	mov    0x40(%eax),%eax
c010245f:	c1 e8 0c             	shr    $0xc,%eax
c0102462:	83 e0 03             	and    $0x3,%eax
c0102465:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102469:	c7 04 24 46 9d 10 c0 	movl   $0xc0109d46,(%esp)
c0102470:	e8 f0 de ff ff       	call   c0100365 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102475:	8b 45 08             	mov    0x8(%ebp),%eax
c0102478:	89 04 24             	mov    %eax,(%esp)
c010247b:	e8 6e fe ff ff       	call   c01022ee <trap_in_kernel>
c0102480:	85 c0                	test   %eax,%eax
c0102482:	75 2d                	jne    c01024b1 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102484:	8b 45 08             	mov    0x8(%ebp),%eax
c0102487:	8b 40 44             	mov    0x44(%eax),%eax
c010248a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248e:	c7 04 24 4f 9d 10 c0 	movl   $0xc0109d4f,(%esp)
c0102495:	e8 cb de ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a5:	c7 04 24 5e 9d 10 c0 	movl   $0xc0109d5e,(%esp)
c01024ac:	e8 b4 de ff ff       	call   c0100365 <cprintf>
    }
}
c01024b1:	90                   	nop
c01024b2:	89 ec                	mov    %ebp,%esp
c01024b4:	5d                   	pop    %ebp
c01024b5:	c3                   	ret    

c01024b6 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024b6:	55                   	push   %ebp
c01024b7:	89 e5                	mov    %esp,%ebp
c01024b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024bf:	8b 00                	mov    (%eax),%eax
c01024c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c5:	c7 04 24 71 9d 10 c0 	movl   $0xc0109d71,(%esp)
c01024cc:	e8 94 de ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d4:	8b 40 04             	mov    0x4(%eax),%eax
c01024d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024db:	c7 04 24 80 9d 10 c0 	movl   $0xc0109d80,(%esp)
c01024e2:	e8 7e de ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ea:	8b 40 08             	mov    0x8(%eax),%eax
c01024ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f1:	c7 04 24 8f 9d 10 c0 	movl   $0xc0109d8f,(%esp)
c01024f8:	e8 68 de ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102500:	8b 40 0c             	mov    0xc(%eax),%eax
c0102503:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102507:	c7 04 24 9e 9d 10 c0 	movl   $0xc0109d9e,(%esp)
c010250e:	e8 52 de ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102513:	8b 45 08             	mov    0x8(%ebp),%eax
c0102516:	8b 40 10             	mov    0x10(%eax),%eax
c0102519:	89 44 24 04          	mov    %eax,0x4(%esp)
c010251d:	c7 04 24 ad 9d 10 c0 	movl   $0xc0109dad,(%esp)
c0102524:	e8 3c de ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102529:	8b 45 08             	mov    0x8(%ebp),%eax
c010252c:	8b 40 14             	mov    0x14(%eax),%eax
c010252f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102533:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010253a:	e8 26 de ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010253f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102542:	8b 40 18             	mov    0x18(%eax),%eax
c0102545:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102549:	c7 04 24 cb 9d 10 c0 	movl   $0xc0109dcb,(%esp)
c0102550:	e8 10 de ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102555:	8b 45 08             	mov    0x8(%ebp),%eax
c0102558:	8b 40 1c             	mov    0x1c(%eax),%eax
c010255b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010255f:	c7 04 24 da 9d 10 c0 	movl   $0xc0109dda,(%esp)
c0102566:	e8 fa dd ff ff       	call   c0100365 <cprintf>
}
c010256b:	90                   	nop
c010256c:	89 ec                	mov    %ebp,%esp
c010256e:	5d                   	pop    %ebp
c010256f:	c3                   	ret    

c0102570 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102570:	55                   	push   %ebp
c0102571:	89 e5                	mov    %esp,%ebp
c0102573:	83 ec 38             	sub    $0x38,%esp
c0102576:	89 5d fc             	mov    %ebx,-0x4(%ebp)
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102579:	8b 45 08             	mov    0x8(%ebp),%eax
c010257c:	8b 40 34             	mov    0x34(%eax),%eax
c010257f:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102582:	85 c0                	test   %eax,%eax
c0102584:	74 07                	je     c010258d <print_pgfault+0x1d>
c0102586:	bb e9 9d 10 c0       	mov    $0xc0109de9,%ebx
c010258b:	eb 05                	jmp    c0102592 <print_pgfault+0x22>
c010258d:	bb fa 9d 10 c0       	mov    $0xc0109dfa,%ebx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102592:	8b 45 08             	mov    0x8(%ebp),%eax
c0102595:	8b 40 34             	mov    0x34(%eax),%eax
c0102598:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010259b:	85 c0                	test   %eax,%eax
c010259d:	74 07                	je     c01025a6 <print_pgfault+0x36>
c010259f:	b9 57 00 00 00       	mov    $0x57,%ecx
c01025a4:	eb 05                	jmp    c01025ab <print_pgfault+0x3b>
c01025a6:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ae:	8b 40 34             	mov    0x34(%eax),%eax
c01025b1:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025b4:	85 c0                	test   %eax,%eax
c01025b6:	74 07                	je     c01025bf <print_pgfault+0x4f>
c01025b8:	ba 55 00 00 00       	mov    $0x55,%edx
c01025bd:	eb 05                	jmp    c01025c4 <print_pgfault+0x54>
c01025bf:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025c4:	0f 20 d0             	mov    %cr2,%eax
c01025c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025cd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c01025d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01025d5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01025d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025dd:	c7 04 24 08 9e 10 c0 	movl   $0xc0109e08,(%esp)
c01025e4:	e8 7c dd ff ff       	call   c0100365 <cprintf>
}
c01025e9:	90                   	nop
c01025ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01025ed:	89 ec                	mov    %ebp,%esp
c01025ef:	5d                   	pop    %ebp
c01025f0:	c3                   	ret    

c01025f1 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025f1:	55                   	push   %ebp
c01025f2:	89 e5                	mov    %esp,%ebp
c01025f4:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	89 04 24             	mov    %eax,(%esp)
c01025fd:	e8 6e ff ff ff       	call   c0102570 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102602:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c0102607:	85 c0                	test   %eax,%eax
c0102609:	74 26                	je     c0102631 <pgfault_handler+0x40>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010260b:	0f 20 d0             	mov    %cr2,%eax
c010260e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102611:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	8b 50 34             	mov    0x34(%eax),%edx
c010261a:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c010261f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102623:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102627:	89 04 24             	mov    %eax,(%esp)
c010262a:	e8 b0 61 00 00       	call   c01087df <do_pgfault>
c010262f:	eb 1c                	jmp    c010264d <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c0102631:	c7 44 24 08 2b 9e 10 	movl   $0xc0109e2b,0x8(%esp)
c0102638:	c0 
c0102639:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0102640:	00 
c0102641:	c7 04 24 2e 9c 10 c0 	movl   $0xc0109c2e,(%esp)
c0102648:	e8 9d e6 ff ff       	call   c0100cea <__panic>
}
c010264d:	89 ec                	mov    %ebp,%esp
c010264f:	5d                   	pop    %ebp
c0102650:	c3                   	ret    

c0102651 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102651:	55                   	push   %ebp
c0102652:	89 e5                	mov    %esp,%ebp
c0102654:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102657:	8b 45 08             	mov    0x8(%ebp),%eax
c010265a:	8b 40 30             	mov    0x30(%eax),%eax
c010265d:	83 f8 2f             	cmp    $0x2f,%eax
c0102660:	77 1e                	ja     c0102680 <trap_dispatch+0x2f>
c0102662:	83 f8 0e             	cmp    $0xe,%eax
c0102665:	0f 82 1a 01 00 00    	jb     c0102785 <trap_dispatch+0x134>
c010266b:	83 e8 0e             	sub    $0xe,%eax
c010266e:	83 f8 21             	cmp    $0x21,%eax
c0102671:	0f 87 0e 01 00 00    	ja     c0102785 <trap_dispatch+0x134>
c0102677:	8b 04 85 ac 9e 10 c0 	mov    -0x3fef6154(,%eax,4),%eax
c010267e:	ff e0                	jmp    *%eax
c0102680:	83 e8 78             	sub    $0x78,%eax
c0102683:	83 f8 01             	cmp    $0x1,%eax
c0102686:	0f 87 f9 00 00 00    	ja     c0102785 <trap_dispatch+0x134>
c010268c:	e9 d8 00 00 00       	jmp    c0102769 <trap_dispatch+0x118>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102691:	8b 45 08             	mov    0x8(%ebp),%eax
c0102694:	89 04 24             	mov    %eax,(%esp)
c0102697:	e8 55 ff ff ff       	call   c01025f1 <pgfault_handler>
c010269c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010269f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01026a3:	0f 84 14 01 00 00    	je     c01027bd <trap_dispatch+0x16c>
            print_trapframe(tf);
c01026a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ac:	89 04 24             	mov    %eax,(%esp)
c01026af:	e8 4f fc ff ff       	call   c0102303 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026bb:	c7 44 24 08 42 9e 10 	movl   $0xc0109e42,0x8(%esp)
c01026c2:	c0 
c01026c3:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01026ca:	00 
c01026cb:	c7 04 24 2e 9c 10 c0 	movl   $0xc0109c2e,(%esp)
c01026d2:	e8 13 e6 ff ff       	call   c0100cea <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c01026d7:	a1 24 74 12 c0       	mov    0xc0127424,%eax
c01026dc:	40                   	inc    %eax
c01026dd:	a3 24 74 12 c0       	mov    %eax,0xc0127424
        if (ticks % TICK_NUM == 0) {
c01026e2:	8b 0d 24 74 12 c0    	mov    0xc0127424,%ecx
c01026e8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026ed:	89 c8                	mov    %ecx,%eax
c01026ef:	f7 e2                	mul    %edx
c01026f1:	c1 ea 05             	shr    $0x5,%edx
c01026f4:	89 d0                	mov    %edx,%eax
c01026f6:	c1 e0 02             	shl    $0x2,%eax
c01026f9:	01 d0                	add    %edx,%eax
c01026fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102702:	01 d0                	add    %edx,%eax
c0102704:	c1 e0 02             	shl    $0x2,%eax
c0102707:	29 c1                	sub    %eax,%ecx
c0102709:	89 ca                	mov    %ecx,%edx
c010270b:	85 d2                	test   %edx,%edx
c010270d:	0f 85 ad 00 00 00    	jne    c01027c0 <trap_dispatch+0x16f>
            print_ticks();
c0102713:	e8 6c fa ff ff       	call   c0102184 <print_ticks>
        }
        break;
c0102718:	e9 a3 00 00 00       	jmp    c01027c0 <trap_dispatch+0x16f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c010271d:	e8 a8 ef ff ff       	call   c01016ca <cons_getc>
c0102722:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102725:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102729:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010272d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102731:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102735:	c7 04 24 5d 9e 10 c0 	movl   $0xc0109e5d,(%esp)
c010273c:	e8 24 dc ff ff       	call   c0100365 <cprintf>
        break;
c0102741:	eb 7e                	jmp    c01027c1 <trap_dispatch+0x170>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102743:	e8 82 ef ff ff       	call   c01016ca <cons_getc>
c0102748:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010274b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c010274f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102753:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102757:	89 44 24 04          	mov    %eax,0x4(%esp)
c010275b:	c7 04 24 6f 9e 10 c0 	movl   $0xc0109e6f,(%esp)
c0102762:	e8 fe db ff ff       	call   c0100365 <cprintf>
        break;
c0102767:	eb 58                	jmp    c01027c1 <trap_dispatch+0x170>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102769:	c7 44 24 08 7e 9e 10 	movl   $0xc0109e7e,0x8(%esp)
c0102770:	c0 
c0102771:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0102778:	00 
c0102779:	c7 04 24 2e 9c 10 c0 	movl   $0xc0109c2e,(%esp)
c0102780:	e8 65 e5 ff ff       	call   c0100cea <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102785:	8b 45 08             	mov    0x8(%ebp),%eax
c0102788:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010278c:	83 e0 03             	and    $0x3,%eax
c010278f:	85 c0                	test   %eax,%eax
c0102791:	75 2e                	jne    c01027c1 <trap_dispatch+0x170>
            print_trapframe(tf);
c0102793:	8b 45 08             	mov    0x8(%ebp),%eax
c0102796:	89 04 24             	mov    %eax,(%esp)
c0102799:	e8 65 fb ff ff       	call   c0102303 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010279e:	c7 44 24 08 8e 9e 10 	movl   $0xc0109e8e,0x8(%esp)
c01027a5:	c0 
c01027a6:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01027ad:	00 
c01027ae:	c7 04 24 2e 9c 10 c0 	movl   $0xc0109c2e,(%esp)
c01027b5:	e8 30 e5 ff ff       	call   c0100cea <__panic>
        break;
c01027ba:	90                   	nop
c01027bb:	eb 04                	jmp    c01027c1 <trap_dispatch+0x170>
        break;
c01027bd:	90                   	nop
c01027be:	eb 01                	jmp    c01027c1 <trap_dispatch+0x170>
        break;
c01027c0:	90                   	nop
        }
    }
}
c01027c1:	90                   	nop
c01027c2:	89 ec                	mov    %ebp,%esp
c01027c4:	5d                   	pop    %ebp
c01027c5:	c3                   	ret    

c01027c6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027c6:	55                   	push   %ebp
c01027c7:	89 e5                	mov    %esp,%ebp
c01027c9:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01027cf:	89 04 24             	mov    %eax,(%esp)
c01027d2:	e8 7a fe ff ff       	call   c0102651 <trap_dispatch>
}
c01027d7:	90                   	nop
c01027d8:	89 ec                	mov    %ebp,%esp
c01027da:	5d                   	pop    %ebp
c01027db:	c3                   	ret    

c01027dc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01027dc:	1e                   	push   %ds
    pushl %es
c01027dd:	06                   	push   %es
    pushl %fs
c01027de:	0f a0                	push   %fs
    pushl %gs
c01027e0:	0f a8                	push   %gs
    pushal
c01027e2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01027e3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01027e8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01027ea:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01027ec:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01027ed:	e8 d4 ff ff ff       	call   c01027c6 <trap>

    # pop the pushed stack pointer
    popl %esp
c01027f2:	5c                   	pop    %esp

c01027f3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01027f3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01027f4:	0f a9                	pop    %gs
    popl %fs
c01027f6:	0f a1                	pop    %fs
    popl %es
c01027f8:	07                   	pop    %es
    popl %ds
c01027f9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01027fa:	83 c4 08             	add    $0x8,%esp
    iret
c01027fd:	cf                   	iret   

c01027fe <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027fe:	6a 00                	push   $0x0
  pushl $0
c0102800:	6a 00                	push   $0x0
  jmp __alltraps
c0102802:	e9 d5 ff ff ff       	jmp    c01027dc <__alltraps>

c0102807 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $1
c0102809:	6a 01                	push   $0x1
  jmp __alltraps
c010280b:	e9 cc ff ff ff       	jmp    c01027dc <__alltraps>

c0102810 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $2
c0102812:	6a 02                	push   $0x2
  jmp __alltraps
c0102814:	e9 c3 ff ff ff       	jmp    c01027dc <__alltraps>

c0102819 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $3
c010281b:	6a 03                	push   $0x3
  jmp __alltraps
c010281d:	e9 ba ff ff ff       	jmp    c01027dc <__alltraps>

c0102822 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102822:	6a 00                	push   $0x0
  pushl $4
c0102824:	6a 04                	push   $0x4
  jmp __alltraps
c0102826:	e9 b1 ff ff ff       	jmp    c01027dc <__alltraps>

c010282b <vector5>:
.globl vector5
vector5:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $5
c010282d:	6a 05                	push   $0x5
  jmp __alltraps
c010282f:	e9 a8 ff ff ff       	jmp    c01027dc <__alltraps>

c0102834 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $6
c0102836:	6a 06                	push   $0x6
  jmp __alltraps
c0102838:	e9 9f ff ff ff       	jmp    c01027dc <__alltraps>

c010283d <vector7>:
.globl vector7
vector7:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $7
c010283f:	6a 07                	push   $0x7
  jmp __alltraps
c0102841:	e9 96 ff ff ff       	jmp    c01027dc <__alltraps>

c0102846 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102846:	6a 08                	push   $0x8
  jmp __alltraps
c0102848:	e9 8f ff ff ff       	jmp    c01027dc <__alltraps>

c010284d <vector9>:
.globl vector9
vector9:
  pushl $0
c010284d:	6a 00                	push   $0x0
  pushl $9
c010284f:	6a 09                	push   $0x9
  jmp __alltraps
c0102851:	e9 86 ff ff ff       	jmp    c01027dc <__alltraps>

c0102856 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102856:	6a 0a                	push   $0xa
  jmp __alltraps
c0102858:	e9 7f ff ff ff       	jmp    c01027dc <__alltraps>

c010285d <vector11>:
.globl vector11
vector11:
  pushl $11
c010285d:	6a 0b                	push   $0xb
  jmp __alltraps
c010285f:	e9 78 ff ff ff       	jmp    c01027dc <__alltraps>

c0102864 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102864:	6a 0c                	push   $0xc
  jmp __alltraps
c0102866:	e9 71 ff ff ff       	jmp    c01027dc <__alltraps>

c010286b <vector13>:
.globl vector13
vector13:
  pushl $13
c010286b:	6a 0d                	push   $0xd
  jmp __alltraps
c010286d:	e9 6a ff ff ff       	jmp    c01027dc <__alltraps>

c0102872 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102872:	6a 0e                	push   $0xe
  jmp __alltraps
c0102874:	e9 63 ff ff ff       	jmp    c01027dc <__alltraps>

c0102879 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $15
c010287b:	6a 0f                	push   $0xf
  jmp __alltraps
c010287d:	e9 5a ff ff ff       	jmp    c01027dc <__alltraps>

c0102882 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $16
c0102884:	6a 10                	push   $0x10
  jmp __alltraps
c0102886:	e9 51 ff ff ff       	jmp    c01027dc <__alltraps>

c010288b <vector17>:
.globl vector17
vector17:
  pushl $17
c010288b:	6a 11                	push   $0x11
  jmp __alltraps
c010288d:	e9 4a ff ff ff       	jmp    c01027dc <__alltraps>

c0102892 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $18
c0102894:	6a 12                	push   $0x12
  jmp __alltraps
c0102896:	e9 41 ff ff ff       	jmp    c01027dc <__alltraps>

c010289b <vector19>:
.globl vector19
vector19:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $19
c010289d:	6a 13                	push   $0x13
  jmp __alltraps
c010289f:	e9 38 ff ff ff       	jmp    c01027dc <__alltraps>

c01028a4 <vector20>:
.globl vector20
vector20:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $20
c01028a6:	6a 14                	push   $0x14
  jmp __alltraps
c01028a8:	e9 2f ff ff ff       	jmp    c01027dc <__alltraps>

c01028ad <vector21>:
.globl vector21
vector21:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $21
c01028af:	6a 15                	push   $0x15
  jmp __alltraps
c01028b1:	e9 26 ff ff ff       	jmp    c01027dc <__alltraps>

c01028b6 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $22
c01028b8:	6a 16                	push   $0x16
  jmp __alltraps
c01028ba:	e9 1d ff ff ff       	jmp    c01027dc <__alltraps>

c01028bf <vector23>:
.globl vector23
vector23:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $23
c01028c1:	6a 17                	push   $0x17
  jmp __alltraps
c01028c3:	e9 14 ff ff ff       	jmp    c01027dc <__alltraps>

c01028c8 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $24
c01028ca:	6a 18                	push   $0x18
  jmp __alltraps
c01028cc:	e9 0b ff ff ff       	jmp    c01027dc <__alltraps>

c01028d1 <vector25>:
.globl vector25
vector25:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $25
c01028d3:	6a 19                	push   $0x19
  jmp __alltraps
c01028d5:	e9 02 ff ff ff       	jmp    c01027dc <__alltraps>

c01028da <vector26>:
.globl vector26
vector26:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $26
c01028dc:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028de:	e9 f9 fe ff ff       	jmp    c01027dc <__alltraps>

c01028e3 <vector27>:
.globl vector27
vector27:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $27
c01028e5:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028e7:	e9 f0 fe ff ff       	jmp    c01027dc <__alltraps>

c01028ec <vector28>:
.globl vector28
vector28:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $28
c01028ee:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028f0:	e9 e7 fe ff ff       	jmp    c01027dc <__alltraps>

c01028f5 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $29
c01028f7:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028f9:	e9 de fe ff ff       	jmp    c01027dc <__alltraps>

c01028fe <vector30>:
.globl vector30
vector30:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $30
c0102900:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102902:	e9 d5 fe ff ff       	jmp    c01027dc <__alltraps>

c0102907 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $31
c0102909:	6a 1f                	push   $0x1f
  jmp __alltraps
c010290b:	e9 cc fe ff ff       	jmp    c01027dc <__alltraps>

c0102910 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $32
c0102912:	6a 20                	push   $0x20
  jmp __alltraps
c0102914:	e9 c3 fe ff ff       	jmp    c01027dc <__alltraps>

c0102919 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $33
c010291b:	6a 21                	push   $0x21
  jmp __alltraps
c010291d:	e9 ba fe ff ff       	jmp    c01027dc <__alltraps>

c0102922 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $34
c0102924:	6a 22                	push   $0x22
  jmp __alltraps
c0102926:	e9 b1 fe ff ff       	jmp    c01027dc <__alltraps>

c010292b <vector35>:
.globl vector35
vector35:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $35
c010292d:	6a 23                	push   $0x23
  jmp __alltraps
c010292f:	e9 a8 fe ff ff       	jmp    c01027dc <__alltraps>

c0102934 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $36
c0102936:	6a 24                	push   $0x24
  jmp __alltraps
c0102938:	e9 9f fe ff ff       	jmp    c01027dc <__alltraps>

c010293d <vector37>:
.globl vector37
vector37:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $37
c010293f:	6a 25                	push   $0x25
  jmp __alltraps
c0102941:	e9 96 fe ff ff       	jmp    c01027dc <__alltraps>

c0102946 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $38
c0102948:	6a 26                	push   $0x26
  jmp __alltraps
c010294a:	e9 8d fe ff ff       	jmp    c01027dc <__alltraps>

c010294f <vector39>:
.globl vector39
vector39:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $39
c0102951:	6a 27                	push   $0x27
  jmp __alltraps
c0102953:	e9 84 fe ff ff       	jmp    c01027dc <__alltraps>

c0102958 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $40
c010295a:	6a 28                	push   $0x28
  jmp __alltraps
c010295c:	e9 7b fe ff ff       	jmp    c01027dc <__alltraps>

c0102961 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $41
c0102963:	6a 29                	push   $0x29
  jmp __alltraps
c0102965:	e9 72 fe ff ff       	jmp    c01027dc <__alltraps>

c010296a <vector42>:
.globl vector42
vector42:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $42
c010296c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010296e:	e9 69 fe ff ff       	jmp    c01027dc <__alltraps>

c0102973 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $43
c0102975:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102977:	e9 60 fe ff ff       	jmp    c01027dc <__alltraps>

c010297c <vector44>:
.globl vector44
vector44:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $44
c010297e:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102980:	e9 57 fe ff ff       	jmp    c01027dc <__alltraps>

c0102985 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $45
c0102987:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102989:	e9 4e fe ff ff       	jmp    c01027dc <__alltraps>

c010298e <vector46>:
.globl vector46
vector46:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $46
c0102990:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102992:	e9 45 fe ff ff       	jmp    c01027dc <__alltraps>

c0102997 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $47
c0102999:	6a 2f                	push   $0x2f
  jmp __alltraps
c010299b:	e9 3c fe ff ff       	jmp    c01027dc <__alltraps>

c01029a0 <vector48>:
.globl vector48
vector48:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $48
c01029a2:	6a 30                	push   $0x30
  jmp __alltraps
c01029a4:	e9 33 fe ff ff       	jmp    c01027dc <__alltraps>

c01029a9 <vector49>:
.globl vector49
vector49:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $49
c01029ab:	6a 31                	push   $0x31
  jmp __alltraps
c01029ad:	e9 2a fe ff ff       	jmp    c01027dc <__alltraps>

c01029b2 <vector50>:
.globl vector50
vector50:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $50
c01029b4:	6a 32                	push   $0x32
  jmp __alltraps
c01029b6:	e9 21 fe ff ff       	jmp    c01027dc <__alltraps>

c01029bb <vector51>:
.globl vector51
vector51:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $51
c01029bd:	6a 33                	push   $0x33
  jmp __alltraps
c01029bf:	e9 18 fe ff ff       	jmp    c01027dc <__alltraps>

c01029c4 <vector52>:
.globl vector52
vector52:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $52
c01029c6:	6a 34                	push   $0x34
  jmp __alltraps
c01029c8:	e9 0f fe ff ff       	jmp    c01027dc <__alltraps>

c01029cd <vector53>:
.globl vector53
vector53:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $53
c01029cf:	6a 35                	push   $0x35
  jmp __alltraps
c01029d1:	e9 06 fe ff ff       	jmp    c01027dc <__alltraps>

c01029d6 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $54
c01029d8:	6a 36                	push   $0x36
  jmp __alltraps
c01029da:	e9 fd fd ff ff       	jmp    c01027dc <__alltraps>

c01029df <vector55>:
.globl vector55
vector55:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $55
c01029e1:	6a 37                	push   $0x37
  jmp __alltraps
c01029e3:	e9 f4 fd ff ff       	jmp    c01027dc <__alltraps>

c01029e8 <vector56>:
.globl vector56
vector56:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $56
c01029ea:	6a 38                	push   $0x38
  jmp __alltraps
c01029ec:	e9 eb fd ff ff       	jmp    c01027dc <__alltraps>

c01029f1 <vector57>:
.globl vector57
vector57:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $57
c01029f3:	6a 39                	push   $0x39
  jmp __alltraps
c01029f5:	e9 e2 fd ff ff       	jmp    c01027dc <__alltraps>

c01029fa <vector58>:
.globl vector58
vector58:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $58
c01029fc:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029fe:	e9 d9 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a03 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $59
c0102a05:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a07:	e9 d0 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a0c <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $60
c0102a0e:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a10:	e9 c7 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a15 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $61
c0102a17:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a19:	e9 be fd ff ff       	jmp    c01027dc <__alltraps>

c0102a1e <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $62
c0102a20:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a22:	e9 b5 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a27 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $63
c0102a29:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a2b:	e9 ac fd ff ff       	jmp    c01027dc <__alltraps>

c0102a30 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $64
c0102a32:	6a 40                	push   $0x40
  jmp __alltraps
c0102a34:	e9 a3 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a39 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $65
c0102a3b:	6a 41                	push   $0x41
  jmp __alltraps
c0102a3d:	e9 9a fd ff ff       	jmp    c01027dc <__alltraps>

c0102a42 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $66
c0102a44:	6a 42                	push   $0x42
  jmp __alltraps
c0102a46:	e9 91 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a4b <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $67
c0102a4d:	6a 43                	push   $0x43
  jmp __alltraps
c0102a4f:	e9 88 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a54 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $68
c0102a56:	6a 44                	push   $0x44
  jmp __alltraps
c0102a58:	e9 7f fd ff ff       	jmp    c01027dc <__alltraps>

c0102a5d <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $69
c0102a5f:	6a 45                	push   $0x45
  jmp __alltraps
c0102a61:	e9 76 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a66 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $70
c0102a68:	6a 46                	push   $0x46
  jmp __alltraps
c0102a6a:	e9 6d fd ff ff       	jmp    c01027dc <__alltraps>

c0102a6f <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $71
c0102a71:	6a 47                	push   $0x47
  jmp __alltraps
c0102a73:	e9 64 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a78 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $72
c0102a7a:	6a 48                	push   $0x48
  jmp __alltraps
c0102a7c:	e9 5b fd ff ff       	jmp    c01027dc <__alltraps>

c0102a81 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $73
c0102a83:	6a 49                	push   $0x49
  jmp __alltraps
c0102a85:	e9 52 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a8a <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $74
c0102a8c:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a8e:	e9 49 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a93 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $75
c0102a95:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a97:	e9 40 fd ff ff       	jmp    c01027dc <__alltraps>

c0102a9c <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $76
c0102a9e:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102aa0:	e9 37 fd ff ff       	jmp    c01027dc <__alltraps>

c0102aa5 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $77
c0102aa7:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102aa9:	e9 2e fd ff ff       	jmp    c01027dc <__alltraps>

c0102aae <vector78>:
.globl vector78
vector78:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $78
c0102ab0:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102ab2:	e9 25 fd ff ff       	jmp    c01027dc <__alltraps>

c0102ab7 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $79
c0102ab9:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102abb:	e9 1c fd ff ff       	jmp    c01027dc <__alltraps>

c0102ac0 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $80
c0102ac2:	6a 50                	push   $0x50
  jmp __alltraps
c0102ac4:	e9 13 fd ff ff       	jmp    c01027dc <__alltraps>

c0102ac9 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $81
c0102acb:	6a 51                	push   $0x51
  jmp __alltraps
c0102acd:	e9 0a fd ff ff       	jmp    c01027dc <__alltraps>

c0102ad2 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $82
c0102ad4:	6a 52                	push   $0x52
  jmp __alltraps
c0102ad6:	e9 01 fd ff ff       	jmp    c01027dc <__alltraps>

c0102adb <vector83>:
.globl vector83
vector83:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $83
c0102add:	6a 53                	push   $0x53
  jmp __alltraps
c0102adf:	e9 f8 fc ff ff       	jmp    c01027dc <__alltraps>

c0102ae4 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $84
c0102ae6:	6a 54                	push   $0x54
  jmp __alltraps
c0102ae8:	e9 ef fc ff ff       	jmp    c01027dc <__alltraps>

c0102aed <vector85>:
.globl vector85
vector85:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $85
c0102aef:	6a 55                	push   $0x55
  jmp __alltraps
c0102af1:	e9 e6 fc ff ff       	jmp    c01027dc <__alltraps>

c0102af6 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $86
c0102af8:	6a 56                	push   $0x56
  jmp __alltraps
c0102afa:	e9 dd fc ff ff       	jmp    c01027dc <__alltraps>

c0102aff <vector87>:
.globl vector87
vector87:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $87
c0102b01:	6a 57                	push   $0x57
  jmp __alltraps
c0102b03:	e9 d4 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b08 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $88
c0102b0a:	6a 58                	push   $0x58
  jmp __alltraps
c0102b0c:	e9 cb fc ff ff       	jmp    c01027dc <__alltraps>

c0102b11 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $89
c0102b13:	6a 59                	push   $0x59
  jmp __alltraps
c0102b15:	e9 c2 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b1a <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $90
c0102b1c:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b1e:	e9 b9 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b23 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $91
c0102b25:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b27:	e9 b0 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b2c <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $92
c0102b2e:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b30:	e9 a7 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b35 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $93
c0102b37:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b39:	e9 9e fc ff ff       	jmp    c01027dc <__alltraps>

c0102b3e <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $94
c0102b40:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b42:	e9 95 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b47 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $95
c0102b49:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b4b:	e9 8c fc ff ff       	jmp    c01027dc <__alltraps>

c0102b50 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $96
c0102b52:	6a 60                	push   $0x60
  jmp __alltraps
c0102b54:	e9 83 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b59 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $97
c0102b5b:	6a 61                	push   $0x61
  jmp __alltraps
c0102b5d:	e9 7a fc ff ff       	jmp    c01027dc <__alltraps>

c0102b62 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $98
c0102b64:	6a 62                	push   $0x62
  jmp __alltraps
c0102b66:	e9 71 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b6b <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $99
c0102b6d:	6a 63                	push   $0x63
  jmp __alltraps
c0102b6f:	e9 68 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b74 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $100
c0102b76:	6a 64                	push   $0x64
  jmp __alltraps
c0102b78:	e9 5f fc ff ff       	jmp    c01027dc <__alltraps>

c0102b7d <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $101
c0102b7f:	6a 65                	push   $0x65
  jmp __alltraps
c0102b81:	e9 56 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b86 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $102
c0102b88:	6a 66                	push   $0x66
  jmp __alltraps
c0102b8a:	e9 4d fc ff ff       	jmp    c01027dc <__alltraps>

c0102b8f <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $103
c0102b91:	6a 67                	push   $0x67
  jmp __alltraps
c0102b93:	e9 44 fc ff ff       	jmp    c01027dc <__alltraps>

c0102b98 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $104
c0102b9a:	6a 68                	push   $0x68
  jmp __alltraps
c0102b9c:	e9 3b fc ff ff       	jmp    c01027dc <__alltraps>

c0102ba1 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $105
c0102ba3:	6a 69                	push   $0x69
  jmp __alltraps
c0102ba5:	e9 32 fc ff ff       	jmp    c01027dc <__alltraps>

c0102baa <vector106>:
.globl vector106
vector106:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $106
c0102bac:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102bae:	e9 29 fc ff ff       	jmp    c01027dc <__alltraps>

c0102bb3 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $107
c0102bb5:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102bb7:	e9 20 fc ff ff       	jmp    c01027dc <__alltraps>

c0102bbc <vector108>:
.globl vector108
vector108:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $108
c0102bbe:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bc0:	e9 17 fc ff ff       	jmp    c01027dc <__alltraps>

c0102bc5 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $109
c0102bc7:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102bc9:	e9 0e fc ff ff       	jmp    c01027dc <__alltraps>

c0102bce <vector110>:
.globl vector110
vector110:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $110
c0102bd0:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102bd2:	e9 05 fc ff ff       	jmp    c01027dc <__alltraps>

c0102bd7 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $111
c0102bd9:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bdb:	e9 fc fb ff ff       	jmp    c01027dc <__alltraps>

c0102be0 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $112
c0102be2:	6a 70                	push   $0x70
  jmp __alltraps
c0102be4:	e9 f3 fb ff ff       	jmp    c01027dc <__alltraps>

c0102be9 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102be9:	6a 00                	push   $0x0
  pushl $113
c0102beb:	6a 71                	push   $0x71
  jmp __alltraps
c0102bed:	e9 ea fb ff ff       	jmp    c01027dc <__alltraps>

c0102bf2 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $114
c0102bf4:	6a 72                	push   $0x72
  jmp __alltraps
c0102bf6:	e9 e1 fb ff ff       	jmp    c01027dc <__alltraps>

c0102bfb <vector115>:
.globl vector115
vector115:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $115
c0102bfd:	6a 73                	push   $0x73
  jmp __alltraps
c0102bff:	e9 d8 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c04 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $116
c0102c06:	6a 74                	push   $0x74
  jmp __alltraps
c0102c08:	e9 cf fb ff ff       	jmp    c01027dc <__alltraps>

c0102c0d <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c0d:	6a 00                	push   $0x0
  pushl $117
c0102c0f:	6a 75                	push   $0x75
  jmp __alltraps
c0102c11:	e9 c6 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c16 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c16:	6a 00                	push   $0x0
  pushl $118
c0102c18:	6a 76                	push   $0x76
  jmp __alltraps
c0102c1a:	e9 bd fb ff ff       	jmp    c01027dc <__alltraps>

c0102c1f <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c1f:	6a 00                	push   $0x0
  pushl $119
c0102c21:	6a 77                	push   $0x77
  jmp __alltraps
c0102c23:	e9 b4 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c28 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $120
c0102c2a:	6a 78                	push   $0x78
  jmp __alltraps
c0102c2c:	e9 ab fb ff ff       	jmp    c01027dc <__alltraps>

c0102c31 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c31:	6a 00                	push   $0x0
  pushl $121
c0102c33:	6a 79                	push   $0x79
  jmp __alltraps
c0102c35:	e9 a2 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c3a <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c3a:	6a 00                	push   $0x0
  pushl $122
c0102c3c:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c3e:	e9 99 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c43 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c43:	6a 00                	push   $0x0
  pushl $123
c0102c45:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c47:	e9 90 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c4c <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $124
c0102c4e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c50:	e9 87 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c55 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c55:	6a 00                	push   $0x0
  pushl $125
c0102c57:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c59:	e9 7e fb ff ff       	jmp    c01027dc <__alltraps>

c0102c5e <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c5e:	6a 00                	push   $0x0
  pushl $126
c0102c60:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c62:	e9 75 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c67 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $127
c0102c69:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c6b:	e9 6c fb ff ff       	jmp    c01027dc <__alltraps>

c0102c70 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $128
c0102c72:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c77:	e9 60 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c7c <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $129
c0102c7e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c83:	e9 54 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c88 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $130
c0102c8a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c8f:	e9 48 fb ff ff       	jmp    c01027dc <__alltraps>

c0102c94 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $131
c0102c96:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c9b:	e9 3c fb ff ff       	jmp    c01027dc <__alltraps>

c0102ca0 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $132
c0102ca2:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102ca7:	e9 30 fb ff ff       	jmp    c01027dc <__alltraps>

c0102cac <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $133
c0102cae:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102cb3:	e9 24 fb ff ff       	jmp    c01027dc <__alltraps>

c0102cb8 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $134
c0102cba:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cbf:	e9 18 fb ff ff       	jmp    c01027dc <__alltraps>

c0102cc4 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $135
c0102cc6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102ccb:	e9 0c fb ff ff       	jmp    c01027dc <__alltraps>

c0102cd0 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $136
c0102cd2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102cd7:	e9 00 fb ff ff       	jmp    c01027dc <__alltraps>

c0102cdc <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $137
c0102cde:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102ce3:	e9 f4 fa ff ff       	jmp    c01027dc <__alltraps>

c0102ce8 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $138
c0102cea:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102cef:	e9 e8 fa ff ff       	jmp    c01027dc <__alltraps>

c0102cf4 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $139
c0102cf6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102cfb:	e9 dc fa ff ff       	jmp    c01027dc <__alltraps>

c0102d00 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $140
c0102d02:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d07:	e9 d0 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d0c <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $141
c0102d0e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d13:	e9 c4 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d18 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $142
c0102d1a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d1f:	e9 b8 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d24 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $143
c0102d26:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d2b:	e9 ac fa ff ff       	jmp    c01027dc <__alltraps>

c0102d30 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $144
c0102d32:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d37:	e9 a0 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d3c <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $145
c0102d3e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d43:	e9 94 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d48 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $146
c0102d4a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d4f:	e9 88 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d54 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $147
c0102d56:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d5b:	e9 7c fa ff ff       	jmp    c01027dc <__alltraps>

c0102d60 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $148
c0102d62:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d67:	e9 70 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d6c <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $149
c0102d6e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d73:	e9 64 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d78 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $150
c0102d7a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d7f:	e9 58 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d84 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $151
c0102d86:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d8b:	e9 4c fa ff ff       	jmp    c01027dc <__alltraps>

c0102d90 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $152
c0102d92:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d97:	e9 40 fa ff ff       	jmp    c01027dc <__alltraps>

c0102d9c <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $153
c0102d9e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102da3:	e9 34 fa ff ff       	jmp    c01027dc <__alltraps>

c0102da8 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $154
c0102daa:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102daf:	e9 28 fa ff ff       	jmp    c01027dc <__alltraps>

c0102db4 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $155
c0102db6:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102dbb:	e9 1c fa ff ff       	jmp    c01027dc <__alltraps>

c0102dc0 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $156
c0102dc2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102dc7:	e9 10 fa ff ff       	jmp    c01027dc <__alltraps>

c0102dcc <vector157>:
.globl vector157
vector157:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $157
c0102dce:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102dd3:	e9 04 fa ff ff       	jmp    c01027dc <__alltraps>

c0102dd8 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $158
c0102dda:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102ddf:	e9 f8 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102de4 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $159
c0102de6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102deb:	e9 ec f9 ff ff       	jmp    c01027dc <__alltraps>

c0102df0 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $160
c0102df2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102df7:	e9 e0 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102dfc <vector161>:
.globl vector161
vector161:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $161
c0102dfe:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e03:	e9 d4 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e08 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $162
c0102e0a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e0f:	e9 c8 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e14 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $163
c0102e16:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e1b:	e9 bc f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e20 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $164
c0102e22:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e27:	e9 b0 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e2c <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $165
c0102e2e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e33:	e9 a4 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e38 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $166
c0102e3a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e3f:	e9 98 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e44 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $167
c0102e46:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e4b:	e9 8c f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e50 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $168
c0102e52:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e57:	e9 80 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e5c <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $169
c0102e5e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e63:	e9 74 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e68 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $170
c0102e6a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e6f:	e9 68 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e74 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $171
c0102e76:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e7b:	e9 5c f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e80 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $172
c0102e82:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e87:	e9 50 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e8c <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $173
c0102e8e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e93:	e9 44 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102e98 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $174
c0102e9a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e9f:	e9 38 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102ea4 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $175
c0102ea6:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102eab:	e9 2c f9 ff ff       	jmp    c01027dc <__alltraps>

c0102eb0 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $176
c0102eb2:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102eb7:	e9 20 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102ebc <vector177>:
.globl vector177
vector177:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $177
c0102ebe:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102ec3:	e9 14 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102ec8 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $178
c0102eca:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102ecf:	e9 08 f9 ff ff       	jmp    c01027dc <__alltraps>

c0102ed4 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $179
c0102ed6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102edb:	e9 fc f8 ff ff       	jmp    c01027dc <__alltraps>

c0102ee0 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $180
c0102ee2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102ee7:	e9 f0 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102eec <vector181>:
.globl vector181
vector181:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $181
c0102eee:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ef3:	e9 e4 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102ef8 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $182
c0102efa:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102eff:	e9 d8 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f04 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $183
c0102f06:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f0b:	e9 cc f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f10 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $184
c0102f12:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f17:	e9 c0 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f1c <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $185
c0102f1e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f23:	e9 b4 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f28 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $186
c0102f2a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f2f:	e9 a8 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f34 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $187
c0102f36:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f3b:	e9 9c f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f40 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $188
c0102f42:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f47:	e9 90 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f4c <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $189
c0102f4e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f53:	e9 84 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f58 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $190
c0102f5a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f5f:	e9 78 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f64 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $191
c0102f66:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f6b:	e9 6c f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f70 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $192
c0102f72:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f77:	e9 60 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f7c <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $193
c0102f7e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f83:	e9 54 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f88 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $194
c0102f8a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f8f:	e9 48 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102f94 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $195
c0102f96:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f9b:	e9 3c f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fa0 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $196
c0102fa2:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fa7:	e9 30 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fac <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $197
c0102fae:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fb3:	e9 24 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fb8 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $198
c0102fba:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102fbf:	e9 18 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fc4 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $199
c0102fc6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102fcb:	e9 0c f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fd0 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $200
c0102fd2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102fd7:	e9 00 f8 ff ff       	jmp    c01027dc <__alltraps>

c0102fdc <vector201>:
.globl vector201
vector201:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $201
c0102fde:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102fe3:	e9 f4 f7 ff ff       	jmp    c01027dc <__alltraps>

c0102fe8 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $202
c0102fea:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fef:	e9 e8 f7 ff ff       	jmp    c01027dc <__alltraps>

c0102ff4 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $203
c0102ff6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102ffb:	e9 dc f7 ff ff       	jmp    c01027dc <__alltraps>

c0103000 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $204
c0103002:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103007:	e9 d0 f7 ff ff       	jmp    c01027dc <__alltraps>

c010300c <vector205>:
.globl vector205
vector205:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $205
c010300e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103013:	e9 c4 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103018 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $206
c010301a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010301f:	e9 b8 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103024 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $207
c0103026:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010302b:	e9 ac f7 ff ff       	jmp    c01027dc <__alltraps>

c0103030 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $208
c0103032:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103037:	e9 a0 f7 ff ff       	jmp    c01027dc <__alltraps>

c010303c <vector209>:
.globl vector209
vector209:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $209
c010303e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103043:	e9 94 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103048 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $210
c010304a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010304f:	e9 88 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103054 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $211
c0103056:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010305b:	e9 7c f7 ff ff       	jmp    c01027dc <__alltraps>

c0103060 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $212
c0103062:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103067:	e9 70 f7 ff ff       	jmp    c01027dc <__alltraps>

c010306c <vector213>:
.globl vector213
vector213:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $213
c010306e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103073:	e9 64 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103078 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $214
c010307a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010307f:	e9 58 f7 ff ff       	jmp    c01027dc <__alltraps>

c0103084 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $215
c0103086:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010308b:	e9 4c f7 ff ff       	jmp    c01027dc <__alltraps>

c0103090 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $216
c0103092:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103097:	e9 40 f7 ff ff       	jmp    c01027dc <__alltraps>

c010309c <vector217>:
.globl vector217
vector217:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $217
c010309e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030a3:	e9 34 f7 ff ff       	jmp    c01027dc <__alltraps>

c01030a8 <vector218>:
.globl vector218
vector218:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $218
c01030aa:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030af:	e9 28 f7 ff ff       	jmp    c01027dc <__alltraps>

c01030b4 <vector219>:
.globl vector219
vector219:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $219
c01030b6:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030bb:	e9 1c f7 ff ff       	jmp    c01027dc <__alltraps>

c01030c0 <vector220>:
.globl vector220
vector220:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $220
c01030c2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030c7:	e9 10 f7 ff ff       	jmp    c01027dc <__alltraps>

c01030cc <vector221>:
.globl vector221
vector221:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $221
c01030ce:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030d3:	e9 04 f7 ff ff       	jmp    c01027dc <__alltraps>

c01030d8 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $222
c01030da:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030df:	e9 f8 f6 ff ff       	jmp    c01027dc <__alltraps>

c01030e4 <vector223>:
.globl vector223
vector223:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $223
c01030e6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030eb:	e9 ec f6 ff ff       	jmp    c01027dc <__alltraps>

c01030f0 <vector224>:
.globl vector224
vector224:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $224
c01030f2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030f7:	e9 e0 f6 ff ff       	jmp    c01027dc <__alltraps>

c01030fc <vector225>:
.globl vector225
vector225:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $225
c01030fe:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103103:	e9 d4 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103108 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $226
c010310a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010310f:	e9 c8 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103114 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $227
c0103116:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010311b:	e9 bc f6 ff ff       	jmp    c01027dc <__alltraps>

c0103120 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $228
c0103122:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103127:	e9 b0 f6 ff ff       	jmp    c01027dc <__alltraps>

c010312c <vector229>:
.globl vector229
vector229:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $229
c010312e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103133:	e9 a4 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103138 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $230
c010313a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010313f:	e9 98 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103144 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $231
c0103146:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010314b:	e9 8c f6 ff ff       	jmp    c01027dc <__alltraps>

c0103150 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $232
c0103152:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103157:	e9 80 f6 ff ff       	jmp    c01027dc <__alltraps>

c010315c <vector233>:
.globl vector233
vector233:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $233
c010315e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103163:	e9 74 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103168 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $234
c010316a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010316f:	e9 68 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103174 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $235
c0103176:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010317b:	e9 5c f6 ff ff       	jmp    c01027dc <__alltraps>

c0103180 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $236
c0103182:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103187:	e9 50 f6 ff ff       	jmp    c01027dc <__alltraps>

c010318c <vector237>:
.globl vector237
vector237:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $237
c010318e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103193:	e9 44 f6 ff ff       	jmp    c01027dc <__alltraps>

c0103198 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $238
c010319a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010319f:	e9 38 f6 ff ff       	jmp    c01027dc <__alltraps>

c01031a4 <vector239>:
.globl vector239
vector239:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $239
c01031a6:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031ab:	e9 2c f6 ff ff       	jmp    c01027dc <__alltraps>

c01031b0 <vector240>:
.globl vector240
vector240:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $240
c01031b2:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031b7:	e9 20 f6 ff ff       	jmp    c01027dc <__alltraps>

c01031bc <vector241>:
.globl vector241
vector241:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $241
c01031be:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031c3:	e9 14 f6 ff ff       	jmp    c01027dc <__alltraps>

c01031c8 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $242
c01031ca:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031cf:	e9 08 f6 ff ff       	jmp    c01027dc <__alltraps>

c01031d4 <vector243>:
.globl vector243
vector243:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $243
c01031d6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031db:	e9 fc f5 ff ff       	jmp    c01027dc <__alltraps>

c01031e0 <vector244>:
.globl vector244
vector244:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $244
c01031e2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031e7:	e9 f0 f5 ff ff       	jmp    c01027dc <__alltraps>

c01031ec <vector245>:
.globl vector245
vector245:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $245
c01031ee:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031f3:	e9 e4 f5 ff ff       	jmp    c01027dc <__alltraps>

c01031f8 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $246
c01031fa:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031ff:	e9 d8 f5 ff ff       	jmp    c01027dc <__alltraps>

c0103204 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103204:	6a 00                	push   $0x0
  pushl $247
c0103206:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010320b:	e9 cc f5 ff ff       	jmp    c01027dc <__alltraps>

c0103210 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103210:	6a 00                	push   $0x0
  pushl $248
c0103212:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103217:	e9 c0 f5 ff ff       	jmp    c01027dc <__alltraps>

c010321c <vector249>:
.globl vector249
vector249:
  pushl $0
c010321c:	6a 00                	push   $0x0
  pushl $249
c010321e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103223:	e9 b4 f5 ff ff       	jmp    c01027dc <__alltraps>

c0103228 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103228:	6a 00                	push   $0x0
  pushl $250
c010322a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010322f:	e9 a8 f5 ff ff       	jmp    c01027dc <__alltraps>

c0103234 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103234:	6a 00                	push   $0x0
  pushl $251
c0103236:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010323b:	e9 9c f5 ff ff       	jmp    c01027dc <__alltraps>

c0103240 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103240:	6a 00                	push   $0x0
  pushl $252
c0103242:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103247:	e9 90 f5 ff ff       	jmp    c01027dc <__alltraps>

c010324c <vector253>:
.globl vector253
vector253:
  pushl $0
c010324c:	6a 00                	push   $0x0
  pushl $253
c010324e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103253:	e9 84 f5 ff ff       	jmp    c01027dc <__alltraps>

c0103258 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103258:	6a 00                	push   $0x0
  pushl $254
c010325a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010325f:	e9 78 f5 ff ff       	jmp    c01027dc <__alltraps>

c0103264 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103264:	6a 00                	push   $0x0
  pushl $255
c0103266:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010326b:	e9 6c f5 ff ff       	jmp    c01027dc <__alltraps>

c0103270 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103270:	55                   	push   %ebp
c0103271:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103273:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c0103279:	8b 45 08             	mov    0x8(%ebp),%eax
c010327c:	29 d0                	sub    %edx,%eax
c010327e:	c1 f8 05             	sar    $0x5,%eax
}
c0103281:	5d                   	pop    %ebp
c0103282:	c3                   	ret    

c0103283 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103283:	55                   	push   %ebp
c0103284:	89 e5                	mov    %esp,%ebp
c0103286:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103289:	8b 45 08             	mov    0x8(%ebp),%eax
c010328c:	89 04 24             	mov    %eax,(%esp)
c010328f:	e8 dc ff ff ff       	call   c0103270 <page2ppn>
c0103294:	c1 e0 0c             	shl    $0xc,%eax
}
c0103297:	89 ec                	mov    %ebp,%esp
c0103299:	5d                   	pop    %ebp
c010329a:	c3                   	ret    

c010329b <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010329b:	55                   	push   %ebp
c010329c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010329e:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a1:	8b 00                	mov    (%eax),%eax
}
c01032a3:	5d                   	pop    %ebp
c01032a4:	c3                   	ret    

c01032a5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01032a5:	55                   	push   %ebp
c01032a6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01032a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01032ab:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032ae:	89 10                	mov    %edx,(%eax)
}
c01032b0:	90                   	nop
c01032b1:	5d                   	pop    %ebp
c01032b2:	c3                   	ret    

c01032b3 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void)
{
c01032b3:	55                   	push   %ebp
c01032b4:	89 e5                	mov    %esp,%ebp
c01032b6:	83 ec 10             	sub    $0x10,%esp
c01032b9:	c7 45 fc 84 7f 12 c0 	movl   $0xc0127f84,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032c6:	89 50 04             	mov    %edx,0x4(%eax)
c01032c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032cc:	8b 50 04             	mov    0x4(%eax),%edx
c01032cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032d2:	89 10                	mov    %edx,(%eax)
}
c01032d4:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01032d5:	c7 05 8c 7f 12 c0 00 	movl   $0x0,0xc0127f8c
c01032dc:	00 00 00 
}
c01032df:	90                   	nop
c01032e0:	89 ec                	mov    %ebp,%esp
c01032e2:	5d                   	pop    %ebp
c01032e3:	c3                   	ret    

c01032e4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n)
{
c01032e4:	55                   	push   %ebp
c01032e5:	89 e5                	mov    %esp,%ebp
c01032e7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01032ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01032ee:	75 24                	jne    c0103314 <default_init_memmap+0x30>
c01032f0:	c7 44 24 0c d0 a0 10 	movl   $0xc010a0d0,0xc(%esp)
c01032f7:	c0 
c01032f8:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01032ff:	c0 
c0103300:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0103307:	00 
c0103308:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010330f:	e8 d6 d9 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c0103314:	8b 45 08             	mov    0x8(%ebp),%eax
c0103317:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c010331a:	eb 7d                	jmp    c0103399 <default_init_memmap+0xb5>
    {
        assert(PageReserved(p));
c010331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331f:	83 c0 04             	add    $0x4,%eax
c0103322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103329:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010332f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103332:	0f a3 10             	bt     %edx,(%eax)
c0103335:	19 c0                	sbb    %eax,%eax
c0103337:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010333a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010333e:	0f 95 c0             	setne  %al
c0103341:	0f b6 c0             	movzbl %al,%eax
c0103344:	85 c0                	test   %eax,%eax
c0103346:	75 24                	jne    c010336c <default_init_memmap+0x88>
c0103348:	c7 44 24 0c 01 a1 10 	movl   $0xc010a101,0xc(%esp)
c010334f:	c0 
c0103350:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103357:	c0 
c0103358:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c010335f:	00 
c0103360:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103367:	e8 7e d9 ff ff       	call   c0100cea <__panic>
        p->flags = p->property = 0;
c010336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103376:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103379:	8b 50 08             	mov    0x8(%eax),%edx
c010337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0103382:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103389:	00 
c010338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338d:	89 04 24             	mov    %eax,(%esp)
c0103390:	e8 10 ff ff ff       	call   c01032a5 <set_page_ref>
    for (; p != base + n; p++)
c0103395:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103399:	8b 45 0c             	mov    0xc(%ebp),%eax
c010339c:	c1 e0 05             	shl    $0x5,%eax
c010339f:	89 c2                	mov    %eax,%edx
c01033a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a4:	01 d0                	add    %edx,%eax
c01033a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01033a9:	0f 85 6d ff ff ff    	jne    c010331c <default_init_memmap+0x38>
    }
    base->property = n;
c01033af:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033b5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01033b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01033bb:	83 c0 04             	add    $0x4,%eax
c01033be:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01033c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033ce:	0f ab 10             	bts    %edx,(%eax)
}
c01033d1:	90                   	nop
    nr_free += n;
c01033d2:	8b 15 8c 7f 12 c0    	mov    0xc0127f8c,%edx
c01033d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033db:	01 d0                	add    %edx,%eax
c01033dd:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c
    list_add_before(&free_list, &(base->page_link));
c01033e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01033e5:	83 c0 0c             	add    $0xc,%eax
c01033e8:	c7 45 e4 84 7f 12 c0 	movl   $0xc0127f84,-0x1c(%ebp)
c01033ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01033f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033f5:	8b 00                	mov    (%eax),%eax
c01033f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01033fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103403:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103406:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103409:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010340c:	89 10                	mov    %edx,(%eax)
c010340e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103411:	8b 10                	mov    (%eax),%edx
c0103413:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103416:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103419:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010341c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010341f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103422:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103425:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103428:	89 10                	mov    %edx,(%eax)
}
c010342a:	90                   	nop
}
c010342b:	90                   	nop
}
c010342c:	90                   	nop
c010342d:	89 ec                	mov    %ebp,%esp
c010342f:	5d                   	pop    %ebp
c0103430:	c3                   	ret    

c0103431 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0103431:	55                   	push   %ebp
c0103432:	89 e5                	mov    %esp,%ebp
c0103434:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103437:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010343b:	75 24                	jne    c0103461 <default_alloc_pages+0x30>
c010343d:	c7 44 24 0c d0 a0 10 	movl   $0xc010a0d0,0xc(%esp)
c0103444:	c0 
c0103445:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010344c:	c0 
c010344d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0103454:	00 
c0103455:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010345c:	e8 89 d8 ff ff       	call   c0100cea <__panic>
    if (n > nr_free)
c0103461:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0103466:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103469:	76 0a                	jbe    c0103475 <default_alloc_pages+0x44>
    {
        return NULL;
c010346b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103470:	e9 3c 01 00 00       	jmp    c01035b1 <default_alloc_pages+0x180>
    }
    struct Page *page = NULL;
c0103475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010347c:	c7 45 f0 84 7f 12 c0 	movl   $0xc0127f84,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list)
c0103483:	eb 1c                	jmp    c01034a1 <default_alloc_pages+0x70>
    {
        struct Page *p = le2page(le, page_link);
c0103485:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103488:	83 e8 0c             	sub    $0xc,%eax
c010348b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c010348e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103491:	8b 40 08             	mov    0x8(%eax),%eax
c0103494:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103497:	77 08                	ja     c01034a1 <default_alloc_pages+0x70>
        {
            page = p;
c0103499:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010349c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010349f:	eb 18                	jmp    c01034b9 <default_alloc_pages+0x88>
c01034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01034a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034aa:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01034ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034b0:	81 7d f0 84 7f 12 c0 	cmpl   $0xc0127f84,-0x10(%ebp)
c01034b7:	75 cc                	jne    c0103485 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL)
c01034b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034bd:	0f 84 eb 00 00 00    	je     c01035ae <default_alloc_pages+0x17d>
    {
        if (page->property > n)
c01034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c6:	8b 40 08             	mov    0x8(%eax),%eax
c01034c9:	39 45 08             	cmp    %eax,0x8(%ebp)
c01034cc:	0f 83 88 00 00 00    	jae    c010355a <default_alloc_pages+0x129>
        {
            struct Page *p = page + n;
c01034d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01034d5:	c1 e0 05             	shl    $0x5,%eax
c01034d8:	89 c2                	mov    %eax,%edx
c01034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034dd:	01 d0                	add    %edx,%eax
c01034df:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e5:	8b 40 08             	mov    0x8(%eax),%eax
c01034e8:	2b 45 08             	sub    0x8(%ebp),%eax
c01034eb:	89 c2                	mov    %eax,%edx
c01034ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f0:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f6:	83 c0 04             	add    $0x4,%eax
c01034f9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103500:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103503:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103506:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103509:	0f ab 10             	bts    %edx,(%eax)
}
c010350c:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c010350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103510:	83 c0 0c             	add    $0xc,%eax
c0103513:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103516:	83 c2 0c             	add    $0xc,%edx
c0103519:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010351c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c010351f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103522:	8b 40 04             	mov    0x4(%eax),%eax
c0103525:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103528:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010352b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010352e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103531:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0103534:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103537:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010353a:	89 10                	mov    %edx,(%eax)
c010353c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010353f:	8b 10                	mov    (%eax),%edx
c0103541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103544:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103547:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010354a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010354d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103550:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103553:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103556:	89 10                	mov    %edx,(%eax)
}
c0103558:	90                   	nop
}
c0103559:	90                   	nop
        }
        list_del(&(page->page_link));
c010355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010355d:	83 c0 0c             	add    $0xc,%eax
c0103560:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103563:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103566:	8b 40 04             	mov    0x4(%eax),%eax
c0103569:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010356c:	8b 12                	mov    (%edx),%edx
c010356e:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0103571:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103574:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103577:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010357a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010357d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103580:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103583:	89 10                	mov    %edx,(%eax)
}
c0103585:	90                   	nop
}
c0103586:	90                   	nop
        nr_free -= n;
c0103587:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c010358c:	2b 45 08             	sub    0x8(%ebp),%eax
c010358f:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c
        ClearPageProperty(page);
c0103594:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103597:	83 c0 04             	add    $0x4,%eax
c010359a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01035a1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01035a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035aa:	0f b3 10             	btr    %edx,(%eax)
}
c01035ad:	90                   	nop
    }
    return page;
c01035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01035b1:	89 ec                	mov    %ebp,%esp
c01035b3:	5d                   	pop    %ebp
c01035b4:	c3                   	ret    

c01035b5 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c01035b5:	55                   	push   %ebp
c01035b6:	89 e5                	mov    %esp,%ebp
c01035b8:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c01035be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01035c2:	75 24                	jne    c01035e8 <default_free_pages+0x33>
c01035c4:	c7 44 24 0c d0 a0 10 	movl   $0xc010a0d0,0xc(%esp)
c01035cb:	c0 
c01035cc:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01035d3:	c0 
c01035d4:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01035db:	00 
c01035dc:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01035e3:	e8 02 d7 ff ff       	call   c0100cea <__panic>
    struct Page *p = base;
c01035e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01035eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c01035ee:	e9 9d 00 00 00       	jmp    c0103690 <default_free_pages+0xdb>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c01035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f6:	83 c0 04             	add    $0x4,%eax
c01035f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103600:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103603:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103606:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103609:	0f a3 10             	bt     %edx,(%eax)
c010360c:	19 c0                	sbb    %eax,%eax
c010360e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103611:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103615:	0f 95 c0             	setne  %al
c0103618:	0f b6 c0             	movzbl %al,%eax
c010361b:	85 c0                	test   %eax,%eax
c010361d:	75 2c                	jne    c010364b <default_free_pages+0x96>
c010361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103622:	83 c0 04             	add    $0x4,%eax
c0103625:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010362c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010362f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103632:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103635:	0f a3 10             	bt     %edx,(%eax)
c0103638:	19 c0                	sbb    %eax,%eax
c010363a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010363d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103641:	0f 95 c0             	setne  %al
c0103644:	0f b6 c0             	movzbl %al,%eax
c0103647:	85 c0                	test   %eax,%eax
c0103649:	74 24                	je     c010366f <default_free_pages+0xba>
c010364b:	c7 44 24 0c 14 a1 10 	movl   $0xc010a114,0xc(%esp)
c0103652:	c0 
c0103653:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010365a:	c0 
c010365b:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103662:	00 
c0103663:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010366a:	e8 7b d6 ff ff       	call   c0100cea <__panic>
        p->flags = 0;
c010366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103672:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0103679:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103680:	00 
c0103681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103684:	89 04 24             	mov    %eax,(%esp)
c0103687:	e8 19 fc ff ff       	call   c01032a5 <set_page_ref>
    for (; p != base + n; p++)
c010368c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103690:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103693:	c1 e0 05             	shl    $0x5,%eax
c0103696:	89 c2                	mov    %eax,%edx
c0103698:	8b 45 08             	mov    0x8(%ebp),%eax
c010369b:	01 d0                	add    %edx,%eax
c010369d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01036a0:	0f 85 4d ff ff ff    	jne    c01035f3 <default_free_pages+0x3e>
    }
    base->property = n;
c01036a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036ac:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01036af:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b2:	83 c0 04             	add    $0x4,%eax
c01036b5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01036bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036c2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01036c5:	0f ab 10             	bts    %edx,(%eax)
}
c01036c8:	90                   	nop
c01036c9:	c7 45 d4 84 7f 12 c0 	movl   $0xc0127f84,-0x2c(%ebp)
    return listelm->next;
c01036d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01036d3:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01036d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
c01036d9:	e9 00 01 00 00       	jmp    c01037de <default_free_pages+0x229>
    {
        p = le2page(le, page_link);
c01036de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e1:	83 e8 0c             	sub    $0xc,%eax
c01036e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01036ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036f0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01036f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p)
c01036f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f9:	8b 40 08             	mov    0x8(%eax),%eax
c01036fc:	c1 e0 05             	shl    $0x5,%eax
c01036ff:	89 c2                	mov    %eax,%edx
c0103701:	8b 45 08             	mov    0x8(%ebp),%eax
c0103704:	01 d0                	add    %edx,%eax
c0103706:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103709:	75 5d                	jne    c0103768 <default_free_pages+0x1b3>
        {
            base->property += p->property;
c010370b:	8b 45 08             	mov    0x8(%ebp),%eax
c010370e:	8b 50 08             	mov    0x8(%eax),%edx
c0103711:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103714:	8b 40 08             	mov    0x8(%eax),%eax
c0103717:	01 c2                	add    %eax,%edx
c0103719:	8b 45 08             	mov    0x8(%ebp),%eax
c010371c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010371f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103722:	83 c0 04             	add    $0x4,%eax
c0103725:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010372c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010372f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103732:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103735:	0f b3 10             	btr    %edx,(%eax)
}
c0103738:	90                   	nop
            list_del(&(p->page_link));
c0103739:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373c:	83 c0 0c             	add    $0xc,%eax
c010373f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103742:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103745:	8b 40 04             	mov    0x4(%eax),%eax
c0103748:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010374b:	8b 12                	mov    (%edx),%edx
c010374d:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103750:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0103753:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103756:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103759:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010375c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010375f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103762:	89 10                	mov    %edx,(%eax)
}
c0103764:	90                   	nop
}
c0103765:	90                   	nop
c0103766:	eb 76                	jmp    c01037de <default_free_pages+0x229>
        }
        else if (p + p->property == base)
c0103768:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376b:	8b 40 08             	mov    0x8(%eax),%eax
c010376e:	c1 e0 05             	shl    $0x5,%eax
c0103771:	89 c2                	mov    %eax,%edx
c0103773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103776:	01 d0                	add    %edx,%eax
c0103778:	39 45 08             	cmp    %eax,0x8(%ebp)
c010377b:	75 61                	jne    c01037de <default_free_pages+0x229>
        {
            p->property += base->property;
c010377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103780:	8b 50 08             	mov    0x8(%eax),%edx
c0103783:	8b 45 08             	mov    0x8(%ebp),%eax
c0103786:	8b 40 08             	mov    0x8(%eax),%eax
c0103789:	01 c2                	add    %eax,%edx
c010378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010378e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103791:	8b 45 08             	mov    0x8(%ebp),%eax
c0103794:	83 c0 04             	add    $0x4,%eax
c0103797:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c010379e:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01037a4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01037a7:	0f b3 10             	btr    %edx,(%eax)
}
c01037aa:	90                   	nop
            base = p;
c01037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ae:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037b4:	83 c0 0c             	add    $0xc,%eax
c01037b7:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01037ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01037bd:	8b 40 04             	mov    0x4(%eax),%eax
c01037c0:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01037c3:	8b 12                	mov    (%edx),%edx
c01037c5:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01037c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c01037cb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01037ce:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01037d1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037d4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037d7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037da:	89 10                	mov    %edx,(%eax)
}
c01037dc:	90                   	nop
}
c01037dd:	90                   	nop
    while (le != &free_list)
c01037de:	81 7d f0 84 7f 12 c0 	cmpl   $0xc0127f84,-0x10(%ebp)
c01037e5:	0f 85 f3 fe ff ff    	jne    c01036de <default_free_pages+0x129>
        }
    }
    nr_free += n;
c01037eb:	8b 15 8c 7f 12 c0    	mov    0xc0127f8c,%edx
c01037f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037f4:	01 d0                	add    %edx,%eax
c01037f6:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c
c01037fb:	c7 45 9c 84 7f 12 c0 	movl   $0xc0127f84,-0x64(%ebp)
    return listelm->next;
c0103802:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103805:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0103808:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
c010380b:	eb 66                	jmp    c0103873 <default_free_pages+0x2be>
    {
        p = le2page(le, page_link);
c010380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103810:	83 e8 0c             	sub    $0xc,%eax
c0103813:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p)
c0103816:	8b 45 08             	mov    0x8(%ebp),%eax
c0103819:	8b 40 08             	mov    0x8(%eax),%eax
c010381c:	c1 e0 05             	shl    $0x5,%eax
c010381f:	89 c2                	mov    %eax,%edx
c0103821:	8b 45 08             	mov    0x8(%ebp),%eax
c0103824:	01 d0                	add    %edx,%eax
c0103826:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103829:	72 39                	jb     c0103864 <default_free_pages+0x2af>
        {
            assert(base + base->property != p);
c010382b:	8b 45 08             	mov    0x8(%ebp),%eax
c010382e:	8b 40 08             	mov    0x8(%eax),%eax
c0103831:	c1 e0 05             	shl    $0x5,%eax
c0103834:	89 c2                	mov    %eax,%edx
c0103836:	8b 45 08             	mov    0x8(%ebp),%eax
c0103839:	01 d0                	add    %edx,%eax
c010383b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010383e:	75 3e                	jne    c010387e <default_free_pages+0x2c9>
c0103840:	c7 44 24 0c 39 a1 10 	movl   $0xc010a139,0xc(%esp)
c0103847:	c0 
c0103848:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010384f:	c0 
c0103850:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103857:	00 
c0103858:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010385f:	e8 86 d4 ff ff       	call   c0100cea <__panic>
c0103864:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103867:	89 45 98             	mov    %eax,-0x68(%ebp)
c010386a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010386d:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0103870:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
c0103873:	81 7d f0 84 7f 12 c0 	cmpl   $0xc0127f84,-0x10(%ebp)
c010387a:	75 91                	jne    c010380d <default_free_pages+0x258>
c010387c:	eb 01                	jmp    c010387f <default_free_pages+0x2ca>
            break;
c010387e:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c010387f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103882:	8d 50 0c             	lea    0xc(%eax),%edx
c0103885:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103888:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010388b:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010388e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103891:	8b 00                	mov    (%eax),%eax
c0103893:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103896:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0103899:	89 45 88             	mov    %eax,-0x78(%ebp)
c010389c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010389f:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c01038a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01038a5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01038a8:	89 10                	mov    %edx,(%eax)
c01038aa:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01038ad:	8b 10                	mov    (%eax),%edx
c01038af:	8b 45 88             	mov    -0x78(%ebp),%eax
c01038b2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01038b5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01038b8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038bb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01038be:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01038c1:	8b 55 88             	mov    -0x78(%ebp),%edx
c01038c4:	89 10                	mov    %edx,(%eax)
}
c01038c6:	90                   	nop
}
c01038c7:	90                   	nop
}
c01038c8:	90                   	nop
c01038c9:	89 ec                	mov    %ebp,%esp
c01038cb:	5d                   	pop    %ebp
c01038cc:	c3                   	ret    

c01038cd <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c01038cd:	55                   	push   %ebp
c01038ce:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01038d0:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
}
c01038d5:	5d                   	pop    %ebp
c01038d6:	c3                   	ret    

c01038d7 <basic_check>:

static void
basic_check(void)
{
c01038d7:	55                   	push   %ebp
c01038d8:	89 e5                	mov    %esp,%ebp
c01038da:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01038dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01038f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038f7:	e8 ec 0e 00 00       	call   c01047e8 <alloc_pages>
c01038fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103903:	75 24                	jne    c0103929 <basic_check+0x52>
c0103905:	c7 44 24 0c 54 a1 10 	movl   $0xc010a154,0xc(%esp)
c010390c:	c0 
c010390d:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103914:	c0 
c0103915:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010391c:	00 
c010391d:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103924:	e8 c1 d3 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103929:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103930:	e8 b3 0e 00 00       	call   c01047e8 <alloc_pages>
c0103935:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103938:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010393c:	75 24                	jne    c0103962 <basic_check+0x8b>
c010393e:	c7 44 24 0c 70 a1 10 	movl   $0xc010a170,0xc(%esp)
c0103945:	c0 
c0103946:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010394d:	c0 
c010394e:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103955:	00 
c0103956:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010395d:	e8 88 d3 ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103962:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103969:	e8 7a 0e 00 00       	call   c01047e8 <alloc_pages>
c010396e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103975:	75 24                	jne    c010399b <basic_check+0xc4>
c0103977:	c7 44 24 0c 8c a1 10 	movl   $0xc010a18c,0xc(%esp)
c010397e:	c0 
c010397f:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103986:	c0 
c0103987:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010398e:	00 
c010398f:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103996:	e8 4f d3 ff ff       	call   c0100cea <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010399b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010399e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01039a1:	74 10                	je     c01039b3 <basic_check+0xdc>
c01039a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01039a9:	74 08                	je     c01039b3 <basic_check+0xdc>
c01039ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01039b1:	75 24                	jne    c01039d7 <basic_check+0x100>
c01039b3:	c7 44 24 0c a8 a1 10 	movl   $0xc010a1a8,0xc(%esp)
c01039ba:	c0 
c01039bb:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01039c2:	c0 
c01039c3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01039ca:	00 
c01039cb:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01039d2:	e8 13 d3 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01039d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039da:	89 04 24             	mov    %eax,(%esp)
c01039dd:	e8 b9 f8 ff ff       	call   c010329b <page_ref>
c01039e2:	85 c0                	test   %eax,%eax
c01039e4:	75 1e                	jne    c0103a04 <basic_check+0x12d>
c01039e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039e9:	89 04 24             	mov    %eax,(%esp)
c01039ec:	e8 aa f8 ff ff       	call   c010329b <page_ref>
c01039f1:	85 c0                	test   %eax,%eax
c01039f3:	75 0f                	jne    c0103a04 <basic_check+0x12d>
c01039f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f8:	89 04 24             	mov    %eax,(%esp)
c01039fb:	e8 9b f8 ff ff       	call   c010329b <page_ref>
c0103a00:	85 c0                	test   %eax,%eax
c0103a02:	74 24                	je     c0103a28 <basic_check+0x151>
c0103a04:	c7 44 24 0c cc a1 10 	movl   $0xc010a1cc,0xc(%esp)
c0103a0b:	c0 
c0103a0c:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103a13:	c0 
c0103a14:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103a1b:	00 
c0103a1c:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103a23:	e8 c2 d2 ff ff       	call   c0100cea <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a2b:	89 04 24             	mov    %eax,(%esp)
c0103a2e:	e8 50 f8 ff ff       	call   c0103283 <page2pa>
c0103a33:	8b 15 a4 7f 12 c0    	mov    0xc0127fa4,%edx
c0103a39:	c1 e2 0c             	shl    $0xc,%edx
c0103a3c:	39 d0                	cmp    %edx,%eax
c0103a3e:	72 24                	jb     c0103a64 <basic_check+0x18d>
c0103a40:	c7 44 24 0c 08 a2 10 	movl   $0xc010a208,0xc(%esp)
c0103a47:	c0 
c0103a48:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103a4f:	c0 
c0103a50:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103a57:	00 
c0103a58:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103a5f:	e8 86 d2 ff ff       	call   c0100cea <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a67:	89 04 24             	mov    %eax,(%esp)
c0103a6a:	e8 14 f8 ff ff       	call   c0103283 <page2pa>
c0103a6f:	8b 15 a4 7f 12 c0    	mov    0xc0127fa4,%edx
c0103a75:	c1 e2 0c             	shl    $0xc,%edx
c0103a78:	39 d0                	cmp    %edx,%eax
c0103a7a:	72 24                	jb     c0103aa0 <basic_check+0x1c9>
c0103a7c:	c7 44 24 0c 25 a2 10 	movl   $0xc010a225,0xc(%esp)
c0103a83:	c0 
c0103a84:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103a8b:	c0 
c0103a8c:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103a93:	00 
c0103a94:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103a9b:	e8 4a d2 ff ff       	call   c0100cea <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa3:	89 04 24             	mov    %eax,(%esp)
c0103aa6:	e8 d8 f7 ff ff       	call   c0103283 <page2pa>
c0103aab:	8b 15 a4 7f 12 c0    	mov    0xc0127fa4,%edx
c0103ab1:	c1 e2 0c             	shl    $0xc,%edx
c0103ab4:	39 d0                	cmp    %edx,%eax
c0103ab6:	72 24                	jb     c0103adc <basic_check+0x205>
c0103ab8:	c7 44 24 0c 42 a2 10 	movl   $0xc010a242,0xc(%esp)
c0103abf:	c0 
c0103ac0:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103ac7:	c0 
c0103ac8:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103acf:	00 
c0103ad0:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103ad7:	e8 0e d2 ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c0103adc:	a1 84 7f 12 c0       	mov    0xc0127f84,%eax
c0103ae1:	8b 15 88 7f 12 c0    	mov    0xc0127f88,%edx
c0103ae7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103aea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103aed:	c7 45 dc 84 7f 12 c0 	movl   $0xc0127f84,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103af7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103afa:	89 50 04             	mov    %edx,0x4(%eax)
c0103afd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b00:	8b 50 04             	mov    0x4(%eax),%edx
c0103b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b06:	89 10                	mov    %edx,(%eax)
}
c0103b08:	90                   	nop
c0103b09:	c7 45 e0 84 7f 12 c0 	movl   $0xc0127f84,-0x20(%ebp)
    return list->next == list;
c0103b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b13:	8b 40 04             	mov    0x4(%eax),%eax
c0103b16:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103b19:	0f 94 c0             	sete   %al
c0103b1c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103b1f:	85 c0                	test   %eax,%eax
c0103b21:	75 24                	jne    c0103b47 <basic_check+0x270>
c0103b23:	c7 44 24 0c 5f a2 10 	movl   $0xc010a25f,0xc(%esp)
c0103b2a:	c0 
c0103b2b:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103b32:	c0 
c0103b33:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103b3a:	00 
c0103b3b:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103b42:	e8 a3 d1 ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c0103b47:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0103b4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103b4f:	c7 05 8c 7f 12 c0 00 	movl   $0x0,0xc0127f8c
c0103b56:	00 00 00 

    assert(alloc_page() == NULL);
c0103b59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b60:	e8 83 0c 00 00       	call   c01047e8 <alloc_pages>
c0103b65:	85 c0                	test   %eax,%eax
c0103b67:	74 24                	je     c0103b8d <basic_check+0x2b6>
c0103b69:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c0103b70:	c0 
c0103b71:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103b78:	c0 
c0103b79:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103b80:	00 
c0103b81:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103b88:	e8 5d d1 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103b8d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b94:	00 
c0103b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b98:	89 04 24             	mov    %eax,(%esp)
c0103b9b:	e8 b5 0c 00 00       	call   c0104855 <free_pages>
    free_page(p1);
c0103ba0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ba7:	00 
c0103ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bab:	89 04 24             	mov    %eax,(%esp)
c0103bae:	e8 a2 0c 00 00       	call   c0104855 <free_pages>
    free_page(p2);
c0103bb3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bba:	00 
c0103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bbe:	89 04 24             	mov    %eax,(%esp)
c0103bc1:	e8 8f 0c 00 00       	call   c0104855 <free_pages>
    assert(nr_free == 3);
c0103bc6:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0103bcb:	83 f8 03             	cmp    $0x3,%eax
c0103bce:	74 24                	je     c0103bf4 <basic_check+0x31d>
c0103bd0:	c7 44 24 0c 8b a2 10 	movl   $0xc010a28b,0xc(%esp)
c0103bd7:	c0 
c0103bd8:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103be7:	00 
c0103be8:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103bef:	e8 f6 d0 ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103bf4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bfb:	e8 e8 0b 00 00       	call   c01047e8 <alloc_pages>
c0103c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c07:	75 24                	jne    c0103c2d <basic_check+0x356>
c0103c09:	c7 44 24 0c 54 a1 10 	movl   $0xc010a154,0xc(%esp)
c0103c10:	c0 
c0103c11:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103c18:	c0 
c0103c19:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103c20:	00 
c0103c21:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103c28:	e8 bd d0 ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103c2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c34:	e8 af 0b 00 00       	call   c01047e8 <alloc_pages>
c0103c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c40:	75 24                	jne    c0103c66 <basic_check+0x38f>
c0103c42:	c7 44 24 0c 70 a1 10 	movl   $0xc010a170,0xc(%esp)
c0103c49:	c0 
c0103c4a:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103c51:	c0 
c0103c52:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103c59:	00 
c0103c5a:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103c61:	e8 84 d0 ff ff       	call   c0100cea <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c6d:	e8 76 0b 00 00       	call   c01047e8 <alloc_pages>
c0103c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c79:	75 24                	jne    c0103c9f <basic_check+0x3c8>
c0103c7b:	c7 44 24 0c 8c a1 10 	movl   $0xc010a18c,0xc(%esp)
c0103c82:	c0 
c0103c83:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103c8a:	c0 
c0103c8b:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103c92:	00 
c0103c93:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103c9a:	e8 4b d0 ff ff       	call   c0100cea <__panic>

    assert(alloc_page() == NULL);
c0103c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ca6:	e8 3d 0b 00 00       	call   c01047e8 <alloc_pages>
c0103cab:	85 c0                	test   %eax,%eax
c0103cad:	74 24                	je     c0103cd3 <basic_check+0x3fc>
c0103caf:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c0103cb6:	c0 
c0103cb7:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103cbe:	c0 
c0103cbf:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103cc6:	00 
c0103cc7:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103cce:	e8 17 d0 ff ff       	call   c0100cea <__panic>

    free_page(p0);
c0103cd3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cda:	00 
c0103cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cde:	89 04 24             	mov    %eax,(%esp)
c0103ce1:	e8 6f 0b 00 00       	call   c0104855 <free_pages>
c0103ce6:	c7 45 d8 84 7f 12 c0 	movl   $0xc0127f84,-0x28(%ebp)
c0103ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cf0:	8b 40 04             	mov    0x4(%eax),%eax
c0103cf3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103cf6:	0f 94 c0             	sete   %al
c0103cf9:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103cfc:	85 c0                	test   %eax,%eax
c0103cfe:	74 24                	je     c0103d24 <basic_check+0x44d>
c0103d00:	c7 44 24 0c 98 a2 10 	movl   $0xc010a298,0xc(%esp)
c0103d07:	c0 
c0103d08:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103d0f:	c0 
c0103d10:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103d17:	00 
c0103d18:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103d1f:	e8 c6 cf ff ff       	call   c0100cea <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103d24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d2b:	e8 b8 0a 00 00       	call   c01047e8 <alloc_pages>
c0103d30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d39:	74 24                	je     c0103d5f <basic_check+0x488>
c0103d3b:	c7 44 24 0c b0 a2 10 	movl   $0xc010a2b0,0xc(%esp)
c0103d42:	c0 
c0103d43:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103d4a:	c0 
c0103d4b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103d52:	00 
c0103d53:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103d5a:	e8 8b cf ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103d5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d66:	e8 7d 0a 00 00       	call   c01047e8 <alloc_pages>
c0103d6b:	85 c0                	test   %eax,%eax
c0103d6d:	74 24                	je     c0103d93 <basic_check+0x4bc>
c0103d6f:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c0103d76:	c0 
c0103d77:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103d7e:	c0 
c0103d7f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103d86:	00 
c0103d87:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103d8e:	e8 57 cf ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c0103d93:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0103d98:	85 c0                	test   %eax,%eax
c0103d9a:	74 24                	je     c0103dc0 <basic_check+0x4e9>
c0103d9c:	c7 44 24 0c c9 a2 10 	movl   $0xc010a2c9,0xc(%esp)
c0103da3:	c0 
c0103da4:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103dab:	c0 
c0103dac:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103db3:	00 
c0103db4:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103dbb:	e8 2a cf ff ff       	call   c0100cea <__panic>
    free_list = free_list_store;
c0103dc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103dc3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103dc6:	a3 84 7f 12 c0       	mov    %eax,0xc0127f84
c0103dcb:	89 15 88 7f 12 c0    	mov    %edx,0xc0127f88
    nr_free = nr_free_store;
c0103dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dd4:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c

    free_page(p);
c0103dd9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103de0:	00 
c0103de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103de4:	89 04 24             	mov    %eax,(%esp)
c0103de7:	e8 69 0a 00 00       	call   c0104855 <free_pages>
    free_page(p1);
c0103dec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103df3:	00 
c0103df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103df7:	89 04 24             	mov    %eax,(%esp)
c0103dfa:	e8 56 0a 00 00       	call   c0104855 <free_pages>
    free_page(p2);
c0103dff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e06:	00 
c0103e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e0a:	89 04 24             	mov    %eax,(%esp)
c0103e0d:	e8 43 0a 00 00       	call   c0104855 <free_pages>
}
c0103e12:	90                   	nop
c0103e13:	89 ec                	mov    %ebp,%esp
c0103e15:	5d                   	pop    %ebp
c0103e16:	c3                   	ret    

c0103e17 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c0103e17:	55                   	push   %ebp
c0103e18:	89 e5                	mov    %esp,%ebp
c0103e1a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103e20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103e2e:	c7 45 ec 84 7f 12 c0 	movl   $0xc0127f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0103e35:	eb 6a                	jmp    c0103ea1 <default_check+0x8a>
    {
        struct Page *p = le2page(le, page_link);
c0103e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e3a:	83 e8 0c             	sub    $0xc,%eax
c0103e3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103e40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103e43:	83 c0 04             	add    $0x4,%eax
c0103e46:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103e4d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e50:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103e53:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103e56:	0f a3 10             	bt     %edx,(%eax)
c0103e59:	19 c0                	sbb    %eax,%eax
c0103e5b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103e5e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103e62:	0f 95 c0             	setne  %al
c0103e65:	0f b6 c0             	movzbl %al,%eax
c0103e68:	85 c0                	test   %eax,%eax
c0103e6a:	75 24                	jne    c0103e90 <default_check+0x79>
c0103e6c:	c7 44 24 0c d6 a2 10 	movl   $0xc010a2d6,0xc(%esp)
c0103e73:	c0 
c0103e74:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103e7b:	c0 
c0103e7c:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103e83:	00 
c0103e84:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103e8b:	e8 5a ce ff ff       	call   c0100cea <__panic>
        count++, total += p->property;
c0103e90:	ff 45 f4             	incl   -0xc(%ebp)
c0103e93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103e96:	8b 50 08             	mov    0x8(%eax),%edx
c0103e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e9c:	01 d0                	add    %edx,%eax
c0103e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ea4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103ea7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103eaa:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0103ead:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103eb0:	81 7d ec 84 7f 12 c0 	cmpl   $0xc0127f84,-0x14(%ebp)
c0103eb7:	0f 85 7a ff ff ff    	jne    c0103e37 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0103ebd:	e8 c8 09 00 00       	call   c010488a <nr_free_pages>
c0103ec2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103ec5:	39 d0                	cmp    %edx,%eax
c0103ec7:	74 24                	je     c0103eed <default_check+0xd6>
c0103ec9:	c7 44 24 0c e6 a2 10 	movl   $0xc010a2e6,0xc(%esp)
c0103ed0:	c0 
c0103ed1:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103ed8:	c0 
c0103ed9:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103ee0:	00 
c0103ee1:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103ee8:	e8 fd cd ff ff       	call   c0100cea <__panic>

    basic_check();
c0103eed:	e8 e5 f9 ff ff       	call   c01038d7 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103ef2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103ef9:	e8 ea 08 00 00       	call   c01047e8 <alloc_pages>
c0103efe:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103f05:	75 24                	jne    c0103f2b <default_check+0x114>
c0103f07:	c7 44 24 0c ff a2 10 	movl   $0xc010a2ff,0xc(%esp)
c0103f0e:	c0 
c0103f0f:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103f16:	c0 
c0103f17:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103f1e:	00 
c0103f1f:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103f26:	e8 bf cd ff ff       	call   c0100cea <__panic>
    assert(!PageProperty(p0));
c0103f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f2e:	83 c0 04             	add    $0x4,%eax
c0103f31:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103f38:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f3b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103f3e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103f41:	0f a3 10             	bt     %edx,(%eax)
c0103f44:	19 c0                	sbb    %eax,%eax
c0103f46:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103f49:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103f4d:	0f 95 c0             	setne  %al
c0103f50:	0f b6 c0             	movzbl %al,%eax
c0103f53:	85 c0                	test   %eax,%eax
c0103f55:	74 24                	je     c0103f7b <default_check+0x164>
c0103f57:	c7 44 24 0c 0a a3 10 	movl   $0xc010a30a,0xc(%esp)
c0103f5e:	c0 
c0103f5f:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103f66:	c0 
c0103f67:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103f6e:	00 
c0103f6f:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103f76:	e8 6f cd ff ff       	call   c0100cea <__panic>

    list_entry_t free_list_store = free_list;
c0103f7b:	a1 84 7f 12 c0       	mov    0xc0127f84,%eax
c0103f80:	8b 15 88 7f 12 c0    	mov    0xc0127f88,%edx
c0103f86:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f89:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f8c:	c7 45 b0 84 7f 12 c0 	movl   $0xc0127f84,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103f93:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f96:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103f99:	89 50 04             	mov    %edx,0x4(%eax)
c0103f9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f9f:	8b 50 04             	mov    0x4(%eax),%edx
c0103fa2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103fa5:	89 10                	mov    %edx,(%eax)
}
c0103fa7:	90                   	nop
c0103fa8:	c7 45 b4 84 7f 12 c0 	movl   $0xc0127f84,-0x4c(%ebp)
    return list->next == list;
c0103faf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103fb2:	8b 40 04             	mov    0x4(%eax),%eax
c0103fb5:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103fb8:	0f 94 c0             	sete   %al
c0103fbb:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103fbe:	85 c0                	test   %eax,%eax
c0103fc0:	75 24                	jne    c0103fe6 <default_check+0x1cf>
c0103fc2:	c7 44 24 0c 5f a2 10 	movl   $0xc010a25f,0xc(%esp)
c0103fc9:	c0 
c0103fca:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0103fd1:	c0 
c0103fd2:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103fd9:	00 
c0103fda:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0103fe1:	e8 04 cd ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0103fe6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fed:	e8 f6 07 00 00       	call   c01047e8 <alloc_pages>
c0103ff2:	85 c0                	test   %eax,%eax
c0103ff4:	74 24                	je     c010401a <default_check+0x203>
c0103ff6:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c0103ffd:	c0 
c0103ffe:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104005:	c0 
c0104006:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010400d:	00 
c010400e:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104015:	e8 d0 cc ff ff       	call   c0100cea <__panic>

    unsigned int nr_free_store = nr_free;
c010401a:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c010401f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104022:	c7 05 8c 7f 12 c0 00 	movl   $0x0,0xc0127f8c
c0104029:	00 00 00 

    free_pages(p0 + 2, 3);
c010402c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010402f:	83 c0 40             	add    $0x40,%eax
c0104032:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104039:	00 
c010403a:	89 04 24             	mov    %eax,(%esp)
c010403d:	e8 13 08 00 00       	call   c0104855 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104042:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104049:	e8 9a 07 00 00       	call   c01047e8 <alloc_pages>
c010404e:	85 c0                	test   %eax,%eax
c0104050:	74 24                	je     c0104076 <default_check+0x25f>
c0104052:	c7 44 24 0c 1c a3 10 	movl   $0xc010a31c,0xc(%esp)
c0104059:	c0 
c010405a:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104061:	c0 
c0104062:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0104069:	00 
c010406a:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104071:	e8 74 cc ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104076:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104079:	83 c0 40             	add    $0x40,%eax
c010407c:	83 c0 04             	add    $0x4,%eax
c010407f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104086:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104089:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010408c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010408f:	0f a3 10             	bt     %edx,(%eax)
c0104092:	19 c0                	sbb    %eax,%eax
c0104094:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104097:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010409b:	0f 95 c0             	setne  %al
c010409e:	0f b6 c0             	movzbl %al,%eax
c01040a1:	85 c0                	test   %eax,%eax
c01040a3:	74 0e                	je     c01040b3 <default_check+0x29c>
c01040a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040a8:	83 c0 40             	add    $0x40,%eax
c01040ab:	8b 40 08             	mov    0x8(%eax),%eax
c01040ae:	83 f8 03             	cmp    $0x3,%eax
c01040b1:	74 24                	je     c01040d7 <default_check+0x2c0>
c01040b3:	c7 44 24 0c 34 a3 10 	movl   $0xc010a334,0xc(%esp)
c01040ba:	c0 
c01040bb:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01040c2:	c0 
c01040c3:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01040ca:	00 
c01040cb:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01040d2:	e8 13 cc ff ff       	call   c0100cea <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01040d7:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01040de:	e8 05 07 00 00       	call   c01047e8 <alloc_pages>
c01040e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01040ea:	75 24                	jne    c0104110 <default_check+0x2f9>
c01040ec:	c7 44 24 0c 60 a3 10 	movl   $0xc010a360,0xc(%esp)
c01040f3:	c0 
c01040f4:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01040fb:	c0 
c01040fc:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0104103:	00 
c0104104:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010410b:	e8 da cb ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104117:	e8 cc 06 00 00       	call   c01047e8 <alloc_pages>
c010411c:	85 c0                	test   %eax,%eax
c010411e:	74 24                	je     c0104144 <default_check+0x32d>
c0104120:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c0104127:	c0 
c0104128:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010412f:	c0 
c0104130:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104137:	00 
c0104138:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010413f:	e8 a6 cb ff ff       	call   c0100cea <__panic>
    assert(p0 + 2 == p1);
c0104144:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104147:	83 c0 40             	add    $0x40,%eax
c010414a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010414d:	74 24                	je     c0104173 <default_check+0x35c>
c010414f:	c7 44 24 0c 7e a3 10 	movl   $0xc010a37e,0xc(%esp)
c0104156:	c0 
c0104157:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010415e:	c0 
c010415f:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0104166:	00 
c0104167:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010416e:	e8 77 cb ff ff       	call   c0100cea <__panic>

    p2 = p0 + 1;
c0104173:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104176:	83 c0 20             	add    $0x20,%eax
c0104179:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010417c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104183:	00 
c0104184:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104187:	89 04 24             	mov    %eax,(%esp)
c010418a:	e8 c6 06 00 00       	call   c0104855 <free_pages>
    free_pages(p1, 3);
c010418f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104196:	00 
c0104197:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010419a:	89 04 24             	mov    %eax,(%esp)
c010419d:	e8 b3 06 00 00       	call   c0104855 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01041a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041a5:	83 c0 04             	add    $0x4,%eax
c01041a8:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01041af:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041b2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01041b5:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01041b8:	0f a3 10             	bt     %edx,(%eax)
c01041bb:	19 c0                	sbb    %eax,%eax
c01041bd:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01041c0:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01041c4:	0f 95 c0             	setne  %al
c01041c7:	0f b6 c0             	movzbl %al,%eax
c01041ca:	85 c0                	test   %eax,%eax
c01041cc:	74 0b                	je     c01041d9 <default_check+0x3c2>
c01041ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041d1:	8b 40 08             	mov    0x8(%eax),%eax
c01041d4:	83 f8 01             	cmp    $0x1,%eax
c01041d7:	74 24                	je     c01041fd <default_check+0x3e6>
c01041d9:	c7 44 24 0c 8c a3 10 	movl   $0xc010a38c,0xc(%esp)
c01041e0:	c0 
c01041e1:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01041e8:	c0 
c01041e9:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01041f0:	00 
c01041f1:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01041f8:	e8 ed ca ff ff       	call   c0100cea <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01041fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104200:	83 c0 04             	add    $0x4,%eax
c0104203:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010420a:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010420d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104210:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104213:	0f a3 10             	bt     %edx,(%eax)
c0104216:	19 c0                	sbb    %eax,%eax
c0104218:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010421b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010421f:	0f 95 c0             	setne  %al
c0104222:	0f b6 c0             	movzbl %al,%eax
c0104225:	85 c0                	test   %eax,%eax
c0104227:	74 0b                	je     c0104234 <default_check+0x41d>
c0104229:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010422c:	8b 40 08             	mov    0x8(%eax),%eax
c010422f:	83 f8 03             	cmp    $0x3,%eax
c0104232:	74 24                	je     c0104258 <default_check+0x441>
c0104234:	c7 44 24 0c b4 a3 10 	movl   $0xc010a3b4,0xc(%esp)
c010423b:	c0 
c010423c:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104243:	c0 
c0104244:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010424b:	00 
c010424c:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104253:	e8 92 ca ff ff       	call   c0100cea <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010425f:	e8 84 05 00 00       	call   c01047e8 <alloc_pages>
c0104264:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104267:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010426a:	83 e8 20             	sub    $0x20,%eax
c010426d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104270:	74 24                	je     c0104296 <default_check+0x47f>
c0104272:	c7 44 24 0c da a3 10 	movl   $0xc010a3da,0xc(%esp)
c0104279:	c0 
c010427a:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104281:	c0 
c0104282:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0104289:	00 
c010428a:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104291:	e8 54 ca ff ff       	call   c0100cea <__panic>
    free_page(p0);
c0104296:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010429d:	00 
c010429e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042a1:	89 04 24             	mov    %eax,(%esp)
c01042a4:	e8 ac 05 00 00       	call   c0104855 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01042a9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01042b0:	e8 33 05 00 00       	call   c01047e8 <alloc_pages>
c01042b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01042b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042bb:	83 c0 20             	add    $0x20,%eax
c01042be:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01042c1:	74 24                	je     c01042e7 <default_check+0x4d0>
c01042c3:	c7 44 24 0c f8 a3 10 	movl   $0xc010a3f8,0xc(%esp)
c01042ca:	c0 
c01042cb:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c01042d2:	c0 
c01042d3:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01042da:	00 
c01042db:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01042e2:	e8 03 ca ff ff       	call   c0100cea <__panic>

    free_pages(p0, 2);
c01042e7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01042ee:	00 
c01042ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042f2:	89 04 24             	mov    %eax,(%esp)
c01042f5:	e8 5b 05 00 00       	call   c0104855 <free_pages>
    free_page(p2);
c01042fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104301:	00 
c0104302:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104305:	89 04 24             	mov    %eax,(%esp)
c0104308:	e8 48 05 00 00       	call   c0104855 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010430d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104314:	e8 cf 04 00 00       	call   c01047e8 <alloc_pages>
c0104319:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010431c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104320:	75 24                	jne    c0104346 <default_check+0x52f>
c0104322:	c7 44 24 0c 18 a4 10 	movl   $0xc010a418,0xc(%esp)
c0104329:	c0 
c010432a:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104331:	c0 
c0104332:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0104339:	00 
c010433a:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104341:	e8 a4 c9 ff ff       	call   c0100cea <__panic>
    assert(alloc_page() == NULL);
c0104346:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010434d:	e8 96 04 00 00       	call   c01047e8 <alloc_pages>
c0104352:	85 c0                	test   %eax,%eax
c0104354:	74 24                	je     c010437a <default_check+0x563>
c0104356:	c7 44 24 0c 76 a2 10 	movl   $0xc010a276,0xc(%esp)
c010435d:	c0 
c010435e:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104365:	c0 
c0104366:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010436d:	00 
c010436e:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104375:	e8 70 c9 ff ff       	call   c0100cea <__panic>

    assert(nr_free == 0);
c010437a:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c010437f:	85 c0                	test   %eax,%eax
c0104381:	74 24                	je     c01043a7 <default_check+0x590>
c0104383:	c7 44 24 0c c9 a2 10 	movl   $0xc010a2c9,0xc(%esp)
c010438a:	c0 
c010438b:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104392:	c0 
c0104393:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c010439a:	00 
c010439b:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01043a2:	e8 43 c9 ff ff       	call   c0100cea <__panic>
    nr_free = nr_free_store;
c01043a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043aa:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c

    free_list = free_list_store;
c01043af:	8b 45 80             	mov    -0x80(%ebp),%eax
c01043b2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01043b5:	a3 84 7f 12 c0       	mov    %eax,0xc0127f84
c01043ba:	89 15 88 7f 12 c0    	mov    %edx,0xc0127f88
    free_pages(p0, 5);
c01043c0:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01043c7:	00 
c01043c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043cb:	89 04 24             	mov    %eax,(%esp)
c01043ce:	e8 82 04 00 00       	call   c0104855 <free_pages>

    le = &free_list;
c01043d3:	c7 45 ec 84 7f 12 c0 	movl   $0xc0127f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c01043da:	eb 1c                	jmp    c01043f8 <default_check+0x5e1>
    {
        struct Page *p = le2page(le, page_link);
c01043dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043df:	83 e8 0c             	sub    $0xc,%eax
c01043e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c01043e5:	ff 4d f4             	decl   -0xc(%ebp)
c01043e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01043eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043ee:	8b 48 08             	mov    0x8(%eax),%ecx
c01043f1:	89 d0                	mov    %edx,%eax
c01043f3:	29 c8                	sub    %ecx,%eax
c01043f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043fb:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01043fe:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104401:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0104404:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104407:	81 7d ec 84 7f 12 c0 	cmpl   $0xc0127f84,-0x14(%ebp)
c010440e:	75 cc                	jne    c01043dc <default_check+0x5c5>
    }
    assert(count == 0);
c0104410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104414:	74 24                	je     c010443a <default_check+0x623>
c0104416:	c7 44 24 0c 36 a4 10 	movl   $0xc010a436,0xc(%esp)
c010441d:	c0 
c010441e:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c0104425:	c0 
c0104426:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c010442d:	00 
c010442e:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c0104435:	e8 b0 c8 ff ff       	call   c0100cea <__panic>
    assert(total == 0);
c010443a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010443e:	74 24                	je     c0104464 <default_check+0x64d>
c0104440:	c7 44 24 0c 41 a4 10 	movl   $0xc010a441,0xc(%esp)
c0104447:	c0 
c0104448:	c7 44 24 08 d6 a0 10 	movl   $0xc010a0d6,0x8(%esp)
c010444f:	c0 
c0104450:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0104457:	00 
c0104458:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c010445f:	e8 86 c8 ff ff       	call   c0100cea <__panic>
}
c0104464:	90                   	nop
c0104465:	89 ec                	mov    %ebp,%esp
c0104467:	5d                   	pop    %ebp
c0104468:	c3                   	ret    

c0104469 <page2ppn>:
page2ppn(struct Page *page) {
c0104469:	55                   	push   %ebp
c010446a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010446c:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c0104472:	8b 45 08             	mov    0x8(%ebp),%eax
c0104475:	29 d0                	sub    %edx,%eax
c0104477:	c1 f8 05             	sar    $0x5,%eax
}
c010447a:	5d                   	pop    %ebp
c010447b:	c3                   	ret    

c010447c <page2pa>:
page2pa(struct Page *page) {
c010447c:	55                   	push   %ebp
c010447d:	89 e5                	mov    %esp,%ebp
c010447f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104482:	8b 45 08             	mov    0x8(%ebp),%eax
c0104485:	89 04 24             	mov    %eax,(%esp)
c0104488:	e8 dc ff ff ff       	call   c0104469 <page2ppn>
c010448d:	c1 e0 0c             	shl    $0xc,%eax
}
c0104490:	89 ec                	mov    %ebp,%esp
c0104492:	5d                   	pop    %ebp
c0104493:	c3                   	ret    

c0104494 <pa2page>:
pa2page(uintptr_t pa) {
c0104494:	55                   	push   %ebp
c0104495:	89 e5                	mov    %esp,%ebp
c0104497:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010449a:	8b 45 08             	mov    0x8(%ebp),%eax
c010449d:	c1 e8 0c             	shr    $0xc,%eax
c01044a0:	89 c2                	mov    %eax,%edx
c01044a2:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01044a7:	39 c2                	cmp    %eax,%edx
c01044a9:	72 1c                	jb     c01044c7 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01044ab:	c7 44 24 08 7c a4 10 	movl   $0xc010a47c,0x8(%esp)
c01044b2:	c0 
c01044b3:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01044ba:	00 
c01044bb:	c7 04 24 9b a4 10 c0 	movl   $0xc010a49b,(%esp)
c01044c2:	e8 23 c8 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c01044c7:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c01044cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d0:	c1 e8 0c             	shr    $0xc,%eax
c01044d3:	c1 e0 05             	shl    $0x5,%eax
c01044d6:	01 d0                	add    %edx,%eax
}
c01044d8:	89 ec                	mov    %ebp,%esp
c01044da:	5d                   	pop    %ebp
c01044db:	c3                   	ret    

c01044dc <page2kva>:
page2kva(struct Page *page) {
c01044dc:	55                   	push   %ebp
c01044dd:	89 e5                	mov    %esp,%ebp
c01044df:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01044e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e5:	89 04 24             	mov    %eax,(%esp)
c01044e8:	e8 8f ff ff ff       	call   c010447c <page2pa>
c01044ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f3:	c1 e8 0c             	shr    $0xc,%eax
c01044f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044f9:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01044fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104501:	72 23                	jb     c0104526 <page2kva+0x4a>
c0104503:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104506:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010450a:	c7 44 24 08 ac a4 10 	movl   $0xc010a4ac,0x8(%esp)
c0104511:	c0 
c0104512:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104519:	00 
c010451a:	c7 04 24 9b a4 10 c0 	movl   $0xc010a49b,(%esp)
c0104521:	e8 c4 c7 ff ff       	call   c0100cea <__panic>
c0104526:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104529:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010452e:	89 ec                	mov    %ebp,%esp
c0104530:	5d                   	pop    %ebp
c0104531:	c3                   	ret    

c0104532 <kva2page>:
kva2page(void *kva) {
c0104532:	55                   	push   %ebp
c0104533:	89 e5                	mov    %esp,%ebp
c0104535:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104538:	8b 45 08             	mov    0x8(%ebp),%eax
c010453b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010453e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104545:	77 23                	ja     c010456a <kva2page+0x38>
c0104547:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010454e:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c0104555:	c0 
c0104556:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010455d:	00 
c010455e:	c7 04 24 9b a4 10 c0 	movl   $0xc010a49b,(%esp)
c0104565:	e8 80 c7 ff ff       	call   c0100cea <__panic>
c010456a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104572:	89 04 24             	mov    %eax,(%esp)
c0104575:	e8 1a ff ff ff       	call   c0104494 <pa2page>
}
c010457a:	89 ec                	mov    %ebp,%esp
c010457c:	5d                   	pop    %ebp
c010457d:	c3                   	ret    

c010457e <pte2page>:
pte2page(pte_t pte) {
c010457e:	55                   	push   %ebp
c010457f:	89 e5                	mov    %esp,%ebp
c0104581:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104584:	8b 45 08             	mov    0x8(%ebp),%eax
c0104587:	83 e0 01             	and    $0x1,%eax
c010458a:	85 c0                	test   %eax,%eax
c010458c:	75 1c                	jne    c01045aa <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010458e:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c0104595:	c0 
c0104596:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010459d:	00 
c010459e:	c7 04 24 9b a4 10 c0 	movl   $0xc010a49b,(%esp)
c01045a5:	e8 40 c7 ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c01045aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045b2:	89 04 24             	mov    %eax,(%esp)
c01045b5:	e8 da fe ff ff       	call   c0104494 <pa2page>
}
c01045ba:	89 ec                	mov    %ebp,%esp
c01045bc:	5d                   	pop    %ebp
c01045bd:	c3                   	ret    

c01045be <pde2page>:
pde2page(pde_t pde) {
c01045be:	55                   	push   %ebp
c01045bf:	89 e5                	mov    %esp,%ebp
c01045c1:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01045c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045cc:	89 04 24             	mov    %eax,(%esp)
c01045cf:	e8 c0 fe ff ff       	call   c0104494 <pa2page>
}
c01045d4:	89 ec                	mov    %ebp,%esp
c01045d6:	5d                   	pop    %ebp
c01045d7:	c3                   	ret    

c01045d8 <page_ref>:
page_ref(struct Page *page) {
c01045d8:	55                   	push   %ebp
c01045d9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01045db:	8b 45 08             	mov    0x8(%ebp),%eax
c01045de:	8b 00                	mov    (%eax),%eax
}
c01045e0:	5d                   	pop    %ebp
c01045e1:	c3                   	ret    

c01045e2 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01045e2:	55                   	push   %ebp
c01045e3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01045e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045eb:	89 10                	mov    %edx,(%eax)
}
c01045ed:	90                   	nop
c01045ee:	5d                   	pop    %ebp
c01045ef:	c3                   	ret    

c01045f0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01045f0:	55                   	push   %ebp
c01045f1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01045f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f6:	8b 00                	mov    (%eax),%eax
c01045f8:	8d 50 01             	lea    0x1(%eax),%edx
c01045fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045fe:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104600:	8b 45 08             	mov    0x8(%ebp),%eax
c0104603:	8b 00                	mov    (%eax),%eax
}
c0104605:	5d                   	pop    %ebp
c0104606:	c3                   	ret    

c0104607 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104607:	55                   	push   %ebp
c0104608:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010460a:	8b 45 08             	mov    0x8(%ebp),%eax
c010460d:	8b 00                	mov    (%eax),%eax
c010460f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104612:	8b 45 08             	mov    0x8(%ebp),%eax
c0104615:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104617:	8b 45 08             	mov    0x8(%ebp),%eax
c010461a:	8b 00                	mov    (%eax),%eax
}
c010461c:	5d                   	pop    %ebp
c010461d:	c3                   	ret    

c010461e <__intr_save>:
__intr_save(void) {
c010461e:	55                   	push   %ebp
c010461f:	89 e5                	mov    %esp,%ebp
c0104621:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104624:	9c                   	pushf  
c0104625:	58                   	pop    %eax
c0104626:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010462c:	25 00 02 00 00       	and    $0x200,%eax
c0104631:	85 c0                	test   %eax,%eax
c0104633:	74 0c                	je     c0104641 <__intr_save+0x23>
        intr_disable();
c0104635:	e8 66 d9 ff ff       	call   c0101fa0 <intr_disable>
        return 1;
c010463a:	b8 01 00 00 00       	mov    $0x1,%eax
c010463f:	eb 05                	jmp    c0104646 <__intr_save+0x28>
    return 0;
c0104641:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104646:	89 ec                	mov    %ebp,%esp
c0104648:	5d                   	pop    %ebp
c0104649:	c3                   	ret    

c010464a <__intr_restore>:
__intr_restore(bool flag) {
c010464a:	55                   	push   %ebp
c010464b:	89 e5                	mov    %esp,%ebp
c010464d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104654:	74 05                	je     c010465b <__intr_restore+0x11>
        intr_enable();
c0104656:	e8 3d d9 ff ff       	call   c0101f98 <intr_enable>
}
c010465b:	90                   	nop
c010465c:	89 ec                	mov    %ebp,%esp
c010465e:	5d                   	pop    %ebp
c010465f:	c3                   	ret    

c0104660 <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
c0104660:	55                   	push   %ebp
c0104661:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
c0104663:	8b 45 08             	mov    0x8(%ebp),%eax
c0104666:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
c0104669:	b8 23 00 00 00       	mov    $0x23,%eax
c010466e:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
c0104670:	b8 23 00 00 00       	mov    $0x23,%eax
c0104675:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
c0104677:	b8 10 00 00 00       	mov    $0x10,%eax
c010467c:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
c010467e:	b8 10 00 00 00       	mov    $0x10,%eax
c0104683:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
c0104685:	b8 10 00 00 00       	mov    $0x10,%eax
c010468a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
c010468c:	ea 93 46 10 c0 08 00 	ljmp   $0x8,$0xc0104693
}
c0104693:	90                   	nop
c0104694:	5d                   	pop    %ebp
c0104695:	c3                   	ret    

c0104696 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
c0104696:	55                   	push   %ebp
c0104697:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104699:	8b 45 08             	mov    0x8(%ebp),%eax
c010469c:	a3 c4 7f 12 c0       	mov    %eax,0xc0127fc4
}
c01046a1:	90                   	nop
c01046a2:	5d                   	pop    %ebp
c01046a3:	c3                   	ret    

c01046a4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
c01046a4:	55                   	push   %ebp
c01046a5:	89 e5                	mov    %esp,%ebp
c01046a7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01046aa:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c01046af:	89 04 24             	mov    %eax,(%esp)
c01046b2:	e8 df ff ff ff       	call   c0104696 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01046b7:	66 c7 05 c8 7f 12 c0 	movw   $0x10,0xc0127fc8
c01046be:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01046c0:	66 c7 05 28 4a 12 c0 	movw   $0x68,0xc0124a28
c01046c7:	68 00 
c01046c9:	b8 c0 7f 12 c0       	mov    $0xc0127fc0,%eax
c01046ce:	0f b7 c0             	movzwl %ax,%eax
c01046d1:	66 a3 2a 4a 12 c0    	mov    %ax,0xc0124a2a
c01046d7:	b8 c0 7f 12 c0       	mov    $0xc0127fc0,%eax
c01046dc:	c1 e8 10             	shr    $0x10,%eax
c01046df:	a2 2c 4a 12 c0       	mov    %al,0xc0124a2c
c01046e4:	0f b6 05 2d 4a 12 c0 	movzbl 0xc0124a2d,%eax
c01046eb:	24 f0                	and    $0xf0,%al
c01046ed:	0c 09                	or     $0x9,%al
c01046ef:	a2 2d 4a 12 c0       	mov    %al,0xc0124a2d
c01046f4:	0f b6 05 2d 4a 12 c0 	movzbl 0xc0124a2d,%eax
c01046fb:	24 ef                	and    $0xef,%al
c01046fd:	a2 2d 4a 12 c0       	mov    %al,0xc0124a2d
c0104702:	0f b6 05 2d 4a 12 c0 	movzbl 0xc0124a2d,%eax
c0104709:	24 9f                	and    $0x9f,%al
c010470b:	a2 2d 4a 12 c0       	mov    %al,0xc0124a2d
c0104710:	0f b6 05 2d 4a 12 c0 	movzbl 0xc0124a2d,%eax
c0104717:	0c 80                	or     $0x80,%al
c0104719:	a2 2d 4a 12 c0       	mov    %al,0xc0124a2d
c010471e:	0f b6 05 2e 4a 12 c0 	movzbl 0xc0124a2e,%eax
c0104725:	24 f0                	and    $0xf0,%al
c0104727:	a2 2e 4a 12 c0       	mov    %al,0xc0124a2e
c010472c:	0f b6 05 2e 4a 12 c0 	movzbl 0xc0124a2e,%eax
c0104733:	24 ef                	and    $0xef,%al
c0104735:	a2 2e 4a 12 c0       	mov    %al,0xc0124a2e
c010473a:	0f b6 05 2e 4a 12 c0 	movzbl 0xc0124a2e,%eax
c0104741:	24 df                	and    $0xdf,%al
c0104743:	a2 2e 4a 12 c0       	mov    %al,0xc0124a2e
c0104748:	0f b6 05 2e 4a 12 c0 	movzbl 0xc0124a2e,%eax
c010474f:	0c 40                	or     $0x40,%al
c0104751:	a2 2e 4a 12 c0       	mov    %al,0xc0124a2e
c0104756:	0f b6 05 2e 4a 12 c0 	movzbl 0xc0124a2e,%eax
c010475d:	24 7f                	and    $0x7f,%al
c010475f:	a2 2e 4a 12 c0       	mov    %al,0xc0124a2e
c0104764:	b8 c0 7f 12 c0       	mov    $0xc0127fc0,%eax
c0104769:	c1 e8 18             	shr    $0x18,%eax
c010476c:	a2 2f 4a 12 c0       	mov    %al,0xc0124a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104771:	c7 04 24 30 4a 12 c0 	movl   $0xc0124a30,(%esp)
c0104778:	e8 e3 fe ff ff       	call   c0104660 <lgdt>
c010477d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104783:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104787:	0f 00 d8             	ltr    %ax
}
c010478a:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c010478b:	90                   	nop
c010478c:	89 ec                	mov    %ebp,%esp
c010478e:	5d                   	pop    %ebp
c010478f:	c3                   	ret    

c0104790 <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
c0104790:	55                   	push   %ebp
c0104791:	89 e5                	mov    %esp,%ebp
c0104793:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104796:	c7 05 ac 7f 12 c0 60 	movl   $0xc010a460,0xc0127fac
c010479d:	a4 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01047a0:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c01047a5:	8b 00                	mov    (%eax),%eax
c01047a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047ab:	c7 04 24 20 a5 10 c0 	movl   $0xc010a520,(%esp)
c01047b2:	e8 ae bb ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c01047b7:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c01047bc:	8b 40 04             	mov    0x4(%eax),%eax
c01047bf:	ff d0                	call   *%eax
}
c01047c1:	90                   	nop
c01047c2:	89 ec                	mov    %ebp,%esp
c01047c4:	5d                   	pop    %ebp
c01047c5:	c3                   	ret    

c01047c6 <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
c01047c6:	55                   	push   %ebp
c01047c7:	89 e5                	mov    %esp,%ebp
c01047c9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01047cc:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c01047d1:	8b 40 08             	mov    0x8(%eax),%eax
c01047d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047d7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047db:	8b 55 08             	mov    0x8(%ebp),%edx
c01047de:	89 14 24             	mov    %edx,(%esp)
c01047e1:	ff d0                	call   *%eax
}
c01047e3:	90                   	nop
c01047e4:	89 ec                	mov    %ebp,%esp
c01047e6:	5d                   	pop    %ebp
c01047e7:	c3                   	ret    

c01047e8 <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
c01047e8:	55                   	push   %ebp
c01047e9:	89 e5                	mov    %esp,%ebp
c01047eb:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c01047ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;

    while (1)
    {
        local_intr_save(intr_flag);
c01047f5:	e8 24 fe ff ff       	call   c010461e <__intr_save>
c01047fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
        {
            page = pmm_manager->alloc_pages(n);
c01047fd:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c0104802:	8b 40 0c             	mov    0xc(%eax),%eax
c0104805:	8b 55 08             	mov    0x8(%ebp),%edx
c0104808:	89 14 24             	mov    %edx,(%esp)
c010480b:	ff d0                	call   *%eax
c010480d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        local_intr_restore(intr_flag);
c0104810:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104813:	89 04 24             	mov    %eax,(%esp)
c0104816:	e8 2f fe ff ff       	call   c010464a <__intr_restore>

        if (page != NULL || n > 1 || swap_init_ok == 0)
c010481b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010481f:	75 2d                	jne    c010484e <alloc_pages+0x66>
c0104821:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104825:	77 27                	ja     c010484e <alloc_pages+0x66>
c0104827:	a1 44 80 12 c0       	mov    0xc0128044,%eax
c010482c:	85 c0                	test   %eax,%eax
c010482e:	74 1e                	je     c010484e <alloc_pages+0x66>
            break;

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
c0104830:	8b 55 08             	mov    0x8(%ebp),%edx
c0104833:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c0104838:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010483f:	00 
c0104840:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104844:	89 04 24             	mov    %eax,(%esp)
c0104847:	e8 ff 19 00 00       	call   c010624b <swap_out>
    {
c010484c:	eb a7                	jmp    c01047f5 <alloc_pages+0xd>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010484e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104851:	89 ec                	mov    %ebp,%esp
c0104853:	5d                   	pop    %ebp
c0104854:	c3                   	ret    

c0104855 <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
c0104855:	55                   	push   %ebp
c0104856:	89 e5                	mov    %esp,%ebp
c0104858:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010485b:	e8 be fd ff ff       	call   c010461e <__intr_save>
c0104860:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104863:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c0104868:	8b 40 10             	mov    0x10(%eax),%eax
c010486b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010486e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104872:	8b 55 08             	mov    0x8(%ebp),%edx
c0104875:	89 14 24             	mov    %edx,(%esp)
c0104878:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487d:	89 04 24             	mov    %eax,(%esp)
c0104880:	e8 c5 fd ff ff       	call   c010464a <__intr_restore>
}
c0104885:	90                   	nop
c0104886:	89 ec                	mov    %ebp,%esp
c0104888:	5d                   	pop    %ebp
c0104889:	c3                   	ret    

c010488a <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
c010488a:	55                   	push   %ebp
c010488b:	89 e5                	mov    %esp,%ebp
c010488d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104890:	e8 89 fd ff ff       	call   c010461e <__intr_save>
c0104895:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104898:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c010489d:	8b 40 14             	mov    0x14(%eax),%eax
c01048a0:	ff d0                	call   *%eax
c01048a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01048a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a8:	89 04 24             	mov    %eax,(%esp)
c01048ab:	e8 9a fd ff ff       	call   c010464a <__intr_restore>
    return ret;
c01048b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01048b3:	89 ec                	mov    %ebp,%esp
c01048b5:	5d                   	pop    %ebp
c01048b6:	c3                   	ret    

c01048b7 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
c01048b7:	55                   	push   %ebp
c01048b8:	89 e5                	mov    %esp,%ebp
c01048ba:	57                   	push   %edi
c01048bb:	56                   	push   %esi
c01048bc:	53                   	push   %ebx
c01048bd:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01048c3:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01048ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01048d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01048d8:	c7 04 24 37 a5 10 c0 	movl   $0xc010a537,(%esp)
c01048df:	e8 81 ba ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
c01048e4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01048eb:	e9 0c 01 00 00       	jmp    c01049fc <page_init+0x145>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01048f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048f6:	89 d0                	mov    %edx,%eax
c01048f8:	c1 e0 02             	shl    $0x2,%eax
c01048fb:	01 d0                	add    %edx,%eax
c01048fd:	c1 e0 02             	shl    $0x2,%eax
c0104900:	01 c8                	add    %ecx,%eax
c0104902:	8b 50 08             	mov    0x8(%eax),%edx
c0104905:	8b 40 04             	mov    0x4(%eax),%eax
c0104908:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010490b:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010490e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104911:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104914:	89 d0                	mov    %edx,%eax
c0104916:	c1 e0 02             	shl    $0x2,%eax
c0104919:	01 d0                	add    %edx,%eax
c010491b:	c1 e0 02             	shl    $0x2,%eax
c010491e:	01 c8                	add    %ecx,%eax
c0104920:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104923:	8b 58 10             	mov    0x10(%eax),%ebx
c0104926:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104929:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010492c:	01 c8                	add    %ecx,%eax
c010492e:	11 da                	adc    %ebx,%edx
c0104930:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104933:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104936:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104939:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010493c:	89 d0                	mov    %edx,%eax
c010493e:	c1 e0 02             	shl    $0x2,%eax
c0104941:	01 d0                	add    %edx,%eax
c0104943:	c1 e0 02             	shl    $0x2,%eax
c0104946:	01 c8                	add    %ecx,%eax
c0104948:	83 c0 14             	add    $0x14,%eax
c010494b:	8b 00                	mov    (%eax),%eax
c010494d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104953:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104956:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104959:	83 c0 ff             	add    $0xffffffff,%eax
c010495c:	83 d2 ff             	adc    $0xffffffff,%edx
c010495f:	89 c6                	mov    %eax,%esi
c0104961:	89 d7                	mov    %edx,%edi
c0104963:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104966:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104969:	89 d0                	mov    %edx,%eax
c010496b:	c1 e0 02             	shl    $0x2,%eax
c010496e:	01 d0                	add    %edx,%eax
c0104970:	c1 e0 02             	shl    $0x2,%eax
c0104973:	01 c8                	add    %ecx,%eax
c0104975:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104978:	8b 58 10             	mov    0x10(%eax),%ebx
c010497b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104981:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104985:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104989:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010498d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104990:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104993:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104997:	89 54 24 10          	mov    %edx,0x10(%esp)
c010499b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010499f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01049a3:	c7 04 24 44 a5 10 c0 	movl   $0xc010a544,(%esp)
c01049aa:	e8 b6 b9 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
c01049af:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049b5:	89 d0                	mov    %edx,%eax
c01049b7:	c1 e0 02             	shl    $0x2,%eax
c01049ba:	01 d0                	add    %edx,%eax
c01049bc:	c1 e0 02             	shl    $0x2,%eax
c01049bf:	01 c8                	add    %ecx,%eax
c01049c1:	83 c0 14             	add    $0x14,%eax
c01049c4:	8b 00                	mov    (%eax),%eax
c01049c6:	83 f8 01             	cmp    $0x1,%eax
c01049c9:	75 2e                	jne    c01049f9 <page_init+0x142>
        {
            if (maxpa < end && begin < KMEMSIZE)
c01049cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01049ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049d1:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01049d4:	89 d0                	mov    %edx,%eax
c01049d6:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c01049d9:	73 1e                	jae    c01049f9 <page_init+0x142>
c01049db:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01049e0:	b8 00 00 00 00       	mov    $0x0,%eax
c01049e5:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c01049e8:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c01049eb:	72 0c                	jb     c01049f9 <page_init+0x142>
            {
                maxpa = end;
c01049ed:	8b 45 98             	mov    -0x68(%ebp),%eax
c01049f0:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01049f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01049f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
c01049f9:	ff 45 dc             	incl   -0x24(%ebp)
c01049fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01049ff:	8b 00                	mov    (%eax),%eax
c0104a01:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104a04:	0f 8c e6 fe ff ff    	jl     c01048f0 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE)
c0104a0a:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104a0f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104a14:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104a17:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104a1a:	73 0e                	jae    c0104a2a <page_init+0x173>
    {
        maxpa = KMEMSIZE;
c0104a1c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104a23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a30:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104a34:	c1 ea 0c             	shr    $0xc,%edx
c0104a37:	a3 a4 7f 12 c0       	mov    %eax,0xc0127fa4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104a3c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104a43:	b8 14 81 12 c0       	mov    $0xc0128114,%eax
c0104a48:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104a4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a4e:	01 d0                	add    %edx,%eax
c0104a50:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104a53:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104a56:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a5b:	f7 75 c0             	divl   -0x40(%ebp)
c0104a5e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104a61:	29 d0                	sub    %edx,%eax
c0104a63:	a3 a0 7f 12 c0       	mov    %eax,0xc0127fa0

    for (i = 0; i < npage; i++)
c0104a68:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a6f:	eb 28                	jmp    c0104a99 <page_init+0x1e2>
    {
        SetPageReserved(pages + i);
c0104a71:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c0104a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a7a:	c1 e0 05             	shl    $0x5,%eax
c0104a7d:	01 d0                	add    %edx,%eax
c0104a7f:	83 c0 04             	add    $0x4,%eax
c0104a82:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104a89:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a8c:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104a8f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104a92:	0f ab 10             	bts    %edx,(%eax)
}
c0104a95:	90                   	nop
    for (i = 0; i < npage; i++)
c0104a96:	ff 45 dc             	incl   -0x24(%ebp)
c0104a99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a9c:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0104aa1:	39 c2                	cmp    %eax,%edx
c0104aa3:	72 cc                	jb     c0104a71 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104aa5:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0104aaa:	c1 e0 05             	shl    $0x5,%eax
c0104aad:	89 c2                	mov    %eax,%edx
c0104aaf:	a1 a0 7f 12 c0       	mov    0xc0127fa0,%eax
c0104ab4:	01 d0                	add    %edx,%eax
c0104ab6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104ab9:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104ac0:	77 23                	ja     c0104ae5 <page_init+0x22e>
c0104ac2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ac5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ac9:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c0104ad0:	c0 
c0104ad1:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104ad8:	00 
c0104ad9:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104ae0:	e8 05 c2 ff ff       	call   c0100cea <__panic>
c0104ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ae8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104aed:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
c0104af0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104af7:	e9 53 01 00 00       	jmp    c0104c4f <page_init+0x398>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104afc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104aff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b02:	89 d0                	mov    %edx,%eax
c0104b04:	c1 e0 02             	shl    $0x2,%eax
c0104b07:	01 d0                	add    %edx,%eax
c0104b09:	c1 e0 02             	shl    $0x2,%eax
c0104b0c:	01 c8                	add    %ecx,%eax
c0104b0e:	8b 50 08             	mov    0x8(%eax),%edx
c0104b11:	8b 40 04             	mov    0x4(%eax),%eax
c0104b14:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b17:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104b1a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104b1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b20:	89 d0                	mov    %edx,%eax
c0104b22:	c1 e0 02             	shl    $0x2,%eax
c0104b25:	01 d0                	add    %edx,%eax
c0104b27:	c1 e0 02             	shl    $0x2,%eax
c0104b2a:	01 c8                	add    %ecx,%eax
c0104b2c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104b2f:	8b 58 10             	mov    0x10(%eax),%ebx
c0104b32:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b38:	01 c8                	add    %ecx,%eax
c0104b3a:	11 da                	adc    %ebx,%edx
c0104b3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b3f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
c0104b42:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104b45:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b48:	89 d0                	mov    %edx,%eax
c0104b4a:	c1 e0 02             	shl    $0x2,%eax
c0104b4d:	01 d0                	add    %edx,%eax
c0104b4f:	c1 e0 02             	shl    $0x2,%eax
c0104b52:	01 c8                	add    %ecx,%eax
c0104b54:	83 c0 14             	add    $0x14,%eax
c0104b57:	8b 00                	mov    (%eax),%eax
c0104b59:	83 f8 01             	cmp    $0x1,%eax
c0104b5c:	0f 85 ea 00 00 00    	jne    c0104c4c <page_init+0x395>
        {
            if (begin < freemem)
c0104b62:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b65:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b6a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104b6d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104b70:	19 d1                	sbb    %edx,%ecx
c0104b72:	73 0d                	jae    c0104b81 <page_init+0x2ca>
            {
                begin = freemem;
c0104b74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b77:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b7a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
c0104b81:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104b86:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b8b:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104b8e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104b91:	73 0e                	jae    c0104ba1 <page_init+0x2ea>
            {
                end = KMEMSIZE;
c0104b93:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104b9a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
c0104ba1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ba4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ba7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104baa:	89 d0                	mov    %edx,%eax
c0104bac:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104baf:	0f 83 97 00 00 00    	jae    c0104c4c <page_init+0x395>
            {
                begin = ROUNDUP(begin, PGSIZE);
c0104bb5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0104bbc:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104bbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bc2:	01 d0                	add    %edx,%eax
c0104bc4:	48                   	dec    %eax
c0104bc5:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104bc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104bcb:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bd0:	f7 75 b0             	divl   -0x50(%ebp)
c0104bd3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104bd6:	29 d0                	sub    %edx,%eax
c0104bd8:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bdd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104be0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104be3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104be6:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104be9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104bec:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bf1:	89 c7                	mov    %eax,%edi
c0104bf3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104bf9:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104bfc:	89 d0                	mov    %edx,%eax
c0104bfe:	83 e0 00             	and    $0x0,%eax
c0104c01:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104c04:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104c07:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104c0a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104c0d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end)
c0104c10:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c16:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104c19:	89 d0                	mov    %edx,%eax
c0104c1b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104c1e:	73 2c                	jae    c0104c4c <page_init+0x395>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104c20:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c23:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104c26:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104c29:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104c2c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104c30:	c1 ea 0c             	shr    $0xc,%edx
c0104c33:	89 c3                	mov    %eax,%ebx
c0104c35:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c38:	89 04 24             	mov    %eax,(%esp)
c0104c3b:	e8 54 f8 ff ff       	call   c0104494 <pa2page>
c0104c40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104c44:	89 04 24             	mov    %eax,(%esp)
c0104c47:	e8 7a fb ff ff       	call   c01047c6 <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
c0104c4c:	ff 45 dc             	incl   -0x24(%ebp)
c0104c4f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c52:	8b 00                	mov    (%eax),%eax
c0104c54:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104c57:	0f 8c 9f fe ff ff    	jl     c0104afc <page_init+0x245>
                }
            }
        }
    }
}
c0104c5d:	90                   	nop
c0104c5e:	90                   	nop
c0104c5f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104c65:	5b                   	pop    %ebx
c0104c66:	5e                   	pop    %esi
c0104c67:	5f                   	pop    %edi
c0104c68:	5d                   	pop    %ebp
c0104c69:	c3                   	ret    

c0104c6a <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
c0104c6a:	55                   	push   %ebp
c0104c6b:	89 e5                	mov    %esp,%ebp
c0104c6d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104c70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c73:	33 45 14             	xor    0x14(%ebp),%eax
c0104c76:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c7b:	85 c0                	test   %eax,%eax
c0104c7d:	74 24                	je     c0104ca3 <boot_map_segment+0x39>
c0104c7f:	c7 44 24 0c 82 a5 10 	movl   $0xc010a582,0xc(%esp)
c0104c86:	c0 
c0104c87:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0104c8e:	c0 
c0104c8f:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104c96:	00 
c0104c97:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104c9e:	e8 47 c0 ff ff       	call   c0100cea <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104ca3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104caa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cad:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104cb2:	89 c2                	mov    %eax,%edx
c0104cb4:	8b 45 10             	mov    0x10(%ebp),%eax
c0104cb7:	01 c2                	add    %eax,%edx
c0104cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cbc:	01 d0                	add    %edx,%eax
c0104cbe:	48                   	dec    %eax
c0104cbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cc5:	ba 00 00 00 00       	mov    $0x0,%edx
c0104cca:	f7 75 f0             	divl   -0x10(%ebp)
c0104ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cd0:	29 d0                	sub    %edx,%eax
c0104cd2:	c1 e8 0c             	shr    $0xc,%eax
c0104cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ce1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ce6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104ce9:	8b 45 14             	mov    0x14(%ebp),%eax
c0104cec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104cf7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c0104cfa:	eb 68                	jmp    c0104d64 <boot_map_segment+0xfa>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104cfc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104d03:	00 
c0104d04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d0e:	89 04 24             	mov    %eax,(%esp)
c0104d11:	e8 88 01 00 00       	call   c0104e9e <get_pte>
c0104d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104d19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104d1d:	75 24                	jne    c0104d43 <boot_map_segment+0xd9>
c0104d1f:	c7 44 24 0c ae a5 10 	movl   $0xc010a5ae,0xc(%esp)
c0104d26:	c0 
c0104d27:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0104d36:	00 
c0104d37:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104d3e:	e8 a7 bf ff ff       	call   c0100cea <__panic>
        *ptep = pa | PTE_P | perm;
c0104d43:	8b 45 14             	mov    0x14(%ebp),%eax
c0104d46:	0b 45 18             	or     0x18(%ebp),%eax
c0104d49:	83 c8 01             	or     $0x1,%eax
c0104d4c:	89 c2                	mov    %eax,%edx
c0104d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d51:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c0104d53:	ff 4d f4             	decl   -0xc(%ebp)
c0104d56:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104d5d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d68:	75 92                	jne    c0104cfc <boot_map_segment+0x92>
    }
}
c0104d6a:	90                   	nop
c0104d6b:	90                   	nop
c0104d6c:	89 ec                	mov    %ebp,%esp
c0104d6e:	5d                   	pop    %ebp
c0104d6f:	c3                   	ret    

c0104d70 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
c0104d70:	55                   	push   %ebp
c0104d71:	89 e5                	mov    %esp,%ebp
c0104d73:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104d76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d7d:	e8 66 fa ff ff       	call   c01047e8 <alloc_pages>
c0104d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
c0104d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d89:	75 1c                	jne    c0104da7 <boot_alloc_page+0x37>
    {
        panic("boot_alloc_page failed.\n");
c0104d8b:	c7 44 24 08 bb a5 10 	movl   $0xc010a5bb,0x8(%esp)
c0104d92:	c0 
c0104d93:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0104d9a:	00 
c0104d9b:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104da2:	e8 43 bf ff ff       	call   c0100cea <__panic>
    }
    return page2kva(p);
c0104da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104daa:	89 04 24             	mov    %eax,(%esp)
c0104dad:	e8 2a f7 ff ff       	call   c01044dc <page2kva>
}
c0104db2:	89 ec                	mov    %ebp,%esp
c0104db4:	5d                   	pop    %ebp
c0104db5:	c3                   	ret    

c0104db6 <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
c0104db6:	55                   	push   %ebp
c0104db7:	89 e5                	mov    %esp,%ebp
c0104db9:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104dbc:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0104dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dc4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104dcb:	77 23                	ja     c0104df0 <pmm_init+0x3a>
c0104dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104dd4:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c0104ddb:	c0 
c0104ddc:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104de3:	00 
c0104de4:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104deb:	e8 fa be ff ff       	call   c0100cea <__panic>
c0104df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df3:	05 00 00 00 40       	add    $0x40000000,%eax
c0104df8:	a3 a8 7f 12 c0       	mov    %eax,0xc0127fa8
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104dfd:	e8 8e f9 ff ff       	call   c0104790 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104e02:	e8 b0 fa ff ff       	call   c01048b7 <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104e07:	e8 ba 04 00 00       	call   c01052c6 <check_alloc_page>

    check_pgdir();
c0104e0c:	e8 d6 04 00 00       	call   c01052e7 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104e11:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0104e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e19:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104e20:	77 23                	ja     c0104e45 <pmm_init+0x8f>
c0104e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e25:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e29:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c0104e30:	c0 
c0104e31:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0104e38:	00 
c0104e39:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104e40:	e8 a5 be ff ff       	call   c0100cea <__panic>
c0104e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e48:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0104e4e:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0104e53:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104e58:	83 ca 03             	or     $0x3,%edx
c0104e5b:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104e5d:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0104e62:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104e69:	00 
c0104e6a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e71:	00 
c0104e72:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104e79:	38 
c0104e7a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104e81:	c0 
c0104e82:	89 04 24             	mov    %eax,(%esp)
c0104e85:	e8 e0 fd ff ff       	call   c0104c6a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104e8a:	e8 15 f8 ff ff       	call   c01046a4 <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104e8f:	e8 f1 0a 00 00       	call   c0105985 <check_boot_pgdir>

    print_pgdir();
c0104e94:	e8 6e 0f 00 00       	call   c0105e07 <print_pgdir>
}
c0104e99:	90                   	nop
c0104e9a:	89 ec                	mov    %ebp,%esp
c0104e9c:	5d                   	pop    %ebp
c0104e9d:	c3                   	ret    

c0104e9e <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
c0104e9e:	55                   	push   %ebp
c0104e9f:	89 e5                	mov    %esp,%ebp
c0104ea1:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ea7:	c1 e8 16             	shr    $0x16,%eax
c0104eaa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104eb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eb4:	01 d0                	add    %edx,%eax
c0104eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
c0104eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ebc:	8b 00                	mov    (%eax),%eax
c0104ebe:	83 e0 01             	and    $0x1,%eax
c0104ec1:	85 c0                	test   %eax,%eax
c0104ec3:	0f 85 af 00 00 00    	jne    c0104f78 <get_pte+0xda>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
c0104ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104ecd:	74 15                	je     c0104ee4 <get_pte+0x46>
c0104ecf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ed6:	e8 0d f9 ff ff       	call   c01047e8 <alloc_pages>
c0104edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ede:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ee2:	75 0a                	jne    c0104eee <get_pte+0x50>
        {
            return NULL;
c0104ee4:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ee9:	e9 e7 00 00 00       	jmp    c0104fd5 <get_pte+0x137>
        }
        set_page_ref(page, 1);
c0104eee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ef5:	00 
c0104ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef9:	89 04 24             	mov    %eax,(%esp)
c0104efc:	e8 e1 f6 ff ff       	call   c01045e2 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f04:	89 04 24             	mov    %eax,(%esp)
c0104f07:	e8 70 f5 ff ff       	call   c010447c <page2pa>
c0104f0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f12:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f18:	c1 e8 0c             	shr    $0xc,%eax
c0104f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f1e:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0104f23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104f26:	72 23                	jb     c0104f4b <get_pte+0xad>
c0104f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f2f:	c7 44 24 08 ac a4 10 	movl   $0xc010a4ac,0x8(%esp)
c0104f36:	c0 
c0104f37:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0104f3e:	00 
c0104f3f:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104f46:	e8 9f bd ff ff       	call   c0100cea <__panic>
c0104f4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f4e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f53:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104f5a:	00 
c0104f5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f62:	00 
c0104f63:	89 04 24             	mov    %eax,(%esp)
c0104f66:	e8 96 46 00 00       	call   c0109601 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f6e:	83 c8 07             	or     $0x7,%eax
c0104f71:	89 c2                	mov    %eax,%edx
c0104f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f76:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f7b:	8b 00                	mov    (%eax),%eax
c0104f7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f82:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f85:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f88:	c1 e8 0c             	shr    $0xc,%eax
c0104f8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f8e:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0104f93:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104f96:	72 23                	jb     c0104fbb <get_pte+0x11d>
c0104f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f9f:	c7 44 24 08 ac a4 10 	movl   $0xc010a4ac,0x8(%esp)
c0104fa6:	c0 
c0104fa7:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c0104fae:	00 
c0104faf:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0104fb6:	e8 2f bd ff ff       	call   c0100cea <__panic>
c0104fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fbe:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104fc3:	89 c2                	mov    %eax,%edx
c0104fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fc8:	c1 e8 0c             	shr    $0xc,%eax
c0104fcb:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104fd0:	c1 e0 02             	shl    $0x2,%eax
c0104fd3:	01 d0                	add    %edx,%eax
}
c0104fd5:	89 ec                	mov    %ebp,%esp
c0104fd7:	5d                   	pop    %ebp
c0104fd8:	c3                   	ret    

c0104fd9 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
c0104fd9:	55                   	push   %ebp
c0104fda:	89 e5                	mov    %esp,%ebp
c0104fdc:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104fdf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fe6:	00 
c0104fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fee:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ff1:	89 04 24             	mov    %eax,(%esp)
c0104ff4:	e8 a5 fe ff ff       	call   c0104e9e <get_pte>
c0104ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
c0104ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105000:	74 08                	je     c010500a <get_page+0x31>
    {
        *ptep_store = ptep;
c0105002:	8b 45 10             	mov    0x10(%ebp),%eax
c0105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105008:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
c010500a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010500e:	74 1b                	je     c010502b <get_page+0x52>
c0105010:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105013:	8b 00                	mov    (%eax),%eax
c0105015:	83 e0 01             	and    $0x1,%eax
c0105018:	85 c0                	test   %eax,%eax
c010501a:	74 0f                	je     c010502b <get_page+0x52>
    {
        return pte2page(*ptep);
c010501c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010501f:	8b 00                	mov    (%eax),%eax
c0105021:	89 04 24             	mov    %eax,(%esp)
c0105024:	e8 55 f5 ff ff       	call   c010457e <pte2page>
c0105029:	eb 05                	jmp    c0105030 <get_page+0x57>
    }
    return NULL;
c010502b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105030:	89 ec                	mov    %ebp,%esp
c0105032:	5d                   	pop    %ebp
c0105033:	c3                   	ret    

c0105034 <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
c0105034:	55                   	push   %ebp
c0105035:	89 e5                	mov    %esp,%ebp
c0105037:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P)
c010503a:	8b 45 10             	mov    0x10(%ebp),%eax
c010503d:	8b 00                	mov    (%eax),%eax
c010503f:	83 e0 01             	and    $0x1,%eax
c0105042:	85 c0                	test   %eax,%eax
c0105044:	74 4d                	je     c0105093 <page_remove_pte+0x5f>
    {
        struct Page *page = pte2page(*ptep);
c0105046:	8b 45 10             	mov    0x10(%ebp),%eax
c0105049:	8b 00                	mov    (%eax),%eax
c010504b:	89 04 24             	mov    %eax,(%esp)
c010504e:	e8 2b f5 ff ff       	call   c010457e <pte2page>
c0105053:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)
c0105056:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105059:	89 04 24             	mov    %eax,(%esp)
c010505c:	e8 a6 f5 ff ff       	call   c0104607 <page_ref_dec>
c0105061:	85 c0                	test   %eax,%eax
c0105063:	75 13                	jne    c0105078 <page_remove_pte+0x44>
        {
            free_page(page);
c0105065:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010506c:	00 
c010506d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105070:	89 04 24             	mov    %eax,(%esp)
c0105073:	e8 dd f7 ff ff       	call   c0104855 <free_pages>
        }
        *ptep = 0;
c0105078:	8b 45 10             	mov    0x10(%ebp),%eax
c010507b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105081:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105084:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105088:	8b 45 08             	mov    0x8(%ebp),%eax
c010508b:	89 04 24             	mov    %eax,(%esp)
c010508e:	e8 07 01 00 00       	call   c010519a <tlb_invalidate>
    }
}
c0105093:	90                   	nop
c0105094:	89 ec                	mov    %ebp,%esp
c0105096:	5d                   	pop    %ebp
c0105097:	c3                   	ret    

c0105098 <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
c0105098:	55                   	push   %ebp
c0105099:	89 e5                	mov    %esp,%ebp
c010509b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010509e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050a5:	00 
c01050a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b0:	89 04 24             	mov    %eax,(%esp)
c01050b3:	e8 e6 fd ff ff       	call   c0104e9e <get_pte>
c01050b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
c01050bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050bf:	74 19                	je     c01050da <page_remove+0x42>
    {
        page_remove_pte(pgdir, la, ptep);
c01050c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01050d2:	89 04 24             	mov    %eax,(%esp)
c01050d5:	e8 5a ff ff ff       	call   c0105034 <page_remove_pte>
    }
}
c01050da:	90                   	nop
c01050db:	89 ec                	mov    %ebp,%esp
c01050dd:	5d                   	pop    %ebp
c01050de:	c3                   	ret    

c01050df <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
c01050df:	55                   	push   %ebp
c01050e0:	89 e5                	mov    %esp,%ebp
c01050e2:	83 ec 28             	sub    $0x28,%esp
    // 找到la对应的pte
    pte_t *ptep = get_pte(pgdir, la, 1);
c01050e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01050ec:	00 
c01050ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01050f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f7:	89 04 24             	mov    %eax,(%esp)
c01050fa:	e8 9f fd ff ff       	call   c0104e9e <get_pte>
c01050ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
c0105102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105106:	75 0a                	jne    c0105112 <page_insert+0x33>
    {
        return -E_NO_MEM;
c0105108:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010510d:	e9 84 00 00 00       	jmp    c0105196 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105112:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105115:	89 04 24             	mov    %eax,(%esp)
c0105118:	e8 d3 f4 ff ff       	call   c01045f0 <page_ref_inc>
    // 如果原来有映射关系，先取消
    if (*ptep & PTE_P)
c010511d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105120:	8b 00                	mov    (%eax),%eax
c0105122:	83 e0 01             	and    $0x1,%eax
c0105125:	85 c0                	test   %eax,%eax
c0105127:	74 3e                	je     c0105167 <page_insert+0x88>
    {
        struct Page *p = pte2page(*ptep);
c0105129:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010512c:	8b 00                	mov    (%eax),%eax
c010512e:	89 04 24             	mov    %eax,(%esp)
c0105131:	e8 48 f4 ff ff       	call   c010457e <pte2page>
c0105136:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
c0105139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010513c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010513f:	75 0d                	jne    c010514e <page_insert+0x6f>
        {
            page_ref_dec(page);
c0105141:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105144:	89 04 24             	mov    %eax,(%esp)
c0105147:	e8 bb f4 ff ff       	call   c0104607 <page_ref_dec>
c010514c:	eb 19                	jmp    c0105167 <page_insert+0x88>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
c010514e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105151:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105155:	8b 45 10             	mov    0x10(%ebp),%eax
c0105158:	89 44 24 04          	mov    %eax,0x4(%esp)
c010515c:	8b 45 08             	mov    0x8(%ebp),%eax
c010515f:	89 04 24             	mov    %eax,(%esp)
c0105162:	e8 cd fe ff ff       	call   c0105034 <page_remove_pte>
        }
    }
    // 再重新设置
    *ptep = page2pa(page) | PTE_P | perm;
c0105167:	8b 45 0c             	mov    0xc(%ebp),%eax
c010516a:	89 04 24             	mov    %eax,(%esp)
c010516d:	e8 0a f3 ff ff       	call   c010447c <page2pa>
c0105172:	0b 45 14             	or     0x14(%ebp),%eax
c0105175:	83 c8 01             	or     $0x1,%eax
c0105178:	89 c2                	mov    %eax,%edx
c010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010517d:	89 10                	mov    %edx,(%eax)
    // 标记TLB中的无效
    tlb_invalidate(pgdir, la);
c010517f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105186:	8b 45 08             	mov    0x8(%ebp),%eax
c0105189:	89 04 24             	mov    %eax,(%esp)
c010518c:	e8 09 00 00 00       	call   c010519a <tlb_invalidate>
    return 0;
c0105191:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105196:	89 ec                	mov    %ebp,%esp
c0105198:	5d                   	pop    %ebp
c0105199:	c3                   	ret    

c010519a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
c010519a:	55                   	push   %ebp
c010519b:	89 e5                	mov    %esp,%ebp
c010519d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01051a0:	0f 20 d8             	mov    %cr3,%eax
c01051a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01051a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
c01051a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051af:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01051b6:	77 23                	ja     c01051db <tlb_invalidate+0x41>
c01051b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051bf:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c01051c6:	c0 
c01051c7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c01051ce:	00 
c01051cf:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01051d6:	e8 0f bb ff ff       	call   c0100cea <__panic>
c01051db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051de:	05 00 00 00 40       	add    $0x40000000,%eax
c01051e3:	39 d0                	cmp    %edx,%eax
c01051e5:	75 0d                	jne    c01051f4 <tlb_invalidate+0x5a>
    {
        invlpg((void *)la);
c01051e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01051ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051f0:	0f 01 38             	invlpg (%eax)
}
c01051f3:	90                   	nop
    }
}
c01051f4:	90                   	nop
c01051f5:	89 ec                	mov    %ebp,%esp
c01051f7:	5d                   	pop    %ebp
c01051f8:	c3                   	ret    

c01051f9 <pgdir_alloc_page>:
// pgdir_alloc_page - call alloc_page & page_insert functions to
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm)
{
c01051f9:	55                   	push   %ebp
c01051fa:	89 e5                	mov    %esp,%ebp
c01051fc:	83 ec 28             	sub    $0x28,%esp
    // 分配一个新的物理页
    struct Page *page = alloc_page();
c01051ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105206:	e8 dd f5 ff ff       	call   c01047e8 <alloc_pages>
c010520b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL)
c010520e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105212:	0f 84 a7 00 00 00    	je     c01052bf <pgdir_alloc_page+0xc6>
    {
        // 建立la对应二级页表项(位于pgdir页表中)与page物理页的映射关系
        if (page_insert(pgdir, page, la, perm) != 0)
c0105218:	8b 45 10             	mov    0x10(%ebp),%eax
c010521b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010521f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105222:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105226:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105229:	89 44 24 04          	mov    %eax,0x4(%esp)
c010522d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105230:	89 04 24             	mov    %eax,(%esp)
c0105233:	e8 a7 fe ff ff       	call   c01050df <page_insert>
c0105238:	85 c0                	test   %eax,%eax
c010523a:	74 1a                	je     c0105256 <pgdir_alloc_page+0x5d>
        {
            free_page(page);
c010523c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105243:	00 
c0105244:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105247:	89 04 24             	mov    %eax,(%esp)
c010524a:	e8 06 f6 ff ff       	call   c0104855 <free_pages>
            return NULL;
c010524f:	b8 00 00 00 00       	mov    $0x0,%eax
c0105254:	eb 6c                	jmp    c01052c2 <pgdir_alloc_page+0xc9>
        }
        // 如果启用了swap交换分区
        if (swap_init_ok)
c0105256:	a1 44 80 12 c0       	mov    0xc0128044,%eax
c010525b:	85 c0                	test   %eax,%eax
c010525d:	74 60                	je     c01052bf <pgdir_alloc_page+0xc6>
        {
            // 将新映射的这一个page物理页设置为可交换的，并纳入全局swap交换管理器中管理
            swap_map_swappable(check_mm_struct, la, page, 0);
c010525f:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c0105264:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010526b:	00 
c010526c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010526f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105273:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105276:	89 54 24 04          	mov    %edx,0x4(%esp)
c010527a:	89 04 24             	mov    %eax,(%esp)
c010527d:	e8 79 0f 00 00       	call   c01061fb <swap_map_swappable>
            // 设置这一物理页关联的虚拟内存
            page->pra_vaddr = la;
c0105282:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105285:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105288:	89 50 1c             	mov    %edx,0x1c(%eax)
            // 校验这个新分配出来的物理页page是否引用次数正好为1
            assert(page_ref(page) == 1);
c010528b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010528e:	89 04 24             	mov    %eax,(%esp)
c0105291:	e8 42 f3 ff ff       	call   c01045d8 <page_ref>
c0105296:	83 f8 01             	cmp    $0x1,%eax
c0105299:	74 24                	je     c01052bf <pgdir_alloc_page+0xc6>
c010529b:	c7 44 24 0c d4 a5 10 	movl   $0xc010a5d4,0xc(%esp)
c01052a2:	c0 
c01052a3:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01052aa:	c0 
c01052ab:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01052b2:	00 
c01052b3:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01052ba:	e8 2b ba ff ff       	call   c0100cea <__panic>
        }
    }
    return page;
c01052bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01052c2:	89 ec                	mov    %ebp,%esp
c01052c4:	5d                   	pop    %ebp
c01052c5:	c3                   	ret    

c01052c6 <check_alloc_page>:

static void
check_alloc_page(void)
{
c01052c6:	55                   	push   %ebp
c01052c7:	89 e5                	mov    %esp,%ebp
c01052c9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01052cc:	a1 ac 7f 12 c0       	mov    0xc0127fac,%eax
c01052d1:	8b 40 18             	mov    0x18(%eax),%eax
c01052d4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01052d6:	c7 04 24 e8 a5 10 c0 	movl   $0xc010a5e8,(%esp)
c01052dd:	e8 83 b0 ff ff       	call   c0100365 <cprintf>
}
c01052e2:	90                   	nop
c01052e3:	89 ec                	mov    %ebp,%esp
c01052e5:	5d                   	pop    %ebp
c01052e6:	c3                   	ret    

c01052e7 <check_pgdir>:

static void
check_pgdir(void)
{
c01052e7:	55                   	push   %ebp
c01052e8:	89 e5                	mov    %esp,%ebp
c01052ea:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01052ed:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01052f2:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01052f7:	76 24                	jbe    c010531d <check_pgdir+0x36>
c01052f9:	c7 44 24 0c 07 a6 10 	movl   $0xc010a607,0xc(%esp)
c0105300:	c0 
c0105301:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105308:	c0 
c0105309:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105310:	00 
c0105311:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105318:	e8 cd b9 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010531d:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105322:	85 c0                	test   %eax,%eax
c0105324:	74 0e                	je     c0105334 <check_pgdir+0x4d>
c0105326:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010532b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105330:	85 c0                	test   %eax,%eax
c0105332:	74 24                	je     c0105358 <check_pgdir+0x71>
c0105334:	c7 44 24 0c 24 a6 10 	movl   $0xc010a624,0xc(%esp)
c010533b:	c0 
c010533c:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105343:	c0 
c0105344:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c010534b:	00 
c010534c:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105353:	e8 92 b9 ff ff       	call   c0100cea <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105358:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010535d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105364:	00 
c0105365:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010536c:	00 
c010536d:	89 04 24             	mov    %eax,(%esp)
c0105370:	e8 64 fc ff ff       	call   c0104fd9 <get_page>
c0105375:	85 c0                	test   %eax,%eax
c0105377:	74 24                	je     c010539d <check_pgdir+0xb6>
c0105379:	c7 44 24 0c 5c a6 10 	movl   $0xc010a65c,0xc(%esp)
c0105380:	c0 
c0105381:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105388:	c0 
c0105389:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105390:	00 
c0105391:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105398:	e8 4d b9 ff ff       	call   c0100cea <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010539d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053a4:	e8 3f f4 ff ff       	call   c01047e8 <alloc_pages>
c01053a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01053ac:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01053b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01053b8:	00 
c01053b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053c0:	00 
c01053c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053c4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053c8:	89 04 24             	mov    %eax,(%esp)
c01053cb:	e8 0f fd ff ff       	call   c01050df <page_insert>
c01053d0:	85 c0                	test   %eax,%eax
c01053d2:	74 24                	je     c01053f8 <check_pgdir+0x111>
c01053d4:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c01053db:	c0 
c01053dc:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01053e3:	c0 
c01053e4:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01053eb:	00 
c01053ec:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01053f3:	e8 f2 b8 ff ff       	call   c0100cea <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01053f8:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01053fd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105404:	00 
c0105405:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010540c:	00 
c010540d:	89 04 24             	mov    %eax,(%esp)
c0105410:	e8 89 fa ff ff       	call   c0104e9e <get_pte>
c0105415:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105418:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010541c:	75 24                	jne    c0105442 <check_pgdir+0x15b>
c010541e:	c7 44 24 0c b0 a6 10 	movl   $0xc010a6b0,0xc(%esp)
c0105425:	c0 
c0105426:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010542d:	c0 
c010542e:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105435:	00 
c0105436:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010543d:	e8 a8 b8 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c0105442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105445:	8b 00                	mov    (%eax),%eax
c0105447:	89 04 24             	mov    %eax,(%esp)
c010544a:	e8 2f f1 ff ff       	call   c010457e <pte2page>
c010544f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105452:	74 24                	je     c0105478 <check_pgdir+0x191>
c0105454:	c7 44 24 0c dd a6 10 	movl   $0xc010a6dd,0xc(%esp)
c010545b:	c0 
c010545c:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105463:	c0 
c0105464:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c010546b:	00 
c010546c:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105473:	e8 72 b8 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 1);
c0105478:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010547b:	89 04 24             	mov    %eax,(%esp)
c010547e:	e8 55 f1 ff ff       	call   c01045d8 <page_ref>
c0105483:	83 f8 01             	cmp    $0x1,%eax
c0105486:	74 24                	je     c01054ac <check_pgdir+0x1c5>
c0105488:	c7 44 24 0c f3 a6 10 	movl   $0xc010a6f3,0xc(%esp)
c010548f:	c0 
c0105490:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105497:	c0 
c0105498:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010549f:	00 
c01054a0:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01054a7:	e8 3e b8 ff ff       	call   c0100cea <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01054ac:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01054b1:	8b 00                	mov    (%eax),%eax
c01054b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054be:	c1 e8 0c             	shr    $0xc,%eax
c01054c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054c4:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01054c9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01054cc:	72 23                	jb     c01054f1 <check_pgdir+0x20a>
c01054ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054d5:	c7 44 24 08 ac a4 10 	movl   $0xc010a4ac,0x8(%esp)
c01054dc:	c0 
c01054dd:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01054e4:	00 
c01054e5:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01054ec:	e8 f9 b7 ff ff       	call   c0100cea <__panic>
c01054f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054f4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01054f9:	83 c0 04             	add    $0x4,%eax
c01054fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01054ff:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105504:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010550b:	00 
c010550c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105513:	00 
c0105514:	89 04 24             	mov    %eax,(%esp)
c0105517:	e8 82 f9 ff ff       	call   c0104e9e <get_pte>
c010551c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010551f:	74 24                	je     c0105545 <check_pgdir+0x25e>
c0105521:	c7 44 24 0c 08 a7 10 	movl   $0xc010a708,0xc(%esp)
c0105528:	c0 
c0105529:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105530:	c0 
c0105531:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105538:	00 
c0105539:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105540:	e8 a5 b7 ff ff       	call   c0100cea <__panic>

    p2 = alloc_page();
c0105545:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010554c:	e8 97 f2 ff ff       	call   c01047e8 <alloc_pages>
c0105551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105554:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105559:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105560:	00 
c0105561:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105568:	00 
c0105569:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010556c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105570:	89 04 24             	mov    %eax,(%esp)
c0105573:	e8 67 fb ff ff       	call   c01050df <page_insert>
c0105578:	85 c0                	test   %eax,%eax
c010557a:	74 24                	je     c01055a0 <check_pgdir+0x2b9>
c010557c:	c7 44 24 0c 30 a7 10 	movl   $0xc010a730,0xc(%esp)
c0105583:	c0 
c0105584:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010558b:	c0 
c010558c:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105593:	00 
c0105594:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010559b:	e8 4a b7 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01055a0:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01055a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055ac:	00 
c01055ad:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01055b4:	00 
c01055b5:	89 04 24             	mov    %eax,(%esp)
c01055b8:	e8 e1 f8 ff ff       	call   c0104e9e <get_pte>
c01055bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055c4:	75 24                	jne    c01055ea <check_pgdir+0x303>
c01055c6:	c7 44 24 0c 68 a7 10 	movl   $0xc010a768,0xc(%esp)
c01055cd:	c0 
c01055ce:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01055d5:	c0 
c01055d6:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c01055dd:	00 
c01055de:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01055e5:	e8 00 b7 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_U);
c01055ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055ed:	8b 00                	mov    (%eax),%eax
c01055ef:	83 e0 04             	and    $0x4,%eax
c01055f2:	85 c0                	test   %eax,%eax
c01055f4:	75 24                	jne    c010561a <check_pgdir+0x333>
c01055f6:	c7 44 24 0c 98 a7 10 	movl   $0xc010a798,0xc(%esp)
c01055fd:	c0 
c01055fe:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105605:	c0 
c0105606:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c010560d:	00 
c010560e:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105615:	e8 d0 b6 ff ff       	call   c0100cea <__panic>
    assert(*ptep & PTE_W);
c010561a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010561d:	8b 00                	mov    (%eax),%eax
c010561f:	83 e0 02             	and    $0x2,%eax
c0105622:	85 c0                	test   %eax,%eax
c0105624:	75 24                	jne    c010564a <check_pgdir+0x363>
c0105626:	c7 44 24 0c a6 a7 10 	movl   $0xc010a7a6,0xc(%esp)
c010562d:	c0 
c010562e:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105635:	c0 
c0105636:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c010563d:	00 
c010563e:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105645:	e8 a0 b6 ff ff       	call   c0100cea <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010564a:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010564f:	8b 00                	mov    (%eax),%eax
c0105651:	83 e0 04             	and    $0x4,%eax
c0105654:	85 c0                	test   %eax,%eax
c0105656:	75 24                	jne    c010567c <check_pgdir+0x395>
c0105658:	c7 44 24 0c b4 a7 10 	movl   $0xc010a7b4,0xc(%esp)
c010565f:	c0 
c0105660:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105667:	c0 
c0105668:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c010566f:	00 
c0105670:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105677:	e8 6e b6 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 1);
c010567c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010567f:	89 04 24             	mov    %eax,(%esp)
c0105682:	e8 51 ef ff ff       	call   c01045d8 <page_ref>
c0105687:	83 f8 01             	cmp    $0x1,%eax
c010568a:	74 24                	je     c01056b0 <check_pgdir+0x3c9>
c010568c:	c7 44 24 0c ca a7 10 	movl   $0xc010a7ca,0xc(%esp)
c0105693:	c0 
c0105694:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010569b:	c0 
c010569c:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c01056a3:	00 
c01056a4:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01056ab:	e8 3a b6 ff ff       	call   c0100cea <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01056b0:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01056b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01056bc:	00 
c01056bd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01056c4:	00 
c01056c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056cc:	89 04 24             	mov    %eax,(%esp)
c01056cf:	e8 0b fa ff ff       	call   c01050df <page_insert>
c01056d4:	85 c0                	test   %eax,%eax
c01056d6:	74 24                	je     c01056fc <check_pgdir+0x415>
c01056d8:	c7 44 24 0c dc a7 10 	movl   $0xc010a7dc,0xc(%esp)
c01056df:	c0 
c01056e0:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01056e7:	c0 
c01056e8:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c01056ef:	00 
c01056f0:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01056f7:	e8 ee b5 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p1) == 2);
c01056fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ff:	89 04 24             	mov    %eax,(%esp)
c0105702:	e8 d1 ee ff ff       	call   c01045d8 <page_ref>
c0105707:	83 f8 02             	cmp    $0x2,%eax
c010570a:	74 24                	je     c0105730 <check_pgdir+0x449>
c010570c:	c7 44 24 0c 08 a8 10 	movl   $0xc010a808,0xc(%esp)
c0105713:	c0 
c0105714:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010571b:	c0 
c010571c:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105723:	00 
c0105724:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010572b:	e8 ba b5 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c0105730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105733:	89 04 24             	mov    %eax,(%esp)
c0105736:	e8 9d ee ff ff       	call   c01045d8 <page_ref>
c010573b:	85 c0                	test   %eax,%eax
c010573d:	74 24                	je     c0105763 <check_pgdir+0x47c>
c010573f:	c7 44 24 0c 1a a8 10 	movl   $0xc010a81a,0xc(%esp)
c0105746:	c0 
c0105747:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010574e:	c0 
c010574f:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105756:	00 
c0105757:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010575e:	e8 87 b5 ff ff       	call   c0100cea <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105763:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105768:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010576f:	00 
c0105770:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105777:	00 
c0105778:	89 04 24             	mov    %eax,(%esp)
c010577b:	e8 1e f7 ff ff       	call   c0104e9e <get_pte>
c0105780:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105783:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105787:	75 24                	jne    c01057ad <check_pgdir+0x4c6>
c0105789:	c7 44 24 0c 68 a7 10 	movl   $0xc010a768,0xc(%esp)
c0105790:	c0 
c0105791:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105798:	c0 
c0105799:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c01057a0:	00 
c01057a1:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01057a8:	e8 3d b5 ff ff       	call   c0100cea <__panic>
    assert(pte2page(*ptep) == p1);
c01057ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057b0:	8b 00                	mov    (%eax),%eax
c01057b2:	89 04 24             	mov    %eax,(%esp)
c01057b5:	e8 c4 ed ff ff       	call   c010457e <pte2page>
c01057ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01057bd:	74 24                	je     c01057e3 <check_pgdir+0x4fc>
c01057bf:	c7 44 24 0c dd a6 10 	movl   $0xc010a6dd,0xc(%esp)
c01057c6:	c0 
c01057c7:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01057ce:	c0 
c01057cf:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c01057d6:	00 
c01057d7:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01057de:	e8 07 b5 ff ff       	call   c0100cea <__panic>
    assert((*ptep & PTE_U) == 0);
c01057e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057e6:	8b 00                	mov    (%eax),%eax
c01057e8:	83 e0 04             	and    $0x4,%eax
c01057eb:	85 c0                	test   %eax,%eax
c01057ed:	74 24                	je     c0105813 <check_pgdir+0x52c>
c01057ef:	c7 44 24 0c 2c a8 10 	movl   $0xc010a82c,0xc(%esp)
c01057f6:	c0 
c01057f7:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01057fe:	c0 
c01057ff:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105806:	00 
c0105807:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010580e:	e8 d7 b4 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, 0x0);
c0105813:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105818:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010581f:	00 
c0105820:	89 04 24             	mov    %eax,(%esp)
c0105823:	e8 70 f8 ff ff       	call   c0105098 <page_remove>
    assert(page_ref(p1) == 1);
c0105828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010582b:	89 04 24             	mov    %eax,(%esp)
c010582e:	e8 a5 ed ff ff       	call   c01045d8 <page_ref>
c0105833:	83 f8 01             	cmp    $0x1,%eax
c0105836:	74 24                	je     c010585c <check_pgdir+0x575>
c0105838:	c7 44 24 0c f3 a6 10 	movl   $0xc010a6f3,0xc(%esp)
c010583f:	c0 
c0105840:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105847:	c0 
c0105848:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c010584f:	00 
c0105850:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105857:	e8 8e b4 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c010585c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010585f:	89 04 24             	mov    %eax,(%esp)
c0105862:	e8 71 ed ff ff       	call   c01045d8 <page_ref>
c0105867:	85 c0                	test   %eax,%eax
c0105869:	74 24                	je     c010588f <check_pgdir+0x5a8>
c010586b:	c7 44 24 0c 1a a8 10 	movl   $0xc010a81a,0xc(%esp)
c0105872:	c0 
c0105873:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010587a:	c0 
c010587b:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105882:	00 
c0105883:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010588a:	e8 5b b4 ff ff       	call   c0100cea <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010588f:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105894:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010589b:	00 
c010589c:	89 04 24             	mov    %eax,(%esp)
c010589f:	e8 f4 f7 ff ff       	call   c0105098 <page_remove>
    assert(page_ref(p1) == 0);
c01058a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a7:	89 04 24             	mov    %eax,(%esp)
c01058aa:	e8 29 ed ff ff       	call   c01045d8 <page_ref>
c01058af:	85 c0                	test   %eax,%eax
c01058b1:	74 24                	je     c01058d7 <check_pgdir+0x5f0>
c01058b3:	c7 44 24 0c 41 a8 10 	movl   $0xc010a841,0xc(%esp)
c01058ba:	c0 
c01058bb:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01058c2:	c0 
c01058c3:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c01058ca:	00 
c01058cb:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01058d2:	e8 13 b4 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p2) == 0);
c01058d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058da:	89 04 24             	mov    %eax,(%esp)
c01058dd:	e8 f6 ec ff ff       	call   c01045d8 <page_ref>
c01058e2:	85 c0                	test   %eax,%eax
c01058e4:	74 24                	je     c010590a <check_pgdir+0x623>
c01058e6:	c7 44 24 0c 1a a8 10 	movl   $0xc010a81a,0xc(%esp)
c01058ed:	c0 
c01058ee:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c01058f5:	c0 
c01058f6:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c01058fd:	00 
c01058fe:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105905:	e8 e0 b3 ff ff       	call   c0100cea <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010590a:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010590f:	8b 00                	mov    (%eax),%eax
c0105911:	89 04 24             	mov    %eax,(%esp)
c0105914:	e8 a5 ec ff ff       	call   c01045be <pde2page>
c0105919:	89 04 24             	mov    %eax,(%esp)
c010591c:	e8 b7 ec ff ff       	call   c01045d8 <page_ref>
c0105921:	83 f8 01             	cmp    $0x1,%eax
c0105924:	74 24                	je     c010594a <check_pgdir+0x663>
c0105926:	c7 44 24 0c 54 a8 10 	movl   $0xc010a854,0xc(%esp)
c010592d:	c0 
c010592e:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105935:	c0 
c0105936:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c010593d:	00 
c010593e:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105945:	e8 a0 b3 ff ff       	call   c0100cea <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010594a:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	89 04 24             	mov    %eax,(%esp)
c0105954:	e8 65 ec ff ff       	call   c01045be <pde2page>
c0105959:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105960:	00 
c0105961:	89 04 24             	mov    %eax,(%esp)
c0105964:	e8 ec ee ff ff       	call   c0104855 <free_pages>
    boot_pgdir[0] = 0;
c0105969:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c010596e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105974:	c7 04 24 7b a8 10 c0 	movl   $0xc010a87b,(%esp)
c010597b:	e8 e5 a9 ff ff       	call   c0100365 <cprintf>
}
c0105980:	90                   	nop
c0105981:	89 ec                	mov    %ebp,%esp
c0105983:	5d                   	pop    %ebp
c0105984:	c3                   	ret    

c0105985 <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
c0105985:	55                   	push   %ebp
c0105986:	89 e5                	mov    %esp,%ebp
c0105988:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
c010598b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105992:	e9 ca 00 00 00       	jmp    c0105a61 <check_boot_pgdir+0xdc>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010599a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010599d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059a0:	c1 e8 0c             	shr    $0xc,%eax
c01059a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01059a6:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01059ab:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01059ae:	72 23                	jb     c01059d3 <check_boot_pgdir+0x4e>
c01059b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059b7:	c7 44 24 08 ac a4 10 	movl   $0xc010a4ac,0x8(%esp)
c01059be:	c0 
c01059bf:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c01059c6:	00 
c01059c7:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c01059ce:	e8 17 b3 ff ff       	call   c0100cea <__panic>
c01059d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059d6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01059db:	89 c2                	mov    %eax,%edx
c01059dd:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c01059e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059e9:	00 
c01059ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ee:	89 04 24             	mov    %eax,(%esp)
c01059f1:	e8 a8 f4 ff ff       	call   c0104e9e <get_pte>
c01059f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01059f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059fd:	75 24                	jne    c0105a23 <check_boot_pgdir+0x9e>
c01059ff:	c7 44 24 0c 98 a8 10 	movl   $0xc010a898,0xc(%esp)
c0105a06:	c0 
c0105a07:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105a0e:	c0 
c0105a0f:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c0105a16:	00 
c0105a17:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105a1e:	e8 c7 b2 ff ff       	call   c0100cea <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105a23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a26:	8b 00                	mov    (%eax),%eax
c0105a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a2d:	89 c2                	mov    %eax,%edx
c0105a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a32:	39 c2                	cmp    %eax,%edx
c0105a34:	74 24                	je     c0105a5a <check_boot_pgdir+0xd5>
c0105a36:	c7 44 24 0c d5 a8 10 	movl   $0xc010a8d5,0xc(%esp)
c0105a3d:	c0 
c0105a3e:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105a45:	c0 
c0105a46:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
c0105a4d:	00 
c0105a4e:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105a55:	e8 90 b2 ff ff       	call   c0100cea <__panic>
    for (i = 0; i < npage; i += PGSIZE)
c0105a5a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a64:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0105a69:	39 c2                	cmp    %eax,%edx
c0105a6b:	0f 82 26 ff ff ff    	jb     c0105997 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105a71:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105a76:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105a7b:	8b 00                	mov    (%eax),%eax
c0105a7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a82:	89 c2                	mov    %eax,%edx
c0105a84:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a8c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105a93:	77 23                	ja     c0105ab8 <check_boot_pgdir+0x133>
c0105a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a9c:	c7 44 24 08 d0 a4 10 	movl   $0xc010a4d0,0x8(%esp)
c0105aa3:	c0 
c0105aa4:	c7 44 24 04 72 02 00 	movl   $0x272,0x4(%esp)
c0105aab:	00 
c0105aac:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105ab3:	e8 32 b2 ff ff       	call   c0100cea <__panic>
c0105ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105abb:	05 00 00 00 40       	add    $0x40000000,%eax
c0105ac0:	39 d0                	cmp    %edx,%eax
c0105ac2:	74 24                	je     c0105ae8 <check_boot_pgdir+0x163>
c0105ac4:	c7 44 24 0c ec a8 10 	movl   $0xc010a8ec,0xc(%esp)
c0105acb:	c0 
c0105acc:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105ad3:	c0 
c0105ad4:	c7 44 24 04 72 02 00 	movl   $0x272,0x4(%esp)
c0105adb:	00 
c0105adc:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105ae3:	e8 02 b2 ff ff       	call   c0100cea <__panic>

    assert(boot_pgdir[0] == 0);
c0105ae8:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105aed:	8b 00                	mov    (%eax),%eax
c0105aef:	85 c0                	test   %eax,%eax
c0105af1:	74 24                	je     c0105b17 <check_boot_pgdir+0x192>
c0105af3:	c7 44 24 0c 20 a9 10 	movl   $0xc010a920,0xc(%esp)
c0105afa:	c0 
c0105afb:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105b02:	c0 
c0105b03:	c7 44 24 04 74 02 00 	movl   $0x274,0x4(%esp)
c0105b0a:	00 
c0105b0b:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105b12:	e8 d3 b1 ff ff       	call   c0100cea <__panic>

    struct Page *p;
    p = alloc_page();
c0105b17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b1e:	e8 c5 ec ff ff       	call   c01047e8 <alloc_pages>
c0105b23:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105b26:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105b2b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105b32:	00 
c0105b33:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105b3a:	00 
c0105b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b3e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b42:	89 04 24             	mov    %eax,(%esp)
c0105b45:	e8 95 f5 ff ff       	call   c01050df <page_insert>
c0105b4a:	85 c0                	test   %eax,%eax
c0105b4c:	74 24                	je     c0105b72 <check_boot_pgdir+0x1ed>
c0105b4e:	c7 44 24 0c 34 a9 10 	movl   $0xc010a934,0xc(%esp)
c0105b55:	c0 
c0105b56:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105b5d:	c0 
c0105b5e:	c7 44 24 04 78 02 00 	movl   $0x278,0x4(%esp)
c0105b65:	00 
c0105b66:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105b6d:	e8 78 b1 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 1);
c0105b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b75:	89 04 24             	mov    %eax,(%esp)
c0105b78:	e8 5b ea ff ff       	call   c01045d8 <page_ref>
c0105b7d:	83 f8 01             	cmp    $0x1,%eax
c0105b80:	74 24                	je     c0105ba6 <check_boot_pgdir+0x221>
c0105b82:	c7 44 24 0c 62 a9 10 	movl   $0xc010a962,0xc(%esp)
c0105b89:	c0 
c0105b8a:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105b91:	c0 
c0105b92:	c7 44 24 04 79 02 00 	movl   $0x279,0x4(%esp)
c0105b99:	00 
c0105b9a:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105ba1:	e8 44 b1 ff ff       	call   c0100cea <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105ba6:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105bab:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105bb2:	00 
c0105bb3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105bba:	00 
c0105bbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105bbe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105bc2:	89 04 24             	mov    %eax,(%esp)
c0105bc5:	e8 15 f5 ff ff       	call   c01050df <page_insert>
c0105bca:	85 c0                	test   %eax,%eax
c0105bcc:	74 24                	je     c0105bf2 <check_boot_pgdir+0x26d>
c0105bce:	c7 44 24 0c 74 a9 10 	movl   $0xc010a974,0xc(%esp)
c0105bd5:	c0 
c0105bd6:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105bdd:	c0 
c0105bde:	c7 44 24 04 7a 02 00 	movl   $0x27a,0x4(%esp)
c0105be5:	00 
c0105be6:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105bed:	e8 f8 b0 ff ff       	call   c0100cea <__panic>
    assert(page_ref(p) == 2);
c0105bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bf5:	89 04 24             	mov    %eax,(%esp)
c0105bf8:	e8 db e9 ff ff       	call   c01045d8 <page_ref>
c0105bfd:	83 f8 02             	cmp    $0x2,%eax
c0105c00:	74 24                	je     c0105c26 <check_boot_pgdir+0x2a1>
c0105c02:	c7 44 24 0c ab a9 10 	movl   $0xc010a9ab,0xc(%esp)
c0105c09:	c0 
c0105c0a:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105c11:	c0 
c0105c12:	c7 44 24 04 7b 02 00 	movl   $0x27b,0x4(%esp)
c0105c19:	00 
c0105c1a:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105c21:	e8 c4 b0 ff ff       	call   c0100cea <__panic>

    const char *str = "ucore: Hello world!!";
c0105c26:	c7 45 e8 bc a9 10 c0 	movl   $0xc010a9bc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c34:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c3b:	e8 f1 36 00 00       	call   c0109331 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105c40:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105c47:	00 
c0105c48:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c4f:	e8 55 37 00 00       	call   c01093a9 <strcmp>
c0105c54:	85 c0                	test   %eax,%eax
c0105c56:	74 24                	je     c0105c7c <check_boot_pgdir+0x2f7>
c0105c58:	c7 44 24 0c d4 a9 10 	movl   $0xc010a9d4,0xc(%esp)
c0105c5f:	c0 
c0105c60:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105c67:	c0 
c0105c68:	c7 44 24 04 7f 02 00 	movl   $0x27f,0x4(%esp)
c0105c6f:	00 
c0105c70:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105c77:	e8 6e b0 ff ff       	call   c0100cea <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c7f:	89 04 24             	mov    %eax,(%esp)
c0105c82:	e8 55 e8 ff ff       	call   c01044dc <page2kva>
c0105c87:	05 00 01 00 00       	add    $0x100,%eax
c0105c8c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105c8f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c96:	e8 3c 36 00 00       	call   c01092d7 <strlen>
c0105c9b:	85 c0                	test   %eax,%eax
c0105c9d:	74 24                	je     c0105cc3 <check_boot_pgdir+0x33e>
c0105c9f:	c7 44 24 0c 0c aa 10 	movl   $0xc010aa0c,0xc(%esp)
c0105ca6:	c0 
c0105ca7:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105cae:	c0 
c0105caf:	c7 44 24 04 82 02 00 	movl   $0x282,0x4(%esp)
c0105cb6:	00 
c0105cb7:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105cbe:	e8 27 b0 ff ff       	call   c0100cea <__panic>

    free_page(p);
c0105cc3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105cca:	00 
c0105ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cce:	89 04 24             	mov    %eax,(%esp)
c0105cd1:	e8 7f eb ff ff       	call   c0104855 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105cd6:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105cdb:	8b 00                	mov    (%eax),%eax
c0105cdd:	89 04 24             	mov    %eax,(%esp)
c0105ce0:	e8 d9 e8 ff ff       	call   c01045be <pde2page>
c0105ce5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105cec:	00 
c0105ced:	89 04 24             	mov    %eax,(%esp)
c0105cf0:	e8 60 eb ff ff       	call   c0104855 <free_pages>
    boot_pgdir[0] = 0;
c0105cf5:	a1 e0 49 12 c0       	mov    0xc01249e0,%eax
c0105cfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105d00:	c7 04 24 30 aa 10 c0 	movl   $0xc010aa30,(%esp)
c0105d07:	e8 59 a6 ff ff       	call   c0100365 <cprintf>
}
c0105d0c:	90                   	nop
c0105d0d:	89 ec                	mov    %ebp,%esp
c0105d0f:	5d                   	pop    %ebp
c0105d10:	c3                   	ret    

c0105d11 <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
c0105d11:	55                   	push   %ebp
c0105d12:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d17:	83 e0 04             	and    $0x4,%eax
c0105d1a:	85 c0                	test   %eax,%eax
c0105d1c:	74 04                	je     c0105d22 <perm2str+0x11>
c0105d1e:	b0 75                	mov    $0x75,%al
c0105d20:	eb 02                	jmp    c0105d24 <perm2str+0x13>
c0105d22:	b0 2d                	mov    $0x2d,%al
c0105d24:	a2 28 80 12 c0       	mov    %al,0xc0128028
    str[1] = 'r';
c0105d29:	c6 05 29 80 12 c0 72 	movb   $0x72,0xc0128029
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d33:	83 e0 02             	and    $0x2,%eax
c0105d36:	85 c0                	test   %eax,%eax
c0105d38:	74 04                	je     c0105d3e <perm2str+0x2d>
c0105d3a:	b0 77                	mov    $0x77,%al
c0105d3c:	eb 02                	jmp    c0105d40 <perm2str+0x2f>
c0105d3e:	b0 2d                	mov    $0x2d,%al
c0105d40:	a2 2a 80 12 c0       	mov    %al,0xc012802a
    str[3] = '\0';
c0105d45:	c6 05 2b 80 12 c0 00 	movb   $0x0,0xc012802b
    return str;
c0105d4c:	b8 28 80 12 c0       	mov    $0xc0128028,%eax
}
c0105d51:	5d                   	pop    %ebp
c0105d52:	c3                   	ret    

c0105d53 <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
c0105d53:	55                   	push   %ebp
c0105d54:	89 e5                	mov    %esp,%ebp
c0105d56:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
c0105d59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d5f:	72 0d                	jb     c0105d6e <get_pgtable_items+0x1b>
    {
        return 0;
c0105d61:	b8 00 00 00 00       	mov    $0x0,%eax
c0105d66:	e9 98 00 00 00       	jmp    c0105e03 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
c0105d6b:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
c0105d6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d71:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d74:	73 18                	jae    c0105d8e <get_pgtable_items+0x3b>
c0105d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d80:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d83:	01 d0                	add    %edx,%eax
c0105d85:	8b 00                	mov    (%eax),%eax
c0105d87:	83 e0 01             	and    $0x1,%eax
c0105d8a:	85 c0                	test   %eax,%eax
c0105d8c:	74 dd                	je     c0105d6b <get_pgtable_items+0x18>
    }
    if (start < right)
c0105d8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d91:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d94:	73 68                	jae    c0105dfe <get_pgtable_items+0xab>
    {
        if (left_store != NULL)
c0105d96:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105d9a:	74 08                	je     c0105da4 <get_pgtable_items+0x51>
        {
            *left_store = start;
c0105d9c:	8b 45 18             	mov    0x18(%ebp),%eax
c0105d9f:	8b 55 10             	mov    0x10(%ebp),%edx
c0105da2:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c0105da4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105da7:	8d 50 01             	lea    0x1(%eax),%edx
c0105daa:	89 55 10             	mov    %edx,0x10(%ebp)
c0105dad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105db4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105db7:	01 d0                	add    %edx,%eax
c0105db9:	8b 00                	mov    (%eax),%eax
c0105dbb:	83 e0 07             	and    $0x7,%eax
c0105dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c0105dc1:	eb 03                	jmp    c0105dc6 <get_pgtable_items+0x73>
        {
            start++;
c0105dc3:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c0105dc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105dcc:	73 1d                	jae    c0105deb <get_pgtable_items+0x98>
c0105dce:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105dd8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ddb:	01 d0                	add    %edx,%eax
c0105ddd:	8b 00                	mov    (%eax),%eax
c0105ddf:	83 e0 07             	and    $0x7,%eax
c0105de2:	89 c2                	mov    %eax,%edx
c0105de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105de7:	39 c2                	cmp    %eax,%edx
c0105de9:	74 d8                	je     c0105dc3 <get_pgtable_items+0x70>
        }
        if (right_store != NULL)
c0105deb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105def:	74 08                	je     c0105df9 <get_pgtable_items+0xa6>
        {
            *right_store = start;
c0105df1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105df4:	8b 55 10             	mov    0x10(%ebp),%edx
c0105df7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dfc:	eb 05                	jmp    c0105e03 <get_pgtable_items+0xb0>
    }
    return 0;
c0105dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e03:	89 ec                	mov    %ebp,%esp
c0105e05:	5d                   	pop    %ebp
c0105e06:	c3                   	ret    

c0105e07 <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
c0105e07:	55                   	push   %ebp
c0105e08:	89 e5                	mov    %esp,%ebp
c0105e0a:	57                   	push   %edi
c0105e0b:	56                   	push   %esi
c0105e0c:	53                   	push   %ebx
c0105e0d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105e10:	c7 04 24 50 aa 10 c0 	movl   $0xc010aa50,(%esp)
c0105e17:	e8 49 a5 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c0105e1c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c0105e23:	e9 f2 00 00 00       	jmp    c0105f1a <print_pgdir+0x113>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e2b:	89 04 24             	mov    %eax,(%esp)
c0105e2e:	e8 de fe ff ff       	call   c0105d11 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e36:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105e39:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e3b:	89 d6                	mov    %edx,%esi
c0105e3d:	c1 e6 16             	shl    $0x16,%esi
c0105e40:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e43:	89 d3                	mov    %edx,%ebx
c0105e45:	c1 e3 16             	shl    $0x16,%ebx
c0105e48:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e4b:	89 d1                	mov    %edx,%ecx
c0105e4d:	c1 e1 16             	shl    $0x16,%ecx
c0105e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e53:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105e56:	29 fa                	sub    %edi,%edx
c0105e58:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e5c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e60:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e64:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e68:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e6c:	c7 04 24 81 aa 10 c0 	movl   $0xc010aa81,(%esp)
c0105e73:	e8 ed a4 ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0105e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e7b:	c1 e0 0a             	shl    $0xa,%eax
c0105e7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0105e81:	eb 50                	jmp    c0105ed3 <print_pgdir+0xcc>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e86:	89 04 24             	mov    %eax,(%esp)
c0105e89:	e8 83 fe ff ff       	call   c0105d11 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105e8e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105e91:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105e94:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105e96:	89 d6                	mov    %edx,%esi
c0105e98:	c1 e6 0c             	shl    $0xc,%esi
c0105e9b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105e9e:	89 d3                	mov    %edx,%ebx
c0105ea0:	c1 e3 0c             	shl    $0xc,%ebx
c0105ea3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105ea6:	89 d1                	mov    %edx,%ecx
c0105ea8:	c1 e1 0c             	shl    $0xc,%ecx
c0105eab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105eae:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105eb1:	29 fa                	sub    %edi,%edx
c0105eb3:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105eb7:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105ebb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ebf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105ec3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ec7:	c7 04 24 a0 aa 10 c0 	movl   $0xc010aaa0,(%esp)
c0105ece:	e8 92 a4 ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0105ed3:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105edb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105ede:	89 d3                	mov    %edx,%ebx
c0105ee0:	c1 e3 0a             	shl    $0xa,%ebx
c0105ee3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105ee6:	89 d1                	mov    %edx,%ecx
c0105ee8:	c1 e1 0a             	shl    $0xa,%ecx
c0105eeb:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0105eee:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105ef2:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105ef5:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105ef9:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105efd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f01:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105f05:	89 0c 24             	mov    %ecx,(%esp)
c0105f08:	e8 46 fe ff ff       	call   c0105d53 <get_pgtable_items>
c0105f0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f14:	0f 85 69 ff ff ff    	jne    c0105e83 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c0105f1a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0105f1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f22:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105f25:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105f29:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0105f2c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105f30:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105f34:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f38:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105f3f:	00 
c0105f40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105f47:	e8 07 fe ff ff       	call   c0105d53 <get_pgtable_items>
c0105f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f53:	0f 85 cf fe ff ff    	jne    c0105e28 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105f59:	c7 04 24 c4 aa 10 c0 	movl   $0xc010aac4,(%esp)
c0105f60:	e8 00 a4 ff ff       	call   c0100365 <cprintf>
}
c0105f65:	90                   	nop
c0105f66:	83 c4 4c             	add    $0x4c,%esp
c0105f69:	5b                   	pop    %ebx
c0105f6a:	5e                   	pop    %esi
c0105f6b:	5f                   	pop    %edi
c0105f6c:	5d                   	pop    %ebp
c0105f6d:	c3                   	ret    

c0105f6e <kmalloc>:

void *
kmalloc(size_t n)
{
c0105f6e:	55                   	push   %ebp
c0105f6f:	89 e5                	mov    %esp,%ebp
c0105f71:	83 ec 28             	sub    $0x28,%esp
    void *ptr = NULL;
c0105f74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base = NULL;
c0105f7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024 * 0124);
c0105f82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f86:	74 09                	je     c0105f91 <kmalloc+0x23>
c0105f88:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105f8f:	76 24                	jbe    c0105fb5 <kmalloc+0x47>
c0105f91:	c7 44 24 0c f5 aa 10 	movl   $0xc010aaf5,0xc(%esp)
c0105f98:	c0 
c0105f99:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105fa0:	c0 
c0105fa1:	c7 44 24 04 d9 02 00 	movl   $0x2d9,0x4(%esp)
c0105fa8:	00 
c0105fa9:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105fb0:	e8 35 ad ff ff       	call   c0100cea <__panic>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
c0105fb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb8:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fbd:	c1 e8 0c             	shr    $0xc,%eax
c0105fc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fc6:	89 04 24             	mov    %eax,(%esp)
c0105fc9:	e8 1a e8 ff ff       	call   c01047e8 <alloc_pages>
c0105fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105fd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105fd5:	75 24                	jne    c0105ffb <kmalloc+0x8d>
c0105fd7:	c7 44 24 0c 0e ab 10 	movl   $0xc010ab0e,0xc(%esp)
c0105fde:	c0 
c0105fdf:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0105fe6:	c0 
c0105fe7:	c7 44 24 04 dc 02 00 	movl   $0x2dc,0x4(%esp)
c0105fee:	00 
c0105fef:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0105ff6:	e8 ef ac ff ff       	call   c0100cea <__panic>
    ptr = page2kva(base);
c0105ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ffe:	89 04 24             	mov    %eax,(%esp)
c0106001:	e8 d6 e4 ff ff       	call   c01044dc <page2kva>
c0106006:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0106009:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010600c:	89 ec                	mov    %ebp,%esp
c010600e:	5d                   	pop    %ebp
c010600f:	c3                   	ret    

c0106010 <kfree>:

void kfree(void *ptr, size_t n)
{
c0106010:	55                   	push   %ebp
c0106011:	89 e5                	mov    %esp,%ebp
c0106013:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024 * 0124);
c0106016:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010601a:	74 09                	je     c0106025 <kfree+0x15>
c010601c:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0106023:	76 24                	jbe    c0106049 <kfree+0x39>
c0106025:	c7 44 24 0c f5 aa 10 	movl   $0xc010aaf5,0xc(%esp)
c010602c:	c0 
c010602d:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c0106034:	c0 
c0106035:	c7 44 24 04 e3 02 00 	movl   $0x2e3,0x4(%esp)
c010603c:	00 
c010603d:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c0106044:	e8 a1 ac ff ff       	call   c0100cea <__panic>
    assert(ptr != NULL);
c0106049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010604d:	75 24                	jne    c0106073 <kfree+0x63>
c010604f:	c7 44 24 0c 1b ab 10 	movl   $0xc010ab1b,0xc(%esp)
c0106056:	c0 
c0106057:	c7 44 24 08 99 a5 10 	movl   $0xc010a599,0x8(%esp)
c010605e:	c0 
c010605f:	c7 44 24 04 e4 02 00 	movl   $0x2e4,0x4(%esp)
c0106066:	00 
c0106067:	c7 04 24 74 a5 10 c0 	movl   $0xc010a574,(%esp)
c010606e:	e8 77 ac ff ff       	call   c0100cea <__panic>
    struct Page *base = NULL;
c0106073:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
c010607a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010607d:	05 ff 0f 00 00       	add    $0xfff,%eax
c0106082:	c1 e8 0c             	shr    $0xc,%eax
c0106085:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0106088:	8b 45 08             	mov    0x8(%ebp),%eax
c010608b:	89 04 24             	mov    %eax,(%esp)
c010608e:	e8 9f e4 ff ff       	call   c0104532 <kva2page>
c0106093:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0106096:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106099:	89 44 24 04          	mov    %eax,0x4(%esp)
c010609d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060a0:	89 04 24             	mov    %eax,(%esp)
c01060a3:	e8 ad e7 ff ff       	call   c0104855 <free_pages>
}
c01060a8:	90                   	nop
c01060a9:	89 ec                	mov    %ebp,%esp
c01060ab:	5d                   	pop    %ebp
c01060ac:	c3                   	ret    

c01060ad <pa2page>:
pa2page(uintptr_t pa) {
c01060ad:	55                   	push   %ebp
c01060ae:	89 e5                	mov    %esp,%ebp
c01060b0:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01060b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01060b6:	c1 e8 0c             	shr    $0xc,%eax
c01060b9:	89 c2                	mov    %eax,%edx
c01060bb:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c01060c0:	39 c2                	cmp    %eax,%edx
c01060c2:	72 1c                	jb     c01060e0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01060c4:	c7 44 24 08 28 ab 10 	movl   $0xc010ab28,0x8(%esp)
c01060cb:	c0 
c01060cc:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01060d3:	00 
c01060d4:	c7 04 24 47 ab 10 c0 	movl   $0xc010ab47,(%esp)
c01060db:	e8 0a ac ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c01060e0:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c01060e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e9:	c1 e8 0c             	shr    $0xc,%eax
c01060ec:	c1 e0 05             	shl    $0x5,%eax
c01060ef:	01 d0                	add    %edx,%eax
}
c01060f1:	89 ec                	mov    %ebp,%esp
c01060f3:	5d                   	pop    %ebp
c01060f4:	c3                   	ret    

c01060f5 <pte2page>:
pte2page(pte_t pte) {
c01060f5:	55                   	push   %ebp
c01060f6:	89 e5                	mov    %esp,%ebp
c01060f8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01060fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01060fe:	83 e0 01             	and    $0x1,%eax
c0106101:	85 c0                	test   %eax,%eax
c0106103:	75 1c                	jne    c0106121 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106105:	c7 44 24 08 58 ab 10 	movl   $0xc010ab58,0x8(%esp)
c010610c:	c0 
c010610d:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106114:	00 
c0106115:	c7 04 24 47 ab 10 c0 	movl   $0xc010ab47,(%esp)
c010611c:	e8 c9 ab ff ff       	call   c0100cea <__panic>
    return pa2page(PTE_ADDR(pte));
c0106121:	8b 45 08             	mov    0x8(%ebp),%eax
c0106124:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106129:	89 04 24             	mov    %eax,(%esp)
c010612c:	e8 7c ff ff ff       	call   c01060ad <pa2page>
}
c0106131:	89 ec                	mov    %ebp,%esp
c0106133:	5d                   	pop    %ebp
c0106134:	c3                   	ret    

c0106135 <swap_init>:
unsigned int swap_in_seq_no[MAX_SEQ_NO], swap_out_seq_no[MAX_SEQ_NO];

static void check_swap(void);

int swap_init(void)
{
c0106135:	55                   	push   %ebp
c0106136:	89 e5                	mov    %esp,%ebp
c0106138:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010613b:	e8 18 29 00 00       	call   c0108a58 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106140:	a1 40 80 12 c0       	mov    0xc0128040,%eax
c0106145:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010614a:	76 0c                	jbe    c0106158 <swap_init+0x23>
c010614c:	a1 40 80 12 c0       	mov    0xc0128040,%eax
c0106151:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106156:	76 25                	jbe    c010617d <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106158:	a1 40 80 12 c0       	mov    0xc0128040,%eax
c010615d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106161:	c7 44 24 08 79 ab 10 	movl   $0xc010ab79,0x8(%esp)
c0106168:	c0 
c0106169:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106170:	00 
c0106171:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106178:	e8 6d ab ff ff       	call   c0100cea <__panic>
     }

     //sm = &swap_manager_fifo;
     sm = &swap_manager_clock;
c010617d:	c7 05 00 81 12 c0 40 	movl   $0xc0124a40,0xc0128100
c0106184:	4a 12 c0 
     int r = sm->init();
c0106187:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c010618c:	8b 40 04             	mov    0x4(%eax),%eax
c010618f:	ff d0                	call   *%eax
c0106191:	89 45 f4             	mov    %eax,-0xc(%ebp)

     if (r == 0)
c0106194:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106198:	75 26                	jne    c01061c0 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010619a:	c7 05 44 80 12 c0 01 	movl   $0x1,0xc0128044
c01061a1:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01061a4:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c01061a9:	8b 00                	mov    (%eax),%eax
c01061ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061af:	c7 04 24 a3 ab 10 c0 	movl   $0xc010aba3,(%esp)
c01061b6:	e8 aa a1 ff ff       	call   c0100365 <cprintf>
          check_swap();
c01061bb:	e8 b0 04 00 00       	call   c0106670 <check_swap>
     }

     return r;
c01061c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01061c3:	89 ec                	mov    %ebp,%esp
c01061c5:	5d                   	pop    %ebp
c01061c6:	c3                   	ret    

c01061c7 <swap_init_mm>:

int swap_init_mm(struct mm_struct *mm)
{
c01061c7:	55                   	push   %ebp
c01061c8:	89 e5                	mov    %esp,%ebp
c01061ca:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01061cd:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c01061d2:	8b 40 08             	mov    0x8(%eax),%eax
c01061d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01061d8:	89 14 24             	mov    %edx,(%esp)
c01061db:	ff d0                	call   *%eax
}
c01061dd:	89 ec                	mov    %ebp,%esp
c01061df:	5d                   	pop    %ebp
c01061e0:	c3                   	ret    

c01061e1 <swap_tick_event>:

int swap_tick_event(struct mm_struct *mm)
{
c01061e1:	55                   	push   %ebp
c01061e2:	89 e5                	mov    %esp,%ebp
c01061e4:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01061e7:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c01061ec:	8b 40 0c             	mov    0xc(%eax),%eax
c01061ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01061f2:	89 14 24             	mov    %edx,(%esp)
c01061f5:	ff d0                	call   *%eax
}
c01061f7:	89 ec                	mov    %ebp,%esp
c01061f9:	5d                   	pop    %ebp
c01061fa:	c3                   	ret    

c01061fb <swap_map_swappable>:

int swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01061fb:	55                   	push   %ebp
c01061fc:	89 e5                	mov    %esp,%ebp
c01061fe:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106201:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c0106206:	8b 40 10             	mov    0x10(%eax),%eax
c0106209:	8b 55 14             	mov    0x14(%ebp),%edx
c010620c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106210:	8b 55 10             	mov    0x10(%ebp),%edx
c0106213:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106217:	8b 55 0c             	mov    0xc(%ebp),%edx
c010621a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010621e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106221:	89 14 24             	mov    %edx,(%esp)
c0106224:	ff d0                	call   *%eax
}
c0106226:	89 ec                	mov    %ebp,%esp
c0106228:	5d                   	pop    %ebp
c0106229:	c3                   	ret    

c010622a <swap_set_unswappable>:

int swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010622a:	55                   	push   %ebp
c010622b:	89 e5                	mov    %esp,%ebp
c010622d:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106230:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c0106235:	8b 40 14             	mov    0x14(%eax),%eax
c0106238:	8b 55 0c             	mov    0xc(%ebp),%edx
c010623b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010623f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106242:	89 14 24             	mov    %edx,(%esp)
c0106245:	ff d0                	call   *%eax
}
c0106247:	89 ec                	mov    %ebp,%esp
c0106249:	5d                   	pop    %ebp
c010624a:	c3                   	ret    

c010624b <swap_out>:

volatile unsigned int swap_out_num = 0;

int swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010624b:	55                   	push   %ebp
c010624c:	89 e5                	mov    %esp,%ebp
c010624e:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++i)
c0106251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106258:	e9 53 01 00 00       	jmp    c01063b0 <swap_out+0x165>
          uintptr_t v;
          // struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          // 找到被换出的物理页，让page指向这个物理页
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010625d:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c0106262:	8b 40 18             	mov    0x18(%eax),%eax
c0106265:	8b 55 10             	mov    0x10(%ebp),%edx
c0106268:	89 54 24 08          	mov    %edx,0x8(%esp)
c010626c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010626f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106273:	8b 55 08             	mov    0x8(%ebp),%edx
c0106276:	89 14 24             	mov    %edx,(%esp)
c0106279:	ff d0                	call   *%eax
c010627b:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0)
c010627e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106282:	74 18                	je     c010629c <swap_out+0x51>
          {
               cprintf("i %d, swap_out: call swap_out_victim failed\n", i);
c0106284:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106287:	89 44 24 04          	mov    %eax,0x4(%esp)
c010628b:	c7 04 24 b8 ab 10 c0 	movl   $0xc010abb8,(%esp)
c0106292:	e8 ce a0 ff ff       	call   c0100365 <cprintf>
c0106297:	e9 20 01 00 00       	jmp    c01063bc <swap_out+0x171>
          }
          // assert(!PageReserved(page));

          // cprintf("SWAP: choose victim page 0x%08x\n", page);
          // 找到这个page对应的虚拟地址并得到对应的pte
          v = page->pra_vaddr;
c010629c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010629f:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01062a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01062a8:	8b 40 0c             	mov    0xc(%eax),%eax
c01062ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062b2:	00 
c01062b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062ba:	89 04 24             	mov    %eax,(%esp)
c01062bd:	e8 dc eb ff ff       	call   c0104e9e <get_pte>
c01062c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01062c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062c8:	8b 00                	mov    (%eax),%eax
c01062ca:	83 e0 01             	and    $0x1,%eax
c01062cd:	85 c0                	test   %eax,%eax
c01062cf:	75 24                	jne    c01062f5 <swap_out+0xaa>
c01062d1:	c7 44 24 0c e5 ab 10 	movl   $0xc010abe5,0xc(%esp)
c01062d8:	c0 
c01062d9:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01062e0:	c0 
c01062e1:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01062e8:	00 
c01062e9:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01062f0:	e8 f5 a9 ff ff       	call   c0100cea <__panic>
          // 把被换出的物理页写到磁盘上
          // page->pra_vaddr 是虚拟地址 除以PGSIZE即右移12位得到高20位 是物理页的索引
          // +1是因为交换分区的前8个扇区不存储
          // 再左移8位构成一个swap_entry_t
          if (swapfs_write((page->pra_vaddr / PGSIZE + 1) << 8, page) != 0)
c01062f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062fb:	8b 52 1c             	mov    0x1c(%edx),%edx
c01062fe:	c1 ea 0c             	shr    $0xc,%edx
c0106301:	42                   	inc    %edx
c0106302:	c1 e2 08             	shl    $0x8,%edx
c0106305:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106309:	89 14 24             	mov    %edx,(%esp)
c010630c:	e8 06 28 00 00       	call   c0108b17 <swapfs_write>
c0106311:	85 c0                	test   %eax,%eax
c0106313:	74 34                	je     c0106349 <swap_out+0xfe>
          {
               cprintf("SWAP: failed to save\n");
c0106315:	c7 04 24 0f ac 10 c0 	movl   $0xc010ac0f,(%esp)
c010631c:	e8 44 a0 ff ff       	call   c0100365 <cprintf>
               // 如果写入磁盘失败，重新令其加入swap管理器
               sm->map_swappable(mm, v, page, 0);
c0106321:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c0106326:	8b 40 10             	mov    0x10(%eax),%eax
c0106329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010632c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106333:	00 
c0106334:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106338:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010633b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010633f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106342:	89 14 24             	mov    %edx,(%esp)
c0106345:	ff d0                	call   *%eax
c0106347:	eb 64                	jmp    c01063ad <swap_out+0x162>
          else
          {
               cprintf(
                   "swap_out: i %d, store page in vaddr 0x%x to disk swap entry "
                   "%d\n",
                   i, v, page->pra_vaddr / PGSIZE + 1);
c0106349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010634c:	8b 40 1c             	mov    0x1c(%eax),%eax
c010634f:	c1 e8 0c             	shr    $0xc,%eax
               cprintf(
c0106352:	40                   	inc    %eax
c0106353:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106357:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010635a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010635e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106361:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106365:	c7 04 24 28 ac 10 c0 	movl   $0xc010ac28,(%esp)
c010636c:	e8 f4 9f ff ff       	call   c0100365 <cprintf>
               // 再修改pte为swap_entry_t，保存扇区号
               *ptep = (page->pra_vaddr / PGSIZE + 1) << 8;
c0106371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106374:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106377:	c1 e8 0c             	shr    $0xc,%eax
c010637a:	40                   	inc    %eax
c010637b:	c1 e0 08             	shl    $0x8,%eax
c010637e:	89 c2                	mov    %eax,%edx
c0106380:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106383:	89 10                	mov    %edx,(%eax)
               // 释放page对应的物理页
               free_page(page);
c0106385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106388:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010638f:	00 
c0106390:	89 04 24             	mov    %eax,(%esp)
c0106393:	e8 bd e4 ff ff       	call   c0104855 <free_pages>
          }
          // 标记TLB不可用
          tlb_invalidate(mm->pgdir, v);
c0106398:	8b 45 08             	mov    0x8(%ebp),%eax
c010639b:	8b 40 0c             	mov    0xc(%eax),%eax
c010639e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063a5:	89 04 24             	mov    %eax,(%esp)
c01063a8:	e8 ed ed ff ff       	call   c010519a <tlb_invalidate>
     for (i = 0; i != n; ++i)
c01063ad:	ff 45 f4             	incl   -0xc(%ebp)
c01063b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063b6:	0f 85 a1 fe ff ff    	jne    c010625d <swap_out+0x12>
     }
     return i;
c01063bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01063bf:	89 ec                	mov    %ebp,%esp
c01063c1:	5d                   	pop    %ebp
c01063c2:	c3                   	ret    

c01063c3 <swap_in>:

int swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01063c3:	55                   	push   %ebp
c01063c4:	89 e5                	mov    %esp,%ebp
c01063c6:	83 ec 28             	sub    $0x28,%esp
     // 先分配一个物理页
     struct Page *result = alloc_page();
c01063c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063d0:	e8 13 e4 ff ff       	call   c01047e8 <alloc_pages>
c01063d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result != NULL);
c01063d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063dc:	75 24                	jne    c0106402 <swap_in+0x3f>
c01063de:	c7 44 24 0c 68 ac 10 	movl   $0xc010ac68,0xc(%esp)
c01063e5:	c0 
c01063e6:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01063ed:	c0 
c01063ee:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01063f5:	00 
c01063f6:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01063fd:	e8 e8 a8 ff ff       	call   c0100cea <__panic>

     // 得到地址对应的页表项
     // 此时页表项中存储的是swap_entry_t
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106402:	8b 45 08             	mov    0x8(%ebp),%eax
c0106405:	8b 40 0c             	mov    0xc(%eax),%eax
c0106408:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010640f:	00 
c0106410:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106413:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106417:	89 04 24             	mov    %eax,(%esp)
c010641a:	e8 7f ea ff ff       	call   c0104e9e <get_pte>
c010641f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No
     // %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));

     int r;
     // 将磁盘中的对应数据写入result中
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106422:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106425:	8b 00                	mov    (%eax),%eax
c0106427:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010642a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010642e:	89 04 24             	mov    %eax,(%esp)
c0106431:	e8 6d 26 00 00       	call   c0108aa3 <swapfs_read>
c0106436:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106439:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010643d:	74 2a                	je     c0106469 <swap_in+0xa6>
     {
          assert(r != 0);
c010643f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106443:	75 24                	jne    c0106469 <swap_in+0xa6>
c0106445:	c7 44 24 0c 77 ac 10 	movl   $0xc010ac77,0xc(%esp)
c010644c:	c0 
c010644d:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106454:	c0 
c0106455:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c010645c:	00 
c010645d:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106464:	e8 81 a8 ff ff       	call   c0100cea <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n",
             (*ptep) >> 8, addr);
c0106469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010646c:	8b 00                	mov    (%eax),%eax
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n",
c010646e:	c1 e8 08             	shr    $0x8,%eax
c0106471:	89 c2                	mov    %eax,%edx
c0106473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106476:	89 44 24 08          	mov    %eax,0x8(%esp)
c010647a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010647e:	c7 04 24 80 ac 10 c0 	movl   $0xc010ac80,(%esp)
c0106485:	e8 db 9e ff ff       	call   c0100365 <cprintf>
     // 修改ptr_result使其指向对应的Page
     *ptr_result = result;
c010648a:	8b 45 10             	mov    0x10(%ebp),%eax
c010648d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106490:	89 10                	mov    %edx,(%eax)
     return 0;
c0106492:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106497:	89 ec                	mov    %ebp,%esp
c0106499:	5d                   	pop    %ebp
c010649a:	c3                   	ret    

c010649b <check_content_set>:

static inline void
check_content_set(void)
{
c010649b:	55                   	push   %ebp
c010649c:	89 e5                	mov    %esp,%ebp
c010649e:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01064a1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01064a6:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num == 1);
c01064a9:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01064ae:	83 f8 01             	cmp    $0x1,%eax
c01064b1:	74 24                	je     c01064d7 <check_content_set+0x3c>
c01064b3:	c7 44 24 0c be ac 10 	movl   $0xc010acbe,0xc(%esp)
c01064ba:	c0 
c01064bb:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01064c2:	c0 
c01064c3:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01064ca:	00 
c01064cb:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01064d2:	e8 13 a8 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01064d7:	b8 10 10 00 00       	mov    $0x1010,%eax
c01064dc:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num == 1);
c01064df:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01064e4:	83 f8 01             	cmp    $0x1,%eax
c01064e7:	74 24                	je     c010650d <check_content_set+0x72>
c01064e9:	c7 44 24 0c be ac 10 	movl   $0xc010acbe,0xc(%esp)
c01064f0:	c0 
c01064f1:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01064f8:	c0 
c01064f9:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106500:	00 
c0106501:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106508:	e8 dd a7 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010650d:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106512:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num == 2);
c0106515:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010651a:	83 f8 02             	cmp    $0x2,%eax
c010651d:	74 24                	je     c0106543 <check_content_set+0xa8>
c010651f:	c7 44 24 0c cf ac 10 	movl   $0xc010accf,0xc(%esp)
c0106526:	c0 
c0106527:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010652e:	c0 
c010652f:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0106536:	00 
c0106537:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010653e:	e8 a7 a7 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106543:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106548:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num == 2);
c010654b:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0106550:	83 f8 02             	cmp    $0x2,%eax
c0106553:	74 24                	je     c0106579 <check_content_set+0xde>
c0106555:	c7 44 24 0c cf ac 10 	movl   $0xc010accf,0xc(%esp)
c010655c:	c0 
c010655d:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106564:	c0 
c0106565:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c010656c:	00 
c010656d:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106574:	e8 71 a7 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106579:	b8 00 30 00 00       	mov    $0x3000,%eax
c010657e:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num == 3);
c0106581:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0106586:	83 f8 03             	cmp    $0x3,%eax
c0106589:	74 24                	je     c01065af <check_content_set+0x114>
c010658b:	c7 44 24 0c e0 ac 10 	movl   $0xc010ace0,0xc(%esp)
c0106592:	c0 
c0106593:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010659a:	c0 
c010659b:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01065a2:	00 
c01065a3:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01065aa:	e8 3b a7 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01065af:	b8 10 30 00 00       	mov    $0x3010,%eax
c01065b4:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num == 3);
c01065b7:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01065bc:	83 f8 03             	cmp    $0x3,%eax
c01065bf:	74 24                	je     c01065e5 <check_content_set+0x14a>
c01065c1:	c7 44 24 0c e0 ac 10 	movl   $0xc010ace0,0xc(%esp)
c01065c8:	c0 
c01065c9:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01065d0:	c0 
c01065d1:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c01065d8:	00 
c01065d9:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01065e0:	e8 05 a7 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01065e5:	b8 00 40 00 00       	mov    $0x4000,%eax
c01065ea:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num == 4);
c01065ed:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01065f2:	83 f8 04             	cmp    $0x4,%eax
c01065f5:	74 24                	je     c010661b <check_content_set+0x180>
c01065f7:	c7 44 24 0c f1 ac 10 	movl   $0xc010acf1,0xc(%esp)
c01065fe:	c0 
c01065ff:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106606:	c0 
c0106607:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c010660e:	00 
c010660f:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106616:	e8 cf a6 ff ff       	call   c0100cea <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c010661b:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106620:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num == 4);
c0106623:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0106628:	83 f8 04             	cmp    $0x4,%eax
c010662b:	74 24                	je     c0106651 <check_content_set+0x1b6>
c010662d:	c7 44 24 0c f1 ac 10 	movl   $0xc010acf1,0xc(%esp)
c0106634:	c0 
c0106635:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010663c:	c0 
c010663d:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0106644:	00 
c0106645:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010664c:	e8 99 a6 ff ff       	call   c0100cea <__panic>
}
c0106651:	90                   	nop
c0106652:	89 ec                	mov    %ebp,%esp
c0106654:	5d                   	pop    %ebp
c0106655:	c3                   	ret    

c0106656 <check_content_access>:

static inline int
check_content_access(void)
{
c0106656:	55                   	push   %ebp
c0106657:	89 e5                	mov    %esp,%ebp
c0106659:	83 ec 18             	sub    $0x18,%esp
     int ret = sm->check_swap();
c010665c:	a1 00 81 12 c0       	mov    0xc0128100,%eax
c0106661:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106664:	ff d0                	call   *%eax
c0106666:	89 45 f4             	mov    %eax,-0xc(%ebp)
     return ret;
c0106669:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010666c:	89 ec                	mov    %ebp,%esp
c010666e:	5d                   	pop    %ebp
c010666f:	c3                   	ret    

c0106670 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106670:	55                   	push   %ebp
c0106671:	89 e5                	mov    %esp,%ebp
c0106673:	83 ec 78             	sub    $0x78,%esp
     // backup mem env
     int ret, count = 0, total = 0, i;
c0106676:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010667d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106684:	c7 45 e8 84 7f 12 c0 	movl   $0xc0127f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list)
c010668b:	eb 6a                	jmp    c01066f7 <check_swap+0x87>
     {
          struct Page *p = le2page(le, page_link);
c010668d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106690:	83 e8 0c             	sub    $0xc,%eax
c0106693:	89 45 c8             	mov    %eax,-0x38(%ebp)
          assert(PageProperty(p));
c0106696:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106699:	83 c0 04             	add    $0x4,%eax
c010669c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01066a3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01066a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01066a9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01066ac:	0f a3 10             	bt     %edx,(%eax)
c01066af:	19 c0                	sbb    %eax,%eax
c01066b1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01066b4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01066b8:	0f 95 c0             	setne  %al
c01066bb:	0f b6 c0             	movzbl %al,%eax
c01066be:	85 c0                	test   %eax,%eax
c01066c0:	75 24                	jne    c01066e6 <check_swap+0x76>
c01066c2:	c7 44 24 0c 02 ad 10 	movl   $0xc010ad02,0xc(%esp)
c01066c9:	c0 
c01066ca:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01066d1:	c0 
c01066d2:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01066d9:	00 
c01066da:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01066e1:	e8 04 a6 ff ff       	call   c0100cea <__panic>
          count++, total += p->property;
c01066e6:	ff 45 f4             	incl   -0xc(%ebp)
c01066e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01066ec:	8b 50 08             	mov    0x8(%eax),%edx
c01066ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066f2:	01 d0                	add    %edx,%eax
c01066f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01066fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01066fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106700:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list)
c0106703:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106706:	81 7d e8 84 7f 12 c0 	cmpl   $0xc0127f84,-0x18(%ebp)
c010670d:	0f 85 7a ff ff ff    	jne    c010668d <check_swap+0x1d>
     }
     assert(total == nr_free_pages());
c0106713:	e8 72 e1 ff ff       	call   c010488a <nr_free_pages>
c0106718:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010671b:	39 d0                	cmp    %edx,%eax
c010671d:	74 24                	je     c0106743 <check_swap+0xd3>
c010671f:	c7 44 24 0c 12 ad 10 	movl   $0xc010ad12,0xc(%esp)
c0106726:	c0 
c0106727:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010672e:	c0 
c010672f:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106736:	00 
c0106737:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010673e:	e8 a7 a5 ff ff       	call   c0100cea <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n", count, total);
c0106743:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106746:	89 44 24 08          	mov    %eax,0x8(%esp)
c010674a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010674d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106751:	c7 04 24 2c ad 10 c0 	movl   $0xc010ad2c,(%esp)
c0106758:	e8 08 9c ff ff       	call   c0100365 <cprintf>

     // now we set the phy pages env
     struct mm_struct *mm = mm_create();
c010675d:	e8 42 15 00 00       	call   c0107ca4 <mm_create>
c0106762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     assert(mm != NULL);
c0106765:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106769:	75 24                	jne    c010678f <check_swap+0x11f>
c010676b:	c7 44 24 0c 52 ad 10 	movl   $0xc010ad52,0xc(%esp)
c0106772:	c0 
c0106773:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010677a:	c0 
c010677b:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0106782:	00 
c0106783:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010678a:	e8 5b a5 ff ff       	call   c0100cea <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c010678f:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c0106794:	85 c0                	test   %eax,%eax
c0106796:	74 24                	je     c01067bc <check_swap+0x14c>
c0106798:	c7 44 24 0c 5d ad 10 	movl   $0xc010ad5d,0xc(%esp)
c010679f:	c0 
c01067a0:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01067a7:	c0 
c01067a8:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01067af:	00 
c01067b0:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01067b7:	e8 2e a5 ff ff       	call   c0100cea <__panic>

     check_mm_struct = mm;
c01067bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067bf:	a3 0c 81 12 c0       	mov    %eax,0xc012810c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01067c4:	8b 15 e0 49 12 c0    	mov    0xc01249e0,%edx
c01067ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067cd:	89 50 0c             	mov    %edx,0xc(%eax)
c01067d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067d3:	8b 40 0c             	mov    0xc(%eax),%eax
c01067d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(pgdir[0] == 0);
c01067d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067dc:	8b 00                	mov    (%eax),%eax
c01067de:	85 c0                	test   %eax,%eax
c01067e0:	74 24                	je     c0106806 <check_swap+0x196>
c01067e2:	c7 44 24 0c 75 ad 10 	movl   $0xc010ad75,0xc(%esp)
c01067e9:	c0 
c01067ea:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01067f1:	c0 
c01067f2:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01067f9:	00 
c01067fa:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106801:	e8 e4 a4 ff ff       	call   c0100cea <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106806:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c010680d:	00 
c010680e:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106815:	00 
c0106816:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c010681d:	e8 fd 14 00 00       	call   c0107d1f <vma_create>
c0106822:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(vma != NULL);
c0106825:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106829:	75 24                	jne    c010684f <check_swap+0x1df>
c010682b:	c7 44 24 0c 83 ad 10 	movl   $0xc010ad83,0xc(%esp)
c0106832:	c0 
c0106833:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010683a:	c0 
c010683b:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106842:	00 
c0106843:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010684a:	e8 9b a4 ff ff       	call   c0100cea <__panic>

     insert_vma_struct(mm, vma);
c010684f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106852:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106859:	89 04 24             	mov    %eax,(%esp)
c010685c:	e8 55 16 00 00       	call   c0107eb6 <insert_vma_struct>

     // setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106861:	c7 04 24 90 ad 10 c0 	movl   $0xc010ad90,(%esp)
c0106868:	e8 f8 9a ff ff       	call   c0100365 <cprintf>
     pte_t *temp_ptep = NULL;
c010686d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106877:	8b 40 0c             	mov    0xc(%eax),%eax
c010687a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106881:	00 
c0106882:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106889:	00 
c010688a:	89 04 24             	mov    %eax,(%esp)
c010688d:	e8 0c e6 ff ff       	call   c0104e9e <get_pte>
c0106892:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(temp_ptep != NULL);
c0106895:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106899:	75 24                	jne    c01068bf <check_swap+0x24f>
c010689b:	c7 44 24 0c c4 ad 10 	movl   $0xc010adc4,0xc(%esp)
c01068a2:	c0 
c01068a3:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01068aa:	c0 
c01068ab:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01068b2:	00 
c01068b3:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01068ba:	e8 2b a4 ff ff       	call   c0100cea <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01068bf:	c7 04 24 d8 ad 10 c0 	movl   $0xc010add8,(%esp)
c01068c6:	e8 9a 9a ff ff       	call   c0100365 <cprintf>

     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c01068cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01068d2:	e9 a2 00 00 00       	jmp    c0106979 <check_swap+0x309>
     {
          check_rp[i] = alloc_page();
c01068d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068de:	e8 05 df ff ff       	call   c01047e8 <alloc_pages>
c01068e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068e6:	89 04 95 cc 80 12 c0 	mov    %eax,-0x3fed7f34(,%edx,4)
          assert(check_rp[i] != NULL);
c01068ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068f0:	8b 04 85 cc 80 12 c0 	mov    -0x3fed7f34(,%eax,4),%eax
c01068f7:	85 c0                	test   %eax,%eax
c01068f9:	75 24                	jne    c010691f <check_swap+0x2af>
c01068fb:	c7 44 24 0c fc ad 10 	movl   $0xc010adfc,0xc(%esp)
c0106902:	c0 
c0106903:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c010690a:	c0 
c010690b:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106912:	00 
c0106913:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c010691a:	e8 cb a3 ff ff       	call   c0100cea <__panic>
          assert(!PageProperty(check_rp[i]));
c010691f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106922:	8b 04 85 cc 80 12 c0 	mov    -0x3fed7f34(,%eax,4),%eax
c0106929:	83 c0 04             	add    $0x4,%eax
c010692c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106933:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106936:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106939:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010693c:	0f a3 10             	bt     %edx,(%eax)
c010693f:	19 c0                	sbb    %eax,%eax
c0106941:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106944:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106948:	0f 95 c0             	setne  %al
c010694b:	0f b6 c0             	movzbl %al,%eax
c010694e:	85 c0                	test   %eax,%eax
c0106950:	74 24                	je     c0106976 <check_swap+0x306>
c0106952:	c7 44 24 0c 10 ae 10 	movl   $0xc010ae10,0xc(%esp)
c0106959:	c0 
c010695a:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106961:	c0 
c0106962:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0106969:	00 
c010696a:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106971:	e8 74 a3 ff ff       	call   c0100cea <__panic>
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106976:	ff 45 ec             	incl   -0x14(%ebp)
c0106979:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010697d:	0f 8e 54 ff ff ff    	jle    c01068d7 <check_swap+0x267>
     }
     list_entry_t free_list_store = free_list;
c0106983:	a1 84 7f 12 c0       	mov    0xc0127f84,%eax
c0106988:	8b 15 88 7f 12 c0    	mov    0xc0127f88,%edx
c010698e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106991:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106994:	c7 45 a4 84 7f 12 c0 	movl   $0xc0127f84,-0x5c(%ebp)
    elm->prev = elm->next = elm;
c010699b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010699e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01069a1:	89 50 04             	mov    %edx,0x4(%eax)
c01069a4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01069a7:	8b 50 04             	mov    0x4(%eax),%edx
c01069aa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01069ad:	89 10                	mov    %edx,(%eax)
}
c01069af:	90                   	nop
c01069b0:	c7 45 a8 84 7f 12 c0 	movl   $0xc0127f84,-0x58(%ebp)
    return list->next == list;
c01069b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01069ba:	8b 40 04             	mov    0x4(%eax),%eax
c01069bd:	39 45 a8             	cmp    %eax,-0x58(%ebp)
c01069c0:	0f 94 c0             	sete   %al
c01069c3:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01069c6:	85 c0                	test   %eax,%eax
c01069c8:	75 24                	jne    c01069ee <check_swap+0x37e>
c01069ca:	c7 44 24 0c 2b ae 10 	movl   $0xc010ae2b,0xc(%esp)
c01069d1:	c0 
c01069d2:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c01069d9:	c0 
c01069da:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01069e1:	00 
c01069e2:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c01069e9:	e8 fc a2 ff ff       	call   c0100cea <__panic>

     // assert(alloc_page() == NULL);

     unsigned int nr_free_store = nr_free;
c01069ee:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c01069f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     nr_free = 0;
c01069f6:	c7 05 8c 7f 12 c0 00 	movl   $0x0,0xc0127f8c
c01069fd:	00 00 00 
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106a00:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a07:	eb 1d                	jmp    c0106a26 <check_swap+0x3b6>
     {
          free_pages(check_rp[i], 1);
c0106a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a0c:	8b 04 85 cc 80 12 c0 	mov    -0x3fed7f34(,%eax,4),%eax
c0106a13:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a1a:	00 
c0106a1b:	89 04 24             	mov    %eax,(%esp)
c0106a1e:	e8 32 de ff ff       	call   c0104855 <free_pages>
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106a23:	ff 45 ec             	incl   -0x14(%ebp)
c0106a26:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106a2a:	7e dd                	jle    c0106a09 <check_swap+0x399>
     }
     assert(nr_free == CHECK_VALID_PHY_PAGE_NUM);
c0106a2c:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0106a31:	83 f8 04             	cmp    $0x4,%eax
c0106a34:	74 24                	je     c0106a5a <check_swap+0x3ea>
c0106a36:	c7 44 24 0c 44 ae 10 	movl   $0xc010ae44,0xc(%esp)
c0106a3d:	c0 
c0106a3e:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106a45:	c0 
c0106a46:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0106a4d:	00 
c0106a4e:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106a55:	e8 90 a2 ff ff       	call   c0100cea <__panic>

     cprintf("set up init env for check_swap begin!\n");
c0106a5a:	c7 04 24 68 ae 10 c0 	movl   $0xc010ae68,(%esp)
c0106a61:	e8 ff 98 ff ff       	call   c0100365 <cprintf>
     // setup initial vir_page<->phy_page environment for page relpacement algorithm

     pgfault_num = 0;
c0106a66:	c7 05 10 81 12 c0 00 	movl   $0x0,0xc0128110
c0106a6d:	00 00 00 

     check_content_set();
c0106a70:	e8 26 fa ff ff       	call   c010649b <check_content_set>
     assert(nr_free == 0);
c0106a75:	a1 8c 7f 12 c0       	mov    0xc0127f8c,%eax
c0106a7a:	85 c0                	test   %eax,%eax
c0106a7c:	74 24                	je     c0106aa2 <check_swap+0x432>
c0106a7e:	c7 44 24 0c 8f ae 10 	movl   $0xc010ae8f,0xc(%esp)
c0106a85:	c0 
c0106a86:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106a8d:	c0 
c0106a8e:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0106a95:	00 
c0106a96:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106a9d:	e8 48 a2 ff ff       	call   c0100cea <__panic>
     for (i = 0; i < MAX_SEQ_NO; i++)
c0106aa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106aa9:	eb 25                	jmp    c0106ad0 <check_swap+0x460>
          swap_out_seq_no[i] = swap_in_seq_no[i] = -1;
c0106aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106aae:	c7 04 85 60 80 12 c0 	movl   $0xffffffff,-0x3fed7fa0(,%eax,4)
c0106ab5:	ff ff ff ff 
c0106ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106abc:	8b 14 85 60 80 12 c0 	mov    -0x3fed7fa0(,%eax,4),%edx
c0106ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ac6:	89 14 85 a0 80 12 c0 	mov    %edx,-0x3fed7f60(,%eax,4)
     for (i = 0; i < MAX_SEQ_NO; i++)
c0106acd:	ff 45 ec             	incl   -0x14(%ebp)
c0106ad0:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106ad4:	7e d5                	jle    c0106aab <check_swap+0x43b>

     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106ad6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106add:	e9 e8 00 00 00       	jmp    c0106bca <check_swap+0x55a>
     {
          check_ptep[i] = 0;
c0106ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ae5:	c7 04 85 dc 80 12 c0 	movl   $0x0,-0x3fed7f24(,%eax,4)
c0106aec:	00 00 00 00 
          check_ptep[i] = get_pte(pgdir, (i + 1) * 0x1000, 0);
c0106af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106af3:	40                   	inc    %eax
c0106af4:	c1 e0 0c             	shl    $0xc,%eax
c0106af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106afe:	00 
c0106aff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b06:	89 04 24             	mov    %eax,(%esp)
c0106b09:	e8 90 e3 ff ff       	call   c0104e9e <get_pte>
c0106b0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b11:	89 04 95 dc 80 12 c0 	mov    %eax,-0x3fed7f24(,%edx,4)
          // cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
          assert(check_ptep[i] != NULL);
c0106b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b1b:	8b 04 85 dc 80 12 c0 	mov    -0x3fed7f24(,%eax,4),%eax
c0106b22:	85 c0                	test   %eax,%eax
c0106b24:	75 24                	jne    c0106b4a <check_swap+0x4da>
c0106b26:	c7 44 24 0c 9c ae 10 	movl   $0xc010ae9c,0xc(%esp)
c0106b2d:	c0 
c0106b2e:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106b35:	c0 
c0106b36:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0106b3d:	00 
c0106b3e:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106b45:	e8 a0 a1 ff ff       	call   c0100cea <__panic>
          assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b4d:	8b 04 85 dc 80 12 c0 	mov    -0x3fed7f24(,%eax,4),%eax
c0106b54:	8b 00                	mov    (%eax),%eax
c0106b56:	89 04 24             	mov    %eax,(%esp)
c0106b59:	e8 97 f5 ff ff       	call   c01060f5 <pte2page>
c0106b5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b61:	8b 14 95 cc 80 12 c0 	mov    -0x3fed7f34(,%edx,4),%edx
c0106b68:	39 d0                	cmp    %edx,%eax
c0106b6a:	74 24                	je     c0106b90 <check_swap+0x520>
c0106b6c:	c7 44 24 0c b4 ae 10 	movl   $0xc010aeb4,0xc(%esp)
c0106b73:	c0 
c0106b74:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106b7b:	c0 
c0106b7c:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0106b83:	00 
c0106b84:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106b8b:	e8 5a a1 ff ff       	call   c0100cea <__panic>
          assert((*check_ptep[i] & PTE_P));
c0106b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b93:	8b 04 85 dc 80 12 c0 	mov    -0x3fed7f24(,%eax,4),%eax
c0106b9a:	8b 00                	mov    (%eax),%eax
c0106b9c:	83 e0 01             	and    $0x1,%eax
c0106b9f:	85 c0                	test   %eax,%eax
c0106ba1:	75 24                	jne    c0106bc7 <check_swap+0x557>
c0106ba3:	c7 44 24 0c dc ae 10 	movl   $0xc010aedc,0xc(%esp)
c0106baa:	c0 
c0106bab:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106bb2:	c0 
c0106bb3:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0106bba:	00 
c0106bbb:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106bc2:	e8 23 a1 ff ff       	call   c0100cea <__panic>
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106bc7:	ff 45 ec             	incl   -0x14(%ebp)
c0106bca:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106bce:	0f 8e 0e ff ff ff    	jle    c0106ae2 <check_swap+0x472>
     }
     cprintf("set up init env for check_swap over!\n");
c0106bd4:	c7 04 24 f8 ae 10 c0 	movl   $0xc010aef8,(%esp)
c0106bdb:	e8 85 97 ff ff       	call   c0100365 <cprintf>
     // now access the virt pages to test  page relpacement algorithm
     ret = check_content_access();
c0106be0:	e8 71 fa ff ff       	call   c0106656 <check_content_access>
c0106be5:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(ret == 0);
c0106be8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0106bec:	74 24                	je     c0106c12 <check_swap+0x5a2>
c0106bee:	c7 44 24 0c 1e af 10 	movl   $0xc010af1e,0xc(%esp)
c0106bf5:	c0 
c0106bf6:	c7 44 24 08 fa ab 10 	movl   $0xc010abfa,0x8(%esp)
c0106bfd:	c0 
c0106bfe:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0106c05:	00 
c0106c06:	c7 04 24 94 ab 10 c0 	movl   $0xc010ab94,(%esp)
c0106c0d:	e8 d8 a0 ff ff       	call   c0100cea <__panic>

     // restore kernel mem env
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106c12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106c19:	eb 1d                	jmp    c0106c38 <check_swap+0x5c8>
     {
          free_pages(check_rp[i], 1);
c0106c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c1e:	8b 04 85 cc 80 12 c0 	mov    -0x3fed7f34(,%eax,4),%eax
c0106c25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106c2c:	00 
c0106c2d:	89 04 24             	mov    %eax,(%esp)
c0106c30:	e8 20 dc ff ff       	call   c0104855 <free_pages>
     for (i = 0; i < CHECK_VALID_PHY_PAGE_NUM; i++)
c0106c35:	ff 45 ec             	incl   -0x14(%ebp)
c0106c38:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106c3c:	7e dd                	jle    c0106c1b <check_swap+0x5ab>
     }

     // free_page(pte2page(*temp_ptep));

     mm_destroy(mm);
c0106c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c41:	89 04 24             	mov    %eax,(%esp)
c0106c44:	e8 a3 13 00 00       	call   c0107fec <mm_destroy>

     nr_free = nr_free_store;
c0106c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c4c:	a3 8c 7f 12 c0       	mov    %eax,0xc0127f8c
     free_list = free_list_store;
c0106c51:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106c54:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106c57:	a3 84 7f 12 c0       	mov    %eax,0xc0127f84
c0106c5c:	89 15 88 7f 12 c0    	mov    %edx,0xc0127f88

     le = &free_list;
c0106c62:	c7 45 e8 84 7f 12 c0 	movl   $0xc0127f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list)
c0106c69:	eb 1c                	jmp    c0106c87 <check_swap+0x617>
     {
          struct Page *p = le2page(le, page_link);
c0106c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c6e:	83 e8 0c             	sub    $0xc,%eax
c0106c71:	89 45 cc             	mov    %eax,-0x34(%ebp)
          count--, total -= p->property;
c0106c74:	ff 4d f4             	decl   -0xc(%ebp)
c0106c77:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106c7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106c7d:	8b 48 08             	mov    0x8(%eax),%ecx
c0106c80:	89 d0                	mov    %edx,%eax
c0106c82:	29 c8                	sub    %ecx,%eax
c0106c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c8a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0106c8d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106c90:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list)
c0106c93:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c96:	81 7d e8 84 7f 12 c0 	cmpl   $0xc0127f84,-0x18(%ebp)
c0106c9d:	75 cc                	jne    c0106c6b <check_swap+0x5fb>
     }
     cprintf("count is %d, total is %d\n", count, total);
c0106c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cad:	c7 04 24 27 af 10 c0 	movl   $0xc010af27,(%esp)
c0106cb4:	e8 ac 96 ff ff       	call   c0100365 <cprintf>
     // assert(count == 0);

     cprintf("check_swap() succeeded!\n");
c0106cb9:	c7 04 24 41 af 10 c0 	movl   $0xc010af41,(%esp)
c0106cc0:	e8 a0 96 ff ff       	call   c0100365 <cprintf>
}
c0106cc5:	90                   	nop
c0106cc6:	89 ec                	mov    %ebp,%esp
c0106cc8:	5d                   	pop    %ebp
c0106cc9:	c3                   	ret    

c0106cca <_clock_init_mm>:
        tlb_invalidate((pgdir), page->pra_vaddr);           \
    } while (0)

static int
_clock_init_mm(struct mm_struct *mm)
{
c0106cca:	55                   	push   %ebp
c0106ccb:	89 e5                	mov    %esp,%ebp
    mm->sm_priv = NULL;
c0106ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    return 0;
c0106cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cdc:	5d                   	pop    %ebp
c0106cdd:	c3                   	ret    

c0106cde <_clock_map_swappable>:

static int
_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106cde:	55                   	push   %ebp
c0106cdf:	89 e5                	mov    %esp,%ebp
c0106ce1:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0106ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce7:	8b 40 14             	mov    0x14(%eax),%eax
c0106cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry = &(page->pra_page_link);
c0106ced:	8b 45 10             	mov    0x10(%ebp),%eax
c0106cf0:	83 c0 14             	add    $0x14,%eax
c0106cf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(entry != NULL);
c0106cf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106cfa:	75 24                	jne    c0106d20 <_clock_map_swappable+0x42>
c0106cfc:	c7 44 24 0c 5c af 10 	movl   $0xc010af5c,0xc(%esp)
c0106d03:	c0 
c0106d04:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0106d0b:	c0 
c0106d0c:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
c0106d13:	00 
c0106d14:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0106d1b:	e8 ca 9f ff ff       	call   c0100cea <__panic>

    // Insert before pointer
    if (head == NULL)
c0106d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d24:	75 26                	jne    c0106d4c <_clock_map_swappable+0x6e>
c0106d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d29:	89 45 ec             	mov    %eax,-0x14(%ebp)
    elm->prev = elm->next = elm;
c0106d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d32:	89 50 04             	mov    %edx,0x4(%eax)
c0106d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d38:	8b 50 04             	mov    0x4(%eax),%edx
c0106d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d3e:	89 10                	mov    %edx,(%eax)
}
c0106d40:	90                   	nop
    {
        list_init(entry);
        mm->sm_priv = entry;
c0106d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d44:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106d47:	89 50 14             	mov    %edx,0x14(%eax)
c0106d4a:	eb 46                	jmp    c0106d92 <_clock_map_swappable+0xb4>
c0106d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0106d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d5b:	8b 00                	mov    (%eax),%eax
c0106d5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d60:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0106d63:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d69:	89 45 d8             	mov    %eax,-0x28(%ebp)
    prev->next = next->prev = elm;
c0106d6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d72:	89 10                	mov    %edx,(%eax)
c0106d74:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d77:	8b 10                	mov    (%eax),%edx
c0106d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106d7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d82:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106d85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106d88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d8e:	89 10                	mov    %edx,(%eax)
}
c0106d90:	90                   	nop
}
c0106d91:	90                   	nop
    }
    else
    {
        list_add_before(head, entry);
    }
    return 0;
c0106d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d97:	89 ec                	mov    %ebp,%esp
c0106d99:	5d                   	pop    %ebp
c0106d9a:	c3                   	ret    

c0106d9b <_clock_swap_out_victim>:

static int
_clock_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick)
{
c0106d9b:	55                   	push   %ebp
c0106d9c:	89 e5                	mov    %esp,%ebp
c0106d9e:	83 ec 58             	sub    $0x58,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0106da1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106da4:	8b 40 14             	mov    0x14(%eax),%eax
c0106da7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(head != NULL);
c0106daa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106dae:	75 24                	jne    c0106dd4 <_clock_swap_out_victim+0x39>
c0106db0:	c7 44 24 0c 94 af 10 	movl   $0xc010af94,0xc(%esp)
c0106db7:	c0 
c0106db8:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0106dbf:	c0 
c0106dc0:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
c0106dc7:	00 
c0106dc8:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0106dcf:	e8 16 9f ff ff       	call   c0100cea <__panic>
    assert(in_tick == 0);
c0106dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106dd8:	74 24                	je     c0106dfe <_clock_swap_out_victim+0x63>
c0106dda:	c7 44 24 0c a1 af 10 	movl   $0xc010afa1,0xc(%esp)
c0106de1:	c0 
c0106de2:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0106de9:	c0 
c0106dea:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0106df1:	00 
c0106df2:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0106df9:	e8 ec 9e ff ff       	call   c0100cea <__panic>

    list_entry_t *selected = NULL, *p = head;
c0106dfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // Search <0,0>
    do
    {
        if (GET_ACCESSED_FLAG(mm->pgdir, p) == 0 && GET_DIRTY_FLAG(mm->pgdir, p) == 0)
c0106e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e0e:	83 e8 14             	sub    $0x14,%eax
c0106e11:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e17:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106e21:	00 
c0106e22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e26:	89 04 24             	mov    %eax,(%esp)
c0106e29:	e8 70 e0 ff ff       	call   c0104e9e <get_pte>
c0106e2e:	8b 00                	mov    (%eax),%eax
c0106e30:	83 e0 20             	and    $0x20,%eax
c0106e33:	85 c0                	test   %eax,%eax
c0106e35:	75 34                	jne    c0106e6b <_clock_swap_out_victim+0xd0>
c0106e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e3a:	83 e8 14             	sub    $0x14,%eax
c0106e3d:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e43:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106e4d:	00 
c0106e4e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e52:	89 04 24             	mov    %eax,(%esp)
c0106e55:	e8 44 e0 ff ff       	call   c0104e9e <get_pte>
c0106e5a:	8b 00                	mov    (%eax),%eax
c0106e5c:	83 e0 40             	and    $0x40,%eax
c0106e5f:	85 c0                	test   %eax,%eax
c0106e61:	75 08                	jne    c0106e6b <_clock_swap_out_victim+0xd0>
        {
            selected = p;
c0106e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0106e69:	eb 17                	jmp    c0106e82 <_clock_swap_out_victim+0xe7>
c0106e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0106e71:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e74:	8b 40 04             	mov    0x4(%eax),%eax
        }
        p = list_next(p);
c0106e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
    } while (p != head);
c0106e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106e80:	75 89                	jne    c0106e0b <_clock_swap_out_victim+0x70>
    // Search <0,1> and set 'accessed' to 0
    if (selected == NULL)
c0106e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e86:	0f 85 ce 00 00 00    	jne    c0106f5a <_clock_swap_out_victim+0x1bf>
        do
        {
            if (GET_ACCESSED_FLAG(mm->pgdir, p) == 0 && GET_DIRTY_FLAG(mm->pgdir, p))
c0106e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e8f:	83 e8 14             	sub    $0x14,%eax
c0106e92:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106e95:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e98:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106ea2:	00 
c0106ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ea7:	89 04 24             	mov    %eax,(%esp)
c0106eaa:	e8 ef df ff ff       	call   c0104e9e <get_pte>
c0106eaf:	8b 00                	mov    (%eax),%eax
c0106eb1:	83 e0 20             	and    $0x20,%eax
c0106eb4:	85 c0                	test   %eax,%eax
c0106eb6:	75 34                	jne    c0106eec <_clock_swap_out_victim+0x151>
c0106eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ebb:	83 e8 14             	sub    $0x14,%eax
c0106ebe:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106ec1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ec4:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ec7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106ece:	00 
c0106ecf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ed3:	89 04 24             	mov    %eax,(%esp)
c0106ed6:	e8 c3 df ff ff       	call   c0104e9e <get_pte>
c0106edb:	8b 00                	mov    (%eax),%eax
c0106edd:	83 e0 40             	and    $0x40,%eax
c0106ee0:	85 c0                	test   %eax,%eax
c0106ee2:	74 08                	je     c0106eec <_clock_swap_out_victim+0x151>
            {
                selected = p;
c0106ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
                break;
c0106eea:	eb 6e                	jmp    c0106f5a <_clock_swap_out_victim+0x1bf>
            }
            CLEAR_ACCESSED_FLAG(mm->pgdir, p);
c0106eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eef:	83 e8 14             	sub    $0x14,%eax
c0106ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ef8:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106efe:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f08:	00 
c0106f09:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f0d:	89 04 24             	mov    %eax,(%esp)
c0106f10:	e8 89 df ff ff       	call   c0104e9e <get_pte>
c0106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f1b:	8b 00                	mov    (%eax),%eax
c0106f1d:	83 e0 df             	and    $0xffffffdf,%eax
c0106f20:	89 c2                	mov    %eax,%edx
c0106f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f25:	89 10                	mov    %edx,(%eax)
c0106f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f2a:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f30:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f33:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f37:	89 04 24             	mov    %eax,(%esp)
c0106f3a:	e8 5b e2 ff ff       	call   c010519a <tlb_invalidate>
c0106f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106f48:	8b 40 04             	mov    0x4(%eax),%eax
            p = list_next(p);
c0106f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        } while (p != head);
c0106f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f51:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106f54:	0f 85 32 ff ff ff    	jne    c0106e8c <_clock_swap_out_victim+0xf1>
    // Search <0,0> again
    if (selected == NULL)
c0106f5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106f5e:	75 77                	jne    c0106fd7 <_clock_swap_out_victim+0x23c>
        do
        {
            if (GET_ACCESSED_FLAG(mm->pgdir, p) == 0 && GET_DIRTY_FLAG(mm->pgdir, p) == 0)
c0106f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f63:	83 e8 14             	sub    $0x14,%eax
c0106f66:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f6c:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f76:	00 
c0106f77:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f7b:	89 04 24             	mov    %eax,(%esp)
c0106f7e:	e8 1b df ff ff       	call   c0104e9e <get_pte>
c0106f83:	8b 00                	mov    (%eax),%eax
c0106f85:	83 e0 20             	and    $0x20,%eax
c0106f88:	85 c0                	test   %eax,%eax
c0106f8a:	75 34                	jne    c0106fc0 <_clock_swap_out_victim+0x225>
c0106f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f8f:	83 e8 14             	sub    $0x14,%eax
c0106f92:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106f95:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f98:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fa2:	00 
c0106fa3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106fa7:	89 04 24             	mov    %eax,(%esp)
c0106faa:	e8 ef de ff ff       	call   c0104e9e <get_pte>
c0106faf:	8b 00                	mov    (%eax),%eax
c0106fb1:	83 e0 40             	and    $0x40,%eax
c0106fb4:	85 c0                	test   %eax,%eax
c0106fb6:	75 08                	jne    c0106fc0 <_clock_swap_out_victim+0x225>
            {
                selected = p;
c0106fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
                break;
c0106fbe:	eb 17                	jmp    c0106fd7 <_clock_swap_out_victim+0x23c>
c0106fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fc3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0106fc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106fc9:	8b 40 04             	mov    0x4(%eax),%eax
            }
            p = list_next(p);
c0106fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        } while (p != head);
c0106fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106fd5:	75 89                	jne    c0106f60 <_clock_swap_out_victim+0x1c5>
    // Search <0,1> again
    if (selected == NULL)
c0106fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106fdb:	75 77                	jne    c0107054 <_clock_swap_out_victim+0x2b9>
        do
        {
            if (GET_ACCESSED_FLAG(mm->pgdir, p) == 0 && GET_DIRTY_FLAG(mm->pgdir, p))
c0106fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fe0:	83 e8 14             	sub    $0x14,%eax
c0106fe3:	8b 50 1c             	mov    0x1c(%eax),%edx
c0106fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fe9:	8b 40 0c             	mov    0xc(%eax),%eax
c0106fec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106ff3:	00 
c0106ff4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ff8:	89 04 24             	mov    %eax,(%esp)
c0106ffb:	e8 9e de ff ff       	call   c0104e9e <get_pte>
c0107000:	8b 00                	mov    (%eax),%eax
c0107002:	83 e0 20             	and    $0x20,%eax
c0107005:	85 c0                	test   %eax,%eax
c0107007:	75 34                	jne    c010703d <_clock_swap_out_victim+0x2a2>
c0107009:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010700c:	83 e8 14             	sub    $0x14,%eax
c010700f:	8b 50 1c             	mov    0x1c(%eax),%edx
c0107012:	8b 45 08             	mov    0x8(%ebp),%eax
c0107015:	8b 40 0c             	mov    0xc(%eax),%eax
c0107018:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010701f:	00 
c0107020:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107024:	89 04 24             	mov    %eax,(%esp)
c0107027:	e8 72 de ff ff       	call   c0104e9e <get_pte>
c010702c:	8b 00                	mov    (%eax),%eax
c010702e:	83 e0 40             	and    $0x40,%eax
c0107031:	85 c0                	test   %eax,%eax
c0107033:	74 08                	je     c010703d <_clock_swap_out_victim+0x2a2>
            {
                selected = p;
c0107035:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107038:	89 45 f4             	mov    %eax,-0xc(%ebp)
                break;
c010703b:	eb 17                	jmp    c0107054 <_clock_swap_out_victim+0x2b9>
c010703d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107040:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0107043:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107046:	8b 40 04             	mov    0x4(%eax),%eax
            }
            p = list_next(p);
c0107049:	89 45 f0             	mov    %eax,-0x10(%ebp)
        } while (p != head);
c010704c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010704f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107052:	75 89                	jne    c0106fdd <_clock_swap_out_victim+0x242>
    // Remove pointed element
    head = selected;
c0107054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107057:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010705a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010705d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return list->next == list;
c0107060:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107063:	8b 40 04             	mov    0x4(%eax),%eax
c0107066:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0107069:	0f 94 c0             	sete   %al
c010706c:	0f b6 c0             	movzbl %al,%eax
    if (list_empty(head))
c010706f:	85 c0                	test   %eax,%eax
c0107071:	74 0c                	je     c010707f <_clock_swap_out_victim+0x2e4>
    {
        mm->sm_priv = NULL;
c0107073:	8b 45 08             	mov    0x8(%ebp),%eax
c0107076:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
c010707d:	eb 3c                	jmp    c01070bb <_clock_swap_out_victim+0x320>
c010707f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107082:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return listelm->next;
c0107085:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0107088:	8b 50 04             	mov    0x4(%eax),%edx
    }
    else
    {
        mm->sm_priv = list_next(head);
c010708b:	8b 45 08             	mov    0x8(%ebp),%eax
c010708e:	89 50 14             	mov    %edx,0x14(%eax)
c0107091:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107094:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_del(listelm->prev, listelm->next);
c0107097:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010709a:	8b 40 04             	mov    0x4(%eax),%eax
c010709d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01070a0:	8b 12                	mov    (%edx),%edx
c01070a2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01070a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next;
c01070a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01070ab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01070ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01070b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01070b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01070b7:	89 10                	mov    %edx,(%eax)
}
c01070b9:	90                   	nop
}
c01070ba:	90                   	nop
        list_del(head);
    }
    *ptr_page = le2page(head, pra_page_link);
c01070bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070be:	8d 50 ec             	lea    -0x14(%eax),%edx
c01070c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070c4:	89 10                	mov    %edx,(%eax)
    return 0;
c01070c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070cb:	89 ec                	mov    %ebp,%esp
c01070cd:	5d                   	pop    %ebp
c01070ce:	c3                   	ret    

c01070cf <_clock_check_swap>:

static int
_clock_check_swap(void)
{
c01070cf:	55                   	push   %ebp
c01070d0:	89 e5                	mov    %esp,%ebp
c01070d2:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01070d5:	c7 04 24 b0 af 10 c0 	movl   $0xc010afb0,(%esp)
c01070dc:	e8 84 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01070e1:	b8 00 30 00 00       	mov    $0x3000,%eax
c01070e6:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 4);
c01070e9:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01070ee:	83 f8 04             	cmp    $0x4,%eax
c01070f1:	74 24                	je     c0107117 <_clock_check_swap+0x48>
c01070f3:	c7 44 24 0c d6 af 10 	movl   $0xc010afd6,0xc(%esp)
c01070fa:	c0 
c01070fb:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107102:	c0 
c0107103:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c010710a:	00 
c010710b:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107112:	e8 d3 9b ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107117:	c7 04 24 e8 af 10 c0 	movl   $0xc010afe8,(%esp)
c010711e:	e8 42 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107123:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107128:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 4);
c010712b:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107130:	83 f8 04             	cmp    $0x4,%eax
c0107133:	74 24                	je     c0107159 <_clock_check_swap+0x8a>
c0107135:	c7 44 24 0c d6 af 10 	movl   $0xc010afd6,0xc(%esp)
c010713c:	c0 
c010713d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107144:	c0 
c0107145:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c010714c:	00 
c010714d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107154:	e8 91 9b ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107159:	c7 04 24 10 b0 10 c0 	movl   $0xc010b010,(%esp)
c0107160:	e8 00 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107165:	b8 00 40 00 00       	mov    $0x4000,%eax
c010716a:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 4);
c010716d:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107172:	83 f8 04             	cmp    $0x4,%eax
c0107175:	74 24                	je     c010719b <_clock_check_swap+0xcc>
c0107177:	c7 44 24 0c d6 af 10 	movl   $0xc010afd6,0xc(%esp)
c010717e:	c0 
c010717f:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107186:	c0 
c0107187:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010718e:	00 
c010718f:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107196:	e8 4f 9b ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010719b:	c7 04 24 38 b0 10 c0 	movl   $0xc010b038,(%esp)
c01071a2:	e8 be 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01071a7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01071ac:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 4);
c01071af:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01071b4:	83 f8 04             	cmp    $0x4,%eax
c01071b7:	74 24                	je     c01071dd <_clock_check_swap+0x10e>
c01071b9:	c7 44 24 0c d6 af 10 	movl   $0xc010afd6,0xc(%esp)
c01071c0:	c0 
c01071c1:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01071c8:	c0 
c01071c9:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c01071d0:	00 
c01071d1:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01071d8:	e8 0d 9b ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01071dd:	c7 04 24 60 b0 10 c0 	movl   $0xc010b060,(%esp)
c01071e4:	e8 7c 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01071e9:	b8 00 50 00 00       	mov    $0x5000,%eax
c01071ee:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 5);
c01071f1:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01071f6:	83 f8 05             	cmp    $0x5,%eax
c01071f9:	74 24                	je     c010721f <_clock_check_swap+0x150>
c01071fb:	c7 44 24 0c 86 b0 10 	movl   $0xc010b086,0xc(%esp)
c0107202:	c0 
c0107203:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c010720a:	c0 
c010720b:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0107212:	00 
c0107213:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c010721a:	e8 cb 9a ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010721f:	c7 04 24 38 b0 10 c0 	movl   $0xc010b038,(%esp)
c0107226:	e8 3a 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010722b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107230:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 5);
c0107233:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107238:	83 f8 05             	cmp    $0x5,%eax
c010723b:	74 24                	je     c0107261 <_clock_check_swap+0x192>
c010723d:	c7 44 24 0c 86 b0 10 	movl   $0xc010b086,0xc(%esp)
c0107244:	c0 
c0107245:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c010724c:	c0 
c010724d:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c0107254:	00 
c0107255:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c010725c:	e8 89 9a ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107261:	c7 04 24 e8 af 10 c0 	movl   $0xc010afe8,(%esp)
c0107268:	e8 f8 90 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010726d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107272:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 6);
c0107275:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010727a:	83 f8 06             	cmp    $0x6,%eax
c010727d:	74 24                	je     c01072a3 <_clock_check_swap+0x1d4>
c010727f:	c7 44 24 0c 97 b0 10 	movl   $0xc010b097,0xc(%esp)
c0107286:	c0 
c0107287:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c010728e:	c0 
c010728f:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
c0107296:	00 
c0107297:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c010729e:	e8 47 9a ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01072a3:	c7 04 24 38 b0 10 c0 	movl   $0xc010b038,(%esp)
c01072aa:	e8 b6 90 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01072af:	b8 00 20 00 00       	mov    $0x2000,%eax
c01072b4:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 6);
c01072b7:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01072bc:	83 f8 06             	cmp    $0x6,%eax
c01072bf:	74 24                	je     c01072e5 <_clock_check_swap+0x216>
c01072c1:	c7 44 24 0c 97 b0 10 	movl   $0xc010b097,0xc(%esp)
c01072c8:	c0 
c01072c9:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01072d0:	c0 
c01072d1:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
c01072d8:	00 
c01072d9:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01072e0:	e8 05 9a ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01072e5:	c7 04 24 b0 af 10 c0 	movl   $0xc010afb0,(%esp)
c01072ec:	e8 74 90 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01072f1:	b8 00 30 00 00       	mov    $0x3000,%eax
c01072f6:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 7);
c01072f9:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01072fe:	83 f8 07             	cmp    $0x7,%eax
c0107301:	74 24                	je     c0107327 <_clock_check_swap+0x258>
c0107303:	c7 44 24 0c a8 b0 10 	movl   $0xc010b0a8,0xc(%esp)
c010730a:	c0 
c010730b:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107312:	c0 
c0107313:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c010731a:	00 
c010731b:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107322:	e8 c3 99 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107327:	c7 04 24 10 b0 10 c0 	movl   $0xc010b010,(%esp)
c010732e:	e8 32 90 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107333:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107338:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 8);
c010733b:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107340:	83 f8 08             	cmp    $0x8,%eax
c0107343:	74 24                	je     c0107369 <_clock_check_swap+0x29a>
c0107345:	c7 44 24 0c b9 b0 10 	movl   $0xc010b0b9,0xc(%esp)
c010734c:	c0 
c010734d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107354:	c0 
c0107355:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010735c:	00 
c010735d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107364:	e8 81 99 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107369:	c7 04 24 60 b0 10 c0 	movl   $0xc010b060,(%esp)
c0107370:	e8 f0 8f ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107375:	b8 00 50 00 00       	mov    $0x5000,%eax
c010737a:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 9);
c010737d:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107382:	83 f8 09             	cmp    $0x9,%eax
c0107385:	74 24                	je     c01073ab <_clock_check_swap+0x2dc>
c0107387:	c7 44 24 0c ca b0 10 	movl   $0xc010b0ca,0xc(%esp)
c010738e:	c0 
c010738f:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107396:	c0 
c0107397:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c010739e:	00 
c010739f:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01073a6:	e8 3f 99 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01073ab:	c7 04 24 e8 af 10 c0 	movl   $0xc010afe8,(%esp)
c01073b2:	e8 ae 8f ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01073b7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01073bc:	0f b6 00             	movzbl (%eax),%eax
c01073bf:	3c 0a                	cmp    $0xa,%al
c01073c1:	74 24                	je     c01073e7 <_clock_check_swap+0x318>
c01073c3:	c7 44 24 0c dc b0 10 	movl   $0xc010b0dc,0xc(%esp)
c01073ca:	c0 
c01073cb:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01073d2:	c0 
c01073d3:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c01073da:	00 
c01073db:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01073e2:	e8 03 99 ff ff       	call   c0100cea <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01073e7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01073ec:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 9);
c01073ef:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01073f4:	83 f8 09             	cmp    $0x9,%eax
c01073f7:	74 24                	je     c010741d <_clock_check_swap+0x34e>
c01073f9:	c7 44 24 0c ca b0 10 	movl   $0xc010b0ca,0xc(%esp)
c0107400:	c0 
c0107401:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107408:	c0 
c0107409:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0107410:	00 
c0107411:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107418:	e8 cd 98 ff ff       	call   c0100cea <__panic>
    cprintf("read Virt Page b in fifo_check_swap\n");
c010741d:	c7 04 24 00 b1 10 c0 	movl   $0xc010b100,(%esp)
c0107424:	e8 3c 8f ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x2000 == 0x0b);
c0107429:	b8 00 20 00 00       	mov    $0x2000,%eax
c010742e:	0f b6 00             	movzbl (%eax),%eax
c0107431:	3c 0b                	cmp    $0xb,%al
c0107433:	74 24                	je     c0107459 <_clock_check_swap+0x38a>
c0107435:	c7 44 24 0c 28 b1 10 	movl   $0xc010b128,0xc(%esp)
c010743c:	c0 
c010743d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107444:	c0 
c0107445:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c010744c:	00 
c010744d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107454:	e8 91 98 ff ff       	call   c0100cea <__panic>
    assert(pgfault_num == 10);
c0107459:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010745e:	83 f8 0a             	cmp    $0xa,%eax
c0107461:	74 24                	je     c0107487 <_clock_check_swap+0x3b8>
c0107463:	c7 44 24 0c 49 b1 10 	movl   $0xc010b149,0xc(%esp)
c010746a:	c0 
c010746b:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107472:	c0 
c0107473:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010747a:	00 
c010747b:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107482:	e8 63 98 ff ff       	call   c0100cea <__panic>
    cprintf("read Virt Page c in fifo_check_swap\n");
c0107487:	c7 04 24 5c b1 10 c0 	movl   $0xc010b15c,(%esp)
c010748e:	e8 d2 8e ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x3000 == 0x0c);
c0107493:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107498:	0f b6 00             	movzbl (%eax),%eax
c010749b:	3c 0c                	cmp    $0xc,%al
c010749d:	74 24                	je     c01074c3 <_clock_check_swap+0x3f4>
c010749f:	c7 44 24 0c 84 b1 10 	movl   $0xc010b184,0xc(%esp)
c01074a6:	c0 
c01074a7:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01074ae:	c0 
c01074af:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01074b6:	00 
c01074b7:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01074be:	e8 27 98 ff ff       	call   c0100cea <__panic>
    assert(pgfault_num == 11);
c01074c3:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01074c8:	83 f8 0b             	cmp    $0xb,%eax
c01074cb:	74 24                	je     c01074f1 <_clock_check_swap+0x422>
c01074cd:	c7 44 24 0c a5 b1 10 	movl   $0xc010b1a5,0xc(%esp)
c01074d4:	c0 
c01074d5:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01074dc:	c0 
c01074dd:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01074e4:	00 
c01074e5:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01074ec:	e8 f9 97 ff ff       	call   c0100cea <__panic>
    cprintf("read Virt Page a in fifo_check_swap\n");
c01074f1:	c7 04 24 b8 b1 10 c0 	movl   $0xc010b1b8,(%esp)
c01074f8:	e8 68 8e ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01074fd:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107502:	0f b6 00             	movzbl (%eax),%eax
c0107505:	3c 0a                	cmp    $0xa,%al
c0107507:	74 24                	je     c010752d <_clock_check_swap+0x45e>
c0107509:	c7 44 24 0c dc b0 10 	movl   $0xc010b0dc,0xc(%esp)
c0107510:	c0 
c0107511:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107518:	c0 
c0107519:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0107520:	00 
c0107521:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107528:	e8 bd 97 ff ff       	call   c0100cea <__panic>
    assert(pgfault_num == 12);
c010752d:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107532:	83 f8 0c             	cmp    $0xc,%eax
c0107535:	74 24                	je     c010755b <_clock_check_swap+0x48c>
c0107537:	c7 44 24 0c dd b1 10 	movl   $0xc010b1dd,0xc(%esp)
c010753e:	c0 
c010753f:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107546:	c0 
c0107547:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c010754e:	00 
c010754f:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107556:	e8 8f 97 ff ff       	call   c0100cea <__panic>
    cprintf("read Virt Page d in fifo_check_swap\n");
c010755b:	c7 04 24 f0 b1 10 c0 	movl   $0xc010b1f0,(%esp)
c0107562:	e8 fe 8d ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x4000 == 0x0d);
c0107567:	b8 00 40 00 00       	mov    $0x4000,%eax
c010756c:	0f b6 00             	movzbl (%eax),%eax
c010756f:	3c 0d                	cmp    $0xd,%al
c0107571:	74 24                	je     c0107597 <_clock_check_swap+0x4c8>
c0107573:	c7 44 24 0c 18 b2 10 	movl   $0xc010b218,0xc(%esp)
c010757a:	c0 
c010757b:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107582:	c0 
c0107583:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c010758a:	00 
c010758b:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107592:	e8 53 97 ff ff       	call   c0100cea <__panic>
    assert(pgfault_num == 13);
c0107597:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010759c:	83 f8 0d             	cmp    $0xd,%eax
c010759f:	74 24                	je     c01075c5 <_clock_check_swap+0x4f6>
c01075a1:	c7 44 24 0c 39 b2 10 	movl   $0xc010b239,0xc(%esp)
c01075a8:	c0 
c01075a9:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01075b0:	c0 
c01075b1:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01075b8:	00 
c01075b9:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01075c0:	e8 25 97 ff ff       	call   c0100cea <__panic>
    cprintf("read Virt Page b in fifo_check_swap\n");
c01075c5:	c7 04 24 00 b1 10 c0 	movl   $0xc010b100,(%esp)
c01075cc:	e8 94 8d ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01075d1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01075d6:	c6 00 0a             	movb   $0xa,(%eax)
    assert(*(unsigned char *)0x3000 == 0x0c);
c01075d9:	b8 00 30 00 00       	mov    $0x3000,%eax
c01075de:	0f b6 00             	movzbl (%eax),%eax
c01075e1:	3c 0c                	cmp    $0xc,%al
c01075e3:	74 24                	je     c0107609 <_clock_check_swap+0x53a>
c01075e5:	c7 44 24 0c 84 b1 10 	movl   $0xc010b184,0xc(%esp)
c01075ec:	c0 
c01075ed:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01075f4:	c0 
c01075f5:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c01075fc:	00 
c01075fd:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107604:	e8 e1 96 ff ff       	call   c0100cea <__panic>
    assert(*(unsigned char *)0x4000 == 0x0d);
c0107609:	b8 00 40 00 00       	mov    $0x4000,%eax
c010760e:	0f b6 00             	movzbl (%eax),%eax
c0107611:	3c 0d                	cmp    $0xd,%al
c0107613:	74 24                	je     c0107639 <_clock_check_swap+0x56a>
c0107615:	c7 44 24 0c 18 b2 10 	movl   $0xc010b218,0xc(%esp)
c010761c:	c0 
c010761d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107624:	c0 
c0107625:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010762c:	00 
c010762d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107634:	e8 b1 96 ff ff       	call   c0100cea <__panic>
    assert(*(unsigned char *)0x5000 == 0x0e);
c0107639:	b8 00 50 00 00       	mov    $0x5000,%eax
c010763e:	0f b6 00             	movzbl (%eax),%eax
c0107641:	3c 0e                	cmp    $0xe,%al
c0107643:	74 24                	je     c0107669 <_clock_check_swap+0x59a>
c0107645:	c7 44 24 0c 4c b2 10 	movl   $0xc010b24c,0xc(%esp)
c010764c:	c0 
c010764d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107654:	c0 
c0107655:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c010765c:	00 
c010765d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107664:	e8 81 96 ff ff       	call   c0100cea <__panic>
    assert(*(unsigned char *)0x2000 == 0x0b);
c0107669:	b8 00 20 00 00       	mov    $0x2000,%eax
c010766e:	0f b6 00             	movzbl (%eax),%eax
c0107671:	3c 0b                	cmp    $0xb,%al
c0107673:	74 24                	je     c0107699 <_clock_check_swap+0x5ca>
c0107675:	c7 44 24 0c 28 b1 10 	movl   $0xc010b128,0xc(%esp)
c010767c:	c0 
c010767d:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c0107684:	c0 
c0107685:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c010768c:	00 
c010768d:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c0107694:	e8 51 96 ff ff       	call   c0100cea <__panic>
    assert(pgfault_num == 14);
c0107699:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010769e:	83 f8 0e             	cmp    $0xe,%eax
c01076a1:	74 24                	je     c01076c7 <_clock_check_swap+0x5f8>
c01076a3:	c7 44 24 0c 6d b2 10 	movl   $0xc010b26d,0xc(%esp)
c01076aa:	c0 
c01076ab:	c7 44 24 08 6a af 10 	movl   $0xc010af6a,0x8(%esp)
c01076b2:	c0 
c01076b3:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c01076ba:	00 
c01076bb:	c7 04 24 7f af 10 c0 	movl   $0xc010af7f,(%esp)
c01076c2:	e8 23 96 ff ff       	call   c0100cea <__panic>
    return 0;
c01076c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01076cc:	89 ec                	mov    %ebp,%esp
c01076ce:	5d                   	pop    %ebp
c01076cf:	c3                   	ret    

c01076d0 <_clock_init>:

static int
_clock_init(void)
{
c01076d0:	55                   	push   %ebp
c01076d1:	89 e5                	mov    %esp,%ebp
    return 0;
c01076d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01076d8:	5d                   	pop    %ebp
c01076d9:	c3                   	ret    

c01076da <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01076da:	55                   	push   %ebp
c01076db:	89 e5                	mov    %esp,%ebp
    return 0;
c01076dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01076e2:	5d                   	pop    %ebp
c01076e3:	c3                   	ret    

c01076e4 <_clock_tick_event>:

_clock_tick_event(struct mm_struct *mm)
{
c01076e4:	55                   	push   %ebp
c01076e5:	89 e5                	mov    %esp,%ebp
    return 0;
c01076e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01076ec:	5d                   	pop    %ebp
c01076ed:	c3                   	ret    

c01076ee <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{
c01076ee:	55                   	push   %ebp
c01076ef:	89 e5                	mov    %esp,%ebp
c01076f1:	83 ec 10             	sub    $0x10,%esp
c01076f4:	c7 45 fc 04 81 12 c0 	movl   $0xc0128104,-0x4(%ebp)
    elm->prev = elm->next = elm;
c01076fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107701:	89 50 04             	mov    %edx,0x4(%eax)
c0107704:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107707:	8b 50 04             	mov    0x4(%eax),%edx
c010770a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010770d:	89 10                	mov    %edx,(%eax)
}
c010770f:	90                   	nop
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
c0107710:	8b 45 08             	mov    0x8(%ebp),%eax
c0107713:	c7 40 14 04 81 12 c0 	movl   $0xc0128104,0x14(%eax)
    // cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
    return 0;
c010771a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010771f:	89 ec                	mov    %ebp,%esp
c0107721:	5d                   	pop    %ebp
c0107722:	c3                   	ret    

c0107723 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107723:	55                   	push   %ebp
c0107724:	89 e5                	mov    %esp,%ebp
c0107726:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0107729:	8b 45 08             	mov    0x8(%ebp),%eax
c010772c:	8b 40 14             	mov    0x14(%eax),%eax
c010772f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry = &(page->pra_page_link);
c0107732:	8b 45 10             	mov    0x10(%ebp),%eax
c0107735:	83 c0 14             	add    $0x14,%eax
c0107738:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(entry != NULL && head != NULL);
c010773b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010773f:	74 06                	je     c0107747 <_fifo_map_swappable+0x24>
c0107741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107745:	75 24                	jne    c010776b <_fifo_map_swappable+0x48>
c0107747:	c7 44 24 0c 94 b2 10 	movl   $0xc010b294,0xc(%esp)
c010774e:	c0 
c010774f:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107756:	c0 
c0107757:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
c010775e:	00 
c010775f:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107766:	e8 7f 95 ff ff       	call   c0100cea <__panic>
c010776b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010776e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107771:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107774:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107777:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010777a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010777d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107780:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c0107783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107786:	8b 40 04             	mov    0x4(%eax),%eax
c0107789:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010778c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010778f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107792:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0107798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010779b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010779e:	89 10                	mov    %edx,(%eax)
c01077a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01077a3:	8b 10                	mov    (%eax),%edx
c01077a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01077a8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01077ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01077b1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01077b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01077ba:	89 10                	mov    %edx,(%eax)
}
c01077bc:	90                   	nop
}
c01077bd:	90                   	nop
}
c01077be:	90                   	nop
    list_add(head, entry); //将最近用到的页面添加到次序队尾
    return 0;
c01077bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01077c4:	89 ec                	mov    %ebp,%esp
c01077c6:	5d                   	pop    %ebp
c01077c7:	c3                   	ret    

c01077c8 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick)
{
c01077c8:	55                   	push   %ebp
c01077c9:	89 e5                	mov    %esp,%ebp
c01077cb:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c01077ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01077d1:	8b 40 14             	mov    0x14(%eax),%eax
c01077d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(head != NULL);
c01077d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077db:	75 24                	jne    c0107801 <_fifo_swap_out_victim+0x39>
c01077dd:	c7 44 24 0c db b2 10 	movl   $0xc010b2db,0xc(%esp)
c01077e4:	c0 
c01077e5:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c01077ec:	c0 
c01077ed:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
c01077f4:	00 
c01077f5:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c01077fc:	e8 e9 94 ff ff       	call   c0100cea <__panic>
    assert(in_tick == 0);
c0107801:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107805:	74 24                	je     c010782b <_fifo_swap_out_victim+0x63>
c0107807:	c7 44 24 0c e8 b2 10 	movl   $0xc010b2e8,0xc(%esp)
c010780e:	c0 
c010780f:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107816:	c0 
c0107817:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
c010781e:	00 
c010781f:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107826:	e8 bf 94 ff ff       	call   c0100cea <__panic>
    list_entry_t *le = head->prev; // 取出链表头，即最早进入的物理页面
c010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010782e:	8b 00                	mov    (%eax),%eax
c0107830:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(head != le);            // 确保链表非空
c0107833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107836:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107839:	75 24                	jne    c010785f <_fifo_swap_out_victim+0x97>
c010783b:	c7 44 24 0c f5 b2 10 	movl   $0xc010b2f5,0xc(%esp)
c0107842:	c0 
c0107843:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c010784a:	c0 
c010784b:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0107852:	00 
c0107853:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c010785a:	e8 8b 94 ff ff       	call   c0100cea <__panic>
    struct Page *p = le2page(le, pra_page_link);
c010785f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107862:	83 e8 14             	sub    $0x14,%eax
c0107865:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107868:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010786b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c010786e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107871:	8b 40 04             	mov    0x4(%eax),%eax
c0107874:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107877:	8b 12                	mov    (%edx),%edx
c0107879:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010787c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c010787f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107882:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107885:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107888:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010788b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010788e:	89 10                	mov    %edx,(%eax)
}
c0107890:	90                   	nop
}
c0107891:	90                   	nop
    //找到对应的物理页面的Page结构
    list_del(le); //将进来最早的页面从队列中删除
    assert(p != NULL);
c0107892:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107896:	75 24                	jne    c01078bc <_fifo_swap_out_victim+0xf4>
c0107898:	c7 44 24 0c 00 b3 10 	movl   $0xc010b300,0xc(%esp)
c010789f:	c0 
c01078a0:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c01078a7:	c0 
c01078a8:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
c01078af:	00 
c01078b0:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c01078b7:	e8 2e 94 ff ff       	call   c0100cea <__panic>
    *ptr_page = p; //将这一页的地址存储在ptr_page中
c01078bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01078c2:	89 10                	mov    %edx,(%eax)
    return 0;
c01078c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01078c9:	89 ec                	mov    %ebp,%esp
c01078cb:	5d                   	pop    %ebp
c01078cc:	c3                   	ret    

c01078cd <_fifo_check_swap>:

static int
_fifo_check_swap(void)
{
c01078cd:	55                   	push   %ebp
c01078ce:	89 e5                	mov    %esp,%ebp
c01078d0:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01078d3:	c7 04 24 0c b3 10 c0 	movl   $0xc010b30c,(%esp)
c01078da:	e8 86 8a ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01078df:	b8 00 30 00 00       	mov    $0x3000,%eax
c01078e4:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 4);
c01078e7:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01078ec:	83 f8 04             	cmp    $0x4,%eax
c01078ef:	74 24                	je     c0107915 <_fifo_check_swap+0x48>
c01078f1:	c7 44 24 0c 32 b3 10 	movl   $0xc010b332,0xc(%esp)
c01078f8:	c0 
c01078f9:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107900:	c0 
c0107901:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
c0107908:	00 
c0107909:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107910:	e8 d5 93 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107915:	c7 04 24 44 b3 10 c0 	movl   $0xc010b344,(%esp)
c010791c:	e8 44 8a ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107921:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107926:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 4);
c0107929:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c010792e:	83 f8 04             	cmp    $0x4,%eax
c0107931:	74 24                	je     c0107957 <_fifo_check_swap+0x8a>
c0107933:	c7 44 24 0c 32 b3 10 	movl   $0xc010b332,0xc(%esp)
c010793a:	c0 
c010793b:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107942:	c0 
c0107943:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c010794a:	00 
c010794b:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107952:	e8 93 93 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107957:	c7 04 24 6c b3 10 c0 	movl   $0xc010b36c,(%esp)
c010795e:	e8 02 8a ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107963:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107968:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 4);
c010796b:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107970:	83 f8 04             	cmp    $0x4,%eax
c0107973:	74 24                	je     c0107999 <_fifo_check_swap+0xcc>
c0107975:	c7 44 24 0c 32 b3 10 	movl   $0xc010b332,0xc(%esp)
c010797c:	c0 
c010797d:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107984:	c0 
c0107985:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c010798c:	00 
c010798d:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107994:	e8 51 93 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107999:	c7 04 24 94 b3 10 c0 	movl   $0xc010b394,(%esp)
c01079a0:	e8 c0 89 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01079a5:	b8 00 20 00 00       	mov    $0x2000,%eax
c01079aa:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 4);
c01079ad:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01079b2:	83 f8 04             	cmp    $0x4,%eax
c01079b5:	74 24                	je     c01079db <_fifo_check_swap+0x10e>
c01079b7:	c7 44 24 0c 32 b3 10 	movl   $0xc010b332,0xc(%esp)
c01079be:	c0 
c01079bf:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c01079c6:	c0 
c01079c7:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c01079ce:	00 
c01079cf:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c01079d6:	e8 0f 93 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01079db:	c7 04 24 bc b3 10 c0 	movl   $0xc010b3bc,(%esp)
c01079e2:	e8 7e 89 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01079e7:	b8 00 50 00 00       	mov    $0x5000,%eax
c01079ec:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 5);
c01079ef:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c01079f4:	83 f8 05             	cmp    $0x5,%eax
c01079f7:	74 24                	je     c0107a1d <_fifo_check_swap+0x150>
c01079f9:	c7 44 24 0c e2 b3 10 	movl   $0xc010b3e2,0xc(%esp)
c0107a00:	c0 
c0107a01:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107a08:	c0 
c0107a09:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0107a10:	00 
c0107a11:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107a18:	e8 cd 92 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107a1d:	c7 04 24 94 b3 10 c0 	movl   $0xc010b394,(%esp)
c0107a24:	e8 3c 89 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107a29:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107a2e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 5);
c0107a31:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107a36:	83 f8 05             	cmp    $0x5,%eax
c0107a39:	74 24                	je     c0107a5f <_fifo_check_swap+0x192>
c0107a3b:	c7 44 24 0c e2 b3 10 	movl   $0xc010b3e2,0xc(%esp)
c0107a42:	c0 
c0107a43:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107a4a:	c0 
c0107a4b:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0107a52:	00 
c0107a53:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107a5a:	e8 8b 92 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107a5f:	c7 04 24 44 b3 10 c0 	movl   $0xc010b344,(%esp)
c0107a66:	e8 fa 88 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107a6b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107a70:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 6);
c0107a73:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107a78:	83 f8 06             	cmp    $0x6,%eax
c0107a7b:	74 24                	je     c0107aa1 <_fifo_check_swap+0x1d4>
c0107a7d:	c7 44 24 0c f3 b3 10 	movl   $0xc010b3f3,0xc(%esp)
c0107a84:	c0 
c0107a85:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107a8c:	c0 
c0107a8d:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107a94:	00 
c0107a95:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107a9c:	e8 49 92 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107aa1:	c7 04 24 94 b3 10 c0 	movl   $0xc010b394,(%esp)
c0107aa8:	e8 b8 88 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107aad:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107ab2:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num == 7);
c0107ab5:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107aba:	83 f8 07             	cmp    $0x7,%eax
c0107abd:	74 24                	je     c0107ae3 <_fifo_check_swap+0x216>
c0107abf:	c7 44 24 0c 04 b4 10 	movl   $0xc010b404,0xc(%esp)
c0107ac6:	c0 
c0107ac7:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107ace:	c0 
c0107acf:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107ad6:	00 
c0107ad7:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107ade:	e8 07 92 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107ae3:	c7 04 24 0c b3 10 c0 	movl   $0xc010b30c,(%esp)
c0107aea:	e8 76 88 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107aef:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107af4:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num == 8);
c0107af7:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107afc:	83 f8 08             	cmp    $0x8,%eax
c0107aff:	74 24                	je     c0107b25 <_fifo_check_swap+0x258>
c0107b01:	c7 44 24 0c 15 b4 10 	movl   $0xc010b415,0xc(%esp)
c0107b08:	c0 
c0107b09:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107b10:	c0 
c0107b11:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107b18:	00 
c0107b19:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107b20:	e8 c5 91 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107b25:	c7 04 24 6c b3 10 c0 	movl   $0xc010b36c,(%esp)
c0107b2c:	e8 34 88 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107b31:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107b36:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num == 9);
c0107b39:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107b3e:	83 f8 09             	cmp    $0x9,%eax
c0107b41:	74 24                	je     c0107b67 <_fifo_check_swap+0x29a>
c0107b43:	c7 44 24 0c 26 b4 10 	movl   $0xc010b426,0xc(%esp)
c0107b4a:	c0 
c0107b4b:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107b52:	c0 
c0107b53:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107b5a:	00 
c0107b5b:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107b62:	e8 83 91 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107b67:	c7 04 24 bc b3 10 c0 	movl   $0xc010b3bc,(%esp)
c0107b6e:	e8 f2 87 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107b73:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107b78:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num == 10);
c0107b7b:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107b80:	83 f8 0a             	cmp    $0xa,%eax
c0107b83:	74 24                	je     c0107ba9 <_fifo_check_swap+0x2dc>
c0107b85:	c7 44 24 0c 37 b4 10 	movl   $0xc010b437,0xc(%esp)
c0107b8c:	c0 
c0107b8d:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107b94:	c0 
c0107b95:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107b9c:	00 
c0107b9d:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107ba4:	e8 41 91 ff ff       	call   c0100cea <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107ba9:	c7 04 24 44 b3 10 c0 	movl   $0xc010b344,(%esp)
c0107bb0:	e8 b0 87 ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c0107bb5:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107bba:	0f b6 00             	movzbl (%eax),%eax
c0107bbd:	3c 0a                	cmp    $0xa,%al
c0107bbf:	74 24                	je     c0107be5 <_fifo_check_swap+0x318>
c0107bc1:	c7 44 24 0c 4c b4 10 	movl   $0xc010b44c,0xc(%esp)
c0107bc8:	c0 
c0107bc9:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107bd0:	c0 
c0107bd1:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c0107bd8:	00 
c0107bd9:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107be0:	e8 05 91 ff ff       	call   c0100cea <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107be5:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107bea:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num == 11);
c0107bed:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0107bf2:	83 f8 0b             	cmp    $0xb,%eax
c0107bf5:	74 24                	je     c0107c1b <_fifo_check_swap+0x34e>
c0107bf7:	c7 44 24 0c 6d b4 10 	movl   $0xc010b46d,0xc(%esp)
c0107bfe:	c0 
c0107bff:	c7 44 24 08 b2 b2 10 	movl   $0xc010b2b2,0x8(%esp)
c0107c06:	c0 
c0107c07:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107c0e:	00 
c0107c0f:	c7 04 24 c7 b2 10 c0 	movl   $0xc010b2c7,(%esp)
c0107c16:	e8 cf 90 ff ff       	call   c0100cea <__panic>
    return 0;
c0107c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107c20:	89 ec                	mov    %ebp,%esp
c0107c22:	5d                   	pop    %ebp
c0107c23:	c3                   	ret    

c0107c24 <_fifo_init>:

static int
_fifo_init(void)
{
c0107c24:	55                   	push   %ebp
c0107c25:	89 e5                	mov    %esp,%ebp
    return 0;
c0107c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107c2c:	5d                   	pop    %ebp
c0107c2d:	c3                   	ret    

c0107c2e <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107c2e:	55                   	push   %ebp
c0107c2f:	89 e5                	mov    %esp,%ebp
    return 0;
c0107c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107c36:	5d                   	pop    %ebp
c0107c37:	c3                   	ret    

c0107c38 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{
c0107c38:	55                   	push   %ebp
c0107c39:	89 e5                	mov    %esp,%ebp
    return 0;
c0107c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107c40:	5d                   	pop    %ebp
c0107c41:	c3                   	ret    

c0107c42 <pa2page>:
pa2page(uintptr_t pa) {
c0107c42:	55                   	push   %ebp
c0107c43:	89 e5                	mov    %esp,%ebp
c0107c45:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c4b:	c1 e8 0c             	shr    $0xc,%eax
c0107c4e:	89 c2                	mov    %eax,%edx
c0107c50:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0107c55:	39 c2                	cmp    %eax,%edx
c0107c57:	72 1c                	jb     c0107c75 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107c59:	c7 44 24 08 94 b4 10 	movl   $0xc010b494,0x8(%esp)
c0107c60:	c0 
c0107c61:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107c68:	00 
c0107c69:	c7 04 24 b3 b4 10 c0 	movl   $0xc010b4b3,(%esp)
c0107c70:	e8 75 90 ff ff       	call   c0100cea <__panic>
    return &pages[PPN(pa)];
c0107c75:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c0107c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c7e:	c1 e8 0c             	shr    $0xc,%eax
c0107c81:	c1 e0 05             	shl    $0x5,%eax
c0107c84:	01 d0                	add    %edx,%eax
}
c0107c86:	89 ec                	mov    %ebp,%esp
c0107c88:	5d                   	pop    %ebp
c0107c89:	c3                   	ret    

c0107c8a <pde2page>:
pde2page(pde_t pde) {
c0107c8a:	55                   	push   %ebp
c0107c8b:	89 e5                	mov    %esp,%ebp
c0107c8d:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c98:	89 04 24             	mov    %eax,(%esp)
c0107c9b:	e8 a2 ff ff ff       	call   c0107c42 <pa2page>
}
c0107ca0:	89 ec                	mov    %ebp,%esp
c0107ca2:	5d                   	pop    %ebp
c0107ca3:	c3                   	ret    

c0107ca4 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *mm_create(void)
{
c0107ca4:	55                   	push   %ebp
c0107ca5:	89 e5                	mov    %esp,%ebp
c0107ca7:	83 ec 28             	sub    $0x28,%esp
    // 分配空间
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107caa:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107cb1:	e8 b8 e2 ff ff       	call   c0105f6e <kmalloc>
c0107cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL)
c0107cb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107cbd:	74 59                	je     c0107d18 <mm_create+0x74>
    {
        // 初始化双向链表
        list_init(&(mm->mmap_list));
c0107cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
c0107cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107ccb:	89 50 04             	mov    %edx,0x4(%eax)
c0107cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cd1:	8b 50 04             	mov    0x4(%eax),%edx
c0107cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cd7:	89 10                	mov    %edx,(%eax)
}
c0107cd9:	90                   	nop
        // 初始化变量
        mm->mmap_cache = NULL;
c0107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cdd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ce7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cf1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        //交换分区的初始化
        if (swap_init_ok)
c0107cf8:	a1 44 80 12 c0       	mov    0xc0128044,%eax
c0107cfd:	85 c0                	test   %eax,%eax
c0107cff:	74 0d                	je     c0107d0e <mm_create+0x6a>
            swap_init_mm(mm);
c0107d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d04:	89 04 24             	mov    %eax,(%esp)
c0107d07:	e8 bb e4 ff ff       	call   c01061c7 <swap_init_mm>
c0107d0c:	eb 0a                	jmp    c0107d18 <mm_create+0x74>
        else
            mm->sm_priv = NULL;
c0107d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d11:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107d1b:	89 ec                	mov    %ebp,%esp
c0107d1d:	5d                   	pop    %ebp
c0107d1e:	c3                   	ret    

c0107d1f <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags)
{
c0107d1f:	55                   	push   %ebp
c0107d20:	89 e5                	mov    %esp,%ebp
c0107d22:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107d25:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107d2c:	e8 3d e2 ff ff       	call   c0105f6e <kmalloc>
c0107d31:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL)
c0107d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107d38:	74 1b                	je     c0107d55 <vma_create+0x36>
    {
        vma->vm_start = vm_start;
c0107d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d40:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107d49:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d4f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d52:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107d58:	89 ec                	mov    %ebp,%esp
c0107d5a:	5d                   	pop    %ebp
c0107d5b:	c3                   	ret    

c0107d5c <find_vma>:

// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *find_vma(struct mm_struct *mm, uintptr_t addr)
{
c0107d5c:	55                   	push   %ebp
c0107d5d:	89 e5                	mov    %esp,%ebp
c0107d5f:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107d62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL)
c0107d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107d6d:	0f 84 95 00 00 00    	je     c0107e08 <find_vma+0xac>
    {
        vma = mm->mmap_cache;
c0107d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d76:	8b 40 08             	mov    0x8(%eax),%eax
c0107d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
        // 如果cache这个vma不满足再循环遍历去找
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
c0107d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107d80:	74 16                	je     c0107d98 <find_vma+0x3c>
c0107d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d85:	8b 40 04             	mov    0x4(%eax),%eax
c0107d88:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107d8b:	72 0b                	jb     c0107d98 <find_vma+0x3c>
c0107d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d90:	8b 40 08             	mov    0x8(%eax),%eax
c0107d93:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107d96:	72 61                	jb     c0107df9 <find_vma+0x9d>
        {
            bool found = 0;
c0107d98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
            // 这里从链表头开始找
            list_entry_t *list = &(mm->mmap_list), *le = list;
c0107d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            while ((le = list_next(le)) != list)
c0107dab:	eb 28                	jmp    c0107dd5 <find_vma+0x79>
            {
                vma = le2vma(le, list_link);
c0107dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107db0:	83 e8 10             	sub    $0x10,%eax
c0107db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
                if (vma->vm_start <= addr && addr < vma->vm_end)
c0107db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107db9:	8b 40 04             	mov    0x4(%eax),%eax
c0107dbc:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107dbf:	72 14                	jb     c0107dd5 <find_vma+0x79>
c0107dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107dc4:	8b 40 08             	mov    0x8(%eax),%eax
c0107dc7:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107dca:	73 09                	jae    c0107dd5 <find_vma+0x79>
                {
                    found = 1;
c0107dcc:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                    break;
c0107dd3:	eb 17                	jmp    c0107dec <find_vma+0x90>
c0107dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return listelm->next;
c0107ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107dde:	8b 40 04             	mov    0x4(%eax),%eax
            while ((le = list_next(le)) != list)
c0107de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107de7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107dea:	75 c1                	jne    c0107dad <find_vma+0x51>
                }
            }
            if (!found)
c0107dec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107df0:	75 07                	jne    c0107df9 <find_vma+0x9d>
            {
                vma = NULL;
c0107df2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
            }
        }
        if (vma != NULL)
c0107df9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107dfd:	74 09                	je     c0107e08 <find_vma+0xac>
        {
            // 最后再更新cache
            mm->mmap_cache = vma;
c0107dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e02:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107e05:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107e0b:	89 ec                	mov    %ebp,%esp
c0107e0d:	5d                   	pop    %ebp
c0107e0e:	c3                   	ret    

c0107e0f <check_vma_overlap>:

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
{
c0107e0f:	55                   	push   %ebp
c0107e10:	89 e5                	mov    %esp,%ebp
c0107e12:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e18:	8b 50 04             	mov    0x4(%eax),%edx
c0107e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e1e:	8b 40 08             	mov    0x8(%eax),%eax
c0107e21:	39 c2                	cmp    %eax,%edx
c0107e23:	72 24                	jb     c0107e49 <check_vma_overlap+0x3a>
c0107e25:	c7 44 24 0c c1 b4 10 	movl   $0xc010b4c1,0xc(%esp)
c0107e2c:	c0 
c0107e2d:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0107e34:	c0 
c0107e35:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0107e3c:	00 
c0107e3d:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0107e44:	e8 a1 8e ff ff       	call   c0100cea <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e4c:	8b 50 08             	mov    0x8(%eax),%edx
c0107e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e52:	8b 40 04             	mov    0x4(%eax),%eax
c0107e55:	39 c2                	cmp    %eax,%edx
c0107e57:	76 24                	jbe    c0107e7d <check_vma_overlap+0x6e>
c0107e59:	c7 44 24 0c 04 b5 10 	movl   $0xc010b504,0xc(%esp)
c0107e60:	c0 
c0107e61:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0107e68:	c0 
c0107e69:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0107e70:	00 
c0107e71:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0107e78:	e8 6d 8e ff ff       	call   c0100cea <__panic>
    assert(next->vm_start < next->vm_end);
c0107e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e80:	8b 50 04             	mov    0x4(%eax),%edx
c0107e83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e86:	8b 40 08             	mov    0x8(%eax),%eax
c0107e89:	39 c2                	cmp    %eax,%edx
c0107e8b:	72 24                	jb     c0107eb1 <check_vma_overlap+0xa2>
c0107e8d:	c7 44 24 0c 23 b5 10 	movl   $0xc010b523,0xc(%esp)
c0107e94:	c0 
c0107e95:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0107e9c:	c0 
c0107e9d:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0107ea4:	00 
c0107ea5:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0107eac:	e8 39 8e ff ff       	call   c0100cea <__panic>
}
c0107eb1:	90                   	nop
c0107eb2:	89 ec                	mov    %ebp,%esp
c0107eb4:	5d                   	pop    %ebp
c0107eb5:	c3                   	ret    

c0107eb6 <insert_vma_struct>:

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
c0107eb6:	55                   	push   %ebp
c0107eb7:	89 e5                	mov    %esp,%ebp
c0107eb9:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ebf:	8b 50 04             	mov    0x4(%eax),%edx
c0107ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ec5:	8b 40 08             	mov    0x8(%eax),%eax
c0107ec8:	39 c2                	cmp    %eax,%edx
c0107eca:	72 24                	jb     c0107ef0 <insert_vma_struct+0x3a>
c0107ecc:	c7 44 24 0c 41 b5 10 	movl   $0xc010b541,0xc(%esp)
c0107ed3:	c0 
c0107ed4:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0107edb:	c0 
c0107edc:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0107ee3:	00 
c0107ee4:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0107eeb:	e8 fa 8d ff ff       	call   c0100cea <__panic>
    // 也是从头开始找 一个prev 一个next 是为了检测重合
    list_entry_t *list = &(mm->mmap_list);
c0107ef0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ef3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = list;
c0107efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le = list_next(le)) != list)
c0107f02:	eb 1f                	jmp    c0107f23 <insert_vma_struct+0x6d>
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f07:	83 e8 10             	sub    $0x10,%eax
c0107f0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (mmap_prev->vm_start > vma->vm_start)
c0107f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f10:	8b 50 04             	mov    0x4(%eax),%edx
c0107f13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f16:	8b 40 04             	mov    0x4(%eax),%eax
c0107f19:	39 c2                	cmp    %eax,%edx
c0107f1b:	77 1f                	ja     c0107f3c <insert_vma_struct+0x86>
        {
            break;
        }
        le_prev = le;
c0107f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f26:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f2c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != list)
c0107f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f35:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107f38:	75 ca                	jne    c0107f04 <insert_vma_struct+0x4e>
c0107f3a:	eb 01                	jmp    c0107f3d <insert_vma_struct+0x87>
            break;
c0107f3c:	90                   	nop
c0107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f40:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107f43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f46:	8b 40 04             	mov    0x4(%eax),%eax
    }

    le_next = list_next(le_prev);
c0107f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    /* check overlap */
    // 检查两次 prev和vma 以及 vma和next 因为最终顺序是 prev vma next 两两之间都不重合
    if (le_prev != list)
c0107f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107f52:	74 15                	je     c0107f69 <insert_vma_struct+0xb3>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f57:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f61:	89 14 24             	mov    %edx,(%esp)
c0107f64:	e8 a6 fe ff ff       	call   c0107e0f <check_vma_overlap>
    }
    if (le_next != list)
c0107f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f6c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107f6f:	74 15                	je     c0107f86 <insert_vma_struct+0xd0>
    {
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f74:	83 e8 10             	sub    $0x10,%eax
c0107f77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f7e:	89 04 24             	mov    %eax,(%esp)
c0107f81:	e8 89 fe ff ff       	call   c0107e0f <check_vma_overlap>
    }
    // 给vma设置其mm，并插入到之前找到的位置
    vma->vm_mm = mm;
c0107f86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f89:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f8c:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f91:	8d 50 10             	lea    0x10(%eax),%edx
c0107f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f97:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107f9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0107f9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107fa0:	8b 40 04             	mov    0x4(%eax),%eax
c0107fa3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107fa6:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107fa9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107fac:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107faf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0107fb2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107fb5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107fb8:	89 10                	mov    %edx,(%eax)
c0107fba:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107fbd:	8b 10                	mov    (%eax),%edx
c0107fbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107fc2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107fc8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107fcb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107fd1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107fd4:	89 10                	mov    %edx,(%eax)
}
c0107fd6:	90                   	nop
}
c0107fd7:	90                   	nop
    // 给mm中记录vma数量的变量count加一
    mm->map_count++;
c0107fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fdb:	8b 40 10             	mov    0x10(%eax),%eax
c0107fde:	8d 50 01             	lea    0x1(%eax),%edx
c0107fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe4:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107fe7:	90                   	nop
c0107fe8:	89 ec                	mov    %ebp,%esp
c0107fea:	5d                   	pop    %ebp
c0107feb:	c3                   	ret    

c0107fec <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
c0107fec:	55                   	push   %ebp
c0107fed:	89 e5                	mov    %esp,%ebp
c0107fef:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *list = &(mm->mmap_list), *le;
c0107ff2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 从头部开始循环释放
    while ((le = list_next(list)) != list)
c0107ff8:	eb 40                	jmp    c010803a <mm_destroy+0x4e>
c0107ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ffd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c0108000:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108003:	8b 40 04             	mov    0x4(%eax),%eax
c0108006:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108009:	8b 12                	mov    (%edx),%edx
c010800b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010800e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    prev->next = next;
c0108011:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108014:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108017:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010801a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010801d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108020:	89 10                	mov    %edx,(%eax)
}
c0108022:	90                   	nop
}
c0108023:	90                   	nop
    {
        // 删除头部第一个vma
        // 注意循环条件之中 list_next(list) 一直再取第一个vma，因为每次都删除第一个vma
        list_del(le);
        // 释放所占的内存区域
        kfree(le2vma(le, list_link), sizeof(struct vma_struct)); // kfree vma
c0108024:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108027:	83 e8 10             	sub    $0x10,%eax
c010802a:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0108031:	00 
c0108032:	89 04 24             	mov    %eax,(%esp)
c0108035:	e8 d6 df ff ff       	call   c0106010 <kfree>
c010803a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010803d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0108040:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108043:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list)
c0108046:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108049:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010804c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010804f:	75 a9                	jne    c0107ffa <mm_destroy+0xe>
    }
    // vma都释放完了再释放mm
    kfree(mm, sizeof(struct mm_struct)); // kfree mm
c0108051:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0108058:	00 
c0108059:	8b 45 08             	mov    0x8(%ebp),%eax
c010805c:	89 04 24             	mov    %eax,(%esp)
c010805f:	e8 ac df ff ff       	call   c0106010 <kfree>
    mm = NULL;
c0108064:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010806b:	90                   	nop
c010806c:	89 ec                	mov    %ebp,%esp
c010806e:	5d                   	pop    %ebp
c010806f:	c3                   	ret    

c0108070 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
c0108070:	55                   	push   %ebp
c0108071:	89 e5                	mov    %esp,%ebp
c0108073:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0108076:	e8 05 00 00 00       	call   c0108080 <check_vmm>
}
c010807b:	90                   	nop
c010807c:	89 ec                	mov    %ebp,%esp
c010807e:	5d                   	pop    %ebp
c010807f:	c3                   	ret    

c0108080 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void)
{
c0108080:	55                   	push   %ebp
c0108081:	89 e5                	mov    %esp,%ebp
c0108083:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108086:	e8 ff c7 ff ff       	call   c010488a <nr_free_pages>
c010808b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    check_vma_struct();
c010808e:	e8 44 00 00 00       	call   c01080d7 <check_vma_struct>
    check_pgfault();
c0108093:	e8 01 05 00 00       	call   c0108599 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0108098:	e8 ed c7 ff ff       	call   c010488a <nr_free_pages>
c010809d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01080a0:	74 24                	je     c01080c6 <check_vmm+0x46>
c01080a2:	c7 44 24 0c 60 b5 10 	movl   $0xc010b560,0xc(%esp)
c01080a9:	c0 
c01080aa:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01080b1:	c0 
c01080b2:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01080b9:	00 
c01080ba:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01080c1:	e8 24 8c ff ff       	call   c0100cea <__panic>

    cprintf("check_vmm() succeeded.\n");
c01080c6:	c7 04 24 87 b5 10 c0 	movl   $0xc010b587,(%esp)
c01080cd:	e8 93 82 ff ff       	call   c0100365 <cprintf>
}
c01080d2:	90                   	nop
c01080d3:	89 ec                	mov    %ebp,%esp
c01080d5:	5d                   	pop    %ebp
c01080d6:	c3                   	ret    

c01080d7 <check_vma_struct>:

static void
check_vma_struct(void)
{
c01080d7:	55                   	push   %ebp
c01080d8:	89 e5                	mov    %esp,%ebp
c01080da:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01080dd:	e8 a8 c7 ff ff       	call   c010488a <nr_free_pages>
c01080e2:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01080e5:	e8 ba fb ff ff       	call   c0107ca4 <mm_create>
c01080ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01080ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01080f1:	75 24                	jne    c0108117 <check_vma_struct+0x40>
c01080f3:	c7 44 24 0c 9f b5 10 	movl   $0xc010b59f,0xc(%esp)
c01080fa:	c0 
c01080fb:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108102:	c0 
c0108103:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010810a:	00 
c010810b:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108112:	e8 d3 8b ff ff       	call   c0100cea <__panic>

    int step1 = 10, step2 = step1 * 10;
c0108117:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010811e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108121:	89 d0                	mov    %edx,%eax
c0108123:	c1 e0 02             	shl    $0x2,%eax
c0108126:	01 d0                	add    %edx,%eax
c0108128:	01 c0                	add    %eax,%eax
c010812a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i--)
c010812d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108130:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108133:	eb 6f                	jmp    c01081a4 <check_vma_struct+0xcd>
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0108135:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108138:	89 d0                	mov    %edx,%eax
c010813a:	c1 e0 02             	shl    $0x2,%eax
c010813d:	01 d0                	add    %edx,%eax
c010813f:	83 c0 02             	add    $0x2,%eax
c0108142:	89 c1                	mov    %eax,%ecx
c0108144:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108147:	89 d0                	mov    %edx,%eax
c0108149:	c1 e0 02             	shl    $0x2,%eax
c010814c:	01 d0                	add    %edx,%eax
c010814e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108155:	00 
c0108156:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010815a:	89 04 24             	mov    %eax,(%esp)
c010815d:	e8 bd fb ff ff       	call   c0107d1f <vma_create>
c0108162:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma != NULL);
c0108165:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108169:	75 24                	jne    c010818f <check_vma_struct+0xb8>
c010816b:	c7 44 24 0c aa b5 10 	movl   $0xc010b5aa,0xc(%esp)
c0108172:	c0 
c0108173:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010817a:	c0 
c010817b:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0108182:	00 
c0108183:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010818a:	e8 5b 8b ff ff       	call   c0100cea <__panic>
        insert_vma_struct(mm, vma);
c010818f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108192:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108196:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108199:	89 04 24             	mov    %eax,(%esp)
c010819c:	e8 15 fd ff ff       	call   c0107eb6 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
c01081a1:	ff 4d f4             	decl   -0xc(%ebp)
c01081a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01081a8:	7f 8b                	jg     c0108135 <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i++)
c01081aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081ad:	40                   	inc    %eax
c01081ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01081b1:	eb 6f                	jmp    c0108222 <check_vma_struct+0x14b>
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01081b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081b6:	89 d0                	mov    %edx,%eax
c01081b8:	c1 e0 02             	shl    $0x2,%eax
c01081bb:	01 d0                	add    %edx,%eax
c01081bd:	83 c0 02             	add    $0x2,%eax
c01081c0:	89 c1                	mov    %eax,%ecx
c01081c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081c5:	89 d0                	mov    %edx,%eax
c01081c7:	c1 e0 02             	shl    $0x2,%eax
c01081ca:	01 d0                	add    %edx,%eax
c01081cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01081d3:	00 
c01081d4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01081d8:	89 04 24             	mov    %eax,(%esp)
c01081db:	e8 3f fb ff ff       	call   c0107d1f <vma_create>
c01081e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma != NULL);
c01081e3:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01081e7:	75 24                	jne    c010820d <check_vma_struct+0x136>
c01081e9:	c7 44 24 0c aa b5 10 	movl   $0xc010b5aa,0xc(%esp)
c01081f0:	c0 
c01081f1:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01081f8:	c0 
c01081f9:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0108200:	00 
c0108201:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108208:	e8 dd 8a ff ff       	call   c0100cea <__panic>
        insert_vma_struct(mm, vma);
c010820d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0108210:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108214:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108217:	89 04 24             	mov    %eax,(%esp)
c010821a:	e8 97 fc ff ff       	call   c0107eb6 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
c010821f:	ff 45 f4             	incl   -0xc(%ebp)
c0108222:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108225:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108228:	7e 89                	jle    c01081b3 <check_vma_struct+0xdc>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010822a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010822d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0108230:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0108233:	8b 40 04             	mov    0x4(%eax),%eax
c0108236:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i++)
c0108239:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0108240:	e9 96 00 00 00       	jmp    c01082db <check_vma_struct+0x204>
    {
        assert(le != &(mm->mmap_list));
c0108245:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108248:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010824b:	75 24                	jne    c0108271 <check_vma_struct+0x19a>
c010824d:	c7 44 24 0c b6 b5 10 	movl   $0xc010b5b6,0xc(%esp)
c0108254:	c0 
c0108255:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010825c:	c0 
c010825d:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0108264:	00 
c0108265:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010826c:	e8 79 8a ff ff       	call   c0100cea <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0108271:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108274:	83 e8 10             	sub    $0x10,%eax
c0108277:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010827a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010827d:	8b 48 04             	mov    0x4(%eax),%ecx
c0108280:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108283:	89 d0                	mov    %edx,%eax
c0108285:	c1 e0 02             	shl    $0x2,%eax
c0108288:	01 d0                	add    %edx,%eax
c010828a:	39 c1                	cmp    %eax,%ecx
c010828c:	75 17                	jne    c01082a5 <check_vma_struct+0x1ce>
c010828e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0108291:	8b 48 08             	mov    0x8(%eax),%ecx
c0108294:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108297:	89 d0                	mov    %edx,%eax
c0108299:	c1 e0 02             	shl    $0x2,%eax
c010829c:	01 d0                	add    %edx,%eax
c010829e:	83 c0 02             	add    $0x2,%eax
c01082a1:	39 c1                	cmp    %eax,%ecx
c01082a3:	74 24                	je     c01082c9 <check_vma_struct+0x1f2>
c01082a5:	c7 44 24 0c d0 b5 10 	movl   $0xc010b5d0,0xc(%esp)
c01082ac:	c0 
c01082ad:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01082b4:	c0 
c01082b5:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01082bc:	00 
c01082bd:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01082c4:	e8 21 8a ff ff       	call   c0100cea <__panic>
c01082c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01082cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01082d2:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01082d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i++)
c01082d8:	ff 45 f4             	incl   -0xc(%ebp)
c01082db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01082e1:	0f 8e 5e ff ff ff    	jle    c0108245 <check_vma_struct+0x16e>
    }

    for (i = 5; i <= 5 * step2; i += 5)
c01082e7:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01082ee:	e9 cb 01 00 00       	jmp    c01084be <check_vma_struct+0x3e7>
    {
        struct vma_struct *vma1 = find_vma(mm, i);
c01082f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01082fd:	89 04 24             	mov    %eax,(%esp)
c0108300:	e8 57 fa ff ff       	call   c0107d5c <find_vma>
c0108305:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma1 != NULL);
c0108308:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010830c:	75 24                	jne    c0108332 <check_vma_struct+0x25b>
c010830e:	c7 44 24 0c 05 b6 10 	movl   $0xc010b605,0xc(%esp)
c0108315:	c0 
c0108316:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010831d:	c0 
c010831e:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0108325:	00 
c0108326:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010832d:	e8 b8 89 ff ff       	call   c0100cea <__panic>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
c0108332:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108335:	40                   	inc    %eax
c0108336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010833a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010833d:	89 04 24             	mov    %eax,(%esp)
c0108340:	e8 17 fa ff ff       	call   c0107d5c <find_vma>
c0108345:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(vma2 != NULL);
c0108348:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010834c:	75 24                	jne    c0108372 <check_vma_struct+0x29b>
c010834e:	c7 44 24 0c 12 b6 10 	movl   $0xc010b612,0xc(%esp)
c0108355:	c0 
c0108356:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010835d:	c0 
c010835e:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0108365:	00 
c0108366:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010836d:	e8 78 89 ff ff       	call   c0100cea <__panic>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
c0108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108375:	83 c0 02             	add    $0x2,%eax
c0108378:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010837f:	89 04 24             	mov    %eax,(%esp)
c0108382:	e8 d5 f9 ff ff       	call   c0107d5c <find_vma>
c0108387:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma3 == NULL);
c010838a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010838e:	74 24                	je     c01083b4 <check_vma_struct+0x2dd>
c0108390:	c7 44 24 0c 1f b6 10 	movl   $0xc010b61f,0xc(%esp)
c0108397:	c0 
c0108398:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010839f:	c0 
c01083a0:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01083a7:	00 
c01083a8:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01083af:	e8 36 89 ff ff       	call   c0100cea <__panic>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
c01083b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083b7:	83 c0 03             	add    $0x3,%eax
c01083ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01083c1:	89 04 24             	mov    %eax,(%esp)
c01083c4:	e8 93 f9 ff ff       	call   c0107d5c <find_vma>
c01083c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma4 == NULL);
c01083cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01083d0:	74 24                	je     c01083f6 <check_vma_struct+0x31f>
c01083d2:	c7 44 24 0c 2c b6 10 	movl   $0xc010b62c,0xc(%esp)
c01083d9:	c0 
c01083da:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01083e1:	c0 
c01083e2:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01083e9:	00 
c01083ea:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01083f1:	e8 f4 88 ff ff       	call   c0100cea <__panic>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
c01083f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083f9:	83 c0 04             	add    $0x4,%eax
c01083fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108400:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108403:	89 04 24             	mov    %eax,(%esp)
c0108406:	e8 51 f9 ff ff       	call   c0107d5c <find_vma>
c010840b:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma5 == NULL);
c010840e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0108412:	74 24                	je     c0108438 <check_vma_struct+0x361>
c0108414:	c7 44 24 0c 39 b6 10 	movl   $0xc010b639,0xc(%esp)
c010841b:	c0 
c010841c:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108423:	c0 
c0108424:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010842b:	00 
c010842c:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108433:	e8 b2 88 ff ff       	call   c0100cea <__panic>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
c0108438:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010843b:	8b 50 04             	mov    0x4(%eax),%edx
c010843e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108441:	39 c2                	cmp    %eax,%edx
c0108443:	75 10                	jne    c0108455 <check_vma_struct+0x37e>
c0108445:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108448:	8b 40 08             	mov    0x8(%eax),%eax
c010844b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010844e:	83 c2 02             	add    $0x2,%edx
c0108451:	39 d0                	cmp    %edx,%eax
c0108453:	74 24                	je     c0108479 <check_vma_struct+0x3a2>
c0108455:	c7 44 24 0c 48 b6 10 	movl   $0xc010b648,0xc(%esp)
c010845c:	c0 
c010845d:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108464:	c0 
c0108465:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010846c:	00 
c010846d:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108474:	e8 71 88 ff ff       	call   c0100cea <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
c0108479:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010847c:	8b 50 04             	mov    0x4(%eax),%edx
c010847f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108482:	39 c2                	cmp    %eax,%edx
c0108484:	75 10                	jne    c0108496 <check_vma_struct+0x3bf>
c0108486:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108489:	8b 40 08             	mov    0x8(%eax),%eax
c010848c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010848f:	83 c2 02             	add    $0x2,%edx
c0108492:	39 d0                	cmp    %edx,%eax
c0108494:	74 24                	je     c01084ba <check_vma_struct+0x3e3>
c0108496:	c7 44 24 0c 78 b6 10 	movl   $0xc010b678,0xc(%esp)
c010849d:	c0 
c010849e:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01084a5:	c0 
c01084a6:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01084ad:	00 
c01084ae:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01084b5:	e8 30 88 ff ff       	call   c0100cea <__panic>
    for (i = 5; i <= 5 * step2; i += 5)
c01084ba:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01084be:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01084c1:	89 d0                	mov    %edx,%eax
c01084c3:	c1 e0 02             	shl    $0x2,%eax
c01084c6:	01 d0                	add    %edx,%eax
c01084c8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01084cb:	0f 8e 22 fe ff ff    	jle    c01082f3 <check_vma_struct+0x21c>
    }

    for (i = 4; i >= 0; i--)
c01084d1:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01084d8:	eb 6f                	jmp    c0108549 <check_vma_struct+0x472>
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
c01084da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084e4:	89 04 24             	mov    %eax,(%esp)
c01084e7:	e8 70 f8 ff ff       	call   c0107d5c <find_vma>
c01084ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (vma_below_5 != NULL)
c01084ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01084f3:	74 27                	je     c010851c <check_vma_struct+0x445>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
c01084f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084f8:	8b 50 08             	mov    0x8(%eax),%edx
c01084fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084fe:	8b 40 04             	mov    0x4(%eax),%eax
c0108501:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108505:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108509:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010850c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108510:	c7 04 24 a8 b6 10 c0 	movl   $0xc010b6a8,(%esp)
c0108517:	e8 49 7e ff ff       	call   c0100365 <cprintf>
        }
        assert(vma_below_5 == NULL);
c010851c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108520:	74 24                	je     c0108546 <check_vma_struct+0x46f>
c0108522:	c7 44 24 0c cd b6 10 	movl   $0xc010b6cd,0xc(%esp)
c0108529:	c0 
c010852a:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108531:	c0 
c0108532:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0108539:	00 
c010853a:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108541:	e8 a4 87 ff ff       	call   c0100cea <__panic>
    for (i = 4; i >= 0; i--)
c0108546:	ff 4d f4             	decl   -0xc(%ebp)
c0108549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010854d:	79 8b                	jns    c01084da <check_vma_struct+0x403>
    }

    mm_destroy(mm);
c010854f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108552:	89 04 24             	mov    %eax,(%esp)
c0108555:	e8 92 fa ff ff       	call   c0107fec <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c010855a:	e8 2b c3 ff ff       	call   c010488a <nr_free_pages>
c010855f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0108562:	74 24                	je     c0108588 <check_vma_struct+0x4b1>
c0108564:	c7 44 24 0c 60 b5 10 	movl   $0xc010b560,0xc(%esp)
c010856b:	c0 
c010856c:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108573:	c0 
c0108574:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c010857b:	00 
c010857c:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108583:	e8 62 87 ff ff       	call   c0100cea <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0108588:	c7 04 24 e4 b6 10 c0 	movl   $0xc010b6e4,(%esp)
c010858f:	e8 d1 7d ff ff       	call   c0100365 <cprintf>
}
c0108594:	90                   	nop
c0108595:	89 ec                	mov    %ebp,%esp
c0108597:	5d                   	pop    %ebp
c0108598:	c3                   	ret    

c0108599 <check_pgfault>:
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void)
{
c0108599:	55                   	push   %ebp
c010859a:	89 e5                	mov    %esp,%ebp
c010859c:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010859f:	e8 e6 c2 ff ff       	call   c010488a <nr_free_pages>
c01085a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c01085a7:	e8 f8 f6 ff ff       	call   c0107ca4 <mm_create>
c01085ac:	a3 0c 81 12 c0       	mov    %eax,0xc012810c
    assert(check_mm_struct != NULL);
c01085b1:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c01085b6:	85 c0                	test   %eax,%eax
c01085b8:	75 24                	jne    c01085de <check_pgfault+0x45>
c01085ba:	c7 44 24 0c 03 b7 10 	movl   $0xc010b703,0xc(%esp)
c01085c1:	c0 
c01085c2:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01085c9:	c0 
c01085ca:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01085d1:	00 
c01085d2:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01085d9:	e8 0c 87 ff ff       	call   c0100cea <__panic>

    struct mm_struct *mm = check_mm_struct;
c01085de:	a1 0c 81 12 c0       	mov    0xc012810c,%eax
c01085e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c01085e6:	8b 15 e0 49 12 c0    	mov    0xc01249e0,%edx
c01085ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085ef:	89 50 0c             	mov    %edx,0xc(%eax)
c01085f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085f5:	8b 40 0c             	mov    0xc(%eax),%eax
c01085f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01085fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085fe:	8b 00                	mov    (%eax),%eax
c0108600:	85 c0                	test   %eax,%eax
c0108602:	74 24                	je     c0108628 <check_pgfault+0x8f>
c0108604:	c7 44 24 0c 1b b7 10 	movl   $0xc010b71b,0xc(%esp)
c010860b:	c0 
c010860c:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108613:	c0 
c0108614:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010861b:	00 
c010861c:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108623:	e8 c2 86 ff ff       	call   c0100cea <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108628:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c010862f:	00 
c0108630:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108637:	00 
c0108638:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010863f:	e8 db f6 ff ff       	call   c0107d1f <vma_create>
c0108644:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108647:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010864b:	75 24                	jne    c0108671 <check_pgfault+0xd8>
c010864d:	c7 44 24 0c aa b5 10 	movl   $0xc010b5aa,0xc(%esp)
c0108654:	c0 
c0108655:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c010865c:	c0 
c010865d:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0108664:	00 
c0108665:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010866c:	e8 79 86 ff ff       	call   c0100cea <__panic>

    insert_vma_struct(mm, vma);
c0108671:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108674:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108678:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010867b:	89 04 24             	mov    %eax,(%esp)
c010867e:	e8 33 f8 ff ff       	call   c0107eb6 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108683:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010868a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010868d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108691:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108694:	89 04 24             	mov    %eax,(%esp)
c0108697:	e8 c0 f6 ff ff       	call   c0107d5c <find_vma>
c010869c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010869f:	74 24                	je     c01086c5 <check_pgfault+0x12c>
c01086a1:	c7 44 24 0c 29 b7 10 	movl   $0xc010b729,0xc(%esp)
c01086a8:	c0 
c01086a9:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01086b0:	c0 
c01086b1:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01086b8:	00 
c01086b9:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01086c0:	e8 25 86 ff ff       	call   c0100cea <__panic>

    int i, sum = 0;
c01086c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i++)
c01086cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01086d3:	eb 16                	jmp    c01086eb <check_pgfault+0x152>
    {
        *(char *)(addr + i) = i;
c01086d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01086db:	01 d0                	add    %edx,%eax
c01086dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086e0:	88 10                	mov    %dl,(%eax)
        sum += i;
c01086e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086e5:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i++)
c01086e8:	ff 45 f4             	incl   -0xc(%ebp)
c01086eb:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01086ef:	7e e4                	jle    c01086d5 <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i++)
c01086f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01086f8:	eb 14                	jmp    c010870e <check_pgfault+0x175>
    {
        sum -= *(char *)(addr + i);
c01086fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108700:	01 d0                	add    %edx,%eax
c0108702:	0f b6 00             	movzbl (%eax),%eax
c0108705:	0f be c0             	movsbl %al,%eax
c0108708:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i++)
c010870b:	ff 45 f4             	incl   -0xc(%ebp)
c010870e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108712:	7e e6                	jle    c01086fa <check_pgfault+0x161>
    }
    assert(sum == 0);
c0108714:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108718:	74 24                	je     c010873e <check_pgfault+0x1a5>
c010871a:	c7 44 24 0c 43 b7 10 	movl   $0xc010b743,0xc(%esp)
c0108721:	c0 
c0108722:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c0108729:	c0 
c010872a:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108731:	00 
c0108732:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c0108739:	e8 ac 85 ff ff       	call   c0100cea <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010873e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108741:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108744:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108747:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010874c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108753:	89 04 24             	mov    %eax,(%esp)
c0108756:	e8 3d c9 ff ff       	call   c0105098 <page_remove>
    free_page(pde2page(pgdir[0]));
c010875b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010875e:	8b 00                	mov    (%eax),%eax
c0108760:	89 04 24             	mov    %eax,(%esp)
c0108763:	e8 22 f5 ff ff       	call   c0107c8a <pde2page>
c0108768:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010876f:	00 
c0108770:	89 04 24             	mov    %eax,(%esp)
c0108773:	e8 dd c0 ff ff       	call   c0104855 <free_pages>
    pgdir[0] = 0;
c0108778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010877b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108781:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108784:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010878b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010878e:	89 04 24             	mov    %eax,(%esp)
c0108791:	e8 56 f8 ff ff       	call   c0107fec <mm_destroy>
    check_mm_struct = NULL;
c0108796:	c7 05 0c 81 12 c0 00 	movl   $0x0,0xc012810c
c010879d:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01087a0:	e8 e5 c0 ff ff       	call   c010488a <nr_free_pages>
c01087a5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01087a8:	74 24                	je     c01087ce <check_pgfault+0x235>
c01087aa:	c7 44 24 0c 60 b5 10 	movl   $0xc010b560,0xc(%esp)
c01087b1:	c0 
c01087b2:	c7 44 24 08 df b4 10 	movl   $0xc010b4df,0x8(%esp)
c01087b9:	c0 
c01087ba:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01087c1:	00 
c01087c2:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01087c9:	e8 1c 85 ff ff       	call   c0100cea <__panic>

    cprintf("check_pgfault() succeeded!\n");
c01087ce:	c7 04 24 4c b7 10 c0 	movl   $0xc010b74c,(%esp)
c01087d5:	e8 8b 7b ff ff       	call   c0100365 <cprintf>
}
c01087da:	90                   	nop
c01087db:	89 ec                	mov    %ebp,%esp
c01087dd:	5d                   	pop    %ebp
c01087de:	c3                   	ret    

c01087df <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
c01087df:	55                   	push   %ebp
c01087e0:	89 e5                	mov    %esp,%ebp
c01087e2:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c01087e5:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    // 从mm中查找虚拟地址对应的vma
    struct vma_struct *vma = find_vma(mm, addr);
c01087ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01087ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f6:	89 04 24             	mov    %eax,(%esp)
c01087f9:	e8 5e f5 ff ff       	call   c0107d5c <find_vma>
c01087fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pgfault_num++;
c0108801:	a1 10 81 12 c0       	mov    0xc0128110,%eax
c0108806:	40                   	inc    %eax
c0108807:	a3 10 81 12 c0       	mov    %eax,0xc0128110
    // 若不存在对应的vma，跳转到failed
    if (vma == NULL || vma->vm_start > addr)
c010880c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108810:	74 0b                	je     c010881d <do_pgfault+0x3e>
c0108812:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108815:	8b 40 04             	mov    0x4(%eax),%eax
c0108818:	39 45 10             	cmp    %eax,0x10(%ebp)
c010881b:	73 18                	jae    c0108835 <do_pgfault+0x56>
    {
        cprintf("not valid addr %x, and can not find it in vma\n", addr);
c010881d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108820:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108824:	c7 04 24 68 b7 10 c0 	movl   $0xc010b768,(%esp)
c010882b:	e8 35 7b ff ff       	call   c0100365 <cprintf>
        goto failed;
c0108830:	e9 9b 01 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
     *第一种：申请写操作，物理内存中不存在，并且对应地址的内容不允许写
     *第二种：申请读操作，并且物理内存中存在（因此已经报错，所以是权限不够）
     *第三种：申请读操作但是物理内存中不存在，并且该地址数据不允许被读或者加载
     */
    // 第0位判断物理页是否存在；第1位判断写异常/读异常
    switch (error_code & 3)
c0108835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108838:	83 e0 03             	and    $0x3,%eax
c010883b:	85 c0                	test   %eax,%eax
c010883d:	74 34                	je     c0108873 <do_pgfault+0x94>
c010883f:	83 f8 01             	cmp    $0x1,%eax
c0108842:	74 1e                	je     c0108862 <do_pgfault+0x83>
    {
    default:
        // 两位都是1，说明物理页存在发生写异常，缺页异常
    case 2:
        // 发生写异常
        if (!(vma->vm_flags & VM_WRITE))
c0108844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108847:	8b 40 0c             	mov    0xc(%eax),%eax
c010884a:	83 e0 02             	and    $0x2,%eax
c010884d:	85 c0                	test   %eax,%eax
c010884f:	75 40                	jne    c0108891 <do_pgfault+0xb2>
        {
            // 跳转到failed
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108851:	c7 04 24 98 b7 10 c0 	movl   $0xc010b798,(%esp)
c0108858:	e8 08 7b ff ff       	call   c0100365 <cprintf>
            goto failed;
c010885d:	e9 6e 01 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
        }
        break;
    case 1:
        // 发生读异常（权限不够）
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108862:	c7 04 24 f8 b7 10 c0 	movl   $0xc010b7f8,(%esp)
c0108869:	e8 f7 7a ff ff       	call   c0100365 <cprintf>
        goto failed;
c010886e:	e9 5d 01 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
    case 0:
        // 读异常，不存在
        if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
c0108873:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108876:	8b 40 0c             	mov    0xc(%eax),%eax
c0108879:	83 e0 05             	and    $0x5,%eax
c010887c:	85 c0                	test   %eax,%eax
c010887e:	75 12                	jne    c0108892 <do_pgfault+0xb3>
        {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108880:	c7 04 24 30 b8 10 c0 	movl   $0xc010b830,(%esp)
c0108887:	e8 d9 7a ff ff       	call   c0100365 <cprintf>
            goto failed;
c010888c:	e9 3f 01 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
        break;
c0108891:	90                   	nop
        }
    }

    // 设置pte用的权限
    uint32_t perm = PTE_U;
c0108892:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE)
c0108899:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010889c:	8b 40 0c             	mov    0xc(%eax),%eax
c010889f:	83 e0 02             	and    $0x2,%eax
c01088a2:	85 c0                	test   %eax,%eax
c01088a4:	74 04                	je     c01088aa <do_pgfault+0xcb>
    {
        perm |= PTE_W;
c01088a6:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    // 地址按页向下取整，因为映射的是整个页的关系
    addr = ROUNDDOWN(addr, PGSIZE);
c01088aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01088ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01088b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01088b8:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c01088bb:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep = NULL;
c01088c2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    ptep = get_pte(mm->pgdir, addr, 1);
c01088c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01088cc:	8b 40 0c             	mov    0xc(%eax),%eax
c01088cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01088d6:	00 
c01088d7:	8b 55 10             	mov    0x10(%ebp),%edx
c01088da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01088de:	89 04 24             	mov    %eax,(%esp)
c01088e1:	e8 b8 c5 ff ff       	call   c0104e9e <get_pte>
c01088e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // 如果一个pte全是0，表示目标页帧不存在，需要分配一个物理页并建立虚实映射关系
    if (*ptep == 0)
c01088e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088ec:	8b 00                	mov    (%eax),%eax
c01088ee:	85 c0                	test   %eax,%eax
c01088f0:	75 35                	jne    c0108927 <do_pgfault+0x148>
    {
        // 为空说明分配失败了
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
c01088f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f5:	8b 40 0c             	mov    0xc(%eax),%eax
c01088f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01088fb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01088ff:	8b 55 10             	mov    0x10(%ebp),%edx
c0108902:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108906:	89 04 24             	mov    %eax,(%esp)
c0108909:	e8 eb c8 ff ff       	call   c01051f9 <pgdir_alloc_page>
c010890e:	85 c0                	test   %eax,%eax
c0108910:	0f 85 b3 00 00 00    	jne    c01089c9 <do_pgfault+0x1ea>
        {
            cprintf("print alloc page failed.\n");
c0108916:	c7 04 24 93 b8 10 c0 	movl   $0xc010b893,(%esp)
c010891d:	e8 43 7a ff ff       	call   c0100365 <cprintf>
            goto failed;
c0108922:	e9 a9 00 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
        }
    }
    else
    {
        if (!swap_init_ok)
c0108927:	a1 44 80 12 c0       	mov    0xc0128044,%eax
c010892c:	85 c0                	test   %eax,%eax
c010892e:	75 1a                	jne    c010894a <do_pgfault+0x16b>
        {
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
c0108930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108933:	8b 00                	mov    (%eax),%eax
c0108935:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108939:	c7 04 24 b0 b8 10 c0 	movl   $0xc010b8b0,(%esp)
c0108940:	e8 20 7a ff ff       	call   c0100365 <cprintf>
            goto failed;
c0108945:	e9 86 00 00 00       	jmp    c01089d0 <do_pgfault+0x1f1>
        }
        // 如果不是全为0，说明可能是之前被交换到了磁盘中，需要换出来
        struct Page *page = NULL;
c010894a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        if (swap_in(mm, addr, &page))
c0108951:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108954:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108958:	8b 45 10             	mov    0x10(%ebp),%eax
c010895b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010895f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108962:	89 04 24             	mov    %eax,(%esp)
c0108965:	e8 59 da ff ff       	call   c01063c3 <swap_in>
c010896a:	85 c0                	test   %eax,%eax
c010896c:	74 0e                	je     c010897c <do_pgfault+0x19d>
        {
            // 如果返回值不为0说明出了问题
            cprintf("swap in failed.\n");
c010896e:	c7 04 24 d8 b8 10 c0 	movl   $0xc010b8d8,(%esp)
c0108975:	e8 eb 79 ff ff       	call   c0100365 <cprintf>
            goto failed;
c010897a:	eb 54                	jmp    c01089d0 <do_pgfault+0x1f1>
        }
        // 建立映射关系，更新PTE，因为换出去以后PTE存的是关于磁盘扇区的信息
        page_insert(mm->pgdir, page, addr, perm);
c010897c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010897f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108982:	8b 40 0c             	mov    0xc(%eax),%eax
c0108985:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108988:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010898c:	8b 4d 10             	mov    0x10(%ebp),%ecx
c010898f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108993:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108997:	89 04 24             	mov    %eax,(%esp)
c010899a:	e8 40 c7 ff ff       	call   c01050df <page_insert>
        // 当前page是为可交换的，将其加入全局虚拟内存交换管理器的管理
        swap_map_swappable(mm, addr, page, 1);
c010899f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01089a2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01089a9:	00 
c01089aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01089ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01089b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b8:	89 04 24             	mov    %eax,(%esp)
c01089bb:	e8 3b d8 ff ff       	call   c01061fb <swap_map_swappable>
        // 设置 这一页的虚拟地址
        page->pra_vaddr = addr;
c01089c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01089c3:	8b 55 10             	mov    0x10(%ebp),%edx
c01089c6:	89 50 1c             	mov    %edx,0x1c(%eax)
    }
    ret = 0;
c01089c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01089d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089d3:	89 ec                	mov    %ebp,%esp
c01089d5:	5d                   	pop    %ebp
c01089d6:	c3                   	ret    

c01089d7 <page2ppn>:
page2ppn(struct Page *page) {
c01089d7:	55                   	push   %ebp
c01089d8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01089da:	8b 15 a0 7f 12 c0    	mov    0xc0127fa0,%edx
c01089e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e3:	29 d0                	sub    %edx,%eax
c01089e5:	c1 f8 05             	sar    $0x5,%eax
}
c01089e8:	5d                   	pop    %ebp
c01089e9:	c3                   	ret    

c01089ea <page2pa>:
page2pa(struct Page *page) {
c01089ea:	55                   	push   %ebp
c01089eb:	89 e5                	mov    %esp,%ebp
c01089ed:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01089f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f3:	89 04 24             	mov    %eax,(%esp)
c01089f6:	e8 dc ff ff ff       	call   c01089d7 <page2ppn>
c01089fb:	c1 e0 0c             	shl    $0xc,%eax
}
c01089fe:	89 ec                	mov    %ebp,%esp
c0108a00:	5d                   	pop    %ebp
c0108a01:	c3                   	ret    

c0108a02 <page2kva>:
page2kva(struct Page *page) {
c0108a02:	55                   	push   %ebp
c0108a03:	89 e5                	mov    %esp,%ebp
c0108a05:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a0b:	89 04 24             	mov    %eax,(%esp)
c0108a0e:	e8 d7 ff ff ff       	call   c01089ea <page2pa>
c0108a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a19:	c1 e8 0c             	shr    $0xc,%eax
c0108a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a1f:	a1 a4 7f 12 c0       	mov    0xc0127fa4,%eax
c0108a24:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108a27:	72 23                	jb     c0108a4c <page2kva+0x4a>
c0108a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108a30:	c7 44 24 08 ec b8 10 	movl   $0xc010b8ec,0x8(%esp)
c0108a37:	c0 
c0108a38:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0108a3f:	00 
c0108a40:	c7 04 24 0f b9 10 c0 	movl   $0xc010b90f,(%esp)
c0108a47:	e8 9e 82 ff ff       	call   c0100cea <__panic>
c0108a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a4f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108a54:	89 ec                	mov    %ebp,%esp
c0108a56:	5d                   	pop    %ebp
c0108a57:	c3                   	ret    

c0108a58 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void swapfs_init(void)
{
c0108a58:	55                   	push   %ebp
c0108a59:	89 e5                	mov    %esp,%ebp
c0108a5b:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO))
c0108a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108a65:	e8 2f 90 ff ff       	call   c0101a99 <ide_device_valid>
c0108a6a:	85 c0                	test   %eax,%eax
c0108a6c:	75 1c                	jne    c0108a8a <swapfs_init+0x32>
    {
        panic("swap fs isn't available.\n");
c0108a6e:	c7 44 24 08 1d b9 10 	movl   $0xc010b91d,0x8(%esp)
c0108a75:	c0 
c0108a76:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
c0108a7d:	00 
c0108a7e:	c7 04 24 37 b9 10 c0 	movl   $0xc010b937,(%esp)
c0108a85:	e8 60 82 ff ff       	call   c0100cea <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108a8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108a91:	e8 43 90 ff ff       	call   c0101ad9 <ide_device_size>
c0108a96:	c1 e8 03             	shr    $0x3,%eax
c0108a99:	a3 40 80 12 c0       	mov    %eax,0xc0128040
}
c0108a9e:	90                   	nop
c0108a9f:	89 ec                	mov    %ebp,%esp
c0108aa1:	5d                   	pop    %ebp
c0108aa2:	c3                   	ret    

c0108aa3 <swapfs_read>:

// 根据传入的swap_entry_t读取对应的磁盘扇区并保存在Page对应的物理内存处
// 这里面可以看出offset与扇区号的对应关系，即offset*8=起始扇区号
int swapfs_read(swap_entry_t entry, struct Page *page)
{
c0108aa3:	55                   	push   %ebp
c0108aa4:	89 e5                	mov    %esp,%ebp
c0108aa6:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aac:	89 04 24             	mov    %eax,(%esp)
c0108aaf:	e8 4e ff ff ff       	call   c0108a02 <page2kva>
c0108ab4:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ab7:	c1 ea 08             	shr    $0x8,%edx
c0108aba:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108ac1:	74 0b                	je     c0108ace <swapfs_read+0x2b>
c0108ac3:	8b 15 40 80 12 c0    	mov    0xc0128040,%edx
c0108ac9:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108acc:	72 23                	jb     c0108af1 <swapfs_read+0x4e>
c0108ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ad1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108ad5:	c7 44 24 08 48 b9 10 	movl   $0xc010b948,0x8(%esp)
c0108adc:	c0 
c0108add:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
c0108ae4:	00 
c0108ae5:	c7 04 24 37 b9 10 c0 	movl   $0xc010b937,(%esp)
c0108aec:	e8 f9 81 ff ff       	call   c0100cea <__panic>
c0108af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108af4:	c1 e2 03             	shl    $0x3,%edx
c0108af7:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108afe:	00 
c0108aff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108b03:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108b0e:	e8 03 90 ff ff       	call   c0101b16 <ide_read_secs>
}
c0108b13:	89 ec                	mov    %ebp,%esp
c0108b15:	5d                   	pop    %ebp
c0108b16:	c3                   	ret    

c0108b17 <swapfs_write>:

int swapfs_write(swap_entry_t entry, struct Page *page)
{
c0108b17:	55                   	push   %ebp
c0108b18:	89 e5                	mov    %esp,%ebp
c0108b1a:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b20:	89 04 24             	mov    %eax,(%esp)
c0108b23:	e8 da fe ff ff       	call   c0108a02 <page2kva>
c0108b28:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b2b:	c1 ea 08             	shr    $0x8,%edx
c0108b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108b31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108b35:	74 0b                	je     c0108b42 <swapfs_write+0x2b>
c0108b37:	8b 15 40 80 12 c0    	mov    0xc0128040,%edx
c0108b3d:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108b40:	72 23                	jb     c0108b65 <swapfs_write+0x4e>
c0108b42:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b45:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108b49:	c7 44 24 08 48 b9 10 	movl   $0xc010b948,0x8(%esp)
c0108b50:	c0 
c0108b51:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
c0108b58:	00 
c0108b59:	c7 04 24 37 b9 10 c0 	movl   $0xc010b937,(%esp)
c0108b60:	e8 85 81 ff ff       	call   c0100cea <__panic>
c0108b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b68:	c1 e2 03             	shl    $0x3,%edx
c0108b6b:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108b72:	00 
c0108b73:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108b77:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108b82:	e8 d0 91 ff ff       	call   c0101d57 <ide_write_secs>
}
c0108b87:	89 ec                	mov    %ebp,%esp
c0108b89:	5d                   	pop    %ebp
c0108b8a:	c3                   	ret    

c0108b8b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108b8b:	55                   	push   %ebp
c0108b8c:	89 e5                	mov    %esp,%ebp
c0108b8e:	83 ec 58             	sub    $0x58,%esp
c0108b91:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b94:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108b97:	8b 45 14             	mov    0x14(%ebp),%eax
c0108b9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108b9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108ba0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108ba3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108ba6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108ba9:	8b 45 18             	mov    0x18(%ebp),%eax
c0108bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108bb8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108bc5:	74 1c                	je     c0108be3 <printnum+0x58>
c0108bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bca:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bcf:	f7 75 e4             	divl   -0x1c(%ebp)
c0108bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bd8:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bdd:	f7 75 e4             	divl   -0x1c(%ebp)
c0108be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108be9:	f7 75 e4             	divl   -0x1c(%ebp)
c0108bec:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108bef:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108bf8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108bfb:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c01:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108c04:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c07:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c0c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0108c0f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0108c12:	19 d1                	sbb    %edx,%ecx
c0108c14:	72 4c                	jb     c0108c62 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108c16:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108c19:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108c1c:	8b 45 20             	mov    0x20(%ebp),%eax
c0108c1f:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108c23:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108c27:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c2a:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c31:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c34:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c38:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c46:	89 04 24             	mov    %eax,(%esp)
c0108c49:	e8 3d ff ff ff       	call   c0108b8b <printnum>
c0108c4e:	eb 1b                	jmp    c0108c6b <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108c50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c57:	8b 45 20             	mov    0x20(%ebp),%eax
c0108c5a:	89 04 24             	mov    %eax,(%esp)
c0108c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c60:	ff d0                	call   *%eax
        while (-- width > 0)
c0108c62:	ff 4d 1c             	decl   0x1c(%ebp)
c0108c65:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108c69:	7f e5                	jg     c0108c50 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108c6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c6e:	05 e8 b9 10 c0       	add    $0xc010b9e8,%eax
c0108c73:	0f b6 00             	movzbl (%eax),%eax
c0108c76:	0f be c0             	movsbl %al,%eax
c0108c79:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108c80:	89 04 24             	mov    %eax,(%esp)
c0108c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c86:	ff d0                	call   *%eax
}
c0108c88:	90                   	nop
c0108c89:	89 ec                	mov    %ebp,%esp
c0108c8b:	5d                   	pop    %ebp
c0108c8c:	c3                   	ret    

c0108c8d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108c8d:	55                   	push   %ebp
c0108c8e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108c90:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108c94:	7e 14                	jle    c0108caa <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c99:	8b 00                	mov    (%eax),%eax
c0108c9b:	8d 48 08             	lea    0x8(%eax),%ecx
c0108c9e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ca1:	89 0a                	mov    %ecx,(%edx)
c0108ca3:	8b 50 04             	mov    0x4(%eax),%edx
c0108ca6:	8b 00                	mov    (%eax),%eax
c0108ca8:	eb 30                	jmp    c0108cda <getuint+0x4d>
    }
    else if (lflag) {
c0108caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108cae:	74 16                	je     c0108cc6 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cb3:	8b 00                	mov    (%eax),%eax
c0108cb5:	8d 48 04             	lea    0x4(%eax),%ecx
c0108cb8:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cbb:	89 0a                	mov    %ecx,(%edx)
c0108cbd:	8b 00                	mov    (%eax),%eax
c0108cbf:	ba 00 00 00 00       	mov    $0x0,%edx
c0108cc4:	eb 14                	jmp    c0108cda <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cc9:	8b 00                	mov    (%eax),%eax
c0108ccb:	8d 48 04             	lea    0x4(%eax),%ecx
c0108cce:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cd1:	89 0a                	mov    %ecx,(%edx)
c0108cd3:	8b 00                	mov    (%eax),%eax
c0108cd5:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108cda:	5d                   	pop    %ebp
c0108cdb:	c3                   	ret    

c0108cdc <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108cdc:	55                   	push   %ebp
c0108cdd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108ce3:	7e 14                	jle    c0108cf9 <getint+0x1d>
        return va_arg(*ap, long long);
c0108ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce8:	8b 00                	mov    (%eax),%eax
c0108cea:	8d 48 08             	lea    0x8(%eax),%ecx
c0108ced:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cf0:	89 0a                	mov    %ecx,(%edx)
c0108cf2:	8b 50 04             	mov    0x4(%eax),%edx
c0108cf5:	8b 00                	mov    (%eax),%eax
c0108cf7:	eb 28                	jmp    c0108d21 <getint+0x45>
    }
    else if (lflag) {
c0108cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108cfd:	74 12                	je     c0108d11 <getint+0x35>
        return va_arg(*ap, long);
c0108cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d02:	8b 00                	mov    (%eax),%eax
c0108d04:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d07:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d0a:	89 0a                	mov    %ecx,(%edx)
c0108d0c:	8b 00                	mov    (%eax),%eax
c0108d0e:	99                   	cltd   
c0108d0f:	eb 10                	jmp    c0108d21 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d14:	8b 00                	mov    (%eax),%eax
c0108d16:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d19:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d1c:	89 0a                	mov    %ecx,(%edx)
c0108d1e:	8b 00                	mov    (%eax),%eax
c0108d20:	99                   	cltd   
    }
}
c0108d21:	5d                   	pop    %ebp
c0108d22:	c3                   	ret    

c0108d23 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108d23:	55                   	push   %ebp
c0108d24:	89 e5                	mov    %esp,%ebp
c0108d26:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108d29:	8d 45 14             	lea    0x14(%ebp),%eax
c0108d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d32:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108d36:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d39:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d47:	89 04 24             	mov    %eax,(%esp)
c0108d4a:	e8 05 00 00 00       	call   c0108d54 <vprintfmt>
    va_end(ap);
}
c0108d4f:	90                   	nop
c0108d50:	89 ec                	mov    %ebp,%esp
c0108d52:	5d                   	pop    %ebp
c0108d53:	c3                   	ret    

c0108d54 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108d54:	55                   	push   %ebp
c0108d55:	89 e5                	mov    %esp,%ebp
c0108d57:	56                   	push   %esi
c0108d58:	53                   	push   %ebx
c0108d59:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108d5c:	eb 17                	jmp    c0108d75 <vprintfmt+0x21>
            if (ch == '\0') {
c0108d5e:	85 db                	test   %ebx,%ebx
c0108d60:	0f 84 bf 03 00 00    	je     c0109125 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0108d66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d6d:	89 1c 24             	mov    %ebx,(%esp)
c0108d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d73:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108d75:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d78:	8d 50 01             	lea    0x1(%eax),%edx
c0108d7b:	89 55 10             	mov    %edx,0x10(%ebp)
c0108d7e:	0f b6 00             	movzbl (%eax),%eax
c0108d81:	0f b6 d8             	movzbl %al,%ebx
c0108d84:	83 fb 25             	cmp    $0x25,%ebx
c0108d87:	75 d5                	jne    c0108d5e <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108d89:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108d8d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d97:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108d9a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108da1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108da4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108da7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108daa:	8d 50 01             	lea    0x1(%eax),%edx
c0108dad:	89 55 10             	mov    %edx,0x10(%ebp)
c0108db0:	0f b6 00             	movzbl (%eax),%eax
c0108db3:	0f b6 d8             	movzbl %al,%ebx
c0108db6:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108db9:	83 f8 55             	cmp    $0x55,%eax
c0108dbc:	0f 87 37 03 00 00    	ja     c01090f9 <vprintfmt+0x3a5>
c0108dc2:	8b 04 85 0c ba 10 c0 	mov    -0x3fef45f4(,%eax,4),%eax
c0108dc9:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108dcb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108dcf:	eb d6                	jmp    c0108da7 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108dd1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108dd5:	eb d0                	jmp    c0108da7 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108dd7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108dde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108de1:	89 d0                	mov    %edx,%eax
c0108de3:	c1 e0 02             	shl    $0x2,%eax
c0108de6:	01 d0                	add    %edx,%eax
c0108de8:	01 c0                	add    %eax,%eax
c0108dea:	01 d8                	add    %ebx,%eax
c0108dec:	83 e8 30             	sub    $0x30,%eax
c0108def:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108df2:	8b 45 10             	mov    0x10(%ebp),%eax
c0108df5:	0f b6 00             	movzbl (%eax),%eax
c0108df8:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108dfb:	83 fb 2f             	cmp    $0x2f,%ebx
c0108dfe:	7e 38                	jle    c0108e38 <vprintfmt+0xe4>
c0108e00:	83 fb 39             	cmp    $0x39,%ebx
c0108e03:	7f 33                	jg     c0108e38 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0108e05:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0108e08:	eb d4                	jmp    c0108dde <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0108e0a:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e0d:	8d 50 04             	lea    0x4(%eax),%edx
c0108e10:	89 55 14             	mov    %edx,0x14(%ebp)
c0108e13:	8b 00                	mov    (%eax),%eax
c0108e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108e18:	eb 1f                	jmp    c0108e39 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0108e1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e1e:	79 87                	jns    c0108da7 <vprintfmt+0x53>
                width = 0;
c0108e20:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108e27:	e9 7b ff ff ff       	jmp    c0108da7 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0108e2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108e33:	e9 6f ff ff ff       	jmp    c0108da7 <vprintfmt+0x53>
            goto process_precision;
c0108e38:	90                   	nop

        process_precision:
            if (width < 0)
c0108e39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e3d:	0f 89 64 ff ff ff    	jns    c0108da7 <vprintfmt+0x53>
                width = precision, precision = -1;
c0108e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e46:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108e49:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108e50:	e9 52 ff ff ff       	jmp    c0108da7 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108e55:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0108e58:	e9 4a ff ff ff       	jmp    c0108da7 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108e5d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e60:	8d 50 04             	lea    0x4(%eax),%edx
c0108e63:	89 55 14             	mov    %edx,0x14(%ebp)
c0108e66:	8b 00                	mov    (%eax),%eax
c0108e68:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e6b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108e6f:	89 04 24             	mov    %eax,(%esp)
c0108e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e75:	ff d0                	call   *%eax
            break;
c0108e77:	e9 a4 02 00 00       	jmp    c0109120 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108e7c:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e7f:	8d 50 04             	lea    0x4(%eax),%edx
c0108e82:	89 55 14             	mov    %edx,0x14(%ebp)
c0108e85:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108e87:	85 db                	test   %ebx,%ebx
c0108e89:	79 02                	jns    c0108e8d <vprintfmt+0x139>
                err = -err;
c0108e8b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108e8d:	83 fb 06             	cmp    $0x6,%ebx
c0108e90:	7f 0b                	jg     c0108e9d <vprintfmt+0x149>
c0108e92:	8b 34 9d cc b9 10 c0 	mov    -0x3fef4634(,%ebx,4),%esi
c0108e99:	85 f6                	test   %esi,%esi
c0108e9b:	75 23                	jne    c0108ec0 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0108e9d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108ea1:	c7 44 24 08 f9 b9 10 	movl   $0xc010b9f9,0x8(%esp)
c0108ea8:	c0 
c0108ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108eac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eb3:	89 04 24             	mov    %eax,(%esp)
c0108eb6:	e8 68 fe ff ff       	call   c0108d23 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108ebb:	e9 60 02 00 00       	jmp    c0109120 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0108ec0:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108ec4:	c7 44 24 08 02 ba 10 	movl   $0xc010ba02,0x8(%esp)
c0108ecb:	c0 
c0108ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ed3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ed6:	89 04 24             	mov    %eax,(%esp)
c0108ed9:	e8 45 fe ff ff       	call   c0108d23 <printfmt>
            break;
c0108ede:	e9 3d 02 00 00       	jmp    c0109120 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108ee3:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ee6:	8d 50 04             	lea    0x4(%eax),%edx
c0108ee9:	89 55 14             	mov    %edx,0x14(%ebp)
c0108eec:	8b 30                	mov    (%eax),%esi
c0108eee:	85 f6                	test   %esi,%esi
c0108ef0:	75 05                	jne    c0108ef7 <vprintfmt+0x1a3>
                p = "(null)";
c0108ef2:	be 05 ba 10 c0       	mov    $0xc010ba05,%esi
            }
            if (width > 0 && padc != '-') {
c0108ef7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108efb:	7e 76                	jle    c0108f73 <vprintfmt+0x21f>
c0108efd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108f01:	74 70                	je     c0108f73 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f0a:	89 34 24             	mov    %esi,(%esp)
c0108f0d:	e8 ee 03 00 00       	call   c0109300 <strnlen>
c0108f12:	89 c2                	mov    %eax,%edx
c0108f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f17:	29 d0                	sub    %edx,%eax
c0108f19:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f1c:	eb 16                	jmp    c0108f34 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0108f1e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108f22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f25:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f29:	89 04 24             	mov    %eax,(%esp)
c0108f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f2f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f31:	ff 4d e8             	decl   -0x18(%ebp)
c0108f34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f38:	7f e4                	jg     c0108f1e <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108f3a:	eb 37                	jmp    c0108f73 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108f3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108f40:	74 1f                	je     c0108f61 <vprintfmt+0x20d>
c0108f42:	83 fb 1f             	cmp    $0x1f,%ebx
c0108f45:	7e 05                	jle    c0108f4c <vprintfmt+0x1f8>
c0108f47:	83 fb 7e             	cmp    $0x7e,%ebx
c0108f4a:	7e 15                	jle    c0108f61 <vprintfmt+0x20d>
                    putch('?', putdat);
c0108f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f53:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108f5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f5d:	ff d0                	call   *%eax
c0108f5f:	eb 0f                	jmp    c0108f70 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0108f61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f68:	89 1c 24             	mov    %ebx,(%esp)
c0108f6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f6e:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108f70:	ff 4d e8             	decl   -0x18(%ebp)
c0108f73:	89 f0                	mov    %esi,%eax
c0108f75:	8d 70 01             	lea    0x1(%eax),%esi
c0108f78:	0f b6 00             	movzbl (%eax),%eax
c0108f7b:	0f be d8             	movsbl %al,%ebx
c0108f7e:	85 db                	test   %ebx,%ebx
c0108f80:	74 27                	je     c0108fa9 <vprintfmt+0x255>
c0108f82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108f86:	78 b4                	js     c0108f3c <vprintfmt+0x1e8>
c0108f88:	ff 4d e4             	decl   -0x1c(%ebp)
c0108f8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108f8f:	79 ab                	jns    c0108f3c <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0108f91:	eb 16                	jmp    c0108fa9 <vprintfmt+0x255>
                putch(' ', putdat);
c0108f93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f9a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fa4:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0108fa6:	ff 4d e8             	decl   -0x18(%ebp)
c0108fa9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108fad:	7f e4                	jg     c0108f93 <vprintfmt+0x23f>
            }
            break;
c0108faf:	e9 6c 01 00 00       	jmp    c0109120 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fbb:	8d 45 14             	lea    0x14(%ebp),%eax
c0108fbe:	89 04 24             	mov    %eax,(%esp)
c0108fc1:	e8 16 fd ff ff       	call   c0108cdc <getint>
c0108fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108fc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108fd2:	85 d2                	test   %edx,%edx
c0108fd4:	79 26                	jns    c0108ffc <vprintfmt+0x2a8>
                putch('-', putdat);
c0108fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fdd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0108fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fe7:	ff d0                	call   *%eax
                num = -(long long)num;
c0108fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108fef:	f7 d8                	neg    %eax
c0108ff1:	83 d2 00             	adc    $0x0,%edx
c0108ff4:	f7 da                	neg    %edx
c0108ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108ff9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108ffc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109003:	e9 a8 00 00 00       	jmp    c01090b0 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109008:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010900b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010900f:	8d 45 14             	lea    0x14(%ebp),%eax
c0109012:	89 04 24             	mov    %eax,(%esp)
c0109015:	e8 73 fc ff ff       	call   c0108c8d <getuint>
c010901a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010901d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109020:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109027:	e9 84 00 00 00       	jmp    c01090b0 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010902c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010902f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109033:	8d 45 14             	lea    0x14(%ebp),%eax
c0109036:	89 04 24             	mov    %eax,(%esp)
c0109039:	e8 4f fc ff ff       	call   c0108c8d <getuint>
c010903e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109041:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109044:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010904b:	eb 63                	jmp    c01090b0 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010904d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109050:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109054:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010905b:	8b 45 08             	mov    0x8(%ebp),%eax
c010905e:	ff d0                	call   *%eax
            putch('x', putdat);
c0109060:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109063:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109067:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010906e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109071:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109073:	8b 45 14             	mov    0x14(%ebp),%eax
c0109076:	8d 50 04             	lea    0x4(%eax),%edx
c0109079:	89 55 14             	mov    %edx,0x14(%ebp)
c010907c:	8b 00                	mov    (%eax),%eax
c010907e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109081:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109088:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010908f:	eb 1f                	jmp    c01090b0 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109091:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109094:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109098:	8d 45 14             	lea    0x14(%ebp),%eax
c010909b:	89 04 24             	mov    %eax,(%esp)
c010909e:	e8 ea fb ff ff       	call   c0108c8d <getuint>
c01090a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01090a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01090b0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01090b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01090b7:	89 54 24 18          	mov    %edx,0x18(%esp)
c01090bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01090be:	89 54 24 14          	mov    %edx,0x14(%esp)
c01090c2:	89 44 24 10          	mov    %eax,0x10(%esp)
c01090c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01090d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01090d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090db:	8b 45 08             	mov    0x8(%ebp),%eax
c01090de:	89 04 24             	mov    %eax,(%esp)
c01090e1:	e8 a5 fa ff ff       	call   c0108b8b <printnum>
            break;
c01090e6:	eb 38                	jmp    c0109120 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01090e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090ef:	89 1c 24             	mov    %ebx,(%esp)
c01090f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01090f5:	ff d0                	call   *%eax
            break;
c01090f7:	eb 27                	jmp    c0109120 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01090f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109100:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109107:	8b 45 08             	mov    0x8(%ebp),%eax
c010910a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010910c:	ff 4d 10             	decl   0x10(%ebp)
c010910f:	eb 03                	jmp    c0109114 <vprintfmt+0x3c0>
c0109111:	ff 4d 10             	decl   0x10(%ebp)
c0109114:	8b 45 10             	mov    0x10(%ebp),%eax
c0109117:	48                   	dec    %eax
c0109118:	0f b6 00             	movzbl (%eax),%eax
c010911b:	3c 25                	cmp    $0x25,%al
c010911d:	75 f2                	jne    c0109111 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c010911f:	90                   	nop
    while (1) {
c0109120:	e9 37 fc ff ff       	jmp    c0108d5c <vprintfmt+0x8>
                return;
c0109125:	90                   	nop
        }
    }
}
c0109126:	83 c4 40             	add    $0x40,%esp
c0109129:	5b                   	pop    %ebx
c010912a:	5e                   	pop    %esi
c010912b:	5d                   	pop    %ebp
c010912c:	c3                   	ret    

c010912d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010912d:	55                   	push   %ebp
c010912e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109130:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109133:	8b 40 08             	mov    0x8(%eax),%eax
c0109136:	8d 50 01             	lea    0x1(%eax),%edx
c0109139:	8b 45 0c             	mov    0xc(%ebp),%eax
c010913c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010913f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109142:	8b 10                	mov    (%eax),%edx
c0109144:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109147:	8b 40 04             	mov    0x4(%eax),%eax
c010914a:	39 c2                	cmp    %eax,%edx
c010914c:	73 12                	jae    c0109160 <sprintputch+0x33>
        *b->buf ++ = ch;
c010914e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109151:	8b 00                	mov    (%eax),%eax
c0109153:	8d 48 01             	lea    0x1(%eax),%ecx
c0109156:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109159:	89 0a                	mov    %ecx,(%edx)
c010915b:	8b 55 08             	mov    0x8(%ebp),%edx
c010915e:	88 10                	mov    %dl,(%eax)
    }
}
c0109160:	90                   	nop
c0109161:	5d                   	pop    %ebp
c0109162:	c3                   	ret    

c0109163 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109163:	55                   	push   %ebp
c0109164:	89 e5                	mov    %esp,%ebp
c0109166:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109169:	8d 45 14             	lea    0x14(%ebp),%eax
c010916c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010916f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109172:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109176:	8b 45 10             	mov    0x10(%ebp),%eax
c0109179:	89 44 24 08          	mov    %eax,0x8(%esp)
c010917d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109184:	8b 45 08             	mov    0x8(%ebp),%eax
c0109187:	89 04 24             	mov    %eax,(%esp)
c010918a:	e8 0a 00 00 00       	call   c0109199 <vsnprintf>
c010918f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109192:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109195:	89 ec                	mov    %ebp,%esp
c0109197:	5d                   	pop    %ebp
c0109198:	c3                   	ret    

c0109199 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109199:	55                   	push   %ebp
c010919a:	89 e5                	mov    %esp,%ebp
c010919c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010919f:	8b 45 08             	mov    0x8(%ebp),%eax
c01091a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01091a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091a8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01091ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ae:	01 d0                	add    %edx,%eax
c01091b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01091b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01091ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01091be:	74 0a                	je     c01091ca <vsnprintf+0x31>
c01091c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01091c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091c6:	39 c2                	cmp    %eax,%edx
c01091c8:	76 07                	jbe    c01091d1 <vsnprintf+0x38>
        return -E_INVAL;
c01091ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01091cf:	eb 2a                	jmp    c01091fb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01091d1:	8b 45 14             	mov    0x14(%ebp),%eax
c01091d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01091d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01091db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01091df:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01091e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091e6:	c7 04 24 2d 91 10 c0 	movl   $0xc010912d,(%esp)
c01091ed:	e8 62 fb ff ff       	call   c0108d54 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01091f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01091f5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01091f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01091fb:	89 ec                	mov    %ebp,%esp
c01091fd:	5d                   	pop    %ebp
c01091fe:	c3                   	ret    

c01091ff <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01091ff:	55                   	push   %ebp
c0109200:	89 e5                	mov    %esp,%ebp
c0109202:	57                   	push   %edi
c0109203:	56                   	push   %esi
c0109204:	53                   	push   %ebx
c0109205:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109208:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010920d:	8b 15 84 4a 12 c0    	mov    0xc0124a84,%edx
c0109213:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109219:	6b f0 05             	imul   $0x5,%eax,%esi
c010921c:	01 fe                	add    %edi,%esi
c010921e:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109223:	f7 e7                	mul    %edi
c0109225:	01 d6                	add    %edx,%esi
c0109227:	89 f2                	mov    %esi,%edx
c0109229:	83 c0 0b             	add    $0xb,%eax
c010922c:	83 d2 00             	adc    $0x0,%edx
c010922f:	89 c7                	mov    %eax,%edi
c0109231:	83 e7 ff             	and    $0xffffffff,%edi
c0109234:	89 f9                	mov    %edi,%ecx
c0109236:	0f b7 da             	movzwl %dx,%ebx
c0109239:	89 0d 80 4a 12 c0    	mov    %ecx,0xc0124a80
c010923f:	89 1d 84 4a 12 c0    	mov    %ebx,0xc0124a84
    unsigned long long result = (next >> 12);
c0109245:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010924a:	8b 15 84 4a 12 c0    	mov    0xc0124a84,%edx
c0109250:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109254:	c1 ea 0c             	shr    $0xc,%edx
c0109257:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010925a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010925d:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109264:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010926a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010926d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109270:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109273:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109276:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010927a:	74 1c                	je     c0109298 <rand+0x99>
c010927c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010927f:	ba 00 00 00 00       	mov    $0x0,%edx
c0109284:	f7 75 dc             	divl   -0x24(%ebp)
c0109287:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010928a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010928d:	ba 00 00 00 00       	mov    $0x0,%edx
c0109292:	f7 75 dc             	divl   -0x24(%ebp)
c0109295:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109298:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010929b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010929e:	f7 75 dc             	divl   -0x24(%ebp)
c01092a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01092a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01092a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01092aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01092ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01092b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01092b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01092b6:	83 c4 24             	add    $0x24,%esp
c01092b9:	5b                   	pop    %ebx
c01092ba:	5e                   	pop    %esi
c01092bb:	5f                   	pop    %edi
c01092bc:	5d                   	pop    %ebp
c01092bd:	c3                   	ret    

c01092be <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01092be:	55                   	push   %ebp
c01092bf:	89 e5                	mov    %esp,%ebp
    next = seed;
c01092c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01092c4:	ba 00 00 00 00       	mov    $0x0,%edx
c01092c9:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01092ce:	89 15 84 4a 12 c0    	mov    %edx,0xc0124a84
}
c01092d4:	90                   	nop
c01092d5:	5d                   	pop    %ebp
c01092d6:	c3                   	ret    

c01092d7 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01092d7:	55                   	push   %ebp
c01092d8:	89 e5                	mov    %esp,%ebp
c01092da:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01092dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01092e4:	eb 03                	jmp    c01092e9 <strlen+0x12>
        cnt ++;
c01092e6:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01092e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01092ec:	8d 50 01             	lea    0x1(%eax),%edx
c01092ef:	89 55 08             	mov    %edx,0x8(%ebp)
c01092f2:	0f b6 00             	movzbl (%eax),%eax
c01092f5:	84 c0                	test   %al,%al
c01092f7:	75 ed                	jne    c01092e6 <strlen+0xf>
    }
    return cnt;
c01092f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01092fc:	89 ec                	mov    %ebp,%esp
c01092fe:	5d                   	pop    %ebp
c01092ff:	c3                   	ret    

c0109300 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109300:	55                   	push   %ebp
c0109301:	89 e5                	mov    %esp,%ebp
c0109303:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010930d:	eb 03                	jmp    c0109312 <strnlen+0x12>
        cnt ++;
c010930f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109312:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109315:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109318:	73 10                	jae    c010932a <strnlen+0x2a>
c010931a:	8b 45 08             	mov    0x8(%ebp),%eax
c010931d:	8d 50 01             	lea    0x1(%eax),%edx
c0109320:	89 55 08             	mov    %edx,0x8(%ebp)
c0109323:	0f b6 00             	movzbl (%eax),%eax
c0109326:	84 c0                	test   %al,%al
c0109328:	75 e5                	jne    c010930f <strnlen+0xf>
    }
    return cnt;
c010932a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010932d:	89 ec                	mov    %ebp,%esp
c010932f:	5d                   	pop    %ebp
c0109330:	c3                   	ret    

c0109331 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109331:	55                   	push   %ebp
c0109332:	89 e5                	mov    %esp,%ebp
c0109334:	57                   	push   %edi
c0109335:	56                   	push   %esi
c0109336:	83 ec 20             	sub    $0x20,%esp
c0109339:	8b 45 08             	mov    0x8(%ebp),%eax
c010933c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010933f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109342:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0109345:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010934b:	89 d1                	mov    %edx,%ecx
c010934d:	89 c2                	mov    %eax,%edx
c010934f:	89 ce                	mov    %ecx,%esi
c0109351:	89 d7                	mov    %edx,%edi
c0109353:	ac                   	lods   %ds:(%esi),%al
c0109354:	aa                   	stos   %al,%es:(%edi)
c0109355:	84 c0                	test   %al,%al
c0109357:	75 fa                	jne    c0109353 <strcpy+0x22>
c0109359:	89 fa                	mov    %edi,%edx
c010935b:	89 f1                	mov    %esi,%ecx
c010935d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109360:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109366:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109369:	83 c4 20             	add    $0x20,%esp
c010936c:	5e                   	pop    %esi
c010936d:	5f                   	pop    %edi
c010936e:	5d                   	pop    %ebp
c010936f:	c3                   	ret    

c0109370 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109370:	55                   	push   %ebp
c0109371:	89 e5                	mov    %esp,%ebp
c0109373:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109376:	8b 45 08             	mov    0x8(%ebp),%eax
c0109379:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010937c:	eb 1e                	jmp    c010939c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010937e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109381:	0f b6 10             	movzbl (%eax),%edx
c0109384:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109387:	88 10                	mov    %dl,(%eax)
c0109389:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010938c:	0f b6 00             	movzbl (%eax),%eax
c010938f:	84 c0                	test   %al,%al
c0109391:	74 03                	je     c0109396 <strncpy+0x26>
            src ++;
c0109393:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0109396:	ff 45 fc             	incl   -0x4(%ebp)
c0109399:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c010939c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01093a0:	75 dc                	jne    c010937e <strncpy+0xe>
    }
    return dst;
c01093a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01093a5:	89 ec                	mov    %ebp,%esp
c01093a7:	5d                   	pop    %ebp
c01093a8:	c3                   	ret    

c01093a9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01093a9:	55                   	push   %ebp
c01093aa:	89 e5                	mov    %esp,%ebp
c01093ac:	57                   	push   %edi
c01093ad:	56                   	push   %esi
c01093ae:	83 ec 20             	sub    $0x20,%esp
c01093b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01093b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01093bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01093c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01093c3:	89 d1                	mov    %edx,%ecx
c01093c5:	89 c2                	mov    %eax,%edx
c01093c7:	89 ce                	mov    %ecx,%esi
c01093c9:	89 d7                	mov    %edx,%edi
c01093cb:	ac                   	lods   %ds:(%esi),%al
c01093cc:	ae                   	scas   %es:(%edi),%al
c01093cd:	75 08                	jne    c01093d7 <strcmp+0x2e>
c01093cf:	84 c0                	test   %al,%al
c01093d1:	75 f8                	jne    c01093cb <strcmp+0x22>
c01093d3:	31 c0                	xor    %eax,%eax
c01093d5:	eb 04                	jmp    c01093db <strcmp+0x32>
c01093d7:	19 c0                	sbb    %eax,%eax
c01093d9:	0c 01                	or     $0x1,%al
c01093db:	89 fa                	mov    %edi,%edx
c01093dd:	89 f1                	mov    %esi,%ecx
c01093df:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01093e2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01093e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01093e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01093eb:	83 c4 20             	add    $0x20,%esp
c01093ee:	5e                   	pop    %esi
c01093ef:	5f                   	pop    %edi
c01093f0:	5d                   	pop    %ebp
c01093f1:	c3                   	ret    

c01093f2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01093f2:	55                   	push   %ebp
c01093f3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01093f5:	eb 09                	jmp    c0109400 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c01093f7:	ff 4d 10             	decl   0x10(%ebp)
c01093fa:	ff 45 08             	incl   0x8(%ebp)
c01093fd:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109404:	74 1a                	je     c0109420 <strncmp+0x2e>
c0109406:	8b 45 08             	mov    0x8(%ebp),%eax
c0109409:	0f b6 00             	movzbl (%eax),%eax
c010940c:	84 c0                	test   %al,%al
c010940e:	74 10                	je     c0109420 <strncmp+0x2e>
c0109410:	8b 45 08             	mov    0x8(%ebp),%eax
c0109413:	0f b6 10             	movzbl (%eax),%edx
c0109416:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109419:	0f b6 00             	movzbl (%eax),%eax
c010941c:	38 c2                	cmp    %al,%dl
c010941e:	74 d7                	je     c01093f7 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109420:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109424:	74 18                	je     c010943e <strncmp+0x4c>
c0109426:	8b 45 08             	mov    0x8(%ebp),%eax
c0109429:	0f b6 00             	movzbl (%eax),%eax
c010942c:	0f b6 d0             	movzbl %al,%edx
c010942f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109432:	0f b6 00             	movzbl (%eax),%eax
c0109435:	0f b6 c8             	movzbl %al,%ecx
c0109438:	89 d0                	mov    %edx,%eax
c010943a:	29 c8                	sub    %ecx,%eax
c010943c:	eb 05                	jmp    c0109443 <strncmp+0x51>
c010943e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109443:	5d                   	pop    %ebp
c0109444:	c3                   	ret    

c0109445 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109445:	55                   	push   %ebp
c0109446:	89 e5                	mov    %esp,%ebp
c0109448:	83 ec 04             	sub    $0x4,%esp
c010944b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010944e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109451:	eb 13                	jmp    c0109466 <strchr+0x21>
        if (*s == c) {
c0109453:	8b 45 08             	mov    0x8(%ebp),%eax
c0109456:	0f b6 00             	movzbl (%eax),%eax
c0109459:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010945c:	75 05                	jne    c0109463 <strchr+0x1e>
            return (char *)s;
c010945e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109461:	eb 12                	jmp    c0109475 <strchr+0x30>
        }
        s ++;
c0109463:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0109466:	8b 45 08             	mov    0x8(%ebp),%eax
c0109469:	0f b6 00             	movzbl (%eax),%eax
c010946c:	84 c0                	test   %al,%al
c010946e:	75 e3                	jne    c0109453 <strchr+0xe>
    }
    return NULL;
c0109470:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109475:	89 ec                	mov    %ebp,%esp
c0109477:	5d                   	pop    %ebp
c0109478:	c3                   	ret    

c0109479 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109479:	55                   	push   %ebp
c010947a:	89 e5                	mov    %esp,%ebp
c010947c:	83 ec 04             	sub    $0x4,%esp
c010947f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109482:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109485:	eb 0e                	jmp    c0109495 <strfind+0x1c>
        if (*s == c) {
c0109487:	8b 45 08             	mov    0x8(%ebp),%eax
c010948a:	0f b6 00             	movzbl (%eax),%eax
c010948d:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0109490:	74 0f                	je     c01094a1 <strfind+0x28>
            break;
        }
        s ++;
c0109492:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0109495:	8b 45 08             	mov    0x8(%ebp),%eax
c0109498:	0f b6 00             	movzbl (%eax),%eax
c010949b:	84 c0                	test   %al,%al
c010949d:	75 e8                	jne    c0109487 <strfind+0xe>
c010949f:	eb 01                	jmp    c01094a2 <strfind+0x29>
            break;
c01094a1:	90                   	nop
    }
    return (char *)s;
c01094a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01094a5:	89 ec                	mov    %ebp,%esp
c01094a7:	5d                   	pop    %ebp
c01094a8:	c3                   	ret    

c01094a9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01094a9:	55                   	push   %ebp
c01094aa:	89 e5                	mov    %esp,%ebp
c01094ac:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01094af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01094b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01094bd:	eb 03                	jmp    c01094c2 <strtol+0x19>
        s ++;
c01094bf:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01094c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c5:	0f b6 00             	movzbl (%eax),%eax
c01094c8:	3c 20                	cmp    $0x20,%al
c01094ca:	74 f3                	je     c01094bf <strtol+0x16>
c01094cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01094cf:	0f b6 00             	movzbl (%eax),%eax
c01094d2:	3c 09                	cmp    $0x9,%al
c01094d4:	74 e9                	je     c01094bf <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01094d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01094d9:	0f b6 00             	movzbl (%eax),%eax
c01094dc:	3c 2b                	cmp    $0x2b,%al
c01094de:	75 05                	jne    c01094e5 <strtol+0x3c>
        s ++;
c01094e0:	ff 45 08             	incl   0x8(%ebp)
c01094e3:	eb 14                	jmp    c01094f9 <strtol+0x50>
    }
    else if (*s == '-') {
c01094e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e8:	0f b6 00             	movzbl (%eax),%eax
c01094eb:	3c 2d                	cmp    $0x2d,%al
c01094ed:	75 0a                	jne    c01094f9 <strtol+0x50>
        s ++, neg = 1;
c01094ef:	ff 45 08             	incl   0x8(%ebp)
c01094f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01094f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01094fd:	74 06                	je     c0109505 <strtol+0x5c>
c01094ff:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109503:	75 22                	jne    c0109527 <strtol+0x7e>
c0109505:	8b 45 08             	mov    0x8(%ebp),%eax
c0109508:	0f b6 00             	movzbl (%eax),%eax
c010950b:	3c 30                	cmp    $0x30,%al
c010950d:	75 18                	jne    c0109527 <strtol+0x7e>
c010950f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109512:	40                   	inc    %eax
c0109513:	0f b6 00             	movzbl (%eax),%eax
c0109516:	3c 78                	cmp    $0x78,%al
c0109518:	75 0d                	jne    c0109527 <strtol+0x7e>
        s += 2, base = 16;
c010951a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010951e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109525:	eb 29                	jmp    c0109550 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0109527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010952b:	75 16                	jne    c0109543 <strtol+0x9a>
c010952d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109530:	0f b6 00             	movzbl (%eax),%eax
c0109533:	3c 30                	cmp    $0x30,%al
c0109535:	75 0c                	jne    c0109543 <strtol+0x9a>
        s ++, base = 8;
c0109537:	ff 45 08             	incl   0x8(%ebp)
c010953a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109541:	eb 0d                	jmp    c0109550 <strtol+0xa7>
    }
    else if (base == 0) {
c0109543:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109547:	75 07                	jne    c0109550 <strtol+0xa7>
        base = 10;
c0109549:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109550:	8b 45 08             	mov    0x8(%ebp),%eax
c0109553:	0f b6 00             	movzbl (%eax),%eax
c0109556:	3c 2f                	cmp    $0x2f,%al
c0109558:	7e 1b                	jle    c0109575 <strtol+0xcc>
c010955a:	8b 45 08             	mov    0x8(%ebp),%eax
c010955d:	0f b6 00             	movzbl (%eax),%eax
c0109560:	3c 39                	cmp    $0x39,%al
c0109562:	7f 11                	jg     c0109575 <strtol+0xcc>
            dig = *s - '0';
c0109564:	8b 45 08             	mov    0x8(%ebp),%eax
c0109567:	0f b6 00             	movzbl (%eax),%eax
c010956a:	0f be c0             	movsbl %al,%eax
c010956d:	83 e8 30             	sub    $0x30,%eax
c0109570:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109573:	eb 48                	jmp    c01095bd <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109575:	8b 45 08             	mov    0x8(%ebp),%eax
c0109578:	0f b6 00             	movzbl (%eax),%eax
c010957b:	3c 60                	cmp    $0x60,%al
c010957d:	7e 1b                	jle    c010959a <strtol+0xf1>
c010957f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109582:	0f b6 00             	movzbl (%eax),%eax
c0109585:	3c 7a                	cmp    $0x7a,%al
c0109587:	7f 11                	jg     c010959a <strtol+0xf1>
            dig = *s - 'a' + 10;
c0109589:	8b 45 08             	mov    0x8(%ebp),%eax
c010958c:	0f b6 00             	movzbl (%eax),%eax
c010958f:	0f be c0             	movsbl %al,%eax
c0109592:	83 e8 57             	sub    $0x57,%eax
c0109595:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109598:	eb 23                	jmp    c01095bd <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010959a:	8b 45 08             	mov    0x8(%ebp),%eax
c010959d:	0f b6 00             	movzbl (%eax),%eax
c01095a0:	3c 40                	cmp    $0x40,%al
c01095a2:	7e 3b                	jle    c01095df <strtol+0x136>
c01095a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a7:	0f b6 00             	movzbl (%eax),%eax
c01095aa:	3c 5a                	cmp    $0x5a,%al
c01095ac:	7f 31                	jg     c01095df <strtol+0x136>
            dig = *s - 'A' + 10;
c01095ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b1:	0f b6 00             	movzbl (%eax),%eax
c01095b4:	0f be c0             	movsbl %al,%eax
c01095b7:	83 e8 37             	sub    $0x37,%eax
c01095ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01095bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095c0:	3b 45 10             	cmp    0x10(%ebp),%eax
c01095c3:	7d 19                	jge    c01095de <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c01095c5:	ff 45 08             	incl   0x8(%ebp)
c01095c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095cb:	0f af 45 10          	imul   0x10(%ebp),%eax
c01095cf:	89 c2                	mov    %eax,%edx
c01095d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095d4:	01 d0                	add    %edx,%eax
c01095d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01095d9:	e9 72 ff ff ff       	jmp    c0109550 <strtol+0xa7>
            break;
c01095de:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01095df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01095e3:	74 08                	je     c01095ed <strtol+0x144>
        *endptr = (char *) s;
c01095e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01095eb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01095ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01095f1:	74 07                	je     c01095fa <strtol+0x151>
c01095f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095f6:	f7 d8                	neg    %eax
c01095f8:	eb 03                	jmp    c01095fd <strtol+0x154>
c01095fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01095fd:	89 ec                	mov    %ebp,%esp
c01095ff:	5d                   	pop    %ebp
c0109600:	c3                   	ret    

c0109601 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109601:	55                   	push   %ebp
c0109602:	89 e5                	mov    %esp,%ebp
c0109604:	83 ec 28             	sub    $0x28,%esp
c0109607:	89 7d fc             	mov    %edi,-0x4(%ebp)
c010960a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010960d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109610:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0109614:	8b 45 08             	mov    0x8(%ebp),%eax
c0109617:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010961a:	88 55 f7             	mov    %dl,-0x9(%ebp)
c010961d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109620:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109623:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109626:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010962a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010962d:	89 d7                	mov    %edx,%edi
c010962f:	f3 aa                	rep stos %al,%es:(%edi)
c0109631:	89 fa                	mov    %edi,%edx
c0109633:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109636:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109639:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010963c:	8b 7d fc             	mov    -0x4(%ebp),%edi
c010963f:	89 ec                	mov    %ebp,%esp
c0109641:	5d                   	pop    %ebp
c0109642:	c3                   	ret    

c0109643 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109643:	55                   	push   %ebp
c0109644:	89 e5                	mov    %esp,%ebp
c0109646:	57                   	push   %edi
c0109647:	56                   	push   %esi
c0109648:	53                   	push   %ebx
c0109649:	83 ec 30             	sub    $0x30,%esp
c010964c:	8b 45 08             	mov    0x8(%ebp),%eax
c010964f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109652:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109655:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109658:	8b 45 10             	mov    0x10(%ebp),%eax
c010965b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010965e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109661:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109664:	73 42                	jae    c01096a8 <memmove+0x65>
c0109666:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010966c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010966f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109675:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109678:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010967b:	c1 e8 02             	shr    $0x2,%eax
c010967e:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0109680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109683:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109686:	89 d7                	mov    %edx,%edi
c0109688:	89 c6                	mov    %eax,%esi
c010968a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010968c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010968f:	83 e1 03             	and    $0x3,%ecx
c0109692:	74 02                	je     c0109696 <memmove+0x53>
c0109694:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109696:	89 f0                	mov    %esi,%eax
c0109698:	89 fa                	mov    %edi,%edx
c010969a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010969d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01096a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01096a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01096a6:	eb 36                	jmp    c01096de <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01096a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096ab:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01096b1:	01 c2                	add    %eax,%edx
c01096b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096b6:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01096b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096bc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01096bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096c2:	89 c1                	mov    %eax,%ecx
c01096c4:	89 d8                	mov    %ebx,%eax
c01096c6:	89 d6                	mov    %edx,%esi
c01096c8:	89 c7                	mov    %eax,%edi
c01096ca:	fd                   	std    
c01096cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01096cd:	fc                   	cld    
c01096ce:	89 f8                	mov    %edi,%eax
c01096d0:	89 f2                	mov    %esi,%edx
c01096d2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01096d5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01096d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01096db:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01096de:	83 c4 30             	add    $0x30,%esp
c01096e1:	5b                   	pop    %ebx
c01096e2:	5e                   	pop    %esi
c01096e3:	5f                   	pop    %edi
c01096e4:	5d                   	pop    %ebp
c01096e5:	c3                   	ret    

c01096e6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01096e6:	55                   	push   %ebp
c01096e7:	89 e5                	mov    %esp,%ebp
c01096e9:	57                   	push   %edi
c01096ea:	56                   	push   %esi
c01096eb:	83 ec 20             	sub    $0x20,%esp
c01096ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01096f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01096f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01096fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109700:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109703:	c1 e8 02             	shr    $0x2,%eax
c0109706:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0109708:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010970b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010970e:	89 d7                	mov    %edx,%edi
c0109710:	89 c6                	mov    %eax,%esi
c0109712:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109714:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109717:	83 e1 03             	and    $0x3,%ecx
c010971a:	74 02                	je     c010971e <memcpy+0x38>
c010971c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010971e:	89 f0                	mov    %esi,%eax
c0109720:	89 fa                	mov    %edi,%edx
c0109722:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109725:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109728:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010972b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010972e:	83 c4 20             	add    $0x20,%esp
c0109731:	5e                   	pop    %esi
c0109732:	5f                   	pop    %edi
c0109733:	5d                   	pop    %ebp
c0109734:	c3                   	ret    

c0109735 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109735:	55                   	push   %ebp
c0109736:	89 e5                	mov    %esp,%ebp
c0109738:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010973b:	8b 45 08             	mov    0x8(%ebp),%eax
c010973e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109741:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109744:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109747:	eb 2e                	jmp    c0109777 <memcmp+0x42>
        if (*s1 != *s2) {
c0109749:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010974c:	0f b6 10             	movzbl (%eax),%edx
c010974f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109752:	0f b6 00             	movzbl (%eax),%eax
c0109755:	38 c2                	cmp    %al,%dl
c0109757:	74 18                	je     c0109771 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109759:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010975c:	0f b6 00             	movzbl (%eax),%eax
c010975f:	0f b6 d0             	movzbl %al,%edx
c0109762:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109765:	0f b6 00             	movzbl (%eax),%eax
c0109768:	0f b6 c8             	movzbl %al,%ecx
c010976b:	89 d0                	mov    %edx,%eax
c010976d:	29 c8                	sub    %ecx,%eax
c010976f:	eb 18                	jmp    c0109789 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0109771:	ff 45 fc             	incl   -0x4(%ebp)
c0109774:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0109777:	8b 45 10             	mov    0x10(%ebp),%eax
c010977a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010977d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109780:	85 c0                	test   %eax,%eax
c0109782:	75 c5                	jne    c0109749 <memcmp+0x14>
    }
    return 0;
c0109784:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109789:	89 ec                	mov    %ebp,%esp
c010978b:	5d                   	pop    %ebp
c010978c:	c3                   	ret    
