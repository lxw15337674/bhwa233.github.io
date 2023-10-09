---
title: "Diff算法"
date: 2022-07-31T14:11:32+08:00
draft: false
tags: ["react"]
categories: [""]
typora-root-url: ..\..\static
---

## 本质

diff本身就是上一帧的元素树与当前帧的元素树进行比对。

## react

正常两棵树完全比对的算法复杂度是O(n 3 )。

> 将两颗树中所有的节点一一对比需要O(n²)的复杂度，在对比过程中发现旧节点在新的树中未找到，那么就需要把旧节点删除，删除一棵树的一个节点(找到一个合适的节点放到被删除的位置)的时间复杂度为O(n),同理添加新节点的复杂度也是O(n),合起来diff两个树的复杂度就是O(n³)

这个开销太过高昂。为了降低算法复杂度，`React`的`diff`做了一些优化：

1. 只对同级元素进行`Diff`。如果一个`DOM节点`在更新中跨越了层级，那么`React`不会尝试复用他。
2. 如果元素不存在 `key prop`，两个不同类型的元素会产生出不同的树。如果元素由`div`变为`p`，React会销毁`div`及其子孙节点，并新建`p`及其子孙节点。
3. 可以通过 `key prop`来显式声明元素，帮助React识别是否可以复用。

```javascript
// 更新前
<div>
  <p key="ka">ka</p>
  <h3 key="song">song</h3>
</div>

// 更新后
<div>
  <h3 key="song">song</h3>
  <p key="ka">ka</p>
</div>
```

如果没有key，React会认为div的第一个子节点由p变为h3，第二个子节点由h3变为p。则执行2，会销毁并新建。

但是当我们用key指明了节点前后对应关系后，React知道key === "ka"的p在更新后还存在，所以DOM节点可以复用，只是需要交换下顺序。

```javascript
// 习题1 更新前
<div>ka song</div>
// 更新后
<p>ka song</p>

// 习题2 更新前
<div key="xxx">ka song</div>
// 更新后
<div key="ooo">ka song</div>

// 习题3 更新前
<div key="xxx">ka song</div>
// 更新后
<p key="ooo">ka song</p>

// 习题4 更新前
<div key="xxx">ka song</div>
// 更新后
<div key="xxx">xiao bei</div>

```

习题1: 未设置`key prop`默认 `key = null;`，所以更新前后key相同，都为`null`，但是更新前`type`为`div`，更新后为`p`，`type`改变则不能复用。

习题2: 更新前后`key`改变，不需要再判断`type`，不能复用。

习题3: 更新前后`key`改变，不需要再判断`type`，不能复用。

习题4: 更新前后`key`与`type`都未改变，可以复用。`children`变化，`DOM`的子元素需要更新。



## 对比

### 相同点

1. 虚拟DOM在比较时只比较同一层级节点，复杂度都为 O(n)，降低了算法复杂度；
2. 都使用key比较是否是相同节点，都是为了尽可能的复用节点
3. 都是操作虚拟DOM，最小化操作真实DOM，提高性能（其实虚拟DOM的优势 并不是在于它操作DOM快）
4. 都是不要用 index作为 key

## 区别

1. React 是从左向右遍历对比，Vue 是双端交叉对比。
2. React 需要维护三个变量（我看源码发现是五个变量），Vue 则需要维护四个变量。
3. Vue 整体效率比 React 更高，举例说明：假设有 N 个子节点，我们只是把最后子节点移到第一个，那么
   1. React 需要进行借助 Map 进行 key 搜索找到匹配项，然后复用节点
   2. Vue 会发现移动，直接复用节点



### 算法比对

vue的列表比对，采用从两端到中间的比对方式，而react则采用从左到右依次比对的方式。当一个集合，只是把最后一个节点移动到了第一个，react会把前面的节点依次移动，而vue只会把最后一个节点移动到第一个。总体上，vue的对比方式更高效。

vue比对节点，当节点元素类型相同，但是className不同，认为是不同类型元素，删除重建，而react会认为是同类型节点，只是修改节点属性

react只比较节点类型和key

```js
function sameVnode(vnode1: VNode, vnode2: VNode): boolean {
  return vnode1.key === vnode2.key && vnode1.sel === vnode2.sel;
}
```

vue比较节点类型和key，还有属性

```js
function sameVnode (a, b) {
  return (
    a.key === b.key &&  // key值
    a.tag === b.tag &&  // 标签名
    a.isComment === b.isComment &&  // 是否为注释节点
    // 是否都定义了data，data包含一些具体信息，例如onclick , style
    isDef(a.data) === isDef(b.data) &&  
    sameInputType(a, b) // 当标签是<input>的时候，type必须相同
  )
}
```

### diff算法遍历原理

1. React 首位是除删除外是固定不动的,然后依次遍历对比;
2. Vue 的compile 阶段的`optimize标记了static 点,可以减少 differ 次数`,而且是采用双向遍历方法;

### diff算法更新DOM逻辑

1. Vue基于snabbdom库，它有较好的速度以及模块机制。Vue Diff使用双向链表，边对比，边更新DOM。
2. React主要使用diff队列保存需要更新哪些DOM，得到patch树，再统一操作批量更新DOM。



> 资料
>
> [个人理解Vue和React区别](https://lq782655835.github.io/blogs/vue/diff-vue-vs-react.html#%E4%B8%AA%E4%BA%BA%E7%90%86%E8%A7%A3vue%E5%92%8Creact%E5%8C%BA%E5%88%AB)
>
> [React Diff 算法核心](https://xyy94813.gitbook.io/x-note/fe/react/react-diff-algorithm)