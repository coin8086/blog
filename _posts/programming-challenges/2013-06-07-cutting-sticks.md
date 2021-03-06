---
title: Cutting Sticks
date: 2013-06-07T23:01:55+08:00
pc-id: 111105
uva-id: 10003
---
分析：割点把木棍分成了若干区间，把这些区间从0到n编号，假设从区间i到j的最小代价为f(i, j)，则f(0, n)即整根木棍的代价。不妨在稿纸上推演一下，如何从f(0, 1)开始一步步计算得到f(0, 2)，f(0, 3)（以下设len(i, j)为区间i到j的长度）：

f(0, 1) = len(0, 1)

f(1, 2) = ...

f(0, 2) = min(f(0, 1) + f(2, 2), f(0, 0) + f(1, 2)) + len(0, 2)

f(1, 3) = ...

f(2, 3) = ...

f(0, 3) = min(f(0, 2) + f(3, 3), f(0, 1) + f(2, 3), f(0, 0) + f(1, 3)) + len(0, 3)

可以归纳得到：<!--more-->

当i < j时：

f(i, j) = min(f(i, j - 1) + f(j, j), f(i, j - 2) + f(j - 1, j), ..., f(i, i) + f(i + 1, j)) + len(i, j)

当i == j时

f(i, j) = 0

如果用表格seg\[i\]\[j\]来存贮f(i, j)的值，即可以动态规划解之。但须注意单元格的计算顺序：从左至右，从下往上。只需计算i < j的格子，i = j的格子初始化为0。

```cpp
#include <iostream>
#include <vector>
#include <climits>

using namespace std;

int cut(int l, const vector<int> & pos) {
  if (pos.size() < 1)
    return pos.empty() ? 0 : l;
  //n cut positions divides one stick into n + 1 sections.
  //sec stores the beginning position of a section. To make it easy to calculate
  //a section length, sec stores the length of the stick as the begnning of a section
  //beyond the n + 1 real sections.
  vector<int> sec;
  sec.push_back(0);
  sec.insert(sec.end(), pos.begin(), pos.end());
  sec.push_back(l);
  int n = sec.size() - 1;
  vector<vector<int> > seg(n, vector<int>(n, 0));
  for (int j = 1; j < n; j++) {
    for (int i = j - 1; i >= 0; i-) {
      int s = 0;
      int m = INT_MAX;
      for (int k = 1; k <= j - i; k++) {
        s = seg[i][j - k] + seg[j - k + 1][j];
        if (s < m)
          m = s;
      }
      seg[i][j] = m + (sec[j + 1] - sec[i]); //m + the length of sections from i to j
    }
  }
  return seg[0][n - 1];
}

int main() {
  int l;
  while ((cin >> l) && l > 0) {
    int n = 0;
    cin >> n;
    vector<int> pos;
    pos.reserve(n);
    for (int i = 0; i < n; i++) {
      int p;
      cin >> p;
      pos.push_back(p);
    }
    cout << "The minimum cutting is " << cut(l, pos) << "." << endl;
  }
  return 0;
}
```

