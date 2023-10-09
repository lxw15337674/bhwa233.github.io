---
title: "Fiber"
date: 2022-07-31T13:35:09+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

### 一句话总结

`React`内部实现的一套状态更新机制。将**同步的更新**变为**可中断的异步更新**。支持任务不同`优先级`，可中断与恢复，并且恢复后可以复用之前的`中间状态`。

> 旧的模式，用的vdom递归渲染也是可以中断的，但无法恢复，因为不知道父节点是哪个

### 背景

react-fiber 产生的根本原因，是大量的同步计算任务阻塞了浏览器的 UI 渲染。

在`React15`及以前，`Reconciler`采用递归的方式创建虚拟DOM，递归过程是不能中断的。如果组件树的层级很深，递归会占用线程很多时间，造成卡顿。

为了解决这个问题，react 16.18.0 版本引入 fiber 架构，实现异步可中断更新。先把 vdom 树转成 fiber 链表，然后再渲染 fiber。主要是解决之前由于直接递归遍历 vdom，不可中断，导致当 vdom 比较大的，频繁调用耗时 dom api 容易产生性能问题。

### 架构

react 16.18.0 版本引入 fiber 架构，实现异步可中断更新。先把 vdom 树转成 fiber 链表，然后再渲染 fiber。主要是解决之前由于直接递归遍历 vdom，不可中断，导致当 vdom 比较大的，频繁调用耗时 dom api 容易产生性能问题。

- Scheduler（调度器）—— 调度任务的优先级，高优任务优先进入**Reconciler**
- Reconciler（协调器）—— 负责找出变化的组件，负责调用组件生命周期方法，进行 Diff 运算等。
- Renderer（渲染器）—— 负责将变化的组件渲染到页面上，根据不同的平台，渲染出相应的页面，比较常见的是 ReactDOM 和 ReactNative。

  ![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/95e8824fc57f4f00a97df4672596a251%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

### 含义

1. 作为架构，之前`React15`的`Reconciler`采用递归的方式执行，数据保存在递归调用栈中，所以被称为`stack Reconciler`。`React16`的`Reconciler`基于`Fiber节点`实现，被称为`Fiber Reconciler`。
2. 作为静态的数据结构来说，每个`Fiber节点`对应一个`React element`，保存了该组件的类型（函数组件/类组件/原生组件...）、对应的DOM节点等信息。
3. 作为动态的工作单元来说，每个`Fiber节点`保存了本次更新中该组件改变的状态、要执行的工作（需要被删除/被插入页面中/被更新...）。

### 结构

```javascript
function FiberNode(
  tag: WorkTag,
  pendingProps: mixed,
  key: null | string,
  mode: TypeOfMode,
) {
  // 作为静态数据结构的属性
  this.tag = tag; // Fiber对应组件的类型 Function/Class/Host...
  this.key = key;// key属性
  this.elementType = null; // 大部分情况同type，某些情况不同，比如FunctionComponent使用React.memo包裹
  this.type = null; // 对于 FunctionComponent，指函数本身，对于ClassComponent，指class，对于HostComponent，指DOM节点tagName
  this.stateNode = null; // Fiber对应的真实DOM节点

  // 用于连接其他Fiber节点形成Fiber树
  this.return = null; // 指向父级Fiber节点
  this.child = null; // 指向子Fiber节点
  this.sibling = null;// 指向右边第一个兄弟Fiber节点
  this.index = 0;

  this.ref = null;

  // 作为动态的工作单元的属性
  // 保存本次更新造成的状态改变相关信息
  this.pendingProps = pendingProps;
  this.memoizedProps = null;
  this.updateQueue = null;
  this.memoizedState = null;
  this.dependencies = null;

  this.mode = mode;
// 保存本次更新会造成的DOM操作
  this.effectTag = NoEffect;
  this.nextEffect = null;

  this.firstEffect = null;
  this.lastEffect = null;

  // 调度优先级相关
  this.lanes = NoLanes;
  this.childLanes = NoLanes;

  // 指向该fiber在另一次更新时对应的fiber
  this.alternate = null;
}
```

### 工作原理

`React`使用“双缓存”来完成`Fiber树`的构建与替换——对应着`DOM树`的创建与更新。

在`React`中最多会同时存在两棵`Fiber树`。当前屏幕上显示内容对应的`Fiber树`称为`current Fiber树`，正在内存中构建的`Fiber树`称为`workInProgress Fiber树`。

> 双缓存
>
> 普通的构建渲染过程是先清除上一帧的画面，再渲染当前帧画面。但如果当前帧计算量大，会导致清除上一帧到绘制当前帧存在较长间隙，出现白屏。
>
> 解决的方法是使用双缓存，先在内存中计算完当前帧动画，再用当前帧替换上一帧画面。这样省去两帧替换间的计算时间，就不会出现白屏情况。
>
> 这种在内存中构建并直接替换的技术叫做双缓存。

总结：

- `Reconciler`工作的阶段被称为`render`阶段。因为在该阶段会调用组件的`render`方法。
- `Renderer`工作的阶段被称为`commit`阶段。就像你完成一个需求的编码后执行`git commit`提交代码。`commit`阶段会把`render`阶段提交的信息渲染在页面上。
- `render`与`commit`阶段统称为`work`，即`React`在工作中。相对应的，如果任务正在`Scheduler`内调度，就不属于`work`。



### JSX与Fiber节点

`JSX`是一种描述当前组件内容的数据结构，他不包含组件**schedule**、**reconcile**、**render**所需的相关信息。

比如如下信息就不包括在`JSX`中：

- 组件在更新中的`优先级`
- 组件的`state`
- 组件被打上的用于**Renderer**的`标记`

这些内容都包含在`Fiber节点`中。

所以，在组件`mount`时，`Reconciler`根据`JSX`描述的组件内容生成组件对应的`Fiber节点`。

在`update`时，`Reconciler`将`JSX`与`Fiber节点`保存的数据对比，生成组件对应的`Fiber节点`，并根据对比结果为`Fiber节点`打上`标记`。

## Fiber 的主要工作流程

1. `ReactDOM.render()` 引导 React 启动或调用 `setState()` 的时候开始创建或更新 Fiber 树。
2. 从根节点开始遍历 Fiber Node Tree， 并且构建 workInProgress Tree（reconciliation 阶段）。
   - 本阶段可以暂停、终止、和重启，会导致 react 相关生命周期重复执行。
   - React 会生成两棵树，一棵是代表当前状态的 current tree，一棵是待更新的 workInProgress tree。
   - 遍历 current tree，重用或更新 Fiber Node 到 workInProgress tree，workInProgress tree 完成后会替换 current tree。
   - 每更新一个节点，同时生成该节点对应的 Effect List。
   - 为每个节点创建更新任务。
3. 将创建的更新任务加入任务队列，等待调度。
   - 调度由 scheduler 模块完成，其核心职责是执行回调。
   - scheduler 模块实现了跨平台兼容的 requestIdleCallback。
   - 每处理完一个 Fiber Node 的更新，可以中断、挂起，或恢复。
4. 根据 Effect List 更新 DOM （commit 阶段）。
   - React 会遍历 Effect List 将所有变更一次性更新到 DOM 上。
   - 这一阶段的工作会导致用户可见的变化。因此该过程不可中断，必须一直执行直到更新完成。



>资料：
>
>[React技术揭秘](https://react.iamkasong.com/)
>
>
>
>https://zhuanlan.zhihu.com/p/424967867

