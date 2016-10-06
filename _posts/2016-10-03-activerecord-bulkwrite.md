---
layout: post
title:  "ActiveRecord批量写入（Bulk Write）的问题与解决"
date:   2016-10-03 20:54:24 +0800
tags: ruby postgresql
---
# 批量写入（bulk write）的问题

Ruby ActiveRecord向数据库的批量写入效率很低：要插入一条记录，你只能先用model的`create`方法构造一个对象，然后保存到数据库；如果你有一批数据要插入，你就要循环调用`create`方法——这一过程可能缓慢到令人难以忍受！

我曾经把一张含有上百万条记录的表由一个数据库转移到另一个数据库：使用上面的循环插入法，在PCIE的SSD硬盘上花了一个小时左右只完成了大约三分之一。于是我中断了进程，转而寻求更快的办法。

一种改善方法是把循环插入包裹在一个transaction之内，避免每次插入都新建一个transaction——这会改善一些性能，但不是太多（大致在10%以内）。

最有效率的方法是：直接构造SQL进行插入，像这样：

```sql
INSERT INTO table_name (col1, col2, col3, ...) VALUES (v11, v12, v13, ...), (v21, v22, v23, ...), ...
```

它使我在十分钟之内完成了工作：其效率大致是循环插入法的十几倍。

[这篇文章](https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/) 也分析了ActiveRecord的批量插入效率问题，并且通过测试数据比较了不同解决方案—— `create`循环插入、在一个transaction内的循环插入以及直接构造SQL——的性能差异，结论相同。感兴趣的读者可以一读。

然而问题并没有结束——在直接构造SQL时你需要特别小心：

* 你需要处理数据类型转换——把普通Ruby对象或者用户输入的字符串转换为数据库接受的类型，比如把`nil`转换成NULL，把Time对象转换为数据库接受的字符串格式——别忘了Time Zone（ActiveRecord Timestamp其实对应着数据库的datetime without timezone类型，但ActiveRecord保存的是UTC time）和时间精度（ActiveRecord Timestamp 保留秒的六位小数），等等。
* 字符串转义，处理`'`和`\`字符

# activerecord-bulkwrite来解决
```
gem install activerecord-bulkwrite
```

## 批量Insert

安装它之后，我们就可以这样进行批量插入：
```ruby
require "activerecord/bulkwrite"

fields = %w(id name hireable created_at)
rows = [
  [1, "Bob's", true, Time.now.utc],
  [2, nil, "false", Time.now.utc.iso8601],
  # ...
]

# The result is the effected(inserted) rows.
result = User.bulk_write(fields, rows)
```

activerecord-bulkwrite会为我们构造SQL，并处理上面提到的问题。更酷的是，它还支持 *upsert*：即先尝试insert，如有冲突（如primary key violation或unique violation）则转为update。

## 批量Upsert
```ruby
result = User.bulk_write(fields, rows, :conflict => [:id])
```

上面这条语句把rows重新插入了一遍，这时id（假设它是primary key）就会发生冲突，插入失败，转而为update。缺省update除conflict以外的所有列，在上面的例子中即name、hireable和created_at。我们可以明确指明要update的列，如：

```ruby
result = User.bulk_write(fields, rows, :conflict => [:id],  :update => %w(name created_at))
```

我们还可以给出一个条件，仅当条件满足时才执行update：
```ruby
result = User.bulk_write(fields, rows, :conflict => [:id],  :where => "users.hireable = TRUE"))
```

实际上，activerecord-bulkwrite的upsert利用了[PostgreSQL 9.5的upsert](https://www.postgresql.org/docs/9.5/static/sql-insert.html#SQL-ON-CONFLICT)：

```sql
INSERT INTO table_name (col1, col2, col3, ...) VALUES (v11, v12, v13), (v21, v22, v23), ...
ON CONFLICT (colX, colY, ...) DO UPDATE
SET colA = ..., colB = ..., ...
WHERE ...
```

因此，它只支持PostgreSQL数据库。当然，如果你只要insert，它的代码经过少许修改就可以复用到其它数据库上。
