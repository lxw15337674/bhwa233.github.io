---
title: "HMR"
date: 2022-07-31T15:57:49+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 详解

https://juejin.im/post/5df36ffd518825124d6c1765 

https://juejin.im/post/5d8db37051882530d438535c 

https://juejin.im/post/5c86ec276fb9a04a10301f5b

https://zhuanlan.zhihu.com/p/30669007

## 概念

Hot Module Replacement（以下简称 HMR） 

当你对代码进行修改并保存后，webpack 将对代码重新打包，并将新的模块发送到浏览器端，浏览器通过新的模块替换老的模块，这样在不刷新浏览器的前提下就能够对应用进行更新。

## 基本原理

> Webpack watch：使用监控模式开始启动 webpack 编译，在 webpack 的 watch 模式下，文件系统中某一个文件发生修改，webpack 监听到文件变化，根据配置文件对模块重新编译打包，每次编译都会产生一个唯一的 hash 值，

构建 bundle 的时候，加入一段 HMR runtime 的 js 和一段和服务沟通的 js 。文件修改会触发 webpack 重新构建，服务器通过向浏览器发送更新消息，浏览器通过 jsonp 拉取更新的模块文件，jsonp 回调触发模块热替换逻辑。

## 工作流程

1.启动dev-server，webpack开始构建，在编译期间会向 entry 文件注入热更新代码；

2.Client 首次打开后，Server 和 Client 基于WebSocket建立通讯渠道；

3.修改文件，Server 端监听文件发送变动，webpack开始编译，直到编译完成会触发"Done"事件；

4.Server通过socket 发送消息告知 Client；

5.Client根据Server的消息（hash值和state状态），通过ajax请求获取 Server 的manifest描述文件；

6.Client对比当前 modules tree ，再次发请求到 Server 端获取新的JS模块；

7.Client获取到新的JS模块后，会更新 modules tree并替换掉现有的模块；

8.最后调用 module.hot.accept() 完成热更新；