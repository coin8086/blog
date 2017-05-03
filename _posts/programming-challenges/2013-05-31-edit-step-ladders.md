---
title: Edit Step Ladders
date: 2013-05-31T22:18:50+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110905/10029 <a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=970" target="_blank">题目描述</a>

分析：按字典序排列的n个单词构成了一个隐式的有向无环图：每个单词单词都有一条出边指向在它字典序之后的每一个单词。要在这张图里找出符合条件的最长路径包含的顶点数。简单的想法就是“暴力”回溯了：对每个顶点进行一次回溯，找出以该点开始的最长的edit step ladder——这个时间复杂度高得能上了火星！思考一下就会发现，回溯包含了大量的重复计算：假设以单词w开始的最长ladder长度为l，那么对于字典中排在w之前的每一个单词（实际上是edit step为1的那些单词），在回溯经过w时都要做同样的重复计算，浪费了大量时间。如果我们计算好了以w开始的最长ladder的长度l，那么对于w的每一个one edit step前驱顶点，其最长ladder长度即为l+1。<!--more-->想到这里，我们可以从字典最后一个单词开始向前，计算每一个单词的最长ladder长度并保存，如下：


  
（需要注意的是：虽然算法的时间复杂度是O(n^2)，但若不考虑优化系数，仍然会在UVa里超时。为此以下算法把已计算过的单词按长度分组以减少比较次数，降低时间复杂度系数）

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;map&gt;
#include &lt;string&gt;

using namespace std;

typedef vector&lt;string&gt; Dict;
typedef map&lt;string, int&gt; LadderLen;

//p1 and p2 must have the same length.
inline bool equal(const char * p1, const char * p2) {
  for (; *p1 && *p1 == *p2; p1++, p2++);
  return !*p1;
}

//w1 and w2 must be different and not empty!
bool one_step(const string & w1, const string & w2) {
  bool r = false;
  int d = w1.size() - w2.size();
  const char * p1 = w1.c_str();
  const char * p2 = w2.c_str();
  if (!d) {
    while (*p1++ == *p2++);
    if (!*p1)
      r = true;
    else
      r = equal(p1, p2);
  }
  else {
    while (*p1++ == *p2++);
    if (d &gt; 0)
      r = equal(p1, --p2);
    else
      r = equal(p2, --p1);
  }
  return r;
}

inline void search(const string & w, const Dict & d, LadderLen & len, int & max) {
  for (int j = 0; j &lt; d.size(); j++) {
    const string & w2 = d[j];
    if (one_step(w, w2) && len[w2] &gt; max) {
      max = len[w2];
    }
  }
}

int ladder(const Dict & d) {
  LadderLen len;
  vector&lt;Dict&gt; d2(17);
  int r = 0;
  for (int i = d.size() - 1; i &gt; 0; i--) {
    const string & w = d[i];
    int max = -1;
    search(w, d2[w.size()], len, max);
    if (w.size() &lt; 16)
      search(w, d2[w.size() + 1], len, max);
    if (w.size() &gt; 1)
      search(w, d2[w.size() - 1], len, max);
    d2[w.size()].push_back(w);
    len[w] = ++max;
    if (max &gt; r)
      r = max;
  }
  return r + 1;
}

int main() {
  Dict d(1); //The first word is just a place holder
  string w;
  while (cin &gt;&gt; w) {
    d.push_back(w);
  }
  cout &lt;&lt; ladder(d) &lt;&lt; endl;
  return 0;
}
</pre>

结语：其实，所谓的动态规划，很像回溯的逆过程：前者从“前”往后递增计算，后者从“后”往前递减计算。只不过前者还记录了一些计算的中间结果以避免重复计算（其实后者也可以，但考虑到栈的深度，一些情况下回溯并不合适）。

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_26">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F31%2Fedit-step-ladders%2F&linkname=Edit%20Step%20Ladders" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F31%2Fedit-step-ladders%2F&linkname=Edit%20Step%20Ladders" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F31%2Fedit-step-ladders%2F&linkname=Edit%20Step%20Ladders" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F31%2Fedit-step-ladders%2F&linkname=Edit%20Step%20Ladders" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>