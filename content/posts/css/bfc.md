---
title: "BFC"
date: 2022-07-31T14:53:23+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 一句话总结

BFC 就相当于一个隔离的独立容器，内部的元素与外界的元素互不干扰。

## 前置知识

### 常见定位方案

- 普通流 (normal flow)

> 在普通流中，元素按照其在 HTML 中的先后位置至上而下布局，在这个过程中，行内元素水平排列，直到当行被占满然后换行，块级元素则会被渲染为完整的一个新行，除非另外指定，否则所有元素默认都是普通流定位，也可以说，普通流中元素的位置由该元素在 HTML 文档中的位置决定。

- 浮动 (float)

> 在浮动布局中，元素首先按照普通流的位置出现，然后根据浮动的方向尽可能的向左边或右边偏移。

- 绝对定位 (absolute positioning)

> 在绝对定位布局中，元素会整体脱离普通流，因此绝对定位元素不会对其兄弟元素造成影响，而元素具体的位置由绝对定位的坐标决定。



## 概念

BFC，也就是块格式化上下文（Block Formatting Context）它属于上述定位方案的普通流，BFC 就相当于一个隔离的独立容器，内部的元素与外界的元素互不干扰。它不会影响外部的布局，外部的布局也不会影响到它。

## 形成条件

- float为 `left|right`
- overflow为 `hidden|auto|scroll`
- display为 `table-cell|table-caption|inline-block|inline-flex|flex`
- position为 `absolute|fixed`
- 根元素

## BFC布局规则

- 内部的Box会在垂直方向，一个接一个地放置(即块级元素独占一行)。
- BFC的区域不会与float box重叠(**利用这点可以实现自适应两栏布局**)。
- 内部的Box垂直方向的距离由margin决定。属于同一个BFC的两个相邻Box的margin会发生重叠(**margin重叠三个条件:同属于一个BFC;相邻;块级元素**)。
- 计算BFC的高度时，浮动元素也参与计算。（清除浮动 haslayout）
- BFC就是页面上的一个隔离的独立容器，容器里面的子元素不会影响到外面的元素。反之也如此。

## 特性

- 内部的盒子会在垂直方向上一个接一个的放置
- 对于同一个 BFC 的俩个相邻的盒子的 margin 会发生重叠，与方向无关。
- 每个元素的左外边距与包含块的左边界相接触（从左到右），即使浮动元素也是如此
- BFC 的区域不会与 float 的元素区域重叠
- 计算 BFC 的高度时，浮动子元素也参与计算
- BFC 就是页面上的一个隔离的独立容器，容器里面的子元素不会影响到外面的元素，反之亦然

## 使用场景

- 解决边距重叠问题
- BFC 不与 float 元素重叠
- 清除浮动（父级元素会计算浮动元素的高度）

## 应用场景

- 清除浮动：BFC 内部的浮动元素会参与高度计算，因此可用于清除浮动，防止高度塌陷
- 避免某元素被浮动元素覆盖：BFC 的区域不会与浮动元素的区域重叠
- 阻止外边距重叠：属于同一个 BFC 的两个相邻 Box 的 margin 会发生折叠，不同 BFC 不会发生折叠





> 参考资料
>
> https://github.com/ljianshu/Blog/issues/15
>
> https://juejin.cn/post/6844903495108132877
>
> https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Block_formatting_context



