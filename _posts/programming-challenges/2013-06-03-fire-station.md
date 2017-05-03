---
title: Fire Station
date: 2013-06-03T14:10:06+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 111003/10278 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=38&#038;page=show_problem&#038;problem=1219" target="_blank">题目描述</a>

分析：如果点i有一个消防站，那么i到其它各点的最近距离是多少？如果点j又有一个消防站呢？如果用矩阵表示图g，用Floyd算法求出每对顶点的最短距离（直接更新图g），那么g[i]就是i点的消防站到各点的最近距离的向量。如果j点又有一个消防站，则按如下方式把g[i]和g[j]合并起来就得到各点到最近消防站的距离向量（即下面的merge函数）：
  
对g\[i]和g[j]的每一个元素（索引为k），取min(g[i\]\[k\], g\[j\]\[k\])作为新的距离向量的元素k的值。<!--more-->


  
对图g中的所有点，依次尝试在没有消防站的点上建立一个消防站，找出一个最远“最近距离”；再比较这些值，找出一个最小的即可解题。

```cpp
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>
#include <climits>

using namespace std;

typedef vector<vector<int> > Graph;

void init(Graph & g) {
  int n = g.size();
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      if (i != j)
        g[i][j] = INT_MAX;
      else
        g[i][j] = 0;
    }
  }
}

void floyd(Graph & g) {
  int n = g.size();
  for (int k = 0; k < n; k++) {
    for (int i = 0; i < n; i++) {
      int ik = g[i][k];
      if (ik == INT_MAX)
        continue;
      for (int j = 0; j < n; j++) {
        if (g[k][j] == INT_MAX)
          continue;
        g[i][j] = min(g[i][j], ik + g[k][j]);
      }
    }
  }
}

inline void merge(vector<int> & v1, const vector<int> & v2) {
  for (int i = 0; i < v1.size(); i++) {
    v1[i] = min(v1[i], v2[i]);
  }
}

int station(Graph & g, const vector<int> & f) {
  floyd(g);
  vector<int> dist = g[f[0]]; //current nearest fire station distance vector.
  int i;
  for (i = 1; i < f.size(); i++) {
    merge(dist, g[f[i]]);
  }
  int n = g.size();
  vector<int> max; //if new position is at i, then max[i] is the max nearest distance
  vector<int>::iterator it;
  for (i = 0; i < n; i++) {
    if (dist[i]) {  // if there's no fire station at i
      vector<int> d = dist;
      merge(d, g[i]);
      it = max_element(d.begin(), d.end());
      max.push_back(*it);
    }
    else {
      max.push_back(INT_MAX);
    }
  }
  it = min_element(max.begin(), max.end());
  return it - max.begin();
}

int main() {
  int n = 0;
  cin >> n;
  for (int i = 0; i < n; i++) {
    int nf, nv;
    cin >> nf >> nv;
    vector<int> s;
    for (int j = 0; j < nf; j++) {
      int f;
      cin >> f;
      s.push_back(f - 1);  //we start from 0
    }
    vector<int>::iterator it = unique(s.begin(), s.end()); //it says fire stations may overlap
    s.erase(it, s.end());
    string line;
    getline(cin, line); //skip trailing 'n'
    Graph g(nv, vector<int>(nv));
    init(g);
    while (getline(cin, line) && !line.empty()) {
      istringstream is(line);
      int u, v;
      int w;
      is >> u >> v >> w;
      u--, v--; //we start from 0
      g[u][v] = w;
      g[v][u] = w;
    }
    if (i)
      cout << endl;
    cout << station(g, s) + 1 << endl;
  }
  return 0;
}
```

