---
title: "webpack配置"
date: 2022-08-07T15:36:16+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

1. 安装两个模块

   ```
   npm i -D typescript ts-loader 
   ```

2. 添加ts的配置文件`tsconfig.json`，[配置参考](https://juejin.cn/post/6844904109976322061)。

3. webpack设置文件后缀补全。

在ts文件中引入其他ts文件会提示不能以'.ts'扩展名结尾。

> TS2691: An import path cannot end with a '.ts' extension. Consider importing './math' instead.

但webpack默认不会补全ts文件，就会在浏览器报错。

```js
// vue-cli默认补全后缀
[ '.mjs','.js',  '.jsx','.vue',  '.json','.wasm']
```

解决办法：配置webpack的扩展名处理。

```json
resolve: {
   extensions: ['.ts', '.mjs','.js',  '.jsx','.vue',  '.json','.wasm']
},  
```

