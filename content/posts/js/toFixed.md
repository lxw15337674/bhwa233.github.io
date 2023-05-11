---
title: "保留小数位-toFixed的坑"
date: 2023-05-11T14:49:27+08:00
draft: false
tags: [""]
categories: ["js"]
typora-root-url: ..\..\static
---

## 背景

开发过程中，遇到 需要对小数进行四舍五入的需求：首先想到的是 [Number.toFixed(pre)](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FReference%2FGlobal_Objects%2FNumber%2FtoFixed) 这个 API 的使用。

## 问题

预期的四舍五入结果：

```javascript
65967.005.toFixed(2) // 65967.01 
12859.005.toFixed(2) // 12859.01 
```

控制台实际输出的结果：

```javascript
65967.005.toFixed(2) // 65967.01 正确
12859.005.toFixed(2) // 12859.00 错误
```

## 原因

js的浮点数计算 。详见[stackoverflow](https://stackoverflow.com/questions/21091727/javascript-tofixed-function)

### 解决办法

1. 封装函数

```javascript
const toFixed = function (value: number, percision: number) {
  return Math.round(value * Math.pow(10, percision)) / (Math.pow(10, percision))
};

toFixed(65967.005, 2) // 65967.01 
toFixed(12859.005, 2) // 12859.01 
```

2. 使用数字库

```javascript
import { Decimal } from 'decimal.js';

const number = new Decimal(65967.005);
// 四舍五入到小数点后两位
const roundedNumber = number.toDecimalPlaces(2);

console.log(roundedNumber.toString()); // 65967.01 
```

