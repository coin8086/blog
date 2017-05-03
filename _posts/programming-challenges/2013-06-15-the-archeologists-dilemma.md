---
title: The Archeologist’s Dilemma
date: 2013-06-15T11:35:17+00:00
layout: post
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110503/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=642" target="_blank">701</a>

分析：5.4节《进制及其转换》提到：把一个a进制整数x转化成b进制整数y的“自左向右”方法是：首先求出y的最高位dl
  
(dl + 1) \* b ^ k > x >= dl \* b ^ k
  
在本题中令x = 2 ^ e，已知十进制y的高n位，则有：
  
(dl + 1) \* 10 ^ k > 2 ^ e > dl \* 10 ^ k
  
其中<!--more-->


  
k + 1 > 2n
  
因为要满足“已知的位数n严格少于丢失的位数”。我们可以从k = 2n开始尝试求以上不等式的整数解e，但e仍需满足：
  
(d(l &#8211; 1) + 1) \* 10 ^ (k &#8211; 1) > (2 ^ e &#8211; dl \* 10 ^ k) >= d(l &#8211; 1) * 10 ^ (k &#8211; 1)
  
及d(l &#8211; 2)&#8230;直到d(1)的一系列不等式。所有n位都满足的整数e即正解。但还有一个问题：什么时候不存在解？笔者无法证明解始终存在，有线索的读者或可给出。
  
另外，还有一个比较简单的实现方法：根据公式
  
N * 10 ^ k < 2 ^ e < (N + 1) * 10 ^ k
  
其中N为已知的10进制数（即y的高n位），可以实现比较简单的验算，<a href="http://blog.csdn.net/metaphysis/article/details/6453199" target="_blank">例如这样</a>；但根据UVa的测试结果，笔者的实现大概比后者快40%左右。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;cmath&gt;

#define MAX_SIZE 10

long double LOG2 = log(2);
long double LOG2_10 = log(10) / LOG2;

using namespace std;

inline vector&lt;char&gt; to_vec(unsigned int n) {
  vector&lt;char&gt; v;
  v.reserve(MAX_SIZE);
  while (n) {
    v.push_back(n % 10);
    n /= 10;
  }
  return v;
}

unsigned int power_of_2(unsigned int n) {
  unsigned int e = 0;
  vector&lt;char&gt; v = to_vec(n);
  int dl = v.back();    //The highest digit.
  int k = 2 * v.size(); //dl * 10 ^ k
  long double log2_dl = log(dl) / LOG2;
  long double log2_dl_plus = log(dl + 1) / LOG2;
  long double k_log2_10 = k * LOG2_10;
  while (true) {
    //(dl + 1) * 10 ^ k &gt; 2 ^ e &gt;= dl * 10 ^ k
    e = ceil(log2_dl + k_log2_10);
    if (e &lt; log2_dl_plus + k_log2_10) {
      //The next digit, dm, if it exists, must satisfy
      //(dm + 1) * 10 ^ (k - 1) &gt; (2 ^ e - (dl * 10 ^ k)) &gt;= dm * 10 ^ (k - 1)
      //And the next next digit repeats this pattern.
      unsigned int s = dl;
      long double m_log2_10 = k_log2_10;
      int i = v.size() - 2;
      for (; i &gt;= 0; i--) {
        s *= 10;
        s += v[i];
        m_log2_10 -= LOG2_10;
        if (e &lt; log(s) / LOG2 + m_log2_10 || e &gt;= log(s + 1) / LOG2 + m_log2_10)
          break;
      }
      if (i &lt; 0)
        break;
    }
    k_log2_10 += LOG2_10;
  }
  return e;
}

int main() {
  unsigned int n;
  while (cin &gt;&gt; n) {
    cout &lt;&lt; power_of_2(n) &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_35">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-archeologists-dilemma%2F&linkname=The%20Archeologist%E2%80%99s%20Dilemma" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-archeologists-dilemma%2F&linkname=The%20Archeologist%E2%80%99s%20Dilemma" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-archeologists-dilemma%2F&linkname=The%20Archeologist%E2%80%99s%20Dilemma" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-archeologists-dilemma%2F&linkname=The%20Archeologist%E2%80%99s%20Dilemma" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>