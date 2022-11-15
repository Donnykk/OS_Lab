# Lab2实验报告

**一、实验目的**

* 理解基于段页式内存地址的转换机制
* 理解页表的建立和使用方法
* 理解物理内存的管理方法

**二、实验过程**

*问题1：*

在ex1中`default_free_pages`部分，需要释放`base`地址开始的连续n个物理页，需要考虑合并的问题。首先遍历`free_list`看能不能合并，可以合并就进行合并，得到一块大的空闲块（如果有合并的话）。之后再遍历一次将这一块插入正确的位置。

一开始我实现的代码始终无法正确释放，代码如下：
```c
static void default_free_pages(struct Page* base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t* le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        le = list_next(le);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        } else if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list){
        p = le2page(le, page_link);
        if (base + base->property < p){
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
}
```
以上代码实现了将空闲块的按序插入，即插入按地址排列后的位置，但是在合并的第一种情况中并没有清空`p->property`，合并的第二种情况中并没有清`base->property`，只清空了`base->eflags`中的`PG_property`。

改进后的代码如下所示：

```c
static void
default_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++)
    {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list)
    {
        p = le2page(le, page_link);
        le = list_next(le);
        if (base + base->property == p)
        {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base)
        {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    le = &free_list;
    while ((le = list_next(le)) != &free_list)
    {
        p = le2page(le, page_link);
        if (base + base->property <= p)
        {
            break;
        }
    }
    nr_free += n;
    list_add_before(le, &(base->page_link));
}
```

*问题2：*

在实现challenge1的过程中遇到了很多问题和困惑，我起初对照的实验指导书中的代码写，发现有一些问题，主要在于：

* 管理物理页要占内存，内核栈大小有限，要把管理物理页占的内存也移到物理页中，余下内存再参与分配。
* 物理内存的页数并不是2的幂次，ucore中实际可用的物理内存是32292个页，而buddy system对于物理内存的管理要求单位块的数量是2的幂次。

对于第二点，我采取的就是简单的向上取整，少的内存初始化时就标记为空。最后`buddy_init_memmap`函数实现如下所示：
```c
static void
buddy_init_memmap(struct Page *base, size_t n)
{
    struct Page *p;
    for (p = base; p != base + n; p++)
    {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
    }
    manager_size = 2 * (1 << get_proper_size(n));
    // 获取 buddy_manager 的起始地址 预留base最开始的部分给 buddy_manager
    buddy_manager = (unsigned *)page2kva(base);
    base += 4 * manager_size / 4096;
    // page_base 用来在后续申请和释放内存的时候提供可用内存空间的起始地址
    page_base = base;
    // 剩余可用页数
    free_page_num = n - 4 * manager_size / 4096;
    unsigned i = 1;
    unsigned node_size = manager_size / 2;
    for (; i < manager_size; i++)
    {
        buddy_manager[i] = node_size;
        if (IS_POWER_OF_2(i + 1))
        {
            node_size /= 2;
        }
    }
    base->property = free_page_num;
    SetPageProperty(base);
}
```
*源码链接：https://github.com/Donnykk/OS_Lab*