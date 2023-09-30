---
title: "Typescript语法"
date: 2022-07-01T17:42:18+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 高级类型

### 字面量类型（literal types）

值作为类型。

```typescript
type foo = "Hello" 
// foo 的类型就是"hello",而不是string类型。
foo ="hello" //ok
foo="hi" // Error: Type '"Hi"' is not assignable to type 'Hello'
```

通常用于和联合类型（union types）、类型别名（type aliases）、类型保护（type guards）。



### 联合类型

将多个类型结合，使用 `｜` 符号进行连接。值只需满足其中一个类型

```typescript
type Foo = "Hello" | "Hi" 
let foo:Foo = "hello" //ok
let foo:Foo= 'welcome' //Error: Type '"welcome"' is not assignable to type 'Foo' 
```



### 交叉类型

多个类型合并为一个类型。使用 `& `连接多个类型，值类型时必需同时满足所有类型。

```typescript
type Foo = { width: number };
type Bar = { height: number };
const baz: Foo & Bar = {
  width: 3,
  height:3
};

```



### 枚举类型

多个键值对的集合，使用其类型时赋值只能是声明的值之一。

```typescript
enum Fruit {
  APPLE = 'apple',
  BANANA = 'banana',
}
const fruit1: Fruit = Fruit.APPLE; // apple
const fruit2: Fruit = Fruit.BANANA; // banana

```

如果都没有赋值，则默认值从0开始。

```typescript
enum Fruit {
  APPLE,
  BANANA,
}
const fruit1: Fruit = Fruit.APPLE; //0
const fruit2: Fruit = Fruit.BANANA; //1
```

如果有一个赋值，则后面没有复制的值都为`undefined`

```typescript
enum Fruit {
  APPLE,
  BANANA = 'BANANA',
  ORANGE,
}
const fruit1 = Fruit.APPLE; //0
const fruit2 = Fruit.BANANA; // 'BANANA'
const fruit3 = Fruit.ORANGE; // undefined
```

### 类型断言

声明一个不确定的类型为确定的类型。有“尖括号”语法和as语法两种写法。

```typescript
let someValue: any = "this is a string";
//“尖括号”语法
let strLength: number = (someValue as string).length; 
//as语法
let strLength: number = (<string>someValue).length;
```

### 类型别名

声明一个类型来代指当前类型。

```typescript
type MyString = string;
```



###  非空断言

声明变量不会为空（包括`undefined`和`null`）

```typescript
const fruit: string | undefined = 1;
fruit.toString() //error, 对象可能为“未定义”
fruit!.toString() //ok
```



## 类型保护

### is

声明参数类型。一般用于判断参数类型的方法。

类型保护的作用域仅仅在 if 后的块级作用域中生效。

```typescript
// 当isString返回值为true的时候, 参数val就是string类型.
function isString(test: any): test is string{
  return typeof test === "string";
}

function example(foo: any){
  if(isString(foo)){
      console.log(foo.toExponential(2)); //error,类型“string”上不存在属性“toExponential”。
  }
  console.log(foo.toExponential(2));  // 编译不会出错，但是运行时出错
}
example("hello world");

```







## 工具类型

### Partial

将传入类型 T 的所有属性变为可选属性。

```typescript
// type Partial<T> = { [P in keyof T]?: T[P] | undefined; }

interface IUser {
  name: string
  age: number
  department: string
}
type optional = Partial<IUser>
```

### Required

将传入类型 T 的所有属性变为必选属性。

```TypeScript
// type Required<T> = { [P in keyof T]-?: T[P]; }

type A  = {a?:number, b?:string}
type A1 = Required<A> // { a: number; b: string;}
```

### Readonly 

将类型 T 的所有属性转换为只读属性，只能在声明时赋值。

```typescript
// type Readonly<T> = { readonly [P in keyof T]: T[P]; }

type Foo = { foo: string };
const readonlyFoo: Readonly<Foo> = {
  foo: 'foo',
};
readonlyFoo.foo = 'bar'; // error
```

### pick

只保留自己选择的属性, K代表要保留的属性键值。

```TypeScript
// type Pick<T, K extends keyof T> = { [P in K]: T[P]; }

interface Foo{
  a:string,
  b:number,
  c:boolean
}

type A = Pick<Foo, 'a'|'b'> //  {a:string,b:number}
```

### Omit

实现排除已选的属性,, K代表要排除的属性键值。

```typescript
// type Omit<T, K extends string | number | symbol> = { [P in Exclude<keyof T, K>]: T[P]; }

interface Foo{
  a:string,
  b:number,
  c:boolean
}

type A = Omit<Foo, 'a'|'b'> //  {c:boolean}
```

### Record

创建一个类型,K代表键值的类型, T代表值的类型。

```TypeScript
// type Record<K extends string | number | symbol, T> = { [P in K]: T; }

type Baz = Record<'name' | 'age', string>;
// 等价于
type Baz = {
    name: string;
    age: string;
}
```

### Exclude

过滤T中和U相同(或兼容)的类型。

```typescript
// type Exclude<T, U> = T extends U ? never : T

type Foo = Exclude<"a" | "b" | "c", "a">;  // "b" | "c"
type Bar = Exclude<"a" | "b" | "c", "a" | "b">;  // "c"

```



### Extract

提取T中和U相同(或兼容)的类型。

```typescript
// type Extract<T, U> = T extends U ? T : never

type Foo = Extract<"a" | "b" | "c", "a" | "f">;  // "a"
```



### **NonNullable**

剔除类型T中的undefined和null。

```typescript
// type NonNullable<T> = T extends null | undefined ? never : T

type Foo = NonNullable<number|string|null|undefined> // number|string
```

### **ReturnType**

获取T的返回值的类型。

```typescript
// type ReturnType<T extends (...args: any) => any> = T extends (...args: any) => infer R ? R : any

type A1= ReturnType<()=>number> // number
```

### **InstanceType**

返回T的实例类型。

```TypeScript
class Human {
  name = 'bhwa233';
  age = 28;
}

type HumanType = InstanceType<typeof Human>; // Human
```

### **Parameters**

返回类型为元祖, 元素顺序同参数顺序。

```TypeScript
interface A{
    (a:number, b:string):string[];
}

type A1 = Parameters<A> // [number, string]
```



## 关键字

### keyof

返回由对象的键值组成的字面量类型。

```typescript
interface Person {
    name: string
    age: number
    location: string
}
type PesonKeys = keyof Person
// PesonKeys ="name" | "age" | "location"

type B = keyof [1,2] // '0'|'1'|'push'... , 获取到内容的同时, 还得到了Array原型上的方法和属性(实战中暂时没遇到这种需求, 了解即可)
```

### typeof

返回值的类型。

```typescript
const foo: string = 'a';
type FooType = typeof foo;
// PesonKeys = string
```

```typescript
const foo = {
  name:'bhwa233',
  age:28
};

type FooType = typeof foo;
// type FooType = {
//   name: string;
//   age: number;
// }

```



### extends

用来表示类型是不确定的, 如果`U`的类型可以表示`T`, 那么返回`X`, 否则`Y`。

```TypeScript
type A =  string extends '123' ? string :'123' // '123'
type B =  '123' extends string ? string :123 // string

```

明显`string`的范围更大, `'123'`可以被`string`表示, 反之不可.



### infer

类型推断，表示在`extends`条件语句中声明待推断的类型变量。

 例如`Parameters`

```typescript
type Parameters<T extends (...args: any) => any> = T extends (...args: infer P) => any ? P : never;
```

上面声明一个`P`用来表示`...args`可能的类型, 如果`(...args: infer P)`可以表示 `T`, 那么返回`...args`对应的类型, 也就是函数的参数类型, 反之返回`never`.

**注意:** 开始的`T extends (...args: any) => any`用来校验输入的`T`是否是函数, 如果不是ts会报错, 如果直接替换成`T`不会有报错, 会一直返回`never`。

举例：利用`infer`来实现"删除元祖类型中第一个元素", 这常用于简化函数参数

```TypeScript
 export type Tail<Tuple extends any[]> = ((...args: Tuple) => void) extends ((a: any, ...args: infer T) => void) ? T : never;
```

### in

遍历联合类型。

```typescript
type key = 'vue' | 'react';

type MappedType = { [k in key]: string } // { vue: string; react: string; }
```



## 接口

###  带有任意数量的其他属性

```typescript
interface SquareConfig {
    color?: string;
    width?: number;
    [propName: string]: any;
}
```

### 函数类型

```typescript
let mySearch: SearchFunc;
mySearch = function(source: string, subString: string) {
  let result = source.search(subString);
  return result > -1;
}t
```

