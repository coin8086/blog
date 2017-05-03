---
title: How Many Pieces of Land?
date: 2013-06-17T19:09:55+00:00
layout: post
excerpt_separator: <!--more-->
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110602/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1154" target="_blank">10213</a>

分析：<a href="http://baike.baidu.cn/view/1289941.htm" target="_blank">《具体数学》</a>第一章有个类似的问题：n条直线最多可以把一个平面分成多少块？如果n条直线把平面分成了m块，那么再加一条直线最多新增n个交点，这n个交点把新的直线分成了n+1段，每一段都把原来的一块区域分成了2块，也就是说新增了n+1块区域。由此有递推公式：
  
f(n) = f(n &#8211; 1) + n
  
但是本题的不同之处在于：虽然椭圆圆周上的n个点最多能产生n(n &#8211; 1)/2条直线，但这些数量的直线并不能产生最多数量的交点，因此不可以套用上面的公式。但我们仍能得到两个关键的启示： <!--more-->


  
１分块数量与线段有关，线段由交点产生
  
２递推解题
  
算法的思想需要借助一些图示，这个<a href="http://en.wikipedia.org/wiki/Dividing_a_circle_into_areas" target="_blank">Wiki</a>说得比较清楚了。可惜的是，本题用递推的方法解会超时！从递推式又很难推导出封闭形式！不过上面提到的Wiki里还记录了一种使用欧拉公式的拓扑方法，形式比较简单，应用这种方式解就可以AC。但笔者以为，贴出递推式的解法也是有意义的——起码笔者很难想到欧拉公式！

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;

using namespace std;

typedef long long llt;

vector&lt;llt&gt; pieces;

inline void init() {
  pieces.reserve(3000);
  pieces.push_back(1);
  pieces.push_back(1);
  pieces.push_back(2);
}

/*
  D(N, i) is the increased pieces of land by introducing one edge
  from a newly added point to one of the existed N points. i is the
  number of the existed point, ranging in [0, N - 1]. Point 0 is the 
  point that is immediately adjacent to the newly added point. Point
  1 is immediately adjacent to point 0, and point i to point i - 1.
  The last point, N - 1, is also immediately adjacent to the newly 
  added point.
  llt D(int N, int i) {
    return (llt)i * (N - i - 1) + 1;
  }
  S(N, n) is the Sum of D(N, i), taking all i in [0, n].
*/
inline llt S(llt N, llt n) {
  return (N - 1) * (1 + n) * n / 2 - n * (n + 1) * (n * 2 + 1) / 6 + n + 1;
}

void compute(int n) {
  for (int i = pieces.size(); i &lt;= n; i++) {
    llt last = pieces[i - 1];
    llt inc = S(i - 1, i - 2);
    last += inc;
    pieces.push_back(last);
  }
}

inline llt how_many_pieces(int n) {
  if (n &gt;= pieces.size())
    compute(n);
  return pieces[n];
}

int main() {
  init();
  int s;
  cin &gt;&gt; s;
  for (int i = 0; i &lt; s; i++) {
    int n;
    cin &gt;&gt; n;
    cout &lt;&lt; how_many_pieces(n) &lt;&lt; endl;
  }
  return 0;
}
</pre>

