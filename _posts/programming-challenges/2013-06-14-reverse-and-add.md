---
id: 490
title: Reverse and Add
date: 2013-06-14T14:22:10+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=280
permalink: /2013/06/14/reverse-and-add/
category_sticky_post:
  - "0"
categories:
  - 编程挑战
---
PC/UVa IDs: 110502/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=959" target="_blank">10018</a>
  
<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

#define MAX_SIZE 10

using namespace std;

typedef long long llt;

typedef vector&lt;char&gt; BigInt;

ostream & operator &lt;&lt;(ostream & os, const BigInt & n) {
  for (int i = n.size() - 1; i &gt;= 0; i--)
    os &lt;&lt; (char)('0' + n[i]);
  return os;
}

inline BigInt to_bigint(llt n) {
  BigInt v;
  if (n) {
    v.reserve(MAX_SIZE);
    while (n) {
      v.push_back(n % 10);
      n /= 10;
    }
  }
  else {
    v.push_back(0);
  }
  return v;
}

inline bool done(const BigInt & bn) {
  bool ok = true;
  int h = bn.size() / 2;
  for (int i = 0; i &lt; h; i++) {
    if (bn[i] != bn[bn.size() - i - 1]) {
      ok = false;
      break;
    }
  }
  return ok;
}

inline void add(BigInt & bn, const BigInt & br) {
  int carry = 0;
  for (int i = 0; i &lt; bn.size(); i++) {
    int s = bn[i] + br[i] + carry;
    if (s &gt; 9) {
      carry = 1;
      s %= 10;
    }
    else {
      carry = 0;
    }
    bn[i] = s;
  }
  if (carry)
    bn.push_back(1);
}

int reverse_add(llt n, BigInt & bn) {
  int c = 0;
  bn = to_bigint(n);
  while (!done(bn)) {
    c++;
    BigInt br(bn.rbegin(), bn.rend());
    add(bn, br);
  }
  return c;
}

int main() {
  int n = 0;
  cin &gt;&gt; n;
  for (int i = 0; i &lt; n; i++) {
    llt p;
    cin &gt;&gt; p;
    BigInt bn;
    int t = reverse_add(p, bn);
    cout &lt;&lt; t &lt;&lt; ' ' &lt;&lt; bn &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_34">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Freverse-and-add%2F&linkname=Reverse%20and%20Add" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Freverse-and-add%2F&linkname=Reverse%20and%20Add" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Freverse-and-add%2F&linkname=Reverse%20and%20Add" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F14%2Freverse-and-add%2F&linkname=Reverse%20and%20Add" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>