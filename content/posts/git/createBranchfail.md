---
title: "git创建分支失败"
date: 2022-08-11T11:01:51+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

# 报错

Invalid reference name

# 原因

仓库中已经存在了一个分支名称为 {branch} 的分支，就不能在新建一个 {branch}/{subName} 这样的额分支，比如仓库中有个分支叫 bugfix 那么再新建一个 bugfix/fix1 这样的分支就会报如上的错误。

主要是因为Git在版本分支信息是以文件夹的形式保存的，在项目的 .git 目录中可以看到，无法在存在一个 文件的情况下，再新建一个同名的文件夹。

![img](/../../static/images/image2022-5-19_16-56-44.png)

# 解决方案

方案1：删除原来的分支（自行确定是否可进行删除操作）。

方案2：更改新建分支的名称，避开把已经存在的分支作为分支前缀的情况。
