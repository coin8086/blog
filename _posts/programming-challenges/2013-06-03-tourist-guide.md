---
title: Tourist Guide
date: 2013-06-03T22:58:06+08:00
pc-id: 111006
uva-id: 10199
---
分析：此题是图的连通性问题。摄像头都位于图的关节点（articulation point）上。判断点v是否是关节点的简单办法是把v及其附着边从图中删去，然后用dfs或bfs检验图是否连通，若不连通则v是关节点。对图中的点依次做判断即可得出摄像头位置。<!--more-->需要注意的是：输入的图可能是不连通的，须要把它拆成若干最大连通子图，然后再找出每个子图中的关节点。笔者不得不说，这是一个大坑。

另外，寻找关节点还有效率更高的办法：可以通过一次dfs找出图的所有关节点，实现稍复杂。

```cpp
#include <iostream>
#include <vector>
#include <map>
#include <set>
#include <string>
#include <queue>
#include <algorithm>

using namespace std;

typedef map<string, vector<string> > Graph;

//remove a vertex v in g to get a new graph
Graph remove(const Graph & g, const string & v) {
  Graph ng = g;
  ng.erase(v);
  Graph::iterator it = ng.begin();
  for (; it != ng.end(); it++) {
    vector<string> & vec = it->second;
    int size = vec.size();
    for (int i = 0; i < size; i++) {
      if (vec[i] == v) {
        if (i != size - 1)
          swap(vec[i], vec.back());
        vec.resize(size - 1);
        break;
      }
    }
  }
  return ng;
}

//bfs g from vertex v and record visited vertexes in visited
void visit(const Graph & g, const string & v, set<string> & visited) {
  queue<string> q;
  visited.insert(v);
  q.push(v);
  while (!q.empty()) {
    const string & u = q.front();
    const vector<string> & vec = g.at(u);
    for (int i = 0; i < vec.size(); i++) {
      if (!visited.count(vec[i])) {
        visited.insert(vec[i]);
        q.push(vec[i]);
      }
    }
    q.pop();
  }
}

//judge whether graph is connected
inline bool connected(const Graph & g) {
  set<string> visited;
  visit(g, g.begin()->first, visited);
  return visited.size() == g.size();
}

//get a subgraph from g, with only vertexes in s
Graph subgraph(const Graph & g, const set<string> & s) {
  Graph ng;
  if (g.size() == s.size()) {
    ng = g;
  }
  else {
    set<string>::const_iterator it = s.begin();
    for (; it != s.end(); it++) {
      const string & v = *it;
      ng[v] = g.at(v);
      vector<string> & vec = ng[v];
      int i, j;
      for (i = vec.size() - 1, j = i; i >= 0; i--) {
        if (!s.count(vec[i])) {
          if (i != j)
            swap(vec[i], vec[j]);
          j--;
        }
      }
      vec.resize(j + 1);
    }
  }
  return ng;
}

//get max connected subgraphs from g
vector<Graph> conn_graphs(const Graph & g) {
  vector<Graph> gs;
  set<string> visited;
  Graph::const_iterator it = g.begin();
  while (visited.size() != g.size()) {
    string v;
    for (; it != g.end(); it++) {
      if (!visited.count(it->first)) {
        v = it->first;
        break;
      }
    }
    set<string> accessed;
    visit(g, v, accessed);
    gs.push_back(subgraph(g, accessed));
    visited.insert(accessed.begin(), accessed.end());
  }
  return gs;
}

vector<string> cameras(const Graph & g) {
  vector<string> r;
  vector<Graph> gs = conn_graphs(g);
  for (int i = 0; i < gs.size(); i++) {
    Graph & g = gs[i];
    Graph::iterator it = g.begin();
    for (; it != g.end(); it++) {
      Graph ng = remove(g, it->first);
      if (ng.size() > 1 && !connected(ng))
        r.push_back(it->first);
    }
  }
  sort(r.begin(), r.end());
  return r;
}

int main() {
  int c = 0;
  int n = 0;
  while ((cin >> n) && n) {
    c++;
    Graph g;
    int i;
    for (i = 0; i < n; i++) {
      string v;
      cin >> v;
      g[v] = vector<string>();
    }
    int r = 0;
    cin >> r;
    for (i = 0; i < r; i++) {
      string u, v;
      cin >> u >> v;
      g[u].push_back(v);
      g[v].push_back(u);
    }
    vector<string> cams = cameras(g);
    if (c != 1)
      cout << endl;
    cout << "City map #" << c << ": " << cams.size() << " camera(s) found" << endl;
    for (i = 0; i < cams.size(); i++) {
      cout << cams[i] << endl;
    }
  }
  return 0;
}
```

