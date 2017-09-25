---
layout: post
title: 七种武器——由一个算法的实现看编程语言的横向对比
excerpt: 学习一门语言的最佳方式是实践——但“Hello, World!”之类的实践太过简单，然而太复杂的实践（比如一个复杂的项目代码）又让人十分痛苦。本文提供了一个不那么简单、又不会让人过于痛苦的算法用于编程实践。同时，它还提供了若干种不同编程语言对这一算法的实现——通过比较这些实现，我们可以对这些编程语言有更好的理解。
---
目录
* 目录
{:toc}

学习一门语言的最佳方式是实践——但“Hello, World!”之类的实践太过简单，然而太复杂的实践（比如一个复杂的项目代码）又让人十分痛苦。本文提供了一个不那么简单、又不会让人过于痛苦的算法用于编程实践。同时，它还提供了若干种不同编程语言对这一算法的实现——通过比较这些实现，我们可以对这些编程语言有更好的理解。

本文选择的算法虽然简单，但很有代表性——它涉及的概念有：包、类、接口、继承、多态、范型等一般语言特性以及集合、迭代／枚举、IO等语言标准库／框架的重要概念，涵盖了大部分的编程基础知识。

另外，本文叫做“七种武器”，是想对比七种编程语言的实现[^seven_weapons]。但在我开始写作时，这些实现并未全部完成。我会陆续完成它们并更新本文。

## 算法
这个算法其实是一个字谜游戏，叫做[hangman](https://en.wikipedia.org/wiki/Hangman_(game))。游戏有两个人参与，一人出题，另一人猜。出题的人想好一个单词，比如apple，然后告诉对方单词有几个字母，比如`-----`（“-”表示一个未知字母）。猜题的人一次可以猜一个字母：如果单词含有这个字母，比如p，出题人就把这个字母在单词中的位置标示出来，比如`-pp--`，或者`a----`，否则就算猜错一次；猜题的人也可以直接猜测一个单词，这种情况下对方只反馈对错。经过若干次猜测，如果猜对了单词则成功结束，或者猜错了一定的次数而失败。单词从一个给定的集合中选出。我们的算法主要关注猜词的策略，也就是扮演猜谜的一方。

## 设计
基本上，我们的程序可分解为以下几个部分：

![类图](/images/hangman.png)

* HangmanGame类扮演出题者。它的guessLetter和guessWord方法分别对应着猜字母和猜单词，方法返回猜测的结果，如`--pp-`，或`-----`。
* Strategy接口扮演猜题者。它的nextGuess方法返回一个猜测（Guess）。
* Guess接口表示一次猜测。它可能是一个字母也能是一个单词。它的makeGuess方法实际执行这个猜测。

基本的流程是：

```
while (game is not over) {
  Guess guess = strategy.nextGuess(game);
  guess.makeGuess(game);
}
```

程序的关键在Strategy接口的实现，MyStrategy上。如何得到一个最优的策略需要仔细思考。一个基本的想法是根据字母概率来猜测。简单的说，如果已知当前猜测的结果是`--pp-`，那么就把所有符合这一形式的单词的集合（记为W）找出来，然后统计其中除“p”以外字母出现的概率，下一次就猜这个概率最大的字母。这个方法还可以优化：如果已知当前猜测结果是`--pp-`，已经猜过的字母的集合是{x, y, p}，那么还应该把集合W中含有字母x或y的单词都排除掉（更多的优化可参考后面的具体实现）。

上述集合W将被实现为一个可枚举的集合（Enumerable Collection）——不同编程语言对这种集合的支持也是我们关注的一个焦点。

## 实现

以下是一些不同编程语言的实现。在开始比较这些语言之前你最好先浏览一下它们的代码（要是能编译、运行它们就更好了），我们的比较和示例代码都基于这些实现，在一定程度上也可以说是这些实现的对比注释。

* Java: [hangman.java](https://github.com/coin8086/hangman.java)
* C#: [hangman.cs](https://github.com/coin8086/hangman.cs)

## 对比

* [C# VS Java ]({% post_url seven-weapons/2017-09-25-cs-vs-java %})
* ……

[^seven_weapons]: 当然，如果读者想到了古龙的《七种武器》那也不奇怪：作者早年曾不自量力地写过一篇同名文章、做过类似的事情（以武侠小说为名头比较一些编程语言），现在看起来未免幼稚、粗糙了一些，而且那篇文章和相关的代码也年久失修。现在作者决定仍然用从前的名称，但重写全部内容，并且大幅更新算法实现以反映最新的语言发展以及这些语言本身的最佳编程习惯。
