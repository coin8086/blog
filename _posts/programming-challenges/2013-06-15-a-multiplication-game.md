---
title: A Multiplication Game
date: 2013-06-15T19:40:57+00:00
layout: post
category_sticky_post:
  - "0"
tags: algorithm
categories:
  - 编程挑战
---
PC/UVa IDs: 110505/<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=788" target="_blank">847</a>

分析：如果n<10,则Stan一步即可轻松获胜；当n>=10时，假设Stan能获胜，那么Ollie的最后一次乘积必须在[ceil(n/9), n)之间。设：
  
lower = ceil(n/9), upper = n
  
又设在此之前Stan的乘积是p，则Stan必须保证：
  
upper > x * p >= lower
  
其中x=2,3,&#8230;,9。即：
  
ceil(upper / x) > p >= ceil(lower / x)<!--more-->


  
取上式右边最大最小值及左边最小最大值，即：
  
ceil(upper / 9) > p >= ceil(lower / 2)
  
可保证x * p的值对**任意x**必在upper和lower之间。设：
  
upper = ceil(upper / 9), lower = ceil(lower / 2)
  
接下来该Ollie做乘法，**只要存在x**使得：
  
upper > x * p >= lower
  
其中p为Ollie的乘积，upper和lower为刚刚更新的upper和lower值，则Stan可以获胜，即：
  
9 \* p >= lower, 2 \* p < upper
  
即：
  
ceil(upper / 2) > p >= ceil(lower / 9)
  
重复以上过程，直到某次Stan的乘积下界lower不超过9为止。此时若
  
9 >= lower >= 2
  
则Stan有必胜策略，否则Ollie必胜。

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;cmath&gt;

using namespace std;

bool stan_win(unsigned int n) {
  bool stan = true;
  if (n &gt; 9) {
    //To ensure Stan's success, Ollie's multiplication result must be in
    //[lower, upper).
    unsigned int upper = n;
    unsigned int lower = ceil(n / 9.0);
    stan = !stan; //Indicate the current range is not Stan's.
    while (true) {
      if (stan && lower &lt;= 9) {
        if (!(lower &gt;= 2 && upper &gt; lower))
          stan = false;
        break;
      }
      stan = !stan;
      if (stan) {
        //Stan must ensure no matter which number(x) Ollie chooses, x * p
        //is in desired range. p is Stan's multiplication result.
        upper = ceil(upper / 9.0);
        lower = ceil(lower / 2.0);
      }
      else {
        //Stan must ensure there is a number(x) so that x * p is in desired
        //range. p is Ollie's multiplication result.
        upper = ceil(upper / 2.0);
        lower = ceil(lower / 9.0);
      }
    }
  }
  return stan;
}

int main() {
  unsigned int n;
  while (cin &gt;&gt; n) {
    cout &lt;&lt; (stan_win(n) ? "Stan wins." : "Ollie wins.") &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_36">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fa-multiplication-game%2F&linkname=A%20Multiplication%20Game" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fa-multiplication-game%2F&linkname=A%20Multiplication%20Game" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fa-multiplication-game%2F&linkname=A%20Multiplication%20Game" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F06%2F15%2Fa-multiplication-game%2F&linkname=A%20Multiplication%20Game" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>