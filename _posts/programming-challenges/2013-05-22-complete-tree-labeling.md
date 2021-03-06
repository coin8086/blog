---
title: Complete Tree Labeling
date: 2013-05-22T18:06:07+08:00
pc-id: 110605
uva-id: 10247
---
分析：如果已知深度为d - 1的k叉树(以下代称T(d-1))一共有a(k, d - 1)种标号法，那么深度为d的k叉树（以下代称T(d)）的a(k, d)如何计算？<!--more-->

对T(d)来说，除去根节点，恰好有k棵T(d-1)子树，考虑到根节点的标号必须是1，则T(d)的标号方法可以分两步进行：首先把2~n的标号分成k组，每组m个，共有

x = C(km, m)\*C((km - m), m)\*C((km - 2m), m)\*...\*C((km - (k - 1)m), m) = (k*m)!/((m!)^k)

种方法；对于每种分组方法，又有a(k, d - 1)^k种组合；因此

a(k, d) = (a(k, d - 1)^k)\*(k\*m)!/((m!)^k)

其中m=(k^d - 1)/(k - 1)，a(k, 0) = 1。但要注意：

1）k = 1时，树退化为链表，无论d如何a(1, d)都是1。

2）注意到其实

m(d) = 1 + k + k^2 + ... + k^(d - 1)

因此可以用递推的方式高效计算m(0)到m(n)的值。

3)注意到k*d<=21，当k=4,d=5时m的数量级在1000，但1000!已远超64位整数的能力范围，如不能设法简化a(k, d)的算式，避免(m!)^k这样的大数运算，就只有……使用自定义的大数运算了（很不幸地，C/C++的标准库都没有大整数运算函数，因此为解题不得不手工编写　<a href="https://code.google.com/p/programming-challenges-robert/source/browse/bigint.h" target="_blank">bigint.h</a>（但是Java标准库却有BigInt类可用，因此此题用Java可以很方便地求解）。

```cpp
#include <iostream>
#include <vector>
#include <cstring>
#include "bigint.h"

using namespace std;

BigInt results[22][22];

int m[22][22];

void init() {
  int k, d;
  for (d = 0; d < 22; d++) {
    results[1][d] = 1;
  }
  for (k = 2; k < 22; k++) {
    results[k][0] = 1;
  }
  memset(m, 0, sizeof(m));
}

int compute_m(int k, int d) {
  int r = m[k][d];
  if (!r && d) {
    r = k * compute_m(k, d - 1) + 1;
    m[k][d] = r;
  }
  return r;
}

BigInt compute(int k, int d) {
  BigInt r = results[k][d];
  if (r.zero()) {
    BigInt smaller = compute(k, d - 1);
    int m = compute_m(k, d);
    //x = (k * m)! / ((m!) ^ k);
    //r = (smaller ^ k) * x;
    BigInt x = BigInt::fact(m * k) / BigInt::pow(BigInt::fact(m), k);
    r = BigInt::pow(smaller, k) * x;
    results[k][d] = r;
  }
  return r;
}

int main() {
  init();
  int k, d;
  while (cin >> k >> d) {
    cout << compute(k, d) << endl;
  }
  return 0;
}
```

