---
title: Distinct Subsequences
date: 2013-07-01T17:52:20+00:00
layout: post
excerpt_separator: <!--more-->
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 111102/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1010" target="_blank">10069</a>

分析：先考虑一个例子：
  
x=babgbag z=bag
  
答案是5，如何数数？
  
假设函数times(x, z)返回z在x中的次数（z可以是字符串也可以是字符——后者相当容易处理），容易得到递归解（伪代码）：<!--more-->

<pre class="brush: cpp; title: ; notranslate" title="">times(x, z) {
  if z.size == 1
    return times(x, z[0]) //寻找字符z[0]在串x中出现的次数
  s = 0
  for i = 0; i &lt; x.size; i++
    if x[i] == z[0]
      //s[i, j]表示s从索引i开始到j结束（包括j在内）的子串，索引-1的位置指向串的最后一个字符
      s += times(x[i + 1, -1], z[1, -1]) 
  return s
}
</pre>

以上代码在每次递归之前都要生成两个新的子串，在此我们做一点优化：如果我们从串的尾部向前处理，则可以仅用子串的长度值来表示子串。由此得到

<pre class="brush: cpp; title: ; notranslate" title="">times(x, z, i, j) { //i,j分别为x,z从0开始的子串长度
  if j == 1
    return times(x, i, z[0]) //寻找字符z[0]在串x子串中出现的次数
  s = 0
  for k = i - 1; k &gt;= 0; k--
    if x[k] == z[j - 1]
      s += times(x, z, k, j - 1) 
  return s
}
</pre>

如果我们以一个二维表格T来表示times计算的结果，则T\[i\]\[j\]就是我们想要的答案，而且我们现在已经有了递推公式：

<pre class="brush: cpp; title: ; notranslate" title="">T[i][j] = {
  s = 0
  for k = i - 1; k &gt;= 0; k--
    if x[k] == z[j - 1]
      s += T[k][j - 1]
  return s
}
</pre>

和初始值：
  
T\[i\]\[1\] = times(x, i, z[0])
  
以及：
  
T\[i\]\[j\] = 0 when i == 0 || j == 0 || i < j
  
但是在我们着手计算之前，结合表格仔细考虑一下递推公式，还可以消除一些重复计算：

<pre class="brush: cpp; title: ; notranslate" title="">T[i][j] = {
  s = T[i - 1][j]
  if z[j - 1] == x[i - 1]
    s += T[i - 1][j - 1]
  return s
}
</pre>

现在足够简单了。不过还有最后一个问题：因为x、z的长度最长分别可达10000和100，所以最多可以有C(10000, 100)种组合方法（10000个数里选出100个），这是一个天文数字，必须用大数运算。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;string&gt;
#include &lt;vector&gt;
#include "bigint.h"

using namespace std;

BigInt times(const string & x, const string & z) {
  if (x.empty() || z.empty() || x.size() &lt; z.size()) {
    return BigInt();
  }
  int rows = x.size() + 1;
  int cols = z.size() + 1;
  vector&lt;vector&lt;BigInt&gt; &gt; T(rows, vector&lt;BigInt&gt;(cols));
  int i, j;
  int c = 0;
  char ch = z[0];
  for (i = 0; i &lt; x.size(); i++) {
    if (x[i] == ch)
      c++;
    T[i + 1][1] = c;
  }
  for (i = 2; i &lt; rows; i++) {
    for (j = 2; j &lt; cols && j &lt;= i; j++) {
      BigInt s = T[i - 1][j];
      if (z[j - 1] == x[i - 1]) {
        s += T[i - 1][j - 1];
      }
      T[i][j] = s;
    }
  }
  return T[x.size()][z.size()];
}

int main() {
  int N = 0;
  cin &gt;&gt; N;
  cin.ignore();
  for (int i = 0; i &lt; N; i++) {
    string x, z;
    cin &gt;&gt; x &gt;&gt; z;
    cout &lt;&lt; times(x, z) &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_53">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F07%2F01%2Fdistinct-subsequences%2F&linkname=Distinct%20Subsequences" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F07%2F01%2Fdistinct-subsequences%2F&linkname=Distinct%20Subsequences" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F07%2F01%2Fdistinct-subsequences%2F&linkname=Distinct%20Subsequences" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F07%2F01%2Fdistinct-subsequences%2F&linkname=Distinct%20Subsequences" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>