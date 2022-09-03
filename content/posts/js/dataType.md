---
title: "javscript数据类型"
date: 2022-07-19T09:45:56+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



## 基本数据类型

7种：

- Undefined

- Null

- Boolean

- String

- Number

- BigInt(主要用的大数据。number最大值2的53次方，超过只能使用BigInt)

- Symbol

  > NaN 属于 number 类型，并且 NaN 不等于自身。
  > bigint 理论上属于 number 类型，但在 typeof 中是 `bigint`

### 特点

1. 值是不可变的

   ```javascript
   let name = 'java';
   name.toUpperCase(); // 输出 'JAVA'
   console.log(name); // 输出  'java'
   ```

2. 存放在栈内存

原始数据类型的数据占据空间小、大小固定，属于被频繁使用数据，所以放入栈中存储。

3. 值的比较

   可以正常比较。

   ```javascript
   let a = 1;
   let b = true;
   console.log(a == b);    // true
   console.log(a === b);   // false
   ```

### 引用数据类型

6种：

- Object(普通类型)
- Array(数组对象)
- RegExp(正则对象)
- Date(日期对象)
- Math(数据对象)
- Function(函数对象)

### 特点

1. 值是动态可变的

   ```javascript
   let a={age:20}；
   a.age=21；
   console.log(a.age)//21
   ```

2. 栈内存中存储指针，堆内存存储实体

   引用数据类型的数据大小不固定，占据空间大，如果存储在栈中，将会影响程序运行的性能；所以引用数据类型在栈中仅存储了指针，该指针指向堆中该实体的起始地址。

   **当解释器寻找引用值时，会首先检索其在栈中的地址，取得地址后从堆中获得实体。**

3. 赋值只会赋值指针

   当将引用类型的值赋给另一个变量时，仅会复制数据的指针。改变其中任何一个变量，都会相互影响

   ```
   var a={age:20};
   var b=a;
   b.age=21;
   console.log(a.age==b.age)//true
   ```

### null 和 undefined 区别

- null 表示对象的值未设定。
  - 作为对象原型链的终点。
  - 作为标识，表示变量未指向任何对象。
- undefined 表示没有被定义。
  - 定义了形参，没有传实参，显示 undefined。
  - 对象属性名不存在时，显示 undefined。
  - 函数没有写返回值，即没有写 return，返回 undefined
  - 写了 return，但没有赋值，拿到的是 undefined

