---
title: "箭头函数"
date: 2022-07-31T15:45:06+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 箭头函数跟普通函数的区别

- 箭头函数没有 this。
  - 函数不会创建自己的 this，它只会从自己的作用域链的上一层继承 this
  - 通过 call 或 apply 调用不会改变 this 指向。
  - 箭头函数不能用作构造器，和 new一起用会抛出错误。
  - 所以箭头函数不适合做方法函数。

- 不能用作构造函数，这就是说不能够使用new命令，否则会抛出一个错误。因为箭头函数没有`prototype`指向原型，所以不能作为构造函数。
- 不能使用arguments对象。
- 没有自己的 super 或 new.target。
  - super 关键字用于访问和调用一个对象的父对象上的函数。
  - new.target 属性允许你检测函数或构造方法是否是通过 new 运算符被调用的
- 不可以使用yield命令，因此箭头函数不能用作Generator函数