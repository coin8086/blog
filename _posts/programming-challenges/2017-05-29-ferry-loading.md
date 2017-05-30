---
title: Ferry Loading
date: 2017-05-29T21:00:00+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - programming-challenges
---
PC/UVa：111106/[10261](https://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=1202)

此题最简单、直观的办法是递归求解：

<!--more-->

```cpp
vector<int> a; //待登船的汽车长度（单位厘米）数组
int L; //车道长度，单位厘米

//当左右两个车道可用容量分别为left、right时，
//从a[i]到a[n - 1]可登船的最多汽车数
int solve(int i, int left, int right) {
  if (i >= a.size() || (a[i] > left && a[i] > right))
    return 0;
  int l = 0;
  int r = 0;
  //如果a[i]放在左边
  if (a[i] <= left)
    l = solve(i + 1, left - a[i], right) + 1;
  //如果a[i]放在右边
  if (a[i] <= right)
    r = solve(i + 1, left, right - a[i]) + 1;
  return l >= r ? l : r;
}

solve(0, L, L);
```

但是递归解的时间复杂度高达O(2^N)，N为登船汽车数量，超过20量车时性能会严重下降，不可取。

但是从上面的递归解可以得到一个递推公式： 设f(i, left, right)为当左右两个车道可用容量分别为left、right时，从a[i]到a[n - 1]可登船的最多汽车数，则有：

```cpp
int solve2() {
  vector<vector<vector<int> > > m(a.size() + 1);
  for (int i = 0; i < m.size(); i++) {
    m[i].resize(L + 1);
    for (int j = 0; j <= L; j++) {
      m[i][j].resize(L + 1);
    }
  }
  for (int i = m.size() - 2; i >= 0; i--) {
    for (int l = 0; l <= L; l++) {
      for (int r = 0; r <= L; r++) {
        int lm = 0;
        int rm = 0;
        if (a[i] <= l)
          lm = m[i + 1][l - a[i]][r] + 1;
        if (a[i] <= r)
          rm = m[i + 1][l][r - a[i]] + 1;
        m[i][l][r] = lm >= rm ? lm : rm;
      }
    }
  }
  return m[0][L][L];
}
```

以上算法的时间复杂度为O(L * L * N)，由于1 <= L <= 10000，即使对于小规模N，如果L比较大，仍然相当耗时、甚至难以计算！

能不能找到O(L * N)的算法呢？ 上面的递推式f(i, l, r)能不能变成f(i, l)呢？

答案是肯定的：实际上，在a[i]登船之前，a[0]到a[i - 1]已经登船，记其总长为s(i - 1)，又因为两条车道总长为L * 2，所以总可用长度为L * 2 - s(i - 1)，如果左边车道可用长度为l, 则右边车道可用长度为L * 2 - s(i - 1) - l，降维成功！代码如下：

```cpp
vector<bool> solve3() {
  vector<vector<int> > m(a.size() + 1);
  for (int i = 0; i < m.size(); i++) {
    m[i].resize(L + 1);
  }

  //port[i][j]记录m[i][j]选择的左／右车道，左边为true，右边false
  vector<vector<bool> > port(a.size() + 1);
  for (int i = 0; i < port.size(); i++) {
    port[i].resize(L + 1);
  }

  int s = 0;
  for (int i = 0; i < a.size(); i++) {
    s += a[i];
  }

  for (int i = m.size() - 2; i >= 0; i--) {
    s -= a[i];
    for (int j = 0; j <= L; j++) {
      int ra = L * 2 - s - j;
      int l = 0;
      int r = 0;
      if (a[i] <= j)
        l = m[i + 1][j - a[i]] + 1;
      if (a[i] <= ra)
        r = m[i + 1][j] + 1;
      m[i][j] = l >= r ? l : r;
      port[i][j] = l >= r;
    }
  }

  //返回一个数组，长度为可登船最多汽车数，ret[i]表示a[i]进左／右车道。
  vector<bool> ret;
  int i = 0;
  int j = L;
  while (m[i][j] > 0) {
    ret.push_back(port[i][j]);
    if (port[i][j])
      j -= a[i];
    i++;
  }
  assert(m[0][L] == ret.size());
  return ret;
}
```
