---
title: "slate.js踩坑记录"
date: 2022-06-30T19:58:01+08:00
draft: false
tags: ["富文本","slate.js"]
categories: [""]
typora-root-url: ..\..\static
---

### 基本没有实践文档

因为slate在0.5版本进行了break改动，插件基本重构，所以基本没有可参考文档。

**解决方法** 

- #### 参考slate的Demo代码和[slate-yjs](https://github.com/BitPhinix/slate-yjs)的源码

### value值限制

value中必须有text或children，否则报错。

![image-20220630195948550](/images/image-20220630195948550.png)

**解决方法：**

插入一个空的line node。

```TypeScript
 const initialValue: Descendant[] = [
    {
      type: 'line',
      children: [
        { text: '' },
        {
          type: 'SelectType',
          items: [],
          text: '',//必须存在
        },
      ],
    },
  ];
```

### <Editable>不能设置lineheight

<Editable>必须被节点填充，否则点击会出现报错，认为是不可识别的node。

比如<Editable>设置lineheight，width，height等都会报错
### element类型

props.element的默认类型没有type，其实是有的。

```TypeScript
const renderElement = useCallback((props: RenderElementProps) => {
    switch ((props.element as any).type) {
      default:
        return <DefaultElement {...props} />;
    }
  }, []);
```

**解决方法**

自行declare

```TypeScript
declare module 'slate' {
    interface CustomTypes {
        Editor: ReactEditor;
        Element: CustomElement;
        Text: CustomText;
    }
}
```

### 默认值报错

value的默认值不能为空数组，否则会报错

![image-20220630200006806](/images/image-20220630200006806.png)

**解决方法**

默认一个空文本节点。

```TypeScript
const initialValue: Descendant[] = [{ children: [{ text: '' }], type: 'text' }];
```



### 单选在最后没有光标

当光标在单选时，光标就不会显示

**解决办法**

插入单选时，插入一个空文本

### autoFocus

默认的autoFocus没有光标。

 **解决方法** 

```TypeScript
   useEffect(() => {
        setTimeout(() => {
            Transforms.setSelection(editor, {
                anchor: {
                    path: [0, 0],
                    offset: 0,
                },
                focus: {
                    path: [0, 0],
                    offset: 0,
                },
            });
            ReactEditor.focus(editor);
        }, 100);
    }, []);
```

### slate 的value 只是默认值，不能联动
[文档链接](https://docs.slatejs.org/walkthroughs/01-installing-slate)

![image](https://user-images.githubusercontent.com/19898669/169041124-c0335333-12f4-4a52-a92c-1468d2e887f6.png)
