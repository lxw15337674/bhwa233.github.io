---
title: "pnpm"
date: 2022-07-07T11:35:22+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

为什么使用pnpm？

解决两个问题：

**相同依赖多次保存，占用磁盘空间安装慢。**

多个项目依赖一个相同的包，例如`react@17.0.13` ，用`npm`或`yarn`时，每个项目都会在各自的`node_modules `保存的React包,。

解决方法：集中化保存依赖。

如果使用`pnpm` 安装依赖，它首先会将依赖下载到一个公共仓库（`~/.pnpm-store`）。在项目中的`node_modules`中创建依赖的硬链接指向公共仓库，而不会将包保存到`node_modules`。

#### 幽灵依赖

`npm`最开始的 `node_modules` 采用嵌套结构，因为会把所有的依赖和依赖中的所有东西都打包到 `node_modules` 文件夹下。

比如项目依赖了 A 和 C，而 A 和 C 依赖了不同版本的 `B@1.0` 和 `B@2.0`，`node_modules` 结构如下：

```undefined
node_modules
├── A@1.0.0
│ └── node_modules
│   └── B@1.0.0
└── C@1.0.0
  └── node_modules
    └── B@2.0.0
```

如果 D 也依赖 `B@1.0`，会生成如下的嵌套结构：

```undefined
node_modules
├── A@1.0.0
│ └── node_modules
│   └── B@1.0.0
├── C@1.0.0
│ └── node_modules
│   └── B@2.0.0
└── D@1.0.0
  └── node_modules
    └── B@1.0.0
```

可以看到同版本的 B 分别被 A 和 D 安装了两次。即依赖地狱。

> 依赖地狱 Dependency Hell
>
在真实场景下，依赖增多，冗余的包也变多，`node_modules` 最终会堪比黑洞，很快就能把磁盘占满。而且依赖嵌套的深度也会十分可怕，这个就是依赖地狱。
>



为了解决依赖地狱。`npm` v3将 采用扁平的 `node_modules` 结构，子依赖会尽量平铺安装在主依赖项所在的目录中。

```
node_modules
├── A@1.0.0
├── B@1.0.0
└── C@1.0.0
  └── node_modules
    └── B@2.0.0
```




导致在`package.json`中没有声明依赖，但仍可以在项目中正常被 import。



解决方法：`pnpm` 会将每个依赖项安装在 `.pnpm` 的对应目录（包名+版本）中，然后将你已经在项目的 package.json 中明确定义的那些依赖“移动”（创建一个链接指向 `.pnpm` 中的对应模块）到项目的 `node_modules` 中。

