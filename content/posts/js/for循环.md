---
title: "js中三类For循环"
date: 2022-09-03T15:39:17+08:00
draft: false
tags: ["js"]
categories: ["js"]
typora-root-url: ..\..\static
---

## 总结

性能对比：

![image-20220903160124158](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/image-20220903160124158.png)



## for 与 while

- 基础 var 循环的时候，两者性能差不多

```php
let arr = new Array(9999999).fill(0);

console.time('for')
for(var i = 0; i < arr.length; i++) {}
console.timeEnd('for')  // for: 8.13818359375 ms

console.time('while')
var i = 0;
while(i < arr.length) {
  i++;
}
console.timeEnd('while') // while: 8.020751953125 ms
```

var 没有块级作用域概念，创建的变量是全局的。全局状态下 i 会占用一定的内存空间，不被释放的情况下，会一直占用空间

- 基于 let 循环的时候，for 循环性能更好

```php
let arr = new Array(9999999).fill(0);

console.time('for')
for(let i = 0; i < arr.length; i++) {}
console.timeEnd('for')  // for: 4.476806640625 ms

console.time('while')
let i = 0;
while(i < arr.length) {
  i++;
}
console.timeEnd('while') // while: 10.82080078125 ms
```

let 是块级作用域，i 属于当前循环中的变量。此次循环结束的时候，i 就被释放，不会占用空间

for 循环没有创造全局不释放的变量

while 循环只能放条件，此时 let 依然在全局作用域下。占用的空间未被释放，所以 while 比 for 性能慢一些

## forEach

- forEach 的性能，远远低于 for 与 while

```php
let arr = new Array(9999999).fill(0);

console.time('forEach')
arr.forEach(function(item){})
console.timeEnd('forEach')	//forEach: 63.18896484375 ms

```

forEach 会将结果帮我们封装起来，用起来很方便。然而 forEach 无法管控过程，性能上也有所消耗

### 手写forEach

```php
let a = [1,2,3]
let arr = new Array(a);

Array.prototype.forEach = function forEach(callback, context) {
  let self = this,
      i = 0,
      len = self.length;
      context = context == null ? window : context;
      for(; i < len; i++) {
        typeof callback === 'function' ? callback.call(context, self[i]) : null;
      }
}

console.time('forEach')
arr.forEach(function(item){
  console.log(item);          /// [1,2,3]
})
console.timeEnd('forEach')
```

## for in

迭代当前对象中所有可枚举的属性

```php
let arr = new Array(9999999).fill(0);
console.time('in')
for(let key in arr){}
console.timeEnd('in')   // in: 1654.09619140625 ms

```

### 缺点

- 性能很差，因为会迭代原型链上的属性。

- 遍历顺序以数字优先。

- 无法遍历 Symbol 属性

  > 解决办法：通过使用`Object.getOwnPropertySymbols(obj)`拿到Symbol的key

- 会遍历到原型链上可枚举的属性

  > 解决办法：可以使用`obj.hasOwnProperty()`。

```php
Object.prototype.fn = function fn() {};
let obj = {
  name: 'bhwa233',
  age: 18,
  [Symbol('AA')]: 100,
  1: 100,
  2: 200
}
for(let key in obj){
  // console.log(obj.hasOwnProperty(key)); 
  // hasOwnProperty()方法会返回一个布尔值,判断对象是否自身属性
  // if(!obj.hasOwnProperty(key)) break;  可解决第三个问题，fn不会被遍历出来
  console.log(key);     // 1 2 name age fn
}
```

## for of

of 循环的原理是按照迭代器规范遍历的。比 in 性能快很多，远远低于 for while

> 拥有**Symbol(Symbol.iterator)**属性的就可以实现迭代。
>
> 具备规范的数据类型：数组、Set、Map。

```php
let arr = new Array(9999999).fill(0);

console.time('of')
for(let val of arr){}
console.timeEnd('of') // of: 86.7080078125 ms
```



### **Symbol(Symbol.iterator)**

内部机制

```javascript
arr = [10, 20, 30]
arr[Symbol.iterator] = function () {
  let self = this, index = 0
  return {
    next() {
      if (index > self.length - 1) {
        return {
          done: true,
          value: undefined
        }
      }
      return {
        done: false,
        value: self[index++]
      }
    }
  }
}
let itor = arr[Symbol.iterator]()
console.log(itor.next());
```

