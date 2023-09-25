---
title: "Base"
date: 2022-08-21T11:29:30+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

**一、webpack的打包原理**

1. 识别入口文件
2. 通过逐层识别模块依赖(Commonjs、amd或者es6的import，webpack都会对其进行分析，来获取代码的依赖)
3. webpack做的就是分析代码，转换代码，编译代码，输出代码
4. 最终形成打包后的代码


