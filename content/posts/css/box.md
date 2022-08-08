---
title: "元素"
date: 2022-08-08T15:37:13+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



## box-sizing

通过box-sizing这个属性来设置元素的盒模型
- box-sizing：content-box 为标准盒模型（默认）
- box-sizing：border-box 为IE怪异盒模型
    - padding 内边距
    - border 边框
    - margin 外边距
## 标准盒模型
元素的 width、height 只包含内容 content，不包含 border 和 padding 值；

![image-20220808154713338](/../../static/images/image-20220808154713338.png)

## IE盒模型
元素的 width、height 包括 content、 border、 padding，不包含margin。

![image-20220808154728166](/../../static/images/image-20220808154728166.png)

## 块模型的大小
块的大小包含context、border、padding、margin
### 详解 
https://segmentfault.com/a/1190000014692461