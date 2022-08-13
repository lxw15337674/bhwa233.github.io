---
title: "Slate transform API 详细说明"
date: 2022-08-13T16:04:44+08:00
draft: false
tags: ["slate"]
categories: [""]
typora-root-url: ..\..\static
weight: 2
---

##  通用配置

### NodeOptions

```typescript
interface NodeOptions {
  at?: Location; // 需要操作的节点，默认为选区。
  match?: NodeMatch<T>; // 自定义匹配方法。
  // 指明Editor.nodes(),以哪种模式遍历slate node tree
  // 'all': 遍历所有节点。
  // 'highest': 只遍历最上层的节点。
  // 'lowest': 只遍历最下层的节点。
  mode?: ('highest' | 'lowest') | ('all' | 'highest' | 'lowest');
  voids?: boolean; // 是否跳过空节点。
}
```


### hanging

`hanging` 在 Slate 里头的意思代表'这段 Range 涵盖到了不存在的节点。如果传入的 为 Range type 的话，这个 value 会决定 Range 是否要另外修正为 type 。

假设目前的 Slate Document 如下：

```jsx
[{text: 'one '}, {text: 'two', bold: true}, {text: ' three'}]
```

这时用户看到的显示方式应该如下：

one **two** three

假设用户选取了 “two” ，此时可能会有几种`selection points` 来表示：

```typescript
// 1 -- no hanging
{
  anchor: { path: [1], offset: 0 },
  focus: { path: [1], offset: 3 }
}

// 2 -- anchor hanging
{
  anchor: { path: [0], offset: 4 },
  focus: { path: [1], offset: 3 }
}

// 3 -- focus hanging
{
  anchor: { path: [1], offset: 0 },
  focus: { path: [2], offset: 0 }
}

// 4 -- both hanging
{
  anchor: { path: [0], offset: 4 },
  focus: { path: [2], offset: 0 }
}
```


## Node

###  `insertNodes`
------


插入节点。如果没有指定位置，会在选区内插入。如果没有选区，则会在末尾插入。

#### 参数

- `editor: Editor`
- `nodes: Node | Node[]`
- `options: InsertNodesOptions`

```typescript
interface InsertNodesOptions extends NodeOptions {
	hanging?: boolean //是否包含不存在的节点。
	select?: boolean // 选区是否更新，如果是则选区会更新为插入节点的后面。
}
```

### `liftNodes`

------


将指定位置的内容，提升到上一层。如果需要，会将它的父级节点一分为二。

此 method 限制无法提升路径长度小于 2 的节点（路径长度为 1 的节点上层就是 Editor root 了）

逻辑分为4种情况：

1. 要提升的节点为其父层节点里的唯一子节点：向上提升并移除父层节点（因为它不再含有任何子节点了）
2. 要提升的节点为同层节点的第一顺位：将其移动到父层节点的原本路径
3. 要提升的节点为同层节点的最后一个顺位：将其移动到父层节点的后一个 sibling 位置
4. 其余状况则将要提升的节点的后一个 sibling 节点作为基准点，将父层节点拆分为二，并将要提升的节点移动到原始父层节点的后一个 sibling 。

```typescript
if (length === 1) {
  const toPath = Path.next(parentPath)
  Transforms.moveNodes(editor, { at: path, to: toPath, voids })
  Transforms.removeNodes(editor, { at: parentPath, voids })
} else if (index === 0) {
  Transforms.moveNodes(editor, { at: path, to: parentPath, voids })
} else if (index === length - 1) {
  const toPath = Path.next(parentPath)
  Transforms.moveNodes(editor, { at: path, to: toPath, voids })
} else {
  const splitPath = Path.next(path)
  const toPath = Path.next(parentPath)
  Transforms.splitNodes(editor, { at: splitPath, voids })
  Transforms.moveNodes(editor, { at: path, to: toPath, voids })
}
```

#### 参数

- `editor: Editor`
- `options: LiftNodesOptions`

```typescript
interface LiftNodesOptions extends NodeOptions {}
```

### `wrapNodes`

------

将指定的内容包装进一个新的 container 节点

#### 参数 

- `editor: Editor`
- `element: Element`：父层 container 节点
- `options: WrapNodesOptions`

```typescript
  interface UnwrapNodesOptions extends NodeOptions {
    split?: boolean// 当节点Range type 时，是否将节点拆分。
  }
```

  

### `unwrapNodes`

------

将指定节点的内容展开并提升至上一层的位置，如果传入的 为 Range type 则会拆分父层节点，为了确保只有展开 Range 覆盖的内容。

如果传入的为 Path，要提升的内容则为 Path 指向的节点覆盖到的所有文本 。

如果传入的 at 为 Range type 同时 split 参数设为 true ，则会先将 Range 所涵盖到的文字范围与其之外的文字先做节点拆分，确保只有 at 包含的文字集合被包装进新的 container 节点。否则传入的Range会以要提升的节点为单位去包含节点内的所有文字。

#### 参数 ：

- `editor: Editor`
- `options: UnwrapNodesOptions`

```typescript
  interface UnwrapNodesOptions extends NodeOptions {
    split?: boolean// 当节点Range type 时，是否将节点拆分。
  }
```

  

### `mergeNodes`

将指定位置的内容,与它同层的前一个node进行合并。并会移除合并过后所产生的空节点。

#### 参数 

- `editor: Editor`
- `options: MergeNodesOptions`

```typescript
interface MergeNodesOptions extends NodeOptions {
	hanging?: boolean //是否包含不存在的节点。
}
```

### `splitNodes`

------

拆分指定位置的节点。

#### 参数

- `editor: Editor`
- `options: SplitNodesOptions`

```typescript
interface SplitNodesOptions extends NodeOptions {
	always?: boolean // 是否总是拆分，例如拆分节点位于父节点的第一个或最后一个，这种情况不需要拆分父节点。
    height?: number //拆分节点与其父级相差的层级数
}
```



### `moveNodes`

------

将指定位置的节点从旧的 Location 移动到新的 Path

#### 参数 

- `editor: Editor`
- `options: MoveNodesOptions`

 ```typescript
  interface MoveNodesOptions extends NodeOptions {
  	to: Path // 移动的新路径（Path）
  }
 ```

### `removeNodes`

------

- 用途：将 Location 指向的单个/复数个节点从 Document 中移除`at`

#### 参数 

- `editor: Editor`
- `options: RemoveNodesOptions`

```typescript
interface RemoveNodesOptions extends NodeOptions {
  	hanging?: boolean //是否包含不存在的节点。
}
```

### `setNodes`

------

将指定位置的节点设置新属性

#### 参数 

- `editor: Editor`

- `props: Partial<Node>`：设置的新属性

- `options: SetNodesOption`

```typescript
interface SetNodesOptions extends NodeOptions {
  	hanging?: boolean  //是否包含不存在的节点。
    split?: boolean // 当节点Range type 时，是否将节点拆分。
}
```

### `unsetNodes`

------

取消指定位置的节点属性

#### 参数 

- `editor: Editor`

- `props: Partial<Node>`：取消设置的属性
- `options: UnsetNodesOptions`

```typescript
interface UnsetNodesOptions extends NodeOptions {
  split?: boolean。 // 当节点Range type 时，是否将节点拆分。
}
```



## selection

### `collapse`

------

将选区折叠为一个`Point`

#### 参数

- `editor: Editor`
- `options: CollapseOptions`

```typescript
interface CollapseOptions {
  // 决定折叠的方式。
  // anchor： 取selection 的 anchor。
  // focus：取selection 的 focus。
  // start：取selection 真正的 起始位置。 因为selection 可能是反向的。
  // end：取selection 真正的 结束位置。
  edge?: 'anchor' | 'focus' | 'start' | 'end'
}
```

### `deselect`

------

取消编辑器的选区。

#### 参数

- `editor: Editor`

### `move`

------

移动 `selection` 里的`Point`。

#### 参数

- `editor: Editor`
- `options: MoveOptions`

```typescript
interface MoveOptions {
  distance?: number // 搭配unit决定要移动的实际距离
  unit?: 'offset' | 'character' | 'word' | 'line' // 移动的单位
  reverse?: boolean // 移动的方式，true:向前移动。false:向后移动。
  // 要移动的点,默认值为null，会同时移动anchor与focus point。
  // anchor: 移动anchor
  // focus: 移动focus
  // start: 移动在选区起始位置的点
  // end: 移动在选区结尾位置的点
  edge?: 'anchor' | 'focus' | 'start' | 'end'
}
```

### `select`

------

重新设置 `selection` 。

#### 参数

- `editor: Editor`
- `target: Location`

### `setPoint`

设置`selection` 其中的一个`Point`。

#### 参数

- `editor: Editor`
- `props: Partial<Point>`
- `options: SetPointOptions`

```typescript
interface SetPointOptions {
  // 设置的点。
  // anchor: anchor
  // focus: focus
  // start: 在选区起始位置的点
  // end: 在选区结尾位置的点
  edge?: 'anchor' | 'focus' | 'start' | 'end';
}

```

### `setSelection`

------

设置新的prop属性在`selection` 上，同时可以确保`selection` 的`anchor` 或 `focus` 不会为`null`。

#### 参数

- `editor: Editor`

- `props: Partial<Range>`

## Text

### `insertText`

------

插入文本。

参数

- `editor: Editor`
- `text: string`
- `options: InsertTextOptions`


- options ：

  ```typescript
  interface InsertTextoptions {
    // 插入位置
    // 插入Path,将整个节点的文本内容替换为新的文本内容
    // 插入Range,将Range中的文字内容替换为新的文本内容
    // 插入Point,直接将文字插入到Point之后
    at?: Location
    voids?: boolean
  }
  ```


### `delete`

------

删除文字内容。

#### 参数

- `editor: Editor`

- `props: Partial<Range>`

```jsx
interface DeleteOptions {
  // 传入Path,将整个节点删除
  // 传入Range，将Range集合的文字删除
  // 传入Point，搭配distance与unit，决定删除文字的范围
  at?: Location;
  distance?: number; // 搭配unit决定要移动的实际距离
  unit?: 'character' | 'word' | 'line' | 'block'; //  移动的单位
  reverse?: boolean; //  移动的方式，true:向前移动。false:向后移动。
  hanging?: boolean; // 是否包含不存在的节点。
  voids?: boolean; // 是否包含空节点。
}

```

### `insertFragment`

------

插入Fragment。

#### 参数

- `editor: Editor`
- `fragment: Node[]`
- `options: InsertFragmentOptions`

```typescript
interface InsertFragmentOptions {
  // 插入位置
  // 插入Path,将Fragment插入到Path所在的节点开头
  // 插入Range,将Range中的文字内容移除后插入Fragment
  // 插入Point,直接将Fragment插入到Point之后
  at?: Location;
  hanging?: boolean; // 是否包含不存在的节点。
  voids?: boolean; // 是否包含空节点。
}
```

