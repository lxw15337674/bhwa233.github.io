---
title: "draft.js 组件 Dev Design"
date: 2022-06-30T19:49:45+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## 一、Overview

富文本输入框，支持插入属性组，先选择属性，再选择属性组。

![clash截图](/images/20220630.png "clash截图")

## 二、实现特性

1. 富文本的属性组组件

## 三、详细设计

### 关于框架

基于Draft.js进行扩展

### 数据结构

后端会通过json的形式进行保存。

则识别属性组组件方式：

#### HTML

缺点：

1. 不能同步属性组配置变化
2. 自行实现html2draft

数据结构：

格式化：自己实现`convertoHtmL` 转为html保存

反格式化：通过draft.js的`convertFromHTML`转为draft.js

#### 一个ContextBlock

数据结构：
通过特定的数据格式保存：

1. 有属性值的属性：`[#keyId:valueId]` 
2. 没有属性值的属性：`[#keyId:]` 

[[匹配的正则](https://jex.im/regulex/#!flags=g&re=\[[0-9a-zA-Z]%2B%3A[0-9a-zA-Z]*\])](https://jex.im/regulex/#!flags=g&re=\[[0-9a-zA-Z]%2B%3A[0-9a-zA-Z]*\])

优点：可以通过输入特定格式直接识别

缺点：多种组件类型会出现输入问题。

踩坑：

- 可以通过正则转换为单选，但是光标处于单选组件都无法输入，无法删除，无法空格。

  解决思路：

  - 判断光标要移动到组件时，跳过组件。
  - 判断光标要删除组件时，手动删除组件的text。

- 光标处于单选组件前一位、后一位时不会显示光标。

  解决思路：在组件前后增加空格文本，但因为选中时会显示出空文本，可能会覆盖掉。

- 必要要用span元素来重写选择组件。

- 需要onChange时判断光标。

- 通过设置属性组组件`contentEditable` 可以跳过光标。

- 当属性组在最后一个时，输入报错。

![img](/images/企业微信截图_16565901851803.png)

	解决方法：需要在自定义组件的根元素上加上key。

![img](/images/企业微信截图_16565901966632.png)

#### 多个ContextBlock

#### 数据结构

文本与属性组组件分离到不同的contextBlock保存。

踩坑

- contentBlock会强制换行，没法作为行内组件。

- 可以通过正则转换为单选，但是光标处于单选组件后无法输入，无法删除，无法空格。

### 需要注意的点

- 配置项的修改删除，对应单元格的属性组也要同步变化。

- 需要在读取数据时，将被删除的属性剔除掉。

## 四、相关文档

https://zhuanlan.zhihu.com/p/24951621

https://segmentfault.com/a/1190000019833834

https://github.com/dreamFlyingCat/draft.js/blob/master/README.md
