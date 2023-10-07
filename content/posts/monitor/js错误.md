---
title: "异常监控"
date: 2023-03-15T14:47:44+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 异常类型

### JS错误

在 JavaScript 中，Error 是一种标准的内置对象，用于表示运行时错误和异常。Error 对象可以通过 throw 语句抛出，由 try...catch 语句捕获并处理。

一个 JavaScript 错误通常包含以下几个主要部分：

1. 错误类型（Error Type）：指 JavaScript 抛出的错误类型，如语法错误(SyntaxError)、参考错误(ReferenceError)等。
2. 错误信息（Error Message）：指错误的文字描述信息，通常包含引起错误的原因和位置。在 JavaScript 中，错误信息通常包含在 Error 对象的 message 属性中。
3. 堆栈跟踪（Stack Trace）：指 JavaScript 引擎运行代码时的调用栈信息，包括函数调用顺序、执行位置、堆栈状态等。堆栈跟踪信息通常包含在 Error 对象的 stack 属性中。

**示例：**

比如，一个 JavaScript 的运行时错误示例：

```javascript
Uncaught TypeError: Cannot read property 'x' of null
    at exampleFunction (example.js:10:15)
    at otherFunction (example.js:5:2)
    at init (example.js:1:1)
```

在这个错误示例中，有以下几个部分：

1. 错误类型：`TypeError` 表示类型错误，即对 `null` 值进行了属性访问操作。
2. 错误信息：`Cannot read property 'x' of null` 表示无法读取 `null` 对象的属性 `'x'`，说明了错误的原因。
3. 堆栈跟踪：根据堆栈信息可以了解到，引发错误的函数为 `exampleFunction`，出现在文件 `example.js` 的第 10 行第 15 列；`exampleFunction` 又被 `otherFunction` 调用，出现在文件 `example.js` 的第 5 行第 2 列；`otherFunction` 又被 `init` 函数调用，出现在文件 `example.js` 的第 1 行第 1 列。

### 错误处理
#### try-catch 

使用 try-catch 可以捕获局部代码中的异常，**只能捕获代码常规的运行错误，语法错误和异步错误不能捕获到**。

```javascript
// 示例1：常规运行时错误，可以捕获 ✅
 try {
   let a = undefined;
   if (a.length) {
     console.log('111');
   }
 } catch (e) {
   console.log('捕获到异常：', e);
}

// 示例2：语法错误，不能捕获 ❌  
try {
  const notdefined,
} catch(e) {
  console.log('捕获不到异常：', 'Uncaught SyntaxError');
}
  
// 示例3：异步错误，不能捕获 ❌
try {
  setTimeout(() => {
    console.log(notdefined);
  }, 0)
} catch(e) {
  console.log('捕获不到异常：', 'Uncaught ReferenceError');
}

```

####  window.onerror

可以捕获常规错误、异步错误，**但不能捕获资源错误**。

示例：

```javascript
/**
* @param { string } message 错误信息
* @param { string } source 发生错误的脚本URL
* @param { number } lineno 发生错误的行号
* @param { number } colno 发生错误的列号
* @param { object } error Error对象
*/
window.onerror = function(message, source, lineno, colno, error) {
  console.log("捕获到的错误信息是：", message, source, lineno, colno, error);
};

// 示例1：常规运行时错误，可以捕获 ✅
console.log(notdefined);

// 示例2：语法错误，不能捕获 ❌
const notdefined;

// 示例3：异步错误，可以捕获 ✅
setTimeout(() => {
  console.log(notdefined);
}, 0);

// 示例4：资源错误，不能捕获 ❌
let script = document.createElement("script");
script.type = "text/javascript";
script.src = "https://www.test.com/index.js";
document.body.appendChild(script);
```

#### window.addEventListener

`error`：可以捕获常规错误、异步错误、静态资源加载失败，但不能捕获到Promise错误。

```javascript
window.addEventListener('error', (error) => {
    console.log('捕获到异常：', error);
}, true)
<!-- 图片、script、css加载错误，都能被捕获 ✅ -->
<img src="https://test.cn/×××.png">
<script src="https://test.cn/×××.js"></script>
<link href="https://test.cn/×××.css" rel="stylesheet" />


window.addEventListener('unhandledrejection', function (event) {
  console.log(event.reason); // Rejection reason
});
```

`unhandledrejection`:  用于捕获Promise中抛出的错误。

```javascript
try {
  new Promise((resolve, reject) => {
    JSON.parse("");
    resolve();
  });
} catch (err) {
  // try/catch 不能捕获Promise中错误 ❌
  console.error("in try catch", err);
}

// error事件 不能捕获Promise中错误 ❌
window.addEventListener(
  "error",
  error => {
    console.log("捕获到异常：", error);
  },
  true
);

// window.onerror 不能捕获Promise中错误 ❌
window.onerror = function(message, source, lineno, colno, error) {
  console.log("捕获到异常：", { message, source, lineno, colno, error });
};

// unhandledrejection 可以捕获Promise中的错误 ✅
window.addEventListener("unhandledrejection", function(e) {
  console.log("捕获到异常", e);
  // preventDefault阻止传播，不会在控制台打印
  e.preventDefault();
});

```

### Vue 错误

Vue项目中，window.onerror 和 error 事件不能捕获到常规的代码错误。需要通过 `Vue.config.errorHander` 来捕获异常：

vue 通过 `Vue.config.errorHander` 来捕获异常：

```javascript
Vue.config.errorHandler = (err, vm, info) => {
 // handleError方法用来处理错误并上报
  handleError(err);
}

```

### React 错误

react16以上，提供了ErrorBoundary组件，被该组件包裹的子组件，render 函数报错时会触发离当前组件最近的ErrorBoundary。

生产环境，一旦被 ErrorBoundary 捕获的错误，也不会触发全局的 window.onerror 和 error 事件.

```javascript
componentDidCatch(error, errorInfo) {
  // handleError方法用来处理错误并上报
  handleError(err);
}
```

## 错误上报

### 错误聚合

主要是为了避免出现大量的重复上报以及提高异常处理的效率。具体原因如下：

1. 避免重复上报：在系统运行过程中，可能会出现多个相同的异常错误，这些异常错误具有相同的错误类型和错误信息。如果每个异常错误都被单独上报，那么异常错误列表中会出现大量的重复项，从而导致数据量过大、占用存储空间多等问题。
2. 提高异常处理效率：对堆栈进行聚合可以将多条相似的异常错误归为同一类，方便开发人员统一分析处理。

一般使用错误堆栈聚合策略。因为在异常聚合时，使用基本的 name + message 的方式可能存在相同错误在不同代码段中出现的风险，这会导致其被当做同一个异常而被聚合到一起，这样可能造成我们修复了其中一个错误后。误以为相关的所有异常都被解决。为了避免这种情况发生，一般会使用堆栈跟踪信息（stack trace）区分不同的异常。堆栈跟踪信息可以准确地指明异常的来源和异常在代码中的位置，从而规避了不同文件下触发相同 message 的问题。

### 数据上报方式

1. fetch请求。
2. 图片打点上报。

通过使用`<img>`标签的方式发送一个GET请求到后台服务器，请求一个不存在的图片地址，同时将相关的错误信息携带在url中一并发送给后台服务器。

图片打点上报的优势：
1）支持跨域，一般而言，上报域名都不是当前域名，上报的接口请求会构成跨域
2）体积小且不需要插入dom中
3）不需要等待服务器返回数据

图片打点缺点是：url受浏览器长度限制

### 数据上报时机

优先使用 requestIdleCallback，利用浏览器空闲时间上报，其次使用微任务上报




## 定位源码

### 堆栈反解

#### why

在本地开发时，我们通常可以清楚的看到报错的源代码堆栈，从而快速定位到原始报错位置。而线上的代码一般会进行编译、压缩、混淆等操作，生成的 JavaScript 代码和原始代码之间的差异会非常大，可读性很差。

#### How

而Sourcemap则是用来解决这个问题。Sourcemap 是一个映射文件，用于将转换后的 JavaScript 代码映射回源代码。Sourcemap 中包含了转换后的代码与原始代码之间的映射关系，通常是一份 JSON 格式的文件，其中包括了每个转换后的代码位置（行数、列数）与其对应的原始代码位置（源文件名、行数、列数）。当 JavaScript 运行时发生错误，浏览器会根据 Sourcemap 文件中的映射信息将错误堆栈反解析回到原始的源代码位置，使得开发者能够更加快速准确地定位错误。

而为了安全，一般sourcemap也不会直接存放在线上，而是在构建中将生成的sourcemap直接上传到后端，一般使用[Sentry](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fgetsentry%2Fsentry-webpack-plugin) 等工具提供sourcemap的上传、反解功能。这样就可以看到线上的错误和原始代码。
