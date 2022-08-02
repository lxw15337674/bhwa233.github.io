---
title: "柯里化"
date: 2022-08-01T19:52:09+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 概念
判断当前传入函数的参数个数 (args.length) 是否大于等于原函数所需参数个数 (fn.length) ，如果是，则执行当前函数；如果是小于，则返回一个函数。

例如：实现`add(1)(2)(3)`

## 思路
- 判断传递的参数是否达到执行函数的fn个数
- 没有达到的话，继续返回新的函数，并且返回curry函数传递剩余参数

## 主要作用
参数复用、提前返回和 延迟执行

参数复用：只要传入一个参数 z，执行，计算结果就是 1 + 2 + z 的结果，1 和 2 这两个参数就直接可以复用了。

提前返回 和 延迟执行：因为每次调用函数时，它只接受一部分参数，并返回一个函数（提前返回），直到(延迟执行)传递所有参数为止。


## 实现

### 第一版
```javascript
function curry(fn){
    let argsList = []
     function curried(...args){
        argsList.push(...args)
        if(argsList.length>=fn.length){
            return fn(...argsList)
        }else{
            return (...args2)=>{
                return curried(...args2)
            }
        }
    }
    return curried
}


const add = curry((a, b, c) => {
    console.log(a, b, c)
})
add(1)(2)(3)

```
### 第二版
```javascript
function curry(fn){
     function curried(...args){
        if(args.length>=fn.length){
            return fn(...args)
        }else{
            return (...args2)=>{
                return curried(...args,...args2)
            }
        }
    }
    return curried
}


const add = curry((a, b, c) => {
    console.log(a, b, c)
})
add(1)(2)(3)
```
### 第三版
```javascript
function curry(fn){
     function curried(...args){
        return args.length>=fn.length?fn(...args):(...args2)=> curried(...args,...args2)
    }
    return curried
}


const add = curry((a, b, c) => {
    console.log(a, b, c)
})
add(1)(2)(3)

```
### 第四版
```javascript
let currying = (fn, ...args) =>
    fn.length > args.length ?
        (...arguments) => currying(fn, ...args, ...arguments) :
        fn(...args)
        
const add = curry((a, b, c) => {
    console.log(a, b, c)
})
add(1)(2)(3)

```

## 参考
https://juejin.im/post/6855129007852093453#heading-5