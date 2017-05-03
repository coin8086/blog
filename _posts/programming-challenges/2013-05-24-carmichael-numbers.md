---
title: Carmichael Numbers
date: 2013-05-24T21:37:16+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110702/10006 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=947" target="_blank">题目描述</a>

分析：只要注意到当n为偶数时
  
(a^n) mod n = (((a^(n/2)) mod n)*((a^(n/2)) mod n)) mod n
  
当n为奇数时
  
(a^n) mod n = (((a^(n/2)) mod n)\*((a^(n/2)) mod n)\*a) mod n
  
则(a^n) mod n运算可在O(log(n))的时间内完成。<!--more-->


  
另外：本答案会导致超时（TLE），优化的方案是：先把65000以内的所有Carmichael数计算出来！其实不过区区十几个数而已。

```cpp
#include <iostream>
#include <cmath>

using namespace std;

typedef unsigned int uint;

bool prime(uint n) {
  if (n % 2 == 0)
    return false;
  uint i = 3;
  uint h = sqrt(n) + 1;
  while (i <= h) {
    if (n % i == 0)
      return false;
    i += 2;
  }
  return true;
}

uint mod(uint a, uint n, uint m) {
  if (n == 1)
    return a;
  uint x = mod(a, n / 2, m);
  x = (x * x) % m;
  if (n % 2)
    x = (x * a) % m;
  return x;
}

bool carm(uint n) {
  bool r = true;
  for (int i = 2; i < n; i++) {
    if (mod(i, n, n) != i) {
      r = false;
      break;
    }
  }
  if (r && prime(n))
    r = false;
  return r;
}

int main() {
  uint n;
  while (cin >> n && n) {
    if (carm(n))
      cout << "The number " << n << " is a Carmichael number." << endl;
    else
      cout << n << " is normal." << endl;
  }
  return 0;
}
```

