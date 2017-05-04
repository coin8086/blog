---
layout: post
title: 作为缓存的Redis实例的备份和恢复
tags: redis backup restore
excerpt: 听上去很简单，然而并不是——今天我要说的是为仅配置为缓存、没有persistence的Redis实例进行备份和恢复。为什么要对缓存进行备份和恢复？每个人的需求都不一样，其中一种是为了debug：你必须复原一个与production一模一样的环境——不仅是db，还有缓存，否则一些问题就没法重现。
---
听上去很简单，然而并不是——今天我要说的是为仅配置为缓存、没有persistence的Redis实例进行备份和恢复。为什么要对缓存进行备份和恢复？每个人的需求都不一样，其中一种是为了debug：你必须复原一个与production一模一样的环境——不仅是db，还有缓存，否则一些问题就没法重现。

为有persistence的Redis备份和恢复比较简单：只要复制persistence的rdb等文件到另一个Redis实例的工作目录下，然后重启那个Redis实例即可。但这么做对无persistence的Redis实例是行不通的——即便你有一个rdb文件。

这有一个可行的办法：首先对要备份的Redis实例生成rdb文件。你可以用SAVE／BGSAVE命令，或者更简单地：

```
redis-cli --rdb <filename>
```

然后恢复，重点来了：你可以用

```
redis-cli --pipe
```

从stdin恢复数据，但输入必须符合Redis protocol——不幸的是rdb文件并不符合，但你可以从它生成Redis protocol文件，用这个[redis-rdb-tools](https://github.com/sripathikrishnan/redis-rdb-tools)：

```
rdb --command protocol <rdbfile>
```

完整的命令行是：

```
rdb --command protocol <rdbfile> | redis-cli --pipe
```

如果你的Redis实例不在默认的6379端口，使用参数`-p xxxx`指明，如`redis-cli -p 6390 --pipe`。

