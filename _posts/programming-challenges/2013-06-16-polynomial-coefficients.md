---
title: Polynomial Coefficients
date: 2013-06-16T13:15:28+08:00
pc-id: 110506
uva-id: 10105
---
分析：考虑二项式

(x1 + x2) ^ n

其中

x1 ^ m * x2 ^ (n - m)

项的系数是组合数

C(n, m)

多项式

(x1 + x2 + ... + xk) ^ n

可以记为

((x1 + x2 + ... + x(k - 1)) + xk) ^ n <!--more-->

其中

(x1 + x2 + ... + x(k -1)) ^ (n - nk) * xk ^ nk

项的系数是

C(n, nk) * f(n - nk, k - 1)

其中f(n, k)即n次k项式中

x1 ^ n1 \* x2 ^ n2 \* ... \* xk \* nk

项的系数。

由此得到递归解法：

```cpp
#include <iostream>
#include <vector>

#define MAX 12

using namespace std;

vector<int> fact;

inline void init() {
  fact.resize(MAX + 1);
  fact[0] = 1;
  for (int i = 1; i < fact.size(); i++) {
    fact[i] = fact[i - 1] * i;
  }
}

inline int combination(int n, int m) {
  return fact[n] / (fact[n - m] * fact[m]);
}

int coefficient(int n, vector<int> & e) {
  int r;
  if (e.size() == 1) {
    r = 1;
  }
  else if (e.size() == 2) {
    r = combination(n, e[0]);
  }
  else {
    int last = e.back();
    int c = combination(n, last);
    e.pop_back();
    r = coefficient(n - last, e) * c;
  }
  return r;
}

int main() {
  init();
  int n, k;
  while (cin >> n >> k) {
    vector<int> e;
    e.reserve(k);
    for (int i = 0; i < k; i++) {
      int c;
      cin >> c;
      e.push_back(c);
    }
    cout << coefficient(n, e) << endl;
  }
  return 0;
}
```

