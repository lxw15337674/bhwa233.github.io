---
title: "Promise"
date: 2022-08-18T11:02:44+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static 
---

## 一句话总结Promise

用于解决异步操作结束后的方法执行问题。

## 诞生原因

最开始解决异步函数的方法是回调函数，将要执行的函数作为参数，传入异步操作中。导致会无限嵌套，也就是回掉地狱，影响代码可读性。例如`asyncfn1(asyncfn2(asyncfn3()))`。

## 原理

通过观察者模式，将要执行的函数放入一个队列里，在异步函数执行结束后执行这个队列。

## 特点

- 不受外界影响，由执行函数内部决定成功和失败。

- 一个 `Promise` 必然处于以下三种状态之一：

  - 执行态 `(pending)`: 初始状态，既没有成功，也没有失败。

  - 实现态`(fulfilled)`: 意味着操作成功完成。

  - 拒绝态`(rejected)`: 意味着操作失败。

- 状态只能由 `Pending` 变为 `Fulfilled` 或由 `Pending` 变为 `Rejected`，且状态改变之后不会在发生变化，会一直保持这个状态。

## 流程

1. 必须给`Promise`对象传入一个执行函数，否则将会报错。
2. 当Promise被创建时就已经开始执行。
3. Promise中有`throw`的话，就相当于执行了`reject`。
4. Promise只以`第一次为准`，第一次成功就永久为`fulfilled`，第一次失败就永远状态为`rejected`，执行了`resolve`，Promise状态会变成`fulfilled`，执行了`reject`，Promise状态会变成`rejected`。
5. Promise里没有执行`resolve`、`reject`以及`throw`的话，则状态也是`pending`，`pending`状态下的promise不会执行对应回调函数。

```javascript
let p1 = new Promise((resolve, reject) => {
    resolve('成功')
    reject('失败')
})
console.log('p1', p1) 
// p1 Promise {<fulfilled>: '成功'}

let p2 = new Promise((resolve, reject) => {
    reject('失败')
    resolve('成功')
})
console.log('p2', p2)
// p2 Promise {<rejected>: '失败'}

let p3 = new Promise((resolve, reject) => {
    throw('报错')
})
console.log('p3', p3)
// p3 Promise {<rejected>: '报错'}

let p4 = new Promise(() => { });

console.log('p4', p4);
// p4  Promise {<pending>}

let p5 = new Promise((resolve, reject) => {
  let a = 1;
  for (let index = 0; index < 5; index++) {
    a++;
  }
})

console.log('p5', p5)
// p5  Promise {<pending>}

p5.then(() => {
  console.log("myPromise2执行了then");
})
// 不会输出

let p6 = new Promise();
console.log('myPromise0 :>> ', p6);
// TypeError: Promise resolver undefined is not a function

let done = true
const isItDoneYet = new Promise((resolve, reject) => {
  console.log('test')
  if (done) {
    const workDone = '这是创建的东西'
    resolve(workDone)
  } else {
    const why = '仍然在处理其他事情'
    reject(why)
  }
})

let p7 = new Promise(() => {
  console.log('p7')
}); 
// 输出p7
```



## 缺点

1. 错误必须被捕获（不捕获反应不到外面）。
2. 需要写回调函数。
3. 一旦新建就会立即执行，无法中途取消。
4. 无法得知`pending`状态，当处于 `pending` 时，无法得知目前进展到哪一个阶段（刚刚开始还是即将完成）。

## API

#### executor

executor作为接收`resolve`和`reject`的函数。
`resolve` 是用于处理操作成功结束的情况，会将`promise`对象的状态从执行态转为成功态，并将异步操作的结果作为参数传递出去。
`reject` 是用于处理操作失败的情况，将`promise` 对象的状态从执行态转为失败态，并将错误作为参数传递出去。

### 原型方法

#### `Promise.prototype.then(onFulfilled,onRejected)`  

将成功和失败的执行函数传入promise，返回一个新的promise，将返回值做为resolve。  

#### `Promise.prototype.catch(onRejected)`  

只处理失败情况，相当于`  
Promise.prototype.then(undefined, onRejected) `  

#### `Promise.prototype.finall(onFinally)`  

不管成功失败都会执行的函数，并且会把之前的值原封不动的传递给后面的then  


### 方法

#### `resolve(value) `

返回一个带有成功值的promise对象，如果参数是promise，则返回参数。  

#### `reject(value)`

返回一个带有拒绝值的promise对象，如果参数是promise，则返回参数。  

#### `all(iterable)`

返回一个promise，执行参数迭代器中所有的promise，如果都正确，则返回一个所有promise结果的列表，如果有一个失败，则返回第一个失败结果。

#### `race(iterable)`

返回一个promise，执行参数迭代器中所有的promise，返回最先执行完成的promise结果。

#### `any(iterable)`

返回一个promise，执行参数迭代器中所有的promise。只要参数实例有一个变成`fulfilled`状态，包装实例就会变成`fulfilled`状态；如果所有参数实例都变成`rejected`状态，包装实例就会变成`rejected`状态。

#### `allSettled(iterable)`

返回一个promise，执行参数迭代器中所有的promise，只有等到所有参数实例都返回结果，才会结束。返回一个所有promise结果的列表，每个对象都有`status`属性，该属性的值只可能是字符串`fulfilled`或字符串`rejected`。`fulfilled`时，对象有`value`属性，`rejected`时有`reason`属性，对应两种状态的返回值。

```javascript
const resolved = Promise.resolve(42);
const rejected = Promise.reject(-1);

const allSettledPromise = Promise.allSettled([resolved, rejected]);

allSettledPromise.then(function (results) {
  console.log(results);
});
// [
//    { status: 'fulfilled', value: 42 },
//    { status: 'rejected', reason: -1 }
// ]
```



## 完整实现

```javascript
//Promise/A+规范的三种状态
const PENDING = 'pending'
const FULFILLED = 'fulfilled'
const REJECTED = 'rejected'

class myPromise {
    constructor(executor) {
        this.status = PENDING
        this.data = null
        this.resolveQueue = []
        this.rejectQueue = []
        let resolve = (value) => {
            let run = () => {
                if (this.status !== PENDING) return
                this.status = FULFILLED
                this.data = null
                for (let callback of this.resolveQueue) {
                    callback(value)
                }
            }
            setTimeout(run)
        }
        let reject = (reason) => {
            let run = () => {
                if (this.status !== PENDING) return
                this.status = REJECTED
                this.data = null
                for (let callback of this.rejectQueue) {
                    callback(reason)
                }
            }
            setTimeout(run)
        }
        executor(resolve, reject)
    }
    then(resolveFn, rejectFn) {
        return new myPromise((resolve, reject) => {
            let fulfilledfn = value => {
                try {
                    resolve(resolveFn(value))
                }
                catch (error) {
                    reject(error)
                }
            }
            let rejectedFn = error => {
                try {
                    resolve(rejectFn(error))
                } catch (error) {
                    reject(error)
                }
            }
            switch (this.status) {
                case PENDING:
                    this.resolveQueue.push(fulfilledfn);
                    this.rejectQueue.push(rejectedFn)
                    break
                case FULFILLED:
                    fulfilledfn(this.data)
                    break
                case REJECTED:
                    rejectFn(this.data)
                    break
            }
        })
    }
    catch(rejectFn) {
        return this.then(null, rejectFn)
    }
    finally(callback) {
        return this.then(
            (res) => {
                callback()
                return res
            },
            (res) => {
                callback()
                throw res
            }
        )
    }
    resolve(value) {
        return new Promise(resolve => resolve(value))
    }
    reject(value) {
        return new Promise((reject, reject) => { this.reject(value) })
    }
    all(promiseList) {
        let list = []
        return new Promise((resolve, reject) => {
            promiseList.forEach((p, i) => {
                resolve(p).then(
                    val => {
                        list.push(val)
                        if (i === promiseList.length) {
                            resolve(result)
                        }
                    },
                    err => {
                        reject(err)
                    }
                )
            })

        })
    }
    race(promiseArr) {
        return new myPromise((resolve, reject) => {
            for (let p of promiseArr) {
                resolve(p).then(
                    value => {
                        resolve(value)
                    },
                    err => {
                        reject(err)
                    }
                )
            }
        })
    }
}


new myPromise(function (resolve, reject) {
    setTimeout(() => {
        console.log('test')
        resolve(2)
    }, 1000)
    resolve(2)
}).then((res) => {
    console.log(`res1${res}`)
    return 3
}).then(res => {
    console.log(`res2${res}`)
    return 4
}).then(res => {
    console.log(`res3${res}`)
    return 5
}).finally(() => {
    console.log('test')
}).then(res => {
    console.log(res)
})

```





## 一些题

### 并发限制

实现 Scheduler.add() 函数

```js
const timeout = (time) => new Promise(resolve => {
  setTimeout(resolve, time)
})

const scheduler = new Scheduler()
const addTask = (time, order) => {
  scheduler.add(() => timeout(time))
    .then(() => console.log(order))
}

// 限制同一时刻只能执行2个task
addTask(4000, '1')
addTask(3500, '2')
addTask(4000, '3')
addTask(3000, '4')
.....

//Scheduler ？
//4秒后打印1
//3.5秒打印2
//3进入队列，到7.5秒打印3 
//...

```

**答案**

根据当前请求数，如果超过限制，就使用新的 promise 来进堵塞后续的请求，把 promise 的 resolve 函数传入一个数组中，然后执行完的请求结束后之前队列最前面的resolve。

promise写法

```javascript
function Scheduler() {
  const queue = []
  let count = 0
  const add = (task) => {
    let res = task
    if (count >= 2) {
      res = () => {
        return new Promise((res) => {
          queue.push(res)
        }).then(task)
      }
    }
    count++
    return res().then(() => {
      count--
      if (queue.length) {
        queue.shift()()
      }
    })
  }
  return {
    add
  }
}

```

async 写法

```javascript
function Scheduler() {
  const queue = []
  let count = 0
  const add = async (task) => {
    if (count >= 2) {
      await new Promise((res) => {
        queue.push(res)
      })
    }
    count++
    const res = await task()
    count--
    if (queue.length) {
      queue.shift()()
    }
    return res
  }
  return {
    add
  }
}

```



### 重试多次

```javascript
const resolveData = () => {
  return new Promise((resolve, reject) => {
    setTimeout(
      () => (Math.random() > 0.8 ? resolve('成功') : reject(new Error('失败')))
      , 1000,
    )
  })
}

Promise.retry(resolveData, 3, 1000).then(res => {
  console.log(res);
})
```

**答案**

Promise写法

```javascript
Promise.retry = (fn, times, delay) => {
  return new Promise((resolve, reject) => {
    const attempt = () => {
      fn().then(res => {
        resolve(res)
      }).catch(err => {
        if (times === 0) {
          reject(err)
          return
        }
        times--
        console.log('重试中', times);
        setTimeout(attempt, delay)
      })
    }
    attempt()
  })
};


const resolveData = () => {
  return new Promise((resolve, reject) => {
    setTimeout(
      () => (Math.random() > 0.5 ? resolve('成功') : reject(new Error('失败')))
      , 1000,
    )
  })
}

Promise.retry(resolveData, 3, 100).then(res => {
  console.log(res);
}).catch(err => {
  console.log(err);
})
```

async 写法

```javascript
// 传入一个promise生成器
Promise.retry = async (fn, times, delay) => {
  const delayFn = () => new Promise((res) => setTimeout(res, delay))
  let error = null
  while (true) {
    try {
      return await fn()
    } catch (e) {
      error = e
    }
    if (times === 0) {
      throw error
    }
    times--
    await delayFn()
    console.log('重试中', times);
  }
};

const resolveData = () => {
  return new Promise((resolve, reject) => {
    setTimeout(
      () => (Math.random() > 0.5 ? resolve('成功') : reject(new Error('失败')))
      , 1000,
    )
  })
}

Promise.retry(resolveData, 3, 100).then(res => {
  console.log(res);
}).catch(err => {
  console.log(err);
})
```



### 支持取消的重试

实现一个轮询方法，返回一个取消方法，能够强制中断轮询

当异步方法成功时，通过回调返回结果并且结束轮询；当异步方法失败时，隔一段时间进行重试，且每次重试的时间是上一次的两倍（第一次的重试时间为 1s）。

```javascript
let count = 0;
function fakeRequest() {
  return new Promise((resolve, reject) => {
    if (++count > 3) {
      resolve("data");
    } else {
      reject(new Error("failed"));
    }
  });  
}
 
function sendWithRetry(fn, onSuccess, onCancel) {
  // TODO
 
}
 
const cancel = sendWithRetry(
  fakeRequest,
  (data) => {
    console.log("结果：", data);
  },
  () => {
    console.log("被取消了");
  }
);
 
setTimeout(() => {
  cancel(); // 取消、中断轮询
}, 3000);
```



**实现**

Promise写法

```javascript

function sendWithRetry(fn, onSuccess, onCancel) {
  let delay = 1000
  let cancel = null
  let error = null
  const retry = () => {
    new Promise((resolve, reject) => {
      cancel = () => {
        reject(error)
        onCancel(error)
      }
      fn().then((res) => {
        onSuccess(res)
        resolve(res)
      }).catch((err) 
               
               => {
        error = err
        setTimeout(() => retry(), delay)
        delay = delay * 2
      })
    })
  }
  retry()
  return function () {
    return cancel()
  };
}
```

Async写法

```javascript
let count = 0;
function fakeRequest() {
  return new Promise((resolve, reject) => {
    if (++count > 3) {
      resolve("data");
    } else {
      reject(new Error("failed"));
    }
  });
}

function sendWithRetry(fn, onSuccess, onCancel) {
  let delay = 1000
  let cancel = null
  let error = null
  const sleep = () => new Promise((res) => setTimeout((res), delay))
  const retry = async () => {
    while (true) {
      cancel = () => {
        onCancel(error)
        throw error
      }
      try {
        const res = await fn()
        onSuccess(res)
        return
      } catch (e) {
        error = e
        await sleep()
        delay = delay * 2
      }
    }
  }
  retry()
  return function () {
    return cancel()
  };
}

const cancel = sendWithRetry(
  fakeRequest,
  (data) => {
    console.log("结果：", data);
  },
  () => {
    console.log("被取消了");
  }
);

setTimeout(() => {
  cancel(); // 取消、中断轮询
}, 3000);

```



### Promise的then的第二个参数和catch的区别

如果在then的第一个函数里抛出了异常，后面的catch能捕获到，而then的第二个函数捕获不到：then的第二个参数本来就是用来处理上一层状态为失败的



## 参考

[剖析Promise内部结构，一步一步实现一个完整的、能通过所有Test case的Promise类 ](https://github.com/xieranmaya/blog/issues/3)

[你真的懂Promise吗](https://github.com/ljianshu/Blog/issues/81)

[要就来45道Promise面试题一次爽到底](https://juejin.cn/post/6844904077537574919)

[由一道bilibili面试题看Promise异步执行机制](https://github.com/sisterAn/blog/issues/86)

[Promise](https://sunchang612.github.io/blog/javascript/basics/promise.html#%E5%9F%BA%E6%9C%AC%E4%BD%BF%E7%94%A8)