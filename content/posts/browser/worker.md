---
title: "各种Worker"
date: 2022-08-07T23:44:59+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## web worker

JS是单线程没有多线程，当JS在页面中运行长耗时同步任务的时候就会导致页面假死。为了解决这个问题，HTML5提供了新的API`web worker`，可以通过另外开辟一个独立的 JS 线程来运行这些高耗时的 JS 代码。

### 特点

1. 独立运行环境

   - 一个独立于JavaScript主线程的线程，在里面执行需要消耗大量资源的操作不会堵塞主线程。

   - worker一旦新建，就会一直运行，不会被主线程的活动打断。

2. 作用域在本Tab页内。

   - 只能服务于新建它的页面，不同页面之间不能共享同一个 Web Worker。

   - 当页面关闭时，该页面新建的 Web Worker 也会随之关闭，不会常驻在浏览器中。

3. 一个页面可以创建多个web worker。

### 限制

1. 同源限制
   worker线程执行的脚本文件必须和主线程的脚本文件同源。

2. 不能读取本地文件
   为了安全，worker线程无法读取本地文件，它所加载的脚本必须来自网络，且需要与主线程的脚本同源。

3. 不能访问DOM

   worker线程在与主线程的window不同的另一个全局上下文中运行，其中无法读取主线程所在网页的DOM对象，也不能获取 `document`、`window`等对象，但是可以获取`navigator`、`location(只读)`、`XMLHttpRequest`、`setTimeout族`等浏览器API。

4. 通信限制
   worker线程与主线程不在同一个上下文，不能直接通信，需要通过`postMessage`方法来通信。

5. 脚本限制
   worker线程不能执行`alert`、`confirm`，但可以使用发送请求

## service worker

基于web worker，通过注册之后，可以独立于浏览器在后台运行，控制我们的一个或者多个页面。如果我们的页面在多个窗口中打开，Service Worker不会重复创建。

一般作为 Web 应用程序、浏览器和网络之间的代理服务。他们旨在创建有效的离线体验，拦截网络请求，以及根据网络是否可用采取合适的行动，更新驻留在服务器上的资源。他们还将允许访问推送通知和后台同步 API。

### 特点
在页面中注册并安装成功后，运行于浏览器后台，不受页面刷新的影响，可以监听和拦截作用域范围内所有页面的 HTTP 请求。


### 特性

- 在web worker的基础上增加了离线缓存的能力
- 其生命周期与页面无关（关联页面未关闭时，它也可以退出，没有关联页面，它也可以启动）
- 由事件驱动的,具有生命周期
- 可以访问cache和indexDB
- 支持推送。

### 注意事项

- 不能访问DOM
- 它设计为完全异步，同步API（如XHR和localStorage）不能在service worker中使用。可以使用fetch替代`XMLHttpRequest` 实现异步请求(ajax)。
- 网站必须使用 HTTPS。除了使用本地开发环境调试时(如域名使用 `localhost`)
- 

### 生命周期

```
install -> installed -> actvating -> Active -> Activated -> Redundant
```

安装中、安装后、激活中、激活、激活后、我废了。

### 应用场景

1. 监控页面的卡顿、崩溃，通过心跳
2. mock数据
3. PWA

>Progressive Web Apps :
>
>- **渐进增强** – 能够让每一位用户使用，无论用户使用什么浏览器，因为它是始终以渐进增强为原则。
>- **响应式用户界面** – 适应任何环境：桌面电脑，智能手机，笔记本电脑，或者其他设备。
>- **不依赖网络连接** – 通过 Service Workers 可以在离线或者网速极差的环境下工作。
>- **类原生应用** – 有像原生应用般的交互和导航给用户原生应用般的体验，因为它是建立在 app shell model 上的。
>- **持续更新** – 受益于 Service Worker 的更新进程，应用能够始终保持更新。
>- **安全** – 通过 HTTPS 来提供服务来防止网络窥探，保证内容不被篡改。
>- **可发现** – 得益于 W3C manifests 元数据和 Service Worker 的登记，让搜索引擎能够找到 web 应用。
>- **再次访问** – 通过消息推送等特性让用户再次访问变得容易。
>- **可安装** – 允许用户保留对他们有用的应用在主屏幕上，不需要通过应用商店。
>- **可连接性** – 通过 URL 可以轻松分享应用，不用复杂的安装即可运行。



## Shared Worker

由同源的所有页面共享。

### 与普通 Worker 区别

1、 同一个js脚本会创建一个 sharedWorker，其他页面再使用同样的脚本创建sharedWorker，会复用已创建的 worker，这个worker由几个页面共享

2、 sharedWorker通过port来发送和接收消息





### 相关资料

[Service Worker 应用详解]([https://lzw.me/a/pwa-service-worker.html#9%20%E5%85%B6%E4%BB%96%E7%9B%B8%E5%85%B3%E5%8F%82%E8%80%83](https://lzw.me/a/pwa-service-worker.html#9 其他相关参考))

[Service Worker初探](https://juejin.im/post/6844903972759666701)

[Service Worker 从入门到出门](https://juejin.im/post/6844903887296528398)

[Web Worker 使用教程](http://www.ruanyifeng.com/blog/2018/07/web-worker.html)

[让Web Worker来给你的网页提提速](https://juejin.cn/post/7055456291493249054)