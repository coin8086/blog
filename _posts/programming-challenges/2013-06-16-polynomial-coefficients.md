---
id: 493
title: Polynomial Coefficients
date: 2013-06-16T13:15:28+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=293
permalink: /2013/06/16/polynomial-coefficients/
category_sticky_post:
  - "0"
categories:
  - 编程挑战
---
PC/UVa IDs: 110506/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1046" target="_blank">10105</a>

分析：考虑二项式
  
(x1 + x2) ^ n
  
其中
  
x1 ^ m * x2 ^ (n &#8211; m)
  
项的系数是组合数
  
C(n, m)
  
多项式
  
(x1 + x2 + &#8230; + xk) ^ n
  
可以记为
  
((x1 + x2 + &#8230; + x(k &#8211; 1)) + xk) ^ n <!--more-->


  
其中
  
(x1 + x2 + &#8230; + x(k -1)) ^ (n &#8211; nk) * xk ^ nk
  
项的系数是
  
C(n, nk) * f(n &#8211; nk, k &#8211; 1)
  
其中f(n, k)即n次k项式中
  
x1 ^ n1 \* x2 ^ n2 \* &#8230; \* xk \* nk
  
项的系数。
  
由此得到递归解法：

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

#define MAX 12

using namespace std;

vector&lt;int&gt; fact;

inline void init() {
  fact.resize(MAX + 1);
  fact[0] = 1;
  for (int i = 1; i &lt; fact.size(); i++) {
    fact[i] = fact[i - 1] * i;
  }
}

inline int combination(int n, int m) {
  return fact[n] / (fact[n - m] * fact[m]);
}

int coefficient(int n, vector&lt;int&gt; & e) {
  int r;
  if (e.size() == 1) {
    r = 1;
  }
  else if (e.size() == 2) {
    r = combination(n, e[0]);
  }
  else {
    int last = e.back();
    int c = combination(n, last);
    e.pop_back();
    r = coefficient(n - last, e) * c;
  }
  return r;
}

int main() {
  init();
  int n, k;
  while (cin &gt;&gt; n &gt;&gt; k) {
    vector&lt;int&gt; e;
    e.reserve(k);
    for (int i = 0; i &lt; k; i++) {
      int c;
      cin &gt;&gt; c;
      e.push_back(c);
    }
    cout &lt;&lt; coefficient(n, e) &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_38">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F16%2Fpolynomial-coefficients%2F&linkname=Polynomial%20Coefficients" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F16%2Fpolynomial-coefficients%2F&linkname=Polynomial%20Coefficients" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F16%2Fpolynomial-coefficients%2F&linkname=Polynomial%20Coefficients" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F16%2Fpolynomial-coefficients%2F&linkname=Polynomial%20Coefficients" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>