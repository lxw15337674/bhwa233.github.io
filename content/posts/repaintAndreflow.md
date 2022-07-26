---
title: "重绘和回流（Repaint & Reflow）"
date: 2022-07-26T23:29:34+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 重绘

DOM样式发生了变化，而不会影响布局时会触发重绘，而不会触发回流。重绘由于DOM位置信息不需要更新，省去了布局过程，因而性能上优于回流

## 回流

当DOM布局改变时，就需要重新计算渲染树，这就是回流。

- DOM元素的几何属性(width/height/padding/margin/border)发生变化时会触发回流
- DOM元素移动或增加会触发回流
- 读写offset/scroll/client等属性时会触发回流
- 调用window.getComputedStyle会触发回流

### 浏览器优化

**1. 减少获取布局信息**

现代浏览器大多都是通过队列机制来批量更新布局，浏览器会把修改操作放在队列中，至少一个浏览器刷新（即16.6ms）才会清空队列，但当你获取布局信息的时候，队列中可能有会影响这些属性或方法返回值的操作，即使没有，浏览器也会强制清空队列，触发回流与重绘来确保返回正确的值。

主要包括以下属性或方法：

- `offsetTop`、`offsetLeft`、`offsetWidth`、`offsetHeight`
- `scrollTop`、`scrollLeft`、`scrollWidth`、`scrollHeight`
- `clientTop`、`clientLeft`、`clientWidth`、`clientHeight`
- `width`、`height`
- `getComputedStyle()`
- `getBoundingClientRect()`

所以，我们应该避免频繁的使用上述的属性，他们都会强制渲染刷新队列。

**2. 减少重绘与回流**

- 使用 `transform` 替代 `top`

- 使用 `visibility` 替换 `display: none` ，因为前者只会引起重绘，后者会引发回流（改变了布局）

- **不要把节点的属性值放在一个循环里当成循环里的变量。**

  ```
  for(let i = 0; i < 1000; i++) {
      // 获取 offsetTop 会导致回流，因为需要去获取正确的值
      console.log(document.querySelector('.test').style.offsetTop)
  }
  ```

- **不要使用 table 布局**，可能很小的一个小改动会造成整个 table 的重新布局

- 动画实现的速度的选择，动画速度越快，回流次数越多，也可以选择使用 **requestAnimationFrame**

- CSS 选择符从右往左匹配查找，避免节点层级过多

- **将频繁重绘或者回流的节点设置为图层**，图层能够阻止该节点的渲染行为影响别的节点，例如`will-change`、`video`、`iframe`等标签，浏览器会自动将该节点变为图层。

- **对具有复杂动画的元素使用绝对定位**，使它脱离文档流，否则会引起父元素及后续元素频繁回流。

- **CSS3 硬件加速（GPU加速）**，使用css3硬件加速，可以让`transform`、`opacity`、`filters`这些动画不会引起回流重绘 。但是对于动画的其它属性，比如`background-color`这些，还是会引起回流重绘的，不过它还是可以提升这些动画的性能。

**JavaScript操作**

- **避免频繁操作样式**，最好一次性重写`style`属性，或者将样式列表定义为`class`并一次性更改`class`属性。
- **避免频繁操作`DOM`**，创建一个`documentFragment`，在它上面应用所有`DOM操作`，最后再把它添加到文档中。
- **避免频繁读取会引发回流/重绘的属性**，如果确实需要多次使用，就用一个变量缓存起来。
- **对具有复杂动画的元素使用绝对定位**，使它脱离文档流，否则会引起父元素及后续元素频繁回流。

## 合成

利用 CSS3 的transform、opacity、filter这些属性就可以实现合成的效果，也就是大家常说的GPU加速。

#### GPU加速的原因

在合成的情况下，会直接跳过布局和绘制流程，直接进入非主线程处理的部分，即直接交给合成线程处理。交给它处理有两大好处:

1. 能够充分发挥GPU的优势。合成线程生成位图的过程中会调用线程池，并在其中使用GPU进行加速生成，而GPU 是擅长处理位图数据的。
2. 没有占用主线程的资源，即使主线程卡住了，效果依然能够流畅地展示。

#### 实践意义

1. 避免频繁使用 style，而是采用修改class的方式。
2. 使用createDocumentFragment进行批量的 DOM 操作。
3. 对于 resize、scroll 等进行防抖/节流处理。
4. 添加 will-change: tranform ，让渲染引擎为其单独实现一个图层，当这些变换发生时，仅仅只是利用合成线程去处理这些变换，而不牵扯到主线程，大大提高渲染效率。当然这个变化不限于tranform, 任何可以实现合成效果的 CSS 属性都能用will-change来声明。



> 参考：
>
> https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/24