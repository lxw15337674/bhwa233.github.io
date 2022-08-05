---
title: "keyof typeof"
date: 2022-08-05T10:54:07+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 前置概念

### 字面量类型（literal types）

更具体的`string`、`number`、`boolean`类型就是字面量类型。例如：

```typescript
type foo = "Hello"
// foo 的类型就是"hello",而不是string类型。
foo ="hello" //ok
foo="hi" // Error: Type '"Hi"' is not assignable to type 'Hello'
```

通常用于和联合类型（union types）、类型别名（type aliases）、类型保护（type guards）。

联合字面量类型的例子：

```typescript
type Foo = "Hello" | "Hi" 
let foo:Foo = "hello" //ok
let foo:Foo= 'welcome' //Error: Type '"welcome"' is not assignable to type 'Foo' 
```



## keyof

获取对象的键值

```typescript
interface Person {
    name: string
    age: number
    location: string
}
type PesonKeys = keyof Person
// PesonKeys ="name" | "age" | "location"
```



## typeof

创建对象的类型，此类型包含一组指定的属性且都是必填

```typescript
interface Person {
    name: string
    age: number
    location: string
}
type PesonKeys = keyof Person
// PesonKeys ="name" | "age" | "location"
```

