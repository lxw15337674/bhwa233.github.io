---
title: "Slate 实践总结"
date: 2022-08-12T11:11:21+08:00
draft: false
tags: ["slate.js"]
categories: ["富文本"]
typora-root-url: ..\..\static
---

## 概念



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
- `set_node`：设置节点
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

