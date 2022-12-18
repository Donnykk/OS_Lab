#ifndef __KERN_PROCESS_PROC_H__
#define __KERN_PROCESS_PROC_H__

#include <defs.h>
#include <list.h>
#include <trap.h>
#include <memlayout.h>

// process's state in his life cycle
// 进程所处的状态
enum proc_state
{
    // 未初始化
    PROC_UNINIT = 0, // uninitialized
                     // 休眠、阻塞状态
    PROC_SLEEPING,   // sleeping
                     // 可运行、就绪状态
    PROC_RUNNABLE,   // runnable(maybe running)
                     // 僵尸状态(几乎已经终止，等待父进程回收其所占资源)
    PROC_ZOMBIE,     // almost dead, and wait parent proc to reclaim his resource
};

// 保存寄存器的目的就在于在内核态中能够进行上下文之间的切换
// 只保存会随着进程切换而改变的寄存器
// Saved registers for kernel context switches.
// Don't need to save all the %fs etc. segment registers,
// because they are constant across kernel contexts.
// Save all the regular registers so we don't need to care
// which are caller save, but not the return register %eax.
// (Not saving %eax just simplifies the switching code.)
// The layout of context must match code in switch.S.
struct context
{
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};

#define PROC_NAME_LEN 15
#define MAX_PROCESS 4096
#define MAX_PID (MAX_PROCESS * 2)

extern list_entry_t proc_list;

/**
 * 进程控制块结构（ucore进程和线程都使用proc_struct进行管理）
 * */
struct proc_struct
{
    // 进程状态
    enum proc_state state; // Process state
    // 进程id
    int pid; // Process ID
    // 被调度执行的总次数/时间片数
    int runs; // the running times of Proces
    // 当前进程内核栈底地址（思考下下面哪里可以反映出这是栈底）
    uintptr_t kstack; // Process kernel stack
    // 是否需要被重新调度，以使当前线程让出CPU
    volatile bool need_resched; // bool value: need to be rescheduled to release CPU ?
    // 当前进程的父进程
    struct proc_struct *parent; // the parent process
    // 当前进程关联的内存总管理器
    struct mm_struct *mm; // Process's memory management field
    // 切换进程时保存的上下文快照
    struct context context; // Switch here to run process
    // 切换进程时的当前中断栈帧
    struct trapframe *tf; // Trap frame for current interrupt
    // 当前进程页表基地址寄存器cr3(指向当前进程的页表物理地址)
    uintptr_t cr3; // CR3 register: the base addr of Page Directroy Table(PDT)
    // 当前进程的状态标志位
    uint32_t flags; // Process flag
    // 进程名
    char name[PROC_NAME_LEN + 1]; // Process name
    // 进程控制块链表节点
    list_entry_t list_link; // Process link list
    // 进程控制块哈希表节点
    list_entry_t hash_link; // Process hash list
};

#define le2proc(le, member) \
    to_struct((le), struct proc_struct, member)

extern struct proc_struct *idleproc, *initproc, *current;

void proc_init(void);
void proc_run(struct proc_struct *proc);
int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);

char *set_proc_name(struct proc_struct *proc, const char *name);
char *get_proc_name(struct proc_struct *proc);
void cpu_idle(void) __attribute__((noreturn));

struct proc_struct *find_proc(int pid);
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
int do_exit(int error_code);

#endif /* !__KERN_PROCESS_PROC_H__ */
