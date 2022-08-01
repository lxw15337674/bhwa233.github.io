---
title: "let、const和var的区别"
date: 2022-08-01T18:51:19+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 变量提升

> 变量提升：
> - 所有的声明都会提升到作用域的最顶上去。
> - 函数声明的优先级高于变量声明的优先级，并且函数声明和函数定义的部分一起被提升。

 一个变量有三个操作，声明(提到作用域顶部)，初始化(赋默认值)，赋值(继续赋值)。

`let` `const` 和`var`三者都会存在变量提升

- `let`只是**创建**过程提升，**初始化**过程并没有提升，所以会产生暂时性死区。

- `var`的**创建**和**初始化**过程都提升了，所以在赋值前访问会得到`undefined`

- `function` 的**创建、初始化、赋值**都被提升了

```javascript
console.log(data1); //undefined
var data1 = 'var';

console.log(data2); //Uncaught ReferenceError: Cannot access 'data2' before initialization 
let data2 = 'let';

console.log(data3); //Uncaught ReferenceError: Cannot access 'data3' before initialization
const data3 = 'const';

```



## 声明

- `var`声明变量可以重复声明，而`let`、`const`不可以重复声明。
- `const`声明之后必须赋值，否则会报错。
- `const`定义不可变的量，改变了就会报错。**但是`const`仅保证指针不发生改变，修改对象的属性不会改变对象的指针，所以是被允许的**

## 作用域

- 比如模块或者一个方法中声明的`var a=1`，如果声明在模块中，则会默认挂载到`window`上；如果声明在方法中，则在方法内部任何地方都可以访问；如果声明在代码块里，则会提升到上一级作用域；
- 而`let`、`const`仅作用于块级作用域，仅在该块级内起作用。

```javascript
if(true){
  var color = "red"
}
console.log(color)  //'red'

if(true){
  let color = 'red'
}
console.log(color) //ReferenceError
```



####  在es5环境下实现const

```javascript
function _const(key, value) {    
    const desc = {        
        value,        
        writable: false    
    }    
    Object.defineProperty(window, key, desc)
}
    
_const('obj', {a: 1})   //定义obj
obj.b = 2               //可以正常给obj的属性赋值
obj = {}                //抛出错误，提示对象read-only

```

## 详解

[let 和 const 命令
](https://es6.ruanyifeng.com/#docs/let)