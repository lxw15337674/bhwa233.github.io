---
title: "react hook"
date: 2022-08-16T18:04:37+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---



Hooks之前的复用方式：

### mixins

缺点：

1. 方法与属性难以追溯，因为可能存在不同的mixins里。
2. 重名的属性与方法会被覆盖。

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

缺点：

会产生多余的层级嵌套。

### Hooks原因

1. 复用一个有状态的组件很困难。

2. 生命周期钩子函数里的逻辑很难抽离。

   希望一个函数只做一件事情，但我们的生命周期钩子函数里通常同时做了很多事情。比如我们需要在`componentDidMount`中发起ajax请求获取数据，绑定一些事件监听等等。同时，有时候我们还需要在`componentDidUpdate`做一遍同样的事情。当项目变复杂后，这一块的代码也变得不那么直观。

3. classes的this指向问题。

   为了保证this的指向正确，经常写`bind`将this指向当前组件。

   

