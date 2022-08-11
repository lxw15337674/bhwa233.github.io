---
title: "闭包"
date: 2022-08-02T23:47:44+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---


![img](/images/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303430313233313932322e706e67)

## 概念

闭包是指可以访问另外一个函数作用域的变量的函数。

## 形成条件

1. 函数嵌套
2. 内部函数引用外部函数的局部变量

## 产生原因

在ES5中只存在两种作用域————全局作用域和函数作用域，当访问一个变量时，解释器会首先在当前作用域查找标示符，如果没有找到，就去父作用域找，直到找到该变量的标示符或者不在父作用域中，这就是作用域链，值得注意的是，每一个子函数都会拷贝上级的作用域，形成一个作用域的链条。   

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

## 表现形式
1. 返回一个函数。

2. 作为函数参数传递。

3. 定时器、时间监听等，只要使用了回调函数，就是使用闭包

4. IIFE(立即执行函数表达式)创建闭包, 保存了全局作用域window和当前函数的作用域，因此可以全局的变量。

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

## 详解

https://juejin.im/post/5dac5d82e51d45249850cd20#heading-23

https://github.com/ljianshu/Blog/issues/6