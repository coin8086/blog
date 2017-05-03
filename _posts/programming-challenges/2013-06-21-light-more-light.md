---
title: Light, More Light
date: 2013-06-21T23:57:45+00:00
layout: post
category_sticky_post:
  - "0"
categories:
  - 编程挑战
---
PC/UVa IDs: 110701/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1051" target="_blank">10110</a>

分析：最直接的想法是如下代码：

<pre class="brush: cpp; title: ; notranslate" title="">bool on = false;
for (int i = 1; i &lt;=n; i++)
  if (n % i == 0)
    on = !on
</pre>

但n最大可达数十亿，此法计算效率太低！那么能不能倒过来想：n可以被多少个不大于n的数整除？很容易给n分解质因数：<!--more-->


  
n = p1\*p2\*p3\*&#8230;\*pk
  
再用组合数学的办法求出这些质因数中的若干个相乘能得到多少个不同整数，是否可以解题？笔者相信理论上可以但是太过复杂。实际上我们不必知道有多少个不大于n的数能整除n，只要知道这些数，即n的因子，是奇数个还是偶数个即可：奇数亮灯，偶数灭灯。对于大于1的整数来说，可以用如下方法统计其因子数量的奇偶性：
  
假设整数n的平方根是实数r，则对于每个小于r的因子p，必有一个大于r的因子q，使得p * q = n；如果实数r不是整数，则n必有偶数个因子，否则为奇数个。
  
也就是说，当且仅当n为完全平方数时，灯亮。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;cmath&gt;

using namespace std;

typedef unsigned int uint;

inline bool light_on(uint n) {
  uint r = floor(sqrt((double)n));
  return r * r == n;
}

int main() {
  uint n = 0;
  while ((cin &gt;&gt; n) && n) {
    cout &lt;&lt; (light_on(n) ? "yes" : "no") &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_44">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Flight-more-light%2F&linkname=Light%2C%20More%20Light" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Flight-more-light%2F&linkname=Light%2C%20More%20Light" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Flight-more-light%2F&linkname=Light%2C%20More%20Light" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Flight-more-light%2F&linkname=Light%2C%20More%20Light" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>