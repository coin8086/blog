---
id: 500
title: Summation of Four Primes
date: 2013-06-22T20:55:26+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=336
permalink: /2013/06/22/summation-of-four-primes/
category_sticky_post:
  - "0"
categories:
  - 编程挑战
---
PC/UVa IDs: 110705/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1109" target="_blank">10168</a>

分析：试验表明：任何一个不小于8的整数都可以表示为四素数之和，且答案可能不唯一；另外，如果按照“从大到小”的顺序来找四个素数会比较快地找到解。因此有如下解：先用筛选质数法列出10000000以内的素数，然后用回溯法把一个整数n分解为四素数之和——在回溯时从不超过n的最大素数开始向前尝试。<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

#define MAX_N 10000000

using namespace std;

vector&lt;int&gt; primes;

void init() {
  vector&lt;bool&gt; removed(MAX_N + 1);
  primes.reserve(665000); //There are 664579 prime numbers within 10000000
  primes.push_back(2);
  int i = 3;
  for (; i &lt;= MAX_N; i += 2) {
    if (!removed[i]) {
      primes.push_back(i);
      int s = i + i;
      for (; s &lt;= MAX_N; s += i) {
        removed[s] = true;
      }
    }
  }
}

//The index of a prime p in primes array that is the biggest prime not bigger than n.
int index_of_prime(int n) {
  int r = -1;
  int i = 0;
  int j = primes.size();
  while (i != j) {
    int mid = (i + j) / 2;
    if (primes[mid] == n) {
      r = mid;
      break;
    }
    else if (primes[mid] &gt; n) {
      j = mid;
      if (i == j) {
        r = mid - 1;
      }
    }
    else {
      i = mid + 1;
      if (i == j) {
        r = mid;
      }
    }
  }
  return r;
}

inline bool is_prime(int n) {
  return n &lt; 2 ? false : primes[index_of_prime(n)] == n;
}

bool backtrack(int n, int q, vector&lt;int&gt; & a) {
  int r = false;
  if (q == 1) {
    if (is_prime(n)) {
      a.push_back(n);
      r = true;
    }
  }
  else {
    int i = index_of_prime(n);
    q--;
    for (; i &gt;= 0; i--) {
      if (backtrack(n - primes[i], q, a)) {
        a.push_back(primes[i]);
        r = true;
        break;
      }
    }
  }
  return r;
}

inline bool four_primes(int n, vector&lt;int&gt; & a) {
  if (n &lt; 8)
    return false;
  return backtrack(n, 4, a);
}

int main() {
  init();
  int n;
  while (cin &gt;&gt; n) {
    vector&lt;int&gt; a;
    if (four_primes(n, a)) {
      for (int i = 0; i &lt; 4; i++) {
        if (i)
          cout &lt;&lt; ' ';
        cout &lt;&lt; a[i];
      }
      cout &lt;&lt; endl;
    }
    else {
      cout &lt;&lt; "Impossible." &lt;&lt; endl;
    }
  }
  return 0;
}
</pre>

需要说明的是：Programming Challenge网站表示此题尚无法正确判定答案，而UVa判以上解WA。但笔者对8到10000000的每一个整数都做了测试，结果表明笔者的解法是正确无误的。测试程序在<a href="https://code.google.com/p/programming-challenges-robert/source/browse/ch7_ex5_test.rb" target="_blank">这里</a>。

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_45">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F22%2Fsummation-of-four-primes%2F&linkname=Summation%20of%20Four%20Primes" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F22%2Fsummation-of-four-primes%2F&linkname=Summation%20of%20Four%20Primes" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F22%2Fsummation-of-four-primes%2F&linkname=Summation%20of%20Four%20Primes" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F22%2Fsummation-of-four-primes%2F&linkname=Summation%20of%20Four%20Primes" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>