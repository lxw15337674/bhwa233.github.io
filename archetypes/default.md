---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
uri: {{ path.Join "/posts" .Name }}
tags: [""]
categories: [""]
typora-root-url: ..\..\static
---

