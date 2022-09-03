---
title: "关于元素隐藏"
date: 2022-07-25T23:56:58+08:00
draft: false
tags: ["css"]
categories: [""]
typora-root-url: ..\..\static
---

常用的隐藏方法：

1. `opacity ：0`
2. `display :none`
3. `visibility :hidden`
4. 设置 `fixed` 并设置足够大负距离的 `left` `top` 使其“隐藏”
5. 用层叠关系 `z-index` 把元素叠在最底下使其“隐藏”。

前三种方法的一些区别

|                    | [`opacity: 0`](https://developer.mozilla.org/en-US/docs/Web/CSS/opacity) | [`visibility: hidden;`](https://developer.mozilla.org/en-US/docs/Web/CSS/visibility) | [`display: none`](https://developer.mozilla.org/en-US/docs/Web/CSS/display) |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 占据页面空间       | 是                                                           | 是                                                           | 否                                                           |
| 事件监听           | 是                                                           | 否                                                           | 否                                                           |
| 性能               | 提升为合成层，不会触发重绘，性能最好                         | 引起重绘，性能较好                                           | 引起回流，性能差                                             |
| 子元素是否会显示   | 非继承属性，子元素无法设置可见。                             | 继承属性，通过设置visibility: visible;可以让子孙节点显示。   | 非继承属性，子元素无法设置可见。                             |
| 是否支持transition | 支持                                                         | 支持                                                         | 不支持                                                       |
| 场景               | 自定义图片上传按钮                                           | 显示不会导致页面结构发生变动，不会撑开                       | 显示出原来这里不存在的结构                                   |

