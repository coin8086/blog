---
id: 492
title: The Stern-Brocot Number System
date: 2013-06-15T21:27:54+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=289
permalink: /2013/06/15/the-stern-brocot-number-system/
category_sticky_post:
  - "0"
categories:
  - 编程挑战
---
PC/UVa IDs: 110507/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1018" target="_blank">10077</a>

分析：Stern-Brocot树的每个节点（包括根节点）都是由两个分数生成的，分别记其为left, right。生成规则为：
  
mid.numerator = left.numerator + right.numerator
  
mid.denominator = left.denominator + right.denominator
  
且有：
  
left < mid < right <!--more-->


  
根据规则，一边生成节点一边二分查找即可。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

typedef long long llt;

class Fraction {
public:
  Fraction(unsigned int a, unsigned int b) : _n(a), _d(b) {}

  Fraction(const Fraction & f) : _n(f._n), _d(f._d) {}

  Fraction & operator =(const Fraction & f) {
    _n = f._n;
    _d = f._d;
    return *this;
  }

  bool operator &lt;(const Fraction & f) const {
    return (llt)_n * f._d - (llt)_d * f._n &lt; 0;
  }

  bool operator !=(const Fraction & f) const {
    return !(_n == f._n && _d == f._d);
  }

  Fraction middle(const Fraction & f) const {
    return Fraction(_n + f._n, _d + f._d);
  }

private:
  unsigned int _n; //numerator
  unsigned int _d; //denominator
};

vector&lt;char&gt; stern_brocot_path(const Fraction & f) {
  vector&lt;char&gt; path;
  Fraction mid(1, 1);
  Fraction left(0, 1);
  Fraction right(1, 0);
  while (f != mid) {
    if (f &lt; mid) {
      right = mid;
      mid = mid.middle(left);
      path.push_back('L');
    }
    else {
      left = mid;
      mid = mid.middle(right);
      path.push_back('R');
    }
  }
  return path;
}

int main() {
  unsigned int a, b;
  while ((cin &gt;&gt; a &gt;&gt; b) && !(a == 1 && b == 1)) {
    vector&lt;char&gt; path = stern_brocot_path(Fraction(a, b));
    for (int i = 0; i &lt; path.size(); i++)
      cout &lt;&lt; path[i];
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_37">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-stern-brocot-number-system%2F&linkname=The%20Stern-Brocot%20Number%20System" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-stern-brocot-number-system%2F&linkname=The%20Stern-Brocot%20Number%20System" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-stern-brocot-number-system%2F&linkname=The%20Stern-Brocot%20Number%20System" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fthe-stern-brocot-number-system%2F&linkname=The%20Stern-Brocot%20Number%20System" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>