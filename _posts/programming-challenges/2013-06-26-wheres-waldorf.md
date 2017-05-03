---
title: Where’s Waldorf?
date: 2013-06-26T12:33:46+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110302/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=951" target="_blank">10010</a>

分析：按从上到下、从左到右的顺序对矩阵中每一个字符向八个方向查找是否存在一个以它开头的单词。<!--more-->

```cpp
#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;utility&gt;
#include &lt;string&gt;
#include &lt;cctype&gt;

using namespace std;

inline void to_lower(vector&lt;string&gt; & lines) {
  for (int i = 0; i &lt; lines.size(); i++) {
    string & s = lines[i];
    for (int j = 0; j &lt; s.size(); j++) {
      s[j] = tolower(s[j]);
    }
  }
}

inline bool find(const vector&lt;string&gt; & matrix, int m, int n, int i, int j,
  const string & word)
{
  int l = word.size();
  //find right
  int l_right = n - j;
  if (l &lt;= l_right) {
    int k = j + 1, d = 1;
    for (; d &lt; l; k++, d++) {
      if (matrix[i][k] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left
  int l_left = j + 1;
  if (l &lt;= l_left) {
    int k = j - 1, d = 1;
    for (; d &lt; l; k--, d++) {
      if (matrix[i][k] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find down
  int l_down = m - i;
  if (l &lt;= l_down) {
    int k = i + 1, d = 1;
    for (; d &lt; l; k++, d++) {
      if (matrix[k][j] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find up
  int l_up = i + 1;
  if (l &lt;= l_up) {
    int k = i - 1, d = 1;
    for (; d &lt; l; k--, d++) {
      if (matrix[k][j] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find right down
  int l_right_down = l_right &lt;= l_down ? l_right : l_down;
  if (l &lt;= l_right_down) {
    int k = i + 1, h = j + 1, d = 1;
    for (; d &lt; l; k++, h++, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find right up
  int l_right_up = l_right &lt;= l_up ? l_right : l_up;
  if (l &lt;= l_right_up) {
    int k = i - 1, h = j + 1, d = 1;
    for (; d &lt; l; k--, h++, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left down
  int l_left_down = l_left &lt;= l_down ? l_left : l_down;
  if (l &lt;= l_left_down) {
    int k = i + 1, h = j - 1, d = 1;
    for (; d &lt; l; k++, h--, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  //find left up
  int l_left_up = l_left &lt;= l_up ? l_left : l_up;
  if (l &lt;= l_left_up) {
    int k = i - 1, h = j - 1, d = 1;
    for (; d &lt; l; k--, h--, d++) {
      if (matrix[k][h] != word[d])
        break;
    }
    if (d == l)
      return true;
  }
  return false;
}

vector&lt;pair&lt;int, int&gt; &gt; where(vector&lt;string&gt; & matrix, vector&lt;string&gt; & words) {
  to_lower(matrix);
  to_lower(words);
  int c = words.size();
  vector&lt;pair&lt;int, int&gt; &gt; pos(c);
  vector&lt;bool&gt; found(c);
  int m = matrix.size();
  int n = matrix[0].size();
  for (int i = 0; i &lt; m; i++) {
    for (int j = 0; j &lt; n; j++) {
      for (int k = 0; k &lt; c; k++) {
        if (!found[k] && matrix[i][j] == words[k][0] && find(matrix, m, n, i, j, words[k])) {
          found[k] = true;
          pos[k] = make_pair(i, j);
        }
      }
    }
  }
  return pos;
}

int main() {
  int t = 0;
  cin &gt;&gt; t;
  for (int i = 0; i &lt; t; i++) {
    int m, n;
    cin &gt;&gt; m &gt;&gt; n;
    vector&lt;string&gt; matrix(m);
    int j;
    for (j = 0; j &lt; m; j++) {
      cin &gt;&gt; matrix[j];
    }
    int k;
    cin &gt;&gt; k;
    vector&lt;string&gt; words(k);
    for (j = 0; j &lt; k; j++) {
      cin &gt;&gt; words[j];
    }
    vector&lt;pair&lt;int, int&gt; &gt; pos = where(matrix, words);
    if (i)
      cout &lt;&lt; endl;
    for (j = 0; j &lt; pos.size(); j++) {
      cout &lt;&lt; pos[j].first + 1 &lt;&lt; ' ' &lt;&lt; pos[j].second + 1 &lt;&lt; endl;
    }
  }
  return 0;
}
```

