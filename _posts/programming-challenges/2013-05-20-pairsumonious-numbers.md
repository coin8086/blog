---
id: 473
title: Pairsumonious Numbers
date: 2013-05-20T00:54:46+00:00
author: Robert
layout: post
guid: http://kuangtong.net/?p=131
permalink: /2013/05/20/pairsumonious-numbers/
categories:
  - 编程挑战
---
<a href="http://uva.onlinejudge.org/index.php?option=com_onlinejudge&#038;Itemid=8&#038;page=show_problem&#038;problem=1143" target="_blank">题目描述</a>

分析：设有n个整数a1,a2,&#8230;,an，已知两两整数的和，则：
  
(a1 + a2) + &#8230; + (a1 + an) + (a2 + a3) + &#8230; + (a2 + an) + &#8230; + (an-1 + an) = (n &#8211; 1)S
  
其中S即a1 + a2 + &#8230; + an的总和。
  
现假设已知a1与其它n-1个数的和分别为s1, s2,&#8230;,s(n-1)，则：
  
s1 + s2 + &#8230; + s(n-1) = (a1 + a2) + (a1 + a3) + &#8230; + (a1 + an) = (n &#8211; 2)a1 + S<!--more-->


  
通过S，从上式可得a1，以及a2, a3, &#8230;, an。但问题是哪些和是包含a1的s1,s2,&#8230;？这需要我们不断地尝试，即：从n(n-1)/2个和中选出n-1个和，计算a1&#8230;an以及两两和，然后用计算得出的两两和与给出的和相比较，如相同则正解；若尝试了所有的组合都没有成功，则无解。算法利用回溯来枚举出所有可能的组合、找出一个可能的解：

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;iostream&gt;
#include &lt;vector&gt;
#include &lt;algorithm&gt;

using namespace std;

typedef long long llt;

class Resolver {
public:
  Resolver(int n, const vector&lt;llt&gt; & sums) : _n(n), _total(0), _sums(sums) {}

  bool prepare() {
    for (int i = 0; i &lt; _sums.size(); i++) {
      _total += _sums[i];
    }
    if (_total % (_n - 1)) {
      return false;
    }
    _total /= (_n - 1);
    sort(_sums.begin(), _sums.end());
    return true;
  }

  bool operator()(const vector&lt;int&gt; & selected) {
    //compute each number
    vector&lt;llt&gt; partial;
    llt partial_total = 0;
    int i;
    for (i = 0; i &lt; selected.size(); i++) {
      llt sum = _sums[selected[i]];
      partial.push_back(sum);
      partial_total += sum;
    }
    if ((partial_total - _total) % (_n - 2))
      return false;
    llt a = (partial_total - _total) / (_n - 2);
    _numbers.clear();
    _numbers.push_back(a);
    for (i = 0; i &lt; partial.size(); i++) {
      _numbers.push_back(partial[i] - a);
    }
    //validate
    vector&lt;llt&gt; sums;
    for (i = 0; i &lt; _numbers.size(); i++) {
      for (int j = i + 1; j &lt; _numbers.size(); j++) {
        sums.push_back(_numbers[i] + _numbers[j]);
      }
    }
    sort(sums.begin(), sums.end());
    return sums == _sums;
  }

  void get_result(vector&lt;llt&gt; & r) {
    sort(_numbers.begin(), _numbers.end());
    r.swap(_numbers);
  }

private:
  int _n;
  llt _total;
  vector&lt;llt&gt; _sums;
  vector&lt;llt&gt; _numbers;
};

//typedef bool (* Success)(const vector&lt;int&gt; & selected);

template&lt;typename Success&gt;
bool combine(int total, int wanted, vector&lt;int&gt; & selected, Success & success)
{
  if (selected.size() == wanted) {
    return success(selected);
  }
  else {
    int idx = selected.size() ? selected.back() + 1 : 0;
    for (int i = idx; i &lt; total; i++) {
      selected.push_back(i);
      if (combine(total, wanted, selected, success))
        return true;
      selected.pop_back();
    }
  }
  return false;
}

bool solve(int n, const vector&lt;llt&gt; & sums, vector&lt;llt&gt; & r) {
  Resolver resolver(n, sums);
  if (!resolver.prepare()) {
    return false;
  }
  vector&lt;int&gt; selected;
  bool ret = combine(sums.size(), n - 1, selected, resolver);
  if (ret) {
    resolver.get_result(r);
  }
  return ret;
}

int main() {
  while (true) {
    int n;
    if (!(cin &gt;&gt; n))
      break;
    int m = n * (n - 1) / 2;
    vector&lt;llt&gt; input;
    llt s;
    for (int i = 0; i &lt; m; i++) {
      cin &gt;&gt; s;
      input.push_back(s);
    }
    vector&lt;llt&gt; r;
    if (solve(n, input, r)) {
      for (int i = 0; i &lt; r.size(); i++) {
        if (i)
          cout &lt;&lt; ' ';
        cout &lt;&lt; r[i];
      }
    }
    else {
      cout &lt;&lt; "Impossible";
    }
    cout &lt;&lt; endl;
  }
  return 0;
}
</pre>

<div class="addtoany_share_save_container addtoany_content_bottom">
  <div class="a2a_kit a2a_kit_size_32 addtoany_list a2a_target" id="wpa2a_18">
    <a class="a2a_button_facebook" href="http://www.addtoany.com/add_to/facebook?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F20%2Fpairsumonious-numbers%2F&linkname=Pairsumonious%20Numbers" title="Facebook" rel="nofollow" target="_blank"></a><a class="a2a_button_twitter" href="http://www.addtoany.com/add_to/twitter?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F20%2Fpairsumonious-numbers%2F&linkname=Pairsumonious%20Numbers" title="Twitter" rel="nofollow" target="_blank"></a><a class="a2a_button_google_plus" href="http://www.addtoany.com/add_to/google_plus?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F20%2Fpairsumonious-numbers%2F&linkname=Pairsumonious%20Numbers" title="Google+" rel="nofollow" target="_blank"></a><a class="a2a_button_sina_weibo" href="http://www.addtoany.com/add_to/sina_weibo?linkurl=http%3A%2F%2Fkuangtong.me%2F2013%2F05%2F20%2Fpairsumonious-numbers%2F&linkname=Pairsumonious%20Numbers" title="Sina Weibo" rel="nofollow" target="_blank"></a><a class="a2a_dd addtoany_share_save" href="https://www.addtoany.com/share_save"></a>
  </div>
</div>