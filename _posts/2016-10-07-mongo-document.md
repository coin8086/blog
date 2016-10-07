---
layout: post
title:  Mongoid VS MongoDB Ruby Driver，以及mongo-document
date:   2016-10-07 13:07:32 +0800
tags:   ruby mongodb mongoid
---
## Mongoid VS MongoDB Ruby Driver

在Ruby程序中使用MongoDB你有两种选择：使用一种ODM（Object-Document-Mapper）库，如Mongoid，或者是MongoDB官方的Ruby Driver。

### Mongoid

Mongoid的API风格与ActiveRecord类似，对于熟悉后者的用户来说比较容易上手。它的早期版本（3.0）使用一个名为Moped的Ruby库与MongoDB通讯。从5.0开始，Moped已替换为MongoDB官方的Ruby Driver，而且Mongoid也被MongoDB官方支持。

以Mongoid 6.0为例，一段示例代码如下：

```ruby
require 'mongoid'

class User
  include Mongoid::Document
  # ...
end

User.create(...)  # Insert one document
User.where(...)   # Find documents
```

与ActiveRecord类似，Mongoid会自动连接数据库，根据用户定义的配置文件（缺省位于your-app/config/mongoid.yml），如：

```yaml
test:
  clients:
    default:
      database: testdb
      hosts:
        - localhost:27017
```

### MongoDB Ruby Driver

与Mongoid相比，MongoDB官方的Ruby Driver简单、功能全面——后者尤为重要，要知道在早些年，Mongoid等ODM库的功能还不完善，用户有时不得不求助于这些ODM底层的Ruby驱动（如Moped）来完成一些任务。因此对这些用户而言与MongoDB打交道实际上需要两套API：高级的ODM和低级的驱动——令人头疼。因此一些有经验的用户选择了简单但功能全面的MongoDB官方Ruby Driver。

此外，用户选择官方Ruby Driver还有一个原因：API一致性——要知道除了Ruby，你很可能还要用到其他语言实现的MongoDB Driver，如JavaScript——Mongo Shell的操作语言。这些官方实现的不同语言的API都有相似的风格和方法名称，因此熟悉了其中一种语言的API就比较容易掌握另一种。

使用Ruby Driver实现上面Mongoid的代码的功能如下：

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

跟Mongoid相比，它显得不那么“方便”：你需要手工建立一个连接——得到一个client对象，然后从它得到一个collection对象，然后才能开始在其中插入或者查找文档；相比之下，Mongoid可以让你直接从collection对象——即User类——开始工作。另外，有了一个User类，就可以把User相关的方法也定义在这个类中，就像ActiveRecord那样，但它也没有。

于是我想，如果给MongoDB Ruby Driver加上这些功能好不好？具体地说：

* 增加一个model类定义，像上面的`class User; ... end`，以免每次都要先建立一个client对象，然后从中得到一个collection对象，然后才能开始实际的插入、查找等工作
* 根据用户定义的配置文件自动连接数据库

同时还要：

* *对数据库的各种操作仍然直接通过MongoDB Ruby Driver进行，不影响效率，用户也不用学习一套新的API*
* 轻巧的实现，很少的代码，易于理解和维护

这样就有了`mongo-document`

## mongo-document

```
gem install mongo-document
```

GitHub: <https://github.com/coin8086/mongo-document>

使用方法：

```ruby
require "mongo/document"

class User
  include Mongo::Document
  # ...
end

# Here User is used as if a collection object
User.insert_one(...)  # Insert one document
User.find(...)        # Find documents
```

这个User类含有Mongo::Collection类型的对象的全部方法，包括`insert_one`和`find`等等——实际上，User的内部实现含有一个collection对象（可以通过`User.collection`得到）；User自身只有很少的几个方法，它把此外的方法调用都转发到它的collection对象上。

mongo-document也会自动读取用户配置文件（缺省位于your-app/config/database.yml），如：

```yaml
test:
  hosts:
    - localhost:27017
  database: testdb
```

Mongo::Client::new方法的所有[options](https://docs.mongodb.com/ruby-driver/v2.2/tutorials/ruby-driver-create-client/#ruby-driver-client-options)都可以在这个配置文件中指定。

`mongo` + `mongo-document`，是不是很方便？
