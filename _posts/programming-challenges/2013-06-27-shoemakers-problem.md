---
title: Shoemaker’s Problem
date: 2013-06-27T12:55:13+00:00
layout: post
categories:
  - 编程挑战
---
PC/UVa IDs: 110405/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=967" target="_blank">10026</a>

分析：先来看一个简单情况，当只有两个订单o1(t1, s1)和o2(t2, s2)时，罚金最小的处理顺序应该是怎样的：
  
先o1再o2，罚金为t1 * s2
  
先o2再o1，罚金为t2 * s1
  
比较t1 \* s2与t2 \* s1的值，选取较小值对应的顺序。<!--more-->


  
如果再加一个订单o3(t3, s3)呢？或者再推广一下：如果已经有n个订单，得到了一个罚金最小的排序，那么怎么安排一个新订单，使得总的罚金最小？我们假设已经有n个订单按照**某种顺序**排好序，设S(n)为前n个订单产生的罚金总和，T(n)为生产前n个订单所需的总时间，s(n)和t(n)分别为第n个订单单日的罚金数和生产天数，如果我们把新的订单放在最后处理，则：
  
S(n + 1) = S(n &#8211; 1) + T(n &#8211; 1) \* s(n) + (T(n &#8211; 1) + t(n)) \* s(n &#8211; 1) **(a)**
  
如果我们把新订单插到原来的最后一个订单之前处理，则：
  
S(n + 1) = S(n &#8211; 1) + T(n &#8211; 1) \* s(n + 1) + (T(n &#8211; 1) + t(n + 1)) \* S(n) **(b)**
  
**(a)(b)**两式相减，得到：
  
(a) &#8211; (b) = t(n) \* s(n + 1) &#8211; t(n + 1) \* s(n) **(c)**
  
**(c)**式告诉我们**(d)**：只要 (c) <= 0 成立，订单n就应该排在订单n + 1前面，反之订单n + 1就排在订单n前面，**不论前n &#8211; 1个订单是如何排列的**。
  
可以证明**(e)**：如果在一个订单排列中，有**相邻两项**Oi和Oj，若ti * sj <= tj * si，则排列
  
O1, O2, ..., Oi, Oj, ..., On
  
产生的罚金一定不大于排列
  
O1, O2, ..., Oj, Oi, ..., On
  
产生的罚金。
  
进一步我们可以证明**(f)**：在罚金最小的订单排列里，**任意两项**Oi和Oj，若Oi排在Oj前，必有ti * sj <= tj * si，反之亦成立（相等时Oi和Oj可以互换而不影响罚金数，但由于我们按字典序输出唯一的排列，所以实际上不会有等于的情况）。
  
由结论**(d)**我们可以用插入排序，结论**(e)**可以用冒泡排序，结论**(f)**则可以使我们用任何排序算法给订单排序而不失正确性。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

using namespace std;

class Order {
public:
  Order(int i, int t, int s) : _i(i), _t(t), _s(s) {}

  bool operator &lt;(const Order & o) const {
    int m1 = _t * o._s;
    int m2 = o._t * _s;
    return m1 &lt; m2 ? true : (m1 == m2 ? _i &lt; o._i : false);
  }

  int idx() const { return _i; }

  static bool cmp(const Order * p1, const Order * p2) {
    return *p1 &lt; *p2;
  }

private:
  int _i;
  int _t;
  int _s;
};

int main() {
  int N = 0;
  cin &gt;&gt; N;
  for (int i = 0; i &lt; N; i++) {
    int n;
    cin &gt;&gt; n;
    vector&lt;Order&gt; orders;
    vector&lt;Order *&gt; p;
    orders.reserve(n);
    p.reserve(n);
    for (int j = 1; j &lt;= n; j++) {
      int t, s;
      cin &gt;&gt; t &gt;&gt; s;
      orders.push_back(Order(j, t, s));
      p.push_back(&orders.back());
    }
    sort(p.begin(), p.end(), Order::cmp);
    if (i)
      cout &lt;&lt; endl;
    for (int k = 0; k &lt; n; k++) {
      if (k)
        cout &lt;&lt; ' ';
      cout &lt;&lt; p[k]-&gt;idx();
    }
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_50">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Fshoemakers-problem%2F&linkname=Shoemaker%E2%80%99s%20Problem" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Fshoemakers-problem%2F&linkname=Shoemaker%E2%80%99s%20Problem" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Fshoemakers-problem%2F&linkname=Shoemaker%E2%80%99s%20Problem" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F27%2Fshoemakers-problem%2F&linkname=Shoemaker%E2%80%99s%20Problem" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>