---
title: "Typescript关键字及工具函数"
date: 2022-07-01T17:42:18+08:00
draft: false
tags: [""]
categories: [""]
uri: /posts/typescript/tsType
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



#### keyof

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



#### typeof

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



#### Required

让属性都变成必选

```TypeScript
type A  = {a?:number, b?:string}
type A1 = Required<A> // { a: number; b: string;}
```

#### pick<T,K>

只保留自己选择的属性, K代表要保留的属性键值

```TypeScript
type A  = Pick<{a:number,b:string,c:boolean}, 'a'|'b'>
type A1 = Pick<A, 'a'|'b'> //  {a:number,b:string}
```

#### Omit<T,K>

实现排除已选的属性,, K代表要排除的属性键值

```
type A  = {a:number, b:string}
type A1 = Omit<A, 'a'> // {b:string}
```

##### **Record<K,T>**

创建一个类型,K代表键值的类型, T代表值的类型

```TypeScript
type A1 = Record<string, string> // 等价{[k:string]:string}
```

#### Exclude<T,U>

过滤T中和U相同(或兼容)的类型

```
type A  = {a:number, b:string}
type A1 = Exclude<number|string, string|number[]> // number

// 兼容
type A2 = Exclude<number|string, any|number[]> // never , 因为any兼容number, 所以number被过滤掉
```

##### **NonNullable**

剔除T中的undefined和null

```
type A1 = NonNullable<number|string|null|undefined> // number|string
```

##### **ReturnType**

获取T的返回值的类型

```
type A1= ReturnType<()=>number> // number
```

##### **InstanceType, 返回T的实例类型**

ts中类有2种类型, 静态部分的类型和实例的类型, 所以`T`如果是构造函数类型, 那么`InstanceType`可以返回他的实例类型:

```TypeScript
interface A{
    a:HTMLElement;
}

interface AConstructor{
    new():A;
}

function create (AClass:AConstructor):InstanceType<AConstructor>{
    return new AClass();
}
```

##### **Parameters**

返回类型为元祖, 元素顺序同参数顺序.

```TypeScript
interface A{
    (a:number, b:string):string[];
}

type A1 = Parameters<A> // [number, string]
```

##### **Extract<T,U>**

提取T中和U相同(或兼容)的类型

```
type A  = {a:number, b:string}
type A1 = Extract<number|string, string|number[]> // string
```

#### Partial

```TypeScript
/**
 * Make all properties in T optional
 */
type Partial<T> = {
    [P in keyof T]?: T[P];
};
```

使所有属性变为可选属性。

```
interface IUser {
  name: string
  age: number
  department: string
}
type optional = Partial<IUser>

// optional的结果如下

type optional = {
    name?: string | undefined;
    age?: number | undefined;
    department?: string | undefined;
}
```

#### extends

```TypeScript
T extends U ? X : Y
复制代码
```

用来表示类型是不确定的, 如果`U`的类型可以表示`T`, 那么返回`X`, 否则`Y`. 举几个例子:

```TypeScript
type A =  string extends '123' ? string :'123' // '123'
type B =  '123' extends string ? string :123 // string
复制代码
```

明显`string`的范围更大, `'123'`可以被`string`表示, 反之不可.

#### keyof

索引类型，获取对象的键值。

```TypeScript
type A = keyof {a:1,b:'123'} // 'a'|'b'
type B = keyof [1,2] // '0'|'1'|'push'... , 获取到内容的同时, 还得到了Array原型上的方法和属性(实战中暂时没遇到这种需求, 了解即可)
```

## infer(类型推断)

单词本身的意思是"推断", 实际表示在`extends`条件语句中**声明**待推断的类型变量. 我们上面介绍的**映射类型**中就有很多都是ts在`lib.d.ts`中实现的, 比如`Parameters`:

```TypeScript
type Parameters<T extends (...args: any) => any> = T extends (...args: infer P) => any ? P : never;
复制代码
```

上面声明一个`P`用来表示`...args`可能的类型, 如果`(...args: infer P)`可以**表示** `T`, 那么返回`...args`对应的类型, 也就是函数的参数类型, 反之返回`never`.

**注意:** 开始的`T extends (...args: any) => any`用来校验输入的`T`是否是函数, 如果不是ts会报错, 如果直接替换成`T`不会有报错, 会一直返回`never`.

##### **应用infer**

接下来我们利用`infer`来实现"删除元祖类型中第一个元素", 这常用于简化函数参数

```TypeScript
export type Tail<Tuple extends any[]> = ((...args: Tuple) => void) extends ((a: any, ...args: infer T) => void) ? T : never;
复制代码
```

## in

我们需要遍历 `IUser` ，这时候 `映射类型`就可以用上了，其语法为 `[P in Keys]`

- P：类型变量，依次绑定到每个属性上，对应每个属性名的类型
- Keys：字符串字面量构成的联合类型，表示一组属性名（的类型），可以联想到上文 `keyof` 的作用

[TypeScript中的高级类型工具类型及关键字](https://juejin.cn/post/6900712964299423758#heading-9)