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

正常两棵树完全比对的算法复杂度是O(n 3 )。这个开销太过高昂。为了降低算法复杂度，`React`的`diff`做了一些优化：

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