---
title: "Hook原理"
date: 2022-09-04T16:57:06+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

>作者：宫秋
>链接：https://juejin.cn/post/7119102104337121316
>来源：稀土掘金

### 原理

hooks 的实现就是基于 fiber 的，会在 fiber 节点上放一个链表，每个节点的 memorizedState 属性上存放了对应的数据，然后不同的 hooks api 使用对应的数据来完成不同的功能。

hooks 就是通过把数据挂载到组件对应的 fiber 节点上memorizedState属性来实现的。

memorizedState是一个链表，会在第一次调用时mount，后面只需要update。

## 具体 hook

### useRef

> 代码位置：[mountRef](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1208)、[updateRef](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1218)

- **mount 时**：把传进来的 value 包装成一个含有 current 属性的对象，然后放在 `memorizedState` 属性上。
- **update 时**：直接返回，没做特殊处理

![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/d98ba0041132406888c63b93963afdac%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/5282a7fd83fa44b498902e23d52388b4%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

#### 对于设置了 ref 的节点，什么时候 ref 值会更新？

组件在 commit 阶段的 mutation 阶段执行 DOM 操作，所以对应 ref 的更新也是发生在 mutation 阶段。



### useCallback

> 代码位置：[mountCallback](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1404)、[updateCallback](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1411)

- **mount 时**：在 memorizedState 上放了一个数组，第一个元素是传入的回调函数，第二个是传入的 deps。
- **update 时**：更新的时候把之前的那个 memorizedState 取出来，和新传入的 deps 做下对比，如果没变，那就返回之前的回调函数，否则返回新传入的函数。

![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/cb27799329a6419392e477fb2f4f775d%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/b7a17b3c9b6a4de39396fb3fbd703052%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

> **比对是依赖项是否一致的时候，用的是**`Object.is`：
>
> Object.is() 与 [===](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FReference%2FOperators%23%E5%85%A8%E7%AD%89%E8%BF%90%E7%AE%97%E7%AC%A6) 不相同。差别是它们对待有符号的零和 NaN 不同，例如，=== 运算符（也包括 == 运算符）将数字 -0 和 +0 视为相等，而将 [Number.NaN](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FReference%2FGlobal_Objects%2FNumber%2FNaN) 与 [NaN](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FReference%2FGlobal_Objects%2FNaN) 视为不相等。

```javascript
function areHookInputsEqual(
  nextDeps: Array<mixed>,
  prevDeps: Array<mixed> | null,
) {
  for (let i = 0; i < prevDeps.length && i < nextDeps.length; i++) {
    // is() 用的是 Object.is，只是多了些兼容代码
    if (is(nextDeps[i], prevDeps[i])) {
      continue;
    }
    return false;
  }
  return true;
}
```

### useMemo

> 代码位置：[mountMemo](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1427)、[updateMemo](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1438)

和 useCallback 大同小异。

- **mount 时**：在 memorizedState 上放了个数组，第一个元素是**传入函数的执行结果**，第二个元素是 deps。
- **update 时**：取出之前的 memorizedState，和新传入的 deps 做下对比，如果没变，就返回之前的值。如果变了，创建一个新的数组放在 memorizedState，第一个元素是新传入函数的执行结果，第二个元素是 deps。

![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/f96601c255974a26bb2b1b05e9994f63%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/45b025beb3e4415a94aed83487014dc3%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

### useEffect

> 代码位置：[mountEffectImpl](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1223)、[updateEffectImpl](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1235)

useLayoutEffect 在 mount 和 update 这块和 useEffect 差不多，就不展开讲了。

mount 时和 update 时涉及的主要方法都是 `pushEffect`，update 时判断依赖是否变化的原理和useCallback 一致。像上面提到的 memoizedState 存的是创建的 effect 对象的环状链表。

![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/c0528b2403b5457b9404c332dff39143%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

`pushEffect` 的作用：是创建 effect 对象，并将组件内的 effect 对象串成**环状单向链表**，放到`fiber.updateQueue`上面。即 **effect 除了保存在 fiber.memoizedState 对应的 hook 中，还会保存在 fiber 的 updateQueue 中**。

```javascript
function pushEffect(tag, create, destroy, deps) {
  // 创建 effect 对象
  var effect = {
    tag: tag,	// effect的类型，区分是 useEffect 还是 useLayoutEffect
    create: create,	// 传入use（Layout）Effect函数的第一个参数，即回调函数
    destroy: destroy,	// 销毁函数
    deps: deps,	// 依赖项
    // Circular
    next: null
  };
  // 获取 fiber 的 updateQueue
  var componentUpdateQueue = currentlyRenderingFiber$1.updateQueue;

  if (componentUpdateQueue === null) {
    componentUpdateQueue = createFunctionComponentUpdateQueue();
    currentlyRenderingFiber$1.updateQueue = componentUpdateQueue;
    // 如果前面没有 effect，则将componentUpdateQueue.lastEffect指针指向effect环状链表的最后一个
    componentUpdateQueue.lastEffect = effect.next = effect;
  } else {
    var lastEffect = componentUpdateQueue.lastEffect;

    if (lastEffect === null) {
      componentUpdateQueue.lastEffect = effect.next = effect;
    } else {
      // 如果前面已经有 effect，将当前生成的 effect 插入链表尾部
      var firstEffect = lastEffect.next;
      lastEffect.next = effect;
      effect.next = firstEffect;
      // 把最后收集到的 effect 放到 lastEffect 上面
      componentUpdateQueue.lastEffect = effect;
    }
  }

  return effect;
}

function createFunctionComponentUpdateQueue() {
  return {
    lastEffect: null,
    stores: null
  };
}

```

hook 内部的 effect 主要是作为上次更新的 effect，为本次创建 effect 对象提供参照（对比依赖项数组），updateQueue 的 effect 链表会作为最终被执行的主体，带到 commit 阶段处理。即 `fiber.updateQueue` 会在本次更新的 commit 阶段中被处理，其中 useEffect 是异步调度的，而 `useLayoutEffect` 的 effect 会在 commit 的 layout 阶段同步处理。等到 commit 阶段完成，更新应用到页面上之后，开始处理 useEffect 产生的 effect，简单说：

- useEffect 是异步调度，等页面渲染完成后再去执行，不会阻塞页面渲染。
- uselayoutEffect 是在 commit 阶段新的 DOM 准备完成，但还未渲染到屏幕前，同步执行。

#### 为什么如果不把依赖放到 deps，useEffect 回调执行的时候拿的会是旧值？

从 `updateEffectImpl` 的逻辑可以看出来，effect 对象只有在 deps 变化的时候才会重新生成，也就保证了，如果不把依赖的数据放到 deps 里面，用的 `effect.create`还是上次更新时的回调，函数内部用到的依赖自然就还是上次更新时的。即不是 useEffect 特意将回调函数内部用到的依赖存下来，而是因为，用的回调函数就是上一次的，自然也是从上一次的上下文中取依赖值，除非把依赖加到 deps 中，重新获取回调函数。

依照这个处理方式也就能了解到：对于拿对象里面的值的情况，如果对象放在组件外部，或者是通过 useRef 存储，即使没有把对象放到 deps 当中，也能拿到最新的值，因为 `effect.create` 拿的只是对象的引用，只要对象的引用本身没变就行。

### useState

> 代码位置：[mountState](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1143)、[updateState](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Facdlite%2Freact%2Fblob%2F1fb18e22ae66fdb1dc127347e169e73948778e5a%2Fpackages%2Freact-reconciler%2Fsrc%2FReactFiberHooks.new.js%23L1168)

- **mount 时：\**将初始值存放在`memoizedState` 中，`queue.pending`用来存调用 setValue（即 dispath）时创建的最后一个 update ，是个\**环状链表，最终返回一个数组，包含初始值和一个由**`dispatchState`**创建的函数。**

> **为什么要是环状链表？—— 在获取头部或者插入尾部的时候避免不必要的遍历操作**
>
> *（上面提到的 fiber.updateQueue 、 useEffect 创建的 hook 对象中的 memoizedState 存的 effect 环状链表，以及 useState 的 queue.pending 上的 update 对象的环状链表，都是这个原因）*
>
> 方便定位到链表的第一个元素。updateQueue 指向它的最后一个 update，updateQueue.next 指向它的第一个update。
>
> 若不使用环状链表，updateQueue 指向最后一个元素，需要遍历才能获取链表首部。即使将updateQueue指向第一个元素，那么新增update时仍然要遍历到尾部才能将新增的接入链表。

```javascript
function mountState(initialState) {
  var hook = mountWorkInProgressHook();

  if (typeof initialState === 'function') {
    // $FlowFixMe: Flow doesn't like mixed types
    initialState = initialState();
  }

  hook.memoizedState = hook.baseState = initialState;
  var queue = {
    pending: null,	// update 形成的环状链表
    interleaved: null,		// 存储最后的插入的 update 
    lanes: NoLanes,
    dispatch: null,		// setValue 函数
    lastRenderedReducer: basicStateReducer,	// 上一次render时使用的reducer
    lastRenderedState: initialState		// 上一次render时的state
  };
  hook.queue = queue;
  var dispatch = queue.dispatch = dispatchSetState.bind(null, currentlyRenderingFiber$1, queue);
  return [hook.memoizedState, dispatch];
}
复制代码
```

- **update 时：可以看到，其实调用的是** `updateReducer`，只是 reducer 是固定好的，作用就是用来直接执行 setValue（即 dispath） 函数传进来的 action，即 useState 其实是对 useReducer 的一个封装，只是 reducer 函数是预置好的。

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/01416b7088b24294a67cac8a4a6d30a0~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp)

**updateReducer 主要工作**：

- 将 baseQueue 和  pendingQueue 首尾合并形成新的链表
- baseQueue 为之前因为某些原因导致更新中断从而剩下的 update 链表，pendingQueue 则是本次产生的 update链表。会把 baseQueue 接在 pendingQueue 前面。
- 从 baseQueue.next 开始遍历整个链表执行 update，每次循环产生的 newState，作为下一次的参数，直到遍历完整个链表。即**整个合并的链表是先执行上一次更新后再执行新的更新，以此保证更新的先后顺序**。
- 最后更新 hook 上的参数，返回 state 和 dispatch。

```javascript
function updateReducer(reducer, initialArg, init) {
  var hook = updateWorkInProgressHook();
  // hook.queue.pending 指向update环转链表的最后一个update，即链表尾部
  var queue = hook.queue;

  queue.lastRenderedReducer = reducer;
  var current = currentHook; // The last rebase update that is NOT part of the base state.

  // 由于之前某些高优先级任务导致更新中断，baseQueue 记录的就是尚未处理的最后一个 update
  var baseQueue = current.baseQueue; // The last pending update that hasn't been processed yet.
  // 当前 update 链表最后一个 update
  var pendingQueue = queue.pending;

  if (pendingQueue !== null) {
    // We have new updates that haven't been processed yet.
    // We'll add them to the base queue.
    if (baseQueue !== null) {
      // 合并 baseQueue 和 pendingQueue，baseQueue 排在 pendingQueue 前面
      var baseFirst = baseQueue.next;
      var pendingFirst = pendingQueue.next;
      baseQueue.next = pendingFirst;
      pendingQueue.next = baseFirst;
    }

    current.baseQueue = baseQueue = pendingQueue;
    queue.pending = null;
  }

  // 合并后的 update 链表不为空时开始循环整个 update 链表计算新 state
  if (baseQueue !== null) {
    // We have a queue to process.
    var first = baseQueue.next;
    var newState = current.baseState;	// useState hook当前的state
    var newBaseState = null;
    var newBaseQueueFirst = null;
    var newBaseQueueLast = null;
    var update = first;

    do {
      var updateLane = update.lane;

      ...
      
      if (update.hasEagerState) {
        // If this update is a state update (not a reducer) and was processed eagerly,
        // we can use the eagerly computed state
        newState = update.eagerState;
      } else {
        // 取得当前的update的action，可能是函数也可能是具体的值
        var action = update.action;
        newState = reducer(newState, action);
      }
      
      update = update.next;
    } while (update !== null && update !== first);

    ...

    // 把最终得倒的状态更新到 hook上
    hook.memoizedState = newState;
    hook.baseState = newBaseState;
    hook.baseQueue = newBaseQueueLast;
    queue.lastRenderedState = newState;
  } 

  ...

  var dispatch = queue.dispatch;
  return [hook.memoizedState, dispatch];
}
复制代码
```

#### dispath 调用时做了什么事情？

主要是执行 `dispatchSetState`函数，创建本次更新的 update 对象，计算本地更新后的新值，存储到 `update.eagerState`中，并把该 update 和之前该 hook 已经产生的 update 连成环状链表。

- **创建 update 对象：**

```javascript
var update = {
  lane: lane,
  action: action,	// 执行的具体数据操作
  hasEagerState: false,
  eagerState: null,		// 依据当前 state 和 action 计算出来的新 state
  next: null			//指向下一个update的指针
};
复制代码
```

- **构建 update 环状链表**：如果前面没有 update，则直接自己连自己，如果有update，则将自己插入到原本最后一个 update 与 第一个 update 之间，并将自己赋值给存储最后一个 update 的 `queue.interleaved`

![img](https://raw.githubusercontent.com/lxw15337674/PicGo_image/main/8445df81cc694db9b9e3d5c53041f475%7Etplv-k3u1fbpfcp-zoom-in-crop-mark%3A3024%3A0%3A0%3A0.awebp)

`dispatchSetState`的作用：

```javascript
function dispatchSetState(fiber, queue, action) {

  // 创建 update 
  var update = {
    lane: lane,
    action: action,
    hasEagerState: false,
    eagerState: null,
    next: null
  };
  
  // 是否在渲染阶段更新
  if (isRenderPhaseUpdate(fiber)) {
    // 将 update 存到 queue.pending 当中
    enqueueRenderPhaseUpdate(queue, update);
  } else {
    ...
    var lastRenderedReducer = queue.lastRenderedReducer;
    ...
    
    // 计算当前 reducer 下生成的 state
    var currentState = queue.lastRenderedState;
    var eagerState = lastRenderedReducer(currentState, action); 
  
    // Stash the eagerly computed state, and the reducer used to compute
    // it, on the update object. If the reducer hasn't changed by the
    // time we enter the render phase, then the eager state can be used
    // without calling the reducer again.
    update.hasEagerState = true;
    update.eagerState = eagerState;
    
    // 将新增的 update 插入 update 链表尾部并返回 root 节点
    var root = enqueueConcurrentHookUpdate(fiber, queue, update, lane);
  
    if (root !== null) {
      var eventTime = requestEventTime();
  
      // 执行调度方法，实现更新
      scheduleUpdateOnFiber(root, fiber, lane, eventTime);
      entangleTransitionUpdate(root, queue, lane);
    }
  }
  
  markUpdateInDevTools(fiber, lane);
}


// 将新增的 update 插入 update 链表尾部
function enqueueConcurrentHookUpdate(fiber, queue, update, lane) {
  var interleaved = queue.interleaved;

  if (interleaved === null) {
    // This is the first update. Create a circular list.
    update.next = update; // At the end of the current render, this queue's interleaved updates will
    // be transferred to the pending queue.

    pushConcurrentUpdateQueue(queue);
  } else {
    update.next = interleaved.next;
    interleaved.next = update;
  }

  queue.interleaved = update;
  return markUpdateLaneFromFiberToRoot(fiber, lane);
}

// 将 update 存到 queue.pending 当中
function enqueueRenderPhaseUpdate(queue, update) {
  // This is a render phase update. Stash it in a lazily-created map of
  // queue -> linked list of updates. After this render pass, we'll restart
  // and apply the stashed updates on top of the work-in-progress hook.
  didScheduleRenderPhaseUpdateDuringThisPass = didScheduleRenderPhaseUpdate = true;
  var pending = queue.pending;

  if (pending === null) {
    // This is the first update. Create a circular list.
    update.next = update;
  } else {
    update.next = pending.next;
    pending.next = update;
  }

  queue.pending = update;
}
复制代码
```

#### 简单实现

> 详细讲解原文地址：[极简 hook 实现](https://link.juejin.cn?target=https%3A%2F%2Freact.iamkasong.com%2Fhooks%2Fcreate.html%23%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86)

涵盖了dispath、创建 update、形成 update 环状链表、更新时遍历整个 update 链表、通过 action 计算新 state 的大概逻辑。

```javascript
let workInProgressHook;
let isMount = true;	// 是mount还是update。

const fiber = {
  memoizedState: null,	// 保存该FunctionComponent对应的Hooks链表
  stateNode: App
};

function schedule() {
  /* 
   更新前将workInProgressHook重置为fiber保存的第一个Hook，
   workInProgressHook变量指向当前正在工作的hook，
   在组件render时，每当遇到下一个useState，我们移动workInProgressHook的指针。
   这样，只要每次组件render时useState的调用顺序及数量保持一致，那么始终可以通过workInProgressHook找到当前useState对应的hook对象。
  */
  workInProgressHook = fiber.memoizedState;
  // 触发组件render
  const app = fiber.stateNode();
  // 组件首次render为mount，以后再触发的更新为update
  isMount = false;
  return app;
}

function dispatchAction(queue, action) {
  // 创建update
  const update = {
    action,
    next: null
  }
  // 环状单向链表操作
  if (queue.pending === null) {
    update.next = update;
  } else {
    update.next = queue.pending.next;
    queue.pending.next = update;
  }
  queue.pending = update;

  // 模拟React开始调度更新
  schedule();
}

function useState(initialState) {
  let hook;	// 当前useState使用的hook会被赋值该该变量

  if (isMount) {
    // mount时为该useState生成hook
    hook = {
      // 保存update的queue，即上文介绍的queue
      queue: {
        pending: null	// 始终指向最后一个插入的 update，是一个环状单向链表
      },
      // 保存hook对应的state
      memoizedState: initialState,
       // 与下一个Hook连接形成单向无环链表
      next: null
    }
    // 将hook插入fiber.memoizedState链表末尾
    if (!fiber.memoizedState) {
      fiber.memoizedState = hook;
    } else {
      workInProgressHook.next = hook;
    }
    workInProgressHook = hook;	// 移动workInProgressHook指针
  } else {
    // update时从workInProgressHook中取出该useState对应的hook
    hook = workInProgressHook;	 // update时找到对应hook
    workInProgressHook = workInProgressHook.next;	// 移动workInProgressHook指针
  }

  let baseState = hook.memoizedState;	// update执行前的初始state
  if (hook.queue.pending) {
    // 根据queue.pending中保存的update更新state
    let firstUpdate = hook.queue.pending.next;	// 获取update环状单向链表中第一个update

    do {
      // 执行update action
      const action = firstUpdate.action;
      baseState = action(baseState);
      firstUpdate = firstUpdate.next;
      // 最后一个update执行完后跳出循环
    } while (firstUpdate !== hook.queue.pending)
      hook.queue.pending = null;	// 清空queue.pending
  }
  hook.memoizedState = baseState;	// 将update action执行完后的state作为memoizedState

  return [baseState, dispatchAction.bind(null, hook.queue)];
}

function App() {
  const [num, updateNum] = useState(0);

  console.log(`${isMount ? 'mount' : 'update'} num: `, num);

  return {
    click() {
      updateNum(num => num + 1);
    }
  }
}

window.app = schedule();

```





