---
title: " Event Loop（js的事件循环机制）"
date: 2022-07-26T22:12:59+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 作用

解决单线程的js对异步任务的问题。

![mark](/images/68747470733a2f2f692e6c6f6c692e6e65742f323031392f30322f30382f356335643661353238626461662e6a7067)

## 机制

js中的**事件触发器**维护宏任务和微任务两个队列，微任务的优先级高于宏任务。
每次宏任务执行完后都会执行所有微任务，然后再执行下一个宏任务。



## 常见宏任务（macrotask）

- script(整体代码)
- setTimeout / setInterval
- setImmediate(Node.js 环境)
- I/O
- UI render
- postMessage
- MessageChannel

## 常见微任务（microtask）

- process.nextTick(Node.js 环境)
- Promise
- Async/Await
- MutationObserver（监视对DOM树所做更改）

## 关于process.nextTick的一点说明

process.nextTick 是一个独立于 eventLoop 的任务队列。

在每一个 eventLoop 阶段完成后会去检查这个队列，如果里面有任务，会让这部分任务优先于微任务执行。



## 引用

- [从一道题浅说 JavaScript 的事件循环](
  https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/7 )
- [浏览器与Node的事件循环(Event Loop)有何区别](https://github.com/ljianshu/Blog/issues/54)
- [微任务、宏任务与Event-Loop](https://juejin.im/post/6844903657264136200)

