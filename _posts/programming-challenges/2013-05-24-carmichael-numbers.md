---
title: Carmichael Numbers
date: 2013-05-24T21:37:16+00:00
layout: post
categories:
  - 编程挑战
---
PC/UVa IDs: 110702/10006 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=947" target="_blank">题目描述</a>

分析：只要注意到当n为偶数时
  
(a^n) mod n = (((a^(n/2)) mod n)*((a^(n/2)) mod n)) mod n
  
当n为奇数时
  
(a^n) mod n = (((a^(n/2)) mod n)\*((a^(n/2)) mod n)\*a) mod n
  
则(a^n) mod n运算可在O(log(n))的时间内完成。<!--more-->


  
另外：本答案会导致超时（TLE），优化的方案是：先把65000以内的所有Carmichael数计算出来！其实不过区区十几个数而已。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;cmath&gt;

using namespace std;

typedef unsigned int uint;

bool prime(uint n) {
  if (n % 2 == 0)
    return false;
  uint i = 3;
  uint h = sqrt(n) + 1;
  while (i &lt;= h) {
    if (n % i == 0)
      return false;
    i += 2;
  }
  return true;
}

uint mod(uint a, uint n, uint m) {
  if (n == 1)
    return a;
  uint x = mod(a, n / 2, m);
  x = (x * x) % m;
  if (n % 2)
    x = (x * a) % m;
  return x;
}

bool carm(uint n) {
  bool r = true;
  for (int i = 2; i &lt; n; i++) {
    if (mod(i, n, n) != i) {
      r = false;
      break;
    }
  }
  if (r && prime(n))
    r = false;
  return r;
}

int main() {
  uint n;
  while (cin &gt;&gt; n && n) {
    if (carm(n))
      cout &lt;&lt; "The number " &lt;&lt; n &lt;&lt; " is a Carmichael number." &lt;&lt; endl;
    else
      cout &lt;&lt; n &lt;&lt; " is normal." &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_22">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Fcarmichael-numbers%2F&linkname=Carmichael%20Numbers" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Fcarmichael-numbers%2F&linkname=Carmichael%20Numbers" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Fcarmichael-numbers%2F&linkname=Carmichael%20Numbers" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Fcarmichael-numbers%2F&linkname=Carmichael%20Numbers" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>