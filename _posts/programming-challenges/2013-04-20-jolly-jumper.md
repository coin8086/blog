---
title: Jolly Jumper
date: 2013-04-20T17:30:31+08:00
pc-id: 110201
uva-id: 10038
---
<!--more-->

```cpp
#include <iostream>
#include <vector>

using namespace std;

typedef long long ll_t;

bool load_input(vector<ll_t> & s) {
  s.clear();
  int n;
  if (!(cin >> n))
    return false;
  for (int i = 0; i < n; i++) {
    ll_t k;
    if (!(cin >> k))
      return false;
    s.push_back(k);
  }
  return true;
}

bool jolly(const vector<ll_t> & s) {
  int n = s.size();
  if (n <= 1)
    return true;
  vector<bool> r(n, false);
  for (int i = 0; i < n - 1; i++) {
    ll_t d = s[i] - s[i + 1];
    if (d < 0)
      d *= -1;
    if (d > n - 1 || d < 1 || r[d])
      return false;
    r[d] = true;
  }
  return true;
}

int main() {
  vector<ll_t> s;
  while (load_input(s)) {
    if (jolly(s)) {
      cout << "Jolly" << endl;
    }
    else {
      cout << "Not jolly" << endl;
    }
  }
  return 0;
}
```

