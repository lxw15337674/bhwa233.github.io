---
title: "node-sass报错解决"
date: 2022-06-30T20:08:22+08:00
draft: false
tags: ["环境"]
categories: [""]
typora-root-url: ..\..\static
---

node-sass不仅下载编译慢，在window环境下总会报错。

#### 解决办法

1. 使用dart-sass替代node-sass

```js
npm install node-sass@npm:dart-sass 
```

这样会写到lock文件中，后面不再需要安装node-sass。

2.  使用sass代替

```js
npm install node-sass@npm:sass
```

