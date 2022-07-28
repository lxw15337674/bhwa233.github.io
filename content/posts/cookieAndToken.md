---
title: "CookieAndToken"
date: 2022-07-28T22:43:24+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## cookie

登陆后后端生成一个sessionid放在cookie中返回给客户端，并且服务端一直记录着这个sessionid，客户端以后每次请求都会带上这个sessionid，服务端通过这个sessionid来验证身份之类的操作。所以别人拿到了cookie拿到了sessionid后，就可以完全替代你。

- cookie可以存一些用户信息。因为 HTTP 是无状态的，它不知道你有没有登陆过。故可以通过cookie里的信息解决无状态的问题。

- 而浏览器，会自动带上请求同域的cookie。（AJAX 不会自动携带cookie）

举例：服务员看你的身份证，给你一个编号，以后，进行任何操作，都出示编号后服务员去看查你是谁。

## token

登陆后后端不返回一个token给客户端，客户端将这个token存储起来，然后每次客户端请求都需要开发者手动将token放在header中带过去，服务端每次只需要对这个token进行验证就能使用token中的信息来进行下一步操作了。

- 一般是基于jwt。
- 后端把用户信息和其他内容放进去，通过 jwt 生成 token，返回给前端。
- 浏览器是不会自动携带 token。

举例：直接给服务员看自己身份证

## CSRF 跨站点请求伪造

通过浏览器会自动携带同域cookie的特点。cookie的传递流程是用户在访问站点时，服务器端生成cookie，发送给浏览器端储存，当下次再访问时浏览器会将**该网站**的cookie发回给服务器端

- 如果用户登陆了A网站，拿到了cookie，又点击了恶意的网站B。
- B收到请求以后，返回一段攻击代码，并且发出一个请求给网站A。
- 浏览器会在用户不知情的情况下，根据B的请求，带着cookie访问A。

由于HTTP是无状态的，A网站不知道这个请求其实是恶意网站B发出的，就会根据cookie来处理请求，从而执行了攻击代码。

而浏览器不会自动携带 token，所以不会劫持 token。