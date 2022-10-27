---
title: "vscode 插件开发踩坑"
date: 2022-10-12T16:38:06+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



中文翻译文档：https://liiked.github.io/VS-Code-Extension-Doc-ZH/#/

### 关于@types/node 报错

 不知道为什么，使用默认的版本会报错，经过测试需要这个版本正常：

```
 "@types/node": "16.11.7",
```



关于命令显示

注意package的配置,如果vscode配置的版本高于本地的vscode就不会显示命令。

```json
"engines": {
	"vscode": "^1.71.0"
 }, 
```

