---
title: "react面试题"
date: 2022-08-20T15:15:31+08:00
draft: false
tags: [""]
categories: ["面试"]
typora-root-url: ..\..\static
---

> 摘抄
>
> [React八股文](https://zhuanlan.zhihu.com/p/400694371)



### JSX的本质是什么

JSX全称JavaScript XML，是react定义的一种类似于XML的JS扩展语法，用来创建虚拟DOM。规则：

- 定义虚拟DOM时，不要写引号。

- 标签中混入JS表达式时要用`{}`。

- 样式的类名指定不要用class，要用className。

- 内联样式，要用style={{key:value}}的形式去写。

- 只有一个根标签，并且标签必须闭合。

- 标签首字母必须首字母

  若小写字母开头，则将该标签转为html中同名元素，若html中无该标签对应的同名元素，则报错。若大写字母开头，react就去渲染对应的组件，若组件没有定义，则报错。

### 组件生命周期

![img](/images/v2-bb99e2c733306dbaee77f6aaf9029cae_r.jpg)

挂载阶段：

- **construct**：构造函数，通常在构造函数里初始化state对象或者给自定义方法绑定this；
- **getDerivedStateFromProps**: 这是个静态⽅法,当我们接收 到新的属性想去修改我们state，可以使⽤getDerivedStateFromProps；
- render：纯函数，只返回需要渲染的东西，不应该包含其它的业务逻辑，可以返回原⽣的DOM、React 组件、Fragment、Portals、字符串和数字、Boolean和null等内容；
- **componentDidMount**：组件装载之后调用，此时我们可以获取到DOM节点并操作，记得在componentWillUnmount中取消订阅。（**react的请求放在此生命周期上）**

更新阶段：

- **getDerivedStateFromProps**
- **shouldComponentUpdate**：SCU有两个参数nextProps和nextState，表示新的属性和变化之后的state，true表示会触发重新渲染，false表示不会触发重新渲染，默认返回 true,我们通常利用SCU来优化React程序性能 ；
- **render**
- **getSnapshotBeforeUpdate**：有两个参数prevProps和prevState，返回值会作为第三个参数传给componentDidUpdate，如果你不想要返回值，可以返回null，此⽣命周期必须 与componentDidUpdate搭配使用；
- **componentDidUpdate**：有三个参数prevProps，prevState，snapshot， 第三个参数是getSnapshotBeforeUpdate返回的,如果触发某些回调函数时需要⽤到 DOM 元素的状态，则将对⽐或 计算的过程迁移此，然后在 componentDidUpdate 中统⼀触发回调或更新状态。

卸载阶段：

- **componentWillUnmount**：当我们的组件被卸载或者销毁了就会调用，我们可以在这个函数里去清除⼀些定时器，取消⽹络请求，清理⽆效的DOM元素等垃圾清理⼯作；

### class组件和函数组件的区别

**类组件的缺点** :

大型组件很难拆分和重构，也很难测试。
业务逻辑分散在组件的各个方法之中，导致重复逻辑或关联逻辑。
组件类引入了复杂的编程模式，比如 render props 和高阶组件。
难以理解的 class，理解 JavaScript 中 `this` 的工作方式。

**区别**：

- 性能

  函数组件的性能比类组件的性能要高，因为类组件使用的时候要实例化，而函数组件直接执行函数取返回结果即可。

- 状态
  hooks出现之前，函数组件`没有实例`，`没有生命周期`，`没有state`，`没有this`，所以我们称函数组件为无状态组件。 hooks出现之前，react中的函数组件通常只考虑负责UI的渲染，没有自身的状态没有业务逻辑代码，是一个纯函数。它的输出只由参数props决定，不受其他任何因素影响。

- 调用方式
  函数组件重新渲染，将重新调用组件方法返回新的react元素。类组件重新渲染new一个新的组件实例，然后调用render类方法返回react元素，这也说明为什么类组件中this是可变的。

### 组件间通信

- 父向子通信：

  通过props向子组件通信；

- 子向父

  props+回调的方式。

- 跨层级通信

  1. 使用props层层传递
  2. 使用context

- 全局状态管理工具：

  1. 可以使用自定义事件通信（发布订阅模式），使用pubsub-js
  2. 借助Redux或者Mobx全局状态管理工具进行通信

### setState

**更新时机**

既存在异步情况也存在同步情况。 

1. 在React事件当中是异步操作。
2. 在setTimeout和自定义事件中使用就是同步的。

```javascript
//setTimeout事件
import React,{ Component } from "react";
class Count extends Component{
    constructor(props){
        super(props);
        this.state = {
            count:0
        }
    }

    render(){
        return (
            <>
                <p>count:{this.state.count}</p>
                <button onClick={this.btnAction}>增加</button>
            </>
        )
    }
    
    btnAction = ()=>{
        //不能直接修改state，需要通过setState进行修改
        //同步
        setTimeout(()=>{
            this.setState({
                count: this.state.count + 1
            });
            console.log(this.state.count);
        })
    }
}

export default Count;
```

```javascript
//自定义dom事件
import React,{ Component } from "react";
class Count extends Component{
    constructor(props){
        super(props);
        this.state = {
            count:0
        }
    }

    render(){
        return (
            <>
                <p>count:{this.state.count}</p>
                <button id="btn">绑定点击事件</button>
            </>
        )
    }
    
    componentDidMount(){
        //自定义dom事件，也是同步修改
        document.querySelector('#btn').addEventListener('click',()=>{
            this.setState({
                count: this.state.count + 1
            });
            console.log(this.state.count);
        });
    }
}

export default Count;
```


### 生命周期

![image.png](/images/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f38626165303165366562383034643834396535626238383966373837373037647e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

```
安装
当组件的实例被创建并插入到 DOM 中时，这些方法按以下顺序调用：

constructor()
static getDerivedStateFromProps()
render()
componentDidMount()

更新中
更新可能由道具或状态的更改引起。当重新渲染组件时，这些方法按以下顺序调用：

static getDerivedStateFromProps()
shouldComponentUpdate()
render()
getSnapshotBeforeUpdate()
componentDidUpdate()

卸载
当组件从 DOM 中移除时调用此方法：

componentWillUnmount()
```



### 性能优化

- **shouldComponentUpdate**

react默认父组件有更新，子组件无条件更新，则可以通过shouldComponentUpdate来决定是否渲染，减少不必要的render，必须配合不可变值同时使用。

```js
shouldComponentUpdate(nextProps,nextState){
  if(nextState.count !== this.state.count){
    return true        // 可以渲染
  }
  return false         //不重复渲染
}
```

- **PureComponent和React.memo**

PureComponent内部实现了shouldComponentUpdate的方法，并且只是进行了浅比较，所以针对基本数据类型才有用，是提供给class组件使用的

React.memo和PureComponent功能是一样的，只不过memo是提供给函数组件使用的，memo提供一个参数，可以自行配置对引用数据做比较然后触发render。

- **immutable.js**

彻底拥抱不可变值，是基于数据共享，速度更快。

### Portals的使用场景

Portal 可以将**子节点渲染到存在于父组件以外的 DOM 节点。**

因为组件默认会按照既定层次嵌套渲染，元素会被挂载到DOM元素中离其最近的父节点，所以需要将子节点渲染到父组件之外的DOM节点就需要Portals。

使用场景：（子组件能够跳出当前阻碍他显示的容器）

- overflow：hidden
- 父组件z-index值太小
- fixed需要放在body第一层级

使用：

```js
ReactDOM.createPortal(child, container)   // 两个参数为React子元素和DOM元素
```

通过Portal进行事件冒泡，它的事件冒泡是根据虚拟DOM树来冒泡，与真实的DOM树无关。

### React 事件绑定原理

React并不是将click事件绑在该div的真实DOM上，而是`在document处监听所有支持的事件`，当事件发生并冒泡至document处时，React将事件内容封装并交由真正的处理函数运行。这样的方式不仅减少了内存消耗，还能在组件挂载销毁时统一订阅和移除事件。
另外冒泡到 document 上的事件也不是原生浏览器事件，而是 React 自己实现的合成事件（SyntheticEvent）。因此我们如果不想要事件冒泡的话，调用 event.stopPropagation 是无效的，而应该调用 `event.preventDefault`。



### React 事件绑定原理

React并不是将click事件绑在该div的真实DOM上，而是`在document处监听所有支持的事件`，当事件发生并冒泡至document处时，React将事件内容封装并交由真正的处理函数运行。这样的方式不仅减少了内存消耗，还能在组件挂载销毁时统一订阅和移除事件。
另外冒泡到 document 上的事件也不是原生浏览器事件，而是 React 自己实现的合成事件（SyntheticEvent）。因此我们如果不想要事件冒泡的话，调用 event.stopPropagation 是无效的，而应该调用 `event.preventDefault`。

![react事件绑定原理](/../../static/images/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f32303839373138663734623334323836396465313566303135383866303333667e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)



### React和Vue的区别

**原理**

Vue 的数据绑定依赖数据劫持 `Object.defineProperty()` 中的 `getter` 和 `setter`，更新视图使用的是 **发布订阅模式（eventEmitter）** 来监听值的变化，从而让 `virtual DOM` 驱动 Model 和 View 的更新，利用 `v-model` 这一语法糖能够轻易实现双向的数据绑定，这种模式被称为 `MVVM: M <=> VM <=> V`，但本质上还是 `State -> View -> Actions` 的单向数据流，只是使用了 `v-model` 不需要显式地编写 `View` 到 `Model` 的更新。

React 则需要依赖 `onChange/setState` 模式来实现数据的双向绑定，因为它在诞生之初就是设计成单向数据流的。

**复用方式**

父组件将渲染内容传给子组件渲染，vue通过插槽实现，react通过Render Props。

**状态管理**

- React 可以通过 `React.context` 来进行跨层级通信；
- Vue 则可以使用 `provide/inject` 来实现跨层级注入数据。

**模版渲染方式**

React 在 JSX 中使用原生的 JS 语法来实现插值，条件渲染，循环等。

Vue 则需要依赖指令进行，更容易上手，但封装程度更高，调试成本更大，难以定位 Bug。

（4）性能差异

在 React 中组件的更新渲染是从数据发生变化的根组件开始往子组件逐层渲染，而组件的生命周期中有 `shouldComponentUpdate` 这一钩子函数可以给开发者优化组件在不需要更新的时候不要更新。

Vue 通过 watcher 监听到数据的变化之后，通过自己的 diff 算法，在 virtualDOM 中直接以最低成本更新视图。

## React Router

### 路由组件与一般组件的区别

（1）写法不同：

- 一般组件：<Demo/>
- 路由组件：<Route path="/demo" component={Demo}/>

（2）存放位置不同：

- 一般组件：components
- 路由组件：pages

（3） 接收到的 props 不同：

- 一般组件：写组件标签时传递了什么，就能收到什么
- 路由组件：接收到三个固定的属性

**BrowserRouter与HashRouter的区别**

（1）底层原理不一样：

- BrowserRouter 使用的是 H5 的 history API，不兼容 IE9 及以下版本。
- HashRouter 使用的是 URL 的哈希值。

（2）path 表现形式不一样

- BrowserRouter 的路径中没有#,例如：localhost:3000/demo/test
- HashRouter 的路径包含#,例如：localhost:3000/#/demo/test

（3）刷新后对路由 state 参数的影响

- BrowserRouter 没有任何影响，因为 state 保存在 history 对象中。
- HashRouter 刷新后会导致路由 state 参数的丢失！

[浅谈前端路由原理hash和history](https://juejin.cn/post/6993840419041706014)