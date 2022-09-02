---
title: "Link标签"
date: 2022-08-21T13:13:13+08:00
draft: false
tags: ["html"]
categories: ["html"]
typora-root-url: ..\..\static
---

## 概述

[link](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FHTML%2FElement%2Flink) 元素用于链接外部`css`样式表等其他相关外部资源。

### 属性

- `href`：指明外部资源文件的路径，即告诉浏览器外部资源的位置
- `hreflang`：说明外部资源使用的语言
- `media`：说明外部资源用于哪种设备
- `rel`：必填，表明当前文档和外部资源的关系
- `sizes`：指定图标的大小，只对属性`rel="icon"`生效
- `type`：说明外部资源的 [MIME](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FHTTP%2FBasics_of_HTTP%2FMIME_types) 类型，如`text/css`、`image/x-icon`

## 应用场景

### 链接样式表 

```xml
<link href="main.css" rel="stylesheet">
```



### 创建站点图标

```xml
<link rel="icon" type="image/png" href="myicon.png">
```



### 预加载

用于前端界面性能优化，rel 的属性值可以为preload、prefetch、dns-prefetch。

```xml
<link rel="preload" href="style.css" as="style">
<link rel="prefetch" href="/uploads/images/pic.png">
<link rel="dns-prefetch" href="//fonts.googleapis.com">
```



### prefetch 预获取

用户在使用当前界面时，浏览器空闲时先把下个界面要使用的资源下载到本地缓存。浏览器下不下载不可知。
举个例子： 网站有A，B 两个界面。当用户访问界面 A 时有很大的概率会访问 B 界面（比如登录跳转）那么我们可以在用户访问界面 A 的时候，提前将 B 界面需要的某些资源下载到本地，性能会得到很大的提升。那么我们只需要在界面 A.html 文件中设置如下代码：

```xml
<link rel="prefetch" href="/uploads/images/pic.png">
```



### preload 

控制当前界面的资源下载优先级，浏览器必须下载资源。
举个例子： 网站的一个界面 A的 css 样式文件中使用了外部字体文件，正常情况下该字体的下载是在 css 解析的时候完成的。想想字体文件好像在 css 样式文件解析之前下载到本地比较好。那么我们就可以在head标签设置字体的 preload。

```xml
<link rel="preload" href="https://example.com/fonts/font.woff" as="font">
```



### dns-prefetch

DNS Prefetch 是一种 DNS 预解析技术。当你浏览网页时，浏览器会在加载网页时对网页中的域名进行解析缓存，这样在你单击当前网页中的连接时就无需进行 DNS 的解析，减少用户等待时间，提高用户体验。



### prefetch & preload 对比

- 关注的页面不同： prefetch 关注要使用的页面，preload 关注当前页面
- 资源是否下载：prefetch 的资源下载情况未知（只在浏览器空闲时会下载），preload 肯定下载



## media 属性

media 属性规定被链接文档将显示在什么设备上。

```xml
<head>
<link rel="stylesheet" type="text/css" href="theme.css" />
<link rel="stylesheet" type="text/css" href="print.css" media="print"/>
</head>
```

注意： 当界面加载时，两个样式表都会下载到客户端，只是会根据场景不同使用不同的样式。



> 引用
>
> [HTML5 之 Link 标签](https://juejin.cn/post/6971640926389141518)
>
> [script、link标签详解](https://juejin.cn/post/6844903746023997448)