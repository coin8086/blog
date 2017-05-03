---
title: Self-describing Sequence
date: 2013-06-21T18:15:34+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110607/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=34&#038;page=show_problem&#038;problem=990" target="_blank">10049</a>

分析：由于n的值可达20亿，所以把f(n)的值记录在数组里是不现实的，因此通过递推式计算f(n)也是不现实的，何况f(n)的递推式也很难得出。假设s(n)为数列f(n)的前n项和，则由数列性质可知：<!--more-->


  
f(s(n)) = n
  
这是因为f(n)的前s(n)项依次是：
  
f(1)个1、f(2)个2、……、f(n)个n
  
最后一项是n（再往后一项就是n+1了），因此又有：
  
f(s(n-1)) = n &#8211; 1
  
即：当x在区间(s(n-1), s(n)]时，f(x) = n。可以据此来求得f(x)：我们可以把s(n)的值记录在数组里，通过比较来确定x所属的区间——s(n)所组成的数列元素数量大致在几万的数量级（这可以由sample给出的一组数据来佐证：n = 1000000000, f(n) = 438744），因此记录s(n)是可以实现的。还有一个好消息就是此题不需要高精度整数运算了！

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

vector&lt;int&gt; F;
vector&lt;int&gt; S; //Sum of first n items from F
int k; //Pointer to item in F

inline void init() {
  F.reserve(50000);
  F.push_back(0);
  F.push_back(1);
  F.push_back(2);
  F.push_back(2);
  k = 2;
  S.push_back(0);
  S.push_back(1);
  S.push_back(3);
  S.push_back(5);
}

inline int f(int n) {
  int r;
  if (F.size() &gt; n) {
    r = F[n];
  }
  else {
    while (S.back() &lt; n) {
      //Add f(k) occurences of k to F, and save the sum of first n items
      int c = F[++k];
      int s = S.back();
      for (int i = 0; i &lt; c; i++) {
        F.push_back(k);
        s += k;
        S.push_back(s);
      }
    }
    for (r = S.size() - 1; r &gt;= 0; r--) {
      if (n &gt; S[r - 1] && n &lt;= S[r])
        break;
    }
  }
  return r;
}

int main() {
  init();
  int n;
  while ((cin &gt;&gt; n) && n &gt; 0) {
    cout &lt;&lt; f(n) &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_43">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Fself-describing-sequence%2F&linkname=Self-describing%20Sequence" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Fself-describing-sequence%2F&linkname=Self-describing%20Sequence" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Fself-describing-sequence%2F&linkname=Self-describing%20Sequence" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F21%2Fself-describing-sequence%2F&linkname=Self-describing%20Sequence" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>