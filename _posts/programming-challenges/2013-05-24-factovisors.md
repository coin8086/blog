---
id: 476
title: Factovisors
date: 2013-05-24T16:51:46+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=155
permalink: /2013/05/24/factovisors/
categories:
  - 编程挑战
---
<a href="http://www.programming-challenges.com/pg.php?page=downloadproblem&probid=110704&format=html" target="_blank">题目描述</a>

分析：若m是合数，把m分解为质因数的乘积
  
m=(p1^k1)(p2^k2)&#8230;(pi^ki)
  
对于m的每一个质因数pi，若其次数ki都不大于n!里pi的最大次数Ki，则m可以整除n!，反之则不能。
  
若m是质数，只要m不大于n即可整除n!；若m等于1，m可以整除任何n!。<!--more-->


  
另外：programming-challenges.com对本答案判定为正确，但UVa却判错。笔者仔细检查了算法和实现，没有发现问题。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;utility&gt;
#include &lt;cmath&gt;

using namespace std;

typedef unsigned int uint;
typedef vector&lt;pair&lt;uint, uint&gt; &gt; PVec;

PVec prime_factors(uint m) {
  PVec r;
  uint i = 2;
  uint c = 0;
  while (m % i == 0) {
    m /= i;
    c++;
  }
  if (c)
    r.push_back(make_pair(i, c));
  i = 3;
  while (i &lt;= sqrt(m) + 1) {
    c = 0;
    while (m % i == 0) {
      m /= i;
      c++;
    }
    if (c)
      r.push_back(make_pair(i, c));
    i += 2;
  }
  return r;
}

bool divisible(uint n, uint m) {
  if (m &lt; 2) {
    return m ? true : false;
  }
  bool r = true;
  PVec factors = prime_factors(m);
  if (factors.empty()) {
    if (n &lt; m)
      r = false;
  }
  else {
    for (int i = 0; i &lt; factors.size(); i++) {
      uint p = factors[i].first;
      uint c = factors[i].second;
      uint count = 0;
      uint np;
      uint t = n;
      while ((np = t / p) &gt; 0) {
        count += np;
        if (count &gt;= c)
          break;
        t = np;
      }
      if (count &lt; c) {
        r = false;
        break;
      }
    }
  }
  return r;
}

int main() {
  uint n, m;
  while (cin &gt;&gt; n &gt;&gt; m) {
    if (divisible(n, m)) {
      cout &lt;&lt; m &lt;&lt; " divides " &lt;&lt; n &lt;&lt; "!" &lt;&lt; endl;
    }
    else {
      cout &lt;&lt; m &lt;&lt; " does not divide " &lt;&lt; n &lt;&lt; "!" &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_21">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Ffactovisors%2F&linkname=Factovisors" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Ffactovisors%2F&linkname=Factovisors" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Ffactovisors%2F&linkname=Factovisors" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F24%2Ffactovisors%2F&linkname=Factovisors" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>