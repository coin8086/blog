---
title: The Tourist Guide
date: 2013-05-30T21:28:52+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110903/10099 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=37&#038;page=show_problem&#038;problem=1040" target="_blank">题目描述</a>

分析：假设从起点s到终点d的路径是a1->a2->..->an，这条路径上容量（权值）最小的边的权值为p，则p即为这条路径的最大容量。在所有s到d的路径中，我们要找出容量最大的一条，设其容量为P。则往返次数n可由
  
n * P >= T + n
  
得到
  
n = ceil(T / (n &#8211; 1))
  
关键是怎样找出P。简单的想法是用回溯法枚举出从s到d的所有路径、找出容量最大的一条，但这样会TLE！<!--more-->


  
笔者的思路是：从s开始广度优先遍历图：假设从s到点v的路径最大容量是pv(记为cap[v]=pv)，从v到它的某个邻接点v2的边容量为pv2，若v2尚未经由其它节点被访问，则从s到v2的最大容量是min(pv, pv2)；若v2已经经由其它节点被访问，并计算得出了cap[v2]，如果cap[v2]小于min(pv, pv2)，更新cap[v2]为min(pv, pv2)；在以上两种情况下，都把v2 push到待访问队列中。当遍历结束后，数组cap包含从s到任意一个节点的最大容量。
  
另外：本题也可以运用Floyd递归求解任意点对间最短路线的思想来解，<a href="http://aduni.org/courses/algorithms/courseware/handouts/Reciation_07.html#25504" target="_blank">参考这里</a>。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;queue&gt;
#include &lt;utility&gt;
#include &lt;algorithm&gt;
#include &lt;climits&gt;
#include &lt;cmath&gt;

using namespace std;

typedef vector&lt;vector&lt;pair&lt;int, int&gt; &gt; &gt; Graph;

int trips(const Graph & g, int src, int dest, int t) {
  queue&lt;int&gt; q;
  vector&lt;int&gt; cap(g.size());
  cap[src] = INT_MAX;
  q.push(src);
  while (!q.empty()) {
    int v = q.front();
    int c = cap[v];
    q.pop();
    for (int i = 0; i &lt; g[v].size(); i++) {
      int v2 = g[v][i].first;
      int c2 = g[v][i].second;
      int m = min(c, c2);
      if (cap[v2] &lt; m) {
        cap[v2] = m;
        q.push(v2);
      }
    }
  }
  return ceil(1.0 * t / (cap[dest] - 1));
}

int main() {
  int nv, ne;
  int count = 0;
  while ((cin &gt;&gt; nv &gt;&gt; ne) && nv) {
    Graph g(nv + 1);
    for (int i = 0; i &lt; ne; i++) {
      int v1, v2, p;
      cin &gt;&gt; v1 &gt;&gt; v2 &gt;&gt; p;
      g[v1].push_back(make_pair(v2, p));
      g[v2].push_back(make_pair(v1, p));
    }
    int s, d, t;
    cin &gt;&gt; s &gt;&gt; d &gt;&gt; t;
    cout &lt;&lt; "Scenario #" &lt;&lt; ++count &lt;&lt; endl;
    cout &lt;&lt; "Minimum Number of Trips = " &lt;&lt; trips(g, s, d, t) &lt;&lt; endl;
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

