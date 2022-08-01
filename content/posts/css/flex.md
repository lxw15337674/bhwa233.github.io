---
title: "Flex"
date: 2022-08-01T23:21:15+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---









三个参数分别对应的是 flex-grow, flex-shrink 和 flex-basis，默认值为0 1 auto。

1.flex-grow属性定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大。

2.flex-shrink属性定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小。

3.flex-basis属性定义了在分配多余空间之前，项目占据的主轴空间（main size）。

```javascript
.item {
flex-grow: 0; // 增长比例，子项合计宽度小于容器宽度，需要根据每个子项设置的此属性比例对剩下的长度进行分配
flex-shrink: 1; // 回缩比例，子项合计宽度大于容器宽度，需要根据每个子项设置的此属性比例对多出的长度进行分配
flex-basis: auto; // 设置了宽度跟宽度走，没设置宽度跟内容实际宽度走
}
```

