---
title: "富文本"
date: 2022-08-11T16:36:14+08:00
draft: true
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



## 富文本框架总结

##  第一代

基于`contenteditable`，基于DOM处理，通过封装一些对DOM操作的的API来进行富文本编辑。主要是直接提供一个现有的编辑器使用，扩展性相对差一些。

**UEditor**：百度出品，暂停维护。

**TinyMCE** ：付费。

**CKEditor** : 付费。



## 第二代

**Quill** :  支持插件功能，可以扩展功能。



### Draft.js

Facebook出品，仅能用于React。主要基于`mmutable.js `

缺点：

1. draft的内容结构是扁平状的，无法在一个block底下存入另一个 child block，无法将整个 Document model 设计成树状结构。 
2. ContentState 的格式架构与原生的 DOM 架构存在不小的差异，如果需要转换会比较麻烦。

### Slate.js

基于`ImmerJS`

### TinyMCE

 付费。

### CKEditor

 付费。



## 总结

|   Name   |       Type       | 唯一真值表示法（ SSOT） |                        Document Model                        | Customizability |      Provided apis       |  See contenteditable as  | Bundle size from [BUNDLEPHOBIA](https://bundlephobia.com/) | Repository Type |
| :------: | :--------------: | :---------------------: | :----------------------------------------------------------: | :-------------: | :----------------------: | :----------------------: | :--------------------------------------------------------: | :-------------: |
| CKEditor |      editor      |      HTML Document      |                             none                             |      weak       |      DOM api 语法糖      |     Complete editor      |          MINIFIED: 280.6 (ckeditor5-core@29.0.0)           |   multi-repo    |
| TinyMCE  |      editor      |      HTML Document      |                             none                             |      weak       |      DOM api 语法糖      |     Complete editor      |                     MINIFIED: 399.7KB                      |   monolithic    |
| Quill.js |      editor      |     Document Model      |      [Parchment](https://github.com/quilljs/parchment)       |     middle      | 实质性对Data Model的操作 | pluggable implementation |                     MINIFIED: 209.5KB                      |   multi-repo    |
| Draft.js | editor-framework |     Document Model      | ContentState ( Based on [Immutable.js](https://github.com/immutable-js/immutable-js/) ) |     strong      | 实质性对Data Model的操作 | pluggable implementation |                     MINIFIED: 217.3KB                      |   monolithic    |
| Slate.js | editor-framework |     Document Model      |                      Plain JSON Object                       |     strong      | 实质性对Data Model的操作 | pluggable implementation |                      MINIFIED: 64.8KB                      |    mono-repo    |



>参考资料：
>
>[[深入 slate.js ｘ 一起打造專屬的富文字編輯器吧！](https://ithelp.ithome.com.tw/users/20139359/ironman/4447)]
>
>[开源富文本编辑器技术的演进（2020 1024）](https://zhuanlan.zhihu.com/p/268366406)
