---
title: "Src和href"
date: 2022-08-21T13:29:51+08:00
draft: false
tags: ["html"]
categories: ["html"]
typora-root-url: ..\..\static
---

## href

href是Hypertext Reference的简写，表示超文本引用，指向网络资源所在位置。

```
<a href="http://www.baidu.com"></a> 
<link type="text/css" rel="stylesheet" href="common.css"> 
```

## src

src是source的简写，目的是要把文件下载到html页面中去。

```
<img src="img/girl.jpg"></img> 
<iframe src="top.html"> 
<script src="show.js"> 
```

## 两者区别

作用结果:

- href 用于在当前文档和引用资源之间确立联系
- src 用于替换当前内容

浏览器解析方式

- 浏览器遇到href会并行下载资源且不会停止对当前文档的处理。(也是为什么建议使用 link 方式加载 CSS，而不是使用 @import 方式)
- 当浏览器解析到src ，会暂停其他资源的下载和处理，直到将该资源加载或执行完毕。(也是script标签为什么放在底部而不是头部的原因)