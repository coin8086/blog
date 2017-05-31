---
title: Chopsticks
date: 2017-05-30T16:15:00+08:00
pc-id: 111107
uva-id: 10271
---
如果考虑一般情况：把n个元素划分成p组（p = k + 8）、每组3个元素，分别计算每种划分的“难用度”然后找出最小值，这种穷举算法时间复杂度巨大、不可用。

题目中说筷子数组l是按长度排好序的，这是一点很重要的提示：如果我们拿l[i]做A筷，则B筷一定是l[i + 1]才能保证(A - B) ^ 2最小，至于C筷，只要它的序号大于i + 1即可。

这样，如果设f(i, j)为从l[i]到l[n - 1]里选出j组筷子（每组3支）的最小“难用度”，则f(0, p)即求解目标，并有以下递推式：

<!--more-->

```
f(i, j) = min{ (l[i + 1] - l[i]) ^ 2 + f(i + 2, j - 1), f(i + 1, j) }
```

其中0 <= i < n，0 <= j <= p；另外，还要满足i + 3 * j <= n以保证有足够的筷子可选。

以上递推式的意义是：在从l[i]到l[n - 1]选择j组筷子时，我们可以选择l[i]做为某一组的A筷（这样l[i + 1]就是B筷），这一组的难用度就是(l[i + 1] - l[i]) ^ 2，然后我们再从l[i + 2]到l[n - 1]选择剩下的j - 1组筷子，其最小难用度是f(i + 2, j - 1)；或者我们不选l[i]，而是从l[i + 1]到l[n - 1]选择j组筷子。这两种方法的最小值就是f(i, j)。另外，当i + 3 * j > n时，令f(i, j)为INF，表示没有足够的筷子可选。为计算方便，我们可令f(i, 0) = 0，表示一组都不选时难用度为0。

代码如下：

```cpp
#include <climits>
#include <vector>
#include <algorithm>
#include <iostream>

using namespace std;

int solve(const vector<int> & l, int k) {
  int n = l.size();
  int p = k + 8;
  vector<vector<int> > m(n);
  for (int i = 0; i < n; i++) {
    m[i].resize(p + 1, INT_MAX);
    m[i][0] = 0;
  }

  vector<int> delta(n - 1);
  for (int i = 0; i < n - 1; i++) {
    int d = l[i + 1] - l[i];
    delta[i] = d * d;
  }

  for (int i = n - 3; i >= 0; i--) {
    for (int j = 1; j <= p; j++) {
      if (i + 3 * j <= n) {
        m[i][j] = min(delta[i] + m[i + 2][j - 1], m[i + 1][j]);
      }
    }
  }

  return m[0][p];
}

int main() {
  int t;
  cin >> t;
  for (int i = 0; i < t; i++) {
    int k, n;
    cin >> k >> n;
    vector<int> L;
    for (int j = 0; j < n; j++) {
      int l;
      cin >> l;
      L.push_back(l);
    }
    cout << solve(L, k) << endl;
  }
  return 0;
}
```

