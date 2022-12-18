# Lab4实验报告

**一、实验目的**

* 了解内核线程创建/执行的管理过程
* 了解内核线程的切换和基本调度过程

**二、实验过程**

这次实验中我没有遇到什么实质性的bug或是困难，以下将简要讲一下本次实验的关键部分和我的一些想法。

## 关键数据结构——进程控制块

```c
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
```

在ucore中，并不对进程与线程显示区分，都适用同样的数据结构`proc_struct`来进行管理。当不同的
`proc_struct`对应的页表`cr3`相同时，ucore认为是同一进程的不同线程。


## initproc生命周期

下面捋一下`initproc`的整个过程。
* 通过`kernel_thread`函数，构造一个临时的`trap_frame`栈帧，其中设置了`CS`指向内核代码段选择子、`DS`/`ES`/`SS`等指向内核的数据段选择子。令中断栈帧中`tf_regs.ebx`、`tf_regs.edx`保存函数`fn`和参数`arg`，`tf_eip`指向`kernel_thread_entry`。

* 通过`do_fork`分配一个未初始化的线程控制块`proc_struct`，设置并初始化其一系列状态。通过`copy_thread`中设置中断帧，设置线程上下文`struct context`中`eip`值为`forkret`，令上下文切换`switch`返回后跳转到`forkret`处，设置上下文中`esp`的值为内核栈的栈顶，此处存储的是中断帧。将`init_proc`加入`ucore`的就绪队列，等待CPU调度。

* `idle_proc`在`cpu_idle`中触发`schedule`，将`init_proc`线程从就绪队列中取出，执行`switch_to`进行`idle_proc`和`init_proc`的`context`线程上下文的切换。

* `switch_to`返回时，CPU开始执行`init_proc`，跳转至`forkret`处。

* `fork_ret`中，进行中断返回。将之前存放在内核栈中的中断帧中的数据依次弹出，并调整栈顶为`tf_eip`，`iret`后跳转至`kernel_thread_entry`处。

* `kernel_thread_entry`中，利用之前在中断栈中设置好的`ebx(fn)`，`edx(arg)`执行真正的`init_proc`逻辑的处理(`init_main`函数)，在`init_main`返回后，跳转至`do_exit `终止退出。


*源码链接：https://github.com/Donnykk/OS_Lab*