---
title: Playing With Wheels
date: 2017-05-31T16:15:00+08:00
pc-id: 110902
uva-id: 10067
---
每个数字代表一个状态，其任意一位左／右转动得出的数字代表一个新的状态：如果把这些状态看作一张图的顶点，在一个状态和它可以（一步）到达的状态之间连一条线，那么在初始状态和目标状态之间的最短路径长度就等于最少的转换步数，可以用广度优先搜索得到；对于禁止的状态，可以在遍历图之前就把它们标记为“已访问”状态，这样就不会搜素经过这些禁止状态的路径了。代码如下：

<!--more-->

```cpp
#include <vector>
#include <queue>
#include <iostream>
#include <cassert>

using namespace std;

struct Status {
  int val;
  int dist;

  Status() : val(0), dist(0) {}

  Status(int n, int d) : val(n), dist(d) {}
};

inline vector<char> numToDigits(int n) {
  vector<char> digits;
  while (n > 0) {
    char ch = n % 10;
    n /= 10;
    digits.push_back(ch);
  }
  digits.resize(4); //make sure leading 0s
  return digits;
}

inline int digitsToNum(const vector<char> & digits) {
  int n = 0;
  int p = 1;
  for (int i = 0; i < digits.size(); i++) {
    n += digits[i] * p;
    p *= 10;
  }
  assert(n < 10000);
  return n;
}

int step[] = {1, -1};

vector<int> neighbours(int n) {
  vector<int> ret;
  vector<char> digits = numToDigits(n);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 2; j++) {
      char d = digits[i];
      char ds = d + step[j];
      if (ds < 0)
        ds += 10;
      ds %= 10;
      digits[i] = ds;
      int ns = digitsToNum(digits);
      ret.push_back(ns);
      digits[i] = d;
    }
  }
  return ret;
}

int solve(int s, int t, vector<bool> & visited) {
  queue<Status> q;
  q.push(Status(s, 0));
  visited[s] = true;
  while (!q.empty()) {
    Status e = q.front();
    q.pop();
    if (e.val == t)
      return e.dist;
    vector<int> ns = neighbours(e.val);
    for (int i = 0; i < ns.size(); i++) {
      int n = ns[i];
      if (!visited[n]) {
        visited[n] = true;
        q.push(Status(n, e.dist + 1));
      }
    }
  }
  return -1;
}

int parseNum() {
  vector<char> s(4);
  for (int k = 0; k < 4; k++) {
    int ch;
    cin >> ch;
    s[4 - 1 - k] = ch;
  }
  return digitsToNum(s);
}

int main() {
  int t;
  cin >> t;
  for (int i = 0; i < t; i++) {
    int s = parseNum();
    int t = parseNum();
    int n;
    cin >> n;
    vector<bool> visited(10000, false);
    for (int k = 0; k < n; k++) {
      int p = parseNum();
      visited[p] = true;
    }
    cout << solve(s, t, visited) << endl;
  }
  return 0;
}
```
