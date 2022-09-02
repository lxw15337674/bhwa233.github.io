---
title: "Middle"
date: 2022-08-21T12:50:51+08:00
draft: false
tags: ["css"]
categories: ["css"]
typora-root-url: ..\..\static
---

# 居中

![image](/images/50374866-75bc1200-062f-11e9-8f19-e044ad460927.png)


## 水平居中

- 行内元素

```
 <div class="container">
  <div>
    123
  </div>
</div>
<style>
  .container {
    text-align: center;
  }
</style>
```

- 块级元素

  - 确定宽度

  ```
    margin:0 auto
    width:100px
  ```

  ```
    width: 100px;
    margin-left: calc(50% - 50px);
  }
  ```

  - 不确定宽度同垂直居中

## 垂直居中

- 弹性盒

```
  display:flex
  align-items:center
```

- translate

```
  position:absolute
  left:50%
  top:50%
  transform:translate(-50%,-50%)
```

- 相对定位

```
  position:absolute
  top/right/bottom/left:0
  margin:auto
```

- table+vertical-align

```
  display:table-cell
  vertical-align:middle
```

## 水平垂直居中

- 利用 css3 的 translate

```
.wrap {
  position: relative;
  width: 100vw;
  height: 100vh;
}

.box {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

- flex

```
.wrap {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

- table-cell，必须固定宽高

```
.father{
    display:table-cell
    vertical-align:middle
    text-align:center
    height:500px
    width:500px
}
```

- [grid](https://juejin.im/post/6844903809953562638)

```
.father{
	display:grid
	justify-items:center
	align-items:center
}
```



## 详解

https://github.com/ljianshu/Blog/issues/29
https://juejin.im/post/58f818bbb123db006233ab2a
http://47.98.159.95/my_blog/css/001.html#%E6%B0%B4%E5%B9%B3%E5%B1%85%E4%B8%AD