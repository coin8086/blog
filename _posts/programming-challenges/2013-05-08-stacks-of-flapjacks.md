---
title: Stacks of Flapjacks
date: 2013-05-08T19:47:04+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110402/120 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=56" target="_blank">题目描述</a>

分析：把一堆煎饼按自底向上的顺序插入到数组中（这样饼号就等于元素下标号加一），然后从数组第一个元素开始向后遍历，每次把最大的煎饼放在遍历的当前位置。<!--more-->

```cpp
#include &lt;iostream&gt;
#include &lt;sstream&gt;
#include &lt;vector&gt;
#include &lt;string&gt;
#include &lt;algorithm&gt;

using namespace std;

vector&lt;int&gt; flip(vector&lt;int&gt; & flaps) {
  vector&lt;int&gt; flips;
  vector&lt;int&gt;::iterator begin = flaps.begin();
  vector&lt;int&gt;::iterator end = flaps.end();
  for (int i = 0; i &lt; flaps.size(); i++) {
    vector&lt;int&gt;::iterator icurrent = begin + i;
    vector&lt;int&gt;::iterator imax = max_element(icurrent, end);
    if (imax != icurrent) {
      if (imax + 1 != end) {
        flips.push_back(imax - begin + 1);
        reverse(imax, end);
      }
      flips.push_back(i + 1);
      reverse(icurrent, end);
    }
  }
  flips.push_back(0);
  return flips;
}

int main() {
  string line;
  while (getline(cin, line)) {
    istringstream is(line);
    vector&lt;int&gt; flaps;
    int d;
    while (is &gt;&gt; d) {
      flaps.push_back(d);
    }
    reverse(flaps.begin(), flaps.end());
    vector&lt;int&gt; flips = flip(flaps);
    cout &lt;&lt; line &lt;&lt; endl;
    for (int i = 0; i &lt; flips.size(); i++) {
      if (i != 0)
        cout &lt;&lt; ' ';
      cout &lt;&lt; flips[i];
    }
    cout &lt;&lt; endl;
  }
}
```

