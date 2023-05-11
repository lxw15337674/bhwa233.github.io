---
title: "Zustand"
date: 2023-03-29T15:22:32+08:00
draft: false
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

**[zustand](https://github.com/pmndrs/zustand)是一个react的状态管理库，可以替代context、redux使用。**

## 创建Store

set用于修改store属性，get获取store内的其他属性。

```typescript
interface Store {
  bears: number;
  cats: number;
  doubleBears: () => number;
  addOneBear: () => void;
  addOneCat: () => void;
}

const useBearStore = create<Store>((set, get) => ({
  bears: 0,
  cats: 0,
  doubleBears: () => {
    return get().bears * 2;
  },
  addOneBear: () =>
    set((state) => ({
      bears: state.bears + 1,
    })),
  addOneCat: () =>
    set((state) => ({
      cats: state.cats + 1,
    })),
}));
```

## 使用Store

### 获取所有state

```typescript
// 任意 state 发生变化时，都会触发组件的重新渲染
function BearCounter() {
  const { bears } = useBearStore();
  return <h1>{bears} around here ...</h1>;
}
```

这样做的问题是，任意state发生变化时，都会触发组件的重新渲染，这可能会导致性能问题。

### 选择单个state

```typescript
// 只有在 cats 变化时组件才会重新渲染。
function Cat() {
  const cats = useBearStore((state) => state.cats);
  return <h1>cats: {cats}</h1>;
}
```

在默认情况下，它使用严格相等（old === new）检测更改。这种检测方式对于基本数据类型的state选择是有效的。

### 组合多个state

如果需要构件由多个状态组成的引用数据类型（例如object、array），需要使用zustand/shallow提供的浅相等函数来进行浅层差异比较。

```typescript
// 任意 state 发生变化时，都会触发组件的重新渲染
function Cat() {
  const { cats } = useBearStore((state) => ({ cats: state.cats }));
  return <h1>cats: {cats}</h1>;
}

// 只有在 cats 变化时组件才会重新渲染。
function Cat() {
  const { cats } = useBearStore((state) => ({ cats: state.cats }), shallow);
  console.log("Cats", cats);
  return <h1>cats: {cats}</h1>;
}
```

shallow 函数的实现原理是通过遍历对象的每个属性值，如果某个属性值是对象，则递归调用 shallow 函数进行浅层比较，如果是其他类型的值，则使用 `Object.is` 进行比较。由于 `Object.is` 比较的是两个值是否相等，包括严格相等和同值相等，因此可以准确地判断值是否发生了变化。

当然也可以自己自定义比较函数。

```typescript
const treats = useBearStore(
  (state) => state.treats,
  (oldTreats, newTreats) => compare(oldTreats, newTreats)
);
```

### 衍生属性

1. zustand 用了类似 redux selector 的方法，实现相应的状态派生。
2. 可以实现只有监听的属性变化，才会重新渲染

```typescript
const doubleBears = (s: Store) => {
  return s.bears * 2;
}
function Bear() {
  const count = useBearStore(doubleBears, shallow)
  return <h1>Bear:{count}</h1>;
}
```

## 修改Store

### 覆盖Store

set 函数有一个默认为 false 的第二个参数。如果设置为 true，它会**替换**整个store而不是merge state。

```typescript
const useBearStore = create<Store>((set, get) => ({
  bears: 0,
  cats: 0,
  doubleBears: () => {
    return get().bears * 2;
  },
  addOneBear: () =>
    set((state) => ({
      bears: state.bears + 1,
    })),
  addOneCat: () =>
    set(
      (state) => ({
        cats: state.cats + 1,
      }),
      true // 修改后只剩下 store 中只有 cats
    ),
}));

```

### 异步操作

调用set。

```typescript
const useBearStore = create<Store>((set, get) => ({
  bears: 0,
  getBears: (n: number) => {
    setTimeout(() => {
      set({ bears: n })
    }, 2000)
  }
}));

```

### 在actions中获取state

1. 通过回调函数

```typescript
const useBearStore = create<Store>((set, get) => ({
  bears: 0,
  addOneBear: () => set(state => ({ bears: state.bears + 1 })),
}));

```

2. 通过get获取

```typescript
const useBearStore = create<Store>((set, get) => ({
  bears: 0,
  addOneBear: () => set({ bears: get().bears + 1 }),
}));

```



### 瞬时更新（针对经常发生的状态更改）

如果需要改变状态，而不期望重新渲染可以考虑使用订阅功能来实现，最好与useEffect结合使用，在卸载时自动取消订阅。

```typescript
const useScratchStore = create(set => ({ scratches: 0, ... }))

const Component = () => {
  const scratchRef = useRef(useScratchStore.getState().scratches)
  // Connect to the store on mount, disconnect on unmount, catch state-changes in a reference
  useEffect(() => useScratchStore.subscribe(
    state => (scratchRef.current = state.scratches)
  ), [])
  ...
```



## 组件外使用

### 获取、修改

```typescript
// 获取state
const bears = useBearStore.getState().bears
// 修改state
useBearStore.setState({ bears: 1 })
```

### 订阅

```typescript
// 监听所有更改，在每次更改时同步触发
const unSub = useBearStore.subscribe(console.log)
// 取消订阅
unSub()
```

如果需要选择订阅，需要使用`subscribeWithSelector`中间件。

```typescript
subscribe(selector, callback, options?: { equalityFn, fireImmediately }): Unsubscribe
```

举例

```typescript
import { subscribeWithSelector } from 'zustand/middleware'
import { create } from 'zustand';

interface Store {
  bears: number;
  addOneBear: () => void;
}
const useBearStore = create(
  subscribeWithSelector<Store>((set, get) => ({
    bears: 0,
    addOneBear: () => set({ bears: get().bears + 1 }),
  }))
)

// 监听bear的变化
const unsub = useBearStore.subscribe(
  (state) => state.bears,
  (bears, previousBears) => console.log(bears, previousBears)
)
// 支持可选的比较函数。
const unsub2 = useBearStore.subscribe(
  (state) => [state.bear, state.fur],
  console.log,
  { equalityFn: shallow }
)
// 立即订阅并触发（执行）
const unsub3 = useBearStore.subscribe((state) => state.bear, console.log, {
  fireImmediately: true,
})
```

 

## 脱离react使用

Zustand核心可以在没有React依赖的情况下导入和使用。唯一的区别是create函数不返回hook，而是API。

```
import { createStore } from 'zustand/vanilla'

const store = createStore(() => ({ ... }))
const { getState, setState, subscribe } = store

export default store
```

你可以使用自v4版本起提供的useStore钩子来使用Vanilla Store。

```
import { useStore } from 'zustand'
import { vanillaStore } from './vanillaStore'

const useBoundStore = (selector) => useStore(vanillaStore, selector)
```



## 中间件

### 自定义中间件

可以扩展zustand功能。一个完整例子：

```typescript
// Log every time state is changed
import { StateCreator } from 'zustand';

type LogImpl = <T>(
  storeInitializer: StateCreator<T, [], []>,
) => StateCreator<T, [], []>;

// Log every time state is changed
const log: LogImpl = config => (set, get, api) => {
  console.log(api);
  return config(
    (...args) => {
      console.log('  applying', args);
      set(...args);
      console.log('  new state', get());
    },
    get,
    api,
  );
};
export default log;

const useBeeStore = create(
  log((set) => ({
    bees: false,
    setBees: (input) => set({ bees: input }),
  }))
)
```

### 持久化中间件

可以根据需要来持久化state

```typescript
import { create } from 'zustand'
import { persist, createJSONStorage } from 'zustand/middleware'

const useFishStore = create(
  persist(
    (set, get) => ({
      fishes: 0,
      addAFish: () => set({ fishes: get().fishes + 1 }),
    }),
    {
      name: 'food-storage', // unique name
      storage: createJSONStorage(() => sessionStorage), // (optional) by default, 'localStorage' is used
    }
  )
)
```

[See the full documentation for this middleware.](https://github.com/pmndrs/zustand/blob/main/docs/integrations/persisting-store-data.md)

### Immer 中间件

```typescript
import { create } from 'zustand'
import { immer } from 'zustand/middleware/immer'

const useBeeStore = create(
  immer((set) => ({
    bees: 0,
    addBees: (by) =>
      set((state) => {
        state.bees += by
      }),
  }))
)
```

### redux中间件

使用类redux写法

```typescript
import { create } from 'zustand'
import { redux } from 'zustand/middleware'

const types = { increase: 'INCREASE', decrease: 'DECREASE' }

const reducer = (state, { type, by = 1 }) => {
  switch (type) {
    case types.increase:
      return { grumpiness: state.grumpiness + by }
    case types.decrease:
      return { grumpiness: state.grumpiness - by }
  }
}

const useGrumpyStore = create(redux(reducer, initialState))
```



### Redux devtools 

可以支持在redux detools中调试

```typescript
import { devtools } from 'zustand/middleware'

// Usage with a plain action store, it will log actions as "setState"
const usePlainStore1 = create(devtools(store), { name, store: storeName1 })
const usePlainStore2 = create(devtools(store), { name, store: storeName2 })
// Usage with a redux store, it will log full action types
const useReduxStore = create(devtools(redux(reducer, initialState)), { name, store: storeName3 })
const useReduxStore = create(devtools(redux(reducer, initialState)), { name, store: storeName4 })
```



## React context

使用 create 创建的 store 本身不需要Context。但在某些情况下，您可能希望使用context进行依赖注入，可以参考例子：

```typescript
import { createContext, useContext } from 'react'
import { createStore, useStore } from 'zustand'

const store = createStore(...) // vanilla store without hooks

const StoreContext = createContext()

const App = () => (
  <StoreContext.Provider value={store}>
    ...
  </StoreContext.Provider>
)

const Component = () => {
  const store = useContext(StoreContext)
  const slice = useStore(store, selector)
    ...

```



