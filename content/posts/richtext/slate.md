---
title: "Slate 实践总结"
date: 2022-08-12T11:11:21+08:00
draft: false
tags: ["slate.js"]
categories: ["富文本"]
typora-root-url: ..\..\static
---



## 定位

### path

节点路径，相对于根节点的相对位置路径。

```typescript
/**
 * `Path` arrays are a list of indexes that describe a node's exact position in
 * a Slate node tree. Although they are usually relative to the root `Editor`
 * object, they can be relative to any `Node` object.
 */

export type Path = number[]
```

**例子**

```typescript
const editor = {
    children: [
        // Path: [0]
        {
            type: 'paragraph',
            children: [
                // Path: [0, 0]
                {
                    text: 'A line of text!',
                },
                // Path: [0, 1]
                {
                    text: 'Another line of text!',
                    bold: true,
                },
            ],
            },
		// Path: [1]
		{
			type: 'paragraph',
			children: [
				// Path: [1, 0]
				{
					text: 'A line of text!',
				},
			],
		},
    ],
}
```



### point

定位单一字符的位置。先用`path`表示字符节点，再用`offset`表示字符在节点的位置。

```typescript
/**
 * `Point` objects refer to a specific location in a text node in a Slate
 * document. Its path refers to the location of the node in the tree, and its
 * offset refers to the distance into the node's string of text. Points can
 * only refer to `Text` nodes.
 */

export interface BasePoint {
  path: Path
  offset: number
}
```

**例子**

```typescript
const editor = {
    children: [
        {
            type: 'paragraph',
            children: [
                {
                    //  "!" is { path: [0, 0], offset: 14 }
                    text: 'A line of text!',
                },
            ],
        },
		{
			type: 'paragraph',
			children: [
				{
					// The point of the character "l" is { path: [1, 0], offset: 2 }
					text: 'A line of text!',
				},
			],
		},
    ],
  
}
```

### range

选取区间。分别用`anchor`， `focus`选取区间的开始位置和结束位置。



```typescript
/**
 * `Range` objects are a set of points that refer to a specific span of a Slate
 * document. They can define a span inside a single node or a can span across
 * multiple nodes.
 */

export interface BaseRange {
  anchor: Point
  focus: Point
}

```

**例子**

```typescript
// mynameisbhwa233

{
	anchor: {
		path: [0, 0],
		offset: 0,	
	},
	focus: {
		path: [0, 0],
		offset:5,
	},
}
// 表示选取内容为：myname
```

### span

用于表示没有文本的选区区间。例如选取两个图片元素。

```typescript
/**
 * The `Span` interface is a low-level way to refer to locations in nodes
 * without using `Point` which requires leaf text nodes to be present.
 */

export type Span = [Path, Path]
```



### location

 `Path` 、 `Point` 、 `Range` 的联合类型

```typescript
/**
 * The `Location` interface is a union of the ways to refer to a specific
 * location in a Slate document: paths, points or ranges.
 *
 * Methods will often accept a `Location` instead of requiring only a `Path`,
 * `Point` or `Range`. This eliminates the need for developers to manage
 * converting between the different interfaces in their own code base.
 */
export type Location = Path | Point | Range
```



## refs

slate通过refs来指向某个节点（类似于React Refs）的定位。**当节点更新时，对应的定位会跟着变化**。

```typescript
export interface PathRef {
  current: Path | null 
  affinity: 'forward' | 'backward' | null
  unref(): Path | null
}

export interface PointRef {
  current: Point | null
  affinity: 'forward' | 'backward' | null
  unref(): Point | null
}

export interface RangeRef {
  current: Range | null
  affinity: 'forward' | 'backward' | 'outward' | 'inward' | null
  unref(): Range | null
}
```

- `current`：节点定位。
- `affinity`：作为执行opeeration时`transform`函数的参数。
- `unref`：取消指向。

### 设置refs

```typescript
export interface EditorInterface {
	pathRef: (
    editor: Editor,
    path: Path,
    options?: {
      affinity?: 'backward' | 'forward' | null
    }
  ) => PathRef
	pointRef: (
    editor: Editor,
    point: Point,
    options?: {
      affinity?: 'backward' | 'forward' | null
    }
  ) => PointRef
	rangeRef: (
    editor: Editor,
    range: Range,
    options?: {
      affinity?: 'backward' | 'forward' | 'outward' | 'inward' | null
    }
  ) => RangeRef
}
```



### 获取refs

```typescript
export interface EditorInterface {
	pathRefs: (editor: Editor) => Set<PathRef>
	pointRefs: (editor: Editor) => Set<PointRef>
	rangeRefs: (editor: Editor) => Set<RangeRef>
}
```





## operation

`operation` 是slate中最基础的核心操作（即原子操作），对编辑器的一切修改都是通过一个或多个`opertaion`来实现的。

### 类型

`operation`可以分为三类：

**Node**

负责与节点（node）相关的操作：

- `insert_node`：插入节点
- `merge_node`：合并节点
- `move_node`：移动节点
- `remove_node`：删除节点
- `set_node`：设置节点属性
- `split_node`：拆分节点

**Selection** 

负责与选区（selection）相关的操作：

- `set_selection`：设置选区

**Text** 

负责与纯文字相关的操作：

- `insert_text`：插入文本

- `remove_text`：删除文本

### apply

operation是通过`editor.apply()`调用。

例子：

```typescript
editor.apply({
  type: 'insert_text',
  path: [0, 0],
  offset: 15,
  text: 'A new string of text to be inserted.',
})

editor.apply({
  type: 'remove_node',
  path: [0, 0],
  node: {
    text: 'A line of text!',
  },
})

editor.apply({
  type: 'set_selection',
  properties: {
    anchor: { path: [0, 0], offset: 0 },
  },
  newProperties: {
    anchor: { path: [0, 0], offset: 15 },
  },
})
```

`apply()`的工作流程：

## Normalizing

slate规范化是通过一组完整的FLUSHING搭配一次Normalize。



为了确保slate能够正确的解析，slate有一些约束，针对这些约束也会做一些操作来保证规范化：

1. 所有的`Element`节点内必须至少一个Text子节点。如果遇到不符合规范的节点，会自动加入一个空的`Text`节点。

   原因：为了确保编辑器的`selection`能够选中空元素。

2. 会将相邻且属性相同的`text`节点合并成一个节点。

   原因：为了防止编辑器内的`text	`节点在新增、删除文字属性时造成节点无意义的拆分。

3. 块节点的子节点（children）只能是块元素（Block）、行内块状元素（inline-block）、text节点（inline）的一种。例如`paragraph` 节点的子节点不能既有`paragraph`block节点，还有`text`inline节点。slate会以子节点的第一个节点作为判断可接受类别的节点，删除其他不符合规范的子节点。

   原因：为了让拆分块节点相关的功能保持稳定的结果。

4. 内联节点现在总是被文本节点包围。如果没有，slate会自动插入空的`Text`节点。

   原因：优化编辑器的内容结构。

5. 第一层节点只能是`Block`节点，其他类型的节点会被直接删除。

   原因：确保编辑器存在Block节点，确保拆分节点功能正常。

```typescript
const initialValue: Descendant[] = [
  //是block节点，正常。
  {
    type: 'paragraph',
    children: [
      { text: 'This is editable plain text, just like a <textarea>!' },
      {
        type: 'link',
        url: 'www.baidu.com',
        text: '123',
      },
    ],
  },
  // 是text节点，会被直接删除。
  { text: 'This is editable plain text, just like a <textarea>!' }, 
];
```

### 自定义规范化

规范化是通过editor 里的 `normalizeNode()`来实现 ， 如果需要进行定制化，可以通过插件对`normalizeNode `进行重写。但需要注意几点：

**normalizing是重复执行的**

slate是通过递归实现对内容深度遍历，即会从子节点开始`normalizing`再到父节点逐级进行规范化。

**避免对无子节点的节点进行规范化**

slate在`normalizeNode`前会遍历节点，没有子节点的节点会自动加入一个空的`Text`作为子节点。

**避免无法满足约束**

应避免自定义的约束，在修正后仍无法满足约束，导致无限循环`normalizeNode`。



## 运作流程

![运作流程图](/images/201393593GX3OuA8NF.png)

完整流程：

1. 通过`Transform`的api触发编辑器更新，执行多次`opertaion`。
2. 第一次的`opertaion`除了会执行`transform` 与`normalize` 之外，也会将 `FLUSHING` 設為 `true` ，并将 `onChange` 的执行以 Promise 的 Micro-Task 包装起来。
3. `opertaion`通过 `getDirtyPath` 取得并更新到 `DIRTY_PATHS` WeakMap variable。
4. `opertaion`再通过 `GeneralTransforms.transform` 和` Immer Draft State` 调用`applyToDraft` 更新 `children` 与 `selection`。
5. 执行`Transform` 的 `normalize`  与 `normalizeNode` 实现对脏路径的节点规范化，调用`Transform` 來更新节点以满足约束并重跑一次相同的 Transform 流程。
6. 完成所有同步更新后，执行Micro-Task的内容将 `FLUSHING` 设为 `false` 并触发 `onChange` 。

## Transforms

一个 `transform`是多个 `operation` 组成。一般开发中使用高阶(High-level) 的 `Transform`api 来替代 低阶（Low-level） 的 `operation`。





## API

`Text.decorations(node: Text, decorations: Range[]) => Text[]`

给区间的文本附加属性。

```typescript
const text = { text: 'This is text example2.' };
const ranges = [{
    anchor: { path: [0, 0], offset: 5 },
    focus: { path: [0, 0], offset: 7 },
    bold: true,
}];

/**
returns: [
    { text: 'This ' },
    { text: 'is', bold: true },
    { text: ' text example2.' },
] */
Text.decorations(text, ranges);
```

