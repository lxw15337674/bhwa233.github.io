---
title: "webpack 中 loader 和 plugin"
date: 2022-08-01T23:17:54+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## loader

webpack自身只支持js和json这两种格式的文件，对于其他文件需要通过loader将其转换为commonJS规范的文件后，webpack才能解析到。

它是一个转换器，将A文件进行编译成B文件，比如：将A.less转换为A.css，单纯的文件转换过程。

## plugin

是用于在webpack打包编译过程里，在对应的事件节点里执行自定义操作，比如资源管理、bundle文件优化等操作。

plugin是一个扩展器，它丰富了webpack本身，针对是loader结束后，webpack打包的整个过程，它并不直接操作文件，而是基于事件机制工作，会监听webpack打包过程中的某些节点，执行广泛的任务





todo:https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/308