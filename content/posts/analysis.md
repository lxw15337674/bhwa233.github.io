---
title: "解析器"
date: 2022-08-02T18:06:56+08:00
draft: false
tags: [""]
categories: ["笔记"]
typora-root-url: ..\..\static
---

## 词法分析

词法分析阶段是编译过程的第一个阶段。

这个阶段的任务是从左到右一个字符一个字符地读入源程序，然后根据构词规则识别单词(也就是token)。比如把“我学习编程”这个句子拆解成“我”“学习”“编程”，这个过程叫做“分词”。

通常用现成工具Lex/Yacc/JavaCC/Antlr生成词法分析器（lexical analyzer、lexer 或者 scanner）。

antlr举例：

```javascript
lexer grammar Hello;  //lexer关键字意味着这是一个词法规则文件，名称是Hello，要与文件名相同
//关键字
If :               'if';
Int :              'int';
//字面量
IntLiteral:        [0-9]+;
StringLiteral:      '"' .*? '"' ;  //字符串字面量
//操作符
AssignmentOP:       '=' ;    
RelationalOP:       '>'|'>='|'<' |'<=' ;    
LeftParen:          '(';
RightParen:         ')';
//标识符
Id :                [a-zA-Z_] ([a-zA-Z_] | [0-9])*;
```



## 语法分析

在词法分析的基础上判断单词组合方式识别出**程序的语法结构**。这个结构是一个树状结构，这棵树叫做抽象语法树（Abstract Syntax Tree，AST）。树的每个节点（子树）是一个语法单元（也就是就是词法分析阶段生成的 Token），这个单元的构成规则就叫“语法”。



## 语义分析——标注AST的属性

语义分析是要让计算机理解我们的真实意图。**语义分析的结果保存在AST 节点的属性上**，比如在 标识符节点和 字面量节点上标识它的数据类型是 int 型的。在AST上还可以标记很多属性。





> 扩展：
>
> https://qiankunli.github.io/2020/02/08/fundamentals_of_compiling_frontend.html
>
> https://yearn.xyz/posts/techs/%E8%AF%8D%E6%B3%95%E8%AF%AD%E6%B3%95%E5%88%86%E6%9E%90%E5%9F%BA%E7%A1%80/#hello-world
