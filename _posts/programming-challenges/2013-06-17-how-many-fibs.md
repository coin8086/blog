---
title: How Many Fibs?
date: 2013-06-17T00:25:37+00:00
layout: post
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110601/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1124" target="_blank">10183</a>

分析：6.4节《其他计数序列》里给出了Fibonacci数列的封闭形式，提示里也说“能否借助封闭形式来避免高精度算数”，但高精度算数还是无法避免。理由如下：<!--more-->


  
F(n) = (a ^ n &#8211; b ^ n) / c
  
其中a，b，c为常数：
  
a = (1 + 5 ^ (1 / 2)) / 2
  
b = (1 &#8211; 5 ^ (1 / 2)) / 2
  
c = 5 ^ (1 / 2)
  
因为abs(b) < 1，所以当n比较大时可以忽略b ^ n，直接用：
  
(a ^ n) / c
  
来估计F(n)，误差在正负1之间。
  
另一方面，当输入数字比较大时，如10 ^ 100，即使用80位的long double（其中精度可达64位），也不能精确表示它，更不要说区分正负1的误差了。
  
综上，高精度算数是唯一选择。当然这对C/C++比较痛苦，因为没有现成的标准库可以用。以下“<a href="https://code.google.com/p/programming-challenges-robert/source/browse/bigint.h" target="_blank">bigint.h</a>”为笔者自创。
  
解法：根据输入范围先算好一个Fibonaaci数列的子序列，然后对输入的数在该序列中进行二分查找。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include "bigint.h"

using namespace std;

vector&lt;BigInt&gt; fib;

void init() {
  fib.reserve(501);
  fib.push_back(0);
  fib.push_back(1);
  fib.push_back(2);
  for (int i = 0; i &lt; 498; i++) {
    int l = fib.size() - 1;
    fib.push_back(fib[l] + fib[l - 1]);
  }
}

int bsearch(const BigInt & v, int s/* start */, int e/* end */) {
  int i;
  int mid = (s + e) / 2;
  int r = v.compare(fib[mid]);
  if (!r) {
    i = mid;
  }
  else if (r &lt; 0) {
    if (s == mid)
      i = s - 1;
    else
      i = bsearch(v, s, mid);
  }
  else {
    if (e == mid + 1)
      i = mid;
    else
      i = bsearch(v, mid + 1, e);
  }
  return i;
}

inline int fibs(const BigInt & a) {
  return a.zero() ? 0 : bsearch(a, 0, fib.size());
}

inline int fibs(const BigInt & a, const BigInt & b) {
  return a.zero() ? fibs(b) : fibs(b) - fibs(a - 1);
}

int main() {
  init();
  BigInt a, b;
  while (cin &gt;&gt; a &gt;&gt; b && !(a.zero() && b.zero())) {
    cout &lt;&lt; fibs(a, b) &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_39">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F17%2Fhow-many-fibs%2F&linkname=How%20Many%20Fibs%3F" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F17%2Fhow-many-fibs%2F&linkname=How%20Many%20Fibs%3F" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F17%2Fhow-many-fibs%2F&linkname=How%20Many%20Fibs%3F" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F17%2Fhow-many-fibs%2F&linkname=How%20Many%20Fibs%3F" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>