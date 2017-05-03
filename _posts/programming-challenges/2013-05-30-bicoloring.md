---
title: Bicoloring
date: 2013-05-30T20:59:49+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110901/10004 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=37&#038;page=show_problem&#038;problem=945" target="_blank">题目描述</a>

分析：对图做广度优先遍历，一边对节点v着色一边检查v是否与某个已着色的临接点同色。<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;queue&gt;

#define RED 1
#define BLACK (-1)

using namespace std;

typedef vector&lt;vector&lt;int&gt; &gt; Graph;

bool bicolorable(const Graph & g) {
  bool r = true;
  vector&lt;int&gt; color(g.size());
  queue&lt;int&gt; q;
  color[0] = RED;
  q.push(0);
  while (!q.empty()) {
    int v = q.front();
    int c = color[v];
    for (int i = 0; i &lt; g[v].size(); i++) {
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
  while ((cin &gt;&gt; nv) && nv) {
    Graph g(nv);
    int ne = 0;
    cin &gt;&gt; ne;
    for (int i = 0; i &lt; ne; i++) {
      int v1, v2;
      cin &gt;&gt; v1 &gt;&gt; v2;
      g[v1].push_back(v2);
      g[v2].push_back(v1);
    }
    if (bicolorable(g))
      cout &lt;&lt; "BICOLORABLE." &lt;&lt; endl;
    else
      cout &lt;&lt; "NOT BICOLORABLE." &lt;&lt; endl;
  }
  return 0;
}
</pre>

