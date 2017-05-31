---
title: Light, More Light
date: 2013-06-21T23:57:45+08:00
pc-id: 110701
uva-id: 10110
---
分析：最直接的想法是如下代码：

```cpp
bool on = false;
for (int i = 1; i <=n; i++)
  if (n % i == 0)
    on = !on
```

但n最大可达数十亿，此法计算效率太低！那么能不能倒过来想：n可以被多少个不大于n的数整除？很容易给n分解质因数：<!--more-->

n = p1\*p2\*p3\*...\*pk

再用组合数学的办法求出这些质因数中的若干个相乘能得到多少个不同整数，是否可以解题？笔者相信理论上可以但是太过复杂。实际上我们不必知道有多少个不大于n的数能整除n，只要知道这些数，即n的因子，是奇数个还是偶数个即可：奇数亮灯，偶数灭灯。对于大于1的整数来说，可以用如下方法统计其因子数量的奇偶性：

假设整数n的平方根是实数r，则对于每个小于r的因子p，必有一个大于r的因子q，使得p * q = n；如果实数r不是整数，则n必有偶数个因子，否则为奇数个。

也就是说，当且仅当n为完全平方数时，灯亮。

```cpp
#include <iostream>
#include <cmath>

using namespace std;

typedef unsigned int uint;

inline bool light_on(uint n) {
  uint r = floor(sqrt((double)n));
  return r * r == n;
}

int main() {
  uint n = 0;
  while ((cin >> n) && n) {
    cout << (light_on(n) ? "yes" : "no") << endl;
  }
  return 0;
}
```

