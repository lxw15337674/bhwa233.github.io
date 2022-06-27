---
title: "First_post"
date: 2022-06-27T19:13:52+08:00
draft: false
---
# 解决github pull/push 超时问题
1. 查看全局代理端口
2. 修改git配置
git config --global http.proxy http://127.0.0.1:端口号
git config --global https.proxy https://127.0.0.1:端口号
