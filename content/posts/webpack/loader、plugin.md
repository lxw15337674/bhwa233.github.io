---
title: "webpack 中 loader 和 plugin"
date: 2022-08-01T23:17:54+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## loader

webpack自身只支持js和json这两种格式的文件，对于其他文件需要通过loader将其转换为commonJS规范的文件后，webpack才能解析到。

它是一个转换器，将A文件进行编译成B文件，比如：将A.less转换为A.css，单纯的文件转换过程。

### 常用loaders

| 名称                 | 描述                                                         |
| -------------------- | ------------------------------------------------------------ |
| babel-loader         | 转换js新特性语法                                             |
| stylus-loader        | 将stylus文件转换成css                                        |
| css-loader           | 将css文件打包到js中                                          |
| style-loader         | 将 css 代码以<style>标签的形式插入到 html 中。               |
| ts-loader            | 将ts转换为js                                                 |
| file-loader          | 生成文件的文件名就是文件内容的 MD5 哈希值并会保留所引用资源的原始扩展名 |
| url-loader           | 把图片以Base64格式打包到bundle.js文件中                      |
| raw-loader           | 将文件以字符串的形式导入                                     |
| thread-loader        | 多进程打包js和css                                            |
| image-webpack-loader | 压缩图片大小                                                 |
| vue-loader           | vue文件的一个加载器，跟template/js/style转换成js模块。       |

**编写原则**:

- **单一原则**: 每个 Loader 只做一件事；
- **链式调用**: Webpack 会按顺序链式调用每个 Loader；
- **统一原则**: 遵循 Webpack 制定的设计规则和结构，输入与输出均为字符串，各个 Loader 完全独立，即插即用；

## plugin

是用于在webpack打包编译过程里，在对应的事件节点里执行自定义操作，比如资源管理、bundle文件优化等操作。

plugin是一个扩展器，它丰富了webpack本身，针对是loader结束后，webpack打包的整个过程，它并不直接操作文件，而是基于事件机制工作，会监听webpack打包过程中的某些节点，执行广泛的任务



| 名称                        | 描述         |
| --------------------------- | ------------ |
| progress-bar-webpack-plugin | 编译进度条   |
| compression-webpack-plugin  | gzip 压缩    |
| happypack                   | 多线程处理   |
| webpack-merge               | 配置合并     |
| splitChunksPlugin           | 代码分隔     |
| CommonsChunkPlugin          | 代码分割     |
| DefinePlugin                | 定义全局变量 |



>  参考
>
> [ webpack 中 loader 和 plugin 的区别是什么](https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/308)
>
> 