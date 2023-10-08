---
title: "原理题"
date: 2022-09-04T15:24:04+08:00
tags: [""]
categories: ["面试"]
typora-root-url: ..\..\static
---



## Ajax、Axios、Fetch的核心区别

**Ajax**

传统 Ajax 指的是 XMLHttpRequest（XHR），核心使用XMLHttpRequest对象

缺点：

- 回调地狱
- 存在安全问题，CSRF攻击，XSS攻击，需要处理。

对原生XHR的封装

**Axios**

对原生XHR的封装，基于Promise管理请求，解决Ajax问题。

**防止CSRF:就是让你的每个请求都带一个从cookie中拿到的key, 根据浏览器同源策略，假冒的网站是拿不到你cookie中得key的，这样，后台就可以轻松辨别出这个请求是否是用户在假冒网站上的误导输入，从而采取正确的策略。**

**Fetch**

ES6新增的通信方法，没有使用XMLHttpRequest对象。

缺点：

- fetch只对网络请求报错，对400，500都当做成功的请求，服务器返回 400，500 错误码时并不会 reject，只有网络错误这些导致请求不能完成时，fetch 才会被 reject。 
- fetch默认不会带cookie，需要添加配置项： fetch(url, {credentials: 'include'}) 
- fetch不支持abort，不支持超时控制，使用setTimeout及Promise.reject的实现的超时控制并不能阻止请求过程继续在后台运行，造成了流量的浪费
- fetch没有办法原生监测请求的进度，而XHR可以




