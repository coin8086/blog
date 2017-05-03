---
title: The Priest Mathematician
date: 2013-06-21T11:06:32+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110606/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;category=34&#038;page=show_problem&#038;problem=1195" target="_blank">10254</a>

分析：这道题不简单，迄今为止我还没看到一个可以严谨地证明其正确性的程序——尽管答案本身是正确的。<!--more-->比如

<a href="http://blog.csdn.net/liukaipeng/article/details/3444016" target="_blank">这种</a>通过观察数列差得到的方法，虽然找出了启发性的递推公式，但不能据此给出归纳证明；又比如<a href="http://blog.csdn.net/liukaipeng/article/details/3444016" target="_blank">这种方法</a>，其证明所依赖的“数列差d(n)所形成的数列是非递减数列”也是没有得到证明的。笔者找到了一篇关于4柱汉诺塔的<a href="http://activity.ntsec.gov.tw/activity/race-1/44/E/040417.pdf" target="_blank">论文</a>——对这个问题进行了深入研究并给出了解的封闭形式。笔者自己最终没能给出一个AC的答案，以下解通过简单地比较找出k值，由于计算量过大而超时。但读者仍能利用此程序观察k或者差值的变化——来验证一些假设吧。
  
设h4(n)为在四根柱汉诺塔上把一个柱子的n个盘子搬到另一个指定柱子上所需的搬运次数（**按照牧师规则的最小次数**），h3(n)为在三根柱汉诺塔（即普通汉诺塔）上把一根柱子上的n个盘子搬到另一个柱子上的最小次数，则有：
  
h4(n) = h4(k) * 2 + h3(n &#8211; k)
  
h3(n) = 2 ^ n &#8211; 1
  
其中 0 <= k < n
  
由此可见当k=0时问题蜕化成3根柱普通汉诺塔问题，当n=10000时h4(n)有上界2 ^ 10000 - 1。高精度整数运算在此必不可少。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include "bigint.h"

using namespace std;

vector&lt;BigInt&gt; H;
vector&lt;BigInt&gt; P2;

void init() {
  H.reserve(10001);
  H.push_back(0);
  H.push_back(1);
  H.push_back(3);
  H.push_back(5);
  P2.reserve(10001);
  P2.push_back(1);
  P2.push_back(2);
  P2.push_back(4);
  P2.push_back(8);
}

inline BigInt p2(int n) {
  if (n &gt;= P2.size()) {
    for (int i = P2.size(); i &lt;= n; i++) {
      P2.push_back(P2.back() * 2);
    }
  }
  return P2[n];
}

inline BigInt h(int n, int k) {
  return H[k] * 2 + p2(n &#8211; k) &#8211; 1;
}

BigInt h(int n) {
  if (n &gt;= H.size()) {
    for (int i = H.size(); i &lt;= n; i++) {
      BigInt min = h(i, 1);
      //int mk = 1;
      for (int k = 2; k &lt; i; k++) {
        BigInt m = h(i, k);
        if (m &lt; min) {
          min = m;
          //mk = k;
        }
      }
      //clog &lt;&lt; "h(" &lt;&lt; i &lt;&lt; ", " &lt;&lt; mk &lt;&lt; ") = " &lt;&lt; min &lt;&lt; endl;
      H.push_back(min);
    }
  }
  return H[n];
}

int main() {
  init();
  int n;
  while (cin &gt;&gt; n) {
    cout &lt;&lt; h(n) &lt;&lt; endl;
  }
  return 0;
}
</pre>

