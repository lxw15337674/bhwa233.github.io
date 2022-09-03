---
title: "js的异步"
date: 2022-07-26T22:26:21+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

js是单线程语言，一次只能进行一个任务。js通过事件循环来解决异步任务。

#### 1. 回调函数（callback）

```javascript
setTimeout(() => {
   callback()
}, 1000)
```

**缺点：回调地狱，不能用 try catch 捕获错误，不能 return**

回调地狱的根本问题在于：

- 缺乏顺序性： 回调地狱导致的调试困难，和大脑的思维方式不符
- 嵌套函数存在耦合性，一旦有所改动，就会牵一发而动全身，即（**控制反转**）
- 嵌套函数过多的多话，很难处理错误

```javascript
ajax('XXX1', () => {
    callback()
    ajax('XXX2', () => {
         callback()
        ajax('XXX3', () => {
             callback()
        })
    })
})
```

**优点：解决了同步的问题**（只要有一个任务耗时很长，后面的任务都必须排队等着，会拖延整个程序的执行。）

#### 2. Promise

Promise 实现了链式调用，每次 then 后返回的都是一个全新 Promise，如果我们在 then 中 return ，return 的结果会被 Promise.resolve() 包装传给后面的promise。

**优点：解决了回调地狱的问题**

```javascript
ajax('XXX1')
  .then(res => {
      // 操作逻辑
      return ajax('XXX2')
  }).then(res => {
      // 操作逻辑
      return ajax('XXX3')
  }).then(res => {
      // 操作逻辑
  })
```

**缺点：**

1. 无法取消 Promise 。
2. 错误需要通过回调函数来捕获。
3. promise处于pending状态时，无法得知目前进展到哪一阶段，刚开始执行还是即将完成

#### 3. Async/await

async、await 是异步的终极解决方案。`await` 内部实现了 `generator`，其实 `await` 就是 `generator` 加上 `Promise`的语法糖，且内部实现了自动执行 `generator`。

优点：代码清晰，不用像 Promise 写一大堆 then 链，处理了回调地狱的问题

缺点：可以用try catch 捕获异常，将异步代码改造成同步代码，如果多个异步操作没有依赖性而使用 await 会导致性能上的降低。

```javascript
async function test() {
  // 以下代码没有依赖性的话，完全可以使用 Promise.all 的方式
  // 如果有依赖性的话，其实就是解决回调地狱的例子了
  await fetch('XXX1')
  await fetch('XXX2')
  await fetch('XXX3')
}
```

