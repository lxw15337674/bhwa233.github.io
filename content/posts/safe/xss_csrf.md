---
title: "网站的几种攻击方式"
date: 2022-08-08T14:23:15+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

![image-20220827220834833](/../../static/images/image-20220827220834833.png)

## CSRF

CSRF即Cross-site request forgery(跨站请求伪造)。CSRF攻击主要是利用自动发送的Cookie，借助Cookie来模拟用户的身份

例如：

假如黑客在自己的站点上放置了其他网站的外链，例如"www.weibo.com/api"，默认情况下，浏览器会带着weibo.com的cookie访问这个网址，如果用户已登录过该网站且网站没有对CSRF攻击进行防御，那么服务器就会认为是用户本人在调用此接口并执行相关操作，致使账号被劫持。

### 攻击方式

- 自动GET请求。
  黑客网页里面可能有一段这样的代码:

  ```html
  <img src="https://xxx.com/info?user=hhh&count=100"></img>
  ```

  进入页面后自动发送 get 请求，值得注意的是，这个请求会自动带上关于 xxx.com 的 cookie 信息(这里是假定你已经在 xxx.com 中登录过)。

- 自动POST请求。
  黑客可能自己填了一个表单，写了一段自动提交的脚本。

  ```html
  <form id='hacker-form' action="https://xxx.com/info" method="POST">
  <input type="hidden" name="user" value="hhh" />
  <input type="hidden" name="count" value="100" />
    </form>
    <script>document.getElementById('hacker-form').submit();</script>
  ```

- 诱导点击发送GET请求。
  在黑客的网站上，可能会放上一个链接，驱使你来点击:

  ```html
  <a href="https://xxx/info?user=hhh&count=100" taget="_blank">点击进入修仙世界</a>
  ```

## 防范措施

防御CSRF 攻击主要有三种策略：

- 验证HTTP Referer 字段。

  验证来源站点：通过请求头的Origin和Referer，其中，Origin只包含域名信息，而Referer包含了具体的 URL 路径。来确定请求是否是合法的源。但都可以伪造。

- 增加验证码输入

- 在请求地址中添加token 并验证。

  使用CSRF Token进行验证，首先，浏览器向服务器发送请求时，服务器生成一个字符串，将其植入到返回的页面中。
  然后浏览器如果要发送请求，就必须带上这个字符串，然后服务器来验证是否合法，如果不合法则不予响应。这个字符串也就是CSRF Token，通常第三方站点无法拿到这个 token, 因此也就是被服务器给拒绝。

- 在HTTP 头中自定义属性并验证。

  设置SameSite,可以对 Cookie 设置 SameSite 属性。该属性表示 Cookie不随着跨域请求发送，但浏览器兼容不一。

 >SameSite可以设置为三个值，Strict、Lax和None。
 >a. 在Strict模式下，浏览器完全禁止第三方请求携带Cookie。比如请求sanyuan.com网站只能在sanyuan.com域名当中请求才能携带 Cookie，在其他网站请求都不能。
 >b. 在Lax模式，就宽松一点了，但是只能在 get 方法提交表单况或者a 标签发送 get 请求的情况下可以携带 Cookie，其他情况均不能。
 >c. 在None模式下，也就是默认模式，请求会自动携带上 Cookie。


![image](/images/1460000012693783)

# XSS

XSS（cross site script）跨站脚本攻击，其原本缩写是 CSS，但为了和层叠样式表(Cascading Style Sheet)有所区分，因而在安全领域叫做 XSS。
指在网站中注入恶意代码，当用户浏览时，执行恶意代码，对用户浏览器进行控制或者获取用户隐私数据。

## 影响

1. 窃取cookie。
2. 监听用户行为，比如输入账号密码后直接发送到黑客服务器。
3. 修改DOM伪造登录表单。
4. 在页面中生成浮窗广告。

## 分类

### 反射型

简单地把用户输入的数据 “反射” 给浏览器，

一般常见于通过URL传递参数的功能，如网站搜索、跳转等。

攻击步骤：

1. 攻击者构造出特殊的URL，其实包含恶意代码。
2. 用户打开带有恶意代码的 URL 时，网站服务端将恶意代码从 URL 中取出，拼接在 HTML 中返回给浏览器。
3. 用户浏览器接收到响应后解析执行，混在其中的恶意代码也被执行。

常见场景：

1. 通过诱导用户点击一个恶意连接。

### 存储型

将用户输入的数据存储在服务端，当浏览器请求数据时，脚本从服务器上传回并执行。

一般常见于带有用户保存数据的网站功能，如发帖、评论、私信等。

常见场景：

1. 攻击者写一篇包含恶意代码的文章或评论，文章或评论发表后，所有访问该文章或评论的用户，都会在他们的浏览器中执行这段恶意代码。

与反射型区别：存储型 XSS 的恶意代码存在数据库里，反射型 XSS 的恶意代码存在 URL 里。


### 文档型（基于DOM）

文档型的 XSS 攻击并不会经过服务端，而是作为中间人的角色，在数据传输过程劫持到网络数据包，然后修改里面的 html 文档。

常见场景：

1. wifi挟持
2. DNS劫持

与前两种区别：DOM 型 XSS 攻击中，发生在浏览器端。而其他两种 XSS 都属于服务端的安全漏洞。

### 总结

![image](/images/1460000012693785)

## 防范措施

XSS特点是让恶意脚本直接能在浏览器中执行。所以防御的思路就是：对输入(和URL参数)进行过滤，对输出进行转义。

一个信念，两个利用。

1. 输入检查：不相信用户的输入，对用户输入的任何东西都进行转义。
2. 设置httpOnly：设置Cookie的HttpOnly属性，js便无法读取cookie的值。
3. 开启CSP，即浏览器中的内容安全策略，就是设立白名单。它的核心思想就是服务器决定浏览器加载哪些资源，可阻止白名单以外的资源加载和运行。具体来说可以完成以下功能:
   - 禁止加载外域代码，防止复杂的攻击逻辑。
   - 禁止外域提交，网站被攻击后，用户的数据不会泄露到外域。
   - 禁止内联脚本执行（规则较严格，目前发现 GitHub 使用）。
   - 禁止未授权的脚本执行（新特性，Google Map 移动版在使用）。
   - 合理使用上报可以及时发现 XSS，利于尽快修复问题。



# SQL注入

把SQL命令插入到请求中，欺骗服务器执行恶意的SQL命令。

## 常见场景

1. 模糊搜索
2. 登录界面

## 防范措施

1. 对输入内容进行转义。
2. 正则匹配过滤。
3. 账号、密码加密。



>参考
>
>[Web 安全总结](https://mp.weixin.qq.com/s?__biz=MzI0MzIyMDM5Ng==&mid=2649825865&idx=1&sn=a049c26b3f81d8657a6066b8e11a7f05&chksm=f175e88ac602619cd82cca9716d7054007470ac77ba1a2d5b23d667cd0e7af73ebeba62ce835&scene=21#wechat_redirect)
>
>[浅说 XSS 和 CSRF](https://github.com/dwqs/blog/issues/68)
>[如何防止XSS攻击？](https://juejin.im/post/5bad9140e51d450e935c6d64)
>[常见六大Web安全攻防解析 ](https://github.com/ljianshu/Blog/issues/56)