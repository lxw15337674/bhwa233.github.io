---
title: "排序算法"
date: 2022-08-14T13:26:49+08:00
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---
 
![image](http://upload-images.jianshu.io/upload_images/1940317-7caf7a8dec095a80.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 冒泡排序
基本思想：比较任何两个相邻的项，如果第一个比第二个大，则交换它们；（每次比较都会找到一个最大的数在最后）

步骤：

1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。 
2. 对每一对相邻元素做同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最大的数。 
3. 针对所有的元素重复以上的步骤，除了最后一个。
4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

时间复杂度是 O(n²)

![image](https://user-gold-cdn.xitu.io/2017/6/26/baca5f1861b9534eb85c2a2f7340a18f?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

```
Array.prototype.bubbleSort = function() {
    for (let i = 0; i < this.length; i++) {
        for (let j = 0; j < this.length - 1 - i; j++) {
            if (this[j] > this[j + 1]) {
                let aux = this[j]
                this[j] = this[j + 1]
                this[j + 1] = aux
            }
        }
    }
}
```
### 选择排序
找到数据结构中的最小值并 将其放置在第一位，接着找到第二小的值并将其放在第二位，以此类推。
![image](https://user-gold-cdn.xitu.io/2017/6/26/fd1cf9bccf6b4147b5442f4d36fc0d59?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
```
Array.prototype.selectionSort = function() {
    let indexMin
    for (let i = 0; i < this.length - 1; i++){
        indexMin = i
        for (var j = i; j < this.length; j++){ 
            if(this[indexMin] > this[j]) {
                indexMin = j
            }
        } 
        if (i !== indexMin){
            let aux = this[i]
            this[i] = this[indexMin]
            this[indexMin] = aux
        }
    }
    return this
}
```

### 插入排序
将一个数据插入到已经排好序的有序数据中，从而得到一个新的、个数加一的有序数据，此算法适用于少量数据的排序，时间复杂度为 O(n^2)。
例如：斗地主抓牌
![image](https://user-gold-cdn.xitu.io/2017/6/26/240c41b9aed4a6ef01abd1e225e11610?imageView2/0/w/1280/h/960/format/webp/ignore-error/1) 

```
Array.prototype.insertionSort = function() {
    let j
    let temp
    for (let i = 1; i < this.length; i++) {
        j = i
        temp = this[i]
        while (j > 0 && this[j - 1] > temp) {
            this[j] = this[j - 1]
            j--
        } 
        this[j] = temp
        console.log(this.join(', '))
    }
    return this
}
```

### 归并排序
将原始数组切分成较小的数组，直到每个小数组只有一 个位置，接着将小数组归并成较大的数组，直到最后只有一个排序完毕的大数组。
时间复杂度为 O(n log n)。

![image](https://user-gold-cdn.xitu.io/2017/6/26/6e75ddc8f4974aecf1619c24a9a5ce5b?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

![image](http://upload-images.jianshu.io/upload_images/1940317-d3d400686bc61c30.gif?imageMogr2/auto-orient/strip)
```
Array.prototype.mergeSort = function() {
    const merge = (left, right) => {
        const result = []
        let il = 0
        let ir = 0
        while(il < left.length && ir < right.length) {
            if(left[il] < right[ir]) {
                result.push(left[il++])
            } else {
                result.push(right[ir++])
            }
        }
        while (il < left.length) {
            result.push(left[il++])
        }
        while (ir < right.length) {
            result.push(right[ir++])
        }
        return result
    }
    const mergeSortRec = array => {
        if (array.length === 1) {
            return array
        }
        const mid = Math.floor(array.length / 2)
        const left = array.slice(0, mid)
        const right = array.slice(mid, array.length)
        return merge(mergeSortRec(left), mergeSortRec(right))
    }
    return mergeSortRec(this)
}
```

### 快速排序
类似二分法查找，从中间取一个数，比这个数小的放左边，大的放右边。
然后继续左右排序，一直到结束。

1. 首先，从数组中选择中间一项作为主元
2. 创建两个指针，左边一个指向数组第一个项，右边一个指向数组最后一个项。移动左指 针直到我们找到一个比主元大的元素，接着，移动右指针直到找到一个比主元小的元素，然后交 换它们，重复这个过程，直到左指针超过了右指针。这个过程将使得比主元小的值都排在主元之 前，而比主元大的值都排在主元之后。这一步叫作划分操作。
3. 接着，算法对划分后的小数组（较主元小的值组成的子数组，以及较主元大的值组成的 子数组）重复之前的两个步骤，直至数组已完全排序。
时间复杂度为 O(n log n)。
![image](http://upload-images.jianshu.io/upload_images/1940317-6d01faf07a21e730.gif?imageMogr2/auto-orient/strip)
![image](https://user-gold-cdn.xitu.io/2018/7/18/164acd0f33702fe6?imageslim)
![image](https://pic1.zhimg.com/80/v2-815dc856a90e961be52594ab4368d8a8_720w.jpg)

```
Array.prototype.quickSort = function() {
    const partition = (array, left, right) => {
        var pivot = array[Math.floor((right + left) / 2)]
        let i = left
        let j = right
        while (i <= j) {
            while (array[i] < pivot) {
                i++
            }
            while (array[j] > pivot) {
                j--
            }
            if (i <= j) {
                let aux = array[i]
                array[i] = array[j]
                array[j] = aux
                i++
                j--
            }
        }
        return i
    }
    const quick = (array, left, right) => {
        let index
        if (array.length > 1) {
            index = partition(array, left, right)
            if (left < index - 1) {
                quick(array, left, index - 1)
            }
            if (index < right) {
                quick(array, index, right)
            }
        }
    }
    quick(this, 0, this.length - 1)
    return this
}
```

[十大经典排序算法动画与解析，看我就够了！（配代码完全版）
](https://mp.weixin.qq.com/s/vn3KiV-ez79FmbZ36SX9lg)

https://github.com/coffe1891/frontend-hard-mode-interview/blob/master/2/2.1.1.md