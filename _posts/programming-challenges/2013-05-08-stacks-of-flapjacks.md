---
title: Stacks of Flapjacks
date: 2013-05-08T19:47:04+08:00
pc-id: 110402
uva-id: 120
---
分析：把一堆煎饼按自底向上的顺序插入到数组中（这样饼号就等于元素下标号加一），然后从数组第一个元素开始向后遍历，每次把最大的煎饼放在遍历的当前位置。<!--more-->

```cpp
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;

vector<int> flip(vector<int> & flaps) {
  vector<int> flips;
  vector<int>::iterator begin = flaps.begin();
  vector<int>::iterator end = flaps.end();
  for (int i = 0; i < flaps.size(); i++) {
    vector<int>::iterator icurrent = begin + i;
    vector<int>::iterator imax = max_element(icurrent, end);
    if (imax != icurrent) {
      if (imax + 1 != end) {
        flips.push_back(imax - begin + 1);
        reverse(imax, end);
      }
      flips.push_back(i + 1);
      reverse(icurrent, end);
    }
  }
  flips.push_back(0);
  return flips;
}

int main() {
  string line;
  while (getline(cin, line)) {
    istringstream is(line);
    vector<int> flaps;
    int d;
    while (is >> d) {
      flaps.push_back(d);
    }
    reverse(flaps.begin(), flaps.end());
    vector<int> flips = flip(flaps);
    cout << line << endl;
    for (int i = 0; i < flips.size(); i++) {
      if (i != 0)
        cout << ' ';
      cout << flips[i];
    }
    cout << endl;
  }
}
```

