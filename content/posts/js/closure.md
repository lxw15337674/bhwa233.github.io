---
title: "闭包"
date: 2022-08-02T23:47:44+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 概念

**函数中的函数**，闭包是指引用了外部函数作用域变量的函数，

可以粗暴的理解为：相当于将外部变量保留下来，就是一个独立的作用域，外部不可见，作为自己函数使用。

## 例子

```
function a(){
	var b = 1;
	var c = 2;
	// 这个函数就是个闭包，可以访问外层 a 函数的变量
	return function(){
		var d = 3;
		return b + c + d;
	}
}
var e = a();
console.log(e());
```

因此，使用闭包可以隐藏变量以及防止变量被篡改和作用域的污染，从而实现封装。
而缺点就是由于保留了作用域链，会增加内存的开销。因此需要注意内存的使用，并且防止内存泄露的问题。

## 形成条件

1. 函数嵌套
2. 内部函数引用外部函数的局部变量

## 为什么使用闭包

确保函数能够访问其定义时的环境中变量。

如果不使用闭包，使用其他变量：

全局变量：可以重用、但是会造成全局污染而且容易被篡改。

局部变量：仅函数内使用不会造成全局污染也不会被篡改、不可以重用。

## 产生原因

闭包产生的本质就是，当前环境中存在指向父级作用域的引用。

```
function f1() {
  var a = 2
  function f2() {
    console.log(a);//2
  } 
  return f2;
}
var x = f1();
x();
```
## 缺点

1. 引起内存泄漏。
2. 闭包的this指向的是window。


## 作用
- 缓存变量
- 避免全局污染

## 应用场景

1. setTimeout 传参。

2. 防抖、节流

3. 返回一个函数。

4. 作为函数参数传递。

5. 定时器、时间监听等，只要使用了回调函数，就是使用闭包

6. IIFE(立即执行函数表达式)创建闭包, 保存了全局作用域window和当前函数的作用域，因此可以全局的变量。

   ```javascript
     var arr = [];
       for (var i=0;i<3;i++){
         //使用IIFE
         (function (i) {
           arr[i] = function () {
             return i;
           };
         })(i);
       }
       console.log(arr[0]()) // 0
       console.log(arr[1]()) // 1
       console.log(arr[2]()) // 2
   ```

   



## 详解

https://juejin.im/post/5dac5d82e51d45249850cd20#heading-23

https://github.com/ljianshu/Blog/issues/6