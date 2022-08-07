---
title: "泛型"
date: 2022-08-07T14:50:37+08:00
draft: false
uri: /posts/generic
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

类型变量，用于传递类型。

### 写法

```TypeScript
function identity<Type>(arg: Type): Type {
  return arg;
}

// 箭头函数的泛型必须有extends，否则语法无法识别。
const identity =<T extends {}>(arg: T): T => {
  return arg;
};
```



### 泛型约束

```TypeScript
interface Length{
  length:number
}
function  fn<T extends Length>(foo:T):T{
  console.log(foo.length)
  return foo
}

fn(1) //error:类型“number”的参数不能赋给类型“Length”的参数。
fn([1,2])
```



### 关于react forwardRef的类型

https://dirask.com/posts/React-forwardRef-with-generic-component-in-TypeScript-D6BoRD

```TypeScript
const test = forwardRef(
    <D extends {}>(
        { fieldItems, formOption, isEdit, defaultValue, style, onChange }: IFormProp<D>,
        ref: React.Ref<IFormBag<D>>
    ) => {
        return null;
    }
);
```