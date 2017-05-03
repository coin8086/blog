---
title: Tourist Guide
date: 2013-06-03T22:58:06+00:00
layout: post
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 111006/10199 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;category=38&#038;problem=1140&#038;mosmsg=Submission+received+with+ID+11854360" target="_blank">题目表述</a>

分析：此题是图的连通性问题。摄像头都位于图的关节点（articulation point）上。判断点v是否是关节点的简单办法是把v及其附着边从图中删去，然后用dfs或bfs检验图是否连通，若不连通则v是关节点。对图中的点依次做判断即可得出摄像头位置。<!--more-->需要注意的是：输入的图可能是不连通的，须要把它拆成若干最大连通子图，然后再找出每个子图中的关节点。笔者不得不说，这是一个大坑。


  
另外，寻找关节点还有效率更高的办法：可以通过一次dfs找出图的所有关节点，实现稍复杂。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;map&gt;
#include &lt;set&gt;
#include &lt;string&gt;
#include &lt;queue&gt;
#include &lt;algorithm&gt;

using namespace std;

typedef map&lt;string, vector&lt;string&gt; &gt; Graph;

//remove a vertex v in g to get a new graph
Graph remove(const Graph & g, const string & v) {
  Graph ng = g;
  ng.erase(v);
  Graph::iterator it = ng.begin();
  for (; it != ng.end(); it++) {
    vector&lt;string&gt; & vec = it-&gt;second;
    int size = vec.size();
    for (int i = 0; i &lt; size; i++) {
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
void visit(const Graph & g, const string & v, set&lt;string&gt; & visited) {
  queue&lt;string&gt; q;
  visited.insert(v);
  q.push(v);
  while (!q.empty()) {
    const string & u = q.front();
    const vector&lt;string&gt; & vec = g.at(u);
    for (int i = 0; i &lt; vec.size(); i++) {
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
  set&lt;string&gt; visited;
  visit(g, g.begin()-&gt;first, visited);
  return visited.size() == g.size();
}

//get a subgraph from g, with only vertexes in s
Graph subgraph(const Graph & g, const set&lt;string&gt; & s) {
  Graph ng;
  if (g.size() == s.size()) {
    ng = g;
  }
  else {
    set&lt;string&gt;::const_iterator it = s.begin();
    for (; it != s.end(); it++) {
      const string & v = *it;
      ng[v] = g.at(v);
      vector&lt;string&gt; & vec = ng[v];
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
  set&lt;string&gt; visited;
  Graph::const_iterator it = g.begin();
  while (visited.size() != g.size()) {
    string v;
    for (; it != g.end(); it++) {
      if (!visited.count(it-&gt;first)) {
        v = it-&gt;first;
        break;
      }
    }
    set&lt;string&gt; accessed;
    visit(g, v, accessed);
    gs.push_back(subgraph(g, accessed));
    visited.insert(accessed.begin(), accessed.end());
  }
  return gs;
}

vector&lt;string&gt; cameras(const Graph & g) {
  vector&lt;string&gt; r;
  vector&lt;Graph&gt; gs = conn_graphs(g);
  for (int i = 0; i &lt; gs.size(); i++) {
    Graph & g = gs[i];
    Graph::iterator it = g.begin();
    for (; it != g.end(); it++) {
      Graph ng = remove(g, it-&gt;first);
      if (ng.size() &gt; 1 && !connected(ng))
        r.push_back(it-&gt;first);
    }
  }
  sort(r.begin(), r.end());
  return r;
}

int main() {
  int c = 0;
  int n = 0;
  while ((cin &gt;&gt; n) && n) {
    c++;
    Graph g;
    int i;
    for (i = 0; i &lt; n; i++) {
      string v;
      cin &gt;&gt; v;
      g[v] = vector&lt;string&gt;();
    }
    int r = 0;
    cin &gt;&gt; r;
    for (i = 0; i &lt; r; i++) {
      string u, v;
      cin &gt;&gt; u &gt;&gt; v;
      g[u].push_back(v);
      g[v].push_back(u);
    }
    vector&lt;string&gt; cams = cameras(g);
    if (c != 1)
      cout &lt;&lt; endl;
    cout &lt;&lt; "City map #" &lt;&lt; c &lt;&lt; ": " &lt;&lt; cams.size() &lt;&lt; " camera(s) found" &lt;&lt; endl;
    for (i = 0; i &lt; cams.size(); i++) {
      cout &lt;&lt; cams[i] &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_29">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F03%2Ftourist-guide%2F&linkname=Tourist%20Guide" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F03%2Ftourist-guide%2F&linkname=Tourist%20Guide" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F03%2Ftourist-guide%2F&linkname=Tourist%20Guide" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F03%2Ftourist-guide%2F&linkname=Tourist%20Guide" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>