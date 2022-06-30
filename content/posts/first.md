---
title: "解决github pull/push 超时问题"
date: 2022-06-27T19:13:52+08:00
draft: false
resources:
- name: "featured-image"
  src: "featured-image.jpg"
tags: ["翻墙"]
categories: ["环境配置"]
typora-root-url: ..\..\static
---

步骤:

1. 查看翻墙软件的代理端口
![clash截图](/images/vpn.jpg "clash截图")
1. 修改git配置

### 全局
```bash
git config --global http.proxy http://127.0.0.1:端口号
git config --global https.proxy https://127.0.0.1:端口号
```
### 单个项目

```bash
git config --local http.proxy http://127.0.0.1:端口号
git config --local https.proxy https://127.0.0.1:端口号
```