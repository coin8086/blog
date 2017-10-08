---
layout: post
title: 七种武器——C++11 VS Java与C#
excerpt: Java的初衷是要做一个更好的C++，C#也也一样。但是它们究竟做到了没有呢？或者说C++身上有哪些值得学习／改进的地方呢？如果说在一开始Java和C#都从C++身上学到了很多东西，那么后来这三门语言其实是相互学习借鉴的。这反映在C++11引入的很多新功能上。本文结合实际代码对比了C++／C++11与Java和C#的一些常见／主要特性，希望能通过比较，对掌握这三门语言的特点有所帮助。
---
_这篇文章是“七种武器”系列的一篇，在这篇[导言]({% post_url seven-weapons/2017-09-22-seven-weapons %})中有相关的介绍和代码，读者应该先读一读它。_

目录
* 目录
{:toc}

Java的初衷是要做一个更好的C++，C#也也一样。但是它们究竟做到了没有呢？或者说C++身上有哪些值得学习／改进的地方呢？如果说在一开始Java和C#都从C++身上学到了很多东西，那么后来这三门语言其实是相互学习借鉴的。这反映在C++11引入的很多新功能上。本文结合实际代码对比了C++／C++11与Java和C#的一些常见／主要特性，希望能通过比较，对掌握这三门语言的特点有所帮助。

我假定读者具有一定C++／C#／Java基础——最起码能够编译、执行一个Hello程序。对于那些已经比较熟悉C++、只想了解C++11的读者，你可以挑选那些感兴趣的章节来看，也可以直接查看代码[hangman.cpp](https://github.com/coin8086/hangman.cpp)，按照README的说明搜索所有标记了C++11特性的代码。

## 编译、链接 VS 虚拟机、字节码

一个C++源程序经过编译、链接成为可在物理机上执行的（二进制，binary）程序，而C#和Java源程序经过编译成为可以在它们的虚拟机上运行的（字节码，bytecode）程序。其实不论物理机还是虚拟机，都是一种“操作平台”，平台上运行的程序都使用平台的指令（物理机的汇编指令、虚拟机的字节码指令）来完成程序的功能。不过两者的不同之处在于：

* 物理机的指令集是由CPU定义的，不同的CPU的指令集可能互不兼容，因此为一种CPU编译的程序可能不能运行在另一种上；另外，即使CPU相同，不同的操作系统对于可执行文件有着不同的“格式”要求（如Windows的PE和Linux的ELF），因此为一种“CPU+操作系统”编译的C++程序可能并不能在另一种“CPU+操作系统”上执行。
* 虚拟机的指令集可以实现统一，也就是说，不论虚拟机之下的“CPU+操作系统”如何，虚拟机本身的指令集可以保持不变，所以为虚拟机编译的程序可以实现所谓的“编译一次、到处运行”（比如，在Linux上编译好的Java程序也可以在Windows上运行）[^run_anywhere]。

这就是C++与C#和Java的最大不同。

## 内存管理

C++与C#和Java的另一个显著不同在于对内存的管理。

C++允许用户通过指针自由操作内存，包括申请（`new`）、释放（`delete`）内存以及读写内存的任意地址[^memory_rw]。Java没有指针也不支持这样的操作，用户只能通过创建对象间接地申请内存，用户也不能自由读写任意内存地址；C#则通过`unsafe`代码对指针提供有限支持，但这主要是为了使C#能与C API互操作，一般情况下并不需要这么做。

自由是一把双刃剑：一方面你可以干任何你想干的事，另一方面它可能会伤到自己。比如，内存泄露——申请了的内存在使用完毕后没有释放，如果积累下去最终会耗尽可用内存而导致程序崩溃。在这方面，Java和C#都使用了更严格的内存管理方法，并且自动回收用户使用完毕的内存，即垃圾回收（Garbage Collection)。在Java和C#里，你并不需要像C++那样`delete`一个`new`创建的对象——它会被虚拟机自动回收，当对象的生命周期结束之后。这是一个很棒的功能。

## 名字空间（Namespace）

同Java和C#一样，C++也有名字空间的概念和方法。

C++通过`namespace`来定义名字空间，如：

```c++
namespace std {
  //...
}
```

C++通过`using`来导入一个名字空间或其中的一个类型，比如：

```c++
using namespace std;
```

或

```c++
using std::string;
```

在这方面，C#与C++很相似，Java则不同，参考[C# Namespace VS Java Package]({% post_url seven-weapons/2017-09-25-cs-vs-java %})。

另外，C++11增强了`using`的功能，现在它可以取代`typedef`，如

```c++
//等价于
//typedef std::vector<int> IntVec;
using IntVec = std::vector<int>;
```

此外，它还可以带有模版参数，如

```c++
template<class T>
using StringMap = std::map<std::string, T>;

//...

StringMap<int> map;
```

## 类、接口与虚函数／虚方法

### 类

在类的定义方面，C++、C#和Java大同小异，其中C#的类定义还支持属性和索引（如`obj.Property`和`obj[index]`，参考C#[类定义]({% post_url seven-weapons/2017-09-25-cs-vs-java %})）。但从功能上说，它们都是完备的，因为属性和索引都可以用方法代替。

|语言  |支持属性          |支持索引               |支持操作符重载
|:-----|:-----------------|:----------------------|:-------------
|C++   |无                |有，通过重载操作符`[]` |有，全部操作符
|C#    |有                |有                     |有，部分操作符
|Java  |无                |无                     |无

### 接口

在接口定义方面，C++用一个纯虚类来定义接口，如

```c++
class Guess {
public:
  virtual void makeGuess(HangmanGame & game) = 0;
};
```

C#和Java则有专门的`interface`来定义，如

```java
//Java或C#
public interface Guess {
  void makeGuess(HangmanGame game);
}
```

另外，C#还提供了一种称为[显式接口实现（Explicit Interface Implementation）]({% post_url seven-weapons/2017-09-25-cs-vs-java %})的机制来解决来自两个不同接口的方法签名冲突的问题。对于C++和Java来说，这个问题应当尽量避免。

### 虚函数／虚方法

虚函数，或称虚方法，是为了支持类的多态（Polymorphism）而产生的概念。在C++中，由`virtual`修饰的函数被称为一个虚函数，就像上面的`makeGuess`方法（实际上`= 0`意味着它是一个纯虚函数，即没有提供实现的虚函数）。C#也有类似的概念和语法，如：

```c#
class A {
  public virtual int Foo() {
    return 1;
  }
}

class B : A {
  public override int Foo() {
    return 2;
  }
}
```

注意C#代码中的`override`修饰符：如果没有它，B::Foo实际上hide了A::Foo，而没有发生多态，编译器会对此给出警告。这一点与C++不同，对于C++代码：

```c++
class A {
public:
  virtual int Foo() {
    return 1;
  }
}

class B : public A {
public:
  int Foo() {
    return 2;
  }
}
```

只要派生类B中的Foo方法与基类A的虚方法Foo的签名相同，派生类就自动override基类方法。

但这里其实有一个隐患：如果派生类的作者拼写错了虚方法的名字，或者是搞错了方法的参数类型，又或者开始没有错，但后来基类的作者修改了虚方法的签名而忘记修改某个派生类，编译器不会发出任何警告。C++11使用`override`来解决这个问题：

```c++
class B : public A {
public:
  int Foo() override {
    return 2;
  }
}
```

如果派生类的方法Foo实际上没有override任何基类的虚方法，编译器就会产生一个错误。但如果你不添加`override`修饰符，编译器则不进行任何检查。

对于Java来说，方法不需要`virtual`修饰，全部都是虚的；同时，Java提供`@Override`注解来检查方法是否override了某个基类方法，如

```java
@Override
public String toString() {
  return "GuessLetter[" + guess + "]";
}
```

同样地，如果不添加该注解则编译器不会检查。在这一点上，C#编译器最为严谨。

## 枚举类型（Enum Type）

以前，C++这样定义和使用枚举类型：

```c++
enum Status { GAME_WON, GAME_LOST, KEEP_GUESSING };

Status gameStatus() const {
  if (_secretWord == _guessedSoFar) {
    return GAME_WON;
  }
  else if (numWrongGuessesMade() > _maxWrongGuesses) {
    return GAME_LOST;
  }
  else {
    return KEEP_GUESSING;
  }
}
```

枚举值`GAME_WON`, `GAME_LOST`, `KEEP_GUESSING`在使用时不可置于`Status`的scope之下，也就是说`Status::GAME_WON`或者`Status.GAME_WON`都是不合法的表达方式，因为实际上它们都定义在与`Status`相同的scope下。这是一种反直觉的语法，同时也污染了名字空间。C++11使用`enum class`来纠正这一问题：

```c++
enum class Status { GAME_WON, GAME_LOST, KEEP_GUESSING };

Status gameStatus() const {
  if (_secretWord == _guessedSoFar) {
    return Status::GAME_WON;
  }
  else if (numWrongGuessesMade() > _maxWrongGuesses) {
    return Status::GAME_LOST;
  }
  else {
    return Status::KEEP_GUESSING;
  }
}
```

C#和Java的枚举类型都是scoped，例如

```java
//Java或C#
public enum Status { GAME_WON, GAME_LOST, KEEP_GUESSING }

public Status gameStatus() {
  if (secretWord.equals(getGuessedSoFar())) {
    return Status.GAME_WON;
  }
  else if (numWrongGuessesMade() > maxWrongGuesses) {
    return Status.GAME_LOST;
  }
  else {
    return Status.KEEP_GUESSING;
  }
}
```

另外，与以前的`enum`不同，`enum class`类型与整型之间没有隐式转换（implicit conversion），因此如下代码是不能通过编译的

```c++
enum class Status { GAME_WON, GAME_LOST, KEEP_GUESSING };
//...
cout << gameStatus();
```

必须做强制转换：

```c++
enum class Status { GAME_WON, GAME_LOST, KEEP_GUESSING };
//...
cout << (int)gameStatus();
```

此外，C++的`enum class`枚举值仍然不能像Java或C#那样输出字符串：

```java
//Java
System.out.println(Status.GAME_WON);
//输出：
//GAME_WON
```

## 智能指针（Smart Pointer）

对C++来说，用户必须负责释放对象，在对象的生命周期结束以后，比如：

```c++
GuessWord * p = new GuessWord(word);
//...
delete p; //释放对象
```

C#和Java没有这种操作，因为它们的对象都会被虚拟机自动进行垃圾回收。

如果用户忘记释放对象就会产生内存泄露——无用的对象占用了内存，这种浪费累积起来会让程序耗尽内存而崩溃。为此C++11提供了一组智能指针来辅助这个问题。它们是：`unique_ptr`、`shared_ptr`和`weak_ptr`，分别用于管理“独占指针”、“共享指针”和“弱（引用）指针”。

其实我们自己也可以实现这些“智能指针”，无非是构造一个指针类、重载它的`*`、`->`等运算符，对于共享的指针还需要使用“引用计数”来管理，一旦计数归零就释放被管理的对象，对于“弱引用”指针，实际上就是不改变“引用计数”的共享指针。

`unique_ptr`用于管理“独占”的资源，当`unique_ptr`的生命周期结束后自动释放被管理的资源。它的一个例子是：

```cpp
class MyGuessingStrategy : public GuessingStrategy {
  //...
private:
  unique_ptr<WordSet> _wordset;
}
```

这里MyGuessingStrategy对象和WordSet对象是一对一的关系，因此用`unique_ptr`来管理是合适的。当MyGuessingStrategy对象被释放时它对应的WordSet对象通过`unique_ptr`也被释放。我们这样赋给它一个普通指针：

```cpp
_wordset.reset(new WordSet(...));
```

`reset`方法同时释放`unique_ptr`中已存在的对象，如果有的话。

`shared_ptr`使用“引用计数”管理可共享的对象，如：

```cpp
class MyGuessingStrategy : public GuessingStrategy {
  //...
public:
  shared_ptr<Guess> nextGuess(const HangmanGame & game) override;
}
//...
while(game.gameStatus() == HangmanGame::Status::KEEP_GUESSING) {
  shared_ptr<Guess> guess = strategy.nextGuess(game);
  //赋值之后guess内含的Guess对象的引用计数为1
  guess->makeGuess(game);
  //guess生命周期结束，内含的Guess对象的引用计数减1；同时，引用计数归零导致Guess对象被释放
}
```

其实，Java和C#的对象的自动垃圾回收也依赖类似的引用计数，只不过无用的对象可能不是立即被释放的，而是被标记起来，等一个合适的时机再释放。

## 空指针（Null Pointer）

对于Java和C#而言，判断一个对象引用是否为空可以这样：

```java
//Java或C#
if (obj == null) {
  //...
}
```

对于C++我们以前这样：

```c++
if (obj == NULL) {
  //...
}
```

现在C++11新增了一个关键字`nullptr`用来取代`NULL`。所以我们以后应该这样：

```c++
if (obj == nullptr) {
  //...
}
```

这是因为：

首先，`NULL`的定义是不确定／无标准的，它可能是

```cpp
#define NULL 0
```

也可能是

```cpp
#define NULL ((void *)0)
```

其次，虽然值都是0，但是整型数值0和指针值0的含义在某些情况下是大有区别的，比如对重载的函数调用：

```cpp
void foo(int) {...}
void foo(int *) {...}

foo(NULL); //究竟会调用哪个foo呢？这要看NULL究竟是整型还是指针
```

或者对于编译器推断模版参数：

```cpp
template <class T>
void foo(T t) {...}

foo(NULL); //T究竟是整型还是指针？
```

现在`nullptr`明确地表示一个空指针就不再有这些问题。

## 容器与迭代（Containers and Iteration）

C++的容器是一种集合类型。常见的C++容器与C#和Java的对应类型如下：

|语言  |列表(数组) |映射(平衡二叉树) |集合(平衡二叉树) |映射(哈希)    |集合(哈希)
|:-----|:----------|:----------------|:----------------|:-------------|:-----------
|C++   |vector     |map              |set              |unordered_map |unordered_set
|C#    |List       |SortedDictionary |SortedSet        |Dictionary    |Set
|Java  |ArrayList  |TreeMap          |TreeSet          |HashMap       |HashSet


其中`unordered_map`和`unordered_set`都是C++11新增的标准容器。

C++容器与Java和C#集合类型的不同之处是：

* C++的容器并没有一个公共的基类或者接口，像Java的`Collection`或者C#的`ICollection`，只有一些公共的行为，比如“迭代方式”。
* C++的的容器靠“迭代器”进行迭代。迭代器的功能类似于Java的`Iterator`或C#的`IEnumerator`，但又不太一样。

简单地说，一个迭代器使用起来就像这样：

```cpp
bool insert(const string & word);

template<class InputIterator>
void insert(InputIterator first, InputIterator last) {
  while (first != last) {
    insert(*first);
    ++first;
  }
}
```

上面的`InputIterator`就是一个迭代器类型，它至少要支持`!=`、`*`和`++`这三种操作。它可以是一个指针，也可以是一个类。

与以上代码对应的Java和C#代码可能是：

```java
//Java
void insert(Collection<String> coll) {
  Iterator<String> it = coll.iterator();
  while (it.hasNext()) {
    insert(it.next());
  }
}
```

```c#
//C#
void insert(ICollection<string> coll) {
  IEnumerator<string> it = coll.GetEnumerator();
  while (it.MoveNext()) {
    insert(it.Current);
  }
}
```

或者简单地：

```java
//Java
void insert(Collection<String> coll) {
  for (String word : coll) {
    insert(word);
  }
}
```

```c#
//C#
void insert(ICollection<string> coll) {
  foreach(string word in coll) {
    insert(word);
  }
}
```

C++11也引入了一个类似的增强的`for`循环，如：

```cpp
template<class T>
void insert(const T & coll) {
  for (const string & word : coll) {
    insert(word);
  }
}
```

其中，coll可以是一个有`begin()`和`end()`方法的对象，就像C++标准容器，如`vector`或`map`那样。

[^run_anywhere]: 实际上情况还要复杂一些，因为虚拟机环境可能并不能够保证在所有的操作系统上都提供一致的“平台服务”，比如某个依赖操作系统的方法调用可能在不同的操作系统上有不一致的行为。因此有人称之为“一次编译，四处调试”。
[^memory_rw]: 当然，如果胡乱写内存程序就会崩溃，但是C++并不限制用户“自杀”的权利；另外，如果读／写了一些被系统禁止的内存地址则会触发运行时异常，程序可能会被终止。
