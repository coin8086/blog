---
title: Little Bishops
date: 2013-05-25T18:46:56+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110801/861 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=36&#038;page=show_problem&#038;problem=802" target="_blank">题目描述</a>

分析：考虑两点：
  
第一，国际象棋棋盘的格子由黑白两色交替填充，黑色格子里的象吃不到白色格子里的象，反之亦然。
  
第二，把棋盘顺时针旋转４５度，象就变成了车！虽然棋盘也从正方形变成了菱形，但其边界不难确定。
  
由此形成解法：首先把棋盘拆为黑、白两部分，然后旋转棋盘，接着把ｋ个象分为两组，一组ｉ个，一组ｋ－ｉ个，分别放在黑、白棋盘里，各有mb(n, i)和mw(n, k &#8211; i)种放置方法，则总的方法数为<!--more-->


  
mb(n, i)*mw(n, k &#8211; i)
  
对上式求i = 0,&#8230;,k的和。mb/mw可以用类似八皇后的回溯法求解，只要注意棋盘边界。
  
另外：以下解法假设棋盘左上角(即：未旋转前的棋盘格子矩阵(0,0)的位置)着黑色。

```cpp
#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;utility&gt;

using namespace std;

typedef unsigned long long ull_t;
typedef vector&lt;pair&lt;int, int&gt; &gt; PVec;

class Black {
public:
  static int rows(int n) {
    return n;
  }

  static int cols(int n) {
    return n % 2 ? n : n - 1;
  }

  static void col_range(int n, int row, int & first, int & last) {
    int mid = cols(n) / 2;
    if (row &gt; mid)
      row = n - 1 - row;
    first = mid - row;
    last = mid + row;
  }

  //1, 1, 2, 3, 4, 5, 6, 7
  static int max(int n) {
    return n &gt; 1 ? n - 1 : 1;
  }
};

class White {
public:
  static int rows(int n) {
    return n - 1;
  }

  static int cols(int n) {
    return n % 2 ? n - 1 : n;
  }

  static void col_range(int n, int row, int & first, int & last) {
    int mid = cols(n) / 2;
    if (row &gt;= mid)
      row = n - 2 - row;
    first = mid - 1 - row;
    last = mid + row;
  }

  //0, 1, 2, 3, 4, 5, 6, 7
  static int max(int n) {
    return n &gt; 1 ? n - 1 : 0;
  }
};

inline bool avail(int col, const PVec & a) {
  for (int i = 0; i &lt; a.size(); i++) {
    if (a[i].second == col)
      return false;
  }
  return true;
}

template&lt;typename T&gt;
void backtrack(int n, int k, PVec & a, int & c) {
  if (a.size() == k) {
    c++;
  }
  //go on only when there are available rows to hold remaining bishops(one in each row)
  else if (k - a.size() &lt;= T::rows(n) - (a.empty() ? 0 : (a.back().first + 1))) {
    int i = a.empty() ? 0 : a.back().first + 1;
    for (; i &lt; T::rows(n); i++) {
      int first, last;
      T::col_range(n, i, first, last);
      for (int j = first; j &lt;= last; j++) {
        if (avail(j, a)) {
          a.push_back(make_pair(i, j));
          backtrack&lt;T&gt;(n, k, a, c);
          a.pop_back();
        }
      }
    }
  }
}

template&lt;typename T&gt;
inline int methods(int n, int k) {
  if (!k)
    return 1;
  int c = 0;
  PVec a;
  backtrack&lt;T&gt;(n, k, a, c);
  return c;
}

ull_t bishops(int n, int k) {
  ull_t c = 0;
  for (int i = 0; i &lt;= k; i++) {
    if (i &lt;= Black::max(n) && k - i &lt;= White::max(n)) {
      ull_t r = methods&lt;Black&gt;(n, i);
      r *= methods&lt;White&gt;(n, k - i);
      c += r;
    }
  }
  return c;
}

int main() {
  int n, k;
  while ((cin &gt;&gt; n &gt;&gt; k) && n) {
    cout &lt;&lt; bishops(n, k) &lt;&lt; endl;
  }
  return 0;
}
```

