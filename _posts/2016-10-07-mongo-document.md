---
layout: post
title:  在Ruby Rack应用中直接使用MongoDB Ruby Driver
date:   2016-10-07 13:07:32 +0800
tags:   ruby mongodb mongoid mongo rack rails
---

在Ruby程序中使用MongoDB你有两种主要的选择：Mongoid或者是MongoDB官方的Ruby Driver。有这么一种常见的说法：Mongoid一般用于Rack应用程序，如Rails，而MongoDB Ruby Driver则用在Rack应用以外的领域。这主要是因为Mongoid作为ActiveRecord在NoSQL数据库上的替代品具有同ActiveRecord相似的API风格，对于熟悉后者的用户来说容易上手。然而，在Rack应用程序中直接使用MongoDB Ruby Driver也并没有什么问题，与Mongoid相比还有一些优点：

* 简单——用一套API实现所有功能。相比之下，Mongoid并未实现MongoDB的所有功能：当你需要做aggregation查询时，你不得不直接操作其底层Driver API来完成。也就是说，Mongoid的用户与MongoDB打交道实际上需要两套API：高级的ODM和低级的驱动。
* API一致性——除了Ruby，你很可能还要用到其他语言实现的MongoDB Driver，如JavaScript——Mongo Shell的操作语言。这些官方实现的不同语言的API都有相似的风格，熟悉了其中一种就比较容易掌握另一种。

但是，直接在Rack里使用MongoDB Ruby Driver毕竟有一些不够方便的地方。下文将通过比较二者的典型用法来说明问题，并给出解决方案。

我们先来看一个Mongoid的例子：

```ruby
require 'mongoid'

class User
  include Mongoid::Document
  # ...
end

User.create(...)  # Insert one document
User.where(...)   # Find documents
```

与ActiveRecord类似，首先你要定义一个model类，如`User`，其后的CRUD就跟ActiveRecord差不多。

Mongoid会自动连接数据库，根据用户定义的配置文件（缺省位于your-app/config/mongoid.yml），如：

```yaml
test:
  clients:
    default:
      database: testdb
      hosts:
        - localhost:27017
```

如果用MongoDB Ruby Driver，你得这么做：

```ruby
require 'mongo'

# Firstly, make a connection to a database
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'testdb')

# Secondly, get an object of Mongo::Collection
collection = client[:users]

# Then do whatever you want with the collection
collection.insert_one(...)  # Insert one document
collection.find(...)        # Find documents
# ...
```

首先你需要建立一个连接——得到一个`client`对象，然后从它得到一个`collection`对象，然后才能开始在其中插入或者查找文档。

与Mongoid相比，这显得不那么方便：Mongoid可以让你直接从collection对象——`User`类——开始工作，也不需要你手工建立数据库连接；此外，有了model类定义，如`User`，就可以把相关的操作数据库的方法都定义在这个类中，像ActiveRecord那样，如：

```ruby
class User
  include Mongoid::Document
  # ...

  def change_password(old_pw, new_pw)
  end
end
```

其时，解决这些问题一点也不难，只要给MongoDB Ruby Driver增加几个功能：

* model类定义，像上面Mongoid的`class User; ... end`，并且用户可以直接把它当作collection对象来用
* 根据用户定义的配置文件自动连接数据库

mongo-document这个Gem正是为此目的：<https://github.com/coin8086/mongo-document>

它的用法如下：

安装
```
gem install mongo-document
```

用例

```ruby
require "mongo"
require "mongo/document"

class User
  include Mongo::Document
  # ...
end

# Here User can be used as if a collection object
User.insert_one(...)  # Insert one document
User.find(...)        # Find documents
```

这个`User`类含有`Mongo::Collection`类型的对象的全部方法，包括`insert_one`和`find`等等——实际上，`User`的内部实现含有一个collection对象（可以通过`User.collection`得到）；User自身只有很少的几个方法，它把此外的方法调用都转发到它的collection对象上。

mongo-document会自动读取用户配置文件（缺省位于your-app/config/database.yml），如：

```yaml
test:
  hosts:
    - localhost:27017
  database: testdb
```

Mongo::Client::new方法的所有[options](https://docs.mongodb.com/ruby-driver/v2.2/tutorials/ruby-driver-create-client/#ruby-driver-client-options)都可以在这个配置文件中指定。

mongo-document自身不到100行代码，十分轻巧，是MongoDB Ruby Driver在Rack应用中的好帮手。
