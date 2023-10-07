---
title: "get与post请求区别"
date: 2022-08-08T14:14:23+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## http常用方法
方法| 作用
--|--|
GET|请求数据
HEAD|用于获取报头，无返回内容
POST| 进行资源修改
PUT | 更新
DELETE |删除
CONNECT | HTTP1.1 协议中预留给将连接改为管道方式的代理服务器
OPTIONS | 预检请求
TRACE  | 用于测试或诊断

## GET 和 POST 区别
### 虚假区别
- GET在浏览器回退时是无害的，而POST会再次提交 
- GET产生的URL地址可以被收藏，而POST不可以  
- GET请求会被浏览器主动缓存，而POST不会除非主动设置
- GET只能进行url编码，而POST支持多种编码
- GET请求参数会被完整的保留在浏览器历史记录中而POST的参数不会
- GET请求在URL传送的参数的长度有限，而POST没有限制
- GET只能接受ASCII字符，而POST没有限制
- GET比POST更不安全，因为参数直接暴露在URL上
- GET参数通过URL传递，而POST放在Request body（请求体）中 


### 终极区别
- GET请求是幂等性的，POST请求不是。
> 幂等性，指的是对某一资源进行一次或多次请求都具有相同的副作用。例如搜索就是一个幂等的操作，而删除、新增则不是一个幂等操作。

由于GET请求是幂等的，在网络不好的环境中，GET请求可能会重复尝试，造成重复操作数据的风险，因此，GET请求用于无副作用的操作(如搜索)，新增/删除等操作适合用POST

- GET产生一个TCP数据包；POST产生两个TCP数据包。
> get请求时，浏览器会把headers和data一起发送出去，服务器响应200（返回数据），
> 
> post请求时，浏览器先发送headers，服务器响应100 continue，浏览器再发送data，服务器响应200（返回数据）。

### 详解
[99%的人都理解错了HTTP中GET与POST的区别
](https://www.jianshu.com/p/678ff764a253)