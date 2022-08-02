---
title: "CrossDomain"
date: 2022-08-02T19:22:25+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

# 跨域
## 同源策略
所谓同源，指协议、域名、端口号相同。
浏览器处于安全考虑，只允许本域名下的接口交互，不同域名下的请求，就会出现跨域。


![url的组成](../../../static/images/1638b3579d9eeb32tplv-t2oaga2asx-zoom-in-crop-mark3024000.awebp)

## 为什么限制跨域访问
防范XSS攻击，如果不限制跨域访问，你先登录支付宝，浏览器就会保留你的登录状态，避免你每次访问支付宝的页面都去输入用户名和密码。然后你又去访问另一个网站。如果这个网站有恶意代码的话，就会利用浏览器里保留的支付宝的登录状态，去访问支付宝的网站，获取你的信息。

## 跨域限制与不限制
- Cookie , LocalStorage ,IndexedDB等存储性内容。
- DOM节点。
- AJAX请求发送后,非同源会被浏览器拦截。
> 请求跨域了,那么到底发出去没有? 跨域并不是请求发不出去,请求能发出去,服务端能收到请求并正常返回结果,只是结果被浏览器拦截了
允许跨域加载资源：
- `<img src=XXX>`
- `<link href=XXX>`
- `<script src=XXX>`
## 解决方案
### 1.JSONP
原理：利用script标签没有跨域限制的特点。
优点：兼容性好。
缺点：需要后端配合，只能发送get请求，容易遭受XSS攻击。
实现流程：将前端方法作为参数传递到服务器端，然后由服务器端注入参数之后再返回。
![image](https://segmentfault.com/img/remote/1460000012469724)
### 2.CORS（跨域资源共享）
详解：http://www.ruanyifeng.com/blog/2016/04/cors.html
原理： 服务器设置Access-Control-Allow-Origin打开CORS。该属性表示哪些域名可以访问资源。
副作用：发送请求会出现两种情况，分别为简单请求和复杂请求。
> 简单请求:
> 同时满足以下两个条件,就属于简单请求
> 1. 使用下列方法之一：
>     - GET
>     - POST
>     - HEAD
> 2. Content-Type的值只限于下列三者之一：
>     - text/plain
>     - multipart/form-data
>     - application/x-www-form-urlencoded 请求中的任意 XMLHttpRequestUpload 对象均没有注册任何事件监听器;  
>
> 复杂请求 : 
> 不符合条件的请求为复杂请求。在复杂请求正式通信前，会增加一次HTTP查询，成为预检请求，为option方法，通过该请求判断服务器是否允许跨域请求。


### 3.PostMessage
利用HTML5的API，postMessage()方法允许来自不同源的脚本采用异步方式进行有限的通信，可以实现跨文本档、多窗口、跨域消息传递。


### 4.webSocket
WebSocket不受跨域限制。
> 对应的库:socket.io,封装了websocket接口，也对不支持webSocket的浏览器提供了向下兼容。

### 5.服务器转发
- 利用nginx 反向代理
- 代理服务器
    
    > 例如:开发环境webpack的proxy

### 6.iframe
- window.name
- location.hash
- document.domain

## 引用
https://juejin.im/post/5c23993de51d457b8c1f4ee1#comment

http://182.92.151.65/docs/%E6%B5%8F%E8%A7%88%E5%99%A8/%E8%B7%A8%E5%9F%9F