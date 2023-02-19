---
title: "判断数据类型"
date: 2022-07-19T19:39:22+08:00
draft: false
tags: [""]
categories: ["javascript"]
typora-root-url: ..\..\static
---

## 总结

- `Object.prototype.toString.call(obj)`最准确。
- typeof 只能检测基本数据类型。

>利用 `typeof` 来判断`number`, `string`, `object`, `boolean`, `function`, `undefined`, `symbol` 这七种类型
>
>null会判断为'object'，引用类型除了函数外其他都会被判断为'object'

- instanceOf 只能检测引用数据类型

### 总结

|                             | 适用于       | 返回       |
| --------------------------- | ------------ | ---------- |
| typeof                      | 基本数据类型 | string     |
| instanceof                  | 引用数据     | true/false |
| `Object.prototype.toString` | 都可以       | string     |

## Object.prototype.toString.call(obj)

### 原理

返回 obj 所属类的信息。

- 基本类型数据原型上的toString方法都是把当前的数据类型转换为字符串的类型（它们的作用仅仅是用来转换为字符串的）
- 引用类型数据上的toString返回当前方法执行的主体（方法中的this）所属类的信息即`[object Object]`=。

```javascript
Object.prototype.toString.call('') ;   // [object String]
Object.prototype.toString.call(1) ;    // [object Number]
Object.prototype.toString.call(true) ; // [object Boolean]
Object.prototype.toString.call(undefined) ; // [object Undefined]
Object.prototype.toString.call(null) ; // [object Null]
Object.prototype.toString.call(new Function()) ; // [object Function]
Object.prototype.toString.call(new Date()) ; // [object Date]
Object.prototype.toString.call([]) ; // [object Array]
Object.prototype.toString.call(new RegExp()) ; // [object RegExp]
Object.prototype.toString.call(new Error()) ; // [object Error]
Object.prototype.toString.call(document) ; // [object HTMLDocument]
Object.prototype.toString.call(window) ; //[object global] window是全局对象global的引用
```

### 检验方法

```
Object.prototype.toString.call(a).split(' ')[1].slice(0,-1).toLowerCase()
```

## typeof

### 原理

基于js底层存储变量数据类型的值（二进制）进行检测

| 类型     | typeof 结果                         |             |
| -------- | ----------------------------------- | ----------- |
| 基本类型 | undefined                           | "undefined" |
|          | Boolean                             | "boolean"   |
|          | Number                              | "number"    |
|          | String                              | "string"    |
|          | BigInt (ECMAScript 2020 新增)       | "bigint"    |
|          | Symbol                              | "symbol"    |
|          | null                                | "object"    |
| 引用类型 | Object（Object、Array、Map、Set等） | "object"    |
|          | Function                            | "function"  |

> 对于原始类型来说，除了 null 都可以调用 typeof 显示正确的类型。null会被检测为object，是js底层的一个bug。


### 语法

typeof检测null是一个对象

typeof检测函数返回时一个function

typeof检测其他对象都返回 object

```javascript
typeof 1 // 'number'
typeof '1' // 'string'
typeof undefined // 'undefined'
typeof true // 'boolean'
typeof Symbol() // 'symbol'
typeof console.log // 'function'
```

但对于引用数据类型，除了函数之外，都会显示"object"。

```javascript
typeof [] // 'object'
typeof {} // 'object'
typeof null; //object 
```

## instanceof

### 原理

判断当前类出现在实例的原型链上。

表达式为：A instanceof B，如果A是B的实例，则返回true,否则返回false。

### 语法

```javascript
[] instanceof Array; //true
{} instanceof Object;//true
new Date() instanceof Date;//true
new RegExp() instanceof RegExp//true

const Person = function() {}
const p1 = new Person()
p1 instanceof Person // true

const str1 = 'hello world'
str1 instanceof String // false

const str2 = new String('hello world')
str2 instanceof String // true
```

### 弊端

- 不能检测null 和 undefined

  ```javascript
  const arr = [1, 2, 3];
  console.log(arr instanceof null)//Uncaught TypeError: Right-hand side of 'instanceof' is not an object
  console.log(arr instanceof undefined)//Uncaught TypeError: Right-hand side of 'instanceof' is not an object
  
  ```

对于特殊的数据类型null和undefined，他们的所属类是Null和Undefined，但是浏览器把这两个类保护起来了，不允许我们在外面访问使用。

- 对于基本数据类型来说，字面量方式创建出来的结果和实例方式创建的是有一定的区别的,所以不能检测基本类型数据。

```javascript
console.log(1 instanceof Number)//false
console.log(new Number(1) instanceof Number)//true
```

- 只要在当前实例的原型链上，我们用其检测出来的结果都是true。**在类的原型继承中，我们最后检测出来的结果未必准确**。

```javascript
const arr = [1, 2, 3];
console.log(arr instanceof Array) // true
console.log(arr instanceof Object);  // true
function fn(){}
console.log(fn instanceof Function)// true
console.log(fn instanceof Object)// true
```
### 源码实现

```javascript
// 实例.__proto__===类.prototype
function instance_of(example, classFunc) {
  let classFuncPrototype = classFunc.prototype
  let proto = Object.getPrototypeOf(example)
  while (true) {
    if (proto === null) {
      return false
    }
    if (proto === classFuncPrototype) {
      return true
    }
    proto = Object.getPrototypeOf(proto)
  }
}
console.log(instance_of({}, Array))//false
```




