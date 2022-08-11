---
title: "Vuex、Flux、Redux、Redux-saga、Dva、MobX 状态管理"
date: 2022-08-09T19:25:58+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

状态管理的解决思路是：**把组件之间需要共享的状态抽取出来，遵循特定的约定，统一来管理，让状态的变化可以预测**。

## store模式

### 简单模式

把状态存到一个全局变量（store）里，然后直接修改状态。

缺点：

1. 数据改变后，不会留下变更过的记录，难以调试。

### 复杂模式

不允许直接修改store里的状态，而是在store里面定义action，由action来控制state的改变。

优点：

1. 可以实现记录变更、保存状态快照、时光旅行的功能。

## Flux

flex是一种思想，核心就是单向流动。 基本逻辑是**View 通过某种方式触发 Store 的事件或方法，Store 的事件或方法对 State 进行修改或返回一个新的 State，State 改变之后，View 发生响应式改变。**它把一个应用分为4个部分。

- view ：视图层，用于将展示store数据。store变时视图会跟着变化。如果View需要修改Store，必须通过Dispatcher。

-  action：操作层，用于存储修改store的所有操作。

- dispatcher：中转层，接受所有的action，发送所有的Store。收到View发出的action，转发给store，由store执行转发的action。

- store：数据层，用于存数据。接受action修改state。

特点：

1. 一个应用可以拥有多个Store，多个Store之间可能存在依赖关系。
1. Store封装了数据和处理数据的逻辑。

## Redux

Redux融合了`Flux`与`immunateble`的思想，与Flux有一些差别：

**store**

- redux只有一个Store。（单一状态树的好处是能够直接地定位任一特定的状态片段，在调试的过程中也能轻易地取得整个当前应用状态的快照。）

- store的state不能直接修改，每次只能返回一个新的state。

**action**

- action必须有一个type属性，来表示action的类型。

**Reducer**

- Redux里没有 Dispatcher，在Store里面已经集成了 dispatch 方法。`store.dispatch()`是 View 发出 Action 的唯一方法。

- Redux 用一个叫做 Reducer 的纯函数来处理事件。reducer可以有多个，各自维护一部分的state。

> 纯函数: 对于相同的输入，永远都只会有相同的输出，不会影响外部的变量，也不会被外部变量影响，不得改写参数。

### 与flux区别：

- redux是单一数据源，flex可以是多个数据源。
- flux的state不一定是纯函数修改，redux使用纯函数来修改。

### 三大原则

-  单一数据源

- State 是只读的

- 通过纯函数来修改

### 工作流程

- 用户在页面上进行某些操作，通过 dispatch 发送一个 action。

- Redux 接收到这个 action 后通过 reducer 函数获取到下一个状态。

- 将新状态更新进 store，store 更新后通知页面进行重新渲染。

  

## Redux中间件

通过中间件对`store.dispatch()`进行改造，来进行一些副作用，异步操作。

 **Redux-thunk**

封装少，需要用户自己定义逻辑，在promise的then、catch等不同阶段执行dispatch。

**Redux-promise**

封装了then、catch的逻辑。



## Vuex

Vuex 主要用于 Vue，和 Flux，Redux 的思想很类似。

**store**

单一数据源：一个应用仅会包含一个 Store 实例

**mutation**

类似于redux的Reducer。通过mutation修改数据，每个 mutation 都有一个字符串的 事件类型 (type) 和 一个 回调函数 (handler)。调用需要通过`store.commit`方法。mutation是同步事务。

与Reducer的区别：

- 可以直接修改state、而不是返回一个新的state。

**action**

Vuex通过action来处理异步。View 通过 store.dispatch('increment') 来触发某个 Action，Action 里面不管执行多少异步操作，完事之后都通过 store.commit('increment') 来触发 mutation，一个 Action 里面可以触发多个 mutation。



## React-Redux

Redux 和 Flux 类似，只是一种思想或者规范，它和 React 之间没有关系。React-Redux是基于Redux思想实现的React库。

React-Redux将React组件分为容器型组件和展示型组件：

容器型组件：一般通过connect函数生成，它订阅了全局状态的变化，通过mapStateToProps函数，可以对全局状态进行过滤。

展示型组件：不直接从global state获取数据，其数据来源于父组件。

![img](/../../static/images/v2-6c15a43f784be592052aff8e9f495643_720w.jpg)

## Mobx

基本思想：**任何源自应用状态的东西都应该自动地获得。**类似Vue的响应式，状态只要一变，所有用到状态的地方就都跟着自动变。

Mobx会把 state 包装成可观察的对象，这个对象会驱动各种改变。Mobx允许有多个Store，sotre里的state可以直接修改。

**与Redux对比**

- redux容易记录变更，Mobx相对麻烦。

- redux每次修改都要返回一整个store，Mobx可以直接修改想更新的数据。

- redux需要引入中间件处理副作用、异步，Mobx则没有限制。

  



>  参考
>
> [Vuex、Flux、Redux、Redux-saga、Dva、MobX](https://zhuanlan.zhihu.com/p/53599723)
>
> [各流派React状态管理对比和原理实现](https://mp.weixin.qq.com/s/h8uRkY8wzzP-ajmEIHkzwQ)

