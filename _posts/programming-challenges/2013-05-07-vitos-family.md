---
title: 'Vito&#8217;s Family'
date: 2013-05-07T23:20:13+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110401/10041 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=982" target="_blank">题目描述</a>

分析：该题等价于“寻找一个正整数A，使得在一个给定的正整数数列中的每一个数与A的差的绝对值之和最小”。显然A应当不小于该数列的最小值，不大于该数列的最大值。乍看上去，似乎平均数是一个比较合理的解，但考虑一个例子“1 30000 30000”，其平均数约20000，此时的和约为40000，但如果A取30000，其和约为30000，显然取平均数是错误的。经过一番尝试，似乎中位数是一个更合理的解。<!--more-->但如何证明？这到颇费思量，可参考

<a href="http://wenku.baidu.com/view/375f42dc5022aaea998f0fea" target="_blank">中位数性质的证明</a>。得到证明之后，解题便相当容易了。另外值得商榷的是：书中本题的难度系数很低，但如果不了解中位数的这个性质，解题还是相当头疼的。因此笔者以为这不是一道好题目。

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdlib>

using namespace std;

inline int sum(const vector<int> & rel, int k) {
  int sum = 0;
  for (int i = 0; i < rel.size(); i++) {
    sum += abs(rel[i] - k);
  }
  return sum;
}

int min(vector<int> & rel) {
  if (rel.size() == 1)
    return 0;
  sort(rel.begin(), rel.end());
  int mid = rel.size() / 2;
  return sum(rel, rel[mid]);
}

int main() {
  int n = 0;
  cin >> n;
  for (int i = 0; i < n; i++) {
    int r = 0;
    cin >> r;
    vector<int> rel(r);
    int j;
    for (j = 0; j < r; j++) {
      cin >> rel[j];
    }
    cout << min(rel) << endl;
  }
}
```

