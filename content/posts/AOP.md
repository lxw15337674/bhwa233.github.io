---
title: "AOP思想"
date: 2022-09-04T14:52:22+08:00
draft: false
tags: [""]
categories: ["手撕代码","javascript"]
typora-root-url: ..\..\static
---

## 基本思想

面向切面编程，把一些跟核心业务逻辑无关的功能抽离出来，再通过动态组织的方式掺入业务逻辑模块中。


```javascript
let func = ()=>{
  //业务逻辑
  console.log('func');
}
func = func.before(()=>{
  console.log('before');
}).after(()=>{
  console.log('after');
})

func()
```



## 使用场景

通常包括日志统计、安全控制、异常处理等。



## 实现

```javascript
Function.prototype.before = function (callback) {
  if (typeof callback !== "function") throw new TypeError('callback must be function')
  let self = this;
  return function (...params) {
    callback.call(this, ...params)
    return self.call(this, ...params)
  }
}
Function.prototype.after = function (callback) {
  if (typeof callback !== "function") throw new TypeError('callback must be function')
  let self = this;
  return function (...params) {
    let res = self.call(this, ...params)
    callback.call(this, ...params)
    return res
  }
}

let func = () => {
  //业务逻辑
  console.log('func');
}
func = func.before(() => {
  console.log('before');
}).after(() => {
  console.log('after');
})


func()
```

