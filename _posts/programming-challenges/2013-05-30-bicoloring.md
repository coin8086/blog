---
title: Bicoloring
date: 2013-05-30T20:59:49+00:00
layout: post
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

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_24">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F30%2Fbicoloring%2F&linkname=Bicoloring" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F30%2Fbicoloring%2F&linkname=Bicoloring" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F30%2Fbicoloring%2F&linkname=Bicoloring" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F30%2Fbicoloring%2F&linkname=Bicoloring" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>