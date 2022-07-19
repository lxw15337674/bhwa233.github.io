---
title: "解决github pull/push 超时问题"
date: 2022-06-27T19:13:52+08:00
draft: false
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
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890
```
### 单个项目

```bash
git config --local http.proxy http://127.0.0.1:7890
git config --local https.proxy https://127.0.0.1:7890
```

### 只对 GitHub 进行代理

```bash
git config --global http.https://github.com.proxy https://127.0.0.1:7890
git config --global https.https://github.com.proxy https://127.0.0.1:7890
```

### socks5代理

```bash
git config --global http.https://github.com.proxy socks5://127.0.0.1:7890
git config --global https.https://github.com.proxy socks5://127.0.0.1:7890
```

### 查看已有配置

```bash
git config --global -l
```

### 取消代理
```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```
