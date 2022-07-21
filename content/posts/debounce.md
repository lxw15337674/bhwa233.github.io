---
title: "Debounce"
date: 2022-07-22T00:13:35+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 防抖(debounce)

作用：触发多次事件，只执行最后一次。
原理：通过setTimeout延迟执行事件，每次触发函数判断定时器是否存在，存在则重置。


应用场景：

1. 输入校验。
2. 拖动对话框。

## 节流(throttle)

作用：触发多次事件，一段时间内只执行第一次
原理：通过setTimeout延迟执行时间，每次触发函数判断定时器是否存在，存在则不执行

应用场景：

1. 监听滚动事件

   

### 防抖

http://jsrun.net/pT2Kp/edit

```
const debounce = function (func,wait = 50) {
    // 缓存一个定时器id
    let timer = null;
    // 这里返回的函数时每次用户实际调用的防抖函数
    // 如果已经设定过定时器了就清空上一次的定时器
    // 开始一个定时器，延迟执行用户传入的方法
    return function(...args){
        if(timer) clearTimeout(timer);
        timer = setTimeout(()=>{
            //将实际的this和参数传入用户实际调用的函数
            func.apply(this,args);
        },wait);
    }
};
```

### 节流

```
function throttle(fn, wait = 50) {
    let timer = null
    return function (...args) {
        if (timer) return
        setTimeout(() => {
            clearTimeout(timer)
            fn.call(this, ...args)
        }, wait);
    }
}
```

## 详解

https://github.com/ljianshu/Blog/issues/43