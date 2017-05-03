---
title: Smith Numbers
date: 2013-06-23T11:29:54+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110706/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=983" target="_blank">10042</a>

分析：分解质因数，求各位数字之和。如果担心当n等于10亿时，Smith数的计算会使unsigned int溢出，可以先试算一下——其实不小于10亿的最小Smith数是1000000165，不算大。<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;cmath&gt;
#include &lt;climits&gt;

using namespace std;

typedef unsigned int uint;

//For a prime number, the return value is empty.
inline vector&lt;uint&gt; prime_factors(uint n) {
  vector&lt;uint&gt; f;
  if (n &gt; 2) {
    uint o = n;
    f.reserve(8);
    while (n % 2 == 0) {
      f.push_back(2);
      n /= 2;
    }
    uint p = 3;
    double rt = sqrt(n);
    while (p &lt; rt + 1) {
      if (n % p == 0) {
        f.push_back(p);
        n /= p;
        while (n % p == 0) {
          f.push_back(p);
          n /= p;
        }
        rt = sqrt(n);
      }
      p += 2;
    }
    if (n &gt; 1 && o != n)
      f.push_back(n);
  }
  return f;
}

inline uint sum_of_digits(uint n) {
  uint s = 0;
  while (n) {
    s += n % 10;
    n /= 10;
  }
  return s;
}

inline bool is_smith(uint n) {
  bool r = false;
  vector&lt;uint&gt; f = prime_factors(n);
  if (!f.empty()) {
    uint sf = 0;
    for (uint i = 0; i &lt; f.size(); i++) {
      sf += sum_of_digits(f[i]);
    }
    r = sum_of_digits(n) == sf;
  }
  return r;
}

inline uint smith(uint n) {
  uint i = n + 1;
  for (; i &lt; UINT_MAX; i++) {
    if (is_smith(i))
      break;
  }
  return i &lt; INT_MAX ? i : 0;
}

int main() {
  uint t;
  cin &gt;&gt; t;
  for (uint i = 0; i &lt; t; i++) {
    uint n;
    cin &gt;&gt; n;
    cout &lt;&lt; smith(n) &lt;&lt; endl;
  }
  return 0;
}
</pre>

