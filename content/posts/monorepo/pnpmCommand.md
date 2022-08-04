---
title: "Pnpm关于monorepo相关命令"
date: 2022-08-03T16:03:44+08:00
draft: false
tags: [""]
categories: ["笔记"]
typora-root-url: ..\..\static
---

### 安装全局依赖

```bash
pnpm i lodash -w #安装lodash到根目录
# -w(--workspace-root)  要安装到根目录
# -D  安装公共开发环境依赖
```

### 安装局部依赖

```bash
pnpm add axios --filter @monorepo/http  # 安装axios依赖到@monorepo/http子项目
```

> 也可以到子项目执行 `pnpm install axios`

### 子项目互相依赖

```bash
pnpm add @monorepo/http@* --filter @monorepo/web # 安装@monorepo/http到@monorepo/web子项目
```

### 取消依赖

```bash
pnpm remove axios
pnpm remove axios --filter  @monorepo/http
```

