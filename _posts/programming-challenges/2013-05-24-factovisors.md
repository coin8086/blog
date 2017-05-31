---
title: Factovisors
date: 2013-05-24T16:51:46+08:00
pc-id: 110704
uva-id: 10139
---
分析：若m是合数，把m分解为质因数的乘积

m=(p1^k1)(p2^k2)...(pi^ki)

对于m的每一个质因数pi，若其次数ki都不大于n!里pi的最大次数Ki，则m可以整除n!，反之则不能。

若m是质数，只要m不大于n即可整除n!；若m等于1，m可以整除任何n!。<!--more-->

另外：programming-challenges.com对本答案判定为正确，但UVa却判错。笔者仔细检查了算法和实现，没有发现问题。

```cpp
#include <iostream>
#include <vector>
#include <utility>
#include <cmath>

using namespace std;

typedef unsigned int uint;
typedef vector<pair<uint, uint> > PVec;

PVec prime_factors(uint m) {
  PVec r;
  uint i = 2;
  uint c = 0;
  while (m % i == 0) {
    m /= i;
    c++;
  }
  if (c)
    r.push_back(make_pair(i, c));
  i = 3;
  while (i <= sqrt(m) + 1) {
    c = 0;
    while (m % i == 0) {
      m /= i;
      c++;
    }
    if (c)
      r.push_back(make_pair(i, c));
    i += 2;
  }
  return r;
}

bool divisible(uint n, uint m) {
  if (m < 2) {
    return m ? true : false;
  }
  bool r = true;
  PVec factors = prime_factors(m);
  if (factors.empty()) {
    if (n < m)
      r = false;
  }
  else {
    for (int i = 0; i < factors.size(); i++) {
      uint p = factors[i].first;
      uint c = factors[i].second;
      uint count = 0;
      uint np;
      uint t = n;
      while ((np = t / p) > 0) {
        count += np;
        if (count >= c)
          break;
        t = np;
      }
      if (count < c) {
        r = false;
        break;
      }
    }
  }
  return r;
}

int main() {
  uint n, m;
  while (cin >> n >> m) {
    if (divisible(n, m)) {
      cout << m << " divides " << n << "!" << endl;
    }
    else {
      cout << m << " does not divide " << n << "!" << endl;
    }
  }
  return 0;
}
```

