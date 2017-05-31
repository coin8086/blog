---
title: Common Permutation
date: 2013-06-25T19:38:41+08:00
pc-id: 110303
uva-id: 10252
---
分析：本题只要求得到一个字符串x，使得x的**某两个排列分别是**两个给定字符串的子串，并没有要求x的**某一个排列同时是**两个给定字符串的子串。理解清楚这一点非常重要——如果题目要求是后者，则问题就演变成了求两个字符串的最长（非连续的）公共子序列（LCS）的问题，难度陡升。<!--more-->笔者开始就是没有看清这一点，得出了错误的答案——不过，从另一个角度讲，如果是后者应该怎样解答呢？笔者的答案在

<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch3_ex3_lcs.cpp" target="_blank">这里</a>。

```cpp
#include <iostream>
#include <string>
#include <algorithm>

#define MAX_LEN 1000

using namespace std;

typedef string::iterator It;

string cp(string & s1, string & s2) {
  sort(s1.begin(), s1.end());
  sort(s2.begin(), s2.end());
  string c;
  c.reserve(MAX_LEN);
  It p1 = s1.begin();
  It p2 = s2.begin();
  while (p1 != s1.end() && p2 != s2.end()) {
    if (*p1 == *p2) {
      c += *p1;
      ++p1;
      ++p2;
    }
    else if (*p1 < *p2) {
      ++p1;
    }
    else {
      ++p2;
    }
  }
  return c;
}

int main() {
  string s1, s2;
  s1.reserve(MAX_LEN);
  s2.reserve(MAX_LEN);
  while (getline(cin, s1) && getline(cin, s2)) {
    cout << cp(s1, s2) << endl;
  }
  return 0;
}
```

