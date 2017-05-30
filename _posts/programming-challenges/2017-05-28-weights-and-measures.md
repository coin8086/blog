---
title: Weights and Measures
date: 2017-05-28T21:00:00+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - programming-challenges
---
PC/UVa：111103/10154

此题贪心可解：定义第i层的最大负载为p(i)，则：

<!--more-->

```
if i == 0
  //设第0层为大地，负载无穷大
  p(0) = INF

if i > 0
  //设第k只乌龟的重量和力量分别为w[k]和m[k]
  p(i) = max({ min(m[k] - w[k], p(i - 1) - w[k]) | 0 <= k < n 并且第k只乌龟还没入栈 })
```

以上`m[k] - w[k]`为第k只乌龟的最大负载，`p(i - 1) - w[k]`为第i层上减去第k只乌龟的重量得到的可能最大负载，这二者的最小值就是第k只乌龟在第i层上的最大负载。在所有这些可能的负载中找出一个最大的，就是第i层的最大负载p(i)。代码如下：

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

using namespace std;

int height(const vector<int> & w, const vector<int> & m) {
  vector<bool> used(w.size());
  int h = 0;
  int capacity = INT_MAX; //某一层的最大负载p，初始为大地（第0层）
  for (int i = 0; i < w.size(); i++) {
    int max = -1;
    int max_j = -1;
    for (int j = 0; j < w.size(); j++) {
      if (!used[j] && w[j] <= capacity) {
        int c = min(m[j] - w[j], capacity - w[j]);
        if (max < c) {
          max = c;
          max_j = j;
        }
      }
    }
    if (max < 0)
      return h;
    capacity = max;
    used[max_j] = true;
    h++;
  }
  return h;
}

int main() {
  vector<int> w, m;
  int wi, mi;
  while ((cin >> wi >> mi)) {
    w.push_back(wi);
    m.push_back(mi);
  }
  cout << height(w, m) << endl;
  return 0;
}
```

时间复杂度为O(N * N)，N为乌龟数。

