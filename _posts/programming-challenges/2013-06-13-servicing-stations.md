---
title: Servicing Stations
date: 2013-06-13T00:14:25+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110804/10160 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1101" target="_blank">题目描述</a>

分析：此题不难，但特别容易超时！——这正是困难之处：有n个元素的集合的子集共有2^n个，枚举算法的时间复杂度在O(2^n)，且本题除枚举外别无他法（NP完全），因此必须尽一切可能性优化，着力在降低计算中n的值（以下1、2项优化）。关键的优化有以下几点（按重要性排列）：
  
１输入的图可能是非连通图，把它分解成若干最大连通子图分别计算
  
２对于顶点数大于二的连通图，服务站只考虑建在度数大于一的点上即可
  
３使用类似迭代加深的方式来枚举可能的组合：先考虑一个点的组合，再考虑二个点的组合，然后三个，……<!--more-->


  
４使用位向量，即整数，来表示一个顶点和它的邻接顶点，用位运算来加速计算

特别感谢“寂静山林”给出的<a href="http://blog.csdn.net/metaphysis/article/details/6601365" target="_blank">优化提示</a>。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;map&gt;
#include &lt;set&gt;
#include &lt;queue&gt;
#include &lt;algorithm&gt;
#include &lt;climits&gt;

#define MAX_TOWNS 35

using namespace std;

typedef map&lt;int, vector&lt;int&gt; &gt; Graph;
typedef long long llt;

//bfs g from vertex v and record visited vertexes in visited
void visit(const Graph & g, int v, set&lt;int&gt; & visited) {
  queue&lt;int&gt; q;
  visited.insert(v);
  q.push(v);
  while (!q.empty()) {
    int u = q.front();
    const vector&lt;int&gt; & vec = g.at(u);
    for (int i = 0; i &lt; vec.size(); i++) {
      if (!visited.count(vec[i])) {
        visited.insert(vec[i]);
        q.push(vec[i]);
      }
    }
    q.pop();
  }
}

//get a subgraph from g, with only vertexes in s
Graph subgraph(const Graph & g, const set&lt;int&gt; & s) {
  Graph ng;
  if (g.size() == s.size()) {
    ng = g;
  }
  else {
    set&lt;int&gt;::const_iterator it = s.begin();
    for (; it != s.end(); it++) {
      int v = *it;
      ng[v] = g.at(v);
      vector&lt;int&gt; & vec = ng[v];
      int i, j;
      for (i = vec.size() - 1, j = i; i &gt;= 0; i--) {
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
vector&lt;Graph&gt; conn_graphs(const Graph & g) {
  vector&lt;Graph&gt; gs;
  set&lt;int&gt; visited;
  Graph::const_iterator it = g.begin();
  while (visited.size() != g.size()) {
    int v;
    for (; it != g.end(); it++) {
      if (!visited.count(it-&gt;first)) {
        v = it-&gt;first;
        break;
      }
    }
    set&lt;int&gt; accessed;
    visit(g, v, accessed);
    gs.push_back(subgraph(g, accessed));
    visited.insert(accessed.begin(), accessed.end());
  }
  return gs;
}

inline vector&lt;int&gt; vertexes(const Graph & g) {
  vector&lt;int&gt; r;
  r.reserve(g.size());
  Graph::const_iterator it = g.begin();
  for (; it != g.end(); it++) {
    r.push_back(it-&gt;first);
  }
  return r;
}

inline llt vec_to_llt(const vector&lt;bool&gt; & vec) {
  llt r = 0;
  for (int i = vec.size() - 1; i &gt;= 0; i--) {
    r = r &lt;&lt; 1;
    if (vec[i])
      r |= 1;
  }
  return r;
}

inline llt to_llt(int n, const vector&lt;int&gt; & vec) {
  vector&lt;bool&gt; v(n);
  for (int i = 0; i &lt; n; i++) {
    if (find(vec.begin(), vec.end(), i) != vec.end()) {
      v[i] = true;
    }
  }
  return vec_to_llt(v);
}

template&lt;typename Success&gt;
bool combine(int total, int wanted, vector&lt;int&gt; & selected, Success & success)
{
  if (selected.size() == wanted) {
    return success(selected);
  }
  else {
    int idx = selected.size() ? selected.back() + 1 : 0;
    for (int i = idx; i &lt; total; i++) {
      selected.push_back(i);
      if (combine(total, wanted, selected, success))
        return true;
      selected.pop_back();
    }
  }
  return false;
}

class Checker {
public:
  Checker(const vector&lt;llt&gt; & towns, llt target) : _towns(towns), _target(target) {}

  bool operator ()(const vector&lt;int&gt; & selected) {
    llt t = 0;
    for (int i = 0; i &lt; selected.size(); i++) {
      t |= _towns[selected[i]];
    }
    return t == _target;
  }

private:
  const vector&lt;llt&gt; & _towns;
  llt _target;
};

int serv_station(const Graph & g) {
  int r = 0;
  //Split a graph into several connected subgraphs. This is A KEY OPTIMIZATION in speed.
  vector&lt;Graph&gt; gs = conn_graphs(g);
  for (int j = 0; j &lt; gs.size(); j++) {
    //Build towns vector, each dimension representing a town and its neighbours.
    vector&lt;llt&gt; towns;
    Graph::iterator it = gs[j].begin();
    for (; it != gs[j].end(); it++) {
      //In a connected graph with more than 2 vertexes, we select a vertex only
      //when it has a degree bigger than 1. This is A KEY OPTIMIZATION in speed.
      if (gs[j].size() &lt; 3 || it-&gt;second.size() &gt; 1) {
        it-&gt;second.push_back(it-&gt;first);
        towns.push_back(to_llt(g.size(), it-&gt;second));
      }
    }
    //The target represents all the towns in a max connected subgraph.
    llt target = to_llt(g.size(), vertexes(gs[j]));
    Checker checker(towns, target);
    //Select i towns from all to check if we make it. It's like an Iterative Deepening.
    int i;
    for (i = 1; i &lt;= gs[j].size(); i++) {
      vector&lt;int&gt; sel;
      if (combine(towns.size(), i, sel, checker))
        break;
    }
    r += i;
  }
  return r;
}

int main() {
  int n, m;
  while ((cin &gt;&gt; n &gt;&gt; m) && n && m) {
    Graph g;
    int i;
    for (i = 0; i &lt; n; i++) {
      g[i] = vector&lt;int&gt;();
    }
    for (i = 0; i &lt; m; i++) {
      int u, v;
      cin &gt;&gt; u &gt;&gt; v;
      u--, v--; //we start from 0
      g[u].push_back(v);
      g[v].push_back(u);
    }
    cout &lt;&lt; serv_station(g) &lt;&lt; endl;
  }
  return 0;
}
</pre>

