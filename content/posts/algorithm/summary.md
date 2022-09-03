---
title: "算法解法总结"
date: 2022-08-14T11:12:13+08:00
draft: true
tags: ["算法"]
categories: ["算法"]
typora-root-url: ..\..\static
---



[分类总结](前端该如何准备数据结构和算法？)

## 双指针

数组和链表算法主要都是使用双指针，双指针分为两类：

### 左右指针

两个指针相向而行或相背而行。

使用场景：

1. 二分查找
2. 两数之和
3. 反转数组
4. 回文判断

### 快慢指针

两个指针同向而行，一快一慢。

使用场景：

1. 涉及到第n个
2. 涉及到原地修改的，例如数组去重，数组移除元素
3. 滑动窗口算法
4. 二分查找
5. 两数之和



## 二叉树

**二叉树的所有问题，就是让你在前中后序位置注入逻辑代码。**

解题思路：

**1、是否可以通过遍历一遍二叉树得到答案**？如果可以，用一个 `traverse` 函数配合外部变量来实现。

**2、是否可以定义一个递归函数，通过子问题（子树）的答案推导出原问题的答案**？如果可以，写出这个递归函数的定义，并充分利用这个函数的返回值。

**3、无论使用哪一种思维模式，你都要明白二叉树的每一个节点需要做什么，需要在什么时候（前中后序）做**

### 四种遍历方式

### 前序遍历

根结点 ---> 左节点 ---> 右节点

```typescript
// 遍历写法
var preorderTraversal = function (root) {
  const traversal = (node, res) => {
    if (!node) return
    res.push(node.val) //根节点
    traversal(node.left, res) //左节点
    traversal(node.right, res) //右节点
  }
  const res = []
  traversal(root, res)
  return res
};

// 递归写法
var preorderTraversal = function (root) {
  const res = []
  if (!root) {
    return res
  }
  res.push(root.val)
  res.push(...preorderTraversal(root.left))
  res.push(...preorderTraversal(root.right))
  return res
};
```

### 中序遍历

左子树---> 根结点 ---> 右子树

```typescript
var inorderTraversal = function (root) {
  const traversal = (node, res) => {
    if (!node) return
    traversal(node.left, res) //左节点
    res.push(node.val) //根节点
    traversal(node.right, res) //右节点
  }
  const res = []
  traversal(root, res)
  return res
};
```

### 后序遍历

左子树 ---> 右子树 ---> 根结点

```typescript
var postorderTraversal = function (root) {
  const traversal = (node, res) => {
    if (!node) return
    traversal(node.left, res) //左节点
    traversal(node.right, res) //右节点
    res.push(node.val) //根节点
  }
  const res = []
  traversal(root, res)
  return res
};
```

### 层序遍历

从上到下，从左到右访问。

```javascript
var levelOrder = function (root) {
  if (!root) return []
  var res = []
  helper(root, 0)
  function helper(node, level) {
    if (!node) return
    if (!res[level]) {
      res[level] = [node.val]
    } else {
      res[level].push(node.val)
    }
    var left = node.left
    var right = node.right
    helper(left, level + 1)
    helper(right, level + 1)
  }
  return res
};
```



**前序位置的代码只能从函数参数中获取父节点传递来的数据，而后序位置的代码不仅可以获取参数数据，还可以获取到子树通过函数返回值传递回来的数据**。**一旦你发现题目和子树有关，那大概率要给函数设置合理的定义和返回值，在后序位置写代码了**。



## 动态规划

**动态规划问题的一般形式就是求最值**，穷举，然后减少重复的计算。

类型：

自顶向下：从一个规模较大的原问题比如说 `f(20)`，向下逐渐分解规模，直到 `f(1)` 和 `f(2)` 这两个 base case，然后逐层返回答案，这就叫「自顶向下」。

自底向上：已知结果的 `f(1)` 和 `f(2)`（base case）开始往上推，直到推到我们想要的答案 `f(20)`。

解题思路：

1. 确定base case
2. 确定状态
3. 确定选择
4. 明确dp函数/数组的定义



## 回溯（DFS）

回溯算法就是多叉树的遍历问题。

回溯算法和 DFS 算法的细微差别是：**回溯算法是在遍历「树枝」，DFS 算法是在遍历「节点」**

解题思路：

1. 路径
2. 选择列表
3. 结束条件

```javascript
def backtrack(...):
    for 选择 in 选择列表:
        做选择
        backtrack(...)
        撤销选择
```

使用场景：

1. 排列/组合/子集



## BFS

本质上就是一幅「图」，让你从一个起点，走到终点，问最短路径

### BFS 相对 DFS 区别：

**方式：**

DFS是深度遍历，通过递归，遍历所有路径才能找到。

BFS是广度遍历，通过队列，遍历当前路径。不满足条件，才会进行下一层路径遍历，所以BFS 找到的路径一定是最短的。

**空间复杂度：**

DFS是递归堆栈，最坏情况就是树的高度，也就是 `O(logN)`，空间复杂度低。

BFS是队列，队列中需要存储一层的所有节点，也就是 `O(N)`，空间复杂度高。

### 使用场景

找最短路径

解题思路：

```
// 计算从起点 start 到终点 target 的最近距离
int BFS(Node start, Node target) {
    Queue<Node> q; // 核心数据结构
    Set<Node> visited; // 避免走回头路
    q.push(start); // 将起点加入队列
    visited.add(start);
    int step = 0; // 记录扩散的步数

    while (q not empty) {
        int sz = q.size();
        /* 将当前队列中的所有节点向四周扩散 */
        for (int i = 0; i < sz; i++) {
            Node cur = q.poll();
            /* 划重点：这里判断是否到达终点 */
            if (cur is target)
                return step;
            /* 将 cur 的相邻节点加入队列 */
            for (Node x : cur.adj()) {
                if (x not in visited) {
                    q.offer(x);
                    visited.add(x);
                }
            }
        }
        /* 划重点：更新步数在这里 */
        step++;
    }
}
```

### 双向BFS优化

**原理**

传统的 BFS 框架就是从起点开始向四周扩散，遇到终点时停止；而双向 BFS 则是从起点和终点同时开始扩散，当两边有交集的时候停止。按照传统 BFS 算法的策略，会把整棵树的节点都搜索一遍，最后找到 `target`；而双向 BFS 其实只遍历了半棵树就出现了交集，也就是找到了最短距离。

**局限**

必须知道终点在哪里。



## 二分查找



思路

```
int binarySearch(int[] nums, int target) {
    int left = 0, right = ...;

    while(...) {
        int mid = left + (right - left) / 2;
        if (nums[mid] == target) {
            ...
        } else if (nums[mid] < target) {
            left = ...
        } else if (nums[mid] > target) {
            right = ...
        }
    }
    return ...;
}
```



## 滑动窗口

定义左右指针。先移动右指针，每当满足收缩条件时，就移动左指针，直到不满足条件后，再重新开始移动右指针。

使用场景：

- 查找子串

思路

```javascript
let findAnagrams = function (s) {
  let left = 0, right = 0;
  while (right < s.length) {
     // 将要移入窗口的字符
    const rightChar = s[right]
    //扩大窗口
    right++
    // 进行窗口内数据更新
    // ....  
    // 判断左侧窗口是否需要收缩
    while (condition) {
      // 将要移出的字符
      const leftChar = s[left]
      // 缩小窗口
      left++
      // 进行窗口内数据更新
     
    }
  }
};
```



## 动态规划

把原始问题分化成一系列子问题，由以求出的局部最优解来推导全局最优解。

