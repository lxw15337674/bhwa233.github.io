---
title: "Call、apply、bind"
date: 2022-07-31T15:31:55+08:00
draft: false
tags: ["javascript"]
categories: ["javascript"]
typora-root-url: ..\..\static
---

## call

> 更改 this 指向，第一个参数作为函数的 this 指向，其余参数作为函数的参数，执行参数。
> `object.call(obj,arg1,arg2,...)`

### 基本思路

1. 将函数作为对象的属性
2. 执行函数
3. 删除函数

### 实现

在线：http://jsrun.net/9V2Kp/

```javascript
Function.prototype.myCall= function(obj,...args){
        const fn = Symbol('fn')        // 声明一个独有的Symbol属性, 防止fn覆盖已有属性
        obj = obj||window //  若没传入，则默认绑定window对象
        obj[fn] = this
        let result = obj[fn](...args)
        delete obj[fn]
        return result
    }
```

## apply

> 第一个参数作为 this 指向，第二个参数为数组提供函数的参数，执行函数。
> `object.apply(obj,[arg1,arg2,...])`

### 与 call区别

- call()接收参数列表，而 apply()接收一个参数数组

- call()性能优于apply，因为apply多了第二个参数解构的操作。

### 实现

```javascript
  Function.prototype.myCall= function(obj,args){
        const fn = Symbol('fn')        // 声明一个独有的Symbol属性, 防止fn覆盖已有属性
        obj = obj||window //  若没传入，则默认绑定window对象
        obj[fn] = this
        let result = obj[fn](...args)
        delete obj.fn
        return result
    }
```

## bind

> 第一个参数作为 this 指向，其余参数作为新函数的参数，返回函数。
> `object.apply(obj,args1,args2)`

### 与 call()区别

- 不执行参数，返回参数。

### 实现思路

#### 第一版

```javascript
Function.prototype.myBind= function(obj,...args){
        let fn=() =>{
            this.call(obj,...args)
        }
        return fn
    }
```

存在问题：
bind 还有一个特点： new 会改变 this 指向，如果 bind 绑定后的函数被 new 了，那么 this 指向会发生改变，指向当前函数的实例

#### 第二版

```javascript
Function.prototype.myBind= function(obj,...args){
        let fn=() =>{
            this.call(obj,...args)
        }
        fn.prototype= this.prototype
        return fn
    }
```



> 参考:
>
> https://segmentfault.com/a/1190000018017796