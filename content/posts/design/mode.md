---
title: "依赖倒置、控制反转，依赖注入"
date: 2023-03-14T17:31:12+08:00
draft: false
tags: [""]
categories: ["设计模式"]
typora-root-url: ..\..\static
---

> 通过定义抽象的接口，我们可以将高层应用和具体的底层模块解耦。应用程序不需要关心具体实现细节，而是通过接口来访问底层模块的功能。当需要使用不同的底层模块时，只需要实现相应的接口，然后在应用程序中传入对应的实现即可。

## 概念

### 依赖倒置

依赖倒置原则（DIP）是一种**设计原则**，它的定义可以总结为以下两点：

1. 高层模块不依赖于底层模块，两者都应该依赖于抽象。
2. 细节依赖于抽象，抽象不依赖于细节。

这个原则的目的是通过解耦高层模块和低层模块之间的依赖关系，使得高层模块不需要关心低层模块的具体实现。

### 控制反转

控制反转（IoC）是一种**编程思想**，它强调将对象之间的关系交给外部容器或框架进行管理。在控制反转中，应用程序的各个组成部分并不直接调用其他组成部分，而是由框架或容器来注入依赖关系。这个思想的目的是将对象之间的依赖关系降低到最小，从而提高系统的可维护性和可扩展性。

### 依赖注入

依赖注入（DI）是控制反转的**一种实现方式**，它指的是在创建一个对象时，将其所依赖的其他对象通过构造函数、方法参数、属性等方式传递进去。通过依赖注入，我们可以将对象之间的关系从代码中硬编码的方式，改为由外部容器或框架动态地注入依赖关系，从而提高代码的可测试性和可维护性。



## 举例

```javascript
// 抽象接口
class Database {
  constructor() {}
  getData() {}
}

// 具体实现类
class MySQL extends Database {
  getData() {
    return 'Data from MySQL';
  }
}

// 具体实现类
class Oracle extends Database {
  getData() {
    return 'Data from Oracle';
  }
}

// 高层模块，在创建 Application 的实例时，我们可以传入任何实现了 Database 接口的对象，从而达到了高层模块和具体实现之间的解耦。
class Application {
  constructor(database) {
    this.database = database;
  }
  getData() {
    console.log(this.database.getData());
  }
}

// 应用程序入口，利用依赖注入实现控制反转。
const mySQL = new MySQL();
const oracle = new Oracle();
const app1 = new Application(mySQL);
const app2 = new Application(oracle);

app1.getData(); // 输出：Data from MySQL
app2.getData(); // 输出：Data from Oracle

```

