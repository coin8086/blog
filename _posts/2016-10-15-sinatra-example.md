---
layout: post
title:  Sinatra + ActiveRecord = Really Lean Startup?
date:   2016-10-15 10:18:26 +0800
tags:   ruby sinatra rails activerecord
excerpt: 为什么不是Rails？因为Rails太臃肿了！如果你有一个好创意，你应该从Sinatra轻快地开始。Sinatra十分轻盈——它只是在Rack的基础上添加了一些必要的辅助功能，如routes、views以及一些HTTP辅助方法，总共不到2500行代码（v1.4.7）——框架代码越少越好，这样你就容易掌控全局；相比之下，Rails仅ActiveRecord代码就超过35000行！
githuber-blog: true
---
## 为什么不是Rails？为什么是Sinatra + ActiveRecord？
Rails太臃肿了！如果你有一个好创意，你应该从Sinatra轻快地开始。Sinatra十分轻盈——它只是在Rack的基础上添加了一些必要的辅助功能，如routes、views以及一些HTTP辅助方法，总共不到2500行代码（v1.4.7）——框架代码越少越好，这样你就容易掌控全局；相比之下，Rails仅ActiveRecord代码就超过35000行！

言归正传，如果你使用Sinatra，首先应该解决如何操作数据库的问题。在这方面Rails的ActiveRecord是一个很好的选择（对SQL数据库来说）——Rails虽然臃肿，但核心的模块都是可以拿出来用的，而且很好用（除了ActiveRecord，ActiveSupport也是一个很实用的模块——我觉得Rails最大的可取之处就是它们俩了——此处欢迎评论）。

当然，我并不是要抛弃Rails，我只是认为它不大适合Lean Startup（精益启动／精益创业），而Sinatra + ActiveRecord的方式更合适一些——前者比较适合一些大而复杂的东西，后者小而美。你也不必担心：小而美的东西如果长“大”怎么办？——如果必要，你随时可以把项目迁移到Rails上去。这并不难，因为你的数据逻辑都建立在ActiveRecord上，同时Sinatra和Rails都是基于Rack的框架，如果你的views还是ERB（一般是这样），那么这种迁移其实并没有太多的工作要做。

## Sinatra + ActiveRecord，如何来做？
简单，这有个例子：<https://github.com/coin8086/sinatra-example>

只要稍加修改，你就可以把它作为你的Sinatra + ActiveRecord项目的起点来用。此外，这个例子还包含了Capistrano的部署脚本，也十分值得借鉴。
