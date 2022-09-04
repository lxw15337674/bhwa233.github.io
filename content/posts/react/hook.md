---
title: "react hook"
date: 2022-08-16T18:04:37+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

## Hooks之前的复用方式

### mixins

缺点：

1. 方法与属性难以追溯，因为可能存在不同的mixins里。

2. 多个 Mixin 之间可能产生冲突,重名的属性与方法会被覆盖。

   

### 渲染属性（render Props)

将渲染内容作为props的属性传给需要动态渲染的组件。

```typescript
import Cat from 'components/cat'
class DataProvider extends React.Component {
  constructor(props) {
    super(props);
    this.state = { target: 'Zac' };
  }

  render() {
    return (
      <div>
        {this.props.render(this.state)}
      </div>
    )
  }
}

<DataProvider render={data => (
  <Cat target={data.target} />
)}/>

```

### 高阶组件

一个函数接受一个组件作为参数，经过加工，返回一个新的组件。

```typescript
const withUser = WrappedComponent => {
  const user = sessionStorage.getItem("user");
  return props => <WrappedComponent user={user} {...props} />;
};

const UserPage = props => (
  <div class="user-container">
    <p>My name is {props.user}!</p>
  </div>
);

export default withUser(UserPage);

```

优点：

- HOC通过外层组件通过 Props 影响内层组件的状态，而不是直接改变其 State不存在冲突和互相干扰,这就降低了耦合度
- 不同于 Mixin 的打平+合并，HOC 具有天然的层级结构（组件树结构），这又降低了复杂度

缺点：

- 会产生多余的层级嵌套。

- 如果高阶组件多次嵌套,没有使用命名空间的话会产生冲突,然后覆盖老属性

  

## Hooks

### 诞生原因

1. 复用一个有状态的组件很困难。

2. 生命周期钩子函数里的逻辑很难抽离。

   希望一个函数只做一件事情，但我们的生命周期钩子函数里通常同时做了很多事情。比如我们需要在`componentDidMount`中发起ajax请求获取数据，绑定一些事件监听等等。同时，有时候我们还需要在`componentDidUpdate`做一遍同样的事情。当项目变复杂后，这一块的代码也变得不那么直观。

3. classes的this指向问题。

   为了保证this的指向正确，经常写`bind`将this指向当前组件。

### 基本原理

在 fiber 节点的 memorizedState 属性存放一个链表，链表节点和 hook 一一对应，每个 hook 都在各自对应的节点上存取数据。

useEffect、useMomo、useCallback 等都有 deps 的参数，实现的时候会对比新旧两次的 deps，如果变了才会重新执行传入的函数。所以 undefined、null 每次都会执行，[] 只会执行一次，[state] 在 state 变了才会再次执行。



### 优点

- 简洁: React Hooks解决了HOC和Render Props的嵌套问题,更加简洁

- 解耦: React Hooks可以更方便地把 UI 和状态分离,做到更彻底的解耦

- 组合: Hooks 中可以引用另外的 Hooks形成新的Hooks,组合变化万千

- 函数友好: React Hooks为函数组件而生,从而解决了类组件的几大问题:
  - this 指向容易错误
  - 分割在不同声明周期中的逻辑使得代码难以理解和维护
  - 代码复用成本高（高阶组件容易使代码量剧增）

### 缺点

- 写法上有限制（不能出现在条件、循环中）。

- 破坏了PureComponent、React.memo浅比较的性能优化效果（为了取最新的props和state，每次render()都要重新创建事件处函数）

- 在闭包场景可能会引用到旧的state、props值

- React.memo并不能完全替代shouldComponentUpdate（因为拿不到 state change，只针对 props change）



### 为什么不能条件语句中，声明`hooks`

因为一旦在条件语句中声明`hooks`，在下一次函数组件更新，`hooks`链表结构，将会被破坏，`current`树的`memoizedState`缓存`hooks`信息，和当前`workInProgress`不一致，如果涉及到读取`state`等操作，就会发生异常。



![hoo11.jpg](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/54a38675154a483885a3c5c9a80f360e%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

### 闭包陷阱

**当我们更新状态的时候，React会重新渲染组件。每一次渲染都能拿到独立的count 状态，这个状态值是函数中的一个常量。每一次调用引起的渲染中，它包含的count值独立于其他渲染（闭包）**

在诸如 的钩子中使用了某个状态`useEffect`，但它并没有添加到`deps`数组中，这样即使状态发生变化，回调函数也不会重新执行，它仍然是指旧值。


### 对比Vue Hooks

> 引用：https://juejin.cn/post/6844903877574295560#heading-2

Vue Hooks优势

1. **Vue 的代码使用更符合 JS 直觉。**

这句话直截了当戳中了 JS 软肋，JS 并非是针对 Immutable 设计的语言，所以 Mutable 写法非常自然，而 Immutable 的写法就比较别扭。

当 Hooks 要更新值时，Vue 只要用等于号赋值即可，而 React Hooks 需要调用赋值函数，**当对象类型复杂时，还需借助第三方库才能保证进行了正确的 Immutable 更新。**

2. **对 Hooks 使用顺序无要求，而且可以放在条件语句里。**

对 React Hooks 而言，调用必须放在最前面，而且不能被包含在条件语句里，这是因为 React Hooks 采用下标方式寻找状态，一旦位置不对或者 Hooks 放在了条件中，就无法正确找到对应位置的值。

而 Vue Function API 中的 Hooks 可以放在任意位置、任意命名、被条件语句任意包裹的，因为其并不会触发 `setup` 的更新，只在需要的时候更新自己的引用值即可，而 Template 的重渲染则完全继承 Vue 2.0 的依赖收集机制，它不管值来自哪里，只要用到的值变了，就可以重新渲染了。

3. **不会再每次渲染重复调用，减少 GC 压力。**

这确实是 React Hooks 的一个问题，所有 Hooks 都在渲染闭包中执行，每次重渲染都有一定性能压力，而且频繁的渲染会带来许多闭包，虽然可以依赖 GC 机制回收，但会给 GC 带来不小的压力。

而 Vue Hooks 只有一个引用，所以存储的内容就非常精简，也就是占用内存小，而且当值变化时，也不会重新触发 `setup` 的执行，所以确实不会造成 GC 压力。

4. **必须要总包裹 `useCallback` 函数确保不让子元素频繁重渲染。**

React Hooks 有一个问题，就是完全依赖 Immutable 属性。**而在 Function Component 内部创建函数时，每次都会创建一个全新的对象，这个对象如果传给子组件，必然导致子组件无法做性能优化。** 因此 React 采取了 `useCallback` 作为优化方案：

```javascript
const fn = useCallback(() => /* .. */, [])
```

只有当第二个依赖参数变化时才返回新引用。但第二个依赖参数需要 lint 工具确保依赖总是正确的（关于为何要对依赖诚实，感兴趣可以移步 [精读《Function Component 入门》 - 永远对依赖诚实](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fdt-fe%2Fweekly%2Fblob%2Fv2%2F104.%E7%B2%BE%E8%AF%BB%E3%80%8AFunction%20Component%20%E5%85%A5%E9%97%A8%E3%80%8B.md%23%E6%B0%B8%E8%BF%9C%E5%AF%B9%E4%BE%9D%E8%B5%96%E9%A1%B9%E8%AF%9A%E5%AE%9E)）。

回到 Vue 3.0，由于 `setup` 仅执行一次，因此函数本身只会创建一次，不存在多实例问题，不需要 `useCallback` 的概念，更不需要使用 [lint 插件](https://link.juejin.cn?target=https%3A%2F%2Fwww.npmjs.com%2Fpackage%2Feslint-plugin-react-hooks) 保证依赖书写正确，这对开发者是实实在在的友好。

5. **不需要使用 `useEffect` `useMemo` 等进行性能优化，所有性能优化都是自动的。**

这也是实在话，毕竟 Mutable + 依赖自动收集就可以做到最小粒度的精确更新，根本不会触发不必要的 Rerender，因此 `useMemo` 这个概念也不需要了。

而 `useEffect` 也需要传递第二个参数 “依赖项”，在 Vue 中根本不需要传递 “依赖项”，所以也不会存在用户不小心传错的问题，更不需要像 React 写一个 lint 插件保证依赖的正确性。



> 参考：
>
> [【React深入】从Mixin到HOC再到Hook](https://juejin.cn/post/6844903815762673671)