---
title: Jolly Jumper
date: 2013-04-20T17:30:31+00:00
layout: post
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa 题号：110201/10038　<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=30&page=show_problem&problem=979" target="_blank">题目描述</a><!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

typedef long long ll_t;

bool load_input(vector&lt;ll_t&gt; & s) {
  s.clear();
  int n;
  if (!(cin &gt;&gt; n))
    return false;
  for (int i = 0; i &lt; n; i++) {
    ll_t k;
    if (!(cin &gt;&gt; k))
      return false;
    s.push_back(k);
  }
  return true;
}

bool jolly(const vector&lt;ll_t&gt; & s) {
  int n = s.size();
  if (n &lt;= 1)
    return true;
  vector&lt;bool&gt; r(n, false);
  for (int i = 0; i &lt; n - 1; i++) {
    ll_t d = s[i] - s[i + 1];
    if (d &lt; 0)
      d *= -1;
    if (d &gt; n - 1 || d &lt; 1 || r[d])
      return false;
    r[d] = true;
  }
  return true;
}

int main() {
  vector&lt;ll_t&gt; s;
  while (load_input(s)) {
    if (jolly(s)) {
      cout &lt;&lt; "Jolly" &lt;&lt; endl;
    }
    else {
      cout &lt;&lt; "Not jolly" &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_5">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F20%2Fjolly-jumper%2F&linkname=Jolly%20Jumper" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F20%2Fjolly-jumper%2F&linkname=Jolly%20Jumper" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F20%2Fjolly-jumper%2F&linkname=Jolly%20Jumper" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F04%2F20%2Fjolly-jumper%2F&linkname=Jolly%20Jumper" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>