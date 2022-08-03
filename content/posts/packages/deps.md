---
title: "搞懂各种依赖"
date: 2022-08-03T17:25:59+08:00
draft: false
tags: [""]
categories: ["笔记"]
typora-root-url: ..\..\static
---

## dependencies

**运行时依赖**，生产环境需要的依赖，会被打包的依赖。

## devDependencies

**开发时依赖**，开发环境需要安装的依赖，不会被打包。

## peerDependencies

**宿主依赖**，指定了当前模块在使用前需要安装的依赖，可以避免依赖的核心依赖库被重复下载。

一般用于插件开发时会用到，例如`html-webpack-plugin` 的开发依赖于 `webpack`，组件库依赖`react`等。

## resolutions

yarn 中特有，指定依赖的特定版本或者版本范围。我们希望指定工程直接依赖里的某个子依赖包的版本时，可以使用 `resolutions`

```json
{
  "name": "project",
  "version": "1.0.0",
  "dependencies": {
    "left-pad": "1.0.0",
    "c": "file:../c-1",
    "d2": "file:../d2-1"
  },
  "resolutions": {
    "d2/left-pad": "1.1.1",
    "c/**/left-pad": "1.1.2"
  }
}
// 直接指定依赖 d2 所依赖的 left-pad 版本为 1.1.1。
```



>扩展：
>
>[一文搞懂peerDependencies](https://segmentfault.com/a/1190000022435060)
>
> [Yarn resolutions](https://soonwang.cn/2021/08/01/yarn-resolutions/)
>
>[选择性依赖项解决](https://chore-update--yarnpkg.netlify.app/zh-Hans/docs/selective-version-resolutions)
