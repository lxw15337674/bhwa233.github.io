---
title: "DNS解析"
date: 2022-09-04T12:07:55+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



## 总结

DNS解析：根据域名找到对应的IP地址。

ISP：互联网服务提供商（如中国电信）。

根DNS服务器：国际顶级域名服务器，如.com,.cn等。

DNS域名系统：是应用层协议，运行UDP协议之上，使用端口43。

### 查询顺序

浏览器缓存-->操作系统缓存-->本地host文件-->路由器缓存-->ISP DNS缓存-->根DNS服务器。


![image](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/89356512-95168e80-d6f0-11ea-93aa-c4f59fd36942.png)

### 查询方式

DNS查询分为两种方式：递归查询和迭代查询。

递归查询：递归查询指的是查询请求发出后，域名服务器代为向下一级域名服务器发出请求，最后向用户返回查询的最终结果。使用递归 查询，用户只需要发出一次查询请求。

迭代查询：迭代查询指的是查询请求后，域名服务器返回单次查询的结果。下一级的查询由用户自己请求。使用迭代查询，用户需要发出 多次的查询请求。

所以一般而言，**「本地服务器查询是递归查询」**，而**「本地 DNS 服务器向其他域名服务器请求的过程是迭代查询的过程」**。


![image-20220904120837596](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/image-20220904120837596.png)



## DNS 为什么使用 UDP 协议作为传输层协议？

**「DNS 使用 UDP 协议作为传输层协议的主要原因是为了避免使用 TCP 协议时造成的连接时延。」**

- 为了得到一个域名的 IP 地址，往往会向多个域名服务器查询，如果使用 TCP 协议，那么每次请求都会存在连接时延，这样使 DNS 服务变得很慢。
- 大多数的地址查询请求，都是浏览器请求页面时发出的，这样会造成网页的等待时间过长。

## 性能优化

每一次DNS解析时间预计在20-120毫秒

- 减少DNS请求次数

  一个页面中尽可能少用不同的域名：资源都放在相同的服务器上。

> 但项目中不会这么干，项目中往往会把不同资源放在不同的服务器上。
>
> 服务器拆分优势：
>
> 1. 资源合理利用
>
> 2. 抗压能力加强
>
> 3. 提高HTTP并发
>
>    同一个源，浏览器只会并发4-7个请求，不同源可以并发更多请求。

- DNS预获取

  尝试在请求资源之前解析域名。[MDN详解](https://developer.mozilla.org/zh-CN/docs/Web/Performance/dns-prefetch)

```html
<link rel="dns-prefetch" href="https://fonts.googleapis.com/">
```



> [为什么 DNS 使用 UDP 协议](https://draveness.me/whys-the-design-dns-udp-tcp/)
