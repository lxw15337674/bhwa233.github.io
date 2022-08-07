---
title: "Hugo lovelt的搜索坑"
date: 2022-08-06T19:30:28+08:00
draft: false
tags: ["hugo"]
categories: ["笔记"]
typora-root-url: ..\..\static
---



lovelt主题的[搜索](https://hugoloveit.com/zh-cn/theme-documentation-basics/#5-%E6%90%9C%E7%B4%A2)，提供了[Lunr.js](https://lunrjs.com/) 、[algolia](https://www.algolia.com/), 两个搜索引擎，但是都很麻烦。

首先`lunr`简单，但不支持中文检索，中文分词依赖库很久都没更新了，我都试下也不能用。

`algolia` ，配置比较麻烦，还需要注册账号，上传索引，具体操作参考[Hugo 集成 Algolia 搜索](https://www.qikqiak.com/post/hugo-integrated-algolia-search/)。然而当我认为可以用时，又发现了问题，`hugo-algolia`生成索引中跳转的路径都不对。于是需要一个一个解决。

## 路径大小写问题

`hugo-algolia`生成的路径是存在大小写的。看图中的uri：

![image-20220806194901626](/images/image-20220806194901626.png)

但`hugo`页面上的路径会默认全部转为小写。

![image-20220806195549873](/images/image-20220806195549873.png)



解决办法：配置`disablePathToLower` 为`true`（[见官方论坛回答](https://discourse.gohugo.io/t/disable-hugo-case-sensitive-url-matching/2498)）。



## 相对路径问题

`hugo-algolia`默认生成的uri是相对路径，会导致不在首页下的搜索都出现问题（具体在这个[issues](https://github.com/dillonzq/LoveIt/issues/421)里）。

为了解决这个问题，我修改了[hugo-algolia](https://github.com/replicatedhq/hugo-algolia)源码，搞了一个新的包[hugo-lovelt-algolia](https://github.com/lxw15337674/hugo-lovelt-algolia)，增加`baseURL`配置，可以将uri变为绝对路径。

