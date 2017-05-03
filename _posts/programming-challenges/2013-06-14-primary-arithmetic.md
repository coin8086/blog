---
title: Primary Arithmetic
date: 2013-06-14T12:37:23+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110501/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=976" target="_blank">10035</a>

<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

#define MAX_SIZE 10

using namespace std;

inline vector&lt;char&gt; to_vec(int n) {
  vector&lt;char&gt; v;
  v.reserve(MAX_SIZE);
  while (n) {
    v.push_back(n % 10);
    n /= 10;
  }
  return v;
}

int carry_times(int n, int m) {
  if (!n || !m)
    return 0;
  vector&lt;char&gt; bn = to_vec(n);
  vector&lt;char&gt; bm = to_vec(m);
  int carry = 0;
  int times = 0;
  int size = n &gt;= m ? bn.size() : bm.size();
  bn.resize(size);
  bm.resize(size);
  for (int i = 0; i &lt; size; i++) {
    int s = carry + bn[i] + bm[i];
    if (s &gt; 9) {
      carry = 1;
      times++;
    }
    else {
      carry = 0;
    }
  }
  return times;
}

int main() {
  int n, m;
  while ((cin &gt;&gt; n &gt;&gt; m) && (n || m)) {
    int t = carry_times(n, m);
    if (!t)
      cout &lt;&lt; "No carry operation.";
    else if (t == 1)
      cout &lt;&lt; "1 carry operation.";
    else
      cout &lt;&lt; t &lt;&lt; " carry operations.";
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_33">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Fprimary-arithmetic%2F&linkname=Primary%20Arithmetic" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Fprimary-arithmetic%2F&linkname=Primary%20Arithmetic" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Fprimary-arithmetic%2F&linkname=Primary%20Arithmetic" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Fprimary-arithmetic%2F&linkname=Primary%20Arithmetic" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>