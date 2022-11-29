# Lab3实验报告

**一、实验目的**

* 了解虚拟内存的Page Fault异常处理实现
* 了解页替换算法在操作系统中的实现

**二、实验过程**

这次实验中我没有遇到什么实质性的bug或是困难，以下将简要讲一下本次实验的难点和我的一些想法。

## 难点1：理解vma与mm

`ucore`中用`vma_struct`来描述合法的连续虚拟内存空间块，一个进程合法的虚拟地址空间段将以`vma`集合的方式表示。

按照`vma_struct`对应的虚拟地址空间的高低顺序(还是从低地址到高地址)可以组成一个双向循环链表，与`lab2`中的`free_list`类似。

```c
// the virtual continuous memory area(vma), [vm_start, vm_end), 
// addr belong to a vma means  vma.vm_start<= addr <vma.vm_end 
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT 
    uintptr_t vm_start;      // start addr of vma      
    uintptr_t vm_end;        // end addr of vma, not include the vm_end itself
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma
};

#define le2vma(le, member)                  \
    to_struct((le), struct vma_struct, member)

//flags中目前用到的属性 可读、可写、可执行
#define VM_READ                 0x00000001
#define VM_WRITE                0x00000002
#define VM_EXEC                 0x00000004
```

这里由于与`free_list`几乎完全一致，不再多说。几个变量意思很明显，其中第一个变量`mm_struct`是另一个结构，具体看下面。

`mm_struct`作为一个进程的内存管理器，统一管理一个进程的虚拟内存与物理内存。

```c
// the control struct for a set of vma using the same PDT
struct mm_struct {
    // 连续虚拟内存块链表头 (内部节点虚拟内存块的起始、截止地址必须全局有序，且不能出现重叠)
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    // 当前访问的mmap_list链表中的vma块(由于局部性原理，之前访问过的vma有更大可能会在后续继续访问，该缓存可以减少从mmap_list中进行遍历查找的次数，提高效率)
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    // 当前mm_struct关联的页目录表
    pde_t *pgdir;                  // the PDT of these vma
    // 当前mm_struct->mmap_list中vma块的数量
    int map_count;                 // the count of these vma
    // 用于虚拟内存置换算法的属性，使用void*指针做到通用 (lab中默认的swap_fifo替换算法中，将其做为了一个先进先出链表队列)
    // sm_priv指向用来链接记录页访问情况的链表头，这建立了mm_struct和后续要讲到的swap_manager之间的联系
    void *sm_priv;                   // the private data for swap manager
};
```

## 难点2：换入换出

在`ucore`中，没有单独的另外构建一张虚拟页与磁盘扇区的映射表，而是巧妙地重复利用了二级页表项。

当一个`PTE`用来描述一般意义上的物理页时，显然它应该维护各种权限和映射关系，以及应该有`PTE_P`标记；但当它用来描述一个被置换出去的物理页时，它被用来维护该物理页与` swap `磁盘上扇区的映射关系，并且该` PTE `不应该由` MMU `将它解释成物理页映射(即没有` PTE_P` 标记)，与此同时对应的权限则交由` mm_struct `来维护，当对位于该页的内存地址进行访问的时候，必然导致` page fault`，然后`ucore`能够根据` PTE `描述的` swap `项将相应的物理页重新建立起来，并根据虚存所描述的权限重新设置好` PTE `使得内存访问能够继续正常进行。

也就是说，当`PTE_P`为1时表明所映射的物理页存在，访问正常；为0时代表不存在，此时`pte`表示的是虚拟页与磁盘扇区的对应关系。在后者的情况下，`ucore`用`pte`的高24位数据表明这一页的起始扇区号。但是为了区分全0的`pte`与从`swap`分区的第一个扇区开始存的页对应的`pte`，`ucore`规定`swap`分区从第9个扇区开始用（即空一个页的大小）。简单说就是，表明虚拟页与磁盘扇区对应关系的`pte`的高24位不全为0。

所以，`pte`就有以下三种情况：

- 全为0，代表未建立对应物理页的映射
- P位为1，代表已建立对应物理页的映射
- P位为0，但高24位不为0。代表所映射的物理页存在，只是被交换到了磁盘交换区中。

对于表明虚拟页与磁盘扇区的对应关系的`pte`，我们称它为`swap_entry_t`。

```c
// swap.c
/* *
 * swap_entry_t
 * --------------------------------------------
 * |         offset        |   reserved   | 0 |
 * --------------------------------------------
 *           24 bits            7 bits    1 bit
 * */

// memlayout.h
typedef pte_t swap_entry_t; //the pte can also be a swap entry
```

一个页大小`4KB`，而一个磁盘扇区大小`0.5KB`，因此一个页需要8个连续扇区来存储。

在`ucore`中为了简化设计，规定`offset*8`即为起始扇区号。

`ucore`可以保存`262144/8=32768`个页，即`128MB`的内存空间。`swap `分区的大小是` swapfs_init `里面根据磁盘驱动的接口计算出来的，目前` ucore` 里面要求` swap `磁盘至少包含` 1000 `个` page`，并且至多能使用 `1<<24 `个`page`。

### 何时进行换入和换出操作？ ###

当所访问的页存储在交换分区时（即`PTE`中高24位不为0而最低位为0），会发生页的换入。页的换入由`swap_in`完成。

`ucore`采用消极换出策略，即当请求空闲页时没有可供分配的物理页时才会发生页的换出。即当调用`alloc_page`并没有空闲的物理页时会调用`swap_out`完成页的换出。

在lab3中，用`check_mm_struct`来表示`ucore`认为所有合法的虚拟空间集合。（目前由于无其他线程所以只是测试用，无实际意义）

看一下lab3中的`alloc_page`。

```c
// pmm.c
// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page* alloc_pages(size_t n) {
    struct Page* page = NULL;
    bool intr_flag;

    while (1) {
        // 下面第一和第三行是同步用的
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0)
            break;
		
        // 当开启了页换入换出机制并且没有通过alloc_pages拿到所需的物理内存则会调用swap_out进行页的换出
        extern struct mm_struct* check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
```

## 一些改进思路

我们观察一下现在的`Page`结构：

```c
// memlayout.h
/* *
 * struct Page - Page descriptor structures. Each Page describes one
 * physical page. In kern/mm/pmm.h, you can find lots of useful functions
 * that convert Page to other data types, such as phyical address.
 * */
struct Page {
    int ref;                        // page frame's reference counter
    uint32_t flags;                 // array of flags that describe the status of the page frame
    unsigned int property;          // the num of free block, used in first fit pm manager
    list_entry_t page_link;         // free list link
    // 链表节点
    list_entry_t pra_page_link;     // used for pra (page replace algorithm)
    // 这个物理页对应的虚拟页的起始地址
    uintptr_t pra_vaddr;            // used for pra (page replace algorithm)
};
```

不难发现，`Page`结构中两个链表`page_link`和`pra_page_link`其实并不合理，因为一个页不会同时为空闲页和置换页，因此可以试着用一个链表，但是具体的实现我还没有什么思路。


*源码链接：https://github.com/Donnykk/OS_Lab*