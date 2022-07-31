---
title: "键盘事件"
date: 2022-07-31T16:08:26+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

由于开发富文本中遇到中文输入法输入等问题，所以总结一下。

# 键盘事件

### 触发顺序

#### 普通输入

`keydown ->keypress -> input->change-> keyup`

#### 输入法输入

**输入时**

`keydown ->CompositionStart->CompositionUpdate -> input->change->onCompositionEnd ->keyup`

### 普通事件

在`keyup` 事件中无法阻止浏览器默认事件，如要阻止默认行为，必须在`keydown`或`keypress`时阻止。

| 事件名     | 触发时机       | 备注                                                         |
| ---------- | -------------- | ------------------------------------------------------------ |
| `keydown`  | 按下任意按键。 |                                                              |
| `keypress` | 任意键被按住。 | 1.当按键处于按下状态时事件会持续触发。<br />2. 按 `Shift`、`Fn`、`CapsLock`不能触发。<br />3. 中文输入法中不会被触发 |
| `keyup`    | 释放任意按键。 |                                                              |

### 输入框特殊事件

只会输入框中输入时触发。

| 事件名              | 触发时机                   | 备注               |
| ------------------- | -------------------------- | ------------------ |
| `compositionstar`   | 使用中文输入法，开始输入时 | 不用输入法不会触发 |
| `compositionend`    | 使用中文输入法，输入完成时 | 不用输入法不会触发 |
| `compositionupdate` | 使用中文输入法，输入更新时 | 不用输入法不会触发 |
| `input`             | 当输入时                   |                    |
| `change`            | 当值变化时                 |                    |





## 参考资料

[限制input输入的方法（监听键盘事件）](https://segmentfault.com/a/1190000023543967)

[解决oninput事件在中文输入法下会取得拼音的值的问题](https://segmentfault.com/a/1190000012490380)