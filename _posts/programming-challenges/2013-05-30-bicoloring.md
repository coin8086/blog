---
title: Bicoloring
date: 2013-05-30T20:59:49+08:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - programming-challenges
---
PC/UVa IDs: 110901/10004 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=37&#038;page=show_problem&#038;problem=945" target="_blank">题目描述</a>

分析：对图做广度优先遍历，一边对节点v着色一边检查v是否与某个已着色的临接点同色。<!--more-->

```cpp
#include <iostream>
#include <vector>
#include <queue>

#define RED 1
#define BLACK (-1)

using namespace std;

typedef vector<vector<int> > Graph;

bool bicolorable(const Graph & g) {
  bool r = true;
  vector<int> color(g.size());
  queue<int> q;
  color[0] = RED;
  q.push(0);
  while (!q.empty()) {
    int v = q.front();
    int c = color[v];
    for (int i = 0; i < g[v].size(); i++) {
      int v2 = g[v][i];
      int & c2 = color[v2];
      if (!c2) {
        c2 = c * -1;
        q.push(v2);
      }
      else if (c2 * c != -1) {
        r = false;
        break;
      }
    }
    q.pop();
  }
  return r;
}

int main() {
  int nv = 0;
  while ((cin >> nv) && nv) {
    Graph g(nv);
    int ne = 0;
    cin >> ne;
    for (int i = 0; i < ne; i++) {
      int v1, v2;
      cin >> v1 >> v2;
      g[v1].push_back(v2);
      g[v2].push_back(v1);
    }
    if (bicolorable(g))
      cout << "BICOLORABLE." << endl;
    else
      cout << "NOT BICOLORABLE." << endl;
  }
  return 0;
}
```

