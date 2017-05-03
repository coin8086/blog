---
title: Primary Arithmetic
date: 2013-06-14T12:37:23+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110501/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=976" target="_blank">10035</a>

<!--more-->

```cpp
#include &lt;iostream&gt;
#include &lt;vector&gt;

#define MAX_SIZE 10

using namespace std;

inline vector&lt;char&gt; to_vec(int n) {
  vector&lt;char&gt; v;
  v.reserve(MAX_SIZE);
  while (n) {
    v.push_back(n % 10);
    n /= 10;
  }
  return v;
}

int carry_times(int n, int m) {
  if (!n || !m)
    return 0;
  vector&lt;char&gt; bn = to_vec(n);
  vector&lt;char&gt; bm = to_vec(m);
  int carry = 0;
  int times = 0;
  int size = n &gt;= m ? bn.size() : bm.size();
  bn.resize(size);
  bm.resize(size);
  for (int i = 0; i &lt; size; i++) {
    int s = carry + bn[i] + bm[i];
    if (s &gt; 9) {
      carry = 1;
      times++;
    }
    else {
      carry = 0;
    }
  }
  return times;
}

int main() {
  int n, m;
  while ((cin &gt;&gt; n &gt;&gt; m) && (n || m)) {
    int t = carry_times(n, m);
    if (!t)
      cout &lt;&lt; "No carry operation.";
    else if (t == 1)
      cout &lt;&lt; "1 carry operation.";
    else
      cout &lt;&lt; t &lt;&lt; " carry operations.";
    cout &lt;&lt; endl;
  }
  return 0;
}
```

