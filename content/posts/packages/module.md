---
title: "前端模块化输出"
date: 2022-07-28T21:17:45+08:00
draft: false
tags: ["js"]
categories: ["js"]
typora-root-url: ..\..\static
---

模块化主要是用来抽离公共代码，隔离作用域，避免变量冲突等。

|                   | 无模块化 | CommonJS规范 | AMD规范                        | CMD规范  | ES6模块化 |
| ----------------- | -------- | ------------ | ------------------------------ | -------- | --------- |
| 适用              |          | 服务端       | 浏览器端                       | 浏览器端 | 浏览器端  |
| 加载方式          |          | 同步加载     | 异步加载、模块开始加载所有依赖 | 按需加载 | 异步加载  |
| 实现库            |          |              | requireJs                      | seajs    |           |
| 来源              |          | 前端社区     | 前端社区                       | 前端社区 | 官方      |
| 是否需要bebal编译 | 否       | 否           | 否                             | 否       | 是        |

## 无模块化

将所有JS文件都放在一块，代码执行顺序就按照文件的顺序执行。

### 缺点

- 污染全局作用域。 因为每一个模块都是暴露在全局的，简单的使用，会导致全局变量命名冲突，当然，我们也可以使用命名空间的方式来解决。
- 对于大型项目，各种js很多，开发人员必须手动解决模块和代码库的依赖关系，后期维护成本较高。
- 依赖关系不明显，不利于维护。 比如main.js需要使用jquery，但是，从上面的文件中，我们是看不出来的，如果jquery忘记了，那么就会报错。

![img](/images/672759-20180302170935534-60089026.png)

## CommonJS

### 核心思想

- 通过 require 方法来**同步加载**所要依赖的其他模块，
- 通过 module.exports 来导出需要暴露的接口

### 特点

- 每个文件就是一个模块，有自己的作用域。在一个文件里面定义的变量、函数、类，都是私有的，对其他文件不可见。
- 所有代码都运行在模块作用域，不会污染全局作用域。
- 模块可以多次加载，但是只会在第一次加载时运行一次，然后运行结果就被缓存了，以后再加载，就直接读取缓存结果。要想让模块再次运行，必须清除缓存。
- 模块加载的顺序，按照其在代码中出现的顺序。
- CommonJS 一般用在服务端或者Node用来同步加载模块，它对于模块的依赖发生在代码运行阶段，不适合在浏览器端做异步加载。

### 缺点

- CommonJS 是同步加载模块的，只有加载完成，才能执行后面的操作。
- 由于 CommonJS 是同步加载模块的，在服务器端，文件都是保存在硬盘上，所以同步加载没有问题，但是对于浏览器端，需要将文件从服务器端请求过来，那么同步加载就不适用了，所以，CommonJS是不适用于浏览器端的。

### 例子

```
// CommonJS模块
let { stat, exists, readFile } = require('fs');

// 等同于
let _fs = require('fs');
let stat = _fs.stat;
let exists = _fs.exists;
let readfile = _fs.readfile;
```

整体加载fs模块（即加载fs的所有方法），生成一个对象（_fs），然后再从这个对象上面读取 3 个方法。这种加载称为“运行时加载”，因为只有运行时才能得到这个对象，导致完全没办法在编译时做“静态优化”。

### 与AMD差别

>  CommonJS 规范加载模块是同步的，也就是说，只有加载完成，才能执行后面的操作。
>
>  AMD规范则是非同步加载模块，允许指定回调函数。 
>
>  由于 Node.js 主要用于服务器编程，模块文件一般都已经存在于本地硬盘，所以加载起来比较快，不用考虑非同步加载的方式，所以 CommonJS 规范比较适用。  
>
>  如果是浏览器环境，要从服务器端加载模块，这时就必须采用非同步模式，因此浏览器端一般采用 AMD 规范。  

## AMD 规范

特点

- **非同步加载模块**，允许指定回调函数。因此浏览器端一般采用AMD规范。

- AMD全称Asynchronous Module Definition异步模块定义。
- AMD并非原生js支持，是RequireJS模块化开发当中推广的产物，AMD依赖于RequireJS函数库，打包生成对应效果的js代码

优点

- 适合在浏览器环境中异步加载模块。
- 可以并行加载多个模块。

缺点：

- 提高了开发成本。
- 不能按需加载，而是必须提前加载所有的依赖。

```javascript
define(function () {
    var alertName = function (str) {
      alert("I am " + str);
    }
    var alertAge = function (num) {
      alert("I am " + num + " years old");
    }
    return {
      alertName: alertName,
      alertAge: alertAge
    };
  });
//引入模块：
require(['alert'], function (alert) {
  alert.alertName('JohnZhu');
  alert.alertAge(21);
});
```

## CMD

- CMD全称Common Module Definition通用模块定义
- 可以通过按需加载的方式，而不是必须在模块开始就加载所有的依赖。
- 同AMD，CMD也有一个函数库SeaJS与RequireJS类似的功能
- CMD推崇一个文件一个模块，推崇**依赖就近**，定义模块`define(id?,deps?,factory)`，id同AMD，deps一般不在其中写依赖，而是在factory中在需要使用的时候引入模块，factory函数接收3各参数，参数一require方法，用来内部引入模块的时候调用，参数二exports是一个对象，用来向外部提供模块接口，参数三module也是一个对象上面存储了与当前模块相关联的一些属性和方法
- 通过seajs.use(deps,func)加载模块，deps为引入到模块路径数组，func为加载完成后的回调函数

**优点：**

- 实现了浏览器端的模块化加载。
- 可以按需加载，依赖就近。

**缺点：**

- 依赖SPM打包，模块的加载逻辑偏重。 

### AMD、CMD区别

1. AMD推崇依赖前置，在定义模块的时候就要声明其依赖的模块。CMD推崇就近依赖，只有在用到某个模块的时候再去require

```javascript
// require.js 例子中的 main.js
// 依赖必须一开始就写好
require(['./add', './square'], function(addModule, squareModule) {
    console.log(addModule.add(1, 1))
    console.log(squareModule.square(3))
});
```

```javascript
// sea.js 例子中的 main.js
define(function(require, exports, module) {
    var addModule = require('./add');
    console.log(addModule.add(1, 1))

    // 依赖可以就近书写
    var squareModule = require('./square');
    console.log(squareModule.square(3))
});
```

2.对于依赖的模块，AMD 是提前执行，CMD 是延迟执行。看两个项目中的打印顺序：

```javascript
// require.js
加载了 add 模块
加载了 multiply 模块
加载了 square 模块
2
9
```

```javascript
// sea.js
加载了 add 模块
2
加载了 square 模块
加载了 multiply 模块
9
```

## UMD规范

**背景：**

Modules/Wrappings是出于对NodeJS模块格式的偏好而包装下使其在浏览器中得以实现, 而且它的格式通过某些工具（如[r.js](https://github.com/jrburke/r.js)）也能运行在NodeJS中。事实上，这两种格式同时有效且都被广泛使用。

AMD以浏览器为第一（browser-first）的原则发展，选择异步加载模块。它的模块支持对象（objects）、函数（functions）、构造器（constructors）、字符串（strings）、JSON等各种类型的模块。因此在浏览器中它非常灵活。

CommonJS以服务器端为第一（server-first）的原则发展，选择同步加载模块。它的模块是无需包装的（unwrapped modules）且贴近于ES.next/Harmony的模块格式。但它仅支持对象类型（objects）模块。 

这迫使一些人又想出另一个更通用格式 [UMD](https://github.com/umdjs/umd)(Universal Module Definition)。希望提供一个前后端跨平台的解决方案。

**说明：**

UMD的实现很简单，先判断是否支持NodeJS模块格式（exports是否存在），存在则使用NodeJS模块格式。

再判断是否支持AMD（define是否存在），存在则使用AMD方式加载模块。前两个都不存在，则将模块公开的全局（window或global）。

## ES Module

- 由于 ES6 模块是编译时加载，使得静态分析成为可能。有了它，就能进一步拓宽 JavaScript 的语法，比如引入宏（macro）和类型检验（type system）这些只能靠静态分析实现的功能。
- 不再需要UMD模块格式，将来服务器和浏览器都会支持 ES6 模块格式。
- 将来浏览器的新 API 就能用模块格式提供，不再必须做成全局变量或者navigator对象的属性

#### 用途

1. 实现按需加载
2. 条件加载
3. 动态的模块路径

```
// ES6模块
import { stat, exists, readFile } from 'fs';
```



## 详解

https://github.com/mqyqingfeng/Blog/issues/108
https://javascript.ruanyifeng.com/nodejs/module.html
https://es6.ruanyifeng.com/#docs/module

## 面试题

### common.js 和 es6 中模块引入的区别？

CommonJS 是一种模块规范，最初被应用于 Nodejs，成为 Nodejs 的模块规范。  
在 ES6 出来之前，前端也实现了一套相同的模块规范 (例如: AMD)，用来对前端模块进行管理。自 ES6 起，引入了一套新的 ES6 Module 规范，在语言标准的层面上实现了模块功能，有望成为浏览器和服务器通用的模块解决方案。但目前浏览器对 ES6 Module 兼容还不太好，我们平时在 Webpack 中使用的 export 和 import，会经过 Babel 转换为 CommonJS 规范。

- CommonJS 是运行时加载，ES6 模块是静态加载。所以前者支持动态导入。
- CommonJs 是同步加载模块，因为用于服务端，文件都在本地。而后者是异步导入，因为用于浏览器。同步加载：所谓同步加载就是加载资源或者模块的过程会阻塞后续代码的执行；异步加载：不会阻塞后续代码的执行；
- CommonJS 是值拷贝（深拷贝），就算导出的值变了，导入的值也不会改变，如果想要更新至，必须重新导入一次。ES6 采用值引用（浅拷贝），导入导出的值都指向同一个内存地址，所以导入值会跟随导出值变化。
- CommonJs 是动态语法可以写在判断里，ES6 Module 静态语法只能写在顶层
- CommonJs 的 this 是当前模块，ES6 Module的 this 是 undefined



## 参考

https://github.com/ljianshu/Blog/issues/48