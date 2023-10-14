---
title: "this指向问题"
date: 2022-09-03T16:15:11+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 总结

this始终指向调用它的那个对象。

场景：

- 给元素的某个行为绑定方法，当事件行为触发，方法中的this是元素本身。
- 构造函数体中的this是当前类的实例。
- 普通函数，指向方法体。
- new函数的指向当前类 
- 箭头函数，没有执行主体，所以始终指向上级的上下文

可以基于call、apply、bind改变this指向。


## 面试题


```javascript
var num = 10
const obj = { num: 20 }
obj.fn = (function (num) {
  this.num = num * 3
  num++
  return function (n) {
    this.num += n
    num++
    console.log(num)
  }
})(obj.num)
var fn = obj.fn // 因为自执行函数，相当于window.obj.fn(obj.num)，此时fn中this指向global,global.num=60+5=65，num是obj.num = 20+1=21
fn(5) // 执行内部函数,this指向global,this.num=60+5=65，num是obj.num = 20+1+1 ,所以输出22
obj.fn(10) // 直接调用obj.fn，this指向obj,this.num = 30,则obj num为初始的22,num=num+1 = 23
console.log(num, obj.num) //65 30

```



```javascript
var num = 1;
let obj = {
    num: 2,
    add: function() {
        this.num = 3;
        // 这里的立即指向函数，因为我们没有手动去指定它的this指向，所以都会指向window
        (function() {
            // 所有这个 this.num 就等于 window.num
            console.log(this.num);
            this.num = 4;
        })();
        console.log(this.num);
    },
    sub: function() {
        console.log(this.num)
    }
}
// 下面逐行说明打印的内容

/**
 * 在通过obj.add 调用add 函数时，函数的this指向的是obj,这时候第一个this.num=3
 * 相当于 obj.num = 3 但是里面的立即指向函数this依然是window,
 * 所以 立即执行函数里面console.log(this.num)输出1，同时 window.num = 4
 *立即执行函数之后，再输出`this.num`,这时候`this`是`obj`,所以输出3
 */ 
obj.add() // 输出 1 3

// 通过上面`obj.add`的执行，obj.name 已经变成了3
console.log(obj.num) // 输出3
// 这个num是 window.num
console.log(num) // 输出4
// 如果将obj.sub 赋值给一个新的变量，那么这个函数的作用域将会变成新变量的作用域
const sub = obj.sub
// 作用域变成了window window.num 是 4
sub() // 输出4

```



## 参考

https://segmentfault.com/a/1190000006731988  
https://juejin.im/post/59bfe84351882531b730bac2
[JavaScript 的 this 原理](http://www.ruanyifeng.com/blog/2018/06/javascript-this.html)