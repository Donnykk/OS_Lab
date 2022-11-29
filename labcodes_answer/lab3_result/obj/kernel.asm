
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 30 12 00       	mov    $0x123000,%eax
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
c0100020:	a3 00 30 12 c0       	mov    %eax,0xc0123000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 20 12 c0       	mov    $0xc0122000,%esp
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

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 14 61 12 c0       	mov    $0xc0126114,%eax
c0100041:	2d 00 50 12 c0       	sub    $0xc0125000,%eax
c0100046:	83 ec 04             	sub    $0x4,%esp
c0100049:	50                   	push   %eax
c010004a:	6a 00                	push   $0x0
c010004c:	68 00 50 12 c0       	push   $0xc0125000
c0100051:	e8 f1 80 00 00       	call   c0108147 <memset>
c0100056:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100059:	e8 92 15 00 00       	call   c01015f0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005e:	c7 45 f4 e0 82 10 c0 	movl   $0xc01082e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100065:	83 ec 08             	sub    $0x8,%esp
c0100068:	ff 75 f4             	push   -0xc(%ebp)
c010006b:	68 fc 82 10 c0       	push   $0xc01082fc
c0100070:	e8 cb 02 00 00       	call   c0100340 <cprintf>
c0100075:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100078:	e8 c1 07 00 00       	call   c010083e <print_kerninfo>

    grade_backtrace();
c010007d:	e8 83 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100082:	e8 6f 49 00 00       	call   c01049f6 <pmm_init>

    pic_init();                 // init interrupt controller
c0100087:	e8 a8 1e 00 00       	call   c0101f34 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008c:	e8 09 20 00 00       	call   c010209a <idt_init>

    vmm_init();                 // init virtual memory management
c0100091:	e8 c3 6c 00 00       	call   c0106d59 <vmm_init>

    ide_init();                 // init ide devices
c0100096:	e8 9b 16 00 00       	call   c0101736 <ide_init>
    swap_init();                // init swap
c010009b:	e8 36 5a 00 00       	call   c0105ad6 <swap_init>

    clock_init();               // init clock interrupt
c01000a0:	e8 ce 0c 00 00       	call   c0100d73 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a5:	e8 f2 1d 00 00       	call   c0101e9c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000aa:	eb fe                	jmp    c01000aa <kern_init+0x74>

c01000ac <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ac:	55                   	push   %ebp
c01000ad:	89 e5                	mov    %esp,%ebp
c01000af:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000b2:	83 ec 04             	sub    $0x4,%esp
c01000b5:	6a 00                	push   $0x0
c01000b7:	6a 00                	push   $0x0
c01000b9:	6a 00                	push   $0x0
c01000bb:	e8 cd 0b 00 00       	call   c0100c8d <mon_backtrace>
c01000c0:	83 c4 10             	add    $0x10,%esp
}
c01000c3:	90                   	nop
c01000c4:	c9                   	leave  
c01000c5:	c3                   	ret    

c01000c6 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c6:	55                   	push   %ebp
c01000c7:	89 e5                	mov    %esp,%ebp
c01000c9:	53                   	push   %ebx
c01000ca:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000cd:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d3:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d9:	51                   	push   %ecx
c01000da:	52                   	push   %edx
c01000db:	53                   	push   %ebx
c01000dc:	50                   	push   %eax
c01000dd:	e8 ca ff ff ff       	call   c01000ac <grade_backtrace2>
c01000e2:	83 c4 10             	add    $0x10,%esp
}
c01000e5:	90                   	nop
c01000e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000e9:	c9                   	leave  
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	83 ec 08             	sub    $0x8,%esp
c01000f4:	ff 75 10             	push   0x10(%ebp)
c01000f7:	ff 75 08             	push   0x8(%ebp)
c01000fa:	e8 c7 ff ff ff       	call   c01000c6 <grade_backtrace1>
c01000ff:	83 c4 10             	add    $0x10,%esp
}
c0100102:	90                   	nop
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100110:	83 ec 04             	sub    $0x4,%esp
c0100113:	68 00 00 ff ff       	push   $0xffff0000
c0100118:	50                   	push   %eax
c0100119:	6a 00                	push   $0x0
c010011b:	e8 cb ff ff ff       	call   c01000eb <grade_backtrace0>
c0100120:	83 c4 10             	add    $0x10,%esp
}
c0100123:	90                   	nop
c0100124:	c9                   	leave  
c0100125:	c3                   	ret    

c0100126 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100126:	55                   	push   %ebp
c0100127:	89 e5                	mov    %esp,%ebp
c0100129:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010012c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010012f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100132:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100135:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100138:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010013c:	0f b7 c0             	movzwl %ax,%eax
c010013f:	83 e0 03             	and    $0x3,%eax
c0100142:	89 c2                	mov    %eax,%edx
c0100144:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c0100149:	83 ec 04             	sub    $0x4,%esp
c010014c:	52                   	push   %edx
c010014d:	50                   	push   %eax
c010014e:	68 01 83 10 c0       	push   $0xc0108301
c0100153:	e8 e8 01 00 00       	call   c0100340 <cprintf>
c0100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010015b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015f:	0f b7 d0             	movzwl %ax,%edx
c0100162:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c0100167:	83 ec 04             	sub    $0x4,%esp
c010016a:	52                   	push   %edx
c010016b:	50                   	push   %eax
c010016c:	68 0f 83 10 c0       	push   $0xc010830f
c0100171:	e8 ca 01 00 00       	call   c0100340 <cprintf>
c0100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100179:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010017d:	0f b7 d0             	movzwl %ax,%edx
c0100180:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c0100185:	83 ec 04             	sub    $0x4,%esp
c0100188:	52                   	push   %edx
c0100189:	50                   	push   %eax
c010018a:	68 1d 83 10 c0       	push   $0xc010831d
c010018f:	e8 ac 01 00 00       	call   c0100340 <cprintf>
c0100194:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100197:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010019b:	0f b7 d0             	movzwl %ax,%edx
c010019e:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c01001a3:	83 ec 04             	sub    $0x4,%esp
c01001a6:	52                   	push   %edx
c01001a7:	50                   	push   %eax
c01001a8:	68 2b 83 10 c0       	push   $0xc010832b
c01001ad:	e8 8e 01 00 00       	call   c0100340 <cprintf>
c01001b2:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001b5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001b9:	0f b7 d0             	movzwl %ax,%edx
c01001bc:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c01001c1:	83 ec 04             	sub    $0x4,%esp
c01001c4:	52                   	push   %edx
c01001c5:	50                   	push   %eax
c01001c6:	68 39 83 10 c0       	push   $0xc0108339
c01001cb:	e8 70 01 00 00       	call   c0100340 <cprintf>
c01001d0:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001d3:	a1 00 50 12 c0       	mov    0xc0125000,%eax
c01001d8:	83 c0 01             	add    $0x1,%eax
c01001db:	a3 00 50 12 c0       	mov    %eax,0xc0125000
}
c01001e0:	90                   	nop
c01001e1:	c9                   	leave  
c01001e2:	c3                   	ret    

c01001e3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001e3:	55                   	push   %ebp
c01001e4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001e6:	90                   	nop
c01001e7:	5d                   	pop    %ebp
c01001e8:	c3                   	ret    

c01001e9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001e9:	55                   	push   %ebp
c01001ea:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001ec:	90                   	nop
c01001ed:	5d                   	pop    %ebp
c01001ee:	c3                   	ret    

c01001ef <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001ef:	55                   	push   %ebp
c01001f0:	89 e5                	mov    %esp,%ebp
c01001f2:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001f5:	e8 2c ff ff ff       	call   c0100126 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001fa:	83 ec 0c             	sub    $0xc,%esp
c01001fd:	68 48 83 10 c0       	push   $0xc0108348
c0100202:	e8 39 01 00 00       	call   c0100340 <cprintf>
c0100207:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010020a:	e8 d4 ff ff ff       	call   c01001e3 <lab1_switch_to_user>
    lab1_print_cur_status();
c010020f:	e8 12 ff ff ff       	call   c0100126 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100214:	83 ec 0c             	sub    $0xc,%esp
c0100217:	68 68 83 10 c0       	push   $0xc0108368
c010021c:	e8 1f 01 00 00       	call   c0100340 <cprintf>
c0100221:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100224:	e8 c0 ff ff ff       	call   c01001e9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100229:	e8 f8 fe ff ff       	call   c0100126 <lab1_print_cur_status>
}
c010022e:	90                   	nop
c010022f:	c9                   	leave  
c0100230:	c3                   	ret    

c0100231 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100231:	55                   	push   %ebp
c0100232:	89 e5                	mov    %esp,%ebp
c0100234:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023b:	74 13                	je     c0100250 <readline+0x1f>
        cprintf("%s", prompt);
c010023d:	83 ec 08             	sub    $0x8,%esp
c0100240:	ff 75 08             	push   0x8(%ebp)
c0100243:	68 87 83 10 c0       	push   $0xc0108387
c0100248:	e8 f3 00 00 00       	call   c0100340 <cprintf>
c010024d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100257:	e8 6f 01 00 00       	call   c01003cb <getchar>
c010025c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010025f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100263:	79 0a                	jns    c010026f <readline+0x3e>
            return NULL;
c0100265:	b8 00 00 00 00       	mov    $0x0,%eax
c010026a:	e9 82 00 00 00       	jmp    c01002f1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100273:	7e 2b                	jle    c01002a0 <readline+0x6f>
c0100275:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027c:	7f 22                	jg     c01002a0 <readline+0x6f>
            cputchar(c);
c010027e:	83 ec 0c             	sub    $0xc,%esp
c0100281:	ff 75 f0             	push   -0x10(%ebp)
c0100284:	e8 dd 00 00 00       	call   c0100366 <cputchar>
c0100289:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010028c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028f:	8d 50 01             	lea    0x1(%eax),%edx
c0100292:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100295:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100298:	88 90 20 50 12 c0    	mov    %dl,-0x3fedafe0(%eax)
c010029e:	eb 4c                	jmp    c01002ec <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c01002a0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a4:	75 1a                	jne    c01002c0 <readline+0x8f>
c01002a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002aa:	7e 14                	jle    c01002c0 <readline+0x8f>
            cputchar(c);
c01002ac:	83 ec 0c             	sub    $0xc,%esp
c01002af:	ff 75 f0             	push   -0x10(%ebp)
c01002b2:	e8 af 00 00 00       	call   c0100366 <cputchar>
c01002b7:	83 c4 10             	add    $0x10,%esp
            i --;
c01002ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002be:	eb 2c                	jmp    c01002ec <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01002c0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c4:	74 06                	je     c01002cc <readline+0x9b>
c01002c6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002ca:	75 8b                	jne    c0100257 <readline+0x26>
            cputchar(c);
c01002cc:	83 ec 0c             	sub    $0xc,%esp
c01002cf:	ff 75 f0             	push   -0x10(%ebp)
c01002d2:	e8 8f 00 00 00       	call   c0100366 <cputchar>
c01002d7:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01002da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002dd:	05 20 50 12 c0       	add    $0xc0125020,%eax
c01002e2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e5:	b8 20 50 12 c0       	mov    $0xc0125020,%eax
c01002ea:	eb 05                	jmp    c01002f1 <readline+0xc0>
        c = getchar();
c01002ec:	e9 66 ff ff ff       	jmp    c0100257 <readline+0x26>
        }
    }
}
c01002f1:	c9                   	leave  
c01002f2:	c3                   	ret    

c01002f3 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f3:	55                   	push   %ebp
c01002f4:	89 e5                	mov    %esp,%ebp
c01002f6:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002f9:	83 ec 0c             	sub    $0xc,%esp
c01002fc:	ff 75 08             	push   0x8(%ebp)
c01002ff:	e8 1d 13 00 00       	call   c0101621 <cons_putc>
c0100304:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100307:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030a:	8b 00                	mov    (%eax),%eax
c010030c:	8d 50 01             	lea    0x1(%eax),%edx
c010030f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100312:	89 10                	mov    %edx,(%eax)
}
c0100314:	90                   	nop
c0100315:	c9                   	leave  
c0100316:	c3                   	ret    

c0100317 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100317:	55                   	push   %ebp
c0100318:	89 e5                	mov    %esp,%ebp
c010031a:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100324:	ff 75 0c             	push   0xc(%ebp)
c0100327:	ff 75 08             	push   0x8(%ebp)
c010032a:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010032d:	50                   	push   %eax
c010032e:	68 f3 02 10 c0       	push   $0xc01002f3
c0100333:	e8 a7 75 00 00       	call   c01078df <vprintfmt>
c0100338:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010033b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033e:	c9                   	leave  
c010033f:	c3                   	ret    

c0100340 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100340:	55                   	push   %ebp
c0100341:	89 e5                	mov    %esp,%ebp
c0100343:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100346:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100349:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034f:	83 ec 08             	sub    $0x8,%esp
c0100352:	50                   	push   %eax
c0100353:	ff 75 08             	push   0x8(%ebp)
c0100356:	e8 bc ff ff ff       	call   c0100317 <vcprintf>
c010035b:	83 c4 10             	add    $0x10,%esp
c010035e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100361:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100364:	c9                   	leave  
c0100365:	c3                   	ret    

c0100366 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100366:	55                   	push   %ebp
c0100367:	89 e5                	mov    %esp,%ebp
c0100369:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010036c:	83 ec 0c             	sub    $0xc,%esp
c010036f:	ff 75 08             	push   0x8(%ebp)
c0100372:	e8 aa 12 00 00       	call   c0101621 <cons_putc>
c0100377:	83 c4 10             	add    $0x10,%esp
}
c010037a:	90                   	nop
c010037b:	c9                   	leave  
c010037c:	c3                   	ret    

c010037d <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010037d:	55                   	push   %ebp
c010037e:	89 e5                	mov    %esp,%ebp
c0100380:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038a:	eb 14                	jmp    c01003a0 <cputs+0x23>
        cputch(c, &cnt);
c010038c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100390:	83 ec 08             	sub    $0x8,%esp
c0100393:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100396:	52                   	push   %edx
c0100397:	50                   	push   %eax
c0100398:	e8 56 ff ff ff       	call   c01002f3 <cputch>
c010039d:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c01003a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a3:	8d 50 01             	lea    0x1(%eax),%edx
c01003a6:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a9:	0f b6 00             	movzbl (%eax),%eax
c01003ac:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003af:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b3:	75 d7                	jne    c010038c <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003b5:	83 ec 08             	sub    $0x8,%esp
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	50                   	push   %eax
c01003bc:	6a 0a                	push   $0xa
c01003be:	e8 30 ff ff ff       	call   c01002f3 <cputch>
c01003c3:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c9:	c9                   	leave  
c01003ca:	c3                   	ret    

c01003cb <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003cb:	55                   	push   %ebp
c01003cc:	89 e5                	mov    %esp,%ebp
c01003ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d1:	90                   	nop
c01003d2:	e8 93 12 00 00       	call   c010166a <cons_getc>
c01003d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003de:	74 f2                	je     c01003d2 <getchar+0x7>
        /* do nothing */;
    return c;
c01003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e3:	c9                   	leave  
c01003e4:	c3                   	ret    

c01003e5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e5:	55                   	push   %ebp
c01003e6:	89 e5                	mov    %esp,%ebp
c01003e8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01003f6:	8b 00                	mov    (%eax),%eax
c01003f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100402:	e9 d2 00 00 00       	jmp    c01004d9 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100407:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010040a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040d:	01 d0                	add    %edx,%eax
c010040f:	89 c2                	mov    %eax,%edx
c0100411:	c1 ea 1f             	shr    $0x1f,%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	d1 f8                	sar    %eax
c0100418:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010041e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100421:	eb 04                	jmp    c0100427 <stab_binsearch+0x42>
            m --;
c0100423:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100427:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010042d:	7c 1f                	jl     c010044e <stab_binsearch+0x69>
c010042f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100432:	89 d0                	mov    %edx,%eax
c0100434:	01 c0                	add    %eax,%eax
c0100436:	01 d0                	add    %edx,%eax
c0100438:	c1 e0 02             	shl    $0x2,%eax
c010043b:	89 c2                	mov    %eax,%edx
c010043d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100440:	01 d0                	add    %edx,%eax
c0100442:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100446:	0f b6 c0             	movzbl %al,%eax
c0100449:	39 45 14             	cmp    %eax,0x14(%ebp)
c010044c:	75 d5                	jne    c0100423 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100451:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100454:	7d 0b                	jge    c0100461 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100456:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100459:	83 c0 01             	add    $0x1,%eax
c010045c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010045f:	eb 78                	jmp    c01004d9 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100461:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100468:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046b:	89 d0                	mov    %edx,%eax
c010046d:	01 c0                	add    %eax,%eax
c010046f:	01 d0                	add    %edx,%eax
c0100471:	c1 e0 02             	shl    $0x2,%eax
c0100474:	89 c2                	mov    %eax,%edx
c0100476:	8b 45 08             	mov    0x8(%ebp),%eax
c0100479:	01 d0                	add    %edx,%eax
c010047b:	8b 40 08             	mov    0x8(%eax),%eax
c010047e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100481:	76 13                	jbe    c0100496 <stab_binsearch+0xb1>
            *region_left = m;
c0100483:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100486:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100489:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010048e:	83 c0 01             	add    $0x1,%eax
c0100491:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100494:	eb 43                	jmp    c01004d9 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100496:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100499:	89 d0                	mov    %edx,%eax
c010049b:	01 c0                	add    %eax,%eax
c010049d:	01 d0                	add    %edx,%eax
c010049f:	c1 e0 02             	shl    $0x2,%eax
c01004a2:	89 c2                	mov    %eax,%edx
c01004a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a7:	01 d0                	add    %edx,%eax
c01004a9:	8b 40 08             	mov    0x8(%eax),%eax
c01004ac:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004af:	73 16                	jae    c01004c7 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ba:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bf:	83 e8 01             	sub    $0x1,%eax
c01004c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c5:	eb 12                	jmp    c01004d9 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004cd:	89 10                	mov    %edx,(%eax)
            l = m;
c01004cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01004d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004df:	0f 8e 22 ff ff ff    	jle    c0100407 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e9:	75 0f                	jne    c01004fa <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ee:	8b 00                	mov    (%eax),%eax
c01004f0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f6:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01004f8:	eb 3f                	jmp    c0100539 <stab_binsearch+0x154>
        l = *region_right;
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100502:	eb 04                	jmp    c0100508 <stab_binsearch+0x123>
c0100504:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100508:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050b:	8b 00                	mov    (%eax),%eax
c010050d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100510:	7e 1f                	jle    c0100531 <stab_binsearch+0x14c>
c0100512:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100515:	89 d0                	mov    %edx,%eax
c0100517:	01 c0                	add    %eax,%eax
c0100519:	01 d0                	add    %edx,%eax
c010051b:	c1 e0 02             	shl    $0x2,%eax
c010051e:	89 c2                	mov    %eax,%edx
c0100520:	8b 45 08             	mov    0x8(%ebp),%eax
c0100523:	01 d0                	add    %edx,%eax
c0100525:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100529:	0f b6 c0             	movzbl %al,%eax
c010052c:	39 45 14             	cmp    %eax,0x14(%ebp)
c010052f:	75 d3                	jne    c0100504 <stab_binsearch+0x11f>
        *region_left = l;
c0100531:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100534:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100537:	89 10                	mov    %edx,(%eax)
}
c0100539:	90                   	nop
c010053a:	c9                   	leave  
c010053b:	c3                   	ret    

c010053c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053c:	55                   	push   %ebp
c010053d:	89 e5                	mov    %esp,%ebp
c010053f:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 00 8c 83 10 c0    	movl   $0xc010838c,(%eax)
    info->eip_line = 0;
c010054b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100558:	c7 40 08 8c 83 10 c0 	movl   $0xc010838c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010055f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100562:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	8b 55 08             	mov    0x8(%ebp),%edx
c010056f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100575:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057c:	c7 45 f4 60 a3 10 c0 	movl   $0xc010a360,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100583:	c7 45 f0 44 a6 11 c0 	movl   $0xc011a644,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058a:	c7 45 ec 45 a6 11 c0 	movl   $0xc011a645,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100591:	c7 45 e8 e7 f4 11 c0 	movl   $0xc011f4e7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100598:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010059e:	76 0d                	jbe    c01005ad <debuginfo_eip+0x71>
c01005a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a3:	83 e8 01             	sub    $0x1,%eax
c01005a6:	0f b6 00             	movzbl (%eax),%eax
c01005a9:	84 c0                	test   %al,%al
c01005ab:	74 0a                	je     c01005b7 <debuginfo_eip+0x7b>
        return -1;
c01005ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b2:	e9 85 02 00 00       	jmp    c010083c <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005c1:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005c4:	c1 f8 02             	sar    $0x2,%eax
c01005c7:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005cd:	83 e8 01             	sub    $0x1,%eax
c01005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d3:	ff 75 08             	push   0x8(%ebp)
c01005d6:	6a 64                	push   $0x64
c01005d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005db:	50                   	push   %eax
c01005dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005df:	50                   	push   %eax
c01005e0:	ff 75 f4             	push   -0xc(%ebp)
c01005e3:	e8 fd fd ff ff       	call   c01003e5 <stab_binsearch>
c01005e8:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005ee:	85 c0                	test   %eax,%eax
c01005f0:	75 0a                	jne    c01005fc <debuginfo_eip+0xc0>
        return -1;
c01005f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005f7:	e9 40 02 00 00       	jmp    c010083c <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100602:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100605:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100608:	ff 75 08             	push   0x8(%ebp)
c010060b:	6a 24                	push   $0x24
c010060d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100610:	50                   	push   %eax
c0100611:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100614:	50                   	push   %eax
c0100615:	ff 75 f4             	push   -0xc(%ebp)
c0100618:	e8 c8 fd ff ff       	call   c01003e5 <stab_binsearch>
c010061d:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100620:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100623:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100626:	39 c2                	cmp    %eax,%edx
c0100628:	7f 78                	jg     c01006a2 <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010062a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010062d:	89 c2                	mov    %eax,%edx
c010062f:	89 d0                	mov    %edx,%eax
c0100631:	01 c0                	add    %eax,%eax
c0100633:	01 d0                	add    %edx,%eax
c0100635:	c1 e0 02             	shl    $0x2,%eax
c0100638:	89 c2                	mov    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	01 d0                	add    %edx,%eax
c010063f:	8b 10                	mov    (%eax),%edx
c0100641:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100644:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100647:	39 c2                	cmp    %eax,%edx
c0100649:	73 22                	jae    c010066d <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010064e:	89 c2                	mov    %eax,%edx
c0100650:	89 d0                	mov    %edx,%eax
c0100652:	01 c0                	add    %eax,%eax
c0100654:	01 d0                	add    %edx,%eax
c0100656:	c1 e0 02             	shl    $0x2,%eax
c0100659:	89 c2                	mov    %eax,%edx
c010065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010065e:	01 d0                	add    %edx,%eax
c0100660:	8b 10                	mov    (%eax),%edx
c0100662:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100665:	01 c2                	add    %eax,%edx
c0100667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010066d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	89 d0                	mov    %edx,%eax
c0100674:	01 c0                	add    %eax,%eax
c0100676:	01 d0                	add    %edx,%eax
c0100678:	c1 e0 02             	shl    $0x2,%eax
c010067b:	89 c2                	mov    %eax,%edx
c010067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100680:	01 d0                	add    %edx,%eax
c0100682:	8b 50 08             	mov    0x8(%eax),%edx
c0100685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100688:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010068b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068e:	8b 40 10             	mov    0x10(%eax),%eax
c0100691:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100694:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100697:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010069a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010069d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006a0:	eb 15                	jmp    c01006b7 <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01006a8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ba:	8b 40 08             	mov    0x8(%eax),%eax
c01006bd:	83 ec 08             	sub    $0x8,%esp
c01006c0:	6a 3a                	push   $0x3a
c01006c2:	50                   	push   %eax
c01006c3:	e8 f3 78 00 00       	call   c0107fbb <strfind>
c01006c8:	83 c4 10             	add    $0x10,%esp
c01006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01006ce:	8b 4a 08             	mov    0x8(%edx),%ecx
c01006d1:	29 c8                	sub    %ecx,%eax
c01006d3:	89 c2                	mov    %eax,%edx
c01006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006db:	83 ec 0c             	sub    $0xc,%esp
c01006de:	ff 75 08             	push   0x8(%ebp)
c01006e1:	6a 44                	push   $0x44
c01006e3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01006e6:	50                   	push   %eax
c01006e7:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01006ea:	50                   	push   %eax
c01006eb:	ff 75 f4             	push   -0xc(%ebp)
c01006ee:	e8 f2 fc ff ff       	call   c01003e5 <stab_binsearch>
c01006f3:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01006f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01006f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01006fc:	39 c2                	cmp    %eax,%edx
c01006fe:	7f 24                	jg     c0100724 <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
c0100700:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	89 d0                	mov    %edx,%eax
c0100707:	01 c0                	add    %eax,%eax
c0100709:	01 d0                	add    %edx,%eax
c010070b:	c1 e0 02             	shl    $0x2,%eax
c010070e:	89 c2                	mov    %eax,%edx
c0100710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100713:	01 d0                	add    %edx,%eax
c0100715:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100719:	0f b7 d0             	movzwl %ax,%edx
c010071c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010071f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100722:	eb 13                	jmp    c0100737 <debuginfo_eip+0x1fb>
        return -1;
c0100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100729:	e9 0e 01 00 00       	jmp    c010083c <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010072e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100731:	83 e8 01             	sub    $0x1,%eax
c0100734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100737:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010073d:	39 c2                	cmp    %eax,%edx
c010073f:	7c 56                	jl     c0100797 <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
c0100741:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100744:	89 c2                	mov    %eax,%edx
c0100746:	89 d0                	mov    %edx,%eax
c0100748:	01 c0                	add    %eax,%eax
c010074a:	01 d0                	add    %edx,%eax
c010074c:	c1 e0 02             	shl    $0x2,%eax
c010074f:	89 c2                	mov    %eax,%edx
c0100751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100754:	01 d0                	add    %edx,%eax
c0100756:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010075a:	3c 84                	cmp    $0x84,%al
c010075c:	74 39                	je     c0100797 <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010075e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100761:	89 c2                	mov    %eax,%edx
c0100763:	89 d0                	mov    %edx,%eax
c0100765:	01 c0                	add    %eax,%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	c1 e0 02             	shl    $0x2,%eax
c010076c:	89 c2                	mov    %eax,%edx
c010076e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100771:	01 d0                	add    %edx,%eax
c0100773:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100777:	3c 64                	cmp    $0x64,%al
c0100779:	75 b3                	jne    c010072e <debuginfo_eip+0x1f2>
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	8b 40 08             	mov    0x8(%eax),%eax
c0100793:	85 c0                	test   %eax,%eax
c0100795:	74 97                	je     c010072e <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079d:	39 c2                	cmp    %eax,%edx
c010079f:	7c 42                	jl     c01007e3 <debuginfo_eip+0x2a7>
c01007a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a4:	89 c2                	mov    %eax,%edx
c01007a6:	89 d0                	mov    %edx,%eax
c01007a8:	01 c0                	add    %eax,%eax
c01007aa:	01 d0                	add    %edx,%eax
c01007ac:	c1 e0 02             	shl    $0x2,%eax
c01007af:	89 c2                	mov    %eax,%edx
c01007b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b4:	01 d0                	add    %edx,%eax
c01007b6:	8b 10                	mov    (%eax),%edx
c01007b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007bb:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007be:	39 c2                	cmp    %eax,%edx
c01007c0:	73 21                	jae    c01007e3 <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 c2                	mov    %eax,%edx
c01007c7:	89 d0                	mov    %edx,%eax
c01007c9:	01 c0                	add    %eax,%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	c1 e0 02             	shl    $0x2,%eax
c01007d0:	89 c2                	mov    %eax,%edx
c01007d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d5:	01 d0                	add    %edx,%eax
c01007d7:	8b 10                	mov    (%eax),%edx
c01007d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007dc:	01 c2                	add    %eax,%edx
c01007de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e1:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e9:	39 c2                	cmp    %eax,%edx
c01007eb:	7d 4a                	jge    c0100837 <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
c01007ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007f0:	83 c0 01             	add    $0x1,%eax
c01007f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01007f6:	eb 18                	jmp    c0100810 <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fb:	8b 40 14             	mov    0x14(%eax),%eax
c01007fe:	8d 50 01             	lea    0x1(%eax),%edx
c0100801:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100804:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100807:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080a:	83 c0 01             	add    $0x1,%eax
c010080d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100810:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100813:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100816:	39 c2                	cmp    %eax,%edx
c0100818:	7d 1d                	jge    c0100837 <debuginfo_eip+0x2fb>
c010081a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010081d:	89 c2                	mov    %eax,%edx
c010081f:	89 d0                	mov    %edx,%eax
c0100821:	01 c0                	add    %eax,%eax
c0100823:	01 d0                	add    %edx,%eax
c0100825:	c1 e0 02             	shl    $0x2,%eax
c0100828:	89 c2                	mov    %eax,%edx
c010082a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082d:	01 d0                	add    %edx,%eax
c010082f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100833:	3c a0                	cmp    $0xa0,%al
c0100835:	74 c1                	je     c01007f8 <debuginfo_eip+0x2bc>
        }
    }
    return 0;
c0100837:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010083c:	c9                   	leave  
c010083d:	c3                   	ret    

c010083e <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010083e:	55                   	push   %ebp
c010083f:	89 e5                	mov    %esp,%ebp
c0100841:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100844:	83 ec 0c             	sub    $0xc,%esp
c0100847:	68 96 83 10 c0       	push   $0xc0108396
c010084c:	e8 ef fa ff ff       	call   c0100340 <cprintf>
c0100851:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100854:	83 ec 08             	sub    $0x8,%esp
c0100857:	68 36 00 10 c0       	push   $0xc0100036
c010085c:	68 af 83 10 c0       	push   $0xc01083af
c0100861:	e8 da fa ff ff       	call   c0100340 <cprintf>
c0100866:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100869:	83 ec 08             	sub    $0x8,%esp
c010086c:	68 cf 82 10 c0       	push   $0xc01082cf
c0100871:	68 c7 83 10 c0       	push   $0xc01083c7
c0100876:	e8 c5 fa ff ff       	call   c0100340 <cprintf>
c010087b:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010087e:	83 ec 08             	sub    $0x8,%esp
c0100881:	68 00 50 12 c0       	push   $0xc0125000
c0100886:	68 df 83 10 c0       	push   $0xc01083df
c010088b:	e8 b0 fa ff ff       	call   c0100340 <cprintf>
c0100890:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100893:	83 ec 08             	sub    $0x8,%esp
c0100896:	68 14 61 12 c0       	push   $0xc0126114
c010089b:	68 f7 83 10 c0       	push   $0xc01083f7
c01008a0:	e8 9b fa ff ff       	call   c0100340 <cprintf>
c01008a5:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008a8:	b8 14 61 12 c0       	mov    $0xc0126114,%eax
c01008ad:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008b2:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008b7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008bd:	85 c0                	test   %eax,%eax
c01008bf:	0f 48 c2             	cmovs  %edx,%eax
c01008c2:	c1 f8 0a             	sar    $0xa,%eax
c01008c5:	83 ec 08             	sub    $0x8,%esp
c01008c8:	50                   	push   %eax
c01008c9:	68 10 84 10 c0       	push   $0xc0108410
c01008ce:	e8 6d fa ff ff       	call   c0100340 <cprintf>
c01008d3:	83 c4 10             	add    $0x10,%esp
}
c01008d6:	90                   	nop
c01008d7:	c9                   	leave  
c01008d8:	c3                   	ret    

c01008d9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008d9:	55                   	push   %ebp
c01008da:	89 e5                	mov    %esp,%ebp
c01008dc:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008e2:	83 ec 08             	sub    $0x8,%esp
c01008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008e8:	50                   	push   %eax
c01008e9:	ff 75 08             	push   0x8(%ebp)
c01008ec:	e8 4b fc ff ff       	call   c010053c <debuginfo_eip>
c01008f1:	83 c4 10             	add    $0x10,%esp
c01008f4:	85 c0                	test   %eax,%eax
c01008f6:	74 15                	je     c010090d <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01008f8:	83 ec 08             	sub    $0x8,%esp
c01008fb:	ff 75 08             	push   0x8(%ebp)
c01008fe:	68 3a 84 10 c0       	push   $0xc010843a
c0100903:	e8 38 fa ff ff       	call   c0100340 <cprintf>
c0100908:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010090b:	eb 65                	jmp    c0100972 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010090d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100914:	eb 1c                	jmp    c0100932 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100919:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010091c:	01 d0                	add    %edx,%eax
c010091e:	0f b6 00             	movzbl (%eax),%eax
c0100921:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100927:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010092a:	01 ca                	add    %ecx,%edx
c010092c:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010092e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100932:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100935:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100938:	7c dc                	jl     c0100916 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010093a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100943:	01 d0                	add    %edx,%eax
c0100945:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100948:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010094b:	8b 45 08             	mov    0x8(%ebp),%eax
c010094e:	29 d0                	sub    %edx,%eax
c0100950:	89 c1                	mov    %eax,%ecx
c0100952:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100955:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100958:	83 ec 0c             	sub    $0xc,%esp
c010095b:	51                   	push   %ecx
c010095c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100962:	51                   	push   %ecx
c0100963:	52                   	push   %edx
c0100964:	50                   	push   %eax
c0100965:	68 56 84 10 c0       	push   $0xc0108456
c010096a:	e8 d1 f9 ff ff       	call   c0100340 <cprintf>
c010096f:	83 c4 20             	add    $0x20,%esp
}
c0100972:	90                   	nop
c0100973:	c9                   	leave  
c0100974:	c3                   	ret    

c0100975 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100975:	55                   	push   %ebp
c0100976:	89 e5                	mov    %esp,%ebp
c0100978:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c010097b:	8b 45 04             	mov    0x4(%ebp),%eax
c010097e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100981:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100984:	c9                   	leave  
c0100985:	c3                   	ret    

c0100986 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100986:	55                   	push   %ebp
c0100987:	89 e5                	mov    %esp,%ebp
c0100989:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c010098c:	89 e8                	mov    %ebp,%eax
c010098e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100991:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100994:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100997:	e8 d9 ff ff ff       	call   c0100975 <read_eip>
c010099c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c010099f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009a6:	e9 8d 00 00 00       	jmp    c0100a38 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ab:	83 ec 04             	sub    $0x4,%esp
c01009ae:	ff 75 f0             	push   -0x10(%ebp)
c01009b1:	ff 75 f4             	push   -0xc(%ebp)
c01009b4:	68 68 84 10 c0       	push   $0xc0108468
c01009b9:	e8 82 f9 ff ff       	call   c0100340 <cprintf>
c01009be:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c01009c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009c4:	83 c0 08             	add    $0x8,%eax
c01009c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c01009ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009d1:	eb 26                	jmp    c01009f9 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
c01009d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01009e0:	01 d0                	add    %edx,%eax
c01009e2:	8b 00                	mov    (%eax),%eax
c01009e4:	83 ec 08             	sub    $0x8,%esp
c01009e7:	50                   	push   %eax
c01009e8:	68 84 84 10 c0       	push   $0xc0108484
c01009ed:	e8 4e f9 ff ff       	call   c0100340 <cprintf>
c01009f2:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c01009f5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c01009f9:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c01009fd:	7e d4                	jle    c01009d3 <print_stackframe+0x4d>
        }
        cprintf("\n");
c01009ff:	83 ec 0c             	sub    $0xc,%esp
c0100a02:	68 8c 84 10 c0       	push   $0xc010848c
c0100a07:	e8 34 f9 ff ff       	call   c0100340 <cprintf>
c0100a0c:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a12:	83 e8 01             	sub    $0x1,%eax
c0100a15:	83 ec 0c             	sub    $0xc,%esp
c0100a18:	50                   	push   %eax
c0100a19:	e8 bb fe ff ff       	call   c01008d9 <print_debuginfo>
c0100a1e:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a24:	83 c0 04             	add    $0x4,%eax
c0100a27:	8b 00                	mov    (%eax),%eax
c0100a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2f:	8b 00                	mov    (%eax),%eax
c0100a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a34:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a3c:	74 0a                	je     c0100a48 <print_stackframe+0xc2>
c0100a3e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a42:	0f 8e 63 ff ff ff    	jle    c01009ab <print_stackframe+0x25>
    }
}
c0100a48:	90                   	nop
c0100a49:	c9                   	leave  
c0100a4a:	c3                   	ret    

c0100a4b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a4b:	55                   	push   %ebp
c0100a4c:	89 e5                	mov    %esp,%ebp
c0100a4e:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a58:	eb 0c                	jmp    c0100a66 <parse+0x1b>
            *buf ++ = '\0';
c0100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a5d:	8d 50 01             	lea    0x1(%eax),%edx
c0100a60:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a63:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a69:	0f b6 00             	movzbl (%eax),%eax
c0100a6c:	84 c0                	test   %al,%al
c0100a6e:	74 1e                	je     c0100a8e <parse+0x43>
c0100a70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a73:	0f b6 00             	movzbl (%eax),%eax
c0100a76:	0f be c0             	movsbl %al,%eax
c0100a79:	83 ec 08             	sub    $0x8,%esp
c0100a7c:	50                   	push   %eax
c0100a7d:	68 10 85 10 c0       	push   $0xc0108510
c0100a82:	e8 01 75 00 00       	call   c0107f88 <strchr>
c0100a87:	83 c4 10             	add    $0x10,%esp
c0100a8a:	85 c0                	test   %eax,%eax
c0100a8c:	75 cc                	jne    c0100a5a <parse+0xf>
        }
        if (*buf == '\0') {
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	0f b6 00             	movzbl (%eax),%eax
c0100a94:	84 c0                	test   %al,%al
c0100a96:	74 65                	je     c0100afd <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a98:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a9c:	75 12                	jne    c0100ab0 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a9e:	83 ec 08             	sub    $0x8,%esp
c0100aa1:	6a 10                	push   $0x10
c0100aa3:	68 15 85 10 c0       	push   $0xc0108515
c0100aa8:	e8 93 f8 ff ff       	call   c0100340 <cprintf>
c0100aad:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab3:	8d 50 01             	lea    0x1(%eax),%edx
c0100ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ab9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ac3:	01 c2                	add    %eax,%edx
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100aca:	eb 04                	jmp    c0100ad0 <parse+0x85>
            buf ++;
c0100acc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad3:	0f b6 00             	movzbl (%eax),%eax
c0100ad6:	84 c0                	test   %al,%al
c0100ad8:	74 8c                	je     c0100a66 <parse+0x1b>
c0100ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0100add:	0f b6 00             	movzbl (%eax),%eax
c0100ae0:	0f be c0             	movsbl %al,%eax
c0100ae3:	83 ec 08             	sub    $0x8,%esp
c0100ae6:	50                   	push   %eax
c0100ae7:	68 10 85 10 c0       	push   $0xc0108510
c0100aec:	e8 97 74 00 00       	call   c0107f88 <strchr>
c0100af1:	83 c4 10             	add    $0x10,%esp
c0100af4:	85 c0                	test   %eax,%eax
c0100af6:	74 d4                	je     c0100acc <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100af8:	e9 69 ff ff ff       	jmp    c0100a66 <parse+0x1b>
            break;
c0100afd:	90                   	nop
        }
    }
    return argc;
c0100afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b01:	c9                   	leave  
c0100b02:	c3                   	ret    

c0100b03 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b03:	55                   	push   %ebp
c0100b04:	89 e5                	mov    %esp,%ebp
c0100b06:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b09:	83 ec 08             	sub    $0x8,%esp
c0100b0c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b0f:	50                   	push   %eax
c0100b10:	ff 75 08             	push   0x8(%ebp)
c0100b13:	e8 33 ff ff ff       	call   c0100a4b <parse>
c0100b18:	83 c4 10             	add    $0x10,%esp
c0100b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b22:	75 0a                	jne    c0100b2e <runcmd+0x2b>
        return 0;
c0100b24:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b29:	e9 83 00 00 00       	jmp    c0100bb1 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b35:	eb 59                	jmp    c0100b90 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b37:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b3a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b3d:	89 c8                	mov    %ecx,%eax
c0100b3f:	01 c0                	add    %eax,%eax
c0100b41:	01 c8                	add    %ecx,%eax
c0100b43:	c1 e0 02             	shl    $0x2,%eax
c0100b46:	05 00 20 12 c0       	add    $0xc0122000,%eax
c0100b4b:	8b 00                	mov    (%eax),%eax
c0100b4d:	83 ec 08             	sub    $0x8,%esp
c0100b50:	52                   	push   %edx
c0100b51:	50                   	push   %eax
c0100b52:	e8 92 73 00 00       	call   c0107ee9 <strcmp>
c0100b57:	83 c4 10             	add    $0x10,%esp
c0100b5a:	85 c0                	test   %eax,%eax
c0100b5c:	75 2e                	jne    c0100b8c <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b61:	89 d0                	mov    %edx,%eax
c0100b63:	01 c0                	add    %eax,%eax
c0100b65:	01 d0                	add    %edx,%eax
c0100b67:	c1 e0 02             	shl    $0x2,%eax
c0100b6a:	05 08 20 12 c0       	add    $0xc0122008,%eax
c0100b6f:	8b 10                	mov    (%eax),%edx
c0100b71:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b74:	83 c0 04             	add    $0x4,%eax
c0100b77:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100b7a:	83 e9 01             	sub    $0x1,%ecx
c0100b7d:	83 ec 04             	sub    $0x4,%esp
c0100b80:	ff 75 0c             	push   0xc(%ebp)
c0100b83:	50                   	push   %eax
c0100b84:	51                   	push   %ecx
c0100b85:	ff d2                	call   *%edx
c0100b87:	83 c4 10             	add    $0x10,%esp
c0100b8a:	eb 25                	jmp    c0100bb1 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b93:	83 f8 02             	cmp    $0x2,%eax
c0100b96:	76 9f                	jbe    c0100b37 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b98:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b9b:	83 ec 08             	sub    $0x8,%esp
c0100b9e:	50                   	push   %eax
c0100b9f:	68 33 85 10 c0       	push   $0xc0108533
c0100ba4:	e8 97 f7 ff ff       	call   c0100340 <cprintf>
c0100ba9:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100bac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bb1:	c9                   	leave  
c0100bb2:	c3                   	ret    

c0100bb3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bb3:	55                   	push   %ebp
c0100bb4:	89 e5                	mov    %esp,%ebp
c0100bb6:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bb9:	83 ec 0c             	sub    $0xc,%esp
c0100bbc:	68 4c 85 10 c0       	push   $0xc010854c
c0100bc1:	e8 7a f7 ff ff       	call   c0100340 <cprintf>
c0100bc6:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100bc9:	83 ec 0c             	sub    $0xc,%esp
c0100bcc:	68 74 85 10 c0       	push   $0xc0108574
c0100bd1:	e8 6a f7 ff ff       	call   c0100340 <cprintf>
c0100bd6:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bdd:	74 0e                	je     c0100bed <kmonitor+0x3a>
        print_trapframe(tf);
c0100bdf:	83 ec 0c             	sub    $0xc,%esp
c0100be2:	ff 75 08             	push   0x8(%ebp)
c0100be5:	e8 eb 15 00 00       	call   c01021d5 <print_trapframe>
c0100bea:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bed:	83 ec 0c             	sub    $0xc,%esp
c0100bf0:	68 99 85 10 c0       	push   $0xc0108599
c0100bf5:	e8 37 f6 ff ff       	call   c0100231 <readline>
c0100bfa:	83 c4 10             	add    $0x10,%esp
c0100bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c04:	74 e7                	je     c0100bed <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100c06:	83 ec 08             	sub    $0x8,%esp
c0100c09:	ff 75 08             	push   0x8(%ebp)
c0100c0c:	ff 75 f4             	push   -0xc(%ebp)
c0100c0f:	e8 ef fe ff ff       	call   c0100b03 <runcmd>
c0100c14:	83 c4 10             	add    $0x10,%esp
c0100c17:	85 c0                	test   %eax,%eax
c0100c19:	78 02                	js     c0100c1d <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100c1b:	eb d0                	jmp    c0100bed <kmonitor+0x3a>
                break;
c0100c1d:	90                   	nop
            }
        }
    }
}
c0100c1e:	90                   	nop
c0100c1f:	c9                   	leave  
c0100c20:	c3                   	ret    

c0100c21 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c21:	55                   	push   %ebp
c0100c22:	89 e5                	mov    %esp,%ebp
c0100c24:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c2e:	eb 3c                	jmp    c0100c6c <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c33:	89 d0                	mov    %edx,%eax
c0100c35:	01 c0                	add    %eax,%eax
c0100c37:	01 d0                	add    %edx,%eax
c0100c39:	c1 e0 02             	shl    $0x2,%eax
c0100c3c:	05 04 20 12 c0       	add    $0xc0122004,%eax
c0100c41:	8b 10                	mov    (%eax),%edx
c0100c43:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c46:	89 c8                	mov    %ecx,%eax
c0100c48:	01 c0                	add    %eax,%eax
c0100c4a:	01 c8                	add    %ecx,%eax
c0100c4c:	c1 e0 02             	shl    $0x2,%eax
c0100c4f:	05 00 20 12 c0       	add    $0xc0122000,%eax
c0100c54:	8b 00                	mov    (%eax),%eax
c0100c56:	83 ec 04             	sub    $0x4,%esp
c0100c59:	52                   	push   %edx
c0100c5a:	50                   	push   %eax
c0100c5b:	68 9d 85 10 c0       	push   $0xc010859d
c0100c60:	e8 db f6 ff ff       	call   c0100340 <cprintf>
c0100c65:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c6f:	83 f8 02             	cmp    $0x2,%eax
c0100c72:	76 bc                	jbe    c0100c30 <mon_help+0xf>
    }
    return 0;
c0100c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c79:	c9                   	leave  
c0100c7a:	c3                   	ret    

c0100c7b <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c7b:	55                   	push   %ebp
c0100c7c:	89 e5                	mov    %esp,%ebp
c0100c7e:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c81:	e8 b8 fb ff ff       	call   c010083e <print_kerninfo>
    return 0;
c0100c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c8b:	c9                   	leave  
c0100c8c:	c3                   	ret    

c0100c8d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c8d:	55                   	push   %ebp
c0100c8e:	89 e5                	mov    %esp,%ebp
c0100c90:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c93:	e8 ee fc ff ff       	call   c0100986 <print_stackframe>
    return 0;
c0100c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9d:	c9                   	leave  
c0100c9e:	c3                   	ret    

c0100c9f <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c9f:	55                   	push   %ebp
c0100ca0:	89 e5                	mov    %esp,%ebp
c0100ca2:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100ca5:	a1 20 54 12 c0       	mov    0xc0125420,%eax
c0100caa:	85 c0                	test   %eax,%eax
c0100cac:	75 5f                	jne    c0100d0d <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100cae:	c7 05 20 54 12 c0 01 	movl   $0x1,0xc0125420
c0100cb5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cb8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cbe:	83 ec 04             	sub    $0x4,%esp
c0100cc1:	ff 75 0c             	push   0xc(%ebp)
c0100cc4:	ff 75 08             	push   0x8(%ebp)
c0100cc7:	68 a6 85 10 c0       	push   $0xc01085a6
c0100ccc:	e8 6f f6 ff ff       	call   c0100340 <cprintf>
c0100cd1:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd7:	83 ec 08             	sub    $0x8,%esp
c0100cda:	50                   	push   %eax
c0100cdb:	ff 75 10             	push   0x10(%ebp)
c0100cde:	e8 34 f6 ff ff       	call   c0100317 <vcprintf>
c0100ce3:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100ce6:	83 ec 0c             	sub    $0xc,%esp
c0100ce9:	68 c2 85 10 c0       	push   $0xc01085c2
c0100cee:	e8 4d f6 ff ff       	call   c0100340 <cprintf>
c0100cf3:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100cf6:	83 ec 0c             	sub    $0xc,%esp
c0100cf9:	68 c4 85 10 c0       	push   $0xc01085c4
c0100cfe:	e8 3d f6 ff ff       	call   c0100340 <cprintf>
c0100d03:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100d06:	e8 7b fc ff ff       	call   c0100986 <print_stackframe>
c0100d0b:	eb 01                	jmp    c0100d0e <__panic+0x6f>
        goto panic_dead;
c0100d0d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d0e:	e8 91 11 00 00       	call   c0101ea4 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d13:	83 ec 0c             	sub    $0xc,%esp
c0100d16:	6a 00                	push   $0x0
c0100d18:	e8 96 fe ff ff       	call   c0100bb3 <kmonitor>
c0100d1d:	83 c4 10             	add    $0x10,%esp
c0100d20:	eb f1                	jmp    c0100d13 <__panic+0x74>

c0100d22 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d22:	55                   	push   %ebp
c0100d23:	89 e5                	mov    %esp,%ebp
c0100d25:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d28:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d2e:	83 ec 04             	sub    $0x4,%esp
c0100d31:	ff 75 0c             	push   0xc(%ebp)
c0100d34:	ff 75 08             	push   0x8(%ebp)
c0100d37:	68 d6 85 10 c0       	push   $0xc01085d6
c0100d3c:	e8 ff f5 ff ff       	call   c0100340 <cprintf>
c0100d41:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d47:	83 ec 08             	sub    $0x8,%esp
c0100d4a:	50                   	push   %eax
c0100d4b:	ff 75 10             	push   0x10(%ebp)
c0100d4e:	e8 c4 f5 ff ff       	call   c0100317 <vcprintf>
c0100d53:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100d56:	83 ec 0c             	sub    $0xc,%esp
c0100d59:	68 c2 85 10 c0       	push   $0xc01085c2
c0100d5e:	e8 dd f5 ff ff       	call   c0100340 <cprintf>
c0100d63:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100d66:	90                   	nop
c0100d67:	c9                   	leave  
c0100d68:	c3                   	ret    

c0100d69 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d69:	55                   	push   %ebp
c0100d6a:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d6c:	a1 20 54 12 c0       	mov    0xc0125420,%eax
}
c0100d71:	5d                   	pop    %ebp
c0100d72:	c3                   	ret    

c0100d73 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d73:	55                   	push   %ebp
c0100d74:	89 e5                	mov    %esp,%ebp
c0100d76:	83 ec 18             	sub    $0x18,%esp
c0100d79:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d7f:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d83:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d87:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d8b:	ee                   	out    %al,(%dx)
}
c0100d8c:	90                   	nop
c0100d8d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d93:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d97:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d9b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d9f:	ee                   	out    %al,(%dx)
}
c0100da0:	90                   	nop
c0100da1:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100da7:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100daf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db3:	ee                   	out    %al,(%dx)
}
c0100db4:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100db5:	c7 05 24 54 12 c0 00 	movl   $0x0,0xc0125424
c0100dbc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dbf:	83 ec 0c             	sub    $0xc,%esp
c0100dc2:	68 f4 85 10 c0       	push   $0xc01085f4
c0100dc7:	e8 74 f5 ff ff       	call   c0100340 <cprintf>
c0100dcc:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dcf:	83 ec 0c             	sub    $0xc,%esp
c0100dd2:	6a 00                	push   $0x0
c0100dd4:	e8 2e 11 00 00       	call   c0101f07 <pic_enable>
c0100dd9:	83 c4 10             	add    $0x10,%esp
}
c0100ddc:	90                   	nop
c0100ddd:	c9                   	leave  
c0100dde:	c3                   	ret    

c0100ddf <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100ddf:	55                   	push   %ebp
c0100de0:	89 e5                	mov    %esp,%ebp
c0100de2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de5:	9c                   	pushf  
c0100de6:	58                   	pop    %eax
c0100de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100ded:	25 00 02 00 00       	and    $0x200,%eax
c0100df2:	85 c0                	test   %eax,%eax
c0100df4:	74 0c                	je     c0100e02 <__intr_save+0x23>
        intr_disable();
c0100df6:	e8 a9 10 00 00       	call   c0101ea4 <intr_disable>
        return 1;
c0100dfb:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e00:	eb 05                	jmp    c0100e07 <__intr_save+0x28>
    }
    return 0;
c0100e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e07:	c9                   	leave  
c0100e08:	c3                   	ret    

c0100e09 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e09:	55                   	push   %ebp
c0100e0a:	89 e5                	mov    %esp,%ebp
c0100e0c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e13:	74 05                	je     c0100e1a <__intr_restore+0x11>
        intr_enable();
c0100e15:	e8 82 10 00 00       	call   c0101e9c <intr_enable>
    }
}
c0100e1a:	90                   	nop
c0100e1b:	c9                   	leave  
c0100e1c:	c3                   	ret    

c0100e1d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e1d:	55                   	push   %ebp
c0100e1e:	89 e5                	mov    %esp,%ebp
c0100e20:	83 ec 10             	sub    $0x10,%esp
c0100e23:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e29:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e2d:	89 c2                	mov    %eax,%edx
c0100e2f:	ec                   	in     (%dx),%al
c0100e30:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e33:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e39:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3d:	89 c2                	mov    %eax,%edx
c0100e3f:	ec                   	in     (%dx),%al
c0100e40:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e43:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e49:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4d:	89 c2                	mov    %eax,%edx
c0100e4f:	ec                   	in     (%dx),%al
c0100e50:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e53:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e59:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5d:	89 c2                	mov    %eax,%edx
c0100e5f:	ec                   	in     (%dx),%al
c0100e60:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e63:	90                   	nop
c0100e64:	c9                   	leave  
c0100e65:	c3                   	ret    

c0100e66 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e66:	55                   	push   %ebp
c0100e67:	89 e5                	mov    %esp,%ebp
c0100e69:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6c:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e76:	0f b7 00             	movzwl (%eax),%eax
c0100e79:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e80:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e88:	0f b7 00             	movzwl (%eax),%eax
c0100e8b:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e8f:	74 12                	je     c0100ea3 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e91:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e98:	66 c7 05 46 54 12 c0 	movw   $0x3b4,0xc0125446
c0100e9f:	b4 03 
c0100ea1:	eb 13                	jmp    c0100eb6 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eaa:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ead:	66 c7 05 46 54 12 c0 	movw   $0x3d4,0xc0125446
c0100eb4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb6:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c0100ebd:	0f b7 c0             	movzwl %ax,%eax
c0100ec0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ec4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ecc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ed0:	ee                   	out    %al,(%dx)
}
c0100ed1:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100ed2:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c0100ed9:	83 c0 01             	add    $0x1,%eax
c0100edc:	0f b7 c0             	movzwl %ax,%eax
c0100edf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ee7:	89 c2                	mov    %eax,%edx
c0100ee9:	ec                   	in     (%dx),%al
c0100eea:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100eed:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ef1:	0f b6 c0             	movzbl %al,%eax
c0100ef4:	c1 e0 08             	shl    $0x8,%eax
c0100ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efa:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c0100f01:	0f b7 c0             	movzwl %ax,%eax
c0100f04:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f08:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f10:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f14:	ee                   	out    %al,(%dx)
}
c0100f15:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f16:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c0100f1d:	83 c0 01             	add    $0x1,%eax
c0100f20:	0f b7 c0             	movzwl %ax,%eax
c0100f23:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f27:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f2b:	89 c2                	mov    %eax,%edx
c0100f2d:	ec                   	in     (%dx),%al
c0100f2e:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f31:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f35:	0f b6 c0             	movzbl %al,%eax
c0100f38:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3e:	a3 40 54 12 c0       	mov    %eax,0xc0125440
    crt_pos = pos;
c0100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f46:	66 a3 44 54 12 c0    	mov    %ax,0xc0125444
}
c0100f4c:	90                   	nop
c0100f4d:	c9                   	leave  
c0100f4e:	c3                   	ret    

c0100f4f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4f:	55                   	push   %ebp
c0100f50:	89 e5                	mov    %esp,%ebp
c0100f52:	83 ec 38             	sub    $0x38,%esp
c0100f55:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f5b:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f63:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f67:	ee                   	out    %al,(%dx)
}
c0100f68:	90                   	nop
c0100f69:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f6f:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f73:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f77:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
}
c0100f7c:	90                   	nop
c0100f7d:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f83:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f87:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f8b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f8f:	ee                   	out    %al,(%dx)
}
c0100f90:	90                   	nop
c0100f91:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f97:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f9b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f9f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fa3:	ee                   	out    %al,(%dx)
}
c0100fa4:	90                   	nop
c0100fa5:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fab:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100faf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fb3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fb7:	ee                   	out    %al,(%dx)
}
c0100fb8:	90                   	nop
c0100fb9:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fbf:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
}
c0100fcc:	90                   	nop
c0100fcd:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fdb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
}
c0100fe0:	90                   	nop
c0100fe1:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100feb:	89 c2                	mov    %eax,%edx
c0100fed:	ec                   	in     (%dx),%al
c0100fee:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ff1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff5:	3c ff                	cmp    $0xff,%al
c0100ff7:	0f 95 c0             	setne  %al
c0100ffa:	0f b6 c0             	movzbl %al,%eax
c0100ffd:	a3 48 54 12 c0       	mov    %eax,0xc0125448
c0101002:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101008:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010100c:	89 c2                	mov    %eax,%edx
c010100e:	ec                   	in     (%dx),%al
c010100f:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101012:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101018:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010101c:	89 c2                	mov    %eax,%edx
c010101e:	ec                   	in     (%dx),%al
c010101f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101022:	a1 48 54 12 c0       	mov    0xc0125448,%eax
c0101027:	85 c0                	test   %eax,%eax
c0101029:	74 0d                	je     c0101038 <serial_init+0xe9>
        pic_enable(IRQ_COM1);
c010102b:	83 ec 0c             	sub    $0xc,%esp
c010102e:	6a 04                	push   $0x4
c0101030:	e8 d2 0e 00 00       	call   c0101f07 <pic_enable>
c0101035:	83 c4 10             	add    $0x10,%esp
    }
}
c0101038:	90                   	nop
c0101039:	c9                   	leave  
c010103a:	c3                   	ret    

c010103b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103b:	55                   	push   %ebp
c010103c:	89 e5                	mov    %esp,%ebp
c010103e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101048:	eb 09                	jmp    c0101053 <lpt_putc_sub+0x18>
        delay();
c010104a:	e8 ce fd ff ff       	call   c0100e1d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101053:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101059:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105d:	89 c2                	mov    %eax,%edx
c010105f:	ec                   	in     (%dx),%al
c0101060:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101063:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101067:	84 c0                	test   %al,%al
c0101069:	78 09                	js     c0101074 <lpt_putc_sub+0x39>
c010106b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101072:	7e d6                	jle    c010104a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101074:	8b 45 08             	mov    0x8(%ebp),%eax
c0101077:	0f b6 c0             	movzbl %al,%eax
c010107a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101080:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101083:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101087:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010108b:	ee                   	out    %al,(%dx)
}
c010108c:	90                   	nop
c010108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
}
c01010a0:	90                   	nop
c01010a1:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010a7:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010af:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010b3:	ee                   	out    %al,(%dx)
}
c01010b4:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b5:	90                   	nop
c01010b6:	c9                   	leave  
c01010b7:	c3                   	ret    

c01010b8 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b8:	55                   	push   %ebp
c01010b9:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bf:	74 0d                	je     c01010ce <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010c1:	ff 75 08             	push   0x8(%ebp)
c01010c4:	e8 72 ff ff ff       	call   c010103b <lpt_putc_sub>
c01010c9:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010cc:	eb 1e                	jmp    c01010ec <lpt_putc+0x34>
        lpt_putc_sub('\b');
c01010ce:	6a 08                	push   $0x8
c01010d0:	e8 66 ff ff ff       	call   c010103b <lpt_putc_sub>
c01010d5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010d8:	6a 20                	push   $0x20
c01010da:	e8 5c ff ff ff       	call   c010103b <lpt_putc_sub>
c01010df:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010e2:	6a 08                	push   $0x8
c01010e4:	e8 52 ff ff ff       	call   c010103b <lpt_putc_sub>
c01010e9:	83 c4 04             	add    $0x4,%esp
}
c01010ec:	90                   	nop
c01010ed:	c9                   	leave  
c01010ee:	c3                   	ret    

c01010ef <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010ef:	55                   	push   %ebp
c01010f0:	89 e5                	mov    %esp,%ebp
c01010f2:	53                   	push   %ebx
c01010f3:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f9:	b0 00                	mov    $0x0,%al
c01010fb:	85 c0                	test   %eax,%eax
c01010fd:	75 07                	jne    c0101106 <cga_putc+0x17>
        c |= 0x0700;
c01010ff:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101106:	8b 45 08             	mov    0x8(%ebp),%eax
c0101109:	0f b6 c0             	movzbl %al,%eax
c010110c:	83 f8 0d             	cmp    $0xd,%eax
c010110f:	74 6b                	je     c010117c <cga_putc+0x8d>
c0101111:	83 f8 0d             	cmp    $0xd,%eax
c0101114:	0f 8f 9c 00 00 00    	jg     c01011b6 <cga_putc+0xc7>
c010111a:	83 f8 08             	cmp    $0x8,%eax
c010111d:	74 0a                	je     c0101129 <cga_putc+0x3a>
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 48                	je     c010116c <cga_putc+0x7d>
c0101124:	e9 8d 00 00 00       	jmp    c01011b6 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101129:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c0101130:	66 85 c0             	test   %ax,%ax
c0101133:	0f 84 a3 00 00 00    	je     c01011dc <cga_putc+0xed>
            crt_pos --;
c0101139:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c0101140:	83 e8 01             	sub    $0x1,%eax
c0101143:	66 a3 44 54 12 c0    	mov    %ax,0xc0125444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101149:	8b 45 08             	mov    0x8(%ebp),%eax
c010114c:	b0 00                	mov    $0x0,%al
c010114e:	83 c8 20             	or     $0x20,%eax
c0101151:	89 c2                	mov    %eax,%edx
c0101153:	8b 0d 40 54 12 c0    	mov    0xc0125440,%ecx
c0101159:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c0101160:	0f b7 c0             	movzwl %ax,%eax
c0101163:	01 c0                	add    %eax,%eax
c0101165:	01 c8                	add    %ecx,%eax
c0101167:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010116a:	eb 70                	jmp    c01011dc <cga_putc+0xed>
    case '\n':
        crt_pos += CRT_COLS;
c010116c:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c0101173:	83 c0 50             	add    $0x50,%eax
c0101176:	66 a3 44 54 12 c0    	mov    %ax,0xc0125444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117c:	0f b7 1d 44 54 12 c0 	movzwl 0xc0125444,%ebx
c0101183:	0f b7 0d 44 54 12 c0 	movzwl 0xc0125444,%ecx
c010118a:	0f b7 c1             	movzwl %cx,%eax
c010118d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101193:	c1 e8 10             	shr    $0x10,%eax
c0101196:	89 c2                	mov    %eax,%edx
c0101198:	66 c1 ea 06          	shr    $0x6,%dx
c010119c:	89 d0                	mov    %edx,%eax
c010119e:	c1 e0 02             	shl    $0x2,%eax
c01011a1:	01 d0                	add    %edx,%eax
c01011a3:	c1 e0 04             	shl    $0x4,%eax
c01011a6:	29 c1                	sub    %eax,%ecx
c01011a8:	89 ca                	mov    %ecx,%edx
c01011aa:	89 d8                	mov    %ebx,%eax
c01011ac:	29 d0                	sub    %edx,%eax
c01011ae:	66 a3 44 54 12 c0    	mov    %ax,0xc0125444
        break;
c01011b4:	eb 27                	jmp    c01011dd <cga_putc+0xee>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b6:	8b 0d 40 54 12 c0    	mov    0xc0125440,%ecx
c01011bc:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c01011c3:	8d 50 01             	lea    0x1(%eax),%edx
c01011c6:	66 89 15 44 54 12 c0 	mov    %dx,0xc0125444
c01011cd:	0f b7 c0             	movzwl %ax,%eax
c01011d0:	01 c0                	add    %eax,%eax
c01011d2:	01 c8                	add    %ecx,%eax
c01011d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01011d7:	66 89 10             	mov    %dx,(%eax)
        break;
c01011da:	eb 01                	jmp    c01011dd <cga_putc+0xee>
        break;
c01011dc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011dd:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c01011e4:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e8:	76 5a                	jbe    c0101244 <cga_putc+0x155>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ea:	a1 40 54 12 c0       	mov    0xc0125440,%eax
c01011ef:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f5:	a1 40 54 12 c0       	mov    0xc0125440,%eax
c01011fa:	83 ec 04             	sub    $0x4,%esp
c01011fd:	68 00 0f 00 00       	push   $0xf00
c0101202:	52                   	push   %edx
c0101203:	50                   	push   %eax
c0101204:	e8 7c 6f 00 00       	call   c0108185 <memmove>
c0101209:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101213:	eb 16                	jmp    c010122b <cga_putc+0x13c>
            crt_buf[i] = 0x0700 | ' ';
c0101215:	8b 15 40 54 12 c0    	mov    0xc0125440,%edx
c010121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010121e:	01 c0                	add    %eax,%eax
c0101220:	01 d0                	add    %edx,%eax
c0101222:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101227:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101232:	7e e1                	jle    c0101215 <cga_putc+0x126>
        }
        crt_pos -= CRT_COLS;
c0101234:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c010123b:	83 e8 50             	sub    $0x50,%eax
c010123e:	66 a3 44 54 12 c0    	mov    %ax,0xc0125444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101244:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c010124b:	0f b7 c0             	movzwl %ax,%eax
c010124e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101252:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101256:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010125a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010125e:	ee                   	out    %al,(%dx)
}
c010125f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101260:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c0101267:	66 c1 e8 08          	shr    $0x8,%ax
c010126b:	0f b6 c0             	movzbl %al,%eax
c010126e:	0f b7 15 46 54 12 c0 	movzwl 0xc0125446,%edx
c0101275:	83 c2 01             	add    $0x1,%edx
c0101278:	0f b7 d2             	movzwl %dx,%edx
c010127b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010127f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101282:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101286:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010128a:	ee                   	out    %al,(%dx)
}
c010128b:	90                   	nop
    outb(addr_6845, 15);
c010128c:	0f b7 05 46 54 12 c0 	movzwl 0xc0125446,%eax
c0101293:	0f b7 c0             	movzwl %ax,%eax
c0101296:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010129a:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010129e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012a2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a6:	ee                   	out    %al,(%dx)
}
c01012a7:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c01012a8:	0f b7 05 44 54 12 c0 	movzwl 0xc0125444,%eax
c01012af:	0f b6 c0             	movzbl %al,%eax
c01012b2:	0f b7 15 46 54 12 c0 	movzwl 0xc0125446,%edx
c01012b9:	83 c2 01             	add    $0x1,%edx
c01012bc:	0f b7 d2             	movzwl %dx,%edx
c01012bf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012c3:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012c6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012ce:	ee                   	out    %al,(%dx)
}
c01012cf:	90                   	nop
}
c01012d0:	90                   	nop
c01012d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012d4:	c9                   	leave  
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 33 fb ff ff       	call   c0100e1d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	90                   	nop
}
c010132e:	90                   	nop
c010132f:	c9                   	leave  
c0101330:	c3                   	ret    

c0101331 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101331:	55                   	push   %ebp
c0101332:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101334:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101338:	74 0d                	je     c0101347 <serial_putc+0x16>
        serial_putc_sub(c);
c010133a:	ff 75 08             	push   0x8(%ebp)
c010133d:	e8 94 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101342:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101345:	eb 1e                	jmp    c0101365 <serial_putc+0x34>
        serial_putc_sub('\b');
c0101347:	6a 08                	push   $0x8
c0101349:	e8 88 ff ff ff       	call   c01012d6 <serial_putc_sub>
c010134e:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101351:	6a 20                	push   $0x20
c0101353:	e8 7e ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101358:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010135b:	6a 08                	push   $0x8
c010135d:	e8 74 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101362:	83 c4 04             	add    $0x4,%esp
}
c0101365:	90                   	nop
c0101366:	c9                   	leave  
c0101367:	c3                   	ret    

c0101368 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101368:	55                   	push   %ebp
c0101369:	89 e5                	mov    %esp,%ebp
c010136b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136e:	eb 33                	jmp    c01013a3 <cons_intr+0x3b>
        if (c != 0) {
c0101370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101374:	74 2d                	je     c01013a3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101376:	a1 64 56 12 c0       	mov    0xc0125664,%eax
c010137b:	8d 50 01             	lea    0x1(%eax),%edx
c010137e:	89 15 64 56 12 c0    	mov    %edx,0xc0125664
c0101384:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101387:	88 90 60 54 12 c0    	mov    %dl,-0x3fedaba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138d:	a1 64 56 12 c0       	mov    0xc0125664,%eax
c0101392:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101397:	75 0a                	jne    c01013a3 <cons_intr+0x3b>
                cons.wpos = 0;
c0101399:	c7 05 64 56 12 c0 00 	movl   $0x0,0xc0125664
c01013a0:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a6:	ff d0                	call   *%eax
c01013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013af:	75 bf                	jne    c0101370 <cons_intr+0x8>
            }
        }
    }
}
c01013b1:	90                   	nop
c01013b2:	90                   	nop
c01013b3:	c9                   	leave  
c01013b4:	c3                   	ret    

c01013b5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b5:	55                   	push   %ebp
c01013b6:	89 e5                	mov    %esp,%ebp
c01013b8:	83 ec 10             	sub    $0x10,%esp
c01013bb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c5:	89 c2                	mov    %eax,%edx
c01013c7:	ec                   	in     (%dx),%al
c01013c8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cf:	0f b6 c0             	movzbl %al,%eax
c01013d2:	83 e0 01             	and    $0x1,%eax
c01013d5:	85 c0                	test   %eax,%eax
c01013d7:	75 07                	jne    c01013e0 <serial_proc_data+0x2b>
        return -1;
c01013d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013de:	eb 2a                	jmp    c010140a <serial_proc_data+0x55>
c01013e0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ea:	89 c2                	mov    %eax,%edx
c01013ec:	ec                   	in     (%dx),%al
c01013ed:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f4:	0f b6 c0             	movzbl %al,%eax
c01013f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fa:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fe:	75 07                	jne    c0101407 <serial_proc_data+0x52>
        c = '\b';
c0101400:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101407:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140a:	c9                   	leave  
c010140b:	c3                   	ret    

c010140c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140c:	55                   	push   %ebp
c010140d:	89 e5                	mov    %esp,%ebp
c010140f:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101412:	a1 48 54 12 c0       	mov    0xc0125448,%eax
c0101417:	85 c0                	test   %eax,%eax
c0101419:	74 10                	je     c010142b <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c010141b:	83 ec 0c             	sub    $0xc,%esp
c010141e:	68 b5 13 10 c0       	push   $0xc01013b5
c0101423:	e8 40 ff ff ff       	call   c0101368 <cons_intr>
c0101428:	83 c4 10             	add    $0x10,%esp
    }
}
c010142b:	90                   	nop
c010142c:	c9                   	leave  
c010142d:	c3                   	ret    

c010142e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142e:	55                   	push   %ebp
c010142f:	89 e5                	mov    %esp,%ebp
c0101431:	83 ec 28             	sub    $0x28,%esp
c0101434:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143e:	89 c2                	mov    %eax,%edx
c0101440:	ec                   	in     (%dx),%al
c0101441:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101444:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101448:	0f b6 c0             	movzbl %al,%eax
c010144b:	83 e0 01             	and    $0x1,%eax
c010144e:	85 c0                	test   %eax,%eax
c0101450:	75 0a                	jne    c010145c <kbd_proc_data+0x2e>
        return -1;
c0101452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101457:	e9 5e 01 00 00       	jmp    c01015ba <kbd_proc_data+0x18c>
c010145c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101462:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101466:	89 c2                	mov    %eax,%edx
c0101468:	ec                   	in     (%dx),%al
c0101469:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101470:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101473:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101477:	75 17                	jne    c0101490 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101479:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c010147e:	83 c8 40             	or     $0x40,%eax
c0101481:	a3 68 56 12 c0       	mov    %eax,0xc0125668
        return 0;
c0101486:	b8 00 00 00 00       	mov    $0x0,%eax
c010148b:	e9 2a 01 00 00       	jmp    c01015ba <kbd_proc_data+0x18c>
    } else if (data & 0x80) {
c0101490:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101494:	84 c0                	test   %al,%al
c0101496:	79 47                	jns    c01014df <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101498:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c010149d:	83 e0 40             	and    $0x40,%eax
c01014a0:	85 c0                	test   %eax,%eax
c01014a2:	75 09                	jne    c01014ad <kbd_proc_data+0x7f>
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	83 e0 7f             	and    $0x7f,%eax
c01014ab:	eb 04                	jmp    c01014b1 <kbd_proc_data+0x83>
c01014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b1:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b8:	0f b6 80 40 20 12 c0 	movzbl -0x3feddfc0(%eax),%eax
c01014bf:	83 c8 40             	or     $0x40,%eax
c01014c2:	0f b6 c0             	movzbl %al,%eax
c01014c5:	f7 d0                	not    %eax
c01014c7:	89 c2                	mov    %eax,%edx
c01014c9:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c01014ce:	21 d0                	and    %edx,%eax
c01014d0:	a3 68 56 12 c0       	mov    %eax,0xc0125668
        return 0;
c01014d5:	b8 00 00 00 00       	mov    $0x0,%eax
c01014da:	e9 db 00 00 00       	jmp    c01015ba <kbd_proc_data+0x18c>
    } else if (shift & E0ESC) {
c01014df:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c01014e4:	83 e0 40             	and    $0x40,%eax
c01014e7:	85 c0                	test   %eax,%eax
c01014e9:	74 11                	je     c01014fc <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014eb:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ef:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c01014f4:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f7:	a3 68 56 12 c0       	mov    %eax,0xc0125668
    }

    shift |= shiftcode[data];
c01014fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101500:	0f b6 80 40 20 12 c0 	movzbl -0x3feddfc0(%eax),%eax
c0101507:	0f b6 d0             	movzbl %al,%edx
c010150a:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c010150f:	09 d0                	or     %edx,%eax
c0101511:	a3 68 56 12 c0       	mov    %eax,0xc0125668
    shift ^= togglecode[data];
c0101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151a:	0f b6 80 40 21 12 c0 	movzbl -0x3feddec0(%eax),%eax
c0101521:	0f b6 d0             	movzbl %al,%edx
c0101524:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c0101529:	31 d0                	xor    %edx,%eax
c010152b:	a3 68 56 12 c0       	mov    %eax,0xc0125668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101530:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c0101535:	83 e0 03             	and    $0x3,%eax
c0101538:	8b 14 85 40 25 12 c0 	mov    -0x3feddac0(,%eax,4),%edx
c010153f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101543:	01 d0                	add    %edx,%eax
c0101545:	0f b6 00             	movzbl (%eax),%eax
c0101548:	0f b6 c0             	movzbl %al,%eax
c010154b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154e:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c0101553:	83 e0 08             	and    $0x8,%eax
c0101556:	85 c0                	test   %eax,%eax
c0101558:	74 22                	je     c010157c <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010155a:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155e:	7e 0c                	jle    c010156c <kbd_proc_data+0x13e>
c0101560:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101564:	7f 06                	jg     c010156c <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101566:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010156a:	eb 10                	jmp    c010157c <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156c:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101570:	7e 0a                	jle    c010157c <kbd_proc_data+0x14e>
c0101572:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101576:	7f 04                	jg     c010157c <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101578:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157c:	a1 68 56 12 c0       	mov    0xc0125668,%eax
c0101581:	f7 d0                	not    %eax
c0101583:	83 e0 06             	and    $0x6,%eax
c0101586:	85 c0                	test   %eax,%eax
c0101588:	75 2d                	jne    c01015b7 <kbd_proc_data+0x189>
c010158a:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101591:	75 24                	jne    c01015b7 <kbd_proc_data+0x189>
        cprintf("Rebooting!\n");
c0101593:	83 ec 0c             	sub    $0xc,%esp
c0101596:	68 0f 86 10 c0       	push   $0xc010860f
c010159b:	e8 a0 ed ff ff       	call   c0100340 <cprintf>
c01015a0:	83 c4 10             	add    $0x10,%esp
c01015a3:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a9:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ad:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b5:	ee                   	out    %al,(%dx)
}
c01015b6:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c01015c2:	83 ec 0c             	sub    $0xc,%esp
c01015c5:	68 2e 14 10 c0       	push   $0xc010142e
c01015ca:	e8 99 fd ff ff       	call   c0101368 <cons_intr>
c01015cf:	83 c4 10             	add    $0x10,%esp
}
c01015d2:	90                   	nop
c01015d3:	c9                   	leave  
c01015d4:	c3                   	ret    

c01015d5 <kbd_init>:

static void
kbd_init(void) {
c01015d5:	55                   	push   %ebp
c01015d6:	89 e5                	mov    %esp,%ebp
c01015d8:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015db:	e8 dc ff ff ff       	call   c01015bc <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e0:	83 ec 0c             	sub    $0xc,%esp
c01015e3:	6a 01                	push   $0x1
c01015e5:	e8 1d 09 00 00       	call   c0101f07 <pic_enable>
c01015ea:	83 c4 10             	add    $0x10,%esp
}
c01015ed:	90                   	nop
c01015ee:	c9                   	leave  
c01015ef:	c3                   	ret    

c01015f0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f0:	55                   	push   %ebp
c01015f1:	89 e5                	mov    %esp,%ebp
c01015f3:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015f6:	e8 6b f8 ff ff       	call   c0100e66 <cga_init>
    serial_init();
c01015fb:	e8 4f f9 ff ff       	call   c0100f4f <serial_init>
    kbd_init();
c0101600:	e8 d0 ff ff ff       	call   c01015d5 <kbd_init>
    if (!serial_exists) {
c0101605:	a1 48 54 12 c0       	mov    0xc0125448,%eax
c010160a:	85 c0                	test   %eax,%eax
c010160c:	75 10                	jne    c010161e <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c010160e:	83 ec 0c             	sub    $0xc,%esp
c0101611:	68 1b 86 10 c0       	push   $0xc010861b
c0101616:	e8 25 ed ff ff       	call   c0100340 <cprintf>
c010161b:	83 c4 10             	add    $0x10,%esp
    }
}
c010161e:	90                   	nop
c010161f:	c9                   	leave  
c0101620:	c3                   	ret    

c0101621 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101621:	55                   	push   %ebp
c0101622:	89 e5                	mov    %esp,%ebp
c0101624:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101627:	e8 b3 f7 ff ff       	call   c0100ddf <__intr_save>
c010162c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010162f:	83 ec 0c             	sub    $0xc,%esp
c0101632:	ff 75 08             	push   0x8(%ebp)
c0101635:	e8 7e fa ff ff       	call   c01010b8 <lpt_putc>
c010163a:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010163d:	83 ec 0c             	sub    $0xc,%esp
c0101640:	ff 75 08             	push   0x8(%ebp)
c0101643:	e8 a7 fa ff ff       	call   c01010ef <cga_putc>
c0101648:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010164b:	83 ec 0c             	sub    $0xc,%esp
c010164e:	ff 75 08             	push   0x8(%ebp)
c0101651:	e8 db fc ff ff       	call   c0101331 <serial_putc>
c0101656:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101659:	83 ec 0c             	sub    $0xc,%esp
c010165c:	ff 75 f4             	push   -0xc(%ebp)
c010165f:	e8 a5 f7 ff ff       	call   c0100e09 <__intr_restore>
c0101664:	83 c4 10             	add    $0x10,%esp
}
c0101667:	90                   	nop
c0101668:	c9                   	leave  
c0101669:	c3                   	ret    

c010166a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010166a:	55                   	push   %ebp
c010166b:	89 e5                	mov    %esp,%ebp
c010166d:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101677:	e8 63 f7 ff ff       	call   c0100ddf <__intr_save>
c010167c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010167f:	e8 88 fd ff ff       	call   c010140c <serial_intr>
        kbd_intr();
c0101684:	e8 33 ff ff ff       	call   c01015bc <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101689:	8b 15 60 56 12 c0    	mov    0xc0125660,%edx
c010168f:	a1 64 56 12 c0       	mov    0xc0125664,%eax
c0101694:	39 c2                	cmp    %eax,%edx
c0101696:	74 31                	je     c01016c9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101698:	a1 60 56 12 c0       	mov    0xc0125660,%eax
c010169d:	8d 50 01             	lea    0x1(%eax),%edx
c01016a0:	89 15 60 56 12 c0    	mov    %edx,0xc0125660
c01016a6:	0f b6 80 60 54 12 c0 	movzbl -0x3fedaba0(%eax),%eax
c01016ad:	0f b6 c0             	movzbl %al,%eax
c01016b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016b3:	a1 60 56 12 c0       	mov    0xc0125660,%eax
c01016b8:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016bd:	75 0a                	jne    c01016c9 <cons_getc+0x5f>
                cons.rpos = 0;
c01016bf:	c7 05 60 56 12 c0 00 	movl   $0x0,0xc0125660
c01016c6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016c9:	83 ec 0c             	sub    $0xc,%esp
c01016cc:	ff 75 f0             	push   -0x10(%ebp)
c01016cf:	e8 35 f7 ff ff       	call   c0100e09 <__intr_restore>
c01016d4:	83 c4 10             	add    $0x10,%esp
    return c;
c01016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016dc:	55                   	push   %ebp
c01016dd:	89 e5                	mov    %esp,%ebp
c01016df:	83 ec 14             	sub    $0x14,%esp
c01016e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016e9:	90                   	nop
c01016ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ee:	83 c0 07             	add    $0x7,%eax
c01016f1:	0f b7 c0             	movzwl %ax,%eax
c01016f4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016f8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016fc:	89 c2                	mov    %eax,%edx
c01016fe:	ec                   	in     (%dx),%al
c01016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101706:	0f b6 c0             	movzbl %al,%eax
c0101709:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010170c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010170f:	25 80 00 00 00       	and    $0x80,%eax
c0101714:	85 c0                	test   %eax,%eax
c0101716:	75 d2                	jne    c01016ea <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101718:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010171c:	74 11                	je     c010172f <ide_wait_ready+0x53>
c010171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101721:	83 e0 21             	and    $0x21,%eax
c0101724:	85 c0                	test   %eax,%eax
c0101726:	74 07                	je     c010172f <ide_wait_ready+0x53>
        return -1;
c0101728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010172d:	eb 05                	jmp    c0101734 <ide_wait_ready+0x58>
    }
    return 0;
c010172f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101734:	c9                   	leave  
c0101735:	c3                   	ret    

c0101736 <ide_init>:

void
ide_init(void) {
c0101736:	55                   	push   %ebp
c0101737:	89 e5                	mov    %esp,%ebp
c0101739:	57                   	push   %edi
c010173a:	53                   	push   %ebx
c010173b:	81 ec 40 02 00 00    	sub    $0x240,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101741:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101747:	e9 6b 02 00 00       	jmp    c01019b7 <ide_init+0x281>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010174c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101750:	6b c0 38             	imul   $0x38,%eax,%eax
c0101753:	05 80 56 12 c0       	add    $0xc0125680,%eax
c0101758:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010175b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010175f:	66 d1 e8             	shr    %ax
c0101762:	0f b7 c0             	movzwl %ax,%eax
c0101765:	0f b7 04 85 3c 86 10 	movzwl -0x3fef79c4(,%eax,4),%eax
c010176c:	c0 
c010176d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101771:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101775:	6a 00                	push   $0x0
c0101777:	50                   	push   %eax
c0101778:	e8 5f ff ff ff       	call   c01016dc <ide_wait_ready>
c010177d:	83 c4 08             	add    $0x8,%esp

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101780:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101784:	c1 e0 04             	shl    $0x4,%eax
c0101787:	83 e0 10             	and    $0x10,%eax
c010178a:	83 c8 e0             	or     $0xffffffe0,%eax
c010178d:	0f b6 c0             	movzbl %al,%eax
c0101790:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101794:	83 c2 06             	add    $0x6,%edx
c0101797:	0f b7 d2             	movzwl %dx,%edx
c010179a:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c010179e:	88 45 c9             	mov    %al,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017a5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
}
c01017aa:	90                   	nop
        ide_wait_ready(iobase, 0);
c01017ab:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017af:	6a 00                	push   $0x0
c01017b1:	50                   	push   %eax
c01017b2:	e8 25 ff ff ff       	call   c01016dc <ide_wait_ready>
c01017b7:	83 c4 08             	add    $0x8,%esp

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017ba:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017be:	83 c0 07             	add    $0x7,%eax
c01017c1:	0f b7 c0             	movzwl %ax,%eax
c01017c4:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017c8:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017cc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017d0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017d4:	ee                   	out    %al,(%dx)
}
c01017d5:	90                   	nop
        ide_wait_ready(iobase, 0);
c01017d6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017da:	6a 00                	push   $0x0
c01017dc:	50                   	push   %eax
c01017dd:	e8 fa fe ff ff       	call   c01016dc <ide_wait_ready>
c01017e2:	83 c4 08             	add    $0x8,%esp

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017e5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017e9:	83 c0 07             	add    $0x7,%eax
c01017ec:	0f b7 c0             	movzwl %ax,%eax
c01017ef:	66 89 45 d2          	mov    %ax,-0x2e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017f3:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c01017f7:	89 c2                	mov    %eax,%edx
c01017f9:	ec                   	in     (%dx),%al
c01017fa:	88 45 d1             	mov    %al,-0x2f(%ebp)
    return data;
c01017fd:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101801:	84 c0                	test   %al,%al
c0101803:	0f 84 a2 01 00 00    	je     c01019ab <ide_init+0x275>
c0101809:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010180d:	6a 01                	push   $0x1
c010180f:	50                   	push   %eax
c0101810:	e8 c7 fe ff ff       	call   c01016dc <ide_wait_ready>
c0101815:	83 c4 08             	add    $0x8,%esp
c0101818:	85 c0                	test   %eax,%eax
c010181a:	0f 85 8b 01 00 00    	jne    c01019ab <ide_init+0x275>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101820:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101824:	6b c0 38             	imul   $0x38,%eax,%eax
c0101827:	05 80 56 12 c0       	add    $0xc0125680,%eax
c010182c:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101833:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101836:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010183c:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183f:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c0101846:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101849:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010184c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184f:	89 cb                	mov    %ecx,%ebx
c0101851:	89 df                	mov    %ebx,%edi
c0101853:	89 c1                	mov    %eax,%ecx
c0101855:	fc                   	cld    
c0101856:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101858:	89 c8                	mov    %ecx,%eax
c010185a:	89 fb                	mov    %edi,%ebx
c010185c:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185f:	89 45 bc             	mov    %eax,-0x44(%ebp)
}
c0101862:	90                   	nop

        unsigned char *ident = (unsigned char *)buffer;
c0101863:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101875:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101878:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187b:	25 00 00 00 04       	and    $0x4000000,%eax
c0101880:	85 c0                	test   %eax,%eax
c0101882:	74 0e                	je     c0101892 <ide_init+0x15c>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101887:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010188d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101890:	eb 09                	jmp    c010189b <ide_init+0x165>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101895:	8b 40 78             	mov    0x78(%eax),%eax
c0101898:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010189f:	6b c0 38             	imul   $0x38,%eax,%eax
c01018a2:	8d 90 84 56 12 c0    	lea    -0x3feda97c(%eax),%edx
c01018a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018ab:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c01018ad:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b1:	6b c0 38             	imul   $0x38,%eax,%eax
c01018b4:	8d 90 88 56 12 c0    	lea    -0x3feda978(%eax),%edx
c01018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018bd:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018c2:	83 c0 62             	add    $0x62,%eax
c01018c5:	0f b7 00             	movzwl (%eax),%eax
c01018c8:	0f b7 c0             	movzwl %ax,%eax
c01018cb:	25 00 02 00 00       	and    $0x200,%eax
c01018d0:	85 c0                	test   %eax,%eax
c01018d2:	75 16                	jne    c01018ea <ide_init+0x1b4>
c01018d4:	68 44 86 10 c0       	push   $0xc0108644
c01018d9:	68 87 86 10 c0       	push   $0xc0108687
c01018de:	6a 7d                	push   $0x7d
c01018e0:	68 9c 86 10 c0       	push   $0xc010869c
c01018e5:	e8 b5 f3 ff ff       	call   c0100c9f <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c01018ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018ee:	6b c0 38             	imul   $0x38,%eax,%eax
c01018f1:	05 80 56 12 c0       	add    $0xc0125680,%eax
c01018f6:	83 c0 0c             	add    $0xc,%eax
c01018f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01018fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ff:	83 c0 36             	add    $0x36,%eax
c0101902:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101905:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010190c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101913:	eb 34                	jmp    c0101949 <ide_init+0x213>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101915:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101918:	8d 50 01             	lea    0x1(%eax),%edx
c010191b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010191e:	01 d0                	add    %edx,%eax
c0101920:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0101923:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101926:	01 ca                	add    %ecx,%edx
c0101928:	0f b6 00             	movzbl (%eax),%eax
c010192b:	88 02                	mov    %al,(%edx)
c010192d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101930:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101933:	01 d0                	add    %edx,%eax
c0101935:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101938:	8d 4a 01             	lea    0x1(%edx),%ecx
c010193b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010193e:	01 ca                	add    %ecx,%edx
c0101940:	0f b6 00             	movzbl (%eax),%eax
c0101943:	88 02                	mov    %al,(%edx)
        for (i = 0; i < length; i += 2) {
c0101945:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101949:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010194f:	72 c4                	jb     c0101915 <ide_init+0x1df>
        }
        do {
            model[i] = '\0';
c0101951:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101954:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101957:	01 d0                	add    %edx,%eax
c0101959:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101962:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101965:	85 c0                	test   %eax,%eax
c0101967:	74 0f                	je     c0101978 <ide_init+0x242>
c0101969:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010196c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196f:	01 d0                	add    %edx,%eax
c0101971:	0f b6 00             	movzbl (%eax),%eax
c0101974:	3c 20                	cmp    $0x20,%al
c0101976:	74 d9                	je     c0101951 <ide_init+0x21b>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101978:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010197c:	6b c0 38             	imul   $0x38,%eax,%eax
c010197f:	05 80 56 12 c0       	add    $0xc0125680,%eax
c0101984:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101987:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010198b:	6b c0 38             	imul   $0x38,%eax,%eax
c010198e:	05 88 56 12 c0       	add    $0xc0125688,%eax
c0101993:	8b 10                	mov    (%eax),%edx
c0101995:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101999:	51                   	push   %ecx
c010199a:	52                   	push   %edx
c010199b:	50                   	push   %eax
c010199c:	68 ae 86 10 c0       	push   $0xc01086ae
c01019a1:	e8 9a e9 ff ff       	call   c0100340 <cprintf>
c01019a6:	83 c4 10             	add    $0x10,%esp
c01019a9:	eb 01                	jmp    c01019ac <ide_init+0x276>
            continue ;
c01019ab:	90                   	nop
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ac:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b0:	83 c0 01             	add    $0x1,%eax
c01019b3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019b7:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019bc:	0f 86 8a fd ff ff    	jbe    c010174c <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01019c2:	83 ec 0c             	sub    $0xc,%esp
c01019c5:	6a 0e                	push   $0xe
c01019c7:	e8 3b 05 00 00       	call   c0101f07 <pic_enable>
c01019cc:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_IDE2);
c01019cf:	83 ec 0c             	sub    $0xc,%esp
c01019d2:	6a 0f                	push   $0xf
c01019d4:	e8 2e 05 00 00       	call   c0101f07 <pic_enable>
c01019d9:	83 c4 10             	add    $0x10,%esp
}
c01019dc:	90                   	nop
c01019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01019e0:	5b                   	pop    %ebx
c01019e1:	5f                   	pop    %edi
c01019e2:	5d                   	pop    %ebp
c01019e3:	c3                   	ret    

c01019e4 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c01019e4:	55                   	push   %ebp
c01019e5:	89 e5                	mov    %esp,%ebp
c01019e7:	83 ec 04             	sub    $0x4,%esp
c01019ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ed:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c01019f1:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c01019f6:	77 1a                	ja     c0101a12 <ide_device_valid+0x2e>
c01019f8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01019fc:	6b c0 38             	imul   $0x38,%eax,%eax
c01019ff:	05 80 56 12 c0       	add    $0xc0125680,%eax
c0101a04:	0f b6 00             	movzbl (%eax),%eax
c0101a07:	84 c0                	test   %al,%al
c0101a09:	74 07                	je     c0101a12 <ide_device_valid+0x2e>
c0101a0b:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a10:	eb 05                	jmp    c0101a17 <ide_device_valid+0x33>
c0101a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a17:	c9                   	leave  
c0101a18:	c3                   	ret    

c0101a19 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a19:	55                   	push   %ebp
c0101a1a:	89 e5                	mov    %esp,%ebp
c0101a1c:	83 ec 04             	sub    $0x4,%esp
c0101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a22:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a26:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a2a:	50                   	push   %eax
c0101a2b:	e8 b4 ff ff ff       	call   c01019e4 <ide_device_valid>
c0101a30:	83 c4 04             	add    $0x4,%esp
c0101a33:	85 c0                	test   %eax,%eax
c0101a35:	74 10                	je     c0101a47 <ide_device_size+0x2e>
        return ide_devices[ideno].size;
c0101a37:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3b:	6b c0 38             	imul   $0x38,%eax,%eax
c0101a3e:	05 88 56 12 c0       	add    $0xc0125688,%eax
c0101a43:	8b 00                	mov    (%eax),%eax
c0101a45:	eb 05                	jmp    c0101a4c <ide_device_size+0x33>
    }
    return 0;
c0101a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a4c:	c9                   	leave  
c0101a4d:	c3                   	ret    

c0101a4e <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101a4e:	55                   	push   %ebp
c0101a4f:	89 e5                	mov    %esp,%ebp
c0101a51:	57                   	push   %edi
c0101a52:	53                   	push   %ebx
c0101a53:	83 ec 40             	sub    $0x40,%esp
c0101a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a59:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101a5d:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101a64:	77 1a                	ja     c0101a80 <ide_read_secs+0x32>
c0101a66:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101a6b:	77 13                	ja     c0101a80 <ide_read_secs+0x32>
c0101a6d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101a71:	6b c0 38             	imul   $0x38,%eax,%eax
c0101a74:	05 80 56 12 c0       	add    $0xc0125680,%eax
c0101a79:	0f b6 00             	movzbl (%eax),%eax
c0101a7c:	84 c0                	test   %al,%al
c0101a7e:	75 19                	jne    c0101a99 <ide_read_secs+0x4b>
c0101a80:	68 cc 86 10 c0       	push   $0xc01086cc
c0101a85:	68 87 86 10 c0       	push   $0xc0108687
c0101a8a:	68 9f 00 00 00       	push   $0x9f
c0101a8f:	68 9c 86 10 c0       	push   $0xc010869c
c0101a94:	e8 06 f2 ff ff       	call   c0100c9f <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101a99:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101aa0:	77 0f                	ja     c0101ab1 <ide_read_secs+0x63>
c0101aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101aa5:	8b 45 14             	mov    0x14(%ebp),%eax
c0101aa8:	01 d0                	add    %edx,%eax
c0101aaa:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101aaf:	76 19                	jbe    c0101aca <ide_read_secs+0x7c>
c0101ab1:	68 f4 86 10 c0       	push   $0xc01086f4
c0101ab6:	68 87 86 10 c0       	push   $0xc0108687
c0101abb:	68 a0 00 00 00       	push   $0xa0
c0101ac0:	68 9c 86 10 c0       	push   $0xc010869c
c0101ac5:	e8 d5 f1 ff ff       	call   c0100c9f <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101aca:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ace:	66 d1 e8             	shr    %ax
c0101ad1:	0f b7 c0             	movzwl %ax,%eax
c0101ad4:	0f b7 04 85 3c 86 10 	movzwl -0x3fef79c4(,%eax,4),%eax
c0101adb:	c0 
c0101adc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101ae0:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ae4:	66 d1 e8             	shr    %ax
c0101ae7:	0f b7 c0             	movzwl %ax,%eax
c0101aea:	0f b7 04 85 3e 86 10 	movzwl -0x3fef79c2(,%eax,4),%eax
c0101af1:	c0 
c0101af2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101af6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101afa:	83 ec 08             	sub    $0x8,%esp
c0101afd:	6a 00                	push   $0x0
c0101aff:	50                   	push   %eax
c0101b00:	e8 d7 fb ff ff       	call   c01016dc <ide_wait_ready>
c0101b05:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b08:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b0c:	83 c0 02             	add    $0x2,%eax
c0101b0f:	0f b7 c0             	movzwl %ax,%eax
c0101b12:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101b16:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b1a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101b1e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101b22:	ee                   	out    %al,(%dx)
}
c0101b23:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101b24:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b27:	0f b6 c0             	movzbl %al,%eax
c0101b2a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b2e:	83 c2 02             	add    $0x2,%edx
c0101b31:	0f b7 d2             	movzwl %dx,%edx
c0101b34:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101b38:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b3b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101b3f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101b43:	ee                   	out    %al,(%dx)
}
c0101b44:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101b45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b48:	0f b6 c0             	movzbl %al,%eax
c0101b4b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b4f:	83 c2 03             	add    $0x3,%edx
c0101b52:	0f b7 d2             	movzwl %dx,%edx
c0101b55:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101b59:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b5c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101b60:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101b64:	ee                   	out    %al,(%dx)
}
c0101b65:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101b66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b69:	c1 e8 08             	shr    $0x8,%eax
c0101b6c:	0f b6 c0             	movzbl %al,%eax
c0101b6f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b73:	83 c2 04             	add    $0x4,%edx
c0101b76:	0f b7 d2             	movzwl %dx,%edx
c0101b79:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101b7d:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b80:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101b84:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101b88:	ee                   	out    %al,(%dx)
}
c0101b89:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b8d:	c1 e8 10             	shr    $0x10,%eax
c0101b90:	0f b6 c0             	movzbl %al,%eax
c0101b93:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b97:	83 c2 05             	add    $0x5,%edx
c0101b9a:	0f b7 d2             	movzwl %dx,%edx
c0101b9d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101ba1:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ba4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ba8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bac:	ee                   	out    %al,(%dx)
}
c0101bad:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101bae:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bb2:	c1 e0 04             	shl    $0x4,%eax
c0101bb5:	83 e0 10             	and    $0x10,%eax
c0101bb8:	89 c2                	mov    %eax,%edx
c0101bba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbd:	c1 e8 18             	shr    $0x18,%eax
c0101bc0:	83 e0 0f             	and    $0xf,%eax
c0101bc3:	09 d0                	or     %edx,%eax
c0101bc5:	83 c8 e0             	or     $0xffffffe0,%eax
c0101bc8:	0f b6 c0             	movzbl %al,%eax
c0101bcb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcf:	83 c2 06             	add    $0x6,%edx
c0101bd2:	0f b7 d2             	movzwl %dx,%edx
c0101bd5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bd9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bdc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101be0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101be4:	ee                   	out    %al,(%dx)
}
c0101be5:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101be6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101bea:	83 c0 07             	add    $0x7,%eax
c0101bed:	0f b7 c0             	movzwl %ax,%eax
c0101bf0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101bf4:	c6 45 ed 20          	movb   $0x20,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bf8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101bfc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c00:	ee                   	out    %al,(%dx)
}
c0101c01:	90                   	nop

    int ret = 0;
c0101c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c09:	eb 57                	jmp    c0101c62 <ide_read_secs+0x214>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c0b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c0f:	83 ec 08             	sub    $0x8,%esp
c0101c12:	6a 01                	push   $0x1
c0101c14:	50                   	push   %eax
c0101c15:	e8 c2 fa ff ff       	call   c01016dc <ide_wait_ready>
c0101c1a:	83 c4 10             	add    $0x10,%esp
c0101c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c24:	75 44                	jne    c0101c6a <ide_read_secs+0x21c>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c26:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101c2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101c30:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101c33:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101c3a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101c3d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101c40:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101c43:	89 cb                	mov    %ecx,%ebx
c0101c45:	89 df                	mov    %ebx,%edi
c0101c47:	89 c1                	mov    %eax,%ecx
c0101c49:	fc                   	cld    
c0101c4a:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101c4c:	89 c8                	mov    %ecx,%eax
c0101c4e:	89 fb                	mov    %edi,%ebx
c0101c50:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101c53:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101c56:	90                   	nop
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c57:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101c5b:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101c62:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101c66:	75 a3                	jne    c0101c0b <ide_read_secs+0x1bd>
    }

out:
c0101c68:	eb 01                	jmp    c0101c6b <ide_read_secs+0x21d>
            goto out;
c0101c6a:	90                   	nop
    return ret;
c0101c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101c6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101c71:	5b                   	pop    %ebx
c0101c72:	5f                   	pop    %edi
c0101c73:	5d                   	pop    %ebp
c0101c74:	c3                   	ret    

c0101c75 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101c75:	55                   	push   %ebp
c0101c76:	89 e5                	mov    %esp,%ebp
c0101c78:	56                   	push   %esi
c0101c79:	53                   	push   %ebx
c0101c7a:	83 ec 40             	sub    $0x40,%esp
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101c84:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101c8b:	77 1a                	ja     c0101ca7 <ide_write_secs+0x32>
c0101c8d:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101c92:	77 13                	ja     c0101ca7 <ide_write_secs+0x32>
c0101c94:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c98:	6b c0 38             	imul   $0x38,%eax,%eax
c0101c9b:	05 80 56 12 c0       	add    $0xc0125680,%eax
c0101ca0:	0f b6 00             	movzbl (%eax),%eax
c0101ca3:	84 c0                	test   %al,%al
c0101ca5:	75 19                	jne    c0101cc0 <ide_write_secs+0x4b>
c0101ca7:	68 cc 86 10 c0       	push   $0xc01086cc
c0101cac:	68 87 86 10 c0       	push   $0xc0108687
c0101cb1:	68 bc 00 00 00       	push   $0xbc
c0101cb6:	68 9c 86 10 c0       	push   $0xc010869c
c0101cbb:	e8 df ef ff ff       	call   c0100c9f <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101cc0:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101cc7:	77 0f                	ja     c0101cd8 <ide_write_secs+0x63>
c0101cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101ccc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ccf:	01 d0                	add    %edx,%eax
c0101cd1:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101cd6:	76 19                	jbe    c0101cf1 <ide_write_secs+0x7c>
c0101cd8:	68 f4 86 10 c0       	push   $0xc01086f4
c0101cdd:	68 87 86 10 c0       	push   $0xc0108687
c0101ce2:	68 bd 00 00 00       	push   $0xbd
c0101ce7:	68 9c 86 10 c0       	push   $0xc010869c
c0101cec:	e8 ae ef ff ff       	call   c0100c9f <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101cf1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101cf5:	66 d1 e8             	shr    %ax
c0101cf8:	0f b7 c0             	movzwl %ax,%eax
c0101cfb:	0f b7 04 85 3c 86 10 	movzwl -0x3fef79c4(,%eax,4),%eax
c0101d02:	c0 
c0101d03:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d07:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d0b:	66 d1 e8             	shr    %ax
c0101d0e:	0f b7 c0             	movzwl %ax,%eax
c0101d11:	0f b7 04 85 3e 86 10 	movzwl -0x3fef79c2(,%eax,4),%eax
c0101d18:	c0 
c0101d19:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101d1d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d21:	83 ec 08             	sub    $0x8,%esp
c0101d24:	6a 00                	push   $0x0
c0101d26:	50                   	push   %eax
c0101d27:	e8 b0 f9 ff ff       	call   c01016dc <ide_wait_ready>
c0101d2c:	83 c4 10             	add    $0x10,%esp

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101d2f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101d33:	83 c0 02             	add    $0x2,%eax
c0101d36:	0f b7 c0             	movzwl %ax,%eax
c0101d39:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d3d:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d41:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d45:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d49:	ee                   	out    %al,(%dx)
}
c0101d4a:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101d4b:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d4e:	0f b6 c0             	movzbl %al,%eax
c0101d51:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d55:	83 c2 02             	add    $0x2,%edx
c0101d58:	0f b7 d2             	movzwl %dx,%edx
c0101d5b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d5f:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d62:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d66:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d6a:	ee                   	out    %al,(%dx)
}
c0101d6b:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d6f:	0f b6 c0             	movzbl %al,%eax
c0101d72:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d76:	83 c2 03             	add    $0x3,%edx
c0101d79:	0f b7 d2             	movzwl %dx,%edx
c0101d7c:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d80:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d83:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d87:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d8b:	ee                   	out    %al,(%dx)
}
c0101d8c:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d90:	c1 e8 08             	shr    $0x8,%eax
c0101d93:	0f b6 c0             	movzbl %al,%eax
c0101d96:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d9a:	83 c2 04             	add    $0x4,%edx
c0101d9d:	0f b7 d2             	movzwl %dx,%edx
c0101da0:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101da4:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101da7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101dab:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101daf:	ee                   	out    %al,(%dx)
}
c0101db0:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101db1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101db4:	c1 e8 10             	shr    $0x10,%eax
c0101db7:	0f b6 c0             	movzbl %al,%eax
c0101dba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dbe:	83 c2 05             	add    $0x5,%edx
c0101dc1:	0f b7 d2             	movzwl %dx,%edx
c0101dc4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101dc8:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dcb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101dcf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101dd3:	ee                   	out    %al,(%dx)
}
c0101dd4:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101dd5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dd9:	c1 e0 04             	shl    $0x4,%eax
c0101ddc:	83 e0 10             	and    $0x10,%eax
c0101ddf:	89 c2                	mov    %eax,%edx
c0101de1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101de4:	c1 e8 18             	shr    $0x18,%eax
c0101de7:	83 e0 0f             	and    $0xf,%eax
c0101dea:	09 d0                	or     %edx,%eax
c0101dec:	83 c8 e0             	or     $0xffffffe0,%eax
c0101def:	0f b6 c0             	movzbl %al,%eax
c0101df2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101df6:	83 c2 06             	add    $0x6,%edx
c0101df9:	0f b7 d2             	movzwl %dx,%edx
c0101dfc:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101e00:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e03:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e07:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e0b:	ee                   	out    %al,(%dx)
}
c0101e0c:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e0d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e11:	83 c0 07             	add    $0x7,%eax
c0101e14:	0f b7 c0             	movzwl %ax,%eax
c0101e17:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101e1b:	c6 45 ed 30          	movb   $0x30,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e1f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101e23:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101e27:	ee                   	out    %al,(%dx)
}
c0101e28:	90                   	nop

    int ret = 0;
c0101e29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101e30:	eb 57                	jmp    c0101e89 <ide_write_secs+0x214>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101e32:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e36:	83 ec 08             	sub    $0x8,%esp
c0101e39:	6a 01                	push   $0x1
c0101e3b:	50                   	push   %eax
c0101e3c:	e8 9b f8 ff ff       	call   c01016dc <ide_wait_ready>
c0101e41:	83 c4 10             	add    $0x10,%esp
c0101e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101e4b:	75 44                	jne    c0101e91 <ide_write_secs+0x21c>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101e4d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e51:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101e54:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e57:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101e5a:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101e61:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101e64:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101e67:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101e6a:	89 cb                	mov    %ecx,%ebx
c0101e6c:	89 de                	mov    %ebx,%esi
c0101e6e:	89 c1                	mov    %eax,%ecx
c0101e70:	fc                   	cld    
c0101e71:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101e73:	89 c8                	mov    %ecx,%eax
c0101e75:	89 f3                	mov    %esi,%ebx
c0101e77:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101e7a:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101e7d:	90                   	nop
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101e7e:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101e82:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101e89:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101e8d:	75 a3                	jne    c0101e32 <ide_write_secs+0x1bd>
    }

out:
c0101e8f:	eb 01                	jmp    c0101e92 <ide_write_secs+0x21d>
            goto out;
c0101e91:	90                   	nop
    return ret;
c0101e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0101e98:	5b                   	pop    %ebx
c0101e99:	5e                   	pop    %esi
c0101e9a:	5d                   	pop    %ebp
c0101e9b:	c3                   	ret    

c0101e9c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101e9c:	55                   	push   %ebp
c0101e9d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101e9f:	fb                   	sti    
}
c0101ea0:	90                   	nop
    sti();
}
c0101ea1:	90                   	nop
c0101ea2:	5d                   	pop    %ebp
c0101ea3:	c3                   	ret    

c0101ea4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101ea4:	55                   	push   %ebp
c0101ea5:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101ea7:	fa                   	cli    
}
c0101ea8:	90                   	nop
    cli();
}
c0101ea9:	90                   	nop
c0101eaa:	5d                   	pop    %ebp
c0101eab:	c3                   	ret    

c0101eac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101eac:	55                   	push   %ebp
c0101ead:	89 e5                	mov    %esp,%ebp
c0101eaf:	83 ec 14             	sub    $0x14,%esp
c0101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101eb9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101ebd:	66 a3 50 25 12 c0    	mov    %ax,0xc0122550
    if (did_init) {
c0101ec3:	a1 60 57 12 c0       	mov    0xc0125760,%eax
c0101ec8:	85 c0                	test   %eax,%eax
c0101eca:	74 38                	je     c0101f04 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101ecc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101ed0:	0f b6 c0             	movzbl %al,%eax
c0101ed3:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101edc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ee0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ee4:	ee                   	out    %al,(%dx)
}
c0101ee5:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101ee6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101eea:	66 c1 e8 08          	shr    $0x8,%ax
c0101eee:	0f b6 c0             	movzbl %al,%eax
c0101ef1:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101ef7:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101efa:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101efe:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f02:	ee                   	out    %al,(%dx)
}
c0101f03:	90                   	nop
    }
}
c0101f04:	90                   	nop
c0101f05:	c9                   	leave  
c0101f06:	c3                   	ret    

c0101f07 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f07:	55                   	push   %ebp
c0101f08:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0d:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f12:	89 c1                	mov    %eax,%ecx
c0101f14:	d3 e2                	shl    %cl,%edx
c0101f16:	89 d0                	mov    %edx,%eax
c0101f18:	f7 d0                	not    %eax
c0101f1a:	89 c2                	mov    %eax,%edx
c0101f1c:	0f b7 05 50 25 12 c0 	movzwl 0xc0122550,%eax
c0101f23:	21 d0                	and    %edx,%eax
c0101f25:	0f b7 c0             	movzwl %ax,%eax
c0101f28:	50                   	push   %eax
c0101f29:	e8 7e ff ff ff       	call   c0101eac <pic_setmask>
c0101f2e:	83 c4 04             	add    $0x4,%esp
}
c0101f31:	90                   	nop
c0101f32:	c9                   	leave  
c0101f33:	c3                   	ret    

c0101f34 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101f34:	55                   	push   %ebp
c0101f35:	89 e5                	mov    %esp,%ebp
c0101f37:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c0101f3a:	c7 05 60 57 12 c0 01 	movl   $0x1,0xc0125760
c0101f41:	00 00 00 
c0101f44:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101f4a:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f4e:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101f52:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101f56:	ee                   	out    %al,(%dx)
}
c0101f57:	90                   	nop
c0101f58:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101f5e:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f62:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101f66:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101f6a:	ee                   	out    %al,(%dx)
}
c0101f6b:	90                   	nop
c0101f6c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101f72:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f76:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101f7a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101f7e:	ee                   	out    %al,(%dx)
}
c0101f7f:	90                   	nop
c0101f80:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101f86:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f8a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101f8e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101f92:	ee                   	out    %al,(%dx)
}
c0101f93:	90                   	nop
c0101f94:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101f9a:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f9e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101fa2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101fa6:	ee                   	out    %al,(%dx)
}
c0101fa7:	90                   	nop
c0101fa8:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101fae:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fb2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101fb6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101fba:	ee                   	out    %al,(%dx)
}
c0101fbb:	90                   	nop
c0101fbc:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101fc2:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101fce:	ee                   	out    %al,(%dx)
}
c0101fcf:	90                   	nop
c0101fd0:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101fd6:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fda:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101fde:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101fe2:	ee                   	out    %al,(%dx)
}
c0101fe3:	90                   	nop
c0101fe4:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101fea:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fee:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ff2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
}
c0101ff7:	90                   	nop
c0101ff8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101ffe:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102002:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102006:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010200a:	ee                   	out    %al,(%dx)
}
c010200b:	90                   	nop
c010200c:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0102012:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102016:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010201a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201e:	ee                   	out    %al,(%dx)
}
c010201f:	90                   	nop
c0102020:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102026:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010202a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010202e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102032:	ee                   	out    %al,(%dx)
}
c0102033:	90                   	nop
c0102034:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010203a:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010203e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102042:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102046:	ee                   	out    %al,(%dx)
}
c0102047:	90                   	nop
c0102048:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010204e:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102052:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102056:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010205a:	ee                   	out    %al,(%dx)
}
c010205b:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010205c:	0f b7 05 50 25 12 c0 	movzwl 0xc0122550,%eax
c0102063:	66 83 f8 ff          	cmp    $0xffff,%ax
c0102067:	74 13                	je     c010207c <pic_init+0x148>
        pic_setmask(irq_mask);
c0102069:	0f b7 05 50 25 12 c0 	movzwl 0xc0122550,%eax
c0102070:	0f b7 c0             	movzwl %ax,%eax
c0102073:	50                   	push   %eax
c0102074:	e8 33 fe ff ff       	call   c0101eac <pic_setmask>
c0102079:	83 c4 04             	add    $0x4,%esp
    }
}
c010207c:	90                   	nop
c010207d:	c9                   	leave  
c010207e:	c3                   	ret    

c010207f <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010207f:	55                   	push   %ebp
c0102080:	89 e5                	mov    %esp,%ebp
c0102082:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102085:	83 ec 08             	sub    $0x8,%esp
c0102088:	6a 64                	push   $0x64
c010208a:	68 40 87 10 c0       	push   $0xc0108740
c010208f:	e8 ac e2 ff ff       	call   c0100340 <cprintf>
c0102094:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102097:	90                   	nop
c0102098:	c9                   	leave  
c0102099:	c3                   	ret    

c010209a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010209a:	55                   	push   %ebp
c010209b:	89 e5                	mov    %esp,%ebp
c010209d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01020a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01020a7:	e9 c3 00 00 00       	jmp    c010216f <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01020ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020af:	8b 04 85 e0 25 12 c0 	mov    -0x3fedda20(,%eax,4),%eax
c01020b6:	89 c2                	mov    %eax,%edx
c01020b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020bb:	66 89 14 c5 80 57 12 	mov    %dx,-0x3feda880(,%eax,8)
c01020c2:	c0 
c01020c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020c6:	66 c7 04 c5 82 57 12 	movw   $0x8,-0x3feda87e(,%eax,8)
c01020cd:	c0 08 00 
c01020d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020d3:	0f b6 14 c5 84 57 12 	movzbl -0x3feda87c(,%eax,8),%edx
c01020da:	c0 
c01020db:	83 e2 e0             	and    $0xffffffe0,%edx
c01020de:	88 14 c5 84 57 12 c0 	mov    %dl,-0x3feda87c(,%eax,8)
c01020e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020e8:	0f b6 14 c5 84 57 12 	movzbl -0x3feda87c(,%eax,8),%edx
c01020ef:	c0 
c01020f0:	83 e2 1f             	and    $0x1f,%edx
c01020f3:	88 14 c5 84 57 12 c0 	mov    %dl,-0x3feda87c(,%eax,8)
c01020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020fd:	0f b6 14 c5 85 57 12 	movzbl -0x3feda87b(,%eax,8),%edx
c0102104:	c0 
c0102105:	83 e2 f0             	and    $0xfffffff0,%edx
c0102108:	83 ca 0e             	or     $0xe,%edx
c010210b:	88 14 c5 85 57 12 c0 	mov    %dl,-0x3feda87b(,%eax,8)
c0102112:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102115:	0f b6 14 c5 85 57 12 	movzbl -0x3feda87b(,%eax,8),%edx
c010211c:	c0 
c010211d:	83 e2 ef             	and    $0xffffffef,%edx
c0102120:	88 14 c5 85 57 12 c0 	mov    %dl,-0x3feda87b(,%eax,8)
c0102127:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212a:	0f b6 14 c5 85 57 12 	movzbl -0x3feda87b(,%eax,8),%edx
c0102131:	c0 
c0102132:	83 e2 9f             	and    $0xffffff9f,%edx
c0102135:	88 14 c5 85 57 12 c0 	mov    %dl,-0x3feda87b(,%eax,8)
c010213c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213f:	0f b6 14 c5 85 57 12 	movzbl -0x3feda87b(,%eax,8),%edx
c0102146:	c0 
c0102147:	83 ca 80             	or     $0xffffff80,%edx
c010214a:	88 14 c5 85 57 12 c0 	mov    %dl,-0x3feda87b(,%eax,8)
c0102151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102154:	8b 04 85 e0 25 12 c0 	mov    -0x3fedda20(,%eax,4),%eax
c010215b:	c1 e8 10             	shr    $0x10,%eax
c010215e:	89 c2                	mov    %eax,%edx
c0102160:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102163:	66 89 14 c5 86 57 12 	mov    %dx,-0x3feda87a(,%eax,8)
c010216a:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010216b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102172:	3d ff 00 00 00       	cmp    $0xff,%eax
c0102177:	0f 86 2f ff ff ff    	jbe    c01020ac <idt_init+0x12>
c010217d:	c7 45 f8 60 25 12 c0 	movl   $0xc0122560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102184:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102187:	0f 01 18             	lidtl  (%eax)
}
c010218a:	90                   	nop
    }
    lidt(&idt_pd);
}
c010218b:	90                   	nop
c010218c:	c9                   	leave  
c010218d:	c3                   	ret    

c010218e <trapname>:

static const char *
trapname(int trapno) {
c010218e:	55                   	push   %ebp
c010218f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102191:	8b 45 08             	mov    0x8(%ebp),%eax
c0102194:	83 f8 13             	cmp    $0x13,%eax
c0102197:	77 0c                	ja     c01021a5 <trapname+0x17>
        return excnames[trapno];
c0102199:	8b 45 08             	mov    0x8(%ebp),%eax
c010219c:	8b 04 85 a0 8b 10 c0 	mov    -0x3fef7460(,%eax,4),%eax
c01021a3:	eb 18                	jmp    c01021bd <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01021a5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01021a9:	7e 0d                	jle    c01021b8 <trapname+0x2a>
c01021ab:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01021af:	7f 07                	jg     c01021b8 <trapname+0x2a>
        return "Hardware Interrupt";
c01021b1:	b8 4a 87 10 c0       	mov    $0xc010874a,%eax
c01021b6:	eb 05                	jmp    c01021bd <trapname+0x2f>
    }
    return "(unknown trap)";
c01021b8:	b8 5d 87 10 c0       	mov    $0xc010875d,%eax
}
c01021bd:	5d                   	pop    %ebp
c01021be:	c3                   	ret    

c01021bf <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01021bf:	55                   	push   %ebp
c01021c0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01021c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021c5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01021c9:	66 83 f8 08          	cmp    $0x8,%ax
c01021cd:	0f 94 c0             	sete   %al
c01021d0:	0f b6 c0             	movzbl %al,%eax
}
c01021d3:	5d                   	pop    %ebp
c01021d4:	c3                   	ret    

c01021d5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01021d5:	55                   	push   %ebp
c01021d6:	89 e5                	mov    %esp,%ebp
c01021d8:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c01021db:	83 ec 08             	sub    $0x8,%esp
c01021de:	ff 75 08             	push   0x8(%ebp)
c01021e1:	68 9e 87 10 c0       	push   $0xc010879e
c01021e6:	e8 55 e1 ff ff       	call   c0100340 <cprintf>
c01021eb:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c01021ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f1:	83 ec 0c             	sub    $0xc,%esp
c01021f4:	50                   	push   %eax
c01021f5:	e8 b4 01 00 00       	call   c01023ae <print_regs>
c01021fa:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01021fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102200:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102204:	0f b7 c0             	movzwl %ax,%eax
c0102207:	83 ec 08             	sub    $0x8,%esp
c010220a:	50                   	push   %eax
c010220b:	68 af 87 10 c0       	push   $0xc01087af
c0102210:	e8 2b e1 ff ff       	call   c0100340 <cprintf>
c0102215:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102218:	8b 45 08             	mov    0x8(%ebp),%eax
c010221b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010221f:	0f b7 c0             	movzwl %ax,%eax
c0102222:	83 ec 08             	sub    $0x8,%esp
c0102225:	50                   	push   %eax
c0102226:	68 c2 87 10 c0       	push   $0xc01087c2
c010222b:	e8 10 e1 ff ff       	call   c0100340 <cprintf>
c0102230:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102233:	8b 45 08             	mov    0x8(%ebp),%eax
c0102236:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010223a:	0f b7 c0             	movzwl %ax,%eax
c010223d:	83 ec 08             	sub    $0x8,%esp
c0102240:	50                   	push   %eax
c0102241:	68 d5 87 10 c0       	push   $0xc01087d5
c0102246:	e8 f5 e0 ff ff       	call   c0100340 <cprintf>
c010224b:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010224e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102251:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102255:	0f b7 c0             	movzwl %ax,%eax
c0102258:	83 ec 08             	sub    $0x8,%esp
c010225b:	50                   	push   %eax
c010225c:	68 e8 87 10 c0       	push   $0xc01087e8
c0102261:	e8 da e0 ff ff       	call   c0100340 <cprintf>
c0102266:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102269:	8b 45 08             	mov    0x8(%ebp),%eax
c010226c:	8b 40 30             	mov    0x30(%eax),%eax
c010226f:	83 ec 0c             	sub    $0xc,%esp
c0102272:	50                   	push   %eax
c0102273:	e8 16 ff ff ff       	call   c010218e <trapname>
c0102278:	83 c4 10             	add    $0x10,%esp
c010227b:	8b 55 08             	mov    0x8(%ebp),%edx
c010227e:	8b 52 30             	mov    0x30(%edx),%edx
c0102281:	83 ec 04             	sub    $0x4,%esp
c0102284:	50                   	push   %eax
c0102285:	52                   	push   %edx
c0102286:	68 fb 87 10 c0       	push   $0xc01087fb
c010228b:	e8 b0 e0 ff ff       	call   c0100340 <cprintf>
c0102290:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102293:	8b 45 08             	mov    0x8(%ebp),%eax
c0102296:	8b 40 34             	mov    0x34(%eax),%eax
c0102299:	83 ec 08             	sub    $0x8,%esp
c010229c:	50                   	push   %eax
c010229d:	68 0d 88 10 c0       	push   $0xc010880d
c01022a2:	e8 99 e0 ff ff       	call   c0100340 <cprintf>
c01022a7:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01022aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ad:	8b 40 38             	mov    0x38(%eax),%eax
c01022b0:	83 ec 08             	sub    $0x8,%esp
c01022b3:	50                   	push   %eax
c01022b4:	68 1c 88 10 c0       	push   $0xc010881c
c01022b9:	e8 82 e0 ff ff       	call   c0100340 <cprintf>
c01022be:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01022c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022c8:	0f b7 c0             	movzwl %ax,%eax
c01022cb:	83 ec 08             	sub    $0x8,%esp
c01022ce:	50                   	push   %eax
c01022cf:	68 2b 88 10 c0       	push   $0xc010882b
c01022d4:	e8 67 e0 ff ff       	call   c0100340 <cprintf>
c01022d9:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01022dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01022df:	8b 40 40             	mov    0x40(%eax),%eax
c01022e2:	83 ec 08             	sub    $0x8,%esp
c01022e5:	50                   	push   %eax
c01022e6:	68 3e 88 10 c0       	push   $0xc010883e
c01022eb:	e8 50 e0 ff ff       	call   c0100340 <cprintf>
c01022f0:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01022f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01022fa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102301:	eb 3f                	jmp    c0102342 <print_trapframe+0x16d>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102303:	8b 45 08             	mov    0x8(%ebp),%eax
c0102306:	8b 50 40             	mov    0x40(%eax),%edx
c0102309:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010230c:	21 d0                	and    %edx,%eax
c010230e:	85 c0                	test   %eax,%eax
c0102310:	74 29                	je     c010233b <print_trapframe+0x166>
c0102312:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102315:	8b 04 85 80 25 12 c0 	mov    -0x3fedda80(,%eax,4),%eax
c010231c:	85 c0                	test   %eax,%eax
c010231e:	74 1b                	je     c010233b <print_trapframe+0x166>
            cprintf("%s,", IA32flags[i]);
c0102320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102323:	8b 04 85 80 25 12 c0 	mov    -0x3fedda80(,%eax,4),%eax
c010232a:	83 ec 08             	sub    $0x8,%esp
c010232d:	50                   	push   %eax
c010232e:	68 4d 88 10 c0       	push   $0xc010884d
c0102333:	e8 08 e0 ff ff       	call   c0100340 <cprintf>
c0102338:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010233b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010233f:	d1 65 f0             	shll   -0x10(%ebp)
c0102342:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102345:	83 f8 17             	cmp    $0x17,%eax
c0102348:	76 b9                	jbe    c0102303 <print_trapframe+0x12e>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010234a:	8b 45 08             	mov    0x8(%ebp),%eax
c010234d:	8b 40 40             	mov    0x40(%eax),%eax
c0102350:	c1 e8 0c             	shr    $0xc,%eax
c0102353:	83 e0 03             	and    $0x3,%eax
c0102356:	83 ec 08             	sub    $0x8,%esp
c0102359:	50                   	push   %eax
c010235a:	68 51 88 10 c0       	push   $0xc0108851
c010235f:	e8 dc df ff ff       	call   c0100340 <cprintf>
c0102364:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0102367:	83 ec 0c             	sub    $0xc,%esp
c010236a:	ff 75 08             	push   0x8(%ebp)
c010236d:	e8 4d fe ff ff       	call   c01021bf <trap_in_kernel>
c0102372:	83 c4 10             	add    $0x10,%esp
c0102375:	85 c0                	test   %eax,%eax
c0102377:	75 32                	jne    c01023ab <print_trapframe+0x1d6>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102379:	8b 45 08             	mov    0x8(%ebp),%eax
c010237c:	8b 40 44             	mov    0x44(%eax),%eax
c010237f:	83 ec 08             	sub    $0x8,%esp
c0102382:	50                   	push   %eax
c0102383:	68 5a 88 10 c0       	push   $0xc010885a
c0102388:	e8 b3 df ff ff       	call   c0100340 <cprintf>
c010238d:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102390:	8b 45 08             	mov    0x8(%ebp),%eax
c0102393:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102397:	0f b7 c0             	movzwl %ax,%eax
c010239a:	83 ec 08             	sub    $0x8,%esp
c010239d:	50                   	push   %eax
c010239e:	68 69 88 10 c0       	push   $0xc0108869
c01023a3:	e8 98 df ff ff       	call   c0100340 <cprintf>
c01023a8:	83 c4 10             	add    $0x10,%esp
    }
}
c01023ab:	90                   	nop
c01023ac:	c9                   	leave  
c01023ad:	c3                   	ret    

c01023ae <print_regs>:

void
print_regs(struct pushregs *regs) {
c01023ae:	55                   	push   %ebp
c01023af:	89 e5                	mov    %esp,%ebp
c01023b1:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01023b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b7:	8b 00                	mov    (%eax),%eax
c01023b9:	83 ec 08             	sub    $0x8,%esp
c01023bc:	50                   	push   %eax
c01023bd:	68 7c 88 10 c0       	push   $0xc010887c
c01023c2:	e8 79 df ff ff       	call   c0100340 <cprintf>
c01023c7:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01023ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cd:	8b 40 04             	mov    0x4(%eax),%eax
c01023d0:	83 ec 08             	sub    $0x8,%esp
c01023d3:	50                   	push   %eax
c01023d4:	68 8b 88 10 c0       	push   $0xc010888b
c01023d9:	e8 62 df ff ff       	call   c0100340 <cprintf>
c01023de:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01023e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e4:	8b 40 08             	mov    0x8(%eax),%eax
c01023e7:	83 ec 08             	sub    $0x8,%esp
c01023ea:	50                   	push   %eax
c01023eb:	68 9a 88 10 c0       	push   $0xc010889a
c01023f0:	e8 4b df ff ff       	call   c0100340 <cprintf>
c01023f5:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01023f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fb:	8b 40 0c             	mov    0xc(%eax),%eax
c01023fe:	83 ec 08             	sub    $0x8,%esp
c0102401:	50                   	push   %eax
c0102402:	68 a9 88 10 c0       	push   $0xc01088a9
c0102407:	e8 34 df ff ff       	call   c0100340 <cprintf>
c010240c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	8b 40 10             	mov    0x10(%eax),%eax
c0102415:	83 ec 08             	sub    $0x8,%esp
c0102418:	50                   	push   %eax
c0102419:	68 b8 88 10 c0       	push   $0xc01088b8
c010241e:	e8 1d df ff ff       	call   c0100340 <cprintf>
c0102423:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102426:	8b 45 08             	mov    0x8(%ebp),%eax
c0102429:	8b 40 14             	mov    0x14(%eax),%eax
c010242c:	83 ec 08             	sub    $0x8,%esp
c010242f:	50                   	push   %eax
c0102430:	68 c7 88 10 c0       	push   $0xc01088c7
c0102435:	e8 06 df ff ff       	call   c0100340 <cprintf>
c010243a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010243d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102440:	8b 40 18             	mov    0x18(%eax),%eax
c0102443:	83 ec 08             	sub    $0x8,%esp
c0102446:	50                   	push   %eax
c0102447:	68 d6 88 10 c0       	push   $0xc01088d6
c010244c:	e8 ef de ff ff       	call   c0100340 <cprintf>
c0102451:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102454:	8b 45 08             	mov    0x8(%ebp),%eax
c0102457:	8b 40 1c             	mov    0x1c(%eax),%eax
c010245a:	83 ec 08             	sub    $0x8,%esp
c010245d:	50                   	push   %eax
c010245e:	68 e5 88 10 c0       	push   $0xc01088e5
c0102463:	e8 d8 de ff ff       	call   c0100340 <cprintf>
c0102468:	83 c4 10             	add    $0x10,%esp
}
c010246b:	90                   	nop
c010246c:	c9                   	leave  
c010246d:	c3                   	ret    

c010246e <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010246e:	55                   	push   %ebp
c010246f:	89 e5                	mov    %esp,%ebp
c0102471:	53                   	push   %ebx
c0102472:	83 ec 14             	sub    $0x14,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102475:	8b 45 08             	mov    0x8(%ebp),%eax
c0102478:	8b 40 34             	mov    0x34(%eax),%eax
c010247b:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010247e:	85 c0                	test   %eax,%eax
c0102480:	74 07                	je     c0102489 <print_pgfault+0x1b>
c0102482:	bb f4 88 10 c0       	mov    $0xc01088f4,%ebx
c0102487:	eb 05                	jmp    c010248e <print_pgfault+0x20>
c0102489:	bb 05 89 10 c0       	mov    $0xc0108905,%ebx
            (tf->tf_err & 2) ? 'W' : 'R',
c010248e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102491:	8b 40 34             	mov    0x34(%eax),%eax
c0102494:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102497:	85 c0                	test   %eax,%eax
c0102499:	74 07                	je     c01024a2 <print_pgfault+0x34>
c010249b:	b9 57 00 00 00       	mov    $0x57,%ecx
c01024a0:	eb 05                	jmp    c01024a7 <print_pgfault+0x39>
c01024a2:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01024a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024aa:	8b 40 34             	mov    0x34(%eax),%eax
c01024ad:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024b0:	85 c0                	test   %eax,%eax
c01024b2:	74 07                	je     c01024bb <print_pgfault+0x4d>
c01024b4:	ba 55 00 00 00       	mov    $0x55,%edx
c01024b9:	eb 05                	jmp    c01024c0 <print_pgfault+0x52>
c01024bb:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01024c0:	0f 20 d0             	mov    %cr2,%eax
c01024c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024c9:	83 ec 0c             	sub    $0xc,%esp
c01024cc:	53                   	push   %ebx
c01024cd:	51                   	push   %ecx
c01024ce:	52                   	push   %edx
c01024cf:	50                   	push   %eax
c01024d0:	68 14 89 10 c0       	push   $0xc0108914
c01024d5:	e8 66 de ff ff       	call   c0100340 <cprintf>
c01024da:	83 c4 20             	add    $0x20,%esp
}
c01024dd:	90                   	nop
c01024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01024e1:	c9                   	leave  
c01024e2:	c3                   	ret    

c01024e3 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01024e3:	55                   	push   %ebp
c01024e4:	89 e5                	mov    %esp,%ebp
c01024e6:	83 ec 18             	sub    $0x18,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01024e9:	83 ec 0c             	sub    $0xc,%esp
c01024ec:	ff 75 08             	push   0x8(%ebp)
c01024ef:	e8 7a ff ff ff       	call   c010246e <print_pgfault>
c01024f4:	83 c4 10             	add    $0x10,%esp
    if (check_mm_struct != NULL) {
c01024f7:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c01024fc:	85 c0                	test   %eax,%eax
c01024fe:	74 24                	je     c0102524 <pgfault_handler+0x41>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102500:	0f 20 d0             	mov    %cr2,%eax
c0102503:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102506:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102509:	8b 45 08             	mov    0x8(%ebp),%eax
c010250c:	8b 50 34             	mov    0x34(%eax),%edx
c010250f:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c0102514:	83 ec 04             	sub    $0x4,%esp
c0102517:	51                   	push   %ecx
c0102518:	52                   	push   %edx
c0102519:	50                   	push   %eax
c010251a:	e8 b9 4e 00 00       	call   c01073d8 <do_pgfault>
c010251f:	83 c4 10             	add    $0x10,%esp
c0102522:	eb 17                	jmp    c010253b <pgfault_handler+0x58>
    }
    panic("unhandled page fault.\n");
c0102524:	83 ec 04             	sub    $0x4,%esp
c0102527:	68 37 89 10 c0       	push   $0xc0108937
c010252c:	68 a5 00 00 00       	push   $0xa5
c0102531:	68 4e 89 10 c0       	push   $0xc010894e
c0102536:	e8 64 e7 ff ff       	call   c0100c9f <__panic>
}
c010253b:	c9                   	leave  
c010253c:	c3                   	ret    

c010253d <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010253d:	55                   	push   %ebp
c010253e:	89 e5                	mov    %esp,%ebp
c0102540:	83 ec 18             	sub    $0x18,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102543:	8b 45 08             	mov    0x8(%ebp),%eax
c0102546:	8b 40 30             	mov    0x30(%eax),%eax
c0102549:	83 f8 2f             	cmp    $0x2f,%eax
c010254c:	77 1e                	ja     c010256c <trap_dispatch+0x2f>
c010254e:	83 f8 0e             	cmp    $0xe,%eax
c0102551:	0f 82 ff 00 00 00    	jb     c0102656 <trap_dispatch+0x119>
c0102557:	83 e8 0e             	sub    $0xe,%eax
c010255a:	83 f8 21             	cmp    $0x21,%eax
c010255d:	0f 87 f3 00 00 00    	ja     c0102656 <trap_dispatch+0x119>
c0102563:	8b 04 85 c8 89 10 c0 	mov    -0x3fef7638(,%eax,4),%eax
c010256a:	ff e0                	jmp    *%eax
c010256c:	83 e8 78             	sub    $0x78,%eax
c010256f:	83 f8 01             	cmp    $0x1,%eax
c0102572:	0f 87 de 00 00 00    	ja     c0102656 <trap_dispatch+0x119>
c0102578:	e9 c2 00 00 00       	jmp    c010263f <trap_dispatch+0x102>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010257d:	83 ec 0c             	sub    $0xc,%esp
c0102580:	ff 75 08             	push   0x8(%ebp)
c0102583:	e8 5b ff ff ff       	call   c01024e3 <pgfault_handler>
c0102588:	83 c4 10             	add    $0x10,%esp
c010258b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010258e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102592:	0f 84 f7 00 00 00    	je     c010268f <trap_dispatch+0x152>
            print_trapframe(tf);
c0102598:	83 ec 0c             	sub    $0xc,%esp
c010259b:	ff 75 08             	push   0x8(%ebp)
c010259e:	e8 32 fc ff ff       	call   c01021d5 <print_trapframe>
c01025a3:	83 c4 10             	add    $0x10,%esp
            panic("handle pgfault failed. %e\n", ret);
c01025a6:	ff 75 f0             	push   -0x10(%ebp)
c01025a9:	68 5f 89 10 c0       	push   $0xc010895f
c01025ae:	68 b5 00 00 00       	push   $0xb5
c01025b3:	68 4e 89 10 c0       	push   $0xc010894e
c01025b8:	e8 e2 e6 ff ff       	call   c0100c9f <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c01025bd:	a1 24 54 12 c0       	mov    0xc0125424,%eax
c01025c2:	83 c0 01             	add    $0x1,%eax
c01025c5:	a3 24 54 12 c0       	mov    %eax,0xc0125424
        if (ticks % TICK_NUM == 0) {
c01025ca:	8b 0d 24 54 12 c0    	mov    0xc0125424,%ecx
c01025d0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01025d5:	89 c8                	mov    %ecx,%eax
c01025d7:	f7 e2                	mul    %edx
c01025d9:	89 d0                	mov    %edx,%eax
c01025db:	c1 e8 05             	shr    $0x5,%eax
c01025de:	6b d0 64             	imul   $0x64,%eax,%edx
c01025e1:	89 c8                	mov    %ecx,%eax
c01025e3:	29 d0                	sub    %edx,%eax
c01025e5:	85 c0                	test   %eax,%eax
c01025e7:	0f 85 a5 00 00 00    	jne    c0102692 <trap_dispatch+0x155>
            print_ticks();
c01025ed:	e8 8d fa ff ff       	call   c010207f <print_ticks>
        }
        break;
c01025f2:	e9 9b 00 00 00       	jmp    c0102692 <trap_dispatch+0x155>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01025f7:	e8 6e f0 ff ff       	call   c010166a <cons_getc>
c01025fc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01025ff:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102603:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102607:	83 ec 04             	sub    $0x4,%esp
c010260a:	52                   	push   %edx
c010260b:	50                   	push   %eax
c010260c:	68 7a 89 10 c0       	push   $0xc010897a
c0102611:	e8 2a dd ff ff       	call   c0100340 <cprintf>
c0102616:	83 c4 10             	add    $0x10,%esp
        break;
c0102619:	eb 78                	jmp    c0102693 <trap_dispatch+0x156>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010261b:	e8 4a f0 ff ff       	call   c010166a <cons_getc>
c0102620:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102623:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102627:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010262b:	83 ec 04             	sub    $0x4,%esp
c010262e:	52                   	push   %edx
c010262f:	50                   	push   %eax
c0102630:	68 8c 89 10 c0       	push   $0xc010898c
c0102635:	e8 06 dd ff ff       	call   c0100340 <cprintf>
c010263a:	83 c4 10             	add    $0x10,%esp
        break;
c010263d:	eb 54                	jmp    c0102693 <trap_dispatch+0x156>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c010263f:	83 ec 04             	sub    $0x4,%esp
c0102642:	68 9b 89 10 c0       	push   $0xc010899b
c0102647:	68 d3 00 00 00       	push   $0xd3
c010264c:	68 4e 89 10 c0       	push   $0xc010894e
c0102651:	e8 49 e6 ff ff       	call   c0100c9f <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102656:	8b 45 08             	mov    0x8(%ebp),%eax
c0102659:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010265d:	0f b7 c0             	movzwl %ax,%eax
c0102660:	83 e0 03             	and    $0x3,%eax
c0102663:	85 c0                	test   %eax,%eax
c0102665:	75 2c                	jne    c0102693 <trap_dispatch+0x156>
            print_trapframe(tf);
c0102667:	83 ec 0c             	sub    $0xc,%esp
c010266a:	ff 75 08             	push   0x8(%ebp)
c010266d:	e8 63 fb ff ff       	call   c01021d5 <print_trapframe>
c0102672:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0102675:	83 ec 04             	sub    $0x4,%esp
c0102678:	68 ab 89 10 c0       	push   $0xc01089ab
c010267d:	68 dd 00 00 00       	push   $0xdd
c0102682:	68 4e 89 10 c0       	push   $0xc010894e
c0102687:	e8 13 e6 ff ff       	call   c0100c9f <__panic>
        break;
c010268c:	90                   	nop
c010268d:	eb 04                	jmp    c0102693 <trap_dispatch+0x156>
        break;
c010268f:	90                   	nop
c0102690:	eb 01                	jmp    c0102693 <trap_dispatch+0x156>
        break;
c0102692:	90                   	nop
        }
    }
}
c0102693:	90                   	nop
c0102694:	c9                   	leave  
c0102695:	c3                   	ret    

c0102696 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102696:	55                   	push   %ebp
c0102697:	89 e5                	mov    %esp,%ebp
c0102699:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010269c:	83 ec 0c             	sub    $0xc,%esp
c010269f:	ff 75 08             	push   0x8(%ebp)
c01026a2:	e8 96 fe ff ff       	call   c010253d <trap_dispatch>
c01026a7:	83 c4 10             	add    $0x10,%esp
}
c01026aa:	90                   	nop
c01026ab:	c9                   	leave  
c01026ac:	c3                   	ret    

c01026ad <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01026ad:	1e                   	push   %ds
    pushl %es
c01026ae:	06                   	push   %es
    pushl %fs
c01026af:	0f a0                	push   %fs
    pushl %gs
c01026b1:	0f a8                	push   %gs
    pushal
c01026b3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01026b4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01026b9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01026bb:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01026bd:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01026be:	e8 d3 ff ff ff       	call   c0102696 <trap>

    # pop the pushed stack pointer
    popl %esp
c01026c3:	5c                   	pop    %esp

c01026c4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01026c4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01026c5:	0f a9                	pop    %gs
    popl %fs
c01026c7:	0f a1                	pop    %fs
    popl %es
c01026c9:	07                   	pop    %es
    popl %ds
c01026ca:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01026cb:	83 c4 08             	add    $0x8,%esp
    iret
c01026ce:	cf                   	iret   

c01026cf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $0
c01026d1:	6a 00                	push   $0x0
  jmp __alltraps
c01026d3:	e9 d5 ff ff ff       	jmp    c01026ad <__alltraps>

c01026d8 <vector1>:
.globl vector1
vector1:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $1
c01026da:	6a 01                	push   $0x1
  jmp __alltraps
c01026dc:	e9 cc ff ff ff       	jmp    c01026ad <__alltraps>

c01026e1 <vector2>:
.globl vector2
vector2:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $2
c01026e3:	6a 02                	push   $0x2
  jmp __alltraps
c01026e5:	e9 c3 ff ff ff       	jmp    c01026ad <__alltraps>

c01026ea <vector3>:
.globl vector3
vector3:
  pushl $0
c01026ea:	6a 00                	push   $0x0
  pushl $3
c01026ec:	6a 03                	push   $0x3
  jmp __alltraps
c01026ee:	e9 ba ff ff ff       	jmp    c01026ad <__alltraps>

c01026f3 <vector4>:
.globl vector4
vector4:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $4
c01026f5:	6a 04                	push   $0x4
  jmp __alltraps
c01026f7:	e9 b1 ff ff ff       	jmp    c01026ad <__alltraps>

c01026fc <vector5>:
.globl vector5
vector5:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $5
c01026fe:	6a 05                	push   $0x5
  jmp __alltraps
c0102700:	e9 a8 ff ff ff       	jmp    c01026ad <__alltraps>

c0102705 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $6
c0102707:	6a 06                	push   $0x6
  jmp __alltraps
c0102709:	e9 9f ff ff ff       	jmp    c01026ad <__alltraps>

c010270e <vector7>:
.globl vector7
vector7:
  pushl $0
c010270e:	6a 00                	push   $0x0
  pushl $7
c0102710:	6a 07                	push   $0x7
  jmp __alltraps
c0102712:	e9 96 ff ff ff       	jmp    c01026ad <__alltraps>

c0102717 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102717:	6a 08                	push   $0x8
  jmp __alltraps
c0102719:	e9 8f ff ff ff       	jmp    c01026ad <__alltraps>

c010271e <vector9>:
.globl vector9
vector9:
  pushl $9
c010271e:	6a 09                	push   $0x9
  jmp __alltraps
c0102720:	e9 88 ff ff ff       	jmp    c01026ad <__alltraps>

c0102725 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102725:	6a 0a                	push   $0xa
  jmp __alltraps
c0102727:	e9 81 ff ff ff       	jmp    c01026ad <__alltraps>

c010272c <vector11>:
.globl vector11
vector11:
  pushl $11
c010272c:	6a 0b                	push   $0xb
  jmp __alltraps
c010272e:	e9 7a ff ff ff       	jmp    c01026ad <__alltraps>

c0102733 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102733:	6a 0c                	push   $0xc
  jmp __alltraps
c0102735:	e9 73 ff ff ff       	jmp    c01026ad <__alltraps>

c010273a <vector13>:
.globl vector13
vector13:
  pushl $13
c010273a:	6a 0d                	push   $0xd
  jmp __alltraps
c010273c:	e9 6c ff ff ff       	jmp    c01026ad <__alltraps>

c0102741 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102741:	6a 0e                	push   $0xe
  jmp __alltraps
c0102743:	e9 65 ff ff ff       	jmp    c01026ad <__alltraps>

c0102748 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $15
c010274a:	6a 0f                	push   $0xf
  jmp __alltraps
c010274c:	e9 5c ff ff ff       	jmp    c01026ad <__alltraps>

c0102751 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $16
c0102753:	6a 10                	push   $0x10
  jmp __alltraps
c0102755:	e9 53 ff ff ff       	jmp    c01026ad <__alltraps>

c010275a <vector17>:
.globl vector17
vector17:
  pushl $17
c010275a:	6a 11                	push   $0x11
  jmp __alltraps
c010275c:	e9 4c ff ff ff       	jmp    c01026ad <__alltraps>

c0102761 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $18
c0102763:	6a 12                	push   $0x12
  jmp __alltraps
c0102765:	e9 43 ff ff ff       	jmp    c01026ad <__alltraps>

c010276a <vector19>:
.globl vector19
vector19:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $19
c010276c:	6a 13                	push   $0x13
  jmp __alltraps
c010276e:	e9 3a ff ff ff       	jmp    c01026ad <__alltraps>

c0102773 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $20
c0102775:	6a 14                	push   $0x14
  jmp __alltraps
c0102777:	e9 31 ff ff ff       	jmp    c01026ad <__alltraps>

c010277c <vector21>:
.globl vector21
vector21:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $21
c010277e:	6a 15                	push   $0x15
  jmp __alltraps
c0102780:	e9 28 ff ff ff       	jmp    c01026ad <__alltraps>

c0102785 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $22
c0102787:	6a 16                	push   $0x16
  jmp __alltraps
c0102789:	e9 1f ff ff ff       	jmp    c01026ad <__alltraps>

c010278e <vector23>:
.globl vector23
vector23:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $23
c0102790:	6a 17                	push   $0x17
  jmp __alltraps
c0102792:	e9 16 ff ff ff       	jmp    c01026ad <__alltraps>

c0102797 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $24
c0102799:	6a 18                	push   $0x18
  jmp __alltraps
c010279b:	e9 0d ff ff ff       	jmp    c01026ad <__alltraps>

c01027a0 <vector25>:
.globl vector25
vector25:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $25
c01027a2:	6a 19                	push   $0x19
  jmp __alltraps
c01027a4:	e9 04 ff ff ff       	jmp    c01026ad <__alltraps>

c01027a9 <vector26>:
.globl vector26
vector26:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $26
c01027ab:	6a 1a                	push   $0x1a
  jmp __alltraps
c01027ad:	e9 fb fe ff ff       	jmp    c01026ad <__alltraps>

c01027b2 <vector27>:
.globl vector27
vector27:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $27
c01027b4:	6a 1b                	push   $0x1b
  jmp __alltraps
c01027b6:	e9 f2 fe ff ff       	jmp    c01026ad <__alltraps>

c01027bb <vector28>:
.globl vector28
vector28:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $28
c01027bd:	6a 1c                	push   $0x1c
  jmp __alltraps
c01027bf:	e9 e9 fe ff ff       	jmp    c01026ad <__alltraps>

c01027c4 <vector29>:
.globl vector29
vector29:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $29
c01027c6:	6a 1d                	push   $0x1d
  jmp __alltraps
c01027c8:	e9 e0 fe ff ff       	jmp    c01026ad <__alltraps>

c01027cd <vector30>:
.globl vector30
vector30:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $30
c01027cf:	6a 1e                	push   $0x1e
  jmp __alltraps
c01027d1:	e9 d7 fe ff ff       	jmp    c01026ad <__alltraps>

c01027d6 <vector31>:
.globl vector31
vector31:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $31
c01027d8:	6a 1f                	push   $0x1f
  jmp __alltraps
c01027da:	e9 ce fe ff ff       	jmp    c01026ad <__alltraps>

c01027df <vector32>:
.globl vector32
vector32:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $32
c01027e1:	6a 20                	push   $0x20
  jmp __alltraps
c01027e3:	e9 c5 fe ff ff       	jmp    c01026ad <__alltraps>

c01027e8 <vector33>:
.globl vector33
vector33:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $33
c01027ea:	6a 21                	push   $0x21
  jmp __alltraps
c01027ec:	e9 bc fe ff ff       	jmp    c01026ad <__alltraps>

c01027f1 <vector34>:
.globl vector34
vector34:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $34
c01027f3:	6a 22                	push   $0x22
  jmp __alltraps
c01027f5:	e9 b3 fe ff ff       	jmp    c01026ad <__alltraps>

c01027fa <vector35>:
.globl vector35
vector35:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $35
c01027fc:	6a 23                	push   $0x23
  jmp __alltraps
c01027fe:	e9 aa fe ff ff       	jmp    c01026ad <__alltraps>

c0102803 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $36
c0102805:	6a 24                	push   $0x24
  jmp __alltraps
c0102807:	e9 a1 fe ff ff       	jmp    c01026ad <__alltraps>

c010280c <vector37>:
.globl vector37
vector37:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $37
c010280e:	6a 25                	push   $0x25
  jmp __alltraps
c0102810:	e9 98 fe ff ff       	jmp    c01026ad <__alltraps>

c0102815 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $38
c0102817:	6a 26                	push   $0x26
  jmp __alltraps
c0102819:	e9 8f fe ff ff       	jmp    c01026ad <__alltraps>

c010281e <vector39>:
.globl vector39
vector39:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $39
c0102820:	6a 27                	push   $0x27
  jmp __alltraps
c0102822:	e9 86 fe ff ff       	jmp    c01026ad <__alltraps>

c0102827 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $40
c0102829:	6a 28                	push   $0x28
  jmp __alltraps
c010282b:	e9 7d fe ff ff       	jmp    c01026ad <__alltraps>

c0102830 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $41
c0102832:	6a 29                	push   $0x29
  jmp __alltraps
c0102834:	e9 74 fe ff ff       	jmp    c01026ad <__alltraps>

c0102839 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $42
c010283b:	6a 2a                	push   $0x2a
  jmp __alltraps
c010283d:	e9 6b fe ff ff       	jmp    c01026ad <__alltraps>

c0102842 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $43
c0102844:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102846:	e9 62 fe ff ff       	jmp    c01026ad <__alltraps>

c010284b <vector44>:
.globl vector44
vector44:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $44
c010284d:	6a 2c                	push   $0x2c
  jmp __alltraps
c010284f:	e9 59 fe ff ff       	jmp    c01026ad <__alltraps>

c0102854 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $45
c0102856:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102858:	e9 50 fe ff ff       	jmp    c01026ad <__alltraps>

c010285d <vector46>:
.globl vector46
vector46:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $46
c010285f:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102861:	e9 47 fe ff ff       	jmp    c01026ad <__alltraps>

c0102866 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $47
c0102868:	6a 2f                	push   $0x2f
  jmp __alltraps
c010286a:	e9 3e fe ff ff       	jmp    c01026ad <__alltraps>

c010286f <vector48>:
.globl vector48
vector48:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $48
c0102871:	6a 30                	push   $0x30
  jmp __alltraps
c0102873:	e9 35 fe ff ff       	jmp    c01026ad <__alltraps>

c0102878 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $49
c010287a:	6a 31                	push   $0x31
  jmp __alltraps
c010287c:	e9 2c fe ff ff       	jmp    c01026ad <__alltraps>

c0102881 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $50
c0102883:	6a 32                	push   $0x32
  jmp __alltraps
c0102885:	e9 23 fe ff ff       	jmp    c01026ad <__alltraps>

c010288a <vector51>:
.globl vector51
vector51:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $51
c010288c:	6a 33                	push   $0x33
  jmp __alltraps
c010288e:	e9 1a fe ff ff       	jmp    c01026ad <__alltraps>

c0102893 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $52
c0102895:	6a 34                	push   $0x34
  jmp __alltraps
c0102897:	e9 11 fe ff ff       	jmp    c01026ad <__alltraps>

c010289c <vector53>:
.globl vector53
vector53:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $53
c010289e:	6a 35                	push   $0x35
  jmp __alltraps
c01028a0:	e9 08 fe ff ff       	jmp    c01026ad <__alltraps>

c01028a5 <vector54>:
.globl vector54
vector54:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $54
c01028a7:	6a 36                	push   $0x36
  jmp __alltraps
c01028a9:	e9 ff fd ff ff       	jmp    c01026ad <__alltraps>

c01028ae <vector55>:
.globl vector55
vector55:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $55
c01028b0:	6a 37                	push   $0x37
  jmp __alltraps
c01028b2:	e9 f6 fd ff ff       	jmp    c01026ad <__alltraps>

c01028b7 <vector56>:
.globl vector56
vector56:
  pushl $0
c01028b7:	6a 00                	push   $0x0
  pushl $56
c01028b9:	6a 38                	push   $0x38
  jmp __alltraps
c01028bb:	e9 ed fd ff ff       	jmp    c01026ad <__alltraps>

c01028c0 <vector57>:
.globl vector57
vector57:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $57
c01028c2:	6a 39                	push   $0x39
  jmp __alltraps
c01028c4:	e9 e4 fd ff ff       	jmp    c01026ad <__alltraps>

c01028c9 <vector58>:
.globl vector58
vector58:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $58
c01028cb:	6a 3a                	push   $0x3a
  jmp __alltraps
c01028cd:	e9 db fd ff ff       	jmp    c01026ad <__alltraps>

c01028d2 <vector59>:
.globl vector59
vector59:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $59
c01028d4:	6a 3b                	push   $0x3b
  jmp __alltraps
c01028d6:	e9 d2 fd ff ff       	jmp    c01026ad <__alltraps>

c01028db <vector60>:
.globl vector60
vector60:
  pushl $0
c01028db:	6a 00                	push   $0x0
  pushl $60
c01028dd:	6a 3c                	push   $0x3c
  jmp __alltraps
c01028df:	e9 c9 fd ff ff       	jmp    c01026ad <__alltraps>

c01028e4 <vector61>:
.globl vector61
vector61:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $61
c01028e6:	6a 3d                	push   $0x3d
  jmp __alltraps
c01028e8:	e9 c0 fd ff ff       	jmp    c01026ad <__alltraps>

c01028ed <vector62>:
.globl vector62
vector62:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $62
c01028ef:	6a 3e                	push   $0x3e
  jmp __alltraps
c01028f1:	e9 b7 fd ff ff       	jmp    c01026ad <__alltraps>

c01028f6 <vector63>:
.globl vector63
vector63:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $63
c01028f8:	6a 3f                	push   $0x3f
  jmp __alltraps
c01028fa:	e9 ae fd ff ff       	jmp    c01026ad <__alltraps>

c01028ff <vector64>:
.globl vector64
vector64:
  pushl $0
c01028ff:	6a 00                	push   $0x0
  pushl $64
c0102901:	6a 40                	push   $0x40
  jmp __alltraps
c0102903:	e9 a5 fd ff ff       	jmp    c01026ad <__alltraps>

c0102908 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $65
c010290a:	6a 41                	push   $0x41
  jmp __alltraps
c010290c:	e9 9c fd ff ff       	jmp    c01026ad <__alltraps>

c0102911 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $66
c0102913:	6a 42                	push   $0x42
  jmp __alltraps
c0102915:	e9 93 fd ff ff       	jmp    c01026ad <__alltraps>

c010291a <vector67>:
.globl vector67
vector67:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $67
c010291c:	6a 43                	push   $0x43
  jmp __alltraps
c010291e:	e9 8a fd ff ff       	jmp    c01026ad <__alltraps>

c0102923 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102923:	6a 00                	push   $0x0
  pushl $68
c0102925:	6a 44                	push   $0x44
  jmp __alltraps
c0102927:	e9 81 fd ff ff       	jmp    c01026ad <__alltraps>

c010292c <vector69>:
.globl vector69
vector69:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $69
c010292e:	6a 45                	push   $0x45
  jmp __alltraps
c0102930:	e9 78 fd ff ff       	jmp    c01026ad <__alltraps>

c0102935 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $70
c0102937:	6a 46                	push   $0x46
  jmp __alltraps
c0102939:	e9 6f fd ff ff       	jmp    c01026ad <__alltraps>

c010293e <vector71>:
.globl vector71
vector71:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $71
c0102940:	6a 47                	push   $0x47
  jmp __alltraps
c0102942:	e9 66 fd ff ff       	jmp    c01026ad <__alltraps>

c0102947 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102947:	6a 00                	push   $0x0
  pushl $72
c0102949:	6a 48                	push   $0x48
  jmp __alltraps
c010294b:	e9 5d fd ff ff       	jmp    c01026ad <__alltraps>

c0102950 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $73
c0102952:	6a 49                	push   $0x49
  jmp __alltraps
c0102954:	e9 54 fd ff ff       	jmp    c01026ad <__alltraps>

c0102959 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $74
c010295b:	6a 4a                	push   $0x4a
  jmp __alltraps
c010295d:	e9 4b fd ff ff       	jmp    c01026ad <__alltraps>

c0102962 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $75
c0102964:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102966:	e9 42 fd ff ff       	jmp    c01026ad <__alltraps>

c010296b <vector76>:
.globl vector76
vector76:
  pushl $0
c010296b:	6a 00                	push   $0x0
  pushl $76
c010296d:	6a 4c                	push   $0x4c
  jmp __alltraps
c010296f:	e9 39 fd ff ff       	jmp    c01026ad <__alltraps>

c0102974 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $77
c0102976:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102978:	e9 30 fd ff ff       	jmp    c01026ad <__alltraps>

c010297d <vector78>:
.globl vector78
vector78:
  pushl $0
c010297d:	6a 00                	push   $0x0
  pushl $78
c010297f:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102981:	e9 27 fd ff ff       	jmp    c01026ad <__alltraps>

c0102986 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $79
c0102988:	6a 4f                	push   $0x4f
  jmp __alltraps
c010298a:	e9 1e fd ff ff       	jmp    c01026ad <__alltraps>

c010298f <vector80>:
.globl vector80
vector80:
  pushl $0
c010298f:	6a 00                	push   $0x0
  pushl $80
c0102991:	6a 50                	push   $0x50
  jmp __alltraps
c0102993:	e9 15 fd ff ff       	jmp    c01026ad <__alltraps>

c0102998 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $81
c010299a:	6a 51                	push   $0x51
  jmp __alltraps
c010299c:	e9 0c fd ff ff       	jmp    c01026ad <__alltraps>

c01029a1 <vector82>:
.globl vector82
vector82:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $82
c01029a3:	6a 52                	push   $0x52
  jmp __alltraps
c01029a5:	e9 03 fd ff ff       	jmp    c01026ad <__alltraps>

c01029aa <vector83>:
.globl vector83
vector83:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $83
c01029ac:	6a 53                	push   $0x53
  jmp __alltraps
c01029ae:	e9 fa fc ff ff       	jmp    c01026ad <__alltraps>

c01029b3 <vector84>:
.globl vector84
vector84:
  pushl $0
c01029b3:	6a 00                	push   $0x0
  pushl $84
c01029b5:	6a 54                	push   $0x54
  jmp __alltraps
c01029b7:	e9 f1 fc ff ff       	jmp    c01026ad <__alltraps>

c01029bc <vector85>:
.globl vector85
vector85:
  pushl $0
c01029bc:	6a 00                	push   $0x0
  pushl $85
c01029be:	6a 55                	push   $0x55
  jmp __alltraps
c01029c0:	e9 e8 fc ff ff       	jmp    c01026ad <__alltraps>

c01029c5 <vector86>:
.globl vector86
vector86:
  pushl $0
c01029c5:	6a 00                	push   $0x0
  pushl $86
c01029c7:	6a 56                	push   $0x56
  jmp __alltraps
c01029c9:	e9 df fc ff ff       	jmp    c01026ad <__alltraps>

c01029ce <vector87>:
.globl vector87
vector87:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $87
c01029d0:	6a 57                	push   $0x57
  jmp __alltraps
c01029d2:	e9 d6 fc ff ff       	jmp    c01026ad <__alltraps>

c01029d7 <vector88>:
.globl vector88
vector88:
  pushl $0
c01029d7:	6a 00                	push   $0x0
  pushl $88
c01029d9:	6a 58                	push   $0x58
  jmp __alltraps
c01029db:	e9 cd fc ff ff       	jmp    c01026ad <__alltraps>

c01029e0 <vector89>:
.globl vector89
vector89:
  pushl $0
c01029e0:	6a 00                	push   $0x0
  pushl $89
c01029e2:	6a 59                	push   $0x59
  jmp __alltraps
c01029e4:	e9 c4 fc ff ff       	jmp    c01026ad <__alltraps>

c01029e9 <vector90>:
.globl vector90
vector90:
  pushl $0
c01029e9:	6a 00                	push   $0x0
  pushl $90
c01029eb:	6a 5a                	push   $0x5a
  jmp __alltraps
c01029ed:	e9 bb fc ff ff       	jmp    c01026ad <__alltraps>

c01029f2 <vector91>:
.globl vector91
vector91:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $91
c01029f4:	6a 5b                	push   $0x5b
  jmp __alltraps
c01029f6:	e9 b2 fc ff ff       	jmp    c01026ad <__alltraps>

c01029fb <vector92>:
.globl vector92
vector92:
  pushl $0
c01029fb:	6a 00                	push   $0x0
  pushl $92
c01029fd:	6a 5c                	push   $0x5c
  jmp __alltraps
c01029ff:	e9 a9 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a04 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a04:	6a 00                	push   $0x0
  pushl $93
c0102a06:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a08:	e9 a0 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a0d <vector94>:
.globl vector94
vector94:
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  pushl $94
c0102a0f:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102a11:	e9 97 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a16 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $95
c0102a18:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102a1a:	e9 8e fc ff ff       	jmp    c01026ad <__alltraps>

c0102a1f <vector96>:
.globl vector96
vector96:
  pushl $0
c0102a1f:	6a 00                	push   $0x0
  pushl $96
c0102a21:	6a 60                	push   $0x60
  jmp __alltraps
c0102a23:	e9 85 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a28 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102a28:	6a 00                	push   $0x0
  pushl $97
c0102a2a:	6a 61                	push   $0x61
  jmp __alltraps
c0102a2c:	e9 7c fc ff ff       	jmp    c01026ad <__alltraps>

c0102a31 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102a31:	6a 00                	push   $0x0
  pushl $98
c0102a33:	6a 62                	push   $0x62
  jmp __alltraps
c0102a35:	e9 73 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a3a <vector99>:
.globl vector99
vector99:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $99
c0102a3c:	6a 63                	push   $0x63
  jmp __alltraps
c0102a3e:	e9 6a fc ff ff       	jmp    c01026ad <__alltraps>

c0102a43 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102a43:	6a 00                	push   $0x0
  pushl $100
c0102a45:	6a 64                	push   $0x64
  jmp __alltraps
c0102a47:	e9 61 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a4c <vector101>:
.globl vector101
vector101:
  pushl $0
c0102a4c:	6a 00                	push   $0x0
  pushl $101
c0102a4e:	6a 65                	push   $0x65
  jmp __alltraps
c0102a50:	e9 58 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a55 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102a55:	6a 00                	push   $0x0
  pushl $102
c0102a57:	6a 66                	push   $0x66
  jmp __alltraps
c0102a59:	e9 4f fc ff ff       	jmp    c01026ad <__alltraps>

c0102a5e <vector103>:
.globl vector103
vector103:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $103
c0102a60:	6a 67                	push   $0x67
  jmp __alltraps
c0102a62:	e9 46 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a67 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102a67:	6a 00                	push   $0x0
  pushl $104
c0102a69:	6a 68                	push   $0x68
  jmp __alltraps
c0102a6b:	e9 3d fc ff ff       	jmp    c01026ad <__alltraps>

c0102a70 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102a70:	6a 00                	push   $0x0
  pushl $105
c0102a72:	6a 69                	push   $0x69
  jmp __alltraps
c0102a74:	e9 34 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a79 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102a79:	6a 00                	push   $0x0
  pushl $106
c0102a7b:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102a7d:	e9 2b fc ff ff       	jmp    c01026ad <__alltraps>

c0102a82 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $107
c0102a84:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102a86:	e9 22 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a8b <vector108>:
.globl vector108
vector108:
  pushl $0
c0102a8b:	6a 00                	push   $0x0
  pushl $108
c0102a8d:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102a8f:	e9 19 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a94 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102a94:	6a 00                	push   $0x0
  pushl $109
c0102a96:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102a98:	e9 10 fc ff ff       	jmp    c01026ad <__alltraps>

c0102a9d <vector110>:
.globl vector110
vector110:
  pushl $0
c0102a9d:	6a 00                	push   $0x0
  pushl $110
c0102a9f:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102aa1:	e9 07 fc ff ff       	jmp    c01026ad <__alltraps>

c0102aa6 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $111
c0102aa8:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102aaa:	e9 fe fb ff ff       	jmp    c01026ad <__alltraps>

c0102aaf <vector112>:
.globl vector112
vector112:
  pushl $0
c0102aaf:	6a 00                	push   $0x0
  pushl $112
c0102ab1:	6a 70                	push   $0x70
  jmp __alltraps
c0102ab3:	e9 f5 fb ff ff       	jmp    c01026ad <__alltraps>

c0102ab8 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102ab8:	6a 00                	push   $0x0
  pushl $113
c0102aba:	6a 71                	push   $0x71
  jmp __alltraps
c0102abc:	e9 ec fb ff ff       	jmp    c01026ad <__alltraps>

c0102ac1 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102ac1:	6a 00                	push   $0x0
  pushl $114
c0102ac3:	6a 72                	push   $0x72
  jmp __alltraps
c0102ac5:	e9 e3 fb ff ff       	jmp    c01026ad <__alltraps>

c0102aca <vector115>:
.globl vector115
vector115:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $115
c0102acc:	6a 73                	push   $0x73
  jmp __alltraps
c0102ace:	e9 da fb ff ff       	jmp    c01026ad <__alltraps>

c0102ad3 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102ad3:	6a 00                	push   $0x0
  pushl $116
c0102ad5:	6a 74                	push   $0x74
  jmp __alltraps
c0102ad7:	e9 d1 fb ff ff       	jmp    c01026ad <__alltraps>

c0102adc <vector117>:
.globl vector117
vector117:
  pushl $0
c0102adc:	6a 00                	push   $0x0
  pushl $117
c0102ade:	6a 75                	push   $0x75
  jmp __alltraps
c0102ae0:	e9 c8 fb ff ff       	jmp    c01026ad <__alltraps>

c0102ae5 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102ae5:	6a 00                	push   $0x0
  pushl $118
c0102ae7:	6a 76                	push   $0x76
  jmp __alltraps
c0102ae9:	e9 bf fb ff ff       	jmp    c01026ad <__alltraps>

c0102aee <vector119>:
.globl vector119
vector119:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $119
c0102af0:	6a 77                	push   $0x77
  jmp __alltraps
c0102af2:	e9 b6 fb ff ff       	jmp    c01026ad <__alltraps>

c0102af7 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102af7:	6a 00                	push   $0x0
  pushl $120
c0102af9:	6a 78                	push   $0x78
  jmp __alltraps
c0102afb:	e9 ad fb ff ff       	jmp    c01026ad <__alltraps>

c0102b00 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b00:	6a 00                	push   $0x0
  pushl $121
c0102b02:	6a 79                	push   $0x79
  jmp __alltraps
c0102b04:	e9 a4 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b09 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b09:	6a 00                	push   $0x0
  pushl $122
c0102b0b:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102b0d:	e9 9b fb ff ff       	jmp    c01026ad <__alltraps>

c0102b12 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $123
c0102b14:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102b16:	e9 92 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b1b <vector124>:
.globl vector124
vector124:
  pushl $0
c0102b1b:	6a 00                	push   $0x0
  pushl $124
c0102b1d:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102b1f:	e9 89 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b24 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102b24:	6a 00                	push   $0x0
  pushl $125
c0102b26:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102b28:	e9 80 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b2d <vector126>:
.globl vector126
vector126:
  pushl $0
c0102b2d:	6a 00                	push   $0x0
  pushl $126
c0102b2f:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102b31:	e9 77 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b36 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $127
c0102b38:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102b3a:	e9 6e fb ff ff       	jmp    c01026ad <__alltraps>

c0102b3f <vector128>:
.globl vector128
vector128:
  pushl $0
c0102b3f:	6a 00                	push   $0x0
  pushl $128
c0102b41:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102b46:	e9 62 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b4b <vector129>:
.globl vector129
vector129:
  pushl $0
c0102b4b:	6a 00                	push   $0x0
  pushl $129
c0102b4d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102b52:	e9 56 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b57 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102b57:	6a 00                	push   $0x0
  pushl $130
c0102b59:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102b5e:	e9 4a fb ff ff       	jmp    c01026ad <__alltraps>

c0102b63 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102b63:	6a 00                	push   $0x0
  pushl $131
c0102b65:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102b6a:	e9 3e fb ff ff       	jmp    c01026ad <__alltraps>

c0102b6f <vector132>:
.globl vector132
vector132:
  pushl $0
c0102b6f:	6a 00                	push   $0x0
  pushl $132
c0102b71:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102b76:	e9 32 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b7b <vector133>:
.globl vector133
vector133:
  pushl $0
c0102b7b:	6a 00                	push   $0x0
  pushl $133
c0102b7d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102b82:	e9 26 fb ff ff       	jmp    c01026ad <__alltraps>

c0102b87 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102b87:	6a 00                	push   $0x0
  pushl $134
c0102b89:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102b8e:	e9 1a fb ff ff       	jmp    c01026ad <__alltraps>

c0102b93 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102b93:	6a 00                	push   $0x0
  pushl $135
c0102b95:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102b9a:	e9 0e fb ff ff       	jmp    c01026ad <__alltraps>

c0102b9f <vector136>:
.globl vector136
vector136:
  pushl $0
c0102b9f:	6a 00                	push   $0x0
  pushl $136
c0102ba1:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ba6:	e9 02 fb ff ff       	jmp    c01026ad <__alltraps>

c0102bab <vector137>:
.globl vector137
vector137:
  pushl $0
c0102bab:	6a 00                	push   $0x0
  pushl $137
c0102bad:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102bb2:	e9 f6 fa ff ff       	jmp    c01026ad <__alltraps>

c0102bb7 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102bb7:	6a 00                	push   $0x0
  pushl $138
c0102bb9:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102bbe:	e9 ea fa ff ff       	jmp    c01026ad <__alltraps>

c0102bc3 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102bc3:	6a 00                	push   $0x0
  pushl $139
c0102bc5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102bca:	e9 de fa ff ff       	jmp    c01026ad <__alltraps>

c0102bcf <vector140>:
.globl vector140
vector140:
  pushl $0
c0102bcf:	6a 00                	push   $0x0
  pushl $140
c0102bd1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102bd6:	e9 d2 fa ff ff       	jmp    c01026ad <__alltraps>

c0102bdb <vector141>:
.globl vector141
vector141:
  pushl $0
c0102bdb:	6a 00                	push   $0x0
  pushl $141
c0102bdd:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102be2:	e9 c6 fa ff ff       	jmp    c01026ad <__alltraps>

c0102be7 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102be7:	6a 00                	push   $0x0
  pushl $142
c0102be9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102bee:	e9 ba fa ff ff       	jmp    c01026ad <__alltraps>

c0102bf3 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102bf3:	6a 00                	push   $0x0
  pushl $143
c0102bf5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102bfa:	e9 ae fa ff ff       	jmp    c01026ad <__alltraps>

c0102bff <vector144>:
.globl vector144
vector144:
  pushl $0
c0102bff:	6a 00                	push   $0x0
  pushl $144
c0102c01:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c06:	e9 a2 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c0b <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c0b:	6a 00                	push   $0x0
  pushl $145
c0102c0d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102c12:	e9 96 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c17 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102c17:	6a 00                	push   $0x0
  pushl $146
c0102c19:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102c1e:	e9 8a fa ff ff       	jmp    c01026ad <__alltraps>

c0102c23 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102c23:	6a 00                	push   $0x0
  pushl $147
c0102c25:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102c2a:	e9 7e fa ff ff       	jmp    c01026ad <__alltraps>

c0102c2f <vector148>:
.globl vector148
vector148:
  pushl $0
c0102c2f:	6a 00                	push   $0x0
  pushl $148
c0102c31:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102c36:	e9 72 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c3b <vector149>:
.globl vector149
vector149:
  pushl $0
c0102c3b:	6a 00                	push   $0x0
  pushl $149
c0102c3d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102c42:	e9 66 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c47 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102c47:	6a 00                	push   $0x0
  pushl $150
c0102c49:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102c4e:	e9 5a fa ff ff       	jmp    c01026ad <__alltraps>

c0102c53 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102c53:	6a 00                	push   $0x0
  pushl $151
c0102c55:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102c5a:	e9 4e fa ff ff       	jmp    c01026ad <__alltraps>

c0102c5f <vector152>:
.globl vector152
vector152:
  pushl $0
c0102c5f:	6a 00                	push   $0x0
  pushl $152
c0102c61:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102c66:	e9 42 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c6b <vector153>:
.globl vector153
vector153:
  pushl $0
c0102c6b:	6a 00                	push   $0x0
  pushl $153
c0102c6d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102c72:	e9 36 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c77 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102c77:	6a 00                	push   $0x0
  pushl $154
c0102c79:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102c7e:	e9 2a fa ff ff       	jmp    c01026ad <__alltraps>

c0102c83 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102c83:	6a 00                	push   $0x0
  pushl $155
c0102c85:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102c8a:	e9 1e fa ff ff       	jmp    c01026ad <__alltraps>

c0102c8f <vector156>:
.globl vector156
vector156:
  pushl $0
c0102c8f:	6a 00                	push   $0x0
  pushl $156
c0102c91:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102c96:	e9 12 fa ff ff       	jmp    c01026ad <__alltraps>

c0102c9b <vector157>:
.globl vector157
vector157:
  pushl $0
c0102c9b:	6a 00                	push   $0x0
  pushl $157
c0102c9d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102ca2:	e9 06 fa ff ff       	jmp    c01026ad <__alltraps>

c0102ca7 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102ca7:	6a 00                	push   $0x0
  pushl $158
c0102ca9:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102cae:	e9 fa f9 ff ff       	jmp    c01026ad <__alltraps>

c0102cb3 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102cb3:	6a 00                	push   $0x0
  pushl $159
c0102cb5:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102cba:	e9 ee f9 ff ff       	jmp    c01026ad <__alltraps>

c0102cbf <vector160>:
.globl vector160
vector160:
  pushl $0
c0102cbf:	6a 00                	push   $0x0
  pushl $160
c0102cc1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102cc6:	e9 e2 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102ccb <vector161>:
.globl vector161
vector161:
  pushl $0
c0102ccb:	6a 00                	push   $0x0
  pushl $161
c0102ccd:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102cd2:	e9 d6 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102cd7 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102cd7:	6a 00                	push   $0x0
  pushl $162
c0102cd9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102cde:	e9 ca f9 ff ff       	jmp    c01026ad <__alltraps>

c0102ce3 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102ce3:	6a 00                	push   $0x0
  pushl $163
c0102ce5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102cea:	e9 be f9 ff ff       	jmp    c01026ad <__alltraps>

c0102cef <vector164>:
.globl vector164
vector164:
  pushl $0
c0102cef:	6a 00                	push   $0x0
  pushl $164
c0102cf1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102cf6:	e9 b2 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102cfb <vector165>:
.globl vector165
vector165:
  pushl $0
c0102cfb:	6a 00                	push   $0x0
  pushl $165
c0102cfd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d02:	e9 a6 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d07 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d07:	6a 00                	push   $0x0
  pushl $166
c0102d09:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102d0e:	e9 9a f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d13 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102d13:	6a 00                	push   $0x0
  pushl $167
c0102d15:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102d1a:	e9 8e f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d1f <vector168>:
.globl vector168
vector168:
  pushl $0
c0102d1f:	6a 00                	push   $0x0
  pushl $168
c0102d21:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102d26:	e9 82 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d2b <vector169>:
.globl vector169
vector169:
  pushl $0
c0102d2b:	6a 00                	push   $0x0
  pushl $169
c0102d2d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102d32:	e9 76 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d37 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102d37:	6a 00                	push   $0x0
  pushl $170
c0102d39:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102d3e:	e9 6a f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d43 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102d43:	6a 00                	push   $0x0
  pushl $171
c0102d45:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102d4a:	e9 5e f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d4f <vector172>:
.globl vector172
vector172:
  pushl $0
c0102d4f:	6a 00                	push   $0x0
  pushl $172
c0102d51:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102d56:	e9 52 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d5b <vector173>:
.globl vector173
vector173:
  pushl $0
c0102d5b:	6a 00                	push   $0x0
  pushl $173
c0102d5d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102d62:	e9 46 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d67 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102d67:	6a 00                	push   $0x0
  pushl $174
c0102d69:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102d6e:	e9 3a f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d73 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102d73:	6a 00                	push   $0x0
  pushl $175
c0102d75:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102d7a:	e9 2e f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d7f <vector176>:
.globl vector176
vector176:
  pushl $0
c0102d7f:	6a 00                	push   $0x0
  pushl $176
c0102d81:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102d86:	e9 22 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d8b <vector177>:
.globl vector177
vector177:
  pushl $0
c0102d8b:	6a 00                	push   $0x0
  pushl $177
c0102d8d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102d92:	e9 16 f9 ff ff       	jmp    c01026ad <__alltraps>

c0102d97 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102d97:	6a 00                	push   $0x0
  pushl $178
c0102d99:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102d9e:	e9 0a f9 ff ff       	jmp    c01026ad <__alltraps>

c0102da3 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102da3:	6a 00                	push   $0x0
  pushl $179
c0102da5:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102daa:	e9 fe f8 ff ff       	jmp    c01026ad <__alltraps>

c0102daf <vector180>:
.globl vector180
vector180:
  pushl $0
c0102daf:	6a 00                	push   $0x0
  pushl $180
c0102db1:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102db6:	e9 f2 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102dbb <vector181>:
.globl vector181
vector181:
  pushl $0
c0102dbb:	6a 00                	push   $0x0
  pushl $181
c0102dbd:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102dc2:	e9 e6 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102dc7 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102dc7:	6a 00                	push   $0x0
  pushl $182
c0102dc9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102dce:	e9 da f8 ff ff       	jmp    c01026ad <__alltraps>

c0102dd3 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102dd3:	6a 00                	push   $0x0
  pushl $183
c0102dd5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102dda:	e9 ce f8 ff ff       	jmp    c01026ad <__alltraps>

c0102ddf <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ddf:	6a 00                	push   $0x0
  pushl $184
c0102de1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102de6:	e9 c2 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102deb <vector185>:
.globl vector185
vector185:
  pushl $0
c0102deb:	6a 00                	push   $0x0
  pushl $185
c0102ded:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102df2:	e9 b6 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102df7 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102df7:	6a 00                	push   $0x0
  pushl $186
c0102df9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102dfe:	e9 aa f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e03 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e03:	6a 00                	push   $0x0
  pushl $187
c0102e05:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e0a:	e9 9e f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e0f <vector188>:
.globl vector188
vector188:
  pushl $0
c0102e0f:	6a 00                	push   $0x0
  pushl $188
c0102e11:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102e16:	e9 92 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e1b <vector189>:
.globl vector189
vector189:
  pushl $0
c0102e1b:	6a 00                	push   $0x0
  pushl $189
c0102e1d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102e22:	e9 86 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e27 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102e27:	6a 00                	push   $0x0
  pushl $190
c0102e29:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102e2e:	e9 7a f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e33 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102e33:	6a 00                	push   $0x0
  pushl $191
c0102e35:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102e3a:	e9 6e f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e3f <vector192>:
.globl vector192
vector192:
  pushl $0
c0102e3f:	6a 00                	push   $0x0
  pushl $192
c0102e41:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102e46:	e9 62 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e4b <vector193>:
.globl vector193
vector193:
  pushl $0
c0102e4b:	6a 00                	push   $0x0
  pushl $193
c0102e4d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102e52:	e9 56 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e57 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102e57:	6a 00                	push   $0x0
  pushl $194
c0102e59:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102e5e:	e9 4a f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e63 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102e63:	6a 00                	push   $0x0
  pushl $195
c0102e65:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102e6a:	e9 3e f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e6f <vector196>:
.globl vector196
vector196:
  pushl $0
c0102e6f:	6a 00                	push   $0x0
  pushl $196
c0102e71:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102e76:	e9 32 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e7b <vector197>:
.globl vector197
vector197:
  pushl $0
c0102e7b:	6a 00                	push   $0x0
  pushl $197
c0102e7d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102e82:	e9 26 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e87 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102e87:	6a 00                	push   $0x0
  pushl $198
c0102e89:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102e8e:	e9 1a f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e93 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102e93:	6a 00                	push   $0x0
  pushl $199
c0102e95:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102e9a:	e9 0e f8 ff ff       	jmp    c01026ad <__alltraps>

c0102e9f <vector200>:
.globl vector200
vector200:
  pushl $0
c0102e9f:	6a 00                	push   $0x0
  pushl $200
c0102ea1:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102ea6:	e9 02 f8 ff ff       	jmp    c01026ad <__alltraps>

c0102eab <vector201>:
.globl vector201
vector201:
  pushl $0
c0102eab:	6a 00                	push   $0x0
  pushl $201
c0102ead:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102eb2:	e9 f6 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102eb7 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102eb7:	6a 00                	push   $0x0
  pushl $202
c0102eb9:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102ebe:	e9 ea f7 ff ff       	jmp    c01026ad <__alltraps>

c0102ec3 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102ec3:	6a 00                	push   $0x0
  pushl $203
c0102ec5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102eca:	e9 de f7 ff ff       	jmp    c01026ad <__alltraps>

c0102ecf <vector204>:
.globl vector204
vector204:
  pushl $0
c0102ecf:	6a 00                	push   $0x0
  pushl $204
c0102ed1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102ed6:	e9 d2 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102edb <vector205>:
.globl vector205
vector205:
  pushl $0
c0102edb:	6a 00                	push   $0x0
  pushl $205
c0102edd:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102ee2:	e9 c6 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102ee7 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102ee7:	6a 00                	push   $0x0
  pushl $206
c0102ee9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102eee:	e9 ba f7 ff ff       	jmp    c01026ad <__alltraps>

c0102ef3 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102ef3:	6a 00                	push   $0x0
  pushl $207
c0102ef5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102efa:	e9 ae f7 ff ff       	jmp    c01026ad <__alltraps>

c0102eff <vector208>:
.globl vector208
vector208:
  pushl $0
c0102eff:	6a 00                	push   $0x0
  pushl $208
c0102f01:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f06:	e9 a2 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f0b <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f0b:	6a 00                	push   $0x0
  pushl $209
c0102f0d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102f12:	e9 96 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f17 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102f17:	6a 00                	push   $0x0
  pushl $210
c0102f19:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102f1e:	e9 8a f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f23 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102f23:	6a 00                	push   $0x0
  pushl $211
c0102f25:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102f2a:	e9 7e f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f2f <vector212>:
.globl vector212
vector212:
  pushl $0
c0102f2f:	6a 00                	push   $0x0
  pushl $212
c0102f31:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102f36:	e9 72 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f3b <vector213>:
.globl vector213
vector213:
  pushl $0
c0102f3b:	6a 00                	push   $0x0
  pushl $213
c0102f3d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102f42:	e9 66 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f47 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102f47:	6a 00                	push   $0x0
  pushl $214
c0102f49:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102f4e:	e9 5a f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f53 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102f53:	6a 00                	push   $0x0
  pushl $215
c0102f55:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102f5a:	e9 4e f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f5f <vector216>:
.globl vector216
vector216:
  pushl $0
c0102f5f:	6a 00                	push   $0x0
  pushl $216
c0102f61:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102f66:	e9 42 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f6b <vector217>:
.globl vector217
vector217:
  pushl $0
c0102f6b:	6a 00                	push   $0x0
  pushl $217
c0102f6d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102f72:	e9 36 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f77 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102f77:	6a 00                	push   $0x0
  pushl $218
c0102f79:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102f7e:	e9 2a f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f83 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102f83:	6a 00                	push   $0x0
  pushl $219
c0102f85:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102f8a:	e9 1e f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f8f <vector220>:
.globl vector220
vector220:
  pushl $0
c0102f8f:	6a 00                	push   $0x0
  pushl $220
c0102f91:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102f96:	e9 12 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102f9b <vector221>:
.globl vector221
vector221:
  pushl $0
c0102f9b:	6a 00                	push   $0x0
  pushl $221
c0102f9d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102fa2:	e9 06 f7 ff ff       	jmp    c01026ad <__alltraps>

c0102fa7 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102fa7:	6a 00                	push   $0x0
  pushl $222
c0102fa9:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102fae:	e9 fa f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fb3 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102fb3:	6a 00                	push   $0x0
  pushl $223
c0102fb5:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102fba:	e9 ee f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fbf <vector224>:
.globl vector224
vector224:
  pushl $0
c0102fbf:	6a 00                	push   $0x0
  pushl $224
c0102fc1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102fc6:	e9 e2 f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fcb <vector225>:
.globl vector225
vector225:
  pushl $0
c0102fcb:	6a 00                	push   $0x0
  pushl $225
c0102fcd:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102fd2:	e9 d6 f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fd7 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102fd7:	6a 00                	push   $0x0
  pushl $226
c0102fd9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102fde:	e9 ca f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fe3 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102fe3:	6a 00                	push   $0x0
  pushl $227
c0102fe5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102fea:	e9 be f6 ff ff       	jmp    c01026ad <__alltraps>

c0102fef <vector228>:
.globl vector228
vector228:
  pushl $0
c0102fef:	6a 00                	push   $0x0
  pushl $228
c0102ff1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102ff6:	e9 b2 f6 ff ff       	jmp    c01026ad <__alltraps>

c0102ffb <vector229>:
.globl vector229
vector229:
  pushl $0
c0102ffb:	6a 00                	push   $0x0
  pushl $229
c0102ffd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103002:	e9 a6 f6 ff ff       	jmp    c01026ad <__alltraps>

c0103007 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103007:	6a 00                	push   $0x0
  pushl $230
c0103009:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010300e:	e9 9a f6 ff ff       	jmp    c01026ad <__alltraps>

c0103013 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103013:	6a 00                	push   $0x0
  pushl $231
c0103015:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010301a:	e9 8e f6 ff ff       	jmp    c01026ad <__alltraps>

c010301f <vector232>:
.globl vector232
vector232:
  pushl $0
c010301f:	6a 00                	push   $0x0
  pushl $232
c0103021:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103026:	e9 82 f6 ff ff       	jmp    c01026ad <__alltraps>

c010302b <vector233>:
.globl vector233
vector233:
  pushl $0
c010302b:	6a 00                	push   $0x0
  pushl $233
c010302d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103032:	e9 76 f6 ff ff       	jmp    c01026ad <__alltraps>

c0103037 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103037:	6a 00                	push   $0x0
  pushl $234
c0103039:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010303e:	e9 6a f6 ff ff       	jmp    c01026ad <__alltraps>

c0103043 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103043:	6a 00                	push   $0x0
  pushl $235
c0103045:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010304a:	e9 5e f6 ff ff       	jmp    c01026ad <__alltraps>

c010304f <vector236>:
.globl vector236
vector236:
  pushl $0
c010304f:	6a 00                	push   $0x0
  pushl $236
c0103051:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103056:	e9 52 f6 ff ff       	jmp    c01026ad <__alltraps>

c010305b <vector237>:
.globl vector237
vector237:
  pushl $0
c010305b:	6a 00                	push   $0x0
  pushl $237
c010305d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103062:	e9 46 f6 ff ff       	jmp    c01026ad <__alltraps>

c0103067 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103067:	6a 00                	push   $0x0
  pushl $238
c0103069:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010306e:	e9 3a f6 ff ff       	jmp    c01026ad <__alltraps>

c0103073 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103073:	6a 00                	push   $0x0
  pushl $239
c0103075:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010307a:	e9 2e f6 ff ff       	jmp    c01026ad <__alltraps>

c010307f <vector240>:
.globl vector240
vector240:
  pushl $0
c010307f:	6a 00                	push   $0x0
  pushl $240
c0103081:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103086:	e9 22 f6 ff ff       	jmp    c01026ad <__alltraps>

c010308b <vector241>:
.globl vector241
vector241:
  pushl $0
c010308b:	6a 00                	push   $0x0
  pushl $241
c010308d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103092:	e9 16 f6 ff ff       	jmp    c01026ad <__alltraps>

c0103097 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103097:	6a 00                	push   $0x0
  pushl $242
c0103099:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010309e:	e9 0a f6 ff ff       	jmp    c01026ad <__alltraps>

c01030a3 <vector243>:
.globl vector243
vector243:
  pushl $0
c01030a3:	6a 00                	push   $0x0
  pushl $243
c01030a5:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01030aa:	e9 fe f5 ff ff       	jmp    c01026ad <__alltraps>

c01030af <vector244>:
.globl vector244
vector244:
  pushl $0
c01030af:	6a 00                	push   $0x0
  pushl $244
c01030b1:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01030b6:	e9 f2 f5 ff ff       	jmp    c01026ad <__alltraps>

c01030bb <vector245>:
.globl vector245
vector245:
  pushl $0
c01030bb:	6a 00                	push   $0x0
  pushl $245
c01030bd:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01030c2:	e9 e6 f5 ff ff       	jmp    c01026ad <__alltraps>

c01030c7 <vector246>:
.globl vector246
vector246:
  pushl $0
c01030c7:	6a 00                	push   $0x0
  pushl $246
c01030c9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01030ce:	e9 da f5 ff ff       	jmp    c01026ad <__alltraps>

c01030d3 <vector247>:
.globl vector247
vector247:
  pushl $0
c01030d3:	6a 00                	push   $0x0
  pushl $247
c01030d5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01030da:	e9 ce f5 ff ff       	jmp    c01026ad <__alltraps>

c01030df <vector248>:
.globl vector248
vector248:
  pushl $0
c01030df:	6a 00                	push   $0x0
  pushl $248
c01030e1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01030e6:	e9 c2 f5 ff ff       	jmp    c01026ad <__alltraps>

c01030eb <vector249>:
.globl vector249
vector249:
  pushl $0
c01030eb:	6a 00                	push   $0x0
  pushl $249
c01030ed:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01030f2:	e9 b6 f5 ff ff       	jmp    c01026ad <__alltraps>

c01030f7 <vector250>:
.globl vector250
vector250:
  pushl $0
c01030f7:	6a 00                	push   $0x0
  pushl $250
c01030f9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01030fe:	e9 aa f5 ff ff       	jmp    c01026ad <__alltraps>

c0103103 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103103:	6a 00                	push   $0x0
  pushl $251
c0103105:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010310a:	e9 9e f5 ff ff       	jmp    c01026ad <__alltraps>

c010310f <vector252>:
.globl vector252
vector252:
  pushl $0
c010310f:	6a 00                	push   $0x0
  pushl $252
c0103111:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103116:	e9 92 f5 ff ff       	jmp    c01026ad <__alltraps>

c010311b <vector253>:
.globl vector253
vector253:
  pushl $0
c010311b:	6a 00                	push   $0x0
  pushl $253
c010311d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103122:	e9 86 f5 ff ff       	jmp    c01026ad <__alltraps>

c0103127 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103127:	6a 00                	push   $0x0
  pushl $254
c0103129:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010312e:	e9 7a f5 ff ff       	jmp    c01026ad <__alltraps>

c0103133 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103133:	6a 00                	push   $0x0
  pushl $255
c0103135:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010313a:	e9 6e f5 ff ff       	jmp    c01026ad <__alltraps>

c010313f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010313f:	55                   	push   %ebp
c0103140:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103142:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c0103148:	8b 45 08             	mov    0x8(%ebp),%eax
c010314b:	29 d0                	sub    %edx,%eax
c010314d:	c1 f8 05             	sar    $0x5,%eax
}
c0103150:	5d                   	pop    %ebp
c0103151:	c3                   	ret    

c0103152 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103152:	55                   	push   %ebp
c0103153:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0103155:	ff 75 08             	push   0x8(%ebp)
c0103158:	e8 e2 ff ff ff       	call   c010313f <page2ppn>
c010315d:	83 c4 04             	add    $0x4,%esp
c0103160:	c1 e0 0c             	shl    $0xc,%eax
}
c0103163:	c9                   	leave  
c0103164:	c3                   	ret    

c0103165 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103165:	55                   	push   %ebp
c0103166:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103168:	8b 45 08             	mov    0x8(%ebp),%eax
c010316b:	8b 00                	mov    (%eax),%eax
}
c010316d:	5d                   	pop    %ebp
c010316e:	c3                   	ret    

c010316f <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010316f:	55                   	push   %ebp
c0103170:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103172:	8b 45 08             	mov    0x8(%ebp),%eax
c0103175:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103178:	89 10                	mov    %edx,(%eax)
}
c010317a:	90                   	nop
c010317b:	5d                   	pop    %ebp
c010317c:	c3                   	ret    

c010317d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010317d:	55                   	push   %ebp
c010317e:	89 e5                	mov    %esp,%ebp
c0103180:	83 ec 10             	sub    $0x10,%esp
c0103183:	c7 45 fc 84 5f 12 c0 	movl   $0xc0125f84,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010318a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010318d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103190:	89 50 04             	mov    %edx,0x4(%eax)
c0103193:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103196:	8b 50 04             	mov    0x4(%eax),%edx
c0103199:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010319c:	89 10                	mov    %edx,(%eax)
}
c010319e:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c010319f:	c7 05 8c 5f 12 c0 00 	movl   $0x0,0xc0125f8c
c01031a6:	00 00 00 
}
c01031a9:	90                   	nop
c01031aa:	c9                   	leave  
c01031ab:	c3                   	ret    

c01031ac <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01031ac:	55                   	push   %ebp
c01031ad:	89 e5                	mov    %esp,%ebp
c01031af:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c01031b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01031b6:	75 16                	jne    c01031ce <default_init_memmap+0x22>
c01031b8:	68 f0 8b 10 c0       	push   $0xc0108bf0
c01031bd:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01031c2:	6a 6d                	push   $0x6d
c01031c4:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01031c9:	e8 d1 da ff ff       	call   c0100c9f <__panic>
    struct Page *p = base;
c01031ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01031d4:	eb 6c                	jmp    c0103242 <default_init_memmap+0x96>
        assert(PageReserved(p));
c01031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031d9:	83 c0 04             	add    $0x4,%eax
c01031dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01031e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01031ec:	0f a3 10             	bt     %edx,(%eax)
c01031ef:	19 c0                	sbb    %eax,%eax
c01031f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01031f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01031f8:	0f 95 c0             	setne  %al
c01031fb:	0f b6 c0             	movzbl %al,%eax
c01031fe:	85 c0                	test   %eax,%eax
c0103200:	75 16                	jne    c0103218 <default_init_memmap+0x6c>
c0103202:	68 21 8c 10 c0       	push   $0xc0108c21
c0103207:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010320c:	6a 70                	push   $0x70
c010320e:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103213:	e8 87 da ff ff       	call   c0100c9f <__panic>
        p->flags = p->property = 0;
c0103218:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010321b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103222:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103225:	8b 50 08             	mov    0x8(%eax),%edx
c0103228:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010322b:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010322e:	83 ec 08             	sub    $0x8,%esp
c0103231:	6a 00                	push   $0x0
c0103233:	ff 75 f4             	push   -0xc(%ebp)
c0103236:	e8 34 ff ff ff       	call   c010316f <set_page_ref>
c010323b:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c010323e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103242:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103245:	c1 e0 05             	shl    $0x5,%eax
c0103248:	89 c2                	mov    %eax,%edx
c010324a:	8b 45 08             	mov    0x8(%ebp),%eax
c010324d:	01 d0                	add    %edx,%eax
c010324f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103252:	75 82                	jne    c01031d6 <default_init_memmap+0x2a>
    }
    base->property = n;
c0103254:	8b 45 08             	mov    0x8(%ebp),%eax
c0103257:	8b 55 0c             	mov    0xc(%ebp),%edx
c010325a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010325d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103260:	83 c0 04             	add    $0x4,%eax
c0103263:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010326a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010326d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103270:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103273:	0f ab 10             	bts    %edx,(%eax)
}
c0103276:	90                   	nop
    nr_free += n;
c0103277:	8b 15 8c 5f 12 c0    	mov    0xc0125f8c,%edx
c010327d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103280:	01 d0                	add    %edx,%eax
c0103282:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c
    list_add_before(&free_list, &(base->page_link));
c0103287:	8b 45 08             	mov    0x8(%ebp),%eax
c010328a:	83 c0 0c             	add    $0xc,%eax
c010328d:	c7 45 e4 84 5f 12 c0 	movl   $0xc0125f84,-0x1c(%ebp)
c0103294:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010329a:	8b 00                	mov    (%eax),%eax
c010329c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010329f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01032a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01032a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01032ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01032ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032b1:	89 10                	mov    %edx,(%eax)
c01032b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01032b6:	8b 10                	mov    (%eax),%edx
c01032b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032bb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01032c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032c4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01032c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01032ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01032cd:	89 10                	mov    %edx,(%eax)
}
c01032cf:	90                   	nop
}
c01032d0:	90                   	nop
}
c01032d1:	90                   	nop
c01032d2:	c9                   	leave  
c01032d3:	c3                   	ret    

c01032d4 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01032d4:	55                   	push   %ebp
c01032d5:	89 e5                	mov    %esp,%ebp
c01032d7:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01032da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01032de:	75 16                	jne    c01032f6 <default_alloc_pages+0x22>
c01032e0:	68 f0 8b 10 c0       	push   $0xc0108bf0
c01032e5:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01032ea:	6a 7c                	push   $0x7c
c01032ec:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01032f1:	e8 a9 d9 ff ff       	call   c0100c9f <__panic>
    if (n > nr_free) {
c01032f6:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c01032fb:	39 45 08             	cmp    %eax,0x8(%ebp)
c01032fe:	76 0a                	jbe    c010330a <default_alloc_pages+0x36>
        return NULL;
c0103300:	b8 00 00 00 00       	mov    $0x0,%eax
c0103305:	e9 3c 01 00 00       	jmp    c0103446 <default_alloc_pages+0x172>
    }
    struct Page *page = NULL;
c010330a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103311:	c7 45 f0 84 5f 12 c0 	movl   $0xc0125f84,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0103318:	eb 1c                	jmp    c0103336 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c010331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010331d:	83 e8 0c             	sub    $0xc,%eax
c0103320:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103323:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103326:	8b 40 08             	mov    0x8(%eax),%eax
c0103329:	39 45 08             	cmp    %eax,0x8(%ebp)
c010332c:	77 08                	ja     c0103336 <default_alloc_pages+0x62>
            page = p;
c010332e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103331:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103334:	eb 18                	jmp    c010334e <default_alloc_pages+0x7a>
c0103336:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c010333c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010333f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103342:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103345:	81 7d f0 84 5f 12 c0 	cmpl   $0xc0125f84,-0x10(%ebp)
c010334c:	75 cc                	jne    c010331a <default_alloc_pages+0x46>
        }
    }
    if (page != NULL) {
c010334e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103352:	0f 84 eb 00 00 00    	je     c0103443 <default_alloc_pages+0x16f>
        if (page->property > n) {
c0103358:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010335b:	8b 40 08             	mov    0x8(%eax),%eax
c010335e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103361:	0f 83 88 00 00 00    	jae    c01033ef <default_alloc_pages+0x11b>
            struct Page *p = page + n;
c0103367:	8b 45 08             	mov    0x8(%ebp),%eax
c010336a:	c1 e0 05             	shl    $0x5,%eax
c010336d:	89 c2                	mov    %eax,%edx
c010336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103372:	01 d0                	add    %edx,%eax
c0103374:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103377:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337a:	8b 40 08             	mov    0x8(%eax),%eax
c010337d:	2b 45 08             	sub    0x8(%ebp),%eax
c0103380:	89 c2                	mov    %eax,%edx
c0103382:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103385:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0103388:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010338b:	83 c0 04             	add    $0x4,%eax
c010338e:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103395:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103398:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010339b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010339e:	0f ab 10             	bts    %edx,(%eax)
}
c01033a1:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c01033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033a5:	83 c0 0c             	add    $0xc,%eax
c01033a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033ab:	83 c2 0c             	add    $0xc,%edx
c01033ae:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01033b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c01033b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033b7:	8b 40 04             	mov    0x4(%eax),%eax
c01033ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033bd:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01033c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c01033c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01033cf:	89 10                	mov    %edx,(%eax)
c01033d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033d4:	8b 10                	mov    (%eax),%edx
c01033d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033d9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033df:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033e2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01033e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033eb:	89 10                	mov    %edx,(%eax)
}
c01033ed:	90                   	nop
}
c01033ee:	90                   	nop
        }
        list_del(&(page->page_link));
c01033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f2:	83 c0 0c             	add    $0xc,%eax
c01033f5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01033f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01033fb:	8b 40 04             	mov    0x4(%eax),%eax
c01033fe:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103401:	8b 12                	mov    (%edx),%edx
c0103403:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0103406:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103409:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010340c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010340f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103412:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103415:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103418:	89 10                	mov    %edx,(%eax)
}
c010341a:	90                   	nop
}
c010341b:	90                   	nop
        nr_free -= n;
c010341c:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c0103421:	2b 45 08             	sub    0x8(%ebp),%eax
c0103424:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c
        ClearPageProperty(page);
c0103429:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010342c:	83 c0 04             	add    $0x4,%eax
c010342f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103436:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103439:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010343c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010343f:	0f b3 10             	btr    %edx,(%eax)
}
c0103442:	90                   	nop
    }
    return page;
c0103443:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103446:	c9                   	leave  
c0103447:	c3                   	ret    

c0103448 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103448:	55                   	push   %ebp
c0103449:	89 e5                	mov    %esp,%ebp
c010344b:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0103451:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103455:	75 19                	jne    c0103470 <default_free_pages+0x28>
c0103457:	68 f0 8b 10 c0       	push   $0xc0108bf0
c010345c:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103461:	68 9a 00 00 00       	push   $0x9a
c0103466:	68 0b 8c 10 c0       	push   $0xc0108c0b
c010346b:	e8 2f d8 ff ff       	call   c0100c9f <__panic>
    struct Page *p = base;
c0103470:	8b 45 08             	mov    0x8(%ebp),%eax
c0103473:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103476:	e9 8f 00 00 00       	jmp    c010350a <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c010347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347e:	83 c0 04             	add    $0x4,%eax
c0103481:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103488:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010348e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103491:	0f a3 10             	bt     %edx,(%eax)
c0103494:	19 c0                	sbb    %eax,%eax
c0103496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103499:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010349d:	0f 95 c0             	setne  %al
c01034a0:	0f b6 c0             	movzbl %al,%eax
c01034a3:	85 c0                	test   %eax,%eax
c01034a5:	75 2c                	jne    c01034d3 <default_free_pages+0x8b>
c01034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034aa:	83 c0 04             	add    $0x4,%eax
c01034ad:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01034b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01034bd:	0f a3 10             	bt     %edx,(%eax)
c01034c0:	19 c0                	sbb    %eax,%eax
c01034c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01034c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01034c9:	0f 95 c0             	setne  %al
c01034cc:	0f b6 c0             	movzbl %al,%eax
c01034cf:	85 c0                	test   %eax,%eax
c01034d1:	74 19                	je     c01034ec <default_free_pages+0xa4>
c01034d3:	68 34 8c 10 c0       	push   $0xc0108c34
c01034d8:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01034dd:	68 9d 00 00 00       	push   $0x9d
c01034e2:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01034e7:	e8 b3 d7 ff ff       	call   c0100c9f <__panic>
        p->flags = 0;
c01034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01034f6:	83 ec 08             	sub    $0x8,%esp
c01034f9:	6a 00                	push   $0x0
c01034fb:	ff 75 f4             	push   -0xc(%ebp)
c01034fe:	e8 6c fc ff ff       	call   c010316f <set_page_ref>
c0103503:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0103506:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010350a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010350d:	c1 e0 05             	shl    $0x5,%eax
c0103510:	89 c2                	mov    %eax,%edx
c0103512:	8b 45 08             	mov    0x8(%ebp),%eax
c0103515:	01 d0                	add    %edx,%eax
c0103517:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010351a:	0f 85 5b ff ff ff    	jne    c010347b <default_free_pages+0x33>
    }
    base->property = n;
c0103520:	8b 45 08             	mov    0x8(%ebp),%eax
c0103523:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103526:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103529:	8b 45 08             	mov    0x8(%ebp),%eax
c010352c:	83 c0 04             	add    $0x4,%eax
c010352f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103536:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103539:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010353c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010353f:	0f ab 10             	bts    %edx,(%eax)
}
c0103542:	90                   	nop
c0103543:	c7 45 d4 84 5f 12 c0 	movl   $0xc0125f84,-0x2c(%ebp)
    return listelm->next;
c010354a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010354d:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103550:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103553:	e9 00 01 00 00       	jmp    c0103658 <default_free_pages+0x210>
        p = le2page(le, page_link);
c0103558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010355b:	83 e8 0c             	sub    $0xc,%eax
c010355e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103561:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103564:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103567:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010356a:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010356d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0103570:	8b 45 08             	mov    0x8(%ebp),%eax
c0103573:	8b 40 08             	mov    0x8(%eax),%eax
c0103576:	c1 e0 05             	shl    $0x5,%eax
c0103579:	89 c2                	mov    %eax,%edx
c010357b:	8b 45 08             	mov    0x8(%ebp),%eax
c010357e:	01 d0                	add    %edx,%eax
c0103580:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103583:	75 5d                	jne    c01035e2 <default_free_pages+0x19a>
            base->property += p->property;
c0103585:	8b 45 08             	mov    0x8(%ebp),%eax
c0103588:	8b 50 08             	mov    0x8(%eax),%edx
c010358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358e:	8b 40 08             	mov    0x8(%eax),%eax
c0103591:	01 c2                	add    %eax,%edx
c0103593:	8b 45 08             	mov    0x8(%ebp),%eax
c0103596:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103599:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359c:	83 c0 04             	add    $0x4,%eax
c010359f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01035a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035a9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035ac:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01035af:	0f b3 10             	btr    %edx,(%eax)
}
c01035b2:	90                   	nop
            list_del(&(p->page_link));
c01035b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b6:	83 c0 0c             	add    $0xc,%eax
c01035b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01035bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035bf:	8b 40 04             	mov    0x4(%eax),%eax
c01035c2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035c5:	8b 12                	mov    (%edx),%edx
c01035c7:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01035ca:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01035cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01035d0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01035d3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01035d9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01035dc:	89 10                	mov    %edx,(%eax)
}
c01035de:	90                   	nop
}
c01035df:	90                   	nop
c01035e0:	eb 76                	jmp    c0103658 <default_free_pages+0x210>
        }
        else if (p + p->property == base) {
c01035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e5:	8b 40 08             	mov    0x8(%eax),%eax
c01035e8:	c1 e0 05             	shl    $0x5,%eax
c01035eb:	89 c2                	mov    %eax,%edx
c01035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f0:	01 d0                	add    %edx,%eax
c01035f2:	39 45 08             	cmp    %eax,0x8(%ebp)
c01035f5:	75 61                	jne    c0103658 <default_free_pages+0x210>
            p->property += base->property;
c01035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fa:	8b 50 08             	mov    0x8(%eax),%edx
c01035fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103600:	8b 40 08             	mov    0x8(%eax),%eax
c0103603:	01 c2                	add    %eax,%edx
c0103605:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103608:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010360b:	8b 45 08             	mov    0x8(%ebp),%eax
c010360e:	83 c0 04             	add    $0x4,%eax
c0103611:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0103618:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010361b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010361e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103621:	0f b3 10             	btr    %edx,(%eax)
}
c0103624:	90                   	nop
            base = p;
c0103625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103628:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010362e:	83 c0 0c             	add    $0xc,%eax
c0103631:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103634:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103637:	8b 40 04             	mov    0x4(%eax),%eax
c010363a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010363d:	8b 12                	mov    (%edx),%edx
c010363f:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103642:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0103645:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103648:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010364b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010364e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103651:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103654:	89 10                	mov    %edx,(%eax)
}
c0103656:	90                   	nop
}
c0103657:	90                   	nop
    while (le != &free_list) {
c0103658:	81 7d f0 84 5f 12 c0 	cmpl   $0xc0125f84,-0x10(%ebp)
c010365f:	0f 85 f3 fe ff ff    	jne    c0103558 <default_free_pages+0x110>
        }
    }
    nr_free += n;
c0103665:	8b 15 8c 5f 12 c0    	mov    0xc0125f8c,%edx
c010366b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010366e:	01 d0                	add    %edx,%eax
c0103670:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c
c0103675:	c7 45 9c 84 5f 12 c0 	movl   $0xc0125f84,-0x64(%ebp)
    return listelm->next;
c010367c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010367f:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0103682:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103685:	eb 5b                	jmp    c01036e2 <default_free_pages+0x29a>
        p = le2page(le, page_link);
c0103687:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010368a:	83 e8 0c             	sub    $0xc,%eax
c010368d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0103690:	8b 45 08             	mov    0x8(%ebp),%eax
c0103693:	8b 40 08             	mov    0x8(%eax),%eax
c0103696:	c1 e0 05             	shl    $0x5,%eax
c0103699:	89 c2                	mov    %eax,%edx
c010369b:	8b 45 08             	mov    0x8(%ebp),%eax
c010369e:	01 d0                	add    %edx,%eax
c01036a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01036a3:	72 2e                	jb     c01036d3 <default_free_pages+0x28b>
            assert(base + base->property != p);
c01036a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a8:	8b 40 08             	mov    0x8(%eax),%eax
c01036ab:	c1 e0 05             	shl    $0x5,%eax
c01036ae:	89 c2                	mov    %eax,%edx
c01036b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b3:	01 d0                	add    %edx,%eax
c01036b5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01036b8:	75 33                	jne    c01036ed <default_free_pages+0x2a5>
c01036ba:	68 59 8c 10 c0       	push   $0xc0108c59
c01036bf:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01036c4:	68 b9 00 00 00       	push   $0xb9
c01036c9:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01036ce:	e8 cc d5 ff ff       	call   c0100c9f <__panic>
c01036d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01036d9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01036dc:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01036df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01036e2:	81 7d f0 84 5f 12 c0 	cmpl   $0xc0125f84,-0x10(%ebp)
c01036e9:	75 9c                	jne    c0103687 <default_free_pages+0x23f>
c01036eb:	eb 01                	jmp    c01036ee <default_free_pages+0x2a6>
            break;
c01036ed:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01036ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f1:	8d 50 0c             	lea    0xc(%eax),%edx
c01036f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01036fa:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01036fd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103700:	8b 00                	mov    (%eax),%eax
c0103702:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103705:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0103708:	89 45 88             	mov    %eax,-0x78(%ebp)
c010370b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010370e:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0103711:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103714:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103717:	89 10                	mov    %edx,(%eax)
c0103719:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010371c:	8b 10                	mov    (%eax),%edx
c010371e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103721:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103724:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103727:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010372a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010372d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103730:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103733:	89 10                	mov    %edx,(%eax)
}
c0103735:	90                   	nop
}
c0103736:	90                   	nop
}
c0103737:	90                   	nop
c0103738:	c9                   	leave  
c0103739:	c3                   	ret    

c010373a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010373a:	55                   	push   %ebp
c010373b:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010373d:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
}
c0103742:	5d                   	pop    %ebp
c0103743:	c3                   	ret    

c0103744 <basic_check>:

static void
basic_check(void) {
c0103744:	55                   	push   %ebp
c0103745:	89 e5                	mov    %esp,%ebp
c0103747:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010374a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103754:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103757:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010375d:	83 ec 0c             	sub    $0xc,%esp
c0103760:	6a 01                	push   $0x1
c0103762:	e8 05 0d 00 00       	call   c010446c <alloc_pages>
c0103767:	83 c4 10             	add    $0x10,%esp
c010376a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010376d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103771:	75 19                	jne    c010378c <basic_check+0x48>
c0103773:	68 74 8c 10 c0       	push   $0xc0108c74
c0103778:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010377d:	68 ca 00 00 00       	push   $0xca
c0103782:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103787:	e8 13 d5 ff ff       	call   c0100c9f <__panic>
    assert((p1 = alloc_page()) != NULL);
c010378c:	83 ec 0c             	sub    $0xc,%esp
c010378f:	6a 01                	push   $0x1
c0103791:	e8 d6 0c 00 00       	call   c010446c <alloc_pages>
c0103796:	83 c4 10             	add    $0x10,%esp
c0103799:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010379c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037a0:	75 19                	jne    c01037bb <basic_check+0x77>
c01037a2:	68 90 8c 10 c0       	push   $0xc0108c90
c01037a7:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01037ac:	68 cb 00 00 00       	push   $0xcb
c01037b1:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01037b6:	e8 e4 d4 ff ff       	call   c0100c9f <__panic>
    assert((p2 = alloc_page()) != NULL);
c01037bb:	83 ec 0c             	sub    $0xc,%esp
c01037be:	6a 01                	push   $0x1
c01037c0:	e8 a7 0c 00 00       	call   c010446c <alloc_pages>
c01037c5:	83 c4 10             	add    $0x10,%esp
c01037c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037cf:	75 19                	jne    c01037ea <basic_check+0xa6>
c01037d1:	68 ac 8c 10 c0       	push   $0xc0108cac
c01037d6:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01037db:	68 cc 00 00 00       	push   $0xcc
c01037e0:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01037e5:	e8 b5 d4 ff ff       	call   c0100c9f <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01037ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037f0:	74 10                	je     c0103802 <basic_check+0xbe>
c01037f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037f8:	74 08                	je     c0103802 <basic_check+0xbe>
c01037fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103800:	75 19                	jne    c010381b <basic_check+0xd7>
c0103802:	68 c8 8c 10 c0       	push   $0xc0108cc8
c0103807:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010380c:	68 ce 00 00 00       	push   $0xce
c0103811:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103816:	e8 84 d4 ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010381b:	83 ec 0c             	sub    $0xc,%esp
c010381e:	ff 75 ec             	push   -0x14(%ebp)
c0103821:	e8 3f f9 ff ff       	call   c0103165 <page_ref>
c0103826:	83 c4 10             	add    $0x10,%esp
c0103829:	85 c0                	test   %eax,%eax
c010382b:	75 24                	jne    c0103851 <basic_check+0x10d>
c010382d:	83 ec 0c             	sub    $0xc,%esp
c0103830:	ff 75 f0             	push   -0x10(%ebp)
c0103833:	e8 2d f9 ff ff       	call   c0103165 <page_ref>
c0103838:	83 c4 10             	add    $0x10,%esp
c010383b:	85 c0                	test   %eax,%eax
c010383d:	75 12                	jne    c0103851 <basic_check+0x10d>
c010383f:	83 ec 0c             	sub    $0xc,%esp
c0103842:	ff 75 f4             	push   -0xc(%ebp)
c0103845:	e8 1b f9 ff ff       	call   c0103165 <page_ref>
c010384a:	83 c4 10             	add    $0x10,%esp
c010384d:	85 c0                	test   %eax,%eax
c010384f:	74 19                	je     c010386a <basic_check+0x126>
c0103851:	68 ec 8c 10 c0       	push   $0xc0108cec
c0103856:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010385b:	68 cf 00 00 00       	push   $0xcf
c0103860:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103865:	e8 35 d4 ff ff       	call   c0100c9f <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010386a:	83 ec 0c             	sub    $0xc,%esp
c010386d:	ff 75 ec             	push   -0x14(%ebp)
c0103870:	e8 dd f8 ff ff       	call   c0103152 <page2pa>
c0103875:	83 c4 10             	add    $0x10,%esp
c0103878:	8b 15 a4 5f 12 c0    	mov    0xc0125fa4,%edx
c010387e:	c1 e2 0c             	shl    $0xc,%edx
c0103881:	39 d0                	cmp    %edx,%eax
c0103883:	72 19                	jb     c010389e <basic_check+0x15a>
c0103885:	68 28 8d 10 c0       	push   $0xc0108d28
c010388a:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010388f:	68 d1 00 00 00       	push   $0xd1
c0103894:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103899:	e8 01 d4 ff ff       	call   c0100c9f <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010389e:	83 ec 0c             	sub    $0xc,%esp
c01038a1:	ff 75 f0             	push   -0x10(%ebp)
c01038a4:	e8 a9 f8 ff ff       	call   c0103152 <page2pa>
c01038a9:	83 c4 10             	add    $0x10,%esp
c01038ac:	8b 15 a4 5f 12 c0    	mov    0xc0125fa4,%edx
c01038b2:	c1 e2 0c             	shl    $0xc,%edx
c01038b5:	39 d0                	cmp    %edx,%eax
c01038b7:	72 19                	jb     c01038d2 <basic_check+0x18e>
c01038b9:	68 45 8d 10 c0       	push   $0xc0108d45
c01038be:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01038c3:	68 d2 00 00 00       	push   $0xd2
c01038c8:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01038cd:	e8 cd d3 ff ff       	call   c0100c9f <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01038d2:	83 ec 0c             	sub    $0xc,%esp
c01038d5:	ff 75 f4             	push   -0xc(%ebp)
c01038d8:	e8 75 f8 ff ff       	call   c0103152 <page2pa>
c01038dd:	83 c4 10             	add    $0x10,%esp
c01038e0:	8b 15 a4 5f 12 c0    	mov    0xc0125fa4,%edx
c01038e6:	c1 e2 0c             	shl    $0xc,%edx
c01038e9:	39 d0                	cmp    %edx,%eax
c01038eb:	72 19                	jb     c0103906 <basic_check+0x1c2>
c01038ed:	68 62 8d 10 c0       	push   $0xc0108d62
c01038f2:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01038f7:	68 d3 00 00 00       	push   $0xd3
c01038fc:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103901:	e8 99 d3 ff ff       	call   c0100c9f <__panic>

    list_entry_t free_list_store = free_list;
c0103906:	a1 84 5f 12 c0       	mov    0xc0125f84,%eax
c010390b:	8b 15 88 5f 12 c0    	mov    0xc0125f88,%edx
c0103911:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103914:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103917:	c7 45 dc 84 5f 12 c0 	movl   $0xc0125f84,-0x24(%ebp)
    elm->prev = elm->next = elm;
c010391e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103921:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103924:	89 50 04             	mov    %edx,0x4(%eax)
c0103927:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010392a:	8b 50 04             	mov    0x4(%eax),%edx
c010392d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103930:	89 10                	mov    %edx,(%eax)
}
c0103932:	90                   	nop
c0103933:	c7 45 e0 84 5f 12 c0 	movl   $0xc0125f84,-0x20(%ebp)
    return list->next == list;
c010393a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010393d:	8b 40 04             	mov    0x4(%eax),%eax
c0103940:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103943:	0f 94 c0             	sete   %al
c0103946:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103949:	85 c0                	test   %eax,%eax
c010394b:	75 19                	jne    c0103966 <basic_check+0x222>
c010394d:	68 7f 8d 10 c0       	push   $0xc0108d7f
c0103952:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103957:	68 d7 00 00 00       	push   $0xd7
c010395c:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103961:	e8 39 d3 ff ff       	call   c0100c9f <__panic>

    unsigned int nr_free_store = nr_free;
c0103966:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c010396b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010396e:	c7 05 8c 5f 12 c0 00 	movl   $0x0,0xc0125f8c
c0103975:	00 00 00 

    assert(alloc_page() == NULL);
c0103978:	83 ec 0c             	sub    $0xc,%esp
c010397b:	6a 01                	push   $0x1
c010397d:	e8 ea 0a 00 00       	call   c010446c <alloc_pages>
c0103982:	83 c4 10             	add    $0x10,%esp
c0103985:	85 c0                	test   %eax,%eax
c0103987:	74 19                	je     c01039a2 <basic_check+0x25e>
c0103989:	68 96 8d 10 c0       	push   $0xc0108d96
c010398e:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103993:	68 dc 00 00 00       	push   $0xdc
c0103998:	68 0b 8c 10 c0       	push   $0xc0108c0b
c010399d:	e8 fd d2 ff ff       	call   c0100c9f <__panic>

    free_page(p0);
c01039a2:	83 ec 08             	sub    $0x8,%esp
c01039a5:	6a 01                	push   $0x1
c01039a7:	ff 75 ec             	push   -0x14(%ebp)
c01039aa:	e8 29 0b 00 00       	call   c01044d8 <free_pages>
c01039af:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01039b2:	83 ec 08             	sub    $0x8,%esp
c01039b5:	6a 01                	push   $0x1
c01039b7:	ff 75 f0             	push   -0x10(%ebp)
c01039ba:	e8 19 0b 00 00       	call   c01044d8 <free_pages>
c01039bf:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01039c2:	83 ec 08             	sub    $0x8,%esp
c01039c5:	6a 01                	push   $0x1
c01039c7:	ff 75 f4             	push   -0xc(%ebp)
c01039ca:	e8 09 0b 00 00       	call   c01044d8 <free_pages>
c01039cf:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01039d2:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c01039d7:	83 f8 03             	cmp    $0x3,%eax
c01039da:	74 19                	je     c01039f5 <basic_check+0x2b1>
c01039dc:	68 ab 8d 10 c0       	push   $0xc0108dab
c01039e1:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01039e6:	68 e1 00 00 00       	push   $0xe1
c01039eb:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01039f0:	e8 aa d2 ff ff       	call   c0100c9f <__panic>

    assert((p0 = alloc_page()) != NULL);
c01039f5:	83 ec 0c             	sub    $0xc,%esp
c01039f8:	6a 01                	push   $0x1
c01039fa:	e8 6d 0a 00 00       	call   c010446c <alloc_pages>
c01039ff:	83 c4 10             	add    $0x10,%esp
c0103a02:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a09:	75 19                	jne    c0103a24 <basic_check+0x2e0>
c0103a0b:	68 74 8c 10 c0       	push   $0xc0108c74
c0103a10:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103a15:	68 e3 00 00 00       	push   $0xe3
c0103a1a:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103a1f:	e8 7b d2 ff ff       	call   c0100c9f <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a24:	83 ec 0c             	sub    $0xc,%esp
c0103a27:	6a 01                	push   $0x1
c0103a29:	e8 3e 0a 00 00       	call   c010446c <alloc_pages>
c0103a2e:	83 c4 10             	add    $0x10,%esp
c0103a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a38:	75 19                	jne    c0103a53 <basic_check+0x30f>
c0103a3a:	68 90 8c 10 c0       	push   $0xc0108c90
c0103a3f:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103a44:	68 e4 00 00 00       	push   $0xe4
c0103a49:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103a4e:	e8 4c d2 ff ff       	call   c0100c9f <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103a53:	83 ec 0c             	sub    $0xc,%esp
c0103a56:	6a 01                	push   $0x1
c0103a58:	e8 0f 0a 00 00       	call   c010446c <alloc_pages>
c0103a5d:	83 c4 10             	add    $0x10,%esp
c0103a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a67:	75 19                	jne    c0103a82 <basic_check+0x33e>
c0103a69:	68 ac 8c 10 c0       	push   $0xc0108cac
c0103a6e:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103a73:	68 e5 00 00 00       	push   $0xe5
c0103a78:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103a7d:	e8 1d d2 ff ff       	call   c0100c9f <__panic>

    assert(alloc_page() == NULL);
c0103a82:	83 ec 0c             	sub    $0xc,%esp
c0103a85:	6a 01                	push   $0x1
c0103a87:	e8 e0 09 00 00       	call   c010446c <alloc_pages>
c0103a8c:	83 c4 10             	add    $0x10,%esp
c0103a8f:	85 c0                	test   %eax,%eax
c0103a91:	74 19                	je     c0103aac <basic_check+0x368>
c0103a93:	68 96 8d 10 c0       	push   $0xc0108d96
c0103a98:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103a9d:	68 e7 00 00 00       	push   $0xe7
c0103aa2:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103aa7:	e8 f3 d1 ff ff       	call   c0100c9f <__panic>

    free_page(p0);
c0103aac:	83 ec 08             	sub    $0x8,%esp
c0103aaf:	6a 01                	push   $0x1
c0103ab1:	ff 75 ec             	push   -0x14(%ebp)
c0103ab4:	e8 1f 0a 00 00       	call   c01044d8 <free_pages>
c0103ab9:	83 c4 10             	add    $0x10,%esp
c0103abc:	c7 45 d8 84 5f 12 c0 	movl   $0xc0125f84,-0x28(%ebp)
c0103ac3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ac6:	8b 40 04             	mov    0x4(%eax),%eax
c0103ac9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103acc:	0f 94 c0             	sete   %al
c0103acf:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103ad2:	85 c0                	test   %eax,%eax
c0103ad4:	74 19                	je     c0103aef <basic_check+0x3ab>
c0103ad6:	68 b8 8d 10 c0       	push   $0xc0108db8
c0103adb:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103ae0:	68 ea 00 00 00       	push   $0xea
c0103ae5:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103aea:	e8 b0 d1 ff ff       	call   c0100c9f <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103aef:	83 ec 0c             	sub    $0xc,%esp
c0103af2:	6a 01                	push   $0x1
c0103af4:	e8 73 09 00 00       	call   c010446c <alloc_pages>
c0103af9:	83 c4 10             	add    $0x10,%esp
c0103afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b05:	74 19                	je     c0103b20 <basic_check+0x3dc>
c0103b07:	68 d0 8d 10 c0       	push   $0xc0108dd0
c0103b0c:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103b11:	68 ed 00 00 00       	push   $0xed
c0103b16:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103b1b:	e8 7f d1 ff ff       	call   c0100c9f <__panic>
    assert(alloc_page() == NULL);
c0103b20:	83 ec 0c             	sub    $0xc,%esp
c0103b23:	6a 01                	push   $0x1
c0103b25:	e8 42 09 00 00       	call   c010446c <alloc_pages>
c0103b2a:	83 c4 10             	add    $0x10,%esp
c0103b2d:	85 c0                	test   %eax,%eax
c0103b2f:	74 19                	je     c0103b4a <basic_check+0x406>
c0103b31:	68 96 8d 10 c0       	push   $0xc0108d96
c0103b36:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103b3b:	68 ee 00 00 00       	push   $0xee
c0103b40:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103b45:	e8 55 d1 ff ff       	call   c0100c9f <__panic>

    assert(nr_free == 0);
c0103b4a:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c0103b4f:	85 c0                	test   %eax,%eax
c0103b51:	74 19                	je     c0103b6c <basic_check+0x428>
c0103b53:	68 e9 8d 10 c0       	push   $0xc0108de9
c0103b58:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103b5d:	68 f0 00 00 00       	push   $0xf0
c0103b62:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103b67:	e8 33 d1 ff ff       	call   c0100c9f <__panic>
    free_list = free_list_store;
c0103b6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103b6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103b72:	a3 84 5f 12 c0       	mov    %eax,0xc0125f84
c0103b77:	89 15 88 5f 12 c0    	mov    %edx,0xc0125f88
    nr_free = nr_free_store;
c0103b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b80:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c

    free_page(p);
c0103b85:	83 ec 08             	sub    $0x8,%esp
c0103b88:	6a 01                	push   $0x1
c0103b8a:	ff 75 e4             	push   -0x1c(%ebp)
c0103b8d:	e8 46 09 00 00       	call   c01044d8 <free_pages>
c0103b92:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0103b95:	83 ec 08             	sub    $0x8,%esp
c0103b98:	6a 01                	push   $0x1
c0103b9a:	ff 75 f0             	push   -0x10(%ebp)
c0103b9d:	e8 36 09 00 00       	call   c01044d8 <free_pages>
c0103ba2:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103ba5:	83 ec 08             	sub    $0x8,%esp
c0103ba8:	6a 01                	push   $0x1
c0103baa:	ff 75 f4             	push   -0xc(%ebp)
c0103bad:	e8 26 09 00 00       	call   c01044d8 <free_pages>
c0103bb2:	83 c4 10             	add    $0x10,%esp
}
c0103bb5:	90                   	nop
c0103bb6:	c9                   	leave  
c0103bb7:	c3                   	ret    

c0103bb8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103bb8:	55                   	push   %ebp
c0103bb9:	89 e5                	mov    %esp,%ebp
c0103bbb:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0103bc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103bc8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103bcf:	c7 45 ec 84 5f 12 c0 	movl   $0xc0125f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103bd6:	eb 60                	jmp    c0103c38 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0103bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bdb:	83 e8 0c             	sub    $0xc,%eax
c0103bde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103be1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103be4:	83 c0 04             	add    $0x4,%eax
c0103be7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103bee:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103bf4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103bf7:	0f a3 10             	bt     %edx,(%eax)
c0103bfa:	19 c0                	sbb    %eax,%eax
c0103bfc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103bff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103c03:	0f 95 c0             	setne  %al
c0103c06:	0f b6 c0             	movzbl %al,%eax
c0103c09:	85 c0                	test   %eax,%eax
c0103c0b:	75 19                	jne    c0103c26 <default_check+0x6e>
c0103c0d:	68 f6 8d 10 c0       	push   $0xc0108df6
c0103c12:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103c17:	68 01 01 00 00       	push   $0x101
c0103c1c:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103c21:	e8 79 d0 ff ff       	call   c0100c9f <__panic>
        count ++, total += p->property;
c0103c26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103c2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103c2d:	8b 50 08             	mov    0x8(%eax),%edx
c0103c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c33:	01 d0                	add    %edx,%eax
c0103c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c3b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103c3e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103c41:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103c44:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c47:	81 7d ec 84 5f 12 c0 	cmpl   $0xc0125f84,-0x14(%ebp)
c0103c4e:	75 88                	jne    c0103bd8 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0103c50:	e8 b8 08 00 00       	call   c010450d <nr_free_pages>
c0103c55:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103c58:	39 d0                	cmp    %edx,%eax
c0103c5a:	74 19                	je     c0103c75 <default_check+0xbd>
c0103c5c:	68 06 8e 10 c0       	push   $0xc0108e06
c0103c61:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103c66:	68 04 01 00 00       	push   $0x104
c0103c6b:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103c70:	e8 2a d0 ff ff       	call   c0100c9f <__panic>

    basic_check();
c0103c75:	e8 ca fa ff ff       	call   c0103744 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103c7a:	83 ec 0c             	sub    $0xc,%esp
c0103c7d:	6a 05                	push   $0x5
c0103c7f:	e8 e8 07 00 00       	call   c010446c <alloc_pages>
c0103c84:	83 c4 10             	add    $0x10,%esp
c0103c87:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103c8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103c8e:	75 19                	jne    c0103ca9 <default_check+0xf1>
c0103c90:	68 1f 8e 10 c0       	push   $0xc0108e1f
c0103c95:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103c9a:	68 09 01 00 00       	push   $0x109
c0103c9f:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103ca4:	e8 f6 cf ff ff       	call   c0100c9f <__panic>
    assert(!PageProperty(p0));
c0103ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cac:	83 c0 04             	add    $0x4,%eax
c0103caf:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103cb6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cb9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103cbc:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103cbf:	0f a3 10             	bt     %edx,(%eax)
c0103cc2:	19 c0                	sbb    %eax,%eax
c0103cc4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103cc7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ccb:	0f 95 c0             	setne  %al
c0103cce:	0f b6 c0             	movzbl %al,%eax
c0103cd1:	85 c0                	test   %eax,%eax
c0103cd3:	74 19                	je     c0103cee <default_check+0x136>
c0103cd5:	68 2a 8e 10 c0       	push   $0xc0108e2a
c0103cda:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103cdf:	68 0a 01 00 00       	push   $0x10a
c0103ce4:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103ce9:	e8 b1 cf ff ff       	call   c0100c9f <__panic>

    list_entry_t free_list_store = free_list;
c0103cee:	a1 84 5f 12 c0       	mov    0xc0125f84,%eax
c0103cf3:	8b 15 88 5f 12 c0    	mov    0xc0125f88,%edx
c0103cf9:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103cfc:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103cff:	c7 45 b0 84 5f 12 c0 	movl   $0xc0125f84,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0103d06:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d09:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103d0c:	89 50 04             	mov    %edx,0x4(%eax)
c0103d0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d12:	8b 50 04             	mov    0x4(%eax),%edx
c0103d15:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d18:	89 10                	mov    %edx,(%eax)
}
c0103d1a:	90                   	nop
c0103d1b:	c7 45 b4 84 5f 12 c0 	movl   $0xc0125f84,-0x4c(%ebp)
    return list->next == list;
c0103d22:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103d25:	8b 40 04             	mov    0x4(%eax),%eax
c0103d28:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103d2b:	0f 94 c0             	sete   %al
c0103d2e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103d31:	85 c0                	test   %eax,%eax
c0103d33:	75 19                	jne    c0103d4e <default_check+0x196>
c0103d35:	68 7f 8d 10 c0       	push   $0xc0108d7f
c0103d3a:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103d3f:	68 0e 01 00 00       	push   $0x10e
c0103d44:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103d49:	e8 51 cf ff ff       	call   c0100c9f <__panic>
    assert(alloc_page() == NULL);
c0103d4e:	83 ec 0c             	sub    $0xc,%esp
c0103d51:	6a 01                	push   $0x1
c0103d53:	e8 14 07 00 00       	call   c010446c <alloc_pages>
c0103d58:	83 c4 10             	add    $0x10,%esp
c0103d5b:	85 c0                	test   %eax,%eax
c0103d5d:	74 19                	je     c0103d78 <default_check+0x1c0>
c0103d5f:	68 96 8d 10 c0       	push   $0xc0108d96
c0103d64:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103d69:	68 0f 01 00 00       	push   $0x10f
c0103d6e:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103d73:	e8 27 cf ff ff       	call   c0100c9f <__panic>

    unsigned int nr_free_store = nr_free;
c0103d78:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c0103d7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103d80:	c7 05 8c 5f 12 c0 00 	movl   $0x0,0xc0125f8c
c0103d87:	00 00 00 

    free_pages(p0 + 2, 3);
c0103d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d8d:	83 c0 40             	add    $0x40,%eax
c0103d90:	83 ec 08             	sub    $0x8,%esp
c0103d93:	6a 03                	push   $0x3
c0103d95:	50                   	push   %eax
c0103d96:	e8 3d 07 00 00       	call   c01044d8 <free_pages>
c0103d9b:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0103d9e:	83 ec 0c             	sub    $0xc,%esp
c0103da1:	6a 04                	push   $0x4
c0103da3:	e8 c4 06 00 00       	call   c010446c <alloc_pages>
c0103da8:	83 c4 10             	add    $0x10,%esp
c0103dab:	85 c0                	test   %eax,%eax
c0103dad:	74 19                	je     c0103dc8 <default_check+0x210>
c0103daf:	68 3c 8e 10 c0       	push   $0xc0108e3c
c0103db4:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103db9:	68 15 01 00 00       	push   $0x115
c0103dbe:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103dc3:	e8 d7 ce ff ff       	call   c0100c9f <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dcb:	83 c0 40             	add    $0x40,%eax
c0103dce:	83 c0 04             	add    $0x4,%eax
c0103dd1:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103dd8:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ddb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103dde:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103de1:	0f a3 10             	bt     %edx,(%eax)
c0103de4:	19 c0                	sbb    %eax,%eax
c0103de6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103de9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103ded:	0f 95 c0             	setne  %al
c0103df0:	0f b6 c0             	movzbl %al,%eax
c0103df3:	85 c0                	test   %eax,%eax
c0103df5:	74 0e                	je     c0103e05 <default_check+0x24d>
c0103df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dfa:	83 c0 40             	add    $0x40,%eax
c0103dfd:	8b 40 08             	mov    0x8(%eax),%eax
c0103e00:	83 f8 03             	cmp    $0x3,%eax
c0103e03:	74 19                	je     c0103e1e <default_check+0x266>
c0103e05:	68 54 8e 10 c0       	push   $0xc0108e54
c0103e0a:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103e0f:	68 16 01 00 00       	push   $0x116
c0103e14:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103e19:	e8 81 ce ff ff       	call   c0100c9f <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103e1e:	83 ec 0c             	sub    $0xc,%esp
c0103e21:	6a 03                	push   $0x3
c0103e23:	e8 44 06 00 00       	call   c010446c <alloc_pages>
c0103e28:	83 c4 10             	add    $0x10,%esp
c0103e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103e32:	75 19                	jne    c0103e4d <default_check+0x295>
c0103e34:	68 80 8e 10 c0       	push   $0xc0108e80
c0103e39:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103e3e:	68 17 01 00 00       	push   $0x117
c0103e43:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103e48:	e8 52 ce ff ff       	call   c0100c9f <__panic>
    assert(alloc_page() == NULL);
c0103e4d:	83 ec 0c             	sub    $0xc,%esp
c0103e50:	6a 01                	push   $0x1
c0103e52:	e8 15 06 00 00       	call   c010446c <alloc_pages>
c0103e57:	83 c4 10             	add    $0x10,%esp
c0103e5a:	85 c0                	test   %eax,%eax
c0103e5c:	74 19                	je     c0103e77 <default_check+0x2bf>
c0103e5e:	68 96 8d 10 c0       	push   $0xc0108d96
c0103e63:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103e68:	68 18 01 00 00       	push   $0x118
c0103e6d:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103e72:	e8 28 ce ff ff       	call   c0100c9f <__panic>
    assert(p0 + 2 == p1);
c0103e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e7a:	83 c0 40             	add    $0x40,%eax
c0103e7d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103e80:	74 19                	je     c0103e9b <default_check+0x2e3>
c0103e82:	68 9e 8e 10 c0       	push   $0xc0108e9e
c0103e87:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103e8c:	68 19 01 00 00       	push   $0x119
c0103e91:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103e96:	e8 04 ce ff ff       	call   c0100c9f <__panic>

    p2 = p0 + 1;
c0103e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e9e:	83 c0 20             	add    $0x20,%eax
c0103ea1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0103ea4:	83 ec 08             	sub    $0x8,%esp
c0103ea7:	6a 01                	push   $0x1
c0103ea9:	ff 75 e8             	push   -0x18(%ebp)
c0103eac:	e8 27 06 00 00       	call   c01044d8 <free_pages>
c0103eb1:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0103eb4:	83 ec 08             	sub    $0x8,%esp
c0103eb7:	6a 03                	push   $0x3
c0103eb9:	ff 75 e0             	push   -0x20(%ebp)
c0103ebc:	e8 17 06 00 00       	call   c01044d8 <free_pages>
c0103ec1:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0103ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ec7:	83 c0 04             	add    $0x4,%eax
c0103eca:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103ed1:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ed4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103ed7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103eda:	0f a3 10             	bt     %edx,(%eax)
c0103edd:	19 c0                	sbb    %eax,%eax
c0103edf:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103ee2:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103ee6:	0f 95 c0             	setne  %al
c0103ee9:	0f b6 c0             	movzbl %al,%eax
c0103eec:	85 c0                	test   %eax,%eax
c0103eee:	74 0b                	je     c0103efb <default_check+0x343>
c0103ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ef3:	8b 40 08             	mov    0x8(%eax),%eax
c0103ef6:	83 f8 01             	cmp    $0x1,%eax
c0103ef9:	74 19                	je     c0103f14 <default_check+0x35c>
c0103efb:	68 ac 8e 10 c0       	push   $0xc0108eac
c0103f00:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103f05:	68 1e 01 00 00       	push   $0x11e
c0103f0a:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103f0f:	e8 8b cd ff ff       	call   c0100c9f <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103f14:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f17:	83 c0 04             	add    $0x4,%eax
c0103f1a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103f21:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f24:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103f27:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103f2a:	0f a3 10             	bt     %edx,(%eax)
c0103f2d:	19 c0                	sbb    %eax,%eax
c0103f2f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103f32:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103f36:	0f 95 c0             	setne  %al
c0103f39:	0f b6 c0             	movzbl %al,%eax
c0103f3c:	85 c0                	test   %eax,%eax
c0103f3e:	74 0b                	je     c0103f4b <default_check+0x393>
c0103f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f43:	8b 40 08             	mov    0x8(%eax),%eax
c0103f46:	83 f8 03             	cmp    $0x3,%eax
c0103f49:	74 19                	je     c0103f64 <default_check+0x3ac>
c0103f4b:	68 d4 8e 10 c0       	push   $0xc0108ed4
c0103f50:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103f55:	68 1f 01 00 00       	push   $0x11f
c0103f5a:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103f5f:	e8 3b cd ff ff       	call   c0100c9f <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103f64:	83 ec 0c             	sub    $0xc,%esp
c0103f67:	6a 01                	push   $0x1
c0103f69:	e8 fe 04 00 00       	call   c010446c <alloc_pages>
c0103f6e:	83 c4 10             	add    $0x10,%esp
c0103f71:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f77:	83 e8 20             	sub    $0x20,%eax
c0103f7a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103f7d:	74 19                	je     c0103f98 <default_check+0x3e0>
c0103f7f:	68 fa 8e 10 c0       	push   $0xc0108efa
c0103f84:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103f89:	68 21 01 00 00       	push   $0x121
c0103f8e:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103f93:	e8 07 cd ff ff       	call   c0100c9f <__panic>
    free_page(p0);
c0103f98:	83 ec 08             	sub    $0x8,%esp
c0103f9b:	6a 01                	push   $0x1
c0103f9d:	ff 75 e8             	push   -0x18(%ebp)
c0103fa0:	e8 33 05 00 00       	call   c01044d8 <free_pages>
c0103fa5:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103fa8:	83 ec 0c             	sub    $0xc,%esp
c0103fab:	6a 02                	push   $0x2
c0103fad:	e8 ba 04 00 00       	call   c010446c <alloc_pages>
c0103fb2:	83 c4 10             	add    $0x10,%esp
c0103fb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103fb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103fbb:	83 c0 20             	add    $0x20,%eax
c0103fbe:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103fc1:	74 19                	je     c0103fdc <default_check+0x424>
c0103fc3:	68 18 8f 10 c0       	push   $0xc0108f18
c0103fc8:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0103fcd:	68 23 01 00 00       	push   $0x123
c0103fd2:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0103fd7:	e8 c3 cc ff ff       	call   c0100c9f <__panic>

    free_pages(p0, 2);
c0103fdc:	83 ec 08             	sub    $0x8,%esp
c0103fdf:	6a 02                	push   $0x2
c0103fe1:	ff 75 e8             	push   -0x18(%ebp)
c0103fe4:	e8 ef 04 00 00       	call   c01044d8 <free_pages>
c0103fe9:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103fec:	83 ec 08             	sub    $0x8,%esp
c0103fef:	6a 01                	push   $0x1
c0103ff1:	ff 75 dc             	push   -0x24(%ebp)
c0103ff4:	e8 df 04 00 00       	call   c01044d8 <free_pages>
c0103ff9:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0103ffc:	83 ec 0c             	sub    $0xc,%esp
c0103fff:	6a 05                	push   $0x5
c0104001:	e8 66 04 00 00       	call   c010446c <alloc_pages>
c0104006:	83 c4 10             	add    $0x10,%esp
c0104009:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010400c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104010:	75 19                	jne    c010402b <default_check+0x473>
c0104012:	68 38 8f 10 c0       	push   $0xc0108f38
c0104017:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010401c:	68 28 01 00 00       	push   $0x128
c0104021:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0104026:	e8 74 cc ff ff       	call   c0100c9f <__panic>
    assert(alloc_page() == NULL);
c010402b:	83 ec 0c             	sub    $0xc,%esp
c010402e:	6a 01                	push   $0x1
c0104030:	e8 37 04 00 00       	call   c010446c <alloc_pages>
c0104035:	83 c4 10             	add    $0x10,%esp
c0104038:	85 c0                	test   %eax,%eax
c010403a:	74 19                	je     c0104055 <default_check+0x49d>
c010403c:	68 96 8d 10 c0       	push   $0xc0108d96
c0104041:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0104046:	68 29 01 00 00       	push   $0x129
c010404b:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0104050:	e8 4a cc ff ff       	call   c0100c9f <__panic>

    assert(nr_free == 0);
c0104055:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c010405a:	85 c0                	test   %eax,%eax
c010405c:	74 19                	je     c0104077 <default_check+0x4bf>
c010405e:	68 e9 8d 10 c0       	push   $0xc0108de9
c0104063:	68 f6 8b 10 c0       	push   $0xc0108bf6
c0104068:	68 2b 01 00 00       	push   $0x12b
c010406d:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0104072:	e8 28 cc ff ff       	call   c0100c9f <__panic>
    nr_free = nr_free_store;
c0104077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010407a:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c

    free_list = free_list_store;
c010407f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104082:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104085:	a3 84 5f 12 c0       	mov    %eax,0xc0125f84
c010408a:	89 15 88 5f 12 c0    	mov    %edx,0xc0125f88
    free_pages(p0, 5);
c0104090:	83 ec 08             	sub    $0x8,%esp
c0104093:	6a 05                	push   $0x5
c0104095:	ff 75 e8             	push   -0x18(%ebp)
c0104098:	e8 3b 04 00 00       	call   c01044d8 <free_pages>
c010409d:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01040a0:	c7 45 ec 84 5f 12 c0 	movl   $0xc0125f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01040a7:	eb 1d                	jmp    c01040c6 <default_check+0x50e>
        struct Page *p = le2page(le, page_link);
c01040a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040ac:	83 e8 0c             	sub    $0xc,%eax
c01040af:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01040b2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01040b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01040b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040bc:	8b 48 08             	mov    0x8(%eax),%ecx
c01040bf:	89 d0                	mov    %edx,%eax
c01040c1:	29 c8                	sub    %ecx,%eax
c01040c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040c9:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01040cc:	8b 45 88             	mov    -0x78(%ebp),%eax
c01040cf:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01040d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040d5:	81 7d ec 84 5f 12 c0 	cmpl   $0xc0125f84,-0x14(%ebp)
c01040dc:	75 cb                	jne    c01040a9 <default_check+0x4f1>
    }
    assert(count == 0);
c01040de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040e2:	74 19                	je     c01040fd <default_check+0x545>
c01040e4:	68 56 8f 10 c0       	push   $0xc0108f56
c01040e9:	68 f6 8b 10 c0       	push   $0xc0108bf6
c01040ee:	68 36 01 00 00       	push   $0x136
c01040f3:	68 0b 8c 10 c0       	push   $0xc0108c0b
c01040f8:	e8 a2 cb ff ff       	call   c0100c9f <__panic>
    assert(total == 0);
c01040fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104101:	74 19                	je     c010411c <default_check+0x564>
c0104103:	68 61 8f 10 c0       	push   $0xc0108f61
c0104108:	68 f6 8b 10 c0       	push   $0xc0108bf6
c010410d:	68 37 01 00 00       	push   $0x137
c0104112:	68 0b 8c 10 c0       	push   $0xc0108c0b
c0104117:	e8 83 cb ff ff       	call   c0100c9f <__panic>
}
c010411c:	90                   	nop
c010411d:	c9                   	leave  
c010411e:	c3                   	ret    

c010411f <page2ppn>:
page2ppn(struct Page *page) {
c010411f:	55                   	push   %ebp
c0104120:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104122:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c0104128:	8b 45 08             	mov    0x8(%ebp),%eax
c010412b:	29 d0                	sub    %edx,%eax
c010412d:	c1 f8 05             	sar    $0x5,%eax
}
c0104130:	5d                   	pop    %ebp
c0104131:	c3                   	ret    

c0104132 <page2pa>:
page2pa(struct Page *page) {
c0104132:	55                   	push   %ebp
c0104133:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104135:	ff 75 08             	push   0x8(%ebp)
c0104138:	e8 e2 ff ff ff       	call   c010411f <page2ppn>
c010413d:	83 c4 04             	add    $0x4,%esp
c0104140:	c1 e0 0c             	shl    $0xc,%eax
}
c0104143:	c9                   	leave  
c0104144:	c3                   	ret    

c0104145 <pa2page>:
pa2page(uintptr_t pa) {
c0104145:	55                   	push   %ebp
c0104146:	89 e5                	mov    %esp,%ebp
c0104148:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010414b:	8b 45 08             	mov    0x8(%ebp),%eax
c010414e:	c1 e8 0c             	shr    $0xc,%eax
c0104151:	89 c2                	mov    %eax,%edx
c0104153:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0104158:	39 c2                	cmp    %eax,%edx
c010415a:	72 14                	jb     c0104170 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010415c:	83 ec 04             	sub    $0x4,%esp
c010415f:	68 9c 8f 10 c0       	push   $0xc0108f9c
c0104164:	6a 5b                	push   $0x5b
c0104166:	68 bb 8f 10 c0       	push   $0xc0108fbb
c010416b:	e8 2f cb ff ff       	call   c0100c9f <__panic>
    return &pages[PPN(pa)];
c0104170:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c0104176:	8b 45 08             	mov    0x8(%ebp),%eax
c0104179:	c1 e8 0c             	shr    $0xc,%eax
c010417c:	c1 e0 05             	shl    $0x5,%eax
c010417f:	01 d0                	add    %edx,%eax
}
c0104181:	c9                   	leave  
c0104182:	c3                   	ret    

c0104183 <page2kva>:
page2kva(struct Page *page) {
c0104183:	55                   	push   %ebp
c0104184:	89 e5                	mov    %esp,%ebp
c0104186:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0104189:	ff 75 08             	push   0x8(%ebp)
c010418c:	e8 a1 ff ff ff       	call   c0104132 <page2pa>
c0104191:	83 c4 04             	add    $0x4,%esp
c0104194:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010419a:	c1 e8 0c             	shr    $0xc,%eax
c010419d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041a0:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c01041a5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01041a8:	72 14                	jb     c01041be <page2kva+0x3b>
c01041aa:	ff 75 f4             	push   -0xc(%ebp)
c01041ad:	68 cc 8f 10 c0       	push   $0xc0108fcc
c01041b2:	6a 62                	push   $0x62
c01041b4:	68 bb 8f 10 c0       	push   $0xc0108fbb
c01041b9:	e8 e1 ca ff ff       	call   c0100c9f <__panic>
c01041be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041c1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01041c6:	c9                   	leave  
c01041c7:	c3                   	ret    

c01041c8 <kva2page>:
kva2page(void *kva) {
c01041c8:	55                   	push   %ebp
c01041c9:	89 e5                	mov    %esp,%ebp
c01041cb:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PADDR(kva));
c01041ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01041d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01041d4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01041db:	77 14                	ja     c01041f1 <kva2page+0x29>
c01041dd:	ff 75 f4             	push   -0xc(%ebp)
c01041e0:	68 f0 8f 10 c0       	push   $0xc0108ff0
c01041e5:	6a 67                	push   $0x67
c01041e7:	68 bb 8f 10 c0       	push   $0xc0108fbb
c01041ec:	e8 ae ca ff ff       	call   c0100c9f <__panic>
c01041f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f4:	05 00 00 00 40       	add    $0x40000000,%eax
c01041f9:	83 ec 0c             	sub    $0xc,%esp
c01041fc:	50                   	push   %eax
c01041fd:	e8 43 ff ff ff       	call   c0104145 <pa2page>
c0104202:	83 c4 10             	add    $0x10,%esp
}
c0104205:	c9                   	leave  
c0104206:	c3                   	ret    

c0104207 <pte2page>:
pte2page(pte_t pte) {
c0104207:	55                   	push   %ebp
c0104208:	89 e5                	mov    %esp,%ebp
c010420a:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010420d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104210:	83 e0 01             	and    $0x1,%eax
c0104213:	85 c0                	test   %eax,%eax
c0104215:	75 14                	jne    c010422b <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0104217:	83 ec 04             	sub    $0x4,%esp
c010421a:	68 14 90 10 c0       	push   $0xc0109014
c010421f:	6a 6d                	push   $0x6d
c0104221:	68 bb 8f 10 c0       	push   $0xc0108fbb
c0104226:	e8 74 ca ff ff       	call   c0100c9f <__panic>
    return pa2page(PTE_ADDR(pte));
c010422b:	8b 45 08             	mov    0x8(%ebp),%eax
c010422e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104233:	83 ec 0c             	sub    $0xc,%esp
c0104236:	50                   	push   %eax
c0104237:	e8 09 ff ff ff       	call   c0104145 <pa2page>
c010423c:	83 c4 10             	add    $0x10,%esp
}
c010423f:	c9                   	leave  
c0104240:	c3                   	ret    

c0104241 <pde2page>:
pde2page(pde_t pde) {
c0104241:	55                   	push   %ebp
c0104242:	89 e5                	mov    %esp,%ebp
c0104244:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0104247:	8b 45 08             	mov    0x8(%ebp),%eax
c010424a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010424f:	83 ec 0c             	sub    $0xc,%esp
c0104252:	50                   	push   %eax
c0104253:	e8 ed fe ff ff       	call   c0104145 <pa2page>
c0104258:	83 c4 10             	add    $0x10,%esp
}
c010425b:	c9                   	leave  
c010425c:	c3                   	ret    

c010425d <page_ref>:
page_ref(struct Page *page) {
c010425d:	55                   	push   %ebp
c010425e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104260:	8b 45 08             	mov    0x8(%ebp),%eax
c0104263:	8b 00                	mov    (%eax),%eax
}
c0104265:	5d                   	pop    %ebp
c0104266:	c3                   	ret    

c0104267 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104267:	55                   	push   %ebp
c0104268:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010426a:	8b 45 08             	mov    0x8(%ebp),%eax
c010426d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104270:	89 10                	mov    %edx,(%eax)
}
c0104272:	90                   	nop
c0104273:	5d                   	pop    %ebp
c0104274:	c3                   	ret    

c0104275 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104275:	55                   	push   %ebp
c0104276:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104278:	8b 45 08             	mov    0x8(%ebp),%eax
c010427b:	8b 00                	mov    (%eax),%eax
c010427d:	8d 50 01             	lea    0x1(%eax),%edx
c0104280:	8b 45 08             	mov    0x8(%ebp),%eax
c0104283:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104285:	8b 45 08             	mov    0x8(%ebp),%eax
c0104288:	8b 00                	mov    (%eax),%eax
}
c010428a:	5d                   	pop    %ebp
c010428b:	c3                   	ret    

c010428c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010428c:	55                   	push   %ebp
c010428d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010428f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104292:	8b 00                	mov    (%eax),%eax
c0104294:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104297:	8b 45 08             	mov    0x8(%ebp),%eax
c010429a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010429c:	8b 45 08             	mov    0x8(%ebp),%eax
c010429f:	8b 00                	mov    (%eax),%eax
}
c01042a1:	5d                   	pop    %ebp
c01042a2:	c3                   	ret    

c01042a3 <__intr_save>:
__intr_save(void) {
c01042a3:	55                   	push   %ebp
c01042a4:	89 e5                	mov    %esp,%ebp
c01042a6:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01042a9:	9c                   	pushf  
c01042aa:	58                   	pop    %eax
c01042ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01042ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01042b1:	25 00 02 00 00       	and    $0x200,%eax
c01042b6:	85 c0                	test   %eax,%eax
c01042b8:	74 0c                	je     c01042c6 <__intr_save+0x23>
        intr_disable();
c01042ba:	e8 e5 db ff ff       	call   c0101ea4 <intr_disable>
        return 1;
c01042bf:	b8 01 00 00 00       	mov    $0x1,%eax
c01042c4:	eb 05                	jmp    c01042cb <__intr_save+0x28>
    return 0;
c01042c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042cb:	c9                   	leave  
c01042cc:	c3                   	ret    

c01042cd <__intr_restore>:
__intr_restore(bool flag) {
c01042cd:	55                   	push   %ebp
c01042ce:	89 e5                	mov    %esp,%ebp
c01042d0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01042d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01042d7:	74 05                	je     c01042de <__intr_restore+0x11>
        intr_enable();
c01042d9:	e8 be db ff ff       	call   c0101e9c <intr_enable>
}
c01042de:	90                   	nop
c01042df:	c9                   	leave  
c01042e0:	c3                   	ret    

c01042e1 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01042e1:	55                   	push   %ebp
c01042e2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01042e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01042e7:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01042ea:	b8 23 00 00 00       	mov    $0x23,%eax
c01042ef:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01042f1:	b8 23 00 00 00       	mov    $0x23,%eax
c01042f6:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01042f8:	b8 10 00 00 00       	mov    $0x10,%eax
c01042fd:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01042ff:	b8 10 00 00 00       	mov    $0x10,%eax
c0104304:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104306:	b8 10 00 00 00       	mov    $0x10,%eax
c010430b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c010430d:	ea 14 43 10 c0 08 00 	ljmp   $0x8,$0xc0104314
}
c0104314:	90                   	nop
c0104315:	5d                   	pop    %ebp
c0104316:	c3                   	ret    

c0104317 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104317:	55                   	push   %ebp
c0104318:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010431a:	8b 45 08             	mov    0x8(%ebp),%eax
c010431d:	a3 c4 5f 12 c0       	mov    %eax,0xc0125fc4
}
c0104322:	90                   	nop
c0104323:	5d                   	pop    %ebp
c0104324:	c3                   	ret    

c0104325 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104325:	55                   	push   %ebp
c0104326:	89 e5                	mov    %esp,%ebp
c0104328:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010432b:	b8 00 20 12 c0       	mov    $0xc0122000,%eax
c0104330:	50                   	push   %eax
c0104331:	e8 e1 ff ff ff       	call   c0104317 <load_esp0>
c0104336:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0104339:	66 c7 05 c8 5f 12 c0 	movw   $0x10,0xc0125fc8
c0104340:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104342:	66 c7 05 28 2a 12 c0 	movw   $0x68,0xc0122a28
c0104349:	68 00 
c010434b:	b8 c0 5f 12 c0       	mov    $0xc0125fc0,%eax
c0104350:	66 a3 2a 2a 12 c0    	mov    %ax,0xc0122a2a
c0104356:	b8 c0 5f 12 c0       	mov    $0xc0125fc0,%eax
c010435b:	c1 e8 10             	shr    $0x10,%eax
c010435e:	a2 2c 2a 12 c0       	mov    %al,0xc0122a2c
c0104363:	0f b6 05 2d 2a 12 c0 	movzbl 0xc0122a2d,%eax
c010436a:	83 e0 f0             	and    $0xfffffff0,%eax
c010436d:	83 c8 09             	or     $0x9,%eax
c0104370:	a2 2d 2a 12 c0       	mov    %al,0xc0122a2d
c0104375:	0f b6 05 2d 2a 12 c0 	movzbl 0xc0122a2d,%eax
c010437c:	83 e0 ef             	and    $0xffffffef,%eax
c010437f:	a2 2d 2a 12 c0       	mov    %al,0xc0122a2d
c0104384:	0f b6 05 2d 2a 12 c0 	movzbl 0xc0122a2d,%eax
c010438b:	83 e0 9f             	and    $0xffffff9f,%eax
c010438e:	a2 2d 2a 12 c0       	mov    %al,0xc0122a2d
c0104393:	0f b6 05 2d 2a 12 c0 	movzbl 0xc0122a2d,%eax
c010439a:	83 c8 80             	or     $0xffffff80,%eax
c010439d:	a2 2d 2a 12 c0       	mov    %al,0xc0122a2d
c01043a2:	0f b6 05 2e 2a 12 c0 	movzbl 0xc0122a2e,%eax
c01043a9:	83 e0 f0             	and    $0xfffffff0,%eax
c01043ac:	a2 2e 2a 12 c0       	mov    %al,0xc0122a2e
c01043b1:	0f b6 05 2e 2a 12 c0 	movzbl 0xc0122a2e,%eax
c01043b8:	83 e0 ef             	and    $0xffffffef,%eax
c01043bb:	a2 2e 2a 12 c0       	mov    %al,0xc0122a2e
c01043c0:	0f b6 05 2e 2a 12 c0 	movzbl 0xc0122a2e,%eax
c01043c7:	83 e0 df             	and    $0xffffffdf,%eax
c01043ca:	a2 2e 2a 12 c0       	mov    %al,0xc0122a2e
c01043cf:	0f b6 05 2e 2a 12 c0 	movzbl 0xc0122a2e,%eax
c01043d6:	83 c8 40             	or     $0x40,%eax
c01043d9:	a2 2e 2a 12 c0       	mov    %al,0xc0122a2e
c01043de:	0f b6 05 2e 2a 12 c0 	movzbl 0xc0122a2e,%eax
c01043e5:	83 e0 7f             	and    $0x7f,%eax
c01043e8:	a2 2e 2a 12 c0       	mov    %al,0xc0122a2e
c01043ed:	b8 c0 5f 12 c0       	mov    $0xc0125fc0,%eax
c01043f2:	c1 e8 18             	shr    $0x18,%eax
c01043f5:	a2 2f 2a 12 c0       	mov    %al,0xc0122a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01043fa:	68 30 2a 12 c0       	push   $0xc0122a30
c01043ff:	e8 dd fe ff ff       	call   c01042e1 <lgdt>
c0104404:	83 c4 04             	add    $0x4,%esp
c0104407:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c010440d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104411:	0f 00 d8             	ltr    %ax
}
c0104414:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0104415:	90                   	nop
c0104416:	c9                   	leave  
c0104417:	c3                   	ret    

c0104418 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104418:	55                   	push   %ebp
c0104419:	89 e5                	mov    %esp,%ebp
c010441b:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c010441e:	c7 05 ac 5f 12 c0 80 	movl   $0xc0108f80,0xc0125fac
c0104425:	8f 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104428:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c010442d:	8b 00                	mov    (%eax),%eax
c010442f:	83 ec 08             	sub    $0x8,%esp
c0104432:	50                   	push   %eax
c0104433:	68 40 90 10 c0       	push   $0xc0109040
c0104438:	e8 03 bf ff ff       	call   c0100340 <cprintf>
c010443d:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0104440:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c0104445:	8b 40 04             	mov    0x4(%eax),%eax
c0104448:	ff d0                	call   *%eax
}
c010444a:	90                   	nop
c010444b:	c9                   	leave  
c010444c:	c3                   	ret    

c010444d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010444d:	55                   	push   %ebp
c010444e:	89 e5                	mov    %esp,%ebp
c0104450:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0104453:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c0104458:	8b 40 08             	mov    0x8(%eax),%eax
c010445b:	83 ec 08             	sub    $0x8,%esp
c010445e:	ff 75 0c             	push   0xc(%ebp)
c0104461:	ff 75 08             	push   0x8(%ebp)
c0104464:	ff d0                	call   *%eax
c0104466:	83 c4 10             	add    $0x10,%esp
}
c0104469:	90                   	nop
c010446a:	c9                   	leave  
c010446b:	c3                   	ret    

c010446c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010446c:	55                   	push   %ebp
c010446d:	89 e5                	mov    %esp,%ebp
c010446f:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0104472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104479:	e8 25 fe ff ff       	call   c01042a3 <__intr_save>
c010447e:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104481:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c0104486:	8b 40 0c             	mov    0xc(%eax),%eax
c0104489:	83 ec 0c             	sub    $0xc,%esp
c010448c:	ff 75 08             	push   0x8(%ebp)
c010448f:	ff d0                	call   *%eax
c0104491:	83 c4 10             	add    $0x10,%esp
c0104494:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104497:	83 ec 0c             	sub    $0xc,%esp
c010449a:	ff 75 f0             	push   -0x10(%ebp)
c010449d:	e8 2b fe ff ff       	call   c01042cd <__intr_restore>
c01044a2:	83 c4 10             	add    $0x10,%esp

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01044a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044a9:	75 28                	jne    c01044d3 <alloc_pages+0x67>
c01044ab:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01044af:	77 22                	ja     c01044d3 <alloc_pages+0x67>
c01044b1:	a1 44 60 12 c0       	mov    0xc0126044,%eax
c01044b6:	85 c0                	test   %eax,%eax
c01044b8:	74 19                	je     c01044d3 <alloc_pages+0x67>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01044ba:	8b 55 08             	mov    0x8(%ebp),%edx
c01044bd:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c01044c2:	83 ec 04             	sub    $0x4,%esp
c01044c5:	6a 00                	push   $0x0
c01044c7:	52                   	push   %edx
c01044c8:	50                   	push   %eax
c01044c9:	e8 00 17 00 00       	call   c0105bce <swap_out>
c01044ce:	83 c4 10             	add    $0x10,%esp
    {
c01044d1:	eb a6                	jmp    c0104479 <alloc_pages+0xd>
    }
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01044d6:	c9                   	leave  
c01044d7:	c3                   	ret    

c01044d8 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01044d8:	55                   	push   %ebp
c01044d9:	89 e5                	mov    %esp,%ebp
c01044db:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01044de:	e8 c0 fd ff ff       	call   c01042a3 <__intr_save>
c01044e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01044e6:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c01044eb:	8b 40 10             	mov    0x10(%eax),%eax
c01044ee:	83 ec 08             	sub    $0x8,%esp
c01044f1:	ff 75 0c             	push   0xc(%ebp)
c01044f4:	ff 75 08             	push   0x8(%ebp)
c01044f7:	ff d0                	call   *%eax
c01044f9:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c01044fc:	83 ec 0c             	sub    $0xc,%esp
c01044ff:	ff 75 f4             	push   -0xc(%ebp)
c0104502:	e8 c6 fd ff ff       	call   c01042cd <__intr_restore>
c0104507:	83 c4 10             	add    $0x10,%esp
}
c010450a:	90                   	nop
c010450b:	c9                   	leave  
c010450c:	c3                   	ret    

c010450d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010450d:	55                   	push   %ebp
c010450e:	89 e5                	mov    %esp,%ebp
c0104510:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104513:	e8 8b fd ff ff       	call   c01042a3 <__intr_save>
c0104518:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010451b:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c0104520:	8b 40 14             	mov    0x14(%eax),%eax
c0104523:	ff d0                	call   *%eax
c0104525:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104528:	83 ec 0c             	sub    $0xc,%esp
c010452b:	ff 75 f4             	push   -0xc(%ebp)
c010452e:	e8 9a fd ff ff       	call   c01042cd <__intr_restore>
c0104533:	83 c4 10             	add    $0x10,%esp
    return ret;
c0104536:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104539:	c9                   	leave  
c010453a:	c3                   	ret    

c010453b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010453b:	55                   	push   %ebp
c010453c:	89 e5                	mov    %esp,%ebp
c010453e:	57                   	push   %edi
c010453f:	56                   	push   %esi
c0104540:	53                   	push   %ebx
c0104541:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104544:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010454b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104552:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104559:	83 ec 0c             	sub    $0xc,%esp
c010455c:	68 57 90 10 c0       	push   $0xc0109057
c0104561:	e8 da bd ff ff       	call   c0100340 <cprintf>
c0104566:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104569:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104570:	e9 f4 00 00 00       	jmp    c0104669 <page_init+0x12e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104575:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104578:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010457b:	89 d0                	mov    %edx,%eax
c010457d:	c1 e0 02             	shl    $0x2,%eax
c0104580:	01 d0                	add    %edx,%eax
c0104582:	c1 e0 02             	shl    $0x2,%eax
c0104585:	01 c8                	add    %ecx,%eax
c0104587:	8b 50 08             	mov    0x8(%eax),%edx
c010458a:	8b 40 04             	mov    0x4(%eax),%eax
c010458d:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104590:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104593:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104596:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104599:	89 d0                	mov    %edx,%eax
c010459b:	c1 e0 02             	shl    $0x2,%eax
c010459e:	01 d0                	add    %edx,%eax
c01045a0:	c1 e0 02             	shl    $0x2,%eax
c01045a3:	01 c8                	add    %ecx,%eax
c01045a5:	8b 48 0c             	mov    0xc(%eax),%ecx
c01045a8:	8b 58 10             	mov    0x10(%eax),%ebx
c01045ab:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01045ae:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01045b1:	01 c8                	add    %ecx,%eax
c01045b3:	11 da                	adc    %ebx,%edx
c01045b5:	89 45 98             	mov    %eax,-0x68(%ebp)
c01045b8:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01045bb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01045be:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045c1:	89 d0                	mov    %edx,%eax
c01045c3:	c1 e0 02             	shl    $0x2,%eax
c01045c6:	01 d0                	add    %edx,%eax
c01045c8:	c1 e0 02             	shl    $0x2,%eax
c01045cb:	01 c8                	add    %ecx,%eax
c01045cd:	83 c0 14             	add    $0x14,%eax
c01045d0:	8b 00                	mov    (%eax),%eax
c01045d2:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01045d5:	8b 45 98             	mov    -0x68(%ebp),%eax
c01045d8:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01045db:	83 c0 ff             	add    $0xffffffff,%eax
c01045de:	83 d2 ff             	adc    $0xffffffff,%edx
c01045e1:	89 c1                	mov    %eax,%ecx
c01045e3:	89 d3                	mov    %edx,%ebx
c01045e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01045e8:	89 55 80             	mov    %edx,-0x80(%ebp)
c01045eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045ee:	89 d0                	mov    %edx,%eax
c01045f0:	c1 e0 02             	shl    $0x2,%eax
c01045f3:	01 d0                	add    %edx,%eax
c01045f5:	c1 e0 02             	shl    $0x2,%eax
c01045f8:	03 45 80             	add    -0x80(%ebp),%eax
c01045fb:	8b 50 10             	mov    0x10(%eax),%edx
c01045fe:	8b 40 0c             	mov    0xc(%eax),%eax
c0104601:	ff 75 84             	push   -0x7c(%ebp)
c0104604:	53                   	push   %ebx
c0104605:	51                   	push   %ecx
c0104606:	ff 75 a4             	push   -0x5c(%ebp)
c0104609:	ff 75 a0             	push   -0x60(%ebp)
c010460c:	52                   	push   %edx
c010460d:	50                   	push   %eax
c010460e:	68 64 90 10 c0       	push   $0xc0109064
c0104613:	e8 28 bd ff ff       	call   c0100340 <cprintf>
c0104618:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010461b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010461e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104621:	89 d0                	mov    %edx,%eax
c0104623:	c1 e0 02             	shl    $0x2,%eax
c0104626:	01 d0                	add    %edx,%eax
c0104628:	c1 e0 02             	shl    $0x2,%eax
c010462b:	01 c8                	add    %ecx,%eax
c010462d:	83 c0 14             	add    $0x14,%eax
c0104630:	8b 00                	mov    (%eax),%eax
c0104632:	83 f8 01             	cmp    $0x1,%eax
c0104635:	75 2e                	jne    c0104665 <page_init+0x12a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104637:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010463a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010463d:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104640:	89 d0                	mov    %edx,%eax
c0104642:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104645:	73 1e                	jae    c0104665 <page_init+0x12a>
c0104647:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c010464c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104651:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104654:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104657:	72 0c                	jb     c0104665 <page_init+0x12a>
                maxpa = end;
c0104659:	8b 45 98             	mov    -0x68(%ebp),%eax
c010465c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010465f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104662:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104665:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104669:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010466c:	8b 00                	mov    (%eax),%eax
c010466e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104671:	0f 8c fe fe ff ff    	jl     c0104575 <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104677:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010467c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104681:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104684:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104687:	73 0e                	jae    c0104697 <page_init+0x15c>
        maxpa = KMEMSIZE;
c0104689:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104690:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104697:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010469a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010469d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01046a1:	c1 ea 0c             	shr    $0xc,%edx
c01046a4:	a3 a4 5f 12 c0       	mov    %eax,0xc0125fa4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01046a9:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01046b0:	b8 14 61 12 c0       	mov    $0xc0126114,%eax
c01046b5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01046b8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01046bb:	01 d0                	add    %edx,%eax
c01046bd:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01046c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01046c3:	ba 00 00 00 00       	mov    $0x0,%edx
c01046c8:	f7 75 c0             	divl   -0x40(%ebp)
c01046cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01046ce:	29 d0                	sub    %edx,%eax
c01046d0:	a3 a0 5f 12 c0       	mov    %eax,0xc0125fa0

    for (i = 0; i < npage; i ++) {
c01046d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01046dc:	eb 29                	jmp    c0104707 <page_init+0x1cc>
        SetPageReserved(pages + i);
c01046de:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c01046e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046e7:	c1 e0 05             	shl    $0x5,%eax
c01046ea:	01 d0                	add    %edx,%eax
c01046ec:	83 c0 04             	add    $0x4,%eax
c01046ef:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01046f6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046f9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01046fc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01046ff:	0f ab 10             	bts    %edx,(%eax)
}
c0104702:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104703:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104707:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010470a:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c010470f:	39 c2                	cmp    %eax,%edx
c0104711:	72 cb                	jb     c01046de <page_init+0x1a3>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104713:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0104718:	c1 e0 05             	shl    $0x5,%eax
c010471b:	89 c2                	mov    %eax,%edx
c010471d:	a1 a0 5f 12 c0       	mov    0xc0125fa0,%eax
c0104722:	01 d0                	add    %edx,%eax
c0104724:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104727:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010472e:	77 17                	ja     c0104747 <page_init+0x20c>
c0104730:	ff 75 b8             	push   -0x48(%ebp)
c0104733:	68 f0 8f 10 c0       	push   $0xc0108ff0
c0104738:	68 e9 00 00 00       	push   $0xe9
c010473d:	68 94 90 10 c0       	push   $0xc0109094
c0104742:	e8 58 c5 ff ff       	call   c0100c9f <__panic>
c0104747:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010474a:	05 00 00 00 40       	add    $0x40000000,%eax
c010474f:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104759:	e9 53 01 00 00       	jmp    c01048b1 <page_init+0x376>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010475e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104761:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104764:	89 d0                	mov    %edx,%eax
c0104766:	c1 e0 02             	shl    $0x2,%eax
c0104769:	01 d0                	add    %edx,%eax
c010476b:	c1 e0 02             	shl    $0x2,%eax
c010476e:	01 c8                	add    %ecx,%eax
c0104770:	8b 50 08             	mov    0x8(%eax),%edx
c0104773:	8b 40 04             	mov    0x4(%eax),%eax
c0104776:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104779:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010477c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010477f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104782:	89 d0                	mov    %edx,%eax
c0104784:	c1 e0 02             	shl    $0x2,%eax
c0104787:	01 d0                	add    %edx,%eax
c0104789:	c1 e0 02             	shl    $0x2,%eax
c010478c:	01 c8                	add    %ecx,%eax
c010478e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104791:	8b 58 10             	mov    0x10(%eax),%ebx
c0104794:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010479a:	01 c8                	add    %ecx,%eax
c010479c:	11 da                	adc    %ebx,%edx
c010479e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01047a1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01047a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047aa:	89 d0                	mov    %edx,%eax
c01047ac:	c1 e0 02             	shl    $0x2,%eax
c01047af:	01 d0                	add    %edx,%eax
c01047b1:	c1 e0 02             	shl    $0x2,%eax
c01047b4:	01 c8                	add    %ecx,%eax
c01047b6:	83 c0 14             	add    $0x14,%eax
c01047b9:	8b 00                	mov    (%eax),%eax
c01047bb:	83 f8 01             	cmp    $0x1,%eax
c01047be:	0f 85 e9 00 00 00    	jne    c01048ad <page_init+0x372>
            if (begin < freemem) {
c01047c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01047c7:	ba 00 00 00 00       	mov    $0x0,%edx
c01047cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01047cf:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01047d2:	19 d1                	sbb    %edx,%ecx
c01047d4:	73 0d                	jae    c01047e3 <page_init+0x2a8>
                begin = freemem;
c01047d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01047d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01047dc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01047e3:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01047e8:	b8 00 00 00 00       	mov    $0x0,%eax
c01047ed:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01047f0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01047f3:	73 0e                	jae    c0104803 <page_init+0x2c8>
                end = KMEMSIZE;
c01047f5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01047fc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104803:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104806:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104809:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010480c:	89 d0                	mov    %edx,%eax
c010480e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104811:	0f 83 96 00 00 00    	jae    c01048ad <page_init+0x372>
                begin = ROUNDUP(begin, PGSIZE);
c0104817:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c010481e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104821:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104824:	01 d0                	add    %edx,%eax
c0104826:	83 e8 01             	sub    $0x1,%eax
c0104829:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010482c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010482f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104834:	f7 75 b0             	divl   -0x50(%ebp)
c0104837:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010483a:	29 d0                	sub    %edx,%eax
c010483c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104841:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104844:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104847:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010484a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010484d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104850:	ba 00 00 00 00       	mov    $0x0,%edx
c0104855:	89 c3                	mov    %eax,%ebx
c0104857:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010485d:	89 de                	mov    %ebx,%esi
c010485f:	89 d0                	mov    %edx,%eax
c0104861:	83 e0 00             	and    $0x0,%eax
c0104864:	89 c7                	mov    %eax,%edi
c0104866:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0104869:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010486c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010486f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104872:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104875:	89 d0                	mov    %edx,%eax
c0104877:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010487a:	73 31                	jae    c01048ad <page_init+0x372>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010487c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010487f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104882:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104885:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104888:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010488c:	c1 ea 0c             	shr    $0xc,%edx
c010488f:	89 c3                	mov    %eax,%ebx
c0104891:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104894:	83 ec 0c             	sub    $0xc,%esp
c0104897:	50                   	push   %eax
c0104898:	e8 a8 f8 ff ff       	call   c0104145 <pa2page>
c010489d:	83 c4 10             	add    $0x10,%esp
c01048a0:	83 ec 08             	sub    $0x8,%esp
c01048a3:	53                   	push   %ebx
c01048a4:	50                   	push   %eax
c01048a5:	e8 a3 fb ff ff       	call   c010444d <init_memmap>
c01048aa:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c01048ad:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01048b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048b4:	8b 00                	mov    (%eax),%eax
c01048b6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01048b9:	0f 8c 9f fe ff ff    	jl     c010475e <page_init+0x223>
                }
            }
        }
    }
}
c01048bf:	90                   	nop
c01048c0:	90                   	nop
c01048c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01048c4:	5b                   	pop    %ebx
c01048c5:	5e                   	pop    %esi
c01048c6:	5f                   	pop    %edi
c01048c7:	5d                   	pop    %ebp
c01048c8:	c3                   	ret    

c01048c9 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01048c9:	55                   	push   %ebp
c01048ca:	89 e5                	mov    %esp,%ebp
c01048cc:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01048cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048d2:	33 45 14             	xor    0x14(%ebp),%eax
c01048d5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01048da:	85 c0                	test   %eax,%eax
c01048dc:	74 19                	je     c01048f7 <boot_map_segment+0x2e>
c01048de:	68 a2 90 10 c0       	push   $0xc01090a2
c01048e3:	68 b9 90 10 c0       	push   $0xc01090b9
c01048e8:	68 07 01 00 00       	push   $0x107
c01048ed:	68 94 90 10 c0       	push   $0xc0109094
c01048f2:	e8 a8 c3 ff ff       	call   c0100c9f <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01048f7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01048fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104901:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104906:	89 c2                	mov    %eax,%edx
c0104908:	8b 45 10             	mov    0x10(%ebp),%eax
c010490b:	01 c2                	add    %eax,%edx
c010490d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104910:	01 d0                	add    %edx,%eax
c0104912:	83 e8 01             	sub    $0x1,%eax
c0104915:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104918:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010491b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104920:	f7 75 f0             	divl   -0x10(%ebp)
c0104923:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104926:	29 d0                	sub    %edx,%eax
c0104928:	c1 e8 0c             	shr    $0xc,%eax
c010492b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010492e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104931:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104934:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104937:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010493c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010493f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104942:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010494d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104950:	eb 57                	jmp    c01049a9 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104952:	83 ec 04             	sub    $0x4,%esp
c0104955:	6a 01                	push   $0x1
c0104957:	ff 75 0c             	push   0xc(%ebp)
c010495a:	ff 75 08             	push   0x8(%ebp)
c010495d:	e8 54 01 00 00       	call   c0104ab6 <get_pte>
c0104962:	83 c4 10             	add    $0x10,%esp
c0104965:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010496c:	75 19                	jne    c0104987 <boot_map_segment+0xbe>
c010496e:	68 ce 90 10 c0       	push   $0xc01090ce
c0104973:	68 b9 90 10 c0       	push   $0xc01090b9
c0104978:	68 0d 01 00 00       	push   $0x10d
c010497d:	68 94 90 10 c0       	push   $0xc0109094
c0104982:	e8 18 c3 ff ff       	call   c0100c9f <__panic>
        *ptep = pa | PTE_P | perm;
c0104987:	8b 45 14             	mov    0x14(%ebp),%eax
c010498a:	0b 45 18             	or     0x18(%ebp),%eax
c010498d:	83 c8 01             	or     $0x1,%eax
c0104990:	89 c2                	mov    %eax,%edx
c0104992:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104995:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104997:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010499b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01049a2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01049a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049ad:	75 a3                	jne    c0104952 <boot_map_segment+0x89>
    }
}
c01049af:	90                   	nop
c01049b0:	90                   	nop
c01049b1:	c9                   	leave  
c01049b2:	c3                   	ret    

c01049b3 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01049b3:	55                   	push   %ebp
c01049b4:	89 e5                	mov    %esp,%ebp
c01049b6:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01049b9:	83 ec 0c             	sub    $0xc,%esp
c01049bc:	6a 01                	push   $0x1
c01049be:	e8 a9 fa ff ff       	call   c010446c <alloc_pages>
c01049c3:	83 c4 10             	add    $0x10,%esp
c01049c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01049c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049cd:	75 17                	jne    c01049e6 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c01049cf:	83 ec 04             	sub    $0x4,%esp
c01049d2:	68 db 90 10 c0       	push   $0xc01090db
c01049d7:	68 19 01 00 00       	push   $0x119
c01049dc:	68 94 90 10 c0       	push   $0xc0109094
c01049e1:	e8 b9 c2 ff ff       	call   c0100c9f <__panic>
    }
    return page2kva(p);
c01049e6:	83 ec 0c             	sub    $0xc,%esp
c01049e9:	ff 75 f4             	push   -0xc(%ebp)
c01049ec:	e8 92 f7 ff ff       	call   c0104183 <page2kva>
c01049f1:	83 c4 10             	add    $0x10,%esp
}
c01049f4:	c9                   	leave  
c01049f5:	c3                   	ret    

c01049f6 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01049f6:	55                   	push   %ebp
c01049f7:	89 e5                	mov    %esp,%ebp
c01049f9:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01049fc:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a04:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104a0b:	77 17                	ja     c0104a24 <pmm_init+0x2e>
c0104a0d:	ff 75 f4             	push   -0xc(%ebp)
c0104a10:	68 f0 8f 10 c0       	push   $0xc0108ff0
c0104a15:	68 23 01 00 00       	push   $0x123
c0104a1a:	68 94 90 10 c0       	push   $0xc0109094
c0104a1f:	e8 7b c2 ff ff       	call   c0100c9f <__panic>
c0104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a27:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a2c:	a3 a8 5f 12 c0       	mov    %eax,0xc0125fa8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104a31:	e8 e2 f9 ff ff       	call   c0104418 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104a36:	e8 00 fb ff ff       	call   c010453b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104a3b:	e8 39 04 00 00       	call   c0104e79 <check_alloc_page>

    check_pgdir();
c0104a40:	e8 57 04 00 00       	call   c0104e9c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104a45:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a4d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104a54:	77 17                	ja     c0104a6d <pmm_init+0x77>
c0104a56:	ff 75 f0             	push   -0x10(%ebp)
c0104a59:	68 f0 8f 10 c0       	push   $0xc0108ff0
c0104a5e:	68 39 01 00 00       	push   $0x139
c0104a63:	68 94 90 10 c0       	push   $0xc0109094
c0104a68:	e8 32 c2 ff ff       	call   c0100c9f <__panic>
c0104a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a70:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0104a76:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104a7b:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104a80:	83 ca 03             	or     $0x3,%edx
c0104a83:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104a85:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104a8a:	83 ec 0c             	sub    $0xc,%esp
c0104a8d:	6a 02                	push   $0x2
c0104a8f:	6a 00                	push   $0x0
c0104a91:	68 00 00 00 38       	push   $0x38000000
c0104a96:	68 00 00 00 c0       	push   $0xc0000000
c0104a9b:	50                   	push   %eax
c0104a9c:	e8 28 fe ff ff       	call   c01048c9 <boot_map_segment>
c0104aa1:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104aa4:	e8 7c f8 ff ff       	call   c0104325 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104aa9:	e8 54 09 00 00       	call   c0105402 <check_boot_pgdir>

    print_pgdir();
c0104aae:	e8 4a 0d 00 00       	call   c01057fd <print_pgdir>

}
c0104ab3:	90                   	nop
c0104ab4:	c9                   	leave  
c0104ab5:	c3                   	ret    

c0104ab6 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104ab6:	55                   	push   %ebp
c0104ab7:	89 e5                	mov    %esp,%ebp
c0104ab9:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104abc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104abf:	c1 e8 16             	shr    $0x16,%eax
c0104ac2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104acc:	01 d0                	add    %edx,%eax
c0104ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad4:	8b 00                	mov    (%eax),%eax
c0104ad6:	83 e0 01             	and    $0x1,%eax
c0104ad9:	85 c0                	test   %eax,%eax
c0104adb:	0f 85 9f 00 00 00    	jne    c0104b80 <get_pte+0xca>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104ae1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104ae5:	74 16                	je     c0104afd <get_pte+0x47>
c0104ae7:	83 ec 0c             	sub    $0xc,%esp
c0104aea:	6a 01                	push   $0x1
c0104aec:	e8 7b f9 ff ff       	call   c010446c <alloc_pages>
c0104af1:	83 c4 10             	add    $0x10,%esp
c0104af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104af7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104afb:	75 0a                	jne    c0104b07 <get_pte+0x51>
            return NULL;
c0104afd:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b02:	e9 ca 00 00 00       	jmp    c0104bd1 <get_pte+0x11b>
        }
        set_page_ref(page, 1);
c0104b07:	83 ec 08             	sub    $0x8,%esp
c0104b0a:	6a 01                	push   $0x1
c0104b0c:	ff 75 f0             	push   -0x10(%ebp)
c0104b0f:	e8 53 f7 ff ff       	call   c0104267 <set_page_ref>
c0104b14:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c0104b17:	83 ec 0c             	sub    $0xc,%esp
c0104b1a:	ff 75 f0             	push   -0x10(%ebp)
c0104b1d:	e8 10 f6 ff ff       	call   c0104132 <page2pa>
c0104b22:	83 c4 10             	add    $0x10,%esp
c0104b25:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b31:	c1 e8 0c             	shr    $0xc,%eax
c0104b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b37:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0104b3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104b3f:	72 17                	jb     c0104b58 <get_pte+0xa2>
c0104b41:	ff 75 e8             	push   -0x18(%ebp)
c0104b44:	68 cc 8f 10 c0       	push   $0xc0108fcc
c0104b49:	68 7f 01 00 00       	push   $0x17f
c0104b4e:	68 94 90 10 c0       	push   $0xc0109094
c0104b53:	e8 47 c1 ff ff       	call   c0100c9f <__panic>
c0104b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b5b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b60:	83 ec 04             	sub    $0x4,%esp
c0104b63:	68 00 10 00 00       	push   $0x1000
c0104b68:	6a 00                	push   $0x0
c0104b6a:	50                   	push   %eax
c0104b6b:	e8 d7 35 00 00       	call   c0108147 <memset>
c0104b70:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b76:	83 c8 07             	or     $0x7,%eax
c0104b79:	89 c2                	mov    %eax,%edx
c0104b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b83:	8b 00                	mov    (%eax),%eax
c0104b85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b90:	c1 e8 0c             	shr    $0xc,%eax
c0104b93:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104b96:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0104b9b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104b9e:	72 17                	jb     c0104bb7 <get_pte+0x101>
c0104ba0:	ff 75 e0             	push   -0x20(%ebp)
c0104ba3:	68 cc 8f 10 c0       	push   $0xc0108fcc
c0104ba8:	68 82 01 00 00       	push   $0x182
c0104bad:	68 94 90 10 c0       	push   $0xc0109094
c0104bb2:	e8 e8 c0 ff ff       	call   c0100c9f <__panic>
c0104bb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bba:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104bbf:	89 c2                	mov    %eax,%edx
c0104bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bc4:	c1 e8 0c             	shr    $0xc,%eax
c0104bc7:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104bcc:	c1 e0 02             	shl    $0x2,%eax
c0104bcf:	01 d0                	add    %edx,%eax
}
c0104bd1:	c9                   	leave  
c0104bd2:	c3                   	ret    

c0104bd3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104bd3:	55                   	push   %ebp
c0104bd4:	89 e5                	mov    %esp,%ebp
c0104bd6:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104bd9:	83 ec 04             	sub    $0x4,%esp
c0104bdc:	6a 00                	push   $0x0
c0104bde:	ff 75 0c             	push   0xc(%ebp)
c0104be1:	ff 75 08             	push   0x8(%ebp)
c0104be4:	e8 cd fe ff ff       	call   c0104ab6 <get_pte>
c0104be9:	83 c4 10             	add    $0x10,%esp
c0104bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104bef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104bf3:	74 08                	je     c0104bfd <get_page+0x2a>
        *ptep_store = ptep;
c0104bf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0104bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104bfb:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104bfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c01:	74 1f                	je     c0104c22 <get_page+0x4f>
c0104c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c06:	8b 00                	mov    (%eax),%eax
c0104c08:	83 e0 01             	and    $0x1,%eax
c0104c0b:	85 c0                	test   %eax,%eax
c0104c0d:	74 13                	je     c0104c22 <get_page+0x4f>
        return pte2page(*ptep);
c0104c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c12:	8b 00                	mov    (%eax),%eax
c0104c14:	83 ec 0c             	sub    $0xc,%esp
c0104c17:	50                   	push   %eax
c0104c18:	e8 ea f5 ff ff       	call   c0104207 <pte2page>
c0104c1d:	83 c4 10             	add    $0x10,%esp
c0104c20:	eb 05                	jmp    c0104c27 <get_page+0x54>
    }
    return NULL;
c0104c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104c27:	c9                   	leave  
c0104c28:	c3                   	ret    

c0104c29 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104c29:	55                   	push   %ebp
c0104c2a:	89 e5                	mov    %esp,%ebp
c0104c2c:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104c2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c32:	8b 00                	mov    (%eax),%eax
c0104c34:	83 e0 01             	and    $0x1,%eax
c0104c37:	85 c0                	test   %eax,%eax
c0104c39:	74 50                	je     c0104c8b <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0104c3b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c3e:	8b 00                	mov    (%eax),%eax
c0104c40:	83 ec 0c             	sub    $0xc,%esp
c0104c43:	50                   	push   %eax
c0104c44:	e8 be f5 ff ff       	call   c0104207 <pte2page>
c0104c49:	83 c4 10             	add    $0x10,%esp
c0104c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104c4f:	83 ec 0c             	sub    $0xc,%esp
c0104c52:	ff 75 f4             	push   -0xc(%ebp)
c0104c55:	e8 32 f6 ff ff       	call   c010428c <page_ref_dec>
c0104c5a:	83 c4 10             	add    $0x10,%esp
c0104c5d:	85 c0                	test   %eax,%eax
c0104c5f:	75 10                	jne    c0104c71 <page_remove_pte+0x48>
            free_page(page);
c0104c61:	83 ec 08             	sub    $0x8,%esp
c0104c64:	6a 01                	push   $0x1
c0104c66:	ff 75 f4             	push   -0xc(%ebp)
c0104c69:	e8 6a f8 ff ff       	call   c01044d8 <free_pages>
c0104c6e:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c0104c71:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104c7a:	83 ec 08             	sub    $0x8,%esp
c0104c7d:	ff 75 0c             	push   0xc(%ebp)
c0104c80:	ff 75 08             	push   0x8(%ebp)
c0104c83:	e8 f8 00 00 00       	call   c0104d80 <tlb_invalidate>
c0104c88:	83 c4 10             	add    $0x10,%esp
    }
}
c0104c8b:	90                   	nop
c0104c8c:	c9                   	leave  
c0104c8d:	c3                   	ret    

c0104c8e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104c8e:	55                   	push   %ebp
c0104c8f:	89 e5                	mov    %esp,%ebp
c0104c91:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104c94:	83 ec 04             	sub    $0x4,%esp
c0104c97:	6a 00                	push   $0x0
c0104c99:	ff 75 0c             	push   0xc(%ebp)
c0104c9c:	ff 75 08             	push   0x8(%ebp)
c0104c9f:	e8 12 fe ff ff       	call   c0104ab6 <get_pte>
c0104ca4:	83 c4 10             	add    $0x10,%esp
c0104ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cae:	74 14                	je     c0104cc4 <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0104cb0:	83 ec 04             	sub    $0x4,%esp
c0104cb3:	ff 75 f4             	push   -0xc(%ebp)
c0104cb6:	ff 75 0c             	push   0xc(%ebp)
c0104cb9:	ff 75 08             	push   0x8(%ebp)
c0104cbc:	e8 68 ff ff ff       	call   c0104c29 <page_remove_pte>
c0104cc1:	83 c4 10             	add    $0x10,%esp
    }
}
c0104cc4:	90                   	nop
c0104cc5:	c9                   	leave  
c0104cc6:	c3                   	ret    

c0104cc7 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104cc7:	55                   	push   %ebp
c0104cc8:	89 e5                	mov    %esp,%ebp
c0104cca:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104ccd:	83 ec 04             	sub    $0x4,%esp
c0104cd0:	6a 01                	push   $0x1
c0104cd2:	ff 75 10             	push   0x10(%ebp)
c0104cd5:	ff 75 08             	push   0x8(%ebp)
c0104cd8:	e8 d9 fd ff ff       	call   c0104ab6 <get_pte>
c0104cdd:	83 c4 10             	add    $0x10,%esp
c0104ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ce7:	75 0a                	jne    c0104cf3 <page_insert+0x2c>
        return -E_NO_MEM;
c0104ce9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104cee:	e9 8b 00 00 00       	jmp    c0104d7e <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104cf3:	83 ec 0c             	sub    $0xc,%esp
c0104cf6:	ff 75 0c             	push   0xc(%ebp)
c0104cf9:	e8 77 f5 ff ff       	call   c0104275 <page_ref_inc>
c0104cfe:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0104d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d04:	8b 00                	mov    (%eax),%eax
c0104d06:	83 e0 01             	and    $0x1,%eax
c0104d09:	85 c0                	test   %eax,%eax
c0104d0b:	74 40                	je     c0104d4d <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0104d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d10:	8b 00                	mov    (%eax),%eax
c0104d12:	83 ec 0c             	sub    $0xc,%esp
c0104d15:	50                   	push   %eax
c0104d16:	e8 ec f4 ff ff       	call   c0104207 <pte2page>
c0104d1b:	83 c4 10             	add    $0x10,%esp
c0104d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d24:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104d27:	75 10                	jne    c0104d39 <page_insert+0x72>
            page_ref_dec(page);
c0104d29:	83 ec 0c             	sub    $0xc,%esp
c0104d2c:	ff 75 0c             	push   0xc(%ebp)
c0104d2f:	e8 58 f5 ff ff       	call   c010428c <page_ref_dec>
c0104d34:	83 c4 10             	add    $0x10,%esp
c0104d37:	eb 14                	jmp    c0104d4d <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104d39:	83 ec 04             	sub    $0x4,%esp
c0104d3c:	ff 75 f4             	push   -0xc(%ebp)
c0104d3f:	ff 75 10             	push   0x10(%ebp)
c0104d42:	ff 75 08             	push   0x8(%ebp)
c0104d45:	e8 df fe ff ff       	call   c0104c29 <page_remove_pte>
c0104d4a:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104d4d:	83 ec 0c             	sub    $0xc,%esp
c0104d50:	ff 75 0c             	push   0xc(%ebp)
c0104d53:	e8 da f3 ff ff       	call   c0104132 <page2pa>
c0104d58:	83 c4 10             	add    $0x10,%esp
c0104d5b:	0b 45 14             	or     0x14(%ebp),%eax
c0104d5e:	83 c8 01             	or     $0x1,%eax
c0104d61:	89 c2                	mov    %eax,%edx
c0104d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d66:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104d68:	83 ec 08             	sub    $0x8,%esp
c0104d6b:	ff 75 10             	push   0x10(%ebp)
c0104d6e:	ff 75 08             	push   0x8(%ebp)
c0104d71:	e8 0a 00 00 00       	call   c0104d80 <tlb_invalidate>
c0104d76:	83 c4 10             	add    $0x10,%esp
    return 0;
c0104d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104d7e:	c9                   	leave  
c0104d7f:	c3                   	ret    

c0104d80 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104d80:	55                   	push   %ebp
c0104d81:	89 e5                	mov    %esp,%ebp
c0104d83:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104d86:	0f 20 d8             	mov    %cr3,%eax
c0104d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104d8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d95:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d9c:	77 17                	ja     c0104db5 <tlb_invalidate+0x35>
c0104d9e:	ff 75 f4             	push   -0xc(%ebp)
c0104da1:	68 f0 8f 10 c0       	push   $0xc0108ff0
c0104da6:	68 e4 01 00 00       	push   $0x1e4
c0104dab:	68 94 90 10 c0       	push   $0xc0109094
c0104db0:	e8 ea be ff ff       	call   c0100c9f <__panic>
c0104db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104dbd:	39 d0                	cmp    %edx,%eax
c0104dbf:	75 0d                	jne    c0104dce <tlb_invalidate+0x4e>
        invlpg((void *)la);
c0104dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104dc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dca:	0f 01 38             	invlpg (%eax)
}
c0104dcd:	90                   	nop
    }
}
c0104dce:	90                   	nop
c0104dcf:	c9                   	leave  
c0104dd0:	c3                   	ret    

c0104dd1 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0104dd1:	55                   	push   %ebp
c0104dd2:	89 e5                	mov    %esp,%ebp
c0104dd4:	83 ec 18             	sub    $0x18,%esp
    struct Page *page = alloc_page();
c0104dd7:	83 ec 0c             	sub    $0xc,%esp
c0104dda:	6a 01                	push   $0x1
c0104ddc:	e8 8b f6 ff ff       	call   c010446c <alloc_pages>
c0104de1:	83 c4 10             	add    $0x10,%esp
c0104de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0104de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104deb:	0f 84 83 00 00 00    	je     c0104e74 <pgdir_alloc_page+0xa3>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0104df1:	ff 75 10             	push   0x10(%ebp)
c0104df4:	ff 75 0c             	push   0xc(%ebp)
c0104df7:	ff 75 f4             	push   -0xc(%ebp)
c0104dfa:	ff 75 08             	push   0x8(%ebp)
c0104dfd:	e8 c5 fe ff ff       	call   c0104cc7 <page_insert>
c0104e02:	83 c4 10             	add    $0x10,%esp
c0104e05:	85 c0                	test   %eax,%eax
c0104e07:	74 17                	je     c0104e20 <pgdir_alloc_page+0x4f>
            free_page(page);
c0104e09:	83 ec 08             	sub    $0x8,%esp
c0104e0c:	6a 01                	push   $0x1
c0104e0e:	ff 75 f4             	push   -0xc(%ebp)
c0104e11:	e8 c2 f6 ff ff       	call   c01044d8 <free_pages>
c0104e16:	83 c4 10             	add    $0x10,%esp
            return NULL;
c0104e19:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e1e:	eb 57                	jmp    c0104e77 <pgdir_alloc_page+0xa6>
        }
        if (swap_init_ok){
c0104e20:	a1 44 60 12 c0       	mov    0xc0126044,%eax
c0104e25:	85 c0                	test   %eax,%eax
c0104e27:	74 4b                	je     c0104e74 <pgdir_alloc_page+0xa3>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0104e29:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c0104e2e:	6a 00                	push   $0x0
c0104e30:	ff 75 f4             	push   -0xc(%ebp)
c0104e33:	ff 75 0c             	push   0xc(%ebp)
c0104e36:	50                   	push   %eax
c0104e37:	e8 53 0d 00 00       	call   c0105b8f <swap_map_swappable>
c0104e3c:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr=la;
c0104e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e42:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e45:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0104e48:	83 ec 0c             	sub    $0xc,%esp
c0104e4b:	ff 75 f4             	push   -0xc(%ebp)
c0104e4e:	e8 0a f4 ff ff       	call   c010425d <page_ref>
c0104e53:	83 c4 10             	add    $0x10,%esp
c0104e56:	83 f8 01             	cmp    $0x1,%eax
c0104e59:	74 19                	je     c0104e74 <pgdir_alloc_page+0xa3>
c0104e5b:	68 f4 90 10 c0       	push   $0xc01090f4
c0104e60:	68 b9 90 10 c0       	push   $0xc01090b9
c0104e65:	68 f7 01 00 00       	push   $0x1f7
c0104e6a:	68 94 90 10 c0       	push   $0xc0109094
c0104e6f:	e8 2b be ff ff       	call   c0100c9f <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0104e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e77:	c9                   	leave  
c0104e78:	c3                   	ret    

c0104e79 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104e79:	55                   	push   %ebp
c0104e7a:	89 e5                	mov    %esp,%ebp
c0104e7c:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0104e7f:	a1 ac 5f 12 c0       	mov    0xc0125fac,%eax
c0104e84:	8b 40 18             	mov    0x18(%eax),%eax
c0104e87:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104e89:	83 ec 0c             	sub    $0xc,%esp
c0104e8c:	68 08 91 10 c0       	push   $0xc0109108
c0104e91:	e8 aa b4 ff ff       	call   c0100340 <cprintf>
c0104e96:	83 c4 10             	add    $0x10,%esp
}
c0104e99:	90                   	nop
c0104e9a:	c9                   	leave  
c0104e9b:	c3                   	ret    

c0104e9c <check_pgdir>:

static void
check_pgdir(void) {
c0104e9c:	55                   	push   %ebp
c0104e9d:	89 e5                	mov    %esp,%ebp
c0104e9f:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104ea2:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0104ea7:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104eac:	76 19                	jbe    c0104ec7 <check_pgdir+0x2b>
c0104eae:	68 27 91 10 c0       	push   $0xc0109127
c0104eb3:	68 b9 90 10 c0       	push   $0xc01090b9
c0104eb8:	68 08 02 00 00       	push   $0x208
c0104ebd:	68 94 90 10 c0       	push   $0xc0109094
c0104ec2:	e8 d8 bd ff ff       	call   c0100c9f <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104ec7:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104ecc:	85 c0                	test   %eax,%eax
c0104ece:	74 0e                	je     c0104ede <check_pgdir+0x42>
c0104ed0:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104ed5:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104eda:	85 c0                	test   %eax,%eax
c0104edc:	74 19                	je     c0104ef7 <check_pgdir+0x5b>
c0104ede:	68 44 91 10 c0       	push   $0xc0109144
c0104ee3:	68 b9 90 10 c0       	push   $0xc01090b9
c0104ee8:	68 09 02 00 00       	push   $0x209
c0104eed:	68 94 90 10 c0       	push   $0xc0109094
c0104ef2:	e8 a8 bd ff ff       	call   c0100c9f <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104ef7:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104efc:	83 ec 04             	sub    $0x4,%esp
c0104eff:	6a 00                	push   $0x0
c0104f01:	6a 00                	push   $0x0
c0104f03:	50                   	push   %eax
c0104f04:	e8 ca fc ff ff       	call   c0104bd3 <get_page>
c0104f09:	83 c4 10             	add    $0x10,%esp
c0104f0c:	85 c0                	test   %eax,%eax
c0104f0e:	74 19                	je     c0104f29 <check_pgdir+0x8d>
c0104f10:	68 7c 91 10 c0       	push   $0xc010917c
c0104f15:	68 b9 90 10 c0       	push   $0xc01090b9
c0104f1a:	68 0a 02 00 00       	push   $0x20a
c0104f1f:	68 94 90 10 c0       	push   $0xc0109094
c0104f24:	e8 76 bd ff ff       	call   c0100c9f <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104f29:	83 ec 0c             	sub    $0xc,%esp
c0104f2c:	6a 01                	push   $0x1
c0104f2e:	e8 39 f5 ff ff       	call   c010446c <alloc_pages>
c0104f33:	83 c4 10             	add    $0x10,%esp
c0104f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104f39:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104f3e:	6a 00                	push   $0x0
c0104f40:	6a 00                	push   $0x0
c0104f42:	ff 75 f4             	push   -0xc(%ebp)
c0104f45:	50                   	push   %eax
c0104f46:	e8 7c fd ff ff       	call   c0104cc7 <page_insert>
c0104f4b:	83 c4 10             	add    $0x10,%esp
c0104f4e:	85 c0                	test   %eax,%eax
c0104f50:	74 19                	je     c0104f6b <check_pgdir+0xcf>
c0104f52:	68 a4 91 10 c0       	push   $0xc01091a4
c0104f57:	68 b9 90 10 c0       	push   $0xc01090b9
c0104f5c:	68 0e 02 00 00       	push   $0x20e
c0104f61:	68 94 90 10 c0       	push   $0xc0109094
c0104f66:	e8 34 bd ff ff       	call   c0100c9f <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104f6b:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0104f70:	83 ec 04             	sub    $0x4,%esp
c0104f73:	6a 00                	push   $0x0
c0104f75:	6a 00                	push   $0x0
c0104f77:	50                   	push   %eax
c0104f78:	e8 39 fb ff ff       	call   c0104ab6 <get_pte>
c0104f7d:	83 c4 10             	add    $0x10,%esp
c0104f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f87:	75 19                	jne    c0104fa2 <check_pgdir+0x106>
c0104f89:	68 d0 91 10 c0       	push   $0xc01091d0
c0104f8e:	68 b9 90 10 c0       	push   $0xc01090b9
c0104f93:	68 11 02 00 00       	push   $0x211
c0104f98:	68 94 90 10 c0       	push   $0xc0109094
c0104f9d:	e8 fd bc ff ff       	call   c0100c9f <__panic>
    assert(pte2page(*ptep) == p1);
c0104fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fa5:	8b 00                	mov    (%eax),%eax
c0104fa7:	83 ec 0c             	sub    $0xc,%esp
c0104faa:	50                   	push   %eax
c0104fab:	e8 57 f2 ff ff       	call   c0104207 <pte2page>
c0104fb0:	83 c4 10             	add    $0x10,%esp
c0104fb3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104fb6:	74 19                	je     c0104fd1 <check_pgdir+0x135>
c0104fb8:	68 fd 91 10 c0       	push   $0xc01091fd
c0104fbd:	68 b9 90 10 c0       	push   $0xc01090b9
c0104fc2:	68 12 02 00 00       	push   $0x212
c0104fc7:	68 94 90 10 c0       	push   $0xc0109094
c0104fcc:	e8 ce bc ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p1) == 1);
c0104fd1:	83 ec 0c             	sub    $0xc,%esp
c0104fd4:	ff 75 f4             	push   -0xc(%ebp)
c0104fd7:	e8 81 f2 ff ff       	call   c010425d <page_ref>
c0104fdc:	83 c4 10             	add    $0x10,%esp
c0104fdf:	83 f8 01             	cmp    $0x1,%eax
c0104fe2:	74 19                	je     c0104ffd <check_pgdir+0x161>
c0104fe4:	68 13 92 10 c0       	push   $0xc0109213
c0104fe9:	68 b9 90 10 c0       	push   $0xc01090b9
c0104fee:	68 13 02 00 00       	push   $0x213
c0104ff3:	68 94 90 10 c0       	push   $0xc0109094
c0104ff8:	e8 a2 bc ff ff       	call   c0100c9f <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104ffd:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105002:	8b 00                	mov    (%eax),%eax
c0105004:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105009:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010500c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010500f:	c1 e8 0c             	shr    $0xc,%eax
c0105012:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105015:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c010501a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010501d:	72 17                	jb     c0105036 <check_pgdir+0x19a>
c010501f:	ff 75 ec             	push   -0x14(%ebp)
c0105022:	68 cc 8f 10 c0       	push   $0xc0108fcc
c0105027:	68 15 02 00 00       	push   $0x215
c010502c:	68 94 90 10 c0       	push   $0xc0109094
c0105031:	e8 69 bc ff ff       	call   c0100c9f <__panic>
c0105036:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105039:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010503e:	83 c0 04             	add    $0x4,%eax
c0105041:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105044:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105049:	83 ec 04             	sub    $0x4,%esp
c010504c:	6a 00                	push   $0x0
c010504e:	68 00 10 00 00       	push   $0x1000
c0105053:	50                   	push   %eax
c0105054:	e8 5d fa ff ff       	call   c0104ab6 <get_pte>
c0105059:	83 c4 10             	add    $0x10,%esp
c010505c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010505f:	74 19                	je     c010507a <check_pgdir+0x1de>
c0105061:	68 28 92 10 c0       	push   $0xc0109228
c0105066:	68 b9 90 10 c0       	push   $0xc01090b9
c010506b:	68 16 02 00 00       	push   $0x216
c0105070:	68 94 90 10 c0       	push   $0xc0109094
c0105075:	e8 25 bc ff ff       	call   c0100c9f <__panic>

    p2 = alloc_page();
c010507a:	83 ec 0c             	sub    $0xc,%esp
c010507d:	6a 01                	push   $0x1
c010507f:	e8 e8 f3 ff ff       	call   c010446c <alloc_pages>
c0105084:	83 c4 10             	add    $0x10,%esp
c0105087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010508a:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c010508f:	6a 06                	push   $0x6
c0105091:	68 00 10 00 00       	push   $0x1000
c0105096:	ff 75 e4             	push   -0x1c(%ebp)
c0105099:	50                   	push   %eax
c010509a:	e8 28 fc ff ff       	call   c0104cc7 <page_insert>
c010509f:	83 c4 10             	add    $0x10,%esp
c01050a2:	85 c0                	test   %eax,%eax
c01050a4:	74 19                	je     c01050bf <check_pgdir+0x223>
c01050a6:	68 50 92 10 c0       	push   $0xc0109250
c01050ab:	68 b9 90 10 c0       	push   $0xc01090b9
c01050b0:	68 19 02 00 00       	push   $0x219
c01050b5:	68 94 90 10 c0       	push   $0xc0109094
c01050ba:	e8 e0 bb ff ff       	call   c0100c9f <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01050bf:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01050c4:	83 ec 04             	sub    $0x4,%esp
c01050c7:	6a 00                	push   $0x0
c01050c9:	68 00 10 00 00       	push   $0x1000
c01050ce:	50                   	push   %eax
c01050cf:	e8 e2 f9 ff ff       	call   c0104ab6 <get_pte>
c01050d4:	83 c4 10             	add    $0x10,%esp
c01050d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01050de:	75 19                	jne    c01050f9 <check_pgdir+0x25d>
c01050e0:	68 88 92 10 c0       	push   $0xc0109288
c01050e5:	68 b9 90 10 c0       	push   $0xc01090b9
c01050ea:	68 1a 02 00 00       	push   $0x21a
c01050ef:	68 94 90 10 c0       	push   $0xc0109094
c01050f4:	e8 a6 bb ff ff       	call   c0100c9f <__panic>
    assert(*ptep & PTE_U);
c01050f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050fc:	8b 00                	mov    (%eax),%eax
c01050fe:	83 e0 04             	and    $0x4,%eax
c0105101:	85 c0                	test   %eax,%eax
c0105103:	75 19                	jne    c010511e <check_pgdir+0x282>
c0105105:	68 b8 92 10 c0       	push   $0xc01092b8
c010510a:	68 b9 90 10 c0       	push   $0xc01090b9
c010510f:	68 1b 02 00 00       	push   $0x21b
c0105114:	68 94 90 10 c0       	push   $0xc0109094
c0105119:	e8 81 bb ff ff       	call   c0100c9f <__panic>
    assert(*ptep & PTE_W);
c010511e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105121:	8b 00                	mov    (%eax),%eax
c0105123:	83 e0 02             	and    $0x2,%eax
c0105126:	85 c0                	test   %eax,%eax
c0105128:	75 19                	jne    c0105143 <check_pgdir+0x2a7>
c010512a:	68 c6 92 10 c0       	push   $0xc01092c6
c010512f:	68 b9 90 10 c0       	push   $0xc01090b9
c0105134:	68 1c 02 00 00       	push   $0x21c
c0105139:	68 94 90 10 c0       	push   $0xc0109094
c010513e:	e8 5c bb ff ff       	call   c0100c9f <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105143:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105148:	8b 00                	mov    (%eax),%eax
c010514a:	83 e0 04             	and    $0x4,%eax
c010514d:	85 c0                	test   %eax,%eax
c010514f:	75 19                	jne    c010516a <check_pgdir+0x2ce>
c0105151:	68 d4 92 10 c0       	push   $0xc01092d4
c0105156:	68 b9 90 10 c0       	push   $0xc01090b9
c010515b:	68 1d 02 00 00       	push   $0x21d
c0105160:	68 94 90 10 c0       	push   $0xc0109094
c0105165:	e8 35 bb ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p2) == 1);
c010516a:	83 ec 0c             	sub    $0xc,%esp
c010516d:	ff 75 e4             	push   -0x1c(%ebp)
c0105170:	e8 e8 f0 ff ff       	call   c010425d <page_ref>
c0105175:	83 c4 10             	add    $0x10,%esp
c0105178:	83 f8 01             	cmp    $0x1,%eax
c010517b:	74 19                	je     c0105196 <check_pgdir+0x2fa>
c010517d:	68 ea 92 10 c0       	push   $0xc01092ea
c0105182:	68 b9 90 10 c0       	push   $0xc01090b9
c0105187:	68 1e 02 00 00       	push   $0x21e
c010518c:	68 94 90 10 c0       	push   $0xc0109094
c0105191:	e8 09 bb ff ff       	call   c0100c9f <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105196:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c010519b:	6a 00                	push   $0x0
c010519d:	68 00 10 00 00       	push   $0x1000
c01051a2:	ff 75 f4             	push   -0xc(%ebp)
c01051a5:	50                   	push   %eax
c01051a6:	e8 1c fb ff ff       	call   c0104cc7 <page_insert>
c01051ab:	83 c4 10             	add    $0x10,%esp
c01051ae:	85 c0                	test   %eax,%eax
c01051b0:	74 19                	je     c01051cb <check_pgdir+0x32f>
c01051b2:	68 fc 92 10 c0       	push   $0xc01092fc
c01051b7:	68 b9 90 10 c0       	push   $0xc01090b9
c01051bc:	68 20 02 00 00       	push   $0x220
c01051c1:	68 94 90 10 c0       	push   $0xc0109094
c01051c6:	e8 d4 ba ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p1) == 2);
c01051cb:	83 ec 0c             	sub    $0xc,%esp
c01051ce:	ff 75 f4             	push   -0xc(%ebp)
c01051d1:	e8 87 f0 ff ff       	call   c010425d <page_ref>
c01051d6:	83 c4 10             	add    $0x10,%esp
c01051d9:	83 f8 02             	cmp    $0x2,%eax
c01051dc:	74 19                	je     c01051f7 <check_pgdir+0x35b>
c01051de:	68 28 93 10 c0       	push   $0xc0109328
c01051e3:	68 b9 90 10 c0       	push   $0xc01090b9
c01051e8:	68 21 02 00 00       	push   $0x221
c01051ed:	68 94 90 10 c0       	push   $0xc0109094
c01051f2:	e8 a8 ba ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p2) == 0);
c01051f7:	83 ec 0c             	sub    $0xc,%esp
c01051fa:	ff 75 e4             	push   -0x1c(%ebp)
c01051fd:	e8 5b f0 ff ff       	call   c010425d <page_ref>
c0105202:	83 c4 10             	add    $0x10,%esp
c0105205:	85 c0                	test   %eax,%eax
c0105207:	74 19                	je     c0105222 <check_pgdir+0x386>
c0105209:	68 3a 93 10 c0       	push   $0xc010933a
c010520e:	68 b9 90 10 c0       	push   $0xc01090b9
c0105213:	68 22 02 00 00       	push   $0x222
c0105218:	68 94 90 10 c0       	push   $0xc0109094
c010521d:	e8 7d ba ff ff       	call   c0100c9f <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105222:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105227:	83 ec 04             	sub    $0x4,%esp
c010522a:	6a 00                	push   $0x0
c010522c:	68 00 10 00 00       	push   $0x1000
c0105231:	50                   	push   %eax
c0105232:	e8 7f f8 ff ff       	call   c0104ab6 <get_pte>
c0105237:	83 c4 10             	add    $0x10,%esp
c010523a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010523d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105241:	75 19                	jne    c010525c <check_pgdir+0x3c0>
c0105243:	68 88 92 10 c0       	push   $0xc0109288
c0105248:	68 b9 90 10 c0       	push   $0xc01090b9
c010524d:	68 23 02 00 00       	push   $0x223
c0105252:	68 94 90 10 c0       	push   $0xc0109094
c0105257:	e8 43 ba ff ff       	call   c0100c9f <__panic>
    assert(pte2page(*ptep) == p1);
c010525c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010525f:	8b 00                	mov    (%eax),%eax
c0105261:	83 ec 0c             	sub    $0xc,%esp
c0105264:	50                   	push   %eax
c0105265:	e8 9d ef ff ff       	call   c0104207 <pte2page>
c010526a:	83 c4 10             	add    $0x10,%esp
c010526d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105270:	74 19                	je     c010528b <check_pgdir+0x3ef>
c0105272:	68 fd 91 10 c0       	push   $0xc01091fd
c0105277:	68 b9 90 10 c0       	push   $0xc01090b9
c010527c:	68 24 02 00 00       	push   $0x224
c0105281:	68 94 90 10 c0       	push   $0xc0109094
c0105286:	e8 14 ba ff ff       	call   c0100c9f <__panic>
    assert((*ptep & PTE_U) == 0);
c010528b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010528e:	8b 00                	mov    (%eax),%eax
c0105290:	83 e0 04             	and    $0x4,%eax
c0105293:	85 c0                	test   %eax,%eax
c0105295:	74 19                	je     c01052b0 <check_pgdir+0x414>
c0105297:	68 4c 93 10 c0       	push   $0xc010934c
c010529c:	68 b9 90 10 c0       	push   $0xc01090b9
c01052a1:	68 25 02 00 00       	push   $0x225
c01052a6:	68 94 90 10 c0       	push   $0xc0109094
c01052ab:	e8 ef b9 ff ff       	call   c0100c9f <__panic>

    page_remove(boot_pgdir, 0x0);
c01052b0:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01052b5:	83 ec 08             	sub    $0x8,%esp
c01052b8:	6a 00                	push   $0x0
c01052ba:	50                   	push   %eax
c01052bb:	e8 ce f9 ff ff       	call   c0104c8e <page_remove>
c01052c0:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01052c3:	83 ec 0c             	sub    $0xc,%esp
c01052c6:	ff 75 f4             	push   -0xc(%ebp)
c01052c9:	e8 8f ef ff ff       	call   c010425d <page_ref>
c01052ce:	83 c4 10             	add    $0x10,%esp
c01052d1:	83 f8 01             	cmp    $0x1,%eax
c01052d4:	74 19                	je     c01052ef <check_pgdir+0x453>
c01052d6:	68 13 92 10 c0       	push   $0xc0109213
c01052db:	68 b9 90 10 c0       	push   $0xc01090b9
c01052e0:	68 28 02 00 00       	push   $0x228
c01052e5:	68 94 90 10 c0       	push   $0xc0109094
c01052ea:	e8 b0 b9 ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p2) == 0);
c01052ef:	83 ec 0c             	sub    $0xc,%esp
c01052f2:	ff 75 e4             	push   -0x1c(%ebp)
c01052f5:	e8 63 ef ff ff       	call   c010425d <page_ref>
c01052fa:	83 c4 10             	add    $0x10,%esp
c01052fd:	85 c0                	test   %eax,%eax
c01052ff:	74 19                	je     c010531a <check_pgdir+0x47e>
c0105301:	68 3a 93 10 c0       	push   $0xc010933a
c0105306:	68 b9 90 10 c0       	push   $0xc01090b9
c010530b:	68 29 02 00 00       	push   $0x229
c0105310:	68 94 90 10 c0       	push   $0xc0109094
c0105315:	e8 85 b9 ff ff       	call   c0100c9f <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010531a:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c010531f:	83 ec 08             	sub    $0x8,%esp
c0105322:	68 00 10 00 00       	push   $0x1000
c0105327:	50                   	push   %eax
c0105328:	e8 61 f9 ff ff       	call   c0104c8e <page_remove>
c010532d:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0105330:	83 ec 0c             	sub    $0xc,%esp
c0105333:	ff 75 f4             	push   -0xc(%ebp)
c0105336:	e8 22 ef ff ff       	call   c010425d <page_ref>
c010533b:	83 c4 10             	add    $0x10,%esp
c010533e:	85 c0                	test   %eax,%eax
c0105340:	74 19                	je     c010535b <check_pgdir+0x4bf>
c0105342:	68 61 93 10 c0       	push   $0xc0109361
c0105347:	68 b9 90 10 c0       	push   $0xc01090b9
c010534c:	68 2c 02 00 00       	push   $0x22c
c0105351:	68 94 90 10 c0       	push   $0xc0109094
c0105356:	e8 44 b9 ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p2) == 0);
c010535b:	83 ec 0c             	sub    $0xc,%esp
c010535e:	ff 75 e4             	push   -0x1c(%ebp)
c0105361:	e8 f7 ee ff ff       	call   c010425d <page_ref>
c0105366:	83 c4 10             	add    $0x10,%esp
c0105369:	85 c0                	test   %eax,%eax
c010536b:	74 19                	je     c0105386 <check_pgdir+0x4ea>
c010536d:	68 3a 93 10 c0       	push   $0xc010933a
c0105372:	68 b9 90 10 c0       	push   $0xc01090b9
c0105377:	68 2d 02 00 00       	push   $0x22d
c010537c:	68 94 90 10 c0       	push   $0xc0109094
c0105381:	e8 19 b9 ff ff       	call   c0100c9f <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105386:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c010538b:	8b 00                	mov    (%eax),%eax
c010538d:	83 ec 0c             	sub    $0xc,%esp
c0105390:	50                   	push   %eax
c0105391:	e8 ab ee ff ff       	call   c0104241 <pde2page>
c0105396:	83 c4 10             	add    $0x10,%esp
c0105399:	83 ec 0c             	sub    $0xc,%esp
c010539c:	50                   	push   %eax
c010539d:	e8 bb ee ff ff       	call   c010425d <page_ref>
c01053a2:	83 c4 10             	add    $0x10,%esp
c01053a5:	83 f8 01             	cmp    $0x1,%eax
c01053a8:	74 19                	je     c01053c3 <check_pgdir+0x527>
c01053aa:	68 74 93 10 c0       	push   $0xc0109374
c01053af:	68 b9 90 10 c0       	push   $0xc01090b9
c01053b4:	68 2f 02 00 00       	push   $0x22f
c01053b9:	68 94 90 10 c0       	push   $0xc0109094
c01053be:	e8 dc b8 ff ff       	call   c0100c9f <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01053c3:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01053c8:	8b 00                	mov    (%eax),%eax
c01053ca:	83 ec 0c             	sub    $0xc,%esp
c01053cd:	50                   	push   %eax
c01053ce:	e8 6e ee ff ff       	call   c0104241 <pde2page>
c01053d3:	83 c4 10             	add    $0x10,%esp
c01053d6:	83 ec 08             	sub    $0x8,%esp
c01053d9:	6a 01                	push   $0x1
c01053db:	50                   	push   %eax
c01053dc:	e8 f7 f0 ff ff       	call   c01044d8 <free_pages>
c01053e1:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01053e4:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01053e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01053ef:	83 ec 0c             	sub    $0xc,%esp
c01053f2:	68 9b 93 10 c0       	push   $0xc010939b
c01053f7:	e8 44 af ff ff       	call   c0100340 <cprintf>
c01053fc:	83 c4 10             	add    $0x10,%esp
}
c01053ff:	90                   	nop
c0105400:	c9                   	leave  
c0105401:	c3                   	ret    

c0105402 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105402:	55                   	push   %ebp
c0105403:	89 e5                	mov    %esp,%ebp
c0105405:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105408:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010540f:	e9 a3 00 00 00       	jmp    c01054b7 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105414:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010541a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010541d:	c1 e8 0c             	shr    $0xc,%eax
c0105420:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105423:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0105428:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010542b:	72 17                	jb     c0105444 <check_boot_pgdir+0x42>
c010542d:	ff 75 e4             	push   -0x1c(%ebp)
c0105430:	68 cc 8f 10 c0       	push   $0xc0108fcc
c0105435:	68 3b 02 00 00       	push   $0x23b
c010543a:	68 94 90 10 c0       	push   $0xc0109094
c010543f:	e8 5b b8 ff ff       	call   c0100c9f <__panic>
c0105444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105447:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010544c:	89 c2                	mov    %eax,%edx
c010544e:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105453:	83 ec 04             	sub    $0x4,%esp
c0105456:	6a 00                	push   $0x0
c0105458:	52                   	push   %edx
c0105459:	50                   	push   %eax
c010545a:	e8 57 f6 ff ff       	call   c0104ab6 <get_pte>
c010545f:	83 c4 10             	add    $0x10,%esp
c0105462:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105465:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105469:	75 19                	jne    c0105484 <check_boot_pgdir+0x82>
c010546b:	68 b8 93 10 c0       	push   $0xc01093b8
c0105470:	68 b9 90 10 c0       	push   $0xc01090b9
c0105475:	68 3b 02 00 00       	push   $0x23b
c010547a:	68 94 90 10 c0       	push   $0xc0109094
c010547f:	e8 1b b8 ff ff       	call   c0100c9f <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105484:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105487:	8b 00                	mov    (%eax),%eax
c0105489:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010548e:	89 c2                	mov    %eax,%edx
c0105490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105493:	39 c2                	cmp    %eax,%edx
c0105495:	74 19                	je     c01054b0 <check_boot_pgdir+0xae>
c0105497:	68 f5 93 10 c0       	push   $0xc01093f5
c010549c:	68 b9 90 10 c0       	push   $0xc01090b9
c01054a1:	68 3c 02 00 00       	push   $0x23c
c01054a6:	68 94 90 10 c0       	push   $0xc0109094
c01054ab:	e8 ef b7 ff ff       	call   c0100c9f <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01054b0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01054b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054ba:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c01054bf:	39 c2                	cmp    %eax,%edx
c01054c1:	0f 82 4d ff ff ff    	jb     c0105414 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01054c7:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01054cc:	05 ac 0f 00 00       	add    $0xfac,%eax
c01054d1:	8b 00                	mov    (%eax),%eax
c01054d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054d8:	89 c2                	mov    %eax,%edx
c01054da:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01054df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054e2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01054e9:	77 17                	ja     c0105502 <check_boot_pgdir+0x100>
c01054eb:	ff 75 f0             	push   -0x10(%ebp)
c01054ee:	68 f0 8f 10 c0       	push   $0xc0108ff0
c01054f3:	68 3f 02 00 00       	push   $0x23f
c01054f8:	68 94 90 10 c0       	push   $0xc0109094
c01054fd:	e8 9d b7 ff ff       	call   c0100c9f <__panic>
c0105502:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105505:	05 00 00 00 40       	add    $0x40000000,%eax
c010550a:	39 d0                	cmp    %edx,%eax
c010550c:	74 19                	je     c0105527 <check_boot_pgdir+0x125>
c010550e:	68 0c 94 10 c0       	push   $0xc010940c
c0105513:	68 b9 90 10 c0       	push   $0xc01090b9
c0105518:	68 3f 02 00 00       	push   $0x23f
c010551d:	68 94 90 10 c0       	push   $0xc0109094
c0105522:	e8 78 b7 ff ff       	call   c0100c9f <__panic>

    assert(boot_pgdir[0] == 0);
c0105527:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c010552c:	8b 00                	mov    (%eax),%eax
c010552e:	85 c0                	test   %eax,%eax
c0105530:	74 19                	je     c010554b <check_boot_pgdir+0x149>
c0105532:	68 40 94 10 c0       	push   $0xc0109440
c0105537:	68 b9 90 10 c0       	push   $0xc01090b9
c010553c:	68 41 02 00 00       	push   $0x241
c0105541:	68 94 90 10 c0       	push   $0xc0109094
c0105546:	e8 54 b7 ff ff       	call   c0100c9f <__panic>

    struct Page *p;
    p = alloc_page();
c010554b:	83 ec 0c             	sub    $0xc,%esp
c010554e:	6a 01                	push   $0x1
c0105550:	e8 17 ef ff ff       	call   c010446c <alloc_pages>
c0105555:	83 c4 10             	add    $0x10,%esp
c0105558:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010555b:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c0105560:	6a 02                	push   $0x2
c0105562:	68 00 01 00 00       	push   $0x100
c0105567:	ff 75 ec             	push   -0x14(%ebp)
c010556a:	50                   	push   %eax
c010556b:	e8 57 f7 ff ff       	call   c0104cc7 <page_insert>
c0105570:	83 c4 10             	add    $0x10,%esp
c0105573:	85 c0                	test   %eax,%eax
c0105575:	74 19                	je     c0105590 <check_boot_pgdir+0x18e>
c0105577:	68 54 94 10 c0       	push   $0xc0109454
c010557c:	68 b9 90 10 c0       	push   $0xc01090b9
c0105581:	68 45 02 00 00       	push   $0x245
c0105586:	68 94 90 10 c0       	push   $0xc0109094
c010558b:	e8 0f b7 ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p) == 1);
c0105590:	83 ec 0c             	sub    $0xc,%esp
c0105593:	ff 75 ec             	push   -0x14(%ebp)
c0105596:	e8 c2 ec ff ff       	call   c010425d <page_ref>
c010559b:	83 c4 10             	add    $0x10,%esp
c010559e:	83 f8 01             	cmp    $0x1,%eax
c01055a1:	74 19                	je     c01055bc <check_boot_pgdir+0x1ba>
c01055a3:	68 82 94 10 c0       	push   $0xc0109482
c01055a8:	68 b9 90 10 c0       	push   $0xc01090b9
c01055ad:	68 46 02 00 00       	push   $0x246
c01055b2:	68 94 90 10 c0       	push   $0xc0109094
c01055b7:	e8 e3 b6 ff ff       	call   c0100c9f <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01055bc:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01055c1:	6a 02                	push   $0x2
c01055c3:	68 00 11 00 00       	push   $0x1100
c01055c8:	ff 75 ec             	push   -0x14(%ebp)
c01055cb:	50                   	push   %eax
c01055cc:	e8 f6 f6 ff ff       	call   c0104cc7 <page_insert>
c01055d1:	83 c4 10             	add    $0x10,%esp
c01055d4:	85 c0                	test   %eax,%eax
c01055d6:	74 19                	je     c01055f1 <check_boot_pgdir+0x1ef>
c01055d8:	68 94 94 10 c0       	push   $0xc0109494
c01055dd:	68 b9 90 10 c0       	push   $0xc01090b9
c01055e2:	68 47 02 00 00       	push   $0x247
c01055e7:	68 94 90 10 c0       	push   $0xc0109094
c01055ec:	e8 ae b6 ff ff       	call   c0100c9f <__panic>
    assert(page_ref(p) == 2);
c01055f1:	83 ec 0c             	sub    $0xc,%esp
c01055f4:	ff 75 ec             	push   -0x14(%ebp)
c01055f7:	e8 61 ec ff ff       	call   c010425d <page_ref>
c01055fc:	83 c4 10             	add    $0x10,%esp
c01055ff:	83 f8 02             	cmp    $0x2,%eax
c0105602:	74 19                	je     c010561d <check_boot_pgdir+0x21b>
c0105604:	68 cb 94 10 c0       	push   $0xc01094cb
c0105609:	68 b9 90 10 c0       	push   $0xc01090b9
c010560e:	68 48 02 00 00       	push   $0x248
c0105613:	68 94 90 10 c0       	push   $0xc0109094
c0105618:	e8 82 b6 ff ff       	call   c0100c9f <__panic>

    const char *str = "ucore: Hello world!!";
c010561d:	c7 45 e8 dc 94 10 c0 	movl   $0xc01094dc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105624:	83 ec 08             	sub    $0x8,%esp
c0105627:	ff 75 e8             	push   -0x18(%ebp)
c010562a:	68 00 01 00 00       	push   $0x100
c010562f:	e8 3c 28 00 00       	call   c0107e70 <strcpy>
c0105634:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105637:	83 ec 08             	sub    $0x8,%esp
c010563a:	68 00 11 00 00       	push   $0x1100
c010563f:	68 00 01 00 00       	push   $0x100
c0105644:	e8 a0 28 00 00       	call   c0107ee9 <strcmp>
c0105649:	83 c4 10             	add    $0x10,%esp
c010564c:	85 c0                	test   %eax,%eax
c010564e:	74 19                	je     c0105669 <check_boot_pgdir+0x267>
c0105650:	68 f4 94 10 c0       	push   $0xc01094f4
c0105655:	68 b9 90 10 c0       	push   $0xc01090b9
c010565a:	68 4c 02 00 00       	push   $0x24c
c010565f:	68 94 90 10 c0       	push   $0xc0109094
c0105664:	e8 36 b6 ff ff       	call   c0100c9f <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105669:	83 ec 0c             	sub    $0xc,%esp
c010566c:	ff 75 ec             	push   -0x14(%ebp)
c010566f:	e8 0f eb ff ff       	call   c0104183 <page2kva>
c0105674:	83 c4 10             	add    $0x10,%esp
c0105677:	05 00 01 00 00       	add    $0x100,%eax
c010567c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010567f:	83 ec 0c             	sub    $0xc,%esp
c0105682:	68 00 01 00 00       	push   $0x100
c0105687:	e8 8c 27 00 00       	call   c0107e18 <strlen>
c010568c:	83 c4 10             	add    $0x10,%esp
c010568f:	85 c0                	test   %eax,%eax
c0105691:	74 19                	je     c01056ac <check_boot_pgdir+0x2aa>
c0105693:	68 2c 95 10 c0       	push   $0xc010952c
c0105698:	68 b9 90 10 c0       	push   $0xc01090b9
c010569d:	68 4f 02 00 00       	push   $0x24f
c01056a2:	68 94 90 10 c0       	push   $0xc0109094
c01056a7:	e8 f3 b5 ff ff       	call   c0100c9f <__panic>

    free_page(p);
c01056ac:	83 ec 08             	sub    $0x8,%esp
c01056af:	6a 01                	push   $0x1
c01056b1:	ff 75 ec             	push   -0x14(%ebp)
c01056b4:	e8 1f ee ff ff       	call   c01044d8 <free_pages>
c01056b9:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c01056bc:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01056c1:	8b 00                	mov    (%eax),%eax
c01056c3:	83 ec 0c             	sub    $0xc,%esp
c01056c6:	50                   	push   %eax
c01056c7:	e8 75 eb ff ff       	call   c0104241 <pde2page>
c01056cc:	83 c4 10             	add    $0x10,%esp
c01056cf:	83 ec 08             	sub    $0x8,%esp
c01056d2:	6a 01                	push   $0x1
c01056d4:	50                   	push   %eax
c01056d5:	e8 fe ed ff ff       	call   c01044d8 <free_pages>
c01056da:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c01056dd:	a1 e0 29 12 c0       	mov    0xc01229e0,%eax
c01056e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01056e8:	83 ec 0c             	sub    $0xc,%esp
c01056eb:	68 50 95 10 c0       	push   $0xc0109550
c01056f0:	e8 4b ac ff ff       	call   c0100340 <cprintf>
c01056f5:	83 c4 10             	add    $0x10,%esp
}
c01056f8:	90                   	nop
c01056f9:	c9                   	leave  
c01056fa:	c3                   	ret    

c01056fb <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01056fb:	55                   	push   %ebp
c01056fc:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01056fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105701:	83 e0 04             	and    $0x4,%eax
c0105704:	85 c0                	test   %eax,%eax
c0105706:	74 07                	je     c010570f <perm2str+0x14>
c0105708:	b8 75 00 00 00       	mov    $0x75,%eax
c010570d:	eb 05                	jmp    c0105714 <perm2str+0x19>
c010570f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105714:	a2 28 60 12 c0       	mov    %al,0xc0126028
    str[1] = 'r';
c0105719:	c6 05 29 60 12 c0 72 	movb   $0x72,0xc0126029
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105720:	8b 45 08             	mov    0x8(%ebp),%eax
c0105723:	83 e0 02             	and    $0x2,%eax
c0105726:	85 c0                	test   %eax,%eax
c0105728:	74 07                	je     c0105731 <perm2str+0x36>
c010572a:	b8 77 00 00 00       	mov    $0x77,%eax
c010572f:	eb 05                	jmp    c0105736 <perm2str+0x3b>
c0105731:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105736:	a2 2a 60 12 c0       	mov    %al,0xc012602a
    str[3] = '\0';
c010573b:	c6 05 2b 60 12 c0 00 	movb   $0x0,0xc012602b
    return str;
c0105742:	b8 28 60 12 c0       	mov    $0xc0126028,%eax
}
c0105747:	5d                   	pop    %ebp
c0105748:	c3                   	ret    

c0105749 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105749:	55                   	push   %ebp
c010574a:	89 e5                	mov    %esp,%ebp
c010574c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010574f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105752:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105755:	72 0e                	jb     c0105765 <get_pgtable_items+0x1c>
        return 0;
c0105757:	b8 00 00 00 00       	mov    $0x0,%eax
c010575c:	e9 9a 00 00 00       	jmp    c01057fb <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105761:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0105765:	8b 45 10             	mov    0x10(%ebp),%eax
c0105768:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010576b:	73 18                	jae    c0105785 <get_pgtable_items+0x3c>
c010576d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105770:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105777:	8b 45 14             	mov    0x14(%ebp),%eax
c010577a:	01 d0                	add    %edx,%eax
c010577c:	8b 00                	mov    (%eax),%eax
c010577e:	83 e0 01             	and    $0x1,%eax
c0105781:	85 c0                	test   %eax,%eax
c0105783:	74 dc                	je     c0105761 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0105785:	8b 45 10             	mov    0x10(%ebp),%eax
c0105788:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010578b:	73 69                	jae    c01057f6 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c010578d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105791:	74 08                	je     c010579b <get_pgtable_items+0x52>
            *left_store = start;
c0105793:	8b 45 18             	mov    0x18(%ebp),%eax
c0105796:	8b 55 10             	mov    0x10(%ebp),%edx
c0105799:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010579b:	8b 45 10             	mov    0x10(%ebp),%eax
c010579e:	8d 50 01             	lea    0x1(%eax),%edx
c01057a1:	89 55 10             	mov    %edx,0x10(%ebp)
c01057a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057ab:	8b 45 14             	mov    0x14(%ebp),%eax
c01057ae:	01 d0                	add    %edx,%eax
c01057b0:	8b 00                	mov    (%eax),%eax
c01057b2:	83 e0 07             	and    $0x7,%eax
c01057b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01057b8:	eb 04                	jmp    c01057be <get_pgtable_items+0x75>
            start ++;
c01057ba:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01057be:	8b 45 10             	mov    0x10(%ebp),%eax
c01057c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01057c4:	73 1d                	jae    c01057e3 <get_pgtable_items+0x9a>
c01057c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01057c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057d0:	8b 45 14             	mov    0x14(%ebp),%eax
c01057d3:	01 d0                	add    %edx,%eax
c01057d5:	8b 00                	mov    (%eax),%eax
c01057d7:	83 e0 07             	and    $0x7,%eax
c01057da:	89 c2                	mov    %eax,%edx
c01057dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057df:	39 c2                	cmp    %eax,%edx
c01057e1:	74 d7                	je     c01057ba <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
c01057e3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01057e7:	74 08                	je     c01057f1 <get_pgtable_items+0xa8>
            *right_store = start;
c01057e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01057ec:	8b 55 10             	mov    0x10(%ebp),%edx
c01057ef:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01057f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057f4:	eb 05                	jmp    c01057fb <get_pgtable_items+0xb2>
    }
    return 0;
c01057f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057fb:	c9                   	leave  
c01057fc:	c3                   	ret    

c01057fd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01057fd:	55                   	push   %ebp
c01057fe:	89 e5                	mov    %esp,%ebp
c0105800:	57                   	push   %edi
c0105801:	56                   	push   %esi
c0105802:	53                   	push   %ebx
c0105803:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105806:	83 ec 0c             	sub    $0xc,%esp
c0105809:	68 70 95 10 c0       	push   $0xc0109570
c010580e:	e8 2d ab ff ff       	call   c0100340 <cprintf>
c0105813:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0105816:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010581d:	e9 d9 00 00 00       	jmp    c01058fb <print_pgdir+0xfe>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105825:	83 ec 0c             	sub    $0xc,%esp
c0105828:	50                   	push   %eax
c0105829:	e8 cd fe ff ff       	call   c01056fb <perm2str>
c010582e:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105831:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105834:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105837:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105839:	89 d6                	mov    %edx,%esi
c010583b:	c1 e6 16             	shl    $0x16,%esi
c010583e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105841:	89 d3                	mov    %edx,%ebx
c0105843:	c1 e3 16             	shl    $0x16,%ebx
c0105846:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105849:	89 d1                	mov    %edx,%ecx
c010584b:	c1 e1 16             	shl    $0x16,%ecx
c010584e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105851:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105854:	29 fa                	sub    %edi,%edx
c0105856:	83 ec 08             	sub    $0x8,%esp
c0105859:	50                   	push   %eax
c010585a:	56                   	push   %esi
c010585b:	53                   	push   %ebx
c010585c:	51                   	push   %ecx
c010585d:	52                   	push   %edx
c010585e:	68 a1 95 10 c0       	push   $0xc01095a1
c0105863:	e8 d8 aa ff ff       	call   c0100340 <cprintf>
c0105868:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c010586b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010586e:	c1 e0 0a             	shl    $0xa,%eax
c0105871:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105874:	eb 49                	jmp    c01058bf <print_pgdir+0xc2>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105879:	83 ec 0c             	sub    $0xc,%esp
c010587c:	50                   	push   %eax
c010587d:	e8 79 fe ff ff       	call   c01056fb <perm2str>
c0105882:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105888:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010588b:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010588d:	89 d6                	mov    %edx,%esi
c010588f:	c1 e6 0c             	shl    $0xc,%esi
c0105892:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105895:	89 d3                	mov    %edx,%ebx
c0105897:	c1 e3 0c             	shl    $0xc,%ebx
c010589a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010589d:	89 d1                	mov    %edx,%ecx
c010589f:	c1 e1 0c             	shl    $0xc,%ecx
c01058a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058a5:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01058a8:	29 fa                	sub    %edi,%edx
c01058aa:	83 ec 08             	sub    $0x8,%esp
c01058ad:	50                   	push   %eax
c01058ae:	56                   	push   %esi
c01058af:	53                   	push   %ebx
c01058b0:	51                   	push   %ecx
c01058b1:	52                   	push   %edx
c01058b2:	68 c0 95 10 c0       	push   $0xc01095c0
c01058b7:	e8 84 aa ff ff       	call   c0100340 <cprintf>
c01058bc:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01058bf:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01058c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01058ca:	89 d3                	mov    %edx,%ebx
c01058cc:	c1 e3 0a             	shl    $0xa,%ebx
c01058cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01058d2:	89 d1                	mov    %edx,%ecx
c01058d4:	c1 e1 0a             	shl    $0xa,%ecx
c01058d7:	83 ec 08             	sub    $0x8,%esp
c01058da:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01058dd:	52                   	push   %edx
c01058de:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01058e1:	52                   	push   %edx
c01058e2:	56                   	push   %esi
c01058e3:	50                   	push   %eax
c01058e4:	53                   	push   %ebx
c01058e5:	51                   	push   %ecx
c01058e6:	e8 5e fe ff ff       	call   c0105749 <get_pgtable_items>
c01058eb:	83 c4 20             	add    $0x20,%esp
c01058ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058f5:	0f 85 7b ff ff ff    	jne    c0105876 <print_pgdir+0x79>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01058fb:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0105900:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105903:	83 ec 08             	sub    $0x8,%esp
c0105906:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105909:	52                   	push   %edx
c010590a:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010590d:	52                   	push   %edx
c010590e:	51                   	push   %ecx
c010590f:	50                   	push   %eax
c0105910:	68 00 04 00 00       	push   $0x400
c0105915:	6a 00                	push   $0x0
c0105917:	e8 2d fe ff ff       	call   c0105749 <get_pgtable_items>
c010591c:	83 c4 20             	add    $0x20,%esp
c010591f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105922:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105926:	0f 85 f6 fe ff ff    	jne    c0105822 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010592c:	83 ec 0c             	sub    $0xc,%esp
c010592f:	68 e4 95 10 c0       	push   $0xc01095e4
c0105934:	e8 07 aa ff ff       	call   c0100340 <cprintf>
c0105939:	83 c4 10             	add    $0x10,%esp
}
c010593c:	90                   	nop
c010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0105940:	5b                   	pop    %ebx
c0105941:	5e                   	pop    %esi
c0105942:	5f                   	pop    %edi
c0105943:	5d                   	pop    %ebp
c0105944:	c3                   	ret    

c0105945 <kmalloc>:

void *
kmalloc(size_t n) {
c0105945:	55                   	push   %ebp
c0105946:	89 e5                	mov    %esp,%ebp
c0105948:	83 ec 18             	sub    $0x18,%esp
    void * ptr=NULL;
c010594b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105952:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010595d:	74 09                	je     c0105968 <kmalloc+0x23>
c010595f:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105966:	76 19                	jbe    c0105981 <kmalloc+0x3c>
c0105968:	68 15 96 10 c0       	push   $0xc0109615
c010596d:	68 b9 90 10 c0       	push   $0xc01090b9
c0105972:	68 9b 02 00 00       	push   $0x29b
c0105977:	68 94 90 10 c0       	push   $0xc0109094
c010597c:	e8 1e b3 ff ff       	call   c0100c9f <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105981:	8b 45 08             	mov    0x8(%ebp),%eax
c0105984:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105989:	c1 e8 0c             	shr    $0xc,%eax
c010598c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c010598f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105992:	83 ec 0c             	sub    $0xc,%esp
c0105995:	50                   	push   %eax
c0105996:	e8 d1 ea ff ff       	call   c010446c <alloc_pages>
c010599b:	83 c4 10             	add    $0x10,%esp
c010599e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c01059a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059a5:	75 19                	jne    c01059c0 <kmalloc+0x7b>
c01059a7:	68 2c 96 10 c0       	push   $0xc010962c
c01059ac:	68 b9 90 10 c0       	push   $0xc01090b9
c01059b1:	68 9e 02 00 00       	push   $0x29e
c01059b6:	68 94 90 10 c0       	push   $0xc0109094
c01059bb:	e8 df b2 ff ff       	call   c0100c9f <__panic>
    ptr=page2kva(base);
c01059c0:	83 ec 0c             	sub    $0xc,%esp
c01059c3:	ff 75 f0             	push   -0x10(%ebp)
c01059c6:	e8 b8 e7 ff ff       	call   c0104183 <page2kva>
c01059cb:	83 c4 10             	add    $0x10,%esp
c01059ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c01059d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059d4:	c9                   	leave  
c01059d5:	c3                   	ret    

c01059d6 <kfree>:

void 
kfree(void *ptr, size_t n) {
c01059d6:	55                   	push   %ebp
c01059d7:	89 e5                	mov    %esp,%ebp
c01059d9:	83 ec 18             	sub    $0x18,%esp
    assert(n > 0 && n < 1024*0124);
c01059dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059e0:	74 09                	je     c01059eb <kfree+0x15>
c01059e2:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c01059e9:	76 19                	jbe    c0105a04 <kfree+0x2e>
c01059eb:	68 15 96 10 c0       	push   $0xc0109615
c01059f0:	68 b9 90 10 c0       	push   $0xc01090b9
c01059f5:	68 a5 02 00 00       	push   $0x2a5
c01059fa:	68 94 90 10 c0       	push   $0xc0109094
c01059ff:	e8 9b b2 ff ff       	call   c0100c9f <__panic>
    assert(ptr != NULL);
c0105a04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a08:	75 19                	jne    c0105a23 <kfree+0x4d>
c0105a0a:	68 39 96 10 c0       	push   $0xc0109639
c0105a0f:	68 b9 90 10 c0       	push   $0xc01090b9
c0105a14:	68 a6 02 00 00       	push   $0x2a6
c0105a19:	68 94 90 10 c0       	push   $0xc0109094
c0105a1e:	e8 7c b2 ff ff       	call   c0100c9f <__panic>
    struct Page *base=NULL;
c0105a23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2d:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105a32:	c1 e8 0c             	shr    $0xc,%eax
c0105a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105a38:	83 ec 0c             	sub    $0xc,%esp
c0105a3b:	ff 75 08             	push   0x8(%ebp)
c0105a3e:	e8 85 e7 ff ff       	call   c01041c8 <kva2page>
c0105a43:	83 c4 10             	add    $0x10,%esp
c0105a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4c:	83 ec 08             	sub    $0x8,%esp
c0105a4f:	50                   	push   %eax
c0105a50:	ff 75 f4             	push   -0xc(%ebp)
c0105a53:	e8 80 ea ff ff       	call   c01044d8 <free_pages>
c0105a58:	83 c4 10             	add    $0x10,%esp
}
c0105a5b:	90                   	nop
c0105a5c:	c9                   	leave  
c0105a5d:	c3                   	ret    

c0105a5e <pa2page>:
pa2page(uintptr_t pa) {
c0105a5e:	55                   	push   %ebp
c0105a5f:	89 e5                	mov    %esp,%ebp
c0105a61:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0105a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a67:	c1 e8 0c             	shr    $0xc,%eax
c0105a6a:	89 c2                	mov    %eax,%edx
c0105a6c:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0105a71:	39 c2                	cmp    %eax,%edx
c0105a73:	72 14                	jb     c0105a89 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0105a75:	83 ec 04             	sub    $0x4,%esp
c0105a78:	68 48 96 10 c0       	push   $0xc0109648
c0105a7d:	6a 5b                	push   $0x5b
c0105a7f:	68 67 96 10 c0       	push   $0xc0109667
c0105a84:	e8 16 b2 ff ff       	call   c0100c9f <__panic>
    return &pages[PPN(pa)];
c0105a89:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c0105a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a92:	c1 e8 0c             	shr    $0xc,%eax
c0105a95:	c1 e0 05             	shl    $0x5,%eax
c0105a98:	01 d0                	add    %edx,%eax
}
c0105a9a:	c9                   	leave  
c0105a9b:	c3                   	ret    

c0105a9c <pte2page>:
pte2page(pte_t pte) {
c0105a9c:	55                   	push   %ebp
c0105a9d:	89 e5                	mov    %esp,%ebp
c0105a9f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa5:	83 e0 01             	and    $0x1,%eax
c0105aa8:	85 c0                	test   %eax,%eax
c0105aaa:	75 14                	jne    c0105ac0 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0105aac:	83 ec 04             	sub    $0x4,%esp
c0105aaf:	68 78 96 10 c0       	push   $0xc0109678
c0105ab4:	6a 6d                	push   $0x6d
c0105ab6:	68 67 96 10 c0       	push   $0xc0109667
c0105abb:	e8 df b1 ff ff       	call   c0100c9f <__panic>
    return pa2page(PTE_ADDR(pte));
c0105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ac8:	83 ec 0c             	sub    $0xc,%esp
c0105acb:	50                   	push   %eax
c0105acc:	e8 8d ff ff ff       	call   c0105a5e <pa2page>
c0105ad1:	83 c4 10             	add    $0x10,%esp
}
c0105ad4:	c9                   	leave  
c0105ad5:	c3                   	ret    

c0105ad6 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0105ad6:	55                   	push   %ebp
c0105ad7:	89 e5                	mov    %esp,%ebp
c0105ad9:	83 ec 18             	sub    $0x18,%esp
     swapfs_init();
c0105adc:	e8 65 1b 00 00       	call   c0107646 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0105ae1:	a1 40 60 12 c0       	mov    0xc0126040,%eax
c0105ae6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0105aeb:	76 0c                	jbe    c0105af9 <swap_init+0x23>
c0105aed:	a1 40 60 12 c0       	mov    0xc0126040,%eax
c0105af2:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0105af7:	76 17                	jbe    c0105b10 <swap_init+0x3a>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0105af9:	a1 40 60 12 c0       	mov    0xc0126040,%eax
c0105afe:	50                   	push   %eax
c0105aff:	68 99 96 10 c0       	push   $0xc0109699
c0105b04:	6a 25                	push   $0x25
c0105b06:	68 b4 96 10 c0       	push   $0xc01096b4
c0105b0b:	e8 8f b1 ff ff       	call   c0100c9f <__panic>
     }
     

     sm = &swap_manager_fifo;
c0105b10:	c7 05 00 61 12 c0 40 	movl   $0xc0122a40,0xc0126100
c0105b17:	2a 12 c0 
     int r = sm->init();
c0105b1a:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105b1f:	8b 40 04             	mov    0x4(%eax),%eax
c0105b22:	ff d0                	call   *%eax
c0105b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0105b27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105b2b:	75 27                	jne    c0105b54 <swap_init+0x7e>
     {
          swap_init_ok = 1;
c0105b2d:	c7 05 44 60 12 c0 01 	movl   $0x1,0xc0126044
c0105b34:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0105b37:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105b3c:	8b 00                	mov    (%eax),%eax
c0105b3e:	83 ec 08             	sub    $0x8,%esp
c0105b41:	50                   	push   %eax
c0105b42:	68 c3 96 10 c0       	push   $0xc01096c3
c0105b47:	e8 f4 a7 ff ff       	call   c0100340 <cprintf>
c0105b4c:	83 c4 10             	add    $0x10,%esp
          check_swap();
c0105b4f:	e8 f7 03 00 00       	call   c0105f4b <check_swap>
     }

     return r;
c0105b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b57:	c9                   	leave  
c0105b58:	c3                   	ret    

c0105b59 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0105b59:	55                   	push   %ebp
c0105b5a:	89 e5                	mov    %esp,%ebp
c0105b5c:	83 ec 08             	sub    $0x8,%esp
     return sm->init_mm(mm);
c0105b5f:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105b64:	8b 40 08             	mov    0x8(%eax),%eax
c0105b67:	83 ec 0c             	sub    $0xc,%esp
c0105b6a:	ff 75 08             	push   0x8(%ebp)
c0105b6d:	ff d0                	call   *%eax
c0105b6f:	83 c4 10             	add    $0x10,%esp
}
c0105b72:	c9                   	leave  
c0105b73:	c3                   	ret    

c0105b74 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0105b74:	55                   	push   %ebp
c0105b75:	89 e5                	mov    %esp,%ebp
c0105b77:	83 ec 08             	sub    $0x8,%esp
     return sm->tick_event(mm);
c0105b7a:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105b7f:	8b 40 0c             	mov    0xc(%eax),%eax
c0105b82:	83 ec 0c             	sub    $0xc,%esp
c0105b85:	ff 75 08             	push   0x8(%ebp)
c0105b88:	ff d0                	call   *%eax
c0105b8a:	83 c4 10             	add    $0x10,%esp
}
c0105b8d:	c9                   	leave  
c0105b8e:	c3                   	ret    

c0105b8f <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105b8f:	55                   	push   %ebp
c0105b90:	89 e5                	mov    %esp,%ebp
c0105b92:	83 ec 08             	sub    $0x8,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0105b95:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105b9a:	8b 40 10             	mov    0x10(%eax),%eax
c0105b9d:	ff 75 14             	push   0x14(%ebp)
c0105ba0:	ff 75 10             	push   0x10(%ebp)
c0105ba3:	ff 75 0c             	push   0xc(%ebp)
c0105ba6:	ff 75 08             	push   0x8(%ebp)
c0105ba9:	ff d0                	call   *%eax
c0105bab:	83 c4 10             	add    $0x10,%esp
}
c0105bae:	c9                   	leave  
c0105baf:	c3                   	ret    

c0105bb0 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105bb0:	55                   	push   %ebp
c0105bb1:	89 e5                	mov    %esp,%ebp
c0105bb3:	83 ec 08             	sub    $0x8,%esp
     return sm->set_unswappable(mm, addr);
c0105bb6:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105bbb:	8b 40 14             	mov    0x14(%eax),%eax
c0105bbe:	83 ec 08             	sub    $0x8,%esp
c0105bc1:	ff 75 0c             	push   0xc(%ebp)
c0105bc4:	ff 75 08             	push   0x8(%ebp)
c0105bc7:	ff d0                	call   *%eax
c0105bc9:	83 c4 10             	add    $0x10,%esp
}
c0105bcc:	c9                   	leave  
c0105bcd:	c3                   	ret    

c0105bce <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0105bce:	55                   	push   %ebp
c0105bcf:	89 e5                	mov    %esp,%ebp
c0105bd1:	83 ec 28             	sub    $0x28,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0105bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105bdb:	e9 2e 01 00 00       	jmp    c0105d0e <swap_out+0x140>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0105be0:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105be5:	8b 40 18             	mov    0x18(%eax),%eax
c0105be8:	83 ec 04             	sub    $0x4,%esp
c0105beb:	ff 75 10             	push   0x10(%ebp)
c0105bee:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0105bf1:	52                   	push   %edx
c0105bf2:	ff 75 08             	push   0x8(%ebp)
c0105bf5:	ff d0                	call   *%eax
c0105bf7:	83 c4 10             	add    $0x10,%esp
c0105bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0105bfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c01:	74 18                	je     c0105c1b <swap_out+0x4d>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0105c03:	83 ec 08             	sub    $0x8,%esp
c0105c06:	ff 75 f4             	push   -0xc(%ebp)
c0105c09:	68 d8 96 10 c0       	push   $0xc01096d8
c0105c0e:	e8 2d a7 ff ff       	call   c0100340 <cprintf>
c0105c13:	83 c4 10             	add    $0x10,%esp
c0105c16:	e9 ff 00 00 00       	jmp    c0105d1a <swap_out+0x14c>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0105c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c1e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0105c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c27:	8b 40 0c             	mov    0xc(%eax),%eax
c0105c2a:	83 ec 04             	sub    $0x4,%esp
c0105c2d:	6a 00                	push   $0x0
c0105c2f:	ff 75 ec             	push   -0x14(%ebp)
c0105c32:	50                   	push   %eax
c0105c33:	e8 7e ee ff ff       	call   c0104ab6 <get_pte>
c0105c38:	83 c4 10             	add    $0x10,%esp
c0105c3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0105c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c41:	8b 00                	mov    (%eax),%eax
c0105c43:	83 e0 01             	and    $0x1,%eax
c0105c46:	85 c0                	test   %eax,%eax
c0105c48:	75 16                	jne    c0105c60 <swap_out+0x92>
c0105c4a:	68 05 97 10 c0       	push   $0xc0109705
c0105c4f:	68 1a 97 10 c0       	push   $0xc010971a
c0105c54:	6a 65                	push   $0x65
c0105c56:	68 b4 96 10 c0       	push   $0xc01096b4
c0105c5b:	e8 3f b0 ff ff       	call   c0100c9f <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0105c60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c66:	8b 52 1c             	mov    0x1c(%edx),%edx
c0105c69:	c1 ea 0c             	shr    $0xc,%edx
c0105c6c:	83 c2 01             	add    $0x1,%edx
c0105c6f:	c1 e2 08             	shl    $0x8,%edx
c0105c72:	83 ec 08             	sub    $0x8,%esp
c0105c75:	50                   	push   %eax
c0105c76:	52                   	push   %edx
c0105c77:	e8 65 1a 00 00       	call   c01076e1 <swapfs_write>
c0105c7c:	83 c4 10             	add    $0x10,%esp
c0105c7f:	85 c0                	test   %eax,%eax
c0105c81:	74 2b                	je     c0105cae <swap_out+0xe0>
                    cprintf("SWAP: failed to save\n");
c0105c83:	83 ec 0c             	sub    $0xc,%esp
c0105c86:	68 2f 97 10 c0       	push   $0xc010972f
c0105c8b:	e8 b0 a6 ff ff       	call   c0100340 <cprintf>
c0105c90:	83 c4 10             	add    $0x10,%esp
                    sm->map_swappable(mm, v, page, 0);
c0105c93:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105c98:	8b 40 10             	mov    0x10(%eax),%eax
c0105c9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c9e:	6a 00                	push   $0x0
c0105ca0:	52                   	push   %edx
c0105ca1:	ff 75 ec             	push   -0x14(%ebp)
c0105ca4:	ff 75 08             	push   0x8(%ebp)
c0105ca7:	ff d0                	call   *%eax
c0105ca9:	83 c4 10             	add    $0x10,%esp
c0105cac:	eb 5c                	jmp    c0105d0a <swap_out+0x13c>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0105cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cb1:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105cb4:	c1 e8 0c             	shr    $0xc,%eax
c0105cb7:	83 c0 01             	add    $0x1,%eax
c0105cba:	50                   	push   %eax
c0105cbb:	ff 75 ec             	push   -0x14(%ebp)
c0105cbe:	ff 75 f4             	push   -0xc(%ebp)
c0105cc1:	68 48 97 10 c0       	push   $0xc0109748
c0105cc6:	e8 75 a6 ff ff       	call   c0100340 <cprintf>
c0105ccb:	83 c4 10             	add    $0x10,%esp
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0105cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cd1:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105cd4:	c1 e8 0c             	shr    $0xc,%eax
c0105cd7:	83 c0 01             	add    $0x1,%eax
c0105cda:	c1 e0 08             	shl    $0x8,%eax
c0105cdd:	89 c2                	mov    %eax,%edx
c0105cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ce2:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0105ce4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ce7:	83 ec 08             	sub    $0x8,%esp
c0105cea:	6a 01                	push   $0x1
c0105cec:	50                   	push   %eax
c0105ced:	e8 e6 e7 ff ff       	call   c01044d8 <free_pages>
c0105cf2:	83 c4 10             	add    $0x10,%esp
          }
          
          tlb_invalidate(mm->pgdir, v);
c0105cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf8:	8b 40 0c             	mov    0xc(%eax),%eax
c0105cfb:	83 ec 08             	sub    $0x8,%esp
c0105cfe:	ff 75 ec             	push   -0x14(%ebp)
c0105d01:	50                   	push   %eax
c0105d02:	e8 79 f0 ff ff       	call   c0104d80 <tlb_invalidate>
c0105d07:	83 c4 10             	add    $0x10,%esp
     for (i = 0; i != n; ++ i)
c0105d0a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d11:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d14:	0f 85 c6 fe ff ff    	jne    c0105be0 <swap_out+0x12>
     }
     return i;
c0105d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d1d:	c9                   	leave  
c0105d1e:	c3                   	ret    

c0105d1f <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0105d1f:	55                   	push   %ebp
c0105d20:	89 e5                	mov    %esp,%ebp
c0105d22:	83 ec 18             	sub    $0x18,%esp
     struct Page *result = alloc_page();
c0105d25:	83 ec 0c             	sub    $0xc,%esp
c0105d28:	6a 01                	push   $0x1
c0105d2a:	e8 3d e7 ff ff       	call   c010446c <alloc_pages>
c0105d2f:	83 c4 10             	add    $0x10,%esp
c0105d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0105d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d39:	75 16                	jne    c0105d51 <swap_in+0x32>
c0105d3b:	68 88 97 10 c0       	push   $0xc0109788
c0105d40:	68 1a 97 10 c0       	push   $0xc010971a
c0105d45:	6a 7b                	push   $0x7b
c0105d47:	68 b4 96 10 c0       	push   $0xc01096b4
c0105d4c:	e8 4e af ff ff       	call   c0100c9f <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0105d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d54:	8b 40 0c             	mov    0xc(%eax),%eax
c0105d57:	83 ec 04             	sub    $0x4,%esp
c0105d5a:	6a 00                	push   $0x0
c0105d5c:	ff 75 0c             	push   0xc(%ebp)
c0105d5f:	50                   	push   %eax
c0105d60:	e8 51 ed ff ff       	call   c0104ab6 <get_pte>
c0105d65:	83 c4 10             	add    $0x10,%esp
c0105d68:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0105d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d6e:	8b 00                	mov    (%eax),%eax
c0105d70:	83 ec 08             	sub    $0x8,%esp
c0105d73:	ff 75 f4             	push   -0xc(%ebp)
c0105d76:	50                   	push   %eax
c0105d77:	e8 0d 19 00 00       	call   c0107689 <swapfs_read>
c0105d7c:	83 c4 10             	add    $0x10,%esp
c0105d7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d86:	74 1f                	je     c0105da7 <swap_in+0x88>
     {
        assert(r!=0);
c0105d88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d8c:	75 19                	jne    c0105da7 <swap_in+0x88>
c0105d8e:	68 95 97 10 c0       	push   $0xc0109795
c0105d93:	68 1a 97 10 c0       	push   $0xc010971a
c0105d98:	68 83 00 00 00       	push   $0x83
c0105d9d:	68 b4 96 10 c0       	push   $0xc01096b4
c0105da2:	e8 f8 ae ff ff       	call   c0100c9f <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0105da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105daa:	8b 00                	mov    (%eax),%eax
c0105dac:	c1 e8 08             	shr    $0x8,%eax
c0105daf:	83 ec 04             	sub    $0x4,%esp
c0105db2:	ff 75 0c             	push   0xc(%ebp)
c0105db5:	50                   	push   %eax
c0105db6:	68 9c 97 10 c0       	push   $0xc010979c
c0105dbb:	e8 80 a5 ff ff       	call   c0100340 <cprintf>
c0105dc0:	83 c4 10             	add    $0x10,%esp
     *ptr_result=result;
c0105dc3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105dc9:	89 10                	mov    %edx,(%eax)
     return 0;
c0105dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dd0:	c9                   	leave  
c0105dd1:	c3                   	ret    

c0105dd2 <check_content_set>:



static inline void
check_content_set(void)
{
c0105dd2:	55                   	push   %ebp
c0105dd3:	89 e5                	mov    %esp,%ebp
c0105dd5:	83 ec 08             	sub    $0x8,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0105dd8:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105ddd:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105de0:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105de5:	83 f8 01             	cmp    $0x1,%eax
c0105de8:	74 19                	je     c0105e03 <check_content_set+0x31>
c0105dea:	68 da 97 10 c0       	push   $0xc01097da
c0105def:	68 1a 97 10 c0       	push   $0xc010971a
c0105df4:	68 90 00 00 00       	push   $0x90
c0105df9:	68 b4 96 10 c0       	push   $0xc01096b4
c0105dfe:	e8 9c ae ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0105e03:	b8 10 10 00 00       	mov    $0x1010,%eax
c0105e08:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0105e0b:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105e10:	83 f8 01             	cmp    $0x1,%eax
c0105e13:	74 19                	je     c0105e2e <check_content_set+0x5c>
c0105e15:	68 da 97 10 c0       	push   $0xc01097da
c0105e1a:	68 1a 97 10 c0       	push   $0xc010971a
c0105e1f:	68 92 00 00 00       	push   $0x92
c0105e24:	68 b4 96 10 c0       	push   $0xc01096b4
c0105e29:	e8 71 ae ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0105e2e:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105e33:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105e36:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105e3b:	83 f8 02             	cmp    $0x2,%eax
c0105e3e:	74 19                	je     c0105e59 <check_content_set+0x87>
c0105e40:	68 e9 97 10 c0       	push   $0xc01097e9
c0105e45:	68 1a 97 10 c0       	push   $0xc010971a
c0105e4a:	68 94 00 00 00       	push   $0x94
c0105e4f:	68 b4 96 10 c0       	push   $0xc01096b4
c0105e54:	e8 46 ae ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0105e59:	b8 10 20 00 00       	mov    $0x2010,%eax
c0105e5e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0105e61:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105e66:	83 f8 02             	cmp    $0x2,%eax
c0105e69:	74 19                	je     c0105e84 <check_content_set+0xb2>
c0105e6b:	68 e9 97 10 c0       	push   $0xc01097e9
c0105e70:	68 1a 97 10 c0       	push   $0xc010971a
c0105e75:	68 96 00 00 00       	push   $0x96
c0105e7a:	68 b4 96 10 c0       	push   $0xc01096b4
c0105e7f:	e8 1b ae ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0105e84:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105e89:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0105e8c:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105e91:	83 f8 03             	cmp    $0x3,%eax
c0105e94:	74 19                	je     c0105eaf <check_content_set+0xdd>
c0105e96:	68 f8 97 10 c0       	push   $0xc01097f8
c0105e9b:	68 1a 97 10 c0       	push   $0xc010971a
c0105ea0:	68 98 00 00 00       	push   $0x98
c0105ea5:	68 b4 96 10 c0       	push   $0xc01096b4
c0105eaa:	e8 f0 ad ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0105eaf:	b8 10 30 00 00       	mov    $0x3010,%eax
c0105eb4:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0105eb7:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105ebc:	83 f8 03             	cmp    $0x3,%eax
c0105ebf:	74 19                	je     c0105eda <check_content_set+0x108>
c0105ec1:	68 f8 97 10 c0       	push   $0xc01097f8
c0105ec6:	68 1a 97 10 c0       	push   $0xc010971a
c0105ecb:	68 9a 00 00 00       	push   $0x9a
c0105ed0:	68 b4 96 10 c0       	push   $0xc01096b4
c0105ed5:	e8 c5 ad ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0105eda:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105edf:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0105ee2:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105ee7:	83 f8 04             	cmp    $0x4,%eax
c0105eea:	74 19                	je     c0105f05 <check_content_set+0x133>
c0105eec:	68 07 98 10 c0       	push   $0xc0109807
c0105ef1:	68 1a 97 10 c0       	push   $0xc010971a
c0105ef6:	68 9c 00 00 00       	push   $0x9c
c0105efb:	68 b4 96 10 c0       	push   $0xc01096b4
c0105f00:	e8 9a ad ff ff       	call   c0100c9f <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0105f05:	b8 10 40 00 00       	mov    $0x4010,%eax
c0105f0a:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0105f0d:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0105f12:	83 f8 04             	cmp    $0x4,%eax
c0105f15:	74 19                	je     c0105f30 <check_content_set+0x15e>
c0105f17:	68 07 98 10 c0       	push   $0xc0109807
c0105f1c:	68 1a 97 10 c0       	push   $0xc010971a
c0105f21:	68 9e 00 00 00       	push   $0x9e
c0105f26:	68 b4 96 10 c0       	push   $0xc01096b4
c0105f2b:	e8 6f ad ff ff       	call   c0100c9f <__panic>
}
c0105f30:	90                   	nop
c0105f31:	c9                   	leave  
c0105f32:	c3                   	ret    

c0105f33 <check_content_access>:

static inline int
check_content_access(void)
{
c0105f33:	55                   	push   %ebp
c0105f34:	89 e5                	mov    %esp,%ebp
c0105f36:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0105f39:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0105f3e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105f41:	ff d0                	call   *%eax
c0105f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0105f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f49:	c9                   	leave  
c0105f4a:	c3                   	ret    

c0105f4b <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0105f4b:	55                   	push   %ebp
c0105f4c:	89 e5                	mov    %esp,%ebp
c0105f4e:	83 ec 68             	sub    $0x68,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0105f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105f58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0105f5f:	c7 45 e8 84 5f 12 c0 	movl   $0xc0125f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105f66:	eb 60                	jmp    c0105fc8 <check_swap+0x7d>
        struct Page *p = le2page(le, page_link);
c0105f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f6b:	83 e8 0c             	sub    $0xc,%eax
c0105f6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(PageProperty(p));
c0105f71:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105f74:	83 c0 04             	add    $0x4,%eax
c0105f77:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105f7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105f81:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105f84:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105f87:	0f a3 10             	bt     %edx,(%eax)
c0105f8a:	19 c0                	sbb    %eax,%eax
c0105f8c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0105f8f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105f93:	0f 95 c0             	setne  %al
c0105f96:	0f b6 c0             	movzbl %al,%eax
c0105f99:	85 c0                	test   %eax,%eax
c0105f9b:	75 19                	jne    c0105fb6 <check_swap+0x6b>
c0105f9d:	68 16 98 10 c0       	push   $0xc0109816
c0105fa2:	68 1a 97 10 c0       	push   $0xc010971a
c0105fa7:	68 b9 00 00 00       	push   $0xb9
c0105fac:	68 b4 96 10 c0       	push   $0xc01096b4
c0105fb1:	e8 e9 ac ff ff       	call   c0100c9f <__panic>
        count ++, total += p->property;
c0105fb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105fba:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105fbd:	8b 50 08             	mov    0x8(%eax),%edx
c0105fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fc3:	01 d0                	add    %edx,%eax
c0105fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fcb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105fce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105fd1:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0105fd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105fd7:	81 7d e8 84 5f 12 c0 	cmpl   $0xc0125f84,-0x18(%ebp)
c0105fde:	75 88                	jne    c0105f68 <check_swap+0x1d>
     }
     assert(total == nr_free_pages());
c0105fe0:	e8 28 e5 ff ff       	call   c010450d <nr_free_pages>
c0105fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105fe8:	39 d0                	cmp    %edx,%eax
c0105fea:	74 19                	je     c0106005 <check_swap+0xba>
c0105fec:	68 26 98 10 c0       	push   $0xc0109826
c0105ff1:	68 1a 97 10 c0       	push   $0xc010971a
c0105ff6:	68 bc 00 00 00       	push   $0xbc
c0105ffb:	68 b4 96 10 c0       	push   $0xc01096b4
c0106000:	e8 9a ac ff ff       	call   c0100c9f <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106005:	83 ec 04             	sub    $0x4,%esp
c0106008:	ff 75 f0             	push   -0x10(%ebp)
c010600b:	ff 75 f4             	push   -0xc(%ebp)
c010600e:	68 40 98 10 c0       	push   $0xc0109840
c0106013:	e8 28 a3 ff ff       	call   c0100340 <cprintf>
c0106018:	83 c4 10             	add    $0x10,%esp
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010601b:	e8 b1 09 00 00       	call   c01069d1 <mm_create>
c0106020:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     assert(mm != NULL);
c0106023:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106027:	75 19                	jne    c0106042 <check_swap+0xf7>
c0106029:	68 66 98 10 c0       	push   $0xc0109866
c010602e:	68 1a 97 10 c0       	push   $0xc010971a
c0106033:	68 c1 00 00 00       	push   $0xc1
c0106038:	68 b4 96 10 c0       	push   $0xc01096b4
c010603d:	e8 5d ac ff ff       	call   c0100c9f <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106042:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c0106047:	85 c0                	test   %eax,%eax
c0106049:	74 19                	je     c0106064 <check_swap+0x119>
c010604b:	68 71 98 10 c0       	push   $0xc0109871
c0106050:	68 1a 97 10 c0       	push   $0xc010971a
c0106055:	68 c4 00 00 00       	push   $0xc4
c010605a:	68 b4 96 10 c0       	push   $0xc01096b4
c010605f:	e8 3b ac ff ff       	call   c0100c9f <__panic>

     check_mm_struct = mm;
c0106064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106067:	a3 0c 61 12 c0       	mov    %eax,0xc012610c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010606c:	8b 15 e0 29 12 c0    	mov    0xc01229e0,%edx
c0106072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106075:	89 50 0c             	mov    %edx,0xc(%eax)
c0106078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010607b:	8b 40 0c             	mov    0xc(%eax),%eax
c010607e:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(pgdir[0] == 0);
c0106081:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106084:	8b 00                	mov    (%eax),%eax
c0106086:	85 c0                	test   %eax,%eax
c0106088:	74 19                	je     c01060a3 <check_swap+0x158>
c010608a:	68 89 98 10 c0       	push   $0xc0109889
c010608f:	68 1a 97 10 c0       	push   $0xc010971a
c0106094:	68 c9 00 00 00       	push   $0xc9
c0106099:	68 b4 96 10 c0       	push   $0xc01096b4
c010609e:	e8 fc ab ff ff       	call   c0100c9f <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01060a3:	83 ec 04             	sub    $0x4,%esp
c01060a6:	6a 03                	push   $0x3
c01060a8:	68 00 60 00 00       	push   $0x6000
c01060ad:	68 00 10 00 00       	push   $0x1000
c01060b2:	e8 97 09 00 00       	call   c0106a4e <vma_create>
c01060b7:	83 c4 10             	add    $0x10,%esp
c01060ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(vma != NULL);
c01060bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01060c1:	75 19                	jne    c01060dc <check_swap+0x191>
c01060c3:	68 97 98 10 c0       	push   $0xc0109897
c01060c8:	68 1a 97 10 c0       	push   $0xc010971a
c01060cd:	68 cc 00 00 00       	push   $0xcc
c01060d2:	68 b4 96 10 c0       	push   $0xc01096b4
c01060d7:	e8 c3 ab ff ff       	call   c0100c9f <__panic>

     insert_vma_struct(mm, vma);
c01060dc:	83 ec 08             	sub    $0x8,%esp
c01060df:	ff 75 dc             	push   -0x24(%ebp)
c01060e2:	ff 75 e4             	push   -0x1c(%ebp)
c01060e5:	e8 cc 0a 00 00       	call   c0106bb6 <insert_vma_struct>
c01060ea:	83 c4 10             	add    $0x10,%esp

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01060ed:	83 ec 0c             	sub    $0xc,%esp
c01060f0:	68 a4 98 10 c0       	push   $0xc01098a4
c01060f5:	e8 46 a2 ff ff       	call   c0100340 <cprintf>
c01060fa:	83 c4 10             	add    $0x10,%esp
     pte_t *temp_ptep=NULL;
c01060fd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106107:	8b 40 0c             	mov    0xc(%eax),%eax
c010610a:	83 ec 04             	sub    $0x4,%esp
c010610d:	6a 01                	push   $0x1
c010610f:	68 00 10 00 00       	push   $0x1000
c0106114:	50                   	push   %eax
c0106115:	e8 9c e9 ff ff       	call   c0104ab6 <get_pte>
c010611a:	83 c4 10             	add    $0x10,%esp
c010611d:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(temp_ptep!= NULL);
c0106120:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106124:	75 19                	jne    c010613f <check_swap+0x1f4>
c0106126:	68 d8 98 10 c0       	push   $0xc01098d8
c010612b:	68 1a 97 10 c0       	push   $0xc010971a
c0106130:	68 d4 00 00 00       	push   $0xd4
c0106135:	68 b4 96 10 c0       	push   $0xc01096b4
c010613a:	e8 60 ab ff ff       	call   c0100c9f <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c010613f:	83 ec 0c             	sub    $0xc,%esp
c0106142:	68 ec 98 10 c0       	push   $0xc01098ec
c0106147:	e8 f4 a1 ff ff       	call   c0100340 <cprintf>
c010614c:	83 c4 10             	add    $0x10,%esp
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010614f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106156:	e9 8e 00 00 00       	jmp    c01061e9 <check_swap+0x29e>
          check_rp[i] = alloc_page();
c010615b:	83 ec 0c             	sub    $0xc,%esp
c010615e:	6a 01                	push   $0x1
c0106160:	e8 07 e3 ff ff       	call   c010446c <alloc_pages>
c0106165:	83 c4 10             	add    $0x10,%esp
c0106168:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010616b:	89 04 95 cc 60 12 c0 	mov    %eax,-0x3fed9f34(,%edx,4)
          assert(check_rp[i] != NULL );
c0106172:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106175:	8b 04 85 cc 60 12 c0 	mov    -0x3fed9f34(,%eax,4),%eax
c010617c:	85 c0                	test   %eax,%eax
c010617e:	75 19                	jne    c0106199 <check_swap+0x24e>
c0106180:	68 10 99 10 c0       	push   $0xc0109910
c0106185:	68 1a 97 10 c0       	push   $0xc010971a
c010618a:	68 d9 00 00 00       	push   $0xd9
c010618f:	68 b4 96 10 c0       	push   $0xc01096b4
c0106194:	e8 06 ab ff ff       	call   c0100c9f <__panic>
          assert(!PageProperty(check_rp[i]));
c0106199:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010619c:	8b 04 85 cc 60 12 c0 	mov    -0x3fed9f34(,%eax,4),%eax
c01061a3:	83 c0 04             	add    $0x4,%eax
c01061a6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01061ad:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01061b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01061b3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01061b6:	0f a3 10             	bt     %edx,(%eax)
c01061b9:	19 c0                	sbb    %eax,%eax
c01061bb:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01061be:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01061c2:	0f 95 c0             	setne  %al
c01061c5:	0f b6 c0             	movzbl %al,%eax
c01061c8:	85 c0                	test   %eax,%eax
c01061ca:	74 19                	je     c01061e5 <check_swap+0x29a>
c01061cc:	68 24 99 10 c0       	push   $0xc0109924
c01061d1:	68 1a 97 10 c0       	push   $0xc010971a
c01061d6:	68 da 00 00 00       	push   $0xda
c01061db:	68 b4 96 10 c0       	push   $0xc01096b4
c01061e0:	e8 ba aa ff ff       	call   c0100c9f <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01061e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01061e9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01061ed:	0f 8e 68 ff ff ff    	jle    c010615b <check_swap+0x210>
     }
     list_entry_t free_list_store = free_list;
c01061f3:	a1 84 5f 12 c0       	mov    0xc0125f84,%eax
c01061f8:	8b 15 88 5f 12 c0    	mov    0xc0125f88,%edx
c01061fe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106201:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106204:	c7 45 a4 84 5f 12 c0 	movl   $0xc0125f84,-0x5c(%ebp)
    elm->prev = elm->next = elm;
c010620b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010620e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106211:	89 50 04             	mov    %edx,0x4(%eax)
c0106214:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106217:	8b 50 04             	mov    0x4(%eax),%edx
c010621a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010621d:	89 10                	mov    %edx,(%eax)
}
c010621f:	90                   	nop
c0106220:	c7 45 a8 84 5f 12 c0 	movl   $0xc0125f84,-0x58(%ebp)
    return list->next == list;
c0106227:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010622a:	8b 40 04             	mov    0x4(%eax),%eax
c010622d:	39 45 a8             	cmp    %eax,-0x58(%ebp)
c0106230:	0f 94 c0             	sete   %al
c0106233:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106236:	85 c0                	test   %eax,%eax
c0106238:	75 19                	jne    c0106253 <check_swap+0x308>
c010623a:	68 3f 99 10 c0       	push   $0xc010993f
c010623f:	68 1a 97 10 c0       	push   $0xc010971a
c0106244:	68 de 00 00 00       	push   $0xde
c0106249:	68 b4 96 10 c0       	push   $0xc01096b4
c010624e:	e8 4c aa ff ff       	call   c0100c9f <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106253:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c0106258:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     nr_free = 0;
c010625b:	c7 05 8c 5f 12 c0 00 	movl   $0x0,0xc0125f8c
c0106262:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106265:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010626c:	eb 1c                	jmp    c010628a <check_swap+0x33f>
        free_pages(check_rp[i],1);
c010626e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106271:	8b 04 85 cc 60 12 c0 	mov    -0x3fed9f34(,%eax,4),%eax
c0106278:	83 ec 08             	sub    $0x8,%esp
c010627b:	6a 01                	push   $0x1
c010627d:	50                   	push   %eax
c010627e:	e8 55 e2 ff ff       	call   c01044d8 <free_pages>
c0106283:	83 c4 10             	add    $0x10,%esp
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106286:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010628a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010628e:	7e de                	jle    c010626e <check_swap+0x323>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106290:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c0106295:	83 f8 04             	cmp    $0x4,%eax
c0106298:	74 19                	je     c01062b3 <check_swap+0x368>
c010629a:	68 58 99 10 c0       	push   $0xc0109958
c010629f:	68 1a 97 10 c0       	push   $0xc010971a
c01062a4:	68 e7 00 00 00       	push   $0xe7
c01062a9:	68 b4 96 10 c0       	push   $0xc01096b4
c01062ae:	e8 ec a9 ff ff       	call   c0100c9f <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01062b3:	83 ec 0c             	sub    $0xc,%esp
c01062b6:	68 7c 99 10 c0       	push   $0xc010997c
c01062bb:	e8 80 a0 ff ff       	call   c0100340 <cprintf>
c01062c0:	83 c4 10             	add    $0x10,%esp
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01062c3:	c7 05 10 61 12 c0 00 	movl   $0x0,0xc0126110
c01062ca:	00 00 00 
     
     check_content_set();
c01062cd:	e8 00 fb ff ff       	call   c0105dd2 <check_content_set>
     assert( nr_free == 0);         
c01062d2:	a1 8c 5f 12 c0       	mov    0xc0125f8c,%eax
c01062d7:	85 c0                	test   %eax,%eax
c01062d9:	74 19                	je     c01062f4 <check_swap+0x3a9>
c01062db:	68 a3 99 10 c0       	push   $0xc01099a3
c01062e0:	68 1a 97 10 c0       	push   $0xc010971a
c01062e5:	68 f0 00 00 00       	push   $0xf0
c01062ea:	68 b4 96 10 c0       	push   $0xc01096b4
c01062ef:	e8 ab a9 ff ff       	call   c0100c9f <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01062f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01062fb:	eb 26                	jmp    c0106323 <check_swap+0x3d8>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01062fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106300:	c7 04 85 60 60 12 c0 	movl   $0xffffffff,-0x3fed9fa0(,%eax,4)
c0106307:	ff ff ff ff 
c010630b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010630e:	8b 14 85 60 60 12 c0 	mov    -0x3fed9fa0(,%eax,4),%edx
c0106315:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106318:	89 14 85 a0 60 12 c0 	mov    %edx,-0x3fed9f60(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010631f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106323:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106327:	7e d4                	jle    c01062fd <check_swap+0x3b2>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106329:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106330:	e9 c8 00 00 00       	jmp    c01063fd <check_swap+0x4b2>
         check_ptep[i]=0;
c0106335:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106338:	c7 04 85 dc 60 12 c0 	movl   $0x0,-0x3fed9f24(,%eax,4)
c010633f:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106343:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106346:	83 c0 01             	add    $0x1,%eax
c0106349:	c1 e0 0c             	shl    $0xc,%eax
c010634c:	83 ec 04             	sub    $0x4,%esp
c010634f:	6a 00                	push   $0x0
c0106351:	50                   	push   %eax
c0106352:	ff 75 e0             	push   -0x20(%ebp)
c0106355:	e8 5c e7 ff ff       	call   c0104ab6 <get_pte>
c010635a:	83 c4 10             	add    $0x10,%esp
c010635d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106360:	89 04 95 dc 60 12 c0 	mov    %eax,-0x3fed9f24(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106367:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010636a:	8b 04 85 dc 60 12 c0 	mov    -0x3fed9f24(,%eax,4),%eax
c0106371:	85 c0                	test   %eax,%eax
c0106373:	75 19                	jne    c010638e <check_swap+0x443>
c0106375:	68 b0 99 10 c0       	push   $0xc01099b0
c010637a:	68 1a 97 10 c0       	push   $0xc010971a
c010637f:	68 f8 00 00 00       	push   $0xf8
c0106384:	68 b4 96 10 c0       	push   $0xc01096b4
c0106389:	e8 11 a9 ff ff       	call   c0100c9f <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010638e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106391:	8b 04 85 dc 60 12 c0 	mov    -0x3fed9f24(,%eax,4),%eax
c0106398:	8b 00                	mov    (%eax),%eax
c010639a:	83 ec 0c             	sub    $0xc,%esp
c010639d:	50                   	push   %eax
c010639e:	e8 f9 f6 ff ff       	call   c0105a9c <pte2page>
c01063a3:	83 c4 10             	add    $0x10,%esp
c01063a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063a9:	8b 14 95 cc 60 12 c0 	mov    -0x3fed9f34(,%edx,4),%edx
c01063b0:	39 d0                	cmp    %edx,%eax
c01063b2:	74 19                	je     c01063cd <check_swap+0x482>
c01063b4:	68 c8 99 10 c0       	push   $0xc01099c8
c01063b9:	68 1a 97 10 c0       	push   $0xc010971a
c01063be:	68 f9 00 00 00       	push   $0xf9
c01063c3:	68 b4 96 10 c0       	push   $0xc01096b4
c01063c8:	e8 d2 a8 ff ff       	call   c0100c9f <__panic>
         assert((*check_ptep[i] & PTE_P));          
c01063cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063d0:	8b 04 85 dc 60 12 c0 	mov    -0x3fed9f24(,%eax,4),%eax
c01063d7:	8b 00                	mov    (%eax),%eax
c01063d9:	83 e0 01             	and    $0x1,%eax
c01063dc:	85 c0                	test   %eax,%eax
c01063de:	75 19                	jne    c01063f9 <check_swap+0x4ae>
c01063e0:	68 f0 99 10 c0       	push   $0xc01099f0
c01063e5:	68 1a 97 10 c0       	push   $0xc010971a
c01063ea:	68 fa 00 00 00       	push   $0xfa
c01063ef:	68 b4 96 10 c0       	push   $0xc01096b4
c01063f4:	e8 a6 a8 ff ff       	call   c0100c9f <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01063f9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01063fd:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106401:	0f 8e 2e ff ff ff    	jle    c0106335 <check_swap+0x3ea>
     }
     cprintf("set up init env for check_swap over!\n");
c0106407:	83 ec 0c             	sub    $0xc,%esp
c010640a:	68 0c 9a 10 c0       	push   $0xc0109a0c
c010640f:	e8 2c 9f ff ff       	call   c0100340 <cprintf>
c0106414:	83 c4 10             	add    $0x10,%esp
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106417:	e8 17 fb ff ff       	call   c0105f33 <check_content_access>
c010641c:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(ret==0);
c010641f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0106423:	74 19                	je     c010643e <check_swap+0x4f3>
c0106425:	68 32 9a 10 c0       	push   $0xc0109a32
c010642a:	68 1a 97 10 c0       	push   $0xc010971a
c010642f:	68 ff 00 00 00       	push   $0xff
c0106434:	68 b4 96 10 c0       	push   $0xc01096b4
c0106439:	e8 61 a8 ff ff       	call   c0100c9f <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010643e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106445:	eb 1c                	jmp    c0106463 <check_swap+0x518>
         free_pages(check_rp[i],1);
c0106447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010644a:	8b 04 85 cc 60 12 c0 	mov    -0x3fed9f34(,%eax,4),%eax
c0106451:	83 ec 08             	sub    $0x8,%esp
c0106454:	6a 01                	push   $0x1
c0106456:	50                   	push   %eax
c0106457:	e8 7c e0 ff ff       	call   c01044d8 <free_pages>
c010645c:	83 c4 10             	add    $0x10,%esp
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010645f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106463:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106467:	7e de                	jle    c0106447 <check_swap+0x4fc>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106469:	83 ec 0c             	sub    $0xc,%esp
c010646c:	ff 75 e4             	push   -0x1c(%ebp)
c010646f:	e8 68 08 00 00       	call   c0106cdc <mm_destroy>
c0106474:	83 c4 10             	add    $0x10,%esp
         
     nr_free = nr_free_store;
c0106477:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010647a:	a3 8c 5f 12 c0       	mov    %eax,0xc0125f8c
     free_list = free_list_store;
c010647f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106482:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106485:	a3 84 5f 12 c0       	mov    %eax,0xc0125f84
c010648a:	89 15 88 5f 12 c0    	mov    %edx,0xc0125f88

     
     le = &free_list;
c0106490:	c7 45 e8 84 5f 12 c0 	movl   $0xc0125f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106497:	eb 1d                	jmp    c01064b6 <check_swap+0x56b>
         struct Page *p = le2page(le, page_link);
c0106499:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010649c:	83 e8 0c             	sub    $0xc,%eax
c010649f:	89 45 cc             	mov    %eax,-0x34(%ebp)
         count --, total -= p->property;
c01064a2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01064a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01064a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01064ac:	8b 48 08             	mov    0x8(%eax),%ecx
c01064af:	89 d0                	mov    %edx,%eax
c01064b1:	29 c8                	sub    %ecx,%eax
c01064b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01064b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064b9:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c01064bc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01064bf:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c01064c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01064c5:	81 7d e8 84 5f 12 c0 	cmpl   $0xc0125f84,-0x18(%ebp)
c01064cc:	75 cb                	jne    c0106499 <check_swap+0x54e>
     }
     cprintf("count is %d, total is %d\n",count,total);
c01064ce:	83 ec 04             	sub    $0x4,%esp
c01064d1:	ff 75 f0             	push   -0x10(%ebp)
c01064d4:	ff 75 f4             	push   -0xc(%ebp)
c01064d7:	68 39 9a 10 c0       	push   $0xc0109a39
c01064dc:	e8 5f 9e ff ff       	call   c0100340 <cprintf>
c01064e1:	83 c4 10             	add    $0x10,%esp
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01064e4:	83 ec 0c             	sub    $0xc,%esp
c01064e7:	68 53 9a 10 c0       	push   $0xc0109a53
c01064ec:	e8 4f 9e ff ff       	call   c0100340 <cprintf>
c01064f1:	83 c4 10             	add    $0x10,%esp
}
c01064f4:	90                   	nop
c01064f5:	c9                   	leave  
c01064f6:	c3                   	ret    

c01064f7 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01064f7:	55                   	push   %ebp
c01064f8:	89 e5                	mov    %esp,%ebp
c01064fa:	83 ec 10             	sub    $0x10,%esp
c01064fd:	c7 45 fc 04 61 12 c0 	movl   $0xc0126104,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0106504:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106507:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010650a:	89 50 04             	mov    %edx,0x4(%eax)
c010650d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106510:	8b 50 04             	mov    0x4(%eax),%edx
c0106513:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106516:	89 10                	mov    %edx,(%eax)
}
c0106518:	90                   	nop
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106519:	8b 45 08             	mov    0x8(%ebp),%eax
c010651c:	c7 40 14 04 61 12 c0 	movl   $0xc0126104,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106523:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106528:	c9                   	leave  
c0106529:	c3                   	ret    

c010652a <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010652a:	55                   	push   %ebp
c010652b:	89 e5                	mov    %esp,%ebp
c010652d:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106530:	8b 45 08             	mov    0x8(%ebp),%eax
c0106533:	8b 40 14             	mov    0x14(%eax),%eax
c0106536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106539:	8b 45 10             	mov    0x10(%ebp),%eax
c010653c:	83 c0 14             	add    $0x14,%eax
c010653f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106542:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106546:	74 06                	je     c010654e <_fifo_map_swappable+0x24>
c0106548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010654c:	75 16                	jne    c0106564 <_fifo_map_swappable+0x3a>
c010654e:	68 6c 9a 10 c0       	push   $0xc0109a6c
c0106553:	68 8a 9a 10 c0       	push   $0xc0109a8a
c0106558:	6a 32                	push   $0x32
c010655a:	68 9f 9a 10 c0       	push   $0xc0109a9f
c010655f:	e8 3b a7 ff ff       	call   c0100c9f <__panic>
c0106564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106567:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010656a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010656d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106570:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106576:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106579:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c010657c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010657f:	8b 40 04             	mov    0x4(%eax),%eax
c0106582:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106585:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010658b:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010658e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0106591:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106594:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106597:	89 10                	mov    %edx,(%eax)
c0106599:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010659c:	8b 10                	mov    (%eax),%edx
c010659e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01065a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01065a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01065a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01065aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01065ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01065b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01065b3:	89 10                	mov    %edx,(%eax)
}
c01065b5:	90                   	nop
}
c01065b6:	90                   	nop
}
c01065b7:	90                   	nop
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c01065b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01065bd:	c9                   	leave  
c01065be:	c3                   	ret    

c01065bf <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01065bf:	55                   	push   %ebp
c01065c0:	89 e5                	mov    %esp,%ebp
c01065c2:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01065c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01065c8:	8b 40 14             	mov    0x14(%eax),%eax
c01065cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01065ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01065d2:	75 16                	jne    c01065ea <_fifo_swap_out_victim+0x2b>
c01065d4:	68 b3 9a 10 c0       	push   $0xc0109ab3
c01065d9:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01065de:	6a 41                	push   $0x41
c01065e0:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01065e5:	e8 b5 a6 ff ff       	call   c0100c9f <__panic>
     assert(in_tick==0);
c01065ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01065ee:	74 16                	je     c0106606 <_fifo_swap_out_victim+0x47>
c01065f0:	68 c0 9a 10 c0       	push   $0xc0109ac0
c01065f5:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01065fa:	6a 42                	push   $0x42
c01065fc:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106601:	e8 99 a6 ff ff       	call   c0100c9f <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     /* Select the tail */
     list_entry_t *le = head->prev;
c0106606:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106609:	8b 00                	mov    (%eax),%eax
c010660b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c010660e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106611:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106614:	75 16                	jne    c010662c <_fifo_swap_out_victim+0x6d>
c0106616:	68 cb 9a 10 c0       	push   $0xc0109acb
c010661b:	68 8a 9a 10 c0       	push   $0xc0109a8a
c0106620:	6a 49                	push   $0x49
c0106622:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106627:	e8 73 a6 ff ff       	call   c0100c9f <__panic>
     struct Page *p = le2page(le, pra_page_link);
c010662c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010662f:	83 e8 14             	sub    $0x14,%eax
c0106632:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106635:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106638:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c010663b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010663e:	8b 40 04             	mov    0x4(%eax),%eax
c0106641:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106644:	8b 12                	mov    (%edx),%edx
c0106646:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106649:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c010664c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010664f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106652:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106655:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106658:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010665b:	89 10                	mov    %edx,(%eax)
}
c010665d:	90                   	nop
}
c010665e:	90                   	nop
     list_del(le);
     assert(p !=NULL);
c010665f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106663:	75 16                	jne    c010667b <_fifo_swap_out_victim+0xbc>
c0106665:	68 d4 9a 10 c0       	push   $0xc0109ad4
c010666a:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010666f:	6a 4c                	push   $0x4c
c0106671:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106676:	e8 24 a6 ff ff       	call   c0100c9f <__panic>
     *ptr_page = p;
c010667b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010667e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106681:	89 10                	mov    %edx,(%eax)
     return 0;
c0106683:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106688:	c9                   	leave  
c0106689:	c3                   	ret    

c010668a <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c010668a:	55                   	push   %ebp
c010668b:	89 e5                	mov    %esp,%ebp
c010668d:	83 ec 08             	sub    $0x8,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106690:	83 ec 0c             	sub    $0xc,%esp
c0106693:	68 e0 9a 10 c0       	push   $0xc0109ae0
c0106698:	e8 a3 9c ff ff       	call   c0100340 <cprintf>
c010669d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c01066a0:	b8 00 30 00 00       	mov    $0x3000,%eax
c01066a5:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01066a8:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01066ad:	83 f8 04             	cmp    $0x4,%eax
c01066b0:	74 16                	je     c01066c8 <_fifo_check_swap+0x3e>
c01066b2:	68 06 9b 10 c0       	push   $0xc0109b06
c01066b7:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01066bc:	6a 55                	push   $0x55
c01066be:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01066c3:	e8 d7 a5 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01066c8:	83 ec 0c             	sub    $0xc,%esp
c01066cb:	68 18 9b 10 c0       	push   $0xc0109b18
c01066d0:	e8 6b 9c ff ff       	call   c0100340 <cprintf>
c01066d5:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01066d8:	b8 00 10 00 00       	mov    $0x1000,%eax
c01066dd:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01066e0:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01066e5:	83 f8 04             	cmp    $0x4,%eax
c01066e8:	74 16                	je     c0106700 <_fifo_check_swap+0x76>
c01066ea:	68 06 9b 10 c0       	push   $0xc0109b06
c01066ef:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01066f4:	6a 58                	push   $0x58
c01066f6:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01066fb:	e8 9f a5 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106700:	83 ec 0c             	sub    $0xc,%esp
c0106703:	68 40 9b 10 c0       	push   $0xc0109b40
c0106708:	e8 33 9c ff ff       	call   c0100340 <cprintf>
c010670d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0106710:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106715:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106718:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c010671d:	83 f8 04             	cmp    $0x4,%eax
c0106720:	74 16                	je     c0106738 <_fifo_check_swap+0xae>
c0106722:	68 06 9b 10 c0       	push   $0xc0109b06
c0106727:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010672c:	6a 5b                	push   $0x5b
c010672e:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106733:	e8 67 a5 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106738:	83 ec 0c             	sub    $0xc,%esp
c010673b:	68 68 9b 10 c0       	push   $0xc0109b68
c0106740:	e8 fb 9b ff ff       	call   c0100340 <cprintf>
c0106745:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0106748:	b8 00 20 00 00       	mov    $0x2000,%eax
c010674d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106750:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0106755:	83 f8 04             	cmp    $0x4,%eax
c0106758:	74 16                	je     c0106770 <_fifo_check_swap+0xe6>
c010675a:	68 06 9b 10 c0       	push   $0xc0109b06
c010675f:	68 8a 9a 10 c0       	push   $0xc0109a8a
c0106764:	6a 5e                	push   $0x5e
c0106766:	68 9f 9a 10 c0       	push   $0xc0109a9f
c010676b:	e8 2f a5 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106770:	83 ec 0c             	sub    $0xc,%esp
c0106773:	68 90 9b 10 c0       	push   $0xc0109b90
c0106778:	e8 c3 9b ff ff       	call   c0100340 <cprintf>
c010677d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c0106780:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106785:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106788:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c010678d:	83 f8 05             	cmp    $0x5,%eax
c0106790:	74 16                	je     c01067a8 <_fifo_check_swap+0x11e>
c0106792:	68 b6 9b 10 c0       	push   $0xc0109bb6
c0106797:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010679c:	6a 61                	push   $0x61
c010679e:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01067a3:	e8 f7 a4 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01067a8:	83 ec 0c             	sub    $0xc,%esp
c01067ab:	68 68 9b 10 c0       	push   $0xc0109b68
c01067b0:	e8 8b 9b ff ff       	call   c0100340 <cprintf>
c01067b5:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c01067b8:	b8 00 20 00 00       	mov    $0x2000,%eax
c01067bd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01067c0:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01067c5:	83 f8 05             	cmp    $0x5,%eax
c01067c8:	74 16                	je     c01067e0 <_fifo_check_swap+0x156>
c01067ca:	68 b6 9b 10 c0       	push   $0xc0109bb6
c01067cf:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01067d4:	6a 64                	push   $0x64
c01067d6:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01067db:	e8 bf a4 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01067e0:	83 ec 0c             	sub    $0xc,%esp
c01067e3:	68 18 9b 10 c0       	push   $0xc0109b18
c01067e8:	e8 53 9b ff ff       	call   c0100340 <cprintf>
c01067ed:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x1000 = 0x0a;
c01067f0:	b8 00 10 00 00       	mov    $0x1000,%eax
c01067f5:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01067f8:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01067fd:	83 f8 06             	cmp    $0x6,%eax
c0106800:	74 16                	je     c0106818 <_fifo_check_swap+0x18e>
c0106802:	68 c5 9b 10 c0       	push   $0xc0109bc5
c0106807:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010680c:	6a 67                	push   $0x67
c010680e:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106813:	e8 87 a4 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106818:	83 ec 0c             	sub    $0xc,%esp
c010681b:	68 68 9b 10 c0       	push   $0xc0109b68
c0106820:	e8 1b 9b ff ff       	call   c0100340 <cprintf>
c0106825:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x2000 = 0x0b;
c0106828:	b8 00 20 00 00       	mov    $0x2000,%eax
c010682d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106830:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0106835:	83 f8 07             	cmp    $0x7,%eax
c0106838:	74 16                	je     c0106850 <_fifo_check_swap+0x1c6>
c010683a:	68 d4 9b 10 c0       	push   $0xc0109bd4
c010683f:	68 8a 9a 10 c0       	push   $0xc0109a8a
c0106844:	6a 6a                	push   $0x6a
c0106846:	68 9f 9a 10 c0       	push   $0xc0109a9f
c010684b:	e8 4f a4 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106850:	83 ec 0c             	sub    $0xc,%esp
c0106853:	68 e0 9a 10 c0       	push   $0xc0109ae0
c0106858:	e8 e3 9a ff ff       	call   c0100340 <cprintf>
c010685d:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x3000 = 0x0c;
c0106860:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106865:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106868:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c010686d:	83 f8 08             	cmp    $0x8,%eax
c0106870:	74 16                	je     c0106888 <_fifo_check_swap+0x1fe>
c0106872:	68 e3 9b 10 c0       	push   $0xc0109be3
c0106877:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010687c:	6a 6d                	push   $0x6d
c010687e:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106883:	e8 17 a4 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106888:	83 ec 0c             	sub    $0xc,%esp
c010688b:	68 40 9b 10 c0       	push   $0xc0109b40
c0106890:	e8 ab 9a ff ff       	call   c0100340 <cprintf>
c0106895:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x4000 = 0x0d;
c0106898:	b8 00 40 00 00       	mov    $0x4000,%eax
c010689d:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c01068a0:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01068a5:	83 f8 09             	cmp    $0x9,%eax
c01068a8:	74 16                	je     c01068c0 <_fifo_check_swap+0x236>
c01068aa:	68 f2 9b 10 c0       	push   $0xc0109bf2
c01068af:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01068b4:	6a 70                	push   $0x70
c01068b6:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01068bb:	e8 df a3 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01068c0:	83 ec 0c             	sub    $0xc,%esp
c01068c3:	68 90 9b 10 c0       	push   $0xc0109b90
c01068c8:	e8 73 9a ff ff       	call   c0100340 <cprintf>
c01068cd:	83 c4 10             	add    $0x10,%esp
    *(unsigned char *)0x5000 = 0x0e;
c01068d0:	b8 00 50 00 00       	mov    $0x5000,%eax
c01068d5:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c01068d8:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01068dd:	83 f8 0a             	cmp    $0xa,%eax
c01068e0:	74 16                	je     c01068f8 <_fifo_check_swap+0x26e>
c01068e2:	68 01 9c 10 c0       	push   $0xc0109c01
c01068e7:	68 8a 9a 10 c0       	push   $0xc0109a8a
c01068ec:	6a 73                	push   $0x73
c01068ee:	68 9f 9a 10 c0       	push   $0xc0109a9f
c01068f3:	e8 a7 a3 ff ff       	call   c0100c9f <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01068f8:	83 ec 0c             	sub    $0xc,%esp
c01068fb:	68 18 9b 10 c0       	push   $0xc0109b18
c0106900:	e8 3b 9a ff ff       	call   c0100340 <cprintf>
c0106905:	83 c4 10             	add    $0x10,%esp
    assert(*(unsigned char *)0x1000 == 0x0a);
c0106908:	b8 00 10 00 00       	mov    $0x1000,%eax
c010690d:	0f b6 00             	movzbl (%eax),%eax
c0106910:	3c 0a                	cmp    $0xa,%al
c0106912:	74 16                	je     c010692a <_fifo_check_swap+0x2a0>
c0106914:	68 14 9c 10 c0       	push   $0xc0109c14
c0106919:	68 8a 9a 10 c0       	push   $0xc0109a8a
c010691e:	6a 75                	push   $0x75
c0106920:	68 9f 9a 10 c0       	push   $0xc0109a9f
c0106925:	e8 75 a3 ff ff       	call   c0100c9f <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c010692a:	b8 00 10 00 00       	mov    $0x1000,%eax
c010692f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0106932:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c0106937:	83 f8 0b             	cmp    $0xb,%eax
c010693a:	74 16                	je     c0106952 <_fifo_check_swap+0x2c8>
c010693c:	68 35 9c 10 c0       	push   $0xc0109c35
c0106941:	68 8a 9a 10 c0       	push   $0xc0109a8a
c0106946:	6a 77                	push   $0x77
c0106948:	68 9f 9a 10 c0       	push   $0xc0109a9f
c010694d:	e8 4d a3 ff ff       	call   c0100c9f <__panic>
    return 0;
c0106952:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106957:	c9                   	leave  
c0106958:	c3                   	ret    

c0106959 <_fifo_init>:


static int
_fifo_init(void)
{
c0106959:	55                   	push   %ebp
c010695a:	89 e5                	mov    %esp,%ebp
    return 0;
c010695c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106961:	5d                   	pop    %ebp
c0106962:	c3                   	ret    

c0106963 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106963:	55                   	push   %ebp
c0106964:	89 e5                	mov    %esp,%ebp
    return 0;
c0106966:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010696b:	5d                   	pop    %ebp
c010696c:	c3                   	ret    

c010696d <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010696d:	55                   	push   %ebp
c010696e:	89 e5                	mov    %esp,%ebp
c0106970:	b8 00 00 00 00       	mov    $0x0,%eax
c0106975:	5d                   	pop    %ebp
c0106976:	c3                   	ret    

c0106977 <pa2page>:
pa2page(uintptr_t pa) {
c0106977:	55                   	push   %ebp
c0106978:	89 e5                	mov    %esp,%ebp
c010697a:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c010697d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106980:	c1 e8 0c             	shr    $0xc,%eax
c0106983:	89 c2                	mov    %eax,%edx
c0106985:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c010698a:	39 c2                	cmp    %eax,%edx
c010698c:	72 14                	jb     c01069a2 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c010698e:	83 ec 04             	sub    $0x4,%esp
c0106991:	68 58 9c 10 c0       	push   $0xc0109c58
c0106996:	6a 5b                	push   $0x5b
c0106998:	68 77 9c 10 c0       	push   $0xc0109c77
c010699d:	e8 fd a2 ff ff       	call   c0100c9f <__panic>
    return &pages[PPN(pa)];
c01069a2:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c01069a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ab:	c1 e8 0c             	shr    $0xc,%eax
c01069ae:	c1 e0 05             	shl    $0x5,%eax
c01069b1:	01 d0                	add    %edx,%eax
}
c01069b3:	c9                   	leave  
c01069b4:	c3                   	ret    

c01069b5 <pde2page>:
pde2page(pde_t pde) {
c01069b5:	55                   	push   %ebp
c01069b6:	89 e5                	mov    %esp,%ebp
c01069b8:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c01069bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01069be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069c3:	83 ec 0c             	sub    $0xc,%esp
c01069c6:	50                   	push   %eax
c01069c7:	e8 ab ff ff ff       	call   c0106977 <pa2page>
c01069cc:	83 c4 10             	add    $0x10,%esp
}
c01069cf:	c9                   	leave  
c01069d0:	c3                   	ret    

c01069d1 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01069d1:	55                   	push   %ebp
c01069d2:	89 e5                	mov    %esp,%ebp
c01069d4:	83 ec 18             	sub    $0x18,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01069d7:	83 ec 0c             	sub    $0xc,%esp
c01069da:	6a 18                	push   $0x18
c01069dc:	e8 64 ef ff ff       	call   c0105945 <kmalloc>
c01069e1:	83 c4 10             	add    $0x10,%esp
c01069e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01069e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01069eb:	74 5c                	je     c0106a49 <mm_create+0x78>
        list_init(&(mm->mmap_list));
c01069ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
c01069f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01069f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01069f9:	89 50 04             	mov    %edx,0x4(%eax)
c01069fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01069ff:	8b 50 04             	mov    0x4(%eax),%edx
c0106a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106a05:	89 10                	mov    %edx,(%eax)
}
c0106a07:	90                   	nop
        mm->mmap_cache = NULL;
c0106a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0106a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0106a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a1f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0106a26:	a1 44 60 12 c0       	mov    0xc0126044,%eax
c0106a2b:	85 c0                	test   %eax,%eax
c0106a2d:	74 10                	je     c0106a3f <mm_create+0x6e>
c0106a2f:	83 ec 0c             	sub    $0xc,%esp
c0106a32:	ff 75 f4             	push   -0xc(%ebp)
c0106a35:	e8 1f f1 ff ff       	call   c0105b59 <swap_init_mm>
c0106a3a:	83 c4 10             	add    $0x10,%esp
c0106a3d:	eb 0a                	jmp    c0106a49 <mm_create+0x78>
        else mm->sm_priv = NULL;
c0106a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a42:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0106a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106a4c:	c9                   	leave  
c0106a4d:	c3                   	ret    

c0106a4e <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0106a4e:	55                   	push   %ebp
c0106a4f:	89 e5                	mov    %esp,%ebp
c0106a51:	83 ec 18             	sub    $0x18,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0106a54:	83 ec 0c             	sub    $0xc,%esp
c0106a57:	6a 18                	push   $0x18
c0106a59:	e8 e7 ee ff ff       	call   c0105945 <kmalloc>
c0106a5e:	83 c4 10             	add    $0x10,%esp
c0106a61:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0106a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106a68:	74 1b                	je     c0106a85 <vma_create+0x37>
        vma->vm_start = vm_start;
c0106a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a6d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106a70:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0106a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a76:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a79:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0106a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a7f:	8b 55 10             	mov    0x10(%ebp),%edx
c0106a82:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0106a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106a88:	c9                   	leave  
c0106a89:	c3                   	ret    

c0106a8a <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0106a8a:	55                   	push   %ebp
c0106a8b:	89 e5                	mov    %esp,%ebp
c0106a8d:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0106a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0106a97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106a9b:	0f 84 95 00 00 00    	je     c0106b36 <find_vma+0xac>
        vma = mm->mmap_cache;
c0106aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa4:	8b 40 08             	mov    0x8(%eax),%eax
c0106aa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0106aaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106aae:	74 16                	je     c0106ac6 <find_vma+0x3c>
c0106ab0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ab3:	8b 40 04             	mov    0x4(%eax),%eax
c0106ab6:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0106ab9:	72 0b                	jb     c0106ac6 <find_vma+0x3c>
c0106abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106abe:	8b 40 08             	mov    0x8(%eax),%eax
c0106ac1:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0106ac4:	72 61                	jb     c0106b27 <find_vma+0x9d>
                bool found = 0;
c0106ac6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0106acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0106ad9:	eb 28                	jmp    c0106b03 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0106adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ade:	83 e8 10             	sub    $0x10,%eax
c0106ae1:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0106ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ae7:	8b 40 04             	mov    0x4(%eax),%eax
c0106aea:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0106aed:	72 14                	jb     c0106b03 <find_vma+0x79>
c0106aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106af2:	8b 40 08             	mov    0x8(%eax),%eax
c0106af5:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0106af8:	73 09                	jae    c0106b03 <find_vma+0x79>
                        found = 1;
c0106afa:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0106b01:	eb 17                	jmp    c0106b1a <find_vma+0x90>
c0106b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b06:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return listelm->next;
c0106b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b0c:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c0106b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106b18:	75 c1                	jne    c0106adb <find_vma+0x51>
                    }
                }
                if (!found) {
c0106b1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0106b1e:	75 07                	jne    c0106b27 <find_vma+0x9d>
                    vma = NULL;
c0106b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0106b27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106b2b:	74 09                	je     c0106b36 <find_vma+0xac>
            mm->mmap_cache = vma;
c0106b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b30:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106b33:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0106b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106b39:	c9                   	leave  
c0106b3a:	c3                   	ret    

c0106b3b <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0106b3b:	55                   	push   %ebp
c0106b3c:	89 e5                	mov    %esp,%ebp
c0106b3e:	83 ec 08             	sub    $0x8,%esp
    assert(prev->vm_start < prev->vm_end);
c0106b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b44:	8b 50 04             	mov    0x4(%eax),%edx
c0106b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b4a:	8b 40 08             	mov    0x8(%eax),%eax
c0106b4d:	39 c2                	cmp    %eax,%edx
c0106b4f:	72 16                	jb     c0106b67 <check_vma_overlap+0x2c>
c0106b51:	68 85 9c 10 c0       	push   $0xc0109c85
c0106b56:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106b5b:	6a 67                	push   $0x67
c0106b5d:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106b62:	e8 38 a1 ff ff       	call   c0100c9f <__panic>
    assert(prev->vm_end <= next->vm_start);
c0106b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6a:	8b 50 08             	mov    0x8(%eax),%edx
c0106b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b70:	8b 40 04             	mov    0x4(%eax),%eax
c0106b73:	39 c2                	cmp    %eax,%edx
c0106b75:	76 16                	jbe    c0106b8d <check_vma_overlap+0x52>
c0106b77:	68 c8 9c 10 c0       	push   $0xc0109cc8
c0106b7c:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106b81:	6a 68                	push   $0x68
c0106b83:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106b88:	e8 12 a1 ff ff       	call   c0100c9f <__panic>
    assert(next->vm_start < next->vm_end);
c0106b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b90:	8b 50 04             	mov    0x4(%eax),%edx
c0106b93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b96:	8b 40 08             	mov    0x8(%eax),%eax
c0106b99:	39 c2                	cmp    %eax,%edx
c0106b9b:	72 16                	jb     c0106bb3 <check_vma_overlap+0x78>
c0106b9d:	68 e7 9c 10 c0       	push   $0xc0109ce7
c0106ba2:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106ba7:	6a 69                	push   $0x69
c0106ba9:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106bae:	e8 ec a0 ff ff       	call   c0100c9f <__panic>
}
c0106bb3:	90                   	nop
c0106bb4:	c9                   	leave  
c0106bb5:	c3                   	ret    

c0106bb6 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0106bb6:	55                   	push   %ebp
c0106bb7:	89 e5                	mov    %esp,%ebp
c0106bb9:	83 ec 38             	sub    $0x38,%esp
    assert(vma->vm_start < vma->vm_end);
c0106bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bbf:	8b 50 04             	mov    0x4(%eax),%edx
c0106bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bc5:	8b 40 08             	mov    0x8(%eax),%eax
c0106bc8:	39 c2                	cmp    %eax,%edx
c0106bca:	72 16                	jb     c0106be2 <insert_vma_struct+0x2c>
c0106bcc:	68 05 9d 10 c0       	push   $0xc0109d05
c0106bd1:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106bd6:	6a 70                	push   $0x70
c0106bd8:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106bdd:	e8 bd a0 ff ff       	call   c0100c9f <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0106be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0106be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106beb:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0106bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0106bf4:	eb 1f                	jmp    c0106c15 <insert_vma_struct+0x5f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0106bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bf9:	83 e8 10             	sub    $0x10,%eax
c0106bfc:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0106bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c02:	8b 50 04             	mov    0x4(%eax),%edx
c0106c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c08:	8b 40 04             	mov    0x4(%eax),%eax
c0106c0b:	39 c2                	cmp    %eax,%edx
c0106c0d:	77 1f                	ja     c0106c2e <insert_vma_struct+0x78>
                break;
            }
            le_prev = le;
c0106c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c18:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c1e:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0106c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c27:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106c2a:	75 ca                	jne    c0106bf6 <insert_vma_struct+0x40>
c0106c2c:	eb 01                	jmp    c0106c2f <insert_vma_struct+0x79>
                break;
c0106c2e:	90                   	nop
c0106c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c32:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c38:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c0106c3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0106c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106c44:	74 15                	je     c0106c5b <insert_vma_struct+0xa5>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0106c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c49:	83 e8 10             	sub    $0x10,%eax
c0106c4c:	83 ec 08             	sub    $0x8,%esp
c0106c4f:	ff 75 0c             	push   0xc(%ebp)
c0106c52:	50                   	push   %eax
c0106c53:	e8 e3 fe ff ff       	call   c0106b3b <check_vma_overlap>
c0106c58:	83 c4 10             	add    $0x10,%esp
    }
    if (le_next != list) {
c0106c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106c61:	74 15                	je     c0106c78 <insert_vma_struct+0xc2>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0106c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c66:	83 e8 10             	sub    $0x10,%eax
c0106c69:	83 ec 08             	sub    $0x8,%esp
c0106c6c:	50                   	push   %eax
c0106c6d:	ff 75 0c             	push   0xc(%ebp)
c0106c70:	e8 c6 fe ff ff       	call   c0106b3b <check_vma_overlap>
c0106c75:	83 c4 10             	add    $0x10,%esp
    }

    vma->vm_mm = mm;
c0106c78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c7b:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c7e:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0106c80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c83:	8d 50 10             	lea    0x10(%eax),%edx
c0106c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c89:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0106c8c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0106c8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106c92:	8b 40 04             	mov    0x4(%eax),%eax
c0106c95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c98:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0106c9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c9e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0106ca1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0106ca4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106ca7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106caa:	89 10                	mov    %edx,(%eax)
c0106cac:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106caf:	8b 10                	mov    (%eax),%edx
c0106cb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106cb4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106cb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cba:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0106cbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106cc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cc3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106cc6:	89 10                	mov    %edx,(%eax)
}
c0106cc8:	90                   	nop
}
c0106cc9:	90                   	nop

    mm->map_count ++;
c0106cca:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ccd:	8b 40 10             	mov    0x10(%eax),%eax
c0106cd0:	8d 50 01             	lea    0x1(%eax),%edx
c0106cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd6:	89 50 10             	mov    %edx,0x10(%eax)
}
c0106cd9:	90                   	nop
c0106cda:	c9                   	leave  
c0106cdb:	c3                   	ret    

c0106cdc <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0106cdc:	55                   	push   %ebp
c0106cdd:	89 e5                	mov    %esp,%ebp
c0106cdf:	83 ec 28             	sub    $0x28,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0106ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0106ce8:	eb 3e                	jmp    c0106d28 <mm_destroy+0x4c>
c0106cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c0106cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106cf3:	8b 40 04             	mov    0x4(%eax),%eax
c0106cf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106cf9:	8b 12                	mov    (%edx),%edx
c0106cfb:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    prev->next = next;
c0106d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d07:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d10:	89 10                	mov    %edx,(%eax)
}
c0106d12:	90                   	nop
}
c0106d13:	90                   	nop
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0106d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d17:	83 e8 10             	sub    $0x10,%eax
c0106d1a:	83 ec 08             	sub    $0x8,%esp
c0106d1d:	6a 18                	push   $0x18
c0106d1f:	50                   	push   %eax
c0106d20:	e8 b1 ec ff ff       	call   c01059d6 <kfree>
c0106d25:	83 c4 10             	add    $0x10,%esp
c0106d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0106d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d31:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c0106d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106d3d:	75 ab                	jne    c0106cea <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0106d3f:	83 ec 08             	sub    $0x8,%esp
c0106d42:	6a 18                	push   $0x18
c0106d44:	ff 75 08             	push   0x8(%ebp)
c0106d47:	e8 8a ec ff ff       	call   c01059d6 <kfree>
c0106d4c:	83 c4 10             	add    $0x10,%esp
    mm=NULL;
c0106d4f:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0106d56:	90                   	nop
c0106d57:	c9                   	leave  
c0106d58:	c3                   	ret    

c0106d59 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0106d59:	55                   	push   %ebp
c0106d5a:	89 e5                	mov    %esp,%ebp
c0106d5c:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0106d5f:	e8 03 00 00 00       	call   c0106d67 <check_vmm>
}
c0106d64:	90                   	nop
c0106d65:	c9                   	leave  
c0106d66:	c3                   	ret    

c0106d67 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0106d67:	55                   	push   %ebp
c0106d68:	89 e5                	mov    %esp,%ebp
c0106d6a:	83 ec 18             	sub    $0x18,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0106d6d:	e8 9b d7 ff ff       	call   c010450d <nr_free_pages>
c0106d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0106d75:	e8 3b 00 00 00       	call   c0106db5 <check_vma_struct>
    check_pgfault();
c0106d7a:	e8 56 04 00 00       	call   c01071d5 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0106d7f:	e8 89 d7 ff ff       	call   c010450d <nr_free_pages>
c0106d84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0106d87:	74 19                	je     c0106da2 <check_vmm+0x3b>
c0106d89:	68 24 9d 10 c0       	push   $0xc0109d24
c0106d8e:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106d93:	68 a9 00 00 00       	push   $0xa9
c0106d98:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106d9d:	e8 fd 9e ff ff       	call   c0100c9f <__panic>

    cprintf("check_vmm() succeeded.\n");
c0106da2:	83 ec 0c             	sub    $0xc,%esp
c0106da5:	68 4b 9d 10 c0       	push   $0xc0109d4b
c0106daa:	e8 91 95 ff ff       	call   c0100340 <cprintf>
c0106daf:	83 c4 10             	add    $0x10,%esp
}
c0106db2:	90                   	nop
c0106db3:	c9                   	leave  
c0106db4:	c3                   	ret    

c0106db5 <check_vma_struct>:

static void
check_vma_struct(void) {
c0106db5:	55                   	push   %ebp
c0106db6:	89 e5                	mov    %esp,%ebp
c0106db8:	83 ec 58             	sub    $0x58,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0106dbb:	e8 4d d7 ff ff       	call   c010450d <nr_free_pages>
c0106dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0106dc3:	e8 09 fc ff ff       	call   c01069d1 <mm_create>
c0106dc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0106dcb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106dcf:	75 19                	jne    c0106dea <check_vma_struct+0x35>
c0106dd1:	68 63 9d 10 c0       	push   $0xc0109d63
c0106dd6:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106ddb:	68 b3 00 00 00       	push   $0xb3
c0106de0:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106de5:	e8 b5 9e ff ff       	call   c0100c9f <__panic>

    int step1 = 10, step2 = step1 * 10;
c0106dea:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0106df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106df4:	89 d0                	mov    %edx,%eax
c0106df6:	c1 e0 02             	shl    $0x2,%eax
c0106df9:	01 d0                	add    %edx,%eax
c0106dfb:	01 c0                	add    %eax,%eax
c0106dfd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0106e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106e06:	eb 5f                	jmp    c0106e67 <check_vma_struct+0xb2>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0106e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e0b:	89 d0                	mov    %edx,%eax
c0106e0d:	c1 e0 02             	shl    $0x2,%eax
c0106e10:	01 d0                	add    %edx,%eax
c0106e12:	83 c0 02             	add    $0x2,%eax
c0106e15:	89 c1                	mov    %eax,%ecx
c0106e17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e1a:	89 d0                	mov    %edx,%eax
c0106e1c:	c1 e0 02             	shl    $0x2,%eax
c0106e1f:	01 d0                	add    %edx,%eax
c0106e21:	83 ec 04             	sub    $0x4,%esp
c0106e24:	6a 00                	push   $0x0
c0106e26:	51                   	push   %ecx
c0106e27:	50                   	push   %eax
c0106e28:	e8 21 fc ff ff       	call   c0106a4e <vma_create>
c0106e2d:	83 c4 10             	add    $0x10,%esp
c0106e30:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma != NULL);
c0106e33:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106e37:	75 19                	jne    c0106e52 <check_vma_struct+0x9d>
c0106e39:	68 6e 9d 10 c0       	push   $0xc0109d6e
c0106e3e:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106e43:	68 ba 00 00 00       	push   $0xba
c0106e48:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106e4d:	e8 4d 9e ff ff       	call   c0100c9f <__panic>
        insert_vma_struct(mm, vma);
c0106e52:	83 ec 08             	sub    $0x8,%esp
c0106e55:	ff 75 bc             	push   -0x44(%ebp)
c0106e58:	ff 75 e8             	push   -0x18(%ebp)
c0106e5b:	e8 56 fd ff ff       	call   c0106bb6 <insert_vma_struct>
c0106e60:	83 c4 10             	add    $0x10,%esp
    for (i = step1; i >= 1; i --) {
c0106e63:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e6b:	7f 9b                	jg     c0106e08 <check_vma_struct+0x53>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0106e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e70:	83 c0 01             	add    $0x1,%eax
c0106e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106e76:	eb 5f                	jmp    c0106ed7 <check_vma_struct+0x122>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0106e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e7b:	89 d0                	mov    %edx,%eax
c0106e7d:	c1 e0 02             	shl    $0x2,%eax
c0106e80:	01 d0                	add    %edx,%eax
c0106e82:	83 c0 02             	add    $0x2,%eax
c0106e85:	89 c1                	mov    %eax,%ecx
c0106e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e8a:	89 d0                	mov    %edx,%eax
c0106e8c:	c1 e0 02             	shl    $0x2,%eax
c0106e8f:	01 d0                	add    %edx,%eax
c0106e91:	83 ec 04             	sub    $0x4,%esp
c0106e94:	6a 00                	push   $0x0
c0106e96:	51                   	push   %ecx
c0106e97:	50                   	push   %eax
c0106e98:	e8 b1 fb ff ff       	call   c0106a4e <vma_create>
c0106e9d:	83 c4 10             	add    $0x10,%esp
c0106ea0:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma != NULL);
c0106ea3:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0106ea7:	75 19                	jne    c0106ec2 <check_vma_struct+0x10d>
c0106ea9:	68 6e 9d 10 c0       	push   $0xc0109d6e
c0106eae:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106eb3:	68 c0 00 00 00       	push   $0xc0
c0106eb8:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106ebd:	e8 dd 9d ff ff       	call   c0100c9f <__panic>
        insert_vma_struct(mm, vma);
c0106ec2:	83 ec 08             	sub    $0x8,%esp
c0106ec5:	ff 75 c0             	push   -0x40(%ebp)
c0106ec8:	ff 75 e8             	push   -0x18(%ebp)
c0106ecb:	e8 e6 fc ff ff       	call   c0106bb6 <insert_vma_struct>
c0106ed0:	83 c4 10             	add    $0x10,%esp
    for (i = step1 + 1; i <= step2; i ++) {
c0106ed3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106eda:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0106edd:	7e 99                	jle    c0106e78 <check_vma_struct+0xc3>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0106edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ee2:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106ee5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106ee8:	8b 40 04             	mov    0x4(%eax),%eax
c0106eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0106eee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0106ef5:	e9 81 00 00 00       	jmp    c0106f7b <check_vma_struct+0x1c6>
        assert(le != &(mm->mmap_list));
c0106efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106efd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106f00:	75 19                	jne    c0106f1b <check_vma_struct+0x166>
c0106f02:	68 7a 9d 10 c0       	push   $0xc0109d7a
c0106f07:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106f0c:	68 c7 00 00 00       	push   $0xc7
c0106f11:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106f16:	e8 84 9d ff ff       	call   c0100c9f <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0106f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f1e:	83 e8 10             	sub    $0x10,%eax
c0106f21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0106f24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106f27:	8b 48 04             	mov    0x4(%eax),%ecx
c0106f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106f2d:	89 d0                	mov    %edx,%eax
c0106f2f:	c1 e0 02             	shl    $0x2,%eax
c0106f32:	01 d0                	add    %edx,%eax
c0106f34:	39 c1                	cmp    %eax,%ecx
c0106f36:	75 17                	jne    c0106f4f <check_vma_struct+0x19a>
c0106f38:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106f3b:	8b 48 08             	mov    0x8(%eax),%ecx
c0106f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106f41:	89 d0                	mov    %edx,%eax
c0106f43:	c1 e0 02             	shl    $0x2,%eax
c0106f46:	01 d0                	add    %edx,%eax
c0106f48:	83 c0 02             	add    $0x2,%eax
c0106f4b:	39 c1                	cmp    %eax,%ecx
c0106f4d:	74 19                	je     c0106f68 <check_vma_struct+0x1b3>
c0106f4f:	68 94 9d 10 c0       	push   $0xc0109d94
c0106f54:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106f59:	68 c9 00 00 00       	push   $0xc9
c0106f5e:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106f63:	e8 37 9d ff ff       	call   c0100c9f <__panic>
c0106f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0106f6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106f71:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0106f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c0106f77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f7e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0106f81:	0f 8e 73 ff ff ff    	jle    c0106efa <check_vma_struct+0x145>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0106f87:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0106f8e:	e9 80 01 00 00       	jmp    c0107113 <check_vma_struct+0x35e>
        struct vma_struct *vma1 = find_vma(mm, i);
c0106f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f96:	83 ec 08             	sub    $0x8,%esp
c0106f99:	50                   	push   %eax
c0106f9a:	ff 75 e8             	push   -0x18(%ebp)
c0106f9d:	e8 e8 fa ff ff       	call   c0106a8a <find_vma>
c0106fa2:	83 c4 10             	add    $0x10,%esp
c0106fa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma1 != NULL);
c0106fa8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106fac:	75 19                	jne    c0106fc7 <check_vma_struct+0x212>
c0106fae:	68 c9 9d 10 c0       	push   $0xc0109dc9
c0106fb3:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106fb8:	68 cf 00 00 00       	push   $0xcf
c0106fbd:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106fc2:	e8 d8 9c ff ff       	call   c0100c9f <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0106fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106fca:	83 c0 01             	add    $0x1,%eax
c0106fcd:	83 ec 08             	sub    $0x8,%esp
c0106fd0:	50                   	push   %eax
c0106fd1:	ff 75 e8             	push   -0x18(%ebp)
c0106fd4:	e8 b1 fa ff ff       	call   c0106a8a <find_vma>
c0106fd9:	83 c4 10             	add    $0x10,%esp
c0106fdc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(vma2 != NULL);
c0106fdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106fe3:	75 19                	jne    c0106ffe <check_vma_struct+0x249>
c0106fe5:	68 d6 9d 10 c0       	push   $0xc0109dd6
c0106fea:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0106fef:	68 d1 00 00 00       	push   $0xd1
c0106ff4:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0106ff9:	e8 a1 9c ff ff       	call   c0100c9f <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0106ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107001:	83 c0 02             	add    $0x2,%eax
c0107004:	83 ec 08             	sub    $0x8,%esp
c0107007:	50                   	push   %eax
c0107008:	ff 75 e8             	push   -0x18(%ebp)
c010700b:	e8 7a fa ff ff       	call   c0106a8a <find_vma>
c0107010:	83 c4 10             	add    $0x10,%esp
c0107013:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma3 == NULL);
c0107016:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010701a:	74 19                	je     c0107035 <check_vma_struct+0x280>
c010701c:	68 e3 9d 10 c0       	push   $0xc0109de3
c0107021:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107026:	68 d3 00 00 00       	push   $0xd3
c010702b:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0107030:	e8 6a 9c ff ff       	call   c0100c9f <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107035:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107038:	83 c0 03             	add    $0x3,%eax
c010703b:	83 ec 08             	sub    $0x8,%esp
c010703e:	50                   	push   %eax
c010703f:	ff 75 e8             	push   -0x18(%ebp)
c0107042:	e8 43 fa ff ff       	call   c0106a8a <find_vma>
c0107047:	83 c4 10             	add    $0x10,%esp
c010704a:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma4 == NULL);
c010704d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107051:	74 19                	je     c010706c <check_vma_struct+0x2b7>
c0107053:	68 f0 9d 10 c0       	push   $0xc0109df0
c0107058:	68 a3 9c 10 c0       	push   $0xc0109ca3
c010705d:	68 d5 00 00 00       	push   $0xd5
c0107062:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0107067:	e8 33 9c ff ff       	call   c0100c9f <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c010706c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010706f:	83 c0 04             	add    $0x4,%eax
c0107072:	83 ec 08             	sub    $0x8,%esp
c0107075:	50                   	push   %eax
c0107076:	ff 75 e8             	push   -0x18(%ebp)
c0107079:	e8 0c fa ff ff       	call   c0106a8a <find_vma>
c010707e:	83 c4 10             	add    $0x10,%esp
c0107081:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma5 == NULL);
c0107084:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107088:	74 19                	je     c01070a3 <check_vma_struct+0x2ee>
c010708a:	68 fd 9d 10 c0       	push   $0xc0109dfd
c010708f:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107094:	68 d7 00 00 00       	push   $0xd7
c0107099:	68 b8 9c 10 c0       	push   $0xc0109cb8
c010709e:	e8 fc 9b ff ff       	call   c0100c9f <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01070a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01070a6:	8b 50 04             	mov    0x4(%eax),%edx
c01070a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070ac:	39 c2                	cmp    %eax,%edx
c01070ae:	75 10                	jne    c01070c0 <check_vma_struct+0x30b>
c01070b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01070b3:	8b 40 08             	mov    0x8(%eax),%eax
c01070b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01070b9:	83 c2 02             	add    $0x2,%edx
c01070bc:	39 d0                	cmp    %edx,%eax
c01070be:	74 19                	je     c01070d9 <check_vma_struct+0x324>
c01070c0:	68 0c 9e 10 c0       	push   $0xc0109e0c
c01070c5:	68 a3 9c 10 c0       	push   $0xc0109ca3
c01070ca:	68 d9 00 00 00       	push   $0xd9
c01070cf:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01070d4:	e8 c6 9b ff ff       	call   c0100c9f <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01070d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01070dc:	8b 50 04             	mov    0x4(%eax),%edx
c01070df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070e2:	39 c2                	cmp    %eax,%edx
c01070e4:	75 10                	jne    c01070f6 <check_vma_struct+0x341>
c01070e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01070e9:	8b 40 08             	mov    0x8(%eax),%eax
c01070ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01070ef:	83 c2 02             	add    $0x2,%edx
c01070f2:	39 d0                	cmp    %edx,%eax
c01070f4:	74 19                	je     c010710f <check_vma_struct+0x35a>
c01070f6:	68 3c 9e 10 c0       	push   $0xc0109e3c
c01070fb:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107100:	68 da 00 00 00       	push   $0xda
c0107105:	68 b8 9c 10 c0       	push   $0xc0109cb8
c010710a:	e8 90 9b ff ff       	call   c0100c9f <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c010710f:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107113:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107116:	89 d0                	mov    %edx,%eax
c0107118:	c1 e0 02             	shl    $0x2,%eax
c010711b:	01 d0                	add    %edx,%eax
c010711d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107120:	0f 8e 6d fe ff ff    	jle    c0106f93 <check_vma_struct+0x1de>
    }

    for (i =4; i>=0; i--) {
c0107126:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c010712d:	eb 5c                	jmp    c010718b <check_vma_struct+0x3d6>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c010712f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107132:	83 ec 08             	sub    $0x8,%esp
c0107135:	50                   	push   %eax
c0107136:	ff 75 e8             	push   -0x18(%ebp)
c0107139:	e8 4c f9 ff ff       	call   c0106a8a <find_vma>
c010713e:	83 c4 10             	add    $0x10,%esp
c0107141:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (vma_below_5 != NULL ) {
c0107144:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107148:	74 1e                	je     c0107168 <check_vma_struct+0x3b3>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010714a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010714d:	8b 50 08             	mov    0x8(%eax),%edx
c0107150:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107153:	8b 40 04             	mov    0x4(%eax),%eax
c0107156:	52                   	push   %edx
c0107157:	50                   	push   %eax
c0107158:	ff 75 f4             	push   -0xc(%ebp)
c010715b:	68 6c 9e 10 c0       	push   $0xc0109e6c
c0107160:	e8 db 91 ff ff       	call   c0100340 <cprintf>
c0107165:	83 c4 10             	add    $0x10,%esp
        }
        assert(vma_below_5 == NULL);
c0107168:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010716c:	74 19                	je     c0107187 <check_vma_struct+0x3d2>
c010716e:	68 91 9e 10 c0       	push   $0xc0109e91
c0107173:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107178:	68 e2 00 00 00       	push   $0xe2
c010717d:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0107182:	e8 18 9b ff ff       	call   c0100c9f <__panic>
    for (i =4; i>=0; i--) {
c0107187:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010718b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010718f:	79 9e                	jns    c010712f <check_vma_struct+0x37a>
    }

    mm_destroy(mm);
c0107191:	83 ec 0c             	sub    $0xc,%esp
c0107194:	ff 75 e8             	push   -0x18(%ebp)
c0107197:	e8 40 fb ff ff       	call   c0106cdc <mm_destroy>
c010719c:	83 c4 10             	add    $0x10,%esp

    assert(nr_free_pages_store == nr_free_pages());
c010719f:	e8 69 d3 ff ff       	call   c010450d <nr_free_pages>
c01071a4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01071a7:	74 19                	je     c01071c2 <check_vma_struct+0x40d>
c01071a9:	68 24 9d 10 c0       	push   $0xc0109d24
c01071ae:	68 a3 9c 10 c0       	push   $0xc0109ca3
c01071b3:	68 e7 00 00 00       	push   $0xe7
c01071b8:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01071bd:	e8 dd 9a ff ff       	call   c0100c9f <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c01071c2:	83 ec 0c             	sub    $0xc,%esp
c01071c5:	68 a8 9e 10 c0       	push   $0xc0109ea8
c01071ca:	e8 71 91 ff ff       	call   c0100340 <cprintf>
c01071cf:	83 c4 10             	add    $0x10,%esp
}
c01071d2:	90                   	nop
c01071d3:	c9                   	leave  
c01071d4:	c3                   	ret    

c01071d5 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01071d5:	55                   	push   %ebp
c01071d6:	89 e5                	mov    %esp,%ebp
c01071d8:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01071db:	e8 2d d3 ff ff       	call   c010450d <nr_free_pages>
c01071e0:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c01071e3:	e8 e9 f7 ff ff       	call   c01069d1 <mm_create>
c01071e8:	a3 0c 61 12 c0       	mov    %eax,0xc012610c
    assert(check_mm_struct != NULL);
c01071ed:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c01071f2:	85 c0                	test   %eax,%eax
c01071f4:	75 19                	jne    c010720f <check_pgfault+0x3a>
c01071f6:	68 c7 9e 10 c0       	push   $0xc0109ec7
c01071fb:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107200:	68 f4 00 00 00       	push   $0xf4
c0107205:	68 b8 9c 10 c0       	push   $0xc0109cb8
c010720a:	e8 90 9a ff ff       	call   c0100c9f <__panic>

    struct mm_struct *mm = check_mm_struct;
c010720f:	a1 0c 61 12 c0       	mov    0xc012610c,%eax
c0107214:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107217:	8b 15 e0 29 12 c0    	mov    0xc01229e0,%edx
c010721d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107220:	89 50 0c             	mov    %edx,0xc(%eax)
c0107223:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107226:	8b 40 0c             	mov    0xc(%eax),%eax
c0107229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010722c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010722f:	8b 00                	mov    (%eax),%eax
c0107231:	85 c0                	test   %eax,%eax
c0107233:	74 19                	je     c010724e <check_pgfault+0x79>
c0107235:	68 df 9e 10 c0       	push   $0xc0109edf
c010723a:	68 a3 9c 10 c0       	push   $0xc0109ca3
c010723f:	68 f8 00 00 00       	push   $0xf8
c0107244:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0107249:	e8 51 9a ff ff       	call   c0100c9f <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c010724e:	83 ec 04             	sub    $0x4,%esp
c0107251:	6a 02                	push   $0x2
c0107253:	68 00 00 40 00       	push   $0x400000
c0107258:	6a 00                	push   $0x0
c010725a:	e8 ef f7 ff ff       	call   c0106a4e <vma_create>
c010725f:	83 c4 10             	add    $0x10,%esp
c0107262:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107265:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107269:	75 19                	jne    c0107284 <check_pgfault+0xaf>
c010726b:	68 6e 9d 10 c0       	push   $0xc0109d6e
c0107270:	68 a3 9c 10 c0       	push   $0xc0109ca3
c0107275:	68 fb 00 00 00       	push   $0xfb
c010727a:	68 b8 9c 10 c0       	push   $0xc0109cb8
c010727f:	e8 1b 9a ff ff       	call   c0100c9f <__panic>

    insert_vma_struct(mm, vma);
c0107284:	83 ec 08             	sub    $0x8,%esp
c0107287:	ff 75 e0             	push   -0x20(%ebp)
c010728a:	ff 75 e8             	push   -0x18(%ebp)
c010728d:	e8 24 f9 ff ff       	call   c0106bb6 <insert_vma_struct>
c0107292:	83 c4 10             	add    $0x10,%esp

    uintptr_t addr = 0x100;
c0107295:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010729c:	83 ec 08             	sub    $0x8,%esp
c010729f:	ff 75 dc             	push   -0x24(%ebp)
c01072a2:	ff 75 e8             	push   -0x18(%ebp)
c01072a5:	e8 e0 f7 ff ff       	call   c0106a8a <find_vma>
c01072aa:	83 c4 10             	add    $0x10,%esp
c01072ad:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01072b0:	74 19                	je     c01072cb <check_pgfault+0xf6>
c01072b2:	68 ed 9e 10 c0       	push   $0xc0109eed
c01072b7:	68 a3 9c 10 c0       	push   $0xc0109ca3
c01072bc:	68 00 01 00 00       	push   $0x100
c01072c1:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01072c6:	e8 d4 99 ff ff       	call   c0100c9f <__panic>

    int i, sum = 0;
c01072cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c01072d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01072d9:	eb 17                	jmp    c01072f2 <check_pgfault+0x11d>
        *(char *)(addr + i) = i;
c01072db:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01072de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072e1:	01 d0                	add    %edx,%eax
c01072e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01072e6:	88 10                	mov    %dl,(%eax)
        sum += i;
c01072e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072eb:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c01072ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01072f2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01072f6:	7e e3                	jle    c01072db <check_pgfault+0x106>
    }
    for (i = 0; i < 100; i ++) {
c01072f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01072ff:	eb 15                	jmp    c0107316 <check_pgfault+0x141>
        sum -= *(char *)(addr + i);
c0107301:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107304:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107307:	01 d0                	add    %edx,%eax
c0107309:	0f b6 00             	movzbl (%eax),%eax
c010730c:	0f be c0             	movsbl %al,%eax
c010730f:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107312:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107316:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010731a:	7e e5                	jle    c0107301 <check_pgfault+0x12c>
    }
    assert(sum == 0);
c010731c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107320:	74 19                	je     c010733b <check_pgfault+0x166>
c0107322:	68 07 9f 10 c0       	push   $0xc0109f07
c0107327:	68 a3 9c 10 c0       	push   $0xc0109ca3
c010732c:	68 0a 01 00 00       	push   $0x10a
c0107331:	68 b8 9c 10 c0       	push   $0xc0109cb8
c0107336:	e8 64 99 ff ff       	call   c0100c9f <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010733b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010733e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107341:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107349:	83 ec 08             	sub    $0x8,%esp
c010734c:	50                   	push   %eax
c010734d:	ff 75 e4             	push   -0x1c(%ebp)
c0107350:	e8 39 d9 ff ff       	call   c0104c8e <page_remove>
c0107355:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(pgdir[0]));
c0107358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010735b:	8b 00                	mov    (%eax),%eax
c010735d:	83 ec 0c             	sub    $0xc,%esp
c0107360:	50                   	push   %eax
c0107361:	e8 4f f6 ff ff       	call   c01069b5 <pde2page>
c0107366:	83 c4 10             	add    $0x10,%esp
c0107369:	83 ec 08             	sub    $0x8,%esp
c010736c:	6a 01                	push   $0x1
c010736e:	50                   	push   %eax
c010736f:	e8 64 d1 ff ff       	call   c01044d8 <free_pages>
c0107374:	83 c4 10             	add    $0x10,%esp
    pgdir[0] = 0;
c0107377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010737a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107380:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107383:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010738a:	83 ec 0c             	sub    $0xc,%esp
c010738d:	ff 75 e8             	push   -0x18(%ebp)
c0107390:	e8 47 f9 ff ff       	call   c0106cdc <mm_destroy>
c0107395:	83 c4 10             	add    $0x10,%esp
    check_mm_struct = NULL;
c0107398:	c7 05 0c 61 12 c0 00 	movl   $0x0,0xc012610c
c010739f:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01073a2:	e8 66 d1 ff ff       	call   c010450d <nr_free_pages>
c01073a7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01073aa:	74 19                	je     c01073c5 <check_pgfault+0x1f0>
c01073ac:	68 24 9d 10 c0       	push   $0xc0109d24
c01073b1:	68 a3 9c 10 c0       	push   $0xc0109ca3
c01073b6:	68 14 01 00 00       	push   $0x114
c01073bb:	68 b8 9c 10 c0       	push   $0xc0109cb8
c01073c0:	e8 da 98 ff ff       	call   c0100c9f <__panic>

    cprintf("check_pgfault() succeeded!\n");
c01073c5:	83 ec 0c             	sub    $0xc,%esp
c01073c8:	68 10 9f 10 c0       	push   $0xc0109f10
c01073cd:	e8 6e 8f ff ff       	call   c0100340 <cprintf>
c01073d2:	83 c4 10             	add    $0x10,%esp
}
c01073d5:	90                   	nop
c01073d6:	c9                   	leave  
c01073d7:	c3                   	ret    

c01073d8 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c01073d8:	55                   	push   %ebp
c01073d9:	89 e5                	mov    %esp,%ebp
c01073db:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_INVAL;
c01073de:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c01073e5:	ff 75 10             	push   0x10(%ebp)
c01073e8:	ff 75 08             	push   0x8(%ebp)
c01073eb:	e8 9a f6 ff ff       	call   c0106a8a <find_vma>
c01073f0:	83 c4 08             	add    $0x8,%esp
c01073f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01073f6:	a1 10 61 12 c0       	mov    0xc0126110,%eax
c01073fb:	83 c0 01             	add    $0x1,%eax
c01073fe:	a3 10 61 12 c0       	mov    %eax,0xc0126110
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107407:	74 0b                	je     c0107414 <do_pgfault+0x3c>
c0107409:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010740c:	8b 40 04             	mov    0x4(%eax),%eax
c010740f:	39 45 10             	cmp    %eax,0x10(%ebp)
c0107412:	73 18                	jae    c010742c <do_pgfault+0x54>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107414:	83 ec 08             	sub    $0x8,%esp
c0107417:	ff 75 10             	push   0x10(%ebp)
c010741a:	68 2c 9f 10 c0       	push   $0xc0109f2c
c010741f:	e8 1c 8f ff ff       	call   c0100340 <cprintf>
c0107424:	83 c4 10             	add    $0x10,%esp
        goto failed;
c0107427:	e9 aa 01 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
    }
    //check the error_code
    switch (error_code & 3) {
c010742c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010742f:	83 e0 03             	and    $0x3,%eax
c0107432:	85 c0                	test   %eax,%eax
c0107434:	74 3c                	je     c0107472 <do_pgfault+0x9a>
c0107436:	83 f8 01             	cmp    $0x1,%eax
c0107439:	74 22                	je     c010745d <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c010743b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010743e:	8b 40 0c             	mov    0xc(%eax),%eax
c0107441:	83 e0 02             	and    $0x2,%eax
c0107444:	85 c0                	test   %eax,%eax
c0107446:	75 4c                	jne    c0107494 <do_pgfault+0xbc>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107448:	83 ec 0c             	sub    $0xc,%esp
c010744b:	68 5c 9f 10 c0       	push   $0xc0109f5c
c0107450:	e8 eb 8e ff ff       	call   c0100340 <cprintf>
c0107455:	83 c4 10             	add    $0x10,%esp
            goto failed;
c0107458:	e9 79 01 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c010745d:	83 ec 0c             	sub    $0xc,%esp
c0107460:	68 bc 9f 10 c0       	push   $0xc0109fbc
c0107465:	e8 d6 8e ff ff       	call   c0100340 <cprintf>
c010746a:	83 c4 10             	add    $0x10,%esp
        goto failed;
c010746d:	e9 64 01 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107472:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107475:	8b 40 0c             	mov    0xc(%eax),%eax
c0107478:	83 e0 05             	and    $0x5,%eax
c010747b:	85 c0                	test   %eax,%eax
c010747d:	75 16                	jne    c0107495 <do_pgfault+0xbd>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c010747f:	83 ec 0c             	sub    $0xc,%esp
c0107482:	68 f4 9f 10 c0       	push   $0xc0109ff4
c0107487:	e8 b4 8e ff ff       	call   c0100340 <cprintf>
c010748c:	83 c4 10             	add    $0x10,%esp
            goto failed;
c010748f:	e9 42 01 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
        break;
c0107494:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107495:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010749c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010749f:	8b 40 0c             	mov    0xc(%eax),%eax
c01074a2:	83 e0 02             	and    $0x2,%eax
c01074a5:	85 c0                	test   %eax,%eax
c01074a7:	74 04                	je     c01074ad <do_pgfault+0xd5>
        perm |= PTE_W;
c01074a9:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01074ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01074b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01074b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01074bb:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c01074be:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c01074c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        }
   }
#endif
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c01074cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01074cf:	8b 40 0c             	mov    0xc(%eax),%eax
c01074d2:	83 ec 04             	sub    $0x4,%esp
c01074d5:	6a 01                	push   $0x1
c01074d7:	ff 75 10             	push   0x10(%ebp)
c01074da:	50                   	push   %eax
c01074db:	e8 d6 d5 ff ff       	call   c0104ab6 <get_pte>
c01074e0:	83 c4 10             	add    $0x10,%esp
c01074e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01074e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01074ea:	75 15                	jne    c0107501 <do_pgfault+0x129>
        cprintf("get_pte in do_pgfault failed\n");
c01074ec:	83 ec 0c             	sub    $0xc,%esp
c01074ef:	68 57 a0 10 c0       	push   $0xc010a057
c01074f4:	e8 47 8e ff ff       	call   c0100340 <cprintf>
c01074f9:	83 c4 10             	add    $0x10,%esp
        goto failed;
c01074fc:	e9 d5 00 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c0107501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107504:	8b 00                	mov    (%eax),%eax
c0107506:	85 c0                	test   %eax,%eax
c0107508:	75 35                	jne    c010753f <do_pgfault+0x167>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c010750a:	8b 45 08             	mov    0x8(%ebp),%eax
c010750d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107510:	83 ec 04             	sub    $0x4,%esp
c0107513:	ff 75 f0             	push   -0x10(%ebp)
c0107516:	ff 75 10             	push   0x10(%ebp)
c0107519:	50                   	push   %eax
c010751a:	e8 b2 d8 ff ff       	call   c0104dd1 <pgdir_alloc_page>
c010751f:	83 c4 10             	add    $0x10,%esp
c0107522:	85 c0                	test   %eax,%eax
c0107524:	0f 85 a5 00 00 00    	jne    c01075cf <do_pgfault+0x1f7>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c010752a:	83 ec 0c             	sub    $0xc,%esp
c010752d:	68 78 a0 10 c0       	push   $0xc010a078
c0107532:	e8 09 8e ff ff       	call   c0100340 <cprintf>
c0107537:	83 c4 10             	add    $0x10,%esp
            goto failed;
c010753a:	e9 97 00 00 00       	jmp    c01075d6 <do_pgfault+0x1fe>
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
c010753f:	a1 44 60 12 c0       	mov    0xc0126044,%eax
c0107544:	85 c0                	test   %eax,%eax
c0107546:	74 6f                	je     c01075b7 <do_pgfault+0x1df>
            struct Page *page=NULL;
c0107548:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c010754f:	83 ec 04             	sub    $0x4,%esp
c0107552:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107555:	50                   	push   %eax
c0107556:	ff 75 10             	push   0x10(%ebp)
c0107559:	ff 75 08             	push   0x8(%ebp)
c010755c:	e8 be e7 ff ff       	call   c0105d1f <swap_in>
c0107561:	83 c4 10             	add    $0x10,%esp
c0107564:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010756b:	74 12                	je     c010757f <do_pgfault+0x1a7>
                cprintf("swap_in in do_pgfault failed\n");
c010756d:	83 ec 0c             	sub    $0xc,%esp
c0107570:	68 9f a0 10 c0       	push   $0xc010a09f
c0107575:	e8 c6 8d ff ff       	call   c0100340 <cprintf>
c010757a:	83 c4 10             	add    $0x10,%esp
c010757d:	eb 57                	jmp    c01075d6 <do_pgfault+0x1fe>
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
c010757f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107582:	8b 45 08             	mov    0x8(%ebp),%eax
c0107585:	8b 40 0c             	mov    0xc(%eax),%eax
c0107588:	ff 75 f0             	push   -0x10(%ebp)
c010758b:	ff 75 10             	push   0x10(%ebp)
c010758e:	52                   	push   %edx
c010758f:	50                   	push   %eax
c0107590:	e8 32 d7 ff ff       	call   c0104cc7 <page_insert>
c0107595:	83 c4 10             	add    $0x10,%esp
            swap_map_swappable(mm, addr, page, 1);
c0107598:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010759b:	6a 01                	push   $0x1
c010759d:	50                   	push   %eax
c010759e:	ff 75 10             	push   0x10(%ebp)
c01075a1:	ff 75 08             	push   0x8(%ebp)
c01075a4:	e8 e6 e5 ff ff       	call   c0105b8f <swap_map_swappable>
c01075a9:	83 c4 10             	add    $0x10,%esp
            page->pra_vaddr = addr;
c01075ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01075af:	8b 55 10             	mov    0x10(%ebp),%edx
c01075b2:	89 50 1c             	mov    %edx,0x1c(%eax)
c01075b5:	eb 18                	jmp    c01075cf <do_pgfault+0x1f7>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01075b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075ba:	8b 00                	mov    (%eax),%eax
c01075bc:	83 ec 08             	sub    $0x8,%esp
c01075bf:	50                   	push   %eax
c01075c0:	68 c0 a0 10 c0       	push   $0xc010a0c0
c01075c5:	e8 76 8d ff ff       	call   c0100340 <cprintf>
c01075ca:	83 c4 10             	add    $0x10,%esp
            goto failed;
c01075cd:	eb 07                	jmp    c01075d6 <do_pgfault+0x1fe>
        }
   }
   ret = 0;
c01075cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01075d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01075d9:	c9                   	leave  
c01075da:	c3                   	ret    

c01075db <page2ppn>:
page2ppn(struct Page *page) {
c01075db:	55                   	push   %ebp
c01075dc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01075de:	8b 15 a0 5f 12 c0    	mov    0xc0125fa0,%edx
c01075e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01075e7:	29 d0                	sub    %edx,%eax
c01075e9:	c1 f8 05             	sar    $0x5,%eax
}
c01075ec:	5d                   	pop    %ebp
c01075ed:	c3                   	ret    

c01075ee <page2pa>:
page2pa(struct Page *page) {
c01075ee:	55                   	push   %ebp
c01075ef:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01075f1:	ff 75 08             	push   0x8(%ebp)
c01075f4:	e8 e2 ff ff ff       	call   c01075db <page2ppn>
c01075f9:	83 c4 04             	add    $0x4,%esp
c01075fc:	c1 e0 0c             	shl    $0xc,%eax
}
c01075ff:	c9                   	leave  
c0107600:	c3                   	ret    

c0107601 <page2kva>:
page2kva(struct Page *page) {
c0107601:	55                   	push   %ebp
c0107602:	89 e5                	mov    %esp,%ebp
c0107604:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0107607:	ff 75 08             	push   0x8(%ebp)
c010760a:	e8 df ff ff ff       	call   c01075ee <page2pa>
c010760f:	83 c4 04             	add    $0x4,%esp
c0107612:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107615:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107618:	c1 e8 0c             	shr    $0xc,%eax
c010761b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010761e:	a1 a4 5f 12 c0       	mov    0xc0125fa4,%eax
c0107623:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107626:	72 14                	jb     c010763c <page2kva+0x3b>
c0107628:	ff 75 f4             	push   -0xc(%ebp)
c010762b:	68 e8 a0 10 c0       	push   $0xc010a0e8
c0107630:	6a 62                	push   $0x62
c0107632:	68 0b a1 10 c0       	push   $0xc010a10b
c0107637:	e8 63 96 ff ff       	call   c0100c9f <__panic>
c010763c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010763f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107644:	c9                   	leave  
c0107645:	c3                   	ret    

c0107646 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107646:	55                   	push   %ebp
c0107647:	89 e5                	mov    %esp,%ebp
c0107649:	83 ec 08             	sub    $0x8,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010764c:	83 ec 0c             	sub    $0xc,%esp
c010764f:	6a 01                	push   $0x1
c0107651:	e8 8e a3 ff ff       	call   c01019e4 <ide_device_valid>
c0107656:	83 c4 10             	add    $0x10,%esp
c0107659:	85 c0                	test   %eax,%eax
c010765b:	75 14                	jne    c0107671 <swapfs_init+0x2b>
        panic("swap fs isn't available.\n");
c010765d:	83 ec 04             	sub    $0x4,%esp
c0107660:	68 19 a1 10 c0       	push   $0xc010a119
c0107665:	6a 0d                	push   $0xd
c0107667:	68 33 a1 10 c0       	push   $0xc010a133
c010766c:	e8 2e 96 ff ff       	call   c0100c9f <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107671:	83 ec 0c             	sub    $0xc,%esp
c0107674:	6a 01                	push   $0x1
c0107676:	e8 9e a3 ff ff       	call   c0101a19 <ide_device_size>
c010767b:	83 c4 10             	add    $0x10,%esp
c010767e:	c1 e8 03             	shr    $0x3,%eax
c0107681:	a3 40 60 12 c0       	mov    %eax,0xc0126040
}
c0107686:	90                   	nop
c0107687:	c9                   	leave  
c0107688:	c3                   	ret    

c0107689 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107689:	55                   	push   %ebp
c010768a:	89 e5                	mov    %esp,%ebp
c010768c:	83 ec 18             	sub    $0x18,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010768f:	83 ec 0c             	sub    $0xc,%esp
c0107692:	ff 75 0c             	push   0xc(%ebp)
c0107695:	e8 67 ff ff ff       	call   c0107601 <page2kva>
c010769a:	83 c4 10             	add    $0x10,%esp
c010769d:	8b 55 08             	mov    0x8(%ebp),%edx
c01076a0:	c1 ea 08             	shr    $0x8,%edx
c01076a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01076a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076aa:	74 0b                	je     c01076b7 <swapfs_read+0x2e>
c01076ac:	8b 15 40 60 12 c0    	mov    0xc0126040,%edx
c01076b2:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01076b5:	72 14                	jb     c01076cb <swapfs_read+0x42>
c01076b7:	ff 75 08             	push   0x8(%ebp)
c01076ba:	68 44 a1 10 c0       	push   $0xc010a144
c01076bf:	6a 14                	push   $0x14
c01076c1:	68 33 a1 10 c0       	push   $0xc010a133
c01076c6:	e8 d4 95 ff ff       	call   c0100c9f <__panic>
c01076cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076ce:	c1 e2 03             	shl    $0x3,%edx
c01076d1:	6a 08                	push   $0x8
c01076d3:	50                   	push   %eax
c01076d4:	52                   	push   %edx
c01076d5:	6a 01                	push   $0x1
c01076d7:	e8 72 a3 ff ff       	call   c0101a4e <ide_read_secs>
c01076dc:	83 c4 10             	add    $0x10,%esp
}
c01076df:	c9                   	leave  
c01076e0:	c3                   	ret    

c01076e1 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01076e1:	55                   	push   %ebp
c01076e2:	89 e5                	mov    %esp,%ebp
c01076e4:	83 ec 18             	sub    $0x18,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01076e7:	83 ec 0c             	sub    $0xc,%esp
c01076ea:	ff 75 0c             	push   0xc(%ebp)
c01076ed:	e8 0f ff ff ff       	call   c0107601 <page2kva>
c01076f2:	83 c4 10             	add    $0x10,%esp
c01076f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01076f8:	c1 ea 08             	shr    $0x8,%edx
c01076fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01076fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107702:	74 0b                	je     c010770f <swapfs_write+0x2e>
c0107704:	8b 15 40 60 12 c0    	mov    0xc0126040,%edx
c010770a:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010770d:	72 14                	jb     c0107723 <swapfs_write+0x42>
c010770f:	ff 75 08             	push   0x8(%ebp)
c0107712:	68 44 a1 10 c0       	push   $0xc010a144
c0107717:	6a 19                	push   $0x19
c0107719:	68 33 a1 10 c0       	push   $0xc010a133
c010771e:	e8 7c 95 ff ff       	call   c0100c9f <__panic>
c0107723:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107726:	c1 e2 03             	shl    $0x3,%edx
c0107729:	6a 08                	push   $0x8
c010772b:	50                   	push   %eax
c010772c:	52                   	push   %edx
c010772d:	6a 01                	push   $0x1
c010772f:	e8 41 a5 ff ff       	call   c0101c75 <ide_write_secs>
c0107734:	83 c4 10             	add    $0x10,%esp
}
c0107737:	c9                   	leave  
c0107738:	c3                   	ret    

c0107739 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107739:	55                   	push   %ebp
c010773a:	89 e5                	mov    %esp,%ebp
c010773c:	83 ec 38             	sub    $0x38,%esp
c010773f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107742:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107745:	8b 45 14             	mov    0x14(%ebp),%eax
c0107748:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010774b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010774e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107751:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107754:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107757:	8b 45 18             	mov    0x18(%ebp),%eax
c010775a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010775d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107760:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107763:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107766:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107769:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010776c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010776f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107773:	74 1c                	je     c0107791 <printnum+0x58>
c0107775:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107778:	ba 00 00 00 00       	mov    $0x0,%edx
c010777d:	f7 75 e4             	divl   -0x1c(%ebp)
c0107780:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107783:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107786:	ba 00 00 00 00       	mov    $0x0,%edx
c010778b:	f7 75 e4             	divl   -0x1c(%ebp)
c010778e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107791:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107794:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107797:	f7 75 e4             	divl   -0x1c(%ebp)
c010779a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010779d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01077a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01077a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01077a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01077a9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01077ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077af:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01077b2:	8b 45 18             	mov    0x18(%ebp),%eax
c01077b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01077ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01077bd:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01077c0:	19 d1                	sbb    %edx,%ecx
c01077c2:	72 37                	jb     c01077fb <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
c01077c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01077c7:	83 e8 01             	sub    $0x1,%eax
c01077ca:	83 ec 04             	sub    $0x4,%esp
c01077cd:	ff 75 20             	push   0x20(%ebp)
c01077d0:	50                   	push   %eax
c01077d1:	ff 75 18             	push   0x18(%ebp)
c01077d4:	ff 75 ec             	push   -0x14(%ebp)
c01077d7:	ff 75 e8             	push   -0x18(%ebp)
c01077da:	ff 75 0c             	push   0xc(%ebp)
c01077dd:	ff 75 08             	push   0x8(%ebp)
c01077e0:	e8 54 ff ff ff       	call   c0107739 <printnum>
c01077e5:	83 c4 20             	add    $0x20,%esp
c01077e8:	eb 1b                	jmp    c0107805 <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01077ea:	83 ec 08             	sub    $0x8,%esp
c01077ed:	ff 75 0c             	push   0xc(%ebp)
c01077f0:	ff 75 20             	push   0x20(%ebp)
c01077f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01077f6:	ff d0                	call   *%eax
c01077f8:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c01077fb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01077ff:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107803:	7f e5                	jg     c01077ea <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107805:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107808:	05 e4 a1 10 c0       	add    $0xc010a1e4,%eax
c010780d:	0f b6 00             	movzbl (%eax),%eax
c0107810:	0f be c0             	movsbl %al,%eax
c0107813:	83 ec 08             	sub    $0x8,%esp
c0107816:	ff 75 0c             	push   0xc(%ebp)
c0107819:	50                   	push   %eax
c010781a:	8b 45 08             	mov    0x8(%ebp),%eax
c010781d:	ff d0                	call   *%eax
c010781f:	83 c4 10             	add    $0x10,%esp
}
c0107822:	90                   	nop
c0107823:	c9                   	leave  
c0107824:	c3                   	ret    

c0107825 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107825:	55                   	push   %ebp
c0107826:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107828:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010782c:	7e 14                	jle    c0107842 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010782e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107831:	8b 00                	mov    (%eax),%eax
c0107833:	8d 48 08             	lea    0x8(%eax),%ecx
c0107836:	8b 55 08             	mov    0x8(%ebp),%edx
c0107839:	89 0a                	mov    %ecx,(%edx)
c010783b:	8b 50 04             	mov    0x4(%eax),%edx
c010783e:	8b 00                	mov    (%eax),%eax
c0107840:	eb 30                	jmp    c0107872 <getuint+0x4d>
    }
    else if (lflag) {
c0107842:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107846:	74 16                	je     c010785e <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0107848:	8b 45 08             	mov    0x8(%ebp),%eax
c010784b:	8b 00                	mov    (%eax),%eax
c010784d:	8d 48 04             	lea    0x4(%eax),%ecx
c0107850:	8b 55 08             	mov    0x8(%ebp),%edx
c0107853:	89 0a                	mov    %ecx,(%edx)
c0107855:	8b 00                	mov    (%eax),%eax
c0107857:	ba 00 00 00 00       	mov    $0x0,%edx
c010785c:	eb 14                	jmp    c0107872 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010785e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107861:	8b 00                	mov    (%eax),%eax
c0107863:	8d 48 04             	lea    0x4(%eax),%ecx
c0107866:	8b 55 08             	mov    0x8(%ebp),%edx
c0107869:	89 0a                	mov    %ecx,(%edx)
c010786b:	8b 00                	mov    (%eax),%eax
c010786d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107872:	5d                   	pop    %ebp
c0107873:	c3                   	ret    

c0107874 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107874:	55                   	push   %ebp
c0107875:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107877:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010787b:	7e 14                	jle    c0107891 <getint+0x1d>
        return va_arg(*ap, long long);
c010787d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107880:	8b 00                	mov    (%eax),%eax
c0107882:	8d 48 08             	lea    0x8(%eax),%ecx
c0107885:	8b 55 08             	mov    0x8(%ebp),%edx
c0107888:	89 0a                	mov    %ecx,(%edx)
c010788a:	8b 50 04             	mov    0x4(%eax),%edx
c010788d:	8b 00                	mov    (%eax),%eax
c010788f:	eb 28                	jmp    c01078b9 <getint+0x45>
    }
    else if (lflag) {
c0107891:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107895:	74 12                	je     c01078a9 <getint+0x35>
        return va_arg(*ap, long);
c0107897:	8b 45 08             	mov    0x8(%ebp),%eax
c010789a:	8b 00                	mov    (%eax),%eax
c010789c:	8d 48 04             	lea    0x4(%eax),%ecx
c010789f:	8b 55 08             	mov    0x8(%ebp),%edx
c01078a2:	89 0a                	mov    %ecx,(%edx)
c01078a4:	8b 00                	mov    (%eax),%eax
c01078a6:	99                   	cltd   
c01078a7:	eb 10                	jmp    c01078b9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01078a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01078ac:	8b 00                	mov    (%eax),%eax
c01078ae:	8d 48 04             	lea    0x4(%eax),%ecx
c01078b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01078b4:	89 0a                	mov    %ecx,(%edx)
c01078b6:	8b 00                	mov    (%eax),%eax
c01078b8:	99                   	cltd   
    }
}
c01078b9:	5d                   	pop    %ebp
c01078ba:	c3                   	ret    

c01078bb <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01078bb:	55                   	push   %ebp
c01078bc:	89 e5                	mov    %esp,%ebp
c01078be:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01078c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01078c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ca:	50                   	push   %eax
c01078cb:	ff 75 10             	push   0x10(%ebp)
c01078ce:	ff 75 0c             	push   0xc(%ebp)
c01078d1:	ff 75 08             	push   0x8(%ebp)
c01078d4:	e8 06 00 00 00       	call   c01078df <vprintfmt>
c01078d9:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01078dc:	90                   	nop
c01078dd:	c9                   	leave  
c01078de:	c3                   	ret    

c01078df <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01078df:	55                   	push   %ebp
c01078e0:	89 e5                	mov    %esp,%ebp
c01078e2:	56                   	push   %esi
c01078e3:	53                   	push   %ebx
c01078e4:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01078e7:	eb 17                	jmp    c0107900 <vprintfmt+0x21>
            if (ch == '\0') {
c01078e9:	85 db                	test   %ebx,%ebx
c01078eb:	0f 84 8e 03 00 00    	je     c0107c7f <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c01078f1:	83 ec 08             	sub    $0x8,%esp
c01078f4:	ff 75 0c             	push   0xc(%ebp)
c01078f7:	53                   	push   %ebx
c01078f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01078fb:	ff d0                	call   *%eax
c01078fd:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0107900:	8b 45 10             	mov    0x10(%ebp),%eax
c0107903:	8d 50 01             	lea    0x1(%eax),%edx
c0107906:	89 55 10             	mov    %edx,0x10(%ebp)
c0107909:	0f b6 00             	movzbl (%eax),%eax
c010790c:	0f b6 d8             	movzbl %al,%ebx
c010790f:	83 fb 25             	cmp    $0x25,%ebx
c0107912:	75 d5                	jne    c01078e9 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0107914:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0107918:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010791f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107922:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0107925:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010792c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010792f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0107932:	8b 45 10             	mov    0x10(%ebp),%eax
c0107935:	8d 50 01             	lea    0x1(%eax),%edx
c0107938:	89 55 10             	mov    %edx,0x10(%ebp)
c010793b:	0f b6 00             	movzbl (%eax),%eax
c010793e:	0f b6 d8             	movzbl %al,%ebx
c0107941:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0107944:	83 f8 55             	cmp    $0x55,%eax
c0107947:	0f 87 05 03 00 00    	ja     c0107c52 <vprintfmt+0x373>
c010794d:	8b 04 85 08 a2 10 c0 	mov    -0x3fef5df8(,%eax,4),%eax
c0107954:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0107956:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010795a:	eb d6                	jmp    c0107932 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010795c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0107960:	eb d0                	jmp    c0107932 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0107962:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0107969:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010796c:	89 d0                	mov    %edx,%eax
c010796e:	c1 e0 02             	shl    $0x2,%eax
c0107971:	01 d0                	add    %edx,%eax
c0107973:	01 c0                	add    %eax,%eax
c0107975:	01 d8                	add    %ebx,%eax
c0107977:	83 e8 30             	sub    $0x30,%eax
c010797a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010797d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107980:	0f b6 00             	movzbl (%eax),%eax
c0107983:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0107986:	83 fb 2f             	cmp    $0x2f,%ebx
c0107989:	7e 39                	jle    c01079c4 <vprintfmt+0xe5>
c010798b:	83 fb 39             	cmp    $0x39,%ebx
c010798e:	7f 34                	jg     c01079c4 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
c0107990:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0107994:	eb d3                	jmp    c0107969 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0107996:	8b 45 14             	mov    0x14(%ebp),%eax
c0107999:	8d 50 04             	lea    0x4(%eax),%edx
c010799c:	89 55 14             	mov    %edx,0x14(%ebp)
c010799f:	8b 00                	mov    (%eax),%eax
c01079a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01079a4:	eb 1f                	jmp    c01079c5 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01079a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01079aa:	79 86                	jns    c0107932 <vprintfmt+0x53>
                width = 0;
c01079ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01079b3:	e9 7a ff ff ff       	jmp    c0107932 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01079b8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01079bf:	e9 6e ff ff ff       	jmp    c0107932 <vprintfmt+0x53>
            goto process_precision;
c01079c4:	90                   	nop

        process_precision:
            if (width < 0)
c01079c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01079c9:	0f 89 63 ff ff ff    	jns    c0107932 <vprintfmt+0x53>
                width = precision, precision = -1;
c01079cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01079d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01079d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01079dc:	e9 51 ff ff ff       	jmp    c0107932 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01079e1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01079e5:	e9 48 ff ff ff       	jmp    c0107932 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01079ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01079ed:	8d 50 04             	lea    0x4(%eax),%edx
c01079f0:	89 55 14             	mov    %edx,0x14(%ebp)
c01079f3:	8b 00                	mov    (%eax),%eax
c01079f5:	83 ec 08             	sub    $0x8,%esp
c01079f8:	ff 75 0c             	push   0xc(%ebp)
c01079fb:	50                   	push   %eax
c01079fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01079ff:	ff d0                	call   *%eax
c0107a01:	83 c4 10             	add    $0x10,%esp
            break;
c0107a04:	e9 71 02 00 00       	jmp    c0107c7a <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0107a09:	8b 45 14             	mov    0x14(%ebp),%eax
c0107a0c:	8d 50 04             	lea    0x4(%eax),%edx
c0107a0f:	89 55 14             	mov    %edx,0x14(%ebp)
c0107a12:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0107a14:	85 db                	test   %ebx,%ebx
c0107a16:	79 02                	jns    c0107a1a <vprintfmt+0x13b>
                err = -err;
c0107a18:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0107a1a:	83 fb 06             	cmp    $0x6,%ebx
c0107a1d:	7f 0b                	jg     c0107a2a <vprintfmt+0x14b>
c0107a1f:	8b 34 9d c8 a1 10 c0 	mov    -0x3fef5e38(,%ebx,4),%esi
c0107a26:	85 f6                	test   %esi,%esi
c0107a28:	75 19                	jne    c0107a43 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0107a2a:	53                   	push   %ebx
c0107a2b:	68 f5 a1 10 c0       	push   $0xc010a1f5
c0107a30:	ff 75 0c             	push   0xc(%ebp)
c0107a33:	ff 75 08             	push   0x8(%ebp)
c0107a36:	e8 80 fe ff ff       	call   c01078bb <printfmt>
c0107a3b:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0107a3e:	e9 37 02 00 00       	jmp    c0107c7a <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
c0107a43:	56                   	push   %esi
c0107a44:	68 fe a1 10 c0       	push   $0xc010a1fe
c0107a49:	ff 75 0c             	push   0xc(%ebp)
c0107a4c:	ff 75 08             	push   0x8(%ebp)
c0107a4f:	e8 67 fe ff ff       	call   c01078bb <printfmt>
c0107a54:	83 c4 10             	add    $0x10,%esp
            break;
c0107a57:	e9 1e 02 00 00       	jmp    c0107c7a <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0107a5c:	8b 45 14             	mov    0x14(%ebp),%eax
c0107a5f:	8d 50 04             	lea    0x4(%eax),%edx
c0107a62:	89 55 14             	mov    %edx,0x14(%ebp)
c0107a65:	8b 30                	mov    (%eax),%esi
c0107a67:	85 f6                	test   %esi,%esi
c0107a69:	75 05                	jne    c0107a70 <vprintfmt+0x191>
                p = "(null)";
c0107a6b:	be 01 a2 10 c0       	mov    $0xc010a201,%esi
            }
            if (width > 0 && padc != '-') {
c0107a70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107a74:	7e 76                	jle    c0107aec <vprintfmt+0x20d>
c0107a76:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0107a7a:	74 70                	je     c0107aec <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a7f:	83 ec 08             	sub    $0x8,%esp
c0107a82:	50                   	push   %eax
c0107a83:	56                   	push   %esi
c0107a84:	e8 b7 03 00 00       	call   c0107e40 <strnlen>
c0107a89:	83 c4 10             	add    $0x10,%esp
c0107a8c:	89 c2                	mov    %eax,%edx
c0107a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a91:	29 d0                	sub    %edx,%eax
c0107a93:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107a96:	eb 17                	jmp    c0107aaf <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0107a98:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0107a9c:	83 ec 08             	sub    $0x8,%esp
c0107a9f:	ff 75 0c             	push   0xc(%ebp)
c0107aa2:	50                   	push   %eax
c0107aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107aa6:	ff d0                	call   *%eax
c0107aa8:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107aab:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107aaf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107ab3:	7f e3                	jg     c0107a98 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0107ab5:	eb 35                	jmp    c0107aec <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0107ab7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107abb:	74 1c                	je     c0107ad9 <vprintfmt+0x1fa>
c0107abd:	83 fb 1f             	cmp    $0x1f,%ebx
c0107ac0:	7e 05                	jle    c0107ac7 <vprintfmt+0x1e8>
c0107ac2:	83 fb 7e             	cmp    $0x7e,%ebx
c0107ac5:	7e 12                	jle    c0107ad9 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0107ac7:	83 ec 08             	sub    $0x8,%esp
c0107aca:	ff 75 0c             	push   0xc(%ebp)
c0107acd:	6a 3f                	push   $0x3f
c0107acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ad2:	ff d0                	call   *%eax
c0107ad4:	83 c4 10             	add    $0x10,%esp
c0107ad7:	eb 0f                	jmp    c0107ae8 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0107ad9:	83 ec 08             	sub    $0x8,%esp
c0107adc:	ff 75 0c             	push   0xc(%ebp)
c0107adf:	53                   	push   %ebx
c0107ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ae3:	ff d0                	call   *%eax
c0107ae5:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0107ae8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107aec:	89 f0                	mov    %esi,%eax
c0107aee:	8d 70 01             	lea    0x1(%eax),%esi
c0107af1:	0f b6 00             	movzbl (%eax),%eax
c0107af4:	0f be d8             	movsbl %al,%ebx
c0107af7:	85 db                	test   %ebx,%ebx
c0107af9:	74 26                	je     c0107b21 <vprintfmt+0x242>
c0107afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107aff:	78 b6                	js     c0107ab7 <vprintfmt+0x1d8>
c0107b01:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0107b05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107b09:	79 ac                	jns    c0107ab7 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
c0107b0b:	eb 14                	jmp    c0107b21 <vprintfmt+0x242>
                putch(' ', putdat);
c0107b0d:	83 ec 08             	sub    $0x8,%esp
c0107b10:	ff 75 0c             	push   0xc(%ebp)
c0107b13:	6a 20                	push   $0x20
c0107b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b18:	ff d0                	call   *%eax
c0107b1a:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0107b1d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107b21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107b25:	7f e6                	jg     c0107b0d <vprintfmt+0x22e>
            }
            break;
c0107b27:	e9 4e 01 00 00       	jmp    c0107c7a <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0107b2c:	83 ec 08             	sub    $0x8,%esp
c0107b2f:	ff 75 e0             	push   -0x20(%ebp)
c0107b32:	8d 45 14             	lea    0x14(%ebp),%eax
c0107b35:	50                   	push   %eax
c0107b36:	e8 39 fd ff ff       	call   c0107874 <getint>
c0107b3b:	83 c4 10             	add    $0x10,%esp
c0107b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b41:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0107b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b4a:	85 d2                	test   %edx,%edx
c0107b4c:	79 23                	jns    c0107b71 <vprintfmt+0x292>
                putch('-', putdat);
c0107b4e:	83 ec 08             	sub    $0x8,%esp
c0107b51:	ff 75 0c             	push   0xc(%ebp)
c0107b54:	6a 2d                	push   $0x2d
c0107b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b59:	ff d0                	call   *%eax
c0107b5b:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0107b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b64:	f7 d8                	neg    %eax
c0107b66:	83 d2 00             	adc    $0x0,%edx
c0107b69:	f7 da                	neg    %edx
c0107b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0107b71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0107b78:	e9 9f 00 00 00       	jmp    c0107c1c <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0107b7d:	83 ec 08             	sub    $0x8,%esp
c0107b80:	ff 75 e0             	push   -0x20(%ebp)
c0107b83:	8d 45 14             	lea    0x14(%ebp),%eax
c0107b86:	50                   	push   %eax
c0107b87:	e8 99 fc ff ff       	call   c0107825 <getuint>
c0107b8c:	83 c4 10             	add    $0x10,%esp
c0107b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0107b95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0107b9c:	eb 7e                	jmp    c0107c1c <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0107b9e:	83 ec 08             	sub    $0x8,%esp
c0107ba1:	ff 75 e0             	push   -0x20(%ebp)
c0107ba4:	8d 45 14             	lea    0x14(%ebp),%eax
c0107ba7:	50                   	push   %eax
c0107ba8:	e8 78 fc ff ff       	call   c0107825 <getuint>
c0107bad:	83 c4 10             	add    $0x10,%esp
c0107bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107bb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0107bb6:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0107bbd:	eb 5d                	jmp    c0107c1c <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0107bbf:	83 ec 08             	sub    $0x8,%esp
c0107bc2:	ff 75 0c             	push   0xc(%ebp)
c0107bc5:	6a 30                	push   $0x30
c0107bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bca:	ff d0                	call   *%eax
c0107bcc:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0107bcf:	83 ec 08             	sub    $0x8,%esp
c0107bd2:	ff 75 0c             	push   0xc(%ebp)
c0107bd5:	6a 78                	push   $0x78
c0107bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bda:	ff d0                	call   *%eax
c0107bdc:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0107bdf:	8b 45 14             	mov    0x14(%ebp),%eax
c0107be2:	8d 50 04             	lea    0x4(%eax),%edx
c0107be5:	89 55 14             	mov    %edx,0x14(%ebp)
c0107be8:	8b 00                	mov    (%eax),%eax
c0107bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0107bf4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0107bfb:	eb 1f                	jmp    c0107c1c <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0107bfd:	83 ec 08             	sub    $0x8,%esp
c0107c00:	ff 75 e0             	push   -0x20(%ebp)
c0107c03:	8d 45 14             	lea    0x14(%ebp),%eax
c0107c06:	50                   	push   %eax
c0107c07:	e8 19 fc ff ff       	call   c0107825 <getuint>
c0107c0c:	83 c4 10             	add    $0x10,%esp
c0107c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c12:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0107c15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0107c1c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0107c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c23:	83 ec 04             	sub    $0x4,%esp
c0107c26:	52                   	push   %edx
c0107c27:	ff 75 e8             	push   -0x18(%ebp)
c0107c2a:	50                   	push   %eax
c0107c2b:	ff 75 f4             	push   -0xc(%ebp)
c0107c2e:	ff 75 f0             	push   -0x10(%ebp)
c0107c31:	ff 75 0c             	push   0xc(%ebp)
c0107c34:	ff 75 08             	push   0x8(%ebp)
c0107c37:	e8 fd fa ff ff       	call   c0107739 <printnum>
c0107c3c:	83 c4 20             	add    $0x20,%esp
            break;
c0107c3f:	eb 39                	jmp    c0107c7a <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0107c41:	83 ec 08             	sub    $0x8,%esp
c0107c44:	ff 75 0c             	push   0xc(%ebp)
c0107c47:	53                   	push   %ebx
c0107c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c4b:	ff d0                	call   *%eax
c0107c4d:	83 c4 10             	add    $0x10,%esp
            break;
c0107c50:	eb 28                	jmp    c0107c7a <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0107c52:	83 ec 08             	sub    $0x8,%esp
c0107c55:	ff 75 0c             	push   0xc(%ebp)
c0107c58:	6a 25                	push   $0x25
c0107c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c5d:	ff d0                	call   *%eax
c0107c5f:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0107c62:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0107c66:	eb 04                	jmp    c0107c6c <vprintfmt+0x38d>
c0107c68:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0107c6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c6f:	83 e8 01             	sub    $0x1,%eax
c0107c72:	0f b6 00             	movzbl (%eax),%eax
c0107c75:	3c 25                	cmp    $0x25,%al
c0107c77:	75 ef                	jne    c0107c68 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0107c79:	90                   	nop
    while (1) {
c0107c7a:	e9 68 fc ff ff       	jmp    c01078e7 <vprintfmt+0x8>
                return;
c0107c7f:	90                   	nop
        }
    }
}
c0107c80:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0107c83:	5b                   	pop    %ebx
c0107c84:	5e                   	pop    %esi
c0107c85:	5d                   	pop    %ebp
c0107c86:	c3                   	ret    

c0107c87 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0107c87:	55                   	push   %ebp
c0107c88:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0107c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c8d:	8b 40 08             	mov    0x8(%eax),%eax
c0107c90:	8d 50 01             	lea    0x1(%eax),%edx
c0107c93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c96:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0107c99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c9c:	8b 10                	mov    (%eax),%edx
c0107c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ca1:	8b 40 04             	mov    0x4(%eax),%eax
c0107ca4:	39 c2                	cmp    %eax,%edx
c0107ca6:	73 12                	jae    c0107cba <sprintputch+0x33>
        *b->buf ++ = ch;
c0107ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cab:	8b 00                	mov    (%eax),%eax
c0107cad:	8d 48 01             	lea    0x1(%eax),%ecx
c0107cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107cb3:	89 0a                	mov    %ecx,(%edx)
c0107cb5:	8b 55 08             	mov    0x8(%ebp),%edx
c0107cb8:	88 10                	mov    %dl,(%eax)
    }
}
c0107cba:	90                   	nop
c0107cbb:	5d                   	pop    %ebp
c0107cbc:	c3                   	ret    

c0107cbd <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0107cbd:	55                   	push   %ebp
c0107cbe:	89 e5                	mov    %esp,%ebp
c0107cc0:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0107cc3:	8d 45 14             	lea    0x14(%ebp),%eax
c0107cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0107cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ccc:	50                   	push   %eax
c0107ccd:	ff 75 10             	push   0x10(%ebp)
c0107cd0:	ff 75 0c             	push   0xc(%ebp)
c0107cd3:	ff 75 08             	push   0x8(%ebp)
c0107cd6:	e8 0b 00 00 00       	call   c0107ce6 <vsnprintf>
c0107cdb:	83 c4 10             	add    $0x10,%esp
c0107cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0107ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107ce4:	c9                   	leave  
c0107ce5:	c3                   	ret    

c0107ce6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0107ce6:	55                   	push   %ebp
c0107ce7:	89 e5                	mov    %esp,%ebp
c0107ce9:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0107cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cf5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cfb:	01 d0                	add    %edx,%eax
c0107cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0107d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107d0b:	74 0a                	je     c0107d17 <vsnprintf+0x31>
c0107d0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d13:	39 c2                	cmp    %eax,%edx
c0107d15:	76 07                	jbe    c0107d1e <vsnprintf+0x38>
        return -E_INVAL;
c0107d17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0107d1c:	eb 20                	jmp    c0107d3e <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0107d1e:	ff 75 14             	push   0x14(%ebp)
c0107d21:	ff 75 10             	push   0x10(%ebp)
c0107d24:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0107d27:	50                   	push   %eax
c0107d28:	68 87 7c 10 c0       	push   $0xc0107c87
c0107d2d:	e8 ad fb ff ff       	call   c01078df <vprintfmt>
c0107d32:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0107d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d38:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0107d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107d3e:	c9                   	leave  
c0107d3f:	c3                   	ret    

c0107d40 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0107d40:	55                   	push   %ebp
c0107d41:	89 e5                	mov    %esp,%ebp
c0107d43:	57                   	push   %edi
c0107d44:	56                   	push   %esi
c0107d45:	53                   	push   %ebx
c0107d46:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0107d49:	a1 60 2a 12 c0       	mov    0xc0122a60,%eax
c0107d4e:	8b 15 64 2a 12 c0    	mov    0xc0122a64,%edx
c0107d54:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0107d5a:	6b f0 05             	imul   $0x5,%eax,%esi
c0107d5d:	01 fe                	add    %edi,%esi
c0107d5f:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0107d64:	f7 e7                	mul    %edi
c0107d66:	01 d6                	add    %edx,%esi
c0107d68:	89 f2                	mov    %esi,%edx
c0107d6a:	83 c0 0b             	add    $0xb,%eax
c0107d6d:	83 d2 00             	adc    $0x0,%edx
c0107d70:	89 c7                	mov    %eax,%edi
c0107d72:	83 e7 ff             	and    $0xffffffff,%edi
c0107d75:	89 f9                	mov    %edi,%ecx
c0107d77:	0f b7 da             	movzwl %dx,%ebx
c0107d7a:	89 0d 60 2a 12 c0    	mov    %ecx,0xc0122a60
c0107d80:	89 1d 64 2a 12 c0    	mov    %ebx,0xc0122a64
    unsigned long long result = (next >> 12);
c0107d86:	a1 60 2a 12 c0       	mov    0xc0122a60,%eax
c0107d8b:	8b 15 64 2a 12 c0    	mov    0xc0122a64,%edx
c0107d91:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107d95:	c1 ea 0c             	shr    $0xc,%edx
c0107d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107d9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0107d9e:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0107da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107dab:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107dae:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107db7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107dbb:	74 1c                	je     c0107dd9 <rand+0x99>
c0107dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dc0:	ba 00 00 00 00       	mov    $0x0,%edx
c0107dc5:	f7 75 dc             	divl   -0x24(%ebp)
c0107dc8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dce:	ba 00 00 00 00       	mov    $0x0,%edx
c0107dd3:	f7 75 dc             	divl   -0x24(%ebp)
c0107dd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107dd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107ddf:	f7 75 dc             	divl   -0x24(%ebp)
c0107de2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107de5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107de8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107deb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107dee:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107df1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107df4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0107df7:	83 c4 24             	add    $0x24,%esp
c0107dfa:	5b                   	pop    %ebx
c0107dfb:	5e                   	pop    %esi
c0107dfc:	5f                   	pop    %edi
c0107dfd:	5d                   	pop    %ebp
c0107dfe:	c3                   	ret    

c0107dff <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0107dff:	55                   	push   %ebp
c0107e00:	89 e5                	mov    %esp,%ebp
    next = seed;
c0107e02:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e05:	ba 00 00 00 00       	mov    $0x0,%edx
c0107e0a:	a3 60 2a 12 c0       	mov    %eax,0xc0122a60
c0107e0f:	89 15 64 2a 12 c0    	mov    %edx,0xc0122a64
}
c0107e15:	90                   	nop
c0107e16:	5d                   	pop    %ebp
c0107e17:	c3                   	ret    

c0107e18 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0107e18:	55                   	push   %ebp
c0107e19:	89 e5                	mov    %esp,%ebp
c0107e1b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0107e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0107e25:	eb 04                	jmp    c0107e2b <strlen+0x13>
        cnt ++;
c0107e27:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0107e2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e2e:	8d 50 01             	lea    0x1(%eax),%edx
c0107e31:	89 55 08             	mov    %edx,0x8(%ebp)
c0107e34:	0f b6 00             	movzbl (%eax),%eax
c0107e37:	84 c0                	test   %al,%al
c0107e39:	75 ec                	jne    c0107e27 <strlen+0xf>
    }
    return cnt;
c0107e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107e3e:	c9                   	leave  
c0107e3f:	c3                   	ret    

c0107e40 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0107e40:	55                   	push   %ebp
c0107e41:	89 e5                	mov    %esp,%ebp
c0107e43:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0107e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0107e4d:	eb 04                	jmp    c0107e53 <strnlen+0x13>
        cnt ++;
c0107e4f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0107e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107e56:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107e59:	73 10                	jae    c0107e6b <strnlen+0x2b>
c0107e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e5e:	8d 50 01             	lea    0x1(%eax),%edx
c0107e61:	89 55 08             	mov    %edx,0x8(%ebp)
c0107e64:	0f b6 00             	movzbl (%eax),%eax
c0107e67:	84 c0                	test   %al,%al
c0107e69:	75 e4                	jne    c0107e4f <strnlen+0xf>
    }
    return cnt;
c0107e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107e6e:	c9                   	leave  
c0107e6f:	c3                   	ret    

c0107e70 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0107e70:	55                   	push   %ebp
c0107e71:	89 e5                	mov    %esp,%ebp
c0107e73:	57                   	push   %edi
c0107e74:	56                   	push   %esi
c0107e75:	83 ec 20             	sub    $0x20,%esp
c0107e78:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0107e84:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e8a:	89 d1                	mov    %edx,%ecx
c0107e8c:	89 c2                	mov    %eax,%edx
c0107e8e:	89 ce                	mov    %ecx,%esi
c0107e90:	89 d7                	mov    %edx,%edi
c0107e92:	ac                   	lods   %ds:(%esi),%al
c0107e93:	aa                   	stos   %al,%es:(%edi)
c0107e94:	84 c0                	test   %al,%al
c0107e96:	75 fa                	jne    c0107e92 <strcpy+0x22>
c0107e98:	89 fa                	mov    %edi,%edx
c0107e9a:	89 f1                	mov    %esi,%ecx
c0107e9c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0107e9f:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0107ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0107ea8:	83 c4 20             	add    $0x20,%esp
c0107eab:	5e                   	pop    %esi
c0107eac:	5f                   	pop    %edi
c0107ead:	5d                   	pop    %ebp
c0107eae:	c3                   	ret    

c0107eaf <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0107eaf:	55                   	push   %ebp
c0107eb0:	89 e5                	mov    %esp,%ebp
c0107eb2:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0107eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0107ebb:	eb 21                	jmp    c0107ede <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0107ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ec0:	0f b6 10             	movzbl (%eax),%edx
c0107ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ec6:	88 10                	mov    %dl,(%eax)
c0107ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107ecb:	0f b6 00             	movzbl (%eax),%eax
c0107ece:	84 c0                	test   %al,%al
c0107ed0:	74 04                	je     c0107ed6 <strncpy+0x27>
            src ++;
c0107ed2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0107ed6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0107eda:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0107ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107ee2:	75 d9                	jne    c0107ebd <strncpy+0xe>
    }
    return dst;
c0107ee4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107ee7:	c9                   	leave  
c0107ee8:	c3                   	ret    

c0107ee9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0107ee9:	55                   	push   %ebp
c0107eea:	89 e5                	mov    %esp,%ebp
c0107eec:	57                   	push   %edi
c0107eed:	56                   	push   %esi
c0107eee:	83 ec 20             	sub    $0x20,%esp
c0107ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0107efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f03:	89 d1                	mov    %edx,%ecx
c0107f05:	89 c2                	mov    %eax,%edx
c0107f07:	89 ce                	mov    %ecx,%esi
c0107f09:	89 d7                	mov    %edx,%edi
c0107f0b:	ac                   	lods   %ds:(%esi),%al
c0107f0c:	ae                   	scas   %es:(%edi),%al
c0107f0d:	75 08                	jne    c0107f17 <strcmp+0x2e>
c0107f0f:	84 c0                	test   %al,%al
c0107f11:	75 f8                	jne    c0107f0b <strcmp+0x22>
c0107f13:	31 c0                	xor    %eax,%eax
c0107f15:	eb 04                	jmp    c0107f1b <strcmp+0x32>
c0107f17:	19 c0                	sbb    %eax,%eax
c0107f19:	0c 01                	or     $0x1,%al
c0107f1b:	89 fa                	mov    %edi,%edx
c0107f1d:	89 f1                	mov    %esi,%ecx
c0107f1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107f22:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0107f25:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0107f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0107f2b:	83 c4 20             	add    $0x20,%esp
c0107f2e:	5e                   	pop    %esi
c0107f2f:	5f                   	pop    %edi
c0107f30:	5d                   	pop    %ebp
c0107f31:	c3                   	ret    

c0107f32 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0107f32:	55                   	push   %ebp
c0107f33:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0107f35:	eb 0c                	jmp    c0107f43 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0107f37:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0107f3b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107f3f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0107f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107f47:	74 1a                	je     c0107f63 <strncmp+0x31>
c0107f49:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f4c:	0f b6 00             	movzbl (%eax),%eax
c0107f4f:	84 c0                	test   %al,%al
c0107f51:	74 10                	je     c0107f63 <strncmp+0x31>
c0107f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f56:	0f b6 10             	movzbl (%eax),%edx
c0107f59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f5c:	0f b6 00             	movzbl (%eax),%eax
c0107f5f:	38 c2                	cmp    %al,%dl
c0107f61:	74 d4                	je     c0107f37 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0107f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107f67:	74 18                	je     c0107f81 <strncmp+0x4f>
c0107f69:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6c:	0f b6 00             	movzbl (%eax),%eax
c0107f6f:	0f b6 d0             	movzbl %al,%edx
c0107f72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f75:	0f b6 00             	movzbl (%eax),%eax
c0107f78:	0f b6 c8             	movzbl %al,%ecx
c0107f7b:	89 d0                	mov    %edx,%eax
c0107f7d:	29 c8                	sub    %ecx,%eax
c0107f7f:	eb 05                	jmp    c0107f86 <strncmp+0x54>
c0107f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f86:	5d                   	pop    %ebp
c0107f87:	c3                   	ret    

c0107f88 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0107f88:	55                   	push   %ebp
c0107f89:	89 e5                	mov    %esp,%ebp
c0107f8b:	83 ec 04             	sub    $0x4,%esp
c0107f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f91:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107f94:	eb 14                	jmp    c0107faa <strchr+0x22>
        if (*s == c) {
c0107f96:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f99:	0f b6 00             	movzbl (%eax),%eax
c0107f9c:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0107f9f:	75 05                	jne    c0107fa6 <strchr+0x1e>
            return (char *)s;
c0107fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa4:	eb 13                	jmp    c0107fb9 <strchr+0x31>
        }
        s ++;
c0107fa6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0107faa:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fad:	0f b6 00             	movzbl (%eax),%eax
c0107fb0:	84 c0                	test   %al,%al
c0107fb2:	75 e2                	jne    c0107f96 <strchr+0xe>
    }
    return NULL;
c0107fb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107fb9:	c9                   	leave  
c0107fba:	c3                   	ret    

c0107fbb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0107fbb:	55                   	push   %ebp
c0107fbc:	89 e5                	mov    %esp,%ebp
c0107fbe:	83 ec 04             	sub    $0x4,%esp
c0107fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fc4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107fc7:	eb 0f                	jmp    c0107fd8 <strfind+0x1d>
        if (*s == c) {
c0107fc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fcc:	0f b6 00             	movzbl (%eax),%eax
c0107fcf:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0107fd2:	74 10                	je     c0107fe4 <strfind+0x29>
            break;
        }
        s ++;
c0107fd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0107fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fdb:	0f b6 00             	movzbl (%eax),%eax
c0107fde:	84 c0                	test   %al,%al
c0107fe0:	75 e7                	jne    c0107fc9 <strfind+0xe>
c0107fe2:	eb 01                	jmp    c0107fe5 <strfind+0x2a>
            break;
c0107fe4:	90                   	nop
    }
    return (char *)s;
c0107fe5:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0107fe8:	c9                   	leave  
c0107fe9:	c3                   	ret    

c0107fea <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0107fea:	55                   	push   %ebp
c0107feb:	89 e5                	mov    %esp,%ebp
c0107fed:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0107ff0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0107ff7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107ffe:	eb 04                	jmp    c0108004 <strtol+0x1a>
        s ++;
c0108000:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0108004:	8b 45 08             	mov    0x8(%ebp),%eax
c0108007:	0f b6 00             	movzbl (%eax),%eax
c010800a:	3c 20                	cmp    $0x20,%al
c010800c:	74 f2                	je     c0108000 <strtol+0x16>
c010800e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108011:	0f b6 00             	movzbl (%eax),%eax
c0108014:	3c 09                	cmp    $0x9,%al
c0108016:	74 e8                	je     c0108000 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0108018:	8b 45 08             	mov    0x8(%ebp),%eax
c010801b:	0f b6 00             	movzbl (%eax),%eax
c010801e:	3c 2b                	cmp    $0x2b,%al
c0108020:	75 06                	jne    c0108028 <strtol+0x3e>
        s ++;
c0108022:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108026:	eb 15                	jmp    c010803d <strtol+0x53>
    }
    else if (*s == '-') {
c0108028:	8b 45 08             	mov    0x8(%ebp),%eax
c010802b:	0f b6 00             	movzbl (%eax),%eax
c010802e:	3c 2d                	cmp    $0x2d,%al
c0108030:	75 0b                	jne    c010803d <strtol+0x53>
        s ++, neg = 1;
c0108032:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108036:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010803d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108041:	74 06                	je     c0108049 <strtol+0x5f>
c0108043:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108047:	75 24                	jne    c010806d <strtol+0x83>
c0108049:	8b 45 08             	mov    0x8(%ebp),%eax
c010804c:	0f b6 00             	movzbl (%eax),%eax
c010804f:	3c 30                	cmp    $0x30,%al
c0108051:	75 1a                	jne    c010806d <strtol+0x83>
c0108053:	8b 45 08             	mov    0x8(%ebp),%eax
c0108056:	83 c0 01             	add    $0x1,%eax
c0108059:	0f b6 00             	movzbl (%eax),%eax
c010805c:	3c 78                	cmp    $0x78,%al
c010805e:	75 0d                	jne    c010806d <strtol+0x83>
        s += 2, base = 16;
c0108060:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108064:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010806b:	eb 2a                	jmp    c0108097 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010806d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108071:	75 17                	jne    c010808a <strtol+0xa0>
c0108073:	8b 45 08             	mov    0x8(%ebp),%eax
c0108076:	0f b6 00             	movzbl (%eax),%eax
c0108079:	3c 30                	cmp    $0x30,%al
c010807b:	75 0d                	jne    c010808a <strtol+0xa0>
        s ++, base = 8;
c010807d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108081:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108088:	eb 0d                	jmp    c0108097 <strtol+0xad>
    }
    else if (base == 0) {
c010808a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010808e:	75 07                	jne    c0108097 <strtol+0xad>
        base = 10;
c0108090:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108097:	8b 45 08             	mov    0x8(%ebp),%eax
c010809a:	0f b6 00             	movzbl (%eax),%eax
c010809d:	3c 2f                	cmp    $0x2f,%al
c010809f:	7e 1b                	jle    c01080bc <strtol+0xd2>
c01080a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01080a4:	0f b6 00             	movzbl (%eax),%eax
c01080a7:	3c 39                	cmp    $0x39,%al
c01080a9:	7f 11                	jg     c01080bc <strtol+0xd2>
            dig = *s - '0';
c01080ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ae:	0f b6 00             	movzbl (%eax),%eax
c01080b1:	0f be c0             	movsbl %al,%eax
c01080b4:	83 e8 30             	sub    $0x30,%eax
c01080b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01080ba:	eb 48                	jmp    c0108104 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01080bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01080bf:	0f b6 00             	movzbl (%eax),%eax
c01080c2:	3c 60                	cmp    $0x60,%al
c01080c4:	7e 1b                	jle    c01080e1 <strtol+0xf7>
c01080c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01080c9:	0f b6 00             	movzbl (%eax),%eax
c01080cc:	3c 7a                	cmp    $0x7a,%al
c01080ce:	7f 11                	jg     c01080e1 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01080d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01080d3:	0f b6 00             	movzbl (%eax),%eax
c01080d6:	0f be c0             	movsbl %al,%eax
c01080d9:	83 e8 57             	sub    $0x57,%eax
c01080dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01080df:	eb 23                	jmp    c0108104 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01080e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01080e4:	0f b6 00             	movzbl (%eax),%eax
c01080e7:	3c 40                	cmp    $0x40,%al
c01080e9:	7e 3c                	jle    c0108127 <strtol+0x13d>
c01080eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ee:	0f b6 00             	movzbl (%eax),%eax
c01080f1:	3c 5a                	cmp    $0x5a,%al
c01080f3:	7f 32                	jg     c0108127 <strtol+0x13d>
            dig = *s - 'A' + 10;
c01080f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f8:	0f b6 00             	movzbl (%eax),%eax
c01080fb:	0f be c0             	movsbl %al,%eax
c01080fe:	83 e8 37             	sub    $0x37,%eax
c0108101:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108104:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108107:	3b 45 10             	cmp    0x10(%ebp),%eax
c010810a:	7d 1a                	jge    c0108126 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010810c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108110:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108113:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108117:	89 c2                	mov    %eax,%edx
c0108119:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010811c:	01 d0                	add    %edx,%eax
c010811e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0108121:	e9 71 ff ff ff       	jmp    c0108097 <strtol+0xad>
            break;
c0108126:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0108127:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010812b:	74 08                	je     c0108135 <strtol+0x14b>
        *endptr = (char *) s;
c010812d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108130:	8b 55 08             	mov    0x8(%ebp),%edx
c0108133:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108135:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108139:	74 07                	je     c0108142 <strtol+0x158>
c010813b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010813e:	f7 d8                	neg    %eax
c0108140:	eb 03                	jmp    c0108145 <strtol+0x15b>
c0108142:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108145:	c9                   	leave  
c0108146:	c3                   	ret    

c0108147 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108147:	55                   	push   %ebp
c0108148:	89 e5                	mov    %esp,%ebp
c010814a:	57                   	push   %edi
c010814b:	83 ec 24             	sub    $0x24,%esp
c010814e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108151:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108154:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108158:	8b 55 08             	mov    0x8(%ebp),%edx
c010815b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010815e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108161:	8b 45 10             	mov    0x10(%ebp),%eax
c0108164:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108167:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010816a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010816e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108171:	89 d7                	mov    %edx,%edi
c0108173:	f3 aa                	rep stos %al,%es:(%edi)
c0108175:	89 fa                	mov    %edi,%edx
c0108177:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010817a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010817d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108180:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0108183:	c9                   	leave  
c0108184:	c3                   	ret    

c0108185 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108185:	55                   	push   %ebp
c0108186:	89 e5                	mov    %esp,%ebp
c0108188:	57                   	push   %edi
c0108189:	56                   	push   %esi
c010818a:	53                   	push   %ebx
c010818b:	83 ec 30             	sub    $0x30,%esp
c010818e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108191:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108194:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108197:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010819a:	8b 45 10             	mov    0x10(%ebp),%eax
c010819d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01081a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081a3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01081a6:	73 42                	jae    c01081ea <memmove+0x65>
c01081a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01081ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01081b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01081ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01081bd:	c1 e8 02             	shr    $0x2,%eax
c01081c0:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01081c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01081c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081c8:	89 d7                	mov    %edx,%edi
c01081ca:	89 c6                	mov    %eax,%esi
c01081cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01081ce:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01081d1:	83 e1 03             	and    $0x3,%ecx
c01081d4:	74 02                	je     c01081d8 <memmove+0x53>
c01081d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01081d8:	89 f0                	mov    %esi,%eax
c01081da:	89 fa                	mov    %edi,%edx
c01081dc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01081df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01081e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01081e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01081e8:	eb 36                	jmp    c0108220 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01081ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081ed:	8d 50 ff             	lea    -0x1(%eax),%edx
c01081f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081f3:	01 c2                	add    %eax,%edx
c01081f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081f8:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01081fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081fe:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0108201:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108204:	89 c1                	mov    %eax,%ecx
c0108206:	89 d8                	mov    %ebx,%eax
c0108208:	89 d6                	mov    %edx,%esi
c010820a:	89 c7                	mov    %eax,%edi
c010820c:	fd                   	std    
c010820d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010820f:	fc                   	cld    
c0108210:	89 f8                	mov    %edi,%eax
c0108212:	89 f2                	mov    %esi,%edx
c0108214:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108217:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010821a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010821d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108220:	83 c4 30             	add    $0x30,%esp
c0108223:	5b                   	pop    %ebx
c0108224:	5e                   	pop    %esi
c0108225:	5f                   	pop    %edi
c0108226:	5d                   	pop    %ebp
c0108227:	c3                   	ret    

c0108228 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108228:	55                   	push   %ebp
c0108229:	89 e5                	mov    %esp,%ebp
c010822b:	57                   	push   %edi
c010822c:	56                   	push   %esi
c010822d:	83 ec 20             	sub    $0x20,%esp
c0108230:	8b 45 08             	mov    0x8(%ebp),%eax
c0108233:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108239:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010823c:	8b 45 10             	mov    0x10(%ebp),%eax
c010823f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108242:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108245:	c1 e8 02             	shr    $0x2,%eax
c0108248:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010824a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010824d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108250:	89 d7                	mov    %edx,%edi
c0108252:	89 c6                	mov    %eax,%esi
c0108254:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108256:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108259:	83 e1 03             	and    $0x3,%ecx
c010825c:	74 02                	je     c0108260 <memcpy+0x38>
c010825e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108260:	89 f0                	mov    %esi,%eax
c0108262:	89 fa                	mov    %edi,%edx
c0108264:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010826a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108270:	83 c4 20             	add    $0x20,%esp
c0108273:	5e                   	pop    %esi
c0108274:	5f                   	pop    %edi
c0108275:	5d                   	pop    %ebp
c0108276:	c3                   	ret    

c0108277 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108277:	55                   	push   %ebp
c0108278:	89 e5                	mov    %esp,%ebp
c010827a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010827d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108280:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108286:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108289:	eb 30                	jmp    c01082bb <memcmp+0x44>
        if (*s1 != *s2) {
c010828b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010828e:	0f b6 10             	movzbl (%eax),%edx
c0108291:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108294:	0f b6 00             	movzbl (%eax),%eax
c0108297:	38 c2                	cmp    %al,%dl
c0108299:	74 18                	je     c01082b3 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010829b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010829e:	0f b6 00             	movzbl (%eax),%eax
c01082a1:	0f b6 d0             	movzbl %al,%edx
c01082a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01082a7:	0f b6 00             	movzbl (%eax),%eax
c01082aa:	0f b6 c8             	movzbl %al,%ecx
c01082ad:	89 d0                	mov    %edx,%eax
c01082af:	29 c8                	sub    %ecx,%eax
c01082b1:	eb 1a                	jmp    c01082cd <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01082b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01082b7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c01082bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01082be:	8d 50 ff             	lea    -0x1(%eax),%edx
c01082c1:	89 55 10             	mov    %edx,0x10(%ebp)
c01082c4:	85 c0                	test   %eax,%eax
c01082c6:	75 c3                	jne    c010828b <memcmp+0x14>
    }
    return 0;
c01082c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01082cd:	c9                   	leave  
c01082ce:	c3                   	ret    
