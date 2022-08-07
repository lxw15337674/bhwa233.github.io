---
title: "前端跨页面通信总结"
date: 2022-08-07T23:04:49+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static

---

> 详解看[面试官：前端跨页面通信，你知道哪些方法？](https://juejin.cn/post/6844903811232825357)，这里只做总结。

在浏览器中，每个Tab页可以粗略理解为一个“独立”的运行环境，即使是全局对象也不会在多个Tab页间共享。但有些场景，需要Tab间之间同步一些数据。

## 同源页面间的通信

### 广播模式

即一个页面将消息通知给一个“中央站”，再由“中央站”通知给各个页面。

- BroadCast Channel

  创建一个用于广播的通信频道。当所有页面都监听同一频道的消息，

- Service Worker

  多页面可以共享一个Service Worker ，将Service Worker作为消息的处理中心。

- LocalStorage

  消息写入到LocalStorage 中；然后在各个页面内，通过监听`storage`事件接收通知。

### 共享存储+长轮询方式

共享存储空间，但无法主动通知，需要通过轮询方式，获取最新数据。

- Service Worker
- IndexedDB

- cookie

### 口口相传模式

使用`window.open`打开页面时，方法会返回一个被打开页面`window`的引用。而在未显示指定`noopener`时，被打开的页面可以通过`window.opener`获取到打开它的页面的引用 

- window.open + window.opener

## 非同源页面之间的通信

可以通过嵌入同源 iframe 作为“桥”，将非同源页面通信转换为同源页面通信