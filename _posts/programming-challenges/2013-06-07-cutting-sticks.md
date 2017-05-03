---
id: 485
title: Cutting Sticks
date: 2013-06-07T23:01:55+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=230
permalink: /2013/06/07/cutting-sticks/
categories:
  - 编程挑战
---
PC/UVa IDs: 111105/10003 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=39&#038;page=show_problem&#038;problem=944" target="_blank">题目描述</a>

分析：割点把木棍分成了若干区间，把这些区间从0到n编号，假设从区间i到j的最小代价为f(i, j)，则f(0, n)即整根木棍的代价。不妨在稿纸上推演一下，如何从f(0, 1)开始一步步计算得到f(0, 2)，f(0, 3)（以下设len(i, j)为区间i到j的长度）：
  
f(0, 1) = len(0, 1)
  
f(1, 2) = &#8230;
  
f(0, 2) = min(f(0, 1) + f(2, 2), f(0, 0) + f(1, 2)) + len(0, 2)
  
f(1, 3) = &#8230;
  
f(2, 3) = &#8230;
  
f(0, 3) = min(f(0, 2) + f(3, 3), f(0, 1) + f(2, 3), f(0, 0) + f(1, 3)) + len(0, 3)
  
可以归纳得到：<!--more-->


  
当i < j时：
  
f(i, j) = min(f(i, j - 1) + f(j, j), f(i, j - 2) + f(j - 1, j), ..., f(i, i) + f(i + 1, j)) + len(i, j)
  
当i == j时
  
f(i, j) = 0
  
如果用表格seg\[i\]\[j\]来存贮f(i, j)的值，即可以动态规划解之。但须注意单元格的计算顺序：从左至右，从下往上。只需计算i < j的格子，i = j的格子初始化为0。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;climits&gt;

using namespace std;

int cut(int l, const vector&lt;int&gt; & pos) {
  if (pos.size() &lt; 1)
    return pos.empty() ? 0 : l;
  //n cut positions divides one stick into n + 1 sections.
  //sec stores the beginning position of a section. To make it easy to calculate
  //a section length, sec stores the length of the stick as the begnning of a section
  //beyond the n + 1 real sections.
  vector&lt;int&gt; sec;
  sec.push_back(0);
  sec.insert(sec.end(), pos.begin(), pos.end());
  sec.push_back(l);
  int n = sec.size() &#8211; 1;
  vector&lt;vector&lt;int&gt; &gt; seg(n, vector&lt;int&gt;(n, 0));
  for (int j = 1; j &lt; n; j++) {
    for (int i = j &#8211; 1; i &gt;= 0; i&#8211;) {
      int s = 0;
      int m = INT_MAX;
      for (int k = 1; k &lt;= j &#8211; i; k++) {
        s = seg[i][j - k] + seg[j - k + 1][j];
        if (s &lt; m)
          m = s;
      }
      seg[i][j] = m + (sec[j + 1] &#8211; sec[i]); //m + the length of sections from i to j
    }
  }
  return seg[0][n - 1];
}

int main() {
  int l;
  while ((cin &gt;&gt; l) && l &gt; 0) {
    int n = 0;
    cin &gt;&gt; n;
    vector&lt;int&gt; pos;
    pos.reserve(n);
    for (int i = 0; i &lt; n; i++) {
      int p;
      cin &gt;&gt; p;
      pos.push_back(p);
    }
    cout &lt;&lt; "The minimum cutting is " &lt;&lt; cut(l, pos) &lt;&lt; "." &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_31">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fcutting-sticks%2F&linkname=Cutting%20Sticks" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fcutting-sticks%2F&linkname=Cutting%20Sticks" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fcutting-sticks%2F&linkname=Cutting%20Sticks" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F07%2Fcutting-sticks%2F&linkname=Cutting%20Sticks" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>